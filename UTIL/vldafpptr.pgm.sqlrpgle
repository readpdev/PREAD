      *%METADATA                                                       *
      * %TEXT Print Rpt for AFPs with Null Page Table Entries          *
      *%EMETADATA                                                      *
     h dftactgrp(*no)
      *
      * 08-18-11 PLR Created. Utility to identify AFP reports having NULL
      *              null pointer values for page table records in AP* files.
      *
      * Read through all folder files having an AFP file ('A' file) specified.
      * Locate the associated AP file, read in the first record for each report
      * and see if the first page table record is all zeros (null). If it is,
      * print a report identifying the report id and folder where the
      * condition was encountered.
      *
     fqsysprt   o    f   80        printer usropn oflind(*in01)

     d system          pr                  extproc('system')
     d  cmd                            *   value options(*string)

     d sqlStmt         s            256
     d apfnam          s             10
     d fldcod          s             10
     d apFile        e ds                  extname(RAPFDBFP)
     d pgTableDS       ds           378
     d  apgTblA                       6    dim(63)
     d  apgTblLastByt                 1    overlay(apgTblA:6)
     d SQ              c                   ''''
     d writeOut        s             80
     d afpFldCnt       s             10i 0
     d apFileCnt       s             10i 0
     d pointersInErr   s             10i 0
     d adsf            s             10i 0
     d rpttyp          s             10
     d i               s             10i 0

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;

       // Override and open print file.
       system('ovrprtf qsysprt splfname(vldafpptr)' +
         ' pagesize(*n 80)');
       open qsysprt;
       system('dltovr prtafpnpt');
       except header;
       *in01 = *off;

       sqlStmt = 'select fldcod,apfnam from mflddir where ' +
         'apfnam <> ' + SQ + ' ' + SQ;

       exec sql prepare stmt from :sqlStmt;
       exec sql declare folderCursor cursor for stmt;
       exec sql open folderCursor;

       if sqlcod <> 0;
         writeOut = 'Error opening folder directory';
         except detail;
       endif;

       exec sql fetch next from folderCursor into :fldcod, :apfnam;
       if sqlcod = 100;
         writeOut = 'No folder directory records with AFP data found.';
         except detail;
       endif;

       dow sqlcod = 0;
         afpFldCnt += 1;
         // Change the 'A' file name prefix to 'AP' and fetch all of the
         // first page table records (sequence number 1).
         %subst(apfnam:2:1) = 'P';
         system('ovrdbf RAPFDBFP ' + apfnam + ' ovrscope(*job)');
         exec sql declare afpCursor cursor for
           select * from RAPFDBFP;
         exec sql open afpCursor;
         exec sql fetch next from afpCursor into :apFile;
         select;
           when sqlcod = 100;
             writeOut = 'No page table records found in ' + apfnam;
           when sqlcod <> 0;
             writeOut = 'Error occurred processing ' + apfnam;
             except detail;
             writeOut = 'SQL code = ' + %trim(%char(sqlcod));
             except detail;
         endsl;
         dow sqlcod = 0;
           apFileCnt += 1;
           pgTableDS = apgtbl;
           for i = 1 to 63;
             if apgTblLastByt(i) = x'00';
               if *in01;
                 except header;
                 *in01 = *off;
               endif;
               pointersInErr += 1;
               exec sql select adsf,rpttyp into :adsf,:rpttyp from mrptdir where
                 repind = :apgrep;
               writeOut = fldcod + '  ' + apfnam + '  ' + apgrep + '  ' +
                 rpttyp + '  ' + %char(adsf);
               except detail;
               leave;
             endif;
           endfor;
           exec sql fetch next from afpCursor into :apfile;
         enddo;
         exec sql close afpCursor;
         system('dltovr rapfdbfp lvl(*job)');

         exec sql fetch next from folderCursor into :fldcod, :apfnam;
       enddo;

       exec sql close folderCursor;

       except blankLine;

       writeOut = 'AFP Folders Found:   ' + %editc(afpFldCnt:'3');
       except detail;
       writeOut = 'Pointer Files Found: ' + %editc(apFileCnt:'3');
       except detail;
       writeOut = 'Pointer Error Count: ' + %editc(pointersInErr:'3');
       except detail;

       writeOut = '**End of Report**';
       except trailer;

       close qsysprt;

       *inlr = '1';
       return;

      /end-free
     oqsysprt   e            header         1  1
     o                                           49 'Validate AFP Page Pointers'
     o                                           75 'Page'
     o                       page          z     80
     o          e            header      1  1
     o                                              'Folder      '
     o                                              'Page Table  '
     o                                              'Document ID '
     o                                              'Report Type '
     o                                              'Achived Date'
     o          e            header         2
     o                                              '----------  '
     o                                              '----------  '
     o                                              '----------- '
     o                                              '----------- '
     o                                              '------------'
     o          e            detail         1
     o                       writeOut
     o          e            blankLine      1
     o                                              ' '
     o          e            trailer     1
     o                       writeOut

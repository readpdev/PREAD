      *%METADATA                                                       *
      * %TEXT Fix AFPs with Null Page Table Entries                    *
      *%EMETADATA                                                      *
     h dftactgrp(*no)
      *
J3729 * 09-26-11 PLR Copy and modified version of PRTAFPNPT. This will restore
      *              all reports detected with having an invalid first
      *              page table record (nulls), point the report directory
      *              records back offline from a backup copy of MRPTDIR in
      *              another library (very custom for Interface Americas),
      *              delete any records in the online AP file matching the
      *              report id (spy#), run the restore operation with the fixed
      *              MAG1091 correcting the page table pointers.
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

     d rstRpt          pr                  extpgm('RSTRPTCL')
     d  folder                       10    const
     d  folderLib                    10    const
     d  reportName                   10    const
     d  jobName                      10    const
     d  userName                     10    const
     d  jobNumber                     6    const
     d  spoolDate                     7    const
     d  fileNumber                   10i 0 const
     d  fileDesc                     40    const                                Not used.
     d  changeAct                     1    const                                Not used.
     d  returnVal                     1
     d rtnOrpt         s              1

     d rptKeys         ds
     d  rk_fld                       10
     d  rk_fldLib                    10
     d  rk_rptName                   10
     d  rk_jobName                   10
     d  rk_userName                  10
     d  rk_jobNbr                     6
     d  rk_splDate                    7
     d  rk_filNbr                    10i 0

     d sqlStmt         s            256
     d apfnam          s             10
     d fldcod          s             10
     d apFile        e ds                  extname(RAPFDBFP)
     d pgTableDS       ds           378
     d  apgTblA                       6    dim(63)
     d  apgTblLastByt                 1    overlay(apgTblA:6)
     d SQ              c                   ''''
     d writeOut        s             80
     d afpFldCnt       s             10i 0 inz
     d apFileCnt       s             10i 0 inz
     d pointersInErr   s             10i 0 inz
     d rptsRestored    s             10i 0 inz
     d adsf            s             10i 0 inz
     d rpttyp          s             10

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;

       // Override and open print file.
       system('ovrprtf qsysprt splfname(fixafpnpt)' +
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
           select * from RAPFDBFP where apgseq = 1;
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
           other;
             apFileCnt += 1;
         endsl;
         dow sqlcod = 0;
           pgTableDS = apgtbl;
           if apgTblLastByt(1) = x'00';
             pointersInErr += 1;
             // Point the report back to offline storage by replacing the
             // current rptdir record with a back up verion that points
             // offline.
             exec sql delete from mrptdir where repind = :apgrep;
             if sqlcod <> 0;
               writeOut = 'Error deleting rptdir record for ' + apgrep;
             endif;
             // Restore the report from backup file to current MRPTDIR.
             if sqlcod = 0;
               exec sql INSERT into mrptdir select * from
                 knthn/mrptdirapr WHERE REPIND = :apgrep;
               if sqlcod <> 0;
                 writeOut = 'Error restoring backup copy of ' + apgrep;
               endif;
             endif;
             // Delete any online AP file records to avoid restore error.
             if sqlcod = 0;
               exec sql delete from rapfdbfp where apgrep = :apgrep;
               if sqlcod <> 0 and sqlcod <> 100; // Error other than not found.
                 writeOut = 'Error deleting null online AP record(s) for ' +
                   apgrep;
               endif;
             endif;
             // Restore the report....
             if sqlcod = 0 or sqlcod = 100;
               // Get full report key from rptdir.
               exec sql select fldr,fldrlb,filnam,jobnam,usrnam,jobnum,
                 trim(char(datfop)),
                 filnum into :rptKeys from mrptdir where repind = :apgrep;
               if sqlcod <> 0;
                 writeOut = 'Error retrieving report dir record for ' +
                   apgrep;
               else;
                 rstRpt(rk_fld:rk_fldlib:rk_rptName:rk_jobName:rk_userName:
                   rk_jobNbr:rk_splDate:rk_filNbr:' ':' ':rtnOrpt);
                 if rtnOrpt = '1'; //Error on restore.
                   writeOut = 'Error restoring report ' + apgrep;
                 else;
                   rptsRestored += 1;
                   writeout = 'Report successfully restored for ' + apgrep;
                 endif;
               endif;
             endif;
             except detail;
             if *in01;
               except header;
               *in01 = *off;
             endif;
           endif;
           exec sql fetch next from afpCursor into :apfile;
         enddo;
         exec sql close afpCursor;
         system('dltovr rapfdbfp lvl(*job)');

         exec sql fetch next from folderCursor into :fldcod, :apfnam;
       enddo;

       exec sql close folderCursor;

       except blankLine;

       if *in01;
         except header;
         *in01 = *off;
       endif;

       writeOut = 'AFP Folders Found:   ' + %editc(afpFldCnt:'3');
       except detail;
       writeOut = 'Pointer Files Found: ' + %editc(apFileCnt:'3');
       except detail;
       writeOut = 'Pointer Error Count: ' + %editc(pointersInErr:'3');
       except detail;
       writeOut = 'Reports corrected:   ' + %editc(rptsRestored:'3');
       except detail;

       writeOut = '**End of Report**';
       except trailer;

       close qsysprt;

       *inlr = '1';
       return;

      /end-free
     oqsysprt   e            header         1  1
     o                                           49 'Fix AFP Null Ptr Records'
     o                                           75 'Page'
     o                       page          z     80
     o          e            detail         1
     o                       writeOut
     o          e            blankLine      1
     o                                              ' '
     o          e            trailer     1
     o                       writeOut

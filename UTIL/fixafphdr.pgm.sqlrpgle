      *%METADATA                                                       *
      * %TEXT Fix AFP Header Record                                    *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*new) bnddir('SPYBNDDIR')

      /copy qsysinc/qrpglesrc,qusrspla
      /copy @masplio
      /copy @memio

     d system          pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d sysdft          ds          1024    dtaara
     d  pgmLib                       10    overlay(sysdft:296)
     d rptdir        e ds                  extname(mrptdir)
     d AfileName       s             10
     d apfdta          s           4079
     d cmd             s           1024
     d msg             s             50    inz
     d                sds
     d jobName               244    253
     d user                  254    263
     d job#                  264    269
     d qJob                  244    269
     d program               334    343
     d INTJOB          s             16a
     d INTSPL          s             16a
     d hSplf           s             10i 0
      * AFP Header (attribute) record
     d afpHdr          ds
     d  afpatl                       10i 0
     d  afpatr                     4075a
     d sqlStmt         s            128
     d sq              c                   ''''

     c     *entry        plist
     c                   parm                    spyNbr           10

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;
       *inlr = *on;

       monitor;

       // Create FIXAFPHDR outq in program library.
       in sysdft;
       system('crtoutq ' + %trimr(pgmLib) + '/FIXAFPHDR');

       // Fetch the report directory record.
       exec sql select * into :rptdir from mrptdir where repind = :spyNbr;

       //Not found...message.
       if sqlcod = 100;
         msg =  'Report ID: ' + spyNbr + ' not found.';
         exsr quitSR;
       endif;

       // Not AFP and not PCL, quit.
       if apftyp <> '2' and apftyp <> '3';
         msg = 'Not AFP or PCL type report. Quitting.';
         exsr quitSR;
       endif;

       // Reprint the report into the temporary outq.
       if usrnam = ' ';
         usrnam = '*N';
       endif;
       if jobnam = ' ';
         jobnam = '*N';
       endif;
       cmd = 'PRNSPYRPT RPTNAM(' + %trimr(filNam) + ') JOB(' + %trim(jobnum) +
         '/' + %trim(usrNam) + '/' + %trim(jobNam) +
         ') DATFO(' + %trim(%char(%date(datfop:*cymd):*mdy0)) +
         ') SPLNBR(' + %trim(%char(filnum)) + ') OUTQ(' + %trimr(pgmLib) +
         '/FIXAFPHDR) FOLDER(' + %trimr(fldrlb) + '/' + %trim(fldr) + ')';
       if system(cmd) <> 0; // Call to print command failed.
         msg = 'Print operation failed. See joblog';
         exsr quitSR;
       endif;

       // Open a file handle to the printed report.
       hSplf = opnSplf(qJob:filNam:-1:INTJOB:INTSPL);
       if hSplf < 0;
         msg = 'Unable to open handle to printed report.';
         exsr quitSR;
       endif;

       // Get the printed report spool file attributes (QUSA0200);
       afpatl = %size(afpatl) + getSplARcd(hSplf:%addr(afpatr));
       cloSplf(hSplf);

       // Retrieve good (hopefully) archived attributes from MRPTATR.
       getArcAtr(spyNbr:%addr(qusa0200):%size(qusa0200):1);

       // Get the 'A' file name from the report folder record.
       exec sql select apfnam into :AfileName from mflddir where fldcod =
         :fldr and fldlib = :fldrlb;
       if sqlcod <> 0 or AfileName = ' ';
         msg = 'AFP file name not found in MFLDDIR';
         exsr quitSR;
       endif;

       // Delete the 'Bad' data from the 'A' file.
       sqlStmt = 'delete from ' + AfileName + ' where apfrep = ' +
         sq + spyNbr + sq + ' and apfseq = 0';
       exec sql execute immediate :sqlStmt;

       // Try to update the damaged 'A' file header record.
J5453  setSplfAts(%addr(afpatr)+4:%addr(qusa0200):%size(qusa0200));

       on-error;
         dsply 'Unexpected error. See joblog.';
       endmon;

       exsr quitSR;

       //***********************************************************************
       begsr quitSR;

       if msg <> ' ';
         dsply msg;
       endif;

       // Clear the outq and delete the temporary outq.
       system('clroutq ' + %trimr(pgmLib) + '/FIXAFPHDR');
       system('dltoutq ' + %trimr(pgmLib) + '/FIXAFPHDR');

       return;

       endsr;

      /end-free

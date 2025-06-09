      *%METADATA                                                       *
      * %TEXT Fix total pages in report attributes                     *
      *%EMETADATA                                                      *

     h dftactgrp(*no) actgrp(*caller) bnddir('SPYBNDDIR')

      /copy @msgLog
      /copy @masplio
      /copy qsysinc/qrpglesrc,qusrspla

     d sqlStmt         s            512
     d spyNumber       s             10
     d totalPgs        s             10i 0
     d LOC_RPTATR      c                   1
     d saveAttr        ds                  likeds(qusa0200)
     d SQ              c                   ''''

     d rcdsFound       s             10i 0  inz
     d rcdsUpdated     s             10i 0  inz
     d errors          s             10i 0  inz
     d critical        s             10i 0  inz
     d rc              s             10i 0  inz

     c     *entry        plist
     c                   parm                    reportType       10
     c                   parm                    fromCYMD          7
     c                   parm                    toCYMD            7

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;
       sqlStmt = 'select repind, totpag from mrptdir where rpttyp = ' + sq +
         %trimr(reportType) + sq + ' and datfop between ' + %trim(fromCYMD) +
         ' and ' + %trim(toCYMD);
       exec sql prepare stmt from :sqlStmt;
       exec sql declare csr01 cursor for stmt;
       exec sql open csr01;
       exec sql fetch next from csr01 into :spyNumber, :totalPgs;
       dow sqlcod = 0;
         if getArcAtr(spyNumber:%addr(qusa0200):%size(qusa0200):LOC_RPTATR) = 0;
           if QUSTP00 < totalPgs;
             rcdsFound += 1;
             saveAttr = qusa0200;
             rc = delArcAtr(spyNumber);
             if rc <> 0;
               msgLog('Error deleting attributes for ' + %trimr(spyNumber) +
                 x'25');
               errors += 1;
             endif;
             saveAttr.QUSTP00 = totalPgs;
             if putArcAtr(spyNumber:%addr(saveAttr)) = 0;
               rcdsUpdated += 1;
             else;
               msgLog('Error writing attributes for ' + %trimr(spyNumber) +
                 x'25');
               critical += 1;
             endif;
           endif;
         endif;
         exec sql fetch next from csr01 into :spyNumber, :totalPgs;
       enddo;
       exec sql close csr01;
       msgLog('Reports found: ' + %trim(%editc(rcdsFound:'3')) + x'25');
       msgLog('Reports updated: ' + %trim(%editc(rcdsUpdated:'3')) + x'25');
       msgLog('Acceptable errors: ' + %trim(%editc(errors:'3')) + x'25');
       msgLog('Critical errors: ' + %trim(%editc(critical:'3')) + x'25');
       *inlr = '1';
      /end-free

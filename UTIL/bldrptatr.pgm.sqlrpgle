      *%METADATA                                                       *
      * %TEXT Build Report Attributes File                             *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR')

      /copy @masplio
      /copy qsysinc/qrpglesrc,qusrspla

     d OK              c                   0
     d sqlStmt         s            512
     d q               c                   ''''
     d repind          s             10
     d ofrvol          s             10
     d msg             s             52

      // This will fetch attribute data for all offline reports and add
      // that data to MRPTATR. This will speed up access time for requests
      // via VCO, i.e., CoEx. Particularly, when selecting a hit from the
      // the folder view within CoEx.

      /free
       sqlStmt = 'select repind,ofrvol from mrptdir where reploc = ' + q + '2' +
         q + ' order by ofrvol';
       exsr preDclOpn;
       exsr fetchSR;
       dow sqlcod = 0;
         clear qusa0200;
         if getArcAtr(repind:%addr(qusa0200):%size(qusa0200):0) = OK;
           putArcAtr(repind:%addr(qusa0200));
         endif;
         exsr fetchSR;
       enddo;
       exsr closeCursor;
       if sqlcod <> 0 and sqlcod <> 100;
         msg = 'SQL Code: ' + %trim(%editc(sqlcod:'Z'));
         dsply msg;
       endif;
       *inlr = '1';
      /end-free

      **************************************************************************
     c     preDclOpn     begsr
     c/exec sql
     c+ prepare stmt from :sqlStmt
     c/end-exec
     c/exec sql
     c+ declare csr01 cursor for stmt
     c/end-exec
     c/exec sql
     c+ open csr01
     c/end-exec
     c                   endsr

      **************************************************************************
     c     fetchSR       begsr
     c/exec sql
     c+ fetch next from csr01 into :repind, :ofrvol
     c/end-exec
     c                   endsr

      **************************************************************************
     c     closeCursor   begsr
     c/exec sql
     c+ close csr01
     c/end-exec
     c                   endsr

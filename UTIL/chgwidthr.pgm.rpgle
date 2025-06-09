     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE':'SPYBNDDIR')

     fmrptatr   uf   e           k disk
     fmrptdir5  if   e           k disk

      /copy @masplio
      /copy qsysinc/qrpglesrc,qusrspla

     d sndmsg          pr
     d  msg                         100    value

     d rc              s             10i 0
     d width           s             10i 0

     c     *entry        plist
     c                   parm                    reportType       10
     c                   parm                    width

      /free
       setll reportType mrptdir5;
       if not %equal;
         sndmsg('Report type ' + %trim(reportType) + ' not found');
         exsr quit;
       endif;
       reade reportType mrptdir5;
       dow not %eof(mrptdir5);
         rc = getArcAtr(repind:%addr(qusa0200):%size(qusa0200):0);
         if rc <> 0;
           sndmsg('Error retrieving attributes for ' + %trim(repind) +
             ' Continuing.');
         endif;
         if rc = 0;
           delete repind mrptatr;
           quspw00 = width;
           rc = putArcAtr(repind:%addr(qusa0200));
           if rc <> 0;
             sndmsg('Error writing attributes for ' + %trim(repind) +
             ' Continuing.');
           endif;
         endif;
         reade reportType mrptdir5;
       enddo;
       exsr quit;

       //*****************************************************************
       begsr quit;
         *inlr = '1';
       endsr;

      /end-free

      *********************************************************************
     p sndmsg          b
     d                 pi
     d msg                          100    value

     d spyErr          pr                  extpgm('SPYERR')
     d  msgid                         7    const
     d  msgdta                      100    const options(*varsize)
     d  msgfil                       10    const
     d  msglib                       10    const

      /free
       spyerr('CPF8797':MSG:'QCPFMSG':'*LIBL');
       return;
      /end-free
     p                 e

      *%METADATA                                                       *
      * %TEXT Dummy MAGPCL pgm for testing return msgs                 *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR')

     d countit         pr            10i 0

      /copy @memio

     DFileNameDS       DS
     D  SplFilNam                    10
     D  SplJobNam                    10
     D  SplUsrNam                    10
     D  SplJobNum                     6
     D  SplFilNum                    10i 0
     D  SplFld                       10
     D  SplFldLib                    10
     D  SplSpyNum                    10
     D  SplOpt                        1
     D  SplType                       1
     D  SplTrnTbl                    10
     D  SplTrnLib                    10
     D  SplOptDrv                    15
     D  SplOptVol                    12
     D  SplOptRnm                    10

     d msgcount        s             10i 0

     c     *entry        plist
     c                   parm                    filenameds
     c                   parm                    cconfig           2
     c                   parm                    ctotrcd          11
     c                   parm                    crtnmsgid         8
     c                   parm                    crtnmsgdta       71
/5206c                   parm                    PageWidth         6
/    c                   parm                    NbrOfCols         6

      /free

       msgcount = countit;
       if (msgcount = 0);
         msgcount = 1;
         *inlr = '1';
       endif;
       memcpy(%addr(crtnmsgid):%addr(msgcount):%size(msgcount));

       return;

      /end-free

     p countit         b

     d                 pi            10i 0

     d count           s             10i 0 static

      /free

       count = count - 1;
       if (count < -54);
         return 0;
       endif;
       return count;

      /end-free

     p                 e

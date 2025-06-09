      *%METADATA                                                       *
      * %TEXT Date time calculation example                            *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('QC2LE')

     d h               s             10i 0
     d m               s             10i 0
     d s               s             10i 0

     d totSec          s             10i 0
     d timeStart       s               z
     d timeEnd         s               z
     d addSec          s             10i 0

     c     *entry        plist
     c                   parm                    addSecChar       10

      /free
       addSec = %int(addSecChar);
       timeStart = %timestamp();
       timeEnd = timeStart + %seconds(addSec);
       totSec = %diff(timeEnd:timeStart:*seconds);
       h = %div(totSec:%int(60**2));
       m = %rem(%div(totSec:60):60);
       s = %rem(totSec:60);
       *inlr = '1';
      /end-free

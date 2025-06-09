     h dftactgrp(*no) actgrp(*caller) bnddir('SPYBNDDIR')
      *
      * Test user index module MGUSRIDX.
      *

      /copy @mgusridx

     d indexName       s             20    inz('TSTUSRIDX PREAD')
     d rc              s             10i 0
     d indexData       ds
     d  key                          10    inz('THIS_KEY')
     d  value                        10
     d indexDataP      s               *    inz(%addr(indexData))
     d rcvr            ds                  qualified
     d  bytesRtn                     10i 0
     d  bytesAvl                     10i 0
     d  entries                    1024
     d entriesRtn      s             10i 0
      /free
       *inlr = *on;

       dltUI(indexName);
       if crtUI(%addr(indexName):10:10) = 0;
         value = 'skippy';
         if addUI(indexName:indexDataP) = 0;
           clear indexData;
           uiError.bytesProvided = %size(uiError);
           if rtvUI(%addr(rcvr):%len(rcvr):%addr(entriesRtn):indexName:1:
             UI_SEARCH_EQ:'THIS_KEY  ':10) = 0;
             reset key;
             if rmvUI(indexName:UI_SEARCH_EQ:%addr(key)) <> 0;
               reset uiError;
               getLastUIError(%addr(uiError));
             endif;
           endif;
         endif;
       endif;

       return;

      /end-free

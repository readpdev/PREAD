     h dftactgrp(*no) actgrp(*caller)

     d system          pr                  extproc('system')
     d  cmd                            *   value options(*string)

     d zeroRecord      ds           378
     d  pgTbl                        10p 0 dim(63) inz
     d outPut          s            378

     c     *entry        plist
     c                   parm                    apFileName       10
     c                   parm                    reportID         10

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;
       system('ovrdbf RAPFDBFP ' + apFileName + ' ovrscope(*job)');
       outPut = zeroRecord;
       output = *allx'00';
       exec sql update rapfdbfp set apgtbl = :outPut
         where apgrep = :reportID;
       if sqlcod <> 0;
         dsply 'Error on update.';
       endif;
       *inlr = '1';
       system('dltovr rapfdbfp lvl(*job)');
       return;
      /end-free

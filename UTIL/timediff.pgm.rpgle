     h main(TIMEDIFF) dftactgrp(*no) actgrp(*caller)

     d timeDiff        pr                  extpgm('TIMEDIFF')
     d  startHHMMss                   8
     d  endHHMMss                     8

     p timeDiff        b
     d                 pi
     d  startHHMMss                   8
     d  endHHMMss                     8

     d timeStart       s               t
     d timeEnd         s               t
     d totMin          s             10i 0
     d msg             s             50

      /free
       timeStart = %time(startHHMMss);
       timeEnd = %time(endHHMMss);
       totMin = %diff(timeStart:timeEnd:*minutes);
       msg = 'Difference in minutes: ' + %char(totMin);
       dsply msg;
       return;
      /end-free

     p                 e

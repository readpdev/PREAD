     h nomain

     d aVar            s             10i 0

     d proc1           pr

     p proc1           b                   export
      /free
       aVar = aVar + 1;
       return;
      /end-free
     p                 e

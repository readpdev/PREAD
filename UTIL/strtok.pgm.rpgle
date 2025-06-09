     h dftactgrp(*no) actgrp(*caller)

     d aString         s             10    inz('*this*')
     d strtok          pr              *   extproc('strtok')
     d  stringIn                       *   value options(*string)
     d  delimiter                      *   value options(*string)
     d inputString     s             20    inz('this is,a;test')
     d resultString    s             50    based(p)
       dcl-s delemA char(1) dim(3) ctdata perrcd(3);
       dcl-s i int(10);

      /free
       inputString = %scanrpl(',':' ':inputString);
       inputString = %scanrpl(';':' ':inputString);
       inputString = %trimr(inputString) + x'00';
       p = strtok(inputString:' ');
       dow p <> *NULL;
         p = strtok(*NULL:' ');
       enddo;
       *inlr = '1';
      /end-free
**ctdata delemA
 ,;

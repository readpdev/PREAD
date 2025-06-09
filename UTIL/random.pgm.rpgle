      *%METADATA                                                       *
      * %TEXT Random number generator                                  *
      *%EMETADATA                                                      *
       ctl-opt dftactgrp(*no) actgrp(*new);

       dcl-pr random extproc('CEERAN0');
         seed int(10);
         ranno float(8);
         feedback char(12) options(*omit);
       end-pr;

       dcl-s letterA char(1) dim(21) ctdata perrcd(21);
       dcl-s seed int(10);
       dcl-s rand float(8);
       dcl-s result int(10);
       dcl-ds word;
         wordA char(1) dim(10);
       end-ds;
       dcl-s i int(10);
       dcl-s j int(10);

       for j = 1 to 10;
         for i = 1 to 10;
           random(seed:rand:*omit);
           result = %rem(%int(rand * 1000):%elem(letterA)) + 1;
           wordA(i) = letterA(result);
         endfor;
         dsply word;
       endfor;

       return;

**ctdata letterA
BCDFGHJKLMNPQRSTVWXYZ

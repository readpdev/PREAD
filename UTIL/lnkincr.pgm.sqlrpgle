      *%METADATA                                                       *
      * %TEXT Increment Index 1 Value                                  *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no);

       dcl-pr system extproc('system');
         command pointer options(*string:*trim) value;
       end-pr;

       dcl-proc main;
         dcl-pi *n extpgm('LNKINCR');
           linkFile char(10) const;
           inputIncrementC char(10) const;
         end-pi;

         dcl-ds incrementDS;
           increment zoned(5) inz(0);
           incrementC char(5) pos(1);
         end-ds;
         dcl-ds rlink extname('RLINK') end-ds;
         dcl-s inputIncrementInt int(10);

         exec sql set option closqlcsr=*endmod,commit=*none;

         system('ovrdbf rlink ' + linkFile + ' ovrscope(*job)');

         exec sql declare c1 cursor for select * from rlink;
         exec sql open c1;

         inputIncrementInt = %int(inputIncrementC);
         increment = inputIncrementInt - 1 ;

         exec sql fetch c1 into :rlink;
         dow sqlcod = 0;
           increment += 1;
           exec sql update rlink set lxiv1 = :incrementC where current of c1;
           exec sql fetch c1 into :rlink;
         enddo;

         exec sql close c1;
         system('dltovr rlink lvl(*job)');

       end-proc;

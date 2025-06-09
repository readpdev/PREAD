      *%METADATA                                                       *
      * %TEXT Tesing multi-thread in RPG                               *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio)
         thread(*concurrent);

      /include qsysinc/qrpglesrc,pthread

       //*******************************************************************
       dcl-proc main;

         procA();

         return;

       end-proc;

       //*******************************************************************
       dcl-proc procA;

         dcl-ds mythread likeds(pthread_t);
         dcl-s rc int(10);
         dcl-s someParm char(15) inz('this is a parm');

         rc = pthread_create(mythread:*OMIT:%paddr(procB):%addr(someParm));

         return;

       end-proc;

       //*******************************************************************
       dcl-proc procB;
         dcl-pi *n;
           someParm pointer value;
         end-pi;

         dcl-pr system int(10) extproc('system');
           command pointer options(*string:*trim) value;
         end-pr;

         system('dlyjob 10');

         return;

       end-proc;

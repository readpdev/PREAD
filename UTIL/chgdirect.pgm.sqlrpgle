      *%METADATA                                                       *
      * %TEXT Change old @hpgminc to /copy directives                  *
      *%EMETADATA                                                      *
       ctl-opt main(main) actgrp(*new);

       exec sql set option closqlcsr=*endmod,commit=*none;

       dcl-pr main extpgm('CHGDIRECT');
       end-pr;

       dcl-pr run extproc('system');
         command pointer value options(*string:*trim);
       end-pr;

       dcl-pr continuation ind;
         sourceLine like(srcdta);
       end-pr;

       dcl-ds srcIO extname('QRPGLESRC') end-ds;

       //***********************************************************************
       dcl-proc main;
         dcl-pi main;
         end-pi;

         dcl-ds dfdDS extname('DSPFD') end-ds;

         dcl-s foundPGM ind inz(*off);

         exec sql declare c1 cursor for select * from dspfd;
         exec sql open c1;
         exec sql fetch c1 into :dfdDS;

         dow sqlcod = 0;

           // Read the source, find the old copy member @hpgminc, change
           // to directives.

           // Override input members.
           run('ovrdbf srcIn pread/qrpglesrc ' + %trimr(mlname));

           exec sql declare c2 cursor for select * from srcIn;
           exec sql open c2;
           exec sql fetch c2 into :srcIO;
           dow sqlcod = 0;
             if %scan('@hpgminc':srcdta) > 0;
               srcdta = '      /copy directives';
               exec sql update srcIn set srcdta = :srcdta where current of c2;
               leave;
             endif;
             exec sql fetch c2 into :srcIO;
           enddo;

           exec sql close c2;

           run('dltovr srcIn');

           exec sql fetch c1 into :dfdDS;

         enddo;

         exec sql close c1;

       end-proc;

       //***********************************************************************
       dcl-proc continuation;
         dcl-pi continuation ind;
           sourceLine like(srcdta);
         end-pi;

         dcl-s endpos int(10);

         endpos = %len(%trimr(sourceLine));
         if endpos > 0;
           if %subst(sourceLine:endpos:1) = '+';
             return *on;
           endif;
         endif;

         return *off;

       end-proc;

      *%METADATA                                                       *
      * %TEXT Send Text Message Choice Program                         *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio);

       // Program status datastructure
       dcl-ds pgm_stat psds;
         pgmlib char(10) pos(81);
       end-ds;

       dcl-proc main;
         dcl-pi *n extpgm('SNDTXTCHC');
           cellnbr int(10);
           carrier char(15);
           subject char(20);
           note char(100);
         end-pi;

         dcl-pr system extproc('system');
           command pointer options(*string:*trim) value;
         end-pr;


         //dcl-ds rptdir extname('MRPTDIR') end-ds;

         return;

       end-proc;

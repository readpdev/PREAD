       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio);

      /copy qsysinc/qrpglesrc,trgbuf

       dcl-pr main extpgm('BPPOHDRTRG');
         triggerBuffer likeds(trgBuff_t);
         triggerBufLen int(10);
       end-pr;

       dcl-pr run extproc('system');
         command pointer value options(*string:*trim);
       end-pr;

       dcl-ds trgBuff_t qualified template;
         trgHdr likeds(qdbtb);
         trgRecDta char(1024);
       end-ds;

       dcl-ds poohdrflDS extname('POOHDRFL') based(poohdrflPtr) end-ds;
       dcl-s sysCmd char(512);

       //***********************************************************************
       dcl-proc main;
         dcl-pi main;
           trgBuf likeds(trgBuff_t);
           trglen int(10);
         end-pi;

         poohdrflPtr = %addr(trgBuf) + trgBuf.trgHdr.qdbnro;

         sysCmd = 'arcstmfspy';
         run('arcstmfspy

         return;

       end-proc;

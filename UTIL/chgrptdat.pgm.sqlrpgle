      *%METADATA                                                       *
      * %TEXT Sample how to change report date in folder               *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio);

       dcl-pr main extpgm('CHGRPTHDR') end-pr;

       dcl-proc main;

         dcl-ds rptheader len(256);
           allData char(256) pos(1);
           flddatfop char(4) pos(206);
         end-ds;

         exec sql set option commit=*none;

         exec sql select * into :rptheader from dftfolder
           where rrn(dftfolder) = 943;

         flddatfop = x'0011DD7F';

         exec sql update dftfolder set dftfolder = :allData
           where rrn(dftfolder) = 943;

         return;

       end-proc;


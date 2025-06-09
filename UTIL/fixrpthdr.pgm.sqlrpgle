      *%METADATA                                                       *
      * %TEXT Fix Report Date in Header                                *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio);

       dcl-pr main extpgm('FIXRPTHDR') end-pr;

       dcl-proc main;

         dcl-ds rptheader len(256);
           allData char(256) pos(1);
           flddatfop char(4) pos(206);
         end-ds;

         exec sql set option commit=*none;

         exec sql select * into :rptheader from afld01 where rrn(afld01) = 19;

         flddatfop = x'0011DD7F';

         exec sql update afld01 set afld01 = :allData where rrn(afld01) = 19;

         return;

       end-proc;


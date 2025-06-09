       ctl-opt main(main) dftactgrp(*no) actgrp('DOCMGR');

       dcl-pr main extpgm('LNKDBCALL') end-pr;
       dcl-pr lnkdbtst extpgm('LNKDBTST') end-pr;

       exec sql set option closqlcsr=*endactgrp,commit=*none;

       dcl-proc main;
       lnkDBtst();
       lnkDBtst();

       *inlr = *on;
       return;
       end-proc;

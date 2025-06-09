     h dftactgrp(*no) actgrp('DOCMGR') bnddir('SPYBNDDIR')

     d rlinkDS       e ds                  extname(RLNKNDX)

      /copy @lnkdbsql

     d rc              s             10i 0 inz
     d sq              c                   ''''
     d i               s             10i 0
     d stmt            s            512
     d call            s             10i 0


       call += 1;

       if call = 1;
       lnkClose();
       lnkClose();

       stmt =  'select * from @000000M00 ' +
         ' order by lxiv1,lxiv2,lxiv3,lxiv4,lxiv5,lxiv6,lxiv7,lxiv8,ldxnam,' +
         'lxseq';

       lnkOpen();

       for i = 1 to 10;
         lnkRead();
       endfor;

       lnkClose();
       endif;

       if call > 1;
       stmt = 'select * from @000000M00 where lxiv1 >= ' + sq + 'IVAL1P1' + sq +
         ' and lxiv8 >= ' + sq + '20170101' + sq +
         ' order by lxiv1,lxiv2,lxiv3,lxiv4,lxiv5,lxiv6,lxiv7,lxiv8';

       lnkOpen();

       lnkRead();

       lnkClose();

       sqlDBquit();
       *inlr = *on;
       endif;

       //*********************************************************
       dcl-proc lnkOpen;

         rc = sqlDBopen(1:stmt);

       end-proc;

       //*********************************************************
       dcl-proc lnkClose;
         sqlDBClose(1);
       end-proc;

       //*********************************************************
       dcl-proc lnkRead;
         clear rlinkDS;
         rc = sqlDBread(1:'READ':%addr(rlinkDS));
       end-proc;

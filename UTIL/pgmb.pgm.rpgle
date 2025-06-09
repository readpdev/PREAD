       ctl-opt actgrp('MYACTGRP') bnddir('MYBNDDIR');

       dcl-pi pgmc extpgm('PGMB');
         oper char(5) const;
       end-pi;

       dcl-pr sqlDBopen int(10) extproc('sqlDBopen');
         handle int(5) value;
         sqlStmt pointer value options(*string:*trim);
       end-pr;

       dcl-pr sqlDBread int(10) extproc('sqlDBread');
         handle int(5) value;
         operation pointer value options(*string:*trim);
         returnStruct pointer value;
       end-pr;

       dcl-pr sqlDBclose extproc('sqlDBclose');
         handle int(5) value;
       end-pr;

       dcl-pr sqlDBquit int(10) extproc('sqlDBquit') end-pr;

       dcl-s firstTime ind inz(*on);
       dcl-ds customerDS extname('QIWS/QCUSTCDT') end-ds;
       dcl-s handle int(5);

       if firstTime;
         sqlDBOpen(handle:'select * from qiws/qcustcdt');
         firstTime = *off;
       endif;

       if oper = 'close';
         sqlDBclose(handle);
         sqlDBquit();
       else;
         clear customerDS;
         sqlDBread(handle:'READ':%addr(customerDS));
       endif;

       return;


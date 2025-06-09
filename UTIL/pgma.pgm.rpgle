       ctl-opt actgrp('MYACTGRP');

       dcl-pr pgmb extpgm('PGMB');
         oper char(5) const;
       end-pr;

       dcl-s i int(10);

       pgmb('fetch');

       pgmb('close');

       return;

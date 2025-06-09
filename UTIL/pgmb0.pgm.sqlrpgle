       ctl-opt actgrp('MYACTGRP');

       dcl-pi pgmb extpgm('PGMB');
         parm1 char(5) const;
       end-pi;

       dcl-pr pgmc extpgm('PGMC');
         parm1 char(5) const;
       end-pr;

       pgmc(parm1);

       return;

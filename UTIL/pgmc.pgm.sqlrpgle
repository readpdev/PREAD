       ctl-opt actgrp('MYACTGRP') bnddir('MYBNDDIR');

       dcl-pi pgmc extpgm('PGMC');
         parm1 char(5) const;
       end-pi;

       dcl-s firstTime ind inz(*on);
       dcl-ds rlnkndxds extname('RLNKNDX') end-ds;
       dcl-s handle int(5);

      /copy @lnkdbsql

       if firstTime;
         sqlDBOpen(handle:'select * from @000001H00');
         firstTime = *off;
       endif;

       if parm1 = 'close';
         sqlDBclose(handle);
         sqlDBquit();
       else;
         sqlDBread(handle:'READ':%addr(rlnkndxDS));
       endif;


       return;


       ctl-opt actgrp('MYACTGRP');

       dcl-pi pgmc extpgm('PGMC');
         parm1 char(10) const;
       end-pi;

       dcl-s firstTime ind inz(*on);
       dcl-ds rlnkndxds extname('RLNKNDX') end-ds;

       if firstTime;
         exec sql declare c1 cursor for select * from @000001H00;
         exec sql open c1;
         firstTime = *off;
       endif;

       if parm1 = 'close';
         exec sql close c1;
       else;
         exec sql fetch c1 into :rlnkndxDS;
       endif;

       return;


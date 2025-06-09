
      //************************************************************************
       dcl-proc writeLog export;
       dcl-pi *n;
        folder char(10) const;
        class char(10) const;
        objectID char(10) const;
        seq int(10) const;
        objectDate packed(8) const;
        message char(80) const;
        link likeds(link_t) const options(*nopass);
       end-pi;

       dcl-ds *n inz;
        i1 char(50);
        i2 char(50);
        i3 char(50);
        i4 char(50);
        i5 char(50);
        i6 char(50);
        i7 char(50);
       end-ds;
       dcl-ds *n inz;
        n1 char(10);
        n2 char(10);
        n3 char(10);
        n4 char(10);
        n5 char(10);
        n6 char(10);
        n7 char(10);
       end-ds;
       if %parms > 6;
         i1 = link.ndx1;
         i2 = link.ndx2;
         i3 = link.ndx3;
         i4 = link.ndx4;
         i5 = link.ndx5;
         i6 = link.ndx6;
         i7 = link.ndx7;
       endif;
       exec sql insert into explog values(curdate(),curtime(),:user,:folder,
         :class,:objectID,:seq,:objectDate, :message, :i1, :i2, :i3, :i4, :i5,
         :i6, :i7, ' ');
       return;
       end-proc;

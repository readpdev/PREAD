      //************************************************************************
     p writeLog        b                   export
     d                 pi
     d folder                        10    const
     d class                         10    const
     d objectID                      10    const
     d seq                           10i 0 const
     d objectDate                     8p 0 const
     d message                       80    const
     d link                                likeds(link_t) const options(*nopass)

     d                 ds                  inz
     d i1                            50
     d i2                            50
     d i3                            50
     d i4                            50
     d i5                            50
     d i6                            50
     d i7                            50
     d                 ds                  inz
     d n1                            10
     d n2                            10
     d n3                            10
     d n4                            10
     d n5                            10
     d n6                            10
     d n7                            10
      /free
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
      /end-free
     p                 e

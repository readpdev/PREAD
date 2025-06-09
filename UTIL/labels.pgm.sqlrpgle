     d labelDta        s            256
     d digits          c                   '0123456789'
     d addrDta         ds
     d name                         100
     d addr1                        100
     d addr2                        100
     d city                          50
     d state                          2
     d zip                            5
     d count           s              5i 0
     d zipPos          s              5i 0
     d TAB             c                   x'05'
      /free
/      exec sql set option closqlcsr=*endmod,commit=*none;
       exec sql declare csr01 cursor for select * from labels;
       exec sql open csr01;
       exec sql fetch next from csr01 into :labelDta;
       dow sqlcod = 0;
         select;
           when %check(digits:%subst(labelDta:1:4)) = 0 and count = 0;
             clear addrDta;
             name = %subst(labelDta:6);
             count += 1;
           when count = 1;
             addr1 = labelDta;
             count += 1;
           when count > 1;
             zipPos = %len(%trimr(labelDta))-4;
             if zipPos > 0;
               zip = %subst(labelDta:zipPos:5);
               if %check(digits:zip) = 0;
                 state = %subst(labelDta:zipPos-3:2);
                 city = %subst(labelDta:1:zipPos-5);
                 count = 0;
                 labelDta = %trimr(name) + TAB + %trim(addr1) + TAB +
                   %trim(addr2) + TAB + %trim(city) + TAB + state + TAB + zip;
                 exec sql insert into labelOut values(:labelDta);
               else;
                 addr2 = labelDta;
               endif;
             endif;
         endsl;
         exec sql fetch next from csr01 into :labelDta;
       enddo;
       exec sql close csr01;
       *inlr = '1';
      /end-free

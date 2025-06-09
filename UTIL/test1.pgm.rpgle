
       dcl-pr getNum extpgm;
         opcode char(1) const;
         gettyp char(10) const;
         rtnval char(10);
       end-pr;
       dcl-s rtnval char(10);

       dow 1 = 1;
         getNum('GET':'BATCH':rtnval);
       enddo;

       *inlr = '1';

       return;

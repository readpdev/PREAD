     h

      /copy @spysvdb

     d docClass        s             10    inz('MYIMAGES')
     d docDesc         s             30    inz
     d indexInfoArray  s             44    dim(7) inz
     d #returned       s             10i 0

      /free
       WVuGetDef(docClass:docDesc:#returned:indexInfoArray);
       dow #returned = 1;
         #returned = 0;
         WVuGetDef(docClass:docDesc:#returned:indexInfoArray);
       enddo;
       dsply #returned;
       *inlr = '1';
      /end-free

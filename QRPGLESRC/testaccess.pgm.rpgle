      *%METADATA                                                       *
      * %TEXT test access() function                                   *
      *%EMETADATA                                                      *
       ctl-opt dftactgrp(*no) actgrp(*new);
      /copy @ifsio
       dcl-s rc int(10);
       dcl-s path char(256);
       path = '/QNTC/preadwin7pro64/TEMP/ghi0.pdf' + x'00';
       rc = access(path:x_ok);
       return;

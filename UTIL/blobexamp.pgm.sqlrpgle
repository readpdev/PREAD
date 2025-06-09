     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE')
     d fLoc            s                   sqltype(BLOB_FILE)
     d myLocator       s                   sqltype(BLOB_LOCATOR)
     d buf32k          s          32740
     d locatorLen      s             10i 0
     d locatorPos      s             10i 0 inz(1)
     d binData         s                   sqltype(BLOB:1024)
     d fd              s             10i 0
     d path            s            255
     d bytesRead       s             10i 0
     d firstTime       s               n   inz('1')
     d locPos          s             10i 0
      /copy @ifsio
      /free
/      exec sql set option closqlcsr=*endmod,commit=*none;
       path = '/QSYS.LIB/PREAD.LIB/PRSAVF.FILE' + x'00';
       fd = open(path:O_RDONLY);
       if fd >= 0;
         bytesRead = read(fd:buf32k:%size(buf32k));
         dow bytesRead > 0;
           if firstTime; // Write the first buffer to the blob and then fetch the locator.
             exec sql insert into myblob values(blob(:buf32k));
             exec sql select * into :myLocator from myblob;
             firstTime = '0';
           else;
             exec sql values concat(substr(:myLocator,:locPos,:bytesRead),
               blob(:buf32k)) into :myLocator;
             locPos = bytesRead + 1;
           endif;
           bytesRead = read(fd:buf32k:%size(buf32k));
         enddo;
         exec sql free locator :myLocator;
       endif;
       callp close(fd);
       // exec sql insert into myblob values(blob('this is a binary value'));
       // exec sql select blob(myblob) into :myLocator from myblob;
       // locatorLen = myLocator;
       // exec sql set :binData = substr(:myLocator,1,:locatorLen);
       *inlr = '1';
      /end-free

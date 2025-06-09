     h dftactgrp(*no) bnddir('QC2LE')

     d getPath         pr              *   extproc('Qp0lGetPathFromFileID')
     d  resultP                        *   value
     d  sizeResult                   10i 0 value
     d  objID                          *   value

     d objID           s             16
     d buf             s            512

      /free
       objID = X'000000000000000000000000000145AC';
       getPath(%addr(buf):%size(buf):%addr(objID));
       *inlr = '1';
      /end-free

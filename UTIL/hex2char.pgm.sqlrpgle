     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE')

     d cvtch           pr                  extproc('cvtch')
     d  tgt                            *   value
     d  src                            *   value
     d  len                          10i 0 value

     d                 ds
     d inBuf                        512
     d inBufA                         2    dim(256) overlay(inBuf)

     d                 ds
     d outBuf                       256
     d outBufA                        1    dim(256) overlay(outBuf)

     d sqlStmt         s            256
     d bLen            s             10i 0
     d i               s             10i 0

      /free
       sqlStmt = 'select * from pread/mtrace';
       exec sql prepare stmt from :sqlStmt;
       exec sql declare csr01 cursor for stmt;
       exec sql open csr01;
       exec sql fetch next from csr01 into :inBuf;
       dow sqlcod = 0;
         bLen = %len(%trim(inBuf)) / 2;
         for i = 1 to bLen;
           cvtch(%addr(outBufA(i)):%addr(inBufA(i)):2);
         endfor;
         exec sql insert into pread/output (output) values(:outBuf);
         exec sql fetch next from csr01 into :inBuf;
       enddo;
       exec sql close csr01;
       *inlr = '1';
      /end-free

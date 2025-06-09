     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE')

     d cvtch           pr                  extproc('cvtch')
     d  target                         *   value
     d  source                         *   value
     d  lengthSource                 10i 0 value

     d spyerr          pr                  extpgm('SPYERR')
     d  msgid                         7    const
     d  msgdta                      100    const
     d  msgfil                       10    const
     d  msglib                       10    const

     d getPath         pr              *   extproc('Qp0lGetPathFromFileID')
     d  pathResult                     *   value
     d  sizeResult                   10i 0 value
     d  fileID                         *   value

     d aPath           s            256    inz
     d pathLen         s             10i 0 inz(%size(aPath))
     d fileID16        s             17

     c     *entry        plist
     c                   parm                    fileIDin         32

      /free
       cvtch(%addr(fileID16):%addr(fileIDin):%size(fileIDin));
       fileid16 = %trimr(fileid16) + x'00';
       getPath(%addr(aPath):pathLen:%addr(fileID16));
       spyerr('CPF9898':aPath:'QCPFMSG':'*LIBL');
       *inlr = '1';
      /end-free

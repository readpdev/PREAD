      *%METADATA                                                       *
      * %TEXT Retrieve DocLinks                                        *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) copyright('Open Text Corporation')

      *

     d main            pr                  extpgm('MCDOCHITR')
     d                 pi
     d  opCode                       10    const
     d  handle                       10    const options(*nopass)
     d  linkFile                     10    const options(*nopass)
     d  requestBuffer                  *   const options(*nopass)
     d  returnBuffer                   *   options(*nopass)
     d  returnBufLen                 10i 0 options(*nopass)

     d returnBuffer    s               *
     d returnBufLen    s             10i 0

      /free

       select;
         when opCode = 'INIT';
         when opCode = 'SELCR';
         when opCode = 'SETGT';
         when opCode = 'RDGT';
         when opCode = 'QUIT';
       endsl;

       return;

      /end-free

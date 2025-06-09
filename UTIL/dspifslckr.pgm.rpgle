      *%METADATA                                                       *
      * %TEXT Display IFS file Info/Lock                               *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE')

     d sq              c                   ''''

     d system          pr                  extproc('system')
     d  command                        *   value options(*string)

     d ifsInfo         pr                  extpgm('QP0FPTOS')
     d  objRef                       10    const
     d  path                        256    const
     d  format                       10    const

     d cmd             s            512

     c     *entry        plist
     c                   parm                    path            256
      /free
       cmd = 'call qp0fptos (' + sq  + '*LSTOBJREF' + sq + ' ' +
       sq + %trim(path) + sq + ' ' + sq + '*FORMAT2' + sq + ')';
       system(cmd);
       *inlr = '1';
       return;
      /end-free

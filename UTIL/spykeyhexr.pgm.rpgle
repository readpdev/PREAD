      *%METADATA                                                       *
      * %TEXT Convert Hex to Character                                 *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('QC2LE')
      *
      * Convert 16-byte hex to 32-byte char.
      *
     D CVTHC           PR                  EXTPROC('cvthc')
     D  RCV                            *   VALUE
     D  SRC                            *   VALUE
     D  RCVLEN                       10I 0 VALUE

     c     *entry        plist
     c                   parm                    input            16
     c                   parm                    output           32

     c                   callp     cvthc(%addr(output):
     c                             %addr(input):32)

     c                   eval      *inlr = '1'

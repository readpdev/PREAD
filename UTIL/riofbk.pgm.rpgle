      *%METADATA                                                       *
      * %TEXT RIOFBK example                                           *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('QC2LE')

      /copy pread/qrpglesrc,@recio

     d nullPtr         s               *
     d fp              s               *


     c                   eval      fp = Ropen('MIMGDIR'+x'00':
     c                             'rr,blkrcd=Y'+x'00')

     c                   callp     Rlocate(fp:nullPtr:0:R_START)
     c                   eval      xxiofbP = Riofbk(fp)
     c                   eval      xxiofb_dbP = xxiofbP + file_dep_off
     c                   callp     Rclose(fp)

     c                   eval      *inlr = '1'

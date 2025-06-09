      /copy qsysinc/qrpglesrc,qusec
     d errData                      100

     d cvtEdtWrd       pr                  extpgm('QECCVTEW')
     d  editMask                    256
     d  editMaskLen                  10i 0
     d  rcv_var_len                  10i 0
     d  editWord                    256
     d  editWordLen                  10i 0
     d  error                              like(qusec)

     d editMask        s            256
     d editMaskLen     s             10i 0
     d rcv_var_len     s             10i 0
     d editWord        s            256
     d editWordLen     s             10i 0 inz(11)

     d edit            pr                  extpgm('QECEDT')
     d  receiver                       *
     d  rec_var_len                  10i 0
     d  source                         *   const
     d  src_var_cls                  10
     d  src_precision                10i 0
     d  edit_mask                   256
     d  edit_mask_len                10i 0
     d  zero_fill_chr                 1
     d  error                              like(qusec)

     d formattedData   s               *
     d zero_fill_chr   s              1    inz(x'00')
     d p30_9           s             30  9 inz(1234567.89)
     d src_var_cls     s             10    inz('*PACKED')
     d src_precision   s             10i 0

     c                   eval      editWord = '   ,   ,   .  '
     c                   eval      editWordLen = 15
     c                   clear                   qusec
     c                   eval      qusbprv = %size(qusec)
     c                   callp     cvtEdtWrd(editMask:editMaskLen:rcv_var_len:
     c                             editWord:editWordLen:qusec)
     c                   clear                   qusec
     c                   eval      qusbprv = %size(qusec)
     c                   eval      src_precision = %len(p30_9)
     c                   alloc     rcv_var_len   formattedData
     c                   callp     edit(formattedData:rcv_var_len:%addr(p30_9):
     c                             src_var_cls:src_precision:editMask:
     c                             editMaskLen:zero_fill_chr:qusec)
     c                   dealloc                 formattedData

     c                   eval      *inlr = '1'

     d genPrdId        ds
     d  gpi_id                        7    inz('FOOBAR')
     d  gpi_term                      6    inz('V7R0')
     d  gpi_ftr                       4    inz('5001')

     c                   call      'QLZAGENK'
     c                   parm                    genPrdId
     c                   parm      'LICT0100'    genFmtNm          8



     c                   eval      *inlr = '1'

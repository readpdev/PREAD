     h dftactgrp(*no) bnddir('QC2LE')

     d itoa            pr              *   extproc('__itoa')
     d  intP                         10i 0 value
     d  charP                          *   value
     d  radix                        10i 0 value

     d rc              s             10i 0
     d rcC             s             10

     c                   eval      rcC = %str(itoa(rc:%addr(rcC):10))

     c                   eval      *inlr = '1'

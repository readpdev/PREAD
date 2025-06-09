      *%METADATA                                                       *
      * %TEXT Create report 256 chars wide                             *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('MYBNDDIR')

     fqsysprt   o    f  256        printer oflind(*in01) usropn

      /copy 'UTIL/@run.rpgleinc'

     d x               s             10i 0
     d detail          s              1    dim(256)
     d lines           s             10i 0 inz(60)

     d nbrPages        s              5s 0
     d nbrPages_c      s              5

     c     *entry        plist
     c                   parm                    nbrPages_c
     c                   move      nbrPages_c    nbrPages

     c                   do        256           x
     c                   eval      detail(x) = %subst(%editc(x-1:'X'):10:1)
     c                   enddo

     c                   callp     run('OVRPRTF FILE(QSYSPRT) PAGESIZE(66 256)'+
     c                             ' OVRFLW(60)')
     c                   open      qsysprt

     c                   eval      *in01 = '1'
     c                   do        nbrPages
     c                   do        lines
     c                   if        *in01
     c                   except    hdr
     c                   eval      *in01 = '0'
     c                   endif
     c                   except    dtl
     c                   enddo
     c                   enddo

     c                   close     qsysprt
     c                   callp     run('dltovr qsysprt')

     c                   eval      *inlr = '1'

     oqsysprt   e            hdr            1  1
     o                                              'Page: '
     o                       page
     o          e            dtl            1
     o                       detail             256

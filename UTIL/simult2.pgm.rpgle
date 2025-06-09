      *%METADATA                                                       *
      * %TEXT Simulate User License Tracking                           *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('MYBNDDIR':'SPYBNDDIR':'SPYSPCIO')

      /copy @mfspyautr
      /copy 'UTIL/@run.rpgleinc'

     d getrdm          pr            10i 0 extproc('getRdm')
     d  modulo                       10i 0 value

     d spyerr          pr                  extpgm('SPYERR')
     d  msgid                         7
     d  msgdta                      100
     d  msgfil                       10    const
     d  msglib                       10    const

     d prodnum         s              3  0
     d modulo          s             10i 0

     d simultdta       s             10    dtaara

     c     *entry        plist
     c                   parm                    prodnum_c         3
     c                   parm                    modulo_c          3

     c                   callp     run('dlyjob 1')
     c                   move      prodnum_c     prodnum
     c                   move      modulo_c      modulo
     c                   in        simultdta

     c                   dow       simultdta <> 'STOP'

      * add product into tracking
     c                   callp     spyaut(prodnum:ar_ind:ar_msgid:ar_mdta)
     c                   if        ar_ind <> '1'
     c                   callp     spyerr(ar_msgid:ar_mdta:'PSCON':'*LIBL')
     c                   leave
     c                   endif
      * delay job between x number of seconds.
     c                   callp     run('dlyjob '+%editc(getrdm(modulo):'X'))
      * remove from tracking.
     c                   callp     spyaut(prodnum:ar_ind:ar_msgid:ar_mdta:'1')
     c                   if        ar_ind <> '1'
     c                   callp     spyerr(ar_msgid:ar_mdta:'PSCON':'*LIBL')
     c                   leave
     c                   endif
      * delay job between x number of seconds.
     c                   callp     run('dlyjob '+%editc(getrdm(modulo):'X'))
     c                   in        simultdta

     c                   enddo

     c                   eval      *inlr = '1'

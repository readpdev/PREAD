      *%METADATA                                                       *
      * %TEXT Manual Report Unpack                                     *
      *%EMETADATA                                                      *
      *
      * compile at v4r5 or above
      *
     h dftactgrp(*no) bnddir('MYBNDDIR') actgrp(*new)

     fmrptdir7  if   e           k disk
     ffolder    if   f  256        disk    usropn
     funpckfldr o    f  256        disk    usropn

      /copy 'UTIL/@run.rpgleinc'

     d codec           pr                  extpgm('SPYCODEC')
     d  opcode                        1    const
     d  sourceData                  256    dim(128)
     d  sourceLen                    10i 0
     d  targetData                  256    dim(128)
     d  targetLenAvl                 10i 0 const
     d  targetLenAct                 10i 0

     d cmpr            s            256    dim(128)
     d dcmpr           s            256    dim(128)
     d inrec           ds           256
     d  bytesInBlock                 10i 0 overlay(inrec:5)
     d outrec          ds           256
     d x               s             10i 0
     d actual          s             10i 0
     d recsinblock     s             10i 0
     d cmprlen         s             10i 0
     d totalrecs       s             10i 0
     d processed       s             10i 0

     c     *entry        plist
     c                   parm                    repind

     c     repind        chain     mrptdir7
     c                   if        %found
     c                   exsr      overrideAndOpn
     c                   eval      totalrecs = locsfp - locsfd
     c                   dou       processed >= totalrecs
     c                   exsr      readandload
     c                   exsr      decompress
     c                   exsr      writetofile
     c                   enddo
     c                   close     unpckfldr
     c                   callp     run('cpyf unpckfldr qsysprt')
     c                   close     folder
     c                   callp     run('dltovr file(*all) lvl(*job)')
     c                   endif

     c                   eval      *inlr = '1'

      **************************************************************************
     c     readAndLoad   begsr

     c                   eval      recsInBlock = bytesInBlock/256
     c                   eval      cmprlen = %rem(bytesInBlock:256)
     c                   if        cmprlen > 0
     c                   eval      recsInBlock = recsInBlock + 1
     c                   endif
     c                   eval      cmprlen = cmprlen + bytesInBlock
     c                   eval      x = 1
     c                   do        recsInBlock
     c                   eval      processed = processed + 1
     c                   eval      cmpr(x) = inrec
     c                   eval      x = x + 1
     c                   read      folder        inrec
     c                   enddo

     c                   endsr

      **************************************************************************
     c     decompress    begsr

     c                   eval      dcmpr(*) = *all' '
     c                   callp     codec('0':cmpr:cmprlen:dcmpr:32768:actual)
     c                   eval      cmpr(*) = *all' '

     c                   endsr

      **************************************************************************
     c     writetofile   begsr

     c                   eval      x = 1
     c                   dow       x < 129 and dcmpr(x) <> ' '
     c                   eval      outrec = dcmpr(x)
     c                   write     unpckfldr     outrec
     c                   eval      x = x + 1
     c                   enddo

     c                   endsr

      **************************************************************************
     c     overrideAndOpnbegsr

     c                   callp     run('ovrdbf folder ' + %trimr(fldrlb) + '/' +
     c                             %trimr(fldr) + ' ovrscope(*job)')
     c                   callp(e)  run('dltf qtemp/unpckfldr')
     c                   callp     run('crtpf qtemp/unpckfldr rcdlen(256)' +
     c                             ' lvlchk(*no)')
     c                   callp     run('ovrdbf unpckfldr qtemp/unpckfldr' +
     c                             ' ovrscope(*job)')
     c                   callp     run('ovrprtf qsysprt ctlchar(*fcfc)' +
     c                             ' pagesize(*n 198) ovrscope(*job)' +
     c                             ' maxrcds(*nomax)')
     c                   open      folder
     c     locsfd        setll     folder
     c                   read      folder        inrec
     c                   open      unpckfldr

     c                   endsr

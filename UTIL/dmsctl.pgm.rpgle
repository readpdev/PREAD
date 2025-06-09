      *%METADATA                                                       *
      * %TEXT Beginnings of test app for DMS                           *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR')

      /copy @mmdmssrvr

     d copath          ds
     d  copathlen                     5s 0 inz(%size(copathdta))
     d  copathdta                    22    inz('C:\prtest\3d456f92.TIF')

     d conote          ds
     d  conotelen                     5s 0 inz(%size(conotedta))
     d  conotedta                    25    inz('This is a check-out note.')

     d rqstptr         s               *
     d hldptr          s               *
     d wrkptr          s               *
     d rqstlen         s             10i 0
     d rspptr          s               *
     d rsplen          s             10i 0
     d msgid           s              7

     d                sds
     d user                  254    263

     c     *entry        plist
     c                   parm                    batchnum         10
     c                   parm                    seqnum            9
     c                   parm                    revid             5

     c                   clear                   csstdrqsthed
     c                   eval      csr_file = '@'
     c                   eval      csr_majminver = '71000'
     c                   eval      csr_opcode = 'DMLCK'

     c                   clear                   contlckhed
     c                   eval      clh_hdrsize = 70
     c                   eval      clh_batchnum = batchnum
     c                   move      seqnum        clh_seqnum
     c                   move      revid         clh_revid
     c                   eval      clh_locktype = 205
     c                   eval      clh_branch = 'N'
     c                   eval      clh_numusrfld = 0

     c                   eval      rqstlen = %size(csstdrqsthed) +
     c                             %size(contlckhed) + %size(copath) +
     c                             %size(conote)

     c                   alloc     rqstlen       rqstptr

     c                   eval      hldptr = rqstptr
     c                   eval      %str(rqstptr:%len(csstdrqsthed)+1) =
     c                             csstdrqsthed
     c                   eval      rqstptr = rqstptr + %len(csstdrqsthed)
     c                   eval      %str(rqstptr:%len(contlckhed)+1) =
     c                             contlckhed
     c                   eval      rqstptr = rqstptr + %len(contlckhed)
     c                   eval      %str(rqstptr:%len(copath)+1) = copath
     c                   eval      rqstptr = rqstptr + %len(copath)
     c                   eval      %str(rqstptr:%len(conote)+1) = conote
     c                   eval      rqstptr = hldptr

     c                   eval      msgid = dmsctl(rqstptr:rspptr:rsplen:user:
     c                             'NODEID')

     c                   eval      *inlr = '1'

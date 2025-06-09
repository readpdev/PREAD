      *%METADATA                                                       *
      * %TEXT DMS OpCode Request                                       *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR')

      /copy @mmdmssrvr

     d rqstPtr         s               *
     d respPtr         s               *
     d wrkInt          s             10i 0

     d dummySend       pr            10i 0
     d  bufptr                         *   value
     d  buflen                       10i 0 value

     d spycs           pr                  extpgm('SPYCS')
     d  nodeid                       17    const
     d  runmode                      10    const
     d  webip                        15    const
     d  webapp                       10    const
     d  webusr                       20    const
     d  opcde                         6    const
     d  buf                        8192
     d  clsend                         *   procptr const
     d buf             s           8192

     d UsrNamValDS     ds
     d  usrValLen                     5s 0 inz(%size(usrValNam))
     d  usrValNam                     8    inz('USERNAME')
     d  usrNamLen                     5s 0 inz(%size(userName))
     d  userName                      8    inz('*CURRENT')

     d                sds
     d pgmusr                254    263

     d rtnMsgID        s              7
     d rspLen          s             10i 0
     d opcode          s                   like(Csr_Opcode)

     c     *entry        plist
     c                   parm                    opcode

     c                   clear                   CsStdRqstHed
     c                   reset                   LckLstRqstHed
     c                   eval      Csr_Opcode = opcode
     c                   eval      buf = csstdrqsthed + lcklstrqsthed +
     c                             usrnamvalDS
     c                   callp     spycs('nodeid':'runmode':'10.32.0.94':
     c                             'SPYDEMO':pgmusr:opcode:buf:
     c                             %paddr('DUMMYSEND'))

     c                   eval      *inlr = '1'

     p dummySend       b                   export

     d                 pi            10i 0
     d bufptr                          *   value
     d buflen                        10i 0 value

     c                   return    0

     p                 e

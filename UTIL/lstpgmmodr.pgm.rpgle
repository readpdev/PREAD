     h dftactgrp(*no) bnddir('SPYSPCIO')

     fqsysprt   o    f  132        printer oflind(*in01)

      /copy @spyspcio
      /copy qsysinc/qrpglesrc,qusec
     d lstPgmi         pr                  extpgm('QBNLPGMI')
     d  userSpc                      20    const
     d  format                        8    const
     d  qpgm                         20    const
     d  error                              like(qusec)

     d lstSrvPgm       pr                  extpgm('QBNLSPGM')
     d  userSpc                      20    const
     d  format                        8    const
     d  qsrvpgm                      20    const
     d  error                              like(qusec)

     d rtvSpcPtr       pr                  extpgm('QUSPTRUS')
     d  userSpc                      20    const
     d  pointer                        *

     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         256    const
     d  cmdlen                       15  5 const

     d header          ds           136    based(hdrP)
     d  lstOffSet                    10i 0 overlay(header:125)
     d  entries                      10i 0 overlay(header:133)

     d list            ds                  based(listP)
     d  sizeEntry                    10i 0
     d  programName                  10
     d  programLib                   10
     d  moduleName                   10
     d  moduleLib                    10

     d underline       s            132    inz(*all'_')
     d qUsrSpc         s             20
     d qpgm            s             20
     d spcPtr          s               *
     d total           s             10i 0 inz
     d pgmType         s             10

     c     *entry        plist
     c                   parm                    library          10
     c                   parm                    pgm              10
     c                   parm                    modSearch        10

     c                   callp     CrtUsrSpc('MODLIST':'QTEMP':2000)

      * Fill user space for all stand alone programs. ILE.
     c                   movel     'MODLIST'     qUsrSpc
     c                   move      'QTEMP     '  qUsrSpc
     c                   eval      qusbprv = %size(qusec)
     c                   eval      qusbavl = 0
     c                   movel     pgm           qpgm
     c                   move      library       qpgm
     c                   callp     lstPgmi(qUsrSpc:'PGML0110':qpgm:qusec)
     c                   callp     rtvSpcPtr(qUsrSpc:spcPtr)
     c                   eval      hdrP = spcPtr
     c                   eval      listP = spcPtr + lstoffset
     c                   callp     run('ovrprtf qsysprt':15)
     c                   eval      *in01 = '1'
     c                   eval      pgmType = '*PGM'
     c                   exsr      doEntries

      * Fill user space for service programs.
     c                   callp     lstSrvPgm(qUsrSpc:'SPGL0110':qpgm:qusec)
     c                   eval      hdrP = spcPtr
     c                   eval      listP = spcPtr + lstoffset
     c                   eval      pgmType = '*SRVPGM'
     c                   exsr      doEntries

     c                   callp     run('dltovr qsysprt':14)

     c                   call      'QUSDLTUS'
     c                   parm                    qUsrSpc
     c                   parm                    qusec

     c                   except    prttotal

     c                   eval      *inlr = '1'

      **************************************************************************
     c     doEntries     begsr

     c                   do        entries
     c                   if        *in01
     c                   except    prtheader
     c                   eval      *in01 = '0'
     c                   endif
     c                   if        modSearch = '*ALL' or
     c                             moduleName = modSearch
     c                   except    prtdetail
     c                   eval      total = total + 1
     c                   endif
     c                   eval      listP = listP + sizeEntry
     c                   enddo

     c                   endsr

      **************************************************************************
     oqsysprt   e            prtheader      1  1
     o                                           76 'List Program Modules'
     o                       PAGE               132
     o          e            prtheader      2
     o                                              'Library: '
     o                       library
     o                                              '  Module Search: '
     o                       modsearch
     o          e            prtheader
     o                                              'Program      '
     o                                              'Type      '
     o                                              'Module    '
     o          e            prtheader      2
     o                       underline
     o          e            prtdetail      1
     o                       programName
     o                                              '   '
     o                       pgmType
     o                       moduleName
     o          e            prttotal    2
     o                                              'Total Programs: '
     o                       total         Z

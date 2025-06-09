     h dftactgrp(*no) bnddir('MYBNDDIR')
     fmrptdir7  if   e           k disk

      /copy 'UTIL/@run.rpgleinc'

     c     *entry        plist
     c                   parm                    repind
     c                   parm                    frpageIn          7 0
     c                   parm                    topageIn          7 0
     c                   parm                    individual        1
     c                   parm                    submit            1

     c                   if        submit = 'Y'
     c                   callp     run('sbmjob cmd(prtrpt repind(' +
     c                             %trimr(repind) + ') frpage(' +
     c                             %trim(%editc(frpageIn:'Z')) +
     c                             ') topage(' + %trim(%editc(topageIn:'Z')) +
     c                             ') individual(' + individual +
     c                             ') submit(N)) job(prtrpt)')
     c                   endif

     c                   if        submit = 'N'
     c     repind        chain     mrptdir7
     c                   if        %found
     c                   if        individual = 'Y'
     c     frpageIn      do        topageIn      x                 7 0
     c                   eval      frpage = x
     c                   eval      topage = x
     c                   exsr      print
     c                   enddo
     c                   else
     c                   eval      frpage = frpageIn
     c                   eval      topage = topageIn
     c                   exsr      print
     c                   endif
     c                   endif
     c                   endif

     c                   eval      *inlr = '1'

      **************************************************************************
     c     print         begsr

     c                   call      'MAG2038'
     C                   PARM      '*ORIG'       RPTNAM           10
     C                   PARM      '*STD'        OUTFRM           10
     C                   PARM      '*ORIG'       RPTUD            10
     C                   PARM                    FRpage            7 0
     C                   PARM                    TOPAGE            7 0
     C                   PARM      ' '           OUTQ             10
     C                   PARM      ' '           OUTQL            10
     C                   PARM      ' '           PRTF             10
     C                   PARM      ' '           PRTLIB           10
     C                   PARM      1             FRMCL#            3 0
     C                   PARM      999           TOCOL#            3 0
     C                   PARM      1             COPIES            3 0
     C                   PARM      ' '           WRITER           10
     C                   PARM      ' '           OUTFIL           10
     C                   PARM      ' '           OUTFLB           10
     C                   PARM                    REPLOC            1
     C                   PARM                    OFRNAM           10
     C                   PARM      0             NUMWND            3 0
     C                   PARM      247           #RL               3 0
     C                   PARM      81            COLSCN            3 0
     C                   PARM      LOCSFA        PLCSFA            9 0
     C                   PARM      LOCSFD        PLCSFD            9 0
     C                   PARM      LOCSFP        PLCSFP            9 0
     C                   PARM      'N'           PRTWND            1
     C                   PARM                    FLDR             10
     C                   PARM                    FLDRLB           10
     C                   PARM                    REPIND           10
     C                   PARM      ' '           PTABLE           20
      * Print duplex: 29-
     C                   PARM      '*NONE'       CVRPAG            7
     C                   PARM      '*ORG'        DUPLEX            4
     C                   PARM      '*AUTO'       ORIENT           10
     C                   PARM      ' '           PTRTYP            6
     C                   PARM      ' '           PTRNOD           17
     C                   PARM      '*SYSDFT'     CVRMBR           10
     C                   PARM      '*SYSDFT'     PAPSIZ           10
     C                   PARM      '*ORG'        DRAWER            4
/5329c                   parm      'N'           eNotesPrint       1

     c                   endsr

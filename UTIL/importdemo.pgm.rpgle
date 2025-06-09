      * CRTOPT TGTRLS(*CURRENT) DFTACTGRP(*NO) ALWNULL(*YES)
      * CRTOPT DBGVIEW(*ALL)
     h datfmt(*iso)
     fdemopf    if   e           k disk
     fspykeymst uf a e           k disk
     fspykeylic uf a e           k disk
     fspykeyhis o    e             disk
     fspykeyprd if   e           k disk

     D WRITEHIST       PR
     D  DATAKEY                      25    VALUE
     D  CURRENT                      12    VALUE
     D  HISTORICAL                   12    VALUE
     D  PRODUCT#                      3  0 VALUE OPTIONS(*NOPASS)

     d prompts         s             25    dim(10) ctdata
     d str             s             10i 0 inz(1)
     d end             s             10i 0
     d pos             s             10i 0
     d x               s             10i 0

     d skmver_c        s              4
     d skl#us_c        s              3
     d skmdmo_c        s              8

      * HISTORY CONTROL.
     D MSTDTA        E DS                  EXTNAME(SPYKEYMST)
     D  MSTKEYDTA             41     60
     D MSTHLD        E DS                  EXTNAME(SPYKEYMST) PREFIX(X_)
     D LICDTA        E DS                  EXTNAME(SPYKEYLIC)
     D LICHLD        E DS                  EXTNAME(SPYKEYLIC) PREFIX(X_)
     D HSTDTA        E DS                  EXTNAME(SPYKEYHIS)

     d licProd         s               n
     d wrkdat          s               d
     d                 ds
     d timedate                      14  0
     d  time                          6  0 overlay(timedate)
     d  date                          8  0 overlay(timedate:7)

     C     MST_KEY       KLIST
     C                   KFLD                    SKMSID
     C                   KFLD                    SKMPFM
     C                   KFLD                    SKMIS#

     C     LIC_KEY       KLIST
     C                   KFLD                    SKMSID
     C                   KFLD                    SKMPFM
     C                   KFLD                    SKMIS#
     C                   KFLD                    SKLPRD

     c     prod_key      klist
     c                   kfld                    skmpfm
     c                   kfld                    sklprd

     c                   eval      skmpfm = '400'
     c                   eval      skmis# = 1
     c                   eval      sklpfm = '400'
     c                   eval      sklis# = 1
     c                   eval      skldmo = 0

     c                   dow       1 = 1

     c                   read      demopf
     c                   if        %eof
     c                   leave
     c                   endif

     c                   eval      skmnam = thname
     c                   eval      str = 1

     c                   do        10            x

     c                   eval      pos = %scan(prompts(x):thmemo:str)
     c                   if        pos = 0
     c                   leave
     c                   endif
     c                   eval      str = pos + 27
     c     ' '           check     thmemo:str    str

     c                   if        (x = 4 or x = 5 or x = 7) and
     c                             %subst(thmemo:str:1) <> 'Y'
     c                   iter
     c                   endif

     c                   select
     c                   when      x = 1
     c                   eval      skmsid = %subst(thmemo:str:8)
     c                   when      x = 2
     c                   eval      skmmdl = %subst(thmemo:str:%len(skmmdl))
     c                   when      x = 3
     c                   eval      skmver_c =
     c                             '0' + %subst(thmemo:str:%len(skmver))
     c                   move      skmver_c      skmver
     c                   when      x = 4
     c                   eval      sklprd = 1
     c                   when      x = 5
     c                   eval      sklprd = 2
     c                   when      x = 6
     c                   eval      sklprd = 4
     c                   when      x = 7
     c                   eval      sklprd = 6
     c                   when      x = 8
     c                   eval      sklprd = 5
     c                   when      x = 9
     c                   eval      skmdmo_c = %subst(thmemo:str:%len(skmdmo))
     c                   move      skmdmo_c      skmdmo
     c     *usa          test(de)                skmdmo
     c                   if        not %error
     c                   mult      10000.0001    skmdmo
     c                   endif
     c                   when      x = 10
     c                   eval      skmkcd = %subst(thmemo:str:%len(skmkcd))
     c     mst_key       setll     spykeymst
     c                   if        %equal
     c                   exsr      chkchgmst
     c                   else
     c                   write     skmrec
     c                   endif
     c                   other
     c                   leave
     c                   endsl

     c                   if        x = 4 or x = 5 or x = 7
     c                   eval      str = str + 6
     c                   eval      skl#us_c=%subst(thmemo:str:%len(skl#us_c))
     c                   move      skl#us_c      skl#us
     c                   eval      sklsid = skmsid
     c     lic_key       setll     spykeylic
     c                   if        %equal
     c                   exsr      chkchglic
     c                   else
     c                   write     sklrec
     c                   endif
     c                   endif

     c                   enddo

     c                   enddo

      * Some accounts in demo do not have licensed product records.
      * Pass through and input all products (not SpyLite). If demo and no produc

     c                   clear                   threc

     c     *loval        setll     spykeymst
     c                   dow       1 = 1

     c                   read      spykeymst
     c                   if        %eof
     c                   leave
     c                   endif

     c                   if        skmdmo = *all'9'
     c                   iter
     c                   endif

     c     mst_key       setll     spykeylic
     c                   if        not %equal

     c     skmpfm        setll     spykeyprd
     c                   dow       1 = 1

     c     skmpfm        reade     spykeyprd
     c                   if        %eof or skpavf > 600
     c                   leave
     c                   endif

     c                   if        skpprd = 2
     c                   iter
     c                   endif

     c                   eval      sklsid = skmsid
     c                   eval      sklprd = skpprd
     c                   eval      skl#us = 0
     c                   if        skputl = 'Y'
     c                   eval      skl#us = 999
     c                   endif
     c                   eval      thuser = 'IMPORT'
     c                   time                    timedate
     c                   eval      skhtlc = time
     c                   eval      skhdlc = date
     c                   if        skmdmo <> *all'9'
     c                   callp     writehist('Demo:':'':'*ADDED':sklprd)
     c                   else
     c                   callp     writehist('':'':'*ADDED')
     c                   endif

     c                   write     sklrec

     c                   enddo

     c                   endif

     c                   enddo

     c                   eval      *inlr = '1'

      **************************************************************************
     C     CHKCHGMST     BEGSR

      * CHECK FOR CHANGES IN MASTER RECORD DATA.

      * SAVE CURRENT MASTER RECORD BUFFER AND RETRIEVE MASTER FROM DB.
     C                   EVAL      MSTHLD = MSTDTA
     C     MST_KEY       reade     SPYKEYMST
     C                   IF        NOT %equal
     C                   EVAL      MSTDTA = MSTHLD
     C                   ENDIF

      * VERSION NUMBER.
     C                   IF        X_SKMVER <> SKMVER
     C                   CALLP     WRITEHIST('Version':
     C                             %TRIML(%EDITC(SKMVER:'Z')):
     C                             %TRIML(%EDITC(X_SKMVER:'Z')))
     C                   ENDIF

      * AS400 MODEL.
     C                   IF        X_SKMMDL <> SKMMDL
     C                   CALLP     WRITEHIST('Model':SKMMDL:X_SKMMDL)
     C                   ENDIF

      * PRE 7.00.00 FULL DEMO DATE.
     C                   IF        X_SKMDMO <> SKMDMO
     C                   CALLP     WRITEHIST('Pre 7.00.00 Demo Date':
     C                             %EDITW(SKMDMO:'    /  /  '):
     C                             %EDITW(X_SKMDMO:'    /  /  '))
     C                   ENDIF

      * MOVE SAVED MASTER BUFFER TO CURRENT BUFFER AND UPDATE. CHAIN TO LOCK.
     C                   EVAL      MSTDTA = MSTHLD
     C                   UPDATE    SKMREC

     C                   ENDSR

      **************************************************************************
     C     CHKCHGLIC     BEGSR

      * CHECK FOR CHANGES IN LICENSED PRODUCTS.

      * SAVE OFF CURRENT LICENSED KEY BUFFER AND BRING DB LIC REC.
     C                   EVAL      LICHLD = LICDTA
     C     LIC_KEY       CHAIN     SPYKEYLIC                          68

      * NUMBER USERS.
     C                   IF        SKPUTL = 'Y' AND X_SKL#US <> SKL#US
     C                   CALLP     WRITEHIST('Users:':
     C                             %TRIML(%EDITC(SKL#US:'Z')):
     C                             %TRIML(%EDITC(X_SKL#US:'Z')))
     C                   ENDIF

      * MOVE HELD LICENSED RECORD BUFFER TO CURRENT BUFFER AND UPDATE.
     C                   EVAL      LICDTA = LICHLD
     C                   UPDATE    SKLREC

     C                   ENDSR

      **************************************************************************
      * WRITE CHANGED DATA TO DETAIL HISTORY FILE.
     P WRITEHIST       B

     D WRITEHIST       PI
     D  DATAKEY                      25    VALUE
     D  CURRENT                      12    VALUE
     D  HISTORICAL                   12    VALUE
     D  PRODUCT#                      3  0 VALUE OPTIONS(*NOPASS)

     C                   IF        %PARMS = 4
     C     DESC_KEY      KLIST
     C                   KFLD                    SKMPFM
     C                   KFLD                    PRODUCT#
     C     DESC_KEY      CHAIN     SPYKEYPRD                          68
     C                   EVAL      DATAKEY = %TRIMR(DATAKEY) + ' ' + SKPDSC
     C                   EVAL      DATAKEY = %TRIML(DATAKEY)
     C                   ENDIF

     C                   EVAL      HSTDTA = MSTKEYDTA
     C                   EVAL      SKHDKY = DATAKEY
     C                   EVAL      SKHCFR = CURRENT
     C                   EVAL      SKHCTO = HISTORICAL
     c                   move      thdate        skhdlc
     c                   move      thtime        skhtlc
     c                   if        skhdlc = 0
     c                   move      *date         skhdlc
     c                   time                    skhtlc
     c                   endif
     c                   eval      skhulc = thuser
     c                   if        skhulc = ' '
     C                   EVAL      SKHULC = 'IMPORT'
     c                   endif
     C                   EVAL      SKHVER = X_SKMVER
     C                   IF        DATAKEY = 'Version' AND SKMVER <> X_SKMVER
     C                   EVAL      SKHVER = SKMVER
     C                   ENDIF
     C                   EVAL      SKHPRD = 0
     C                   IF        %PARMS = 4
     C                   EVAL      SKHPRD = PRODUCT#
     C                   ENDIF

     C                   WRITE     SKHREC

     P                 E
**ctdata prompts
Customer Serial Number  :
Customer Model Number . :
Software Release Number :
SpyView . . . . . . . . :
SpyLite . . . . . . . . :
Report Distribution . . :
Client Server . . . . . :
SpyImage  . . . . . . . :
SpyView Expiration Date :
SpyView KEY CODE  . . . :

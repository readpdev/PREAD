      * CRTOPT TGTRLS(*CURRENT) DFTACTGRP(*NO) ALWNULL(*YES)
      * CRTOPT DBGVIEW(*ALL)
     h datfmt(*iso)
     fpermpf    if   e           k disk
     fspykeymst uf a e           k disk
     fspykeylic uf a e           k disk
     fspykeyhis o    e             disk
     fspykeyprd if   e           k disk

     D WRITEHIST       PR
     D  DATAKEY                      25    VALUE
     D  CURRENT                      12    VALUE
     D  HISTORICAL                   12    VALUE
     D  PRODUCT#                      3  0 VALUE OPTIONS(*NOPASS)

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
     C                   KFLD                    skmsid
     C                   KFLD                    skmpfm
     C                   KFLD                    SKMIS#
     C                   KFLD                    sklprd

     c     prod_key      klist
     c                   kfld                    skmpfm
     c                   kfld                    sklprd

     c                   eval      skmpfm = '400'
     c                   eval      skmis# = 1
     c                   eval      skmdmo = *all'9'
     c                   eval      sklpfm = '400'
     c                   eval      sklis# = 1
     c                   eval      skldmo = 0

     c                   dow       1 = 1

     c                   read      permpf
     c                   if        %eof
     c                   leave
     c                   endif

     c                   eval      skmsid = impserial
     c                   eval      skmnam = impname
     c                   eval      skmmdl = impmodel
     c                   eval      skmftr = impfeature
     c                   eval      skmver = impversion

     c                   eval      sklsid = impserial
     c                   eval      sklprd = impprod#
     c                   eval      skl#us = imp#users
     c                   if        sklprd = 4 or sklprd = 5
     c                   eval      skl#us = 0
     c                   endif

      * When product# = 99...means a combination of spyview and rd.
      * Will create 2 licensed product records. One for spyview and one for rd.
     c                   if        sklprd = 99
     c                   do        2             x
     c                   select
     c                   when      x = 1
     c                   eval      sklprd = 1
     c                   exsr      products
     c                   when      x = 2
     c                   eval      sklprd = 4
     c                   endsl
     c                   enddo
     c                   endif

     c                   exsr      products

     c     mst_key       setll     spykeymst
     c                   if        %equal
     c                   exsr      chkchgmst
     c                   else
     c                   write     skmrec
     c                   endif

     c                   enddo

     c                   eval      *inlr = '1'

      **************************************************************************
     c     products      begsr

     c     lic_key       setll     spykeylic
     c                   if        %equal
     c                   exsr      chkchglic
     c                   else
     c                   write     sklrec
     c                   callp     writehist('':'':'*ADDED':sklprd)
     c                   endif

     c                   endsr

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
     c                   if        licdta <> lichld
     C                   EVAL      LICDTA = LICHLD
     C                   UPDATE    SKLREC
     c                   endif

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
     c                   eval      skhdlc = impchgdate
     c                   eval      skhtlc = impchgtime
     c                   eval      skhulc = impchgusr
     C                   EVAL      SKHVER = skmver
     C                   IF        DATAKEY = 'Version' AND SKMVER <> X_SKMVER
     C                   EVAL      SKHVER = SKMVER
     C                   ENDIF
     C                   EVAL      SKHPRD = impprod#
     C                   IF        %PARMS = 4
     C                   EVAL      SKHPRD = PRODUCT#
     C                   ENDIF

     C                   WRITE     SKHREC

     P                 E

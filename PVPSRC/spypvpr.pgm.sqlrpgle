      *%METADATA                                                       *
      * %TEXT Document Pointer Validation Procedure                    *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp('DOCMGR') bnddir('SPYBNDDIR')
      *********--------------------------
      * SPYPVPR VERIFY ARCHIVED DOCUMENT POINTERS
      *********--------------------------
      *
J2169 * 10-30-09 PLR Validate offline report internal spool file number, too.
J2136 * 10-20-09 PLR Was trying to process native PDF documents as AFP.
/8879 *  3-08-04 JMO Added DATFOP to parms for MAG1040.
/8738 * 12-05-03 JMO Added additional logic for report RRN validation.
/     *                The Job number, spool number and Spool file opened date
/     *                will be passed to MAG1040 to be used to validate RRNs.
/8722 * 12-04-03 JMO Added logic to validate AFP data files.
/3868 *  2-08-01 DLS prior patch for mag1040 parm list does not work when
/3868 *              observability is removed.
/3868 *              Added spylink verification for dasd same same as optical
/3868 *              if mismatch found.
/3487 *  2-01-01 DLS add detection for number of parameters required for call to
/3487 *              MAG1040.  This is required after P3717HQ and SPYPVP is not
/3487 *              version specific.
      *
/3487 *  1-19-01 DLS new parm and logic.
      *  Ok, the new version of SPYPVPR is in TSTOOLS.  Under this logic the following is true:
      *  Return file count   Header record file count    Include SpyLinks mismatch    Error Reported
      *          1                      2                        *YES                     ERR2105
      *          1                      2                        *NO               no error reported
      *          0                      2                        *YES                     ERR2104
      *          0                      2                        *NO                      ERR2104
      *
/3487 * 12-13-00 DLS NEW PROGRAM
      *
     FMFLDDIR   IF   E           K DISK    USROPN
     FMFLDDIR2  IF   E           K DISK    USROPN
     F                                     RENAME(FLDDIR:FLDDIR2)
     FMRPTDIR1  IF   E           K DISK
     FMIMGDIR6  IF   E           K DISK    USROPN
     FMOPTTBL1  IF   E           K DISK
     FRapfDbf   IF   E           K DISK    USROPN
     FSPYPVPF   O    E             DISK

/8722 /copy @masplio

/8722 /copy qsysinc/qrpglesrc,Qusrspla

/8738d filnub          s              9b 0
      *
     D CL              S             59    DIM(8) CTDATA PERRCD(1)
     D ER              S              2  0 DIM(12) CTDATA PERRCD(1)             Error#table
     D ERM             S              7    DIM(12) ALT(ER)                      Message code
      *
     D PCATR           DS          1024
     D  FMTSPY                 1      3
     D  FMTVER                 1      5
     D  PCIDX#                 6      8
     D  PCSIZE                 9     17
     D  PCFILE                18     42
     D  PCEXT                 43     47
     D  PCDATE                48     55
     D  PCTIME                56     61
     D  PCPATH                62    311
     D  PCUDAT               312    319
     D  PCUTIM               320    325
     D  PCUSR                326    335
     D  PCNODE               336    352
     D  PCOSV                353    358
     D  PCSPYV               359    364
     D  PCSYS                365    369
      *
     D SDT             DS          7680
     D DTA             S            256    DIM(512)
      *
     D ODDTA           DS           256
J2169d  atrSplNbr             86     89i 0
      *
     D ERRCD           DS
     D  @ERCON                 9     15
     D  @ERDTA                17    116
      *
     D OKEY            DS
     D  OKEYP                  1     20
     D  FLDR                   1     10
     D  FLDRLB                11     20
     D  FILNAM                21     30
     D  JOBNAM                31     40
     D  USRNAM                41     50
     D  JOBNUM                51     56
     D  FILNUM                57     60B 0
      *
     D SYMD            DS
     D  SYY                    1      2  0
     D  SMM                    3      4  0
     D  SDD                    5      6  0
      *
     D @DATE           DS
     D  DT1                    1      2
     D  DT2                    3      4
     D  DT3                    5      6
      *
     D                 DS
     D  CTIME                  1      6  0
     D  CHH                    1      2  0
     D  CMM                    3      4  0
     D  CSS                    5      6  0

/8738d RptHdrInf       DS
/    d  rh_filna              21     30
/    d  rh_jobna              31     40
/    d  rh_usrna              41     50
/    d  rh_jobnu              51     56
/    d  rh_filnu              57     60B 0
/8738d  rh_DatFoA            204    207a
/8738d  rh_DatFop            204    207B 0
      *
     d AfileName       s             10a
     d rc              s             10i 0
     D PSCON           C                   CONST('PSCON     *LIBL     ')
      *
     c*                  eval      clcmd = 'OVRPRTF FILE(QSYSPRT) ' +
     c*                            'PAGESIZE(*N 198) CPI(15) ' +
     c*                            'OVRSCOPE(*CALLLVL)'
     c*                  exsr      runcl
     c*                  open(e)   Qsysprt
      *
     C     WRPTS         IFEQ      '*YES'                                       INCLUDE RPT
     C*                  EXCEPT    PRTHED
      *
     C                   EXSR      @READF                                       Read FLDDIR
      *
     C                   MOVE      'RPORT'       ACTION            5
      *------------
      * Folder loop
      *------------
     C     *IN20         DOWEQ     *OFF
      *
     C     FLDCOD        CAT       FLDLIB        WKEYP            20
     C                   MOVE      *BLANKS       OKEY
      *
     C     FLDDKY        SETLL     RPTDIR
     C     FLDDKY        KLIST
     C                   KFLD                    FLDCOD
     C                   KFLD                    FLDLIB
      *------------------
      * Report inner loop
      *------------------
     C                   EXSR      @GETR                                        Read RptDir
     C     *IN21         DOWEQ     *OFF
     C                   CLEAR                   ERR#
     C                   CLEAR                   @ERCON
      *
     C                   SELECT
      * DASD
     C     REPLOC        WHENEQ    ' '
     C     REPLOC        OREQ      '0'
     C     REPLOC        OREQ      '5'                                          R/dars qdls
     C                   EXSR      CHKRPT
      * Tape
     C     REPLOC        WHENEQ    '1'
     C                   MOVEL(P)  'ERR1386'     @ERCON
      * Optical
     C     REPLOC        WHENEQ    '2'                                          OPTICAL
     C     REPLOC        OREQ      '4'                                          R/dars
     C     REPLOC        OREQ      '6'                                          Imageview
     C                   EXSR      CHKORP
     C                   ENDSL
      *
     C                   EXSR      @GETR                                        Read RptDir
     C                   ENDDO
      * Finish folder
      *
     C                   EXSR      @READF                                       Read FLDDIR
     C                   ENDDO
     c*                  EXCEPT    ENDLIS
     C                   END
      *
     C     WIMGR         IFEQ      '*YES'                                       INCLUDE IMG
     c*                  EXCEPT    PRTHDI
     C                   MOVE      'IMAGE'       ACTION
     C                   EXSR      RUNQRY
     C                   EXSR      @GETI                                        Read ImgDir
     C     *IN20         DOWEQ     *OFF
     C                   CLEAR                   ERR#
     C                   CLEAR                   @ERCON
      *
     C                   SELECT
      * DASD
     C     IDILOC        WHENEQ    ' '
     C     IDILOC        OREQ      '0'
     C     IDILOC        OREQ      '3'
     C                   EXSR      CHKIMG
      * Tape
     C     IDILOC        WHENEQ    '1'
     C                   MOVEL(P)  'ERR1386'     @ERCON
      * Optical
     C     IDILOC        WHENEQ    '2'
     C                   EXSR      CHKOIM
     C                   ENDSL
      *
     C     @ERCON        IFNE      *BLANKS
     C                   EXSR      BADRPT                                        Blah...
     C                   END
      *
     C                   EXSR      @GETI                                        Read ImgDir
     C                   ENDDO
     c*                  EXCEPT    ENDLIS
     C                   END
      *
     C                   EXSR      @QUIT
      *
      ************************************************************************
     C     CHKRPT        BEGSR
      *          ----------------------------------------------
      *          Check the integrity of the next report.
      *          If any of the 'CHK' subrs error, rtn ERR# <> 0
      *          ----------------------------------------------
     C                   move      '0'           *in99
/8738c                   eval      filnub = filnum
     C                   CALL      'MAG1040'                            99
     C                   PARM                    FLDR
     C                   PARM                    FLDRLB
     C                   PARM                    LOCSFA
     C                   PARM                    ENDRRN
     C                   PARM                    REPLOC
     C                   PARM                    ACTION
     C                   PARM                    ERR#              2 0
/3487C                   PARM      '*NO '        ignopn            4
/8738C                   parm      jobnum        @jobnr            6
/8738C                   parm                    filnub
/8879C                   parm      mdatop        mdatop7           7 0
/8879C                   parm      datfop        datfop7           7 0
/     *
/    C     *in99         ifeq      *on
/    C                   CALL      'MAG1040'
/    C                   PARM                    FLDR
/    C                   PARM                    FLDRLB
/    C                   PARM                    LOCSFA
/    C                   PARM                    ENDRRN
/    C                   PARM                    REPLOC
/    C                   PARM                    ACTION
/    C                   PARM                    ERR#              2 0
/3487C                   END
      *
     C     ERR#          IFGT      0
     C                   EXSR      ERRLOK
     C                   EXSR      BADRPT                                        Blah...
     C                   END
/8722
/     * verify A-file
/    c                   if        Apfnam <> *blanks
J2136c                             and Apftyp <> *blanks and apftyp <> '4'
8722 c                   exsr      CkAfilDasd
/    c                   endif
      *
     C                   ENDSR
      *
      ************************************************************************
     C     CHKORP        BEGSR
      *          ----------------------------------------------
      *          Check the integrity of the optical report
      *          ----------------------------------------------
     C                   MOVE      'TABLE'       ODOPC
     c     locsfa        sub       1             locsfh            9 0
     C                   MOVEL     LOCSFh        ODKEY
     C                   MOVEL     LOCSFh        ODRRN
     C                   MOVE      *blanks       ODINLR
      *
     C                   CALL      'MAG1053'     PL1053                 50      Optical Drv
     C     PL1053        PLIST
     C                   PARM      'QTEMP'       ODLIB            10            Library
     C                   PARM      OFRNAM        ODFILE           10            Object
     C                   PARM                    ODFILE                         Member
     C                   PARM                    ODKEY            99            Key
     C                   PARM      '00'          ODKYL             2            KeyLength 00
     C                   PARM                    ODOPC             5            Oper 'READ '
     C                   PARM                    ODRRN             9 0          Folder RRN 1
     C                   PARM      *OFF          ODINHI            1            Ind High
     C                   PARM      *OFF          ODINLO            1            Ind Low
     C                   PARM      *OFF          ODINEQ            1            Ind Equal
     C                   PARM                    ODINLR            1            Ind LR
     C                   PARM      *BLANKS       ODRTNI            7            Return MSGID
     C                   PARM      *BLANKS       ODRTND          100            Return MSGDTA
     C                   PARM                    ODDTA                          Return
     C                   PARM                    REPLOC                         File locatio
     C                   PARM                    REPIND                         SpyNum
     C                   PARM                    RFIL#             9 0          File#
     C                   PARM                    ROFFS            11 0          Segment offs
      *
     c                   Select
     c                   when      *in50 = *on
     C                   MOVEL(P)  'ERR2104'     @ERCON
     C                   EXSR      BADRPT                                        write error

     c                   when      ODRTND <> *blanks
     C                   MOVEL(P)  ODRTNI        @ERCON
     C                   EXSR      BADRPT                                        write error

/8738c                   other

/8738c                   eval      datfop7 = mdatop
/
/    c                   eval      RptHdrInf = %subst(oddta:3:254)
/    c                   move      filnum        SplNbr4           4 0
/    c                   if        jobnum <> rh_jobnu or
/    c                             (rh_DatFoA <> *blanks and
/    c                             Datfop7 <> rh_DatFop) or
/    c                             (filnum <> rh_filnu and
/    c                              SplNbr4 <> rh_filnu)
/    c                   eval      err# = 27
/    C                   EXSR      ERRLOK
/    C                   EXSR      BADRPT                                        Blah...
/    c                   endif
/8738
     C                   endsl

J2169c                   if        err# = 0
/    c                   eval      locsfh = locsfa
/    c                   movel     locsfh        odkey
/    c                   movel     locsfh        odrrn
/    c                   call      'MAG1053'     pl1053                 50      optical drv
/    c                   if        not *in50 and atrSplNbr = 0
/    c                   eval      err# = 35
/    c                   exsr      errlok
/    c                   exsr      badrpt                                        blah...
/    c                   endif
/    c                   endif

     C                   MOVEL(P)  '*ALL'        ODLIB                          Optical
     C                   MOVEL(P)  '*ALL'        ODFILE
     C                   MOVE      '1'           ODINLR
     C                   CALL      'MAG1053'     PL1053
/8722
/     * verify A-file
/    c                   if        Apfnam <> *blanks
/    c                             and Apftyp <> *blanks
/    c                   exsr      CkAfilOpt
/    c                   endif

     C                   ENDSR
      *
     c*-----------------------------------------------------------------------
     c*- CkAfilDasd - Verify A-file(s) on DASD
     c*-----------------------------------------------------------------------
     c     CkAfilDasd    begsr

     c                   eval      clcmd = 'OVRDBF FILE(RAPFDBF) TOFILE(' +
     c                             %trim(fldlib) + '/' + %trim(Apfnam) +
     c                             ') OVRSCOPE(*CALLLVL)'
     c                   exsr      runcl
     c                   if        *in99 = *off

     c                   open(e)   Rapfdbf
     c                   if        not %open(Rapfdbf)
     c                   eval      @ercon = 'ERR2113'
     c                   eval      @erdta = Apfnam + Fldlib
     c                   exsr      BadRpt

     c                   else

      * get the attribute record from the A-file
     c     Repind        chain(e)  RapfDbf
     c                   if        %error or not %found
     c                   eval      @ercon = 'ERR2115'
     c                   eval      @erdta = Apfnam
     c                   exsr      BadRpt
     c                   else
      * check for valid and correct attributes
     c                   eval      rc = setSplfAts(%addr(apfdta)+4:
     c                              %addr(Qusa0200):%size(Qusa0200))
     c                   move      filnum        filnu4            4 0
     c                   move      Qusdfilo00    DateOpn7          7 0
     c                   if        rc < #SPL_OK
     c                             or Qusjnbr10 <> jobnum
     c                             or DateOpn7 <> datfop
     c                             or (Qussnbr00 <> filnum and
     c                               Qussnbr00 <> filnu4)
     c                   eval      @ercon = 'ERR2117'
     c                   eval      @erdta = Apfnam + Fldlib + Repind
     c                   exsr      BadRpt
     c                   endif

     c                   endif

     c                   close(e)  Rapfdbf
     c                   endif

     c                   eval      clcmd = 'DLTOVR FILE(RAPFDBF) LVL(*)'
     c                   exsr      runcl
     c                   endif

     c                   endsr
     c*-----------------------------------------------------------------------
     c*- CkAfilOpt - Verify A-file(s) on Optical
     c*-----------------------------------------------------------------------
     c     CkAfilOpt     begsr

     c                   eval      @ercon = *blanks
     c                   eval      @erdta = *blanks

      * if the optical name or volume in MRPTDIR is not given then set error
     c                   if        ofrnam = *blanks or
     c                             ofrvol = *blanks
     c                   eval      @ercon = 'ERR2119'
     c                   eval      @erdta = *blanks
     c                   exsr      BadRpt

     c                   else

      * check for "new" AFP data file name on optical  (Annnnnnnss)
     c                   eval      aFileName = 'A' + %subst(OfrNam:2:7) + '00'
     c     aFileName     Chain(e)  MoptTbl1
     c                   if        %error or not %found
      * check for "old" AFP data file name on optical  (SnnnnnnnA0)
     c                   eval      aFileName = %subst(OfrNam:1:8) + 'A0'
     c     aFileName     Chain(e)  MoptTbl1
      * if neither AFP data file is found then flag error
     c                   if        %error or not %found
     c                   eval      @ercon = 'ERR2122'
     c                   eval      @erdta = Fldcod + Fldlib + Repind
     c                   exsr      BadRpt
     c                   endif
     c                   endif

     c                   if        @ercon = *blanks

      * if the AFP data file was found then attempt to retreive the file attribute record
     c                   eval      evol = optvol
     c                   eval      edir = '/SPYGLASS/' + %trim(optlib) + '/' +
     c                             %trim(optfdr)
     c                   eval      efile = optfil
     c                   call      'MAG1091'     pl1091
      * error reading optical file
     c                   if        erMsgID <> *blanks
     c                   eval      @ercon = 'ERR2123'
     c                   eval      @erdta = eFile + eVol
     c                   exsr      BadRpt
     c                   else
      * check for valid and correct attributes
     c                   eval      rc = setSplfAts(%addr(eDta)+4:
     c                              %addr(Qusa0200):%size(Qusa0200))
     c                   move      filnum        filnu4            4 0
     c                   move      Qusdfilo00    DateOpn7          7 0
     c                   if        rc < #SPL_OK
     c                             or Qusjnbr10 <> jobnum
     c                             or DateOpn7 <> datfop
     c                             or (Qussnbr00 <> filnum and
     c                               Qussnbr00 <> filnu4)
     c                   eval      @ercon = 'ERR2124'
     c                   eval      @erdta = *blanks
     c                   exsr      BadRpt
     c                   endif
     c
     c                   endif
     c                   endif

     c                   endif

      * check for AFP data on DASD if error found on optical
     c                   if        @ercon <> *blanks

     c                   eval      clcmd = 'OVRDBF FILE(RAPFDBF) TOFILE(' +
     c                             %trim(fldlib) + '/' + %trim(Apfnam) +
     c                             ') OVRSCOPE(*CALLLVL)'
     c                   exsr      runcl
     c                   open(e)   Rapfdbf
     c                   if        not %open(Rapfdbf)
     c                   eval      @ercon = 'ERR2125'
     c                   eval      @erdta = *blanks
     c                   exsr      BadRpt
     c                   else

     c     Repind        chain(e)  RapfDbf
     c                   if        %error or not %found
     c                   eval      @ercon = 'ERR2125'
     c                   eval      @erdta = *blanks
     c                   exsr      BadRpt
     c                   else

     c                   eval      rc = setSplfAts(%addr(apfdta)+4:
     c                              %addr(Qusa0200):%size(Qusa0200))
     c                   move      Qusdfilo00    DateOpn7          7 0
     c                   if        rc < #SPL_OK
     c                   eval      @ercon = 'ERR2125'
     c                   else
     c                   eval      @ercon = 'ERR2126'
     c                   endif
     c                   eval      @erdta = *blanks
     c                   exsr      BadRpt
     c                   endif

     c                   close(e)  Rapfdbf
     c                   endif

     c                   eval      clcmd = 'DLTOVR FILE(RAPFDBF) LVL(*)'
     c                   exsr      runcl

     c                   endif

     c     pl1091        plist
     c                   parm                    EOPTID           10
     c                   parm                    EOPDRV           15
     c                   parm                    EVOL             12
     c                   parm                    EDIR             80
     c                   parm                    EFILE            12
     c                   parm      1             FOFSET           13 0
     c                   parm      *blanks       eDta           4079
     c                   parm      4079          EDTASZ            6 0
     c                   parm      '1'           ECLSP             1
     c                   parm                    eLoc              1            Storage location
     c                   parm                    eTyp              1            Document type
     c                   parm      *blanks       erMsgID           7            return message ID
     c                   parm      *blanks       erMsgDta        100            return message data

     c                   endsr
      ************************************************************************
     C     CHKIMG        BEGSR
      *          ----------------------------------------------
      *          Check the integrity of the next report.
      *          If any of the 'CHK' subrs error, rtn ERR# <> 0
      *          ----------------------------------------------
     C                   move      '0'           *in99
     C                   CALL      'MAG1040'                            99
     C                   PARM                    IDPFIL
     C                   PARM                    IDFLIB
     C                   PARM                    IDBBGN
     C                   PARM                    IDBEND
     C                   PARM                    IDILOC
     C                   PARM                    ACTION
     C                   PARM                    ERR#
/    C                   PARM      '*NO '        ignopn
/     *
/    C     *in99         ifeq      *on
/    C                   CALL      'MAG1040'
/    C                   PARM                    IDPFIL
/    C                   PARM                    IDFLIB
/    C                   PARM                    IDBBGN
/    C                   PARM                    IDBEND
/    C                   PARM                    IDILOC
/    C                   PARM                    ACTION
/    C                   PARM                    ERR#
/3487C                   END
      *
     C     ERR#          IFGT      0
     C                   EXSR      ERRLOK
/3868 *
/    C                   ELSE
/    C                   MOVEL(P)  'READ'        OPCODE
/    C     1             ADD       IDICNT        RTNREC
/    C                   CALL      'SPYCSFIL'    PLFIL                  50
/     *
/    C     *IN50         IFEQ      *ON
/    C     RTNCS         OREQ      '30'
/    C     RTNCS         OREQ      '20'
/    C     RTNREC        ANDNE     IDICNT
/     *
/    C     RTNRec        IFNE      IDICNT
/    C     RTNRec        ANDNE     0
/     *
/    C     WSLNK         IFEQ      '*YES'                                       INCLUDE
/    C                   MOVEL(P)  'ERR2105'     @ERCON                         SPYLINK
/    C                   MOVE      RTNRec        RTNRCH            8            MISMATCH
/    C                   MOVE      IDICNT        IDICCH            8
/    C     RTNRCH        CAT(P)    IDICCH:0      @ERDTA
/    C                   ENDIF
/     *
/    C                   ELSE
/    C                   MOVEL(P)  'ERR2104'     @ERCON
/    C                   ENDIF
/    C                   ENDIF
/    C                   MOVEL(P)  'QUIT'        OPCODE
/3868C                   CALL      'SPYCSFIL'    PLFIL
     C                   END
      *
     C                   ENDSR
      *
      ************************************************************************
     C     CHKOIM        BEGSR
      *          ----------------------------------------------
      *          Check the integrity of the optical imgage
      *          ----------------------------------------------
     C                   MOVE      '1'           CLCSFL            1
     C                   MOVEL(P)  'READ'        OPCODE
     C     1             ADD       IDICNT        RTNREC
     C                   CALL      'SPYCSFIL'    PLFIL                  50
     C     PLFIL         PLIST
     C                   PARM      'WRKBCH'      PRMWIN           10        WIDNOW
     C                   PARM      IDBNUM        PRMBCH           10        Batch ID
     C                   PARM                    OPCODE            6        Opcode
     C                   PARM                    SETSEQ            9        Pos. Seq. Number
     C                   PARM                    SDT                        Return data
     C                   PARM                    RTNREC            9 0      Rtn # of rec
     C                   PARM                    RTNCS             2        Return code
      *
     C     *IN50         IFEQ      *ON
     C     RTNCS         OREQ      '30'
     C     RTNCS         OREQ      '20'
     C     RTNREC        ANDNE     IDICNT
     C                   Z-ADD     RTNREC        RTNRSV            9 0
     C                   MOVEL(P)  'QUIT'        OPCODE
     C                   CALL      'SPYCSFIL'    PLFIL
     C                   CLEAR                   CLCSFL
      *
     C                   MOVEL(p)  'GETATR'      PCOPCD
     C                   CALL      'MAG1092'     PL1092                 50
     C     PL1092        PLIST
     C                   PARM                    PCOPCD           10
     C                   PARM      IDBNUM        PCBTCH           10
     C                   PARM      OPBBGN        PCIRRN            9 0
     C                   PARM                    PCSTOF            9 0
     C                   PARM                    PCBREQ            9 0
     C                   PARM      'Y'           PCCACH            1
     C                   PARM                    PCISIZ            9 0
     C                   PARM                    PCBRET            9 0
     C                   PARM                    PCNRRN            9 0
     C                   PARM                    PCATR
     C                   PARM                    DTA
     C                   PARM                    PCRTNC            7
     C                   PARM                    PCRTND          100
      *
     C     *IN50         IFEQ      *ON
     C     PCRTNC        OREQ      *BLANKS
      *
     C     RTNRSV        IFNE      IDICNT
     C     RTNRSV        ANDNE     0
      *
     C     WSLNK         IFEQ      '*YES'                                       INCLUDE
     C                   MOVEL(P)  'ERR2105'     @ERCON                         SPYLINK
     C                   MOVE      RTNRSV        RTNRCH            8            MISMATCH
     C                   MOVE      IDICNT        IDICCH            8
     C     RTNRCH        CAT(P)    IDICCH:0      @ERDTA
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL(P)  'ERR2104'     @ERCON
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL(P)  PCRTNC        @ERCON
     C                   ENDIF
      *
     C                   MOVEL(p)  'CLOSEW'      PCOPCD
     C                   CALL      'MAG1092'     PL1092
      *
     C                   ENDIF
      *
     C     CLCSFL        IFEQ      *ON                                          Close
     C                   MOVEL(P)  'QUIT'        OPCODE
     C                   CALL      'SPYCSFIL'    PLFIL
     C                   CLEAR                   CLCSFL
     C                   END
      *
     C                   ENDSR
      *
      ************************************************************************
     C     ERRLOK        BEGSR
      *          Get error code
     C                   Z-ADD     1             X                 5 0
     C     ERR#          LOOKUP    ER(X)                                  99     Eq
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  ERM(X)        @ERCON
     C                   ELSE
     C                   MOVEL(P)  'ERR2104'     @ERCON
     C                   ENDIF
     C                   ENDSR
      *
      ************************************************************************
     C     BADRPT        BEGSR
      *          Bad report
      *          Get text for error
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        ERRMSG           80
      *
      /free
       if action = 'RPORT';
         clear spypvpr;
         spfldr = fldcod;
         spflib = fldlib;
         spclass = rpttyp;
         spdocid = repind;
         if reploc = '2';
           sppfil = ofrnam;
           spvoln = ofrvol;
         endif;
       else;
         clear spypvpr;
         spfldr = idfld;
         spflib = idflib;
         spclass = iddoct;
         spdocid = idbnum;
         sppfil = idpfil;
         if idiloc = '2';
           exec sql select optvol into :spvoln from mopttbl
             where optrnm = :idbnum;
         endif;
       endif;
      /end-free

     C                   MOVEL     @ERCON        SPERRN
     C                   WRITE     SPYPVPR
     C                   ENDSR
      *
      ************************************************************************
     C     @GETR         BEGSR
      *          Get RptDir record for the next report.
      *
     C                   DO        *HIVAL
     C                   READ      RPTDIR                                 21
      *
     C                   SELECT
     C     *IN21         WHENEQ    *ON                                          Like READE
     C     OKEYP         ORNE      WKEYP                                         fld|lib
     C                   MOVE      *ON           *IN21
     C                   LEAVE                                                  Exit loop
      * DASD
     C     REPLOC        WHENEQ    ' '
     C     REPLOC        OREQ      '0'
     C     REPLOC        OREQ      '5'                                          R/dars qdls
     C                   LEAVE                                                  Exit w/recrd
      * Tape
     C     REPLOC        WHENEQ    '1'
     C                   LEAVE                                                  Exit w/recrd
      * Optical
     C     REPLOC        WHENEQ    '2'                                          OPTICAL
     C     REPLOC        OREQ      '4'                                          R/dars
     C     REPLOC        OREQ      '6'                                          Imageview
      *
     C     WOPTV         IFEQ      '*ALL'
     C     WOPTV         OREQ      OFRVOL                                       IMAGEVIEW
     C                   LEAVE
     C                   END
     C                   ENDSL
     C                   ENDDO
     C                   ENDSR
      *
      ************************************************************************
     C     @GETI         BEGSR
      *          Get ImgDir record for the next image.
      *
     C                   DO        *HIVAL
     C                   READ      IMGDIR                                 20
      *
     C                   SELECT
     C     *IN20         WHENEQ    *ON
     C                   LEAVE                                                  Exit loop
      * DASD
     C     IDILOC        WHENEQ    ' '
     C     IDILOC        OREQ      '0'
     C     IDILOC        OREQ      '3'
     C                   LEAVE                                                  Exit w/recrd
      * Tape
     C     IDILOC        WHENEQ    '1'
     C                   LEAVE                                                  Exit w/recrd
      * Optical
     C     IDILOC        WHENEQ    '2'                                          OPTICAL
      *
     C     WOPTV         IFNE      '*NONE'
     C     IDPFIL        CHAIN     MOPTTBL1                           99
     C     *IN99         IFEQ      *OFF
     C     WOPTV         ANDEQ     '*ALL'
     C     *IN99         OREQ      *OFF
     C     WOPTV         ANDEQ     OPTVOL                                       IMAGEVIEW
     C                   LEAVE
     C                   END
     C                   END
     C                   ENDSL
     C                   ENDDO
     C                   ENDSR
      *
      ************************************************************************
     C     @READF        BEGSR
      *          Read a Folder Directory record
      *
      *          DOMAIN......... ALAF = All librs  All fldrs
      *                          1L1F = One libr   One fldr
      *                          1LAF = One libr   All fldrs
      *                          AL1F = All librs  One fldr
      *
     C                   SELECT
     C     DOMAIN        WHENEQ    'ALAF'
     C                   READ      MFLDDIR                                20
     C     DOMAIN        WHENEQ    '1L1F'
     C     FLDKY         READE     MFLDDIR                                20
     C     DOMAIN        WHENEQ    'AL1F'
     C     WFOLD         READE     MFLDDIR                                20
     C     DOMAIN        WHENEQ    '1LAF'
     C     WLIBR         READE     MFLDDIR2                               20
     C                   ENDSL
      *
     C                   ENDSR
      *
      ************************************************************************
     C     RTVMSG        BEGSR
      *          -------------------------------
      *          Retrieve message from PSCON
      *          -------------------------------
     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80
     C                   MOVE      *BLANKS       @ERDTA
     C                   ENDSR
      *
      ************************************************************************
     C     RUNQRY        BEGSR
      *          Set up and run QRY.
      *
     C                   MOVEL(P)  CL(3)         CLCMD                          OvrDbf
     C                   EXSR      RUNCL
      * QRY
     C     CL(1)         CAT(P)    CL(2):1       CLCMD                          OpnQryF
      *
     C     WLIBR         IFNE      '*ALL'
     C     WFOLD         ORNE      '*ALL'
     C     WOPTV         OREQ      '*NONE'
     C                   CAT       CL(4):1       CLCMD
     C     WOPTV         IFEQ      '*NONE'
     C                   CAT       CL(8):0       CLCMD
     C                   END
      *
     C     WFOLD         IFNE      '*ALL'
     C     WOPTV         IFEQ      '*NONE'
     C                   CAT       '*AND (':1    CLCMD
     C                   ElSE
     C                   CAT       '(':0         CLCMD
     C                   END
     C                   CAT       'IDFLD':0     CLCMD
     C     '*'           SCAN      WFOLD                                  99
     C                   CAT       '*EQ':1       CLCMD
     C   99              CAT       CL(5):1       CLCMD
     C  N99              CAT       '"':1         CLCMD
     C                   CAT       WFOLD:0       CLCMD
     C                   CAT       '")':0        CLCMD
     C   99              CAT       ')':0         CLCMD
     C                   END
      *
     C     WLIBR         IFNE      '*ALL'
     C     WFOLD         IFNE      '*ALL'
     C     WOPTV         OREQ      '*NONE'
     C                   CAT       '*AND (':1    CLCMD
     C                   ElSE
     C                   CAT       '(':0         CLCMD
     C                   END
     C                   CAT       'IDFLIB':0    CLCMD
     C     '*'           SCAN      WLIBR                                  99
     C                   CAT       '*EQ':1       CLCMD
     C   99              CAT       CL(5):1       CLCMD
     C  N99              CAT       '"':1         CLCMD
     C                   CAT       WLIBR:0       CLCMD
     C                   CAT       '")':0        CLCMD
     C   99              CAT       ')':0         CLCMD
     C                   END
      *
     C                   CAT       ''')':0       CLCMD                          CloseQryLine
     C                   END
     C                   EXSR      RUNCL
     C                   OPEN      MIMGDIR6
     C                   ENDSR
      *
      ************************************************************************
     C     RUNCL         BEGSR
     C                   CALL      'QCMDEXC'     PLCL                   99
     C     PLCL          PLIST
     C                   PARM                    CLCMD           255
     C                   PARM      255           CLLEN            15 5
     C                   ENDSR
      *
      ************************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    WFOLD            10            Folder
     C                   PARM                    WLIBR            10            Library
     C                   PARM                    WOPTV            12            INCLUDE OPT
     C                   PARM                    WRPTS             4            INCLUDE RPT
     C                   PARM                    WIMGR             4            INCLUDE IMG
     C                   PARM                    WSLNK             4            INCLUDE lnk
     C                   PARM                    RTNCDE            8            Return Code
      *-------------------------------------------------------------
      * Set DOMAIN & SETLL for the range of librs & fldrs we process
      *          ALAF = All librs  All fldrs
      *          AL1F = All librs  One fldr
      *          1L1F = One libr   One fldr
      *          1LAF = One libr   All fldrs
      *-------------------------------------------------------------
     C     WRPTS         IFEQ      '*YES'                                       INCLUDE RPT
     C                   SELECT
     C     WFOLD         WHENEQ    '*ALL'
     C     WLIBR         ANDEQ     '*ALL'
     C                   MOVE      'ALAF'        DOMAIN            4
     C                   OPEN      MFLDDIR
     C     *LOVAL        SETLL     MFLDDIR
      *
     C     WLIBR         WHENEQ    '*ALL'
     C                   MOVE      'AL1F'        DOMAIN
     C                   OPEN      MFLDDIR
     C     WFOLD         SETLL     MFLDDIR
      *
     C     WFOLD         WHENEQ    '*ALL'
     C                   MOVE      '1LAF'        DOMAIN
     C                   OPEN      MFLDDIR2
     C     WLIBR         SETLL     MFLDDIR2
      *
     C                   OTHER
     C                   MOVE      '1L1F'        DOMAIN
     C                   OPEN      MFLDDIR
     C     FLDKY         SETLL     MFLDDIR
     C     FLDKY         KLIST
     C                   KFLD                    WFOLD
     C                   KFLD                    WLIBR
     C                   ENDSL
     C                   END
      *
     C                   MOVE      WFOLD         FLDCOD
     C                   MOVE      WLIBR         FLDLIB
      *
     C                   CALL      'MAG1047'                              99
     C                   PARM                    YMDNUM            9 0
     C                   PARM                    YMD               8
      *
     C                   CALL      'MAG8090'
     C                   PARM                    DATFMT            3
     C                   PARM                    DATSEP            1
     C                   PARM                    TIMSEP            1
      *
     C     DATFMT        IFEQ      *BLANKS
     C                   MOVE      'MDY'         DATFMT
     C                   END
      *
     C                   MOVE      YMD           SYMD
     C*
     C* Format Dates.
     C*
     C                   SELECT
     C     DATFMT        WHENEQ    'YMD'
     C                   MOVE      SYY           DT1
     C                   MOVE      SMM           DT2
     C                   MOVE      SDD           DT3
     C     DATFMT        WHENEQ    'MDY'
     C                   MOVE      SMM           DT1
     C                   MOVE      SDD           DT2
     C                   MOVE      SYY           DT3
     C     DATFMT        WHENEQ    'DMY'
     C                   MOVE      SDD           DT1
     C                   MOVE      SMM           DT2
     C                   MOVE      SYY           DT3
     C                   ENDSL
      *
     C                   MOVEL(P)  DT1           DATTIM           18
     C                   CAT       DATSEP:0      DATTIM
     C                   CAT       DT2:0         DATTIM
     C                   CAT       DATSEP:0      DATTIM
     C                   CAT       DT3:0         DATTIM
      *
     C                   TIME                    CTIME
     C                   MOVE      CTIME         @DATE
     C                   CAT       DT1:2         DATTIM
     C                   CAT       TIMSEP:0      DATTIM
     C                   CAT       DT2:0         DATTIM
     C                   CAT       TIMSEP:0      DATTIM
     C                   CAT       DT3:0         DATTIM
      *
     C     *LIKE         DEFINE    LOCSFA        ENDRRN
     C                   CLEAR                   SETSEQ
      *
     C                   ENDSR
      *
      ************************************************************************
     C     @QUIT         BEGSR
      *
     C     WRPTS         IFEQ      '*YES'                                       INCLUDE RPT
     C     DOMAIN        IFEQ      '1LAF'
     C                   CLOSE     MFLDDIR2
     C                   ELSE
     C                   CLOSE     MFLDDIR
     C                   END
     C                   END
      *
     C     WIMGR         IFEQ      '*YES'                                       INCLUDE IMG
     C                   CLOSE     MFLDDIR
     C                   MOVEL(P)  CL(6)         CLCMD                          CLOSE QRY
     C                   EXSR      RUNCL
     C                   MOVEL(P)  CL(7)         CLCMD                          DLTOVR
     C                   EXSR      RUNCL
     C                   END
      *
     c*                  close(e)  Qsysprt
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *
** CL
OPNQRYF FILE((MIMGDIR6))                                   1
KEYFLD((IDFLD) (IDFLIB) (IDPFIL) (IDBNUM))                 2
OVRDBF FILE(MIMGDIR6) SHARE(*YES)                          3
QRYSLT('                                                   4
%WLDCRD("                                                  5
CLOF OPNID(MIMGDIR6)                                       6
DLTOVR FILE(MIMGDIR6)                                      7
(IDILOC *EQ %VALUES(" " "0" "3"))                          8
** ERROR NUMBER / ERROR MESSAGE CODE
08ERR2108
09ERR2109
10ERR2110
11ERR2111
12ERR2112
14ERR2114
16ERR2116
18ERR2118
20ERR2120
21ERR2121
27ERR2127
35ERR2135

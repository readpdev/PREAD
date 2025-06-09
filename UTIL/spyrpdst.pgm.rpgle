      *%METADATA                                                       *
      * %TEXT Build Distribution for Archived Report                   *
      *%EMETADATA                                                      *
      ***********---------------------------------------------
      * SPYRPDST  Build Distribution Table for Archived Report
      ***********---------------------------------------------
      *           (Work w/ Reports (WRKRDR) option 15=Distrib.)
      *
     FSPYRPDFM  CF   E             WORKSTN usropn INFDS(DSDSP)
     FMRPTDIR6  IF   E           K DISK    RENAME(RPTDIR:RPTDIR6)
     FRMAINT    IF   E           K DISK
      *
/6708 * 10-21-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte bina
      *              Remove access to MRPTDIR, use MRPTDIR1 instead.
      *              Change FILNUM (in MRPTDIR) to be the actual spool file numb
      *              change MRPTDIR1 key to include the spool file opened date.
/5811 * 01-10-02 KAC Cleanup Page data line structure.
/1452 * 10-31-00 JAM PREVENT LOSS OF SCREEN DATA ON HELP.
/2272 * 12-03-99 DM  Changed spypgrtv rrn to 9 bytes numeric
      *  1-20-99 JJF Handle pages with >240 records
      *  1-30-98 GT  Change overstrike compares to use new API string
      * 01-26-98 GT  Extend DTS data structure to 240 occurrances.
      * 10-14-97 GT  Add INLLIBL(*CURRENT) to SBMJOB command
      * 12-06-96 JJF Add Personal Help.
      * 11-21-96 FB  New program
      *

     D DSDSP           DS
     D  KEY                  369    369
     D  CSRLOC               370    371i 0
     D  SFLZ                 378    379i 0
     D  WINLOC               382    383i 0

     D ERROR           DS
     D  BYTPRV                 1      4i 0 INZ(256)
     D  BYTAVA                 5      8i 0 INZ(0)
     D  ERRID                  9     15
     D  ERR###                16     16
     D  MSGDTA                17    256

     D PSCON           C                   CONST('PSCON     *LIBL     ')
     D ERRCD           DS           116
      *             Api error code
     D  @ERLEN                 1      4i 0
     D  @ERCON                 9     15
     D  @ERDTA                17    116

     D               ESDS                  EXTNAME(CASPGMD)

     D                 DS           116    INZ
     D  STSBAR                 1     50
     D  STS                    1     50    DIM(50)

     D                 DS                  INZ
     D  ALF50                  1      5
     D  PCK50                  1      5P 0

     D  APILEN         s             10i 0

/5811d MaxCols         c                   236
/    d @PAG            s                   dim(256) like(LinDS)
/    d LinDS           ds                  based(LinDSp)
/    d Lin                            1    dim(MaxCols)

     D DTS             DS           256    OCCURS(240) INZ
     D  CODE                   1      1
/    d  DAT                    2    237    dim(MaxCols)
/    d  DTSNoteFlag          238    238
/5811d  DTSLineNum           239    247
/    d  DTSPageNum           248    256

     d @datfo          s              9b 0

     D SBMJO1          C                   CONST('SBMJOB JOB(SPYRPTDST-
     D                                     ) INLLIBL(*CURRENT) -
     D                                     CMD(CALL PGM(-
     D                                     SPYRPDST) PARM(''')
     D HELP            C                   CONST(X'F3')

/6708d filnub          s              9b 0

     C     *ENTRY        PLIST
     C                   PARM                    JOBNUM            6
     C                   PARM                    datfo             7
/6708C                   PARM                    filnub
     C                   PARM                    SEGMNT           10
     C                   PARM                    RTNCDE            8

/6708c                   z-add     filnub        filnum
/6708c                   move      datfo         @datfo

     C     WQPRM         IFGT      3
     C     RTNCDE        IFEQ      'CLOSEW'
     C                   EXSR      QUIT
     C                   ENDIF
     C                   MOVEL     RTNCDE        CALLER           10
     C                   ENDIF

      * Get Big5
     C     KEYDIR        CHAIN     RPTDIR6                            50
     C     KEYDIR        KLIST
     C                   KFLD                    JOBNUM
     C                   KFLD                    FILNUM
     C                   KFLD                    @datfo
     C     *IN50         IFEQ      *ON
     C                   MOVEL     'ERR0125'     EMSGID
     C                   EXSR      SPYERR
     C                   ENDIF
      * Get Report Type
     C     KLBIG5        CHAIN     RMAINT                             50
     C     KLBIG5        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C     *IN50         IFEQ      *ON
     C                   MOVEL     'ERR0125'     EMSGID
     C                   EXSR      SPYERR
     C                   ENDIF

      * CHECK Distr PAGE pgm
     C                   MOVEL(P)  'CHECK'       @OPCDE           10
     C                   EXSR      DSTPAG
     C                   EXSR      DOERR
      * Self-submit
     C     JOBTYP        IFEQ      '1'
     C     WQPRM         ANDGE     3
     C     CALLER        ANDNE     'MAG408'
     C     CALLER        ANDNE     '*NOPMT'
     C                   EXSR      SRSBMJ
     C                   ENDIF
      * CHECK PARMS IF *NOPMT
     C     CALLER        IFEQ      '*NOPMT'
     C                   MOVEL(P)  'CHKHIST'     @OPCDE           10
     C                   EXSR      DSTPAG
     C     @RTNCD        IFNE      *BLANKS
     C                   MOVEL(P)  @RTNCD        CALLER
     C                   EXSR      QUIT
     C                   ENDIF
     C                   ENDIF

      * Status Bar
     C     JOBTYP        IFEQ      '1'
     C     TOTPAG        DIV(H)    50            STEP             11 0
     C                   EXSR      BAR
     C                   END

      *--------------------------------------------------------
      * Get each page and call pgms to build distribution PgTbl
      *--------------------------------------------------------
     C                   DO        TOTPAG        PAGE#
     C                   EXSR      GETPAG
      * Build distribution                                 'SPYPGRTV'
     C                   CLEAR                   @OPCDE
     C                   EXSR      DSTPAG
     C                   EXSR      DOERR
      * Status bar
     C     JOBTYP        IFEQ      '1'
     C                   ADD       1             CNTR             11 0
     C     CNTR          IFGE      STEP
     C                   EXSR      BAR
     C                   CLEAR                   CNTR
     C                   ENDIF
     C                   END
     C                   ENDDO
      *------
      * Close
      *------
     C                   MOVEL(P)  'CLOSE'       @OPCDE
     C                   EXSR      DSTPAG
     C                   EXSR      DOERR

     C     *IN50         IFEQ      *ON
     C                   MOVEL     'ERR0125'     EMSGID
     C                   EXSR      SPYERR
     C                   ENDIF

     C                   EXSR      RETRN

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
     C                   CALL      'MAG1034'
     C                   PARM      ' '           JOBTYP            1
     C     JOBTYP        IFEQ      '1'
     C                   OPEN      SPYRPDFM
     C                   ENDIF

      * Retrieve overstrike characters
     C                   CALL      'MAG103C'
     C                   PARM                    OCLEN             3 0
     C                   PARM                    OCSTR            99
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETFKY        BEGSR
      *          Format the function keys

     C                   MOVE      'FKY0300'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        FKYTXT

     C                   MOVE      'FKY0401'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT(P)    @MSGTX:2      FKYTXT

     C                   MOVE      'FKY1200'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT(P)    @MSGTX:2      FKYTXT

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVMSG        BEGSR
      *          Retrieve Message from PSCON
     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80
     C                   MOVE      *BLANKS       @ERDTA
     C                   ENDSR

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETPAG        BEGSR
      *          Call SpyPgRtv to get up to 240 data recs for pg in DTS
      *          Tfr DTS to memory array @PAG for passing to SpyPgDst,
      *          which creates the segment PgTbl.

     C                   CLEAR                   @PAG
     C                   CLEAR                   OPCODE
      *>>>>
     C     MORPAG        TAG
     C                   CALL      'SPYPGRTV'                           50
     C                   PARM                    REPIND
     C                   PARM                    OPCODE            5
     C                   PARM                    PAGE#             7 0
/2272C                   PARM                    RRN               9 0
      *                                                    Return:
     C                   PARM                    DTS
     C                   PARM                    RTNREC            9 0
     C                   PARM                    RTNATR           80
     C                   PARM                    CALLNK            1
     C                   PARM                    LKVAL1           70
     C                   PARM                    LKVAL2           70
     C                   PARM                    LKVAL3           70
     C                   PARM                    LKVAL4           70
     C                   PARM                    LKVAL5           70
     C                   PARM                    LKVAL6           70
     C                   PARM                    LKVAL7           70
     C                   PARM                    RTNRTV            2
     C                   PARM                    PMSGID            7
     C                   PARM                    PMSGDT          100
     C                   PARM      0             RFIL#             9 0
     C                   PARM      0             ROFFS            11 0

     C     RTNRTV        IFEQ      '30'
     C     *IN50         OREQ      *ON
     C     PMSGID        IFEQ      *BLANKS
     C                   MOVEL     'ERR0125'     EMSGID
     C                   ELSE
     C                   MOVEL     PMSGID        EMSGID
     C                   MOVEL     PMSGDT        EMSGDT
     C                   ENDIF
     C                   EXSR      SPYERR
     C                   ENDIF
      *--------------------------
      * Build memory page in @PAG
      *--------------------------
     C                   DO        RTNREC        #                 9 0
     C     #             OCCUR     DTS

     C                   SELECT
     C     CODE          WHENEQ    '1'
     C                   Z-ADD     1             L                 5 0
     C     CODE          WHENEQ    ' '
     C                   ADD       1             L
     C     CODE          WHENEQ    '0'
     C                   ADD       2             L
     C     CODE          WHENEQ    '-'
     C                   ADD       3             L
     C                   ENDSL
      * Not overstrike
     C     CODE          IFNE      '+'
     C                   MOVEA     DAT           @PAG(L)
      * Overstrike
     C                   ELSE

/5811c                   eval      LinDSp = %addr(@PAG(L))
     C                   DO        MaxCols       C#                9 0
     C     DAT(C#)       IFNE      ' '
     C     LIN(C#)       SCAN      OCSTR         OC#               3 0
     C     OC#           IFGT      0
     C     OC#           ANDLE     OCLEN
     C                   MOVE      DAT(C#)       LIN(C#)
     C                   END
     C                   END
     C                   ENDDO

     C                   END
     C                   ENDDO

      * If SPYPGRTV returned code=25, there are more records for page
     C     RTNRTV        IFEQ      '25'
     C                   MOVE      'CONTI'       OPCODE
     C                   GOTO      MORPAG
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DSTPAG        BEGSR

     C                   CALL      'SPYPGDST'                           50
     C                   PARM      REPIND        @REPID           10
     C                   PARM      RTYPID        @RPTYP           10
     C                   PARM                    SEGMNT           10
     C                   PARM                    @OPCDE           10
     C                   PARM      PAGE#         @PAGE#            5 0
     C                   PARM                    @PAG
     C                   PARM      L             @LINES            5 0

     C                   PARM      *BLANKS       @RTNCD            7
     C                   PARM      *BLANKS       RTNSEG           10
     C                   PARM      *BLANKS       RTNSUB           10

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DOERR         BEGSR
      * SEND ERRORS, THAT CAME FROM SPYPGDST

     C     *IN50         IFEQ      *OFF
     C     @RTNCD        ANDEQ     'ERR0126'
     C     CALLER        ANDEQ     'MAG408'
     C                   MOVE      *BLANKS       @RTNCD
     C                   EXSR      RETRN
     C                   ENDIF

     C     *IN50         IFEQ      *ON
     C     @RTNCD        ORNE      *BLANKS
     C                   MOVEL     @RTNCD        EMSGID
     C   50              MOVEL     'ERR0125'     EMSGID
     C                   EXSR      SPYERR
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
     C                   MOVEL(P)  'CANCEL'      @OPCDE
     C                   EXSR      DSTPAG
     C                   EXSR      DOERR
     C                   MOVE      *ON           *INLR
     C                   EXSR      RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RETRN         BEGSR

     C     WQPRM         IFGE      4
     C                   MOVE      KEY           RTNCDE
     C                   ENDIF
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPYERR        BEGSR

     C                   CALL      'SPYERR'                             50
     C                   PARM                    EMSGID            7
     C                   PARM                    EMSGDT          100
     C                   PARM                    EMSGF            10
     C                   PARM                    EMSGFL           10

     C     JOBTYP        IFEQ      '1'
     C                   EXSR      RETRN
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *PSSR         BEGSR
     C                   ENDSR     '*CANCL'
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FAKEIT        BEGSR
      *          (not executed)
     C                   EXFMT     STATUS
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     BAR           BEGSR

     C     CALLER        IFNE      'MAG408'
     C     PAGE#         DIV       TOTPAG        I3                7 2
     C     I3            MULT(H)   50            I2                5 0
     C     I2            IFLT      1
     C                   Z-ADD     1             I2
     C                   ENDIF
     C     I2            IFLE      50
     C                   CLEAR                   STS
     C                   MOVE      X'20'         STS(I2)
     C                   ENDIF
     C                   WRITE     STATUS
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRSBMJ        BEGSR

     C                   EXSR      GETFKY
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   MOVE      'Y'           SBMYN
     C                   MOVEL     'QDFTJOBD'    JOBDSC
     C                   MOVEL     '*LIBL'       JOBLIB
      *>>>>
     C     INSBM         TAG
     C     SEGMNT        IFEQ      *BLANKS
     C                   MOVEL     '*ALL'        SEGMNT
     C                   ENDIF
     C                   EXFMT     SBMJOB
/1452C     KEY           DOWEQ     HELP
     C                   CALL      'SPYHLP'
     C                   PARM      'SPYRPDFM'    DSPFIL           10
     C                   PARM      'SBMJOB'      HLPFMT           10
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      SBMJOB                                 99
/1452C                   MOVE      #IN99         *IN99
/1452C                   ENDDO

     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS

     C     *INKC         IFEQ      *ON
     C     *INKL         OREQ      *ON
      * CANCEL Distribution PAGE Program
     C                   MOVEL(P)  'CANCEL'      @OPCDE
     C                   EXSR      DSTPAG
     C                   EXSR      DOERR
     C                   EXSR      RETRN
     C                   ENDIF

     C     *INKD         IFEQ      *ON
     C                   EXSR      SRF4
     C                   GOTO      INSBM
     C                   ENDIF
     C     SEGMNT        IFEQ      '*ALL'
     C                   CLEAR                   SEGMNT
     C                   ENDIF
      *   Check if selected segment has been distributed before
     C                   EXSR      CHKHST
     C     @RTNCD        CABNE     *BLANKS       INSBM
      *   Check parms
     C     SBMYN         IFEQ      'Y'
     C     JOBLIB        IFEQ      *BLANKS
     C                   MOVEL     '*LIBL'       JOBLIB
     C                   ENDIF
     C     JOBDSC        CAT       JOBLIB        OBJECT
     C                   MOVEL     '*JOBD'       OBJTYP
     C                   EXSR      CHKOBJ
     C     EXISTS        CABEQ     'N'           INSBM                    60

      * Submit yourself.  See you again in batch...
     C     SBMJO1        CAT(P)    JOBNUM        CMDLIN
     C                   CAT       ''' ''':0     CMDLIN
     c                   eval      cmdlin=%trimr(cmdlin)+
     c                               %trim(%editc(filnum:'Z'))
     C                   CAT       ''' ''':0     CMDLIN
     C                   CAT       SEGMNT:0      CMDLIN
     C                   CAT       '''))':0      CMDLIN
     C                   CAT       'JOBD(':1     CMDLIN
     C                   CAT       JOBLIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       JOBDSC:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL
     C  N50              EXSR      RETRN
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKHST        BEGSR
      * Check if already done
     C                   MOVEL(P)  'CHKHIST'     @OPCDE           10
     C                   EXSR      DSTPAG
     C                   EXSR      DOERR
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SELOBJ        BEGSR

     C                   CALL      'MAG2042'                            45
     C                   PARM      '*ALL'        LKPOBJ           10
     C                   PARM                    LKPLIB           10
     C                   PARM                    LKPTYP           10
     C                   PARM      *BLANKS       LKPATR           10
     C                   PARM      *BLANKS       RTNOBJ           10
     C                   PARM      *BLANKS       RTNLIB           10
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF4          BEGSR

     C                   EXSR      SRCURS
     C                   SELECT
     C     FLD           WHENEQ    'JOBDSC'
     C     JOBLIB        IFNE      *BLANKS
     C                   MOVE(P)   JOBLIB        LKPLIB
     C                   ELSE
     C                   MOVEL     '*LIBL'       LKPLIB
     C                   ENDIF
     C                   MOVE      *BLANKS       LKPOBJ
     C                   MOVEL     '*JOBD'       LKPTYP           10
     C                   EXSR      SELOBJ
     C     RTNOBJ        IFNE      *BLANKS
     C                   MOVEL     RTNOBJ        JOBDSC
     C                   MOVEL     RTNLIB        JOBLIB
     C                   ENDIF

     C     FLD           WHENEQ    'JOBLIB'
     C                   MOVE      *BLANKS       LKPOBJ
     C                   MOVEL     '*LIBL'       LKPLIB
     C                   MOVEL     '*LIB'        LKPTYP           10
     C                   EXSR      SELOBJ
     C     RTNOBJ        IFNE      *BLANKS
     C                   MOVEL     RTNOBJ        JOBLIB
     C                   ENDIF

     C     FLD           WHENEQ    'SEGMNT'
     C                   CALL      'WRKSHD'
     C                   PARM      RTYPID        WHREPT           10
     C                   PARM      SEGMNT        WHSEG            10
     C                   PARM      '1'           WLIST             1
     C                   PARM      '1'           SUBSET            1
     C                   PARM      'S'           SCRZ              1
     C                   PARM                    RTNCDE            8
     C     WHSEG         IFNE      *BLANKS
     C                   MOVEL     WHSEG         SEGMNT
     C                   ENDIF
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    CMDLIN          255
     C                   PARM      255           CLLEN            15 5
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRCURS        BEGSR
      *          Cursor position
     C     CSRLOC        DIV       256           CSRLIN            3 0
     C                   MVR                     CSRPOS            3 0
     C     WINLOC        DIV       256           WINLIN            3 0
     C                   MVR                     WINPOS            3 0
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKOBJ        BEGSR
      *          -------------------------------------------------
      *          Return EXISTS=Y/N if OBJECT exists/does not exist
      *          -------------------------------------------------
     C                   CALL      'QUSROBJD'
     C                   PARM                    @OBJD            90
     C                   PARM      90            APILEN
     C                   PARM      'OBJD0100'    APIFMT            8
     C                   PARM                    OBJECT           20
     C                   PARM                    OBJTYP           10
     C                   PARM                    ERROR

     C     BYTAVA        IFEQ      0
     C                   MOVE      'Y'           EXISTS            1
     C                   ELSE
     C                   MOVE      'N'           EXISTS
     C                   END
     C                   ENDSR

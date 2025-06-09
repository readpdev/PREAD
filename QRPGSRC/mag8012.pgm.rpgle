      *%METADATA                                                       *
      * %TEXT WorkView - Work with Transaction Descriptions            *
      *%EMETADATA                                                      *
      **********------------------------------
      * MAG8012  WORK TRANSACTION DESCRIPTIONS
      **********------------------------------
      *           F. BR!GGE  2/96
      *
      *  6-25-97 JJF Add Personal Help.
      *
      *    01     VLDCMDKEY
      *    10     POSITION SFL1
      *    11     SFLNXTCHG
      *    50     ERROR READ
      *    59     ERROR SFL1
      *    60 -69 FEHLERMELDUNG EINGABE
      *    70 -74 CONTROL   SUBFILE 1+2
      *    75     CONTROL   MSG-SUBFILE
      *
     FMAG8012F  CF   E             WORKSTN INFDS(DSDSP)
     F                                     SFILE(SFL1:RCD1)
     F                                     SFILE(SFL2:RCD2)
     FWVPROP    IF   E           K DISK
     FWVTADP    UF A E           K DISK
     FWVTRAP    UF   E           K DISK    USROPN
     FWVSECP    UF   E           K DISK    USROPN
      *
     D*@  Ind Inpt Calc  Out    Ind Inpt Calc  Out    Ind Inpt Calc  Out
     D*@   KC        M           10        MOX         61        M
     D*@   KD        M           11        MOX         70        MOX
     D*@   KE        M           50      L M           71      L MOX
     D*@   KF      L M           51      L             72        MOX
     D*@   LR        MO          59        MO          73        MOX
     D*@   01        M           60        M           75        MO
     D*@  *MAIN*       QUIT   SRDSP  CLRMSG QUIT   SRDSP  SRF6   SRF21
     D*@               SRO02  SRO14  SRO08  SRO04  SNDMSG
     D*@  SRDSP        FMTRCD
     D*@  SRO08        SNDMSG SRF21  SRCHK  FMTRCD SNDMSG
     D*@  SRF6         SNDMSG SRF21  FMTRCD CLRMSG SNDMSG
     D*@ SPYREAL/QRPGSRC/MAG8012          11/06/97 at 12:20:52 by FIDDY
     D*@
     D                SDS
     D  PGMQ             *PROC
     D  ERRNR                 40     46
     D  ERRMSG                91    170
     D  ERRFIL               201    210
     D  JOB                  244    253
     D  USR                  254    263
     D  JNR                  264    269
     D                 DS                  INZ
     D  STKCNT                 1      4B 0
     D  DTALEN                 5      8B 0
     D  ERRCOD                 9     12B 0
     D*
     D DSDSP           DS
     D  KEY                  369    369
     D  CSRLOC               370    371B 0
     D  SFLZ                 378    379B 0
     D  WINLOC               382    383B 0
      *
     D TRNACT          C                   CONST('*TRANSACT')
     D HELP            C                   CONST(X'F3')
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRO              10
      *
    IC     PRO           CHAIN     WVPROF                             50
     C   50              EXSR      QUIT
     C                   CLOSE     WVPROP
     C                   WRITE     WIN01
     C                   EXSR      SRDSP
      *>>>>>>>>>>IN02
     C     IN02          TAG
      *
<--1 C     *INKD         IFEQ      '0'
|    C                   CLEAR                   WINLIN
|    C                   CLEAR                   WINPOS
|__1 C                   ENDIF
      *
     C     TRCD1         COMP      0                                      71     EQ
     C   71              WRITE     FMT02
<--1 C     SFLRC1        IFEQ      0
|    C                   Z-ADD     1             SFLRC1
|__1 C                   ENDIF                                                              MainLine
      *
     C                   WRITE     MSGSFC
      *                 |-------------|
     C                   EXFMT     SFC1
      *                 |-------------|
     C                   EXSR      CLRMSG
     C                   Z-ADD     SFLZ          SFLRC1
      *
      * F KEYS
<--1 C     *IN01         IFEQ      '1'
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'SFC1'        HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
|    C     PLHELP        PLIST
|    C                   PARM      'MAG8012F'    DSPFIL           10
|    C                   PARM                    HLPFMT           10
|   GC                   GOTO      IN02
|__2 C                   END
<--2 C     *INKC         CASEQ     '1'           QUIT
|    C     *INKL         CASEQ     '1'           QUIT                                       MainLine
|    C     *INKE         CASEQ     '1'           SRDSP
|    C     *INKF         CASEQ     '1'           SRF6
|    C     *INKV         CASEQ     '1'           SRF21
|__2 C                   ENDCS
|   GC                   GOTO      IN02
|__1 C                   ENDIF
      *
      * CLR SFL2 IF NOT EMPTY
<--1 C     TRCD2         IFNE      *ZEROS
|    C                   MOVEA     '11'          *IN(72)
|    C                   WRITE     SFC2
|    C                   MOVEA     '00'          *IN(72)
|    C                   CLEAR                   TRCD2
|    C                   CLEAR                   RCD2
|__1 C                   ENDIF
      *
      * SUBFILE READ
      *
<--1 C     TRCD1         IFGT      0
|     *                                                                MainLine
<--2dC                   DO        *HIVAL
|   IC                   READC     SFL1                                 5050
|    C   50              LEAVE
|     *
|    C                   Z-ADD     RCD1          SFLRC1                         POSITION
|    C                   MOVE      OPTION        OPT#
|    C                   CLEAR                   OPTION
|    C     OPT#          COMP      *ZERO                              1111       NE
|    C                   UPDATE    SFL1
|     *
<--3sC                   SELECT
|     * 2=CHANGE
| -3wC     OPT#          WHENEQ    2
|    C                   EXSR      SRO02
|    C                   MOVEL     FADESC        FADE34           34
|    C                   WRITE     FMT01
|     * 14=AUTHORITY
| -3wC     OPT#          WHENEQ    14
|    C                   EXSR      SRO14
|     * 8=DESCRIPTION
| -3wC     OPT#          WHENEQ    8                                                        MainLine
|    C                   EXSR      SRO08
|     * 4=DELETE
|     *
| -3wC     OPT#          WHENEQ    4
|    C                   EXSR      SRO04
|     * WRONG OPTION
| -3wC                   OTHER
<--4 C     OPT#          IFNE      0
|   IC     RCD1          CHAIN     SFL1                               50
|    C                   MOVE      '1'           *IN59
|    C                   MOVE      '1'           *IN11
|    C                   MOVE      OPT#          OPTION
|    C  N50              UPDATE    SFL1
|__4 C                   ENDIF
|__3sC                   ENDSL
|__2dC                   ENDDO
|__1 C                   ENDIF
      *
      * SECURITY QUESTIONS FOR DELETE
      *                                                                MainLine
<--1 C     TRCD2         IFNE      *ZEROS
|    C                   WRITE     FMT03
|    C                   Z-ADD     1             SFLRC2
|    C*>>>>>>>>>>SHOWC2
|    C     SHOWC2        TAG
|     *                 |-------------|
|    C                   EXFMT     SFC2
|     *                 |-------------|
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'SFC2'        HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
|   GC                   GOTO      SHOWC2
|__2 C                   END
<--2 C     *IN01         IFEQ      '0'
|    C                   OPEN      WVSECP
|    C                   OPEN      WVTRAP
<--3dC                   DO        TRCD2         F40               4 0
|   IC     F40           CHAIN     SFL2                               50
<--4 C     *IN50         IFEQ      '0'
|   IC     KEYACT        CHAIN     WVTADF                             51                    MainLine
|    C     KEYAUT        KLIST
|    C                   KFLD                    FETYP
|    C                   KFLD                    FEOBJ
|    C                   KFLD                    FETRA
|    C                   Z-ADD     FFTRA         FETRA                          TRANACT#
|    C                   MOVEL     PRO           FEOBJ                          PROCESS
|    C                   MOVEL     TRNACT        FETYP                          *TRANSACT
<--5dC     *IN50         DOUEQ     '1'
|    C     KEYAUT        DELETE    WVSECF                             50
|__5dC                   ENDDO
<--5dC     *IN50         DOUEQ     '1'
|    C     KEYACT        DELETE    WVTRAF                             50
|__5dC                   ENDDO
|    C  N51              DELETE    WVTADF
|   IC     RCD1          CHAIN     SFL1                               50
|    C                   CLEAR                   SFL1
|    C                   MOVEL(P)  'deleted'     FFDESC
|    C                   MOVE      '1'           *IN10
|    C                   MOVE      '0'           *IN11
|    C                   UPDATE    SFL1                                                     MainLine
|__4 C                   ENDIF
|__3dC                   ENDDO
|    C                   CLOSE     WVSECP
|    C                   CLOSE     WVTRAP
|    C                   MOVE      'ACT0009'     MSGID
->E2 C                   ELSE
|    C                   MOVE      'ACT0014'     MSGID
|__2 C                   ENDIF
|    C                   EXSR      SNDMSG
|    C                   MOVE      '0'           *IN10
|    C                   MOVEL     FADESC        FADE34
|    C                   WRITE     FMT01
|__1 C                   ENDIF
      *
    GC                   GOTO      IN02
      *
      *
      *@$$$$$$$$ QUIT   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *
      *
      *@$$$$$$$$ SNDMSG $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDMSG        BEGSR
      *          SEND PROGRAM MSG
      *
     C                   CALL      'SNDMSG2'                            50
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA          132
     C                   ENDSR
      *
     C     KEYACT        KLIST
     C                   KFLD                    PRO
     C                   KFLD                    FFTRA
      *
      *
      *@$$$$$$$$ *INZSR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
      *
     C     *LIKE         DEFINE    RCD1          TRCD1
     C     *LIKE         DEFINE    RCD1          TRCD2
      *
     C                   MOVEL     X'2A'         ERR               7
     C                   MOVE      '*ERROR'      ERR
      *
     C                   MOVE      '1'           *IN75
     C                   MOVE      *BLANKS       MSGKY             4
     C                   MOVEL     '*ALL'        MSGRMV           10
     C                   ENDSR
      *
      *@$$$$$$$$ SRCURS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRCURS        BEGSR
      *          GET CURSOR POSITION
      *
     C     CSRLOC        DIV       256           CSRLIN            3 0          CURS-LINE
     C                   MVR                     CSRPOS            3 0          CURS-POS
     C     WINLOC        DIV       256           WINLIN            3 0          CURS-LINE
     C                   MVR                     WINPOS            3 0          CURS-POS
     C                   ENDSR
      *
      *@$$$$$$$$ CLRMSG $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRMSG        BEGSR
      *          REMOVE PGM-MSG
     C                   CALL      'QMHRMVPM'
     C                   PARM                    PGMQ
     C                   PARM                    STKCNT
     C                   PARM                    MSGKY             4
     C                   PARM                    MSGRMV           10
     C                   PARM                    ERRCOD
     C                   ENDSR
      *
      *@$$$$$$$$ SRDSP  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRDSP         BEGSR
      *          FILL SFL
      *
     C                   CLEAR                   TRCD1
     C                   CLEAR                   RCD1
     C                   MOVEA     '11'          *IN(70)
     C                   WRITE     SFC1
     C                   MOVEA     '00'          *IN(70)
     C                   Z-ADD     1             SFLRC1
     C                   CLEAR                   OPTION
     C                   CLEAR                   *IN10
     C                   CLEAR                   *IN11
     C                   CLEAR                   *IN59
     C                   MOVEL     FADESC        FADE34
     C                   WRITE     FMT01
     C     PRO           SETLL     WVTADF
      *
<--1dC                   DO        *HIVAL
|   IC     PRO           READE(N)  WVTADF                                 50
|    C   50              LEAVE                                                              SRDSP
|    C                   EXSR      FMTRCD
|    C                   ADD       1             TRCD1
|    C                   Z-ADD     TRCD1         RCD1
|    C                   WRITE     SFL1
|__1dC                   ENDDO
      *
     C                   Z-ADD     1             SFLRC1
     C                   ENDSR
      *
      *@$$$$$$$$ FMTRCD $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FMTRCD        BEGSR
      *          FORMAT SFL RECORD
     C                   ENDSR
      *
      *@$$$$$$$$ SRCHK  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRCHK         BEGSR
     C*>>>>>>>>>>CHECK I
      *          CHECK INPUT
     C                   MOVE      ' '           ERROR             1
     C                   ENDSR
      *
      *@$$$$$$$$ SRO02  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO02         BEGSR
      *          2=CHANGE
      *
     C                   CALL      'MAG8014'                            50
     C                   PARM                    PRO
     C                   PARM                    FFTRA
     C     ENDA02        ENDSR
      *
      *@$$$$$$$$ SRO14  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO14         BEGSR
      *          14=AUTHORITY
      *
     C                   CALL      'MAG8013'                            50
     C                   PARM      FFPRO         OBJECT           10
     C                   PARM      TRNACT        OBJTYP           10
     C                   PARM      FFTRA         OBJTRA            3 0
      *
     C                   ENDSR
      *
      *@$$$$$$$$ SRO08  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO08         BEGSR
      *          8=DESCRITPTION
      *
    IC     KEYACT        CHAIN(N)  WVTADF                             5050
      *
      *>>>>>>>>>>INO08
     C     INO08         TAG
      *
<--1 C     *INKD         IFEQ      '0'
|    C                   CLEAR                   WINLIN
|    C                   CLEAR                   WINPOS
|__1 C                   ENDIF
      *                 |-------------|
     C                   EXFMT     FMT05
      *                 |-------------|
<--1 C     *IN01         IFEQ      '1'
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'FMT05'       HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
|   GC                   GOTO      INO08
|__2 C                   END                                                                SRO08
<--2 C     *INKC         IFEQ      '1'
|    C     *INKL         OREQ      '1'
|    C                   MOVE      'ACT0006'     MSGID
|    C                   EXSR      SNDMSG
|   GC                   GOTO      ENDO08
|__2 C                   ENDIF
<--2 C     *INKV         CASEQ     '1'           SRF21
|__2 C                   ENDCS
|   GC                   GOTO      INO08
|__1 C                   ENDIF
      *
     C                   EXSR      SRCHK
    GC     ERROR         CABEQ     '1'           INO08
      *
    IC     RCD1          CHAIN     SFL1                               50
    IC     KEYACT        CHAIN     WVTADF                             5050
      *
    IC                   READ      FMT05                                  51
      *
     C                   EXSR      SRCHK                                                    SRO08
      *
<--1 C     *IN50         IFEQ      '0'
|    C                   UPDATE    WVTADF                               60
<--2 C     *IN60         IFEQ      '1'
|   GC                   GOTO      INO08
|__2 C                   ENDIF
|    C                   EXSR      FMTRCD
|    C                   UPDATE    SFL1
|    C                   MOVE      'ACT0007'     MSGID                          UPDAT OK
|    C                   CLEAR                   MSGDTA
->E1 C                   ELSE
|    C                   MOVE      'ACT0008'     MSGID                          CHAIN ERROR
|    C                   CLEAR                   MSGDTA
|__1 C                   ENDIF
      *
     C                   EXSR      SNDMSG
     C     ENDO08        ENDSR
      *
      *@$$$$$$$$ SRO04  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO04         BEGSR
      *          WRITE IN SFL2 FOR DELETE
      *
     C                   ADD       1             TRCD2
     C                   Z-ADD     TRCD2         RCD2
     C                   WRITE     SFL2
     C                   ENDSR
      *
      *@$$$$$$$$ SRF6   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF6          BEGSR
      *          NEW RECORD
      *
      * Get sort# (next even multiple of 10)
      *
     C     PRO           SETGT     WVTADF
     C     PRO           READPE    WVTADF                                 50
<--1 C     *IN50         IFEQ      *ON
|    C                   Z-ADD     10            FFTRA                          Start
->E1 C                   ELSE
|    C                   ADD       10            FFTRA                          Cont 20 25
|    C     FFTRA         DIV       10            F50               5 0                2  2
|    C                   MVR                     REMAIN            3 0                0  5
<--2 C     REMAIN        IFGT      0
|    C                   ADD       1             F50                                     3
|__2 C                   ENDIF
|    C     F50           MULT      10            FFTRA                               20 30
|__1 C                   ENDIF
      *
     C                   CLEAR                   FFDESC                                     SRF6
      *>>>>>>>>>>INF6
     C     INF6          TAG
      *                 |-------------|
     C                   EXFMT     FMT06
      *                 |-------------|
<--1 C     *IN01         IFEQ      '1'
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'FMT06'       HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
|   GC                   GOTO      INF6
|__2 C                   END
<--2 C     *INKC         IFEQ      '1'
|    C     *INKL         OREQ      '1'
|    C                   MOVE      'ACT0016'     MSGID
|    C                   EXSR      SNDMSG
|   GC                   GOTO      ENDF6
|__2 C                   ENDIF
<--2 C     *INKV         CASEQ     '1'           SRF21
|__2 C                   ENDCS
|   GC                   GOTO      INF6                                                     SRF6
|__1 C                   ENDIF
      *
    GC     FFTRA         CABEQ     0             INF6                     60
      *
     C     KEYACT        SETLL     WVTADF                                 61
    GC     *IN61         CABEQ     '1'           INF6                     61
      *
     C                   MOVE      PRO           FFPRO
     C                   WRITE     WVTADF                               61
    GC     *IN61         CABEQ     '1'           INF6
      *
     C                   EXSR      FMTRCD
     C                   ADD       1             TRCD1
     C                   Z-ADD     TRCD1         RCD1
     C                   Z-ADD     TRCD1         SFLRC1
     C                   WRITE     SFL1
     C                   EXSR      CLRMSG
     C                   MOVE      'ACT0015'     MSGID
     C                   EXSR      SNDMSG
     C     ENDF6         ENDSR
      *
      *@$$$$$$$$ RUNCL  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
      *
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    CMD             250
     C                   PARM      250           F155             15 5
     C                   ENDSR
      *
      *@$$$$$$$$ SRF21  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF21         BEGSR
      *          F21=SYSTEM COMMAND LINE
      *
     C                   CALL      'MSYSCMDC'                           50
     C                   ENDSR

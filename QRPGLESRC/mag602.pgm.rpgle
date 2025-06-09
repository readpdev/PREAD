      *%METADATA                                                       *
      * %TEXT Distribution Report Menu                                 *
      *%EMETADATA                                                      *
      /copy directives
      **********-------------------------
      *  MAG602  Distribution Report Menu
      **********-------------------------
      *
     FMAG602FM  CF   E             WORKSTN
     F                                     INFDS(INFDS)
     FRDSTDEF2  IF   E           K DISK
     F                                     RENAME(DSTDEF:DSTDEF2)
     FRBNDDEF   IF   E           K DISK
     FMAG601A   O    E           K DISK    USROPN
      *
/1452 * 10-31-00 JAM PREVENT LOSS OF SCREEN DATA ON HELP.
/2347 *  2-22-00 JJF Exit if user is not authorized to run
      * 12-06-96 JJF Add Personal Help.
      *  5-28-94     New program
      *
     D CL              S             79    DIM(11) CTDATA PERRCD(1)
     D TMP             S              1    DIM(80)
      *
     D                SDS
     D  WQLIBN                81     90
      *
     D ENVDFT          DS          1024
     D  LMSGQ                129    138
     D  LMSGQL               139    148
     D INFDS           DS
     D  KEY                  369    369
      *
     D @OBJD           DS            90
      *             Retrieve object descr
     D  OBJLB1                19     28
      *
     D @MSGDT          DS           103
      *             Retieve message
     D  ERRLEN                 9     12B 0
     D  @EM                   25    103
     D                                     DIM(79)                              Error Message
     D ERRCD           DS           116
     D  @ERLEN                 1      4B 0
     D  @ERTCD                 5      8B 0
     D  @ERCON                 9     15
      *
     D                 DS
      *             Binaries
     D  APILEN                 1      4B 0
     D  @MSGLN                 5      8B 0
     D  @MSGQ#                 9     12B 0
      *
     D F3              C                   CONST(X'33')
     D F4              C                   CONST(X'34')
     D F12             C                   CONST(X'3C')
     D HELP            C                   CONST(X'F3')
     D #OBJA           C                   CONST('MAG601A   QTEMP     ')
     D PSCON           C                   CONST('PSCON     *LIBL     ')
      *
/2347 * Exit if user is not authorized to run
     C                   CALL      'SPYAUT'
     C                   PARM      'MAG602'      SPYPGM           10
     C                   PARM                    RET1              1
<--1 C     RET1          IFEQ      'N'
|    C                   CALL      'SPYERR'
|    C                   PARM      'SPY0013'     MSGID
|    C                   MOVE      *ON           *INLR
|    C                   RETURN
|__1 C                   END
      *
     C     *DTAARA       DEFINE                  ENVDFT                         Get System
     C                   IN        ENVDFT                                       Defaults
     C                   MOVEL     LMSGQ         #MSGQ            20
     C                   MOVE      LMSGQL        #MSGQ
      *
     C                   Z-ADD     1             RPTLYO
     C                   MOVE      'N'           LVBKFF
     C                   MOVE      'Y'           PRTDES
     C                   MOVEL     '*ALL'        @BUNDL
     C                   MOVEL     '*ALL'        @SUBSC
     C                   MOVEL     '*ALL'        @REPT
     C                   MOVEA     '000'         *IN(31)
     C                   MOVE      *BLANKS       ERRMSG
      *
<--1dC     *INLR         DOWEQ     *OFF
|    C                   EXFMT     INPUT
/1452C     @1            TAG
|     *
<--2 C     KEY           IFEQ      F3
|    C     KEY           OREQ      F12
|    C                   MOVE      *ON           *INLR
|    C                   RETURN                                                                MainLn
|__2 C                   END
|     * Help
<--2 C     KEY           IFEQ      HELP
|    C                   MOVEL(P)  'INPUT'       HLPFMT
|    C                   CALL      'SPYHLP'
|    C                   PARM      'MAG602FM'    DSPFIL           10
|    C                   PARM                    HLPFMT           10
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      INPUT                                  99
/1452C                   MOVE      #IN99         *IN99
^^1  C*/1452               ITER
/1452C                   GOTO      @1
|__2 C                   END
|     *
|    C                   MOVE      *BLANKS       TMP
|    C                   MOVE      *BLANKS       ERRMSG
|    C                   MOVEA     '000000'      *IN(31)
|     * F4=Prompt
<--2 C     KEY           IFEQ      F4
|     *
<--3sC                   SELECT
| -3wC     FLD           WHENEQ    '@BUNDL'
|    C                   CALL      'WRKBND'
|    C                   PARM                    @BUNDL
|    C                   PARM      '1'           WLIST             1
|    C                   PARM                    RTNCDE            8
|    C                   MOVE      *ON           *IN34
^^1  C                   ITER
| -3wC     FLD           WHENEQ    '@SUBSC'
|    C                   MOVE      'ERR0013'     MSGID
|    C                   EXSR      RTVMSG
|    C                   MOVEL     MSGTXT        ERRMSG
|    C                   MOVE      *ON           *IN35
^^1  C                   ITER                                                                  MainLn
| -3wC     FLD           WHENEQ    '@REPT'
|    C                   CALL      'WRKRPT'
|    C                   PARM      *BLANKS       PRMFLD           10
|    C                   PARM      *BLANKS       PRMFLD           10
|    C                   PARM      *BLANKS       PRMPOS           10
|    C                   PARM      '*SELECT'     PRMOPC           10
|    C                   PARM                    @REPT
|    C                   PARM                    @WRNAM           10
|    C                   PARM                    @WJNAM           10
|    C                   PARM                    @WPNAM           10
|    C                   PARM                    @WUNAM           10
|    C                   PARM                    @WUDAT           10
|    C                   PARM                    RTNCDE
|    C                   MOVE      *ON           *IN36
^^1  C                   ITER
|     *
| -3wC                   OTHER
|    C                   MOVE      'ERR0013'     MSGID
|    C                   EXSR      RTVMSG
|    C                   MOVEL     MSGTXT        ERRMSG
^^1  C                   ITER
|__3sC                   ENDSL
|__2 C                   END
|     *
<--2 C     RPTLYO        IFNE      1
|    C     RPTLYO        ANDNE     2
|    C     RPTLYO        ANDNE     3
|    C                   Z-ADD     1             RPTLYO
|    C                   MOVE      *ON           *IN31
|    C                   MOVE      'E602001'     MSGID                                         MainLn
|    C                   EXSR      RTVMSG
|    C                   MOVEL     MSGTXT        ERRMSG
^^1  C                   ITER                                                   Error
|__2 C                   END
|     *
<--2 C     LVBKFF        IFNE      'Y'
|    C     LVBKFF        ANDNE     'N'
|    C                   MOVE      'N'           LVBKFF
|    C                   MOVE      *ON           *IN32
|    C                   MOVE      'E602002'     MSGID
|    C                   EXSR      RTVMSG
|    C                   MOVEL     MSGTXT        ERRMSG
^^1  C                   ITER                                                   Error
|__2 C                   END
|     *
<--2 C     PRTDES        IFNE      'Y'
|    C     PRTDES        ANDNE     'N'
|    C                   MOVE      'Y'           PRTDES
|    C                   MOVE      *ON           *IN33
|    C                   MOVE      'E602002'     MSGID
|    C                   EXSR      RTVMSG
|    C                   MOVEL     MSGTXT        ERRMSG
^^1  C                   ITER                                                   Error
|__2 C                   END
|     *
<--2 C     @BUNDL        IFEQ      *BLANKS
|    C                   MOVEL     '*ALL'        @BUNDL
|__2 C                   END
|     *
<--2 C     @SUBSC        IFEQ      *BLANKS                                                     MainLn
|    C                   MOVEL     '*ALL'        @SUBSC
|__2 C                   END
|     *
<--2 C     @REPT         IFEQ      *BLANKS
|    C                   MOVEL     '*ALL'        @REPT
|__2 C                   END
|     *
-¬1  C                   LEAVE
|__1 C                   END
      *------------------------------------
      * Create dup of file MAG601A in QTemp
      *------------------------------------
     C                   MOVE      #OBJA         OBJTYP
     C                   MOVE      'A'           SUFFIX            1
     C                   EXSR      DUPFIL
<--1 C     *IN81         IFEQ      *ON
|    C                   MOVE      *BLANKS       MSGTXT                         Error
|    C                   MOVE      'ERR0001'     MSGID                          creating
|    C                   EXSR      SNDMSG                                       temp file
|   GC                   GOTO      FINI
|__1 C                   END
     C                   OPEN      MAG601A
      * Fill temp file
     C                   EXSR      BNDRED                                           (1)
      *
<--1dC     *IN65         DOWEQ     *OFF                                         Record found
|     *
|    C                   MOVE      *BLANKS       #HBUN            10
|    C     BNDLID        SETLL     DSTDEF2                                66        (2)
|     *                                                                   MainLn
<--2 C     *IN66         IFEQ      *ON                                          Record found
|    C                   EXSR      DDFRED                                           (2)
|     *
<--3dC     *IN66         DOWEQ     *OFF                                         Record found
|    C                   MOVE      BPRTY         #BPRIO
|    C                   MOVE      BNDLID        #BUNDL
|    C                   MOVE      RDSUBR        #SUBSC
|    C                   MOVE      RDREPT        #REPT
|    C                   MOVE      RDPRTY        #SPRIO
|    C                   MOVE      RDSEG         #SEGMT
|    C                   WRITE     RC601A
|     *
|    C                   EXSR      DDFRED                                           (2)
|__3 C                   END
|__2 C                   END
|     *
|    C                   EXSR      BNDRED                                           (1)
|__1 C                   END
     C                   CLOSE     MAG601A
      * OpnQryF
<--1 C     @BUNDL        IFNE      '*ALL'
|    C     @SUBSC        ORNE      '*ALL'
|    C     @REPT         ORNE      '*ALL'
|    C     RPTLYO        ORNE      1
|     *
|    C                   MOVE      *OFF          *IN80
|    C                   MOVEL(P)  CL(5)         CLCMD
<--2 C     @BUNDL        IFNE      '*ALL'
|    C                   MOVE      *ON           *IN80
|    C                   CAT       CL(11):1      CLCMD                                         MainLn
|    C                   CAT       '#BUNDL':0    CLCMD
|    C     '*'           SCAN      @BUNDL                                 81
|    C                   CAT       '*EQ':1       CLCMD
|    C   81              CAT       CL(7):1       CLCMD
|    C  N81              CAT       '"':1         CLCMD
|    C                   CAT       @BUNDL:0      CLCMD
|    C                   CAT       '")':0        CLCMD
|    C   81              CAT       ')':0         CLCMD
|__2 C                   END
|     *
<--2 C     @SUBSC        IFNE      '*ALL'
<--3 C     *IN80         IFEQ      *OFF
|    C                   CAT       CL(11):1      CLCMD
--E3 C                   ELSE
|    C                   CAT       '*AND (':1    CLCMD
|__3 C                   END
|    C                   MOVE      *ON           *IN80
|    C                   CAT       '#SUBSC':0    CLCMD
|    C     '*'           SCAN      @SUBSC                                 81
|    C                   CAT       '*EQ':1       CLCMD
|    C   81              CAT       CL(7):1       CLCMD
|    C  N81              CAT       '"':1         CLCMD
|    C                   CAT       @SUBSC:0      CLCMD
|    C                   CAT       '")':0        CLCMD
|    C   81              CAT       ')':0         CLCMD
|__2 C                   END
|     *
<--2 C     @REPT         IFNE      '*ALL'
<--3 C     *IN80         IFEQ      *OFF
|    C                   CAT       CL(11):1      CLCMD                                         MainLn
--E3 C                   ELSE
|    C                   CAT       '*AND (':1    CLCMD
|__3 C                   END
|    C                   MOVE      *ON           *IN80
|    C                   CAT       '#REPT':0     CLCMD
|    C     '*'           SCAN      @REPT                                  81
|    C                   CAT       '*EQ':1       CLCMD
|    C   81              CAT       CL(7):1       CLCMD
|    C  N81              CAT       '"':1         CLCMD
|    C                   CAT       @REPT:0       CLCMD
|    C                   CAT       '")':0        CLCMD
|    C   81              CAT       ')':0         CLCMD
|__2 C                   END
|     *
<--2 C     *IN80         IFEQ      *ON
|    C                   CAT       ''')':0       CLCMD
|__2 C                   END
|     *
<--2sC                   SELECT
| -2wC     RPTLYO        WHENEQ    1                                            Bundle
|    C                   CAT       CL(8):1       CLCMD
| -2wC     RPTLYO        WHENEQ    2                                            Subscriber
|    C                   CAT       CL(9):1       CLCMD
| -2wC     RPTLYO        WHENEQ    3                                            Report Type
|    C                   CAT       CL(10):1      CLCMD
|__2sC                   ENDSL
|     *
|    C                   CALL      'QCMDEXC'                            81
|    C                   PARM                    CLCMD           255
|    C                   PARM      255           CLLEN            15 5                         MainLn
|__1 C                   END
      *
<--1sC                   SELECT
| -1wC     RPTLYO        WHENEQ    1                                            Bundle
|    C                   CALL      'MAG602A'
|    C                   PARM                    LVBKFF
|    C                   PARM                    PRTDES
| -1wC     RPTLYO        WHENEQ    2                                            Subscriber
|    C                   CALL      'MAG602B'
|    C                   PARM                    LVBKFF
|    C                   PARM                    PRTDES
| -1wC     RPTLYO        WHENEQ    3                                            Report Type
|    C                   CALL      'MAG602C'
|    C                   PARM                    LVBKFF
|    C                   PARM                    PRTDES
|__1sC                   ENDSL
      *
     C                   MOVEL(P)  CL(6)         CLCMD
     C                   CALL      'QCMDEXC'                            81
     C                   PARM                    CLCMD           255
     C                   PARM      255           CLLEN            15 5
<--1 C     *IN81         IFEQ      *ON
|__1 C                   END
      *>>>>>>>>>>FINI
     C     FINI          TAG
     C                   CLOSE     MAG601A
     C                   MOVE      'A'           SUFFIX
     C                   EXSR      RMVOVR
     C                   MOVE      *ON           *INLR
      *                                                                   MainLn
      *
      *@$$$$$$$$ DUPFIL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DUPFIL        BEGSR
      *          Create a MAG601_ temp file
      *
     C                   EXSR      CHKOBJ
      *
<--1 C     @ERTCD        IFNE      0
|    C     CL(1)         CAT(P)    WQLIBN:0      CLCMD
|    C                   CAT       ')':0         CLCMD
--E1 C                   ELSE
|    C     CL(2)         CAT(P)    SUFFIX:0      CLCMD
|    C                   CAT       ')':0         CLCMD
|__1 C                   END
      *
     C                   CALL      'QCMDEXC'                            81
     C                   PARM                    CLCMD           255
     C                   PARM      255           CLLEN            15 5
<--1 C     *IN81         IFEQ      *ON
|   GC                   GOTO      ENDDUP
|__1 C                   END
      *
     C                   EXSR      OVRFIL
     C     ENDDUP        ENDSR
      *
      *@$$$$$$$$ OVRFIL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OVRFIL        BEGSR
      *          Override File
      *
     C                   MOVEL(P)  CL(3)         CLCMD                          OvrDbf
     C                   CALL      'QCMDEXC'                            81
     C                   PARM                    CLCMD
     C                   PARM      255           CLLEN
     C                   ENDSR
      *
      *@$$$$$$$$ CHKOBJ $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKOBJ        BEGSR
      *          Check object existence
      *
     C                   Z-ADD     116           @ERLEN
     C                   CALL      'QUSROBJD'                                   33 - 9
     C                   PARM                    @OBJD                          Retrieve
     C                   PARM      90            APILEN                         Object
     C                   PARM      'OBJD0100'    APIFMT            8            Description
     C                   PARM                    OBJTYP           20
     C                   PARM      '*FILE'       APITYP           10
     C                   PARM                    ERRCD
     C                   ENDSR
      *
      *@$$$$$$$$ BNDRED $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     BNDRED        BEGSR
      *          Bundle Def file read
      *
      *>>>>>>>>>>BR1
     C     BR1           TAG
    IC                   READ      BNDDEF                                 65        (1)
<--1 C     *IN65         IFEQ      *OFF
|    C     BSTAT         ANDEQ     'D'
|   GC                   GOTO      BR1
|__1 C                   END
     C                   ENDSR
      *
      *@$$$$$$$$ DDFRED $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DDFRED        BEGSR
      *          Distribution Def file read
      *
      *>>>>>>>>>>DF1
     C     DF1           TAG
    IC                   READ      DSTDEF2                                66        (2)
<--1 C     *IN66         IFEQ      *OFF
<--2 C     #HBUN         IFNE      *BLANKS
|    C     #HBUN         ANDNE     RDBNDL
|    C                   MOVE      *ON           *IN66
--E2 C                   ELSE
<--3 C     RDSTAT        IFEQ      'D'
|   GC                   GOTO      DF1
|__3 C                   END
|__2 C                   END
|    C  N66              MOVE      RDBNDL        #HBUN            10
|__1 C                   END
     C                   ENDSR
      *
      *@$$$$$$$$ RMVOVR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RMVOVR        BEGSR
      *          Remove OvrDbf
      *
     C                   MOVEL(P)  CL(4)         CLCMD
     C                   CALL      'QCMDEXC'                            81
     C                   PARM                    CLCMD
     C                   PARM      255           CLLEN
     C                   ENDSR
      *
      *@$$$$$$$$ RTVMSG $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVMSG        BEGSR
      *          Retrieve Messages from PSCON
      *
     C                   MOVEA(P)  TMP           MSGTXT
     C     ' '           CHECKR    MSGTXT        @MSGLN
     C                   Z-ADD     116           @ERLEN
      *
     C                   CALL      'QMHRTVM'                                    18 - 16
     C                   PARM                    @MSGDT                         Retrieve
     C                   PARM      103           APILEN                         Message
     C                   PARM      'RTVM0100'    APIFMT            8
     C                   PARM                    MSGID
     C                   PARM      PSCON         @MSGFL
     C                   PARM                    MSGTXT
     C                   PARM                    @MSGLN
     C                   PARM      '*YES'        MSGSUB           10
     C                   PARM      '*NO'         MSGCTL           10
     C                   PARM                    ERRCD
      *
     C                   MOVE      *BLANKS       MSGTXT
     C     ERRLEN        ADD       1             #E                3 0
     C                   MOVEA     *BLANKS       @EM(#E)
     C                   MOVEA     @EM           MSGTXT
     C                   ENDSR
      *
      *@$$$$$$$$ SNDMSG $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDMSG        BEGSR
      *          Send a Non-Program Message
      *
     C                   MOVEA(P)  TMP           MSGTXT
     C     ' '           CHECKR    MSGTXT        @MSGLN
     C                   Z-ADD     116           @ERLEN
      *
     C                   CALL      'QMHSNDM'                                    18 - 22
     C                   PARM                    MSGID             7            Send Non-Pgm
     C                   PARM      PSCON         @MSGFL           20            Message
     C                   PARM                    MSGTXT           80
     C                   PARM                    @MSGLN                         B
     C                   PARM      '*INFO'       @MSGTY           10
     C                   PARM      #MSGQ         @MSGQ            20
     C                   PARM      1             @MSGQ#                         B
     C                   PARM      *BLANKS       @MSGR            20
     C                   PARM      *BLANKS       @MSGKY            4
     C                   PARM                    ERRCD
     C                   ENDSR
**
CRTDUPOBJ OBJ(MAG601A) OBJTYPE(*FILE) TOLIB(QTEMP) FROMLIB(
CLRPFM FILE(QTEMP/MAG601
OVRDBF FILE(MAG601A) SHARE(*YES) TOFILE(QTEMP/MAG601A)
DLTOVR FILE(MAG601A)
OPNQRYF FILE((MAG601A))
CLOF OPNID(MAG601A)
%WLDCRD("
KEYFLD((#BUNDL) (#SUBSC) (#REPT) (#SEGMT))
KEYFLD((#SUBSC) (#BUNDL) (#REPT) (#SEGMT))
KEYFLD((#REPT) (#BUNDL) (#SUBSC) (#SEGMT))
QRYSLT('(

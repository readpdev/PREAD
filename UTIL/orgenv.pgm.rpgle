      *%METADATA                                                       *
      * %TEXT Set Organizer Job Attributes Program                     *
      *%EMETADATA                                                      *
      ********* -----------------------------------------
      * ORGENV  Load LDA with Organizer Environment Parms
      ********* -----------------------------------------
      *
/1452 * 10-31-00 JAM PREVENT LOSS OF SCREEN DATA ON HELP.
      * 12-10-96 GK  Add Personal Help.
      *  6-10-93 DM  Program created
      *  1-13-95 Dlm Add code to save and restore library list
      *  5-16-95 JJF Add application security.
      *
     FORGENVD   CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS)
     D ARY             S              1    DIM(10)
      *
      * Named hexadecimal constants for functions keys
     D*@  IND INPT CALC  OUT    IND INPT CALC  OUT    IND INPT CALC  OUT
     D*@   LR        MO          72        MOX         75        MOX
     D*@   50        M           73        MOX         76        MOX
     D*@   60        MOX         74        MOX         81        M
     D*@   71        MOX
     D*@  *MAIN*       @ASEC  @SNDMG @OBJCK @SNDMG SELDES @OBJCK @SNDMG
     D*@               SELMSQ @SNDMG @OBJCK @SNDMG @OBJCK @SNDMG @OBJCK
     D*@               @SNDMG @OBJCK @SNDMG LDAOUT
     D*@ GARY/QRPGSRC/ORGENV              12/10/96 at 16:59:14 by GARY
     D*@
     D F03             C                   CONST(X'33')
     D F04             C                   CONST(X'34')
     D F12             C                   CONST(X'3C')
     D HELP            C                   CONST(X'F3')
      *
     D ENVDFT          DS          1024
     D  LORGNM                 1     10
     D  LORGDS                11     20
     D  LORGLB                21     30
     D  LORGPT                31     32
     D SYSDFT          DS          1024
     D  LMONMQ                33     42
     D  LMONML                43     52
      *
     D                SDS
     D  WQPGMN                 1     10
     D  WQLIBN                81     90
     D INFDS           DS
     D  KEY                  369    369
      *
     C                   EXSR      @ASEC                                        APPL SECUR.
<--1 C     AUTRTN        IFEQ      'N'                                          User not
|    C                   MOVE      'SPY0013'     @MSGID                          auth to run
|    C                   EXSR      @SNDMG
|__1 C                   END
      *--------
      * Display
      *--------
      *>>>>>>>>>>DSPLY
     C     DSPLY         TAG                                                    Display     MainLine
     C                   EXFMT     PRMPT
      *
/1452C     KEY           DOWEQ     HELP                                         Help
|    C                   MOVEL(P)  'PRMPT'       HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
|    C     PLHELP        PLIST
|    C                   PARM      'ORGENVD'     DSPFIL           10
|    C                   PARM                    HLPFMT           10
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      PRMPT                                  99
/1452C                   MOVE      #IN99         *IN99
|   GC*/1452               GOTO DSPLY
/1452C                   ENDDO                                                              MainLine
      *
      *-------
      * F3/F12
      *-------
<--1 C     KEY           IFEQ      F03
|    C     KEY           OREQ      F12
|   GC                   GOTO      PGMEND
|__1 C                   ENDIF
      *
<--1 C     AUTRTN        IFEQ      'N'                                          User not    MainLine
|   GC                   GOTO      DSPLY                                          AUTH.
|__1 C                   END
      *
     C                   MOVE      *OFF          *IN60                          Error Ind
     C                   MOVE      *BLANKS       @MSGID            7
     C                   MOVE      *BLANKS       LKPOBJ
     C                   MOVE      *BLANKS       LKPLIB
     C                   MOVE      *BLANKS       LKPTYP
      * Set Screen Inds off
     C                   MOVEA     '000000'      *IN(71)                                    MainLine
     C                   MOVEL     FLD           FLD6              6            Field in
      *
      * If F4 Cursor in Field (Monitor Description)
      *
<--1 C     KEY           IFEQ      F04
|    C     FLD6          ANDEQ     'SORGDS'                                     Organiz Desc
|    C     SORGLB        ANDNE     *BLANKS                                      Validation
|    C                   MOVEL     SORGLB        @OBJ                           when F4
|    C                   MOVEL     'QSYS'        @OBJL                          is selected
|    C                   MOVEL     '*LIB'        @OBJT                                      MainLine
|    C                   EXSR      @OBJCK
<--2 C     @OBJRC        IFEQ      '1'
|    C                   MOVE      'SPY0001'     @MSGID                         F04 and
|    C                   MOVE      *ON           *IN73                          Library
|    C                   EXSR      @SNDMG                                       Invalid
|   GC                   GOTO      DSPLY
|__2 C                   ENDIF                                                  Validation
|__1 C                   ENDIF                                                  End
      *
<--1 C     KEY           IFEQ      F04                                                      MainLine
|    C     FLD6          ANDEQ     'SORGDS'                                     Organiz Desc
|     *                                                    F4 Selected
|    C                   MOVEA     SORGDS        ARY
|    C                   MOVE      *BLANKS       LKPOBJ
|    C                   Z-ADD     1             X                 2 0
|    C     '*'           LOOKUP    ARY(X)                                 50     EQ
<--2 C     *IN50         IFNE      '1'                                          Handles
|    C                   MOVEL     '*ALL'        LKPOBJ                         '*' entries
->E2 C                   ELSE                                                   in Object
|    C                   MOVEL     SORGDS        LKPOBJ                         (SORGDS)    MainLine
|__2 C                   ENDIF
|     *
<--2 C     SORGLB        IFEQ      *BLANKS
|    C                   MOVEL     '*ALL'        LKPLIB                         If Library
->E2 C                   ELSE                                                   is blank
|    C                   MOVEL     SORGLB        LKPLIB                         default *ALL
|__2 C                   ENDIF
|     *
|    C                   MOVEL     '*JOBD'       LKPTYP
|    C                   EXSR      SELDES                                                   MainLine
|   GC                   GOTO      DSPLY
|__1 C                   ENDIF                                                  End Organiz
      * If F4 Cursor in Field (Spy Message Queue)
<--1 C     KEY           IFEQ      F04
|    C     FLD6          ANDEQ     'SMONMQ'                                     SpyGls  MsgQ
|    C     SMONML        ANDNE     *BLANKS                                      Validation
|    C                   MOVEL     SMONML        @OBJ                           when F4
|    C                   MOVEL     'QSYS'        @OBJL                          is selected
|    C                   MOVEL     '*LIB'        @OBJT
|    C                   EXSR      @OBJCK                                                   MainLine
<--2 C     @OBJRC        IFEQ      '1'
|    C                   MOVE      'SPY0001'     @MSGID                         F04 and
|    C                   MOVE      *ON           *IN76                          Library
|    C                   EXSR      @SNDMG                                       Invalid
|   GC                   GOTO      DSPLY
|__2 C                   ENDIF                                                  Validation
|__1 C                   ENDIF                                                  End
      *
<--1 C     KEY           IFEQ      F04
|    C     FLD6          ANDEQ     'SMONMQ'                                     Monitor MsgQMainLine
|     *                                                    F4 Selected
|    C                   MOVEA     SMONMQ        ARY
|    C                   MOVE      *BLANKS       LKPOBJ
|    C                   Z-ADD     1             X                 2 0
|    C     '*'           LOOKUP    ARY(X)                                 50     EQ
<--2 C     *IN50         IFNE      '1'                                          Handles '*'
|    C                   MOVEL     '*ALL'        LKPOBJ                         entries in
->E2 C                   ELSE                                                   Object
|    C                   MOVEL     SMONMQ        LKPOBJ                         (SMONMQ)
|__2 C                   ENDIF                                                              MainLine
|     *
<--2 C     SMONML        IFEQ      *BLANKS                                      If Library
|    C                   MOVEL     '*ALL'        LKPLIB                         is Blank
->E2 C                   ELSE                                                   default *ALL
|    C                   MOVEL     SMONML        LKPLIB
|__2 C                   END
|     *
|    C                   MOVEL     '*MSGQ'       LKPTYP
|    C                   EXSR      SELMSQ
|   GC                   GOTO      DSPLY                                                    MainLine
|__1 C                   ENDIF                                                  End Monitor
      *-----------------                                   MsgQ
      * Check For Errors
      *-----------------                                   MsgQ
<--1 C     KEY           IFEQ      F04
|    C     FLD6          ANDNE     'SMONMQ'                                     Spy     MsgQ
|    C     FLD6          ANDNE     'SORGDS'                                     Organiz Desc
|    C                   MOVE      *ON           *IN71
|    C                   MOVE      'SPY0002'     @MSGID                         F04 And not
|    C                   EXSR      @SNDMG                                       in Proper   MainLine
|   GC                   GOTO      DSPLY                                        Field
|__1 C                   ENDIF
      *
<--1 C     SORGNM        IFEQ      *BLANKS                                      Organiz Job
|    C                   MOVE      *ON           *IN71                             Name
|    C                   MOVE      'SPY0003'     @MSGID
|    C                   EXSR      @SNDMG
|   GC                   GOTO      DSPLY
|__1 C                   ENDIF
      *                                                                MainLine
     C                   MOVEL     SORGLB        @OBJ                           Organiz Job
     C                   MOVEL     'QSYS'        @OBJL                          Description
     C                   MOVEL     '*LIB'        @OBJT                          Library
     C                   EXSR      @OBJCK
<--1 C     @OBJRC        IFEQ      '1'
|    C                   MOVE      'SPY0001'     @MSGID
|    C                   MOVE      *ON           *IN73                          Library
|    C                   EXSR      @SNDMG                                       Invalid
|   GC                   GOTO      DSPLY
|__1 C                   ENDIF                                                              MainLine
      *
     C                   MOVEL     SORGDS        @OBJ                           Organiz Job
     C                   MOVEL     SORGLB        @OBJL                          Description
     C                   MOVEL     '*JOBD'       @OBJT
     C                   EXSR      @OBJCK
<--1 C     @OBJRC        IFEQ      '1'
|    C                   MOVE      'SPY0004'     @MSGID
|    C                   MOVE      *ON           *IN72                          Description
|    C                   EXSR      @SNDMG                                       Invalid
|   GC                   GOTO      DSPLY                                                    MainLine
|__1 C                   ENDIF
      *
     C                   MOVE      SORGPT        PRTY              2 0
<--1 C     PRTY          IFLT      10                                           Organiz Job
|    C                   MOVE      *ON           *IN74                          Running
|    C                   MOVE      'SPY0005'     @MSGID                         Priority
|    C                   EXSR      @SNDMG
|   GC                   GOTO      DSPLY
|__1 C                   ENDIF
      *                                                                MainLine
     C                   MOVEL     SMONMQ        MSGQ              7
<--1 C     MSGQ          IFEQ      '*SYSOPR'
|    C                   MOVE      *BLANKS       SMONMQ
|    C                   MOVEL     'QSYSOPR'     SMONMQ
|    C                   MOVE      *BLANKS       SMONML
|    C                   MOVEL     'QSYS'        SMONML
|__1 C                   ENDIF
      *
<--1 C     SMONML        IFEQ      *BLANKS                                      SpyGlass
|    C     MSGQ          ANDNE     '*SYSOPR'                                    Message     MainLine
|    C                   MOVEL     SMONML        @OBJ                           Queue
|    C                   MOVEL     'QSYS'        @OBJL                          Library
|    C                   MOVEL     '*LIB'        @OBJT
|    C                   EXSR      @OBJCK
<--2 C     @OBJRC        IFEQ      '1'
|    C                   MOVE      'SPY0001'     @MSGID
|    C                   MOVE      *ON           *IN76                          Library
|    C                   EXSR      @SNDMG                                       Invalid
|   GC                   GOTO      DSPLY
|__2 C                   ENDIF                                                              MainLine
|__1 C                   ENDIF
      *
     C                   MOVEL     SMONMQ        @OBJ                           Message
     C                   MOVEL     SMONML        @OBJL                          Queue
     C                   MOVEL     '*MSGQ'       @OBJT
     C                   EXSR      @OBJCK
<--1 C     @OBJRC        IFEQ      '1'
|    C                   MOVE      'SPY0006'     @MSGID
|    C                   MOVE      *ON           *IN75                          Queue
|    C                   EXSR      @SNDMG                                       Invalid     MainLine
|   GC                   GOTO      DSPLY
|__1 C                   ENDIF
      *
     C                   EXSR      LDAOUT
      *
      *>>>>>>>>>>PGMEND
     C     PGMEND        TAG
     C                   MOVE      *ON           *INLR
     C                   CLOSE     *ALL
     C                   CALL      'MAG1031'                                                MainLine
     C                   PARM                    WQPGMN
     C                   PARM      'Q'           #LOAD
      *
<--1 C     CHANGE        IFEQ      1
|    C                   MOVE      *BLANKS       CLCMD
|    C     'RMVLIBLE'    CAT       WQLIBN:1      CLCMD
|    C                   CALL      'QCMDEXC'                            81
|    C                   PARM                    CLCMD
|    C                   PARM      255           CLLEN            15 5
|__1 C                   END                                                                MainLine
      *
     C                   RETURN
      *
     C*@$$$$$$$$ LDAOUT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LDAOUT        BEGSR
      *          Update Data Area
     C     *LOCK         IN        ENVDFT
      *
     C                   MOVE      SORGNM        LORGNM                         Move Screen
     C                   MOVE      SORGDS        LORGDS                         fields back
     C                   MOVE      SORGLB        LORGLB                         to Default
     C                   MOVE      SORGPT        LORGPT                         fields
     C                   OUT       ENVDFT
     C     *LOCK         IN        SYSDFT                                                   LDAOUT
      *
<--1 C     MSGQ          IFEQ      '*SYSOPR'
|    C                   MOVE      *BLANKS       SMONMQ
|    C                   MOVEL     'QSYSOPR'     SMONMQ
|    C                   MOVEL     'QSYS'        SMONML
|__1 C                   ENDIF
      *
     C                   MOVE      SMONMQ        LMONMQ
     C                   MOVE      SMONML        LMONML
     C                   OUT       SYSDFT                                                   LDAOUT
     C                   ENDSR
     C*@$$$$$$$$ @SNDMG $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @SNDMG        BEGSR
      *           Send Error Messages
     C                   MOVE      *ON           *IN60
     C                   ENDSR
     C*@$$$$$$$$ @OBJCK $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @OBJCK        BEGSR
      *
      *          Check For OBJECT EXISTENCE.
      *          Return Codes: '0' = Object EXISTS
      *                        '1' = Object DOES NOT EXIST
      *
     C                   MOVE      '0'           @OBJRC
     C                   CALL      'SPCHKOBJ'    @CKOPL
     C                   MOVE      *BLANKS       @OBJ
     C                   MOVE      *BLANKS       @OBJL                                      @OBJCK
     C                   MOVE      *BLANKS       @OBJT
     C                   ENDSR
     C*@$$$$$$$$ SELDES $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SELDES        BEGSR
      *          Select Description
     C                   CALL      'MAG2042'     @GETNM
<--1 C     RETOBJ        IFNE      *BLANKS
|    C                   MOVEL     RETOBJ        SORGDS
|    C                   MOVEL     RETLIB        SORGLB
|__1 C                   END
     C                   ENDSR
     C*@$$$$$$$$ SELMSQ $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SELMSQ        BEGSR
      *          Select MessageQ
     C                   CALL      'MAG2042'     @GETNM
<--1 C     RETOBJ        IFNE      *BLANKS
|    C                   MOVEL     RETOBJ        SMONMQ
|    C                   MOVEL     RETLIB        SMONML
|__1 C                   END
     C                   ENDSR
      *@$$$$$$$$ @ASEC  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @ASEC         BEGSR
      *           Application security
     C                   CALL      'MAG1060'
     C                   PARM      'ORGENV'      CALPGM           10            Calling pgm
     C                   PARM      'N'           PGMOFF            1            Unload pgm
     C                   PARM      'O'           CKTYPE            1            Chk type
     C                   PARM      'A'           OBJCOD            1            Obj type
     C                   PARM      'ORGENV'      OBJNAM           10            Object name
     C                   PARM      WQLIBN        OBJLIB           10            Object libr
     C                   PARM      *BLANKS       RNAME            10            Report Name @ASEC
     C                   PARM      *BLANKS       JNAME            10            Job Name
     C                   PARM      *BLANKS       PNAME            10            Program
     C                   PARM      *BLANKS       UNAME            10            User name
     C                   PARM      *BLANKS       UDATA            10            User data
     C                   PARM      07            REQOPT            2 0          Reqst Opt
     C                   PARM      *BLANKS       AUTRTN            1            Return Y/N
     C                   ENDSR
      *
     C*@$$$$$$$$ *INZSR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
     C                   Z-ADD     0             CHANGE            1 0
     C                   MOVE      *BLANKS       CLCMD           255
     C     'ADDLIBLE'    CAT       WQLIBN:1      CLCMD
      *
     C                   CALL      'QCMDEXC'                            81
     C                   PARM                    CLCMD
     C                   PARM      255           CLLEN            15 5
<--1 C     *IN81         IFEQ      *OFF
|    C                   Z-ADD     1             CHANGE                                     *INZSR
|__1 C                   END
      *
     C                   CALL      'MAG1031'
     C                   PARM                    WQPGMN
     C                   PARM      ' '           #LOAD             1
     C                   CALL      'MAG103A'                            81
<--1 C     *IN81         IFEQ      *ON
|    C                   CALL      'MAG1031'
|    C                   PARM                    WQPGMN
|    C                   PARM      'Q'           #LOAD                                      *INZSR
|    C                   MOVE      *ON           *INLR
|    C                   RETURN
|__1 C                   END
      *
     C                   OPEN      ORGENVD
      *-----------
      * Parm Lists
      *-----------
     C     @CKOPL        PLIST                                                  PGM: SPCHKOBJ
     C                   PARM                    @OBJ             10                        *INZSR
     C                   PARM                    @OBJL            10
     C                   PARM                    @OBJT            10
     C                   PARM                    @OBJRC            1
      *
     C     @GETNM        PLIST                                                  PGM: MAG2042G
     C                   PARM                    LKPOBJ           10
     C                   PARM                    LKPLIB           10
     C                   PARM                    LKPTYP           10
     C                   PARM      *BLANKS       LKPATR           10
     C                   PARM      *BLANKS       RETOBJ           10                        *INZSR
     C                   PARM      *BLANKS       RETLIB           10
      *----------------
      * Open Data Areas
      *----------------
     C     *DTAARA       DEFINE                  ENVDFT                         Get System
     C                   IN        ENVDFT                                       Defaults
     C                   MOVE      LORGNM        SORGNM                         Move default
     C                   MOVE      LORGDS        SORGDS                         fields to
     C                   MOVE      LORGLB        SORGLB                         Screen
     C                   MOVE      LORGPT        SORGPT                         fields      *INZSR
      *
     C     *DTAARA       DEFINE                  SYSDFT                         Get System
     C                   IN        SYSDFT                                       Defaults
     C                   MOVE      LMONMQ        SMONMQ
     C                   MOVE      LMONML        SMONML
     C                   ENDSR

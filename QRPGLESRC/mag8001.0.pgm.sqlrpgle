     h bnddir('SPYBNDDIR')
      /copy directives

      **********-----------------------------
      * MAG8001  WORK WITH PROCESS DEFINITION
      **********-----------------------------
      *
      *    F. BRUEGGE    2/96

J6516 * 05-24-17 PLR Slightly tweak 6517 code to be more generically used by
      *              other edits that need to convert the overloaded procedure
      *              format.
J6517 * 03-31-17 PLR Fix position-to feature to work with overloaded
      *              (numeric id | folder) data. Was not positioning correctly.
J5177 * 08-06-13 EPG Correct an issue with selecting the correct
      *              subfile record with an option 2.
J4439 * 09-12-12 PLR Rename and copy options bring up wrong process when
      *              multiple records exist.
J3248 * 01-26-11 EPG Convert to ILE and iinclude new alias
/     *              file.
/1452 * 10-31-00 JAM PREVENT LOSS OF SCREEN DATA ON HELP.
      *
      *  6-24-97 JJF Add Personal Help.
      *
      *       01         VALIDCMDKEY
      *       02         CHANGE MATCHCODE FIELD
      *       10         DISPLAY OPTION IN SUBFILE
      *       11         SUBFILE NEXT CHANGE
      *                  POSITION CURSOR
      *       50         ERROR
      *       60 - 62    ERROR ON SFL
      *       70 - 71    SFC1
      *       74         SFLDROP ETC.
      *       75         MSGSFL
      *       96         ROLDOWN ACTIVE
      *       97         ROLDOWN RESPONSE
      *       98         ROLUP   ACTIVE
      *       99         ROLUP   RESPONSE
      *
     FMAG8001F  CF   E             WORKSTN INFDS(DSDSP)
     F                                     SFILE(SFL1:RCD1)
     F                                     SFILE(SFL2:RCD2)
     FWVPROP    UF A E           K DISK
     FWVSECP    UF A E           K DISK    USROPN
     FWVTRAP    UF A E           K DISK    USROPN
     FWVTADP    UF A E           K DISK    USROPN
     FWVSPYP    UF A E           K DISK    USROPN
     FWVLDDP    UF A E           K DISK    USROPN
     FSPYCTL    IF   E           K DISK    USROPN
J3248FWVOTXP    UF A E           K DISK
      *
J3248 * Prototypes -----------------------------------------------------------------------------------
/    dGetProcName      pr            21a
/    d  pProcKey                     10a   const
/
/     /include @spyhlp
/     /include @mmmsgio

J3248 * Constants ------------------------------------------------------------------------------------
/     /include @fkeys
/    d TRUE            c                   '1'
/    d FALSE           c                   '0'
/    d AUTTYP_PROCESS  c                   '*PROCESS'
/    d AUT_ALL         c                   '*ALL'
/    d AUT_USRDFN      c                   '*USRDFN'
/    d AUT_NONE        c                   '*NONE'
/    d AUT_ACT         c                   '*ACTAUT'
/    d USRTYP_USER     c                   'U'
/    d TYPE_CAPTARIS   c                   'C'

/     * Data Structures ------------------------------------------------------------------------------\
J3248d hashkey         ds                  qualified
/    D  ModelID                      10u 0 inz(*hival)
/    D  FolderID                     10u 0 inz(*hival)
/    d  buffer                        2a   inz(*blanks)

J3248D IndicatorsDS    ds                  based(p_Indicators)
/    d  blnValidFunctionKey...
     d                        01     01n
/    d  blnDefExist           60     60n
/    d  blnDefInvalid         61     61n
/    d  blnAutInvalid         62     62n

     D PGMSDS         SDS           528
     D  PGMQ             *PROC
     D  ERRNR                 40     46
     D  ERRMSG                91    170
     D  ERRFIL               201    210
     D  USERID               254    263
     D                 DS                  INZ
     D  STKCNT                 1      4B 0
     D  DTALEN                 5      8B 0
     D  ERRCOD                 9     12B 0
     D DSDSP           DS
     D  KEY                  369    369
     D  CSRLOC               370    371B 0
     D  SFLZ                 378    379B 0
     D  WINLOC               382    383B 0
     D                 DS                  INZ
     D  RCVERR                 1    100
     D  ERRPRO                 1      4B 0
     D  ERRAVA                 5      8B 0
     D  ERRDTA                17    100
     D ACTKEY          DS                  INZ
     D  FAPRO                  1     10
     D BEFKEY          DS                  INZ
     D  BEFPRO                 1     10
     D FSTKEY          DS                  INZ
     D  FSTPRO                 1     10    inz(*allx'00')
     D LSTKEY          DS                  INZ
     D  LSTPRO                 1     10    inz(*allx'FF')
     D AFTKEY          DS                  INZ
     D  AFTPRO                 1     10
      *
     D TRNACT          C                   CONST('*TRANSACT')
J3248 * Variables -----------------------------------------------------
/    d blnAut          s               n   inz(FALSE)
/    d blnError        s               n   inz(FALSE)
/    d MsgID           s              7a
/    d p_Indicators    s               *   inz(%addr(*in))

/    d strMsg          s             60a
      *----------------------------------------------------------------
      *
       exec sql set option commit=*none, closqlcsr=*endmod;

     C     *ENTRY        PLIST
     C                   PARM                    SETPRO
      *
     C     *LIKE         DEFINE    RCD1          TRCD1
     C     *LIKE         DEFINE    RCD1          TRCD2
     C                   WRITE     WIN01
     C                   WRITE     FKEYS
     C                   CLEAR                   BEFKEY                                     MainLine
/       //           Change the lower limit value from
/       //           all blanks to the binary value of zeros
/
/                        If ( ( %parms = 1        ) and
/                             ( SetPro <> *blanks )      );
/                          FstPro = SetPro;
/                         Else;
/                          Reset FstPro;
/                        EndIf;
     C                   SETOFF                                       96
     C                   EXSR      UPUP
      *>>>>>>>>>>IN01
     C     IN01          TAG
      *
<--1 C     *INKD         IFEQ      *OFF
|    C                   CLEAR                   WINLIN
|    C                   CLEAR                   WINPOS
|__1 C                   END                                                                MainLine
      *
<--1 C     TRCD1         IFEQ      *ZEROS                                        KEIN SATZ
|    C                   MOVE      *ON           *IN71                           IN SUBFILE
|    C                   WRITE     NORCD
->E1 C                   ELSE
|    C                   MOVE      *OFF          *IN71
|__1 C                   END
      *
<--1 C     SFLRC1        IFGT      TRCD1
|    C                   Z-ADD     TRCD1         SFLRC1                                     MainLine
|__1 C                   ENDIF
      *
<--1 C     SFLRC1        IFEQ      0
|    C                   Z-ADD     1             SFLRC1
|__1 C                   ENDIF
      *
     C                   MOVE      *OFF          *IN70
     C                   WRITE     MSGSFC
      *                 |-------------|
     C                   EXFMT     SFC1                                          CHOICE     MainLine
      *                 |-------------|
     C                   MOVEA     '000000'      *IN(60)
     C                   Z-ADD     SFLZ          SFLRC1
     C                   EXSR      CLRMSG
      *-------
      * F KEYS
      *-------
<--1 C     *IN01         IFEQ      *ON                                           VLDCMDKEY
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'SFC1'        HLPFMT                                     MainLine
|    C                   CALL      'SPYHLP'      PLHELP
|    C     PLHELP        PLIST
|    C                   PARM      'MAG8001F'    DSPFIL           10
|    C                   PARM                    HLPFMT           10
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      SFC1                                   99
/1452C                   MOVE      #IN99         *IN99
|   GC                   GOTO      IN01
|__2 C                   END
<--2 C     *INKC         CASEQ     *ON           QUIT                            F3
|    C     *INKL         CASEQ     *ON           QUIT                            F12
|    C     *INKF         CASEQ     *ON           SRF6                            F6
|    C     *INKV         CASEQ     *ON           SRF21                           F21
|__2 C                   ENDCS
<--2 C     *IN99         IFEQ      *ON                                           ROLLUP
<--3 C     *IN02         IFNE      *ON
|    C     *IN03         ANDNE     *ON
|    C                   MOVE      AFTKEY        FSTKEY
|    C                   MOVE      LSTKEY        BEFKEY
|    C                   EXSR      REDSFL
|    C                   EXSR      UPUP
|   GC                   GOTO      IN01
|__3 C                   END                                                                MainLine
|__2 C                   END
<--2 C     *IN97         IFEQ      *ON                                           ROLLDOWN
<--3 C     *IN02         IFNE      *ON
|    C     *IN03         ANDNE     *ON
|    C                   MOVE      BEFKEY        LSTKEY
|    C                   MOVE      FSTKEY        AFTKEY
|    C                   EXSR      REDSFL
|    C                   EXSR      UPDOWN
|   GC                   GOTO      IN01
|__3 C                   END                                                                MainLine
|__2 C                   END
|__1 C                   END
      *--------
      * REFRESH
      *--------
<--1 C     *INKE         IFEQ      *ON
|    C     *IN02         OREQ      *ON
|    C     *IN03         OREQ      *ON
<--2 C     *IN02         IFEQ      *ON
|    C     *IN03         OREQ      *ON                                                      MainLine
|    C                   MOVE      SETPRO        FSTPRO
|__2 C                   ENDIF
|    C                   EXSR      REDSFL
|    C                   EXSR      UPUP
|__1 C                   END
      *
     C                   EXSR      REDSFL
    GC                   GOTO      IN01
      *
      *                                                                MainLine
      *@$$$$$$$$ QUIT   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
      *          QUIT PROGRAM
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *
     C     KEYFST        KLIST                                                   FA
     C                   KFLD                    FSTPRO
     C     KEYLST        KLIST
     C                   KFLD                    LSTPRO
     C     KEYBEF        KLIST
     C                   KFLD                    BEFPRO
      *
      *@$$$$$$$$ UPUP   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPUP          BEGSR
      *          ROLL UP
      *
     C                   EXSR      CLRSFL
     C                   MOVE      *ON           *IN98
     C     KEYFST        SETLL     WVPROF
    IC                   READP(N)  WVPROF                                 50
<--1 C     *IN50         IFEQ      *OFF
|    C                   MOVE      ACTKEY        BEFKEY
|    C                   SETON                                        96                    UPUP
->E1 C                   ELSE
J3248C                   MOVE      *ALLX'00'     BEFKEY
|    C                   SETOFF                                       96
|__1 C                   ENDIF
      *
     C     KEYFST        SETLL     WVPROF
<--1dC                   DO        12
|   IC                   READ(N)   WVPROF                                 50
<--2 C     *IN50         IFEQ      *ON
|    C                   SETOFF                                       98                    UPUP
|    C                   LEAVE
|__2 C                   ENDIF
|     *
|    C                   EXSR      SRDSP
|    C                   ADD       1             TRCD1
|    C                   Z-ADD     TRCD1         RCD1
|    C                   WRITE     SFL1
|     *
<--2 C     TRCD1         IFEQ      1
|    C                   MOVE      ACTKEY        FSTKEY                                     UPUP
|__2 C                   ENDIF
|     *
<--2 C     TRCD1         IFEQ      12
|    C                   MOVE      ACTKEY        LSTKEY
|__2 C                   ENDIF
|__1dC                   ENDDO
      *
<--1 C     *IN98         IFEQ      *ON
|   IC                   READ(N)   WVPROF                                 50
<--2 C     *IN50         IFEQ      *ON                                                      UPUP
|    C                   SETOFF                                       98
->E2 C                   ELSE
|    C                   MOVE      ACTKEY        AFTKEY
|    C                   SETON                                        98
|__2 C                   ENDIF
|__1 C                   ENDIF
      *
<--1 C     TRCD1         IFEQ      0
|    C     *HIVAL        SETGT     WVPROF
|   IC                   READP(N)  WVPROF                                 50                UPUP
<--2 C     *IN50         IFEQ      *ON
|    C                   SETOFF                                       96
->E2 C                   ELSE
|    C                   EXSR      SRDSP
|    C                   MOVE      ACTKEY        FSTKEY
|    C                   Z-ADD     1             TRCD1
|    C                   Z-ADD     TRCD1         RCD1
|    C                   WRITE     SFL1
|   IC                   READP(N)  WVPROF                                 50
<--3 C     *IN50         IFEQ      *ON                                                      UPUP
|    C                   SETOFF                                       96
->E3 C                   ELSE
|    C                   MOVE      ACTKEY        BEFKEY
|__3 C                   ENDIF
|__2 C                   ENDIF
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ UPDOWN $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPDOWN        BEGSR
      *          Roll down
      *
     C                   EXSR      CLRSFL
     C                   MOVE      BEFKEY        LSTKEY
     C                   MOVE      FSTKEY        AFTKEY
     C                   SETON                                        98
     C                   Z-ADD     13            TRCD1
      *
     C     KEYBEF        SETGT     WVPROF                                                   UPDOWN
<--1dC                   DO        12
|   IC                   READP(N)  WVPROF                                 50
<--2 C     *IN50         IFEQ      *ON
|    C                   MOVE      ACTKEY        FSTKEY
|    C                   EXSR      UPUP
|    C                   SETOFF                                       96
|   GC                   GOTO      ENDDWN
|__2 C                   ENDIF
|     *
|    C                   EXSR      SRDSP                                                    UPDOWN
|    C                   SUB       1             TRCD1
|    C                   Z-ADD     TRCD1         RCD1
|    C                   WRITE     SFL1
|     *
<--2 C     TRCD1         IFEQ      1
|    C                   MOVE      ACTKEY        FSTKEY
|__2 C                   ENDIF
|__1dC                   ENDDO
      *
    IC                   READP(N)  WVPROF                                 50                UPDOWN
<--1 C     *IN50         IFEQ      *ON
|    C                   SETOFF                                       96
->E1 C                   ELSE
|    C                   MOVE      ACTKEY        BEFKEY
|__1 C                   ENDIF
     C     ENDDWN        ENDSR
      *
      *@$$$$$$$$ SRDSP  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRDSP         BEGSR
      *          FORMAT RECORD FOR DISPLAY
/          Chain(n) (FAPRO) WVOTXP;
/          s1Key = FAPro;
/
/          If ( %found = TRUE );
/            s1Type = TYPE_CAPTARIS;
/            S1Proc = %trim(FOMDLID) + '|' + %trim(FOFLDID);
/          Else;
/            s1Type = *blanks;
/            S1Proc = FAPRO;
/          EndIf;
      *
     C                   ENDSR
      *
      *@$$$$$$$$ SRCURS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRCURS        BEGSR
      *          GET CURSOR POSITION
      *
     C     CSRLOC        DIV       256           CSRLIN            3 0          CURS-LINE
     C                   MVR                     CSRPOS            3 0          CURS-POS  E
     C     WINLOC        DIV       256           WINLIN            3 0          CURS-LINE
     C                   MVR                     WINPOS            3 0          CURS-POS
     C                   ENDSR
      *
      *@$$$$$$$$ CLRMSG $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRMSG        BEGSR
      *          Remove msg
     C                   CALL      'QMHRMVPM'
     C                   PARM                    PGMQ
     C                   PARM                    STKCNT
     C                   PARM                    MSGKY
     C                   PARM                    MSGRMV
     C                   PARM                    ERRCOD
     C                   ENDSR
      *                                                                UPUP
      *@$$$$$$$$ *INZSR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
      *
     C                   MOVE      *ON           *IN75
     C                   MOVE      *BLANKS       MSGKY             4
     C                   MOVEL     '*ALL'        MSGRMV           10
     C                   Z-ADD     1             SFLRC1
     C                   MOVEL     '*PUBLIC'     PUBLIC           10
      *
     C     KEYAUT        KLIST
     C                   KFLD                    AUTTYP                                     *INZSR
     C                   KFLD                    FAPRO
     C     KEYPUB        KLIST
     C                   KFLD                    AUTTYP
     C                   KFLD                    FEOBJ
     C                   KFLD                    FETRA
     C                   KFLD                    PUBLIC
     C                   ENDSR
      *
      *@$$$$$$$$ CLRSFL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRSFL        BEGSR
     C                   MOVEA     '11'          *IN(70)
     C                   WRITE     SFC1
     C                   MOVEA     '00'          *IN(70)
     C                   CLEAR                   RCD1
     C                   CLEAR                   TRCD1
     C                   CLEAR                   OPTION
     C                   MOVE      *OFF          *IN11
     C                   MOVE      *OFF          *IN03
     C                   CLEAR                   CHANGE                                     CLRSFL
     C                   CLEAR                   SETPRO
     C                   ENDSR
      *
      *@$$$$$$$$ ERRSFL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ERRSFL        BEGSR
      *          ERROR IN SUBFILE
    IC     RCD1          CHAIN     SFL1                               50
     C                   MOVE      *ON           *IN11
     C                   MOVE      OPT#          OPTION
     C                   UPDATE    SFL1
     C                   ENDSR
      *
      *@$$$$$$$$ SRO03  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO03         BEGSR
      *          3=Copy
      *
     C                   OPEN      WVSECP                                       AUTHORITY
     C                   CLEAR                   FETRA
     C                   MOVEL     FAPRO         FEOBJ
     C                   MOVEL(P)  '*PROCESS'    AUTTYP                         GET PUBLIC
    IC     KEYPUB        CHAIN(N)  WVSECF                             50        AUTHORITY
<--1 C     *IN50         IFEQ      *ON
|    C     FEAUT         OREQ      '*USRDFN'                                                SRO03
|    C                   MOVEL(P)  '*ALL'        AUT
->E1 C                   ELSE
|    C                   MOVEL     FEAUT         AUT
|__1 C                   ENDIF
      *
     C                   CLEAR                   COPPRO
      *>>>>>>>>>>INO03
     C     INO03         TAG
      *
<--1 C     *INKD         IFEQ      *OFF                                                     SRO03
|    C                   CLEAR                   WINLIN
|    C                   CLEAR                   WINPOS
|__1 C                   ENDIF
      *                 |-------------|
     C                   EXFMT     FMT03
      *                 |-------------|
<--1 C     *IN01         IFEQ      *ON
|   GC     *INKC         CABEQ     *ON           ENDO03
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'FMT03'       HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      FMT03                                  99
/1452C                   MOVE      #IN99         *IN99
|   GC                   GOTO      INO03
|__2 C                   END
|   GC     *INKL         CABEQ     *ON           ENDO03
<--2 C     *INKV         CASEQ     *ON           SRF21                           F21
|    C     *INKD         CASEQ     *ON           SRF4                            F4
|__2 C                   ENDCS
|   GC                   GOTO      INO03
|__1 C                   ENDIF
      *                                                                SRO03
    GC     COPPRO        CABEQ     *BLANKS       INO03                    61
     C     COPPRO        SETLL     WVPROF                                 60
    GC     *IN60         CABEQ     *ON           INO03                    60
      *  CHECK AUTHORITY
<--1 C     AUT           IFNE      '*NONE'
|    C                   MOVEL     '*ACTAUT'     CNAME
|    C                   MOVEL     'RC'          CTYPE
|    C                   MOVEL     AUT           CKEY
|    C                   OPEN      SPYCTL
|   IC     KEYCTL        CHAIN     SPYCTL                             50                    SRO03
|    C                   CLOSE     SPYCTL
|   GC     *IN50         CABEQ     *ON           INO03                    62
|__1 C                   ENDIF
      *
    IC     FAPRO         CHAIN(N)  WVPROF                             50
      *
     C                   MOVEL(P)  '*PROCESS'    AUTTYP           10            PROCESS
     C     KEYAUT        SETLL     WVSECF
<--1dC                   DO        *HIVAL
|   IC     KEYAUT        READE(N)  WVSECF                                 50                SRO03
|    C   50              LEAVE
|    C                   MOVE      COPPRO        FEOBJ
|    C                   MOVE      AUTTYP        FETYP
|    C                   WRITE     WVSECF                               50
|__1dC                   ENDDO
      *
     C                   MOVEL     TRNACT        AUTTYP           10            TRANSACT
     C     KEYAUT        SETLL     WVSECF
      *
<--1dC                   DO        *HIVAL                                                   SRO03
|   IC     KEYAUT        READE(N)  WVSECF                                 50
|    C   50              LEAVE
|    C                   MOVE      COPPRO        FEOBJ
|    C                   MOVE      AUTTYP        FETYP
|    C                   WRITE     WVSECF                               50
|__1dC                   ENDDO
      *
      * GRANT PUBLIC AUTHORITY
<--1 C     AUT           IFNE      '*NONE'
|    C                   CLEAR                   FETRA                                      SRO03
|    C                   MOVEL     FAPRO         FEOBJ
|    C                   MOVEL(P)  '*PROCESS'    AUTTYP                         GET PUBLIC
|   IC     KEYPUB        CHAIN     WVSECF                             50        AUTHORITY
|    C                   MOVEL     AUT           FEAUT
|    C     30            SUBST     CTEXT:81      FEOPT
<--2 C     *IN50         IFEQ      *ON
|    C                   MOVE      COPPRO        FEOBJ
|    C                   MOVE      AUTTYP        FETYP
|    C                   MOVEL     PUBLIC        FEUSR
|    C                   MOVE      'U'           FEUTP                          USER        SRO03
|    C                   WRITE     WVSECF
->E2 C                   ELSE
|    C                   UPDATE    WVSECF
|__2 C                   ENDIF
|__1 C                   ENDIF
      *
     C                   OPEN      WVTRAP
     C     FAPRO         SETLL     WVTRAF
<--1dC                   DO        *HIVAL
|   IC     FAPRO         READE(N)  WVTRAF                                 50                SRO03
|    C   50              LEAVE
|    C                   MOVE      COPPRO        FCPRO
|    C                   WRITE     WVTRAF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVTRAP
      *
     C                   OPEN      WVTADP
     C     FAPRO         SETLL     WVTADF
<--1dC                   DO        *HIVAL
|   IC     FAPRO         READE(N)  WVTADF                                 50                SRO03
|    C   50              LEAVE
|    C                   MOVE      COPPRO        FFPRO
|    C                   WRITE     WVTADF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVTADP
      *
     C                   OPEN      WVSPYP
     C     FAPRO         SETLL     WVSPYF
<--1dC                   DO        *HIVAL
|   IC     FAPRO         READE(N)  WVSPYF                                 50                SRO03
|    C   50              LEAVE
|    C                   MOVE      COPPRO        FLPRO
|    C                   WRITE     WVSPYF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVSPYP
      *
     C                   OPEN      WVLDDP
     C     FAPRO         SETLL     WVLDDF
<--1dC                   DO        *HIVAL
|   IC     FAPRO         READE(N)  WVLDDF                                 50                SRO03
|    C   50              LEAVE
|    C                   MOVE      COPPRO        FMPRO
|    C                   WRITE     WVLDDF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVLDDP
      *
     C                   MOVE      COPPRO        FAPRO
     C                   WRITE     WVPROF                               60
    GC   60              GOTO      INO03
      *                                                                SRO03
     C                   MOVE      *ON           CHANGE            1
      *>>>>>>>>>>ENDO03
     C     ENDO03        TAG
     C                   CLOSE     WVSECP
     C                   ENDSR
      /free
J3248  //------------------------------------------------------------------------
/        BegSr SrO03Cap;
/      //------------------------------------------------------------------------
/      //  Copy Captaris Process                                                -
/      //------------------------------------------------------------------------
/          Open(e) WVSECP;
/          Clear FETRA;
/          FEObj = FAPRO;
/          AutTyp = AUTTYP_PROCESS;
/          Chain(n) KeyPub WVSecF;
/
/          If ( ( NOT %found ) or ( FEAut = AUT_USRDFN )  );
/            Aut = AUT_ALL;
/          Else;
/            Aut = FEAUT;
/          EndIf;
/
/          Chain(n) s1Key WVOtxp;

           If ( %found = TRUE );
/            Monitor;
/            S3MdlID = %int(%trim(FOMDLID));
/            on-error *all;
/              S3MdlID = *zeros;
/            EndMon;
/
/            Monitor;
/            S3FldID = %int(%trim(FOFLDID));
/            on-error *all;
/              S3FldID = *zeros;
/            EndMon;
/          Else;
             LeaveSr;
/          EndIf;

/          s3Desc   = FADesc;

/          S3MDLIDN      = *ZEROS;
/          S3FLDIDN      = *ZEROS;
/          blnDefExist   = FALSE;
           blnDefInvalid = FALSE;

/          DoU ( ( blnDefExist = FALSE   ) and
/                ( blnDefInvalid = FALSE )     );
/            If ( key <>F4 );
/              Clear WinLin;
/              Clear WinPos;
/            EndIf;
/
/            ExFmt Fmt03Cap;
/
/            // Process Function Keys;
/
/            If *in01 = *on;
/              Select;
/                When ( key = F3 );
/                  LeaveSr;
/                When ( key = HELP );
/                  SpyHlp('MAG8001F':'FMT03CAP');
/                  #in99 = *in99;
/                  Read Fmt03Cap;
/                  *in99 = #in99;
/                  Iter;
/                When ( key = F12 );
/                  LeaveSr;
/                When ( key = F21 );
/                  ExSr SrF21;
/                When ( key = ENTER );
/                  Leave;
/                EndSl;
/                Iter;
/              EndIf;    // Process Function Keys;
/
/              hashkey.ModelId   = s3mdlidn;
/              hashkey.FolderID  = s3fldidn;
/              Coppro = hashkey;
/
/              If ( ( S3MdlIDN = *ZEROS ) and
/                   ( S3FldIDN = *ZEROS )     );
                 blnDefInvalid = TRUE;
                 Iter;
/              Else;
                 blnDefInvalid = FALSE;
/              EndIf;
/
/              Setll (Coppro) WVPROF;
/
/            // Check for existing process;
/
/              If ( %Equal = TRUE );
/                *IN60 = TRUE;
/                blnDefExist = TRUE;
/                Iter;
               Else;
                 blnDefExist = FALSE;
/              EndIf;
/
/          // Check Authority
/
/            If ( Aut <> AUT_NONE );
/              CName  = AUT_ACT;
/              Ctype  = 'RC';
/              Ckey   = AUT;
/              Open SPYCTL;
/              Chain  KeyCtl SPYCTL;
/              Close SPYCTL;
/
/              If ( NOT %found );
/                blnError = TRUE;
/                Iter;   // Not Authorized to copy
/              EndIf;
/
/            EndIf;
/
/          EndDo;
/
/          // Copy process authority
/
J6517      Chain(n) (s1key) WVPROF;
/          AUTTyp = AUTTYP_PROCESS;
/          Setll KeyAut WVSecf;
/
/          DoW TRUE;
/            Reade(n) KeyAut WVSecF;
/
/            If %eof;
/              Leave;
/            EndIf;
/
/            FeObj = CopPro;
/            FeTyp = AutTyp;
/            Write WVSecF;
/          EndDo;
/
/          // Copy the transaction authority
/
/          AutTyp = TrnAct;
/
/          Setll KEYAuT WVSecF;
/
/          Dow TRUE;
/            Reade(n) KeyAut WVSecF;
/
/            If %eof;
/              Leave;
/            EndIf;
/
/            FeObj = CopPro;
/            FeTyp = AutTyp;
/            Write WVSecF;
/          EndDo;
/
/        // Grant Public Authority
/
/         If ( Aut <> AUT_NONE );
/           Clear FETRA;
/           FEObj = FAPro;
/           AutTyp = AUTTYP_PROCESS;
/           Chain KeyPub WVSecF;
/           FEAut = Aut;
/           FEOpt = %SubSt(CText:81:30);

/           If NOT %Found;
/             FEObj = CopPro;
/             FETyp = AutTyp;
/             FEUTp = USRTYP_USER;
/             Write WVSecf;
/           Else;
/             Update WVSecf;
/           EndIf;
/
/         EndIf;
/
/         // Copy the Tranaction records

/         Open WVTrap;
/         Setll (FAPro) WVTrap;
/
/         DoW TRUE;
/           Reade(n) (FAPro) WVTraf;
/           If %EOF;
/             Leave;
/           EndIf;
/           FCPro = CopPro;
/           Write WVTraf;
/         EndDo;
/
/         Close(e) WVTrap;
/
/         // Copy the Tranaction Description records

/         Open WVTadp;
/         Setll (FAPro) WVTadf;
/         DoW TRUE;
/           Reade(n) (FAPro) WVTadf;
/
/           If ( %EOF = TRUE );
/             leave;
/           EndIf;
/
/           FFPro = CopPro;
/           Write WVTadf;
/
/         EndDo;
/
/         Close(e) WVTADP;
/
/         // Copy the Spylink distribution records

/         Open(e) WVSpyP;
/         Setll (FAPro) WVSpyF;
/
/         DoW TRUE;
/           Reade(n) FAPro WVSpyF;
/
/           If ( %eof = TRUE );
/             Leave;
/           EndIf;
/
/           Write WVSpyF;
/
/         EndDo;
/
/         Close(e) WVSpyP;
/
/         // Copy the Spylink distribution definition records
/
/         Open(e) WVLDDp;
/         Setll (FAPro) WVLDDF;
/
/         DoW TRUE;
/           Reade(n) (FAPro) WVLDDF;
/
/           If ( %eof = TRUE );
/             Leave;
/           EndIf;
/
/           FMPro = CopPro;
/           Write WVLDDf;
/         EndDo;
/
/         Close(e) WVLDDp;
/
/         // Copy the Captaris alternative key records

/         Setll (FAPro) WVOTXF;
/
/         DoW TRUE;
/           Reade(n) (FAPro) WVOTXF;
/
/           If ( %eof = TRUE );
/             Leave;
/           EndIf;
/
/           FOPro = CopPro;
/           FOMdlID  = %char(s3mdlidn);
/           FOFldID  = %char(s3fldidn);
/           Write WVOtxf;
/         EndDo;
/
          // Rename the header record

/         FAPro = CopPro;
          FaDesc = S3DescN;
/         Write(e) WVProf;
/         Change = *on;
/         Close WVSecP;
/       EndSr;
/
/     /end-free
      *@$$$$$$$$ SRO10  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO10         BEGSR
      *          10=SpyLinks
      *
J3248C     s1Key         CHAIN(N)  WVPROF                             50
<--1 C     *IN50         IFEQ      *OFF
|    C                   CALL      'MAG8004'                            50
J3248C                   PARM                    s1Key
|    C                   PARM      *BLANKS       SETRTY           10
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ SRO08  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO08         BEGSR
      *          8=Chg description
      *
J3248C     s1Key         CHAIN(N)  WVPROF                             50
      /free
                         s8ProcName = GetProcName( s1Key );
      /end-free
      *
      *>>>>>>>>>>INO08
     C     INO08         TAG
      *                 |-------------|
     C                   EXFMT     FMT08
      *                 |-------------|                                SRO08
<--1 C     *IN01         IFEQ      *ON
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'FMT08'       HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      FMT08                                  99
/1452C                   MOVE      #IN99         *IN99
|   GC                   GOTO      INO08
|__2 C                   END
|   GC     *INKC         CABEQ     *ON           ENDO08
|   GC     *INKL         CABEQ     *ON           ENDO08
<--2 C     *INKV         CASEQ     *ON           SRF21                           F21
|__2 C                   ENDCS                                                              SRO08
|   GC                   GOTO      INO08
|__1 C                   ENDIF
      *
    IC     FAPRO         CHAIN     WVPROF                             50
    IC                   READ      FMT08                                  50
     C                   UPDATE    WVPROF
     C                   MOVE      *ON           CHANGE
     C     ENDO08        ENDSR
      *
      *@$$$$$$$$ SRO07  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO07         BEGSR
      *          7=Rename
      *
     C                   MOVE      FAPRO         NEWPRO
      *>>>>>>>>>>INO07
     C     INO07         TAG
      *                 |-------------|
     C                   EXFMT     FMT07
      *                 |-------------|
<--1 C     *IN01         IFEQ      *ON                                                      SRO07
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'FMT07'       HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      FMT07                                  99
/1452C                   MOVE      #IN99         *IN99
|   GC                   GOTO      INO07
|__2 C                   END
|   GC     *INKC         CABEQ     *ON           ENDO07
|   GC     *INKL         CABEQ     *ON           ENDO07
<--2 C     *INKV         CASEQ     *ON           SRF21                           F21
|__2 C                   ENDCS
|   GC                   GOTO      INO07                                                    SRO07
|__1 C                   ENDIF
      *
    GC     NEWPRO        CABEQ     *BLANKS       INO07                    61
      *
     C     NEWPRO        SETLL     WVPROF                                 60
    GC     *IN60         CABEQ     *ON           INO07                    60
      *
    IC     FAPRO         CHAIN     WVPROF                             50
      *
     C                   OPEN      WVSECP                                        AUTHORITY  SRO07
     C                   MOVEL(P)  '*PROCESS'    AUTTYP           10             PROCESS
     C     KEYAUT        SETLL     WVSECF
<--1dC                   DO        *HIVAL
|   IC     KEYAUT        READE     WVSECF                                 50
|    C   50              LEAVE
|    C                   MOVE      NEWPRO        FEOBJ
|    C                   UPDATE    WVSECF                               50
|__1dC                   ENDDO
      *
     C                   MOVEL     TRNACT        AUTTYP           10            TRANSACTIO  SRO07
     C     KEYAUT        SETLL     WVSECF
<--1dC                   DO        *HIVAL
|   IC     KEYAUT        READE     WVSECF                                 50
|    C   50              LEAVE
|    C                   MOVE      NEWPRO        FEOBJ
|    C                   UPDATE    WVSECF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVSECP
      *
     C                   OPEN      WVTRAP                                                   SRO07
     C     FAPRO         SETLL     WVTRAF
<--1dC                   DO        *HIVAL
|   IC     FAPRO         READE     WVTRAF                                 50
|    C   50              LEAVE
|    C                   MOVE      NEWPRO        FCPRO
|    C                   UPDATE    WVTRAF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVTRAP
      *
     C                   OPEN      WVTADP                                                   SRO07
     C     FAPRO         SETLL     WVTADF
<--1dC                   DO        *HIVAL
|   IC     FAPRO         READE     WVTADF                                 50
|    C   50              LEAVE
|    C                   MOVE      NEWPRO        FFPRO
|    C                   UPDATE    WVTADF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVTADP
      *
     C                   OPEN      WVSPYP                                                   SRO07
     C     FAPRO         SETLL     WVSPYF
<--1dC                   DO        *HIVAL
|   IC     FAPRO         READE     WVSPYF                                 50
|    C   50              LEAVE
|    C                   MOVE      NEWPRO        FLPRO
|    C                   UPDATE    WVSPYF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVSPYP
      *
     C                   OPEN      WVLDDP                                                   SRO07
     C     FAPRO         SETLL     WVLDDF
<--1dC                   DO        *HIVAL
|   IC     FAPRO         READE     WVLDDF                                 50
|    C   50              LEAVE
|    C                   MOVE      NEWPRO        FMPRO
|    C                   UPDATE    WVLDDF                               50
|__1dC                   ENDDO
     C                   CLOSE     WVLDDP
      *
     C                   MOVE      NEWPRO        FAPRO                                      SRO07
     C                   UPDATE    WVPROF                               60
    GC   60              GOTO      INO07
      *
     C                   MOVE      *ON           CHANGE
     C     ENDO07        ENDSR
      *
      *--------------------------------------------------------------------------
J3248 /Free
/      //-----------------------------------------------------------------------
/      BegSr Sro07Cap;
/      //-----------------------------------------------------------------------
/      //  Rename an current captaris process to a new process.                -
/      //-----------------------------------------------------------------------
/          Open(e) WVSECP;
/          Clear FETRA;
/          FEObj = FAPRO;
/          AutTyp = AUTTYP_PROCESS;
/          Chain(n) KeyPub WVSecF;
/
/          If ( ( NOT %found ) or ( FEAut = AUT_USRDFN )  );
/            Aut = AUT_ALL;
/          Else;
/            Aut = FEAUT;
/          EndIf;
/
/          Chain(n) s1Key WVOtxp;
/
/          If ( %found = TRUE );
/            Monitor;
/            S7MdlID = %int(%trim(FOMDLID));
/            on-error *all;
/            S7MdlID = *zeros;
/            EndMon;
/
/            Monitor;
/            S7FldID = %int(%trim(FOFLDID));
/            on-error *all;
/              S7FldID = *zeros;
/            EndMon;
/          Else;
/            LeaveSr;
/          EndIf;
/
/          S7DESC        = FADesc;
/          S7MDLIDN      = *ZEROS;
/          S7FLDIDN      = *ZEROS;
/          blnDefExist   = FALSE;
/          blnDefInvalid = FALSE;
/
/          DoU ( ( blnDefExist = FALSE   ) and
/                ( blnDefInvalid = FALSE )     );
/            If ( key <> F4 );
/              Clear WinLin;
/              Clear WinPos;
/            EndIf;
/
/            ExFmt Fmt07Cap;
/
/            // Process Function Keys;
/
/            If *in01 = *on;
/              Select;
/                When ( key = F3 );
/                  LeaveSr;
/                When ( key = HELP );
/                  SpyHlp('MAG8001F':'FMT07CAP');
/                  #in99 = *in99;
/                  Read Fmt07Cap;
/                  *in99 = #in99;
/                  Iter;
/                When ( key = F12 );
/                  LeaveSr;
/                When ( key = F21 );
/                  ExSr SrF21;
/                When ( key = ENTER );
/                  Leave;
/                EndSl;
/                Iter;
/              EndIf;    // Process Function Keys;
/
/              hashkey.ModelId   = s7mdlidn;
/              hashkey.FolderID  = s7fldidn;
/              Coppro = hashkey;
/
/              If ( ( S7MdlIDN = *ZEROS ) and
/                   ( S7FldIDN = *ZEROS )     );
/                blnDefInvalid = TRUE;
/                Iter;
/              Else;
/                blnDefInvalid = FALSE;
/              EndIf;
/
/              Setll (Coppro) WVPROF;
/
/            // Check for existing process;
/
/              If ( %Equal = TRUE );
/                *IN60 = TRUE;
/                blnDefExist= TRUE;
/                Iter;
/              Else;
/                blnDefExist = FALSE;
/              EndIf;
/
/          // Check Authority
/
/            If ( Aut <> AUT_NONE );
/              CName  = AUT_ACT;
/              Ctype  = 'RC';
/              Ckey   = AUT;
/              Open SPYCTL;
/              Chain  KeyCtl SPYCTL;
/              Close SPYCTL;
/
/              If ( NOT %found );
/                blnError = TRUE;
/                Iter;   // Not Authorized to copy
/              EndIf;
/
/            EndIf;
/
/          EndDo;
/
/          // Rename process authority
/
/          Chain (s1key) WVPROF;
/          AUTTyp = AUTTYP_PROCESS;
/          Setll KeyAut WVSecf;
/
/          If ( %Equal = TRUE );
/
/            DoW TRUE;
/              Reade KeyAut WVSecF;
/
/              If %eof;
/                Leave;
/              EndIf;
/
/              FeObj = CopPro;
/              FeTyp = AutTyp;
/              Update WVSecF;
/            EndDo;

/          EndIf;
/          // Rename the transaction authority
/
/          AutTyp = TrnAct;
/
/          Setll KEYAuT WVSecF;
/
/          Dow TRUE;
/            Reade KeyAut WVSecF;
/
/            If %eof;
/              Leave;
/            EndIf;
/
/            FeObj = CopPro;
/            FeTyp = AutTyp;
/            Update WVSecF;
/          EndDo;
/
/        // Grant Public Authority
/
/         If ( Aut <> AUT_NONE );
/           Clear FETRA;
/           FEObj = FAPro;
/           AutTyp = AUTTYP_PROCESS;
/           Chain KeyPub WVSecF;
/           FEAut = Aut;
/           FEOpt = %SubSt(CText:81:30);
/
/           If ( %Found = TRUE );
/             Update WVSecf;
/           EndIf;
/
/         EndIf;
/
/         // Rename the Tranaction records
/
/         Open WVTrap;
/         Setll (FAPro) WVTrap;
/
/         DoW TRUE;
/           Reade FAPro WVTraf;
/           If %EOF;
/             Leave;
/           EndIf;
/           FCPro = CopPro;
/           Update WVTraf;
/         EndDo;
/
/         Close(e) WVTrap;
/
/         // Rename the Tranaction Description records
/
/         Open WVTadp;
/         Setll (FAPro) WVTadf;
/         DoW TRUE;
/           Reade (FAPro) WVTadf;
/
/           If ( %EOF = TRUE );
/             leave;
/           EndIf;
/
/           FFPro = CopPro;
/           Update WVTadf;
/
/         EndDo;
/
/         Close(e) WVTADP;
/
/         // Rename the Spylink distribution records
/
/         Open(e) WVSpyP;
/         Setll (FAPro) WVSpyF;
/
/         DoW TRUE;
/           Reade FAPro WVSpyF;
/
/           If ( %eof = TRUE );
/             Leave;
/           EndIf;
/
//          FLPro = CopPro;
/           Update WVSpyF;
/
/         EndDo;
/
/         Close(e) WVSpyP;
/
/         // Rename the Spylink distribution definition records
/
/         Open(e) WVLDDp;
/         Setll (FAPro) WVLDDF;
/
/         DoW TRUE;
/           Reade (FAPro) WVLDDF;
/
/           If ( %eof = TRUE );
/             Leave;
/           EndIf;
/
/           FMPro = CopPro;
/           Update WVLDDf;
/         EndDo;
/
/         Close(e) WVLDDp;
/
/         // Rename the Captaris alternative key records
/
/         Setll (FAPro) WVOTXF;
/
/         DoW TRUE;
/           Reade (FAPro) WVOTXF;
/
/           If ( %eof = TRUE );
/             Leave;
/           EndIf;
/
/           FOPro = CopPro;
/           FOMdlID  = %char(s7mdlidn);
/           FOFldID  = %char(s7fldidn);
/           Update WVOtxf;
/         EndDo;
/
/         // Rename the header record
/
/         FAPro = CopPro;
/         FaDesc = S7DescN;
/         Update(e) WVProf;
/         Change = *on;
/         Close WVSecP;
/       EndSr;
/      //---------------------------------------------------------------
/       BegSr  SrF6;
/       //-------------------------------------------------------------
/       // First, determine the type of work flow process being added: Workflow
/       // WorkView or Staffview. Based on this entry, then display the appropreiate
/       // screen for the workflow process.
/       //-----------------------------------------------------------------
/
/                        // Determine the type of
/                        // the process to add
/                        s1Desc        = *blanks;
/                        blnDefExist   = FALSE;
/                        blnDefInvalid = FALSE;
/
/                        Dou   ( key = Enter ) or
/                              ( key = F3    ) or
/                              ( key = F12   );
/                          Exfmt FMTTYPF6;
/
/                          // Process Function Keys
/
/                          If *in01 = *on;
/                            Select;
/                              When ( key = HELP );
/                                SpyHlp('MAG8001F':'FMTYPF6');
/                              When ( key = F3 );
/                                leaveSr;
/                              When ( Key = F12 );
/                                leaveSr;
/                              When ( Key = F21 );
/                                ExSr SrF21;
/                              When ( Key = Enter );
/                                leave;
/                            EndSl;
/                            Iter;
/                          EndIf;
/
/                        EndDo;
/
/                        // Should a workflow process be
/                        // added, then display the correct format.
/
/                        If ( Choice = 1 );
/                          Clear s1MDLId;
/                          Clear s1FldId;
/
/                          blnDefExist = FALSE;
/                          blnDefInvalid = FALSE;
/
/                          DoU ( key = F3    )                   or
/                              ( key = F12   )                   or
/                              (  ( key = ENTER           ) and
/                                 ( blnDefExist = FALSE   ) and
/                                 ( blnDefInvalid = FALSE )         );
/                            Exfmt FMTWRKFLW;
/
/                            // Process Function Key
/
/                            If ( blnValidFunctionKey = TRUE );
/                              Select;
/                                When ( key = HELP );
/                                  SpyHlp('MAG8001F':'FMTWRKFLW');
/                                When ( ( key = F3  ) or
/                                       ( key = F12 )    );
/                                  leaveSr;
/                                When ( key = F21 );
/                                  ExSr Srf21;
/                              EndSl;
/                              Iter;
/                            EndIf;
/
/                           // Validate Entry
/
/                            If ( key = ENTER );
/
/                              If NOT %Open(SPYCTL);
/                                Open(e) SPYCTL;
/                              EndIf;
/                              Chain ('*ACTAUT':'RC':'*ALL') SPYCTL;
/                              Close(e) SPYCTL;
/
/                              If ( %found = FALSE );
/                                blnAutInvalid = TRUE;
/                                Iter;
/                              Else;
/                                blnAutInvalid = FALSE;
/                              EndIf;
/
/                              HashKey.ModelID  = s1mdlid;
/                              HashKey.FolderID = s1fldid;
/
/                              Chain(n) HashKey WVProp;
/
/                              If ( %found = TRUE );
/                                blnDefExist = TRUE;
/                                Iter;
/                              Else;
/                                blnDefExist = FALSE;
/                              EndIf;
/
/                            EndIf;
/                          EndDo;
/
/
/                     // Add key to the process header
/
/                          HashKey.ModelID  = s1mdlid;
/                          HashKey.FolderID = s1fldid;
/                          NewPro =  HashKey;
/                          NewDsc =  s1Desc;
/                          Fapro   = HashKey;
/                          FaDesc  = s1desc;
/                          Chain FaPro WVProp;
/
/                          If ( %found = FALSE );
/                            Write wvprof;
/                          EndIf;
/
/                     // Add key to the alias file
/
/                          FoPro   = HashKey;
/                          FoMdlID = %char(s1MdlId);
/                          FoFldID = %char(s1FldId);
/                          Chain FoPro WVOtxP;
/
/                          If ( %found = FALSE);
/                            Write WVotxf;
/                          EndIf;
/
/                     // Grant Public Authority
/
/                     // Add key to the security file
/
/                          Open(e) WVSecP;
/                          AutTyp = AUTTYP_PROCESS;
/                          FEObj  = HashKey;
/                          FETyp  = AutTyp;
/                          FEAut  = AUT_ALL;
/                          FEOpt  = %subSt(CText:81);
/                          FEUsr  = PUBLIC;
/                          FEUTP  = USRTYP_USER;
/                          Chain (FETyp:FEObj:FETra:FEUsr:FeUsr) WVSecP;
/
/                          If ( %found = TRUE );
/                            Update WVSecf;
/                          Else;
/                            Write WVSecf;
/                          EndIf;
/
/                          ExSr Sro02;
/                          Change = *on;
/                          Choice = 0;
                           Close(e) WVSECP;
/                        Else;
/     /end-free
      *          F6=Create new Process Definition
      *
     C                   CLEAR                   NEWPRO
     C                   CLEAR                   NEWDSC
     C                   MOVEL(P)  '*ALL'        AUT
      *>>>>>>>>>>INF6
     C     INF6          TAG
      *
<--1 C     *INKD         IFEQ      *OFF
|    C                   CLEAR                   WINLIN                                     SRF6
|    C                   CLEAR                   WINPOS
|__1 C                   ENDIF
      *                 |-------------|  Create new Process Definition
     C                   EXFMT     FMTF6
      *                 |-------------|  NEWPRO NEWDSC AUT
<--1 C     *IN01         IFEQ      *ON
<--2 C     KEY           IFEQ      HELP                                         Help
|    C                   MOVEL(P)  'FMTF6'       HLPFMT
|    C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      FMTF6                                  99
/1452C                   MOVE      #IN99         *IN99
|__2 C                   END
|   GC     *INKC         CABEQ     *ON           ENDF6
|   GC     *INKL         CABEQ     *ON           ENDF6
<--2 C     *INKV         CASEQ     *ON           SRF21                          F21
|    C     *INKD         CASEQ     *ON           SRF4                           F4
|__2 C                   ENDCS
|   GC                   GOTO      INF6
|__1 C                   ENDIF
      *
    GC     NEWPRO        CABEQ     *BLANKS       INF6                     61                SRF6
      *
     C     NEWPRO        SETLL     WVPROF                                 60
    GC     *IN60         CABEQ     *ON           INF6                     60
      *
     C                   MOVE      NEWPRO        FAPRO
     C                   MOVE      NEWDSC        FADESC
      *
      *   GRANT PUBLIC AUTHORITY
<--1 C     AUT           IFNE      '*NONE'
|    C                   CLEAR                   FETRA                                      SRF6
|    C                   MOVEL     '*ACTAUT'     CNAME
|    C                   MOVEL     'RC'          CTYPE
|    C                   MOVEL     AUT           CKEY
|    C     KEYCTL        KLIST
|    C                   KFLD                    CNAME
|    C                   KFLD                    CTYPE
|    C                   KFLD                    CKEY
|    C                   OPEN      SPYCTL
|   IC     KEYCTL        CHAIN     SPYCTL                             50
|    C                   CLOSE     SPYCTL                                                   SRF6
|   GC     *IN50         CABEQ     *ON           INF6                     62
|     *
|    C                   OPEN      WVSECP
|    C                   MOVEL(P)  '*PROCESS'    AUTTYP                         GET PUBLIC
|    C                   MOVE      NEWPRO        FEOBJ
|    C                   MOVE      AUTTYP        FETYP
|    C                   MOVE      AUT           FEAUT
|    C     30            SUBST     CTEXT:81      FEOPT
|    C                   MOVEL     PUBLIC        FEUSR
|    C                   MOVE      'U'           FEUTP                          USER        SRF6
|    C                   WRITE     WVSECF
|    C                   CLOSE     WVSECP
|__1 C                   ENDIF
      * WRITE RECORD
     C                   WRITE     WVPROF
     C                   EXSR      SRO02
     C                   WRITE     FKEYS
     C                   MOVE      *ON           CHANGE
J3248C                   EndIf
     C     ENDF6         ENDSR
      *                                                                UPUP
      *@$$$$$$$$ REDSFL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     REDSFL        BEGSR
      *          Read subfile
      *
      * CLEAR THE DELETE SUBFILE
<--1 C     TRCD2         IFNE      *ZEROS
|    C                   MOVEA     '11'          *IN(72)
|    C                   WRITE     SFC2
|    C                   MOVEA     '00'          *IN(72)
|    C                   CLEAR                   TRCD2
|    C                   CLEAR                   RCD2                                       REDSFL
|__1 C                   ENDIF
      *
<--1 C     TRCD1         IFGT      0
<--2dC                   DO        *HIVAL
|   IC                   READC     SFL1                                 5050
|    C   50              LEAVE
|     *
|    C                   Z-ADD     RCD1          SFLRC1                         POSITION
|    C                   MOVE      OPTION        OPT#              2 0
|    C                   CLEAR                   OPTION                                     REDSFL
|    C     OPT#          COMP      *ZERO                              1111       NE
|    C                   UPDATE    SFL1
|     *
<--3 C     OPT#          IFNE      *ZEROS
|    C                   Z-ADD     RCD1          SFLRC1
|__3 C                   ENDIF
|     *
|     * 2=CHANGE
|     * 3=COPY                                                         REDSFL
|     * 4=DELETE
|     * 7=RENAME
|     * 8=DESCRIPTION
|     * 9=PROCESSES
|     *10=SPYLINKS
|     *14=AUTHORITY

      /FREE
<--3s  SELECT;
| -3w  When OPT# = 2;
|        EXSR SRO02;
|        WRITE FKEYS;
| -3w  WHEN OPT# = 9;                                                         //            REDSFL
|        EXSR SRO09;
| -3w  WHEN OPT# = 3
       AND S1TYPE = *BLANKS;
J4439    fapro = s1proc;
|        EXSR SRO03;
| -3w  WHEN OPT# = 3
       AND S1TYPE = TYPE_CAPTARIS;
|        EXSR SRO03CAP;
J3248  WHEN ( ( OPT# = 14 )   and
/             ( S1TYPE <> TYPE_CAPTARIS ) );
|        EXSR SRO14;
| -3w  When ( ( Opt# = 7 )        and
J3248         ( s1Type = *blanks )    );
J4439    fapro = s1proc;
|        ExSr SRO07;
J3248  When ( ( Opt# = 7 )        and
/             ( s1Type = TYPE_CAPTARIS ) );
/        ExSr Sro07Cap;
| -3w  WHEN OPT# = 8;
|        EXSR SRO08;
| -3w  WHEN OPT# = 10;                                                        //            REDSFL
|        EXSR SRO10;
|      WHEN OPT# = 4;
      /END-FREE
|    C                   Z-ADD     4             OPTION
|    C                   ADD       1             TRCD2
|    C                   Z-ADD     TRCD2         RCD2
      /FREE
J3248    S2Proc = S1Proc;
J3248    S2Key  = S1Key;
|        WRITE SFL2;
|        // WRONG OPTION
| -3w  OTHER;
<--4     IF OPT# <> 0;
|   I      CHAIN RCD1 SFL1;                                                   //            REDSFL
           *IN50 = NOT %FOUND;
      /END-FREE
|    C                   MOVE      *ON           *IN60
|    C                   MOVE      *ON           *IN11
|    C                   MOVE      OPT#          OPTION
|    C  N50              UPDATE    SFL1
      /FREE
|__4     ENDIF;
|__3s  ENDSL;
      /END-FREE
|__2dC                   ENDDO
|__1 C                   END
      *---------------
      * CONFIRM DELETE                                                 REDSFL
      *---------------
<--1 C     TRCD2         IFNE      *ZEROS
|    C                   Z-ADD     1             SFLRC2
|    C                   WRITE     FKEYDLT
|     *                 |-------------|
|    C                   EXFMT     SFC2
|     *                 |-------------|
<--2 C     *IN01         IFEQ      *OFF
|    C                   OPEN      WVSECP
|    C                   OPEN      WVTRAP                                                   REDSFL
|    C                   OPEN      WVTADP
|    C                   OPEN      WVSPYP
|    C                   OPEN      WVLDDP
<--3dC                   DO        TRCD2         F40               4 0
|   IC     F40           CHAIN     SFL2                               50
<--4 C     *IN50         IFEQ      *OFF
J3248C                   Eval      FAPro = S2key
     C     FAPro         CHAIN     WVPROF                             51
<--5 C     *IN51         IFEQ      *OFF
|    C                   MOVEL(P)  '*PROCESS'    AUTTYP           10            PROCESS
<--6dC     *IN50         DOUEQ     *ON                                                      REDSFL
|    C     KEYAUT        DELETE    WVSECF                             50
|__6dC                   ENDDO
|    C                   MOVEL     TRNACT        AUTTYP           10            TRANSACTIO
<--6dC     *IN50         DOUEQ     *ON
|    C     KEYAUT        DELETE    WVSECF                             50
|__6dC                   ENDDO
<--6dC     *IN50         DOUEQ     *ON
|    C     FAPRO         DELETE    WVTRAF                             50
|__6dC                   ENDDO
<--6dC     *IN50         DOUEQ     *ON                                                      REDSFL
|    C     FAPRO         DELETE    WVTADF                             50
|__6dC                   ENDDO
<--6dC     *IN50         DOUEQ     *ON
|    C     FAPRO         DELETE    WVSPYF                             50
|__6dC                   ENDDO
<--6dC     *IN50         DOUEQ     *ON
|    C     FAPRO         DELETE    WVLDDF                             50
|__6dC                   ENDDO
J6517                    Dou NOT %found;
J6517                      Delete (FAPRO) WVOTXF;
J6517                    EndDo;
|__5 C                   ENDIF
|    C  N51              DELETE    WVPROF                                                   REDSFL
|__4 C                   ENDIF
|__3dC                   ENDDO

|    C                   CLOSE     WVSECP
|    C                   CLOSE     WVTRAP
|    C                   CLOSE     WVTADP
|    C                   CLOSE     WVSPYP
|    C                   CLOSE     WVLDDP
|    C                   MOVE      *ON           CHANGE
->E2 C                   ELSE
<--3dC                   DO        TRCD2         F40                                        REDSFL
|   IC     F40           CHAIN     SFL2                               50
|   IC     RCD1          CHAIN     SFL1                               50
|    C                   MOVE      *ON           *IN11
|    C                   Z-ADD     4             OPTION
|    C                   UPDATE    SFL1
|__3dC                   ENDDO
|__2 C                   ENDIF
|    C                   CLEAR                   OPTION
|__1 C                   ENDIF
      *                                                                REDSFL
     C                   WRITE     FKEYS
      *
<--1 C     CHANGE        IFEQ      *ON
|    C                   EXSR      UPUP
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ RUNCL  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    CMD             250
     C                   PARM      250           F155             15 5
     C                   ENDSR
      *
      *@$$$$$$$$ SRO02  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO02         BEGSR
      *          2=Change
      *
      *           This condition tests for either a change to an
      *           existing process, or an add to a new process that
      *           is not a captaris workflow process.
      *
J6516  fapro = convertCapProc(s1proc);
    IC     FAPRO         CHAIN(N)  WVPROF                             50
<--1 C     *IN50         IFEQ      *OFF
|     *
|    C                   CALL      'MAG8012'                            50
|    C                   PARM      FAPRO         PRO              10
|__1 C                   ENDIF

      *>>>>>>>>>>ENDA2                                                 SRO02
     C     ENDA2         TAG
     C                   EXSR      CLRMSG
     C                   ENDSR
      *
      *@$$$$$$$$ SRF21  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF21         BEGSR
      *          F21=Cmd line
      *
     C                   CALL      'MSYSCMDC'                           50
     C                   ENDSR
      *
      *@$$$$$$$$ SRO14  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO14         BEGSR
      *          14=Authority
      *
     C                   CALL      'MAG8013'                            50
     C                   PARM      FAPRO         OBJECT           10
     C                   PARM      '*PROCESS'    OBJTYP           10
     C                   PARM      0             OBJTRA            3 0
     C                   ENDSR
      *
      *@$$$$$$$$ SRF4   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF4          BEGSR
      *
     C                   CLEAR                   CTLTYP
     C                   EXSR      SRCURS
      *
<--1sC                   SELECT
| -1wC     FLD           WHENEQ    'AUT'
|    C                   MOVEL(P)  '*ACTAUT'     CTLNAM
|    C                   CALL      'SPYCTL'                             50
|    C                   PARM                    CTLNAM           10                        SRF4
|    C                   PARM                    CTLTYP            2
|    C                   PARM                    CTLKEY           10
<--2 C     CTLKEY        IFNE      *BLANKS
|    C                   MOVEL     CTLKEY        AUT
|__2 C                   ENDIF
|__1sC                   ENDSL
     C                   ENDSR
      *
      *@$$$$$$$$ SRO09  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRO09         BEGSR
      *          9=Processes
     C                   CALL      'MAG8002'                            50
     C                   PARM      FAPRO         PRMPRO           10
     C                   PARM      *BLANKS       PRMPRJ           10
     C                   ENDSR

       // --------------------------------------------------
       // Procedure name: paginate
       // Purpose:        Page up/down and load the subfile.
       // Returns:        Returns 0 (zero) if successful or -1 if NRF, BOF or...
       //                           EOF
       // Parameter:      direction => Page up (>=) or down (<=)
       // --------------------------------------------------
       DCL-PROC paginate ;
         DCL-PI *N INT(3);
           direction CHAR(2) CONST; // UP, DN
         END-PI ;
         dcl-s cursorOpen ind inz(*off) static;

         DCL-S retField INT(3);

         if not cursorOpen or fstpro <> ' ';
           exec sql close c1;
         endif;

         *in98 = *on;
         for i = 1 to 12;
           if fetch(direction) = 0;
             *in50 = *off;
             *in96 = *on;
             exsr srdsp;
             trcd1 += 1;
             rcd1 = trcd1;
             write sfl1;
             select;
               when trcd1 = 1;
                 fstkey = actkey;
               when trcd1 = 12;
                 lstkey = actkey;
             endsl;
           else;
             *in50 = *on;
             *in96 = *off;
             *in98 = *off;
             leave;
           endif;
         endfor;
         // Your calculation code goes here

         return retField ;
       END-PROC ;


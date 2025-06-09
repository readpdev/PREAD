      *%METADATA                                                       *
      * %TEXT Change SpyView Help                                      *
      *%EMETADATA                                                      *
      *********-----------------
      * CHGHLP  Change Help Text
      *********-----------------
      *
      *          Fiddy Brugge   Nov 1995
      *
      *  INDICATORS
      *  ==========
      *  01 = VLDCMDKEY
      *  12 = DSPSIZE       On=132 col    Off=80 col
      *  13 = USERHELP      On=UserHelp   Off=Magellan (from WRKHLP)
      *  21 = CMD LINE      On=Allower
      *  50 = ERROR
      *  70 = SFLDSPCTL
      *  71 = SFLDSP
      *
     FCHGHLPFM  CF   E             WORKSTN INFDS(DSDSP)
     F                                     SFILE(SFL1:RRN1)
     FHMAGHLP   UF A E           K DISK    USROPN
     FHUSRHLP   UF A E           K DISK    USROPN
      *
     D SYSDFT          DS          1024
     D  LMENU                121    121
     D  LCKF21               223    223
     D PGMSDS         SDS           528
      *              Pgm status                             RPG pg 43
     D  QPGM             *PROC
     D  WQPGMN                 1     10
     D  QERNR                 40     46
     D  WQLIBN                81     90
     D  QERMSG                91    170
     D  QERFIL               201    210
     D  WQUSRN               254    263
     D                 DS                  INZ
     D  HMTXT                  1     65
     D  TX                     1     65
     D                                     DIM(65)
     D                 DS                  INZ
     D  STKCNT                 1      4B 0
     D  DTALEN                 5      8B 0
     D  ERRCOD                 9     12B 0
     D DSDSP           DS
     D  CSRLOC               370    371B 0
     D  SFLZ                 378    379B 0
     D  WINLOC               382    383B 0
      *
     I*@  IND INPT CALC  OUT    IND INPT CALC  OUT    IND INPT CALC  OUT
     I*@   KC        M           LR        MO          64        M X
     I*@   KD        M           01        M           65        M X
     I*@   KE        M           50        M           70        MOX
     I*@   KF      L M           60        M X         71        MOX
     I*@   KH        M           61        M X         75        MO
     I*@   KI        M           62        M X         81        M
     I*@   KJ        M           63        M X         99        M
     I*@  *MAIN*       SRF5   CLRMSG UPCURS EXIT   SRF4   SRF5   SRF6
     I*@               SRF8   SRF9   SRF10  SRF21  NXTPAG
     I*@  EXIT         SRSAVE QUIT
     I*@  *INZSR       QUIT
     I*@  SRF8         UPCURS
     I*@  SRF9         UPCURS
     I*@  SRF10        UPCURS
     I*@  SRF4         UPCURS
     I*@  SRF6         UPCURS WRTSFL
     I*@  SRF5         CLRSFL GETTXT WRTSFL
     I*@  GETTXT       WRTSFL
     I*@  NXTPAG       WRTSFL
     I*@  QUIT         RUNCL
     I*@ SPYREAL/QRPGSRC/CHGHLP           11/27/96 at 21:03:43 by FIDDY
     I*@
     IUSRHLPF
     I              HUFIL                       HMFIL
     I              HURCD                       HMRCD
     I              HUSEQ                       HMSEQ
     I              HUTXT                       HMTXT
     I              HUPRV                       HMPRV
     I              HUUSR                       HMUSR
     I              HUDAT                       HMDAT
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRMFIL           10
     C                   PARM                    PRMRCD           10
     C                   PARM                    PRMUSR           10
     C                   PARM                    PRMRTN            1
      *
     C     *DTAARA       DEFINE                  SYSDFT
     C                   IN        SYSDFT
      *
     C     PRMUSR        COMP      *BLANKS                            1313
    GC     LCKF21        CABNE     'S'                                2121
    GC     LMENU         CABNE     'Y'                                2525
      *
     C     *LIKE         DEFINE    RRN1          #RECS1
     C                   WRITE     WINDOW2
     C                   SETOFF                                       96
     C                   EXSR      SRF5
      *>>>>>>>>>>SHOWS1
     C     SHOWS1        TAG
      *
<--1 C     #RECS1        IFEQ      *ZEROS
|    C                   MOVE      *ON           *IN71
->E1 C                   ELSE
|    C                   MOVE      *OFF          *IN71
|__1 C                   END
      *
<--1 C     SFLRC1        IFGT      #RECS1
|    C                   Z-ADD     #RECS1        SFLRC1
|__1 C                   END
<--1 C     SFLRC1        IFEQ      0
|    C                   Z-ADD     1             SFLRC1
|__1 C                   END
      *
     C                   MOVE      *OFF          *IN70
      *                 |-------------|
     C                   EXFMT     SFC1
      *                 |-------------|
     C                   MOVEA     '000000'      *IN(60)
     C                   Z-ADD     SFLZ          SFLRC1
     C                   EXSR      UPCURS
      *-------
      * F-Keys
      *-------
<--1 C     *IN01         IFEQ      *ON
<--2 C     *INKC         CASEQ     *ON           EXIT
|    C     *INKL         CASEQ     *ON           EXIT
|    C     *INKD         CASEQ     *ON           SRF4
|    C     *INKE         CASEQ     *ON           SRF5
|    C     *INKF         CASEQ     *ON           SRF6
|    C     *INKH         CASEQ     *ON           SRF8
|    C     *INKI         CASEQ     *ON           SRF9
|    C     *INKJ         CASEQ     *ON           SRF10
|    C     *INKV         CASEQ     *ON           SRF21
|    C     *IN99         CASEQ     *ON           NXTPAG
|__2 C                   ENDCS
|__1 C                   ENDIF
      *
    GC                   GOTO      SHOWS1
      *                                                                MainLine
      *@$$$$$$$$ EXIT   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     EXIT          BEGSR
      *
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   MOVE      'Y'           YESNO
      *>>>>>>>>>>INEXIT
     C     INEXIT        TAG
      *                 |--------------|  Save changes ?
     C                   EXFMT     FMSAV
      *                 |--------------|  YaNein
<--1 C     *IN01         IFEQ      *ON
|   GC     *INKC         CABEQ     *ON           ENDEXT
|   GC     *INKL         CABEQ     *ON           ENDEXT
|   GC                   GOTO      INEXIT
|__1 C                   ENDIF
      *
<--1 C     YESNO         IFEQ      'Y'
|    C                   EXSR      SRSAVE
|__1 C                   ENDIF
      *
     C                   EXSR      QUIT
     C     ENDEXT        ENDSR
      *
      *@$$$$$$$$ SRSAVE $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRSAVE        BEGSR
      *
<--1dC     *IN50         DOUEQ     *ON
<--2 C     PRMUSR        IFEQ      *BLANKS
|    C     KEYRCD        DELETE    MAGHLPF                            50
->E2 C                   ELSE
|    C     KEYUSR        DELETE    USRHLPF                            50
|__2 C                   ENDIF
|__1dC                   ENDDO
      *
      * Find last text in SubF                                         SRSAVE
     C                   Z-ADD     #RECS1        TOTLIN            5 0
<--1dC                   DO        #RECS1
|   IC     TOTLIN        CHAIN     SFL1                               50
<--2 C     HMTXT         IFNE      *BLANKS
|    C                   LEAVE
|__2 C                   ENDIF
|    C                   SUB       1             TOTLIN
|__1dC                   ENDDO
      * HEADER
<--1 C     TOTLIN        IFGT      0
|    C                   MOVEL     PRMFIL        HMFIL
|    C                   MOVEL     PRMRCD        HMRCD
|    C                   MOVEL(P)  HLPTXT        HMTXT
|    C                   MOVEL     HLPPRV        HMPRV
|    C                   MOVEL     WQUSRN        HMUSR
|    C                   MOVEL     UDATE         HMDAT
|    C                   CLEAR                   HMSEQ
<--2 C     PRMUSR        IFEQ      *BLANKS
|    C                   WRITE     MAGHLPF
->E2 C                   ELSE
|    C                   WRITE     USRHLPF
|__2 C                   ENDIF
|     * SAVE TEXT
<--2dC                   DO        TOTLIN        HMSEQ
|   IC     HMSEQ         CHAIN     SFL1                               50
<--3 C     PRMUSR        IFEQ      *BLANKS
|    C                   WRITE     MAGHLPF
->E3 C                   ELSE
|    C                   WRITE     USRHLPF
|__3 C                   ENDIF
|__2dC                   ENDDO
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ *INZSR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
      *
     C     WQLIBN        CAT       '/MAG103B'    MG103B           21
     C                   CALL      MG103B
     C                   PARM                    CGLIST            1 0
      *
     C                   CALL      'MAG1031'
     C                   PARM                    WQPGMN
     C                   PARM      ' '           #LOAD             1
      *                                                                *INZSR
      *                                                     pgm+data
<--1 C     PRMUSR        IFEQ      *BLANKS
|    C                   OPEN      HMAGHLP
->E1 C                   ELSE
|    C                   OPEN      HUSRHLP
|__1 C                   ENDIF
      *                                                                *INZSR
     C                   Z-ADD     1             SFLRC1
      * Get prev DspSize
     C                   CALL      'DSPSIZ'
     C                   PARM                    DSPSIZ            3 0
     C                   PARM                    CSRLIN            3 0
     C                   PARM                    CSRPOS            3 0
     C     DSPSIZ        COMP      132                                    12
     C     *LIKE         DEFINE    HMFIL         SAVFIL
     C     *LIKE         DEFINE    HMRCD         SAVRCD
     C                   ENDSR
      *
      *@$$$$$$$$ CLRSFL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRSFL        BEGSR
     C                   MOVEA     '11'          *IN(70)
     C                   WRITE     SFC1
     C                   MOVEA     '00'          *IN(70)
     C                   CLEAR                   RRN1
     C                   CLEAR                   #RECS1
     C                   ENDSR
      *
      *@$$$$$$$$ SRF8   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF8          BEGSR
      *          Underline
     C                   EXSR      UPCURS
      *
<--1 C     RCD           IFEQ      'SFL1'
|    C     POS           ANDNE     0
|    C     CURRCD        ANDNE     0
|   IC     CURRCD        CHAIN     SFL1                               50
<--2 C     TX(POS)       IFGE      X'40'
|    C                   MOVE      X'20'         TX(POS)
|__2 C                   ENDIF
|    C                   BITON     '6'           TX(POS)
|    C                   UPDATE    SFL1
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ SRF9   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF9          BEGSR
      *          Highlight
     C                   EXSR      UPCURS
      *
<--1 C     RCD           IFEQ      'SFL1'
|    C     POS           ANDNE     0
|    C     CURRCD        ANDNE     0
|   IC     CURRCD        CHAIN     SFL1                               50
<--2 C     TX(POS)       IFGE      X'40'
|    C                   MOVE      X'20'         TX(POS)
|__2 C                   ENDIF
|    C                   BITON     '5'           TX(POS)
|    C                   UPDATE    SFL1
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ SRF10  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF10         BEGSR
      *          Normal
     C                   EXSR      UPCURS
      *
<--1 C     RCD           IFEQ      'SFL1'
|    C     POS           ANDNE     0
|    C     CURRCD        ANDNE     0
|   IC     CURRCD        CHAIN     SFL1                               50
|    C                   MOVE      X'20'         TX(POS)
|    C                   UPDATE    SFL1
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ SRF4   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF4          BEGSR
      *
     C                   EXSR      UPCURS
      *
<--1 C     RCD           IFEQ      'SFL1'
|    C     POS           ANDNE     0
|    C     CURRCD        ANDNE     0
|     *
|    C                   Z-ADD     #RECS1        RECORD            5 0
|    C                   CLEAR                   TXTNXT
|     *
<--2dC     RECORD        DOULT     CURRCD
|   IC     RECORD        CHAIN     SFL1                               50
|    C                   MOVE      HMTXT         TXTSAV
|    C                   MOVE      TXTNXT        HMTXT
|    C                   UPDATE    SFL1
|    C                   MOVE      TXTSAV        TXTNXT
|    C                   SUB       1             RECORD
|__2dC                   ENDDO
|__1 C                   ENDIF
      *
     C     *LIKE         DEFINE    HMTXT         TXTNXT
     C     *LIKE         DEFINE    HMTXT         TXTSAV
     C                   ENDSR
      *
      *@$$$$$$$$ SRF6   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF6          BEGSR
      *
     C                   EXSR      UPCURS
      *
<--1 C     RCD           IFEQ      'SFL1'
|    C     POS           ANDNE     0
|    C     CURRCD        ANDNE     0
|     *
|    C                   CLEAR                   TXTSAV
|     *                                                                SRF6
<--2dC     CURRCD        DO        #RECS1        RECORD
|   IC     RECORD        CHAIN     SFL1                               50
|    C                   MOVE      HMTXT         TXTNXT
|    C                   MOVE      TXTSAV        HMTXT
|    C                   MOVE      TXTNXT        TXTSAV
|    C                   UPDATE    SFL1
|__2dC                   ENDDO
|     *
<--2 C     TXTSAV        IFNE      *BLANKS
|    C                   MOVE      TXTSAV        HMTXT
|    C                   EXSR      WRTSFL
|    C                   CLEAR                   HMTXT
<--3dC     2             DO        12
|    C                   EXSR      WRTSFL
|__3dC                   ENDDO
|__2 C                   ENDIF
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ SRF5   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF5          BEGSR
     C                   EXSR      CLRSFL
     C     KEYRCD        KLIST
     C                   KFLD                    PRMFIL
     C                   KFLD                    PRMRCD
     C     KEYUSR        KLIST
     C                   KFLD                    PRMFIL
     C                   KFLD                    PRMRCD
     C                   KFLD                    PRMUSR
      * READ Hdr                                                       SRF5
<--1 C     PRMUSR        IFEQ      *BLANKS
|    C     KEYRCD        SETLL     MAGHLPF
|   IC     KEYRCD        READE(N)  MAGHLPF                                50
->E1 C                   ELSE
|    C     KEYUSR        SETLL     USRHLPF
|   IC     KEYUSR        READE(N)  USRHLPF                                50
|__1 C                   ENDIF
      *
<--1 C     *IN50         IFEQ      *OFF
|    C                   MOVEL     HMTXT         HLPTXT
|    C                   MOVEL     HMPRV         HLPPRV
|    C                   EXSR      GETTXT
->E1 C                   ELSE
|    C                   CLEAR                   HLPTXT
|    C                   MOVEL(P)  'N'           HLPPRV
|__1 C                   ENDIF
      *
     C     #RECS1        DIV       12            IX                5 0
     C                   MVR                     IX
<--1 C     IX            IFNE      0
|    C     #RECS1        OREQ      0
|    C                   CLEAR                   USRHLPF
|    C     12            SUB       IX            IX
<--2dC                   DO        IX
|    C                   EXSR      WRTSFL
|__2dC                   ENDDO
|__1 C                   ENDIF
     C                   ENDSR
      *
      *@$$$$$$$$ GETTXT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETTXT        BEGSR
      *          Load SubF
<--1dC                   DO        *HIVAL
<--2 C     PRMUSR        IFEQ      *BLANKS
|   IC     KEYRCD        READE(N)  MAGHLPF                                50
->E2 C                   ELSE
|   IC     KEYUSR        READE(N)  USRHLPF                                50
|__2 C                   ENDIF
|    C   50              LEAVE
|    C                   EXSR      WRTSFL
|__1dC                   ENDDO
      *
     C                   Z-ADD     1             SFLRC1
     C                   ENDSR
      *
      *@$$$$$$$$ WRTSFL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRTSFL        BEGSR
     C                   ADD       1             #RECS1
     C                   Z-ADD     #RECS1        RRN1
     C                   WRITE     SFL1
     C                   ENDSR
      *
      *@$$$$$$$$ NXTPAG $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     NXTPAG        BEGSR
     C                   CLEAR                   USRHLPF
<--1dC                   DO        12
|    C                   EXSR      WRTSFL
|__1dC                   ENDDO
     C                   Z-ADD     #RECS1        SFLRC1
     C                   ENDSR
      *
      *@$$$$$$$$ UPCURS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPCURS        BEGSR
      *          Cursor position
      *
     C     CSRLOC        DIV       256           CSRLIN            3 0
     C                   MVR                     CSRPOS            3 0
     C     WINLOC        DIV       256           WINLIN            3 0
     C                   MVR                     WINPOS            3 0
     C                   ENDSR
      *
      *@$$$$$$$$ RUNCL  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    CLCMD           255
     C                   PARM      255           CLLEN            15 5
     C                   ENDSR
      *
      *@$$$$$$$$ SRF21  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF21         BEGSR
      *          Cmd line
     C                   CALL      'QUSCMDLN'                           50
     C                   ENDSR
      *
      *@$$$$$$$$ QUIT   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
      *
<--1 C     CGLIST        IFEQ      1
|    C     'RMVLIBLE'    CAT(P)    WQLIBN:1      CLCMD
|    C                   EXSR      RUNCL
|__1 C                   END
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *================================================================$

      *%METADATA                                                       *
      * %TEXT Restore Image record to Dasd                             *
      *%EMETADATA                                                      *
      * MAG1505 - Add Image rec to DASD.  Update MImgDir, MFldDir @ End
      *
/2484 * 03-05-10 EPG Change the PF from reuse deleted records *YES to *NO.
      * 06-04-96 PF  Added Logic to update new optical counters
      *
      * 12-21-95 GK  Program Created.
      *  1-23-96 JJF Count #IRecs as added, instead of get from MImgDir
      *
     FMIMGDIR   UF   E           K DISK    USROPN
     FMFLDDIR   UF   E           K DISK    USROPN
     FIMGFIL    O  A F 1024        DISK    INFDS(FILDAT)
     F                                     USROPN
      *
     D IMAGE           S              1    DIM(1024)
     D CL              S             79    DIM(8) CTDATA PERRCD(1)              Cl commands
      *================================================================
      *
     D*@  IND INPT CALC  OUT    IND INPT CALC  OUT    IND INPT CALC  OUT
     D*@   50        M           95        M
     D*@  *MAIN*       UPDDIR QUIT
     D*@  OPNIMG       QUIT   RUNCL  CRTFIL QUIT
     D*@  QUIT         RUNCL
     D*@  *INZSR       OPNIMG
     D*@ SPYREAL/QRPGSRC/MAG1505           1/23/96 at 16:12:04 by JOHN
     D*@
     D FILDAT          DS
      * Last RRN in IMGFIL when opened.
     D  LSTRRN               156    159B 0
      *
      *================================================================
     C     *ENTRY        PLIST
     C                   PARM                    OPCODE            6            Oper code
     C                   PARM                    BTCHNO           10            Batch #
     C                   PARM                    IFILE            10            I000...Fil
     C                   PARM                    FLDR             10            Folder
     C                   PARM                    FLDRLB           10            Folder Lib
     C                   PARM                    IMAGE                          Image Data
     C                   PARM                    RTNCDE            7
     C                   PARM                    RTNDTA          100
      *
<--1 C     OPCODE        IFNE      'QUIT'
|   OC                   EXCEPT    ADDIRC                                       Add IMG rec.
|    C                   ADD       1             #IRECS
|    C                   RETURN
|     *
->E1 C                   ELSE                                                   Quitting,
<--2 C     #IRECS        CASGT     0             UPDDIR                          update dir
|__2 C                   ENDCS                                                   files.
|    C                   MOVE      *BLANKS       RTNCDE
|    C                   MOVE      *BLANKS       RTNDTA
|    C                   EXSR      QUIT
|__1 C                   ENDIF
      *
      *
      *@$$$$$$$$ UPDDIR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPDDIR        BEGSR
      *          Update Image and Folder directory files.
      *
    IC     BTCHNO        CHAIN     IMGDIR                             95
<--1 C     *IN95         IFEQ      '0'                                          Update
|    C                   MOVE      IDILOC        OLDLOC            1             MImgDir
|    C                   MOVE      '0'           IDILOC
|    C                   MOVE      IFILE         IDPFIL
|     *
|    C     LSTRRN        ADD       1             IDBBGN                          Add to Lst
|    C     LSTRRN        ADD       #IRECS        IDBEND                          rec on fil.
|     *
|    C                   UPDATE    IMGDIR
|__1 C                   ENDIF
      *
      *
|   IC     FDKEY         CHAIN     FLDDIR                             95
<--2 C     *IN95         IFEQ      '0'                                          Updt MFldDir
<--1 C     OLDLOC        IFEQ      '1'                                          If 1 (=tape)
|    C                   SUB       1             FDIOPT                          - Tape
     C                   ELSE
|    C                   SUB       1             FDIOPC                          - OPTICAL
|__1 C                   END
|    C                   ADD       1             FDIDSD                          + Dasd
|    C                   UPDATE    FLDDIR
|__2 C                   END
     C                   ENDSR
      *
      * ---------------------------------------------------
     C     FDKEY         KLIST                                                  FldDir key
     C                   KFLD                    FLDR
     C                   KFLD                    FLDRLB
      *
      *
      *@$$$$$$$$ OPNIMG $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPNIMG        BEGSR
      *          Open Dasd Image file  (for output add)
      *
     C     CL(2)         CAT(P)    'IMGFIL':0    CLCMD                          OvrDbf
     C                   CAT       CL(3):0       CLCMD                          ToFile
     C                   CAT       FLDRLB:0      CLCMD
     C                   CAT       '/':0         CLCMD
     C                   CAT       IFILE:0       CLCMD                          I000...
     C                   CAT       ')':0         CLCMD
     C                   CAT       CL(6):1       CLCMD
     C                   EXSR      RUNCL
      *
     C                   Z-ADD     0             #IRECS            9 0
     C                   OPEN      IMGFIL                               50
      *
<--1 C     *IN50         IFEQ      '1'                                          FilNotThere
|    C                   EXSR      CRTFIL                                       Create it.
|    C                   OPEN      IMGFIL                               50
|__1 C                   ENDIF
      *
      * Ck for lock.  If not locked, lock it.  If locked, error.
     C                   CALL      'IMGLOCK'                                    Check for
     C                   PARM                    IFILE                           locked.
     C                   PARM                    FLDRLB
     C                   PARM                    RTNCDE
     C                   PARM                    RTNDTA
<--1 C     RTNCDE        IFNE      *BLANKS                                      ERROR,
|    C                   EXSR      QUIT                                          quit...
|__1 C                   ENDIF
      *
     C                   ENDSR
      *
      *@$$$$$$$$ CRTFIL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CRTFIL        BEGSR
      *          If I000.. does not exist - create it.
      *
     C     CL(4)         CAT(P)    FLDRLB:0      CLCMD                          Crt File
     C                   CAT       '/':0         CLCMD                          I000...
     C                   CAT       IFILE:0       CLCMD
     C                   CAT       CL(5):0       CLCMD
      *
     C                   CALL      'MAG1030'
     C                   PARM                    CRTRTN            1
     C                   PARM      FLDRLB        CRTLIB           10
     C                   PARM      IFILE         CRTOBJ           10
     C                   PARM      '*FILE'       CRTTYP           10
     C                   PARM                    CLCMD
<--1 C     CRTRTN        IFNE      ' '
|    C                   MOVEL     'ERR1473'     RTNCDE                         Term error.
|    C                   MOVE      *BLANKS       RTNDTA
|    C                   EXSR      QUIT
|__1 C                   ENDIF
      *
     C                   ENDSR
      *
      *@$$$$$$$$ RUNCL  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
      *          Delete overrides, close files and shutdown.
      *
     C                   CALL      'QCMDEXC'                            81
     C                   PARM                    CLCMD           255
     C                   PARM      255           CLLEN            15 5
      *
     C                   ENDSR
      *
      *@$$$$$$$$ QUIT   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
      *          close files and shutdown.
      *
     C                   CLOSE     *ALL
      *
     C                   MOVEL(P)  CL(1)         CLCMD                          DltOvr *ALL
     C                   EXSR      RUNCL
      *
     C                   MOVEL(P)  CL(7)         CLCMD                          DlcObj
     C                   CAT       FLDRLB:0      CLCMD
     C                   CAT       '/':0         CLCMD
     C                   CAT       IFILE:0       CLCMD
     C                   CAT       CL(8):0       CLCMD
     C                   EXSR      RUNCL
      *
     C                   SETON                                        LR        Shutdown
     C                   RETURN                                                 Pgm
      *
     C                   ENDSR
      *
      *@$$$$$$$$ *INZSR $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
      *
      *          Open files.
     C                   OPEN      MFLDDIR
     C                   OPEN      MIMGDIR
     C                   EXSR      OPNIMG                                       Open I file
     C                   ENDSR
      *
      *================================================================
     OIMGFIL    EADD         ADDIRC
     O                       IMAGE             1024
      *
      *================================================================
** CL
DLTOVR FILE(*ALL)
OVRDBF FILE(
) TOFILE(
CRTPF FILE(
) RCDLEN(1024) MAXMBRS(*NOMAX) SIZE(*NOMAX) REUSEDLT(*NO)
FRCRATIO(1024) SEQONLY(*YES 1024)
DLCOBJ OBJ((
 *FILE *EXCLRD))

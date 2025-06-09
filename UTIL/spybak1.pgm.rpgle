      *%METADATA                                                       *
      * %TEXT Move Reports & Batches to tape or optical                *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR') actgrp('DOCMGR')
      **********------------------------------------------------------
      * SPYBAK1  Move 1 (one) report or image batch to tape or optical
      **********------------------------------------------------------
      *
      * Called by SPYBACK (RPG)       DAVID MICKLE   5/14/93
      *
      * 1) If output is DASD, when done call SPYSAVCL to save DASD
      *      file to tape.
      * 2) Update MRptDIR for reports:     LOCSFA A)ttr pointer
      *      REPLOC Location 1=Tape 2=Opt  LOCSFC C)ompres tbl pointer
      *      OFRVOL Offline Volume         LOCSFD D)ata pointer
      *      OFRDAT    "    Date           LOCSFP P)g tbl pointer
      *      OFRNAM    "    Name           LOCSFE E)nd report pointer
      * 3) Update MImgDIR for images when moved to tape.
      *      (Mag1502 handles images to optical.)
      *---
J3068 * 10-28-10 PLR Add Tivoli management class support.
J2592 * 04-29-10 PLR Patch J1793 causes the spybak job to ignore all volumes
      *              in a set. Removed patch for the time being.
J2366 * 02-05-10 PLR Unreferenced 'I' files backed up to tape were not being
      *              deleted. Caused by 7111. Removed code around call to
      *              MAG1507. Left code that clears idpfil (image file name)
      *              on quit.
J1793 * 05-08-09 PLR Trap duplicate key error in MOPTTBL1 (OPTFIL). Could not
      *              duplicate issue on customer system or in-house. Added code
      *              to detect duplicate key and return archive failure and
      *              continue.
T6944 * 04-17-08 PLR Remove reference to old revision control logging service
      *              program MMAUDLOGR. Deprecated by MLAUDLOG.
/9274 * 10-04-04 JMO Added new logic to make sure MAG1090 shuts down when the
      *                *PSSR subroutine triggers SPYBAK1 to shut down. Also,
      *                added code to write the actual error to the job log as
      *                well as the SPYGLASS message queue.
/9134 *  7-07-04 JMO Added code to specify the MBR on OVRDBF commands for folder
      *              and Image files.
/8911 * 03-25-04 JMO Changed sequence of updates to the Folder header record so
      *               that an extra header record will not be written to optical
      *               This is only an issue when the report on DASD is uncompres
      *               is being compressed as it is written to optical.
      *               (see subroutine OPT$UC)
/8879 *  3-08-04 JMO Added DATFOP to parms for MAG1040.
/5635 *  3-04-04 JMO Added logic to write HIPAA logging for Moving a report
      *                to optical.
/8779 * 01-13-04 JMO Added double check to be sure that the report or
/     *               image has not already been moved off-line.
/8696 * 01-02-04 PLR Added return code to plist for MAG1502. Needed to allow
/     *              MAG1502 to set error severity based on error. This will
/     *              facilitate the termination or continuation of processing.
/8738 * 12-05-03 JMO Added additional logic for report RRN validation.
/     *                The Job number, spool number and Spool file opened date
/     *                will be passed to MAG1040 to be used to validate RRNs.
/6708 * 10-21-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte bina
      *              Remove access to MRPTDIR, use MRPTDIR1 instead.
      *              Change FILNUM (in MRPTDIR) to be the actual spool file numb
      *              change MRPTDIR1 key to include the spool file opened date.
/8437 * 07-07-03 PLR Messaging not sent up the stack for write to storage error.
/7174 * 12-19-02 JMO Corrected wrong field used in chain to RMAINT.
      *               When backing up an image batch the FILNAM field
      *               contains the Batch ID.  Therefore, we must get
      *               the DocType from the MIMGDIR record.
/7111 * 12-13-02 PLR Clear out ifile name when calling MAG1507 on quit and or tr
/     *              to delete a file that is on optical (doesn't exist on dasd)
/     *              Was causing the addition of an invalid PNDCMD record.
/6913 * 09-12-02 PLR Removed reference to tape sequence when building SETMEDBRM
/     *              Value of '0000' invalid and caused failure.
/6531 * 04-26-02 PLR File size counter overflow causing duplicate key error
/     *              to MOPTTBL when dealing with very large files. i.e., 1M pgs
/5917 * 12-19-01 KAC "A" file data incorrectly written to tape.
/5400 *  9-13-01 KAC File already open bug.
/4582 * 06-18-01 DLS Add RC audit log.
/4614 *  6-14-01 DLS Program is erroring CHKTAP dev is not parsed right
/3717 *  1-25-01 DLS Add Ignore of Open Batch Error
/3321 * 12-29-00 KAC REMOVE OPT ID (OBSOLETE AS OF 6.0.6)
/2595 *  5-12-00 DLS Validate pointers prior to saving.  If invalid do
      *              no update directory record.
/2272 * 12-01-99 DM  Choice between packed or binary pg/pk tables
/2272 *  9-01-99 FID Added new optical support
      *  2-01-99 KAC DISABLE CONVERSION FILE DOCS FROM BACKUP
      * 12-09-98 KAC CHANGE PARMS TO MAG1502 & MAG1512.
      *  7-23-98 KAC DISABLE IMAGEPLUS FROM BACKUP
      *  5-25-98 JJF Call GETNUM to assign Ifile# & Offline file
      *  4-09-98 GT  Add retry for dir in use when attempting to create
      *  3-09-98 KAC DISABLE R/DARS & IMAGEVIEW FROM BACKUP
      *  1-31-98 JJF Change optical code for SPYVCT rtning VOLS,1 only
      * 12-29-97 GT  Corrected data queue send length (RCSLEN) calculation
      *  6-17-97 JJF Don't fail if APFNAM file non-exist (cust deleted)
      *  6-04-97 JJF Process APF rpt data and page tbl files to tape
      *  2-18-97 JJF Add msg ERR135B to name report for other err msgs
      *---
      * 12-31-96 JJF Change OPT array to 512*256=131,072 bytes to
      *              assure maximum optical filesize = 16,384,000.
      *  8-14-96 KAC Redirect FileClerk Image Batches to MAG1512.
      *  8-07-96 AMR Move AFP resources to optical (Mag808)
      *  6-30-96 JJF Add MAGSERVER optical lan writing (OPTTYP field)
      *  1-23-96 JJF Call Mag1507 to check & delete IMGFIL if empty.
      *  1-12-96 JJF Speed enhancements: Leave pgm up betwn batch mode
      *              calls. Clear PACKTBL instead of delete & create.
      *              Don't close & open PACKTBL between output & input.
      *  Earlier changes are in QRPGARC(SPYBAK1UR)
      *
     FSPYVCTFM  CF   E             WORKSTN USROPN
     FRMAINT    IF   E           K DISK    USROPN
     FMIMGDIR   UF   E           K DISK    USROPN
     FMRPTDIR1  UF   E           K DISK    USROPN
     FMOPTTBL   O    E           K DISK
      *
     FMFLDDIR   IF   E           K DISK
     FRAPFDBF   UF   E           K DISK    USROPN
     FRAPFDBFP  UF   E           K DISK    USROPN
     FPACKTBL   IF A F  256        DISK    USROPN
      *
     FIMGFIL    IF   F 1024        DISK    USROPN
     FFOLDER    IF   F  256        DISK    USROPN
     FIMGTAPE   O    F 1024        SEQ     USROPN
     FREPTAPE   O    F  256        SEQ     USROPN
     FIMGSAV    O  A F 1024        DISK    USROPN
     FREPSAV    UF A F  256        DISK    USROPN
      *======================== Files =================================
      *   for     Input     DASDout      TAPEout     OPTICALout
      *  ------   ------    -------   --(BKREC=Y)--  -----------------
      *  Images   IMGFIL    IMGSAV       IMGTAPE     n/a, call Mag1502
      *  Report   FOLDER    REPSAV       REPTAPE     PCOPT or call QHF_
      *
      * Notes: MAX one input file and one output file in use per call.
      *        aaaTAPE files (device=SEQ) are used only for "record
      *           mode", BKREC=Y.
      *        aaaSAV files actually go to dasd here, then to tape or
      *           optical with a call to SPYSAVCL.
      *        IMGFIL is not used when output is to optical (Mag1052).
      *        PCOPT is output only when OPTTYP='X' (3rd party)
      *           Normally the QHF APIs are called.
      *================================================================
      *
/9274
/9274d QMHSndPm        pr                  extpgm('QSYS/QMHSNDPM')
/9274d  MsgID                         7    const
/9274d  MsgF                         20    const
/9274d  MsgDta                        1    const options(*varsize)
/9274d  MsgDtaLn                     10i 0 const
/9274d  MsgType                      10    const
/9274d  CStack                       10    const
/9274d  CStackC                      10i 0 const
/9274d  MsgKey                        4
/9274d  ErrorDS                       1    options(*varsize)
/9274
/9274 * system API error struct
/9274d APIerrDS        ds
/9274d  AerrBprv                     10i 0 inz(%size(APIerrDS))
/9274d  AerrBavl                     10i 0
/9274d  AerrExcID                     7
/9274d  AerrRSV1                      1
/9274d  AerrData                    128
/9274
/9274d ErrMsgDta       s            200a
/9274d MsgKey          s              4a
/9274
/5635
/5635 * Prototypes for HIPAA logging service program
/5635 /copy @mlaudlog
J3068 /copy @mfputmc
/5635
/5635d LogDS           ds                  inz
/5635 /copy @mlaudinp
/5635
/9134 * copy prototypes for OS APIs
/9134 /copy @OSAPI
/5635
/5635d rc              s             10i 0
/5635d DtlType         s             10i 0

     D CMD             S             78    DIM(38) CTDATA PERRCD(1)
     D MSGE            S              7    DIM(13) CTDATA PERRCD(1)

     D CP              S              7  0 DIM(63)
/2272D CPB             S              9  0 DIM(63)

     D VOLS            S             12    DIM(100)
     D HDR             S            256    DIM(14)
     D OPT             S            256    DIM(512)
     D SND             S            256    DIM(130)
     D OPTR            S              1    DIM(256)
     D OPTN            S              1    DIM(10)

     D IPK             S            256    DIM(128)
     D OPK             S            256    DIM(128)

     D SVD             S              1    DIM(50)
     D IMGDTA          DS
     D  IMAGE1                 1    256
     D  IMAGE2               257    512
     D  IMAGE3               513    768
     D  IMAGE4               769   1024
     D CPTAB           DS
     D  PK                     1    252P 0 DIM(63)
/2272D  PKB                    1    252b 0 DIM(63)

     D SAVDS1          DS
     D  SAVSFA                 1      4i 0
     D  SAVSFD                 5      8i 0
     D  SAVSFP                 9     12i 0
     D SAVDS2          DS
     D  SAVSFE                 1      4i 0
     D  SAVSFC                 5      8i 0
     D  SAVREC                 9     12i 0
     D  SAVVER                13     24
     D                 DS
      *             Binary to char
     D  APFSEX                 1      4
     D  APFSEQ                 1      4B 0
     D  APGSEX                 5      8
     D  APGSEQ                 5      8B 0
     D APFDTA          DS
     D  ADVD                   1   4079    DIM(4079)
     D APGDTA          DS
     D  ADVP                   1    378    DIM(378)

     D @MSGDT          DS           103
     D  ERRLEN                 9     12i 0
     D  @EM                   25    103    DIM(79)
     D                 DS
     D  CSFA                   1      4
     D  CSFD                   5      8
     D  CSFP                   9     12
     D  CSFC                  13     16
     D  CSFE                  17     20
     D  CREC                  21     24
     D  OPTSFA                 1      4i 0
     D  OPTSFD                 5      8i 0
     D  OPTSFP                 9     12i 0
     D  OPTSFC                13     16i 0
     D  OPTSFE                17     20i 0
     D  OPTREC                21     24i 0
     D                 DS
     D  BGRLS                  1      6
     D  OSRLS                  1      4

     D  IBUFL          s             10i 0
     D  OBUFL          s             10i 0
     D  RBUFL          s             10i 0

     D OBUF            DS            44

     D SYSDFT          DS          1024    dtaara
     D  SYSPAK                86     86
     D  LVEROP               222    222
     D  BKREC                371    371
     D  BRMSYN               372    372
     D  ENDOPT               404    413
     D                 DS
     D  YYMMDD                 1      8  0
     D  YY                     1      2  0
     D  YYYY                   1      4  0
     D  MMDD                   5      8  0
     D  YMMDD                  3      8  0
     D FLSIZ           DS
     D  @ML                    1      3
     D  @CML                   4      4
     D  @TH                    5      7
     D  @CTH                   8      8
     D  @HU                    9     11
     D                 DS
     D  @BR                    1     50    DIM(50)

     D  STSBAR                 1     50
     D RETCD           DS
     D  ERLEN                  1      4i 0
     D  RTCD                   5      8i 0
     D  CONDTN                 9     15
     D  RSV                   16     16
     D  MSGDTA                17    116

     D  MSGL           s             10i 0
     D  MSGDTL         s             10i 0
     D  PAKLEN         s             10i 0
     D  INRLEN         s             10i 0

     D                SDS
     D  PGMERR           *STATUS
     D  WQPGMN                 1     10
     D  PGMLIN                21     28
     D  SYSERR                40     46
     D  SPYLIB                81     90
/9274D  SysErrDta             91    170
     D  WQUSRN               254    263
     D  $JOB#                264    269

     D PSCON           C                   CONST('PSCON     *LIBL     ')
     D OPTICL          C                   CONST('OPTICAL   ')
     D NULLS           C                   CONST(X'0000000000-
     D                                     0000000000')
     D INACT           C                   CONST('*ALLINACT')
     d endrrn          s                   like(locsfa)

     D  STKCNT         s             10i 0

     D ERRCD           DS           116
     D  @ERLEN                 1      4i 0
     D  @ERCON                 9     15
     D  @ERDTA                17    116
     D  @ED                   17    116    DIM(100)

/    d eFilNb          s              9b 0
/    d eDatfo          s              9b 0

/8738d filnub          s              9b 0

     IFOLDER    NS
     I                                  1    1  RECTYP
     I                             i  105  108 0OUTSFA
     I                             i  109  112 0OUTSFD
     I                             i  113  116 0OUTSFP
     I                             i  182  185 0OUTSFE
     I                             i  186  189 0OUTSFC
     I                             i  190  193 0OUTREC
     I                                245  254  PGM
/2272I                                254  254  PGTBTF
     I                                255  256  PGMLB1
     I                                  2    9  PGMLB2
     I                                  1  256  DATA
     IREPSAV    NS
     IPACKTBL   NS
/2272I                                  1  253  CPTABT
     I                                  1  252  CPTAB
     IIMGFIL    JF
     I                                  1  256  IMAGE1
     I                                257  512  IMAGE2
     I                                513  768  IMAGE3
     I                                769 1024  IMAGE4

     C     *ENTRY        PLIST
     C                   PARM                    EFLDR            10
     C                   PARM                    EFLDRL           10
     C                   PARM                    EFILNM           10
     C                   PARM                    EJOBNM           10
     C                   PARM                    EUSRNM           10
     C                   PARM                    EJOBNB            6
/6708C                   PARM                    DATFO             7
     C                   PARM                    EFILNB

     C                   PARM                    EVOL              6
     C                   PARM                    EDRV             15
     C                   PARM                    evolume          12
     C                   PARM                    EDEV             10
     C                   PARM                    OFSNAM           10
     C                   PARM                    PGMOPF           10
     C                   PARM                    PGMLIB           10
     C                   PARM                    TAPSEQ            4
     C                   PARM                    EDEN             11
     C                   PARM                    LSTRPT            1
     C                   PARM                    RETRN
/3717C                   PARM                    EIGNOR            4

/6708c                   move      datfo         eDatfo

     C                   MOVE      '1'           RETRN
     C                   EXSR      @OPNIO

      * From: (RptDir says)
     C     PKVER         IFNE      ' '
     C                   MOVEL     'C'           @PKCOD            2
     C                   ELSE
     C                   MOVEL     'U'           @PKCOD
     C                   END

      * To: (SysDft says)
     C     SYSPAK        IFEQ      'Y'
     C                   MOVE      'C'           @PKCOD
     C                   ELSE
     C                   MOVE      'U'           @PKCOD
     C                   END

     C     @PKCOD        IFEQ      'CU'
     C                   MOVE      'CC'          @PKCOD
     C                   END

      * SKIP SOME CONVERTED IMAGES AND REPORT
     C     @INPUT        IFEQ      'I'
     C                   call      'MAG1040'
     C                   parm                    idpfil
     C                   parm                    idflib
     C                   parm                    idbbgn
     C                   parm                    idbend
     C                   parm                    idiloc
     C                   parm      'IMAGE'       action            5
     C                   parm                    err#              2 0
/3717C                   parm                    eignor
     C     IDITYP        IFEQ      '5'
     C     IDITYP        OREQ      '9'
     C     ERR#          ORNE      0
     C     ERR#          IFNE      0
     C                   MOVE      '2'           RETRN
     C                   ELSE
     C                   MOVE      '1'           RETRN
     C                   END
     C                   GOTO      DIRUPD
     C                   END
      **
     C                   ELSE
      **
/8738c                   eval      filnub = filnum
     C                   call      'MAG1040'
     C                   parm                    fldr
     C                   parm                    fldrlb
     C                   parm                    locsfa
     C                   parm                    endrrn
     C                   parm                    reploc
     C                   parm      'RPORT'       action
     C                   parm                    err#
/3717C                   parm                    eignor
/8738c                   parm      jobnum        @jobnr            6
/    c                   parm                    filnub
/8879c                   parm      mdatop        Mdatop7           7 0
/8879c                   parm      datfop        datfop7           7 0
      **
     C     REPLOC        IFEQ      '4'
     C     REPLOC        OREQ      '5'
     C     REPLOC        OREQ      '6'
     C     ERR#          ORNE      0
     C     ERR#          IFNE      0
     C                   MOVE      '2'           RETRN
     C                   ELSE
     C                   MOVE      '1'           RETRN
     C                   END
     C                   GOTO      DIRUPD
     C                   END
     C                   END

      * Images
     C     @INPUT        IFEQ      'I'
     C     EDEV          CASEQ     OPTICL        IMGOPT
     C     IDITYP        CASEQ     '2'           IMGFC
     C                   CAS                     IMGTAP
     C                   ENDCS
     C                   GOTO      DIRUPD
     C                   END

      * Report tape                                        REPORT
     C     EDEV          IFNE      OPTICL
     C     @PKCOD        CASEQ     'UU'          TAP$UU
     C     @PKCOD        CASEQ     'UC'          TAP$UC
     C     @PKCOD        CASEQ     'CC'          TAP$CC
     C                   ENDCS
     C     RETRN         CASEQ     '0'           AFPTAP
     C                   ENDCS
     C     BKREC         IFEQ      'Y'
     C                   CLOSE     REPTAPE
     C                   ELSE
     C                   EXSR      SAVOBJ
     C                   END
      * Report opt
     C                   ELSE
     C     @PKCOD        CASEQ     'UU'          OPT$UU
     C     @PKCOD        CASEQ     'UC'          OPT$UC
     C     @PKCOD        CASEQ     'CC'          OPT$CC
     C                   ENDCS
     C     RETRN         CASEQ     '0'           AFPOPT
     C                   ENDCS
     C                   END

      *>>>>
     C     DIRUPD        TAG
     C     RETRN         IFEQ      '0'
     C                   EXSR      UPDDIR

     C     BATCH         IFNE      'Y'
     C     @INPUT        IFNE      'I'
     C     IDITYP        ORNE      '2'
     C                   MOVE      *BLANKS       STSBAR
     C                   MOVE      X'23'         @BR(1)
     C                   MOVE      X'20'         @BR(50)
     C                   WRITE     STATUS
     C                   END
     C                   END
     C                   END

     C                   EXSR      EXIT

/5635c*------------------------------------------------------------------------
/5635c*- BldLogEnt - Build HIPAA log entries and write them
/5635c*------------------------------------------------------------------------
/5635c     BldLogEnt     begsr
/5635
/5635 * write from volume (detail)
/5635c                   eval      DtlType = #DTVOL
/5635c                   if        @input = 'I'
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:*NULL:0:
/5635c                               %addr(evolume):%len(%trim(evolume)))
/5635c                   eval      LogObjID  = Idbnum
/5635c                   else
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:*NULL:0:
/5635c                               %addr(OfrVol):%len(%trim(OfrVol)))
/5635c                   eval      LogObjID  = RepInd
/5635c                   endif
/5635
/5635 * build log header
/5635c                   eval      LogOpCode = #AUBKPOBJ
/5635c                   eval      LogUserID = Wqusrn
/5635c                   callp     LogEntry(%addr(LogDS))
/5635
/5635c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

     C                   IN        SYSDFT

     C                   CALL      'MAG1034'
     C                   PARM      ' '           JOBTYP            1
     C     JOBTYP        IFEQ      *ON
     C                   MOVE      'N'           BATCH             1
     C                   MOVE      'M'           VCARTN            1
     C                   OPEN      SPYVCTFM                             35
     C                   ELSE
     C                   MOVE      'Y'           BATCH
     C                   MOVE      ' '           VCARTN
     C                   END

     C                   Z-ADD     116           @ERLEN
     C                   Z-ADD     116           ERLEN
     C                   Z-ADD     255           STRLEN
     C                   MOVEL     'QTEMP'       SAVLIB           10

     C                   EXSR      CVTSDT

     C                   CALL      'MAG103R'
     C                   PARM                    BGRLS

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @OPNIO        BEGSR
      *          Open input and output files
      *          RMaint  MImgDir/MRptDir  ImgFil/Folder
      *                  ImgTape/RepTape  ImgSav/RepSav
      *                                                    ------------
     C     EUSRNM        IFEQ      ' image'
     C                   MOVE      'I'           @INPUT            1
     C                   MOVE      *BLANK        EUSRNM
     C                   MOVEL(P)  'IMGTAPE'     TAPFIL            8
     C                   MOVE      '1024'        RCDLEN            4
     C                   MOVE      '30720'       BLKLEN            5
     C     $OPNID        IFEQ      ' '
     C                   MOVE      'Y'           $OPNID            1
     C                   OPEN      MIMGDIR                              50
     C                   END
     C     EJOBNM        CHAIN(N)  MIMGDIR                            99
     C     '''':'"'      XLATE(P)  IDDESC        SAVDES
     C                   MOVEL(P)  'IMGFIL'      FILENM

     C     $OPNRM        IFEQ      ' '
     C                   MOVE      'Y'           $OPNRM            1
     C                   OPEN      RMAINT                               50
     C                   END
/7174C                   Movel     IDDOCT        FILNAM
     C                   MOVE      *BLANKS       JOBNAM
     C                   MOVE      *BLANKS       PGMOPF
     C                   MOVE      *BLANKS       USRNAM
     C                   MOVE      *BLANKS       USRDTA
     C     KLBIG5        CHAIN     RMNTRC                             99
     C     KLBIG5        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
      *                                                    ------------
     C                   ELSE
     C                   MOVE      'R'           @INPUT

     C     $OPNRD        IFEQ      ' '
     C                   MOVE      'Y'           $OPNRD            1
     C                   OPEN      MRPTDIR1                             50
     C                   END

     C                   MOVE      EFLDR         PFLDR            10
     C                   MOVE      EFLDRL        PFLDRL           10
     C                   MOVE      EFILNM        PFILNM           10
     C                   MOVE      EJOBNM        PJOBNM           10
     C                   MOVE      EUSRNM        PUSRNM           10
     C                   MOVE      EJOBNB        PJOBNB            6
     C                   MOVE      EFILNB        PFILNB            9 0
     C                   MOVE      eDatfo        pDatfo            9 0
     C     MRPTKY        CHAIN(N)  RPTDIR                             99
     C     MRPTKY        KLIST
     C                   KFLD                    PFLDR
     C                   KFLD                    PFLDRL
     C                   KFLD                    PFILNM
     C                   KFLD                    PJOBNM
     C                   KFLD                    PUSRNM
     C                   KFLD                    PJOBNB
     C                   KFLD                    PFILNB
     C                   KFLD                    pDatfo

     C     $OPNRM        IFEQ      ' '
     C                   MOVE      'Y'           $OPNRM            1
     C                   OPEN      RMAINT                               50
     C                   END
     C     KLBIG5        CHAIN     RMNTRC                             99
     C                   MOVEL     RRDESC        SAVDES           50
     C                   MOVEA     SAVDES        SVD
     C     #             DOUEQ     0
     C     ''''          SCAN      SAVDES        #                 5 0
     C     #             IFEQ      0
     C                   LEAVE
     C                   END
     C                   MOVE      '"'           SVD(#)
     C                   MOVEA     SVD           SAVDES
     C                   ENDDO

J3068 /free
J3068  MFPUTMC('RT=' + rtypid);
J3068 /end-free

     C                   CALL      'CHKACTFLD'   PLIST2
     C     PLIST2        PLIST
     C                   PARM                    EFLDR
     C                   PARM                    EFLDRL
     C                   PARM      '*SHRRD '     EACCES            7
     C                   PARM                    MSGID             7
     C                   PARM                    MSG              70
     C                   PARM                    RETRN6            6
     C     RETRN6        IFNE      *BLANK
     C                   EXSR      ABEND
     C                   END

     C                   MOVEL(P)  'FOLDER'      FILENM           10
     C                   MOVEL(P)  'REPTAPE'     TAPFIL
     C                   MOVE      '0256'        RCDLEN
     C                   MOVE      '32512'       BLKLEN
     C                   END

/8779 * double check to be sure that the image/report is still on-line
/     *  if not, log message and abort.
/    c                   if        (@input='R' and (RepLoc='1' or Reploc='2'))
/    c                             or (@input='I' and (IdiLoc='1' or
/    c                              IdiLoc='2'))
/    c                   movel     msge(2)       @ercon
/    c                   movel     efilnm        @erdta
/    c                   movea     efldr         @ed(11)
     c                   if        (@input = 'R' and Reploc = '1') or
     c                             (@input = 'I' and IdiLoc = '1')
     c                   movea     'Tape'        @ed(21)
     c                   else
     c                   movea     'Optical'     @ed(21)
     c                   endif
/    c                   exsr      rtvmsg
/    c                   movel(p)  @msgtx        log              80
/    c                   exsr      errmsg
/    c                   exsr      abend
/    c                   endif
/8779c
      *                                                    Open input
     C                   EXSR      @OPENF
      *--------                                           -------------
      * OUTPUT                                             OUTPUT
      *--------                                           -------------
     C                   SELECT
     C     @INPUT        WHENEQ    'R'
     C                   CALL      'GETNUM'
     C                   PARM      'GET'         GETOP             6
     C                   PARM      'OPTNAM'      GETTYP           10
     C                   PARM                    OFSNAM           10

     C     @INPUT        WHENEQ    'I'
     C     EDEV          ANDNE     OPTICL
     C                   CALL      'GETNUM'
     C                   PARM      'GET'         GETOP
     C                   PARM      'IMGFIL'      GETTYP
     C                   PARM                    OFSNAM
     C                   ENDSL

     C                   MOVEA     OFSNAM        OPTN
     C                   SELECT
      * Tape                                               ------------
     C     EDEV          WHENNE    OPTICL
      *                                                    ------------@OPNIO
     C     BRMSYN        IFEQ      'Y'
     C                   MOVEL     EDEN          MEDCLS           10
     C                   END

     C     BKREC         IFEQ      'Y'
     C     TAPSEQ        ANDEQ     '*OBJ'
     C                   MOVE      'N'           BKREC
     C                   MOVE      '0001'        TAPSEQ
     C                   END

     C     BKREC         IFEQ      'Y'
     C                   EXSR      SETTAP
     C     SYSPAK        IFEQ      'Y'
     C     PKVER         ANDEQ     ' '
     C                   MOVE      ' '           SYSPAK
     C                   END

     C                   ELSE
     C     @INPUT        IFEQ      'R'
     C                   MOVEL(P)  'REPSAV'      FILENM
     C                   ELSE
     C                   MOVEL(P)  'IMGSAV'      FILENM
     C                   END
     C                   EXSR      @OPENF
     C                   END

      * Optical                                            ------------
     C     EDEV          WHENEQ    OPTICL

     C     EDRV          IFEQ      '*RPTCFG'
     C                   MOVEL     RDRIVE        EDRV
     C                   END

     C     evolume       IFEQ      '*RPTCFG'
     C                   MOVEL     ROPVID        evolume
     C                   END

     C     evolume       IFEQ      *BLANKS
     C                   MOVEL     MSGE(6)       @ERCON
     C                   MOVEL     EFILNM        @ERDTA
     C                   MOVEA     EFLDR         @ED(11)
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG              80
     C                   EXSR      ERRMSG
     C                   EXSR      ABEND
     C                   END
     C                   ENDSL
      * Status bar
     C     BATCH         CASEQ     'N'           SETBAR
     C                   ENDCS

     C                   MOVE      *OFF          *IN10
     C                   Z-ADD     0             SZ               13 0
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @OPENF        BEGSR
      *          Open a file: FOLDER, IMGFIL, REPSAV, IMGSAV or PACKTBL

     C                   SELECT
     C     FILENM        WHENEQ    'FOLDER'
     C                   MOVE      EFLDR         OFILE            10
     C                   MOVE      EFLDRL        FLDLIB           10
     C                   EXSR      @OVRFL
     C                   OPEN      FOLDER                               20

     C     FILENM        WHENEQ    'IMGFIL'
     C                   MOVE      IDPFIL        OFILE
     C                   MOVE      IDFLIB        FLDLIB
     C                   EXSR      @OVRFL
     C                   OPEN      IMGFIL                               20

     C     FILENM        WHENEQ    'REPSAV'
     C                   MOVE      OFSNAM        OFILE
     C                   MOVEL(P)  'QTEMP'       FLDLIB
     C                   EXSR      @CRTFL
     C                   EXSR      @OVRFL
     C                   OPEN      REPSAV                               20

     C     FILENM        WHENEQ    'IMGSAV'
     C                   MOVE      OFSNAM        OFILE
     C                   MOVEL(P)  'QTEMP'       FLDLIB
     C                   EXSR      @CRTFL
     C                   EXSR      @OVRFL
     C     IDITYP        IFNE      '2'
     C                   OPEN      IMGSAV                               20
     C                   END

     C     FILENM        WHENEQ    'PACKTBL'
     C                   MOVEL(P)  'PACKTBL'     OFILE
     C                   MOVEL(P)  'QTEMP'       FLDLIB
     C                   EXSR      @CRTFL
     C                   EXSR      @OVRFL
     C                   OPEN      PACKTBL                              20

     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CRTFL        BEGSR
      *          Create (or clear) a file

     C     CMD(5)        CAT(P)    SAVLIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       OFILE:0       CMDLIN
     C                   CAT       CMD(6):0      CMDLIN
     C                   CAT       SAVDES:0      CMDLIN
     C                   CAT       CMD(7):1      CMDLIN
     C                   CAT       RCDLEN:0      CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   CALL      'MAG1030'
     C                   PARM                    #RTN              1
     C                   PARM                    SAVLIB
     C                   PARM                    OFILE
     C                   PARM      '*FILE'       #TYPE            10
     C                   PARM                    CMDLIN

     C     #RTN          IFEQ      'A'
     C                   CLOSE     PACKTBL
     C     'CLRPFM'      CAT(P)    SAVLIB:1      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       OFILE:0       CMDLIN
     C                   CALL      'QCMDEXC'     PLCMD
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @OVRFL        BEGSR

/9134 * change OVRDBF to specify member.  Also, use prototyped
/9134 *   call to QCmdExc.
/9134c                   eval      cmdLin = 'OVRDBF FILE('+%trim(filenm)+
/9134c                             ') TOFILE('+%trim(FldLib)+'/'+%trim(Ofile)
/9134
/9134c                   if        Filenm = 'FOLDER' or
/9134c                             Filenm = 'IMGFIL'
/9134c                   eval      cmdLin = %trim(cmdLin) +
/9134c                             ') MBR('+%trim(Ofile)+') '
/9134c                             + %trim(cmd(3))+' OVRSCOPE(*CALLLVL)'
/9134c                   else
/9134c                   eval      cmdLin = %trim(cmdLin) + ') ' +
/9134c                             %trim(cmd(4))+' OVRSCOPE(*CALLLVL)'
/9134c                   endif
/9134c
/9134c                   callp(e)  QCmdExc(%trim(cmdLin):%len(%trim(cmdLin)))

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETTAP        BEGSR
      *          ------------------------------------------
      * BKREC=Y  Set the tape file up, Override it, open it
      *          ------------------------------------------
     C     BRMSYN        IFEQ      'Y'
     C     CMD(20)       CAT(P)    MEDCLS:0      CMDLIN
     C                   CAT       CMD(21):0     CMDLIN
     C                   CAT       CMD(22):0     CMDLIN
     C                   CAT       CMD(23):0     CMDLIN
     C                   CALL      'QCMDEXC'     PLCMD                  90
     C     *IN90         IFEQ      *ON
     C     CMD(32)       CAT(P)    MEDCLS:0      CMDLIN
     C                   CAT       CMD(33):0     CMDLIN
     C                   CAT       CMD(34):0     CMDLIN
     C                   CAT       CMD(23):0     CMDLIN
     C                   CALL      'QCMDEXC'     PLCMD                  90
     C                   END
     C                   END

     C     CMD(24)       CAT(P)    TAPFIL:0      CMDLIN
     C                   CAT       CMD(25):0     CMDLIN
     C                   CAT       EDEV:0        CMDLIN
     C                   CAT       CMD(26):0     CMDLIN
     C                   CAT       OFSNAM:0      CMDLIN
/6913c*                  CAT       CMD(27):0     CMDLIN
/6913c*                  CAT       TAPSEQ:0      CMDLIN
     C                   CAT       CMD(28):0     CMDLIN
     C     LSTRPT        IFNE      'Y'
     C                   MOVEL(P)  '*LEAVE'      ENDOP             7
     C                   ELSE
     C                   MOVEL(P)  ENDOPT        ENDOP
     C     ENDOP         IFNE      '*REWIND'
     C     ENDOP         ANDNE     '*UNLOAD'
     C     ENDOP         ANDNE     '*LEAVE'
     C                   MOVEL(P)  '*REWIND'     ENDOP
     C                   END
     C                   END
     C                   CAT       ENDOP:0       CMDLIN
     C                   CAT       CMD(29):0     CMDLIN
     C                   CAT       RCDLEN:0      CMDLIN
     C                   CAT       CMD(30):0     CMDLIN
     C                   CAT       BLKLEN:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLCMD                  90

     C     @INPUT        IFEQ      'R'
     C                   OPEN      REPTAPE                              35
     C                   ELSE
     C     IDITYP        IFNE      '2'
     C                   OPEN      IMGTAPE                              35
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     IMGOPT        BEGSR
      *          ---------------------------
      *          Images to Optical  MAG1502
      *          ---------------------------

      * Close IFile to avoid lock
     C                   CLOSE     IMGFIL                               50
     C                   CALL      'MAG1502'
     C                   PARM      EJOBNM        BTCHNO           10
     C                   PARM      EFLDR         FLDR             10
     C                   PARM      EFLDRL        FLDRLB           10
     C                   PARM      EDRV          DV1502           15
     C                   PARM      evolume       VL1502           12
     C                   PARM      *BLANKS       RT1502            7
     C                   PARM      *BLANKS       RT150D          100
/8696c                   parm                    retrn

     C     RT1502        IFEQ      *BLANKS
     C                   MOVE      '0'           RETRN
     C                   EXSR      EXIT
     C                   ELSE
     C                   MOVEL     RT1502        @ERCON
     C                   MOVEL     RT150D        @ERDTA
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   MOVE      '1'           RETRN
     C                   EXSR      ABEND
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     IMGTAP        BEGSR
      *          ----------------------------------------------
      *          Images to tape  (or to DASD object, then tape)
      *          ----------------------------------------------
     C     IDBEND        SUB       IDBBGN        #IRECS            9 0
     C                   ADD       1             #IRECS
     C     IDBBGN        SETLL     IMGFIL

     C                   DO        #IRECS
     C                   READ      IMGFIL                                 95
     C     BKREC         IFEQ      'Y'
     C                   EXCEPT    IMGTP
     C                   ELSE
     C                   EXCEPT    IMGSV
     C                   END
     C     BATCH         CASEQ     'N'           STATS
     C                   ENDCS
     C                   ENDDO

     C     BKREC         IFEQ      'Y'
     C                   CLOSE     IMGTAPE
     C                   ELSE
     C                   CLOSE     IMGSAV
     C                   EXSR      SAVOBJ
     C                   END

     C                   MOVE      '0'           RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     IMGFC         BEGSR
      *          ---------------------------
      *          FileClerk Images to Tape  MAG1512
      *          ---------------------------
     C                   CALL      'MAG1512'
     C                   PARM      'TO TAP'      FOPCDE            6
     C                   PARM      EJOBNM        BTCHNO           10
     C                   PARM      EFLDR         FLDR             10
     C                   PARM      EFLDRL        FLDRLB           10
     C                   PARM                    DV1512           15
     C                   PARM                    VL1512           12
     C                   PARM      *BLANKS       RT1512            7
     C                   PARM      *BLANKS       RT151D          100

     C     RT1512        IFEQ      *BLANKS
     C                   MOVE      '0'           RETRN
     C                   ELSE
     C                   MOVEL     RT1512        @ERCON
     C                   MOVEL     RT151D        @ERDTA
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   MOVE      '1'           RETRN
     C                   EXSR      ABEND
     C                   END

     C     BKREC         IFNE      'Y'
     C                   EXSR      SAVOBJ
     C                   END

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     TAP$UU        BEGSR
      *          ----------------------------------------------
      *          Report to Tape  (UnCompressed to UnCompressed)
      *          ----------------------------------------------
     C     LOCSFA        SUB       1             RRCNTR            9 0
     C     RRCNTR        SETLL     FOLDER
     C                   SUB       1             RRCNTR
     C                   MOVE      ' '           DONE              1

     C     RRCNTR        DO        *HIVAL        RRCNTR

     C                   READ      FOLDER                                 90
     C     RRCNTR        IFGE      LOCSFP
     C     RECTYP        ANDEQ     '0'
     C     *IN90         OREQ      *ON
     C                   LEAVE
     C                   END

     C     DONE          IFNE      'D'
     C                   MOVE      'D'           DONE
     C                   Z-ADD     0             ATRCNT            9 0
     C     OUTSFA        SUB       2             LOCOFF            9 0
     C     OUTSFE        SUB       LOCOFF        SAVSFE
     C     OUTSFA        SUB       LOCOFF        SAVSFA
     C     OUTSFD        SUB       LOCOFF        SAVSFD
     C     OUTSFP        SUB       LOCOFF        SAVSFP
     C                   Z-ADD     0             SAVSFC
     C                   Z-ADD     0             SAVREC
     C                   MOVE      *BLANKS       SAVVER
     C                   MOVE      *BLANKS       SAVPK             1
     C                   SETON                                        55
     C                   END

     C                   EXSR      OUDATA
     C                   SETOFF                                       55

     C     BATCH         CASEQ     'N'           STATS
     C                   ENDCS

     C     ATRCNT        IFEQ      1
     C                   MOVEL     PGM           PGMOPF
     C                   MOVEL     PGMLB1        PGMLIB
     C                   END

     C     ATRCNT        IFEQ      2
     C                   MOVE      PGMLB2        PGMLIB
     C     PGMLIB        IFEQ      NULLS
     C                   MOVE      *BLANKS       PGMLIB
     C                   END
     C                   END

     C                   ADD       1             ATRCNT
     C                   ENDDO

     C                   MOVE      '0'           RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     TAP$UC        BEGSR
      *          ------------------------------------------------
      *          Report to Tape  (UnCompressed to Compressed)
      *          ------------------------------------------------
     C                   Z-ADD     0             #CR               9 0
     C                   Z-ADD     0             #CT               5 0
     C                   Z-ADD     0             #PRECS           11 0
     C                   Z-ADD     0             INRLEN
     C                   Z-ADD     0             IC                3 0
     C                   MOVE      *ZEROS        CP
/2272C                   MOVE      *ZEROS        CPB
     C                   MOVE      'N'           OPTYN             1
     C                   Z-ADD     0             #RR               9 0
     C                   Z-ADD     0             RECCNT            9 0
     C                   Z-ADD     0             @DB               3 0

     C                   MOVEL(P)  'PACKTBL'     FILENM
     C                   EXSR      @OPENF

/2272C     LOCSFP        SETLL     FOLDER
/2272C                   READ      FOLDER                                 90
/2272C                   MOVE      PGTBTF        PGTBTY            1

     C     LOCSFA        SUB       1             RRCNTR
     C     RRCNTR        SETLL     FOLDER
     C                   SUB       1             RRCNTR

     C     RRCNTR        DOUEQ     LOCSFP

     C                   ADD       1             RRCNTR
     C     RRCNTR        IFEQ      LOCSFP
     C                   LEAVE
     C                   END

     C                   READ      FOLDER                                 90
     C   90              LEAVE

     C     RECCNT        IFEQ      1
     C                   MOVEL     PGM           PGMOPF
     C                   MOVEL     PGMLB1        PGMLIB
     C                   END

     C     RECCNT        IFEQ      2
     C                   MOVE      PGMLB2        PGMLIB
     C     PGMLIB        IFEQ      NULLS
     C                   MOVE      *BLANKS       PGMLIB
     C                   END
     C                   END

     C     RECCNT        IFLT      14
     C                   ADD       1             RECCNT
     C                   EXSR      OUDATA
     C                   ITER
     C                   END

     C                   ADD       1             #RR
     C     BATCH         CASEQ     'N'           STATS
     C                   ENDCS

     C                   ADD       256           INRLEN
     C                   ADD       1             IC
     C                   MOVE      DATA          IPK(IC)
     C     IC            CASEQ     128           PACK
     C                   ENDCS

     C                   ENDDO


     C     IC            CASGT     0             PACK
     C                   ENDCS

     C     PGTBTY        IFEQ      ' '
     C     CP(1)         CASGT     0             PKWTR
     C                   ENDCS
     C                   ELSE
     C     CPB(1)        CASGT     0             PKWTR
     C                   ENDCS
     C                   ENDIF

     C     1             ADD       RECCNT        SAVSFP

     C     RECTYP        DOUEQ     '0'
     C                   READ      FOLDER                                 90
     C     *IN90         IFEQ      *ON
     C     RECTYP        OREQ      '0'
     C                   LEAVE
     C                   END
     C                   ADD       1             RECCNT
     C                   EXSR      OUDATA
     C                   ENDDO

     C     1             ADD       RECCNT        SAVSFC
     C     1             CHAIN     PACKTBL                            90
/2272C     '4'           CAT       CPTABT:0      OUTDTA          256
     C                   ADD       1             RECCNT
     C                   EXSR      OUTRPT
     C     #PKREC        SUB       1             #C               11 0
     C     #C            IFGT      0
     C                   DO        #C
     C                   READ      PACKTBL                                90
/2272C     '4'           CAT       CPTABT:0      OUTDTA
     C                   ADD       1             RECCNT
     C                   EXSR      OUTRPT
     C                   ENDDO
     C                   END

     C                   Z-ADD     2             SAVSFA
     C                   Z-ADD     15            SAVSFD
     C                   Z-ADD     RECCNT        SAVSFE
     C                   Z-ADD     #RR           SAVREC
     C                   MOVEL     'Pack''d '    SAVVER
     C                   MOVE      'Ver.1'       SAVVER
     C                   MOVE      '1'           SAVPK

     C     BKREC         IFNE      'Y'
     C     1             CHAIN     REPSAV                             90
     C                   EXCEPT    CHGF
     C                   END

     C                   MOVE      '0'           RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     TAP$CC        BEGSR
      *          ------------------------------------------
      *          Report to Tape  (Compressed to Compressed)
      *          ------------------------------------------
     C                   MOVE      ' '           DONE
     C     LOCSFA        SUB       1             RRCNTR
     C     RRCNTR        SETLL     FOLDER
     C                   SUB       1             RRCNTR

     C     RRCNTR        DOUGE     LOCSFC
     C     RECTYP        ANDEQ     '0'

     C                   READ      FOLDER                                 90
     C   90              LEAVE
     C                   ADD       1             RRCNTR
     C     RRCNTR        IFGE      LOCSFC
     C     RECTYP        ANDEQ     '0'
     C                   LEAVE
     C                   END

     C     DONE          IFNE      'D'
     C                   MOVE      'D'           DONE
     C     OUTSFA        SUB       2             LOCOFF
     C     OUTSFE        SUB       LOCOFF        SAVSFE
     C     OUTSFA        SUB       LOCOFF        SAVSFA
     C     OUTSFD        SUB       LOCOFF        SAVSFD
     C     OUTSFP        SUB       LOCOFF        SAVSFP
     C     OUTSFC        SUB       LOCOFF        SAVSFC
     C                   Z-ADD     OUTREC        SAVREC
     C                   MOVEL     'Pack''d '    SAVVER
     C                   MOVE      'Ver.1'       SAVVER
     C                   MOVE      '1'           SAVPK
     C                   Z-ADD     0             ATRCNT
     C                   SETON                                        55
     C                   END

     C                   EXSR      OUDATA
     C                   SETOFF                                       55

     C     BATCH         CASEQ     'N'           STATS
     C                   ENDCS

     C     ATRCNT        IFEQ      1
     C                   MOVEL     PGM           PGMOPF
     C                   MOVEL     PGMLB1        PGMLIB
     C                   END

     C     ATRCNT        IFEQ      2
     C                   MOVE      PGMLB2        PGMLIB
     C     PGMLIB        IFEQ      NULLS
     C                   MOVE      *BLANKS       PGMLIB
     C                   END
     C                   END

     C                   ADD       1             ATRCNT
     C                   ENDDO

     C                   MOVE      '0'           RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPT$UU        BEGSR
      *          ------------------------------------------------
      *          Report to Optical (UnCompressed to UnCompressed)
      *          ------------------------------------------------
     C                   MOVE      ' '           DONE
     C                   Z-ADD     0             ORN               9 0
     C     LOCSFA        SUB       1             RRCNTR
     C     RRCNTR        SETLL     FOLDER
     C                   SUB       1             RRCNTR

     C     RRCNTR        DOUGE     LOCSFP
     C     RECTYP        ANDEQ     '0'

     C                   READ      FOLDER                                 90
     C     BATCH         CASEQ     'N'           STATS
     C                   ENDCS

     C     *IN90         IFEQ      *ON
     C     ARYBYT        IFGT      0
     C                   MOVE      *ON           *IN10
     C                   EXSR      CRTOPT
     C                   END
     C                   LEAVE
     C                   END

     C                   ADD       1             RRCNTR
     C     RRCNTR        IFGE      LOCSFP
     C     RECTYP        ANDEQ     '0'

     C     ARYBYT        IFGT      0
     C                   MOVE      *ON           *IN90
     C                   MOVE      *ON           *IN10
     C                   EXSR      CRTOPT
     C                   END
     C                   LEAVE
     C                   END

     C     DONE          IFNE      'D'
     C                   MOVE      'D'           DONE
     C     OUTSFA        SUB       2             LOCOFF
     C     OUTSFE        SUB       LOCOFF        SAVSFE
     C     OUTSFA        SUB       LOCOFF        SAVSFA
     C     OUTSFD        SUB       LOCOFF        SAVSFD
     C     OUTSFP        SUB       LOCOFF        SAVSFP
     C                   Z-ADD     0             SAVSFC
     C                   Z-ADD     0             SAVREC
     C                   MOVE      *BLANKS       SAVVER
     C                   MOVE      *BLANKS       SAVPK
     C                   Z-ADD     SAVSFA        OPTSFA
     C                   Z-ADD     SAVSFD        OPTSFD
     C                   Z-ADD     SAVSFP        OPTSFP
     C                   Z-ADD     SAVSFC        OPTSFC
     C                   Z-ADD     SAVSFE        OPTSFE
     C                   Z-ADD     SAVREC        OPTREC
     C                   Z-ADD     0             ATRCNT
     C                   END

     C                   ADD       1             ORN
     C                   MOVE      DATA          OUTDTA
     C                   EXSR      OUTOPT

     C     ATRCNT        IFEQ      1
     C                   MOVEL     PGM           PGMOPF
     C                   MOVEL     PGMLB1        PGMLIB
     C                   END

     C     ATRCNT        IFEQ      2
     C                   MOVE      PGMLB2        PGMLIB
     C     PGMLIB        IFEQ      NULLS
     C                   MOVE      *BLANKS       PGMLIB
     C                   END
     C                   END

     C                   ADD       1             ATRCNT
     C                   ENDDO

     C                   MOVE      '0'           RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPT$UC        BEGSR
      *          ----------------------------------------------
      *          Report to Optical (UnCompressed to Compressed)
      *          ----------------------------------------------
     C                   MOVE      ' '           DONE
     C                   MOVE      'Y'           PACKIT            1
     C                   Z-ADD     0             #CR
     C                   Z-ADD     0             #CT
     C                   Z-ADD     0             #PKREC           11 0
     C                   MOVE      *ZEROS        CP
/2272C                   MOVE      *ZEROS        CPB

     C                   Z-ADD     0             INRLEN
     C                   Z-ADD     0             IC                3 0

     C                   MOVE      'Y'           OPTYN             1
     C                   Z-ADD     0             #RR
     C                   Z-ADD     0             RECCNT
     C                   Z-ADD     0             @DB               3 0
     C                   Z-ADD     0             ORN

     C                   MOVEL(P)  'PACKTBL'     FILENM
     C                   EXSR      @OPENF

     C     LOCSFA        SUB       1             RRCNTR
     C     RRCNTR        SETLL     FOLDER
     C                   SUB       1             RRCNTR

     C     RRCNTR        DOUEQ     LOCSFP

     C                   ADD       1             RRCNTR
     C     RRCNTR        IFEQ      LOCSFP
     C                   LEAVE
     C                   END
     C                   READ      FOLDER                                 90
     C   90              LEAVE

     C     DONE          IFNE      'D'
     C                   MOVE      'D'           DONE
     C     OUTSFA        SUB       2             LOCOFF
     C     OUTSFE        SUB       LOCOFF        SAVSFE
     C     OUTSFA        SUB       LOCOFF        SAVSFA
     C     OUTSFD        SUB       LOCOFF        SAVSFD
     C     OUTSFP        SUB       LOCOFF        SAVSFP
     C                   Z-ADD     0             SAVSFC
     C                   Z-ADD     0             SAVREC
     C                   MOVEL     'Pack''d '    SAVVER
     C                   MOVE      'Ver.1'       SAVVER
     C                   MOVE      '1'           SAVPK
     C                   Z-ADD     SAVSFA        OPTSFA
     C                   Z-ADD     SAVSFD        OPTSFD
     C                   Z-ADD     SAVSFP        OPTSFP
     C                   Z-ADD     SAVSFC        OPTSFC
     C                   Z-ADD     SAVSFE        OPTSFE
     C                   Z-ADD     SAVREC        OPTREC
     C                   MOVE      DATA          SAVHDR          256
     C                   END

     C     RECCNT        IFEQ      1
     C                   MOVEL     PGM           PGMOPF
     C                   MOVEL     PGMLB1        PGMLIB
     C                   END

     C     RECCNT        IFEQ      2
     C                   MOVE      PGMLB2        PGMLIB
     C     PGMLIB        IFEQ      NULLS
     C                   MOVE      *BLANKS       PGMLIB
     C                   END
     C                   END

     C     RECCNT        IFLT      14
     C                   ADD       1             RECCNT
     C                   ADD       1             ORN
     C                   MOVE      DATA          OUTDTA
     C                   EXSR      OUTOPT
     C                   ITER
     C                   END

     C                   ADD       1             #RR
     C                   ADD       1             ORN
     C     BATCH         CASEQ     'N'           STATS
     C                   ENDCS

     C                   ADD       256           INRLEN
     C                   ADD       1             IC
     C                   MOVE      DATA          IPK(IC)
     C     IC            CASEQ     128           PACK
     C                   ENDCS

     C                   ENDDO

     C     IC            CASGT     0             PACK
     C                   ENDCS

     C     CP(1)         CASGT     0             PKWTR
     C                   ENDCS

     C     1             ADD       RECCNT        SAVSFP

     C     RECTYP        DOUEQ     '0'
     C                   READ      FOLDER                                 90
     C     *IN90         IFEQ      *ON
     C     RECTYP        OREQ      '0'
     C                   LEAVE
     C                   END

     C                   ADD       1             ORN
     C                   ADD       1             RECCNT
     C                   MOVE      DATA          OUTDTA
     C                   EXSR      OUTOPT
     C                   ENDDO

     C     1             ADD       RECCNT        SAVSFC

/8911c                   clear                   outdta

     C     1             CHAIN     PACKTBL                            90
     C     '4'           CAT       CPTAB:0       OUTDTA
     C                   ADD       1             ORN
     C                   ADD       1             RECCNT
     C                   EXSR      OUTOPT
     C     #PKREC        SUB       1             #C
     C     #C            IFGT      0
     C                   DO        #C
     C                   READ      PACKTBL                                90
     C     '4'           CAT       CPTAB:0       OUTDTA
     C                   ADD       1             ORN
     C                   ADD       1             RECCNT
     C                   EXSR      OUTOPT
     C                   ENDDO
     C                   END
/8911
/8911C                   Z-ADD     2             SAVSFA
/8911C                   Z-ADD     15            SAVSFD
/8911C                   Z-ADD     RECCNT        SAVSFE
/8911C                   Z-ADD     #RR           SAVREC
/8911C                   MOVEL     'Pack''d '    SAVVER
/8911C                   MOVE      'Ver.1'       SAVVER
/8911C                   MOVE      '1'           SAVPK
/8911
/8911C                   Z-ADD     SAVSFA        OPTSFA
/8911C                   Z-ADD     SAVSFD        OPTSFD
/8911C                   Z-ADD     SAVSFP        OPTSFP
/8911C                   Z-ADD     SAVSFC        OPTSFC
/8911C                   Z-ADD     SAVSFE        OPTSFE
/8911C                   Z-ADD     SAVREC        OPTREC
/8911
/8911C                   MOVEA     SAVHDR        OPTR
/8911C                   Z-ADD     105           Z                 3 0
/8911C                   MOVEA     CSFA          OPTR(Z)
/8911C                   Z-ADD     109           Z
/8911C                   MOVEA     CSFD          OPTR(Z)
/8911C                   Z-ADD     113           Z
/8911C                   MOVEA     CSFP          OPTR(Z)
/8911C                   Z-ADD     182           Z
/8911C                   MOVEA     CSFE          OPTR(Z)
/8911C                   Z-ADD     186           Z
/8911C                   MOVEA     CSFC          OPTR(Z)
/8911C                   Z-ADD     190           Z
/8911C                   MOVEA     CREC          OPTR(Z)
/8911C                   Z-ADD     194           Z
/8911C                   MOVEA     SAVVER        OPTR(Z)
/8911C                   MOVEA     OPTR          OPT(1)
/8911
/8911C     ARYBYT        IFGT      0
/8911C                   MOVE      *OFF          *IN90
/8911C                   EXSR      CRTOPT
/8911C                   END
      *                                                    ------------
     C                   EXSR      CLSOPT

     C                   MOVE      *ON           *IN10
     C                   MOVE      '0'           RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPT$CC        BEGSR
      *          -------------------------------------------------
      *          Copy Report to Optical (Compressed to Compressed)
      *          -------------------------------------------------
     C                   MOVE      ' '           DONE
     C                   Z-ADD     0             ORN
     C     LOCSFA        SUB       1             RRCNTR
     C     RRCNTR        SETLL     FOLDER
     C                   SUB       1             RRCNTR

     C     RRCNTR        DOUGE     LOCSFC
     C     RECTYP        ANDEQ     '0'

     C                   READ      FOLDER                                 90
     C     BATCH         CASEQ     'N'           STATS
     C                   ENDCS

     C     *IN90         IFEQ      *ON
     C     ARYBYT        IFGT      0
     C                   MOVE      *ON           *IN10
     C                   EXSR      CRTOPT
     C                   END
     C                   LEAVE
     C                   END
     C                   ADD       1             RRCNTR
     C     RRCNTR        IFGE      LOCSFC
     C     RECTYP        ANDEQ     '0'
     C     ARYBYT        IFGT      0
     C                   MOVE      *ON           *IN90
     C                   MOVE      *ON           *IN10
     C                   EXSR      CRTOPT
     C                   END
     C                   LEAVE
     C                   END

     C     DONE          IFNE      'D'
     C                   MOVE      'D'           DONE
     C     OUTSFA        SUB       2             LOCOFF
     C     OUTSFE        SUB       LOCOFF        SAVSFE
     C     OUTSFA        SUB       LOCOFF        SAVSFA
     C     OUTSFD        SUB       LOCOFF        SAVSFD
     C     OUTSFP        SUB       LOCOFF        SAVSFP
     C     OUTSFC        SUB       LOCOFF        SAVSFC
     C                   Z-ADD     OUTREC        SAVREC
     C                   MOVEL     'Pack''d '    SAVVER
     C                   MOVE      'Ver.1'       SAVVER
     C                   MOVE      '1'           SAVPK
     C                   Z-ADD     SAVSFA        OPTSFA
     C                   Z-ADD     SAVSFD        OPTSFD
     C                   Z-ADD     SAVSFP        OPTSFP
     C                   Z-ADD     SAVSFC        OPTSFC
     C                   Z-ADD     SAVSFE        OPTSFE
     C                   Z-ADD     SAVREC        OPTREC
     C                   Z-ADD     0             ATRCNT
     C                   END

     C                   ADD       1             ORN
     C                   MOVE      DATA          OUTDTA
     C                   EXSR      OUTOPT

     C     ATRCNT        IFEQ      1
     C                   MOVEL     PGM           PGMOPF
     C                   MOVEL     PGMLB1        PGMLIB
     C                   END

     C     ATRCNT        IFEQ      2
     C                   MOVE      PGMLB2        PGMLIB
     C     PGMLIB        IFEQ      NULLS
     C                   MOVE      *BLANKS       PGMLIB
     C                   END
     C                   END

     C                   ADD       1             ATRCNT
     C                   ENDDO

     C                   MOVE      '0'           RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PACK          BEGSR
      *          -----------------------------------------
      *          Pack input records, buffered at 32K bytes
      *          -----------------------------------------
      *                                                    Compress
     C                   CALL      'SPYPACK'
     C                   PARM                    IPK
     C                   PARM                    INRLEN
     C                   PARM      *BLANKS       OPK
     C                   PARM      0             PAKLEN

     C     PAKLEN        CASLE     0             ERRCPS
     C                   ENDCS

     C     PAKLEN        DIV       256           PKREC             3 0
     C                   MVR                     REM               3 0
     C     REM           IFGT      0
     C                   ADD       1             PKREC
     C                   END

     C                   ADD       1             #CT

     C                   DO        PKREC         OC                3 0
     C                   ADD       1             #CR

     C     OC            IFEQ      1
/2272C     PGTBTY        IFEQ      ' '
     C                   Z-ADD     #CR           CP(#CT)
     C                   ELSE
     C                   Z-ADD     #CR           CPB(#CT)
     C                   ENDIF
     C     #CT           IFEQ      63
     C                   EXSR      PKWTR
     C                   Z-ADD     0             #CT
     C                   END
     C                   END

     C                   MOVE      OPK(OC)       OUTDTA
     C                   ADD       1             RECCNT
      *                                                    record to:
     C     OPTYN         CASEQ     'Y'           OUTOPT
     C                   CAS                     OUTRPT
     C                   ENDCS

     C                   ENDDO

     C                   MOVE      *BLANK        IPK
     C                   Z-ADD     0             IC
     C                   Z-ADD     0             INRLEN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PKWTR         BEGSR
      *          -----------------------------------------
      *          Write compressed report record to PACKTBL
      *          -----------------------------------------
/2272
     C     PGTBTY        IFEQ      ' '
     C                   MOVE      CP            PK
     C                   ELSE
     C                   MOVE      CPB           PKB
     C                   ENDIF

     C                   MOVE      *ZEROS        CP
/2272C                   MOVE      *ZEROS        CPB
     C                   ADD       1             #PKREC
     C                   EXCEPT    PAKTBL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETBAR        BEGSR
      *          Set up status bar vars

     C                   MOVE      *BLANKS       FLSIZ
     C     @INPUT        IFEQ      'I'
     C     IDBEND        SUB       IDBBGN        BGREC             9 0
     C     BGREC         MULT      1024          @SZ               9 0
     C                   ELSE
     C     LOCSFP        SUB       LOCSFD        BGREC             9 0
     C     BGREC         MULT      256           @SZ               9 0
     C                   END
     C                   Z-ADD     @SZ           @FLSIZ            9 0
     C     @FLSIZ        DIV       48            @BVAL             9 0
     C     @SZ           DIV       1000000       @MIL              3 0
     C     @MIL          MULT      1000000       @SUB              9 0
     C                   SUB       @SUB          @SZ
     C     @SZ           DIV       1000          @THOU             3 0
     C     @THOU         MULT      1000          @SUB
     C     @SZ           SUB       @SUB          @HUND             3 0
     C     @MIL          IFGT      0
     C                   MOVE      @MIL          @ML
     C     @MIL          IFLT      10
     C                   MOVEL     '  '          @ML
     C                   END
     C     @MIL          IFLT      100
     C                   MOVEL     ' '           @ML
     C                   END
     C                   MOVE      ','           @CML
     C                   MOVE      @THOU         @TH
     C                   MOVE      ','           @CTH
     C                   MOVE      @HUND         @HU
     C                   GOTO      @ESIZ

     C                   END

     C     @THOU         IFGT      0
     C                   MOVE      @THOU         @TH
     C     @THOU         IFLT      10
     C                   MOVEL     '  '          @TH
     C                   END
     C     @THOU         IFLT      100
     C                   MOVEL     ' '           @TH
     C                   END
     C                   MOVE      ','           @CTH
     C                   MOVE      @HUND         @HU
     C                   GOTO      @ESIZ

     C                   END

     C                   MOVE      @HUND         @HU
     C     @HUND         IFLT      10
     C                   MOVEL     '  '          @HU
     C                   ELSE
     C     @HUND         IFLT      100
     C                   MOVEL     ' '           @HU
     C                   END
     C                   END

     C     @ESIZ         ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     STATS         BEGSR
      *          Status Bar reporting

     C     @INPUT        IFEQ      'I'
     C                   ADD       1024          @WBYTE            9 0
     C                   ELSE
     C                   ADD       256           @WBYTE
     C                   END
     C     @WBYTE        DIV       @BVAL         @B                2 0

     C     @B            IFGT      48
     C                   Z-ADD     48            @B
     C                   ELSE
     C     @B            IFLT      1
     C                   Z-ADD     1             @B
     C                   END
     C                   END

     C     @B            IFGE      @DB
     C                   MOVE      *BLANKS       STSBAR
     C                   MOVE      X'23'         @BR(1)
     C                   MOVE      X'20'         @BR(@B)
     C                   WRITE     STATUS
     C                   ADD       4             @DB
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SAVOBJ        BEGSR
      *          Call CL pgm to write dasd SAV file to tape.

     C     @INPUT        IFEQ      'R'
     C                   CLOSE     REPSAV
     C                   ELSE
     C                   CLOSE     IMGSAV
     C                   END

     C                   CALL      'SPYSAVCL'
     C                   PARM                    OFSNAM
     C                   PARM                    SAVLIB
     C                   PARM                    EVOL
     C                   PARM                    evolume
     C                   PARM                    EDEV
     C                   PARM                    TAPSEQ
     C                   PARM                    RETRN             1
      *              Note: TAPSEQ is ignored by the receiving programs.
      *                    File is always written to '*END' of tape.

      * If last file was written, process ENDOPT from SYSDFT
     C     LSTRPT        IFEQ      'Y'
     C     ENDOPT        ANDNE     '*LEAVE'
     C                   MOVEL(P)  ENDOPT        ENDOP
     C     ENDOP         IFNE      '*REWIND'
     C     ENDOP         ANDNE     '*UNLOAD'
     C                   MOVEL(P)  '*REWIND'     ENDOP
     C                   END
     C                   MOVEL(P)  CMD(37)       CMDLIN
     C                   CAT       EDEV:0        CMDLIN
/4614C                   CAT       CMD(38):0     CMDLIN
     C                   CAT       ENDOP:0       CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLCMD
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPDDIR        BEGSR
      *          -----------------------------------------------------
      *          Update DIR file to reflect offline status. Log trans.
      *          -----------------------------------------------------
      *                                                    -----------
     C     @INPUT        IFEQ      'R'
      *                                                    -----------
     C     MRPTKY        CHAIN     RPTDIR                             89
     C     *IN89         IFEQ      *OFF

     C     EDEV          IFEQ      OPTICL
     C                   MOVEL     '2'           REPLOC
     C                   MOVEL     SAVEVL        OFRVOL
     C                   ELSE
     C                   MOVEL     '1'           REPLOC
     C                   MOVEL     EVOL          OFRVOL
     C                   MOVE      ' '           OFRSYS
     C                   MOVE      ' '           OFRTYP
     C     BRMSYN        IFEQ      'Y'
     C                   MOVEL(P)  'BRMS'        OFRVOL
     C                   MOVE      'B'           OFRSYS
     C                   END
     C     BKREC         IFEQ      'Y'
     C                   MOVE      'R'           OFRTYP
     C                   MOVEL     TAPSEQ        OFRSEQ
     C                   ELSE
     C                   MOVE      '0000'        OFRSEQ
     C                   END
     C                   END

     C                   Z-ADD     SAVSFA        LOCSFA
     C                   Z-ADD     SAVSFD        LOCSFD
     C                   Z-ADD     SAVSFP        LOCSFP
     C                   Z-ADD     SAVSFC        LOCSFC
     C                   MOVE      SAVPK         PKVER
     C                   Z-ADD     CYMD          OFRDAT
     C                   MOVEL     OFSNAM        OFRNAM

     C                   UPDATE    RPTDIR

     C                   MOVE      RTYPID        DLREPT
     C                   MOVE      REPIND        DLREP
     C                   Z-ADD     TOTPAG        DLTPGS
     C                   END
      *                                                    ------------
     C                   ELSE
     C     EJOBNM        CHAIN     IMGDIR                             89
     C     *IN89         IFEQ      *OFF

     C     EDEV          IFNE      OPTICL
     C                   MOVEL     '1'           IDILOC
     C                   MOVEL     EVOL          IDTVOL
     C                   MOVE      ' '           IDTSYS
     C                   MOVE      ' '           IDTTYP
     C     BRMSYN        IFEQ      'Y'
     C                   MOVEL(P)  'BRMS'        IDTVOL
     C                   MOVE      'B'           IDTSYS
     C                   END
     C     BKREC         IFEQ      'Y'
     C                   MOVEL     TAPSEQ        IDTSEQ
     C                   MOVE      'R'           IDTTYP
     C                   ELSE
     C                   MOVE      '0000'        IDTSEQ
     C                   END
     C                   END

     C                   Z-ADD     CYMD          IDTDTE
     C                   MOVEL     OFSNAM        IDTFIL

     C                   UPDATE    IMGDIR
     C                   CLOSE     IMGFIL

     C                   MOVE      *BLANKS       OP1507
     C                   CALL      'MAG1507'     PL1507
     C     PL1507        PLIST
     C                   PARM      IDPFIL        FL1507           10
     C                   PARM      IDFLIB        LB1507           10
     C                   PARM                    OP1507            4
     C                   PARM                    OPRTN             2

     C                   MOVE      EFILNM        DLREPT
     C                   MOVE      EJOBNM        DLREP
     C                   Z-ADD     IDICNT        DLTPGS

     C                   END
     C                   END

     C     *IN89         IFEQ      *OFF
     C                   CALL      'MAG901'                             81
     C                   PARM                    LOGRTN            1
     C                   PARM      *BLANK        DLSUB            10
     C                   PARM                    DLREPT           10
     C                   PARM      *BLANK        DLSEG            10
     C                   PARM                    DLREP            10
     C                   PARM      *BLANK        DLBNDL           10
     C                   PARM      'S'           DLTYPE            1
     C                   PARM                    DLTPGS            9 0
     C                   PARM      'SPYBAK1'     DLPROG           10
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPNAFP        BEGSR
      *          -------------------------------
      *          OPEN AFP FOLDER AND CHECK IT
      *          -------------------------------

     C     MFLDKY        CHAIN     FLDDIR                             51
     C     MFLDKY        KLIST
     C                   KFLD                    EFLDR            10
     C                   KFLD                    EFLDRL           10

     C     *IN51         CABEQ     *ON           ENDAFP
     C     APFNAM        CABEQ     *BLANK        ENDAFP                   51

/5400c                   CLOSE     RAPFDBF
/    c                   eval      CMDLIN = 'OVRDBF FILE(RAPFDBF) +
/    c                                       TOFILE('+%trim(efldrl)+'/'+
/    c                                                %trim(apfnam)+')'
     c                   CALL      'QCMDEXC'     PLCMD
     c                   OPEN      RAPFDBF                              51
/    c                   eval      CMDLIN = 'DLTOVR FILE(RAPFDBF)'
/    c                   CALL      'QCMDEXC'     PLCMD
     C     *IN51         CABEQ     *ON           ENDAFP
     C     REPIND        SETLL     RAPFDBF                                51
     c                   eval      *in51 = not *in51

     C     ENDAFP        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     AFPTAP        BEGSR
      *          -------------------------------
      *          Copy AFP data and PgTbl to tape
      *          -------------------------------

     C                   EXSR      OPNAFP
     C     *IN51         CABEQ     *ON           ENDAPT

/5917c                   eval      OUTDTA = '*ADTA16V02'
     C                   EXSR      OUTRPT
     C     REPIND        READE     APFDBF                                 51
     C     *IN51         DOWEQ     *OFF

      *          For each APFDBF rec, write sixteen 256 byte recs.
     C                   Z-ADD     1             X                 5 0
     C                   DO        16            #OUREC            3 0
     C     #OUREC        IFEQ      1
/5917c                   eval      outdta = repind
/    c                   eval      %subst(outdta:11:4) = apfsex
/    c                   eval      %subst(outdta:15:242) = apfdta
     C                   ADD       242           X
     C                   ELSE
     C                   MOVEA(P)  ADVD(X)       OUTDTA
     C                   ADD       256           X
     C                   END
     C                   EXSR      OUTRPT
     C                   ENDDO

     C     REPIND        READE     APFDBF                                 51
     C                   ENDDO
      * Delete
     C     *IN51         DOUEQ     *ON
     C     REPIND        DELETE    APFDBF                             51
     C                   ENDDO
/5400c                   CLOSE     RAPFDBF
      *---------
      * Page Tbl
      *---------
/5400c                   CLOSE     RAPFDBFP
     C                   MOVE      APFNAM        PGTNAM           10
     C                   MOVEL     'AP'          PGTNAM
/    c                   eval      CMDLIN = 'OVRDBF FILE(RAPFDBFP) +
/    c                                       TOFILE('+%trim(efldrl)+'/'+
/    c                                                %trim(pgtnam)+')'
     c                   CALL      'QCMDEXC'     PLCMD
     C                   OPEN      RAPFDBFP                             51
/    c                   eval      CMDLIN = 'DLTOVR FILE(RAPFDBFP)'
     c                   CALL      'QCMDEXC'     PLCMD
     C     *IN51         CABEQ     *ON           ENDAPT
     C     REPIND        SETLL     RAPFDBFP                               51
     C     *IN51         CABEQ     *OFF          ENDAPT

/5917c                   eval      OUTDTA = '*APAG02V02'
     C                   EXSR      OUTRPT
     C     REPIND        READE     APGDBF                                 51
     C     *IN51         DOWEQ     *OFF

      *          For each APFDBFP rec, write two 256 byte recs.
     C                   Z-ADD     1             X
     C                   DO        2             #OUREC
     C     #OUREC        IFEQ      1
/5917c                   eval      outdta = apgrep
/    c                   eval      %subst(outdta:11:4) = apgsex
/    c                   eval      %subst(outdta:15:1) = apgtyp
/    c                   eval      %subst(outdta:16:241) = apgtbl
     C                   ADD       241           X
     C                   ELSE
     C                   MOVEA(P)  ADVP(X)       OUTDTA
     C                   ADD       256           X
     C                   END
     C                   EXSR      OUTRPT
     C                   ENDDO

     C     REPIND        READE     APGDBF                                 51
     C                   ENDDO
      * Delete
     C     *IN51         DOUEQ     *ON
     C     APGREP        DELETE    APGDBF                             51
     C                   ENDDO
/5400c                   CLOSE     RAPFDBFP

     C     ENDAPT        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     AFPOPT        BEGSR
      *          ------------------------------------------------
      *          Copy AFP data and PGtbl to optical (Call Mag808)
      *          ------------------------------------------------

     C                   EXSR      OPNAFP
     C     *IN51         CABEQ     *ON           ENDAPO

     C                   CLOSE     RAPFDBF

     C                   CALL      'MAG808'
     C                   PARM                    APFNAM           10
     C                   PARM      REPIND        APFREP           10
     C                   PARM                    EFLDR            10
     C                   PARM                    EFLDRL           10
     C                   PARM                    EDRV             15
     C                   PARM                    evolume          12
     C                   PARM      OFSNAM        EFILE            10
     C                   PARM      'SPYBAK1'     CALLER           10
/8437C                   PARM      '0'           retrn             1

     C     ENDAPO        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CVTSDT        BEGSR
      *          Convert  system date to CYYMMDD (Century code+YYMMDD)
      *             Ex : 19930511   ->   0930511
      *                  20000511   =->  1000511

     C                   CALL      'MAG1047'
     C                   PARM                    YMDNUM            9 0
     C                   PARM                    YMD               8
     C                   MOVE      YMD           YYMMDD
     C                   Z-ADD     YMMDD         CYMD              9 0
     C     YY            IFEQ      20
     C                   ADD       1000000       CYMD
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OUTOPT        BEGSR
      *          Fill optical stream files and write to optical

     C                   SELECT
      *          Opt Rec No
     C     ORN           WHENEQ    1
     C                   EXSR      OPTNAM
      *        Calculate required space for optical allocation
     c                   eval      M90Aloc=outsfp-outsfd
     c                   if        packit='Y'
     c                   mult      128           m90aloc
     c                   else
     c                   mult      256           m90aloc
     c                   endif
     c                   eval      m90aloc = m90aloc +
     c                             ((outsfe - outsfp + 15) * 256)
      *  ALLWAYS TAKE MULTIPLE OF 16 for the max file size
     c                   clear                   maxfilsiz        13 0
     c                   eval      maxfilsiz=m90aloc/101376000
     c                   eval      maxfilsiz=maxfilsiz/16+1
     c                   eval      maxfilsiz=maxfilsiz*16384000
     c                   move      maxfilsiz     M90FilSiz

     C                   MOVE      *BLANKS       HDR
     C                   MOVEA     OUTDTA        OPTR
     C                   Z-ADD     105           Z
     C                   MOVEA     CSFA          OPTR(Z)
     C                   Z-ADD     109           Z
     C                   MOVEA     CSFD          OPTR(Z)
     C                   Z-ADD     113           Z
     C                   MOVEA     CSFP          OPTR(Z)
     C                   Z-ADD     182           Z
     C                   MOVEA     CSFE          OPTR(Z)
     C                   Z-ADD     186           Z
     C                   MOVEA     CSFC          OPTR(Z)
     C                   Z-ADD     190           Z
     C                   MOVEA     CREC          OPTR(Z)
     C                   Z-ADD     194           Z
     C                   MOVEA     SAVVER        OPTR(Z)
     C                   MOVEA     OPTR          HDR(1)
      *                                                    Variables
     C                   Z-ADD     0             ZZ                3 0
     C                   MOVE      *BLANKS       OPT
     C                   Z-ADD     0             @SF               2 0
     C                   Z-ADD     0             ARYBYT            9 0
/6531C                   Z-ADD     0             FYLBYT           15 0

     C     ORN           WHENGE    2
     C     ORN           ANDLE     14
     C                   Z-ADD     ORN           @O               10 0
     C                   MOVEA     OUTDTA        HDR(@O)

     C     ORN           WHENGT    14
     C     ORN           ANDLT     OPTSFP
     C                   ADD       1             ZZ
     C                   MOVEA     OUTDTA        OPT(ZZ)
     C                   ADD       256           ARYBYT
     C                   ADD       256           FYLBYT

     C     ARYBYT        CASEQ     131072        CRTOPT
     C                   ENDCS

     C     ORN           WHENGE    OPTSFP

     C     ORN           IFEQ      OPTSFP
     C     ARYBYT        IFGT      0
     C                   MOVE      *ON           *IN90
     C                   EXSR      CRTOPT
     C                   MOVE      *OFF          *IN90
     C                   END

     C     FYLBYT        IFNE      0
     C                   EXSR      CLSOPT
     C                   Z-ADD     0             FYLBYT
     C                   END

     C                   Z-ADD     14            @O
     C                   MOVE      HDR           OPT
     C                   Z-SUB     1             @SF
     C                   Z-ADD     3584          ARYBYT
     C                   Z-ADD     3584          FYLBYT
     C                   MOVE      *OFF          *IN90
     C                   END

     C                   ADD       1             @O
     C                   MOVE      OUTDTA        OPT(@O)
     C                   ADD       256           ARYBYT
     C                   ADD       256           FYLBYT

     C     ARYBYT        IFEQ      131072
     C                   EXSR      CRTOPT
     C                   Z-ADD     0             @O
     C                   END

     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPTNAM        BEGSR
      *          Get Optical SPY name for writing report to Optical
     C                   MOVE      '00'          OFSNAM
     C                   MOVE      OFSNAM        FILE10           10
     C                   ENDSR
      ********************************************************************
     C     CRTOPT        BEGSR
      *          Write stream file array (OPT) for reports to optical

     C     FYLBYT        IFLE      131072

     C                   ADD       1             @SF
     C                   MOVE      @SF           @SFC              2
      *                                                    -----------
     C                   MOVEA     @SFC          OPTN(9)
     C                   MOVEA     OPTN          FILE10           10
      *                                                    -----------
     c                   eval      M90dir='/SPYGLASS/'+
     c                                  %trim(efldrl) + '/' +
     c                                  %trim(efldr)
     c                   eval      M90File=file10
     c                   eval      M90Volume =Evolume

     C                   END

     C                   Z-ADD     ARYBYT        M90DtaSiz
     C                   EXSR      WRTOPT
     C                   ADD       M90DtaSiz     SZ
     C                   MOVE      *BLANKS       OPT
     C                   Z-ADD     0             ARYBYT
     C                   Z-ADD     0             ZZ
      *---------------------------------------------
      * Cut off the optical file (later start another)
      * when the size hits 16 megabytes.
      *---------------------------------------------
     C*****FYLBYT        IFEQ      16384000
     C                   IF        *in90
     C                   EXSR      CLSOPT
     C                   Z-ADD     0             FYLBYT
     C                   END

     C                   ENDSR
      ********************************************************************
     C     RM6701        BEGSR
      *          Remove msg Opt6701.
     C                   CALL      'QMHRMVPM'
     C                   PARM      INACT         ALLINA           10
     C                   PARM      0             STKCNT
     C                   PARM      *BLANKS       MSGKY             4
     C                   PARM      '*ALL'        MSGRMV           10
     C                   PARM                    ERRCD
     C                   ENDSR
      ********************************************************************
      *          Write to optical stream file
     C     WRTOPT        BEGSR

     c     pl1090        plist
     C                   parm                    M90Drive         15
     C                   parm                    M90Volume        12
     C                   parm                    M90Aloc          13 0
     C                   parm                    M90Dir           80
     C                   parm                    M90File          10
     C                   parm                    M90FilSiz        13
     C                   parm                    OPT
     C                   parm                    M90DtaSiz         6 0
     C                   parm                    M90ClsPgm         1
     C                   parm                    M90RtnCde         1

     c                   z-add     M90DtaSiz     BufferLen         6 0
     c                   call      'MAG1090'     pl1090                 50
      *        Save return volume
     c                   if        m1090opn=' '
     C                   move      m90volume     VOL              12
     C                   move      m90volume     SAVEVL           12
     C                   move      m90volume     Volume           12
     c                   move      '1'           m1090opn          1
     c                   add       1             of#               3 0
     c                   endif

     c                   if        M90RtnCde<>'0' or
     c                             *in50
/9274 * put message into job log
/9274c                   eval      ErrMsgDta = 'MAG1090 ended abnormally. ' +
/9274c                             'SPYBAK1 will be terminated.'
/9274c                   callp     QMHSndPm('CPF9898':'QCPFMSG   QSYS':
/9274c                                      ErrMsgDta:%len(%trim(ErrMsgDta)):
/9274c                                      '*DIAG':'*':0:
/9274c                                      msgKey:APIerrDS)
     c                   exsr      abend
     c                   endif

      *    Bytes 2 write and bytes written are not the same
     c                   if        M90DtaSiz <> Bufferlen
/9274 * put message into job log
/9274c                   eval      ErrMsgDta = 'MAG1090 bytes written != ' +
/9274c                             'buffer length. SPYBAK1 will be terminated.'
/9274c                   callp     QMHSndPm('CPF9898':'QCPFMSG   QSYS':
/9274c                                      ErrMsgDta:%len(%trim(ErrMsgDta)):
/9274c                                      '*DIAG':'*':0:
/9274c                                      msgKey:APIerrDS)
     c                   exsr      abend
     c                   endif

      *    If filename has changed, write out record to mopttbl
     c                   if        m90file<>lastfile
     c                   exsr      addopttbl
     c                   movel     m90file       lastfile         10
     c                   endif

     C                   ENDSR
      ********************************************************************
      *          Close optical stream file
     C     CLSOPT        BEGSR

     c                   clear                   m90dtasiz
     c                   move      '1'           m90clspgm
     c                   call      'MAG1090'     pl1090                 50
     c                   move      ' '           m90clspgm
      *    Mark as closed
     c                   clear                   m1090opn

     c                   if        m90rtncde<>'0'  or
     c                             *in50
     C                   EXSR      ABEND
     C                   END
     C                   ENDSR
      ********************************************************************
      *    Add record to mopttbl
     c     addopttbl     begsr

     C                   MOVE      M90Volume     OPTVOL
     C                   MOVEL     M90File       OPTFIL
     c                   eval      opmxsz=maxfilsiz/1024000
     c                   move      M90File       f2a               2
     c                   move      f2a           f20               2 0
     c                   z-add     f20           optseq
     c                   eval      optfdr = efldr
     c                   eval      optlib = efldrl
     C                   movea     '00'          OPTN(9)
     C                   MOVEA     OPTN          OPTRNM
     C                   write     OPTRC

     C                   ENDSR
      ********************************************************************
      *          Capture sys program exc errors.  Send msg to outq.
     C     *PSSR         BEGSR
     C                   MOVE      PGMERR        PGMERC            5
     C                   MOVEL     MSGE(1)       @ERCON
     C                   MOVEL     PGMERC        @ERDTA
     C                   MOVEA     SYSERR        @ED(6)
     C                   MOVEA     PGMLIN        @ED(13)
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
/9274
/9274c                   eval      ErrMsgDta = 'Error Id: ' + %trim(SysErr) +
/9274c                             ' Error Data: ' + %trim(SysErrDta)
/9274c                   callp     QMHSndPm('CPF9898':'QCPFMSG   QSYS':
/9274c                                      ErrMsgDta:%size(ErrMsgDta):
/9274c                                      '*DIAG':'*':0:
/9274c                                      msgKey:APIerrDS)
/9274
/9274c     '*PSSR'       dump

     C                   EXSR      ABEND
     C                   ENDSR
      ********************************************************************
      *          Retrieve errors from compression routine
     C     ERRCPS        BEGSR

     C     BATCH         IFEQ      'Y'
     C                   MOVEL     MSGE(13)      @ERCON
     C                   MOVEL     EFILNM        @ERDTA
     C                   MOVEA     EFLDR         @ED(11)
     C                   MOVEA     EFLDRL        @ED(21)
     C                   MOVEA     REPIND        @ED(31)
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   END
     C                   MOVEL     MSGE(8)       @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   EXSR      CLSOPT
     C                   EXSR      ABEND
     C                   ENDSR
      ********************************************************************
     C     ABEND         BEGSR
/9274
/9274 * Close MAG1090 if necessary
/9274c                   if        m1090opn = '1'
/9274c                   clear                   m90dtasiz
/9274c                   move      '1'           m90clspgm
/9274c                   call      'MAG1090'     pl1090                 50
/9274c                   move      ' '           m90clspgm
/9274 *    Mark as closed
/9274c                   clear                   m1090opn
/9274c                   endif
      *          Load RETRN & return
     C                   MOVE      '1'           RETRN
     C                   EXSR      EXIT
     C                   ENDSR
      ********************************************************************
     C     EXIT          BEGSR

     c                   if        retrn = '0'
/5635c                   exsr      BldLogEnt
     c                   endif

      *          Return to caller.
      *          Shut down if interactive or last batch call.
     C     BATCH         IFEQ      'N'
     C     LSTRPT        OREQ      'Y'
     C                   MOVE      *ON           *INLR
     C                   MOVE      'QUIT'        OP1507
/7111c                   eval      idpfil = ' '
     C                   CALL      'MAG1507'     PL1507
     C                   CALL      'GETNUM'
     C                   PARM      'QUIT'        GETOP

     C                   ELSE
     C     @INPUT        IFEQ      'I'
     C                   CLOSE     IMGFIL                               50
     C                   ELSE
     C                   CLOSE     FOLDER
     C                   END
     C                   END

     C                   RETURN
     C                   ENDSR
      ********************************************************************
     C     RTVMSG        BEGSR
      *          Retrieve message text from PSCON
     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80
     C                   MOVE      *BLANKS       @ERDTA
     C                   ENDSR
      ********************************************************************
     C     RTVMS2        BEGSR
      *          Retrieve message text from QSYS/QCPFMSG

     C     'QCPFMSG'     CAT(P)    'QSYS':3      MSGFIL           20
     C                   CALL      'QMHRTVM'                              50
     C                   PARM                    @MSGDT
     C                   PARM      104           MSGL
     C                   PARM      'RTVM0100'    MSGFMT            8
     C                   PARM                    CONDTN
     C                   PARM                    MSGFIL
     C                   PARM                    MSGDTA
     C                   PARM      100           MSGDTL
     C                   PARM      '*YES'        MSGSUB           10
     C                   PARM      '*NO'         MSGCTL           10
     C                   PARM                    RETCD

     C     ERRLEN        ADD       1             #T                3 0
     C                   MOVEA     *BLANKS       @EM(#T)
     C                   MOVEA     @EM           OPTMSG           80
     C                   ENDSR
      ********************************************************************
     C     ERRMSG        BEGSR
      *          Send error message to screen or log it.
     C     BATCH         IFNE      'Y'
     C                   MOVEL(P)  LOG           LOG50            50
     C                   MOVE      *BLANKS       LOG50B           50
     C                   EXFMT     ERROR
     C                   ELSE
     C                   CALL      'LOGMSGQ'                              50
     C                   PARM                    LOG
     C                   END
     C                   ENDSR
      ********************************************************************
     C     OUDATA        BEGSR
      *          Put DATA to file
     C     BKREC         IFEQ      'Y'
     C                   EXCEPT    REPTP2
     C                   ELSE
     C                   EXCEPT    REPDS2
     C                   END
     C                   ENDSR
      ********************************************************************
     C     OUTRPT        BEGSR
      *          Put OUTDTA to file
     C     BKREC         IFEQ      'Y'
     C                   EXCEPT    REPTAP
     C                   ELSE
     C                   EXCEPT    REPDSK
     C                   END
     C                   ENDSR
      *================================================================

     C     PLCMD         PLIST
     C                   PARM                    CMDLIN          300
     C                   PARM                    STRLEN           15 5

     OIMGSAV    EADD         IMGSV
     O                       IMGDTA            1024

     OIMGTAPE   E            IMGTP
     O                       IMGDTA            1024

     OREPTAPE   E            REPTAP
     O                       OUTDTA             256

     O          E            REPTP2
     O                       DATA               256
     O                  55   SAVDS1             116
     O                  55   SAVDS2             205

     OREPSAV    EADD         REPDSK
     O                       OUTDTA             256

     O          EADD         REPDS2
     O                       DATA               256
     O                  55   SAVDS1             116
     O                  55   SAVDS2             205

     O          E            CHGF
     O                       SAVDS1             116
     O                       SAVDS2             205

     OPACKTBL   EADD         PAKTBL
     O                       CPTAB              252
     O                       PGTBTY             253

** CMD   Command line text
OVRDBF                                                                         1

NBRRCDS(2000) SEQONLY(*YES 2000)                                               3
FRCRATIO(2000) SEQONLY(*YES 2000)                                              4
CRTPF SHARE(*NO) FILE(                                                         5
) TEXT('                                                                       6
') OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) RCDLEN(                                 7
DLTF                                                                           8
DLTF QUSRTEMP/                                                                 9
CRTPF SHARE(*NO) FILE(QUSRTEMP/                                               10
) TEXT('SPY Optical temp file') OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) RCDLEN(   11
OVRDBF FILE(PCOPT) SEQONLY(*YES 2000) TOFILE(QUSRTEMP/                        12
OVRDBF FILE(PCOPT2) SEQONLY(*YES 2000) TOFILE(QUSRTEMP/                       13
ALCOBJ OBJ((SPYVCT *PGM *EXCL)) WAIT(300)                                     14
DLCOBJ OBJ((SPYVCT *PGM *EXCL))                                               15
SAVHLDOPTF FROMPATH('                                                         16
') TOPATH('                                                                   17
') RELEASE(*YES)                                                              18
RLSHLDOPTF PATH('                                                             19
SETTAPBRM  INPUT(*NONE *CURRENT *YES) MEDCLS(                                 20
) MOVPCY(*NONE) VOLSEC(*NO) RET(*NONE                                         21
) FILEGRP(*NONE) GRPTYP(*NONE                                                 22
) TEXT('SpyView Report Backup')                                               23
OVRTAPF EXPDATE(*PERM) TOFILE(QSYS/QSYSTAP) FILE(                             24
) DEV(                                                                        25
) LABEL(                                                                      26
) SEQNBR(                                                                     27
) ENDOPT(                                                                     28
) RCDLEN(                                                                     29
) BLKLEN(                                                                     30
CHKOBJ OBJTYPE(*FILE) OBJ(                                                    31
SETMEDBRM  LABEL(*NONE *CURRENT) ALWCNV(*YES) MEDCLS(                         32
) MOVPCY(*NONE) VOLSEC(*NO) RET(*NONE                                         33
) FILEGRP(*NONE) GRPTYPE(*NONE) MARKDUP(*NO                                   34
                                                                              35
                                                                              36
CHKTAP DEV(
) ENDOPT(
** MSGE  Message Entries
ERR1305  1Archive aborted *Status Code(&1) System Code(&2) Pgm line(&3)
ERR131C  2 Report(&1) Folder(&2) skipped - already off-line.
         3
ERR1307  4 Not enough space on Optical volume(s)
         5
ERR1350  6 Report(&1) Folder(&2) skipped - optical volume not entered
         7
ERR1308  8 Compression error occured.
ERR1309  9 Optical error while writing to jukebox.
ERR1310 10 Optical file verification error.
        11
ERR135A 12 Report(&1) Folder(&2) skipped - optical drive not entered
ERR135B 13 Report(&1) Folder(&2) Library(&3) Link(&4) skipped -

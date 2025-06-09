      *%METADATA                                                       *
      * %TEXT Archive Report to a Folder                               *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp('DOCMGR') bnddir('SPYBNDDIR')
      **********--------------------
      * MAG1052  Old Report Archiver  Called by Mag1043 (CL)
      **********--------------------
      *                              Mag1043 called by Mag402 & Mag5022
/2074 * 11-03-09 EPG Recover from RNQ1221 Error with an unexpected
/     *              update or delete in file RSEGHDR without prior input
/     *              operation.
/1944 * 07-29-09 EPG Data Stream type in report maintenance invalid with
/     *              with alternate report key.
/7509 * 05-06-09 EPG Provide for proper error trapping and recovery if
/     *              an attempt to open a file fails.
/6902 * 03-03-08 EPG *USERASCII file archived with different width
/     *              attributes from the original file. Inhibit adjusting
/     *              the width attribute if the printer type is *USERASCII.
T6394 * 06-13-07 PLR Code added under clientele bug 6708 broke the report
      *              splitter by chaining back to MRPTDIR to verify what looks
      *              like availibility by file number. Replaced chain operation
      *              with setll.
T6349 * 05-25-07 PLR LPR'd *USERASCII text file does not distribute. Caused
      *              Total pages attribute not preserved when writting out
      *              attribute record.
T6276 * 05-01-07 PLR Reports containing variable size characters truncated when
      *              viewed through DocView and during printing. Caused by not
      *              archiving the actual max record length. Broken during the
      *              change to using MASPLIO-SRVPGM.
T5178 * 04-12-07 EPG Change the user message from ARC0008, to ARC0009
      *              to prevent the 'Folder threshold exceeded' message
      *              from appearing. The prior message appears to mean
      *              that the program did something that it was not
      *              supposed to do. ARC0009 provides a better idea
      *              to the user of the results, without
      *              unintentionally implying that an error occurred.
T5178 * 03-26-07 EPG Enforce the folder threshold by inhibiting a spooled file
      *              from being archived should the resulting archive produce
      *              a folder that exceeds the current threshold, even though
      *              the threshold has not yet been met prior to the archive.
T5946 * 12-15-06 PLR Configurator crashes when trying to configure report that's
      *              been archived. Caused by T5036 checking for report existence
      *              and then leaving before temporary folder is created that is
      *              used during configuration. Moved code for T5036 out of *inzsr
      *              and into the SKPDUN subroutine.
T5036 * 05-20-06 EPG Inhibit duplicate reports by checking for an
      *              existing spooled file within mrptdir6 based on
      *              the job number, spool number, and date.
T5178 * 04-17-06 PLR Check for folder records overflow. Pointers in the report dir
      *              (i.e., locsfa) have a limitation of 9b0. That translates to
      *              999,999,999. When customer archives past this threshold data
      *              corruption occurs in the form of header records being written
      *              over existing reports.
/9003 * 12-02-04 JMO Added logic to create a hash for the report data in the Folder.
/9118 * 10-13-04 JMO Changed to use new MARMNTIO module for RMaint file updates
/9198 *  8-02-04 JMO Changed update to MRPTDIR so that the Adv. print type (APFTYP)
      *               will be set correctly when archiving PCL regardless of the
      *               SYSDFT setting for APFCFG.
      *               !!!!!!!!!!!!!!!!!! Important Note !!!!!!!!!!!!!!!!!!!!!!!!
      *               ! This change was made to allow customers to be able to  !
      *               ! archive ONLY PCL type reports by using a "P" in the    !
      *               ! SYSDFT APFCFG field. Technically using the "P" setting !
      *               ! should prevent all Advanced print data from being      !
      *               ! archived including PCL. However, there is a "bug" in   !
      *               ! MAGPCL5/MAGPCL that is allowing the PCL data to be     !
      *               ! archived even when the APFCFG flag is "P". We are      !
      *               ! taking advantage of this "bug". Future releases must   !
      *               ! be aware of this and not "break" the functionality.    !
      *               !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
/9134 *  7-07-04 JMO Added code to specify the MBR on OVRDBF commands for folders
      *              and Image files.
/9003 *  5-27-04 JMO Added code to initialize the report Hash value to x'00'.
/5635 * 02-23-04 PLR Audit logging.
/8203 *  1-29-04 JMO Add code to force spool buffer size to 4079.
      *               This was done because we will always re-buffer the
      *               512 byte records into 4079 byte records in order
      *               to efficiently use the 4093 byte records in RAFPDBF.
/6708 * 10-21-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte binary.
      *              Remove access to MRPTDIR, use MRPTDIR1 instead.
      *              Change FILNUM (in MRPTDIR) to be the actual spool file number and
      *              change MRPTDIR1 key to include the spool file opened date.
/8602 *  9-16-03 JMO Corrected logic for retreiving index value(s) for use in
      *               Alternate spool file keys. We were not handling upper and lower
      *               case prompts and data correctly.
/8353 *  9-16-03 JMO Added logic to have RSPLCFG support wildcard values for Report name
      *               replacement.  e.g. LPD* would allow replacement of any reports that
      *               start with LPD.
/8388 *  6-10-03 JMO Changed spool file attributes structure from 3301 bytes
/8388 *               to 8192 bytes. Also, added logic to use MASPLATR functions
      *                to write attribute record(s) to MRPTATR file.
/8058 * 03-12-03 JMO Fixed attribute handling for Page Width, Overflow line
      *                and Total Pages so that it will be correct when archiving to Optical.
      *                The values were being updated in subr. UPDHDR after the
      *                header records were written to Optical.
/7622 * 01-09-03 JMO Removed code to decrement bytes to allocate (m90aloc).
      *              This is handled in MAG1090 and should not be done here.
/6520 * 04-23-02 GT  Increase DIS end EDIS size to 512 elements
/     *              Reports w/ overstrikes do not display correctly
/3765 * 02-21-01 JAM Document management system changes.
/3321 * 12-29-00 KAC REMOVE OPT ID (OBSOLETE AS OF 6.0.6)
/3512 * 12-22-00 PLR Open and close folder file to return size on 1st archive.
/3438 * 12-13-00 KAC Revise compressed report size estimate.
/2737 *  6-21-00 FID Error handling from MAG1090 didn't work in all cases
/2737 *  6-08-00 DLS Alt. create date should monitor for invalid date 2737HQ
/2604 *  5-25-00 DLS Incorrect MDATOP for split report if manual arc  2604HQ
/2604 *  3-30-00 DLS Incorrect MDATOP for split report if manual arc  2604HQ
/2201 * 11-30-99 KAC ADDED NEW FORMATS FOR SPLF CREATE DATE           2201HQ
/2272 * 11-17-99 DM  Choice between packed or binary pg/pk tables
      *  9-10-99 FID call MAG1090 for optical
      *  8-23-99 DM  Fixed alt crt date when using splitter
      *  8-18-99 DM  FID did not change M1052CHL parm list on 3/25/99
      *  8-13-99 FID Added new compare LK=Like NL=Not Like
      *  3-25-99 FID New Parm for PCL5 Support
      *  2-12-99 DM  Added MAG0001 extended filnum
      * 12-08-98 GT  Change call to CVTDAT to SPYCVTDT
      * 10-28-98 JJF Remove job#/file# check in subr SKPDUN
      *  8-18-98 DM  Fixed the Meet subroutine to handle 3 criteria
      *  7-30-98 GT  Set TOTPAG to @PGVRY (counted pages)
      *  6-02-98 JJF Require the data AT SpCol# to match in subr MEET
      *  5-26-98 JJF Call GETNUM to assign SPY#,Segfil,Offlnfile,RType
      *  5-01-98 JJF Define RNDXKY to use entry values for Big5
      *  4-09-98 GT  Add retry for dir in use when attempting to create
      *  3-02-98 FID Folder override for AFP fixed and FLD allocation
      *  3-01-98 FID Masking and Justification for links
      *  2-20-98 FID Allow Blank Prompt
      *  2-17-98 JJF Process error returned from CRTFLD
      *  2-13-98 GT  Changed comp for @SPLTC to EQ *ON instead of
      *              *OFF because @SPLTC is not initialized to '0' (*OFF)
      *  1-29-98 GT  Change overstrike compares to use new API string
      * 12-23-97 JJF Chg Kflds in RPTDKY: FLDR+FLDRLB to EFLDR+EFLDRL
      * 12-19-97 JJF Chain twice to MRptDir6 to be sure rpt not archivd
      * 10-14-97 GT  Add accounting code substitution variable
      *  7-02-97 GK  Make sure Spy# is not on MRptdir.
      *  5-08-97 JJF Change EFLDR & EFLDRL if configured. See OVRFLD SR
      *  3-07-97 JJF Split report if RIndex has Index Type 5 record.
      *  1-27-97 JJF Config report key with report data, cf KEYCFG subr
      *  7-30-96 JJF Add MAGSERVER optical lan writing (OPTTYP field)
      *  6-21-96 PAF Increase FLD array to 41 to prevent problem with
      *              with dist. segments that have idx fields= 40 Bytes
      *  6-05-96 PAF Add additional status desc. for (On+Op)
      *  4-29-96 FID New method for lower/upper case XLATE
      *  3-28-96 GK  Add page# to Report key configuration.
      *  8-28-95 GT  Change MSGE array entries to message IDs
      *  7-28-95 DM  Add MAXLEN to SPYVCT parm list
      *  6-20-95 JJF Call MAG901 for transaction logging.
      *  3-27-95 JJF Outpt single-mbr RSEGMNT file vs multi-mbr SGPGMEM
      *  2-28-95 DM  Add Save and release optical held files recovery
      *  2-16-95 Dlm Add code to lock spyvct *pgm
      *  2-13-95 DM  CrtPf,AddPfm Share parameter to *NO
      *  1-11-95 Ed  Change Sang API to check Return code vs Mess ID.
      * 11-29-94 DM  Create files with the right OWNER  (MAG1030)
      * 11-29-94 DM  Create files in DTALIB not SPYLIB
      * 10-27-94 DM  Fix Bug due to needing to close on 512 boundry
      *  8-30-94 DM  Change JMIPUT to SANGPUT for Non IBM PC optical
      *  8-16-94 DM  Pass back changed rmaint key due to reconfigure
      *  8-10-94 DM  RMAINT key configure by Report data
      *  8- 5-94 DM  Add code for Filter Process
      *  7- 7-94 Dlm Add code to delete the RArchive job records
      *  7- 6-94 DM  Check for Compression Error
      *          DM  Check for Optical Write Error BYT2RW .vs. bufferlen
      *          DM  Verify All size of bytes written to optical
      *                to actual size of files on optical
      *  6-30-94 DM  User Open & Close Distribution Files
      *  6-02-94 DM  Add Distibution Partial Page Table Module
      *  4-13-94 DM  Fix Optical last buffer of data problem (MTEL)
      *  3-28-94 DM  PC optical support
      *  1-07-94 DM  Add compression
      * 12-  -93 DM  Status Bar (shows activity)
      * 11-  -93 DM  Write to optical
      *  8-  -93 Dlm Add code to blanks field that make up RMaint key
      *          DM  Call mag1047 for system date (YYMMDD) -> ADSF
      *          DM  End of FILE rewrite   IntEof Corrected
      *  7-  -93 Dlm Change chain to disp to a read
      *  6-  -93 Dlm Change 9999 page table limit to unlimited
      *          Dlm ADSF field is initialize to today's date
      *
     FSPYVCTFM  CF   E             WORKSTN USROPN
     FMFLDDIR   UF A E           K DISK
     FMRPTDIR1  UF A E           K DISK
     FMRPTDIR6  IF   E           K DISK
     F                                     RENAME(RPTDIR:RPTDIR6)
     FMOPTTBL   O    E           K DISK
     FMSPLDAT1  O    F  256        DISK    INFDS(FILDT1)
     F                                     USROPN
      *       aka Folder
     FMSPLDAT2  UF   F  256        DISK    USROPN
     FPAGETBL   IF A F  256        DISK    USROPN
     FPACKTBL   IF A F  256        DISK    USROPN
     FDISP      IF   F  256        DISK    INFDS(FILDT2)
     FDISP2     IF   F  256        DISK    RECNO(DSPREC)
     F                                     USROPN
     FRMAINT    IF   E           K DISK
/1944FRMAINT4   IF   E           K DISK    USROPN RENAME(RMNTRC:RMNTRC4)
     FRDSTDEF1  IF   E           K DISK    USROPN
     FRSUBLHD   IF   E           K DISK    USROPN
     FRSUBSCR   IF   E           K DISK    USROPN
     FRSEGHDR   UF   E           K DISK    USROPN
     FRSEGHDR2  IF   E           K DISK    USROPN
     F                                     RENAME(SEGHDR:SEGHDR2)
     FRSEGDEF   IF   E           K DISK    USROPN
     FRINDEX    IF   E           K DISK    USROPN
     FMAG1052   UF A E             DISK    USROPN
     FSEGPGTBL  IF A E             DISK    USROPN
     FRSEGMNT   O    E           K DISK    USROPN
     FRARCHIVE  UF   E           K DISK
     FRFILTER   UF   E           K DISK
     FTICKLER   O    F  256        DISK    USROPN

/9134 * copy prototypes for OS APIs
/9134 /copy @OSAPI

T6276 /copy qsysinc/qrpglesrc,qusrspla

/9118 * copy prototypes for RMaint I/O functions
/9118 /copy @MADBIO

      * copy prototypes for MASPLIO functions
      /copy @MASPLIO
/9003
/9003 * copy prototypes for MGHASHFNR functions
/9003 /copy @MGHASHFNR

/9003 /copy qsysinc/qrpglesrc,Qusec
     d pQusec          s               *   inz(%addr(Qusec))
/9003 /copy qsysinc/qrpglesrc,Qwcrdtaa

     d RtvDtaAra       pr                  extpgm('QWCRDTAA')
     d  RcvDta                    32766a   options(*varsize)
     d  rcvLen                       10i 0 const
     d  RcvName                      20a   const
     d  rcvStPos                     10i 0 const
     d  rcvdtaLen                    10i 0 const
     d  Qusec                     32766a   options(*varsize)
     d

/8353d pDtaAraDta      s               *   inz(%addr(DtaAraDta))
     d DtaAraDta       ds           400
     d  HashAFile                    10a
     d  HashValue                    16a

/8353 * copy prototypes for MAALTKEY functions
/8353 /copy qrpglesrc,@MAALTKEY

/8353 * Data structure for RsplCfg records
/8353d RsplCfgDS     e ds                  extname(RsplCfg)

/8353d pRsplCfgDS      s               *   inz(%addr(RsplCfgDS))

      *
/8353d rc              s             10i 0

      * internal spool file number parm.
     d efil#           s              9b 0
     d eDatfo          s              9b 0

      * data structure for changing spool file number for Parent report splitter
     d efil#DS         ds
     d efil#9                  1      9s 0
     d efil_spnbr              4      9s 0

     D CMD             S             60    DIM(54) CTDATA PERRCD(1)
     D MSGE            S              7    DIM(9) CTDATA PERRCD(1)
     D $LG             S              1    DIM(80)

/2272D PG              S              9  0 DIM(63)

/2272D CP              S              9  0 DIM(63)


     D HDR             S            256    DIM(14)
     D OPT             S            256    DIM(640)
     D M90Dta          S            256    DIM(512)
     D OPTR            S              1    DIM(256)
     D OPTN            S              1    DIM(10)

     D IPK             S            256    DIM(128)
     D OPK             S            256    DIM(128)

     D @BR             S              1    DIM(50)
     D SVD             S              1    DIM(50)

     D FLTL            S              3  0 DIM(256)
     D RPL             S              1    DIM(75)
      * Page of report
     D EDIS            S            256    DIM(512)
     D DIS             S            256    DIM(512)
     D @PAG            S            247    DIM(256)
     D LIN             S              1    DIM(247)
     D OVR             S              1    DIM(247)
     D DV              S              1    DIM(40)
     D DF              S             10    DIM(20)
     D IV              S             99    DIM(7)
/8058d upddu1          s              1    inz('N')

     D ILC             S              1    DIM(7) CTDATA PERRCD(1)
     D CLC             S              2    DIM(7) ALT(ILC)
/2201D DFC             S              1    DIM(14) CTDATA PERRCD(1)
/2201D DFN             S             10    DIM(14) ALT(DFC)

/9003
/9003d Context         ds
/9003d  cc_State                     10u 0 dim(4)
/9003d  cc_Count                     10u 0 dim(2)
/9003d  cc_Buffer                    64
/9003d cc_P            s               *   inz(%addr(Context))
/9003
/9003d Digest16        s             16a
/9003d mKey            s             10u 0
/1944d blnAltTyp       s               n   inz(FALSE)
      *---------------------------------
      * end Input, begin Data Structures
      *---------------------------------
/8353d fldAll          ds
/8353d  fld                           1a   dim(41)

/2272D CPTAB           DS
     D  CPT                    1    252P 0 DIM(63)
     D  CV_CPB                 1    252
     D  CPB                           9B 0 DIM(63)
     D                                     OVERLAY(CV_CPB)

/2272D PGTAB           DS
     D  PGT                    1    252P 0 DIM(63)
     D  CV_PGB                 1    252
     D  PGB                           9B 0 DIM(63)
     D                                     OVERLAY(CV_PGB)

     D DIRECD          DS
     D  DIFCFC                 1      1
     D  DTA                    2    256

     D @MSGDT          DS           103
     D  ERRLEN                 9     12B 0
     D  @EM                   25    103
     D                                     DIM(79)
     D FILDT1          DS
      *             Info DS for MSplDat1
     D  BGREC1               156    159B 0
     D FILDT2          DS
      *             Info DS for DISP
     D  BGREC2               156    159B 0

     D ECVVAR          DS          8192
     D                 DS
     d  rcvvar                 1   8192
     d  orat                   1   3315    dim(13)

     D  @JOBNA                49     58
     D  @USRNA                59     68
     D  @JOBNU                69     74
     D  @FILNA                75     84
     D  @FILNU                85     88B 0
     D  @FRMTY                89     98
     D  @USRDT                99    108
     D  @HLDF                129    138
     D  @SAVF                139    148
     D  @TOTPA               149    152B 0
     D  @TOTCP               173    176B 0
     D  @LPI                 181    184B 0
     D  @CPI                 185    188B 0
     D  @OUTQN               191    200
     D  @OUTQL               201    210
     D  @DATFO               211    217
     D  NDATFO               211    217  0
     D  @TIMFO               218    223
     D  @DEVFN               224    233
     D  @PGMOP               244    253
     D  @ACGCD               264    278
     D  @PRTTX               279    308
     D  @DEVCL               317    326
     D  PTRTYP               327    336
     D  PAGLEN               433    436B 0
     D  PAGWID               437    440B 0
     D  @OVRLI               445    448B 0
     D  @PRTFO               537    546
     D  @PAGRO               553    556B 0
     D  @MAXSI               857    860B 0
/8203d  @BufSz               861    864i 0
/9003d  @NbrBufs             997   1000i 0
     D  reserv              3302   3315
     D                 DS
     D  TYPE0                  1    255
     D  DLTSTS                 1      1
     D  FLDR                   2     11
     D  FLDRLB                12     21
     D  FILNAM                22     31
     D  JOBNAM                32     41
     D  USRNAM                42     51
     D  JOBNUM                52     57
     D  FILNUM                58     61B 0
     D  CHKSUM                62     65B 0
     D  SFDESC                66     95
     D  ADSF                  96     99B 0
     D  EXPDAT               100    103B 0
     D  LOCSFA               104    107B 0
     D  LOCSFD               108    111B 0
     D  LOCSFP               112    115B 0
     D  PAGSIZ               116    119B 0
     D  RECOVR               120    120
     D  REPIND               121    130
     D  RPIXNM               131    140
     D  DFTPRT               141    150
     D  DPDESC               151    180
     D  LOCSFE               181    184B 0
     D  LOCSFC               185    188B 0
     D  RPTREC               189    192B 0
     D  PAKVER               193    204
     D  @MDATO               205    208B 0
     D  @MTIMO               209    212B 0
     D  APFTYP               213    213
/9003d  rptHash              214    230
     D                 DS
     D  BGRLS                  1      6
     D  OSRLS                  1      4
     D                 DS
     D  IBUFL                  1      4B 0
     D  OBUFL                  5      8B 0
     D  RBUFL                  9     12B 0

     D OBUF            DS            44

     D SYSDFT          DS          1024
     D  APFCFG               134    134
T5178d  lfldthr              198    200
     D  LDSTYN               220    220
     D  LVEROP               222    222
     D  LSPCFG               228    228
      *                                   228=Config by Rpt Data  Y/N
     D  DRPTNM               252    252
     D  DJOBNM               253    253
     D  DPGMNM               254    254
     D  DUSRNM               255    255
     D  DUSRDA               256    256
     D  DTALIB               306    315
     D  SPLCDT               455    462
     D  SPLCTM               463    468
/2272D  SPGTYP               842    842
     D MHSPY#          DS
      *             Parse Mheader field
     D  VERPRE                 1      3
     D  SPRE2                  2      3  0
     D  SPRE2C                 2      3
     D  VERID                  4     10  0
     D MHOFFL          DS
      *             Parse Mheader field
     D  MHOFF7                 4     10  0

     D BPGLN           DS
     D  #BPAG                  1      4B 0
     D  #BPC                   1      4
     D  #BLINE                 5      8B 0
     D  #BLC                   5      8
     D OPNINF          DS
     D  EXISTS                 1      1
     D  NOTTHR                 2      2
     D  SYNASY                 3      3
     D  RSV1                   4      4
     D  SHAREM                 5      5
     D  ACCESS                 6      6
     D  OTYPE                  7      7
     D  RSV3                   8     10
     D ATTRLN          DS
     D  ATTRL                  1      4B 0
     D PTRINF          DS
     D  STRLOC                 1      1
     D  RSV4                   2      6
     D RETCD           DS
     D  ERLEN                  1      4B 0
     D  RTCD                   5      8B 0
     D  CONDTN                 9     15
     D  MSGDTA                17    116
     D MSGCD           DS
     D  ERLENM                 1      4B 0
     D  RTCDM                  5      8B 0
     D  CONDTM                 9     15
     D  MSGDTM                17    116
     D                 DS                  INZ
     D  PATHL                  9     12B 0
     D  DSTMOV                13     16B 0
     D  NEWPTR                17     20B 0
     D  DIRL                  21     24B 0
     D  MSGL                  25     28B 0
     D  MSGDTL                29     32B 0
     D  @ADSF                 33     40  0
     D  VCTID                 41     52
     D  VCTRTN                60     60
     D  PAKLEN                61     64B 0
     D  INRLEN                65     68B 0
     D  RCVLEN                69     72B 0
     D  OPSIZ                 73     76B 0
     D  DSPREC                77     85  0
     D                 DS
     D  INR                    1    256
     D  CTYPE                  1      1
     D  CDAT                   2    248
     D  CPAG                 249    252
     D  CLIN                 253    256
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

     D DSF             DS                  OCCURS(20)
     D  LSTFLD                 1     40

     D                SDS
     D  PGMERR           *STATUS
     D  PGMLIN                21     28
     D  SYSERR                40     46
     D  SPYLIB                81     90
     D  $JOBNM               244    253
     D  $JOB#                264    269

     D                 DS
      *  Binaries
     D  INFLEN                 1      4B 0
     D  STKCNT                 5      8B 0

     D MSGINF          DS           100

     D ERRCD           DS           116
     D  @ERLEN                 1      4B 0 INZ(116)
     D  @ERCON                 9     15
     D  @ERDTA                17    116
     D  @ED                   17    116
     D                                     DIM(100)

     D COMPST          C                   CONST('COMPOSITE ')
     D PSCON           C                   CONST('PSCON     *LIBL     ')
     D NULLS           C                   CONST(X'0000000000-
     D                                     0000000000')
     D ASCII           C                   CONST('*USERASCII')
     D @CVTDT          C                   CONST('SPYCVTDT2')
/1944d TYPE_ASC        C                   '2'
/1944d TYPE_PCL        C                   '3'
/1944d STREAM_ASC      C                   'ASC'
/1944d TRUE            c                   '1'
/    d FALSE           c                   '0'
     d

/5635 /copy @mlaudlog

/5635d LogDS           ds                  inz
/     /copy @mlaudinp

/3765 * --------------------------------
/3765 * Common definitions
/3765 * --------------------------------
/3765 /COPY @MMdmssrvr

     IMSPLDAT2  UF  01
     I                                  1    1  RECTYP
     I                                  2  256  RECFUL
     I                                  2  248  RECDAT
     I                             B  249  252 0#PAG
     I                             B  253  256 0#LINE

     IPACKTBL   IF  01
/2272I                                  1  253  CPTABT
     I                                  1  252  CPTAB
     IPAGETBL   IF  01
/2272I                                  1  253  PGTABT
     I                                  1  252  PGTAB
     IDISP      IF  01
     I                                  1  256  DIRECD
     IDISP2     IF  01
     I                                  1  256  DIRECD


     C     *ENTRY        PLIST
     C                   PARM                    EFLDR            10
     C                   PARM                    EFLDRL           10
     C                   PARM                    prmrcvvar      8192
     C                   PARM                    OPTYN             1
     C                   PARM                    OPTD             15
     C                   PARM                    OPTV             12
     C                   PARM                    PACKIT            1
     C                   PARM                    CFILNM           10
     C                   PARM                    CJOBNM           10
     C                   PARM                    CPGMOP           10
     C                   PARM                    CUSRNM           10
     C                   PARM                    CUSRDT           10
     C                   PARM                    ARCRTN            1
     C                   PARM                    COMPOS            1
     C                   PARM                    NWRPIN           10
     C                   PARM                    NWAPFN           10
     C                   PARM                    NWAPFI           10
     C                   PARM                    EFIL#
     C                   PARM                    ECHILD            1
     C                   PARM                    STMTYP           10
     C                   PARM                    EOFRPT            1
     C                   PARM                    EINPUT            3 0
     C                   PARM                    EFILNM           10
     C                   PARM                    EDIS
     C                   PARM                    ETOPLN          256
     C                   PARM                    EDISRR            9 0
     C                   PARM                    ERECNO            9 0
     C                   PARM                    ECSPDT            9 0
      *----------------------------------------                           MainLn
      * NOTE: *INZSR does a lot of work here...
      *----------------------------------------

     C     CONFIG        CASNE     'C'           SKPDUN
     C                   ENDCS

     C     OPTYN         IFNE      'Y'
     C                   MOVE      'N'           OPTYN

/7509C                   Monitor
/    C                   OPEN      MSPLDAT1
/    c                   on-error  *all
/     *                  Folder locked by another
/     *                  Process. Try again later.
/    c                   Eval      @ercon = 'DOE0007'
/    c                   Eval      @erdta = *blanks
/    c                   Eval      *inlr = *on
/    c                   Return
/    c                   EndMon

     C                   Z-ADD     BGREC1        splstrrec         9 0
      * Check to see if folder records threshold has been exceeded.
T5178c                   move      lfldthr       fldThr            3 0
/    c                   if        fldThr = 0
/    c                   eval      fldThr = 999
/    c                   endif

/    c                   if        bgrec1 >= (fldThr * 1000000)
/    c                   eval      @ercon = 'ARC0009'
/    c                   eval      @erdta = efldr
/    c                   exsr      rtvmsg
/    c                   eval      log = @msgtx
/    c                   exsr      errmsg
/    c                   eval      *inlr = '1'
/    c                   return
/    c                   endif

      * Accomodate for the potential that the resulting spool archive
      * may exceed the threshold for the folder.

/5178c                   If        (bgrec1 + bgrec2) >=
/    c                             (fldThr * 1000000)
/    c                   eval      @ercon = 'ARC0009'
/    c                   eval      @erdta = efldr
/    c                   exsr      rtvmsg
/    c                   eval      log = @msgtx
/    c                   exsr      errmsg
/    c                   eval      *inlr = '1'
/    c                   return
/5178c                   EndIf

     C                   ELSE
     C                   Z-ADD     0             splstrrec
     C                   END
     c                   add       1             splstrrec

     C     @SPLTC        IFEQ      *ON
     C                   MOVE      'N'           NODST
     C                   END

     C     NODST         IFNE      'N'
     C                   EXSR      DSTYN
     C     DST           CASEQ     'Y'           SEGTBL
     C                   ENDCS
     C                   END

     C     MANUAL        CASEQ     'M'           SETBAR
     C                   ENDCS

     C     CONFIG        CASNE     'C'           VERSID
     C                   ENDCS

     C                   EXSR      NEWFLD
      *    Calculate required file size for optical
     c                   if        packit = 'Y'
/3438c                   if        pagwid > 0
/    c                   eval      M90Aloc=(BGREC2+1000) * pagwid * .5          compressed report
/    c                   else
/    c                   eval      M90Aloc=(BGREC2+1000) * 256 * .5
/    c                   end
/    c                   else
/    c                   eval      M90Aloc=(BGREC2+1000)*256                    uncompressed folder
/    c                   end
      *  ALLWAYS TAKE MULTIPLE OF 16 for the max file size
     c                   clear                   maxfilsiz        13 0
     c                   eval      maxfilsiz=m90aloc/101376000
     c                   eval      maxfilsiz=maxfilsiz/16+1
     c                   eval      maxfilsiz=maxfilsiz*16384000
     c                   move      maxfilsiz     M90FilSiz

/9003 * intialize hash context and prepare to build the hash digest value
/9003c                   eval      mKey = getDocHKey(@NbrBufs)
/9003c                   clear                   Context
/9003c                   callp     MD5Init(cc_P:mKey)
/9003

     c                   if        optyn<>'Y'
     C                   EXSR      ADDHDR
     C                   EXSR      ADDATR
     C                   EXSR      ADDDTA
     C                   EXSR      ADDTBL
     c                   else
      *   ...01-nn file
     C                   EXSR      ADDDTA
      *   ...00 file
     C                   EXSR      ADDHDR
     C                   EXSR      ADDATR
     C                   EXSR      ADDTBL
     c                   endif

     C                   EXSR      NEWRPT
      *                                                       PckTbl

     C     NODST         IFNE      'N'
     C     DST           ANDEQ     'Y'
     C                   EXSR      ADDSEG
     C                   END

     c                   EXSR      UPDFDR
     C                   EXSR      UPDHDR

      *     If folder name got overwritten, move apf data to new folder
     C     ORGFLD        IFNE      EFLDR
     C     ORGFLB        ORNE      EFLDRL
     C     OPTYN         IFNE      'Y'
     C     APFTYP        ANDNE     ' '
     C                   EXSR      MOVAPF
     C                   ENDIF
     C                   ENDIF
      *                                                     in folder
     C     MANUAL        IFEQ      'M'
     C                   MOVE      *BLANKS       @BR
     C                   MOVE      X'23'         @BR(1)
     C                   MOVE      X'20'         @BR(50)
     C                   MOVEA     @BR           STSBAR
     C                   WRITE     STATUS
     C                   END

     C     ARCKY         DELETE    ARCRC                              67

/5635c                   if        config <> 'C'
/    c                   eval      LogOpCode = #AUCAPOBJ
/    c                   eval      LogObjID  = repind
/    c                   callp     AddLogDtl(%addr(LogDS):#DTFLR:*null:0:
/    c                             %addr(efldr):%len(%trimr(efldr)))
/    c                   callp     AddLogDtl(%addr(LogDS):#DTVOL:*NULL:0:
/    c                             %addr(m90volume):%len(%trimr(m90volume)))
/    c                   callp     LogEntry(%addr(LogDS))
/    c                   endif

     C     @SPLTC        IFEQ      *ON
     C     EOFRPT        IFNE      'Y'
     C                   Z-ADD     #INPUT        EINPUT
     C                   MOVE      DIS           EDIS
     C                   MOVE      TOPLIN        ETOPLN
     C                   MOVE      DISRR         EDISRR
     C                   MOVE      RECNO         ERECNO
     C                   Z-ADD     CSPLDT        ECSPDT
     C                   END
     C                   OPEN      TICKLER
     C                   EXCEPT    TICKLR
     C                   END

     C                   CLOSE     *ALL
     C                   MOVE      REPIND        NWRPIN
     C                   MOVE      *ON           *INLR



      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

     c                   movel     prmrcvvar     rcvvar

     C                   CALL      'MAG103R'
     C                   PARM                    BGRLS
      * Save input folder name
     C                   MOVEL     EFLDR         ORGFLD           10
     C                   MOVEL     EFLDRL        ORGFLB           10

      * Retrieve overstrike characters
     C                   CALL      'MAG103C'
     C                   PARM                    OCLEN             3 0
     C                   PARM                    OCSTR            99

     C     ARCRTN        IFEQ      'C'
     C                   MOVE      'C'           CONFIG            1
     C                   MOVE      'M'           VCTRTN
     C                   MOVE      'M'           MANUAL            1
     C                   MOVE      'N'           NODST             1
     C                   ELSE
     C                   MOVE      ARCRTN        VCTRTN
     C                   MOVE      ARCRTN        MANUAL
     C                   MOVE      ARCRTN        NODST
     C                   END

     C                   MOVE      VCTRTN        VCARTN            1

     C     MANUAL        IFEQ      'M'
     C                   OPEN      SPYVCTFM
     c                   if        %error or
     c                             not %open(spyvctfm)
     c                   eval      *in35 = not *in35
     c                   endif
     C  N35
     CAN 35              READ      SPYVCTFM                               35
     C                   END

     C                   MOVE      *ON           ARCRTN
      *                                                    successful
     C                   Z-ADD     116           ERLEN
     C                   Z-ADD     116           ERLENM

     C     *DTAARA       DEFINE                  SYSDFT
     C                   IN        SYSDFT
/2272
     C     SPGTYP        IFNE      'B'
     C                   MOVE      ' '           PGTBTY            1
     C                   ELSE
     C                   MOVE      'B'           PGTBTY
     C                   ENDIF

     C     DTALIB        IFEQ      *BLANKS
     C                   MOVEL     'SPYGLASS'    DTALIB
     C                   END
      *                                                                   *INZSR
     C     NODST         IFNE      'N'
     C     LDSTYN        ANDNE     'Y'
     C                   MOVE      'N'           NODST
     C                   END

     C                   OPEN      RINDEX                               41
     C     *IN41         IFEQ      '1'
     C                   EXSR      MONMSG
     C                   ENDIF

     C     NODST         IFNE      'N'
     C                   OPEN      RDSTDEF1
     C                   OPEN      RSUBLHD
     C                   OPEN      RSUBSCR
     C                   OPEN      RSEGHDR
     C                   OPEN      RSEGHDR2
     C                   OPEN      RSEGDEF
     C                   END

     C     @PGMOP        IFEQ      NULLS
     C                   MOVE      *BLANKS       @PGMOP
     C                   END

     C                   MOVE      @JOBNU        JOBNUM
     C                   Z-ADD     @FILNU        filnum
/6708C                   move      @datfo        datfop

     C     ECHILD        IFNE      *BLANK
     C                   MOVE      EFIL#         FILNUM
     C                   END

     C     DRPTNM        IFEQ      'Y'
     C                   MOVE      *BLANKS       FILNAM
     C                   ELSE
     C                   MOVE      @FILNA        FILNAM
     C                   END
     C     DJOBNM        IFEQ      'Y'
     C                   MOVE      *BLANKS       JOBNAM
     C                   ELSE
     C                   MOVE      @JOBNA        JOBNAM
     C                   END
     C     DPGMNM        IFEQ      'Y'
     C                   MOVE      *BLANKS       PGMOPF
     C                   ELSE
     C                   MOVE      @PGMOP        PGMOPF
     C                   END
     C     DUSRNM        IFEQ      'Y'
     C                   MOVE      *BLANKS       USRNAM
     C                   ELSE
     C                   MOVE      @USRNA        USRNAM
     C                   END
     C     DUSRDA        IFEQ      'Y'
     C                   MOVE      *BLANKS       USRDTA
     C                   ELSE
     C                   MOVE      @USRDT        USRDTA
     C                   END
      *                                                    Override/
     C                   EXSR      OVRFLD

      *------------------ Report Splitter -------------------------
      * If RIndex record type 5 exists, this report is to be split.
      *------------------------------------------------------------
     C                   SELECT
     C     ECHILD        WHENEQ    ' '
     C     ARCRTN        ANDNE     'C'
     C     KLBIG5        SETLL     RINDEX                                 50
     C     *IN50         IFEQ      *ON
     C                   DO        *HIVAL
     C     KLBIG5        READE     INDEXRC                                50
     C   50              LEAVE
     C     IICMD         IFEQ      5
     C                   MOVE      *ON           @SPLTP            1
     C                   END
     C                   ENDDO
     C                   END

     C     ECHILD        WHENEQ    '1'
     C     ECHILD        OREQ      'Y'
     C                   MOVE      *ON           @SPLTC            1
     C                   ENDSL

     C     ECHILD        IFEQ      '1'
     C                   MOVE      'Y'           CYCLE1            1
     C                   ENDIF

     C     @SPLTP        CASEQ     *ON           PARENT
     C     @SPLTC        CASEQ     *ON           CHILD
     C                   ENDCS

     C     ECHILD        IFEQ      ' '
     C                   MOVE      'Y'           CYCLE1
     C                   ENDIF

     C                   OPEN      PAGETBL
     C                   OPEN      PACKTBL

     C                   MOVE      FILNAM        #FILNM           10
     C                   MOVE      JOBNAM        #JOBNM           10
     C                   MOVE      PGMOPF        #PGMOF           10
     C                   MOVE      USRNAM        #USRNM           10
     C                   MOVE      USRDTA        #USRDT           10

     C                   CALL      'SPYLOUP'
     C                   PARM                    LO               60
     C                   PARM                    UP               60

     C     LSPCFG        IFEQ      'Y'
     C     @SPLTC        ANDEQ     ' '

/8353 * Get first RSPLCFG record with matching Big5 key
/8353c                   eval      rc = Get1stSplCfg(pRsplCfgDS:Filnam:Jobnam:
/8353c                              pgmopf:usrnam:usrdta)

     c                   Dow       rc = #OK

      *                                                    Replace a
     C                   MOVE      'Y'           USECFG            1
     C                   EXSR      KEYCFG
/8353c                   eval      rc = GetNxtSplCfg(pRsplCfgDS:Filnam:Jobnam:
/8353c                              pgmopf:usrnam:usrdta)
     C                   ENDDO

      * close file(s)
     c                   eval      rc = ClsSplCfg

     C                   Z-ADD     0             MEMPG#
     C                   MOVE      *BLANKS       @PAG
     C                   Z-ADD     0             #P
     C                   Z-ADD     0             L
     C                   MOVE      *OFF          *IN99
     C                   END

     C     ECHILD        IFNE      'Y'
     C                   MOVE      FILNAM        CFILNM
     C                   MOVE      JOBNAM        CJOBNM
     C                   MOVE      PGMOPF        CPGMOP
     C                   MOVE      USRNAM        CUSRNM
     C                   MOVE      USRDTA        CUSRDT
     C                   END

     C     ECHILD        IFEQ      ' '
     C                   EXSR      GETSDT
     C                   ELSE
     C     CSPLDT        IFNE      *ZEROS
     C                   Z-ADD     CSPLDT        MDATOP
     C                   MOVE      'N'           NODATE
     C                   ELSE
     C                   MOVE      'Y'           NODATE
     C                   ENDIF
     C                   ENDIF

     C     MANUAL        IFEQ      'M'
     C                   MOVE      @TIMFO        MTIMOP

     C                   ELSE
     C     NODATE        IFEQ      'Y'
     C                   SELECT
     C     SPLCDT        WHENEQ    *BLANKS
     C                   MOVE      @DATFO        MDATOP
     C                   OTHER
     C                   MOVE      SPLCDT        MDATWK            8 0
     C                   MOVEL     MDATWK        MDTWK2            2
     C     MDTWK2        IFEQ      '20'
     C                   MOVEL     '01'          MDATWK
     C                   ELSE
     C                   MOVEL     '00'          MDATWK
     C                   END
     C                   Z-ADD     MDATWK        MDATOP
     C                   ENDSL
     C                   END

     C     SPLCTM        IFEQ      *BLANKS
     C                   MOVE      @TIMFO        MTIMOP
     C                   ELSE
     C                   MOVE      SPLCTM        MTIMOP
     C                   END
     C                   END

     C                   Z-ADD     MDATOP        @MDATO
     C                   Z-ADD     MTIMOP        @MTIMO

     C     CONFIG        IFNE      'C'
/9118 * write/update the Rmaint record
/9118c                   eval      rc = crtRmaint(Filnam:JobNam:PgmOpf:UsrNam:
/9118c                               usrDta)
      * retreive updated values
     c     klbig5        chain(e)  Rmaint
      /free
/1944                    If  ( NOT %found );
/
/                          If ( Not %open(RMaint4) );
/                            Open(e)   RMaint4;
/                          EndIf;
/
/                          Chain ( RtypID )  RMaint4;
/
/                          If ( %found  = TRUE );
/                             blnAltTyp = ( STREAM_ASC = RDtStr );
/                          EndIf;

/                          Close(e) RMaint4;
/                        Else;
/                           blnAltTyp = ( STREAM_ASC = RDtStr );
/                        EndIf;
      /end-free

     C                   END

     C                   MOVE      *ZEROS        FLTL
     C                   Z-ADD     0             FLINE#
     C                   Z-ADD     0             FLOVST
     C                   Z-ADD     0             FLCOL#
     C     RFLTKY        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C                   KFLD                    FLINE#
     C                   KFLD                    FLOVST
     C                   KFLD                    FLCOL#
     C     RFLTKY        SETLL     RFILTER
     C     KLBIG5        READE     RFILTER                                51

     C     *IN51         DOWEQ     *OFF
     C                   MOVE      'Y'           FLT               1
     C                   Z-ADD     FLINE#        LIN3              3 0
     C                   Z-ADD     1             #                 5 0
     C     LIN3          LOOKUP    FLTL(#)                                52
     C     *IN52         IFNE      *ON
     C                   Z-ADD     0             Z3                3 0
     C                   Z-ADD     1             #
     C     Z3            LOOKUP    FLTL(#)                                52
     C                   Z-ADD     LIN3          FLTL(#)
     C                   END

     C     KLBIG5        READE     RFILTER                                51
     C                   ENDDO

     C     FLT           IFNE      'Y'
     C                   CLOSE     RFILTER
     C                   END

     C                   MOVE      *BLANKS       BLNK10           10
     C                   Z-ADD     255           STRLEN           15 5
     C                   Z-ADD     0             SZ               13 0
     C                   CLOSE     DISP2


     C                   ENDSR
/7622c*@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/7622c* getMaxSiz - get the maximum optical file segment size
/7622c*@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/7622c     getMaxSiz     Begsr
/7622c
/7622 *      Get the maximum Optical file size
      * use maximum of 99 files because file seq# 00 is used for header info.
/7622c                   CALL      'SPYSZFIT'
/7622c                   PARM                    TOTRCD           13 0          TOTAL RCD#
/7622c                   PARM                    RCDLEN           13 0          RCD LENGTH
/7622c                   PARM      99            MAXFIL            3 0          MAX # OF FIL
/7622c                   PARM                    MAXBYT           13 0          MAX BYTE SIZ
/7622c                   PARM                    MAXMB            13 0          MAX MB   SIZ
/7622c
/7622c                   z-add     MAXBYT        MaxFilSiz
/7622c
/7622c                   Endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DLCFLD        BEGSR
      *          Dealocate folder
     C     'DLCOBJ'      CAT(P)    'OBJ((':1     CMDLIN
     C                   CAT       EFLDRL:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       EFLDR:0       CMDLIN
     C                   CAT       '*FILE':1     CMDLIN
     C                   CAT       '*EXCL':1     CMDLIN
     C                   CAT       'RD))':0      CMDLIN
     C                   EXSR      RUNCL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ALCFLD        BEGSR
      *          Alocate   folder
     C     'ALCOBJ'      CAT(P)    'OBJ((':1     CMDLIN
     C                   CAT       EFLDRL:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       EFLDR:0       CMDLIN
     C                   CAT       '*FILE':1     CMDLIN
     C                   CAT       '*EXCL':1     CMDLIN
     C                   CAT       'RD))':0      CMDLIN
     C                   CAT       'WAIT(':1     CMDLIN
     C                   CAT       '0)':0        CMDLIN
     C                   EXSR      RUNCL
      *   Could not alocate folder
     C     *IN22         IFEQ      '1'
     C                   MOVEL     'ERR1446'     @ERCON
     C     EFLDR         CAT(P)    EFLDRL        @ERDTA
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   EXSR      QUIT
     C                   ENDIF

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PARENT        BEGSR
      *          Parent Report Splitter

      *   This instance of Mag1052 does not process the report, but
      *   rather calls a child multiple times to do the work, sending
      *   the child ECHILD=1 or Y - (1)st call or (Y)es subseq calls.
      *       i.e: Put a copy of Mag1052 (M1052CHL), in QTemp.
      *            Call M1052CHL until it returns EOFRPT=Y.
      *   The parent then SETS ON LR and RETURNS from this subroutine.

     C                   EXSR      GETSDT
     C     NODATE        IFEQ      'N'
     C                   Z-ADD     MDATOP        CSPLDT            9 0
     C                   ELSE
     C                   MOVE      *ZEROS        CSPLDT
     C                   ENDIF

     C                   CALL      'MAG1030'
     C                   PARM                    CRTRTN
     C                   PARM      'QTEMP'       CRTLIB
     C                   PARM      'INDXTICK'    CRTOBJ
     C                   PARM      '*FILE'       CRTTYP
     C                   PARM      CMD(50)       CRTCMD

     C                   MOVEL(P)  CMD(51)       CMDLIN
     C                   EXSR      RUNCL

     C     MANUAL        IFEQ      'M'
     C                   MOVE      'U'           MSGTO             1
     C                   END
     C     OPTYN         IFEQ      'Y'
     C                   MOVEL     '*YES'        OPTICL            4
     C                   ELSE
     C                   MOVEL     '*NO '        OPTICL
     C                   END

     C     CMD(46)       CAT(P)    SPYLIB:0      CMDLIN
     C                   CAT       CMD(47):0     CMDLIN
     C                   EXSR      RUNCL
     C                   MOVE      '1'           ECHILD
      *                                                     to child...
     C                   MOVE      $JOB#         @JOBNU
     C                   Z-ADD     FILNUM        EFIL#

     C     CEOF          DOUEQ     'Y'
      *                                                    Disp.
     C     CONFIG        IFEQ      'C'
     C                   MOVE      'C'           ARCRTN
     C                   ELSE
     C                   MOVE      MANUAL        ARCRTN
     C                   END

/6708c                   eval      Efil#9 = Efil#
/6708c                   eval      efil_spnbr = 0
/6708C                   DO        1000000
/6708c                   eval      efil_spnbr = efil_spnbr + 1
/6708c                   eval      efil# = efil#9
/6708c                   eval      @filnu = efil_spnbr
     c                   eval      eDatfo = ndatfo
T6394C     RPTKY6        setll     RPTDIR6                                30
     C     RPTKY6        KLIST
     C                   KFLD                    @JOBNU
     C                   KFLD                    EFIL#
     C                   KFLD                    eDatfo
T6394C  n30              LEAVE
     C                   ENDDO

T6394C     *IN30         IFEQ      *on
     C                   MOVE      '1'           ARCRTN
     C                   LEAVE
     C                   END

     C     cspldt        ifeq      *zeros
     C     mdatop        andne     *zeros
     C                   z-add     mdatop        cspldt
     C                   endif

     C                   CALL      'M1052CHL'
     C                   PARM                    EFLDR
     C                   PARM                    EFLDRL
     C                   PARM      RCVVAR        ECVVAR
     C                   PARM                    OPTYN
     C                   PARM                    OPTD
     C                   PARM                    OPTV
     C                   PARM                    PACKIT
     C                   PARM                    CFILNM
     C                   PARM                    CJOBNM
     C                   PARM                    CPGMOP
     C                   PARM                    CUSRNM
     C                   PARM                    CUSRDT
     C                   PARM                    ARCRTN
     C                   PARM                    COMPOS
     C                   PARM      *BLANKS       NWRPIN
     C                   PARM                    NWAPFN
     C                   PARM                    NWAPFI
     C                   PARM                    EFIL#
     C                   PARM                    ECHILD
     C                   PARM                    STMTYP           10
     C                   PARM                    CEOF              1
     C                   PARM                    #INPUT
     C                   PARM                    FILNAM
     C                   PARM                    DIS
     C                   PARM                    TOPLIN
     C                   PARM                    DISRR
     C                   PARM                    RECNO
     C                   PARM                    CSPLDT

     C     ARCRTN        IFEQ      '1'
     C                   LEAVE
     C                   ENDIF

     C     ECHILD        IFEQ      '1'
     C                   Z-ADD     @FILNU        FIL1ST            9 0
     C                   ENDIF

     C                   MOVE      'Y'           ECHILD

     C                   MOVEL(P)  CMD(48)       CMDLIN
     C                   EXSR      RUNCL
     C                   MOVEL(P)  CMD(49)       CMDLIN
     C                   EXSR      RUNCL
     C                   ENDDO

     C                   Z-ADD     FIL1ST        @FILNU
     C                   CLOSE     *ALL

     C                   exsr      shutdwn
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHILD         BEGSR
      *          Child Report Splitter
      *          Report name (FILNAM) is determined by using an RIndex
      *          record, type 5 (IICMD=5).  The contents each page of
      *          the report at the location defined by the RIndex5
      *          record becomes the split report name.

      *  Read the DISP file (with shared data path) until:
      *     End of file.  Return EOFRPT=Y.
      *  or A page is encountered whose user-defined splitter field
      *     changes values.  Return DSP 512 x 256 array with recs
      *     from the next page.

      *     The 1st time the child is called (ECHILD=1), he gets his
      *     1st page reading the DB file DISP.  Subsequent child runs
      *     (ECHILD=Y) get the 1st page from the entry parm array, DIS,
      *     which the previous child run returned to the parent.

     C                   Z-ADD     ERECNO        RECNO
     C                   Z-ADD     ECSPDT        CSPLDT

     C     *LIKE         DEFINE    IPLN#         CPLN#
     C     *LIKE         DEFINE    ISCOL         CSCOL
     C     *LIKE         DEFINE    IKLEN         CKLEN
     C     *LIKE         DEFINE    IPLN#         CPLN2
     C     *LIKE         DEFINE    ISCOL         CSCO2
     C     *LIKE         DEFINE    IKLEN         CKLE2

     C     KLBIG5        SETLL     RINDEX
     C                   DO        *HIVAL
     C     KLBIG5        READE     INDEXRC                                50
     C     *IN50         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C     IICMD         IFNE      5
     C                   ITER
     C                   ENDIF

     C                   SELECT
     C     IINAM         WHENEQ    '@SPLIT2'
     C                   Z-ADD     IPLN#         CPLN2
     C                   Z-ADD     IKLEN         CKLE2
     C                   Z-ADD     ISCOL         CSCO2
     C                   OTHER
     C                   Z-ADD     IPLN#         CPLN#
     C                   Z-ADD     IKLEN         CKLEN
     C                   Z-ADD     ISCOL         CSCOL
     C                   ENDSL
     C                   ENDDO

     C     ECHILD        IFEQ      '1'
     C                   EXSR      LODDIS
     C                   Z-ADD     #INPUT        EINPUT
     C                   EXSR      SPLITF
     C     FILNA1        CAT(P)    FILNA2:0      FILNAM

     C                   ELSE
     C                   MOVE      EDIS          DIS
     C                   MOVE      ETOPLN        TOPLIN
     C                   MOVE      EFILNM        FILNAM
     C                   Z-ADD     EINPUT        #INPUT
     C                   MOVE      EDISRR        DISRR             9 0
     C                   END

     C                   MOVE      'LOADED'      @DIS@             6
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPLITF        BEGSR
      *          Get the splitter fields off the page

      *   Get FILNA1 from line CPLN#, column CSCOL, length CKLEN.
      *   Get FILNA2 from line CPLN2, column CSCO2, length CKLE2.

     C                   MOVE      *BLANKS       FILNA1
     C                   MOVE      *BLANKS       FILNA2

     C                   MOVEL(P)  @PAG(CPLN#)   TXT             247
     C     CKLEN         SUBST(P)  TXT:CSCOL     FILNA1           10
     C                   SUBST     FILNA1:1      FIL1              1
     C     FIL1          IFEQ      ' '
     C     ' '           CHECK     FILNA1        #F                2 0    50
     C   50              SUBST(P)  FILNA1:#F     FILNA1
     C                   ENDIF
     C     ' '           CHECKR    FILNA1        #F1               2 0    50
     C  N50              Z-ADD     10            #F1
      *                                                     field.
     C     CPLN2         IFNE      0
     C                   MOVEL(P)  @PAG(CPLN2)   TXT
     C     CKLE2         SUBST(P)  TXT:CSCO2     FILNA2           10
     C                   SUBST     FILNA2:1      FIL1
     C     FIL1          IFEQ      ' '
     C     ' '           CHECK     FILNA2        #F                       50
     C   50              SUBST(P)  FILNA2:#F     FILNA2
     C                   ENDIF
     C                   SUBST     FILNA2:10     FIL1
     C     FIL1          IFEQ      ' '
     C     ' '           CHECKR    FILNA2        #F2               2 0
     C                   ELSE
     C                   Z-ADD     10            #F2
     C                   ENDIF
     C     10            SUB       #F1           #AV               2 0
     C     #AV           IFGT      0
     C     #F2           IFLE      #AV
     C                   Z-ADD     #F2           #AV
     C                   Z-ADD     1             #F2
     C                   ELSE
     C                   SUB       #AV           #F2
     C                   ADD       1             #F2
     C                   ENDIF
     C     #AV           IFNE      0
     C     #AV           SUBST(P)  FILNA2:#F2    FILNA2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SKPDUN        BEGSR
      *          Skip this report if already archived

     C     RPTDKY        SETLL     RPTDIR                                 67
     C     RPTDKY        KLIST
     C                   KFLD                    EFLDR
     C                   KFLD                    EFLDRL
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    USRNAM
     C                   KFLD                    JOBNUM
     C                   KFLD                    FILNUM
     C                   KFLD                    DATFOP

      *                  Check for a duplicate report
      *                  and exit if this does exist
T5946c                   if        not *in67
/    c                   Eval      efil#  = @filnu
/    c                   Eval      eDatfo = nDatfo
/    c     RptKy6        setll     RptDir6                                67
/    c                   If        %equal
/    c                   eval      @ercon = 'ARC0016'
/    c                   exsr      rtvmsg
/    c                   eval      log = @msgtx
/    c                   exsr      errmsg
/    c                   EndIf
/    c                   EndIf

     C     *IN67         IFEQ      *ON
     C                   exsr      shutdwn
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETSDT        BEGSR
      *          Get the spoolfile create date

     C                   MOVE      ' '           CONTPG            1
     C                   MOVE      'N'           NODATE            1
     C                   OPEN      RINDEX                               41
     C     *IN41         IFEQ      '1'
     C                   EXSR      MONMSG
     C                   ENDIF
     C                   MOVEL(P)  '@SPLDAT'     DSRFLD
     C     RNDXDS        CHAIN     RINDEX                             41
     C     RNDXDS        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C                   KFLD                    DSRFLD

     C     *IN41         IFEQ      *ON
     C                   MOVE      @DATFO        MDATOP
     C                   MOVE      'Y'           NODATE
     C                   GOTO      ENDGSD
     C                   END

     C                   Z-ADD     1             SPPAG#
      *>>>>
     C     GNXT          TAG
     C                   EXSR      MAKEPG
      *                                                                   GETSDT
     C     IPMTL         IFEQ      *ZERO
     C                   MOVEA     @PAG(IPLN#)   EXM             256
     C                   Z-ADD     ISCOL         S#                3 0
     C                   GOTO      PIKDT
     C                   END

     C     IPMTEC        IFEQ      999
     C                   Z-ADD     247           @EC               3 0
     C                   ELSE
     C                   Z-ADD     IPMTEC        @EC
     C                   END

     C     IPMTEL        IFEQ      999
     C                   Z-ADD     255           @EL               3 0
     C                   ELSE
     C                   Z-ADD     IPMTEL        @EL
     C                   END

     C                   Z-ADD     IPMTSL        @SL               3 0
     C                   Z-ADD     IPMTL         #LN               3 0
     C                   Z-ADD     IPMTSC        @SC               3 0
     C                   MOVE      *OFF          *IN41

     C     @SL           DO        @EL           L
     C                   MOVEA     @PAG(L)       EXM
     C     IPRMPT:#LN    SCAN      EXM:@SC       #FS               3 0    41
     C     #FS           ADD       #LN           #FE               3 0
     C                   SUB       1             #FE

     C     *IN41         IFEQ      *ON
     C     #FE           ANDGT     @EC
     C     *IN41         OREQ      *OFF
     C                   MOVE      *OFF          *IN41
     C                   ITER
     C                   END

     C                   LEAVE
     C                   ENDDO

     C     *IN41         IFEQ      *OFF
     C     *IN99         ANDEQ     *ON
     C                   MOVE      @DATFO        MDATOP
     C                   MOVE      'Y'           NODATE            1
     C                   GOTO      ENDGSD
     C                   END

     C     *IN41         IFEQ      *OFF
     C                   MOVE      '0'           NOREAD            1
     C     DSPREC        IFGT      1
     C                   SUB       1             DSPREC
     C     DSPREC        CHAIN     DISP2                              41
     C                   ELSE
     C                   MOVE      '1'           NOREAD
     C                   ENDIF
     C                   ADD       1             SPPAG#
     C     SPPAG#        SUB       1             #P
     C                   MOVE      'Y'           CONTPG
     C                   GOTO      GNXT
     C                   END
      *                                                                   GETSDT
     C     IPMTRC        ADD       #FS           S#
     C     IPMTRL        ADD       L             #P
     C                   MOVEA     @PAG(#P)      EXM
      *                                                    found
      *>>>>
     C     PIKDT         TAG
/2201C     IKLEN         SUBST(P)  EXM:S#        DATSEL           20
/2201C                   MOVE      *BLANKS       INFORM
/    C                   Z-ADD     1             D                 3 0
/    C     IINDA         LOOKUP    DFC(D)                                 66
/    C     *IN66         IFEQ      *ON
/    C                   MOVEL     DFN(D)        INFORM
/    C                   END

/    C                   MOVEL(P)  DATSEL        DATEIO
/2201C                   CALL      @CVTDT                               50
/    C                   PARM                    DATEIO           20
     C                   PARM                    INFORM           10
     C                   PARM      '*YYMD'       OUTORM           10
     C                   PARM      *BLANK        CVTERR            1

/2737c     cvterr        ifeq      *on
/2737c                   move      @datfo        mdatop
/2737c                   move      'Y'           nodate
/2737c                   else

     C                   MOVEL     DATEIO        MDATWK            8 0
     C                   MOVEL     MDATWK        MDTWK2            2
     C     MDTWK2        IFEQ      '20'
     C                   MOVEL     '01'          MDATWK
     C                   ELSE
     C                   MOVEL     '00'          MDATWK
     C                   END
     C                   Z-ADD     MDATWK        MDATOP
/2737c                   end

     C     ENDGSD        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     KEYCFG        BEGSR
      *          ----------------------------------------------------
      *          Replace 1 Rmaint key field as configured in RSPLCFG
      *          ----------------------------------------------------
      *          Put data into ALFA10; at end move to key field.

      * Think "Replace SPLFLD with SPRPDT"
      * RSPLCFG fields:
      *         SP LFLD = The name of the field to be replaced
      *            RPDT = Replacement data -or name of,ptr to repl data
      *            PAG# = Location of report data: Page
      *            Lin# =    "     "    "      " : line
      *            Col# =    "     "    "      " : column
      *            #byt =    "     "    "      " : length
      *----------------------------------------------
      * Replacement data is in a spool file attribute
      *----------------------------------------------
     C     SPRPDT        IFEQ      'RPTNAM'
     C     SPRPDT        OREQ      'JOBNAM'
     C     SPRPDT        OREQ      'USRNAM'
     C     SPRPDT        OREQ      'PGMNAM'
     C     SPRPDT        OREQ      'USRDTA'
     C     SPRPDT        OREQ      'FRMNAM'
     C     SPRPDT        OREQ      'OUTQNM'
     C     SPRPDT        OREQ      'ACGCDE'

     C                   Z-ADD     SPCOL#        ##
     C                   SELECT
     C     SPRPDT        WHENEQ    'RPTNAM'
     C     SP#BYT        SUBST(P)  @FILNA:##     ALFA10           10
     C     SPRPDT        WHENEQ    'JOBNAM'
     C     SP#BYT        SUBST(P)  @JOBNA:##     ALFA10
     C     SPRPDT        WHENEQ    'USRNAM'
     C     SP#BYT        SUBST(P)  @USRNA:##     ALFA10
     C     SPRPDT        WHENEQ    'PGMNAM'
     C     SP#BYT        SUBST(P)  @PGMOP:##     ALFA10
     C     SPRPDT        WHENEQ    'USRDTA'
     C     SP#BYT        SUBST(P)  @USRDT:##     ALFA10
     C     SPRPDT        WHENEQ    'FRMNAM'
     C     SP#BYT        SUBST(P)  @FRMTY:##     ALFA10
     C     SPRPDT        WHENEQ    'OUTQNM'
     C     SP#BYT        SUBST(P)  @OUTQN:##     ALFA10
     C     SPRPDT        WHENEQ    'ACGCDE'
     C     SP#BYT        SUBST(P)  @ACGCD:##     ALFA10
     C                   ENDSL

     C                   GOTO      LODKEY
     C                   END

      *--------------------------------------------------------------
      * Replacement data is NOT a spool file attr. It's either:
      *           1. in the RSplCfg field SPRPDT  or
      *           2. on the report.
      * But before we replace, we must meet search criteria.
      *--------------------------------------------------------------
     C                   EXSR      MAKEPG

/8353c                   eval      rc = ChkSelSplCfg(pRsplCfgDS:%addr(@pag))
/8353c     rc            cabeq     #NOMATCH      ENDKEY

      *----------------------------------------------------------------KEYCFG
      * Report data matches criteria.  If the "replacement data",         KEYCFG
      * (SpRPDT) is an Index name with an index type of 4, use report
      * data.  Else use the contents of SpRPDT.
      * So:
      *    If   SpRPDT starts with @, and
      *         the index is in the RIndex file, and
      *         the index type (IICMD in RIndex) is 4
      *    Then get report data described by the index (IKLEN bytes
      *         from line IPLN# at column ISCOL).
      *    Else use the contents of SPRPDT (literal value from RSplCfg)
      *----------------------------------------------------------------
     C                   MOVEL     SPRPDT        ALFA10

     C                   MOVEL     SPRPDT        ALFA1             1
     C     ALFA1         IFEQ      '@'
     C                   MOVE      SPRPDT        DSRFLD
     C     RNDXKY        CHAIN     RINDEX                             60
     C     RNDXKY        KLIST
     C                   KFLD                    #FILNM
     C                   KFLD                    #JOBNM
     C                   KFLD                    #PGMOF
     C                   KFLD                    #USRNM
     C                   KFLD                    #USRDT
     C                   KFLD                    DSRFLD
     C     *IN60         IFEQ      *OFF
     C     IICMD         ANDEQ     4
      *   Get value from spool
     C                   MOVE      'CFGKEY'      SUBR              6
     C                   EXSR      GETFLD
     C                   MOVEA     FLD           ALFA10
      *                                                                   KEYCFG
      *   If justification is defined, go for it
     C     JUSTIF        IFEQ      'L'
     C     JUSTIF        OREQ      'R'
     C                   Z-ADD     10            JSTLEN            5 0
     C                   MOVEL(P)  ALFA10        JSTVAL           99
     C                   EXSR      DOJUST
     C                   MOVEL(P)  JSTVAL        ALFA10
     C                   ENDIF

     C                   END
     C                   END
      *>>>>
     C     LODKEY        TAG

/8602 * only allow lowercase data for Userdata; all others must be uppercase
/8602c                   if        SPlfld <> 'USRDTA'
/8602c     lo:up         xlate     alfa10        alfa10
/8602c                   endif

     C                   SELECT
     C     SPLFLD        WHENEQ    'RPTNAM'
     C                   MOVE      ALFA10        FILNAM
     C     SPLFLD        WHENEQ    'JOBNAM'
     C                   MOVE      ALFA10        JOBNAM
     C     SPLFLD        WHENEQ    'PGMNAM'
     C                   MOVE      ALFA10        PGMOPF
     C     SPLFLD        WHENEQ    'USRNAM'
     C                   MOVE      ALFA10        USRNAM
     C     SPLFLD        WHENEQ    'USRDTA'
     C                   MOVE      ALFA10        USRDTA
     C                   ENDSL
     C     ENDKEY        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CVTLOC        BEGSR
      *  ILOC db field is used twice   1. Justification  2. Lower case

      *    ILOC  ->  Justif Lowcas
      *     l    ->    L      Y
      *     r    ->    R      Y
      *     L    ->    l      n
      *     R    ->    r      n
      *     Y    ->    n      y
      *     N    ->    n      n
      *    ' '   ->    n      n

      *  Convert before output to rlnkdef
     C     CVTMOD        IFEQ      'DBOUT'
     C                   Z-ADD     1             @                 5 0
     C                   MOVEL     JUSTIF        F2A               2
     C                   MOVE      LOWCAS        F2A
     C     F2A           LOOKUP    CLC(@)                                 01
     C     *IN01         IFEQ      '1'
     C                   MOVE      ILC(@)        ILOC
     C                   ELSE
     C                   MOVE      'N'           ILOC
     C                   ENDIF

      *  Convert after reading from rlindex
     C                   ELSE
     C                   Z-ADD     1             @                 5 0
     C     ILOC          LOOKUP    ILC(@)                                 01
     C     *IN01         IFEQ      '1'
     C                   MOVE      CLC(@)        LOWCAS            1
     C                   MOVEL     CLC(@)        JUSTIF            1
     C                   ELSE
     C                   MOVE      'N'           LOWCAS
     C                   MOVE      'N'           JUSTIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OVRFLD        BEGSR
      *          OvrDbf for the folder (MSPLDAT1 & 2).
      *          Replace EFLDR/EFLDRL if configured.

     C     EFLDRL        IFNE      'QTEMP'

      * Rsplky = filnam jobnam pgmopf usrnam usrdta splfld
      *                                                     If there's
     C                   MOVEL(P)  'FOLDER'      SPLFLD

/8353 * Get first RSPLCFG record with matching Big5 key
/8353c                   eval      rc = Get1stSplCfg(pRsplCfgDS:Filnam:Jobnam:
/8353c                              pgmopf:usrnam:usrdta:splfld)
/8353c                   dow       rc = #ok

     C                   EXSR      MAKEPG
     C                   EXSR      MEET
     C     MEETS         IFEQ      'Y'
     C     SPRPDT        IFNE      EFLDR
     C     SPLIBR        ORNE      EFLDRL
     C                   EXSR      DLCFLD
     C                   ENDIF
     C                   MOVE      SPRPDT        EFLDR
     C                   MOVE      SPLIBR        EFLDRL
     C                   EXSR      ALCFLD
     C                   LEAVE
     C                   END

/8353c                   eval      rc = GetNxtSplCfg(pRsplCfgDS:Filnam:Jobnam:
/8353c                              pgmopf:usrnam:usrdta:splfld)
/8353c                   enddo

      * close file(s)
     c                   eval      rc = ClsSplCfg

     C                   END

     C                   CALL      'CRTFLD'
     C                   PARM                    EFLDR
     C                   PARM                    EFLDRL
     C                   PARM                    CFRETN            8
     C     CFRETN        IFEQ      '1'
      *          "SpyFolder was not created."               there and
     C                   MOVE      'ERR130B'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   EXSR      EXITER
     C                   END

/9134 * change OVRDBF to specify member.  Also, use prototyped
/9134 *   call to QCmdExc.
/9134c                   eval      cmdLin = %trim(cmd(52))+%trim(efldrl)+'/'+
/9134c                             %trim(efldr)+') MBR('+%trim(efldr)+')' +
/9134c                             ' OVRSCOPE(*CALLLVL)'
/9134c                   callp(e)  QCmdExc(%trim(cmdLin):%len(%trim(cmdLin)))
/9134
/9134c                   eval      cmdLin = %trim(cmd(53))+%trim(efldrl)+'/'+
/9134c                             %trim(efldr)+') MBR('+%trim(efldr)+')' +
/9134c                             ' OVRSCOPE(*CALLLVL) ' + %trim(cmd(54))
/9134c                   callp(e)  QCmdExc(%trim(cmdLin):%len(%trim(cmdLin)))
/9134

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MEET          BEGSR
      *          Meet up to 3 search criteria on SplCfg record.
      *          Return MEETS = Y or N

      * Until 6/2/98 the searches used a scan STARTING at SpCol#
      *    On 6/2/98 the searches require the data AT SpCol# to match.

     C                   MOVE      'N'           MEETS             1
     C                   Z-ADD     SP#BYT        ##
     C                   Z-ADD     SPLIN#        ML                5 0
     C                   MOVEA     @PAG(ML)      DTA

     C     *LIKE         DEFINE    SPCRIT        RPTVAL
     C     ##            SUBST(P)  DTA:SPCOL#    RPTVAL
     C     RPTVAL        CABNE     SPCRIT        BOTMET
     C                   MOVE      'Y'           MEETS

     C     SP#BY2        IFGT      0
     C                   MOVE      'N'           MEETS
     C                   Z-ADD     SP#BY2        ##
     C                   Z-ADD     SPLIN2        ML
     C                   MOVEA     @PAG(ML)      DTA
     C     ##            SUBST(P)  DTA:SPCOL2    RPTVAL
     C     RPTVAL        CABNE     SPCRI2        BOTMET
     C                   MOVE      'Y'           MEETS
     C                   END

     C     SP#BY3        IFGT      0
     C                   MOVE      'N'           MEETS
     C                   Z-ADD     SP#BY3        ##
     C                   Z-ADD     SPLIN3        ML
     C                   MOVEA     @PAG(ML)      DTA
     C     ##            SUBST(P)  DTA:SPCOL3    RPTVAL
     C     RPTVAL        CABNE     SPCRI3        BOTMET
     C                   MOVE      'Y'           MEETS
     C                   END
     C     BOTMET        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MAKEPG        BEGSR
      *          Make memory page for key configuration
      *          by reading the DISP2 file of the report

     C     SPPAG#        IFEQ      0
     C                   Z-ADD     1             SPPAG#
     C                   END

     C     SPPAG#        CABEQ     MEMPG#        ENDMAK
      *                                                     in mem now.
     C     *LIKE         DEFINE    SPPAG#        MEMPG#
     C                   Z-ADD     SPPAG#        MEMPG#

     C     DP2OPN        IFNE      'Y'
     C                   OPEN      DISP2
     C                   MOVE      'Y'           DP2OPN            1
     C                   END

     C                   MOVE      *BLANKS       @PAG
     C     CONTPG        IFNE      'Y'
     C                   Z-ADD     0             #P
     C                   SELECT
     C     ECHILD        WHENEQ    ' '
     C     ECHILD        OREQ      '1'
     C     1             SETLL     DISP2
     C     ECHILD        WHENEQ    'Y'
     C     EDISRR        SETLL     DISP2
     C                   ENDSL
     C                   ENDIF
     C                   Z-ADD     0             L
     C                   MOVE      *OFF          *IN99

     C     *IN99         DOUEQ     *ON
     C     CONTPG        IFEQ      'Y'
     C     NOREAD        ANDEQ     '1'
     C                   MOVE      '0'           NOREAD
     C                   GOTO      RPTCDS
     C                   ENDIF
     C                   READ      DISP2                                  99
     C     *IN99         IFEQ      *ON
     C                   LEAVE
     C                   END

      *>>>>
     C     RPTCDS        TAG
     C     DIFCFC        IFEQ      '1'
     C                   ADD       1             #P
     C                   END

     C     #P            IFLT      SPPAG#
     C                   ITER
     C                   ELSE
     C     #P            IFGT      SPPAG#
     C                   LEAVE
     C                   END
     C                   END
      *                                                    On the page.
     C                   SELECT
     C     DIFCFC        WHENEQ    '1'
     C                   Z-ADD     1             L
     C     DIFCFC        WHENEQ    ' '
     C                   ADD       1             L
     C     DIFCFC        WHENEQ    '0'
     C                   ADD       2             L
     C     DIFCFC        WHENEQ    '-'
     C                   ADD       3             L
     C     DIFCFC        WHENEQ    '+'
     C                   ADD       0             L
     C                   ENDSL

     C     DIFCFC        IFNE      '+'
     C                   MOVEA     DTA           @PAG(L)
     C                   ELSE
     C                   MOVEA     @PAG(L)       LIN
     C                   MOVEA     DTA           OVR
     C                   DO        247           #
     C     OVR(#)        IFNE      ' '
     C     LIN(#)        SCAN      OCSTR         OC#               3 0
     C     OC#           IFGT      0
     C     OC#           ANDLE     OCLEN
     C                   MOVE      OVR(#)        LIN(#)
     C                   END
     C                   END
     C                   ENDDO
     C                   MOVEA     LIN           @PAG(L)
     C                   END
     C                   ENDDO
     C     ENDMAK        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MAKPAG        BEGSR
      *          Make memory page from DIS array

     C                   MOVE      *BLANKS       @PAG
     C                   Z-ADD     0             L

     C                   DO        #INPUT        I#
     C                   MOVE      DIS(I#)       DIRECD
     C                   SELECT
     C     DIFCFC        WHENEQ    '1'
     C                   Z-ADD     1             L
     C     DIFCFC        WHENEQ    ' '
     C                   ADD       1             L
     C     DIFCFC        WHENEQ    '0'
     C                   ADD       2             L
     C     DIFCFC        WHENEQ    '-'
     C                   ADD       3             L
     C     DIFCFC        WHENEQ    '+'
     C                   ADD       0             L
     C                   ENDSL

     C     DIFCFC        IFNE      '+'
     C                   MOVEA     DTA           @PAG(L)
      *                                                        or
     C                   ELSE
     C                   MOVEA     @PAG(L)       LIN
     C                   MOVEA     DTA           OVR

     C                   DO        247           #
     C     OVR(#)        IFNE      ' '
     C     LIN(#)        SCAN      OCSTR         OC#               3 0
     C     OC#           IFGT      0
     C     OC#           ANDLE     OCLEN
     C                   MOVE      OVR(#)        LIN(#)
     C                   END
     C                   END
     C                   ENDDO

     C                   MOVEA     LIN           @PAG(L)
     C                   END
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     NEWFLD        BEGSR
      *          Add new folder record if needed to MFLDDIR

     C     FLDDKY        CHAIN(N)  FLDDIR                             68
     C     *IN68         IFEQ      *ON
/3512C                   CLOSE     MSPLDAT1                             69
/3512C                   OPEN      MSPLDAT1                             69
     C                   Z-ADD     bgrec1        INTEOF
     C                   MOVE      EFLDR         FLDCOD
     C                   MOVE      EFLDRL        FLDLIB
     C                   MOVE      *BLANKS       FDESC
     C                   Z-ADD     0             NUMFIL
      ** THIS IS DONE BY MAGSPLF OR MAGASCII AND CAUSES PROBLEMS
      ***                  MOVE NWAPFN    APFNAM
     C                   WRITE     FLDDIR
      ***                  ELSE
      ** THIS IS DONE BY MAGSPLF OR MAGASCII AND CAUSES PROBLEMS
      ***        NWAPFN    IFNE *BLANKS
      ***                  MOVE NWAPFN    APFNAM
      ***                  UPDATFLDDIR
      ***                  ELSE
      ***                  UNLCKMFLDDIR
      ***                  END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADDHDR        BEGSR
      *          ------------------------------------
      *          Add report header record to folder
      *              or to HDR,1 for write to optical
      *          ------------------------------------
     C                   MOVE      *ON           *IN81
     C                   MOVE      '0'           RECTYP
     C                   MOVEL     MSGE(3)       @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        RECFUL
     C                   Z-ADD     splstrrec     @LCSFH            9 0
      *   Fill fields in TYPE0 record
     C                   MOVE      FLDCOD        FLDR
     C                   MOVE      FLDLIB        FLDRLB
     C                   Z-ADD     0             CHKSUM
     C     COMPOS        IFEQ      'Y'
     C                   Z-ADD     1             CHKSUM
     C                   END

     C                   CALL      'MAG1047'                              50
     C                   PARM                    YMDNUM            9 0
     C                   PARM                    YMD               8
     C                   MOVE      YMD           @ADSF
     C                   Z-ADD     @ADSF         ADSF

     C                   Z-ADD     0             EXPDAT
     C                   Z-ADD     0             PAGSIZ
      *    compute record pointer to folder
     c                   exsr      getfldptr

     C     OPTYN         IFEQ      'N'
     C                   EXCEPT    SPLDAT
     C                   ELSE
     C     '0'           CAT       TYPE0:0       HDR(1)
     C                   END

     C                   ENDSR
      *****************************************************************
     C     getfldptr     BEGSR

     C     splstrrec     ADD       1             locsfa
     c                   eval      locsfd=locsfa+13
     c                   eval      locsfp=locsfd+spldtarec
     c                   if        packit = 'Y'
     c                   eval      locsfc=locsfp+pagtblrec
     c                   else
     c                   clear                   locsfc
     c                   endif
     c                   eval      locsfe=locsfp+pagtblrec+cprtblrec-1

     C     PACKIT        IFEQ      'Y'
     C                   MOVEL     'Pack''d '    PAKVER
     C                   MOVE      'Ver.1'       PAKVER
     C                   MOVE      '1'           PKVER
     C                   END

     c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADDATR        BEGSR
      *          Process Attribute records

     C                   MOVE      *ON           *IN81
     C                   MOVE      '1'           RECTYP
      *      Write out 13 attribute records
     c                   clear                   reserv
     c                   do        13            ix                5 0
     C                   MOVE      ORAT(ix)      RECFUL
     C                   EXSR      WRTATR
     c                   enddo

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRTATR        BEGSR
      *          ------------------------------
      *          Write attributes to folder
      *             or to HDR
      *          ------------------------------
     C     OPTYN         ifeq      'N'
     C                   EXCEPT    SPLDAT
     C                   ELSE
     C     ix            add       1             @O               10 0
     C     '1'           CAT(P)    RECFUL:0      HDR(@o)
     C                   endif
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADDDTA        BEGSR

     c                   clear                   spldtarec        11 0

      *          Add data records to folder (MSplDat1)     Variables
      *                                                    for Pagetbl
      *                                                    -----------
     C                   Z-ADD     0             RR#              10 0
     C                   Z-ADD     0             RPTREC
     C                   Z-ADD     0             #P               10 0
     C                   Z-ADD     0             @PGVRY           10 0
     C                   Z-ADD     1             LSTPG            10 0
     C                   Z-ADD     0             #PT              10 0
     C                   Z-ADD     0             pagtblrec        10 0
     C                   MOVE      *ZEROS        PG

      *                                                    For Compress
      *                                                    table
      *                                                    -----------
     C                   Z-ADD     0             #CR              10 0
     C                   Z-ADD     0             #CT              10 0
     C                   Z-ADD     0             cprtblrec        10 0
     C                   MOVE      *ZEROS        CP

      *                                                    For Optical
      *                                                    -----------
     C                   MOVE      *BLANKS       OPT
     C                   Z-ADD     0             ZZ                3 0
     C                   Z-ADD     0             @SF               2 0
     C                   Z-ADD     163840        @TBYTE            9 0
     C                   Z-ADD     0             @RBYTE            9 0
     C                   Z-ADD     0             @RFBYT            9 0
     C                   MOVE      *OFF          *IN81

      *                                                    For Compress
      *                                                    ------------
     C                   Z-ADD     0             INRLEN
     C                   Z-ADD     0             IC                3 0

     C                   Z-ADD     0             @DB               3 0
      *----------------------------------------------------------------
      * New process 3/97 to allow report splitter to work:
      *   Load records for a page into a record buffer (DIS array).
      *   Unload the array and process the data.
      *----------------------------------------------------------------
      * Report loop
     C     *IN99         DOUEQ     *ON

     C                   EXSR      LODDIS
      *                                                     into DIS.

     C     @SPLTC        IFEQ      *ON
     C     L2BRK         ANDNE     FILNAM
     C                   MOVEL     L2BRK         EFILNM
     C                   MOVE      *ON           *IN99
     C                   LEAVE
     C                   ENDIF

     C     @SPLTC        IFEQ      *ON
     C     EOFRPT        ANDEQ     'L'
     C                   MOVE      'Y'           EOFRPT
     C                   MOVE      '1'           *IN99
     C                   ENDIF
      * Unload page loop
     C                   DO        #INPUT        I#
     C     I#            IFEQ      #INPUT
     C                   MOVE      'Y'           ENDDIS            1
     C                   ELSE
     C                   MOVE      'N'           ENDDIS
     C                   ENDIF
     C                   MOVE      DIS(I#)       DIRECD
     C                   ADD       1             RR#
     C                   ADD       1             RPTREC

     C     MANUAL        IFEQ      'M'
     C                   ADD       256           @WBYTE            9 0
     C     @WBYTE        DIV       @BVAL         @B                2 0

     C     @B            IFGT      48
     C                   Z-ADD     48            @B
     C                   ELSE
     C     @B            IFLT      1
     C                   Z-ADD     1             @B
     C                   END
     C                   END

     C     @B            IFGE      @DB
     C                   MOVE      *BLANKS       @BR
     C                   MOVE      X'23'         @BR(1)
     C                   MOVE      X'20'         @BR(@B)
     C                   MOVEA     @BR           STSBAR
     C                   WRITE     STATUS
     C                   ADD       4             @DB
     C                   END
     C                   END

     C     DIFCFC        IFEQ      '1'
     C     *LIKE         DEFINE    TOTPAG        SPLTP#
     C                   ADD       1             SPLTP#
     C                   ADD       1             #P
     C                   ADD       1             @PGVRY
     C                   ADD       1             #PT
     C                   Z-ADD     RR#           PG(#PT)
     C     #PT           IFEQ      63
     C                   EXSR      PTWTR
     C                   Z-ADD     0             #PT
     C                   END
     C                   END
      *                                                    file
     C                   SELECT
     C     DIFCFC        WHENEQ    '1'
     C     #LINE         IFGT      @OVRLI
     C                   Z-ADD     #LINE         @OVRLI
     C                   END
     C     #LINE         IFGT      PAGLEN
     C                   Z-ADD     #LINE         PAGLEN
     C                   END

     C                   Z-ADD     1             #LINE
     C     DIFCFC        WHENEQ    ' '
     C                   ADD       1             #LINE
     C     DIFCFC        WHENEQ    '0'
     C                   ADD       2             #LINE
     C     DIFCFC        WHENEQ    '-'
     C                   ADD       3             #LINE
     C     DIFCFC        WHENEQ    '+'
     C                   ADD       0             #LINE
     C                   ENDSL

     C     RFLTCK        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C                   KFLD                    FLINE#

     C     FLT           IFEQ      'Y'
     C                   Z-ADD     #LINE         LIN3
     C     LIN3          LOOKUP    FLTL                                   51
     C     *IN51         IFEQ      *ON

     C     DIFCFC        IFEQ      '+'
     C                   ADD       1             FOVR              3 0
     C                   ELSE
     C                   Z-ADD     1             FOVR
     C                   END

     C                   Z-ADD     #LINE         FLINE#
     C                   Z-ADD     FOVR          FLOVST
     C                   Z-ADD     0             FLCOL#
     C     RFLTKY        SETLL     RFILTER

     C     *IN51         DOUEQ     *ON
     C     RFLTCK        READE     RFILTER                                51
     C     *IN51         IFEQ      *ON
     C                   LEAVE
     C                   END

     C                   MOVE      *OFF          *IN52

     C     FLCRIT        IFNE      '*ANY'
     C     FLCRIT        IFNE      *BLANKS
     C     ' '           CHECKR    FLCRIT        ##
     C                   ELSE
     C                   Z-ADD     FL#BYT        ##
     C                   END
     C     FLCRIT:##     SCAN      DTA:FLCOL#                             52
     C                   ELSE
     C                   MOVE      *ON           *IN52
     C                   END

     C     *IN52         IFEQ      *ON
     C                   MOVEA     DTA           LIN
     C                   Z-ADD     FLCOL#        #
     C     FLRPLT        IFEQ      '*ORIG'
     C                   MOVEA     LIN(#)        RPL
     C     1             ADD       FL#BYT        #
     C                   MOVEA     *BLANKS       RPL(#)
     C                   MOVEA(P)  RPL           FLRPDT
     C                   UPDATE    FILTRC
     C                   END

     C                   Z-ADD     FLCOL#        #
     C                   Z-ADD     FL#BYT        ##                3 0
     C                   DO        ##
     C                   MOVE      ' '           LIN(#)
     C                   ADD       1             #
     C                   ENDDO
     C                   MOVEA     LIN           DTA
     C                   END
     C                   ENDDO
     C                   END
     C                   END

     C     ' '           CHECKR    DTA           @PGW              9 0
/8058C*    @PGW          IFGT      pagwid
/6902c*    PtrTyp        andne     '*USERASCII'
/1944c                   If        ( ( @PGW > PagWid ) and
/    c                                ( PtrTyp <> '*USERASCII' ) ) or
/    c                             ( ( @PGW > PagWid          )  and
/    c                                ( PtrTyp = '*USERASCII' )  and
/    c                                ( blnAltTyp = TRUE      )       )
/8058C                   Z-ADD     @PGW          pagwid
/1944C                   EndIf

     C                   MOVE      DIFCFC        RECTYP
     C                   MOVEL     DTA           RECDAT
     C                   Z-ADD     #P            #PAG
      *                                                    is
     C                   MOVE      RECTYP        CTYPE
     C                   MOVE      RECDAT        CDAT
     C                   Z-ADD     #PAG          #BPAG
     C                   Z-ADD     #LINE         #BLINE
     C                   MOVE      #BPC          CPAG
     C                   MOVE      #BLC          CLIN

     C     NODST         IFNE      'N'
     C     DST           ANDEQ     'Y'
     C     #P            IFNE      LSTPG
     C                   EXSR      CRTSEG
     C                   MOVE      *BLANKS       @PAG
     C                   Z-ADD     #P            LSTPG
     C                   END

     C                   MOVE      CDAT          LOWR            247
     C     LO:UP         XLATE     LOWR          UPER            247
      *                                                    UpperCase
     C                   Z-ADD     #LINE         L                 3 0
     C     DIFCFC        IFNE      '+'
     C                   MOVEA     UPER          @PAG(L)
     C                   ELSE
     C                   MOVEA     @PAG(L)       LIN
     C                   MOVEA     UPER          OVR
     C                   DO        247           #
     C     OVR(#)        IFNE      ' '
     C     LIN(#)        SCAN      OCSTR         OC#               3 0
     C     OC#           IFGT      0
     C     OC#           ANDLE     OCLEN
     C                   MOVE      OVR(#)        LIN(#)
     C                   END
     C                   END
     C                   ENDDO
     C                   MOVEA     LIN           @PAG(L)
     C                   END
     C                   MOVE      'Y'           PGDTA             1
     C                   END
/9003
/9003 * hash the print data
/9003c                   callp     md5Update(cc_P:%addr(INR):
/9003c                               %size(INR))

     C     PACKIT        IFEQ      'Y'
     C                   ADD       256           INRLEN
     C                   ADD       1             IC
     C                   MOVE      INR           IPK(IC)
     C     IC            IFEQ      128
     C                   EXSR      PACK
     C                   MOVE      *BLANK        IPK
     C                   Z-ADD     0             IC
     C                   Z-ADD     0             INRLEN
     C                   END
     C                   ELSE
     C                   MOVE      INR           OUTREC          256
     C                   EXSR      ADDRPT
     C                   END
     C                   ENDDO
     C                   ENDDO
      *------------------------
      * Endof report processing
      *------------------------

/9003 * Finalize hash
/9003c                   callp     MD5Final(Digest16:cc_P)
/9003c                   eval      rptHash = Digest16

     C     *IN99         IFEQ      *ON
     C     NODST         IFNE      'N'
     C     DST           ANDEQ     'Y'
     C     PGDTA         ANDEQ     'Y'
     C                   ADD       1             #P
     C                   EXSR      CRTSEG
     C                   END

     C     PACKIT        IFEQ      'Y'
     C     IC            ANDGT     0
     C                   EXSR      PACK
     C                   MOVE      *BLANK        IPK
     C                   Z-ADD     0             IC
     C                   Z-ADD     0             INRLEN
     C                   END

     C     OPTYN         IFEQ      'Y'
     C     @RBYTE        IFGT      0
     C                   MOVE      *ON           *IN99
     C                   EXSR      CRTOPT
     C                   END
     C     @RFBYT        IFGT      0
     C                   EXSR      CLSOPT
     C                   Z-ADD     0             @RFBYT
     C                   END
     C                   END

     C     PG(1)         CASGT     0             PTWTR
     C                   ENDCS

     C     PACKIT        IFEQ      'Y'
     C     CP(1)         ANDGT     0
     C                   EXSR      PKWTR
     C                   END
     C                   END

     C     @OVRLI        IFGT      PAGLEN
     C                   Z-ADD     PAGLEN        @OVRLI
     C                   END
/8058 *
/8058c                   eval      upddu1 = 'n'
/8058c     @pgvry        ifne      @totpa
/8058c                   z-add     @pgvry        @totpa
/8058c                   eval      upddu1 = 'Y'
/8058c                   endif
/8058 *
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODDIS        BEGSR
      *          Load a page of DISP records into DIS array 512 x 256

     C     @DIS@         IFEQ      'LOADED'
     C                   MOVE      *BLANK        @DIS@             6
     C                   Z-ADD     EINPUT        #INPUT
     C     EOFRPT        IFEQ      'L'
     C                   MOVE      'Y'           EOFRPT
     C                   MOVE      *ON           *IN99
     C                   END
     C                   GOTO      BOTDIS
     C                   END

     C                   ADD       1             DISPG#            9 0

      * Tricky, because we read DISP sequentially, and we read
      * the 1st record of the next (unwanted) page into memory.
      * The field TopLin holds this line - the next page's top line.

/6520c                   z-add     0             I#                3 0
/    c                   dow       i# < %elem(dis)
/    c                   eval      i# = i# + 1
     C                   READ      DISP                                   99
     C                   ADD       1             RECNO             9 0

     C     *IN99         IFEQ      *ON
     C     @SPLTC        IFEQ      *ON
     C                   MOVE      'L'           EOFRPT
     C                   END
     C     TOPLIN        IFNE      *BLANK
     C                   MOVE      TOPLIN        DIS(1)
     C                   MOVE      *BLANK        TOPLIN
     C                   ADD       1             I#
     C                   END
     C                   LEAVE
     C                   END

     C     CYCLE1        IFEQ      'Y'
     C                   MOVE      'N'           CYCLE1
     C                   ELSE
     C     I#            IFEQ      1
     C                   MOVE      TOPLIN        DIS(1)
     C                   MOVE      *BLANK        TOPLIN
     C                   ADD       1             I#
     C     RECNO         SUB       1             DISRR
     C                   END
     C     DIFCFC        IFEQ      '1'
     C                   MOVE      DIRECD        TOPLIN          256
     C                   LEAVE
     C                   END
     C                   END

     C                   MOVE      DIRECD        DIS(I#)
     C                   ENDDO
     C     I#            SUB       1             #INPUT            3 0

      *>>>>
     C     BOTDIS        TAG
     C     @SPLTC        IFEQ      *ON

      *            L2brk = filna1 *cat filna2
      *                                                                   LODDIS
     C                   EXSR      MAKPAG
     C                   EXSR      SPLITF
     C     FILNA1        CAT(P)    FILNA2:0      L2BRK            10
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PACK          BEGSR
      *          Pack input record buffered at 32,768 bytes  128 Recs

      *          Compress records of Report before adding to folder
      *          by calling an MI program, the IBM supplied
      *          compression instruction.

      * The record format of the compression record is:

      *    |   |   |   |   |   |   |   |   |   |   |   |   |   |256|
      *      |                                                   |
      *      +------------- Real Compressed data ----------------+

      *    Multiple Report records will exist within the 256 byte
      *    records.

      *    Report records can cross over the 256 byte boundary.

      *    Buffering 128 records to the compress MI program.
      *    When adding compressed records to the report, the
      *    start of each 128 record's boundary will begin at col 1.

      *    The Version of the compression algorithm is placed in the
      *    header record of the report.

      *          Input: IPK     (128x256) data stream
      *                 INRLEN  size in bytes before packing
      *                 Packit,optyn,*in99,@rbyte

      *          Work:  OPK     (128x256) IPK packed by SpyPack           PACK
      *                 PAKLEN  size in bytes after packing
      *                 PKREC   number of packed 256 byte recs

      *          Output:OUTREC-->passed to SR ADDRPT PKREC times.

     C                   MOVE      *BLANKS       OPK
     C                   Z-ADD     0             PAKLEN
     C                   CALL      'SPYPACK'
     C                   PARM                    IPK
     C                   PARM                    INRLEN
     C                   PARM                    OPK
     C                   PARM                    PAKLEN

     C     PAKLEN        IFLE      0
     C                   EXSR      ERRCPS
     C                   END

     C     PAKLEN        DIV       256           PKREC             3 0
     C                   MVR                     REM               3 0
     C     REM           IFGT      0
     C                   ADD       1             PKREC
     C                   END

     C                   ADD       1             #CT
      *                                                      pointer.
     C     PACKIT        IFEQ      'Y'
     C     OPTYN         ANDEQ     'Y'
     C     *IN99         ANDEQ     *ON
     C     PKREC         MULT      256           @NEWPK            9 0
     C     @RBYTE        ADD       @NEWPK        @TOTPK            9 0
     C     @TOTPK        IFGT      @TBYTE
     C                   MOVE      *OFF          *IN99
     C                   END
     C                   END

     C                   DO        PKREC         OC                3 0
     C                   ADD       1             #CR
      *                                                    packed rec
     C     OC            IFEQ      1
     C                   Z-ADD     #CR           CP(#CT)
     C     #CT           IFEQ      63
     C                   EXSR      PKWTR
     C                   Z-ADD     0             #CT
     C                   END
     C                   END
      *                                                    file
     C                   MOVE      OPK(OC)       OUTREC
     C                   EXSR      ADDRPT
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADDRPT        BEGSR
      *          ----------------------------------------
      *          Add record to folder or to Optical array
      *          ----------------------------------------
     c                   add       1             spldtarec

     C     OPTYN         IFEQ      'N'
     C                   EXCEPT    SPLDAT
     C                   ELSE
     C                   ADD       1             ZZ
     C                   MOVEA     OUTREC        OPT(ZZ)
     C                   ADD       256           @RBYTE
     C                   ADD       256           @RFBYT
     C     @RBYTE        CASEQ     @TBYTE        CRTOPT
     C                   ENDCS
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PKWTR         BEGSR
      *          Write compressed (packed) record to PACKTBL

     C                   ADD       1             cprtblrec
/2272
     C     PGTBTY        IFNE      'B'
     C                   Z-ADD     CP            CPT
     C                   ELSE
     C                   Z-ADD     CP            CPB
     C                   ENDIF

     C                   EXCEPT    PAKDAT
     C                   Z-ADD     0             CP
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PTWTR         BEGSR
      *          Write page table record to PAGETBL

     C                   ADD       1             pagtblrec
/2272
     C     PGTBTY        IFNE      'B'
     C                   Z-ADD     PG            PGT
     C                   ELSE
     C                   Z-ADD     PG            PGB
     C                   ENDIF

     C                   EXCEPT    TBLDAT
     C                   Z-ADD     0             PG
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADDTBL        BEGSR
      *          Add page table records to end of report in folder
      *            or in a new stream file on optical,
      *          If needed...
      *          Add Compress table records to end of report in folder
      *            or in a new stream file on optical

     C                   MOVE      *ON           *IN81
     C                   MOVE      '3'           RECTYP

     C     OPTYN         IFEQ      'Y'
     C                   Z-ADD     14            @O
     C                   MOVEA     HDR           OPT
     C                   Z-SUB     1             @SF
     C                   Z-ADD     3584          @RBYTE
     C                   Z-ADD     @RBYTE        @RFBYT
     C                   MOVE      *OFF          *IN99
     c                   eval      M90aloc=(pagtblrec+cprtblrec+20)*256
     C                   END

     C                   DO        pagtblrec     #C               10 0
     C     #C            CHAIN     PAGETBL                            66
/2272C                   MOVEL     PGTABT        RECFUL

     C     OPTYN         IFEQ      'N'
     C                   EXCEPT    SPLDAT
     C                   ELSE
     C                   ADD       1             @O
     c                   eval      opt(@o)='3'+recful
     C                   ADD       256           @RBYTE
     C                   ADD       256           @RFBYT
     C     @RBYTE        IFEQ      @TBYTE
     C                   EXSR      CRTOPT
     C                   Z-ADD     0             @O
     C                   END
     C                   END
     C                   ENDDO

     C     PACKIT        IFEQ      'Y'
     C                   MOVE      *ON           *IN81
     C                   MOVE      '4'           RECTYP

     C     OPTYN         IFEQ      'Y'
     C                   MOVE      *OFF          *IN99
     C                   END

     C                   DO        cprtblrec     #C               10 0
     C     #C            CHAIN     PACKTBL                            66
/2272C                   MOVEL     CPTABT        RECFUL

     C     OPTYN         IFEQ      'N'
     C                   EXCEPT    SPLDAT
     C                   ELSE
     C                   ADD       1             @O
     C     '4'           CAT(P)    RECFUL:0      OPT(@O)
     C                   ADD       256           @RBYTE
     C                   ADD       256           @RFBYT
     C     @RBYTE        IFEQ      @TBYTE
     C                   EXSR      CRTOPT
     C                   Z-ADD     0             @O
     C                   END
     C                   END

     C                   ENDDO
     C                   END

     C     OPTYN         IFEQ      'Y'
     C     @RBYTE        ANDGT     0
     c                   seton                                        99
     C                   EXSR      CRTOPT
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     NEWRPT        BEGSR
      *          ----------------------------------------------
      *          Build MRPTDIR record with fields from original
      *          attributes and new folder pointers
      *          ----------------------------------------------
     C     @SPLTC        IFEQ      *ON
     C                   Z-ADD     SPLTP#        TOTPAG
     C                   ELSE
     C                   Z-ADD     @PGVRY        TOTPAG
     C                   ENDIF
      *    compute record pointer to folder
     c                   exsr      getfldptr

     C                   MOVE      *BLANKS       SFDESC
     C                   MOVE      @FRMTY        FRMTYP
     C                   MOVE      @HLDF         HLDF
     C                   MOVE      @SAVF         SAVF
     C                   Z-ADD     @TOTCP        TOTCPY
     C                   Z-ADD     @LPI          LPI
     C                   Z-ADD     @CPI          CPI
     C                   MOVE      @OUTQN        OUTQNM
     C                   MOVE      @OUTQL        OUTQLB
     C                   MOVE      @DATFO        DATFOP
     C                   MOVE      @TIMFO        TIMFOP
     C                   MOVE      @DEVFN        DEVFNA
     C                   MOVE      @PRTTX        PRTTXT
     C                   MOVE      @DEVCL        DEVCLS
     C                   Z-ADD     @OVRLI        OVRLIN
     C                   MOVE      @PRTFO        PRTFON
     C                   Z-ADD     @PAGRO        PAGROT
     C                   Z-ADD     @MAXSI        MAXSIZ
     C                   MOVE      *BLANKS       RECOVR
     C     NWRPIN        IFNE      *BLANKS
     C     REPIND        ANDEQ     *BLANKS
     C                   MOVE      NWRPIN        REPIND
     C                   END
     C                   MOVE      *BLANKS       RPIXNM
     C                   MOVE      *BLANKS       DFTPRT
     C                   MOVE      *BLANKS       DPDESC

     C     OPTYN         IFEQ      'Y'
     C                   MOVE      '2'           REPLOC
     C                   MOVEL     SAVEVL        OFRVOL
     C                   MOVEA     '00'          OPTN(9)
     C                   MOVEA     OPTN          OFRNAM

     C     NWAPFI        IFNE      *BLANKS
     C                   MOVEL     NWAPFI        OFRNAM
     C                   MOVE      '00'          OFRNAM
     C                   ENDIF

     C                   MOVE      YMD           YYMMDD
     C                   Z-ADD     YMMDD         CYMD              9 0
     C     YY            IFEQ      20
     C                   ADD       1000000       CYMD
     C                   END
     C                   Z-ADD     CYMD          OFRDAT
     C                   END
      *    SET APF TYPE 3=PCL, 2=OTHER WITH PAGETABLE
/9198C                   MOVE      ' '           APFTYP
/9198 * Set APFTYP for *PCL type reports when APFCFG is
/9198 *   to either "Y" or "P".
     C     NWRPIN        IFNE      *BLANKS
/9198c                   select
/9198
/9198 * all types except PCL when Adv. Print is configured
/9198c                   when      ApfCfg = 'Y' and
/9198c                             StmTyp <> '*PCL5'
/9198c                   eval      ApfTyp = '2'
/9198
/9198 * handle *PCL when Adv. Print is "Y" or "P"
/9198c                   when      (ApfCfg='Y' or ApfCfg='P') and
/9198c                             StmTyp = '*PCL5'
/9198c                   eval      ApfTyp = '3'
/9198
/9198 * in all other cases the APFTYP will remain *blank
/9198c                   endsl
/9198
     C                   ENDIF

     C                   MOVE      RTYPID        RPTTYP

/9003c                   exsr      SetHashVal
/1944c                   ExSr      SetAltAPFTyp

     C                   WRITE     RPTDIR

      * write attribute record(s) to MrptAtr file
      *  if not being run from Report Configurator (REPIND will be blank
      *  when running from Report Config.)
     c                   if        RepInd <> *blanks
T6276c                   eval      qusa0200 = prmrcvvar
/    c                   if        pagwid > quspw00
/    c                   eval      quspw00 = pagwid
/    c                   endif
T6349c                   eval      qustp00 = @totpa
/    c                   eval      prmrcvvar = qusa0200
     c                   eval      rcvvar = prmrcvvar
/8203 * force buffer size to 4079 (See note in tombstone details)
/8203c                   eval      @bufSz = 4079
     c                   eval      rc = putArcAtr(RepInd:%addr(rcvvar))
     c                   if        rc < 0
     c                   eval      @ercon = 'ARC0015'
     c                   eval      @erdta = %subst(%editc(@filnu:'Z'):
     c                               4:6) + @jobna + @usrna + @jobnu
     c                   exsr      rtvmsg
     c                   eval      log = @msgtx
     c                   exsr      errmsg
     c                   exsr      quit
     c                   endif
     c                   endif

      *  ------------------------------
      *   Do workflow   distribution
      *  ------------------------------
     C     '*SPYREP'     CAT(P)    'ORT':0       DOCTYP
     C                   CALL      'MAG8016'                            50
     C                   PARM                    DOCTYP           10
     C                   PARM      *BLANKS       BUNDLE           10
     C                   PARM      *BLANKS       SEGMNT           10
     C                   PARM      RTYPID        RPTTYP           10
     C                   PARM      'SEND'        OPCODE           10
     C                   PARM                    IV
     C                   PARM      0             STRPAG            9 0
     C                   PARM      0             ENDPAG            9 0
     C                   PARM      ' '           TYPE              1
     C                   PARM      REPIND        NAM              10
     C                   PARM      0             SEQ               9 0
     C                   PARM                    RTNCDE            7
     C                   ENDSR
     c*-------------------------------------------------------------------------
     c*- SetHashVal - determine which hash value to use in MRPTDIR
     c*-------------------------------------------------------------------------
     c     SetHashVal    begsr

      * Get Hash value from A-file (if one exists)
     c                   clear                   DtaAraDta
     c                   clear                   QwcrDRtn
     c                   clear                   Qusec
     c                   eval      QwcbAvl = %size(DtaAraDta)
     c                   eval      Qusbprv = %size(Qusec)
     c                   callp(e)  RtvDtaAra(DtaAraDta:%size(DtaAraDta):
     c                             'HASHDTAARAQTEMP     ':1:32:Qusec)
     c                   eval      QwcrDRtn = DtaAraDta
     c                   eval      DtaAraDta = %subst(DtaAraDta:
     c                             %size(QwcrDRtn)+1:%size(DtaAraDta)-
     c                             %size(QwcrDRtn))

      * if a hash value from the A-file was found then use it
      *   otherwise use the hash from the folder.
     c                   if        HashValue <> *blanks
     c                   eval      MrHash = HashValue
     c                   else
     c                   eval      MrHash = Digest16
     c                   endif

     c                   endsr
/1944 *-----------------------------------------------------------------------
/    c     SetAltAPFTyp  BegSr
/     *-----------------------------------------------------------------------
/     *    Set the alternative datastream within MRPTDIR record
/     *    Specifically overriding PCL with ASCII if the report
/     *    maintenance file specifies it as such.
/     *-----------------------------------------------------------------------
/     /free
/      If ( APFTyp = TYPE_PCL );
/        Chain (FilNam:JobNam:PgmOpf:UsrNam:UsrDta) RMaint;
/
/        If (  ( %found = TRUE     )  and
/              ( RDTSTR = STREAM_ASC )    );
/          APFTyp = TYPE_ASC;
/        EndIf;
/
/      EndIf;
/     /end-free
/    c                   EndSr
/     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPDFDR        BEGSR
      *          Update folder's INTEOF and NUMFIL

     C     FLDDKY        KLIST
     C                   KFLD                    EFLDR
     C                   KFLD                    EFLDRL
     C     FLDDKY        CHAIN     FLDDIR                             68

     C     OPTYN         IFEQ      'N'
/3512C                   CLOSE     MSPLDAT1                             69
/3512C                   OPEN      MSPLDAT1                             69
     C                   Z-ADD     bgrec1        INTEOF
     C                   END

     C     *IN68         IFEQ      *ON
     C                   MOVE      EFLDR         FLDCOD
     C                   MOVE      EFLDRL        FLDLIB
     C                   MOVE      *BLANKS       FDESC
     C     OPTYN         IFEQ      'Y'
     C                   Z-ADD     1             NUMOPT
     C                   ELSE
     C                   Z-ADD     1             NUMFIL
     C                   END
     C                   WRITE     FLDDIR

     C                   ELSE
     C                   MOVE      'Y'           ADDED1            1
     C     OPTYN         IFEQ      'Y'
     C                   ADD       1             NUMOPT
     C                   ELSE
     C                   ADD       1             NUMFIL
     C                   END
     C                   UPDATE    FLDDIR
     C                   END

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPDHDR        BEGSR
      *          Update header record of report in folder
      *          and any attribute records.
      *          Close optical header file & commit all directories.

      *                                                    ----------
     C     OPTYN         IFEQ      'N'
     C                   CLOSE     MSPLDAT1
     C                   OPEN      MSPLDAT2
     C     @LCSFH        CHAIN     MSPLDAT2                           66
     C                   MOVE      *BLANKS       DLTSTS
     C                   MOVE      TYPE0         RECFUL
     C                   EXCEPT    SPLDTU

/8058c                   if        upddu1 = 'Y'
     C     @LCSFH        ADD       1             @LCSF1           13 0
     C     @LCSF1        CHAIN     MSPLDAT2                           66
     C                   EXCEPT    SPLDU1
/8058C                   endif

     C     @LCSFH        ADD       2             @LCSF2           13 0
     C     @LCSF2        CHAIN     MSPLDAT2                           66
     C                   EXCEPT    SPLDU2

     C                   CLOSE     MSPLDAT2
     C                   MOVE      *OFF          ARCRTN
     C                   END

     C     OPTYN         IFEQ      'Y'
     c                   seton                                        10
     C                   MOVE      *OFF          ARCRTN
     C                   END

     C                   ENDSR
      **********************************************************************
     c     addopttbl     begsr

     C                   MOVEL     M90File       OPTFIL
     c                   move      M90File       f2a               2
     c                   move      f2a           f20               2 0
     c                   z-add     f20           optseq
     C                   MOVE      EFLDR         OPTFDR
     C                   MOVE      EFLDRL        OPTLIB
     C                   MOVE      M90Volume     OPTVOL
     C                   MOVEA     '00'          OPTN(9)
     C                   MOVEA     OPTN          OPTRNM
     c                   eval      opmxsz=maxfilsiz/1024000
     C                   WRITE     OPTRC

     c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DSTYN         BEGSR
      * Determine if Seg Pg Tables need to be created for Distribution
      *          Create work file containing the keys of the segments
      *          to be built

      *ADdbkp*
     C                   MOVEL(P)  CMD(20)       CMDLIN
     C                   EXSR      RUNCL

     C     CMD(21)       CAT(P)    SPYLIB:0      CMDLIN
     C                   CAT       CMD(22):0     CMDLIN
     C                   EXSR      RUNCLE

     C                   MOVEL(P)  CMD(23)       CMDLIN
     C                   EXSR      RUNCLE

     C                   OPEN      MAG1052
      *                                                    for seg keys
     C                   MOVE      *BLANKS       DST               1
     C                   MOVE      *BLANKS       RTYPID
     C                   MOVE      *BLANKS       RDSEG
     C                   MOVE      *BLANKS       RDSUBR

     C     KLBIG5        CHAIN     RMAINT                             67

     C     RTYPID        IFNE      *BLANKS
     C     RDSTKY        KLIST
     C                   KFLD                    RTYPID
     C                   KFLD                    RDSEG
     C                   KFLD                    RDSUBR
     C     RDSTKY        SETLL     RDSTDEF1

     C     *IN67         DOUEQ     *ON
     C     RTYPID        READE     DSTDEF                                 67

     C     *IN67         IFEQ      *ON
     C                   LEAVE
     C                   END

     C     RDSTAT        IFEQ      ' '
     C                   MOVE      'D'           SSTAT
     C                   MOVE      'D'           SLSTAT
     C     RDSUBR        CHAIN     RSUBLHD                            69
     C   69RDSUBR        CHAIN     RSUBSCR                            69

     C     SSTAT         IFEQ      ' '
     C     SLSTAT        OREQ      ' '
     C                   MOVE      'Y'           DST

     C     RDSEG         IFNE      LSTSEG
     C                   MOVE      RDREPT        WDREPT
     C                   MOVE      RDSEG         WDSEG
     C                   WRITE     W1052
     C                   MOVE      RDSEG         LSTSEG           10
     C                   END
     C                   END
     C                   END
     C                   ENDDO
     C                   END
      *                                                                   DSTYN
     C     DST           IFEQ      'Y'

     C     RRDESC        IFEQ      *BLANKS
     C                   MOVEL     RTYPID        RPTDES           50
     C                   ELSE
     C                   MOVEL     RRDESC        RPTDES
     C                   END

     C                   MOVEA     RPTDES        SVD
     C     #             DOUEQ     0
     C     ''''          SCAN      RPTDES        #
     C     #             IFEQ      0
     C                   LEAVE
     C                   END
     C                   MOVE      '"'           SVD(#)
     C                   MOVEA     SVD           RPTDES
     C                   ENDDO
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SEGTBL        BEGSR
      *          Create Distribution Segment work file and open it
      *          for output.  Contains:
      *            SHSFIL(Segment Phy file name) and PAGENO

     C                   MOVEL(P)  CMD(24)       CMDLIN
     C                   EXSR      RUNCL

     C     CMD(6)        CAT(P)    SPYLIB:0      CMDLIN
     C                   CAT       CMD(7):0      CMDLIN
     C                   EXSR      RUNCLE

     C     CMD(8)        CAT(P)    CMD(9):1      CMDLIN
     C                   EXSR      RUNCLE

     C                   OPEN      SEGPGTBL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CRTSEG        BEGSR
      *          Create segment page recs for distribution

     C                   MOVE      *OFF          *IN67
     C     1             SETLL     MAG1052
     C     *IN67         DOUEQ     *ON
     C                   READ      MAG1052                                67
     C     *IN67         IFEQ      *ON
     C                   LEAVE
     C                   END
     C     WDSEG         IFEQ      '*ALL'
     C                   ITER
     C                   END
     C                   EXSR      DEFSEG
     C     SEGCHK        IFEQ      'Y'
     C                   EXSR      SEGNAM
     C                   MOVE      SHSFIL        WHSFIL
     C     #P            SUB       1             WSPG
     C                   WRITE     WSEGPG
     C                   END
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DEFSEG        BEGSR
      *          Check segment rules to determine if this page belongs

     C                   MOVE      ' '           SEGCHK            1
     C     *LIKE         DEFINE    DSSEQ#        WDSEQ#
     C                   Z-ADD     0             WDSEQ#

     C     SDEFKY        KLIST
     C                   KFLD                    WDREPT
     C                   KFLD                    WDSEG
     C                   KFLD                    WDSEQ#
     C     SDCMP         KLIST
     C                   KFLD                    WDREPT
     C                   KFLD                    WDSEG

     C     SDEFKY        SETLL     RSEGDEF

     C     *IN61         DOUEQ     *ON
     C     SDCMP         READE     SEGDEF                                 61
     C   61              LEAVE

     C     DSGRP         IFEQ      'O'
     C     SEGCHK        IFEQ      'Y'
     C                   LEAVE
     C                   END
     C                   MOVE      ' '           SEGCHK
     C                   END

     C     SEGCHK        IFNE      'N'
     C                   MOVE      'DSTSEG'      SUBR              6
     C                   EXSR      GETFLD
     C     *IN50         IFNE      *ON
     C                   MOVE      'N'           SEGCHK
     C                   ITER
     C                   END

      *   If justification is defined, go for it
     C     JUSTIF        IFEQ      'L'
     C     JUSTIF        OREQ      'R'
     C                   Z-ADD     IKLEN         JSTLEN            5 0
     C                   MOVEA(P)  FLD           JSTVAL           99
     C                   EXSR      DOJUST
     C                   CLEAR                   FLD
     C                   MOVEA     JSTVAL        FLD
     C                   ENDIF

     C                   EXSR      CHKFLD
     C     *IN50         IFNE      *ON
     C                   MOVE      'N'           SEGCHK
     C                   ITER
     C                   ELSE
     C                   MOVE      'Y'           SEGCHK
     C                   END

     C                   END
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETFLD        BEGSR
      *          Get field location from RINDEX and retrieve
      *          its contents from the @PAG (page in memory)

     C                   MOVE      *BLANKS       FLD

     C     '@'           CHECK     DSRFLD        $@                2 0
     C     $@            IFEQ      1
     C                   MOVEL     DSRFLD        NDXFLD            9
     C     '@'           CAT       NDXFLD:0      DSRFLD
     C                   END

     C     SUBR          IFEQ      'DSTSEG'
     C     RNDXDS        CHAIN     RINDEX                             60
     C                   ELSE
     C     RNDXKY        CHAIN     RINDEX                             60
     C                   ENDIF
     C     *IN60         IFEQ      *ON
     C                   MOVE      *OFF          *IN50
     C                   GOTO      EFLD
     C                   END
      *   Reset masking fields
     C                   CLEAR                   MSK
     C                   CLEAR                   MSKLEN
     C                   CLEAR                   MSKNUM
     C                   CLEAR                   MSKALF
     C                   CLEAR                   MSKWLD
     C                   CLEAR                   MSKLEN
      *   Take care of double use of iloc
     C                   MOVEL(P)  'DBIN '       CVTMOD            5
     C                   EXSR      CVTLOC

     C                   MOVE      *OFF          *IN50
     C     IPMTL         IFEQ      0
     C                   Z-ADD     ISCOL         $S                3 0
     C                   Z-ADD     IPLN#         $P                3 0
     C                   MOVEA     @PAG($P)      LIN
     C                   MOVE      *ON           *IN50

     C                   ELSE
     C                   Z-ADD     IPMTEL        $EL               3 0
     C                   Z-ADD     IPMTEC        $EC               3 0
     C                   Z-ADD     IPMTSL        $SL               3 0
     C                   Z-ADD     IPMTSC        $SC               3 0
     C                   MOVE      IPRMPT        LPRMPT           30
     C     LO:UP         XLATE     LPRMPT        UPRMPT           30
     C                   MOVE      UPRMPT        IPRMPT
      *   Check for masking
     C                   MOVEL     IPRMPT        F5A               5
     C     F5A           IFEQ      '*MASK'
      *        Convert prompt to mask values
     C                   CALL      'SPYMASK'                            50
     C                   PARM      'TOMASK'      MSKOPC           10
     C                   PARM                    IPRMPT
     C                   PARM                    MSK              18
     C                   PARM                    MSKNUM            1
     C                   PARM                    MSKNBL            1
     C                   PARM                    MSKALF            1
     C                   PARM                    MSKWLD            1
     C     ' '           CHECKR    MSK           MSKLEN            3 0
     C                   Z-ADD     MSKLEN        IPMTL
     C                   ENDIF


     C     $EL           IFEQ      999
     C                   Z-ADD     L             $EL
     C                   END
     C     $EC           IFEQ      999
     C                   Z-ADD     247           $EC
     C                   END

     C     $SL           DO        $EL           $N                3 0
     C                   MOVEA     @PAG($N)      LINE            247
     C                   Z-ADD     IPMTL         $L                3 0

     C     MSK           IFNE      *BLANKS
     C                   EXSR      SCNMSK
     C                   ELSE
     C                   EXSR      SCNREG
     C                   ENDIF
      *                                                    end col for GETFLD
     C     *IN50         IFEQ      *ON
     C     $FE           ANDGT     $EC
     C     *IN50         OREQ      *OFF
     C                   MOVE      *OFF          *IN50
     C                   ITER
     C                   END

     C     IPMTRC        ADD       $FS           $S
     C     IPMTRL        ADD       $N            $P                3 0
     C                   MOVEA     @PAG($P)      LIN
     C                   LEAVE
     C                   ENDDO
     C                   END

     C     *IN50         IFEQ      *ON
     C     IKLEN         ADD       1             $K                3 0
     C                   MOVEA     LIN($S)       FLD(1)
     C                   MOVEA     *BLANKS       FLD($K)
     C                   END

     C     IINDA         IFEQ      'C'
     C                   Z-ADD     1             #D                2 0
     C     DSRFLD        LOOKUP    DF(#D)                                 60
     C     *IN60         IFEQ      *OFF
     C                   Z-ADD     1             #D
     C     BLNK10        LOOKUP    DF(#D)                                 60
     C                   MOVE      DSRFLD        DF(#D)
     C                   END

     C     #D            OCCUR     DSF
      *                                                    Lstfld
     C                   MOVEA     FLD           FLDC
     C     FLDC          IFEQ      *BLANKS
     C     LSTFLD        ANDNE     *BLANKS
     C                   MOVEA     LSTFLD        FLD
     C                   END

     C     FLDC          IFNE      *BLANKS
     C                   MOVE      FLDC          LSTFLD
     C                   END

     C                   MOVEA     FLD           FLDC
     C     FLDC          IFNE      *BLANKS
     C                   MOVE      *ON           *IN50
     C                   END

     C                   END
     C     EFLD          ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SCNMSK        BEGSR

      *    Scan line for mask prompt
     C     $EC           SUB       MSKLEN        MAX               3 0
     C                   ADD       1             MAX

     C                   CLEAR                   INVLD
     C                   CLEAR                   $FS

     C     $SC           DO        MAX           IX                5 0
     C                   CLEAR                   INVLD
     C                   Z-ADD     IX            SP                3 0
     C                   DO        MSKLEN        MP                3 0
     C     1             SUBST     LINE:SP       F1A               1
     C     1             SUBST     MSK:MP        F1M               1
     C                   SELECT
     C     F1M           WHENEQ    MSKALF
      *   For alfa it has to be nonblank and not numeric
     C     F1A           IFEQ      X'40'
     C     F1A           OREQ      X'41'
     C     F1A           ORGE      '0'
     C     F1A           ANDLE     '9'
     C                   MOVE      '1'           INVLD             1
     C                   LEAVE
     C                   ENDIF
      *   For numeric only 0-9 is allowed
     C     F1M           WHENEQ    MSKNUM
     C     F1A           IFLT      '0'
     C     F1A           ORGT      '9'
     C                   MOVE      '1'           INVLD             1
     C                   LEAVE
     C                   ENDIF
      *   Wildcard takes everything
     C     F1M           WHENEQ    MSKWLD
      *   Nonblank allows everything else than ' ' and x'41'
     C     F1M           WHENEQ    MSKNBL
     C     F1A           IFEQ      ' '
     C     F1A           OREQ      X'41'
     C                   MOVE      '1'           INVLD             1
     C                   LEAVE
     C                   ENDIF
     C                   OTHER
      *   Everything else compare character by character
     C     F1M           IFNE      F1A
     C                   MOVE      '1'           INVLD             1
     C                   LEAVE
     C                   ENDIF
     C                   ENDSL
     C                   ADD       1             SP
     C                   ENDDO
      *   Check was ok, prompt was found
     C     INVLD         IFNE      '1'
     C                   Z-ADD     IX            $FS
     C     $FS           ADD       MSKLEN        $FE               3 0
     C                   SUB       1             $FE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

      *                                                                   SCNMSK
     C     INVLD         IFEQ      '1'
     C                   SETOFF                                       50
     C                   ELSE
     C                   SETON                                        50
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SCNREG        BEGSR

/8602 * fix for lowercase prompt data
/8602c     *like         define    Line          Line_up
/8602c     LO:UP         Xlate     Line          Line_up

      *  Scan for regular prompt in one line
     C                   Z-ADD     0             $FS               3 0
/8602C     IPRMPT:$L     SCAN      LINE_up:$SC   $FS                      50
     C     $FS           ADD       $L            $FE               3 0
     C                   SUB       1             $FE
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKFLD        BEGSR
      *          Compare data found on report with the user-defined
      *          compare operator to the user-supplied value.

     C                   MOVE      *OFF          *IN50
     C                   MOVEA     FLD           FLDC             40

     C     ''''          CHECK     DSVAL         $LS               2 0
     C     $LS           IFEQ      2
     C     ' '           CHECKR    DSVAL         $LS
     C                   MOVEA     DSVAL         DV
     C                   MOVEA     *BLANKS       DV($LS)
     C                   MOVEA(P)  DV(2)         DSVAL
     C                   END

      *   If justification is defined, go for it
     C     JUSTIF        IFEQ      'L'
     C     JUSTIF        OREQ      'R'
     C                   Z-ADD     IKLEN         JSTLEN            5 0
     C                   MOVEL(P)  DSVAL         JSTVAL           99
     C                   EXSR      DOJUST
     C                   MOVEL(P)  JSTVAL        DSVAL
     C                   ENDIF


     C                   SELECT
     C     DSOPER        WHENEQ    'EQ'
     C     FLDC          IFEQ      DSVAL
     C                   MOVE      *ON           *IN50
     C                   END
     C     DSOPER        WHENEQ    'NE'
     C     FLDC          IFNE      DSVAL
     C                   MOVE      *ON           *IN50
     C                   END
     C     DSOPER        WHENEQ    'GT'
     C     FLDC          IFGT      DSVAL
     C                   MOVE      *ON           *IN50
     C                   END
     C     DSOPER        WHENEQ    'GE'
     C     FLDC          IFGE      DSVAL
     C                   MOVE      *ON           *IN50
     C                   END
     C     DSOPER        WHENEQ    'LT'
     C     FLDC          IFLT      DSVAL
     C                   MOVE      *ON           *IN50
     C                   END
     C     DSOPER        WHENEQ    'LE'
     C     FLDC          IFLE      DSVAL
     C                   MOVE      *ON           *IN50
     C                   END
     C     DSOPER        WHENEQ    'CT'
     C     DSOPER        OREQ      'DC'
     C     ' '           CHECKR    DSVAL         $LS
     C     DSVAL:$LS     SCAN      FLDC:1        $SC                      49
     C     DSOPER        IFEQ      'CT'
     C     *IN49         ANDEQ     *ON
     C                   MOVE      *ON           *IN50
     C                   END
     C     DSOPER        IFEQ      'DC'
     C     *IN49         ANDNE     *ON
     C                   MOVE      *ON           *IN50
     C                   END
      *     LIKE/NOT LIKE
     C     DSOPER        WHENEQ    'LK'
     C     DSOPER        OREQ      'NL'
     C                   EXSR      LIKE
     C     LIKEOK        IFEQ      '1'
     C     DSOPER        ANDEQ     'LK'
     C     LIKEOK        ORNE      '1'
     C     DSOPER        ANDEQ     'NL'
     C                   MOVE      *ON           *IN50
     C                   ENDIF
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LIKE          BEGSR
      *          -------------------------------------------
      *          LIKE/NLIKE Test. If OK set LIKEOK='1'
      *          -------------------------------------------
     C                   CALL      'SPYLIKE'                            50
     C                   PARM      DSVAL         VALUE            30
     C                   PARM      FLDC          REALV            99
     C                   PARM                    LIKEOK            1

     C     ENDLIK        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SEGNAM        BEGSR
      *          Get SHSFIL, database file name for segment,"Pxxxx

     C                   MOVE      *BLANKS       SHSFIL

     C     RSEGKY        CHAIN     RSEGHDR                            69

/2074C                   If        NOT %found
/    C                   Eval      @ercon = 'ERR1169'
/    C                   Eval      @erdta = *blanks
/    C                   ExSr      RtvMsg
/    C                   Eval      log = @msgTx
/    C                   ExSr      ErrMsg
/    C                   Eval      *inlr = *on
/    C                   Return
/    C                   EndIf

     C     RSEGKY        KLIST
     C                   KFLD                    WDREPT
     C                   KFLD                    WDSEG
     C     SHSFIL        IFEQ      *BLANKS
     C                   CALL      'GETNUM'
     C                   PARM      'GET'         GETOP
     C                   PARM      'SEGFIL'      GETTYP
     C                   PARM                    SHSFIL
     C                   UPDATE    SEGHDR
     C                   ELSE
     C                   UNLOCK    RSEGHDR
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADDSEG        BEGSR
      *          Transfer segment records from the work file SegPgTbl
      *          to the true physical file member.
      *                                                    Segment flds
      *                                                    ------------
     C                   Z-ADD     0             #P               10 0
     C                   Z-ADD     0             #PT              10 0
     C                   MOVE      *ZEROS        PG
     C                   CLOSE     SEGPGTBL
      *                                                    DltOvr
     C                   MOVEL(P)  CMD(25)       CMDLIN
     C                   EXSR      RUNCLE
      *                                                    OvrDbf
     C     CMD(8)        CAT(P)    CMD(26):1     CMDLIN
     C                   EXSR      RUNCLE
      *                                                    OpnQryF
     C                   MOVEL(P)  CMD(27)       CMDLIN
     C                   EXSR      RUNCLE

     C                   OPEN      SEGPGTBL
     C                   EXSR      MONMSG
     C                   MOVEL     REPIND        SGREP
      *                                                    output key.
     C                   MOVE      *OFF          *IN67
     C     *IN67         DOUEQ     *ON
     C                   READ      SEGPGTBL                               67
     C     *IN67         IFEQ      *ON
     C     PG(1)         IFGT      0
     C                   EXSR      SGWTR
     C                   END
     C                   LEAVE
     C                   END

     C     WHSFIL        IFNE      LHSFIL
     C     PG(1)         CASGT     0             SGWTR
     C                   ENDCS
     C                   CLOSE     RSEGMNT
     C                   MOVEL(P)  CMD(28)       CMDLIN
     C                   EXSR      RUNCL

     C                   MOVE      *BLANKS       SEGDES           50
     C     WHSFIL        CHAIN     RSEGHDR2                           69
     C     SEGDES        IFEQ      *BLANKS
     C                   MOVEL(P)  SHSEG         SEGDES
     C                   ELSE
     C                   MOVEL(P)  SHDESC        SEGDES
     C                   END

     C                   MOVEA     SEGDES        SVD
     C     #             DOUEQ     0
     C     ''''          SCAN      SEGDES        #
     C     #             IFEQ      0
     C                   LEAVE
     C                   END
     C                   MOVE      '"'           SVD(#)
     C                   MOVEA     SVD           SEGDES
     C                   ENDDO

     C     WHSFIL        CAT(P)    DTALIB        OBJLIB
      *                                                                   ADDSEG
     C                   CALL      'QUSROBJD'
     C                   PARM                    ROBVAR            8
     C                   PARM      8             RCVLEN
     C                   PARM      'OBJD0100'    OBJFMT            8
     C                   PARM                    OBJLIB           20
     C                   PARM      '*FILE'       OBJTYP           10
     C                   PARM                    RETCD

     C     RTCD          IFNE      0
     C                   Z-ADD     0             RTCD
     C     CMD(10)       CAT(P)    SPYLIB:0      CMDLIN
     C                   CAT       CMD(11):0     CMDLIN
     C                   CAT       DTALIB:0      CMDLIN
     C                   CAT       CMD(12):0     CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(13):0     CMDLIN
     C                   CALL      'MAG1030'
     C                   PARM                    CRTRTN            1
     C                   PARM      DTALIB        CRTLIB           10
     C                   PARM      WHSFIL        CRTOBJ           10
     C                   PARM      '*FILE'       CRTTYP           10
     C                   PARM      CMDLIN        CRTCMD          255

     C     CRTRTN        IFNE      ' '
     C                   MOVE      *ON           *IN50

     C                   ELSE
     C     CMD(18)       CAT(P)    DTALIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(19):0     CMDLIN
     C                   CAT       SEGDES:0      CMDLIN
     C                   CAT       CMD(16):0     CMDLIN
     C                   EXSR      RUNCL
      *                                                    Rename mbr
     C     CMD(14)       CAT(P)    DTALIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(15):0     CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(13):0     CMDLIN
     C                   EXSR      RUNCL
      *                                                    Change desc
     C     CMD(42)       CAT(P)    DTALIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(43):0     CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(44):0     CMDLIN
     C                   CAT       SEGDES:0      CMDLIN
     C                   CAT       CMD(16):0     CMDLIN
     C                   EXSR      RUNCL
     C                   END
     C                   END

     C     WHSFIL        CAT(P)    DTALIB        OBJLIB
     C                   CALL      'QUSRMBRD'
     C                   PARM                    ROBVAR
     C                   PARM      8             RCVLEN
     C                   PARM      'MBRD0100'    OBJFMT
     C                   PARM                    OBJLIB
     C                   PARM                    WHSFIL
     C                   PARM      '0'           QUSOVR            1
     C                   PARM                    RETCD
     C     RTCD          IFNE      0
     C     CMD(39)       CAT(P)    DTALIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(40):0     CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(41):0     CMDLIN
     C                   CAT       SEGDES:0      CMDLIN
     C                   CAT       CMD(16):0     CMDLIN
     C                   EXSR      RUNCL
     C                   ENDIF
      *                                                    OvrDbf
     C     CMD(17)       CAT(P)    DTALIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       WHSFIL:0      CMDLIN
     C                   CAT       CMD(13):0     CMDLIN
     C                   EXSR      RUNCLE

     C                   OPEN      RSEGMNT
     C                   Z-ADD     0             SGSEQ
     C                   Z-ADD     0             #P               10 0
     C                   Z-ADD     0             #PT              10 0
     C                   MOVE      *ZEROS        PG
     C                   MOVE      WHSFIL        LHSFIL           10
     C                   END
      *                                                                   ADDSEG
     C                   ADD       1             #PT
     C                   Z-ADD     WSPG          PG(#PT)
     C     #PT           IFEQ      63
     C                   EXSR      SGWTR
     C                   Z-ADD     0             #PT
     C                   END

     C                   ENDDO

     C                   CLOSE     SEGPGTBL
     C                   CLOSE     RSEGMNT
     C                   CLOSE     MAG1052

     C                   MOVEL(P)  CMD(29)       CMDLIN
     C                   EXSR      RUNCLE
     C                   MOVEL(P)  CMD(25)       CMDLIN
     C                   EXSR      RUNCLE
     C                   MOVEL(P)  CMD(24)       CMDLIN
     C                   EXSR      RUNCL
     C                   MOVEL(P)  CMD(28)       CMDLIN
     C                   EXSR      RUNCL
     C                   MOVEL(P)  CMD(30)       CMDLIN
     C                   EXSR      RUNCL
     C                   MOVEL(P)  CMD(20)       CMDLIN
     C                   EXSR      RUNCL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SGWTR         BEGSR
      *          Write segment page table record to the member
     C                   ADD       1             SGSEQ
     C                   Z-ADD     PG            PGT
     C                   WRITE     SEGREC
     C                   Z-ADD     0             PG
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     VERSID        BEGSR

      *   Get the next SPY Report ID number
     C     NWRPIN        IFNE      *BLANK
     C                   MOVE      NWRPIN        REPIND
     C                   ELSE
     C                   CALL      'GETNUM'
     C                   PARM      'GET'         GETOP
     C                   PARM      'REPIND'      GETTYP
     C                   PARM                    REPIND
     C                   END

      *   Get optical filename
     c                   if        optyn='Y'
     C     NWAPFI        IFEQ      *BLANKS
     C                   EXSR      OPTNAM
     C                   ELSE
     C                   MOVEA     NWAPFI        OPTN
     C                   MOVEA     '  '          OPTN(9)
     C                   ENDIF
     C                   endif

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPTNAM        BEGSR
      *          Get Optical SPY name for writing report to Optical
     C                   CALL      'GETNUM'
     C                   PARM      'GET'         GETOP             6
     C                   PARM      'OPTNAM'      GETTYP           10
     C                   PARM                    NEWVAL           10
     C                   MOVEA     NEWVAL        OPTN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CRTOPT        BEGSR
      *          Create dir,open optfil, write the array OPT to optical

     C     @RFBYT        IFLE      @TBYTE
     C                   ADD       1             @SF
     C                   MOVE      @SF           @SFC              2
     C                   MOVEA     @SFC          OPTN(9)
     C                   MOVEA     OPTN          FILE10           10
     C                   MOVEL     OPTV          VOL              12

     c                   eval      M90dir='/SPYGLASS/'+
     c                                  %trim(efldrl) + '/' +
     c                                  %trim(efldr)
     c                   eval      M90File=file10
     c                   eval      M90Volume =vol
     C                   END

     C                   Z-ADD     @RBYTE        m90dtasiz
     C                   EXSR      WRTOPT
     C                   ADD       bufferlen     SZ
     C                   MOVE      *BLANKS       OPT
     C                   Z-ADD     0             @RBYTE
     C                   Z-ADD     0             ZZ
      *    If filename has changed, write out record to mopttbl
     c                   if        m90file<>lastfile
     c                   exsr      addopttbl
     c                   movel     m90file       lastfile         10
     c                   endif

     C     *IN99         IFEQ      *ON
     C     ENDDIS        ANDEQ     'Y'
     C                   EXSR      CLSOPT
     C                   Z-ADD     0             @RFBYT
     C                   END

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSOPT        BEGSR
      *          Close optical stream file

     c                   clear                   m90dtasiz
     c                   move      '1'           m90clspgm
     c                   call      'MAG1090'     pl1090                 50
     c                   move      ' '           m90clspgm

     c                   if        m90rtncde<>'0'  or
     c                             *in50
     C                   EXSR      errcls
     C                   END
      *     16mb chunk has been written, compute new alocation
     c                   move      M90Aloc       M90FilSiz
      *                                                    ------------
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRTOPT        BEGSR
      *          Write to the Optical file

     c     pl1090        plist
     C                   parm                    M90Drive         15
     C                   parm                    M90Volume        12
     C                   parm                    M90Aloc          13 0
     C                   parm                    M90Dir           80
     C                   parm                    M90File          10
     C                   parm                    M90FilSiz        13
     C                   parm                    M90Dta
     C                   parm                    M90DtaSiz         6 0
     C                   parm                    M90ClsPgm         1
     C                   parm                    M90RtnCde         1

     c                   clear                   totalwrt
     c                   movea     opt(1)        M90Dta(1)
     c                   z-add     M90DtaSiz     BufferLen         6 0
     c                   if        bufferlen>131072
     c                   eval      m90dtasiz=131072
     c                   call      'MAG1090'     pl1090                 50
      *    Error occured
     c                   if        M90RtnCde <> '0' or
     c                             *in50
     c                   exsr      errwrt
     c                   endif
     c                   add       m90dtasiz     totalwrt         13 0
     c                   movea     opt(513)      M90Dta(1)
     c                   eval      M90DtaSiz=Bufferlen-131072
     c                   endif

      *        Write out rest of buffer
     c                   call      'MAG1090'     pl1090                 50
     c                   add       m90dtasiz     totalwrt         13 0
      *        Save return volume
     c                   if        m1090opn=' '
     C                   move      m90volume     VOL              12
     C                   move      m90volume     SAVEVL           12
     C                   move      m90volume     Volume           12
     c                   move      '1'           m1090opn          1
     c                   add       1             of#               3 0
     c                   endif

      *    Bytes 2 write and bytes written are not the same
     c                   if        totalwrt <> Bufferlen  or
     c                             M90RtnCde <> '0' or
     c                             *in50
     c                   exsr      errwrt
     c                   endif
/7622c******             sub       totalwrt      m90aloc
      *                                                    ------------
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     EXITER        BEGSR
      *          Send terminal error msg & return
     C                   EXSR      QUIT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETBAR        BEGSR
      *          Set up status bar variables

     C                   MOVE      *BLANKS       FLSIZ
     C     BGREC2        MULT      256           @SZ               9 0
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
     C                   ELSE
     C     @THOU         IFLT      100
     C                   MOVEL     ' '           @TH
     C                   END
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
     C     ERRVER        BEGSR
      *          Error verifing bytes written to get file size

     C                   MOVEL     MSGE(8)       @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   EXSR      CLSOPT
     C                   EXSR      QUIT
     C                   ENDSR
      *****************************************************************
     C     ERRWRT        BEGSR
      *          Error writing to optical
     C                   EXSR      CLSOPT
     C                   EXSR      QUIT
     C                   ENDSR
      *****************************************************************
     C     ERRCLS        BEGSR
      *          Error closing optical file
     C                   EXSR      QUIT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ERRCPS        BEGSR
      *          Retrieve errors from compression routine
     C                   MOVEL     MSGE(6)       @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   EXSR      CLSOPT
     C                   EXSR      QUIT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MAG901        BEGSR
      *          Call MAG901, the transaction logger.

     C     CONFIG        IFNE      'C'
     C     KLBIG5        CHAIN     RMAINT                             67

     C                   CALL      'MAG901'                             81
     C                   PARM      *BLANK        LOGRTN            1
     C                   PARM      *BLANK        DLSUB            10
     C                   PARM      RTYPID        DLREPT           10
     C                   PARM      *BLANK        DLSEG            10
     C                   PARM      REPIND        DLREP            10
     C                   PARM      *BLANK        DLBNDL           10
     C                   PARM      'A'           DLTYPE            1
     C                   PARM      @TOTPA        DLTPGS            9 0
     C                   PARM      'MAG1052'     DLPROG           10
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVMSG        BEGSR
      *          Retrieve message from PSCON
     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVMS2        BEGSR
      *          Retrieve Messages from QCPFMSG in QSYS

     C     MSGPRM        PLIST
     C                   PARM                    @MSGDT
     C                   PARM                    MSGL
     C                   PARM                    MSGFMT
     C                   PARM                    CONDTM
     C                   PARM                    MSGFIL
     C                   PARM                    MSGDTM
     C                   PARM                    MSGDTL
     C                   PARM                    MSGSUB
     C                   PARM                    MSGCTL
     C                   PARM                    MSGCD

     C                   Z-ADD     104           MSGL
     C                   Z-ADD     100           MSGDTL
     C                   MOVE      CONDTN        CONDTM
     C                   MOVE      'RTVM0100'    MSGFMT            8
     C                   MOVEL(P)  'QCPFMSG'     MSGFIL           20
     C                   MOVEL(P)  'QSYS'        TEMP10           10
     C                   MOVE      TEMP10        MSGFIL
     C                   MOVEL     '*YES'        MSGSUB           10
     C                   MOVEL     '*NO'         MSGCTL           10

     C                   CALL      'QMHRTVM'     MSGPRM                   50

     C     ERRLEN        ADD       1             #T                3 0
     C                   MOVEA     *BLANKS       @EM(#T)
     C                   MOVEA     @EM           OPTMSG           80
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ERRMSG        BEGSR
      *          Terminal messages from return codes. Send msg to outq

     C     MANUAL        IFEQ      'M'
     C                   MOVE      *BLANKS       LOG50B           50
     C                   MOVE      *BLANKS       LOG50            50
     C                   MOVEA(P)  LOG           $LG
     C                   Z-ADD     50            $G                2 0
     C     $G            DOUEQ     1
     C     $LG($G)       IFEQ      ' '
     C     $G            OREQ      0
     C                   ADD       1             $G
     C                   MOVEA     $LG($G)       LOG50B
     C                   MOVEA     *BLANKS       $LG($G)
     C                   MOVEA     $LG(1)        LOG50
     C                   LEAVE
     C                   END
     C                   SUB       1             $G
     C                   ENDDO

     C                   EXFMT     ERROR
     C                   ELSE

     C     LOGPRM        PLIST
     C                   PARM                    LOG              80
     C                   CALL      'LOGMSGQ'     LOGPRM                   50
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *PSSR         BEGSR
      *          Sys program exception error.  Send msg to outq.
     C                   MOVE      PGMERR        PGMERC            5
     C                   MOVEL     MSGE(1)       @ERCON
     C                   MOVEL     PGMERC        @ERDTA
     C                   MOVEA     SYSERR        @ED(6)
     C                   MOVEA     PGMLIN        @ED(13)
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        LOG
     C                   EXSR      ERRMSG
     C                   EXSR      QUIT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
      *          Shut down program abnormally: terminal error

     C     RPTDKY        CHAIN     RPTDIR                             6767
     c                   if        *in67 = *off
     c                   eval      rc = delArcAtr(Repind)
     C                   DELETE    RPTDIR
     c                   endif

     C     ADDED1        IFEQ      'Y'
     C     FLDDKY        CHAIN     FLDDIR                             6868
     C     *IN68         IFEQ      *OFF
     C     OPTYN         IFEQ      'Y'
     C                   SUB       1             NUMOPT
     C                   ELSE
     C                   SUB       1             NUMFIL
     C                   END
     C                   UPDATE    FLDDIR
     C                   END
     C                   END

     C                   MOVE      'Q'           LIKEOK
     C                   EXSR      LIKE

      * close files (MaAltKey module)
     c                   eval      rc = ClsSplCfg

     C     ARCKY         DELETE    ARCRC                              6767
     C                   CALL      'GETNUM'
     C                   PARM      'QUIT'        GETOP
     C                   CLOSE     *ALL
     C                   exsr      shutdwn
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SHUTDWN       BEGSR
      *          Shut down program

     c                   callp     endMADB

     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCLE        BEGSR
      *          --------------------------------------
      *          Run a Cl command not monitoring errors
      *          --------------------------------------
     C                   CALL      'QCMDEXC'     PLCMD
     C     PLCMD         PLIST
     C                   PARM                    CMDLIN          255
     C                   PARM      255           STRLEN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
      *          --------------------------------------
      *          Run a Cl command monitoring errors
      *          --------------------------------------
     C                   CALL      'QCMDEXC'     PLCMD                  22
      *                                   Plcmd = cmdlin strlen
     C     *IN22         IFEQ      *ON
     C                   EXSR      MONMSG
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MONMSG        BEGSR
     C                   EXSR      RCVMSG
     C                   EXSR      RCVMSG
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DOJUST        BEGSR
     C     JSTVAL        IFNE      *BLANKS
     C     ' '           CHECK     JSTVAL        JSTFRM            3 0
     C     ' '           CHECKR    JSTVAL        JSTTO             3 0
      *  First allways left justify it
     C     JSTTO         SUB       JSTFRM        JL                5 0
     C                   ADD       1             JL
     C                   Z-ADD     JSTFRM        JF                5 0
     C     JL            SUBST(P)  JSTVAL:JF     JSTVAL
      *  If right justification is reqired, do it
     C     JUSTIF        IFEQ      'R'
     C     JSTLEN        SUB       JL            JL
     C     JL            IFLT      0
     C                   CLEAR                   JL
     C                   ENDIF
     C                   CLEAR                   F100A
     C                   CAT       JSTVAL:JL     F100A           100
     C                   MOVEL(P)  F100A         JSTVAL
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RCVMSG        BEGSR
     C                   CALL      'QMHRCVPM'
     C                   PARM                    MSGINF
     C                   PARM      100           INFLEN
     C                   PARM      'RCVM0100'    FORMAT            8
     C                   PARM      '*'           RCVPGM           20
     C                   PARM      0             STKCNT
     C                   PARM      '*LAST'       MSGTYP           10
     C                   PARM                    MSGKY             4
     C                   PARM      *LOVAL        WAIT              4
     C                   PARM      '*REMOVE'     RCVACT           10
     C                   PARM                    ERRCD
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MOVAPF        BEGSR
      *     If folder has changed, make sure, that apf data move from
      *     Orgfld to the new afldr. this needs to be done, because
      *     The afp data are written out to the a000.. file by magsplf
      *     Or magasci prior to this event.

     C     KEYORG        KLIST
     C                   KFLD                    ORGFLD
     C                   KFLD                    ORGFLB
     C     KEYORG        CHAIN(N)  MFLDDIR                            50
     C                   MOVEL     APFNAM        ORGAPF           10
     C     FLDDKY        CHAIN(N)  FLDDIR                             50

     C                   CALL      'MAG1070'
     C                   PARM      'M'           @OPER             1
     C                   PARM      ORGAPF        FRMAPF           10
     C                   PARM      ORGFLB        FRMFLB           10
     C                   PARM      REPIND        FRMREP           10
     C                   PARM      APFNAM        TOAPF            10
     C                   PARM      EFLDRL        TOFLB            10
     C                   PARM      REPIND        TOREP            10
      *  If a000.. file has changed, use new name
     C     APFNAM        IFNE      TOAPF
     C     FLDDKY        CHAIN     FLDDIR                             50
     C                   MOVE      TOAPF         APFNAM
     C  N50              UPDATE    FLDDIR
     C                   ENDIF

     C                   ENDSR
      *==============================================================
     C     ARCKY         KLIST
     C                   KFLD                    EFLDR
     C                   KFLD                    EFLDRL
     C                   KFLD                    @FILNA
     C                   KFLD                    @JOBNA
     C                   KFLD                    @USRNA
     C                   KFLD                    @JOBNU
     C                   KFLD                    @FILNU
     C                   KFLD                    DATFOP
/9118
/9118C     KLBIG5        KLIST
/9118C                   KFLD                    FILNAM
/9118C                   KFLD                    JOBNAM
/9118C                   KFLD                    PGMOPF
/9118C                   KFLD                    USRNAM
/9118C                   KFLD                    USRDTA

      *      MSpl Dat is the Folder
     OMSPLDAT1  E            SPLDAT
     O               81      RECTYP               1
     O               81      RECFUL             256
     O              N81      OUTREC             256

     OMSPLDAT2  E            SPLDTU
     O                       RECTYP               1
     O                       RECFUL             256

     O          E            SPLDU1
     O                       @TOTPA             153B

     O          E            SPLDU2
     O                       PAGLEN             182B
     O                       PAGWID             186B
     O                       @OVRLI             194B

     OPAGETBL   EADD         TBLDAT
/2272O                       PGTAB              252
/2272O                       PGTBTY             253

     OPACKTBL   EADD         PAKDAT
/2272O                       CPTAB              252
/2272O                       PGTBTY             253

     OTICKLER   E            TICKLR
     O                       EFLDR               20
     O                       EFLDRL              30
     O                       FILNAM              40
     O                       JOBNAM              50
     O                       USRNAM              60
     O                       JOBNUM              66
/6708O                       DATFOP              70B
     O                       FILNUM              79
     O                       MSGTO               80
** CMD  CL Command lines
DLTF FILE(QUSRTEMP/                                         1
CRTPF SIZE(*NOMAZ) SHARE(*NO) RCDLEN(256) FILE(QUSRTEMP/    2
) TEXT('SPY Optical temp file') OPTION(*NOSRC *NOLIST)      3
                                                            4
                                                            5
CRTDUPOBJ OBJ(SEGPGTBL) FROMLIB(                            6
) OBJTYPE(*FILE) TOLIB(QTEMP)                               7
OVRDBF FILE(SEGPGTBL) TOFILE(QTEMP/SEGPGTBL)                8
NBRRCDS(2000) SEQONLY(*YES 2000) FRCRATIO(2000)             9
CRTDUPOBJ OBJ(RSEGMNT) OBJTYPE(*FILE) DATA(*YES) FROMLIB(   10
) TOLIB(                                                    1
) NEWOBJ(                                                   2
)                                                           3
RNMM MBR(RSEGMNT) FILE(                                     4
) NEWMBR(                                                   5
')                                                          6
OVRDBF SEQONLY(*NO) FILE(RSEGMNT) MBR(*FIRST) TOFILE(       7
CHGPF FILE(                                                 8
) TEXT('                                                    9
DLTF FILE(QTEMP/MAG1052)                                    20
CRTDUPOBJ OBJ(MAG1052) FROMLIB(                             1
) OBJTYPE(*FILE) TOLIB(QTEMP)                               2
OVRDBF FILE(MAG1052) TOFILE(QTEMP/MAG1052)                  3
DLTF FILE(QTEMP/SEGPGTBL)                                   4
DLTOVR FILE(SEGPGTBL)                                       5
NBRRCDS(2000) SHARE(*YES)                                   6
OPNQRYF FILE((QTEMP/SEGPGTBL)) KEYFLD((WHSFIL))             7
DLTOVR FILE(RSEGMNT)                                        8
CLOF OPNID(SEGPGTBL)                                        9
DLTOVR FILE(MAG1052)                                        30
CRTPF SIZE(*NOMAX) SHARE(*NO) RCDLEN(256) FILE(             1
) TEXT('SPY Optical Trace file') OPTION(*NOSRC *NOLIST)     2
ALCOBJ OBJ((SPYVCT *PGM *EXCL)) WAIT(300)                   3
DLCOBJ OBJ((SPYVCT *PGM *EXCL))                             4
SAVHLDOPTF FROMPATH('                                       5
') TOPATH('                                                 6
') RELEASE(*YES)                                            7
RLSHLDOPTF PATH('                                           8
ADDPFM FILE(                                                9
) MBR(                                                      40
) TEXT('                                                    1
CHGPFM FILE(                                                2
) MBR(                                                      3
) TEXT('                                                    4
OVRDBF FILE(DISP2) TOFILE(QTEMP/DISP) SEQONLY(*NO)          5
CRTDUPOBJ OBJ(MAG1052) OBJTYPE(*PGM) TOLIB(QTEMP) FROMLIB(  6                  5
) NEWOBJ(M1052CHL)                                          7
CLRPFM FILE(QTEMP/PAGETBL)                                  8
CLRPFM FILE(QTEMP/PACKTBL)                                  9
CRTPF  FILE(QTEMP/INDXTICK) RCDLEN(256) SIZE(*NOMAX)        50
OVRDBF FILE(TICKLER) TOFILE(QTEMP/INDXTICK) SHARE(*YES)     1
OVRDBF FILE(MSPLDAT2) FRCRATIO(2000) TOFILE(                2
OVRDBF FILE(MSPLDAT1) FRCRATIO(2000) TOFILE(                3
SEQONLY(*YES 2000)                                          4
** MSGE  Message Entries ..............................................
ERR1305 - Archive abort *Status:&1 SysCode:&2 Line:&3  1
                                                       2
ERR1306 (**INCOMPLETE**)                               3
ERR1307 Not enough space on optical volume(s).         4
                                                       5
ERR1308 Compression error occured.                     6
ERR1309 Optical error while writting to jukebox.       7
ERR1310 Optical file verification error.               8
ERR1378 Unable to confirm recording of file on PC Optical Server.9
**
lLY
rRY
LLN
RRN
YNY
NNN
 NN
** DATE FORMAT CODES
1*MDYY
2*MDY
3*DMYY
4*DMY
5*YYMD
6*YMD
7*LONGJUL
8*JUL
AMMMDYY
BMMMDY
CDMMMYY
DDMMMY
EYYMMMD
FYMMMD

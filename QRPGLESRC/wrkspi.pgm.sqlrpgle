      *%METADATA                                                       *
      * %TEXT Display SpyLink                                          *
      *%EMETADATA                                                      *
     h bnddir('SPYBNDDIR')
      /copy directives
      *********---------------------------
      * WRKSPI  SpyLink search and display
      *********---------------------------
      *
      * Caution: Any RPG pgm called by this program must potentially
      *          be cloned.  For sample code, find "recurs" in col 40.
      *
/3316FMOPTTBL   IF   E           K DISK    USROPN
     FRMAINT1   IF   E           K DISK
     FMRPTDIR7  IF   E           K DISK
     FMIMGDIR   IF   E           K DISK
     FRLNKDEF   IF   E           K DISK
     FRLNKOFF   IF   E           K DISK    USROPN
     FRDBKEY    IF   E           K DISK    USROPN
     FRINDEX1   IF   E           K DISK
     FRSEGHDR   IF   E           K DISK
/3723FDRPTIDX1  IF   E           K DISK
     FWRKSPIFM  CF   E             WORKSTN INFDS(INFDS)
     F                                     USROPN
     F                                     SFILE(SUBFL1:CRRN1)
     F                                     SFILE(SUBFL2:CRRN2)
J2096FdocApiDlt o    e             printer oflind(*in01) usropn
      *
J7355 * 03-06-18 PLR Added *DELETELNK operation (from DOC/SPYAPICMD) to remove
      *              just link data.
J5350 * 11-21-13 PLR Issue 4103 inadvertently caused a performance issue when
      *              trying to find the correct seq number for copied links in
      *              large batches (several thousand images per batch).
J4796 * 03-21-13 PLR Generate trusted URL by calling TServlet in CoEx.
      *              Significant reorganization of previous trusted URL code.
J4795 * 03-19-13 PLR Extend size of CoEx URL host names.
J4258 * 02-16-13 PLR Allow prompting for CoEx URL. If STRPCOCMD fails, display
      *              they http string for selection.
J4602 * 12-19-12 EPG Echo a more explicit error message when attempting
/     *              to make an unqualifed search with DocLink Security.
J4240 * 07-10-12 PLR Disallow deletion of offline content when the volume is
      *              is flagged as Delete Capable = 'N'.
J4103 * 04-20-12 EPG Correct an issue with copied index values by
/     *              returning the base index value for the original
/     *              imgage.
J2437 * 04-07-10 PLR Export TIF as PDF.
J2096 * 03-23-10 PLR Add *DELETE and *DELETECHK codes to allow for the
      *              deletion of documents or the reporting thereof, through
      *              SPY/DOCAPICMD.
/1892 * 06-25-09 EPG Remedy a subfile processing issue.
T6762 * 01-08-08 PLR Unable to access DocLinks after upload of 60
/     *              character index field. Increase the Field array
/     *              dimension to accmodate the title notes, status
/     *              etc to a maximum of 598 from 498 for array t and d.
/6692 * 12-10-07 EPG Distribution of a single DocLink Image did not process
/     *              correctly, though multiple DocLink Images did send
/     *              correctly.
T6294 * 05-10-07 PLR Distribution doclinks not functioning correctly. Was not
      *              getting the correct start and end pages.
5230  * 06-06-06 EPG Enhance WRKSPI so that a sequence number
      *              parameter is added. Use the sequence number
      *              parameter as a selection criteria if the value
      *              being passed is greater than -1.
/8627 * 10-11-04 JMO Added logic to support F9 - Top functionality for
      *               optical spylinks.  This function was not working for
      *               at all if the spylinks were on optical.
/5635 * 06-17-03 PLR Audit logging.
/8729 * 12-01-03 GT  Changed check for report to use 'S' instead of 'SPY'.
/6708 * 10-09-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte binary.
      *              Remove access to MRPTDIR, use MRPTDIR1 instead.
      *              Change FILNUM (in MRPTDIR) to be the actual spool file number and
      *              change MRPTDIR1 key to include the spool file opened date.
/7829 *  7-30-03 JMO Removed checking for Omnilinks prior to deleting
      *               indices.  The program logic was left in place but
      *               but the subr. that does the checking is never run.
      *               Search for $OMNI to find the changes.
      *               Also made changes to fix display problems related to function keys.
/7675 *  1-22-03 JMO Increased size of Process Number parm for MAG8009.
      *              Size was changed in MAG8009 and MAG8010 by Bug id# 4283.
/6924 * 11-20-02 PLR Add support for FaxCom.
/6604 *  6-12-02 DLS Send a clear handle to SPYCSLNK after the links have
/6604 *              been viewed and screen refreshed.  This will force MCSPYHITR
/6604 *              to rebuild.  Also make sure that opcode of QUIT is sent to
/6604 *              SPYCSLNK when ready to leave.
/6503 * 06-06-02 PLR Correct erratic scrolling of links on F10=Bottom.
/6609 *  5-16-02 DLS Add INTERFACE parameter for Gumbo SpoolMail support.
/5921 * 05-10-02 PLR Suppress list of segments. User should see only links
/     *              assigned. Power users should see all. See MCSPYHITR.
/5909 * 12-20-01 PLR Not maintaining column positions when entering/exiting
/     *              different reports. Wasn't clearing positioning and content
/     *              arrays.
/5723 * 11-02-01 KAC Force segment selection if previously skipped.
/5673 * 10-19-01 KAC Fix DSPF override with SpyLinks
/5231 * 08-13-01 KAC REMOVE SPYLINKS SECURITY CHANGE (P2917)
/5197 * 08-07-01 KAC Fix APPLICATION SECURITY FOR NOTES
/4662 * 06-20-01 DLS Modify Copy / Change / Delete security (P2917)
/3765 * 06-18-01 PLR Revision control audit log.
/3765 *  6-11-01 KAC Add lock check for Revision Control.
/3765 * 05-16-01 PLR Disallow check out under RevCtl when object already checked out.
/3723 * 05-16-01 DLS adjust prior change by JAM to use SPYUPD for global delete
/3723 *              but bypass any screen processing as confirmation was done in WRKSPI
/3723 *              new op code "DLTONLY"
/4278 * 03-28-01 JAM Separate COPY and MOVE authority from CHANGE.
/3316 *  2-20-01 DLS ALLOW FOR 12 CHAR. DISPLAY FOR OFFLINE VOLUME
/3393 *  2-16-01 DLS Add IgnBatch parameter.
/3723 * 01/12/01 JAM Global delete modification.
/3723 * 03/01/01 JAM Changed MVRPTID1 to DRPTIDX1 and removed array.
/3723 *              ** CL   CL commands
/3723 *              OVRDBF FILE(MVRPTID1) TOFILE(MVRPTIDX1)
/3457 * 11-30-00 DLS value of fist line of SFLCTL1 is repeated thru
      *              subfile if cmd 5 is pressed.
/3331 * 11-27-00 KAC 7.0 SPYLINKS PROCESSING PROBLEM WITH SPYAPICMD
/1452 * 10-31-00 JAM PREVENT LOSS OF SCREEN DATA ON HELP.
/2929 * 09-27-00 JAM Clear BKEY in @INZFL to prevent previous
/2929 *              selection's last sequence number from affecting
/2929 *              new selection criteria.
/2930 *  9-19-00 KAC Add CodePage parameter
/2256 *  9-11-00 DLS Call to SPYLNKV RTNCOD of 'E' if Cmd3 from viewer.
/2917 * 08-10-00 JAM Folder security logic.
/2839 *  7-28-00 KAC ADD APPLICATION SECURITY FOR NOTES
/813  *  7-26-00 KAC REAPPLY "REVISED NOTES INTERFACE"
/2832 * 07-25-00 DLS Properly display the date range in hidden filter
/2832 *              display via CF4.
/2565 * 06-06-00 DLS DUP spylink rcd display but no dup in MIMGDIR    2565HQ
/2423 * 04-17-00 FID Fixed EXPOBJSPY Code                             2423HQ
/2493 * 03-31-00 FID Added new option 17=Move                         2493HQ
      *              Fixed Problem with closing the windows
/2249 * 12-23-99 GT  Move compare of WRKRSL return values to after    2249HQ
/2249 *              call WRKRSL clone.  Would only work if not cloned.
      *              Fix processing of WRKRSL return value '*PEND'.
      *              Was allowing '*PEND' to be passed to CHKSEGPG
      *              causing it to crash on OVRDBF command.
/2319 * 12-14-99 KAC PASS "INIT" TO SPYCSHHIT
/2204 * 12-06-99 JJF Fix subr IFSFYL handling of reports
/2249 * 11-12-99 DM  Validate that segment exists for page table.P2249HQ
/2204 * 11-11-99 JJF Allow '*' in IFS path (to get file name from hdr)
      * 10-22-99 KAC REMOVE "REVISE NOTES INTERFACE"
      * 10-13-99 GT  Fix conditioning for API=I
      *              Needed to be in the same places as API=M
      *  9-14-99 JJF Allow OpCde=*IFS, API=I for IFS destination      DriverNet
      *  9-08-99 KAC ADD STAFFVIEW CASE START OPTION
      *  8-02-99 JJF Send error msg if user not auth'd to run this    1128HQ
      *  7-30-99 KAC REVISE NOTES INTERFACE
      *  6-08-99 JJF Load PHYFI2 in subr SPYLNK for SPYAPICMD
      *  6-04-99 KAC LINK FILE PARM NOT BEING RESET (OFFLINE SPYLINKS).
      *  5-03-99 JJF Allow FastFax CoName,NickName via EFXTL2,@FXTO2
      *  2-11-99 JJF Send Partial PgTbl name to SPYLNKVU
      *  2-09-99 FID Use BLDSPKEY and BLDSPOPT for international text
      * 12-16-98 FID Add new email parms for SNDOBJSPY
      * 12-09-98 KAC CHANGE SPYLNKVU & GETHDR PARM LIST INCLUDE MSG ID & DATA
      * 12-08-98 FID Fix API opcode when faxing using SPYAPICMD
      * 12-06-98 FID Fix Display FILTER ON / QUERY ON
      * 11-10-98 JJF Rtn RtnCde='3' to SPYAPICMD when no hits on *ALL
      * 10-21-98 GT  Add parms to PLFIND (SPYFND)
      * 10-08-98 GT  Don't check outq if SpyPrinter specified.
      *  8-14-98 KAC ADD REPORT PRINTING VIA OMNISERVER
      *  8-04-98 GK  Fix SpyApiCmd not finding hits using OptIdx #989
      *  8-04-98 GK  Fix SpyApiCmd *View then Send bug #987.
      *  7-01-98 GK  Add *ALL to View optn in SpyApiCmd to dsp all.
      *  6-02-98 GK  Add *IBMSbmFax Op code.
      *  5-12-98 KAC FIX IMAGEVIEW/RDARS PRINT/FAX
      *  4-20-98 JJF Fix PgUp error. (Check NVAL1 b4 move '1' LCKPRV)
      *  4-10-98 GT  Fix YMD date format
      *  3-24-98 JJF Check PRNT authority (not READ) when selio=2
      *  3-23-98 GK  Fix more / bottom bug.
      *  2-27-98 KAC ADD SUPPORT FOR IMAGEVIEW TYPE REPORTS
      *  2-05-98 KAC ADD SUPPORT FOR R/DARS TYPE REPORTS
      *  1-22-98 GK  Add P030223 msg "Report linked for display"
      *  1-20-98 JJF Call WrkRSL if Distr SpyLinks enabled (DSTLNK=Y)
      *  1-16-98 GT  Fix "Show single hit from SpyAPI" operation
      *              Change MSGDTA length to 256 to match SNDMSG2
      * 11-07-97 GK  Add *VIEWLOCK to disable F16 on SflCtl1.
      * 10-28-97 GT  Change check for msgid ERR1557 to ERR156A
      * 10-22-97 JJF Prevent recursive call to SpyLnkVu
      *  9-24-97 GK  Add TelexFax logic.
      *  5-14-97 GT  Add F9 (top) and F10 (bottom) keys to SFLCTL1
      *  5-12-97 GT  Add Join and Page Range parms to ENTRY plist;
      *              Add Page Range parm to MAG210 plist
      * 10-23-96 JJF Send RTNCDE='D' to SpyApiCmd to start OmniServer.
      *  8-06-96 JJF Allow F12 to quit if called by Spy API.
      *  5-29-96 JJF Change SpyCSLnk's return SDT to 70 byte inx fields
      *  5-07-96 FID Add 8=Update option
      *  4-09-96 JJF Fix"position to"date when using descending date ky
      *  3-28-96 JJF Call SpyLnkVu for all viewing (images and reports)
      *  1-11-96 JJF Call DspImgA to display images on graphics terminl
      *  1-06-96 PAF Remove conditional code that tested printer name
      *              and prevented the outq from being overriden.
      * 12-21-95 JJF Add AppSec w/opts 10,11=N if not RVI. Add opt5 img
      * 12-11-95 JJF Bundle images for SpyCSDQ data que up to 9 reqs.
      * 11-22-95 JJF Send requests to SpyCSDQ data que for image viewer
      *
/3765 /copy @mmdmssrvr
J4240 /copy @mrrepmgr
/5635 /copy @mlaudlog
/    d LogDS           ds
/     /copy @mlaudinp
J4258 /copy qsysinc/qrpglesrc,qusec

J7355d deleteLinkOnly  pr            10i 0

J4796d coExImgView     pr            10i 0

J4796d getTrustedURL   pr            10i 0
     d  hostName                       *   const options(*string:*trim)
J4796d  ioURL                       500


J4103dGetBaseSeq       pr            10i 0
/    d pIndexFile                    10a   const
/    d pBatch                        10a   const
/    d pStartOffset                   9a   const
/    d pbinSeq                        9p 0
/    d pstrSeq                        9a

J5350d getSeqNum       pr            10i 0
J5350d  batchid                      10
J5350d  imageRRN                     10i 0 const

J4240d rtvMsgs         pr            80
J4240d  msgID                         7    const
J4240d  msgVals                      80    const options(*nopass)


/6692 // Constants --------------------------------------------------------------------------------------------
/    d TRUE            c                   '1'
/    d FALSE           c                   '0'
J4602d ERR1813         c                   'ERR1813'
/    d ERR000A         c                   'ERR000A'
/    d LNKRTN_30       c                   '30'
/    d LNKRTN_40       c                   '40'

/     // Variables ---------------------------------------------------------------------------------------------
/1892d intSfl1Cnt      s              4p 0
/     * Counter for simulating a READC
/    dpIndicators      s               *   inz(%addr(*in))
/    dIndicatords      ds            99    based(pIndicators)
/    d  blnSflChg1                     n   overlay(Indicatords:08)
/    d blnEndSfl1                      n   overlay(Indicatords:98)
/6692d blnCloseW       s               n   inz(FALSE)
T6762dMAXTITLE         c                   598
/    D T               S              1    DIM(MAXTITLE)                        Title Line
/    D D               S              1    DIM(MAXTITLE)                        Display Line
     D IN              S             10    DIM(11)                              Index Name
     D ID              S             30    DIM(11)                              Index Desc
     D IDL             S              2  0 DIM(11)                              Desc. Length
     D IL              S              3  0 DIM(11)                              Index Length
     D DP              S              5  0 DIM(11)                              Data Position
     D KL              S              3  0 DIM(11)                              Actual KeyLen
     D @KL             S              3  0 DIM(11)                              KL for logical
     D LE              S              1  0 DIM(11)                              Logical Exist
     D SPV             S             99    DIM(7)                               USRSPC VAELUS

     D VI              S              4  0 DIM(10)                              View img RRNs

/3723D ERR             S              7    DIM(16) CTDATA PERRCD(1)             Msg IDs
J4258d coExUrlA        s            100    dim(1) ctdata
     D AUT             S              1    DIM(25)                              Auth returns
/2839D AUTE            S              1    DIM(40)                              EXTENDED Auth return
l    D PRS             S              1    DIM(100)                             PRint secure
      * Spylink full test search
     D WR              S             95    DIM(5)                               Search Words
     D AO              S              4    DIM(5)                               AND/OR
     D TE              S              5    DIM(5)                               Test LIKE/NLIK
      * Query selection parms
     D AOQ             S              3    DIM(25)                              AND/OR
     D FNQ             S             10    DIM(25)                              Field Name
     D TEQ             S              5    DIM(25)                              Test
     D VAQ             S             30    DIM(25)                              Value
      * Email Text
     D @TXT            S             65    DIM(5)                               Text Lines Email
     D ETXT            S             65    DIM(5)                               Text Lines Email

     D OT              S            132    DIM(10)                              OPTIOM texts
     D FKT             S            132    DIM(5)                               FKYVIW texts
/3723
/3723 * User index variables
/3723D UINAME          DS            20
/3723D  UINAM1                 1      1
/3723D  UINAM2                 2      5
/3723D  UINAM3                 6     10
/3723D  UINAM4                11     20
/3723 * User index parms
/3723D UIPARM          DS
/3723D  UIEXTA                 1     10
/3723D  UILENA                11     11
/3723D  UIDTAL                12     15B 0
/3723D  UIINSK                16     16
/3723D  UIKEYL                17     20B 0
/3723D  UIFRCE                21     21
/3723D  UIOPTZ                22     22
/3723D  UIAUTH                23     32
/3723D  UITEXT                33     82
/3723D  UIREPL                83     92
/3723D  UIDOMN                93    102
/3723D  UIRTNL               103    112
/3723D  UI#ADD               113    116B 0
/3723D  UIINST               117    120B 0
/3723D  UIOFST               121    128
/3723D  UI#ENT               129    132B 0
/3723
/3723D UIERR           DS           272
/3723D  UIBYTP                 1      4B 0
/3723D  UIBYTA                 5      8B 0
/3723D  UIMSGI                 9     15
/3723D  UIRSV                 16     16
/3723D  UIMSGD                17    272
     D OFFSET          C                   CONST(X'0000000000000000')
/3723
/3723 * User index header record
     D DTALEN          C                   CONST(529)
     D KEYLEN          C                   CONST(5)
/3723D UIHDR           DS           529
/3723D  UIKEYH                 1      5  0
/3723D  UIFILE                 6     15
/3723D  UILN                  16     36  0 DIM(7)                               User Index Values
/3723D  UILN01                16     18  0
/3723D  UILN02                19     21  0
/3723D  UILN03                22     24  0
/3723D  UILN04                25     27  0
/3723D  UILN05                28     30  0
/3723D  UILN06                31     33  0
/3723D  UILN07                34     36  0
/3723D  UIFLH1                37    256
/3723D  UIFLH2               257    512
/3723D  UIFLH3               513    529
/3723
/3723 * User index data record
/3723D UIDTA           DS           529
/3723D  UIKEYD                 1      5  0
/3723D  UINX01                 6     75
/3723D  UINX02                76    145
/3723D  UINX03               146    215
/3723D  UINX04               216    285
/3723D  UINX05               286    355
/3723D  UINX06               356    425
/3723D  UINX07               426    495
/3723D  UINX08               496    503
/3723D  UINXNM               504    513
/3723D  UINXSQ               514    518P 0
/3723D  UITYP                519    519
/3723D  UISPG                520    524P 0
/3723D  UIEPG                525    529P 0
/3723
     D MVGLDL          C                   CONST('MVGLBDLTC')

     D TX1024          DS          1024    INZ

     D DTA             DS          5120
      *             Optical Link header rec
      *                     Key Lengths
      *                     Stg method version
      *                     Opt names
      *                     Index descrs
     D  OKL                   41     64P 0 DIM(8)                               Key Lengths
     D  LOVERS                89     90P 0
     D  ON                   151    220    DIM(7)                               OPt. names
     D  ID@                  320    559    DIM(8)                               Index Descr.
     D DSF#            DS
     D  @FILNU                 1      4B 0

     D SFDATA          DS                  OCCURS(10)
      *             Subfile data 10 occurs
     D  DATA1                  1    256
     D  DATA2                257    512
     D  LXSPG$               702    710
     D  LXEPG$               711    719
     D  LXSEC                720    722
     D  DSPLN                723    792
     D  LXTYP                793    793
     D  LXFIL                794    801
     D  LXEXT                802    803
     D  LXLIB                804    813
     D  LXBI5                814    863
     D  LXLOC                864    864
     D  LXNOT                865    865
     D  LXRO#                866    874
     D  LXRF#                875    883

     D LXDATA          DS                  OCCURS(10)
      *             Subfile data 10 occurs
     D  LXIV1                  1     70
     D  LXIV2                 71    140
     D  LXIV3                141    210
     D  LXIV4                211    280
     D  LXIV5                281    350
     D  LXIV6                351    420
     D  LXIV7                421    490
/5635d   lxivA                       70    dim(7) overlay(lxdata)
     D  LXIV8                491    498
     D  LDXNAM               507    516
     D  LXSEQ$               517    525

     D IFILTR          DS          1000
      *             Setll the @file
     D  LLIV1                  1     99
     D  LLIV2                100    198
     D  LLIV3                199    297
     D  LLIV4                298    396
     D  LLIV5                397    495
     D  LLIV6                496    594
     D  LLIV7                595    693
J2096D   iFilterA                    99    dim(7) overlay(iFiltr)
     D  LLIV8                694    701
     D  LLIV9                702    709
     D  LLNAM                710    719
     D  LLSEQ                720    728  0

     D TKEY            DS           728
      *             Top & bottom subf lines
     D  LTIV1                  1     70
     D  LTIV2                 71    140
     D  LTIV3                141    210
     D  LTIV4                211    280
     D  LTIV5                281    350
     D  LTIV6                351    420
     D  LTIV7                421    490
     D  LTIV8                491    498
     D  LTNAM                507    516
     D  LTSEQ                517    525

     D BKEY            DS           728
     D  LBIV1                  1     70
     D  LBIV2                 71    140
     D  LBIV3                141    210
     D  LBIV4                211    280
     D  LBIV5                281    350
     D  LBIV6                351    420
     D  LBIV7                421    490
     D  LBIV8                491    498
     D  LBNAM                507    516
     D  LBSEQ                517    525

     D SDTPRM          DS           768

     D SDT             DS           768    OCCURS(10)
      *             Send back DS: up to 10 matched SpyLink recs
     D  SDTRV1                 1     70
     D  SDTRV2                71    140
     D  SDTRV3               141    210
     D  SDTRV4               211    280
     D  SDTRV5               281    350
     D  SDTRV6               351    420
     D  SDTRV7               421    490
     D  SDTRV8               491    498
     D  SDTNAM               507    516
     D  SDTSEQ               517    525
     D  SDTSPG               526    534
     D  SDTEPG               535    543
     D  SDTSEC               544    546
     D  SDTTYP               547    547
     D  SDTFIL               548    555
     D  SDTEXT               556    557
     D  SDTLIB               558    567
     D  SDTBI5               568    617
     D  SDTLOC               618    618
     D  SDTNOT               619    619
     D  SDTPCT               620    624
     D  SDTTPG               625    633
     D  SDTRO#               634    642
     D  SDTRF#               643    651
     D INFDS           DS
      *             Subfile INFDS rtn vals
     D  KEY                  369    369
     D  CSRLOC               370    371B 0
     D  WINLOC               382    383B 0
     D  PAGRRN               378    379B 0

     D SYSDFT          DS          1024
      *             SpySystem defaults
     D  LIMGID               124    133
/4662D  EXTSEC               137    137
J4258d  CoExURL              206    206
J4258d   CoExURLRpt          207    207
J4258d   CoExURLImg          208    208
J4796d   CoExTrPrf           209    218
J4258d   CoExPCCmd           219    219
J4795d   CoExSrvNam          612    636
     D  DSTLNK               221    221
     D  FAXTYP               251    251
J4258D  lPgmLib              296    305
     D  LDTALB               306    315
J5350d  getImgSeq            612    612
     D  WVACT                654    654
     D  SNGHIT               670    670
     D  MLACT                771    771
     D  MLEXT                775    777
J4796D  trustedURLkey        892    923
J4258D  TCPPort              946    950

J4795d sysdft2         ds          2000    dtaara
J4795d  CoExSysNam          1218   1242

     D T560            DS
      *             Titles for subfile (8 screens)
     D  T1                     1     70
     D  T2                    71    140
     D  T3                   141    210
     D  T4                   211    280
     D  T5                   281    350
     D  T6                   351    420
     D  T7                   421    490
     D  T8                   491    560
     D RVIP            DS
      *             Real Vision Imaging Parms
     D  RVIID                  1      1
     D  RVI1                   2     31
     D  RVI2                  32     61
     D  RVI3                  62     91
     D  RVI4                  92    121
     D  RVI5                 122    151
     D  RVI6                 152    181
     D  RVI7                 182    211
     D                 DS
      *             Display date
     D  DDMMYY                 1      6
     D  DD                     1      2
     D  MM                     3      4
     D  YY                     5      6
     D  YYMMDD                 5     10
     D  MMDDYY                 7     12
     D  MMDD                   7     10
     D  YY2                   11     12
     D WRKDT           DS
      *             Display date
     D  WMM                    1      2
     D  SLASH1                 3      3
     D  WDD                    4      5
     D  SLASH2                 6      6
     D  WYY                    7     10
     D WRKDT2          DS
      *             Convert date
     D  WYY2                   1      4
     D  WMM2                   5      6
     D  WDD2                   7      8
     D WRKDT3          DS
      *             Display date
     D  WYY3                   1      4
     D  SLASH3                 5      5
     D  WMM3                   6      7
     D  SLASH4                 8      8
     D  WDD3                   9     10
     D                 DS
      *             Misc Date Conversion
     D  WRK60                  1      6  0
     D  WRK601                 1      2  0
     D  WRK602                 3      4  0
     D  WRK603                 5      6  0
     D  WRK636                 3      6  0

     D  FILFMT                 7     12  0
     D  FRK601                 7      8  0
     D  FRK636                 9     12  0

     D  SYSFMT                13     18  0
     D  SRK601                13     14  0
     D  SRK602                15     16  0
     D  SRK614                13     16  0
     D  SRK603                17     18  0

     D  INDX8S                19     26
     D  INI8BY                19     22
     D  INI8BM                23     24
     D  INI8BD                25     26

     D  INDX8E                27     34
     D  INI8EY                27     30
     D  INI8EM                31     32
     D  INI8ED                33     34
     D                 DS
      *             Misc
     D  NVAL1                  1     35
     D  FILNUB                36     39B 0
     D  APILEN                40     43B 0
     D  FLDR                  44     53
     D  FLDRLB                54     63
     D  IKYLNK                64    113
     D  LRNAM                 64     73
     D  LJNAM                 74     83
     D  LPNAM                 84     93
     D  LUNAM                 94    103
     D  LUDAT                104    113

     D ECVRTX          s            780
     D CVRTXT          s            780
      *             Entry parm passed to Mag210
     D ERROR           DS                  INZ
      *             Error Message Return Code
     D  BYTPRV                 1      4B 0
     D  BYTAVA                 5      8B 0
     D  ERRID                  9     15
     D  ERR###                16     16
     D  INSDTA                17    256

     D ERRCD           DS           116
     D  @ERCON                 9     15
     D  @ERDTA                17    116

     D @OBJD           DS            90
      *             Check object exist API
     D  OBJLIB                19     28
     D               ESDS                  EXTNAME(CASPGMD)
      *             System DS (SDS) - see PFSRC/CASPGMD

     D QDTA            DS           128
      *             Data queue data  (& DIRqst for DspImgA pgm)
     D  DIRQST                 1     39
     D  BTCHNO                 1     10
     D  BTCHSQ                11     19  0
     D  @FILE                 20     29
     D  @LIBR                 30     39
     D  #IV                   40     41  0
     D  E#IV                  40     41
     D                 DS                  INZ
      *           Actionfile attach path
     D  PATHDS                 1    100
     D  ARNAM                  1     10
     D  AJNAM                 11     20
     D  APNAM                 21     30
     D  AUNAM                 31     40
     D  AUDAT                 41     50
     D  ASTR                  51     59
     D  AEND                  60     68
     D  ATYPE                 69     69

      * check for revision control lock
/3765d ChkRCLock       pr            10i 0
     d BatNum                        10    const
     d StrPage                        9s 0 const
     d LockUser                      10

     d LockUser        s             10

J2096d deleteObject    pr            10i 0
J2096d  object                       10    value
J2096d  pgOrRRN                       9    options(*nopass)

      * function return codes
     d OK              c                   1
     d FAIL            c                   0
     d rc              s             10i 0

      /copy @FKEYS

     D X40000          C                   CONST(X'40000000')
     D PSCON           C                   CONST('PSCON     *LIBL     ')
J7355d SQLMSGF         c                   const('QSQLMSG   *LIBL     ')
     D SPYSPC          C                   CONST('SPYEXPSPC')
     D NUMBRS          C                   CONST('0123456789')
     D TLXFAX          C                   CONST('*TELEXFAX')
     D FAXSVR          C                   CONST('*FAXSRV401')
     D SBMFAX          C                   CONST('*IBMSBMFAX')
     D VUELCK          C                   CONST('*VIEWLOCK')
/5673d OVRDSP          c                   'OVRDSPF FILE(WRKSPIFM) SHARE(*YES) -
/    d                                     OPNSCOPE(*JOB) OVRSCOPE(*CALLLVL)'
     D SUNODL          C                   CONST('SPYUPDNODL')
/3765d RevLck          s              5i 0

/3765d PassFail        s             10i 0
/6503d maxHits         c                   10
/7675d ActPro          s             10s 0
/7829d sav_key#        s              3s 0

5230 d NOSEQNBR        c                   x'FFFFFFFF'
      * The reserved value of *NONE has been passed
5230 d NONE            c                   -1
5230 d intSeqNbr       s             10i 0
      * Requested sequence number
5230 d intSeqCnt       s             10i 0 inz(*zeros)
      * Count of the requested sequence number
5230 d strSeqNbr       s              9a

5230 d                 ds
5230 ddsStrSeqNbr              1      4
5230 ddsBinSeqNbr              1      4b 0
J7355d sq              c                   ''''

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

     C     *ENTRY        PLIST
     C                   PARM                    PHYFIL           10            File Name
     C                   PARM                    PHYMBR           10            Mbr Name
     C                   PARM                    SPYLIB           10            SpyLib
     C                   PARM                    WFILN                          Big5
     C                   PARM                    WJOBN                           :
     C                   PARM                    WPROG                           :
     C                   PARM                    WUSR                            :
     C                   PARM                    WUDTA                           :
     C                   PARM                    RTNCDE            8            Return Code
      * WrkSpr and WrkSp2 call this pgm with only 9 parms

     C                   PARM                    DUPS              1            PROMPT DUP
     C                   PARM                    XVAL1            99            API filter
     C                   PARM                    XVAL2            99
     C                   PARM                    XVAL3            99
     C                   PARM                    XVAL4            99
     C                   PARM                    XVAL5            99
     C                   PARM                    XVAL6            99
     C                   PARM                    XVAL7            99
     C                   PARM                    XVAL8            99
     C                   PARM                    XVAL9            99
      *  20-26
     C                   PARM                    PRNTF             1            Print Doc
     C                   PARM                    WRINTR           10            Printer
     C                   PARM                    WOUTQ            10            Output Q
     C                   PARM                    WOUTL            10            Output L
     C                   PARM                    WBMJBQ            1            Sbmjob
     C                   PARM                    WBDESC           10            JobD
     C                   PARM                    WBDLIB           10            JobD lib
      * Fax 27-41
     C                   PARM                    WFAX#            40            To number
     C                   PARM                    WFAXFR           45            From
     C                   PARM                    WFAXTO           45            To
     C                   PARM                    WFAXRE           45            Re.
     C                   PARM                    WFXTX1           50            Text 1    31
     C                   PARM                    WFXTX2           50                 2    32
     C                   PARM                    WFXTX3           50                 3    33
     C                   PARM                    WFAXID           50
     C                   PARM                    WCNFRM           20
     C                   PARM                    WFMNAM           10
     C                   PARM                    WSDPRT            2
     C                   PARM                    WFXSTY            4
     C                   PARM                    WFXVC             4
     C                   PARM                    WFXHC             4
     C                   PARM                    EOPCDE           10            Prt,Fax,View
      * Optical 42-50                                          eMl,Ifs
     C                   PARM                    WOODES                         Opt Desc
     C                   PARM                    WOOPID                         Opt ID
     C                   PARM                    WODRV                          Opt DRV
     C                   PARM                    WOVOL                          Opt Vol
     C                   PARM                    WODIR                          Opt Dir
     C                   PARM                    WOFILE                         Opt FileName
     C                   PARM                    ENVWND            1            With Win Y/N
     C                   PARM                    ENVUSR           10            Envir User
     C                   PARM                    ENVNAM           10            Envir Name
      * more Fax 51-60
     C                   PARM                    EFXTL1           40            To number
     C                   PARM                    EFXTL2           40            Text 1
     C                   PARM                    EFXTL3           40                 2
     C                   PARM                    EFXFL1           40                 3
     C                   PARM                    EFXFL2           40                 4
     C                   PARM                    EFXFL3           40                 5
     C                   PARM                    ETITLE           45            Title
     C                   PARM                    ECOMNT           40            comment
     C                   PARM                    ECVRPF           10            CovrPg file
     C                   PARM                    ECVRPL           10            CovrPg libr
      * Print Duplex  61-67
     C                   PARM                    ECVRPA            7            CovrPgB4/Aft
     C                   PARM                    ECPMBR           10            CoverPg Mbr
     C                   PARM                    ECVRTX                         CovrPg text
     C                   PARM                    EDUPLE            4            *YES/*NO
     C                   PARM                    EORIEN           10            *LAND/*PORT
     C                   PARM                    EPTRTY            6            *XI *PVL etc
     C                   PARM                    EPTRNO           17            PCsrvrNodeID
     C                   PARM                    ECOPIE            3 0          #Copies
     C                   PARM                    EPAPSZ           10            Papersize
     C                   PARM                    EDRWER           10            Drawer
      * Joiner & Fax batch 71-74
     C                   PARM                    EJOIN             1            Join
     C                   PARM                    EPGRNG           20            Page range
     C                   PARM                    EBCHOP            1            Batch option
     C                   PARM                    EBCHID           10            Batch opt ID
      * eMail  75-80
     C                   PARM                    ESNDR            60            SENDER
     C                   PARM                    EADTYP            1            TO ADDR TYPE
     C                   PARM                    ERCVR            60            RECEIVER
     C                   PARM                    ESUBJ            60            SUBJECT
     C                   PARM                    ETXT                           TEXT 5*65
     C                   PARM                    EFMT             10            FORMAT
      * more   81-83
/2930C                   PARM                    ECDPAG            5            CODE PAGE
/3393C                   PARM                    IGNBAT            1            IGNORE BADBATCH
/6609C                   PARM                    INTFAC            1            SpoolMail Interface
/5230c                   Parm                    SeqNbr            4

J7355 /free
J7355  exec sql set option commit=*none, closqlcsr=*endmod;
J7355 /end-free

5230 c                   Select
5230  *                  No sequence specified
5230 c                   When      %addr(SeqNbr) <> *null  and
5230 c                             (SeqNbr    = NOSEQNBR  or
5230 c                             SeqNbr    = *blanks)
5230 c                   Eval      intSeqNbr = -1

5230  *                  No sequence specified
5230 c                   When      %addr(SeqNbr) = *null
5230 c                   Eval      intSeqNbr = -1

5230  *                  Sequence specified
5230 c                   When      %addr(SeqNbr) <> *null  and
5230 c                             SeqNbr   <> NOSEQNBR    and
5230 c                             SeqNbr   <> *blanks
5230 c                   Eval      dsStrSeqNbr = SeqNbr
5230 c                   Eval      intSeqNbr  = dsBinSeqNbr
5230 c                   Eval      strSeqNbr =
5230 c                             %subst(%editc(intSeqNbr:'X'):2:9)
5230 c                   EndSl

     C     WQPRM         IFGE      74                                           SpyApiCmd
     C     DUPS          ANDEQ     'A'
     C                   MOVE      'Y'           DUPS
     C                   MOVE      'Y'           PRTALL            1
     C                   ENDIF

/2930C     WQPRM         IFGE      81
/    C                   MOVEL     ECDPAG        @CDPAG
/    C                   ELSE
/    C                   MOVE      *BLANKS       @CDPAG
/    C                   ENDIF

/3393C     WQPRM         IFGE      82
/    C                   MOVEL     IGNBAT        @IGBAT
/    C                   ELSE
/    C                   MOVE      'N'           @IGBAT
/    C                   ENDIF

/6609C     WQPRM         IFGE      83
/    C                   MOVEL     INTFAC        @INFAC
/    C                   ELSE
/    C                   MOVE      '*'           @INFAC
/    C                   ENDIF

     C                   MOVE      *ON           *IN16                          F16

     C     WQPRM         IFGE      41
     C     EOPCDE        ANDEQ     VUELCK                                       *VIEWLOCK
     C                   MOVE      *OFF          *IN16                          lock F16 on
     C                   MOVEL(P)  '*VIEW'       EOPCDE                         Sflctl1IfCMD
     C                   ENDIF

     C     WQPRM         IFGE      69
     C                   MOVEL     EPAPSZ        PAPSIZ           10            Papersize
     C                   ENDIF
     C     WQPRM         IFGE      70
     C                   MOVEL     EDRWER        DRAWER            4            Drawer
     C                   ENDIF
     C     WQPRM         IFGE      71
     C                   MOVEL     EJOIN         JOIN              1            Join
     C                   ENDIF
     C     WQPRM         IFGE      72                                           Page range
     C                   MOVEL     EPGRNG        PAGRNG           20
     C                   ENDIF
     C     WQPRM         IFGE      73                                           Batch option
     C                   MOVEL     EBCHOP        BCHOPT            1            (for faxing)
     C                   MOVEL     EBCHID        BCHID            10             Y/N/(C)lose
     C                   ELSE
     C                   MOVE      'N'           BCHOPT
     C                   MOVE      *BLANKS       BCHID
     C                   ENDIF

     C                   CLEAR                   CRTERR

     C     WQPRM         IFGE      41
     C                   MOVEL     EOPCDE        OPCDE
     C                   ELSE
     C                   MOVEL     '*VIEW'       OPCDE
     C                   ENDIF

     C     WQPRM         IFGE      61
     C                   MOVE      ECVRPA        CVRPAG            7            CovrPgB4/Aft
     C                   MOVE      ECPMBR        CPGMBR           10            CoverPg Mbr
     C                   MOVE      ECVRTX        CVRTXT                         CovrPg text
     C                   MOVE      EDUPLE        DUPLEX            4            *YES/*NO
     C                   MOVE      EORIEN        ORIENT           10            *LAND/*PORT
     C                   MOVE      EPTRTY        PTRTYP            6            *XI *PVL etc
     C                   MOVE      EPTRNO        PTRNOD           17            PCsrvrNodeID
     C                   MOVE      ECOPIE        COPIES            3 0          #Copies
     C                   ENDIF

     C     RTNCDE        IFEQ      'CLOSEW'
     C                   EXSR      QUIT
     C                   END
/3723
/3723C                   MOVE      'N'           OMNFLG
/3723
      * Called by DspHypLnk
     C                   MOVEL     RTNCDE        ALFA6             6
     C     ALFA6         IFEQ      'OMNILI'
     C                   MOVE      'Y'           @OMNI             1
     C                   MOVE      RTNCDE        #IV                            # imgs to vu
     C                   ELSE
     C                   MOVE      'N'           @OMNI
     C                   MOVE      11            #IV
/7829 * the following two lines were removed 7-30-03 by Jeff Olen
/3723 ******               Is this connected to an OmniLink?
/3723C******             EXSR      $OMNI
     C                   END

     C                   Z-ADD     1             FIRST             1 0          Set size
      * Init vars
     C     BCHOPT        IFNE      'C'
     C                   EXSR      SETSCN
     C                   ENDIF
      * Applic sec
     C                   EXSR      APPSEC
      * FKey text
     C                   EXSR      GETFKY

      * Set API=VPFM (Vu/Prt/Fax/Mail)   APIIND='1'/' '
     C                   EXSR      IFAPI
      * SegNam
     C     BCHOPT        IFNE      'C'
     C                   EXSR      SETSEG
     C                   END

      * If more than 9 parms, we have been called by a SpyAPI.
      * If BCHOPT=C, it's just the fax batch closing its DtaQ.

     C     WQPRM         IFGT      9
     C     BCHOPT        CASEQ     'C'           CLSBCH
     C                   CAS                     PROCES
     C                   ENDCS
     C                   END

      *===============================================================
      *       Main Interactive Program loop
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

     C     KEY           DOUEQ     F3
     C     KEY           OREQ      F12

     C     FIRST         IFEQ      1                                            Get search
     C                   EXSR      FILTER                                        args
     C                   Z-ADD     0             FIRST
     C                   END

     C     BATCH         IFEQ      'Y'                                          If batch
     C                   MOVE      *ON           *INLR                          we're done
     C                   EXSR      RETURN
     C                   END

     C                   EXSR      @LOAD                                        Load SubFile

     C     NVAL1         IFEQ      *BLANKS                                      Not posnto:
     C                   MOVE      '1'           LCKPRV                         LOCK PRV PAG
     C                   END                                                    LIST ON TOP

     C     CRRN1         IFGT      0                                             display
     C                   MOVE      *ON           *IN42                           1st 10
     C                   ELSE
     C                   MOVE      *OFF          *IN42
     C                   END
      *===============================================================
      *          Hit List subfile screen sub-loop
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     C                   Z-ADD     0             #IV
     C                   CLEAR                   APIIND
      *>>>>
     C     SHOWS1        TAG
     C     KEY           DOUEQ     F3
     C                   MOVE      '1'           DOLOCK            1            keybrd lck
     C                   EXSR      CLRW                                         Clr window
     C                   WRITE     CMDLIN1
     C                   WRITE     MSGSFC
     C  N42              WRITE     NORCD
     C                   MOVE      *ON           *IN41
     C                   EXFMT     SFLCTL1
/3723C                   Z-ADD     PAGRRN        RCDNBR
/3723C                   Z-ADD     PAGRRN        TOPRCD                          Save top
/3723C     *LIKE         DEFINE    PAGRRN        TOPRCD                          RECORD
     C                   MOVE      *OFF          *IN41
     C                   EXSR      CLRMSG

/1452C     KEY           DOWEQ     HELP                                         Help
     C                   MOVEL(P)  'SFLCTL1'     HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
     C     PLHELP        PLIST
     C                   PARM      'WRKSPIFM'    DSPFIL           10
     C                   PARM                    HLPFMT           10
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      SFLCTL1                                99
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO SHOWS1
/1452C                   ENDDO
/3723
/3723 * If F18 was previously pressed and ENTER was not pressed,
/3723 * (no position to entered either) then refresh.
/3723C     F18FLG        IFEQ      'Y'
/3723
/3723C     KEY           IFEQ      F18
/3723C                   ITER
/3723C                   ELSE
/3723
/3723C     KEY           IFEQ      F3
/3723C     KEY           OREQ      F4
/3723C     F5            OREQ      KEY
/3723C     KEY           OREQ      F9
/3723C     KEY           OREQ      F10
/3723C     KEY           OREQ      F11
/3723C     KEY           OREQ      F12
/3723C     KEY           OREQ      F14
/3723C     KEY           OREQ      F17
/3723C     KEY           OREQ      F21
/3723C     KEY           OREQ      F23
/3723C     KEY           OREQ      F24
/3723C     NVAL1         ORNE      *BLANKS
/3723C***********KEY       OREQ PAGEDN
/3723C***********KEY       OREQ PAGEUP
/3723C                   CLEAR                   F18FLG
/3723C                   EXSR      SRF5
/3723C                   ENDIF
/3723
/3723C                   ENDIF
/3723
/3723C                   ENDIF
/3723
/3723C                   CLEAR                   F18FLG

      * F4=Display Filter
     C     KEY           IFEQ      F4                                           display
     C                   EXSR      DSPFLT                                       filter
     C                   GOTO      SHOWS1
     C                   ENDIF
      * F23=More OPTION
     C     KEY           IFEQ      F23                                          more options
     C                   EXSR      SRF23
     C                   GOTO      SHOWS1
     C                   ENDIF
      * F24=More Keys
     C     KEY           IFEQ      F24                                          more keys
     C                   EXSR      SRF24
     C                   GOTO      SHOWS1
     C                   ENDIF
      * F14=Find
     C     KEY           IFEQ      F14                                          f14 find
     C     AUT(1)        CASEQ     'N'           SNDEIA                         "Insuf auth"
     C                   ENDCS
     C                   MOVEL     LXSEC         READ              1            Security
     C     AUT(1)        CASNE     'Y'           SNDEIA                         "Insuf auth"
     C                   ENDCS
     C                   EXSR      SRF14
     C                   GOTO      SHOWS1
     C                   ENDIF
      * F3=Exit
     C     KEY           IFEQ      F3
     C                   MOVE      KEY           RTNCDE
     C                   EXSR      RETURN
     C                   ENDIF
      * F12=Cancel
     C     KEY           IFEQ      F12
     C     API           ANDNE     ' '
     C     OPCDE         ANDNE     '*SELECT'                                     NO SELECT
     C                   MOVE      KEY           RTNCDE
     C                   EXSR      RETURN
     C                   END

     C*/3723               Z-ADDPAGRRN    RCDNBR
     C*/3723               Z-ADDPAGRRN    TOPRCD            Save top
     C*/3723     *LIKE     DEFN PAGRRN    TOPRCD            RECORD
      * F9=Top
     C     KEY           IFEQ      F9
     C                   EXSR      @GOTOP
     C                   GOTO      SHOWS1
     C                   ENDIF
      * F10=Botm
     C     KEY           IFEQ      F10
     C                   EXSR      @GOBOT
     C                   GOTO      SHOWS1
     C                   ENDIF
      * F21=CmdLn
     C     KEY           IFEQ      F21
     C                   CALL      'MSYSCMDC'
     C                   GOTO      SHOWS1
     C                   END
      * F11=ChgVu
     C     KEY           IFEQ      F11
     C                   EXSR      @CHGV
     C     GETCSR        IFEQ      0
     C                   Z-ADD     1             RCDNBR
     C                   ELSE
     C                   Z-ADD     GETCSR        RCDNBR
     C                   ENDIF
     C     CRRN1         CASGT     0             @CHGSF                          Chg Subfile
     C                   ENDCS                                                   (shift)
     C                   ITER
     C                   END
      * PosnTo
     C     NVAL1         IFNE      *BLANKS
     C                   EXSR      POSTO
     C                   LEAVE
     C                   END
      *F17=ChgSort
     C     KEY           IFEQ      F17
     C                   EXSR      SRF17
     C     LFILE#        IFNE      WFILE#
     C                   MOVE      WFILE#        LFILE#
     C                   MOVE      *BLANKS       NPOS

     C     LFILE#        IFGT      0
     C                   MOVE      IN(LFILE#)    TMP9              9            Change title
     C                   MOVEL     TMP9          NPOS
     C                   Z-ADD     LFILE#        OVRL#                          Ovrride log#
     C                   ELSE
     C                   MOVE      IN(1)         TMP9
     C                   MOVEL     TMP9          NPOS
     C                   Z-ADD     1             OVRL#
     C                   END
     C                   EXSR      CLRSFL
     C                   EXSR      @SELCR                                       Get 1st 10
     C                   LEAVE
     C                   END
     C                   END
      * PgDn
     C     KEY           IFEQ      PAGEDN
     C     TOPRRN        ANDGT     9
     C     *IN99         IFEQ      *ON                                          No more
     C     DIRECT        ANDEQ     'F'
     C                   MOVE      'P007057'     MSGID                          ALREADY BOTT
     C                   EXSR      SNDMSG
     C                   ITER
     C                   END

     C                   MOVE      'F'           DIRECT
     C                   EXSR      @MORE
     C                   ITER
     C                   END
      * PgUp
     C     KEY           IFEQ      PAGEUP
     C     LCKPRV        IFNE      '1'
     C                   MOVE      'B'           DIRECT
     C                   MOVE      *OFF          *IN99
     C                   EXSR      @MORE
     C                   ELSE
     C                   MOVE      'P007056'     MSGID                          ALREADY TOP
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ITER
     C                   END
      * F5=Refrsh
     C     F5            IFEQ      KEY
     C                   EXSR      SRF5
     C                   ITER
     C                   END
/3723 * F18=Repeat to end of list.
/3723C     F18           IFEQ      KEY
/3723C                   EXSR      $F18
/3723
/3723C     F18CTR        IFGE      MAXDLT
/3723C                   EXFMT     DLTMSG
/3723C                   ENDIF
/3723
/3723C                   ITER
/3723C                   END
      * F12/16=Filter
     C     KEY           IFEQ      F16
     C     KEY           OREQ      F12
     C                   EXSR      FILTER
     C                   LEAVE
     C                   END
      * F13=RVIimgs
     C     F13           IFEQ      KEY
     C     'IMAG'        CAT(P)    'CVACL'       RVIPGM            9
     C                   MOVEL(P)  RVIPGM        OBJNAM           10
     C                   MOVEL(P)  '*LIBL   '    OBJLIB
     C                   MOVEL(P)  '*PGM    '    OBJTYP
     C                   EXSR      @CHKOB
     C     EXISTS        IFEQ      'Y'
     C                   CALL      RVIPGM
     C                   ELSE
     C                   MOVE      ERR(4)        MSGID
     C                   EXSR      SNDMSG
     C                   END
     C                   ITER
     C                   END
      *---------------------------------------------------------------
      *  Process selections on the SpyLink hits (SELIO).
      *  ReadC the subfile multiple times:
      *     Pass 1. Check security for all options. Pick off "View
      *             Images" only, and send to SpyCsImg DataQ.
      *     Pass 2. Count print and fax requests for passes 3+4.
      *     Pass 3. Process options other than View Image & Fax.
      *     Pass 4. Process fax requests.
      *---------------------------------------------------------------
     C     #SFLPG        IFGT      0
     C     GETCSR        IFEQ      0                                            Cursor
     C                   Z-ADD     1             GETCSR                          outside
     C                   ENDIF                                                   subfile.

     C                   MOVE      'N'           @JOINS                         JOIN PRINT
     C                   MOVE      ' '           REREAD            1
     C                   Z-ADD     GETCSR        CRRN1                          current
     C     TOPRCD        ADD       9             ENDRRN            5 0
     C                   CLEAR                   FIND
     C                   MOVE      '0'           CNLOPT            1
      *-------
      * PASS 1 Send view image requests SpyCsImg DataQ
      *-------
     C     CRRN1         IFGT      0
/3723
/3723 * Clear delete flag (used for later confirmation) and SUBFL2 rrn.
/3723C                   CLEAR                   DLTACT
/3723C                   MOVE      '0'           *IN97

/1892 *-----------------------------------------------------------
/     *   This code simulates a ReadC by searching for a
/     *   subfile record with the next subfile change
/     *   indicator on, but avoids rereading a record
/     *   previously read this has had its next subfile
/     *   record change indicator set back on.
/     *----------------------------------------------------------
/1892C                   Eval      intSfl1cnt = 0
     C
     C                   DO        *HIVAL
/1892C                   Eval      intSfl1cnt = intSfl1Cnt + 1
/    c     intSfl1Cnt    Chain     SubFl1
/    c                   If        %found
/    c
/    c                   If        Selio = *zero
/    c                   Iter
/    c                   Else
/    c                   Eval      blnSflChg1 = FALSE
/    c                   Update    SubFl1
/    c     intSfl1Cnt    Chain     SubFl1
/    c                   EndIf
/    c
/    c                   Else
/    c                   ExSr      ClrMsg
/    c                   leave
/    c                   EndIf
      *---------------------------------------------------------------
      * Do cursor position in subfile.
      *   If selection was done on displayable part of the screen
      *   Put the cursor on the last selection made in subfile,
      *   Otherwise display current subfile page and put cursor on the
      *   first entry.
     C     SFLRRN        IFGE      TOPRCD
     C     SFLRRN        ANDLE     ENDRRN
     C     SELIO         ANDNE     0
     C                   Z-ADD     SFLRRN        RCDNBR
     C                   ENDIF
      *---------------------------------------------------------------
      * App Sec Gatekeeper
     C     SELIO         IFGT      0
     C                   Z-ADD     SELIO         O#                2 0          Work field
     C                   SELECT
     C     SELIO         WHENEQ    2                                            Print
     C     SELIO         OREQ      13                                           FAX
     C                   Z-ADD     6             O#                              aut,6
     C     SELIO         WHENEQ    3                                            ATTACH
     C                   Z-ADD     1             O#                              aut,1
     C     SELIO         WHENEQ    7                                            ADDLinks
/4278C                   Z-ADD     3             O#                             Copy:aut,3
     C     SELIO         WHENEQ    8                                            ChgLinks
     C                   Z-ADD     2             O#                              aut,2
     C     SELIO         WHENEQ    17                                           MOVE
/4278C                   Z-ADD     9             O#                             Move:aut,9
     C     SELIO         WHENEQ    18                                           Notes
/5197C     NotesAuth     CASEQ     'N'           SNDEIA                         "Insuf auth"
/    C                   ENDCS
/    C                   GOTO      SKIPS1
     C     SELIO         WHENEQ    10                                           Vu RVI img
     C                   Z-ADD     23            O#                              aut,23
     C     SELIO         WHENEQ    11                                           Scan RVI
     C                   Z-ADD     24            O#                              aut,24
     C     SELIO         WHENEQ    14                                           TRACK IT
     C                   Z-ADD     1             O#                              aut,1
     C     SELIO         WHENEQ    25                                           Search
     C                   Z-ADD     1             O#                              aut,1
     C     SELIO         WHENEQ    31                                           START CASE
     C                   Z-ADD     1             O#
/4662C     SELIO         WHENEQ    4                                            Delete
/    C                   Z-ADD     4             O#                              aut,4
     C                   ENDSL
/4662C     AUT(O#)       CASNE     'Y'           SNDEIA                         "Insuf auth"
     C                   ENDCS
/4662C                   MOVE      AUT(4)        DLTFLD            1
/4662 ****
/    C     EXTSEC        IFEQ      'Y'

/    C                   Z-ADD     O#            REQOPT
/    C                   SELECT
/    C     SELIO         WHENEQ    2
/    C     SELIO         OREQ      13
/    C     SELIO         OREQ      5
/    C                   Z-ADD     1             reqopt
/    C     SELIO         WHENEQ    17
/    C                   Z-ADD     2             reqopt
/    C                   ENDSL

/5231c                   Z-ADD     1             REQOPT
/    C                   EXSR      @FSEC
/    C     FAUTH         IFNE      'Y'
/    C                   EXSR      SNDEIA
/    C                   END

/    C     DLTFLD        IFEQ      'Y'
/    C                   Z-ADD     4             REQOPT
/    C                   EXSR      @FSEC
/    C     FAUTH         IFNE      'Y'
/    C*/5231             MOVE      'N'           DLTFLD
/    C                   END
/    C                   END
/4662C                   END
      ****
     C                   END

/2839C     SKIPS1        TAG
     C                   MOVEL     LXSEC         READ              1
     C                   SUBST     LXSEC:2       DEL               1
     C                   SUBST     LXSEC:3       PRNT              1

/3765 * Do not allow delete or change if under revision control.
/3765c                   eval      RevLck = 0
/3765c                   if        (selio = 4 or selio = 8) and
/3765c                             GetWipBy_RevID(GetHedBy_ConID(
/3765c                             ldxnam + lxspg$)) > 0
/3765c                   eval      RevLck = 1
/3765c                   endif

     C     SELIO         IFEQ      1
     C     READ          ANDNE     'Y'
     C     SELIO         OREQ      3
     C     READ          ANDNE     'Y'
     C     SELIO         OREQ      5
     C     READ          ANDNE     'Y'
     C     SELIO         OREQ      2
     C     PRNT          ANDNE     'Y'
     C     SELIO         OREQ      14
     C     READ          ANDNE     'Y'
     C     SELIO         OREQ      25
     C     READ          ANDNE     'Y'
     C     SELIO         OREQ      31
     C     READ          ANDNE     'Y'
     C     SELIO         OREQ      13
     C     PRNT          ANDNE     'Y'
/4662 ***  SELIO         OREQ      8
/4662 ***  CHGFLD        ANDEQ     'N'
/3765c     selio         oreq      8
/3765c     RevLck        andeq     1
/3723 * Delete selected but not authorized.
/3723C     SELIO         OREQ      4
/3723C     DLTFLD        ANDNE     'Y'
      * Delete selected but key value greater than 70.
/3723C     SELIO         OREQ      4
/3723C     LNGKEY        ANDEQ     'Y'
/3723 * Delete selected but OmniLink relationship.
/3723C     SELIO         OREQ      4
/3723C     OMNFLG        ANDEQ     'Y'
/3723 * Delete selected and called through DSPHYPLNK - no delete.
/3723C     SELIO         OREQ      4
/3723C     @OMNI         ANDEQ     'Y'
/3765 * Cannot delete locked revision.
/3765c     selio         oreq      4
/3765c     RevLck        andeq     1
/3723 *                                                                is 99 and we don't have
/3723C                   SELECT
/3723C     DLTFLD        WHENNE    'Y'
     C                   MOVE      ERR(2)        MSGID                          Insufficient
/3723C     OMNFLG        WHENEQ    'Y'
/3723C                   MOVE      ERR(15)       MSGID                          OmniLink relationshi
/3723C     LNGKEY        WHENEQ    'Y'
/3723C                   MOVE      ERR(13)       MSGID                          Key exceeds 70 chara
/3723 *                                                    (can't be assured of results since
/3723 *                                                     max length is 99 and we don't have
/3723 *                                                     them all!) :-(
/3765c                   when      (selio = 4 or selio = 8) and RevLck = 1
/3765c                   eval      msgid = 'DMS0126'
/3765c                   other
      * check for exclusive revision control lock
/3765c                   move      lxspg$        lxspg$n           9 0
/    c                   if          OK <> ChkRCLock(ldxnam:lxspg$n:LockUser)
/    c                                  and LockUser <> *blanks
/    c                   eval      msgid  = 'ERR1619'
/    c                   eval      msgdta = LockUser
/    c                   end
/3723C                   ENDSL
/3765c                   if        msgid <> *blanks
     C                   EXSR      SNDMSG                                       error message
     C                   EXSR      @CLROP                                       Clr option
     C                   GOTO      SHOWS1
/3765c                   end
     C                   END

     C                   MOVEL     LDXNAM        LDXNM1            1
     C     SELIO         IFEQ      1                                            View image
     C     LDXNM1        ANDEQ     'B'
     C                   EXSR      SHOIMG
     C                   ELSE
     C                   MOVE      'Y'           REREAD
     C                   MOVE      *ON           *IN08                          SflNxtChg
/1892C                   UPDATE(e) SUBFL1
/    C                   If        ( %error = TRUE)
/    C                   Leave
/    C                   EndIf
     C                   END
     C                   ENDDO

     C     #IV           IFGT      0                                            Img views
     C                   EXSR      SNDIMG                                        Send 'em.
     C                   ENDIF
      *-------
      * PASS 2 Count print and fax requests
      *-------
     C     REREAD        IFEQ      'Y'
     C     1             CHAIN     SUBFL1                             98
     C                   MOVE      'N'           REREAD
     C                   Z-ADD     0             #PRT              5 0
     C                   Z-ADD     0             #FAX              5 0

     C     *IN98         DOWEQ     *OFF

     C     SELIO         IFGT      0
     C                   SELECT
     C     SELIO         WHENEQ    2                                            count print
     C                   ADD       1             #PRT                            for join
     C     SELIO         WHENEQ    13                                           count fax
     C                   ADD       1             #FAX                           for join
     C                   ENDSL
     C                   MOVE      'Y'           REREAD
     C                   MOVE      *ON           *IN08                          SflNxtChg
     C                   UPDATE    SUBFL1
     C                   ENDIF

     C                   READC     SUBFL1                                 98
     C                   ENDDO

     C     #IV           IFGT      0
     C                   EXSR      SNDPRT                                       Send print
     C                   ENDIF                                                   requests
     C                   ENDIF
      *-------
      * PASS 3 Do all options but fax
      *-------
     C     REREAD        IFEQ      'Y'
     C                   MOVE      'Y'           NUJOIN
     C                   MOVE      'N'           @JOINS
     C     1             CHAIN     SUBFL1                             98        Repos BOF.
     C     *IN98         DOWEQ     *OFF
     C     SELIO         IFNE      13                                           Not Fax
     C                   EXSR      DOOPT
     C                   ELSE
     C                   MOVE      *ON           *IN08                          SflNxtChg
     C                   UPDATE    SUBFL1
     C                   ENDIF
/2256
/    C     RTMSGI        IFEQ      'EXIT'
/    C                   MOVE      *BLANKS       RTMSGI
/    C                   LEAVE
/    C                   END
/2256
     C                   READC     SUBFL1                                 98
     C                   ENDDO
      *-------
      * PASS 4 Fax
      *-------
     C     #FAX          IFGT      0
     C                   MOVE      'N'           @JOINS
     C     1             CHAIN     SUBFL1                             98        Repos BOF.
     C     *IN98         DOWEQ     *OFF
     C     SELIO         IFEQ      13                                           Fax
     C                   EXSR      DOOPT
     C                   ELSE
     C                   MOVE      *ON           *IN08                          SflNxtChg
     C                   UPDATE    SUBFL1
     C                   ENDIF
     C                   READC     SUBFL1                                 98
     C                   ENDDO
     C                   END
     C                   END
     C                   END
     C                   END
/3723
/3723 * Confirm deletion.
/3723C     DLTACT        IFEQ      'Y'
/3723C                   EXSR      $CNFRM
/3723C                   ENDIF
/3723
      * If update then refresh
     C     INDUPD        IFEQ      '1'
     C                   EXSR      SRF5
     C                   CLEAR                   INDUPD
     C                   ENDIF

     C                   ENDDO
     C                   ENDDO

     C                   MOVE      KEY           RTNCDE
     C                   EXSR      RETURN

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR

     C     ACT210        IFEQ      'Y'
     C                   MOVEL(P)  'CLOSEW'      PRTRTN
     C                   EXSR      MAG210
     C                   CLEAR                   ACT210
     C                   ENDIF

     C                   MOVE      'Y'           SETLR                          Down
/6604C                   MOVE      'QUIT '       OPCODE
     C                   CALL      'SPYCSLNK'    PLSPY                           SpyCsLnk.

     C     SPCOPN        IFEQ      '1'
     C                   EXSR      CLSSPC
     C                   ENDIF

/3765c                   callp     DmsQuit

     C                   MOVE      *ON           *INLR
     C                   EXSR      RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     POSTO         BEGSR
      *          Position to

     C                   MOVE      *BLANKS       IFILTR
     C                   Z-ADD     0             LLSEQ
      * Put NVal1 in SetLL key
     C                   SELECT
     C     LFILE#        WHENEQ    1
     C                   MOVEL     NVAL1         LLIV1
     C     LFILE#        WHENEQ    2
     C                   MOVEL     NVAL1         LLIV2
     C     LFILE#        WHENEQ    3
     C                   MOVEL     NVAL1         LLIV3
     C     LFILE#        WHENEQ    4
     C                   MOVEL     NVAL1         LLIV4
     C     LFILE#        WHENEQ    5
     C                   MOVEL     NVAL1         LLIV5
     C     LFILE#        WHENEQ    6
     C                   MOVEL     NVAL1         LLIV6
     C     LFILE#        WHENEQ    7
     C                   MOVEL     NVAL1         LLIV7
     C     LFILE#        WHENEQ    8

     C     DATFMT        IFEQ      'YMD'                                        Convert to
     C                   MOVEL     NVAL1         WRKDT3                         yyyymmdd
     C                   MOVE      WYY3          WYY2
     C                   MOVE      WMM3          WMM2
     C                   MOVE      WDD3          WDD2
     C                   ELSE
     C                   MOVEL     NVAL1         WRKDT
     C                   MOVE      WYY           WYY2
     C     DATFMT        IFEQ      'DMY'                                        Convert to
     C                   MOVE      WMM           WDD2                           ddmmyyyy
     C                   MOVE      WDD           WMM2
     C                   ELSE
     C                   MOVE      WMM           WMM2                           Convert to
     C                   MOVE      WDD           WDD2                           mmddyyyy
     C                   END
     C                   END
     C                   MOVE      WRKDT2        LLIV8                          AscendingKey
     C                   MOVE      WRKDT2        LLIV9                          DescendingKy
     C                   MOVE      DATSEP        SLASH1
     C                   MOVE      DATSEP        SLASH2
     C                   ENDSL

     C                   EXSR      @SETLL
     C                   EXSR      CLRSFL
     C                   EXSR      @REDGT
     C                   CLEAR                   LCKPRV
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DOOPT         BEGSR

     C                   MOVE      '0'           FNDF14            1            F14=Find

     C     CNLOPT        IFNE      '1'

      *          ----------------------------------------
      *          Process options (second read of subfile)
      *          ----------------------------------------
     C     SELIO         CASEQ     1             VIEWER                         View REPORT
     C     SELIO         CASEQ     2             @CPRIN                         Print
/3723C     SELIO         CASEQ     4             $LDCFM                         Delete
     C     SELIO         CASEQ     13            @CPRIN                         Fax
     C     SELIO         CASEQ     3             ATTACT                         ATTACH ACTFI
     C     SELIO         CASEQ     5             @CVEW                          View attrs
     C     SELIO         CASEQ     7             UPDAT                          ADD NEW
     C     SELIO         CASEQ     8             UPDAT                          UPDATE
     C     SELIO         CASEQ     9             USREXT                         USER EXIT
     C     SELIO         CASEQ     10            @CRVI                          RVImg view
     C     SELIO         CASEQ     11            @CRVI                          RVImg scan
     C     SELIO         CASEQ     18            @NOTES                         NOTES
     C     SELIO         CASEQ     17            MOVE                           MOVE DOC
     C     SELIO         CASEQ     14            @TRACK                         TRACKING
     C     SELIO         CASEQ     25            @FIND                          FIND
     C     SELIO         CASEQ     31            $STRCS                         START CASE
     C                   ENDCS

     C     KEY           IFEQ      F3
     C     SELIO         ANDNE     2
     C     SELIO         ANDNE     13
     C     SELIO         ANDNE     10
     C     SELIO         ANDNE     11
     C     SELIO         ANDNE     31
     C                   MOVE      KEY           RTNCDE
     C                   EXSR      RETURN
     C                   END
     C                   ENDIF

     C                   EXSR      @CLROP                                       Clear opt
     C                   ENDSR
/3723 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3723 * Load selected entry to confirmation subfile.
/3723C     $LDCFM        BEGSR
/3723
/3723C     DLTACT        IFNE      'Y'
/3723C                   MOVE      '0'           *IN97                          -CLEAR SFL
/3723C                   WRITE     SFLCTL2
/3723C                   CLEAR                   CRRN2
/3723C                   Z-ADD     1             #RRN2
/3723C                   ENDIF
/3723
/3723C                   MOVE      'Y'           DLTACT            1
/3723C                   MOVE      '1'           *IN97                          -SFLDSP/CTL/END
/3723C                   ADD       1             CRRN2
/3723C                   MOVE      DXIV1         UINX01
/3723C                   MOVE      DXIV2         UINX02
/3723C                   MOVE      DXIV3         UINX03
/3723C                   MOVE      DXIV4         UINX04
/3723C                   MOVE      DXIV5         UINX05
/3723C                   MOVE      DXIV6         UINX06
/3723C                   MOVE      DXIV7         UINX07
/3723C                   MOVE      DXIV8         UINX08
/3723C                   MOVE      LDXNAM        UINXNM
/3723C                   MOVE      LXSEQ$        UISEQ
/3723C* NOT CORRECT FROM SDT   MOVE LXTYP     UITYP
/3723C                   MOVE      LXSPG$        UISTR
/3723C                   MOVE      LXEPG$        UIEND
/3723C                   WRITE     SUBFL2
/3723
/3723C     XLDENT        ENDSR
/3723 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3723 * Confirm delete request.
/3723C     $CNFRM        BEGSR
/3723
/7829c                   eval      sav_key# = Key#
/3723C                   EXSR      $DLTKY
/3723
/3723C     KEY           DOUEQ     F3
/3723C     KEY           OREQ      F10
/3723C     KEY           OREQ      F12
/3723C                   WRITE     CMDLIN2
/3723C                   EXFMT     SFLCTL2
/3723C                   Z-ADD     PAGRRN        #RRN2
/3723
/3723C     KEY           IFEQ      F3
/3723C                   EXSR      RETURN
/3723C                   ENDIF
/3723
/3723C     KEY           IFEQ      F10
/3723C                   EXSR      $DELET
/3723C                   ENDIF
/3723
/3723C                   ENDDO
/3723
/3723C                   EXSR      SRF5                                         -REFRESH
/7829C                   EXSR      GETFKY
/3723
/3723C     XCNFRM        ENDSR
/3723 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3723 * Load all entries from the confirmation subfile to the user
/3723 * index and submit the job.
/3723C     $DELET        BEGSR
/    C                   MOVE      FILNAM        RRNAM                          Big5
/    C                   MOVE      JOBNAM        RJNAM
/    C                   MOVE      PGMOPF        RPNAM
/    C                   MOVE      USRNAM        RUNAM
/    C                   MOVE      USRDTA        RUDAT
/    C                   MOVEL(P)  'DLTONLY'     UPDOPT

/3723
/3723 * Load the user index entries.
/3723C     *LIKE         DEFINE    CRRN2         LSTRN2
/3723C                   Z-ADD     CRRN2         LSTRN2
/3723
/3723C                   DO        LSTRN2        CRRN2
/3723C     CRRN2         CHAIN     SUBFL2                             96        -NOT FOUND
/3723
/    C                   MOVEL     UISEQ         SEQ90
/    C                   MOVEL     UINXNM        LDXNAM

/    C                   CALL      'SPYUPD'                             50
/    C                   PARM                    RRNAM            10
/    C                   PARM                    RJNAM            10
/    C                   PARM                    RPNAM            10
/    C                   PARM                    RUNAM            10
/    C                   PARM                    RUDAT            10
/    C                   PARM                    LDXNAM
/    C                   PARM                    SEQ90             9 0
/    C                   PARM                    UPDOPT           10
/    C                   PARM                    UPDRTN            1
/3723C                   ENDDO
/3723
/    C     UPDRTN        IFEQ      'D'
/    C                   MOVEL     'ACT0009'     MSGID                          DLT OK
/    C                   EXSR      SNDMSG
/    C                   ENDIF

/    C                   MOVE      '1'           INDUPD            1            DO RELOAD
/    C                   MOVE      '1'           UPDOPN            1            UPDAT OPEN
/3723
/3723C     XDELET        ENDSR
/3723 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3723 * F18=Repeat LAST selection to end of list.
/3723C     $F18          BEGSR
/3723
/3723C                   MOVE      'Y'           F18FLG            1
/3723C     *LIKE         DEFINE    CRRN1         F18CTR
/3723C                   CLEAR                   F18CTR
/3723
/3723C     *LIKE         DEFINE    CRRN1         LSTRN1
/3723C                   Z-ADD     CRRN1S        LSTRN1                         -last loaded
/3723
/3723 * READC to last selected (be sure to seton SFLNXTCHG.)
/3723C                   READC     SUBFL1                                 96    -NOT FOUND
/3723
/3723C     *IN96         DOWEQ     '0'
/3723C                   MOVE      '1'           *IN08                          -SFLNXTCHG
/3723C                   UPDATE    SUBFL1
/3723C                   READC     SUBFL1                                 96    -NOT FOUND
/3723C                   ENDDO
/3723
/3723 * Don't continue if delete was selected and user is not authorized
/3723 * or if OmniLink, or if option chosen is not delete.
/3723C     SELIO         IFEQ      4
/3723C     DLTFLD        ANDNE     'Y'
/3723C     SELIO         OREQ      4
/3723C     OMNFLG        ANDEQ     'Y'
/3723C***********SELIO     ORNE 4
/3723
/3723C                   SELECT
/3723C     SELIO         WHENNE    4
/3723C                   MOVE      ERR(16)       MSGID                          Only option 4.
/3723C     DLTFLD        WHENNE    'Y'
/3723C                   MOVE      ERR(2)        MSGID                          Insufficient authori
/3723C     OMNFLG        WHENEQ    'Y'
/3723C                   MOVE      ERR(15)       MSGID                          OmniLink
/3723C                   ENDSL
/3723
/3723C                   EXSR      SNDMSG
/3723C                   CLEAR                   F18FLG
/3723C                   GOTO      XF18
/3723C                   ENDIF
/3723
/3723 * Store last option entry in SELLST.
/3723C     *LIKE         DEFINE    SELIO         LSTSEL
/3723C                   MOVE      SELIO         LSTSEL
/3723C                   ADD       1             CRRN1
/3723
/3723 * Read any/all remaining entries already loaded and mark.
/3723C     CRRN1         DOWLE     LSTRN1
/3723C     F18CTR        ANDLT     MAXDLT
/3722C     CRRN1         CHAIN     SUBFL1                             99        -NOT FOUND
/3723C                   MOVE      LSTSEL        SELIO
/3723C                   MOVE      '1'           *IN08                          -SFLNXTCHG
/3723C                   UPDATE    SUBFL1
/3723C                   ADD       1             CRRN1
/3723
/3723C     LSTSEL        IFEQ      4
/3723C                   ADD       1             F18CTR
/3723C                   ENDIF
/3723
/3723C                   ENDDO
/3723
/3723 * EXSR @MORE until filled or max subfile records. If max subfile
/3723 * records, send message.
/3723C                   MOVE      'F'           DIRECT
/3723
/3723C     *IN99         DOWNE     '1'
/3723C     F18CTR        ANDLE     MAXDLT
/3723C                   EXSR      @MORE
/3723C                   ENDDO
/3723
/3723C     XF18          ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETSEG        BEGSR
      *          ---------------------------------------------------
      *          Select SHSFIL (Dst Seg filename) by calling WRKRSL
      *          ---------------------------------------------------
      *          Gateway: If  the sysenv DSTLNK =Y (limit hits to seg)
      *                   and we are interactive,
      *                   and we weren't called by DspHypLnk,
      *                   and this report has distribution,
      *                  then have the user select a report segment
      *          ---------------------------------------------------
     C                   MOVE      *BLANKS       SHSFIL

     C     DSTLNK        IFEQ      'Y'
     C     BATCH         ANDEQ     'N'
     C     @OMNI         ANDEQ     'N'
     C     RTYPID        CHAIN     RSEGHDR                            95
     C     *IN95         IFEQ      *OFF
      *                                                    Called by
     C     WQPRM         IFEQ      9                                            WrkSpr/Sp2
     C                   MOVE      'Y'           CHOOSE            1             Choose seg.
     C                   ELSE
     C                   MOVE      'N'           CHOOSE                          No choice
     C                   END

      * If this program was not called recursively, call WRKRSL.
      * Else clone WRKRSL and call the clone (NEWPGM=WRKRSL0xxx)

     C     PLWRSL        PLIST
     C                   PARM                    RTYPID                           Rpt Type
     C                   PARM                    CHOOSE
     C                   PARM                    SEGNAM           10              Rtn SegNm
     C                   PARM                    SHSFIL                           Rtn PfilNm

/5921c                   if        pgmsfx <> ' '
     C                   MOVE      'WRKRSL'      PGMNAM
     C     'WRKRSL0'     CAT       PGMSFX:0      NEWPGM
     C                   CALL      'CLNSPYPR'    PLCLON
     C     PLCLON        PLIST
     C                   PARM                    PGMNAM           10
     C                   PARM                    NEWPGM           10
     C                   CALL      NEWPGM        PLWRSL                 50
     C                   END

     C     SHSFIL        IFEQ      '*PEND'
     C     *IN90         IFEQ      '0'                                          Not power user
/2249C                   MOVEL     'NOTBUILT'    SHSFIL
     C                   ELSE
     C                   MOVE      *BLANKS       SHSFIL
     C                   ENDIF
     C                   ENDIF

     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SHOIMG        BEGSR
      *          ----------------------------------------
      *          User has requested viewing of an image...
      *          -----------------------------------------
      * Queue this request by storing RRN in VI array.
      * If we have 9 images queued for viewing, ship'em.

     C                   ADD       1             #IV                            Bump and
     C                   Z-ADD     CRRN1         VI(#IV)                         save RRN.
     C                   EXSR      @CLROP                                       Clear optn.

     C     #IV           IFEQ      9                                            Full (9)
     C                   EXSR      SNDIMG
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDIMG        BEGSR
      *          ------------------------------------------------------
      *          Call SpyLnkVu up to 9 times for 9 images.
      *          #IV is number of images to view.  IM# is this img's #.
      *          ------------------------------------------------------
     C                   Z-ADD     CRRN1         SAVRRN            4 0          Save RRN.
     C                   Z-ADD     #IV           #LOOPS            1 0

     C                   DO        #LOOPS        IM#               3 0          For # imgs,
     C     VI(IM#)       CHAIN     SUBFL1                             50         get subfile
     C                   MOVE      IM#           IM#1              1             data.
     C                   MOVEL     IM#1          #IV
     C                   EXSR      VIEWER
/2256
/    C     RTMSGI        IFEQ      'EXIT'
/    C                   MOVE      *BLANKS       RTMSGI
/    C                   LEAVE
/2256C                   END
     C                   ENDDO

     C     BATCH         IFEQ      'N'                                          Interactive
     C     MSGID         ANDEQ     *BLANKS
     C     IMGDSP        ANDNE     '1'
     C                   MOVE      ERR(9)        MSGID
     C                   EXSR      SNDMSG                                        progress
     C                   ENDIF

     C                   Z-ADD     0             #IV
     C     SAVRRN        CHAIN     SUBFL1                             50
     C                   SETON                                        08        Force Chg
     C                   UPDATE    SUBFL1
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDPRT        BEGSR
      *          ------------------------------------------------------
      *          Call SpyLnkVu for each image to print
      *          #IV is number of images to print  IM# is this img's #.
      *          ------------------------------------------------------
     C                   Z-ADD     CRRN1         SAVRRN            4 0
     C                   Z-ADD     #IV           #LOOPS            1 0

     C                   DO        #LOOPS        IM#               3 0          For # imgs
     C     VI(IM#)       CHAIN     SUBFL1                             50
     C                   MOVE      IM#           IM#1              1
     C                   MOVEL     IM#1          #IV
      * Call SPYLNKVU for (P)rint
     C                   MOVE      'P'           VIWACT                         Print
     C                   EXSR      VIEWER
     C                   MOVE      *BLANKS       VIWACT
/2256
/    C     RTMSGI        IFEQ      'EXIT'
/    C                   MOVE      *BLANKS       RTMSGI
/    C                   LEAVE
/2256C                   END
     C                   ENDDO

     C     BATCH         IFEQ      'N'                                          Interactive
     C     MSGID         IFEQ      *BLANKS
     C                   MOVE      ERR(11)       MSGID
     C                   END
     C                   EXSR      SNDMSG
     C                   END

     C                   Z-ADD     0             #IV
     C     SAVRRN        CHAIN     SUBFL1                             50
     C                   SETON                                        08
     C                   UPDATE    SUBFL1
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     VIEWER        BEGSR
      *          -----------------------------------------------
      *          1=Select. Call SpyLnkVu to display report/image
      *          -----------------------------------------------
     C                   Z-ADD     1             UNLOAD            1 0

      * BUILD SPYLINK DATA STRUCTURE
     C                   EXSR      @SDT
      /free
J5350  if getImgSeq = 'Y' and idiloc <> '2';
J5350    sdtSeq = %char(getSeqNum(sdtNam:%int(sdtSpg)));
J5350  endif;
      /End-free
     C                   MOVEL     SDT           SDTPRM

J4258 /free
J4258  if (CoExURL = 'Y' or CoExURL = 'B') and
J4258    ((CoExURLImg = 'Y' and %subst(sdtNam:1:1) = 'B') or
J4258    (CoExURLRpt = 'Y' and %subst(sdtNam:1:1) = 'S'));
J4258    if clientOpt = ' ';
J4258      clientOpt = '1';
J4258    endif;
J4258    if CoExURL = 'B';
J4258      exfmt CoExChoice;
J4258      if key = F3 or key = F12;
J4258        leavesr;
J4258      endif;
J4258    endif;
J4258    if clientOpt = '1'; // CoEx selected as viewer.
J4796      if coExImgView() <> 0;
J4796        exsr sndmsg;
J4796      endif;
J4796      leavesr;
J4258    endif;
J4258  endif;
J4258 /end-free

      * Send either a Caller ID or the Partial PgTbl name
     C     SHSFIL        IFEQ      *BLANKS
/2249C     SHSFIL        OREQ      'NOTBUILT'
     C                   MOVEL(P)  '*SPYLINK'    CALPPT
     C                   ELSE
     C                   MOVEL     SHSFIL        CALPPT
     C                   END

      * If this program was not called recursively, call SPYLNKVU.
      * Else clone SPYLNKVU and call the clone (NEWPGM=SPYLNKVxxx)

     C     PGMSFX        IFEQ      *BLANK                                       Not recursiv
     C                   CALL      'SPYLNKVU'    PLVIEW
     C                   ELSE                                                   Recursive
/5921C                   MOVE      'SPYLNKVU'    PGMNAM           10              Copy this
     C     'SPYLNKV'     CAT       PGMSFX:0      NEWPGM                           To this
     C                   CALL      'CLNSPYPR'    PLCLON
     C                   CALL      NEWPGM        PLVIEW
     C                   END

     C     PLVIEW        PLIST
     C                   PARM                    LNKFIL                         @Filename
     C                   PARM                    LDXNAM                         SPY0../B0..
     C                   PARM                    LXSEQ#                         Sequence #
     C                   PARM                    LXSPGN                         Start
     C                   PARM                    LXEPGN                         End
     C                   PARM                    PRNT                           Print auth
     C                   PARM                    SDTPRM                         DATA
     C                   PARM                    E#IV                           Image #s
     C                   PARM                    VIWACT            1            V)iew/P)rint
     C                   PARM                    RTYPID                         RMaint RType
     C                   PARM                    CALPPT           10            Callr/PgTbl
     C                   PARM                    RTMSGI            7            Rtn Msg ID
     C                   PARM                    RTMSGD          100            Rtn Msg DATA

/3765c                   eval      PassFail = 1
     C                   SELECT
     C     RTMSGI        WHENEQ    'TERMINL'
     C                   MOVE      *BLANKS       RTMSGI
     C                   MOVE      *BLANKS       RTMSGD
/3765c                   eval      PassFail = 0
     C     RTMSGI        WHENNE    *BLANKS
/2256C     RTMSGI        ANDNE     'EXIT'
     C                   MOVEL     RTMSGI        MSGID
     C                   MOVEL(P)  RTMSGD        MSGDTA
     C                   EXSR      SNDMSG
     C                   MOVE      '7'           ERR#              1
/3765c                   eval      PassFail = 0
/2256C     RTMSGI        WHENNE    'EXIT'
/8729C                   MOVEL     LDXNAM        RPTTST            1
/8729C     RPTTST        IFEQ      'S'
     C                   MOVE      ERR(12)       MSGID                          Rpt linked
     C                   EXSR      SNDMSG                                       to display.
/3765c                   eval      PassFail = 1
     C                   ENDIF
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANK        ERR#
     C                   ENDSL

/3765c                   if        RTMSGI <> ' ' and
/    c                             RTMSGI <> 'EXIT'
/    c                   endif

     C     API           IFEQ      'V'                                          If View API
     C     OPCDE         ANDNE     '*SELECT'                                     NO SELECT
     C     MSGID         IFEQ      'ERR156A'                                    "Start your
     C                   MOVE(P)   'D'           RTNCDE                          OmniServer"
     C                   ELSE
     C                   MOVE(P)   ERR#          RTNCDE
     C                   END
     C     ERR#          IFNE      ' '                                          If error or
     C     APIONE        OREQ      'Y'                                           vu only one
     C                   EXSR      RETURN                                        return.
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $STRCS        BEGSR
      * START A STAFFVIEW CASE

      * BUILD SPYLINK DATA STRUCTURE
     C                   EXSR      @SDT
     C                   MOVEL     SDT           SDTPRM

      * PROMPT TO START A CASE
     C                   CALL      'MAG8021'                            50
     C                   PARM                    RTYPID                         RMaint RType
     C                   PARM                    SDTPRM                         DATA
     C                   PARM                    SVRTN             7            Return Code

     C                   MOVE      'Y'           A8021             1            PGM ACTIVE
     C                   MOVE      SVRTN         KEY
      * Error
     C     *IN50         IFEQ      *ON
     C     SVRTN         ORNE      *BLANKS
     C                   SELECT
     C     *IN50         WHENEQ    *ON                                          PGM blew
     C                   MOVE      '1'           CNLOPT
     C                   MOVEL     'ERR1089'     MSGID
     C     KEY           WHENEQ    F3                                           F3=Exit or
     C     SVRTN         OREQ      'ERR138A'                                    F12=Cancel
     C                   MOVE      '1'           CNLOPT
     C                   MOVE      'ERR138A'     MSGID
     C                   OTHER
     C                   MOVEL     SVRTN         MSGID
     C                   ENDSL
     C                   EXSR      SNDMSG
     C                   END

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @SDT          BEGSR

     C                   MOVE      LXSEQ$        LXSEQ#            9 0

/5921c                   if        (lxloc = '4' or lxloc = '5' or lxloc = '6')
/    c                             or (dstlnk = 'Y' and not *in90 and
T6294c                             not *in95 and lxro# <> ' ' and lxrf# <> ' ')
     C                   MOVE      LXRO#         LXSPGN            9 0          R/DARS OFFSE
     C                   MOVE      LXRF#         LXEPGN            9 0          R/DARS FILE#
     C                   ELSE
     C                   MOVE      LXSPG$        LXSPGN            9 0
     C                   MOVE      LXEPG$        LXEPGN            9 0
     C                   END
      * Move parms
     C                   MOVEL(P)  DXIV1         SDTRV1
     C                   MOVEL(P)  DXIV2         SDTRV2
     C                   MOVEL(P)  DXIV3         SDTRV3
     C                   MOVEL(P)  DXIV4         SDTRV4
     C                   MOVEL(P)  DXIV5         SDTRV5
     C                   MOVEL(P)  DXIV6         SDTRV6
     C                   MOVEL(P)  DXIV7         SDTRV7
     C                   MOVEL(P)  DXIV8         SDTRV8
     C                   MOVE      LXSPG$        SDTSPG
     C                   MOVE      LXEPG$        SDTEPG
     C                   MOVE      LXSEC         SDTSEC
     C                   MOVE      LXSEQ$        SDTSEQ
     C                   MOVE      LDXNAM        SDTNAM
     C                   MOVE      LXTYP         SDTTYP
     C                   MOVE      LXFIL         SDTFIL
     C                   MOVE      LXEXT         SDTEXT
     C                   MOVE      LXLIB         SDTLIB
     C                   MOVE      LXBI5         SDTBI5
     C                   MOVE      LXLOC         SDTLOC
     C                   MOVE      LXNOT         SDTNOT
     C                   MOVE      LXRO#         SDTRO#                         R/DARS OFFSE
     C                   MOVE      LXRF#         SDTRF#                         R/DARS FILE#
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     IFAPI         BEGSR
      *          If we were called by an API, load SELIO, API, APIIND

     C                   MOVE      ' '           API               1
     C                   MOVE      ' '           APIIND            1

     C                   SELECT
     C     WQPRM         WHENEQ    19                                           View Api
     C                   Z-ADD     1             SELIO                           View
     C                   MOVE      'V'           API

     C     WQPRM         WHENEQ    26                                           Print Api
     C                   Z-ADD     2             SELIO                           Print
     C                   MOVE      'P'           API
     C     WRINTR        IFEQ      *BLANKS
     C                   EXSR      CHKQ
     C                   ENDIF

     C     WQPRM         WHENGT    26                                           Fax Api, not
     C     WQPRM         ANDLT     61                                            SPYAPICMD
     C                   Z-ADD     13            SELIO                            Send
     C                   MOVE      'F'           API                              Fax
     C     WRINTR        IFEQ      *BLANKS
     C                   EXSR      CHKQ
     C                   ENDIF

     C     WQPRM         WHENGE    61                                           SPYAPICMD
     C                   SELECT
     C     OPCDE         WHENEQ    '*VIEW'
     C                   Z-ADD     1             SELIO
     C                   MOVE      'V'           API                             View
     C     OPCDE         WHENEQ    '*PRINT'
     C                   Z-ADD     2             SELIO
     C                   MOVE      'P'           API                             Print
J2096 /free
J2096  when %subst(opcde:1:7) = '*DELETE';
J2096    selio = 4;
      /end-free
     C     OPCDE         WHENEQ    '*EMAIL'
     C                   Z-ADD     13            SELIO                           Send
     C                   MOVE      'M'           API                              Mail
J2473C                   when      %subst(opcde:1:4) = '*IFS'
     C                   Z-ADD     13            SELIO                           Send
     C                   MOVE      'I'           API                              Ifs
     C     OPCDE         WHENEQ    '*FAXSTAR'
     C     OPCDE         OREQ      '*IBMFAX'
     C     OPCDE         OREQ      '*RYDEX'
     C     OPCDE         OREQ      '*FASTFAX'
     C     OPCDE         OREQ      '*FAXSYS'
     C     OPCDE         OREQ      '*DIRECT'
     C     OPCDE         OREQ      '*FAXACS'
/6924C     OPCDE         OREQ      '*FAXCOM'
     C     OPCDE         OREQ      TLXFAX                                       *TELEXFAX
     C     OPCDE         OREQ      FAXSVR                                       *FAXSERVER
     C     OPCDE         OREQ      SBMFAX                                       *IBMSBMFAX
     C                   Z-ADD     13            SELIO                           Send
     C                   MOVE      'F'           API                              Fax
     C                   ENDSL
     C                   ENDSL

     C     API           IFEQ      'I'                                          INIT USRSPC
     C                   EXSR      INISPC
     C                   ENDIF

     C     WQPRM         IFGT      9
     C     WQPRM         IFGE      41                                           41+
     C     OPCDE         ANDEQ     '*SELECT'
     C                   CLEAR                   SELIO
     C                   ELSE                                                   10-40
     C                   CLEAR                   FIRST
     C                   ENDIF
     C                   ENDIF

     C     API           IFNE      *BLANK
     C                   MOVE      '1'           APIIND
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CHKOB        BEGSR
      *          Set EXISTS=Y if object exists

     C                   Z-ADD     272           BYTPRV                         Error Code
     C                   CLEAR                   BYTAVA
     C     OBJNAM        CAT       OBJLIB        OBJECT
     C                   CALL      'QUSROBJD'
     C                   PARM                    @OBJD                          Retrieve
     C                   PARM      90            APILEN                         Obj
     C                   PARM      'OBJD0100'    APIFMT            8            Descr
     C                   PARM                    OBJECT
     C                   PARM                    OBJTYP
     C                   PARM                    ERROR

     C     BYTAVA        IFEQ      0
     C                   MOVE      'Y'           EXISTS            1
     C                   ELSE
     C                   MOVE      'N'           EXISTS
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CRVI         BEGSR
      *          10,11=Call RVI's API for working with images

     C     SELIO         IFEQ      10
     C                   MOVEL     RVIVEW        RVIPGM                         Show RVI Img
     C                   ELSE
     C                   MOVEL     RVISCN        RVIPGM                         Scan RVI Img
     C                   END

     C                   MOVE      *BLANKS       RVIRTN            2
     C                   MOVEL     LXIV1         RVI1
     C                   MOVEL     LXIV2         RVI2
     C                   MOVEL     LXIV3         RVI3
     C                   MOVEL     LXIV4         RVI4
     C                   MOVEL     LXIV5         RVI5
     C                   MOVEL     LXIV6         RVI6
     C                   MOVEL     LXIV7         RVI7
     C                   MOVEL     'E'           RVIID
     C                   MOVEL     RVIP          RVIPAR          211
     C                   CALL      RVIPGM
     C                   PARM                    RVIPAR
     C                   PARM                    RVIRTN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FILTER        BEGSR
      *          F12,F16=Filter criteria screen
      *                                                    Fill INDXO1-
     C                   EXSR      FILT1                                             INDXO7,
      *>>>>                                                seton 61-68.
     C     SELCRT        TAG
     C                   XFOOT     LE            LE#               2 0          Which scrn

     C     KLBIG5        CHAIN     LNKDEF                             52
     C     *IN52         IFEQ      *OFF
     C     RDSPF         ANDNE     *BLANKS
     C     CRTERR        ANDNE     '1'

     C                   MOVEL     LOFILI        LSTFIL
     C     *LIKE         DEFINE    LOFILI        LSTFIL

     C                   MOVE      'Y'           UNSCH2            1

     C                   CALL      'SPYSCH2'     PLSCH2                         NOT WRKSPIFM
     C     PLSCH2        PLIST
     C                   PARM                    FILNAM
     C                   PARM                    JOBNAM
     C                   PARM                    PGMOPF
     C                   PARM                    USRNAM
     C                   PARM                    USRDTA
     C                   PARM                    INDXI1
     C                   PARM                    INDXI2
     C                   PARM                    INDXI3
     C                   PARM                    INDXI4
     C                   PARM                    INDXI5
     C                   PARM                    INDXI6
     C                   PARM                    INDXI7
     C                   PARM                    INDXI8           59
     C                   PARM                    INDXI9           59
     C                   PARM                    AOQ                            AND/OR
     C                   PARM                    FNQ                            FIELDS
     C                   PARM                    TEQ                            TEST
     C                   PARM                    VAQ                            VALUES
     C                   PARM                    QRYTYP            1            QRY TYPE
     C                   PARM                    LOOPID           10            Opt ID
     C                   PARM                    LODRV            15            Opt DRIVE
     C                   PARM                    LOVOL            12            Opt Vol
     C                   PARM                    LODIR            80            Directory
     C                   PARM                    LOFILI                         Opt FileName
     C                   PARM      *BLANKS       RTNKEY            1            Return key

     C                   MOVE      RTNKEY        KEY


/6604c     key           ifeq      F5                                           viewed online links
/    c     key           oreq      F7                                           viewed offline links
/    c     key           oreq      F3
/    c     key           oreq      F12
/     *  Clear handle
/    c                   exsr      @clrwh                                       clear window handle
/6604c                   endif

     C     KEY           IFEQ      F12
     C     KEY           OREQ      F3
     C                   MOVE      KEY           RTNCDE
     C                   EXSR      RETURN
     C                   END
      * If query was requested, do *share on dspf for atn cancel
     C     FNQ(1)        IFNE      *BLANKS
     C                   MOVE      '1'           QUERY
     C                   MOVEL(P)  OVRDSP        CLCMD                          SHARE(*YES)
     C                   EXSR      RUNCL
     C                   ELSE
     C                   MOVE      ' '           QUERY             1
     C                   ENDIF

     C     KEY           IFEQ      '1'
     C                   MOVE      '1'           CRTERR            1
      *                         "Cannot create Filter Screen"
     C                   MOVEL     'ERR0092'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        CRIMSG
     C                   GOTO      REDISP
     C                   ENDIF

     C     LOFILI        IFGT      *BLANK
     C                   MOVE      '1'           LASER             1            From Optical
     C                   ELSE
     C                   MOVE      '0'           LASER                          From Dasd
     C                   END

     C     PHYFIL        IFEQ      *BLANKS
     C     LOFILI        ANDNE     *BLANKS
     C                   MOVE      LOFILI        PHYFI2
     C                   ELSE
     C                   MOVE      PHYFIL        PHYFI2
     C                   ENDIF

     C     LOFILI        IFNE      LSTFIL
     C                   MOVE      'N'           IDXCG             1
     C                   EXSR      SETSCN
     C                   ENDIF

     C                   MOVEL     INDXI8        TEMP8             8            If from date
     C     TEMP8         IFNE      *ZEROS                                        empty or
     C     NUMBRS        CHECK     TEMP8                                  58     has
     C   58              MOVE      *ZEROS        TEMP8                           alpha,
     C                   END
      *                                                     fill
     C     TEMP8         IFEQ      *ZEROS                                        alpha.
     C                   MOVE      'YYYYMMDD'    INDX8S
     C                   ELSE                                                   Numeric date
     C                   MOVEL     INDXI8        TEMP8
     C                   EXSR      EXTFDT
     C                   MOVE      TEMP8Y        INI8BY
     C                   MOVE      TEMP8M        INI8BM
     C                   MOVE      TEMP8D        INI8BD
     C                   ENDIF

     C                   MOVEL     INDXI9        TEMP8
     C     TEMP8         IFNE      *ZEROS
     C     NUMBRS        CHECK     TEMP8                                  58
     C   58              MOVE      *ZEROS        TEMP8
     C                   END

     C     TEMP8         IFEQ      *ZEROS
     C                   MOVEL     'YYYYMMDD'    INDX8E
     C                   ELSE
     C                   EXSR      EXTFDT
     C                   MOVE      TEMP8Y        INI8EY
     C                   MOVE      TEMP8M        INI8EM
     C                   MOVE      TEMP8D        INI8ED
     C                   ENDIF
      *------------------------------------------
      * If query, write out ww screen first and
      * Unlock the keybord for the atn escape key
      *------------------------------------------
     C     FNQ(1)        IFNE      *BLANKS
     C                   WRITE     CMDLIN1
     C                   MOVE      *OFF          *IN42                          SFLDSP
     C                   MOVE      *ON           *IN41                          SFLCLR
     C                   WRITE     SFLCTL1
     C                   MOVE      *OFF          *IN41
     C                   WRITE     DOQRY                                        QRY RUNNING
      *            RETURNED KEY GET OVERWRITTEN
     C                   MOVE      RTNKEY        KEY
     C                   ENDIF

     C                   ELSE                                                   Use Standard
      *                                                    WRKSPIFM
     C                   OPEN      RLNKOFF
     C     KLBIG5        SETLL     RLNKOFF                                98    =LinksOfflin
     C     *IN98         IFEQ      *ON
     C                   CLEAR                   LOOPID
     C                   CLEAR                   LODRV
     C                   CLEAR                   LOVOL
     C                   CLEAR                   LODIR
     C                   CLEAR                   LOFILI
     C                   MOVE      *ON           *IN24
      *                        "F4=Opt Link  F5=Dasd Link"
     C                   MOVEL     ERR(5)        @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        F4F5OP
     C                   ELSE
     C                   MOVE      *OFF          *IN24
     C                   MOVE      *BLANKS       F4F5OP
     C                   END
     C                   CLOSE     RLNKOFF

     C     REDISP        TAG

     C                   SELECT
     C     2             WHENEQ    LE#
     C                   EXFMT     SELCR2
     C     3             WHENEQ    LE#
     C                   EXFMT     SELCR3
     C     4             WHENEQ    LE#
     C                   EXFMT     SELCR4
     C     5             WHENEQ    LE#
     C                   EXFMT     SELCR5
     C     6             WHENEQ    LE#
     C                   EXFMT     SELCR6
     C     7             WHENEQ    LE#
     C                   EXFMT     SELCR7
     C     8             WHENEQ    LE#
     C                   EXFMT     SELCR8
     C                   ENDSL

     C                   CLEAR                   CRIMSG

/1452C     KEY           DOWEQ     HELP                                         Help
     C                   MOVEL(P)  'SELCR2'      HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   SELECT
/1452C     2             WHENEQ    LE#
/1452C                   READ      SELCR2                                 99
/1452C     3             WHENEQ    LE#
/1452C                   READ      SELCR3                                 99
/1452C     4             WHENEQ    LE#
/1452C                   READ      SELCR4                                 99
/1452C     5             WHENEQ    LE#
/1452C                   READ      SELCR5                                 99
/1452C     6             WHENEQ    LE#
/1452C                   READ      SELCR6                                 99
/1452C     7             WHENEQ    LE#
/1452C                   READ      SELCR7                                 99
/1452C     8             WHENEQ    LE#
/1452C                   READ      SELCR8                                 99
/1452C                   ENDSL
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO REDISP
/1452C                   ENDDO

     C     KEY           IFEQ      F5                                           -----------
     C                   MOVE      '0'           LASER                          Switch to
     C                   MOVE      *BLANKS       LOOPID                         Dasd
     C                   MOVE      *BLANKS       LODRV                          ------------
     C                   MOVE      *BLANKS       LOVOL
     C                   MOVE      *BLANKS       LODIR
     C                   MOVE      *BLANKS       LOFILI

     C     RRDESC        IFNE      *BLANKS
     C                   MOVE      RRDESC        OPTITL
     C                   ELSE
     C                   MOVE      *BLANKS       OPTITL
     C                   END

     C                   MOVEL     ERR(7)        @ERCON                         Switch loc
     C                   EXSR      RTVMSG                                       prompt
     C                   MOVEL     @MSGTX        STORAG                         to DASD
     C                   GOTO      REDISP
     C                   END

     C     KEY           IFEQ      F4                                           -----------
     C                   CALL      'MAG904'                                     OpticalLink
     C                   PARM                    RTNCDE                         -----------
     C                   PARM                    FILNAM           10            Big5
     C                   PARM                    JOBNAM           10             "
     C                   PARM                    PGMOPF           10             "
     C                   PARM                    USRNAM           10             "
     C                   PARM                    USRDTA           10             "
     C                   PARM                    LOODES           40            Optical Desc
     C                   PARM      *BLANKS       LOOPID                         Dasd
     C                   PARM      *BLANKS       LODRV                          Dasd
     C                   PARM      *BLANKS       LOVOL            12            Opt Vol
     C                   PARM      *BLANKS       LODIR            80            Directory
     C                   PARM      *BLANKS       LOFILI                         Opt FileName

     C     LOFILI        IFGT      *BLANK                                       Optical
     C                   MOVE      '1'           LASER             1             Spylnk
     C                   MOVE      LOODES        OPTITL           40
     C                   MOVEL     ERR(6)        @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        STORAG

     C                   ELSE
     C                   MOVE      '0'           LASER                          Else
      *                                                     Dasd
     C     RRDESC        IFNE      *BLANKS                                       Spylnk
     C                   MOVE      RRDESC        OPTITL
     C                   ELSE
     C                   MOVE      *BLANKS       OPTITL
     C                   END

     C                   MOVEL     ERR(7)        @ERCON                         Dasd
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        STORAG
     C                   END
     C                   GOTO      REDISP                                       Redisplay
     C                   END
     C                   END

     C     KEY           IFEQ      F3
     C     KEY           OREQ      F12
     C                   MOVE      KEY           RTNCDE
     C                   EXSR      RETURN

     C                   ELSE
     C                   EXSR      FILT2                                        Edit filter
     C     FILT2F        CABEQ     'Y'           SELCRT                         Error

      * Set text 'filter on' or 'query on'
     C                   EXSR      SETTXT

     C                   EXSR      CLRSFL
     C                   Z-ADD     0             OVRL#

     C     LASER         IFNE      '1'
     C                   MOVEL(P)  'WRKSPID'     @HNDL                          Window Handl
     C                   ELSE
     C                   MOVEL(P)  'WRKSPIO'     @HNDL
     C                   ENDIF
      * Get 1st 10 matches
     C                   EXSR      @SELCR
     C                   EXSR      LODPSN                                       Load NPOS
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     EXTFDT        BEGSR
      *          Extract filter date year, month, and day values

     C                   SELECT
     C     DATFMT        WHENEQ    'YMD'
     C                   SUBST     TEMP8:1       TEMP8Y            4
     C                   SUBST     TEMP8:5       TEMP8M            2
     C                   SUBST     TEMP8:7       TEMP8D            2
     C     DATFMT        WHENEQ    'DMY'
     C                   SUBST     TEMP8:1       TEMP8D
     C                   SUBST     TEMP8:3       TEMP8M
     C                   SUBST     TEMP8:5       TEMP8Y
     C                   OTHER
     C                   SUBST     TEMP8:1       TEMP8M
     C                   SUBST     TEMP8:3       TEMP8D
     C                   SUBST     TEMP8:5       TEMP8Y
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETTXT        BEGSR
      *          Set text 'Filter on' or 'Query on'

     C                   CLEAR                   SELTXT
     C     FNQ(1)        IFNE      *BLANKS
     C                   MOVEL     QRYTXT        SELTXT                          "Query on"
     C                   ELSE
     C     INDXI1        IFNE      *BLANK
     C     INDXI2        ORNE      *BLANK
     C     INDXI3        ORNE      *BLANK
     C     INDXI4        ORNE      *BLANK
     C     INDXI5        ORNE      *BLANK
     C     INDXI6        ORNE      *BLANK
     C     INDXI7        ORNE      *BLANK
     C     INI8BM        ORNE      'DD'
     C     INI8BM        ANDNE     'MM'
     C     INI8EM        ORNE      'DD'
     C     INI8EM        ANDNE     'MM'
     C                   MOVEL     FLTTXT        SELTXT                          "Filter on"
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FILT1         BEGSR
      *          Filter setup Part 1, index field prompts

      *          For each IN,n (1-8) not blank:
      *              Set on corresponding indicator, 61-68.
      *              Move the IN value to INDXOn field (excpt INDXO8).

     C     IN(1)         IFNE      *BLANKS
     C                   MOVE      *ON           *IN61
     C                   MOVE      IN(1)         INDXO1                         I N D X Oh 1
     C                   END
     C     IN(2)         IFNE      *BLANKS
     C                   MOVE      *ON           *IN62
     C                   MOVE      IN(2)         INDXO2                         I N D X Oh 2
     C                   END
     C     IN(3)         IFNE      *BLANKS
     C                   MOVE      *ON           *IN63
     C                   MOVE      IN(3)         INDXO3
     C                   END
     C     IN(4)         IFNE      *BLANKS
     C                   MOVE      *ON           *IN64
     C                   MOVE      IN(4)         INDXO4
     C                   END
     C     IN(5)         IFNE      *BLANKS
     C                   MOVE      *ON           *IN65
     C                   MOVE      IN(5)         INDXO5
     C                   END
     C     IN(6)         IFNE      *BLANKS
     C                   MOVE      *ON           *IN66
     C                   MOVE      IN(6)         INDXO6
     C                   END
     C     IN(7)         IFNE      *BLANKS
     C                   MOVE      *ON           *IN67
     C                   MOVE      IN(7)         INDXO7
     C                   END
     C     IN(8)         IFNE      *BLANKS
     C                   MOVE      *ON           *IN68
     C                   END

     C                   MOVE      *BLANKS       TMP9
     C                   MOVE      *BLANKS       CRIMSG
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FILT2         BEGSR
      *          Filter setup part 2:  Validate dates

     C                   MOVE      *BLANKS       CRIMSG
     C                   MOVE      'N'           FILT2F            1            No Error

     C                   Z-ADD     0             INTEST            3 0
     C     INI8BM        IFEQ      'MM'
     C                   ADD       4             INTEST
     C                   END
     C     INI8BD        IFEQ      'DD'
     C                   ADD       2             INTEST
     C                   END
     C     INI8BY        IFEQ      'YYYY'
     C                   ADD       1             INTEST
     C                   END
     C     INTEST        IFGT      0
     C     INTEST        ANDLT     7
     C     'The star'    CAT       'ting d':0    CRIMSG
     C                   CAT       'ate is':0    CRIMSG
     C                   CAT       'invali':1    CRIMSG
     C                   CAT       'd':0         CRIMSG
     C                   MOVE      'Y'           FILT2F
     C                   GOTO      FILT2E
     C                   END

     C                   Z-ADD     0             INTEST
     C     INI8EM        IFEQ      'MM'
     C                   ADD       4             INTEST
     C                   END
     C     INI8ED        IFEQ      'DD'
     C                   ADD       2             INTEST
     C                   END
     C     INI8EY        IFEQ      'YYYY'
     C                   ADD       1             INTEST
     C                   END
     C     INTEST        IFGT      0
     C     INTEST        ANDLT     7
     C     'The endi'    CAT       'ng dat':0    CRIMSG
     C                   CAT       'e is i':0    CRIMSG
     C                   CAT       'nvalid':0    CRIMSG
     C                   MOVE      'Y'           FILT2F
     C                   GOTO      FILT2E
     C                   END
     C     FILT2E        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODPSN        BEGSR
      *          SpyCsLnk returned best logical choice
      *          Reload Position to (NPOS)

     C                   Z-ADD     OVRL#         WFILE#
     C     WFILE#        IFNE      0
     C                   MOVE      WFILE#        LFILE#
     C                   END

     C     LFILE#        IFGT      0
     C                   MOVE      IN(LFILE#)    TMP9
     C                   ELSE
     C                   MOVE      IN(1)         TMP9
     C                   END
     C                   MOVEL     TMP9          NPOS
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PROCES        BEGSR
      *          Process View/Print/Fax/IFS/Delete

     C                   MOVE      ' '           APIONE            1
     C                   EXSR      FILT1                                        Fltr prompts
     C                   MOVEL     XVAL1         INDXI1
     C                   MOVEL     XVAL2         INDXI2
     C                   MOVEL     XVAL3         INDXI3
     C                   MOVEL     XVAL4         INDXI4
     C                   MOVEL     XVAL5         INDXI5
     C                   MOVEL     XVAL6         INDXI6
     C                   MOVEL     XVAL7         INDXI7
     C                   MOVEL(P)  XVAL1         DXIV1
     C                   MOVEL(P)  XVAL2         DXIV2
     C                   MOVEL(P)  XVAL3         DXIV3
     C                   MOVEL(P)  XVAL4         DXIV4
     C                   MOVEL(P)  XVAL5         DXIV5
     C                   MOVEL(P)  XVAL6         DXIV6
     C                   MOVEL(P)  XVAL7         DXIV7
     C                   MOVEL(P)  XVAL8         DXIV8

     C     XVAL8         IFNE      *BLANKS
     C                   MOVEL     XVAL8         INDX8S
     C                   ELSE
     C                   MOVEL     'YYYYMMDD'    INDX8S
     C                   ENDIF

     C     XVAL9         IFNE      *BLANKS
     C                   MOVEL     XVAL9         INDX8E
     C                   ELSE
     C                   MOVEL     'YYYYMMDD'    INDX8E
     C                   ENDIF

      * Set Text (SELTXT) = "Filter on", "Query on" or blanks
     C                   EXSR      SETTXT

     C     BATCH         IFNE      'Y'
     C                   EXSR      CLRSFL
     C                   END

     C                   Z-ADD     0             OVRL#
     C                   MOVEL(P)  'WRKSPID'     @HNDL                          Window Handl

     C     OPCDE         CABEQ     '*SELECT'     ENDAPI

      * SpyApiCmd, *VIEW, DupHits=*ALL:  Display all rpts or imgs.

     C     WQPRM         IFGE      74                                           SpyApiCmd
     C     OPCDE         ANDEQ     '*VIEW'
     C     PRTALL        ANDEQ     'Y'                                          Dups=*All
     C                   EXSR      @SELCR                                       Get 1st 10
     C     LNKRTN        IFEQ      '20'                                          NRF
/3331C     #HITS         ANDEQ     0
     C                   MOVE(P)   '3'           RTNCDE
     C                   EXSR      RETURN
     C                   END

     C                   DO        *HIVAL
     C                   EXSR      @FILN                                        Fill SFDATA

     C                   DO        10            XX                             View 1 to 10
     C     XX            OCCUR     SFDATA
     C     XX            OCCUR     LXDATA
     C     LDXNAM        IFEQ      *BLANK                                       No more
     C                   EXSR      RETURN
     C                   ENDIF
     C                   EXSR      VIEWER                                       View
/2256
/    C     RTMSGI        IFEQ      'EXIT'
/    C                   LEAVE
/2256C                   END
     C                   ENDDO

/2256C     RTMSGI        IFEQ      'EXIT'
/    C                   MOVE      *BLANKS       RTMSGI
/    C                   LEAVE
/    C                   END
/2256
     C                   EXSR      @REDGT                                       Next 10
     C     LNKRTN        IFEQ      '20'                                         No more
/3331C     #HITS         ANDEQ     0
     C                   EXSR      RETURN
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF

     C                   EXSR      @SELCR                                       Get 1st 10
     C                   EXSR      LODPSN

     C     LNKRTN        IFEQ      '20'                                         NRF
/3331C     #HITS         ANDEQ     0
     C                   MOVE(P)   '3'           RTNCDE
     C                   EXSR      RETURN
     C                   END
      *       ------------------------------------
      *       Process the selected Spylnk hit list
      *       ------------------------------------
     C                   EXSR      @FILN                                        Fill SFDATA
     C                   MOVE      *BLANKS       RTNCDE                            & LXDATA
      * Is there a 2nd hit on the filter?
     C     2             OCCUR     LXDATA

      * Set APIONE='Y' if we are interested in only one match.
      *   If we found only one hit and SysDft SNGHIT "rtn only 1' is No
      *      or found >1, but user requested no dups.

     C     LDXNAM        IFEQ      *BLANK                                       Only one hit
     C     SNGHIT        ANDNE     'Y'                                           No show sng
     C     LDXNAM        ORNE      *BLANK                                       More than 1
     C     DUPS          ANDNE     'Y'                                           No dups
     C                   MOVE      'Y'           APIONE
     C                   ENDIF

     C     APIONE        IFEQ      'Y'                                          Use only 1st
     C     1             OCCUR     SFDATA
     C     1             OCCUR     LXDATA
     C                   MOVEL     LXSEC         READ
     C                   SUBST     LXSEC:2       DEL
     C                   SUBST     LXSEC:3       PRNT
     C                   MOVEL     LDXNAM        LDXNM1

      *____________________SELECT by SELIO_____________________________
     C                   SELECT
      * View
     C     SELIO         WHENEQ    1
     C     READ          IFNE      'Y'                                          Not auth.
     C                   MOVE      '9'           RTNCDE
     C                   EXSR      RETURN
     C                   END

     C                   EXSR      VIEWER
      * Print/fax/ifs
     C     SELIO         WHENEQ    2
     C     SELIO         OREQ      13
     C     PRNT          IFNE      'Y'                                          Not auth
     C                   MOVE      '9'           RTNCDE
     C                   EXSR      RETURN
     C                   END

     C                   EXSR      @CPRIN                                        OK
      * Actfil att
     C     SELIO         WHENEQ    3
     C                   CLEAR                   UPDOPT
     C                   EXSR      ATTACT
      * Update
     C     SELIO         WHENEQ    8
     C                   CLEAR                   UPDOPT
     C                   EXSR      UPDAT
     C                   ENDSL
     C                   EXSR      RETURN
     C                   END
      * View
     C     SELIO         IFEQ      1

     C     APIONE        IFEQ      'Y'                                          Only
     C     READ          IFNE      'Y'                                          1 found
     C                   MOVE      '9'           RTNCDE
     C                   EXSR      RETURN
     C                   END

     C                   EXSR      VIEWER
     C                   EXSR      RETURN
     C                   ENDIF

     C                   Z-ADD     0             SELIO                          More than 1
     C                   GOTO      ENDAPI
     C                   ENDIF
      * Print/fax/delete
     C     SELIO         IFEQ      2
     C     SELIO         OREQ      13
J2096C     selio         oreq      4

      *   For every match...
     C                   DO        *HIVAL
      *       ExSr @CPrin up to 10 times for non-blank occurs of LXDATA.
      *       Exit WRKSPI on blank occurence.
     C                   DO        10            XX
     C     XX            OCCUR     SFDATA
     C     XX            OCCUR     LXDATA
     C     LDXNAM        IFEQ      *BLANK
J2096 /free
J2096  if selio = 4;
J2096    deleteObject('*DONE');
J2096  endif;
J2096 /end-free
     C                   EXSR      RETURN
     C                   ENDIF

J2096c                   if        selio = 2 or selio = 13
     C                   SUBST     LXSEC:3       PRNT
     C     PRNT          IFNE      'Y'
     C                   ITER
     C                   END
      *   Print it
     C                   MOVEL     LDXNAM        LDXNM1
     C                   EXSR      @CPRIN
J2096C                   endif

J2096 /free
J2096  if selio = 4; // Delete by way of SPY/DOCAPICMD
J2096    deleteObject(ldxnam:lxspg$);
J2096  endif;
J2096 /end-free

     C                   ENDDO

      *    Printed 10; get 10 more.
     C                   EXSR      @REDGT
     C     LNKRTN        IFEQ      '20'
/3331C     #HITS         ANDEQ     0
J2096 /free
J2096  if selio = 4;
J2096    deleteObject('*DONE');
J2096  endif;
J2096 /end-free
     C                   EXSR      RETURN
     C                   END
     C                   EXSR      @FILN                                        Fill SFDATA
     C                   ENDDO                                                       LXDATA
     C                   END

     C                   MOVE      *BLANKS       RTNCDE
     C                   EXSR      RETURN

     C     ENDAPI        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSBCH        BEGSR
      *          Program was called from an API
      *              Process Close Batch Option
     C                   EXSR      @CPRIN
     C                   MOVE      *BLANKS       RTNCDE
     C                   EXSR      RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPYLNK        BEGSR
      *          Call SpyCsLnk: SpyLink Db Server

      * If query, unlock keybord.
      * Fix key field (gets overwritten by write unlock)
     C     FNQ(1)        IFNE      *BLANKS
     C     DOLOCK        ANDEQ     '1'
     C                   WRITE     UNLOCK
     C                   CLEAR                   KEY
     C                   ENDIF

     C     PHYFIL        IFEQ      *BLANKS
     C     LOFILI        ANDNE     *BLANKS
     C                   MOVE      LOFILI        PHYFI2
     C                   ELSE
     C                   MOVE      PHYFIL        PHYFI2
     C                   ENDIF

/5921c                   if        not *in95 and dstlnk = 'Y'
/    c                   eval      shsfil = *allx'00'
/    c                   endif

      * Call SpyCsLnk
     C                   CALL      'SPYCSLNK'    PLSPY
     C     PLSPY         PLIST                                                  @00...1-8
     C                   PARM                    PHYFI2           10            Lnk lgcl fil
     C                   PARM                    @HNDL            10            Window Handl
     C                   PARM                    SPYLIB           10            @0000 Libr
     C                   PARM                    IKYLNK           50            RLnkdef key
     C                   PARM                    OPCODE            5            Opcode
     C                   PARM                    SEC               3            Security
     C                   PARM                    IFILTR                         Input filter
     C                   PARM                    SDT                            Return data
     C                   PARM      *BLANKS       LNKRTN            2            Return code
     C                   PARM      *BLANKS       ERTNID            7            Retrn ID
     C                   PARM      *BLANKS       ERTNDT          100            Retrn DATA
     C                   PARM                    SETLR             1            Shutdown N/Y
     C                   PARM                    LOOPID
     C                   PARM                    LODRV
     C                   PARM                    LOVOL
     C                   PARM                    LODIR
     C                   PARM                    LOFILI           10            Opt @00...xx
     C                   PARM                    OVRL#             1 0          Opened logcl
/6503C                   PARM      maxHits       #HITS             2 0          # hits
     C                   PARM                    AOQ                            AND/OR
     C                   PARM                    FNQ                            FIELDS
     C                   PARM                    TEQ                            TEST
     C                   PARM                    VAQ                            VALUES
     C                   PARM                    QRYTYP            1            QRYTYP
     C                   PARM                    SHSFIL                         Dst seg file

/5921c                   if        not *in95 and dstlnk = 'Y'
/    c                   eval      shsfil = ' '
/    c                   endif

J4602 /free
/                        Select;
/                          When LnkRtn = LNKRTN_30;
/                            MsgId = ERR1813; // Error reading Link db see joblog
/                            ExSr SndMsg;
/                          When LnkRtn = LNKRTN_40;
/                            MsgID = ERR000A; // Unqualified search invalid
/                            ExSr SndMsg;     // with DocLink Security;
/                        EndSl;
/     /end-free
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @SELCR        BEGSR
      *          Get the 1st 10 records for the filter criteria
     C                   MOVE      'F'           DIRECT                         Fwd directn
     C                   EXSR      @INZFL
     C                   MOVE      'SELCR'       OPCODE
     C                   EXSR      SPYLNK                                       CallSpyCsLnk
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @INZFL        BEGSR
      *          Init IFILTR fields

     C                   MOVE      *BLANKS       IFILTR
     C                   MOVEL     INDXI1        LLIV1
     C                   MOVEL     INDXI2        LLIV2
     C                   MOVEL     INDXI3        LLIV3
     C                   MOVEL     INDXI4        LLIV4
     C                   MOVEL     INDXI5        LLIV5
     C                   MOVEL     INDXI6        LLIV6
     C                   MOVEL     INDXI7        LLIV7
     C                   MOVE      *BLANKS       LLIV8
     C                   MOVEL     *BLANKS       LLIV9
     C     INI8BY        IFNE      'YYYY'
     C                   MOVEL     INDX8S        LLIV8
     C                   END
     C     INI8EY        IFNE      'YYYY'
     C                   MOVEL     INDX8E        LLIV9
     C                   END
     C                   MOVEL     *BLANKS       LLNAM
     C                   Z-ADD     0             LLSEQ
/2929
/2929C                   CLEAR                   BKEY
/2929
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/6604C     @clrwh        begsr
/     *          Clear previous handle

/     *  Physical file sent from subfile may not match record in RLNKDEF if link was
/     *  moved offline and subfile screen was not refreshed.  This hold original info
/     *  until user reloads online screen or returns from list of doc classes

/    c                   move      'CLEAR'       opcode
/    c                   z-add     0             ovrl#
/    c                   exsr      spylnk                                       CallSpyCsLnk

/    c                   movel     lnkfil        phyfil
/    c                   movel     lnkfil        phymbr
/    c                   movel     phymbr        mtyp
/6604c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @SETLL        BEGSR
      *          Position the input at the start
      *          of the input filter criteria
     C                   MOVE      'SETLL'       OPCODE
     C                   Z-ADD     0             OVRL#
     C                   EXSR      SPYLNK                                       CallSpyCsLnk
     C                   ENDSR
/8627 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/8627C     @SETBG        BEGSR
/8627 *          Position the input at the beginning of the filter
/8627
/8627C                   MOVE      'SETBG'       OPCODE
/8627C                   Z-ADD     0             OVRL#
/8627C                   EXSR      SPYLNK                                       CallSpyCsLnk
/8627C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @SETEN        BEGSR
      *          Position the input at the end of the filter

     C                   MOVE      'SETEN'       OPCODE
     C                   Z-ADD     0             OVRL#
     C                   EXSR      SPYLNK                                       CallSpyCsLnk
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @REDGT        BEGSR
      *          Get the next 10 records
     C                   MOVE      'RDGT '       OPCODE
     C                   Z-ADD     0             OVRL#
     C                   EXSR      SPYLNK                                       CallSpyCsLnk
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @REDLT        BEGSR
      *          Get the previuos 10 records
     C                   MOVE      'RDLT '       OPCODE
     C                   Z-ADD     0             OVRL#
     C                   EXSR      SPYLNK                                       CallSpyCsLnk
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @FILN         BEGSR
      *          Fill the Subfile 10 occurence data structures
      *          (SFDATA, LXDATA) with SDT data from SpyCsLnk

     C                   DO        10            OCC               3 0
     C     OCC           OCCUR     SFDATA
     C     OCC           OCCUR     LXDATA
     C     OCC           OCCUR     SDT
     C                   MOVEL(P)  SDTRV1        LXIV1
     C                   MOVEL(P)  SDTRV2        LXIV2
     C                   MOVEL(P)  SDTRV3        LXIV3
     C                   MOVEL(P)  SDTRV4        LXIV4
     C                   MOVEL(P)  SDTRV5        LXIV5
     C                   MOVEL(P)  SDTRV6        LXIV6
     C                   MOVEL(P)  SDTRV7        LXIV7
     C                   MOVEL(P)  SDTRV8        LXIV8
     C                   MOVEL(P)  SDTNAM        LDXNAM
     C                   MOVEL     SDTSEQ        LXSEQ$
     C                   MOVEL     SDTSPG        LXSPG$
     C                   MOVEL     SDTEPG        LXEPG$
     C                   MOVEL     SDTSEC        LXSEC
     C                   MOVEL     SDTTYP        LXTYP
     C                   MOVEL     SDTFIL        LXFIL
     C                   MOVEL     SDTEXT        LXEXT
     C                   MOVEL     SDTLIB        LXLIB
     C                   MOVEL     SDTBI5        LXBI5
     C                   MOVEL     SDTLOC        LXLOC
     C                   MOVEL     SDTNOT        LXNOT
     C                   MOVE      SDTRO#        LXRO#                          R/DARS OFFSE
     C                   MOVE      SDTRF#        LXRF#                          R/DARS FILE#
     C                   Z-ADD     1             X                 3 0
     C                   Z-ADD     1             Y                 5 0          Fill array
     C                   MOVEA     LXIV1         D(1)                           "D" (498x1),
      *                                                    one line of
     C                   Z-ADD     DP(2)         Y                              the display
     C     Y             IFGT      0                                            subfile.
     C                   MOVEA     LXIV2         D(Y)
     C                   END

     C                   Z-ADD     DP(3)         Y
     C     Y             IFGT      0
     C                   MOVEA     LXIV3         D(Y)
     C                   END

     C                   Z-ADD     DP(4)         Y
     C     Y             IFGT      0
     C                   MOVEA     LXIV4         D(Y)
     C                   END

     C                   Z-ADD     DP(5)         Y
     C     Y             IFGT      0
     C                   MOVEA     LXIV5         D(Y)
     C                   END

     C                   Z-ADD     DP(6)         Y
     C     Y             IFGT      0
     C                   MOVEA     LXIV6         D(Y)
     C                   END

     C                   Z-ADD     DP(7)         Y
     C     Y             IFGT      0
     C                   MOVEA     LXIV7         D(Y)
     C                   END

     C                   Z-ADD     DP(8)         Y
     C     Y             IFGT      0
     C                   MOVEL     'FILE'        FRMFMT            4
     C                   MOVEL     LXIV8         WYY                            Save 19XX Da
     C                   MOVE      LXIV8         WRK60                          19940601
     C                   EXSR      @CVTD                                          940601
     C     DATFMT        IFEQ      'YMD'
     C                   MOVE      DATSEP        SLASH3                         Convert date
     C                   MOVE      DATSEP        SLASH4
     C                   MOVE      WYY           WYY3
     C                   MOVE      SRK602        WMM3
     C                   MOVE      SRK603        WDD3
     C                   MOVEA     WRKDT3        D(Y)
     C                   ELSE
     C                   MOVE      SRK601        WMM                            eg:06
     C                   MOVE      SRK602        WDD                              01
     C                   MOVE      SRK603        WYY                              1994
     C                   MOVEA     WRKDT         D(Y)                             06/01/1994
     C                   END                                                      Y:14
     C                   END

     C                   Z-ADD     DP(9)         Y                              TYPE
     C     Y             IFGT      0
     C                   MOVEA     SDTPCT        D(Y)
     C                   ENDIF

     C                   Z-ADD     DP(10)        Y                              Status
     C     Y             IFGT      0
     C                   SELECT
     C     SDTLOC        WHENEQ    '1'
     C                   MOVEA     'Offline'     D(Y)
     C     SDTLOC        WHENEQ    '2'
     C                   MOVEA     'Optical'     D(Y)
     C                   OTHER
     C                   MOVEA     'Online'      D(Y)
     C                   ENDSL
     C                   END

     C                   Z-ADD     DP(11)        Y                              Notes
     C     Y             IFGT      0
     C                   SELECT
     C     SDTNOT        WHENEQ    '1'
     C                   MOVEA     NOTTXT        D(Y)                           "Text"
     C     SDTNOT        WHENEQ    '2'
     C                   MOVEA     ANNTXT        D(Y)                           "Annot"
     C     SDTNOT        WHENEQ    '3'
     C                   MOVEA     BTHTXT        D(Y)                           "An +Txt"
     C                   OTHER
     C                   MOVEA     '     '       D(Y)
     C                   ENDSL
     C                   END

     C     SCR           SUB       1             Y                              Determine
     C     Y             IFLE      0                                            where to get
     C                   Z-ADD     1             Y                              data for the
     C                   ELSE                                                   load of scrn
     C                   MULT      70            Y                              DspLn
     C                   ADD       1             Y
     C                   END
     C                   MOVEA     D(Y)          DSPLN

     C                   MOVEA     D(1)          DATA1
     C                   MOVEA     D(257)        DATA2
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CHGSF        BEGSR
      *          Change subfile view

     C     SCR           SUB       1             Y
     C     Y             IFLE      0
     C                   Z-ADD     1             Y
     C                   ELSE
     C     70            MULT      Y             Y
     C                   ADD       1             Y
     C                   END

      * Reread the subfile.  Update to start at proper display column
     C                   Z-ADD     CRRN1S        XXX               9 0
     C                   DO        XXX           #                 9 0
     C     #             CHAIN     SUBFL1                             22
     C   22              LEAVE
     C                   MOVEA     DATA1         D(1)
     C                   MOVEA     DATA2         D(257)
     C                   MOVEA     D(Y)          DSPLN
     C     SELIO         COMP      0                                  0808       NE
     C                   UPDATE    SUBFL1                                       So READC
     C                   MOVE      *OFF          *IN08                          will work
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRSFL        BEGSR
      *          Clear the subfile and RRNs
     C                   MOVE      KEY           SAVKEY            1
     C                   MOVE      *ON           *IN40
     C                   WRITE     SFLCTL1
     C                   MOVE      *OFF          *IN40
     C                   MOVE      SAVKEY        KEY
     C                   Z-ADD     0             CRRN1
     C                   Z-ADD     0             CRRN1S
     C                   Z-ADD     1             GETCSR
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @LOAD         BEGSR
      *          Load 10 records from the SFDATA & LXDATA
      *               10 occurrence data structures into the subfile

     C                   EXSR      @FILN
     C                   MOVE      *OFF          *IN99                          more recs

     C     DIRECT        IFEQ      'F'                                          Fwd directin
     C                   Z-ADD     CRRN1S        CRRN1
     C                   ELSE
     C                   EXSR      CLRSFL
     C                   END

     C                   DO        10            XX                2 0          Load 10
     C     XX            OCCUR     SFDATA
     C     XX            OCCUR     LXDATA

      *   If a specific sequence number is requested, then
      *   Check the data structure for that sequence number,
      *   continue to the next occurrence if that sequence
      *   is not correct.
5230 C                   If        intSeqNbr > NONE

5230 C                   If        strSeqNbr <> LXSEQ$
5230 C                   Iter
     c                   Else
     c                   Eval      intSeqCnt = intSeqCnt + 1
5230 C                   EndIf

5230 c                   EndIf

     C     LDXNAM        IFEQ      *BLANKS
     C                   MOVE      *ON           *IN99                          No more
     C                   LEAVE
     C                   END
/3457C                   Z-ADD     0             SELIO
     C                   MOVEL(P)  LXIV1         DXIV1
     C                   MOVEL(P)  LXIV2         DXIV2
     C                   MOVEL(P)  LXIV3         DXIV3
     C                   MOVEL(P)  LXIV4         DXIV4
     C                   MOVEL(P)  LXIV5         DXIV5
     C                   MOVEL(P)  LXIV6         DXIV6
     C                   MOVEL(P)  LXIV7         DXIV7
     C                   MOVEL(P)  LXIV8         DXIV8

/5635c                   clear                   LogDS
/    c                   eval      LogOpCode = #AUVEWLNK
/    c                   eval      LogUserID = wqusrn
/    c                   move      lxseq$        LogLnkSeq
/    c                   eval      LogObjID = ldxnam
/    c                   move      lxspg$        LogImgSeq
/    c                   for       x = 1 to %elem(lxivA)
     c                   if        in(x) = ' '
     c                   leave
     c                   endif
/    c                   callp     AddLogDtl(%addr(LogDS):#DTLINK:%addr(in(x)):
/    c                             %len(%trimr(in(x))):%addr(lxivA(x)):
/    c                             %len(%trimr(lxivA(x))))
/    c                   endfor
/    c                   callp     LogEntry(%addr(LogDS))

/3723 * If F18 processing, mark new record with selected option and
/3723 * SFLNXTCHG.
/3723C                   MOVE      '0'           *IN08
/3723
/3723C     F18FLG        IFEQ      'Y'
/3723C                   MOVE      LSTSEL        SELIO
/3723C                   MOVE      '1'           *IN08
/3723
/3723C     LSTSEL        IFEQ      4
/3723C                   ADD       1             F18CTR
/3723C                   ENDIF
/3723
/3723C                   ENDIF
/3723
     C                   ADD       1             CRRN1
/3723C                   ADD       1             USRIDX                         Track usridx entries
     C                   Z-ADD     CRRN1         SFLRRN
     C                   WRITE     SUBFL1

     C     XX            IFEQ      1
     C                   Z-ADD     CRRN1         RCDNBR                         Pos cursor
     C                   END

     C     CRRN1         IFEQ      1
     C                   MOVE      LXDATA        TKEY                           Save 1st
     C                   END

     C                   MOVE      LXDATA        BKEY                           Save last
/3723
/3723 * Check for maximum subfile records.
/3723C     CRRN1         IFEQ      MAXRRN
/3723C                   MOVE      *ON           *IN99                          No more
/3723C                   MOVE      ERR(14)       MSGID                          Max records
/3723C                   EXSR      SNDMSG
/3723C                   LEAVE
/3723C                   ENDIF
/3723
     C                   ENDDO

      *           Set on end of subfile indicator

5230 c                   If        intSeqCnt > *zero and
5230 c                             intSeqCnt < 10
5230  *              Simulate the end of the hit list
     c                   Eval      xx = intSeqCnt + 1
5230 c                   Eval      *in99 = *on
5230 c                   Eval      lnkRtn = '20'
5230 c                   Eval      #hits  = *zero
5230 c                   Eval      Query  = '1'

5230 c                   If        RcdNbr = *zero
5230 c                   Eval      RcdNbr = 1
5230 c                   EndIf

5230 c                   EndIf

     C     LNKRTN        IFEQ      '20'                                         WAS CANCEL O
/3331C     #HITS         ANDEQ     0
     C     QUERY         ANDEQ     '1'
     C                   MOVE      *ON           *IN99                          bottom...
     C                   ELSE
/3723
/3723C     CRRN1         IFNE      MAXRRN
/3723C                   ENDIF
/3723
     C                   ENDIF

     C     XX            SUB       1             #SFLPG            2 0          Recs on scn
     C                   Z-ADD     CRRN1         CRRN1S

     C     CRRN1         IFGT      TOPRRN
     C                   Z-ADD     CRRN1         TOPRRN
     C                   ENDIF

/6503c                   clear                   sdt

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @MORE         BEGSR
      *          Check for 10 more records

     C                   SELECT
     C     DIRECT        WHENEQ    'F'
     C                   MOVEL(P)  LBIV1         LLIV1
     C                   MOVEL(P)  LBIV2         LLIV2
     C                   MOVEL(P)  LBIV3         LLIV3
     C                   MOVEL(P)  LBIV4         LLIV4
     C                   MOVEL(P)  LBIV5         LLIV5
     C                   MOVEL(P)  LBIV6         LLIV6
     C                   MOVEL(P)  LBIV7         LLIV7
     C                   MOVEL(P)  LBIV8         LLIV8
     C                   MOVEL     LBNAM         LLNAM
     C                   MOVEL     LBSEQ         LLSEQ
     C                   MOVE      LLIV8         LLIV9
     C                   CLEAR                   LLIV9
     C                   EXSR      @REDGT                                       Get nxt 10
     C     LNKRTN        IFEQ      '20'
/3331C     #HITS         ANDEQ     0
     C                   MOVE      *ON           *IN99
     C                   ELSE
     C                   EXSR      @LOAD

     C                   ENDIF

     C     DIRECT        WHENEQ    'B'
     C                   MOVEL(P)  LTIV1         LLIV1
     C                   MOVEL(P)  LTIV2         LLIV2
     C                   MOVEL(P)  LTIV3         LLIV3
     C                   MOVEL(P)  LTIV4         LLIV4
     C                   MOVEL(P)  LTIV5         LLIV5
     C                   MOVEL(P)  LTIV6         LLIV6
     C                   MOVEL(P)  LTIV7         LLIV7
     C                   MOVEL(P)  LTIV8         LLIV8
     C                   MOVEL     LTNAM         LLNAM
     C                   MOVEL     LTSEQ         LLSEQ
     C                   MOVE      LLIV8         LLIV9
     C                   EXSR      @SETLL
     C                   CLEAR                   LLIV9
     C                   EXSR      @REDLT                                       Get prv 10
      *  IF NO HITS WERE FOUND, THE CURRENT SUBFILE IS THE TOP
     C     #HITS         IFGT      0
     C     LNKRTN        IFEQ      '20'                                         EOF
/6503C     #HITS         ANDlt     maxHits
     C                   EXSR      @GOTOP
     C                   ELSE
     C                   EXSR      @LOAD
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '1'           LCKPRV            1            LOCK PREV
     C                   ENDIF
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @GOTOP        BEGSR
      *          F9=Load the first page of subfile recs
     C                   MOVE      *BLANK        DIRECT
     C                   EXSR      @INZFL
/8627C                   EXSR      @SETBG
     C                   EXSR      @REDGT
     C     LNKRTN        IFEQ      *BLANKS                                      No recs
/3331C     LNKRTN        OREQ      '00'
     C                   EXSR      @LOAD
     C                   ENDIF
     C                   MOVE      '1'           LCKPRV            1            LOCK PREV
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @GOBOT        BEGSR
      *          F10=Load the last page of subfile recs

     C                   MOVE      *BLANK        DIRECT
     C                   EXSR      @INZFL
     C                   EXSR      @SETEN
     C                   EXSR      @REDLT
     C     LNKRTN        IFEQ      '20'                                         No recs
/3331C     #HITS         ANDEQ     0
     C                   EXSR      @SETLL
     C                   EXSR      @REDGT
     C                   ENDIF

     C     LNKRTN        IFEQ      *BLANKS
/3331C     LNKRTN        OREQ      '00'
     C                   EXSR      @LOAD
     C                   ENDIF

     C                   MOVE      *ON           *IN99
     C                   CLEAR                   LCKPRV

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CLROP        BEGSR
      *          Clear SELIO
     C                   MOVE      *OFF          *IN08                          SflNxtChg
     C                   Z-ADD     0             SELIO
     C                   UPDATE    SUBFL1
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRW          BEGSR
      *          Clear windows from previous calls

     C     CLOSEW        IFEQ      'Y'
     C                   SELECT
     C     LCALL         WHENEQ    '@CPRI'
     C                   MOVEL(P)  'CLOSEW'      PRTRTN
     C                   EXSR      MAG210
     C                   CLEAR                   ACT210
     C     LCALL         WHENEQ    '@NOTE'
     C                   MOVEL(P)  'CLOSEW'      NOTRTN
     C                   CALL      'MAG2032'     PL2032                 50
     C                   CLEAR                   UN2032
     C     LCALL         WHENEQ    '@FIND'
     C                   EXSR      CLSFND
     C     LCALL         WHENEQ    '@CVEW'
     C                   MOVEL(P)  'CLOSEW'      RTNCDE
     C                   EXSR      @CVEW
     C                   MOVE      *BLANKS       RTNCDE
     C                   ENDSL
     C                   MOVE      *BLANKS       CLOSEW
     C                   ENDIF

     C     MOVOPN        IFEQ      '1'
     C                   MOVEL(P)  'CLOSE'       MOVOPT           10
     C                   CALL      'SPYMOV'      PLMOV                  50
     C                   CLEAR                   MOVOPN
     C                   MOVE      *BLANKS       MOVOPT
     C                   ENDIF

     C     TRKOPN        IFEQ      '1'
     C                   MOVEL(P)  'CLOSE'       WVRTN
     C                   EXSR      @TRACK
     C                   CLEAR                   TRKOPN
     C                   CLEAR                   WVRTN
     C                   ENDIF

     C     ACT210        IFEQ      'Y'
     C                   MOVEL(P)  'CLOSEW'      PRTRTN
     C                   EXSR      MAG210
     C                   ENDIF

     C     UN2032        IFEQ      'Y'
     C                   MOVEL(P)  'CLOSEW'      NOTRTN
     C                   CALL      'MAG2032'     PL2032                 50
     C                   ENDIF
     C     UNFIND        IFEQ      'Y'
     C                   EXSR      CLSFND
     C                   ENDIF

     C     ACTHDR        IFEQ      '1'
     C                   CALL      'GETHDR'                             50
     C                   PARM                    LOOPID           10            OptId
     C                   PARM                    LODRV            15            Opt Drive
     C                   PARM                    LOVOL            12            Volume
     C                   PARM                    LODIR            80            Sub dir
     C                   PARM                    LOFILI                         File name
     C                   PARM                    DTA                            Rtn data
     C                   PARM      '1'           ECLSP             1            Close pgm      RETUR
     C                   PARM      *BLANKS       ERTNID            7            Retrn ID
     C                   PARM      *BLANKS       ERTNDT          100            Retrn DATA
     C                   ENDIF

     C     A8021         IFEQ      'Y'
     C                   MOVEL(P)  'QUIT'        SVRTN
     C                   EXSR      $STRCS
     C                   CLEAR                   A8021
     C                   ENDIF

     C     UPDOPN        IFEQ      '1'
     C                   MOVEL(P)  'CLOSE'       UPDOPT
     C                   EXSR      UPDAT
     C                   CLEAR                   UPDOPN
     C                   MOVE      *BLANKS       UPDOPT
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF17         BEGSR
      *          F17=Change sort order

     C                   MOVE      *BLANKS       ERRMSG
      *>>>>
     C     INF17         TAG
     C                   EXFMT     SORT
     C                   MOVE      *BLANKS       ERRMSG

     C                   Z-ADD     WFILE#        X
     C     LE(X)         IFEQ      0
     C                   MOVE      ERR(3)        @ERCON
     C                   EXSR      RTVERM
     C                   GOTO      INF17
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CHGV         BEGSR
      *          F11=Chg view.  Rotate around screens 1-8
      *          Seton one of 81-88 to match SCR value 1-8

     C                   MOVEA     '00000000'    *IN(81)
     C                   ADD       1             SCR
     C     SCR           IFGT      MAXSCR
     C                   Z-ADD     1             SCR
     C                   END

     C                   SELECT
     C     SCR           WHENEQ    1
     C                   MOVE      *ON           *IN81
     C     SCR           WHENEQ    2
     C                   MOVE      *ON           *IN82
     C     SCR           WHENEQ    3
     C                   MOVE      *ON           *IN83
     C     SCR           WHENEQ    4
     C                   MOVE      *ON           *IN84
     C     SCR           WHENEQ    5
     C                   MOVE      *ON           *IN85
     C     SCR           WHENEQ    6
     C                   MOVE      *ON           *IN86
     C     SCR           WHENEQ    7
     C                   MOVE      *ON           *IN87
     C     SCR           WHENEQ    8
     C                   MOVE      *ON           *IN88
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @NOTES        BEGSR
      *          18=W/w notes

     C                   MOVEL     LDXNAM        LDXNM1            1
     C     LDXNM1        IFEQ      'B'                                          SpyImage
     C     LDXNAM        CHAIN     MIMGDIR                            50
/813 C                   MOVE      LXSPG$        PAGE#
/    C                   Z-ADD     1             #FRSTP
/    C                   Z-ADD     *HIVAL        #LASTP
/    C                   Z-ADD     1             ACTPG#                         Actual Page#
     C                   MOVEL     IDFLD         @FLDR
     C                   MOVEL     IDFLIB        @FLDLB
     C                   MOVEL     IDDOCT        @FILNA
     C                   MOVEL     IDBNUM        @JOBNA
     C                   CLEAR                   @USRNA
     C                   CLEAR                   @JOBNU
     C                   CLEAR                   DSF#
/6708C                   CLEAR                   @datfo
     C                   ELSE                                                   Report
     C     LDXNAM        CHAIN     MRPTDIR7                           50
     C                   MOVEL     FLDR          @FLDR
     C                   MOVEL     FLDRLB        @FLDLB
     C                   MOVEL     FILNAM        @FILNA
     C                   MOVEL     JOBNAM        @JOBNA
     C                   MOVEL     USRNAM        @USRNA
     C                   MOVEL     JOBNUM        @JOBNU
/6708C                   MOVE      DATFOP        @datfo
/813 C     LXLOC         IFEQ      '4'                                          R/DARS Optical
/    C     LXLOC         OREQ      '5'                                          R/DARS QDLS
/    C     LXLOC         OREQ      '6'                                          IMAGEVIEW OPTICAL
/813 C                   MOVE      LXSPG$        PAGE#
/    C                   Z-ADD     1             #FRSTP
/    C                   Z-ADD     *HIVAL        #LASTP
/    C                   Z-ADD     1             ACTPG#                         Actual Page#
     C                   ELSE
/813 C                   MOVE      LXSPG$        PAGE#
/    C                   MOVE      LXSPG$        #FRSTP
/    C                   MOVE      LXEPG$        #LASTP
/    C                   Z-ADD     PAGE#         ACTPG#                         Actual Page#
     C                   END
     C                   Z-ADD     FILNUM        @FILNU
     C                   ENDIF

     C                   MOVE      '1'           WORKNT            1
     C                   CLEAR                   NOTRTN
     C                   CALL      'MAG2032'     PL2032                 50

     C     PL2032        PLIST
     C                   PARM                    WQUSRN           10
     C                   PARM      LDTALB        NOTLIB           10
     C                   PARM                    @FLDR            10
     C                   PARM                    @FLDLB           10
     C                   PARM                    @FILNA           10
     C                   PARM                    @JOBNA           10
     C                   PARM                    @USRNA           10
     C                   PARM                    @JOBNU            6
/6708C                   PARM                    @datfo            7            date spooled file op
     C                   PARM                    DSF#
     C                   PARM                    PAGE#             9 0
     C                   PARM                    WORKNT            1
     C                   PARM      *BLANKS       SEGFIL           10
     C                   PARM                    #FRSTP            9 0
     C                   PARM                    #LASTP            9 0
     C                   PARM                    BGREC             9 0
     C                   PARM      *BLANKS       REPIND           10
     C                   PARM                    NOTRTN            7
/813 C                   PARM                    ACTPG#            9 0          Actual Page#

     C                   MOVE      'Y'           UN2032            1
     C                   MOVEL     '@NOTES'      LCALL
     C                   MOVE      'Y'           CLOSEW

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @FIND         BEGSR
      *          25=Find

     C                   MOVEL     LDXNAM        LDXNM1            1
     C     LDXNM1        IFEQ      'B'                                          SpyImage
      *                    "Sorry, cannot search PC Files"
     C                   MOVEL     'ERR0164'     MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      ENDFND
     C                   END

     C     FIND          IFNE      '1'
     C                   MOVE      '1'           FIND              1
      * Disply Hdr
     C     FNDF14        IFNE      '1'
     C                   MOVEL(P)  'P00309E'     SCHMSG                         25=Find
     C                   ELSE
     C                   MOVEL(P)  'P00309D'     SCHMSG                         F14=Find all
     C                   ENDIF

     C                   CLEAR                   CURFND
     C                   CLEAR                   STPFND
     C                   CLEAR                   MAXFND
     C                   CLEAR                   FNDPAG
     C                   MOVEL(P)  'FILTER'      FNDOPC

     C                   CALL      'SPYFND'      PLFIND                 50
     C     PLFIND        PLIST
     C                   PARM                    SCHMSG            7
     C                   PARM                    REPIND                           SPY number
     C                   PARM                    NDXNAM           10              Rep index
     C                   PARM                    NDXFIL           10              Rep index
     C                   PARM                    COLFRM            5 0            Col from
     C                   PARM                    COLTO             5 0            Col to
     C                   PARM                    LINFRM            5 0            Line from
     C                   PARM                    LINTO             5 0            Line to
     C                   PARM                    CURFND            5 0            CURRENT
     C                   PARM                    FNDMAX            5 0            MAXIMUM
     C                   PARM                    MATCH             1              Exact Matc
     C                   PARM                    WLDCRD            1              Wild Card
     C                   PARM                    FNDOPT            1              Optical
     C                   PARM                    WR                               Words
     C                   PARM                    AO                               AND/OR
     C                   PARM                    TE                               LIKE/NLIKE
     C                   PARM                    FNDOPC           10              OPCODE
     C                   PARM                    FNDRTN            7              Rtn code

     C                   MOVE      '1'           FSTFND            1            1st run
     C                   ENDIF

     C                   MOVE      'Y'           UNFIND            1
     C                   MOVEL     '@FIND'       LCALL
     C                   MOVE      'Y'           CLOSEW
      * Cancel
     C     FNDRTN        CABEQ     F3            ENDFND
     C     FNDRTN        CABEQ     F12           ENDFND

      * Search successful, ask for continue
     C     FNDPAG        IFNE      0
     C                   MOVEL(P)  'CANCEL'      FNDOPC
     C                   CALL      'SPYFND'      PLFIND                 50
      * Cancel
     C     FNDRTN        CABEQ     F3            ENDFND
     C     FNDRTN        CABEQ     F12           ENDFND

     C                   MOVEL(P)  'CURRENT'     FNDOPC
     C                   CALL      'SPYFND'      PLFIND                 50
     C                   ELSE

      * Step of 5 searched pages found
     C     STPFND        IFGT      5
     C     FSTFND        OREQ      '1'                                          1st run
     C                   CLEAR                   STPFND
     C                   MOVEL(P)  'CURRENT'     FNDOPC
     C                   CALL      'SPYFND'      PLFIND                 50
     C                   ENDIF

      * Max search pages reached
     C     MAXFND        IFGE      FNDMAX
     C                   CLEAR                   MAXFND
     C                   MOVEL(P)  'MAX'         FNDOPC
     C                   CALL      'SPYFND'      PLFIND                 50
      * Cancel
     C     FNDRTN        CABEQ     F3            ENDFND
     C     FNDRTN        CABEQ     F12           ENDFND

     C                   MOVEL(P)  'CURRENT'     FNDOPC
     C                   CALL      'SPYFND'      PLFIND                 50
     C                   ENDIF
     C                   ENDIF

      * Search
     C                   MOVE      LXSPG$        PAGFRM
     C                   MOVE      LXEPG$        PAGTO
     C                   MOVEL(P)  *BLANKS       FNDOPC
     C                   CALL      'SPYCSFND'    PLSRCH                 50
     C     PLSRCH        PLIST
     C                   PARM                    FNDOPC           10              SPY000...
     C                   PARM      LDXNAM        REPIND           10              SPY000...
     C                   PARM                    PAGFRM            9 0            Page from
     C                   PARM                    PAGTO             9 0            Page to
     C                   PARM                    COLFRM            5 0            Col from
     C                   PARM                    COLTO             5 0            Col to
     C                   PARM                    LINFRM            5 0            Line from
     C                   PARM                    LINTO             5 0            Line to
     C                   PARM                    MATCH             1              Exact Matc
     C                   PARM                    WLDCRD            1              Wild Card
     C                   PARM                    FNDOPT            1              Optical
     C                   PARM                    WR                               Words
     C                   PARM                    AO                               AND/OR
     C                   PARM                    TE                               LIKE/NLIKE
      *       return parms
     C                   PARM                    FNDGRP            5              Page GRPS
     C                   PARM                    FNDPAG            9 0            Page fnd
     C                   PARM                    FNDCOL            5 0            Col  fnd
     C                   PARM                    FNDLIN            5 0            Line fnd
     C                   PARM                    FNDRTN            7              Rtn MSGID
     C                   PARM                    FNDDTA          100              Rtn Data

      * Bump page counters

     C     PAGTO         SUB       PAGFRM        F50               5 0
     C                   ADD       1             F50
     C                   ADD       F50           CURFND            5 0
     C                   ADD       F50           STPFND            5 0
     C                   ADD       F50           MAXFND            5 0
     C                   CLEAR                   FSTFND
      * Cancel
     C     FNDRTN        CABEQ     F3            ENDFND
     C     FNDRTN        CABEQ     F12           ENDFND

     C     FNDRTN        IFNE      *BLANKS                                      Error
     C                   MOVEL     FNDRTN        MSGID
     C                   MOVEL(P)  FNDDTA        MSGDTA
     C                   EXSR      SNDMSG

     C                   ELSE
     C     FNDPAG        IFNE      0                                            View REPORT
     C                   EXSR      VIEWER
     C                   END
     C                   END
     C     ENDFND        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CPRIN        BEGSR
      *          2,13=Print,Fax,Ifs  Image or Report

     C                   CLEAR                   PRS
      * Print
     C     SELIO         IFEQ      2                                            Print
     C     #PRT          IFGT      1
     C     NUJOIN        IFEQ      'Y'
     C                   MOVE      'Y'           @JOINS
     C                   ENDIF
     C                   MOVE      ' '           PRS(25)                        UnProt join
     C                   ELSE
     C                   MOVE      'N'           @JOINS
     C                   MOVE      '2'           PRS(25)                        Prot join
     C                   ENDIF
     C                   ENDIF
      * Fax
     C     SELIO         IFEQ      13                                           Fax
     C     #FAX          IFGE      2
     C     NUJOIN        IFEQ      'Y'
     C                   MOVE      'Y'           @JOINS
     C                   ENDIF
     C                   MOVE      ' '           PRS(25)
     C                   ELSE
     C                   MOVE      'N'           @JOINS
     C                   MOVE      '2'           PRS(25)
     C                   ENDIF
     C                   ENDIF
      * If called by api, use the parms that were passed in
     C     API           IFEQ      'P'                                          Print
     C     API           OREQ      'F'                                          Fax
     C     API           OREQ      'M'                                          Mail
     C     API           OREQ      'I'                                          IFS
     C                   EXSR      APIPRM
     C                   ENDIF

     C                   MOVE      LXSPG$        F90               9 0
     C                   Z-ADD     F90           @FRMPG
     C     LXEPG$        IFNE      *BLANKS
     C                   MOVE      LXEPG$        F90               9 0
     C     F90           IFEQ      0
     C                   MOVE      LXSPG$        F90               9 0
     C                   MOVE      '1'           PRS(1)                         PROT FRM PG
     C                   MOVE      ' '           PRS(2)                         INPUT TO PG
     C                   ELSE
     C                   MOVE      '1'           PRS(1)                         NOND FRM PG
     C                   MOVE      '1'           PRS(2)                         NOND TO PG
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     F90           @TOPG

     C                   SELECT
     C     SELIO         WHENEQ    2                                            Print
     C                   MOVE      'P'           OPCD                             (P)rt
     C     SELIO         WHENEQ    13                                           Send
     C     APIIND        IFEQ      ' '
     C                   MOVE      'S'           OPCD                           (S)end
     C                   ELSE
     C                   MOVE      API           OPCD                           (F)ax/(M)ail
     C                   END
     C                   ENDSL

     C     LDXNM1        IFNE      'B'
     C                   MOVE      'R'           OBJTY                          (R)pt
     C                   ELSE
     C                   MOVE      'I'           OBJTY                          (I)mg
     C                   ENDIF

      * LOAD SPYLINK DATA STRUCTURE  (SDT)
     C                   EXSR      @SDT
     C                   MOVEL     SDT           SDTPRM

     C                   EXSR      MAG210

     C                   MOVE      'N'           NUJOIN            1
     C                   MOVE      'Y'           ACT210            1
     C                   MOVEL     '@CPRI'       LCALL
     C                   MOVE      'Y'           CLOSEW

     C     API           IFEQ      'F'                                          API return
     C     API           OREQ      'P'
     C     API           OREQ      'M'
     C     API           OREQ      'I'
     C     APIONE        IFEQ      'Y'                                          ALWAYS
     C                   EXSR      RETURN                                       RETURN
     C                   END
     C     RTNCDE        IFNE      *BLANKS
     C                   EXSR      RETURN
     C                   ENDIF
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     APIPRM        BEGSR
      *          Print/fax/mail/ifs API: use parms.

     C                   MOVE      BCHOPT        PROMPT
     C                   MOVE      JOIN          @JOINS
     C                   MOVEL     WRINTR        @PTRID           10            Print Id
     C                   MOVEL     WOUTQ         @OUTQ            10            Outq
     C                   MOVEL     WOUTL         @OUTQL           10            Outq Libr
     C                   MOVEL     WBMJBQ        @SBMJB            1            Submit
     C                   MOVEL     WBDESC        @JBDES           10            Job Desc
     C                   MOVEL     WBDLIB        @JBDLB           10            Job-D Lib
      * View
     C     WQPRM         IFGE      48
     C                   MOVEL     ENVWND        @PRTWN            1            PrintWdw
     C                   MOVEL     ENVUSR        @ENVUS           10            Env User
     C                   MOVEL     ENVNAM        @ENVNA           10            Env Name
     C                   ENDIF
      * Fax
     C     API           IFEQ      'F'
     C                   MOVEL(P)  WFAX#         @FXNBR                         To phone nbr
     C                   MOVEL(P)  WFAXTO        @FXTO1                         To person
     C                   MOVEL(P)  EFXTL2        @FXTO2
     C                   MOVEL(P)  EFXTL3        @FXTO3
     C                   MOVEL(P)  WFAXFR        @FXFR1                         From
     C                   MOVEL(P)  EFXFL2        @FXFR2
     C                   MOVEL(P)  EFXFL3        @FXFR3
     C                   MOVEL(P)  WFAXRE        @FXREF                         Refer
     C                   MOVEL(P)  WFXTX1        @FXTX1                         Text 1
     C                   MOVEL(P)  WFXTX2        @FXTX2                              2
     C                   MOVEL(P)  WFXTX3        @FXTX3                              3
     C                   MOVEL(P)  WFMNAM        @FXFRM                         Formname
     C                   MOVEL(P)  WFXSTY        @FXSTY                         Style
     C                   MOVEL     WFXVC         @FXLPI                         LPI
     C                   MOVEL     WFXHC         @FXCPI                         CPI
     C                   MOVEL(P)  WSDPRT        @FXPTY                         Priority
     C                   MOVEL(P)  WFAXID        @FXSID                         Send Id
     C                   MOVEL(P)  WCNFRM        @FXMSG                         Message to
     C                   MOVEL(P)  ECOMNT        @FXTX5
     C                   MOVEL     ECVRPF        @FXCPF
     C                   MOVEL     ECVRPL        @FXCPL
      * Spcl Fax To/From
     C     OPCDE         IFEQ      '*IBMFAX'
     C     OPCDE         OREQ      '*DIRECT'
     C                   MOVEL(P)  EFXTL1        @FXTO1
     C                   MOVEL(P)  EFXFL1        @FXFR1
     C                   ENDIF
      * Re
     C     @FXREF        IFEQ      *BLANKS
     C                   MOVEL     ETITLE        @FXREF
     C                   ENDIF

     C                   ENDIF
      * Mail
     C     API           IFEQ      'M'
     C     API           OREQ      'I'
     C                   MOVEL     ESNDR         @SNDR            60            SENDER
     C                   MOVEL     EADTYP        @ADTYP            1            RCVR ADDRESS
     C                   MOVEL     ERCVR         @RCVR            60            RECEIVER
     C                   MOVEL     ESUBJ         @SUBJ            60            SUBJECT
     C                   MOVEL     EFMT          @FMT             10            FORMAT
     C                   MOVEA     ETXT          @TXT                           TEXT 5*65

     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MAG210        BEGSR
      *          Call Mag210: Print/Fax/Xmit server

     C     LXLOC         IFEQ      '4'                                          R/DARS OPTIC
     C     LXLOC         OREQ      '5'                                          R/DARS QDLS
     C     LXLOC         OREQ      '6'                                          IMAGEVIEW OP
     C                   MOVE      *ZEROS        @PGTBL
     C                   MOVEL     LXRF#         @PGTBL
     C                   MOVE      LXRO#         @PGTBL
     C                   ELSE
     C                   MOVEL     *BLANKS       @PGTBL                         SegFiNm|Key
     C                   END

      * Save index values in an external program for later use
     C                   CALL      'MAG210SV'                           50
     C                   PARM      'SAVVAL'      SVOPCD           10
     C                   PARM      DXIV1         SVIV1            99               VALUE 1
     C                   PARM      DXIV2         SVIV2            99               VALUE 2
     C                   PARM      DXIV3         SVIV3            99               VALUE 3
     C                   PARM      DXIV4         SVIV4            99               VALUE 4
     C                   PARM      DXIV5         SVIV5            99               VALUE 5
     C                   PARM      DXIV6         SVIV6            99               VALUE 6
     C                   PARM      DXIV7         SVIV7            99               VALUE 7
     C                   PARM      DXIV8         SVIV8             8               VALUE 8

     C     WQPRM         IFGE      61
     C                   MOVE      COPIES        @COPIE            3 0          #Copies
     C                   MOVE      CVRPAG        @CVRPA            7            CovrPgB4/Aft
     C                   MOVE      DUPLEX        @DUPLE            4            *YES/*NO
     C                   MOVE      ORIENT        @ORIEN           10            *LAND/*PORT
     C                   MOVE      PTRTYP        @PTRTY            6            *XI *PVL etc
     C                   MOVE      PTRNOD        @PTRNO           17            PCsrvrNodeID
     C                   MOVE      CPGMBR        @CPGMB           10            CoverPg Mbr
     C                   END
/2204 * If IFS, setup file name
/2204C     API           IFEQ      'I'
     C     PRTRTN        ANDNE     'CLOSEW'
     C                   MOVEA(P)  ETXT          @TXT
     C                   MOVE      'Y'           @JOINS                         No Joins
     C                   MOVE      'Y'           JOIN
     C                   EXSR      ADDSPC
/2204C                   END

/6692c                   If        OpCd  = 'M'     and
/    c                             ObjTy = 'I'     and
/    c                             Prompt =  ' '   and
/    c                             PrtRtn = 'CLOSEW'
/    c                   Eval      Prompt = 'C'
/    c                   EndIf

      //                 The call to MAG210 modifies some of the operational
      //                 values passed to it. So preserve the prior value of
      //                 PrtRtn

/    c                   If        PrtRtn = 'CLOSEW'
/    c                   Eval      blnCloseW = TRUE
/    c                   Else
/    c                   Eval      blnCloseW = FALSE
/    c                   EndIf

     C                   CALL      'MAG210'                             50
     C                   PARM                    OPCD              1            P)rt F)ax
     C                   PARM                    OBJTY             1            I)mg R)pt
     C                   PARM      LDXNAM        REPIDX           10            Rept Idx #
     C                   PARM                    PROMPT            1            Prompt Scrn
     C                   PARM                    PRS                            SecurityFlg
     C                   PARM                    PRTRTN            7            Return Code
     C                   PARM                    @FRMPG            7 0          7  Frm page
     C                   PARM                    @TOPG             7 0          8  To  page
     C                   PARM      0             @FRMCO            3 0          9  Frm col
     C                   PARM      0             @TOCOL            3 0          10 To  col
     C                   PARM                    @PRTWN            1            1 PrintWindo
     C                   PARM                    @ENVUS           10            2 EnviroUser
     C                   PARM                    @ENVNA           10            3 EnviroName
     C                   PARM                    @SBMJB            1            4 Submit
     C                   PARM                    @JBDES           10            5 Job Desc
     C                   PARM                    @JBDLB           10            6 Job-D Lib
     C                   PARM                    @RPTNA           10            7 Rpt Name
     C                   PARM                    @OUTFR           10            8 Out Form
     C                   PARM                    @RPTUD           10            9 User data
     C                   PARM                    @PTRID           10            20 Print Id
      * 21-30
     C                   PARM                    @OUTQ            10            Outq
     C                   PARM                    @OUTQL           10            Outq Lib
     C                   PARM                    @PRTF            10            PrintF
     C                   PARM                    @PRTLB           10            PrintF Lb
     C                   PARM                    @WTR             10            Writer
     C                   PARM                    @COPIE                         #Copies
     C                   PARM                    @DJEBF           10            Dje Befor
     C                   PARM                    @DJEAF           10            Dje After
     C                   PARM                    @BANNR           10            Banner Id
     C                   PARM                    @INSTR           10            Instru Id
      * 31-40
     C                   PARM                    @JOINS            1            Join Splf
     C                   PARM                    @PRTTY           10            PRINT TYPE
     C                   PARM                    @DBFIL           10            File Name
     C                   PARM                    @DBLIB           10            Library
     C                   PARM                    @DBNOT            1            Notes
      * 36-50
     C                   PARM                    @FXNBR           40            Fax Nbr
     C                   PARM                    @FXTO1           45             :  to 1
     C                   PARM                    @FXTO2           45             :     2
     C                   PARM                    @FXTO3           45             :     3
     C                   PARM                    @FXFR1           45             :  from 1
     C                   PARM                    @FXFR2           45             :       2
     C                   PARM                    @FXFR3           45             :       3
     C                   PARM                    @FXREF           45             :  Refer
     C                   PARM                    @FXTX1           52             :  Text 1
     C                   PARM                    @FXTX2           52             :       2
     C                   PARM                    @FXTX3           52             :       3
     C                   PARM                    @FXTX4           52             :       4
     C                   PARM                    @FXTX5           52             :       5
      * 49-58
     C                   PARM                    @FXCPF           10            Cover PRTF
     C                   PARM                    @FXCPL           10            Cover  LIB
     C                   PARM                    @FXFRM           10            Formname
     C                   PARM                    @FXSTY            4            Style
     C                   PARM                    @FXLPI            4            LPI
     C                   PARM                    @FXCPI            4            CPI
     C                   PARM                    @FXPTY            2            Priority
     C                   PARM                    @FXSID           50            Send Id
     C                   PARM                    @FXMSG           20            Message to
     C                   PARM                    @FXSAV            1            SAVE STS
      * 59-62
     C                   PARM                    @DEVFN           10            ORIG PRTF
     C                   PARM                    @DEVFL           10            ORIG PRTFLB
     C                   PARM                    @UPGTB            1            USE PAGETBL
     C                   PARM                    @PGTBL           20            USE PAGETBL
      * 63-69
     C                   PARM                    @CVRPA                         CovrPgB4/Aft
     C                   PARM                    CVRTXT                         CovrPg text
     C                   PARM                    @DUPLE                         *YES/*NO
     C                   PARM                    @ORIEN                         *LAND/*PORT
     C                   PARM                    @PTRTY                         *XI *PVL etc
     C                   PARM                    @PTRNO                         PCsrvrNodeID
     C                   PARM                    @CPGMB                         CoverPg Mbr
      * 70-74
     C                   PARM                    PAPSIZ                         PAPER SIZE
     C                   PARM                    DRAWER                         DRAWER
     C                   PARM                    PAGRNG                         Page Range
     C                   PARM                    BCHID                          Batch ID
     C                   PARM                    SDTPRM                         DATA
      * EMAIL 75-80
     C                   PARM                    @SNDR            60            EMAIL SENDER
     C                   PARM                    @ADTYP            1            RCVR ADDRESS
     C                   PARM                    @RCVR            60            RECEIVER
     C                   PARM                    @SUBJ            60            SUBJECT
     C                   PARM                    @TXT                           TEXT 5*65
     C                   PARM                    @FMT             10            FORMAT
/2930C                   PARM                    @CDPAG            5            CODE PAGE
/3393C                   PARM                    @IGBAT            1            IGNORE BADBATCH
/6609C                   PARM                    @INFAC            1            SpoolMail Interface

/6692c                   If        blnCloseW = TRUE
/    c                   Eval      OpCd   = 'S'
/    c                   Eval      Prompt = ' '
/    c                   Eval      PrtRtn = ' '
/    c                   EndIf

     C                   MOVE      PRTRTN        KEY
      * Error
     C     *IN50         IFEQ      *ON
     C     PRTRTN        ORNE      *BLANKS

     C                   SELECT
     C     *IN50         WHENEQ    *ON                                          MAG210 blew
     C                   MOVE      '1'           CNLOPT
     C                   MOVEL     'ERR1089'     MSGID
     C     KEY           WHENEQ    F3                                           F3=Exit or
     C     PRTRTN        OREQ      'ERR1385'                                    F12=Cancel
     C                   MOVE      '1'           CNLOPT
     C                   MOVE      'ERR1385'     MSGID
     C     PRTRTN        WHENEQ    'ERR1821'                                    Fax cmd
     C                   MOVE      'F'           ERR#                           failed.
     C                   OTHER
     C                   MOVEL     PRTRTN        MSGID
     C                   ENDSL

      * Reset index values in external program
     C                   CALL      'MAG210SV'                           50
     C                   PARM      'RESET '      SVOPCD           10
     C                   PARM      *BLANKS       SVIV1            99               value 1
     C                   PARM      *BLANKS       SVIV2            99               value 2
     C                   PARM      *BLANKS       SVIV3            99               value 3
     C                   PARM      *BLANKS       SVIV4            99               value 4
     C                   PARM      *BLANKS       SVIV5            99               value 5
     C                   PARM      *BLANKS       SVIV6            99               value 6
     C                   PARM      *BLANKS       SVIV7            99               value 7
     C                   PARM      *BLANKS       SVIV8             8               value 8
      *          Didn't do this one.
     C     SELIO         IFEQ      2
     C                   SUB       1             #PRT
     C                   ENDIF
     C     SELIO         IFEQ      13
     C                   SUB       1             #FAX
     C                   ENDIF
     C                   EXSR      SNDMSG
     C     API           IFEQ      'F'                                          API return
     C     API           OREQ      'P'
     C                   MOVE      ERR#          RTNCDE
     C                   END
      * No error
     C                   ELSE                                                   No error

     C     APIONE        IFEQ      'Y'                                          API only 1:
     C     API           IFEQ      'F'                                           Fax
     C     API           OREQ      'P'                                           Print
     C                   MOVE      *BLANKS       RTNCDE                           OK
     C                   END
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKQ          BEGSR
      *          Check if the output queue is valid

     C                   MOVE      WOUTQ         OUTQ             10
     C                   MOVE      WOUTL         OUTQLB
     C                   MOVE      WBMJBQ        SBMJBQ            1
     C                   MOVE      WBDESC        JBDESC           10
     C                   MOVE      WBDLIB        JBDLIB           10
     C     OUTQ          IFEQ      *BLANKS
     C                   MOVE      '4'           RTNCDE
     C                   EXSR      RETURN
     C                   END

     C     OUTQLB        IFEQ      *BLANKS
     C     OUTQ          ANDNE     '*USRPRF'
     C     OUTQ          ANDNE     '*JOB'
     C                   MOVE      '4'           RTNCDE
     C                   EXSR      RETURN
     C                   END

     C     OUTQLB        IFNE      *BLANKS
     C     OUTQ          ANDNE     '*USRPRF'
     C     OUTQ          ANDNE     '*JOB'
     C                   MOVEL(P)  OUTQ          OBJNAM
     C                   MOVEL(P)  OUTQLB        OBJLIB
     C                   MOVEL(P)  '*OUTQ'       OBJTYP
     C                   EXSR      @CHKOB
     C     EXISTS        IFEQ      'N'                                          Error
     C                   MOVE      '4'           RTNCDE
     C                   EXSR      RETURN
     C                   END

     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CVEW         BEGSR
      *          5=Display attributes

     C     LDXNM1        IFEQ      'B'                                          Image
     C                   EXSR      @CVEWI
     C                   ELSE                                                   Report
     C     LDXNAM        CHAIN     MRPTDIR7                           50
     C                   MOVE      '1'           CHGACT            1
     C                   Z-ADD     FILNUM        FILNUB
     c                   move      datfop        @datfo
     C                   CALL      'DSPRDR'                             49
     C                   PARM                    FLDR                           Folder
     C                   PARM                    FLDRLB                         Libr
     C                   PARM                    FILNAM                          Report
     C                   PARM                    JOBNAM                          Job
     C                   PARM                    USRNAM                          User
     C                   PARM                    JOBNUM                           Job#
     C                   PARM                    @datfo                          date spool file ope
     C                   PARM                    FILNUB                           File#
     C                   PARM                    OPTITL                         Description
     C                   PARM                    CHGACT                         Action code
     C                   PARM                    RTNCDE                         Return code
     C                   MOVEL     '@CVEW'       LCALL
     C                   MOVE      'Y'           CLOSEW
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CVEWI        BEGSR
      *          Show Img Dir info

     C     LDXNAM        CHAIN     MIMGDIR                            50
     C     *IN50         IFEQ      *OFF
     C                   MOVE      IDDSCN        YYMMDD
     C                   EXSR      CVTMDY
     C                   MOVE      @DATE         #DTSCN
     C                   MOVE      IDDCPT        YYMMDD
     C                   EXSR      CVTMDY
     C                   MOVE      @DATE         #DTCPT
     C                   MOVE      IDTDTE        YYMMDD
     C                   EXSR      CVTMDY
     C                   MOVE      @DATE         #DTTAP
     C                   MOVE      LXSPG$        STRIMG
     C                   MOVE      LXEPG$        ENDIMG
     C                   ELSE

     C                   CLEAR                   IDFLD
     C                   CLEAR                   IDFLIB
     C                   CLEAR                   IDDOCT
     C                   CLEAR                   IDPFIL
     C                   CLEAR                   IDDESC
     C                   CLEAR                   #DTSCN
     C                   CLEAR                   IDTVOL
     C                   CLEAR                   #DTCPT
     C                   CLEAR                   #DTTAP
     C                   CLEAR                   STRIMG
     C                   CLEAR                   IDTFIL
     C                   CLEAR                   ENDIMG
     C                   CLEAR                   IDBNUM
     C                   END
/3316C                   EXSR      @OPTVL

     C     CVEWFM        TAG
     C                   EXFMT     CVEWIFM

/1452C     KEY           DOWEQ     HELP
     C                   MOVEL(P)  'CVEWIFM'     HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      CVEWIFM                                99
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO CVEWFM
/1452C                   ENDDO
     C                   ENDSR
/3316 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/    C     @OPTVL        BEGSR
/     *          If report is on optical get the the Optical Volume
/     *            else use IDTVOL.
/
/    C                   MOVE      *BLANKS       OFLNVL
/    C     IDILOC        IFNE      '2'                                          Tape
/    C                   MOVEL(P)  IDTVOL        OFLNVL
/    C                   ELSE                                                   Optical
/    C                   OPEN      MOPTTBL
/    C     IDBNUM        SETGT     OPTRC
/    C     IDBNUM        READPE    OPTRC                                  50
/    C     *IN50         IFEQ      *OFF
/    C                   MOVE      OPTVOL        OFLNVL
/    C                   END
/    C                   CLOSE     MOPTTBL
/    C                   END
/3316C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CVTMDY        BEGSR
      *          Convert YYMMDD to MMDDYY

     C                   SELECT
     C     DATFMT        WHENEQ    'MDY'
     C                   MOVE      YY            YY2
     C                   MOVE      MMDDYY        @DATE             6 0
     C     DATFMT        WHENEQ    'DMY'
     C                   MOVEL     MMDD          MM
     C                   MOVE      MMDD          DD
     C                   MOVE      DDMMYY        @DATE
     C                   OTHER
     C                   MOVE      YYMMDD        @DATE
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CVTD         BEGSR
      *          Convert date from the system format
      *          to the YMD format or back

     C                   Z-ADD     0             SYSFMT            6 0
     C                   Z-ADD     0             FILFMT            6 0

     C     FRMFMT        IFNE      'FILE'                                        IF FROM SYS
      *                                                     TO FILE FMT
     C                   Z-ADD     WRK60         SYSFMT            6 0
     C                   SELECT
     C     DATFMT        WHENEQ    'YMD'                                        ............
     C                   Z-ADD     WRK60         FILFMT            6 0           CONVERT DAT
     C     DATFMT        WHENEQ    'MDY'                                         FROM SYSTEM
     C                   MOVE      WRK636        FRK636                          FORMAT TO
     C                   MOVE      WRK601        FRK601                          FILE FORMAT
     C     DATFMT        WHENEQ    'DMY'                                               V
     C                   MOVEL     WRK603        WRK40             4 0                 V
     C                   MOVE      WRK602        WRK40                                 V
     C                   MOVE      WRK601        FILFMT                                V
     C                   MOVEL     WRK40         FILFMT                                V
     C                   ENDSL                                                         V

     C                   ELSE                                                    IF FROM FIL
      *                                                     TO SYSTEM F
     C                   Z-ADD     WRK60         FILFMT            6 0
     C                   SELECT
     C     DATFMT        WHENEQ    'YMD'                                        ............
     C                   Z-ADD     WRK60         SYSFMT            6 0           CONVERT THE
     C     DATFMT        WHENEQ    'MDY'                                         YYMMDD DATE
     C                   MOVE      WRK636        SRK614                          SYSTEM FORM
     C                   MOVE      WRK601        SRK603
     C     DATFMT        WHENEQ    'DMY'                                               V
     C                   MOVEL     WRK603        WRK40             4 0                 V
     C                   MOVE      WRK602        WRK40                                 V
     C                   MOVE      WRK601        SYSFMT                                V
     C                   MOVEL     WRK40         SYSFMT                                V
     C                   ENDSL

     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETSCN        BEGSR
      *          Initialize vars, screens, arrays, etc

/5909c                   eval      idl(*) = 0
/    c                   eval      d(*) = ' '
     C                   MOVE      DATSEP        SLASH1
     C                   MOVE      DATSEP        SLASH2
     C                   MOVE      *BLANKS       ID
     C                   MOVE      *BLANKS       IN
     C                   MOVEL     PHYMBR        MTYP              1
     C                   Z-ADD     1             KL
     C                   Z-ADD     8             KL(8)
     C                   Z-ADD     0             IL
     C                   Z-ADD     0             LE
     C                   Z-ADD     0             DP
     C                   Z-ADD     0             INTEST
     C                   MOVE      *BLANKS       INDXO1
     C                   MOVE      *BLANKS       INDXO2
     C                   MOVE      *BLANKS       INDXO3
     C                   MOVE      *BLANKS       INDXO4
     C                   MOVE      *BLANKS       INDXO5
     C                   MOVE      *BLANKS       INDXO6
     C                   MOVE      *BLANKS       INDXO7

     C     IDXCG         IFNE      'N'
     C                   MOVE      *BLANKS       INDXI1
     C                   MOVE      *BLANKS       INDXI2
     C                   MOVE      *BLANKS       INDXI3
     C                   MOVE      *BLANKS       INDXI4
     C                   MOVE      *BLANKS       INDXI5
     C                   MOVE      *BLANKS       INDXI6
     C                   MOVE      *BLANKS       INDXI7
     C                   MOVE      'YYYYMMDD'    INDX8S
     C                   MOVE      'YYYYMMDD'    INDX8E
     C                   ENDIF
      * Init key fields
     C                   MOVE      WFILN         FILNAM                         *Entry Big5
     C                   MOVE      WJOBN         JOBNAM                            "
     C                   MOVE      WPROG         PGMOPF                            "
     C                   MOVE      WUSR          USRNAM                            "
     C                   MOVE      WUDTA         USRDTA                            "
     C                   MOVE      *BLANKS       FLDR
     C                   MOVE      *BLANKS       FLDRLB
     C                   MOVE      *BLANKS       JOBNUM
     C                   Z-ADD     0             FILNUM

     C                   MOVE      *BLANKS       LCALL             5
     C                   MOVE      '1'           SUBFL             1
     C                   MOVE      'F'           DIRECT            1
     C                   Z-ADD     1             LFILE#            1 0
     C                   Z-ADD     1             WFILE#            1 0
     C                   MOVEL     *BLANKS       NPOS
     C                   MOVE      ' '           CLOSEW            1
     C                   EXSR      CLRMSG
     C                   Z-ADD     0             CRRN1             9 0
     C                   Z-ADD     0             CRRN1S            9 0
     C                   Z-ADD     0             TOPRRN            9 0
     C                   Z-ADD     0             SELIO

     C                   MOVEL     ERR(7)        @ERCON                         Default
     C                   EXSR      RTVMSG                                        DASD
     C                   MOVEL     @MSGTX        STORAG
     C                   MOVE      '0'           LASER

     C     KLBIG5        CHAIN     RMNTRC                             30
     C  N30              MOVEL     RRDESC        OPTITL
     C   30              MOVE      *BLANKS       OPTITL

     C     WQPRM         IFGE      47
     C     WOFILE        ANDNE     *BLANKS
     C     LOFILI        ORNE      *BLANKS
     C                   MOVEL     ERR(6)        @ERCON                         Optical
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        STORAG
     C     LOFILI        IFEQ      *BLANKS
     C     WQPRM         ANDGE     47
     C                   MOVE      WOODES        OPTITL           40
     C                   MOVE      WOOPID        LOOPID
     C                   MOVE      WODRV         LODRV
     C                   MOVEL     WOVOL         LOVOL                          Opt Vol
     C                   MOVEL     WODIR         LODIR                          Directory
     C                   MOVEL     WOFILE        LOFILI                         Opt FileName
     C                   ENDIF
     C                   MOVE      '1'           LASER
     C                   ELSE
     C                   MOVE      *BLANKS       LOOPID                         Dasd
     C                   MOVE      *BLANKS       LODRV
     C                   MOVE      *BLANKS       LOVOL
     C                   MOVE      *BLANKS       LODIR
     C                   MOVE      *BLANKS       LOFILI
     C                   ENDIF

     C     KLBIG5        CHAIN     RLNKDEF                            98
     C     *IN98         IFEQ      *ON
     C                   MOVE      ERR(1)        MSGID                          Lnk no exist
     C                   EXSR      SNDMSG
     C                   GOTO      ENDSCN
     C                   ENDIF

     C     LOFILI        IFNE      *BLANKS                                      Get optical
     C                   EXSR      OPTDSC                                        header
     C     ERTNID        IFNE      *BLANKS                                      Error
     C                   MOVEL     ERTNID        MSGID                           no links
     C                   MOVEL     ERTNDT        MSGDTA
     C                   EXSR      SNDMSG
     C                   GOTO      ENDSCN
     C                   ENDIF
     C                   ELSE
     C                   CLEAR                   OPTIC
     C                   CLEAR                   DASD
     C                   ENDIF

     C                   DO        7             X                              Load 7 logcl

     C                   SELECT
     C     X             WHENEQ    1
     C                   MOVEL     LNDXN1        IINAM                          eg:@PATIENT
     C                   MOVE      LNDXN1        IN(X)                                " 8x10
     C                   MOVE      IINAM         TMP9                                 "
     C                   MOVEL     TMP9          NPOS                           eg:PATIENT
     C     X             WHENEQ    2
     C                   MOVEL     LNDXN2        IINAM
     C                   MOVE      LNDXN2        IN(X)
     C     X             WHENEQ    3
     C                   MOVEL     LNDXN3        IINAM
     C                   MOVE      LNDXN3        IN(X)
     C     X             WHENEQ    4
     C                   MOVEL     LNDXN4        IINAM
     C                   MOVE      LNDXN4        IN(X)
     C     X             WHENEQ    5
     C                   MOVEL     LNDXN5        IINAM
     C                   MOVE      LNDXN5        IN(X)
     C     X             WHENEQ    6
     C                   MOVEL     LNDXN6        IINAM
     C                   MOVE      LNDXN6        IN(X)
     C     X             WHENEQ    7
     C                   MOVEL     LNDXN7        IINAM
     C                   MOVE      LNDXN7        IN(X)
     C                   ENDSL

     C     OPTIC         IFEQ      '1'                                          OFFLINE
     C                   MOVEL     ON(X)         IINAM
     C                   MOVE      ON(X)         IN(X)
     C                   ENDIF

     C     IINAM         IFNE      *BLANKS
     C     RIKEY         CHAIN     RINDEX1                            98        w/ IINAM
     C     RIKEY         KLIST
     C                   KFLD                    LRNAM
     C                   KFLD                    LJNAM
     C                   KFLD                    LPNAM
     C                   KFLD                    LUNAM
     C                   KFLD                    LUDAT
     C                   KFLD                    IINAM

     C     OPTIC         IFEQ      '1'                                          Optical
     C                   EXSR      OVRDSC                                        ovr index
     C                   ENDIF                                                   descr

     C     *IN98         IFEQ      *OFF
     C     OPTIC         OREQ      '1'

     C     IDESC         IFEQ      *BLANKS                                      Load index
     C                   MOVE      IINAM         TMP9                            description
     C                   MOVEL     TMP9          IDESC                           length in
     C                   END                                                     IDL (8x2.0)
     C     ' '           CHECKR    IDESC         IDL(X)                         LASTnon-blnk
     C                   ADD       1             IDL(X)
     C                   MOVE      IDESC         ID(X)

     C                   MOVE      IKLEN         KL(X)                          Key lengths.
     C                   Z-ADD     1             LE(X)                          Logcl exists

     C     IKLEN         IFGT      70                                           Longest
     C                   MOVE      70            IL(X)                           supported
/3723C                   MOVE      'Y'           LNGKEY            1
     C                   ELSE                                                    key = 70chr
     C                   MOVE      IKLEN         IL(X)
     C                   END

     C                   END
     C                   END
     C                   ENDDO

     C                   Z-ADD     KL            @KL
     C                   MOVEL     '@Created'    IN(8)
     C                   MOVEL     'Created '    ID(8)
     C                   Z-ADD     10            IL(8)
     C                   Z-ADD     10            IDL(8)
     C                   Z-ADD     1             LE(8)

     C                   MOVEL     '@TYPE'       IN(9)
     C                   MOVEL     'Type'        ID(9)
     C                   Z-ADD     5             IL(9)
     C                   Z-ADD     5             IDL(9)

     C                   MOVEL     '@Status'     IN(10)
     C                   MOVEL     'Status'      ID(10)
     C                   Z-ADD     7             IL(10)
     C                   Z-ADD     7             IDL(10)

     C                   MOVEL     '@Notes'      IN(11)
     C                   MOVEL     NOTTIT        ID(11)
     C                   Z-ADD     6             IL(11)
     C                   Z-ADD     6             IDL(11)

     C                   Z-ADD     0             Y
     C                   Z-ADD     0             SCR               3 0
     C                   Z-ADD     0             POS               3 0

     C                   DO        11            X
     C     IL(X)         IFEQ      0                                            Skip if
     C     IDL(X)        ANDEQ     0                                              empty.
     C                   ITER
     C                   ENDIF

     C     IL(X)         IFGE      IDL(X)                                       For each
     C                   ADD       IL(X)         POS                            logical
     C                   ELSE                                                   use
     C                   ADD       IDL(X)        POS                            greater
     C                   ENDIF                                                  of index
      *                                                    or desc
      *----------------------------------------------------------------
      * If INT is GT current Screen #  and we have a remainder,
      *      field does not fit on screen.
      * SCR = 1, POS = 80, 80/71= 1.13 new start is 1 * 71 or scr*71
      *----------------------------------------------------------------
     C     POS           DIV       70            INT               3 0
     C                   MVR                     REM               3 0
     C     INT           IFGE      SCR
     C     POS           SUB       Y             TMP
     C     SCR           MULT      70            Y
     C                   Z-ADD     0             REM
     C                   ADD       1             SCR
     C     TMP           ADD       Y             POS
     C                   ENDIF
      *----------------------------------------------------------------
      * Save the starting position so the data will be placed there.
      * Use Description Length for Title, and blank out after the title
      * If we did not end on a display border (POS/70) = 0) then the
      *    next field should start 3 positions over
      *----------------------------------------------------------------
     C                   ADD       1             Y                              Load T
     C                   Z-ADD     Y             DP(X)                            498x1.
     C                   MOVEA     ID(X)         T(Y)
     C     Y             ADD       IDL(X)        TMP               5 0
T6762c                   If        Tmp <= %Elem(T)
     C                   MOVEA     *BLANKS       T(TMP)
T6762c                   EndIf

     C     REM           IFLE      68
     C                   ADD       2             POS
     C                   ENDIF
      *                                                       Y=end of
     C                   Z-ADD     POS           Y                                 prev fld.
     C                   ENDDO

     C                   MOVE      *BLANKS       SORT1
     C                   MOVE      *BLANKS       SORT2
     C                   MOVE      *BLANKS       SORT3
     C                   MOVE      *BLANKS       SORT4
     C                   MOVE      *BLANKS       SORT5
     C                   MOVE      *BLANKS       SORT6
     C                   MOVE      *BLANKS       SORT7
     C                   MOVE      *BLANKS       SORT8

     C     LE(1)         IFEQ      1                                             Logcl exsts
     C                   MOVE      IN(1)         TMP9                            eg @PATIENT
     C     '1. '         CAT       TMP9:0        SORT1
     C                   CAT       ' - ':0       SORT1                           1. PATIENT
     C                   MOVE      IN(2)         TMP9                               -
     C                   CAT       TMP9:0        SORT1                              D.O.S.
     C                   CAT       ' - ':0       SORT1                              -
     C                   MOVE      IN(3)         TMP9
     C                   CAT       TMP9:0        SORT1                              SURGEON
     C                   CAT       ' - ':0       SORT1
     C                   MOVE      IN(4)         TMP9
     C                   CAT       TMP9:0        SORT1
     C                   CAT       ' - ':0       SORT1
     C                   MOVE      IN(5)         TMP9
     C                   CAT       TMP9:0        SORT1
     C                   END
      *-------------------------------------------------------
     C     LE(2)         IFEQ      1
     C     IN(2)         ANDNE     *BLANKS
     C                   MOVE      IN(2)         TMP9
     C     '2. '         CAT       TMP9:0        SORT2                          2. D.O.S.
     C                   CAT       ' - ':0       SORT2                             -
     C                   MOVE      IN(1)         TMP9
     C                   CAT       TMP9:0        SORT2                             PATIENT
     C                   CAT       ' - ':0       SORT2                             -
     C                   MOVE      IN(3)         TMP9
     C                   CAT       TMP9:0        SORT2                             SURGEON
     C                   CAT       ' - ':0       SORT2
     C                   MOVE      IN(4)         TMP9
     C                   CAT       TMP9:0        SORT2
     C                   CAT       ' - ':0       SORT2
     C                   MOVE      IN(5)         TMP9
     C                   CAT       TMP9:0        SORT2
     C                   END
      *-------------------------------------------------------
     C     LE(3)         IFEQ      1
     C     IN(3)         ANDNE     *BLANKS
     C                   MOVE      IN(3)         TMP9
     C     '3. '         CAT       TMP9:0        SORT3                          3. SURGEON
     C                   CAT       ' - ':0       SORT3                             -
     C                   MOVE      IN(1)         TMP9
     C                   CAT       TMP9:0        SORT3                             PATIENT
     C                   CAT       ' - ':0       SORT3                             -
     C                   MOVE      IN(2)         TMP9
     C                   CAT       TMP9:0        SORT3                             D.O.S.
     C                   CAT       ' - ':0       SORT3
     C                   MOVE      IN(4)         TMP9
     C                   CAT       TMP9:0        SORT3
     C                   CAT       ' - ':0       SORT3
     C                   MOVE      IN(5)         TMP9
     C                   CAT       TMP9:0        SORT3
     C                   END
      *-------------------------------------------------------
     C     LE(4)         IFEQ      1
     C     IN(4)         ANDNE     *BLANKS
     C                   MOVE      IN(4)         TMP9
     C     '4. '         CAT       TMP9:0        SORT4
     C                   CAT       ' - ':0       SORT4
     C                   MOVE      IN(1)         TMP9
     C                   CAT       TMP9:0        SORT4
     C                   CAT       ' - ':0       SORT4
     C                   MOVE      IN(2)         TMP9
     C                   CAT       TMP9:0        SORT4
     C                   CAT       ' - ':0       SORT4
     C                   MOVE      IN(3)         TMP9
     C                   CAT       TMP9:0        SORT4
     C                   CAT       ' - ':0       SORT4
     C                   MOVE      IN(5)         TMP9
     C                   CAT       TMP9:0        SORT4
     C                   END
      *-------------------------------------------------------
     C     LE(5)         IFEQ      1
     C     IN(5)         ANDNE     *BLANKS
     C                   MOVE      IN(5)         TMP9
     C     '5. '         CAT       TMP9:0        SORT5
     C                   CAT       ' - ':0       SORT5
     C                   MOVE      IN(1)         TMP9
     C                   CAT       TMP9:0        SORT5
     C                   CAT       ' - ':0       SORT5
     C                   MOVE      IN(2)         TMP9
     C                   CAT       TMP9:0        SORT5
     C                   CAT       ' - ':0       SORT5
     C                   MOVE      IN(3)         TMP9
     C                   CAT       TMP9:0        SORT5
     C                   CAT       ' - ':0       SORT5
     C                   MOVE      IN(4)         TMP9
     C                   CAT       TMP9:0        SORT5
     C                   END
      *-------------------------------------------------------
     C     LE(6)         IFEQ      1
     C     IN(6)         ANDNE     *BLANKS
     C                   MOVE      IN(6)         TMP9
     C     '6. '         CAT       TMP9:0        SORT6
     C                   CAT       ' - ':0       SORT6
     C                   MOVE      IN(1)         TMP9
     C                   CAT       TMP9:0        SORT6
     C                   CAT       ' - ':0       SORT6
     C                   MOVE      IN(2)         TMP9
     C                   CAT       TMP9:0        SORT6
     C                   CAT       ' - ':0       SORT6
     C                   MOVE      IN(3)         TMP9
     C                   CAT       TMP9:0        SORT6
     C                   CAT       ' - ':0       SORT6
     C                   MOVE      IN(4)         TMP9
     C                   CAT       TMP9:0        SORT6
     C                   END
      *-------------------------------------------------------
     C     LE(7)         IFEQ      1
     C     IN(7)         ANDNE     *BLANKS
     C                   MOVE      IN(7)         TMP9
     C     '7. '         CAT       TMP9:0        SORT7
     C                   CAT       ' - ':0       SORT7
     C                   MOVE      IN(1)         TMP9
     C                   CAT       TMP9:0        SORT7
     C                   CAT       ' - ':0       SORT7
     C                   MOVE      IN(2)         TMP9
     C                   CAT       TMP9:0        SORT7
     C                   CAT       ' - ':0       SORT7
     C                   MOVE      IN(3)         TMP9
     C                   CAT       TMP9:0        SORT7
     C                   CAT       ' - ':0       SORT7
     C                   MOVE      IN(4)         TMP9
     C                   CAT       TMP9:0        SORT7
     C                   END
      *-------------------------------------------------------
     C     LE(8)         IFEQ      1
     C                   MOVE      IN(8)         TMP9
     C     '8. '         CAT       TMP9:0        SORT8
     C                   CAT       ' - ':0       SORT8
     C                   MOVE      IN(1)         TMP9
     C                   CAT       TMP9:0        SORT8
     C                   CAT       ' - ':0       SORT8
     C                   MOVE      IN(2)         TMP9
     C                   CAT       TMP9:0        SORT8
     C                   CAT       ' - ':0       SORT8
     C                   MOVE      IN(3)         TMP9
     C                   CAT       TMP9:0        SORT8
     C                   CAT       ' - ':0       SORT8
     C                   MOVE      IN(4)         TMP9
     C                   CAT       TMP9:0        SORT8
     C                   END
      *----------------------------------------------------------------
      * Move Title to All Title Screens (seton Screen 1=81)
      * Set current screen number to 1
      * Set Maximum displayable screens MAXSCR
      *----------------------------------------------------------------
     C                   MOVEA     T             T560                           8 lines of70
     C                   MOVE      *ON           *IN81
     C                   Z-ADD     SCR           MAXSCR            3 0
     C                   Z-ADD     1             SCR
     C                   Z-ADD     0             CR                5 0
     C     ENDSCN        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPTDSC        BEGSR

     C                   MOVE      *BLANKS       ERTNID
     C                   MOVE      *BLANKS       ERTNDT

     C     LOVOL         IFNE      *BLANKS
     C                   CALL      'GETHDR'                             50
     C                   PARM                    LOOPID           10            OptId
     C                   PARM                    LODRV            15            Opt Drive
     C                   PARM                    LOVOL            12            Volume
     C                   PARM                    LODIR            80            Sub dir
     C                   PARM                    LOFILI                         File name
     C                   PARM                    DTA                            Rtn data
     C                   PARM      ' '           ECLSP             1            Close pgm
     C                   PARM      *BLANKS       ERTNID            7            Retrn ID
     C                   PARM      *BLANKS       ERTNDT          100            Retrn DATA

     C                   MOVE      '1'           ACTHDR            1
     C                   MOVE      '1'           OPTIC             1
     C                   MOVE      ' '           DASD              1

     C                   ELSE
      *  Get hidden big5 key

     C                   MOVEL(P)  'MAGELLAN'    HRNAM            10
     C                   MOVEL(P)  'SOFTWARE'    HJNAM            10
     C                   MOVEL(P)  'DASDLINK'    HPNAM            10
     C                   MOVEL(P)  LOFILI        HUNAM            10
      * Read short key loseq not available
     C     KEYHID        KLIST
     C                   KFLD                    HRNAM
     C                   KFLD                    HJNAM
     C                   KFLD                    HPNAM
     C                   KFLD                    HUNAM

     C     KEYHID        CHAIN     RLNKDEF                            50

     C                   MOVE      ' '           OPTIC             1
     C                   MOVE      '1'           DASD              1
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OVRDSC        BEGSR

     C     OKL(X)        IFNE      IKLEN                                        changed
     C     *IN98         OREQ      *ON                                          not found
     C     LOVERS        ORGT      1                                            new version
     C                   Z-ADD     OKL(X)        IKLEN
     C     LOVERS        IFNE      1                                            from optical
     C                   MOVEL     ID@(X)        IDESC
     C                   ELSE
     C   98              MOVEL     ON(X)         IDESC
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETFKY        BEGSR
      *          Read f-key text from pscon
     C                   CLEAR                   TX1024

     C                   MOVEL     'FKY0300'     @ERCON                          F3=EXIT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TX1024

     C                   MOVEL     'FKY0500'     @ERCON                          F5=REFRESH
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024

     C                   MOVEL     'FKY0901'     @ERCON                          F9=TOP
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024

     C                   MOVEL     'FKY1002'     @ERCON                          F10=BOTTOM
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024

     C                   MOVEL     'FKY1100'     @ERCON                          F11=ALTVIEW
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024
/3723
     C                   MOVEL     'FKY1402'     @ERCON                          F14=FIND
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024

     C     *IN16         IFEQ      '1'
     C                   MOVEL     'FKY1602'     @ERCON                          F16=FILTER
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024
     C                   ENDIF

     C                   MOVEL     'FKY1700'     @ERCON                          F17=SORT
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024

/3723C     @OMNI         IFEQ      'N'
/3723C                   MOVEL     'FKY1802'     @ERCON                          F18=REPEAT
/3723C                   EXSR      RTVMSG
/3723C                   CAT       @MSGTX:3      TX1024
/3723C                   ENDIF

     C     MAXF23        IFGT      1
     C                   MOVE      'FKY2300'     @ERCON                         F23
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024
     C                   ENDIF

     C     '*'           CHECKR    FKEY          MAXFKY

     C                   CALL      'BLDSPKEY'
     C                   PARM                    TX1024                         Text
     C                   PARM                    MAXFKY            5 0          Max length
     C                   PARM                    FKT                            Rtn text
     C                   PARM                    MAXF24            5 0          Max pres F24
/7829
/7829c                   if        sav_key# <> 0
/7829c                   eval      key# = sav_key#
/7829c                   eval      sav_key# = 0
/7829c                   else
     C                   Z-ADD     1             KEY#
/7829c                   endif

     C                   MOVEL     FKT(KEY#)     FKEY

     C                   ENDSR
/3723 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3723C     $OMNI         BEGSR
/3723
/3723C****       KYMVR1    KLIST
/3723C     KYDRPT        KLIST
/3723C                   KFLD                    WFILN
/3723C                   KFLD                    WJOBN
/3723C                   KFLD                    WPROG
/3723C                   KFLD                    WUSR
/3723C                   KFLD                    WUDTA
/3723
/3723C****       KYMVR1    SETLLMVRPTID1                 96-FOUND
/3723C     KYDRPT        SETLL     DRPTIDX1                               96    -FOUND
/3723
/3723C     *IN96         IFEQ      '1'
/3723C                   MOVE      'Y'           OMNFLG            1
/3723C                   ENDIF
/3723
/3723C     XOMNI         ENDSR
/3723 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3723C     $DLTKY        BEGSR
/3723 *          Read f-key text from pscon
/3723C                   CLEAR                   TX1024
/3723
/3723C                   MOVEL     'FKY0300'     @ERCON                          F3=EXIT
/3723C                   EXSR      RTVMSG
/3723C                   MOVEL     @MSGTX        TX1024
/3723
/3723C                   MOVEL     'FKY2602'     @ERCON                          F10=CONFIRM
/3723C                   EXSR      RTVMSG
/3723C                   CAT       @MSGTX:3      TX1024
/3723
/3723C                   MOVEL     'FKY1200'     @ERCON                          F10=CONFIRM
/3723C                   EXSR      RTVMSG
/3723C                   CAT       @MSGTX:3      TX1024
/3723
/3723C     '*'           CHECKR    FKEY          MAXFKY
/3723
/3723C                   CALL      'BLDSPKEY'
/3723C                   PARM                    TX1024                         Text
/3723C                   PARM                    MAXFKY            5 0          Max length
/3723C                   PARM                    FKT                            Rtn text
/3723C                   PARM                    MAXF24            5 0          Max pres F24
/3723
/3723C                   Z-ADD     1             KEY#
/3723C                   MOVEL     FKT(KEY#)     FKEY1
/3723
/3723C     XDLTKY        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     APPSEC        BEGSR
      *          Get Application security.
      *          Fill TITLE1 for options prompt.

     C                   CLEAR                   TX1024

      * get extended security options
/5197c                   MOVEL     'MAG203'      OBJNAM
/    c                   CALL      'MAG1060'     mag1060pl
/    c                   MOVEL     AUTE(14)      NotesAuth         1

/5197c                   MOVEL     'WRKSPI'      OBJNAM
/    c                   CALL      'MAG1060'     mag1060pl
/    c     mag1060pl     plist
/    c                   PARM      'WRKSPI'      CALPGM           10            Calling pgm
     C                   PARM      'N'           PGMOFF            1            Keep it up
     C                   PARM      'O'           CKTYPE            1            Chk (O)bjct
     C                   PARM      'A'           OBJCOD            1            (A)pplicatn
/5197c                   PARM                    OBJNAM           10            Progrm name
     C                   PARM      WQLIBN        OBJLIB           10            Progrm libr
     C                   PARM      *BLANK        RNAME            10
     C                   PARM      *BLANK        JNAME            10
     C                   PARM      *BLANK        PNAME            10
     C                   PARM      *BLANK        UNAME            10
     C                   PARM      *BLANK        UDATA            10
     C                   PARM      07            REQOPT            2 0          Reqstd optn
     C                   PARM      *BLANK        AUTRTN            1            Return Y/N
     C                   PARM      *BLANK        AUT                            Return array
/2839C                   PARM      *BLANK        AUTE                           Return EXTENDED arra

     C     AUTRTN        IFEQ      'N'
     C                   CALL      'SPYERR'
     C                   PARM      'E000009'     MSGID             7
     C                   EXSR      RETURN                                       USER CANNOT
     C                   END                                                     run this pg
      * Fill TITLE1

     C     AUT(1)        IFNE      'N'                                          1=Select
     C                   MOVEL     'OPT0102'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END

     C     AUT(6)        IFNE      'N'                                          2=Print
     C                   MOVEL     'OPT0202'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END

     C     AUT(1)        IFNE      'N'                                          Select
     C     ACTATT        ANDEQ     '1'                                          ACTIVE 3=ATT
     C                   MOVEL     'OPT0302'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END
/3723
/3723 * Determine user's authority to delete (authority to delete from
/4662C     AUT(4)        IFEQ      'Y'                                          Delete
/3723C                   MOVEL     'OPT0401'     @ERCON
/3723C                   EXSR      RTVMSG
/3723C                   CAT       @MSGTX:2      TX1024
/3723C                   END

     C     AUT(5)        IFNE      'N'                                          5=View
     C                   MOVEL     'OPT0503'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END
/4278
/4278C     AUT(3)        IFNE      'N'                                          Copy
/4278C                   MOVEL     'OPT0703'     @ERCON                         7=COPY
/4278C                   EXSR      RTVMSG
/4278C                   CAT       @MSGTX:2      TX1024
/4278C                   END

     C     AUT(2)        IFNE      'N'                                          Chg LinkValu
     C*/4278               MOVEL'OPT0703' @ERCON           7=COPY
     C*/4278               EXSR RTVMSG
     C*/4278               CAT  @MSGTX:2  TX1024
     C                   MOVEL     'OPT0805'     @ERCON                         8=CHANGE
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END

      *   User exit program
     C                   OPEN      RDBKEY
     C                   Z-ADD     3             KVAL
     C     KEYVAL        CHAIN     RDBKEY                             50
     C     *IN50         IFEQ      *OFF
     C     AUT(1)        ANDNE     'N'
     C                   CAT(P)    '9=':2        TX1024
     C                   CAT       KMBR:0        TX1024
     C                   ELSE
     C                   CLEAR                   KOBJ
     C                   ENDIF
     C                   CLOSE     RDBKEY

      * Special in WrkSpi for RVI imaging software:
      *  Don't allow opts 11 or 12 unless SpySys Dft 3rd pty imging=RVI
      *  Don't allow 10 unless pgm MVC012 exists, 11 unless MVC013 exst

     C     LIMGID        IFNE      'RVI'                                        Not avail,
     C                   MOVEA     'NN'          AUT(23)                         SELIO 10,11
     C                   ELSE
     C                   MOVEL     '*LIBL   '    OBJLIB
     C                   MOVEL     '*PGM    '    OBJTYP
     C                   MOVE      'MVC012'      RVIVEW            9            View progrm
     C                   MOVEL(P)  RVIVEW        OBJNAM           10             exists?
     C                   EXSR      @CHKOB
     C     EXISTS        IFEQ      'N'                                          Nope, no
     C                   MOVE      'N'           AUT(23)                         SELIO=10.
     C                   END

     C                   MOVEL     'MVC013'      RVISCN            9            Scan progrm
     C                   MOVEL(P)  RVISCN        OBJNAM                          exists?
     C                   EXSR      @CHKOB
     C     EXISTS        IFEQ      'N'                                          Nope, no
     C                   MOVE      'N'           AUT(24)                         SELIO=11.
     C                   END
     C                   END

     C     AUT(23)       IFNE      'N'                                          View RVI
     C                   MOVEL     'OPT1004'     @ERCON                         10=DISPLAY I
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END

     C     AUT(24)       IFNE      'N'                                          Scan RVI
     C                   MOVEL     'OPT1103'     @ERCON                         11=SCAN IMAG
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END

     C     AUT(6)        IFNE      'N'                                          FAX/MAIL
     C     FAXTYP        IFNE      '0'                                          FAX
     C     MLACT         OREQ      'Y'                                          OR MAIL
     C                   MOVEL     'OPT1305'     @ERCON                         13=SEND
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END
     C                   END

     C     WVACT         IFEQ      'Y'                                          14=TRACKING
     C     AUT(1)        ANDNE     'N'                                          NOTES
     C                   MOVEL     'OPT1402'     @ERCON                         14=TRACK
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END

/4278C     AUT(9)        IFNE      'N'                                          Move
     C                   MOVEL     'OPT1701'     @ERCON                         17=MOVE
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   ENDIF

/5197c     NotesAuth     IFNE      'N'                                          NOTES
     C                   MOVEL     'OPT1801'     @ERCON                         18=NOTES
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
/    C                   END
/    C     AUT(1)        IFNE      'N'
     C                   MOVEL     'OPT2501'     @ERCON                         25=FINDS
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END
     C     WVACT         IFEQ      'Y'                                          STAFFVIEW
     C     AUT(1)        ANDNE     'N'
     C                   MOVEL     'OPT3101'     @ERCON                         31=START CAS
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:2      TX1024
     C                   END

     C     '*'           CHECKR    TITLE1        MAXOPT                         GET FLD LENG

     C                   CALL      'BLDSPOPT'
     C                   PARM                    TX1024                         Text
     C                   PARM                    MAXOPT            5 0          Max length
     C                   PARM      2             MAXLIN            5 0          Max Lines
     C                   PARM                    OT                             Rtn text
     C                   PARM                    MAXF23            5 0          Max pres F23

     C                   Z-ADD     1             OT#
     C                   MOVEL     OT(OT#)       TITLE1
     C                   ADD       1             OT#
     C                   MOVEL     OT(OT#)       TITLE2
     C                   SUB       1             OT#

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @GSEC         BEGSR
      *          Get User security info

     C                   CALL      'MAG1060'
     C                   PARM      'WRKSPI'      CALPGM                         Calling Pgm
     C                   PARM      *BLANKS       PGMOFF                         Unload Pgm
     C                   PARM      'U'           CKTYPE                         Chk Type
     C                   PARM      'R'           OBJCOD                         Fld or Rpt
     C                   PARM      *BLANKS       FOLDER           10
     C                   PARM      *BLANKS       OBJLIB
     C                   PARM      *BLANKS       RNAME
     C                   PARM      *BLANKS       JNAME
     C                   PARM      *BLANKS       PNAME
     C                   PARM      *BLANKS       UNAME
     C                   PARM      *BLANKS       UDATA
     C                   PARM      0             REQOPT                         Reqst Opt
     C                   PARM      *BLANKS       AUTRTN                         Auth return

      * If "Power User" or ext sec on, set on *IN90.
     C     AUTRTN        IFEQ      'Y'
     C                   MOVE      *ON           *IN90
     C                   ELSE
     C                   MOVE      *OFF          *IN90
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDEIA        BEGSR
      *          Send Error message "Insuff Auth"

     C                   EXSR      @CLROP                                       Clear option
     C                   MOVE      'ERR1203'     MSGID
     C                   EXSR      SNDMSG
      *     DON'T EVEN THINK ABOUT COPYING THIS GOTO
     C                   GOTO      SHOWS1
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVERM        BEGSR
      *          Retrieve error message
     C     @ERCON        IFNE      *BLANKS
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        ERRMSG
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVMSG        BEGSR
      *          Retrieve message from PSCON

     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80

     C                   MOVE      *BLANKS       @ERDTA
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    CLCMD           250
     C                   PARM      250           F155             15 5
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

     C     WQLIBN        IFEQ      'QTEMP'                                      Using pgm
     C     3             SUBST     WQPGMN:8      PGMSFX            3             name w/sufx
     C                   END

     C                   MOVEL(P)  OVRDSP        CLCMD
     C                   EXSR      RUNCL

     C                   OPEN      WRKSPIFM                             35
     C     *IN35         IFEQ      *ON                                          Batch job
     C                   MOVE      'Y'           BATCH             1
     C                   ELSE                                                   Interactive
     C                   MOVE      'N'           BATCH
     C                   END

     C     *DTAARA       DEFINE                  SYSDFT
     C                   IN        SYSDFT

J4795 /free
J4795  in sysdft2;
J4795 /end-free

     C                   CALL      'MAG8090'                                    DATE FORMAT
     C                   PARM                    DATFMT            3
     C                   PARM                    DATSEP            1
     C                   PARM                    TIMSEP            1

     C     DATFMT        IFEQ      *BLANKS                                      Default
     C                   MOVE      'MDY'         DATFMT                          date format
     C                   END

     C                   Z-ADD     272           BYTPRV
     C                   Z-ADD     0             BYTAVA
     C                   MOVE      *BLANKS       ERRID
     C                   MOVE      *BLANKS       ERR###
     C                   MOVE      *BLANKS       INSDTA
     C                   MOVE      *BLANKS       VIWACT

     C                   MOVE      *BLANKS       OBJECT           20
     C                   MOVE      *BLANKS       OBJAUT           10
     C                   MOVE      *BLANKS       OBJTYP           10
     C                   MOVE      *BLANKS       FRMFMT            4

     C                   EXSR      ACTFIL                                       ACTION FILE
     C                   CALL      'CHKIMGD'
     C                   PARM                    IMGDSP            1            1=Img
      *                                                      capable
     C                   MOVE      'N'           SETLR

     C                   EXSR      @GSEC                                        Get user sec

/2319C                   MOVEL(P)  'INIT'        OPCODE                         PROGRAM START
/    C                   CALL      'SPYCSLNK'    PLSPY

     C                   MOVEL     'P020055'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        NOTTIT            6            "Notes"
     C                   MOVEL     'P020030'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        NOTTXT            6            "Text"
     C                   MOVEL     'P020031'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        ANNTXT            6            "Annot"
     C                   MOVEL     'P020032'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        BTHTXT            6            "An +Tx"


     C                   MOVEL(P)  'P003071'     @ERCON                          Filter on
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        FLTTXT           30
     C                   MOVEL(P)  'P00307A'     @ERCON                          Query on
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        QRYTXT           30
      * Msg subfile
     C                   MOVE      *ON           *IN75
     C                   MOVE      *BLANKS       MSGKY             4
     C                   MOVEL     '*ALL'        MSGRMV           10

     C                   EXSR      CLRMSG
/2917
/2917 * Retrieve folder security.
/4662 *********          EXSR      @FSEC                                        Folder name n/a
/2917
/3723C     *LIKE         DEFINE    CRRN1         MAXRRN
/3723C     *LIKE         DEFINE    CRRN1         MAXDLT
/3723C                   Z-ADD     9999          MAXRRN
/3723C                   Z-ADD     1000          MAXDLT
/2917
/3723 * User index variables
/3723C                   CLEAR                   USRIDX
/3723C                   MOVE      OFFSET        UIOFST
/3723 ****
/3723 * Override to OmniLink logical and open file.
/3723C****                 MOVE CL,1      CLCMD     P
/3723C****                 EXSR RUNCL
/3723C****                 OPEN MVRPTID1

/3765c                   callp     DmsInit

     C                   ENDSR
/2917 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2917C     @FSEC         BEGSR
/2917
/2917 * Determine user authorizations for folder.
/4662C                   MOVEL     LDXNAM        LDXNM1            1
/    C     ldxnm1        IFEQ      'B'                                          SpyImage
/    C     ldxnam        CHAIN     MIMGDIR
/    C                   MOVEL     IDFLD         @FLDR
/    C                   MOVEL     IDFLIB        @FLDLB
/    C                   ELSE                                                    Report
/    C     ldxnam        CHAIN     MRPTDIR7
/    C                   MOVEL     FLDR          @FLDR
/    C                   MOVEL     FLDRLB        @FLDLB
/4662C                   END
      *
/2917C                   CALL      'MAG1060'
/2917C                   PARM      'WRKSPI'      CALPGM
/4662C                   PARM      *BLANK        PGMOFF
/2917C                   PARM      'O'           CKTYPE
/2917C                   PARM      'F'           OBJCOD
/4662C                   PARM                    @fldr
/4662C                   PARM                    @fldlb
/2917C                   PARM      *BLANK        RNAME
/2917C                   PARM      *BLANK        JNAME
/2917C                   PARM      *BLANK        PNAME
/2917C                   PARM                    WQUSRN
/2917C                   PARM      *BLANK        UDATA
/4662C                   PARM                    REQOPT                         Reqstd optn
/2917C                   PARM      *BLANK        AUTRTN                         Return Y/N
/2917
      *
/4662C     AUTRTN        IFEQ      'Y'
/    C                   MOVE      'Y'           FAUTH             1
/    C                   ELSE
/    C                   MOVE      'N'           FAUTH
/4662C                   END
/2917 * Save change and delete authority flags.
/4662 ****               MOVE      AUT(2)        CHGFLD            1
/4662 ****               MOVE      AUT(4)        DLTFLD            1
/2917
/2917C     XFSEC         ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDMSG        BEGSR
      *          Send pgm msg
     C     MSGID         IFNE      *BLANKS
     C                   CALL      'SNDMSG2'                            50
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA          256
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRMSG        BEGSR
      *          Remove msg
     C                   Z-ADD     272           BYTPRV                         Error Code
     C                   CLEAR                   BYTAVA
     C                   MOVE      *LOVAL        STKCNT
     C                   CALL      'QMHRMVPM'
     C                   PARM                    WQPGMN
     C                   PARM                    STKCNT            4
     C                   PARM                    MSGKY             4
     C                   PARM                    MSGRMV           10
     C                   PARM                    ERROR
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RETURN        BEGSR
      *          Close subprograms that are open and return.
      *          Does NOT close this program or SPYCSLNK here

     C     UNLOAD        IFEQ      1                                            Viewer
     C                   MOVEL(P)  'QUIT'        LNKFIL
     C     PGMSFX        IFEQ      *BLANK                                       Not recursiv
     C                   CALL      'SPYLNKVU'    PLVIEW
     C                   ELSE                                                   Need to call
     C     'SPYLNKV'     CAT       PGMSFX:0      NEWPGM                          cloned pgm.
     C                   CALL      NEWPGM        PLVIEW
     C                   END
     C                   END

     C     UNSCH2        IFEQ      'Y'                                          Alternative
     C                   MOVEL(P)  '*CLOSEW'     FILNAM                         filter input
     C                   CALL      'SPYSCH2'     PLSCH2                         screen pgm
     C                   ENDIF

     C                   MOVE      *BLANKS       LOOPID
     C                   MOVE      *BLANKS       LODRV
     C                   MOVE      *BLANKS       LOVOL
     C                   MOVE      *BLANKS       LODIR
     C                   MOVE      *BLANKS       LOFILI

     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ATTACT        BEGSR
      *          3=Attach link to action file

     C     ACTATT        IFEQ      '1'                                          Is active
     C                   MOVE      FILNAM        ARNAM                           Big5
     C                   MOVE      JOBNAM        AJNAM
     C                   MOVE      PGMOPF        APNAM
     C                   MOVE      USRNAM        AUNAM
     C                   MOVE      USRDTA        AUDAT
     C                   MOVE      LXSPG$        ASTR                            Start page
     C                   MOVE      LXEPG$        AEND                            End page
     C                   MOVEL     LXTYP         ATYPE                           Type
      * Format object
     C                   MOVEL(P)  LXSEQ$        ACTOBJ
     C                   MOVE      LDXNAM        ACTOBJ
      * WorkVu attach
     C                   CALL      'MAG8010'                            50
/7675C                   PARM                    ACTPRO                         PROC NBR.
     C                   PARM                    ACTOBJ           20
     C                   PARM      '*SPYLINK'    ACTTYP           10            LNK TYPE
     C                   PARM      PATHDS        ACTPTH          100            PATH
     C                   PARM      RRDESC        ACTDSC           30            DESCRIPTION
     C                   PARM      ' '           ACTRTN            1            RETURN
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPDAT         BEGSR
      *          8=Update

     C     OPTIC         IFNE      '1'                                          NO OFF OOPTI
     C     DASD          ANDNE     '1'                                          NO OFF DASD
     C     UPDOPT        OREQ      'CLOSE'                                      SHUT DOWN

     C                   MOVE      FILNAM        RRNAM                          Big5
     C                   MOVE      JOBNAM        RJNAM
     C                   MOVE      PGMOPF        RPNAM
     C                   MOVE      USRNAM        RUNAM
     C                   MOVE      USRDTA        RUDAT
     C                   MOVEL     LXSEQ$        SEQ90

     C                   SELECT
     C     SELIO         WHENEQ    7
     C                   MOVEL(P)  'ADD'         UPDOPT
     C     SELIO         WHENEQ    8
/4662C     DLTFLD        IFEQ      'Y'
     C                   MOVEL     *BLANKS       UPDOPT
     C                   ELSE
/4662C                   MOVE      SUNODL        UPDOPT
     C                   ENDIF
     C                   ENDSL

/2917 * If user is not allowed to delete, call SPYUPD with OPCODE =
/2917 * 'SPYUPDNODL'.
/4662 **** DLTFLD        IFEQ      'N'
/4662 *                  MOVE      SUNODL        UPDOPT
/4662 ****               ENDIF
/2917
     C                   CALL      'SPYUPD'                             50
     C                   PARM                    RRNAM            10
     C                   PARM                    RJNAM            10
     C                   PARM                    RPNAM            10
     C                   PARM                    RUNAM            10
     C                   PARM                    RUDAT            10
     C                   PARM                    LDXNAM
     C                   PARM                    SEQ90             9 0
     C                   PARM                    UPDOPT           10
     C                   PARM                    UPDRTN            1

     C                   MOVE      '1'           INDUPD            1            DO RELOAD
     C     UPDOPT        IFNE      'CLOSE'
     C     UPDRTN        IFEQ      ' '
     C     SELIO         IFEQ      7
     C                   MOVEL(P)  'P004197'     MSGID                          ADD OK
     C                   ELSE
     C                   MOVEL     'ACT0050'     MSGID                          UPD OK
     C                   ENDIF
     C                   ELSE
     C     UPDRTN        IFEQ      'D'
     C                   MOVEL     'ACT0009'     MSGID                          DLT OK
     C                   ELSE
     C                   CLEAR                   INDUPD                         NO RELOAD
     C                   MOVEL     'ACT0006'     MSGID                          NO UPD
     C                   ENDIF
     C                   ENDIF
     C                   EXSR      SNDMSG
     C                   ENDIF

     C                   MOVE      '1'           UPDOPN            1            UPDAT OPEN

     C                   ELSE
     C                   MOVE      'ERR1812'     MSGID                          LNK IS OFFL
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MOVE          BEGSR
      *         17=MOVE
     C                   CLEAR                   MSGID

     C     OPTIC         IFNE      '1'                                          NO OFF OOPTI
     C     DASD          ANDNE     '1'                                          NO OFF DASD

     C                   MOVEL     LDXNAM        LDXNM1            1
     C     LDXNM1        IFNE      'B'                                          SpyImage
      *                    "Sorry, cannot move reports"
     C                   MOVEL     'ERR4091'     MSGID
     C                   ELSE

     C                   MOVEL     LXSEQ$        SEQ90

/2917 * If user is not allowed to delete, pass 'MOVENODL' to SPYMOV.
/2917C     DLTFLD        IFEQ      'Y'
     C                   MOVEL     'MOVE'        MOVOPT
/2917C                   ELSE
/2917C                   MOVEL     'MOVENODL'    MOVOPT
/2917C                   ENDIF

     C                   CALL      'SPYMOV'      PLMOV                  50
     C     PLMOV         PLIST
     C                   PARM                    MOVOPT
     C                   PARM                    CPYNOT            1
     C                   PARM      'Y'           PMTMOV            1
     C                   PARM      '*IDXNAM'     MOVMAP           10
     C                   PARM      *BLANKS       MOVOMN           10
     C                   PARM      LDXNAM        MOVBCH           10
     C                   PARM                    SEQ90
     C                   PARM      *BLANKS       MOVDOC           10
     C                   PARM                    MOVNBT           10
     C                   PARM                    MOVNSQ            9 0
     C                   PARM                    MOVKEY            1
     C                   PARM                    MOVRTN            7
     C                   PARM                    MOVRTD          128

     C                   MOVEL     MOVRTN        MSGID
     C                   MOVEL     MOVRTD        MSGDTA

     C                   MOVE      '1'           INDUPD                         REFRESH
     C                   MOVE      '1'           MOVOPN            1            UPDAT OPEN

     C                   ENDIF

     C                   ELSE
     C                   MOVE      'ERR1812'     MSGID                          LNK IS OFFL
     C                   ENDIF

     C     MSGID         IFNE      *BLANKS
     C                   EXSR      SNDMSG
     C                   ENDIF

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @TRACK        BEGSR
      *          14=TRACK

     C     LXSEQ$        CAT       LDXNAM:1      WVOBJ
     C                   CALL      'MAG8017'                            50
     C                   PARM      '*SPYLINK'    WVOTYP           10            TYPE
     C                   PARM                    WVOBJ            20            OBJECT NAME
     C                   PARM                    WVPTH           100            OBJECT PATH
     C                   PARM                    WVRTN            10            RETRN CDE

     C                   MOVE      '1'           TRKOPN            1            TRACK OPEN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF5          BEGSR
      *          F5=Refresh

     C     TOPRCD        IFNE      0                                            1st line
     C     TOPRCD        CHAIN     SUBFL1                             50
     C                   MOVEL(P)  LXIV1         LLIV1
     C                   MOVEL(P)  LXIV2         LLIV2
     C                   MOVEL(P)  LXIV3         LLIV3
     C                   MOVEL(P)  LXIV4         LLIV4
     C                   MOVEL(P)  LXIV5         LLIV5
     C                   MOVEL(P)  LXIV6         LLIV6
     C                   MOVEL(P)  LXIV7         LLIV7
     C                   MOVEL(P)  LXIV8         LLIV8
     C                   MOVEL     LDXNAM        LLNAM
     C                   MOVEL     LXSEQ$        LLSEQ

     C                   ELSE
     C                   MOVEL(P)  LTIV1         LLIV1
     C                   MOVEL(P)  LTIV2         LLIV2
     C                   MOVEL(P)  LTIV3         LLIV3
     C                   MOVEL(P)  LTIV4         LLIV4
     C                   MOVEL(P)  LTIV5         LLIV5
     C                   MOVEL(P)  LTIV6         LLIV6
     C                   MOVEL(P)  LTIV7         LLIV7
     C                   MOVEL(P)  LTIV8         LLIV8
     C                   MOVEL     LTNAM         LLNAM
     C                   MOVEL     LTSEQ         LLSEQ
     C                   ENDIF

     C                   MOVE      LLIV8         LLIV9
     C                   EXSR      @SETLL
     C                   CLEAR                   LLIV9
     C                   MOVE      *BLANK        DIRECT
     C                   EXSR      @REDGT
      * No record, try previous from bottom
     C     #HITS         IFEQ      0
     C     QUERY         ANDNE     '1'
     C                   MOVE      LLIV8         LLIV9
     C                   CLEAR                   LLIV9
     C                   MOVE      *BLANK        DIRECT
     C                   EXSR      @REDLT
     C                   ENDIF
      *  Still no record, display no record found
     C     #HITS         IFEQ      0
     C                   MOVE      *OFF          *IN42                          SFLDSP
     C                   ELSE
     C                   EXSR      @LOAD
     C                   ENDIF

     C                   MOVE      ' '           LCKPRV

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ACTFIL        BEGSR

     C     *INU1         IFEQ      *ON                                          CHECK JOB
     C     *INU2         ANDEQ     *OFF                                         SWITCHES
     C     *INU3         ANDEQ     *OFF                                         '10011001'
     C     *INU4         ANDEQ     *ON                                          ACTFIL
     C     *INU5         ANDEQ     *ON                                          ATTACH PGM
     C     *INU6         ANDEQ     *OFF                                         IS REQ
     C     *INU7         ANDEQ     *OFF
     C     *INU8         ANDEQ     *ON
     C                   CALL      'MAG8009'                            50      RCV ACT PRO
/7675C                   PARM                    ACTPRO                         PROC NBR.
     C                   PARM      ' '           ACTRTN            1            RETURN
     C     ACTRTN        IFEQ      ' '
     C     *IN50         ANDEQ     *OFF
     C                   MOVE      '1'           ACTATT            1            ATTACH OK
     C                   ELSE
     C                   MOVE      ' '           ACTATT            1            NO ATTACH
     C                   ENDIF
     C                   ELSE
     C                   MOVE      ' '           ACTATT            1            NO ATTACH
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     USREXT        BEGSR
      *          9=Call user exit program

     C     KOBJ          IFNE      *BLANKS
     C     KOBJ          ANDNE     '*NONE'
     C     LDXNAM        CHAIN     MRPTDIR7                           50
     C     KLIB          CAT(P)    '/':0         USREX            21
     C                   CAT       KOBJ:0        USREX
     C                   CALL      USREX                                50      UsrExit pgm
     C                   PARM      KFLD1         UEFLD1           10              usr parm
     C                   PARM      FLDR          UEFLDN           10              Folder
     C                   PARM      FLDRLB        UEFLDL           10              Libr
     C                   PARM      FILNAM        UEFNAM           10              Big5
     C                   PARM      JOBNAM        UEJNAM           10                :
     C                   PARM      PGMOPF        UEPNAM           10                :
     C                   PARM      USRNAM        UEUNAM           10                :
     C                   PARM      USRDTA        UEUDAT           10                :
     C                   PARM      LDXNAM        UELDXN           10              Index
     C                   PARM      LXSEQ$        UESEQ             9              Sequence
     C                   PARM      DXIV1         UEIV1            70              Values
     C                   PARM      DXIV2         UEIV2            70
     C                   PARM      DXIV3         UEIV3            70
     C                   PARM      DXIV4         UEIV4            70
     C                   PARM      DXIV5         UEIV5            70
     C                   PARM      DXIV6         UEIV6            70
     C                   PARM      DXIV7         UEIV7            70
     C                   PARM      DXIV8         UEIV8             8
     C                   PARM      LXSPG$        UESPG             9              Start page
     C                   PARM      LXEPG$        UEEPG             9              End page
     C                   PARM      REPLOC        UELOC             1              Location

     C                   WRITE     CMDLIN1                              50
     C                   WRITE     SFLCTL1                              50
     C     SFLRRN        CHAIN     SUBFL1                             5050
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DSPFLT        BEGSR
      *          F4=Display filter

     C                   MOVEA     INDXI1        PRS(1)
     C     IL(1)         ADD       1             IX                5 0
     C                   MOVE      X'20'         PRS(IX)
     C                   MOVEA     PRS(1)        DSPVA1

     C                   MOVEA     INDXI2        PRS(1)
     C     IL(2)         ADD       1             IX                5 0
     C                   MOVE      X'20'         PRS(IX)
     C                   MOVEA     PRS(1)        DSPVA2

     C                   MOVEA     INDXI3        PRS(1)
     C     IL(3)         ADD       1             IX                5 0
     C                   MOVE      X'20'         PRS(IX)
     C                   MOVEA     PRS(1)        DSPVA3

     C                   MOVEA     INDXI4        PRS(1)
     C     IL(4)         ADD       1             IX                5 0
     C                   MOVE      X'20'         PRS(IX)
     C                   MOVEA     PRS(1)        DSPVA4

     C                   MOVEA     INDXI5        PRS(1)
     C     IL(5)         ADD       1             IX                5 0
     C                   MOVE      X'20'         PRS(IX)
     C                   MOVEA     PRS(1)        DSPVA5

     C                   MOVEA     INDXI6        PRS(1)
     C     IL(6)         ADD       1             IX                5 0
     C                   MOVE      X'20'         PRS(IX)
     C                   MOVEA     PRS(1)        DSPVA6

     C                   MOVEA     INDXI7        PRS(1)
     C     IL(7)         ADD       1             IX                5 0
     C                   MOVE      X'20'         PRS(IX)
     C                   MOVEA     PRS(1)        DSPVA7

     C                   CLEAR                   PRS
     C                   MOVEA     INDXI8        PRS(1)
     C                   MOVE      X'20'         PRS(9)
     C                   MOVE      '-'           PRS(10)
     C                   MOVE      X'32'         PRS(11)
/2832C                   MOVEA     INDXI9        PRS(12)
     C                   MOVE      X'20'         PRS(20)
     C                   MOVEA     PRS(1)        DSPVA8

     C                   CLEAR                   PRS

     C     FLTRFM        TAG
     C                   EXFMT     DSPFILT

/1452C     KEY           DOWEQ     HELP
     C                   MOVEL(P)  'DSPFILT'     HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      DSPFILT                                99
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO FLTRFM
/1452C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF14         BEGSR
      *          F14=Full Text search

     C                   MOVE      '1'           FNDF14
     C                   CLEAR                   FIND
     C                   MOVE      'F'           DIRECT
     C                   EXSR      @SELCR                                       Get 1st 10

     C     LNKRTN        DOUEQ     '20'
/3331C     #HITS         ANDEQ     0
     C                   EXSR      @FILN                                        FORMAT RCDS
     C                   DO        10            XX                2 0          Load 10
     C     XX            OCCUR     SFDATA
     C     XX            OCCUR     LXDATA
     C     LDXNAM        IFEQ      *BLANKS                                      NOT VALID
     C                   LEAVE
     C                   END

     C                   MOVEL     LDXNAM        LDXNM1            1
     C     LDXNM1        IFNE      'B'                                          NotSpyImage
     C                   EXSR      @FIND
     C                   ELSE
      *                    "Sorry, cannot search PC Files."
     C                   MOVEL     'ERR0164'     MSGID
     C                   EXSR      SNDMSG
     C                   GOTO      BOTF14
     C                   ENDIF

     C     FNDRTN        CABEQ     F3            BOTF14
     C     FNDRTN        CABEQ     F12           BOTF14
     C                   ENDDO

     C                   EXSR      @REDGT                                       Get more
     C                   ENDDO

     C     BOTF14        TAG
     C                   EXSR      CLSFND
     C                   MOVE      '0'           FNDF14
     C                   EXSR      SRF5                                         Refresh
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSFND        BEGSR
      *          Close search program

     C                   MOVEL(P)  'CLOSEW'      FNDOPC
     C                   CALL      'SPYFND'      PLFIND                 50
     C                   MOVEL(P)  'CLOSEW'      FNDOPC
     C                   CALL      'SPYCSFND'    PLSRCH                 50
     C                   CLEAR                   UNFIND
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRCURS        BEGSR
      *          Get cursor position
     C     CSRLOC        DIV       256           CSRLIN            3 0          Curs-line
     C                   MVR                     CSRPOS            3 0          Curs-pos  e
     C     WINLOC        DIV       256           WINLIN            3 0          Curs-line
     C                   MVR                     WINPOS            3 0          Curs-pos
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF23         BEGSR
      *          F23= MORE OPTIONS
     C                   EXSR      SRCURS

     C                   ADD       1             OT#               3 0
     C     OT#           IFGT      MAXF23
     C                   Z-ADD     1             OT#
     C                   ENDIF

     C     OT#           MULT      2             F30               3 0
     C                   SUB       1             F30
     C                   MOVEL     OT(F30)       TITLE1
     C                   ADD       1             F30
     C                   MOVEL     OT(F30)       TITLE2

     C                   MOVE      F4            KEY
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF24         BEGSR
      *          F24= More keys
     C                   EXSR      SRCURS

     C                   ADD       1             KEY#              3 0
     C     KEY#          IFGT      MAXF24
     C                   Z-ADD     1             KEY#
     C                   ENDIF

     C                   MOVEL     FKT(KEY#)     FKEY
     C                   WRITE     CMDLIN1

     C                   MOVE      F4            KEY
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     INISPC        BEGSR
      *  Initialize USRSPC that contains the list of documents and the
      *  spylink description for later output to a list of docs exported
      *  This will only be used, if called from EXPOBJSPY.

     C                   MOVEL     RTYPID        SPCOBJ
     C                   MOVEL     XVAL1         SPV(1)
     C                   MOVEL     XVAL2         SPV(2)
     C                   MOVEL     XVAL3         SPV(3)
     C                   MOVEL     XVAL4         SPV(4)
     C                   MOVEL     XVAL5         SPV(5)
     C                   MOVEL     XVAL6         SPV(6)
     C                   MOVEL     XVAL7         SPV(7)
     C                   MOVEL     XVAL8         SPCFRM
     C                   MOVEL     XVAL9         SPCTO
     C                   MOVEA     ETXT          SPCPTH

     C                   MOVEL(P)  'INIT'        SPCOPC
     C                   CALL      SPYSPC        PLSPC                  50

     C                   MOVE      *ON           SPCOPN            1

     C     PLSPC         PLIST
     C                   PARM                    SPCOPC           10
     C                   PARM                    SPCOBJ           10
     C                   PARM      '*SPYLINK'    SPCTYP           10
     C                   PARM      *BLANKS       SPCSEG           10
     C                   PARM                    SPV
     C                   PARM                    SPCFRM            8
     C                   PARM                    SPCTO             8
     C                   PARM                    SPCFMT           10
/2930C                   PARM                    @CDPAG            5            CODE PAGE
     C                   PARM                    SPCJOI            1
     C                   PARM                    SPCPTH          256
     C                   PARM                    SPCSPY           10
     C                   PARM                    SPCSEQ            9 0
     C                   PARM                    SPCRPL            1
     C                   PARM                    SPCMSG            7
     C                   PARM                    SPCDTA          256
/3393C                   PARM                    @IGBAT            1

     C                   ENDSR

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADDSPC        BEGSR

      *  Add a new document to USRSPC that contains the list of documents and the
      *  spylink description for later output to a list of docs exported
      *  This will only be used, if called from EXPOBJSPY.

     C                   MOVEL     RTYPID        SPCOBJ
     C                   MOVEL     LXIV1         SPV(1)
     C                   MOVEL     LXIV2         SPV(2)
     C                   MOVEL     LXIV3         SPV(3)
     C                   MOVEL     LXIV4         SPV(4)
     C                   MOVEL     LXIV5         SPV(5)
     C                   MOVEL     LXIV6         SPV(6)
     C                   MOVEL     LXIV7         SPV(7)
     C                   MOVEL     LXIV8         SPCFRM
     C                   MOVEL     LXIV8         SPCFRM
     C                   MOVEL     LXIV8         SPCFRM
     C                   MOVEA     @TXT          SPCPTH
     C                   MOVEL     LDXNAM        SPCSPY
     C                   MOVEL     LXSEQ$        SPCSEQ

     C                   MOVEL(P)  'ADDDOC'      SPCOPC
     C                   CALL      SPYSPC        PLSPC                  50

     C                   MOVE      *ON           SPCOPN            1

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSSPC        BEGSR

     C                   MOVEL(P)  'QUIT'        SPCOPC
     C                   CALL      SPYSPC        PLSPC                  50
     C                   CLEAR                   SPCOPN

     C                   ENDSR
      *================================================================

     C     *LIKE         DEFINE    FILNAM        OPCDE
     C     *LIKE         DEFINE    LOODES        WOODES
     C     *LIKE         DEFINE    LOOPID        WOOPID
     C     *LIKE         DEFINE    LODRV         WODRV
     C     *LIKE         DEFINE    LOVOL         WOVOL
     C     *LIKE         DEFINE    LODIR         WODIR
     C     *LIKE         DEFINE    LOFILI        WOFILE
     C     *LIKE         DEFINE    FILNAM        WFILN
     C     *LIKE         DEFINE    JOBNAM        WJOBN
     C     *LIKE         DEFINE    USRNAM        WUSR
     C     *LIKE         DEFINE    USRDTA        WUDTA
     C     *LIKE         DEFINE    PGMOPF        WPROG

     C     KLBIG5        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C     KEYVAL        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C                   KFLD                    KVAL

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * check for revision control lock
/3765p ChkRCLock       b
     d                 pi            10i 0
     d BatNum                        10    const
     d StrPage                        9s 0 const
     d LockUser                      10

     d BatNumLast      s             10    static
     d BatNumOK        s              1    static
     d RptTypLast      s             10    static

     d ldRevID         s             10i 0
     d ldContID        ds            20                                         Content ID
     d  ldBatNum                     10                                         Batch number
     d  ldBatRRN                      9  0                                      Batch RRN

     c                   eval      LockUser = *blanks
     c                   if        %subst(BatNum:1:1) <> 'B'
     c                   return    OK
     c                   end
      * check batch
     c                   if        BatNumLast <> BatNum
     c                               or idbnum = *blanks
     c                   eval      BatNumLast =  BatNum
     c                   if        not %open(MIMGDIR)
     c                   open      MIMGDIR
     c                   end
     c     BatNum        CHAIN     MIMGDIR
     c                   eval      BatNumOK = %found
     c                   end
     c                   if        BatNumOK = *off
     c                   return    FAIL
     c                   end
      * check Revision Control
     c                   if        RptTypLast <> idRTyp
     c                               or idRTyp = *blanks
     c                   eval      RptTypLast =  idRTyp
     c                   if        OK <> RtvDMSFlgs(idRTyp:
     c                                   LckSupport:AnnoSupport:BranchSupport)
     c                   return    FAIL
     c                   end
     c                   end
     c                   if        LckSupport = Sv_NotAllowed
     c                   return    OK
     c                   end
      * get/check revision info
     c                   eval      ldBatNum = BatNum                            Batch number
     c                   eval      ldBatRRN = StrPage                           Batch RRN
     c                   eval      ldRevID = GetLRevBy_ConID(ldContID)          find RevID
     c                   if        ldRevID <> 0
     c                   if        OK <> GetRevSts(ldRevID:RevStatus)           get status
     c                   return    FAIL
     c                   end
     c                   if        Rs_LockSts = Lt_Exclusive
     c                   eval      LockUser = Rs_LockUser
     c                   return    FAIL
     c                   end
     c                   end
     c                   return    OK
     p                 e

      **************************************************************************
      * Delete object when called from SPY/DOCAPICMD
J2096p deleteObject    b
     d                 pi            10i 0
     d objectID                      10    value
     d pageOrRRN                      9    options(*nopass)

     d object          ds                  qualified
     d  name                         10
     d   type                         1    overlay(name)
     d  pgOrRRN                       9
     d objectType      s              1
     d dltObjRtn       s             10i 0
     d i               s             10i 0
     d beenHere        s               n   static
     d records         s             10i 0 static
     d deleted         s             10i 0 static
     d errors          s             10i 0 static
J4240d opticalVol      s             12
      /free
       if not beenHere;
         records = 0;
         deleted = 0;
         errors = 0;
         open docApiDlt;
         write header;
         exsr printCriteria;
         write header2;
       endif;
       beenHere = '1';
       if objectID = '*DONE';
         exsr printSummary;
         return OK;
       endif;
       object.name = objectID;
       object.pgOrRRN = pageOrRRN;
       objectType = REPORT;
       if object.type = 'B';
         objectType = IMAGE;
       endif;
J4240  clear opticalVol;
       records += 1;
J7355  select;
J7355  when opcde = '*DELETECHK'; //Report mode only...no delete occurs.
         exsr printReport;
J7355  when opcde = '*DELETE';
         dltObjRtn = dltObj(object:objectType);
J4240    select;
           when dltObjRtn = 0;
             deleted += 1;
J4240      when dltObjRtn = DOE_READONLY;
           other;
J4240        // dltMsgs = rtvMsgs('ERR1337');
J4240        errors += 1;
         endsl;
         exsr printReport;
J7355  when opcde = '*DELETELNK';
J7355    if deleteLinkOnly() <> 0;
J7355      errors += 1;
J7355      //dltMsgs = rtvMsgs('SQL' + %subst(%editc(%abs(sqlcod):'X'):6:4)
           //:sqlerm);
J7355    endif;
J7355    exsr printReport;
J7355  endsl;

       return OK;

       //***********************************************************************
       begsr printReport;
         if *in01 = '1';
           *in01 = '0';
           write header;
           write header2;
         endif;
J4240    //if dltMsgs = *blanks and
J4240    //  not deleteCapable(objectID:objectType:opticalVol);
J4240    //  dltMsgs = rtvMsgs('STG0019':opticalVol);
J4240    //  errors += 1;
J4240    //endif;
         write detail;
J4240    //clear dltMsgs;
       endsr;
       //***********************************************************************
       begsr printCriteria;
         write criteria;
         %subst(critDta:37:5) = '*NONE'; //No criteria selected default.
         for i = 1 to 7;
           if iFilterA(i) <> ' '; //Only print criteria that is non-blank.
             critDta = %trimr(id(i)) + ' = ' + %trimr(iFilterA(i));
             write criteria2;
           endif;
         endfor;
         if lliv8 <> ' '; //From create date.
           critDta = 'From date: ' + lliv8;
           write criteria2;
         endif;
         if lliv9 <> ' '; //To create date.
           critDta = 'To date: ' + lliv9;
           write criteria2;
         endif;
       endsr;
       //***********************************************************************
       begsr printSummary;
         //recordsOut = records;
         //deleteOut = deleted;
         // errorsOut = errors;
         write summary;
         close docApiDlt;
         beenHere = '0';
       endsr;
      /end-free
     p                 e

      **************************************************************************
J4240p rtvMsgs         b
     d                 pi            80
     d msgID                          7    const
     d msgVals                       80    const options(*nopass)

     d mag1033         pr                  extpgm('MAG1033')
     d  action                        1    const
     d  msgFile                      20    const
     d  errorDS                            likeds(errCd)
     d  msgTxt                       80    const

J7355d msgFile         s             20

      /free
       clear errCd;
       @ercon = msgID;
       if %parms = 2;
         @erdta = msgVals;
       endif;
J7355  msgFile = PSCON;
J7355  if %subst(msgID:1:3) = 'SQL';
J7355    msgFile = SQLMSGF;
J7355  endif;
       mag1033(' ':msgFile:errCd:@msgTx);
       return @msgTx;
      /end-free
     p                 e
      **************************************************************************
      * Get actual image sequence number.
J5350p getSeqNum       b
     d                 pi            10i 0
     d batchID                       10
     d imageRRN                      10i 0 const

     d rtn             s             10i 0 inz

     d spycsfil        pr                  extpgm('SPYCSFIL')
     d  PRMWIN                       10    const
     d  PRMBCH                       10
     d  OPCODE                        6    const
     d  SETSEQ                        9
     d  SDT                        7680
     d  RTNREC                        9  0
     d  RTNCS                         2

     d sdt             ds          7680
     d  FlSPY                         3
     d  FlVER                         5    overlay(sdt)
     D  FLIDX#                        3
     D  FLSIZE                        9
     D  FLFILE                       25
     D  FLEXT                         5
     D  FLDAT                         8
     D  FLTIM                         6
     D  FLUDAT                        8
     D  FLUTIM                        6
     D  FLUSR                        10
     D  FLNODE                       17
     D  FLSEQ                         9
     D  FLRRN                         9

     d setseq          s              9    inz(*all'0')
     d rtncs           s              2    inz('00')
     d rtnrec          s              9  0 inz(1)
     d testRRN         s             10i 0

      /FREE
       dou rtncs <> '00';
         spycsfil('*INTERACT ':batchID:'READGT':
             setseq:sdt:rtnrec:rtncs);
         if rtnrec > 0;
           testRRN = %int(flrrn);
           if testRRN = imageRRN;
             rtn = %int(flseq);
             leave;
           endif;
           setseq = flseq;
         endif;
       enddo;

       return rtn;
      /END-FREE

     p                 e
      **************************************************************************
      * View image by way of CoEx URL (Standard or Trusted)
J4796p coExImgView     b
     d                 pi            10i 0

     D rtvNetA         PR                  ExtPgm('QWCRNETA')
     D  RcvVar                      256A   OPTIONS(*VARSIZE)
     D  RcvVarLen                    10I 0 const
     D  NbrNetAtr                    10I 0 const
     D  AttrNames                    10A   const
     D  ErrorCode                          likeds(qusec)
     D netAtr          ds                  qualified
     D  nbrRtn                       10i 0
     D  offset                       10i 0 dim(1)
     d  atrInfo                     256
     d atrInf          ds                  qualified based(atrInfP)
     d  atr                          10
     d  type                          1
     d  infSts                        1
     d  len                          10i 0
     d  data                         50

     d run             pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d sprintf         pr            10i 0 extproc('sprintf')
     d  target                         *   value options(*string)
     d  source                         *   value options(*string)
     d  value1                         *   value options(*string)
     d  value2                         *   value options(*string:*nopass)
     d  value3                         *   value options(*string:*nopass)
     d  value4                         *   value options(*string:*nopass)
     d  value5                         *   value options(*string:*nopass)
     d  value6                         *   value options(*string:*nopass)
     d  value7                         *   value options(*string:*nopass)
     d  value8                         *   value options(*string:*nopass)
     d  value9                         *   value options(*string:*nopass)
     d  value10                        *   value options(*string:*nopass)

     d urlType         s              2
     d i               s             10i 0
     d j               s             10i 0
     d servlet         s             10
     d pcoString       s            150
     d sq              c                   ''''
     d coExRtn         s             10i 0 inz

      /free
       // Retrieve the network attribute system name if specified.
       if CoExSysNam = '*SYSNAME';
         clear qusec;
         QUSBPRV = %size(qusec);
         clear netAtr;
         rtvNetA(netAtr:%size(netAtr):1:'SYSNAME':qusec);
         atrInfP = %addr(netAtr) + netAtr.offset(1);
         CoExSysNam =  %subst(atrInf.data:1:atrInf.len);
       endif;

       // Format the URL for an image.
       if CoExURLIMG = 'Y' and %subst(sdtNam:1:1) = 'B';
         urlType = 'BI';
       else; // Format the URL for report.
         urlType = 'BD';
       endif;

       // Create URL.
       servlet = 'VipDms';
       if trustedURLkey <> ' ' and CoExTrPrf <> ' ';
         servlet = 'TServlet';
       endif;
       sprintf(%addr(coExUrlOut):coExUrlA(1):%trim(CoExSrvNam):
        %trim(servlet):%trim(CoExSysNam):%trimr(rtypid):urlType:
        sdtNam:%trim(%char(%int(SDTSPg))));
       coExUrlOut = %str(%addr(coExUrlOut));

       // Attempt to retrieve trusted URL from CoEx TServlet
       if trustedURLkey <> ' ' and CoExTrPrf <> ' ';
         coExRtn = getTrustedURL(CoExSrvNam:coExUrlOut);
         if coExRtn <> 0;
           return coExRtn;
         endif;
       endif;

       if CoExPCCmd = 'Y'; // Send URL to PC for execution.
         run('STRPCO PCTA(*NO)');
         // Parse URL and format for PCO command processing.
         // Escape the ampersands in the string for PCO.
         i = %scan('&':coExUrlOut);
         dow i > 0;
           coExUrlOut = %replace('^&':coExUrlOut:i:1);
           i += 2;
           i = %scan('&':coExUrlOut:i);
         enddo;
         // Break URL into chunks for PCO. PCO will fail if passed
         // anything over 123 bytes.
         // Redirect chunks into batch file for processing.
         // Scan to beginning of first parameter, send first chunk.
         i = %scan('^':CoExUrlOut);
         pcoString = 'STRPCCMD ' + sq + 'echo set "p1=' +
           %subst(CoExUrlOut:1:i-1) + '"> \docurl.bat' + sq + ' PAUSE(*NO)';
         rc = run(%trimr(pcoString));
         // Get the next chunk. Parameterized portion of URL.
         j = %scan(',':CoExUrlOut);
         if j = 0;
           j = %len(CoExUrlOut);
         endif;
         pcoString = 'STRPCCMD ' + sq + 'echo set "p2=' +
           %trimr(%subst(CoExUrlOut:i:j-i)) + '" >> \docurl.bat' + sq +
           ' PAUSE(*NO)';
         rc = run(%trimr(pcoString));
         // Get the last chunk. Remaining portion of URL containing key.
         pcoString = 'STRPCCMD ' + sq + 'echo set "p3=' +
           %trimr(%subst(CoExUrlOut:j)) + '" >> \docurl.bat' + sq +
           ' PAUSE(*NO)';
         rc = run(%trimr(pcoString));
         // Send start command.
         pcoString = 'STRPCCMD ' +
           sq + 'echo start %p1%%p2%%p3% >> \docurl.bat' + sq + ' PAUSE(*NO)';
         // Run remote batch file.
         rc = run(%trimr(pcoString));
         pcoString = 'STRPCCMD ' + sq + '\docurl.bat' + sq + ' PAUSE(*NO)';
         rc = run(%trimr(pcoString));
       else;
         // Display clickable URL.
         exfmt coExDspURL;
       endif;

       return coExRtn;

      /end-free
     p                 e

      **************************************************************************
J4796p getTrustedURL   b
     d                 pi            10i 0
     d  hostNameIn                     *   const options(*string:*trim)
     d  ioURL                       500

      /copy @socket

     d getCodePage     pr                  extpgm('SPYCDPAG')
     d  fromCCSID                     5    const
     d  toCCSID                       5    const
     d  frTable                     256
     d  toTable                     256
     d frTable         s            256
     d toTable         s            256

     d write           PR            10i 0 extproc('write')
     d  fildes                       10i 0 value
     d  buf                            *   value
     d  nbyte                        10u 0 value

     d read            pr            10i 0 extproc('read')
     d  fildes                       10i 0 value
     d  buf                            *   value
     d  nbyte                        10u 0 value

     d fclose          pr            10i 0 extproc('close')
     d  fildes                       10i 0

     d iobuff          s            512    inz
     d tSocket         s             10i 0 inz
     d hostName        s             40    inz
     d ptrVal          S           1024a   based(ptrValP)
     d ptrToPtr        DS                  based(ptrToPtrP)
     d  derefPtr                       *
     d rc              s             10i 0 inz
     d ERROR           c                   -1
     d pos             s             10i 0 inz

      /free

       // Set up socket definition.
       sin_family = AF_INET;
       sin_port = 80; // Default port.
       // Use the port number on the end of the URL input string if passed.
       pos = %scan(':':%str(hostNameIn));
       if pos > 0;
         sin_port = %int(%subst(%str(hostNameIn):pos+1));
         hostName = %subst(%str(hostNameIn):1:pos-1);
       else;
         hostName = %str(hostNameIn);
       endif;
       // Try to get host by name.
       hostName = %trimr(hostName) + x'00';
       p_hostent = getHstByNm(%addr(hostName));
       if p_hostent <> *NULL;
         ptrToPtrP = h_addrlist;
         ptrValP = derefPtr;
         sin_addr = %subst(ptrVal:1:4);
       else;
         // Try to get host by address.
         s_addr = inet_addr(hostName);
       endif;
       if s_addr = 0 or s_addr = INADR_BRDC or s_addr = INADR_LOOP;
         rc = ERROR;
         exsr quitSR;
       endif;
       sin_zero = *allx'00';

       tSocket = socket(AF_INET:SOCK_STRM:IPPRO_IP);
       if tSocket < 0;
         rc = ERROR;
         exsr quitSR;
       endif;

       if connect(tSocket:sockadr_in:%size(sockadr_in)) < 0;
         rc = ERROR;
         msgid = 'EML0037';
         msgdta = CoExSrvNam;
         exsr quitSR;
       endif;

       // Prepend GET for HTTP protocol and add trusted user to URL.
       iobuff = 'GET ' + %trimr(ioUrl) + '&TU=' + %trimr(CoexTrPrf) + '&R=1';

       // Get code page and translate URL from ebcdic to 819;
       getCodePage('00000':'00819':frTable:toTable);
       iobuff = %xlate(frTable:toTable:iobuff);
       iobuff = %trimr(iobuff:x'20') + x'0d0a0d0a';

       // Write standard URL to servlet.
       if write(tSocket:%addr(iobuff):%len(%trimr(iobuff))) < 0;
         rc = ERROR;
         exsr quitSR;
       endif;

       // Receive trusted URL from servlet.
       clear iobuff;
       if read(tSocket:%addr(iobuff):%size(iobuff)) <= 0;
         rc = ERROR;
         exsr quitSR;
       endif;

       // Translate the response back to ebcdic.
       iobuff = %xlate(toTable:frTable:iobuff);

       // If the first characters returned are not http:, error occurred.
       if %subst(iobuff:1:5) <> 'http:' and %subst(iobuff:1:5) <> 'HTTP:';
         msgid = 'API1001';
         msgdta = %trimr(iobuff:x'7c');
         rc = ERROR;
         exsr quitSR;
       endif;

       // Trim up the returned trusted URL and return;
       ioURL = %trimr(iobuff:x'7c');

       exsr quitSR;

       //********************************************************************
       begsr quitSR;

         fclose(tSocket);

         return rc;

       endsr;

      /end-free
     p                 e

      **************************************************************************
J7355p deleteLinkOnly  b
     d                 pi            10i 0
     d sqlStmt         s           1024
     d whereClause     s           1024    inz
     d i               s             10i 0
      /free
       clear whereClause;
       sqlStmt = 'delete from ' + lnkfil;
       for i = 1 to %elem(iFilterA);
         if iFilterA(i) <> ' ';
           if whereClause <> ' ';
             whereClause = %trimr(whereClause) + ' and';
           endif;
           whereClause = %trimr(whereClause) + ' trim(' + 'lxiv' +
             %trim(%char(i)) + ') = ' + sq + %trim(iFilterA(i)) + sq;
         endif;
       endfor;
       // Do not delete anything if no criteria is specified...
       // don't want to inadvertently delete everything. Edits are
       // in the commands to prevent but just to be extra careful.
       if whereClause <> ' ';
         sqlStmt = %trimr(sqlStmt) + ' where ' + %trim(whereClause);
         exec sql execute immediate :sqlStmt;
         if sqlcod <> 0;
           return -1;
         endif;
       endif;
       return 0;
      /end-free
     p                 e
**ctdata ERR
ERR1191  1 No Reports exist to be displayed.
ERR1243  2 Insufficient authority.
ERR1359  3 Invalid Option entered.
ERR1360  4 RVI Imaging programs are not found on libr
DSP1141  5 F4=Opt Link  F5=Dasd Link
DSP1142  6 Optical
DSP1143  7 DASD
OPT0002  8 Can't open requested file.
P002116  9 Document images linked for display.
P002121 10 This Workstation cannot display images
P002130 11 Document images linked for printing
P030223 12 Report linked for display.
ERR4114 13 One or more key elements longer than maximum (70.)
P051063 14 Maximum record limit reached.
ERR4115 15 OmniLink. Cannot delete.
ERR4116 16 Cannot use repeat option for Start Case.
**ctdata coExUrlA
http://%s/contentexplorer/servlet/%s?DN=%s&NAME=%s&TYPE=%s&B=%s&S=%s

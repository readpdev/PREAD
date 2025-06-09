      *%METADATA                                                       *
      * %TEXT Client Server Manager                                    *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR':'MYBNDDIR') actgrp('DOCMGR')
      ********----------------------------
      * SPYCS  Client/Server Host Director
      ********----------------------------
      *
T6053 * 02-07-07 PLR Allow for print authority checking for client software.
T5375 * 05-22-06 PLR Image requests were failing via workflow on german
/     *              systems. This was a translation error for the literal 'at-s
/     *              character. Added additional checking for the hex value.
T4951 * 11-23-05 PLR Add license call for DOCMGRAPI runmode.
/4934 * 11-17-05 PLR CoEx critical annotation buttons unavailable because
      *              the code and structure for GTAUT response were incomplete.
T4730 * 09-30-05 PLR Discovered solution to #9154. Was able to extend the
/     *              malloc() function into teraspace within the LIBTIFF
/     *              service program by adding compile time options to
/     *              modules AS400IO & IOMGR.
/9804 * 04-15-05 PLR Sticky note text disappearing when applied via CoEx & RevCt
/     *              Was not receiving batch number from VCO. Compromised
/     *              by resolving batch from RevID.
/6938 * 03-11-05 PLR Add security for revision control.
/9542 * 03-09-05 PLR Overload GTAUT operation to return report authority flags.
/9346 * 12-29-04 PLR Requirements for folder/folderLib when host printing.
/9325 * 11-23-04 PLR When using the NT file export application, server was
/     *              returning an 'All file handles in use' error because
/     *              the GetDocAttr() procedure does not clean up it's file
/     *              handles. Added a call to close the file handle.
/9154 * 07-19-04 PLR Check max size if tiff image. 16M malloc/usrspc size limit
/     *              in LIBTIFF service program. Not able to change to use
/     *              teraspace due to possible pointer implications and time
/     *              constraints.
/7747 * 07-09-04 PLR Unable to update Overlay margin when changing settings
/     *              in VIP ImageLink Plus.
/5733 * 04-29-04 GT  Change AUTHOR routine to use aut flag sent by client
/     *                (was hard coded to opt 10)
/8273 * 04-13-04 GT  Clear RRSDT buffer in COMMND.  Was causing SpyWeb
/     *              API to generate bogus SpyLink hits on a bad query
/     *              because of previous response data in RRSDT.
/5635 * 02-18-04 PLR Audit logging.
/6708 * 10-14-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte bina
/8180 * 08-01-03 PLR Add compatiblity for VCO changes/additions.
/8278 * 07-08-03 PLR Needed to modify the return value in DMUSR (DMS)
/     *              conversation to force the return of the 'W04 END OF
/     *              FILE REACHED' message instead of just a 'K' and an
/     *              empty buffer. Modified for consistency to match
/     *              what occurs between VCO and NT product.
/8179 * 04-04-03 JMO Added Host Email functionality
/7621 * 01-13-03 PLR On LSTNT opcode and large enough request of notes to
/     *              more than fill buffer, the application will hang.
/     *              This was caused by on the continuation opcode and the
/     *              opcode not being checked again. The continuation was
/     *              treated as if it was report data.
/4569 * 05-08-02 GT  Fix INIT/QUIT logic in procedures LnkHitList and
      *               OmniHitList
/6576 * 05-02-02 GT  Handle SPYCSLCRI returning warning for bad doc class
/6356 * 04-12-02 PLR Error msg when retrieving VCO revision data.
/6391 * 03-22-02 RA  Correct blank page in Spyweb - PDF
/5921 * 01-25-02 KAC Revise distribution Spylinks support
/5999 * 01-16-02 KAC Add Ascending/Descending Order flag to DocView
/5972 * 01-11-02 KAC VCO Revision list function.
/3667 * 11-15-01 KAC Add receive callback for single socket processing.
/4537 * 10-29-01 KAC Revise for VCO phase II functions.
/5235 * 10-15-01 KAC Revise CS Segment notes.
/5542 * 10-01-01 PLR Make sure licensing for Image Viewer Plus is made seperatel
/     *              from Spy/CS. Was previously taking a license hit from both.
/4537 * 08-15-01 KAC Add VCO phase II functions.
/4900 * 07-11-01 PLR Move logic of 4835 to SPYCSNOT. Was causing buffer
      *              syncronization problems.
/4835 * 06-19-01 PLR Prevent annotation functions to previous revisions.
/3765 * 06-11-01 KAC Add Omnilink Revid parm for OL Rev list processing.
/3765 * 06-11-01 DLS Adjust to send proper WIP/ or REVid to SPYCSNOT
/4419 * 05-22-01 PLR Incorrect report type logged to RDSTLOG via SPYWEB.
/3629 * 05-17-01 KAC Adjust callback buffer size based on version.
/4203 * 03-14-01 RA  Correct MAG1060 parameter call.
/3765 * 03-04-01 KAC Add document revision support.
/4103 * 03-01-01 PLR Authorization warning message had wrong message code. Cause
/3890 * 01-25-00 GT  Remove SPYCS data queue entry on termination.
/3889 * 01-25-00 PLR Was not checking key code on startup.
/3679 * 01-03-01 KAC Add VCO support report type rather Big5 key.
/813c * 12-12-00 KAC Fix Notes deletion authority code/message
/3340 * 11-21-00 KAC Add a new SpyLinks opcode RDREV (read reverse)
/813b * 11-16-00 KAC Fix Notes return code
/2550 * 10-13-00 KAC Call new PCL sub-pgm (uses callback function)
/2107 * 10-12-00 KAC Add support CS Distribution Spylinks
/1497 * 09-13-00 PLR PRODUCT AUTHORIZATION ENHANCEMENT.
/2924 *  8-16-00 KAC Switch to NT's "Big Key Patch" conversation.
/813  *  7-26-00 KAC USE REVISED NOTES INTERFACE
/2815 * 07-08-00 KAC Add SCS to PDF conversion
/2492 * 06-08-00 KAC Correct original 2292HQ enh. @OPCOD not
      *              being set correctly.
/2149 * 05-31-00 GT  Correct original 2149HQ fix. LNKPG flag not
      *              always being reset correctly.
/2492 * 05-16-00 GT  Fix RTNFRM field length (was 8, s/b 10)
/2492 * 04-07-00 FID OVERLAY SUPPORT FOR SPYPGRTV
/2319 * 12-14-99 KAC PASS "INIT" TO SPYCSLNK
/2306 * 12-08-99 JJF Call Mag901 for activity logging
/2272 * 12-03-99 DM  Change spypgrtv rrn to 9 bytes numeric
      * 11-23-99 KAC RETURN ATTRIBUTE DATA ON READC.                  1990HQ
      * 11-08-99 GT  Changed FMTIVAL index value parm length to 99    2189HQ
      * 11-01-99 KAC ADDED WEB PARMS TO SPYCSFLD                      2153HQ
      * 10-27-99 KAC ALWAYS CALL SPYWBFLT FOR SELCR opcode            2153HQ
      * 10-21-99 GT  Only call SPYWBFLT for SELCR opcode              2213HQ
      * 10-11-99 KAC BUG READING PAGES > 240 LINES VIA SPYLINKS.      2149HQ
      *  9-08-99 GT  Add new PCL opcodes to continuation check in CALPCL
      *  8-04-99 FID ADDED NEW FIELD TO KEY STRUC WHEN REQUESTING REPORTS OVERLA
      *  6-21-99 GT  Add run mode parm to *ENTRY plist
      *  6-18-98 KAC ENABLE NEW SINGLE MEMBER REPORT INDEX FILES
      *  6-04-99 GT  Correct page range mapping for SPYAFRTV
      *  5-17-99 DM  Remove the changing library list stuff
      *  4-03-99 GT  Call SPYCHGRP to change run priority
      *  3-31-98 KAC RESTORE OLD NOTES INTERFACE
      *  3-22-99 JJF Call Mag901w to log Web user on and off
      *  3-18-99 KAC ADD CALL TO SPYPLRTV
      *  3-30-99 FID ADD Query opcodes for spylinks/omnilinks
      *  2-24-99 KAC ADD ANNOTATION TEMPLATE INTERFACE
      *  2-06-99 FID Added SPYCSRPTN, SPYCSBCHN, SPYCSTYP
      *  1-22-99 JJF Add continue read for long distribution pages
      * 12-22-98 KAC USE REVISED NOTES INTERFACE
      * 12-09-98 KAC CHANGE SPYCSLNK PARM LIST INCLUDE MSG ID & DATA
      * 12-01-98 FID Add continue read for long reports
      * 11-24-98 KAC ADD NOTES FLAG FOR AFP REPORTS.
      * 11-18-98 GT  Get multiple SpyLink and OmniLink criteria specs
      *              on one request. Wake up OmniServer (subr WAKOMN).
      * 11-17-98 GT  Call MAG8090 to get date format for SYSENV function.
      *  9-11-98 GT  Disable key code checking if web access
      *  3-10-98 KAC APPEND RETURN CODE FOR SPYPGRTV ERRORS
      *  3-06-98 GT  View entire report if segment *ALL is requested.
      *  2-27-98 KAC ADD SUPPORT FOR IMAGEVIEW TYPE REPORTS
      *  2-26-98 GT  Change ENDJOB cmd to call to SPYENDJB
      *  2-05-98 KAC ADD SUPPORT FOR R/DARS TYPE REPORTS
      *  1-26-98 GT  Changed SPY number location to KEY,66 in PRTRPT
      *  8-26-97 GT  Added page range to AFP retrieval
      *  7-25-97 GT  Added AFP retrieval routines and changed RTVPAG
      *              to use the opcode passed from the client.
      *  5-09-97 GK  Added SpyCsOLnk.
      *  4-08-97 GK  Pass MsgID and MsgDta from called pgm to caller
      *  2-25-97 GK  Take out ICF file and replace with Buffer parm.
      * 11-25-96 JJF Add opcode-file READ-SYSDFT to give client SYSDFT
      * 10-07-96 JJF Add dist page table name (DSTTBL) parm for Mag801
      *  8-15-96 GK  Add Note Annotations & new SpyCs test method
      *  4-15-96 JJF Clear liblist & add QSYS2. Add trace function
      *  2-15-96 DM  New program
      *
      *  Bytes   Field
      *  -----   ------
      *   1- 10  File   File to retrieve records
      *  11- 20  Libr   Libr where file is found
      *  21-120  Key    Key from which to start reading records
      * 121-125  OpCode Read,Readp,Page,Print,Info,Selcr
      * 126-134  Page   Read Records starting at PG
      *
      * API's for FOLDERS
      * -----------------
      * Get a page of a report (data)
      * -----------------------------
      *  Bytes   Field
      *  -----   ------
      *   1- 10  File   Folder to retrieve records
      *  11- 20  Libr   Libr where folder is found
      *  21-120  Key    MRPTDIR key of Report
      * 121-125  OpCode Page
      * 126-134  Page   Read Records starting at PG number
      * 135-1034 Xbfr   empty
      *
      *
      * API's for MRPTDIR and MFLDDIR
      * -----------------------------
      *
      * Get a list of Folder or a list of Reports within a folder
      * ---------------------------------------------------------
      *  Bytes   Field
      *  -----   ------
      *   1- 10  File   File to retrieve records MRPTDIR/MFLDDIR
      *  11- 20  Libr   Libr where file is found (SPYDATA)
      *  21-120  Key    Key from which to start reading records
      * 121-125  OpCode Read,Readp
      * 126-134  Page   empty
      * 135-1034 Xbfr   empty
      *
      *
      * API's for SPYLINKS
      * ------------------
      *
      * Get a list of Report Types that have SpyLinks
      * ---------------------------------------------
      *  Bytes   Field
      *  -----   -----
      *   1- 10  File   File to retrieve records RLNKDEF
      *  11- 20  Libr   Libr where file is found (SPYDATA)
      *  21-120  Key    Key from which to start reading records
      * 121-125  OpCode Read,Readp
      * 126-134  Page   empty
      * 135-1034 Xbfr   empty
      *
      *
      * Retrieve Data Field definitions that make up a SpyLink
      * ------------------------------------------------------
      *  Bytes   Field
      *  -----   -----
      *   1- 10  File   File to retrieve records RLNKDEF
      *  11- 20  Libr   Libr where file is found (SPYDATA)
      *  21-120  Key    RMAINT key that has SpyLink
      * 121-125  OpCode Info
      * 126-134  Page   empty
      * 135-1034 Xbfr   empty
      *
      *
      * Retrieve SpyLink data recs associated to given filter request
      * -------------------------------------------------------------
      *  Bytes   Field
      *  -----   -----
      *   1- 10  File   File to retrieve records @000000* file
      *  11- 20  Libr   Libr where file is found (SPYDATA)
      *  21-120  Key    RMAINT key that has SpyLink
      * 121-125  OpCode Selcr / Rdgt / Clear
      * 126-134  Page   empty
      * 135-1034 Xbfr   Extra Buffer as described
      *                        - filter index values 1-7
      *                        - filter index value 8  from date
      *                        - filter index value 9  to date
      *                        - Spy Version ID     >>>>> __________
      *                        - SpyLink sequence number    |
      *                        - Starting Page of SpyLink   |
      *                        - Ending Page of SpyLink     | empty
      *                        - Read flag                  |
      *                        - Delete flag                |
      *                        - Print flag               __+_______
      *
      *
      * Retrieve SpyLink Report pages (viewer data)
      * -------------------------------------------------------------
      *  Bytes   Field
      *  -----   -----
      *   1- 10  File   File to retrieve records @000000* file
      *  11- 20  Libr   Libr where file is found (SPYDATA)
      *  21-120  Key    RMAINT key that has SpyLink
      *                        - "SPYLINK"
      *                        - Spy Version ID
      *                        - start page
      *                        - end page
      * 121-125  OpCode READ
      * 126-134  Page   empty
      * 135-1034 Xbfr   empty
      *
      * API's for PRINTING
      * ------------------
      *
      * Prints Reports (pages) from folders
      * ------------------------------------------------------
      *  Bytes   Field
      *  -----   -----
      *   1- 10  File   Folder of the report
      *  11- 20  Libr   Libr where folder is found (SPYDATA)
      *  21-120  Key    MRPTDIR of the report in the folder
      * 121-125  OpCode Print
      * 126-134  Page   empty
      * 135-1034 Xbfr   Extra Buffer is as follows:
      *                        - From Page #
      *                        - To Page #
      *                        - SpyPrinter Name
      *                        - Output Queue
      *                        - Output Queue Library
      *                        - Printer File
      *                        - Printer File Library
      *                        - Submit as Background job
/8179 * API's for EMAIL
/8179 * ------------------
/8179 *
/8179 * Emails Reports from folders or Spylinks
/8179 * ------------------------------------------------------
/8179 *  Bytes   Field
/8179 *  -----   -----
/8179 *   1- 10  File   Folder of the report
/8179 *  11- 20  Libr   Libr where folder is found (SPYDATA)
/8179 *  21-120  Key    MRPTDIR of the report in the folder
/8179 * 121-125  OpCode EMAIL
/8179 * 126-134  Page   empty
/8179 * 135-1034 Xbfr   Extra Buffer is as follows:
/8179 *---------------------------------------------
/8179 * 135-144                - From Page #
/8179 * 145-154                - To Page #
/8179 * 155-159                - Structure version#
/8179 * 160-160                - Submit job? (Y/N)
/8179 * 161-170                - Email format (*TXT)
/8179 * 171-290                - From email address
/8179 * 291-350                - Subject text
/8179 * 351-675                - Email text (5x65)
/8179 * 676-795                - Destination email address
      *
      *
      *----------------------------------------------------------------
      *To set debug interactive debug:
      * AS400 src    1) Change the constant SETDBG field to a "Y".
      * AS400 cmd    2) Recompile the program.
      * PC windows   3) Start SpyCS from Windows.
      * AS400 cmd    4) On an As400 session start interactive debug SI
      *                 on the program NOOP in QGPL with *SELECT
      *                 and pick the SPYCS ICF job thats in a message
      *                 wait state.
      * AS400 cmd    5) Run the program UNFRZJOB.
      * AS400 SI     6) When the Interactive debug screen is displayed
      * Dbg pop_up #5   on the As400 session add the program SPYCS to
      *    #5           the list of programs being debuged.
      * AS400 SI     7) Change over to the SPYCS program source after
      * Dbg pop_up #5   you have added it and set break points.
      * AS400 SI     8) Then hit Function 17 to run to the next break
      *                 point.
      *
      * PRODUCT AUTHORIZATION PROTOTYPE.
      /COPY @MFSPYAUTR

      /copy @MGMEMMGRR
      /copy @MMDMSSRVR
      /copy @MMDOCFNCR
/5921 /COPY @MMRPTDSTR
      /copy 'UTIL/@timer.rpgleinc'

      * function return codes
     d OK              c                   1
     d FAIL            c                   0
     d rc              s             10i 0

      * parameter for MAG801
/6708d @filn#b         s              9b 0

     d RevID           s             10i 0
     d HeadRevID       s             10i 0
     d WipRevID        s             10i 0

/5921d DistPage        s             10i 0

      * spylinks report page request ("x" buffer portion)
/5921d LnkPgRqstDS     ds
/    d LnkVal                        70    dim(7)
/    d LnkRepLoc             618    618
/    d LnkRStrPgA            634    642
/    d LnkRStrPg                      9  0 overlay(LnkRStrPgA)
/    d LnkREndPgA            643    651
/    d LnkREndPg                      9  0 overlay(LnkREndPgA)

/813cD MSGE            S              7    DIM(9) CTDATA PERRCD(1)
     D DTS             S            256    DIM(240)
     D WTS             S            256    DIM(240)
     D @I              S              1    DIM(8)
     D AUT             S              1    DIM(25)

      * Query selection parms
     D AO              S              3    DIM(25)
     D FN              S             10    DIM(25)
     D TE              S              5    DIM(25)
     D QV              S             30    DIM(25)
     D QVF             S             30    DIM(25)

     d XBFR            ds          1000
/8179d  xbf_fpg                       9
/8179d  xbf_tpg                       9
/8179d  xbf_vers                      5
/8179d  xbf_sbmjb                     1
/8179d  xbf_fmt                      10
/8179d  xbf_frmeml                  120
/8179d  xbf_subj                     60
/8179d  xbf_msgtxt                  325
/8179d  xbf_dsteml                  120
/8179
     d BF              s              1    dim(%size(XBFR))

/2924d SDTds           ds          8100
     d SDT                            1    dim(%size(SDTds))

      * Criteria selection (up to 9)
/2924d LinkLst         s             55    dim(9)
/2924d OmniLst         s             10    dim(9)

/3679d TableFile       s              1

     D JOB#            DS
     D  @JOBNA                 1     10
     D  @USRNA                11     20
     D  @JOBNU                21     26

     d  APILEN         s             10i 0
     d  @MSGWT         s             10i 0

     D PSCON           C                   CONST('PSCON     *LIBL     ')

     D ERRCD           DS
     D  @ERLEN                 1      4i 0 inz(%size(ERRCD))
     D  @ERCON                 9     15
     D  @ERDTA                17    116

     D                SDS
      *             PROGRAM STATUS
     D  PGMERR           *STATUS
     D  WQPGMN                 1     10
     D  PGMLIN                21     28
     d  @PARMS                37     39  0
     D  SYSERR                40     46
     D  WQLIBN                81     90
     D  PGMUSR               254    263

     D SYSDFT          DS          1024    dtaara
     D  EXTSEC               137    137
     D  SDATFM               224    226
/2306D  SDLOGT               414    414
     D  LDEBUG               454    454
     D  SCSPTY               524    525
     D  LOGWEB               791    791
/8179D  SplMail              868    868
/8179D  SplMailLib           869    878
     D                 DS
     D  OUTQ#                  1     20
     D  OUTQ1                  1      1
     D  OUTQ                   1     10
     D  OUTQL                 11     20
     D                 DS
     D  @YMD                   1      8  0
     D  @SYSD8                15     22  0
     D  @CKACC                23     38
     D  @O                    23     38  0 DIM(8)
     D  @X                    39     39  0
     D  @Z                    40     42  0
     D  @SDATE                43     50  0
     D  @SDATC                43     50
     D  @ACESS                51     66
     D  @TFACT                67     74  0
     D  @TMP2                 75     76  0
     D                 DS                  INZ
     D  QSNDR                  1     44
     D  QBTRTN                 1      4P 0
     D  QBTAVL                 5      8P 0
     D  QJNAM                  9     18
     D  QUSER                 19     28
     D  QJ#                   29     34
     D  QCUSRP                35     44

      * request "key" data
     d SKEY            ds
     d  SKEY1                        10
     d  SKEY2                        10
     d  SKEY3                        10
     d  SKEY4                        65
/3765d  sMajMinVer                    5
     d KEY                     1    100    dim(100)

      *--------------------------------------------
      * Query Filter (stays in memory until reset)
     D QRYAO           S             60    INZ
     D QRYFN           S            200    INZ
     D QRYTE           S            100    INZ
     D QRYVL           S            600    INZ
      *--------------------------------------------

     D #SPYMF          C                   CONST('Q         QGPL      ')
     D #SPYM9          C                   CONST('Q9        QGPL      ')
     D DBGPGM          C                   CONST('QGPL/NOOP')
     D @ATM            C                   CONST('*ATEMPLATE')
     D @PCL            C                   CONST('*PCL5')
/2815d @PDF            c                   '*PDF'

/8179d LDA            uds                  dtaara(*LDA)
/8179d  mlind                  1     40
/8179d  mlfrm                 41    160
/8179d  mlfrm6                41    100
/8179d  mlsubj               161    220
/8179d  mltxta               221    545
/8179d  mltxt1               221    285
/8179d  mltxt2               286    350
/8179d  mltxt3               351    415
/8179d  mltxt4               416    480
/8179d  mltxt5               481    545
/8179d  mltype               546    546
/8179d  mlto60               547    606
/8179d  mlto                 547    666
/8179d  iflist               547    556
/8179d  ifrepl               557    557
/8179d  mldist               667    667
/8179d  mlfmt                668    677
/8179d  mlcdpg               678    682
/8179d  mligba               683    683
/8179D  mlspml               684    684


      * SpyWeb parms
/2815d SPYWEB         UDS                  dtaara
/    d swWEBAPP                      10
/    d swWEBUSR                      20

      *             Work Fields.
     d  FILE           s             10
     d  LIBR           s             10
     d  OPCODE         s              5
     d  RRN#PG         s              9
     d  WRECS          s              9
     d  ERRTYP         s              1
     d  ERRDES         s             80
/1497D PRD#            S              3  0

      * Regular request (little buffer)
     d REGREQ          DS
     d  RQFILE                       10
     d  RQLIBR                       10
     d  RQSKEY                      100
     d  RQOPCD                        5
     d  RQR#PG                        9
     d  RQXBFR                     1000

      * Notes request (big buffer)
     d NOTREQ          ds          8192
     D  NQFILE                       10
     D  NQLIBR                       10
     D  NQRECS                        9
     D  NQOPCD                        5
     D  NQR#PG                        9
     D  NQTIF#                        4
     d  NQSDT                      8100

/813  * Note List Structure
/    d NLDS            ds           128
/    d  NLPAGN                 1     10  0
/    d  NLNOTN                11     20  0 inz
/813 d  NLUSER                21     40
/    d  NLDATE                41     48  0
/    d  NLTIME                49     54  0
/    d  NLTYPE                55     55
/    d  NLACOO                56    105
/    d  NXASTP                56     57
/    d  NXALEN                96    104
/    d  NXATYP               105    109

/4537d  ndStartPos     s             10i 0
/    d  ndDataLen      s             10i 0

     D REGRSP          DS
      *             Regular Response returned in BUF
     D  RRERTY                 1      1
     D  RRERDS                 2     81
      * AFP return values
     D  ARERDS                 2     57
.    D  AFPNOT                58     58
     D  ACOUNT                59     67  0
     D  ATOTSZ                68     76  0
     D  ABUFLN                77     81  0
     d  RRSDT                      8100
/3765d  rMajMinVer                    5
/    d                                5
/2550d  RREOB               8192   8192

     D NOTRSP          DS
      *             Note Response returned in BUF
     D  NRERTY                 1      1
     D  NRERDS                 2     81

      * Report attributes returned from SPYPGRTV
     D RPTATR          DS            80
     D  RPTWID                 1      9
     D  PAGLNS                10     18
     D  FRMTYP                19     28
     D  RPTLPI                29     37
     D  RPTCPI                38     46
     D  RPTRTT                47     47
     D  OVLYN                 48     48

      * Report attributes passed back in ERRDES (ALWAYS ADD TO START OF STRUCUT
     D RTNATR          DS
     D  RTNOVL                 1      1
     D  RTNRTT                 2      2
     D  RTNCPI                 3     11
     D  RTNLPI                12     18
     D  RTNFRM                21     30
     D  RTNWID                31     37
     D  RTNPGL                40     48

      * Get PSCON message
     d RtvMsgSpy       pr            80
     d MsgID                          7    const
     d MsgData                      100    const
      * Set return status code and message
     d RtnStatus       pr
     d RtnCode                        2    const
     d Program                       10    const
     d File                          10    const
     d MsgID                          7    const options(*nopass)
     d MsgData                      100    const options(*nopass)

      * FileName structure passed on open function
     d TFileData       ds
     d  SplFilNam                    10
     d  SplJobNam                    10
     d  SplUsrNam                    10
     d  SplJobNum                     6
     d  SplFilNum                    10i 0
     d  SplFld                       10
     d  SplFldLib                    10
     d  SplSpyNum                    10
     d  SplOpt                        1
     d  SplType                       1
      *   :
      *   :
      *   :
      *   :
      *   :
      *   :
      *   :
      *   :
      *   :
     d  SplTrnTbl                    10
     d  SplTrnLib                    10
     d  SplOptDrv                    15
     d  SplOptVol                    12
     d  SplOptRnm                    10

     d  pPagFrm        s              9p 0
     d  pPagTo         s              9p 0
     d  uPagFrm        s             10u 0
     d  uPagTo         s             10u 0
     d  LastPos        s             10i 0
/8180d docrrn          s             10i 0

      * Comm layer callback for receiving data
/3667d CLrecv          s               *   procptr
     d CLRecvData      pr            10i 0 extproc(CLrecv)
     d  Buffer                         *   value
     d  BufferLn                     10u 0 value
      * Comm layer callback for sending data
/2550d CLsend          s               *   procptr
     d CLSendData      pr            10i 0 extproc(CLsend)
     d  Buffer                         *   value
     d  BufferLn                     10u 0 value

      * Application layer callback for sending data
/2550d ALsend          s               *   procptr inz(%paddr('ALSENDDATA'))
     d ALSendData      pr            10i 0
     d  Buffer                         *   value
     d  BufferLn                     10u 0 value
     d  BufferFlag                   10i 0 value
     d  ErrorID                       8    value
     d  ErrorData                   101    value
      * Send Return Buffer Data
/3765d SendData        pr            10i 0
     d  Data                           *   value
     d  DataLn                       10u 0 value
     d  MaxBufrSiz                   10u 0 value
     d  LastBufrFlag                 10i 0 value
      * Send Response data
/3765d SndRspDta       pr
     d  RspDtaP                        *   value
     d  RspDtaLn                     10u 0 value
     d  LastBufrFlag                 10i 0 value
      * Document revision operations
/3765d DocRevision     pr
      * SpyLinks Hit list
/3765d LnkHitList      pr
     d OpCode                         5    const
      * OmniLinks Hit list
/3765d OmniHitList     pr
     d OpCode                         5    const
      * OmniLinks Report types
/3765d OmniRepTypes    pr
     d OpCode                         5    const
      * Overlay template operations
/4537d OverlayOps      pr
     d OpCode                         5    const
      * get page info for a image/document
/4537d GetPageInfo     pr
     d OpCode                         5    const
      * convert content id (batch/seq) to rev id
/4537d Cvt2RevID       pr
     d OpCode                         5    const
/8179
/8179 * Get User Email address
/8179d GetUsrAddr      pr           256

/8180d fyldta          ds
     d  flspy                  1      3
     d  flver                  1      5
     d  flidx#                 6      8
     d  flsize                 9     17
     d  flfile                18     42
     d  flext                 43     47
     d  fldat                 48     55
     d  fltim                 56     61
     d  fludat                62     69
     d  flutim                70     75
     d  flusr                 76     85
     d  flnode                86    102
     d  flseq                103    111  0
     d  flrrn                112    120  0

      *             Report security auths
/9542d rptsds          ds
     d  sread                         1
     d  schg                          1
     d  scopy                         1
     d  sdel                          1
     d  sattr                         1
     d  ssec                          1
     d  slink                         1
     d  sbak                          1
     d  srst                          1
     d  scfg                          1
     d  sseg                          1
     d  sprnt                         1
     d  smove                         1

/9542d getAllAuth      ds
/    d  ga_view                       1
/    d  ga_print                      1
/    d  ga_delete                     1
/    d  ga_reserve1                   1
/    d  ga_reserve2                   1
/    d  ga_display                    1
/    d  ga_upload                     1
/    d  ga_editLink                   1
/    d  ga_checkOut                   1
/4934d  ga_manSbmCase                 1
/9542d  ga_critAnno                   1

      * ---------------------------------------------------------------------- *

     C     *ENTRY        PLIST
     C                   PARM                    NODEID           17
     C                   PARM                    RUNMOD           10
     C                   PARM                    WEBIP            15
     C                   PARM                    WEBAPP           10
     C                   PARM                    WEBUSR           20
     C                   PARM                    OPCDE             6
/    C                   PARM                    BUF            8192
/2550c                   parm                    CLsend
/3667c                   parm                    CLrecv

     c     OPCDE         CASEQ     'INIT'        $INIT
     c     OPCDE         CASEQ     'QUIT'        $QUIT
     c                   ENDCS

     C     OPCDE         IFEQ      'CONTPG'
     C     FILE          ANDNE     @ATM
     C     FILE          ANDNE     @PCL
/2815C     FILE          ANDNE     @PDF
/813 C     OPCODE        ANDNE     'GETNT'
/7621c     opcode        andne     'LSTNT'
     C                   EXSR      CONTPG
     C                   GOTO      RETURN
     C                   ENDIF

     C                   Z-ADD     0             #
      *-----------------------------------------------------
      * Load data structure and work fields from entry parms
      *-----------------------------------------------------
     C     OPCDE         IFNE      'CONTPG'
     C     NTRQS         IFNE      'Y'
     C                   MOVEL(P)  BUF           REGREQ
     C                   ELSE
     C                   MOVEL(P)  BUF           NOTREQ
     C                   ENDIF
     C                   END
      *
     C                   EXSR      LODWRK
      *
      *---------------------
      * Process all requests
      *---------------------
     c                   eval      OPCDE = *blanks
     C                   EXSR      PROCES
      *>>>>>>>>>>
     C     RETURN        TAG
     C                   RETURN

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PROCES        BEGSR
      *          -------------------------------
      *          Process Input from Client
      *          -------------------------------

      *--------------------
      * Init working fields
      *--------------------
     C                   MOVE      'K'           ERRTYP
     C                   MOVE      *BLANKS       ERRDES
     C                   MOVE      ' '           FNDDTA            1
     C                   MOVE      '  '          @RTN
     C                   MOVE      *BLANKS       DTS
/3679c                   eval      TableFile = 'N'

      * CHECK PRODUCT AUTHORIZATION.
/1497C                   IF        AR_IND = '0'
      * DEFAULT PRODUCT IS SPYVISION/CS.
/1497C                   EVAL      PRD# = 6
T4951c                   select
/    c                   when      runmod = 'DOCMGRAPI'
/    c                   eval      prd# = 14
      * CHECK FOR AUTHORIZATION TO IMAGE VIEWER PLUS IF RUNNING.
T4951C                   when      RUNMOD = 'SPYEXEVU'
/5542C                   eval      prd# = 9
T4951C                   ENDsl
      * SET PRODUCT NUMBER TO SPYWEB IF WEBIP ADDRESS AVAILABLE.
/1497C                   IF        WEBIP <> ' '
/1497C                   EVAL      PRD# = 11
/1497C                   ENDIF
/1497C                   CALLP     SPYAUT(PRD#:AR_IND:AR_MSGID:AR_MDTA)
/1497C                   ENDIF
      * SEND AUTHORIZATION ERROR OR DEMO EXPIRATION WARNING (ONE TIME)
/1497C                   IF        AR_IND = '0' OR
/1497C                             AR_IND = '1' AND AR_MSGID <> ' '
/1497C                   EVAL      ERRDES = RTVMSGSPY(AR_MSGID:AR_MDTA)
/1497C                   EVAL      ERRDES = '   ' + %TRIM(ERRDES)
/1497C                   IF        AR_IND = '1'
/1497C                   EVAL      AR_MSGID = ' '
/4103C                   EVAL      ERRTYP = 'W'
/4103C                   ELSE
/1497C                   EVAL      @RTN = '30'
/1497C                   ENDIF
/1497C                   ENDIF

     C     @RTN          IFNE      '30'
     C                   EXSR      COMMND
     C                   EXSR      SNDREQ
     C                   GOTO      ENDPRO
     C                   END

      * Term error
     c                   if        %subst(errdes:1:10) = *blanks
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):' ')
     c                   end
     C                   MOVE      'E'           ERRTYP
     C                   EXSR      LODDS

     C     NTRQS         IFEQ      'Y'
     C                   MOVEL(P)  NOTRSP        BUF
     C                   ELSE
     C                   MOVEL(P)  REGRSP        BUF
     C                   ENDIF

     C     ENDPRO        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDREQ        BEGSR
      *          ------------------------------------
      *          Send requested information to Client
      *          ------------------------------------

/813 c     NTRQS         IFEQ      'Y'
     C                   EXSR      LODDS
     C                   MOVEL(P)  NOTRSP        BUF
     C                   GOTO      ENDSQ
     C                   ENDIF

     C     OPCODE        IFEQ      'PRINT'
/8179C     OPCODE        OREQ      'EMAIL'
     C     OPCODE        OREQ      'BCHCT'
     C     FILE          OREQ      'SYSDFT'
     C                   MOVE      ' '           ERRTYP
     C                   MOVE      *BLANKS       ERRDES
     C                   EXSR      LODDS
     C                   MOVEL(P)  REGRSP        BUF
     C                   GOTO      ENDSQ
     C                   ENDIF

     C     FILE          IFEQ      '*AFPDS'
     C     FILE          OREQ      @ATM
     C     FILE          OREQ      @PCL
/2815C     FILE          OREQ      @PDF
/813 c     OPCODE        OREQ      'LSTNT'
/813 c     OPCODE        OREQ      'GETNT'
/813 c     OPCODE        OREQ      'UPDNT'
/813 c     OPCODE        OREQ      'WRTNT'
/813 c     OPCODE        OREQ      'DLTNT'
/4537c     OPCODE        OREQ      'APDNT'
     C                   EXSR      LODDS
     C                   MOVEL(P)  REGRSP        BUF
     C                   GOTO      ENDSQ
     C                   ENDIF

      * "Table File" return data
/3679c                   if        TableFile = 'Y'
     C                   EXSR      LODDS
     C                   MOVEL(P)  REGRSP        BUF
     C                   GOTO      ENDSQ
/    c                   end

     C     OPCODE        IFNE      'GTAUT'
     C     #             IFGT      0
     C     #             ANDNE     120
     C     #             ANDNE     240
     C                   ADD       1             #
     C                   MOVEL     '~'           DTS(#)
     C                   ENDIF
     C                   ENDIF

     C     FNDDTA        IFNE      'Y'
     C                   MOVE      RPTRTT        RTNRTT
     C                   MOVE      RPTCPI        RTNCPI
     C                   MOVE      RPTLPI        RTNLPI
     C                   MOVE      RPTWID        RTNWID
     C                   MOVE      OVLYN         RTNOVL
     C                   MOVE      PAGLNS        RTNPGL
     C                   MOVEL     FRMTYP        TMP1              1
     C     TMP1          IFEQ      '*'
     C                   SUBST(P)  FRMTYP:2      RTNFRM
     C                   ELSE
     C                   MOVEL(P)  FRMTYP        RTNFRM
     C                   ENDIF
     C                   MOVE      RTNATR        ERRDES
     C                   ENDIF

     C                   Z-ADD     1             CONTST            3 0
     C                   EXSR      CONTPG

     C     ENDSQ         ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CONTPG        BEGSR
      *          -----------------------------------------
      *          Send the rest of the buffers for the page
      *          -----------------------------------------
     C                   MOVEA(P)  DTS(CONTST)   SDT
     C                   EXSR      LODDS
     C                   MOVEL(P)  REGRSP        BUF

     C                   ADD       30            CONTST
     C     #             IFGE      CONTST
     C                   MOVEL     'CONTPG'      OPCDE
     C                   ELSE
      *   If the buffer has been sent, but there are more
      *   data for this page, go ahead and get the rest
     C     MORSCS        IFEQ      '1'
     C                   EXSR      RTVPAG
     C                   Z-ADD     1             CONTST            3 0
     C     #             IFLT      240
     C                   ADD       1             #
     C                   MOVEL     '~'           DTS(#)
     C                   ENDIF
     C                   ELSE
      *   If no more data for page, pass pack empty opcode
     C                   MOVE      *BLANKS       OPCDE
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     COMMND        BEGSR
      *          -------------------------------------------
      *          Perform the command requested by the client
      *          -------------------------------------------

     C                   MOVE      RRN#PG        ALFA4             4
     C     OPCODE        CAT(P)    FILE:1        TCTEXT
     C                   CAT       ALFA4:1       TCTEXT
     C                   CAT       SKEY1:1       TCTEXT
     C                   CAT       SKEY2:1       TCTEXT
     C                   CAT       SKEY3:1       TCTEXT
     C                   CAT       SKEY4:1       TCTEXT
/3765c                   CAT       sMajMinVer:1  TCTEXT
     C                   CAT       XBFR:1        TCTEXT
     C                   CALL      'SPYCSTRC'    PLTRCE
      *---------------------
      * Clean up entry parms
      *---------------------
     C     OPCODE        IFEQ      'CLSNT'
     C                   MOVE      *ZEROS        RRN#PG
     C                   ENDIF

     C                   MOVEL     RRN#PG        PAGCHR            1
     C     PAGCHR        IFNE      '.'
     C     PAGCHR        ANDNE     '*'
     C                   MOVE      RRN#PG        #RRNPG            9 0
     C                   ELSE
     C                   Z-ADD     0             #RRNPG
     C                   ENDIF

     C                   MOVEA     XBFR          BF

      *----------------
      * Process opcodes
      *----------------
     c                   select
      * System Env.
     c                   when      File = 'SYSDFT'
     C                   EXSR      SYSENV
     C                   GOTO      ENDCMD
      * Authority
     c                   when      OpCode = 'GTAUT'
     C                   EXSR      AUTHOR
     C                   GOTO      ENDCMD
      * Get Overlays
     c                   when      OpCode = 'GTOVL'
     C                   EXSR      GETOVL
     C                   GOTO      ENDCMD
      * SpyLink/OmniLink Query Filter
     c                   when      File = 'QRYFLT'
     C                   EXSR      QRYFLT
     C                   GOTO      ENDCMD
      *------
     c                   when      File = @ATM
/3667c                   EXSR      $Templates
     C                   GOTO      ENDCMD
     c                   when      File = @PCL
     C                   EXSR      CALPCL
     C                   GOTO      ENDCMD
/2815c                   when      File = @PDF
     C                   EXSR      CvtPDF
     C                   GOTO      ENDCMD
     C                   ENDSL
      *------
      * Notes
      *------
     c                   if        %subst(File:1:1) = 'S' or
     c                             %subst(File:1:1) = 'B'
/813 c     OPCODE        IFEQ      'LSTNT'
/    c     OPCODE        OREQ      'GETNT'
/    c     OPCODE        OREQ      'UPDNT'
/    c     OPCODE        OREQ      'WRTNT'
/    c     OPCODE        OREQ      'DLTNT'
/4537c     OPCODE        OREQ      'APDNT'
/3667c                   EXSR      $Notes
     C                   GOTO      ENDCMD
     C                   ENDIF
     C                   ENDIF

     c                   clear                   SDTds
/8273c                   clear                   RRSDT
      *------
      * Print
      *------
     C     OPCODE        IFEQ      'PRINT'
/8179C     OPCODE        OREQ      'EMAIL'
     C                   EXSR      PRTRPT
     C                   GOTO      ENDCMD
     C                   ENDIF
      *-------------
      * Batch Counts
      *-------------
     C     OPCODE        IFEQ      'BCHCT'
     C                   EXSR      BCHCNT
     C                   GOTO      ENDCMD
     C                   ENDIF
      *------------------
      * Retrieve AFP data
      *------------------
     C     FILE          IFEQ      '*AFPDS'
     C                   EXSR      RTVAFP
     C                   GOTO      ENDCMD
     C                   ENDIF
      *----------
      * Std Index
      *----------
     c                   if        %subst(File:1:1) = '@' or
     c                             %subst(File:1:1) = 'R'
     C                   SELECT
     C     OPCODE        WHENEQ    'NDXNX'
     C     OPCODE        OREQ      'NDXPV'
     C     OPCODE        OREQ      'NDXCL'
     C                   EXSR      SRHNDX
     C                   GOTO      ENDCMD
     C                   ENDSL
     C                   ENDIF
      *---------
      * OmniLink
      *---------
     C                   SELECT
      * Get criteria: SpycsHCri
     C     FILE          WHENEQ    'OMNICRIT'
     c                   if        %subst(OpCode:1:4) = 'INFO'
     C                   EXSR      OMNCRI
     C                   GOTO      ENDCMD
     C                   ENDIF
      * Get rpt types: SpycsHRep
     C     FILE          WHENEQ    'REPTYPES'
     c                   if        %subst(OpCode:1:4) = 'INFO'
/3765c                   callp     OmniRepTypes(OPCODE)
     C                   GOTO      ENDCMD
     C                   ENDIF
      * Get hit list: SpycsHHit
     C     FILE          WHENEQ    'OMNIHITS'
/3765c                   callp     OmniHitList(OPCODE)
     C                   GOTO      ENDCMD
     C                   ENDSL
      *--------
      * SpyLink
      *--------
     c                   if        %subst(File:1:1) = '@' or
T5375c                             %subst(File:1:1) = x'b5' or
T5375c                             %subst(File:1:1) = x'44'
     C                   SELECT
      * Get criteria
     c                   when      %subst(OpCode:1:4) = 'INFO'
     C                   MOVEL(P)  'RLNKDEF'     FILE
     C                   EXSR      LNKCRI
     C                   GOTO      ENDCMD
      * Get hit page
     c                   when      %subst(OpCode:1:4) = 'READ'
     C                   EXSR      LNKPGS
     C                   GOTO      ENDCMD
      * Get hit list
     C     OPCODE        WHENEQ    'SELCR'
     C     OPCODE        OREQ      'CLEAR'
     C     OPCODE        OREQ      'SETLL'
     C     OPCODE        OREQ      'SETGT'
     C     OPCODE        OREQ      'SETEN'
     C     OPCODE        OREQ      'RDGT '
     C     OPCODE        OREQ      'RDLT '
     C     OPCODE        OREQ      'RDLTX'
/3340C     OPCODE        OREQ      'RDREV'
/3765c                   callp     LnkHitList(OPCODE)
     C                   GOTO      ENDCMD
     C                   ENDSL
     C                   ENDIF

      * Document revision
     c                   if        OpCode = 'DMLST' or
     c                             OpCode = 'DMLCK' or
     c                             OpCode = 'DMULK' or
     c                             OpCode = 'DMUSR' or
     c                             OpCode = 'DMRVT' or
/8180c                             OpCode = 'EDLNK' or
/    c                             (OpCode = 'READ' and File ='COBJECTS')
/3765c                   callp     DocRevision
     C                   GOTO      ENDCMD
     c                   end

      * Overlay template support
     c                   if        OpCode = 'CROVL' or
     c                             OpCode = 'DLOVL' or
     c                             OpCode = 'UPOVL' or
     c                             OpCode = 'RTOMD' or
     c                             OpCode = 'RTOVL'
/4537c                   callp     OverlayOps(OPCODE)
     C                   GOTO      ENDCMD
     c                   end

      *--------------
      * Screen scrape
      *--------------
     C     FILE          IFEQ      'OMNISERV'
     C     OPCODE        ANDEQ     'WAKUP'
     C                   EXSR      WAKOMN
     C                   GOTO      ENDCMD
     C                   ENDIF
      *-------------
      * Distribution
      *-------------
     c                   if        %subst(SKey1:1:7) = 'RSEGMNT'
     c                               and OPCODE = 'READ'
     C                   EXSR      RTVDPG
     C                   GOTO      ENDCMD
     C                   ENDIF
      *-----------
      * Table file
      *-----------
     C                   EXSR      LSTTBL
      *------------
      * Folder page
      *------------
/3679c                   if        TableFile = 'N'
     C                   EXSR      RTVPAG
     C                   ENDIF

     C     ENDCMD        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  Call SPYPGRTV to get the name for the overlays requested before
     C     GETOVL        BEGSR

     C                   MOVEL     'GETOV'       @OPCOD
     C                   CALL      'SPYPGRTV'    PLRETV

     c                   callp     RtnStatus(@RTN:'SPYPGRTV':@SETKY:
     c                                                       MsgID:MsgDta)

     C                   MOVEA     WTS           DTS

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     AUTHOR        BEGSR

     C                   SUBST     SKEY:1        AUTRPT
     C                   SUBST     SKEY:11       AUTJOB
     C                   SUBST     SKEY:21       AUTPGM
     C                   SUBST     SKEY:31       AUTUSR
     C                   SUBST     SKEY:41       AUTUDT

/5733c                   subst     skey:51       autrqc            2
/    c                   move      autrqc        autreq

/9542c                   select
/    c                   when      autreq = 0
      * The following code will not work for the get-all-auth request if the sys
      * is configured with the jobnam as the only non-exclusionary key.
T6053c                   if        skey1 = ' ' and skey2 <> ' ' and
/    c                             %subst(skey:21:30) = ' '
/9542c                   eval      skey1 = x'00' + 'BATCHID'
/    c                   endif
/    c                   call      'MAG1060'
/    c                   parm      'WRKSPI'      autcal
/    c                   parm      'N'           autoff
/    c                   parm      'R'           autchk
/    c                   parm      'R'           autobt
/    c                   parm      ' '           autobj
/    c                   parm      ' '           wqlibn
/    c                   parm      skey1         autrpt
T6053c                   parm                    autjob
/    c                   parm                    autpgm
/    c                   parm                    autusr
/    c                   parm                    autudt
/9542c                   parm      07            spclreq           2 0
/    c                   parm      ' '           autrtn
/    c                   parm      ' '           rptsds
/    c                   eval      getAllAuth = *all'N'
/    c                   eval      ga_view = sread
/    c                   eval      ga_print = sprnt
/    c                   eval      ga_delete = sdel
/    c                   eval      ga_editLink = schg
/6938c                   eval      ga_checkout = scopy
/    c                   if        ga_checkout = 'N' and extsec = 'N'
/    c                   eval      ga_checkout = sread
/    c                   endif
/4934c                   eval      ga_critanno = schg
/6938c                   when      extsec = 'Y'
     C                   CALL      'MAG1060'                            50
     C                   PARM      'SPYCS'       AUTCAL           10
     C                   PARM      ' '           AUTOFF            1
     C                   PARM      'R'           AUTCHK            1
     C                   PARM      'R'           AUTOBT            1
     C                   PARM      *BLANKS       AUTOBJ           10
     C                   PARM      *BLANKS       AUTLIB           10
     C                   PARM                    AUTRPT           10
     C                   PARM                    AUTJOB           10
     C                   PARM                    AUTPGM           10
     C                   PARM                    AUTUSR           10
     C                   PARM                    AUTUDT           10
/5733C                   PARM                    AUTREQ            2 0
     C                   PARM      *BLANKS       AUTRTN            1
     C                   PARM      *BLANKS       AUT
      * NOT Ext Sec
/9542C                   when      extsec = 'N'
     C                   CALL      'MAG1060'                            50
     C                   PARM      'SPYCS'       AUTCAL           10
     C                   PARM      ' '           AUTOFF            1
     C                   PARM      'U'           AUTCHK            1
     C                   PARM      ' '           AUTOBT            1
     C                   PARM      *BLANKS       AUTOBJ           10
     C                   PARM      *BLANKS       AUTLIB           10
     C                   PARM                    AUTRPT           10
     C                   PARM                    AUTJOB           10
     C                   PARM                    AUTPGM           10
     C                   PARM                    AUTUSR           10
     C                   PARM                    AUTUDT           10
/5733C                   PARM                    AUTREQ            2 0
     C                   PARM      *BLANKS       AUTRTN            1
     C                   PARM      *BLANKS       AUT
/9542c                   endsl

/9542c                   if        autreq = 0
/    c                   movea     getAllAuth    dts
/    c                   else
     C                   MOVEL     AUTRTN        DTS(1)
/9542c                   endif

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTTBL        BEGSR
      *          ---------------------------------------
      *          Perform Opcodes for SpyView table files
      *          ---------------------------------------
/3679c                   eval      TableFile = 'Y'
     C                   SELECT
/    c                   when      %subst(File:1:7) = 'MFLDDIR'
     C                   EXSR      LSTFLD
/    c                   when      %subst(File:1:7) = 'RMAINTN'
     C                   EXSR      LSTTYP
/    c                   when      %subst(File:1:6) = 'RMAINT'
      * skip
/    c                   when      %subst(File:1:8) = 'MRPTDIRN'
     C                   EXSR      LSTRPN
/    c                   when      %subst(File:1:6) = 'MRPTDI'
     C                   EXSR      LSTRPT
/    c                   when      %subst(File:1:7) = 'RLNKDEF'
     C                   EXSR      LSTLNK
/    c                   when      %subst(File:1:6) = 'RINDEX'
     C                   EXSR      LSTNDX
/    c                   when      %subst(File:1:7) = 'RDSTHST'
     C                   EXSR      LSTHST
/    c                   when      %subst(File:1:8) = 'AHYPLNKD'
     C                   EXSR      LSTOMN
/    c                   when      %subst(File:1:8) = 'MIMGDIRN'
     C                   EXSR      LSTBCN
/    c                   when      %subst(File:1:7) = 'MIMGDIR'
     C                   EXSR      LSTBCH
/    c                   when      %subst(File:1:7) = 'RLNKOFF'
     C                   EXSR      LSTOFF
/    c                   when      %subst(File:1:8) = 'CALENDER'
     C                   EXSR      LSTCAL
/    c                   when      %subst(File:1:7) = 'BCHFILE'
     C                   EXSR      LSTFIL
/4537c                   when      File = 'PGCNT'
/    c                   callp     GetPageInfo(OPCODE)
/4537c                   when      File = 'REVID'
/    c                   callp     Cvt2RevID(OPCODE)
     c                   other
/    c                   eval      TableFile = 'N'
     C                   ENDSL

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTFLD        BEGSR
      *          -----------------------------------------
      *          Get the next list of folders from MFLDDIR
      *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKEY1         @FLDR
     C                   MOVEL(p)  SKEY2         @LIBR
     C                   MOVE      *BLANKS       @SCROL
      * Scrolling
     C     PAGCHR        IFEQ      '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @FLDR
     C                   MOVE      *BLANKS       @LIBR
     C                   ENDIF

     C                   CALL      'SPYCSFLD'    PLFLD

     c                   callp     RtnStatus(@RTN:'SPYCSFLD':File)
     c                   if        @RTN <= '20'
     C                   MOVE      FLDCNT        ERRDES
     c                   end

     C                   ENDSR
      *================================================================
     C     PLFLD         PLIST
     C                   PARM                    @FLDR            10
     C                   PARM                    @LIBR            10
     C                   PARM                    @OPCOD            6
/2153C                   PARM                    WEBAPP           10
/2153C                   PARM                    WEBUSR           20
     C                   PARM                    @SCROL            3
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      0             FLDCNT            9 0
     C                   PARM      '00'          @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTFIL        BEGSR
      *          -----------------------------------------
      *          Get the next list of files in a batch
      *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKEY1         @BCHID
     C                   MOVEL(p)  SKEY2         @SESEQ
/8180c                   if        skey3 = '*RRN'
/    c                   move      @seseq        docrrn
/    c                   eval      rc = GetDocAttr(@bchid:docrrn:DocAttrDS)
/9325c                   callp     DocFncQuit
/8180c                   eval      fyldta = DocAttrDS
/    c                   eval      fludat = da_UpDate
/    c                   eval      flutim = da_UpTime
/    c                   eval      flusr = da_UpUser
/    c                   eval      flnode = da_UpNode
/    c                   eval      flseq = 0
/    c                   eval      flrrn = docrrn
     c                   eval      sdtds = fyldta
/    c                   eval      @rtn = '20'
/    c                   eval      @rtnrc = 1
/    c                   endif

/8180c                   if        skey3 <> '*RRN'
      *   REPLACE 5 CHAR OPCODE BY 6 CHAR OPCODE
     C                   SELECT
     C     @OPCOD        WHENEQ    'REDLT'
     C                   MOVEL     'READLT'      @OPCOD
     C     @OPCOD        WHENEQ    'REDGT'
     C                   MOVEL     'READGT'      @OPCOD
     C                   ENDSL

     C                   MOVEA     XBFR          SDT
     C                   CALL      'SPYCSFIL'    PLFIL
/8180c                   endif

     c                   callp     RtnStatus(@RTN:'SPYCSFIL':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES
     c                   end

     C                   ENDSR
      *================================================================
     C     PLFIL         PLIST
     C                   PARM      RQLIBR        @WIN             10
     C                   PARM                    @BCHID           10
     C                   PARM                    @OPCOD
     C                   PARM                    @SESEQ            9
     C                   PARM                    SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM                    @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTRPN        BEGSR
      *          -----------------------------------------
      *          Get the next list of reports from MRPTDIR (NEW VERSION)
      *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKEY1         @VIEW
     C                   MOVEL(p)  SKEY2         @SESPY
     C                   MOVEL(p)  SKEY3         @PATH
     C                   MOVEL(p)  SKEY4         @LIB
     C                   MOVEL(p)  XBFR          @VWKEY
???
      *   REPLACE 5 CHAR OPCODE BY 6 CHAR OPCODE
     C                   SELECT
     C     @OPCOD        WHENEQ    'REDLT'
     C                   MOVEL     'READLT'      @OPCOD
     C     @OPCOD        WHENEQ    'REDGT'
     C                   MOVEL     'READGT'      @OPCOD
     C                   ENDSL

     C                   MOVEA     XBFR          SDT
     C                   CALL      'SPYCSRPTN'   PLRPTN

     c                   callp     RtnStatus(@RTN:'SPYCSRPTN':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @SCROL        ERRDES
     c                   end

     C                   ENDSR
      *================================================================
     C     PLRPTN        PLIST
     C                   PARM      RQLIBR        @WIN             10
     C                   PARM                    @VIEW            10
     C                   PARM      *BLANKS       @LIB             10
     C                   PARM      *BLANKS       @PATH            10
     C                   PARM                    @VWKEY          200
     C                   PARM                    @OPCOD
     C                   PARM                    @SESPY           10
     C                   PARM      *BLANKS       POSFLD           10
     C                   PARM      *BLANKS       POSDAT           10
     C                   PARM      *BLANKS       POSFMT           10
     C                   PARM      *BLANKS       POSTN
     C                   PARM                    SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM                    @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTBCN        BEGSR
      *          -----------------------------------------
      *          Get the next list of batches from MIMGDIR (NEW VERSION)
      *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKEY1         @VIEW
     C                   MOVEL(p)  SKEY2         @SEBCH
     C                   MOVEL(p)  SKEY3         @PATH
     C                   MOVEL(p)  SKEY4         @LIB
     C                   MOVEL(p)  XBFR          @VWKEY
???
      *   REPLACE 5 CHAR OPCODE BY 6 CHAR OPCODE
     C                   SELECT
     C     @OPCOD        WHENEQ    'REDLT'
     C                   MOVEL     'READLT'      @OPCOD
     C     @OPCOD        WHENEQ    'REDGT'
     C                   MOVEL     'READGT'      @OPCOD
     C                   ENDSL

     C                   CALL      'SPYCSBCHN'   PLBCHN

     c                   callp     RtnStatus(@RTN:'SPYCSBCHN':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @SCROL        ERRDES
     c                   end

     C                   ENDSR
      *================================================================
     C     PLBCHN        PLIST
     C                   PARM      RQLIBR        @WIN             10
     C                   PARM                    @VIEW            10
     C                   PARM      *BLANKS       @LIB             10
     C                   PARM      *BLANKS       @PATH            10
     C                   PARM                    @VWKEY          200
     C                   PARM                    @OPCOD
     C                   PARM                    @SEBCH           10
     C                   PARM      *BLANKS       POSFLD           10
     C                   PARM      *BLANKS       POSDAT           10
     C                   PARM      *BLANKS       POSFMT           10
     C                   PARM      *BLANKS       POSTN
     C                   PARM                    SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM                    @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTTYP        BEGSR
      *          -----------------------------------------
      *          Get the next list of report types RMAINT (NEW VERSION)
      *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKEY1         @VIEW
     C                   MOVEL(p)  SKEY2         @TYPE
     C                   MOVEA     KEY(12)       @SORT
     C                   MOVEA     KEY(22)       @SETYP
     C                   SUBST     XBFR:1        @FLDR
     C                   SUBST     XBFR:11       @LIBR
      *   REPLACE 5 CHAR OPCODE BY 6 CHAR OPCODE
     C                   SELECT
     C     @OPCOD        WHENEQ    'REDLT'
     C                   MOVEL     'READLT'      @OPCOD
     C     @OPCOD        WHENEQ    'REDGT'
     C                   MOVEL     'READGT'      @OPCOD
     C                   ENDSL

     C                   CALL      'SPYCSRTY'    PLTYP

     c                   callp     RtnStatus(@RTN:'SPYCSRTY':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES
     c                   end

     C                   ENDSR
      *================================================================
     C     PLTYP         PLIST
     C                   PARM                    @VIEW            10
     C                   PARM                    @FLDR
     C                   PARM                    @LIBR
     C                   PARM                    @OPCOD
     C                   PARM                    @SORT            10
     C                   PARM                    @TYPE             1
     C                   PARM                    @SETYP           10
     C                   PARM      *BLANKS       POSTN            10
     C                   PARM                    SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM                    @RTN              2
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTCAL        BEGSR
      *          ----------------
      *          Get the CALENDAR
      *          ----------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKEY1         @VIEW
     C                   SUBST     XBFR:1        @FLDR
     C                   SUBST     XBFR:11       @LIBR
     C                   SUBST     XBFR:21       @RTYP
     C                   SUBST     XBFR:31       F4A               4
     C                   MOVE      F4A           @YEAR
     C                   SUBST     XBFR:35       F2A               2
     C                   MOVE      F2A           @MONTH

     C                   CALL      'SPYCSCAL'    PLCAL

     c                   callp     RtnStatus(@RTN:'SPYCSCAL':File)

     C                   ENDSR
      *================================================================
     C     PLCAL         PLIST
     C                   PARM                    @VIEW            10
     C                   PARM                    @FLDR
     C                   PARM                    @LIBR
     C                   PARM                    @RTYP            10
     C                   PARM                    @OPCOD
     C                   PARM                    @YEAR             4 0
     C                   PARM                    @MONTH            2 0
     C                   PARM                    SDT
     C                   PARM                    @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTRPT        BEGSR
      *          -----------------------------------------
      *          Get the next list of reports from MRPTDIR
      *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  FILE          @FILE
     C                   MOVEL(p)  SKey1         @FLDR
     C                   MOVEL(p)  SKey2         @LIBR
     C                   MOVEA     KEY(66)       @SETKY
     C                   MOVEA     BF(1)         @POSTO
     C                   MOVE      *BLANKS       @SCROL
      * Scrolling
     C     PAGCHR        IFEQ      '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @SETKY
     C                   MOVE      *BLANKS       @POSTO
     C                   ELSE
      * Position to
     C     @POSTO        IFNE      *BLANKS
     C                   MOVE      *BLANKS       @SETKY
     C                   MOVE      *BLANKS       @SCROL
     C                   ENDIF
      * Page up/dwn
     C     @SETKY        IFNE      *BLANKS
     C                   MOVE      *BLANKS       @POSTO
     C                   MOVE      *BLANKS       @SCROL
     C                   ENDIF
     C                   ENDIF

     C                   MOVEA     XBFR          SDT
     C                   CALL      'SPYCSRPT'    PLRPT

     c                   callp     RtnStatus(@RTN:'SPYCSRPT':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @SCROL        ERRDES
     c                   end

     C                   ENDSR
      *================================================================
     C     PLRPT         PLIST
     C                   PARM                    @FILE            10
     C                   PARM                    @FLDR            10
     C                   PARM                    @LIBR            10
     C                   PARM                    @OPCOD            6
     C                   PARM                    @SETKY           10
     C                   PARM                    @SCROL            3
     C                   PARM                    @POSTO           10
     C                   PARM                    SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      '00'          @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTOFF        BEGSR
      *          -----------------------------------------
      *          Get the next list of reports from RLNKOFF
      *          -----------------------------------------
     C                   MOVEL(p)  SKey1         LORPT            10
     C                   MOVEL(p)  SKey2         LOJOB            10
     C                   MOVEL(p)  SKey3         LOPRG            10
     C                   MOVEL(p)  SKey4         LOUSR            10
     C                   MOVEA     KEY(41)       LOUDTA           10
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   CALL      'SPYCSOLNK'   PLOFF

     c                   callp     RtnStatus(@RTN:'SPYCSOLNK':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES
     c                   end

     C                   ENDSR
      *================================================================
     C     PLOFF         PLIST
     C                   PARM                    LORPT
     C                   PARM                    LOJOB
     C                   PARM                    LOPRG
     C                   PARM                    LOUSR
     C                   PARM                    LOUDTA
     C                   PARM                    @OPCOD            6
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      '00'          @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTBCH        BEGSR
      *          -----------------------------------------------
      *          Get the next list of Image batches from MIMGDIR
      *          -----------------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
???   ***
     C                   MOVEL(p)  FILE          @FILE
     C     @FILE         IFNE      'MIMGDIR3'
     C                   MOVEL     'MIMGDIR3'    @FILE
     C                   ENDIF
     C                   MOVEL(p)  SKey1         @FLDR
     C                   MOVEL(p)  SKey2         @LIBR
     C                   MOVEA     KEY(66)       @SETKY
     C                   MOVEA     BF(1)         @POSTO
     C                   MOVE      *BLANKS       @SCROL
      * Scrolling
     C     PAGCHR        IFEQ      '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @SETKY
     C                   MOVE      *BLANKS       @POSTO
     C                   ELSE
      * Position to
     C     @POSTO        IFNE      *BLANKS
     C                   MOVE      *BLANKS       @SETKY
     C                   MOVE      *BLANKS       @SCROL
     C                   ENDIF
      * Page up/dwn
     C     @SETKY        IFNE      *BLANKS
     C                   MOVE      *BLANKS       @POSTO
     C                   MOVE      *BLANKS       @SCROL
     C                   ENDIF
     C                   ENDIF

     C                   CALL      'SPYCSBCH'    PLBCH

     c                   callp     RtnStatus(@RTN:'SPYCSBCH':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @SCROL        ERRDES
     c                   end

     C                   ENDSR
      *================================================================
     C     PLBCH         PLIST
     C                   PARM                    @FILE            10
     C                   PARM                    @FLDR            10
     C                   PARM                    @LIBR            10
     C                   PARM                    @OPCOD            6
     C                   PARM                    @SETKY           10
     C                   PARM                    @SCROL            3
     C                   PARM                    @POSTO           10
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      '00'          @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     BCHCNT        BEGSR
      *          ----------------------------------------------
      *          Get the Image Batch Counts for selected FOLDER
      *          ----------------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKey1         @FLDR
     C                   MOVEL(p)  SKey2         @LIBR

     C                   CALL      'SPYCSBCNT'   PLBCNT
     C     PLBCNT        PLIST
     C                   PARM                    @FLDR            10
     C                   PARM                    @LIBR            10
     C                   PARM                    @OPCOD            6
     C                   PARM      *BLANKS       SDT
     C                   PARM      '00'          @RTN              2

     c                   callp     RtnStatus(@RTN:'SPYCSBCNT':@FLDR)

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTLNK        BEGSR
      *          -----------------------------------------------
      *          Get the next list of SpyLinked Reports & Images
      *            (primarily RMaint data)
      *          -----------------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  FILE          @FILE
     C                   MOVEL(p)  SKey          @SETRT
     C                   MOVE      *BLANKS       @SCROL
      * Scrolling
     C     PAGCHR        IFEQ      '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @SETRT
     C                   ENDIF

     C                   CALL      'SPYCSLRMNT'  PLLNK
     C     PLLNK         PLIST
     C                   PARM                    @FILE            10
     C                   PARM                    @OPCOD            6
     C                   PARM                    @SETRT           50
     C                   PARM                    WEBAPP           10
     C                   PARM                    WEBUSR           20
     C                   PARM                    @SCROL            3
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      '00'          @RTN              2
/3765c                   parm                    sMajMinVer

     c                   callp     RtnStatus(@RTN:'SPYCSLRMNT':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES
     c                   end

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTNDX        BEGSR
      *          -------------------------------------------------
      *          Get the next list of Standard Indexes from RINDEX
      *          -------------------------------------------------
     C                   MOVE      FILE          @FILE
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKey1         @SETKY

     C                   CALL      'SPYCSNDX'    PLNDX
     C     PLNDX         PLIST
     C                   PARM                    FILE             10
     C                   PARM                    @OPCOD            6
     C                   PARM                    @SETKY           10
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      '00'          @RTN              2

     c                   callp     RtnStatus(@RTN:'SPYCSNDX':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES
     c                   end

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTHST        BEGSR
      *          -------------------------------------------
      *          Get the next list of segments from RDSTHST
      *          -------------------------------------------
     C                   MOVEL(P)  OPCODE        @OPCOD
     C                   MOVE      FILE          @FILE
     C                   MOVEL(p)  SKey          @SET30

     C                   CALL      'SPYCSSEG'    PLHST
     C     PLHST         PLIST
     C                   PARM                    FILE
     C                   PARM                    @OPCOD
     C                   PARM                    @SET30           30
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC
     C                   PARM      '00'          @RTN

     c                   callp     RtnStatus(@RTN:'SPYCSSEG':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES
     c                   end

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTOMN        BEGSR
      *          --------------------------------------------------
      *          Get the next list of OmniLink names from AhypLnkD
      *          --------------------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKey1         @OMNAM
     C                   MOVE      *BLANKS       @SCROL
      * Scrolling
     C     PAGCHR        IFEQ      '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @OMNAM
     C                   ENDIF

     C                   CALL      'SPYCSOMN'    PLOMN
     C     PLOMN         PLIST
     C                   PARM                    @OMNAM           10
     C                   PARM                    @OPCOD            6
     C                   PARM                    WEBAPP           10
     C                   PARM                    WEBUSR           20
     C                   PARM                    @SCROL            3
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      0             OMNCNT            9 0
     C                   PARM      '00'          @RTN              2

     c                   callp     RtnStatus(@RTN:'SPYCSOMN':File)
     c                   if        @RTN <= '20'
     C                   MOVE      OMNCNT        ERRDES
     c                   end

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LNKCRI        BEGSR
      *          --------------------------------------------------    -
      *          Get the field names & descriptions for the SPYLINK
      *          --------------------------------------------------    -
      *  When OPCODE = 'INFO ' a single key value is in KEY.
      *  When OPCODE = 'INFOn' where n is 1-9, KEY is blank and
      *     n 55-byte (Big5 + Offlink seq#) are in BF (XBFR).

     c                   eval      @OPCOD = opCode
     c                   eval      LinkLst(*) = *blanks
     c                   if        %subst(@OPCOD:1:4) = 'INFO'
     c                   if        %subst(@OPCOD:5:1) <> *blanks
     C                   MOVEA     BF(1)         LinkLst
     c                   else
     c                   select
     c                   when      sMajMinVer = *blanks
     c                   eval      LinkLst(1) = Skey
     c                   when      Skey1 <> *blanks
     c                   eval      LinkLst(1) = Skey
     c                   eval      %subst(LinkLst(1):1:50)
     c                                = x'00'+'RTYPEID  '+SKey1
     c                   when      Skey2 <> *blanks
     c                   eval      %subst(LinkLst(1):1:20)
     c                                = x'00'+'REVID    '+SKey2
     c                   endsl
     c                   end
     c                   end
     c                   eval      @FILE  = file
     C                   CLEAR                   SDT

     C                   CALL      'SPYCSLCRI'   PLCRI

     c                   callp     RtnStatus(@RTN:'SPYCSLCRI':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES
     c                   end
/3679c                   eval      TableFile = 'Y'

     C                   ENDSR
      *================================================================
     C     PLCRI         PLIST
     C                   PARM                    @FILE
     C                   PARM                    @OPCOD            6
     C                   PARM                    LinkLst
     C                   PARM                    WEBAPP           10
     C                   PARM                    WEBUSR           20
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      '00'          @RTN              2
/3765c                   parm                    sMajMinVer

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LNKPGS        BEGSR
      *          -----------------------------------------------
      *          Get the pages for the selected SpyLink hit key
      *          -----------------------------------------------

???   ***
     C                   MOVEL(P)  'READ '       @OPCOD
     C                   Z-ADD     #RRNPG        PAGE#

     C                   MOVE      'Y'           LNKPG             1
     C                   EXSR      RTVPAG

     C                   ENDSR
      *================================================================
/2815c     plSpyWeb      plist
     c                   parm                    POpCode          10
     c                   parm                    PRqsData       1000
     c                   parm                    PRtnCode          1
     c                   parm                    PRtnID            7
     c                   parm                    PRespData      1000

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OMNCRI        BEGSR
      *          ----------------------------------------------------  -
      *          Get the field names and descriptions for the OMNLINK
      *          ----------------------------------------------------  -

      *  When OPCODE = 'INFO ' a single key value is in KEY.
      *  When OPCODE = 'INFOn' where n is 1-9, KEY is blank and
      *   n 10-byte key values are in BF (XBFR).

     c                   eval      @OPCOD = opCode
     c                   eval      OmniLst(*) = *blanks
     c                   if        %subst(@OPCOD:1:4) = 'INFO'
     c                   if        %subst(@OPCOD:5:1) <> *blanks
     C                   MOVEA     BF(1)         OmniLst
     c                   else
     c                   eval      OmniLst(1) = SKey
     c                   end
     c                   end
     C                   CLEAR                   SDT

     C                   CALL      'SPYCSHCRI'   PHCRI

     c                   callp     RtnStatus(@RTN:'SPYCSHCRI':File)
     c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES
     c                   end
/3679c                   eval      TableFile = 'Y'

     C                   ENDSR
      *================================================================
     C     PHCRI         PLIST
/    C                   PARM                    OmniLst
     C                   PARM                    WEBAPP           10
     C                   PARM                    WEBUSR           20
     C                   PARM                    @OPCOD            6
     C                   PARM      *BLANKS       SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      '00'          @RTN              2
/3765c                   parm                    sMajMinVer

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WAKOMN        BEGSR
      *          ------------------------------------
      *          Wake up OmniServer for screen scrape
      *          ------------------------------------
     C                   MOVEL(P)  'WAKEUP'      QDTA

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SPYCSDQ'     QNAME            10
/    C                   PARM      '*LIBL'       QLIB             10
     C                   PARM      1024          QDTASZ            5 0
     C                   PARM                    QDTA           1024
     C                   PARM      17            QKEYSZ            3 0
     C                   PARM                    NODEID           17

     C                   MOVE      '00'          @RTN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVDPG        BEGSR
      *          --------------------------
      *          Get Distribution page data
      *          --------------------------
     C                   EXSR      RTVDST

     C     @RTN          IFEQ      '00'
     C                   MOVE      ' '           MORSCS
     C                   MOVE      ' '           LNKPG
     C     @OPCOD        IFNE      'READC'
     C                   MOVEL     'DTAOV'       @OPCOD
     C                   ENDIF
     C                   CALL      'SPYPGRTV'    PLRETV
     C     @RTN          IFNE      '30'
/2306C     SDLOGT        IFEQ      'Y'
     C                   MOVEA     BF            DLSEG
     C                   MOVE      'V'           DLTYPE
     C                   MOVE      @SETKY        DLREP
     C                   Z-ADD     @TOTPG        DLTPGS
     C                   EXSR      MAG901
/2306C                   END
     C                   Z-ADD     #RTV          #
     C                   MOVEA     WTS           DTS
     C                   Z-ADD     @DSTPG        DSTPG9            9 0
     C                   MOVE      DSTPG9        DTS
     C                   ENDIF
     C                   ENDIF

     C                   SELECT
      * 20: Warning: no more pages
     C     @RTN          WHENEQ    '20'
/813cc                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):File)
      * 25: Part of a long page returned.  Setup for subr RTVPAG next.
     C     @RTN          WHENEQ    '25'
     C                   MOVE      '1'           MORSCS
     C                   MOVEA     @SETKY        KEY(66)
      * 30: Fatality
     C     @RTN          WHENEQ    '30'
/813cc                   eval      ErrTyp = 'E'
     c                   eval      ErrDes = @RTN+' '+RtvMsgSpy(MsgID:MsgDta)
     C                   ENDSL

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVDST        BEGSR
      *          -----------------------------------------------------
      *          Get Distribution page# (PAGE#) from partial page file
      *          -----------------------------------------------------
     C                   MOVEL(P)  'READ  '      @OPCOD
     C                   MOVE      *BLANKS       @SCROL

     C     PAGCHR        IFEQ      '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @SETRT
     C                   ENDIF

     C                   MOVEA     BF(51)        DSTTBL           10
     C                   MOVEA     BF(51)        @FILE
     C                   MOVEA     BF(91)        @SETKY
     C                   MOVEA     BF(101)       ATOTPG            9
     C                   MOVE      ATOTPG        @TOTPG
     C                   Z-ADD     #RRNPG        @DSTPG
     C     @DSTPG        IFEQ      0
     C                   Z-ADD     1             @DSTPG
     C                   ENDIF

     C                   MOVE      '00'          @RTN
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANKS       MSGDTA
     C     @FILE         IFEQ      *BLANKS
     C                   Z-ADD     @DSTPG        PAGE#
     C                   ELSE
     C                   CALL      'SPYCSDST'    PLDST
     C                   ENDIF
     C                   ENDSR
      *================================================================
     C     PLDST         PLIST
     C                   PARM                    @FILE
     C                   PARM                    @OPCOD
     C                   PARM                    @SETKY
     C                   PARM                    @SCROL
     C                   PARM                    @DSTPG            7 0
     C                   PARM                    @TOTPG            9 0
     C                   PARM      0             PAGE#
     C                   PARM      '00'          @RTN              2
     C                   PARM      *BLANKS       MSGID
     C                   PARM      *BLANKS       MSGDTA

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRHNDX        BEGSR
      *          ----------------------------------------
      *          Get the next page satisfying the search
      *          ----------------------------------------
     C                   SELECT
     C     OPCODE        WHENEQ    'NDXNX'
     C                   MOVEL(P)  'NEXT'        @OPCOD
     C     OPCODE        WHENEQ    'NDXPV'
     C                   MOVEL(P)  'PREV'        @OPCOD
     C     OPCODE        WHENEQ    'NDXCL'
     C                   MOVEL(P)  'CLEAR'       @OPCOD
     C                   ENDSL

     C                   MOVEL(p)  FILE          @FILE
     C                   MOVEL(p)  LIBR          HANDL
     C                   MOVEL(p)  SKey1         @SETKY

     C                   MOVEA     XBFR          BF
     C                   MOVEA     BF(1)         @PFILE
     C                   MOVEA     BF(11)        FRMRRC            9
     C                   MOVE      FRMRRC        FRMRR#
     C                   MOVEA     BF(20)        ARGLEC            3
     C                   MOVE      ARGLEC        ARGLEN
     C                   MOVEA     BF(23)        ARG

     C                   CALL      'SPYCSSNDX'   PLSNDX

     c                   callp     RtnStatus(@RTN:'SPYCSSNDX':File)

     C                   MOVE      'Y'           FNDDTA

     C     #             IFGT      0
     C                   MULT      13            #
     C                   DIV       256           #
     C                   MVR                     REM               9 0
     C     REM           IFGT      0
     C                   ADD       1             #
     C                   ENDIF
     C                   ENDIF
      * P.S. (JJF 1/19/99) The above undocumented code appears to
      *      compute # = zero or 14. (# from SPYCSSNDX is 0 or 1)

     C                   ENDSR
      *================================================================
     C     PLSNDX        PLIST
     C                   PARM                    @FILE            10
     C                   PARM                    @SETKY
     C                   PARM                    @PFILE           10
     C                   PARM                    HANDL            10
     C                   PARM                    @OPCOD
     C                   PARM                    ARG             256
     C                   PARM                    ARGLEN            3 0
     C                   PARM                    FRMRR#            9 0
     C                   PARM      *BLANKS       DTS
     C                   PARM      0             #
     C                   PARM      '00'          @RTN              2

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVPAG        BEGSR
      *          --------------------------------
      *          Get the SpyLink/Folder page data
      *          --------------------------------
     C                   MOVEL(P)  OPCODE        @OPCOD
     C                   Z-ADD     #RRNPG        PAGE#
     C                   MOVE      *BLANK        DSTTBL
     C                   Z-ADD     0             RFIL#
     C                   Z-ADD     0             ROFFS

     C     LNKPG         IFEQ      'Y'
     C                   MOVEL(p)  SKey2         @SETKY
     C                   MOVE      KEY(39)       FORMS

      * handle converted report pages numbers
/5921c                   eval      LnkPgRqstDS = XBfr
/    c                   if        LnkRStrPgA <> *blanks and
/    c                             LnkREndPgA <> *blanks
/    c                   if        LnkRepLoc = '4' or
/    c                             LnkRepLoc = '5' or
/    c                             LnkRepLoc = '6'
/    c                   eval      ROffs = LnkRStrPg
/    c                   eval      RFil# = LnkREndPg
/    c                   else
      * convert distribution request
/    c                   eval      DistPage = Page#
/5921c                   if        1 = CvtFromDistPageNbr(@SetKy:
/    c                                    sit_any_sub:*blanks:
/    c                                    LnkRStrPg:LnkREndPg:DistPage)
/    c                   eval      Page# = DistPage
/    c                   end
/    c                   end
/    c                   end

     C                   ELSE
     C                   MOVEA     KEY(66)       @SETKY
     C                   MOVE      KEY(76)       FORMS
     C                   ENDIF

     C                   Z-ADD     0             #                 9 0
     C                   DO        *HIVAL
      *      If previous call didn't return the whole page
     C     MORSCS        IFEQ      '1'
/2492C                   MOVEL(P)  'CNTOV'       @OPCOD
     C                   ELSE
     C     @OPCOD        IFNE      'READC'
     C                   MOVEL     'DTAOV'       @OPCOD
     C                   ENDIF
     C                   ENDIF

     C                   CALL      'SPYPGRTV'    PLRETV
     C                   MOVE      ' '           MORSCS

     C     @RTN          IFEQ      '30'
     C     #             IFNE      0
     C                   MOVE      '00'          @RTN
     C                   ELSE
/813cc                   eval      ErrTyp = 'E'
     c                   eval      ErrDes = @RTN+' '+RtvMsgSpy(MsgID:MsgDta)
     C                   ENDIF
/2149C                   MOVE      ' '           LNKPG
     C                   LEAVE
     C                   ENDIF
      * Log it
/2306C     SDLOGT        IFEQ      'Y'
     C     FORMS         IFEQ      'P'
     C                   MOVE      FORMS         DLTYPE
     C                   ELSE
     C                   MOVE      'V'           DLTYPE
     C                   END
     C                   MOVE      *BLANKS       DLSEG
     C                   MOVE      @SETKY        DLREP
     C                   Z-ADD     PAGE#         DLTPGS
     C                   EXSR      MAG901
/2306C                   END

     C     OPCODE        IFEQ      'READC'
     C     @RTN          IFEQ      '21'
/813cc                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = @RTN+' '+RtvMsgSpy(MsgID:MsgDta)
     C                   MOVE      '20'          @RTN
/1990C                   MOVE      RPTATR        SAVATR
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *  If second request, make sure, that (if possible) not more than
      *  120 records get transferred.
     C     #             IFGT      0
     C     #             ADD       #RTV          #1                9 0
     C     #             IFLE      120
     C     #1            ANDGT     120
     C     #             ORGT      120
     C     #1            ANDGT     240
     C     @RTN          OREQ      '25'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *  Fill the DTS buffer with the current page data.

     C     #             ADD       1             #1                9 0
     C                   MOVEA     WTS           DTS(#1)
     C                   ADD       #RTV          #

     C     *LIKE         DEFINE    RPTATR        SAVATR
     C                   MOVE      RPTATR        SAVATR

      *  If request was made to get the rest of data for the prv. request, get o
     C     @OPCOD        IFNE      'CONTIN'
     C                   ADD       1             PAGE#
     C                   ENDIF

      *  If page is too long for one buffer, set flag to continue reading.
     C     @RTN          IFEQ      '25'
     C                   MOVE      '1'           MORSCS            1
     C                   LEAVE
     C                   ENDIF

     C     @RTN          IFEQ      '20'
/813cc                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):@SetKy)
/2149C                   MOVE      ' '           LNKPG
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

     C                   MOVE      SAVATR        RPTATR
      * /2149 (5/31/00) - Need to reset LNKPG if no more data to read
     C     MORSCS        IFNE      '1'
     C                   MOVE      ' '           LNKPG
     C                   ENDIF
     C                   ENDSR
      *================================================================
     C     PLRETV        PLIST
     C                   PARM                    @SETKY           10
     C                   PARM                    @OPCOD            6
     C                   PARM                    PAGE#             7 0
/2272C                   PARM      0             RRN#              9 0
     C                   PARM      *BLANKS       WTS
     C                   PARM      0             #RTV              9 0
     C                   PARM                    RPTATR           80
     C                   PARM                    LNKPG
     C                   PARM                    LnkVal(1)
     C                   PARM                    LnkVal(2)
     C                   PARM                    LnkVal(3)
     C                   PARM                    LnkVal(4)
     C                   PARM                    LnkVal(5)
     C                   PARM                    LnkVal(6)
     C                   PARM                    LnkVal(7)
     C                   PARM      '00'          @RTN              2
     C                   PARM      *BLANKS       MSGID             7
     C                   PARM      *BLANKS       MSGDTA          100
     C                   PARM                    RFIL#             9 0
     C                   PARM                    ROFFS            11 0
     C                   PARM                    FORMS             1

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVAFP        BEGSR
      *          -----------------
      *          Get AFP Page Data
      *          -----------------
     C                   CLEAR                   @RTN
     C                   MOVEL(p)  LIBR          HANDL
     C                   MOVEL(p)  SKey1         @SETKY

     C                   SELECT
     C     OPCODE        WHENEQ    'AGTPG'
     C     OPCODE        OREQ      'AGAPG'
     C                   SELECT
     C     KEY(11)       WHENNE    *BLANK
     C                   EXSR      RTVDST
     C     @RTN          IFEQ      '20'
     C                   MOVE      '30'          @RTN
     C                   MOVEL     'ERR1807'     MSGID
     C                   MOVEL(P)  @DSTPG        MSGDTA
     C                   ELSE
     C                   Z-ADD     PAGE#         AFFRPG
     C                   Z-ADD     PAGE#         AFTOPG
     C                   ENDIF
     C     RRN#PG        WHENEQ    '*DOCHDR'
     C                   Z-ADD     0             AFFRPG
     C                   Z-ADD     0             AFTOPG
     C     RRN#PG        WHENEQ    '*DOCFTR'
     C                   Z-ADD     -1            AFFRPG
     C                   Z-ADD     0             AFTOPG
     C                   OTHER
     C                   MOVEL(p)  SKey4         AFPGWK            9
     C                   MOVE      AFPGWK        AFFRPG
     C                   MOVEA     KEY(40)       AFPGWK            9
     C                   MOVE      AFPGWK        AFTOPG
     C                   ENDSL

     C     OPCODE        WHENEQ    'AGTRD'
     C                   MOVEA     KEY(11)       AFRSCT
     C                   MOVEA     KEY(12)       AFRSCN
     C                   MOVEA     KEY(22)       AFRSCL
     C                   ENDSL

     C                   MOVE      *BLANKS       AFPNOT
     C     @RTN          IFNE      '30'
     C                   CALL      'SPYAFRTV'    PLARTV
     C                   Z-ADD     AFRTCT        ACOUNT
     C                   Z-ADD     AFRTSZ        ATOTSZ
     C                   Z-ADD     AFRTBL        ABUFLN
     C                   MOVEL     MSGDTA        AFPNOT
     C                   ENDIF

     C     @RTN          IFEQ      '00'
     C                   MOVE      'K'           ERRTYP
     C                   MOVE      *BLANKS       ERRDES
     C                   ELSE
     C     @RTN          IFEQ      '20'
     C                   MOVE      'W'           ERRTYP
     C                   ELSE
     C                   MOVE      'E'           ERRTYP
     C                   ENDIF
     c                   eval      ErrDes = RtvMsgSpy(MsgID:MsgDta)
     C                   ENDIF
     C                   ENDSR
      *================================================================
     C     PLARTV        PLIST
     C                   PARM                    OPCODE
     C                   PARM                    HANDL
     C                   PARM                    @SETKY
     C                   PARM                    AFFRPG            7 0
     C                   PARM                    AFTOPG            7 0
     C                   PARM                    AFRSCT            1
     C                   PARM                    AFRSCN           10
     C                   PARM                    AFRSCL           10
     C                   PARM                    AFRTSZ            9 0
     C                   PARM                    AFRTCT            9 0
     C                   PARM                    AFRTBL            5 0
     C                   PARM                    SDT
     C                   PARM                    @RTN              2
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA          100

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3667c     $Notes        begsr
      * Notes processing (Handle notes data buffers)

     c                   dou       NtRqs <> 'Y'
     c                   exsr      CalNot

      * notes data buffer processing
     c                   if        NtRqs = 'Y'
     c                   if        @Parms < 9 or CLrecv = *null
     c                   leave
     c                   end
     c                   eval      rc = CLRecvData(%addr(NOTREQ):%size(NOTREQ))
     c                   if        rc < 0
     c                   MOVE      'N'           NTRQS
     c                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):'SPYCSNOT')
     c                   leave
     c                   end
     c                   EXSR      LODWRK
     c                   eval      OPCDE = *blanks
     c                   end

     c                   enddo

     c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALNOT        BEGSR
      * Add or Get notes for pages of reports

     C                   MOVEL(p)  LIBR          HANDL
     C                   MOVEL(p)  FILE          @FILE
     C                   MOVEL(p)  'SPYCS'       @LIBR
/813 C                   MOVEL(p)  OPCODE        NTCODE
     C                   CLEAR                   NOTE#
/813 C                   CLEAR                   TIFPG#
/    C                   Z-ADD     0             NOTREC
/    C                   Z-ADD     0             ENDPAG
/3765c                   eval      RevIDn = 0
/4537c                   eval      ndStartPos = 0
/    c                   eval      ndDataLen  = 0

     C                   SELECT
/813 C     OPCODE        WHENEQ    'LSTNT'
/    C                   MOVEL     XBFR          ALF9              9
/    C                   TESTN                   ALF9                 88
/    C   88              MOVE      ALF9          ENDPAG
/    C                   OTHER
/    C     NTRQS         IFNE      'Y'
/    C                   MOVEL     XBFR          NLDS
/    C                   END
/    C                   MOVE      NLPAGN        TIFPG#
/    C     OPCODE        IFNE      'WRTNT'
/813 C                   MOVE      NLNOTN        NOTE#
/    C                   END
     C                   ENDSL

/813 C     NTRQS         IFNE      'Y'
/    C                   MOVE      *BLANKS       SDT
/    C                   MOVEA     XBFR          SDT
/5235c                   movea     bf(129)       Segmnt
/3765c                   eval      RevIDn = 0
/    C                   END

/    c                   if        sMajMinVer <> *blanks
/    c                   if        sKey1 <> *blanks
/    c                   move      SKey1         RevIDn
/    c                   end
/    c                   eval      HeadRevID = GetHedBy_RevID(RevIDn)
/    c                   eval      WipRevID = GetWIPBy_RevID(RevIDn)

/3765c                   if        RevIDn = HeadRevID
/    c                   if        WipRevID > 0
/    c                   eval      RevIDn = WipRevID
/    c                   endif
/    c                   endif
/    c                   if        RevIDn = 0
/8180c                   if        RRN#PG = ' '
/    c                   move      nlpagn        RRN#PG
/    c                   endif
/3765c                   eval      RevIDn=GetHedBy_ConID(@File + RRN#PG)
/    c                   end

/4537c                   if        sKey2 <> *blanks
/    c                              and OpCode = 'GETNT'
/    c                   move      SKey2         ndStartPos
/    c                   end
/4537c                   if        sKey3 <> *blanks
/    c                              and ( OpCode = 'GETNT' or
/    c                                    OpCode = 'APDNT' )
/    c                   move      SKey3         ndDataLen
/    c                   end

/    C                   END

/4900c                   eval      errid = ' '
/    c                   eval      errdta = ' '
/9804c                   if        @FILE = 'B         ' and RevIDn <> 0
/    c                   eval      @FILE = GetContID(RevIDn)
/    c                   endif
     C                   MOVE      *BLANKS       @ERCON
     C                   CALL      'SPYCSNOT'    plCSNOT                50
/813 C                   MOVE      *BLANKS       RTNDES

/813  * SWITCH BUFFER OR CONVERSION MODE
/    C                   SELECT
/    C     OPCODE        WHENEQ    'WRTNT'
/4537c     OPCODE        OREQ      'APDNT'
/    C     NOTREC        IFGT      0
/    C                   MOVE      'Y'           NTRQS             1
/    C                   MOVE      'NORESP'      OPCDE
/    C                   ELSE
/    C                   MOVE      'N'           NTRQS
/    C                   MOVEA     SDT           RTNDES
/    C                   END
/    C     OPCODE        WHENEQ    'UPDNT'
/    C     @RTN          ANDEQ     '00'
/    C                   MOVEA     SDT           RTNDES
/    C     OPCODE        WHENEQ    'LSTNT'
/    C     @RTN          ANDEQ     '00'
/    C     OPCODE        OREQ      'GETNT'
/    C     @RTN          ANDEQ     '00'
/    C                   MOVEL     'CONTPG'      OPCDE
/    C                   ENDSL

     C                   SELECT
     C     @RTN          WHENEQ    '00'
/813 C                   MOVE      'K'           ERRTYP
/813bC                   MOVEL     RTNDES        ERRDES
     C     @RTN          WHENEQ    '20'
     C                   MOVE      'W'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):@File)
     C     @RTN          WHENEQ    '25'
     C                   MOVE      'E'           ERRTYP
/813cc                   eval      ErrDes = RtvMsgSpy(MsgE(7):' ')
     C     @RTN          WHENEQ    '30'
     C                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):'SPYCSNOT')
     C                   ENDSL

/4900c                   if        errid <> ' '
/    C                   MOVE      'E'           ERRTYP
/    c                   eval      ErrDes = '  ' + RtvMsgSpy(errid:errdta)
/    c                   endif
/4537c                   if        @RTN <= '20'
/    c                   MOVE      NOTREC        ERRDES
/    c                   end

/4835C     endcalnot     ENDSR
      *================================================================
     C     plCSNOT       PLIST
     C                   PARM                    @FILE
     C                   PARM                    SEGMNT           10
     C                   PARM                    HANDL
     C                   PARM                    @LIBR
     C                   PARM                    NTCODE            5
     C                   PARM                    #RRNPG            9 0
     C                   PARM                    NOTE#             9 0
     C                   PARM                    TIFPG#            9 0
     C                   PARM                    SDT
     C                   PARM                    NOTREC            9 0
     C                   PARM      '00'          @RTN
     C                   PARM                    NOTLR             1
     C                   PARM                    NEWNOT            1
/813 C                   PARM                    ENDPAG            9 0
     C                   PARM                    A01               1
/3765c                   PARM                    RevIDn            9 0
     c                   parm                    dcode             9 0
     c                   parm                    dtype             9 0
     c                   parm                    errid             7
     c                   parm                    errdta           80
/4537c                   parm                    ndStartPos
/    c                   parm                    ndDataLen

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3667c     $Templates    begsr
      * Annotation Template processing (Handle notes data buffers)

     c                   dou       NtRqs <> 'Y'
     c                   exsr      CalATM

      * notes data buffer processing
     c                   if        NtRqs = 'Y'
     c                   if        @Parms < 9 or CLrecv = *null
     c                   leave
     c                   end
     c                   eval      rc = CLRecvData(%addr(NOTREQ):%size(NOTREQ))
     c                   if        rc < 0
     c                   MOVE      'N'           NTRQS
     c                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):'SPYCSATM')
     c                   leave
     c                   end
     c                   EXSR      LODWRK
     c                   eval      OPCDE = *blanks
     c                   end

     c                   enddo

     c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALATM        BEGSR
      *          ----------------------
      *          Call SPYCSATM
      *          ----------------------
     C                   MOVEL(P)  OPCODE        @OPCOD

     C     NTRQS         IFNE      'Y'
     C                   MOVE      *BLANKS       SDT
     C                   MOVEA     XBFR          SDT
     C                   END

     C                   MOVE      *BLANKS       @ERCON
     C                   CALL      'SPYCSATM'    PLATM                  50

     C     *LIKE         DEFINE    ERRDES        RTNDES
     C                   MOVE      *BLANKS       RTNDES

      * SWITCH BUFFER OR CONVERSION MODE
     C                   SELECT
     C     OPCODE        WHENEQ    'WRTTM'
     C     @RTNRC        IFGT      0
     C                   MOVE      'Y'           NTRQS
     C                   MOVE      'NORESP'      OPCDE
     C                   ELSE
     C                   MOVE      'N'           NTRQS
     C                   MOVEA     SDT           RTNDES
     C                   END
/813 C     OPCODE        WHENEQ    'LSTTN'
/    C     @RTN          ANDEQ     '00'
/    C     OPCODE        OREQ      'GETTM'
     C     @RTN          ANDEQ     '00'
     C                   MOVEL     'CONTPG'      OPCDE
     C                   ENDSL

     C                   SELECT
     C     @RTN          WHENEQ    '00'
     C                   MOVE      'K'           ERRTYP
     C                   MOVEL     RTNDES        ERRDES
     C     @RTN          WHENEQ    '20'
     C                   MOVE      'W'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):' ')
     C     @RTN          WHENEQ    '25'
     C                   MOVE      'E'           ERRTYP
/813cc                   eval      ErrDes = RtvMsgSpy(MsgE(8):' ')
     C     @RTN          WHENEQ    '30'
     C                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):'SPYCSATM')
     C                   ENDSL

     C                   ENDSR
      *================================================================
     C     PLATM         PLIST
     C                   PARM                    @OPCOD
     C                   PARM                    SKEY
     C                   PARM                    SDT
     C                   PARM      0             @RTNRC            9 0
     C                   PARM      '00'          @RTN
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALPCL        BEGSR
      * get PCL report by page range

     C                   MOVEL(P)  OPCODE        @OPCOD

     C                   MOVE      RRN#PG        pPAGFRM
     C                   MOVEL     XBFR          pPAGTO
     c                   eval      uPagFrm = pPagFrm
     c                   eval      uPagTo  = pPagTo
     c                   eval      KeyData = %subst(XBFR:10)

     c                   eval      LastPos = 0
     c                   clear                   TFileData
     c                   eval      SplSpyNum = SKey1

/2550c                   CALL      'BLDPCLPGS'   PBLDPCL                50

      * check return message
     c     x'00'         scan      RMsgID0       np                3 0    88
     c   88              eval      %subst(RMsgID0:np) = *blanks
     c     x'00'         scan      RMsgDta0      np                       88
     c   88              eval      %subst(RMsgDta0:np) = *blanks

      * response status
     c                   select
     c                   when      RmsgID0 <> *blanks or *in50
     c                   eval      @RTN  = '30'
     c                   other
     c                   eval      @RTN  = '20'
     c                   eval      OPCDE = 'NORESP'
     c                   endsl
     c                   callp     RtnStatus(@RTN:'BLDPCLPGS':'PCLREPORT':
     c                                                        RMsgID0:RMsgDta0)

     C                   ENDSR
      *================================================================
/2550c     PBLDPCL       plist
     c                   parm                    @OPCOD
     c                   parm                    uPAGFRM
     c                   parm                    uPAGTO
     c                   parm                    TFileData
     c                   parm                    ALSend
     c                   parm                    KeyData        1000
     c                   parm      x'00'         RMsgID0           8
     c                   parm      x'00'         RMsgDta0        101

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2815C     CvtPDF        BEGSR
      *          ----------------------
      *          Call MCPDFCVTR
      *          ----------------------
     C                   MOVEL(P)  OPCODE        @OPCOD

     C                   MOVE      RRN#PG        PAGFRM
     C                   MOVEL     XBFR          PAGTO
      * load parm structures
/2815c                   clear                   SpyLinkDS
/    c                   subst     XBFR:10       SLpartial       262
/    c                   move      SLpartial     SpyLinkDS
/2815C                   eval      RDstSegDS = %subst(XBFR:272)

     C                   MOVE      *BLANKS       @ERCON
     C                   MOVE      *BLANKS       @ERDTA
     C                   CALL      'MCPDFCVTR'   PLPDFCvt               50

/6391 *   RETURN NUMBER OF BYTES IN BUFFER
/    C     @RTN          IFEQ      '00'
/    C     @RTN          OREQ      '20'
/    C                   Z-ADD     BYTRTN        ABUFLN
/    C                   ENDIF

     C     @RTN          IFEQ      '00'
     C     OPCODE        IFEQ      'READ'
     C                   MOVEL     'CONTPG'      OPCDE
     C                   ENDIF
     C                   ENDIF
     c                   callp     RtnStatus(@RTN:'MCPDFCVTR':@SETKY:
     c                                                        @ERCON:@ERDTA)
/4537c                   if        @RTN <= '20'
/    c                   MOVE      BYTRTN        ERRDES
/    c                   end

     C                   ENDSR
      *================================================================
     C     PLPDFCvt      PLIST
     C                   PARM                    @OPCOD
     C                   PARM                    HANDL
     C                   PARM      SKEY1         @SETKY
     C                   PARM                    PAGFRM            9 0
     C                   PARM                    PAGTO             9 0
     C                   PARM      7680          BYTRQS            9 0
     C                   PARM                    BYTRTN            9 0
     C                   PARM                    SDT
     C                   PARM      '00'          @RTN
     C                   PARM                    @ERCON
     C                   PARM                    @ERDTA
     c                   parm                    SpyLinkDS       768
     c                   parm                    RDstSegDS       127
     c                   parm                    Forms             1
     C                   PARM                    WEBAPP           10
     C                   PARM                    WEBUSR           20

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PRTRPT        BEGSR
      *          ---------------------
      *          Print Report
      *          ---------------------
     C                   MOVEL(p)  SKey4         @JOBNA
     C                   MOVEA     KEY(41)       @USRNA
     C                   MOVEA     KEY(51)       @JOBNU
     C                   MOVEA     KEY(57)       TEMP9             9
     C                   MOVE      TEMP9         @FILN#            9 0
     C                   MOVEA     KEY(66)       @SPY00

     C                   MOVEA     XBFR          BF
     C                   MOVEA     BF(1)         TEMP9
     C                   MOVE      TEMP9         FRMPAG
     C                   MOVEA     BF(10)        TEMP9
     C                   MOVE      TEMP9         TOPAGE
     C                   MOVEA     BF(69)        WSBM

      * if this is an email command then change prt device to "EMAIL"
      *  and load the LDA with the email information
/8179c                   if        OpCode = 'EMAIL'
/8179c                   eval      wPrt = Opcode
/8179c                   exsr      LoadLDA
/8179c                   else
     C                   MOVEA     BF(19)        WPRT
     C                   MOVEA     BF(29)        OUTQ
     C                   MOVEA     BF(39)        OUTQL
     C                   MOVEA     BF(49)        WP
     C                   MOVEA     BF(59)        WPL
/8179c                   endif
/8179
     C                   Z-ADD     1             COPIES

     C     OUTQ1         IFEQ      ' '
     C                   MOVE      *BLANKS       OUTQ#
     C                   ENDIF

     C     OUTQ#         IFEQ      *BLANKS
     C     WP            ANDEQ     *BLANKS
     C     WPRT          ANDEQ     *BLANKS
     C                   MOVEL     '*USRPRF'     OUTQ#
     C                   ENDIF

/9346c                   eval      qualFolder = skey1 + skey2
/9346c                   CALL      'MCDDPCPP'    PL801
     C     PL801         PLIST
     C                   PARM                    @SPY00           10
     C                   PARM                    JOB#
     c                   parm      *zeros        datfo             7
     C                   PARM                    @FILN#
     C                   PARM                    OUTQ#            20
     C                   PARM                    COPIES            3 0
     C                   PARM                    CALLER           10
     C                   PARM                    FRMPAG            9 0
     C                   PARM                    TOPAGE            9 0
     C                   PARM                    WPRT             10
     C                   PARM                    WP               10
     C                   PARM                    WPL              10
     C                   PARM                    WSBM              1
     C                   PARM                    DSTTBL
/9346c                   parm                    qualFolder       20
/    c                   parm      '4'           operation         1
     C                   ENDSR
/8179c*-------------------------------------------------------------------------
/8179c*-  LoadLDA - Load LDA with Email parameters
/8179c*-------------------------------------------------------------------------
/8179c     LoadLDA       Begsr
/8179
/8179c                   In        LDA
/8179
/8179 * format the buffer based on the version of the structure
/8179c                   Select
/8179
/8179 * extra buffer structure version 0
/8179c                   when      xbf_vers = '00000'
/8179c                   eval      mlind = '*EMAIL'
      * get from address if it is blank
     c                   if        xbf_frmeml = *blanks or
     c                             xbf_frmeml = '*CURRENT'
     c                   eval      Xbf_frmeml = GetUsrAddr
     c                   else
/8179c                   eval      mlfrm = xbf_frmeml
     c                   endif

/8179c                   eval      mlsubj = xbf_subj
/8179c                   eval      mltxta = xbf_msgtxt
/8179c                   eval      mlto = xbf_dsteml
/8179c                   eval      mlfmt = xbf_fmt
/8179c                   eval      mltype = 'E'
      * special parms for Spoolmail
/8179c                   if        Splmail = 'Y'
/8179c                   eval      mlind = ' '
/8179c                   eval      mlspml = 'S'
/8179c                   endif
/8179
/8179c                   endsl
/8179
/8179c                   Out       LDA
/8179
/8179c                   Endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QRYFLT        BEGSR
      *          ----------------------
      *          Do Query Filter Opcodes
      *          ----------------------
     C                   SELECT

     C     OPCODE        WHENEQ    'SET'
     C                   MOVEA     SDT(1)        QRYAO
     C                   MOVEA     SDT(61)       QRYFN
     C                   MOVEA     SDT(261)      QRYTE
     C                   MOVEA     SDT(361)      QRYVL
     C                   MOVEA     SDT(961)      QRYTYP            1
     C     10            SUBST     SKEY:1        QRYRTY
     C     10            SUBST     SKEY:11       QRYOBT
     C     5             SUBST     SKEY:21       F5A               5
     C     F5A           IFEQ      *BLANKS
     C                   CLEAR                   QRYOFF
     C                   ELSE
     C                   MOVEL     F5A           QRYOFF
     C                   ENDIF
      *    Move Query Parms to arrays
     C                   MOVEA     QRYAO         AO
     C                   MOVEA     QRYFN         FN
     C                   MOVEA     QRYTE         TE
     C                   MOVEA     QRYVL         QV
     C                   MOVEL     *BLANKS       QVF
      *    Check the filter and return error line
     C                   CALL      'SPYCSQRY'                           50
     C                   PARM                    QRYRTY           10
     C                   PARM                    QRYOBT           10
     C                   PARM                    QRYOFF            5 0
     C                   PARM                    AO
     C                   PARM                    FN
     C                   PARM                    TE
     C                   PARM                    QV
     C                   PARM                    QVF
     C                   PARM                    QRYOPC           10
     C                   PARM                    QRYMSG            7
     C                   PARM                    QRYLIN            3 0
     C                   PARM                    QRYFLD           10

     C     QRYMSG        IFNE      *BLANKS
     C                   CLEAR                   AO
     C                   CLEAR                   FN
     C                   CLEAR                   TE
     C                   CLEAR                   QV
     C                   CLEAR                   QVF
     C                   MOVE      QRYLIN        F3A               3
/813cc                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = F3A + RtvMsgSpy(QryMsg:QryFld)
     C                   MOVE      '20'          @RTN
     C                   ENDIF

     C     OPCODE        WHENEQ    'CLEAR'
     C                   CLEAR                   QRYAO
     C                   CLEAR                   QRYFN
     C                   CLEAR                   QRYTE
     C                   CLEAR                   QRYVL
     C                   CLEAR                   QRYTYP
     C                   CLEAR                   AO
     C                   CLEAR                   FN
     C                   CLEAR                   TE
     C                   CLEAR                   QV
     C                   CLEAR                   QVF
     C                   CLEAR                   QRYRTY
     C                   CLEAR                   QRYOBT
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SYSENV        BEGSR
      *          ----------------------
      *          Do Environment Opcodes
      *          ----------------------
     C     OPCODE        IFEQ      'READ'
     C                   IN        SYSDFT

      * SYSDFT date format can be 'JOB', so call MAG8090 to resolve it
      * and put back into the SYSDFT structure.
     C                   CALL      'MAG8090'
     C                   PARM                    DATFMT            3
     C                   PARM                    DATSEP            1
     C                   PARM                    TIMSEP            1

     C                   MOVE      DATFMT        SDATFM

     C                   MOVEA(P)  SYSDFT        SDT
     C                   Z-ADD     1025          @S                5 0
     C                   MOVE      DATSEP        SDT(@S)
     C                   Z-ADD     1026          @S
     C                   MOVE      TIMSEP        SDT(@S)
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2306C     MAG901        BEGSR
      *          Call Mag901 to log activity to RDstLog
      *          when significant fields change.

     C     DLREP         IFNE      DXREP
     C     DLTYPE        ORNE      DXTYPE
     C     DLREPT        ORNE      DXREPT
     C     DLSUBS        ORNE      DXSUBS
     C     DLSEG         ORNE      DXSEG

     C                   CALL      'MAG901'
     C                   PARM                    RTN               1
     C                   PARM                    DLSUBS           10
/4419C                   PARM      *blanks       DLREPT           10
     C                   PARM                    DLSEG            10
     C                   PARM                    DLREP            10
     C                   PARM                    DLBNDL           10
     C                   PARM                    DLTYPE            1
     C                   PARM                    DLTPGS            9 0
     C                   PARM      'SPYCS'       CALPGM           10
     C                   PARM      WEBAPP        DLWEBA           10
     C                   PARM      WEBUSR        DLWEBU           20

     C                   MOVE      DLREP         DXREP            10
     C                   MOVE      DLTYPE        DXTYPE            1
     C                   MOVE      DLREPT        DXREPT           10
     C                   MOVE      DLSUBS        DXSUBS           10
     C                   MOVE      DLSEG         DXSEG            10
     C                   END
/2306C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RCVMSG        BEGSR
      *          -------------------------
      *          Get Non-Program Message
      *          -------------------------
     C                   CALL      'QMHRCVM'
     C                   PARM                    @MSGT@            8
     C                   PARM      8             APILEN
     C                   PARM      'RCVM0100'    MSGFMT            8
     C                   PARM                    @MSGQ            20
     C                   PARM      '*LAST'       @MSGTY           10
     C                   PARM      *BLANKS       @MSGKY            4
     C                   PARM      -1            @MSGWT
     C                   PARM      '*REMOVE'     @MSGAC           10
     C                   PARM                    ERRCD
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

      * Force key code checking on startup.
/3889c                   eval      ar_ind = '0'
      * Save SpyWeb parms
/2815c                   eval      swWEBAPP = WEBAPP
/2815c                   eval      swWEBUSR = WEBUSR
/2815c                   OUT       SPYWEB

     C                   IN        SYSDFT
      * Chg RunPty
     C     SCSPTY        IFNE      *BLANKS
     C                   CALL      'SPYCHGRP'
     C                   PARM                    SCSPTY
     C                   ENDIF
      * Login WebUser
     C     WEBUSR        IFNE      *BLANKS
     C     LOGWEB        ANDEQ     'Y'
     C                   MOVE      'I'           WBTYPE
     C                   CALL      'MAG901W'     PL901W
     C     PL901W        PLIST
     C                   PARM                    WEBAPP           10
     C                   PARM                    WEBUSR           20
     C                   PARM      WEBIP         WEBADR           17
     C                   PARM                    PGMUSR
     C                   PARM                    WBTYPE            1
     C                   PARM                    RTN901            7
     C                   END

     C     LDEBUG        IFEQ      'Y'
     C                   MOVE      'N'           SETDBG            1
     C                   END

     C     SETDBG        IFNE      'Y'
     C                   GOTO      NODBG
     C                   ENDIF

     c                   eval      CLCMD = 'CRTMSGQ MSGQ(QGPL/Q9)'
     C                   CALL      'MAG1030'
     C                   PARM                    RTN               1
     C                   PARM      'QGPL'        #LIBR            10
     C                   PARM      'Q9'          #OBJ             10
     C                   PARM      '*MSGQ'       APITYP           10
     C                   PARM                    CLCMD           255
     C                   MOVEL(P)  #SPYM9        @MSGQ

     C                   EXSR      RCVMSG
     C                   CALL      DBGPGM
      *>>>>>>>>>>
     C     NODBG         TAG
     c                   callp     DMSinit
/2319c                   callp     LnkHitList('INIT')
     c                   callp     OmniHitList('INIT')
     C                   EXSR      CLNUP

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSPGM        BEGSR
      *          Close Programs

     C                   MOVEL(P)  'QUIT'        @OPCOD

/2815C                   CALL      'MCPDFCVTR'   PLPDFCVT
/813 c                   CALL      'SPYCSATM'    PLATM
     C                   CALL      'SPYCSFLD'    PLFLD
     C                   CALL      'SPYCSRPT'    PLRPT
     C                   CALL      'SPYCSBCH'    PLBCH
     C                   CALL      'SPYCSNDX'    PLNDX
     C                   CALL      'SPYPGRTV'    PLRETV
     C                   CALL      'SPYCSSEG'    PLHST
     C                   CALL      'SPYCSDST'    PLDST
     C                   CALL      'SPYCSOMN'    PLOMN
     C                   CALL      'SPYAFRTV'    PLARTV
     C                   CALL      'SPYCSOLNK'   PLOFF
     C                   CALL      'SPYCSBCNT'   PLBCNT
     C                   CALL      'SPYCSLRMNT'  PLLNK
     C                   CALL      'SPYCSLCRI'   PLCRI
     C                   CALL      'SPYCSHCRI'   PHCRI
     C                   CALL      'SPYCSSNDX'   PLSNDX
/3765c                   callp     LnkHitList('QUIT')
/3765c                   callp     OmniHitList('QUIT')
/3765c                   callp     OmniRepTypes('QUIT')
/4537c                   callp     OverlayOps('QUIT')
     C                   MOVE      'Y'           NOTLR
     C                   CALL      'SPYCSNOT'    plCSNOT
     c                   eval      ErrDes = RtvMsgSpy('Q':' ')
      * Logout WebUser
     C     WEBUSR        IFNE      *BLANKS
     C     LOGWEB        ANDEQ     'Y'
     C                   MOVE      'O'           WBTYPE
     C                   CALL      'MAG901W'     PL901W
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODWRK        BEGSR
      *          Load DS fields to Wrk fields (from entry parm).

     C     NTRQS         IFNE      'Y'
     C                   MOVE      RQFILE        FILE
     C                   MOVE      RQLIBR        LIBR
     C                   MOVE      RQOPCD        OPCODE
     C                   MOVE      RQR#PG        RRN#PG
     C                   MOVE      RQSKEY        SKEY
     C                   MOVEL(p)  RQXBFR        XBFR
     C                   ELSE
     C                   MOVE      NQFILE        FILE
     C                   MOVE      NQLIBR        LIBR
     C                   MOVE      NQOPCD        OPCODE
     C                   MOVE      NQR#PG        RRN#PG
     C                   MOVE      NQRECS        WRECS
     C                   MOVEL(p)  NQSDT         SDTds
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODDS         BEGSR
      *          Load WRK fields to DS fields (to be returned in BUF)

     C                   SELECT
     C     FILE          WHENEQ    '*AFPDS'
     C     FILE          OREQ      @PCL
/2815C     FILE          OREQ      @PDF
     C                   MOVE      ERRTYP        RRERTY
     C                   MOVEL     ERRDES        ARERDS
     C                   MOVEA     SDT           RRSDT
     C     NTRQS         WHENEQ    'Y'
     C                   MOVE      ERRTYP        NRERTY
     C                   MOVE      ERRDES        NRERDS
     C                   OTHER
     C                   MOVE      ERRTYP        RRERTY
     C                   MOVE      ERRDES        RRERDS
     C                   MOVEA     SDT           RRSDT
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $INIT         BEGSR
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $QUIT         BEGSR
      * REMOVE USER FROM LICENSE TRACKING FILE.
/1497C                   CALLP     SPYAUT(PRD#:AR_IND:AR_MSGID:AR_MDTA:'1')
/1497C                   CALLP     SPYAUT(9:AR_IND:AR_MSGID:AR_MDTA:'1')

      * REMOVE node entry from SPYCS data queue.
      * (QKEY value set in CLNUP routine at startup)
/3890c                   CALL      'QRCVDTAQ'    PLRCVQ                 81

     C                   EXSR      CLSPGM
     c                   callp     DMSquit
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLNUP         BEGSR
      *          Cleanup  ghost jobs from prior crashes

      *************  NodeId is now blank  *************

      *    QRcvDtaQ Parms:
      *    Parm  Name   Size  Description
      *    ----  -----  ----  ----------------------------------------
      *     1    QName    10  Name of Queue         ='SPYCS'
      *     2    QLib     10  Library of Queue      =LPGMLB
      *     3    QDtaSz   5.0 Length of Data field  =10
      *     4    QDta    128  Field containing data
      *     5    QWait    5.0 Wait time in seconds  = 0
      *     6    QOrder   2   Logical operand       =EQ
      *     7    QKeySz   3.0 Length of key         =27
      *     8    QKey     27  Key value (NodeID+RunMode)
      *     9    QSndLn   3.0 Sender length         =44
      *    10    QSndr    44  Sender id (see data str)

     C     NODEID        CAT       RUNMOD        QKEY

     C                   CALL      'QRCVDTAQ'    PLRCVQ                 81
      *                                                     Rcv (Clear)
     C     QDTASZ        DOWGT     0
     C     *IN81         ANDEQ     *OFF
     C                   CALL      'SPYENDJB'
     C                   PARM                    QJNAM
     C                   PARM                    QUSER
     C                   PARM                    QJ#
      *                                                     Rcv (Clear)
     C                   CALL      'QRCVDTAQ'    PLRCVQ                 81
     C                   ENDDO

     C                   CALL      'QSNDDTAQ'    PLSNDQ
     C                   ENDSR
      *================================================================
      * Send data que
     C     PLSNDQ        PLIST
     C                   PARM      'SPYCS'       QNAME            10
/    C                   PARM      '*LIBL'       QLIB
     C                   PARM      10            QDTASZ            5 0
     C                   PARM      'SPYCS'       QDTA
     C                   PARM      27            QKEYSZ            3 0
     C                   PARM                    QKEY             27
      * Rcv data que
     C     PLRCVQ        PLIST
     C                   PARM      'SPYCS'       QNAME
/    C                   PARM      '*LIBL'       QLIB
     C                   PARM      10            QDTASZ
     C                   PARM      'SPYCS'       QDTA
     C                   PARM      0             QWAIT             5 0
     C                   PARM      'EQ'          QORDER            2
     C                   PARM      27            QKEYSZ
     C                   PARM                    QKEY
     C                   PARM      44            QSNDLN            3 0
     C                   PARM                    QSNDR

     C     PLTRCE        PLIST
     C                   PARM                    NODEID           17
     C                   PARM      'SPYCS'       TCPROG           10
     C                   PARM      *BLANK        TCMSGI            7
     C                   PARM                    TCTEXT           80
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Get PSCON message
     p RtvMsgSpy       b
     d                 pi            80
     d MsgID                          7    const
     d MsgData                      100    const

     c                   select
     C     MsgID         wheneq    'Q'
     C                   eval      @MPACT = 'Q'
     C                   EXSR      RTVMSG
     C     MsgID         whenne    *BLANKS
     C                   eval      @ERCON = MsgID
     C                   eval      @ERDTA = MsgData
     C                   EXSR      RTVMSG
     C                   return    @MSGTX
     C                   endsl
     C                   return    *BLANKS

     C     RTVMSG        BEGSR
      *          Get Message from PSCON
     C                   CALL      'MAG1033'                            99
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80

     C                   MOVE      *BLANKS       @ERDTA
     C                   ENDSR
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Set return status code and message
     p RtnStatus       b
     d                 pi
     d RtnCode                        2    const
     d Program                       10    const
     d File                          10    const
     d MsgID                          7    const options(*nopass)
     d MsgData                      100    const options(*nopass)

     c                   select
      * errors
     c                   when      RtnCode >= '30'
     c                               and %parms >= 4 and MsgID <> *blanks
     c                   eval      ErrTyp = 'E'
     c                   eval      ErrDes = RtnCode+' '+RtvMsgSpy(MsgID:MsgDta)
     c                   eval      @RTN = '30'
     c                   when      RtnCode >= '30'
     c                   eval      ErrTyp = 'E'
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):Program)
     c                   eval      @RTN = '30'
      * warnings
     c                   when      RtnCode >= '20'
     c                               and %parms >= 4 and MsgID <> *blanks
     c                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = RtnCode+' '+RtvMsgSpy(MsgID:MsgDta)
     c                   eval      @RTN = '20'
/6576c                   when      RtnCode = '22'
/    c                   eval      ErrTyp = 'W'
/    c                   eval      ErrDes = RtvMsgSpy(MsgE(9):File)
/    c                   eval      @RTN = '22'
     c                   when      RtnCode = '21'
     c                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = RtvMsgSpy(MsgE(6):File)
     c                   eval      @RTN = '20'
     c                   when      RtnCode >= '20'
     c                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):File)
     c                   eval      @RTN = '20'
/6356c                   when      @rtn = '19'
/    c                   eval      ErrTyp = 'E'
     c                   other
     c                   eval      ErrTyp = 'K'
     c                   eval      ErrDes = *blanks
     c                   eval      @RTN = '00'
     c                   endsl

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Application layer callback for sending data
/2550p ALSendData      b
     d ALSendData      pi            10i 0
     d  Buffer                         *   value
     d  BufferLn                     10u 0 value
     d  BufferFlag                   10i 0 value
     d  ErrorID                       8    value
     d  ErrorData                   101    value

     d  rc             s             10i 0
     d  MaxBuf         s             10u 0

     c                   eval      ErrorID   = x'00'
     c                   eval      ErrorData = x'00'
/3629c                   callp     RtnStatus('20':'CALLBACK':'DATA')
/3629c                   if        sMajMinVer = *blanks
/    c                   eval      MaxBuf = 7680
/    c                   else
/    c                   eval      MaxBuf = 8100
/    c                   end
      * Pass request to send function
     c                   eval      rc = SendData(Buffer:BufferLn:
     c                                           MaxBuf:BufferFlag)
     c                   if        rc < 0
     c                   eval      ErrorID   = MsgE(2) + x'00'
     c                   eval      ErrorData = 'SENDDATA' + x'00'
     c                   return    rc
     c                   end

     c                   return    BufferLn
     p ALSendData      e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Send Return Buffer Data
/3765p SendData        b
     d                 pi            10i 0
     d  Data                           *   value
     d  DataLn                       10u 0 value
     d  MaxBufrSiz                   10u 0 value
     d  LastBufrFlag                 10i 0 value

/4537d  BufrLen        s              9s 0
     d  Bufr           s          32767    based(BufrP)
     d  Pos            s             10i 0
     d  Len            s             10i 0
     d  rc             s             10i 0

      * setup regular return buffer
     c                   eval      RRERTY = 'K'
/4537c                   eval      rrERDS = *blanks
/3765c                   eval      rMajMinVer = sMajMinVer
     c                   eval      RREOB = '1'
      * send data in fixed blocks
     c                   eval      BufrP = Data
     c                   eval      Pos = 0
     c                   dou       Pos = DataLn

      * copy to send buffer
     c                   eval      Len = MaxBufrSiz - LastPos
     c                   if        Len > DataLn - Pos
     c                   eval      Len = DataLn - Pos
     c                   end
     c                   if        Len > 0 and BufrP <> *null
     c                   eval      %subst(RRSDT:LastPos+1) =
     c                                          %subst(Bufr:1:Len)
     c                   eval      BufrP = BufrP + Len
     c                   end

      * send a buffer
     c                   if        LastPos+Len = MaxBufrSiz
     c                               or LastBufrFlag<>0
     c                   if        LastBufrFlag<>0 and Pos+Len=DataLn
     c                   eval      RRERTY = ErrTyp
     c                   eval      RRERDS = ErrDes
     c                   eval      RREOB = *blanks
     c                   end
/4537c                   eval      BufrLen = LastPos + Len
/4537c                   MOVE      BufrLen       rrERDS
     c                   eval      rc = CLSendData(%addr(REGRSP):%size(REGRSP))
     c                   if        rc < 0
     c                   return    rc
     c                   end
     c                   eval      RRSDT = *blanks
     c                   eval      LastPos = 0
     c                   else
     c                   eval      LastPos = LastPos + Len
     c                   end

     c                   eval      Pos = Pos + Len
     c                   enddo

     c                   return    DataLn
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Send Response data
/3765p SndRspDta       b
     d                 pi
     d  RspDtaP                        *   value
     d  RspDtaLn                     10u 0 value
     d  LastBufrFlag                 10i 0 value

      * Response Header
/3765d RspHdrDS        ds
     d  rhHdrSiz                      5  0
     d  rhBufLen                      5  0
     d  rhMajMinVer                   5
     d  rhDtaSiz                      5  0
     d                               44

     d  rc             s             10i 0
     d  @MaxBuf        c                   8100

      * build and send the response header
     c                   clear                   RspHdrDS
     c                   eval      rhHdrSiz = %size(RspHdrDS)
     c                   eval      rhBufLen = @MaxBuf
     c                   eval      rhMajMinVer = sMajMinVer
     c                   eval      rhDtaSiz = RspDtaLn
     c                   eval      rc=SendData(%addr(RspHdrDS):%size(RspHdrDS):
     c                                         @MaxBuf:0)
      * send the data
     c                   eval      rc=SendData(RspDtaP:RspDtaLn:
     c                                         @MaxBuf:LastBufrFlag)
     c                   return
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Document revision operations
/3765p DocRevision     b
     d                 pi

     d  RspP           s               *
     d  RspLn          s             10i 0
     d  rc             s             10i 0
     d  ErrID          s              7
     d  ErrDta         s            100
/5792d  RevID          s             10s 0
/    d  BatSeq         s              9s 0
/    d  RevType        s              1
/    d  LastRevID      s             10s 0
/8180d RqstP           s               *
/    d docType         s             10

      * operation
     c                   eval      @RTN  = '30'
     c                   eval      RspP  = *null
     c                   select
/8180c                   when      File ='COBJECTS'
/    c                   eval      rc = GetVCOContObj(%addr(REGREQ):RspP:RspLn)
     c                   when      OpCode = 'DMLST'
     c                   eval      rc = GetRevLst(%addr(REGREQ):RspP:RspLn)
     c                   when      OpCode = 'DMLCK' or
     c                             OpCode = 'DMULK' or
     c                             OpCode = 'DMUSR' or
     c                             OpCode = 'DMRVT'
     c                   eval      ErrID = DMSCtl(%addr(REGREQ):RspP:RspLn:
     c                                          PGMUSR:NodeID)
     c                   if        ErrID = *blanks
     c                   eval      @RTN  = '00'
     c                   end
/8180c                   when      OpCode = 'EDLNK'
/    c                   eval      ErrID = EditDocLink(%addr(xbfr))
/    c                   if        ErrID <> ' '
/    c                   eval      @rtn = '30'
/    c                   else
/    c                   eval      @rtn = '00'
/    c                   endif
     c                   endsl

/8180c                   if        rc=1 and (File='COBJECTS' or OpCode='DMLST')
/    c                   eval      @RTN  = '20'
/    c                   endif

      * send response buffer
     c                   callp     RtnStatus(@RTN:'DOCREV':File:ErrID:ErrDta)
     c                   if        @RTN <= '20'
     c                   select
     c                   when      OpCode = 'DMLCK' or
     c                             OpCode = 'DMULK' or
     c                             OpCode = 'DMRVT'
     c                   eval      rc=SendData(RspP:RspLn:8100:1)
     c                   other
     c                   callp     SndRspDta(RspP:RspLn:1)
     c                   endsl
     c                   eval      OPCDE = 'NORESP'
     c                   end
     c                   callp     mm_free(RspP:0)

     c                   eval      TableFile = 'Y'
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * SpyLinks Hit list
/3765p LnkHitList      b
     d                 pi
     d OpCode                         5    const

     d PgmActive       s              1    static inz(*OFF)
     d  RqstP          s               *
     d  RspP           s               *
     d  RspLn          s             10i 0

/4537d  KeyType        s             10
/    d  KeyData        s             20
     d  RevID          s             10i 0
     d  RqstHits       s             10i 0
     d  HitCount       s             10i 0
     d  rc             s             10i 0

      * shutdown sub-program
     c                   select
     c                   when      OpCode = 'INIT'
     c                   if        PgmActive = *OFF
     c                   CALL      'MCSPYHITR'   plLnkHit
     c                   eval      PgmActive = *ON
     c                   endif
     c                   return
     c                   when      OpCode = 'QUIT'
     c                   if        PgmActive = *ON
     c                   CALL      'MCSPYHITR'   plLnkHit
     c                   eval      PgmActive = *OFF
     c                   endif
     c                   return
     c                   endsl

/4537c                   eval      @File = FILE
     c                   eval      Handle = LIBR
     C                   MOVE      'NNN'         LNKSEC
      * Check if offline SpyLink (Key(51-55) is not empty)
     C                   MOVEA     KEY(51)       F5A
     C     ' ':'0'       XLATE     F5A           F5A
     C                   MOVE      F5A           @SEQ              5 0
     C     @SEQ          IFNE      *ZEROS
     C                   MOVEL(P)  @SEQ          OPLID
     C                   MOVEL(P)  'RLNKOFF'     OPLFIL
     C                   ELSE
     C                   CLEAR                   OPLID
     C                   CLEAR                   OPLFIL
     C                   ENDIF
      * versioned parms
     c                   if        sMajMinVer = *blanks
     c                   eval      Big5key = SKey
     c                   else
/    c                   if        SKey1 <> *blanks
     c                   eval      Big5key = x'00'+'RTYPEID  '+SKey1
/    c                   end
/4537c                   select
/    c                   when      SKey2 = '*IMAGENO' or
/    c                             SKey2 = '*HITSEQ'  or
/    c                             SKey2 = '*BATCH'
/    c                   if        %subst(SKey4:1:20) <> *blanks
/    c                   eval      KeyType = SKey2
/    c                   eval      KeyData = SKey4
/    c                   end
/    c                   when      SKey2 <> *blanks and
/    c                             SKey2 <> *zeros
     c                   testn                   SKey2                66
/    c                   if        *in66
/    c                   eval      KeyType = '*REVID'
/    c                   move      SKey2         RevID
/    c                   end
/    c                   endsl
     c                   if        SKey3 <> *blanks
     c                   testn                   SKey3                66
     c   66              move      SKey3         RqstHits
     c                   end
     c                   end
/5999 * Note: SKey4 (pos 1) contains Ascending/Descending Order flag (" ","A","D
/     * This is a "hint" used by NT to optimize it's Spylinks query processing

     c                   eval      RqstP = %addr(XBFR)
     c                   CALL      'MCSPYHITR'   plLnkHit
     c                   eval      PgmActive = *on

      * send response buffer
     c                   callp     RtnStatus(@RTN:'MCSPYHITR':@File:
     c                                                        MsgID:MsgDta)
     c                   if        @RTN <= '20'
     c                   if        sMajMinVer = *blanks
     c                   eval      rc=SendData(RspP:RspLn:7680:1)
     c                   else
     c                   callp     SndRspDta(RspP:RspLn:1)
     c                   end
     c                   eval      OPCDE = 'NORESP'
     c                   end
     c                   callp     mm_free(RspP:0)

     c                   eval      TableFile = 'Y'
     c                   return
      *========================================================================
     c     plLnkHit      PLIST
     c                   parm                    @FILE            10
     c                   parm                    HANDLE           10
     c                   parm                    Big5key          50
     c                   PARM      OpCode        OpCodeX          10
     c                   parm                    sMajMinVer
     C                   PARM                    LNKSEC            3
     c                   parm                    RqstP
     c                   parm                    RspP
     c                   parm                    RspLn
     C                   PARM      *blanks       @RTN
     C                   PARM      *BLANKS       MSGID
     C                   PARM      *BLANKS       MSGDTA
      * Optical parms 13-19
     C                   PARM                    OPLID            10
     C                   PARM      *BLANKS       OPLDRV           15
     C                   PARM      *BLANKS       OPLVOL           12
     C                   PARM      *BLANKS       OPLDIR           80
     C                   PARM                    OPLFIL           10
     C                   PARM      0             OVRL#             1 0
     c                   parm      RqstHits      HitCount
      * parms 20 - 23
/4537c                   parm                    KeyType
/    c                   parm                    KeyData
     c                   parm                    RevID
/5921C                   PARM      *loval        SHSFIL           10
      * Query parms 24-28
     C                   PARM                    AO
     C                   PARM                    FN
     C                   PARM                    TE
     C                   PARM                    QVF
     C                   PARM                    QRYTYP
/5635c                   parm                    nodeid
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * OmniLinks Hit list
/3765p OmniHitList     b
     d                 pi
     d OpCode                         5    const

     d PgmActive       s              1    static inz(*OFF)
     d  RqstP          s               *
     d  RspP           s               *
     d  RspLn          s             10i 0

/3765d  RevID          s             10i 0
     d  RqstHits       s             10i 0
     d  HitCount       s             10i 0
     d  rc             s             10i 0

      * shutdown sub-program
     c                   select
     c                   when      OpCode = 'INIT'
     c                   if        PgmActive = *OFF
     c                   CALL      'MCOMNHITR'   plOmniHit
     c                   eval      PgmActive = *ON
     c                   endif
     c                   return
     c                   when      OpCode = 'QUIT'
     c                   if        PgmActive = *ON
     c                   CALL      'MCOMNHITR'   plOmniHit
     c                   eval      PgmActive = *OFF
     c                   endif
     c                   return
     c                   endsl

     c                   eval      OmniName = SKey1
     c                   eval      Handle = LIBR
      * versioned parms
     c                   if        sMajMinVer = *blanks
     c                   eval      Big5key = %subst(SKey:11)
     c                   else
     c                   if        SKey2 <> *blanks
     c                   eval      Big5key = x'00'+'RTYPEID  '+SKey2
     c                   end
     c                   end

     c                   eval      RqstP = %addr(XBFR)
     c                   callp     timer('START')
     c                   CALL      'MCOMNHITR'   plOmniHit
     c                   callp     timer('STOP')
     c                   eval      PgmActive = *on

      * send response buffer
     c                   callp     RtnStatus(@RTN:'MCOMNHITR':OmniName:
     c                                                        MsgID:MsgDta)
     c                   if        @RTN <= '20'
     c                   if        sMajMinVer = *blanks
     c                   eval      rc=SendData(RspP:RspLn:7680:1)
     c                   else
     c                   callp     SndRspDta(RspP:RspLn:1)
     c                   end
     c                   eval      OPCDE = 'NORESP'
     c                   end
     c                   callp     mm_free(RspP:0)

     c                   eval      TableFile = 'Y'
     c                   return
      *========================================================================
     c     plOmniHit     PLIST
     c                   parm                    OmniName         10
     c                   parm                    HANDLE           10
     c                   parm                    Big5key          50
     c                   parm      OpCode        OpCodeX          10
     c                   parm                    sMajMinVer
     c                   parm                    RqstP
     c                   parm                    RspP
     c                   parm                    RspLn
     C                   PARM      *blanks       @RTN              2
/    c                   parm      *blanks       MSGID             7
/    c                   parm      *blanks       MSGDTA          100
     c                   parm      RqstHits      HitCount
/3765c                   parm                    RevID
     C                   PARM                    AO
     C                   PARM                    FN
     C                   PARM                    TE
     C                   PARM                    QVF
     C                   PARM                    QRYTYP            1
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * OmniLinks Report types
/3765p OmniRepTypes    b
     d                 pi
     d OpCode                         5    const

     d PgmActive       s              1    static
     d  RspP           s               *
     d  RspLn          s             10i 0
     d  rc             s             10i 0

      * shutdown sub-program
     c                   if        OpCode = 'QUIT' or
     c                             OpCode = 'INIT'
     c                   if        PgmActive = *on
     C                   CALL      'SPYCSHREP'   plORepTypes
     c                   end
     c                   return
     c                   end

      * Get the report types for an OmniLink
     c                   eval      OmniName = SKey1
     c                   CALL      'SPYCSHREP'   plORepTypes
     c                   eval      PgmActive = *on

      * send response buffer
     c                   callp     RtnStatus(@RTN:'SPYCSHREP':OmniName:
     c                                                        MsgID:MsgDta)
     c                   if        @RTN <= '20'
     C                   MOVE      RtnRecs       ERRDES
     c                   if        sMajMinVer = *blanks
     c                   eval      rc=SendData(RspP:RspLn:7680:1)
     c                   else
     c                   callp     SndRspDta(RspP:RspLn:1)
     c                   end
     c                   eval      OPCDE = 'NORESP'
     c                   end
     c                   callp     mm_free(RspP:0)

     c                   eval      TableFile = 'Y'
     c                   return
      *========================================================================
     c     plORepTypes   PLIST
     c                   parm                    OmniName         10
     c                   parm      OpCode        OpCodeX          10
     c                   parm                    sMajMinVer
     c                   parm                    RspP
     c                   parm                    RspLn
     C                   PARM      0             RtnRecs           9 0
     C                   PARM      '00'          @RTN              2
     c                   parm      *blanks       MSGID             7
     c                   parm      *blanks       MSGDTA          100
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Overlay template operations
/4537p OverlayOps      b
     d                 pi
     d OpCode                         5    const

     d PgmActive       s              1    static
     d  RqstP          s               *
     d  RspP           s               *
     d  RspLn          s             10i 0
     d  rc             s             10i 0
     d  MaxLn          s             10i 0 inz(8100)

     c                   eval      OpCodeX = OpCode
      * shutdown sub-program
     c                   if        OpCode = 'QUIT'
     c                   if        PgmActive = *on
     c                   call      'MCOVRLAYR'   plOvrLay
     c                   end
     c                   return
     c                   end
     c                   eval      PgmActive = *on

      * Do overlay template operations
/7747c                   if        SKey1 = '*SPYNBR'
/    c                   eval      RptTypeID = RtvDocType(SKey3)
/    c                   else
     c                   eval      RptTypeID = SKey1
/7747c                   endif
     c                   eval      OverlayID = SKey2
     c                   eval      RqstP = %addr(XBFR)
     c                   call      'MCOVRLAYR'   plOvrLay

      * block read processing for overlay images
     c                   if        OpCode = 'RTOVL' and @RTN = '00'
     c                   eval      OpCodeX = 'RTOVLcont'
     c                   dou       @RTN <> '00'
     c                   eval      rc=SendData(RspP:RspLn:MaxLn:0)
     c                   call      'MCOVRLAYR'   plOvrLay
     c                   enddo
     c                   end

      * send response buffer
     c                   callp     RtnStatus(@RTN:'MCOVRLAYR':RptTypeID:
     c                                                        MsgID:MsgDta)
     c                   if        @RTN <= '20'
     c                   eval      rc=SendData(RspP:RspLn:MaxLn:1)
     c                   eval      OPCDE = 'NORESP'
     c                   end
     c                   callp     mm_free(RspP:0)

     c                   eval      TableFile = 'Y'
     c                   return
      *========================================================================
     c     plOvrlay      PLIST
     c                   parm                    OpCodeX          10
     c                   parm                    sMajMinVer
     c                   parm                    RptTypeID        10
     c                   parm                    OverlayID        10
     c                   parm                    RqstP
     c                   parm                    RspP
     c                   parm                    RspLn
     C                   parm      '00'          @RTN              2
     c                   parm      *blanks       MSGID             7
     c                   parm      *blanks       MSGDTA          100
     c                   parm                    MaxLn
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get page info for a image/document
/4537p GetPageInfo     b
     d                 pi
     d OpCode                         5    const

     d RevID           s             10i 0
     d ContID          ds            20
     d  ciBatNum                     10
     d  ciBatSeq                      9s 0
     d Pages           s             10i 0

     d PagInfoDS       ds
     d  PageCnt                      10
     d  ImgSize                      10

     c                   reset                   DocFncRtnStsDS
     c                   eval      @RTN = '00'
     c                   eval      SDTds = *blanks
     c                   eval      PagInfoDS = *zeros
      * rev or content id
     c                   select
     c                   when      SKEY1 <> *blanks
     c                   MOVE      SKEY1         RevID
     c                   eval      ContID = GetContID(RevID)
     c                   if        ContID = *blanks
     c                   eval      @RTN = '20'
     c                   end
     c                   when      SKEY2 <> *blanks and SKEY3 <> *blanks
     c                   clear                   ContID
     c                   MOVEL(p)  SKEY2         ciBatNum
     c                   MOVEL     SKEY3         ciBatSeq
     c                   other
     c                   eval      @RTN = '20'
     c                   endsl
      * get size and page count
     c                   if        @RTN = '00'
     c                   if        OK<>GetDocAttr(ciBatNum:ciBatSeq:DocAttrDS)
     c                   eval      @RTN = DocFncRtnSts(DocFncRtnStsDS)
     c                   else
     c                   move      da_FileSize   ImgSize
     c                   if        OK = IsTiffImage(da_FileExt)
T4730c                   if        OK<>GetDocPageCnt(ciBatNum:ciBatSeq:Pages)
     c                   eval      @RTN = DocFncRtnSts(DocFncRtnStsDS)
     c                   else
     c                   move      Pages         PageCnt
     c                   eval      SDTds = PagInfoDS
     c                   end
     c                   end
     c                   end
     c                   end
      * response structure
     c                   callp     RtnStatus(@RTN:'PAGEINFO':ContID:
     c                                       dfRtnMsg:dfRtnMsgDta)
     c                   return
/4537p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert content id (batch/seq) to rev id
/4537p Cvt2RevID       b
     d                 pi
     d OpCode                         5    const

      * client request/response
     d c1RqstDS        ds
     d c1RevType                      1
     d c2RespDS        ds
     d c2RevID                       10
     d c2ContID                      20

/8180d RevType         s              1
     d RevID           s             10i 0
     d ContID          ds            20
     d  ciBatNum                     10
     d  ciBatSeq                      9s 0

     c                   eval      @RTN = '00'
     c                   eval      SDTds = *blanks
     c                   eval      c1RqstDS = XBfr
     c                   eval      c2RespDS = *blanks
      * batch/seq or content id
     c                   select
     c                   when      SKEY2 <> *blanks and SKEY3 <> *blanks
     c                   clear                   ContID
     c                   MOVEL(p)  SKEY2         ciBatNum
     c                   MOVEL     SKEY3         ciBatSeq
     c                   when      SKEY4 <> *blanks
     c                   MOVEL     SKEY4         ContID
     c                   other
     c                   eval      @RTN = '20'
     c                   endsl
      * rev type
     c                   if        @RTN = '00'
     c                   select
     c                   when      c1RevType = '0'
     c                   eval      RevType = Rt_Lowest
     c                   when      c1RevType = '1'
     c                   eval      RevType = Rt_Highest
     c                   when      c1RevType = '2'
     c                   eval      RevType = Rt_Head
     c                   other
     c                   eval      @RTN = '20'
     c                   endsl
      * get the revision
     c                   if        @RTN = '00'
     c                   eval      RevID=GetRevByContID(ContID:RevType)
     c                   move      RevID         c2RevID
     c                   move      ContID        c2ContID
     c                   end
     c                   end
      * response structure
     c                   eval      SDTds = c2RespDS
     c                   callp     RtnStatus(@RTN:'CVTREVID':ContID)
     c                   return
/4537p                 e
/8179
/8179p*-------------------------------------------------------------------------
/8179p*- Get the current user's SMTP address
/8179p*-------------------------------------------------------------------------
/8179pGetUsrAddr       b
/8179d GetUsrAddr      pi           256
/8179
/8179d smtpAddr        s            256    inz(*blanks)
/8179
/8179c                   call      'SPYMLRSN'
/8179c                   parm      pgmusr        prmUser          10
/8179c                   parm                    smtpAddr
/8179c                   parm                    prmDesc         256
/8179
/8179c                   return    smtpAddr
/8179
/8179p                 e
/8179
** ERROR MESSAGES
ERR1364 04 END/TOP OF FILE REACHED
ERR1371 11 TERMINAL ERROR
ERR1374 14 PGM EXCEPTION ERROR
ERR1372 12 USER LICENSE EXCEEDED
ERR1373 13 INVALID SPYVIEW AUTHORIZATION
ERR1369 06 TOP OF FILE REACHED
ERR137A 15 Not authorized to delete annotation.
ERR137B 16 Not authorized to delete template.
ERR137C 01 Object not found.

F5953h bnddir('SPYSPCIO':'SPYMAIL':'SPYBNDDIR')
      /copy directives

      *********-------------------------------------
      * MAG210  Print/Fax/Send Window  calls Mag2039
      *********-------------------------------------
      *

     FMAG210FM  CF   E             WORKSTN INFDS(INFDS)
     F                                     USROPN
     FMIMGDIR   IF   E           K DISK    USROPN
     FMFLDDIR   IF   E           K DISK
     FMRPTDIR7  IF   E           K DISK
     F                                     RENAME(RPTDIR:RPTDIR7)
     FRPTABLE   IF   E           K DISK
     FRPRTDJE   IF   E           K DISK
     FRBNDBAN   IF   E           K DISK
     FRBNDINS   IF   E           K DISK
     FRMAINT1   IF   E           K DISK
/1892FRMAINT4   IF   E           K DISK    UsrOpn
/    F                                     Rename(RmnTrc:RmnTrc4)
     FSPYCTL    IF   E           K DISK
     FRWINDOW   IF   E           K DISK    USROPN
/3523F@PFA      IF   E             DISK    USROPN extdesc('QAFDSPOL')
      *
      *  Indicator:  21  ALLOW COMMAND
      *              25  Allow check(er)
      *              26  Dspsize = 132
      *              43  Exfmt ADDITIONAL PARMS screen on Enter key
      *              54  Exfmt ADDITIONAL PARMS screen on F10
      *              43  Exfmt ADDITIONAL PARMS screen on Enter key
/6842 *              86  Email To Address is dirty
      * Called by:
      *     DSPHYPLNK  Display OmniLinks
      *     MAG203     Viewer
      *     MAG8040    WorkView - Exit Program for *SPYLINK
      *     MAG8042    WorkView - Exit Program for *REPORT
      *     MAG8043    WorkView - Exit Program for *SEGMENT
      *     PRTBND     Print Bundle
      *     PRTFLD     Print ALL Reports in a Folder
      *     SNDOBJSPYR Send SpyView Object
      *     WRKBHS     Work with Bundle History
      *     WRKCBN     Work with Current Bundle/Segment Subset
      *     WRKRDR     Work with Reports
      *     WRKRSG     Work with Report Segments for MRPTDIR
      *     WRKSPI     Work with SpyLink Indices
      *
J4788 * 12-11-16 PLR Rework multi-email selection process. Added separate
      *              module (MGEMLSLT).
J6624 * 08-23-16 PLR Prevent user from creating library when outputting document
      *              to disk from report viewer, option (P)rint>2(OutFile).
      *              The default library can be specified by admin on the
      *              document type config screen. If specified, a user cannot
      *              change the target library.
J4788 * 08-17-15 EPG Implement debug statements.
J5954 * 02-23-15 EPG Name of destributed PDF attachment is the bundle name
      *              and in a previous release it used to be the report type.
J5953 * 02-23-15 EPG Dynamically change the setting for SpoolMail based
J5953 *              on the SpoolType being processed.
5978  * Add SpySpcIO binding directory
J4788 * 09-26-14 EPG Refactor email selection.
J5660 * 04-09-14 EPG Trap an error when attempting to join spooled files.
J4748 * 02-26-13 EPG Provide for a postion to entry in the email configuration
/     *              list.
J4643 * 01-22-13 EPG Fix an issue where the counter variable used was a short
/     *              integer capable of only holding three significant digits.
J3479 * 09-04-12 EPG Override the  out queue with the default out queue
/     *              associated with the writer when the writer is specified
/     *              and the out queue is not manually entered. Retain the out queue
/     *              associated with the writer, if a specific writer is
/     *              configured. Generate a message if both the out queue
/     *              and writer are manually enter.
J3337 * 10-27-11 EPG Undo the prior change in J2459 that had previously
/     *              commented out the loop counter value in the for loop.
J2459 * 02-16-11 EPG Correct an issue with the for loop counter.
J2473 * 04-08-10 PLR Export TIFF to PDF.
J2399 * 03-18-10 EPG Enhance EXPOBJSPY to output to the IFS as PDF.
J1554 * 02-18-10 EPG Enable Email Logging
J2149 * 11-04-09 PLR Allow field OUTFLB in display record FILOUT to be input
      *              capable. Used when sending a report to an outfile. Still
      *              defaults to SPYEXPORT. Removed one line of code.
      *              MOVE '1' SEC(28).
/1936J* 07-27-09 EPG Modify GetEmailCnt procedure to by traversing the
/     *              subfile using a for loop instead of a do while
/     *              in order to avoid an errouneous message in the job
/     *              log.
/1892 * 06-23-09 EPG The return code from a failed chain to RMAINT did not
/     *              get populated and perculate up the stack.
T7319 * 10-29-08 EPG Modified the procedure PutEmailSpc by preventing an
      *              entry of a duplicate Email into the user Space.
T7353 * 10-29-08 EPG Spoolmail integration problem that was
      *              preventing normal print operations.
/7063 * 05-29-08 EPG The field FAXSAV from the local data area overlays the
/     *              memory allocated for the message text. Conditionally
/     *              prevent the value FAXSAV from being set to 'N' if MLSPML
/     *              is set to 'Y' when SpoolMail is enabled.
/7065 * 05-27-08 EPG Unable to print from archive, when SpoolMail is enabled.
/7063 * 05-27-08 EPG Emailing multiple doclink or omnilink hits ends in error.
/     *              Recent enhancments were not populating the processing
/     *              data queue with the correct records. One or more dataq
/     *              'page' records followed by a 'quit' dataq record for
/     *              each request.
T6842 * 02-08-12 EPG Additionally purge the data area QTEMP/MLARA
/     *              positions 546 to xxx.
/     * 02-08-11 EPG The functionality of the F10 key is globally
/     *              controlled via the system environment field
/     *              REQF10. Retain the global attribute of the F10
/     *              key, but toggle access to the F10 key when the
/     *              EmailSltC1 is selected.
/
/     * 02-08-08 EPG Include the following usability enhancements:
/     *              - If the *list values from the user space
/     *                can fit on the visible prompt, then show
/     *                these values.
/     *              - If *list is typed over, then clear the list
/     *                and only use the entries.
/     *              - If F4 is used to select multiple entries,
/     *                and the list is redisplayed then those items
/     *                selected should appear at the top of the list.
/6692 * 11-30-07 EPG Mutliple DocLink attachments prevented from being
/     *              sent. Place a wrapper around the subroutine
/     *              clsdq to only be called if the rtncde passed into
/     *              it contained the value CLOSEW.
T6375 * 06-11-07 PLR Prevent SpoolMail from processing natively archived
      *              PDF documents.
/5505 * 05-14-07 EPG Revisit the subfile maintenance when combined with
/     *              adding subscribers. If a new subscriber, or
/     *              subscriber list is detected to be added from
/     *              the work with screen, it is assumed that this
/     *              needs to be added. Subsequently, it will be added
/     *              to the subfile screen preselected.
/6302 * 05-09-07 EPG Populate the out queue with the FASTFAX/FFXOTQAPI if the
/     *              spooled file is *USERASCII.
T5978 * 03-27-07 PLR While testing another SAR, it was noticed that the emailing
      *              of images no longer functions. Code implemented under this
      *              SAR caused the problem.
      * 02-14-07 EPG When the F4 key is pressed, if the
      *              userspace exist, populate the subfile
      *              with the entries from the userspace.
      *              into the subfile, and delete the user
      *              space. If the subfile is exited with
      *              F3 or F12 remove the entries from the
      *              subfile, and delete the user space.
      *              If the subfile is exited with an F10
      *              Save the entries.

/5978 * 02-12-07 EPG Extend the functionality of Email to
/     *              honor persistance.

/5978 * 01-16-07 EPG Extend that capacity of the Email inter
/5978 *              face enabling the prompt for addresses
/5978 *              subscribers, and subscriber lists to be
/5978 *              entered into a subfile interface.

/5736 * 10-09-06 EPG Formtype of an spooled file rendered from
/5736 *              an image is being populated with a value of
/5736 *              '*ORIG' when it should be populated with
/5736 *              '*STD'
/5736 *

/5505 * 08-07-06 EPG No prompting ability exists for selecting from a
/5505 *              subscription list.
/5500 * 07-13-06 EPG Un-initialized values in Send Email screen
/5469 * 07-10-06 EPG Enable native PDF documents to be distributed.
      *              When a native PDF document is being selected to
      *              distribute with email, populate the attachment type
      *              with *PDF.
/6708 * 11-19-03 JMO Changed calls to use complete pgm name rather than CAT'ed name
/7564 * 07-11-03 PLR IBM SBMFAX was receiving error due to invalid characters
/     *              in the comment field. This is because of packed data fields
/     *              overlaying the same area in the LDA.
/7687 * 01-29-03 PLR SNDFAX command failing because image file output to
/     *              spoolfile was still named SPYIMG was expecting DOCIMAGE.
/     *              Probably product of rebranding in 8.0.
/6924 * 11-20-02 PLR Add FaxCom.
/6996 * 09-30-02 JMO Changed to honor the 256 character limit on spoolmail text
/7112 * 09-11-02 PLR Add *ORIG to formtype when printing.
/6923 * 08-07-02 PLR Prevent loss of form type when faxing.
/6847 *  7-08-02 DLS Ensure proper error messages are displayed on additional
/6847 *              print parameters for images.
/6763 *  7-03-02 DLS Add ability to print text on scaled image
/6763 * -----------> NOTE:  When any new edits and logic are coded in here
/6763 *                     the same should be required in MAG210 and visa versa.
/6641 *  6-18-02 DLS Edit page range for image processing.  This is not a full
/6641 *              and accurate edit but will eliminate obvious errors.
/6521 *  6-06-02 DLS Allow for differant help screen when emailing a report.
/6522 *  6-04-02 DLS For Printer type *RPC or *LPC retain parameter values.
/6609 *  5-15-02 DLS Add INTERFACE parameter for Gumbo SpoolMail support.
/5939 * 04-25-02 DLS Additional logic for email format & ext.
/2937 * 03-21-02 RA  Global Save/Hold overrides
/5939 * 01-10-02 PLR Suppress Join option when emailing.
/5329 *  9-07-01 KAC Revise Notes print selection (seperate parm)
/2720 * 09-04-01 PLR INITIAL REPORT FAX DEFAULTS NOT ACKNOWLEDGED.
/5220 * 08-23-01 PLR PREVENT LOSS OF FORM TYPE DATA WHEN PRINTING
/4876 * 06-28-01 PLR Pass CPI & LPI in LDA for FastFax.
/3585 *  6-07-01 KAC ADD HOLD,SAVE,COPIES TO PRTARA
/4625 *  6-06-01 KAC Fix number of copies on join.
/3393 *  2-16-01 DLS Add IGNBATCH parameter
/3394 * 02-02-01 DLS ENSURE THAT FAXNUM IS BEING BLANKED OUT IN LDA PRIOR
/3394 *              TO PRINT.  ANY VALUE IN HERE WILL CAUSE MAG2038 TO
/3394 *              ASSUME THIS IS A FAX AND NOT ALLOW LOGIC TO FALL INTO
/3394 *              PROPER PRINT CYCLE, THUS CAUSING COVER PAGES TO BE PRINTED
/3394 *              WITH REGULAR TEST.
/3390 * 01-30-01 DLS DUPLEX parm will use same default logic as original
/3390 *              GETDFT subroutine.
/3523 * 12/21/00 JAM Printer file overrides.
/3523 *              If a SpyPrinter is assigned with a printer file,
/3523 *              the hold and save attributes for that printer file
/3523 *              apply. If no SpyPrinter is assigned, but a printer
/3523 *              file is assigned, then the hold and save attri-
/3523 *              butes for that printer file apply. If either of
/3523 *              these circumstances exist, the printer file,
/3523 *              printer file library, and printer are NOT saved
/3523 *              for the CURRENT print run like other user selections.
/3523 *              This is because we wouldn't want a forced override
/3523 *              to affect every following spool file. Only if no
/3523 *              forced override exists will the user's current
/3523 *              selections be saved to the *LDA to be re-used
/3523 *              for the next selection.
/3523 *              Also, if a SpyPrinter and a printer file have been
/3523 *              assigned, the printer file associated with the
/3523 *              SpyPrinter overrides. If the user blanks out the
/3523 *              SpyPrinter in this type of circumstance, then the
/3523 *              assigned printer file will be used. If the user
/3523 *              blanks out both the assigned SpyPrinter and the
/3523 *              assigned printer file, then the hold and save
/3523 *              attributes of the archived spool file are used.
/3524 * 12-14-00 KAC Change the messages for default values used.
/3331 * 11-17-00 KAC PRINTER TYPE NOT SET ON IMAGES GOING THRU DTAQ
/1964 * 11-15-00 PLR AFTER PRINTING, WAS UPDATING PRTARA DTAARA. CAUSING
/3291 * 11-14-00 KAC Fix outq not being passed from prompt.
/1452 * 10-31-00 JAM PREVENT LOSS OF SCREEN DATA ON HELP.
/2119 * 10-18-00 DLS CORRECT FAXING ERROR FROM RA ON/ 2873 and ensure
      *              process works for FASTFAX.
/2971 * 09-21-00 JAM Prevent loss of default outq.
/2930 *  9-18-00 KAC Add CodePage parameter
/813  *  7-26-00 KAC REAPPLY REVISED NOTES CHANGES
/2806 * 07-26-00 DLS Allow for SPYPRINTER values for printer attributes
/2873 * 07-24-00 RA  CORRECT FAXING ERROR
/2881 * 07-21-00 KAC ADD PARM PASSED CHECK FOR "Add IFS destination (OpCd=I)"
/2497 * 05-31-00 KAC ADD PDF FORMAT OPTION FOR EMAIL.
/2757 *  5-26-00 DM  Default for Duplex parameter not correct.
/2455 *  2-16-00 DLS Allow for HOLD & SAVE spoolfile on print
/2409 *  2-01-00 JJF Prevent emailing if SysEnv's MLACT=N
/2403 *  1-24-00 DM  User Exit FaxF4 for FAXSYS not returning faxnum  2403HQ
/2270 *  1-06-00 GT  Fix formatting of REMFIL/REMLIB for Cornerstone  2270HQ
      *              Was using FAXRE and FAXTX5 but MAG2038 expected
      *              just FAXRE
      * 10-04-99 KAC REMOVE REVISED NOTES CHANGES
      *  9-15-99 KAC FIX SPYAPICMD BATCH FAXES
      *  9-14-99 JJF Add IFS destination (OpCd=I)
      *  8-02-99 KAC REVISE NOTES INTERFACE
      *  7-01-99 JJF Let user change page from-to (in entry range)    1978HQ
      *  6-30-99 JJF If SpyLink, ignore 3 Env vars in SR GETENV       1762HQ
      *  5-10-99 JJF Allow more PRTTYP values for Rpts in SR CHKTYP.  1775HQ
      *  5-03-99 JJF Get FastFax's RPNAME and CPNAME from entry @FXTO2
      *  3-29-99 JJF Write FCFC char in output dasd file in *SHRFLD
      *  3-18-99 KAC ADD A FLAG FOR INITIALIZING PRINT SELECTIONS.
      *  3-08-99 KAC MOVE NOTES CODE TO SPYCSNOT.
      *  3-02-99 FID Faxing Images is now checked through SPYCTL file
      *  2-08-99 GT  Remove setting DQACT to Y for OmniServer print
      *              Was bad RQOP value to be used on subsequent requests
      * 12-29-98 JJF Protect pg#s if SpyLink w/limit scrol
      * 12-22-98 KAC USE NEW NOTES FILES.
      * 12-17-98 FID Added Support for Email parms
      * 11-10-98 JJF Clarify FastFax error diagnostics (SR CHKFX1)
      * 10-26-98 JJF Call Mag2031 to get viewer environment (SR GETENV)
      * 10-08-98 JJF Limit FaxStar's form name to 8 char
      * 10-06-98 GT  Fix setting of PRTTYP field when blank (bad compare)
      *  9-04-98 GT  Change LDA email structure to include MLIND value
      *  9-01-98 GK  Validate and prompt Email addr type.
      *  8-25-98 GK  Fix prt outside of links bug.
      *  8-17-98 GK  Faxes were not working with SpyApiCmd.
      *  8-11-98 GK  Attach a document to a fax (FaxStar).
      *  8-11-98 GT  Remove HX40:HX41 cover page translation--no one
      *              knows why this was there, and causing print problems
      *              on some printers.
      *  8-04-98 KAC Add report printing for omniserver
      *  8-03-98 GK  Fix Rmaint values in FaxStar screen.
      *  7-28-98 GK  Move cover page to TelexFax screen again.
      *  7-20-98 JJF Use RLMTSC (limit scroll) from RMAINT if non-blank
      *  7-17-98 GK  Pass NodeId for *RPC print w/out F10.
      *  7-15-98 GK  Now Fax OutQ always dft to SysEnv Fax OutQ.
      *  6-13-98 FID Add new Email Formats
      *  6-11-98 GK  Move cover page to TelexFax screen.
      *  6-05-98 GK  Give Err msg if Fax command fails.
      *  5-22-98 GK  Add the IBM SbmFax command.
      *  4-22-98 GT  Use node ID from RPTABLE if SpyPrinter is selected.
      *  4-20-98 GK  If OutQ is not blank and OutQL is blank load
      *              load *LIBL into OutQL
      *  4-16-98 DM  Add sysdft sduplx field default..Sony
      *  2-26-98 GK  Prompt Command driven faxes.
      *  2-25-98 GK  Add FRMNAM to FAXTLX screen.
      *  2-21-98 kac Add support for imageview type reports
      *  2-03-98 kac Add support for r/dars type reports
      *  1-15-98 GT  Move '*RPC' into CHKSRV opcode for RPC check
      *  1-13-98 GK  Show Enviro fields on Print screens.
      *  1-05-98 GT  Fix page range validation when RMAINT has start page
      * 12-22-97 GK  Dont allow printing outside SpyLink Link range if
      *              LnkScroll=Y
      * 12-10-97 GK  Fix OutQ bug on SpyApiCmd/Faxstar Batch mode.
      * 11-05-97 JJF Call Mag1060 for auth to chg the print Job Desc
      * 10-24-97 GT  Correct changing of outq when no add'l parm prompt
      * 10-09-97 GT  Change outq/writer selection logic in GETDFT
      * 10-20-97 GK  Add *Fax/ACS logic.
      * 10-02-97 GK  Add *FaxServer logic.
      *  9-24-97 GK  Add *TelexFax logic.
      *  9-12-97 GK  Disallow zero/blank in ToPage on PrtWdw screen.
      *  5-27-97 GT  Change RMAINT no hit in CHKRPT to clear fields
      *              fields used instead of error message.
      *  5-20-97 GT  Add OBJTY condition in MG2039 to correct overlay
      *              of LDA fields by cover sheet array.
      *  5-15-97 GT  Create MOVPRM routine to correct parm overlay
      *              on re-entry with join.
      *  5-13-97 GT  Add REFX value to FaxStar prompt screen;
      *              If FaxStar, first 16 bytes of parm @FXSID has REFX
      *              Rearranged LDA fields
      *  5-12-97 GT  Add page range ENTRY parm (@PGRNG-->IMGPAG)
      *  4-28-97 JJF If no addit parms screen, chg bad OutQ to *USRPRF.
      *              If parms screen, put error msg to screen.
      *  3-24-97 JJF If SysDft OutQ=*RPTCFG & OQ non-exist, use *USRPRF
      *  1-15-97 JJF Use SysDft (SPTRTY) for Printer Type default.
      *  1-13-97 JJF Elim infin loop when OUTQ,WRITER not bl & PROMPT=Y
      *  1-07-97 GK  Fix multiple SpyLnk print bug.
      * 11-11-96 JJF Add duplex printing entry parms & screen fields
      *  9-18-96 JJF Don't get from&to pages from ENVIRO.
      *  8-31-96 JJF Add Fax function and Image handling.
      *  8-13-96 Fid For spool join, send data que msg to MAG2038.
      *  7-02-96 PAF Fix mag210 clearing screen when called recursively
      *

/     * ProtoTypes ------------------------------------------------
      *
J4788 /include mgemlslth
J5954 /include @MASPLIO
J5954 /include qsysinc/qrpglesrc,qusrspla
J5953d IsSplMail       pr              n
J5953d IsFormatError   pr              n

J3479d GetWtrInfo      pr                  ExtPgm('QSPRWTRI')
/    d  pRcvVar                     320a
/    d  pRcvVar                      10i 0 const
/    d  pFormat                       8a   const
/    d  pPrinter                     10a   const
/    d  pError                             likeds(APIError)

/7319D QUsPtrUs        PR                  ExtPgm('QUSPTRUS')
/    D  UserSpaceName                20A   Const
/    D  pSpacePtr                      *
/    D  ErrorCode                          Options(*NOPASS)
/    D                                     LikeDS(APIError)

/5978d SpyHelp         pr                  ExtPgm('SPYHLP')
/    d  pFile                        10a   const
/    d  pRecord                      10a   const
/
     d SpyLoUp         pr                  ExtPgm('SPYLOUP')
     d  pLower                       60a
     d  pUpper                       60a

/5978d/copy @spyspcio

/7319d APIError        ds                  qualified
/    d  intBytesP                    10i 0 inz(%size(APIError))
/    d  intBytesA                    10i 0 inz(*zero)
/    d  MsgID                         7    inz(*blanks)
/    d  Resvr                         1
/    d  MsgDta                      240    inz(*blanks)

J1554 /include @memlio
      * Constants -------------------------------------------------
J5953d PRTTY_AFPDS     c                   '*AFPDS'
J5953d PRTTY_IPDS      c                   '*IPDS'
J5953d PRTTY_AFPDSLINE...
J5953d                 c                   '*AFPDSLINE'
J5953dMLFMT_PDF        c                   '*PDF'
J5953dMLFMT_TXT        c                   '*TXT'
J5660d PARMNUM_@ADTYP  c                   76
J3479dUSRPRF           c                   '*USRPRF'
/     * Retrieve outqueue from user profile
/    dWTRI0100         c                   'WTRI0100'
/     * API Writer info format name for QSPRWTRI
      * Native PDF file
T5469d NATIVEPDF       c                   '4'
T5469d TRUE            c                   '1'
T5469d FALSE           c                   '0'
J1554d YES             c                   'Y'
/    d NO              c                   'N'
J2399d RQOP_QUIT       c                   'Q'
/     * Data Queue subfield signifying
/     * quit
/    d RQOP_IFS        c                   'I'
/     * Data Queue subfield signifying
/     * text conversion
/    d RQOP_IFSPDF     c                   'A'
/     * Data Queue subfield signifying
/     * PDF conversion
/    d ADTYP_IFS       c                   'I'
/    d ADTYP_IFSPDF    c                   'A'

      * Data Structures --------------------------------------------
J3479 /include qsysinc/qrpglesrc,qsprwtri

J4788  dcl-ds mailEntry likeds(mailEntry_t);
J4788  dcl-s getMailOpcode char(10);

      * variables --------------------------------------------------
J5953d blnTextOnly     s               n
J5953d blnIsSplMail    s               n

/1892d OpnImg          s              1a   inz(*blanks)
T5469d blnNativePDF    s               n   INZ(FALSE)
     D LOC             S              7    DIM(3)                               Folder Loc
     D ERR             S              7    DIM(29) CTDATA PERRCD(1)
/3523D CL              S             79    DIM(6) CTDATA PERRCD(1)
     D SEC             S              1    DIM(100)                             Security Flags
     D @SEC            S              1    DIM(100)                             Security Flags
     D TMP             S              1    DIM(247)                             Temporary Data Holde
     D FS              S             11    DIM(40) CTDATA PERRCD(1)             Faxfld table
     D FP              S             10    DIM(40) ALT(FS)
/6641D pagtmp          S                   like(imgpag)                         Temporary Page Range
     D
     D @TXT            S             65    DIM(5)                               Text Lines Email
     D NSDT            S              1    DIM(7680)
/6996D Idx             s              3  0
/6996D chk_txt         s            330

      * Data Structures ----------------------------------------------------------------
     D QDTA            DS          1024    INZ
      *           Data queue data  (& DIRqst for DspImgA pgm)
     D  BTCHNO                 1     10
     D  @FILE                 20     29
     D  ACTION                42     42
     D  STROFS                43     49
     D  ENDOFS                50     56
     D  JOINS                 57     57
     D  PCPRT                 58     59
     D  RMTUSR                60     69
     D  PCCOPY                70     72  0
     D  PCSTRP                73     81  0
     D  PCENDP                82     90  0
     D  PCIMGP                91    110
     D  SDTRC1               257    512
     D  SDTRC2               513    768
     D  SDTRC3               769   1024

     D SDT             DS           768
     D  SDT1                   1    256
     D  SDT2                 257    512
     D  SDT3                 513    768
     D  SDTNAM               507    516
     D  SDTSPG               526    534
     D  SDTEPG               535    543
     D  SDTSEC               544    546
     D  SDTTYP               547    547
     D  SDTFIL               548    555
     D  SDTEXT               556    557
     D  SDTLIB               558    567
     D  SDTBI5               568    617
     D  FILNA2               568    577
     D  JOBNA2               578    587
     D  PGMOP2               588    597
     D  USRNA2               598    607
     D  USRDT2               608    617
     D  SDTLOC               618    618
     D  SDTNOT               619    619
     D  SDTFEX               620    624
     D  SDTTPG               625    633
     D  SDTRO#               634    642
     D  SDTRF#               643    651
     D  SDTMOD               652    652

     D  FLDR1                  1     10
     D  FLDRL1                11     20
     D  FILNA1                21     30
     D  JOBNA1                31     40
     D  USRNA1                41     50
     D  JOBNU1                51     56
     D  FILN#C                57     65
     D  SDTNA1                66     75
      *                                      66  75 sdtna1
     D @SDT            DS           768

     D @OBJD           DS           180
     D  OBJLIB                19     28
     D  OBJAT3                91     93

     D INFDS           DS
     D  #KEY                 369    369
     D  CSRLOC               370    371B 0
     D  WINLOC               382    383B 0

     D @CVRTX          DS           780
     D CVRTXT          DS           780
      *             Duplex print
     D  CTEXT1                 1     65
     D  CTEXT2                66    130
     D  CTEXT3               131    195
     D  CTEXT4               196    260
     D  CTEXT5               261    325
     D  CTEXT6               326    390
     D  CTEXT7               391    455
     D  CTEXT8               456    520
     D  CTEXT9               521    585
     D  CTEXTA               586    650
     D  CTEXTB               651    715
     D  CTEXTC               716    780

     D RECIP           C                   CONST('*RECIPIENT')
     D DFTJBD          C                   CONST('SPYGLSPRT')
     D NUM             C                   CONST('0123456789 ')

     D F3              C                   CONST(X'33')
     D F4              C                   CONST(X'34')
     D F9              C                   CONST(X'39')
     D F10             C                   CONST(X'3A')
     D F12             C                   CONST(X'3C')
     D F13             C                   CONST(X'B1')
     D F21             C                   CONST(X'B9')
     D F22             C                   CONST(X'BA')
     D HELP            C                   CONST(X'F3')
     D PRVPG           C                   CONST(X'F4')
     D NXTPG           C                   CONST(X'F5')

     D PROTEC          C                   CONST(X'A0')
     D NONDSP          C                   CONST(X'A7')


     D DQMSG           DS           256
      *             Data Que Message
     D  RQOP                   1      1
     D  RQOBTY                 2      2
     D  RQRPT                  3     12
     D  RQFRM                 13     22
     D  RQUD                  23     32
     D  RQSPAG                33     39  0
     D  RQEPAG                40     46  0
     D  RQPTRA                47     55  0
     D  RQPTRD                56     64  0
     D  RQPTRP                65     73  0
     D  RQFLDR                74     83
     D  RQFLIB                84     93
     D  RQLOC                 94     94
     D  RQOPTF                95    104
     D  RQPTYP               105    114
     D  RQIDX                115    124
     D  RQMBR                125    134
     D  RQPWND               135    135
     D  RQEUSR               136    145
     D  RQENAM               146    155
     D  RQNWND               156    158  0
     D  RQIMPG               159    178
/5329d  rqNotesPrint         179    179

2459Jd PriorDQMsg      ds                  likeds(DQMsg) inz(*likeds)

     D SYSDFT          DS          1024
     D  LMENU                121    121
     D  LCKF21               223    223
     D  PROPLC               231    240
     D  OQOPLC               241    250
     D  #FAXSV               230    230
     D  FAXTYP               251    251
     D  LFXOUT               257    266
     D  LFXLIB               267    276
     D  LPGMLB               296    305
     D  DTALIB               306    315
     D  LNKSCR               370    370
     D  APPSEC               373    373
     D  LBANID               374    383
     D  LINSTR               384    393
     D  REQF10               497    497
     D  SYSNOD               541    557
     D  SPTRTY               581    590
     D  SFXF4P               592    601
     D  SFXF4L               602    611
     D  SDUPLX               722    722
     D  MLACT                771    771
     D  ACMDCD               773    773
     D  EMLTYP               774    774
/5939D  EMLEXT               775    777
     D  RPPRTS               790    790
/2937D  GRPHLD               866    866
/2937D  GRPSAV               867    867
/6609D  USESPM               868    868                                         SpoolMail for report
/1554D  LOGEML               961    961
     D                 DS
     D  PLIBR                 11     20
     D PGMD          ESDS                  EXTNAME(CASPGMD)
      *             Program status
     D ERROR           DS           256
     D  BYTPRV                 1      4B 0
     D  BYTAVA                 5      8B 0
     D                 DS                  INZ
      *             Screen hide/protect attr bytes
     D  ATR                    1    100
     D                                     DIM(100)                             Atributes
     D  ATRB1                  1      1
     D  ATRB2                  2      2
     D  ATRB3                  3      3
     D  ATRB4                  4      4
     D  ATRB5                  5      5
     D  ATRB6                  6      6
     D  ATRB7                  7      7
     D  ATRB8                  8      8
     D  ATRB9                  9      9
     D  ATRB10                10     10
     D  ATRB11                11     11
     D  ATRB12                12     12
     D  ATRB13                13     13
     D  ATRB14                14     14
     D  ATRB15                15     15
     D  ATRB16                16     16
     D  ATRB17                17     17
     D  ATRB18                18     18
     D  ATRB19                19     19
     D  ATRB20                20     20
     D  ATRB21                21     21
     D  ATRB22                22     22
     D  ATRB23                23     23
     D  ATRB24                24     24
     D  ATRB25                25     25
     D  ATRB26                26     26
     D  ATRB27                27     27
     D  ATRB28                28     28
     D  ATRB29                29     29
     D  ATRB30                30     30
     D  ATRB31                31     31
     D  ATRB32                32     32
     D  ATRB33                33     33
     D  ATRB34                34     34
     D  ATRB35                35     35
     D  ATRB36                36     36
     D  ATRB37                37     37
     D  ATRB38                38     38
     D  ATRB39                39     39
     D  ATRB40                40     40
     D  ATRB41                41     41
     D  ATRB42                42     42
     D  ATRB43                43     43
     D  ATRB44                44     44
     D  ATRB46                46     46
     D  ATRB52                52     52

     D ERRCD           DS           116
     D  @ERLEN                 1      4B 0
     D  @ERCON                 9     15
     D  @ERDTA                17    116
     D PSCON           C                   CONST('PSCON     *LIBL     ')

     D                 DS
     D  APILEN                40     43B 0

     D ENVIRI          DS          2048
      *             Input Enivornment
     D  E@CPY@               119    120
     D  E@CPYS               119    120P 0
     D  E@FCO@               225    226
     D  E@FCOL               225    226P 0
     D  E@FPA@               227    230
     D  E@FPAG               227    230P 0
     D  E@SPTR               624    633
     D  E@TCO@               672    673
     D  E@TCOL               672    673P 0
     D  E@TPA@               674    677
     D  E@TPAG               674    677P 0
     D  E@WRTR               688    697

     D ENVIRO          DS          2048    INZ
      *             Output Enivornment
     D  ENVI01                 1    256
     D  ENVI03               513    768
     D  ENVI04               769   1024
     D  ENVI05              1025   1280
     D  FRMCOL               225    226P 0
     D  NUMWND               556    557P 0
     D  OUTFIL               568    577
     D  OUTFLB               578    587
     D  OUTFRM               588    597
     D  PRINTR               624    633
     D  RPTNAM               635    644
     D  RPTUD                645    654
     D  TOCOL                672    673P 0
     D  WRITER               688    697
     D  CWSC                 698    895
     D  CWW                  896   1093

     D PRTARA         UDS          1024
      *             Saved print options per session.
|    D  LFMCOL                 1     10  0
|    D  LTOCOL                11     20  0
|    D  LPRNTR                21     30
|    D  LOUTQ                 31     40
|    D  LOUTQL                41     50
|    D  LPTRF                 51     60
|    D  LPTRFL                61     70
|    D  LWRITR                71     80
/2806D  LOUTFR                81     90
/2806D  LPRTYP                91    100
/2806D  LDJEBF               101    110
/2806D  LDJEAF               111    120
/2806D  LBANNR               121    130
/2806D  LNSTRU               131    140
/2806D  LPRNOD               141    157
/2806D  LOADED               158    158
/3585D  LHOLD                159    162
/3585D  LSAVE                163    166
/3585D  LCOPIE               167    169  0
     D FAXARA         UDS          1024
     D MLARA          UDS          1024
     D LDASAV          DS          1024

     D LDA            UDS
      *             LDA built here for Mag2038
     D  MLIND                  1     40
     D  MLFRM                 41    160
     D  MLSUBJ               161    220
     D  MTX                  221    545
     D                                     DIM(5)                               Text Lines Email
     D  MLTXT1               221    285
     D  MLTXT2               286    350
     D  MLTXT3               351    415
     D  MLTXT4               416    480
     D  MLTXT5               481    545
/1554d  MLTEXT               221    545
     D  MLTYPE               546    546
     D  MLTO60               547    606
     D  MLTO                 547    666
     D  MLDIST               667    667
     D  MLFMT                668    677
/2497D  MLFMT4               668    671
/2930D  MLCDPG               678    682
/3393D  MLIGBA               683    683
/6609D  MLSPML               684    684                                         SpoolMail

     D  CT                   101    880
     D                                     DIM(12)                              Covertext
     D  FAXNUM                 1     40
     D  FAXFRM                41     85
     D  FAXTO                 86    130
     D  FAXRE                131    175
     D  FAXTX1               176    225
     D  FAXTX2               226    275
     D  FAXTX3               276    325
      * FastFax puts RpName & CpName to Faxtx4
      * FaxSys  puts to Faxid to Faxtx4
     D  FAXTX4               326    375
     D  FAXID                326    375
     D  RPNAME               326    345
     D  CPNAME               346    365

     D  FAXTX5               376    425
     D  FAXTPM               376    377P 0
     D  FAXCTY               378    378
     D  FAXOVR               379    398
     D  FAXLPP               403    404P 0
     D  FAXLPA               403    404
     D  FAXSAV               426    426

     D  @WSC                 427    624
     D  @WW                  625    822
     D  FAXHLD               832    832
     D  LFILNA               833    842
     D  LJOBNA               843    852
     D  LUSRNA               853    862
     D  LUSRDT               863    872
     D  LPGMOP               873    882
     D  DJEBEF               884    893
     D  DJEAFT               894    903
     D  BANNID               904    913
     D  INSTRU               914    923
     D  FRMNAM               924    933
      * FaxStar
     D  FXREFX               934    949
     D  ATCCMD               950    959
     D  DOCNAM               960    969
      * IBM Fax
     D  FCPRTF               934    943
     D  FCPRTL               944    953
      * Telex Fax
     D  FCVRID               934    937
      * FaxSys
     D  CONFRM               934    953
      * Rydex Fax
     D  FXRYLM               934    934
      * FastFax,FaxServer (CVRSHT only)
     D  CVRSHT               934    943
     D  SCFAX                945    949
     D  PCPFAX               950    955
     D  SDATE                956    963
     D  STIME                964    971
     D  CSTACT               972    978
     D  RTCODE               979    984
     D  SNDPRT               985    986
      * FastFax,FaxStar,DirectFax,FaxSys,FaxServer
     D  FAXVC                992    995
     D  FAXHC                996    999
     D  FAXSTY              1000   1003
     D  IMGPAG              1004   1023
      * PrmFax is also used to return error codes from mag2038.
      * PrmFax 'A' = Attach document to fax.
     D  PRMFAX              1024   1024
/6924 * FaxCom Stuff
/    d fc_faxnum                     30    overlay(faxnum)
/    d fc_From                       30    overlay(faxfrm)
/    d fc_ToCmpny                    30    overlay(faxtx4)
/    d fc_ToCntct                    30    overlay(faxto)

     D DSKMSR          C                   CONST('PRTDMDOC')

      * Variables ------------------------------------------------
T7063d emlddq          s               n   inz('0')
T4788d emailCount      s             10i 0

     C     *ENTRY        PLIST
      * General: 1-16
      *            OpCd: P)rint F)ax D)asd M)ail I)fs S)end-select
     C                   PARM                    OPCD              1            SPIFMD
     C                   PARM                    OBJTY             1            (I)mg (R)pt
     C                   PARM                    REPIDX           10            Rept Idx #
     C                   PARM                    @PRMPT            1            Prompt Scr
     C                   PARM                    @SEC                           Security F
     C                   PARM                    RTNCDE            7            Return Cod
     C                   PARM                    @FRMPG            7 0          7 From Page
     C                   PARM                    @TOPG             7 0          8 To   Page
     C                   PARM                    @FRMCO            3 0          9 From Colum
     C                   PARM                    @TOCOL            3 0          10To   Colum
     C                   PARM                    @PRTWN            1            1 Print Wind
     C                   PARM                    @ENVUS           10            2 Enviro Use
     C                   PARM                    @ENVNA           10            3 Enviro Nam
     C                   PARM                    @SBMJB            1            4 Submit job
     C                   PARM                    @JBDES           10            5 Job Desc
     C                   PARM                    @JBDLB           10            6 Job-D Lib
      * Print  17-32
     C                   PARM                    @RPTNA           10            7 Report Nam
     C                   PARM                    @OUTFR           10            8 Out Form
     C                   PARM                    @RPTUD           10            9 User data
     C                   PARM                    @PTRID           10            20Print Id
     C                   PARM                    @OUTQ            10            1 Outq
     C                   PARM                    @OUTQL           10            2 Outq Libra
     C                   PARM                    @PRTF            10            3 Print-F
     C                   PARM                    @PRTLB           10            4 Print-F Li
     C                   PARM                    @WTR             10            5 Writer
     C                   PARM                    @COPIE            3 0          6 #Copies
     C                   PARM                    @DJEBF           10            7 Dje Before
     C                   PARM                    @DJEAF           10            8 Dje After
     C                   PARM                    @BANNR           10            9 Banner Id
     C                   PARM                    @INSTR           10            30Instru Id
     C                   PARM                    @JOINS            1            1 Join Splf
     C                   PARM                    @PRTTY           10            2 Print Type
      * Outfile  33-35
     C                   PARM                    @DBFIL           10            3 File Name
     C                   PARM                    @DBLIB           10            4 Library
     C                   PARM                    @DBNOT            1            5 Notes
      * Fax  36-48
     C                   PARM                    @FXNBR           40            Fax to Nbr
     C                   PARM                    @FXTO1           45            Fax to 1
     C                   PARM                    @FXTO2           45                   2
     C                   PARM                    @FXTO3           45                   3
     C                   PARM                    @FXFR1           45            Fax frm 1
     C                   PARM                    @FXFR2           45                    2
     C                   PARM                    @FXFR3           45                    3
     C                   PARM                    @FXREF           45            Fax refer
     C                   PARM                    @FXTX1           52            Fax text 1
     C                   PARM                    @FXTX2           52                     2
     C                   PARM                    @FXTX3           52                     3
     C                   PARM                    @FXTX4           52                     4
     C                   PARM                    @FXTX5           52                     5
      * Fax  49-58
     C                   PARM                    @FXCPF           10            Cover PRTF
     C                   PARM                    @FXCPL           10            Cover PRTF
     C                   PARM                    @FXFRM           10            Formname
     C                   PARM                    @FXSTY            4            Style
     C                   PARM                    @FXLPI            4            Lpi
     C                   PARM                    @FXCPI            4            Cpi
     C                   PARM                    @FXPTY            2            Priority
     C                   PARM                    @FXSID           50            Send Id
     C                   PARM                    @FXMSG           20            Message to
     C                   PARM                    @FXSAV            1            Save statu
      * Misc          59-62
     C                   PARM                    @DEVFN           10            Orig prtf
     C                   PARM                    @DEVFL           10            Orig prtfl
     C                   PARM                    @UPGTB            1            Use pagetb
     C                   PARM                    @PGTBL           20            Use pagetb
      * Print duplex  63-69
     C                   PARM                    @CVRPA            7            CovrPgB4/A
     C                   PARM                    @CVRTX                         CovrPg tex
     C                   PARM                    @DUPLE            4            *yes/*no
     C                   PARM                    @ORIEN           10            *land/*por
     C                   PARM                    @PRTYP            6            *XI *PVL e
     C                   PARM                    @PRTNO           17            PCsrvrNode
     C                   PARM                    @CVRMB           10            CvrPgTxt M
      * Paper Size/Pgs 70-72
     C                   PARM                    @PAPSZ           10            Paper size
     C                   PARM                    @DRWER            4            Drawer
     C                   PARM                    @PGRNG           20            Page range
      * Batch ID      73
     C                   PARM                    @BCHID           10            Batch ID
      * SpyLink data  74
     C                   PARM                    @SDT                           Spylink stru
      * eMail         75-80
     C                   PARM                    @SNDR            60            eMail SENDER
     C                   PARM                    @AdTyp            1            RCVR ADDRESS
     C                   PARM                    @RCVR            60            RECEIVER
     C                   PARM                    @SUBJ            60            SUBJECT
     C                   PARM                    @TXT                           TEXT 5*60
     C                   PARM                    @FMT             10            FORMAT
      * add on        81-83
/2930C                   PARM                    @CDPG             5            CODE PAGE
/3393C                   PARM                    @IGBA             1            IGNORE BADBATCH
/6609C                   PARM                    @INTFC            1            SpoolMail Interface
      * Save LDA
     C                   IN        LDA
     C                   MOVE      LDA           LDASAV

J5953
J5953    If ( IsSplMail = FALSE );
J5953      mlspml = *blanks;
J5953      Out LDA;
J5953    EndIf;
J5953
J5953 /end-free

/6609C     WQPRM         IFGE      83
/    C                   MOVE      @INTFC        Interface         1
/    C                   ELSE
/    C                   MOVE      '*'           Interface
/6609C                   ENDIF

/3523
/3523 * Save *ENTRY parm values.
/3523C                   MOVE      'N'           OVRPRT            1
/3523
/3523C     *LIKE         DEFINE    @PTRID        SVPTR
/3523C     *LIKE         DEFINE    @PRTF         SVPF
/3523C     *LIKE         DEFINE    @PRTLB        SVPFLB
/3523
/3523C                   MOVE      @PTRID        SVPTR
/3523C                   MOVE      @PRTF         SVPF
/3523C                   MOVE      @PRTLB        SVPFLB
/3523
      * Get fax values
     C                   SELECT
     C     LSTCHC        WHENEQ    'F'
     C     LSTCHC        OREQ      'I'
     C                   IN        FAXARA
     C                   MOVE      FAXARA        LDA
     C                   OUT       LDA
     C     LSTCHC        WHENEQ    'M'
/2873C                   IN        MLARA
     C                   MOVE      MLARA         LDA
     C                   OUT       LDA

/7063 //   Restore the values used for SpoolMail
/
/    c                   When      (LstChc = 'S') and
/    c                             (MlSpMl = 'S')
/    C                   IN        MLARA
/    C                   MOVE      MLARA         LDA
/    C                   OUT       LDA

     C     LSTCHC        WHENEQ    'P'
/3291C     USEDDQ        IFNE      'Y'
/2806C                   EXSR      CLRSPR
/3291C                   END
     C                   IN        PRTARA
     C                   OUT       LDA
     C                   ENDSL

     C                   MOVEA     @SEC          SEC

      * If we're writing to dasd for transfer to QDLS shared
      * folder, we will be writing FCFCs for page ejects.

     C     OPCD          IFEQ      'D'
     C     @OUTQ         ANDEQ     '*SHRFLD'
     C                   CLEAR                   @OUTQ
     C                   MOVE      'Y'           WTFCFC            1
     C                   ELSE
     C                   MOVE      ' '           WTFCFC
     C                   END

     C     WQPRM         IFGE      59
     C                   MOVEL(P)  @DEVFN        DEVFN            10
     C                   MOVEL(P)  @DEVFL        DEVFL            10
     C                   ELSE
     C                   MOVE      *BLANKS       DEVFN
     C                   MOVE      *BLANKS       DEVFL
     C                   ENDIF

     C     WQPRM         IFGE      61                                           Use pagetbl
     C                   MOVE      @UPGTB        UPGTBL            1
     C                   MOVEL(P)  @PGTBL        PTABLE           20
     C                   ELSE
     C                   MOVE      '0'           UPGTBL
     C                   MOVE      *BLANKS       PTABLE
     C                   ENDIF

      * Passed for a SpyLink
     C                   CLEAR                   SDT
     C                   MOVE      *OFF          SDTFLG            1
     C     WQPRM         IFGE      74                                           Passed
     C                   MOVEL     @SDT          SDT
     C     SDTNAM        IFNE      *BLANKS                                      for SpyLink
     C                   MOVE      *ON           SDTFLG
     C                   END
     C                   END

     C                   CLEAR                   ERRMSG

     C     @JOINS        IFEQ      'N'                                          *ENTRY parm
     C                   MOVE      '2'           SEC(25)                         prevents
     C                   END                                                     joining

     C     OPCD          IFEQ      ' '                                          OpCode empty
     C     PROMPT        ANDNE     'N'                                            default
     C                   MOVE      'P'           OPCD                             Print
     C                   END

     C     @JOINS        IFEQ      ' '                                          *ENTRY parm
     C                   MOVE      'N'           @JOINS                          default
     C                   END

     C                   MOVE      @PRMPT        PROMPT            1
     C     PROMPT        IFEQ      ' '                                          PROMPT is
     C                   MOVE      'Y'           PROMPT                          never blank
     C                   ENDIF

     C     PROMPT        IFEQ      'C'                                          Close batch
     C                   MOVE      'Y'           USEDDQ                          force DQ us
     C                   ENDIF

     C                   MOVE      *BLANKS       CALPGM
     C     RTNCDE        IFEQ      'MAG203'
     C                   MOVE      RTNCDE        CALPGM            7
     C                   MOVE      *BLANKS       RTNCDE
     C                   ENDIF

J5953c                   Eval      blnIsSplMail = IsSplMail
      * DTAQ was prev active, but not this time. Close it.
     C     USEDDQ        IFEQ      'Y'                                          DTAQ active
     C     USEDPC        ANDNE     'Y'                                          Pc print
     C     PROMPT        ANDNE     'A'                                          No batch add
     C     PROMPT        IFEQ      'C'                                          Close batch
     C     RTNCDE        OREQ      'CLOSEW'                                     close progr
     C     @JOINS        ORNE      'Y'                                          no join anym
     C     OPCD          ORNE      LSTOPC                                       FAX/PRT chg
     C     OBJTY         ORNE      LSTTYP                                       IMG/RPT chg
     C     OPCD          ANDNE     'F'                                           and no fax
     C     OPCD          ANDNE     'M'                                           and no mail
     C     OPCD          ANDNE     'S'                                           and no send
     C     OPCD          ANDNE     'I'                                           and no ifs
/6609C     OBJTY         OREQ      'R'                                          Previous Image
/    C     Interface     ANDNE     'N'                                          in DTAQ this is
/    C     OPCD          ANDEQ     'S'                                          a SpoolMail
J5849C     blnIsSplMail  ANDEQ     TRUE
/6609C     FAXNUM        ANDEQ     '*EMAIL      '                               AND emailing
/6609C     OBJTY         OREQ      'R'                                          Previous Image
/    C     Interface     ANDNE     'N'                                          in DTAQ this is
/    C     OPCD          ANDEQ     'M'                                          a SpoolMail
J5849C     blnIsSplMail  ANDEQ     TRUE
/6609C     FAXNUM        ANDEQ     '*EMAIL      '                               AND emailing
     C                   EXSR      CLSDQ
     C                   ENDIF
     C                   ENDIF

     C     PROMPT        IFEQ      'C'                                          Close/Quit
     C     @JOINS        OREQ      'C'
     C     RTNCDE        OREQ      'CLOSEW'
     C                   EXSR      QUIT
     C                   ENDIF

     C     PROMPT        IFEQ      'Y'                                          Inter prompt
     C     @JOINS        ANDEQ     'Y'                                           Join
     C     DQACT         ANDEQ     'Y'                                          Active
/6609C     PROMPT        OREQ      'Y'                                          Inter prompt
/    C     @JOINS        ANDEQ     'Y'                                           Join
/    C     LSTSPM        ANDEQ     'Y'                                          had spoolmail
/6609C     PROMPT        OREQ      'Y'                                          Inter prompt
/    C     @JOINS        ANDEQ     'Y'                                           Join
/    C     OBJTY         ANDNE     lsttyp                                       switching from
/6609C     lsttyp        ANDNE     ' '                                          image to report
     C                   MOVE      'N'           PROMPT
     C                   ENDIF

     C     *LIKE         DEFINE    OPCD          LSTOPC
     C     *LIKE         DEFINE    OBJTY         LSTTYP
     C                   MOVE      OBJTY         LSTTYP                         Last type
     C                   MOVE      OPCD          LSTOPC                         Last option

     C                   CLEAR                   RTNCDE
      * Open display file
     C                   EXSR      GETDSP

      * Assure existence of db files & records
     C     OBJTY         CASEQ     'R'           CHKRPT                         Rpt files
     C     OBJTY         CASEQ     'I'           CHKIMG                         Img files
     C                   ENDCS

      * Move entry parms to internal/screen values
     C                   EXSR      MOVPRM

      * Get defaults if first join or no join
     C     USEDDQ        IFNE      'Y'
     C                   EXSR      GETDFT
     C                   MOVE      LDA           LDASAV
     C                   ENDIF

      * ExFmt and do output
     C                   EXSR      OUTPUT

     C                   MOVE      OPCD          LSTCHC            1
     C                   EXSR      RETRN


      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKIMG        BEGSR
      *          Check existence of db files & records for Image
/1892 *
/     *                  Open Image File
/     *
/    C                   If        OpnImg <> '1'
/
/    C                   If        NOT %Open(MImgDir)
/    C                   Open(e)   MImgDir
/
/    C                   If        %error
/    C                   Eval      RtnCde = 'ERR0082'
/    C                   ExSr      Retrn
/    C                   EndIf
/    C                   Eval      OpnImg = '1'
/    c                   EndIf
/
/    c                   EndIf
/
/
/    c     RepIdx        Chain     MImgDir
/    c
/    c                   If        NOT %found
/    C                   Eval      RtnCde = 'ERR1852'
/    C                   ExSr      Retrn
/    c                   Else
/    c                   Eval      FilNam = IDDocT
/    c                   Eval      JobNam = *blanks
/    c                   Eval      PgmOpf = *blanks
/    c                   Eval      UsrNam = *blanks
/    c                   Eval      UsrDta = *blanks
/    c     KLBig5        Chain     RMaint1
/    c
/    c                   If        NOT %found
      *----------------------------------------------------------
      *  Check for the circumstances where the big five key
      *  for the batch image has been modified by looking up
      *  the report master by the report type.
      *----------------------------------------------------------
/    c                   If        NOT %Open(RMAINT4)
/    c                   Open(e)   Rmaint4

/    c                   If        Not %Error
/    c     IDDocT        Chain     RMnTrc4
/    c                   Close(e)  RMaint4
/
/    c                   If        %Found
/    c                   Eval      FilNam = RRNam
/    c                   Eval      JobNam = RJNam
/    c                   Eval      PgmOpf = RPNam
/    c                   Eval      UsrNam = RUNam
/    c                   Eval      UsrDta = RUDat
/    c                   Else
/    c                   Eval      RtnCde = 'ERR1037'
/    c                   EndIf
/    c                   Else
/    c                   Eval      RtnCde = 'ERR0082'
/    c                   EndIf
/
/    c                   EndIf
/
/    c                   EndIf
/
/    c                   EndIf
/
/    c                   If        RtnCde <> *blanks
/    c                   Eval      @ErCon = RtnCde
/    C                   ExSr      RtvErm
/    C                   ExSr      Retrn
/    C                   EndIf
/
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKRPT        BEGSR
      *          Check existence of db files & records for Report

     C                   MOVE      *BLANK        @ERCON
     C                   MOVE      *BLANK        ERR#              1

     C     REPIDX        CHAIN     MRPTDIR7                           40
     C     *IN40         IFEQ      *ON
     C                   MOVEL     'ERR116A'     @ERCON                         "Report key
     C                   GOTO      BOTLOD
     C                   ENDIF

     C     KLBIG5        CHAIN     RMAINT1                            41
     C     *IN41         IFEQ      *ON
     C                   CLEAR                   RRNAM
     C                   CLEAR                   RDEFP
     C                   CLEAR                   RDEFQ
     C                   CLEAR                   RDEFL
     C                   CLEAR                   RTYPID
     C                   CLEAR                   RDJEB
     C                   CLEAR                   RDJEA
     C                   CLEAR                   RBNRID
     C                   CLEAR                   RINSTR
     C                   CLEAR                   RPTRFL
     C                   CLEAR                   RPTRLB
     C                   CLEAR                   RFXFRM
     C                   CLEAR                   RFXLAN
     C                   CLEAR                   RFXCPI
     C                   CLEAR                   RFXLPI
     C                   CLEAR                   RFXCPF
     C                   CLEAR                   RFXCPL
     C                   CLEAR                   RPRTYP
     C                   CLEAR                   RPNODE
     C                   MOVE      LNKSCR        RLMTSC
     C                   ELSE
      * Limit scroll
     C     RLMTSC        IFEQ      *BLANK
     C                   MOVE      LNKSCR        RLMTSC
     C                   END
     C                   END
/3523
/3523 * Retrieve printer file attributes for save and hold.
/3523C                   CLEAR                   SPHOLD
/3523C                   CLEAR                   SPSAVE
/3523C                   CLEAR                   PFAMSG
/3523C                   CLEAR                   PFAIND
/3523
/3523C     *LIKE         DEFINE    RPTRLB        PFALIB
/3523C     *LIKE         DEFINE    RPTRFL        PFAFIL
/3523
/3523C     RDEFP         IFNE      *BLANKS
/3523C                   MOVE      RDEFP         @PTRID                         -force previous
/3523C     RDEFP         CHAIN     RPTABLE                            90
/3523C                   ENDIF
/3523
/3523C                   SELECT
/3523C     RDEFP         WHENNE    *BLANKS
/3523C     *IN90         ANDEQ     '0'
/3523C                   MOVE      RDEFP         PRINTR
/3523C                   MOVE      PPRTLB        @PRTLB                         <-force previous
/3523C                   MOVE      PPRTFL        @PRTF
/3523C                   MOVE      'Y'           OVRPRT
/3523C     RPTRFL        WHENNE    *BLANKS
/3523C                   MOVE      RPTRLB        @PRTLB                         <-force previous
/3523C                   MOVE      RPTRFL        @PRTF
/3523C                   MOVE      'Y'           OVRPRT
/3523C                   ENDSL

     C     LOCSFA        IFEQ      0
     C     LOCSFD        OREQ      0
     C     LOCSFP        OREQ      0
     C                   MOVE      '7'           ERR#
     C                   MOVE      'ERR1167'     @ERCON                         "Pointers
     C                   GOTO      BOTLOD
     C                   END

     C     REPLOC        IFEQ      '1'                                          Report is
     C                   MOVE      '7'           ERR#                           on tape
     C                   MOVE      ERR(4)        @ERCON
     C                   GOTO      BOTLOD
     C                   END

     C     FLKEY         CHAIN     FLDDIR                             47        Folder index
     C     FLKEY         KLIST
     C                   KFLD                    FLDR
     C                   KFLD                    FLDRLB
     C     *IN47         IFEQ      *ON                                          is missing
     C                   MOVE      ERR(17)       @ERCON
     C                   GOTO      BOTLOD
     C                   END

     C     REPLOC        IFNE      '2'                                          Blnk offline
     C     REPLOC        ANDNE     '4'                                          R/dars optic
     C     REPLOC        ANDNE     '6'                                          Imageview op
     C                   MOVE      *BLANKS       OFRNAM                          name if not
     C                   END                                                     optical.
      * Folder exist?
     C                   CALL      'CHKEXSFLD'
     C                   PARM                    FLDR
     C                   PARM                    FLDRLB
     C                   PARM      *BLANK        RETN6
     C     RETN6         IFEQ      'NOEXST'
     C                   MOVE      '7'           ERR#                           "Folder is
     C                   MOVEL     ERR(10)       @ERCON                         Missing"
     C                   GOTO      BOTLOD
     C                   END
      *>>>>
     C     BOTLOD        TAG

     C     @ERCON        IFNE      *BLANK                                       Error
     C                   EXSR      RTVERM
     C                   MOVE      *ON           *IN47
     C                   EXSR      RETRN                                         return.
     C                   END
     C                   ENDSR
/3523 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3523 * Retrieve printer file attributes.
/3523C     $RTPFA        BEGSR
/3523
/3523 * Clear any previous printer file values.
/3523C                   CLEAR                   SPHOLD
/3523C                   CLEAR                   SPSAVE
/3523C                   CLEAR                   PFAMSG
/3523C                   CLEAR                   PFAIND
/3523
/3523 * Create temporary file with printer file attributes.
/3523C                   CLEAR                   CLCMD
/3523C     CL(2)         CAT(P)    PFALIB:0      CLCMD
/3523C     CLCMD         CAT       '/':0         CLCMD
/3523C     CLCMD         CAT       PFAFIL:0      CLCMD
/3523C     CLCMD         CAT       CL(3):0       CLCMD
/3523
/3523C                   EXSR      RUNCL
/3523
/3523 * If printer file object found, override and read.
/3523C     *IN33         IFEQ      '0'
/3523C                   CLEAR                   CLCMD
/3523C                   MOVEL     CL(4)         CLCMD
/3523
/3523C                   EXSR      RUNCL
/3523
/3523C     *IN33         IFEQ      '0'
/3523C                   OPEN      @PFA
/3523C                   READ      @PFA                                   33
/3523C                   CLOSE     @PFA
/3523
/3523 * Create override message and indicator.
/3523C     PFAOVR        CAT(P)    PFALIB:1      PFAMSG
/3523C     PFAMSG        CAT       '/':0         PFAMSG
/3523C     PFAMSG        CAT       PFAFIL:0      PFAMSG
/3523C                   MOVE      '*'           PFAIND
/3523
/3523 * Delete override.
/3523C                   CLEAR                   CLCMD
/3523C                   MOVEL     CL(5)         CLCMD
/3523C                   EXSR      RUNCL
/3523
/3523 * Delete temporary file.
/3523C                   CLEAR                   CLCMD
/3523C                   MOVEL     CL(6)         CLCMD
/3523C                   EXSR      RUNCL
/3523C                   ENDIF
/3523
/3523C                   ENDIF
/3523
/3523C     XRTPFA        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MOVPRM        BEGSR
      *          Put entry parms into screen/internal fields

     C                   SELECT
     C     DQACT         WHENEQ    'Y'                                          Join active
     C     @JOINS        ANDEQ     'Y'                                          use old opcd
     C                   MOVE      RQOP          OPCD
     C     OPCD          WHENEQ    ' '                                          OpCode empty
     C     PROMPT        ANDNE     'N'                                            default
     C                   MOVE      'P'           OPCD                             Print
     C                   ENDSL
      * For images
     C     OBJTY         IFEQ      'I'
     C     WQPRM         IFGE      72
     C     @PGRNG        IFNE      *BLANKS
     C                   MOVEL(P)  @PGRNG        IMGPAG
     C                   ELSE
     C                   MOVEL(P)  '*ALL'        IMGPAG
     C                   ENDIF
     C                   ELSE
     C                   MOVEL(P)  '*ALL'        IMGPAG
     C                   ENDIF
     C                   ENDIF

      * If there's a page range limit in *entry, put it to MIN-MAX
     C     @FRMPG        IFGT      0
     C     @TOPG         ANDGT     0
     C                   Z-ADD     @FRMPG        MINPAG            9 0
     C                   Z-ADD     @TOPG         MAXPAG            9 0
     C                   ELSE
     C                   CLEAR                   MINPAG
     C                   CLEAR                   MAXPAG
     C                   END

      * Fill user screen fields
     C     @FRMPG        IFGT      0                                            From Page
     C                   Z-ADD     @FRMPG        FRMPAG
     C                   ELSE
     C                   Z-ADD     1             FRMPAG
     C                   END

     C     @TOPG         IFGT      0                                            To Page
     C                   Z-ADD     @TOPG         TOPAGE
     C                   ELSE
     C                   Z-ADD     TOTPAG        TOPAGE
     C                   END

     C     @FRMCO        IFGT      0                                            From Column
     C                   Z-ADD     @FRMCO        FRMCOL
     C                   ELSE
     C                   Z-ADD     1             FRMCOL
     C                   ENDIF

     C     @TOCOL        IFGT      0                                            To Column
     C                   Z-ADD     @TOCOL        TOCOL
     C                   ELSE
     C                   Z-ADD     9999          TOCOL
     C                   ENDIF

/4625C     DQACT         IFNE      'Y'                                          Join active
/    C     @JOINS        ORNE      'Y'                                          use old opcd
     C     @COPIE        IFEQ      0
     C                   Z-ADD     1             COPIES                         #Copies
     C                   ELSE
     C                   Z-ADD     @COPIE        COPIES
     C                   END
/    C                   END

     C     @PRTWN        IFNE      *BLANK                                       Prt Window
     C                   MOVEL(P)  @PRTWN        PRTWND
     C                   END

     C     @ENVUS        IFNE      *BLANK                                       Enviro Usr
     C                   MOVEL(P)  @ENVUS        ENVUSR
     C                   END

     C     @ENVNA        IFNE      *BLANK                                       Enviro Name
     C                   MOVEL(P)  @ENVNA        ENVNAM
     C                   END

     C     @SBMJB        IFNE      *BLANK                                       Submit Job
     C                   MOVEL(P)  @SBMJB        SBMJBQ
     C                   END

     C     SBMJBQ        IFNE      'Y'
     C     SBMJBQ        ANDNE     'N'
     C                   MOVE      'Y'           SBMJBQ
     C                   END

     C     @JBDES        IFNE      *BLANK                                       Job-D
     C                   MOVEL(P)  @JBDES        JBDESC
     C                   MOVEL(P)  @JBDLB        JBDLIB
     C                   ELSE
     C                   MOVEL     DFTJBD        JBDESC
     C                   END

     C     JBDLIB        IFEQ      *BLANK                                       Job-D Lib
     C                   MOVEL     '*LIBL'       JBDLIB
     C                   END

     C     OBJTY         IFEQ      'R'

     C                   ELSE
     C                   MOVE      '*NO '        SAVE
     C                   MOVE      '*NO '        HOLD
     C                   END
     C                   ENDSR
/3523 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3523 * Apply correct save/hold parameters.
I3523C     $SVHLD        BEGSR
     C
/3523
/3523C                   CLEAR                   SAVIND
/3523C                   CLEAR                   HLDIND
/3523
/3523C                   SELECT
/3585C     RPPRTS        WHENEQ    'Y'                                          RETAIN LAST
/    C     LOADED        ANDEQ     'Y'
/    C     #KEY          ANDNE     F22                                          Reset
/    C     LSAVE         ANDNE     *BLANKS
/    C     RPPRTS        OREQ      'G'
/    C     LOOPNG        ANDEQ     'Y'
/    C     #KEY          ANDNE     F22                                          Reset
/    C     LSAVE         ANDNE     *BLANKS
/    C                   MOVE      LSAVE         SAVE
/3523C     SPSAVE        WHENEQ    'Y'
/3523C                   MOVE      '*YES'        SAVE
/3523C                   MOVE      '*'           SAVIND
/3523C     SPSAVE        WHENEQ    'N'
/3523C                   MOVE      '*NO '        SAVE
/3523C                   MOVE      '*'           SAVIND
/2937C     GRPSAV        WHENEQ    'Y'
/2937C     GRPSAV        OREQ      'N'
/2937C                   MOVE      '*SYS'        SAVE
/3523C     SAVF          WHENEQ    '*YES'
/3523C                   MOVE      '*YES'        SAVE
/3523C     SAVF          WHENEQ    '*NO '
/3523C                   MOVE      '*NO '        SAVE
/3523C                   ENDSL
/3523
/3523C                   SELECT
/3585C     RPPRTS        WHENEQ    'Y'                                          RETAIN LAST
/    C     LOADED        ANDEQ     'Y'
/    C     #KEY          ANDNE     F22                                          Reset
/    C     LHOLD         ANDNE     *BLANKS
/    C     RPPRTS        OREQ      'G'
/    C     LOOPNG        ANDEQ     'Y'
/    C     #KEY          ANDNE     F22                                          Reset
/    C     LHOLD         ANDNE     *BLANKS
/    C                   MOVE      LHOLD         HOLD
/3523C     SPHOLD        WHENEQ    'Y'
/3523C                   MOVE      '*YES'        HOLD
/3523C                   MOVE      '*'           HLDIND
/3523C     SPHOLD        WHENEQ    'N'
/3523C                   MOVE      '*NO '        HOLD
/3523C                   MOVE      '*'           HLDIND
/2937C     GRPHLD        WHENEQ    'Y'
/2937C     GRPHLD        OREQ      'N'
/2937C                   MOVE      '*SYS'        HOLD
/3523C     HLDF          WHENEQ    '*YES'
/3523C                   MOVE      '*YES'        HOLD
/3523C     HLDF          WHENEQ    '*NO '
/3523C                   MOVE      '*NO '        HOLD
/3523C                   ENDSL
/3523
/3523C     XSVHLD        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETDFT        BEGSR

/2806
/2806C     OPCD          IFEQ      'P'
/2806C                   EXSR      PRTDFT
/2806C                   END

/6923C                   SELECT
/    C     @OUTFR        WHENNE    *BLANK                                       Output Form
/    C                   MOVEL(P)  @OUTFR        OUTFRM
/
/    C     OBJTY         WHENEQ    'I'                                          For Images
/    C     OUTFRM        ANDEQ     *BLANK
/    C                   MOVEL(P)  '*STD'        OUTFRM
/
/    C     OBJTY         WHENEQ    'R'                                          For reports
/    C     OUTFRM        ANDEQ     *BLANK
/7112c                   eval      outfrm = '*ORIG'
/    C                   ENDSL

/2806C     RPPRTS        IFEQ      'Y'                                          RETAIN LAST
/2806C     LOADED        ANDEQ     'Y'
/2806C     #KEY          ANDNE     F22                                          Reset
/2806C     RPPRTS        OREQ      'G'
/2806C     LOOPNG        ANDEQ     'Y'
/2806C     #KEY          ANDNE     F22                                          Reset
/2806C                   EXSR      RELOAD
/2806C                   END


     C     OUTFLB        IFEQ      *BLANKS                                      Output
     C     'SPYEXPOR'    CAT       'T ':0        OUTFLB                         Database
     C                   MOVE      'N'           NOTPRT
     C                   END

     C     @JOINS        IFEQ      'Y'
     C                   MOVE      'Y'           JOINS
     C                   ELSE
     C                   MOVE      'N'           JOINS
     C                   END

     C     @JOINS        IFEQ      'N'                                          Report name
     C                   MOVE      *BLANKS       RPTNAM
     C                   END

     C                   SELECT
     C     @RPTNA        WHENNE    *BLANK                                        From parms
     C                   MOVEL(P)  @RPTNA        RPTNAM

     C     RPTNAM        WHENEQ    *BLANKS
     C                   SELECT
     C     OBJTY         WHENEQ    'I'                                           for images
/7687C                   MOVEL     'DOCIMAGE'    RPTNAM
     C                   OTHER
     C                   MOVEL(P)  '*ORIG'       RPTNAM
     C                   ENDSL
     C                   ENDSL

     C                   CLEAR                   SEC(26)                        Secure prtty

/2806 *****                                                Output Form
/2806 *****                                                Printer Type
/2806 *****                                                Rpt cfg

     C                   SELECT
     C     @RPTUD        WHENNE    *BLANK                                       User Data
     C                   MOVEL(P)  @RPTUD        RPTUD

     C     RPTUD         WHENEQ    *BLANK
     C     OBJTY         IFNE      'I'
     C                   MOVEL     '*ORIG'       RPTUD
     C                   ELSE
     C                   MOVEL     IDDOCT        RPTUD
     C                   END
     C                   ENDSL
/2806
/2806 *****                                                Outq
/2806 *****                                                Writer

     C     NOTPRT        IFEQ      *BLANKS                                      Notes
     C                   MOVE      'N'           NOTPRT
     C                   END

      * FaxCom
/6924c                   if        faxtyp = 'B'
/    c                   eval      faxhld = 'N'
/6924c                   eval      faxsav = 'N'
/    c                   endif

      * Fax
     C     FOUTQ         IFEQ      *BLANKS
     C                   MOVE      LFXOUT        FOUTQ                          Use SysDft
     C                   MOVE      LFXLIB        FOUTQL                          OutQ & Lib
     C                   ENDIF

     C     FRMNAM        IFEQ      *BLANKS
     C     FAXTYP        ANDNE     '1'                                          No faxstar
     C     FAXTYP        ANDNE     '2'                                          No ibm fax
     C     FAXTYP        ANDNE     '6'                                          No directf
     C     FAXTYP        ANDNE     '9'                                          No fax/acs
     C                   MOVEL     RFXFRM        FAXOVR
     C                   ENDIF

      * FastFax RPNAME(To nickname) and CPNAME(To company name)
     C     FAXTYP        IFEQ      '4'
     C                   MOVEL     @FXTO2        @FXTX4                          Nick,CoName
     C                   MOVEL     *BLANKS       @FXTO2
     C                   ENDIF

     C                   MOVEL     RFXCPF        FCPRTF
     C                   MOVEL     RFXCPL        FCPRTL
     C                   MOVEL     RFXCPF        CVRSHT

     C     OPCD          IFNE      'M'
     C     #FAXSV        IFNE      'Y'
     C     #FAXSV        ANDNE     'N'
     C                   MOVE      'N'           #FAXSV
     C                   END

     C     FAXSAV        IFEQ      *BLANKS

/7063 //   Inhibit the FAX Save field from being set in the event that
/     //   the delivery of the document is to be mailed. This prevents
/     //   an errouneous value from overlaying the memory allocated to
/     //   the message text in the email.
/
/7063C                   If        MlSpMl = *blanks
     C                   MOVE      #FAXSV        FAXSAV
/7063c                   EndIf

     C                   END

     C     FAXLPA        IFEQ      *BLANK                                       Lines/page
     C                   Z-ADD     0             FAXLPP
     C                   END
     C                   END

     C     FAXTYP        IFEQ      '3'                                          Rydex
     C     FAXTYP        OREQ      '5'                                          FaxSys

     C     FAXHC         IFEQ      *BLANKS
     C                   MOVEL(P)  'R'           FAXHC
     C                   END

     C     FAXVC         IFEQ      *BLANKS
     C                   MOVE      '6   '        FAXVC
     C                   END

     C     FAXSTY        IFEQ      *BLANKS
     C                   MOVE      'L   '        FAXSTY
     C                   END

     C     FAXCTY        IFEQ      *BLANKS
     C                   MOVE      'L'           FAXCTY
     C                   END
     C                   ENDIF

     C                   SELECT
     C     FAXTYP        WHENEQ    '1'                                           Faxstar
     C     FAXTYP        OREQ      '2'                                           Ibm
     C     FAXTYP        OREQ      '6'                                           Directfax
     C     FAXTYP        OREQ      '7'                                           TelexFax
     C     FAXTYP        OREQ      '8'                                           FaxServer
      *                    CLEARnothing
     C     FAXTYP        WHENEQ    '9'                                           Fax/acs
/7564c     faxtyp        oreq      'A'
     C                   CLEAR                   FAXTX5
     C                   OTHER                                                   others
     C                   CLEAR                   FAXTPM
     C                   ENDSL

/2720C     FAXARA        IFEQ      *BLANKS
/    C     *LOCK         IN        FAXARA
/    C                   MOVE      LDA           FAXARA
/    C                   OUT       FAXARA
/    C                   ENDIF

/2806 ******                                               Printer Id
/2806 *    *                                               PRTF
/2806 *    *                                               DJE Before
/2806 *    *                                               DJE After
/2806 *    *                                               Banner Id
/2806 ******                                               Instructions
      *------------
      * Parms 33-35
      *------------
     C     WQPRM         CABLT     33            ENDDFT

     C     @DBFIL        IFNE      *BLANKS
     C                   MOVEL(P)  @DBFIL        OUTFIL                         File Name
     C                   END

     C     @DBLIB        IFNE      *BLANKS
     C                   MOVEL(P)  @DBLIB        OUTFLB                         File LIB
     C                   END

     C     @DBNOT        IFNE      *BLANKS
     C                   MOVEL(P)  @DBNOT        NOTPRT                         File NOTES
     C                   END
      *------------
      * Parms 36-57
      *------------
     C     WQPRM         CABLT     36            ENDDFT

     C     @FXNBR        IFNE      *BLANKS                                      Fax Nbr
     C                   MOVEL(P)  @FXNBR        FAXNUM
     C                   MOVEL(P)  @FXNBR        FX2NUM
     C                   END

     C     @FXTO1        IFNE      *BLANKS                                      Fax to 1
     C                   MOVEL(P)  @FXTO1        FAXTO
     C                   MOVEL(P)  @FXTO1        FX2TO
     C                   END

     C     @FXTO2        IFNE      *BLANKS                                      Fax to 2
     C                   MOVEL(P)  @FXTO2        FAXTX1
     C                   END

     C     @FXTO3        IFNE      *BLANKS                                      Fax to 3
     C                   MOVEL(P)  @FXTO3        FAXTX2
     C                   END

     C     @FXFR1        IFNE      *BLANKS                                      Fax from 1
     C                   MOVEL(P)  @FXFR1        FAXFRM
     C                   MOVEL(P)  @FXFR1        FX2FRM
     C                   END

     C     @FXFR2        IFNE      *BLANKS                                      Fax from 2
     C                   MOVEL(P)  @FXFR2        FAXTX3
     C                   END

     C     @FXFR3        IFNE      *BLANKS                                      Fax from 3
     C                   MOVEL(P)  @FXFR3        FAXTX4
     C                   END

     C     @FXREF        IFNE      *BLANKS                                      Fax Refer
     C                   MOVEL(P)  @FXREF        FAXRE
     C                   MOVEL(P)  @FXREF        FX2RE
     C                   END

     C     @FXTX1        IFNE      *BLANKS                                      Fax Text 1
     C                   MOVEL(P)  @FXTX1        FAXTX1
     C                   MOVEL(P)  @FXTX1        FX2TX1
     C                   END

     C     @FXTX2        IFNE      *BLANKS                                      Fax Text 2
     C                   MOVEL(P)  @FXTX2        FAXTX2
     C                   MOVEL(P)  @FXTX2        FX2TX2
     C                   END

     C     @FXTX3        IFNE      *BLANKS                                      Fax Text 3
     C                   MOVEL(P)  @FXTX3        FAXTX3
     C                   END

     C     @FXTX4        IFNE      *BLANKS                                      Fax Text 4
     C                   MOVEL(P)  @FXTX4        FAXTX4
     C                   END

     C     @FXTX5        IFNE      *BLANKS                                      Fax Text 5
     C                   MOVEL(P)  @FXTX5        FAXTX5
     C                   MOVEL(P)  @FXTX5        FX2TX5
     C                   END

     C     @FXCPF        IFNE      *BLANKS                                      Cover PRTF
     C                   MOVEL(P)  @FXCPF        FCPRTF
     C                   MOVEL(P)  @FXCPF        CVRSHT
     C                   END

     C     @FXCPL        IFNE      *BLANKS                                      Cover PRTFL
     C                   MOVEL(P)  @FXCPL        FCPRTL
     C                   END

     C     @FXFRM        IFNE      *BLANKS                                      Formname
     C                   MOVEL(P)  @FXFRM        FRMNAM
     C                   MOVEL(P)  @FXFRM        FAXOVR
     C                   END

     C     @FXSTY        IFNE      *BLANKS                                      Style
     C                   MOVEL(P)  @FXSTY        FAXSTY
     C                   END

     C     @FXLPI        IFNE      *BLANKS                                      Lpi
     C                   MOVEL(P)  @FXLPI        FAXVC
     C                   END

     C     @FXCPI        IFNE      *BLANKS                                      Cpi
     C                   MOVEL(P)  @FXCPI        FAXHC
     C                   END

     C     @FXPTY        IFNE      *BLANKS                                      Priority
     C                   MOVEL(P)  @FXPTY        SNDPRT
     C                   END

     C     @FXSID        IFNE      *BLANKS                                      Send Id
     C     FAXTYP        IFEQ      '1'
     C                   MOVEL     @FXSID        FXREFX
     C                   ELSE
     C                   MOVEL(P)  @FXSID        FAXID
     C                   END
     C                   ENDIF

     C     @FXMSG        IFNE      *BLANKS                                      Message to
     C                   MOVEL(P)  @FXMSG        CONFRM
     C                   END

     C     @FXSAV        IFNE      *BLANKS                                      Save status
     C                   MOVEL(P)  @FXSAV        FAXSAV
     C                   END

/3390C                   EXSR      DFTDUP                                       DUPLEX DFT VALU

      *------------
      * Parms 63-67
      *------------
     C     WQPRM         IFGE      63

     C     CVRPAG        IFEQ      *BLANKS
     C                   MOVEL(P)  @CVRPA        CVRPAG            7            CovrPgB4/Aft
     C                   ENDIF

     C     CVRTXT        IFEQ      *BLANKS
     C                   MOVEL(P)  @CVRTX        CVRTXT                         CovrPg text
     C                   ENDIF

     C     ORIENT        IFEQ      *BLANKS
     C                   MOVEL(P)  @ORIEN        ORIENT           10            *land/*port
     C                   ENDIF
/2806 *****                                                *XI *PVL etc
/2806 *****                                                PCsrvrNodeID
     C                   ENDIF

     C     ORIENT        IFEQ      *BLANKS                                      Orientation
     C                   MOVEL(P)  '*AUTO'       ORIENT
     C                   END

     C     CVRPAG        IFEQ      *BLANKS                                      Cover Page
     C                   MOVEL     '*NONE'       CVRPAG
     C                   END

     C     CVRMBR        IFEQ      *BLANKS
     C                   MOVEL(P)  '*SYSDFT'     CVRMBR           10            Cover Mbr
     C     WQPRM         IFGE      69
     C     @CVRMB        ANDNE     *BLANKS
     C                   MOVEL(P)  @CVRMB        CVRMBR
     C                   END
     C                   END
      *                                                    Papersize
     C     PAPSIZ        IFEQ      *BLANKS
     C                   MOVEL(P)  '*SYSDFT'     PAPSIZ           10
     C     WQPRM         IFGE      70
     C     @PAPSZ        ANDNE     *BLANKS
     C                   MOVEL     @PAPSZ        PAPSIZ
     C                   ENDIF
     C                   ENDIF

     C     DRAWER        IFEQ      *BLANKS                                      Drawer
     C                   MOVEL(P)  '*ORG'        DRAWER
     C     WQPRM         IFGE      71
     C     @DRWER        ANDNE     *BLANKS
     C                   MOVEL     @DRWER        DRAWER
     C                   ENDIF
     C                   ENDIF
      *    EMAIL PARMS
     C     WQPRM         IFGT      74
     C     @SNDR         IFNE      *BLANKS
     C                   MOVEL(P)  @SNDR         MLFRM
     C                   ENDIF
     C     @RCVR         IFNE      *BLANKS
     C                   MOVEL(P)  @RCVR         MLTO
     C                   ENDIF
     C     @ADTYP        IFNE      *BLANKS
     C                   MOVEL(P)  @ADTYP        MLTYPE
     C                   ENDIF
     C     @SUBJ         IFNE      *BLANKS
     C                   MOVEL(P)  @SUBJ         MLSUBJ
     C                   ENDIF
     C     @FMT          IFNE      *BLANKS
     C                   MOVEL(P)  @FMT          MLFMT
     C                   ENDIF
     C                   DO        5             MT                5 0
     C     @TXT(MT)      IFNE      *BLANKS
     C                   MOVEA     @TXT          MTX
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF

/2930C     WQPRM         IFGE      81
/    C                   MOVEL     @CDPG         MLCDPG
/    C                   ELSE
/    C                   MOVE      *BLANKS       MLCDPG
/    C                   END

/3393C     WQPRM         IFGE      82
/    C                   MOVEL     @IGBA         MLIGBA
/    C                   ELSE
/    C                   MOVE      'N'           MLIGBA
/    C                   END

     C     ENDDFT        ENDSR
/3390 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/    C     DFTDUP        BEGSR
/

/    C     OBJTY         IFEQ      'R'                                          Duplex
/    C     DUPLEX        ANDEQ     *BLANKS                                      No image
/    C                   SELECT
/    C     SDUPLX        WHENEQ    'Y'
/    C                   MOVE(P)   '*YES'        DUPLEX
/    C     SDUPLX        WHENEQ    'N'
/    C                   MOVEL(P)  '*NO'         DUPLEX
/    C                   OTHER
/    C                   MOVE(P)   '*ORG'        DUPLEX
/    C                   ENDSL
/    C                   END
/
/    C     WQPRM         IFGE      63
/    C     DUPLEX        ANDEQ     *BLANKS
/    C                   MOVEL(P)  @DUPLE        DUPLEX            4            *yes/*no
/    C                   END
/
/    C     DUPLEX        IFEQ      *BLANKS
/    C                   MOVEL(P)  '*NO'         DUPLEX                         Duplex
/    C                   END
/3390C                   ENDSR
/2806 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2806C     PRTDFT        BEGSR

/2806
/2806C                   SELECT
/2806
/2806C     @PTRID        WHENNE    *BLANKS                                      Printer Id
/2806C                   MOVE(P)   @PTRID        PRINTR
/2806
/2806C     RDEFP         WHENNE    *BLANKS
/2806C                   MOVE(P)   RDEFP         PRINTR
/2806C                   ENDSL
/2806
/2806 * Printr read from SpyView Printer Table
/2806C     PRINTR        IFNE      *BLANKS
/2806C                   EXSR      GETPTR
/2806C                   END
/2806
/2806
/2806C                   SELECT
/2806C     WQPRM         WHENGT    63
/2806C     @PRTYP        ANDNE     *BLANKS
/2806C                   MOVEL(P)  @PRTYP        PRTTYP                         Printer Type
/2806C     WQPRM         WHENGE    63
/2806C     @PRTTY        ANDNE     *BLANKS
/2806C                   MOVEL(P)  @PRTTY        PRTTYP                         *XI *PVL etc
/2806C     RPRTYP        WHENNE    *BLANKS
/2806C                   MOVEL(P)  RPRTYP        PRTTYP                          Rpt cfg
/2806C     SPTRTY        WHENNE    *BLANKS
/2806C     PRTTYP        ANDEQ     *BLANKS
/2806C                   MOVEL     SPTRTY        F4A               4
/2806C     F4A           IFEQ      '*RPC'
/2806C     F4A           OREQ      '*LPC'
/2806C     OBJTY         OREQ      'I'
/2806C                   MOVEL(P)  SPTRTY        PRTTYP                          SysDft
/2806C                   ENDIF
/2806C                   ENDSL
/2806 * Outq OR writer
/2806C                   SELECT
/2806
/2806C     @OUTQ         WHENNE    *BLANKS                                      Outq
/2806C                   MOVE      @OUTQ         OUTQ
/2806C                   MOVE      @OUTQL        OUTQL
/2806
/2806C     @WTR          WHENNE    *BLANKS                                      Writer
/2806C                   MOVE      @WTR          WRITER
/2806
/2806C     OQOPLC        WHENEQ    '*RPTCFG'                                    RMAINT outq
/2806C     RDEFQ         ANDNE     *BLANKS
/2806C                   MOVE      RDEFQ         OUTQ
/2806C                   MOVE      RDEFL         OUTQL
/2806
/2806C     OQOPLC        WHENNE    '*RPTCFG'                                    SYSENV outq
/2806C     OQOPLC        ANDNE     *BLANKS
/2806C     OUTQ          ANDEQ     *BLANKS
/2806C     WRITER        ANDEQ     *BLANKS
/2806C                   MOVE      OQOPLC        OUTQ
/2806C                   MOVE      *BLANKS       OUTQL
/2806
/2806C     PROPLC        WHENNE    *BLANKS                                      SYSENV write
/2806C     OUTQ          ANDEQ     *BLANKS
/2806C     WRITER        ANDEQ     *BLANKS
/2806C                   MOVE      PROPLC        WRITER
/2806
/2806C     OUTQ          WHENEQ    *BLANKS
/2806C     WRITER        ANDEQ     *BLANKS
/2806C                   MOVEL     OUTQNM        OUTQ                            orig outq
/2806C                   MOVEL     OUTQLB        OUTQL                           from RptDir
/2806C                   ENDSL
/2806
/2806C                   SELECT
/2806C     @PRTF         WHENNE    *BLANKS
/2806C                   MOVEL(P)  @PRTF         PRTF
/2806C                   MOVEL(P)  @PRTLB        PRTLIB
/2806C     RPTRFL        WHENNE    *BLANKS
/2806C                   MOVEL(P)  RPTRFL        PRTF
/2806C                   MOVEL(P)  RPTRLB        PRTLIB
/3523C                   MOVEL(P)  RPTRFL        PFAFIL
/3523C                   MOVEL(P)  RPTRLB        PFALIB
/3523C                   EXSR      $RTPFA
/3523C                   EXSR      $SVHLD
/3523C     PPRTFL        WHENNE    *BLANKS
/2806C                   MOVEL(P)  PPRTFL        PRTF
/2806C                   MOVEL(P)  PPRTLB        PRTLIB
/3523C                   MOVEL(P)  PPRTFL        PFAFIL
/3523C                   MOVEL(P)  PPRTLB        PFALIB
/3523C                   EXSR      $RTPFA
/3523C                   EXSR      $SVHLD
/2806C                   ENDSL
/2806
/2806C                   SELECT
/2806C     @DJEBF        WHENNE    *BLANK                                       DJE Before
/2806C                   MOVEL(P)  @DJEBF        DJEBEF
/2806C     RDJEB         WHENNE    *BLANK
/2806C                   MOVEL(P)  RDJEB         DJEBEF
/2806C                   ENDSL
/2806
/2806C                   SELECT
/2806C     @DJEAF        WHENNE    *BLANK                                       DJE After
/2806C                   MOVEL(P)  @DJEAF        DJEAFT
/2806C     RDJEA         WHENNE    *BLANK
/2806C                   MOVEL(P)  RDJEA         DJEAFT
/2806C                   ENDSL
/2806
/2806C                   SELECT
/2806C     @BANNR        WHENNE    *BLANK                                       Banner Id
/2806C                   MOVEL(P)  @BANNR        BANNID
/2806C     RBNRID        WHENNE    *BLANK
/2806C                   MOVEL(P)  RBNRID        BANNID
/2806C     BANNID        WHENEQ    *BLANK
/2806C                   MOVEL(P)  LBANID        BANNID
/2806C                   ENDSL
/2806
/2806C                   SELECT
/2806C     @INSTR        WHENNE    *BLANK                                       Instructions
/2806C                   MOVEL(P)  @INSTR        INSTRU
/2806C     RINSTR        WHENNE    *BLANK
/2806C                   MOVEL(P)  RINSTR        INSTRU
/2806C     INSTRU        WHENEQ    *BLANK
/2806C                   MOVEL(P)  LINSTR        INSTRU
/2806C                   ENDSL
/2806
/2806C                   SELECT
/2806C     WQPRM         WHENGE    63
/2806C     @PRTNO        ANDNE     *BLANKS
/2806C                   MOVEL(P)  @PRTNO        PRTNOD                         PCsrvrNodeID
/2806C     RPNODE        WHENNE    *BLANKS
/2806C                   MOVE      RPNODE        PRTNOD                          SysDefault
/2806C     SYSNOD        WHENNE    *BLANKS
/2806C     PRTNOD        ANDNE     *BLANKS
/2806C                   MOVE      SYSNOD        PRTNOD                          SysDefault
/2806C                   ENDSL
/2806C                   ENDSR
/2806 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2806 *****
/2806 *   ONLY RPPRTS *NE 'N' WILL EVER GO HERE
/2806 *****
/2806C     RELOAD        BEGSR

/2806
/2806C     @PTRID        IFNE      *BLANKS                                      Printer Id
/2806C                   MOVE(P)   @PTRID        PRINTR
/2806C                   ELSE
/2806C                   MOVEL     LPRNTR        PRINTR
/2806C                   END
/2806
/2806
      * Always use report formtype when faxing/sending in order to maintain
      * splf formtype.
/6923c                   if        opcd = 'F' or opcd = 'S'
/    c                   eval      outfrm = frmtyp
/    c                   else
/2806C     @OUTFR        IFNE      *BLANK                                       Output Form
/2806C                   MOVEL(P)  @OUTFR        OUTFRM
/2806C                   ELSE
/5220C     LOUTFR        IFNE      *BLANK
/2806C                   MOVEL(P)  LOUTFR        OUTFRM

/5736c                   If        ObjTy  = 'I' and
/5736c                             OutFrm = '*ORIG'
/5736c                   Eval      OutFrm = '*STD'
/5736c                   EndIf

/5220C                   ENDIF
/6923c                   endif
/2806C                   END
/2806
/2806
/2806C                   SELECT
/2806C     WQPRM         WHENGT    63
/2806C     @PRTYP        ANDNE     *BLANKS
/2806C                   MOVEL(P)  @PRTYP        PRTTYP                         Printer Type
/2806C     WQPRM         WHENGE    63
/2806C     @PRTTY        ANDNE     *BLANKS
/2806C                   MOVEL(P)  @PRTTY        PRTTYP                         *XI *PVL etc
/2806C                   OTHER
/2806C                   MOVEL(P)  LPRTYP        PRTTYP
/2806C                   ENDSL
/2806 * Outq OR writer
/2806C                   SELECT
/2806
/2806C     @OUTQ         WHENNE    *BLANKS                                      Outq
/2806C                   MOVE      @OUTQ         OUTQ
/2806C                   MOVE      @OUTQL        OUTQL
/2806
/2806C     @WTR          WHENNE    *BLANKS                                      Writer
/2806C                   MOVE      @WTR          WRITER
/2806
/2806C     LOUTQ         WHENNE    *BLANKS
/2806C                   MOVEL     LOUTQ         OUTQ
/2806C                   MOVEL     LOUTQL        OUTQL
/2806
/2806C                   OTHER
/2806C                   MOVEL     LWRITR        WRITER
/2806C                   ENDSL
/2806
/2806C     @PRTF         IFNE      *BLANKS
/2806C                   MOVEL(P)  @PRTF         PRTF
/2806C                   MOVEL(P)  @PRTLB        PRTLIB
/2806C                   ELSE                                                   RETAIN LAST
/2806C                   MOVEL     LPTRF         PRTF
/2806C                   MOVEL     LPTRFL        PRTLIB
/2806C                   END
/2806
/2806C     @DJEBF        IFNE      *BLANK                                       DJE Before
/2806C                   MOVEL(P)  @DJEBF        DJEBEF
/2806C                   ELSE
/2806C                   MOVEL(P)  LDJEBF        DJEBEF
/2806C                   END
/2806
/2806C     @DJEAF        IFNE      *BLANK                                       DJE After
/2806C                   MOVEL(P)  @DJEAF        DJEAFT
/2806C                   ELSE
/2806C                   MOVEL(P)  LDJEAF        DJEAFT
/2806C                   END
/2806
/2806C     @BANNR        IFNE      *BLANK                                       Banner Id
/2806C                   MOVEL(P)  @BANNR        BANNID
/2806C                   ELSE
/2806C                   MOVEL(P)  LBANNR        BANNID
/2806C                   END
/2806
/2806C     @INSTR        IFNE      *BLANK                                       Instructions
/2806C                   MOVEL(P)  @INSTR        INSTRU
/2806C                   ELSE
/2806C                   MOVEL(P)  LNSTRU        INSTRU
/2806C                   END
/2806
/2806C     WQPRM         IFGE      63
/2806C     @PRTNO        ANDNE     *BLANKS
/2806C                   MOVEL(P)  @PRTNO        PRTNOD                         PCsrvrNodeID
/2806C                   ELSE
/2806C                   MOVEL(P)  LPRNOD        PRTNOD
/2806C                   END

/3585C     LHOLD         IFNE      *BLANKS
/    C                   MOVEL     LHOLD         HOLD
/    C                   END
/    C     LSAVE         IFNE      *BLANKS
/    C                   MOVEL     LSAVE         SAVE
/    C                   END
/    C     LCOPIE        IFNE      *ZEROS
/    C                   MOVE      LCOPIE        COPIES
/    C                   END

/2806C                   ENDSR
/2806 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2806C     CLRSCN        BEGSR
/2806
/2806C                   CLEAR                   PRINTR
/2806C                   CLEAR                   OUTQ
/2806C                   CLEAR                   OUTQL
/2806C                   CLEAR                   WRITER
/2806C                   CLEAR                   OUTFRM
/2806C                   CLEAR                   PRTF
/2806C                   CLEAR                   PRTLIB
/2806C                   CLEAR                   DJEBEF
/2806C                   CLEAR                   DJEAFT
/2806C                   CLEAR                   BANNID
/2806C                   CLEAR                   INSTRU
/2806C                   CLEAR                   PRTTYP
/2806C                   CLEAR                   PRTNOD
/2806C                   CLEAR                   PRTRSV
/2806C                   ENDSR
/2806 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2806C     CLRSPR        BEGSR

/2806
/2806C                   EXSR      CLRSCN
/2806
/2806C                   CLEAR                   RDEFP
/2806C                   CLEAR                   RDEFQ
/2806C                   CLEAR                   RDEFL
/2806C                   CLEAR                   RPTRFL
/2806C                   CLEAR                   RPTRLB
/2806C                   CLEAR                   RDJEB
/2806C                   CLEAR                   RDJEA
/2806C                   CLEAR                   RBNRID
/2806C                   CLEAR                   RINSTR
/2806C                   CLEAR                   RPRTYP
/2806C                   CLEAR                   RPNODE
/2806
/2806C                   CLEAR                   POUTQ                          Update OutQ
/2806C                   CLEAR                   PLIBR                          OUTQL  and r
/2806C                   CLEAR                   PRTDV                          Writer
/2806C                   CLEAR                   PFILT                          Formtype
/2806C                   CLEAR                   PPRTFL                         Print File
/2806C                   CLEAR                   PPRTLB                         Print Fil Lb
/2806C                   CLEAR                   PDJEB                          DJE Before
/2806C                   CLEAR                   PDJEA                          DJE After
/2806C                   CLEAR                   PBANID                         Banner Id
/2806C                   CLEAR                   PINSTR                         Instr Id
/2806C                   CLEAR                   PPRTYP                         Printer Typ
/2806C                   CLEAR                   PNODID                         Node ID
/2806
/2806C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OUTPUT        BEGSR
      *          ------------------------------------------------
      *          ExFmt and call Mag2039 to process data to output
      *          ------------------------------------------------

      * Set Hide/Protect attrs for screen.
      * Load display fields ATRB1...ATRB31

     C                   SELECT
     C     OBJTY         WHENEQ    'I'                                          Image
     C                   MOVEA     '11'          SEC(3)                          No columns
     C     OBJTY         WHENEQ    'R'                                          Report
     C                   MOVEA     '  '          SEC(1)                          UnprotctPgs
     C                   ENDSL

     C                   MOVE      *BLANK        ATR
     C     WQPRM         SUB       6             MAX50             3 0

     C                   DO        MAX50         I                 3 0
     C                   SELECT                                                 Use SEC
     C     SEC(I)        WHENEQ    '1'
     C                   MOVE      PROTEC        ATR(I)                          to protect
     C     SEC(I)        WHENEQ    '2'
     C                   MOVE      NONDSP        ATR(I)                          or hide
     C                   ENDSL
     C                   ENDDO

     C                   MOVE      *BLANK        @ERCON
     C                   MOVE      *BLANK        ERR#              1

      * Prompting and interactive
     C     PROMPT        IFEQ      'Y'
     C     JOBTYP        ANDEQ     '1'
     C                   SELECT
     C     OPCD          WHENEQ    'S'                                          Send via..
/2409C     FAXTYP        IFNE      '0'
/2409C     MLACT         OREQ      'Y'
     C                   EXSR      CHCSND                                        pick(FM)
/5939c                   if        opcd = 'M'                                    need to do this
/    c                   eval      sec(25) = '2'                                 only for email
/    c                   MOVE      NONDSP        ATR(25)                         and not fax
/    c                   endif

/2409C                   ELSE
/2409C                   CALL      'SPYERR'                                      Error
/2409C                   PARM      ERR(1)        ERRID             7
/2409C                   EXSR      RETRN
/2409C                   END
     C     OPCD          WHENEQ    ' '                                          No destinatn
     C                   EXSR      CHCALL                                        pick(DFMP)
     C                   ENDSL
      * Screen header
     C                   SELECT
     C     OPCD          WHENEQ    'D'                                          Dasd
     C                   MOVEL(P)  OPFILE        OUTTYP
     C     OPCD          WHENEQ    'F'                                          Fax
     C                   MOVEL(P)  OPFAX         OUTTYP
     C     OPCD          WHENEQ    'M'
     C                   MOVEL(P)  OPMAIL        OUTTYP                         Email
     C     OPCD          WHENEQ    'P'
     C                   MOVEL(P)  OPPRT         OUTTYP                         Print
     C                   CLEAR                   OUTFIL
     C                   CLEAR                   OUTFLB
     C                   ENDSL
     C                   ENDIF

      * If Fax, check capability

     C     OPCD          IFEQ      'F'                                          Fax
     C     FAXTYP        IFEQ      '0'                                           Not
     C                   MOVEL     ERR(25)       RTNCDE                          configured
     C                   EXSR      RETRN
     C                   ENDIF
      * Check if image is faxed
     C     OBJTY         IFEQ      'I'
     C                   EXSR      VLDFAX                                       VALIDATE IF
     C     ALWIMG        IFNE      'Y'
     C                   MOVEL     'ERR1609'     RTNCDE                          "No images"
     C                   EXSR      RETRN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * If report, get *ALL environment for screen defaults
     C     OBJTY         IFEQ      'R'
     C                   EXSR      GETENV
     C                   END
      * Set ind for F10
     C                   EXSR      SETF10

     C     PROMPT        IFEQ      'Y'
     C                   SELECT
     C     OPCD          WHENEQ    'F'
     C     OPCD          OREQ      'I'
     C                   MOVE      FAXARA        LDA                            Take fax par
     C                   OUT       LDA

/7063C                   When      ( OpCd = 'M' ) or
/7063C                             ( OpCd = 'S' and MlSpMl = 'S' )
     C                   MOVE      MLARA         LDA                            Take mail pa
     C                   OUT       LDA
     C                   ENDSL

     C     IMGPAG        IFEQ      *BLANKS
     C                   MOVEL     '*ALL'        IMGPAG
     C                   ENDIF
      *>>>>
     C     SHOWS1        TAG

     C     @ERCON        IFEQ      *BLANK
     C                   MOVE      *BLANK        PTRMSG
     C                   ELSE
     C                   EXSR      RTVERM
     C                   MOVEL(P)  ERRMSG        PTRMSG
     C                   END

     C     *INKD         IFEQ      *OFF
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   END

     C     JOBTYP        IFEQ      '1'                                          Interactive
     C     AUTCHG        IFEQ      'N'                                           EQ, protect
     C                   MOVE      PROTEC        ATR(9)                          Job Desc
     C                   MOVE      PROTEC        ATR(10)                         JobD lib
     C                   END

     C     ACMDCD        IFEQ      ' '
     C     ACMDCD        OREQ      '0'
     C                   MOVE      *OFF          *IN28                          ProtctDOCNAM
     C                   ELSE
     C                   MOVE      *ON           *IN28
     C                   ENDIF
      * PRTWDW __________________________________________
      *       |            Output to  Printer___         | OUTTYP
      *       |  From Page #    : ______1                | FRMPAG
      *       |  To Page #      : ______6                | TOPAGE
      *       |  Join Spoolfile : Y                      | JOINS
      *       |  From Column #  : __1                    | FRMCOL
      *       |  To Column #    : 999                    | TOCOL
      *       |  With Windows   : N                      | PRTWND
      *       |    Environ User:  JOHN______             | ENVUSR
      *       |    Environ Name:  *ALL______             | ENVNAM
      *       |  Submit Job     : Y                      | SBMJBQ
      *       |  Job Description: *USRPRF___    F4=List  | JBDESC
      *       |    Library      :   __________           | JBDLIB
      *       |  F3=Exit   F10=More Parms    F12=Cancel  |
      *       |__________________________________________|
      *PRTWDWI|           Output to  OUTTYP____        |
      *       | Pages to Print : IMGPAG______________  |
      *       | Join Spoolfile : JOINS                 |
      *       | Attach doc name: DOCNAM____    F4=List |
      *       | Submit Job . . : SBMJBQ                |
      *       | Job Description: JBDESC____    F4=List |
      *       |   Library  . . :   JBDLIB____          |
      *       | F3=Exit   F10=More Parms    F12=Cancel |
      *       | PTRMSG_____________________________    |
      *       |________________________________________|
      *PRTWDWFX           Output to  OUTTYP____        |
      *       | From Page #    : FRMPAG_               |
      *       | To Page #      : TOPAGE_               |
      *       | Join Spoolfile : JOINS                 |
      *       | From Column #  : FRMCOL                |
      *       | To Column #    : TOCOL                 |
      *       | With Windows . : PRTWND                |
      *       |   Environ User:  ENVUSR____            |
      *       |   Environ Name:  ENVNAM____            |
      *       | Attach doc name: DOCNAM____    F4=List |
      *       | Submit Job . . : SBMJBQ                |
      *       | Job Description: JBDESC____    F4=List |
      *       |   Library  . . :   JBDLIB____          |
      *       | F3=Exit   F10=More Parms    F12=Cancel |
      *       |________________________________________|
     C                   SELECT
     C     OBJTY         WHENEQ    'I'
     C                   MOVEL(P)  'PRTWDWI'     HLPFMT
     C                   EXFMT     PRTWDWI                                      Image
     C     OPCD          WHENEQ    'F'
     C                   MOVEL(P)  'PRTWDWFX'    HLPFMT
     C                   EXFMT     PRTWDWFX                                     Fax rpt
     C                   OTHER
/6521C     OPCD          ifeq      'M'
/6521C                   MOVEL(P)  'PRTWDWFX'    HLPFMT
/6521C                   ELSE
     C                   MOVEL(P)  'PRTWDW'      HLPFMT
/6521C                   ENDIF
/3523
/3523C     PRTF          IFNE      *BLANKS
/3523C                   MOVE      PRTF          PFAFIL
/3523
/3523C     PRTLIB        IFEQ      *BLANKS
/3523C                   CLEAR                   PFALIB
/3523C                   MOVEL     '*LIBL'       PFALIB
/3523C                   ELSE
/3523C                   MOVE      PRTLIB        PFALIB
/3523C                   ENDIF
/3523
/3523C                   EXSR      $RTPFA
/3523C                   ENDIF
/3523
/3523C                   EXSR      $SVHLD
     C                   EXFMT     PRTWDW                                       Prt rpt
     C                   ENDSL

/1452C     @1            TAG
     C                   MOVE      *BLANKS       @ERCON
     C                   MOVE      *BLANKS       PTRMSG

      * FKey other than F10=MoreParms
     C     *IN01         IFEQ      *ON                                          VldCmdKey
     C     *INKJ         ANDNE     *ON                                          but not F10
     C                   SELECT
     C     *INKC         WHENEQ    *ON
     C                   MOVE      #KEY          RTNCDE                               Return
     C                   EXSR      RETRN
     C     *INKL         WHENEQ    *ON                                          12=Cancel
     C                   MOVEL     'ERR1385'     RTNCDE                               Return
     C                   EXSR      RETRN
     C     *INKD         WHENEQ    *ON                                          F4
     C                   EXSR      SRF4A
     C     *INKV         WHENEQ    *ON                                          F21
     C                   EXSR      SRF21
     C     #KEY          WHENEQ    HELP
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   SELECT
/1452C     OBJTY         WHENEQ    'I'
/1452C                   READ      PRTWDWI                                99    Image
/1452C     OPCD          WHENEQ    'F'
/1452C                   READ      PRTWDWFX                               99    Fax rpt
/1452C                   OTHER
/1452C                   READ      PRTWDW                                 99    Prt rpt
/1452C                   ENDSL
/1452C                   MOVE      #IN99         *IN99
/1452C                   GOTO      @1
     C                   ENDSL
     C                   GOTO      SHOWS1
     C                   END
     C                   ENDIF
     C                   ENDIF

     C     PRTWND        IFEQ      'Y'
     C     FRMCOL        IFGT      *ZERO
     C     TOCOL         ORGT      *ZERO
     C                   Z-ADD     0             FRMCOL                         Not valid w/
     C                   Z-ADD     0             TOCOL                          Window=Y
     C                   END

     C     ENVUSR        IFNE      '*CURRENT'
     C     ENVUSR        IFEQ      *BLANKS
     C     ENVNAM        OREQ      *BLANKS
     C                   MOVE      'M203095'     @ERCON                         "mandatory
     C                   GOTO      SHOWS1
     C                   END
     C                   END
     C                   END
      *---------------------------
      * Validate report page range
      *---------------------------
     C     OBJTY         IFEQ      'R'
     C                   SELECT
      *    If limiting SpyLink scrolling or using distr page table,
      *    require page numbers within allowed MIN-MAX range.

     C     RLMTSC        WHENEQ    'Y'
     C     UPGTBL        OREQ      '1'
     C     MINPAG        IFGT      0
     C     FRMPAG        IFLT      MINPAG
     C     FRMPAG        ORGT      MAXPAG
     C                   MOVE      ERR(27)       @ERCON                         Page Range
     C                   MOVE      '8'           ERR#                            invalid
     C                   Z-ADD     MINPAG        FRMPAG
     C                   END

     C     TOPAGE        IFLT      MINPAG
     C     TOPAGE        ORGT      MAXPAG
     C                   MOVE      ERR(27)       @ERCON                         Page Range
     C                   MOVE      '8'           ERR#                            invalid
     C                   Z-ADD     MAXPAG        TOPAGE
     C                   END
     C                   END

     C     FRMPAG        WHENGT    TOTPAG
     C                   MOVE      ERR(27)       @ERCON
     C                   MOVE      '8'           ERR#
     C                   Z-ADD     1             FRMPAG

     C     TOPAGE        WHENLT    1
     C     TOPAGE        ORGT      TOTPAG
     C                   MOVE      ERR(27)       @ERCON
     C                   MOVE      '8'           ERR#
     C                   Z-ADD     TOTPAG        TOPAGE
     C                   ENDSL

/6641c                   else

/     *  edit page range for images only if not *ALL or blanks(which will default to *ALL)

/    c     imgpag        ifne      '*ALL'
/    c     imgpag        andne     *blanks

/     *  substitue '0' for any "," or "-" which are valid entries for ranges
/    c                   eval      f6p = 1
/    c                   dow       f6p <= %size(imgpag)
/    c                   if        %subst(imgpag:f6p:1) = '-' or
/    c                             %subst(imgpag:f6p:1) = ','
/    c                   eval      %subst(pagtmp:f6p:1) = '0'
/    c                   else
/    c                   eval      %subst(pagtmp:f6p:1) = %subst(imgpag:f6p:1)
/    c                   endif
/    c                   eval      f6p = f6p + 1
/    c                   enddo

/     *  if first non numberic found is less that last number in the array it is invalid
/    C     ' '           CHECKR    pagtmp        F6L
/    C     NUM           CHECK     pagtmp        F6P                            Check num
/    C     NUM           CHECK     pagtmp        F6P                            Check num
/    C     F6P           IFGT      0
/    C     F6P           ANDLE     F6L
/    C                   MOVE      ERR(27)       @ERCON                         Page Range
/    C                   MOVE      '8'           ERR#                            invalid
/    C                   ENDIF

/    c                   endif
     C                   ENDIF
/6641C     @ERCON        CABNE     *BLANKS       SHOWS1

     C                   SELECT
     C     SBMJBQ        WHENNE    'Y'
     C     SBMJBQ        ANDNE     'N'
     C                   MOVE      'Y'           SBMJBQ
     C                   MOVEL     ERR(29)       @ERCON                         Submit job
     C                   MOVE      '7'           ERR#                            not Y/N

     C     SBMJBQ        WHENEQ    'Y'
     C                   SELECT
     C     JBDESC        WHENEQ    *BLANKS
     C                   MOVEL     DFTJBD        JBDESC
     C                   MOVEL     '*LIBL'       JBDLIB
     C                   MOVEL     ERR(20)       @ERCON                         Invalid Job
     C                   MOVE      '5'           ERR#

     C     JBDESC        WHENNE    '*USRPRF'
     C     JBDLIB        ANDEQ     *BLANKS
     C                   MOVEL     ERR(21)       @ERCON                         Invalid JobD
     C                   MOVE      '5'           ERR#

     C     JBDESC        WHENNE    '*USRPRF'
     C                   MOVEL(P)  JBDESC        OBJNAM           10
     C                   MOVEL(P)  JBDLIB        OBJLIB
     C                   MOVEL(P)  '*JOBD'       OBJTYP
     C                   EXSR      CHKOBJ
     C     EXISTS        IFEQ      'N'
     C                   MOVEL     ERR(22)       @ERCON                         Enter JobD/
     C                   MOVE      '5'           ERR#
     C                   END
     C                   ENDSL
     C                   ENDSL

     C     @ERCON        CABNE     *BLANKS       SHOWS1

     C     CALPGM        IFEQ      'MAG203'
     C                   EXSR      RTNPM1                                       Set RtnParms
     C                   ENDIF
      *-----------------------------------------
      * Do additional parms in AdPrm1 subroutine
      *-----------------------------------------
     C     *IN43         IFEQ      *ON                                          Add parms
     C     *INKJ         OREQ      *ON                                          or F10

     C     OPCD          IFEQ      'P'                                          Print
     C                   EXSR      ADPRM1                                       Addit parms
     C     #KEY          CABEQ     PRVPG         SHOWS1
     C     #KEY          CABEQ     NXTPG         SHOWS1
     C     #KEY          CABEQ     F12           SHOWS1
     C     #KEY          CABEQ     F3            BOTOUT
     C                   ELSE                                                   Not Printing
     C                   GOTO      SHOWS1
     C                   ENDIF

     C                   ELSE

      * If printing, check OUTQ/writer existence.

     C     OPCD          IFEQ      'P'                                          Printing
     C                   MOVEL     PRTTYP        F4A
     C     F4A           IFEQ      '*RPC'                                        remote  pc
     C                   MOVEL     PRTNOD        NODEID
     C                   MOVEL(P)  '*RPC'        OPCODE
     C                   ENDIF

     C                   MOVE      'N'           EXISTS
     C     OUTQ          CASNE     *BLANKS       OQEXST
     C     WRITER        CASNE     *BLANKS       WTEXST
     C                   ENDCS

/2971C     OUTQ          IFNE      '*JOB'
/2971C     OUTQ          ANDNE     '*USRPRF'
/2971
     C     EXISTS        IFEQ      'N'                                          Bad object
     C                   MOVEL(P)  '*USRPRF'     OUTQ                            replace
     C                   MOVE      *BLANKS       OUTQL                           with UsrPrf
     C                   MOVE      *BLANKS       WRITER
     C                   ENDIF
/2971
/2971C                   ENDIF
/2971
     C                   ENDIF
     C                   ENDIF

     C                   Z-ADD     1             SCREEN            3 0
     C                   MOVE      ' '           PRMFAX
      * Database, Fax, eMail
     C     OPCD          CASEQ     'D'           DODB                           Create empty
     C     OPCD          CASEQ     'F'           DOFAX
     C     OPCD          CASEQ     'M'           DOMAIL
     C     OPCD          CASEQ     'I'           DOIFS
     C                   ENDCS

/6609 *   If SpoolMail is specified for Interface or the Interface is marked for default
/     *   AND this is an email, AND SYSENV is ok activated for SpoolMail, AND this is a
/     *   report.  Change this operation to PRINT, set the outq and no join allowed.
/6609 *   Save prior values so you can reset them after the print has occured.

T6375c                   if        not blnNativePDF
/6609C                   if        Interface = 'S' or
/    C                             Interface = '*' and
/    C                             opcd      = 'M' and
J5849C                             IsSplMail = TRUE and
/6609C                             objty     = 'R' or
/    C                             Interface = '*' and
/    C                             opcd      = 'S' and
J5953C                             IsSplMail =  TRUE and
/6690C                             objty     = 'R'
/    C                   movel     opcd          opcdsv            1
/    C                   eval      opcd      = 'P'
/    C                   movel     outq          outqsav          10
/    C                   eval      outq      = 'SPYGLSOUTQ'
/    C                   movel     @joins        joinsv            2
/    C                   move      joins         joinsv
/    C                   eval      @joins    = 'N'
/    C                   eval      joins     = 'N'
/    C                   MOVE      'S'           MLSPML
/    C                   MOVE      LDA           LDASAV
/    C                   else
/    C                   MOVE      ' '           MLSPML
/    C                   MOVE      LDA           LDASAV
/6609C                   ENDIF
T6375c                   endif

     C     *INKL         CABEQ     '1'           SHOWS1                         F12

      *========================================*
      *    Validation complete                 *
      *    Process data to output              *
      *========================================*
      * Use DtaQ
     C     OBJTY         IFEQ      'I'
     C     @JOINS        OREQ      'Y'
     C     JOINS         OREQ      'Y'
     C                   MOVE      'Y'           USEDDQ            1
     C                   ENDIF

T7063c                   eval      emlddq = '0'

       // Force subid, sublst or email addresses into list.
J4788  addEmailEntry(mlto60);
J4788c                   if        getEmailEntry('*COUNT') > 1
     c                             and (opcd = 'M' or
J5953c                             opcd = 'P' and IsSplMail = TRUE )
T7063c                   eval      useddq = 'Y'
/    c                   eval      emlddq = '1'
/    c                   endif

      * InfoMsg
     C     PROMPT        IFEQ      'Y'
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS

     C     JOBTYP        IFEQ      '1'
     C                   MOVE      'P00056A'     @ERCON                         "Sending
     C                   EXSR      RTVMSG
     C     RRNAM         IFNE      *BLANKS                                      Rep name
     C     @MSGTX        CAT(P)    RRNAM:1       ANYMSG
     C                   ELSE
     C     @MSGTX        CAT(P)    RTYPID:1      ANYMSG                         Repid
     C                   ENDIF
     C                   MOVE      'P00056B'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:1      ANYMSG                         "to"
     C                   SELECT
     C     OPCD          WHENEQ    'P'                                          Print
     C     OUTQ          IFNE      *BLANKS
     C                   MOVE      'P00056C'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:1      ANYMSG                         "outq"
     C                   CAT       OUTQ:1        ANYMSG                          OutQ/Writer
     C                   ELSE
     C                   MOVE      'P00056D'     @ERCON
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:1      ANYMSG                         "writer"
     C                   CAT       WRITER:1      ANYMSG
     C                   END
     C     OPCD          WHENEQ    'F'                                          Fax
     C                   CAT       FOUTQ:1       ANYMSG
     C     OPCD          WHENEQ    'D'                                          Outfile
     C                   CAT       OUTFIL:1      ANYMSG
     C     OPCD          WHENEQ    'M'                                          Mail
     C                   CAT       MLTO:1        ANYMSG
     C     OPCD          WHENEQ    'I'                                          IFS
     C                   CAT       'IFS.'        ANYMSG
     C                   ENDSL
     C                   WRITE     ANYKEY
     C                   ENDIF
     C                   ENDIF

     C     PRTWND        IFEQ      'Y'
/5220C     OPCD          ANDNE     'P'
     C                   EXSR      EXTWIN                                       GetExtWinEnv
     C                   ELSE
     C                   CLEAR                   NUMWND
     C                   ENDIF

     C     OPCD          IFNE      'M'                                          Not mail
     C     FAXSAV        ANDEQ     *BLANKS
/6609C     MLSPML        ANDNE     'S'                                          not SpoolMail
     C                   MOVE      'N'           FAXSAV
     C                   ENDIF

     C     OPCD          IFNE      'P'                                          Not Print
     C     FAXHLD        ANDEQ     *BLANKS
     C                   MOVE      'N'           FAXHLD
     C                   ENDIF
     C                   MOVE      FILNAM        LFILNA
     C                   MOVE      JOBNAM        LJOBNA
     C                   MOVE      USRNAM        LUSRNA
     C                   MOVE      USRDTA        LUSRDT
     C                   MOVE      PGMOPF        LPGMOP

     C     OPCD          IFEQ      'P'                                          Print
/6609C     MLSPML        ANDNE     'S'                                          Not SpoolMail
     C                   SELECT                                                 Save
/2937C     GRPSAV        WHENEQ    'Y'
/    C     SAVE          ANDEQ     '*SYS'
/    C                   MOVE      'Y'           FAXSAV
/    C     GRPSAV        WHENEQ    'N'
/    C     SAVF          ANDEQ     '*SYS'
/    C                   MOVE      'N'           FAXSAV
     C     SAVE          WHENEQ    '*YES'
     C     SAVE          OREQ      '*ORG'
     C     SAVF          ANDEQ     '*YES'
     C                   MOVE      'Y'           FAXSAV
     C     SAVE          WHENEQ    '*NO '
     C     SAVE          OREQ      '*ORG'
     C     SAVF          ANDEQ     '*NO '
     C                   MOVE      'N'           FAXSAV
     C                   OTHER
     C                   MOVE      'N'           FAXSAV
     C                   ENDSL

     C                   SELECT                                                 Hold
/2937C     GRPHLD        WHENEQ    'Y'
/    C     HOLD          ANDEQ     '*SYS'
/    C                   MOVE      'Y'           FAXHLD
/    C     GRPHLD        WHENEQ    'N'
/    C     HOLD          ANDEQ     '*SYS'
/    C                   MOVE      'N'           FAXHLD
     C     HOLD          WHENEQ    '*YES'
     C     HOLD          OREQ      '*ORG'
     C     HLDF          ANDEQ     '*YES'
     C                   MOVE      'Y'           FAXHLD
     C     HOLD          WHENEQ    '*NO '
     C     HOLD          OREQ      '*ORG'
     C     HLDF          ANDEQ     '*NO '
     C                   MOVEL     'N'           FAXHLD
     C                   OTHER
     C                   MOVE      'N'           FAXHLD
     C                   ENDSL
     C                   END

     C     *DTAARA       DEFINE    *LDA          LDA                            Write LDA
     C                   OUT       LDA

     C                   Z-ADD     LOCSFA        PTRA              9 0          Attrib locat
     C                   Z-ADD     LOCSFD        PTRD              9 0          Data locatio
     C                   Z-ADD     LOCSFP        PTRP              9 0          Page table l
      *------------
      * PC printing
      *------------
     C     OPCD          IFEQ      'P'                                          Print
     C                   MOVEL     PRTTYP        F4A               4
     C     2             SUBST     PRTTYP:5      PCPRT                          Printer nbr
     C     F4A           IFEQ      '*LPC'
     C     F4A           OREQ      '*RPC'
     C                   MOVE      'N'           JOINS
     C                   MOVE      'N'           @JOINS
      * Local
     C     F4A           IFEQ      '*LPC'                                       Local
     C                   CLEAR                   NODEID
     C                   CLEAR                   OPCODE
     C                   MOVE      '1'           CHKSRV            1
     C                   CALL      'CHKSRV'      PLCHK                  50      Srvr active?
     C     PLCHK         PLIST
     C                   PARM                    NODEID           17
     C                   PARM      OBJTY         TYPDOC            1
     C                   PARM                    OPCODE           10
     C                   PARM      'PRINT'       CHKACT           10
     C                   PARM                    RTNCDE
     C     RTNCDE        IFNE      *BLANKS                                       No, error
     C                   EXSR      RETRN
     C                   ENDIF
     C                   ENDIF

     C                   MOVEL     REPIDX        BTCHNO                         B.........
     C                   MOVEL     'MAG210'      @FILE            10            From 210
     C                   MOVE      @FRMPG        STROFS                         ofsets
     C                   MOVE      @TOPG         ENDOFS
     C                   MOVE      'P'           ACTION                         print
     C                   MOVEL     WQUSRN        RMTUSR                         remote user
     C                   Z-ADD     COPIES        PCCOPY                         copies
     C     OBJTY         IFEQ      'R'
     C                   Z-ADD     FRMPAG        PCSTRP
     C                   Z-ADD     TOPAGE        PCENDP
     C                   ELSE
     C                   Z-ADD     @FRMPG        PCSTRP
     C                   Z-ADD     @TOPG         PCENDP
     C                   END
     C                   MOVE      IMGPAG        PCIMGP
     C                   Z-ADD     @FRMPG        F90               9 0
     C                   MOVE      F90           SDTSPG
     C                   Z-ADD     @TOPG         F90               9 0
     C                   MOVE      F90           SDTEPG

      * Additional OmniLink server data for reports

     C     OBJTY         IFEQ      'R'
     C                   MOVE      TOTPAG        SDTTPG                         Total pages

     C     SDTFLG        IFEQ      *OFF                                         Non-spylink
     C                   MOVEL     'Rpt'         BTCHNO
     C                   MOVE      *BLANKS       @FILE

     C                   MOVEL     FLDR          FLDR1
     C                   MOVEL     FLDRLB        FLDRL1
     C                   MOVEL     FILNAM        FILNA1
     C                   MOVEL     JOBNAM        JOBNA1
     C                   MOVEL     USRNAM        USRNA1
     C                   MOVEL     JOBNUM        JOBNU1
     C                   MOVE      FILNUM        FILN#C
     C                   MOVEL     REPIDX        SDTNA1

     C                   MOVEL     REPIDX        SDTNAM
     C                   MOVEL     FLDRLB        SDTLIB
     C                   MOVEL     FILNAM        FILNA2
     C                   MOVEL     JOBNAM        JOBNA2
     C                   MOVEL     PGMOPF        PGMOP2
     C                   MOVEL     USRNAM        USRNA2
     C                   MOVEL     USRDTA        USRDT2
     C                   MOVEL     'P'           SDTMOD                         Print mode (as400 ov

     C                   MOVEL     REPLOC        SDTLOC
     C                   MOVEL(P)  'RPT'         SDTFEX                         File extent
     C                   ENDIF
     C                   ENDIF

     C                   EXSR      CHKNOT                                       Check notes

     C                   MOVE      SDT1          SDTRC1
     C                   MOVE      SDT2          SDTRC2
     C                   MOVE      SDT3          SDTRC3

     C                   CALL      'QSNDDTAQ'                                   Use DataQ.
     C                   PARM      'SPYCSDQ'     QNAME            10            Queanamename
     C                   PARM      LPGMLB        QLIB             10            Que library
     C                   PARM      1024          QDTASZ            5 0          Data size
     C                   PARM                    QDTA                           Data
     C                   PARM      17            QKEYSZ            3 0          Key size
     C                   PARM                    NODEID           17            Key

     C                   MOVE      'N'           USEDDQ                         NotUsingDtaQ
     C                   MOVE      'Y'           USEDPC            1            Using PC
/6522C                   clear                   @ercon
/6522C                   goto      savout
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      'N'           USEDPC

     C     *LIKE         DEFINE    REPIDX        SPYNUM
     C                   MOVE      REPIDX        SPYNUM

     C     UPGTBL        IFEQ      '1'
     C     'YN':'yn'     XLATE     PRTWND        PRTWND
     C                   ELSE
     C     REPLOC        IFNE      '4'                                          R/dars optic
     C     REPLOC        ANDNE     '5'                                          R/dars qdls
     C     REPLOC        ANDNE     '6'                                          Imageview op
     C                   MOVE      *BLANKS       PTABLE                         Distribution
     C                   END
     C                   ENDIF


      *------------------------------------------------
      * If using the Mag210 DtaQ, just send parms to it
      *         (the call to MAG2039 comes later).
      * Else call MAG2039 with data in parm list now.
      *------------------------------------------------
     C     USEDDQ        IFEQ      'Y'                                          Using DtaQ
     C     DQACT         IFNE      'Y'                                            Use first
     C                   MOVE      OPCD          RQOP                              join OpCd
     C                   ENDIF
T5978c                   exsr      sendObjectSR

     C                   ELSE                                                   No DataQ
     C                   CLEAR                   KEY20A
     C                   MOVEL(P)  RPTNAM        RPTPRM
     C                   MOVEL(P)  OUTFRM        FRMPRM
/7112c                   if        outfrm = '*ORIG'
/7112c                   eval      frmprm = frmtyp
/7112c                   endif
     C                   MOVEL     RPTUD         UDPRM
T5978c                   exsr      sendObjectSR
     C                   ENDIF                                                     w/parms

/6522C     SAVOUT        TAG

     C                   EXSR      SAVARA                                       Save parms

     C     @ERCON        IFNE      *BLANK
     C                   GOTO      SHOWS1
     C                   ENDIF

/6609 *   If SpoolMail is specified and executed it doesn't use DQACT.  If this is allowed
/     *   to go to "Y" you will not receive any images that maybe included in the *omnilink
/6609 *   of the SNDOBJSPY command.

     C     JOINS         IFEQ      'Y'                                          Joining
/6609c     MLSPML        ANDNE     'S'                                          not for SpoolMail
     C                   MOVE      'Y'           DQACT             1             is active
     C                   END

     C     BOTOUT        TAG
     C                   MOVE      JOINS         @JOINS

     C     JOINS         IFEQ      'N'                                          Not joining
     C     USEDDQ        ANDEQ     'Y'                                          DQ prev actv
     C     USEDPC        ANDNE     'Y'                                          Not PC Print
     C     PROMPT        ANDNE     'A'                                          No batch add
     C                   EXSR      CLSDQ                                         Close DtaQ.
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
T5978c     sendObjectSR  begsr


T6375c                   if        JobTyp  = '1' and
T7353c                             Prompt  = 'Y' and (opcd = 'M' or
J5953c                             (IsSplMail = TRUE and mlspml = 'S' and
/    c                             opcdsv = 'M'))

J4788  addEmailEntry(mlto60);
J4788  getMailOpcode = '*FIRST';
J4788  dow getEmailEntry(getMailOpcode:mailEntry) = 0;
J4788    getMailOpcode = '*NEXT';
J4788    mlto60 = mailEntry.recipient;
J4788    mlType = mailEntry.type;

     c                   Out       Lda
     c                   if        useddq = 'Y'
     c                   eval      rqop = opcd
     c                   exsr      snddq                                          to mag2038

/6692c                   If        RtnCde = 'CLOSEW'
     c                   exsr      clsdq
/6692c                   EndIf

     c                   eval      useddq = 'Y'
     c                   else
     c                   exsr      mg2039
     c                   endif
J4788  enddo;
J4788  mlto60 = getRecipientList();

T7063c                   if        useddq = 'Y' and not emlddq
     c                   eval      useddq = 'N'
     c                   endif
     c                   else
     c                   if        useddq = 'Y'
     c                   exsr      snddq                                          to mag2038
     c                   else
     c                   exsr      mg2039
     c                   endif
     c                   endif

     c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SAVARA        BEGSR

      *          Save parms in data area FAXARA, MLARA, or PRTARA
      * Fax
     C                   SELECT
     C                   When      (OpCd = 'F') or
     C                             (OpCd = 'I') or
     C                             (OpCd = 'S'
/7063C                               and MlSpml <> 'S')
     C                   MOVEL     OUTQ#         OUTQ
     C                   MOVEL     OUTQL#        OUTQL
     C     *LOCK         IN        FAXARA
     C                   MOVE      LDA           FAXARA
     C                   OUT       FAXARA
      * eMail
     c                   When      (OpCd = 'M')
     C     *LOCK         IN        MLARA
     C                   MOVE      LDA           MLARA
     C                   OUT       MLARA
      * Print
     C     OPCD          WHENEQ    'P'
/1964C     RPPRTS        ANDNE     'N'
     C     *LOCK         IN        PRTARA
     C                   Z-ADD     FRMCOL        LFMCOL
     C                   Z-ADD     TOCOL         LTOCOL
/3523
/3523C     OVRPRT        IFEQ      'N'
     C                   MOVEL     PRINTR        LPRNTR
/3523C                   ENDIF
/3523

     C                   MOVEL     OUTQ          LOUTQ
     C                   MOVEL     OUTQL         LOUTQL
/3523
/3523C     OVRPRT        IFEQ      'N'
     C                   MOVEL     PRTF          LPTRF
     C                   MOVEL     PRTLIB        LPTRFL
/3523C                   ENDIF
/3523
     C                   MOVEL     WRITER        LWRITR
/2806C                   MOVEL     OUTFRM        LOUTFR
/2806C                   MOVEL     PRTTYP        LPRTYP
/2806C                   MOVEL     DJEBEF        LDJEBF
/2806C                   MOVEL     DJEAFT        LDJEAF
/2806C                   MOVEL     BANNID        LBANNR
/2806C                   MOVEL     INSTRU        LNSTRU
/2806C                   MOVEL     PRTNOD        LPRNOD
/2806C                   MOVEL     'Y'           LOADED
/3585C                   MOVEL     HOLD          LHOLD
/3585C                   MOVEL     SAVE          LSAVE
/3585C                   MOVEL     COPIES        LCOPIE
     C                   OUT       PRTARA

      //  Preserve the settings from the prior selection for
      //  Use with SpoolMail since the operation code had been
      //  Toggled from S for SpoolMail to P for Print.

/7063C                   If        opcdsv = 'M' or
/    C                             opcdsv = 'S'
/    C     *LOCK         IN        MLARA
/    C                   MOVE      LDA           MLARA
/    C                   OUT       MLARA
/    C                   EndIf

     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHCALL        BEGSR
      *          Choice for ALL  1=Print  2=DB  3=Fax  4=Mail


     C     SHOWS0        TAG
     C                   MOVE      '1'           CHO
      *                 |-----------------|    get operation:
     C                   EXFMT     PRTWDWOP
      *                 |-----------------|    1=print  2=dasd 3=fax
/1452C     @2            TAG
     C     *IN01         IFEQ      *ON
     C                   SELECT
     C     *INKC         WHENEQ    *ON
     C                   MOVE      #KEY          RTNCDE                               Return
     C                   EXSR      RETRN
     C     *INKL         WHENEQ    *ON                                          12=Cancel
     C                   MOVEL     'ERR1385'     RTNCDE                               Return
     C                   EXSR      RETRN
     C     *INKV         WHENEQ    *ON                                          F21
     C                   EXSR      SRF21
     C     #KEY          WHENEQ    HELP                                         Help
     C                   MOVEL(P)  'PRTWDWOP'    HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      PRTWDWOP                               99
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO SHOWS0
/1452C                   GOTO      @2
     C                   ENDSL
     C                   END

     C                   SELECT
     C     CHO           WHENEQ    '1'
     C                   MOVE      'P'           OPCD                           Print
     C     CHO           WHENEQ    '2'
     C                   MOVE      'D'           OPCD                           Dasd
     C     CHO           WHENEQ    '3'
     C                   MOVE      'F'           OPCD                           Fax
     C     CHO           WHENEQ    '4'
     C                   MOVE      'M'           OPCD                           Mail
     C                   OTHER
     C                   GOTO      SHOWS0
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHCSND        BEGSR
      *          Set OPCD for sending: 1=Fax 2=Mail

     C                   SELECT

      * Fax enabled, not mail: must be fax
     C     MLACT         WHENNE    'Y'
     C     FAXTYP        ANDNE     '0'
     C                   MOVE      'F'           OPCD                           Fax

      * Mail enabled, not fax: must be mail
     C     MLACT         WHENEQ    'Y'
     C     FAXTYP        ANDEQ     '0'
     C                   MOVE      'M'           OPCD                           Mail

      * Both are enabled: choose
     C                   OTHER
     C                   MOVE      '1'           CHO                            Default
      *>>>>
     C     SHOWSA        TAG
      *                  -----------------
      *                  |    Send       |
      *                  |   1. Fax      |
      *                  |   2. Email    |
      *                  |---------------|
     C                   EXFMT     PRTWDWSN
      * Fkey             |---------------|
/1452C     @3            TAG
     C     *IN01         IFEQ      *ON
     C                   SELECT
     C     *INKC         WHENEQ    *ON
     C                   MOVE      #KEY          RTNCDE
     C                   EXSR      RETRN
     C     *INKL         WHENEQ    *ON                                          12=Cancel
     C                   MOVEL     'ERR1385'     RTNCDE
     C                   EXSR      RETRN
     C     *INKV         WHENEQ    *ON                                          F21
     C                   EXSR      SRF21
     C     #KEY          WHENEQ    HELP                                         Help
     C                   MOVEL(P)  'PRTWDWSN'    HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
     C     PLHELP        PLIST
     C                   PARM      'MAG210FM'    DSPFIL           10
     C                   PARM                    HLPFMT           10
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      PRTWDWSN                               99
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO SHOWSA
/1452C                   GOTO      @3
     C                   ENDSL
     C                   END

     C                   SELECT
      * Fax and fax is enabled
     C     CHO           WHENEQ    '1'
/2409C     FAXTYP        ANDNE     '0'
     C                   MOVE      'F'           OPCD                           Fax
      * Mail and mail is enabled
     C     CHO           WHENEQ    '2'
/2409C     MLACT         ANDEQ     'Y'
     C                   MOVE      'M'           OPCD                           Mail
      * Error
     C                   OTHER
     C                   GOTO      SHOWSA
     C                   ENDSL
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETENV        BEGSR
      *          If a *ALL environment has been defined for
      *          Big5 report, use significant values from it

     C                   CALL      'MAG2031'
     C                   PARM      WQUSRN        E@USER           10            User or *ALL
     C                   PARM      '*ALL'        E@ENAM           10            *ALL EnvName
     C                   PARM                    ENVIRI                         Rtn DS
     C                   PARM      'RSTOR'       E@OPCD            5            Op code
     C                   PARM                    FILNAM                         Big5
     C                   PARM                    JOBNAM                          :
     C                   PARM                    USRNAM                          :
     C                   PARM                    USRDTA                          :
     C                   PARM                    PGMOPF                          :

     C     E@OPCD        IFNE      'FAIL'
      * If NOT a SpyLink/Dist call (@TOPG<1): Use from-to pgs,copies
     C     @TOPG         IFLT      1
      *   From pg
     C     E@FPA@        IFNE      *BLANKS                                       Test *char
     C     E@FPAG        ANDGT     *ZERO                                         b4 *dec
     C                   Z-ADD     E@FPAG        FRMPAG
     C                   END
      *   To pg
     C     E@TPA@        IFNE      *BLANKS
     C     E@TPAG        ANDGT     *ZERO
     C                   Z-ADD     E@TPAG        TOPAGE
     C                   END
      *   Copies
     C     @COPIE        IFLT      1
     C     E@CPY@        ANDNE     *BLANKS
     C     E@CPYS        ANDGT     *ZERO
     C                   Z-ADD     E@CPYS        COPIES
     C                   END
     C                   END
      * Always
      *   From col
     C     E@FCO@        IFNE      *BLANKS
     C     E@FCOL        ANDGT     *ZERO
     C                   Z-ADD     E@FCOL        FRMCOL
     C                   END
      *   To col
     C     E@TCO@        IFNE      *BLANKS
     C     E@TCOL        ANDGT     *ZERO
     C                   Z-ADD     E@TCOL        TOCOL
     C                   END
      *   SpyPrtr
     C     E@SPTR        IFNE      *BLANKS
     C                   MOVE      E@SPTR        PRINTR
     C                   END
      *   Writer
     C     E@WRTR        IFNE      *BLANKS
     C                   MOVE      E@WRTR        WRITER
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DODB          BEGSR
      *          Call MAG2041 to create an empty report file on Dasd

     C     PROMPT        IFEQ      'Y'                                          Want Prompt
     C                   CLEAR                   PTRMSG

J6624 /free
J6624  if routlib <> ' ';
J6624    outflb = routlib;
J6624    atrb28 = PROTEC;
J6624  endif;
J6624 /end-free

      *>>>>
     C     SHOWD1        TAG
     C     *INKD         IFEQ      *OFF
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   ENDIF
     C                   EXFMT     FILOUT
/1452C     @4            TAG

     C     *IN01         IFEQ      *ON                                          Vldcmdkey
     C     *INKC         IFEQ      *ON                                          F3=Cancel
     C                   MOVEL     'ERR1385'     RTNCDE                               Return
     C                   EXSR      RETRN
     C                   ENDIF
     C     #KEY          IFEQ      HELP                                         Help
     C                   MOVEL(P)  'FILOUT'      HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      FILOUT                                 99
/1452C                   MOVE      #IN99         *IN99
/1452C                   GOTO      @4
     C                   END
     C     *INKL         CABEQ     *ON           ENDDB                          F12=Cancel
     C                   ENDIF
     C                   ENDIF
      * Check values
     C                   EXSR      CHKDB
     C     @ERCON        IFNE      *BLANKS                                      error
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        PTRMSG
     C                   GOTO      SHOWD1
     C                   ENDIF
      * Check for file Existence and prompt if there.
     C                   MOVEL     OUTFIL        APIFLB           20
     C                   MOVE      OUTFLB        APIFLB
     C                   Z-ADD     116           @ERLEN
     C                   CALL      'QUSROBJD'
     C                   PARM                    @OBJD                          Retrieve
     C                   PARM      180           APILEN                         Object
     C                   PARM      'OBJD0200'    APIFMT            8            Description
     C                   PARM      APIFLB        APIOBJ           20
     C                   PARM      '*FILE'       APITYP           10
     C                   PARM                    ERRCD
      * File exists
     C     @ERCON        IFEQ      *BLANKS
      *>>>>
     C     FILEX         TAG
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   EXFMT     FILEXS                                       FilExistOps
     C     *IN01         IFEQ      *ON                                           Vldcmdkey
     C     *INKC         IFEQ      *ON
     C     *INKL         OREQ      *ON
     C                   GOTO      SHOWD1
     C                   ENDIF
     C                   GOTO      FILEX
     C                   ENDIF

     C                   SELECT
     C     CHO           WHENEQ    'D'                                          Delete
     C     'DLTF'        CAT(P)    'FILE(':1     CLCMD
     C                   CAT       OUTFLB:0      CLCMD
     C                   CAT       '/':0         CLCMD
     C                   CAT       OUTFIL:0      CLCMD
     C                   CAT       ')':0         CLCMD
     C                   EXSR      RUNCL
     C     *IN33         IFEQ      *ON
     C                   MOVEL     'ERR1605'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        PTRMSG
     C                   GOTO      SHOWD1
     C                   ENDIF
     C     CHO           WHENEQ    'A'                                          Append
      * fall thru
     C     CHO           WHENEQ    'I'                                          IP Nw Fil
     C                   GOTO      SHOWD1
     C                   OTHER
     C                   GOTO      FILEX
     C                   ENDSL
     C                   ENDIF

     C                   CALL      'MAG2041'                                    Create reprt
     C                   PARM                    OUTFIL                         output file
     C                   PARM                    OUTFLB                         in library
     C                   CLEAR                   FAXNUM
     C     ENDDB         ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DOFAX         BEGSR
      *          Do the Faxing stuff

      * Load Attach Cmd and Attach flag to LDA.
     C     DOCNAM        IFNE      *BLANKS
     C                   MOVE      'A'           PRMFAX                         AttachDoc2Fx
     C                   SELECT
     C     ACMDCD        WHENEQ    '1'                                          Sysenv.
     C                   MOVEL(P)  DSKMSR        ATCCMD                         PrtDmDoc-cmd
     C                   OTHER
     C                   MOVE      *BLANKS       ATCCMD                         Error
     C                   MOVE      *BLANKS       DOCNAM
     C                   MOVE      *BLANKS       PRMFAX
     C                   ENDSL
     C                   ENDIF

     C     PROMPT        IFEQ      'Y'                                          Want Prompt
     C     PROMPT        OREQ      'N'                                          OR no bch
     C     FAXNUM        ANDEQ     *BLANK                                       AND no fax#
     C     PROMPT        OREQ      'C'                                          OR close bch
     C     FAXNUM        ANDEQ     *BLANK                                       AND no fax#

     C     FAXTYP        IFEQ      '2'                                          IBM SndFax
     C     FAXTYP        OREQ      'A'                                          IBM SbmFax
     C     FAXTYP        OREQ      '6'                                          Directfax
     C     FAXTYP        OREQ      '7'                                          TelexFax
     C     FAXTYP        OREQ      '8'                                          FaxServer
     C                   MOVEL(P)  FAXNUM        FX2NUM
     C                   MOVEL(P)  FAXTO         FX2TO                          Load screen
     C                   MOVEL(P)  FAXFRM        FX2FRM                         fields.
     C                   MOVEL(P)  FAXTX1        FX2TX1
     C                   MOVEL(P)  FAXTX2        FX2TX2
     C                   MOVEL(P)  FAXTX3        FX2TX3
     C                   MOVEL(P)  FAXTX4        FX2TX4
     C                   MOVEL(P)  FAXTX5        FX2TX5
     C                   MOVEL(P)  FAXRE         FX2RE
     C                   ENDIF

     C                   CLEAR                   PTRMS3

     C     FAXSAV        IFEQ      *BLANKS
     C                   MOVE      #FAXSV        FAXSAV
     C                   END

      * Load brand-specific fields.
     C                   SELECT
      * FaxStar
     C     FAXTYP        WHENEQ    '1'
     C                   MOVEL(P)  RFXFRM        FRMNAM                         Form
     C                   MOVEL(P)  RFXLAN        FAXSTY                         Style
     C                   MOVEL(P)  RFXCPI        FAXHC                          Cpi
     C                   MOVEL(P)  RFXLPI        FAXVC                          Lpi
      * IBM
     C     FAXTYP        WHENEQ    '2'                                          SndFax
     C     FAXTYP        OREQ      'A'                                          SbmFax
     C                   MOVEL     RFXCPF        FCPRTF
     C                   MOVEL     RFXCPL        FCPRTL
      * Rydex
     C     FAXTYP        WHENEQ    '3'
     C                   Z-ADD     0             FAXTPM
     C                   Z-ADD     0             FAXLPP
      * FastFax
/4876C     FAXTYP        WHENEQ    '4'
/    C                   Z-ADD     0             FAXTPM
/    C                   Z-ADD     0             FAXLPP
/    C                   MOVEL(P)  RFXCPI        FAXHC                          Cpi
/    C                   MOVEL(P)  RFXLPI        FAXVC                          Lpi
/2720c                   if        frmnam = ' '
/    c                   eval      frmnam = rfxfrm
/    c                   endif
      * Telex
     C     FAXTYP        WHENEQ    '7'
     C                   MOVEL     RFXCPF        CVRID
     C                   ENDSL

     C     SHOWF1        TAG
     C     @ERCON        IFEQ      *BLANK
     C                   MOVE      *BLANK        PTRMSG
     C                   ELSE
     C                   EXSR      RTVERM
     C                   MOVEL(P)  ERRMSG        PTRMS3
     C                   ENDIF

     C     *INKD         IFEQ      *OFF
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   ENDIF

     C     SBMJBQ        IFEQ      'N'
     C     FAXTYP        IFEQ      '2'                                          IBM SndFax
     C     FAXTYP        OREQ      'A'                                          IBM SbmFax
     C     FAXTYP        OREQ      '7'                                          TelexFax
     C     FAXTYP        OREQ      '8'                                          FaxServer
/6924c     faxtyp        oreq      'B'
     C                   MOVE      *ON           *IN13                          Allow F13
     C                   ENDIF
     C                   ENDIF
      *       | Execute brand-specific formats  |
     C                   SELECT
      * FaxStar
     C     FAXTYP        WHENEQ    '1'
     C                   MOVEL(P)  '*RPTCFG'     FRMNM8            8             Dos 8 char
     C                   EXFMT     FAXSTAR
     C                   MOVEL(P)  FRMNM8        FRMNAM
     C                   MOVEL(P)  'FAXSTAR'     HLPFMT
      * IBM SndFax
     C     FAXTYP        WHENEQ    '2'
     C                   MOVEL(P)  'SNDFAX'      IBMCMD
     C                   EXFMT     FAXIBM
     C                   MOVEL(P)  'FAXIBM'      HLPFMT
     C                   MOVEL(P)  FX2NUM        FAXNUM
     C                   MOVEL(P)  FX2TO         FAXTO
     C                   MOVEL(P)  FX2TX1        FAXTX1
     C                   MOVEL(P)  FX2TX2        FAXTX2
     C                   MOVEL(P)  FX2FRM        FAXFRM
     C                   MOVEL(P)  FX2TX3        FAXTX3
     C                   MOVEL(P)  FX2TX4        FAXTX4
     C                   MOVEL(P)  FX2TX5        FAXTX5
     C                   MOVEL(P)  FX2RE         FAXRE
      * IBM SbmFax
     C     FAXTYP        WHENEQ    'A'
     C                   MOVEL(P)  'SBMFAX'      IBMCMD
     C                   EXFMT     FAXIBM
     C                   MOVEL(P)  'FAXIBM'      HLPFMT
     C                   MOVEL(P)  FX2NUM        FAXNUM
     C                   MOVEL(P)  FX2TO         FAXTO
     C                   MOVEL(P)  FX2TX1        FAXTX1
     C                   MOVEL(P)  FX2TX2        FAXTX2
     C                   MOVEL(P)  FX2FRM        FAXFRM
     C                   MOVEL(P)  FX2TX3        FAXTX3
     C                   MOVEL(P)  FX2TX4        FAXTX4
     C                   MOVEL(P)  FX2TX5        FAXTX5
     C                   MOVEL(P)  FX2RE         FAXRE
/6924 * FaxCom
/    c                   when      faxtyp = 'B'
/    c                   eval      hlpfmt = 'FAXCOM'
/    c                   exfmt     faxcom
/    c                   movea     '00000'       *in(61)
      * Rydex
     C     FAXTYP        WHENEQ    '3'
     C     SCREEN        IFEQ      1
     C                   EXFMT     FAXRYD1
     C                   MOVEL(P)  'FAXRYD1'     HLPFMT
     C                   ELSE
     C                   EXFMT     FAXRYD2
     C                   MOVEL(P)  'FAXRYD2'     HLPFMT
     C                   ENDIF
      * FastFax
     C     FAXTYP        WHENEQ    '4'
     C     SCREEN        IFEQ      1

/6302c     RepIDX        Chain     MRPTDIR7
/
/     *    Should this contain a PCL *USRASCII file
/     *    Prepopulate the out queue with the correct
/     *    value required for the API FFX325CL
/
/    c                   If        %found
/
/    c                   If        APFTyp = '3'
/    c                   Eval      FOutQ = 'FFXOTQAPI'
/    c                   Eval      FOutQL = 'FASTFAX'
/    c                   EndIf
/
/    c                   EndIf

     C                   EXFMT     FAXFST1
     C                   MOVEL(P)  'FAXFST1'     HLPFMT
     C                   ELSE
     C                   EXFMT     FAXFST2
     C                   MOVEL(P)  'FAXFST2'     HLPFMT
     C                   ENDIF
      * FaxSys
     C     FAXTYP        WHENEQ    '5'
     C     SCREEN        IFEQ      1
     C                   EXFMT     FAXSYS1
     C                   MOVEL(P)  'FAXSYS1'     HLPFMT
     C                   ELSE
     C                   EXFMT     FAXSYS2
     C                   MOVEL(P)  'FAXSYS2'     HLPFMT
     C                   ENDIF
      * DirectFax
     C     FAXTYP        WHENEQ    '6'
     C                   EXFMT     FAXDIR
     C                   MOVEL(P)  'FAXDIR'      HLPFMT
     C                   MOVEL(P)  FX2NUM        FAXNUM
     C                   MOVEL(P)  FX2TO         FAXTO
     C                   MOVEL(P)  FX2TX1        FAXTX1
     C                   MOVEL(P)  FX2TX2        FAXTX2
     C                   MOVEL(P)  FX2FRM        FAXFRM
     C                   MOVEL(P)  FX2TX3        FAXTX3
     C                   MOVEL(P)  FX2TX4        FAXTX4
     C                   MOVEL(P)  FX2TX5        FAXTX5
     C                   MOVEL(P)  FX2RE         FAXRE
      * Telexfax
     C     FAXTYP        WHENEQ    '7'
     C                   EXFMT     FAXTLX
     C                   MOVEL(P)  'FAXTLX'      HLPFMT
     C                   MOVEL(P)  FX2NUM        FAXNUM
     C                   MOVEL(P)  FX2TO         FAXTO
      *                    Moveluserid    faxfrm    p
     C                   MOVEL(P)  FX2RE         FAXRE
     C                   MOVEL(P)  CVRID         FCVRID
      * FaxServer
     C     FAXTYP        WHENEQ    '8'
     C                   EXFMT     FAXSRVR
     C                   MOVEL(P)  'FAXSVR'      HLPFMT
     C                   MOVEL(P)  FX2NUM        FAXNUM
     C                   MOVEL(P)  FX2TO         FAXTO
     C                   MOVEL(P)  FX2TX1        FAXTX1
     C                   MOVEL(P)  FX2TX2        FAXTX2
     C                   MOVEL(P)  FX2FRM        FAXFRM
     C                   MOVEL(P)  FX2TX3        FAXTX3
     C                   MOVEL(P)  FX2TX4        FAXTX4
     C                   CLEAR                   FAXRE                          Remark file
     C     REMFIL        IFNE      *BLANKS
     C     REMLIB        IFNE      *BLANKS
     C     REMLIB        CAT       '/':0         FAXRE
     C                   ENDIF
     C                   CAT       REMFIL:0      FAXRE
     C                   ENDIF
      * Fax/ACS
     C     FAXTYP        WHENEQ    '9'
     C                   EXFMT     FAXACS
     C                   MOVEL(P)  'FAXACS'      HLPFMT
     C                   MOVEL(P)  FRMMSK        FRMNAM
     C                   MOVEL(P)  PGORNT        FAXSTY
     C                   MOVEL(P)  CPICD         FAXHC
     C                   MOVEL(P)  LPICD         FAXVC
     C                   ENDSL
      * All
     C                   CLEAR                   PTRMS3
     C     *IN01         IFEQ      *ON
     C                   SELECT
     C     *INKC         WHENEQ    *ON                                          F3=Exit
     C                   MOVEL     'ERR1385'     RTNCDE
     C                   EXSR      RETRN
     C     *INKL         WHENEQ    *ON                                          F12=Cancel
     C                   GOTO      ENDFAX
     C     #KEY          WHENEQ    F13                                          PromptFaxCmd
     C     SBMJBQ        ANDNE     'Y'
     C                   MOVE      'Y'           PRMFAX
     C                   GOTO      CHKFAX
     C     #KEY          WHENEQ    HELP                                         Help
     C                   CALL      'SPYHLP'      PLHELP
     C     *INKD         WHENEQ    *ON                                          F4=Prompt
     C                   EXSR      SRF4
     C     *INKV         WHENEQ    *ON                                          F21=CmdLine
     C                   EXSR      SRF21
     C     #KEY          WHENEQ    PRVPG                                        Prev/Next
     C     #KEY          OREQ      NXTPG
     C                   GOTO      CHKFAX
     C                   ENDSL
     C                   GOTO      SHOWF1
     C                   ENDIF
     C                   ENDIF

     C     CHKFAX        TAG
     C     SCREEN        IFEQ      1
     C     PROMPT        ANDNE     'A'
     C     PROMPT        OREQ      'N'
     C                   EXSR      CHKFX1
      * Error
     C     @ERCON        IFNE      *BLANKS
      *     batch
     C     PROMPT        IFNE      'Y'
     C                   MOVEL     @ERCON        RTNCDE
     C                   EXSR      RETRN
      *     interactive
     C                   ELSE
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        PTRMS3
     C                   GOTO      SHOWF1
     C                   END
     C                   END
     C                   END

     C     SCREEN        IFEQ      2
     C     PROMPT        ANDNE     'A'
     C     PROMPT        OREQ      'N'
     C     FAXTYP        IFEQ      '3'
     C     FAXTYP        OREQ      '4'
     C     FAXTYP        OREQ      '5'
     C                   EXSR      CHKFX2
      * Error
     C     @ERCON        IFNE      *BLANKS
      *     batch
     C     PROMPT        IFNE      'Y'
     C                   MOVEL     @ERCON        RTNCDE
     C                   EXSR      RETRN
      *     interactive
     C                   ELSE
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        PTRMS3
     C                   GOTO      SHOWF1
     C                   END
     C                   END
     C                   END
     C                   END
      * Roll
     C     #KEY          IFEQ      PRVPG
     C     SCREEN        IFEQ      2
     C                   SUB       1             SCREEN
     C                   ELSE
     C                   MOVEL     'ERR1608'     @ERCON                           kbd err
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        PTRMS3
     C                   ENDIF
     C                   GOTO      SHOWF1
     C                   ENDIF

     C     #KEY          IFEQ      NXTPG
     C     SCREEN        IFEQ      1
     C     FAXTYP        IFEQ      '3'
     C     FAXTYP        OREQ      '4'
     C     FAXTYP        OREQ      '5'
     C                   ADD       1             SCREEN
     C                   ELSE
     C                   MOVEL     'ERR1608'     @ERCON                         kbd err
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        PTRMS3
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'ERR1608'     @ERCON                         kbd err
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        PTRMS3
     C                   ENDIF
     C                   GOTO      SHOWF1
     C                   ENDIF

     C     ENDFAX        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DOMAIL        BEGSR
      *          Email Stuff

     C                   MOVEL(P)  '*EMAIL'      MLIND
     C                   MOVE      'N'           NOTPRT

/     * OUTPUT FORMAT
/2497C     MLFMT         IFNE      '*TXT'
/    C     MLFMT         ANDNE     '*PDF'
/5939C     EMLEXT        IFEQ      'PDF'
/5939C                   MOVEL     '*PDF'        MLFMT                          DEFAULT FORMAT
/5939C                   ELSE
/    C                   MOVEL     '*TXT'        MLFMT                          DEFAULT FORMAT
/5939C                   ENDIF
/    C                   ENDIF

T5469 *    Determine if the report type is Native PDF
T5469c     RepIdx        Chain     MRptDir7

T5469c                   If        %found

T5469c                   If        apfTyp = NATIVEPDF
T5469c                   Eval      blnNativePDF = TRUE
T5469c                   Else
T5469c                   Eval      blnNativePDF = FALSE
T5469c                   EndIf

T5469c                   Else
T5469c                   Eval      blnNativePDF = FALSE
T5469c                   EndIf

T5469c                   If        blnNativePDF = TRUE
T5469c                   Eval      MlFmt = '*PDF'
T5469c                   EndIf

     C     PROMPT        IFEQ      'Y'                                          Want Prompt
     C                   MOVE      EMLTYP        MLTYPE                         sysdft

      *     Try to figure out the senders email adress
     C     MLDSC         IFEQ      *BLANKS

     C                   CALL      'SPYMLRSN'
     C                   PARM      '*CURRENT'    MLUSR            10            Mailer user
     C                   PARM                    MLADR           256            Mailer adres
     C                   PARM                    MLTXT           256            Mailer descr

     C                   MOVEL     MLTXT         MLDSC                          Mailer descr
     C                   MOVEL     MLADR         MLFRM                          Mailer adres
     C                   ENDIF

     C                   CLEAR                   PTRMS3
      *>>>>
J5953 /free
J5953                    blnTextOnly = ( IsSplMail = FALSE )            and
J5953                                  ( ( quspdt00 = PRTTY_AFPDS     ) or
J5953                                    ( quspdt00 = PRTTY_AFPDSLINE ) or
J5953                                    ( quspdt00 = PRTTY_IPDS      )    );
J5953
J5953                    If blnTextOnly;
J5953                      mlfmt = '*TXT';
J5953                    EndIf;
J5953 /end-free
     C     SHOWML        TAG
     C     @ERCON        IFEQ      *BLANK
     C                   MOVE      *BLANK        PTRMSG
     C                   ELSE
     C                   EXSR      RTVERM
     C                   MOVEL(P)  ERRMSG        PTRMS3
     C                   ENDIF

     C     *INKD         IFEQ      *OFF
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   ENDIF

J4788  mlto60 = getRecipientList();

     C                   EXFMT     EMAIL

/1452C     @5            TAG
      * FKeys
     C     *IN01         IFEQ      *ON
     C                   SELECT
     C     *INKC         WHENEQ    *ON                                          F3=Exit
     C                   MOVEL     'ERR1385'     RTNCDE
     C                   EXSR      RETRN
     C     *INKL         WHENEQ    *ON                                          F12
     C                   GOTO      ENDML
     C     #KEY          WHENEQ    HELP                                         Help
     C                   MOVEL(P)  'EMAIL'       HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      EMAIL                                  99
/1452C                   MOVE      #IN99         *IN99
/1452C                   GOTO      @5
     C     *INKD         WHENEQ    *ON                                          F4=Prompt
     C                   EXSR      SRF4
     C     *INKV         WHENEQ    *ON                                          F21=CmdLine
     C                   EXSR      SRF21
     C                   OTHER
     C                   GOTO      SHOWML
     C                   ENDSL
     C                   GOTO      SHOWML
     C                   ENDIF

J5953C                   If        ( IsFormatError = TRUE )
J5953C                   Goto      ShowMl
J5953C                   EndIf

      //              Test for the contents of the field
      //              named mlTo60 being changed

/    C                   if        mlTo60 = *blanks or
J4788c                             getEmailEntry('*COUNT') <= 0
/    C                   Eval      @ErCon = 'EML0062'
/    C                   Goto      ShowMl
/5978c                   EndIf

     C                   EXSR      CHKML                                         Check mail
     C     @ERCON        CABNE     *BLANKS       SHOWML
     C                   ENDIF
J1554 /free
/                        If ( ( LogEml = YES  )                        and
/                             ( ( @prmpt = YES ) or ( @prmpt = ' ' ) ) and
/                             ( *INKL  = *OFF )                        and
                              ( prompt <> NO  )                            );
/                          Callp(e) EMLIO_NewLog();
/                          Callp(e) EMLIO_SetLogHdr(
/                                     %trimr(mlFrm)
/                                   : %trimr(mlSubj)
/                                   : %trimr(mlText)
/                                   : wqjobn
/                                   : wqusrn
/                                   : %editc(wqjob#:'X')
/                                   : ELMSTS_SENT);
/                        EndIf;
/
/     /End-free
     C     ENDML         TAG
     C                   MOVE      ' '           MLDIST                          No distribu

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKML         BEGSR
      *          Check the entry parms for email

     C                   CLEAR                   @ERCON

      *    The Email type is now handled internally

      * Check mail from address
     C                   CALL      'SPYCHKML'
     C                   PARM      MLFRM         ADRESS          256               Mail adre
     C                   PARM      'E'           ADRTYP            1               Adress ty
     C                   PARM                    ADRERR            1               Rtn error
     C     ADRERR        IFEQ      '1'                                              Error
     C                   MOVEL     'ERR1822'     @ERCON
     C                   GOTO      ECHKML
     C                   ENDIF
/6996 *
/     * Add logic to limit message text to 256 chars
/     *  when using SpoolMail to send a report.
/     *
/     * determine if SpoolMail is being used
T6375c                   if        not blnNativePDF
/6996C                   if        Interface = 'S' or
/    C                             Interface = '*' and
/    C                             opcd      = 'M' and
J5849C                             IsSplMail = TRUE  and
/6996C                             objty     = 'R' or
/    C                             Interface = '*' and
/    C                             opcd      = 'S' and
J5849C                             IsSplMail = TRUE and
/6996C                             objty     = 'R'
/     *
/     * Compress text. This MUST be the same compression" that is
/     *   used in SPYMAIL when Opcd = 'SpoolMail'
/     *
/    C                   Eval      chk_txt = *blanks
/    C                   Do        5             Idx
/    C                   Eval      chk_txt = %trimr(chk_txt) + ' ' + mtx(idx)
/    C                   Enddo
/    C
/     * check for total length > 256 characters
/    C                   if        %len(%trimr(chk_txt)) > 256
/    C                   Movel     'E602018'     @ERCON
/    C                   Goto      ECHKML
/    C                   Endif
/    C
/    C                   Endif
/6996C* end of chgs 6996
T6375c                   endif
/
/     * OUTPUT FORMAT
/2497C     MLFMT         IFNE      '*TXT'
/    C     MLFMT         ANDNE     '*PDF'
/    C                   MOVEL     'ERR157B'     @ERCON
/    C                   GOTO      ECHKML
/    C                   ENDIF
/
     C     ECHKML        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DOIFS         BEGSR
      *          IFS Stuff
     C                   MOVEL(P)  '*IFS'        MLIND
     C                   MOVE      'N'           NOTPRT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MG2039        BEGSR
      *          Call Mag2039 with full parm list

     C     OPCD          IFNE      'F'                                          Not Fax
     C     OPCD          ANDNE     'M'                                          Not MAIL
     C     OPCD          ANDNE     'I'                                          Not IFS
J2473C     opcd          andne     'A'                                          Not PDF IFS
     C     OBJTY         IFEQ      'I'                                           Image
     C                   MOVEA     CVRTXT        CT
     C                   END
/3394
/    C                   CLEAR                   FAXNUM
/
     C                   OUT       LDA
     C                   ELSE                                                   Fax
     C                   MOVEL     OUTQ          OUTQ#            10             Save values
     C                   MOVEL     OUTQL         OUTQL#           10
     C     PROMPT        IFEQ      'Y'                                           210fm
     C                   MOVEL     FOUTQ         OUTQ                            Ovr faxout
     C                   MOVEL     FOUTQL        OUTQL
     C                   ELSE
     C     @OUTQ         IFNE      *BLANKS
     C                   MOVE      @OUTQ         OUTQ                            Use Cmd
     C                   MOVE      @OUTQL        OUTQL                           parms.
     C                   ELSE
     C                   MOVE      LFXOUT        OUTQ                            use SysDft
     C                   MOVE      LFXLIB        OUTQL                           OutQ & Lib
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     OBJTY         IFEQ      'R'                                           REPORT
     C                   Z-ADD     FRMPAG        FPAG7
     C                   Z-ADD     TOPAGE        TPAG7
     C                   ELSE
     C                   Z-ADD     @FRMPG        FPAG7
     C                   Z-ADD     @TOPG         TPAG7
     C                   END

      * If we're writing to dasd for transfer to QDLS shared
      * folder, we will be writing FCFCs for page ejects.
     C     WTFCFC        IFEQ      'Y'
     C                   MOVEL(P)  '*SHRFLD'     OUTQ
     C                   END

/2971 * Use different variables for call so *JOB and *USRPRF outq
/2971 * designation is not lost.
/2971C     *LIKE         DEFINE    OUTQ          JMOUTQ
/2971C     *LIKE         DEFINE    OUTQL         JMOTQL
/2971C                   MOVE      OUTQ          JMOUTQ
/3291C                   MOVE      OUTQL         JMOTQL
J4788  addEmailEntry(mlto60);
J4788  if getEmailEntry('*COUNT') > 1 and
          (opcd = 'M' or opcd = 'P' and IsSplMail = TRUE);
/7063    udprm = %editc(timjoi:'X');
         getMailOpcode = '*FIRST';
         dow getEmailEntryRS(getMailOpcode:mailEntry) = 0;
           getMailOpcode = '*NEXT';

/7063      If FAXSAV = 'N';
/            FAXSAV = *blanks;
/          EndIf;

J4788      mlto60 = mailEntry.recipient;
J4788      mlType = mailEntry.type;

/          out lda;
/          rptprm = '*DTAQ';
/     /END-FREE
/    C                   CALL      'MAG2039'     PL2039                 44      Call w/plist
/     /FREE
/          frmprm = %editc(wqjob#:'X');
/          udprm = %char(%time(timjoi:*iso) +
/              %seconds(i):*iso0);
J4788    enddo;
J4788    mlto60 = getRecipientList();
       else;
/
J3479
/        If ( ( Writer <> *blanks ) and
/             ( Outq   =  USRPRF  )     ) or
/           ( ( Writer <> *blanks ) and
/             ( Outq   =  *blanks )     );
/          Reset APIError;
/          Callp(e) GetWtrInfo( QSPI0100
/                             : %size( QSPI0100 )
/                             : WTRI0100
/                             : Writer
/                             : APIError );
/
/          If ( ( APIError.intBytesA > 0 ) or
/               ( %error = TRUE )             );
/          Else;
/            JMOutQ = QSpOQN01;
/            JMotQL = QSPOQLN;
/          EndIf;
/
/        EndIf;

/
/     /end-free
     C                   CALL      'MAG2039'     PL2039                 44      Call w/plist
T7063c                   endif
     C     PL2039        PLIST
     C                   PARM                    RPTPRM                         1
     C                   PARM                    FRMPRM                         2
     C                   PARM                    UDPRM                          3
     C                   PARM                    FPAG7             7 0          4
     C                   PARM                    TPAG7             7 0          5
/2971C                   PARM                    JMOUTQ
/2971C                   PARM                    JMOTQL
     C                   PARM                    PRTF             10            8
     C                   PARM                    PRTLIB           10            9
     C                   PARM                    FRMCOL                         10
     C                   PARM                    TOCOL                          1
     C                   PARM                    COPIES                         2
     C                   PARM                    WRITER           10            3
     C                   PARM                    OUTFIL           10            4
     C                   PARM                    OUTFLB           10            5
     C                   PARM                    REPLOC                         6
     C                   PARM                    OFRNAM                         7
     C                   PARM                    NUMWND            3 0          8
     C                   PARM      247           #RL               3 0          9
     C                   PARM      81            COLSCN            3 0          20
     C                   PARM                    PTRA                           1 Attrib loc
     C                   PARM                    PTRD                           2 Data loc
     C                   PARM                    PTRP                           3 PageTbl l
     C                   PARM                    FLDR                           4
     C                   PARM                    FLDLIB           10            5
     C                   PARM                    SBMJBQ                         6
     C                   PARM                    PRTWND            1            7
     C                   PARM                    SPYNUM                         8
     C                   PARM                    JBDESC                         9
     C                   PARM                    JBDLIB                         30
     C                   PARM                    PTABLE           20            Pg Tbl Name
     C                   PARM                    CVRPAG                         CovrPgB4/Aft
      * Print duplex: (from WrkSpi only as of Nov '96)
     C                   PARM                    DUPLEX                         *yes/*no
     C                   PARM                    ORIENT                         *land/*port
     C                   PARM                    PRTTYP                         *XI *PVL etc
     C                   PARM                    PRTNOD                         PCsrvrNodeID
     C                   PARM                    CVRMBR                         cover member
     C                   PARM                    PAPSIZ                         paper size
     C                   PARM                    DRAWER                         drawer
/5329c                   parm      NotPrt        pNotesPrint       1            Notes print

/6609 *   If SpoolMail was specified change this back into an email it was changed to look
/     *   like a print for MAG2038 only.

/6609C                   if        MLSPML    = 'S'
/    C                   eval      opcd      = opcdsv                           Reset prior
/    C                   eval      outq      = outqsav                          values
/    C                   movel     joinsv        @joins
/    C                   move      joinsv        joins
/    C                   move      'Y'           lstspm            1
/6609C                   endif

     C     WTFCFC        IFEQ      'Y'
     C                   MOVE      *BLANKS       OUTQ
     C                   END

     C                   IN        LDA
     C     PRMFAX        IFEQ      'E'                                          Error, fax
     C                   MOVE      ERR(28)       @ERCON                         cmd failed.
     C                   MOVE      ERR(28)       RTNCDE
/6924C**   WQPRM         IFGE      73                                           If Cmd retrn
/6924c                   if        jobtyp <> '1'
     C                   EXSR      RETRN                                        now.
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADPRM1        BEGSR
      *          Addtional PRINT parameters

     C                   MOVE      *BLANK        @ERCON
      *>>>>
     C     SHOWS2        TAG
     C     @ERCON        IFEQ      *BLANK
     C                   MOVE      *BLANK        PTRMS2
     C                   ELSE
     C                   EXSR      RTVERM
     C                   MOVEL     ERRMSG        PTRMS2
     C                   ENDIF

     C     PROMPT        IFEQ      'Y'

     C     *INKD         IFEQ      *OFF
     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   END

     C     JOBTYP        IFEQ      '1'                                          Interactive
     C                   MOVE      'MOR0001'     @ERCON                         'More...'
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        @@MORE
/3523
/3523C     *LIKE         DEFINE    PRTF          #PRTF
/3523C     *LIKE         DEFINE    PRTLIB        #PRTFL
/3523C     *LIKE         DEFINE    PRINTR        #PRNTR
/3523
/3523C                   MOVE      PRTF          #PRTF
/3523C                   MOVE      PRTLIB        #PRTFL
/3523C                   MOVE      PRINTR        #PRNTR
/3523
J3479 /free
J4788                    If ( RpPrtS <> 'N' );
/                          Writer = LWritr;
/                        EndIf;
/     /end-free
     C     OBJTY         IFEQ      'I'
     C                   MOVEL(P)  'ADPARMI'     HLPFMT
      *                 |---------------|                  addit parms
     C                   EXFMT     ADPARMI                                        Image
     C                   ELSE
     C                   EXFMT     ADPARM                                         Report
     C                   MOVEL(P)  'ADPARM'      HLPFMT
     C     CALPGM        IFEQ      'MAG203'
     C                   EXSR      RTNPM2                                       Set RtnParms
     C                   ENDIF
     C                   ENDIF
/1452C     @6            TAG
     C     #KEY          CABEQ     F12           ENDF10
     C     #KEY          CABEQ     F3            ENDF10
     C     #KEY          CABEQ     PRVPG         SHOWS2                         Stay on scre

     C     #KEY          IFEQ      F21                                          Cmd line
     C                   EXSR      SRF21
     C                   GOTO      SHOWS2
     C                   END

     C     #KEY          IFEQ      HELP                                         Help
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C     OBJTY         IFEQ      'I'
/1452C                   READ      ADPARMI                                99    Image
/1452C                   ELSE
/1452C                   READ      ADPARM                                 99    Report
/1452C                   ENDIF
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO SHOWS2
/1452C                   GOTO      @6
     C                   END

     C     #KEY          IFEQ      F4
     C     #KEY          OREQ      F9
     C     #KEY          IFEQ      F9
     C                   MOVE      F4            #KEY
     C                   MOVEL(P)  'PRINTR'      FLD
     C                   END
     C                   EXSR      SRF4
     C                   GOTO      SHOWS2
     C                   END
     C                   END
/2806
/2806C     #KEY          IFEQ      F22                                          Reset
/2806C                   EXSR      CLRSCN
/2806C                   EXSR      GETDFT
/2806C                   GOTO      SHOWS2                                         default
/2806C                   END
     C                   END

      * If PC printing requested, set DORPC = '1'
     C                   CLEAR                   DORPC
     C     OPCD          IFEQ      'P'                                          Print
     C                   MOVEL     PRTTYP        F4A               4
     C     F4A           IFEQ      '*RPC'
     C     F4A           OREQ      '*LPC'
     C                   MOVE      '1'           DORPC             1            Yes, PC
     C                   ENDIF
     C                   ENDIF

      * If not printing on a PC, check outq,printer etc.
     C     DORPC         IFNE      '1'
     C                   EXSR      CHKPRT
     C     @ERCON        CABNE     *BLANKS       SHOWS2
     C                   ENDIF

      * Check printer type
     C     OPCD          IFEQ      'P'
     C                   EXSR      CHKTYP
     C     @ERCON        CABNE     *BLANKS       SHOWS2
     C                   ENDIF

     C     OUTFRM        IFEQ      *BLANKS
/3524C     FRMTYP        ANDNE     *BLANKS
     C                   MOVEL     FRMTYP        OUTFRM
     C                   MOVE      'M203036'     @ERCON                         "Output form
/3524C                   MOVE      'M20303B'     @ERCON
     C                   GOTO      SHOWS2
     C                   END
/3523
/3523C     PRTF          IFEQ      *BLANKS
/3523C     PRTLIB        ANDEQ     *BLANKS
/3523C     PRINTR        ANDNE     *BLANKS
/3523
/3523C                   EXSR      GETPTR
/3523
/3523C                   MOVE      PPRTFL        PRTF
/3523C                   MOVE      PPRTLB        PRTLIB
/3523C                   MOVE      PPRTFL        #PRTF
/3523C                   MOVE      PPRTLB        #PRTFL
/3523
/3523C     PRTF          IFNE      *BLANKS
/3523C     PRTLIB        ANDNE     *BLANKS
/3523C                   MOVE      PRTF          PFAFIL
/3523C                   MOVE      PRTLIB        PFALIB
/3523C                   EXSR      $RTPFA
/3523C                   EXSR      $SVHLD
/3523C                   ENDIF
/3523
/3523C                   ENDIF
      * PrtF
/3523C     PRTF          IFNE      *BLANKS
/3523
/3523C     PRTF          IFNE      #PRTF
/3523C     PRTLIB        ORNE      #PRTFL
/3523C                   MOVE      PRTF          PFAFIL
/3523C                   MOVE      PRTLIB        PFALIB
/3523C                   EXSR      $RTPFA
/3523C                   EXSR      $SVHLD
/3523C                   ENDIF
/3523
/3523C                   ENDIF
/3523
/3523C     PRTF          IFEQ      *BLANKS
/3523C     PRTLIB        ANDEQ     *BLANKS
/3523C                   CLEAR                   SPHOLD
/3523C                   CLEAR                   SPSAVE
/3523C                   CLEAR                   PFAMSG
/3523C                   CLEAR                   PFAIND
/3523C                   EXSR      $SVHLD
/3523C                   ENDIF
/3523
/3523C     PRTF          IFEQ      *BLANKS
/3523C     #PRTF         ANDNE     *BLANKS
/3523C     #PRTF         ANDNE     RPTRFL
/3523C     PRINTR        ANDEQ     *BLANKS
/3523C     RPTRFL        ANDNE     *BLANKS
/3523C                   MOVE      RPTRFL        PRTF
/3523C                   MOVE      RPTRLB        PRTLIB
/3523C                   MOVE      RPTRFL        PFAFIL
/3523C                   MOVE      RPTRLB        PFALIB
/3523C                   EXSR      $RTPFA
/3523C                   EXSR      $SVHLD
/3523C                   GOTO      SHOWS2
/3523C                   ENDIF
/3523
     C                   SELECT
     C     PRTF          WHENEQ    *BLANKS
     C     PRTLIB        ANDNE     *BLANKS
     C                   MOVE      'M203045'     @ERCON                         "Enter
     C                   GOTO      SHOWS2                                         PrtF"

     C     PRTLIB        WHENEQ    *BLANKS
     C     PRTF          ANDNE     *BLANKS                                      "Enter
     C                   MOVE      'M203046'     @ERCON                          Prt Lib"
     C                   GOTO      SHOWS2

     C     PRTF          WHENNE    *BLANKS
     C     PRTLIB        ANDNE     *BLANKS
     C                   MOVEL(P)  PRTF          OBJNAM
     C                   MOVEL(P)  PRTLIB        OBJLIB
     C                   MOVEL(P)  '*FILE '      OBJTYP
     C                   EXSR      CHKOBJ
     C     EXISTS        IFEQ      'N'
     C                   MOVE      'M203047'     @ERCON                         "Nonexistent
     C                   GOTO      SHOWS2                                         Prt file"
     C                   END
     C                   ENDSL
      * Copies
     C     COPIES        IFEQ      0
     C                   Z-ADD     1             COPIES
     C                   MOVE      'M203048'     @ERCON                         "Copies"
/3524C                   MOVE      'M20303C'     @ERCON
     C                   GOTO      SHOWS2
     C                   END
      *----------------------------------------------------------------
      * End of error diagnostics.  Begin next screen.
      *----------------------------------------------------------------
      *>>>>
     C     INPRM2        TAG
     C     OBJTY         IFEQ      'I'                                          Image
     C     PRTTYP        IFEQ      '*PCL'                                       If HP or
     C     PRTTYP        OREQ      '*XI'                                         XIonics
     C     PRTTYP        OREQ      '*AFP'                                        AFP
     C                   EXSR      ADPRM2                                       Exfmts
     C     #KEY          CABEQ     PRVPG         SHOWS2                          Prev screen
     C     #KEY          CABEQ     F3            ENDF10                          Exit
     C     #KEY          CABEQ     F12           SHOWS2                          Cancel
     C     #KEY          IFEQ      F21                                           Cmd line
     C                   EXSR      SRF21
     C                   GOTO      SHOWS2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     OBJTY         IFEQ      'R'                                          Report
     C     #KEY          ANDEQ     NXTPG
     C                   EXSR      ADPRMB                                       Exfmts
     C     #KEY          CABEQ     PRVPG         SHOWS2                          Prev screen
     C     #KEY          CABEQ     F3            ENDF10                          Exit
     C     #KEY          CABEQ     F12           SHOWS2                          Cancel
     C     #KEY          IFEQ      F21                                           Cmd line
     C                   EXSR      SRF21
     C                   GOTO      SHOWS2
     C                   ENDIF
     C                   ENDIF
      *>>>>
     C     INCTXT        TAG
     C     CVRPAG        IFNE      '*NONE'
     C     PROMPT        ANDEQ     'Y'
      *                 |---------------|                  text for
     C                   EXFMT     ADPARMT                                      cover page
/1452C     @7            TAG
     C     #KEY          CABEQ     PRVPG         INPRM2                         Prev screen
     C     #KEY          CABEQ     F12           INPRM2                         Cancel
     C     #KEY          IFEQ      F21                                          Cmd line
     C                   EXSR      SRF21
     C                   GOTO      INCTXT
     C                   END
     C     #KEY          IFEQ      HELP                                         Help
     C                   MOVEL(P)  'ADPARMT'     HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      ADPARMT                                99
/1452C                   MOVE      #IN99         *IN99
/1452C                   GOTO      @7
     C                   END
     C                   END

     C     ENDF10        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKTYP        BEGSR
      *          Check the prttyp field

     C                   MOVEL     PRTTYP        F4A               4            1st 4 pos.

     C     PRTTYP        IFNE      '*PCL'                                       Not...PCL
     C     PRTTYP        ANDNE     *BLANKS
     C     PRTTYP        ANDNE     '*XI'                                         Xionics
     C     F4A           ANDNE     '*LPC'                                        Local PC
     C     F4A           ANDNE     '*RPC'                                        Remote PC
     C     PRTTYP        ANDNE     '*AFP'                                        AFP
     C                   MOVE      'ERR1610'     @ERCON                         No good...
     C                   GOTO      ENDTYP
     C                   ENDIF

     C     F4A           IFEQ      '*LPC'                                       Local PC
     C     F4A           OREQ      '*RPC'                                       Remote PC

     C     OBJTY         IFEQ      'I'                                          Image
     C     #KEY          IFEQ      NXTPG                                        NxtPgNotVal
     C                   MOVE      'ERR1816'     @ERCON                         w/LPC or RPC
     C                   GOTO      ENDTYP
     C                   ENDIF
     C                   ENDIF

     C                   SUBST     PRTTYP:5      F6A               6
     C     ' '           CHECKR    F6A           F6L               2 0
     C     F6L           IFGT      2                                            Too long
     C                   MOVE      'ERR1611'     @ERCON                         Number
     C                   GOTO      ENDTYP                                       invalid
     C                   ELSE
     C     F6L           IFGT      0                                            Blank OK
     C     NUM           CHECK     F6A           F6P               2 0          Check num
     C     F6P           IFGT      0
     C     F6P           ANDLE     F6L
     C                   MOVE      'ERR1611'     @ERCON                         Number
     C                   GOTO      ENDTYP                                       invalid
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     F4A           IFEQ      '*LPC'                                       Local PC
     C                   CLEAR                   NODEID
     C                   CLEAR                   OPCODE
     C                   MOVE      '1'           CHKSRV            1
     C                   CALL      'CHKSRV'      PLCHK                  50      Srvr active?
     C     RTNCDE        IFNE      *BLANKS
     C                   MOVEL     RTNCDE        @ERCON
     C                   GOTO      ENDTYP
     C                   ENDIF
     C                   ENDIF

     C     F4A           IFEQ      '*RPC'                                       Remote PC

     C     PRTNOD        IFEQ      *BLANKS                                      SpyPtrNode
     C                   SELECT
     C     RPNODE        WHENNE    *BLANKS
     C                   MOVE      RPNODE        PRTNOD                          SysDefault
     C     SYSNOD        WHENNE    *BLANKS
     C                   MOVE      SYSNOD        PRTNOD                          SysDefault
     C                   ENDSL
     C                   ELSE
     C     PRTNOD        IFEQ      '*RPTCFG'                                    SpyPtrNode
     C                   MOVE      RPNODE        PRTNOD                          Rept cfg
     C                   ENDIF
     C     PRTNOD        IFEQ      '*SYSDFT'                                    SpyPtrNode
     C                   MOVE      SYSNOD        PRTNOD                          SysDefault
     C                   ENDIF
     C                   ENDIF

     C     PRTNOD        IFEQ      *BLANKS                                      Still empty
     C                   MOVE      'ERR1612'     @ERCON                         "No Remote
     C                   GOTO      ENDTYP                                        defined"
     C                   ENDIF

     C                   MOVEL     PRTNOD        NODEID
     C                   MOVEL(P)  '*RPC'        OPCODE
     C                   MOVE      '1'           CHKSRV            1
     C                   CALL      'CHKSRV'      PLCHK                  50      Srvr active?
     C     RTNCDE        IFNE      *BLANKS
     C                   MOVEL     RTNCDE        @ERCON
     C                   GOTO      ENDTYP
     C                   ENDIF
     C                   ENDIF
     C     ENDTYP        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKPRT        BEGSR

     C     OUTQ          IFEQ      '*RPTCFG'                                     *RptConfig
     C                   SELECT
     C     RDEFQ         WHENNE    *BLANK                                        RMaint
     C                   MOVE      RDEFQ         OUTQ                             OutQ
     C                   MOVE      RDEFL         OUTQL                            OutQ Lib
     C     OQOPLC        WHENEQ    '*RPTCFG'                                     SysDft
     C                   MOVEL(P)  '*USRPRF'     OUTQ                             use UsrPrf
     C                   MOVE      *BLANKS       OUTQL
     C                   OTHER
     C                   MOVE      'ERR116D'     @ERCON                         "Not configd
     C                   GOTO      ENDPRT
     C                   END
     C                   END

     C                   MOVEL(P)  '*ALL'        LKPOBJ
     C                   MOVEL(P)  '*LIBL'       LKPLIB
     C                   MOVE      *OFF          *IN45
      * Outq
     C     OUTQ          IFNE      '*USRPRF'
     C     OUTQ          ANDNE     '*JOB'
     C     '*'           SCAN      OUTQ                                   45
     C     *IN45         IFEQ      *ON
     C                   MOVEL(P)  'OUTQ'        FLD
     C                   MOVE      F4            #KEY
     C                   END
     C                   END

     C     OUTQL         IFEQ      *BLANKS
     C     *IN45         ANDEQ     *ON
     C                   MOVE      'M203034'     @ERCON                         "OutQ libr
     C                   GOTO      ENDPRT
     C                   END
      * Writer
     C     *IN45         IFEQ      *OFF
     C     WRITER        ANDNE     '*USRPRF'
     C     WRITER        ANDNE     '*JOB'
     C     '*'           SCAN      WRITER                                 45
     C     *IN45         IFEQ      *ON
     C                   MOVEL(P)  'WRITER'      FLD
     C                   MOVE      F4            #KEY
     C                   END
     C                   END
      *----------------------------------------------------------------
      * Begin error diagnostics
      *----------------------------------------------------------------
     C     RPTNAM        IFEQ      *BLANKS
     C                   MOVEL     '*ORIG'       RPTNAM
     C                   MOVE      'M203035'     @ERCON                         "SplF name
/3524C                   MOVE      'M20303A'     @ERCON
     C                   GOTO      ENDPRT
     C                   END

     C     RPTNAM        IFNE      '*ORIG'                                      check for
     C     'WRKOUTQ'     CAT       RPTNAM:1      F255A           255            valid name
     C                   CALL      'SPYCLCHK'
     C                   PARM                    F255A
     C                   PARM      *BLANKS       ERRTXT          255
     C     ERRTXT        IFNE      *BLANKS
     C                   MOVEL     '*ORIG'       RPTNAM
     C                   MOVE      'M203035'     @ERCON                         "SplF name
/3524C                   MOVE      'M20303A'     @ERCON
     C                   GOTO      ENDPRT
     C                   ENDIF
     C                   ENDIF
      * SpyPrinter
     C     PRINTR        IFNE      *BLANKS
     C                   EXSR      GETPTR
     C     *IN42         IFEQ      *ON                                          Not found
     C                   MOVE      'M203037'     @ERCON                         "Printer
     C                   GOTO      ENDPRT
     C                   ENDIF
     C                   END
      * OutQ+Wrtr
     C                   SELECT
     C     OUTQ          WHENEQ    *BLANKS                                      Need ONE
     C     WRITER        ANDEQ     *BLANKS                                      of these
     C                   MOVE      'M203041'     @ERCON                         "No output
     C                   GOTO      ENDPRT
     C     OUTQ          WHENNE    *BLANKS                                      "Not both
     C     OUTQ          ANDNE     '*USRPRF'
     C     OUTQ          ANDNE     '*JOB'
     C     WRITER        ANDNE     *BLANKS                                       present"
     C                   MOVE      'M203042'     @ERCON
     C     PROMPT        CABEQ     'Y'           ENDPRT
     C                   MOVE      *BLANKS       OUTQ
     C                   ENDSL
      * OutQ
     C                   SELECT
     C     OUTQ          WHENEQ    *BLANKS
     C     OUTQ          ANDNE     '*USRPRF'
     C     OUTQ          ANDNE     '*JOB'
     C     OUTQL         ANDNE     *BLANKS
     C                   MOVE      'M203038'     @ERCON                         "OutQ
     C                   GOTO      ENDPRT                                         needed

     C     OUTQ          WHENEQ    '*USRPRF'                                    If OutQ is
     C     OUTQ          OREQ      '*JOB'                                       *special
     C                   MOVE      *BLANKS       OUTQL                          clear libr

     C     OUTQ          WHENNE    *BLANKS                                      If user outq
     C     OUTQ          ANDNE     '*JOB'
     C     OUTQ          ANDNE     '*USRPRF'
     C     OUTQL         IFEQ      *BLANKS
     C                   MOVEL     '*LIBL'       OUTQL                          default*LIBL
     C                   END
      * OutQ exist?
     C                   EXSR      OQEXST                                       OutQ exist?
     C     EXISTS        IFEQ      'N'                                          No
     C     OQOPLC        IFEQ      '*RPTCFG'                                     SYSDFT *rpt
     C     PROMPT        ANDNE     'Y'                                           No screen
     C                   MOVEL(P)  '*USRPRF'     OUTQ                            Use UsrPrf
     C                   MOVE      *BLANKS       OUTQL
     C                   ELSE
     C                   MOVE      'M203044'     @ERCON                         "Nonexistent
     C                   GOTO      ENDPRT                                         OutQ"
     C                   END
     C                   END
     C                   ENDSL
      * Writer
     C     WRITER        IFNE      *BLANKS
     C     WRITER        ANDNE     '*USRPRF'
     C     WRITER        ANDNE     '*JOB'
     C                   MOVEL(P)  'QSYS'        OBJLIB
     C                   MOVE      WRITER        OBJNAM
     C                   MOVEL(P)  '*DEVD'       OBJTYP
     C                   EXSR      CHKOBJ
     C     EXISTS        IFEQ      'N'
     C                   MOVE      'M203043'     @ERCON                         "Writer not
     C                   GOTO      ENDPRT                                         found"
     C                   END
     C                   END
     C     ENDPRT        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OQEXST        BEGSR
/2971
/2971 * Only check for existence of outq if not *JOB and not *USRPRF.
/2971C     OUTQ          IFNE      '*JOB'
/2971C     OUTQ          ANDNE     '*USRPRF'
/2971
      *          Does OutQ exist?  Input:  OUTQ, OUTQL
      *                            Output: EXISTS= Y or N
      *                                    OUTQ, OUTQL  (If *RPTCFG in)

     C     OUTQL         IFEQ      *BLANKS
     C                   MOVEL     '*LIBL'       OUTQL
     C                   ENDIF

     C     OUTQ          IFEQ      '*USRPRF'
     C                   MOVE      'Y'           EXISTS
     C                   ELSE
     C     OUTQ          IFEQ      '*RPTCFG'
     C                   MOVE      RDEFQ         OUTQ                             OutQ
     C                   MOVE      RDEFL         OUTQL                            OutQ Lib
     C                   END
     C                   MOVE      OUTQ          OBJNAM
     C                   MOVE      OUTQL         OBJLIB                         Check exist
     C                   MOVEL(P)  '*OUTQ'       OBJTYP
     C                   EXSR      CHKOBJ
     C                   END
/2971
/2971C                   ENDIF
/2971
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WTEXST        BEGSR
      *          Does Writer exist?  Input:  WRITER
      *                              Output: EXISTS= Y or N

     C     WRITER        IFEQ      '*JOB'
     C     WRITER        OREQ      '*USRPRF'
     C                   MOVE      'Y'           EXISTS
     C                   ELSE
     C                   MOVE      WRITER        OBJNAM
     C                   MOVEL(P)  'QSYS'        OBJLIB                         Check exist
     C                   MOVEL(P)  '*DEVD'       OBJTYP
     C                   EXSR      CHKOBJ
     C     EXISTS        IFEQ      'Y'
     C     OBJAT3        ANDNE     'PRT'
     C                   MOVE      'N'           EXISTS
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADPRM2        BEGSR
      *          ExFmts for Duplex printing

     C     #KEY          IFEQ      NXTPG
     C                   MOVE      'MOR0002'     @ERCON                         'Bottom'
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        @@MORE
      *>>>>
     C     SHOWSD        TAG
     C     *INKD         IFEQ      '0'
     C                   CLEAR                   WINPOS
     C                   CLEAR                   WINLIN
     C                   ENDIF
     C     @ERCON        IFEQ      *BLANK
     C                   MOVE      *BLANK        PTRMS2
     C                   ELSE
     C                   EXSR      RTVERM
     C                   MOVEL     ERRMSG        PTRMS2
     C                   END
     C     PROMPT        IFEQ      'Y'                                          PROMPT is
     C                   EXFMT     ADPARMD                                      (D)uplex
/1452C     @8            TAG
     C     #KEY          CABEQ     NXTPG         SHOWSD                         NxtPg=Repete
     C     #KEY          CABEQ     F12           ENDDUP                         Cancel
     C     #KEY          CABEQ     F3            ENDDUP                         Exit
     C     #KEY          IFEQ      F21                                          Cmd line
     C                   EXSR      SRF21
     C                   GOTO      SHOWSD
     C                   END
     C     #KEY          IFEQ      HELP                                         Help
     C                   MOVEL(P)  'ADPARMD'     HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      ADPARMD                                99
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO SHOWSD
/1452C                   GOTO      @8
     C                   END
     C     #KEY          IFEQ      F4                                           F4 prompt
     C                   EXSR      SRF4
     C                   GOTO      SHOWSD
     C                   ENDIF
     C                   END

/6763C     CVRPAG        IFEQ      *BLANKS                                      Cover Page
     C                   MOVEL(P)  '*NONE'       CVRPAG
     C                   END

/6763C     CVRPAG        IFNE      '*BEFORE'
/    C     CVRPAG        ANDNE     '*AFTER'
/    C     CVRPAG        ANDNE     '*NONE'
/    C     CVRPAG        ANDNE     '*TOP'
/    C     CVRPAG        ANDNE     '*BOTTOM'
/    C     CVRPAG        ANDNE     '*TOPP1'
/    C     CVRPAG        ANDNE     '*BOTP1'
/    C                   MOVE      'M20303D'     @ERCON
/    C                   GOTO      SHOWSD
/    C                   END

/6763c                   if        (%subst(cvrpag:1:4) = '*TOP' or
/    c                             %subst(cvrpag:1:4) = '*BOT') and
/    c                             prttyp <> '*PCL'
/    C                   MOVE      'M20303E'     @ERCON
/    C                   GOTO      SHOWSD
/    C                   END

     C     DUPLEX        IFNE      '*YES'
     C     DUPLEX        ANDNE     '*NO'
     C     DUPLEX        ANDNE     '*ORG'
/3390C                   EXSR      DFTDUP                                       DUPLEX DFT VALU
/6847C                   MOVE      'M20304B'     @ERCON
     C                   GOTO      SHOWSD
     C                   END

      * Check papersize with ctl file
     C     KEYCTL        KLIST
     C                   KFLD                    CNAME
     C                   KFLD                    CTYPE
     C                   KFLD                    CKEY
     C                   MOVEL(P)  'ORIENT'      CNAME
     C                   MOVEL     'RC'          CTYPE                            Record
     C                   MOVEL     ORIENT        CKEY
     C     KEYCTL        SETLL     SPYCTLF                                50
     C     *IN50         IFEQ      '0'
     C                   MOVEL(P)  '*AUTO'       ORIENT
/6847C                   MOVE      'M20304C'     @ERCON
     C                   GOTO      SHOWSD
     C                   ENDIF

      * Check papersize with ctl file
     C     'IMG'         CAT(P)    'PAPSIZ'      CNAME
     C                   MOVEL     'RC'          CTYPE                            Record
     C                   MOVEL     PAPSIZ        CKEY
     C     KEYCTL        SETLL     SPYCTLF                                50
     C     *IN50         IFEQ      '0'
     C                   MOVEL     'SV'          CTYPE                            Special va
     C     KEYCTL        SETLL     SPYCTLF                                50
     C     *IN50         IFEQ      '0'
     C                   MOVEL(P)  '*LEGAL'      PAPSIZ
     C                   MOVE      'ESE000A'     @ERCON
     C                   GOTO      SHOWSD
     C                   ENDIF
     C                   ENDIF
     C                   END
     C     ENDDUP        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADPRMB        BEGSR

     C     #KEY          IFEQ      NXTPG
     C                   MOVE      'MOR0002'     @ERCON                         'Bottom'
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        @@MORE

     C     SHOWSB        TAG
     C     *INKD         IFEQ      '0'
     C                   CLEAR                   WINPOS
     C                   CLEAR                   WINLIN
     C                   ENDIF
     C     @ERCON        IFEQ      *BLANK
     C                   MOVE      *BLANK        PTRMS2
     C                   ELSE
     C                   EXSR      RTVERM
     C                   MOVEL     ERRMSG        PTRMS2
     C                   END
     C     PROMPT        IFEQ      'Y'                                          PROMPT is
     C                   EXFMT     ADPARMB
/1452C     @9            TAG
     C     #KEY          CABEQ     NXTPG         SHOWSB                         NxtPg=Repete
/2806C     #KEY          CABEQ     F9            SHOWSB                         Not Vld here
     C     #KEY          CABEQ     F12           ENDAPB                         Cancel
     C     #KEY          CABEQ     F3            ENDAPB                         Exit
     C     #KEY          IFEQ      F21                                          Cmd line
     C                   EXSR      SRF21
     C                   GOTO      SHOWSB
     C                   END
/2806
/2806C     #KEY          IFEQ      F22                                          Reset
/2806C                   EXSR      CLRSCN
/2806C                   EXSR      GETDFT
/2806C                   GOTO      SHOWSB                                         default
/2806C                   END
     C     #KEY          IFEQ      HELP                                         Help
     C                   MOVEL(P)  'ADPARMB'     HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      ADPARMB                                99
/1452C                   MOVE      #IN99         *IN99
/1452C                   GOTO      @9
     C                   END
     C     #KEY          IFEQ      F4                                           F4 prompt
     C                   EXSR      SRF4
     C                   GOTO      SHOWSB
     C                   ENDIF
     C                   END
      * Dje
     C     DJEBEF        IFNE      *BLANKS
     C     DJEBEF        CHAIN     RPRTDJE                            42
     C     *IN42         IFEQ      *ON
     C                   MOVE      'M203081'     @ERCON                         "DJE seq non
     C                   GOTO      SHOWSB
     C                   END
     C                   END

     C     DJEAFT        IFNE      *BLANKS
     C     DJEAFT        CHAIN     RPRTDJE                            42
     C     *IN42         IFEQ      *ON
     C                   MOVE      'M203081'     @ERCON                         "DJE seq non
     C                   GOTO      SHOWSB
     C                   END
     C                   END
      * Banner
     C     BANNID        IFNE      *BLANKS
     C     BANNID        CHAIN     RBNDBAN                            42
     C     *IN42         IFEQ      *ON
     C                   MOVE      'M203082'     @ERCON                         "Banner ID
     C                   GOTO      SHOWSB
     C                   END
     C                   END
      * Drawer
     C     DRAWER        IFNE      '*E1'
     C     DRAWER        ANDNE     '*ORG'
     C     NUM           CHECK     DRAWER                                 50
     C     *IN50         IFEQ      '1'
     C                   MOVE      'M203401'     @ERCON                         "Drawer
     C                   GOTO      SHOWSB
     C                   END
     C                   END
      * Instruct
     C     INSTRU        IFNE      *BLANKS
     C     INSTRU        CHAIN     RBNDINS                            42
     C     *IN42         IFEQ      *ON
     C                   MOVE      'M203083'     @ERCON                         "Instruct ID
     C                   GOTO      SHOWSB
     C                   END
     C                   END

     C     DUPLEX        IFNE      '*YES'
     C     DUPLEX        ANDNE     '*NO'
/2757C     DUPLEX        ANDNE     '*ORG'
/3390C                   EXSR      DFTDUP                                       DUPLEX DFT VALU
     C                   GOTO      SHOWSB
     C                   END
     C                   END
     C     ENDAPB        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPYPRM        BEGSR
     C                   CALL      'SPYCTL'                             50
     C                   PARM                    CTLNAM           10
     C                   PARM                    CTLTYP            2
     C                   PARM      *BLANKS       CTLKEY           10
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF4          BEGSR
      *          F4=Prompt key

     C                   EXSR      SRCURS
     C                   MOVE      *BLANKS       CTLTYP

     C                   SELECT
     C     FLD           WHENEQ    'MLTYPE'                                     Mail type
     C                   MOVEL(P)  'MAILTYPE'    CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL     CTLKEY        MLTYPE
     C                   ENDIF

     C     FLD           WHENEQ    'MLTO60'                                     Mail to
J4788  showEmailList(mlto60);
/6763C     FLD           WHENEQ    'CVRPAG'                                     Cover Page
/    C                   MOVEL(P)  'CVRPAG'      CTLNAM
/    C                   EXSR      SPYPRM
/    C     CTLKEY        IFNE      *BLANKS
/    C                   MOVEL     CTLKEY        CVRPAG
/    C                   ENDIF

     C     FLD           WHENEQ    'ORIENT'                                     Orientation
     C                   MOVEL(P)  'ORIENT'      CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL     CTLKEY        ORIENT
     C                   ENDIF

     C     FLD           WHENEQ    'PRTTYP'                                     Printer Type
     C     RCD           ANDEQ     'ADPARMI'                                    on image add
     C     'IMGPTR'      CAT(P)    'TYP':0       CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL     CTLKEY        PRTTYP
     C                   ENDIF

     C     FLD           WHENEQ    'DRAWER'                                     Drawer
     C                   MOVEL(P)  'DRAWER'      CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C     CTLKEY        IFNE      '#'
     C                   MOVEL(P)  CTLKEY        DRAWER
     C                   ELSE
     C                   MOVEL(P)  '1'           DRAWER
     C                   ENDIF
     C                   ENDIF

     C     FLD           WHENEQ    'DUPLEX'                                     Duplex
     C                   MOVEL(P)  'DUPLEX'      CTLNAM
     C     OBJTY         IFEQ      'I'                                          Image
     C                   MOVEL     'RC'          CTLTYP                         Only rc
     C                   ENDIF
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL     CTLKEY        DUPLEX
     C                   ENDIF

     C     FLD           WHENEQ    'PAPSIZ'                                     Paper size
     C     'IMG'         CAT(P)    'PAPSIZ'      CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL     CTLKEY        PAPSIZ
     C                   ENDIF

     C     FLD           WHENEQ    'PRINTR'
     C                   CALL      'WRKPTR'                             45
     C                   PARM                    PRINTR
     C                   PARM                    WFILT            10
     C                   PARM                    OUTQ             10
     C                   PARM                    OUTQL            10
     C                   PARM                    RTNPTR            8

     C     PRINTR        IFNE      *BLANKS
     C                   EXSR      GETPTR
     C                   END

     C     FLD           WHENEQ    'OUTQ'
     C     FLD           OREQ      'OUTQL'
     C     OUTQL         IFNE      *BLANKS
     C                   MOVE(P)   OUTQL         LKPLIB
     C                   ELSE
     C                   MOVEL     '*LIBL'       LKPLIB
     C                   ENDIF
     C                   CALL      'MAG2042'                            45
     C                   PARM      '*ALL'        LKPOBJ           10
     C                   PARM                    LKPLIB           10
     C                   PARM      '*OUTQ'       LKPTYP           10
     C                   PARM      *BLANKS       LKPATR           10
     C                   PARM      *BLANKS       RETOBJ           10
     C                   PARM      *BLANKS       RETLIB           10
     C     RETOBJ        IFNE      *BLANKS
     C                   MOVE      RETOBJ        OUTQ
     C                   END
     C     RETLIB        IFNE      *BLANKS
     C                   MOVE      RETLIB        OUTQL
     C                   END
     C     FLD           WHENEQ    'FOUTQ'
     C     FLD           OREQ      'FOUTQL'
     C     FOUTQL        IFNE      *BLANKS
     C                   MOVE(P)   FOUTQL        LKPLIB
     C                   ELSE
     C                   MOVEL     '*LIBL'       LKPLIB
     C                   ENDIF
     C                   CALL      'MAG2042'                            45
     C                   PARM      '*ALL'        LKPOBJ           10
     C                   PARM                    LKPLIB           10
     C                   PARM      '*OUTQ'       LKPTYP           10
     C                   PARM      *BLANKS       LKPATR           10
     C                   PARM      *BLANKS       RETOBJ           10
     C                   PARM      *BLANKS       RETLIB           10
     C     RETOBJ        IFNE      *BLANKS
     C                   MOVE      RETOBJ        FOUTQ
     C                   END
     C     RETLIB        IFNE      *BLANKS
     C                   MOVE      RETLIB        FOUTQL
     C                   END

     C     FLD           WHENEQ    'WRITER'
     C                   CALL      'MAG2042'                            45
     C                   PARM      '*ALL'        LKPOBJ
     C                   PARM      '*LIBL'       LKPLIB
     C                   PARM      '*DEVD'       LKPTYP
     C                   PARM      'PRT*  '      LKPATR
     C                   PARM      *BLANKS       RETOBJ
     C                   PARM      *BLANKS       RETLIB
     C     RETOBJ        IFNE      *BLANKS
     C                   MOVE      RETOBJ        WRITER
     C                   END

     C     FLD           WHENEQ    'DJEBEF'
     C                   CALL      'WRKDJD'
     C                   PARM                    DJEBEF
     C                   PARM      '1'           WLIST
     C                   PARM                    RTNCDE

     C     FLD           WHENEQ    'DJEAFT'
     C                   CALL      'WRKDJD'
     C                   PARM                    DJEAFT
     C                   PARM      '1'           WLIST
     C                   PARM                    RTNCDE

     C     FLD           WHENEQ    'BANNID'
     C                   CALL      'WRKBID'
     C                   PARM                    BANNID
     C                   PARM      '1'           WLIST             1
     C                   PARM                    RTNCDE

     C     FLD           WHENEQ    'INSTRU'
     C                   CALL      'WRKINS'
     C                   PARM                    INSTRU
     C                   PARM      '1'           WLIST
     C                   PARM                    RTNCDE
      *                                                     Excpt
     C     FLD           WHENEQ    'PRTF'
     C                   MOVE      DEVFN         PRTF
     C                   MOVE      DEVFL         PRTLIB
     C                   ENDSL
      * User exit program for fax f4
     C     SFXF4P        IFNE      '*NONE'
     C     SFXF4P        ANDNE     *BLANKS
     C                   EXSR      FAXF4
     C                   ENDIF
     C                   ENDSR

/5978 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/5978C     FAXF4         BEGSR

     C                   SELECT
      * Faxstar
     C     FAXTYP        WHENEQ    '1'
     C     FLD           IFEQ      'FAXNUM'
     C     FLD           OREQ      'FAXFRM'
     C     FLD           OREQ      'FAXTO'
     C     FLD           OREQ      'FAXRE'
     C     FLD           OREQ      'FAXTX1'
     C     FLD           OREQ      'FAXTX2'
     C     FLD           OREQ      'FAXTX3'
     C     FLD           OREQ      'FAXTX4'
     C     FLD           OREQ      'FAXTX5'

     C                   EXSR      CALF4

     C     F4NUM         IFNE      *BLANKS
     C                   MOVEL(P)  F4NUM         FAXNUM                           Fax nbr
     C                   ENDIF
     C     F4FRM1        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM1        FAXFRM                           Fax frm
     C                   ENDIF
     C     F4TO1         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO1         FAXTO                            Fax to
     C                   ENDIF
     C     F4REF         IFNE      *BLANKS
     C                   MOVEL(P)  F4REF         FAXRE                            Fax ref
     C                   ENDIF
     C     F4TXT1        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT1        FAXTX1                           Fax text1
     C                   ENDIF
     C     F4TXT2        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT2        FAXTX2                           Fax text2
     C                   ENDIF
     C     F4TXT3        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT3        FAXTX3                           Fax text3
     C                   ENDIF
     C     F4TXT4        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT4        FAXTX4                           Fax text4
     C                   ENDIF
     C     F4TXT5        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT5        FAXTX5                           Fax text5
     C                   ENDIF
     C                   ENDIF
      * IBMfax --------------------------------------------------------
     C     FAXTYP        WHENEQ    '2'
     C     FLD           IFEQ      'FX2NUM'
     C     FLD           OREQ      'FX2TO'
     C     FLD           OREQ      'FX2TX1'
     C     FLD           OREQ      'FX2TX2'
     C     FLD           OREQ      'FX2FRM'
     C     FLD           OREQ      'FX2TX3'
     C     FLD           OREQ      'FX2TX4'
     C     FLD           OREQ      'FX2RE'
     C     FLD           OREQ      'FX2TX5'
     C                   EXSR      CALF4
     C     F4NUM         IFNE      *BLANKS
     C                   MOVEL(P)  F4NUM         FX2NUM                           Fax nbr
     C                   ENDIF
     C     F4TO1         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO1         FX2TO                            Fax to 1
     C                   ENDIF
     C     F4TO2         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO2         FX2TX1                           Fax to 2
     C                   ENDIF
     C     F4TO2         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO3         FX2TX2                           Fax to 3
     C                   ENDIF
     C     F4FRM1        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM1        FX2FRM                           Fax frm 1
     C                   ENDIF
     C     F4FRM2        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM2        FX2TX3                           Fax frm 1
     C                   ENDIF
     C     F4FRM3        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM3        FX2TX4                           Fax frm 1
     C                   ENDIF
     C     F4REF         IFNE      *BLANKS
     C                   MOVEL(P)  F4REF         FX2RE                            Fax ref
     C                   ENDIF
     C     F4TXT1        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT1        FX2TX5                           Fax text
     C                   ENDIF
     C                   ENDIF
      * Rydex ---------------------------------------------------------
     C     FAXTYP        WHENEQ    '3'
     C     FLD           IFEQ      'FAXTX1'
     C     FLD           OREQ      'FAXNUM'
     C     FLD           OREQ      'FAXTO'
     C     FLD           OREQ      'FAXRE'
     C     FLD           OREQ      'FAXFRM'
     C                   EXSR      CALF4
     C     F4NUM         IFNE      *BLANKS
     C                   MOVEL(P)  F4NUM         FAXNUM                           Fax nbr
     C                   ENDIF
     C     F4REF         IFNE      *BLANKS
     C                   MOVEL(P)  F4REF         FAXTX1                           Fax ref
     C                   ENDIF
     C     F4TO1         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO1         FAXTO                            Fax to
     C                   ENDIF
     C     F4AT          IFNE      *BLANKS
     C                   MOVEL(P)  F4AT          FAXRE                            Fax ref
     C                   ENDIF
     C     F4FRM1        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM1        FAXFRM                           Fax from
     C                   ENDIF
     C                   ENDIF
      * Fastfax -------------------------------------------------------
     C     FAXTYP        WHENEQ    '4'
     C     FLD           IFEQ      'FAXNUM'
     C     FLD           OREQ      'FAXFRM'
     C     FLD           OREQ      'FAXTO'
     C     FLD           OREQ      'FAXTX1'                                      Text
     C     FLD           OREQ      'FAXTX2'
     C     FLD           OREQ      'FAXTX3'
     C                   EXSR      CALF4
     C     F4NUM         IFNE      *BLANKS
     C                   MOVEL(P)  F4NUM         FAXNUM                           Fax nbr
     C                   ENDIF
     C     F4FRM1        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM1        FAXFRM                           Fax frm
     C                   ENDIF
     C     F4TO1         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO1         FAXTO                            Fax to
     C                   ENDIF
     C     F4TXT1        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT1        FAXTX2                           Fax ref
     C                   ENDIF
     C     F4TXT2        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT2        FAXTX3                           Fax ref
     C                   ENDIF
     C     F4REF         IFNE      *BLANKS
     C                   MOVEL(P)  F4REF         FAXTX1                           Fax text1
     C                   ENDIF
     C                   ENDIF
      * Faxsys --------------------------------------------------------
     C     FAXTYP        WHENEQ    '5'
     C     FLD           IFEQ      'FAXNUM'
     C     FLD           OREQ      'FAXFRM'
     C     FLD           OREQ      'FAXTO'
     C     FLD           OREQ      'FAXTX1'
     C     FLD           OREQ      'FAXTX2'
     C     FLD           OREQ      'FAXTX3'
     C                   EXSR      CALF4
/2403C     F4NUM         IFNE      *BLANKS
     C                   MOVEL(P)  F4NUM         FAXNUM                           Fax nbr
     C                   ENDIF
     C     F4FRM1        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM1        FAXFRM
     C                   ENDIF
     C     F4TO1         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO1         FAXTO
     C                   ENDIF
     C     F4TXT1        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT1        FAXTX1
     C                   ENDIF
     C     F4TXT2        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT2        FAXTX2
     C                   ENDIF
     C     F4TXT3        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT3        FAXTX3
     C                   ENDIF
     C                   ENDIF
      * Directfax -----------------------------------------------------
     C     FAXTYP        WHENEQ    '6'
     C     FLD           IFEQ      'FX2NUM'
     C     FLD           OREQ      'FX2TO'
     C     FLD           OREQ      'FX2TX1'
     C     FLD           OREQ      'FX2TX2'
     C     FLD           OREQ      'FX2FRM'
     C     FLD           OREQ      'FX2TX3'
     C     FLD           OREQ      'FX2TX4'
     C     FLD           OREQ      'FX2RE'
     C     FLD           OREQ      'FX2TX5'
     C                   EXSR      CALF4
     C     F4NUM         IFNE      *BLANKS
     C                   MOVEL(P)  F4NUM         FX2NUM                           Fax nbr
     C                   ENDIF
     C     F4TO1         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO1         FX2TO                            Fax to 1
     C                   ENDIF
     C     F4TO2         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO2         FX2TX1                           Fax to 2
     C                   ENDIF
     C     F4TO2         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO3         FX2TX2                           Fax to 3
     C                   ENDIF
     C     F4FRM1        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM1        FX2FRM                           Fax frm 1
     C                   ENDIF
     C     F4FRM2        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM2        FX2TX3                           Fax frm 1
     C                   ENDIF
     C     F4FRM3        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM3        FX2TX4                           Fax frm 1
     C                   ENDIF
     C     F4REF         IFNE      *BLANKS
     C                   MOVEL(P)  F4REF         FX2RE                            Fax ref
     C                   ENDIF
     C     F4TXT1        IFNE      *BLANKS
     C                   MOVEL(P)  F4TXT1        FX2TX5                           Fax text
     C                   ENDIF
     C                   ENDIF
      * TelexFax ------------------------------------------------------
     C     FAXTYP        WHENEQ    '7'
     C     FLD           IFEQ      'FX2NUM'
     C     FLD           OREQ      'FX2TO'
     C     FLD           OREQ      'FX2FRM'
     C     FLD           OREQ      'FX2RE'
     C                   EXSR      CALF4
     C     F4NUM         IFNE      *BLANKS
     C                   MOVEL(P)  F4NUM         FX2NUM                           Fax nbr
     C                   ENDIF
     C     F4TO1         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO1         FX2TO                            Fax to 1
     C                   ENDIF
     C     F4FRM1        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM1        FX2FRM                           Fax frm 1
     C                   ENDIF
     C                   ENDIF
      * FaxServer -----------------------------------------------------
     C     FAXTYP        WHENEQ    '8'
     C     FLD           IFEQ      'FX2NUM'
     C     FLD           OREQ      'FX2TO'
     C     FLD           OREQ      'FX2FRM'
     C     FLD           OREQ      'FX2RE'
     C                   EXSR      CALF4
     C     F4NUM         IFNE      *BLANKS
     C                   MOVEL(P)  F4NUM         FX2NUM                           Fax nbr
     C                   ENDIF
     C     F4TO1         IFNE      *BLANKS
     C                   MOVEL(P)  F4TO1         FX2TO                            Fax to 1
     C                   ENDIF
     C     F4FRM1        IFNE      *BLANKS
     C                   MOVEL(P)  F4FRM1        FX2FRM                           Fax frm 1
     C                   ENDIF
     C                   ENDIF

     C                   ENDSL
     C                   ENDSR

     C     CALF4         BEGSR
      *          Get correct field name for exit pgm

     C     FAXTYP        CAT       FLD:0         F11A             11
     C                   Z-ADD     1             IX                5 0
     C     F11A          LOOKUP    FS(IX)                                 50     Eq
     C     *IN50         IFEQ      '1'
     C                   MOVEL(P)  FP(IX)        F4FLD
     C                   ELSE
     C                   MOVEL(P)  FLD           F4FLD
     C                   ENDIF

      * Call user exit program for F4 on fax screen
     C     SFXF4L        CAT(P)    '/':0         EXTPGM           21
     C                   CAT       SFXF4P:0      EXTPGM

      * Retrieve index values from external program
     C                   CALL      'MAG210SV'                           50
     C                   PARM      'RTVVAL'      SVOPCD           10
     C                   PARM      *BLANKS       SVIV1            99               Value 1
     C                   PARM      *BLANKS       SVIV2            99               Value 2
     C                   PARM      *BLANKS       SVIV3            99               Value 3
     C                   PARM      *BLANKS       SVIV4            99               Value 4
     C                   PARM      *BLANKS       SVIV5            99               Value 5
     C                   PARM      *BLANKS       SVIV6            99               Value 6
     C                   PARM      *BLANKS       SVIV7            99               Value 7
     C                   PARM      *BLANKS       SVIV8             8               Value 8

     C                   CALL      EXTPGM                               50
     C                   PARM      RTYPID        F4DOC            10              Doc id
     C                   PARM                    F4FLD            10              Field
     C                   PARM      POS           F4POS             3 0            Position
     C                   PARM      *BLANKS       F4NUM            50              Fax nbr
     C                   PARM      *BLANKS       F4FRM1           50              Fax frm 1
     C                   PARM      *BLANKS       F4FRM2           50              Fax frm 2
     C                   PARM      *BLANKS       F4FRM3           50              Fax frm 3
     C                   PARM      *BLANKS       F4TO1            50              Fax to 1
     C                   PARM      *BLANKS       F4TO2            50              Fax to 2
     C                   PARM      *BLANKS       F4TO3            50              Fax to 3
     C                   PARM      *BLANKS       F4AT             50              Fax at
     C                   PARM      *BLANKS       F4REF            50              Fax ref
     C                   PARM      *BLANKS       F4TXT1           50              Fax text1
     C                   PARM      *BLANKS       F4TXT2           50              Fax text2
     C                   PARM      *BLANKS       F4TXT3           50              Fax text3
     C                   PARM      *BLANKS       F4TXT4           50              Fax text4
     C                   PARM      *BLANKS       F4TXT5           50              Fax text5
     C                   PARM      SVIV1         F4IV1            99              Value 1
     C                   PARM      SVIV2         F4IV2            99              Value 2
     C                   PARM      SVIV3         F4IV3            99              Value 3
     C                   PARM      SVIV4         F4IV4            99              Value 4
     C                   PARM      SVIV5         F4IV5            99              Value 5
     C                   PARM      SVIV6         F4IV6            99              Value 6
     C                   PARM      SVIV7         F4IV7            99              Value 7
     C                   PARM      SVIV8         F4IV8             8              Value 8

     C   50              EXSR      RMVMSG
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RMVMSG        BEGSR
      *          Remove pgm msg
     C                   MOVE      *LOVAL        MSGLEN
     C                   MOVE      X'64'         MSGLEN
     C                   CALL      'QMHRCVPM'
     C                   PARM                    MSGINF          100
     C                   PARM                    MSGLEN            4
     C                   PARM      'RCVM0100'    MSGFMT            8
     C                   PARM      '*'           MSGPGM           20
     C                   PARM      *LOVAL        MSGSTK            4
     C                   PARM      '*LAST'       MSGTYP           10
     C                   PARM      *BLANKS       MSGKY             4
     C                   PARM      *LOVAL        MSGW              4
     C                   PARM      '*REMOVE'     MSGACT           10
     C                   PARM      *LOVAL        MSGERR            4
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF4A         BEGSR

     C                   EXSR      SRCURS
     C                   SELECT
     C     FLD           WHENEQ    'IMGPAG'
     C     'PAGE'        CAT(P)    'RANGE':0     CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL     CTLKEY        IMGPAG
     C                   ENDIF

     C     FLD           WHENEQ    'JBDESC'
     C     FLD           OREQ      'JBDLIB'
     C                   CALL      'MAG2042'
     C                   PARM      '*ALL'        LKPOBJ                         Retrieve
     C                   PARM      '*LIBL'       LKPLIB                         JobD/Lib
     C                   PARM      '*JOBD'       LKPTYP
     C                   PARM      *BLANKS       LKPATR
     C                   PARM      *BLANKS       RETOBJ
     C                   PARM      *BLANKS       RETLIB
     C     RETOBJ        IFNE      *BLANKS
     C                   MOVE      RETOBJ        JBDESC
     C                   END
     C     RETLIB        IFNE      *BLANKS
     C                   MOVE      RETLIB        JBDLIB
     C                   END
     C     FLD           WHENEQ    'DOCNAM'
     C                   CALL      'WRKDM'                              45
     C                   PARM                    WQUSRN
     C                   PARM      *BLANKS       DOCNAM
     C                   ENDSL
     C                   MOVE      '5'           ERR#
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKOBJ        BEGSR
      *          Return EXISTS=Y/N if object exists/does not exist

     C     OBJNAM        CAT       OBJLIB        OBJECT
     C                   CALL      'QUSROBJD'
     C                   PARM                    @OBJD                          Retrieve
     C                   PARM      180           APILEN                         Object
     C                   PARM      'OBJD0200'    APIFMT            8            Descr
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
     C     RTVERM        BEGSR

      * If pgm called with no prompting, quit, returning error msgid
     C     PROMPT        IFNE      'Y'
     C                   MOVE      @ERCON        RTNCDE                         Retn MSGID
     C                   EXSR      QUIT                                          to caller
     C                   END
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        ERRMSG
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVMSG        BEGSR
      *          Retrieve message text (@MSGTX) for msgid (@ERCON)
     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80
     C                   MOVE      *BLANKS       @ERDTA
     C                   MOVE      *BLANK        @ERCON
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     EXTWIN        BEGSR
      *          Get an External Window Environment

     C     ENVUSR        IFEQ      '*CURRENT'
     C     ENVUSR        OREQ      *BLANKS
     C                   MOVE      WQUSRN        ENVUS            10
     C                   ELSE
     C                   MOVE      ENVUSR        ENVUS
     C                   ENDIF

     C                   OPEN      RWINDOW
     C     RWINKE        CHAIN     WINRC                              45
     C     RWINKE        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C                   KFLD                    ENVUS
     C                   KFLD                    ENVNAM
     C                   CLOSE     RWINDOW
     C     *IN45         IFEQ      *ON
     C                   CLEAR                   ENVIRO
     C                   ELSE
     C                   MOVE      WESP1         ENVI01                         Load Enviro
     C                   MOVE      WESP3         ENVI03
     C                   MOVE      WESP4         ENVI04
     C                   MOVE      WESP5         ENVI05
     C                   MOVE      FILNAM        LFILNA                         Load and
     C                   MOVE      JOBNAM        LJOBNA                         output LDA
     C                   MOVE      PGMOPF        LPGMOP
     C                   MOVE      USRNAM        LUSRNA
     C                   MOVE      USRDTA        LUSRDT
     C                   MOVE      CWSC          @WSC
     C                   MOVE      CWW           @WW
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
     C                   CALL      'QCMDEXC'                            33
     C                   PARM                    CLCMD           255
     C                   PARM      255           CLLEN            15 5
     C   33              EXSR      RMVMSG
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

     C                   MOVE      OPCD          LSTCHC                         FIX BATCH FAX
     C                   CLEAR                   ERROR
     C                   CLEAR                   PRMFAX
     C                   Z-ADD     272           BYTPRV
     C                   Z-ADD     0             BYTAVA
     C                   MOVE      *BLANKS       ERRMSG           50
     C                   MOVE      *BLANKS       OBJECT           20
     C                   MOVE      *BLANKS       OBJTYP           10

     C     *DTAARA       DEFINE                  SYSDFT                         Get System
     C                   IN        SYSDFT                                        defaults

     C     *DTAARA       DEFINE                  PRTARA                         Print parms
     C     *LOCK         IN        PRTARA
     C                   OUT       PRTARA
     C     *DTAARA       DEFINE                  FAXARA                         Fax parms
     C     *LOCK         IN        FAXARA
     C                   OUT       FAXARA
     C     *DTAARA       DEFINE                  MLARA                          Mail parms
     C     *LOCK         IN        MLARA
     C                   OUT       MLARA

     C     APPSEC        IFEQ      'Y'                                          User auth to
     C                   CALL      'MAG1060'                                    chg JobD ?
     C                   PARM      'MAG210'      CALLER           10             Caller
     C                   PARM                    PGMOFF            1             Unlod M1060
     C                   PARM      'O'           CKTYPE            1             Check Obj
     C                   PARM      'A'           OBJCOD            1             (A)pplicatn
     C                   PARM      'MAG210'      OBJNAM                          Object name
     C                   PARM      WQLIBN        OBJLIB                          Object libr
     C                   PARM      *BLANK        BL10             10
     C                   PARM      *BLANK        BL10
     C                   PARM      *BLANK        BL10
     C                   PARM      *BLANK        BL10
     C                   PARM      *BLANK        BL10
     C                   PARM      02            REQOPT            2 0          Get Chg auth
     C                   PARM                    AUTCHG            1            Return Y/N
     C                   PARM                    AUT25            25
     C                   END

     C                   CALL      'MAG8090'                                    Date fmt
     C                   PARM                    DATFMT            3
     C                   PARM                    DATSEP            1
     C                   PARM                    TIMSEP            1

     C     SPTRTY        IFEQ      *BLANKS
     C                   MOVE      '*PCL'        SPTRTY
     C                   END
     C     DATFMT        IFEQ      *BLANKS
     C                   MOVE      'MDY'         DATFMT
     C                   END
     C     SYSNOD        IFEQ      '*NONE'
     C                   MOVE      *BLANKS       SYSNOD
     C                   END

     C     LCKF21        CABNE     'S'                                2121
     C     LMENU         CABNE     'Y'                                2525
      * Vars
     C                   MOVE      *BLANKS       MSGID             7
     C                   MOVE      *BLANKS       ERRMSG           50

     C                   CALL      'MAG1034'                                    Is this
     C                   PARM      ' '           JOBTYP            1            interactive?

      * Get Type of OUTPUT
     C                   MOVEL     'P006239'     @ERCON                         File
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        OPFILE           20
     C                   MOVEL     'P006240'     @ERCON                         Printer
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        OPPRT            20
     C                   MOVEL     'P006241'     @ERCON                         Fax
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        OPFAX            20
     C                   MOVEL     'P00624A'     @ERCON                         Email
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        OPMAIL           20
      * Get location text
     C                   MOVEL     'DSP1003'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        LOC(1)
     C                   MOVEL     'DSP1004'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        LOC(2)
     C                   MOVEL     'DSP1005'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        LOC(3)

     C                   Z-ADD     0             FILNUM
     C                   Z-ADD     0             MDATOP
     C                   MOVE      WQUSRN        ENVUSR
     C                   MOVEL(P)  '*ALL'        ENVNAM
     C                   MOVE      'N'           PRTWND
     C                   MOVE      *BLANKS       RETN6             6
     C                   MOVE      *BLANK        @ERCON
     C                   CALL      'MAG103R'                                    Get opsys
     C                   PARM                    OSRLS             6             version
     C                   CALL      'SPYLOUP'                                    Upper/Lower
     C                   PARM                    LO               60            case table
     C                   PARM                    UP               60
/3523
/3523 * Retrieved override and not found messages for printer file.
/3523C                   MOVE      'PFA0001'     @ERCON
/3523C                   EXSR      RTVMSG
/3523C     *LIKE         DEFINE    PFAMSG        PFAOVR
/3523C                   MOVEL(P)  @MSGTX        PFAOVR
/3523
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETF10        BEGSR
      *          Turn on F10-Additional Parm for display file screen 1

     C                   SELECT
     C     OPCD          WHENNE    'P'                                          Not Printing
     C                   MOVE      *OFF          *IN43                           No autoscrn
     C                   MOVE      *OFF          *IN54                           Hide F10=
     C     REQF10        WHENEQ    'Y'                                          Prtg SysEnv:
     C                   MOVE      *OFF          *IN43                           No autoscrn
     C                   MOVE      *ON           *IN54                           Show F10=Ad
     C                   OTHER
     C                   MOVE      *ON           *IN43                           Auto scrn
     C                   MOVE      *OFF          *IN54                           Hide F10=Ad
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRCURS        BEGSR
      *          Cursor position
     C     CSRLOC        DIV       256           CSRLIN            3 0          Curs-line
     C                   MVR                     CSRPOS            3 0          Curs-pos
     C     WINLOC        DIV       256           WINLIN            3 0          Curs-line
     C                   MVR                     WINPOS            3 0          Curs-pos
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDDQ         BEGSR
      *          Send msg to Data Que

     C     @INTDQ        IFEQ      ' '                                          1st time
     C                   MOVE      'Y'           @INTDQ            1            initialize
     C                   MOVEL(P)  '*DTAQ'       RPTPRM           10             DtaQ fields
     C     PROMPT        IFEQ      'A'                                          Add batch
     C     PROMPT        OREQ      'C'                                          Close batch
     C                   MOVEL(P)  @BCHID        FRMPRM
     C                   MOVE      *BLANKS       UDPRM
     C                   ELSE
     C                   MOVEL(P)  WQJOB#        FRMPRM           10
     C                   TIME                    TIMJOI            6 0
     C                   MOVEL(P)  TIMJOI        UDPRM            10             DtaQ key=
     C                   END                                                      BCH ID or
     C     FRMPRM        CAT       UDPRM:0       KEY20A                           Job6|hhmms
     C                   ENDIF

     C                   MOVE      OBJTY         RQOBTY
     C                   MOVEL(P)  OUTFRM        RQFRM
     C                   MOVEL(P)  RPTUD         RQUD
     C                   MOVEL(P)  RPTNAM        RQRPT
     C                   Z-ADD     NUMWND        RQNWND

     C     OBJTY         IFEQ      'I'                                          Image
     C                   Z-ADD     @FRMPG        RQSPAG
     C                   Z-ADD     @TOPG         RQEPAG
     C                   MOVE      REPIDX        RQFLDR                         Ifile
     C                   MOVEL(P)  @ENVUS        RQFLIB                         Ifile libr
     C                   MOVEL(P)  @ENVNA        RQPTRA                         Rrn
     C                   MOVEL(P)  REPIDX        RQIDX
     C                   MOVE(P)   *BLANKS       RQMBR
     C                   CLEAR                   RQIMPG
     C                   CLEAR                   RQPTRA
     C                   CLEAR                   RQPTRD
     C                   CLEAR                   RQPTRP
/3331C     PRTTYP        IFNE      *BLANKS
     C                   MOVEL     PRTTYP        RQPTYP
/3331C                   ELSE
/    C                   MOVEL     SPTRTY        RQPTYP
/    C                   END
     C                   MOVEL     IMGPAG        RQIMPG

     C                   ELSE                                                   Report
     C                   Z-ADD     FRMPAG        RQSPAG
     C                   Z-ADD     TOPAGE        RQEPAG
     C                   MOVEL(P)  FLDR          RQFLDR
     C                   MOVEL(P)  FLDLIB        RQFLIB
      * Count pages for joined faxing (coverpage)
     C     RQOP          IFNE      'Q'
     C     RQEPAG        SUB       RQSPAG        F90               9 0
     C                   ADD       1             F90
     C                   ADD       F90           JOIPAG            9 0
     C                   ENDIF
     C                   Z-ADD     PTRA          RQPTRA
     C                   Z-ADD     PTRD          RQPTRD
     C                   Z-ADD     PTRP          RQPTRP
     C                   MOVEL(P)  REPLOC        RQLOC
     C                   MOVEL(P)  OFRNAM        RQOPTF
     C                   MOVE      *BLANKS       RQPTYP
     C                   MOVE      *BLANKS       RQIDX
     C                   MOVE      SPYNUM        RQMBR
     C                   MOVE      PRTWND        RQPWND
     C                   MOVE      ENVUSR        RQEUSR
     C                   MOVE      ENVNAM        RQENAM
     C                   END
/5329c                   eval      rqNotesPrint = NotPrt

/2881C     WQPRM         IFGE      76                                           passed

/2399C                   If        ( ( @AdTyp = ADTYP_IFS    ) or                       IFS/QDLS
/    c                               ( @AdTyp = ADTYP_IFSPDF )    )  and
/    c                             ( RQOp <> RQOP_QUIT )
/    c                   Eval      RQOp = RQOP_IFS
/    c                   ElseIf    ( ( @AdTyp = ADTYP_IFS    ) or
/    c                               ( @AdTyp = ADTYP_IFSPDF )    )  and
/    c                             ( RQOp <> RQOP_QUIT )
/    C                   Eval      RQOp = RQOP_IFSPDF
/    C                   EndIf
/    C
/2881C                   EndIf

      * When using the dtaq for multiple pages and mulitple email recipients,
      * add an addtional dtaq entry with the key (job#+time) one second newer
      * than the original for each additional recipient.
J4788  emailCount = getEmailEntry('*COUNT');
J4788c                   if        emailCount > 1 and
/    c                             (opcd = 'M' or opcd = 'P' and usespm = 'Y')
/    c                   eval      %subst(key20a:7:6) = %editc(timjoi:'X')
J4788  for i = 1 to emailCount;
     C                   CALL      'QSNDDTAQ'    sdqPlist                       Send request
     c                   eval      %subst(key20a:7:6) =
     c                             %char(%time(timjoi:*iso) +
     c                             %seconds(i):*iso0)
J4788  endfor;
     c                   else

J5660c                   If        %Parms >= PARMNUM_@ADTYP
     c
T2399c                   If        ( ( @ADTyp = ADTYP_IFSPDF ) and
/    c                               ( RQOp   = RQOP_IFS )           )
/    c                   Eval      RQOp = RQOP_IFSPDF
/    c                   EndIf
/    c
J5660c                   EndIf
     c
J2459c                   If        ( PriorDQMsg <> DQMsg )
7063 C                   CALL      'QSNDDTAQ'    sdqPlist                       Send request
J2459c                   EndIf
J2459c                   Eval      PriorDQMsg = DQMsg
/    c                   endif
/    C     sdqPlist      plist                                                   Que name
     C                   PARM      'MAG210'      QNAME            10             Que name
     C                   PARM      '*LIBL'       LIB              10             Que libr
     C                   PARM      256           QDTASZ            5 0           Data size
     C                   PARM                    DQMSG                           Data struct
     C                   PARM      20            QKEYSZ            3 0
     C                   PARM                    KEY20A           20            Job6|hhmmss
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSDQ         BEGSR
      *          Send a final msg to MAG2039 & start it up.

     C                   CLEAR                   DQACT
     C     USEDDQ        IFEQ      'Y'
     C                   MOVE      'N'           USEDDQ
     C                   MOVE      'Q'           RQOP                           (Q)uit
     C                   EXSR      SNDDQ
     C     OPCD          IFNE      'F'
     C     OPCD          ANDNE     'M'
     C     OPCD          ANDNE     'S'
     C                   CLEAR                   FAXNUM
     C                   ENDIF

     C                   Z-ADD     JOIPAG        FRMPAG
     C                   EXSR      MG2039
     C                   CLEAR                   FRMPAG
     C                   CLEAR                   JOIPAG
     C                   CLEAR                   @INTDQ
     C                   END

     C     OBJTY         IFNE      LSTTYP
     C                   CLEAR                   OUTFRM
     C                   CLEAR                   PRTTYP
     C                   CLEAR                   RPTNAM
     C                   CLEAR                   RPTUD
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RETRN         BEGSR
      * Restore LDA
     C                   MOVE      LDASAV        LDA
     C                   OUT       LDA
/2806C                   MOVE      'Y'           LOOPNG            1
/3523
/3523 * If the printer or printer file was overridden, then don't pass
/3523 * them back. Restore *ENTRY parm values.
/3523C     OVRPRT        IFEQ      'Y'
/3523C                   MOVE      SVPTR         @PTRID
/3523C                   MOVE      SVPF          @PRTF
/3523C                   MOVE      SVPFLB        @PRTLB
/3523C                   ENDIF
/3523
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
      *          Close the program

     C     CHKSRV        IFEQ      '1'
     C                   MOVEL     'CLOSEW'      OPCODE
     C                   CALL      'CHKSRV'      PLCHK                  50      Srvr active?
     C                   ENDIF

     C     USEDDQ        IFEQ      'Y'
     C     USEDPC        ANDNE     'Y'                                          No pc used
     C     PROMPT        ANDNE     'A'                                          No batch add
     C                   EXSR      CLSDQ
     C                   ENDIF

     C     NTCODE        IFNE      *BLANKS
     C                   MOVEL     'Y'           NOTLR
     C                   CALL      'SPYCSNOT'    CSNOT
     C                   END

     C                   MOVE      *BLANKS       RTNCDE
     C                   MOVE      *ON           *INLR
     C                   EXSR      RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF21         BEGSR
      *          F21=Cmd line
     C                   CALL      'QUSCMDLN'                           50
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKDB         BEGSR

     C                   CLEAR                   @ERCON
     C     OUTFIL        IFEQ      *BLANKS
     C                   MOVEL     'M203050'     @ERCON                         "out file nm
     C                   END

     C     OUTFLB        IFEQ      *BLANKS
     C                   MOVEL     'M203051'     @ERCON                         "Out libr
     C                   ELSE
     C     OUTFLB        IFNE      'QTEMP'
     C                   MOVEL(P)  OUTFLB        OBJNAM
     C                   MOVEL(P)  '*LIBL'       OBJLIB
     C                   MOVEL(P)  '*LIB'        OBJTYP
     C                   EXSR      CHKOBJ
     C     EXISTS        IFEQ      'N'
     C     CL(1)         CAT(P)    OUTFLB:0      CLSTMT
     C                   CAT       ')':0         CLSTMT                         CRTLIB Cmd
     C                   CALL      'MAG1030'
     C                   PARM      *BLANKS       RTN               1
     C                   PARM      'QSYS'        SYLIB            10
     C                   PARM                    OUTFLB
     C                   PARM      '*LIB'        OBJTYP
     C                   PARM                    CLSTMT          255
     C                   ENDIF
     C                   ELSE
     C     SBMJBQ        IFEQ      'Y'
     C                   MOVEL     'ERR1607'     @ERCON                         Qtemp for
     C                   ENDIF                                                  Batch
     C                   ENDIF
     C                   ENDIF

     C     @ERCON        IFNE      *BLANKS
     C     PROMPT        ANDNE     'Y'
     C                   MOVE      @ERCON        RTNCDE
     C                   EXSR      RETRN
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKFX1        BEGSR
      *          Check user data on fax screen 1

     C                   CLEAR                   @ERCON
/6924c                   movea     '00000'       *in(61)
      * FastFax
     C     FAXTYP        IFEQ      '4'                                          FastFax

      *    RpName is a Nickname set up in a FastFax Directory
     C     FAXNUM        IFEQ      *BLANKS
     C     FAXNUM        OREQ      RECIP                                         '*RECIPIENT

     C     RPNAME        IFEQ      *BLANKS                                      "Insufficnt
     C                   MOVE      'M203084'     @ERCON                          addressee
     C                   GOTO      ENDCK1                                        info"

     C                   ELSE
     C     FAXTO         IFNE      *BLANKS
     C     CPNAME        ORNE      *BLANKS                                      "Name inval
     C                   MOVE      'M203085'     @ERCON                          w/nickname"
     C                   GOTO      ENDCK1
     C                   END
     C                   END
     C                   END

     C     FAXNUM        IFNE      *BLANKS
     C     FAXNUM        ANDNE     RECIP                                         '*RECIPIENT

     C     FAXTO         IFEQ      *BLANKS                                      "Enter FaxTo
     C     CPNAME        ANDEQ     *BLANKS                                       or Company
     C                   MOVE      'M203097'     @ERCON                          name"
     C                   ELSE
     C     RPNAME        IFNE      *BLANKS
     C                   MOVE      'M203089'     @ERCON                         "Invalid
     C                   END                                                     Nickname"
     C                   END
     C                   END
      * O.K.
     C     @ERCON        IFEQ      *BLANKS
     C     FAXNUM        ANDEQ     *BLANKS
     C                   MOVEL     RECIP         FAXNUM
     C                   END
     C                   END
      * All
     C     FOUTQ         IFEQ      *BLANKS
     C     FOUTQL        ANDEQ     *BLANKS
     C                   MOVE      'M203054'     @ERCON                         "OutQ can't
     C                   ENDIF                                                   be blank"

     C     FOUTQ         IFNE      '*JOB'                                       Default to
     C     FOUTQ         ANDNE     '*USRPRF'                                    *libl
     C     FOUTQ         ANDNE     *BLANKS
     C     FOUTQL        ANDEQ     *BLANKS
     C                   MOVEL     '*LIBL'       FOUTQL
     C                   ENDIF

     C     FOUTQ         IFEQ      *BLANKS
     C     FOUTQL        ANDNE     *BLANKS
     C                   MOVE      'M203038'     @ERCON                         "OutQ
     C                   ENDIF                                                   invalid"

     C     FOUTQ         IFNE      *BLANKS
     C     FOUTQL        ANDEQ     *BLANKS
     C     FOUTQ         ANDNE     '*USRPRF'
     C     FOUTQ         ANDNE     '*JOB'
     C                   MOVE      'M203039'     @ERCON                         "OutQ libr
     C                   ENDIF                                                   invalid"

     C     FOUTQ         IFEQ      '*USRPRF'
     C     FOUTQ         OREQ      '*JOB'
     C     FOUTQL        IFNE      *BLANKS
     C                   MOVE      *BLANKS       OUTQL
     C                   MOVE      'M203040'     @ERCON                         "OutQ libr
     C                   ENDIF                                                   m/b blank"
     C                   ENDIF

     C     FOUTQ         IFNE      '*USRPRF'
     C     FOUTQ         ANDNE     '*JOB'
     C                   MOVEL(P)  FOUTQ         OBJNAM
     C                   MOVEL(P)  FOUTQL        OBJLIB
     C                   MOVEL(P)  '*OUTQ'       OBJTYP
     C                   EXSR      CHKOBJ
     C     EXISTS        IFEQ      'N'
     C                   MOVE      'M203044'     @ERCON                         "OutQ error"
/6924c                   eval      *in65 = '1'
/    c                   goto      endck1
     C                   ENDIF
     C                   ENDIF

     C     PRTF          IFEQ      *BLANKS
     C     PRTLIB        ANDNE     *BLANKS
     C     PRTLIB        ANDNE     '*LIBL'
     C                   MOVE      'M203045'     @ERCON                         "Ptr file
     C                   ENDIF                                                   invalid"

     C     PRTF          IFNE      *BLANKS
     C     PRTLIB        ANDEQ     *BLANKS
     C     PRTLIB        ANDNE     '*LIBL'
     C                   MOVE      'M203046'     @ERCON                         "Ptr libr
     C                   ENDIF                                                   invalid"

     C     PRTF          IFNE      *BLANKS
     C                   MOVEL(P)  PRTF          OBJNAM
     C                   MOVEL(P)  PRTLIB        OBJLIB
     C                   MOVEL(P)  '*FILE'       OBJTYP
     C                   EXSR      CHKOBJ
     C     EXISTS        IFEQ      'N'
     C                   MOVE      'M203047'     @ERCON                         "Ptr file
     C                   ENDIF                                                   not found"
     C                   ENDIF

     C     NOTPRT        IFNE      'Y'
     C     NOTPRT        ANDNE     'N'
     C                   MOVE      'N'           NOTPRT
     C                   MOVE      'M203049'     @ERCON                         "Print notes
     C                   ENDIF                                                   m/b Y/N"

     C     FAXSAV        IFNE      #FAXSV
     C     *LOCK         IN        SYSDFT
     C                   MOVE      FAXSAV        #FAXSV
     C                   OUT       SYSDFT
     C                   END

     C     SPTRTY        IFEQ      *BLANKS
     C                   MOVE      '*PCL'        SPTRTY
     C                   END

     C     SYSNOD        IFEQ      '*NONE'
     C                   MOVE      *BLANKS       SYSNOD
     C                   END

     C     FAXNUM        IFEQ      *BLANKS
     C                   MOVE      'M203052'     @ERCON                         "Fax number
/6924c                   eval      *in62 = '1'
/    c                   goto      endck1
     C                   ENDIF                                                   invalid"
      * Rydex
     C     FAXTYP        IFEQ      '3'                                          Rydex
     C     FAXCTY        ANDNE     'L'
     C     FAXCTY        ANDNE     'D'
     C     FAXCTY        ANDNE     'O'
     C                   MOVE      'L'           FAXCTY
     C                   MOVE      'M203074'     @ERCON                         "Call type
     C                   ENDIF                                                   m/b L/D/O"
      * TelexFax
     C     FAXTYP        IFEQ      '7'                                          TelexFax
     C     FX2RE         ANDEQ     *BLANKS
     C                   MOVE      'M203096'     @ERCON                         Desc is
     C                   ENDIF                                                  blank.

      * FaxCom
/6924c                   if        faxtyp = 'B'
/    c                   select
/    c                   when      fc_From = ' '
/    c                   eval      *in61 = '1'
/    c                   eval      @ercon = 'P004002'
/    c                   when      fc_ToCmpny = ' ' and fc_ToCntct = ' '
/    c                   eval      @ercon = 'M203097'
/    c                   eval      *in63 = '1'
/    c                   when      faxtx1 = ' '
/    c                   eval      *in64 = '1'
/    c                   eval      @ercon = 'P004002'
/    c                   endsl
/    c                   endif

     C     ENDCK1        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKFX2        BEGSR
      *          Check user data on fax screen 2

     C                   CLEAR                   @ERCON

     C                   MOVEA     FAXVC         TMP
     C     FAXVC         IFNE      *BLANKS
     C     TMP(1)        ANDEQ     *BLANKS
     C     FAXTYP        ANDNE     '4'
     C     FAXTYP        ANDNE     '5'
     C                   MOVEL     'M203079'     @ERCON                         "Can't start
     C                   ENDIF                                                   w/ blank"

     C     FAXVC         IFNE      '*LIN'
     C     FAXVC         ANDNE     '6'
     C     FAXVC         ANDNE     '8'
     C     FAXTYP        ANDNE     '4'
     C     FAXTYP        ANDNE     '5'
     C                   MOVE      '6   '        FAXVC
     C                   MOVE      'M203075'     @ERCON                         "Vert cmpres
     C                   ENDIF

     C     FAXTYP        IFEQ      '3'
     C     FAXTYP        OREQ      '4'
     C     FAXLPA        IFEQ      *BLANKS
     C     FAXLPP        ORNE      0
     C     FAXLPP        ANDLT     20
     C     FAXLPP        ORGT      99
     C                   Z-ADD     0             FAXLPP
     C                   MOVE      'M203076'     @ERCON                         "llp m/b
     C                   END                                                     20-99"
     C                   END                                                     20-99"

     C                   MOVEA     FAXHC         TMP
     C     FAXHC         IFNE      *BLANKS
     C     TMP(1)        ANDEQ     *BLANKS
     C                   MOVE      'M203079'     @ERCON                         "Cant start
     C                   ENDIF                                                   w/blank"

     C     FAXTYP        IFNE      '4'                                          Not FastFax
     C     FAXTYP        ANDNE     '5'                                          Not FaxSys
     C     FAXHC         IFNE      '*LIN'
     C     FAXHC         ANDNE     'W'
     C     FAXHC         ANDNE     'S'
     C     FAXHC         ANDNE     'R'
     C     FAXHC         ANDNE     'C'
     C                   MOVE      'R   '        FAXHC                          Force defalt
     C                   MOVE      'M203077'     @ERCON                         "Horz comp
     C                   ENDIF                                                   M/b w/s..."

     C     1             SUBST     FAXSTY        START1            1
     C     FAXSTY        IFNE      *BLANKS
     C     START1        ANDEQ     *BLANK
     C                   MOVE      'M203079'     @ERCON                         "Can't start
     C                   END                                                     w/ blank"

     C     FAXSTY        IFNE      '*LIN'
     C     FAXSTY        ANDNE     'P'
     C     FAXSTY        ANDNE     'L'
     C     FAXSTY        ANDNE     'G'
     C     FAXSTY        ANDNE     'A'
     C                   MOVE      'L   '        FAXSTY
     C                   MOVE      'M203075'     @ERCON                         "Vert comp
     C                   END                                                     M/b 6/8/*l"
     C                   END

     C     FAXSAV        IFNE      'Y'
     C     FAXSAV        ANDNE     'N'
     C                   MOVE      #FAXSV        FAXSAV
     C                   MOVE      'M203053'     @ERCON                         "Save status
     C                   ENDIF                                                   m/b Y/N"
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKNOT        BEGSR
      *          Set SDTNOT to 0,1,2,3 (NoNotes,Text,Annot,Text+Ann)

      * IMAGE/REPORT PARAMETERS
     C     SDTTYP        IFEQ      '1'                                          Image
     C                   MOVEL     IDBNUM        SPYNBR
     C                   ELSE                                                   Spoolfile
     C                   MOVEL     REPIND        SPYNBR
     C                   END
/813 C     SDTRO#        IFNE      *BLANKS                                      CONVERTED RPT
/    C                   MOVE      SDTRO#        NPAGE#                         RRN
/    C                   ELSE
/    C                   MOVE      SDTSPG        NPAGE#                         PAGE#
/    C                   END
     C                   MOVE      SDTSPG        NPAG#S                         STARTING RRN
     C                   MOVE      SDTEPG        NPAG#E                         ENDING RRN#

      * CHECK FOR NOTES
     C                   MOVEL     'CHKNT'       NTCODE                         CHECK FOR NO
     C                   MOVE      *OFF          SDTNOT                         NOTES FLAG
     C                   CALL      'SPYCSNOT'    CSNOT
     C     CSNOT         PLIST
     C                   PARM                    SPYNBR           10            Spy000*
     C                   PARM                    SEGMNT           10            Dst pgtbl nm
     C                   PARM                    NHNDL            10            Window Handl
     C                   PARM                    DTALIB                         Spy00 Libr
     C                   PARM                    NTCODE            5            Opcode
/813 C                   PARM                    NPAGE#            9 0          Page # / RRN
     C                   PARM                    NOTE#             9 0          Note #
/813 C                   PARM                    NPAG#S            9 0          TIFF/Actual Page#
     C                   PARM                    NSDT                           Return data
     C                   PARM                    NOTREC            9 0          Rtn # of rec
     C                   PARM                    NRTN              2            Return code
     C                   PARM                    NOTLR             1            Shutdown
     C                   PARM                    NEWNOT            1            NEW NOTE
     C                   PARM                    NPAG#E            9 0          END PAGE RAN
     C                   PARM                    SDTNOT            1            NOTES FLAG

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETDSP        BEGSR
      *          Get the current dspsiz  80/132

     C     JOBTYP        IFEQ      '1'                                          Interactive
     C     PROMPT        ANDEQ     'Y'
     C                   CALL      'DSPSIZ'
     C                   PARM                    DSPSIZ            3 0
     C                   PARM                    CSRLIN            3 0
     C                   PARM                    CSRPOS            3 0
     C     DSPSIZ        COMP      132                                    26     Eq
     C     DQACT         IFEQ      ' '                                          but not join
     C     LSTSIZ        ANDNE     DSPSIZ
     C     LSTSIZ        IFNE      0
     C                   CLOSE     MAG210FM
     C                   ENDIF
     C                   OPEN      MAG210FM                                     Open dspfile
     C                   Z-ADD     DSPSIZ        LSTSIZ            3 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETPTR        BEGSR
      *          Get SpyPrinter values from RPTABLE file

/3523C                   MOVE      '0'           *IN42
/2806C     *LIKE         DEFINE    PRINTR        PRTRSV
/2806C     PRINTR        IFNE      PRTRSV

     C     PRINTR        CHAIN     PTABRC                             42
/2806C     *IN42         IFEQ      *ON
/2806C                   CLEAR                   POUTQ                          Update OutQ
/2806C                   CLEAR                   PLIBR                          OUTQL  and r
/2806C                   CLEAR                   PFILT                          Formtype
/2806C                   CLEAR                   PPRTFL                         Print File
/2806C                   CLEAR                   PPRTLB                         Print Fil Lb
/2806C                   CLEAR                   PRTDV                          Writer
/2806C                   CLEAR                   PDJEB                          DJE Before
/2806C                   CLEAR                   PDJEA                          DJE After
/2806C                   CLEAR                   PBANID                         Banner Id
/2806C                   CLEAR                   PINSTR                         Instr Id
/2806C                   CLEAR                   PPRTYP                         Printer Typ
/2806C                   CLEAR                   PNODID                         Node ID
/2806C                   ELSE

     C     POUTQ         IFNE      *BLANKS
     C                   MOVE      POUTQ         OUTQ                           Update OutQ
     C                   ENDIF
     C     PLIBR         IFNE      *BLANKS
     C                   MOVE      PLIBR         OUTQL                          OUTQL  and r
     C                   ENDIF
     C     PFILT         IFNE      *BLANKS
     C                   MOVE      PFILT         OUTFRM                         Formtype
     C                   ENDIF
     C     PPRTFL        IFNE      *BLANKS
     C                   MOVE      PPRTFL        PRTF                           Print File
     C                   ENDIF
     C     PPRTLB        IFNE      *BLANKS
     C                   MOVE      PPRTLB        PRTLIB                         Print Fil Lb
     C                   ENDIF
     C     PRTDV         IFNE      *BLANKS
     C                   MOVE      PRTDV         WRITER                         Writer
     C                   ENDIF
     C     PDJEB         IFNE      *BLANKS
     C                   MOVE      PDJEB         DJEBEF                         DJE Before
     C                   ENDIF
     C     PDJEA         IFNE      *BLANKS
     C                   MOVE      PDJEA         DJEAFT                         DJE After
     C                   ENDIF
     C     PBANID        IFNE      *BLANKS
     C                   MOVE      PBANID        BANNID                         Banner Id
     C                   ENDIF
     C     PINSTR        IFNE      *BLANKS
     C                   MOVE      PINSTR        INSTRU                         Instr Id
     C                   ENDIF
     C     PPRTYP        IFNE      *BLANKS
     C                   MOVE      PPRTYP        PRTTYP                         Printer Typ
     C                   ENDIF
     C     PNODID        IFNE      *BLANKS
     C                   MOVE      PNODID        PRTNOD                         Node ID
     C                   ENDIF
/2806C                   MOVE      PRINTR        PRTRSV
     C                   ENDIF
/2806C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTNPM1        BEGSR
      *          Set return Parms from the PRTWDW screen.

     C                   Z-ADD     FRMPAG        @FRMPG
     C                   Z-ADD     TOPAGE        @TOPG
     C                   Z-ADD     FRMCOL        @FRMCO
     C                   Z-ADD     TOCOL         @TOCOL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTNPM2        BEGSR
      *          Set return Parms from the ADPARM screen.

     C                   MOVE      RPTNAM        @RPTNA
     C                   MOVE      OUTFRM        @OUTFR
     C                   MOVE      RPTUD         @RPTUD
     C                   MOVE      PRINTR        @PTRID
     C                   MOVE      OUTQ          @OUTQ
     C                   MOVE      OUTQL         @OUTQL
     C                   MOVE      WRITER        @WTR
     C                   Z-ADD     COPIES        @COPIE
     C                   MOVE      PRTF          @PRTF
     C                   MOVE      PRTLIB        @PRTLB
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     VLDFAX        BEGSR
      *          Check if fax is image enabled (return ALWIMG Y/N)
     C                   MOVE      'N'           ALWIMG
     C                   MOVEL(P)  'FAXTYPE'     CNAME
     C                   MOVEL     'RC'          CTYPE
     C     FAXTYP        IFGE      'A'
     C     FAXTYP        ANDLE     'Z'
     C                   MOVE      *BLANKS       CKEY
     C                   CAT       FAXTYP:5      CKEY
     C                   ELSE
     C                   MOVE      *ZEROS        CKEY
     C                   MOVE      FAXTYP        CKEY
     C                   ENDIF
     C     KEYCTL        CHAIN     SPYCTLF                            50
     C     *IN50         IFEQ      '0'
     C     1             SUBST     CTEXT:51      ALWIMG            1
     C                   ENDIF
     C                   ENDSR
      *================================================================

     C     KLBIG5        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA

J5953p IsSplMail       b
J5953d IsSplMail       pi              n
J5953d NOT_SPLMAIL     c                   '0'
J5953d IS_SPLMAIL      c                   '1'
J5953d rtnSplMail      s              1a
J5953d rc              s             10i 0
J5953 /free
J5953   If ( quspdt00 = *blanks );
J5953     rc=getArcAtr( REPIDX  : %addr(Qusa0200) : %size(Qusa0200) : 3);
J5953   EndIf;
J5953
J5953   If ( UseSpm <> YES );
J5953     rtnSplMail = NOT_SPLMAIL;
J5953   Else;
J5953     If (   quspdt00 = PRTTY_AFPDS     )  or
J5953        (   quspdt00 = PRTTY_AFPDSLINE )  or
J5953        (   quspdt00 = PRTTY_IPDS      );
J5953       rtnSplMail = IS_SPLMAIL;
J5953     Else;
J5953       rtnSplMail = NOT_SPLMAIL;
J5953     EndIf;
J5953
J5953   EndIf;
J5953
J5953   return rtnSplMail;
J5953 /end-free
J5953p IsSplMail       e
J5953p IsFormatError   b
J5953d IsFormatError   pi              n
J5953d blnIsFormatError...
J5953d                 s               n   inz(FALSE)
J5953 /free
J5953   reset blnIsFormatError;
J5953
J5953   Select;
J5953     When ( MlFmt <> MLFMT_TXT )  and
J5953          ( MlFmt <> MLFMT_PDF );
J5953       @ErCon = 'ERR157B';
J5953       blnIsFormatError = TRUE;
J5953
J5953     When ( blnTextOnly = TRUE      ) and
J5953          ( mlfmt      <> MLFMT_TXT );
J5953       @ErCon = 'ERR1968';
J5953       blnIsFormatError = TRUE;
J5953
J5953     When ( blnNativePDF = TRUE      ) and
J5953          ( mlfmt       <> MLFMT_PDF );
J5953       @ErCon = 'ERR1969';
J5953       blnIsFormatError = TRUE;
J5953   EndSl;
J5953
J5953   Return blnIsFormatError;
J5953 /end-free
J5953pIsFormatError    e
** ERR   Error Messages
ERR1618 Fax and mail have not been configured          01
ERR1192  (NOT USED)                                    02
ERR1167  (NOT USED)                                    03
ERR1247 Report is off-line; restore to view.           04
ERR1248  (NOT USED)                                    05
ERR1249  (NOT USED)                                    06
ERR1250  (NOT USED)                                    07
ERR1251  (NOT USED)                                    08
ERR1252  (NOT USED)                                    09
ERR1253 Folder is missing.                             10
ERR1243  (NOT USED)                                    11
ERR1254  (NOT USED)                                    12
ERR1255  (NOT USED)                                    13
ERR1256  (NOT USED)                                    14
ERR1257  (NOT USED)                                    15
ERR1258  (NOT USED)                                    16
ERR1171 Folder has been removed.                       17
ERR1380  (NOT USED)                                    18
DSP1141  (NOT USED)                                    19
ERR1536 Invalid Job Description name                   20
ERR1537 Invalid JobD library name                      21
ERR1538 Enter JobD/library not found                   22
ERR1601  (NOT USED)                                    23
ERR1602  (NOT USED)                                    24
ERR1604 No Fax Configured                              25
ERR1617  (NOT USED)                                    26
ERR1815 Page range is invalid.                         27
ERR1821 Error - Fax command failed                     28
ERR1535 Submit job must Y or N                         29
** CL
CRTLIB TYPE(*PROD) TEXT('Report Output File Library') LIB(
DSPFD FILE(
) TYPE(*SPOOL) OUTPUT(*OUTFILE) OUTFILE(QTEMP/@@@@@@@PFA)
OVRDBF FILE(@PFA) TOFILE(QTEMP/@@@@@@@PFA)
DLTOVR FILE(@PFA)
DLTF FILE(QTEMP/@@@@@@@PFA)
** FS FIELD SCRENN    FP FIELD PARM
1FAXFRM    FAXFRM1
1FAXTO     FAXTO1
1FAXRE     FAXREF
1FAXTX1    FAXTXT1
1FAXTX2    FAXTXT2
1FAXTX3    FAXTXT3
1FAXTX4    FAXTXT4
1FAXTX5    FAXTXT5
2FX2NUM    FAXNUM
2FX2TO     FAXTO1
2FX2TX1    FAXTO2
2FX2TX2    FAXTO3
2FX2FRM    FAXFRM1
2FX2TX3    FAXFRM2
2FX2TX4    FAXFRM3
2FX2RE     FAXREF
2FX2TX5    FAXTXT1
3FAXTX1    FAXREF
3FAXTO     FAXTO1
3FAXRE     FAXAT
3FAXFRM    FAXFRM1
4FAXFRM    FAXFRM1
4FAXTO     FAXTO1
4FAXTX1    FAXREF
4FAXTX2    FAXTXT1
4FAXTX3    FAXTXT2
5FAXFRM    FAXFRM1
5FAXTO     FAXTO1
5FAXTX1    FAXTXT1
5FAXTX2    FAXTXT2
5FAXTX3    FAXTXT3
6FX2NUM    FAXNUM
6FX2TO     FAXTO1
6FX2FRM    FAXFRM1
6FX2RE     FAXREF
6FX2TX1    FAXTXT1
6FX2TX2    FAXTXT2
6FX2TX3    FAXTXT3
6FX2TX4    FAXTXT4
6FX2TX5    FAXTXT5

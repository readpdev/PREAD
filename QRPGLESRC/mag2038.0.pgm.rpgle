J3613h copyright('Open Text Corporation') option(*noshowcpy:*nodebugio)

      **********--------------------------
      * MAG2038  Print/Fax/Send Background
      **********--------------------------
     FMSPLDAT   IF   F  256        DISK    USROPN
     FRWINDOW   IF   E           K DISK    USROPN
     FRFORMS    IF   E           K DISK
     FRPRTDJE   IF   E           K DISK
     FMRPTDIR7  IF   E           K DISK    USROPN
     FMIMGDIR   IF   E           K DISK    USROPN
     FRSEGMNT   IF   E           K DISK    USROPN
     FRSEGHDR2  IF   E           K DISK    USROPN
     FRDSTHST   UF   E           K DISK    USROPN
/6865FRDSTDEF   IF   E           K DISK    UsrOpn
     FRMAINT    IF   E           K DISK    USROPN
J1892FRMAINT4   IF   E           K DISK    USROPN
/    f                                     rename(rmntrc:rmntrc4)
     FMAG2038   IF   E           K DISK    USROPN extdesc('QAFDPRT')
     FDISP      IF   F  256        DISK    USROPN
J2813fRAPFDbf   if   e           k disk    usropn
/    fMfldDir   if   e           k disk    usropn
     F#REPORT#  O    F  248        PRINTER OFLIND(*INOF)
J6058F                                     USROPN


J6644 * 03-04-16 PLR Correct duplicate printing of document when AFP and
      *              using FastFax.
J6642 * 03-28-16 PLR Failure to send AFP via SpoolMail when submitted to batch.
J6561 * 02-18-16 PLR When emailing AFP document using SpoolMail and specifying a
      *              page range, the entire report would be delivered and not
      *              for the pages specified. Code was written to support
      *              RD but not for individual selection. See T2649J.
J6449 * 10-05-15 PLR While testing original reported issue, it was noticed that
      *              when attempting to print AFPDS documents interactively while
      *              using SPYAPICMD, an error would pop up indicating an email
      *              recipient name was not correctly formatted. This should not
      *              have been occurring when just printing. Located code that
      *              should have been further qualified in a select statement.
      *              The error was not visible when submitted and did not prevent
      *              printing. See VIP-4819.

J6348 * 07-14-15 PLR Emplementation of email logging was not done correctly under T5635
      *              (pre-Jira). Log header information was not set at the correct point.
J6346 * 07-02-15 PLR Crash occurs on attempt to chain to closed RSEGMNT file when processing
      *              an AFP document. Not data related. Added a bit of a hack to
      *              the subroutine that attempts to load more page table records (LODPPT)
      *              where it tests whether or not RSEGMNT is still open. Works because logic
      *              elsewhere in this program handles the page table records. Issue only
      *              occurs when there are exactly 63 distribution pages that fill the PPT
      *              array. Section of code calling into LODPPT doesn't know that the all
      *              of the distribution pages have been processed.
J6058 * 10-23-14 PLR USROPN option missing from #REPORT#. Got shifted...see it
      *              on the comment below? Ahhh! Got stepped on while applying
      *              VIP-5920 somehow.
J5921 * 09-22-14 PLR Mispelling of *USERASCII (*USRASCII) for FastFax processing
      *              causing fax failure. 2399?                                     USROPN
J5953 * 03-13-15 EPG Short circuit the assessment for the usage of SpoolMail
J5953 *              based solely on the report type being either *AFPFS,
J5953 *              *IPDS or ( *SCS and afptyp being 4 ) and SpoolMail being
J5953 *              enabled. In this way, DocManager enabled mail will be used
J5953 *              instead of SpoolMail.
J5953 *
J5953 *              Additionally, fix a potential infinite loop in the subroutine
J5953 *              CLRDQ should the API call return an error.
J5856 * 07-22-14 EPG Distribution Attachment name is not the name of the
J5856 *              report type.
J5758 * 06-17-14 EPG Revert the behavior of the naming convention for
J5758 *              exported file names back to the original behavior.
J5464 * 04-25-14 EPG Render PCL to PDF for a specific page range.
J5467 * 11-21-13 EPG Remove the redirection with the call to PCL to PDF and
J5467 *              and use the operation extender when calling the procedure
J5467 *              to unlink the ifs file.
J5438 * 11-18-13 EPG Truncation issue when exporting a PCL spooled file to text
J5438 *              using EXPOBJSPY targeting the IFS.
J5331 * 11-18-13 EPG Issue with TIFF to PDF. Change the technique that is used
J5331 *              to convert TIFF to PDF. Instead of leveraging the original
J5331 *              PDFLib and the calls to its service program to import the
J5331 *              TIFF images extended another approach that originally was
J5331 *              intended for exceptions to instead drive all of the TIFF
J5331 *              to PDF conversions. Removed implementation of J5109.
J5343 * 11-13-13 EPG Update the way that the PCL6 command is called so that
J5343 *              option -dNOPAUSE is before -sOutPutFile
J5109 * 08-08-13 PLR Include logic to control the size of PDF documents that
      *              are converted from TIFF by using a percentage threshold
      *              value set in the SYSDFT data area. If the resulting PDF
      *              exceeds the TIFF original size + X% then a secondary
      *              utility (tiffrgb2g4) is called in the IFS to convert the
      *              large tiff to a single strip g4 tiff and then converted
      *              to PDF. Side effects are a reduction or loss of color
      *              should the original have any. Size is significanly
      *              reduced for most TIFFs. Issue was originally caused by
      *              oddly formed TIFFs and caused decompression when wrapped
      *              in PDF resulting in files much larger than the original.
J4819 * 08-07-13 EPG Correct an issue when integrated with SpoolMail
J4902 * 04-26-13 EPG Make the necessary chanages to the procedures to
/     *              return the filename and return the path.
J3951 * 01-13-12 EPG Fix an issue that was introduced with the code for J2473
/     *              that foiled conversion of SCS spooled files to PDF.
J3533 * 01-05-12 EPG According to IBM, IPDS spooled files may be created as AFPDS
/     *              in order to leverage CPYSPLF to convert these files to PDF.
/     *              Patch the code that generates the intermediate spooled file
/     *              so the printer device type is *AFPDS.
J2813 * 01-04-12 EPG Massage first buffer of data going to the IFS if the length
      *              of this data is equal
J3356 * 12-19-11 EPG Change the call to MGAFPTOPDF to use the spynumber
/     *              and not the file name as the base.
J3533 * 09-27-11 EPG Enable IPDS to PDF.
J2620 * 09-06-11 EPG Implement BMP to PDF for EXPOBJSPY.
J2554 * 10-16-12 EPG Originally implemented IPDS to PDF, but then retained the
J2554 *              error trapping and recovery to deal with it.
J2469 * 08-25-11 EPG Implement distribution of AFP to PDF for email.
J3613 * 06-02-11 EPG Implement exporting original PDF to PDF. Also, extend
      *              this to include the export of the files, and indices.
J3218 * 05-20-11 PLR Allow FastFax to write to the IFS root instead of QDLS.
J2621 * 05-19-11 EPG Convert JPG files to PDF.
J2619 * 05-17-11 EPG Convert GIF files to PDF.
J2470 * 05-02-11 EPG Convert text files to PDF. Correct an override issue to
/     *              MSPLDAT.
J3358 * 04-27-11 EPG Qualify the conversion of spooled file to SCS
/     *              by first testing for the printer type.
J3470 * 04-05-11 EPG Expose Ghost PCL messages to the job log.
J3358 * 03-22-11 EPG Refactor the code to accomodate a call to MGAFP2PDF
/     *              to convert AFP to PDF. Fix the protoype to the external
      *              call to system to return a signed integer.
J2813 * 03-09-11 EPG Retrofit the code that calls BLDPCLPGS from SPYCS
/     *              to MAG2038. Fix an issue with the the path parameter
/     *              received from RenderIFSFile contains a trailing /*.
/     *              Both of these need to be removed.
/     *              Changed the compile defaults on the program to include
/     *              the binding directory QC2LE. Provide error trapping and
      *              reporting.
J2459 * 02-17-11 EPG Provide for logging for the data queue issue.
J3234 * 01-17-11 EPG Correct an issue with an error occuring due to
/     *              OPNFLD being called more then once.
J2814 * 09-21-10 EPG Convert IFS PCL file to PDF.
J2813 * 09-16-10 EPG Render a PCL file to the IFS when the @dest type
      *              retrieved from the data queue yeilds an A.
J2576 * 05-05-10 EPG Append a missing return code to the call SBMSPLFAXB.
/     *              Control FAX  error reporting via blnSplFAXB.
J2553 * 04-27-10 EPG Extend EXPOBJSPY to enable SCS spooled files to be converted
/     *              to PDF.
J2473 * 04-07-10 PLR Export TIF as PDF.
J2399 * 03-10-10 EPG Extend EXPOBJSPY to enable AFP spooled files to be converted
/     *              to PDF.
J2363 * 03-05-10 EPG Prevent EXPOBJSPY from placing a type of PDF on a report
/     *              converted to the IFS even though the text extension reads
/     *              PDF from the system environment variable TXTEXT.
J2144 * 10-21-09 PLR Add ability to delete faxstar attachments by referencing
      *              value in data area qtemp/dltfaxatt. Only available when
      *              run through DOC/SPYAPICMD.
J2037 * 09-22-09 EPG Remedy an issue with printing multiple DocLink Values
/     *              with those pages are not combined.
J1481 * 08-13-09 PLR Combine tiff pages when emailing. Using code created by
      *              Wayne.
J1892 * 06-25-09 EPG Remedy the issue surfaced when attempting to
/     *              retrieve a Report Type using only the first
/     *              field of the big five key. Should this technique
/     *              not work, the open the RMAINT4 file and do a
/     *              lookup against the report type.
J1872 * 06-16-09 PLR Modify a large portion of the 6202 patch. Instead of
      *              walking the FastFax outq (FFXOTQAPI) and the FastFax
      *              api feeder file (FFXAPI) just retrieve the last spool
      *              file for the job and then call the api. Customer was
      *              experiencing duplicates of their fax jobs because of
      *              the previous looping mechanism.
T1770 * 04-29-09 EPG User defined print file and library lost when
      *              retrieving getArcAtr prior to being passed.
      *              Also, the library name of the print file is not
      *              specified within the RcvVar data structure.
t7485 * 03-02-08 PLR Image link error displayed when EXPOBJSPY used. Was
      *              occurring when the requested size and the file size
      *              matched. Changed the iterative operation from doult to
      *              doule.
T7480 * 02-13-09 PLR Array index out of range error occurring when emailing
      *              native PDF distributions containing more than 63 pages...
      *              the array limit of the page table array PPT. Fixed by
      *              reloading the page table array as necessary.
T7488 * 02-12-09 PLR Allow the sending of mixed content (reports & images) at
      *              the same time via email. Was getting mail api error in
      *              SPYMAIL pgm.
/6865 * 05-22-08 EPG Correct the prototype to SpyMail as both the Receiver
/     *              and Sender were incorrectly typed with a length of
/     *              120 instead of 256. Corrected the prototype.
/     *              Additionally, changed the subject prototype length
/     *              from 60 to 65, and change the parameter for message
/     *              array to be passed by value. Replaced the subroutine
      *              SpoolMail with the new subroutine SndSplMail.
/6865 * 05-13-08 EPG Accommodate distribution with SpoolMail by adhering to the
/     *              baseline DocManager implementation allowing for multiple
/     *              attachments. Only allow Spool Mail to be used if
/     *              the printer file type is *IPDS, and *AFPDS and the
/     *              conversion format requested is *PDF. Additionally,
/     *              if Spooled Mail needs to be leverage to distribute
/     *              multiple *IPDS or *AFPDS spooled files as *PDF attachments,
/     *              then those receipients will receive multiple emails with
/     *              a single *PDF attachment.
T6637 * 03-11-08 PLR Set specified outq when printing mixed report types and
      *              using the join option.
T6764 * 01-08-08 PLR TIF to PDF email clipping top of image. Was calculating the
      *              page height using the width resolution.
T6686 * 11-20-07 PLR Error on chgsplfa. *DTAQ is file name. Added code
      *              to use correct spool file name.
T6375 * 06-11-07 PLR Prevent SpoolMail from attempting to process natively
/     *              archived PDFs.
/6202 * 05-09-07 EPG Previously, when Quadrant's FastFAX modifier *AP
/     *              was used to refer to an image, the path /QDLS was
/     *              implied. Now since Quadrant includes support for
/     *              the IFS the path name needs to be explicity defined.
/     *              Extend the interface to Quadrant's FastFAX  by using
      *              their API to send the PCL FAX document.
T6202 * 04-06-07 EPG Enable an APF (Advance printer file - *USERASCII NOT
      *              AFP Advanced Function Print) to be defined with a job
      *              override as before, but with a printer device type of
      *              *USERASCII and not *SCS in the event that the file
      *              is 1) being FAXed 2) Defined as FastFAX 3) The source
      *              spooled file archived is oringally *USERASCII.
      *              Prevent the SCS FAX attributes from being used when
      *              the above conditions are met.
T6276 * 05-01-07 PLR Force retrieve of archive attributes for AFP reports
      *              that have variable CPI.
T6195 * 04-07-07 PLR Hard error when attempting to print text version
      *              of native PDF report.
T5459 * 01-31-07 EPG Prevent an errouneous write to the MIME file.
T5657 * 11-09-06 PLR Remove dtaq entries from MAG210-DTAQ when retrieved.
      *              DTAQ was filling up and preventing print operations.
T4979 * 10-12-06 PLR Remove call to MAGGETPDF and replace with call to
/     *              distribution modules in PDFIO.
/5469 *  7-14-06 EPG Preserve all of the original processing of SCS
      *              to PDF by qualifying the PDF_FMT type.
/5469 *  7-13-06 EPG Enable the distribution of native PDF files that
      *              originally had been archived from the IFS.
/5225 *  3-28-06 EPG Enable an AFP spooled file to be retrived with original
      *              spooled file attributes, when faxing using the IBM     AX
      *              command.
/9816 *  4-06-05 JMO Fixed problems with special characters in the report name.
      *                The report name will now have invalid characters replaced
      *                with "_".
/9613 * 03-23-05 PLR SpoolMail logic causing email logging appear to be a
/     *              print operation.
/6921 *  3-10-05 JMO Changed logic so that file types that are not supported by
      *                SPOOLMAIL will be emailed using our own internal processes
      *                regardless of the SYSDFT setting for SPOOLMAIL Y/N.
/9518 *  3-09-05 JMO fixed problem with MSPLDAT file not being opened.  Indicator
      *                81 was being set by a previous operation and not reset
      *                before being used for a comparison.
/9134 *  7-07-04 JMO Added code to specify the MBR on OVRDBF commands for folders
      *              and Image files.
/7455 *  6-18-04 JMO Fixed problem with long IFS path names being truncated.
/8989 *  5-20-04 JMO Changed logic to use the total number of pages from the
      *                MRPTDIR file when resetting the ending page number.
      *                Previously the ending page number would be set to 1 any time
      *                the spooled file attributes had an estimated number of pages
      *                and the user entered an ending page greater than the total
      *                number of pages. This caused problems for the REPRINTRPT cmd.
/5635 *  2-23-04 JMO Added HIPAA logging for Print/Fax/Email
/8603 * 11-14-03 JMO Additional changes to better support various code pages
      *                and character sets.
/6708 * 10-09-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte binary.
/8603 * 10-07-03 GT  Change PDF code page to 1252 (was 819) to be compatible
      *              with PDF keyword "winansi".  Also use report code page
      *              as the from-code page if available.
      *              NOTE: This is not a complete fix, but will address the
      *                    customer's specific issue.
/8632 * 09-30-03 JMO Modified to handle single quote in Form type or User Data.
      *                This was causing the OVRPRTF to fail.
/8527 * 09-17-03 PLR Modified to handle printing multiple AFP reports when
      *              selected to fax via FaxCom.
/8528 *  8-21-03 JMO Added logic to use Ouq and Outq Lib from MRPTDIR when
      *               the user selects *RPTCFG as the outq,
/8388 *  6-10-03 JMO Changed spool file attributes structure from 3301 bytes
/8388 *               to 8192 bytes.
/7956 * 03-10-03 PLR While fixing for 7956 noticed that segments printed from
/     *              MAG2038APF where being placed on hold arbitrarily. Modified
/     *              fix for 6754 to check the hold flag more accurately.
/6754 * 01-09-03 PLR Spool file hold not being honored when requested to do so.
/6924 * 11-20-02 PLR Add support for FaxCom.
/6763 *  6-20-02 GT  Add ability to print text on scaled image
/6609 *  5-16-02 DLS Add INTERFACE for Gumbo SpoolMail support.
/6487 * 04-19-02 GT  Fix AFP splf not moving to correct outq
      *              MAG2038APF was not being closed before CHGSPLFA was run
/5778 * 11-16-01 KAC Add opcode (OPEN, WRITE, & CLOSE) to MAG2038APF
/5469 *  9-24-01 KAC Overstrike DJDE commands.
/5329 *  9-07-01 KAC Revise Notes print selection (seperate parm)
/4570 *  6-04-01 KAC Fix PDF & Email Overlay processing
/4492 * 05-08-01 PLR WHEN USING THE FASTFAX API, IMAGE FILES SENT VIA THE API
      *              (PREFIXED BY MODIFIER '*AP') MUST BE INCLUDED ON SAME
      *              PAGE OF SPOOL FILE.
/3765 * 02-28-01 DLS MODIFIED FOR NEW CHECK IN/OUT DATA BASE
/3393 *  2/12/01 DLS Add IgnBatch parameter
/3940 *  2-06-01 KAC Revise PDF page/font setup calculations
/3345 * 12-04-00 JAM Correct date format FAXACS. Removed *DT and *TM
/3345 *              keywords from FastFAX (scheduling info, not printed.)
/3345 *              Rydex cannot be added at this time because it cannot
/3345 *              be tested at MagHQ.
/3345 *              This required CVRPAGTX6 to be added for FAXACS.
/2497 * 12-01-00 KAC Check for blank or zero codepage parameter
/3307 * 11-27-00 RA  Change to Gauss Name
/3307 * 11-15-00 KAC Treat 'TIFF' the same as 'TIF'
/3166 * 10-27-00 DLS Additional error message to be send in esc mode if
/3166 *              from EXPOBJSPY. modify prior mods for 2423D by RONA
/3139 * 10-20-00 DLS if faxing TXT then RPT the RPT portion was not
      *              being sent.  This was due to the output file being
      *              opened multiple times.
/2119 * 10-18-00 DLS Add fax support for TXT documents(orig. RA 6/05/00)
/2732 * 10-02-00 JAM Correct date format.
/2855 *  7-05-00 DM  Change CPI value from 16.6 to 16.7
/2930 *  9-18-00 KAC Add CodePage parameter
/2904 *  8-02-00 GT  Fix call to MAG1090: Was not closing properly
      *              installed by DLS on 10/13/00 to sync up program
/2627 *  7-31-00 KAC Pass missing Drawer Selection parm to MAG920
/813  *  7-26-00 KAC Apply REVISED NOTES INTERFACE
/2497 *  7-13-00 KAC Revise PDF page width calculation
/CISC *  7-07-00 KAC Workaround for Floats.
/2272 *  6-15-00 KAC Bug printing/emailing using page table ranges.
/2308 *  5-26-00 DM  Save status not working in Rpt.dist bundles
/2272 *  5-25-00 DM  Choice between packed or binary pg/pk tables
/2497 *  5-23-00 KAC Add PDF library calls for email.
/2423 *  5-23-00 RA  Add capture and send message to EXPOBJSPY
/2423 *  5-02-00 GT  Fix parms passed to SPYERR (wrong fields used)
/2680 *  4-24-00 DM  IF RPTNAM HAS X'4A REPLACE THEM WITH "#"s
/2423 *  4-17-00 FID FIXED CODE FOR EXPOBJSPY
/2264 *  3-16-00 KAC REPEATING NEW PAGE CODES ("1") NOT WORKING
/2478 *  3-15-00 DLS correct QUIT routine for IBM Fax of Images
/2541 *  3-13-00 KAC REMOVE REVISED NOTES INTERFACE
/2423 *  2-23-00 JJF Don't call SPMAIL when FRMOVR=Y and dest is IFS
/2245 *  2-16-00 DLS Allow for HOLD & SAVE spoolfile on print  2245HQ
/2420 *  1-26-00 JJF Fix print overlay for joined SpyLinks
/2204 *  1-26-00 JJF Fix export to IFS for large imgs & multi-pg tiffs
/1887 *  1-17-00 GT  Fix missing email text for reports        1887HQ
/2330 * 12-15-99 GT  Clear DTASIZ parm to shut down MAG1090    2328HQ
/2330 * 12-15-99 DM  IF RPTNAM HAS "-"s REPLACE THEM WITH "#"s 2330HQ
/2322 * 12-14-99 KAC PASS DRAWER SELECTION TO IMAGE PRINT      2322HQ
      *  9-17-99 KAC CHANGE "IMG" EXTENSTION TO "TIF"          2118HQ
      *  9-16-99 JJF Allow output to IFS (MLIND=*IFS, path in fax text)
      *  9-15-99 KAC FIX SPYAPICMD BATCH FAXES
      *  8-02-99 FID FAX FORMS USING FAXSTAR
      *  7-30-99 KAC REVISE NOTES INTERFACE
      *  7-01-99 JJF Prevent dbl occur of SHARE(*YES) in OvrPrtf cmd
      *  5-24-99 JJF Fix increment of image retrieval offset FAXIMG
      *  5-24-99 JJF Put *SAVE parm in OvrPrtF (SR OPN#RP) only for FAX 1793HQ
      *  5-04-99 KAC Add AFP Printing FOR IMAGES
      *  3-30-99 JJF Chg #REPORT# to 248 recl for new page eject FCFC
      *  3-22-99 FID Fix Pagerange problem for ASCII/PCL files
      *  3-10-99 KAC REMOVE "TIFF PAGE MARKED FOR PRINT" NOTES LOGIC
      *  3-08-99 KAC MOVE NOTES CODE TO SPYCSNOT.
      *  3-02-99 FID ADD IMAGE FAX FOR SBMFAX/SNDFAX IBM
      *  2-08-99 DM  Add MAG0001 extended filnum
      * 12-22-98 KAC USE NEW NOTES FILES
      * 12-17-98 FID FIX DAVE'S HACK WITH FAXSTAR MESSAGE
      * 12-09-98 KAC CHANGE MAG1053 PARM LIST INCLUDE MSG ID & DATA
      * 12-07-98 DAV ADD 999 AND *ORIG FOR USRDTA AND COPIES
      * 12-07-98 FID Add AFP Printing FOR IMAGES
      * 11-30-98 FID Change parm list to spymail to use bigger text array
      * 11-25-98 FID Remove bogus read from pscon for atsign
      *  9-08-98 GT  Fix form overlay processing for email
      *  9-04-98 GT  Change LDA email structure to include MLIND value
      *  9-04-98 GK  Always delete FaxSvr401 Images after faxing
      *  8-17-98 GK  Faxes were not working with SpyApiCmd
      *  8-11-98 GK  Attach a document to a fax (FaxStar)
      *  8-05-98 GK  Fix #pgs on cover sheet on DirectFax
      *  8-04-98 GK  Fix SpyApiCmd print w/Windows bug
      *  6-19-98 GK  Fix FaxServer401 for Image faxing
      *  6-10-98 GT  Change fax image file name to use base 36 seq nbr
      *              Add SPYFAXSEQ data area to QTEMP to store last seq
      *  6-05-98 GK  Give Err msg if Fax command fails
      *  5-22-98 GK  Add IBM fax command - SbmFax
      *  5-21-98 GK  If Faxstar & landscape print cover pg as portrait
      *  5-20-98 JJF Fix chgsplfa cmd for duplex reports
      *  4-29-98 GT  Fix Quadrant FastFax - multiple command errors
      *  4-10-98 JJF Fix form overlay error. (Use ind 67, not 66)
      *  4-06-98 FID Use PsCon msg HEX0002 to define hex value for ^
      *  3-25-98 GK  Add the parm APPL to TelexFax.
      *  3-20-98 GK  Use the *MARKED in the RQIMPG fld to trigger a
      *              search for a Print annotation preset to print
      *              certain pages in a mult page Tiff.
      *  3-18-98 FID For some reports the MRPTDIR pages don't match the
      *              attribute pages
      *  3-02-98 GK  New Rmaint fld(RGRFVR)to get graphics from APfile.
      *  2-21-98 kac Add support for imageview type reports
      *  2-05-98 kac Add support for r/dars type reports
      *  1-30-98 GT  Change overstrike compares to use new API string
      * 12-15-97 GK  Add switch to prt 1 or multi cvr pgs per Img doc
      * 12-05-97 GK  Overlay records on Print to File.
      * 12-04-97 GK  Add Fax Image capability to FaxServer.
      * 10-24-97 GT  Correct outq/writer override logic.
      * 10-20-97 GK  Add *Fax/ACS logic.
      * 10-03-97 GK  Add FaxServer logic.
      *  9-24-97 GK  Add *TelexFax logic.
      *  9-30-97 JJF Use msg ERR0162 (not ERR0157) if prt file missing
      *  9-26-97 JJF Don't clear AFPFRM & AFPEND before Mag2038APF call
      *  9-25-97 GK  Add TelexFax logic.
      *  9-16-97 JJF Use PsCon msg HEX0001 to define hex value for \
      *  8-22-97 GT  Fix infinite loop when printing report with note
      *  7-28-97 GT  Add ENTCNT/ENTPRC fields to prevent duplex
      *              printing of joined images with cover text from
      *              resetting printer until the last image is processed.
      *  6-11-97 JJF Update date & time printed for segments (RDSTHST)
      *  5-13-97 GT  Add **REFX for FaxStar; Rearrange some LDA flds
      *  1-08-97 JJF Close #REPORT# in subr CLSFAX.
      * Earlier changes: See QrpgARC/Mag2038_C
      *
      *
      // Prototypes -----------------------------------------------------------------------

J6642d getJobTyp       pr                  extpgm('MAG1034')
J6642d  jobType                       1
J6642d jobType         s              1

J5953d IsSplMail       pr             1a
J5331d UniqueFileName  pr            10i 0
J5331d  p_UniqueFileName...
J5331d                                 *

J5331d GetUsrSpcSz     pr            10i 0
J5331d  pLib                         10a   const
J5331d  pUsrSpc                      10a   const

J2620 /include @memio

J2620d GetUsrSpace     PR                  ExtPgm('QUSPTRUS')
/    d  UserSpaceName                20A   Const
/    d  pSpacePtr                      *
/    d  ErrorCode                          Options(*NOPASS)
/    d                                     LikeDS(DSErrorCode)
/
J2620d MGBMPToTIF      pr            10i 0 extproc('mgbmptotif')
/    d  pOptions                       *   value options( *string : *trim )
/    d  pSrcPath                       *   value options( *string : *trim )
/    d  pTgtPath                       *   value options( *string : *trim )

J2469d IFSOpen         pr            10i 0 extproc('open')
/    d  pPath                          *   value options( *string : *trim )
/    d  poFlag                       10i 0 value
/    d  pMode                        10u 0 value options( *nopass )
/    d  pCodePage                    10u 0 value options( *nopass )

J5331d IFSWrite        pr            10i 0 extproc('write')
J5331d  fildes                       10i 0 value
J5331d  buf                            *   value
J5331d  nbyte                        10u 0 value

J2469d IFSClose        pr            10i 0 extproc('close')
/    d  pfildes                      10i 0 value

J2469d IFSRead         pr            10i 0 extproc('read')
/    d  pfd                          10i 0 value
/    d  pbuf                           *   value
/    d  pbyte                        10u 0 value

J2619d ConvImgPDF      pr            10i 0
/    d  pIFSPath                    256a
/    d  pImgType                      5a   const
/    d  pImgExt                       5a   const
/    d  pDeleteOrg                    1a   const

J2470 /include @mgstrio
/    d ConvTxtPDF      pr            10i 0
/    d  pIFSPath                    256a
/    d  pDeleteOrg                    1a   const
/    d  pLPI                         10i 0 const
/    d  pPageLength                  10i 0 const
/    d  pCPI                         10i 0 const
/    d  pPageWidth                   10i 0 const

J2470d SpyIFS          pr                  ExtPgm('SPYIFS')
/    d  pOpCode                      10a   const
/    d  pPath                       256a   const
/    d  pDta                               like(DTA)  const
/    d  pDtaLen                      10i 0 const
/    d  pFrmCCS                       5a   const
/    d  pToCCS                        5a   const
/    d  pMsgID                        7a

J2470d Translate       pr                  ExtPgm('QDCXLATE')
/    d  pLength                       5p 0 const
/    d  pData                     32766a   options(*varsize)
/    d  pTable                       10a   const

J3470 /include @msglog
/
/    D ReadLine        PR            10I 0
/    D pintFh                        10I 0 value
/    D pstrText                        *   value
/    D pMaxLen                       10I 0 value

J3358d MGAFP2PDF       pr                  ExtPgm('MGAFP2PDF')
/    d  pSpoolFile                   10a   const
/    d  pJobName                     10a   const
/    d  pUserName                    10a   const
/    d  pJobNbr                       6a   const
/    d  pSpoolNbr                    10i 0 const
/    d  pPath                       256a   const
/    d  pIFSFile                    256a   const
/    d  pCodePage                    10u 0 const
/    d  pMsgID                        7a
/    d  pMsgDta                     256a   options(*varsize)
/
/    d GetPathString   pr           256a
/    d  pPath                          *   value options(*string:*trim)

/    d GetFileName     pr           256a
/    d  pPath                          *   value options(*string:*trim)
/    d  pFileName                      *   value options(*string:*trim)
/    d  pExtension                    3a   const
/    d  pReplaceSeq                   1a   const
/    d  pSeqNbr                      10i 0 const options( *nopass )


J2813d OpenIFS         pr            10I 0 ExtProc('open')
/    d  pFileName                      *   value options(*string : *trim)
/    d  pOpenFlags                   10i 0 value
/    d  pMode                        10u 0 value options(*nopass)
/    d  pCodePage                    10u 0 value options(*nopass)
/    d WIFEXITED       pr            10I 0
/    d   pStatus                     10I 0 value
/    d WIFSIGNALED     pr            10I 0
/    d   pStatus                     10I 0 value
/    d WIFSTOPPED      pr            10I 0
/    d   pStatus                     10I 0 value
/    d WIFEXCEPTION    pr            10I 0
/    d   pStatus                     10I 0 value
/    d WEXITSTATUS     pr            10I 0
/    d   pStatus                     10I 0 value
/    d WSTOPSIG        pr            10I 0
/    d   pStatus                     10I 0 value
/    d WTERMSIG        pr            10I 0
/    d   pStatus                     10I 0 value
/    d WEXCEPTNUMBER   pr            10I 0
/    d   pStatus                     10I 0 value
/    d WEXCEPTMSGID    pr             7A
/    d   pStatus                     10I 0 value

J2459d DtaqMsgLog      pr
/    d  pblnLog                        n   const
/    d  pProgram                     10a   const
/    d  pAPI                         10a   const
/    d  pKey                         20a   const
/    d  pDQMsg                      256a   const

J2469d SubMsgLog       pr
/    d  pblnLog                        n   const
/    d  pSub                         30a   const
/    d  pblnEntering                   n   const

J2814d RtnStatus       pr
/    d RtnCode                        2    const
/    d Program                       10    const
/    d File                          10    const
/    d MsgID                          7    const options(*nopass)               Message ID
/    d MsgData                      100    const options(*nopass)


J2814d ALSendData      pr            10i 0
/    d  Buffer                         *   value
/    d  BufferLn                     10u 0 value
/    d  BufferFlag                   10i 0 value
/    d  ErrorID                       8    value
/    d  ErrorData                   101    value

J2814dSendData         pr            10i 0
/    d  Data                           *   value
/    d  DataLn                       10u 0 value
/    d  MaxBufrSiz                   10u 0 value
/    d  LastBufrFlag                 10i 0 value
/
/     /include @mmmsgio
J3358d run             pr            10i 0 extproc('system')
J5331d  cmd                            *   value options(*string : *trim )

J1481d rtvUsrSpcPtr    pr                  extpgm('QUSPTRUS')
     d  qualSpcName                  20    const
     d  rtnTiffSpcP                    *
     d  error                              likeds(qusec)

J1481d tiffUsrSpcP     s               *   dim(1000)

J1481d cmbTiffPgs      pr                  extproc('CombineTiffPages')
     d  tiffPgsArrayP                  *   value
     d  nbrOfPages                   10i 0 value
J5331d  cmbPgsPath                     *   value options(*string : *trim )

J1481d spyPath         pr                  extpgm('SPYPATH')
     d  pathID                       10    const
     d  returnPath                  256
     d tiffPath        s            256

J2469d fd              s             10i 0
J1481d fp              s               *

J2814dQzshCommand      pr            10i 0 ExtProc('QzshSystem')
/    d pCommand                        *   value options(*string:*trim)

J2813dAccessIFS        pr            10i 0 extproc('access')
/    d pPath                           *   value options( *string : *trim )
/    d pMode                         10i 0 value

J5464dstatIFS          pr            10i 0 extproc('stat')
J5464d pPath                           *   value options( *string : *trim )
J5464d pStat                           *   value

J3470d ReadIFS         pr            10i 0 extproc('read')
/    d  pFh                          10i 0 value
/    d  pBuffer                        *   value
/    d  pByptes                      10u 0 value

J2813dUnlinkIFS        pr            10i 0 extproc('unlink')
/    d pPath                           *   value options( *string : *trim )

J2813dRenderIFSFile    pr            10i 0
/    d pSpyNumber                    10a   const
/    d pFolderLib                    10a   const
/    d pFileName                     10a   const
/    d pExtention                     3a   const
/    d pPath                        128a   const options(*varsize)
/    d pCodePage                     10u 0 const
     d pReplaceSeq                    1a   const
     d pintBegin                     10u 0 const
     d pintEnd                       10u 0 const
     d pintTotal                     10u 0 const
/    d pstrIFSFile                  256a
/    d pSeqNumber                    10i 0 const options(*nopass)

/    dRenderPCLPDF     pr            10i 0
J5464d pstrIFSFile                  256a
J5464d pFrmPag                       10u 0 const options( *nopass )
J5464d pToPag                        10u 0 const options( *nopass )

     dObjExist         pr            10i 0
/    d pLibrary                      10a   const options(*varsize)
/    d pObject                       10a   const options(*varsize)
/    d pType                          7a   const options(*varsize)

J2813d
J2813dCmd              pr                  extproc('system')
/    d pCommand                        *   value
/    d                                     Options(*string)

/6865d PrtAPFSpool     pr                  ExtPgm('MAG2038APF')
/    d  pFolder                      10a
/    d  pFolderLib                   10a
/    d  pRptInd                      10a
/    d  pOfRNam                      10a
/    d  pRepLoc                       1a
/    d  pRcvVar                            Likeds(RcvVar)
/    d  pAFPFrm                       9p 0
/    d  pAFPEnd                       9p 0
/    d  pNoPag                        1
/    d  pRptNam                      10a
/    d  pDrawer                       4a
/    d  pOpCode                      10a   const
/
/5469 /copy @pdfbufhdl

      * Header file for Quadrant Fast FAX integration
T6302 /copy @ffxPCLFAX

/9816 * copy prototypes for Name Fix
/9816 /copy @mgosifc
T4979 /copy @pdfio

/5635
/5635 * copy prototypes for HIPAA audit logging
/5635 /copy @mlaudlog

/9134 * copy prototypes for OS APIs
/9134 /copy @OSAPI

J2473 * User space prototypes.
/     /copy @spyspcio

/5635
/5635 * HIPAA audit logging input structure
/5635d LogDS           ds                  inz
/5635 /copy @mlaudinp
/5635
/5635 * Build audit log entry
/5635d BldLogEnt       pr
/5635d DestId                         1a   const
/5635d SpyNbr                        10a
/5635d FrmPage                       10i 0 value
/5635d toPage                        10i 0 value

      * Native PDF I/O
5469 dSpyMail          pr                  extpgm('SPYMAIL')
5469 d pMlDta                              const likeds(MlDta)
5469 d pDtle                          5  0
5469 d pMlOpCd                       10a   const
6865 d pPRcvr                       256a   const options(*varsize)
5469 d pMpType                        1a
6865 d pMpSndr                      256a   const options(*varsize)
6865 d pMlSubj                       65a   const options(*varsize)
5469 d pMpt                          80a   dim(400) const
5469 d pMlRtn                         7a
J5856d pRTypID                       10a   const options( *nopass )
      * Quick reverse Scan function
J3613d RScan           pr            10u 0
/    d  pSearch                       1a   const
/    d  pString                     512a   const

J3613d UpdateDoc       pr                  ExtPgm('SPYEXPSPC')
/    d  pOpCode                      10a   const
/    d  pObject                      10a   const
/    d  pType                        10a   const
/    d  pSegment                     10a   const
/    d  pDTS                        100    dim(76)
/    d  pFrom                         8a   const
/    d  pTo                           8a   const
/    d  pFormat                      10a   const
/    d  pCodePage                          like(ToCdePag)
/    d  pJoin                         1a   const
/    d  pPath                       256a   const
/    d  pSpy                         10a   const
/    d  pSequence                     9  0 const
/    d  pReplace                      1    const
/    d  pMsg                          7
/    d  pDta                        256
/    d  pIgnBatch                     1    const
      * copy prototypes for MASPLIO functions
      /copy @masplio
      /copy qsysinc/qrpglesrc,qusrspla

      * Constants -------------------------------------------------
J4819d  YES            c                   'Y'
J4819d  DESTMAIL       c                   'M'
J4819d  FORMATPDF      c                   '*PDF'
J4819d FILENAME_ORIGINAL...
/    d                 c                   '*ORIG'
J4902d ASTERICK        c                   '*'
/    d SLASH           c                   '/'
/    d PERIOD          c                   '.'
J5331d QQ              c                   '"'
J2620d AS400_IO_USRSPC...
/    d                 c                   '2'
/    d MAXUSRSPC       c                   16776704
J2469d MLOPCD_OPEN     c                   'OPEN'
/    d MLOPCD_OPNATT   c                   'OPNATT'
/    d MLOPCD_WRTATT   c                   'WRTATT'
/    d MLOPCD_CLSATT   c                   'CLSATT'
/    d MLOPCD_CLOSE    c                   'CLOSE'
/    d MLCDPG_DOS      c                   '437'
/    d LF              c                   x'25'
J3613d SPCOPC_UPDDOC   c                   'UPDDOC'
J3613d REPLACE_YES     c                   'Y'
J3613d REPLACE_NO      c                   'N'
J3613d REPLACE_SEQ     c                   'S'
     d
J3386d RQOBTY_IMAGE    c                   'I'
J3386d RQOBTY_REPORT   c                   'R'
J2619d  EXT_GIF        c                   'GIF'
/    d  EXT_JPG        c                   'JPG'
/    d  EXT_BMP        c                   'BMP'
/    d  EXT_TIF        c                   'TIF'
/    d  EXT_TIFF       c                   'TIFF'
J4902d  EXT_PNG        c                   'PNG'
J2470d  DELETEORG_YES  c                   'Y'
/    d  DELETEORG_NO   c                   'N'
/     * These constants are used to override the spooled attribute values
/     * when conveting a text file to PDF.
/    d  TXTPDF_LPI     c                   60
/     * Normally, this would be lines per inch. However, since there is legacy
/     * mistake the precision of the variable, the calculation using this
/     * value have been adjusted. The value should be 6 for six lines per inch.
/    d  TXTPDF_PAGLE   c                   66
/     * Page length in lines
/    d  TXTPDF_CPI     c                   100
/     * Normally, this would be characters per inch. Howeverr, since there is legacy
/     * mistake the precision of the variable, the calculation using this
/     * value have been adjusted. The value should be 10 for 10 chars per inch.
/    d  TXTPDF_PAGWI   c                   132
/     * Page width in characters
/    d  QTCPASC        c                   'QTCPASC'
/     * Used by translate to convert EBCDIC to ASCII
/    d  CCSID_819      c                   '00819'
/     * Used by SPYIFS to create IFS file as ASCII
J3358d  OUTQ_SPYGLSOUTQ...
/    d                 c                   'SPYGLSOUTQ'
/2813d OK              c                   0
/6865d SPLMAIL         c                   'S'
/    d DESTPRINT       c                   'P'
T5469d ERROR           c                   -1
T5469d NATIVEPDF       c                   '4'
      * Native PDF file
T5469d TRUE            c                   '1'
T5469d FALSE           c                   '0'
J2399d Q               c                   x'7D'
/    d DEST_IFS        c                   'I'
/     * Signifies that the output will target an IFS file with a Text Format
/    d DEST_IFSPDF     c                   'A'
/     * Signifies that the output will target an IFS file with a PDF Format
/    d DEST_MAIL       c                   'M'
      * Signifies that the destination should be mail
J6644d DEST_FAX        c                   'F'

/    d EXT_TXT         c                   'TXT'
/    d EXT_PDF         c                   'PDF'
/    d PRTTY_AFPDS     c                   '*AFPDS'
J2469d PRTTY_IPDS      c                   '*IPDS'
J3358d PRTTY_AFPDSLINE...
/    d                 c                   '*AFPDSLINE'
J4819d PRTTY_LINE      c                   '*LINE'
J2399d PRTTY_SCS       c                   '*SCS'
/    d PRTTY_USERASCII...
/    d                 c                   '*USERASCII'
J2813d OBJTYP_IMAGE    c                   'I'
/    d OBJTYP_REPORT   c                   'R'
J2554d ERR102A         c                   'ERR102A'
      * Data Structures --------------------------------------------
J5331d  pstrSpcBuf     s               *
J5331d  pstrSpcSz      s               *
J5331d  strSpcSz       s              9a   based(pstrSpcSz)

J5331d dsBufSpc        ds                  based(pdsBufSpc)
J5331d   binBuffer                48000a

/6865d dsDstDef        ds                  inz qualified
/    d  RdSubr                       10a
/    d  RdRept                       10a
/    d  RdSeg                        10a

J2620d TIFFile         s            257a
/    d TIFType         s              2a
/    d TIFOffset       s             11a
/    d TIFLength       s             11a

/    d dsTIFtoPDF      ds
/    d                                 *   inz( %addr(TIFFile)   )
/    d                                 *   inz( %addr(TIFType)   )
/    d                                 *   inz( %addr(TIFOffset) )
/    d                                 *   inz( %addr(TIFLength) )
     d
J2620d dsTIFUsrSpc     ds                  qualified
/    d  UsrSpc                       10a   inz( 'TIFUSRSPC' )
/    d  UsrSpcLib                    10a   inz( 'QTEMP'     )

J3358d dsErrorCode     ds                  qualified
/    d  ByteProv                     10i 0 inz(%size(dsErrorCode))
/    d  ByteAvl                      10i 0 inz
/    d  MsgID                         7a
/    d  Rsrv                          1a
/    d  MsgDta                      256a

J2620d p_dsErrorCode   s               *   inz( %addr( dsErrorCode ) )

J2619d IMGTYPE_GIF     ds
/    d                                3    inz('gif')
/    d                                2    inz(x'0000')
/
J4902d IMGTYPE_PNG     ds
/    d                                3    inz('png')
/    d                                2    inz(x'00')
/
J2621d IMGTYPE_JPG     ds
/    d                                4    inz('jpeg')
/    d                                1    inz(x'00')
/
J2620d IMGTYPE_BMP     ds
/    d                                3    inz('bmp')
/    d                                2    inz(x'0000')

J2620d IMGTYPE_TIF     ds
/    d                                4    inz('tiff')
/    d                                2    inz(x'0000')
      * Variables --------------------------------------------------
J5331d p_UniqueFileName...
J5331d                 s               *
J5331d intWriteSz      s             10u 0
J5331 * Size the of buffer to be written to the IFS
J5331d pdsUsrSpc       s               *
J5331 * based pointer for the data structure
J5331d strTiffOffSet   s              9a
J5331 * character offset size from the QTEMP/TIFFnnn user space
J5331d intCodePage     s             10u 0 inz(1252)
J5331 * Windows code page
J5331d tiffBufferP     s               *
J5331 * Pointer into QTEMP/TIFFnnn user space
J5331d tiffBufSzP      s               *   inz(%addr(strTiffOffSet))
J5331 * Pointer into QTEMP/TIFFnnn user space representing the tiff data
J5331d intTiffBufSz    s             10u 0
J5331 * The integer equivalent of strTiffOffset
J5331d intUsrSpcSz     s             10i 0
J5331d flags           s             10u 0
J5331d mode            s             10u 0
J5331d intTiffCount    s             10i 0
J5331 * Count the number of tiff pages in a file
J5331d strSrcPath      s            256a
J5331 * Directory for the temporary tiff files
J5331d strSrcFile      s            256a
J5331 * File name for the temporary tiff files
J5331d strSrcPathFile  s            256a
J5331 * Concatentated path and file
J5331d strObjPath      s            256a
J5331d strPathPgm      s            256a
J5331 * Path to the conversion program
J4902d intPeriod       s             10i 0
J4902d blnOverload     s               n
      * Note that the file name had been passed
J2620d strOptions      s              8a
/     * No compression option string when calling MGBMPTOTIF
/    d p_strOptions    s               *   inz(%addr(strOptions))
/     *
/    d blnDebug        s               n   inz( FALSE )
/    d intCodePageWin  s             10u 0 inz(819)
/    d p_TifUsrSpc     s               *
/     * pointer to TIFF User Space QTEMP/TIFUSRSPC
/    d strFileSize     s              9a
/     * size of the TIFF File
/    d intTh           s             10i 0
/     * TIFF File Handle
/    d intUsrSpc       s              9b 0
/     * initial size of the user space
/    d strTifDta       s           5700a
/     * buffer data from the ifs file to the user space
/    d p_strTifDta     s               *   inz( %addr( strTifDta ) )
J2469d intEntCnt       s             10i 0
J2469d blnLog          s               n   inz( TRUE )
J2469d blnNativeEmailAFP...
/    d                 s               n   inz( FALSE )
/    d strAFPPath      s            256a
/    d strAFPPDFPathFile...
/    d                 s            256a
J3613d intStart        s             10u 0 inz( *zero )
J3613d intPDFSeq       s             10u 0 inz(*zero)
J2740d blnTXTPDF       s               n   inz(FALSE)
      * Used to control the file CCSID used when creating files on the IFS TXT to PDF
J3358d strErrorLog     s             80a
J5331d cmdOScmd        s           3000a
J3358d strGetPathString...
/    d                 s            256a
/    d strGetFileName  s            256a
J5464d ALwrite         s               *   procptr inz(%paddr('WRITEDATA'))
J5464d WriteData       pr            10i 0
J5464d  Buffer                         *   value
J5464d  BufferLn                     10u 0 value
J5464d  BufferFlag                   10i 0 value
J5464d  ErrorID                       8    value
J5464d  ErrorData                   101    value
J2814d ALsend          s               *   procptr inz(%paddr('ALSENDDATA'))    callback functi
j3470d*strPCLData      s           8100a
j3470d strPCLData      s          32767a
J2814d  LastPos        s             10i 0                                      buffer last pos
/    d gstrPCLFile     s            256a
/    d intPCLFH        s             10i 0
J2813d CurApfNam       s             10a
/    dmfldLib          s             10a
/    dstrIFSFile       s            256a
/    dstrPCLPath       s            128a
/    dmfldFile         s             10a
/    dmfldr            s             10a
T2553d Opened          s               n   inz(FALSE)
T2576d blnSplFAXBErr   s               n   inz(FALSE)
J2399d strAFPDSPath    s             65a
/6865d strBndID        s             10a
     d intBeginPage    s             10i 0
      * begining merge page
     d intEndPage      s             10i 0
      * ending merge page
     d i               s             10i 0
     d strPDFEOF       s              5a   inz(x'2525454F46')
      * ASCII representation of %%EOF
     d intPDFEOF       s             10i 0
T5469d intRtnCde       s             10i 0
     d strPDFBuffer    s           5700a   inz(*allx'00')
T5456d ptrPDFBuffer    s               *   inz(%addr(strPDFBuffer))
T5469d intReqSize      s             10u 0
T5469d intRtnSize      s             10i 0
T5469d intRtnCod       s             10i 0
T5469d intPDFGetBuf    s             10u 0 inz(5700)
T5469d intPDFSize      s             10u 0
T5469d intFH           s             10i 0
      * Native PDF buffer handler
T5469d blnNativePDF    s               n   INZ(FALSE)
      * Boolean determines if PDF files originated on the IFS
/5469dblnDistribution  s               n   INZ(FALSE)
      * Boolean determines if Distribution is being used
J2576dstrFAXReturn     s              4a   INZ('0000')

     d rc              s             10i 0
     d wkPage          s             10a
/9816d  wk_rptnam      s             10a

/6078d dblqte          pr           256
/    d  source                      256    value

     D B36             S              1    DIM(36) CTDATA PERRCD(36)
     D CL              S             78    DIM(58) CTDATA PERRCD(1)
/3345D FC              S             20    DIM(49) CTDATA PERRCD(1)
     D SPF             S             10    DIM(16) CTDATA PERRCD(1)
     D MSG             S              7    DIM(2) CTDATA PERRCD(1)

     D MPT             S             80    DIM(400)
     D #SI             S              1    DIM(10)
     D TMP             S              1    DIM(247)
     D RCW             S              1    DIM(247)
/    d RCHds           ds
     D RCH                            1    DIM(247)
     D W20             S              1    DIM(20)

     D DTS             S            100    DIM(76)
     D DTA             S            256    DIM(512)

     D HDR             S             80    DIM(4)
     D XF              S            100    DIM(250)

/2330D SVD             S              1    DIM(10)

     D @@LAND          C                   CONST('*LAND')
     D @@PORT          C                   CONST('*PORT')
     D @@AUTO          C                   CONST('*AUTO')
     D CRLF            C                   CONST(X'0D0A')
/6763D CVRRCL          C                   CONST(80)

     D RCDATA          DS
     D  RCFCFC                 1      1
     D  RCD                    2    248    DIM(247)
/    d  RC2247                 2    248
     D  RC2256                 2    256
     D  RC#RCS               190    193B 0
     D  RCPACK               205    205
     D  RCPG#                249    252B 0
     D  RCLIN#               253    256B 0
/2272D  PGTBTY               254    254
/2272D  PGTBTYsv       s                   like(PGTBTY)

     D MLDTA           DS          5700
     D  MLEXT                  1      5
     D  MLRTYP                 6     15
     D  MLSEG                 16     25
/8603D  MLPGTB                26     30

     D PCATR           DS          1024
     D  FMTSPY                 1      3
     D  FMTVER                 1      5
     D  PCIDX#                 6      8
     D  PCSIZE                 9     17
     D  PCFILE                18     42
     D  PCEXT                 43     47
     D  PCDATE                48     55
     D  PCTIME                56     61
     D  PCPATH                62    311
     D  PCUDAT               312    319
     D  PCUTIM               320    325
     D  PCUSR                326    335
     D  PCNODE               336    352
     D  PCOSV                353    358
     D  PCSPYV               359    364
     D  PCSYS                365    369

     D  DTALEN         s             10i 0
     D  DTAOFS         s             10i 0

     D ENVIRO          DS          2048    INZ
      *             Enivornment
     D  ENVI01                 1    256
     D  ENVI02               257    512
     D  ENVI03               513    768
     D  ENVI04               769   1024
     D  ENVI05              1025   1280
     D  ENVI06              1281   1536
     D  ENVI07              1537   1792
     D  ENVI08              1793   2048

     D  #FF                  104    104  0
     D  #HL                  105    106P 0
     D  #HS                  107    108P 0
     D  ENUMWN               556    557P 0
     D  ECWSC                698    895
     D  ECWW                 896   1093
     D LDA            UDS
     D  MLIND                  1     40
     D  MLFRM                 41    160
     D  MLFRM6                41    100
     D  MLSUBJ               161    220
     D  MLTXT1               221    285
     D  MLTXT2               286    350
     D  MLTXT3               351    415
     D  MLTXT4               416    480
     D  MLTXT5               481    545
     D  MLTYPE               546    546
     D  MLTO60               547    606
     D  MLTO                 547    666
     D  IFLIST               547    556
     D  IFREPL               557    557
     D  MLDIST               667    667
/2497d  mlFmt                668    677
/2930d  mlCdPg               678    682
/3393d  mlIgBa               683    683
/6609D  mlspml               684    684                                         SpoolMail

     D  CT                   101    880    DIM(12)
     D  FAXNUM                 1     40
     D  FAXFRM                41     85
     D  FAXTO                 86    130
     D  FAXRE                131    175
     D  FAXTX1               176    225
     D  FAXTX2               226    275
     D  FAXTX3               276    325
      * Faxtx4 used by faxid for faxsys
     D  FAXTX4               326    375
      * RPname & CPname for FastFax
     D  RPNAME               326    345
     D  CPNAME               346    365
     D  FAXID                326    375

     D  FAXTX5               376    425
     D  FAXTPM               376    377P 0
     D  FAXCTY               378    378
     D  FAXOVR               379    398
     D  FAXLPP               403    404P 0
     D  FAXLPA               403    404
     D  FAXSAV               426    426
     D  $WSC                 427    624
     D  $WW                  625    822
     D  FAXHLD               832    832
     D  LFILNA               833    842
     D  LJOBNA               843    852
     D  LUSRNA               853    862
     D  LUSRDT               863    872
     D  LPGMOP               873    882
     D  LCVRPG               883    883
     D  DJEBEF               884    893
     D  DJEAFT               894    903
     D  BANNID               904    913
     D  INSTRU               914    923
     D  FRMNAM               924    933
/2308d  Caller               992   1001
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
      *                                     987 990 kplste
      * FastFax,FaxStar,DirectFax,FaxSys,FaxServer
     D  COMBIN               991    991
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

     d SplData         s            247
/5469d djdeStart       s                   like(djeseq)
      * write a spool line (handle DJDE on first line)
/5469d SplLine         pr
     d  FCFC                          1    const
     d  Buffer                      247    const
      * write a spool line
/5469d SplWrite        pr
     d  FCFC                          1    const
     d  Buffer                      247    const

      * ---------------------------------------------------------------------- *
/6609d TXT_FMT         c                   '*TXT'
/2497d PDF_FMT         c                   '*PDF'
/8603d PDF_FONT        c                   'Courier'
/    d PDF_ENC_ST      c                   'winansi'
/    d PDF_ENC_CP      c                   '01252'

5225 d/copy QRPGLESRC,@PDFLIB

      * Packed to/from Float conversion (V3R2 workaround)
/CISCd Phloat          s             15p 5

     d PLastPos        s             10i 0
     d PPState         s              1

     d PDFh            s               *
     d PWidth          s                   like(phloat)
     d PHeight         s                   like(phloat)
     d PMargin         s                   like(phloat) inz(20)

     d PFNTh           s             10i 0
     d PFontSize       s                   like(phloat)
/3940d PFontSizeH      s                   like(phloat)
/    d PFontSizeW      s                   like(phloat)
/    d FHscale         s                   like(phloat)
/    d FWidth          s                   like(phloat)
     d Px              s                   like(phloat)
     d Py              s                   like(phloat)

     d PIMGh           s             10i 0
     d IWidth          s                   like(phloat)
     d IHeight         s                   like(phloat)
     d IResX           s                   like(phloat)
     d IResY           s                   like(phloat)

      * Open and setup a PDF document
/2497d OpenPDF         pr            10i 0
     d  PDFhandle                      *

      * Close a PDF document
/2497d ClosePDF        pr            10i 0
     d  PDFhandle                      *   const

      * Setup text page in the PDF document
/2497d SetTxtPDF       pr            10i 0
     d  PDFhd                          *   const

      * Start a new page in the PDF document
/2497d NewPagPDF       pr
     d  PDFhd                          *   const

      * Write a PDF document line
/2497d WrtLnPDF        pr
     d  PDFhd                          *   const
     d  Line                        256    const

      * Translate from EBCDIC to ASCII
/2497d xlateE2A        pr
     d  Line                      32767    options(*varsize)

      * Open Tiff image page for PDF document
/2497d OpenTifPDF      pr            10i 0
     d  PDFhd                          *
     d  FName                       256    const
     d  FType                         1    const
     d  FLength                      10i 0 const

      * Place Image as PDF page
/2497d ImgPagePDF      pr
     d  PDFhd                          *   const
     d  IMGhd                        10i 0 const

      * Callback for PDFopenMem
/2497d cbWrtMemP       s               *   procptr inz(%paddr('CBWRTMEM'))
     d cbWrtMem        pr            10u 0
     d  PDFhandle                      *   value
     d  Buffer                         *   value
     d  BufferLn                     10u 0 value

/2119DFrmTblS          DS           256
/2119d FrmTbl                         1    dim(256)
/
/2119DToTblS           DS           256
/2119d ToTbl                          1    dim(256)
      * ---------------------------------------------------------------------- *
/2423 *   This routine is a hardcoded to send escape messages to
/2423 *    EXPOBJSPY.
/2423d $EXPMSG         pr

      * Translate from ASCII to EBCDIC
/2119d xlateA2E        pr
/    d  A2ESpcPtr                      *   const
/    d  A2ELength                    10u 0 const

     D  INFLEN         s             10i 0
     D  STKCNT         s             10i 0

     D MSGINF          DS           100
     D  MINRTN                 1      4i 0
     D  MINAVL                 5      8i 0
     D  MINSEV                 9     12i 0
     D  MINMID                13     19
     D  FAXFIL                49     56
     D  MINDTA                49    100
     D ERRCD           DS           116
     D  @ERLEN                 1      4i 0 INZ(116)
     D  @MSGID                 9     15
     D  @ERDTA                17    116
     D                 DS
     D  #SICPY                 1     10
     D  #SDCPY                11     15
     D  #SDC2                 12     12
     D  #SDC3                 13     13
     D  #SDC4                 14     14
     D  #SDC5                 15     15

/2272D PTDSP           DS
      *             Page table from folder packed
     D  PTP                    1    252P 0 DIM(63)
/2272D PTDSB           DS
      *             Page table from folder binary
     D  CV_PTB                 1    252
     D  PTB                           9B 0 DIM(63)
     D                                     OVERLAY(CV_PTB)

     D PGTAB           DS                  INZ
      *             RSEGMNT data record
     D  PPT                    1    252P 0 DIM(63)
     D                SDS
      *             Program status
     D  PARMS                 37     39  0
     D  SYSERR                40     46
     D  PGMLIB                81     90
/6924d  thisJobName          244    253
     D  WQUSRN               254    263
     D  JNR                  264    269
     D                 DS
     D  WSC                    1    198  0 DIM(66)
     D  CWSC                   1    198
     D                 DS
     D  WW                     1    198  0 DIM(66)
     D  CWW                    1    198

     D SDT             DS          7680

     D RCVVAR          DS          8192    inz
      *              As400 spool file attrs
     D  @JOBNA                49     58
     D  @USRNA                59     68
     D  @JOBNU                69     74
     D  @FILNA                75     84
     D  @FILNU                85     88i 0
     D  @FRMTY                89     98
     D  @USRDT                99    108
     d  @hldfil              129    138a
     d  @savfil              139    148a
     D  @TOTPA               149    152i 0
     D  @LPI                 181    184i 0
     D  @CPYS                173    176i 0
     d  @cpyrem              177    180i 0
     D  @CPI                 185    188i 0
     d  @outQNam             191    200a
     d  @outQLib             201    210a
     D  @DATFO               211    217
     D  NDATFO               211    217  0
     d  @devNam              224    233a
T1770d  @devNamLib           234    243a
     D  @PGMOP               244    253
     D  @PRTXT               279    308
     D  @PRTTY               327    336
     D  @PRTFI               421    430
     D  @RPLUN               431    431
     D  @RPLCH               432    432
     D  @PAGLE               433    436i 0
     D  @PAGWI               437    440i 0
     D  @NUMSE               441    444i 0
     D  @OVRLI               445    448i 0
     D  @DBCDA               449    458
     D  @DBCEC               459    468
     D  @DBCSO               469    478
     D  @DBCCR               479    488
     D  @DBCCI               489    492i 0
     D  @GRAPH               493    502
     D  @CODPA               503    512
T1720d  @USFDN               513    522
/     * Form Definition
/    d  @USFDL               523    532
/     * Form Definition Library
     D  @SRCDR               533    536i 0
     D  @PRTFO               537    546
     D  @PAGRO               553    556i 0
     D  @JUSTI               557    560i 0
     D  @PRTBO               561    570
     D  @ALGFR               591    600
     D  @PRTQU               601    610
     D  @FRMFE               611    620
     D  @PGPSI               733    736i 0
     D  @FOVNA               737    746
     D  @FOVLI               747    756
     D  @FOVFD               757    764P 5
     D  @FOVFA               765    772P 5
     D  @BOVNA               773    782
     D  @BOVLI               783    792
     D  @BOVFD               793    800P 5
     D  @BOVFA               801    808P 5
     D  @UOM                 809    818
T1720D  @USPD                819    828
/     * Page Definition
/    D  @USPDL               829    838
/     * Page Definition Library
     D  @PNTSI               849    856P 5
     D  @CHLMO               887    896
     D  @CHLC1               897    900i 0
     D  @CHLC2               901    904i 0
     D  @CHLC3               905    908i 0
     D  @CHLC4               909    912i 0
     D  @CHLC5               913    916i 0
     D  @CHLC6               917    920i 0
     D  @CHLC7               921    924i 0
     D  @CHLC8               925    928i 0
     D  @CHLC9               929    932i 0
     D  @CHLCA               933    936i 0
     D  @CHLCB               937    940i 0
     D  @CHLCC               941    944i 0
     D  @FMRFD              3153   3160P 5
     D  @FMRFA              3161   3168P 5
     D  @BMRFD              3169   3176P 5
     D  @BMRFA              3177   3184P 5
     D  @FCHSN              3212   3221
     D  @FCHSL              3222   3231
     D  @CDPGN              3232   3241
     D  @CDPGL              3242   3251
     D  @CFNTN              3252   3261
     D  @CFNTL              3262   3271
     D  @DCFTN              3272   3281
     D  @DCFTL              3282   3291

     D DQMSG           DS           256
      * Data Que Message  (*Entry extensions)
     D  @DEST                  1      1
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

     D SYSDFT          DS          1024    dtaara
     D  ORGPH#                73     85
     D  LAPFCF               134    134
J3218d  LNOQDLS              203    203
     D  FAXTYP               251    251
     D  LFXOUT               257    266
     D  LFXLIB               267    276
     D  DTALIB               306    315
     D  PFRFLD               395    395
     D  SEPCHR               558    558
     D  SCVRPG               559    568
     D  SPAPSZ               570    579
     D  PRT1CP               680    680
     D  TXTEXT               775    777

     D ENVDFT          DS          1024
     D  FSTCLN               939    946
     D  FSTYYY               939    942
     D  FSTMM                943    944
     D  FSTDD                945    946

     D SPYCVR          DS           256
     D  CREPT                  1     10
     D  CBUNDL                11     20
     D  CSEGMT                21     30
     D  CSUBSC                31     40
     D  CCOPY                 41     46
     D  CRPTDS                47     86
     D  CBNDDS                87    126
     D  CSEGDS               127    166
     D  CSUBDS               167    206
     D  CRRNAM               207    216
     D  CRJNAM               217    226
     D  CRPNAM               227    236
     D  CRUNAM               237    246
     D  CRUDAT               247    256

      * Fax sequence number data area - created in QTEMP
      * Stores the job's last fax image sequence number in base 36
     D FAXSEQ         UDS
     D  FX#                    1      6    DIM(6)

/8603D                 DS
/     *             Hex conversion
/    D  CONVRT                 1      4i 0
/    D  CNVRT1                 4      4

     D                 DS
      *             Convert strings to packed.
     D  WRKPAK                 1      5P 0
     D                 DS
     D  YMD                    1      8
     D  SYYYY                  1      4
/3345D  SYY                    3      4
     D  SMM                    5      6
     D  SDD                    7      8
     D                 DS
     D  CYMD                   1      8
     D  CYYYY                  1      4
     D  CMM                    5      6
     D  CDD                    7      8
     D                 DS
      *                                             ....+....0...4
      *                                             Hhmmssmmddcccc
      *                                             Hhyyyymmddcccc
     D  TIMSTP                 1     14  0
     D  CDATE                  3     10  0
     D  YYYY                   3      6
     D  CCCC                  11     14
     D IMGNAM          DS
     D  IMGNMA                 1      2    INZ('IM')
     D  IMGNMN                 3      8

     D                 DS
     D  CTIME                  1      6  0
     D  CHR                    1      2
     D  CMN                    3      4
     D  CSS                    5      6

     D CMDLIN          DS          6000

     D CVRTXT          DS            65    OCCURS(12)
      *             Entry parm for duplex print

     D SPYSPC          C                   CONST('SPYEXPSPC')
     D PSCON           C                   CONST('PSCON     *LIBL     ')
     D RECIP           C                   CONST('*RECIPIENT')
     D OVRDB1          C                   CONST('OVRDBF FILE(')
     D OVRDB2          C                   CONST(') TOFILE(')
     D OVRDB3          C                   CONST(') NBRRCDS(2000) SEQO-
     D                                     NLY(*YES 2000)')
     D DLTOV1          C                   CONST('DLTOVR FILE(')
     D M2038A          C                   CONST('MAG2038APF')
     D CHKSPC          C                   CONST('CHKOBJ OBJTYPE(-
     D                                     *USRSPC) OBJ(QTEMP/')
     D DLTSPC          C                   CONST('DLTUSRSPC QTEMP/')
     D USRSPC          C                   CONST('*USERSPACE')
     D CUS#            C                   CONST('*CUSTNUMBER')
     D INTIMG          C                   CONST('*INTERNALIMG')
     D AFPSPL          C                   CONST('*AFPSPOOL')
     D AFPSTM          C                   CONST('*AFPDS')
     D ASCSTM          C                   CONST('*USERASCII')
     D #SHARE          C                   CONST('SHARE(*YES)')
/3393D BYPASS          C                   CONST('Bypass INVALID IMAGE')

/2423D  EMSGLN         s             10i 0
/2423D  @MSGPG         s             10i 0
/2423D  APILEN         s             10i 0

/2119 * User Space Buffer
/    Dusrspcd          s              1    based(usrspcdP)

/    D  usrspcs        s             10i 0
/    D  usrspcl        s             10i 0

/     * User Space Data Length
/    D dataLenA        DS
/    D dataLen                        9  0

/     * User Space Data
/    D SpcDataA        DS
/    D SpcData                    32767
/3345
/3345d xdate           s             13
/3345d DStime          ds
/3345d  xtime                  1      6  0
/3345d  xhh                    1      2
/3345d  xmm                    3      4
/3345d  xss                    5      6
/3345d xtime$          s             11
/3345d X               s              3  0
/3393
/3393D ERRCD2          DS           116
/3393D  @ERLE2                 1      4i 0 INZ(116)
/3393D  @ERRL2                 5      8i 0 inz(0)
/3393D  @MSGI2                 9     15
/3393D  @ERDT2                17    116
T4979d pdfFileName     s            512
/    d saveFH          s             10i 0
T3586d tgtPDFFileName  s            512a
T3586d tgtPDFPath      s            512a
T3586d srcPDFPathFile  s            512a
T3586d srcPDFFile      s            512a
T3586d srcPDFPath      s            512a

J1872d rtvSplfA        pr                  extpgm('QUSRSPLA')
     d  rcvVar                     8192
     d  lenRcvVar                    10i 0 const
     d  formatName                    8    const
     d  qualifiedJob                 26    const
     d  internalJobID                16    const
     d  interFileID                  16    const
     d  spoolFileName                10
     d  spoolFileNbr                 10i 0 const

J2144d dltfaxatt       ds             1    dtaara

/     * User Space Error Handling
/    I/copy qsysinc/qrpglesrc,qusec

     IMSPLDAT   IF  01
     I                                  1  256  RCDATA
     IDISP      IF  01
      * Attach file containing document to be attached to a fax.
     I                                  1    1  ATFCFC
     I                                  2  248  ATCRCD

     C     *ENTRY        PLIST
     C                   PARM                    RPTNAM           10
     C                   PARM                    OUTFRM           10
     C                   PARM                    RPTUD            10
     C                   PARM                    FRMPAG            7 0
     C                   PARM                    TOPAGE            7 0
     C                   PARM                    OUTQ             10
     C                   PARM                    OUTQL            10
     C                   PARM                    PRTF             10
     C                   PARM                    PRTLIB           10
     C                   PARM                    FRMCL#            3 0
     C                   PARM                    TOCOL#            3 0
     C                   PARM                    COPIES            3 0
     C                   PARM                    WRITER           10
     C                   PARM                    OUTFIL           10
     C                   PARM                    OUTFLB           10
     C                   PARM                    FILLOC            1
     C                   PARM                    OPTFIL           10
     C                   PARM                    NUMWND            3 0
     C                   PARM                    #RL               3 0
     C                   PARM                    COLSCN            3 0
     C                   PARM                    PLCSFA            9 0
     C                   PARM                    PLCSFD            9 0
     C                   PARM                    PLCSFP            9 0
     C                   PARM                    PRTWND            1
     C                   PARM                    @FLDR            10
     C                   PARM                    @FLDLB           10
     C                   PARM                    SPYNUM           10
     C                   PARM                    PTABLE           20
      * Print duplex: 29-
     C                   PARM                    CVRPAG            7
     C                   PARM                    DUPLEX            4
     C                   PARM                    ORIENT           10
     C                   PARM                    PTRTYP            6
     C                   PARM                    PTRNOD           17
     C                   PARM                    CVRMBR           10
     C                   PARM                    PAPSIZ           10
     C                   PARM                    DRAWER            4
/5329c                   parm                    eNotesPrint       1            Notes print

J2469c                   Callp(e)  submsglog( blnDebug : 'MAIN' : blnDebug )
T5469 *    Determine if distribution is being used

T5469c                   If        %subst(PTABLE:1:10) = *blanks
T5469c                   Eval      blnDistribution = FALSE
T5469c                   Else
T5469c                   Eval      blnDistribution = TRUE

      *   Determne if distribution is paired with SpoolMail and PDF
      *
J4819c***** 5849         If        (  ( mlspml = SPLMAIL    ) and
J5953c                   If        (  ( IsSplMail = SPLMAIL ) and
J4819c                                ( mlfmt  = FORMATPDF  )     )
J4819c                   Eval      @dest = DESTPRINT
J4819c                   EndIf

T5469c                   EndIf


T5469 *    Determine if the report type is Native PDF

T5469c                   If        NOT %open(MRptDir7)
T5469c                   Open(e)   MRptDir7
T5469c                   EndIf

T5469c     SpyNum        Chain(e)  MRptDir7

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

T5459c                   Close(e)  MRptDir7

/9816c                   eval      wk_rptnam = rptnam
     C                   Z-ADD     0             PAGE#             9 0
/5329c                   movel(p)  eNotesPrint   wNotesPrint       1
     C                   MOVEL     RPTNAM        SAVRPT           10

     C     PARMS         IFGE      28
     C                   MOVEL     PTABLE        TBL20            20
     C                   MOVEL     PTABLE        TBLNAM           10
     C                   ELSE
     C                   CLEAR                   TBL20
     C                   CLEAR                   TBLNAM
     C                   END

      * Parms for r/dars & imageview
     C     TBL20         IFNE      *BLANKS
     C     FILLOC        ANDEQ     '4'
     C     TBL20         ORNE      *BLANKS
     C     FILLOC        ANDEQ     '5'
     C     TBL20         ORNE      *BLANKS
     C     FILLOC        ANDEQ     '6'
     C                   MOVEL     TBL20         RFIL#
     C                   MOVE      TBL20         ROFFS
     C                   CLEAR                   TBL20
     C                   CLEAR                   TBLNAM
     C                   ELSE
     C                   Z-ADD     0             RFIL#
     C                   Z-ADD     0             ROFFS
     C                   END

     C                   DO        12            C#                5 0
     C     C#            OCCUR     CVRTXT
     C                   MOVE      CT(C#)        CVRTXT
     C                   ENDDO
     C                   CLEAR                   CVRDON
     C                   CLEAR                   NBRJOI
     C                   CLEAR                   FIL#
     C                   CLEAR                   IMG#

     C                   SELECT
      *----------------------------------------------------------------
      * If RPTNAM = *DTAQ or *DTAQi on entry:
      *    Concat values in OUTFRM and RPTUD to form key for DtaQ Read.
      *    Get values for RPTNAM, OUTFRM, RPTUD, etc from DtaQ msg.
      *----------------------------------------------------------------
     C     SAVRPT        WHENEQ    '*DTAQ'
     C     SAVRPT        OREQ      '*DTAQi'
     C     OUTFRM        CAT       RPTUD:0       KEY20A           20
     C                   EXSR      CNTPGS
     C                   Z-ADD     0             ENTPRC            5 0
     C                   MOVE      *ON           JOIN              1
     C                   MOVE      '*'           PRTINZ
     C                   MOVE      '0'           PRTRST
      *                                                     Get parms
     C                   DO        *HIVAL
      * Loop until (Q)uit=Leave
     C                   EXSR      RCVDQ
     C     @DEST         IFEQ      'Q'
     C     QDTASZ        OREQ      0

     C     SVDEST        IFNE      'I'
      * If there are images to fax, create coverpage.
     C     #TI           IFNE      0
     C     CVRDON        ANDNE     *ON
     C                   MOVE      *ON           CRTCVR            1
     C                   MOVEL     SVOBTY        RQOBTY
     C                   MOVE      'F'           @DEST
     C                   EXSR      DO#RPT
     C                   MOVE      'Q'           @DEST
     C                   MOVE      ' '           CRTCVR
     C                   END

     C     CVRDON        IFEQ      *ON
     C                   EXSR      CLSFAX
     C                   END
     C                   END

     C                   LEAVE
     C                   END
      *                                                    DQ entries
     C                   ADD       1             ENTPRC
      *                                                    Entry parms
     C                   MOVE      RQRPT         RPTNAM
     C                   MOVE      RQFRM         OUTFRM
     C                   MOVE      RQUD          RPTUD
     C                   MOVE      RQFLDR        @FLDR
     C                   MOVE      RQFLIB        @FLDLB
     C                   MOVE      RQLOC         FILLOC
     C                   MOVE      RQOPTF        OPTFIL
     C                   MOVE      RQIDX         REPIDX           10
     C                   MOVE      @DEST         SVDEST            1

     C                   MOVE      RQMBR         SPYNUM
/5329c                   eval      wNotesPrint = rqNotesPrint

     C                   Z-ADD     RQSPAG        FRMPAG
     C                   Z-ADD     RQEPAG        TOPAGE
     C                   Z-ADD     RQPTRA        PLCSFA
     C                   Z-ADD     RQPTRD        PLCSFD
     C                   Z-ADD     RQPTRP        PLCSFP
     C                   Z-ADD     RQNWND        NUMWND
     C                   MOVE      RQPWND        PRTWND
     C                   MOVE      RQEUSR        ENVUSR           10
     C                   MOVE      RQENAM        ENVNAM
     C                   MOVE      RQIMPG        IMGPAG

     C     PRTWND        IFEQ      'Y'
     C                   EXSR      EXTWIN
     C                   END

     C     @DEST         IFEQ      'F'
     C                   EXSR      CHKFAX
     C                   ENDIF
J2813 /free
J2470                    If ( RqObTy = OBJTYP_REPORT );
J2813                      ExSr OpnFld;
J2813                      ExSr RedAtr;
J2470                    EndIf;
/
/                        Select;
/                          When ( RqObTy = OBJTYP_IMAGE );
/                            ExSr Do#Img;
J3613                      When ( ( RQObTy = RQOBTY_REPORT ) and
/                                 ( @Dest  = DEST_IFSPDF   ) and
/                                 ( blnNativePDF = TRUE    )     );
/                            ExSr Do#NativePDF;
J2554                      When ( ( RqObTy = OBJTYP_REPORT    ) and
/                                 ( @PRTTY = PRTTY_IPDS       ) and
/                                 ( @dest  = DEST_IFSPDF      )     );
/                            @MsgID = ERR102A;
/                            Callp(e) $ExpMsg();
                             ExSr Quit;
J3358                      When ( ( RqObTy = OBJTYP_REPORT    )        and
/                                 ( ( @PRTTY = PRTTY_AFPDS     ) or
J3358                               ( @PRTTY = PRTTY_AFPDSLINE )    )  and
/                                 ( @dest  = DEST_IFSPDF      )             );
/
J3358
/                            OutQ = OUTQ_SPYGLSOUTQ;
/                            OutQL = DtaLib;
/                            ExSr Do#Rpt;
/                            Reset dsErrorCode;
/
/          strGetPathString =  GetPathString(MlTxt1);
/
/          //  Get the auto rendered file name based on the report
J4902      If %subst(%trim(mltxt1):%len(%trim(mltxt1)):1)  = SLASH  or
/             %subst(%trim(mltxt1):%len(%trim(mltxt1)):1)  = ASTERICK ;
/           strGetFileName = GetFileName( strGetPathString:@FilNa:'PDF':IfRepl);
/          Else; // Get the auto rendered filed name based on the file passed
/            strGetFileName =  %subst(%trim(MlTxt1)
/                                     : %len(%trim(strGetPathString))+2);
/
/           // Parse the prefix portion of the filename
/
/           If %scan( '.' : strGetFileName ) > 0;
/             strGetFileName = %subst( strGetFileName
/                                    : 1
/                                    : %scan( '.' : strGetFileName ) - 1);
/           EndIf;
/
/           strGetFileName = GetFileName( strGetPathString
/                                       : strGetFileName
/                                       : 'PDF'
/                                       : IfRepl );
/          EndIf;
/
/
/                            Callp(e) MgAFP2PDF( @Filna
/                                     : ThisJobName
/                                     : WQUsrN
/                                     : Jnr
/                                     : -1
J4902                                 : strGetPathString
J4902                                 : strGetFileName
/                                     : %int(mlcdpg)
/                                     : dsErrorCode.MsgID
/                                     : dsErrorCode.MsgDta
/                                     );
/
/                             If (  dsErrorCode.MsgID <> *blanks );
/                               strErrorLog =
/                               MMMSGIO_RtvMsgTxt( dsErrorCode.MsgId
/                                                : dsErrorCode.MsgDta
/                                                : 'PSCON' );
/
/                               MMMSGIO_SndMsgTxt( strErrorLog );
/                             EndIf;
/
/                             // Delete spooled file
/
/                             cmdOScmd = 'DLTSPLF FILE('
/                                      + %trim(@FilNa)
/                                      + ') JOB('
/                                      + JNR + '/'
/                                      + %trim(WQUsrN) + '/'
/                                      + %trim(ThisJobName) + ') '
/                                      + ' SPLNBR(*LAST)';
/
/                             If ( Run(%trimr(cmdOScmd)) <> OK );
/                               strErrorLog = 'Issue deleting spooled file';
/                               MMMSGIO_SndMsgTxt( strErrorLog );
/                             EndIf;
/
/                             // Close the open report, delete the override
/
/                             Close #report#;
/
/                             cmdOScmd = 'DLTOVR FILE(#REPORT#) LVL(*JOB)';
/                             If ( Run(%trimr(cmdOScmd)) <> OK );
/                               strErrorLog = 'Issue deleting override';
/                               MMMSGIO_SndMsgTxt( strErrorLog );
/                             EndIf;
/
J2813                      When ( ( RqObTy = OBJTYP_REPORT    ) and
/                                 ( @PRTTY = PRTTY_USERASCII ) and
/                                 ( @dest  = DEST_IFSPDF      )     );
/
/
/                            If ( RenderIFSFile( SpyNum
/                                              : @FldLb
                                               : repind
                                               : 'PCL'
/                                              : %trim(mltxt1) + %trim(mltxt2)
/                                              : %int(MlCdPg)
                                               : IfRepl
                                               : FrmPag
                                               : ToPage
                                               : TotPag
/                                              : strIFSFile) = OK );
/
/                                If  ( TotPag = ( ( ToPage - FrmPag ) + 1 ) );
/                                  RenderPCLPDF( gstrPCLFile );
J5464                            Else;
J5464                             // RenderPCLPDF( gstrPCLFile
J5464                             //             : %int( FrmPag  )
J5464                             //             : %int( ToPage  ) );
/                                EndIf;
/
/                            EndIf;
/
/                          Other;
/                            ExSr Do#Rpt;
/                        EndSl;
/     /end-free
     C*** 2813 RQOBTY        CASEQ     'I'           DO#IMG
     C*** 2813               CAS                     DO#RPT
     C*** 2813               ENDCS

     C                   ENDDO

     C                   OTHER
     C     TOPAGE        SUB       FRMPAG        PAGTOT
     C                   ADD       1             PAGTOT
     C                   MOVE      ' '           JOIN              1
     C                   MOVE      'R'           RQOBTY

     C     @DEST         IFEQ      'F'
     C                   EXSR      CHKFAX
     C                   ENDIF

     C                   MOVE      DESTSV        @DEST
     C                   EXSR      DO#RPT

     C     @DEST         IFEQ      'F'
     C                   EXSR      CLSFAX
     C                   END
     C                   ENDSL
      * Close mail
     C     MLOPEN        IFEQ      '1'
     C     MLDIST        ANDNE     'Y'
     C                   MOVEL(P)  'CLOSE'       MLOPCD
     C                   EXSR      SPMAIL
     C                   ENDIF

/5635 * write HIPAA log record
/9613c                   select
J5953c                   When      @dest = 'P' and IsSplMail = 'S'
/9613c***** 5849         when      @dest = 'P' and mlspml = 'S'
/    c                   exsr      bldEmlDtl
/    c                   when      (@dest <> 'F' or
     c                             (@dest = 'F' and PrmFax <> 'E'))
     c                             and @dest <> 'Q'
/5635c                   callp     BldLogEnt(@dest:SpyNum:Frmpag:ToPage)
/9613c                   endsl

     C                   EXSR      QUIT
      *---------------------------------------------------------------------------------------
J4902 /free
/       BegSr SetPCFilSeq;
/        strGetPathString = GetPathString( mltxt1 );
/
/        // Massage the target filename
/        // If ( IfRepl = REPLACE_SEQ );
/          strGetFileName   = PCFile;
/
/          If %scan( '.' : strGetFileName ) > 0;
/            strGetFileName = %subst( strGetFileName
/                                   : 1
/                                   : %scan( '.' : strGetFileName ) - 1 );
/            // Use the archived image file name
/            If ( %subst(mltxt1 : %len( %trim( mltxt1 ) ) : 1 ) = SLASH    ) or
/               ( %subst(mltxt1 : %len( %trim( mltxt1 ) ) : 1 ) = ASTERICK );
/              // strGetFileName = PCFile;
/            Else;
/            // Use the API file name to render and override the
/            // archived file name
/              strGetFileName =
/              %subst( mltxt1  : %len ( %trim( strGetPathString ) ) + 2  );
/              intPeriod =  %scan(PERIOD : strGetFileName );
/
/              If intPeriod > 0;
/                strGetFileName = %subst( strGetFileName : 1 : intPeriod - 1);
/              EndIf;
/
/            EndIf;
/
/          // EndIf;
/
/          PCFile = GetFileName( strGetPathString
/                              : strGetFileName
/                              : ToUpper( PCExt )
/                              : IFREPL
/                              : %int( img# ) );
/        EndIf;
/       EndSr;
/     /end-free
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPNIFS        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'OPNIFS' : blnDebug )
J4902c                   ExSr      setPCFilSeq
      *          Open file for IFS export
     c                   exsr      setPCFilNam
     C                   MOVEL(P)  'OPEN'        IFOPCD
     C                   CALL      'SPYIFS'      PLIFS

/5635 * prepare detail HIPAA logging for printing to *IFS
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):#DTPATH:*NULL:
/5635c                              0:%addr(IFPath):%len(%trim(IFPath)))
/5635c                   callp     BldLogEnt('I':SpyNum:Frmpag:ToPage)

     C     IFSRTN        IFNE      *BLANKS
/2423C                   MOVE      IFSRTN        @MSGID
/2423c                   callp     $EXPMSG
     C                   MOVEL(P)  'QUIT'        IFOPCD
     C                   CALL      'SPYIFS'      PLIFS
     C                   EXSR      QUIT
     C                   END

     C                   ENDSR

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
J2473c     setPCFilNam   begsr

J2469c                   Callp(e)  SubMsgLog(blnDebug:'SetPCFilNam' : blnDebug )
/7455 * IFS path now limited to 128 characters
/7455c                   eval      ifPath = %trim(Mltxt1) + %trim(Mltxt2)
      *  FIGURE OUT FILENAME FOR REPORTS
     C     RQOBTY        IFEQ      'I'
     C     '.IMG'        SCAN      PCFILE                                 50
     C     *IN50         IFEQ      '1'
     C     PCBTCH        CAT(P)    '.TIF':0      PCFILE
     C                   ENDIF
     C                   ELSE
     C     SPYNUM        CAT(P)    '.':0         PCFILE

/2399 /free
/                        Select;
/                          When ( @Dest = DEST_IFS );
/                            PCFile = %trimr(PCFile) + EXT_TXT;
/
/        //  Define the path name of the resulting file here
/        //  if the original spooled file is NOT AFPDS and PDF
/        //  extension is requested.
/
/                          When ( ( @Dest = DEST_IFSPDF ) and
/                                 ( @Prtty <>  PRTTY_AFPDS )   );
/                            PCFile = %trimr(PCFile) + EXT_PDF;
/                          Other;
/                            PCFile = %trimr(PCFile) + TXTEXT;
/                        EndSl;
/     /End-free
     C
     C                   ENDIF
      *  IF LAST CHAR OF IFS PATH IS '*' JUST ADD FILENAME
     C     ' '           CHECKR    IFPATH        F50               5 0
     C     F50           IFGT      0
     C     1             SUBST     IFPATH:F50    F1A               1
     C     F1A           IFEQ      '*'
J2473 /free
J2473   if @dest = 'A' and %xlate(lo:up:%subst(pcExt:1:3)) = 'TIF';
J4902   // swap the existing TIF extension with the PDF extension
J4902     PCFile = %subst( PCFile : 1 : %scan( '.' : PCFile) ) + EXT_PDF;
J2473   // pcFile = %replace('.' + EXT_PDF:pcFile:
J2473   //   %scan('.'+%trim(pcExt):pcFile):%len(%trim(pcExt)) + 1);
J2473   endif;
J2473 /end-free
     C                   SUB       1             F50
     C     F50           SUBST(P)  IFPATH:1      IFPATH
     C                   CAT       PCFILE:0      IFPATH
J4902 /free
/                        ElseIf ( @Dest = DEST_IFSPDF );
/                          IfPath = %trim(strGetPathString) + '/' + PCFile;
/     /End-free
     C                   ENDIF
     C                   ENDIF

     C                   SELECT
     C     IFREPL        WHENEQ    'N'
     C                   MOVEL(P)  'CHECK'       IFOPCD
     C                   CALL      'SPYIFS'      PLIFS
     C     IFSRTN        IFEQ      *BLANKS
     C                   MOVEL     'ERR4095'     @MSGID
     C                   MOVEL(P)  IFPATH        EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   ENDIF
     C     IFREPL        WHENEQ    'S'
     C                   MOVEL(P)  'DUPFIL'      IFOPCD
     C                   CALL      'SPYIFS'      PLIFS
     C                   ENDSL
      *          UPDATE USRSPC
     C                   EXSR      UPDSPC

     C                   endsr

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKFAX        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CHKFAX' : blnDebug )
      *          Check if everything is fine for faxing
      *            (you might check if the faxserver is up)

     C     DIDCHK        IFEQ      ' '
     C                   SELECT
     C     FAXTYP        WHENEQ    '1'
      * See if Faxstar is setup under TCP
     C                   CALL      'FAXSTCP'
     C                   PARM      OUTQ          FOUTQ            10
     C                   PARM      OUTQL         FOUTQL           10
     C                   PARM                    FTCP              1
     C                   ENDSL
     C                   MOVE      '1'           DIDCHK            1
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CNTPGS        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CNTPGS' : blnDebug )
      *          Read the DtaQ msgs for this OUTFRM|RPTUD
      *          and put them back in order to count:
      *            # entries for the OUTFRM|RPTUD
      *            # pages queued for inclusion on the cover page

     C                   Z-ADD     0             ENTCNT            5 0
     C                   Z-ADD     1             PAGTOT            5 0
     C                   EXSR      RCVDQ

     C     QDTASZ        DOWGT     0
     C                   EXSR      SNDDQ

     C     @DEST         IFEQ      'Q'
     C                   LEAVE
     C                   END

     C                   ADD       1             ENTCNT
     C                   ADD       RQEPAG        PAGTOT
     C                   SUB       RQSPAG        PAGTOT
     C                   ADD       1             PAGTOT
     C                   EXSR      RCVDQ
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RCVDQ         BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'RCVDQ' : blnDebug )

     C                   CALL      'QRCVDTAQ'
     C                   PARM      'MAG210'      QNAME            10
     C                   PARM      '*LIBL'       QLIB             10
     C                   PARM      256           QDTASZ            5 0
     C                   PARM                    DQMSG
     C                   PARM      30            QWAIT             5 0
     C                   PARM      'EQ'          QORDER            2
     C                   PARM      20            QKEYSZ            3 0
     C                   PARM                    KEY20A
     C                   PARM                    QSNDLN            3 0
     C                   PARM                    QBRTN             7 0
T5657c                   parm      '*YES'        rmvmsgs          10
/    c                   parm      256           rcvrLen           5 0
/    c                   parm                    errcd2

     C     SVOBTY        IFEQ      ' '
     C                   MOVE      RQOBTY        SVOBTY            1
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRDQ         BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CLRDQ' : blnDebug )
J5953c                   Reset                   ErrCd2
     c
      * CLEAR DTAQ
J5953C                   DoU       ( ( QDtaSz = 0        )  or
J5953c                               ( @MsgI2 <> *blanks )     )
     C                   CALL      'QRCVDTAQ'
     C                   PARM      'MAG210'      QNAME            10
     C                   PARM      '*LIBL'       QLIB             10
     C                   PARM      256           QDTASZ            5 0
     C                   PARM                    DQMSG
     C                   PARM      0             QWAIT             5 0
     C                   PARM      'EQ'          QORDER            2
     C                   PARM      20            QKEYSZ            3 0
     C                   PARM                    KEY20A
     C                   PARM                    QSNDLN            3 0
     C                   PARM                    QBRTN             7 0
T5657c                   parm      '*YES'        rmvmsgs          10
/    c                   parm      256           rcvrLen           5 0
/    c                   parm                    errcd2
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDDQ         BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'SNDDQ' : blnDebug )

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'MAG210'      QNAME            10
     C                   PARM      '*LIBL'       QLIB             10
     C                   PARM      256           QDTASZ            5 0
     C                   PARM                    DQMSG
     C                   PARM      20            QKEYSZ            3 0
     C                   PARM                    KEY20A
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MG1092        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'MG1092' : blnDebug )
      *          Call Db server: Image & PC files; dasd/opt (QMRSRC)

     C                   CALL      'MAG1092'                            50
     C                   PARM                    PCOPCD           10
     C                   PARM                    PCBTCH           10
     C                   PARM                    PCIRRN            9 0
     C                   PARM                    PCSTOF            9 0
     C                   PARM                    PCBREQ            9 0
     C                   PARM      'Y'           PCCACH            1
     C                   PARM                    PCISIZ            9 0
     C                   PARM                    PCBRET            9 0
     C                   PARM                    PCNRRN            9 0
     C                   PARM                    PCATR
     C                   PARM                    DTA
     C                   PARM                    PCRTNC            7
     C                   PARM                    PCRTND          100

     C                   MOVE      '1'           CL1092            1

     C     PCRTNC        IFNE      *BLANKS
     C     *IN50         OREQ      *ON
     C                   MOVEL     PCRTNC        @MSGID
     C                   MOVEL     PCRTND        EMSGDT
/2423c                   callp     $EXPMSG
/3393 *
/3393 **Check Error code if you can clear messages for EXPOBJSPY
/3393 ** DID NOT Send Escape Message so you are not in EXPOBJSPY
/3393 ** so you should quit
/3393 *
/3393C     IgnBatch      ifeq      'N'
/3393C     PCRTNC        oreq      'ERR004A'
/3393C     PCRTNC        oreq      'ERR004B'
     C                   EXSR      QUIT
/3393C                   END
     C                   END
     C     PCEXT         IFEQ      'IMG'
     c                   eval      pcExt = 'TIFF'
     C                   END

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DO#IMG        BEGSR
      *          --------------------------------
      *          Process a request for Image data
      *          --------------------------------
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'DO#IMG' : blnDebug )
      * Fax:
      *   Put records put to QDLS.
     C                   MOVE      REPIDX        PCBTCH
     C     OPNIMG        IFEQ      ' '
     C                   OPEN      MIMGDIR
     C                   MOVE      '1'           OPNIMG            1
     C                   END
     C     PCBTCH        CHAIN     MIMGDIR                            50
     C                   Z-ADD     RQSPAG        PCIRRN
      * Check if pointers valid
     C                   MOVEL(p)  'GETATR'      PCOPCD
     C                   EXSR      MG1092
/3393 *
/3393 * Don't continue if in error
/3393C     PCRTNC        IFeq      *BLANKS
/3393C     *IN50         andeq     *Off
/3393C     IgnBatch      andeq     'Y'
/3393C     IgnBatch      oreq      'N'
      * Get rmaint
     C                   OPEN      RMAINT                               50
     C                   MOVE      IDDOCT        FILNAM
     C                   MOVE      *BLANKS       JOBNAM
     C                   MOVE      *BLANKS       PGMOPF
     C                   MOVE      *BLANKS       USRNAM
     C                   MOVE      *BLANKS       USRDTA
     C     KLBIG5        CHAIN     RMNTRC                             66
     C                   CLOSE     RMAINT

J1892C                   If        NOT %Found
/    C                   Open(e)   RMAINT4
/    C     IDDOCT        Chain     RMNTRC4                            66
/    C                   Close(e)  RMAINT4
/     *
/    C                   If        NOT %found
/    C                   Eval      RTypID = *blanks
/    C                   EndIf
/     *
/    C                   EndIf

     C                   SELECT
      * EMail
     C     @DEST         WHENEQ    'M'
     C                   EXSR      MLIMG
      * Fax
     C     @DEST         WHENEQ    'F'

     C     FAXTYP        IFEQ      'A'
     C     FAXTYP        OREQ      '2'
     C                   MOVEL(P)  '*AFP'        RQPTYP
     C                   EXSR      PRTIMG
     C                   MOVE      '1'           AFPIMG            1
     C                   ELSE
     C                   EXSR      FAXIMG
     C                   ENDIF
      * Print
     C     @DEST         WHENEQ    'P'
     C                   EXSR      PRTIMG
J2473 * Convert to PDF format and place on IFS.

/    C                   when      @dest = DEST_IFSPDF and @prtty <> PRTTY_AFPDS
J2470C                             and not blnNativePDF and
J2470C                             ( ( ToUpper( PCExt ) = EXT_TIF   )  or
/    C                               ( ToUpper( PCExt ) = EXT_TIFF )      )
/    C                   exsr      convertToPDF
      * To IFS
/2399C                   When      ( @Dest = DEST_IFS ) or
/    C                             (  ( @Dest  = DEST_IFSPDF ) and
/    C                                ( @prtty <> PRTTY_AFPDS )     )
/2470c                   Eval      TOCCS = CCSID_819
/2470c                   Eval      blnTXTPDF = TRUE
/2399C                   EXSR      IFSIMG
/2470 /free
/
/
/                        If ( @Dest = DEST_IFSPDF );
/
/                          Select;   // Convert text to PDF
/                            When ( ToUpper( PCExt ) = EXT_TXT );
/                              If ( ConvTXTPDF( IFPath
/                                             : DELETEORG_YES
/                                             : TXTPDF_LPI
/                                             : TXTPDF_PAGLE
/                                             : TXTPDF_CPI
/                                             : TXTPDF_PAGWI) <> OK );
/                                MMMSGIO_SndMsgTxt( 'Issue converting ' +
/                                                   'TXT file to PDF' );
/                              EndIf;  // Convert GIF to PDF
J4902                        When ( ToUpper( PCExt ) = EXT_PNG );
/                              If ( ConvImgPDF( IFPath
/                                             : IMGTYPE_PNG
/                                             : EXT_PNG
/                                             : DELETEORG_YES ) <> OK );
/                                MMMSGIO_SndMsgTxt( 'Issue converting ' +
/                                                   'GIF file to PDF' );
/                              EndIf;   // Convert JPG to PDF
J2619                        When ( ToUpper( PCExt ) = EXT_GIF );
/                              If ( ConvImgPDF( IFPath
/                                             : IMGTYPE_GIF
/                                             : EXT_GIF
/                                             : DELETEORG_YES ) <> OK );
/                                MMMSGIO_SndMsgTxt( 'Issue converting ' +
/                                                   'GIF file to PDF' );
/                              EndIf;   // Convert JPG to PDF
J2621                        When ( ToUpper( PCExt ) = EXT_JPG );
/                              If ( ConvImgPDF( IFPath
/                                             : IMGTYPE_JPG
/                                             : EXT_JPG
/                                             : DELETEORG_YES)  <> OK );
/                                MMMSGIO_SndMsgTxt( 'Issue converting ' +
/                                                   'JPG file to PDF' );
/                              EndIf;
J2620                        When ( ToUpper( PCExt ) = EXT_BMP );
/                              If ( ConvImgPDF( IFPath
/                                            : IMGTYPE_BMP
/                                            : EXT_BMP
/                                            : DELETEORG_YES ) <> OK );
/                                MMMSGIO_SndMsgTxt( 'Issue converting ' +
/                                                   'BMP file to PDF' );
/                              EndIf;
J2470                      EndSl;
/
/                        EndIf;
/     /end-free
/2399C                   ENDSL
/3393C                   else
/3393C                   movel(p)  BYPASS        IFPATH
/3393C                   EXSR      UPDSPC
/3393C                   end

     C     ENDIMG        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MLIMG         BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'MLIMG' : blnDebug )
      *          Mail pc files

J6348c                   exsr      BldEmlDtl

      * Open mail
     C     MLOPEN        IFNE      '1'
     C                   MOVEL(P)  MLTXT1        MPT(1)
     C                   MOVEL(P)  MLTXT2        MPT(2)
     C                   MOVEL(P)  MLTXT3        MPT(3)
     C                   MOVEL(P)  MLTXT4        MPT(4)
     C                   MOVEL(P)  MLTXT5        MPT(5)
     C                   CLEAR                   MLDTA
     C                   CLEAR                   MLDTLE
     C                   MOVEL(P)  'OPEN'        MLOPCD
     C                   EXSR      SPMAIL
     C                   ENDIF

     C     LO:UP         XLATE     PCEXT         PCEXT

     C     PCEXT         IFNE      'TIF'
/3307C     PCEXT         ANDNE     'TIFF'
     C     PCEXT         ANDNE     'IMG'
     C     PCEXT         ANDNE     *BLANKS
     C     IMGPAG        OREQ      '*ALL'
/2497c     mlFmt         andne     PDF_FMT
     C     IMGPAG        OREQ      *BLANKS
/2497c     mlFmt         andne     PDF_FMT
     C                   EXSR      MLSTMF
     C                   ELSE
     C                   EXSR      MLTIFF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MLTIFF        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'MLTIFF' : blnDebug )
      *          Mail a tiff file

      * Get req pages
     C                   EXSR      SPYTIF

J1481 /free
/      // Get user space pointers for all requested pages.
/      if mlfmt <> PDF_FMT;
/        clear qusec;
/        qusbprv = %size(qusec);
/        for filidx = 0 to 999;
/          rtvUsrSpcPtr('TIFF' + %editc(filidx:'X') + '   QTEMP':
/            tiffUsrSpcP(filidx+1):qusec);
/          if qusbavl > 0 and qusei = 'CPF9801'; // No more spaces. Process.
/            leave;
/          endif;
/        endfor;
/        spyPath('*MAILTMP':tiffPath);

J5331    If ( UniqueFilename(p_UniqueFileName) <> OK );
J5331      leaveSr;
J5331    EndIf;
J5331
J5331    tiffPath = %trimr(tiffPath) + '/' + %str(p_UniqueFileName) +
/          '.tiff' + x'00';
/        // Combine all of the generated user space pages into a single file
/        // and then attach the contents of that file to the email.
/        cmbTiffPgs(%addr(tiffUsrSpcP):filidx:tiffPath);
/        run('dltusrspc qtemp/tiff*');
/        stat(%addr(tiffPath):%addr(stat_ds));
/        fp = ifsfopen(tiffPath:'rb');
/        bytrem = st_size;
/        clear mldta;
/        mlext = pcext;
/        mlrtyp = rtypid;
/        mlstm = 'BIN';
/        spyMail(mldta:mldtle:'OPNATT':mlto:mltype:mlfrm:mlsubj:mpt:mlrtn);
/        dtalen = 5700;
/        clear mldta;
/        dow bytrem > 0;
/          if ifsfread(%addr(mldta):dtalen:1:fp) > 0;
/            mldtle = dtalen;
/            spyMail(mldta:mldtle:'WRTATT':mlto:mltype:mlfrm:mlsubj:mpt:mlrtn);
/          endif;
/          bytrem -= dtalen;
/          if bytrem < 5700;
/            dtalen = bytrem;
/          endif;
/        enddo;
/        ifsfclose(fp);
/        unlink(tiffPath);
/        leavesr;
J5331  ElseIf ( mlfmt = PDF_FMT );
J5331      spyPath('*MAILTMP':strSrcPath);
J5331
J5331      for filidx = 0 to 999;
J5331        nxtnam = 'TIFF' + %editc(filidx:'X');
J5331        exsr chkNxt;
J5331
J5331        if nxtOK = '0';
J5331          leave;
J5331        endif;
J5331        // Place a pointer of the user space into
J5331        // an array of pointers
J5331        reset qusec;
J5331        rtvUsrSpcPtr('TIFF' + %editc(filidx
J5331                     : 'X') + '   QTEMP'
J5331                     : TiffBufferP
J5331                     : qusec);
J5331
J5331        If qusbavl > 0 and qusei = 'CPF9801'; // No more spaces. Process.
J5331          leave;
J5331        EndIf;
J5331
J5331        // Isolate the embedded size of the buffer
J5331        pstrSpcSz  = TiffBufferP;
J5331        // Isolate the point to the buffer data itself
J5331        pstrSpcBuf = TiffBufferP+9;
J5331        // Initialize the pointer with the address of the
J5331        // buffer where actual tiff data is stored
J5331        //  DsUsrSpc.pBufSpc =  TiffBufferP + %size(dsUsrSpc.strSpcSz);
J5331        // Create a separate TIF file for each user space
J5331        strSrcFile = 'src' + %editc(filidx : 'X' ) + '.tif';
J5331        strSrcPathFile = %trimr(strSrcPath) + '/' + strSrcFile + x'00';
J5331        intUsrSpcSz = GetUsrSpcSz( 'QTEMP     '
J5331                                  : 'TIFF' + %editc(filidx : 'X' ) );
J5331        flags = O_WRONLY + O_CREAT + O_TRUNC;
J5331        mode  = S_IRUSR + S_IWUSR + S_IRGRP;
J5331        fd = IFSopen(  %trimr( strSrcPathFile )
J5331                    : O_CREAT + O_TRUNC + O_WRONLY + O_CODEPAGE
J5331                    : S_IRWXU + S_IRWXG + S_IRWXO
J5331                    : intCodePageWin );
J5331        IFSClose(fd);
J5331        fd = IFSOpen( %trimr( strSrcPathFile ):flags:mode);
J5331
J5331        If ( fd < 0 );
J5331          leaveSr;
J5331        EndIf;
J5331
J5331        intWriteSz = %int(strSpcSz);
J5331
J5331        If ( IFSwrite( fd
J5331                     : pstrSpcBuf
J5331                     : intWriteSz
J5331                     )
J5331              <> intWriteSz
J5331            );
J5331          leaveSr;
J5331        EndIf;
J5331
J5331        Callp(e) close(fd);
J5331
J5331      endfor;
J5331
J5331      intTiffCount = filidx - 1;
J5331
J5331      // Combine all of the generated user psaced into a single file
J5331      // and then call tiff2pdf
J5331
J5331      run('dltusrspc qtemp/tiff*');
J5331      spyPath('*PDFSUPP' : strObjPath );
J5331      strPathPgm = %trimr( strObjPath ) + '/tiff2pdf';
J5331
J5331      If ( UniqueFilename(p_UniqueFileName) <> OK );
J5331        leaveSr;
J5331      EndIf;
J5331
J5331      tiffPath = %trimr(%str(p_UniqueFileName));
J5331      tiffPath = %trimr(strSrcPath) + '/' + %trim(tiffPath) + '.pdf';
J5331      cmdOScmd = 'qsh cmd(' + Q + %trimr( strPathPgm )
J5331               + ' -t ' + QQ + 'OpenText Document' + QQ
J5331               + ' -a ' + QQ + 'OpenText' + QQ
J5331               + ' -d ' + QQ + %trim( strSrcPath ) + '/' + QQ
J5331               + ' -o ' + QQ + %trim( tiffPath )   + QQ;
J5331
J5331     For filidx = 0 to intTiffCount;
J5331        strSrcFile = 'src' + %editc(filidx : 'X' ) + '.tif';
J5331        cmdOScmd = %trim(cmdOScmd) + '  ' + QQ + %trim( strSrcFile ) +QQ;
J5331     EndFor;
J5331
J5331     cmdOScmd =  %trim(cmdOScmd) + ' 2>/dev/null ' + Q +  ' )';
J5331
J5331      If ( run(cmdOScmd) <> 0 );
J5331        exsr quit;
J5331      EndIf;
J5331
J5331      For filidx = 0 to intTiffCount;
J5331        strSrcFile = %trim(strSrcPath) + '/'
J5331                   + 'src' + %editc(filidx : 'X' ) + '.tif';
J5331        unlink( strSrcPathFile );
J5331      EndFor;
J5331      run('dltusrspc qtemp/tiff*');
J5331      tiffPath = %trim( tiffPath ) + x'00';
J5331      stat(%addr(tiffPath):%addr(stat_ds));
J5331      fp = ifsfopen(tiffPath:'rb');
J5331      bytrem = st_size;
J5331      clear mldta;
J5331      mlext = 'PDF';
J5331      mlrtyp = rtypid;
J5331      mlstm = 'BIN';
J5331      spyMail(mldta:mldtle:'OPNATT':mlto:mltype:mlfrm:mlsubj:mpt:mlrtn);
J5331      dtalen = 5700;
J5331      clear mldta;
J5331      dow bytrem > 0;
J5331        if ifsfread(%addr(mldta):dtalen:1:fp) > 0;
J5331          mldtle = dtalen;
J5331          spyMail( mldta : mldtle : 'WRTATT'
J5331                 : mlto : mltype : mlfrm : mlsubj : mpt : mlrtn);
J5331        endif;
J5331        bytrem -= dtalen;
J5331        if bytrem < 5700;
J5331          dtalen = bytrem;
J5331        endif;
J5331      enddo;
J5331      ifsfclose(fp);
J5331      unlink(tiffPath);
J5331      leaveSr;
J5331    EndIf;
J5331    EndSr;
J5331 /end-free
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MLSTMF        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'MLSTMF' : blnDebug )
      *          Mail a stream file

      * Open attachment
     C                   CLEAR                   MLDTA
     C                   MOVEL(P)  PCEXT         MLEXT
     C                   MOVEL(P)  RTYPID        MLRTYP
     C                   MOVEL(P)  'BIN'         MLSTM             3
     C                   MOVEL(P)  'OPNATT'      MLOPCD
     C                   EXSR      SPMAIL
     C                   CLEAR                   MLDTA
      * Read data
     C                   Z-ADD     0             PCSTOF
     C     PCBRET        DOULT     PCBREQ
     C                   Z-ADD     5700          PCBREQ
     C                   MOVEL(p)  'READ'        PCOPCD
     C                   EXSR      MG1092
     C                   ADD       PCBRET        PCSTOF

     C     PCBRET        IFNE      0
     C                   MOVEA     DTA           MLDTA
     C                   Z-ADD     PCBRET        MLDTLE
     C                   MOVEL(P)  'WRTATT'      MLOPCD
     C                   EXSR      SPMAIL
     C                   CLEAR                   MLDTA
     C                   ENDIF
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPYTIF        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'SPYTIF' : blnDebug )
      *          Call SPYTIF to put an image into UsrSpc QTEMP/TIFFNO

     C     IMGPAG        IFEQ      *BLANKS
     C                   MOVEL     '*ALL'        IMGPAG
     C                   END

     C                   MOVEL(P)  'TIFF'        TIFFNO            7

     C                   CALL      'SPYTIF'                             50
     C                   PARM      'FILEMANY'    @OPCOD           10
     C                   PARM      IDBNUM        @BTCH#           10
     C                   PARM      RQSPAG        @STRRN            9 0
     C                   PARM                    @RTNCD            7
     C                   PARM                    @RTNDT          100
     C                   PARM                    @MLTPG            1
     C                   PARM                    @PAGE#            9 0
     C                   PARM      IMGPAG        @PAGRN           50
     C                   PARM      USRSPC        @OUTTY           10
     C                   PARM      TIFFNO        @OUTOB           10
     C                   PARM      'QTEMP'       @OUTLI          100

     C     @RTNCD        IFNE      *BLANKS
     C     *IN50         OREQ      *ON
     C                   MOVEL     @RTNCD        @MSGID
     C                   MOVEL     @RTNDT        EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PRTIMG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'PRTIMG' : blnDebug )
      *          Call PRTIMGX, PRTIMGM

     C                   SELECT
     C     RQPTYP        WHENEQ    '*XI'
     C     RQPTYP        OREQ      '*PCL'
     C     RQPTYP        OREQ      '*AFP'

     C                   SELECT
     C     RQPTYP        WHENEQ    '*XI'
     C                   MOVE      'X'           OUTTYP
     C                   MOVEL     ASCSTM        SPCTYP
     C     RQPTYP        WHENEQ    '*PCL'
     C                   MOVE      'P'           OUTTYP
     C                   MOVEL     ASCSTM        SPCTYP
     C     RQPTYP        WHENEQ    '*AFP'
     C                   MOVE      'A'           OUTTYP
     C                   MOVEL     AFPSTM        SPCTYP
     C                   ENDSL
      * Duplex
     C     PRTDUP        IFEQ      *BLANK
     C     DUPLEX        IFEQ      '*YES'
     C                   MOVE      '1'           PRTDUP            1
     C                   ELSE
     C                   MOVE      '*'           PRTDUP
     C                   END
     C                   END
      * Papersize
     C                   SELECT
     C     PAPSIZ        WHENEQ    '*SYSDFT'
     C     PAPSIZ        OREQ      *BLANKS
     C     SPAPSZ        IFNE      *BLANKS
     C                   MOVE      SPAPSZ        PAPSIZ
     C                   ELSE
     C                   MOVEL     '*LETTER'     PAPSIZ
     C                   END
     C                   ENDSL
      * Orientation
     C     PRTORI        IFEQ      *BLANK
     C                   SELECT
     C     ORIENT        WHENEQ    @@PORT
     C                   MOVE      '0'           PRTORI            1
     C     ORIENT        WHENEQ    @@LAND
     C                   MOVE      '1'           PRTORI            1
     C                   OTHER
     C                   MOVE      '*'           PRTORI
     C                   ENDSL
     C                   END

/     * PRINTER DRAWER
/2322C     DRAWER        IFNE      *BLANKS
/    C                   MOVEL     DRAWER        PRTDRW
/    C                   ELSE
/    C                   MOVE      '*'           PRTDRW
/    C                   END

      * OvrPrtf for ASCII print File
     C     OPNASC        IFEQ      ' '
     C     RQPTYP        ANDNE     '*AFP'
     C                   EXSR      OVRASC
     C                   MOVE      '1'           OPNASC            1
     C                   END

      * Create Image Coverpage USRSPC
/6763c                   eval      prttxl = 0
/6763C     CVRPAG        IFNE      '*NONE'
     C                   SELECT
     C     CVRMBR        WHENEQ    '*SYSDFT'
     C     CVRMBR        OREQ      *BLANKS
     C                   MOVE      SCVRPG        PRMMBR
     C     CVRMBR        WHENEQ    '*NONE'
     C                   MOVE      *BLANKS       PRMMBR
     C                   OTHER
     C                   MOVE      CVRMBR        PRMMBR
     C                   ENDSL
      *          Create UsrSpc with coverpage text
     C                   CALL      'SPYCVR'                             50
     C                   PARM                    PRMMBR           10
     C                   PARM      'QNDXSRC'     CVRFIL           10
     C                   PARM      PGMLIB        CVRLIB           10
     C                   PARM      'SPYCVR'      SPCNAM           10
     C                   PARM      'QTEMP'       SPCLIB           10
     C                   PARM                    CVRTXT
     C                   PARM                    CVRRTN            7
/6763 * Get number of cover page text lines
/    c                   if        cvrrtn = *blanks and
     c                             outtyp = 'P' and
/    c                             (%subst(cvrpag:1:4) = '*TOP' or
/    c                              %subst(cvrpag:1:4) = '*BOT')
/    c     spcnam        cat       spclib        tmpspc
/    C                   CALL      'QUSRTVUS'                           99
/    C                   PARM                    TMPSPC           20
/    C                   PARM      1             DTAOFS
/    C                   PARM      9             DTALEN
/    C                   PARM                    F9A               9
/    C                   MOVE      F9A           F90               9 0
/    c                   eval      prttxl = f90 / CVRRCL
/    c                   end
     C                   END
      *---------------------------------
      * Create USRSPC for a page of TIFF
      *---------------------------------
/2119C                   EXSR      GETEXT
/2119C     PCEXT         IFEQ      'TXT'
/2119C                   eval      spcnam = 'TEXTFILE'
/2119C                   ENDIF
     C                   EXSR      CVTTIF

     C                   SELECT
     C     PCEXT         WHENEQ    'AFP'
     C                   CALL      'SPC2PRT'     PLSTRM                 50

      *-----------------------------------
      * Process Text for Fax
      *-----------------------------------
/2119C     PCEXT         WHENEQ    'TXT'

/    C     CVRPAG        IFEQ      '*BEFORE'
/    C                   EXSR      SRICVR
/    C                   END
/     *  IF NO CVRPAG AFTER THIS IMAGE AND TOTAL NUMBER
/     *  OF IMAGES REACHED, GO AHEAD AND ISSUE *FILEEND
/    C     CVRPAG        IFNE      '*AFTER'
/    C                   MOVE      '*'           PRTRST
/    C                   END

/2119C                   exsr      FAXTXT

/     *-----------------------------------
/     * Print 1 coverpage after all images
/     *-----------------------------------
/    C     PRT1CP        IFEQ      'Y'
/    C     CVRPAG        ANDEQ     '*AFTER '
/    C                   MOVE      '*'           PRTRST
/    C                   EXSR      SRICVR
/    C                   END

     C     PCEXT         WHENEQ    'TIF'
/3307C     PCEXT         OREQ      'TIFF'
     C     PCEXT         OREQ      'IMG'
      *-------------------
      * Loop for each page
      *-------------------
     c                   eval      prtrst = '0'
     c                   eval      prtff = '*'
     c                   if        %subst(cvrpag:1:4) = '*BOT'
     c                   eval      prttxl = -prttxl
     c                   endif

     C                   Z-ADD     0             COUNT             9 0

     C     0             DO        999           FIL#              3 0
      * Next UsrSpc name (CURRENT +1)
     C     FIL#          ADD       1             F30               3 0
     C                   MOVE      F30           F3A               3
     C     'TIFF'        CAT(P)    F3A:0         NXTNAM           10
      * Does another page exist?
     C                   EXSR      CHKNXT
      ****       NXTOK     IFEQ '0'
      ****                 LEAVE                           No
      ****                 END
      * UsrSpc name
     C                   MOVE      FIL#          F3A               3
     C     'TIFF'        CAT(P)    F3A:0         TIFNAM           10

     C                   ADD       1             COUNT

     c                   if        cvrpag = '*BEFORE' and
     c                              (count = 1 or prt1cp <> 'Y')
     C                   EXSR      SRICVR
     C                   END

     c                   select
     c                   when      (%subst(cvrpag:1:4) = '*TOP' or
     c                              %subst(cvrpag:1:4) = '*BOT')
     c                   if        count = 1 or %subst(cvrpag:5:2) <> 'P1'
     c                   eval      prtff = '0'
     c                   else
     c                   eval      prttxl = 0
     c                   endif

      *  IF NO CVRPAG AFTER THIS IMAGE AND TOTAL NUMBER
      *  OF IMAGES REACHED, GO AHEAD AND ISSUE *FILEEND
     c                   when      cvrpag <> '*AFTER'
     c                   if        nxtok = '0' and entprc >= entcnt
     c                   eval      prtrst = '*'
     c                   endif
     c                   endsl

      *  -----------------------------------------
      *   Output the TIFF USRSPC to ASCII Format USRSPC
      *   For AFP write to putsplf output file directly
      *  -----------------------------------------

     C                   CALL      'MAG920'                             50
     C                   PARM      *ON           PRTASC            1
     C                   PARM      IDBNUM        BTCHNO           10
     C                   PARM      RQSPAG        STROFS            9 0
     C                   PARM      TIFNAM        INOBJ            10
     C                   PARM      'QTEMP'       INLIB            10
     C                   PARM      'USRASCII'    OUTFIL           10
     C                   PARM      'QTEMP'       OUTLIB           10
     C                   PARM      '2'           OUTOBJ            1
     C                   PARM                    OUTTYP            1
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM                    PRTINZ            1
     C                   PARM                    PAPSIZ           10
     C                   PARM                    PRTFF             1
     C                   PARM                    PRTRST            1
     C                   PARM                    PRTDUP            1
     C                   PARM                    PRTORI            1
/2322C                   PARM                    PRTDRW            4
/6763C                   PARM                    PRTTXL            3 0

     C                   MOVE      '0'           PRTINZ

     C     RTNCDE        IFNE      *BLANKS
     C                   MOVEL     RTNCDE        @MSGID
     C                   MOVE      *BLANKS       EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   END

      * Copy UserSpace to Printer output
     C                   CALL      'SPC2PRT'     PLSTRM                 50

     C                   MOVE      *ON           PRTASC            1

      * Delete QTemp/TIFFxxxxxx UsrSpc
     C     DLTSPC        CAT(P)    TIFNAM:0      CMDLIN
     C                   EXSR      RUNCL
     C                   EXSR      RMVMSG

      * Print Coverpage after each image page
     c                   eval      prtff = '*'
     c                   if        (cvrpag = '*AFTER' and prt1cp <> 'Y') or
     c                             ((%subst(cvrpag:1:4) = '*TOP' or
     c                               %subst(cvrpag:1:4) = '*BOT') and
     c                              (count = 1 or
     c                               %subst(cvrpag:5:2) <> 'P1'))
     C     NXTOK         IFEQ      '0'
     C     ENTPRC        ANDGE     ENTCNT
     C                   MOVE      '*'           PRTRST
     C                   END
     C                   EXSR      SRICVR
     C                   END
     C     NXTOK         IFEQ      '0'
     C                   LEAVE
     C                   END
     C                   ENDDO
     C                   ENDSL
      *-----------------------------------
      * Print 1 coverpage after all images
      *-----------------------------------
     C     PRT1CP        IFEQ      'Y'
     C     CVRPAG        ANDEQ     '*AFTER '
     C     NXTOK         IFEQ      '0'
     C     ENTPRC        ANDGE     ENTCNT
     C                   MOVE      '*'           PRTRST
     C                   END
     C                   EXSR      SRICVR
     C                   END
     C                   ENDSL
     C                   ENDSR
/2119 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/ "  C     GETEXT        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'GETEXT' : blnDebug )
/ "   *          Create USRSPC for each page of tiff
/ "
/ "   * Check attributes
/ "  C                   MOVEL     'GETATR'      PCOPCD           10
/ "  C                   MOVEL     IDBNUM        PCBTCH           10
/ "  C                   Z-ADD     RQSPAG        PCIRRN            9 0
/ "  C                   EXSR      MG1092
/ "  C     LO:UP         XLATE     PCEXT         PCEXT
/ "
/ "  C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CVTTIF        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CVTTIF' : blnDebug )
      *          Create USRSPC for each page of tiff

      * Check attributes
     C                   MOVEL(p)  'GETATR'      PCOPCD           10
     C                   MOVEL     IDBNUM        PCBTCH           10
     C                   Z-ADD     RQSPAG        PCIRRN            9 0
     C                   EXSR      MG1092
     C     LO:UP         XLATE     PCEXT         PCEXT

     C                   SELECT
     C     PCEXT         WHENEQ    'TIF'
/3307C     PCEXT         OREQ      'TIFF'
     C     PCEXT         OREQ      'IMG'
     C     PCEXT         OREQ      *BLANKS
      * Get page of multi-page tiff
     C                   EXSR      SPYTIF
     C     PCEXT         WHENEQ    'AFP'
     C                   EXSR      GETAFP
/2119C     PCEXT         WHENEQ    'TXT'
/2119C                   EXSR      GETTXT
     C                   OTHER
     C                   MOVEL     'IMG0033'     @MSGID
     C                   MOVE      *BLANKS       EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   ENDSL

     C                   ENDSR
/2119 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2119C     GETTXT        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'GETTXT' : blnDebug )

     C** Get text file and put into a user space
/    C                   CALL      'MAG921'
/    C                   PARM                    PCBTCH           10
/    C                   PARM                    PCIRRN            9 0
/    C                   PARM      'USRASCII'    SPCNAM           10
/    C                   PARM      'QTEMP'       SPCLIB           10
/    C                   PARM      '2'           OUTOBJ            1
/    C                   PARM      'TXT'         OUTTP3            3
/    C                   PARM                    SPCRTN            7

     C** Get Data Length
/    C                   eval      usrspcn = SPCNAM + SPCLIB
/    C                   eval      usrspcl = %size(dataLenA)
/    C                   eval      usrspcdP = %addr(dataLenA)
/    C                   eval      usrspcs = 1

/    C                   exsr      $RtvUs

     C** Retrieve pointer to User Space
/    C                   CALL      'QUSPTRUS'
/    C                   parm                    usrspcn
/    C                   parm                    usrspcdP

/    C** Convert ASCII to EBCDIC (ignore first 9 bytes - length)
/    c                   callp     xlateA2E(usrspcdP+9:datalen-9)

     C                   ENDSR
/2119 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2119C     $RtvUs        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'SRTVUS' : blnDebug )

     C**  Retrieve User Space
/ "  C                   CALL      'QUSRTVUS'
/ "  C                   parm                    usrspcn          20
/ "  C                   parm                    usrspcs
/ "  C                   parm                    usrspcl
/ "  C                   parm                    usrspcd
/ "  C                   parm                    qusec

     C                   ENDSR
/2119 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2119C     FAXTXT        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FAXTXT' : blnDebug )

/3139 * Open and create printer file
/3139C     OPENED        IFNE      *ON
/3139C                   EXSR      OPN#RP
/3139C                   MOVE      *ON           OPENED
/3139C                   END

/    C                   if        cvrdon <> *on
/    C                   EXSR      FAXCVR
/    C                   endif
/    C
/    C*  create new page
/    C                   except    NEWPAG

/    C*  Retrieve data from User Space
/    C                   eval      usrspcn = SPCNAM + SPCLIB
/    C                   eval      usrspcdP = %addr(SpcDataA)
/    C                   eval      usrspcs = 10

/    C                   if        (datalen - 9) <= 75
/    C                   eval      usrspcl = (datalen-9)
/    C                   else
/    C                   eval      usrspcl = 75
/    C                   endif

/    C*  Process User space in 75 bytes (to fit on a single line)
/    C                   dou       usrspcs >= (datalen+9)
/    C
/    C                   exsr      $RtvUs

/    C*  Print Field Name and Value
/2119C                   eval      rc2247 = %subst(SpcData:1:usrspcl)
/5469c                   callp     SplLine(' ':rc2247)

/    C*  Set Starting position for next 75 read from user space
/    C                   eval      usrspcs = usrspcs + usrspcl

/2119C*  Set User space retrieval if last record.
/2119C                   if        (datalen + 9) < (usrspcs + usrspcl)
/2119C                   eval      usrspcl = ((datalen+9) - usrspcs)
/2119C                   end
/    C
/    C                   enddo
/    C
/2119C                   MOVE      '1'           TXTIMG            1

/    C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETAFP        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'GETAFP' : blnDebug )

     C                   CALL      'MAG921'      PL921
     C     PL921         PLIST
     C                   PARM                    PCBTCH           10
     C                   PARM                    PCIRRN            9 0
     C                   PARM      'USRASCII'    SPCNAM           10
     C                   PARM      'QTEMP'       SPCLIB           10
     C                   PARM      '2'           OUTOBJ            1
     C                   PARM      'AFP'         OUTTP3            3
     C                   PARM                    SPCRTN            7

     C                   MOVE      *ON           PRTAFP            1

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKNXT        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CHKNXT' : blnDebug )
      *          Check existence of next UsrSpc for image print

     C     CHKSPC        CAT(P)    NXTNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL

     C     *IN81         IFEQ      *ON
     C                   EXSR      RMVMSG
     C                   MOVE      '0'           NXTOK             1
     C                   ELSE
     C                   MOVE      '1'           NXTOK
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OVRASC        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'OVRASC' : blnDebug )
      *          OvrPrtF for PrtImgx printer file

     C     'OVRPRTF'     CAT(P)    'FILE(P':1    CMDLIN
     C                   CAT       'RTIMGX':0    CMDLIN
     C                   CAT       ')':0         CMDLIN

     C     RPTNAM        IFNE      *BLANKS
     C                   CAT       'SPLFNA':1    CMDLIN
     C                   CAT       'ME(':0       CMDLIN
     C                   CAT       RPTNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C                   SELECT
     C     OUTQ          WHENNE    *BLANKS
     C                   CAT       'OUTQ(':1     CMDLIN
     C     OUTQL         IFNE      *BLANKS
     C                   CAT       OUTQL:0       CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   END
     C                   CAT       OUTQ:0        CMDLIN
     C                   CAT       ')':0         CMDLIN
     C     WRITER        WHENNE    *BLANKS
     C                   CAT       'DEV(':1      CMDLIN
     C                   CAT       WRITER:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   ENDSL

     C     COPIES        IFNE      0
     C                   CAT       'COPIES':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   MOVE      COPIES        F3A               3
     C                   CAT       F3A:0         CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C                   CAT       'USRDTA':1    CMDLIN
     C                   CAT       '(''':0       CMDLIN
/8632c                   eval      CmdLin=%trimr(CmdLin)+%trim(dblqte(Rptud))
     C                   CAT       ''')':0       CMDLIN

     C     OUTFRM        IFNE      *BLANKS
     C                   CAT       'FORMTY':1    CMDLIN
     C                   CAT       'PE(''':0     CMDLIN
/8632c                   eval      CmdLin=%trimr(CmdLin)+%trim(dblqte(OutFrm))
     C                   CAT       ''')':0       CMDLIN
     C                   END

     C                   eval      cmdlin = %trim(cmdlin) +  ' OVRSCOPE(*JOB)'
     C                   EXSR      RUNCL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FAXIMG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FAXIMG' : blnDebug )
      *          Write fax image to IFS, using Mag1090

     C                   ADD       1             IMG#              3 0
      *-----------
      * Setup EDIR for Mag1090 e.g. '/QDLS/FAXSTAR/D990930/J123456/'
      *-----------
     C     IMG#          IFEQ      1
     C                   SELECT
     C     FAXTYP        WHENEQ    '1'
     C                   MOVEL(P)  'FAXSTAR'     FXROOT           15
     C     FAXTYP        WHENEQ    '4'
     C                   MOVEL(P)  'FASTFAX'     FXROOT
     C     FAXTYP        WHENEQ    '6'
     C                   MOVEL(P)  'DF400TIF'    FXROOT
     C     FAXTYP        WHENEQ    '8'
     C                   MOVEL(P)  'FAXSVR'      FXROOT
/6924c                   when      faxtyp = 'B'
/    c                   eval      fxroot = 'FAXCOM'
     C                   ENDSL
      * Delete old faxes
     C                   EXSR      CHKDLT
     C     FXROOT        CAT(P)    '/':0         FXDIR            80
     C                   CAT       'D':0         FXDIR
     C                   MOVEL     UYEAR         F2A
     C                   CAT       F2A:0         FXDIR
     C                   MOVEL     UMONTH        F2A
     C                   CAT       F2A:0         FXDIR
     C                   MOVEL     UDAY          F2A               2
     C                   CAT       F2A:0         FXDIR
     C                   CAT       '/J':0        FXDIR
     C                   CAT       JNR:0         FXDIR
     C                   MOVEL(P)  FXDIR         EDIR8            80
     C                   CAT       '/':0         FXDIR
      * FaxStar now supports writing to IFS instead of QDLS
J3218c                   if        faxtyp = '1' and LNOQDLS = 'Y'
J3218c                   eval      edir = '/' + %trim(fxdir)
J3218c                   else
     C     '/QDLS/'      CAT(P)    FXDIR:0       EDIR
J3218c                   endif

      * Get the next outfile seq number
     C                   EXSR      GETFX#
     C                   END

     C                   MOVE      'Y'           CL1090            1
     C                   MOVE      ' '           ECLSP
      *------------------------------------
      * Create USRSPC for each page of tiff
      *------------------------------------
/2119C                   EXSR      GETEXT
/2119C*
/2119C     PCEXT         IFEQ      'TXT'
/2119C                   eval      spcnam = 'TEXTFILE'
/2119C                   ENDIF

     C                   EXSR      CVTTIF
/2119 *
/    C                   select
/2119C     PCEXT         wheneq    'TXT'
/    C                   ADD       1             #TI               5 0
/2119C                   exsr      FAXTXT

/2119C                   OTHER

     C     0             DO        999           FILIDX            3 0
      * Name the userspace
     C                   MOVE      FILIDX        F3A               3
     C     'TIFF'        CAT(P)    F3A:0         NXTNAM           10
      * Check if pages exist
     C                   EXSR      CHKNXT
     C     NXTOK         IFEQ      '0'
     C                   LEAVE
     C                   END

     C                   MOVEL(P)  NXTNAM        TMPSPC
     C                   MOVEL(P)  'QTEMP'       F10A             10
     C                   MOVE      F10A          TMPSPC
      * Get image size
     C                   CALL      'QUSRTVUS'                           99
     C                   PARM                    TMPSPC           20
     C                   PARM      1             DTAOFS
     C                   PARM      9             DTALEN
     C                   PARM                    F9A               9

     C                   MOVE      F9A           F90               9 0
     C                   Z-ADD     F90           BYTREM            9 0
     C                   ADD       1             FIL#

      * Format EFILE, outfile name

     C                   MOVE      FIL#          F3A               3
     C                   SELECT
     C     FAXTYP        WHENEQ    '1'
     C     FTCP          IFNE      'Y'
     C                   MOVEL(P)  FAXSEQ        EFILE
     C                   CAT       '.':0         EFILE
     C                   CAT       F3A:0         EFILE
     C                   ELSE
     C     3             SUBST(P)  FAXSEQ:4      EFILE
     C                   CAT       F3A:0         EFILE
     C                   CAT       '.TIF':0      EFILE
     C                   ENDIF
     C     FAXTYP        WHENEQ    '4'
     C     3             SUBST(P)  FAXSEQ:4      EFILE
     C                   CAT       F3A:0         EFILE
     C                   CAT       '.GP4':0      EFILE
     C                   OTHER
     C     3             SUBST(P)  FAXSEQ:4      EFILE
     C                   CAT       F3A:0         EFILE
     C                   CAT       '.TIF':0      EFILE
     C                   ENDSL
      * Write file to QDLS
     C                   Z-ADD     10            DTAOFS

     C     BYTREM        DOULE     0

      * Get space data
     C     BYTREM        IFLT      131072
     C                   Z-ADD     BYTREM        DTALEN
     C                   ELSE
     C                   Z-ADD     131072        DTALEN
     C                   END

     C                   CALL      'QUSRTVUS'                           99
     C                   PARM                    TMPSPC           20
     C                   PARM                    DTAOFS
     C                   PARM                    DTALEN
     C                   PARM                    DTA
      * Calc file pointers for next read
     C                   SUB       DTALEN        BYTREM
     C                   ADD       DTALEN        DTAOFS
      * Write data to ifs
     C                   CLEAR                   ECLSP
/2904c                   z-add     dtalen        dtasiz
     C                   CALL      'MAG1090'     PL1090
     C     PL1090        PLIST
     C                   PARM      *BLANKS       EDRV             15
     C                   PARM      '*IFS'        EVOL             12
     C                   PARM                    EALLOC           13 0
     C                   PARM                    EDIR             80
     C                   PARM                    EFILE            10
     C                   PARM      '*NOMAX'      EFILSZ           13
     C                   PARM                    DTA
/2904C                   PARM                    DTASIZ            6 0
     C                   PARM                    ECLSP             1
     C                   PARM                    ERTN              1
     C                   ENDDO
      * Shut down 1090
     C                   MOVE      *ON           ECLSP
     C                   Z-ADD     0             DTASIZ
     C                   CALL      'MAG1090'     PL1090

      * Delete UsrSpc
     C     DLTSPC        CAT(P)    NXTNAM:0      CMDLIN
     C                   EXSR      RUNCL
     C                   EXSR      RMVMSG

     C                   MOVE      MSG(1)        @MSGID
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        HEX               1

     C                   MOVE      MSG(2)        @MSGID
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        HEXCIR            1

     C                   ADD       1             #TI               5 0

     C     FAXTYP        IFEQ      '8'
     C                   MOVEL(P)  EFILE         XF(#TI)
     C                   ELSE

     C     FTCP          IFNE      'Y'
     C     FXDIR         CAT(P)    EFILE:0       XF(#TI)
     C                   ELSE
      * NOTE: FAXSTAR NEEDS ONLY 1 FILE ATTACHMENT.
      *       IT WILL PICKUP "RELATED" IMAGE FILES BASED ON PATH
     C     ONLY1         IFNE      'Y'
     C                   MOVE      'Y'           ONLY1             1
     C     EDIR          CAT(P)    EFILE:0       XF(#TI)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     FAXTYP        IFNE      '4'
     C     FAXTYP        ANDNE     '8'
     C     FAXTYP        ANDNE     '1'
     C     FAXTYP        OREQ      '1'
     C     FTCP          ANDNE     'Y'
     C     '/':HEX       XLATE     XF(#TI)       XF(#TI)
     C                   ENDIF
     C                   ENDDO
/2119C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     IFSIMG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'IFSIMG' : blnDebug )
      *          Write image to IFS, using SPYIFS

     C                   ADD       1             IMG#
      * Open output file
J2470C                   If        blnTXTPDF = FALSE
     C                   MOVEL     '*NONE'       TOCCS
J2470C                   EndIf

     C                   EXSR      OPNIFS
J2470 * Now that the file is created with 819 ( The correct CCSID )
/     * Keep the ASCII data by changing the CCSID back to NONE
/    C                   MOVEL     '*NONE'       TOCCS

      * For each 131,072 bytes, read & write
     C                   MOVEL(P)  'WRITE'       IFOPCD
     C                   Z-ADD     131072        PCBREQ
     C                   Z-ADD     0             PCSTOF
      *  Read
t7485c                   dou       pcstof = pcisiz
     C                   MOVEL(p)  'READ'        PCOPCD
     C                   EXSR      MG1092
      *  Write
     C     PCBRET        IFNE      0
/3393C     PCRTNC        andeq     *BLANKS
/3393C     *IN50         andeq     *Off
/3393C     IgnBatch      andeq     'Y'
/3393C     PCBRET        orNE      0
/3393C     IgnBatch      andeq     'N'
     C                   Z-ADD     PCBRET        DTALEN
     C                   CALL      'SPYIFS'      PLIFS
     C     PLIFS         PLIST
     C                   PARM                    IFOPCD           10
     C                   PARM                    IFPATH          256
     C                   PARM                    DTA
     C                   PARM                    DTALEN
     C                   PARM                    FRMCCS            5
     C                   PARM                    TOCCS             5
     C                   PARM                    IFSRTN            7

     C     IFSRTN        IFNE      *BLANKS
/2423C                   MOVE      IFSRTN        @MSGID
/2423c                   callp     $EXPMSG
     C                   MOVEL(P)  'QUIT'        IFOPCD
     C                   CALL      'SPYIFS'      PLIFS
     C                   EXSR      QUIT
     C                   END

     C                   ADD       PCBRET        PCSTOF
     C                   END
     C                   ENDDO
/    C                   MOVEL(P)  'CLSOPT'      PCOPCD
/    C                   EXSR      MG1092

     C                   MOVEL(P)  'QUIT'        IFOPCD
     C                   CALL      'SPYIFS'      PLIFS
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     UPDSPC        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'UPDSPC' : blnDebug )
      *  COUNT NUMBER OF FILES AND PASS NUMBER TO SPYEXPSPC

     C                   MOVEL     IFPATH        SPCPTH
     C                   MOVEL     'UPDDOC'      SPCOPC
     C                   ADD       1             UPDSEQ            9 0
     C                   Z-ADD     UPDSEQ        SPCSEQ
     C                   CALL      SPYSPC        PLSPC                  50

     C                   MOVE      '1'           OPNSPC            1

     C                   ENDSR

     C     PLSPC         PLIST
     C                   PARM                    SPCOPC           10
     C                   PARM                    SPCOBJ           10
     C                   PARM      '*SPYLINK'    SPCTYP           10
     C                   PARM      *BLANKS       SPCSEG           10
     C                   PARM                    DTS
     C                   PARM                    SPCFRM            8
     C                   PARM                    SPCTO             8
     C                   PARM                    SPCFMT           10
/2930c                   parm                    ToCdePag
     C                   PARM                    SPCJOI            1
     C                   PARM                    SPCPTH          256
     C                   PARM                    SPCSPY           10
     C                   PARM                    SPCSEQ            9 0
     C                   PARM      IFREPL        SPCRPL            1
     C                   PARM                    SPCMSG            7
     C                   PARM                    SPCDTA          256
/3393c                   parm                    IgnBatch          1
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     IFSLIN        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'IFSLIN' : blnDebug )
      *          Write a report line to IFS, using SPYIFS

     C                   CAT       CRLF:0        MLRCD
     C                   MOVEA     MLRCD         DTA
     C     ' '           CHECKR    MLRCD         DTALEN
     C                   MOVEL(P)  'WRITE'       IFOPCD
     C                   CALL      'SPYIFS'      PLIFS
     C     IFSRTN        IFNE      *BLANKS
/2423C                   MOVE      IFSRTN        @MSGID
/2423c                   callp     $EXPMSG
     C                   MOVEL(P)  'QUIT'        IFOPCD
     C                   CALL      'SPYIFS'      PLIFS
     C                   EXSR      QUIT
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETFX#        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'GETFX#' : blnDebug )
      *          Get FAXSEQ, the next fax sequence number PER JOB
      *          6 byte, base36 (upto 2,176,782,336)

     C     *DTAARA       DEFINE    SPYFAXSEQ     FAXSEQ
     C                   IN        FAXSEQ
      * Init 0's
     C     FAXSEQ        IFEQ      *BLANKS
     C                   MOVE      B36(1)        FX#
     C                   ENDIF
      * Rgt to left
     C                   Z-ADD     6             F1                3 0

     C     F1            DOULE     0
     C     FCARRY        OREQ      '0'
     C                   Z-ADD     1             X1                3 0
     C     FX#(F1)       LOOKUP    B36(X1)                                10

     C     X1            IFGE      36
     C                   MOVE      '1'           FCARRY            1
     C                   Z-ADD     1             X1
     C                   ELSE
     C                   MOVE      '0'           FCARRY
     C                   ADD       1             X1
     C                   ENDIF

     C                   MOVE      B36(X1)       FX#(F1)
     C                   SUB       1             F1
     C                   ENDDO

     C                   OUT       FAXSEQ
     C                   ENDSR
J3613 //------------------------------------------------------------------------
/     /free
/      //------------------------------------------------------------------------
/       BegSr Do#NativePDF;
J2469     Callp(e)  SubMsgLog( blnDebug : 'Do#NativePDF' : blnDebug ) ;
/      //------------------------------------------------------------------------
/      //  This essentially replicates the code for email distribution, but
/      //------------------------------------------------------------------------
/         tgtPDFPath = %trim(mlTxt1) + %trim(mlTxt2);
/         pdfFileName = tgtPDFPath;
/
/         If ( %subst( tgtPDFPath : %len ( %trim( tgtPDFPath ) ) : 1 ) = '*' );
/           pdfFileName = %subst(pdfFileName:1:%len(%trim(pdfFileName)) - 1);
/           tgtPDFPath  =  %subst(pdfFileName:1:%len(%trim(pdfFileName)) - 1);
/         EndIf;
/
/
/         Select;
/           When IfRepl = REPLACE_YES;
/             pdfFileName = %trim( pdfFileName )
/                         + %trim(lFilNa) + '.pdf' + x'00';
/
/             If ( accessIFS(%trim(pdfFileName)+x'00' : F_OK ) = 0 );
/               unlinkIFS( %trim(pdfFileName) + x'00' );
/             EndIf;
/
/             tgtPDFFileName = %trim(lFilNa) + '.pdf';
/           When IfRepl = REPLACE_NO;
/             pdfFileName = %trim( pdfFileName )
/                         + %trim(lFilNa) + '.pdf';
/
/             If ( accessIFS(%trim(pdfFileName) + x'00' : F_OK ) = 0 );
/               LeaveSr;
/             EndIf;
/
/             tgtPDFFileName = %trim(lFilNa) + '.pdf';
/
/           When IfRepl = REPLACE_SEQ;
/             intPDFSeq += 1;
/             pdfFileName = %trim( pdfFileName )
/                         + %trim(lFilNa)
/                         + %editc( intPDFSeq : 'X' )
/                         + '.pdf';
/
/             tgtPDFFileName = %trim(lFilNa)
/                           + %editc( intPDFSeq : 'X' )
/                           + '.pdf';
/
/             DoW ( accessIFS(%trim(pdfFileName) + x'00' : F_OK ) = 0 );
/               intPDFSeq += 1;
/               tgtPDFFileName = %trim(lFilNa)
/                           + %editc( intPDFSeq : 'X' )
/                           + '.pdf';
/               pdfFileName = %trim( pdfFileName )
/                           + %trim(lFilNa)
/                           + %editc( intPDFSeq : 'X' )
/                           + '.pdf';
/             EndDo;
/
/         EndSl;
/
/         // Use the entries from the data queue to populate the
/         // paramaters for the call to PDFBufInit
/
/         frmPag = RQSPag;
/         toPage = RQEPag;
/         ExSr RenderPDFIFS;
          SpcPth = pdfFileName;
          SpcSeq = intPDFSeq;
          SpcTyp = '*SPYLINK';
/         OpnSpc = TRUE;
/         Callp(e) UpdateDoc( SPCOPC_UPDDOC : SpcObj  : SpcTyp : SpcSeg
                            : DTS     : SpcFrm  : SpcTo   : SpcFmt  : ToCdePag
                            : SpcJoi  : SpcPth : SpcSpy  : SpcSeq  : IFRePl
                            : SpcMsg  : SpcDta  : IgnBatch );
/       EndSr;
/       //------------------------------------------------------------------------
/       BegSr RenderPDFIFS;
/       //------------------------------------------------------------------------
J2469     Callp(e)  SubMsgLog( blnDebug : 'RenderPDFIFS' : blnDebug ) ;
/         rc = PDFBufInit(intFH:spynum:frmPag:toPage:intPDFSize:srcPDFPathFile);
/
/         If ( rc <> OK );
/           @MsgID =  'ERR9901';
            EMsgDT =  PDFGetLastError();
/           ExSr Quit;
/         EndIf;
/
/         // This returns a null terminated string for the filename
/         srcPDFPathFile = %str( %addr( srcPDFPathFile ));
/
/         cmdLin = 'MOV OBJ(' + Q + %trim(srcPDFPathFile) + Q + ') ' +
/                  'TODIR(' + Q + %trim(tgtPDFPath) + Q + ')';
/         ExSr RunCl;
/
/         If ( *in81 = *on );
/           LeaveSr;
/         EndIf;
/
/         intStart = RScan( '/' : srcPDFPathFile );
/
/         If ( intStart > 0 );
/           srcPDFFile = %subst( srcPDFPathFile : intStart + 1 );
/         Else;
/           srcPDFFile = srcPDFPathFile;
/         EndIf;
/
/         cmdLin = 'REN OBJ(' + Q + %trim(tgtPDFPath)
/                + '/' + %trim(srcPDFFile) + Q
/                + ') NEWOBJ(' + Q + %trim(tgtPDFFileName) + Q + ')';
/         ExSr RunCl;
/
/         If ( *in81 = *on );
/           LeaveSr;
/         EndIf;
/
/         PDFBufQuit(intFH);
/         intFH = 0;
/       EndSr;
/     /end-free
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DO#RPT        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'DO#RPT' : blnDebug )
      *          Process one report (or distr segment)
/5469c                   eval      djdeStart = *blanks
     C                   CLEAR                   FSTOVR
/6921 /free
/6921  // if we are preparing to send an email thru SpoolMail then
/6921  //  get the Attributes from the Folder file and determine
/6921  //  if the report type (*SCS, *LINE, *AFPDS etc...) is
/6921  //  supported by SpoolMail.  If not then set flags to
/6921  //  send the email thru our internal email process.

J2469       rc=getArcAtr(SpyNum:%addr(Qusa0200): %size(Qusa0200):3);

J5953       If (   IsSplMail = 'S'                                        ) or
/6921       // if (   mlspml = 'S'                                        ) or
J2469          ( ( mlfmt = PDF_FMT ) and ( quspdt00 =  PRTTY_AFPDS     ) ) or
J2469          ( ( mlfmt = PDF_FMT ) and ( quspdt00 =  PRTTY_AFPDSLINE ) ) or
J2469          ( ( mlfmt = PDF_FMT ) and ( quspdt00 =  PRTTY_IPDS      ) );
J2469
/6921          rc=getArcAtr(SpyNum:%addr(Qusa0200): %size(Qusa0200):3);
/6921
/6921          if ( rc = #SPL_OK );
/6921
i6921  // check for supported SPOOLMAIL file types
       //
/6865  // Enable the use of Spool Mail only for the use of
/      // *AFPDS or *IPDS spooled files requiring a text
/      // conversion.
J2469            Select;
/                  When ( mlfmt  = PDF_FMT     )  and
J2469                   ( blnNativePDF = FALSE )  and
/                       ( ( quspdt00 = PRTTY_AFPDS     ) or
/                         ( quspdt00 = PRTTY_AFPDSLINE ) or
/                         ( quspdt00 = PRTTY_IPDS      )        );
/                     blnNativeEmailAFP = TRUE;
/                     @Dest  = 'P';
/                  When ( mlfmt  = PDF_FMT     )            and
J5953                   ( isSplMail = 'S'      )            and
J2469                   ( @dest  = 'P'         )            and
/                       ( blnNativePDF = FALSE )            and
/                       ( ( quspdt00 = PRTTY_AFPDS     ) or
/                         ( quspdt00 = PRTTY_AFPDSLINE ) or
/                         ( quspdt00 = PRTTY_IPDS      )        );
/                     MlSpMl = 'S'; // Spool Mail
/                     @Dest  = 'P';
J4819         //    Other;
J4819         //      MlSpMl = ' '; // Native Mail
J4819         //      @dest  = 'M';
J2469             EndSl;
/
/     /end-free
/6921c                   endif
/6921c                   endif
     C     SVOBTY        IFNE      'I'
     C     RQOBTY        OREQ      'R'
     C                   OPEN      MRPTDIR7
     C     SPYNUM        CHAIN     RPTDIR                             50
     C     *IN50         IFEQ      *ON
     C                   MOVEL     'ERR0157'     @MSGID
     C                   MOVE      *BLANKS       EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   END

/8528 * pick up outq and outq lib from MRPTDIR if *RPTCFG specified
/8528c                   if        OUTQ = '*RPTCFG'
/8528c                   eval      outq = outqnm
/8528c                   eval      outql = outqlb
/8528c                   endif
     c
     C                   CLOSE     MRPTDIR7
     C                   END

     C                   CLEAR                   PGBEG
     C                   CLEAR                   PGEND
     C                   ADD       1             NBRJOI            5 0

      * If this is not a coverpage for image faxing
      *   get attributes to support *ORIG value for PARMS

     C     CRTCVR        IFNE      *ON
     C     FILLOC        IFNE      '1'
     C     FILLOC        ANDNE     '2'
     C     FILLOC        ANDNE     '4'
     C     FILLOC        ANDNE     '5'
     C     FILLOC        ANDNE     '6'
     C                   EXSR      OPNFLD
     C   81              GOTO      ENDPRT
     C                   END

     C     CRTCVR        IFNE      *ON
     C                   EXSR      REDATR
     C                   END

     C     RPTNAM        IFEQ      *BLANKS
     C     RPTNAM        OREQ      '*ORIG'
     C                   MOVE      @FILNA        RPTNAM
     C                   END
     C                   END

     C     RPTNAM        IFEQ      *BLANKS
     C                   MOVEL     'SPYVIEW'     RPTNAM
     C                   END

/2330C                   MOVEA     RPTNAM        SVD
     C     #             DOUEQ     0
     C     '-'           SCAN      RPTNAM        #                 2 0
     C     #             IFEQ      0
     C                   LEAVE
     C                   END
     C                   MOVE      '#'           SVD(#)
     C                   MOVEA     SVD           RPTNAM
     C                   ENDDO

/2680C                   MOVEA     RPTNAM        SVD
     C     #             DOUEQ     0
     C     X'4A'         SCAN      RPTNAM        #                 2 0
     C     #             IFEQ      0
     C                   LEAVE
     C                   END
     C                   MOVE      '#'           SVD(#)
     C                   MOVEA     SVD           RPTNAM
     C                   ENDDO

     C     CRTCVR        IFNE      *ON

     C     TOPAGE        IFLT      0
     C                   Z-SUB     TOPAGE        #TOPRT            9 0
     C                   Z-ADD     9999999       TOPAGE
     C                   ELSE
     C                   Z-ADD     9999999       #TOPRT
     C                   END

     C                   MOVE      $WSC          CWSC
     C                   MOVE      $WW           CWW
     C                   Z-ADD     FRMCL#        FRMCOL            3 0
     C                   Z-ADD     TOCOL#        TOCOL             3 0

     C     HCMPRS        IFNE      '1'
     C     PLCSFP        SUB       PLCSFD        #MXRRN           10 0
     C                   END

     C     PRTWND        IFEQ      'y'
     C                   MOVE      *ON           UPGTBL            1
     C                   MOVE      'Y'           PRTWND
     C                   ELSE
     C                   MOVE      *OFF          UPGTBL
     C                   END

     C     PRTWND        IFEQ      'n'
     C                   MOVE      *ON           UPGTBL
     C                   MOVE      'N'           PRTWND
     C                   END

     C                   MOVE      HCMPRS        COMPRS
     C                   Z-ADD     @FILNU        MAGFLN            9 0

     C     UPGTBL        IFEQ      *ON
     C                   OPEN      MRPTDIR7
     C     SPYNUM        CHAIN     RPTDIR                             50
     C     *IN50         IFEQ      *ON
     C                   MOVEL     'ERR0157'     @MSGID
     C                   MOVE      *BLANKS       EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   END
     C                   CLOSE     MRPTDIR7

     C                   OPEN      RSEGMNT

      * Set up BGREC, the number of records in RSEGMNT for this report.
      *  (Go beyond the end, read prior, use the seq. no.)

     C     PGKEY         KLIST
     C                   KFLD                    REPIND
     C                   KFLD                    SGSEQ
     C                   MOVEL     9999999       SGSEQ
     C     PGKEY         SETLL     RSEGMNT
     C                   READ      RSEGMNT                                66
     C   66*HIVAL        SETGT     RSEGMNT

     C                   READP     RSEGMNT                                66
     C                   Z-ADD     SGSEQ         BGREC             9 0
     C                   Z-ADD     1             SGSEQ
     C     PGKEY         CHAIN     RSEGMNT                            66
     C     PPT(1)        CABEQ     0             ENDPRT
     C                   Z-ADD     PPT(1)        #FRSTP            9 0

      * Get the last record to load #LASTP, the last page.
     C     BGREC         IFNE      1
     C                   Z-ADD     BGREC         SGSEQ
     C     PGKEY         CHAIN     RSEGMNT                            66
     C                   END

      * #T points to the last PPT element with a page no.
     C     PPT(63)       IFEQ      0
     C                   DO        63            #T
     C     PPT(#T)       IFEQ      0
     C                   SUB       1             #T
     C                   LEAVE
     C                   END
     C                   ENDDO
     C                   ELSE
     C                   Z-ADD     63            #T
     C                   END

     C                   Z-ADD     PPT(#T)       #LASTP            9 0
     C                   Z-ADD     PPT(1)        PTBEG             9 0
     C                   Z-ADD     PPT(#T)       PTEND             9 0

      * How many pages?
     C     BGREC         SUB       1             #OFPP             9 0
     C                   MULT      63            #OFPP
     C                   ADD       #T            #OFPP
     C                   Z-ADD     BGREC         #PPTRR

     C                   SELECT
     C     FRMPAG        WHENLE    #FRSTP
     C                   Z-ADD     #FRSTP        FRMPAG
     C     FRMPAG        WHENGE    #LASTP
     C                   Z-ADD     #LASTP        FRMPAG
     C                   OTHER
     C                   Z-ADD     FRMPAG        PAG#
     C                   EXSR      PAGCHK

     C     PAG#          IFEQ      0

     C                   SELECT
     C     PTBEG         WHENGT    FRMPAG
     C                   Z-ADD     PTBEG         FRMPAG
     C     PTEND         WHENLT    FRMPAG
     C                   ADD       1             #PPTRR
     C                   EXSR      LODPPT
     C                   Z-ADD     PTBEG         FRMPAG

     C                   OTHER
     C                   DO        63            #T
     C     PPT(#T)       IFGT      FRMPAG
     C                   Z-ADD     PPT(#T)       FRMPAG
     C                   LEAVE
     C                   END
     C                   ENDDO

     C                   ENDSL
     C                   END
     C                   ENDSL

     C     FRMPAG        CABGT     TOPAGE        ENDPRT
     C                   END
     C                   END

     C     OUTFRM        IFEQ      '*ORIG'
     C                   MOVE      @FRMTY        OUTFRM
     C                   END

     C     RPTUD         IFEQ      '*ORIG'
     C                   MOVE      @USRDT        RPTUD
     C                   END

     C     FRMPAG        IFEQ      0
     C                   Z-ADD     1             FRMPAG
     C                   END

     C     TOPAGE        IFEQ      0
      *******    TOPAGE    ORGT @TOTPA                     DON'T TAKE TOT PAGES
     C     TOPAGE        ORGT      TOTPAG
     C     FRMPAG        ORGT      TOPAGE
/8989C                   Z-ADD     TOTPAG        TOPAGE
     C                   END

     C     TOCOL         IFEQ      0
     C     TOCOL         ORGT      @PAGWI
     C                   Z-ADD     @PAGWI        TOCOL
     C                   END
     C     TOCOL         IFGT      247
     C                   Z-ADD     247           TOCOL
     C                   END

     C     FRMCOL        IFEQ      0
     C     FRMCOL        ORGT      TOCOL
     C                   Z-ADD     1             FRMCOL
     C                   END

     C     COPIES        IFEQ      0
     C                   Z-ADD     1             COPIES
     C                   END
     C     COPIES        IFEQ      999
     C                   Z-ADD     @CPYS         COPIES
     C                   END

     C     FAXTYP        IFEQ      '3'
     C     FAXTYP        OREQ      '4'
     C     FAXLPA        IFEQ      *BLANKS
     C                   Z-ADD     0             FAXLPP
     C                   END
     C     @DEST         IFEQ      'F'
     C     FAXLPP        ANDNE     0
     C                   Z-ADD     FAXLPP        RPTLPP            3 0
     C                   ELSE
     C                   Z-ADD     @PAGLE        RPTLPP
     C                   END
     C                   END
/6865 /free
J5953                    if ( ( IsSplMail = SPLMAIL              ) and
J5953                 // If ( ( mlSpMl = SPLMAIL                 ) and
J4819                         ( ( @Prtty = PRTTY_AFPDS      ) or
J4819                           ( @Prtty = PRTTY_AFPDSLINE  ) or
J4819                           ( @Prtty = PRTTY_IPDS       )    ) and
J4819                         ( MlDist = YES                     ) and
/6865                         ( @dest  = DESTPRINT)                     );
/                          LeaveSr;
/                        EndIf;
/     /end-free

      * Open and create printer file
J6644 /free
J6644  if not opened and
J6644    ((@dest <> DEST_MAIL and @dest <> DEST_IFS) or
J6644     (@dest = DEST_IFSPDF and @prtty = PRTTY_AFPDS) or
J6644     (@dest = DEST_IFSPDF and @prtty = PRTTY_SCS));
J6644 /end-free
     C                   EXSR      OPN#RP
     C     *IN51         CABEQ     *ON           CLOSED
     C     *IN81         CABEQ     *ON           CLOSED
     C                   MOVE      *ON           OPENED
     C                   END

     C     DUPLEX        IFEQ      '*YES'
     C     @PRTBO        ORNE      '*NO'
     C     @PRTBO        ANDNE     '*FORMDEF'
     C     DUPLEX        ANDNE     '*NO'
     C     DUPLEX        ANDNE     '*YES'
     C                   MOVE      '1'           DODUPL            1
     C                   ELSE
     C                   MOVE      '0'           DODUPL            1
     C                   END

     C     @DEST         IFEQ      'P'
     C                   EXSR      STRDJE
     C                   EXSR      STRBAN
     C                   ENDIF

      * If duplex, make even pages
     C                   EXSR      EVNPAG
      * If emailing
     C     @DEST         IFEQ      'M'
     C     NBRJOI        ANDEQ     1
     C     MLDIST        ANDNE     'Y'
/1887C                   MOVEL(P)  MLTXT1        MPT(1)
/1887C                   MOVEL(P)  MLTXT2        MPT(2)
/1887C                   MOVEL(P)  MLTXT3        MPT(3)
/1887C                   MOVEL(P)  MLTXT4        MPT(4)
/1887C                   MOVEL(P)  MLTXT5        MPT(5)
     C                   CLEAR                   MLDTA
     C                   CLEAR                   MLDTLE
     C                   MOVEL(P)  'OPEN'        MLOPCD
T7276c                   if        mlopen <> '1'
     C                   EXSR      SPMAIL
T7276c                   endif
     C     CRTCVR        CABEQ     *ON           ENDPRT
     C                   ENDIF
      * If faxing, cover
     C     @DEST         IFEQ      'F'
     C     NBRJOI        ANDEQ     1
/3139C     CVRDON        ANDNE     *ON
     C                   EXSR      FAXCVR
     C     CRTCVR        CABEQ     *ON           ENDPRT
     C                   END

     C                   EXSR      GETRRN
      * Get RMaint rec
     C                   OPEN      RMAINT                               50
     C     KLBIG5        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C     KLBIG5        CHAIN     RMNTRC                             66

/1892C                   If        NOT %Found
/    C                   Open(e)   RMAINT4
/    C     IDDOCT        Chain     RMNTRC4                            66
/    C                   Close(e)  RMAINT4
/     *
/    C                   If        NOT %found
/    C                   Eval      RTypID = *blanks
/    C                   EndIf
/     *
/    C                   EndIf

     C                   CLOSE     RMAINT

     C                   SELECT
      * Mail, open attachment file
     C     @DEST         WHENEQ    'M'
     C                   CLEAR                   MLDTA
     C     TBLNAM        IFNE      *BLANKS
     C                   OPEN      RSEGHDR2
     C     TBLNAM        CHAIN     RSEGHDR2                           50
     C                   CLOSE     RSEGHDR2
     C                   MOVEL     SHSEG         MLSEG
     C                   ELSE
     C                   CLEAR                   MLSEG
     C                   ENDIF

/2497c                   if        mlFmt = PDF_FMT and
/5469c                             blnNativePDF = FALSE
     C                   MOVEL(P)  'PDF'         MLEXT
     C                   MOVEL(P)  'BIN'         MLSTM
     c                   else
     C                   MOVEL(P)  'SCS'         MLEXT
     C                   MOVEL(P)  'SCS'         MLSTM             3
     c                   end
     C                   MOVEL(P)  RTYPID        MLRTYP
/8603c                   if        @codpa <> *blanks and @codpa <> '*DEVD'
/8603c                   eval      mlpgTb = %subst(@codpa:6:5)
/8603c                   else
/8603c                   eval      mlpgTb = *blanks
/8603c                   endif
     C                   MOVEL(P)  'OPNATT'      MLOPCD
     C                   EXSR      SPMAIL
     C                   CLEAR                   MLDTA
/2497c                   if        mlFmt = PDF_FMT and
/5469c                             blnNativePDF = FALSE
     c                   if        0 = OpenPDF(PDFh)
/2497C                   eval      @MSGID = 'ERR157C'
/2497c                   callp     $EXPMSG
     c                   exsr      quit
     c                   end
     c                   if        0 = SetTxtPDF(PDFh)
/2497C                   eval      @MSGID = 'ERR157C'
/2497c                   callp     $EXPMSG
     c                   exsr      quit
     c                   end
     c                   callp     NewPagPDF(PDFh)
     c                   end
      * IFS: open file
/2553c                   When      ( ( @Dest = DEST_IFS           ) and
J3358c                               ( @PrtTy <> PRTTY_AFPDS and
J3533c                                 @PrtTy <> PRTTY_IPDS  and
J3358c                                 @PrtTy <> PRTTY_AFPDSLINE )     )
/2930c                   eval      ToCCS = ToCdePag
     C                   EXSR      OPNIFS

      * IFS: Open file for PDF
      /free
/2553                    When (  @Dest = DEST_IFSPDF       and
J3358                            @PrtTy <> PRTTY_AFPDS     and
J2554                            @PrtTy <> PRTTY_IPDS      and
J3358                            @PrtTy <> PRTTY_AFPDSLINE and
/2553                            blnNativePDF = FALSE           );
/                          ExSr SetPCFilNam;
/
/                          If ( 0 = OpenPDF(PDFh) );
/                             @MsgID = 'ERR157C';
/                             Callp $ExpMsg();
/                             ExSr Quit;
/                           EndIf;

/                          If ( 0 = SetTxtPDF(PDFh) );
/                            @MSGID = 'ERR157C';
/                            Callp(e) $EXPMSG();
/                            exsr quit;
/                          EndIf;
/
/                          Callp NewPagPDF(PDFh);
/      /end-free
     C                   ENDSL

     C     UPGTBL        IFEQ      *ON
     C                   Z-ADD     FRMPAG        PAG#
     C                   EXSR      PAGCHK
     C                   END

     C     FAXTYP        IFEQ      *BLANK
     C                   MOVE      '1'           FAXTYP
     C                   END

     C     DTALIB        IFEQ      *BLANKS
     C                   MOVEL     'SPYGLASS'    DTALIB
     C                   END

      * If SysDft says cfg for APF files, get type of AFP output
     C     LAPFCF        IFEQ      'Y'
     C                   SELECT
     C     PFRFLD        WHENEQ    'N'
     C     PFRFLD        WHENEQ    'P'
     C                   OTHER
     C                   GOTO      OLAY
     C                   ENDSL

      * If APF, print with Mag2038Apf
     C     APFTYP        IFGE      '0'
T6195c     blnNativePDF  andeq     FALSE
     C     RGRFVR        OREQ      'Y'
     C     COMBIN        IFNE      'Y'
     C     @DEST         ANDNE     'F'
     C     @DEST         ANDNE     'M'
     C     @DEST         ANDNE     'D'
     C     @DEST         ANDNE     'I'
/6924c     @dest         oreq      'F'
/    c     faxtyp        andeq     'B'
5225 c     @dest         oreq      'F'
5225 c     faxtyp        andeq     'A'
6302 c     @dest         oreq      'F'
6302 c     faxtyp        andeq     '4'

      * Fetch the Afile archive attribute and check for variable cpi setting.
      * If it is found and the var cpi flag is on and the archived (mrptatr)
      * page width is different than what the page width is in the Afile,
      * move the Afile attributes to the receiver var for processing by
      * mag2038apf.
T6276c                   eval      rc=getArcAtr(SpyNum:%addr(Qusa0200):
/    c                             %size(Qusa0200):2)

T2037c                   ExSr      OvrAttrs

T6276c                   if        rc = 0 and qusfc = 'Y' and
/    c                             @pagwi <> quspw00
/    c                   eval      rcvvar = qusa0200
/    c                   endif

T1720c                   If        ( Prtf <> *blanks and
/    c                               Prtf <> @devnam ) or
/    c                             ( Prtf = @devnam  and
/    c                               PrtLib <> @devnamlib)
/    c                   Eval      @devNam = PrtF

/     *                 Clear the original Page definition and
/     *                 the page library, form definition and the
/     *                 form library to derive the values from the
/     *                 print file itself.
/
/    c                   Eval      @USPD  = *blanks
/    c                   Eval      @USPDL = *blanks
/    c                   Eval      @USFDN = *blanks
/    c                   Eval      @USFDL = *blanks

/    c                   If        PrtLib <> *blanks and
/    c                             PrtLib <> @devnamLib
/    c                   Eval      @devNamLib = PrtLib
/    c                   EndIf

/    c                   EndIf

T6637c                   if        outq <> ' '
/    c                   eval      @outqnam = outq
/    c                   endif
/    c                   if        outql <> ' '
/    c                   eval      @outqlib = outql
/    c                   endif

/5778c                   eval      aOpCode = 'OPEN'
/    c                   CALL      M2038A        pM2038APF              50

/6302c                   If        @PrtTy  = '*USERASCII' and
/    c                             FAXTyp  = '4' and
/    c                             (LAPFCF  = 'Y' or LAPFCF = 'P')
/    c                   CALL      M2038A        pM2038APF              50
/    c                   EndIf

     C     UPGTBL        IFEQ      *ON
     C                   EXSR      PRTSEG
     C                   ELSE
     C                   Z-ADD     FRMPAG        STPRPG            7 0
     C                   Z-ADD     TOPAGE        ENPRPG            7 0
     C                   EXSR      PRTPGS
     C                   END
/5778c                   eval      aOpCode = 'CLOSE'
/    c                   CALL      M2038A        pM2038APF              50
     C                   EXSR      CHGDUP
      *   CHANGE THE OUTQ AS LAST THING
     C                   EXSR      CHGOUT

/8527c                   if        @dest = 'F' and faxtyp = 'B'
/    c                   exsr      sbmsplfaxb
/    c                   endif

      *  Send PCL Document via Quadrants FastFAX API

/6302C                   If        @dest = 'F' and faxtyp = '4'
/    C                   ExSr      SndPCLFAX
/    C                   ENDIF

     C                   Z-ADD     0             #T
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      * Form overlay
     C     OLAY          TAG
     C     RFORM         KLIST
/2420C                   KFLD                    FILNAM
/2420C                   KFLD                    JOBNAM
/2420C                   KFLD                    PGMOPF
/2420C                   KFLD                    USRNAM
/2420C                   KFLD                    USRDTA
     C                   KFLD                    FTYPE
     C                   MOVE      'R'           FTYPE
     C     RFORM         SETLL     RFORRC                                 66

     C     *IN66         IFEQ      *OFF
     C                   MOVE      'N'           FRMOVR
     C                   ELSE
     C                   MOVE      'Y'           FRMOVR            1
     C                   END
      *  IF FAXSTAR IS USED FOR FAXING AND THERE IS A GRAFIC FORM OVERLAY
      *  DON'T USE THE TEXT OVERLAY
     C     @DEST         IFEQ      'F'
     C     FAXTYP        ANDEQ     '1'
     C     FRMNAM        ANDNE     *BLANKS
     C                   MOVE      'N'           FRMOVR
     C                   ENDIF

     C                   Z-ADD     0             #PRTD             9 0
     C                   Z-ADD     1             OVLIN#            7 0

      *
T6195c                   If        blnNativePDF = TRUE and @dest = 'M'
5469 c                   Movel(P)  'WRTATT'      MlOpCd
5469 c                   ExSr      SpMail
5469 c                   Movel(P)  'CLSATT'      MlOpCd
5469 c                   ExSr      SpMail
5469 c                   LeaveSr
5469 c                   EndIf
      *---------
      * Do lines
      *---------
J5438 /free
J5438    rc=getArcAtr(SpyNum:%addr(Qusa0200): %size(Qusa0200): 1 );
J5438
J5438    If (   ( @PRTTY = PRTTY_USERASCII ) and
J5438           ( @DEST  = DEST_IFS        ) and
J5438           ( QUSRF  = '*VARIABLE '    )     );
J5438      #rl = 247;
J5438       ToCol = 247;
J5438    EndIf;
J5438 /end-free
/2264C                   MOVE      *BLANKS       ZZFCFC            1
     C     #V            DO        #T            RR                9 0
     C                   EXSR      DO#LIN
     C   66              LEAVE
     C     #PRTD         IFGT      #TOPRT
     C                   LEAVE
     C                   END
     C                   ENDDO

      * Flush last line
     C                   SELECT
      *   Dasd
     C     @DEST         WHENEQ    'D'
/5469c                   callp     SplLine(' ':RCHds)
      *   Mail
     C     @DEST         WHENEQ    'M'
/2497c                   if        mlFmt = PDF_FMT and
/5469c                             blnNativePDF = FALSE
     c                   callp     WrtLnPDF(PDFh:RCHds)
     c                   else
     C                   MOVEA     RCH           MLRCD
     C     ' '           CHECKR    MLRCD         MLRCDL
     C                   MOVEL(P)  'WRTATT'      MLOPCD
     C                   EXSR      SPMAIL
     c                   end
/2553 *   IFSPDF
/    C                   When      (  @Dest = DEST_IFSPDF       and
J3358c                                @PrtTy <> PRTTY_AFPDS     and
J3358c                                @PrtTy <> PRTTY_AFPDSLINE and
J3353c                                @PrtTy <> PRTTY_IPDS      and
/    c                                blnNativePDF = FALSE           )
/    c                   callp     WrtLnPDF(PDFh:RCHds)
      *   Ifs
     C     @DEST         WHENEQ    'I'
     C                   MOVEA     RCH           MLRCD
     C                   EXSR      IFSLIN
     C                   ENDSL

      * Notes
/5329c                   if        wNotesPrint = 'Y'
     C                   EXSR      DONOTE
     C                   ENDIF
      *>>>>>>>>>>
     C     CLOSED        TAG
     C                   MOVE      *ON           *INLR

     C     @DEST         IFEQ      'P'
     C                   EXSR      ENDBAN
     C                   EXSR      ENDDJE
     C                   END

     C     *IN51         IFEQ      *ON
     C                   CALL      'MAG2051'
     C                   PARM      'MAG2039'     #MSGLC           10

     C                   ELSE

     C     UPGTBL        IFEQ      *ON
     C     @DEST         IFEQ      'P'
     C     @DEST         OREQ      'F'
     C                   EXSR      TSTAMP
     C                   END
     C                   END

     C     TOPAGE        SUB       FRMPAG        PGS901
     C                   ADD       1             PGS901
     C                   CALL      'MAG901'                             81
     C                   PARM                    LOGRTN            1
     C                   PARM      *BLANK        DLSUBS           10
     C                   PARM                    RTYPID
     C                   PARM      *BLANK        DLSEG            10
     C                   PARM                    REPIND
     C                   PARM      *BLANK        DHBNDL           10
     C                   PARM      'P'           DLTYPE            1
     C                   PARM      #PRTD         PGS901            9 0
     C                   PARM      'MAG2038'     DLPROG           10
     C                   END
      *>>>>>>>>>>
     C     ENDPRT        TAG
     C                   CLOSE     RSEGMNT                              50
     C     FILLOC        IFNE      '1'
     C     FILLOC        ANDNE     '2'
     C     FILLOC        ANDNE     '4'
     C     FILLOC        ANDNE     '5'
     C     FILLOC        ANDNE     '6'
     C                   EXSR      CLSFLD
     C                   END

      * If duplex, make even pages
     C                   EXSR      EVNPAG

     C                   SELECT
      * If email, close the attachment
     C     @DEST         WHENEQ    'M'
/2497c                   if        mlFmt = PDF_FMT and
/5469c                             blnNativePDF = FALSE
     c                   if        0 = ClosePDF(PDFh)
/2497C                   eval      @MSGID = 'ERR157C'
/2497c                   callp     $EXPMSG
     c                   exsr      quit
     c                   end
     c                   end
     C                   MOVEL(P)  'CLSATT'      MLOPCD
     C                   EXSR      SPMAIL
     C     @DEST         WHENEQ    'I'
     C                   MOVEL(P)  'CLOSE'       IFOPCD
     C                   CALL      'SPYIFS'      PLIFS
/2553c                   When      ( @Dest = DEST_IFSPDF       and
/    c                               blnNativePDF = FALSE      and
J3358c                               @PrtTy <> PRTTY_AFPDS     and
J3358c                               @PrtTy <> PRTTY_AFPDSLINE and
J3533c                               @PrtTy <> PRTTY_IPDS          )
/    c                   If        0 = ClosePDF(PDFh)
/    c                   eval      @MSGID = 'ERR157C'
/    c                   callp     $EXPMSG
/    c                   exsr      quit
/    c                   EndIf
/
     C                   ENDSL
     C                   ENDSR
      /free
J4819  //-----------------------------------------------------------------------
J4819      BegSr SndSpoolMailSCS;
J4819  //-----------------------------------------------------------------------
J4819
J4819     Reset dsDstDef;
J4819     dsDstDef.RdSubr = %subst(Mlto:1:10);
J4819
J4819     If NOT %Open(RSegHdr2);
J4819       Open(e) RSegHdr2;
J4819
J4819       If %Error = TRUE;
J4819
J4819       EndIf;
J4819
J4819     EndIf;
J4819
J4819     Chain(e) TblNam RSegHdr2;
J4819
J4819     If %Found = TRUE;
J4819       dsDstDef.RdRept = ShRept;
J4819       dsDstDef.RdSeg  = ShSeg;
J4819     Else;
J4819       // Error Handle
J4819     EndIf;
J4819
J4819     Close(e) RSegHdr2;
J4819
J4819     If NOT %Open(RDstDef);
J4819       Open(e) RDstDef;
J4819     EndIf;
J4819
J4819     Chain (dsDstDef.RdSubr:dsDstDef.RdRept:dsDstDef.RdSeg) RDstDef;
J4819
J4819     If %found = TRUE;
J4819       wk_RptNam = RdBndl;
J4819     Else;
J4819            // Error Handle
J4819      EndIf;
j4819
J4819      MlRTyp = wk_RptNam;
J4819      MlExt  = %trim( %xlate('*':' ':mlfmt:1) );
J4819      MlSeg  =  ShSeg;
J4819      MlPgTb =  TblNam;
J4819      mpt(1) = mltxt1;
J4819      mpt(2) = mltxt2;
J4819      mpt(3) = mltxt3;
J4819      mpt(4) = mltxt4;
J4819      mpt(5) = mltxt5;
J4819     // Close the report and delete the override
J4819      feod(e) #REPORT#;
J4819      Close(e) #REPORT#;
J4819      cmdOScmd = 'DLTOVR FILE(#REPORT#) LVL(*JOB)';
J4819
J4819      If ( Run(%trimr(cmdOScmd)) <> OK );
J4819        strErrorLog = 'Issue deleting override';
J4819        MMMSGIO_SndMsgTxt( strErrorLog );
J4819      EndIf;
J4819
J4819      SpyMail(MlDta:MlDtLe:'SPOOLMAIL':
J4819             %trimr(MlTo):MlType:%trimr(MlFrm):
J5658             %trimr(%subst(MlSubj:1:60)) : MPt : MlRtn : RTypID);
J4819      EndSr;
/6865  //------------------------------------------------------------------------
J4819      BegSr SndSpoolMailAFP;
/6865  //------------------------------------------------------------------------
/      //  Render and send a spooled file with SpoolMail if the spooled file is
/      //  of type *AFPDS or *IPDS
/      //------------------------------------------------------------------------
J2469        Callp(e)  SubMsgLog( blnDebug : 'SndSpoolMailAFP' : blnDebug ) ;
/            If blnDistribution = TRUE;
/
/              Reset dsDstDef;
/
/              // Get the Subscriber to build the key to
/              // retrieve the bundle ID
/
/              dsDstDef.RdSubr = %subst(Mlto:1:10);
/
/              // Get the Segment to build the key to
/              // Retrieve the bundle ID from the RSegHdr2
/
/              If NOT %Open(RSegHdr2);
/                Open(e) RSegHdr2;
/
/                If %Error = TRUE;
/
/                EndIf;
/
/              EndIf;
/
/              Chain(e) TblNam RSegHdr2;
/
/              If %Found = TRUE;
/                dsDstDef.RdRept = ShRept;
/                dsDstDef.RdSeg  = ShSeg;
/              Else;
/                // Error Handle
/              EndIf;
/
/              Close(e) RSegHdr2;
/
/              If NOT %Open(RDstDef);
/                Open(e) RDstDef;
/              EndIf;
/
/              Chain (dsDstDef.RdSubr:dsDstDef.RdRept:dsDstDef.RdSeg) RDstDef;
/
/              If %found = TRUE;
/                wk_RptNam = RdBndl;
/              Else;
/                // Error Handle
/              EndIf;
/            EndIf;   // blnDistribution is TRUE
/
/            ExSr OvrAttrs;
/
/            PrtAPFSpool(@fldr:@fldLb:RepInd:OfRNam:RepLoc:RcvVar:
/                        AfpFrm:AfpEnd:NoPagT:
/                        wk_RptNam:drawer:'OPEN');
/            #TSum = 1;

J6561        if not blnDistribution;
J6561          if afpfrm <> frmpag;
J6561            stprpg = frmpag;
J6561          endif;
J6561          if afpend <> topage;
J6561            enprpg = topage;
J6561          endif;
J6561          exsr PrtPgs;
J6561        else;
J6561          ExSr PrtSeg;
J6561        endif;

/            PrtAPFSpool(@fldr:@fldLb:RepInd:OfRNam:RepLoc:
/                        RcvVar:AfpFrm:AfpEnd:NoPagT:
/                        wk_RptNam:drawer:'CLOSE');
/
/            // Set the Report Name to the bundleID in wk_RptNam
/
/            MlRTyp = wk_RptNam;
/
/            // Since SpoolMail is only being used for PDF
/            // set the extension for PDF
/
/            MlExt  = %trim( %xlate('*':' ':mlfmt:1) );
/            mpt(1) = mltxt1;
/            mpt(2) = mltxt2;
/            mpt(3) = mltxt3;
/            mpt(4) = mltxt4;
/            mpt(5) = mltxt5;
/2469        SpyMail(MlDta:MlDtLe:'SPOOLMAIL':
/                   %trimr(MlTo):MlType:%trimr(MlFrm):
/                   %trimr(%subst(MlSubj:1:60)):MPt:MlRtn);
/          EndSr;
/     /end-free
/6202 *-------------------------------------------------------------------------
/    c     SndPCLFAX     BegSr
/     *-------------------------------------------------------------------------
/     * FAX a *USERASCII spooled file using the Quadrant FastFAX interface     -
/     * Capture the last spooled file created in          -
/     * FASTFAX/FFXOTQAPI. Populate the fields accordingly for the call.       -
/     *-------------------------------------------------------------------------
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'SndPCLFax' : blnDebug)

      * Retrieve the last spool file for the job to get the spool number.
J6644 /free
J6644  if splnam = '*ORIG';
J6644    splnam = filnam;
J6644  endif;
J6644 /end-free
J1872c                   callp     rtvSplfA(rcvVar:%size(rcvVar):'SPLA0200':'*':
/    c                             ' ':' ':splnam:-1)
/    c                   reset                   dsFFXSelect
/    c                   eval      ffxSpoolName = splnam
/    c                   eval      ffxJobName = @jobna
/    c                   eval      ffxUserName = @usrna
/    c                   eval      ffxJobNbr = @jobnu
/    c                   eval      ffxSplNbr10 = %editc(@filnu:'X')
/    c                   eval      ffxUsrDta = ' '
/    c                   eval      ffxOutQ = @outQNam
/    c                   eval      ffxOutL = @outQLib

/6202C                   ExSr      PCLFaxCvr
/    c                   Callp(e)  FFXFaxPCL(dsFFXSelect   :
/    c                                FFXQDir              :
/    c                                FFXQRcp              :
/    c                                FFXQRco              :
/    c                                FFXQAd1              :
/    c                                FFXQAd2              :
/    c                                FFXQCty              :
/    c                                FFXQSta              :
/    c                                FFXQZip              :
/    c                                FFXQCny              :
/    c                                FFXQFXN              :
/    c                                FFXQInt              :
/    c                                FFXQRty              :
/    c                                FFXQFan              :
/    c                                FFXQUsr              :
/    c                                FFXQSDr              :
/    c                                FFXQSDt              :
/    c                                FFXQSTM              :
/    c                                FFXQPty              :
/    c                                FFXQRef              :
/    c                                FFXQRSL              :
/    c                                FFXQRTY              :
/    c                                FFXQCvr              :
/    c                                FFXQFMN              :
/    c                                FFXQCAC              :
/    c                                FFXQSVC              :
/    c                                FFXQPrc              :
/    c                                FFXQPvc              :
/    c                                FFXQPrt              :
/    c                                FFXQOQN              :
/    c                                FFXQOQL              :
/    c                                FFXQPof              :
/    c                                FFXQCS1              :
/    c                                FFXQCS2              :
/    c                                FFXQEML              :
/    c                                FFXQDSD              :
/    c                                FFXQSDP
/    c                                )
/    c                   EndSr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/8527c     sbmsplfaxb    begsr
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'sbmsplfaxb' :blnDebug)
/2576c                   Eval                    blnSplFAXbErr = FALSE
     c
/6924c                   call      'SBMSPLFAXB'                         81
/9816c                   parm                    wk_rptnam
/    c                   parm                    thisJobName
J2575c                   parm                    wqusrn
/9816c                   parm                    jnr
/    c                   parm                    fc_faxnum
/    c                   parm                    fc_From
/    c                   parm                    fc_ToCmpny
/    c                   parm                    fc_ToCntct
/    c                   parm                    faxtx1
/    c                   parm                    faxtx2
/    c                   parm                    faxtx3
/    c                   parm                    faxhld
/    c                   parm                    faxsav
/    c                   parm                    prmfax
/    c                   parm                    faxcomrtn         4

/    c                   If                      faxcomrtn <> '0000' and
/    c                                           faxcomrtn <> ' '
/2576c                   eval                    blnSplFAXbErr = TRUE
/9816c                   EndIf

     c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DONOTE        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'DONOTE' : blnDebug )
      *          Do notes

     C     FRMPAG        DO        TOPAGE        #PAGE            11 0
     C                   Z-ADD     #PAGE         PAG#
     C                   EXSR      PAGCHK
     C     PAG#          IFEQ      0
     C                   ITER
     C                   END

      * NOTES PRINT
/813 c                   Z-ADD     PAG#          ACTPG#
     C     ROFFS         IFGT      0
     C                   Z-ADD     ROFFS         PAG#
     C                   END
     C                   CALL      'MAG20362'    P20362
     C     P20362        PLIST
     C                   PARM                    PAG#              9 0
     C                   PARM                    @FLDR            10
     C                   PARM                    @FLDLB           10
     C                   PARM                    @FILNA           10
     C                   PARM                    @JOBNA           10
     C                   PARM                    @USRNA           10
     C                   PARM                    @JOBNU            6
     C                   PARM                    @FILNU
     C                   PARM      DTALIB        @LIBR            10
     C                   PARM      SPYNUM        @FILE            10
     C                   PARM                    REPLOC            1
/813 c                   PARM                    ACTPG#            9 0
/3765c                   PARM      0             Revid             9 0

     C                   ENDDO

     C     ENDNOT        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETRRN        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'GETRRN' : blnDebug )
      *  Get starting and ending rrn
     C     TOPAGE        IFGE      @TOTPA
     C     TOPAGE        ORGE      TOTPAG
     C                   Z-ADD     #MXRRN        #T               10 0
     C                   ELSE
     C     TOPAGE        ADD       1             #T
     C                   Z-ADD     #T            PAG#
     C                   EXSR      LODPT
     C     FRRN          SUB       1             #T
     C                   END

     C     FRMPAG        IFEQ      1
     C                   Z-ADD     FRMPAG        FRRN
     C                   ELSE
     C                   Z-ADD     FRMPAG        PAG#
     C                   EXSR      LODPT
     C                   END

     C                   Z-ADD     FRRN          #V                9 0
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     STRDJE        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'STRDJE' : blnDebug )
      *          Print starting dje

     C     DJEBEF        IFNE      *BLANKS
     C     DJEBEF        CHAIN     RPRTDJE                            66
     C     *IN66         IFEQ      *OFF
     C                   MOVE      *ON           *IN81
/5469c                   eval      djdeStart = djeseq
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ENDDJE        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'ENDDJE' : blnDebug )
      *          Print ending dje

     C     DJEAFT        IFNE      *BLANKS
     C     DJEAFT        CHAIN     RPRTDJE                            66
     C     *IN66         IFEQ      *OFF
     C                   MOVE      *OFF          *IN81
/    c                   if        djeseq <> *blanks
/5469c                   callp     SplLine('+':djeseq)
/    c                   end
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     STRBAN        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'STRBAN' : blnDebug )
      *          Print starting banner

     C     BANNID        IFNE      *BLANKS
     C     INSTRU        ORNE      *BLANKS
/    c                   if        djdeStart <> *blanks
/5469c                   callp     SplLine('1':*blanks)
/    c                   end
     C                   CALL      'MAG604V'
     C                   PARM                    BANNID
     C                   PARM                    INSTRU
     C                   PARM                    LFILNA
     C                   PARM                    LJOBNA
     C                   PARM                    LUSRNA
     C                   PARM                    LUSRDT
     C                   PARM                    LPGMOP
     C                   PARM                    @DATFO
     C                   PARM                    COPIES
     C                   PARM                    FRMPAG
     C                   PARM                    TOPAGE
     C                   ADD       1             PAGE#
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ENDBAN        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'ENDBAN' : blnDebug )
      *          Print ending banner

     C     BANNID        IFNE      *BLANKS
     C     INSTRU        ORNE      *BLANKS
     C                   EXSR      EVNPAG
     C                   CALL      'MAG607V'
     C                   PARM                    BANNID
     C                   PARM                    INSTRU
     C                   ADD       1             PAGE#
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     EVNPAG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'EVNPAG' : blnDebug )
      *          Spit out empty page for duplex printing

     C     DODUPL        IFEQ      '1'
     C     PAGE#         DIV       2             F90               9 0
     C                   MVR                     F90
     C     F90           IFNE      0
     C                   ADD       1             PAGE#
     C                   EXCEPT    NEWPAG
     C                   CLEAR                   RCD
/5469c                   callp     SplLine('-':*blanks)
/5469c                   callp     SplLine('-':*blanks)
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DO#LIN        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'DO#LIN' : blnDebug )
      *          Do a line

     C     RR            ADD       PLCSFD        FRRN
     C                   SUB       1             FRRN
     C                   EXSR      DEVCHN
     C   66              GOTO      ENDPAG

     C     UPGTBL        IFEQ      *ON
     C     RCPG#         IFGT      #LASTP
     C                   Z-ADD     #T            RR
     C                   GOTO      ENDPAG
     C                   END

     C     PPT(#TSUM)    IFNE      RCPG#
     C                   ADD       1             #TSUM
     C     #TSUM         IFEQ      64
     C                   Z-ADD     1             #TSUM
     C                   ADD       1             #PPTRR
     C                   EXSR      LODPPT
     C                   END

     C     PPT(#TSUM)    IFEQ      0
     C                   Z-ADD     #T            RR
     C                   GOTO      ENDPAG
     C                   END

     C                   Z-ADD     PPT(#TSUM)    PAG#
     C                   EXSR      LODPT
     C     FRRN          SUB       1             RR
     C                   GOTO      ENDPAG
     C                   END
     C                   END

     C                   MOVE      *BLANKS       TMP

     C     NUMWND        IFGT      1
     C     PRTWND        ANDEQ     'N'
     C                   Z-ADD     1             FRMCOL
     C                   Z-ADD     #RL           TOCOL
     C                   END

     C     NUMWND        IFEQ      1
     C     PRTWND        OREQ      'N'
     C     FRMCOL        IFNE      1
     C     TOCOL         ORNE      #RL
     C                   Z-ADD     0             #Z                5 0
     C     FRMCOL        DO        TOCOL         #I                5 0
     C                   ADD       1             #Z
     C                   MOVE      RCD(#I)       TMP(#Z)
     C                   ENDDO
     C                   MOVEA(P)  TMP           RCD
     C                   END

     C                   ELSE
     C                   Z-ADD     0             #W                5 0

     C                   DO        NUMWND        #Y                5 0

     C                   DO        WW(#Y)        #I
     C     WSC(#Y)       ADD       #I            #Z
     C                   SUB       1             #Z
     C                   ADD       1             #W
     C                   MOVE      RCD(#Z)       TMP(#W)
     C                   ENDDO

     C     #W            IFNE      COLSCN
     C                   ADD       1             #W
     C                   MOVE      SEPCHR        TMP(#W)
     C                   END
     C                   ENDDO

     C                   MOVEA(P)  TMP           RCD
     C                   END


     C     LCVRPG        IFEQ      'Y'
     C                   EXSR      RPLFLD
      *                                   Cpi
     C                   ELSE
      *-----------
      * Form olay: space up to curr line, printing olay lines as avail
      *-----------
     C     FRMOVR        IFEQ      'Y'
     C     RCLIN#        ANDGT     1
     C                   MOVE      'R'           FTYPE

      * save current line data
/4570c     *like         define    rcdata        rcdataSV
/    c                   eval      rcdataSV = rcdata
/    c     *like         define    rclin#        rclin#SV
/    c                   eval      rclin#SV = rclin#

/    C     OVLIN#        DO        RCLIN#sv      FLINE

/    C     FLINE         IFEQ      RCLIN#sv
/    c                   eval      rcdata = rcdataSV
     C                   MOVE      ' '           RCFCFC
     C                   LEAVE
     C                   END

     C     RFORMA        CHAIN     RFORRC                             67

     C     @DEST         IFNE      'M'
     C     @DEST         ANDNE     'I'

     C     *IN67         IFEQ      *OFF
     C                   EXCEPT    OUTO1
     C                   ELSE
     C                   EXCEPT    SPACE
     C                   ENDIF

     C                   ELSE

/4570c                   eval      rcfcfc = *blank
/    c                   if        not *in67
/    c                   eval      rc2247 = fdata
/    c                   else
/    c                   eval      rc2247 = *blanks
/    c                   end
/    c                   eval      rclin# = fline
/    c                   EXSR      PUTLIN

     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF

     C     @DEST         IFEQ      'D'
     C     @DEST         OREQ      'M'
     C     @DEST         OREQ      'I'
/2553C     @DEST         OREQ      DEST_IFSPDF
     C                   EXSR      PUTLIN

     C                   ELSE
      * New page
     C                   SELECT
     C     RCFCFC        WHENEQ    '1'
     C                   ADD       1             #PRTD
     C     #PRTD         CABGT     #TOPRT        ENDPAG
     C                   ADD       1             PAGE#
      *      Fax
     C     @DEST         IFEQ      'F'
     C     FAXTYP        ANDEQ     '5'
     C     FRMNAM        ANDNE     *BLANKS
     C     FC(23)        CAT       FRMNAM:1      TMP2            247
     C                   EXCEPT    FAX5$F
     C                   ADD       1             PAGE#
     C                   END

     C     FAXTYP        IFEQ      '1'
     C     FAXSTY        ANDEQ     '*YES'
     C     LANOUT        ANDNE     'Y'
     C                   MOVE      'Y'           LANOUT            1
      *                                                    Cpi
     C                   MOVE(P)   *BLANKS       CMDLIN
     C     FAXHC         IFNE      *BLANKS
     C                   CAT       FAXHC:1       CMDLIN
     C                   ELSE
     C                   Z-ADD     NUMCPI        #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END
      *                                                    Lpi
     C     FAXVC         IFNE      *BLANKS
     C                   CAT       FAXVC:1       CMDLIN
     C                   ELSE
     C                   Z-ADD     NUMLPI        #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END
     C                   MOVEL(P)  CMDLIN        CPILPI          100
     C                   EXCEPT    FX1LAN
/5469c                   callp     SplLine('+':rc2247)
     C                   ELSE
      *  New page
/2264C     ZZFCFC        IFEQ      '1'
/2264C                   EXCEPT    OUTP1
/2264C                   END
/5469c                   callp     SplLine(rcFCFC:rc2247)
     C                   ENDIF
      *  Con't
/    c                   other
/5469c                   callp     SplLine(rcFCFC:rc2247)
     C                   ENDSL
/2264C                   MOVEL     RCFCFC        ZZFCFC            1
     C                   END

     C     RCLIN#        ADD       1             OVLIN#
      * Fax
     C     @DEST         IFEQ      'F'
     C     FAXTYP        ANDEQ     '1'
     C     FRMNAM        ANDNE     *BLANKS
     C     RCFCFC        ANDEQ     '1'
     C     FRMNAM        IFEQ      '*RPTCFG'
     C                   MOVEL     RFXFRM        FSTFRM           10
     C                   ELSE
     C                   MOVEL     FRMNAM        FSTFRM           10
     C                   ENDIF
     C     FSTFRM        IFNE      *BLANKS
     C                   EXCEPT    CFORM
     C                   ENDIF
     C                   END
      * All
     C     FRMOVR        IFEQ      'Y'
     C     LCVRPG        ANDNE     'Y'
     C                   MOVE      'R'           FTYPE
     C                   Z-ADD     RCLIN#        FLINE
     C     RFORMA        CHAIN     RFORRC                             67
/4570c                   if        not *in67
/    C     @DEST         IFNE      'M'
/    C     @DEST         ANDNE     'I'
/    C                   EXCEPT    OUTO
/    c                   ELSE
/    c                   eval      rcfcfc = '+'
/    c                   eval      rc2247 = fdata
/    c                   EXSR      PUTLIN
/    c                   end
/    c                   end
     C                   ENDIF
     C     ENDPAG        ENDSR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - =
     C     RFORMA        KLIST
/2420C                   KFLD                    FILNAM
/2420C                   KFLD                    JOBNAM
/2420C                   KFLD                    PGMOPF
/2420C                   KFLD                    USRNAM
/2420C                   KFLD                    USRDTA
     C                   KFLD                    FTYPE
     C                   KFLD                    FLINE

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPMAIL        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'SPMAIL' : blnDebug )

     C                   SELECT
      * CLSATT
     C     MLOPCD        WHENEQ    'CLSATT'
/5635c                   exsr      BldEmlDtl
     C                   CLEAR                   MLPAGE
     C     MLDTLE        IFGT      0
     C                   MOVEL(P)  'WRTATT'      MLOPCD
     C                   CALL      'SPYMAIL'     PLMAIL
     C                   MOVEL     'CLSATT'      MLOPCD
     C                   CLEAR                   MLDTA
     C                   CLEAR                   MLDTLE
     C                   ENDIF

      *                 WRTATT when writing native PDF.
      /free
T4979     When  MlOpCd = 'WRTATT' and blnNativePDF = TRUE;

             if blnDistribution;
               frmPag = 1;
               toPage = -1;
             endif;

T4979        PDFBufInit(intFH:spynum:frmPag:toPage:intPDFSize:pdfFileName);

T4979        if blnDistribution = TRUE and #Ofpp > 0;
               // Get the pdf file name to be used as the source
               // document for the distribution. Then use the pdf distribution
               // modules to more efficiently build the distribution. (PDFIO)
/              pdfFileName = %trim(pdfFileName) + x'00';
/              PDF_dst_init(intFH);

T7480          #pptrr = 1;
/              exsr lodppt;
/              dow not *in66;
/                For i = 1 to %elem(ppt);
/5469              If ppt(i) > *zero and     // Check for valid
/5469                ppt(i) <= TotPag;      // array elements
                     // Add the pages to the distribution pdf file.
T4979                PDF_dst_add_page(ppt(i));
                   endif;
                 EndFor;
T7480            #pptrr += 1;
/                exsr lodppt;
/              enddo;

               // Close the newly created distribution pdf.
T4979          PDF_dst_close();
/              // Open a handle to the distribution pdf for email.
               pdfFileName = PDF_dst_get_fileName();
/              pdfFileName = %trimr(pdfFileName) + x'00';
/              saveFH = intFH;
/              intFH = open(pdfFileName:O_RDONLY);
/            endif; //blnDistribution = TRUE
/            intReqSize = 5700;
/            strPDFBuffer = *allx'00';
/            PDFBufRtv(intFH:ptrPDFBuffer:intReqSize:intRtnSize);

T4979        dow intRtnSize > 0;
/5469          mldtle = intRtnSize;
/5469          Callp(e)  SpyMail(   strPDFBuffer                  :
/5469                               mldtle                        :
/5469                               'WRTATT'                      :
/5469                               MLTO                          :
/5469                               MLTYPE                        :
/5469                               MLFRM                         :
/5469                               MLSUBJ                        :
/5469                               MPT                           :
/5469                               MlRtn);
T4979          PDFBufRtv(intFH:ptrPDFBuffer:intReqSize:intRtnSize);
/            enddo;

/5469        mldtle = intRtnSize; // Prevent an errounous writ to MIME
             // Clean up distribution.
T4979        if blnDistribution;
/              PDFBufQuit(intFH);
/              PDF_dst_quit();
/              intFH = saveFH;
/              saveFH = 0;
/            endif;

T4979        PDFBufQuit(intFH);

             MlOpCd = 'CLSATT';

      /end-free

      * WRTATT
     C     MLOPCD        WHENEQ    'WRTATT'
     C     MLSTM         ANDEQ     'SCS'
      *          pseudo code for crlf
     C     0             DO        LINFDS
     C                   CAT       X'0001':0     MLRCD           256
     C                   ADD       2             MLRCDL            5 0
     C                   ENDDO

     C                   CLEAR                   LINFDS
     C     MLDTLE        ADD       MLRCDL        MLTOTL            5 0
     C                   CAT       MLRCD:0       MLDTA

     C     MLTOTL        IFGT      5700
     C                   Z-ADD     5700          MLDTLE
     C                   CALL      'SPYMAIL'     PLMAIL
     C                   CLEAR                   MLDTA
     C     MLTOTL        SUB       5700          MLDTLE
     C     MLDTLE        IFGT      0
     C     MLRCDL        SUB       MLDTLE        STR               5 0
     C                   ADD       1             STR
     C     MLDTLE        SUBST(P)  MLRCD:STR     MLDTA
     C                   ENDIF
     C                   ELSE
     C                   ADD       MLRCDL        MLDTLE
     C                   ENDIF
      * Other=SPYMAIL (OPEN, OPNATT, CLOSE)
     C                   OTHER
T4979c                   if        blnNativePDf
/    c                   eval      MLEXT = 'PDF'
/    c                   endif
     C                   CALL      'SPYMAIL'     PLMAIL
     C                   ENDSL

     C     PLMAIL        PLIST
     C                   PARM                    MLDTA
     C                   PARM                    MLDTLE            5 0
     C                   PARM                    MLOPCD           10
     C                   PARM      MLTO          MPRCVR          256
     C                   PARM      MLTYPE        MPTYPE            1
     C                   PARM      MLFRM         MPSNDR          256
     C                   PARM      MLSUBJ        MPSUBJ           65
     C                   PARM                    MPT
     C                   PARM                    MLRTN             7

     C                   MOVE      '1'           MLOPEN            1

     C     MLRTN         IFNE      *BLANKS
     C                   MOVEL     MLRTN         @MSGID
     C                   MOVE      *BLANKS       EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   ENDIF
     C                   ENDSR
/5635c*------------------------------------------------------------------------
/5635c*- BldEmlDtl - build detail information for email object logging
/5635c*------------------------------------------------------------------------
/5635c     BldEmlDtl     begsr
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'BldEmlDtl' : blnDebug)

J6348 * build log header
J6348c                   eval      LogOpCode = #AUEMLOBJ
J6348c                   eval      LogUserID = wqusrn
J6348c                   eval      LogObjID  = SpyNum
J6348c                   if        LogObjID = ' '
J6348c                   eval      LogObjID = IDBNUM
J6348c                   endif
J6348c                   eval      LogPagNbr = -1

/5635 * build email from address detail
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):#DTEML:*NULL:
/5635c                              0:%addr(Mlfrm):%len(%trim(MlFrm)))
/5635
/5635 * build email subject detail
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):#DTESUB:*NULL:
/5635c                              0:%addr(MlSubj):%len(%trim(Mlsubj)))
/5635
/5635 * build email Recipient detail
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):#DTRNAME:*NULL:
/5635c                              0:%addr(Mlto):%len(%trim(Mlto)))
/5635
/5635 * get from page#
/5635c                   eval      wkPage = %trim(%editc(FrmPag:'Z'))
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):#DTFPAGE:*NULL:
/5635c                              0:%addr(wkPage):%len(%trim(wkPage)))
/5635 * get to page#
/5635c                   eval      wkPage = %trim(%editc(toPage:'Z'))
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):#DTTPAGE:*NULL:
/5635c                              0:%addr(wkPage):%len(%trim(wkPage)))
/5635
/5635 * build log header
/5635c                   eval      LogOpCode = #AUEMLOBJ
/5635c                   eval      LogUserID = wqusrn
/5635c                   eval      LogObjID  = SpyNum
/5635c                   eval      LogPagNbr = -1
/5635c                   callp     LogEntry(%addr(LogDS))
/5635
/5635c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PUTLIN        BEGSR
J2469c                   Callp(e)  SubMsgLog( FALSE: 'PUTLIN' : blnDebug )
      *          Put a line to Dasd file/eMail/IFS
      *          Records are held at least 1 pass until the next
      *          non-overstrike record is read before outputing.

     C                   MOVE      ' '           SRFCFC            1

     C                   SELECT
     C     RCFCFC        WHENEQ    '1'
     C     OUTQ          IFEQ      '*SHRFLD'
     C     FSTOVR        ANDNE     ' '
     C                   MOVE      RCFCFC        SRFCFC
     C                   END
     C                   CLEAR                   LINFDS
     C     RCFCFC        WHENEQ    '0'
     C                   ADD       1             LINFDS            5 0
     C     RCFCFC        WHENEQ    '-'
     C                   ADD       2             LINFDS
     C                   ENDSL

     C                   MOVEA     RCD           RCW
     C                   MOVE      SRFCFC        FCFCW             1

     C                   SELECT
      * 1st rec
     C     FSTOVR        WHENEQ    ' '
     C                   MOVE      'N'           FSTOVR            1
      * Overstrike
     C     RCFCFC        WHENEQ    '+'
     C                   EXSR      OVRLAY
     C                   GOTO      ENDDAS
      * Rest
     C                   OTHER
     C                   MOVEA     RCH           RCD
     C                   MOVE      FCFCH         SRFCFC

     C                   SELECT
     C     @DEST         WHENEQ    'D'
/5469c                   callp     SplLine(' ':rc2247)
      * -> Mail
     C     @DEST         WHENEQ    'M'
/2497c                   if        mlFmt = PDF_FMT and
/5469c                             blnNativePDF = FALSE
     c                   callp     WrtLnPDF(PDFh:RC2247)
     c                   else
     C                   MOVEA(P)  RCD           MLRCD
     C     ' '           CHECKR    MLRCD         MLRCDL
     C                   MOVEL(P)  'WRTATT'      MLOPCD
     C                   EXSR      SPMAIL
     c                   end

     C     RCFCFC        IFEQ      '1'
     C                   ADD       1             MLPAGE            9 0
/2497c                   if        mlFmt = PDF_FMT and
/5469c                             blnNativePDF = FALSE
     c                   callp     NewPagPDF(PDFh)
     c                   else
     C                   MOVEL(P)  PAGSEP        MLRCD
     C     ' '           CHECKR    MLRCD         MLRCDL
     C                   MOVEL(P)  'WRTATT'      MLOPCD
     C                   EXSR      SPMAIL
     c                   end
     C                   ENDIF
      * -> IFS
     C     @DEST         WHENEQ    'I'
     C                   MOVEA(P)  RCD           MLRCD
     C                   EXSR      IFSLIN

      * IFSPDF
/2553C                   When      ( @DEST = DEST_IFSPDF       and
J3358c                               @PrtTy <> PRTTY_AFPDS     and
J3358c                               @PrtTy <> PRTTY_AFPDSLINE and
J3533c                               @PrtTy <> PRTTY_IPDS      and
J2553c                               blnNativePDF = FALSE          )
/    c                   callp     WrtLnPDF(PDFh:RC2247)
/
/    c                   If        ( RCFCFC = '1' )
/    c                   Eval      MlPage += 1
/    c                   callp     NewPagPDF(PDFh)
/    c                   EndIf
/    c
/    C                   ENDSL
/    C                   ENDSL

     C                   MOVEA     RCW           RCH
     C                   MOVE      FCFCW         FCFCH             1
     C     ENDDAS        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OVRLAY        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'OVRLAY' : blnDebug )
      *          Overlay previous line with overstrike data if
      *          certain criteria are met.
     C                   DO        247           OL                3 0
     C     RCW(OL)       IFNE      ' '
     C     RCH(OL)       SCAN      OCSTR         OC#               3 0
     C     OC#           IFGT      0
     C     OC#           ANDLE     OCLEN
     C                   MOVE      RCW(OL)       RCH(OL)
     C                   END
     C                   END
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RUNCL         BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'RUNCL' : blnDebug )

     C                   CALL      'QCMDEXC'                            81
     C                   PARM                    CMDLIN
     C                   PARM      6000          CLLEN            15 5

     C     *IN81         IFEQ      *ON
     C                   EXSR      RMVMSG
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RMVMSG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'RMVMSG' : blnDebug )
      *          Remove pgm msg
     C                   CALL      'QMHRCVPM'                           51
     C                   PARM                    MSGINF          100
     C                   PARM      100           INFLEN
     C                   PARM      'RCVM0100'    MSGFMT            8
     C                   PARM      '*'           MSGPGM           20
     C                   PARM      0             STKCNT
     C                   PARM      '*LAST'       MSGTYP           10
     C                   PARM                    MSGKY             4
     C                   PARM      *LOVAL        MSGW              4
     C                   PARM      '*REMOVE'     MSGACT           10
     C                   PARM                    ERRCD
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RCVMSG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'RCVMSG' : blnDebug )
      *          Remove pgm msg
     C                   CALL      'QMHRCVPM'                           51
     C                   PARM                    MSGINF          100
     C                   PARM      100           INFLEN
     C                   PARM      'RCVM0100'    MSGFMT            8
     C                   PARM      '*'           MSGPGM           20
     C                   PARM      0             STKCNT
     C                   PARM      '*LAST'       MSGTYP           10
     C                   PARM                    MSGKY             4
     C                   PARM      *LOVAL        MSGW              4
     C                   PARM      '*SAME'       MSGACT           10
     C                   PARM                    ERRCD
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     NUMSTR        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'NUMSTR' : blnDebug )
      *          ------------------------------------------
      *          Convert number to string, concat to CMDLIN
      *          ------------------------------------------
      *            Input : #NCPY(15.5), CMDLIN, *IN31, *IN81
      *            Output: #SDCPY, CMDLIN with #SDCPY concatenated

     C                   Z-ADD     #NCPY         #ICPY            10 0
     C     #NCPY         SUB       #ICPY         #DCPY             5 5    81
     C                   MOVE      #ICPY         #SICPY
     C                   MOVE      #DCPY         #SDCPY
     C                   MOVEA     #SICPY        #SI
     C                   Z-ADD     1             #SUB              3 0

     C                   DO        10            #C                3 0
     C     #SI(#C)       IFNE      '0'
     C                   Z-ADD     0             #SUB
     C                   LEAVE
     C                   END
     C                   ENDDO

     C                   SUB       #SUB          #C
     C                   MOVEA(P)  #SI(#C)       #SICPY
     C     *IN31         IFEQ      *OFF
     C                   CAT       #SICPY:0      CMDLIN
     C                   ELSE
     C                   CAT       #SICPY:1      CMDLIN
     C                   END

     C     *IN81         IFEQ      *OFF
     C                   CAT       '.':0         CMDLIN
     C     #SDC5         CABNE     '0'           DDONE
     C                   MOVE      ' '           #SDC5
     C     #SDC4         CABNE     '0'           DDONE
     C                   MOVE      ' '           #SDC4
     C     #SDC3         CABNE     '0'           DDONE
     C                   MOVE      ' '           #SDC3
     C     #SDC2         CABNE     '0'           DDONE
     C                   MOVE      ' '           #SDC2
      *>>>>>>>>>>
     C     DDONE         TAG
     C                   CAT       #SDCPY:0      CMDLIN
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CMDBLD        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CMDBLD' : blnDebug )
      *          -------------------------------
      *          Build OvrPrtF Command
      *          -------------------------------

     C                   CAT       'SCHEDU':1    CMDLIN
     C                   CAT       'LE(':0       CMDLIN
     C                   CAT       '*FILE':0     CMDLIN
     C                   CAT       'END':0       CMDLIN
     C                   CAT       ')':0         CMDLIN
      * B 181 1840@lpi
     C                   CAT       'LPI(':1      CMDLIN
     C                   Z-ADD     @LPI          #NCPY            15 5
     C                   DIV       10            #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       ')':0         CMDLIN
      * B 185 1880@cpi
     C                   CAT       'CPI(':1      CMDLIN
     C                   Z-ADD     @CPI          #NCPY
/2855C     #ncpy         ifeq      166
/    C                   z-add     167           #ncpy
/    C                   endif
     C                   DIV       10            #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       ')':0         CMDLIN
      * 279 308 @prtxt
     C                   CAT       'PRTTXT':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C     @PRTXT        IFEQ      *BLANKS
     C                   CAT       '*BLANK':0    CMDLIN
     C                   ELSE
     C                   CAT       '''':0        CMDLIN
     C                   CAT       @PRTXT:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN

J2554 /free
/                        Select;
/                          When ( ( @dest     = DEST_IFSPDF ) and
/                                 ( @prtty    = PRTTY_AFPDS )     );
/                            cmdLin = %trimr(cmdLin)  +
/                                    ' DEVTYPE(*AFPDS) ';
/
/                          When ( ( @dest     = DEST_IFSPDF ) and
/                                 ( @prtty    = PRTTY_IPDS  )     );
/                            cmdLin = %trimr(cmdLin)  +
/                                    ' DEVTYPE(*IPDS) ';
/2399
                          // Isolate processing for FastFAX

/                          When ( ( @prtty = '*USERASCII' ) and
/                                 ( faxtyp = '4'          ) and
/                                 ( @dest  = 'F'          )     );
/                            cmdLin = %trimr(cmdLin)
J5921                               + ' DEVTYPE(*USERASCII) ';

/                          Other;
/                            cmdLin = %trimr(cmdLin)
/                                   + ' DEVTYPE(*SCS) ';
/                        EndSl;
/     /end-free

      * 421 430 @prtfi
     C                   CAT       'FIDELI':1    CMDLIN
     C                   CAT       'TY(':0       CMDLIN
     C                   CAT       @PRTFI:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      * 431 431 @rplun
      * 432 432 @rplch
     C                   CAT       'RPLUNP':1    CMDLIN
     C                   CAT       'RT(':0       CMDLIN
     C     @RPLUN        IFEQ      'N'
     C                   CAT       '*NO':0       CMDLIN
     C                   ELSE
     C                   CAT       '*YES':0      CMDLIN
     C                   CAT       '''':1        CMDLIN
     C     @RPLCH        IFEQ      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   ELSE
     C                   CAT       @RPLCH:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C                   END
     C                   CAT       ')':0         CMDLIN
      * B 433 4360@pagle
     C                   CAT       'PAGESI':1    CMDLIN
     C                   CAT       'ZE(':0       CMDLIN
     C                   Z-ADD     @PAGLE        #NCPY
     C                   EXSR      NUMSTR
      * B 437 4400@pagwi
     C                   Z-ADD     @PAGWI        #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
      * 3201 3210 @meamt
     C                   CAT       '*ROWCO':1    CMDLIN
     C                   CAT       'L)':0        CMDLIN
      * B 441 4440@numse
     C                   CAT       'FILESE':1    CMDLIN
     C                   CAT       'P(':0        CMDLIN
     C                   Z-ADD     @NUMSE        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       ')':0         CMDLIN
      * B 445 4480@ovrli
     C                   CAT       'OVRFLW':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C     @OVRLI        IFGT      @PAGLE
     C                   Z-ADD     @PAGLE        @OVRLI
     C                   END
     C                   Z-ADD     @OVRLI        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       ')':0         CMDLIN
      *   449 458 @dbcda
     C                   CAT       'IGCDTA':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   CAT       @DBCDA:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      *   459 468 @dbcec
     C                   CAT       'IGCEXN':1    CMDLIN
     C                   CAT       'CHR(':0      CMDLIN
     C                   CAT       @DBCEC:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      * 469 478 @dbcso
     C                   CAT       'IGCSOS':1    CMDLIN
     C                   CAT       'I(':0        CMDLIN
     C                   CAT       @DBCSO:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      * 479 488 @dbccr
     C                   CAT       'IGCCHR':1    CMDLIN
     C                   CAT       'RTT(':0      CMDLIN
     C                   CAT       @DBCCR:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      * B 489 4920@dbcci
     C                   CAT       'IGCCPI':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C     @DBCCI        IFEQ      -1
     C                   CAT       '*CPI':0      CMDLIN
     C                   ELSE
     C     @DBCCI        IFEQ      -2
     C                   CAT       '*CONDE':0    CMDLIN
     C                   CAT       'NSED':0      CMDLIN
     C                   ELSE
     C                   Z-ADD     @DBCCI        #NCPY
     C                   EXSR      NUMSTR
     C                   END
     C                   END
     C                   CAT       ')':0         CMDLIN
      * 493 502 @graph
      * 503 512 @codpa
     C                   CAT       'CHRID(':1    CMDLIN
     C     @GRAPH        IFEQ      '*DEVD'
     C                   CAT       '*DEVD':0     CMDLIN
     C                   ELSE
     C                   CAT       @GRAPH:0      CMDLIN
     C                   CAT       @CODPA:1      CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN
      * B 533 5360@srcdr
     C                   CAT       'DRAWER':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C     DRAWER        IFEQ      '*ORG'
     C     @SRCDR        IFEQ      -1
     C                   CAT       '*E1':0       CMDLIN
     C                   ELSE
     C     @SRCDR        IFEQ      -2
     C                   CAT       '1':0         CMDLIN
     C                   ELSE
     C                   Z-ADD     @SRCDR        #NCPY
     C                   EXSR      NUMSTR
     C                   END
     C                   END
     C                   ELSE
     C                   CAT       DRAWER:0      CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN
      *   537 546 @prtfo
      * P 849 8565@pntsi
     C                   CAT       'FONT(':1     CMDLIN
     C     @PRTFO        IFEQ      '*DEVD'
     C     @PRTFO        OREQ      '*CPI'
     C                   CAT       @PRTFO:0      CMDLIN
     C                   ELSE
     C                   CAT       @PRTFO:0      CMDLIN
     C     @PNTSI        IFEQ      0
     C                   CAT       '*NONE':1     CMDLIN
     C                   ELSE
     C                   Z-ADD     @PNTSI        #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END
     C                   END
     C                   CAT       ')':0         CMDLIN
      * B 553 5560@pagro
     C                   CAT       'PAGRTT':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   SELECT
     C     @PAGRO        WHENEQ    -1
     C                   CAT       '*AUTO':0     CMDLIN
     C     @PAGRO        WHENEQ    -2
     C                   CAT       '*DEVD':0     CMDLIN
     C     @PAGRO        WHENEQ    -3
     C                   CAT       '*COR':0      CMDLIN
     C                   OTHER
     C                   Z-ADD     @PAGRO        #NCPY
     C                   EXSR      NUMSTR
     C                   ENDSL
     C                   CAT       ')':0         CMDLIN
      * B 557 5600@justi
     C                   CAT       'JUSTIF':1    CMDLIN
     C                   CAT       'Y(':0        CMDLIN
     C                   Z-ADD     @JUSTI        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       ')':0         CMDLIN
      * 561 570 @prtbo
     C                   CAT       'DUPLEX':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   SELECT
     C     DUPLEX        WHENEQ    '*NO'
     C     DUPLEX        OREQ      '*YES'
     C                   CAT       DUPLEX:0      CMDLIN
     C                   OTHER
     C     @PRTBO        IFEQ      '*FORMDF'
     C                   CAT       '*NO':0       CMDLIN
     C                   ELSE
     C                   CAT       @PRTBO:0      CMDLIN
     C                   END
     C                   ENDSL
     C                   CAT       ')':0         CMDLIN
      * 591 600 @algfr
     C                   CAT       'ALIGN(':1    CMDLIN
     C                   CAT       @ALGFR:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      * 601 610 @prtqu
     C                   CAT       'PRTQLT':1    CMDLIN
     C                   CAT       'Y(':0        CMDLIN
     C                   CAT       @PRTQU:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      * 611 620 @frmfe
     C                   CAT       'FORMFE':1    CMDLIN
     C                   CAT       'ED(':0       CMDLIN
     C                   CAT       @FRMFE:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      * B 733 7360@pgpsi
     C                   CAT       'MULTIU':1    CMDLIN
     C                   CAT       'P(':0        CMDLIN
     C                   Z-ADD     @PGPSI        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       ')':0         CMDLIN
      *   737 746 @fovna
      *   747 756 @fovli
      * P 757 7645@fovfd
      * P 765 7725@fovfa
     C                   CAT       'FRONTO':1    CMDLIN
     C                   CAT       'VL(':0       CMDLIN
     C     @FOVNA        IFEQ      '*NONE'
     C                   CAT       @FOVNA:0      CMDLIN
     C                   ELSE
     C                   CAT       @FOVLI:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       @FOVNA:0      CMDLIN
     C                   MOVE      *ON           *IN31
     C                   Z-ADD     @FOVFD        #NCPY
     C                   EXSR      NUMSTR
     C                   Z-ADD     @FOVFA        #NCPY
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END
     C                   CAT       ')':0         CMDLIN
      *   773 782 @bovna
      *   783 792 @bovli
      * P 793 8005@bovfd
      * P 801 8085@bovfa
     C                   CAT       'BACKOV':1    CMDLIN
     C                   CAT       'L(':0        CMDLIN
     C     @BOVNA        IFEQ      '*NONE'
     C     @BOVNA        OREQ      CL(2)
     C                   CAT       @BOVNA:0      CMDLIN
     C                   ELSE
     C                   CAT       @BOVLI:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       @BOVNA:0      CMDLIN
     C                   MOVE      *ON           *IN31
     C                   Z-ADD     @BOVFD        #NCPY
     C                   EXSR      NUMSTR
     C                   Z-ADD     @BOVFA        #NCPY
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END
     C                   CAT       ')':0         CMDLIN
      * 809 818 @uom
     C                   CAT       'UOM(':1      CMDLIN
     C                   CAT       @UOM:0        CMDLIN
     C                   CAT       ')':0         CMDLIN
      * 887 896 @chlmo
      * 897 944 @chlco
     C                   CAT       'CHLVAL':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C     @CHLMO        IFEQ      '*NORMAL'
     C                   CAT       @CHLMO:0      CMDLIN
     C                   ELSE
     C     @CHLC1        IFGT      0
     C                   CAT       '(1 (':0      CMDLIN
     C                   Z-ADD     @CHLC1        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLC2        IFGT      0
     C                   CAT       '(2 (':0      CMDLIN
     C                   Z-ADD     @CHLC2        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLC3        IFGT      0
     C                   CAT       '(3 (':0      CMDLIN
     C                   Z-ADD     @CHLC3        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLC4        IFGT      0
     C                   CAT       '(4 (':0      CMDLIN
     C                   Z-ADD     @CHLC4        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLC5        IFGT      0
     C                   CAT       '(5 (':0      CMDLIN
     C                   Z-ADD     @CHLC5        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLC6        IFGT      0
     C                   CAT       '(6 (':0      CMDLIN
     C                   Z-ADD     @CHLC6        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLC7        IFGT      0
     C                   CAT       '(7 (':0      CMDLIN
     C                   Z-ADD     @CHLC7        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLC8        IFGT      0
     C                   CAT       '(8 (':0      CMDLIN
     C                   Z-ADD     @CHLC8        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLC9        IFGT      0
     C                   CAT       '(9 (':0      CMDLIN
     C                   Z-ADD     @CHLC9        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLCA        IFGT      0
     C                   CAT       '(10 (':0     CMDLIN
     C                   Z-ADD     @CHLCA        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLCB        IFGT      0
     C                   CAT       '(11 (':0     CMDLIN
     C                   Z-ADD     @CHLCB        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C     @CHLCC        IFGT      0
     C                   CAT       '(12 (':0     CMDLIN
     C                   Z-ADD     @CHLCC        #NCPY
     C                   EXSR      NUMSTR
     C                   CAT       '))':0        CMDLIN
     C                   END
     C                   END
     C                   CAT       ')':0         CMDLIN
      * P315331605@fmrfd
      * P316131685@fmrfa
     C                   CAT       'FRONTM':1    CMDLIN
     C                   CAT       'GN(':0       CMDLIN
     C     @FMRFD        IFEQ      -2
     C                   CAT       '*DEVD':0     CMDLIN
     C                   ELSE
     C                   Z-ADD     @FMRFD        #NCPY
     C                   EXSR      NUMSTR
     C                   Z-ADD     @FMRFA        #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END
     C                   CAT       ')':0         CMDLIN
      * P316931765@bmrfd
      * P317731845@bmrfa
     C                   CAT       'BACKMG':1    CMDLIN
     C                   CAT       'N(':0        CMDLIN
     C     @BMRFD        IFEQ      -2
     C                   CAT       '*DEVD':0     CMDLIN
     C                   ELSE
     C     @BMRFD        IFEQ      -1
     C                   CAT       '*FRONT':0    CMDLIN
     C                   CAT       'MGN':0       CMDLIN
     C                   ELSE
     C                   Z-ADD     @BMRFD        #NCPY
     C                   EXSR      NUMSTR
     C                   Z-ADD     @BMRFA        #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END
     C                   END
     C                   CAT       ')':0         CMDLIN
      *  32123221 @fchsn
      *  32223231 @fchsl
      *  32323241 @cdpgn
      *  32423251 @cdpgl
     C                   CAT       'FNTCHR':1    CMDLIN
     C                   CAT       'SET(':0      CMDLIN
     C     @FCHSN        IFEQ      '*FONT'
     C                   CAT       @FCHSN:0      CMDLIN
     C                   ELSE
     C                   CAT       @FCHSL:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       @FCHSN:0      CMDLIN
     C                   CAT       @CDPGL:1      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       @CDPGN:0      CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN
      *  32523261 @cfntn
      *  32623271 @cfntl
     C                   CAT       'CDEFNT':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C     @CFNTN        IFEQ      CL(3)
     C                   CAT       @CFNTN:0      CMDLIN
     C                   ELSE
     C                   CAT       @CFNTL:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       @CFNTN:0      CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN
      *  32723281 @dcftn
      *  32823291 @dcftl
     C                   CAT       'IGCCDE':1    CMDLIN
     C                   CAT       'FNT(':0      CMDLIN
     C     @DCFTN        IFEQ      *BLANKS
     C                   MOVE      '*SYSVAL'     @DCFTN
     C                   END
     C     @DCFTN        IFEQ      '*SYSVAL'
     C                   CAT       @DCFTN:0      CMDLIN
     C                   ELSE
     C                   CAT       @DCFTL:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       @DCFTN:0      CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN
     C                   ENDSR
/6302 *-----------------------------------------------------------------------------------------
/    C     PCLFAXCvr     BegSr
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'PCLFAXCVR' : blnDebug)
/     *-----------------------------------------------------------------------------------------
/     *  FastFax Populate the parameter fields being passed into the API
/     *  FFX325CL with the values from the data structure.
/     *-----------------------------------------------------------------------------------------
/
/    c                   Eval      FFXQDir = *blanks
/     * FAX Directory Nick Name *FD
/    c                   Eval      FFXQRcp = FaxTo
/     * FAX Recipient *FI
/    c                   Eval      FFXQRco = CPName
/     * FAX Company Name
/    c                   Eval      FFXQAD1 = *blanks
/     * FAX Address 1 Recipient
/    c                   Eval      FFXQAD2 = *blanks
/     * FAX Address 2 Recipient
/    c                   Eval      FFXQCty = *blanks
/     * FAX City    Recipient
/    c                   Eval      FFXQSTa = *blanks
/     * FAX State   Recipient
/    c                   Eval      FFXQCny = *blanks
/     * FAX Country Recipient
/    c                   Eval      FFXQFXN =  FAXNUM
/     * FAX Number Recipient
/    c                   Eval      FFXQInt = *blanks
/     * FAX International Code Receipient
/    c                   Eval      FFXQAin = *blanks
/     * FAX Alternate international Code
/    c                   Eval      FFXQFan = *blanks
/     * FAX Alternate international Number
/    c                   Eval      FFXQUsr = *blanks
/     * User Profile
/    c                   Eval      FFXQsDr = FAXFrm
/     * Sender Name Transmission
/    c                   Eval      FFXQSDT = *blanks
/     * Scheduled Date
/    c                   Eval      FFXQSTM = *blanks
/     * Scheduled Time
/    c                   Eval      FFXQPTY = *blanks
/     * Send Priority
/    c                   Eval      FFXQREF = *blanks
/     * Description Transmission
/    c                   Eval      FFXQRSL = *blanks
/     * Graphic Resolution
/    c                   Eval      FFXQRTY = *blanks
/     * Number of Retries
/    c                   If        CvrSht <> *blanks
/    c                   Eval      FFXQCVR = CVRSHT
/    c                   Else
/    c                   Eval      FFXQCVR = *blanks
/    c                   EndIf
/     * Cover Sheet Name  *CV
/    c                   Eval      FFXQFMN = *blanks
/     * Form Merge
/    c                   If        CstACt = *blanks
/    c                   Eval      FFXQCAC = *blanks
/    c                   Else
/    c                   Eval      FFXQCAC = CstAct
/    c                   EndIf
/     * Cost Account *CA
/    c                   If        SCFAx = *blanks
/    C                   Eval      FFXQSVC = *blanks
/    c                   Else
/    c                   Eval      FFXQSVC = SCFAX
/    c                   EndIf
/     * Save FAX *SC
/    c                   If        PCPFAX = *blanks
/    c                   Eval      FFXQPrc = *blanks
/    c                   Else
/    c                   Eval      FFXQPrc = PCPFAX
/    c                   ENDIF
/     * Print Copy *PC
/    C                   Eval      FFXQPVC = *blanks
/     * Print Cover *PV
/    c                   Eval      FFXQPRT = *blanks
/     * Printer id *PR
/    C                   Eval      FFXQOQN = *blanks
/     * Output Queue *OQ
/    c                   Eval      FFXQOQL = *blanks
/     * Output Queue Library  *OL
/    c                   Eval      FFXQPOF = *blanks
/     * Print copy on form *PF
/    C                   If        FAXTX1 <> *blanks or
/    C                             FAXTX2 <> *blanks or
/    C                             FAXtx3 <> *blanks
/    c                   Eval      %subst(FFXQCs1:1:50)   = %subst(FAXTX1:1:50)
/    c                   Eval      %subst(FFXQCs1:81:50)  = %subst(FAXTX2:1:50)
/    c                   Eval      %subst(FFXQCs1:161:50) = %subst(FAXTX3:1:50)
/    c                   Eval      FFXQCS2 = *blanks
/    c                   Else
/    c                   Eval      FFXQCS1 = *blanks
/    c                   Eval      FFXQcs2 = *blanks
/    C                   EndIf
/     * Cover sheet Notes *CN
/    C                   Eval      FFXQDSd = *blanks
/     * Destination for recipient's FAX *DS
/    c                   Eval      FFXQSDP = *blanks
/     * Sender/Department Preference
/
/    c                   EndSr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FAXCVR        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FAXCVR' : blnDebug )
      *          -------------------------------
      *          Create a Fax Cover Page
      *          -------------------------------
     C                   MOVE      *ON           CVRDON            1

     C     FAXTYP        IFEQ      ' '
     C                   MOVE      '1'           FAXTYP
     C                   END

     C     PRMFAX        IFEQ      'A'
     C     FAXTYP        CASEQ     '1'           FCATC1
     C                   ENDCS
     C                   ADD       DOCPGS        PAGTOT
     C                   ENDIF

     C     FAXTYP        CASEQ     '1'           FXTYP1
     C     FAXTYP        CASEQ     '3'           FXTYP3
     C     FAXTYP        CASEQ     '4'           FXTYP4
     C     FAXTYP        CASEQ     '5'           FXTYP5
     C     FAXTYP        CASEQ     '6'           FXTYP6
     C     FAXTYP        CASEQ     '9'           FXTYP9
     C                   ENDCS

     C     PRMFAX        IFEQ      'A'
     C     FAXTYP        CASEQ     '1'           FXATC1
     C                   ENDCS
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PRTSEG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'PRTSEG' : blnDebug )
      *          -------------------------
      *          Partial APF Files
      *          -------------------------
     C                   DO        *HIVAL
     C                   Z-ADD     PPT(#TSUM)    STPRPG
     C                   Z-ADD     PPT(#TSUM)    ENPRPG

     C                   DO        *HIVAL
     C                   ADD       1             #TSUM
     C     #TSUM         IFEQ      64
     C                   Z-ADD     1             #TSUM
     C                   ADD       1             #PPTRR
     C                   EXSR      LODPPT
     C                   END

     C     PPT(#TSUM)    IFGT      TOPAGE
     C                   LEAVE
     C                   END

     C     PPT(#TSUM)    SUB       1             #X1               7 0
     C     #X1           IFEQ      ENPRPG
     C                   Z-ADD     PPT(#TSUM)    ENPRPG
     C                   ITER
     C                   ELSE
     C                   LEAVE
     C                   END
     C                   ENDDO

     C                   EXSR      PRTPGS

     C     ENPRPG        IFGE      #LASTP
     C     ENPRPG        ORGE      TOPAGE
     C                   LEAVE
     C                   END
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PRTPGS        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'PRTPGS' : blnDebug )
      *          --------------------------------
      *          Call Mag2038Apf to print page(s)
      *          --------------------------------
     C                   Z-ADD     STPRPG        AFPFRM
     C                   Z-ADD     ENPRPG        AFPEND

/5778c                   eval      aOpCode = 'WRITE'
     C                   CALL      M2038A        pM2038APF              50
/5778c     pM2038APF     plist
     C                   PARM                    @FLDR
     C                   PARM                    @FLDLB
     C                   PARM                    REPIND
     C                   PARM                    OFRNAM
     C                   PARM                    REPLOC
     C                   PARM                    RCVVAR
     C                   PARM                    AFPFRM            9 0
     C                   PARM                    AFPEND            9 0
     C                   PARM                    NOPAGT            1
/9816C                   PARM                    wk_rptnam
     C                   PARM                    DRAWER            4
/5778c                   parm                    aOpCode          10

      * The following PageRange parm will normally fail, because
      * Mag1074 has been changed to limit output to pages requested.
      * It is needed only when the Splf contains more pages than the
      * user requested, and has been separated from the rest of the
      * command to be sure the rest works...     JJF 9/30/97

     C     @PRTTY        IFNE      '*AFPDS'
/5778C     @PRTTY        ANDNE     '*PCL5'                                      *USERASCII
     C     NOPAGT        ANDEQ     *ON
     C                   EXSR      FMTCHG
     C                   CAT       CL(31):1      CMDLIN
     C                   MOVE      STPRPG        NUM7C             7
     C                   CAT       NUM7C:0       CMDLIN
     C                   MOVE      ENPRPG        NUM7C
     C                   CAT       NUM7C:1       CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL
     C                   END

/5778c*    @PRTTY        IFNE      '*PCL5'                                      *USERASCII
/6487C*                  EXSR      CHGDUP
      *   CHANGE THE OUTQ AS LAST THING
     C*                  EXSR      CHGOUT
     C*                  EXSR      RLSSPL
/    c*                  END

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RLSSPL        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'RLSSPL' : blnDebug )
      *          -----------------------------
      *          Release SPLF for APF files
      *          -----------------------------
     C     CL(34)        CAT(P)    SPLNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHGOUT        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CHGOUT' : blnDebug )
      *          -----------------------------
      *          Chg Outq, usrdta etc. for apf files
      *          -----------------------------
     C                   EXSR      FMTCHG

     C     WRITER        IFNE      *BLANKS
     C                   CAT       CL(27):1      CMDLIN
     C                   CAT       WRITER:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END
     C                   CAT       CL(28):1      CMDLIN
     C     OUTFRM        IFEQ      *BLANKS
     C                   MOVEL     '*STD'        OUTFRM
     C                   END
/8632c                   eval      CmdLin=%trimr(CmdLin)+%trim(dblqte(OutFrm))
     C                   CAT       CL(29):0      CMDLIN
     C                   Z-ADD     COPIES        NUM3              3 0
     C                   MOVE      NUM3          NUM3C             3
     C                   CAT       NUM3C:0       CMDLIN
     C     OUTQ          IFNE      *BLANKS
     C                   CAT       CL(30):0      CMDLIN
     C     OUTQL         IFNE      *BLANKS
     C                   CAT       OUTQL:0       CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   END
     C                   CAT       OUTQ:0        CMDLIN
     C                   END

     C                   CAT       CL(32):0      CMDLIN
     C     FAXSAV        IFEQ      'Y'
     C                   CAT       '*YES':0      CMDLIN
     C                   ELSE
     C                   CAT       '*NO':0       CMDLIN
     C                   END

     C                   CAT       CL(33):0      CMDLIN
/8632c                   eval      CmdLin=%trimr(CmdLin)+%trim(dblqte(Rptud))
     C                   CAT       ''')':0       CMDLIN
     C                   EXSR      RUNCL

/6754c                   eval      cmdlin = 'HLDSPLF ' + %trimr(splnam) +
/    c                             ' SPLNBR(*LAST)'
/7956c                   if        faxhld <> 'Y'
/6754c                   eval      %subst(cmdlin:1:3) = 'RLS'
/    c                   endif
/    c                   exsr      runcl

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FMTCHG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FMTCHG' : blnDebug )
      *          -----------------------------
      *          GET THE START FOR CMD: CHGSPLFA JOB(...
      *          -----------------------------
/9816
/9816C     wk_rptnam     IFNE      *BLANKS
/9816C     wk_rptnam     ANDNE     '*ORIG'
T6686c     wk_rptnam     andne     '*DTAQ'
/9816C                   MOVEL(P)  wk_rptnam     SPLNAM
     C                   ELSE
T6686c                   if        @filna <> ' '
     C                   MOVEL(P)  @FILNA        SPLNAM           10
T6686c                   else
T6686c                   eval      splnam = rptnam
T6686c                   endif
     C                   END

     C     CL(24)        CAT(P)    SPLNAM:0      CMDLIN
     C                   CAT       CL(25):0      CMDLIN
     C                   CAT       '*':0         CMDLIN
     C                   CAT       CL(26):0      CMDLIN
     C                   CAT       '*LAST':0     CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHGDUP        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CHGDUP' : blnDebug )
      * The following DUPLEX parm may fail for AFP reports.
      * It has been separated from the rest of the command
      * to be sure the rest works...   JJF 5/20/98

     C     DUPLEX        IFNE      *BLANKS
     C     DUPLEX        ANDNE     '*ORG'
     C                   EXSR      FMTCHG
     C                   CAT       'DUPLEX':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   CAT       DUPLEX:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2322C     CHGDRW        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CHGDRW' : blnDebug )

     C     DRAWER        IFNE      *BLANKS
     C     DRAWER        ANDNE     '*ORG'
     C                   EXSR      FMTCHG
     C                   CAT       'DRAWER':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   CAT       DRAWER:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL
     C                   END

/2322C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODPT         BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'LODPT' : blnDebug )
      *          -----------------------------
      *          Page Table Read
      *          -----------------------------
     C     PAG#          IFLT      1
     C                   Z-ADD     1             PAG#              9 0

     C                   ELSE
     C     PAG#          IFGT      @TOTPA
     C                   Z-ADD     @TOTPA        PAG#
     C                   END
     C                   END

      * Page in array and table has not changed
     C     PAG#          IFGE      PGBEG
     C     PAG#          ANDLE     PGEND
     C                   GOTO      NOREAD
     C                   END

/2272C                   Z-ADD     0             PTP
/2272C                   Z-ADD     0             PTB

     C     PAG#          SUB       1             #P                9 0
     C                   DIV       63            #P
     C     PLCSFP        ADD       #P            FRRN              9 0
     C                   MOVE      ' '           COMPRS
     C                   EXSR      DEVCHN
     C                   MOVE      HCMPRS        COMPRS

/2272c                   eval      PGTBTYsv = PGTBTY
/2272C     PGTBTY        IFEQ      ' '
     C                   MOVEL     RC2256        PTDSP
     C                   ELSE
     C                   MOVEL     RC2256        PTDSB
     C                   ENDIF

     C                   MULT      63            #P
     C     #P            ADD       1             PGBEG             9 0
     C     PGBEG         ADD       62            PGEND             9 0
     C     PGEND         IFGT      @TOTPA
     C                   Z-ADD     @TOTPA        PGEND
     C                   END
      *>>>>>>>>>>
     C     NOREAD        TAG
     C     PAG#          DIV       63            #P
     C                   MVR                     #P
     C     #P            IFEQ      0
     C                   Z-ADD     63            #P
     C                   END

/2272C     PGTBTYsv      IFEQ      ' '
     C                   Z-ADD     PTP(#P)       FRRN
     C                   ELSE
     C                   Z-ADD     PTB(#P)       FRRN
     C                   ENDIF

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PAGCHK        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'PAGCHK' : blnDebug )
      *          -------------------------------------
      *          Set PAG# to 0 if not viewable by user
      *          -------------------------------------
     C     UPGTBL        CABNE     *ON           PGCKE

     C     PAG#          IFLT      #FRSTP
     C     #PPTRR        IFNE      1
     C                   Z-ADD     1             #PPTRR
     C                   EXSR      LODPPT
     C                   END
     C                   Z-ADD     0             PAG#
     C                   GOTO      PGCKE
     C                   END

     C     PAG#          IFGT      #LASTP
     C     #PPTRR        IFNE      BGREC
     C                   Z-ADD     BGREC         #PPTRR
     C                   EXSR      LODPPT
     C                   END
     C                   Z-ADD     0             PAG#
     C                   GOTO      PGCKE
     C                   END

     C     PAG#          IFGE      PTBEG
     C     PAG#          ANDLE     PTEND
     C                   GOTO      NORDPT
     C                   END

     C                   Z-ADD     0             #PPTRS            9 0
     C                   Z-ADD     BGREC         #PPTRE            9 0
     C                   Z-ADD     BGREC         #PPTRR            9 0

     C                   DO        *HIVAL

     C     PAG#          IFLT      PTBEG
     C     #PPTRS        ADD       #PPTRR        #TSUM             9 0
     C                   END

     C     PAG#          IFGT      PTEND
     C     #PPTRE        ADD       #PPTRR        #TSUM
     C                   END

     C     #TSUM         DIV       2             #PPTRR
     C     #PPTRS        IFEQ      #PPTRR
     C                   Z-ADD     0             PAG#
     C                   GOTO      PGCKE
     C                   END

     C                   EXSR      LODPPT

     C     PAG#          IFGE      PTBEG
     C     PAG#          ANDLE     PTEND
     C                   LEAVE
     C                   END

     C     PAG#          IFLT      PTBEG
     C                   Z-ADD     #PPTRR        #PPTRE
     C                   END

     C     PAG#          IFGT      PTEND
     C                   Z-ADD     #PPTRR        #PPTRS
     C                   END
     C                   ENDDO

     C     NORDPT        TAG

     C                   DO        63            #TSUM
     C     PAG#          CABEQ     PPT(#TSUM)    PGCKE
     C     PAG#          IFLT      PPT(#TSUM)
     C                   Z-ADD     0             PAG#
     C                   GOTO      PGCKE
     C                   END
     C                   ENDDO
     C     PGCKE         ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODPPT        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'LODPPT' : blnDebug )
      *          Load Partial Page Table with RSegmnt chain

      // Leave the subroutine if the segment page file is closed. All records have
      // already been processed.
J6346 /free
J6346   if not %open(rsegmnt);
J6346     leavesr;
J6346   endif;
J6346 /end-free

     C                   Z-ADD     #PPTRR        SGSEQ
     C     PGKEY         CHAIN     RSEGMNT                            66
     C                   Z-ADD     PPT(1)        PTBEG

     C     PPT(63)       IFGT      0
     C                   Z-ADD     PPT(63)       PTEND
     C                   ELSE
     C                   Z-ADD     #LASTP        PTEND
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DEVCHN        BEGSR
J2469c                   Callp(e)  SubMsgLog( FALSE : 'DEVCHN' : blnDebug )
      *          Chain to Folder

     C                   MOVE      'CHAIN'       ODOPC
     C                   MOVE      '0'           ODINLR
     C     FILLOC        IFNE      '1'
     C     FILLOC        ANDNE     '2'
     C     FILLOC        ANDNE     '4'
     C     FILLOC        ANDNE     '5'
     C     FILLOC        ANDNE     '6'
     C                   EXSR      DASDRD
     C                   ELSE
     C                   MOVEL     FRRN          ODKEY
     C                   MOVEL(P)  'QTEMP'       ODLIB
     C                   EXSR      OPTRD
     C                   END
     C                   MOVE      ODINHI        *IN66
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DEVRD         BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'DEVRD' : blnDebug )
      *          Read Folder

     C                   ADD       1             FRRN
     C                   MOVE      'READ '       ODOPC
     C                   MOVE      '0'           ODINLR

     C     FILLOC        IFNE      '1'
     C     FILLOC        ANDNE     '2'
     C     FILLOC        ANDNE     '4'
     C     FILLOC        ANDNE     '5'
     C     FILLOC        ANDNE     '6'
     C                   EXSR      DASDRD
     C                   ELSE
     C                   MOVEL(P)  'QTEMP'       ODLIB
     C                   MOVE      *BLANKS       ODKEY
     C                   EXSR      OPTRD
     C                   END

     C                   MOVE      ODINEQ        *IN66
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DASDRD        BEGSR
J2469c                   Callp(e)  SubMsgLog( FALSE : 'DASDRD' : blnDebug )
/2813 /free
/                        If NOT %Open(MSPLDAT);
/                          Open(e) MSPLDAT;
/                        EndIf;
/     /end-free
/     *          Read folder from DASD

     C     COMPRS        IFEQ      ' '
     C                   SELECT
     C     ODOPC         WHENEQ    'CHAIN'
      *          Frrn      chainmspldat              66
     C     FRRN          SETLL     MSPLDAT                            66
     C                   READ      MSPLDAT                                66
     C                   OTHER
     C                   READ      MSPLDAT                                66
     C                   ENDSL
/2497c                   move      *in66         ODINHI
/    c                   move      *off          ODINLO
/    c                   move      *in66         ODINEQ

     C                   ELSE
     C                   Z-ADD     1             UNLCOM            1 0
     C                   CALL      'MAG1055'     COMPRM
     C     COMPRM        PLIST
     C                   PARM                    @FLDR
     C                   PARM                    @FLDLB
     C                   PARM                    PLCSFA
     C                   PARM                    ODOPC
     C                   PARM      FRRN          ODRRN
/    C                   PARM      *off          ODINHI
/    C                   PARM      *off          ODINLO
/    C                   PARM      *off          ODINEQ
     C                   PARM                    ODINLR
     C                   PARM                    ODRTN             1
     C                   PARM                    CMDLIN
     C                   MOVEL     CMDLIN        RCDATA
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPTRD         BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'OPTRD' : blnDebug )
      *          Read folder from QDLS (Optical)

     C                   Z-ADD     1             UNLOPT            1 0
     C     COMPRS        IFEQ      ' '
     C                   MOVE      'TABLE'       ODOPC
     C                   END
     C                   CALL      'MAG1053'     MPGPRM
     C     MPGPRM        PLIST
     C                   PARM                    ODLIB            10
     C                   PARM                    OPTFIL
     C                   PARM                    OPTFIL
     C                   PARM                    ODKEY            99
     C                   PARM      '00'          ODKYL             2
     C                   PARM                    ODOPC             5
     C                   PARM      FRRN          ODRRN             9 0
     C                   PARM      *OFF          ODINHI            1
     C                   PARM      *OFF          ODINLO            1
     C                   PARM      *OFF          ODINEQ            1
     C                   PARM                    ODINLR            1
     C                   PARM      *BLANKS       ODRTNI            7
     C                   PARM      *BLANKS       ODRTND          100
     C                   PARM                    CMDLIN
     C                   PARM                    FILLOC
     C                   PARM                    SPYNUM
     C                   PARM                    RFIL#             9 0
     C                   PARM                    ROFFS            11 0

     C                   MOVEL     CMDLIN        RCDATA

     C     ODRTNI        IFNE      *BLANKS
     C                   MOVEL     ODRTNI        @MSGID
     C                   MOVEL     ODRTND        EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RPLFLD        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'RPLFLD' : blnDebug )
      *          ----------------------------------------
      *          Replace Cover Page field in printed text
      *          ----------------------------------------
     C     GOTFLD        IFNE      'Y'
     C     *DTAARA       DEFINE                  SPYCVR
     C                   IN        SPYCVR
     C                   CALL      'MAG1047'
     C                   PARM                    CYMDNO            9 0
     C                   PARM                    CYMD              8
     C                   TIME                    CTIME
     C                   MOVE      'Y'           GOTFLD            1
     C                   END

     C                   MOVEA     RCD           LINE            247

     C                   DO        16            #F                2 0
     C     ' '           CHECKR    SPF(#F)       #L                3 0

     C     *IN81         DOUEQ     *ON
     C                   Z-ADD     0             #G                3 0
     C     SPF(#F):#L    SCAN      LINE:1        #G                       81
     C     *IN81         IFNE      *ON
     C                   LEAVE
     C                   END
     C     #G            ADD       #L            #FE               3 0
     C                   MOVEA     LINE          TMP
     C                   MOVEA     *BLANKS       TMP(#G)
     C                   SELECT
     C     #F            WHENEQ    1
     C                   MOVEA     CMM           TMP(#G)
     C                   ADD       2             #G
     C                   MOVEA     '/'           TMP(#G)
     C                   ADD       1             #G
     C                   MOVEA     CDD           TMP(#G)
     C                   ADD       2             #G
     C                   MOVEA     '/'           TMP(#G)
     C                   ADD       1             #G
     C                   MOVEA     CYYYY         TMP(#G)
     C                   ADD       4             #G
     C     #F            WHENEQ    2
     C                   MOVEA     CHR           TMP(#G)
     C                   ADD       2             #G
     C                   MOVEA     ':'           TMP(#G)
     C                   ADD       1             #G
     C                   MOVEA     CMN           TMP(#G)
     C                   ADD       2             #G
     C                   MOVEA     ':'           TMP(#G)
     C                   ADD       1             #G
     C                   MOVEA     CSS           TMP(#G)
     C                   ADD       2             #G
     C     #F            WHENEQ    3
     C     ' '           CHECKR    CBUNDL        #LL               3 0
     C                   MOVEA     CBUNDL        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    4
     C     ' '           CHECKR    CREPT         #LL
     C                   MOVEA     CREPT         TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    5
     C     ' '           CHECKR    CSEGMT        #LL
     C                   MOVEA     CSEGMT        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    6
     C     ' '           CHECKR    CSUBSC        #LL
     C                   MOVEA     CSUBSC        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    7
     C     ' '           CHECKR    CCOPY         #LL
     C                   MOVEA     CCOPY         TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    8
     C     ' '           CHECKR    CBNDDS        #LL
     C                   MOVEA     CBNDDS        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    9
     C     ' '           CHECKR    CRPTDS        #LL
     C                   MOVEA     CRPTDS        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    10
     C     ' '           CHECKR    CSEGDS        #LL
     C                   MOVEA     CSEGDS        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    11
     C     ' '           CHECKR    CSUBDS        #LL
     C                   MOVEA     CSUBDS        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    12
     C     ' '           CHECKR    CRRNAM        #LL
     C                   MOVEA     CRRNAM        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    13
     C     ' '           CHECKR    CRJNAM        #LL
     C                   MOVEA     CRJNAM        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    14
     C     ' '           CHECKR    CRPNAM        #LL
     C                   MOVEA     CRPNAM        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    15
     C     ' '           CHECKR    CRUNAM        #LL
     C                   MOVEA     CRUNAM        TMP(#G)
     C                   ADD       #LL           #G
     C     #F            WHENEQ    16
     C     ' '           CHECKR    CRUDAT        #LL
     C                   MOVEA     CRUDAT        TMP(#G)
     C                   ADD       #LL           #G
     C                   ENDSL
     C                   MOVEA     RCD(#FE)      TMP(#G)
     C                   MOVEA(P)  TMP           RCD
     C                   MOVEA(P)  TMP           LINE
     C                   ENDDO
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVMSG        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'RTVMSG' : blnDebug )
     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80
     C                   MOVE      *BLANKS       @ERDTA
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPN#RP        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'OPN#RP' : blnDebug )
      *          Override & open #REPORT#

      * If OUTFIL given, we are "printing" to a user-named DASD file.
      *    Just override #REPORT# to the database file.
     C     OUTFIL        IFNE      *BLANKS
     C     CL(5)         CAT(P)    OUTFLB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       OUTFIL:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   GOTO      BOTOPN
     C                   END

      * Not to db, override #REPORT# to a printer file.
      *      If COMBIN=Y, the output is #REPORT#.
      *      If COMBIN=N, the output is to: PrtLib/PrtF  if given
      *                                     Qtemp/Output if no PrtF

      * If PRTF given, get PR... vars from it.
     C     PRTF          IFNE      *BLANKS
     C     CL(11)        CAT(P)    PRTLIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       PRTF:0        CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL

     C     *IN81         IFEQ      *ON
     C                   MOVE      *BLANKS       PRTF
     C                   MOVE      *BLANKS       PRTLIB
     C                   ELSE
     C                   MOVEL(P)  CL(12)        CMDLIN
     C                   EXSR      RUNCL
     C                   OPEN      MAG2038
     C                   READ      QWHFDPRT                               50
      *                                                      Mag2038
     C     *IN50         IFEQ      *ON
     C                   MOVEL     'ERR0162'     @MSGID
/2423C     PRTF          CAT(P)    PRTLIB        EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   END

     C     PRFLS         IFEQ      'Y'
     C                   MOVE      *BLANKS       PRTF
     C                   MOVE      *BLANKS       PRTLIB
     C                   END

     C     PRPTXT        IFEQ      @PRTXT
     C                   MOVE      *BLANKS       @PRTXT
     C                   ELSE
     C                   MOVE      PRPTXT        @PRTXT
     C                   END

     C                   CLOSE     MAG2038
     C                   MOVEL(P)  CL(13)        CMDLIN
     C                   EXSR      RUNCL
     C                   END
     C                   END

     C     PRTF          IFEQ      *BLANKS
     C                   MOVE      *BLANKS       @PRTXT
     C     COMBIN        IFNE      'Y'
      *                         CRTPRTF QTEMP/OUTPUT
     C                   MOVEL(P)  CL(1)         CMDLIN
     C                   EXSR      RUNCL
     C     *IN81         CABEQ     *ON           ENDOPN
     C                   END
     C                   END

/9816
/9816c                   callp     os_FixName(rptnam:%len(%trimr(rptnam)):
/9816c                               wk_rptnam)
/9816
/9816c                   eval      cmdlin=%trim(cl(4)) + ' SPLFNAME(' +
/9816c                             %trim(wk_rptnam) + ')'
     C                   CAT       #SHARE:1      CMDLIN

      * If COMBIN=N the override has a TOFILE.
      * If COMBIN=N the override has a TOFILE.
     C     COMBIN        IFNE      'Y'
     C                   CAT       'TOFILE':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C     PRTF          IFEQ      *BLANKS
     C                   CAT       'QTEMP/':0    CMDLIN
     C                   CAT       'OUTPUT':0    CMDLIN
     C                   ELSE
     C                   CAT       PRTLIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       PRTF:0        CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN
     C                   END
      * outq/writer
     C                   SELECT
     C     OUTQ          WHENNE    *BLANKS
     C                   CAT       'OUTQ(':1     CMDLIN
     C     OUTQL         IFNE      *BLANKS
     C                   CAT       OUTQL:0       CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   END
     C                   CAT       OUTQ:0        CMDLIN
     C                   CAT       ')':0         CMDLIN
     C     WRITER        WHENNE    *BLANKS
     C                   CAT       'DEV(':1      CMDLIN
     C                   CAT       WRITER:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   ENDSL
      * formtype
     C     OUTFRM        IFNE      *BLANKS
     C                   CAT       'FORMTY':1    CMDLIN
     C                   CAT       'PE(''':0     CMDLIN
/8632c                   eval      CmdLin=%trimr(CmdLin)+%trim(dblqte(OutFrm))
     C                   CAT       ''')':0       CMDLIN
     C                   END
      * usrdta
     C                   CAT       'USRDTA':1    CMDLIN
     C                   CAT       '(''':0       CMDLIN
/8632c                   eval      CmdLin=%trimr(CmdLin)+%trim(dblqte(Rptud))
     C                   CAT       ''')':0       CMDLIN
      * copies
     C                   CAT       'COPIES':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   MOVE      COPIES        TMPCPY            3
     C                   CAT       TMPCPY:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
      * hold
     C                   CAT       'HOLD(':1     CMDLIN
     C     FAXHLD        IFEQ      'Y'
     C                   CAT       '*YES)':0     CMDLIN
     C                   ELSE
     C                   CAT       '*NO)':0      CMDLIN
     C                   END
      * save
     C     @DEST         IFEQ      'F'
     C     @DEST         OREQ      'P'
/2308c     Caller        oreq      'MAG601'
     C                   CAT       'SAVE(':1     CMDLIN
     C     FAXSAV        IFEQ      'Y'
     C                   CAT       '*YES)':0     CMDLIN
     C                   ELSE
     C                   CAT       '*NO)':0      CMDLIN
     C                   END
     C                   END

     C     PRTF          IFEQ      *BLANKS
     C     CRTCVR        ANDNE     *ON
/3139C     PCEXT         ANDNE     'TXT'
     C                   EXSR      CMDBLD
     C                   ELSE
      * prttxt
     C                   CAT       'PRTTXT':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C     @PRTXT        IFEQ      *BLANKS
     C                   CAT       '*BLANK':0    CMDLIN
     C                   ELSE
     C                   CAT       '''':0        CMDLIN
     C                   CAT       @PRTXT:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN
     C                   END
      * * * * SHARE(*YES) always done. See #SHARE above. * * * * *
      * * * *    DJEBEF    IFNE *BLANKS                          *
      * * * *    DJEAFT    ORNE *BLANKS                          *
      * * * *    BANNID    ORNE *BLANKS                          *
      * * * *    INSTRU    ORNE *BLANKS                          *
      * * * *              CAT  CL,35:1   CMDLIN                 *
      * * * *              END                                   *
      *>>>>>>>>>>
     C     BOTOPN        TAG
J4819 /free
J4819                    If ( ( mldist = YES     ) and
J5953                         ( IsSplMail = SPLMAIL )    );
J4819                   //      ( mlspml = SPLMAIL )     );
J4819                      CmdLin = %trim( CmdLin ) +
J4819                      ' SECURE(*YES) '         +
J4819                      ' OPNSCOPE(*JOB) ';
J4819                    EndIf;
J4819 /end-free
     C                   EXSR      RUNCL
     C  N81              OPEN      #REPORT#                             51

      * change the Spool file attributes to match the overridden values
      *   entered by the user.  This will be used by the actual print
      *   programs when they create the spool file (QSPCRTSP API)
     c                   exsr      OvrAttrs

     C     ENDOPN        ENDSR
     c*-------------------------------------------------------------------------
     c*- Override spool file attributes
     c*-------------------------------------------------------------------------
     c     OvrAttrs      begsr
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'OvrAttrs' : blnDebug )

      * override report name
/9816c                   if        wk_rptnam <> *blanks
/9816c                   eval      @filna = wk_rptnam
     c                   endif

      * override form type
     c                   if        outfrm <> *blanks
     c                   eval      @frmty = outfrm
     c                   endif

      * override user data
     c                   if        rptud <> *blanks
     c                   eval      @usrdt = rptud
     c                   endif

      * override Outq
     c                   if        outq <> *blanks
     c                   eval      @OutQnam = Outq
     c                   endif

      * override OutQ library
     c                   if        OutqL <> *blanks
     c                   eval      @OutQLib = OutqL
     c                   endif

      * override Writer
     c                   if        Writer <> *blanks
     c                   eval      @Devnam = Writer
     c                   eval      @outqNam = '*DEV'
     c                   eval      @outqlib = *blanks
     c                   endif

      * override copies
     c                   if        copies <> 0
     c                   eval      @cpys = copies
     c                   eval      @cpyrem = copies
     c                   endif

      * override hold status
     c                   if        faxhld = 'Y'
     c                   eval      @hldfil = '*YES'
     c                   else
     c                   eval      @hldfil = '*NO'
     c                   endif

      * override save status
     c                   if        faxsav = 'Y'
     c                   eval      @savfil = '*YES'
     c                   else
     c                   eval      @savfil = '*NO'
     c                   endif

     c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPNFLD        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'OPNFLD' : blnDebug )

J3234c                   If        ( %open(MSPLDAT) = FALSE )
/9134 * change OVRDBF to specify member.  Also, use prototyped
/9134 *   call to QCmdExc.
J2470c                   If        ( @fldlb = *blanks )
/    c                   eval      cmdLin = %trim(Ovrdb1)+'MSPLDAT'+
/    c                             %trim(Ovrdb2)+%trim(@fldr)+
/    c                             ') MBR('+%trim(@fldr)+')' +
/    c                             ' OVRSCOPE(*CALLLVL' + %trim(Ovrdb3)
/    c                   Else
/9134c                   eval      cmdLin = %trim(Ovrdb1)+'MSPLDAT'+
/9134c                             %trim(Ovrdb2)+%trim(@fldlb)+'/'+%trim(@fldr)+
/9134c                             ') MBR('+%trim(@fldr)+')' +
/9134c                             ' OVRSCOPE(*CALLLVL' + %trim(Ovrdb3)
J2470c                   EndIf

/9134c                   callp(e)  QCmdExc(%trim(cmdLin):%len(%trim(cmdLin)))
/9518
/9518C                   OPEN      MSPLDAT                              81
J3234c                   EndIf

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSFLD        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CLSFLD' : blnDebug )
     C                   CLOSE     MSPLDAT
     C     DLTOV1        CAT(P)    'MSPLDA':0    CMDLIN
     C                   CAT       'T)':0        CMDLIN
     C                   EXSR      RUNCL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     REDATR        BEGSR
J2469c                   Callp(e)  SubMsgLog( FALSE : 'REDATR' : blnDebug )

     C                   MOVE      ' '           COMPRS            1
     C     PLCSFA        SUB       1             FRRN
     C                   EXSR      DEVCHN

     C     FILLOC        IFEQ      '2'
     C     RCPACK        ANDEQ     *BLANKS
     C                   MOVE      '0'           RCPACK
     C                   END

     C                   MOVE      RCPACK        HCMPRS            1
     C     RCPACK        IFNE      ' '
     C     RCPACK        ANDNE     '0'
     C                   Z-ADD     RC#RCS        #MXRRN
     C                   END

     c                   clear                   RcvVar
     c                   eval      rc = getArcAtr(Spynum:%addr(RcvVar):
     c                              %size(RcvVar):0)
     c                   if        rc < #SPL_OK
     c                   eval      @msgid = 'ERR0172'
     c                   callp     $EXPMSG
     c                   exsr      quit
     c                   endif

/8603 * Get the ASCII translate table again because we now have the
/     * report's code page attribute
/    c                   exsr      $getAscii

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     TSTAMP        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'TSTAMP' : blnDebug )
      *          Timestamp the RDstHst record for the report segment
      *          Use TBLNAM (*entry PTABLE) to chain to SegHdr and
      *              pick up the segment name (SHSEG).
      *          Use the SPY# and SHSEG to get DstHst record(s).
      *          Update the date & time (DHPDT & DHPTM).

     C     TBLNAM        CABEQ     *BLANK        ENDTIM

     C                   OPEN      RSEGHDR2
     C     TBLNAM        CHAIN     RSEGHDR2                           50
     C     *IN50         CABEQ     *ON           ENDTIM

     C                   TIME                    CTIME
     C                   TIME                    TIMSTP
     C                   MOVE      CCCC          YYYY
     C                   OPEN      RDSTHST
     C     HSTKEY        KLIST
     C                   KFLD                    REPIND
     C                   KFLD                    SHSEG
     C     HSTKEY        SETLL     RDSTHST
     C     HSTKEY        READE     RDSTHST                                50

     C     *IN50         DOWEQ     *OFF
     C                   Z-ADD     CDATE         DHPDT
     C                   Z-ADD     CTIME         DHPTM
     C                   UPDATE    DSTHST
     C     HSTKEY        READE     RDSTHST                                50
     C                   ENDDO
     C     ENDTIM        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'QUIT' : blnDebug )

     C                   EXSR      CLRDQ

     C     OPNSPC        IFEQ      '1'
     C     IFLIST        ANDNE     '*NONE'
     c                   eval      spcpth = mlSubj
     C                   MOVEL     IFLIST        SPCOPC
     C                   CALL      SPYSPC        PLSPC
     C
     C                   CLEAR                   OPNSPC
     C     SPCMSG        IFNE      *BLANKS
     C                   MOVEL     SPCMSG        @MSGID
     C                   MOVEL     SPCDTA        EMSGDT
/2423c                   callp     $EXPMSG
     C                   ENDIF
     C                   ENDIF

     C     BENHER        CABEQ     ' '           QUIT0
     C     BENHER        CABEQ     '1'           QUIT1
     C     BENHER        CABEQ     '2'           QUIT2
     C     BENHER        CABEQ     '3'           QUIT3
     C     BENHER        CABEQ     '4'           QUIT4

     C     QUIT0         TAG
     C                   MOVE      '1'           BENHER            1
     C                   CLOSE     *ALL

     C     COMBIN        IFNE      'Y'
     C     @DEST         ANDEQ     'D'
     C                   MOVEL(P)  CL(6)         CMDLIN
     C                   EXSR      RUNCL
     C     OUTFIL        IFEQ      *BLANKS
     C     PRTF          ANDEQ     *BLANKS
     C                   MOVEL(P)  CL(7)         CMDLIN
     C                   EXSR      RUNCL
     C                   END
     C                   END

     C     QUIT1         TAG
     C                   MOVE      '2'           BENHER

     C     CL1092        IFEQ      '1'
     C                   MOVEL(p)  'CLOSEW'      PCOPCD
     C                   EXSR      MG1092
     C                   CLEAR                   CL1092
     C                   END

     C     QUIT2         TAG
     C                   MOVE      '3'           BENHER

     C     CL1090        IFEQ      'Y'
     C                   MOVE      *ON           ECLSP             1
     C                   Z-ADD     0             DTASIZ
     C                   CALL      'MAG1090'     PL1090
     C                   END

     C     QUIT3         TAG
     C                   MOVE      '4'           BENHER

     C     PRTASC        IFEQ      *ON
     C                   CALL      'MAG920'                             50
     C                   PARM      *ON           PRTASC            1
     C                   PARM      IDBNUM        BTCHNO           10
     C                   PARM      RQSPAG        STROFS            9 0
     C                   PARM      IDPFIL        @FILE            10
     C                   PARM      IDFLIB        @LIBR            10
     C                   PARM      'USRASCII'    OUTFIL           10
     C                   PARM      'QTEMP'       OUTLIB           10
     C                   PARM      '2'           OUTOBJ            1
     C                   PARM                    OUTTYP            1
     C                   PARM      'Q'           RTNCDE            7
     C                   PARM                    PRTINZ            1
     C                   PARM                    PAPSIZ           10
     C                   PARM      '*'           PRTFF             1
     C                   PARM                    PRTRST            1
     C                   PARM                    PRTDUP            1
     C                   PARM                    PRTORI            1
/2627C                   PARM                    PRTDRW            4
/6763C                   PARM                    PRTTXL            3 0
      *  FLUSH OUT THE IMAGE PRINT DTASTRAM
     C                   MOVEL(P)  'CLOSEW'      SPCOPC
     C                   CALL      'SPC2PRT'     PLSTRM

     C     RQPTYP        IFEQ      '*AFP'
     C     AFPIMG        OREQ      '1'
     C                   EXSR      CHGDUP
/2322C                   EXSR      CHGDRW
     C                   EXSR      CHGOUT
     C                   EXSR      RLSSPL
     C                   END
     C                   END
      *    IF IMAGE WAS FAXED AS AFP, CLOSE FAX
     C     AFPIMG        IFEQ      '1'
     C                   EXSR      CLSFAX
     C                   CLEAR                   AFPIMG
     C                   ENDIF

     C     PRTAFP        IFEQ      *ON
/2119C     TXTIMG        OREQ      '1'
     C                   MOVEL     'Q'           SPCRTN
     C                   CALL      'MAG921'      PL921
      *  FLUSH OUT THE IMAGE PRINT DATASTREAM
     C                   MOVEL(P)  'CLOSEW'      SPCOPC
     C                   CALL      'SPC2PRT'     PLSTRM
     C                   EXSR      CHGDUP
/2322C                   EXSR      CHGDRW
     C                   EXSR      CHGOUT
     C                   EXSR      RLSSPL
/2119C                   CLEAR                   TXTIMG
     C                   END

     C     QUIT4         TAG
     C                   MOVE      '5'           BENHER
     C                   CALL      'SPYCSNOT'
     C                   PARM                    A10              10
     C                   PARM                    A10
     C                   PARM                    A10
     C                   PARM                    A10
     C                   PARM                    A05               5
     C                   PARM                    N09               9 0
     C                   PARM                    N09
/813 C                   PARM                    N09               9 0
     C                   PARM                    SDT
     C                   PARM                    N09
     C                   PARM                    A02               2
     C                   PARM      'Y'           SETLR             1
     C                   PARM                    A01               1
     C                   PARM                    N09               9 0
     C                   PARM                    A01               1
/6609 *  If you have just completed a PRINT for an email to be sent via SpoolMail
/     *  This *lda value was set in MAG210 based on SYSENV settings, email options
/6609 *  and type of object being sent.  Now need to send the splf as an email via SPYMAIL
      /free

J4819                    Select;
J5953                      When ( ( IsSplMail = SPLMAIL  )        and
J5953                 //   When ( ( mlspml   = SPLMAIL   )        and
J4819                             ( @dest    = DESTPRINT )        and
J4819                             ( ( quspdt00 = PRTTY_SCS  ) or
J4819                               ( quspdt00 = PRTTY_LINE )    )    );
J4819                        ExSr SndSpoolMailSCS;
J4819
J5953                      When ( ( IsSplMail = SPLMAIL  )             and
J5953                  //  When ( ( mlspml   = SPLMAIL   )             and
J4819                             ( @dest    = DESTPRINT )             and
J4819                             ( ( quspdt00 = PRTTY_IPDS      ) or
J4819                               ( quspdt00 = PRTTY_AFPDS     ) or
J4819                               ( quspdt00 = PRTTY_AFPDSLINE )    )     );
J6642                        getJobTyp(jobType);
J6642                        if (jobType = '0' and @dest = 'Q') or
J6642                          @dest = DESTPRINT;
J4819                          ExSr SndSpoolMailAFP;
J6642                        endif;
J6449                      when (IsSplMail = SPLMAIL and
J6449                        blnNativeEmailAFP = TRUE);
J6449                         ExSr SndNativeEmailAFP;
J4819                    EndSl;
       /end-free
     C     QUIT5         TAG
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
J2469 /free
/       //--------------------------------------------------------------
/       BegSr SndNativeEmailAFP;
/       //--------------------------------------------------------------
/       // Send AFP Spooled files natively                             -
/       //--------------------------------------------------------------
J2469   Callp(e)  SubMsgLog( blnDebug : 'SndNativeEmailAFP' : blnDebug ) ;
/       If blnDistribution = TRUE;
/
/         Reset dsDstDef;
/
/         // Get the Subscriber to build the key to
/         // retrieve the bundle ID
/
/         dsDstDef.RdSubr = %subst(Mlto:1:10);
/
/         // Get the Segment to build the key to
/         // Retrieve the bundle ID from the RSegHdr2
/
/         If NOT %Open(RSegHdr2);
/           Open(e) RSegHdr2;
/
/           If %Error = TRUE;
              dsErrorCode.MsgID = 'ERR1169';
/             strErrorLog =  MMMSGIO_RtvMsgTxt( dsErrorCode.MsgId
/                                         : dsErrorCode.MsgDta
/                                         : 'PSCON' );
/             MMMSGIO_SndMsgTxt( strErrorLog );
              LeaveSr;
/           EndIf;
/
/         EndIf;
/
/         Chain(e) TblNam RSegHdr2;
/
/         If %Found = TRUE;
/           dsDstDef.RdRept = ShRept;
/           dsDstDef.RdSeg  = ShSeg;
/         Else;
/           dsErrorCode.MsgID = 'ERR0009'; // Segment for report skippped
/           dsErrorCode.MsgDta = dhseg + dhrept + dhrep;
/           strErrorLog =  MMMSGIO_RtvMsgTxt( dsErrorCode.MsgId
/                                           : dsErrorCode.MsgDta
/                                           : 'PSCON' );
/           MMMSGIO_SndMsgTxt( strErrorLog );
            LeaveSr;
/         EndIf;
/
/         Close(e) RSegHdr2;
/
/         If NOT %Open(RDstDef);
/           Open(e) RDstDef;
/         EndIf;
/
/         Chain (dsDstDef.RdSubr:dsDstDef.RdRept:dsDstDef.RdSeg) RDstDef;
/
/         If %found = TRUE;
/           wk_RptNam = RdBndl;
/         Else;
/           // Error Handle
/         EndIf;
/
/
/         ExSr OvrAttrs;
/
/         PrtAPFSpool(@fldr:@fldLb:RepInd:OfRNam:RepLoc:RcvVar:
/                     AfpFrm:AfpEnd:NoPagT:
/                     wk_RptNam:drawer:'OPEN');
/         #TSum = 1;
/         ExSr PrtSeg;
/         PrtAPFSpool(@fldr:@fldLb:RepInd:OfRNam:RepLoc:
/                     RcvVar:AfpFrm:AfpEnd:NoPagT:
/                     wk_RptNam:drawer:'CLOSE');
/
/         // Set the Report Name to the bundleID in wk_RptNam
/
/         MlRTyp = wk_RptNam;
/
/         // Since SpoolMail is only being used for PDF
/         // set the extension for PDF
/
/         MlExt = 'PDF';
/         mpt(1) = MMMSGIO_RtvMsgTxt( 'MAI0031' : dsErrorCode.MsgDta : 'PSCON');
/         mpt(2) = MMMSGIO_RtvMsgTxt( 'MAI0032' : dsErrorCode.MsgDta : 'PSCON');
/         mpt(3) = MMMSGIO_RtvMsgTxt( 'MAI0033' : dsErrorCode.MsgDta : 'PSCON');
/         mpt(4) = MMMSGIO_RtvMsgTxt( 'MAI0034' : dsErrorCode.MsgDta : 'PSCON');
/         mpt(5) = MMMSGIO_RtvMsgTxt( 'MAI0035' : dsErrorCode.MsgDta : 'PSCON');
/       ElseIf ( blnDistribution = FALSE );  // Distribution is off
/
/         // Close the report and delete the override
/         Close #report#;
/         cmdOScmd = 'DLTOVR FILE(#REPORT#) LVL(*JOB)';
/
/         If ( Run(%trimr(cmdOScmd)) <> OK );
/           strErrorLog = 'Issue deleting override';
/           MMMSGIO_SndMsgTxt( strErrorLog );
/           LeaveSr;
/         EndIf;
/
/       EndIf;
/
/       // Capture the spooled file to the IFS
/
/       SpyPath('*MAILTMP' : strAFPPath );
/
/       If ( EntCnt <= 0 );
          EntCnt = 1;
        EndIf;

/       For intEntCnt = 1 to EntCnt;
/         If intEntCnt = 1;
/           strGetFileName = GetFileName( strAFPPath
/                                        : @FilNa : 'PDF' : 'Y' );
/         Else;
/           strGetFileName = GetFileName( strAFPPath
/                                        : @FilNa + '(' + %char(intEntCnt) +
                                         ')' : 'PDF' : 'Y' );
          EndIf;
/
          If mlcdpg = *blanks;
/           mlcdpg = MLCDPG_DOS;
/         EndIf;
/
/         strAFPPDFPathFile = %trim(strAFPPath) + '/'
/                           + %trim(strGetFileName) + x'00';
/
/         If ( access( strAFPPDFPathFile : F_OK ) = 0 );
/           unlink( strAFPPDFPathFile );
/         EndIf;
/
/         Reset dsErrorCode;
/
/         If wk_rptnam = *blanks;
/           wk_rptnam = @filna;
/         EndIf;
/
/         Callp(e) MgAFP2PDF( wk_rptnam
/                   : ThisJobName
/                   : WQUsrN
/                   : Jnr
/                   : -1
/                   : strAFPPath
/                   : strGetFileName
/                   : %int(mlcdpg)
/                   : dsErrorCode.MsgID
/                   : dsErrorCode.MsgDta );
/
/         // Test for missing spooled file
/
/         If ( dsErrorCode.MsgID <> *blanks );
/           strErrorLog =  MMMSGIO_RtvMsgTxt( dsErrorCode.MsgId
/                                           : dsErrorCode.MsgDta
/                                           : 'PSCON' );
/           MMMSGIO_SndMsgTxt( strErrorLog );
/           leaveSr;
/         EndIf;
/
/         If ( intEntCnt = 1 );
/           MLOPCD = MLOPCD_OPEN;
/           ExSr SPMAIL;
/         EndIf;

/         stat( %addr(strAFPPDFPathFile) : %addr(stat_ds) );
/         fd = IFSopen(strAFPPDFPathFile : O_RDONLY : S_IRWXU );
/
/         If ( fd < 1 );
/           dsErrorCode.MsgID = 'ERR1824';
/           strErrorLog = MMMSGIO_RtvMsgTxt( dsErrorCode.MsgId
/                                          : dsErrorCode.MsgDta
/
                                           : 'PSCON' );
/           MMMSGIO_SndMsgTxt( strErrorLog );
/           LeaveSr;
/         EndIf;
/
/         bytrem = st_size;
/         clear mldta;
/         mlext = 'PDF';
/
/         If ( blnDistribution = TRUE );
/           mlrtyp = shrept;
/           mlseg  = shSeg;
/           mlpgtb = tblnam;
/         Else;
/           mlrtyp = rtypid;
/         EndIf;
/
/         // Send the attachment
/         mlstm = 'BIN';
/         spyMail(mldta:mldtle:'OPNATT':mlto:mltype:mlfrm:mlsubj:mpt:mlrtn);
/         dtalen = 5700;
/         clear mldta;
/
/         Dow bytrem > 0;
/
/           dtalen =  IFSRead( fd : %addr(mldta): %size(mldta) );
/
/           If ( dtalen > 0 );
/             mldtle = dtalen;
/             spyMail(mldta : mldtle : 'WRTATT' : mlto : mltype
/                   : mlfrm : mlsubj : mpt : mlrtn);
/           EndIf;
/
/           bytrem -= dtalen;
/
/           If bytrem <  %size(mldta);
/             dtalen = bytrem;
/           EndIf;
/
/         EndDo;
/
/         IFSclose(fd);
/         unlink(strAFPPDFPathFile);
/         MLOPCD = MLOPCD_CLSATT;
/         ExSr SPMAIL;
/
/         // Delete the spooled file
/
/         cmdOScmd = 'DLTSPLF FILE('
/                 + %trim(@FilNa)
/                 + ') JOB('
/                 + JNR + '/'
/                 + %trim(WQUsrN) + '/'
/                 + %trim(ThisJobName) + ') '
/                 + ' SPLNBR(*LAST)';
/
/         If ( Run(%trimr(cmdOScmd)) <> OK );
/           strErrorLog = 'Issue deleting spooled file';
/           MMMSGIO_SndMsgTxt( strErrorLog );
/           LeaveSr;
/         EndIf;
/
/       EndFor;
/
/       MLOPCD = MLOPCD_CLOSE;
/       ExSr SPMAIL;
/
/      EndSr;
/     /end-free
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : '*INZ' : blnDebug )

     C     *DTAARA       DEFINE    *LDA          LDA
     C                   IN        LDA
     C                   IN        SYSDFT
/2732 *
/2732 * Retrieve date format
/2732C                   CALL      'MAG8090'
/2732C                   PARM                    DATFMT            3
/2732C                   PARM                    DATSEP            1
/2732C                   PARM                    TIMSEP            1
/2732 *
/2732C     DATFMT        IFEQ      *BLANKS
/2732C                   MOVE      'MDY'         DATFMT
/2732C                   ENDIF

      * Get page separator for eMail
     C                   MOVE      'MAI0000'     @MSGID
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        PAGSEP          200
      *                                                    Local Data
     C                   SELECT
     C     MLIND         WHENEQ    '*EMAIL'
     C                   MOVE      'M'           @DEST             1
     C     MLIND         WHENEQ    '*IFS'
     C                   MOVE      'I'           @DEST             1
     C     FAXNUM        WHENNE    *BLANK
     C                   MOVE      'F'           @DEST             1
     C     OUTFIL        WHENGT    *BLANK
     C                   MOVEL     'D'           @DEST
     C                   OTHER
     C                   MOVEL     'P'           @DEST
     C                   ENDSL

     C                   MOVE      @DEST         DESTSV            1

     C                   CALL      'SPYLOUP'
     C                   PARM                    LO               60
     C                   PARM                    UP               60

      * determine ignore bad batch
/3393c                   if        mlIgBa <> 'N' and mlIgBa <> 'Y'
/    c                   eval      Ignbatch = 'N'
/    c                   else
/    c                   eval      Ignbatch = mlIgBa
/    c                   end

      *      Get EBDIC to ASCII translation table for current codepage
/2119C                   exsr      $GetAscii

      * Retrieve overstrike characters
     C                   CALL      'MAG103C'
     C                   PARM                    OCLEN             3 0
     C                   PARM                    OCSTR            99

     C                   ENDSR
/2119 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2119C     $GetAscii     BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : '$GetAscii' : blnDebug)

      * Get EBCDIC to ASCII translate table.
      * /8603: Reworked to use the report code page (if present) and
      *        PDF code page if the mail code page was not specified.

/7201 * Set up translation array (x'00' - x'ff')
/    c                   eval      convrt = 0
/    c                   dow       convrt < %elem(FrmTbl)
/    c                   eval      FrmTbl(convrt+1) = cnvrt1
/    c                   eval      convrt = convrt + 1
/    c                   enddo

      * Set from-code page value
     c                   if        @CODPA <> *blanks and @CODPA <> '*DEVD'
     c                   eval      FrmCdePag = %subst(@CODPA:6:5)
     c                   else
     c                   eval      FrmCdePag = '00000'
     c                   endif

      * Set to-code page value. If not passed in, use PDF code page.
/2497c                   if        MLCdPg <> *blanks and MLCdPg <> *zeros
     c                   eval      ToCdePag = MlCdPg
     c                   else
     c                   eval      ToCdePag = PDF_ENC_CP
     c                   endif

/2497c                   CALL      'SPYCDPAG'
/2199c                   PARM                    FrmCdePag         5
/    c                   PARM                    ToCdePag          5
/    c                   PARM                    FrmTbl
/    c                   PARM                    ToTbl

/2119C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKDLT        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CHKDLT' : blnDebug )

      *  Get date for last cleanup
     C     *DTAARA       DEFINE                  ENVDFT
     C                   IN        ENVDFT

     C     FSTCLN        IFEQ      *BLANKS
     C     *LOCK         IN        ENVDFT
     C                   MOVE      *YEAR         FSTYYY
     C                   MOVE      UMONTH        FSTMM
     C                   MOVE      UDAY          FSTDD
     C                   OUT       ENVDFT
     C                   END

     C                   MOVE      FSTYYY        DJJJJ
     C                   MOVE      FSTMM         DMM
     C                   MOVE      FSTDD         DTT

     C     DJJJJ         IFNE      *YEAR
     C     DMM           ORNE      UMONTH
     C     DTT           ORNE      UDAY
      *  MAG1400D calculates the day number since 1900  in DWT
     C                   CLEAR                   DWT
     C                   CALL      'MAG1400D'    PL14D                  50
     C                   Z-ADD     DWT           LSTDLT            5 0

     C                   Z-ADD     *YEAR         DJJJJ
     C                   Z-ADD     UMONTH        DMM
     C                   Z-ADD     UDAY          DTT
     C                   CLEAR                   DWT
     C                   CALL      'MAG1400D'    PL14D                  50
     C                   Z-ADD     DWT           TODAY             5 0
     C     TODAY         SUB       1             YESTER            5 0

     C     LSTDLT        IFEQ      0
     C     YESTER        SUB       1             LSTDLT
     C                   END

     C                   CLEAR                   ERRDLT

      * Delete all folders since last clean up
     C     LSTDLT        IFLT      TODAY
     C     LSTDLT        DO        YESTER        DLTDAY            5 0
     C                   Z-ADD     0             DJJJJ
     C                   Z-ADD     0             DMM
     C                   Z-ADD     0             DTT
     C                   Z-ADD     DLTDAY        DWT
     C                   CALL      'MAG1400D'    PL14D                  50
      * Check if folder exists
     C     'CHKDLO'      CAT(P)    'DLO(D':1     CMDLIN
     C                   MOVE      DJJJJ         F2A               2
     C                   CAT       F2A:0         CMDLIN
     C                   MOVE      DMM           F2A               2
     C                   CAT       F2A:0         CMDLIN
     C                   MOVE      DTT           F2A               2
     C                   CAT       F2A:0         CMDLIN
     C                   CAT       ') FL':0      CMDLIN
     C                   CAT       'R(''':0      CMDLIN
     C                   CAT       FXROOT:0      CMDLIN
     C                   CAT       ''')':0       CMDLIN

     C                   EXSR      RUNCL
     C   81              EXSR      RMVMSG

      * Folder exists. delete it
     C     *IN81         IFEQ      *OFF
     C     'DLTDLO'      CAT(P)    'DLO(*A':1    CMDLIN
     C                   CAT       'LL) FL':0    CMDLIN
     C                   CAT       'R(''':0      CMDLIN
     C                   CAT       FXROOT:0      CMDLIN
     C                   CAT       '/D':0        CMDLIN
     C                   MOVE      DJJJJ         F2A               2
     C                   CAT       F2A:0         CMDLIN
     C                   MOVE      DMM           F2A               2
     C                   CAT       F2A:0         CMDLIN
     C                   MOVE      DTT           F2A               2
     C                   CAT       F2A:0         CMDLIN
     C                   CAT       ''')':0       CMDLIN
     C                   EXSR      RUNCL
     C     *IN81         IFEQ      *ON
     C                   MOVE      *ON           ERRDLT            1
     C                   END
     C                   END

     C                   ENDDO

     C     ERRDLT        IFEQ      ' '
      * Write last clean up to ENVDFT
     C     *LOCK         IN        ENVDFT
     C                   MOVE      *YEAR         FSTYYY
     C                   MOVE      UMONTH        FSTMM
     C                   MOVE      UDAY          FSTDD
     C                   OUT       ENVDFT
     C                   END
     C                   END
     C                   END

     C     PL14D         PLIST
     C                   PARM                    DTT               2 0
     C                   PARM                    DMM               2 0
     C                   PARM                    DJJJJ             4 0
     C                   PARM                    DWT               5 0
     C                   PARM                    DGK               1
     C                   PARM                    DWOT             10
     C                   PARM                    DWOK              2
     C                   PARM                    DMON              9
     C                   PARM                    DMOK              3
     C                   PARM                    DTAGJ             3 0
     C                   PARM                    DKW               2 0
     C                   PARM                    DTAGNR            1 0
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSFAX        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'CLSFAX' : blnDebug )
      *          FaxTyp 1,4,5,6 &9 output END rec to report.
      *          FaxTyp 2,7,8,A build Cmd and run it.

      * Put xattach statements
     C                   SELECT
     C     FAXTYP        WHENEQ    '1'
     C                   DO        #TI           IX                5 0
     C     XF(IX)        IFEQ      *BLANKS
     C                   LEAVE
     C                   ENDIF
     C                   MOVEL     XF(IX)        XATFIL          100
     C     FTCP          IFNE      'Y'
J2144C                   in(e)     dltfaxatt
/    C                   if        not %error and dltfaxatt = 'Y'
/    C                   except    fximg1d
/    C                   else
     C                   EXCEPT    FXIMG1
J2144C                   endif
     C                   ELSE
     C                   EXCEPT    FXIMGF
     C                   ENDIF
     C                   ENDDO
     C                   ADD       1             PAGE#
/5469c                   callp     SplLine('1':'**END')
     C     FAXTYP        WHENEQ    '4'
     C                   DO        #TI           IX                5 0
/2119C     XF(IX)        IFNE      *BLANKS
     C                   MOVEL     XF(IX)        XATFIL
/6302c                   Eval      XATFIL =
/    c                             '/QDLS/' + %trim(XATFIL)
     C                   EXCEPT    FXIMG4

      * More images, skip to new page
/4492C*    #TI           IFGT      IX
/    C*                  EXCEPT    NEWPAG
/    C*                  END
     C                   ENDIF
     C                   ENDDO

     C     FAXTYP        WHENEQ    '6'
     C                   DO        #TI           IX
     C                   MOVEL     XF(IX)        XATFIL
     C                   EXCEPT    FXIMG6
     C                   ENDDO
     C                   ENDSL

     C     FAXTYP        IFEQ      '5'
     C                   ADD       1             PAGE#
/5469c                   callp     SplLine('1':'&&& END')
     C                   END
     C     FAXTYP        IFEQ      '9'
     C                   ADD       1             PAGE#
/5469c                   callp     SplLine('1':'**END')
     C                   END

      * COMMAND based faxes
     C     FAXTYP        IFEQ      '2'
     C     PRMFAX        IFEQ      'Y'
     C     '?'           CAT(P)    CL(10):0      CMDNAM
     C                   ELSE
     C                   MOVEL(P)  CL(10)        CMDNAM
     C                   END
     C     CMDNAM        CAT(P)    'TO((''':1    CMDLIN
     C                   CAT       FAXNUM:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C     FAXTO         IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTO:0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C     FAXTX1        IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTX1:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C     FAXTX2        IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTX2:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C                   CAT       '))':0        CMDLIN
     C                   CAT       'FILE(':1     CMDLIN
     C                   CAT       RPTNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CAT       'JOB(*)':1    CMDLIN

     C                   CAT       'SPLNBR':1    CMDLIN
     C                   CAT       '(*LAST':0    CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   CAT       'CRTCVR':1    CMDLIN
     C                   CAT       'P(':0        CMDLIN
     C                   CAT       '*YES)':0     CMDLIN

     C                   CAT       'CVRPRT':1    CMDLIN
     C                   CAT       'F(':0        CMDLIN
     C     FCPRTF        IFEQ      *BLANKS
     C     FCPRTL        ANDEQ     *BLANKS
     C                   CAT       '*DFT':0      CMDLIN
     C                   ELSE
     C     FCPRTL        IFNE      *BLANKS
     C                   CAT       FCPRTL:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   END
     C                   CAT       FCPRTF:0      CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN

     C     FAXRE         IFNE      *BLANKS
     C                   CAT       'TITLE(':1    CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       FAXRE:0       CMDLIN
     C                   CAT       ''')':0       CMDLIN
     C                   END

     C     FAXFRM        IFNE      *BLANKS
     C     FAXTX3        ORNE      *BLANKS
     C     FAXTX4        ORNE      *BLANKS
     C                   CAT       'FROM(':1     CMDLIN

     C     FAXFRM        IFNE      *BLANKS
     C                   CAT       '''':0        CMDLIN
     C                   CAT       FAXFRM:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END

     C     FAXTX3        IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTX3:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END

     C     FAXTX4        IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTX4:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END

     C                   CAT       ')':0         CMDLIN
     C                   END

     C     FAXTX5        IFNE      *BLANKS
     C                   CAT       'COMMEN':1    CMDLIN
     C                   CAT       'T(''':0      CMDLIN
     C                   CAT       FAXTX5:0      CMDLIN
     C                   CAT       ''')':0       CMDLIN
     C                   END

     C                   CLOSE     #REPORT#                             50
     C                   MOVE      *OFF          OPENED

     C                   EXSR      RUNCL
     C                   ENDIF

     C     FAXTYP        IFEQ      'A'
     C     PRMFAX        IFEQ      'Y'
     C     '?'           CAT(P)    CL(45):0      CMDNAM
     C                   ELSE
     C                   MOVEL(P)  CL(45)        CMDNAM
     C                   ENDIF

     C     CMDNAM        CAT(P)    'TO(''':1     CMDLIN
     C                   CAT       FAXNUM:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C     FAXTO         IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTO:0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C     FAXTX1        IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTX1:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C     FAXTX2        IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTX2:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN
     C                   CAT       'FILE(':1     CMDLIN
     C                   CAT       RPTNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CAT       'JOB(*)':1    CMDLIN

     C                   CAT       'SPLNBR':1    CMDLIN
     C                   CAT       '(*LAST':0    CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   CAT       'CRTCVR':1    CMDLIN
     C                   CAT       'P(':0        CMDLIN
     C                   CAT       '*YES)':0     CMDLIN

     C                   CAT       'CVRPRT':1    CMDLIN
     C                   CAT       'F(':0        CMDLIN
     C     FCPRTF        IFEQ      *BLANKS
     C     FCPRTL        ANDEQ     *BLANKS
     C                   ELSE
     C     FCPRTL        IFNE      *BLANKS
     C                   CAT       FCPRTL:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   END
     C                   CAT       FCPRTF:0      CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN

     C     FAXRE         IFNE      *BLANKS
     C                   CAT       'TITLE(':1    CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       FAXRE:0       CMDLIN
     C                   CAT       ''')':0       CMDLIN
     C                   END

     C     FAXFRM        IFNE      *BLANKS
     C     FAXTX3        ORNE      *BLANKS
     C     FAXTX4        ORNE      *BLANKS
     C                   CAT       'FROM(':1     CMDLIN

     C     FAXFRM        IFNE      *BLANKS
     C                   CAT       '''':0        CMDLIN
     C                   CAT       FAXFRM:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END

     C     FAXTX3        IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTX3:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END

     C     FAXTX4        IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTX4:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END

     C                   CAT       ')':0         CMDLIN
     C                   END

     C     FAXTX5        IFNE      *BLANKS
     C                   CAT       'COMMEN':1    CMDLIN
     C                   CAT       'T(''':0      CMDLIN
     C                   CAT       FAXTX5:0      CMDLIN
     C                   CAT       ''')':0       CMDLIN
     C                   END

     C                   CAT       'DEST(':1     CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       FAXNUM:0      CMDLIN
     C                   CAT       ''')':0       CMDLIN

     C                   CAT       CL(46):1      CMDLIN

     C                   CLOSE     #REPORT#
     C                   MOVE      *OFF          OPENED

     C                   EXSR      RUNCL
     C                   ENDIF

     C     FAXTYP        IFEQ      '7'
     C     APFTYP        IFEQ      *BLANKS
     C     PRMFAX        IFEQ      'Y'
     C     '?'           CAT(P)    CL(36):0      CMDNAM           11
     C                   ELSE
     C                   MOVEL(P)  CL(36)        CMDNAM
     C                   END
     C     CMDNAM        CAT(P)    'SPF(':1      CMDLIN
     C                   CAT       RPTNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   CAT       'DESC(':1     CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       FAXRE:0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   CAT       'DIAL(':1     CMDLIN
     C                   CAT       '*N':0        CMDLIN
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXNUM:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C     FAXTO         IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTO:0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN

     C     FCVRID        IFNE      *BLANKS
     C                   CAT       'CVRID(':1    CMDLIN
     C                   CAT       FCVRID:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C     FAXFRM        IFNE      *BLANKS
     C                   CAT       'USER(':1     CMDLIN
     C                   CAT       FAXFRM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C     FRMNAM        IFNE      *BLANKS
     C                   CAT       'APPL(':1     CMDLIN
     C                   CAT       FRMNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C                   CLOSE     #REPORT#
     C                   MOVE      *OFF          OPENED

     C                   EXSR      RUNCL

     C                   ELSE
     C     PRMFAX        IFEQ      'Y'
     C     '?'           CAT(P)    CL(37):0      CMDNAM
     C                   ELSE
     C                   MOVEL(P)  CL(37)        CMDNAM
     C                   END
     C     CMDNAM        CAT(P)    'SPF(':1      CMDLIN
     C                   CAT       RPTNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   CAT       'DESC(':1     CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       FAXRE:0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   CAT       'DIAL(':1     CMDLIN
     C                   CAT       '*N':0        CMDLIN
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXNUM:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C     FAXTO         IFNE      *BLANKS
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTO:0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   END
     C                   CAT       ')':0         CMDLIN

     C     FCVRID        IFNE      *BLANKS
     C                   CAT       'CVRID(':1    CMDLIN
     C                   CAT       FCVRID:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C     FAXFRM        IFNE      *BLANKS
     C                   CAT       'USER(':1     CMDLIN
     C                   CAT       FAXFRM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C     FRMNAM        IFNE      *BLANKS
     C                   CAT       'APPL(':1     CMDLIN
     C                   CAT       FRMNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C                   CLOSE     #REPORT#
     C                   MOVE      *OFF          OPENED
     C                   EXSR      RUNCL
     C                   ENDIF
     C                   ENDIF

     C     FAXTYP        IFEQ      '8'
     C     RQOBTY        IFEQ      'I'
     C                   MOVEL     XF(1)         IMGNMN
     C     CL(39)        CAT(P)    'FOLDER':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       EDIR8:0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CAT       CL(44):1      CMDLIN
     C                   CAT       '*GEN':0      CMDLIN
     C                   CAT       CL(47):0      CMDLIN
     C                   CAT       '*YES)':0     CMDLIN
     C                   CAT       CL(58):1      CMDLIN
     C                   CAT       CL(40):1      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       XF(1):0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C     2             DO        #TI           IX                5 0
     C                   CAT       '''':1        CMDLIN
     C                   CAT       XF(IX):0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   ENDDO
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL

     C     *IN81         IFEQ      '1'
     C                   EXSR      RCVMSG
     C                   MOVE      MINMID        @MSGID
     C                   MOVEL(P)  'FAXMSGF'     EMSGF
     C                   MOVEL(P)  'FAXLIB'      EMSGFL
     C                   MOVEL(P)  MINDTA        EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   ELSE
     C                   EXSR      RCVMSG
     C                   ENDIF
      *                                                    (faxfil)
     C                   ENDIF

     C     PRMFAX        IFEQ      'Y'
     C     '?'           CAT(P)    CL(38):0      CMDNAM
     C                   ELSE
     C                   MOVEL(P)  CL(38)        CMDNAM
     C                   END
     C     CMDNAM        CAT(P)    'FROM':1      CMDLIN
     C                   CAT       'NAME(':0     CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       FAXFRM:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       ')':0         CMDLIN

     C                   CAT       'DEST':1      CMDLIN
     C                   CAT       '((':0        CMDLIN
     C                   CAT       '*N':0        CMDLIN
     C                   CAT       CUS#:1        CMDLIN
     C                   CAT       CUS#:1        CMDLIN
     C                   CAT       '1':1         CMDLIN
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXNUM:0      CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       '''':1        CMDLIN
     C                   CAT       FAXTO:0       CMDLIN
     C                   CAT       '''':0        CMDLIN
     C                   CAT       '))':0        CMDLIN

     C     RQOBTY        IFEQ      'I'
     C                   CAT       CL(41):1      CMDLIN
     C                   CAT       INTIMG:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CAT       CL(43):1      CMDLIN
     C                   CAT       FAXFIL:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   ELSE
     C                   CAT       'FILE(':1     CMDLIN
     C                   CAT       RPTNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C     APFTYP        IFNE      *BLANKS
     C                   CAT       CL(41):1      CMDLIN
     C                   CAT       AFPSPL:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   ENDIF
     C                   ENDIF

     C     FAXRE         IFNE      *BLANKS
     C                   CAT       'RE':1        CMDLIN
     C                   CAT       'MARKS':0     CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   CAT       FAXRE:0       CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   END

     C     CVRSHT        IFNE      *BLANKS
     C                   CAT       'COVER':1     CMDLIN
     C                   CAT       'IMG(':0      CMDLIN
     C                   CAT       CVRSHT:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   ENDIF

     C     FRMNAM        IFNE      *BLANKS
     C                   CAT       'OVER':1      CMDLIN
     C                   CAT       'LAY(':0      CMDLIN
     C                   CAT       FRMNAM:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   ENDIF

     C     FAXHC         IFNE      *BLANKS
     C                   CAT       'COLUMN':1    CMDLIN
     C                   CAT       'S(':0        CMDLIN
     C                   CAT       FAXHC:0       CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   ENDIF

     C     FAXVC         IFNE      *BLANKS
     C                   CAT       'LINES(':1    CMDLIN
     C                   CAT       FAXVC:0       CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   ENDIF

     C     FAXSTY        IFNE      *BLANKS
     C                   CAT       'ORIENT':1    CMDLIN
     C                   CAT       '(':0         CMDLIN
     C                   SELECT
     C     FAXSTY        WHENEQ    'AUTO'
     C                   CAT       '*AUTO':0     CMDLIN
     C     FAXSTY        WHENEQ    'PORT'
     C     FAXSTY        OREQ      '*NO'
     C     FAXSTY        OREQ      'NO'
     C     FAXSTY        OREQ      'N'
     C                   CAT       '*PORT':0     CMDLIN
     C                   CAT       'RAIT':0      CMDLIN
     C     FAXSTY        WHENEQ    'LAND'
     C     FAXSTY        OREQ      '*YES'
     C     FAXSTY        OREQ      'YES'
     C     FAXSTY        OREQ      'Y'
     C                   CAT       '*LAND':0     CMDLIN
     C                   CAT       'SCAPE':0     CMDLIN
     C                   OTHER
     C                   CAT       '*N':0        CMDLIN
     C                   ENDSL
     C                   CAT       ')':0         CMDLIN
     C                   ENDIF

     C                   CAT       'DLTAFT':1    CMDLIN
     C                   CAT       'SND(':0      CMDLIN
     C                   CAT       '*YES)':0     CMDLIN

     C                   CLOSE     #REPORT#
     C                   MOVE      *OFF          OPENED
     C                   EXSR      RUNCL
     C                   END

/8527c                   if        faxtyp = 'B' and apftyp <= '0'
/6924C                   CLOSE     #REPORT#
/    C                   MOVE      *OFF          OPENED
/8527c                   exsr      sbmsplfaxb
/6924c                   endif

      * COMMAND based faxes
     C     FAXTYP        IFEQ      '2'
     C     FAXTYP        OREQ      'A'
     C     FAXTYP        OREQ      '7'
     C     FAXTYP        OREQ      '8'
/6924c     faxtyp        oreq      'B'

/2576c                   If        ( ( faxtyp = 'B'         ) and
/    c                               ( blnSplFAXBErr = TRUE )     )
/    c                   Eval      PrmFAX = 'E'
/    C                   Out       LDA
/    c                   ElseIf    ( ( *in81 = TRUE )         and
     c                               ( faxtyp <> 'B' )            )
/    c                   Eval      PrmFAX = 'E'
     C                   Out       LDA
     C                   EndIf

     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     EXTWIN        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'EXTWIN' : blnDebug )
      *          ----------------------------------
      *          Get an External Window Environment
      *          only for DTAQ, for non join get it from LDA
      *          ----------------------------------
     C     ENVUSR        IFEQ      '*CURRENT'
     C     ENVUSR        OREQ      *BLANKS
     C                   MOVE      WQUSRN        ENVUS            10
     C                   ELSE
     C                   MOVE      ENVUSR        ENVUS
     C                   END

     C                   OPEN      MRPTDIR7
     C     SPYNUM        CHAIN     RPTDIR                             50
     C                   CLOSE     MRPTDIR7

     C                   OPEN      RWINDOW
     C     RWINKE        CHAIN     WINRC                              45
     C                   CLOSE     RWINDOW
     C     *IN45         IFEQ      *OFF
     C                   CLEAR                   ENVIRO
     C                   MOVE      WESP1         ENVI01
     C                   MOVE      WESP2         ENVI02
     C                   MOVE      WESP3         ENVI03
     C                   MOVE      WESP4         ENVI04
     C                   MOVE      WESP5         ENVI05
     C                   MOVE      WESP6         ENVI06
     C                   MOVE      WESP7         ENVI07
     C                   MOVE      WESP8         ENVI08
     C                   MOVE      FILNAM        LFILNA
     C                   MOVE      JOBNAM        LJOBNA
     C                   MOVE      PGMOPF        LPGMOP
     C                   MOVE      USRNAM        LUSRNA
     C                   MOVE      USRDTA        LUSRDT
     C                   MOVE      ECWSC         $WSC
     C                   MOVE      ECWW          $WW
     C                   Z-ADD     ENUMWN        NUMWND
     C                   END
     C                   ENDSR

     C     RWINKE        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C                   KFLD                    ENVUS            10
     C                   KFLD                    ENVNAM           10

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRICVR        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'SRICVR' : blnDebug )

      * Convert text into ascii usrspc
     C                   CALL      'MAG920'                             50
     C                   PARM      '2'           PRTASC            1
     C                   PARM                    BTCHNO           10
     C                   PARM                    STROFS            9 0
     C                   PARM      'SPYCVR'      SPCNAM           10
     C                   PARM      'QTEMP'       SPCLIB           10
     C                   PARM      'USRASCII'    OUTFIL           10
     C                   PARM      'QTEMP'       OUTLIB           10
     C                   PARM      '2'           OUTOBJ            1
     C                   PARM                    OUTTYP            1
     C                   PARM      *BLANKS       RTNCDE            7
     C                   PARM                    PRTINZ            1
     C                   PARM                    PAPSIZ           10
     C                   PARM      '*'           PRTFF             1
     C                   PARM                    PRTRST            1
     C                   PARM                    PRTDUP            1
     C                   PARM                    PRTORI            1
/2627C                   PARM                    PRTDRW            4
/6763C                   PARM                    PRTTXL            3 0

     C                   MOVE      '0'           PRTINZ

     C     RTNCDE        IFNE      *BLANKS
     C                   MOVEL     RTNCDE        @MSGID
     C                   MOVE      *BLANKS       EMSGDT
/2423c                   callp     $EXPMSG
     C                   EXSR      QUIT
     C                   END

      *  Copy usrspc to printer output
     C                   CALL      'SPC2PRT'     PLSTRM                 50
     C     PLSTRM        PLIST
     C                   PARM      'USRASCII'    SPCNAM           10
     C                   PARM      'QTEMP'       SPCLIB           10
     C                   PARM                    SPCTYP           10
     C                   PARM                    SPCOPC           10
     C                   PARM                    SPCRTN            7

     C                   MOVE      *ON           PRTASC            1
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FXTYP6        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FXTYP6' : blnDebug )
      *          DirectFax

     C                   MOVE      *BLANKS       RCD
     C                   ADD       1             PAGE#
/5469c                   callp     SplLine('1':*blanks)
/5469c                   callp     SplLine('-':*blanks)
/5469c                   callp     SplLine('-':*blanks)
     C                   CALL      'MAG1047'
     C                   PARM                    YMDNUM            9 0
     C                   PARM                    YMD               8
     C                   MOVE      'P001920'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN            3 0
     C     21            SUB       @MSGLN        #T
/2732 *
/2732 * Format date
/2732C                   select
/2732C                   when      DATFMT = 'MDY'
     C     @MSGTX        CAT(P)    SMM:#T        CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       SDD:0         CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       SYYYY:0       CMDLIN
/2732C                   when      DATFMT = 'DMY'
/2732C     @MSGTX        CAT(P)    SDD:#T        CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SMM:0         CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SYYYY:0       CMDLIN
/2732C                   when      DATFMT = 'YMD'
/2732C     @MSGTX        CAT(P)    SYYYY:#T      CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SMM:0         CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SDD:0         CMDLIN
/2732C                   endsl
/2732 *
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001921'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXNUM:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001922'     @MSGID
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        CMDLIN
     C     RQOBTY        IFEQ      'I'
     C                   Z-ADD     #TI           PAGTOT
     C                   END

     C     PAGTOT        ADD       1             #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001923'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXFRM:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001924'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXTO:#T      CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001925'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXRE:#T      CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001926'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXTX1:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)
     C                   MOVE      *BLANKS       RCD
     C                   MOVEA     FAXTX2        RCD(22)
/5469c                   callp     SplLine(' ':rc2247)
     C                   MOVE      *BLANKS       RCD
     C                   MOVEA     FAXTX3        RCD(22)
/5469c                   callp     SplLine(' ':rc2247)
     C                   MOVE      *BLANKS       RCD
     C                   MOVEA     FAXTX4        RCD(22)
/5469c                   callp     SplLine(' ':rc2247)
     C                   MOVE      *BLANKS       RCD
     C                   MOVEA     FAXTX5        RCD(22)
/5469c                   callp     SplLine(' ':rc2247)

/5469c                   callp     SplLine('-':*blanks)
/5469c                   callp     SplLine('-':*blanks)

     C                   MOVE      'P001927'     @MSGID
     C                   EXSR      RTVMSG
/5469c                   callp     SplLine('-':@MSGTX)

     C                   MOVE      'P001928'     @MSGID
     C                   EXSR      RTVMSG
     C     @MSGTX        CAT(P)    ORGPH#:1      CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'Q'           @MPACT
     C                   EXSR      RTVMSG
     C                   MOVE      ' '           @MPACT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FXTYP1        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FXTYP1' : blnDebug )
      *          FaxStar
     C                   MOVEL(P)  '**(FAX)'     CMDLIN
     C     ' '           CHECKR    FAXNUM        #T
     C                   MOVEA(P)  FAXNUM        TMP

     C                   DO        #T            #I
     C     TMP(#I)       IFEQ      ' '
     C                   MOVE      '-'           TMP(#I)
     C                   END
     C                   ENDDO

     C                   MOVEA(P)  TMP           FAX#             40
     C                   CAT       FAX#:1        CMDLIN

     C     @LPI          DIV       10            #NCPY            15 5
     C     #NCPY         IFLE      6
     C                   Z-ADD     6             #NCPY
     C                   ELSE
     C                   Z-ADD     8             #NCPY
     C                   END
     C                   Z-ADD     #NCPY         NUMLPI            1 0

     C                   OPEN      RMAINT
     C     RMNT          KLIST
     C                   KFLD                    LFILNA
     C                   KFLD                    LJOBNA
     C                   KFLD                    LPGMOP
     C                   KFLD                    LUSRNA
     C                   KFLD                    LUSRDT
     C     RMNT          CHAIN     RMNTRC                             66

/1892C                   If        NOT %Found
/    C                   Open(e)   RMAINT4
/    C     IDDOCT        Chain     RMNTRC4                            66
/    C                   Close(e)  RMAINT4
/     *
/    C                   If        NOT %found
/    C                   Eval      RTypID = *blanks
/    C                   EndIf
/     *
/    C                   EndIf

     C     *IN66         IFEQ      *OFF
     C     RLCKH         ANDGE     0
     C     RLCKH         MULT      10            @CPI
     C                   END
     C                   CLOSE     RMAINT
     C                   Z-ADD     @CPI          #NCPY            15 5
     C                   DIV       10            #NCPY
     C     #NCPY         IFLE      10
     C                   Z-ADD     10            #NCPY
     C                   ELSE
     C     #NCPY         IFLE      12
     C                   Z-ADD     12            #NCPY
     C                   ELSE
     C                   Z-ADD     17            #NCPY
     C                   END
     C                   END
     C                   Z-ADD     #NCPY         NUMCPI            2 0
      *                                                    ---------
     C     FAXSTY        IFEQ      '*YES'
     C     FAXSTY        OREQ      'Y'
     C     FAXSTY        OREQ      'YES'
     C     FAXSTY        OREQ      'LAND'
      *                                                    ---------
     C                   ELSE
      *                                                    ---------
     C                   CAT       '**LPI':1     CMDLIN
     C     FAXVC         IFNE      *BLANKS
     C                   CAT       FAXVC:1       CMDLIN
     C                   ELSE
     C                   Z-ADD     NUMLPI        #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END

     C                   CAT       '**CPI':1     CMDLIN
     C     FAXHC         IFNE      *BLANKS
     C                   CAT       FAXHC:1       CMDLIN
     C                   ELSE
     C                   Z-ADD     NUMCPI        #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
     C                   END
     C                   END

      *  Do the attribute lines for FAXSTAR with SPACEA(0)
      *  (This doesn't change the coverpage layout)
     C                   CAT       '**PRIO':1    CMDLIN
     C                   CAT       'RITY 0':0    CMDLIN
/5469c                   callp     SplLine('+':CmdLin)
     C     ' **CONFI'    CAT(P)    'RM':0        CMDLIN
     C                   CAT       WQUSRN:1      CMDLIN
     C                   CAT       '**(REF':1    CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CAT       RPTNAM:1      CMDLIN
/5469c                   callp     SplLine('+':CmdLin)
     C     FXREFX        IFNE      *BLANKS
     C     ' '           CHECKR    FXREFX        #T
     C                   MOVEA(P)  FXREFX        TMP
     C                   DO        #T            #I
     C     TMP(#I)       IFEQ      ' '
     C                   MOVE      '_'           TMP(#I)
     C                   END
     C                   ENDDO
     C                   MOVEA     TMP           FXREFX
     C     ' **(REFX'    CAT(P)    ')':0         CMDLIN
     C                   CAT       FXREFX:1      CMDLIN
/5469c                   callp     SplLine('+':CmdLin)
     C                   END

     C                   MOVE      *BLANKS       RCD
     C                   ADD       1             PAGE#
/5469c                   callp     SplLine('1':*blanks)
/5469c                   callp     SplLine('-':*blanks)
/5469c                   callp     SplLine('-':*blanks)
     C                   CALL      'MAG1047'
     C                   PARM                    YMDNUM            9 0
     C                   PARM                    YMD               8
     C                   MOVE      'P001920'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN            3 0
     C     21            SUB       @MSGLN        #T
/2732 *
/2732 * Format date
/2732C                   select
/2732C                   when      DATFMT = 'MDY'
     C     @MSGTX        CAT(P)    SMM:#T        CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       SDD:0         CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       SYYYY:0       CMDLIN
/2732C                   when      DATFMT = 'DMY'
/2732C     @MSGTX        CAT(P)    SDD:#T        CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SMM:0         CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SYYYY:0       CMDLIN
/2732C                   when      DATFMT = 'YMD'
/2732C     @MSGTX        CAT(P)    SYYYY:#T      CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SMM:0         CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SDD:0         CMDLIN
/2732C                   endsl

/5469c                   callp     SplLine('-':CmdLin)
     C                   MOVE      'P001921'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXNUM:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)
     C                   MOVE      'P001922'     @MSGID
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        CMDLIN

      * Override Page total with Image page count.
     C     #TI           IFGT      0
     C                   Z-ADD     #TI           PAGTOT
     C                   END

     C     PAGTOT        ADD       1             #NCPY
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
/5469c                   callp     SplLine('-':CmdLin)
     C                   MOVE      'P001923'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T

     C     @MSGTX        CAT(P)    FAXFRM:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)
     C                   MOVE      'P001924'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T

     C     @MSGTX        CAT(P)    FAXTO:#T      CMDLIN
/5469c                   callp     SplLine('-':CmdLin)
     C     FAXRE         IFNE      *BLANK
     C                   MOVE      'P001925'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXRE:#T      CMDLIN
/5469c                   callp     SplLine('-':CmdLin)
     C                   END

     C     FAXTX1        IFNE      *BLANK
     C     FAXTX2        ORNE      *BLANK
     C     FAXTX3        ORNE      *BLANK
     C     FAXTX4        ORNE      *BLANK
     C                   MOVE      'P001926'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXTX1:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)
     C                   MOVE      *BLANKS       RCD
     C                   MOVEA     FAXTX2        RCD(22)
/5469c                   callp     SplLine(' ':rc2247)
     C                   MOVEA     FAXTX3        RCD(22)
/5469c                   callp     SplLine(' ':rc2247)
     C                   MOVEA     FAXTX4        RCD(22)
/5469c                   callp     SplLine(' ':rc2247)
     C                   MOVEA     FAXTX5        RCD(22)
/5469c                   callp     SplLine(' ':rc2247)
     C                   END

     C                   MOVE      *BLANKS       RCD
/5469c                   callp     SplLine('-':*blanks)
/5469c                   callp     SplLine('-':*blanks)
     C                   MOVE      'P001927'     @MSGID
     C                   EXSR      RTVMSG
/5469c                   callp     SplLine(' ':@MSGTX)
     C                   MOVE      'P001928'     @MSGID
     C                   EXSR      RTVMSG
     C     @MSGTX        CAT(P)    ORGPH#:1      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   MOVE      'Q'           @MPACT
     C                   EXSR      RTVMSG
     C                   MOVE      ' '           @MPACT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FXTYP3        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FXTYP3' : blnDebug )
      *          Rydex

     C     CL(14)        CAT(P)    FAXTX1:11     CMDLIN
     C                   ADD       1             PAGE#
/5469c                   callp     SplLine('1':CmdLin)
     C                   MOVE      *BLANKS       CMDLIN
     C                   Z-ADD     FAXTPM        #NCPY
     C                   EXSR      NUMSTR
     C                   MOVEL     CMDLIN        TOPM              3
     C     CL(15)        CAT(P)    TOPM:12       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     CL(16)        CAT(P)    FAXNUM:13     CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     CL(17)        CAT(P)    FAXCTY:12     CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     CL(18)        CAT(P)    '1:':0        CMDLIN
     C                   CAT       FAXTO:13      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     CL(18)        CAT(P)    '3:':0        CMDLIN
     C                   CAT       FAXFRM:13     CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     CL(19)        CAT(P)    FAXOVR:12     CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     CL(20)        CAT(P)    FAXVC:13      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C                   MOVE      *BLANKS       CMDLIN
     C                   Z-ADD     RPTLPP        #NCPY
     C                   EXSR      NUMSTR
     C                   MOVEL     CMDLIN        TOPM
     C     CL(21)        CAT(P)    TOPM:15       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     CL(22)        CAT(P)    FAXHC:13      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     CL(23)        CAT(P)    FAXSTY:13     CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     FC(35)        CAT(P)    FXRYLM:12     CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C                   ENDSR
      *----------------------------------------------------------------$$$$$$$$$
     C     FXTYP4        BEGSR
      *---------------------------------------------------------------------------
/6302 *    FastFax special code insertion for SCS spooled files.
/6302 *    Inhibit the insertion of these characters if the spooled
/6302 *    file is *USERASCII. ASCII Fax codes will be inserted with
/6302 *    the subroutine PCLFAXCvr.
      *---------------------------------------------------------------------------
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FXTYP4' : blnDebug )

/6302c                   If        @PrtTy <> '*USERASCII' and
/6302c                             @PrtTy <> '*PCL5'
      * FAXNUM EQ '*RECIPIENT'
     C     FAXNUM        IFEQ      RECIP
      * *FD Directory nickname (from the FastFax directory)
     C     RPNAME        IFNE      *BLANKS
     C     '*FD'         CAT(P)    RPNAME:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

      * Else (FAXNUM NE '*RECIPIENT')
     C                   ELSE
      * *FN fax to Number
     C     '*FN'         CAT(P)    FAXNUM:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
      * *FI Individual name
     C     FAXTO         IFNE      *BLANKS
     C     '*FI'         CAT(P)    FAXTO:0       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *FC Company name
     C     CPNAME        IFNE      *BLANKS
     C     '*FC'         CAT(P)    CPNAME:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
     C                   END
      * *RG Routing code
     C     RTCODE        IFNE      *BLANKS
     C     '*RG'         CAT(P)    RTCODE:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *SD from
     C     FAXFRM        IFNE      *BLANKS
     C     '*SD'         CAT(P)    FAXFRM:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *CN/*CZ cover page note start/end of line
     C     FAXTX1        IFNE      *BLANKS
     C     '*CN'         CAT(P)    FAXTX1:0      CMDLIN
     C                   CAT       '*CZ':0       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXTX2        IFNE      *BLANKS
     C     '*CN'         CAT(P)    FAXTX2:0      CMDLIN
     C                   CAT       '*CZ':0       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXTX3        IFNE      *BLANKS
     C     '*CN'         CAT(P)    FAXTX3:0      CMDLIN
     C                   CAT       '*CZ':0       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *FM form
     C     FRMNAM        IFNE      *BLANKS
     C     '*FM'         CAT(P)    FRMNAM:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *CV cover
     C     CVRSHT        IFNE      *BLANKS
     C     '*CV'         CAT(P)    CVRSHT:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *LI lines/inch
     C     FAXVC         IFNE      *BLANKS
     C     '*LI'         CAT(P)    FAXVC:0       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *PL page length
     C     RQOBTY        IFNE      'I'
     C                   MOVE      *BLANKS       CMDLIN
     C                   Z-ADD     RPTLPP        #NCPY
     C                   EXSR      NUMSTR
     C                   MOVEL     CMDLIN        TOPM
     C     '*PL'         CAT(P)    TOPM:0        CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *CI char/inch
     C     FAXHC         IFNE      *BLANKS
     C     '*CI'         CAT(P)    FAXHC:0       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *LS landscape code
     C     FAXSTY        IFNE      *BLANKS
     C     '*LS'         CAT(P)    FAXSTY:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *SC save copy
     C     SCFAX         IFNE      *BLANKS
     C     '*SC'         CAT(P)    SCFAX:0       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *PC print copy
     C     PCPFAX        IFNE      *BLANKS
     C     '*PC'         CAT(P)    PCPFAX:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *CA cost account
     C     CSTACT        IFNE      *BLANKS
     C     '*CA'         CAT(P)    CSTACT:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
      * *PY priority
     C     SNDPRT        IFNE      *BLANKS
     C     '*PY'         CAT(P)    SNDPRT:0      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

/6302c                   EndIf

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FXTYP5        BEGSR
      *          FaxSys
      * Commands / COMMAND ENTRY LIST ON LINE #58
      * ------------
      * &&& fax       phone #
      * &&& form      form name
      * &&& lpi       vertical compression
      * &&& cpi       horizontal compression
      * &&& landscape landscape mode code
      * &&& portrait  portrait mode code
      * &&& priority  priority
      * &&& id        fax id
      * &&& confirm   send a message to a workstation id or user id

      * Before the cover page.

J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FXTYP5' : blnDebug )
     C     FC(22)        CAT(P)    FAXNUM:1      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C     SNDPRT        IFNE      *BLANKS
     C     FC(28)        CAT(P)    SNDPRT:1      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXSTY        IFEQ      '1'
     C     FC(26)        CAT       ' '           CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   ELSE
     C     FAXSTY        IFNE      *BLANKS
     C     FC(27)        CAT(P)    ' '           CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
     C                   END

     C     CONFRM        IFNE      *BLANKS
     C     FC(30)        CAT(P)    CONFRM:1      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXVC         IFNE      *BLANKS
     C     FC(24)        CAT(P)    FAXVC:1       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXHC         IFNE      *BLANKS
     C     FC(25)        CAT(P)    FAXHC:1       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXID         IFNE      *BLANKS
     C     FC(29)        CAT(P)    FAXID:1       CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

      * Before printing the spoolfile.
     C                   MOVE      *BLANKS       RCD
     C                   CALL      'MAG1047'
     C                   PARM                    YMDNUM            9 0
     C                   PARM                    YMD               8

     C                   MOVE      'P001920'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN            3 0
     C     21            SUB       @MSGLN        #T

/2732 *
/2732 * Format date
/2732C                   select
/2732C                   when      DATFMT = 'MDY'
     C     @MSGTX        CAT(P)    SMM:#T        CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       SDD:0         CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       SYYYY:0       CMDLIN
/2732C                   when      DATFMT = 'DMY'
/2732C     @MSGTX        CAT(P)    SDD:#T        CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SMM:0         CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SYYYY:0       CMDLIN
/2732C                   when      DATFMT = 'YMD'
/2732C     @MSGTX        CAT(P)    SYYYY:#T      CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SMM:0         CMDLIN
/2732C                   CAT       '/':0         CMDLIN
/2732C                   CAT       SDD:0         CMDLIN
/2732C                   endsl
/2732 *
/5469c                   callp     SplLine('-':CmdLin)
     C                   MOVE      'P001921'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T

     C     @MSGTX        CAT(P)    FAXNUM:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C     TOPAGE        SUB       FRMPAG        #NCPY
     C                   ADD       2             #NCPY
     C                   MOVE      'P001922'     @MSGID
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        CMDLIN
     C                   MOVE      *ON           *IN31
     C                   EXSR      NUMSTR
     C                   MOVE      *OFF          *IN31
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001923'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T

     C     @MSGTX        CAT(P)    FAXFRM:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001924'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXTO:#T      CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      'P001925'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T

     C                   MOVE      'P001926'     @MSGID
     C                   EXSR      RTVMSG
     C     ' '           CHECKR    @MSGTX        @MSGLN
     C     21            SUB       @MSGLN        #T
     C     @MSGTX        CAT(P)    FAXTX1:#T     CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C                   MOVE      *BLANKS       CMDLIN
     C                   CAT       FAXTX2:21     CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C                   MOVE      *BLANKS       CMDLIN
     C                   CAT(P)    FAXTX3:21     CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C                   MOVE      *BLANKS       RCD
/5469c                   callp     SplLine('-':*blanks)
/5469c                   callp     SplLine('-':*blanks)

     C                   MOVE      'P001927'     @MSGID
     C                   EXSR      RTVMSG
/5469c                   callp     SplLine(' ':@MSGTX)

     C                   MOVE      'P001928'     @MSGID
     C                   EXSR      RTVMSG
     C     @MSGTX        CAT(P)    ORGPH#:1      CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)

     C                   MOVE      'Q'           @MPACT
     C                   EXSR      RTVMSG
     C                   MOVE      ' '           @MPACT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FXTYP9        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FXTYP9' : blnDebug )
      *          Fax/Acs
      * Get Defaults
     C     @LPI          DIV       10            #NCPY            15 5
     C     #NCPY         IFLE      6
     C                   Z-ADD     6             #NCPY
     C                   ELSE
     C                   Z-ADD     8             #NCPY
     C                   END
     C                   Z-ADD     #NCPY         NUMLPI            1 0
     C                   MOVE      NUMLPI        LPIDFT            1

     C                   OPEN      RMAINT
     C     RMNT          CHAIN     RMNTRC                             66
/1892C                   If        NOT %Found
/    C                   Open(e)   RMAINT4
/    C     IDDOCT        Chain     RMNTRC4                            66
/    C                   Close(e)  RMAINT4
/     *
/    C                   If        NOT %found
/    C                   Eval      RTypID = *blanks
/    C                   EndIf
/     *
/    C                   EndIf
     C     *IN66         IFEQ      *OFF
     C     RLCKH         ANDGE     0
     C     RLCKH         MULT      10            @CPI
     C                   END
     C                   CLOSE     RMAINT
     C                   Z-ADD     @CPI          #NCPY            15 5
     C                   DIV       10            #NCPY
     C     #NCPY         IFLE      10
     C                   Z-ADD     10            #NCPY
     C                   ELSE
     C     #NCPY         IFLE      12
     C                   Z-ADD     12            #NCPY
     C                   ELSE
     C                   Z-ADD     17            #NCPY
     C                   END
     C                   END
     C                   Z-ADD     #NCPY         NUMCPI            2 0
     C                   SELECT
     C     NUMCPI        WHENEQ    10
     C                   MOVE      '1'           CPIDFT            1
     C     NUMCPI        WHENEQ    12
     C                   MOVE      '2'           CPIDFT
     C     NUMCPI        WHENEQ    17
     C                   MOVE      '3'           CPIDFT
     C     NUMCPI        WHENEQ    20
     C                   MOVE      '4'           CPIDFT
     C                   OTHER
     C                   MOVE      '1'           CPIDFT
     C                   ENDSL

      * Create and Output Fax Commands.
     C     FRMNAM        IFNE      *BLANKS
     C     '$'           CAT(P)    FC(36):0      CMDLIN
     C                   CAT       FRMNAM:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('+':CmdLin)
     C                   END

     C     FAXSTY        IFNE      *BLANKS
     C     '$'           CAT(P)    FC(37):0      CMDLIN
     C                   CAT       FAXSTY:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('+':CmdLin)
     C                   END

     C     '$'           CAT(P)    FC(38):0      CMDLIN
     C     FAXHC         IFNE      *BLANKS
     C                   CAT       FAXHC:0       CMDLIN
     C                   ELSE
     C                   CAT       CPIDFT:0      CMDLIN
     C                   END
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('+':CmdLin)

     C     '$'           CAT(P)    FC(39):0      CMDLIN
     C     FAXVC         IFNE      *BLANKS
     C                   CAT       FAXVC:0       CMDLIN
     C                   ELSE
     C                   CAT       LPIDFT:0      CMDLIN
     C                   END
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('+':CmdLin)

     C     '$'           CAT(P)    FC(40):0      CMDLIN
     C                   CAT       'F':0         CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('+':CmdLin)

     C     '$'           CAT(P)    FC(41):0      CMDLIN
     C                   CAT       FAXNUM:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
     C                   ADD       1             PAGE#
/5469c                   callp     SplLine('1':CmdLin)

     C     '$'           CAT(P)    FC(42):0      CMDLIN
     C                   CAT       FAXFRM:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C     '$'           CAT(P)    FC(43):0      CMDLIN
     C                   CAT       FAXTO:0       CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('-':CmdLin)

     C     FAXTX1        IFNE      *BLANKS
     C     '$'           CAT(P)    FC(44):0      CMDLIN
     C                   CAT       FAXTX1:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('-':CmdLin)
     C                   END

     C     FAXTX2        IFNE      *BLANKS
     C     '$'           CAT(P)    FC(45):0      CMDLIN
     C                   CAT       FAXTX2:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXTX3        IFNE      *BLANKS
     C     '$'           CAT(P)    FC(46):0      CMDLIN
     C                   CAT       FAXTX3:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXTX4        IFNE      *BLANKS
     C     '$'           CAT(P)    FC(47):0      CMDLIN
     C                   CAT       FAXTX4:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END

     C     FAXTX5        IFNE      *BLANKS
     C     '$'           CAT(P)    FC(48):0      CMDLIN
     C                   CAT       FAXTX5:0      CMDLIN
     C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine(' ':CmdLin)
     C                   END
/3345
/3345 * Retrieve system date.
/3345C                   CALL      'MAG1047'
/3345C                   PARM                    YMDNUM            9 0
/3345C                   PARM                    YMD               8
/3345
/3345C                   clear                   xdate
/3345 * Format date
/3345C                   select
/3345C                   when      DATFMT = 'MDY'
/3345C                   eval      xdate = SMM + '/' + SDD + '/' + SYYYY
/3345C                   when      DATFMT = 'DMY'
/3345C                   eval      xdate = SDD + '/' + SMM + '/' + SYYYY
/3345C                   when      DATFMT = 'YMD'
/3345C                   eval      xdate = SYYYY + '/' + SMM + '/' + SDD
/3345C                   endsl
/3345
/3345C                   TIME                    xtime
/3345
/3345C                   eval      xtime$ = xhh + ':' + xmm + ':' + xss
/3345
/3345C     '$'           CAT(P)    FC(49):0      CMDLIN
/3345C                   CAT       'Date:':0     CMDLIN
/3345C                   CAT       xdate:0       CMDLIN
/3345C                   CAT       '  Time:':0   CMDLIN
/3345C                   CAT       xtime$:0      CMDLIN
/3345C                   CAT       '$':0         CMDLIN
/5469c                   callp     SplLine('+':CmdLin)
/3345
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FCATC1        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FCATC1' : blnDebug )
      *          FaxStar Attach document -count pages in doc only

     C                   MOVEL(P)  CL(48)        CMDLIN
     C                   EXSR      RUNCL
     C                   EXSR      DOC2FL
     C                   MOVEL(P)  CL(55)        CMDLIN
     C                   EXSR      RUNCL
     C                   OPEN      DISP
     C                   Z-ADD     0             DOCPGS            9 0
     C                   READ      DISP                                   25

     C     *IN25         DOWEQ     *OFF
     C     ATFCFC        IFEQ      '1'
     C                   ADD       1             DOCPGS
     C                   ENDIF
     C                   READ      DISP                                   25
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FXATC1        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'FXATC1' : blnDebug )
      *          FaxStar Attach document

     C     1             SETLL     DISP                               50
     C                   READ      DISP                                   25

     C     *IN25         DOWEQ     *OFF
/5469c                   callp     SplLine(atFCFC:atcrcd)
     C                   READ      DISP                                   25
     C                   ENDDO

     C                   CLOSE     DISP
     C                   MOVEL(P)  CL(57)        CMDLIN
     C                   EXSR      RUNCL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DOC2FL        BEGSR
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'DOC2FL' : blnDebug )
      *          Print Document and CpySplF it to a DBfile.

     C                   SELECT
     C     ATCCMD        WHENEQ    'PRTDMDOC'
     C                   MOVEL(P)  CL(49)        CMDLIN
     C                   EXSR      RUNCL
     C     CL(50)        CAT(P)    DOCNAM:0      CMDLIN
     C                   CAT       CL(51):0      CMDLIN
     C                   CAT       LFXLIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       LFXOUT:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL
     C     *IN81         IFEQ      *ON
     C                   MOVE      'E'           PRMFAX
     C                   OUT       LDA
     C                   EXSR      QUIT
     C                   ENDIF
     C                   ENDSL

     C     CL(56)        CAT(P)    PGMLIB:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   EXSR      RUNCL
     C                   MOVEL(P)  CL(52)        CMDLIN
     C                   EXSR      RUNCL
     C                   MOVEL(P)  CL(53)        CMDLIN
     C                   EXSR      RUNCL

     C                   SELECT
     C     ATCCMD        WHENEQ    'PRTDMDOC'
     C                   MOVEL(P)  CL(54)        CMDLIN
     C                   EXSR      RUNCL
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      /free
       begsr convertToPDF;
J2469    Callp(e)  SubMsgLog( blnDebug : 'ConvertToPDF' : blnDebug ) ;

J4902    If ( IfRepl = REPLACE_SEQ );
/          img# += 1;
/        EndIf;

J4902    ExSr setPCFilSeq;
J2469    exsr setPCFilNam;

         // Note that the file name had been passed
         blnOverload =
         ( %subst(mltxt1 : %len( %trim( mltxt1 ) ) : 1 ) <> SLASH    ) and
         ( %subst(mltxt1 : %len( %trim( mltxt1 ) ) : 1 ) <> ASTERICK );

         Select;
           When  (  ( IFRepl <> REPLACE_SEQ ) and
                    ( blnOverload = TRUE    )     );
             IFPath = %trim(Mltxt1) + %trim(Mltxt2);
           When  (  ( IFRepl =  REPLACE_SEQ ) and
                    ( blnOverload = TRUE    )     );
             IFPath = %subst(IFpath : 1 : %scan( '.' : IFPath ) ) + EXT_PDF;
           When  (  ( IFRepl =  REPLACE_SEQ ) and
                    ( blnOverload = TRUE    )     );
           When  (  ( IFRepl =  REPLACE_SEQ ) and
                    ( blnOverload = TRUE    )     );
         EndSl;

         if %xlate(lo:up:%subst(pcExt:1:3)) = 'TIF';
           exsr SPYTIF;
J5331      spyPath('*MAILTMP':strSrcPath);

           for filidx = 0 to 999;
             nxtnam = 'TIFF' + %editc(filidx:'X');
             exsr chkNxt;

             if nxtOK = '0';
               leave;
             endif;
J5331        // Place a pointer of the user space into
J5331        // an array of pointers
J5331        reset qusec;
J5331        rtvUsrSpcPtr('TIFF' + %editc(filidx
J5331                     : 'X') + '   QTEMP'
J5331                     : TiffBufferP
J5331                     : qusec);
J5331
J5331        If qusbavl > 0 and qusei = 'CPF9801'; // No more spaces. Process.
J5331          leave;
J5331        EndIf;
J5331
J5331        // Isolate the embedded size of the buffer
J5331        pstrSpcSz  = TiffBufferP;
J5331        // Isolate the point to the buffer data itself
J5331        pstrSpcBuf = TiffBufferP+9;
J5331        // Initialize the pointer with the address of the
J5331        // buffer where actual tiff data is stored
J5331        //  DsUsrSpc.pBufSpc =  TiffBufferP + %size(dsUsrSpc.strSpcSz);
J5331        // Create a separate TIF file for each user space
J5331        strSrcFile = 'src' + %editc(filidx : 'X' ) + '.tif';
J5331        strSrcPathFile = %trimr(strSrcPath) + '/' + strSrcFile + x'00';
J5331        intUsrSpcSz = GetUsrSpcSz( 'QTEMP     '
J5331                                  : 'TIFF' + %editc(filidx : 'X' ) );
J5331        flags = O_WRONLY + O_CREAT + O_TRUNC;
J5331        mode  = S_IRUSR + S_IWUSR + S_IRGRP;
J5331        fd = IFSopen(  %trimr( strSrcPathFile )
J5331                    : O_CREAT + O_TRUNC + O_WRONLY + O_CODEPAGE
J5331                    : S_IRWXU + S_IRWXG + S_IRWXO
J5331                    : intCodePageWin );
J5331        IFSClose(fd);
J5331        fd = IFSOpen( %trimr( strSrcPathFile ):flags:mode);
J5331
J5331        If ( fd < 0 );
J5331          leaveSr;
J5331        EndIf;
J5331
J5331        intWriteSz = %int(strSpcSz);
J5331
J5331        If ( IFSwrite( fd
J5331                     : pstrSpcBuf
J5331                     : intWriteSz
J5331                     )
J5331              <> intWriteSz
J5331            );
J5331          leaveSr;
J5331        EndIf;
J5331
J5331        Callp(e) close(fd);
J5331
J5331      endfor;
J5331
J5331      intTiffCount = filidx - 1;
J5331
J5331      // Combine all of the generated user psaced into a single file
J5331      // and then call tiff2pdf
J5331
J5331      run('dltusrspc qtemp/tiff*');
J5331      spyPath('*PDFSUPP' : strObjPath );
J5331      strPathPgm = %trimr( strObjPath ) + '/tiff2pdf';
J5331      cmdOScmd = 'qsh cmd(' + Q + %trimr( strPathPgm )
J5331               + ' -t ' + QQ + 'OpenText Document' + QQ
J5331               + ' -a ' + QQ + 'OpenText' + QQ
J5331               + ' -d ' + QQ + %trim( strSrcPath ) + '/' + QQ
J5331               + ' -o ' + QQ + %trim( strGetPathString )
J5331               +          '/' + %trim( strGetFileName ) + '.pdf' + QQ;
J5331
J5331     For filidx = 0 to intTiffCount;
J5331        strSrcFile = 'src' + %editc(filidx : 'X' ) + '.tif';
J5331        cmdOScmd = %trim(cmdOScmd) + '  ' + QQ + %trim( strSrcFile ) +QQ;
J5331     EndFor;
J5331
J5331     cmdOScmd =  %trim(cmdOScmd) + ' 2>/dev/null ' + Q +  ' )';
J5331
J5331      If ( run(cmdOScmd) <> 0 );
J5331        exsr quit;
J5331      EndIf;
J5331
J5331      For filidx = 0 to intTiffCount;
J5331        strSrcFile = %trim(strSrcPath) + '/'
J5331                   + 'src' + %editc(filidx : 'X' ) + '.tif';
J5331        unlink( strSrcPathFile );
J5331      EndFor;
J5331
J5331    EndIf;
J5331
J5331  EndSr;
      /end-free
      *================================================================
     C     PLERR         PLIST
     C                   PARM      @MSGID        EMSGID            7
     C                   PARM                    EMSGDT          100
     C                   PARM                    EMSGF            10
     C                   PARM                    EMSGFL           10

/3469o#REPORT#  e            SplLineP         01
/    o                       SplData            247
/    o          e            SplLine0    0  0
/    o                       SplData            247
/    o          e            SplLine1    1
/    o                       SplData            247
/    o                       srFCFC             248
/    o          e            SplLine2    2
/    o                       SplData            247
/    o          e            SplLine3    3
/    o                       SplData            247

/2264O          E            OUTP1       1

     O          E            FX1LAN           01
     O                                            6 '**LAND'
     O                       CPILPI             106
     O          E            FAX5$F           01
     O                       TMP2               247

     O          E            OUTO        0
     O                       FDATA              247
     O          E            OUTO1       1
     O                       FDATA              247

     O          E            SPACE       1
     O          E            NEWPAG           01

     O          E            FXIMG1      1
     O                                              '**(XATTACH)'
     O                       XATFIL            +001
J2144O          E            FXIMG1d     1
/    O                                              '**(XATTACHD)'
/    O                       XATFIL            +001
     O          E            FXIMGF      1
     O                                              '**(FTPATTACH)'
     O                       XATFIL            +001
     O          E            FXIMG4      1
     O                                              '*AP'
     O                       XATFIL
     O          E            FXIMG6      1
     O                       HEXCIR
     O                                              'ATTACH'
     O                       XATFIL            +001

     O          E            CFORM       0  0
     O                                              '**FORM '
     O                       FSTFRM

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * write a spool line (handle DJDE on first line)
/5469p SplLine         b
     d                 pi
     d  FCFC                          1    const
     d  Buffer                      247    const
     c                   if        djdeStart <> *blanks
     c                   callp     SplWrite(FCFC:djdeStart)
     c                   callp     SplWrite('+':Buffer)
     c                   eval      djdeStart = *blanks
     c                   else
     c                   callp     SplWrite(FCFC:Buffer)
     c                   end
/5469p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * write a spool line
/5469p SplWrite        b
     d                 pi
     d  FCFC                          1    const
     d  Buffer                      247    const
     c                   eval      SplData = Buffer
     c                   SELECT
     c     FCFC          WHENEQ    '1'                                          new page
     c                   EXCEPT    SplLineP
     c     FCFC          WHENEQ    '+'                                          overstrike
     c                   EXCEPT    SplLine0
     c     FCFC          WHENEQ    ' '                                          space 1
     c                   EXCEPT    SplLine1
     c     FCFC          WHENEQ    '0'                                          space 2
     c                   EXCEPT    SplLine2
     c     FCFC          WHENEQ    '-'                                          space 3
     c                   EXCEPT    SplLine3
     c                   ENDSL
/5469p                 e
      * ---------------------------------------------------------------------- *
      * Open and setup a PDF document                                          *
      * ---------------------------------------------------------------------- *
/2497p OpenPDF         b
     d OpenPDF         pi            10i 0
     d  PDFhd                          *

     d IKey            s             32
     d IValue          s            256

     d rc              s             10i 0

      * clear email buffer
     c                   eval      MLDTA = *blanks
     c                   eval      PLastPos = 0
      * new document
     c                   eval      PPstate = *blank
     c                   eval      PDFhd = PDFnew
     c                   if        PDFhd = *null
     c                   return    0
     c                   end
J2473 /free
J2473  if @dest = 'A';
J2473    rc = PDFopnFile(PDFhd:%trim(ifpath) +  x'00');
J2473  else;

J3951    If ( 0 > PDFopnFile(PDFhd:x'00') );
J3951      Return 0;
J3951    EndIf;

J3951    PDFopenMem(PDFhd:cbWrtMemP);
J2473  endif;
J2473 /end-free
      * document info
     c                   eval      IKey   = 'Title' + x'00'
     c                   eval      IValue = 'Open Text Document' + x'00'
     c                   callp     PDFsetInfo(PDFhd:IKey:Ivalue)
     c                   eval      IKey   = 'Creator' + x'00'
/3274c                   eval      IValue = 'Open Text' +x'00'
     c                   callp     PDFsetInfo(PDFhd:IKey:Ivalue)

     c                   return    1
     p                 e
      * ---------------------------------------------------------------------- *
      * Close a PDF document                                                   *
      * ---------------------------------------------------------------------- *
/2497p ClosePDF        b
     d ClosePDF        pi            10i 0
     d  PDFhd                          *   const

      * finish document
     c                   if        PPState = 'P'
     c                   callp     PDFendPage(PDFhd)
     c                   eval      PPState = *blanks
     c                   end
     c                   callp     PDFclose(PDFhd)

      * flush any remaining data
J2473c                   if        @dest <> 'A'
     c                   if        PLastPos> 0
     c                   eval      MLDTLE = PLastPos
     C                   MOVEL(P)  'WRTATT'      MLOPCD
     C                   CALL      'SPYMAIL'     PLMAIL
     C     MLRTN         IFNE      *BLANKS
     C                   MOVEL     MLRTN         @MSGID
     C                   MOVE      *BLANKS       EMSGDT
/2423c                   callp     $EXPMSG
     c                   return    0
     C                   END
J2473C                   endif
     c                   eval      MLDTLE = 0
     c                   eval      MLDTA  = *blanks
     c                   eval      PLastPos = 0
     c                   end

     c                   return    1
     p                 e
      * ---------------------------------------------------------------------- *
      * Setup text page in the PDF document                                    *
      * ---------------------------------------------------------------------- *
/2497p SetTxtPDF       b
     d SetTxtPDF       pi            10i 0
     d  PDFhd                          *   const

     d Encoding        s             32a
     d FontName        s             64a

      * text font
/8603c                   eval      FontName = PDF_FONT + x'00'
/    c                   eval      Encoding = PDF_ENC_ST + x'00'
     c                   eval      PFNTh = PDFfndFont(PDFhd:FontName:Encoding:0)
     c                   if        PFNTh < 0
     c                   return    0
     c                   end
      * form
     c                   eval      PFontSize = 12.0
     c                   eval      PWidth  = PDF_LtrWid
     c                   eval      PHeight = PDF_LtrHgt
     c                   if        @lpi > 0
     c                   eval      PFontSize = 72/(@lpi*.1)
     c                   end
     c                   if        @pagLe > 0
     c                   eval      PHeight = @pagLe * PFontSize
     c                   end
/3940c                   eval      PFontSizeH = PFontSize
/    c                   eval      PFontSizeW = PFontSizeH *.6
/    c                   if        @cpi > 0
/    c                   eval      PFontSizeW = 72/(@cpi*.1)
/    c                   end
/    c                   eval      FHscale = 0                                  calc later
      * note: width is adjusted by an assumed font height/width ratio (6LPI/10CP
     c                   if        @pagWi > 0
/    c                   eval      PWidth  = @pagWi * PFontSizeW
     c                   end
     c                   eval      PWidth  = PWidth + PMargin*2
     c                   eval      PHeight = PHeight + PMargin*2

     c                   return    1
     p                 e
      * ---------------------------------------------------------------------- *
      * Start a new page in the PDF document                                   *
      * ---------------------------------------------------------------------- *
/2497p NewPagPDF       b
     d NewPagPDF       pi
     d  PDFhd                          *   const

/3940d FKey            s             32
/    d FTxt            s             32

      * end last page
     c                   if        PPState = 'P'
     c                   callp     PDFendPage(PDFhd)
     c                   end
      * start new page
     c                   callp     PDFbgnPage(PDFhd:PWidth:PHeight)
     c                   eval      PPState = 'P'
     c                   if        PFNTh >= 0
     c                   callp     PDFsetFont(PDFhd:PFNTh:PFontSize)
      * adjust font width to fit page
/3940c                   if        FHscale = 0                                  not set yet
/    c                   eval      FHscale = 100
/    c                   eval      FTxt   = 'W' + x'00'
/    c                   eval      FWidth=PDFstrWid(PDFhd:FTxt:PFNTh:PFontSize)
/    c                   if        FWidth <> PFontSizeW

J2470c                   If        ( FWidth = *zeros )
/    c                   Eval      FWidth = 7.19999
/    c                   EndIf

/3940c                   eval      FHscale = (PFontSizeW/FWidth)*100
/    c                   end
/    c                   end
/    c                   eval      FKey   = 'horizscaling' + x'00'
/    c                   callp     PDFsetVal(PDFhd:FKey:FHscale)
     c                   end
     c                   eval      Px = PMargin
/    c                   eval      Py = PHeight - PMargin - PFontSizeH

     p                 e
      * ---------------------------------------------------------------------- *
      * Write a PDF document line                                              *
      * ---------------------------------------------------------------------- *
/2497p WrtLnPDF        b
     d WrtLnPDF        pi
     d  PDFhd                          *   const
     d  Line                        256    const

     d  LineA          s             +1    like(Line)

      * plot text
     c                   if        Line <> *blanks
     c                   callp     PDFsetTxtP(PDFhd:Px:Py)
     c                   eval      LineA = %trimr(Line) + x'00'
     c                   callp     xlateE2A(LineA)
     c                   callp     PDFshow(PDFhd:LineA)
     c                   end
      * get position from line spacing
/    c                   eval      Py = Py - PFontSizeH * (Linfds+1)
     C                   CLEAR                   LINFDS
     p                 e
      * ---------------------------------------------------------------------- *
      * Translate from EBCDIC to ASCII                                         *
      * ---------------------------------------------------------------------- *
/2497p xlateE2A        b
     d xlateE2A        pi
     d  Line                      32767    options(*varsize)
     d  LineA          s              1    dim(%size(line)) based(LineAp)
     d  pos            s              5u 0 inz(1)
     d                 ds
     d  int                    1      2u 0 inz
     d  char                   2      2
      * Translate up to the null
     c                   eval      LineAp = %addr(Line)
     c                   dow       LineA(pos) <> x'00'
     c                   eval      char = LineA(pos)
     c                   eval      LineA(pos) = ToTbl(int+1)
     c                   eval      pos = pos + 1
     c                   enddo
     p                 e
      * ---------------------------------------------------------------------- *
      * Open Tiff image page for PDF document                                  *
      * ---------------------------------------------------------------------- *
/2497p OpenTifPDF      b
     d OpenTifPDF      pi            10i 0
     d  PDFhd                          *
     d  FName                       256    const
     d  FType                         1    const
     d  FLength                      10i 0 const

     d MIFile          s            257a
     d MItype          s              2a
     d MIoffset        s             11a
     d MIlength        s             11a
     d IType           s             16a
     d Is              s              1a   inz(x'00')
     d Ii              s             10i 0 inz(0)

     d IKey            s             32

      * open structure
     c                   eval      MIFile = %trimr(Fname) + x'00'
     c                   eval      MItype = Ftype + x'00'
     c                   eval      MIoffset = '9' + x'00'
     c                   movel     Flength       MIlength
     c                   eval      MIlength = %trim(MIlength) + x'00'
     c                   eval      MPTname   = %addr(MIFile)
     c                   eval      MPTtype   = %addr(MItype)
     c                   eval      MPToffset = %addr(MIoffset)
     c                   eval      MPTlength = %addr(MIlength)
      * open image
     c                   eval      IType = 'tiff' + x'00'
     c                   eval      PIMGh = PDFopnImgF(PDFhd:IType:
     c                                                MagPDFtiff:Is:Ii)
     c                   if        PIMGh < 0
     c                   return    0
     c                   end
      * get image values
     c                   eval      IKey   = 'imagewidth' + x'00'
     c                   eval      IWidth = PDFgetVal(PDFhd:IKey:PIMGh)
     c                   eval      IKey    = 'imageheight' + x'00'
     c                   eval      IHeight = PDFgetVal(PDFhd:IKey:PIMGh)
     c                   eval      IKey  = 'resx' + x'00'
     c                   eval      IResX = PDFgetVal(PDFhd:IKey:PIMGh)
     c                   eval      IKey  = 'resy' + x'00'
     c                   eval      IResY = PDFgetVal(PDFhd:IKey:PIMGh)

     c                   return    1
     p                 e
      * ---------------------------------------------------------------------- *
      * Place Image as PDF page                                                *
      * ---------------------------------------------------------------------- *
/2497p ImgPagePDF      b
     d ImgPagePDF      pi
     d  PDFhd                          *   const
     d  IMGhd                        10i 0 const

     d Res             s                   like(phloat) inz(200)
     d Sx              s                   like(phloat) inz(1)
     d Sy              s                   like(phloat) inz(1)

      * determine page dimensions and scaling
     c                   if        IWidth > 0 and IHeight > 0
     c                   if        IResX > 0
     c                   eval      Res = IResX
     c                   if        IResX <> IResY and IResY > 0
     c                   eval      Sy = IResX/IResY
     c                   end
     c                   end
     c                   eval      Sx = 72/Res
     c                   eval      PWidth  = IWidth * Sx
T6764c                   eval      PHeight = IHeight * (72/IResY)
     c                   else
     c                   eval      PWidth  = PDF_LtrWid
     c                   eval      PHeight = PDF_LtrHgt
     c                   end
      * page break
     c                   if        PPState = 'P'
     c                   callp     PDFendPage(PDFhd)
     c                   end
     c                   callp     PDFbgnPage(PDFhd:PWidth:PHeight)
      * place image
     c                   if        Sy <> 1
     c                   callp     PDFsave(PDFhd)
     c                   callp     PDFscale(PDFhd:1:Sy)
     c                   end
     c                   callp     PDFplacImg(PDFhd:IMGhd:0:0:Sx)
     c                   if        Sy <> 1
     c                   callp     PDFrestore(PDFhd)
     c                   end
      * finish page
     c                   callp     PDFendPage(PDFhd)
     c                   eval      PPState = *blanks

     p                 e
      * ---------------------------------------------------------------------- *
      * Callback for PDFopenMem                                                *
      * ---------------------------------------------------------------------- *
/2497p cbWrtMem        b
     d cbWrtMem        pi            10u 0
     d  PDFhd                          *   value
     d  Buffer                         *   value
     d  BufferLn                     10u 0 value

     d  Bufr           s          32767    based(BufrP)
     d  Pos            s             10i 0
     d  Len            s             10i 0

      * process in fixed blocks
     C                   MOVEL(P)  'WRTATT'      MLOPCD
     c                   eval      BufrP = Buffer
     c                   dou       Pos = BufferLn

      * copy to mail buffer
     c                   eval      Len = %size(MLDTA) - PLastPos
     c                   if        Len > BufferLn - Pos
     c                   eval      Len = BufferLn - Pos
     c                   end
     c                   eval      %subst(MLDTA:PLastPos+1) =
     c                                          %subst(Bufr:1:Len)
     c                   eval      BufrP = BufrP + len

      * load a mail buffer
     c                   if        PLastPos+Len = %size(MLDTA)
     c                   eval      MLDTLE = PLastPos + Len
     C                   CALL      'SPYMAIL'     PLMAIL
     C     MLRTN         IFNE      *BLANKS
     C                   MOVEL     MLRTN         @MSGID
     C                   MOVE      *BLANKS       EMSGDT
/2423c                   callp     $EXPMSG
     c                   return    0
     C                   END
     c                   eval      MLDTLE = 0
     c                   eval      MLDTA  = *blanks
     c                   eval      PLastPos = 0
     c                   else
     c                   eval      PLastPos = PLastPos + Len
     c                   end

     c                   eval      Pos = Pos + Len
     c                   enddo

     c                   return    BufferLn
     p                 e
/2423 *----------------------------------------------------------------
/2423p $EXPMSG         b
/2423d                 pi
/2423 *----------------------------------------------------------------
/2423 *   This routine is a hardcoded to send escape messages to
/2423 *    EXPOBJSPY.
/2423 *          Clear program msgs for EXPOBJSPY

/2423c                   eval      @MSGQ = 'EXPOBJSPY'
/2423C                   MOVE      *BLANKS       @MSGKY
/2423C
/2423C                   CALL      'QMHRMVPM'
/2423C                   PARM                    @MSGQ            10
/2423C                   PARM      0             APILEN
/2423C                   PARM                    @MSGKY            4
/2423C                   PARM      '*ALL'        MSGCTL           10
/2423C                   PARM                    ERRCD2
/2423C
/2423C**Check Error code if can not clear messages for EXPOBJSPY
/3166C     @ERRL2        ifeq      *zeros
/2423C
/2423C** Send Escape Message to EXPOBJSPY
/2423C                   MOVEL     'PSCON'       EMSGF
/2423C                   MOVEL     '*LIBL   '    EMSGFL
/2423C                   MOVEL     EMSGF         @MSGF
/2423C                   MOVE      EMSGFL        @MSGF
/2423C
/2423C     ' '           CHECKR    EMSGDT        EMSGLN
/2423C                   Z-ADD     0             @MSGPG
/2423C                   MOVE      *BLANKS       @MSGKY
/2423C
/2423C                   CALL      'QMHSNDPM'
/2423C                   PARM                    @MSGID
/2423C                   PARM                    @MSGF            20
/2423C                   PARM                    EMSGDT
/2423C                   PARM                    EMSGLN
/2423C                   PARM      '*DIAG'       @MSGTY           10
/2423C                   PARM                    @MSGQ
/2423C                   PARM                    @MSGPG
/2423C                   PARM                    @MSGKY            4
/2423C                   PARM                    ERRCD2
/2423C
/2423C** Call SPYERR if cannot send message to EXPOBJSPY
/2423C                   ELSE
/2423C                   CALL      'SPYERR'      PLERR                  50
/2423C                   ENDIF
/2423p                 e
/2119 * ---------------------------------------------------------------------- *
/     * Translate Space from ASCII to EBCDIC                                   *
/     * ---------------------------------------------------------------------- *
/2119p xlateA2E        b
/    d xlateA2E        pi
/    d  A2ESpcPtr                      *   const
/    d  A2ELength                    10u 0 const

/    d  A2EDataA       s              1a   based(A2ESpcPtrP)
/    d  pos            s             10u 0 inz(1)

/    d                 ds
/    d  int                    1      2u 0 inz
/    d  char                   2      2
/     * Translate

/    C                   eval      A2ESpcPtrP = A2ESpcPtr

/    c                   dow       pos <= A2ELength
/    c                   eval      char = A2EDataA
/    C     totbls:frmtblsxlate     A2EDataA      A2EDataA
/    c                   eval      pos = pos + 1
     c                   eval      A2ESpcPtrP = A2ESpcPtrP + 1
/    c                   enddo
     p                 e
      *-------------------------------------------------------------------------
      * Pair up single quotes for command.
      *-------------------------------------------------------------------------
/8632p dblqte          b

     d                 pi           256
     d source                       256    value

     d target          s              1    dim(256) inz
     d tgtndx          s             10i 0 inz(1)
     d srclen          s             10i 0 inz
     d srcVal          s              1    based(srcPtr)
     d sq              c                   ''''

     c                   eval      srcPtr = %addr(source)
     c                   eval      srclen = %len(%trim(source))
     c                   do        srclen
     c                   if        srcVal = sq
     c                   eval      target(tgtndx) = sq
     c                   eval      tgtndx = tgtndx + 1
     c                   endif
     c                   eval      target(tgtndx) = srcVal
     c                   eval      tgtndx = tgtndx + 1
     c                   eval      srcPtr = srcPtr + 1
     c                   enddo

     c                   movea     target        source
     c                   return    source

     p                 e
/5635 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/5635p BldLogEnt       b
/5635
/5635d                 pi
/5635d DestId                         1a   const
/5635d SpyNbr                        10a
/5635d FrmPage                       10i 0 value
/5635d ToPage                        10i 0 value

     d DtlType         s              5u 0 inz(0)
     d DtlNamLen       s              5u 0 inz(0)
     d DtlValLen       s              5u 0 inz(0)
     d DtlNam          s               *   inz(*NULL)
     d wkPage          s             10a
     d wkPath          s            256a
/5635
/5635 * determine logging code based on the operation being performed
/5635c                   select
/5635 * Print to outfile
/5635c                   when      DestId = 'D'
/5635c                   eval      LogOpCode = #AUPRTOBJ
/5635 * get path for printing to outfile
/5635c                   eval      DtlType = #DTPATH
/5635c                   eval      wkPath = %trim(Outflb)+'/'+%trim(Outfil)
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:DtlNam:
/5635c                              DtlNamLen:%addr(wkPath):%len(%trim(wkPath)))
      * Print to *IFS
/5635c                   when      DestId = 'I'
/5635c                   eval      LogOpCode = #AUPRTOBJ
/5635 * Print object
/5635c                   when      DestId = 'P'
/5635c                   eval      LogOpCode = #AUPRTOBJ
     c                   exsr      BldPrtDtl
/5635
/5635 * Fax object
/5635c                   when      DestId = 'F'
/5635c                   eval      LogOpCode = #AUFAXOBJ
     c                   exsr      BldFaxDtl
/5635
/5635c                   other
/5635c                   return
/5635c                   endsl
/5635 * get from page#
/5635c                   eval      DtlType = #DTFPAGE
/5635c                   eval      wkPage = %trim(%editc(FrmPage:'Z'))
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:DtlNam:
/5635c                              DtlNamLen:%addr(wkPage):%len(%trim(wkPage)))
/5635 * get to page#
/5635c                   eval      DtlType = #DTTPAGE
/5635c                   eval      wkPage = %trim(%editc(toPage:'Z'))
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:DtlNam:
/5635c                              DtlNamLen:%addr(wkPage):%len(%trim(wkPage)))
/5635
/5635 * build log header
/5635c                   eval      LogUserID = wqusrn
/5635c                   eval      LogObjID  = SpyNum
/5635c                   eval      LogPagNbr = -1
/5635c                   callp     LogEntry(%addr(LogDS))
/5635
/5635c                   return
     c*------------------------------------------------------------------------
     c*- BldFaxDtl - build detail information for Fax object logging
     c*------------------------------------------------------------------------
     c     BldFaxDtl     begsr
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'BldFaxDtl' : blnDebug)

      * build fax number detail
     c                   eval      DtlType = #DTFAX
     c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:DtlNam:
     c                              DtlNamLen:%addr(FaxNum):%len(%trim(FaxNum)))
     c                   if        rc < 0
     c                   LeaveSr
     c                   endif

      * build Fax Recipient detail
     c                   eval      DtlType = #DTRNAME
     c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:DtlNam:
     c                              DtlNamLen:%addr(FaxTo):%len(%trim(FaxTo)))
     c                   if        rc < 0
     c                   LeaveSr
     c                   endif

     c                   endsr
     c*------------------------------------------------------------------------
     c*- BldPrtDtl - build detail information for print object logging
     c*------------------------------------------------------------------------
     c     BldPrtDtl     begsr
J2469c                   Callp(e)  SubMsgLog( blnDebug : 'BldPrtDtl' : blnDebug)

      * build Print detail
     c                   eval      DtlType = #DTPTR
     c                   if        Writer <> *blanks
     c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:DtlNam:
     c                              DtlNamLen:%addr(Writer):%len(%trim(Writer)))
     c                   else
     c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:DtlNam:
     c                              DtlNamLen:%addr(Outq):%len(%trim(Outq)))
     c                   endif
     c                   if        rc < 0
     c                   LeaveSr
     c                   endif

     c                   endsr
     c*------------------------------------------------------------------------
/5635p                 e
/2813pRenderIFSFile    b
/    dRenderIFSFile    pi            10i 0
/    d aSpyNumber                    10a   const
/    d aFolderLib                    10a   const
/    d aFileName                     10a   const
/    d aExtention                     3a   const
/    d aPath                        128a   const options(*varsize)
/    d aCodePage                     10u 0 const
/    d aReplaceSeq                    1a   const
/    d aintBegin                     10u 0 const
/    d aintEnd                       10u 0 const
/    d aintTotal                     10u 0 const
/    d astrIFSFile                  256a
/    d aSeqNumber                    10i 0 const options(*nopass)

J2814d BldPCLPgs       pr                  ExtPgm('BLDPCLPGS')
/    d  pOpCode                       6a   const
/    d  pPagFrm                      10u 0 const
/    d  pPagTo                       10u 0 const
/    d  pTFileData                         likeds(TFileData)
/    d  pALSend                            like(ALSend)
/    d  pKeyData                   1000a
/    d  pMsgID                        7a
/    d  pMsgDta                     100a




J2814
/    dTRUE             c                   '1'
     dFALSE            c                   '0'
/    dOK               c                   0
/    dERROR            c                   -1
/    dREPLACE_SEQ      c                   'S'
/    dREPLACE_YES      C                   'Y'
/    dREPLACE_NO       c                   'N'
/    dBLDPCL_PCLDTA    c                   'PCLDT'
/    dASTERICK         c                   '*'
/    dSLASH            c                   '/'


J2814 * FileName structure passed on open function
/    d TFileData       ds                  inz                                  Open Filename D
/    d  SplFilNam                    10                                         Spooled File Na
/    d  SplJobNam                    10                                         Spooled File Jo
/    d  SplUsrNam                    10                                         Spooled File Us
/    d  SplJobNum                     6                                         Spooled File Jo
/    d  SplFilNum                    10i 0                                      Spooled File Fi
/    d  SplFld                       10                                         Folder to archi
/    d  SplFldLib                    10                                         Folder library
/    d  SplSpyNum                    10                                         SPY000.. Number
/    d  SplOpt                        1                                         Optical '1'=YES
/    d  SplType                       1                                         File to Open
/     *   :                                                                     'A'=Attribute r
/     *   :                                                                     '1'=QSPL Member
/     *   :                                                                     '2'=A0000... Fi
/     *   :                                                                     '3'=AP000... Fi
/     *   :                                                                     '4'=DISP... Fil
/     *   :                                                                     '5'=Resource
/     *   :                                                                     '6'=Font List
/     *   :                                                                     '7'=Macro List
/     *   :                                                                     '8'=State data
/    d  SplTrnTbl                    10                                         Translation Tab
/    d  SplTrnLib                    10                                         Translation Tab
/    d  SplOptDrv                    15                                         Optical Drive
/    d  SplOptVol                    12                                         Optical Volume
/    d  SplOptRnm                    10                                         Optical Report
/
/    d                 ds
/    d strAPFlen               1      4a
/    d intAPFlen               1      4i 0
/
/    dblnFirstBuffer   s               n   inz(TRUE)
/    dblnRptID         s               n   inz(FALSE)
/    dstrASCBuf        s           4075a
/    dintOFlag         s             10i 0
/    dintMode          s             10u 0
/    dintReturn        s             10i 0 inz(OK)
/    dintSeqNumber     s             10i 0 inz static
/    dstrPath          s            128a
/    dstrPCLPath0      s            256a
/    dstrIFSFile0      s            256a
/    dstrKeyData       s           1000a
/    dstrMsgID         s              7a   inz(*allx'00')
/    dstrMsgDta        s            100a   inz(*allx'00')
/
/     /free
/      Monitor;

/         gstrPCLFile = astrIFSFile;

/         If NOT %open(MRptDir7);
/           open(e) MRptDir7;
/         EndIf;
/
/         Chain(e) (aSpyNumber) MRptDir7;
/
/         If %found = FALSE;
/           Close(e) MRptDir7;
/           intReturn = ERROR;
/           ExSr QuitSr;
/         EndIf;
/
/         Close(e) MRptDir7;
/         Open(e) mFldDir;
/         Chain(e) (fldr:fldrlb) MFldDir;
/
/         If NOT %found;
/           intReturn = ERROR;
/           ExSr QuitSr;
/         EndIf;
/
/         strPath = aPath;
/
/         // Remove trailing slashes and asterick
/
/         If ( %len(%trim(aPath)) > 1 );
/
/           DoW ( ( %subst(%trim(strPath):%len(%trim(strPath)):1) = SLASH  ) or
/               ( %subst(%trim(strPath):%len(%trim(strPath)):1) = ASTERICK )  );
/             strPath =  %subst(%trim(strPath):1:%len(%trim(strPath))-1);
/           EndDo;
/
/         EndIf;
/
/         curApfNam = apfnam;
/
/         blnRptID = ( TotPag = ( ( aintEnd - aintBegin ) + 1 ) );
/         Close(e) MfldDir;
/         Cmd('DLTOVR FILE(MFLDDIR)');
/           // Get the APFNam from MFLDDIR
/         If ( ObjExist( aFolderLib : CurAPFNam : '*FILE' ) <> OK );
/           intReturn = ERROR;
/           ExSr QuitSr;
/         EndIf;
/
/         Cmd('OVRDBF FILE(RAPFDBF) ' +
/             'TOFILE(' + %trim(aFolderLib) + '/' + %trim(CurAPFNam) + ') ' +
/             'MBR(RAPFDBF) OVRSCOPE(*CALLLVL)');
/         Open(e) RApfDBF;
/
J5464     // If %error = TRUE;
J5464     //   Close(e) RAPFDBF;
J5464     //  Cmd('DLTOVR FILE(MFLDDIR)');
J5464     //  intReturn = ERROR;
J5464     //  ExSr QuitSr;
J5464     // EndIf;
J2814
/
/         intMode  = O_CREAT + O_WRONLY + O_CODEPAGE;
/         intOFlag = S_IRWXU;
/
/         If ( aReplaceSeq = REPLACE_SEQ );
/           intSeqNumber += 1;
/           SpcSeq = intSeqNumber;
/           gstrPCLFile = %trim(strPath) + '/'
/                       + %trim(aFileName)
/                       + %char(intSeqNumber)
/                       + '.'
/                       + aExtention;
/
/           DoW ( accessIFS(gstrPCLFile:O_RDONLY) = OK );
/             intSeqNumber += 1;
/             SpcSeq = intSeqNumber;
/             gstrPCLFile = %trim(strPath) + '/'
/                         + %trim(aFileName)
/                         + %char(intSeqNumber)
/                         + '.'
/                         + aExtention;
/           EndDo;
/
/         Else;
/            gstrPCLFile = %trim(strPath) + '/'
/                       + %trim(aFileName)
/                       + '.'
/                       + aExtention;
/         EndIf;
/
/         strPCLPath0 = %trim( gstrPCLFile ) + x'00';
/
/         Select;
/           When ( aReplaceSeq = REPLACE_YES );
/              If ( accessIFS( gstrPCLFile : O_RDONLY) = OK );
/
/                If ( unlinkIFS(  gstrPCLFile ) < 0 );
/                  ExSr QuitSr;
/                EndIf;
/
/             EndIf;
/
/           When ( aReplaceSeq = REPLACE_NO  ); // File exist, exit
/             If  ( accessIFS(  gstrPCLFile :O_RDONLY) = OK );
/                ExSr QuitSr;
/             EndIf;
/         EndSl;
/
/         intPCLFH = Open( strPCLPath0
/                     : O_CREAT+O_WRONLY+O_CODEPAGE
/                     : S_IWUSR+S_IRUSR+S_IRGRP+S_IROTH
/                     : aCodePage );
/
/         If intPCLFH = ERROR;
/           p_errno = getErrno();
/           intReturn = ERROR;
/           ExSr QuitSr;
/         EndIf;
/         Select;
/           When ( blnRptId = TRUE );
/             ExSr BldReportSr;
/           When ( blnRptId = FALSE );
/             ExSr BldPagesSr;
/         EndSl;
/
/         Monitor;
/         // strAPFLen = %subst(apfdta:4076:4);
/         on-error *all;
/         EndMon;
/
/
/         rc = Close(intPCLFH);
/
/         If ( ( rc <> OK            )  or
/              ( p_errno = getErrno())     );
/           intReturn = ERROR;
/           ExSr QuitSr;
/         EndIf;
/
/         Close(e) RAPFDBF;
/         Cmd('DLTOVR FILE(RAPFDBF)');
/         Return intReturn;
/
/      on-error *all;
/        intReturn = ERROR;
/        Return intReturn;
/      EndMon;
/      //-----------------------------------------------------------------
/      BegSr BldReportSr;
J2469   Callp(e)  SubMsgLog( blnDebug : 'BldReportSr' : blnDebug ) ;
/
/       Monitor;
/       apfrep = aSpyNumber;
/       apfseq = 1;
/       Setll (ApfRep:ApfSeq) RApfDBF;
/       Chain(e) (ApfRep:ApfSeq) ApfDBF;
/
/       If ( ( %error = TRUE ) or
/            ( NOT %found    )    );
/         Close(e) RApfDBF;
/         Cmd('DLTOVR FILE(MFLDDIR)');
/         intReturn = ERROR;
/         ExSr QuitSr;
/       EndIf;
/
/       DoU (%eof = TRUE);
/         // Flush the ASCII bufferr
/         strASCBuf = *allx'00';
/         // Capture tthe data portion of the APFDta Field
/         strAPFLen = %subst(apfdta:4076:4);
/
/         If ( blnFirstBuffer = TRUE );
/           blnFirstBuffer = FALSE;
/           %subst( strASCBuf : 1 : intAPFLen - 19 ) =
/           %subst( apfdta : 20 : intAPFLen - 19);
/         Else;
/           %subst( strASCBuf : 1 : intAPFLen) =
/           %subst( apfdta : 1 : intAPFLen);
/         EndIf;
/
/         Callp(e) Write( intPCLFH  : strASCBuf  : intAPFLen);
/         apfseq = apfseq + 1;
/         Reade(e) (ApfRep:ApfSeq) ApfDBF;
/       EndDo;
/
/
/         on-error *all;
/           intReturn = ERROR;
/           ExSr QuitSr;
/         EndMon;
/
/      EndSr;
/      //-----------------------------------------------------------------
/      BegSr BldPagesSr;
J2469    Callp(e)  SubMsgLog( blnDebug : 'BldPagesSr' : blnDebug ) ;
/        SplSpyNum = aSpyNumber;
/        Reset strMsgID;
/        Reset strMsgDta;
/        // Reset strKeyData;
/
/        Callp(e) BldPCLPgs( BLDPCL_PCLDTA : aintBegin
/                           : aintEnd   : TFileData
/                           : ALSend    : strKeyData
/                           : strMsgID  : strMsgDta );
/
/      //  If ( ( %error    = TRUE    )  or
/      //       ( strMsgID <> *blanks )      );
/      //    intReturn  = ERROR;
/      //    ExSr QuitSr;
/      //  EndIf;
/
/        Callp(e) Write( intPCLFH  : strASCBuf  : intAPFLen);
/      EndSr;
/      //-----------------------------------------------------------------
/      BegSr QuitSr;
J2469    Callp(e) SubMsgLog( blnDebug : 'QuitSr' : blnDebug ) ;
/        Return intReturn;
/      EndSr;
/     /end-free
/    pRenderIFSFile    e
/     //---------------------------------------------------------------------
/    pObjExist         b
/    dObjExist         pi            10i 0
/    d aLibrary                      10a   const options(*varsize)
/    d aObject                       10a   const options(*varsize)
/    d aType                          7a   const options(*varsize)
/    d strCommand      s           3000a
/    d ERROR           c                   -1
/    d OK              c                   0
/    d intReturn       s             10i 0 inz(OK)
/     /free
/      Monitor;
/        reset intReturn;
/        strCommand =  'chkobj obj(' + %trim(aLibrary) + '/' +
/                      %trim(aObject) + ') OBJTYPE(' +
/                      %trim(aType) + ')';
/        Callp(e) Cmd(strCommand);
/        Return intReturn;
/
/       On-error *all;
/         intReturn = ERROR;
/        Return intReturn;
/       EndMon;
/     /end-free
/    pObjExist         e
/     //---------------------------------------------------------------------
J2814pRenderPCLPDF     b
/    dRenderPCLPDF     pi            10i 0
/    d astrIFSFile                  256a
J5464d aFrmPage                      10u 0 const options( *nopass )
J5464d aToPage                       10u 0 const options( *nopass )

J5464d WrtPCLPgs       pr                  ExtPgm('BLDPCLPGS')
J5464d  pOpCode                       6a   const
J5464d  pPagFrm                      10u 0 const
J5464d  pPagTo                       10u 0 const
J5464d  pTFileData                         likeds(TFileData)
J5464d  pALSend                            like(ALWrite)
J5464d  pKeyData                   1000a
J5464d  pMsgID                        7a
J5464d  pMsgDta                     100a
J5464d
J5464d PARMPAGERANGE   c                   3
J5464 * FileName structure passed on open function
J5464d TFileData       ds                  inz                                  Open Filename D
J5464d  SplFilNam                    10                                         Spooled File Na
J5464d  SplJobNam                    10                                         Spooled File Jo
J5464d  SplUsrNam                    10                                         Spooled File Us
J5464d  SplJobNum                     6                                         Spooled File Jo
J5464d  SplFilNum                    10i 0                                      Spooled File Fi
J5464d  SplFld                       10                                         Folder to archi
J5464d  SplFldLib                    10                                         Folder library
J5464d  SplSpyNum                    10                                         SPY000.. Number
J5464d  SplOpt                        1                                         Optical '1'=YES
J5464d  SplType                       1                                         File to Open
J5464 *   :                                                                     'A'=Attribute r
J5464 *   :                                                                     '1'=QSPL Member
J5464 *   :                                                                     '2'=A0000... Fi
J5464 *   :                                                                     '3'=AP000... Fi
J5464 *   :                                                                     '4'=DISP... Fil
J5464 *   :                                                                     '5'=Resource
J5464 *   :                                                                     '6'=Font List
J5464 *   :                                                                     '7'=Macro List
J5464 *   :                                                                     '8'=State data
J5464d  SplTrnTbl                    10                                         Translation Tab
J5464d  SplTrnLib                    10                                         Translation Tab
J5464d  SplOptDrv                    15                                         Optical Drive
J5464d  SplOptVol                    12                                         Optical Volume
J5464d  SplOptRnm                    10
/    d GHOST           c                   '*GHOST'
/    d OK              c                   0
/    d ERROR           c                   -1
/    d LF              C                   x'0D'
/    d blnRptID        s               n
/     * Determines if this is an entire report
/    d strCmdPath      s            256a
/    d strSrcIFSFile   s            256a
/    d strTgtIFSFile   s            256a
/    d intReturn       s             10i 0 inz(OK)
/    d strCommand      s           3000a
/    d intStatus       s             10i 0
/    d i               s             10i 0
J3470d intFh           s             10i 0
/    d strLine         s            132a
/    d strLog          s             80a
J5464dstrMsgID         s              7a   inz(*allx'00')
J5464dstrMsgDta        s            100a   inz(*allx'00')
J5464dstrKeyData       s           1000a
J2814 /free
/      intReturn = OK;
/
/      Callp(e) SpyPath(GHOST:strCmdPath);
/      If %error = TRUE;
/        unlinkIFS(strSrcIFSFile);
/        intReturn = ERROR;
/        Return intReturn;
/      EndIf;
/
/      // Determines if this is an entire report
/
/      strSrcIFSFile = astrIFSFile;
/      strTgtIFSFile = %replace('PDF ' : strSrcIFSFile : %scan('PCL '
/                    : strSrcIFSFile ));
J5464
J5464  //If ( %parms = PARMPAGERANGE );
J5464  //  flags = O_WRONLY + O_CREAT + O_TRUNC;
J5464  //  mode  = S_IRUSR + S_IWUSR + S_IRGRP;
J5464  // fd = IFSopen(  %trimr( strSrcPathFile )
J5464  //              : O_CREAT + O_TRUNC + O_WRONLY + O_CODEPAGE
J5464  //              : S_IRWXU + S_IRWXG + S_IRWXO
J5464  //              : intCodePageWin );
J5464  //  IFSClose(fd);
J5464  //  fd = IFSOpen( %trimr( strSrcIFSFile ):flags:mode);
J5464  //
J5464  //  If ( fd < 0 );
J5464  //    Return fd;
J5464  //  EndIf;
J5464  //
J5464  //  ExSr WrtPCLPGSSr;
J5464     // Check for error code here and report and recover
J5464  //  IFSClose(fd);
J5464  //EndIf;

/      strCommand = %trim(strCmdPath)
/                 + '/pcl6 '
J5343             + ' -lPCL5E '
J5343             + ' -sDEVICE=pdfwrite '
J5343             + ' -dNOPAUSE '
J2811             + ' -sOutputFile=' + %trim(strTgtIFSFile)
                  + ' '
J5467             + %trim(strSrcIFSFile) + x'00';
J5467  // remove the redirection
/      ExSr QzShSetup;
/      intStatus = QzshCommand(strCommand);
/
/       // Update the user space with the document information
/       // for the output.
/
/       SpcTyp = '*SPYLINK';
/       SpcPth = strTgtIFSFile;
/       OpnSpc = TRUE;
/
/       Callp(e) UpdateDoc( SPCOPC_UPDDOC : SpcObj  : SpcTyp : SpcSeg
/                         : DTS     : SpcFrm  : SpcTo   : SpcFmt  : ToCdePag
/                         : SpcJoi  : SpcPth : SpcSpy  : SpcSeq  : IFRePl
/                         : SpcMsg  : SpcDta  : IgnBatch );
/
/      Select;
/        When (  ( WIFEXITED(intStatus) <> 0  ) and
/                ( WEXITSTATUS(intStatus) = 0 )      );
/        When ( WIFEXITED(intStatus) <> 0 );
/          PCRtnD = 'Exit Status = ' + %editc(WTERMSIG(intStatus): 'N');
/          unlinkIFS(strSrcIFSFile);
/          intReturn = ERROR;
/        When ( WIFSIGNALED(intStatus) <> 0 );
/          PCRtnD = 'Ended with a signal ' +
/                   %editc(WTERMSIG(intStatus): 'N');
/          unlinkIFS(strSrcIFSFile);
/          intReturn = ERROR;
/        When ( WIFEXCEPTION(intStatus) <> 0 );
/          PCRtnD = 'Ended with error ' + WEXCEPTMSGID(intStatus);
/          intReturn = ERROR;
/      EndSl;
/
/      unlinkIFS(strSrcIFSFile);
/      ExSr QzShClose;

J3470  ExSr RedirectQshellMsg;
J5467   // To handle procedure call exceptions
J5467   // preface the call with the operations
J5467   // extender
J5467  Callp(e) unlinkIFS('/tmp/stderr-'+jnr);
J5467  Callp(e) unlinkIFS('/tmp/stdout-'+jnr);

J2814  return intReturn;
J3470   //--------------------------------------------------------------
/       BegSr RedirectQShellMsg;
/       //--------------------------------------------------------------
/       // Open up the QShell log file and echo to the job log. Lastly
/       // close the log file and delete it.
/       //--------------------------------------------------------------
J2469     Callp(e) SubMsgLog( blnDebug : 'RedirectQShellMsg' : blnDebug ) ;
J5464     Callp(e) statIFS('/tmp/stderr-'+jnr : %addr(stat_ds) );

J5464     If (st_size <= 0 );
J5464       leaveSr;
J5465     EndIf;

J2469     If ( AccessIFS('/tmp/stderr-'+jnr : O_RDONLY ) = OK );
/           intFh = OpenIFS( '/tmp/stderr-'+jnr : O_RDONLY );
/
/           If ( intFh < 0 );
/             LeaveSr;
/           EndIf;
/
/           DoW ( ReadLine( intFh : %addr( strLine) : %size( strLine )) >= 0 );
/             strLog = strLine;
/             MMMSGIO_SndMsg( 'CPF9897' : strLog );
/           EndDo;

/           Callp(e) close( intFh );
/         EndIf;
/
/        EndSr;
J2814   //--------------------------------------------------------------
/       BegSr QzShClose;
/       //--------------------------------------------------------------
J2469   Callp(e)  SubMsgLog( blnDebug : 'QzShClose' : blnDebug ) ;
/       For i = 0 to 2;
/         Callp(e) close(i);
/       EndFor;
/       EndSr;
/       //--------------------------------------------------------------
/       BegSr QzShSetup;
/       //--------------------------------------------------------------
/       // File descriptors 0,1, & 2 are used by unix environmsngs for
/       // stdin, stdout, & stderr. Redirect these discriptors to stream
/       // files.
/       //---------------------------------------------------------------
J2469   Callp(e)  SubMsgLog( blnDebug : 'QzShClose' : blnDebug ) ;
/       For  i = 0 to 2;
/         Callp(e) close(i);
/       EndFor;
/
/       PCRtnD = *blanks;
/
/       If ( openIFS('/dev/qsh-stdin-null':O_RDONLY)<>0  );
/         strLog = 'Unable to open fake STDIN';
/         MMMSGIO_SndMsg( 'CPF9897' : strLog );
/       EndIf;
/
/       If ( openIFS('/tmp/stdout-'+jnr:O_WRONLY+O_CREAT+O_TRUNC: 511)<>1 );
/         strLog = 'Unable to open fake STDOUT';
/         MMMSGIO_SndMsg( 'CPF9897' : strLog );
/       EndIf;
/
/       If ( openIFS('/tmp/stderr-'+jnr
           : O_WRONLY+O_CREAT+O_TRUNC: 511)<>2 );
/         strLog = 'Unable to open fake STDERR';
/         MMMSGIO_SndMsg( 'CPF9897' : strLog );
/       EndIf;
/
/       If PCRtnD <> *blanks;
/
/         PCRtnC = 'DSP1356';
/
/         For i = 0 to 2;
/            Callp(e) close(i);
/         EndFor;
/
J4902     Return intReturn;
J2469   EndIf;
/       EndSr;
J5464   //-----------------------------------------------------
J5464   BegSr WrtPCLPgsSr;
J5464   //-----------------------------------------------------
J5464   //  Build a page segment to the IFS.
J5464   //-----------------------------------------------------
J5464        WrtPCLPgs( 'PCLDT'
J5464                 : aFrmPage
J5464                 : aToPage
J5464                 : TFileData
J5464                 : ALWrite
J5464                 : strKeyData
J5464                 : strMsgID
J5464                 : strMsgDta );
J5464  EndSr;
/     /end-free
/    pRenderPCLPDF     e
/     *-----------------------------------------------------------------------
/    p RtnStatus       b
/    d                 pi
/    d RtnCode                        2    const
/    d Program                       10    const
/    d File                          10    const
/    d MsgID                          7    const options(*nopass)               Message ID
/    d MsgData                      100    const options(*nopass)               Message Data
/     /FREE
/
/      select;
/        when ( ( RtnCode >= '30'  ) and                                                 //Fatal error
/               ( %parms >= 4      ) and
/               ( MsgID <> *blanks )     );
/          EMsgID = MsgID;
/          EMsgDt = MsgData;
/
/        when (  ( RtnCode >= '20' ) and
/              ( %parms >= 4     )   and
/              ( MsgID <> *blanks )      );
/          EMsgID = MsgID;
/          EMsgDt = MsgData;
/
/        when ( ( RtnCode = '22'   ) and                                                   //Top of data
/               ( %parms >= 4      ) and
/               ( MsgID <> *blanks )     );
/          EMsgID = MsgID;
/          EMsgDt = MsgData;
/
/        when ( ( RtnCode = '21'   ) and                                                  //Top of data
/             ( %parms >= 4      )   and
/             ( MsgID <> *blanks )       );
/          EMsgID = MsgID;
/          EMsgDt = MsgData;
/
/        when ( ( RtnCode >= '20'  ) and                                                 //End of data
/               ( %parms >= 4      ) and
/               ( MsgID <> *blanks )     );
/          EMsgID = MsgID;
/          EMsgDt = MsgData;
/        other;
/          EMsgID = *blanks;
/          EMsgDt = *blanks;
/      endsl;
/     /End-Free
/    p                 e
/     *----------------------------------------------------------------
/    p ALSendData      b
/    d ALSendData      pi            10i 0
/    d  Buffer                         *   value
/    d  BufferLn                     10u 0 value
/    d  BufferFlag                   10i 0 value                                last buffer
/    d  ErrorID                       8    value                                return error
/    d  ErrorData                   101    value                                return data
/
/    d  rc             s             10i 0
/    d  MaxBuf         s             10u 0
/     /Free
/      ErrorID   = x'00';
/      ErrorData = x'00';
/      RtnStatus('20':'CALLBACK':'DATA');
/      MaxBuf = 32767;
/
/      // Pass request to send function
/      rc = SendData( Buffer : BufferLn : MaxBuf : BufferFlag );
/
/      If rc < 0;
/        ErrorID   = 'ERR1371' + x'00';
/        ErrorData = 'SENDDATA' + x'00';
/        Return rc;
/      EndIf;
/
/      Return BufferLn;
/     /END-FREE
/    p ALSendData      e
/     *----------------------------------------------------------------
/    pSendData         b
/    dSendData         pi            10i 0
/    d  Data                           *   value
/    d  DataLn                       10u 0 value
/    d  MaxBufrSiz                   10u 0 value
/    d  LastBufrFlag                 10i 0 value                                last buffer
/
/     * Constants -------------------------------------------------------
/    d  ERROR          c                   -1
/    d  OK             c                   0
/    d  BufrLen        s              9s 0
/     * Variables -------------------------------------------------------
/    d  Bufr           s          32767    based(BufrP)
/    d  Pos            s             10i 0
/    d  Len            s             10i 0
/     /Free
/      BufrP = Data;
/      Pos = 0;
/      dou Pos = DataLn;
/        // copy to IFS PCL Buffer
/        Len = MaxBufrSiz - LastPos;
/
/        If ( Len > DataLn - Pos );                                               //get shortest
/          Len = DataLn - Pos;
/        EndIf;
/
/        If (  ( Len > 0 )       and
/              ( BufrP <> *null )     );
/          %subst(strPCLData:LastPos+1) =                                     //     copy data
/              %subst(Bufr:1:Len);
/          BufrP = BufrP + Len;
/        EndIf;
/
/        // Write a PCL Buffer
/        If ( ( LastPos+Len  =  MaxBufrSiz ) or                                         //full buffer
/             ( LastBufrFlag <> 0          )    );                                            //last buffer
/          BufrLen = LastPos + Len;
/
/          If ( Write( intPCLFH  : strPCLData : BufrLen ) < BufrLen );
/            return ERROR;
/          Else;
             rc = Close(intPCLFH);
             RenderPCLPDF(  gstrPCLFile );
/          EndIf;
/
/          strPCLData = *blanks;
/          LastPos = 0;
/        Else;                                                                //partial
/          LastPos = LastPos + Len;                                           //update position
/        EndIf;
/
/        Pos = Pos + Len;
/      EndDo;
/
/      return DataLn;
/     /End-Free
/    pSendData         e
/     *----------------------------------------------------------------
/     * Evaluates to a non-zero value if child terminated normally.
/     *  #define WIFEXITED(x)     (((x) & 0xFFFF0000) ? 0 :  0x00010000)
/     *----------------------------------------------------------------
/    P WIFEXITED       B                   export
/    D WIFEXITED       PI            10I 0
/    D   Status                      10I 0 value
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/    c                   eval      binary = Status
/    c                   bitoff    x'FF'         alpha3
/    c                   bitoff    x'FF'         alpha4
/    c                   if        binary <> 0
/    c                   return    0
/    c                   else
/    c                   eval      binary = 0
/    c                   biton     x'01'         alpha2
/    c                   return    binary
/    c                   endif
/
/    P                 E
/     *------------------------------------------------------------------
/     * Evaluates to a non-zero value if child terminated abnormally.
/     * #define WIFSIGNALED(x)   ((x) & 0x00020000)
/     *-------------------------------------------------------------------
/    P WIFSIGNALED     B                   export
/    D WIFSIGNALED     PI            10I 0
/    D   Status                      10I 0 value
/
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/
/    c                   eval      binary = Status
/    c                   bitoff    x'FF'         alpha1
/    c                   bitoff    x'FD'         alpha2
/    c                   bitoff    x'FF'         alpha3
/    c                   bitoff    x'FF'         alpha4
/    c                   return    binary
/
/    P                 E
/     *------------------------------------------------------------------
/     * Evaluates to a non-zero value if status returned for a stopped
/     * child.
/     * #define WIFSTOPPED(x)    ((x) & 0x00040000)
/     *-------------------------------------------------------------------
/    P WIFSTOPPED      B                   export
/    D WIFSTOPPED      PI            10I 0
/    D   Status                      10I 0 value
/
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/
/    c                   eval      binary = Status
/    c                   bitoff    x'FF'         alpha1
/    c                   bitoff    x'FB'         alpha2
/    c                   bitoff    x'FF'         alpha3
/    c                   bitoff    x'FF'         alpha4
/    c                   return    binary
/
/    P                 E
/     *---------------------------------------------------------------------
/     * Evaluates to a non-zero value if status returned for a
/     * child process that terminated due to an error state.
/     * #define WIFEXCEPTION(x)  ((x) & 0x00080000)
/     *----------------------------------------------------------------------
/    P WIFEXCEPTION    B                   export
/    D WIFEXCEPTION    PI            10I 0
/    D   Status                      10I 0 value
/
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/
/    c                   eval      binary = Status
/    c                   bitoff    x'FF'         alpha1
/    c                   bitoff    x'F7'         alpha2
/    c                   bitoff    x'FF'         alpha3
/    c                   bitoff    x'FF'         alpha4
/    c                   return    binary
/
/    P                 E
/     *-------------------------------------------------------------------
/     * Evaluates to the low-order 8 bits from the childs exit status.
/     * #define WEXITSTATUS(x)   (WIFEXITED(x) ? ((x) &  0x000000FF) : -1)
/     *-------------------------------------------------------------------
/    P WEXITSTATUS     B                   export
/    D WEXITSTATUS     PI            10I 0
/    D   Status                      10I 0 value
/
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/
/    c                   if        WIFEXITED(status) <> 0
/    c                   eval      binary = status
/    c                   bitoff    x'FF'         alpha1
/    c                   bitoff    x'FF'         alpha2
/    c                   bitoff    x'FF'         alpha3
/    c                   return    binary
/    c                   else
/    c                   return    -1
/    c                   endif
/    P                 E
/     *----------------------------------------------------------------------
/     * Evaluates to the number of the signal that caused the child to stop.
/     * #define WSTOPSIG(x)      (WIFSTOPPED(x) ? ((x) &
/     * 0x0000FFFF) : -1)
/     *----------------------------------------------------------------------
/    P WSTOPSIG        B                   export
/    D WSTOPSIG        PI            10I 0
/    D   Status                      10I 0 value
/
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/    c                   if        WIFSTOPPED(status) <> 0
/    c                   eval      binary = status
/    c                   bitoff    x'FF'         alpha1
/    c                   bitoff    x'FF'         alpha2
/    c                   return    binary
/    c                   else
/    c                   return    -1
/    c                   endif
/    P                 E
/     *------------------------------------------------------------------
/     * Evaluates to the number of the signal that caused the child to
/     * terminate.
/     * #define WTERMSIG(x)      (WIFSIGNALED(x) ? ((x) &  0x0000FFFF) : -1)
/     *------------------------------------------------------------------
/    P WTERMSIG        B                   export
/    D WTERMSIG        PI            10I 0
/    D   Status                      10I 0 value
/
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/    c                   if        WIFSIGNALED(status) <> 0
/    c                   eval      binary = status
/    c                   bitoff    x'FF'         alpha1
/    c                   bitoff    x'FF'         alpha2
/    c                   return    binary
/    c                   else
/    c                   return    -1
/    c                   endif
/    P                 E
/     *---------------------------------------------------------------------
/     * Evaluates to the number of the OS/400 Exception that caused the
/     * child to terminate.
/     * #define WEXCEPTNUMBER(x) (WIFEXCEPTION(x) ? ((x) & 0x0000FFFF) : -1)
/     *----------------------------------------------------------------------
/    P WEXCEPTNUMBER   B                   export
/    D WEXCEPTNUMBER   PI            10I 0
/    D   Status                      10I 0 value
/
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/
/    c                   if        WIFEXCEPTION(status) <> 0
/    c                   eval      binary = status
/    c                   bitoff    x'FF'         alpha1
/    c                   bitoff    x'FF'         alpha2
/    c                   return    binary
/    c                   else
/    c                   return    -1
/    c                   endif
/    P                 E
/     *------------------------------------------------------------------
/     *  Evaluates to the OS/400 exception msg id for the status code.
/     *  returns *blanks if no exception id is indicated.
/     *--------------------------------------------------------------------
/    P WEXCEPTMSGID    B                   export
/    D WEXCEPTMSGID    PI             7A
/    D   Status                      10I 0 value
/
/     * Exception numbers returned by WEXCEPTNUMBER() can be turned into
/     * exception id's by using the following process:
/     *
/     * If the number returned (in hex) is 0x0000wwyy, and if zz is the
/     * decimal conversion of ww, then the exception id is "MCHzzyy".
/     *
/     * Example: WEXCEPTNUMBER(my_status) --> 0x00002401 then the
/     *          exception id would be "MCH3601".
/
/    D cvthc           PR                  extproc('cvthc')
/    D  OutputHex                      *   value
/    D  InputBits                      *   value
/    D  OutputSize                   10I 0 value
/
/    D                 DS
/    D  binary                 1      4I 0
/    D  alpha1                 1      1A
/    D  alpha2                 2      2A
/    D  alpha3                 3      3A
/    D  alpha4                 4      4A
/
/    D                 DS
/    D  cvtbin                 1      2U 0 inz(0)
/    D  cvtalpha               2      2A
/
/    D  dsMsgID        DS
/    D   MCH                   1      3A   inz('MCH')
/    D   first2                4      5A
/    D   last2                 6      7A
/
/
/    c                   eval      binary = WEXCEPTNUMBER(status)
/    c                   if        binary = -1
/    c                   return    *blanks
/    c                   endif
/
/    c                   eval      cvtalpha = alpha3
/    c                   move      cvtbin        first2
/
/    c                   callp     cvthc(%addr(last2): %addr(alpha4): 2)
/    c                   return    dsMsgID
/
/    P                 E
/
/     *------------------------------------------------------------------------------
J2459p DtaqMsgLog      b
/     *------------------------------------------------------------------------------
/    d DtaqMsgLog      pi
/    d  ablnLog                        n   const
/    d  aProgram                     10a   const
/    d  aAPI                         10a   const
/    d  aKey                         20a   const
/    d  aDQMsg                      256a   const
/    d  LF             c                   x'25'
/    d  ASTERICK       c                   '*'
/     /free
/       If ( ablnLog = TRUE );
/         MsgLog( 'Program: ' + aProgram +
/                 'API    : ' + aAPI +
/                 'Key    : ' + akey + LF );
/         MsgLog( 'Msg    : ' + aDQMsg + LF );
/       EndIf;
/     /end-free
/    p DtaqMsgLog      e
J3358p GetPathString   b
/    d GetPathString   pi           256a
/    d  aPath                          *   value options(*string:*trim)

/    dSLASH            c                   '/'
/    dASTERICK         c                   '*'
/    d strPath         s            256a
      /free
         strPath = %str( aPath : %size( strPath ) );
/
/         // Remove trailing slashes and asterick
/
/         If ( %len(%trim(strPath)) > 1 );
/
J4902        If   %subst(%trim(strPath):%len(%trim(strPath)):1) = SLASH  or
/               %subst(%trim(strPath):%len(%trim(strPath)):1) = ASTERICK;
/
/              DoW  %subst(%trim(strPath):%len(%trim(strPath)):1) = SLASH  or
/                   %subst(%trim(strPath):%len(%trim(strPath)):1) = ASTERICK;
/                strPath =  %subst(%trim(strPath):1:%len(%trim(strPath))-1);
/              EndDo;
/
/            Else;
/
/              DoU ( %subst(%trim(strPath):%len(%trim(strPath)):1) = SLASH );
/                strPath =  %subst(%trim(strPath):1:%len(%trim(strPath))-1);
/              EndDo;

/              strPath =  %subst(%trim(strPath):1:%len(%trim(strPath))-1);
/           EndIf;

/        EndIf;
/
J3358    Return strPath;
/     /End-Free
/    p GetPathString   e
/    p GetFileName     b
/    d GetFileName     pi           256a
/    d  aPath                          *   value options(*string:*trim)
/    d  aFileName                      *   value options(*string:*trim)
/    d  aExtension                    3a   const
/    d  aReplaceSeq                   1a   const
J4902d  aSeqNbr                      10i 0 const options( *nopass )

J3358dREPLACE_SEQ      c                   'S'
/    dREPLACE_YES      C                   'Y'
/    dREPLACE_NO       c                   'N'
/    dOVERRIDE_SEQNBR  c                   5
/    d  intSeqNumber   s              5i 0 inz
/    d  strPathFile    s            256a
/    d  strFile        s            256a
/    d  strPath        s            256a
      /free
/      Select;
/        When ( aReplaceSeq = REPLACE_SEQ );
/
J4902    // J5758 If ( %parms >= OVERRIDE_SEQNBR );
/        // J5758  intSeqNumber = aSeqNbr;
/        // J5758 Else;
/        // J5758  intSeqNumber += 1;
/        // J5758 EndIf;
/
J3348      strPath = %str(aPath);
/          strFile =  %str(aFileName)
/          // J5758     + %editc(intSeqNumber:'X')
/                  + '.'
/                  + aExtension;
/          strPathFile = %trim( strPath ) + '/'
/                      + %trim( strFile );

/          DoW ( accessIFS(strPathFile:O_RDONLY) = OK );

/            // J5758 If %parms >= OVERRIDE_SEQNBR;
             // J5758  intSeqNumber = aSeqNbr;
             // J5758 Else;
/              intSeqNumber += 1;
             // J5758 EndIf;

/            strFile = %str(aFileName)
/                    + %editc(intSeqNumber:'X')
/                    + '.'
/                    + aExtension;
/            strPathFile = %trim( %str(aPath) ) + '/'
/                        + strFile;
/          EndDo;
/
/        When ( aReplaceSeq = REPLACE_YES );
/          strFile = %trim( %str(aFileName) )
/                  + '.'
/                  + aExtension;
J4902      strPathFile = %trim( %str(aPath) ) + '/'
J4902                    + strFile;
J4902      unlinkIFS( strPathFile );
J3358    When ( aReplaceSeq = REPLACE_NO  );
/          strFile = %trim( %str(aFileName) )
/                  + '.'
/                  + aExtension;
/        EndSl;
/
/      Return strFile;
/     /end-free
     p GetFileName     e
J3470p ReadLine        b
/    D ReadLine        pi            10i 0
/    D   aintFh                      10i 0 value
/    D   astrText                      *   value
/    D   aMaxLen                     10i 0 value
/    d ERROR           c                   -1
/    d CR              c                   x'25'
/     * Carriage Return
/    d NL              c                   x'0A'
/     * New Line
/    d LF              c                   x'0D'
/     * Line Feed
/    d rdbuf           s           1024a   static
/    d rdpos           s             10i 0 static
/    d rdlen           s             10i 0 static
/    d p_retstr        s               *
/    d RetStr          s          32766a   based( p_retstr )
/    d len             s             10i 0
/    d strErrMsg       s             80a
/     /free
/       len = *zero;
/       p_retstr = astrtext;
/       %subst( RetStr : 1 : aMaxLen ) = *blanks;
/
/       Dow ( TRUE = TRUE );
/
/         // Load Buffer
/         If ( rdpos >= rdlen );
/           rdpos = 0;
/           rdlen = readIFS(aintFh : %addr( rdbuf ) : %size( rdbuf ));
/
J5464       if ( rdlen < 0 );
J3470         p_errno = getErrno();
/             dsErrorCode.MsgID  = 'CPE'
/                                + %subst(%editc(Errno:'X'):7:4);
/             dsErrorCode.MsgDta = *blanks;
/             strErrMsg =
/             MMMSGIO_RtvMsgTxt( dsErrorCode.MsgID
/                              : dsErrorCode.MsgDta
/                              : 'QCPFMSG' );
/             MMMSGIO_SndMsg( 'CPF9897' : strErrMsg );
/             Return ERROR;
/           EndIf;
/
/         EndIf;
/
/         // Is this the end of the line
/
/         rdpos += 1;
/
/         If (  ( %subst( rdbuf : rdpos : 1 ) = CR ) or
                ( %subst( rdbuf : rdpos : 1 ) = NL )    );
/           Return len;
/         EndIf;
/
/         // Otherwise add it to the text string
/
/         If ( ( %subst( rdbuf : rdpos : 1 ) <> LF ) and
/              ( len <> aMaxLen )                      );
/           len += 1;
/           %subst( retstr : len : 1 ) =  %subst( rdbuf : rdpos : 1 );
/         EndIf;
/       EndDo;
/
/       Return len;
/
/     /End-free
/    p ReadLine        e
/     //--------------------------------------------------------------------------
J2619p ConvImgPDF      b
/    d ConvImgPDF      pi            10i 0
/    d  aIFSPath                    256a
/    d  aImgType                      5a   const
/    d  aImgExt                       5a   const
/    d  aDeleteOrg                    1a   const
/
J2620d  intUsrSpcPos   s              9b 0 inz(1)
J2619d  intChrRead     s             10i 0
/    d  intImgFH       s             10i 0
/     * Image file Handle
/    d  intReturn      s             10i 0 INZ(OK)
/    d  intLineCount   s             10i 0
/    d  intOrgLPI      s                   like(@lpi)
/    d  intOrgPagle    s                   like(@pagle)
/    d  intOrgcpi      s                   like(@cpi)
/    d  intOrgpagwi    s                   like(@pagwi)
/    d  intPDFFH       s             10i 0
/     * PDF file Handle
/    d  strIType       s             16a
/     * Image type for processing
/    d strImgString    s              5a   inz(x'00')
/     * Image string for opening image file
/    d intInteger      s             10i 0 inz(*zeros)
/    d IKey            s             32a
/    d Phloat          s             15p 5
/    d IWidth          s                   like(phloat)
/    d IHeight         s                   like(phloat)
/    d IResX           s                   like(phloat)
/    d IResY           s                   like(phloat)
/    d IValue          s            256a
/    d PWidth          s                   like(phloat)
     d PHeight         s                   like(phloat)
/    d p_PDFfh         s               *
/    d p_ImgFh         s               *
     d Res             s                   like(phloat) inz(200)
/    d rc              s             10i 0
/    d str1            s              5a
     d str2            s              5a
/    d  strTgtIFSPath  s            256a
J2620d  p_strTgtIFSPath...
/    d                 s               *   inz(%addr( strTgtIFSPath ) )
J2619d  strSrcIFSPath  s            256a
J2620d  p_strSrcIFSPath...
/    d                 s               *   inz(%addr( strSrcIFSPath ) )
J2619d  strBaseName    s            256a
/    d  strLine        s            256a
/    d  Sy             s                   like(phloat) inz(1)
     d  Sx             s                   like(phloat) inz(1)
/    d  TxtPDFh        s               *
/     * file handle of new PDF file
/
/     * handle for target PDF file
/     /free
/      Monitor;
/
/        // Path cannot be blanks
/
/        If  ( aIFSPath = *blanks );
/          MMMSGIO_SndMsg( 'ERR0170' : *blanks : 'PSCON' );
/          intReturn = ERROR;
/          ExSr ConvImgPDF_QuitSr;
/        EndIf;
/
/        // Path Extension must match image type
/
/        // If ( ToUpper( GetPathExt(aIFSPath) )
         //     <> %trim( aImgExt ) );
/        //  MMMSGIO_SndMsg( 'CPF9897' : 'Extension not ' + aImgType );
/        //  intReturn = ERROR;
/        //  ExSr ConvImgPDF_QuitSr;
/        // EndIf;
/
/        // Source Path must exist
/
/        If ( AccessIFS(%trimr(aIFSPath) : O_RDONLY ) <> OK );
/          MMMSGIO_SndMsg( 'ERR4108' : *blanks : 'PSCON' );
/          intReturn = ERROR;
/          ExSr ConvImgPDF_QuitSr;
/        EndIf;
/
/        // Delete Original Needs to be Yes or No
/
/        If ( ( aDeleteOrg <> DELETEORG_YES ) and
/             ( aDeleteOrg <> DELETEORG_NO  )     );
/          MMMSGIO_SndMsg( 'CPF9897' :
/                          'ConvImgPDF invalid paramter value not Y or N' );
/          intReturn = ERROR;
/          ExSr ConvImgPDF_QuitSr;
/        EndIf;
/
/        //  Delete original is NO and the target exist
/
/        strBaseName = %Trim( GetPathBaseName( aIFSPath ) ) + '.' + EXT_PDF;
/
/        If ( AccessIFS( %trimr( strBaseName ) : O_RDONLY ) = OK );
/          If ( aDeleteOrg = DELETEORG_NO );
/            MMMSGIO_SndMsg( 'ERR4095' : strBaseName : 'PSCON' );
/            intReturn = ERROR;
/            ExSr ConvImgPDF_QuitSr;
/          ElseIf ( aDeleteOrg = DELETEORG_YES );
/            unlinkIFS(strBaseName);
/          EndIf;
/        EndIf;

J2620    If ( aImgType <> IMGTYPE_BMP );
J2619      ExSr ConvImgPDF_InitPDF;
/          p_PDFfh = PDFNew;
/
/          If ( p_PDFfh = *null );
/            ExSr ConvImgPDF_QuitSr;
/          EndIf;
/
J2620    ElseIf ( aImgType = IMGTYPE_BMP );
/          p_PDFfh = PDFNew;
/
/          If ( p_PDFfh = *null );
/            ExSr ConvImgPDF_QuitSr;
/          EndIf;
/
/          strSrcIFSPath = aIFSPath;
/          strTgtIFSPath = %Trim( GetPathBaseName( aIFSPath ) ) + '.' +
/                          EXT_TIF;
/          reset dsErrorCode;
/          strOptions = '-c none' + x'00';
/          strSrcIFSPath = %trim(strSrcIFSPath) + x'00';
/          strTgtIFSPath = %trim(strTgtIFSPath) + x'00';
/
/          // Open the resulting TIFF file to establish the
/          // correct code page of 1252
/
/          fd = IFSopen(p_strTgtIFSPath
/                      : O_CREAT + O_TRUNC + O_WRONLY + O_CODEPAGE
/                      : S_IRWXU + S_IRWXG + S_IRWXO
/                      : intCodePageWin );
/          IFSClose(fd);
/
/          Callp(e) MGBMPToTIF( p_strOptions
/                             : p_strSrcIFSPath
/                             : p_strTgtIFSPath );
/          If ( ( %error = TRUE )               or
/               ( dsErrorCode.MsgID <> *blanks )   );
/            MMMSGIO_SndMsg( 'CPF9897' :
/                            'Issue calling MGBMPtoTIF' );
/            intReturn = ERROR;
/            ExSr ConvImgPDF_QuitSr;
/          Else;
/            unlinkIFS(strSrcIFSPath);
/            strSrcIFSPath = %Trim( GetPathBaseName( aIFSPath ) )
/                          + '.' + EXT_TIF;
/            strTgtIFSPath = %Trim( GetPathBaseName( aIFSPath ) )
/                          + '.' + EXT_PDF;
/          EndIf;
/        EndIf;
J2619
/        // Open the target PDF file
/
/        rc = PDFopnFile( p_PDFfh : %trim( strTgtIFSPath ) +  x'00');
/        IKey   = 'Title' + x'00';
/        IValue = 'Open Text Document' + x'00';
/        PDFsetInfo( p_PDFfh : IKey : Ivalue);
/        IKey   = 'Creator' + x'00';
/        IValue = 'Open Text' +x'00';
/        PDFsetInfo( p_PDFfh : IKey : Ivalue );
/
/        If ( AccessIFS(%trimr(strSrcIFSPath) : O_RDONLY ) = OK );
/
J2620      If ( aImgType = IMGTYPE_BMP );

J2619        strIType     = IMGTYPE_TIF;
J2620        strImgString =  x'00';
/            TIFFile      = %trimr( strSrcIFSPath ) + x'00';
/            TIFType      =  '0'+x'00';  // No AS/400 File
/            TIFOffset    =  '1'+x'00';  // 9 is the value used for
/                                        // the user spaces
/            stat(%addr(TIFFile):%addr(stat_ds));
/            reset dsErrorCode;
/            intUsrSpc = st_size + 9;
/
/            If ( intUsrSpc > MAXUSRSPC );
/              MMMSGIO_SndMsg( 'CPF9897' :
/                      %char(intUsrSpc)
/                      + ' exceeds maximum of '
/                      + %char(MAXUSRSPC));
/              intReturn = ERROR;
/              ExSr ConvImgPDF_QuitSr;
/            EndIf;
/            Callp(e) CrtUsrSpc( dsTifUsrSpc.UsrSpc     :
/                                dsTifUsrSpc.UsrSpcLib  :
/                                intUsrSpc              :
/                                dsErrorCode            );
/
/            If ( ( %error = TRUE ) or
/                 ( dsErrorCode.byteAvl > 0 ) );
/              MMMSGIO_SndMsg( 'CPF9897' :
/                              'Issue creating user space ' + dsTifUsrSpc);
/              intReturn = ERROR;
/              ExSr ConvImgPDF_QuitSr;
/            EndIf;
/
/            reset dsErrorCode;
/
/            strFileSize = %editc( st_size : 'X' );
/            reset intUsrSpcPos;
/            ChgUsrSpc( dsTifUsrSpc.UsrSpc : dsTifUsrSpc.UsrSpcLib
/                     : intUsrSpcPos : %size( strFileSize ) : strFileSize );
/            intUsrSpcPos += %size( strFileSize );
/            intTh = IFSOpen( strSrcIFSPath : O_RDONLY );
/            bytrem = st_size;
/            dtalen = %size(strTifDta);
/
/            Dow ( bytrem > 0 );
/
/              If ( IFSread( intTh : p_strTifDta : dtalen ) > 0);
/                ChgUsrSpc( dsTifUsrSpc.UsrSpc : dsTifUsrSpc.UsrSpcLib
/                         : intUsrSpcPos : dtalen : strTifDta );
/                intUsrSpcPos += dtalen;
/              Else;
/                MMMSGIO_SndMsg( 'CPF9897' :
/                                'Issue reading tiff file'
/                                + %trim(strSrcIFSPath) );
/                intReturn = ERROR;
/                ExSr ConvImgPDF_QuitSr;
/              EndIf;
/              bytrem -= dtalen;
               If ( bytrem < dtalen );
                 dtalen = bytrem;
               EndIf;
/            EndDo;

/            Callp(e) IFSClose( intTh );
/
/            Evalr TIFLength    =  %char(st_size) +x'00';
/            TifLength = %xlate(' ':'0':TIFLength);
/            TIFFile      = %trim(dsTifUsrSpc.UsrSpcLib) +
/                           '/' + %trim(dsTifUsrSpc.UsrSpc) + x'00';
/            TIFType      =  AS400_IO_USRSPC +x'00';
/            TIFOffset    =  '9'+x'00';  // 9 is the value used for
/                                        // the user spaces
/            intIMGFh = PDFOpnImgF( p_PDFFh
/                                 : strIType
/                                 : dsTIFtoPDF
/                                 : strImgString
/                                 : intInteger );
J2620      Else;
/            strIType = aImgType;
/            intIMGFh = PDFOpnImgF( p_PDFFh
/                                 : strIType
/                                 : %trimr( strSrcIFSPath ) + x'00'
/                                 : strImgString
/                                 : intInteger );
/          EndIf;
J2619
/
/          // Open the image file
/
/          Monitor;

/          On-Error *all;
/            Callp(e) DltUsrSpc( dsTifUsrSpc.UsrSpc : dsTifUsrSpc.UsrSpcLib );
/            intIMGFh = -1;
/           // PDFclsImg(p_PDFfh : intImgFh );
/            PDFclose( p_PDFfh );
/            unlinkIFS(strSrcIFSPath);
/            unlinkIFS(strTgtIFSPath);
/            intReturn = ERROR;
/            ExSr ConvImgPDF_QuitSr;
/          EndMon;
/
/          If ( intIMGFh < 0 );
/            MMMSGIO_SndMsg( 'CPF9897' :
/                          'Error PDFOpnImgF with ' + %trimr(strSrcIFSPath) );
/            ExSr ConvImgPDF_QuitSr;
/          EndIf;
/
/          //

/          IKey   = 'imagewidth' + x'00';
/          IWidth = PDFgetVal( p_PDFfh : IKey : intIMGFh );
/          IKey    = 'imageheight' + x'00';
/          IHeight = PDFgetVal( p_PDFfh : IKey : intIMGFh );
/          IKey  = 'resx' + x'00';
/          IResX = PDFgetVal(  p_PDFfh : IKey : intIMGFh );
/          IKey  = 'resy' + x'00';
/          IResY = PDFgetVal(  p_PDFfh : IKey : intIMGFh );
/
/          // determine page dimensions and scaling
/
/          If ( IWidth > 0 ) and ( IHeight > 0 );
/
/            If ( IResX > 0 );
/               Res = IResX;
/
/               If ( IResX <> IResY ) and ( IResY > 0 );
/                 Sy = IResX/IResY;
/               EndIf;
/
/             EndIf;
/
/             Sx = 72/Res;
/             PWidth  = IWidth * Sx;

/             If ( IResY > 0 );
/               PHeight = IHeight * (72/IResY);
              Else;
                PHeight = IHeight * sx;
              EndIf;

/           Else;
/             PWidth  = PDF_LtrWid;
/             PHeight = PDF_LtrHgt;
/           EndIf;
/
/           // Only creating one page here
/
/           PDFbgnPage( p_PDFfh : PWidth : PHeight );
/
/           // place image
/           if Sy <> 1;
/             PDFsave(  p_PDFfh );
/             PDFscale(  p_PDFfh :1:Sy);
/           EndIf;

/           PDFplacImg(  p_PDFfh : intIMGFh : 0 : 0 : Sx );

/           If Sy <> 1;
/             PDFrestore(  p_PDFfh );
/           EndIf;

/           // finish page
/           PDFendPage(  p_PDFfh );
/           PPState = *blanks;
/
/           // Close the pdf and image files
/           PDFclsImg(p_PDFfh : intImgFh );
            PDFclose( p_PDFfh );
/           unlinkIFS(strSrcIFSPath);
/
/           If ( aImgType = IMGTYPE_BMP );
/             Callp(e) DltUsrSpc( dsTifUsrSpc.UsrSpc : dsTifUsrSpc.UsrSpcLib );
/           EndIf;
/
/        Else;  // Source TIF file does not exist
/          MMMSGIO_SndMsg( 'CPF9897' :
/                          %trim( strSrcIFSPath ) + ' does not exist' );
/        EndIf;
/
/      Return intReturn;
/      on-error *all;
/        intReturn = ERROR;
/        Return intReturn;
/      EndMon;
/      //------------------------------------------------------
/      BegSR ConvImgPDF_InitPDF;
/      //------------------------------------------------------
J2469    Callp(e)  SubMsgLog( blnDebug : 'ConvImgPDF_InitPDF' : blnDebug ) ;
/        strSrcIFSPath = aIFSPath;
/        strTgtIFSPath = %Trim( GetPathBaseName( aIFSPath ) )
/                      + '.' + EXT_PDF;
/
/        ifPath = strTgtIFSPath;  // Used as a gobal var for opening
/                                 // the PDF IFS file
/
/        // Since the original PDFLib
/        // uses fopen to create files on the IFS
/        // without regard to the intended CCSID
/        // create and close targe file prior to
/        // callinig OpenPDF
/
/        Callp SPYIFS( 'OPEN'
/                    : strTgtIFSPath
/                    : *blanks
/                    : 0
/                    : FrmCCS
/                    : CCSID_819
/                    : IFSRtn);
/
/        Callp SPYIFS( 'QUIT'
/                    : strTgtIFSPath
/                    : *blanks
/                    : 0
/                    : FrmCCS
/                    : CCSID_819
/                    : IFSRtn);
/
/      EndSr;
/      //------------------------------------------------------
/      BegSR ConvImgPDF_QuitSr;
/      //------------------------------------------------------
J2469    Callp(e)  SubMsgLog( blnDebug : 'ConvImgPDF_QuitSr' : blnDebug ) ;
/        Return intReturn;
/      EndSr;
/     /end-free
/    p ConvImgPDF      e

J2470p ConvTXTPDF      b
/     //--------------------------------------------------------------------------
/     // Convert from text to PDF for an existing IFS File.                      -
/     //--------------------------------------------------------------------------
/    d ConvTxtPDF      pi            10i 0
/    d  aIFSPath                    256a
/    d  aDeleteOrg                    1a   const
/    d  aLPI                         10i 0 const
/    d  aPageLength                  10i 0 const
/    d  aCPI                         10i 0 const
/    d  aPageWidth                   10i 0 const

/    d  PAGELINES      c                   66
/    d  intReturn      s             10i 0 INZ(OK)
/    d  strTgtIFSPath  s            256a
/    d  strSrcIFSPath  s            256a
/    d  strBaseName    s            256a
/    d  strLine        s            256a
/    d  TxtPDFh        s               *
/    d  intLineCount   s             10i 0
/    d  intOrgLPI      s                   like(@lpi)
/    d  intOrgPagle    s                   like(@pagle)
/    d  intOrgcpi      s                   like(@cpi)
/    d  intOrgpagwi    s                   like(@pagwi)
/    d  intChrRead     s             10i 0
/
/     * handle for target PDF file
/     /free
/      Monitor;
/        // Save the original values
/
/        intOrgLPI   = @lpi;
/        intOrgPagle = @pagle;
/        intOrgcpi   = @cpi;
/        intOrgpagwi = @pagwi;
/
/        // Override the print attributes
/
/        @lpi   = aLPI;
/        @pagle = aPageLength;
/        @cpi   = aCPI;
/        @Pagwi = aPageWidth;
/
/        // Validate Parameters
/
/        // Path cannot be blanks
/
/        If  ( aIFSPath = *blanks );
/          MMMSGIO_SndMsg( 'ERR0170' : *blanks : 'PSCON' );
/          intReturn = ERROR;
/          ExSr ConvTXTPDF_QuitSr;
/        EndIf;
/
/        // Path Extension must be TXT
/
/        If ( ToUpper( GetPathExt(aIFSPath) ) <> EXT_TXT );
/          MMMSGIO_SndMsg( 'CPF9897' : 'Extension not TXT' );
/          intReturn = ERROR;
/          ExSr ConvTXTPDF_QuitSr;
/        EndIf;
/
/        // Source Path must exist
/
/        If ( AccessIFS(%trimr(aIFSPath) : O_RDONLY ) <> OK );
/          MMMSGIO_SndMsg( 'ERR4108' : *blanks : 'PSCON' );
/          intReturn = ERROR;
/          ExSr ConvTXTPDF_QuitSr;
/        EndIf;
/
/        // Delete Original Needs to be Yes or No
/
/        If ( ( aDeleteOrg <> DELETEORG_YES ) and
/             ( aDeleteOrg <> DELETEORG_NO  )     );
/          MMMSGIO_SndMsg( 'CPF9897' :
/                          'ConvTXTPDF invalid paramter value not Y or N' );
/          intReturn = ERROR;
/          ExSr ConvTXTPDF_QuitSr;
/        EndIf;
/
/        //  Delete original is NO and the target exist
/
/        strBaseName = %Trim( GetPathBaseName( aIFSPath ) ) + EXT_PDF;
/
/        If ( AccessIFS( %trimr( strBaseName ) : O_RDONLY ) = OK );
/          If ( aDeleteOrg = DELETEORG_NO );
/            MMMSGIO_SndMsg( 'ERR4095' : strBaseName : 'PSCON' );
/            intReturn = ERROR;
/            ExSr ConvTXTPDF_QuitSr;
/          ElseIf ( aDeleteOrg = DELETEORG_YES );
             unlinkIFS(strBaseName);
/          EndIf;
/        EndIf;
/
/        // Open IFS file and begin conversion
/
/        ExSr ConvTXTPDF_InitPDF;
/
/        If ( AccessIFS(%trimr(strSrcIFSPath) : O_RDONLY ) = OK );
/          intFh = OpenIFS( %trimr(strSrcIFSPath) : O_RDONLY );
/
/          If ( intFh < 0 );
/            intReturn = ERROR;
/            ExSr ConvTXTPDF_QuitSr;
/          EndIf;
/
/           intChrRead =  ReadLine( intFh : %addr( strLine) : %size( strLine ));

/           DoW ( intChrRead >= 0 );
/             // strLine contains ASCII characters and EBCIDIC Spaces
              // Massage this data to translate EBCIDIC space to ASCII Space
/             // strLine = %xlate( x'40' : x'20' : strLine );
/             If ( intChrRead < ( %size( strLine ) - 1 ));
/               %subst( strLine : intChrRead + 1 : 1 ) = x'00';
/             EndIf;

/             XLateA2E( %addr(strLine) : intChrRead );
/             WrtLnPDF( PDFh : strLine );
/             intLineCount += 1;
/
/             If ( intLineCount >= PAGELINES );
/               intLineCount = 0;
/               NewPagPDF( PDFh );
/             EndIf;

/           intChrRead =  ReadLine( intFh : %addr( strLine) : %size( strLine ));
/           EndDo;
/
/           ClosePDF( PDFh );
/           Callp(e) close( intFh );
/           unlinkIFS(strSrcIFSPath);
/        EndIf;
/
/      @lpi   = intOrgLPI;
/      @pagle = intOrgPagle;
/      @cpi   = intOrgCPI;
/      @Pagwi = intOrgPagWi;
/
/      Return intReturn;
/      on-error *all;
/
/        @lpi   = aLPI;
/        @pagle = aPageLength;
/        @cpi   = aCPI;
/        @Pagwi = aPageWidth;
/        intReturn = ERROR;
/        Return intReturn;
/      EndMon;
/      //------------------------------------------------------
/      BegSR ConvTXTPDF_InitPDF;
/      //------------------------------------------------------
J2469    Callp(e)  SubMsgLog( blnDebug : 'ConvTXTPDF_InitPDF' : blnDebug ) ;
/        strSrcIFSPath = aIFSPath;
/        strTgtIFSPath = %Trim( GetPathBaseName( aIFSPath ) )
/                      + '.' + EXT_PDF;
/
/        ifPath = strTgtIFSPath;  // Used as a gobal var for opening
/                                 // the PDF IFS file
/
/        // Since the original PDFLib
/        // uses fopen to create files on the IFS
/        // without regard to the intended CCSID
/        // create and close targe file prior to
/        // callinig OpenPDF
/
/        Callp SPYIFS( 'OPEN'
/                    : strTgtIFSPath
/                    : *blanks
/                    : 0
/                    : FrmCCS
/                    : CCSID_819
/                    : IFSRtn);
/
/        Callp SPYIFS( 'QUIT'
/                    : strTgtIFSPath
/                    : *blanks
/                    : 0
/                    : FrmCCS
/                    : CCSID_819
/                    : IFSRtn);
/
/        If ( 0 = OpenPDF(PDFh));
/           MMMSGIO_SndMsg( 'ERR157C' : *blanks : 'PSCON' );
/           ExSr ConvTXTPDF_QuitSr;
/        EndIf;
/
/        If ( 0 = SetTxtPDF( PDFh ) );
/           MMMSGIO_SndMsg( 'ERR157C' : *blanks : 'PSCON' );
/           ExSr ConvTXTPDF_QuitSr;
/        EndIf;
/
/        Callp NewPagPDF( PDFh );
/      EndSr;
/      //------------------------------------------------------
/      BegSR ConvTXTPDF_QuitSr;
/      //------------------------------------------------------
J2469    Callp(e)  SubMsgLog( blnDebug : 'ConvTXTPDF_QuitSr' : blnDebug ) ;
/        Return intReturn;
/      EndSr;
/     /end-free
/    p ConvTXTPDF      e
J3613p RScan           b
J3613d RScan           pi            10u 0
/    d  aSearch                       1a   const
/    d  aString                     512a   const
/    d  intLen         s             10i 0
/    d  i              s             10i 0
/    d  intReturn      s             10u 0 inz( *zero )
/     /free
/      intLen = %len( %trimr( aString ) );
/      for i = intLen downto 1;
/        If ( %subst(aString : i : 1 ) = aSearch );
/          intReturn = i;
/          leave;
/        EndIf;
/      EndFor;
/      Return intReturn;
/     /end-free
J3613p RScan           e
J2469p SubMsgLog       b
J2469d SubMsgLog       pi
/    d  ablnLog                        n   const
/    d  aSub                         30a   const
/    d  ablnEntering                   n   const
/    d  intDepth       s             10i 0 inz static
/     /free
/       If ( ablnLog = FALSE );
/         Return;
/       ElseIf ( ablnEntering = TRUE );
/         MsgLog( 'Entering Sub ' + %trim(aSub) + LF );
/       Else;
/         MsgLog( 'Leaving  Sub ' + %trim(aSub) + LF );
/       EndIf;
/     /end-free
/    p SubMsgLog       e
J5331pGetUsrSpcSz      b
J5331dGetUsrSpcSz      pi            10i 0
J5331d aUsrSpcLib                    10a   const
J5331d aUsrSpc                       10a   const
J5331
J5331d qual_name_t     ds                  qualified
J5331d   UsrSpc                      10a
J5331d   UsrSpcLib                   10a
J5331
J5331d spca0100_t      ds                  qualified
J5331d    bytes_returned...
J5331d                               10i 0
J5331d    bytes_available...
J5331d                               10i 0
J5331d    spc_size                   10i 0
J5331d    auto_extend                 1a
J5331d    init_value                  1a
J5331d    lib_name                   10a
J5331 // Prototype of the Retrieve User Space   Attributes API
J5331d qusrusat        pr                  extpgm('QUSRUSAT')
J5331d     attr                            likeds(spca0100_t)
J5331d     rcv_len                   10i 0
J5331d     fmt_name                   8a
J5331d     spc_name                        likeds(qual_name_t)
J5331d     ec                         8a   options(*varsize)
J5331
J5331d spc_name        ds                  likeds(qual_name_t)
J5331d attr            ds                  likeds(spca0100_t)
J5331d rcv_len         s             10i 0 inz(%size(attr))
J5331d fmt_name        s              8a   inz('SPCA0100')
J5331d ec              s              8a   inz(*allx'00')
J5331 /free
J5331  spc_name.UsrSpc    = aUsrSpc;
J5331  spc_name.UsrSpcLib = aUsrSpcLib;
J5331  qusrusat(attr : rcv_len : fmt_name   : spc_name : ec);
J5331  return attr.spc_size;
J5331 /end-free
J5331pGetUsrSpcSz      e
J5331pUniqueFileName   b
J5331dUniqueFileName   pi            10i 0
J5331d ap_UniqueFileName...
J5331d                                 *
J5331d
J5331d                 ds
J5331d TimeStamp                       z
J5331d  QYear                         4     Overlay(TimeStamp)
J5331d  QMonth                        2  0  Overlay(TimeStamp : 6)
J5331d  QDay                          2     Overlay(TimeStamp : 9)
J5331d  QHour                         2     Overlay(TimeStamp : 12)
J5331d  QMinute                       2     Overlay(TimeStamp : 15)
J5331d  QSecond                       2     Overlay(TimeStamp : 18)
J5331d  QMili                         3     Overlay(TimeStamp : 21)
J5331d fileName        s             50     static
J5331
J5331 /free
J5331   Monitor;
J5331     TimeStamp = %TimeStamp;
J5331     fileName = QHour + QMinute + QSecond + QMili + x'00';
J5331     ap_UniqueFileName = %addr(filename);
J5331     return OK;
J5331   on-error *all;
J5331    return  ERROR;
J5331   endmon;
J5331 /end-free
J5331pUniqueFileName   e
J5464p WriteData       b
J5464d WriteData       pi            10i 0
J5464d  Buffer                         *   value
J5464d  BufferLn                     10u 0 value
J5464d  BufferFlag                   10i 0 value                                last buffer
J5464d  ErrorID                       8    value                                return error
J5464d  ErrorData                   101    value                                return data
J5464
J5464d  Bufr           s          32767    based(BufrP)
J5464d  Pos            s             10i 0
J5464d  Len            s             10i 0
J5464d  RC             s             10i 0
J5464d  intBufWrtLn    s             10i 0
J5464 /free
J5464
J5464   intBufWrtLn = IFSWrite( fd : Buffer : Bufferln );
J5464
J5464   If ( intBufWrtLn <> Bufferln );
J5464     ErrorID = 'IFS0010';
J5464     ErrorData = '';
J5464   EndIf;
J5464
J5464   Return intBufWrtLn;
J5464 /end-free
J5464p WriteData       e
J5953p IsSplMail       b
J5953d IsSplMail       pi             1a
J5953d NOT_SPLMAIL     c                   ' '
J5953d IS_SPLMAIL      c                   'S'
J5953d rtnSplMail      s              1a
J5953 /free
J5953   If ( mlspml <> IS_SPLMAIL );
J5953     rtnSplMail = NOT_SPLMAIL;
J5953   Else;
J5953     If ( quspdt00 = *blanks );
J5953        rc=getArcAtr(SpyNum:%addr(Qusa0200): %size(Qusa0200):3);
J5953     EndIf;
J5953
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
** BASE 36 DIGITS
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
** CL
CRTPRTF FILE(QTEMP/OUTPUT)                                                    1
*FRONTOVL                                                                     2
*FNTCHRSET                                                                    3
OVRPRTF FILE(#REPORT#) PAGERANGE(1 *END) MAXRCDS(*NOMAX) OVRSCOPE(*JOB)       4
OVRDBF FILE(#REPORT#) TOFILE(                                                 5
DLTOVR FILE(#REPORT#)                                                         6
DLTF FILE(QTEMP/OUTPUT)                                                       7
                                                                              8
                                                                              9
SNDFAX                                                                        10
DSPFD TYPE(*ATR) OUTPUT(*OUTFILE) FILEATR(*PRTF) OUTFILE(QTEMP/MAG2038) FILE( 11
OVRDBF FILE(MAG2038) TOFILE(QTEMP/MAG2038)                                    12
DLTOVR FILE(MAG2038)                                                          13
         $SUBJECT:                                                            14
         $TOPMGN:                                                             15
         $PHONE:                                                              16
         $CALTYP:                                                             17
         $CVR0                                                                18
         $INLOVL:                                                             19
         $VCOMP:                                                              20
         $LPP:                                                                21
         $HCOMP:                                                              22
         $STYLE:                                                              23
CHGSPLFA FILE(                                                                24
) JOB(                                                                        25
) SPLNBR(                                                                     26
DEV(                                                                          27
FORMTYPE('                                                                    28
') COPIES(                                                                    29
) OUTQ(                                                                       30
PAGERANGE(                                                                    31
) SAVE(                                                                       32
) USRDTA('                                                                    33
RLSSPLF SPLNBR(*LAST) FILE(                                                   34
SHARE(*YES)                                                                   35
SNDFSPL                                                                       36
SNDFSPLA                                                                      37
SNDAPIFAX                                                                     38
XFIMPIMG                                                                      39
DOCNAME(                                                                      40
FAXTYPE(                                                                      41
DLTAFTSND(                                                                    42
IMAGENAME(                                                                    43
IMGNAME(                                                                      44
SBMFAX                                                                        45
TYPE(*BCH) OPTION(*SPLEXIST) DSTSELMTH(*EXT)                                  46
) ADDQDLS(                                                                    47
OVRPRTF FILE(D@DOCMNT) SCHEDULE(*JOBEND)                                      48
ADDLIBLE LIB(DMLIB)                                                           49
PRTDMDOC DOCUMENT(                                                            50
) OUTQ(                                                                       51
CPYSPLF FILE(D@DOCMNT) TOFILE(QTEMP/DISP) SPLNBR(*LAST) CTLCHAR(*FCFC)        52
DLTSPLF FILE(D@DOCMNT) SPLNBR(*LAST)                                          53
DLTOVR FILE(D@DOCMNT)                                                         54
OVRDBF FILE(DISP) TOFILE(QTEMP/DISP)                                          55
CRTDUPOBJ OBJ(DISP) OBJTYPE(*FILE) TOLIB(QTEMP) FROMLIB(                      56
DLTF FILE(QTEMP/DISP)                                                         57
REPLACE(*YES)                                                                 58
**  FC Fax Commands
*FN                  1
*FD                  2
*FI                  3
*FC                  4
*RG                  5
*SD                  6
*RF                  7
*FM                  8
*CV                  9
*LI                 10
*PL                 11
*CI                 12
*LS                 13
*SC                 14
*PC                 15
*DT                 16
*TM                 17
*CA                 18
*PY                 19
*KEEP LIST ENTRY    20
- FaxSys Commands   21
&&& FAX             22
&&& FORM            23
&&& LPI             24
&&& CPI             25
&&& LANDSCAPE       26
&&& PORTRAIT        27
&&& PRIORITY        28
&&& ID              29
&&& CONFIRM         30
To Fax Number       31
&&& FROM            32
&&& TO              33
Re                  34
         $LFTMGN:   35
FRMMSKNUM           36
PAGORIENT           37
CHRPERICH           38
LINPERICH           39
FAXPRTCOD           40
FAXPHNNUM           41
CVRPAGFCN           42
CVRPAGCON           43
CVRPAGTX1           44
CVRPAGTX2           45
CVRPAGTX3           46
CVRPAGTX4           47
CVRPAGTX5           48
CVRPAGTX6           49
** SPF Special Replacement fields for cover page
$DATE      Current Date                           1
$TIME      Current Time                           2
$BUNDLE    Bundle ID                   CBUNDL     3
$REPTID    Report Type ID              CREPT      4
$SEGID     Segment ID                  CSEGMT     5
$SUBSID    Subscriber ID               CSUBSC     6
$COPY      Number of Copies            CCOPY      7
@BUNDLE    Bundle Description          CBNDDS     8
@REPTID    Report Type Description     CRPTDS     9
@SEGID     Segment Description         CSEGDS    10
@SUBSID    Subscriber Name             CSUBDS    11
$RRNAM     RMAINT Report Name          CRRNAM    12
$RJNAM     RMAINT Report Job Name      CRJNAM    13
$RPNAM     RMAINT Report Program Name  CRPNAM    14
$RUNAM     RMAINT Report User Name     CRUNAM    15
$RUDAT     RMAINT Report User Data     CRUDAT    16
** MSG   Message Entries ....................
HEX0001 5 /  The first character of this message must be a backslash.
HEX0002 6 ^  The first character of this message must be a ACCENT CIRC.

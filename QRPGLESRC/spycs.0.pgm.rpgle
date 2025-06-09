       ctl-opt DFTACTGRP(*NO) ACTGRP(*CALLER) EXPROPTS(*RESDECPOS)
       DATFMT(*ISO) TIMFMT(*ISO) OPTION(*NODEBUGIO: *NOUNREF);
       ctl-opt copyright('Open Text Corporation') dftactgrp(*no)
       actgrp('DOCMGR') bnddir('SPYCS':'SPYMAIL':'PDFLIBI');
   
     ********----------------------------
     * SPYCS  Client/Server Host Director
     ********----------------------------
     *
     * 04-10-15 PLR Create a dataara call COEX in QTEMP to identify the
     *              connection to SPYCSLRMNT so that it can decide whether or
     *              not to display empty document classes to CoEx for upload.
     * 02-20-15 EPG Dynamically change the setting for SpoolMail based
     *              on the SpoolType being processed.
     * 06-13-14 PLR DocView requests PDF page range when emailing. This is
     *              different that the page-by-page request when displaying
     *              the PDF. Check to see if requested span is the total
     *              page range of the document to maintain return speeds when
     *              the entire document is requested.
     * 10-25-12 PLR Set authority upload flag to 'Y' when standard security only.
     *              If using sup grps, be sure to turn on sup grp checking by
     *              setting sysdft position 277 to 'Y'.
     *              If deny upload is required, turn on extended security and
     *              and set the Copy flag to 'N'.
     * 09-27-12 EPG Extend the selection for security to include email, fax and
     *              save.
     * 07-09-12 PLR Suppress annotation flags from segment buffer when connected
     *              via DocView. DocView does not need the functionality like
     *              CoEx and breaks the buffer format for DocView.
     * 04-19-12 PLR Compensate for CoEx/VCO revision control state failures.
     * 01-11-12 PLR Missing ifs file close causing pdf page retrieval from CoEx.
     *              Error raised by PDFLib: 'too many file handles open'. Added
     *              close function.
     * 08-12-11 PLR Increase return speed of PDF document when entire report
     *              page range is requested. This will bypass the unnecessary
     *              distribution functions used to send back pieces of the
     *              of the document.
     * 09-20-11 EPG Convert from a bound program to a module
     * 08-11-11 PLR Pull licenses for respective clients (CoEx, DocView) and
     *              ContentAccess API when being called through ContentAccess.
     *              Run mode for CA/DocView = CAGAPI.
     *              Run mode for CA/CoEx = CAGCOEX.
     * 06-23-11 PLR Add extended note flags to the VCO conversation.
     *              Uses new conversation version to determine which structures
     *              to return to client.
     * 12-16-10 PLR Check first 8 characters of runmode for SPYEXEVU so that
     *              the correct license key is pulled for ImageLink+ and not
     *              from DocView. SPYEXEVU2 is sent as the runmode for this
     *              conversation.
     * 09-30-10 PLR Correct the not-fully-functional report/std indices feature.
     *              Add capabilities flag (see SPYCSLSTN) to allow for a change
     *              to the index return buffer.
     * 09-14-10 PLR Add Content Access product to licensing. Product# = 21;
     *              Runmode = 'CAGAPI'
     * 06-10-10 EPG Fix the performance issues encountered after upgrade.
     * 06-11-10 PLR Add DLTNU opcode for delete note for update.
     * 05-24-10 PLR Annotation security.
     * 03-09-10 EPG Retrofit email logging changes.
     * 10-30-09 PLR SPYWEBAPI access was using DocView licenses because the
     *              client ip address was not being passed. This works ok
     *              from the local spywebapi. Added another check for the
     *              web app name to assist in drawing from the correct
     *              license pool.
     * 10-22-09 EPG CoEx DocLink search failed when a lower case value was
     *              passed to it.
     * 10-21-09 PLR Server was receiving 'receiver value too small to hold result'
     *              error when exporting large number of hits to the pc export
     *              client. The receiver value (rhDtaSiz) is a dec(5,0) field
     *              and in the case of the customer the hitlist return buffer
     *              size was 156k. Solution was to set the field to its max when
     *              exceeded (99,999) and continue. This did not seem to invalidate
     *              the export data and processed without error.
     * 09-21-09 PLR PC Export/Import client is only getting 101 reports when
     *              requesting by docClass. Caused by a couple of issues. First
     *              they ask for 100 report record blocks in the form of a
     *              COBJECTS request. The server returns 101 but returns a W04
     *              end-of-file response. The next problem is that
     *              the positioning key sent from the client to get the next
     *              block is not correct but can be manipulated to function.
     *              This request does not appear to be used by anything other than
     *              this conversation as far as I can tell and does not
     *              impact CoEx for report list requests.
     * 09-24-09 EPG Recompile Only.
     * 09-24-09 EPG Getting decimal data error in subroutine CALPCL when processing
     *              PCL segments having mixed data in XBFR. Data is suppose to be
     *              used to identify the to page of the PCL document. But the
     *              buffer usage has changed somewhat to accomodate the segment
     *              processing from DocView. Check for numeric data in the buffer
     *              prior to move.
     * 08-11-09 PLR Track SpyWeb independently of CoEx. Added new product id
     *              for SpyWeb...product number 17.
     * 08-10-09 PLR Correct licensing for CoEx connections. Use to pull from
     *              the DocView license. VCO now sends a runmode of COEX.
     * 07-21-09 PLR Prevent message from being trimmed off when file not found
     *              on volume. Was missing the volume name and device.
     * 02-12-09 PLR Host email from hit list delivers incorrect image. Clients
     *              were not sending the RRN along with the batchid. Changed
     *              emailImage() procedure to accommodate. Added the page
     *              range capability.
     * 04-28-08 PLR Added a call to quit SPYPGRTV in the situation where a
     *              previous error was reported from a previous call to SPYPGRTV.
     *              Was causing decimal data error in SPYPGRTV on subsequent
     *              calls. This was reported when an offline report was trying
     *              to be emailed. User should get continuous error messages
     *              of "Unable to open file on volume" without crashing server.
     * 02-05-08 PLR PC based export app fails when invalid sequence number
     *              is passed to MMDMSSRVR service program GetHedBy_ConID
     *              procedure. Related to fetching notes.
     * 05-10-07 PLR Make sure getAllAuth structure is synced with clients.
     * 03-28-07 PLR Add ability to host email images via DocView client.
     * 01-31-07 PLR Add key code checking for client based import/export utility.
     * 01-25-07 PLR Implement the return of pcl segment page numbers to DocView.
     * 12-19-06 PLR Allow the request for print authority from DocView.
     * 11-01-06 PLR DocView was changed to support embedded PDF viewing.
     *              With that change, it was discovered that the logic to
     *              handle the retrieval and sending of the PDF data stream
     *              was incorrect. This also impacts CoEx and some changes
     *              are made to reflect that fact.
     * 10-03-06 PLR Add native pdf viewing of segments. Reworked a large
     *              portion of the original work done under 4979 in order
     *              to accommodate the handling of segments as well to make
     *              the processing a little more efficient.
     * 08-14-06 PLR Image requests were failing via workflow on german
     *              systems. This was a translation error for the literal 'at-sign'
     *              character. Added additional checking for the hex value.
     * 01-31-06 EPG Retrofit Native PDF file support.
     * 11-23-05 PLR Add license call for DOCMGRAPI runmode.
     * 11-17-05 PLR CoEx critical annotation buttons unavailable because
     *              the code and structure for GTAUT response were incomplete.
     * 09-30-05 PLR Discovered solution to #9154. Was able to extend the
     *              malloc() function into teraspace within the LIBTIFF
     *              service program by adding compile time options to
     *              modules AS400IO & IOMGR.
     * 04-15-05 PLR Sticky note text disappearing when applied via CoEx & RevCtl.
     *              Was not receiving batch number from VCO. Compromised
     *              by resolving batch from RevID.
     * 03-11-05 PLR Add security for revision control.
     * 03-09-05 PLR Overload GTAUT operation to return report authority flags.
     * 12-29-04 PLR Requirements for folder/folderLib when host printing.
     * 11-23-04 PLR When using the NT file export application, server was
     *              returning an 'All file handles in use' error because
     *              the GetDocAttr() procedure does not clean up it's file
     *              handles. Added a call to close the file handle.
     * 07-19-04 PLR Check max size if tiff image. 16M malloc/usrspc size limit
     *              in LIBTIFF service program. Not able to change to use
     *              teraspace due to possible pointer implications and time
     *              constraints.
     * 07-09-04 PLR Unable to update Overlay margin when changing settings
     *              in VIP ImageLink Plus.
     * 04-29-04 GT  Change AUTHOR routine to use aut flag sent by client
     *                (was hard coded to opt 10)
     * 04-13-04 GT  Clear RRSDT buffer in COMMND.  Was causing SpyWeb
     *              API to generate bogus SpyLink hits on a bad query
     *              because of previous response data in RRSDT.
     * 02-18-04 PLR Audit logging.
     * 10-14-03 JMO Add support for 6 digit spool file numbers.
     *              Also, standardize spool file nbr parms - always 4 byte binary.
     * 08-01-03 PLR Add compatiblity for VCO changes/additions.
     * 07-08-03 PLR Needed to modify the return value in DMUSR (DMS)
     *              conversation to force the return of the 'W04 END OF
     *              FILE REACHED' message instead of just a 'K' and an
     *              empty buffer. Modified for consistency to match
     *              what occurs between VCO and NT product.
     * 04-04-03 JMO Added Host Email functionality
     * 01-13-03 PLR On LSTNT opcode and large enough request of notes to
     *              more than fill buffer, the application will hang.
     *              This was caused by on the continuation opcode and the
     *              opcode not being checked again. The continuation was
     *              treated as if it was report data.
     * 05-08-02 GT  Fix INIT/QUIT logic in procedures LnkHitList and
     *               OmniHitList
     * 05-02-02 GT  Handle SPYCSLCRI returning warning for bad doc class
     * 04-12-02 PLR Error msg when retrieving VCO revision data.
     * 03-22-02 RA  Correct blank page in Spyweb - PDF
     * 01-25-02 KAC Revise distribution Spylinks support
     * 01-16-02 KAC Add Ascending/Descending Order flag to DocView
     * 01-11-02 KAC VCO Revision list function.
     * 11-15-01 KAC Add receive callback for single socket processing.
     * 10-29-01 KAC Revise for VCO phase II functions.
     * 10-15-01 KAC Revise CS Segment notes.
     * 10-01-01 PLR Make sure licensing for Image Viewer Plus is made seperately
     *              from Spy/CS. Was previously taking a license hit from both.
     * 08-15-01 KAC Add VCO phase II functions.
     * 07-11-01 PLR Move logic of 4835 to SPYCSNOT. Was causing buffer
     *              syncronization problems.
     * 06-19-01 PLR Prevent annotation functions to previous revisions.
     * 06-11-01 KAC Add Omnilink Revid parm for OL Rev list processing.
     * 06-11-01 DLS Adjust to send proper WIP/ or REVid to SPYCSNOT
     * 05-22-01 PLR Incorrect report type logged to RDSTLOG via SPYWEB.
     * 05-17-01 KAC Adjust callback buffer size based on version.
     * 03-14-01 RA  Correct MAG1060 parameter call.
     * 03-04-01 KAC Add document revision support.
     * 03-01-01 PLR Authorization warning message had wrong message code. Caused halt.
     * 01-25-00 GT  Remove SPYCS data queue entry on termination.
     * 01-25-00 PLR Was not checking key code on startup.
     * 01-03-01 KAC Add VCO support report type rather Big5 key.
     * 12-12-00 KAC Fix Notes deletion authority code/message
     * 11-21-00 KAC Add a new SpyLinks opcode RDREV (read reverse)
     * 11-16-00 KAC Fix Notes return code
     * 10-13-00 KAC Call new PCL sub-pgm (uses callback function)
     * 10-12-00 KAC Add support CS Distribution Spylinks
     * 09-13-00 PLR PRODUCT AUTHORIZATION ENHANCEMENT.
     *  8-16-00 KAC Switch to NT's "Big Key Patch" conversation.
     *  7-26-00 KAC USE REVISED NOTES INTERFACE
     * 07-08-00 KAC Add SCS to PDF conversion
     * 06-08-00 KAC Correct original 2292HQ enh. @OPCOD not
     *              being set correctly.
     * 05-31-00 GT  Correct original 2149HQ fix. LNKPG flag not
     *              always being reset correctly.
     * 05-16-00 GT  Fix RTNFRM field length (was 8, s/b 10)
     * 04-07-00 FID OVERLAY SUPPORT FOR SPYPGRTV
     * 12-14-99 KAC PASS "INIT" TO SPYCSLNK
     * 12-08-99 JJF Call Mag901 for activity logging
     * 12-03-99 DM  Change spypgrtv rrn to 9 bytes numeric
     * 11-23-99 KAC RETURN ATTRIBUTE DATA ON READC.                  1990HQ
     * 11-08-99 GT  Changed FMTIVAL index value parm length to 99    2189HQ
     * 11-01-99 KAC ADDED WEB PARMS TO SPYCSFLD                      2153HQ
     * 10-27-99 KAC ALWAYS CALL SPYWBFLT FOR SELCR opcode            2153HQ
     * 10-21-99 GT  Only call SPYWBFLT for SELCR opcode              2213HQ
     * 10-11-99 KAC BUG READING PAGES > 240 LINES VIA SPYLINKS.      2149HQ
     *  9-08-99 GT  Add new PCL opcodes to continuation check in CALPCL
     *  8-04-99 FID ADDED NEW FIELD TO KEY STRUC WHEN REQUESTING REPORTS OVERLA
     *  6-21-99 GT  Add run mode parm to *ENTRY plist
     *  6-18-98 KAC ENABLE NEW SINGLE MEMBER REPORT INDEX FILES
     *  6-04-99 GT  Correct page range mapping for SPYAFRTV
     *  5-17-99 DM  Remove the changing library list stuff
     *  4-03-99 GT  Call SPYCHGRP to change run priority
     *  3-31-98 KAC RESTORE OLD NOTES INTERFACE
     *  3-22-99 JJF Call Mag901w to log Web user on and off
     *  3-18-99 KAC ADD CALL TO SPYPLRTV
     *  3-30-99 FID ADD Query opcodes for spylinks/omnilinks
     *  2-24-99 KAC ADD ANNOTATION TEMPLATE INTERFACE
     *  2-06-99 FID Added SPYCSRPTN, SPYCSBCHN, SPYCSTYP
     *  1-22-99 JJF Add continue read for long distribution pages
     * 12-22-98 KAC USE REVISED NOTES INTERFACE
     * 12-09-98 KAC CHANGE SPYCSLNK PARM LIST INCLUDE MSG ID & DATA
     * 12-01-98 FID Add continue read for long reports
     * 11-24-98 KAC ADD NOTES FLAG FOR AFP REPORTS.
     * 11-18-98 GT  Get multiple SpyLink and OmniLink criteria specs
     *              on one request. Wake up OmniServer (subr WAKOMN).
     * 11-17-98 GT  Call MAG8090 to get date format for SYSENV function.
     *  9-11-98 GT  Disable key code checking if web access
     *  3-10-98 KAC APPEND RETURN CODE FOR SPYPGRTV ERRORS
     *  3-06-98 GT  View entire report if segment *ALL is requested.
     *  2-27-98 KAC ADD SUPPORT FOR IMAGEVIEW TYPE REPORTS
     *  2-26-98 GT  Change ENDJOB cmd to call to SPYENDJB
     *  2-05-98 KAC ADD SUPPORT FOR R/DARS TYPE REPORTS
     *  1-26-98 GT  Changed SPY number location to KEY,66 in PRTRPT
     *  8-26-97 GT  Added page range to AFP retrieval
     *  7-25-97 GT  Added AFP retrieval routines and changed RTVPAG
     *              to use the opcode passed from the client.
     *  5-09-97 GK  Added SpyCsOLnk.
     *  4-08-97 GK  Pass MsgID and MsgDta from called pgm to caller
     *  2-25-97 GK  Take out ICF file and replace with Buffer parm.
     * 11-25-96 JJF Add opcode-file READ-SYSDFT to give client SYSDFT
     * 10-07-96 JJF Add dist page table name (DSTTBL) parm for Mag801
     *  8-15-96 GK  Add Note Annotations & new SpyCs test method
     *  4-15-96 JJF Clear liblist & add QSYS2. Add trace function
     *  2-15-96 DM  New program
     *
     *  Bytes   Field
     *  -----   ------
     *   1- 10  File   File to retrieve records
     *  11- 20  Libr   Libr where file is found
     *  21-120  Key    Key from which to start reading records
     * 121-125  OpCode Read,Readp,Page,Print,Info,Selcr
     * 126-134  Page   Read Records starting at PG
     *
     * API's for FOLDERS
     * -----------------
     * Get a page of a report (data)
     * -----------------------------
     *  Bytes   Field
     *  -----   ------
     *   1- 10  File   Folder to retrieve records
     *  11- 20  Libr   Libr where folder is found
     *  21-120  Key    MRPTDIR key of Report
     * 121-125  OpCode Page
     * 126-134  Page   Read Records starting at PG number
     * 135-1034 Xbfr   empty
     *
     *
     * API's for MRPTDIR and MFLDDIR
     * -----------------------------
     *
     * Get a list of Folder or a list of Reports within a folder
     * ---------------------------------------------------------
     *  Bytes   Field
     *  -----   ------
     *   1- 10  File   File to retrieve records MRPTDIR/MFLDDIR
     *  11- 20  Libr   Libr where file is found (SPYDATA)
     *  21-120  Key    Key from which to start reading records
     * 121-125  OpCode Read,Readp
     * 126-134  Page   empty
     * 135-1034 Xbfr   empty
     *
     *
     * API's for SPYLINKS
     * ------------------
     *
     * Get a list of Report Types that have SpyLinks
     * ---------------------------------------------
     *  Bytes   Field
     *  -----   -----
     *   1- 10  File   File to retrieve records RLNKDEF
     *  11- 20  Libr   Libr where file is found (SPYDATA)
     *  21-120  Key    Key from which to start reading records
     * 121-125  OpCode Read,Readp
     * 126-134  Page   empty
     * 135-1034 Xbfr   empty
     *
     *
     * Retrieve Data Field definitions that make up a SpyLink
     * ------------------------------------------------------
     *  Bytes   Field
     *  -----   -----
     *   1- 10  File   File to retrieve records RLNKDEF
     *  11- 20  Libr   Libr where file is found (SPYDATA)
     *  21-120  Key    RMAINT key that has SpyLink
     * 121-125  OpCode Info
     * 126-134  Page   empty
     * 135-1034 Xbfr   empty
     *
     *
     * Retrieve SpyLink data recs associated to given filter request
     * -------------------------------------------------------------
     *  Bytes   Field
     *  -----   -----
     *   1- 10  File   File to retrieve records @000000* file
     *  11- 20  Libr   Libr where file is found (SPYDATA)
     *  21-120  Key    RMAINT key that has SpyLink
     * 121-125  OpCode Selcr / Rdgt / Clear
     * 126-134  Page   empty
     * 135-1034 Xbfr   Extra Buffer as described
     *                        - filter index values 1-7
     *                        - filter index value 8  from date
     *                        - filter index value 9  to date
     *                        - Spy Version ID     >>>>> __________
     *                        - SpyLink sequence number    |
     *                        - Starting Page of SpyLink   |
     *                        - Ending Page of SpyLink     | empty
     *                        - Read flag                  |
     *                        - Delete flag                |
     *                        - Print flag               __+_______
     *
     *
     * Retrieve SpyLink Report pages (viewer data)
     * -------------------------------------------------------------
     *  Bytes   Field
     *  -----   -----
     *   1- 10  File   File to retrieve records @000000* file
     *  11- 20  Libr   Libr where file is found (SPYDATA)
     *  21-120  Key    RMAINT key that has SpyLink
     *                        - "SPYLINK"
     *                        - Spy Version ID
     *                        - start page
     *                        - end page
     * 121-125  OpCode READ
     * 126-134  Page   empty
     * 135-1034 Xbfr   empty
     *
     * API's for PRINTING
     * ------------------
     *
     * Prints Reports (pages) from folders
     * ------------------------------------------------------
     *  Bytes   Field
     *  -----   -----
     *   1- 10  File   Folder of the report
     *  11- 20  Libr   Libr where folder is found (SPYDATA)
     *  21-120  Key    MRPTDIR of the report in the folder
     * 121-125  OpCode Print
     * 126-134  Page   empty
     * 135-1034 Xbfr   Extra Buffer is as follows:
     *                        - From Page #
     *                        - To Page #
     *                        - SpyPrinter Name
     *                        - Output Queue
     *                        - Output Queue Library
     *                        - Printer File
     *                        - Printer File Library
     *                        - Submit as Background job
     * API's for EMAIL
     * ------------------
     *
     * Emails Reports from folders or Spylinks
     * ------------------------------------------------------
     *  Bytes   Field
     *  -----   -----
     *   1- 10  File   Folder of the report
     *  11- 20  Libr   Libr where folder is found (SPYDATA)
     *  21-120  Key    MRPTDIR of the report in the folder
     * 121-125  OpCode EMAIL
     * 126-134  Page   empty
     * 135-1034 Xbfr   Extra Buffer is as follows:
     *---------------------------------------------
     * 135-144                - From Page #
     * 145-154                - To Page #
     * 155-159                - Structure version#
     * 160-160                - Submit job? (Y/N)
     * 161-170                - Email format (*TXT)
     * 171-290                - From email address
     * 291-350                - Subject text
     * 351-675                - Email text (5x65)
     * 676-795                - Destination email address
     *
     *
     *----------------------------------------------------------------
     *To set debug interactive debug:
     * AS400 src    1) Change the constant SETDBG field to a "Y".
     * AS400 cmd    2) Recompile the program.
     * PC windows   3) Start SpyCS from Windows.
     * AS400 cmd    4) On an As400 session start interactive debug SI
     *                 on the program NOOP in QGPL with *SELECT
     *                 and pick the SPYCS ICF job thats in a message
     *                 wait state.
     * AS400 cmd    5) Run the program UNFRZJOB.
     * AS400 SI     6) When the Interactive debug screen is displayed
     * Dbg pop_up #5   on the As400 session add the program SPYCS to
     *    #5           the list of programs being debuged.
     * AS400 SI     7) Change over to the SPYCS program source after
     * Dbg pop_up #5   you have added it and set break points.
     * AS400 SI     8) Then hit Function 17 to run to the next break
     *                 point.
     *
     * PRODUCT AUTHORIZATION PROTOTYPE.
       dcl-f MRPTDIR7 keyed usropn;
4979  /copy @pdfbufhdl
      /COPY @MFSPYAUTR
      /copy @MGMEMMGRR                                                          Memory Manager
      /copy @MMDMSSRVR                                                          DMS functions
      /copy @MMDOCFNCR                                                          Doc/Img functio
/5921 /COPY @MMRPTDSTR
T4979 /copy @pdfio
J1554 /include @memlio
   
     * Prototypes -------------------------------------------------
   
   
     * PDF Buffer Process FALSE=Not a PDF Process, TRUE=PDF Process
   
   
     * Constants --------------------------------------------------
   
     * function return codes
       dcl-c OK 1;
       dcl-c FAIL 0;
       dcl-c KEY_RTYPID '*RTYPID';
       dcl-c YES 'Y';
       dcl-c NO 'N';
     * Variables --------------------------------------------------
       dcl-s rc int(10);
   
     * parameter for MAG801
       dcl-s @filn#b bindec(9);
   
       dcl-s RevID int(10);
       dcl-s HeadRevID int(10);
       dcl-s WipRevID int(10);
   
       dcl-s DistPage int(10);
   
     * spylinks report page request ("x" buffer portion)
       dcl-ds LnkPgRqstDS;
         LnkVal char(70) dim(7); // used for highli
         LnkRepLoc char(1) pos(618); // report location
         LnkRStrPgA char(9) pos(634);
         LnkRStrPg zoned(9) overlay(lnkrstrpga); // link start page
         LnkREndPgA char(9) pos(643);
         LnkREndPg zoned(9) overlay(lnkrendpga); // link end page
       end-ds;
   
       dcl-s MSGE char(7) dim(9) ctdata perrcd(1); // Error Msgs
       dcl-s DTS char(256) dim(240); // 240 Rec Splfil
       dcl-s WTS char(256) dim(240); // Work DTS
       dcl-s @I char(1) dim(8); // Access Wrk Ary
       dcl-s AUT char(1) dim(25); // Auth returns
   
     * Query selection parms
       dcl-s AO char(3) dim(25); // AND/OR
       dcl-s FN char(10) dim(25); // Field Name
       dcl-s TE char(5) dim(25); // Test
       dcl-s QV char(30) dim(25); // Value
       dcl-s QVF char(30) dim(25); // Value FMT
   
       dcl-ds XBFR len(1000);
         xbf_fpg char(9);
         xbf_tpg char(9);
         xbf_vers char(5);
         xbf_sbmjb char(1);
         xbf_fmt char(10);
         xbf_frmeml char(120);
         xbf_subj char(60);
         xbf_msgtxt char(325);
         xbf_dsteml char(120);
       end-ds;
   
       dcl-s BF char(1) dim(%size(xbfr)); // Xfer Buffer
   
       dcl-ds SDTds len(8100);
         SDT char(1) dim(%size(sdtds));
       end-ds;
   
     * Criteria selection (up to 9)
       dcl-s LinkLst char(55) dim(9);
       dcl-s OmniLst char(10) dim(9);
   
       dcl-s TableFile char(1);
   
       dcl-ds JOB#;
         @JOBNA char(10) pos(1);
         @USRNA char(10) pos(11);
         @JOBNU char(6) pos(21);
       end-ds;
   
       dcl-s APILEN int(10);
       dcl-s @MSGWT int(10);
   
       dcl-c LF x'25';
       dcl-c TRUE '1';
       dcl-c FALSE '0';
       dcl-c PSCON const('PSCON     *LIBL     ');
   
       dcl-ds ERRCD;
         @ERLEN int(10) inz(%size(errcd)) pos(1);
         @ERCON char(7) pos(9);
         @ERDTA char(100) pos(17);
       end-ds;
   
     *             PROGRAM STATUS
       dcl-ds *n PSDS;
         PGMERR *STATUS;
         WQPGMN char(10) pos(1);
         PGMLIN char(8) pos(21);
         @PARMS zoned(3) pos(37);
         SYSERR char(7) pos(40);
         WQLIBN char(10) pos(81);
     * Job Name
         WQJOBN char(10) pos(244);
     * User Name
         PGMUSR char(10) pos(254);
         jobNum char(6) pos(264);
       end-ds;
     * Job Number
       dcl-ds SYSDFT len(1024) dtaara;
         EXTSEC char(1) pos(137);
         SDATFM char(3) pos(224);
         SDLOGT char(1) pos(414);
         LDEBUG char(1) pos(454);
         SCSPTY char(2) pos(524);
         LOGWEB char(1) pos(791);
         SplMail char(1) pos(868);
         SplMailLib char(10) pos(869);
         LOGEML char(1) pos(961);
       end-ds;
       dcl-ds *n;
         OUTQ# char(20) pos(1);
         OUTQ1 char(1) pos(1);
         OUTQ char(10) pos(1);
         OUTQL char(10) pos(11);
       end-ds;
       dcl-ds *n;
         @YMD zoned(8) pos(1);
         @SYSD8 zoned(8) pos(15);
         @CKACC char(16) pos(23);
         @O zoned(2) dim(8) pos(23);
         @X zoned(1) pos(39);
         @Z zoned(3) pos(40);
         @SDATE zoned(8) pos(43);
         @SDATC char(8) pos(43);
         @ACESS char(16) pos(51);
         @TFACT zoned(8) pos(67);
         @TMP2 zoned(2) pos(75);
       end-ds;
       dcl-ds *n inz;
         QSNDR char(44) pos(1);
         QBTRTN packed(7) pos(1);
         QBTAVL packed(7) pos(5);
         QJNAM char(10) pos(9);
         QUSER char(10) pos(19);
         QJ# char(6) pos(29);
         QCUSRP char(10) pos(35);
       end-ds;
   
     * request "key" data
       dcl-ds SKEY;
         SKEY1 char(10);
         SKEY2 char(10);
         SKEY3 char(10);
         SKEY4 char(65);
         sMajMinVer char(5);
         KEY char(1) dim(100) pos(1);
       end-ds;
   
     *--------------------------------------------
     * Query Filter (stays in memory until reset)
       dcl-s QRYAO char(60) inz;
       dcl-s QRYFN char(200) inz;
       dcl-s QRYTE char(100) inz;
       dcl-s QRYVL char(600) inz;
     *--------------------------------------------
   
       dcl-c #SPYMF const('Q         QGPL      ');
       dcl-c #SPYM9 const('Q9        QGPL      ');
       dcl-c DBGPGM const('QGPL/NOOP');
       dcl-c @ATM const('*ATEMPLATE');
       dcl-c @PCL const('*PCL5');
       dcl-c @PDF '*PDF';
   
       dcl-ds LDA dtaara(*auto: *lda);
         mlind char(40) pos(1);
         mlfrm char(120) pos(41);
         mlfrm6 char(60) pos(41);
         mlsubj char(60) pos(161);
         mltxta char(325) pos(221);
         mltxt1 char(65) pos(221);
         mltxt2 char(65) pos(286);
         mltxt3 char(65) pos(351);
         mltxt4 char(65) pos(416);
         mltxt5 char(65) pos(481);
         mltype char(1) pos(546);
         mlto60 char(60) pos(547);
         mlto char(120) pos(547);
         iflist char(10) pos(547);
         ifrepl char(1) pos(557);
         mldist char(1) pos(667);
         mlfmt char(10) pos(668);
         mlcdpg char(5) pos(678);
         mligba char(1) pos(683);
         mlspml char(1) pos(684); // SpoolMail
       end-ds;
   
   
     * SpyWeb parms
       dcl-ds SPYWEB dtaara(*auto);
         swWEBAPP char(10); // Web App
         swWEBUSR char(20); // Web User
       end-ds;
   
     *             Work Fields.
       dcl-s FILE char(10);
       dcl-s LIBR char(10);
       dcl-s OPCODE char(5);
       dcl-s RRN#PG char(9);
       dcl-s WRECS char(9);
       dcl-s ERRTYP char(1);
       dcl-s ERRDES char(80);
       dcl-s PRD# packed(3);
   
     * Regular request (little buffer)
       dcl-ds REGREQ;
         RQFILE char(10);
         RQLIBR char(10);
         RQSKEY char(100);
         RQOPCD char(5);
         RQR#PG char(9);
         RQXBFR char(1000);
       end-ds;
   
     * Notes request (big buffer)
       dcl-ds NOTREQ len(8192);
         NQFILE char(10);
         NQLIBR char(10);
         NQRECS char(9);
         NQOPCD char(5);
         NQR#PG char(9);
         NQTIF# char(4);
         NQSDT char(8100);
       end-ds;
   
     * Note List Structure
       dcl-ds NLDS len(128);
         NLPAGN zoned(10) pos(1);
         NLNOTN zoned(10) inz pos(11);
         NLUSER char(20) pos(21);
         NLDATE zoned(8) pos(41);
         NLTIME zoned(6) pos(49);
         NLTYPE char(1) pos(55);
         NLACOO char(50) pos(56);
         NXASTP char(2) pos(56);
         NXALEN char(9) pos(96);
         NXATYP char(5) pos(105);
       end-ds;
   
       dcl-s ndStartPos int(10); // data start pos
       dcl-s ndDataLen int(10); // data length
   
     *             Regular Response returned in BUF
       dcl-ds REGRSP;
         RRERTY char(1) pos(1);
     * AFP return values
         RRERDS char(80) pos(2);
         ARERDS char(56) pos(2);
         AFPNOT char(1) pos(58);
         ACOUNT zoned(9) pos(59);
         ATOTSZ zoned(9) pos(68);
         ABUFLN zoned(5) pos(77);
         RRSDT char(8100);
         rMajMinVer char(5);
         *n char(5);
         RREOB char(1) pos(8192);
       end-ds;
   
     *             Note Response returned in BUF
       dcl-ds NOTRSP;
         NRERTY char(1) pos(1);
         NRERDS char(80) pos(2);
       end-ds;
   
     * Report attributes returned from SPYPGRTV
       dcl-ds RPTATR len(80);
         RPTWID char(9) pos(1);
         PAGLNS char(9) pos(10);
         FRMTYP char(10) pos(19);
         RPTLPI char(9) pos(29);
         RPTCPI char(9) pos(38);
         RPTRTT char(1) pos(47);
         OVLYN char(1) pos(48);
       end-ds;
   
     * Report attributes passed back in ERRDES (ALWAYS ADD TO START OF STRUCUT RE)
       dcl-ds RTNATR;
         RTNOVL char(1) pos(1);
         RTNRTT char(1) pos(2);
         RTNCPI char(9) pos(3);
         RTNLPI char(7) pos(12);
         RTNFRM char(10) pos(21);
         RTNWID char(7) pos(31);
         RTNPGL char(9) pos(40);
       end-ds;
   
     * Map PCL segment pages to physical pages and send back to client.
   
     * Get PSCON message
     * Set return status code and message
   
     * FileName structure passed on open function
       dcl-ds TFileData; // Open Filename D
         SplFilNam char(10); // Spooled File Na
         SplJobNam char(10); // Spooled File Jo
         SplUsrNam char(10); // Spooled File Us
         SplJobNum char(6); // Spooled File Jo
         SplFilNum int(10); // Spooled File Fi
         SplFld char(10); // Folder to archi
         SplFldLib char(10); // Folder library
         SplSpyNum char(10); // SPY000.. Number
         SplOpt char(1); // Optical '1'=YES
     *   :                                                                     'A'=Attribute r
     *   :                                                                     '1'=QSPL Member
     *   :                                                                     '2'=A0000... Fi
     *   :                                                                     '3'=AP000... Fi
     *   :                                                                     '4'=DISP... Fil
     *   :                                                                     '5'=Resource
     *   :                                                                     '6'=Font List
     *   :                                                                     '7'=Macro List
     *   :                                                                     '8'=State data
         SplType char(1); // File to Open
         SplTrnTbl char(10); // Translation Tab
         SplTrnLib char(10); // Translation Tab
         SplOptDrv char(15); // Optical Drive
         SplOptVol char(12); // Optical Volume
         SplOptRnm char(10); // Optical Report
       end-ds;
   
       dcl-s pPagFrm packed(9); // Page From
       dcl-s pPagTo packed(9); // Page To
       dcl-s uPagFrm uns(10); // Page From
       dcl-s uPagTo uns(10); // Page To
       dcl-s LastPos int(10); // buffer last pos
       dcl-s docrrn int(10);
   
     * Comm layer callback for receiving data
       dcl-s CLrecv pointer(*proc);
       dcl-pr CLRecvData int(10) extproc(clrecv);
         *n pointer value; // Buffer
         *n uns(10) value; // BufferLn
       end-pr;
     * Comm layer callback for sending data
       dcl-s CLsend pointer(*proc);
       dcl-pr CLSendData int(10) extproc(clsend);
         *n pointer value; // Buffer
         *n uns(10) value; // BufferLn
       end-pr;
   
     * Application layer callback for sending data
       dcl-s ALsend pointer(*proc) inz(%paddr('ALSENDDATA')); // callback functi
     * Send Return Buffer Data
     * Send Response data
     * Document revision operations
     * SpyLinks Hit list
     * OmniLinks Hit list
     * OmniLinks Report types
     * Overlay template operations
     * get page info for a image/document
     * convert content id (batch/seq) to rev id
   
     * Get User Email address
   
       dcl-ds fyldta;
         flspy char(3) pos(1);
         flver char(5) pos(1);
         flidx# char(3) pos(6);
         flsize char(9) pos(9);
         flfile char(25) pos(18);
         flext char(5) pos(43);
         fldat char(8) pos(48);
         fltim char(6) pos(56);
         fludat char(8) pos(62);
         flutim char(6) pos(70);
         flusr char(10) pos(76);
         flnode char(17) pos(86);
         flseq zoned(9) pos(103);
         flrrn zoned(9) pos(112);
       end-ds;
   
     *             Report security auths
       dcl-ds rptsds;
         sread char(1);
         schg char(1);
         scopy char(1);
         sdel char(1);
         sattr char(1);
         ssec char(1);
         slink char(1);
         sbak char(1);
         srst char(1);
         scfg char(1);
         sseg char(1);
         sprnt char(1);
         smove char(1);
         semail char(1);
         sfax char(1);
         ssave char(1);
       end-ds;
   
       dcl-ds getAllAuth;
         ga_view char(1);
         ga_print char(1);
         ga_delete char(1);
         ga_stampPlace char(1);
         ga_reserve2 char(1);
         ga_display char(1);
         ga_upload char(1);
         ga_editLink char(1);
         ga_checkOut char(1);
         ga_manSbmCase char(1);
         ga_critAnno char(1);
         ga_dltLinkVal char(1);
         ga_email char(1);
         ga_fax char(1);
         ga_save char(1);
       end-ds;
   
       dcl-s blnSendPDFOnly ind inz(false);
   
       dcl-c MPH_GET 1; // PDF get handle
       dcl-c MPH_QUIT 2; // PDF cleanup and quit
   
       dcl-s test9a char(9);
   
     * ---------------------------------------------------------------------- *
   
   
     //--*STAND ALONE-------------------------------------------
     D #               s              9p 0
     D #LIBR           s             10a
     D #OBJ            s             10a
     D #rl             s              3p 0
     D #RRNPG          s              9p 0                                       request?
     D #RTV            s              9p 0                                      Rtn # recs
     D #1              s              9p 0
     D @BCHID          s             10a                                        batch ID
     D @DSTPG          s              7p 0                                      Page elemnt#
     D @FILE           s             10a                                        MrptDirLgcal
     D @FILN#          s              9p 0
     D @fldlb          s             10a
     D @FLDR           s             10a                                        Folder
     D @LIB            s             10a                                        Library
     D @LIBR           s             10a                                        Library
     D @MONTH          s              2p 0                                      Month
     D @MPACT          s              1a
     D @MSGAC          s             10a
     D @MSGFL          s             20a
     D @MSGKY          s              4a
     D @MSGQ           s             20a
     D @MSGT@          s              8a
     D @MSGTX          s             80a
     D @MSGTY          s             10a
     D @OMNAM          s             10a                                        Omni Name
     D @OPCOD          s              6a                                        Opcode
     D @PATH           s             10a                                        PATH
     D @PFILE          s             10a                                        P0000 file
     D @POSTO          s             10a                                        Post to
     D @RTN            s              2a                                        Rtn code
     D @RTNRC          s              9p 0                                      Rtn # recs
     D @RTYP           s             10a                                        Rpt type
     D @S              s              5p 0
     D @SCROL          s              3a                                        Scroll factr
     D @SEBCH          s             10a                                        Spy00 start
     D @SEQ            s              5p 0
     D @SESEQ          s              9a                                        Position Sequen
     D @SESPY          s             10a                                        Spy00 start
     D @SETKY          s             10a                                        Spy00 start
     D @SETRT          s             50a                                        Big 5 key
     D @SETYP          s             10a                                        RptTyp
     D @SET30          s             30a                                        Seg start
     D @SORT           s             10a                                        Sort
     D @SPY00          s             10a
     D @TOTPG          s              9p 0                                      Pgs per Seg
     D @TYPE           s              1a                                        Show type
     D @VIEW           s             10a                                        View
     D @VWKEY          s            200a                                        ViewKeyValue
     D @WIN            s             10a                                        Window
     D @YEAR           s              4p 0                                      Year
     D AFFRPG          s              7p 0                                      From page
     D AFPGWK          s              9a
     D AFRSCL          s             10a                                        Rsc lib
     D AFRSCN          s             10a                                        Rsc name
     D AFRSCT          s              1a                                        Rsc type
     D AFRTBL          s              5p 0                                      Rtn buf len
     D AFRTCT          s              9p 0                                      Rtn pg/rsc c
     D AFRTSZ          s              9p 0                                      Rtn obj size
     D AFTOPG          s              7p 0                                      To page
     D ALFA4           s              4a                                        MTrace
     D ALF9            s              9a
     D APITYP          s             10a
     D ARG             s            256a                                        Search arg.
     D ARGLEC          s              3a
     D ARGLEN          s              3p 0                                      Arg length
     D ATOTPG          s              9a
     D AUTCAL          s             10a                                        Calling pgm
     D AUTCHK          s              1a                                        Chk Rpt
     D aute            s             40a
     D AUTJOB          s             10a                                         :
     D AUTLIB          s             10a                                        Object libr
     D AUTOBJ          s             10a                                        Object name
     D AUTOBT          s              1a                                        Rpt Obj type
     D AUTOFF          s              1a                                        Unload: no
     D AUTPGM          s             10a                                         :
     D AUTREQ          s              2p 0                                      CFG Rights?
     D AUTRPT          s             10a                                        Big5
     D autrqc          s              2a
     D AUTRTN          s              1a                                        Return Y/N
     D AUTUDT          s             10a                                         :
     D AUTUSR          s             10a                                         :
     D A01             s              1a                                        NOTE TYPE
     D Big5key         s             50a                                        Big5
     D BUF             s           8192a                                        8192 buffer
     D BYTRQS          s              9p 0                                      BYTES REQUESTED
     D BYTRTN          s              9p 0                                      BYTES RETURNED
     D CALLER          s             10a
     D CALPGM          s             10a
     D CLCMD           s            255a
     D colscn          s              3p 0
     D CONTST          s              3p 0
     D COPIES          s              3p 0
     D cvrmbr          s             10a
     D cvrpag          s              7a
     D DATFMT          s              3a
     D datfo           s              7a
     D DATSEP          s              1a
     D dcode           s              9p 0
     D DLBNDL          s             10a
     D DLREP           s             10a
     D DLREPT          s             10a
     D DLSEG           s             10a
     D DLSUBS          s             10a
     D DLTPGS          s              9p 0
     D DLTYPE          s              1a
     D DLWEBA          s             10a
     D DLWEBU          s             20a
     D drawer          s              4a
     D DSTPG9          s              9p 0                                      Overlay pg#
     D DSTTBL          s             10a                                        Save 4 Mg801
     D dtype           s              9p 0
     D duplex          s              4a
     D DXREP           s             10a
     D DXREPT          s             10a
     D DXSEG           s             10a
     D DXSUBS          s             10a
     D DXTYPE          s              1a
     D ENDPAG          s              9p 0                                      Ending Page #
     D eNotesPrint     s              1a                                        Notes print
     D errdta          s             80a
     D errid           s              7a
     D FILE            s             10a                                        "RINDEX"
     D filloc          s              1a
     D FLDCNT          s              9p 0                                      # of folders
     D FNDDTA          s              1a
     D FORMS           s              1a                                        FORMS
     D frmcl#          s              3p 0
     D FRMPAG          s              9p 0                                      Extended
     D frmprm          s             10a
     D FRMRR#          s              9p 0                                      From RR#
     D FRMRRC          s              9a
     D F2A             s              2a
     D F3A             s              3a                                        CAT LINE TO MES
     D F4A             s              4a
     D F5A             s              5a                                        Offline Sequenc
     D HANDL           s             10a                                        Folder
     D HANDLE          s             10a                                        Handle
     D KeyData         s           1000a
     D key20a          s             20a
     D lib             s             10a
     D LNKPG           s              1a
     D LNKSEC          s              3a
     D LOJOB           s             10a                                         :
     D LOPRG           s             10a                                         :
     D LORPT           s             10a                                        Big5
     D LOUDTA          s             10a                                         :
     D LOUSR           s             10a                                         :
     D MORSCS          s              1a
     D MSGDTA          s            100a                                        MsgDataFld
     D MSGFMT          s              8a
     D MSGID           s              7a                                        Msg ID
     D NEWNOT          s              1a                                        New Note
     D NODEID          s             17a                                        Node Id
     D NOTE#           s              9p 0                                      Note #
     D noteSecurity    s            100a
     D NOTLR           s              1a                                        Shutdown
     D NOTREC          s              9p 0                                      Rtn # of rec
     D np              s              3p 0
     D NTCODE          s              5a                                        Opcode
     D NTRQS           s              1a                                        BIG BUFFER
     D numwnd          s              3p 0
     D OMNCNT          s              9p 0                                      # of OmniNms
     D OmniName        s             10a                                        OmniName
     D OPCDE           s              6a                                        Oper code
     D OpCodeX         s             10a
     D operation       s              1a
     D OPLDIR          s             80a
     D OPLDRV          s             15a
     D OPLFIL          s             10a                                        Opt @00...xx
     D OPLID           s             10a
     D OPLVOL          s             12a
     D optfil          s             10a
     D orient          s             10a
     D outfil          s             10a
     D outflb          s             10a
     D outq            s             10a
     D OUTQ#           s             20a
     D outql           s             10a
     D OverlayID       s             10a                                        Overlay ID
     D OVRL#           s              1p 0
     D PAGCHR          s              1a                                         Is this a
     D PAGE#           s              7p 0                                      Pg   (or)
     D PAGFRM          s              9p 0                                      PAGE FROM
     D PAGTO           s              9p 0                                      PAGE TO
     D papsiz          s             10a
     D plcsfa          s              9p 0
     D plcsfd          s              9p 0
     D plcsfp          s              9p 0
     D POpCode         s             10a
     D POSDAT          s             10a                                        Post *DATE
     D POSFLD          s             10a                                        Post FLDNAM
     D POSFMT          s             10a                                        Post CYYMMDD
     D POSTN           s             10a                                        Posn to
     D PRespData       s           1000a
     D prmDesc         s            256a
     D prmUser         s             10a
     D PRqsData        s           1000a
     D prtf            s             10a
     D prtlib          s             10a
     D PRtnCode        s              1a
     D PRtnID          s              7a
     D prtwnd          s              1a
     D ptable          s             20a
     D ptrnod          s             17a
     D ptrtyp          s              6a
     D QDTA            s           1024a                                        Data
     D QDTASZ          s              5p 0                                      Data size
     D QKEY            s             27a                                        Key
     D QKEYSZ          s              3p 0                                      Key size
     D QLIB            s             10a                                        Que library
     D QNAME           s             10a                                        Que name
     D QORDER          s              2a                                        Logical op
     D QRYFLD          s             10a                                        Error Field
     D QRYLIN          s              3p 0                                      Error Line
     D QRYMSG          s              7a                                        Msg ID
     D QRYOBT          s             10a                                        OBJ Type
     D QRYOFF          s              5p 0                                      Opt Seq.
     D QRYOPC          s             10a                                        OpCode
     D QRYRTY          s             10a                                        Rep Type
     D QRYTYP          s              1a                                        Query Type S=Se
     D QSNDLN          s              3p 0                                      Sender lngth
     D qualFolder      s             20a
     D QWAIT           s              5p 0                                      Wait time
     D RDstSegDS       s            127a                                        Dist Seg DS
     D REM             s              9p 0
     D RevIDn          s              9p 0                                      Revision id
     D RFIL#           s              9p 0                                      FILE#
     D RMsgDta0        s            101a                                        Retn Msg Dta
     D RMsgID0         s              8a                                        Return Msg
     D ROFFS           s             11p 0                                      SEGMENT OFFS
     D RPTATR          s             80a                                        Rpt Attrs
     D rptfrm          s             10a
     D RptTypeID       s             10a                                        Report Type ID
     D rptud           s             10a
     D RRN#            s              9p 0                                      RRn in page
     D RTN             s              1a
     D RTNDES          s                   like(ERRDES)                         RETURN DATA
     D RtnRecs         s              9p 0                                      Rtn # recs
     D RTN901          s              7a                                        Rtn code
     D RUNMOD          s             10a                                        Run mode
     D SAVATR          s                   like(RPTATR)
     D secOvr          s             10a
     D SEGMNT          s             10a                                        Dst pgtbl nm
     D SETDBG          s              1a
     D SHSFIL          s             10a                                        Dst seg file
     D SLpartial       s            262a                                        partial spylink
     D SpyLinkDS       s            768a                                        SpyLink DS
     D TCMSGI          s              7a
     D TCPROG          s             10a
     D TCTEXT          s             80a
     D TEMP9           s              9a
     D TIFPG#          s              9p 0                                      Tiff/Cvt page#
     D TIMSEP          s              1a
     D TMP1            s              1a                                        Strip '*'
     D tocol#          s              3p 0
     D TOPAGE          s              9p 0                                      Parms for
     D WBTYPE          s              1a                                        In/Out
     D WEBADR          s             17a                                        Tcp/ip addr
     D WEBAPP          s             10a                                        Web App
     D WEBIP           s             15a                                        Web IP addr
     D WEBUSR          s             20a                                        Web User
     D WP              s             10a                                        Printing
     D WPL             s             10a
     D WPRT            s             10a                                        Client Servr
     D writer          s             10a
     D WSBM            s              1a
   
     C     *ENTRY        PLIST
     C                   PARM                    NODEID           17            Node Id
     C                   PARM                    RUNMOD           10            Run mode
     C                   PARM                    WEBIP            15            Web IP addr
     C                   PARM                    WEBAPP           10            Web App
     C                   PARM                    WEBUSR           20            Web User
     C                   PARM                    OPCDE             6            Oper code
     C                   PARM                    BUF            8192            8192 buffer
     c                   parm                    CLsend                         Comm layer send
     c                   parm                    CLrecv                         Comm layer rece
   
   
 1b  c     OPCDE         CASEQ     'INIT'        $INIT
     c     OPCDE         CASEQ     'QUIT'        $QUIT
 1e  c                   ENDCS
   
 1b  C                   IF        OPCDE = 'CONTPG'  and                        More page
     C                             FILE <> @ATM  and
     C                             FILE <> @PCL  and
     C                             FILE <> @PDF  and
     C                             OPCODE <> 'GETNT'  and
     c                             opcode <> 'LSTNT'
     C                   EXSR      CONTPG                                       buffers
 GO  C                   GOTO      RETURN
 1e  C                   ENDIF
   
     C                   Z-ADD     0             #
     *-----------------------------------------------------
     * Load data structure and work fields from entry parms
     *-----------------------------------------------------
 1b  C                   IF        OPCDE <> 'CONTPG'                            More data
 2b  C                   IF        NTRQS <> 'Y'                                 Not NoteMode
     C                   MOVEL(P)  BUF           REGREQ                          RQ...fields
 2x  C                   ELSE                                                   Note mode
     C                   MOVEL(P)  BUF           NOTREQ                          NQ...fields
 2e  C                   ENDIF
 1e  C                   ENDIF
     *
     C                   EXSR      LODWRK                                       FILE, LIBR,
     *                                                                         OPCODE, etc.
     *---------------------
     * Process all requests
     *---------------------
     c                   eval      OPCDE = *blanks
     C                   EXSR      PROCES
     *>>>>>>>>>>
     C     RETURN        TAG
     C                   RETURN
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PROCES        BEGSR
     *          -------------------------------
     *          Process Input from Client
     *          -------------------------------
   
     *--------------------
     * Init working fields
     *--------------------
     C                   MOVE      'K'           ERRTYP                         Rtn code
     C                   MOVE      *BLANKS       ERRDES                         Rtn err desc
     C                   MOVE      ' '           FNDDTA
     C                   MOVE      '  '          @RTN
     C                   MOVE      *BLANKS       DTS
     c                   eval      TableFile = 'N'
   
     * CHECK PRODUCT AUTHORIZATION.
 1b  C                   IF        AR_IND = '0'
     * DEFAULT PRODUCT IS SPYVISION/CS.
     C                   EVAL      PRD# = 6
 2b  c                   select
 2x  c                   when      runmod = 'DOCMGRAPI'
     c                   eval      prd# = 14
 2x  c                   when      runmod = 'DOCIMPEXP'
     c                   eval      prd# = 16
     * CHECK FOR AUTHORIZATION TO IMAGE VIEWER PLUS IF RUNNING.
 2x  C                   when      %subst(RUNMOD:1:8) = 'SPYEXEVU'
     C                   eval      prd# = 9
 2x  c                   when      %subst(runmod:1:4) = 'COEX'
     c                   eval      prd# = 11
     c                   eval      CLCMD = 'CRTDTAARA QTEMP/COEX *CHAR 1'
     C                   CALL      'MAG1030'
     C                   PARM                    RTN               1
     C                   PARM      'QTEMP'       #LIBR            10
     C                   PARM      'COEX'        #OBJ             10
     C                   PARM      '*DTAARA'     APITYP           10
     C                   PARM                    CLCMD           255
 2x  C                   when      %subst(runmod:1:3) = 'CAG'
     C                   eval      prd# = 21
     * SET PRODUCT NUMBER TO SPYWEB IF WEBIP ADDRESS AVAILABLE.
 2x  C                   when      WEBIP <> ' ' or webapp <> ' '
     C                   EVAL      PRD# = 17
 2e  C                   ENDSL
     C                   CALLP     SPYAUT(PRD#:AR_IND:AR_MSGID:AR_MDTA)
         // If CAG/Client combo, check license for ContentAccess first (above)
         // then the accompanying client (following).
 2b    if %subst(runmod:1:3) = 'CAG' and ar_msgID = ' ';
 3b      select;
 3x        when runmod = 'CAGAPI'; // DocView called through CA.
             prd# = 6;
 3x        when runmod = 'CAGCOEX'; // CoEx called through CA.
             prd# = 11;
 3e      endsl;
         SPYAUT(PRD#:AR_IND:AR_MSGID:AR_MDTA);
 2e    endif;
 1e  C                   ENDIF
     * SEND AUTHORIZATION ERROR OR DEMO EXPIRATION WARNING (ONE TIME)
 1b  C                   IF        AR_IND = '0' OR
     C                             AR_IND = '1' AND AR_MSGID <> ' '
     C                   EVAL      ERRDES = RTVMSGSPY(AR_MSGID:AR_MDTA)
     C                   EVAL      ERRDES = '   ' + %TRIM(ERRDES)
 2b  C                   IF        AR_IND = '1'
     C                   EVAL      AR_MSGID = ' '
     C                   EVAL      ERRTYP = 'W'
 2x  C                   ELSE
     C                   EVAL      @RTN = '30'
 2e  C                   ENDIF
 1e  C                   ENDIF
   
 1b  C                   IF        @RTN <> '30'                                 OK, Send
     C                   EXSR      COMMND                                         do command
     C                   EXSR      SNDREQ                                        requested
 GO  C                   GOTO      ENDPRO                                        data
 1e  C                   ENDIF
   
     * Term error
 1b  c                   if        %subst(errdes:1:10) = *blanks
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):' ')               terminal error
 1e  c                   endif
     C                   MOVE      'E'           ERRTYP
     C                   EXSR      LODDS
   
 1b  C                   IF        NTRQS = 'Y'
     C                   MOVEL(P)  NOTRSP        BUF                            Note respons
 1x  C                   ELSE
     C                   MOVEL(P)  REGRSP        BUF                            Regular
 1e  C                   ENDIF
   
     C     ENDPRO        ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDREQ        BEGSR
     *          ------------------------------------
     *          Send requested information to Client
     *          ------------------------------------
   
 1b  c                   IF        NTRQS = 'Y'                                  AFTER NEW
     C                   EXSR      LODDS
     C                   MOVEL(P)  NOTRSP        BUF
 GO  C                   GOTO      ENDSQ
 1e  C                   ENDIF
   
 1b  C                   IF        OPCODE = 'PRINT'  or
     C                             OPCODE = 'EMAIL'  or
     C                             OPCODE = 'BCHCT'  or
     C                             FILE = 'SYSDFT'
     C                   MOVE      ' '           ERRTYP
     C                   MOVE      *BLANKS       ERRDES
     C                   EXSR      LODDS
     C                   MOVEL(P)  REGRSP        BUF
 GO  C                   GOTO      ENDSQ                                        for Print
 1e  C                   ENDIF
   
 1b  C                   IF        FILE = '*AFPDS'  or
     C                             FILE = @ATM  or
     C                             FILE = @PCL  or
     C                             FILE = @PDF  or
     c                             OPCODE = 'LSTNT'  or                         LIST notes
     c                             OPCODE = 'GETNT'  or                         GET notes
     c                             OPCODE = 'UPDNT'  or                         UPDATE notes
     c                             OPCODE = 'WRTNT'  or                         WRITE notes
     c                             OPCODE = 'DLTNT'  or                         DELETE notes
     c                             OPCODE = 'DLTNU'  or                         DELETE notes
     c                             OPCODE = 'APDNT'                             Append notes
     C                   EXSR      LODDS
     C                   MOVEL(P)  REGRSP        BUF
 GO  C                   GOTO      ENDSQ                                        for AFP requ
 1e  C                   ENDIF
   
     * "Table File" return data
 1b  c                   if        TableFile = 'Y'
     C                   EXSR      LODDS
     C                   MOVEL(P)  REGRSP        BUF
 GO  C                   GOTO      ENDSQ                                        for AFP requ
 1e  c                   endif
   
 1b  C                   if        opcode <> 'GTAUT' and
     C                             %subst(opcode:1:3) <> 'NDX'
 2b  C                   IF        # > 0  and
     C                             # <> 120  and                                End of Rept
     C                             # <> 240
     C                   ADD       1             #                              data marker
     C                   MOVEL     '~'           DTS(#)
 2e  C                   ENDIF
 1e  C                   ENDIF
   
 1b  C                   IF        FNDDTA <> 'Y'  and
     C                             ERRDES = ' '
     C                   MOVE      RPTRTT        RTNRTT
     C                   MOVE      RPTCPI        RTNCPI
     C                   MOVE      RPTLPI        RTNLPI
     C                   MOVE      RPTWID        RTNWID
     C                   MOVE      OVLYN         RTNOVL
     C                   MOVE      PAGLNS        RTNPGL
     C                   MOVEL     FRMTYP        TMP1                           Strip '*'
 2b  C                   IF        TMP1 = '*'                                   from 1st
     C                   SUBST(P)  FRMTYP:2      RTNFRM                         of Form type
 2x  C                   ELSE
     C                   MOVEL(P)  FRMTYP        RTNFRM
 2e  C                   ENDIF
     C                   MOVE      RTNATR        ERRDES
 1e  C                   ENDIF
   
     C                   Z-ADD     1             CONTST
     C                   EXSR      CONTPG
   
     C     ENDSQ         ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CONTPG        BEGSR
     *          -----------------------------------------
     *          Send the rest of the buffers for the page
     *          -----------------------------------------
     C                   MOVEA(P)  DTS(CONTST)   SDT
     C                   EXSR      LODDS
     C                   MOVEL(P)  REGRSP        BUF
   
     C                   ADD       30            CONTST
 1b  C                   IF        # >= CONTST
     C                   MOVEL     'CONTPG'      OPCDE
 1x  C                   ELSE
     *   If the buffer has been sent, but there are more
     *   data for this page, go ahead and get the rest
 2b  C                   IF        MORSCS = '1'
     C                   EXSR      RTVPAG
     C                   Z-ADD     1             CONTST
 3b  C                   IF        # < 240
     C                   ADD       1             #                              data marker
     C                   MOVEL     '~'           DTS(#)                         END OF PAGE
 3e  C                   ENDIF
 2x  C                   ELSE
     *   If no more data for page, pass pack empty opcode
     C                   MOVE      *BLANKS       OPCDE
 2e  C                   ENDIF
 1e  C                   ENDIF
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     COMMND        BEGSR
     *          -------------------------------------------
     *          Perform the command requested by the client
     *          -------------------------------------------
   
     C                   MOVE      RRN#PG        ALFA4                          MTrace
     C                   eval      TCTEXT = %trimr(OPCODE) + ' ' + FILE          this
     C                   CAT       ALFA4:1       TCTEXT                          request
     C                   CAT       SKEY1:1       TCTEXT
     C                   CAT       SKEY2:1       TCTEXT
     C                   CAT       SKEY3:1       TCTEXT
     C                   CAT       SKEY4:1       TCTEXT
     c                   CAT       sMajMinVer:1  TCTEXT
     C                   CAT       XBFR:1        TCTEXT
     C                   CALL      'SPYCSTRC'    PLTRCE
     *---------------------
     * Clean up entry parms
     *---------------------
 1b  C                   IF        OPCODE = 'CLSNT'
     C                   MOVE      *ZEROS        RRN#PG
 1e  C                   ENDIF
   
     C                   MOVEL     RRN#PG        PAGCHR                          Is this a
 1b  C                   IF        PAGCHR <> '.'  and                            Scroll or
     C                             PAGCHR <> '*'                                 Special
     C                   MOVE      RRN#PG        #RRNPG                          request?
 1x  C                   ELSE
     C                   Z-ADD     0             #RRNPG                          yes
 1e  C                   ENDIF
   
     C                   MOVEA     XBFR          BF                              Xtra Buffer
   
     *----------------
     * Process opcodes
     *----------------
 1b  c                   select
     * System Env.
 1x  c                   when      File = 'SYSDFT'
     C                   EXSR      SYSENV                                       SysDft
 GO  C                   GOTO      ENDCMD
     * Authority
 1x  c                   when      OpCode = 'GTAUT'
     C                   EXSR      AUTHOR
 GO  C                   GOTO      ENDCMD
     * Get Overlays
 1x  c                   when      OpCode = 'GTOVL'
     C                   EXSR      GETOVL
 GO  C                   GOTO      ENDCMD
     * SpyLink/OmniLink Query Filter
 1x  c                   when      File = 'QRYFLT'
     C                   EXSR      QRYFLT
 GO  C                   GOTO      ENDCMD
     *------
 1x  c                   when      File = @ATM
     c                   EXSR      $Templates                                   Annot templates
 GO  C                   GOTO      ENDCMD
 1x  c                   when      File = @PCL
     C                   EXSR      CALPCL
 GO  C                   GOTO      ENDCMD
   
     *                  Execute if the PDF conversion
     *                  needs to take place otherwise
     *                  send the reconstituted PDF
     *                  Also test the for AFPTYP being type 4
   
 1x  c                   when      File = @PDF and
     c                             GetAPFTyp(rqskey) <> '4'
     C                   EXSR      CvtPDF
 GO  C                   GOTO      ENDCMD
 1e  C                   ENDSL
     *------
     * Notes
     *------
 1b  c                   if        %subst(File:1:1) = 'S' or                    Report
     c                             %subst(File:1:1) = 'B'                       Image Batch
 2b  c                   IF        OPCODE = 'LSTNT'  or                         LIST
     c                             OPCODE = 'GETNT'  or                         GET
     c                             OPCODE = 'UPDNT'  or                         UPDATE
     c                             OPCODE = 'WRTNT'  or                         WRITE
     c                             OPCODE = 'DLTNT'  or                         DELETE
     c                             OPCODE = 'DLTNU'  or                         DELETE
     c                             OPCODE = 'APDNT'                             Append
     c                   EXSR      $Notes                                       Notes/Annotes
 GO  C                   GOTO      ENDCMD
 2e  C                   ENDIF
 1e  C                   ENDIF
   
     c                   clear                   SDTds
     c                   clear                   RRSDT
     *------
     * Print
     *------
 1b  C                   IF        OPCODE = 'PRINT'  or
     C                             OPCODE = 'EMAIL'
     C                   EXSR      PRTRPT
 GO  C                   GOTO      ENDCMD
 1e  C                   ENDIF
     *-------------
     * Batch Counts
     *-------------
 1b  C                   IF        OPCODE = 'BCHCT'
     C                   EXSR      BCHCNT
 GO  C                   GOTO      ENDCMD
 1e  C                   ENDIF
     *------------------
     * Retrieve AFP data
     *------------------
 1b  C                   IF        FILE = '*AFPDS'
     C                   EXSR      RTVAFP
 GO  C                   GOTO      ENDCMD
 1e  C                   ENDIF
     *----------
     * Std Index
     *----------
 1b  c                   if        (%subst(File:1:1) = '@' and                  Multi member
     c                             blnSendPDFOnly   = FALSE)  or
     c                             %subst(File:1:1) = 'R'                       Single member
 2b  c                   if        %subst(opcode:1:3) = 'NDX'
     C                   EXSR      SRHNDX
 GO  C                   GOTO      ENDCMD
 2e  C                   ENDIF
 1e  C                   ENDIF
     *---------
     * OmniLink
     *---------
 1b  C                   SELECT
     * Get criteria: SpycsHCri
 1x  C                   WHEN      FILE = 'OMNICRIT'
 2b  c                   if        %subst(OpCode:1:4) = 'INFO'
     C                   EXSR      OMNCRI
 GO  C                   GOTO      ENDCMD
 2e  C                   ENDIF
     * Get rpt types: SpycsHRep
 1x  C                   WHEN      FILE = 'REPTYPES'
 2b  c                   if        %subst(OpCode:1:4) = 'INFO'
     c                   callp     OmniRepTypes(OPCODE)
 GO  C                   GOTO      ENDCMD
 2e  C                   ENDIF
     * Get hit list: SpycsHHit
 1x  C                   WHEN      FILE = 'OMNIHITS'
     c                   callp     OmniHitList(OPCODE)
 GO  C                   GOTO      ENDCMD
 1e  C                   ENDSL
     *--------
     * SpyLink
     *--------
 1b  c                   if        %subst(File:1:1) = '@' or
     c                             %subst(File:1:1) = x'b5' or
     c                             %subst(File:1:1) = x'44'
 2b  C                   SELECT
     * Get criteria
 2x  c                   when      %subst(OpCode:1:4) = 'INFO'
     C                   MOVEL(P)  'RLNKDEF'     FILE
     C                   EXSR      LNKCRI
 GO  C                   GOTO      ENDCMD
     * Get hit page
 2x  c                   when      %subst(OpCode:1:4) = 'READ'
     C                   EXSR      LNKPGS
 GO  C                   GOTO      ENDCMD
     * Get hit list
 2x  C                   WHEN      OPCODE = 'SELCR'  or
     C                             OPCODE = 'CLEAR'  or
     C                             OPCODE = 'SETLL'  or
     C                             OPCODE = 'SETGT'  or
     C                             OPCODE = 'SETEN'  or
     C                             OPCODE = 'RDGT '  or
     C                             OPCODE = 'RDLT '  or
     C                             OPCODE = 'RDLTX'  or
     C                             OPCODE = 'RDREV'                             read reverse
     c                   callp     LnkHitList(OPCODE)
 GO  C                   GOTO      ENDCMD
 2e  C                   ENDSL
 1e  C                   ENDIF
   
     * Document revision
 1b  c                   if        OpCode = 'DMLST' or                          Revision List
     c                             OpCode = 'DMLCK' or                          Lock Revision
     c                             OpCode = 'DMULK' or                          Un-Lock Revisio
     c                             OpCode = 'DMUSR' or                          User Lock List
     c                             OpCode = 'DMRVT' or                          Revert
     c                             OpCode = 'EDLNK' or                          Edit Link
     c                             (OpCode = 'READ' and File ='COBJECTS')
     c                   callp     DocRevision
 GO  C                   GOTO      ENDCMD
 1e  c                   endif
   
     * Overlay template support
 1b  c                   if        OpCode = 'CROVL' or                          Create ovl marg
     c                             OpCode = 'DLOVL' or                          Delete ovl marg
     c                             OpCode = 'UPOVL' or                          Update ovl marg
     c                             OpCode = 'RTOMD' or                          Retrieve ovl ma
     c                             OpCode = 'RTOVL'                             Retrieve ovl im
     c                   callp     OverlayOps(OPCODE)
 GO  C                   GOTO      ENDCMD
 1e  c                   endif
   
     *--------------
     * Screen scrape
     *--------------
 1b  C                   IF        FILE = 'OMNISERV'  and
     C                             OPCODE = 'WAKUP'
     C                   EXSR      WAKOMN
 GO  C                   GOTO      ENDCMD
 1e  C                   ENDIF
     *-------------
     * Distribution
     *-------------
   
 1b  c                   if        %subst(SKey1:1:7) = 'RSEGMNT'
     c                               and OPCODE = 'READ'
     C                   EXSR      RTVDPG
 GO  C                   GOTO      ENDCMD
 1e  C                   ENDIF
     *-----------
     * Table file
     *-----------
     C                   EXSR      LSTTBL
     *------------
     * Folder page
     *------------
 1b  c                   if        TableFile = 'N'
     C                   EXSR      RTVPAG
 1e  C                   ENDIF
   
     C     ENDCMD        ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     *  Call SPYPGRTV to get the name for the overlays requested before
     C     GETOVL        BEGSR
   
     C                   MOVEL     'GETOV'       @OPCOD
     C                   CALL      'SPYPGRTV'    PLRETV
   
     c                   callp     RtnStatus(@RTN:'SPYPGRTV':@SETKY:
     c                                                       MsgID:MsgDta)
   
     C                   MOVEA     WTS           DTS
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     AUTHOR        BEGSR
   
     C                   SUBST     SKEY:1        AUTRPT                         Big5
     C                   SUBST     SKEY:11       AUTJOB                          :
     C                   SUBST     SKEY:21       AUTPGM                          :
     C                   SUBST     SKEY:31       AUTUSR                          :
     C                   SUBST     SKEY:41       AUTUDT                          :
   
     c                   subst     skey:51       autrqc
     c                   move      autrqc        autreq
   
 1b  c                   if        autreq = 0
     * The following code will not work for the get-all-auth request if the sysenv
     * is configured with the jobnam as the only non-exclusionary key.
 2b  c                   if        skey1 = ' ' and skey2 <> ' ' and
     c                             %subst(skey:21:30) = ' '
     c                   eval      skey1 = x'00' + 'BATCHID'
 2e  c                   endif
     c                   eval      autreq = 7
 1e  c                   endif
   
     C                   CALL      'MAG1060'                            50
     C                   PARM      'SPYCS'       AUTCAL           10            Calling pgm
     C                   PARM      ' '           AUTOFF            1            Unload: no
     C                   PARM      'R'           AUTCHK            1            Chk Rpt
     C                   PARM      'R'           AUTOBT            1            Rpt Obj type
     C                   PARM      *BLANKS       AUTOBJ           10            Object name
     C                   PARM      *BLANKS       AUTLIB           10            Object libr
     C                   PARM      skey1         AUTRPT           10            Big5
     C                   PARM                    AUTJOB           10             :
     C                   PARM                    AUTPGM           10             :
     C                   PARM                    AUTUSR           10             :
     C                   PARM                    AUTUDT           10             :
     C                   PARM                    AUTREQ            2 0          CFG Rights?
     C                   PARM      *BLANKS       AUTRTN            1            Return Y/N
     C                   PARM      *BLANKS       AUT
     c                   parm      ' '           aute             40
     C                   parm      ' '           secOvr           10
     C                   parm      ' '           noteSecurity    100
   
 1b  c                   if        autreq = 7
     c                   eval      getAllAuth = *all'N'
     c                   movea     aut           rptsds
     c                   eval      ga_view = sread
     c                   eval      ga_print = sprnt
     c                   eval      ga_delete = sdel
     c                   eval      ga_stampPlace = schg
     c                   eval      ga_display = ga_view
     c                   eval      ga_upload = scopy
 2b  c                   if        ga_upload = 'N' and extsec = 'N'
     c                   eval      ga_upload = 'Y'
 2e  c                   endif
     c                   eval      ga_editLink = schg
     c                   eval      ga_checkout = scopy
 2b  c                   if        ga_checkout = 'N' and extsec = 'N'
     c                   eval      ga_checkout = sread
 2e  c                   endif
     c                   eval      ga_critanno = scfg
     c                   eval      ga_dltLinkVal = scfg
     *
     *                  Add in the new values for email, fax and save
     *
     c                   eval      ga_email = semail
     c                   eval      ga_fax   = sfax
     c                   eval      ga_save  = ssave
   
     c                   movea     getAllAuth    dts
 1x  c                   else
     C                   MOVEL     AUTRTN        DTS(1)                         Y/N authoriz
 1e  c                   endif
   
     c                   eval      dts(1) = %trimr(dts(1)) + noteSecurity
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTTBL        BEGSR
     *          ---------------------------------------
     *          Perform Opcodes for SpyView table files
     *          ---------------------------------------
     c                   eval      TableFile = 'Y'                              Assume
 1b  C                   SELECT
 1x  c                   when      %subst(File:1:7) = 'MFLDDIR'
     C                   EXSR      LSTFLD
 1x  c                   when      %subst(File:1:7) = 'RMAINTN'                 New Vers
     C                   EXSR      LSTTYP
 1x  c                   when      %subst(File:1:6) = 'RMAINT'
     * skip
 1x  c                   when      %subst(File:1:8) = 'MRPTDIRN'                New Vers
     C                   EXSR      LSTRPN
 1x  c                   when      %subst(File:1:6) = 'MRPTDI'
     C                   EXSR      LSTRPT
 1x  c                   when      %subst(File:1:7) = 'RLNKDEF'
     C                   EXSR      LSTLNK
 1x  c                   when      %subst(File:1:6) = 'RINDEX'
     C                   EXSR      LSTNDX
 1x  c                   when      %subst(File:1:7) = 'RDSTHST'
     C                   EXSR      LSTHST
 1x  c                   when      %subst(File:1:8) = 'AHYPLNKD'
     C                   EXSR      LSTOMN
 1x  c                   when      %subst(File:1:8) = 'MIMGDIRN'                New Vers
     C                   EXSR      LSTBCN
 1x  c                   when      %subst(File:1:7) = 'MIMGDIR'
     C                   EXSR      LSTBCH
 1x  c                   when      %subst(File:1:7) = 'RLNKOFF'
     C                   EXSR      LSTOFF
 1x  c                   when      %subst(File:1:8) = 'CALENDER'
     C                   EXSR      LSTCAL
 1x  c                   when      %subst(File:1:7) = 'BCHFILE'
     C                   EXSR      LSTFIL
 1x  c                   when      File = 'PGCNT'
     c                   callp     GetPageInfo(OPCODE)
 1x  c                   when      File = 'REVID'
     c                   callp     Cvt2RevID(OPCODE)
 1x  c                   other
     c                   eval      TableFile = 'N'                              Not a table fil
 1e  C                   ENDSL
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTFLD        BEGSR
     *          -----------------------------------------
     *          Get the next list of folders from MFLDDIR
     *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD                         Place entry
     C                   MOVEL(p)  SKEY1         @FLDR                          parameter
     C                   MOVEL(p)  SKEY2         @LIBR                          list fields
     C                   MOVE      *BLANKS       @SCROL
     * Scrolling
 1b  C                   IF        PAGCHR = '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @FLDR
     C                   MOVE      *BLANKS       @LIBR
 1e  C                   ENDIF
   
     C                   CALL      'SPYCSFLD'    PLFLD
   
     c                   callp     RtnStatus(@RTN:'SPYCSFLD':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      FLDCNT        ERRDES                         # of folders
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLFLD         PLIST
     C                   PARM                    @FLDR            10            Folder
     C                   PARM                    @LIBR            10            Library
     C                   PARM                    @OPCOD            6            Opcode
     C                   PARM                    WEBAPP                         Web Applic.
     C                   PARM                    WEBUSR                         Web Applic.
     C                   PARM                    @SCROL            3            Scroll factr
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC            9 0          Rtn # recs
     C                   PARM      0             FLDCNT            9 0          # of folders
     C                   PARM      '00'          @RTN              2            Rtn code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTFIL        BEGSR
     *          -----------------------------------------
     *          Get the next list of files in a batch
     *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD                         Place entry
     C                   MOVEL(p)  SKEY1         @BCHID                         parameters
     C                   MOVEL(p)  SKEY2         @SESEQ
 1b  c                   if        skey3 = '*RRN'
     c                   move      @seseq        docrrn
     c                   eval      rc = GetDocAttr(@bchid:docrrn:DocAttrDS)
     c                   callp     DocFncQuit
     c                   eval      fyldta = DocAttrDS
     c                   eval      fludat = da_UpDate
     c                   eval      flutim = da_UpTime
     c                   eval      flusr = da_UpUser
     c                   eval      flnode = da_UpNode
     c                   eval      flseq = 0
     c                   eval      flrrn = docrrn
     c                   eval      sdtds = fyldta
     c                   eval      @rtn = '20'
     c                   eval      @rtnrc = 1
 1e  c                   endif
   
 1b  c                   if        skey3 <> '*RRN'
     *   REPLACE 5 CHAR OPCODE BY 6 CHAR OPCODE
 2b  C                   SELECT
 2x  C                   WHEN      @OPCOD = 'REDLT'
     C                   MOVEL     'READLT'      @OPCOD
 2x  C                   WHEN      @OPCOD = 'REDGT'
     C                   MOVEL     'READGT'      @OPCOD
 2e  C                   ENDSL
   
     C                   MOVEA     XBFR          SDT                            FILTER
     C                   CALL      'SPYCSFIL'    PLFIL                          Get list
 1e  c                   endif
   
     c                   callp     RtnStatus(@RTN:'SPYCSFIL':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES                         # of records
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLFIL         PLIST
     C                   PARM      RQLIBR        @WIN             10            Window
     C                   PARM                    @BCHID           10            batch ID
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SESEQ            9            Position Sequen
     C                   PARM                    SDT                            Return data
     C                   PARM      0             @RTNRC                         Rtn # of rec
     C                   PARM                    @RTN                           Return code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTRPN        BEGSR
     *          -----------------------------------------
     *          Get the next list of reports from MRPTDIR (NEW VERSION)
     *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD                         Place entry
     C                   MOVEL(p)  SKEY1         @VIEW                          parameters
     C                   MOVEL(p)  SKEY2         @SESPY
     C                   MOVEL(p)  SKEY3         @PATH
     C                   MOVEL(p)  SKEY4         @LIB
     C                   MOVEL(p)  XBFR          @VWKEY
   
     *   REPLACE 5 CHAR OPCODE BY 6 CHAR OPCODE
 1b  C                   SELECT
 1x  C                   WHEN      @OPCOD = 'REDLT'
     C                   MOVEL     'READLT'      @OPCOD
 1x  C                   WHEN      @OPCOD = 'REDGT'
     C                   MOVEL     'READGT'      @OPCOD
 1e  C                   ENDSL
   
     C                   MOVEA     XBFR          SDT                            FILTER
     C                   CALL      'SPYCSRPTN'   PLRPTN                         Get list
   
     c                   callp     RtnStatus(@RTN:'SPYCSRPTN':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @SCROL        ERRDES                         Scroll to pos
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLRPTN        PLIST
     C                   PARM      RQLIBR        @WIN                           Window
     C                   PARM                    @VIEW            10            View
     C                   PARM      *BLANKS       @LIB             10            Library
     C                   PARM      *BLANKS       @PATH            10            PATH
     C                   PARM                    @VWKEY          200            ViewKeyValue
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SESPY           10            Spy00 start
     C                   PARM      *BLANKS       POSFLD           10            Post FLDNAM
     C                   PARM      *BLANKS       POSDAT           10            Post *DATE
     C                   PARM      *BLANKS       POSFMT           10            Post CYYMMDD
     C                   PARM      *BLANKS       POSTN                          Post to
     C                   PARM                    SDT                            Return data
     C                   PARM      0             @RTNRC                         Rtn # of rec
     C                   PARM                    @RTN                           Return code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTBCN        BEGSR
     *          -----------------------------------------
     *          Get the next list of batches from MIMGDIR (NEW VERSION)
     *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD                         Place entry
     C                   MOVEL(p)  SKEY1         @VIEW                          parameters
     C                   MOVEL(p)  SKEY2         @SEBCH
     C                   MOVEL(p)  SKEY3         @PATH
     C                   MOVEL(p)  SKEY4         @LIB
     C                   MOVEL(p)  XBFR          @VWKEY
   
     *   REPLACE 5 CHAR OPCODE BY 6 CHAR OPCODE
 1b  C                   SELECT
 1x  C                   WHEN      @OPCOD = 'REDLT'
     C                   MOVEL     'READLT'      @OPCOD
 1x  C                   WHEN      @OPCOD = 'REDGT'
     C                   MOVEL     'READGT'      @OPCOD
 1e  C                   ENDSL
   
     C                   CALL      'SPYCSBCHN'   PLBCHN                         Get list
   
     c                   callp     RtnStatus(@RTN:'SPYCSBCHN':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @SCROL        ERRDES                         Scroll to pos
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLBCHN        PLIST
     C                   PARM      RQLIBR        @WIN                           Window
     C                   PARM                    @VIEW                          View
     C                   PARM      *BLANKS       @LIB                           Library
     C                   PARM      *BLANKS       @PATH                          PATH
     C                   PARM                    @VWKEY                         ViewKeyValue
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SEBCH           10            Spy00 start
     C                   PARM      *BLANKS       POSFLD                         Post FLDNAM
     C                   PARM      *BLANKS       POSDAT                         Post *DATE
     C                   PARM      *BLANKS       POSFMT                         Post CYYMMDD
     C                   PARM      *BLANKS       POSTN                          Post to
     C                   PARM                    SDT                            Return data
     C                   PARM      0             @RTNRC                         Rtn # of rec
     C                   PARM                    @RTN                           Return code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTTYP        BEGSR
     *          -----------------------------------------
     *          Get the next list of report types RMAINT (NEW VERSION)
     *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD                         Place entry
     C                   MOVEL(p)  SKEY1         @VIEW                          parameters
     C                   MOVEL(p)  SKEY2         @TYPE
     C                   MOVEA     KEY(12)       @SORT
     C                   MOVEA     KEY(22)       @SETYP
     C                   SUBST     XBFR:1        @FLDR
     C                   SUBST     XBFR:11       @LIBR
     *   REPLACE 5 CHAR OPCODE BY 6 CHAR OPCODE
 1b  C                   SELECT
 1x  C                   WHEN      @OPCOD = 'REDLT'
     C                   MOVEL     'READLT'      @OPCOD
 1x  C                   WHEN      @OPCOD = 'REDGT'
     C                   MOVEL     'READGT'      @OPCOD
 1e  C                   ENDSL
   
     C                   CALL      'SPYCSRTY'    PLTYP                          Get list
   
     c                   callp     RtnStatus(@RTN:'SPYCSRTY':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES                         # of records
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLTYP         PLIST
     C                   PARM                    @VIEW                          View
     C                   PARM                    @FLDR                          Folder
     C                   PARM                    @LIBR                          Library
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SORT            10            Sort
     C                   PARM                    @TYPE             1            Show type
     C                   PARM                    @SETYP           10            RptTyp
     C                   PARM      *BLANKS       POSTN            10            Posn to
     C                   PARM                    SDT                            Return data
     C                   PARM      0             @RTNRC                         Rtn # of rec
     C                   PARM                    @RTN                           Return code
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTCAL        BEGSR
     *          ----------------
     *          Get the CALENDAR
     *          ----------------
     C                   MOVEL(p)  OPCODE        @OPCOD                         Place entry
     C                   MOVEL(p)  SKEY1         @VIEW                          parameters
     C                   SUBST     XBFR:1        @FLDR
     C                   SUBST     XBFR:11       @LIBR
     C                   SUBST     XBFR:21       @RTYP
     C                   SUBST     XBFR:31       F4A
     C                   MOVE      F4A           @YEAR
     C                   SUBST     XBFR:35       F2A
     C                   MOVE      F2A           @MONTH
   
     C                   CALL      'SPYCSCAL'    PLCAL                          Get list
   
     c                   callp     RtnStatus(@RTN:'SPYCSCAL':File)
   
     C                   ENDSR
     *================================================================
     C     PLCAL         PLIST
     C                   PARM                    @VIEW                          View
     C                   PARM                    @FLDR                          Folder
     C                   PARM                    @LIBR                          Library
     C                   PARM                    @RTYP            10            Rpt type
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @YEAR             4 0          Year
     C                   PARM                    @MONTH            2 0          Month
     C                   PARM                    SDT                            Return data
     C                   PARM                    @RTN                           Return code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTRPT        BEGSR
     *          -----------------------------------------
     *          Get the next list of reports from MRPTDIR
     *          -----------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD                         Place entry
     C                   MOVEL(p)  FILE          @FILE                          parms into
     C                   MOVEL(p)  SKey1         @FLDR                          parameters
     C                   MOVEL(p)  SKey2         @LIBR
     C                   MOVEA     KEY(66)       @SETKY
     C                   MOVEA     BF(1)         @POSTO
     C                   MOVE      *BLANKS       @SCROL
     * Scrolling
 1b  C                   IF        PAGCHR = '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @SETKY
     C                   MOVE      *BLANKS       @POSTO
 1x  C                   ELSE
     * Position to
 2b  C                   IF        @POSTO <> *BLANKS
     C                   MOVE      *BLANKS       @SETKY
     C                   MOVE      *BLANKS       @SCROL
 2e  C                   ENDIF
     * Page up/dwn
 2b  C                   IF        @SETKY <> *BLANKS
     C                   MOVE      *BLANKS       @POSTO
     C                   MOVE      *BLANKS       @SCROL
 2e  C                   ENDIF
 1e  C                   ENDIF
   
     C                   MOVEA     XBFR          SDT                            FILTER
     C                   CALL      'SPYCSRPT'    PLRPT                          Get list
   
     c                   callp     RtnStatus(@RTN:'SPYCSRPT':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @SCROL        ERRDES                         Scroll to pos
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLRPT         PLIST
     C                   PARM                    @FILE            10            MrptDirLgcal
     C                   PARM                    @FLDR                          Folder
     C                   PARM                    @LIBR                          Library
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SETKY           10            Spy00 start
     C                   PARM                    @SCROL                         Scroll factr
     C                   PARM                    @POSTO           10            Post to
     C                   PARM                    SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTOFF        BEGSR
     *          -----------------------------------------
     *          Get the next list of reports from RLNKOFF
     *          -----------------------------------------
     C                   MOVEL(p)  SKey1         LORPT                          Big5
     C                   MOVEL(p)  SKey2         LOJOB                           :
     C                   MOVEL(p)  SKey3         LOPRG                           :
     C                   MOVEL(p)  SKey4         LOUSR                           :
     C                   MOVEA     KEY(41)       LOUDTA                          :
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   CALL      'SPYCSOLNK'   PLOFF                          SpyCsOLnk
   
     c                   callp     RtnStatus(@RTN:'SPYCSOLNK':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES                         # of records
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLOFF         PLIST
     C                   PARM                    LORPT
     C                   PARM                    LOJOB
     C                   PARM                    LOPRG
     C                   PARM                    LOUSR
     C                   PARM                    LOUDTA
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTBCH        BEGSR
     *          -----------------------------------------------
     *          Get the next list of Image batches from MIMGDIR
     *          -----------------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     ***
     C                   MOVEL(p)  FILE          @FILE
 1b  C                   IF        @FILE <> 'MIMGDIR3'
     C                   MOVEL     'MIMGDIR3'    @FILE
 1e  C                   ENDIF
     C                   MOVEL(p)  SKey1         @FLDR
     C                   MOVEL(p)  SKey2         @LIBR
     C                   MOVEA     KEY(66)       @SETKY                         (B00*)
     C                   MOVEA     BF(1)         @POSTO
     C                   MOVE      *BLANKS       @SCROL
     * Scrolling
 1b  C                   IF        PAGCHR = '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @SETKY
     C                   MOVE      *BLANKS       @POSTO
 1x  C                   ELSE
     * Position to
 2b  C                   IF        @POSTO <> *BLANKS
     C                   MOVE      *BLANKS       @SETKY
     C                   MOVE      *BLANKS       @SCROL
 2e  C                   ENDIF
     * Page up/dwn
 2b  C                   IF        @SETKY <> *BLANKS
     C                   MOVE      *BLANKS       @POSTO
     C                   MOVE      *BLANKS       @SCROL
 2e  C                   ENDIF
 1e  C                   ENDIF
   
     C                   CALL      'SPYCSBCH'    PLBCH                          Get list
   
     c                   callp     RtnStatus(@RTN:'SPYCSBCH':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @SCROL        ERRDES                         Scroll to pos
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLBCH         PLIST
     C                   PARM                    @FILE                          MimgDirLgcal
     C                   PARM                    @FLDR                          Folder
     C                   PARM                    @LIBR                          Library
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SETKY                         B0000 start
     C                   PARM                    @SCROL                         Scroll factr
     C                   PARM                    @POSTO                         Post to
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     BCHCNT        BEGSR
     *          ----------------------------------------------
     *          Get the Image Batch Counts for selected FOLDER
     *          ----------------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKey1         @FLDR
     C                   MOVEL(p)  SKey2         @LIBR
   
     C                   CALL      'SPYCSBCNT'   PLBCNT                         Get Bcnt
     C     PLBCNT        PLIST
     C                   PARM                    @FLDR
     C                   PARM                    @LIBR
     C                   PARM                    @OPCOD
     C                   PARM      *BLANKS       SDT
     C                   PARM      '00'          @RTN
   
     c                   callp     RtnStatus(@RTN:'SPYCSBCNT':@FLDR)
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTLNK        BEGSR
     *          -----------------------------------------------
     *          Get the next list of SpyLinked Reports & Images
     *            (primarily RMaint data)
     *          -----------------------------------------------
 1b                      If ( ( Skey1 <> *blanks )   and
                              ( SKey2 = KEY_RTYPID )     );
                           Callp(e) ToUpper(SKey1);
 1e                      Endif;
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  FILE          @FILE
     C                   MOVEL(p)  SKey          @SETRT
     C                   MOVE      *BLANKS       @SCROL
     * Scrolling
 1b  C                   IF        PAGCHR = '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @SETRT
 1e  C                   ENDIF
   
     C                   CALL      'SPYCSLRMNT'  PLLNK
     C     PLLNK         PLIST
     C                   PARM                    @FILE                          "RLNKDEF"
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SETRT           50            Big 5 key
     C                   PARM                    WEBAPP                         Web Applic.
     C                   PARM                    WEBUSR                         Web Applic.
     C                   PARM                    @SCROL                         Scroll factr
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
     c                   parm                    sMajMinVer                     Major/Minor/Ver
   
     c                   callp     RtnStatus(@RTN:'SPYCSLRMNT':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES                         # of records
 1e  c                   endif
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTNDX        BEGSR
     *          -------------------------------------------------
     *          Get the next list of Standard Indexes from RINDEX
     *          -------------------------------------------------
     C                   MOVE      FILE          @FILE
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKey1         @SETKY
   
     C                   CALL      'SPYCSNDX'    PLNDX
     C     PLNDX         PLIST
     C                   PARM                    FILE             10            "RINDEX"
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SETKY                         Spy00 start
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
   
     c                   callp     RtnStatus(@RTN:'SPYCSNDX':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES                         # of records
 1e  c                   endif
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTHST        BEGSR
     *          -------------------------------------------
     *          Get the next list of segments from RDSTHST
     *          -------------------------------------------
     C                   MOVEL(P)  OPCODE        @OPCOD
     C                   MOVE      FILE          @FILE
     C                   MOVEL(p)  SKey          @SET30
   
     * Tell segment application to suppress returning annotation flags in
     * the buffer if DocView. It doesn't need the flags. CoEx/VCO only.
 1b    if prd# = 6 or prd# = 14; //DocView or DOCMGRAPI
         FILE = %trimr(FILE) + 'DV';
 1e    endif;
     C                   CALL      'SPYCSSEG'    PLHST
     C     PLHST         PLIST
     C                   PARM                    FILE                           "RDSTHST"
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SET30           30            Seg start
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
   
     c                   callp     RtnStatus(@RTN:'SPYCSSEG':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES                         # of records
 1e  c                   endif
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSTOMN        BEGSR
     *          --------------------------------------------------
     *          Get the next list of OmniLink names from AhypLnkD
     *          --------------------------------------------------
     C                   MOVEL(p)  OPCODE        @OPCOD
     C                   MOVEL(p)  SKey1         @OMNAM
     C                   MOVE      *BLANKS       @SCROL
     * Scrolling
 1b  C                   IF        PAGCHR = '.'
     C     3             SUBST     RRN#PG:1      @SCROL
     C                   MOVE      *BLANKS       @OMNAM
 1e  C                   ENDIF
   
     C                   CALL      'SPYCSOMN'    PLOMN                          Get list
     C     PLOMN         PLIST
     C                   PARM                    @OMNAM           10            Omni Name
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    WEBAPP                         Web App
     C                   PARM                    WEBUSR                         Web User
     C                   PARM                    @SCROL                         Scroll factr
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      0             OMNCNT            9 0          # of OmniNms
     C                   PARM      '00'          @RTN                           Rtn code
   
     c                   callp     RtnStatus(@RTN:'SPYCSOMN':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      OMNCNT        ERRDES                         # of Omni Names
 1e  c                   endif
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LNKCRI        BEGSR
     *          --------------------------------------------------    -
     *          Get the field names & descriptions for the SPYLINK
     *          --------------------------------------------------    -
     *  When OPCODE = 'INFO ' a single key value is in KEY.
     *  When OPCODE = 'INFOn' where n is 1-9, KEY is blank and
     *     n 55-byte (Big5 + Offlink seq#) are in BF (XBFR).
   
     c                   eval      @OPCOD = opCode
     c                   eval      LinkLst(*) = *blanks
 1b  c                   if        %subst(@OPCOD:1:4) = 'INFO'
 2b  c                   if        %subst(@OPCOD:5:1) <> *blanks
     C                   MOVEA     BF(1)         LinkLst
 2x  c                   else
 3b  c                   select
 3x  c                   when      sMajMinVer = *blanks
     c                   eval      LinkLst(1) = Skey                            Big5 + Seq
 3x  c                   when      Skey1 <> *blanks
     c                   eval      LinkLst(1) = Skey                            xxxx + Seq
     c                   eval      %subst(LinkLst(1):1:50)
     c                                = x'00'+'RTYPEID  '+SKey1                 Report Type
 3x  c                   when      Skey2 <> *blanks
     c                   eval      %subst(LinkLst(1):1:20)
     c                                = x'00'+'REVID    '+SKey2                 RevID
 3e  c                   endsl
 2e  c                   endif
 1e  c                   endif
     c                   eval      @FILE  = file
     C                   CLEAR                   SDT
   
     C                   CALL      'SPYCSLCRI'   PLCRI                          Get list
   
     c                   callp     RtnStatus(@RTN:'SPYCSLCRI':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES                         # of records
 1e  c                   endif
     c                   eval      TableFile = 'Y'
   
     C                   ENDSR
     *================================================================
     C     PLCRI         PLIST
     C                   PARM                    @FILE                          "RLNKDEF"
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    LinkLst                        Big5+seq (9)
     C                   PARM                    WEBAPP                         Web Applic.
     C                   PARM                    WEBUSR                         Web User
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
     c                   parm                    sMajMinVer                     Major/Minor/Ver
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LNKPGS        BEGSR
     *          -----------------------------------------------
     *          Get the pages for the selected SpyLink hit key
     *          -----------------------------------------------
   
     ***
     C                   MOVEL(P)  'READ '       @OPCOD
     C                   Z-ADD     #RRNPG        PAGE#
   
     C                   MOVE      'Y'           LNKPG
     C                   EXSR      RTVPAG                                       Get Page
   
     C                   ENDSR
     *================================================================
     c     plSpyWeb      plist
     c                   parm                    POpCode          10
     c                   parm                    PRqsData       1000
     c                   parm                    PRtnCode          1
     c                   parm                    PRtnID            7
     c                   parm                    PRespData      1000
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OMNCRI        BEGSR
     *          ----------------------------------------------------  -
     *          Get the field names and descriptions for the OMNLINK
     *          ----------------------------------------------------  -
   
     *  When OPCODE = 'INFO ' a single key value is in KEY.
     *  When OPCODE = 'INFOn' where n is 1-9, KEY is blank and
     *   n 10-byte key values are in BF (XBFR).
   
     c                   eval      @OPCOD = opCode
     c                   eval      OmniLst(*) = *blanks
 1b  c                   if        %subst(@OPCOD:1:4) = 'INFO'
 2b  c                   if        %subst(@OPCOD:5:1) <> *blanks
     C                   MOVEA     BF(1)         OmniLst
 2x  c                   else
     c                   eval      OmniLst(1) = SKey
 2e  c                   endif
 1e  c                   endif
     C                   CLEAR                   SDT
   
     C                   CALL      'SPYCSHCRI'   PHCRI                          Get Criteria
   
     c                   callp     RtnStatus(@RTN:'SPYCSHCRI':File)
 1b  c                   if        @RTN <= '20'
     C                   MOVE      @RTNRC        ERRDES                         # of records
 1e  c                   endif
     c                   eval      TableFile = 'Y'
   
     C                   ENDSR
     *================================================================
     C     PHCRI         PLIST
     C                   PARM                    OmniLst                        OmniName (9)
     C                   PARM                    WEBAPP                         Web Applic.
     C                   PARM                    WEBUSR                         Web User
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM      *BLANKS       SDT                            Rtn data
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
     c                   parm                    sMajMinVer                     Major/Minor/Ver
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WAKOMN        BEGSR
     *          ------------------------------------
     *          Wake up OmniServer for screen scrape
     *          ------------------------------------
     C                   MOVEL(P)  'WAKEUP'      QDTA
   
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SPYCSDQ'     QNAME            10            Que name
     C                   PARM      '*LIBL'       QLIB             10            Que library
     C                   PARM      1024          QDTASZ            5 0          Data size
     C                   PARM                    QDTA           1024            Data
     C                   PARM      17            QKEYSZ            3 0          Key size
     C                   PARM                    NODEID                         Key
   
     C                   MOVE      '00'          @RTN
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVDPG        BEGSR
     *          --------------------------
     *          Get Distribution page data
     *          --------------------------
     C                   EXSR      RTVDST                                       Load PAGE#
   
 1b  C                   IF        @RTN = '00'
     C                   MOVE      ' '           MORSCS
     C                   MOVE      ' '           LNKPG
 2b  C                   IF        @OPCOD <> 'READC'
     C                   MOVEL     'DTAOV'       @OPCOD                         WITH OVERLAY
 2e  C                   ENDIF
     C                   CALL      'SPYPGRTV'    PLRETV
 2b  C                   IF        @RTN <> '30'                                 O.K.
 3b  C                   IF        SDLOGT = 'Y'
     C                   MOVEA     BF            DLSEG
     C                   MOVE      'V'           DLTYPE
     C                   MOVE      @SETKY        DLREP
     C                   Z-ADD     @TOTPG        DLTPGS
     C                   EXSR      MAG901
 3e  C                   ENDIF
     C                   Z-ADD     #RTV          #
     C                   MOVEA     WTS           DTS
     C                   Z-ADD     @DSTPG        DSTPG9                         Overlay pg#
     C                   MOVE      DSTPG9        DTS                            with elemnt#
 2e  C                   ENDIF                                                  pos 248-256.
 1e  C                   ENDIF
   
 1b  C                   SELECT
     * 20: Warning: no more pages
 1x  C                   WHEN      @RTN = '20'
     c                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):File)
     * 25: Part of a long page returned.  Setup for subr RTVPAG next.
 1x  C                   WHEN      @RTN = '25'
     C                   MOVE      '1'           MORSCS
     C                   MOVEA     @SETKY        KEY(66)
     * 30: Fatality
 1x  C                   WHEN      @RTN = '30'
     c                   eval      ErrTyp = 'E'
     c                   eval      ErrDes = @RTN+' '+RtvMsgSpy(MsgID:MsgDta)
 1e  C                   ENDSL
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVDST        BEGSR
     *          -----------------------------------------------------
     *          Get Distribution page# (PAGE#) from partial page file
     *          -----------------------------------------------------
     C                   MOVEL(P)  'READ  '      @OPCOD                         Move parms
     C                   MOVE      *BLANKS       @SCROL                         to parm list
   
 1b  C                   IF        PAGCHR = '.'                                 Scroll
     C     3             SUBST     RRN#PG:1      @SCROL                          requested
     C                   MOVE      *BLANKS       @SETRT
 1e  C                   ENDIF
   
     C                   MOVEA     BF(51)        DSTTBL                         Save 4 Mg801
     C                   MOVEA     BF(51)        @FILE
     C                   MOVEA     BF(91)        @SETKY
     C                   MOVEA     BF(101)       ATOTPG
     C                   MOVE      ATOTPG        @TOTPG
     C                   Z-ADD     #RRNPG        @DSTPG
 1b  C                   IF        @DSTPG = 0
     C                   Z-ADD     1             @DSTPG
 1e  C                   ENDIF
   
     C                   MOVE      '00'          @RTN
     C                   MOVE      *BLANKS       MSGID
     C                   MOVE      *BLANKS       MSGDTA
 1b  C                   IF        @FILE = *BLANKS
     C                   Z-ADD     @DSTPG        PAGE#
 1x  C                   ELSE
     C                   CALL      'SPYCSDST'    PLDST                          Get Dst Page
 1e  C                   ENDIF
     C                   ENDSR
     *================================================================
     C     PLDST         PLIST
     C                   PARM                    @FILE                          Pfile
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    @SETKY                         Pg   (or)
     C                   PARM                    @SCROL                         Scroll pct
     C                   PARM                    @DSTPG            7 0          Page elemnt#
     C                   PARM                    @TOTPG            9 0          Pgs per Seg
     C                   PARM      0             PAGE#                          Rtn page#
     C                   PARM      '00'          @RTN                           Rtn code
     C                   PARM      *BLANKS       MSGID                          Msg ID
     C                   PARM      *BLANKS       MSGDTA                         MsgDataFld
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRHNDX        BEGSR
     *          ----------------------------------------
     *          Get the next page satisfying the search
     *          ----------------------------------------
 1b  C                   SELECT
 1x  C                   WHEN      OPCODE = 'NDXNX'
     C                   MOVEL(P)  'NEXT'        @OPCOD
 1x  C                   WHEN      OPCODE = 'NDXN2'
     C                   MOVEL(P)  'NEXT2'       @OPCOD
 1x  C                   WHEN      OPCODE = 'NDXPV'
     C                   MOVEL(P)  'PREV'        @OPCOD
 1x  C                   WHEN      OPCODE = 'NDXP2'
     C                   MOVEL(P)  'PREV2'       @OPCOD
 1x  C                   WHEN      OPCODE = 'NDXCL'
     C                   MOVEL(P)  'CLEAR'       @OPCOD
 1e  C                   ENDSL
   
     C                   MOVEL(p)  FILE          @FILE                          parms into
     C                   MOVEL(p)  LIBR          HANDL                          Parm list
     C                   MOVEL(p)  SKey1         @SETKY                         Parm list
   
     C                   MOVEA     XBFR          BF
     C                   MOVEA     BF(1)         @PFILE
     C                   MOVEA     BF(11)        FRMRRC
     C                   MOVE      FRMRRC        FRMRR#
     C                   MOVEA     BF(20)        ARGLEC
     C                   MOVE      ARGLEC        ARGLEN
     C                   MOVEA     BF(23)        ARG
   
     C                   CALL      'SPYCSSNDX'   PLSNDX
   
     c                   callp     RtnStatus(@RTN:'SPYCSSNDX':File)
   
     C                   MOVE      'Y'           FNDDTA
   
 1b  C                   IF        # > 0
     C                   MULT      13            #
     C                   DIV       256           #
     C                   MVR                     REM
 2b  C                   IF        REM > 0
     C                   ADD       1             #
 2e  C                   ENDIF
 1e  C                   ENDIF
     * P.S. (JJF 1/19/99) The above undocumented code appears to
     *      compute # = zero or 14. (# from SPYCSSNDX is 0 or 1)
   
     C                   ENDSR
     *================================================================
     C     PLSNDX        PLIST
     C                   PARM                    @FILE                          @0000*
     C                   PARM                    @SETKY                         Spy00 start
     C                   PARM                    @PFILE           10            P0000 file
     C                   PARM                    HANDL            10            Folder
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    ARG             256            Search arg.
     C                   PARM                    ARGLEN            3 0          Arg length
     C                   PARM                    FRMRR#            9 0          From RR#
     C                   PARM      *BLANKS       DTS                            Rtn dta str
     C                   PARM      0             #                              Rtn # recs
     C                   PARM      '00'          @RTN                           Rtn code
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVPAG        BEGSR
     *          --------------------------------
     *          Get the SpyLink/Folder page data
     *          --------------------------------
     C                   MOVEL(P)  OPCODE        @OPCOD                         parms into
     C                   Z-ADD     #RRNPG        PAGE#                          parm list
     C                   MOVE      *BLANK        DSTTBL                         Dist TblFile
     C                   Z-ADD     0             RFIL#                          R/DARS FILE#
     C                   Z-ADD     0             ROFFS                          R/DARS SEGMENT
   
 1b  C                   IF        LNKPG = 'Y'                                  ------------
     C                   MOVEL(p)  SKey2         @SETKY                         Report Page
     C                   MOVE      KEY(39)       FORMS
   
     * handle converted report pages numbers
     c                   eval      LnkPgRqstDS = XBfr
 2b  c                   if        LnkRStrPgA <> *blanks and
     c                             LnkREndPgA <> *blanks
 3b  c                   if        LnkRepLoc = '4' or                           R/DARS OPTICAL
     c                             LnkRepLoc = '5' or                           R/DARS QDLS
     c                             LnkRepLoc = '6'                              IMAGEVIEW OPTIC
     c                   eval      ROffs = LnkRStrPg                            R/DARS Segment
     c                   eval      RFil# = LnkREndPg                            R/DARS File#
 3x  c                   else
     * convert distribution request
     c                   eval      DistPage = Page#
 4b  c                   if        1 = CvtFromDistPageNbr(@SetKy:
     c                                    sit_any_sub:*blanks:                  any subscribed
     c                                    LnkRStrPg:LnkREndPg:DistPage)
     c                   eval      Page# = DistPage
 4e  c                   endif
 3e  c                   endif
 2e  c                   endif
   
 1x  C                   ELSE
     C                   MOVEA     KEY(66)       @SETKY                         Report Page
     C                   MOVE      KEY(76)       FORMS
 1e  C                   ENDIF                                                  ------------
     ******---------
 1b  c                   if        PDFBufPrc() = TRUE
     c                   Eval      blnSendPDFOnly = TRUE
 LV  c                   Leavesr
 1e  c                   Endif
   
     C                   Z-ADD     0             #
 1b  C                   DO        *HIVAL
     *      If previous call didn't return the whole page
 2b  C                   IF        MORSCS = '1'
     C                   MOVEL(P)  'CNTOV'       @OPCOD                         Continue same p
 2x  C                   ELSE
 3b  C                   IF        @OPCOD <> 'READC'
     C                   MOVEL     'DTAOV'       @OPCOD                         WITH OVERLAY
 3e  C                   ENDIF
 2e  C                   ENDIF
   
     C                   CALL      'SPYPGRTV'    PLRETV                         Get Page
     C                   MOVE      ' '           MORSCS
   
 2b  C                   IF        @RTN = '30'                                  Terminal
 3b  C                   IF        # <> 0
     C                   MOVE      '00'          @RTN
 3x  C                   ELSE
     c                   eval      ErrTyp = 'E'
     c                   eval      ErrDes = @RTN+' '+RtvMsgSpy(MsgID:MsgDta)
 4b  c                   if        msgid <> ' '
     c                   eval      @opcod = 'QUIT'
     c                   CALL      'SPYPGRTV'    PLRETV                         Get Page
 4e  c                   endif
 3e  C                   ENDIF
     C                   MOVE      ' '           LNKPG
 1v  C                   LEAVE
 2e  C                   ENDIF
     * Log it
 2b  C                   IF        SDLOGT = 'Y'
 3b  C                   IF        FORMS = 'P'
     C                   MOVE      FORMS         DLTYPE
 3x  C                   ELSE
     C                   MOVE      'V'           DLTYPE
 3e  C                   ENDIF
     C                   MOVE      *BLANKS       DLSEG
     C                   MOVE      @SETKY        DLREP
     C                   Z-ADD     PAGE#         DLTPGS
     C                   EXSR      MAG901
 2e  C                   ENDIF
   
 2b  C                   IF        OPCODE = 'READC'
 3b  C                   IF        @RTN = '21'                                  Alt data str
     c                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = @RTN+' '+RtvMsgSpy(MsgID:MsgDta)
     C                   MOVE      '20'          @RTN
     C                   MOVE      RPTATR        SAVATR                         SAVE VALUES
 3e  C                   ENDIF
 1v  C                   LEAVE
 2e  C                   ENDIF
     *  If second request, make sure, that (if possible) not more than
     *  120 records get transferred.
 2b  C                   IF        # > 0
     C     #             ADD       #RTV          #1
 3b  C                   IF        # <= 120  and
     C                             #1 > 120  or
     C                             # > 120  and
     C                             #1 > 240  or
     C                             @RTN = '25'
 1v  C                   LEAVE
 3e  C                   ENDIF
 2e  C                   ENDIF
     *  Fill the DTS buffer with the current page data.
   
     C     #             ADD       1             #1
     C                   MOVEA     WTS           DTS(#1)
     C                   ADD       #RTV          #
   
     C                   MOVE      RPTATR        SAVATR                         SAVE VALUES
   
     *  If request was made to get the rest of data for the prv. request, get o
 2b  C                   IF        @OPCOD <> 'CONTIN'
     C                   ADD       1             PAGE#
 2e  C                   ENDIF
   
     *  If page is too long for one buffer, set flag to continue reading.
 2b  C                   IF        @RTN = '25'                                  Didn't fit in o
     C                   MOVE      '1'           MORSCS
 1v  C                   LEAVE
 2e  C                   ENDIF
   
 2b  C                   IF        @RTN = '20'                                  Warning
     c                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):@SetKy)
     C                   MOVE      ' '           LNKPG
 1v  C                   LEAVE
 2e  C                   ENDIF
 1e  C                   ENDDO
   
     C                   MOVE      SAVATR        RPTATR                         RESTORE VAL
     * /2149 (5/31/00) - Need to reset LNKPG if no more data to read
 1b  C                   IF        MORSCS <> '1'
     C                   MOVE      ' '           LNKPG
 1e  C                   ENDIF
     C                   ENDSR
     *================================================================
     C     PLRETV        PLIST
     C                   PARM                    @SETKY                         Spy00 start
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    PAGE#             7 0          Pg   (or)
     C                   PARM      0             RRN#              9 0          RRn in page
     C                   PARM      *BLANKS       WTS                            Rtn data
     C                   PARM      0             #RTV              9 0          Rtn # recs
     C                   PARM                    RPTATR           80            Rpt Attrs
     C                   PARM                    LNKPG                          Lnk get?
     C                   PARM                    LnkVal(1)                      Lnk Val 1
     C                   PARM                    LnkVal(2)                      Lnk Val 2
     C                   PARM                    LnkVal(3)                      Lnk Val 3
     C                   PARM                    LnkVal(4)                      Lnk Val 4
     C                   PARM                    LnkVal(5)                      Lnk Val 5
     C                   PARM                    LnkVal(6)                      Lnk Val 6
     C                   PARM                    LnkVal(7)                      Lnk Val 7
     C                   PARM      '00'          @RTN                           Rtn code
     C                   PARM      *BLANKS       MSGID             7            Msg ID
     C                   PARM      *BLANKS       MSGDTA          100            MsgDataFld
     C                   PARM                    RFIL#             9 0          FILE#
     C                   PARM                    ROFFS            11 0          SEGMENT OFFS
     C                   PARM                    FORMS             1            FORMS
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVAFP        BEGSR
     *          -----------------
     *          Get AFP Page Data
     *          -----------------
     C                   CLEAR                   @RTN
     C                   MOVEL(p)  LIBR          HANDL
     C                   MOVEL(p)  SKey1         @SETKY
   
 1b  C                   SELECT
 1x  C                   WHEN      OPCODE = 'AGTPG'  or
     C                             OPCODE = 'AGAPG'
 2b  C                   SELECT
 2x  C                   WHEN      KEY(11) <> *BLANK
     C                   EXSR      RTVDST
 3b  C                   IF        @RTN = '20'
     C                   MOVE      '30'          @RTN
     C                   MOVEL     'ERR1807'     MSGID
     C                   MOVEL(P)  @DSTPG        MSGDTA
 3x  C                   ELSE
     C                   Z-ADD     PAGE#         AFFRPG
     C                   Z-ADD     PAGE#         AFTOPG
 3e  C                   ENDIF
 2x  C                   WHEN      RRN#PG = '*DOCHDR'
     C                   Z-ADD     0             AFFRPG
     C                   Z-ADD     0             AFTOPG
 2x  C                   WHEN      RRN#PG = '*DOCFTR'
     C                   Z-ADD     -1            AFFRPG
     C                   Z-ADD     0             AFTOPG
 2x  C                   OTHER
     C                   MOVEL(p)  SKey4         AFPGWK
     C                   MOVE      AFPGWK        AFFRPG
     C                   MOVEA     KEY(40)       AFPGWK
     C                   MOVE      AFPGWK        AFTOPG
 2e  C                   ENDSL
   
 1x  C                   WHEN      OPCODE = 'AGTRD'
     C                   MOVEA     KEY(11)       AFRSCT
     C                   MOVEA     KEY(12)       AFRSCN
     C                   MOVEA     KEY(22)       AFRSCL
 1e  C                   ENDSL
   
     C                   MOVE      *BLANKS       AFPNOT
 1b  C                   IF        @RTN <> '30'
     C                   CALL      'SPYAFRTV'    PLARTV
     C                   Z-ADD     AFRTCT        ACOUNT
     C                   Z-ADD     AFRTSZ        ATOTSZ
     C                   Z-ADD     AFRTBL        ABUFLN
     C                   MOVEL     MSGDTA        AFPNOT
 1e  C                   ENDIF
   
 1b  C                   IF        @RTN = '00'
     C                   MOVE      'K'           ERRTYP
     C                   MOVE      *BLANKS       ERRDES
 1x  C                   ELSE
 2b  C                   IF        @RTN = '20'
     C                   MOVE      'W'           ERRTYP
 2x  C                   ELSE
     C                   MOVE      'E'           ERRTYP
 2e  C                   ENDIF
     c                   eval      ErrDes = RtvMsgSpy(MsgID:MsgDta)
 1e  C                   ENDIF
     C                   ENDSR
     *================================================================
     C     PLARTV        PLIST
     C                   PARM                    OPCODE
     C                   PARM                    HANDL
     C                   PARM                    @SETKY                         Spy00
     C                   PARM                    AFFRPG            7 0          From page
     C                   PARM                    AFTOPG            7 0          To page
     C                   PARM                    AFRSCT            1            Rsc type
     C                   PARM                    AFRSCN           10            Rsc name
     C                   PARM                    AFRSCL           10            Rsc lib
     C                   PARM                    AFRTSZ            9 0          Rtn obj size
     C                   PARM                    AFRTCT            9 0          Rtn pg/rsc c
     C                   PARM                    AFRTBL            5 0          Rtn buf len
     C                   PARM                    SDT                            Rtn data
     C                   PARM                    @RTN                           Rtn code
     C                   PARM                    MSGID                          Msg ID
     C                   PARM                    MSGDTA                         MsgDataFld
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     c     $Notes        begsr
     * Notes processing (Handle notes data buffers)
   
 1b  c                   dou       NtRqs <> 'Y'                                 Done
     c                   exsr      CalNot
   
     * notes data buffer processing
 2b  c                   if        NtRqs = 'Y'                                  Note Data buffe
 3b  c                   if        @Parms < 9 or CLrecv = *null                 read callback
 1v  c                   leave                                                  not available
 3e  c                   endif
     c                   eval      rc = CLRecvData(%addr(NOTREQ):%size(NOTREQ)) comm layer rece
 3b  c                   if        rc < 0                                       Error
     c                   MOVE      'N'           NTRQS
     c                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):'SPYCSNOT')
 1v  c                   leave
 3e  c                   endif
     c                   EXSR      LODWRK                                       FILE, LIBR, ...
     c                   eval      OPCDE = *blanks
 2e  c                   endif
   
 1e  c                   enddo
   
     c                   endsr
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALNOT        BEGSR
     * Add or Get notes for pages of reports
   
     C                   MOVEL(p)  LIBR          HANDL
     C                   MOVEL(p)  FILE          @FILE
     C                   MOVEL(p)  'SPYCS'       @LIBR
     C                   MOVEL(p)  OPCODE        NTCODE
     C                   CLEAR                   NOTE#
     C                   CLEAR                   TIFPG#
     C                   Z-ADD     0             NOTREC
     C                   Z-ADD     0             ENDPAG                         END Page#
     c                   eval      RevIDn = 0                                   Revision ID
     c                   eval      ndStartPos = 0                               data start pos
     c                   eval      ndDataLen  = 0                               data length
   
 1b  C                   SELECT
 1x  C                   WHEN      OPCODE = 'LSTNT'
     C                   MOVEL     XBFR          ALF9
     C                   TESTN                   ALF9                 88
     C   88              MOVE      ALF9          ENDPAG                         end page range
 1x  C                   OTHER
 2b  C                   IF        NTRQS <> 'Y'                                 LITTLE BUFFER
     C                   MOVEL     XBFR          NLDS                           NOTE LIST DS
 2e  C                   ENDIF
     C                   MOVE      NLPAGN        TIFPG#                         PAGE#
 2b  C                   IF        OPCODE <> 'WRTNT'
     C                   MOVE      NLNOTN        NOTE#                          NOTE NUMBER
 2e  C                   ENDIF
 1e  C                   ENDSL
   
 1b  C                   IF        NTRQS <> 'Y'                                 LITTLE BUFFER
     C                   MOVE      *BLANKS       SDT
     C                   MOVEA     XBFR          SDT
     c                   movea     bf(129)       Segmnt
     c                   eval      RevIDn = 0
 1e  C                   ENDIF
   
 1b  c                   if        sMajMinVer <> *blanks
 2b  c                   if        sKey1 <> *blanks
     c                   move      SKey1         RevIDn                         Revision ID
 2e  c                   endif
     c                   eval      HeadRevID = GetHedBy_RevID(RevIDn)
     c                   eval      WipRevID = GetWIPBy_RevID(RevIDn)
   
 2b  c                   if        RevIDn = HeadRevID
 3b  c                   if        WipRevID > 0
     c                   eval      RevIDn = WipRevID
 3e  c                   endif
 2e  c                   endif
 2b  c                   if        RevIDn = 0
 3b  c                   if        RRN#PG = ' '
     c                   move      nlpagn        RRN#PG
 4b  c                   if        RRN#PG = ' '
     c                   eval      RRN#PG = *all'9'
 4e  c                   endif
 3e  c                   endif
     c                   eval      RevIDn=GetHedBy_ConID(@File + RRN#PG)
     c                   eval      WipRevID = GetWIPBy_RevID(RevIDn)
 3b  c                   if        WipRevID > RevIDn
     c                   eval      RevIDn = WipRevID
 3e  c                   endif
 2e  c                   endif
   
 2b  c                   if        sKey2 <> *blanks
     c                              and OpCode = 'GETNT'
     c                   move      SKey2         ndStartPos                     data start pos
 2e  c                   endif
 2b  c                   if        sKey3 <> *blanks
     c                              and ( OpCode = 'GETNT' or
     c                                    OpCode = 'APDNT' )
     c                   move      SKey3         ndDataLen                      data length
 2e  c                   endif
   
 1e  C                   ENDIF
   
     c                   eval      errid = ' '
     c                   eval      errdta = ' '
 1b  c                   if        @FILE = 'B         ' and RevIDn <> 0
     c                   eval      @FILE = GetContID(RevIDn)
 1e  c                   endif
     C                   MOVE      *BLANKS       @ERCON
     C                   CALL      'SPYCSNOT'    plCSNOT                50
     C                   MOVE      *BLANKS       RTNDES
   
     * SWITCH BUFFER OR CONVERSION MODE
 1b  C                   SELECT
 1x  C                   WHEN      OPCODE = 'WRTNT'  or                         WRITE NOTE/ANNO
     c                             OPCODE = 'APDNT'                             Append NOTE/ANN
 2b  C                   IF        NOTREC > 0                                   MORE DATA TO RE
     C                   MOVE      'Y'           NTRQS                          BIG BUFFER
     C                   MOVE      'NORESP'      OPCDE                          SEND NO RESPONS
 2x  C                   ELSE
     C                   MOVE      'N'           NTRQS                          LITTLE BUFFER
     C                   MOVEA     SDT           RTNDES
 2e  C                   ENDIF
 1x  C                   WHEN      OPCODE = 'UPDNT'  and                        UPDATE NOTE/ANN
     C                             @RTN = '00'                                  MORE DATA TO SE
     C                   MOVEA     SDT           RTNDES
 1x  C                   WHEN      OPCODE = 'LSTNT'  and                        LIST NOTES/ANNO
     C                             @RTN = '00'  or                              MORE DATA TO SE
     C                             OPCODE = 'GETNT'  and                        GET NOTE/ANNOTA
     C                             @RTN = '00'                                  MORE DATA TO SE
     C                   MOVEL     'CONTPG'      OPCDE                          KEEP SENDING
 1e  C                   ENDSL
   
 1b  C                   SELECT
 1x  C                   WHEN      @RTN = '00'                                  Complete
     C                   MOVE      'K'           ERRTYP                         OK
     C                   MOVEL     RTNDES        ERRDES
 1x  C                   WHEN      @RTN = '20'                                  Warning
     C                   MOVE      'W'           ERRTYP                         error
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):@File)
 1x  C                   WHEN      @RTN = '25'                                  insuffent
     C                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(7):' ')
 1x  C                   WHEN      @RTN = '30'
     C                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):'SPYCSNOT')
 1e  C                   ENDSL
   
 1b  c                   if        errid <> ' '
     C                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = '  ' + RtvMsgSpy(errid:errdta)
 1e  c                   endif
 1b  c                   if        @RTN <= '20'
     c                   MOVE      NOTREC        ERRDES                         # of bytes
 1e  c                   endif
   
     C     endcalnot     ENDSR
     *================================================================
     C     plCSNOT       PLIST
     C                   PARM                    @FILE                          Spy000*
     C                   PARM                    SEGMNT           10            Dst pgtbl nm
     C                   PARM                    HANDL                          Window Handl
     C                   PARM                    @LIBR                          Spy00 Libr
     C                   PARM                    NTCODE            5            Opcode
     C                   PARM                    #RRNPG                         RRN/Page#
     C                   PARM                    NOTE#             9 0          Note #
     C                   PARM                    TIFPG#            9 0          Tiff/Cvt page#
     C                   PARM                    SDT                            Return data
     C                   PARM                    NOTREC            9 0          Rtn # of rec
     C                   PARM      '00'          @RTN                           Return code
     C                   PARM                    NOTLR             1            Shutdown
     C                   PARM                    NEWNOT            1            New Note
     C                   PARM                    ENDPAG            9 0          Ending Page #
     C                   PARM                    A01               1            NOTE TYPE
     c                   PARM                    RevIDn            9 0          Revision id
     c                   parm                    dcode             9 0
     c                   parm                    dtype             9 0
     c                   parm                    errid             7
     c                   parm                    errdta           80
     c                   parm                    ndStartPos                     data start pos
     c                   parm                    ndDataLen                      data length
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     c     $Templates    begsr
     * Annotation Template processing (Handle notes data buffers)
   
 1b  c                   dou       NtRqs <> 'Y'                                 Done
     c                   exsr      CalATM
   
     * notes data buffer processing
 2b  c                   if        NtRqs = 'Y'                                  Note Data buffe
 3b  c                   if        @Parms < 9 or CLrecv = *null                 read callback
 1v  c                   leave                                                  not available
 3e  c                   endif
     c                   eval      rc = CLRecvData(%addr(NOTREQ):%size(NOTREQ)) comm layer rece
 3b  c                   if        rc < 0                                       Error
     c                   MOVE      'N'           NTRQS
     c                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):'SPYCSATM')
 1v  c                   leave
 3e  c                   endif
     c                   EXSR      LODWRK                                       FILE, LIBR, ...
     c                   eval      OPCDE = *blanks
 2e  c                   endif
   
 1e  c                   enddo
   
     c                   endsr
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALATM        BEGSR
     *          ----------------------
     *          Call SPYCSATM
     *          ----------------------
     C                   MOVEL(P)  OPCODE        @OPCOD                         Place entry
   
 1b  C                   IF        NTRQS <> 'Y'                                 LITTLE BUFFER
     C                   MOVE      *BLANKS       SDT
     C                   MOVEA     XBFR          SDT
 1e  C                   ENDIF
   
     C                   MOVE      *BLANKS       @ERCON
     C                   CALL      'SPYCSATM'    PLATM                  50
   
     C                   MOVE      *BLANKS       RTNDES
   
     * SWITCH BUFFER OR CONVERSION MODE
 1b  C                   SELECT
 1x  C                   WHEN      OPCODE = 'WRTTM'                             WRITE ATM
 2b  C                   IF        @RTNRC > 0                                   MORE DATA TO RE
     C                   MOVE      'Y'           NTRQS                          BIG BUFFER
     C                   MOVE      'NORESP'      OPCDE                          SEND NO RESPONS
 2x  C                   ELSE
     C                   MOVE      'N'           NTRQS                          LITTLE BUFFER
     C                   MOVEA     SDT           RTNDES
 2e  C                   ENDIF
 1x  C                   WHEN      OPCODE = 'LSTTN'  and                        LIST ATMS
     C                             @RTN = '00'  or                              MORE DATA TO SE
     C                             OPCODE = 'GETTM'  and                        GET ATM
     C                             @RTN = '00'                                  MORE DATA TO SE
     C                   MOVEL     'CONTPG'      OPCDE                          KEEP SENDING
 1e  C                   ENDSL
   
 1b  C                   SELECT
 1x  C                   WHEN      @RTN = '00'                                  NO ERROR
     C                   MOVE      'K'           ERRTYP                         OK
     C                   MOVEL     RTNDES        ERRDES
 1x  C                   WHEN      @RTN = '20'                                  End of file
     C                   MOVE      'W'           ERRTYP                         Warning
     c                   eval      ErrDes = RtvMsgSpy(MsgE(1):' ')
 1x  C                   WHEN      @RTN = '25'                                  insuffent
     C                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(8):' ')
 1x  C                   WHEN      @RTN = '30'
     C                   MOVE      'E'           ERRTYP
     c                   eval      ErrDes = RtvMsgSpy(MsgE(2):'SPYCSATM')
 1e  C                   ENDSL
   
     C                   ENDSR
     *================================================================
     C     PLATM         PLIST
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    SKEY                           KEY
     C                   PARM                    SDT                            DATA BUFFER
     C                   PARM      0             @RTNRC                         Rtn # recs
     C                   PARM      '00'          @RTN                           Return code
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALPCL        BEGSR
     * get PCL report by page range
   
     C                   MOVEL(P)  OPCODE        @OPCOD                         Place entry
   
     C                   MOVE      RRN#PG        pPAGFRM                        PAGE FROM
     c                   eval      test9a = xbfr
     c                   testn                   test9a               68
 1b  c                   if        *in68
     C                   MOVEL     XBFR          pPAGTO                         PAGE TO
 1e  c                   endif
     c                   eval      uPagFrm = pPagFrm                            Page From
     c                   eval      uPagTo  = pPagTo                             Page To
     c                   eval      KeyData = %subst(XBFR:10)
   
     c                   eval      LastPos = 0
     c                   clear                   TFileData
     c                   eval      SplSpyNum = SKey1
   
     * If a segment page mapping is requested...otherwise process pcl operations.
 1b  c                   if        opcode = 'PGMAP'
     c                   callp     mapPCLSegPgs(xbfr)
 1x  c                   else
     c                   CALL      'BLDPCLPGS'   PBLDPCL                50
 1e  c                   endif
   
     * check return message
     c     x'00'         scan      RMsgID0       np                       88
     c   88              eval      %subst(RMsgID0:np) = *blanks
     c     x'00'         scan      RMsgDta0      np                       88
     c   88              eval      %subst(RMsgDta0:np) = *blanks
   
     * response status
 1b  c                   select
 1x  c                   when      RmsgID0 <> *blanks or *in50
     c                   eval      @RTN  = '30'
 1x  c                   other
     c                   eval      @RTN  = '20'                                 End of File
     c                   eval      OPCDE = 'NORESP'
 1e  c                   endsl
     c                   callp     RtnStatus(@RTN:'BLDPCLPGS':'PCLREPORT':
     c                                                        RMsgID0:RMsgDta0)
   
     C                   ENDSR
     *================================================================
     c     PBLDPCL       plist
     c                   parm                    @OPCOD                         Opcode
     c                   parm                    uPAGFRM                        PAGE FROM
     c                   parm                    uPAGTO                         PAGE TO
     c                   parm                    TFileData
     c                   parm                    ALSend                         App layer callb
     c                   parm                    KeyData        1000
     c                   parm      x'00'         RMsgID0           8            Return Msg
     c                   parm      x'00'         RMsgDta0        101            Retn Msg Dta
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CvtPDF        BEGSR
     *          ----------------------
     *          Call MCPDFCVTR
     *          ----------------------
     C                   MOVEL(P)  OPCODE        @OPCOD                         Place entry
   
     C                   MOVE      RRN#PG        PAGFRM                         PAGE FROM
     C                   MOVEL     XBFR          PAGTO                          PAGE TO
     * load parm structures
     c                   clear                   SpyLinkDS
     c                   subst     XBFR:10       SLpartial                      partial spylink
     c                   move      SLpartial     SpyLinkDS
     C                   eval      RDstSegDS = %subst(XBFR:272)
   
     C                   MOVE      *BLANKS       @ERCON
     C                   MOVE      *BLANKS       @ERDTA
     C                   CALL      'MCPDFCVTR'   PLPDFCvt               50
   
     *   RETURN NUMBER OF BYTES IN BUFFER
 1b  C                   IF        @RTN = '00'  or                              NO ERROR
     C                             @RTN = '20'                                  WARNING
     C                   Z-ADD     BYTRTN        ABUFLN
 1e  C                   ENDIF
   
 1b  C                   IF        @RTN = '00'
 2b  C                   IF        OPCODE = 'READ'
     C                   MOVEL     'CONTPG'      OPCDE                          KEEP SENDING
 2e  C                   ENDIF
 1e  C                   ENDIF
     c                   callp     RtnStatus(@RTN:'MCPDFCVTR':@SETKY:
     c                                                        @ERCON:@ERDTA)
 1b  c                   if        @RTN <= '20'
     c                   MOVE      BYTRTN        ERRDES
 1e  c                   endif
   
     C                   ENDSR
     *================================================================
     C     PLPDFCvt      PLIST
     C                   PARM                    @OPCOD                         Opcode
     C                   PARM                    HANDL                          Window Handl
     C                   PARM      SKEY1         @SETKY                         Spy000*
     C                   PARM                    PAGFRM            9 0          PAGE FROM
     C                   PARM                    PAGTO             9 0          PAGE TO
     C                   PARM      7680          BYTRQS            9 0          BYTES REQUESTED
     C                   PARM                    BYTRTN            9 0          BYTES RETURNED
     C                   PARM                    SDT                            Return data
     C                   PARM      '00'          @RTN                           Return code
     C                   PARM                    @ERCON                         Return Msg
     C                   PARM                    @ERDTA                         Retn Msg Dta
     c                   parm                    SpyLinkDS       768            SpyLink DS
     c                   parm                    RDstSegDS       127            Dist Seg DS
     c                   parm                    Forms                          text forms: P o
     C                   PARM                    WEBAPP                         Web App
     C                   PARM                    WEBUSR                         Web User
   
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PRTRPT        BEGSR
     *          ---------------------
     *          Print Report
     *          ---------------------
     C                   MOVEL(p)  SKey4         @JOBNA
     C                   MOVEA     KEY(41)       @USRNA
     C                   MOVEA     KEY(51)       @JOBNU
     C                   MOVEA     KEY(57)       TEMP9
     C                   MOVE      TEMP9         @FILN#
     C                   MOVEA     KEY(66)       @SPY00
   
     C                   MOVEA     XBFR          BF
     C                   MOVEA     BF(1)         TEMP9
     C                   MOVE      TEMP9         FRMPAG
     C                   MOVEA     BF(10)        TEMP9
     C                   MOVE      TEMP9         TOPAGE
     C                   MOVEA     BF(69)        WSBM
   
     * if this is an email command then change prt device to "EMAIL"
     *  and load the LDA with the email information
 1b  c                   if        OpCode = 'EMAIL'
     c                   eval      wPrt = Opcode
     c                   exsr      LoadLDA
 2b                      If ( LogEml = YES );
                           Callp(e) EMLIO_NewLog();
                           Callp(e) EMLIO_SetLogHdr(
                                      %trimr(mlFrm)
                                    : %trimr(mlSubj)
                                    : %trimr(mlTxta)
                                    : wqjobn
                                    : pgmusr
                                    : jobnum
                                    : ELMSTS_SENT);
 2e                      Endif;
   
 1x  c                   else
     C                   MOVEA     BF(19)        WPRT
     C                   MOVEA     BF(29)        OUTQ
     C                   MOVEA     BF(39)        OUTQL
     C                   MOVEA     BF(49)        WP
     C                   MOVEA     BF(59)        WPL
 1e  c                   endif
   
     C                   Z-ADD     1             COPIES
   
 1b  C                   IF        OUTQ1 = ' '                                  If 1st char
     C                   MOVE      *BLANKS       OUTQ#                          of OUTQ#
 1e  C                   ENDIF                                                  blank
   
 1b  C                   IF        OUTQ# = *BLANKS  and
     C                             WP = *BLANKS  and
     C                             WPRT = *BLANKS
     C                   MOVEL     '*USRPRF'     OUTQ#                          Default
 1e  C                   ENDIF
   
     * Email images.
 1b  c                   if        rqopcd = 'EMAIL' and %subst(skey4:36:1) = 'B'
     c                   callp     emailImage
 LV  c                   leavesr
 1e  c                   endif
   
     c                   eval      qualFolder = skey1 + skey2
     c                   CALL      'MCDDPCPP'    PL801                          Print report
     C     PL801         PLIST
     C                   PARM                    @SPY00           10
     C                   PARM                    JOB#
     c                   parm      *zeros        datfo             7
     C                   PARM                    @FILN#
     C                   PARM                    OUTQ#            20
     C                   PARM                    COPIES            3 0
     C                   PARM                    CALLER           10
     C                   PARM                    FRMPAG            9 0          Extended
     C                   PARM                    TOPAGE            9 0          Parms for
     C                   PARM                    WPRT             10            Client Servr
     C                   PARM                    WP               10            Printing
     C                   PARM                    WPL              10
     C                   PARM                    WSBM              1
     C                   PARM                    DSTTBL                         Dist table
     c                   parm                    qualFolder       20
     c                   parm      '4'           operation         1
     C                   ENDSR
     *-------------------------------------------------------------------------
     *-  LoadLDA - Load LDA with Email parameters
     *-------------------------------------------------------------------------
     c     LoadLDA       Begsr
   
     c                   In        LDA
   
     * format the buffer based on the version of the structure
 1b  c                   Select
   
     * extra buffer structure version 0
 1x  c                   when      xbf_vers = '00000'
     c                   eval      mlind = '*EMAIL'
     * get from address if it is blank
 2b  c                   if        xbf_frmeml = *blanks or
     c                             xbf_frmeml = '*CURRENT'
     c                   eval      Xbf_frmeml = GetUsrAddr
 2x  c                   else
     c                   eval      mlfrm = xbf_frmeml
 2e  c                   endif
   
     c                   eval      mlsubj = xbf_subj
     c                   eval      mltxta = xbf_msgtxt
     c                   eval      mlto = xbf_dsteml
     c                   eval      mlfmt = xbf_fmt
     c                   eval      mltype = 'E'
     * special parms for Spoolmail
 2b  c                   If        ( isSplMail = TRUE )
     c                   eval      mlind = ' '
     c                   eval      mlspml = 'S'
 2e  c                   endif
   
 1e  c                   endsl
   
     c                   Out       LDA
   
     c                   Endsr
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QRYFLT        BEGSR
     *          ----------------------
     *          Do Query Filter Opcodes
     *          ----------------------
 1b  C                   SELECT
   
 1x  C                   WHEN      OPCODE = 'SET'                               Set Filter
     C                   MOVEA     SDT(1)        QRYAO                          AND/OR
     C                   MOVEA     SDT(61)       QRYFN                          Field Name
     C                   MOVEA     SDT(261)      QRYTE                          Test
     C                   MOVEA     SDT(361)      QRYVL                          Value
     C                   MOVEA     SDT(961)      QRYTYP                         Query Type S=Se
     C     10            SUBST     SKEY:1        QRYRTY                         ReportType/Omni
     C     10            SUBST     SKEY:11       QRYOBT                         Object Type *SP
     C     5             SUBST     SKEY:21       F5A                            Offline Sequenc
 2b  C                   IF        F5A = *BLANKS
     C                   CLEAR                   QRYOFF
 2x  C                   ELSE
     C                   MOVEL     F5A           QRYOFF
 2e  C                   ENDIF
     *    Move Query Parms to arrays
     C                   MOVEA     QRYAO         AO
     C                   MOVEA     QRYFN         FN                             Index Name
     C                   MOVEA     QRYTE         TE                             Test
     C                   MOVEA     QRYVL         QV                             Value
     C                   MOVEL     *BLANKS       QVF                            Value SAVE
     *    Check the filter and return error line
     C                   CALL      'SPYCSQRY'                           50
     C                   PARM                    QRYRTY           10            Rep Type
     C                   PARM                    QRYOBT           10            OBJ Type
     C                   PARM                    QRYOFF            5 0          Opt Seq.
     C                   PARM                    AO                             And/Or
     C                   PARM                    FN                             Index Name
     C                   PARM                    TE                             Test
     C                   PARM                    QV                             Value
     C                   PARM                    QVF                            Value Formatted
     C                   PARM                    QRYOPC           10            OpCode
     C                   PARM                    QRYMSG            7            Msg ID
     C                   PARM                    QRYLIN            3 0          Error Line
     C                   PARM                    QRYFLD           10            Error Field
   
 2b  C                   IF        QRYMSG <> *BLANKS
     C                   CLEAR                   AO                             And/Or
     C                   CLEAR                   FN                             Index Name
     C                   CLEAR                   TE                             Test
     C                   CLEAR                   QV                             Value
     C                   CLEAR                   QVF                            Value Formatted
     C                   MOVE      QRYLIN        F3A                            CAT LINE TO MES
     c                   eval      ErrTyp = 'W'
     c                   eval      ErrDes = F3A + RtvMsgSpy(QryMsg:QryFld)
     C                   MOVE      '20'          @RTN                           WARNING
 2e  C                   ENDIF
   
 1x  C                   WHEN      OPCODE = 'CLEAR'                             Clear Filter
     C                   CLEAR                   QRYAO                          AND/OR
     C                   CLEAR                   QRYFN                          Field Name
     C                   CLEAR                   QRYTE                          Test
     C                   CLEAR                   QRYVL                          Value
     C                   CLEAR                   QRYTYP                         Query Type S=Se
     C                   CLEAR                   AO                             And/Or
     C                   CLEAR                   FN                             Index Name
     C                   CLEAR                   TE                             Test
     C                   CLEAR                   QV                             Value
     C                   CLEAR                   QVF                            Value Formatted
     C                   CLEAR                   QRYRTY                         ReportType/Omni
     C                   CLEAR                   QRYOBT                         Object Type *SP
 1e  C                   ENDSL
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SYSENV        BEGSR
     *          ----------------------
     *          Do Environment Opcodes
     *          ----------------------
 1b  C                   IF        OPCODE = 'READ'                              READ
     C                   IN        SYSDFT                                       Defaults
   
     * SYSDFT date format can be 'JOB', so call MAG8090 to resolve it
     * and put back into the SYSDFT structure.
     C                   CALL      'MAG8090'
     C                   PARM                    DATFMT            3
     C                   PARM                    DATSEP            1
     C                   PARM                    TIMSEP            1
   
     C                   MOVE      DATFMT        SDATFM
   
     C                   MOVEA(P)  SYSDFT        SDT
     C                   Z-ADD     1025          @S
     C                   MOVE      DATSEP        SDT(@S)
     C                   Z-ADD     1026          @S
     C                   MOVE      TIMSEP        SDT(@S)
 1e  C                   ENDIF
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MAG901        BEGSR
     *          Call Mag901 to log activity to RDstLog
     *          when significant fields change.
   
 1b  C                   IF        DLREP <> DXREP  or
     C                             DLTYPE <> DXTYPE  or
     C                             DLREPT <> DXREPT  or
     C                             DLSUBS <> DXSUBS  or
     C                             DLSEG <> DXSEG
   
     C                   CALL      'MAG901'
     C                   PARM                    RTN
     C                   PARM                    DLSUBS           10
     C                   PARM      *blanks       DLREPT           10
     C                   PARM                    DLSEG            10
     C                   PARM                    DLREP            10
     C                   PARM                    DLBNDL           10
     C                   PARM                    DLTYPE            1
     C                   PARM                    DLTPGS            9 0
     C                   PARM      'SPYCS'       CALPGM           10
     C                   PARM      WEBAPP        DLWEBA           10
     C                   PARM      WEBUSR        DLWEBU           20
   
     C                   MOVE      DLREP         DXREP
     C                   MOVE      DLTYPE        DXTYPE
     C                   MOVE      DLREPT        DXREPT
     C                   MOVE      DLSUBS        DXSUBS
     C                   MOVE      DLSEG         DXSEG
 1e  C                   ENDIF
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RCVMSG        BEGSR
     *          -------------------------
     *          Get Non-Program Message
     *          -------------------------
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
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
   
     * Force key code checking on startup.
     c                   eval      ar_ind = '0'
     * Save SpyWeb parms
     c                   eval      swWEBAPP = WEBAPP                            Web App
     c                   eval      swWEBUSR = WEBUSR                            Web User
     c                   OUT       SPYWEB                                       RELEASE AFTER C
   
     C                   IN        SYSDFT                                       Defaults
     * Chg RunPty
 1b  C                   IF        SCSPTY <> *BLANKS
     C                   CALL      'SPYCHGRP'
     C                   PARM                    SCSPTY
 1e  C                   ENDIF
     * Login WebUser
 1b  C                   IF        WEBUSR <> *BLANKS  and
     C                             LOGWEB = 'Y'
     C                   MOVE      'I'           WBTYPE
     C                   CALL      'MAG901W'     PL901W
     C     PL901W        PLIST
     C                   PARM                    WEBAPP                         Web App
     C                   PARM                    WEBUSR                         Web User
     C                   PARM      WEBIP         WEBADR           17            Tcp/ip addr
     C                   PARM                    PGMUSR                         User profile
     C                   PARM                    WBTYPE            1            In/Out
     C                   PARM                    RTN901            7            Rtn code
 1e  C                   ENDIF
   
 1b  C                   IF        LDEBUG = 'Y'
     C                   MOVE      'N'           SETDBG
 1e  C                   ENDIF
   
 1b  C                   IF        SETDBG <> 'Y'
 GO  C                   GOTO      NODBG                                        Set debug
 1e  C                   ENDIF
   
     c                   eval      CLCMD = 'CRTMSGQ MSGQ(QGPL/Q9)'
     C                   CALL      'MAG1030'
     C                   PARM                    RTN
     C                   PARM      'QGPL'        #LIBR
     C                   PARM      'Q9'          #OBJ
     C                   PARM      '*MSGQ'       APITYP
     C                   PARM                    CLCMD
     C                   MOVEL(P)  #SPYM9        @MSGQ
   
     C                   EXSR      RCVMSG
     C                   CALL      DBGPGM
     *>>>>>>>>>>
     C     NODBG         TAG
     c                   callp     DMSinit
     c                   callp     LnkHitList('INIT')
     c                   callp     OmniHitList('INIT')
     C                   EXSR      CLNUP
   
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLSPGM        BEGSR
     *          Close Programs
   
     C                   MOVEL(P)  'QUIT'        @OPCOD                         Unload Pgm
   
     c                   CALL      'SPYCSATM'    PLATM                          ATM
     C                   CALL      'SPYCSFLD'    PLFLD                          Fld list
     C                   CALL      'SPYCSRPT'    PLRPT                          Rpt List
     C                   CALL      'SPYCSBCH'    PLBCH                          Bch List
     C                   CALL      'SPYCSNDX'    PLNDX                          Ndx List
     C                   CALL      'SPYPGRTV'    PLRETV                         Pg Rtv
     C                   CALL      'SPYCSSEG'    PLHST                          Seg Rtv
     C                   CALL      'SPYCSDST'    PLDST                          Dst Rtv
     C                   CALL      'SPYCSOMN'    PLOMN                          Omn list
     C                   CALL      'SPYAFRTV'    PLARTV                         AFP Rsc
     C                   CALL      'SPYCSOLNK'   PLOFF                          Get Offlnks
     C                   CALL      'SPYCSBCNT'   PLBCNT                         Get Bcnt
     C                   CALL      'SPYCSLRMNT'  PLLNK                          Get Spy list
     C                   CALL      'SPYCSLCRI'   PLCRI                          Lnk Criteria
     C                   CALL      'SPYCSHCRI'   PHCRI                          Omni Criteria
     C                   CALL      'SPYCSSNDX'   PLSNDX                         Search ndx
     c                   callp     LnkHitList('QUIT')
     c                   callp     OmniHitList('QUIT')
     c                   callp     OmniRepTypes('QUIT')
     c                   callp     OverlayOps('QUIT')
     C                   MOVE      'Y'           NOTLR
     C                   CALL      'SPYCSNOT'    plCSNOT
     c                   eval      ErrDes = RtvMsgSpy('Q':' ')
     * Logout WebUser
 1b  C                   IF        WEBUSR <> *BLANKS  and
     C                             LOGWEB = 'Y'
     C                   MOVE      'O'           WBTYPE                         (O)ut
     C                   CALL      'MAG901W'     PL901W
 1e  C                   ENDIF
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODWRK        BEGSR
     *          Load DS fields to Wrk fields (from entry parm).
   
 1b  C                   IF        NTRQS <> 'Y'
     C                   MOVE      RQFILE        FILE                           Reg Request
     C                   MOVE      RQLIBR        LIBR
     C                   MOVE      RQOPCD        OPCODE
     C                   MOVE      RQR#PG        RRN#PG
     C                   MOVE      RQSKEY        SKEY
     C                   MOVEL(p)  RQXBFR        XBFR
 1x  C                   ELSE
     C                   MOVE      NQFILE        FILE                           Note Request
     C                   MOVE      NQLIBR        LIBR
     C                   MOVE      NQOPCD        OPCODE
     C                   MOVE      NQR#PG        RRN#PG
     C                   MOVE      NQRECS        WRECS
     C                   MOVEL(p)  NQSDT         SDTds
 1e  C                   ENDIF
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODDS         BEGSR
     *          Load WRK fields to DS fields (to be returned in BUF)
   
 1b  C                   SELECT
 1x  C                   WHEN      FILE = '*AFPDS'  or
     C                             FILE = @PCL  or
     C                             FILE = @PDF
     C                   MOVE      ERRTYP        RRERTY                         AFP Response
     C                   MOVEL     ERRDES        ARERDS
     C                   MOVEA     SDT           RRSDT
 1x  C                   WHEN      NTRQS = 'Y'
     C                   MOVE      ERRTYP        NRERTY                         NoteResponse
     C                   MOVE      ERRDES        NRERDS
 1x  C                   OTHER
     C                   MOVE      ERRTYP        RRERTY                         Reg Response
     C                   MOVE      ERRDES        RRERDS
     C                   MOVEA     SDT           RRSDT
 1e  C                   ENDSL
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $INIT         BEGSR
     C                   RETURN
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $QUIT         BEGSR
   
     c                   callp     managePDFHandles(MPH_QUIT)
   
     * REMOVE USER FROM LICENSE TRACKING FILE.
     C                   CALLP     SPYAUT(PRD#:AR_IND:AR_MSGID:AR_MDTA:'1')
     C                   CALLP     SPYAUT(9:AR_IND:AR_MSGID:AR_MDTA:'1')
   
     * REMOVE node entry from SPYCS data queue.
     * (QKEY value set in CLNUP routine at startup)
     c                   CALL      'QRCVDTAQ'    PLRCVQ                 81
   
     C                   EXSR      CLSPGM
     c                   callp     DMSquit
 1b    if %open(mrptdir7);
         close mrptdir7;
 1e    endif;
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLNUP         BEGSR
     *          Cleanup  ghost jobs from prior crashes
   
     *************  NodeId is now blank  *************
   
     *    QRcvDtaQ Parms:
     *    Parm  Name   Size  Description
     *    ----  -----  ----  ----------------------------------------
     *     1    QName    10  Name of Queue         ='SPYCS'
     *     2    QLib     10  Library of Queue      =LPGMLB
     *     3    QDtaSz   5.0 Length of Data field  =10
     *     4    QDta    128  Field containing data
     *     5    QWait    5.0 Wait time in seconds  = 0
     *     6    QOrder   2   Logical operand       =EQ
     *     7    QKeySz   3.0 Length of key         =27
     *     8    QKey     27  Key value (NodeID+RunMode)
     *     9    QSndLn   3.0 Sender length         =44
     *    10    QSndr    44  Sender id (see data str)
   
     C     NODEID        CAT       RUNMOD        QKEY
   
     C                   CALL      'QRCVDTAQ'    PLRCVQ                 81
     *                                                     Rcv (Clear)
 1b  C                   DOW       QDTASZ > 0  and
     C                             NOT *IN81
     C                   CALL      'SPYENDJB'                                    Kill ghost
     C                   PARM                    QJNAM                            SpyCS
     C                   PARM                    QUSER                            ENDJOB
     C                   PARM                    QJ#
     *                                                     Rcv (Clear)
     C                   CALL      'QRCVDTAQ'    PLRCVQ                 81
 1e  C                   ENDDO
   
     C                   CALL      'QSNDDTAQ'    PLSNDQ                          Track new
     C                   ENDSR                                                   job
     *================================================================
     * Send data que
     C     PLSNDQ        PLIST
     C                   PARM      'SPYCS'       QNAME                          Que name
     C                   PARM      '*LIBL'       QLIB                           Que library
     C                   PARM      10            QDTASZ                         Data length
     C                   PARM      'SPYCS'       QDTA                           Data
     C                   PARM      27            QKEYSZ                         Key length
     C                   PARM                    QKEY             27            Key
     * Rcv data que
     C     PLRCVQ        PLIST
     C                   PARM      'SPYCS'       QNAME                          Que name
     C                   PARM      '*LIBL'       QLIB                           Que library
     C                   PARM      10            QDTASZ                         Data length
     C                   PARM      'SPYCS'       QDTA                           Data
     C                   PARM      0             QWAIT             5 0          Wait time
     C                   PARM      'EQ'          QORDER            2            Logical op
     C                   PARM      27            QKEYSZ                         Key length
     C                   PARM                    QKEY                           Key
     C                   PARM      44            QSNDLN            3 0          Sender lngth
     C                   PARM                    QSNDR                          Sender ID
   
     C     PLTRCE        PLIST                                                  SpyCSTrc
     C                   PARM                    NODEID
     C                   PARM      'SPYCS'       TCPROG           10
     C                   PARM      *BLANK        TCMSGI            7
     C                   PARM                    TCTEXT           80
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * Get PSCON message
       dcl-proc RtvMsgSpy;
        dcl-pi *n char(80); // Message
          MsgID char(7) const; // Message ID
          MsgData char(100) const; // Message Data
        end-pi;
   
 1b  c                    select
 1x  C      MsgID         wheneq    'Q'
     C                    eval      @MPACT = 'Q'
     C                    EXSR      RTVMSG
 1x  C      MsgID         whenne    *BLANKS
     C                    eval      @ERCON = MsgID
     C                    eval      @ERDTA = MsgData
     C                    EXSR      RTVMSG
     C                    return    @MSGTX
 1e  C                   endsl
     C                    return    *BLANKS
   
     C      RTVMSG        BEGSR
     *          Get Message from PSCON
     C                    CALL      'MAG1033'                            99
     C                    PARM                    @MPACT            1
     C                    PARM      PSCON         @MSGFL           20
     C                    PARM                    ERRCD
     C                    PARM      *BLANKS       @MSGTX           80
   
     C                    MOVE      *BLANKS       @ERDTA
     C                    ENDSR
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * Set return status code and message
       dcl-proc RtnStatus;
        dcl-pi *n;
          RtnCode char(2) const;
          Program char(10) const;
          File char(10) const;
          MsgID char(7) const options(*nopass); // Message ID
          MsgData char(100) const options(*nopass); // Message Data
        end-pi;
   
 1b  c                    select
     * errors
 1x  c                    when      RtnCode >= '30'                              Fatal error
     c                                and %parms >= 4 and MsgID <> *blanks
     c                    eval      ErrTyp = 'E'
     c                    eval      ErrDes = RtnCode+' '+RtvMsgSpy(MsgID:MsgDta)
     c                    eval      @RTN = '30'
 1x  c                    when      RtnCode >= '30'                              Fatal error
     c                    eval      ErrTyp = 'E'
     c                    eval      ErrDes = RtvMsgSpy(MsgE(2):Program)
     c                    eval      @RTN = '30'
     * warnings
 1x  c                    when      RtnCode >= '20'
     c                                and %parms >= 4 and MsgID <> *blanks
     c                    eval      ErrTyp = 'W'                                 Warning
     c                    eval      ErrDes = RtnCode+' '+RtvMsgSpy(MsgID:MsgDta)
     c                    eval      @RTN = '20'
 1x  c                    when      RtnCode = '22'                               Top of data
     c                    eval      ErrTyp = 'W'                                 Warning
     c                    eval      ErrDes = RtvMsgSpy(MsgE(9):File)
     c                    eval      @RTN = '22'
 1x  c                    when      RtnCode = '21'                               Top of data
     c                    eval      ErrTyp = 'W'                                 Warning
     c                    eval      ErrDes = RtvMsgSpy(MsgE(6):File)
     c                    eval      @RTN = '20'
 1x  c                    when      RtnCode >= '20'                              End of data
     c                    eval      ErrTyp = 'W'                                 Warning
     c                    eval      ErrDes = RtvMsgSpy(MsgE(1):File)
     c                    eval      @RTN = '20'
 1x  c                    when      @rtn = '19'
     c                    eval      ErrTyp = 'E'
 1x  c                    other
     c                    eval      ErrTyp = 'K'
     c                    eval      ErrDes = *blanks
     c                    eval      @RTN = '00'
 1e  c                   endsl
   
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * Application layer callback for sending data
       dcl-proc ALSendData;
        dcl-pi ALSendData int(10);
          Buffer pointer value;
          BufferLn uns(10) value;
          BufferFlag int(10) value; // last buffer
          ErrorID char(8) value; // return error
          ErrorData char(101) value; // return data
        end-pi;
   
        dcl-s rc int(10);
        dcl-s MaxBuf uns(10);
   
     c                    eval      ErrorID   = x'00'
     c                    eval      ErrorData = x'00'
     c                    callp     RtnStatus('20':'CALLBACK':'DATA')
 1b  c                    if        sMajMinVer = *blanks
     c                    eval      MaxBuf = 7680
 1x  c                    else
     c                    eval      MaxBuf = 8100
 1e  c                   endif
     * Pass request to send function
     c                    eval      rc = SendData(Buffer:BufferLn:
     c                                            MaxBuf:BufferFlag)
 1b  c                    if        rc < 0                                       Error
     c                    eval      ErrorID   = MsgE(2) + x'00'
     c                    eval      ErrorData = 'SENDDATA' + x'00'
     c                    return    rc
 1e  c                   endif
   
     c                    return    BufferLn
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * Send Return Buffer Data
       dcl-proc SendData;
        dcl-pi *n int(10);
          Data pointer value;
          DataLn uns(10) value;
          MaxBufrSiz uns(10) value;
          LastBufrFlag int(10) value; // last buffer
        end-pi;
   
        dcl-s BufrLen zoned(9);
        dcl-s Bufr char(32767) based(bufrp);
        dcl-s Pos int(10);
        dcl-s Len int(10);
        dcl-s rc int(10);
   
     * setup regular return buffer
     c                    eval      RRERTY = 'K'                                 OK (More data)
     c                    eval      rrERDS = *blanks
     c                    eval      rMajMinVer = sMajMinVer
     c                    eval      RREOB = '1'
     * send data in fixed blocks
     c                    eval      BufrP = Data
     c                    eval      Pos = 0
 1b  c                    dou       Pos = DataLn
   
     * copy to send buffer
     c                    eval      Len = MaxBufrSiz - LastPos
 2b  c                    if        Len > DataLn - Pos                           get shortest
     c                    eval      Len = DataLn - Pos
 2e  c                   endif
 2b  c                    if        Len > 0 and BufrP <> *null
     c                    eval      %subst(RRSDT:LastPos+1) =                    copy data
     c                                           %subst(Bufr:1:Len)
     c                    eval      BufrP = BufrP + Len
 2e  c                   endif
   
     * send a buffer
 2b  c                    if        LastPos+Len = MaxBufrSiz                     full buffer
     c                                or LastBufrFlag<>0                         last buffer
 3b  c                    if        LastBufrFlag<>0 and Pos+Len=DataLn
     c                    eval      RRERTY = ErrTyp
     c                    eval      RRERDS = ErrDes
     c                    eval      RREOB = *blanks
 3e  c                   endif
     c                    eval      BufrLen = LastPos + Len
     c                    MOVE      BufrLen       rrERDS
     c                    eval      rc = CLSendData(%addr(REGRSP):%size(REGRSP)) comm layer send
 3b  c                    if        rc < 0                                       Error
     c                    return    rc
 3e  c                   endif
     c                    eval      RRSDT = *blanks
     c                    eval      LastPos = 0
 2x  c                    else                                                   partial
     c                    eval      LastPos = LastPos + Len                      update position
 2e  c                   endif
   
     c                    eval      Pos = Pos + Len
 1e  c                   enddo
   
     c                    return    DataLn
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * Send Response data
       dcl-proc SndRspDta;
        dcl-pi *n;
          RspDtaP pointer value;
          RspDtaLn uns(10) value;
          LastBufrFlag int(10) value; // last buffer
        end-pi;
   
     * Response Header
        dcl-ds RspHdrDS;
          rhHdrSiz zoned(5); // Header size
          rhBufLen zoned(5); // Buffer length
          rhMajMinVer char(5); // Major/Minor/Ver
          rhDtaSiz zoned(5); // Data size
          *n char(44); // pad
        end-ds;
   
        dcl-s rc int(10);
        dcl-c @MaxBuf 8100;
   
     * build and send the response header
     c                    clear                   RspHdrDS
     c                    eval      rhHdrSiz = %size(RspHdrDS)
     c                    eval      rhBufLen = @MaxBuf
     c                    eval      rhMajMinVer = sMajMinVer
 1b  c                    if        RspDtaLn > 99999
     c                    eval      rhDtaSiz = 99999
 1x  c                    else
     c                    eval      rhDtaSiz = RspDtaLn
 1e  c                   endif
     c                    eval      rc=SendData(%addr(RspHdrDS):%size(RspHdrDS):
     c                                          @MaxBuf:0)                       not done yet
     * send the data
     c                    eval      rc=SendData(RspDtaP:RspDtaLn:
     c                                          @MaxBuf:LastBufrFlag)            done (maybe)
     c                    return
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * Document revision operations
       dcl-proc DocRevision;
        dcl-pi *n end-pi;
   
        dcl-s RspP pointer;
        dcl-s RspLn int(10);
        dcl-s rc int(10);
        dcl-s ErrID char(7);
        dcl-s ErrDta char(100);
        dcl-s RevID zoned(10);
        dcl-s BatSeq zoned(9);
        dcl-s RevType char(1);
        dcl-s LastRevID zoned(10);
        dcl-s RqstP pointer;
        dcl-s docType char(10);
   
     * operation
     c                    eval      @RTN  = '30'
     c                    eval      RspP  = *null
 1b  c                    select
 1x  c                    when      File ='COBJECTS'
     c                    eval      rc = GetVCOContObj(%addr(REGREQ):RspP:RspLn:
     c                              sMajMinVer)
 2b  c                    if        rc = 0
     c                    eval      @rtn = '00'
 2e  c                   endif
 1x  c                    when      OpCode = 'DMLST'                             Revision List
     c                    eval      rc = GetRevLst(%addr(REGREQ):RspP:RspLn)
 1x  c                    when      OpCode = 'DMLCK' or                          Lock Revision
     c                              OpCode = 'DMULK' or                          Un-Lock Revisio
     c                              OpCode = 'DMUSR' or                          User Lock List
     c                              OpCode = 'DMRVT'                             Revert Revision
     c                    eval      ErrID = DMSCtl(%addr(REGREQ):RspP:RspLn:
     c                                           PGMUSR:NodeID)
 2b  c                    if        ErrID = *blanks
     c                    eval      @RTN  = '00'                                 OK
 2e  c                   endif
 1x  c                    when      OpCode = 'EDLNK'                             Edit Link
     c                    eval      ErrID = EditDocLink(%addr(xbfr))
 2b  c                    if        ErrID <> ' '
     c                    eval      @rtn = '30'
 2x  c                    else
     c                    eval      @rtn = '00'
 2e  c                   endif
 1e  c                   endsl
   
 1b  c                    if        rc=1 and (File='COBJECTS' or OpCode='DMLST')
     c                    eval      @RTN  = '20'                                 End of File
 1e  c                   endif
   
     * send response buffer
     c                    callp     RtnStatus(@RTN:'DOCREV':File:ErrID:ErrDta)
 1b  c                    if        @RTN <= '20'
 2b  c                    select
 2x  c                    when      OpCode = 'DMLCK' or                          Lock Revision
     c                              OpCode = 'DMULK' or                          Un-Lock Revisio
     c                              OpCode = 'DMRVT'                             Revert Revision
     c                    eval      rc=SendData(RspP:RspLn:8100:1)               no RspHdr
 2x  c                    other
     c                    callp     SndRspDta(RspP:RspLn:1)
 2e  c                   endsl
     c                    eval      OPCDE = 'NORESP'
 1e  c                   endif
     c                    callp     mm_free(RspP:0)
   
     c                    eval      TableFile = 'Y'
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * SpyLinks Hit list
       dcl-proc LnkHitList;
        dcl-pi *n;
          OpCode char(5) const;
        end-pi;
   
        dcl-s PgmActive char(1) static inz(*off);
        dcl-s RqstP pointer;
        dcl-s RspP pointer;
        dcl-s RspLn int(10);
   
        dcl-s KeyType char(10);
        dcl-s KeyData char(20);
        dcl-s RevID int(10);
        dcl-s RqstHits int(10);
        dcl-s HitCount int(10);
        dcl-s rc int(10);
   
     * shutdown sub-program
 1b  c                    select
 1x  c                    when      OpCode = 'INIT'
 2b  c                    if        PgmActive = *OFF
     c                    CALL      'MCSPYHITR'   plLnkHit
     c                    eval      PgmActive = *ON
 2e  c                   endif
     c                    return
 1x  c                    when      OpCode = 'QUIT'
 2b  c                    if        PgmActive = *ON
     c                    CALL      'MCSPYHITR'   plLnkHit
     c                    eval      PgmActive = *OFF
 2e  c                   endif
     c                    return
 1e  c                   endsl
   
     c                    eval      @File = FILE                                 @ file
     c                    eval      Handle = LIBR                                handle
     C                    MOVE      'NNN'         LNKSEC
     * Check if offline SpyLink (Key(51-55) is not empty)
     C                    MOVEA     KEY(51)       F5A
     C      ' ':'0'       XLATE     F5A           F5A
     C                    MOVE      F5A           @SEQ
 1b  C      @SEQ          IFNE      *ZEROS
     C                    MOVEL(P)  @SEQ          OPLID
     C                    MOVEL(P)  'RLNKOFF'     OPLFIL
 1x  C                    ELSE
     C                    CLEAR                   OPLID
     C                    CLEAR                   OPLFIL
 1e  C                   ENDIF
     * versioned parms
 1b  c                    if        sMajMinVer = *blanks
     c                    eval      Big5key = SKey                               Big5 key
 1x  c                    else
 2b  c                    if        SKey1 <> *blanks
     c                    eval      Big5key = x'00'+'RTYPEID  '+SKey1            Doc class
 2e  c                   endif
 2b  c                    select
 2x  c                    when      SKey2 = '*IMAGENO' or                        Image RRN
     c                              SKey2 = '*HITSEQ'  or                        Link Seq
     c                              SKey2 = '*BATCH'                             Batch Number
 3b  c                    if        %subst(SKey4:1:20) <> *blanks
     c                    eval      KeyType = SKey2
     c                    eval      KeyData = SKey4
 3e  c                   endif
 2x  c                    when      SKey2 <> *blanks and
     c                              SKey2 <> *zeros
     c                    testn                   SKey2                66
 3b  c                    if        *in66
     c                    eval      KeyType = '*REVID'
     c                    move      SKey2         RevID                          Revision ID
 3e  c                   endif
 2e  c                   endsl
 2b  c                    if        SKey3 <> *blanks                             passed
     c                    testn                   SKey3                66
     c    66              move      SKey3         RqstHits                       Requested Hits
 2e  c                   endif
 1e  c                   endif
     * Note: SKey4 (pos 1) contains Ascending/Descending Order flag (" ","A","D")
     * This is a "hint" used by NT to optimize it's Spylinks query processing
   
     c                    eval      RqstP = %addr(XBFR)
     c                    CALL      'MCSPYHITR'   plLnkHit
     c                    eval      PgmActive = *on
   
     * send response buffer
     c                    callp     RtnStatus(@RTN:'MCSPYHITR':@File:
     c                                                         MsgID:MsgDta)
 1b  c                    if        @RTN <= '20'
 2b  c                    if        sMajMinVer = *blanks
     c                    eval      rc=SendData(RspP:RspLn:7680:1)               old block
 2x  c                    else
     c                    callp     SndRspDta(RspP:RspLn:1)                      response
 2e  c                   endif
     c                    eval      OPCDE = 'NORESP'
 1e  c                   endif
     c                    callp     mm_free(RspP:0)
   
     c                    eval      TableFile = 'Y'
     c                    return
     *========================================================================
     c      plLnkHit      PLIST
     c                    parm                    @FILE
     c                    parm                    HANDLE           10            Handle
     c                    parm                    Big5key          50            Big5
     c                    PARM      OpCode        OpCodeX          10
     c                    parm                    sMajMinVer                     Major/Minor/Ver
     C                    PARM                    LNKSEC            3
     c                    parm                    RqstP                          Request buffer
     c                    parm                    RspP                           Return buffer
     c                    parm                    RspLn                          Return length
     C                    PARM      *blanks       @RTN
     C                    PARM      *BLANKS       MSGID                          Msg ID
     C                    PARM      *BLANKS       MSGDTA                         MsgDataFld
     * Optical parms 13-19
     C                    PARM                    OPLID            10
     C                    PARM      *BLANKS       OPLDRV           15
     C                    PARM      *BLANKS       OPLVOL           12
     C                    PARM      *BLANKS       OPLDIR           80
     C                    PARM                    OPLFIL           10            Opt @00...xx
     C                    PARM      0             OVRL#             1 0
     c                    parm      RqstHits      HitCount                       Rqst/Rtrn Hits
     * parms 20 - 23
     c                    parm                    KeyType                        Key type
     c                    parm                    KeyData                        Key data
     c                    parm                    RevID                          RevID
     C                    PARM      *loval        SHSFIL           10            Dst seg file
     * Query parms 24-28
     C                    PARM                    AO                             And/Or
     C                    PARM                    FN                             Field Names
     C                    PARM                    TE                             Test
     C                    PARM                    QVF                            Values
     C                    PARM                    QRYTYP                         Qry type
     c                    parm                    nodeid
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * OmniLinks Hit list
       dcl-proc OmniHitList;
        dcl-pi *n;
          OpCode char(5) const;
        end-pi;
   
        dcl-s PgmActive char(1) static inz(*off);
        dcl-s RqstP pointer;
        dcl-s RspP pointer;
        dcl-s RspLn int(10);
   
        dcl-s RevID int(10);
        dcl-s RqstHits int(10);
        dcl-s HitCount int(10);
        dcl-s rc int(10);
   
     * shutdown sub-program
 1b  c                    select
 1x  c                    when      OpCode = 'INIT'
 2b  c                    if        PgmActive = *OFF
     c                    CALL      'MCOMNHITR'   plOmniHit
     c                    eval      PgmActive = *ON
 2e  c                   endif
     c                    return
 1x  c                    when      OpCode = 'QUIT'
 2b  c                    if        PgmActive = *ON
     c                    CALL      'MCOMNHITR'   plOmniHit
     c                    eval      PgmActive = *OFF
 2e  c                   endif
     c                    return
 1e  c                   endsl
   
     c                    eval      OmniName = SKey1                             OmniLink name
     c                    eval      Handle = LIBR                                handle
     * versioned parms
 1b  c                    if        sMajMinVer = *blanks
     c                    eval      Big5key = %subst(SKey:11)                    Big5 key
 1x  c                    else
 2b  c                    if        SKey2 <> *blanks
     c                    eval      Big5key = x'00'+'RTYPEID  '+SKey2            Doc class
 2e  c                   endif
 1e  c                   endif
   
     c                    eval      RqstP = %addr(XBFR)
     c                    CALL      'MCOMNHITR'   plOmniHit
     c                    eval      PgmActive = *on
   
     * send response buffer
     c                    callp     RtnStatus(@RTN:'MCOMNHITR':OmniName:
     c                                                         MsgID:MsgDta)
 1b  c                    if        @RTN <= '20'
 2b  c                    if        sMajMinVer = *blanks
     c                    eval      rc=SendData(RspP:RspLn:7680:1)               old block
 2x  c                    else
     c                    callp     SndRspDta(RspP:RspLn:1)                      response
 2e  c                   endif
     c                    eval      OPCDE = 'NORESP'
 1e  c                   endif
     c                    callp     mm_free(RspP:0)
   
     c                    eval      TableFile = 'Y'
     c                    return
     *========================================================================
     c      plOmniHit     PLIST
     c                    parm                    OmniName         10            OmniName
     c                    parm                    HANDLE                         Handle
     c                    parm                    Big5key                        Big5
     c                    parm      OpCode        OpCodeX
     c                    parm                    sMajMinVer                     Major/Minor/Ver
     c                    parm                    RqstP                          Request buffer
     c                    parm                    RspP                           Return buffer
     c                    parm                    RspLn                          Return length
     C                    PARM      *blanks       @RTN
     c                    parm      *blanks       MSGID                          Msg ID
     c                    parm      *blanks       MSGDTA                         MsgDataFld
     c                    parm      RqstHits      HitCount                       Rqst/Rtrn Hits
     c                    parm                    RevID                          By Single RevID
     C                    PARM                    AO                             AND/OR
     C                    PARM                    FN                             FIELDS
     C                    PARM                    TE                             TEST
     C                    PARM                    QVF                            VALUES
     C                    PARM                    QRYTYP                         QRYTYP
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * OmniLinks Report types
       dcl-proc OmniRepTypes;
        dcl-pi *n;
          OpCode char(5) const;
        end-pi;
   
        dcl-s PgmActive char(1) static;
        dcl-s RspP pointer;
        dcl-s RspLn int(10);
        dcl-s rc int(10);
   
     * shutdown sub-program
 1b  c                    if        OpCode = 'QUIT' or
     c                              OpCode = 'INIT'
 2b  c                    if        PgmActive = *on
     C                    CALL      'SPYCSHREP'   plORepTypes
 2e  c                   endif
     c                    return
 1e  c                   endif
   
     * Get the report types for an OmniLink
     c                    eval      OmniName = SKey1                             OmniLink name
     c                    CALL      'SPYCSHREP'   plORepTypes
     c                    eval      PgmActive = *on
   
     * send response buffer
     c                    callp     RtnStatus(@RTN:'SPYCSHREP':OmniName:
     c                                                         MsgID:MsgDta)
 1b  c                    if        @RTN <= '20'
     C                    MOVE      RtnRecs       ERRDES                         # of records
 2b  c                    if        sMajMinVer = *blanks
     c                    eval      rc=SendData(RspP:RspLn:7680:1)               old block
 2x  c                    else
     c                    callp     SndRspDta(RspP:RspLn:1)                      response
 2e  c                   endif
     c                    eval      OPCDE = 'NORESP'
 1e  c                   endif
     c                    callp     mm_free(RspP:0)
   
     c                    eval      TableFile = 'Y'
     c                    return
     *========================================================================
     c      plORepTypes   PLIST
     c                    parm                    OmniName                       OmniName
     c                    parm      OpCode        OpCodeX                        Opcode
     c                    parm                    sMajMinVer                     Major/Minor/Ver
     c                    parm                    RspP                           Return buffer
     c                    parm                    RspLn                          Return length
     C                    PARM      0             RtnRecs           9 0          Rtn # recs
     C                    PARM      '00'          @RTN                           Rtn code
     c                    parm      *blanks       MSGID                          Msg ID
     c                    parm      *blanks       MSGDTA                         MsgDataFld
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * Overlay template operations
       dcl-proc OverlayOps;
        dcl-pi *n;
          OpCode char(5) const;
        end-pi;
   
        dcl-s PgmActive char(1) static;
        dcl-s RqstP pointer;
        dcl-s RspP pointer;
        dcl-s RspLn int(10);
        dcl-s rc int(10);
        dcl-s MaxLn int(10) inz(8100);
   
     c                    eval      OpCodeX = OpCode
     * shutdown sub-program
 1b  c                    if        OpCode = 'QUIT'
 2b  c                    if        PgmActive = *on
     c                    call      'MCOVRLAYR'   plOvrLay
 2e  c                   endif
     c                    return
 1e  c                   endif
     c                    eval      PgmActive = *on
   
     * Do overlay template operations
 1b  c                    if        SKey1 = '*SPYNBR'
     c                    eval      RptTypeID = RtvDocType(SKey3)
 1x  c                    else
     c                    eval      RptTypeID = SKey1                            Report Type ID
 1e  c                   endif
     c                    eval      OverlayID = SKey2                            Overlay ID
     c                    eval      RqstP = %addr(XBFR)
     c                    call      'MCOVRLAYR'   plOvrLay
   
     * block read processing for overlay images
 1b  c                    if        OpCode = 'RTOVL' and @RTN = '00'             not complete
     c                    eval      OpCodeX = 'RTOVLcont'
 2b  c                    dou       @RTN <> '00'                                 done
     c                    eval      rc=SendData(RspP:RspLn:MaxLn:0)              return data
     c                    call      'MCOVRLAYR'   plOvrLay
 2e  c                   enddo
 1e  c                   endif
   
     * send response buffer
     c                    callp     RtnStatus(@RTN:'MCOVRLAYR':RptTypeID:
     c                                                         MsgID:MsgDta)
 1b  c                    if        @RTN <= '20'
     c                    eval      rc=SendData(RspP:RspLn:MaxLn:1)              return data
     c                    eval      OPCDE = 'NORESP'
 1e  c                   endif
     c                    callp     mm_free(RspP:0)
   
     c                    eval      TableFile = 'Y'
     c                    return
     *========================================================================
     c      plOvrlay      PLIST
     c                    parm                    OpCodeX                        Opcode
     c                    parm                    sMajMinVer                     Major/Minor/Ver
     c                    parm                    RptTypeID        10            Report Type ID
     c                    parm                    OverlayID        10            Overlay ID
     c                    parm                    RqstP                          Request buffer
     c                    parm                    RspP                           Return buffer
     c                    parm                    RspLn                          Return length
     C                    parm      '00'          @RTN                           Rtn code
     c                    parm      *blanks       MSGID                          Msg ID
     c                    parm      *blanks       MSGDTA                         MsgDataFld
     c                    parm                    MaxLn                          Max Return leng
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * get page info for a image/document
       dcl-proc GetPageInfo;
        dcl-pi *n;
          OpCode char(5) const;
        end-pi;
   
        dcl-s RevID int(10);
        dcl-ds ContID len(20);
          ciBatNum char(10);
          ciBatSeq zoned(9);
        end-ds;
        dcl-s Pages int(10);
   
        dcl-ds PagInfoDS;
          PageCnt char(10);
          ImgSize char(10);
        end-ds;
   
     c                    reset                   DocFncRtnStsDS
     c                    eval      @RTN = '00'
     c                    eval      SDTds = *blanks                              return buffer
     c                    eval      PagInfoDS = *zeros                           resp struct
     * rev or content id
 1b  c                    select
 1x  c                    when      SKEY1 <> *blanks
     c                    MOVE      SKEY1         RevID
     c                    eval      ContID = GetContID(RevID)                    convert revid
 2b  c                    if        ContID = *blanks
     c                    eval      @RTN = '20'
 2e  c                   endif
 1x  c                    when      SKEY2 <> *blanks and SKEY3 <> *blanks
     c                    clear                   ContID
     c                    MOVEL(p)  SKEY2         ciBatNum
     c                    MOVEL     SKEY3         ciBatSeq
 1x  c                    other
     c                    eval      @RTN = '20'
 1e  c                   endsl
     * get size and page count
 1b  c                    if        @RTN = '00'
 2b  c                    if        OK<>GetDocAttr(ciBatNum:ciBatSeq:DocAttrDS)
     c                    eval      @RTN = DocFncRtnSts(DocFncRtnStsDS)
 2x  c                    else
     c                    move      da_FileSize   ImgSize
 3b  c                    if        OK = IsTiffImage(da_FileExt)
 4b  c                    if        OK<>GetDocPageCnt(ciBatNum:ciBatSeq:Pages)
     c                    eval      @RTN = DocFncRtnSts(DocFncRtnStsDS)
 4x  c                    else
     c                    move      Pages         PageCnt
     c                    eval      SDTds = PagInfoDS
 4e  c                   endif
 3e  c                   endif
 2e  c                   endif
 1e  c                   endif
     * response structure
     c                    callp     RtnStatus(@RTN:'PAGEINFO':ContID:
     c                                        dfRtnMsg:dfRtnMsgDta)
     c                    return
       end-proc;
     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     * convert content id (batch/seq) to rev id
       dcl-proc Cvt2RevID;
        dcl-pi *n;
          OpCode char(5) const;
        end-pi;
   
     * client request/response
        dcl-ds c1RqstDS;
          c1RevType char(1);
        end-ds;
        dcl-ds c2RespDS;
          c2RevID char(10);
          c2ContID char(20);
        end-ds;
   
        dcl-s RevType char(1);
        dcl-s RevID int(10);
        dcl-ds ContID len(20);
          ciBatNum char(10);
          ciBatSeq zoned(9);
        end-ds;
   
     c                    eval      @RTN = '00'
     c                    eval      SDTds = *blanks                              return buffer
     c                    eval      c1RqstDS = XBfr
     c                    eval      c2RespDS = *blanks
     * batch/seq or content id
 1b  c                    select
 1x  c                    when      SKEY2 <> *blanks and SKEY3 <> *blanks
     c                    clear                   ContID
     c                    MOVEL(p)  SKEY2         ciBatNum
     c                    MOVEL     SKEY3         ciBatSeq
 1x  c                    when      SKEY4 <> *blanks
     c                    MOVEL     SKEY4         ContID
 1x  c                    other
     c                    eval      @RTN = '20'
 1e  c                   endsl
     * rev type
 1b  c                    if        @RTN = '00'
 2b  c                    select
 2x  c                    when      c1RevType = '0'
     c                    eval      RevType = Rt_Lowest
 2x  c                    when      c1RevType = '1'
     c                    eval      RevType = Rt_Highest
 2x  c                    when      c1RevType = '2'
     c                    eval      RevType = Rt_Head
 2x  c                    other
     c                    eval      @RTN = '20'
 2e  c                   endsl
     * get the revision
 2b  c                    if        @RTN = '00'
     c                    eval      RevID=GetRevByContID(ContID:RevType)
     c                    move      RevID         c2RevID
     c                    move      ContID        c2ContID
 2e  c                   endif
 1e  c                   endif
     * response structure
     c                    eval      SDTds = c2RespDS
     c                    callp     RtnStatus(@RTN:'CVTREVID':ContID)
     c                    return
       end-proc;
   
     *----------------------------------------------------------------------------------------
     *- Get the current user's SMTP address
     *----------------------------------------------------------------------------------------
       dcl-proc GetUsrAddr;
        dcl-pi GetUsrAddr char(256) end-pi;
   
        dcl-s smtpAddr char(256) inz(*blanks);
   
     c                    call      'SPYMLRSN'
     c                    parm      pgmusr        prmUser          10
     c                    parm                    smtpAddr
     c                    parm                    prmDesc         256
   
     c                    return    smtpAddr
   
       end-proc;
   
     *------------------------------------------------------------
       dcl-proc GetAPFTyp;
        dcl-pi GetAPFTyp char(1);
          aRqsKey char(100) const;
        end-pi;
        dcl-s chrAPFTyp char(1);
        dcl-s keyRptDir char(10);
   
        dcl-ds dsRqsKey;
          RqsKey10 char(10);
          RqsKey20 char(10);
          RqsKey30 char(10);
          RqsKey40 char(10);
          RqsKey50 char(10);
          RqsKey60 char(10);
          RqsKey70 char(10);
          RqsKey80 char(10);
          RqsKey90 char(10);
          RqsKey100 char(10);
        end-ds;
   
        dsRqsKey = aRqsKey;
   
      // Get the report id.
 1b     if skey1 = 'SPYLINK';
          keyRptDir = skey2;
 1x     else;
          keyRptDir = %subst(rqskey:66:10);
 2b       if keyRptDir = ' ';
            keyRptDir = skey1;
 2e       endif;
 1e     endif;
   
 1b     if %open(mrptdir7);
          close mrptdir7;
 1e     endif;
        Open(e) MRptDir7;
        Chain    keyRptDir MRptDir7;
   
 1b     If %found(MRptDir7);
          chrAPFtyp = APFTyp;
 1x     Else;
          chrAPFtyp = *blank;
 1e     Endif;
   
        Return chrAPFTyp;
       end-proc;
   
     *------------------------------------------------------------
       dcl-proc PDFBufPrc;
     *------------------------------------------------------------
     * Used to determine if a native PDF file is available that may
     * be associated with the document folder or document link.
     *------------------------------------------------------------
   
        dcl-pi PDFBufPrc ind end-pi;
   
      /copy @memio
J5600 /copy qsysinc/qrpglesrc,qusrspla
J5600 /copy @masplio
   
        dcl-pr atoi int(10) extproc('atoi');
          *n pointer value options(*string); // alpha
        end-pr;
   
     * Constants ----------------------------------------------
        dcl-c TRUE '1';
        dcl-c FALSE '0';
        dcl-c LASTBUFFLG 1;
        dcl-c NOTLASTBUFFLG 0;
        dcl-c BUFREQSIZE 8100;
        dcl-c ERROR -1;
   
     * Variables ----------------------------------------------
        dcl-s intTotalBufRtn uns(10) static inz(*zero);
        dcl-s intPDFSize uns(10) static inz(*zero);
        dcl-s intBufRtn int(10);
        dcl-s strPDFBuffer char(32767) inz(*allx'00');
        dcl-s ptrPDFBuffer pointer inz(%addr(strpdfbuffer));
        dcl-s MaxBuf uns(10) inz(8100);
        dcl-s bufferflag int(10);
        dcl-s MAXREAD int(10) inz(32767);
        dcl-s strRptId char(10);
        dcl-s inpPDFPath char(512) static;
        dcl-s firstPage int(10) inz(1);
        dcl-s lastPage int(10) inz(-1);
        dcl-s intFH int(10);
        dcl-s i int(10);
        dcl-s pageRangeRequested ind inz(*off);
   
 1b     if GetAPFTyp(rqskey) <> '4';
          return FALSE;
 1e     endif;
   
      // Get the report id.
 1b     if skey1 = 'SPYLINK';
          strRptId = skey2;
 1x     else;
          strRptId = %subst(rqskey:66:10);
 2b       if strRptId = ' ';
            strRptId = skey1;
 2e       endif;
 1e     endif;
   
 1b     Select;
 1x       When opcode = 'READC';
            intFH = managePDFHandles(MPH_GET:strRptID:intPDFSize); //T5840
 2b         if intFH <> ERROR;
              file = @PDF;             // Set the format type to PDF
              errdes = *blanks;        // Clear return data structure
              errtyp = 'W';            // File has been acknowledged
              errdes = '21 *PDF';      // as PDF type
              aTotSz = intPDFSize;     // Return back the size of the returned file
              abufln = 1;
              %subst(errdes:59:9) = *blanks;
              Return TRUE;
 2x         else;
              return FALSE;
 2e         Endif;
   
 1x       when OpCode = 'READ';
         // Use the distribution modules to more efficiently retrieve pages
         // for both segment and link requests.
            intFH = managePDFHandles(MPH_GET:strRptId:intPDFSize); //T5840
         // If this is a segment request, convert the pages requested to
         // the segment pages and send back.
   
            firstPage = atoi(rqr#pg);
            lastPage = firstPage;
 2b         if rqr#pg <> xbf_fpg;
              lastPage = atoi(xbf_fpg);
            // Check if range is a subset of document. If so, allow into
            // distribution logic.
 3b          if %subst(rqxbfr:322:1) <> 'P';
               getArcAtr(strRptId:%addr(qusa0200):%size(qusa0200):0);
 4b            if QUSTP00 > (lastPage - firstPage + 1);
                 pageRangeRequested = *on;
 4e            endif;
 3e          endif;
 2e         endif;
   
         //Distribution or page-at-a-time request or a subset page range.
 2b        if (%subst(rqxbfr:322:1) = 'P' and isRptDistrib(skey1:pgmusr) = 1) or
             lastPage = firstPage or pageRangeRequested;
              PDF_dst_init(intFH);
 3b           select;
 3x             when %subst(rqxbfr:322:1) = 'P' and
                  isRptDistrib(skey1:pgmusr) = 1;
                  dsttbl = %subst(xbfr:322:10);
                  lastPage = *hival;
                  cvtToDistPageNbrs(skey1:sit_segFile:dsttbl:firstPage:
                    lastPage:distPage);
 4b               for @dstpg = firstPage to lastPage;
                    distPage = @dstpg;
                    cvtFromDistPageNbr(skey1:sit_segFile:dsttbl:0:0:distPage);
                    PDF_dst_add_page(distPage);
 4e               endfor;
 3x             other;
 4b               for i = firstPage to lastPage;
                    PDF_dst_add_page(i);
 4e               endfor;
 3e           endsl;
              PDF_dst_close();
              inpPDFPath = %trim(PDF_dst_get_fileName()) + x'00';
              intFH = Open(inpPDFPath:O_RDONLY);
 2e         endif;
   
         // Open handle to extracted pages and reopen handle to
         // work pdf.
            fstat(intFH:%addr(stat_ds));
            intPDFSize = st_size;
            aTotSz = intPDFSize;
            ExSr StreamFile;               // Send file down the pipe
   
            callp close(intFH);  //T3996J
   
         // Close up and delete work files. Set regular response buffer and return.
            PDF_dst_quit();
   
            intFH = 0;
            intTotalBufRtn = 0;
            file = @PDF;
            abufln = intBufRtn;
            errtyp = 'W';
            errdes = '04';
            OpCde = 'NORESP';              // 03-15 Trigger the end of sending data
            RRSDt  = *blanks;
   
            return TRUE;
   
 1x       Other;
            Return FALSE;
 1e       Endsl;
   
      //----------------------------------------------------------------
      // Send the stream file down the socket and cleanup afterwards
      //----------------------------------------------------------------
         BegSr StreamFile;
   
            intTotalBufRtn = *zero;
            file = @PDF;
            PDFBufRtv(intFH:ptrPDFBuffer:MAXREAD:intBufRtn);
   
 1b         Dow intBufRtn > 0;
              intTotalBufRtn = intTotalBufRtn + intBufRtn;
   
 2b           If intTotalBufRtn >= intPDFSize;
                errtyp = 'W';
                errdes = '04';
                BufferFlag = LASTBUFFLG;
                errdes = '04';
 2x           Else;
                errtyp = 'K';
                errdes = *blanks;
                BufferFlag = NOTLASTBUFFLG;
 2e           Endif;
   
         // Process the First buffer here
              abufln = intBufRtn;     // Data Buffer pass back the ASCII pdf Data
              rc = SendData(ptrPDFBuffer:intBufRtn:MaxBuf:BufferFlag);
              strPDFBuffer = *allx'00';
   
              PDFBufRtv(intFH:ptrPDFBuffer:MAXREAD:intBufRtn);
   
 1e         Enddo;
   
         EndSr;
   
        /end-free
       end-proc;
   
     **************************************************************************
       dcl-proc managePDFHandles;
   
        dcl-pi *n int(10);
          operation int(10) const;
          reportID char(10) options(*nopass);
          fileSizeRtn uns(10) options(*nopass);
        end-pi;
   
     * Operations: GET=1, DELETE=2
   
        dcl-ds pdfHandle based(php) qualified;
          next pointer;
          rptID char(10);
          timeOpened timestamp;
          fileHandle int(10);
          size uns(10);
        end-ds;
        dcl-s TOP pointer static;
        dcl-s saveP pointer;
   
        dcl-s firstPage int(10) inz(1);
        dcl-s lastPage int(10) inz(-1);
        dcl-s wrkFH int(10);
   
 1b     select;
 1x     when operation = MPH_GET;  // Get file handle.
 2b       if TOP = *null; // Init linked list.
            phP = %alloc(%size(pdfHandle));
            clear pdfHandle;
            TOP = phP;
 2e       endif;
          phP = TOP;
 2b       dou pdfHandle.next = *null;
 3b         select;
               // Clear the report id and close the file handle if opened for
               // more than 2 hours. Reuse the slot.
 3x         when pdfHandle.rptID <> ' ' and
              %diff(%timestamp():pdfHandle.timeOpened:*h) > 2;
              exsr closeAndClear;
 2v           leave;
 3x         when pdfHandle.rptID = reportID; // Rtn opened file handle.
              fileSizeRtn = pdfHandle.size;
              return pdfHandle.fileHandle;
 3e         endsl;
 3b         if pdfHandle.next <> *null;
              phP = pdfHandle.next;
 3e         endif;
 2e       enddo;
 2b       if pdfHandle.rptID <> ' ' and pdfHandle.next = *null;
            pdfHandle.next = %alloc(%size(pdfHandle));
            phP = pdfHandle.next;
            clear pdfHandle;
 2e       endif;
          exsr openAndAdd;
          return pdfHandle.fileHandle;
 1x     when operation = MPH_QUIT;
          phP = TOP;
 2b       dow phP <> *null;
            exsr closeAndClear;
            saveP = pdfHandle.next;
            dealloc(n) phP;
            phP = saveP;
 2e       enddo;
          return 0;
 1e     endsl;
   
      //************************************************************************
        begsr openAndAdd;
 1b       If  PDFBufInit(wrkFH:reportID:firstPage:lastPage:fileSizeRtn) = -1;
            return -1;
 1e       endif;
          pdfHandle.rptID = reportID;
          pdfHandle.timeOpened = %timestamp();
          pdfHandle.fileHandle = wrkFH;
          pdfHandle.size = fileSizeRtn;
        endsr;
   
      //************************************************************************
        begsr closeAndClear;
          pdfHandle.rptID = ' ';
          pdfBufQuit(pdfHandle.fileHandle);
          pdfHandle.fileHandle = 0;
          pdfHandle.size = 0;
        endsr;
   
       end-proc;
     *----------------------------------------------------------
   
     ************************************************************************
     * Map PCL page segments to physical pages and send back to DocView.
       dcl-proc mapPCLSegPgs;
        dcl-pi *n;
          inBuf like(xbfr);
        end-pi;
   
        dcl-ds segment qualified;
          name char(10);
          desc char(40);
          file char(10);
          rptType char(10);
          bundle char(10);
          subList char(10);
          reportID char(10);
          totPgs char(9);
          sPageC char(9);
          ePageC char(9);
        end-ds;
   
        dcl-s totPages int(10);
        dcl-s x int(10);
        dcl-s transformPage int(10);
        dcl-s actualPage uns(10);
        dcl-s bufPtr pointer inz(%addr(actualpage));
        dcl-s bufLen uns(10) inz(%size(actualpage));
        dcl-s lastBufFlg int(10) inz(0);
   
        segment = inBuf;
        totPages = %int(%trim(segment.totPgs));
 1b     for x = 1 to totPages;
          transformPage = x;
          CvtFromDistPageNbr(segment.reportID:sit_segFile:segment.file:0:0:
            transformPage);
          actualPage = transformPage;
 2b       if x = totPages;
            lastBufFlg = 1;
 2e       endif;
          AlSendData(bufPtr:bufLen:lastBufFlg:' ':' ');
 1e     endfor;
       end-proc;
   
     ************************************************************************
       dcl-proc emailImage;
        dcl-pi *n end-pi;
   
        dcl-pr spycsfil extpgm('SPYCSFIL');
          *n char(10) const; // window
          *n char(10) const; // batchID
          *n char(6) const; // opcode
          *n char(9) const; // setseq
          *n char(7680); // rtnBuf
          *n packed(9) const; // rtn#rec
          *n char(2); // rtncde
        end-pr;
   
        dcl-ds rtnBuf len(7680) qualified;
          rrn zoned(9) pos(112);
        end-ds;
        dcl-s rtncde char(2);
   
     * Data Que Message
        dcl-ds dqmsg len(256);
          rqop char(1) pos(1);
          rqobty char(1) pos(2);
          rqrpt char(10) pos(3);
          rqfrm char(10) pos(13);
          rqud char(10) pos(23);
          rqspag zoned(7) pos(33);
          rqepag zoned(7) pos(40);
          rqptra zoned(9) pos(47);
          rqptrd zoned(9) pos(56);
          rqptrp zoned(9) pos(65);
          rqfldr char(10) pos(74);
          rqflib char(10) pos(84);
          rqloc char(1) pos(94);
          rqoptf char(10) pos(95);
          rqptyp char(10) pos(105);
          rqidx char(10) pos(115);
          rqmbr char(10) pos(125);
          rqpwnd char(1) pos(135);
          rqeusr char(10) pos(136);
          rqenam char(10) pos(146);
          rqnwnd zoned(3) pos(156);
          rqimpg char(20) pos(159);
          rqNotesPrint char(1) pos(179);
        end-ds;
   
        clear dqmsg;
        rptud = %char(%time():*iso0);
        key20a = %trim(jobNum) + rptud;
        rqobty = 'I';
        rqfrm = '*STD';
        rqrpt = 'DOCIMAGE';
        spycsfil(' ':%subst(skey4:36:10):'READ':
          %subst(skey4:46:10):rtnBuf:1:rtncde);
 1b     if %subst(skey4:46:9) <> ' ';
          rqspag = %dec(%subst(skey4:46:9):9:0);
          rqepag = %dec(%subst(skey4:46:9):9:0);
 1e     endif;
        rqfldr = %subst(skey4:36:10);
        rqidx = %subst(skey4:36:10);
        rqptyp = '*PCL';
        rqimpg = %trim(xbf_fpg) + '-' + %trim(xbf_tpg);
        rqnotesprint = 'N';
        rqop = 'M';
 1b  c                    do        2
     c                    call      'QSNDDTAQ'
     c                    parm      'MAG210'      qname
     c                    parm      '*LIBL'       lib              10
     c                    parm      256           qdtasz
     c                    parm                    dqmsg
     c                    parm      20            qkeysz
     c                    parm                    key20a           20
     c                    eval      rqop = 'Q'
 1e  c                   enddo
   
     c                    call      'MAG2038'
     c                    parm      '*DTAQ'       rptfrm           10
     c                    parm      jobNum        frmprm           10
     c                    parm                    rptud            10
     c                    parm                    rqspag
     c                    parm                    rqepag
     c                    parm      ' '           outq             10
     c                    parm      ' '           outql            10
     c                    parm      ' '           prtf             10
     c                    parm      ' '           prtlib           10
     c                    parm      1             frmcl#            3 0
     c                    parm      999           tocol#            3 0
     c                    parm      1             copies
     c                    parm      ' '           writer           10
     c                    parm      ' '           outfil           10
     c                    parm      'SPYEXPORT'   outflb           10
     c                    parm      ' '           filloc            1
     c                    parm      ' '           optfil           10
     c                    parm      0             numwnd            3 0
     c                    parm      247           #rl               3 0
     c                    parm      81            colscn            3 0
     c                    parm      0             plcsfa            9 0
     c                    parm      0             plcsfd            9 0
     c                    parm      0             plcsfp            9 0
     c                    parm      'N'           prtwnd            1
     c                    parm      ' '           @fldr
     c                    parm      ' '           @fldlb           10
     c                    parm                    rqfldr
     c                    parm      ' '           ptable           20
     c                    parm      '*NONE'       cvrpag            7
     c                    parm      '*NO'         duplex            4
     c                    parm      '*AUTO'       orient           10
     c                    parm      ' '           ptrtyp            6
     c                    parm      ' '           ptrnod           17
     c                    parm      '*SYSDFT'     cvrmbr           10
     c                    parm      '*SYSDFT'     papsiz           10
     c                    parm      '*ORG'        drawer            4
     c                    parm      'Y'           eNotesPrint       1            Notes print
   
     c                    return
   
       end-proc;
     *------------------------------------------------------------------------------
       dcl-proc ToUpper;
        dcl-pi ToUpper int(10);
          aInput char(1024) options(*varsize);
        end-pi;
   
        dcl-c TOUPPER_OK 0;
        dcl-c TOUPPER_ERROR -1;
        dcl-c UPPER 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        dcl-c LOWER 'abcdefghijklmnopqrstuvwxyz';
   
        dcl-s output varchar(1024);
        dcl-s intReturn int(10) inz(toupper_ok);
     C      LOWER:UPPER   XLate     aInput        aInput
     C                    return    intReturn
       end-proc;
       dcl-proc IsSplMail;
        dcl-pi IsSplMail ind end-pi;
   
J5953 /include @MASPLIO
J5953 /include qsysinc/qrpglesrc,qusrspla
   
        dcl-c NOT_SPLMAIL '0';
        dcl-c IS_SPLMAIL '1';
        dcl-c PRTTY_AFPDS '*AFPDS';
        dcl-c PRTTY_IPDS '*IPDS';
        dcl-c PRTTY_AFPDSLINE '*AFPDSLINE';
        dcl-s rtnSplMail char(1);
        dcl-s rc int(10);
        dcl-s strRptId char(10);
 1b      If ( SplMail <> YES );
           rtnSplMail = NOT_SPLMAIL;
 1x      Else;
 2b        If skey1 = 'SPYLINK';
             strRptId = skey2;
 2x        Else;
             strRptId = %subst(rqskey:66:10);
   
 3b          If strRptId = ' ';
               strRptId = skey1;
 3e          Endif;
 2e        Endif;
   
   
 2b        If ( quspdt00 = *blanks );
              rc=getArcAtr( strRptId  : %addr(Qusa0200) : %size(Qusa0200) : 3);
 2e        Endif;
   
 2b        If (   quspdt00 = PRTTY_AFPDS     )  or
              (   quspdt00 = PRTTY_AFPDSLINE )  or
              (   quspdt00 = PRTTY_IPDS      );
             rtnSplMail = IS_SPLMAIL;
 2x        Else;
             rtnSplMail = NOT_SPLMAIL;
 2e        Endif;
   
 1e      Endif;
   
         return rtnSplMail;
       end-proc;
**ctdata msge
ERR1364 04 END/TOP OF FILE REACHED
ERR1371 11 TERMINAL ERROR
ERR1374 14 PGM EXCEPTION ERROR
ERR1372 12 USER LICENSE EXCEEDED
ERR1373 13 INVALID SPYVIEW AUTHORIZATION
ERR1369 06 TOP OF FILE REACHED
ERR137A 15 Not authorized to delete annotation.
ERR137B 16 Not authorized to delete template.
ERR137C 01 Object not found.

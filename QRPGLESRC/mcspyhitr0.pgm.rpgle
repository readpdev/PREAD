      *%METADATA                                                       *
      * %TEXT SpyLink Hit List Server                                  *
      *%EMETADATA                                                      *
/1767h bnddir('SPYBNDDIR')
      /copy directives
      ***********-------------------------
      * MCSPYHITR  SpyLink Hit List Server
      ***********-------------------------
      *
      *  Retrieve from SpyLink databases up to 10 records that match
      *  the requested filter query. Called by WRKSPI, SPYCS, DSPHYPLNK
      *                                        Spycshhit, Mag1085
      *  Note:
      *   If the program does a QUERY against a DASD SpyLink, the
      *   IO Buffer for the READ and for the KEY of the @000... file
      *   has to be formatted differently. Because of the FORMAT parm
      *   in the OPNQRYF (has to be used because you cannot read the
      *   QRYF with a LVLCHK(*NO)) the IO buffer fills the fields
      *   IXIV1-8 perfectly.  No SUBST operation is needed to fill
      *   the RV array.
      *
      *   WRKSPIFM is used with a OVRDSP SHARE(*YES) to handle query
      *   escape window properly.
      *
J7246 * 11-14-17 PLR Translate query mode screen selection criteria to SQL.
J4772 * 07-13-17 PLR Replace the link retrieval mechanism with SQL.
J7064 * 03-03-17 PLR Indexes longer than 30 bytes and having a wildcard where
      *              not returning any hits. Caused by internal opnqryf fields
      *              used for LIKE conditions being too short. Increased to 70
      *              bytes to match max 5250 display field lengths. Any size
      *              bigger than that, and things get weird.
J6848 * 05-09-17 PLR Duplicate records appear at end of list when using OmniLinks
      *              search through CoEx. Generally, occurs only in the first
      *              doclink class in the OmniLink.
J5546 * 04-26-17 PLR Large image file support.
J6772 * 08-09-16 PLR TERMINAL ERROR 11 encountered when client would enter new
      *              criteria containing wildcard after normal search. Error
      *              would occur because the incorrect window handle structure
      *              was used and the file handle in that occurence was null.
      *              Corrected by using the specified session handle instead of
      *              attempting to force the use of the 1st window handle data
      *              structure when running in query mode (wild card used).
      *              Also implemented under this issue, VIP-6161. No rollfoward
      *              was done.
J5904 * 09-22-14 PLR Yet another issue with the wildcard implementation. After
      *              several searches between different wildcard criteria,
      *              the returning hit list will always return the previous
      *              wildcard search. Caused by a failure in the OPNQRYF command
      *              because the handle attempting to open for the query is
      *              open in another handle. Resolved by closing all of the
      *              handles if the search is a query and not a DB record
      *              search.
J4899 * 09-12-13 PLR Remove section of code throwing unnecessary TERMINAL ERR
      *              message. No adverse reactions detected in DocView, CoEx or green screen.
J5023 * 07-25-13 EPG Qualify the modification used in J4414 by checking for
/     *              the system default value that is used to determine if this
/     *              check should in fact be used.
J4644 * 01-24-13 PLR Right justified indexes do not show up in searches.
J4602 * 12-19-12 EPG An unqualified DocLink index search for a user in a
/     *              subscriber list that has DocLink Security defined
/     *              hangs in DocView.
J4355 * 08-29-12 PLR Correct leading wildcard search.
J4347 * 07-30-12 EPG Fix an issue with the composite key built used to
      *              chain to the RMAINT file.
J4275 * 07-09-12 PLR Additional issue with wildcard searching. When called by
      *              either client (DocView or CoEx) with a wildcard on both
      *              ends of the criteria (*55*) the first search returned the
      *              first search correctly, however, the second search with a
      *              different wildcard value (*56*) would return the hits
      *              for the first search criteria. Because the clients return
      *              a new window handle for each search, it was necessary to
      *              close the window handles and open query files if the
      *              incoming handle was not found (new).
J3692 * 08-10-11 PLR VIP-1996 change to allow enhanced wildcard searches was
      *              causing very slow returns for environments with large
      *              hit list files (5 million+). Made a small change to the
      *              query mode (qrType = 'Q' instead of 'S') and the time to
      *              return a list decreased five fold. May be required to
      *              rework if response times continue at a degraded level.
J3728 * 09-20-11 PLR Add create date to factoring to help in speeding up
      *              retrieval for large lists.
J3618 * 06-22-11 PLR Retrieve extended annotation flags.
J3472 * 04-20-11 PLR Clear query request structure when a clear opcode is issued.
      *              Was causing the export/import client to export more document
      *              data outside of a given date range.
J3055 * 04-20-11 PLR VCO api call to get document by id/seq fails when CoEx
      *              connecting in spyweb mode. Will bypass validity checking
      *              when the keyType is *HITSEQ.
J3399 * 03-15-11 PLR Justified index values do not function with LIKE
      *              and wildcard values.
J2813 * 03-09-11 EPG Revise the low level Rreadn C function to
J2746 * 03-02-11 EPG Roll foreward the changes detailed in VIP-2642.
/     *              Conditionally populate the field hhdate based on the
/     *              system environment variable rtvImgCrtTim.
J3242 * 01-17-11 EPG Change the implementation for the low level read of the
/     *              database to be use with no lock and provide new error
/     *              recovery.
J3252 * 01-13-11 EPG Roll forward additional changes that should have originally
/     *              been included in J2745. This includes removing debug code
/     *              and restoring the original low level read instructions.
J3012 * 12-17-10 PLR Removed another section of code from patch 1767 because
      *              it was preventing the change of the sort order from the
      *              green screen hit list (F17=Sort) with a date range
      *              specified. Again, 1767 should have been addressed as a
      *              data correction issue and not a program change. See Aldon
      *              history for source code comparison.
J2799 * 12-17-10 PLR Changes made under 1767 caused a problem with how window
      *              handles manage open index files (@ files). The premature
      *              exit when reading docLinks at an end-of-data (R@WARN = 20)
      *              caused the index files to appear as if already open in
      *              another window causing the terminal error experienced by
      *              the customer. Erick and Philip resolved to remove just the
      *              piece of code that was causing the link-read to terminate
      *              prematurely. If the original issue was indeed orphaned
      *              image indexes, this should not have an impact. What should
      *              have occurred is the data should have been corrected. This
      *              kind of 'orphaned' link data issue can be detected by
      *              SPYPVP. Three lines of code removed from BldHitList. See
      *              Aldon historical records for original code.
J3114 * 11-02-10 EPG Provide for a replacement value to be used as the wild
      *              card value for DocLnk searches.
J1509 * 10-08-09 EPG Provide a check for DocLink Security within the
      *              routine SETHDL.
J1996 * 09-16-09 PLR 'LIKE' search capability to the search criteria. This
      *              allows the user to prepend an asterisk wildcard to the
      *              search. Previously only supported trailing asterisk
      *              wildcard searches.
J1798 * 08-25-09 PLR Include create time for reports and capture time for
      *              images to the VCO conversation. Using field hhToDate in
      *              structure HitHdrDS. Wasn't being used by anything.
      *              Added flag to sysenv that will turn on/off the ability
      *              to retrieve the create time for a specific image file.
      *              Getting this info can be expensive...
T1509 * 06-01-09 EPG Derive Doclink security from the RMAINT file, and if
/     *              deemed as active, call the exit program MASECLNK.
T1767 * 04-28-09 EPG Provide the means to recover from an instance
/     *              where orphaned MIMGDIR records are read from
/     *              an index file, and the end of the file is reached.
/     *              Also, reformat the binding directory compile option.
/     *              Under certain condtions, if a read is performed
/     *              in the procedure lnkdbread, with the current OPCODE
/     *              being READ and not all of the return hits are retrived,
/     *              then MCSPYHITR would exit, and reenter with the original
/     *              search criteria. This would cause the search to continue
/     *              over again.
/     *              This condition is trapped, causing the error to be reported
/     *              and recovering by reading the next record.
T7279 * 02-12-09 PLR Trap a potential error where a null pointer has been
/     *              passed to the procedures. Set the global return structure
/     *              for a warning to indicate the end of the file has been
/     *              reached. Roll forward of EPG code.
T7475 * 02-12-09 PLR Has been an ongoing issue since 9828 (clientele). An all
      *              9's date range is invalid and this should have never been
      *              done in the first place. Removed code.
T6642 * 12-11-07 PLR Wasn't logging retrieve link detail records.
T5783 * 11-07-06 PLR Added exit point to hit list selection, allowing further
      *              validation by customer applications.
T5415 * 06-21-06 EPG Query index searches of values containing all 9's
      *              failed to successfully return matching Doc Classes.
      *              Modified the logic to accomodate this value.
T5028 * 01-11-06 PLR Annotation icons were not being displayed for the
      *              clients in their hit lists and the annotations
      *              were not being displayed when distribution and
      *              distribution doclinks were active. Condition occurred
      *              when logical distribution page range was outside of
      *              physical page range. Removed offending code from
      *              subprocedure BldHitHdr.
T4475 * 07-08-05 PLR Bug 9828 (clientele) caused a problem when specifying
      *              a date range selection with the from date only filled in
      *              and the sysenv control for archiving create dates in
      *              descending order turned on.
/9828 * 04-12-05 PLR Default 'to' date set to 99999999 in rlocate function
/9828 * 04-12-05 PLR Default 'to' date set to 99999999 in rlocate function
      *              causing non-display of image via workflow and coex.
/9684 *  3-31-05 JMO Fixed problem with off-line links not returning hits when
      *               when the user searches using more than 1 search criteria.
      *               Loop was ending when it should not.
/9669 *  3-24-05 JMO Added logic to retrive the BIG5 from the Spy# or
      *                Batch# when using the "SELCR" opcode with *HITSEQ or
      *                *IMAGENO.
/8627 * 10-11-04 JMO Added SETBG opcode functionality to position to the
      *                beginning of the filter data.
/9160 * 09-02-04 PLR Check user authority to segments.
/5635 * 02-04-04 PLR Audit logging.
/8793 * 01-21-04 JMO Changed parms on call to FMTIVAL so it would work
      *               correctly when user is accessing off-line spylinks
      *               Previously, the parms would cause the call to
      *               FMTIVAL to fail which would in turn cause incorrect
      *               filtering of off-line spylinks
/8724 * 12-01-03 PLR Suppress messages off of joblog for override and close.
/8724 * 11-25-03 GT  Change OVRSCOPE to *CALLLVL and remove DLTOVR commands.
/     *              DLTOVR *ALL was used, causing all overrides (not just
/     *              ours) to be removed. DLTOVR no longer needed because
/     *              using *CALLLVL causes overrides to be deleted when
/     *              the invocation level ends.
/     *              NOTE: There is still a problem when going from an
/     *              OPNQRYF query to a regular query. At the point where
/     *              the file is being closed, the program no longer knows
/     *              that the previous open used OPNQRYF, so the CLOF
/     *              command is not called. This change corrects most of
/     *              the file closing issues, but more extensive changes
/     *              will be required to completely fix the file closing
/     *              logic in this case.
/8557 * 08-26-03 GT  Changed positioning of file after failed SETLL to EOF
/     *              (was BOF).  Previous setting was causing long
/     *              search times when no record found.
/8304 * 05-16-03 PLR User receiving inappropriate power user authority when
      *              viewing segments via client.
/7459 * 01-16-03 PLR Next key appearing on SpyWeb screen when initial screen
/     *              of hits does not have more than what is displayed. Set the
/     *              'hits this buffer' link header field to be the total number
/     *              of hits sent back in the buffer.
/7563 * 01-06-03 PLR Security was not working correctly with omnilinks.
/     *              Was not including the report name (for reports) or batch
/     *              number when checking authority.
/7419 * 11-13-02 GT  Change default image extension to TIF (was TIFF)
/7087 *  9-03-02 GT  Add calc for number of hits per buffer for 7.0 conv
/6604 *  6-12-02 DLS Send a clear handle to SPYCSLNK after the links have
/6604 *              been viewed and screen refreshed.  This will force MCSPYHITR
/6604 *              to rebuild.  Also make sure that opcode of QUIT is sent to
/6604 *              SPYCSLNK when ready to leave.  And in MCSPYHITR the OVRDBF
/6604 *              has OVRSCOPE(*JOB) therefore the delete of the override
/6604 *              should be at that same level.
/6503 * 06-06-02 PLR Correct order of links in buffer on read-previous.
/4569 * 05-08-02 GT  Fix no OmniLink hits returned in SPYWEB when
      *               only OmniLinks enabled: Call to SPYCSWEB was
      *               returning an error because no SpyLink access
      *               records existed
/4569 * 02-28-02 KAC Do not call Web filter for Omnilinks
/5921 * 01-25-02 KAC Revise distribution Spylinks support
/6001 * 01-18-02 KAC Fix problem with Offline spylinks (definition big5).
/4537 * 10-29-01 KAC Revise for VCO phase II functions.
/5673 * 10-23-01 KAC Attention Key not being set correctly.
/5671 * 10-19-01 KAC Full text search failure
/5624 * 10-10-01 GT  SPYCSWEB parm list change
/5150 * 09-20-01 KAC Spylink positioning problem (SETGT)
/5014 * 08-30-01 KAC Make additional CS call to FMTIVAL (fix numerics)
/5068 * 07-27-01 KAC Problems with positioning (SETLL/SETGT).
/5083 * 07-16-01 KAC Include missing non-rev docs on "show all revs".
/5000 * 07-16-01 KAC Handle Revision Selection with Optical Spylinks.
/4779 * 07-13-01 KAC Show all revisions (repeat spylinks).
/4863 * 06-19-01 KAC Problems with Numeric index formating
/3765 * 06-13-01 PLR Get correct rc comment.
/4648 * 05-24-01 KAC Backup & Restore offline spylinks within same session fails.
/3765 * 05-24-01 KAC Add flag for unavailable (offline) spylinks.
/4564 * 05-21-01 KAC Revision count selection not working
/3982 * 05-18-01 KAC Green Screen omnilink problem with filter and positioning.
/4407 * 05-02-01 KAC Spy"like" condition test reversed.
/4396 * 04-26-01 KAC Problem with green screen offline spylinks (related to /3765)
/3765 * 02-12-01 KAC Add document revision support.
/3982 * 02-07-01 KAC Green Screen omnilink problem with filter and positioning.
/3869 * 01-25-01 KAC Fix postitioning with Green screen F19/F20 w/filter.
/3679 * 01-16-01 KAC Add VCO support report type rather Big5 key.
/3794 *  1-15-00 RA  3794HQ - Correct type code with reportid rolls from SPY to Snnnnn....
/2924 * 01-05-01 KAC Add new "MoreLinks Web" structure.
/3321 * 12-28-00 KAC Remove OPT ID (Obsolete as of 6.0.6)
/3340 * 11-21-00 KAC Add a new SpyLinks opcode RDREV (read reverse)
/2397 * 10-19-00 KAC Always call FMTIVAL (wasn't called for Omnilinks)
/2107 * 10-11-00 KAC Add support CS Distribution Spylinks
/2954 *  9-08-00 KAC Query fails due to single quotes.
/2924 *  8-23-00 KAC Switch to NT's "Big Key Patch" conversation.
/813  *  7-26-00 KAC Apply REVISED NOTES INTERFACE
/2832 * 07-25-00 DLS Allow for proper display of all records if sort by
/2832 *              create date is selected.  Problem with 8 defined
/2832 *              elements but only 7 field names were loaded. 8th
/2832 *              entry is always create date (not in RLNKDEF file).
/2832 *              Hard coded "CREATED" for this field name.
/2832 *              NOTE: No preceding "@" sign is used to avoid
/2832 *              collision with user defined key field names.
/2815 * 07-19-00 KAC Add SpyWeb Limit Scrolling
/2763 * 05-31-00 GT  Use RMAINT data stream type
/2499 * 03-14-00 DLS Ensure proper file shut down from OMNIAPICMD and
/2499 *              and SpyApiCmd.
/2395 * 01-19-00 KAC SPYESC DATA AREA LOCK BEING HELD.
/2319 * 12-14-99 KAC ADDED "INIT" OPCODE FOR PROGRAM SHUTDOWN CONTROL
      *  8-16-99 FID Added new field to DTS structure to send report type to pc
      *  8-13-99 FID Added new compare LK=Like NL=Not Like
      * 06-30-99 KAC TEST FOR VALID ARRAY INDEX.
      * 05-07-99 GT  Don't replace @FILE with blank offline file name.
      * 03-08-99 KAC MOVE NOTES CODE TO SPYCSNOT.
      * 12-22-98 KAC USE NEW NOTES FILES.
      * 12-09-98 KAC CHANGE ENTRY & GETHDR PARM LIST INCLUDE MSG ID &  DATA
      *  8-19-98 GK  Bug - Lnks on Opt & Img on DASD for OffLine files.
      *  6-16-98 FID Links for open batches are not valid
      *  5-11-98 GT  Check RNF indicator in REINIT subroutine
      *  4-27-98 JJF Fix error paging when crt date is criterion
      *  4-22-98 GT  Fix LIKE/NLIKE/CT/DC query algorithms.
      *  2-27-98 kac add support for imageview type reports
      *  2-05-98 kac add support for r/dars type reports
      *  1-20-98 JJF Limit hits to Dist Segment if SHSFIL parm not blnk
      *  9-15-97 GT  Fix date value handling for SETEN opcode
      *  6-24-97 JJF Don't close RLNKDEF.
      *  5-14-97 GT  Add SETGT and SKIPP opcodes
      *  5-08-97 GT  Change SDTRV7 start pos to 421 (was 412)
      *  7-16-96 JJF Allow opcode 'QUIT' to shut down program.      and JobTyp = '1'
      *  5-28-96 DM  Change SDT structure (SR FILDTS).
      *  4-29-96 FID New method for lower/upper case XLATE
      *  4-08-96 JJF If @file won't open (in OPNFIL SR) return RTN=20.
      * 10-22-95 JJF Remove * from search arg if user fills inx length.
      * 10-02-95 JJF Allow descending create date key.  (POSFIL SR)
      *  9-19-95 JJF Save,restore CRTFRM,CRTTO with SVA in SAVVAL.
      *  9-15-95 JJF Revise to be server to WRKSPI for terminals.
      *  9-08-95 JJF Call MAG1081 to retrieve indices from optical.
      *  5-15-95 DM  New program
      *
      *  Entry Parms:
      *
      *    Parm  name   size  description
      *    ----  -----  ----  ----------------------------------------
      *     1    @File    10  Name of file containing records to select
      *     2    @Hndl    10  Window Handle
      *     3    EnBig5   50  RMaint key of report
      *     4    OpCode    5  Selcr / Rdgt etc. (see below)
      *     5    Sec       3  Security for READ/DELETE/PRINT
      *     6    IFiltr 1000
      *                    --------------------------------------------
      *     7    Sdt    8100  Send back buffer
      *     8    Rtn      2   Return code (20=warning 30=terminal)
      *     14   OptVol  12   Optical volume
      *     15   OptDir  80   Optical directory (e.g. SPYDATA)
      *     16   OptFil  10   Optical file name (e.g. @000070312)
      *
      *  When OPCODE is:
      *
      *          "SELCR"  start the search into the SpyLink database
      *                   pass back 10 hits.
      *
      *          "SETBG"  set file to the beginning of the filter, using
      *                   IFILTR fields through SpyLink sequence no.
      *
      *          "SETLL"  set lower limits to the logical, using
      *                   IFILTR fields through SpyLink sequence no.
      *
      *          "RDGT"   start where it left off on the previous call
      *                   pass back back the next 10 hits, reading fwd.
      *
      *          "SETGT"  set greater than to the logical, using
      *                   IFILTR fields through SpyLink sequence no.
      *
      *          "RDLT"   start where it left off on the previous call
      *                   and send back the PREVIOUS 10 hits.
      *                   Restart from the beginning if less
      *                   than 10 hits are available.
      *
      *          "RDLTX"  start where it left off on the previous call
      *                   and send back the PREVIOUS 10 hits.
      *                   DO NOT restart from the beginning if less
      *                   than 10 hits are available.
      *
      *          "RDREV"  start where it left off on the previous call
      *                   and send back the PREVIOUS hits.
      *                   Like RDLTX except buffer is reverse order.
      *
      *          "SETEN"  set the logical to the end of the filter using
      *                   IFILTR fields through SpyLink sequence no.
      *
      *          "CLEAR"  clear the window handle, making it available.
      *
/2319 *          "INIT"   PROGRAM STARTUP
      *

     FWRKSPIFM  CF   E             WORKSTN USROPN INFDS(INFDS)
     FRMAINT    IF   E           K DISK
/3679fRMaint4   if   e           k disk    usropn rename(RMntRc:RMntRc4)
     FRLNKDEF   IF   E           K DISK
     FRINDEX1   IF   E           K DISK
     FMRPTDIR7  IF   E           K DISK
     FMIMGDIR   IF   E           K DISK
     FRLNKOFF   IF   E           K DISK    usropn
/4396fRLnkOff1  if   e           k disk    usropn rename(LnkOff:LnkOff1)
/4779fMMREVDR2  if   e           k disk    usropn
/1509fadseclnk1 if   e           k disk    usropn

T5783 /copy @mgnvphdl
T5783 /copy @linkexit
      /copy 'QRPGLESRC/@lnkdbsql0.rpgleinc'

      // ProtoTypes -----------------------------------------------------------------------
J4602d IsQualified     pr              n
/     * Determine if this is a qualifed search
/2813d GetNextRec      pr
/    d  pRIOFBp                        *   value

/1509d GetSecRule      pr              n
/
/1509d MaSecLnk        pr                  ExtPgm('MASECLNK')
/    d  pNvpHandler                    *   procptr
/
/    d SecLnkAddHit    pr             1

T5783d exitPgmAddHit   pr             1

T5783d checkObject     pr                  extpgm('SPCHKOBJ')
/    d  object                       10    const
/    d  objectLib                    10    const
/    d  objectType                   10    const
/    d  objectRtnCde                  1
T7279d MsgLog          PR            10I 0 ExtProc('Qp0zLprintf')
/    d  szOutputStg                    *   Value OPTIONS(*STRING)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
/    d                                 *   Value OPTIONS(*string:*nopass)
      * build Hit list
     d BldHitlist      pr            10i 0
     d OpCode                        10    const
      * filter link selection
     d LnkFilter       pr            10i 0
     d HdlNbr                         5i 0 const                                handle number
     d OpCode                        10    const                                operation
      * Build hit header
     d BldHitHdr       pr            10i 0
     d RevID                         10i 0 const
      * get the PC file extension from the link's doc type
     d GetPCext        pr             5a
     d LnkCode                        1    const                                Doc link code
      * convert selection criteria (filter or position to) - (7.0 version)
/2924d CvtCrit70       pr
     d CritMapP                        *   const                                buffer/map
     d RqsBufrP                        *   const                                request buffer
      * convert selection criteria (filter or position to) - (7.1 version)
/3765d CvtCrit71       pr
     d CritMapP                        *   const                                buffer/map
     d RqsBufrP                        *   const                                request buffer
      * convert criteria values
     d CvtCritVal      pr
     d CVBufrP                         *   const                                Crit Val buffer
     d CVcnt                          5i 0 const                                Crit Val count
     d CVlen                          5i 0 const                                Crit Val length
      * format criteria values
     d FmtCrit         pr            10i 0
     d CritMapP                        *   const                                buffer/map
      * check criteria date
/5068d ChkCritDate     pr            10i 0
/    d CritMapP                        *   const                                buffer/map
      * setup filter criteria
     d SetFilter       pr
     d HdlNbr                         5i 0 const                                handle number
      * build key list buffer for positioning
     d BuildKey        pr
     d KeyMapP                         *   const                                buffer/map
      * get size of one hit
/7087d GetMaxHits      pr            10i 0
      * add multiple revision link hits
/4779d AddHitMult      pr
     d OpCode                        10    const
      * add link hit entry to return buffer
     d AddHit          pr
     d RevID                         10i 0 const
/2924d AddHit70        pr            10i 0
/7087d AddOpt                        10i 0 value
      * add link hit entry to return buffer (7.1 version)
/3765d AddHit71        pr            10i 0
/7087d AddOpt                        10i 0 value

J3618 * add link hit entry to return buffer (9.0 version)
J3618d AddHit90        pr            10i 0
J3618d AddOpt                        10i 0 value

      * reallocate buffer and return offset pointer
/3765d BufrAlloc       pr              *                                        data offset
     d Size                          10i 0 const                                data size

      * get/assign window handle
     d GetHandle       pr             5i 0                                      handle number
     d Handle                        11    const                                window handle
      * clear window handle
     d ClrHandle       pr
     d HdlNbr                         5i 0 const                                handle number

      * setup doc class definition
     d GetDCdef        pr            10i 0
     d Big5                          50    const                                Big5 key
      * Offline links
     d OffLinks        pr            10i 0
     d RptBig5                       50                                         RMaint  Big5
     d LnkBig5                       50                                         RLnkDef Big5
     d OffFile                       10    const                                offline file
     d OffSeq                         5    const                                offline seq
      * get Offline links by File
     d OffLinkFile     pr            10i 0
     d OffFile                       10    const                                offline file
     d RptBig5                       50                                         RMaint  Big5
     d LnkBig5                       50                                         RLnkDef Big5
      * get Offline links by Seq
     d OffLinkSeq      pr            10i 0
     d Big5                          50    const                                RMaint  Big5
     d OffSeq                         5    const                                offline seq
      * link definition
     d LinkDef         pr            10i 0
     d Big5                          50    const                                Big5 key
      * Optical links definitions
     d OptLnkDef       pr            10i 0
     d OpCode                        10    const                                operation
      * build link buffer mapping structure
     d BldLnkMap       pr
     d BufrMapP                        *                                        buffer map
      * deallocate link buffer mapping structure
     d DlcLnkMap       pr
     d BufrMapP                        *                                        buffer map

      * position link db file
     d LnkDBpos        pr            10i 0
     d HdlNbr                         5i 0 const                                handle number
     d OpCode                        10    const                                operation
      * read link db file
     d LnkDBread       pr             2a
     d HdlNbr                         5i 0 const                                handle number
     d OpCode                        10    const                                operation
      * open link db file
     d LnkDBopen       pr            10i 0
     d HdlNbr                         5i 0 const                                handle number
      * close link db file
     d LnkDBclose      pr            10i 0
     d HdlNbr                         5i 0 const                                handle number
      * optical links
     d OptLnkIO        pr             2a                                        return code
     d OpCode                        10    const                                operation

     d SpyLikeTest     pr            10i 0
     d LikeValue                     30    const options(*nopass)               like value
     d IndexData                     99    const options(*nopass)               index data
      * full text search
     d CSFind          pr            10i 0
     d OpCode                        10    const                                operation
/5671d LnkBufrP                        *   const options(*nopass)               link buffer
      * get notes flag
     d ChkNotes        pr            10i 0
     d OpCode                        10    const                                operation
     d NoteCde                        1    options(*nopass)                     notes code
J3618d noteFlagsP                      *   options(*nopass)                     extended note flags

J3618 * Additional parms needed for passing note flags pointer.
J3618d StartPos        s             10i 0                                      Start position
J3618d DataLen         s             10i 0

      * get Web parameters
     d GetWebParms     pr            10i 0
     d OpCode                        10    const                                operation
     d WebParm                        1    options(*nopass)
      * get document attribute
/3765d GetDocAttr      pr            10i 0
     d OpCode                        10    const                                operation
     d BatchNum                      10    const options(*nopass)
     d BatchRRN                      10i 0 const options(*nopass)

      * get/check revision id
/3765d RevCheck        pr            10i 0
     d BackCount                     10i 0 const                                Revs back
      * add revision entry to hit list
/3765d RevEntry        pr
      * Add the log entry.
/5635d AddLogEnt       pr

      * check distribution spylinks and convert page numbers
/5921d ChkDistLink     pr            10i 0
     d SpyNumber                     10    value
     d RptStartPage                  10i 0 value
     d RptEndPage                    10i 0 value
     d DistStartPage                  9s 0
     d DistEndPage                    9s 0
     d DistTotalPages                 9s 0

      * convert distribution link back to report pages
/5921d CvtFromDist     pr            10i 0
     d SpyNumber                     10    value
     d DistStartPage                 10i 0 value
     d DistEndPage                   10i 0 value
     d RptStartPage                   9p 0
     d RptEndPage                     9p 0

      * set return status
     d RtnSts          pr
     d RtnCode                        2    const
     d MsgID                          7    const options(*nopass)
     d MsgData                      100    const options(*nopass)
      * convert big5 key if necessary
/3679d CvtBig5         pr            50
     d Big5                          50    const

      * setup query processing request
     d QuerySetup      pr
      * remove/double the quotes
/2954d Qfix            pr
     d val                           30
     d char                           1    const
      * Build query command
     d QueryCmd        pr
     d  cmd                        1024

      * execute a CL command
     d CLcmd           pr            10i 0
     d  cmd                        1024    const                                CL command
/5673d QCmdExc         pr                  extpgm('QSYS/QCMDEXC')
/    d  cmd                        1024    const                                command
/    d  cmdLen                       15  5 const                                command length
      * receive a message
     d RcvMsg          pr
      * send a status message
     d SpyStsMsg       pr
     d  MsgID                         7    const                                msg id
     d  MsgDta                      256    const                                msg data

      /copy @RECIO                                                              Record I/O
      /copy @MEMIO                                                              Memory I/O
      /copy @MGMEMMGRR                                                          Memory Manager
      /copy @MMDMSSRVR                                                          DMS functions
      /copy @MMCSNOTER                                                          Notes
/5921 /copy @MMRPTDSTR
/5635 /copy @mlaudlog
      * Constants ------------------------------------------------------------------
J4602dERR000A          c                   'ERR000A'
J4602dRTNCDE_40        c                   '40'
/1509dYES              c                   'Y'
/1767dTRUE             c                   '1'
/    dFALSE            c                   '0'
      * conversation versions
/3765d CV@DMS71        c                   '71000'
J3618d CV@DMS90        c                   '90000'
     d OK              c                   1
     d FAIL            c                   0
T7279D LF              C                   x'25'
/     * Return value: '0' = Exists, '1' = Does NOT exist
     d MaxHndl         c                   256                                  max handles
     d MaxIndx         c                   7                                    max indexes
     d MaxQryLn        c                   25
     D PSCON           C                   'PSCON     *LIBL     '
      * program return codes
     d R@OK            c                    '00'
     d R@WARN          c                    '20'
     d R@ERROR         c                    '30'
      * add link hit entry to return buffer (7.0 version)
/7087d #AHAddHit       c                   0
/7087d #AHGetSize      c                   -1

      * Data Structures -----------------------------------------------------------------------
J4347d RMaintKeyds     ds                  LikeRec(RMntRc:*key)

      * Requested Query values
     d QryRqstDS       ds
     d qrAndOr                        3    dim(MaxQryLn)
     d qrFldNam                      10    dim(MaxQryLn)
     d qrDtaTyp                       1    dim(MaxQryLn)
     d qrCond                         5    dim(MaxQryLn)
J7064d qrValue                       70    dim(MaxQryLn)
     d qrType                         1
      * Regular Query (non-fulltext) values
     d RegQryDS        ds
     d rqAndOr                        3    dim(MaxQryLn)
     d rqFldNam                      10    dim(MaxQryLn)
     d rqDtaTyp                       1    dim(MaxQryLn)
     d rqCond                         5    dim(MaxQryLn)
J7064d rqValue                       70    dim(MaxQryLn)
     D rqGroup                        3  0 dim(MaxQryLn)                        group#
     d WHdlDS          ds                  occurs(MaxHndl) inz
     d wxBig5                              like(enBig5)
     d wxOptID                             like(OptID)
     d wxOptFil                            like(OptFil)
     d whOptID                             like(OptID)
     d whOptVol                            like(OptVol)
     d whOptDir                            like(OptDir)
     d whOptFil                            like(OptFil)
     d whOptSeq                       5
     d whOptLinks                      n
     d whOpnQryF                       n
     d whFileP                         *
     d whOpenFile                    10
     d whLinkFile                    10
     d whLfNbr                        3  0                                      logical file nbr
     d whLfKSL                        8
     d whLfKeyOrd                     1  0 dim(8) overlay(whLfKSL)              lf key order
     d whLfFactors                         dim(8) like(lNDxF1)
     d whLfFltCde                     1
     d whMaxEQ                        3  0
     d whLnkBufP                       *                                        link buffer map
     d whFilterP                       *                                        filter criteria map
     d whPosKeyP                       *                                        position key map

T5783d mchitexit       ds                  dtaara
/    d  he_pgmNam                    10
/    d  he_pgmLib                    10

     d FulTxtDS        ds
     d ftAndOr                        4    dim(5)
     d ftCond                         5    dim(5)
     d ftWord                        95    dim(5)
     D ftGroup                        3  0 dim(MaxQryLn)                        group#
     d FNDGRP                         5                                         Fnd Group


      * link data/filter map
     d LnkMapDS        ds                  based(LnkMapDSp)
     d lmLnkNdxP                       *                                        link Buffer
     d lmBatNumP                       *                                        Batch num
     d lmLnkSeqP                       *                                        Link seq
     d lmCrtDateP                      *                                        Create date
     d lmTypCodeP                      *                                        type code
     d lmStrPageP                      *                                        starting page/rrn
     d lmEndPageP                      *                                        ending page/rrn
     d lmValLn                        5i 0 dim(MaxIndx)                         index lengths
     d lmValP                          *   dim(MaxIndx)                         index values
     d lmFltCde                       1    dim(8)                               filter code
     d lmFltLn                        5i 0 dim(8)                               filter lengths
     d lmCrtDate2                          like(lxIv8 )                         Create to date
     d lmNumRev                      10i 0                                      Number of revisions
      * link db record (special alpha version that matches compiled file IO)
     d RLnkNdxDS     e ds                  extname(RLnkND01) based(RLnkNdxDSp)
J4355d wKeyList        ds           999
J4355d KV                      1    999    DIM(999)                             1-7 + date
      * Doc Class Info
     d DClsDS          ds                  occurs(MaxHndl) inz
     d dcBig5                              like(rmBig5) inz(*loval)             Big 5
/6001d dcBig5ld                            like(rmBig5) inz(*loval)             Big 5 (lnkdef)
     d dcRptTyp                            like(RTypID)                         Report type
     d dcLmtScr                            like(RLmtSc)                         limit scrolling
     d dcDteDesc                           like(LdtDes)                         date descending
     d dcValCnt                       5i 0
     d dcValNam                            dim(MaxIndx) like(iInam)
     d dcValDesc                           dim(MaxIndx) like(iDesc)
     d dcValLn                        5i 0 dim(MaxIndx)
     d dcAnnoAsRev                         like(AnnoSupport)                    anno as a rev
     d dcLckSupport                        like(LckSupport)                     lock support
     d dcAllowBranch                       like(BranchSupport)                  allow branching
     d dcRevStatus                         like(RevStatus)                      revision status

      * Link work fields
     d LinkWorkDS      ds
     d  ldContID                     20                                         Content ID
     d  ldBatNum                     10    overlay(ldContID:1)                  Batch number
     d  ldBatRRN                      9  0 overlay(ldContID:11)                 Batch RRN
     d  ldRevID                      10i 0                                      Revision ID
     d  ldRevLckSts                  10i 0                                      Rev lock sts

      * Hit Header (Old SDT structure minus index data)
     d HitHdrDS        ds
     d  hhFrmDate                     8                                         From date
     d  hhToDate                      8                                         To date
     d  hhBatNum                     10                                         Batch number
     d  hhLnkSeq                      9  0                                      Link seq
     d  hhStrPage                     9  0                                      Start page
     d  hhEndPage                     9  0                                      End page
     d  hhSecFlag                     3                                         security flags
     d  hhRedFlag                     1    overlay(hhSecFlag:1)                 read flag
     d  hhDltFlag                     1    overlay(hhSecFlag:2)                 delete flag
     d  hhPrtFlag                     1    overlay(hhSecFlag:3)                 print flag
     d  hhTypCde                      1                                         type code
     d  hhLnkFile                    10                                         link file
     d  hhLnkLib                     10                                         link file library
     d  hhBig5Key                    50                                         Big5 key
     d  hhLocCde                      1                                         location code
     d  hhNoteCde                     1                                         notes code
     d  hhPCext                       5                                         PC file extension
     d  hhTotPag                      9  0                                      total pages
     d  hhRDARoff                     9
     d  hhRDARfil                     9
     d  hhLmtScrl                     1                                         limit scroll
     d  hhRptTyp                     10                                         report type
     d  hhTblSeq                     10                                         table seq
     d  hhOffSeq                     10                                         offline seq
/3765d  hhIdxNotAvail                 1                                         index n/a
/    d                               85                                         pad

J3618 * Hit Header (Old SDT structure minus index data) with extended note flags
J3618d HitHdrDS_2      ds                  qualified
J3618d  hhFrmDate                     8                                         From date
J3618d  hhToDate                      8                                         To date
J3618d  hhBatNum                     10                                         Batch number
J3618d  hhLnkSeq                      9  0                                      Link seq
J3618d  hhStrPage                     9  0                                      Start page
J3618d  hhEndPage                     9  0                                      End page
J3618d  hhSecFlag                     3                                         security flags
J3618d  hhRedFlag                     1    overlay(hhSecFlag:1)                 read flag
J3618d  hhDltFlag                     1    overlay(hhSecFlag:2)                 delete flag
J3618d  hhPrtFlag                     1    overlay(hhSecFlag:3)                 print flag
J3618d  hhTypCde                      1                                         type code
J3618d  hhLnkFile                    10                                         link file
J3618d  hhLnkLib                     10                                         link file library
J3618d  hhBig5Key                    50                                         Big5 key
J3618d  hhLocCde                      1                                         location code
J3618d  hhNoteCde                     1                                         notes code
J3618d  hhPCext                       5                                         PC file extension
J3618d  hhTotPag                      9  0                                      total pages
J3618d  hhRDARoff                     9
J3618d  hhRDARfil                     9
J3618d  hhLmtScrl                     1                                         limit scroll
J3618d  hhRptTyp                     10                                         report type
J3618d  hhTblSeq                     10                                         table seq
J3618d  hhOffSeq                     10                                         offline seq
J3618d  hhIdxNotAvail                 1                                         index n/a
J3618d  hhHasBlackOut                 1                                         blackout note y/n
J3618d  hhHasRbrStmp                  1                                         rubberstamp note y/n
J3618d  hhHasTextNote                 1                                         text note y/n
J3618d  hhHasSticky                   1                                         sticky note y/n
J3618d  hhHasHiLite                   1                                         hilite note y/n
J3618d  hhHasAudio                    1                                         audio file y/n
J3618d  hhHasFile                     1                                         file blob attach y/n
J3618d                               78                                         pad

/3679d rmBig5          ds
     d  rRNAM
     d  rJNAM
     d  rPNAM
     d  rUNAM
     d  rUDAT

     d ldBig5          ds
     d  lRNAM
     d  lJNAM
     d  lPNAM
     d  lUNAM
     d  lUDAT

     d loBig5          ds
     d  loRPTN
     d  loJOBN
     d  loPGMN
     d  loUSRN
     d  loUSRD

     d lNdxNds         ds
     d  lNdxN1
     d  lNdxN2
     d  lNdxN3
     d  lNdxN4
     d  lNdxN5
     d  lNdxN6
     d  lNdxN7
     d  lNdxNA                             like(lndxn1) dim(MaxIndx)
     d                                     overlay(lNdxNds)
     d lNdxFds         ds
     d  lNdxF1
     d  lNdxF2
     d  lNdxF3
     d  lNdxF4
     d  lNdxF5
     d  lNdxF6
     d  lNdxF7
     d  lNdxF8

     D INFDS           DS
      *             Subfile return values
     D  KEY                  369    369
     D  PAGRRN               378    379i 0

      * Field name/lengths
???  d FLDS            DS                  occurs(MaxHndl) inz
     D  LN                           10    DIM(8)                               Lnk Ndx Names
     D  IL                            3  0 DIM(8)                               Ndx Lengths
     D  IK                            3  0 DIM(8)                               Start Position
      *
J4355d qIL             s              3  0 dim(8)                               Qry ndx lengths
J4355d qIK             s              3  0 dim(8)                               Qry start pos

     D                SDS
     D @PARMS                 37     39  0
     d @User                 254    263                                         user name

     D SYSDFT          DS          1024    dtaara
     D  EXTSEC               137    137
J1798D  rtvImgCrtTim         202    202
     D  DSTLNK               221    221
T5783d  pgmlib               296    305
     D  DTALIB               306    315
     D  LNKSCR               370    370
J3114D  WLDCRD               962    962
J5023D  IUSDLS              1004   1004

     D SPYESC         UDS                  dtaara
      *             Escape attention key
     D  ESCSTS                 1      1

      * PC File extensions
     d SPYPCTYP        ds          2000    dtaara
     d  PCtype                        5    dim(256)                             File types

      * SpyWeb parms
/2815d SPYWEB         UDS                  dtaara
/    d swWEBAPP                      10                                         Web App
/    d swWEBUSR                      20                                         Web User

      * Image/Doc Attribute structure
     d PCATR           ds          1024
     d  FMTSPY                 1      3
     d  FMTVER                 1      5
     d  PCIDX#                 6      8
     d  PCSIZE                 9     17
     d  PCFILE                18     42
     d  PCEXT                 43     47
     d  PCDATE                48     55
     d  PCTIME                56     61
     d  PCPATH                62    311
     d  PCUDAT               312    319
     d  PCUTIM               320    325
     d  PCUSR                326    335
     d  PCNODE               336    352
     d  PCOSV                353    358
     d  PCSPYV               359    364
     d  PCSYS                365    369

      * query status msg data
     d  QueryStsDS     ds                  inz
     d  qsScanned                     9p 0
     d  qsMatched                     9p 0

      * system API error struct
     d APIerrDS        ds
     d  AerrBprv                     10i 0 inz(%size(APIerrDS))
     d  AerrBavl                     10i 0
     d  AerrExcID                     7
     d  AerrRSV1                      1
     d  AerrData                    128


      * working return code
     d wRtnDS          ds
     d wRtnCde                        2    inz('00')                            return code
     d wRtnID                         7                                         msg id
     d wRtnDta                      100                                         msg data

/5635d LogDS           ds                  inz
/     /copy @mlaudinp
      * Single Key data
/4537d cKeyDataDS      ds            20
/    d  ckBatNum                     10                                         Batch number
/    d  ckSeqNum                      9                                         sequence
/5635d mctcpinf        ds          2000    dtaara
/    d  mc_nodeid                    15

      * Variables -----------------------------------------------------------------------------
J3114d strWldCrd       s              1    inz('*')
/1509d blnSecLnk       s               n   inz(FALSE)

/    d chkObjRtn       s              1

T5783d exitPgmExists   s               n   inz

/    d qualExitPgm     s             21

     D KSL             S              8    DIM(8) CTDATA PERRCD(1)              Keysrt table

     D V               S              1    DIM(99)                              Work array

J7246D qryOpcode       S              5    Dim(10) ctdata PERRCD(1)
J7246D sqlOpcode       S              8    Dim(10) alt(qryOpcode)
      *                                                   of each key

      *                                                  Fltr blank
      *                                                    '0' None
      *                                                  Fltr w/'*'
      *                                                    '1' Generic
      *                                                  Fltr exact mch
      *                                                    '2' Equal

      *                                                  after parsing
     D CR              S              1    DIM(8)                               Compare Result
      *                                                  =  '0' equal
      *                                                  =  '1' not eq


      * -----------------------------------

      * Fulltext Search values
     d @FullText       s             10    inz('@*FULTXT')
     d QueryMode       s               n
     d QueryScan       s               n
     d QueryNoSelect   s               n
     d FullQueryMode   s               n
     d QryGrpTot       s              3  0
     d QueryEscape     s               n                                        escape flag
     D OKq             S              1    dim(MaxQryLn)                        Ok flag for Grps

      * Query selection parms.  All blank if regular filter is passed.
     D AO              S              3    dim(MaxQryLn)                        AND/ORs
     D FN              S             10    dim(MaxQryLn)                        Field names
     D TE              S              5    dim(MaxQryLn)                        Comparators
     D VL              S             30    dim(MaxQryLn)                        Values

     d MATCHS          s              1                                         link matches
     d dbOpCode        s             10                                         db opcode

      * -----------------------------------

      * Window Handle Info
     d wh              s             10i 0
     d WHdl            s                   like(WHandle) dim(MaxHndl)
     d                                       inz(*loval)
     d qfLinkFile      s                   like(whLinkFile) dim(MaxHndl)
     d lastQryF        s                   like(whLinkFile)
/4564d fxNumRev        s             10i 0                                      Number of revisions
      * link mapped fields
     d lmBatNum        s                   based(lmBatNumP  ) like(ldxNam)      Batch num
     d lmLnkSeq        s                   based(lmLnkSeqP  ) like(lxSeq )      Link seq
     d lmCrtDate       s                   based(lmCrtDateP ) like(lxIv8 )      Create date
     d lmTypCode       s                   based(lmTypCodeP ) like(lxTyp )      type code
     d lmStrPage       s              9p 0 based(lmStrPageP )                   starting page/rrn
     d lmEndPage       s              9p 0 based(lmEndPageP )                   ending page/rrn


      * key list buffer
     d wKeyBufrP       s               *

/1767d blnFltDteOnly   s               n    inz(FALSE)
/     * Used to determine if the date only is being filtered
/1767d BlankLink       s                   like(RLnkNdxDS) inz(*blanks)
/1767d intRlnkNdxDs    s             10i 0 inz(*zero)

      * doc class index names
     d lNdxNp          s               *   inz(%addr(lNdxNds))
     d lNdxN           s                   like(lNdxN1) dim(7) based(lNdxNp)
      * link file factors (determines optimal logical file to use)
     d lNdxFp          s               *   inz(%addr(lNdxFds))
     d lNdxF           s                   like(lNdxF1) dim(8) based(lNdxFp)
      * receive message info struct
     d MsgInfo         s            128

      * function return codes
     d rc              s             10i 0
     d rcA             s              2

      * -----------------------------------
      * prototypes


/5921d DistStrPg       s              9s 0                                      dist start page
/    d DistEndPg       s              9s 0                                      dist end page
/    d DistTotPg       s              9s 0                                      dist total pages

     d CMD             s           1024


/4537d ckKeySeq        s              9  0
/    d ckRevID         s             10i 0
/    d ckRevStatus     s                    like(RevStatus)

      * entry parms
     d WHandle         s             11
     d enBig5          s                    like(enBig5x)
     d enBig5xSv       s                    like(enBig5x) inz(*loval)
     d RtnHits         s             10i 0
     d RqstHits        s             10i 0
/4537d enKeyType       s             10
/    d enKeyData       s             20
     d enRevID         s             10i 0
     d DistSegFile     s                    like(enSegFile)
     d RqstBufrP       s               *                                        Request data
      * return data buffer (allocated as needed)
/3765d RtnBufrP        s               *                                        Return data
/    d RtnBufrLn       s             10i 0                                      Return length

/6503d hitSize         s             10i 0
/    d swapP           s               *
/    d fCnt            s             10i 0
/    d fPos            s             10i 0
/    d bCnt            s             10i 0
/    d bPos            s             10i 0

/1767dblnEndOfFile     s               n   inz(FALSE)
/    dprvBatNum        s             10a

J1996d likeWrkIn       ds                  qualified
J1996d  a                             1    dim(125)
J1996d i               s             10i 0
J1996d j               s             10i 0
J1996d k               s             10i 0
J1996d ndxLikeDS       ds
J1996d  ndxLike                        n   dim(maxIndx) inz('0')

J4772d isDigits        pr              n
J4772d  inputDateStr                  8

J4772d positionTo      s             99

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

     c     *ENTRY        PLIST
     c                   PARM                    @FILE            10            Link file
     c                   PARM                    enHandle         10            Window handle
/3679c                   PARM                    ENBIG5x          50            RLnkdef key
     c                   PARM                    OPCODE           10            Opcode
     c                   parm                    CVersID           5            Major/Minor/Vers
     c                   PARM                    SEC               3            Security
/    c                   parm                    RqstBufrP                      Request buffer
/3765c                   parm                    RtnBufrP                       Return buffer
/    c                   parm                    RtnBufrLn                      Return length
     c                   PARM                    eRTNCDE           2            Return code
     c                   PARM                    eMSGID            7            Msg id
     c                   PARM                    eMSGDTA         100            Msg data
      * Optical parms 13-19
     C                   PARM                    OPTID            10
     C                   PARM                    OPTDRV           15
     C                   PARM                    OPTVOL           12
     C                   PARM                    OPTDIR           80
     C                   PARM                    OPTFIL           10            Opt @00...xx
     C                   PARM                    OVRL#             1 0          Ovride lgcl#
     c     RqstHits      parm                    RtnHits                        Rqst/Rtrn Hits
      * parms 20 - 23
/4537c                   parm                    enKeyType                      By Single Key type
/    c                   parm                    enKeyData                      By Single Key data
     c                   parm                    enRevID                        By Single RevID
     c                   PARM                    enSegFile        10            Dst seg file
      * Query parms 24-28
     C                   PARM                    AO                             And/Or
     C                   PARM                    FN                             Field Names
     C                   PARM                    TE                             Test
     C                   PARM                    VL                             Values
     C                   PARM                    QRYTYP            1            Qry type

     c     @PARMS        IFGE      21
     c                   eval      DistSegFile = enSegFile
     c                   else
     c                   eval      DistSegFile = *blanks
     c                   end
     c                   eval      WHandle = enHandle

     c                   in        SPYPCTYP                                     file types
     C                   eval      QueryEscape = *off

/2319C     OPCODE        CASEQ     'INIT'        $INIT
     C     OPCODE        CASEQ     'QUIT'        $QUIT
     C                   ENDCS

      * check if called from OmniLinks Hit server
     C                   if        eMSGID = '*OMNI'
     C                   eval      OmniCaller = 'Y'
     C                   else
     C                   move      *blanks       OmniCaller        1
     C                   end

     c                   callp     RtnSts(R@OK)
     C                   CLEAR                   eRTNCDE
     C                   MOVE      *BLANKS       eMSGID                         Msg id
     C                   MOVE      *BLANKS       eMSGDTA                        Msg data
     C                   CLEAR                   RtnHits
      * Return buffer will be allocated to the size of the "response".
      * It should be deallocated in the caller (SPYCS) after use.
     c                   eval      RtnBufrLn = 0
     c                   callp     mm_free(RtnBufrP:1)

/4537c                   clear                   cKeyDataDS
/    c                   clear                   ckKeySeq
/    c                   clear                   ckRevID
     c                   select
     c                   when      OPCODE = 'SELCR' and
/4537c                               (enKeyType <> *blanks or enRevID <> 0)
/    c                   exsr      GetKeyHit                                    get hit by key
     c                   other
     C     OPCODE        CASEQ     'SELCR'       SELCR                          Start search
     C     OPCODE        CASEQ     'SETLL'       SETXX                          Set lowr lim
     C     OPCODE        CASEQ     'SETGT'       SETXX                          Set greater
     C     OPCODE        CASEQ     'SETEN'       SETXX                          Set end
/8627C     OPCODE        CASEQ     'SETBG'       SETXX                          Set begin
     C     OPCODE        CASEQ     'RDGT '       RDGT                           Read GT
     C     OPCODE        CASEQ     'RDLT '       RDLT                           Read LT
     C     OPCODE        CASEQ     'RDLTX'       RDLT                           Rd LT,Nofill
/3340C     OPCODE        CASEQ     'RDREV'       RDLT                           Rd LT,Reverse
     C     OPCODE        CASEQ     'SKIP '       HITFWD                         Read 1 rec
     C     OPCODE        CASEQ     'SKIPP'       HITBAK                         ReadP 1 rec
     C     OPCODE        CASEQ     'CLEAR'       $CLEAR                         Clear Window
     C                   ENDCS
     c                   endsl

      * CHECK IF ALL HITS REQUESTED WERE FOUND
/3340c                   if        opcode = 'SELCR' or
/    c                             %subst(opcode:1:2) = 'RD' or
/    c                             %subst(opcode:1:2) = 'SK'
/    c                   if        RtnHits < RqstHits
/    c                   callp     RtnSts(R@WARN)                               End of File
/    c                   end
/    c                   end

     C                   EXSR      RETRN

/1509 *------------------------------------------------------------------------
/    c     GetLnkSec     BegSr
/     *------------------------------------------------------------------------
/     * Determine if the DocClass passed is enabled for DocLink Security
      *------------------------------------------------------------------------
J4347                    RMaintKeyds = EnBig5;
J4347                    Chain  %kds( RMaintKeyds ) RMaint;
J4347
J4347                    If ( %found( RMaint ) = TRUE );

                           // Test for a power user
                           // Turn Security off ifn TRUE
/                          If ( *in90 = *on );
                             blnSecLnk = FALSE;
                           Else;
/                            blnSeclnk = ( rsclnk = YES ) and GetSecRule();
                           EndIf;

/                        Else;
/                          blnSecLnk = FALSE;
/                        EndIf;
/    c                   EndSr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RETRN         BEGSR
     C                   if        QueryScan                                    Query?
/5673c                   eval      cmd = 'SETATNPGM PGM(*PRVINVLVL)'
/5673c                   callp     QCMDEXC(cmd:%size(cmd))
     C                   end
     c                   eval      eRTNCDE = wRtnCde                            Return code
     c                   eval      eMSGID  = wRtnID                             Msg id
     c                   eval      eMSGDTA = wRtnDta                            Msg data
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     c     GetKeyHit     begsr
      * fetch spylinks by key (RevID, ContID, LinkSeq)

/4537c                   select
      * by revision
/    c                   when      enKeyType = '*REVID' and enRevID <> 0
/    c                   eval      ckRevID   = enRevID
     c                   if        OK <> GetRevSts(ckRevID:RevStatus)           get status
     c                   callp     RtnSts(R@WARN)                               Not found
     c                   EXSR      RETRN
     c                   end
      * if a WIP, get the Head Rev
     c                   if        Rs_RevID = Rs_WIPID
     c                   if        OK <> GetRevSts(Rs_HeadID:RevStatus)         get status
     c                   callp     RtnSts(R@WARN)                               Not found
     c                   EXSR      RETRN
     c                   end
     c                   end
     c                   eval      ckRevStatus = RevStatus
/    c                   eval      ckBatNum = Rs_BatNum                         Batch number
/    c                   eval      ckKeySeq = Rs_BatSeq                         Start page
      * get/assign another window handle
     c                   move      ckRevID       RevIDa           10
     c                   eval      EnBig5x = x'00'+'REVID    '+RevIDa
     c                   eval      WHandle = '*'+WHandle                        make different
     c                   EXSR      SETHDL                                       Set Window handle
     c                   eval      RevStatus = ckRevStatus                      restore
      * by batch and seq/rrn
/    c                   when      enKeyType = '*IMAGENO' or
/    c                             enKeyType = '*HITSEQ'  or
/    c                             enKeyType = '*BATCH'
/    c                   eval      cKeyDataDS = enKeyData
/9669c                   if        %subst(enBig5x:1:1) <> x'00'
/9669c                   exsr      RtvDocCls
/9669c                   endif
/    c                   testn                   ckSeqNum             66
/    c   66              move      ckSeqNum      ckKeySeq
      * get/assign another window handle
/    c                   eval      WHandle = '*'+WHandle                        make different
/    c                   EXSR      SETHDL                                       Set Window handle
/4537c                   endsl

      * setup query
     c                   clear                   QryRqstDS
     c                   eval      qrFldNam(1) = '@SPYNUM'
     c                   eval      qrCond(1)   = 'EQ'
/    c                   eval      qrValue(1)  = ckBatNum
/    c                   if        ckKeySeq <> 0
     c                   eval      qrAndOr(2)  = 'AND'
/    c                   if        enKeyType = '*HITSEQ'
/    c                   eval      qrFldNam(2) = '@LINKSEQ'
     c                   else
     c                   eval      qrFldNam(2) = '@STARTPAGE'
     c                   end
     c                   eval      qrDtaTyp(2) = 'N'
     c                   eval      qrCond(2)   = 'EQ'
/    c                   eval      qrValue(2)  = %trim(%editc(ckKeySeq:'P'))
     c                   end
     c                   eval      qrType      = 'Q'
     c                   EXSR      CHKQRY

     c                   if        OK <> FmtCrit(whFilterP) or
/5068c                             OK <> ChkCritDate(whFilterP)
     c                   EXSR      RETRN
     c                   end
     c                   eval      LnkMapDSp = whFilterP                        link map
     c                   eval      lmNumRev  = 99999                            Number of revisions
     c                   callp     SetFilter(wh)

      * position by filter
       if whOptLinks;
J4772c                   callp     BuildKey(whFilterP)
J4772c                   EXSR      POSFIL
     c                   eval      RqstHits = 99999
       endif;
     C                   EXSR      HITFWD

      * blank entry
     c                   if        RtnHits = 0
     c                   eval      LnkMapDSp  = whLnkBufP                       link map
     c                   eval      RLnkNdxDSp = lmLnkNdxP                       link buffer
     c                   clear                   RLnkNdxDS
     c                   eval      lmCrtDate = *zeros                           From date
/    c                   eval      lmBatNum  = ckBatNum                         Batch number
     c                   eval      lmLnkSeq  = 0                                Link seq
     c                   eval      lmStrPage = 0                                Start page
     c                   eval      lmEndPage = 0                                End page
/    c                   if        enKeyType = '*HITSEQ'
/    c                   eval      lmLnkSeq  = ckKeySeq                         Link seq
/    c                   else
/    c                   eval      lmStrPage = ckKeySeq                         Start page
/    c                   end
      * build and map link to return buffer
     c                   if        OK = BldHitHdr(ckRevID)                      build hit
/    c                   if        %subst(lmBatNum:1:1) = 'B' and
/    c                             OK = GetDocAttr('READ':ckBatNum:lmStrPage)   get PCATR
     c                   eval      hhPCext   = PCEXT                            PC file extension
     c                   end
      * add to the hit list (by conversation version)
     c                   select
     c                   when      CVersID = CV@DMS71
/7087c                   callp     AddHit71(#AHAddHit)                          7.1 version
J3618c                   when      CVersID = CV@DMS90
J3618c                   callp     AddHit90(#AHAddHit)                          9.0 version
     c                   endsl
     c                   eval      RtnHits = RtnHits + 1
     c                   end
     c                   end

     c                   callp     ClrHandle(GetHandle(WHandle))

     c                   endsr
/9669c*-------------------------------------------------------------------------
/9669c*- RtvDocCls - Retrieve DocClass from either Batch# or Spy#
/9669c*-------------------------------------------------------------------------
/9669c     RtvDocCls     begsr
/9669
/9669c                   if        %subst(ckBatNum:1:1) = 'B'
/1767c     ckbatnum      chain(e)  MImgDir
/9669c                   if        %found
/9669c                   eval      enBig5x = x'00' + 'RTYPEID  ' + idRtyp
/9669c                   endif
/9669
/9669c                   else
/9669
/9669c     ckbatnum      chain(e)  RptDir
/9669c                   if        %found
/9669c                   eval      enBig5x = x'00' + 'RTYPEID  ' + RptTyp
/9669c                   endif
/9669
/9669c                   endif
/9669
/9669c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SELCR         BEGSR
      *          -------------------------------
      *          Start search and pass back hits
      *          -------------------------------
     C                   EXSR      SETHDL                                       Set Window handle

      * check/setup qcriteria (by conversation version)
     c                   clear                   QryRqstDS
     c     @PARMS        IFGE      28
     c                   eval      qrAndOr(*)  = AO(*)
     c                   eval      qrFldNam(*) = FN(*)
     c                   eval      qrCond(*)   = TE(*)
     c                   eval      qrValue(*)  = VL(*)
     c                   eval      qrType      = qrytyp
     c                   end
     c                   EXSR      CHKQRY
      * build record maps
     c                   exsr      BuildMaps

      * build filter criteria (by conversation version)
     c                   select
     c                   when      CVersID = *blanks
     c                   callp     CvtCrit70(whFilterP:RqstBufrP)               7.0 version
J3618c                   when      CVersID >= CV@DMS71
/3765c                   callp     CvtCrit71(whFilterP:RqstBufrP)               7.1 version
     c                   endsl
     c                   if        OK <> FmtCrit(whFilterP) or
/5068c                             OK <> ChkCritDate(whFilterP)
     c                   EXSR      RETRN
     c                   end
/      // Switch to query mode when LIKE condition detected in criteria.
/      //if not queryMode;

J3114    If ( WldCrd <> *blanks );
/          strWldCrd = WLDCRD;
/        EndIf;
/
J1996    reset ndxLike;
/        for i = 1 to maxIndx;
/          k = 0;
/          clear likeWrkIn;
J3399      likeWrkIn = %trim(%str(lmValP(i):lmValLn(i)));
/          if likeWrkIn = ' ';
/            iter;
/          endif;

           // Look for a wildcard at the beginning of the criteria.
J4355      if  likeWrkIn.a(1) = strWldCrd;
J4355        likeWrkIn.a(1) = '%';
J4355        ndxLike(i) = '1';
J4355      endif;
J4355      if %subst(likeWrkIn:%checkr(' ':likeWrkIn):1) = strWldCrd;
J4355        likeWrkIn.a(%checkr(' ':likeWrkIn)) = '%';
J4355        ndxLike(i) = '1';
J4355      endif;

J6722      // Check if a wildcard is at the end of the criteria if one exists
J6722      // at the beginning.
J6722      if ndxLike(i) = '1' and
J6722        %subst(likeWrkIn:%checkr(' ':likeWrkIn):1) = strWldCrd;
J6722          likeWrkIn.a(%checkr(' ':likeWrkIn)) = '%';
J6722      endif;

J4644      if ndxLike(i) = '1';
J4644        memcpy(lmValP(i):%addr(likeWrkIn):lmValLn(i));
J4644      endif;
/        endfor;
/        if ndxLikeDS <> *all'0'; //Like found. Format for query mode.
/          qrCond(*) = 'EQ';
/          for i = 1 to maxIndx;
/            if %str(lmValP(i):lmValLn(i)) = ' ';
/              iter;
/            endif;
/            j = %lookup(' ':qrFldNam);
/            qrFldNam(j) = ln(i);
/            qrValue(j) = %str(lmValP(i):lmValLn(i));
/            if ndxLike(i);
/              qrCond(j) = 'LIKE';
/            endif;
/          endfor;
/          ChkCritDate(whFilterP);
/          if %addr(lmCrtDate) <> *null and lmCrtDate <> ' ';
/            i = %lookup(' ':qrFldNam);
/            qrFldNam(i) = '@SPYDAT';
/            qrCond(i) = 'GE';
/            qrValue(i) = lmCrtDate;
/          endif;
/          if %addr(lmCrtDate2) <> *null and lmCrtDate2 <> ' ';
/            i = %lookup(' ':qrFldNam);
/            qrFldNam(i) = '@SPYDAT';
/            qrCond(i) = 'LE';
/            qrValue(i) = lmCrtDate2;
/          endif;
/          qrAndOr(*) = 'AND';
/          qrType = 'Q';
/          clear qfLinkFile;
/          exsr chkQry;
/          exsr buildMaps;
/        endif;
/      //endif;
/
J4414  If ( ( blnSeclnk = TRUE      ) and
J5023       ( IUSDLS    = YES       ) and
J4414       ( IsQualified() = FALSE )     );
/        eMsgID =  ERR000A;
/        eMsgDta = *blanks;
/        Callp(e) RtnSts( RTNCDE_40 : eMsgID : eMSGDta );
/        ExSr Retrn;
/      EndIf;
     c                   callp     SetFilter(wh)

      * check open file
     c                   if        not whOptLinks                               DASD...
     c                   if        wh <> LastW
     c                               or whLinkFile <> Last@
     c                               or whOpnQryF or lastQryF <> *blanks
     c                               or (not whOptLinks and whFileP = *null)
     c                   MOVE      whLinkFile    Last@            10
     c                   Z-ADD     wh            LastW             3 0
     c                   end
     c                   end

      * position by filter

       if whOptLinks;
     c                   callp     BuildKey(whFilterP)
     C                   EXSR      POSFIL
       endif;
     C                   EXSR      HITFWD

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETXX         BEGSR
      *          -----------------------------------------------
      *          Set file position to logical with complete key.
      *          -----------------------------------------------

        if whOptLinks;
     C                   EXSR      SETHDL
     C                   EXSR      CHKQRY

/8627c                   if        opCode = 'SETEN' or Opcode = 'SETBG'
/8627c                   callp     BuildKey(whFilterP)
/8627c                   else

      * build position to key (by conversation version)
     c                   select
     c                   when      CVersID = *blanks
     c                   callp     CvtCrit70(whPosKeyP:RqstBufrP)               7.0 version
J3618c                   when      CVersID >= CV@DMS71
/3765c                   callp     CvtCrit71(whPosKeyP:RqstBufrP)               7.1 version
     c                   endsl
/5068c                   if        OK <> ChkCritDate(whPosKeyP)
/    c                   EXSR      RETRN
/    c                   end

      * use filter as key if no position to key passed
     c                   eval      LnkMapDSp = whPoskeyP                        link map
     c                   eval      RLnkNdxDSp = lmLnkNdxP                       link buffer
     c                   if        RLnkNdxDS = *blanks  or
     c                             RLnkNdxDS = BlankLink
     c                   callp     BuildKey(whFilterP)
     c                   else
     c                   callp     BuildKey(whPosKeyP)
     c                   end

     C                   ENDIF
     C                   EXSR      POSFIL
       else;
         if opcode = 'SETEN' or opcode = 'SETBG';
           LnkDBread(wh:opcode);
           if opcode = 'SETEN';
             LnkDBread(wh:'READ');
           elseif opcode = 'SETBG';
             LnkDBread(wh:'READP');
           endif;
         endif;
         // Position to operation. Fetch the positioning criteria from
         // the request buffer. Walk through the open cursor and try to match
         // the positioning key.
         if opcode = 'SETLL';
           exsr sethdl;
           LnkDBclose(wh);
           CvtCrit70(whFilterP:RqstBufrP);
           positionTo = %str(lmvalp(1):lmvalln(1));
           LnkDBopen(wh);
         //LnkDBread(wh:'SETBG');
         //LnkDBread(wh:'READP');
         //rcA = LnkDBread(wh:'READ');
         //dow rcA = '00';
         //  if %trim(%str(lmvalp(1):lmvalln(1))) >= %trim(positionTo);
         //    LnkDBread(wh:'READ');
         //    leave;
         //  endif;
         //  rcA = LnkDBread(wh:'READ');
         //enddo;
         //if rcA <> '00';
         //  exsr retrn;
         //endif;
         endif;
       endif;

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RDGT          BEGSR
      *          -----------------------------------------------
      *          Read GT...Restore the saved filter and get hits
      *          -----------------------------------------------
     C                   EXSR      SETHDL
     C                   EXSR      CHKQRY
     C                   EXSR      HITFWD
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RDLT          BEGSR
      *          -----------------------------------------
      *          Read LT (READP for terminal-based access)
      *          -----------------------------------------
     C                   EXSR      SETHDL
     C                   EXSR      CHKQRY
     C                   EXSR      HITBAK

      * Links in buffer are inverted because of read direction. Was more
      * efficient and substantially less coding to do it in this manner.
      * Repositioning file cursor; applying filter or query, etc.
/6503c                   if        rtnHits > 1 and jobtyp = '1'
/    c                   eval      hitSize = rtnBufrLn / rtnHits
/    c                   eval      swapP = mm_alloc(hitSize)
/    c                   eval      fCnt = 1
/    c                   eval      bCnt = rtnHits
/    c                   dou       fCnt >= bCnt
/    c                   eval      fPos = fCnt * hitSize - hitSize
/    c                   eval      bPos = bCnt * hitSize - hitSize
/    c                   callp     memcpy(swapP:rtnBufrP+fPos:hitSize)
/    c                   callp     memmove(rtnBufrP+fPos:rtnBufrP+bPos:hitSize)
/    c                   callp     memmove(rtnBufrP+bPos:swapP:hitSize)
/    c                   eval      fCnt = fCnt + 1
/    c                   eval      bCnt = bCnt - 1
/    c                   enddo
/    c                   callp     mm_free(swapP:0)
/    c                   endif

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     HITFWD        BEGSR
      * Read forward on Spylinks and fill the hit list
J4772c                   if        OK <> BldHitlist(opcode)
     c                   exsr      RETRN
     c                   end
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     HITBAK        BEGSR
      * Read backward (previous) on Spylinks and fill the hit list
     c                   if        OK <> BldHitlist('READP')
     c                   exsr      RETRN
     c                   end
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $CLEAR        BEGSR
      *          Clear window handle
     c                   callp     ClrHandle(GetHandle(WHandle))
     c                   callp     RtnSts(R@OK)
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETHDL        BEGSR
      *          ---------------------------
      *          Set to proper Window Handle
      *          ---------------------------
      * get/assign window handle
     c                   eval      wh = GetHandle(WHandle)
     c                   if        wh = FAIL
     c                   EXSR      RETRN
     c                   end
     C     wh            OCCUR     FLDS

      * convert big5 parm if necessary (VCO interface passes doc type)
     c                   if        EnBig5xSv <> EnBig5x
     c                   eval      EnBig5xSv =  EnBig5x
/3679c                   eval      EnBig5 = CvtBig5(EnBig5x)
     c                   end

/1509c                   ExSr      GetLnkSec

      * get/setup doc class definition
     c                   if        wxBig5 <> EnBig5
     c                              or wxOptID  <> OptID
     c                              or wxOptFil <> OptFil
     c                   if        FAIL = GetDCdef(EnBig5)
     C                   EXSR      RETRN
     c                   end
     c                   eval      wxBig5  =  EnBig5
     c                   eval      wxOptID  = OptID
     c                   eval      wxOptFil = OptFil
     c                   end

      * no @file
     c                   if        not whOptLinks
     c                               and whLinkFile = *blanks
     c                   callp     RtnSts(R@WARN)
     c                   EXSR      RETRN
     c                   end

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     c     BuildMaps     BEGSR
      * setup link mapping structures for this handle
     c                   callp     BldLnkMap(whLnkBufP)                         link buffer
     c                   callp     BldLnkMap(whFilterP)                         filter selection
     c                   callp     BldLnkMap(whPosKeyP)                         position key
     c                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKQRY        BEGSR
      *          --------------------------------------------
      *          Check if program was called to execute query
      *          --------------------------------------------
     c                   callp     QuerySetup
      * If query for optical bring up scan screen
     C                   if        QueryScan
/5673c                   eval      cmd = 'SETATNPGM PGM(SPYESCATN)'
/5673c                   callp     QCMDEXC(cmd:%size(cmd))
     c                   callp     SpyStsMsg('STS0010':QueryStsDS)
     c                   end
     C     *LOCK         IN        SPYESC
     C                   MOVE      *OFF          ESCSTS
     C                   OUT       SPYESC

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CK@FIL        BEGSR
      *          ------------------------------------
      *          Check for the existence of the @FILE
      *          ------------------------------------
     c                   if        not whOptLinks
     c                   if        whLinkFile = *blanks
     c                   callp     RtnSts(R@ERROR)                              No @file
     C                   EXSR      RETRN
     c                   end
     C                   CALL      'MAG1036'
     C                   PARM                    MS1036           80
     C                   PARM                    DTALIB
     C                   PARM                    whLinkFile
     C                   PARM      '*FILE'       APITYP           10
     C     MS1036        IFNE      *BLANKS                                      Not found.
     c                   callp     RtnSts(R@ERROR)
     C                   EXSR      RETRN
     C                   ENDIF
     c                   end
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     POSFIL        BEGSR
      *          ----------------------------------
      *          Position to best start for reading
      *          records from the SpyLink Database
      *          ----------------------------------
     c                   select
     c                   when      OpCode = 'SETGT' or
     c                             OpCode = 'SETEN' or
     c                             OpCode = 'SETBG'
     c                   eval      rc = LnkDBpos(wh:OpCode)
     c                   other
     c                   eval      rc = LnkDBpos(wh:'SETLL')
     c                   endsl
     c                   if        rc = FAIL
     c                   EXSR      RETRN
     c                   end

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2319C     $INIT         BEGSR
/     * BUMP THE INIT COUNT EACH CALL
     c                   if        InitCount = 0                                1st call
     c                   callp     DMSinit
     c                   callp     CSNoteInit
/5921c                   callp     RptDstInit
     c                   eval      rc = ChkNotes('INIT')
     c                   end
/    C                   ADD       1             InitCount         5 0
/    C                   EXSR      RETRN
/    C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $QUIT         BEGSR
      *          -------------------------------------------
      *          Delete overrides, close files and shutdown.
      *          -------------------------------------------
/     * REDUCE THE INIT COUNT EACH CALL
/2319C                   SUB       1             InitCount
/    C     InitCount     IFGT      0                                            NOT YET
     C     BENHER        ORNE      *BLANKS
/    C                   EXSR      RETRN
/    C                   END
     C                   MOVE      *ON           *INLR
     C                   MOVE      'Y'           BENHER            1

      * Close handles and opnqryf
/8724C                   DO        MaxHndl       wh
/    c     wh            occur     WHdlDS
/    c                   if        whFileP <> *null
/    c                   endif
/    c                   callp     ClrHandle(wh)
     C                   ENDDO

      * shutdown sub-programs
J4772   sqlDBquit();
     c                   callp     DMSquit
     c                   callp     CSNoteQuit
/5921c                   callp     RptDstQuit
     c                   eval      rc = ChkNotes('QUIT')
     c                   eval      rc = OptLnkDef('QUIT')
     c                   eval      rcA = OptLnkIO('QUIT')
     c                   eval      rc = SpyLikeTest
     c                   eval      rc = CSFind('QUIT')
     c                   eval      rc = GetWebParms('QUIT')
     c                   eval      rc = GetDocAttr('QUIT')

/                        If ( blnSecLnk = TRUE );
/                          nvpHandler(BH_OP_PUT:BH_NVP_QUIT:' ');
/                          MaSecLnk(nvpHandlerP);
/                          nvpHandler(BH_OP_CLR);
/                        EndIf;
/
/     * If exit program exists send quit.
T5783c                   if        exitPgmExists
/     * Notify the exit program that we are quitting.
/    c                   callp     nvpHandler(BH_OP_PUT:BH_NVP_QUIT:' ')
/    c                   call      qualExitPgm
/    c                   parm                    nvpHandlerP
/     * Issue a clear to deallocate and cleanup the buffer.
/    c                   callp     nvpHandler(BH_OP_CLR)
/    c                   endif

     C                   CALL      'MAG1060'
     C                   PARM      'WRKSPI'      CALPGM
     C                   PARM      'Y'           PGMOFF                                  .

     C                   MOVE      *ON           *INLR
     C                   EXSR      RETRN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

      * At the moment this data area contains the ip address at connect time in
      * spytcpent.
/5635c                   in(e)     mctcpinf

/2395C                   UNLOCK    SPYESC                                       RELEASE AFTER CREATE
/2815C                   UNLOCK    SPYWEB

     C                   IN        SYSDFT                                       Defaults

/1767c                   Eval      intRLnkNdxDS = %size(RLnkNdxDS)
     c
T5783 * Validate exit point data area/program.
/    c                   eval      exitPgmExists = '0'
/    c                   callp     checkObject('MCHITEXIT':pgmlib:'*DTAARA':
/    c                             chkObjRtn)
/    c                   if        chkObjRtn = '0'
/    c                   in(e)     mchitexit
/    c                   if        not %error
/    c                   callp     checkObject(he_pgmNam:he_pgmLib:'*PGM':
/    c                             chkObjRtn)
/    c                   if        chkObjRtn = '0'
/    c                   eval      exitPgmExists = '1'
/    c                   eval      qualExitPgm = %trim(he_pgmLib) + '/' +
/    c                             %trim(he_pgmNam)
/    c                   endif
/    c                   endif
/    c                   endif

      * Get User Authority.  Set *IN90 *ON for power user.
     C                   CALL      'MAG1060'                                    Get USER
     C                   PARM      'WRKSPI'      CALPGM           10             auth.
     C                   PARM      *BLANKS       PGMOFF            1            Set *IN90.
     C                   PARM      'U'           CKTYPE            1            Chk (U)ser
/8304C                   PARM      'A'           FLDRPT            1            Fld or Rpt
     C                   PARM      *BLANKS       FOLDER           10
     C                   PARM      *BLANKS       FOLDRL           10
     C                   PARM      *BLANKS       RNAME            10
     C                   PARM      *BLANKS       JNAME            10
     C                   PARM      *BLANKS       PNAME            10
     C                   PARM      *BLANKS       UNAME            10
     C                   PARM      *BLANKS       UDATA            10
     C                   PARM      0             REQOPT            2 0
     C                   PARM      *BLANKS       AUTRTN            1            Return
     c                   eval      *in90 = (AutRtn = 'Y')

     C                   CALL      'SPYLOUP'                                    Upper/Lower
     C                   PARM                    LO               60            case table
     C                   PARM                    UP               60

      * If SPYPCTYP *DTAARA doesn't exist, create it
     c                   eval      CMD='CHKOBJ OBJ(SPYPCTYP) OBJTYPE(*DTAARA)'
     c                   eval      rc = CLcmd(CMD)
     c                   if        rc = 0
     c                   eval      CrtLib = DtaLib
     c                   eval      CrtObj = 'SPYPCTYP'
     c                   eval      CMD='CRTDTARA DTAARA('+%trimr(CRTLIB)+'/'+
     c                                                    %trimr(CRTOBJ)+') +
     c                                TYPE(*CHAR) LEN(2000) TEXT(''SPYVIEW'')'
      * If filetyp dtaara doesn't exist, create it
     C                   CALL      'MAG1030'
     C                   PARM                    CRTRTN            1
     C                   PARM                    CRTLIB           10
     C                   PARM                    CRTOBJ           10
     C                   PARM      '*DTAARA'     CRTTYP           10
     C                   PARM                    CMD
     c                   end

     c                   in        SPYPCTYP                                     file types

     C                   CALL      'MAG1034'                                    Is this
     C                   PARM      ' '           JOBTYP            1            interactive?

      * setup a blank link record
     c                   eval      RLnkNdxDSp = %addr(BlankLink)
     c                   clear                   RLnkNdxDS

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * build Hit list
     p BldHitlist      b
     d                 pi            10i 0
     d opcode                        10    const


T7279c                   If        %addr(OpCode) = *null
/    c                   Return    FAIL
/    c                   callp     RtnSts(R@WARN)                               End of File
/    c                   EndIf


/7087 * If number of hits not specified, calcualte max per buffer
/    c                   if        RqstHits = 0
/    c                   eval      RqstHits = GetMaxHits
/    c                   endif

       lnkDBopen(wh);

      * do requested number of hits
J4772c                   dou       ( RtnHits >= RqstHits )
      * read a link
       rcA = LnkDBread(wh:opcode);

     c                   select
J4772c                   when       rcA = R@OK
J4772c                   eval       rc = OK
     c                   when       rcA = R@ERROR
     c                   return    FAIL
     c                   when       rcA <> R@OK
     c                                or OPCODE = 'SKIP'
     c                                or OPCODE = 'SKIPP'
     c                   LEAVE                                                  no data
     c                   endsl

      * Query abort check
     c                   if        QueryMode and QueryEscape
     c                   return    OK
     c                   end

      * add hit to list
     c                   if        rc = OK                                      matched
/4779c                   if        fxNumRev >= 99999                            show all revs
/    c                              and ckRevID = 0                             no specific request
/    c                   callp     AddHitMult(OpCode)                           do all revs
/    c                   else
     c                   callp     AddHit(ckRevID)
/    c                   end
     c                   else
      * READE simulation (to end read loop)
     c                   if        not QueryMode
     c                   DO        whMaxEQ       KeyNum            5 0
/9684c                   if        CR(whLfKeyOrd(KeyNum)) = *on and
/9684c                               not whOptLinks
     c                   return    OK
     c                   end
     c                   ENDDO
     c                   end
     c                   ITER
     c                   end

     c                   ENDDO

     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * set return status
     p RtnSts          b
     d                 pi
     d RtnCode                        2    const
     d MsgID                          7    const options(*nopass)
     d MsgData                      100    const options(*nopass)
     c                   clear                   wRtnDS
     c                   eval      wRtnCde = RtnCode
     c                   if        %parms >= 2
     c                   eval      wRtnID  = MsgID
     c                   if        %parms >= 3
     c                   eval      wRtnDta = MsgData
     c                   end
     c                   end
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert big5 key if necessary
/3679p CvtBig5         b
     d                 pi            50
     d Big5                          50    const
      * check for a non-Big5 key
     c                   if        %subst(Big5:1:1) = x'00'
     c                   clear                   RTypID
     c                   select
     c                   when      %subst(Big5:2:9) = 'RTYPEID'                 by report type
     c                   eval      RTypID = %subst(Big5:11)
     c                   when      %subst(Big5:2:9) = 'REVID'                   by revision
     c                   eval      RTypID = RtvDocType(%subst(Big5:11:10))
     c                   endsl
     c                   if        RTypID <> *blanks
     c                   if        not %open(RMaint4)
     c                   open      RMaint4
     c                   end
     c     RTypID        chain     RMaint4                            81
     c                   if        *in81
     c                   clear                   rmBig5
     c                   end
     c                   return    rmBig5
     c                   end
     c                   end
     c                   return    Big5                                         no conversion
/3679p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * setup query processing request
     p QuerySetup      b
     d                 pi

     c                   eval      QueryMode = *off
     c                   eval      QueryScan = *off
     c                   eval      QueryNoSelect = *off
     c                   eval      FullQueryMode = *off
     c                   exsr      QryCheck
     c                   if        QueryMode
     c                   exsr      QrySetup
     c                   end
     c                   return
      * ---------------------------------------------------------------------- *
     C     QryCheck      BEGSR
      *          --------------------------------------------
      *          Check if program was called to execute query
      *          --------------------------------------------
     c                   eval      whOpnQryF = *off
     C                   CLEAR                   qsScanned
     C                   CLEAR                   qsMatched

      * If query parms were passed, check if filter or query
      *    First field name must be non blank for a query
     C                   if        qrFldNam(1) <> *blanks
     c                   eval      QueryMode = *on
      * Check if fulltext search in query
     C     @FullText     LOOKUP    qrFldNam                               50    Eq
     c                   eval      FullQueryMode = *in50
      * Check if opnqryf was requested
     c                   if        not whOptLinks                               DASD...
     c                              and qrType = 'Q'                            QueryFile
     c                   eval      whOpnQryF = *on
     c                   end
      * If query for optical bring up scan screen
     c                   if        JobTyp = '1'                                 Interactive
     c                   if        whOptLinks                                   Optical...
     c                              or qrType = 'S'                             Sequential
     c                              or qrType = 'Q'                             QueryFile
     c                                 and FullQueryMode                        Full text search
     c                   eval      QueryScan = *on                              scanning Query
     c                   end
     c                   end
     c                   end

     C     *LOCK         IN        SPYESC
     C                   MOVE      *OFF          ESCSTS
     C                   OUT       SPYESC

     c                   ENDSR
      * ---------------------------------------------------------------------- *
     c     QrySetup      BEGSR
      *------------------------------------------------------------
      *  If fulltext search was requested, split up comparison
      *  lines. One table for the reqular stuff, one for fulltext.
      *  If later the regular stuff is false, you don't have to do
      *  a fulltext search. This speeds up bigtime.
      *------------------------------------------------------------
      *   Example:   Entry Query  -> Regular Query  +  Full Query
      * Grp Ptr
      * RU FU | G#    Entry        |  RG#   Regular  | FG#   Fulltext
      * ------|--------------------|-----------------|---------------------
      *  1    | 1      idx1 eq 1   |  1    idx1 eq 1 |  1    full ct m ag
      *  2 1  | 2   o  idx1 eq 5   |  2  o idx1 eq 5 |  2  o full ct s oft
      *       |     A  FULL CT mag |  3  O UDX1 EQ 3 |
      *    2  | 3   o  full ct soft|     a idx2 eq 1 |
      *  3    | 4   o  idx1 eq 3   |                 |
      *       |     a  idx2 eq 1   |                 |
      *  ----------------------------------------------------------
     c                   clear                   RegQryDS                       reqular
     c                   clear                   FulTxtDS                       fulltext
     C                   CLEAR                   G#                             Total grps
     C                   CLEAR                   #F                             # of fullsch
     C                   CLEAR                   #R                             # of regular
     C                   CLEAR                   QryGrpTot                      Total groups
     C                   CLEAR                   G#
     C                   CLEAR                   FG#
     C                   CLEAR                   RG#

     C                   DO        MaxQryLn      Q#                5 0
      * Last record
     C                   if        qrFldNam(Q#) = *blanks
     C                   LEAVE
     C                   ENDIF
      * Find next or group and set flags
     C                   if        Q# = 1 or qrAndOr(Q#) = 'OR'
      *     If there is an or group with only *fultext, the
      *     Opnqryf must not do an select for the regular stuff.
     C     Q#            IFNE      1
     C     REGUSE        ANDEQ     ' '
     C     FULUSE        ANDEQ     '1'
     C                   eval      QueryNoSelect = *on
     C                   ENDIF

     C                   ADD       1             G#                3 0          Group #
     C                   CLEAR                   REGUSE                         Regular used
     C                   CLEAR                   FULUSE                         Fulltxt used
     C                   ENDIF

     C                   if        qrFldNam(Q#) = @FullText                     Fulltext
                                                                                ========
     C                   ADD       1             #F                3 0
     C     FULUSE        IFEQ      '1'
     c                   eval      ftAndOr(#F) = 'AND'
     C                   ELSE
     c                   eval      ftAndOr(#F) = 'OR'
     C                   ADD       1             FG#               3 0          Full Grp #
     c                   eval      ftGroup(G#) = FG#
     C                   ENDIF

     c                   if        qrCond(Q#) = 'LIKE' or
     c                             qrCond(Q#) = 'CT'   or
     c                             qrCond(Q#) = 'EQ'
     c                   eval      ftCond(#F) = 'LIKE'
     c                   else
     c                   eval      ftCond(#F) = 'NLIKE'
     c                   end
     c                   eval      ftWord(#F) = qrValue(Q#)                     Word
/2954c                   callp     Qfix(ftWord(#F):'''')
/2954c                   callp     Qfix(ftWord(#F):'"')
     C                   MOVE      '1'           FULUSE            1

     C                   ELSE                                                   Regular
                                                                                ========
     C                   ADD       1             #R                3 0
     C     REGUSE        IFEQ      '1'
     c                   eval      rqAndOr(#R) = 'AND'
     C                   ELSE
     c                   eval      rqAndOr(#R) = 'OR'
     C                   ADD       1             RG#               3 0          Reg Group #
     c                   eval      rqGroup(G#) = RG#
     C                   ENDIF
     c                   eval      rqFldNam(#R) = qrFldNam(Q#)
     c                   eval      rqDtaTyp(#R) = qrDtaTyp(Q#)
     c                   eval      rqCond(#R) = qrCond(Q#)
     c                   eval      rqValue(#R) = qrValue(Q#)
/2954c                   callp     Qfix(rqValue(#R):'''')
/2954c                   callp     Qfix(rqValue(#R):'"')
     C                   MOVE      '1'           REGUSE            1
     C                   ENDIF
     C                   ENDDO

     C                   Z-ADD     G#            QryGrpTot                      Total grps
      *     If there is an or group with only *fultext, the
      *     Opnqryf must not do an select for the regular stuff.
     C     QryGrpTot     IFNE      0
     C     REGUSE        ANDEQ     ' '
     C     FULUSE        ANDEQ     '1'
     C                   eval      QueryNoSelect = *on
     C                   ENDIF

     C                   ENDSR
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * remove/double the quotes
/2954p Qfix            b
     d                 pi
     d val                           30
     d char                           1    const
     c                   if        val <> *blanks
      * remove outer quotes
     c                   if        %subst(val:1:1) = char
     c     ' '           checkr    val           x
     c                   if        x > 1 and %subst(val:x:1) = char
     c                   eval      val = %subst(val:2:x-2)
     c                   end
     c                   end
      * double quote characters
     c                   z-add     1             x                 3 0
     c                   dow       x < %size(val)
     c                   if        %subst(val:x:1) = char
     c                   eval      val = %subst(val:1:x) + char +
     c                                   %subst(val:x+1)
     c                   eval      x = x+1
     c                   end
     c                   eval      x = x+1
     c                   enddo
     c                   end
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Build query command
     p QueryCmd        b
     d                 pi
     d  cmd                        1024

      * Select
     C                   if        rqFldNam(1) <> *blanks
     C                               and not QueryNoSelect                      No select
     C                   CAT       'QRYSLT(''':1 CMD

     C                   DO        MaxQryLn      Q#                5 0

     C                   if        rqFldNam(Q#) <> *blanks and
     C                             rqFldNam(Q#) <> @FullText
      * And/Or
     c                   if        Q# <> 1
     c                   eval      CMD=%trimr(CMD)+' *'+rqAndOr(Q#)
     c                   end
      * Nlike or dc have to be done with *not(iv *eq %wldcrd())
     c                   if        rqCond(Q#) = 'NLIKE' or
     c                             rqCond(Q#) = 'DC'
     c                   eval      CMD=%trimr(CMD)+' *NOT ('
     c                   end

     C                   SELECT
      * Date
     C                   when      rqFldNam(Q#) = '@SPYDAT'
     c                   eval      CMD=%trimr(CMD)+' LXIV8'
      * Spy Number
     c                   when      rqFldNam(Q#) = '@SPYNUM' or
     c                             rqFldNam(Q#) = '@SPYBAT'
     c                   eval      CMD=%trimr(CMD)+' LDXNAM'
      * Starting page
     c                   when      rqFldNam(Q#) = '@STARTPAGE'
     c                   eval      CMD=%trimr(CMD)+' LXSPG'
      * Link Sequence
/4537c                   when      rqFldNam(Q#) = '@LINKSEQ'
/    c                   eval      CMD=%trimr(CMD)+' LXSEQ'

     C                   OTHER
      * Index
     C                   Z-ADD     1             I#                5 0
J4355  if rqCond(Q#) = 'LIKE';
J4355    cmd = %trimr(cmd) + ' %strip(';
J4355  endif;
     C     rqFldNam(Q#)  LOOKUP    LN(I#)                                 66    Eq
     C                   CAT       'LXIV':1      CMD
     C                   MOVE      I#            F1A               1
     C                   CAT       F1A:0         CMD                            Lxiv1..7
J4355  if rqCond(Q#) = 'LIKE';
J4355    cmd = %trimr(cmd) + ' " " *BOTH)';
J4355  endif;
     C                   ENDSL
      * Test
     c                   eval      CMD=%trimr(CMD)+' *'
     C                   SELECT                                                 Comparators
     c                   when      rqCond(Q#) = 'LIKE' or
     c                             rqCond(Q#) = 'NLIKE'
     c                   eval      CMD=%trimr(CMD)+'EQ'                         positive
J7064c     '%':'*'       XLATE(P)  rqValue(Q#)   F70A             70            Use *for%
     c                   eval      CMD=%trimr(CMD)+
J7064c                                           ' %WLDCRD("'+%trimr(F70A)+'")'
     c                   if        rqCond(Q#) = 'NLIKE'
     c                   eval      CMD=%trimr(CMD)+')'
     C                   ENDIF

     c                   when      rqCond(Q#) = 'CT' or
     c                             rqCond(Q#) = 'DC'
     c                   eval      CMD=%trimr(CMD)+
     c                                          'CT "'+%trimr(rqValue(Q#))+'"'
     c                   if        rqCond(Q#) = 'DC'
     c                   eval      CMD=%trimr(CMD)+')'
     c                   end
     c                   when      rqDtaTyp(Q#) = 'N'                           Numeric
     c                   eval      CMD=%trimr(CMD)+ %trimr(rqCond(Q#))+         comparator
     c                                             ' '+%trimr(rqValue(Q#))      /value
     C                   OTHER                                                  Regular
     c                   eval      CMD=%trimr(CMD)+ %trimr(rqCond(Q#))+         comparator
     c                                            ' "'+%trimr(rqValue(Q#))+'"'  /value
     C                   ENDSL

     C                   ENDIF

     C                   ENDDO

     c                   eval      CMD=%trimr(CMD)+''')'
     C                   ENDIF
      *----------
      * Keyfields
     C                   CAT       'KEYFLD(':1   CMD
     C                   MOVE      whLinkFile    F2A               2
     C                   MOVE      F2A           F20               2 0
      * 1st key field
     C                   MOVE      F20           F1A                            Get index #
     C                   EXSR      QRYKEY                                       Add to CMD
      * other key fields
     C                   DO        8             I#                             Index #
     C     I#            IFEQ      F20                                          Not fst key
     C                   ITER
     C                   ENDIF
     C                   MOVE      I#            F1A                            Get Index #
     C                   EXSR      QRYKEY                                       Add to CMD
     C                   ENDDO

      * Add LDXNAM AND LXSEQ as KEYFIELDS
     c                   eval      CMD=%trimr(CMD)+ ' (LDXNAM) (LXSEQ)) +
     c                                                OPTIMIZE(*FIRSTIO)'
     c                   return
      * ---------------------------------------------------------------------- *
     C     QRYKEY        BEGSR
      *          ---------------------------------------
      *          Insert KeyFld for OPNQRYF in CMD string
      *          ---------------------------------------
     C                   CAT       '(LXIV':1     CMD
     C                   CAT       F1A:0         CMD                              Index #
     C     F1A           IFNE      '8'
     C     dcDteDesc     ORNE      'Y'
     C                   CAT       '*ASCEND)':1  CMD
     C                   ELSE
     C                   CAT       '*DESCEND)':1 CMD
     C                   ENDIF
     C                   ENDSR
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * execute a CL command
     p CLcmd           b
     d                 pi            10i 0
     d  cmd                        1024    const                                CL command
     c                   callp     QCMDEXC(cmd:%size(cmd))
     c                   callp     RcvMsg
     c                   return    OK
     c     *pssr         begsr
     c                   callp     RcvMsg
     c                   return    FAIL
     c                   endsr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * receive a message
     p RcvMsg          b
     d                 pi

     d QMHRcvPm        pr                  extpgm('QSYS/QMHRCVPM')
     d  MsgInfo                       1    options(*varsize)                    msg info
     d  MsgInfoLn                    10i 0 const                                msg info length
     d  MsgInfoFmt                    8    const                                msg info format
     d  CStack                       10    const                                call stack entry
     d  CStackC                      10i 0 const                                call stack counter
     d  MsgType                      10    const                                msg type
     d  MsgKey                        4    const                                msg key
     d  WaitTime                     10i 0 const                                wait time
     d  MsgAction                    10    const                                msg action
     d  ErrorDS                       1    options(*varsize)                    API error struct

     c                   callp     QMHRcvPm(MsgInfo:%size(MsgInfo):
     c                                     'RCVM0100':'*':1:'*ANY':*BLANKS:
     c                                      0:'*REMOVE':APIerrDS)

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * send a status message
     p SpyStsMsg       b
     d                 pi
     d  MsgID                         7    const                                msg id
     d  MsgDta                      256    const                                msg data

     d QMHSndPm        pr                  extpgm('QSYS/QMHSNDPM')
     d  MsgID                         7    const                                msg id
     d  MsgF                         20    const                                msg file
     d  MsgDta                        1    const options(*varsize)              msg data
     d  MsgDtaLn                     10i 0 const                                msg data length
     d  MsgType                      10    const                                msg type
     d  CStack                       10    const                                call stack entry
     d  CStackC                      10i 0 const                                call stack counter
     d  MsgKey                        4                                         msg key
     d  ErrorDS                       1    options(*varsize)                    API error struct

     c                   callp     QMHSndPm(msgID:PSCON:
     c                                      msgDta:%size(msgDta):
     c                                      '*STATUS':'*EXT':0:
     c                                      msgKey:APIerrDS)
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * filter link selection
     p LnkFilter       b
     d                 pi            10i 0
     d HdlNbr                         5i 0 const                                handle number
     d OpCode                        10    const                                operation

     d vn              s              5i 0

???   * load old fields
/5000d RV              s             99    dim(11)                              link + date
/1767d                 ds                  inz
/    d FilterValues                 693
/    d VA                            99    dim(7)                               filter
/    d                                     Overlay(FilterValues)
      * load links
     c                   eval      LnkMapDSp = whLnkBufP                        link buffer
     c                   eval      vn = 1
     c                   dow       vn <= %elem(VA) and vn <= dcValCnt
     c                   eval      RV(vn) = %str(lmValP(vn):lmValLn(vn))        data
     c                   eval      vn = vn + 1
     c                   enddo
     c                   eval      RV(8) = lmCrtDate
/5000c                   eval      RV(9) = lmBatNum                             Spy/Bat number
/    c                   eval      RV(10) = %trim(%editc(lmStrPage:'P'))        page/image rrn
/4537c                   eval      RV(11) = %trim(%editc(lmLnkSeq:'P'))         link seq
      * load filter
     c                   eval      LnkMapDSp = whFilterP                        filter criteria
     c                   eval      vn = 1
     c                   dow       vn <= %elem(VA) and vn <= dcValCnt
     c                   eval      VA(vn) = %str(lmValP(vn):lmValLn(vn))        data
     c                   eval      vn = vn + 1
     c                   enddo
      * compare
     C                   EXSR      MATCH
     C                   IF        MATCHS <> *ON
     c                   return    FAIL
     c                   end

     c                   return    OK
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MATCH         BEGSR
      *          ----------------------------------------------
      *          Based on the criteria set MATCHS *ON or *OFF
      *          ----------------------------------------------
     C                   MOVE      *ON           MATCHS                         Default *ON
     c                   eval      CR(*) = *off

      * Match either for query or filter
     c                   if        QueryMode
     c                   EXSR      MCHQRY
     c                   ELSE
     c                   EXSR      MCHFLT
     c                   ENDIF

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MCHFLT        BEGSR
      *          If the record read is not a match set MATCHS *OFF

     C                   DO        7             @                 5 0
     c                   if        VA(@) <> *blanks
     C                   SELECT
     C     lmFltCde(@)   WHENEQ    '1'                                          Generic chk
     c                   if        VA(@) <> %subst(RV(@):1:lmFltLn(@))
     C                   MOVE      *ON           CR(@)                          stop
     C                   MOVE      *OFF          MATCHS
     C                   ENDIF
     C     lmFltCde(@)   WHENEQ    '2'                                          Equal chk
     c                   if        VA(@) <> RV(@)
     C                   MOVE      *ON           CR(@)                          stop
     C                   MOVE      *OFF          MATCHS
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
     C                   ENDDO
      *--------------------
      * Creation date range
      *--------------------
J4602c                   If        ( ( %addr(lmCrtDate) <> *NULL     ) and      Before Range
/    c                               ( lmCrtDate        <> *blanks   ) and
/    c                               ( rv(8)            <  lmCrtDate )     )
     C                   MOVE      *OFF          MATCHS
     C     dcDteDesc     IFNE      'Y'                                           Ascend key
     C     OpCode        ANDeq     'READ'
     C                   MOVE      *OFF          CR(8)                            read more.
     C                   ELSE                                                    Descnd key
     C                   MOVE      *ON           CR(8)                            stop read.
     C                   END
     C                   ENDIF

     c                   if        lmCrtDate2 <> *blanks
     c                              and rv(8) > lmCrtDate2                      after range
     C                   MOVE      *OFF          MATCHS
     C     dcDteDesc     IFNE      'Y'                                           Ascend key
     C     OpCode        ANDeq     'READ'
     C                   MOVE      *ON           CR(8)                            stop read.
     C                   ELSE                                                    Descnd key
     C                   MOVE      *OFF          CR(8)                            read more.
     C                   END
     C                   ENDIF

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MCHQRY        BEGSR
      *          ------------------------------------
      *          Based on the QUERY pass back whether
      *          or not the read record is a match
      *          ------------------------------------
     C                   CLEAR                   OKq
     C                   MOVE      *ON           MATCHS
     C                   CLEAR                   G#
     c                   if        whOpnQryF and FullQueryMode
     c                               or not whOpnQryF
      *------------------------------------------
      * Do compare for every query line (regular)
      *------------------------------------------
     C                   DO        MaxQryLn      Q#                5 0
     C     rqFldNam(Q#)  IFEQ      *BLANKS                                      End reached
     C                   ADD       1             G#                3 0          Or group#
     c                   if        rqGroup(G#) <> 0
     c                   eval      OKq(rqGroup(G#)) = MATCHS
     c                   end
     C                   LEAVE
     C                   ENDIF
      *--------------------------------
      * Do AND/OR group stuff (regular)
      *--------------------------------
     c                   if        rqAndOr(Q#) = 'OR'                           New or group
     C     Q#            IFNE      1                                            Not 1fst rcd
     C                   ADD       1             G#                3 0          Or group#
     c                   eval      OKq(rqGroup(G#)) = MATCHS

      * If group matches and no fullsearch requested get out
     C     MATCHS        IFEQ      *ON
     C                   if        not FullQueryMode
     C                   LEAVE
     C                   ENDIF
      * If group matches and fullsearch requested
      * continue compare for other groups
     C                   ELSE
     C                   MOVE      *ON           MATCHS
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     MATCHS        IFNE      *ON                                          'AND' found
     C     Q#            ANDNE     1                                            not 1fst rcd
     C                   ITER                                                   skip it rcd
     C                   ENDIF
     C                   ENDIF
      *-----------------
      * Get Index Number
      *-----------------
/5000c                   select
/    c                   when      rqFldNam(Q#) = '@SPYDAT'                     Date field
/    c                   eval      i# = 8
/    c                   when      rqFldNam(Q#) = '@SPYNUM' or                  Spy/Bat number
/    c                             rqFldNam(Q#) = '@SPYBAT'
/    c                   eval      i# = 9
/    c                   when      rqFldNam(Q#) = '@STARTPAGE'                  page/image rrn
/    c                   eval      i# = 10
/4537c                   when      rqFldNam(Q#) = '@LINKSEQ'                    Link seq
/    c                   eval      i# = 11
/    c                   other
     C                   Z-ADD     1             I#                5 0          Index #
     C     rqFldNam(Q#)  LOOKUP    LN(I#)                                 50
     c                   if        not *in50
     C                   MOVE      *OFF          MATCHS                         not found
     C                   ITER                                                   not valid
     C                   ENDIF
/5000c                   endsl
      *--------
      * Compare
      *--------
     C                   SELECT
     c                   when      rqCond(Q#) = 'EQ'
     c                   if        RV(I#) <> rqValue(Q#)
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDIF

     c                   when      rqCond(Q#) = 'NE'
     c                   if        RV(I#) = rqValue(Q#)
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDIF

     c                   when      rqCond(Q#) = 'GT'
     c                   if        RV(I#) <= rqValue(Q#)
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDIF

     c                   when      rqCond(Q#) = 'GE'
     c                   if        RV(I#) < rqValue(Q#)
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDIF

     c                   when      rqCond(Q#) = 'LT'
     c                   if        RV(I#) >= rqValue(Q#)
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDIF

     c                   when      rqCond(Q#) = 'LE'
     c                   if        RV(I#) > rqValue(Q#)
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDIF

     c                   when      rqCond(Q#) = 'CT'    or                      Contain
     c                             rqCond(Q#) = 'DC'    or                      Doesn't cnt
     c                             rqCond(Q#) = 'LIKE'  or                      Like
     c                             rqCond(Q#) = 'NLIKE'                         Nlike
/4407c                   if        OK = SpyLikeTest(rqValue(Q#):RV(I#))         like OK
     c                   if        rqCond(Q#) = 'DC' or
     c                             rqCond(Q#) = 'NLIKE'
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDIF
     C                   ELSE                                                   Like not OK
     c                   if        rqCond(Q#) = 'CT' or
     c                             rqCond(Q#) = 'LIKE'
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDIF
     C                   ENDIF

     C                   OTHER                                                  Unknown
     C                   MOVE      *OFF          MATCHS                         Invalid
     C                   ENDSL
     C                   ENDDO
     C                   ENDIF
      *---------------------------------------------------
      * If fullsearch requested and the query still has
      * to be run, call SPYCSFND to check for the fulltext
      *---------------------------------------------------
     C                   MOVE      ' '           DIDFND            1
     C                   if        FullQueryMode                                Do fullsch
     C                   MOVE      *OFF          MATCHS
      *   Check if there is a group that matches, and has no
      *   fulltext search. If found, record is valid.
     C                   MOVE      *ON           NOMATCH           1
     C                   DO        QryGrpTot     Q#
     C                   if        OKq(Q#) = *on or                             Grp is ok
     C                             OKq(Q#) <> *on and rqGroup(Q#) = 0           not req
     C                   MOVE      *OFF          NOMATCH                        setof flag
     C                   ENDIF
      * If group is ok and is not used for fulltext, record is ok
     C                   if        OKq(Q#) = *on and ftGroup(Q#) = 0            OK group
     C                   MOVE      *ON           MATCHS                         Fulltext
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

      * There is no possible match, because all regular groups
      * that did not have FULLTEXT didn't match
     C     NOMATCH       IFEQ      *ON
     C                   MOVE      *OFF          MATCHS
     C                   ELSE

      * Fulltext search required. Read every group.
     C     MATCHS        IFNE      *ON
/5671c                   eval      rc = CSfind('SEARCH':whLnkBufP)
     C                   MOVE      '1'           DIDFND            1            Did fulltxt
     C                   DO        QryGrpTot     Q#
     C                   if        ftGroup(Q#) = 0 or                           No fulltxt
     C                             OKq(Q#) <> *on and rqGroup(Q#) <> 0          not valid
     C                   ITER                                                   Skip grp
     C                   ENDIF
      * Get OK flag from fulltext API retrn parm
     c                   if        %subst(FndGrp:ftGroup(Q#):1) = '1'           valid
     C                   MOVE      *ON           MATCHS
     C                   LEAVE                                                  get out
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *---------------------------------------
      * If interactive, display status message
      *---------------------------------------
     C                   eval      QueryEscape = *off
     C                   if        QueryScan
     C                   ADD       1             qsScanned
     C     MATCHS        IFEQ      *ON
     C                   ADD       1             qsMatched
     C                   ENDIF
     C                   MOVE      qsScanned     F2A               2
      * Check every 100 records if attn key was pressed by checking
      * the SPYESC DTAARA in QTEMP. 1=ATN was pressed.
     C     F2A           IFEQ      '00'
     C     DIDFND        OREQ      '1'                                          Did find
     C                   IN        SPYESC
     C     ESCSTS        IFEQ      *ON                                          Was pressed
     C     *LOCK         IN        SPYESC
     C                   MOVE      *OFF          ESCSTS
     C                   OUT       SPYESC
     C                   OPEN      WRKSPIFM
     C                   EXFMT     CANCEL                                       Cancel?
     C     ANSWER        IFEQ      'Y'                                           Yes
     C     *INKC         OREQ      *ON
     C                   eval      QueryEscape = *on                             escape flag
     C                   ELSE
     C                   WRITE     UNLOCK
     C                   eval      QueryEscape = *off
     C                   ENDIF
     C                   CLOSE     WRKSPIFM
     C                   ENDIF
     c                   callp     SpyStsMsg('STS0010':QueryStsDS)
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Build hit header
     p BldHitHdr       b
     d                 pi            10i 0
     d RevID                         10i 0 const

     d BatNumOK        s               n   static
     d BatNum          s                   static like(idBnum)
/1767d prvBatNum       s                   static like(idBnum)
/1767d prvSeq          s                   static like(LxSeq)
     d SecRDP          s              3    static
     d SecBreakX       s                   static like(SecBreak)
     d SecBreak        ds
     d bFolder                             like(IDFLD)
     d bFolderLib                          like(IDFLIB)
     d bBig5                               like(dcBig5)

J3618  if noteFlagsP = *null;
J3618    noteFlagsP = %alloc(%size(noteFlags));
J3618  endif;
J3618  clear noteFlags;

     c                   eval      LnkMapDSp = whLnkBufP                        link buffer
     c                   clear                   LinkWorkDS
     c                   eval      ldBatNum = lmBatNum                          Batch number
     c                   eval      ldBatRRN = lmStrPage                         Batch RRN

      * get/check revision info
     c                   if        RevID <> 0
     c                   eval      ldRevID = RevID                              specific request
     c                   else
     c                   eval      ldRevID = GetLRevBy_ConID(ldContID)          find RevID
     c                   end
     c                   if        ldRevID <> 0
     c                   if        OK <> GetRevSts(ldRevID:RevStatus)           get status
     c                   return    FAIL
     c                   end
     c                   else
     c                   eval      RevStatus = dcRevStatus                      default
     c                   end
     c                   if        RevID = 0                                    hit list
     c                              and OK <> RevCheck(fxNumRev)                eligibility
     c                   return    FAIL
     c                   end
     c                   eval      ldRevLckSts = Rs_LockSts                     lock status
      * hit header
     c                   clear                   HitHdrDS
     c                   eval      hhFrmDate = lmCrtDate                        From date
     c                   eval      hhBatNum  = lmBatNum                         Batch number
     c                   eval      hhLnkSeq  = lmLnkSeq                         Link seq
     c                   eval      hhStrPage = lmStrPage                        Start page
     c                   eval      hhEndPage = lmEndPage                        End page
     c                   eval      hhSecFlag = sec                              security
     c                   eval      hhLnkFile = %subst(whLinkFile:1:8) + '00'    link file
     c                   eval      hhLnkLib  = DtaLib                           link file library
     c                   eval      hhBig5Key = dcBig5                           Big5 key
     c                   eval      hhLmtScrl = dcLmtScr                         limit scroll
     c                   eval      hhRptTyp  = dcRptTyp                         report type

     c                   select
      * reports
     c                   when      %subst(hhBatNum:1:1) = 'S'
     c                   if        BatNum <> hhBatNum
     c                               or RepInd = *blanks
     c                   eval      BatNum =  hhBatNum
     c     BatNum        CHAIN     MRPTDIR7
     c                   eval      BatNumOK = %found
     c                   end
     c                   if        not BatNumOK
     c                               or IDSts = '1'                             Batch is open
/1767c                   Callp(e)  SpyStsMsg( 'ERR9901'
/    c                                       : 'Batch ' + BatNum
/    c                                       + ' not found in MIMGDIR')
/1767c                   If        ( BatNum = PrvBatNum ) and
/    c                             ( LxSeq  = PrvSeq    )
/    c                   Eval      blnEndOfFile = TRUE
/    c                   Else
/    c                   Eval      blnEndOfFile = FALSE
/    c                   EndIf
     c
/1767c                   Eval      PrvBatNum = BatNum
/1767c                   Eval      PrvSeq    = LxSeq
     c                   return    FAIL
     c                   end

J2746c                   if        rtvImgCrtTim = YES
J1798c                   eval      hhToDate = %subst(%editc(timfop:'X'):4:6)
J2746c                                      + '00'
J2746c                   EndIf

      * Check and convert to distribution page numbers
J69  c                   if        OK <> ChkDistLink(hhBatNum:
/5921c                                               hhStrPage:hhEndPage:
/    c                                     DistStrPg:DistEndPg:DistTotPg)
/    c                   return    FAIL
/    c                   end
     c                   eval      hhTypCde  = '0'                              type code
     c                   eval      hhLocCde  = RepLoc                           location code
/2763c     RDTSTR        IFNE      *BLANKS                                      data stream
/2763c                   eval      hhPCext   = RDTSTR
/2763c                   ELSE
     c                   eval      hhPCext   = 'RPT'                            SCS
/2763c                   ENDIF
     c                   eval      hhTotPag  = totpag                           total pages
      * Fixup conversion R/DARS and ImageView links (Spoof the page range)
     c                   if        hhLocCde = '4' or                            R/DARS Optical
     c                             hhLocCde = '5' or                            R/DARS QDLS
     c                             hhLocCde = '6'                               ImageView Optical
     c                   move      hhStrPage     hhRDARoff                      true start page
     c                   move      hhEndPage     hhRDARfil                      true end page
     c                   eval      hhStrPage = 1                                spoof Start page
     c                   eval      hhEndPage = 9999999                          spoof End page
     c                   end
     c                   eval      bFolder    = FLDR
     c                   eval      bFolderLib = FLDRLB
/7563c                   eval      bBig5 = hhbig5key
      * image/documents
     c                   when      %subst(hhBatNum:1:1) = 'B'
     c                   if        BatNum <> hhBatNum
     c                               or idBnum = *blanks
     c                   eval      BatNum =  hhBatNum
     c     BatNum        CHAIN     MIMGDIR
     c                   eval      BatNumOK = %found
     c                   end
     c                   if        not BatNumOK
     c                               or IDSts = '1'                             Batch is open
     c                   return    FAIL
     c                   end
     c                   eval      hhTypCde  = '1'                              type code
     c                   eval      hhLocCde  = IdiLoc                           location code
     c                   if        lmTypCode = 'S'
/7419c                   eval      hhPCext   = 'TIF'                            Image
     c                   else
     c                   eval      hhPCext   = GetPCext(lmTypCode)              PC file extension
     c                   end
     c                   eval      bFolder    = IDFLD
     c                   eval      bFolderLib = IDFLIB
/7563c                   eval      bBig5 = BatNum

J1798c                   If        rtvImgCrtTim = 'Y'

J2746c                   If        GetDocAttr('READ':hhBatNum:hhStrPage) = OK
J1798c                   eval      hhToDate = pctime
J2746c                   EndIf

J1789c                   EndIf

     c                   endsl

      * check security
     c                   exsr      ChkSecurity
     c                   if        SecRDP = 'NNN'
     c                   return    FAIL
     c                   end
     c                   eval      hhSecFlag = SecRDP                           security
      * set notes code
J3618  if cVersID >= CV@DMS90;
J3618    if chkNotes('CHKNT':hhNoteCde:noteFlagsP) <> OK;
J3618      return FAIL;
J3618    endif;
J3618    hitHdrDS_2 = hitHdrDS;
J3618    %str(%addr(hitHdrDS_2.hhHasBlackout):%size(noteFlags)+1) = noteFlags;
J3618  else;
     c                   if        OK <> ChkNotes('CHKNT':hhNoteCde)            set notes code
     c                   return    FAIL
     c                   end
J3618c                   endif

     c                   return    OK
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ChkSecurity   BEGSR
      *          Check user authority for folder/report.

     c                   if        SecBreakX <> SecBreak
     c                   eval      SecBreakX =  SecBreak
     C                   Z-ADD     25            REQOPT
     C                   EXSR      @CSEC
     C     AUTRTN        IFEQ      'N'                                          Can't touch
     C                   MOVE      'NNN'         SecRDP
     C                   ELSE                                                   Can we
     C                   Z-ADD     12            REQOPT                          print.....?
     C                   EXSR      @CSEC
     C     AUTRTN        IFEQ      'Y'                                            Yes
     C                   MOVE      'YNY'         SecRDP                            Rd & Prt
     C                   ELSE                                                     No
     C                   MOVE      'YNN'         SecRDP                            Read only
     C                   END
     C                   END
      * If SEGFILE has a value, pgm WRKRSL has "pre-authorized"
      * this link.  User has this segment distributed to him.
     C     DistSegFile   IFNE      *BLANKS                                      Distr link
/7563c     DistSegfile   andne     *allx'00'
     C     DistSegFile   ANDNE     '*ALL'
     C     SecRDP        ANDEQ     'NNN'
     C                   MOVE      'YNY'         SecRDP
     C                   END

     c                   end
     C                   MOVE      SecRDP        SEC                            Return val.

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CSEC         BEGSR
      *          Check user authority for folder/report.
     C                   CALL      'MAG1060'
     C                   PARM      'SPYCSLNK'    CALPGM           10            Caller
     C                   PARM      *BLANKS       PGMOFF            1            Unload Pgm
     C                   PARM      'R'           CKTYPE            1            Chk Type
     C                   PARM      'R'           FLDRPT            1            Fld or Rpt
     C                   PARM                    bFolder          10            Folder
     C                   PARM                    bFolderLib       10            Folder lib
     C                   PARM      rRNAM         rRNAMx           10            Big5
     C                   PARM      rJNAM         rJNAMx           10             :
     C                   PARM      rPNAM         rPNAMx           10             :
     C                   PARM      rUNAM         rUNAMx           10             :
     C                   PARM      rUDAT         rUDATx           10             :
     C                   PARM                    REQOPT            2 0          Reqst Opt
     C                   PARM      *BLANKS       AUTRTN            1            Auth return
     C                   ENDSR
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get the PC file extension from the link's doc type
     p GetPCext        b
     d                 pi             5a
     d LnkCode                        1    const                                Doc link code
     d IntChr          ds                  inz
     d Int                            5i 0
     C                   move      lnkCode       IntChr
     c                   return    PCtype(Int+1)
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert selection criteria (filter or position to) - (7.0 version)
/2924p CvtCrit70       b
     d                 pi
     d CritMapP                        *   const                                buffer/map
     d RqsBufrP                        *   const                                request buffer
      * "MoreLinks" style Spylinks Criteria structure
/2924d LnkCriDS        ds                  based(LnkCriDSp)
     d  lcHdrSiz                      5  0
     d  lcCrtDtF                      8                                         Create From Date
     d  lcCrtDtT                      8                                         Create To Date
     d  lcCriCnt                      5  0                                      Criteria key count
     d  lcCriLen                      5  0                                      Criteria length

      * "MoreLinks Web" style Spylinks Criteria structure
/2924d LnkCriWDS       ds                  based(LnkCriWDSp)
     d  lwHdrSiz                      5  0
/    d  lwBatNum                     10                                         Batch number
/    d  lwLnkSeq                      9  0                                      Link Seq
     d  lwCrtDtF                      8                                         Create From Date
     d  lwCrtDtT                      8                                         Create To Date
     d  lwCriCnt                      5  0                                      Criteria key count
     d  lwCriLen                      5  0                                      Criteria length

     d HdrSizDS        ds                  based(HdrSizDSp)
     d HdrSiz                         5  0
     d CVBufrP         s               *                                        Crit Val buffer

T7279c                   If        (CritMapP = *null) or
/    c                             (RqsBufrP  = *null)
/    c                   Callp(e)  MsgLog('CvtCrit70 received null pointers'
/    c                                     + LF)
/    c                   callp     RtnSts(R@WARN)                               End of File
/    c                   Return
/    c                   EndIf

     c                   eval      LnkMapDSp = CritMapP                         link map
     c                   eval      RLnkNdxDSp = lmLnkNdxP                       link buffer
     c                   clear                   RLnkNdxDS
      * check structure passed
     c                   eval      HdrSizDSp = RqsBufrP
     c                   testn                   HdrSizDS             66
     c                   if        not *in66
     c                   return
     c                   end

      * indentify structure and parse criteria data
     c                   select
      * version 1 "MoreLinks" structure
     c                   when      HdrSiz = %size(LnkCriDS)
     c                   eval      LnkCriDSp  = RqsBufrP
     c                   eval      lmBatNum = *blanks                           Spy/Bat nbr
     c                   eval      lmLnkSeq = 0                                 Link Seq
     c                   eval      lmCrtDate  = lcCrtDtF                        Create From Date
     c                   eval      lmCrtDate2 = lcCrtDtT                        Create To Date
     c                   eval      CVBufrP = LnkCriDSp + lcHdrSiz               start of values
     c                   callp     CvtCritVal(CVBufrP:lcCriCnt:lcCriLen)
      * version 2 "MoreLinks Web" structure
/    c                   when      HdrSiz = %size(LnkCriWDS)
/    c                   eval      LnkCriWDSp = RqsBufrP
/    c                   eval      lmBatNum = lwBatNum                          Batch number
/    c                   eval      lmLnkSeq = lwLnkSeq                          Link Seq
     c                   eval      lmCrtDate  = lwCrtDtF                        Create From Date
     c                   eval      lmCrtDate2 = lwCrtDtT                        Create To Date
     c                   eval      CVBufrP = LnkCriWDSp + lwHdrSiz              start of values
     c                   callp     CvtCritVal(CVBufrP:lwCriCnt:lwCriLen)
     c                   endsl

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert selection criteria (filter or position to) - (7.1 version)
/2924p CvtCrit71       b
     d                 pi
     d CritMapP                        *   const                                buffer/map
     d RqsBufrP                        *   const                                request buffer
      * Extended Spylinks Criteria structure
/2924d LnkCriDS        ds                  based(LnkCriDSp)
     d  lcHdrSiz                      5  0
     d  lcCrtDtF                      8                                         Create From Date
     d  lcCrtDtT                      8                                         Create To Date
     d  lcCriCnt                      5  0                                      Criteria key count
     d  lcCriLen                      5  0                                      Criteria length
     d  lcNumRev                      5  0                                      Number of revisions

     d HdrSizDS        ds                  based(HdrSizDSp)
     d HdrSiz                         5  0
     d CVBufrP         s               *                                        Crit Val buffer

T7279c                   If        (CritMapP = *null) or
/    c                             (RqsBufrP  = *null)
/    c                   Callp(e)  MsgLog('CvtCrit71 received null pointers'
/    c                                     + LF)
/    c                   callp     RtnSts(R@WARN)                               End of File
/    c                   Return
/    c                   EndIf

      * setup from/to data
     c                   eval      LnkMapDSp = CritMapP                         link map
     c                   eval      RLnkNdxDSp = lmLnkNdxP                       link buffer
     c                   clear                   RLnkNdxDS
      * check structure passed
     c                   eval      HdrSizDSp = RqsBufrP
     c                   testn                   HdrSizDS             66
     c                   if        not *in66
     c                   return
     c                   end

      * indentify structure and parse criteria data
     c                   select
      * "MoreLinks" structure
     c                   when      HdrSiz = %size(LnkCriDS)
     c                   eval      LnkCriDSp  = RqsBufrP
     c                   eval      lmBatNum = *blanks                           Spy/Bat nbr
     c                   eval      lmLnkSeq = 0                                 Link Seq
     c                   eval      lmCrtDate  = lcCrtDtF                        Create From Date
     c                   eval      lmCrtDate2 = lcCrtDtT                        Create To Date
     c                   eval      lmNumRev   = lcNumRev                        Number of revisions
     c                   eval      CVBufrP = LnkCriDSp + lcHdrSiz               start of values
     c                   callp     CvtCritVal(CVBufrP:lcCriCnt:lcCriLen)
     c                   endsl

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert criteria values
     p CvtCritVal      b
     d                 pi
     d CVBufrP                         *   const                                Crit Val buffer
     d CVcnt                          5i 0 const                                Crit Val count
     d CVlen                          5i 0 const                                Crit Val length

     d lxCriVal        s          32767    based(lxCriValP)                     Criteria value

     d cValue          s          32767    based(cValueP)                       Criteria value
     d vCnt            s              5i 0                                      Crit Val count
     d vLen            s              5i 0                                      Crit Val length

     c                   if        CVcnt > 0 and CVlen > 0                      values
     c                   eval      vLen = CVlen / CVcnt
     c                   eval      lxCriValP = CVBufrP                          start of values
     c                   eval      vCnt = 0
     c                   dow       vCnt < CVCnt and vCnt < %elem(lmValP)
     c                   eval      vCnt = vCnt+1
     c                   eval      cValueP = lmValP(vCnt)
     c                   eval      %subst(cValue:1:lmValLn(vCnt))
     c                                       = %subst(lxCriVal:1:vLen)
     c                   eval      lxCriValP = lxCriValP + vLen                 next value
     c                   enddo
     c                   end
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * format criteria values
     p FmtCrit         b
     d                 pi            10i 0
     d CritMapP                        *   const                                buffer/map
      * Original interface (<=6.6) FILTER values
     d slFilter        ds
     d  slVal                        99    DIM(7)                               Filter Values
     d  slCrtDtF                      8                                         Create From Date
     d  slCrtDtT                      8                                         Create To Date
     d  slBatNum                     10                                         Batch number
     d  slLnkSeq                      9  0                                      Link Seq

     d cValue          s          32767    based(cValueP)                       Criteria value
     d  vn             s              5i 0



T7279c                   If        (CritMapP = *null)
/    c                   Callp(e)  MsgLog('FmtCrit received null pointer'
/    c                                     + LF)
/    c                   callp     RtnSts(R@WARN)                               End of File
/    c                   Return    FAIL
/    c                   EndIf

      * build original filter
     c                   eval      LnkMapDSp  = CritMapP                        link map
     c                   clear                   slFilter
     c                   eval      slCrtDtF = lmCrtDate                         Create From Date
     c                   eval      slCrtDtT = lmCrtDate2                        Create To Date
     c                   eval      slBatNum = lmBatNum                          Batch number
     c                   eval      slLnkSeq = lmLnkSeq                          Link Seq
     c                   eval      vn = 1
     c                   dow       vn <= %elem(slVal)
     c                   eval      slVal(vn) = %str(lmValP(vn):lmValLn(vn))
     c                   eval      vn = vn + 1
     c                   enddo

      * SpyWeb filter values
     c                   if        swWEBAPP <> *blanks and swWEBUSR <> *blanks  Web env.
/4569c                              and OmniCaller <> 'Y'
J3055c                              and enKeyType <> '*HITSEQ'
     C                   CALL      'SPYWBFLT'    PLFLT
     C     PLFLT         PLIST
     C                   PARM      'CHECK'       WEBOPC           10            Opcode
     C                   PARM                    swWEBAPP                       Web Applic.
     C                   PARM                    swWEBUSR                       Web User
     C                   PARM                    dcBig5                         RLnkdef key
     C                   PARM      '*SPYLINK'    WEBTYP           10            Object Type
     C                   PARM                    slFilter                       Logut filter
     C                   PARM                    WEBRTN            2            Return CODE
     C                   PARM                    WEBMSG            7            Return Msg
     C                   PARM                    WEBDTA          128            Retn Msg Dta
     C     WEBMSG        IFNE      *BLANKS
     c                   callp     RtnSts(WebRtn:WebMsg:WebDta)
     c                   return    FAIL
     C                   ENDIF
     c                   end

/6001c                   eval      ldBig5 = dcBig5ld

/8793 * prepare parameters for call to FMTIVAL
/8793 *    DASD
/8793c                   if        not whOptLinks
/8793c                   eval      fm_rnam = lRNAM
/8793c                   eval      fm_jnam = lJNAM
/8793c                   eval      fm_pnam = lPNAM
/8793c                   eval      fm_unam = lUNAM
/8793c                   eval      fm_udat = lUDAT
/8793c                   eval      offseq = 0
/8793c                   else
/8793 *    optical
/8793c                   eval      fm_rnam = lorptn
/8793c                   eval      fm_jnam = lojobn
/8793c                   eval      fm_pnam = lopgmn
/8793c                   eval      fm_unam = lousrn
/8793c                   eval      fm_udat = lousrd
/8793c                   eval      offseq = loseq
/8793c                   endif

/     * CS client needs additional pass to format numerics
/5014c                   if        %subst(wHandle:1:6) <> 'WRKSPI'              not green screen
/    c                   eval      OPTCDE = 'CHARCHK'
/    c                   CALL      'FMTIVAL'     pFMTIVAL               50
/    c                   end
/    c                   eval      OPTCDE = 'NUM'
/    c                   CALL      'FMTIVAL'     pFMTIVAL               50

/8793 * FMTIVAL parm list for DASD links
/8793c     pFMTIVAL      plist
/8793C                   PARM                    fm_rnam          10            Big5
/8793C                   PARM                    fm_jnam          10             :
/8793C                   PARM                    fm_pnam          10             :
/8793C                   PARM                    fm_unam          10             :
/8793C                   PARM                    fm_udat          10             :
     C                   PARM                    slVal(1)                       Search args
     C                   PARM                    slVal(2)
     C                   PARM                    slVal(3)
     C                   PARM                    slVal(4)
     C                   PARM                    slVal(5)
     C                   PARM                    slVal(6)
     C                   PARM                    slVal(7)
     c                   PARM                    OPTCDE           10
     c                   PARM      *blanks       FMTRTN            1
/8793c                   PARM                    OFFSEQ            5 0

      * update criteria
     c                   eval      lmCrtDate  = slCrtDtF                        Create From Date
     c                   eval      lmCrtDate2 = slCrtDtT                        Create To Date
     c                   eval      lmBatNum   = slBatNum                        Batch number
     c                   eval      lmLnkSeq   = slLnkSeq                        Link Seq
     c                   eval      vn = 1
     c                   dow       vn <= %elem(slVal)
     c     LO:UP         XLATE     slVal(vn)     slVal(vn)                      UPPERCASE
     c                   eval      cValueP = lmValP(vn)
     c                   eval      %subst(cValue:1:lmValLn(vn)) = slVal(vn)
     c                   eval      vn = vn + 1
     c                   enddo

     c                   return    OK
     c     *pssr         begsr
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   endsr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * check criteria date
/5068p ChkCritDate     b
     d                 pi            10i 0
     d CritMapP                        *   const                                buffer/map
T7279c                   If        (CritMapP = *null)
/    c                   Callp(e)  MsgLog('ChkCritDate received null pointer'
/    c                                     + LF)
/    c                   callp     RtnSts(R@WARN)                               End of File
/    c                   Return    FAIL
/    c                   EndIf

     c                   eval      LnkMapDSp  = CritMapP                        link map

      * from/to create dates
/3982c                   if        lmCrtDate  = '00000000' and
/    c                             lmCrtDate2 = '99999999'
/    c                   eval      lmCrtDate  = *blanks
/    c                   eval      lmCrtDate2 = *blanks
/    c                   end
     c                   if        lmCrtDate  = 'YYYYMMDD'
     c                   eval      lmCrtDate  = *blanks
     c                   end
     c                   if        lmCrtDate2 = 'YYYYMMDD'
     c                   eval      lmCrtDate2 = *blanks
     c                   end

     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * setup filter criteria
     p SetFilter       b
     d                 pi
     d HdlNbr                         5i 0 const                                handle number

     d cValue          s          32767    based(cValueP)                       Criteria value
     d vn              s              5i 0

???   * old filter array
     d VA              s             99    dim(7)                               filter

      * load filter
     c                   eval      LnkMapDSp = whFilterP                        filter criteria
     c                   eval      vn = 1
     c                   dow       vn <= %elem(VA) and vn <= dcValCnt
     c                   eval      VA(vn) = %str(lmValP(vn):lmValLn(vn))        data
     c                   eval      vn = vn + 1
     c                   enddo

      * process
     C                   EXSR      SETFLT

      * update filter
     c                   eval      vn = 1
     c                   dow       vn <= %elem(VA) and vn <= dcValCnt
     c                   eval      cValueP = lmValP(vn)
     c                   eval      %subst(cValue:1:lmValLn(vn)) = VA(vn)        data
     c                   eval      vn = vn + 1
     c                   enddo

/4564c                   eval      fxNumRev = lmNumRev                          Number of revisions

     c                   return
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETFLT        BEGSR
      *          --------------------------------
      *          Set the filter array descriptors
      *          --------------------------------
     C                   CLEAR                   IK
     c                   clear                   whLfNbr                        logical file nbr
     c                   clear                   whMaxEQ

J3114c                   If        WLDCRD <> *blanks
/    c                   Eval      strWldCrd =WLDCRD
/    c                   EndIf

     c                   eval      lmFltCde(*) = '0'
     C                   DO        7             @                 5 0          Load IG:
     C     VA(@)         IFNE      *BLANKS                                       0-no arg
     C     ' '           CHECKR    VA(@)         @2                5 0    50     1-part arg
     C     *IN50         IFEQ      *ON                                           2-full arg
     C     1             SUBST     VA(@):@2      F1A               1
      *                                                                         What type?
J3114C     F1A           IFNE      strWldCrd
     C                   MOVE      '2'           lmFltCde(@)                    EQUAL type,
     C                   ELSE                                                      full arg.
     C     @2            IFEQ      1
     C                   CLEAR                   VA(@)                          * in FIRST
     C                   ITER                                                    position.
     C                   ENDIF
     C     @2            IFGT      dcValLn(@)                                   Arg is FULL,
     C                   MOVE      '2'           lmFltCde(@)                    EQUAL type.
     C     dcValLn(@)    SUBST(P)  VA(@)         VA(@)                           Remove *.
     C                   ITER
     C                   END
     C                   MOVE      '1'           lmFltCde(@)                    * after
     C     @2            SUB       1             lmFltln(@)                      1st pos,
     C                   MOVEA     VA(@)         V                              Generic
     C                   MOVE      ' '           V(@2)                          type
     C                   MOVEA     V             VA(@)                          partial arg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO

      *----------------------------------------------------------------
      * IF WRKSPI has not overridden the logical file #...
      * Set FO, the logical File to Open (one w/ lowest SFACTR).
      *  Compute SFACTR, search factor, for each logical, based on
      *  the uniqueness of a single value in the db key and the
      *  completeness of the search argument given by the user.
      *----------------------------------------------------------------
     C     OVRL#         IFGT      0                                            WRKSPI says
     C                   Z-ADD     OVRL#         whLfNbr                        LF to use
     C                   ELSE
     C                   Z-ADD     *HIVAL        LOFACT           15 5          Start high.
     C                   DO        7             @
     C     lmFltCde(@)   IFNE      '0'                                          Arg present
     C                   if        whLfFactors(@) = 0                           Db file fact
     C                   Z-ADD     1             @FFACT            5 4           default.
     C                   ELSE
     C                   eval      @FFACT = whLfFactors(@)
     C                   END
     C     lmFltLn(@)    IFEQ      0                                            Search arg
     C                   Z-ADD     dcValLn(@)    @ARGWD            3 0          width.
     C                   ELSE
     C                   Z-ADD     lmFltLn(@)    @ARGWD
     C                   END

     C     dcValLn(@)    DIV       @ARGWD        SFACTR           15 5          TotWid/ArgWd
     C                   MULT      @FFACT        SFACTR                         X FileFactor

     C     SFACTR        IFLE      LOFACT                                       Use this
     C                   Z-ADD     SFACTR        LOFACT                         logical.
     C                   Z-ADD     @             whLfNbr
     C                   END
     C                   END
     C                   ENDDO

J3728C                   if        whLfNbr = 0 or
J3728C                             (whLfFactors(8) <> 0 and (lmCrtDate <> ' ' or
J3728C                             lmCrtDate2 <> ' '))
     C     lmCrtDate     IFNE      *BLANKS
     C     lmCrtDate2    ORNE      *BLANKS
J3728C                   if        whLfFactors(8) <> 0
J3728C                   eval      sfactr = 1 * whLfFactors(8)
J3728C                   if        sfactr <= lofact
J3728C                   eval      whlfnbr = 8
J3728C                   endif
J3728C                   else
     C                   Z-ADD     8             whLfNbr
J3728C                   endif
     C                   ELSE
     C                   Z-ADD     1             whLfNbr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * logical file selection
     c                   Z-ADD     whLfNbr       OVRL#                          For WRKSPI.
     c                   eval      whLfFltCde = lmFltCde(whLfNbr)               For MAG1081.
     c                   MOVE      whLfNbr       wrk2a             2
     c                   MOVE      wrk2a         whLinkFile                     Logical to open
     c                   movea     KSL(whLfNbr)  whLfKSL                        lf key order

      * READE partial keylist count
     C                   MOVE      '0'           NOEQ              1
     C                   Z-ADD     1             PIK               3 0
     C                   DO        8             @                              Find the 1st
     C                   Z-ADD     whLfKeyOrd(@) @2                             generic fld
     C                   Z-ADD     PIK           IK(@2)                         of the
     C                   ADD       IL(@2)        PIK                            selected
     C     lmFltCde(@2)  IFEQ      '2'                                          logical
     C     LN(@2)        OREQ      *BLANKS
     C     NOEQ          IFEQ      '0'                                          Exact match
     C                   ADD       1             whMaxEQ
     C                   ENDIF
     C                   ELSE
     C     lmFltCde(@2)  IFEQ      '1'                                          Generic
     C     NOEQ          ANDEQ     '0'                                          match
     C                   ADD       1             whMaxEQ
     C                   ENDIF
     C                   MOVE      '1'           NOEQ                           Blnk/generic
     C                   ENDIF
     C                   ENDDO

      * Close last QRYF
     c                   eval      lastQryF = qfLinkFile(wh)
     c                   if        qfLinkFile(wh) <> *blanks
     c                   eval      qfLinkFile(wh) =  *blanks
     C                   end

     c                   if        whOpnQryF                                    open query file
     c                   eval      qfLinkFile(wh) = whLinkFile
     c                   end

     C                   ENDSR
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * build key list buffer for positioning
     p BuildKey        b
     d                 pi
     d KeyMapP                         *   const                                buffer/map

     d cValue          s          32767    based(cValueP)                       Criteria value
     d vn              s              5i 0

???   * old key fields
     d VA              s             99    dim(7)
     d                 ds
     d  ALFA                   1      5
     d  PACK                   1      5P 0

      * setup key data
     c                   eval      LnkMapDSp = KeyMapP                          filter criteria
     c                   eval      vn = 1
     c                   dow       vn <= %elem(VA) and vn <= dcValCnt
     c                   eval      VA(vn) = %str(lmValP(vn):lmValLn(vn))        data
     c                   eval      vn = vn + 1
     c                   enddo
     c                   eval      wKeyBufrP = lmLnkNdxP                        key buffer
     c                   clear                   wKeyList                       key list

J4355  if queryMode;
J4355    for @2 = 1 to 8;
J4355      if @2 = 1;
J4355        qIK(@2) = 1;
J4355      endif;
J4355      if @2 > 1;
J4355        qIK(@2) = qIK(@2-1)+99;
J4355      endif;
J4355      if @2 < 8 and qIL(@2) > 1;
J4355        qIL(@2) = 99;
J4355      endif;
J4355    endfor;
J4355  endif;
      *          ----------------------------------
      *          Position to best start for reading
      *          records from the SpyLink Database
      *          ----------------------------------
     C                   DO        8             @                 5 0          Set up
     C                   Z-ADD     whLfKeyOrd(@) @2                5 0          the KEYSET
     C     @2            IFGT      0
     C                   Z-ADD     IK(@2)        @3                5 0          keylist
J4355  if queryMode;
J4355    @3 = qIK(@2);
J4355  endif;
     C                   SELECT
     C     @2            WHENNE    8
     C                   MOVEA     VA(@2)        KV(@3)
/8627c                   if        OpCode='SETEN' or OpCode='SETBG'
     C                   EXSR      KVEND
     C                   ENDIF
     C     dcDteDesc     WHENNE    'Y'                                          Create date
     C     OPCODE        ANDNE     'SETEN'
     C     dcDteDesc     OREQ      'Y'
     C     OPCODE        ANDEQ     'SETEN'
     C                   MOVEA     lmCrtDate     KV(@3)                         Ascending
     C     lmCrtDate2    WHENNE    *BLANKS                                      Descending
     C                   MOVEA     lmCrtDate2    KV(@3)
     C                   OTHER
     C                   MOVEA     '99999999'    KV(@3)
     C                   ENDSL
     C                   END
     C                   ENDDO

      *----------------------------
      * If BATNUM blank, no OPNQRYF
      *----------------------------
     c                   if        lmBatNum <> *blanks and not whOptLinks
     C                   XFOOT     IL            @3
J4355  if queryMode;
J4355    @3 = %xfoot(qIL);
J4355  endif;
     C                   ADD       1             @3
     C                   MOVEA     lmBatNum      KV(@3)
     C                   ADD       10            @3
     C                   Z-ADD     lmLnkSeq      PACK
     C                   MOVEA     ALFA          KV(@3)
     c                   end

     c                   return
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     KVEND         BEGSR
      *          ------------------------------
      *          Append *HIVAL characters to
      *          key values for SETEN opcode
      *          ------------------------------
     C     lmFltCde(@2)  IFEQ      '0'
     C     lmFltCde(@2)  OREQ      '1'
     C     @3            ADD       IL(@2)        @4                5 0
     C     lmFltCde(@2)  IFEQ      '1'
     C                   ADD       lmFltLn(@2)   @3
     C                   ENDIF
     C     @3            DOWLT     @4
/8627c                   if        Opcode = 'SETBG'
/8627c                   move      x'00'         KV(@3)
/8627c                   else
     C                   MOVE      x'FF'         KV(@3)
/8627c                   endif
     C                   ADD       1             @3
     C                   ENDDO
     C                   ENDIF

     C                   ENDSR
     p                 e
/7087 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/     * Get number of hits that will fit into one buffer
/    p GetMaxHits      b
/    d                 pi            10i 0
/
/    d HitSize         s             10i 0
/
/     * Handle different buffer sizes for 7.0 and 7.1 (8.0)
      *
/    c                   if        CVersID = *blanks
/    c                   eval      HitSize = AddHit70(#AHGetSize)
/    c                   if        HitSize > 0
/    c                   return    7680 / HitSize
/    c                   endif
/    c                   else
/    c                   eval      HitSize = AddHit71(#AHGetSize)
/    c                   if        HitSize > 0
/    c                   return    8100 / HitSize
/    c                   endif
/    c                   endif
/
/     * Return 10 if the actual value can't be calcualted
/    c                   return    10
/    p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * add multiple revision link hits
/4779p AddHitMult      b
     d                 pi
     d OpCode                        10    const

     c                   if        not %open(MMREVDR2)
     c                   open      MMREVDR2
     c                   end

     c     KContID       klist
     c                   kfld                    crBNum
     c                   kfld                    crBSeq

     c                   eval      LnkMapDSp = whLnkBufP                        link buffer
     c                   eval      crBNum = lmBatNum                            Batch number
     c                   eval      crBSeq = lmStrPage                           Batch RRN

     c                   select
     c                   when      OpCode = 'READ'
      * build revlist forward
     c     KContID       setll     MMREVDR2
     c     KContID       reade     MMREVDR2
/5083c                   if        %eof
/    c                   callp     AddHit(ckRevID)
/    c                   else
     c                   dow       not %eof
     c                   if        crWrkip = '0'                                not a WIP
     c                   callp     AddHit(crRevID)
     c                   end
     c     KContID       reade     MMREVDR2
     c                   enddo
/    c                   end
     c                   other
      * build revlist backwards
     c     KContID       setgt     MMREVDR2
     c     KContID       readpe    MMREVDR2
/5083c                   if        %eof
/    c                   callp     AddHit(ckRevID)
/    c                   else
     c                   dow       not %eof
     c                   if        crWrkip = '0'                                not a WIP
     c                   callp     AddHit(crRevID)
     c                   end
     c     KContID       readpe    MMREVDR2
     c                   enddo
/    c                   end
     c                   endsl

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * add link hit entry to return buffer
     p AddHit          b
     d                 pi
     d RevID                         10i 0 const
      * build and map link to return buffer
     c                   if        OK = BldHitHdr(RevID)                        build hit
     c
T1509c                   If        SecLnkAddHit  = BH_ADDHIT_NO
/    c                   Return
/    c                   EndIf

T5783c                   if        exitPgmAddHit = BH_ADDHIT_NO
/    c                   return
/    c                   endif
      * add to the hit list (by conversation version)
     c                   select
     c                   when      CVersID = *blanks
/7087c                   callp     AddHit70(#AHAddHit)                          7.0 version
     c                   when      CVersID = CV@DMS71
/3765c                   callp     AddHit71(#AHAddHit)                          7.1 version
J3618c                   when      CVersID = CV@DMS90
J3618c                   callp     AddHit90(#AHAddHit)                          9.0 version
     c                   endsl
     c                   eval      RtnHits = RtnHits + 1
     c                   end
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * add link hit entry to return buffer (7.0 version)
/2924p AddHit70        b
/7087d                 pi            10i 0
/7087d AddOpt                        10i 0 value

      * "MoreLinks" style Spylinks hits structure
/2924d LnkHitDS        ds                  based(LnkHitDSp)
     d  lhHdrSiz                      5  0
     d  lhHitHdr                           like(HitHdrDS)                       Hit Header struct
     d  lhValCnt                      5  0                                      Value count
     d  lhValLen                      5  0                                      Value length (all)
     d  lhMaxHit                      5  0                                      Max hits per buffer
     d  lhBufHit                      5  0                                      hits this buffer
/2924d LnkValDS        ds                  based(LnkValDSp)
     d  lvVal                        70    dim(7)                               link values

     d  vn             s              5i 0


     c                   eval      LnkMapDSp = whLnkBufP                        link buffer

/7087 * If hit size requested, return calcualted value
/    c                   if        AddOpt = #AHGetSize
/    c                   return    %size(LnkHitDS) +
/    c                               (dcValCnt * %size(lvVal))
/    c                   endif


      * link/hit header
     c                   eval      LnkHitDSp = BufrAlloc(%size(LnkHitDS))
     c                   clear                   LnkHitDS
     c                   eval      lhHdrSiz = %size(LnkHitDS)
     c                   eval      lhHitHdr = HitHdrDS                          Hit header
     c                   eval      lhValCnt = dcValCnt
     c                   eval      lhValLen = lhValCnt * %size(lvVal)
     c                   eval      lhMaxHit = RqstHits
     c                   eval      lhBufHit = RtnHits + 1
      * add link data values
     c                   eval      lnkValDSp = BufrAlloc(lhValLen)
     c                   eval      vn = 1
T6642c                   eval      LogOpCode = #AURTVLNK
     c                   dow       vn <= %elem(lvVal) and vn <= dcValCnt
     c                   eval      lvVal(vn) = %str(lmValP(vn):lmValLn(vn))     hit data
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):#DTLINK:
/    c                             %addr(lndxn(vn)):%len(%trimr(lndxn(vn))):
/    c                             lmValP(vn):lmValLn(vn))
     c                   eval      vn = vn + 1
     c                   enddo
/5635c                   callp     AddLogEnt

/7459c                   if        swwebusr <> ' ' and swwebapp <> ' '
/    c                   eval      lnkHitDSp = rtnbufrp
/    c                   do        RtnHits       vn
/    c                   eval      lhBufHit = rtnHits + 1
/    c                   eval      lnkHitDSp=lnkHitDSp + lhHdrSiz + lhValLen
/    c                   enddo
/    c                   endif

/7087c                   return    0
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * add link hit entry to return buffer (7.1 version)
/3765p AddHit71        b
/7087d                 pi            10i 0
/7087d AddOpt                        10i 0 value

      * Link Hit Header
     d LnkHitDS        ds                  based(LnkHitDSp)
     d  lhHdrSiz                      5  0                                      Header size
     d  lhHitHdr                           like(HitHdrDS)                       Hit Header struct
     d  lhValCnt                      5  0                                      index count

      * Link Hit Value
     d LnkValDS        ds                  based(LnkValDSp)
     d  lvValLen                      5  0                                      Index length
     d  lvVal                     32767                                         Index value

     d  vn             s              5i 0

     c                   eval      LnkMapDSp = whLnkBufP                        link buffer

/7087 * If hit size requested, return 0
/     * (New conversation handles spanning buffers)
/    c                   if        AddOpt = #AHGetSize
/    c                   return    0
/    c                   endif

      * add revision entry
     c                   callp     RevEntry

      * link header
     c                   eval      LnkHitDSp = BufrAlloc(%size(LnkHitDS))
     c                   clear                   LnkHitDS
     c                   eval      lhHdrSiz = %size(LnkHitDS)
     c                   eval      lhHitHdr = HitHdrDS                          Hit header
     c                   eval      lhValCnt = dcValCnt
      * add link data values
T6642c                   eval      LogOpCode = #AURTVLNK
     c                   do        dcValCnt      vn
     c                   eval      LnkValDSp = BufrAlloc(dcValLn(vn)+
     c                                                   %size(lvValLen))
     c                   eval      lvValLen = dcValLn(vn)                       defined length
     c                   eval      %subst(lvVal:1:lvValLen) =
     c                                         %str(lmValP(vn):lmValLn(vn))     hit data
     c                   eval      rc = AddLogDtl(%addr(LogDS):#DTLINK:
     c                             %addr(lndxn(vn)):%len(%trimr(lndxn(vn))):
     c                             lmValP(vn):lmValLn(vn))
     c                   enddo
/5635c                   callp     AddLogEnt

/7087c                   return    0
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * add link hit entry to return buffer (9.0 version)
      * Duped from AddHit71. Necessary because the size of lhHitHdr changes
      * with the addition of extended anno flags.
J3618p AddHit90        b
     d                 pi            10i 0
     d AddOpt                        10i 0 value

      * Link Hit Header
     d LnkHitDS        ds                  based(LnkHitDSp)
     d  lhHdrSiz                      5  0                                      Header size
     d  lhHitHdr                           like(HitHdrDS_2)                     Hit Header struct
     d  lhValCnt                      5  0                                      index count

      * Link Hit Value
     d LnkValDS        ds                  based(LnkValDSp)
     d  lvValLen                      5  0                                      Index length
     d  lvVal                     32767                                         Index value

     d  vn             s              5i 0

     c                   eval      LnkMapDSp = whLnkBufP                        link buffer

      * If hit size requested, return 0
      * (New conversation handles spanning buffers)
     c                   if        AddOpt = #AHGetSize
     c                   return    0
     c                   endif

      * add revision entry
     c                   callp     RevEntry

      * link header
     c                   eval      LnkHitDSp = BufrAlloc(%size(LnkHitDS))
     c                   clear                   LnkHitDS
     c                   eval      lhHdrSiz = %size(LnkHitDS)
     c                   eval      lhHitHdr = HitHdrDS_2                        Hit header
     c                   eval      lhValCnt = dcValCnt
      * add link data values
     c                   eval      LogOpCode = #AURTVLNK
     c                   do        dcValCnt      vn
     c                   eval      LnkValDSp = BufrAlloc(dcValLn(vn)+
     c                                                   %size(lvValLen))
     c                   eval      lvValLen = dcValLn(vn)                       defined length
     c                   eval      %subst(lvVal:1:lvValLen) =
     c                                         %str(lmValP(vn):lmValLn(vn))     hit data
     c                   eval      rc = AddLogDtl(%addr(LogDS):#DTLINK:
     c                             %addr(lndxn(vn)):%len(%trimr(lndxn(vn))):
     c                             lmValP(vn):lmValLn(vn))
     c                   enddo
     c                   callp     AddLogEnt

     c                   return    0
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * reallocate buffer and return offset pointer
/3765p BufrAlloc       b
     d                 pi              *                                        data offset
     d Size                          10i 0 const                                data size
     d Offset          s             10i 0
      * reallocate space in buffer
     c                   eval      Offset = RtnBufrLn
     c                   eval      RtnBufrLn = RtnBufrLn + Size
     c                   if        RtnBufrP = *null
     c                   eval      RtnBufrP = mm_alloc(RtnBufrLn)
     c                   else
     c                   eval      RtnBufrP = mm_realloc(RtnBufrP:RtnBufrLn)
     c                   end
     c                   return    RtnBufrP + Offset                            starting pos
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get/assign window handle
     p GetHandle       b
     d                 pi             5i 0                                      handle number
     d Handle                        11    const                                window handle

     d WHnbr           s              5i 0
     d NewHandle       s                   like(Handle) inz(*loval)

      * find the handle
     c                   eval      WHnbr = 1
     c     Handle        lookup    WHdl(WHnbr)                            61
     c                   if        not *in61                                    not found
      * find unused handle
     c                   eval      WHnbr = 1
     c     NewHandle     lookup    WHdl(WHnbr)                            62    get new
     c                   if        not *in62                                    not available
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   end
J4355  if queryMode and %trim(whdl(whnbr)) <> 'WRKSPI';
J4355    whNbr = 1;
J4355  endif;
     c                   eval      WHdl(WHnbr) = *blanks
     c                   callp     ClrHandle(WHnbr)
     c                   eval      WHdl(WHnbr) = Handle
     c                   end
      * setup handle
     c     WHnbr         occur     WHdlDS
     c     WHnbr         occur     DClsDS
     c                   return    WHnbr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * clear window handle
     p ClrHandle       b
     d                 pi
     d HdlNbr                         5i 0 const                                handle number

     c                   if        HdlNbr < 1 or HdlNbr > %elem(WHdl)           invalid
     c                               or WHdl(HdlNbr) = *loval                   not used
     c                   return                                                 skip
     c                   end
      * clear memory
     c                   eval      WHdl(HdlNbr) = *loval
     c     HdlNbr        occur     WHdlDS
     c     HdlNbr        occur     DClsDS
/8724c                   eval      rc = LnkDBclose(HdlNbr)
     c                   callp     DlcLnkMap(whLnkBufP)                         link buffer
     c                   callp     DlcLnkMap(whFilterP)                         filter selection
     c                   callp     DlcLnkMap(whPosKeyP)                         position key
     c                   reset                   WHdlDS
     c                   reset                   DclsDS
     c                   move      HdlNbr        ALF2              2
     c                   eval      whOpenFile = 'RLNKND' + ALF2
J3472c                   clear                   QryRqstDS

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * setup doc class definition
     p GetDCdef        b
     d                 pi            10i 0
     d Big5                          50    const                                Big5 key

     d LimitScroll     s                   like(RLmtSc)

     c     KeyBig5       KLIST
     c                   KFLD                    rRNAM
     c                   KFLD                    rJNAM
     c                   KFLD                    rPNAM
     c                   KFLD                    rUNAM
     c                   KFLD                    rUDAT

     c                   reset                   DClsDS
     c                   eval      rmBig5 = Big5
     c                   eval      ldBig5 = Big5
      * resolve offline links (either in GS or CS format)
     c                   if        OptFil <> *blanks or
     c                             OptID  <> *blanks                            Offline seq
     c                   eval      rc = OffLinks(rmBig5:ldBig5:OptFil:OptID)
     c                   end
      * Doc Class Info
     C     KeyBig5       chain     RMntRC
     c                   if        not %found
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   end
     c                   eval      dcBig5   = rmBig5
/6001c                   eval      dcBig5ld = ldBig5
     c                   eval      dcRptTyp = RtypID
      * limit scrolling
     c                   if        RLmtSc = *blanks
     c                   eval      dcLmtScr = LnkScr                            SysDft
     c                   else
     c                   eval      dcLmtScr = RLmtSc
     c                   end

      * get web limit scrolling
     c                   if        OK = GetWebParms('LMTSCR':LimitScroll)
     c                               and LimitScroll <> *blanks
     c                   eval      dcLmtScr = LimitScroll
     c                   end

      * get link definition
     c                   if        whOptVol <> *blanks
     c                   eval      whOptLinks = *on
     c                   eval      rc = OptLnkDef('GET')                        optical
     c                   else
/4648c                   eval      whOptLinks = *off
     c                   eval      rc = LinkDef(ldBig5)                         dasd online/offline
     c                   end
     c                   if        rc = FAIL
     c                   return    FAIL
     c                   end

      * get Revision Control info
     c                   if        OK = RtvDMSFlgs(dcRptTyp:
     c                                   LckSupport:AnnoSupport:BranchSupport)
     c                   eval      dcAnnoAsRev   = AnnoSupport                  anno as a rev
     c                   eval      dcLckSupport  = LckSupport                   lock support
     c                   eval      dcAllowBranch = BranchSupport                allow branching
     c                   end
      * default Revision Status
     c                   clear                   RevStatus
     c                   eval      Rs_LockSts = DMSDrvLockSts(dcRptTyp)         get default
     c                   eval      dcRevStatus = RevStatus                      default

???   * old array (plus date)
     c                   eval      LN(*) = dcValNam(*)
     c                   eval      IL(*) = dcValLn(*)
J4355c                   eval      qIL(*) = dcValLn(*)
/2832c                   MOVEL     'CREATED'     LN(8)
     c                   Z-ADD     8             IL(8)
J4355c                   Z-ADD     8             qIL(8)

     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Offline links
     p OffLinks        b
     d                 pi            10i 0
     d RptBig5                       50                                         RMaint  Big5
     d LnkBig5                       50                                         RLnkDef Big5
     d OffFile                       10    const                                offline file
     d OffSeq                         5    const                                offline seq

     c                   eval      ldBig5 = RptBig5
     c                   select
      * CS style
     c                   when      OffFile = 'RLNKOFF'
     c                   eval      rc = OffLinkSeq(RptBig5:OffSeq)
     c                   clear                   ldBig5
     c                   eval      lRNAM = 'MAGELLAN'
     c                   eval      lJNAM = 'SOFTWARE'
     c                   eval      lPNAM = 'DASDLINK'
     c                   eval      lUNAM = whOptFil
     c                   eval      lUDAT = whOptSeq
     c                   eval      LnkBig5 = ldBig5
      * GS style
     c                   when      lRNAM = 'MAGELLAN' and
     c                             lJNAM = 'SOFTWARE' and
     c                             lPNAM = 'DASDLINK' and
     c                             lUNAM = OffFile
     c                   eval      rc = OffLinkFile(OffFile:RptBig5:LnkBig5)
      * GS style (alternate)
     c                   when      %subst(OffFile:1:1) = '@'
     c                   eval      rc = OffLinkFile(OffFile:RptBig5:LnkBig5)
     c                   clear                   ldBig5
     c                   eval      lRNAM = 'MAGELLAN'
     c                   eval      lJNAM = 'SOFTWARE'
     c                   eval      lPNAM = 'DASDLINK'
     c                   eval      lUNAM = whOptFil
     c                   eval      lUDAT = whOptSeq
     c                   eval      LnkBig5 = ldBig5
     c                   endsl

     c                   if        whOptFil <> *blanks
     c                   eval      @file = whOptFil
     c                   end
     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get Offline links by Seq
     p OffLinkSeq      b
     d                 pi            10i 0
     d Big5                          50    const                                RMaint  Big5
     d OffSeq                         5    const                                offline seq

     d OffSeqWrk       s                   like(OffSeq)

      * get offline sequence number
     c     ' ':'0'       XLATE     OffSeq        OffSeqWrk
     c                   MOVE      OffSeqWrk     loSeq

     C     KeyLnkOff     KLIST
     c                   KFLD                    lRNAM
     c                   KFLD                    lJNAM
     c                   KFLD                    lPNAM
     c                   KFLD                    lUNAM
     c                   KFLD                    lUDAT
     C                   KFLD                    loSeq

     c                   if        not %open(RLnkOff)
     c                   open      RLnkOff
     c                   end
     c                   eval      ldBig5 = Big5
     c     KeyLnkOff     CHAIN     RLNKOFF
     c                   if        %found
     c                   eval      whOptVol = loVol
     c                   eval      whOptDir = loDir
     c                   eval      whOptFil = loFili
     c                   eval      whOptSeq = OffSeqWrk
     c                   eval      OptVol = whOptVol
     c                   eval      OptDir = whOptDir
     c                   eval      OptFil = whOptFil
     c                   end
     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get Offline links by File
     p OffLinkFile     b
     d                 pi            10i 0
     d OffFile                       10    const                                offline file
     d RptBig5                       50                                         RMaint  Big5
     d LnkBig5                       50                                         RLnkDef Big5

     c                   eval      LnkBig5 = RptBig5
     c                   if        not %open(RLnkOff1)
     c                   open      RLnkOff1
     c                   end
     c     OffFile       chain     RLnkOff1
     c                   if        %found
     c                   eval      RptBig5 = loBig5
     c                   eval      whOptVol = loVol
     c                   eval      whOptDir = loDir
     c                   eval      whOptFil = loFili
     c                   move      loseq         whOptSeq
     c                   end
     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * link definition
     p LinkDef         b
     d                 pi            10i 0
     d Big5                          50    const                                Big5 key

     d vc              s             10i 0

     c     KeyBig5       KLIST
     c                   KFLD                    lRNAM
     c                   KFLD                    lJNAM
     c                   KFLD                    lPNAM
     c                   KFLD                    lUNAM
     c                   KFLD                    lUDAT
     c     KeyIndx       KLIST
     c                   KFLD                    lRNAM
     c                   KFLD                    lJNAM
     c                   KFLD                    lPNAM
     c                   KFLD                    lUNAM
     c                   KFLD                    lUDAT
     c                   KFLD                    lndxn(vc)

      * get link definition
     c                   eval      ldBig5 = Big5
     c     KeyBig5       chain     LnkDef                                       online
     c                   if        not %found
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   end
     c                   if        LnkFil = *blanks
     c                   callp     RtnSts(R@WARN)
     c                   return    FAIL
     c                   end
     c                   eval      whLinkFile = LnkFil
     c                   eval      whLfFactors(*) = lNdxF(*)
     c                   eval      dcDteDesc = LdtDes                           date descending

      * load index definitions
     c                   eval      vc = 1
     c                   dow       vc <= %elem(lndxn)
     c*                  eval      dcValLn(vc) = 1                              unused length
     c*                  if        lndxn(vc) <> *blanks
     c                   eval      dcValCnt = dcValCnt + 1
     c*                  eval      dcValNam(vc) = lndxn(vc)
       dcValLn(vc) = 99;
     c*    KeyIndx       chain     IndexRC
     c*                  if        %found
     c*                  eval      dcValLn(vc) = iklen
     c*                  end
     c*                  end
     c                   eval      vc = vc + 1
     c                   enddo

     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * Optical links definitions
     p OptLnkDef       b
     d                 pi            10i 0
     d OpCode                        10    const                                operation

     d OptHdrDS        DS          5120
     d  oLen                  41     64p 0 dim(8)                               Key lengths
     d  oVers                 89     90p 0                                      Version
     d  oNam                 151    220    dim(7)                               Opt names

     d vc              s             10i 0
     d PgmActive       s              1    static

      * shutdown sub-program
     c                   if        OpCode = 'QUIT'
     c                   if        PgmActive = *on
     c                   eval      eClosePgm = *on                              Close pgm
     c                   CALL      'GETHDR'      plGetHdr
     c                   end
     c                   return    OK
     c                   end
     c                   eval      PgmActive = *on

      * optical links header
     c                   CALL      'GETHDR'      plGetHdr
     c     plGetHdr      PLIST
     C                   PARM                    OPTID                          OptId
     C                   PARM                    OPTDRV                         Opt Drive
     C                   PARM                    OPTVOL                         Volume
     C                   PARM                    OPTDIR                         Sub dir
     C                   PARM                    OPTFIL                         File name
     C                   PARM                    OptHdrDS                       Rtn data
     C                   PARM                    eClosePgm         1            Close pgm
     C                   PARM      *BLANKS       eRtnID            7            Retrn ID
     C                   PARM      *BLANKS       eRtnData        100            Retrn DATA

     c                   if        eRtnID <> *blanks
     c                   callp     RtnSts(R@ERROR:eRtnID:eRtnData)
     c                   return    FAIL
     c                   end

      * load index definitions
     c                   eval      vc = 1
     c                   dow       vc <= %elem(oNam)
     c                   eval      dcValLn(vc) = 1                              unused length
     c                   if        oNam(vc) <> *blanks
     c                   eval      dcValCnt = dcValCnt + 1
     c                   eval      dcValNam(vc) = oNam(vc)
     c                   eval      dcValLn(vc) = oLen(vc)
     c                   end
     c                   eval      vc = vc + 1
     c                   enddo

     c                   return    OK
     c     *pssr         begsr
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   endsr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * build link buffer mapping structure
     p BldLnkMap       b
     d                 pi
     d BufrMapP                        *                                        buffer map

     d vm              s                   like(dcValCnt)
     d bp              s               *

      * allocate structures
     c                   callp     DlcLnkMap(BufrMapP)
     c                   eval      BufrMapP = mm_alloc(%size(LnkMapDS))         buffer map
     c                   eval      LnkMapDSp  =  BufrMapP
     c                   clear                   LnkMapDS
     c                   eval      lmLnkNdxP = mm_alloc(%size(RLnkNdxDS))       link Buffer
     c                   eval      RLnkNdxDSp =  lmLnkNdxP
     c                   clear                   RLnkNdxDS

      * map link fields
     c                   eval      lmBatNumP  = %addr(ldxNam)                   Batch num
     c                   eval      lmLnkSeqP  = %addr(lxSeq )                   Link seq
      * calculate remaining record layout
     c                   eval      bp = %addr(lxIv1)                            first index
     c                   eval      vm = 1
     c                   dow       vm <= MaxIndx
     c                   if        whOpnQryF                                    open query file
     c                   eval      lmValLn(vm) = %len(lxIv1)
     c                   else
     c                   eval      lmValLn(vm) = dcValLn(vm)
     c                   end
     c                   eval      lmValP(vm) = bp
     c                   eval      bp = bp + lmValLn(vm)
     c                   eval      vm = vm + 1
     c                   enddo
      * record tail
     c                   eval      lmCrtDateP = bp                              Create date
     c                   eval      bp = bp +  %size(lxIv8)
     c                   eval      lmTypCodeP = bp                              type code
     c                   eval      bp = bp +  %size(lxTyp)
     c                   eval      lmStrPageP = bp                              starting page/rrn
     c                   eval      bp = bp +  %size(lxSpg)
     c                   eval      lmEndPageP = bp                              ending page/rrn

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * deallocate link buffer mapping structure
     p DlcLnkMap       b
     d                 pi
     d BufrMapP                        *                                        buffer map
     c                   if        BufrMapP <> *null
     c                   eval      LnkMapDSp  =  BufrMapP
     c                   callp     mm_free(lmLnkNdxP:0)                         link buffer
     c                   end
     c                   callp     mm_free(BufrMapP:1)                          buffer map
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * position link db file
     p LnkDBpos        b
     d                 pi            10i 0
     d HdlNbr                         5i 0 const                                handle number
     d OpCode                        10    const                                operation

      * Dasd links
     c                   select
     c                   when      not whOptLinks
     c                   if        whFileP = *null                              not open
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   end
     c                   select
     c                   when      OpCode = 'SETLL' or
     c                             OpCode = 'SETBG'
     c                   eval      RIOFBp = Rlocate(whFileP:%addr(wKeyList):
     c                                                      %size(wKeyList):
     c                                              R_KEY_GE+R_PRIOR)
/5150c                   if        RioBytes < 1                                 failed
/8557c                   eval      RIOFBp = Rlocate(whFileP:*null:0:R_END)      eof
/5150c                   end
     c                   when      OpCode = 'SETGT' or
     c                             OpCode = 'SETEN'
     c                   eval      RIOFBp = Rlocate(whFileP:%addr(wKeyList):
     c                                                      %size(wKeyList):
     c                                              R_KEY_GT+R_PRIOR)
/5150c                   if        RioBytes < 1                                 failed
     c                   eval      RIOFBp = Rlocate(whFileP:*null:0:R_END)      eof
     c                   end
     c                   endsl
      * Optical links
     c                   when      whOptLinks
     c                   if        R@ERROR = OptLnkIO(OpCode)
     c                   return    FAIL
     c                   end
     c                   endsl

     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * read link db file
     p LnkDBread       b
     d                 pi             2a
     d HdlNbr                         5i 0 const                                handle number
     d OpCode                        10    const                                operation

      * setup buffer
     c
     c                   eval      LnkMapDSp  = whLnkBufP                       link map
     c                   eval      RLnkNdxDSp = lmLnkNdxP                       link buffer
      * Dasd links
     c                   select
     c                   when      not whOptLinks
J3252c                   If        ( %addr(RLnkNdxDS) = *null )
/    c                   callp     RtnSts(R@ERROR)
/    c                   return    R@ERROR
/    c                   EndIf
       if rLnkNdxDSp = *null;
         rLnkNdxDSp = %alloc(%size(rLnkNdxDS));
       endif;
       clear rLnkNdxDS;
J4772  rc = sqlDBread(hdlNbr:opcode:RLnkNdxDSp);
J4772  if rc = 100;
J4772    RtnSts(R@Warn);
J4772    return R@Warn;
J4772  endif;
J4772   if rc < 0;
J4772    RtnSts(R@Error);
J4772    return R@Error;
J4772  endif;
      * Optical links
     c                   when      whOptLinks
     c***                return    OptLnkIO(OpCode)
     c                   return    OptLnkIO('READ')
     c                   endsl

     c                   return    R@OK

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * open link db file
     p LnkDBopen       b
     d                 pi            10i 0
     d HdlNbr                         5i 0 const                                handle number

      * Search criteria/positioning keys.
     d scRqstBuf       ds                  based(scRqstBufP)
     d  scHeaderSize                  5s 0

     d scDates         ds                  based(scDatesP)
     d  scDateFr                      8
     d  scDateTo                      8

     d scNbrNdx        ds                  based(scNbrNdxP)
     d  scNbrCrit                     5s 0

     d scDocID         ds
     d  scID                         10
     d  scSeq                         9s 0
     d lnkCriteriaVal  ds                  based(lcvP)
     d  lcvA                         99    dim(MAXINDX)

     d i               s              5i 0
     d j               s              5i 0
     d k               s              5i 0
     d startNdxOrder   s              5i 0 inz(1) static
     d sq              c                   ''''
     d sqlStmt         s           4096    inz
     d whereClause     s           2048    inz
     d orderByClause   s            512    inz static
     d operator        s              4    inz('=')

       //if whOptLinks or opcode <> 'SELCR';
       if whOptLinks or (opcode <> 'SELCR' and opcode <> 'SETLL');
         return OK;
       endif;

       scRqstBufP = rqstbufrp;
       lcvP = rqstbufrp + scHeaderSize; //Offset to criteria index array.

       if scHeaderSize < 50;
         scDatesP = scRqstBufP + %size(scHeaderSize);
         scNbrNdxP = scDatesP + %size(scDates);
       else;
         scDatesP = scRqstBufP + %size(scHeaderSize) + %size(scDocID);
         scNbrNdxP = scDatesP + %size(scDates);
       endif;

       // Build the SQL statement and pass it to the SQL module.
       sqlStmt = 'select * from ' + %trim(dtalib) + '/' + lnkfil;

       if opcode = 'SELCR';
         reset startNdxOrder;
         clear orderByClause;
         for i = 1 to %elem(lcvA);
           if lcvA(i) <> ' ' and lcvA(i) <> *allx'00';
             // First non-blank index search/return value marks starting sort order.
             if opcode = 'SELCR';
               startNdxOrder = i;
             endif;
             if whereClause <> ' ';
               whereClause = %trimr(whereClause) + ' and';
             endif;
             // Set the operator for the values in the where clause.
             reset operator;
             if %subst(lcvA(i):1:1) = wldCrd or
               %subst(lcvA(i):%len(%trimr(lcvA(i))):1) = wldCrd;
               if %subst(lcvA(i):1:1) = wldCrd;
                 %subst(lcvA(i):1:1) = '%';
               endif;
               if %subst(lcvA(i):%len(%trimr(lcvA(i))):1) = wldCrd;
                 %subst(lcvA(i):%len(%trimr(lcvA(i))):1) = '%';
               endif;
               operator = 'like';
             endif;
             whereClause = %trimr(whereClause) + ' lxiv' +
               %trim(%char(i)) + ' ' + %trim(operator) + ' ' +
               sq + %trim(%xlate(lo:up:lcvA(i))) + sq;
           endif;
         endfor;

J7246    // Test to see if query mode is active (green screen only) and map
J7246    // QRY selection to SQL statement.
J7246    if whereClause = ' ' and queryMode;
J7246      for i = 1 to MaxQryLn;
J7246        if fn(i) <> ' ';
J7246         whereClause = %trimr(whereClause) + ' ' + %trim(ao(i)) + ' ' +
J7246           'lxiv' + %trim(%char(%lookup(fn(i):lNdxNA))) + ' ' +
J7246           %trim(sqlOpcode(%lookup(te(i):qryOpcode)));
J7246           // If leading single quote, assume user entered quotes for value.
J7246           if %subst(%trim(vl(i)):1:1) = SQ;
J7246             whereClause = %trimr(whereClause) + ' ' + %trim(vl(i));
J7246           else;
J7246             whereClause = %trimr(whereClause) + ' ' +
J7246               sq + %trim(vl(i)) + sq;
J7246           endif;
J7246        endif;
J7246      endfor;
J7246    endif;

         // Handle from and to date search criteria.
         if isDigits(scDateFr) or isDigits(scDateTo);
           if whereClause <> ' ';
             whereClause = %trimr(whereClause) + ' and';
           endif;
           select;
             when isDigits(scDateFr) and isDigits(scDateTo) and
               opcode <> 'SETGT';
               whereClause = %trimr(whereClause) + ' lxiv8 between ' +
                 sq + scDateFr + sq + ' and ' + sq + scDateTo + sq;
             when isDigits(scDateFr);
               whereClause = %trimr(whereClause) + ' lxiv8 >= '+sq+scDateFr+sq;
             when isDigits(scDateTo);
               whereClause = %trimr(whereClause) + ' lxiv8 <= '+sq+scDateTo+sq;
           endsl;
           if opcode = 'SELCR' and startNdxOrder = 0;
             startNdxOrder = 8;
           endif;
         endif;

         // Test for DocLink Security


         // Set order by clause;
         // All key fields must be specified or the existing access path (logical file)
         // will not be utilized and will cause a performance issue.
         j = startNdxOrder;
         for i = 1 to (%elem(lcvA)+1); //+1 = lxiv8 (create date)
           if orderByClause <> ' ';
             orderByClause = %trimr(orderByClause) + ',';
           endif;
           if j = startNdxOrder and i <> 1;
             j += 1;
           endif;
           orderByClause = %trimr(orderByClause) + 'lxiv' + %trim(%char(j));
           if opcode = 'RDLT' and j = startNdxOrder;
             orderByClause = %trimr(orderByClause) + ' desc';
           endif;
           if j > i;
             j = 1;
           else;
             j += 1;
           endif;
         endfor;
         orderByClause = %trimr(orderByClause) + ',ldxnam,lxseq';

       endif;

       // Position to option...green screen only...so far.
       if opcode = 'SETLL' and positionTo <> ' ';
         if whereClause <> ' ';
           whereClause = %trimr(whereClause) + ' and';
         endif;
         whereClause = %trimr(whereClause) + ' lxiv1 >= ' +
           sq + %trim(positionTo) + sq;
         positionTo = ' ';
       endif;

       if whereClause <> ' ';
         sqlStmt = %trimr(sqlStmt) + ' where ' + %trimr(whereClause);
       endif;

       sqlStmt = %trimr(sqlStmt) + ' order by ' + %trimr(orderByClause);

       // Open the SQL cursor for the specified (or unqualified) search.
J4772  if sqlDBopen(hdlNbr:sqlStmt) <> 0;
J4772    return FAIL;
       endif;

       return OK;

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * close link db file
     p LnkDBclose      b
     d                 pi            10i 0
     d HdlNbr                         5i 0 const                                handle number

/8724c                   if        whOptLinks
/    c                   return    OK
/    c                   endif
/
J4772  sqlDBclose(hdlNbr);

/    c                   eval      whFileP = *null

     c                   return    OK

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * optical links
     p OptLnkIO        b
     d                 pi             2a                                        return code
     d OpCode                        10    const                                operation

      * optical link record (minus Batch/Seq)
     d OptData         s            712    based(OptDataP)                      (727 minus bat/seq)
     d PgmActive       s              1    static

      * shutdown sub-program
     c                   if        OpCode = 'QUIT'
     c                   if        PgmActive = *on
     c                   call      'MAG1081'     plMAG1081
     c                   end
     c                   return    R@OK
     c                   end
     c                   eval      PgmActive = *on

     c                   if        OpCode = 'READ' or
     c                             OpCode = 'READP'
      * map optical data over db link record (set past SpyNum/Seq)
     c                   eval      LnkMapDSp  = whLnkBufP                       link map
     c                   eval      RLnkNdxDSp = lmLnkNdxP                       link buffer
     c                   eval      OptDataP = %addr(lxIv1)                      first key
     c                   else
      * map optical data over sorted key buffer
     c                   eval      RLnkNdxDSp = wKeyBufrP                       link buffer
     c                   eval      OptDataP = %addr(wKeyList)
     c                   end

     c                   call      'MAG1081'     plMAG1081
     c     plMAG1081     plist
     C                   PARM                    OPTID                          Opt id
     C                   PARM                    OPTDRV                         Opt drive
     C                   PARM                    OPTVOL                         Volume
     C                   PARM                    OPTDIR                         Sub dir
     C                   PARM                    OPTFIL                         FILE @00..xx
     C                   PARM      whLfNbr       LFnbr             1 0          Logical ID
     C                   PARM      OpCode        oOpCode           5            Setll/read..
     C                   PARM      whLfFltCde    SCHTYP            1            Search type
     C                   PARM                    OptData                        Bidirec data
     C                   PARM                    LDXNAM                         Spy00...
     C                   PARM                    LXSEQ                          Logcl FilPtr
     C                   PARM      R@OK          oRtnCde           2            Rtn Code
     C                   PARM      *BLANKS       oRtnID            7            Rtn ID
     C                   PARM      *BLANKS       oRtnData        100            Rtn DATA

      * setup return error message
     c                   if        oRtnCde = *blanks
     c                   eval      oRtnCde = R@OK
     c                   end
     c                   callp     RtnSts(oRtnCde:oRtnID:oRtnData)
     c                   return    oRtnCde
     c     *pssr         begsr
     c                   callp     RtnSts(R@ERROR)
     c                   return    R@ERROR
     c                   endsr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     p SpyLikeTest     b
     d                 pi            10i 0
     d LikeValue                     30    const options(*nopass)               like value
     d IndexData                     99    const options(*nopass)               index data
      * LIKE/NLIKE/CT/DC Test. If OK set RTNCDE='1'
     d SpyLike         pr                  extpgm('SPYLIKE')
     d  Like                         30
     d  Index                        99    const
     d  RtnCde                        1
     d  Like           s             30
     d  RtnCde         s              1
      * shutdown
     c                   if        %parms < 2
     c                   eval      RtnCde = 'Q'
     c                   callp     SpyLike(Like:IndexData:RtnCde)
     c                   return    OK
     c                   end
     c                   eval      Like = LikeValue
     c                   callp     SpyLike(Like:IndexData:RtnCde)
     c                   if        RtnCde <> *on
     c                   return    FAIL
     c                   end
     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * full text search
     p CSFind          b
     d                 pi            10i 0
     d OpCode                        10    const                                operation
/5671d LnkBufrP                        *   const options(*nopass)               link buffer

     d PgmActive       s              1    static

      * shutdown sub-program
     c                   if        OpCode = 'QUIT'
     c                   if        PgmActive = *on
     c                   eval      fOpCode = OpCode
     c                   call      'SPYCSFND'    plCSFND                50
     c                   end
     c                   return    OK
     c                   end
     c                   eval      PgmActive = *on

      * do full text search within pg range
/5671c                   eval      LnkMapDSp = LnkBufrP                         link buffer
     c                   eval      fOpCode = *blanks
     c                   call      'SPYCSFND'    plCSFND                50
     c     plCSFND       PLIST
     C                   PARM                    fOpCode          10             Oper code
     C                   PARM      lmBatNum      REPIND           10              Spy000...
     C                   PARM      lmStrPage     PAGFRM            9 0            Page from
     C                   PARM      lmEndPage     PAGTO             9 0            Page to
     C                   PARM      0             COLFRM            5 0            Col from
     C                   PARM      0             COLTO             5 0            Col to
     C                   PARM      0             LINFRM            5 0            Line from
     C                   PARM      0             LINTO             5 0            Line to
     C                   PARM      'Y'           FNDCAS            1              Ign. case
     C                   PARM      '_'           WLDCRD            1              Wild Card
     C                   PARM      'Y'           FNDOPT            1              Optical
     C                   PARM                    ftWord                           Words
     C                   PARM                    ftAndOr                          And/or
     C                   PARM                    ftCond                           Like/nlike
      *     return parms
     C                   PARM                    FNDGRP                           Fnd Group
     C                   PARM                    FNDPAG            9 0            Page fnd
     C                   PARM                    FNDCOL            5 0            Col  fnd
     C                   PARM                    FNDLIN            5 0            Line fnd
     C                   PARM                    FNDRTN            7              Rtn MSGID
     C                   PARM                    FNDDTA          100              Rtn Data

     C     FNDPAG        IFEQ      0                                              Not found
     C     FNDRTN        ORNE      *BLANKS                                        or error
     C                   MOVE      *OFF          MATCHS
     C                   ELSE
     C                   MOVE      *ON           MATCHS
     C                   ENDIF

     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get notes code
     p ChkNotes        b
     d                 pi            10i 0
     d OpCode                        10    const                                operation
     d NoteCde                        1    options(*nopass)                     notes code
J3618d noteFlagsP                      *   options(*nopass)                     note flags pointer

      * shutdown sub-program
     c                   if        OpCode = 'QUIT' or
     c                             OpCode = 'INIT'
     c                   call      'SPYCSNOT'    plCSNOT
     c                   return    OK
     c                   end

     c                   eval      nSpyNum  = hhBatNum
     c                   eval      RevIDb = ldRevID
      * check distribution range
/5921c                   if        DistStrPg <> 0
/    c                   eval      nStrPage = DistStrPg
/    c                   eval      nEndPage = DistEndPg
/    c                   callp     CvtFromDist(hhBatNum:hhStrPage:hhEndPage:
/    c                                                  nStrPage:nEndPage)
/    c                   eval      nPage = nStrPage
/    c                   else
/    c                   eval      nPage = hhStrPage
/    c                   eval      nStrPage = hhStrPage
/    c                   eval      nEndPage = hhEndPage
/    c                   end
      * handle conversion documents
     c                   if        hhLocCde = '4' or                            R/DARS optical
     c                             hhLocCde = '5' or                            R/DARS QDLS
     c                             hhLocCde = '6'                               ImageView optical
     c                   if        hhRDARoff <> *blanks
     C                   move      hhRDARoff     nPage                          actual page#
     c                   end
     c                   end
      * check for notes/annotations
     c                   call      'SPYCSNOT'    plCSNOT
     c     plCSNOT       plist
     c                   parm                    nSpyNum          10            Spy000*
     c                   parm                    nSegment         10            Dst pgtbl nm
     c                   parm                    nHandle          10            Window Handl
     c                   parm                    DTALIB                         Spy00 Libr
     c                   parm      OpCode        nOpCode           5            Opcode
/813 c                   parm                    nPage             9 0          Page # / RRN
     c                   parm                    Note#             9 0          Note #
/813 c                   parm                    nStrPage          9 0          TIFF/Actual Page#
     c                   parm                    nBuffer        7680            Return data
     c                   parm                    NoteRecs          9 0          Rtn # of rec
     c                   parm                    nRtnCde           2            Return code
     c                   parm                    nSetonLR          1            Shutdown
     c                   parm                    NewNote           1            NEW NOTE
     c                   parm                    nEndPage          9 0          END PAGE RANGE
     c                   parm      *blanks       NoteFlag          1            NOTES FLAG
     c                   parm                    RevIdb            9 0          Revision ID
J3618C                   PARM      0             DCODE             9 0          Domain
J3618C                   PARM      0             DTYPE             9 0          Domain Type
J3618c                   parm      *blanks       errid             7
J3618c                   parm      *blanks       errdta           80
J3618c                   parm      0             StartPos                       Start position
J3618c                   parm      0             DataLen
J3618c                   parm                    noteFlagsP

      * setup return error
     c                   if        nRtnCde = R@ERROR
     c                   callp     RtnSts(nRtnCde)
     c                   return    FAIL
     c                   end
      * Note Codes: 0,1,2,3 (NoNotes,Text,Annot,Text+Ann)
     c                   if        %parms >= 2
     c                   eval      NoteCde = NoteFlag                           notes code
     c                   end
     c                   return    OK
     c     *pssr         begsr
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   endsr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get Web parameters
     p GetWebParms     b
     d                 pi            10i 0
     d OpCode                        10    const                                operation
     d WebParm                        1    options(*nopass)

/2815d/copy @SPYCSWEB

/5624d DMSSvrCfg       ds
/5624d/copy @USERMGMTC

     d PgmActive       s              1    static

/2815c     plSpyWeb      plist
     c                   parm                    POpCode          10
/5624c                   parm                    DMSSvrCfg
     c                   parm                    PRqsData       1000
     c                   parm                    PRtnCode          1
     c                   parm                    PRtnID            7
     c                   parm                    PRespData      1000

/5624 * DMSSvrCfg values not required for this call
/5624c                   eval      DMSSvrCfg = *allx'00'

/2815c                   eval      pCfgRqs  = %addr(PRqsData)
     c                   eval      pCfgResp = %addr(PRespData)

      * shutdown sub-program
     c                   if        OpCode = 'QUIT' or %parms <= 1
     c                   if        PgmActive = *on
     c                   eval      POpCode = OpCode
/2815c                   CALL      'SPYCSWEB'    plSpyWeb
     c                   end
     c                   return    OK
     c                   end
     c                   eval      PgmActive = *on

      * get web config parms
/2815c                   if        swWEBAPP <> *blanks and swWEBUSR <> *blanks
     c                   eval      CfgRqAppID =  swWEBAPP
     c                   eval      CfgRqUser  =  swWEBUSR
     c                   eval      CfgRqObTyp =  '*SPYLINK'
     c                   eval      CfgRqObNam =  dcRptTyp
     c                   eval      CfgRqObLib =  *blanks
     c                   if        OmniCaller = 'Y'
     c                   eval      CfgRqIgnAE = '1'
     c                   else
     c                   eval      CfgRqIgnAE = '0'
     c                   endif

     c                   eval      POpCode = 'CFGPARMS'
     c                   CALL      'SPYCSWEB'    plSpyWeb
     c                   if        PRtnCode = #RtnOK
     c                   eval      WebParm = CfgRsLmScr
     c                   else
     c                   callp     RtnSts(R@ERROR:PRtnID)
     c                   return    FAIL
     c                   end

     c                   endif

     c                   return    OK
     c     *pssr         begsr
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   endsr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get document attribute
/3765p GetDocAttr      b
     d                 pi            10i 0
     d OpCode                        10    const                                operation
     d BatchNum                      10    const options(*nopass)
     d BatchRRN                      10i 0 const options(*nopass)

     d dtaBuffer       s           1024    dim(128)
     d PgmActive       s              1    static

J5546  dcl-s pcfsize uns(10);

      * shutdown sub-program
     c                   if        OpCode = 'QUIT' or %parms <= 1
     c                   if        PgmActive = *on
     c                   eval      PCOPCD = 'CLOSEW'
     c                   call      'MAG1092'     PL1092
     c                   end
     c                   return    OK
     c                   end
     c                   eval      PgmActive = *on

      *          Get file attributes.
     c                   eval      PCBTCH = BatchNum                            Batch ID
     c                   eval      PCBRRN = BatchRRN                            Start RRN
     c                   eval      PCOPCD = 'GETATR'                            read opcode
     c                   eval      PCBREQ = 0                                   bytes req.
     c                   eval      pcSofs = 0                                   start offset
     c                   eval      PCCACH = 'Y'                                 cache

     c                   call      'MAG1092'     PL1092
     c                   if        PCRTCD <> *blanks                            error code
     c                   callp     RtnSts(R@ERROR:PCRTCD:PCRTDT)
     c                   end

     c                   return    OK

     c     PL1092        plist
     c                   parm                    PCOPCD           10            Read opcode
     c                   parm                    PCBTCH           10            Batch ID
     c                   parm                    PCBRRN            9 0          Start RRN
J5546c                   parm                    PCSOFS           10 0          StartOffset
     c                   parm                    PCBREQ            9 0          Bytes req.
     c                   parm                    PCCACH            1            Cache
      *                             return
J5546c                   parm                    pcFsize                        Img/filSize
     c                   parm                    PCRET             9 0          Bytes rtn
     c                   parm                    NXTRRN            9 0          Next RRN
     c                   parm                    PCATR                          Attributes
     c                   parm                    dtaBuffer
     c                   parm                    PCRTCD            7            Rtn code
     c                   parm                    PCRTDT          100            Rtn DATA

     c     *pssr         begsr
     c                   callp     RtnSts(R@ERROR)
     c                   return    FAIL
     c                   endsr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get/check revision id
/3765p RevCheck        b
     d                 pi            10i 0
     d BackCount                     10i 0 const                                Revs back

     c                   select
      * Head Revisions Only
     c                   when      BackCount = 0                                heads only
     c                   if        Rs_RevID <> 0 and                            under Rev control
     c                             Rs_RevID <> Rs_HeadID                        not the head
     c                   return    FAIL
     c                   end
      * only BackCount revs back
     c                   when      BackCount < 99999                            x revs back
     c                   if        Rs_HeadNum - Rs_RevNum  > BackCount
     c                   return    FAIL
     c                   end
     c                   endsl

      * skip if pending (work-in-progress)
/3765c                   if        ( Rs_WIPID <> 0 and Rs_RevID = Rs_WIPID )    work in progress
     c                   return    FAIL
     c                   end

     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * add revision entry to hit list
/3765p RevEntry        b
     d                 pi

      * Revision Hit list header
     d RevHdrDS        ds                  based(RevHdrDSp)
     d  rhHdrSiz                      5  0                                      Header Size
     d  rhContID                     20                                         Content ID
     d  rhRevID                      10  0                                      Revision ID
     d  rhLockSts                     5  0                                      Lock Status
     d  rhAnnoAsRev                   1                                         anno as a rev
     d  rhLckSupport                  5  0                                      lock support
     d  rhAllowBranch                 1                                         allow branching
     d  rhCmtCnt                      5  0                                      comment count
     d  rhHitCnt                      5  0                                      hit count

     d VarCharDS       ds                  based(VarCharDSp)
     d  vcDataLn                      5  0                                      length
     d  vcData                    32767                                         data

     d dDataP          s               *                                        dotted notation
     d dDataLn         s              5i 0
     d cDataP          s               *                                        rev comment
     d cDataLn         s              5i 0
     d cCmmtType       s              5i 0
     d cPathP          s               *                                        check out path
     d cPathLn         s              5i 0

     d DomainType      s              9  0

     c                   if        ldRevID > 0                                  under rev control

      * get dotted notation entry
     c                   if        OK <> GetDotNote(ldRevID:dDataP:dDataLn)
     c                   callp     mm_free(dDataP:1)
     c                   eval      dDataLn = 0
     c                   end

      * get checkout path
     c                   if        OK <> GetRevCOPath(ldRevID:cPathP)
     c                   callp     mm_free(cPathP:1)
     c                   end
     c                   if        cPathP <> *null
     c                   eval      cPathLn = %len(%str(cPathP))
     c                   end
     c                   end
      * get comment (type based on lock state)
     c                   eval      DomainType = RevDomTypeMX
/3765c                   if        ldRevLckSts = Lt_ReadOnly or
/    c                             ldRevLckSts = Lt_Exclusive
/    c                   eval      DomainType = RevDomTypeCO
     c                   endif
     c                   if        OK <> DoNotes(Sn_Get:
     c                                    hhBatNum:hhStrPage:ldRevID:
     c                                    cDataP:RevDomainCode:DomainType)
     c                   callp     mm_free(cDataP:1)
     c                   end
     c                   if        cDataP <> *null
     c                   eval      cDataLn = %len(%str(cDataP))
     c                   end

     c                   if        cDataLn > 0
     c                   eval      RevHdrDSp = BufrAlloc(%size(RevHdrDS) +      header size
     c                                           %size(vcDataLn)+dDataLn +      dotted notation
     c                                         2*%size(vcDataLn)+cDataLn +      check out comment
     c                                           %size(vcDataLn)+cPathLn )      check out path
     c                   else
     c                   eval      RevHdrDSp = BufrAlloc(%size(RevHdrDS) +      header size
     c                                           %size(vcDataLn)+dDataLn +      dotted notation
     c                                           %size(vcDataLn)+cPathLn )      check out path
     c                   end

      * build revision header
     c                   clear                   RevHdrDS
     c                   eval      rhHdrSiz = %size(RevHdrDS)
     c                   eval      rhContID = ldContID
     c                   eval      rhRevID = ldRevID
     c                   eval      rhLockSts = ldRevLckSts
     c                   eval      rhAnnoAsRev   = dcAnnoAsRev                  anno as a rev
     c                   eval      rhLckSupport  = dcLckSupport                 lock support
     c                   eval      rhAllowBranch = dcAllowBranch                allow branching
     c                   if        cDataLn > 0
     c                   eval      rhCmtCnt = 1                                 comment count
     c                   end
???  c                   eval      rhHitCnt = 1                                 hit count
     c                   eval      VarCharDSp = RevHdrDSp + %size(RevHdrDS)

      * add dotted notation entry
     c                   eval      vcDataLn = dDataLn
     c                   if        dDataLn > 0
     c                   callp     memcpy(%addr(vcData):dDataP:dDataLn)
     c                   callp     mm_free(dDataP:0)
     c                   end
     c                   eval      VarCharDSp = VarCharDSp +
     c                                          %size(vcDataLn) + vcDataLn

      * add check out comments
     c                   if        cDataLn > 0
     c                   eval      vcDataLn = cCmmtType                         comment type
     c                   eval      VarCharDSp = VarCharDSp + %size(vcDataLn)
     c                   eval      vcDataLn = cDataLn                           comment len
     c                   callp     memcpy(%addr(vcData):cDataP:cDataLn)
     c                   callp     mm_free(cDataP:0)
     c                   eval      VarCharDSp = VarCharDSp +
     c                                          %size(vcDataLn) + vcDataLn
     c                   end

      * add checkout path
     c                   eval      vcDataLn = cPathLn
     c                   if        cPathLn > 0
     c                   callp     memcpy(%addr(vcData):cPathP:cPathLn)
     c                   callp     mm_free(cPathP:0)
     c                   end

     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * check distribution spylinks and convert page numbers
/5921p ChkDistLink     b
     d                 pi            10i 0
     d SpyNumber                     10    value
     d RptStartPage                  10i 0 value
     d RptEndPage                    10i 0 value
     d DistStartPage                  9s 0
     d DistEndPage                    9s 0
     d DistTotalPages                 9s 0

     d SegType         s             10i 0
     d SegID           s             10
     d TotalPages      s             10i 0

     c                   eval       DistStartPage = 0
     c                   eval       DistEndPage = 0
     c                   eval       DistTotalPages = 0
      * skip check
     c                   if        DistSegFile = *blanks                        not requested
     c                               or DSTLNK <> 'Y'                           not enabled
     c                               or OK <> IsRptDistrib(SpyNumber:@user)     not in R/D
     c                   return     OK                                          no segments
     c                   end
      * distribution type (one or any segments)
     c                   if         DistSegFile = *loval
     c                   eval       SegType = sit_any_sub
     c                   eval       SegID   = *blanks
     c                   else
     c                   eval       SegType = sit_SegFile
     c                   eval       SegID   = DistSegFile
     c                   end
      * Convert to distribution page numbers
     c                   if         OK <> CvtToDistPageNbrs(SpyNumber:
     c                                                      SegType:SegID:
     c                                    RptStartPage:RptEndPage:TotalPages)
     c                   return     FAIL                                        not subscribed
     c                   end
     c                   if         TotalPages > 0
     c                   eval       DistStartPage = RptStartPage
     c                   eval       DistEndPage = RptEndPage
     c                   eval       DistTotalPages = TotalPages
     c                   end
     c                   return     OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert distribution link back to report pages
/5921p CvtFromDist     b
     d                 pi            10i 0
     d SpyNumber                     10    value
     d RptStartPage                  10i 0 value
     d RptEndPage                    10i 0 value
     d DistStartPage                  9p 0
     d DistEndPage                    9p 0

     d SegType         s             10i 0
     d SegID           s             10
     d PageNbr         s             10i 0

      * skip check
     c                   if        DistSegFile = *blanks                        not requested
     c                               or DSTLNK <> 'Y'                           not enabled
     c                   eval       DistStartPage = RptStartPage
     c                   eval       DistEndPage =   RptEndPage
     c                   return    OK
     c                   end
      * distribution type (one or any segments)
     c                   if         DistSegFile = *loval
     c                   eval       SegType = sit_any_sub
     c                   eval       SegID   = *blanks
     c                   else
     c                   eval       SegType = sit_SegFile
     c                   eval       SegID   = DistSegFile
     c                   end
      * Convert from distribution page numbers
     c                   eval       PageNbr = DistStartPage
     c                   if         OK = CvtFromDistPageNbr(SpyNumber:
     c                                                      SegType:SegID:
     c                                      RptStartPage:RptEndPage:PageNbr)
     c                   eval       DistStartPage = PageNbr
     c                   end
     c                   eval       PageNbr = DistEndPage
     c                   if         OK = CvtFromDistPageNbr(SpyNumber:
     c                                                      SegType:SegID:
     c                                      RptStartPage:RptEndPage:PageNbr)
     c                   eval       DistEndPage = PageNbr
     c                   end
     c                   return     OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/5635p AddLogEnt       b

     d                 pi

     d wUint           s              5u 0

     c                   eval      LogOpCode = #AURTVLNK
     c                   if        swwebusr <> ' ' and mc_nodeid <> ' '
     c                   eval      wUint = %len(%trimr(mc_nodeid))
     c                   eval      LogNodeID = mm_alloc(wUint+%size(wUint))
     c                   callp     memcpy(LogNodeID:%addr(wUint):%size(wUint))
     c                   callp     memcpy(LogNodeID+%size(wUint):
     c                             %addr(mc_nodeid):wUint)
     c                   endif
     c                   if        swwebusr<>' ' and %subst(swwebusr:1:1)<>'*'
     c                   eval      LogUserID = swwebusr
     c                   else
     c                   eval      LogUserID = @user
     c                   endif
     c                   eval      LogObjID  = lmbatnum
     c                   eval      LogLnkSeq = lmlnkseq
     c                   if        %subst(lmbatnum:1:1) = 'B'
     c                   eval      LogImgSeq = lmstrpage
     c                   else
     c                   eval      LogPagNbr = lmstrpage
     c                   endif
     c                   eval      LogRevID = ldrevid
     c                   callp     LogEntry(%addr(LogDS))

     c                   return

     p                 e

      **************************************************************************
T5783p exitPgmAddHit   b
/
/    d                 pi             1
/
/    d i               s             10i 0
/    d name            s            256
/    d value           s            256
/
/    d lastDocClass    s                   like(rtypid) static
/    d currentChkCls   s              1    static
/
/    c                   if        exitPgmExists
/     * If no change in docClass and instructed not to check the exit program for
/     * this class...add the hit.
/    c                   if        rtypid = lastDocClass and
/    c                             currentChkCls = BH_CHKCLS_NO
/    c                   return    BH_ADDHIT_YES
/    c                   endif
/     * If there is a change in docClass ask the exit program if this class
/     * should be checked.
/    c                   if        rtypid <> lastDocClass
/    c                   eval      lastDocClass = rtypid
/    c                   callp     nvpHandler(NVP_PUT:BH_NVP_CHKCLS:
/    c                             %trim(rtypid))
/    c                   call      qualExitPgm
/    c                   parm                    nvpHandlerP
/    c                   callp     nvpHandler(NVP_GET:%addr(name):%addr(value))
/    c                   eval      currentChkCls = value
/     * If exit program instructs not to check for the current docClass then
/     * add the hit.
/    c                   if        name = BH_NVP_CHKCLS and value = BH_CHKCLS_NO
/    c                   return    BH_ADDHIT_YES
/    c                   endif
/    c                   endif
/     * Send the exit program hits to be validated.
/    c                   eval      lastDocClass = rtypid
/    c                   callp     nvpHandler(NVP_PUT:BH_NVP_DOCCLS:
/    c                             %trim(rtypid))
/    c                   for       i = 1 to dcValCnt
/    c                   callp     nvpHandler(NVP_PUT:BH_NVP_NDXNAM:
/    c                             %trim(%subst(dcValNam(i):2:9)))
/    c                   callp     nvpHandler(NVP_PUT:BH_NVP_NDXVAL:
/    c                             %str(lmValP(i):lmValLn(i)))
/    c                   endfor
/    c                   call      qualExitPgm
/    c                   parm                    nvpHandlerP
/    c                   callp     nvpHandler(NVP_GET:%addr(name):%addr(value))
/     * Return result from exit program...add the hit or don't add the hit.
/    c                   if        name = BH_NVP_ADDHIT
/    c                   return    value
/    c                   endif
/    c                   endif
/
/    c                   return    BH_ADDHIT_YES
/
/    p                 e
/1509 //----------------------------------------------------------------------------
/    pSecLnkAddHit     b
/     //----------------------------------------------------------------------------
/    dSecLnkAddHit     pi             1a
/    d i               s             10i 0
/    d name            s            256
/    d value           s            256
/
/    d lastDocClass    s                   like(rtypid) static
/    d currentChkCls   s              1    static
/    d strReturn       s              1a
/
/      if blnSecLnk = TRUE;
/        // If no change in docClass and instructed not to check the exit program for
/        // this class...add the hit.
/        if rtypid = lastDocClass and
/              currentChkCls = BH_CHKCLS_NO;
/          return BH_ADDHIT_YES;
/        endif;
/        // If there is a change in docClass ask the exit program if this class
/        // should be checked.
/        if rtypid <> lastDocClass;
/          lastDocClass = rtypid;
/          nvpHandler(NVP_PUT:BH_NVP_CHKCLS:
/              %trim(rtypid));
/          MaSecLnk(nvpHandlerP);
/          nvpHandler(NVP_GET:%addr(name):%addr(value));
/          currentChkCls = value;
/          // If exit program instructs not to check for the current docClass then
/          // add the hit.
/          if name = BH_NVP_CHKCLS and value = BH_CHKCLS_NO;
/            return BH_ADDHIT_YES;
/          endif;
/        endif;
/        // Send the exit program hits to be validated.
/        lastDocClass = rtypid;
/        nvpHandler(NVP_PUT:BH_NVP_DOCCLS:
/            %trim(rtypid));
/        for i = 1 to dcValCnt;
/          nvpHandler(NVP_PUT:BH_NVP_NDXNAM:
/              %trim(%subst(dcValNam(i):2:9)));
/          nvpHandler(NVP_PUT:BH_NVP_NDXVAL:
/              %str(lmValP(i):lmValLn(i)));
/        endfor;
/        MaSecLnk(nvpHandlerP);
/        nvpHandler(NVP_GET:%addr(name):%addr(value));
/        // Return result from exit program...add the hit or don't add the hit.

/        If name = BH_NVP_ADDHIT;
           strReturn = %subst(value:1:1);
           Return strReturn;
/        EndIf;

/      endif;
/
/      return BH_ADDHIT_YES;
/    pSecLnkAddHit     e
/     *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/    pGetSecRule       b
/    dGetSecRule       pi              n
/    d blnReturn       s               n   inz(FALSE)
/      If not %open(adseclnk1);
/        Open(e) adseclnk1;
/      EndIf;

/      Chain (RTypID) adseclnk1;
/      Close(e) adseclnk1;
/
/      If %found = TRUE;
/        blnReturn = TRUE;
/      Else;
/        blnReturn = FALSE;
/      EndIf;
/
/      Return blnReturn;
/    pGetSecRule       e
J4602pIsQualified      b
/    dIsQualified      pi              n
/    d intReturn       s               n   inz(FALSE)
/    d i               s             10i 0
/    d strFilter       s            256a   inz
/       For i = 1 to MaxIndx;
/
/         If ( %trim(%str(lmValP(i):lmValLn(i))) <> *blanks );
/           intReturn = TRUE;
/           Return intReturn;
/         EndIf;
/
/       EndFor;
/
/       For i = 1 to MAXQRYLN;
/
/         If ( QrValue( i ) <> *blanks );
/           intReturn = TRUE;
/           Return intReturn;
/         EndIf;
/
/       EndFor;
/
/       Return intReturn;
/    pIsQualified      e

      * Return indicator *ON if passed value are all digits or *OFF if it is not.
J4772p isDigits        b
J4772d                 pi              n
J4772d inputDateStr                   8
J4772d digits          s             10    inz('0123456789')

J4772  if %checkr(digits:inputDateStr) = 0;
J4772    return *on;
J4772  else;
J4772    return *off;
J4772  endif;
J4772p                 e
**ctdata KSL    Order of DB-KEY for the Index-DB 1-8   (READE Simulation  245
12345678
21345678
31245678
41235678
51234678
61234578
71234568
81234567
**ctdata qryOpCode
CT   LIKE
DC   NOT LIKE
EQ   =
GE   >=
GT   >
LE   <=
LIKE LIKE
LT   <
NE   <>
NLIKENOT LIKE

      *%METADATA                                                       *
      * %TEXT Display OmniLinks                                        *
      *%EMETADATA                                                      *
     h bnddir('SPYBNDDIR')
      /copy directives
      ************----------------------------
      * DSPHYPLNK   Display Hyper (Omni) Links
      ************----------------------------
      *
     FDSPHYPBD  CF   E             WORKSTN INFDS(DSDSP)
     F                                     USROPN
     F                                     SFILE(SFS1:RRN)
     FDSPHYPB2  CF   E             WORKSTN INFDS(DSDSP2)
     F                                     USROPN
     F                                     SFILE(SFS2:RRN2)
     FAHYPLNKD  IF   E           K DISK
     FCHYPIDXD  IF   E           K DISK
     FRLNKDEF   IF   E           K DISK
     FRMAINT1   IF   E           K DISK
/8607FRMAINT4   IF   E           K DISK    rename(rmntrc:rmntrc4)
     FMRPTDIR7  IF   E           K DISK    USROPN
     FMIMGDIR   IF   E           K DISK    USROPN
      *
     FRINDEX1   IF   E           K DISK
      *
T6765 * 01-08-08 PLR Report security is not acknowledged. For instance, if a user
      *              is secured from printing a report they will not be restricted
      *              from doing so through the OmniLink.
/6692 * 12-05-07 EPG Enable multiple entries within an OmniLink Hit list to be selected.
/     *              Enable a single attachment to be selected, and sent.
T6401 * 06-14-07 EPG Omnilink display problem when report heading is on the last line.
T4774 * 10-04-05 PLR Date range selection was invalid. Was xlate'ing blanks to
      *              zeros when not necessary. Caused call to SPYCVTDAT to return
      *              error.
/8607 * 10-29-03 PLR Use SPYCSHREP to return list of reports for selection criteria.
/6708 * 10-21-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte binary.
      *              Remove access to MRPTDIR, use MRPTDIR1 instead.
      *              Change FILNUM (in MRPTDIR) to be the actual spool file number and
      *              change MRPTDIR1 key to include the spool file opened date.
/8652 * 10-10-03 GT  Fix call to SPYERR from APPSEC routine.
      *              (Was not passing any parms, causing SPYERR to crash.)
/6693 * 06-28-02 PLR Fix scrolling issues involving F18 and pageup.
/6609 *  5-15-02 DLS Add INTERFACE parameter for Gumbo SpoolMail support.
/5197 * 08-07-01 KAC Fix APPLICATION SECURITY FOR NOTES
/3765 *  6-11-01 KAC Add lock check for Revision Control.
/3393 *  2-16-01 DLS Add IGNBATCH parameter
/3989 * 02/15/01 DLS AVOID 9TH IMAGE OVERLAP TO 1ST IMAGE ON NEXT PAGE
/3865 * 01/23/01 JAM Correct report type for StaffView cases.
/2930 *  9-19-00 KAC Add CodePage parameter
/2256 *  9-08-00 DLS Call to SPYLNKV RTNCOD of 'E' if Cmd3 form viewer.
/2839 *  7-31-00 KAC ADD APPLICATION SECURITY FOR NOTES
/813  *  7-26-00 KAC REAPPLY REVISED NOTES INTERFACE CHANGES
/2852 *  7-18-00 DM  Faxing many rpts with 1 image problem
/2122 *  7-25-00 DLS Pass backwards view link not running
/2423 *  4-17-00 FID Fixed code for EXPOBJSPY
/2499 *  3-06-00 DLS PASS BACKWARDS INVALID FILTER RESULT
/2427 *  2-14-00 KAC REMOVE REVISE NOTES INTERFACE CHANGES
/2319 * 12-14-99 KAC PASS "INIT" TO SPYCSHHIT
      * 12-01-99 KAC FIXED SFL SELECTABLE HEADING BUG                 2216HQ
      * 11-19-99 JJF Add capability for IFS destination (ExpObjSpy cmd)
      *  9-24-99 KAC FIX DUPS *NO & *ALL FOR REPORTS
      *  9-09-99 KAC ADD STAFFVIEW CASE START OPTION
      *  7-30-99 KAC REVISE NOTES INTERFACE
      *  7-09-99 KAC BOMBS IF MORE THAN 9 IMAGES SELECTED
      *  7-08-99 KAC CLEAR OPTION ON NEXT SFL PAGE.  SFLNXTCHG BUG
      *  6-30-99 KAC SFL BOMBS IF PAGEDOWN AND NO MORE DATA TO LOAD
      *  6-01-99 JJF Allow SPYCSHHIT to return mult Big5's in DTS  1842HQ
      *  3-26-99 FID Clear status message if query is active
      *  2-11-98 JJF Send '*OMNILINK' instead of 'OMNILINK' to SPYLNKVU
      *  1-11-99 JJF Add MSGDTA prm to LINKVU call. Also process error
      *              msg returned from pgm SPYLNKVU (subr CALLVW).
      * 12-17-98 FID Add Email support for API call SNDOBJSPY
      * 12-10-98 KAC change spycslnk parm list include msg id & data
      * 12-08-98 GT  Change call to CVTDAT to SPYCVTDT
      * 12-06-98 FID Use SPUCSHHOT and allow QUERY search
      *              also use mag210 for printing
      *              allow omniapicmd to run in batch
      *              add new f keys etc., etc...
      *  8-14-98 kac Add report printing via omniserver
      *  3-16-98 KAC Add support for r/dars & imageview reports
      *  1-22-98 GK  Add HYP0004 Report linked msg.
      *  4-30-97 GK  Chg Mag2032 Libr parm to DtaLib.
      *  8-13-96 JJF Display index args in custom sort order (SRSORT).
      *  7-02-96 PAF Add ability to print Images and Reports
      *  5-29-96 JJF Change SpyCSLnk's return data fields 99 to 70 byts
      *  3-29-96 JJF Call new pgm, SpyLnkVu (vs. SpyAPI) to view.
      *              Fix F11 toggle view error from 3/8/96.
      *  3-08-96 JJF Auto-select all S2 hit list when few hits.  Elim
      *              MULT opcodes by letting VIEW be offset value.
      *  2-28-96 JJF Allow OmniAPI call to this program (BIG *ENTRY).
      * 12-04-95 JJF Call SpyAPI to view multiple (vs single) images.
      * 11-22-95 JJF Call SpyCSLnk for Link file data.
      * 10-10-95 JJF Format input: begin & end dates to YYYYMMDD.
      *  4-26-96 FID Date from to creation date format international
      *              Read 'created' from msgf
      *              Read 'no entry found' from msgf
      *  2-16-95 FID New program
      *
      * This program has 2 screens:
      *
      *  DSPHYPBD  User supplies search arguments and selects SpyLinks
      *       to be used.  This format can be overridden by a custom
      *       user format.  See ADSPF in AHypLnkD.
      *  DSPHYPB2  Displays hit lists from multiple SpyLinks, allowing
      *       the user to select link(s) for viewing.
      *
      *       KC   F3    Exit
      *       KE   F5    Refresh
      *       KL   F12   Cancel
      *       01   Fxx   VALIDCMDKEY
      *       10         Display OPTION in subfile
      *       11         Subfile next change - position cursor
      *       12         Protect search args on format
      *       13         Protect report selection on format
      *       50         Error
      *       59         Error option
      *       60 - 68    Error VALUE FIELDS
      *       70 - 71    SF Control 1
      *       72 - 73    SF Control 2
      *       75         MsgSfs
      * ************************************************************
      *
T6765d checkAuthority  pr            10i 0
     d  option                       10i 0 value

     D TXT             S            132    DIM(5)                               FKYVIW texts
     D TX2             S            132    DIM(5)                               FKYVIW texts
      * Query selection parms
     D AO              S              3    DIM(25)                              And/or
     D FN              S             10    DIM(25)                              Field Name
     D TE              S              5    DIM(25)                              Test
     D VAF             S             30    DIM(25)                              Value SAVE

     D WH              S             50    DIM(20)                              Window Handle
     D US              S              1    DIM(7)                                 Used: 1/' '
     D AN              S              1    DIM(7)                                 Type: A/N
     D F               S              1    DIM(7)                                 Force input
     D LC              S              1    DIM(7)                                 Check(LC)
     D D               S              1  0 DIM(7)                                 Dec pos
     D TI              S              1  0 DIM(7)                                 Index target
     D L               S              2  0 DIM(7)                                 Length
     D IE              S              3  0 DIM(7)                                 Pos per indx
     D PG              S             10    DIM(7)                                 User program
     D VA              S             99    DIM(7)                                 Value
     D SA              S             12    DIM(7)
     D WRK             S             99    DIM(7)

     D IO              S              3  0 DIM(11)                              IO pos IDX
     D IP              S              3  0 DIM(11)                              IO pos SFS
     D IN              S             10    DIM(11)                              Index name
     D ID              S             30    DIM(11)                              Index desc

     D VI              S              4  0 DIM(9)                               View img RRNs

     D PA              S              1    DIM(99)                              Parameters
     D V               S              1    DIM(99)                              Value
     D VZ              S              1    DIM(99)                              Value target
     D HD              S              1    DIM(500)                             Header


     D CL              S             75    DIM(3) CTDATA PERRCD(1)              Cmd Language

     D SPV             S             99    DIM(7)                               USRSPC VAELUS
     D IV              S             99    DIM(7)                               Input values

     D PRS             S              1    DIM(100)                             Print secur

      * Email Text
     D @TXT            S             65    DIM(5)                               Text Lines Email
     D ETXT            S             65    DIM(5)                               Text Lines Email

     D OT              S            132    DIM(10)                              OPTIOM texts
     D FKT             S            132    DIM(5)                               FKYVIW texts
/2204D CHKP            S              1    DIM(256)                             IFS work array
/2839D AUT             S              1    DIM(25)                              Auth returns
/    D AUTE            S              1    DIM(40)                              EXTENDED Auth return

     D HITB5           DS
      *             Big5   structure for  spycshhit
     D  HRNAM                  1     10
     D  HJNAM                 11     20
     D  HPNAM                 21     30
     D  HUNAM                 31     40
     D  HUDAT                 41     50
     D                 DS                  INZ
      *             Binary for sndmsg api
     D  STSLE#                 1      4B 0
     D  STSST#                 5      8B 0

     D DSPSDT          DS           768    OCCURS(9)
     D HITSDT          DS           768    OCCURS(10)
      *             Return structure from spycshhit
     D SDT             DS           768
     D  SDTRV1                 1     70
     D  SDTRV2                71    140
     D  SDTRV3               141    210
     D  SDTRV4               211    280
     D  SDTRV5               281    350
     D  SDTRV6               351    420
     D  SDTRV7               421    490
     D  SDTRV8               491    498
     D  SDTRV9               499    506
     D  SDTNAM               507    516
     D  SDTNM1               507    507
     D  SDTSEQ               517    525
     D  SDTSPG               526    534
     D  SDTEPG               535    543
     D  SDTSEC               544    546
     D  SDTTYP               547    547
     D  SDTFIL               548    555
     D  SDTEXT               556    557
     D  SDTLIB               558    567
     D  SDTBI5               568    617
     D  SDTRNA               568    577
     D  SDTJNA               578    587
     D  SDTPNA               588    597
     D  SDTUNA               598    607
     D  SDTUDA               608    617
     D  SDTLOC               618    618
     D  SDTNOT               619    619
     D  SDTPCT               620    624
     D  SDTRO#               634    642
     D  SDTRF#               643    651

/3989D SAVSDT          DS           768

     D HITFLT          DS          1000
      *             Filter for spycshhit
     D  HV                     1    693    DIM(7)                                 Hit values
     D  FLTFRM               694    701
     D  FLTTO                702    709
     D  FLTVER               710    719
     D  FLTSEQ               720    728  0
     D  SEL                  729    853    DIM(125)                             Selected=1
     D  FLTTYP               854    863
     D SAVFLT          DS          1000
     D DSF#            DS
     D  @FILNU                 1      4B 0
     D TX1024          DS          1024    INZ
     D                 DS                  INZ
      *             Actionfile attach path
     D  PATHDS                 1    100
     D  ARNAM                  1     10
     D  AJNAM                 11     20
     D  APNAM                 21     30
     D  AUNAM                 31     40
     D  AUDAT                 41     50
     D  ASTR                  51     59
     D  AEND                  60     68
     D  ATYPE                 69     69
     D SDTPRM          DS           768
     D                 DS                  INZ
     D  KV                     1    768    DIM(768)                             Key value
     D  LXIV                   1    490    DIM(7)                                 Values Rtn
     D  LXIV8                491    498
     D  LDXNAM               507    516
     D  LDXNA1               507    507
     D  LXSEQA               517    525
     D  OXSPGA               526    534
     D  OXEPGA               535    543
     D  OXTLOC               618    618
     D  OXTRO#               634    642
     D  OXTRF#               643    651

     D  VL1                    1     70
     D  VL2                   71    140
     D  VL3                  141    210
     D  VL4                  211    280
     D  VL5                  281    350
     D  VL6                  351    420
     D  VL7                  421    490
     D  VL8                  491    498
     D FULLRC          DS                  INZ
     D fRC                     1    700    DIM(700)                             Record

     D SAVERC          DS           700    INZ

     D BUSAV           DS           413
     D                 DS                  INZ
     D  BU                     1    413    DIM(413)                             E/a buffer
     D  W1##                   1     59
     D  W2##                  60    118
     D  W3##                 119    177
     D  W4##                 178    236
     D  W5##                 237    295
     D  W6##                 296    354
     D  W7##                 355    413
     D                 DS                  INZ
      *             Index names for screen BF01
     D  NAMES                  1     70
     D  NAME1                  1     10
     D  NAME2                 11     20
     D  NAME3                 21     30
     D  NAME4                 31     40
     D  NAME5                 41     50
     D  NAME6                 51     60
     D  NAME7                 61     70

     D @CVRTX          s            780

     D               ESDS                  EXTNAME(CASPGMD)
      *             Prog Status
     D                 DS                  INZ
      *             Binaries
     D  STKCNT                 1      4B 0
     D  ERRCOD                 5      8B 0
     D DSDSP           DS
     D  KEY                  369    369
     D  CSRLOC               370    371B 0
     D  WINLOC               382    383B 0
     D  SFLZ                 378    379B 0
     D DSDSP2          DS           383
     D  SFLZ2                378    379B 0
     D                 DS                  INZ
     D  W                      1     40    DIM(40)                              Edit word
     D  DWRD                   1     40
     D                 DS                  INZ
     D  LN                     1    110    DIM(11)                              Index name
     D  LNDXN1                 1     10
     D  LNDXN2                11     20
     D  LNDXN3                21     30
     D  LNDXN4                31     40
     D  LNDXN5                41     50
     D  LNDXN6                51     60
     D  LNDXN7                61     70

     D IFILTR          DS          1000
     D  IFILTB               729    984
     D SORTDS          DS
     D  SORT#                  1      1
     D  CINAM                  2     11
     D  SORT@                 12     12

     D SYSDFT          DS          1024
     D  LCKF21               223    223
     D  FAXTYP               251    251
     D  DTALIB               306    315
     D  WVACT                654    654
     D  LNKQRY               678    678
     D  SUPEMT               717    717
     D  NOFCLS               718    718
     D  MLACT                771    771

     D ERRCD           DS           116
     D  @ERLEN                 1      4B 0
     D  @ERCON                 9     15
     D  @ERDTA                17    116

     D SPSHIT          C                   CONST('SPYCSHHIT')
     D VT              C                   CONST('}JKLMNOPQR')
     D NT              C                   CONST('0123456789')
     D PSCON           C                   CONST('PSCON     *LIBL     ')
     D SPYSPC          C                   CONST('SPYEXPSPC')
     D OMNLNK          C                   CONST('*OMNILINK')
     D $TITLE          C                   CONST('1')
     D $COLHD          C                   CONST('2')
     D $NORCD          C                   CONST('3')
     D $DATA           C                   CONST('4')

/3765 /copy @MMDMSSRVR                                                          DMS functions

      * check for revision control lock
/3765d ChkRCLock       pr            10i 0
     d BatNum                        10    const
     d StrPage                        9s 0 const
     d LockUser                      10

     d LockUser        s             10

      * function return codes
     d OK              c                   1
     d FAIL            c                   0
     d rc              s             10i 0
/6693d savehdr         s                     like(record)
/    d savetit         s                     like(record)

/8607d CV@DMS71        c                   '71000'
/    d rtnP            s               *
/    d rtnLen          s             10i 0

/8607d OmnRepDS        ds                  based(OmnRepDSp)
/    d  orRepTyp                     10                                         report type
/    d  orRepDesc                    40                                         report desc
/    d  orRepFile                    10                                         report file
/    d  orDftSel                      1                                         default selection
/    d  orLckSupport                  5  0                                      lock support
/    d  orAnnoAsRev                   1                                         anno as a rev
/    d  orAllowBranch                 1                                         allow branching

      *   Function keys
      /copy @FKEYS

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

     C     *ENTRY        PLIST
     C                   PARM                    AHNAM                          OmniLink nam
     C                   PARM                    IVAL1            99            Idx value 1
     C                   PARM                    IVAL2            99            Idx value 2
     C                   PARM                    IVAL3            99            Idx value 3
     C                   PARM                    IVAL4            99            Idx value 4
     C                   PARM                    IVAL5            99            Idx value 5
     C                   PARM                    IVAL6            99            Idx value 6
     C                   PARM                    IVAL7            99            Idx value 7
     C                   PARM                    IVAL8            99            Date from yy
     C                   PARM                    IVAL9            99            Date to   yy
     C                   PARM                    RTNCDE            8            Return code
     C                   PARM                    PRTF              1            Print file y
     C                   PARM                    PRINTR           10            Printer
     C                   PARM                    POUTQ            10            Printer outq
     C                   PARM                    POUTL            10            Printer outq
     C                   PARM                    SBMJOB            1            Sbmjob y/n
     C                   PARM                    JBDESC           10            Jobd
     C                   PARM                    JBDLIB           10            Jobd lib
     C                   PARM                    RPTDFT            1            Y=only defau
      *                                                    A=all report
     C                   PARM                    VALCHG            1            Allow change
     C                   PARM                    PRMSEL            1            Allow select
      * eMail 22-27
     C                   PARM                    ESNDR            60            Email sender
     C                   PARM                    EADTYP            1            Rcvr address
     C                   PARM                    ERCVR            60            Receiver
     C                   PARM                    ESUBJ            60            Subject
     C                   PARM                    ETXT                           Text 5*60
     C                   PARM                    EFMT             10            Format
     C                   PARM                    EJOIN             1            Join
      * DUPS 29
     C                   PARM                    EDUPS             1            DUPLICATES
/2930C                   PARM                    ECDPAG            5            CODE PAGE
/3933C                   PARM                    IGNBAT            1            IGNORE BADBATCH
/6609C                   PARM                    INTFAC            1            SpoolMail Interface

     C                   EXSR      SETAPI

     C     VALCHG        IFEQ      'N'
     C     RPTSEL        ANDEQ     'N'
     C     PRTF          OREQ      'Y'
     C     EMAIL         OREQ      'Y'
     C     DUPS          OREQ      'A'
     C     DUPS          OREQ      'N'
     C                   MOVE      '1'           NOSFL1            1
     C                   EXSR      CHKFLT                                       Chk Filter
     C     ERROR         IFEQ      '1'
     C                   EXSR      QUIT
     C                   END

     C                   ELSE
     C                   MOVE      '0'           NOSFL1
     C                   END

     C     NOSFL1        IFEQ      '0'
     C     ERROR         DOUNE     '1'
     C                   EXSR      WORKS1                                       Get filter
     C                   EXSR      CHKFLT                                       Chk filter
     C                   ENDDO
     C                   END
      * Clear query parms
     C                   CLEAR                   AO
     C                   CLEAR                   FN
     C                   CLEAR                   TE
     C                   CLEAR                   VAF
     C                   CLEAR                   QRYTYP
     C                   Z-ADD     0             #ITHTS            5 0          Img Hits
     C                   Z-ADD     0             #RTHTS            5 0          Rpt Hits
      * Set filter
     C                   EXSR      SETFLT

      * No dups: process one hit and quit
     C     DUPS          IFEQ      'N'
     C                   EXSR      DUPSNO
     C                   EXSR      QUIT
     C                   ENDIF

      * Load the hit list
     C                   EXSR      SRF17

      * Print api is done.
     C     PRTF          IFEQ      'Y'
     C     DUPS          OREQ      'A'
     C                   EXSR      QUIT
     C                   END
      * Work with hit list
     C     GOTONE        IFEQ      '1'
     C                   EXSR      WORKS2
     C                   END

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WORKS1        BEGSR
      *          Search criteria screen

     C     VALCHG        COMP      'N'                                    12     Screen
     C     RPTSEL        COMP      'N'                                    13      protects.
      *>>>>
     C     TOPS1         TAG

     C     *INKD         IFEQ      *OFF
     C                   Z-ADD     0             WINLIN
     C                   Z-ADD     0             WINPOS
     C                   END

     C                   WRITE     WINDOW2
     C     TRRN          COMP      0                                      71     EQ, subfile
     C                   WRITE     MSGSFK                                        is empty.
     C     RPTSEL        CASEQ     'N'           QUIT                           No power,yer
     C                   ENDCS                                                   outta here.

     C                   MOVE      'N'           SEENAL            1            Haven't seen
      *                                                     all matches
     C     VALCHG        IFEQ      'N'                                          Can't change
     C                   WRITE     BF01                                          selectn OK
     C                   MOVEL(P)  'SFK1'        HLPFMT
     C                   EXFMT     SFK1
     C                   ELSE                                                   Full power
     C                   WRITE     SFK1                                          change args
     C                   MOVEL(P)  'BF01'        HLPFMT                              and
      *                 |-------------|                     select rpts
     C                   EXFMT     BF01
     C                   END

     C                   EXSR      CLRMSG
      * FKeys
     C     *IN01         IFEQ      *ON                                          CmdKey
     C     KEY           CASEQ     F3            QUIT
     C     KEY           CASEQ     F4            SRF4
     C     KEY           CASEQ     F5            LODS1S                          F5=Refresh
     C     KEY           CASEQ     F10           SRF10
     C     KEY           CASEQ     F12           QUIT
     C     KEY           CASEQ     F21           SRF21
     C     KEY           CASEQ     F24           SRF24
     C     KEY           CASEQ     HELP          HELPS1
     C                   ENDCS
     C                   GOTO      TOPS1
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     HELPS1        BEGSR

     C                   MOVEL     'DSPHYPBD'    DSPFIL
     C                   CALL      'SPYHLP'      PLHELP
     C     PLHELP        PLIST
     C                   PARM                    DSPFIL           10
     C                   PARM                    HLPFMT           10
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

     C     *DTAARA       DEFINE                  SYSDFT                         Get System
     C                   IN        SYSDFT                                       Defaults

     C                   MOVEL(P)  'SPYLNKVU'    LINKVU           10

     C     WQLIBN        IFEQ      'QTEMP'                                      Using pgm
     C     3             SUBST     WQPGMN:8      PGMSFX            3             name w/sufx
     C     PGMSFX        IFNE      *BLANK
     C                   MOVEL     LINKVU        PGMNAM
     C     'SPYLNKV'     CAT       PGMSFX:0      LINKVU
     C                   CALL      'CLNSPYPR'
     C                   PARM                    PGMNAM           10             Clone this
     C                   PARM                    LINKVU                          to this.
     C                   END
     C                   END
      * Lower/upper case trn table
     C                   CALL      'SPYLOUP'                                    Upper/Lower
     C                   PARM                    LO               60            case table
     C                   PARM                    UP               60
      * Get the current date fmt
     C                   CALL      'MAG8090'
     C                   PARM                    DATFMT            3
     C                   PARM                    DATSEP            1
     C                   PARM                    TIMSEP            1
      * Check if dsp is able to dsp images
     C                   CALL      'CHKIMGD'
     C                   PARM                    IMGDSP            1            1=Img
      * Get job type
     C                   CALL      'MAG1034'                                    0=Batch
     C                   PARM      ' '           JOBTYP            1            1=Interactiv

      * If batch, no changes to filter or report selects
     C     JOBTYP        IFNE      '1'
     C                   MOVEL     'N'           VALCHG
     C                   MOVEL     'N'           PRMSEL
     C                   ENDIF

/2319C                   MOVEL(P)  'INIT'        HITOPC                         START PROGRAM
/    C                   EXSR      CALHIT

     C                   MOVEL     WQPGMN        PGMQ
     C                   CLEAR                   ENTFND
     C     LCKF21        CABNE     'S'                                2121
      * Format the input filter
     C                   EXSR      INFILT
/2839 * Applic sec
/    C                   EXSR      APPSEC
      * Get option prompts
     C                   EXSR      GETOPT

     C     *LIKE         DEFINE    RRN           TRRN
     C     *LIKE         DEFINE    RRN2          TRRN2
     C                   MOVEL     X'2A'         ERR               7
     C                   MOVE      '*ERROR'      ERR
     C                   MOVEL     X'22'         USE
     C                   MOVE      '*USE'        USE               5
     C                   MOVE      *ON           *IN75
     C                   MOVE      *BLANK        MSGKY             4
     C                   MOVEL     '*ALL'        MSGRMV           10
     C                   EXSR      CLRMSG

     C                   Z-ADD     12            TOTSFL            3 0
     C     TOTSFL        SUB       2             TOTDTA            3 0

     C     AHNAM         CHAIN     AHYPLNK                            50        Get AFILE,
     C     *IN50         IFEQ      *ON
     C                   MOVEL     '1'           RTNCDE
     C                   EXSR      QUIT
     C                   END
      * Open files
     C                   EXSR      OPNFIL
      * Interactive: load subfile
     C     JOBTYP        IFEQ      '1'
     C                   EXSR      LODS1S
     C                   ELSE
      * Batch: load index table
     C                   EXSR      GETIDX
     C                   ENDIF

     C                   Z-ADD     1             @RC               3 0          @rc = 1,76
      * Get text from pscon
     C                   EXSR      GETTXT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     INFILT        BEGSR

      * Ival8 and Ival9 have edit check zeros stuck in them.
      * Eval8 and Eval9 maintain their original entry values.
     C                   MOVE      IVAL8         EVAL8            99
     C                   MOVE      IVAL9         EVAL9            99

     C                   MOVE      IVAL1         IV(1)                          Receive *ENT
     C                   MOVE      IVAL2         IV(2)                           parms and
     C                   MOVE      IVAL3         IV(3)                           format
     C                   MOVE      IVAL4         IV(4)                           dates.
     C                   MOVE      IVAL5         IV(5)
     C                   MOVE      IVAL6         IV(6)
     C                   MOVE      IVAL7         IV(7)
     C                   MOVEL(P)  '*YYMD'       INFORM
     C                   SELECT
     C     DATFMT        WHENEQ    'MDY'
     C                   MOVEL(P)  '*MDYY'       OUTFRM           10
     C     DATFMT        WHENEQ    'DMY'
     C                   MOVEL(P)  '*DMYY'       OUTFRM
     C                   OTHER
     C                   MOVEL(P)  '*YYMD'       OUTFRM
     C                   ENDSL
     C                   MOVEL(P)  IVAL8         DATALF
     C     DATALF        IFNE      *ZEROS
     C                   CALL      'SPYCVTDT'    PLCVTD                 50
     C  N50              MOVEL     DATALF        DATEFM
     C                   END
     C                   MOVEL(P)  IVAL9         DATALF
     C     DATALF        IFNE      *ZEROS
     C                   CALL      'SPYCVTDT'    PLCVTD                 50
     C  N50              MOVEL     DATALF        DATETO
     C                   END

     C     PLCVTD        PLIST                                                  Convert date
     C                   PARM                    DATALF           10
     C                   PARM                    INFORM                         From format
     C                   PARM                    OUTFRM           10             To  format
     C                   PARM      *BLANK        ERROR
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OPNFIL        BEGSR
      *          Open files

     C     PLCMDE        PLIST
     C                   PARM                    CMD             120
     C                   PARM      120           F155             15 5

      * Interactive: open dspf's
     C     JOBTYP        IFEQ      '1'
     C     ACRTF         IFEQ      'Y'                                          If FM creatd
     C     CL(2)         CAT(P)    ADSPF:0       CMD                             use ADspF,
     C                   CAT       ')':0         CMD                             @BD00...
     C                   CALL      'QCMDEXC'     PLCMDE                 60       DspHypBD
     C                   END
     C                   OPEN      DSPHYPBD                             50
     C                   OPEN      DSPHYPB2                             50
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETTXT        BEGSR
      *          Retrieve miscellaneous text

     C                   MOVEL(P)  'P003071'     @ERCON                         Filter on
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        FLTTXT           30
     C                   MOVEL(P)  'P00307A'     @ERCON                         Query on
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        QRYTXT           30
     C                   MOVEL     'P030011'     @ERCON                         Created
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        CREATD           10
     C                   MOVEL     'P020055'     @ERCON                         Notes title
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        NOTTIT            6
     C                   MOVEL     'P020030'     @ERCON                         Notes
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        NOTTXT            6
     C                   MOVEL     'P020031'     @ERCON                         Annot
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        ANNTXT            6
     C                   MOVEL     'P020032'     @ERCON                         Both
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        BTHTXT            6

     C                   SELECT
     C     DATFMT        WHENEQ    'MDY'
     C                   MOVEL(P)  '*MDYY'       INFORM           10
     C                   MOVEL     'P030016'     @ERCON
     C     DATFMT        WHENEQ    'YMD'
     C                   MOVEL(P)  '*YYMD'       INFORM
     C                   MOVEL     'P030017'     @ERCON
     C     DATFMT        WHENEQ    'DMY'
     C                   MOVEL(P)  '*DMYY'       INFORM
     C                   MOVEL     'P030015'     @ERCON
     C                   OTHER
     C                   MOVEL(P)  '*YYMD'       INFORM
     C                   MOVEL     'P030018'     @ERCON
     C                   ENDSL
     C                   MOVEL(P)  '*YYMD'       OUTFRM
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        INPFMT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETOPT        BEGSR
      *          Get option prompts

     C                   MOVEL     'OPT0102'     @ERCON                         1=Display
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        TX1024
     C                   MOVEL     'OPT0202'     @ERCON                         2=Print
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024
     C                   EXSR      ACTFIL                                       3=Attach
     C                   CAT       ATTACH:3      TX1024                         Actionfile

     C     FAXTYP        IFNE      '0'
     C     MLACT         OREQ      'Y'
     C                   MOVEL     'OPT1305'     @ERCON                         13=send
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024
     C                   MOVE      '1'           ALWSND            1
     C                   ELSE
     C                   MOVE      '0'           ALWSND            1
     C                   END

/2839C     AUTE(14)      IFNE      'N'                                          NOTES
     C                   MOVEL     'OPT1801'     @ERCON                         18=notes
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024
/    C                   END

     C     WVACT         IFEQ      'Y'                                          STAFFVIEW
     C                   MOVEL     'OPT3101'     @ERCON                         31=START CASE
     C                   EXSR      RTVMSG
     C                   CAT       @MSGTX:3      TX1024
     C                   END

     C     '*'           CHECKR    TITLE1        MAXOPT                         GET FLD LENG

     C                   CALL      'BLDSPOPT'
     C                   PARM                    TX1024                         Text
     C                   PARM                    MAXOPT            5 0          Max length
     C                   PARM      1             MAXLIN            5 0          Max Lines
     C                   PARM                    OT                             Rtn text
     C                   PARM                    MAXF23            5 0          Max pres F23

     C                   Z-ADD     1             OT#
     C                   MOVEL     OT(OT#)       TITLE1
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETFKY        BEGSR

     C                   MOVEL     'FKY0300'     @ERCON                         F3=exit
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF3            30
     C                   MOVEL     'FKY0401'     @ERCON                         F4=prompt
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF4            30
     C                   MOVEL     'FKY0500'     @ERCON                         F5=refresh
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF5            30
     C                   MOVEL     'FKY0500'     @ERCON                         F5=refresh
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF5            30
     C                   MOVEL     'FKY1001'     @ERCON                         F10=query
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF10           30
     C                   MOVEL     'FKY1100'     @ERCON                         F11=alt view
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF11           30
     C                   MOVEL     'FKY1200'     @ERCON                         F12=cancel
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF12           30
     C                   MOVEL     'FKY1701'     @ERCON                         F17=top
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF17           30
     C                   MOVEL     'FKY1801'     @ERCON                         F18=bottom
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF18           30
     C                   MOVEL     'FKY1901'     @ERCON                         F19=step bac
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF19           30
     C                   MOVEL     'FKY2001'     @ERCON                         F20=step fwd
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF20           30
     C                   MOVEL     'FKY2300'     @ERCON                         F23=MORE OPT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        TXTF23           30

     C                   MOVEL(P)  TXTF3         TX1024
     C     ALWF4         IFEQ      '1'
     C                   CAT       TXTF4:3       TX1024
     C                   ENDIF
     C                   CAT       TXTF5:3       TX1024
     C     LNKQRY        IFNE      'N'
     C                   CAT       TXTF10:3      TX1024
     C                   ENDIF
     C                   CAT       TXTF12:3      TX1024

     C                   CALL      'BLDSPKEY'
     C                   PARM                    TX1024                         Text
     C                   PARM      72            MAXFKY            5 0          Max length
     C                   PARM                    TXT                            Rtn text
     C                   PARM                    MAXF24            5 0          Max pres f24
     C                   Z-ADD     1             FKYS#             3 0
     C                   MOVEL(P)  TXT(FKYS#)    FKEYS

     C                   MOVEL(P)  TXTF3         TX1024
     C                   CAT       TXTF5:3       TX1024
     C                   CAT       TXTF11:3      TX1024
     C                   CAT       TXTF12:3      TX1024
     C                   CAT       TXTF17:3      TX1024
     C                   CAT       TXTF18:3      TX1024
     C                   CAT       TXTF19:3      TX1024
     C                   CAT       TXTF20:3      TX1024
     C     MAXF23        IFGT      1
     C                   CAT       TXTF23:3      TX1024
     C                   ENDIF

     C                   CALL      'BLDSPKEY'
     C                   PARM                    TX1024                         Text
     C                   PARM      73            MAXFKY            5 0          Max length
     C                   PARM                    TX2                            Rtn text
     C                   PARM                    MA2F24            5 0          Max pres f24
     C                   Z-ADD     1             FKYS2#            3 0
     C                   MOVEL(P)  TX2(FKYS2#)   FKEY2
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/2839C     APPSEC        BEGSR
      *          Get Application security.

/5197C                   MOVEL     'MAG203'      OBJNAM
     C     'DSPHYP'      CAT       'LNK':0       CALPGM
     C                   CALL      'MAG1060'
     C                   PARM                    CALPGM           10            Calling pgm
     C                   PARM      'N'           PGMOFF            1            Keep it up
     C                   PARM      'O'           CKTYPE            1            Chk (O)bjct
     C                   PARM      'A'           OBJCOD            1            (A)pplicatn
/5197C                   PARM                    OBJNAM           10            Progrm name
     C                   PARM      WQLIBN        OBJLIB           10            Progrm libr
     C                   PARM      *BLANK        RNAME            10
     C                   PARM      *BLANK        JNAME            10
     C                   PARM      *BLANK        PNAME            10
     C                   PARM      *BLANK        UNAME            10
     C                   PARM      *BLANK        UDATA            10
     C                   PARM      07            REQOPT            2 0          Reqstd optn
     C                   PARM      *BLANK        AUTRTN            1            Return Y/N
     C                   PARM      *BLANK        AUT                            Return array
     C                   PARM      *BLANK        AUTE                           Return EXTENDED arra

     C     AUTRTN        IFEQ      'N'
     C                   CALL      'SPYERR'
/8652C                   PARM      'E000009'     MSGID

/8652C                   MOVEL(P)  MSGID         RTNCDE
     C                   EXSR      QUIT                                         USER CANNOT
     C                   END                                                     run this pg

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODS1S        BEGSR
      *          Load subfile 1

      * Chain to A HypLnk to get the @HL... file name of B HypRpt.
      * Read up to 7 recs from C HypIdx to define the indices
      *      (type, length, dec pos, etc.).
      * Read all the recs in the @HL... (B HypRpt) file to show
      *      the available reports on the "X-Select" subfile.

     C                   Z-ADD     0             RRN
     C                   Z-ADD     0             SFLRC1
     C                   Z-ADD     0             TRRN
      * Interactive
     C     JOBTYP        IFEQ      '1'
     C                   MOVEA     '11'          *IN(70)                        Clear
     C                   WRITE     SFK1
     C                   MOVEA     '00'          *IN(10)                        Setof 10-11
     C                   MOVEA     '00'          *IN(70)                              70-71
      * Index names & descs
     C                   EXSR      GETIDX
     C                   ENDIF
      *-----------------------------------------------------
      * Load Report selection subfile (lower half of screen)
      *-----------------------------------------------------
/8607c                   eval      opcode = 'INFO'
/    c                   exsr      replistSR

     C                   Z-ADD     0             IX
/8607c                   do        rtnRecs       IX
/    c                   eval      OmnRepDSp = rtnP +
/    c                             (ix*%size(OmnRepDS)-%size(OmnRepDS))
     C     RPTDFT        IFEQ      'A'
     C                   MOVE      'X'           SELX                            Select All
     C                   ELSE
/8607c                   if        orDftSel = '1'
     C                   MOVE      'X'           SELX
     C                   ELSE
     C                   MOVE      ' '           SELX                            Not this
     C                   END
     C                   END

     C     'X':'1'       XLATE     SELX          SEL(IX)

/8607c     orRepTyp      chain     rmaint4
/    c                   if        not %found
     C                   MOVEL(P)  ERR           RRDESC
     C                   MOVE      ' '           SELX                            Not this
     C                   ENDIF
     C                   ADD       1             TRRN
     C                   Z-ADD     TRRN          RRN
     C     JOBTYP        IFEQ      '1'
      * Must remain compatible with previous display formats - QNDXSRC(HYPDFTDSP)
/8607c                   eval      brnam = rrnam
     C                   WRITE     SFS1                                         Subfile
     C                   ENDIF
     C                   ENDDO

     C                   Z-ADD     1             SFLRC1
      * Interactv
     C     JOBTYP        IFEQ      '1'
     C                   EXSR      GETFKY
     C                   ENDIF
     C                   ENDSR

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/8607c     replistSR     begsr

     c                   call      'SPYCSHREP'
     c                   parm                    ahnam
     c                   parm                    opcode           10
     c                   parm      CV@DMS71      version           5
     c                   parm                    rtnP
     c                   parm                    rtnLen
     c                   parm                    rtnRecs           9 0
     c                   parm                    returnCode        2
     c                   parm                    msgid
     c                   parm                    rtnMsgDta       100

     c                   if        msgid <> ' '
     c                   eval      msgdta = rtnmsgdta
     c                   exsr      sndmsg
     c                   endif

     c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETIDX        BEGSR
      *          Get index names and descriptions

     C                   Z-ADD     1             POSEA             3 0
     C                   Z-ADD     0             #IX
     C                   MOVE      'N'           SORTEM            1
     C                   MOVE      *BLANK        SA
     C                   MOVE      ' '           ALWF4             1            Allow f4
      *                                                    Get file nms
     C     AHNAM         CHAIN     AHYPLNK                            50         AFile ADspF
      *                                                     @hl.. @bd..
     C     AHNAM         SETLL     CHYPIDX                            50

     C                   DO        7                                            Get field
     C     AHNAM         READE     CHYPIDX                                50     desc for
     C   50              LEAVE                                                   each inx in
     C                   ADD       1             #IX               3 0           the OmniLnk
     C     #IX           ADD       30            IX                5 0
     C                   MOVE      *ON           *IN(IX)                        Seton 31-37

     C     ACRTF         IFEQ      'N'                                          Not created
     C                   MOVE      'A'           CART                            set default
     C                   Z-ADD     59            CLAN                            alfa,lng 59
     C                   Z-ADD     0             CDEZ                            0 dec,
     C                   MOVE      'Y'           CLOC                            Check(LC)
     C                   MOVE      'N'           CFIN                            no ForceInp
     C                   END

     C                   MOVE      CINAM         IN(#IX)                        Name
     C                   MOVEL     ' '           IN(#IX)                        Remove @.
     C                   MOVE      CART          AN(#IX)                        Field type
     C                   MOVE      CLAN          L(#IX)                         Length
     C                   MOVE      CDEZ          D(#IX)                         Dec pos
     C                   MOVE      CLOC          LC(#IX)                        Check(LC)
     C                   MOVE      CFIN          F(#IX)                         Force input
     C                   MOVE      CPGM          PG(#IX)                        Program

     C     CPGM          IFNE      *BLANKS
     C                   MOVE      '1'           ALWF4                          Allow f4
     C                   ENDIF

     C     CART          IFNE      'A'                                          Numeric,
     C     ' ':'0'       XLATE     IV(#IX)       IV(#IX)                         zero fill.
     C                   END

     C                   MOVE      CSORT         SORT#                          Load dtastr
     C                   MOVE      #IX           SORT@                           for sort
     C                   MOVE      SORTDS        SA(#IX)                         array.
     C     CSORT         IFGT      0                                            Need to sort
     C                   MOVE      'Y'           SORTEM                          later.
     C                   END
     C                   ENDDO

     C                   Z-ADD     #IX           #CHYP             1 0

     C     SORTEM        CASEQ     'Y'           SRSORT                         Rearrange
     C                   ENDCS                                                   arrays.

     C                   DO        #IX           #
     C                   Z-ADD     POSEA         IE(#)                          Start pos.
     C                   Z-ADD     POSEA         I3                5 0          Setup srch
     C                   MOVEA     IV(#)         BU(I3)                          args, W_##.
     C                   ADD       L(#)          POSEA                          Bump for nxt
     C                   ENDDO

     C                   MOVEA     BU            BUSAV
     C                   MOVEA     IN            NAMES
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRSORT        BEGSR
      *          ------------------------------------------
      *          Sort arrays according to CSORT in CHypIdxD
      *          ------------------------------------------
     C                   SORTA     SA                                           This order:
     C     8             SUB       #IX           START#            1 0          1.Csort
      *                                                    2.Cinam
     C                   MOVE      AN            WRK                            3.Arrive seq
     C                   CLEAR                   AN
     C                   Z-ADD     0             TO                1 0
     C     START#        DO        7             #
     C                   MOVE      SA(#)         FRM               1 0
     C                   ADD       1             TO
     C                   MOVE      WRK(FRM)      AN(TO)
     C                   ENDDO

     C                   MOVE      L             WRK
     C                   CLEAR                   L                              Empty array
     C                   Z-ADD     0             TO                              to WRK.
     C     START#        DO        7             #
     C                   MOVE      SA(#)         FRM                            Reload array
     C                   ADD       1             TO                              in sorted
     C                   MOVE      WRK(FRM)      L(TO)                           order.
     C                   ENDDO

     C                   MOVE      D             WRK
     C                   CLEAR                   D
     C                   Z-ADD     0             TO                1 0
     C     START#        DO        7             #
     C                   MOVE      SA(#)         FRM               1 0
     C                   ADD       1             TO
     C                   MOVE      WRK(FRM)      D(TO)
     C                   ENDDO

     C                   MOVE      LC            WRK
     C                   CLEAR                   LC
     C                   Z-ADD     0             TO
     C     START#        DO        7             #
     C                   MOVE      SA(#)         FRM
     C                   ADD       1             TO
     C                   MOVE      WRK(FRM)      LC(TO)
     C                   ENDDO

     C                   MOVE      F             WRK
     C                   CLEAR                   F
     C                   Z-ADD     0             TO
     C     START#        DO        7             #
     C                   MOVE      SA(#)         FRM
     C                   ADD       1             TO
     C                   MOVE      WRK(FRM)      F(TO)
     C                   ENDDO

     C                   MOVE      PG            WRK
     C                   CLEAR                   PG
     C                   Z-ADD     0             TO
     C     START#        DO        7             #
     C                   MOVE      SA(#)         FRM
     C                   ADD       1             TO
     C                   MOVE      WRK(FRM)      PG(TO)
     C                   ENDDO

     C                   MOVE      IV            WRK
     C                   CLEAR                   IV
     C                   Z-ADD     0             TO
     C     START#        DO        7             #
     C                   MOVE      SA(#)         FRM
     C                   ADD       1             TO
     C                   MOVE      WRK(FRM)      IV(TO)
     C                   ENDDO

     C                   MOVE      IN            WRK
     C                   CLEAR                   IN
     C                   Z-ADD     0             TO
     C     START#        DO        7             #
     C                   MOVE      SA(#)         FRM
     C                   ADD       1             TO
     C                   MOVE      WRK(FRM)      IN(TO)
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRCURS        BEGSR
      *          Cursor position
     C     WINLOC        DIV       256           CSRLIN            3 0               Lin
     C                   MVR                     CSRPOS            3 0               Pos
     C     WINLOC        DIV       256           WINLIN            3 0
     C                   MVR                     WINPOS            3 0
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRMSG        BEGSR
      *          Clear message
     C                   CALL      'QMHRMVPM'
     C                   PARM                    PGMQ
     C                   PARM                    STKCNT
     C                   PARM                    MSGKY             4
     C                   PARM                    MSGRMV           10
     C                   PARM                    ERRCOD
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDMSG        BEGSR
      *          Send message

     C                   MOVEL     MSGID         ALFA6             6

     C     ALFA6         IFEQ      *BLANK
     C                   MOVEL     'E00000'      MSGID
     C                   END

     C     MSGID         IFNE      *BLANKS
     C     API           IFEQ      'A'                                           If Api
     C     SHRCUT        ANDEQ     '1'                                           Shortcut
     C                   MOVEL     MSGID         EMSGID
     C                   MOVEL     MSGDTA        EMSGDT
     C                   EXSR      SPYERR
     C                   END

     C                   CALL      'SNDPMSG'
     C                   PARM                    MSGID             7
     C                   PARM                    MSGDTA          132
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPYERR        BEGSR
     C                   CALL      'SPYERR'                             50
     C                   PARM                    EMSGID            7
     C                   PARM                    EMSGDT          100
     C                   PARM                    EMSGF            10
     C                   PARM                    EMSGFL           10
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKFLT        BEGSR
      *   ----------------------------------------------------------
      *    Check if the filter contains valid values and format date
      *   ----------------------------------------------------------
     C                   CLEAR                   SELTXT
     C                   CLEAR                   VA                             Clear &
     C                   EXSR      LOADVA                                       load  values
     C                   MOVE      '0'           ERROR             1

     C     DATEFM        IFEQ      0
     C                   MOVE      *BLANK        CRTFRM            8
     C                   ELSE
     C                   MOVEL(P)  FLTTXT        SELTXT
     C                   MOVEL(P)  DATEFM        DATALF                         Convert
     C                   CALL      'SPYCVTDT'    PLCVTD                 50
     C     ERROR         IFEQ      '1'
     C                   MOVE      *ON           *IN68
     C                   GOTO      ENDCHK
     C                   END
     C                   MOVEL     DATALF        CRTFRM                           Yyyymmdd
     C                   END

     C     DATETO        IFEQ      0
     C                   MOVE      *BLANK        CRTTO             8
     C                   ELSE
     C                   MOVEL     FLTTXT        SELTXT
     C                   MOVEL(P)  DATETO        DATALF
     C                   CALL      'SPYCVTDT'    PLCVTD                 50
     C     ERROR         IFEQ      '1'
     C                   MOVE      *ON           *IN69
     C                   GOTO      ENDCHK
     C                   END
     C                   MOVEL     DATALF        CRTTO
     C                   END

      * For forced input fields, a value M/B present in VA.
     C                   DO        7             IX                             For 7 indxes
     C     IN(IX)        IFNE      *BLANK                                        Name presnt

     C                   SELECT
     C     AN(IX)        WHENEQ    'A'
     C     VA(IX)        IFEQ      *BLANK                                       Alpha
     C     F(IX)         IFEQ      'Y'                                           w forc inpt
     C     IX            ADD       60            I2                5 0           field
     C                   MOVE      *ON           *IN(I2)                         empty.
     C                   MOVE      '1'           ERROR
     C                   GOTO      ENDCHK
     C                   END
     C                   ELSE
     C                   MOVEL     FLTTXT        SELTXT
     C                   END

     C                   OTHER
     C                   MOVEA     VA(IX)        F99A             99
     C     '0':' '       XLATE     F99A          F99A                           Numeric
     C     F99A          IFEQ      *BLANK                                        field
     C     F(IX)         IFEQ      'Y'                                           w forc inpt
     C     IX            ADD       60            I2                              empty.
     C                   MOVE      *ON           *IN(I2)
     C                   MOVE      '1'           ERROR
     C                   GOTO      ENDCHK
     C                   GOTO      ENDCHK
     C                   END
     C                   ELSE
     C                   MOVEL     FLTTXT        SELTXT
     C                   END
     C                   ENDSL
     C                   END
     C                   ENDDO

     C                   MOVEA     BU            BUSAV
     C     ENDCHK        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LOADVA        BEGSR
      *          --------------------------------
      *          Load VA array (7x99) with values
      *          --------------------------------
     C                   CLEAR                   US
     C                   DO        7             IX                             For each inx
     C     IN(IX)        IFNE      *BLANK                                        in use...
     C                   MOVE      *BLANK        PA                              Clr wrk ary
     C                   Z-ADD     IE(IX)        I2                              Inx positn

     C                   DO        L(IX)         I1                5 0          Put
     C                   MOVE      BU(I2)        PA(I1)                          PU,InxPos
     C                   ADD       1             I2                              into PA
     C                   ENDDO                                                   work array.

     C                   MOVEA     PA            VA(IX)                         All to VA

      * Try to find out, if filter value for index was used
     C     VA(IX)        IFNE      *BLANKS
     C     AN(IX)        ANDNE     'N'
     C                   MOVE      '1'           US(IX)                         Used
     C                   END

      * If index is numeric, test first non zero character
      * if it is LE than the IO buffer length USED=1
     C     AN(IX)        IFEQ      'N'                                          Numeric
     C     '0'           CHECK     VA(IX)        TSTNUL            5 0
     C     TSTNUL        IFLE      L(IX)
     C                   MOVE      '1'           US(IX)                         Used
     C                   END
     C                   END
     C                   END
     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     USRPGM        BEGSR
      *          --------------------
      *          F4=Call user program
      *          --------------------
     C                   MOVEL     FELD          F1A               1

     C     F1A           IFEQ      'W'                                          FELD must
     C     1             SUBST     FELD:2        F1A                             start with
     C     F1A           IFGE      '1'                                           "w1..w7"
     C     F1A           ANDLE     '7'
     C                   MOVE      F1A           #                 1 0           #=1..7

     C     PG(#)         IFNE      '*NONE'                                      Call user
     C     PG(#)         ANDNE     *BLANK                                        program.
     C                   CALL      PG(#)                                50
     C                   PARM      *BLANK        PA
     C     *IN50         IFEQ      *ON                                          Error
     C                   MOVE      'HYP0002'     MSGID
     C                   EXSR      SNDMSG                                        "F4 not
     C                   ELSE

     C                   MOVEA     PA            F99A
     C     F99A          IFEQ      *BLANK
     C     AN(#)         ANDEQ     'N'
     C                   MOVEA     *ZEROS        PA
     C                   END

     C                   Z-ADD     IE(#)         IX

     C                   DO        L(#)          I1
     C                   MOVE      PA(I1)        BU(IX)
     C                   ADD       1             IX
     C                   ENDDO

     C                   END                                                      valid"
     C                   ELSE
     C                   MOVE      'HYP0002'     MSGID
     C                   EXSR      SNDMSG                                        "F4 not
     C                   END                                                      valid"

     C                   ELSE
     C                   MOVE      'HYP0002'     MSGID
     C                   EXSR      SNDMSG
     C                   END

     C                   ELSE
     C                   MOVE      'HYP0002'     MSGID
     C                   EXSR      SNDMSG
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WORKS2        BEGSR
      *          -----------------------------
      *          Work with Screen 2: HIT LIST.
      *          -----------------------------
     C                   WRITE     WINDOW
     C                   WRITE     S2HDR                                        ScreenHeader
      *>>>>
     C     TOPS2         TAG

      * Check for Mag210 Shut down
     C     SEENAL        IFEQ      'Y'                                          Seen all rpt
     C     #ITHTS        ADD       #RTHTS        #HITS             5 0          Hit(s)
     C                   MOVE      '0'           SHRCUT            1
     C                   END

     C     SHOWS2        TAG
     C     *INKD         IFEQ      *OFF                                         No Usr Pgm
     C                   Z-ADD     0             WINLIN                          requested.
     C                   Z-ADD     0             WINPOS
     C                   END

     C     TRRN2         IFEQ      0                                            If zero,
     C                   MOVE      *ON           *IN73                           clear sfl.
     C                   WRITE     S2ERR
     C                   ELSE
     C                   MOVE      *OFF          *IN73
     C                   END

     C                   MOVE      *OFF          *IN72
     C     SFLRC2        IFEQ      0
     C                   Z-ADD     3             SFLRC2
     C                   END
     C                   WRITE     S2MSG
     C                   EXFMT     S2                                           Hit list
     C                   MOVEL     DSDSP2        DSDSP

     C     VALCHG        IFEQ      'N'                                          Called by
     C     RPTSEL        ANDEQ     'N'                                           external
     C     ENTFND        ANDNE     '1'                                           criteria
     C     *IN99         ANDEQ     *OFF                                         no roll
     C                   MOVEL     '3'           RTNCDE                          program.
     C                   EXSR      QUIT                                         Nothing
     C                   END                                                     found...

     C                   EXSR      CLRMSG
     C                   MOVEA     '000000'      *IN(60)                        Setof 60-65
     C     SFLZ2         ADD       2             SFLRC2

     C     *IN01         IFEQ      *ON                                           VldCmdKey
     C     KEY           CASEQ     PAGEDN        SRNEXT                           Next page
     C     KEY           CASEQ     PAGEUP        SRPREV                           PREV. Page
     C     KEY           CASEQ     F5            SRF5
     C     KEY           CASEQ     F11           TGLVEW                           F11
     C     KEY           CASEQ     F17           SRF17
     C     KEY           CASEQ     F18           SRF18
     C     KEY           CASEQ     F19           SRF19
     C     KEY           CASEQ     F20           SRF20
     C     KEY           CASEQ     F21           SRF21
     C     KEY           CASEQ     F23           SRF23
     C     KEY           CASEQ     F24           SRF242
     C                   ENDCS

     C     NOSFL1        IFEQ      '1'                                           Quit
     C     KEY           IFEQ      F12                                           F12 w/API
     C     KEY           OREQ      F3
     C                   EXSR      QUIT
     C                   ENDIF
     C                   ENDIF
     C     KEY           CABEQ     F3            ENDWS1                          F3
     C     KEY           CABEQ     F12           ENDWS1                          F12

     C     KEY           IFEQ      HELP                                          Help
     C                   MOVEL(P)  'DSPHYPB2'    DSPFIL
     C                   MOVEL(P)  'S2'          HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
     C                   END
     C                   GOTO      SHOWS2
     C                   END

     C     SKIPS2        TAG

     C                   Z-ADD     0             #IV               1 0
     C                   MOVE      *BLANK        VI
     C     TRRN2         IFNE      0                                            Empty sfl
     C                   MOVE      'Y'           NUJOIN
     C                   EXSR      DOOPTN
     C                   END

     C     #HITS         CABNE     -99999        SHOWS2                         Loop if not
      *                                                     auto-select
     C     VALCHG        IFEQ      'N'                                          Quit if
     C     RPTSEL        ANDEQ     'N'                                           auto-select
     C     #HITS         ANDEQ     -99999                                        green scren
     C                   EXSR      QUIT                                          scrape.
     C                   END

     C     ENDWS1        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FMTTIT        BEGSR
      *          ------------------------------------
      *          Format the the title for the subfile
      *          ------------------------------------
     C                   CLEAR                   IO                             Compute strt
     C                   CLEAR                   IP                             positions
     C                   Z-ADD     1             IO(1)                          for columns
     C                   Z-ADD     1             IP(1)                          on screen.
     C                   Z-ADD     1             PIO               3 0
     C                   Z-ADD     0             PIS               3 0

     C                   DO        11            IX
     C                   SELECT
     C     IX            WHENLT    8
     C     LN(IX)        IFEQ      *BLANK                                       Nonexistent
     C                   Z-ADD     1             IKLEN                           index
     C                   CLEAR                   IDESC
     C                   ELSE
     C     KEYNA2        CHAIN     INDEXRC                            50        Index exists
     C                   END
     C     IX            WHENEQ    8
     C                   Z-ADD     8             IKLEN                          Date always
     C                   MOVEL(P)  CREATD        IDESC                           exists.
     C     IX            WHENEQ    9
     C                   Z-ADD     5             IKLEN                          Type
     C                   MOVEL(P)  'Type'        IDESC
     C     IX            WHENEQ    10
     C                   Z-ADD     7             IKLEN                          Status
     C                   MOVEL(P)  'Status'      IDESC
     C     IX            WHENEQ    11
     C                   Z-ADD     6             IKLEN                          Notes
     C                   MOVEL(P)  NOTTIT        IDESC
     C                   ENDSL

     C     LN(IX)        IFNE      *BLANK                                       Default desc
     C     IDESC         ANDEQ     *BLANK                                        is inx name
     C     9             SUBST(P)  LN(IX):2      IDESC
     C                   END

     C     IDESC         IFNE      *BLANK                                       Set IX2 to
     C     IX            IFEQ      8                                            For Date
     C                   Z-ADD     10            IX2                            always len
     C                   ELSE                                                   of 10 char
     C     ' '           CHECKR    IDESC         IX2               5 0           larger of
     C     IX2           IFLT      IKLEN                                         desc or
     C                   Z-ADD     IKLEN         IX2                             data field.
     C                   END
     C                   END

     C                   ADD       2             PIS
     C     PIS           ADD       IX2           PIN               3 0
     C     PIN           DIV       70            PN70              3 0
     C     PIS           DIV       70            PS70              3 0

     C     PN70          IFNE      PS70
     C     PN70          MULT      70            PIS
     C                   ADD       1             PIS
     C     PIS           ADD       IX2           PIN
     C                   END

     C                   Z-ADD     PIS           IP(IX)
     C                   Z-ADD     PIN           PIS
     C                   END
     C                   MOVE      IDESC         ID(IX)
     C                   Z-ADD     PIO           IO(IX)                         Dbf IO pos
     C                   ADD       IKLEN         PIO
     C                   ENDDO

     C     PIS           DIV       70            MAXVW                          Max views
     C                   MVR                     REMAIN            3 0           for this
     C     REMAIN        IFNE      0                                             report.
     C                   ADD       1             MAXVW
     C                   END
     C                   SUB       1             MAXVW

     C     MAXVW         IFGT      MAXVEW                                       Max for all
     C                   Z-ADD     MAXVW         MAXVEW            3 0
     C                   END

     C                   DO        11            IX                             Load HD,
     C     ID(IX)        IFNE      *BLANK                                        column
     C                   MOVEL(P)  ID(IX)        F99A                            headings.
     C                   Z-ADD     IP(IX)        IX2
     C                   MOVEA     F99A          HD(IX2)
     C                   END
     C                   ENDDO
      * Save Big5 in subfile
     C                   MOVEL     RRNAM         SDTRNA
     C                   MOVEL     RJNAM         SDTJNA
     C                   MOVEL     RPNAM         SDTPNA
     C                   MOVEL     RUNAM         SDTUNA
     C                   MOVEL     RUDAT         SDTUDA
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FMTSF2        BEGSR

     C                   DO        7             IX                             Spread out
     C                   Z-ADD     IP(IX)        IX3               3 0           in fRC as
     C     IX3           IFNE      0                                             displayed
     C                   MOVEA     LXIV(IX)      fRC(IX3)                        to the user
     C                   END                                                     in a 70 pos
     C                   ENDDO                                                   subfile
      *                                                     field named
      *                                                     "record".
     C                   CLEAR                   DAT10A
     C                   DO        3             I1                             Format date
     C     1             SUBST     DATFMT:I1     F1A               1             as required
     C                   SELECT                                                  by the date
     C     F1A           WHENEQ    'Y'                                           format,
     C                   MOVEL     LXIV8         F4A               4             Datfmt.
     C                   CAT       F4A:0         DAT10A
     C     F1A           WHENEQ    'M'
     C     2             SUBST     LXIV8:5       F2A               2
     C                   CAT       F2A:0         DAT10A
     C     F1A           WHENEQ    'D'
     C                   MOVE      LXIV8         F2A               2
     C                   CAT       F2A:0         DAT10A           10
     C                   ENDSL
     C     I1            IFNE      3
     C                   CAT       DATSEP:0      DAT10A
     C                   END
     C                   ENDDO

     C                   Z-ADD     IP(8)         IX3                            Date
     C                   MOVEA     DAT10A        fRC(IX3)
     C                   Z-ADD     IP(9)         IX3                            Type
     C                   MOVEA     SDTPCT        fRC(IX3)
     C                   Z-ADD     IP(10)        IX3                            status

     C                   SELECT
     C     SDTLOC        WHENEQ    '1'
     C                   MOVEA     'Offline'     fRC(IX3)
     C     SDTLOC        WHENEQ    '2'
     C                   MOVEA     'Optical'     fRC(IX3)
     C                   OTHER
     C                   MOVEA     'Online'      fRC(IX3)
     C                   ENDSL

     C                   Z-ADD     IP(11)        IX3                            Notes
     C                   SELECT
     C     SDTNOT        WHENEQ    '1'
     C                   MOVEA     NOTTXT        fRC(IX3)
     C     SDTNOT        WHENEQ    '2'
     C                   MOVEA     ANNTXT        fRC(IX3)
     C     SDTNOT        WHENEQ    '3'
     C                   MOVEA     BTHTXT        fRC(IX3)
     C                   OTHER
     C                   MOVEA     '      '      fRC(IX3)
     C                   ENDSL

     C                   MOVEA     fRC(@RC)      RECORD
     C                   MOVE      LXSEQA        LXSEQ                          Sequence #
     C                   MOVE      LXSEQA        SPYSEQ            9 0
     C                   MOVE      SDTSPG        OXSPG                          Start & end
     C                   MOVE      SDTEPG        OXEPG                            pages
     C                   MOVE      SDTRO#        OXTRO                          R/dars offse
     C                   MOVE      SDTRF#        OXTRF                          R/dars file#
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRTS2F        BEGSR
      *          -------------------------------
      *          Write to S2's Subfile. FORWARD
      *          -------------------------------
     C     PRTF          IFNE      'Y'
     C     DUPS          ANDNE     'A'
     C                   MOVE      *IN10         FMIN10                         NodisplyProt
     C                   ADD       1             #ONPAG
     C     #ONPAG        IFLE      TOTSFL
     C                   ADD       1             TRRN2
     C                   Z-ADD     TRRN2         RRN2
     C                   WRITE     SFS2
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRTS2B        BEGSR
      *          -------------------------------
      *          Write to S2's Subfile. BACKWARD
      *          -------------------------------
     C                   MOVE      *IN10         FMIN10                         NodisplyProt
     C                   ADD       1             #ONPAG
     C     #ONPAG        IFLE      TOTSFL
     C                   SUB       1             TRRN2
     C                   Z-ADD     TRRN2         RRN2
     C                   WRITE     SFS2
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRTHD2        BEGSR
      *          ---------------------------------------------------
      *          Write report title & column headers in S2's Subfile
      *          ---------------------------------------------------
     C                   MOVE      *ON           *IN10                          Protect
     C                   MOVE      *OFF          *IN11                          Sflnxtchg
     C     DIRECT        IFEQ      'FORW'
     C                   EXSR      WRTTIT
     C                   EXSR      WRTHDR
     C                   ELSE
     C                   EXSR      WRTHDR
     C                   EXSR      WRTTIT
     C                   ENDIF

     C                   MOVE      SAVERC        FULLRC
     C                   MOVE      *OFF          *IN10
     C                   CLEAR                   RECORD
     C                   CLEAR                   fRC
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRTTIT        BEGSR
     C                   MOVE      $TITLE        FORMAT                         Report Title
     C     RRNAM         CAT(P)    RRDESC:1      RECORD
     C     DIRECT        IFEQ      'FORW'
     C                   EXSR      WRTS2F
     C                   ELSE
/6693c                   if        lstbi5 <> sdtbi5 and lstbi5 <> ' '
/    c                   eval      record = savetit
/    c                   endif
/    c                   eval      savetit = record
     C                   EXSR      WRTS2B
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRTHDR        BEGSR

     C                   MOVE      $COLHD        FORMAT                         Col headers
     C                   Z-ADD     1             IX                             Ix = 1,76
     C                   DO        VIEW                                              etc.
     C                   ADD       70            IX
     C                   ENDDO

     C                   MOVE      FULLRC        SAVERC
     C                   MOVEA     HD            fRC
     C                   MOVEA     HD(IX)        RECORD
     C                   MOVE      *ON           *IN10                          Protect
     C                   MOVE      *OFF          *IN11                          Sflnxtchg
     C     DIRECT        IFEQ      'FORW'
     C                   EXSR      WRTS2F
     C                   ELSE
/6693c                   if        lstbi5 <> sdtbi5 and lstbi5 <> ' '
/    c                   eval      record = savehdr
/    c                   endif
/    c                   eval      savehdr = record
     C                   EXSR      WRTS2B
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SHORPT        BEGSR
      *          ----------------------------------------
      *          Call SpyAPI to get the viewer for REPORT
      *          ----------------------------------------
     C     #IV           CASGT     0             SNDIMG                         Flush images
     C                   ENDCS

     C                   Z-ADD     0             LXSEQ
     C                   EXSR      CALLVW                                       Viewer
/2256C     MSGID         IFNE      *BLANKS
/2256C     MSGID         ANDNE     'EXIT'
/2256C                   EXSR      SNDMSG
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALLVW        BEGSR
      *          Call the Viewer (SpyLnkVu)

     C                   MOVEL(P)  VL1           SDTRV1
     C                   MOVEL(P)  VL2           SDTRV2
     C                   MOVEL(P)  VL3           SDTRV3
     C                   MOVEL(P)  VL4           SDTRV4
     C                   MOVEL(P)  VL5           SDTRV5
     C                   MOVEL(P)  VL6           SDTRV6
     C                   MOVEL(P)  VL7           SDTRV7
     C                   MOVEL(P)  VL8           SDTRV8
     C                   MOVE      OXSPG         SDTSPG
     C                   MOVE      OXEPG         SDTEPG
     C                   MOVE      OXTRO         SDTRO#                         R/dars & ima
     C                   MOVE      OXTRF         SDTRF#                         R/dars & ima
     C                   MOVE      LXSEQ         SDTSEQ
     C                   MOVE      LDXNAM        SDTNAM
      * Move datastructure
     C                   MOVE      SDT           SDTPRM

     C     *LIKE         DEFINE    OXSPG         OXSPGZ
     C     *LIKE         DEFINE    OXEPG         OXEPGZ
     C     SDTLOC        IFEQ      '4'                                          R/dars optic
     C     SDTLOC        OREQ      '5'                                          R/dars qdls
     C     SDTLOC        OREQ      '6'                                          Imageview op
     C                   Z-ADD     OXTRO         OXSPGZ
     C                   Z-ADD     OXTRF         OXEPGZ
     C                   ELSE
     C                   Z-ADD     OXSPG         OXSPGZ
     C                   Z-ADD     OXEPG         OXEPGZ
     C                   END

     C     '*'           CAT(P)    'OMNILINK'    CALLID
     C                   CALL      LINKVU        PLVIEW                         SpyLnkVu
     C     PLVIEW        PLIST
     C                   PARM                    LNKFIL
     C                   PARM                    LDXNAM
     C                   PARM                    LXSEQ
     C                   PARM                    OXSPGZ
     C                   PARM                    OXEPGZ
     C                   PARM      'Y'           PRNTAU            1
     C                   PARM                    SDTPRM                         Data
     C                   PARM                    IMG##
     C                   PARM                    VACTIO            1            View Action
     C                   PARM                    RTYPID
     C                   PARM                    CALLID           10            *OMNILINK
     C                   PARM                    MSGID
     C                   PARM                    MSGDTA

     C                   SELECT
     C     MSGID         WHENEQ    'TERMINL'                                    Used Mag203
     C                   MOVE      *BLANKS       MSGID                           green scrn
     C     MSGID         WHENEQ    *BLANKS                                      Used
     C                   MOVEL     LDXNAM        RPTTST            1             OmniServer
     C     RPTTST        IFEQ      'S'
      *          'Report linked for display.'
     C                   MOVE      'HYP0004'     MSGID
     C                   EXSR      SNDMSG
     C                   MOVE      *BLANKS       MSGID
     C                   END
     C                   END

/2122C                   SELECT
/    C     MSGID         WHENEQ    'ERR156A'
/    C     MSGID         OREQ      'ERR156B'
/    C                   MOVEL(P)  MSGID         RTNCDE
/    C     RTNCDE        WHENEQ    'F'
     C                   MOVEL(P)  ' '           RTNCDE
/2122C                   ENDSL
     C                   MOVE      'Y'           VIEWUP            1
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SHOIMG        BEGSR
      *          ------------------------------------------------------
      *          User has requested viewing of an image...
      *            If we have 9 images queued up for viewing, send them
      *            Else If this request is for a different doc type
      *                 send any in queue.
      *          Queue this request.
      *          ------------------------------------------------------

      * check for exclusive revision control lock
/3765c                   move      oxspg         oxspgn            9 0
/    c                   if          OK <> ChkRCLock(ldxnam:oxspgn:LockUser)
/    c                                  and LockUser <> *blanks
/    c                   eval      msgid = 'ERR1619'
/    c                   eval      msgdta = LockUser
/    c                   exsr      SNDMSG
/    c                   goto      shoimgExit
/    c                   end

     C     #IV           IFEQ      9                                            Full (9)
/3989C                   MOVE      SDT           SAVSDT
     C                   EXSR      SNDIMG                                        Send 'em.
/3989C                   MOVE      SAVSDT        SDT
     C                   END

     C                   ADD       1             #IV                            Bump and
     C     DUPS          IFEQ      'A'
     C     DUPS          OREQ      'N'
     C     #IV           OCCUR     DSPSDT
     C                   MOVEL     SDT           DSPSDT
     C                   ELSE
     C                   Z-ADD     RRN2          VI(#IV)                         save RRN
     C                   ENDIF
     C                   MOVE      LDXNAM        @LSTNM           10             for sending later

/3765c     shoimgExit    tag
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDIMG        BEGSR
      *          ------------------------------------------------------
      *          Call SPYLNKVU to view queued image(s).
      *          #IV is number of images to view.  IM# is this img's #.
      *          ------------------------------------------------------
     C                   Z-ADD     RRN2          SAVRN2            4 0          Save RRN.

     C                   DO        #IV           IM#               2 0
     C     DUPS          IFEQ      'A'
     C     DUPS          OREQ      'N'
     C     IM#           OCCUR     DSPSDT
     C                   MOVEL     DSPSDT        SDT
     C                   MOVEA     SDT           KV
     C                   EXSR      FMTSF2
     C                   ELSE
     C     VI(IM#)       CHAIN     SFS2                               50
     C                   ENDIF
     C                   MOVE      IM#           IM#ALF            1
     C                   MOVE      #IV           IMG##             2
     C                   MOVEL     IM#ALF        IMG##
     C                   EXSR      CALLVW                                       Viewer
/2256
/2256C     MSGID         IFEQ      'EXIT'
/2256C                   MOVE      *BLANKS       MSGID
/2256C                   LEAVE
/2256C                   END

     C     MSGID         IFEQ      *BLANK                                       If success
     C     IMGDSP        ANDNE     '1'
     C                   MOVE      'HYP2116'     MSGID                           show
     C                   END                                                     progress
      *                                                     else errmsg
     C     MSGID         IFNE      *BLANKS
     C                   EXSR      SNDMSG
     C                   END

     C                   ENDDO

     C                   Z-ADD     0             #IV                            Clear ctr.
      *    UPDATE SUBFILE ONLY IF DUPS NE *ALL
     C     DUPS          IFNE      'A'
     C     DUPS          ANDNE     'N'
     C     SAVRN2        CHAIN     SFS2                               50        Restore ptr.
     C                   SETON                                        11
     C                   UPDATE    SFS2
     C     SAVRN2        CHAIN     SFS2                               50        GET FOR NEXT UPDATE
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUEPRT        BEGSR
      *          ------------------------------------------------------
      *          User has requested printing of an image...
      *             If we have 9 images queued up for printing, send em
      *             Else If this request is for a different doc type
      *                  send any in queue.
      *          Queue this request.
      *          ------------------------------------------------------
     C     #IV           IFEQ      9                                            Full (9)
     C                   EXSR      SNDPRT                                        Send 'em.
     C                   END

     C                   ADD       1             #IV                            Bump and
     C                   Z-ADD     RRN2          VI(#IV)                         save RRN
     C                   MOVE      LDXNAM        @LSTNM           10             for sending
     C                   ENDSR                                                   later.
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SNDPRT        BEGSR
      *          ------------------------------------------------------
      *          Call SPYLNKVU to print queued image(s).
      *          #IV is number of images to print. IM# is this img's #.
      *          ------------------------------------------------------
     C                   Z-ADD     RRN2          SAVRN2            4 0          Save RRN.

     C                   DO        #IV           IM#               2 0
     C     VI(IM#)       CHAIN     SFS2                               50
     C                   MOVE      IM#           IM#ALF            1
     C                   MOVE      #IV           IMG##             2
     C                   MOVEL     IM#ALF        IMG##
      *               _______________________________
      *                Send viewer Print Action code
      *               _______________________________
     C                   MOVE      'P'           VACTIO                         Action Code
     C                   EXSR      CALLVW                                       Viewer
     C                   MOVE      *BLANKS       VACTIO                         reset Action
/2256
/2256C     MSGID         IFEQ      'EXIT'
/2256C                   MOVE      *BLANKS       MSGID
/2256C                   LEAVE
/2256C                   END

     C     MSGID         IFEQ      *BLANK                                       If success
     C                   MOVE      'HYP2116'     MSGID                           show
     C                   END                                                     progress
      *                                                     else errmsg
     C                   EXSR      SNDMSG

     C                   ENDDO

     C                   Z-ADD     0             #IV                            Clear ctr.
     C     SAVRN2        CHAIN     SFS2                               50        Restore ptr.
     C                   SETON                                        11
     C                   UPDATE    SFS2
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRS2S        BEGSR
      *          Clear S2's Subfile.

     C     PRTF          IFNE      'Y'
     C                   MOVEA     '11'          *IN(72)
     C                   WRITE     S2
     C                   MOVEA     '00'          *IN(72)
     C                   CLEAR                   RRN2
     C                   CLEAR                   SFLRC2
     C                   Z-ADD     0             TRRN2
     C                   Z-ADD     0             OPTION
     C                   MOVE      *OFF          *IN11
     C                   ENDIF
     C                   Z-ADD     0             #RHITS            5 0          Total #hits
     C                   Z-ADD     0             #IHITS            5 0           Rpt & Image
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     TGLVEW        BEGSR
      *          F11=Toggle view

     C                   ADD       1             VIEW              3 0
     C     VIEW          IFGT      MAXVEW
     C                   Z-ADD     0             VIEW
     C                   END

     C                   Z-ADD     1             IX                              Ix = 1,76
     C                   DO        VIEW                                               etc.
     C                   ADD       70            IX
     C                   ENDDO

     C                   DO        TRRN2         R#
     C     R#            CHAIN     SFS2                               50

     C     FORMAT        IFLT      '3'                                          Rpt headers
     C                   MOVE      *ON           *IN10                           NonDisplay
     C                   ELSE                                                   Fm 3,4
     C                   MOVE      *OFF          *IN10                           DisplayOptn
     C                   END

     C     FORMAT        IFEQ      '2'                                          Col hdr line
     C     FORMAT        OREQ      '4'                                          Data record
     C                   MOVEA     fRC(IX)       RECORD
     C                   END

     C     OPTION        COMP      0                                  1111      NE, SflChg
     C                   UPDATE    SFS2
     C                   ENDDO

     C                   Z-ADD     1             @RC               3 0          @rc = 1,76
     C                   DO        VIEW                                               etc.
     C                   ADD       70            @RC
     C                   ENDDO

     C                   MOVE      *OFF          *IN10
     C                   MOVE      *OFF          *IN11
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
     C                   MOVEL     @MSGTX        ERRMSG           50
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR

     C                   MOVEL(P)  CL(3)         CMD                            DltOvr All
     C                   CALL      'QCMDEXC'     PLCMDE                 50
      * Viewer
     C     VIEWUP        IFEQ      'Y'                                          Viewer
     C                   MOVEL(P)  'QUIT'        LNKFIL
     C                   CALL      LINKVU        PLVIEW
     C                   END
      * Print
     C     UN210         IFEQ      'Y'
     C                   MOVE      *BLANKS       LDXNAM
     C                   MOVE      'N'           PROMPT
     C                   MOVEL(P)  'CLOSEW'      PRTRTN
     C                   EXSR      MAG210
     C                   MOVE      *BLANK        MAGRUN
     C                   MOVE      *BLANKS       RTNCDE
     C                   END
      * Notes
     C     UN2032        IFEQ      'Y'
     C                   MOVEL(P)  'CLOSEW'      NOTRTN
     C                   CALL      'MAG2032'     PL2032                 50
     C                   CLEAR                   UN2032
     C                   END
      *          Shut down If query check
     C     QRYOPN        IFEQ      '1'
     C                   MOVEL     '*CLOSEW'     QRYOPC                         OpCode
     C                   CALL      'SPYQRY'      PLQRY                  50
     C                   ENDIF
     C     KEY           IFEQ      F3
     C     KEY           OREQ      F12
     C                   MOVE      KEY           RTNCDE
     C                   END
      * Shut down spycshhit
     C     HITOPN        IFEQ      '1'
     C                   MOVEL(P)  'QUIT'        HITOPC
     C                   EXSR      CALHIT
     C                   ENDIF

     C     SPCOPN        IFEQ      '1'
     C                   EXSR      CLSSPC
     C                   ENDIF

/8607c                   eval      opcode = 'QUIT'
/    c                   exsr      replistSR

     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR

      *================================================================

     C     KEYLNK        KLIST
     C                   KFLD                    RRNAM
     C                   KFLD                    RJNAM
     C                   KFLD                    RPNAM
     C                   KFLD                    RUNAM
     C                   KFLD                    RUDAT

     C     KLBIG5        KLIST
     C                   KFLD                    SDTRNA
     C                   KFLD                    SDTJNA
     C                   KFLD                    SDTPNA
     C                   KFLD                    SDTUNA
     C                   KFLD                    SDTUDA

     C     KEYRP2        KLIST
     C                   KFLD                    LRNAM
     C                   KFLD                    LJNAM
     C                   KFLD                    LPNAM
     C                   KFLD                    LUNAM
     C                   KFLD                    LUDAT

     C     KEYNA2        KLIST
     C                   KFLD                    LRNAM
     C                   KFLD                    LJNAM
     C                   KFLD                    LPNAM
     C                   KFLD                    LUNAM
     C                   KFLD                    LUDAT
     C                   KFLD                    LN(IX)

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ACTFIL        BEGSR

     C                   CLEAR                   ATTACH

     C     *INU1         IFEQ      *ON                                          Check job
     C     *INU2         ANDEQ     *OFF                                         Switches
     C     *INU3         ANDEQ     *OFF                                         '10011001'
     C     *INU4         ANDEQ     *ON                                          Actfil
     C     *INU5         ANDEQ     *ON                                          Attach pgm
     C     *INU6         ANDEQ     *OFF                                         Is req
     C     *INU7         ANDEQ     *OFF
     C     *INU8         ANDEQ     *ON
     C                   CALL      'MAG8009'                            50      Rcv act pro
     C                   PARM                    ACTPRO            9 0          Pro nbr.
     C                   PARM      ' '           ACTRTN            1            Return

     C     ACTRTN        IFEQ      ' '
     C     *IN50         ANDEQ     *OFF
     C                   MOVE      '1'           ACTATT            1            Attach ok
     C                   MOVEL     'OPT0302'     @ERCON                         3=attach
     C                   EXSR      RTVMSG
     C                   MOVEL(P)  @MSGTX        ATTACH           20
     C                   ELSE
     C                   MOVE      ' '           ACTATT                         No attach
     C                   END

     C                   ELSE
     C                   MOVE      ' '           ACTATT                         No attach
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ATTACT        BEGSR
      *          Attach link to action file

     C     ACTATT        IFEQ      '1'                                          Is active
     C                   MOVE      LRNAM         ARNAM                          Rmnt filenm
     C                   MOVE      LJNAM         AJNAM                          Rmnt jobnm
     C                   MOVE      LPNAM         APNAM                          Rmnt pgmnm
     C                   MOVE      LUNAM         AUNAM                          Rmnt usrnm
     C                   MOVE      LUDAT         AUDAT                          Rmnt usrdta
     C                   MOVE      OXSPG         ASTR                           Start page
     C                   MOVE      OXEPG         AEND                           End page

      * Format object
     C                   MOVEL(P)  LXSEQ         ACTOBJ
     C                   MOVE      LDXNAM        ACTOBJ
      * Call workvu attach
     C     '*OMNILIN'    CAT(P)    'K'           ACTTYP
     C                   CALL      'MAG8010'                            50
     C                   PARM                    ACTPRO            9 0          Proc nbr.
     C                   PARM                    ACTOBJ           20
     C                   PARM                    ACTTYP           10            Lnk type
     C                   PARM      PATHDS        ACTPTH          100            Path
     C                   PARM      RRDESC        ACTDSC           30            Description
     C                   PARM      ' '           ACTRTN            1            Return
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALPRT        BEGSR
      *          Call MAG210

      * check for exclusive revision control lock
/3765c                   move      oxspg         oxspgn            9 0
/    c                   if          OK <> ChkRCLock(ldxnam:oxspgn:LockUser)
/    c                                  and LockUser <> *blanks
/    c                   eval      msgid = 'ERR1619'
/    c                   eval      msgdta = LockUser
/    c                   exsr      SNDMSG
/    c                   goto      calprtExit
/    c                   end

     C                   MOVEL     LDXNAM        F1A               1            Image
     C     F1A           IFNE      'B'
     C                   MOVE      'R'           OBJTY                          (R)pt
     C                   ELSE
     C                   MOVE      'I'           OBJTY                          (I)mg
     C                   END

      * Check if there is a join for printing
     C     OPTION        IFEQ      2                                            Print
T6765c                   if        checkAuthority(12) <> 0
/    c                   eval      msgid = 'ERR1203'
/    c                   exsr      sndmsg
/    c                   leavesr
/    c                   endif
     C     #PRT          IFGE      2
     C     NUJOIN        IFEQ      'Y'
     C                   MOVE      'Y'           @JOINS
     C                   END
     C                   MOVE      ' '           PRS(25)                        Prot join
     C                   ELSE
     C                   MOVE      'N'           @JOINS
     C                   MOVE      '2'           PRS(25)                        Prot join
     C                   END
     C                   END

      * Check if there is a join for sending
     C     OPTION        IFEQ      13                                           Fax
T6765c                   if        checkAuthority(12) <> 0
/    c                   eval      msgid = 'ERR1203'
/    c                   exsr      sndmsg
/    c                   leavesr
/    c                   endif
     C     #FAX          IFGE      2
     C     NUJOIN        IFEQ      'Y'
     C                   MOVE      'Y'           @JOINS
     C                   END
     C                   MOVE      ' '           PRS(25)                        Prot join

     C                   ELSE
     C                   MOVE      'N'           @JOINS
     C                   MOVE      '2'           PRS(25)                        Prot join
     C                   END
     C                   END

     C                   Z-ADD     OXSPG         @FRMPG
     C     OXEPG         IFNE      0
     C                   MOVE      OXEPG         @TOPG
     C                   MOVE      '1'           PRS(1)                         Nond frm pg
     C                   MOVE      '1'           PRS(2)                         Nond to pg
     C                   ELSE
     C                   MOVE      OXSPG         @TOPG
     C                   MOVE      '1'           PRS(1)                         Prot frm pg
     C                   MOVE      ' '           PRS(2)                         Prot to pg
     C                   END

     C                   MOVE      *BLANKS       @PGTBL
     C     SDTLOC        IFEQ      '4'                                          R/dars optic
     C     SDTLOC        OREQ      '5'                                          R/dars qdls
     C     SDTLOC        OREQ      '6'                                          Imageview op
     C                   MOVEL(P)  OXTRF         @PGTBL
     C                   MOVE      OXTRO         @PGTBL
     C                   END
      * Set Mag210's OpCd
     C                   SELECT
     C     EADTYP        WHENEQ    'I'
     C     PRTRTN        ANDNE     'CLOSEW'
     C                   MOVE      'I'           OPCD                           I)FS: path
     C                   MOVEA(P)  ETXT          @TXT
     C                   MOVEL     ERCVR         @RCVR                          Receiver
     C                   MOVEL     ESUBJ         @SUBJ                          Subject
     C                   MOVE      'Y'           @JOINS                         No Joins
     C                   EXSR      ADDSPC
     C     OPTION        WHENEQ    2
     C                   MOVE      'P'           OPCD                           P)rint
     C     OPTION        WHENEQ    13
     C                   MOVE      'S'           OPCD                           S)end
     C                   ENDSL

      * Move parms
     C                   MOVEL(P)  VL1           SDTRV1
     C                   MOVEL(P)  VL2           SDTRV2
     C                   MOVEL(P)  VL3           SDTRV3
     C                   MOVEL(P)  VL4           SDTRV4
     C                   MOVEL(P)  VL5           SDTRV5
     C                   MOVEL(P)  VL6           SDTRV6
     C                   MOVEL(P)  VL7           SDTRV7
     C                   MOVEL(P)  VL8           SDTRV8
     C                   MOVE      OXSPG         SDTSPG
     C                   MOVE      OXEPG         SDTEPG
     C                   MOVE      OXTRO         SDTRO#                         R/dars & ima
     C                   MOVE      OXTRF         SDTRF#                         R/dars & ima
     C                   MOVE      LXSEQ         SDTSEQ
     C                   MOVE      LDXNAM        SDTNAM
      * Move datastructure
     C                   MOVE      SDT           SDTPRM
     C                   MOVE      'Y'           PROMPT

     C                   EXSR      MAG210

     C                   MOVE      'N'           NUJOIN            1
     C                   MOVEL     '@CPRI'       LCALL             5
     C                   MOVE      'Y'           MAGRUN            1
     C                   MOVE      'Y'           CLOSEW            1
     C                   MOVE      'Y'           UN210             1

/3765c     calprtExit    tag
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     MAG210        BEGSR

/6692c                   If        PRTRTN = 'CLOSEW' and
/    c                             OpCd   = 'M'      and
/    c                             Prompt = 'Y'
/    c                   Eval      Prompt = 'C'
/    c                   EndIf

     C                   CALL      'MAG210'      PL210                  50

     C     *IN50         IFEQ      *ON
     C     PRTRTN        ORNE      *BLANKS
     C     *IN50         IFEQ      *OFF
     C                   MOVEL     PRTRTN        MSGID
     C                   ELSE
     C                   MOVEL     'ERR1089'     MSGID
     C                   END
     C     OPTION        IFEQ      2
     C                   SUB       1             #PRT
     C                   END
     C     OPTION        IFEQ      13
     C                   SUB       1             #FAX
     C                   END
     C                   ELSE
     C                   CLEAR                   MSGID
     C                   END

     C     MSGID         IFNE      *BLANKS
     C                   EXSR      SNDMSG
     C                   MOVE      'N'           @JOINS
     C                   END
     C                   ENDSR
      *    ----------------------------------------------------------
     C     PL210         PLIST
     C                   PARM                    OPCD              1            P/F/M/I
     C                   PARM                    OBJTY             1            (I)mg (R)pt
     C                   PARM      LDXNAM        REPIDX           10            Rept Idx #
     C                   PARM                    PROMPT            1            Prompt Scrn
     C                   PARM                    PRS                            Security Flg
     C                   PARM                    PRTRTN            7            Return Code
     C                   PARM                    @FRMPG            7 0           1 From Page
     C                   PARM                    @TOPG             7 0           2 To   Page
     C                   PARM      0             @FRMCO            3 0           3 From Colu
     C                   PARM      0             @TOCOL            3 0           4 To   Colu
/2852C                   PARM      'N'           @PRTWN            1             5 Print Win
     C                   PARM                    @ENVUS           10             6 Enviro Us
     C                   PARM                    @ENVNA           10             7 Enviro Na
     C                   PARM                    @SBMJB            1             8 Submit jo
     C                   PARM                    @JBDES           10             9 Job Desc
     C                   PARM                    @JBDLB           10            10 Job-D Lib
     C                   PARM                    @RPTNA           10            11 Report Na
     C                   PARM                    @OUTFR           10            12 Out Form
/2852C                   PARM      *BLANKS       @RPTUD           10            13 User data
     C                   PARM                    @PTRID           10            14 Print Id
     C                   PARM                    @OUTQ            10            15 Outq
     C                   PARM                    @OUTQL           10            16 Outq Libr
     C                   PARM                    @PRTF            10            17 Print-F
     C                   PARM                    @PRTLB           10            18 Print-F L
     C                   PARM                    @WTR             10            19 Writer
     C                   PARM                    @COPIE            3 0          20 #Copies
     C                   PARM                    @DJEBF           10            21 Dje Befor
     C                   PARM                    @DJEAF           10            22 Dje After
     C                   PARM                    @BANNR           10            Banner Id
     C                   PARM                    @INSTR           10            24 Instru Id
     C                   PARM                    @JOINS            1            25 Join Splf
     C                   PARM                    @PRTTY           10            Print Type
      *  Outfile Parms (32-34)
     C                   PARM                    @DBFIL           10            File Name
     C                   PARM                    @DBLIB           10            Library
     C                   PARM                    @DBNOT            1            Notes
      *  Fax Parms     (35-56)
     C                   PARM                    @FXNBR           40            Fax Nbr
     C                   PARM                    @FXTO1           45            Fax to 1
     C                   PARM                    @FXTO2           45            Fax to 2
     C                   PARM                    @FXTO3           45            Fax to 3
     C                   PARM                    @FXFR1           45            Fax from 1
     C                   PARM                    @FXFR2           45            Fax from 2
     C                   PARM                    @FXFR3           45            Fax from 3
     C                   PARM                    @FXREF           45            Fax Refer
     C                   PARM                    @FXTX1           52            Fax Text 1
     C                   PARM                    @FXTX2           52            Fax Text 2
     C                   PARM                    @FXTX3           52            Fax Text 3
     C                   PARM                    @FXTX4           52            Fax Text 4
     C                   PARM                    @FXTX5           52            Fax Text 5
     C                   PARM                    @FXCPF           10            Cover PRTF
     C                   PARM                    @FXCPL           10            Cover PRTFLI
     C                   PARM                    @FXFRM           10            Formname
     C                   PARM                    @FXSTY            4            Style
     C                   PARM                    @FXLPI            4            Lpi
     C                   PARM                    @FXCPI            4            Cpi
     C                   PARM                    @FXPTY            2            Priority
     C                   PARM                    @FXSID           50            Send Id
     C                   PARM                    @FXMSG           20            Message to
     C                   PARM                    @FXSAV            1            Save status
      * Parms   :  59-62
     C                   PARM                    @DEVFN           10            9 orig prtf
     C                   PARM                    @DEVFL           10            60orig prtfl
     C                   PARM                    @UPGTB            1            1 use pagetb
     C                   PARM                    @PGTBL           20            2 use pagetb
      * Print duplex: 63-69
     C                   PARM                    @CVRPA            7            3 CovrPgB4/A
     C                   PARM                    @CVRTX                         4 CovrPg tex
     C                   PARM                    @DUPLE            4            5 *yes/*no
     C                   PARM                    @ORIEN           10            6 *land/*por
     C                   PARM                    @PRTYP            6            7 *XI *PVL e
     C                   PARM                    @PRTNO           17            8 PCsrvrNode
     C                   PARM                    @CVRMB           10            9 CvrPgTxt M
      * Paper Size  : 70-72
     C                   PARM                    @PAPSZ           10            70Paper Size
     C                   PARM                    @DRWER            4            1 Drawer
     C                   PARM                    @PGRNG           20            2 Page Range
      * Batch ID    : 73-73
     C                   PARM                    @BCHID           10            3 Batch ID
      * Spylink data: 74-74
     C                   PARM                    SDTPRM
      * Email parms   75-80
     C                   PARM                    @SNDR            60            Email sender
     C                   PARM                    @ADTYP            1            Rcvr address
     C                   PARM                    @RCVR            60            Receiver
     C                   PARM                    @SUBJ            60            Subject
     C                   PARM                    @TXT                           Text 5*60
     C                   PARM                    @FMT             10            Format
/2930C                   PARM                    @CDPAG            5            CODE PAGE
/3393C                   PARM                    @IGBAT            1            IGNORE BADBATCH
/6609C                   PARM                    @INFAC            1            SpoolMail Interface

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRW          BEGSR
      *          Shutdown called pgms

     C     CLOSEW        IFEQ      'Y'
     C     LCALL         IFEQ      '@CPRI'
     C                   MOVEL(P)  'CLOSEW'      PRTRTN
     C                   EXSR      MAG210
     C                   CLEAR                   UN210
     C                   ENDIF
     C     LCALL         IFEQ      '@NOTE'
     C                   MOVEL(P)  'CLOSEW'      NOTRTN
     C                   CALL      'MAG2032'     PL2032                 50
     C                   CLEAR                   UN2032
     C                   ENDIF
     C     LCALL         IFEQ      '$STRCS'
     C                   MOVEL(P)  'QUIT'        CASRTN
     C                   CALL      'MAG8021'     PL8021                 50
     C                   CLEAR                   UN8021
     C                   ENDIF
     C                   MOVE      *BLANKS       CLOSEW
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF4          BEGSR
      *          F4=Prompt
     C                   EXSR      SRCURS
     C     ALWF4         IFEQ      '1'
     C                   EXSR      USRPGM
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF10         BEGSR
      *          F10=Query

     C     LNKQRY        IFNE      'N'                                          SYSDFT allow
      *>>>>
     C     INQRY         TAG
     C                   MOVE      ' '           QUERY             1
     C                   MOVE      '1'           QRYOPN            1
     C                   CLEAR                   QRYOPC

     C                   CALL      'SPYQRY'      PLQRY                  50
     C     PLQRY         PLIST
     C                   PARM      '*OMNILNK'    PRMTYP           10            Obj type
     C                   PARM      AHNAM         PRMOBJ           10            Object
     C                   PARM                    QRYOPC           10            Opcode
     C                   PARM                    AO                             And or
     C                   PARM                    FN                             Fields
     C                   PARM                    TE                             Test
     C                   PARM                    VAF                            Values fmt
     C                   PARM                    QRYTYP            1            Query type
     C                   PARM                    LOOPID           10            Opt OPID
     C                   PARM                    LODRV            15            Opt DRIVE
     C                   PARM                    LOVOL            12            Opt Vol
     C                   PARM                    LODIR            80            Directory
     C                   PARM                    LOFILI           10            Opt FileName
     C                   PARM                    LOSEQ             5 0          Opt SEQ
     C                   PARM      ' '           QRYKEY            1

     C     QRYKEY        IFEQ      F3
     C     QRYKEY        OREQ      F12
     C                   MOVEL     QRYKEY        KEY
     C                   EXSR      QUIT
     C                   ENDIF

     C     QRYKEY        IFNE      F10
     C                   MOVE      '1'           QUERY             1
     C                   CLEAR                   SELTXT
     C     FN(1)         IFNE      *BLANKS
     C                   MOVEL(P)  QRYTXT        SELTXT                         Query on
     C                   ENDIF
      * Show screen query running....
     C                   MOVE      *ON           *IN73                           clear sfl.
     C                   MOVE      *OFF          *IN72
     C                   WRITE     WINDOW
     C                   WRITE     S2HDR
     C                   WRITE     S2MSG
     C                   WRITE     S2
     C                   WRITE     S2QRY                                        Hit list
      * Clear regular filter
     C                   CLEAR                   VA
     C                   EXSR      SETFLT
     C                   EXSR      SRF17
     C     GOTONE        CASEQ     '1'           WORKS2                          Hit list.
     C                   ENDCS

     C                   GOTO      INQRY
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF21         BEGSR
      *          F21=Cmd line
     C                   CALL      'MSYSCMDC'                           50
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF24         BEGSR
      *          F24=More keys

     C                   ADD       1             FKYS#             3 0
     C     FKYS#         IFGT      MAXF24
     C                   Z-ADD     1             FKYS#
     C                   END
     C                   MOVEL(P)  TXT(FKYS#)    FKEYS
     C                   EXSR      SRCURS
     C                   MOVE      *ON           *INKD                          Keep cursor
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF242        BEGSR
      *          More keys
     C                   ADD       1             FKYS2#            3 0
     C     FKYS2#        IFGT      MA2F24
     C                   Z-ADD     1             FKYS2#
     C                   END
     C                   MOVEL(P)  TX2(FKYS2#)   FKEY2
     C                   EXSR      SRCURS
     C                   MOVE      *ON           *INKD                          Keep cursor
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DOOPTN        BEGSR
      *          Process user-entered options

     C                   Z-ADD     0             #PRT              5 0          Clear counts
     C                   Z-ADD     0             #PRTIM            5 0
     C                   Z-ADD     0             #FAX              5 0
     C                   Z-ADD     0             #FAXIM            5 0
     C                   READC     SFS2                                 5050

     C     *IN50         DOWEQ     *OFF                                         Process
     C     OPTION        IFGT      0
     C                   MOVE      *ON           *IN11                           Dspatr(PC)
      *-------
      * Images
      *-------
     C                   SELECT
     C     OPTION        WHENEQ    1                                            Images
     C     LDXNA1        IFEQ      'B'
     C                   EXSR      SHOIMG
     C                   Z-ADD     0             OPTION
     C                   END
      * Count fax, print, and print
     C     OPTION        WHENEQ    2                                            Print
     C     LDXNA1        IFEQ      'B'                                          Image
     C                   ADD       1             #PRTIM
     C                   ELSE
     C                   ADD       1             #PRT
     C                   END
     C     OPTION        WHENEQ    13                                           Print
     C     ALWSND        ANDEQ     '1'
     C     LDXNA1        IFEQ      'B'                                          Image
     C                   ADD       1             #FAXIM
     C                   ELSE
     C                   ADD       1             #FAX
     C                   END
     C                   ENDSL

     C     RRN2          IFGT      SFLRC2
     C                   Z-ADD     RRN2          SFLRC2                         SflRcdNbr
     C                   END

     C                   ELSE
     C                   MOVE      *OFF          *IN11                          NoDspatr(PC)
     C                   END

/6401 *                  This ensures that the subfile record number
/     *                  updated is the correct one.
/    c**                 If        rrn2 = sflrc2
     C                   Update(e) SFS2
/6401c**                 EndIf
     C                   READC     SFS2                                 5050
     C                   ENDDO

     C     #IV           CASGT     0             SNDIMG                         Flush images
     C                   ENDCS
      *--------
      * Reports do all options (not faxing and no image)
      *--------
     C     1             CHAIN     SFS2                               50        Imgs done,
     C                   READC     SFS2                                 5050

     C     *IN50         DOWEQ     *OFF
     C     OPTION        IFGT      0
     C                   SETON                                        11        Dspatr(PC)
     C                   SELECT

     C     OPTION        WHENEQ    1                                            1 display
     C                   EXSR      SHORPT                                       View Report
     C                   CLEAR                   OPTION

     C     OPTION        WHENEQ    2                                            2 Print
     C     LDXNA1        ANDNE     'B'                                          Report
     C                   EXSR      CALPRT
     C                   CLEAR                   OPTION

     C     OPTION        WHENEQ    3                                            Action file
     C     ACTATT        ANDEQ     '1'                                          And active
     C                   EXSR      ATTACT
     C                   CLEAR                   OPTION
/2839C     OPTION        WHENEQ    18                                           Notes
/    C     AUTE(14)      ANDEQ     'N'
/    C                   MOVEL     'ERR1203'     MSGID
/    C                   EXSR      SNDMSG
/    C                   CLEAR                   OPTION
     C     OPTION        WHENEQ    18                                           Notes
     C                   EXSR      @NOTES
     C                   CLEAR                   OPTION
     C     OPTION        WHENEQ    31                                           START CASE
     C                   EXSR      $STRCS
     C                   CLEAR                   OPTION

     C                   ENDSL
     C                   ELSE
     C                   SETOFF                                       11        NoDspatr(pc)
     C                   END

     C                   UPDATE    SFS2
/2256
/2256C     MSGID         IFEQ      'EXIT'
/2256C                   SETON                                        50
/2256C                   MOVE      *BLANKS       MSGID
/2256C                   LEAVE
/2256C                   END
/2256
     C                   READC     SFS2                                 5050
     C                   ENDDO

/2852C                   Z-ADD     #FAX          #FAXRP            9 0
/2852C     #FAX          ADD       #FAXIM        TOTFAX            9 0

      * Fax images (always FIRST)
     C     #FAXIM        IFGT      0
/2852C                   Z-ADD     TOTFAX        #FAX
     C     1             CHAIN     SFS2                               50        Imgs done,
     C                   READC     SFS2                                 5050
     C     *IN50         DOWEQ     *OFF
     C     OPTION        IFGT      0
     C                   SETON                                        11        Dspatr(pc)
     C                   SELECT
     C     OPTION        WHENEQ    13                                           1 Print
     C     LDXNA1        ANDEQ     'B'                                          Images
     C                   EXSR      CALPRT
     C                   CLEAR                   OPTION
     C                   ENDSL
     C                   ELSE
     C                   SETOFF                                       11        NoDspatr(pc)
     C                   END
     C                   UPDATE    SFS2
     C                   READC     SFS2                                 5050
     C                   ENDDO
     C                   END
      * Fax reports (always LAST)
/2852C     #FAXRP        IFGT      0
/2852C                   Z-ADD     TOTFAX        #FAX
     C     1             CHAIN     SFS2                               50        Imgs done,
     C                   READC     SFS2                                 5050
     C     *IN50         DOWEQ     *OFF
     C     OPTION        IFGT      0
     C                   SETON                                        11        Dspatr(pc)
     C                   SELECT
     C     OPTION        WHENEQ    13                                           13 fax
     C     LDXNA1        ANDNE     'B'                                          Reports
     C                   EXSR      CALPRT
     C                   CLEAR                   OPTION
     C                   ENDSL
     C                   ELSE
     C                   SETOFF                                       11        NoDspatr(pc)
     C                   END
     C                   UPDATE    SFS2
     C                   READC     SFS2                                 5050
     C                   ENDDO
     C                   END
      * Print images
     C     #PRTIM        IFGT      0
     C                   Z-ADD     #PRTIM        #PRT
     C     1             CHAIN     SFS2                               50        Imgs done,
     C                   READC     SFS2                                 5050
     C     *IN50         DOWEQ     *OFF
     C     OPTION        IFGT      0
     C                   SETON                                        11        Dspatr(pc)
     C                   SELECT
     C     OPTION        WHENEQ    2                                            1 Print
     C     LDXNA1        ANDEQ     'B'                                          Images
     C                   EXSR      CALPRT
     C                   CLEAR                   OPTION
     C                   ENDSL
     C                   ELSE
     C                   SETOFF                                       11        NoDspatr(pc)
     C                   END
     C                   UPDATE    SFS2
     C                   READC     SFS2                                 5050
     C                   ENDDO
     C                   END

     C     CLOSEW        IFEQ      'Y'                                          Close
     C                   EXSR      CLRW                                         Window stuff
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @NOTES        BEGSR

     C                   MOVEL     LDXNAM        LDXNM1            1            Image
     C     LDXNM1        IFEQ      'B'                                          SpyImage
     C                   OPEN      MIMGDIR
     C     LDXNAM        CHAIN     MIMGDIR                            50        Image Dir
     C                   CLOSE     MIMGDIR
     C                   Z-ADD     OXSPG         PAGE#
     C                   Z-ADD     1             #FRSTP
     C                   Z-ADD     *HIVAL        #LASTP
/813 C                   Z-ADD     1             ACTPG#                         Actual Page#
     C                   MOVEL     IDFLD         @FLDR
     C                   MOVEL     IDFLIB        @FLDLB
     C                   MOVEL     IDDOCT        @FILNA
     C                   MOVEL     IDBNUM        @JOBNA
     C                   CLEAR                   @USRNA
     C                   CLEAR                   @JOBNU
     C                   CLEAR                   DSF#
/6708C                   clear                   @datfo
     C                   MOVE      '0'           WORKNT            1
     C                   ELSE
     C                   OPEN      MRPTDIR7
     C     LDXNAM        CHAIN     MRPTDIR7                           50        Report
     C                   CLOSE     MRPTDIR7
     C                   MOVEL     FLDR          @FLDR
     C                   MOVEL     FLDRLB        @FLDLB
     C                   MOVEL     FILNAM        @FILNA
     C                   MOVEL     JOBNAM        @JOBNA
     C                   MOVEL     USRNAM        @USRNA
     C                   MOVEL     JOBNUM        @JOBNU
/6708c                   move      datfop        @datfo
     C     SDTLOC        IFEQ      '4'                                          R/DARS Optical
     C     SDTLOC        OREQ      '5'                                          R/DARS QDLS
     C     SDTLOC        OREQ      '6'                                          IMAGEVIEW OPTICAL
     C                   Z-ADD     OXTRO         PAGE#
     C                   Z-ADD     1             #FRSTP
     C                   Z-ADD     *HIVAL        #LASTP
/813 C                   Z-ADD     1             ACTPG#                         Actual Page#
     C                   ELSE
     C                   Z-ADD     OXSPG         PAGE#
     C                   Z-ADD     OXSPG         #FRSTP
     C                   Z-ADD     OXEPG         #LASTP
/813 C                   Z-ADD     PAGE#         ACTPG#                         Actual Page#
     C                   END
     C                   Z-ADD     FILNUM        @FILNU
     C                   MOVE      '1'           WORKNT            1
     C                   END

     C                   CLEAR                   NOTRTN
     C                   CALL      'MAG2032'     PL2032                 50

     C     PL2032        PLIST
     C                   PARM                    WQUSRN           10
     C                   PARM                    DTALIB           10
     C                   PARM                    @FLDR            10
     C                   PARM                    @FLDLB           10
     C                   PARM                    @FILNA           10
     C                   PARM                    @JOBNA           10
     C                   PARM                    @USRNA           10
     C                   PARM                    @JOBNU            6
/6708C                   parm                    @datfo            7            spooled file opened date
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
     C     $STRCS        BEGSR
      * START A CASE

     C                   MOVEL(P)  VL1           SDTRV1
     C                   MOVEL(P)  VL2           SDTRV2
     C                   MOVEL(P)  VL3           SDTRV3
     C                   MOVEL(P)  VL4           SDTRV4
     C                   MOVEL(P)  VL5           SDTRV5
     C                   MOVEL(P)  VL6           SDTRV6
     C                   MOVEL(P)  VL7           SDTRV7
     C                   MOVEL(P)  VL8           SDTRV8
     C                   MOVE      OXSPG         SDTSPG
     C                   MOVE      OXEPG         SDTEPG
     C                   MOVE      OXTRO         SDTRO#                         R/dars & ima
     C                   MOVE      OXTRF         SDTRF#                         R/dars & ima
     C                   MOVE      LXSEQ         SDTSEQ
     C                   MOVE      LDXNAM        SDTNAM
      * Move datastructure
     C                   MOVE      SDT           SDTPRM

      * PROMPT TO START A CASE
     C                   CLEAR                   CASRTN
     C                   CALL      'MAG8021'     PL8021                 50
     C     PL8021        PLIST
     C*3865                PARM           RTYPID           RMaint RType
/3865C                   PARM                    HRPTYP                         RMaint RType
     C                   PARM                    SDTPRM                         DATA
     C                   PARM                    CASRTN            7            Return Code

     C                   MOVE      'Y'           UN8021            1
     C                   MOVEL     '$STRCS'      LCALL
     C                   MOVE      'Y'           CLOSEW

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETFLT        BEGSR
      *          Set the filter for spycshhit

     C                   CLEAR                   HITFLT                         Reset flt
     C                   CLEAR                   FLTSEQ
     C                   CLEAR                   FLTVER
     C                   CLEAR                   FLTTYP
      * Interactive
     C     JOBTYP        IFEQ      '1'
     C                   CLEAR                   SEL
     C                   CLEAR                   GOTONE
     C                   DO        TRRN          R#                4 0          Load the VA
     C     R#            CHAIN     SFS1                               50        array (srch
     C     SELX          IFEQ      'X'                                          args) w 7
     C     GOTONE        IFNE      '1'
     C                   MOVE      RRNAM         HRNAM
     C                   MOVE      RJNAM         HJNAM
     C                   MOVE      RUNAM         HUNAM
     C                   MOVE      RUDAT         HUDAT
     C                   MOVE      RPNAM         HPNAM
     C                   ENDIF
     C                   MOVE      '1'           SEL(R#)
     C                   MOVE      '1'           GOTONE            1
     C                   ENDIF
     C                   ENDDO
      * Batch
     C                   ELSE
     C                   EXSR      LODS1S
     C                   ENDIF
      * Move filter values
     C     QUERY         IFEQ      '1'
     C                   CLEAR                   VA
     C                   CLEAR                   HV
     C                   CLEAR                   FLTFRM
     C                   CLEAR                   FLTTO
     C                   ELSE
     C                   MOVEA     VA            HV
     C                   MOVE      CRTFRM        FLTFRM
     C                   MOVE      CRTTO         FLTTO
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CALHIT        BEGSR
      *          Call SPYCSHHIT
     C                   MOVE      '1'           HITOPN            1
     C                   CALL      SPSHIT        PLSHIT                 50      'SPYCSHHIT'
     C     PLSHIT        PLIST
     C                   PARM      'INTER'       HITHDL           10            Windo handl
     C                   PARM      AHNAM         HITNAM           10            Omni name
     C                   PARM                    HITLIB           10            @File libr
     C                   PARM                    HITB5            50            RLnkdef key
     C                   PARM                    HITOPC            6            Opcode
     C                   PARM                    HITFLT                         Filter data
     C                   PARM                    HITSDT                         Return recs
     C                   PARM                    HITRTN            2            Return code
     C                   PARM                    AO                             And/or
     C                   PARM                    FN                             Fields
     C                   PARM                    TE                             Test
     C                   PARM                    VAF                            Values
     C                   PARM                    QRYTYP            1            Qrytyp
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PUTSFL        BEGSR
      *          Write the SDTLIN occurence of HITSDT in subfile

     C                   CLEAR                   OPTION
     C                   MOVE      ' '           PARHDR            1
     C     SDTLIN        OCCUR     HITSDT
     C                   MOVE      HITSDT        SDT
      * Write header if docclass has changed
     C     SDTTYP        IFEQ      '0'                                          Valid record
     C     SDTTYP        OREQ      '1'
     C     SDTTYP        OREQ      '5'                                          No rcd found

     C     SDTBI5        IFNE      LSTBI5
/3865C                   CLEAR                   HRPTYP

     C     KLBIG5        CHAIN     RMAINT1                            50
/3865
/3865C     *IN50         IFEQ      '0'
/3865C                   MOVE      RTYPID        HRPTYP
/3865C                   ENDIF
/3865
     C     KLBIG5        CHAIN     RLNKDEF                            50
     C                   EXSR      FMTTIT

     C     DIRECT        IFEQ      'FORW'
     C     DIRECT        OREQ      'BACK'
     C     TRRN2         ANDGT     5
     C     TRRN2         ANDLT     TOTSFL
     C                   EXSR      WRTHD2
     C                   ENDIF
      *   This would cause a partial header
     C     DIRECT        IFEQ      'BACK'
     C     TRRN2         ANDLE     5
     C     TRRN2         ANDGT     1
     C     TRRN2         ANDLT     TOTSFL
     C                   MOVE      '1'           PARHDR            1
     C                   GOTO      PUTEND
     C                   ENDIF

     C                   MOVE      SDTBI5        LSTBI5
     C     *LIKE         DEFINE    SDTBI5        LSTBI5
     C                   ENDIF
     C                   ENDIF

     C     DIRECT        IFEQ      'BACK'
     C     TRRN2         ANDEQ     3
     C                   EXSR      WRTHD2
     C                   ENDIF

     C                   SELECT
      *----------------------------------------------------------------
     C     SDTTYP        WHENEQ    '5'                                          No rcd found
     C                   MOVEL(P)  X'20'         FULLRC                          Found'
     C                   MOVEA     SDT           fRC(2)
     C                   MOVEA     SDT           KV
     C                   MOVEA     fRC           RECORD
     C                   MOVE      $NORCD        FORMAT                         db Data rec
     C                   MOVE      *ON           *IN10                          NonDsp,Prot

     C     DIRECT        IFEQ      'FORW'
     C                   EXSR      WRTS2F
     C                   ELSE
     C                   EXSR      WRTS2B
     C                   ENDIF

     C                   MOVE      *OFF          *IN10
      *----------------------------------------------------------------
     C     SDTTYP        WHENEQ    '0'                                          Valid record
     C     SDTTYP        OREQ      '1'
     C                   MOVE      '1'           ENTFND            1
     C                   MOVEA     SDT           KV
     C                   EXSR      FMTSF2                                       Fmt record

     C     LDXNA1        IFNE      'B'
     C                   ADD       1             #RHITS                         Report
     C                   ELSE
     C                   ADD       1             #IHITS                         Image
     C                   END

     C                   ADD       1             #FOUND            9 0
     C                   MOVE      $DATA         FORMAT                         db Data rec

     C     DIRECT        IFEQ      'FORW'
     C                   EXSR      WRTS2F
     C                   ELSE
     C                   EXSR      WRTS2B
     C                   ENDIF

     C                   MOVE      '1'           ENTFND                         Entry found
      * Printing
     C     PRTF          IFEQ      'Y'
     C                   EXSR      PRTHIT
     C                   END
      * Displaying imgs, dups=ALL
     C     DUPS          IFEQ      'A'
     C     LDXNA1        IFEQ      'B'
     C                   EXSR      SHOIMG
     C                   ELSE
     C                   EXSR      SHORPT
     C                   END
     C                   END

     C     #ONPAG        IFGT      TOTSFL                                       Subfile full
     C     QUERY         ANDEQ     '1'
     C                   EXSR      CLRSTS                                       CLEAR STATUS
     C                   ENDIF
     C                   ENDSL

     C     PUTEND        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ROLFWD        BEGSR
      *          Roll forward

      * Get right column for view
     C                   Z-ADD     1             @RC               3 0          @rc = 1,76
     C                   DO        VIEW                                               etc.
     C                   ADD       70            @RC
     C                   ENDDO
     C                   Z-ADD     TRRN2         TRRNSV            5 0

     C                   CLEAR                   LSTBI5                         Last big5 ke
     C                   Z-ADD     0             #ONPAG            3 0
      * Roll forward
     C                   DO        *HIVAL
     C     FSTREQ        IFEQ      '1'
     C                   MOVEL(P)  'SELCR'       HITOPC
     C                   ELSE
     C                   MOVEL(P)  'RDGT'        HITOPC
     C                   ENDIF
      * Get hitlist
     C                   EXSR      CALHIT
     C                   CLEAR                   FSTREQ
      * Mark as forward
     C                   MOVEL     'FORW'        DIRECT            4

      * * * *    HITRTN    IFEQ '20'                       Warning
     C     HITRTN        IFEQ      '30'                                         Error
     C                   LEAVE
     C                   ENDIF

     C                   DO        10            SDTLIN            5 0
     C                   EXSR      PUTSFL
/2256
/2256C     MSGID         IFEQ      'EXIT'
/2256C                   MOVE      *BLANKS       MSGID
/2256C                   MOVE      '20'          HITRTN                         Warning
/2256C                   LEAVE
/2256C                   END
/2256
     C                   ENDDO

     C     #ONPAG        IFGT      TOTSFL                                       Subfile full
     C                   LEAVE
     C                   ENDIF

     C     HITRTN        IFEQ      '20'                                         Warning
     C                   LEAVE
     C                   END
     C                   ENDDO

      * Empty buffer if dups='A'
     C     DUPS          IFEQ      'A'
     C     #IV           CASGT     0             SNDIMG                         Flush images
     C                   ENDCS
     C                   ENDIF

     C     #ONPAG        COMP      TOTSFL                             98         Gt
     C     TRRNSV        ADD       3             SFLRC2
     C     SFLRC2        IFGT      TRRN2                                        WILL BOMB
     C                   Z-ADD     TRRN2         SFLRC2
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ROLBCK        BEGSR
      *          Roll forward
      * Get right column for view
     C                   Z-ADD     1             @RC               3 0          @rc = 1,76
     C                   DO        VIEW                                               etc.
     C                   ADD       70            @RC
     C                   ENDDO

     C                   EXSR      CLRS2S                                       Clear
     C                   CLEAR                   LSTBI5                         LastBig5 key
     C                   Z-ADD     0             #ONPAG            3 0
      * Mark as backwards
     C                   MOVEL     'BACK'        DIRECT            4
     C     TOTSFL        ADD       1             TRRN2
      * Roll forward
     C                   DO        *HIVAL
     C                   MOVEL(P)  'RDLT'        HITOPC

     C                   EXSR      CALHIT                                       Get hitlist
     C                   CLEAR                   FSTREQ

/testc                   if        hitrtn = '20' and hitsdt = ' ' or
/testc                             hitrtn = '21' or hitrtn = '30'
     C                   LEAVE
     C                   ENDIF

     C                   Z-ADD     10            SDTLIN            5 0
     C                   DO        10
     C                   EXSR      PUTSFL
     C     PARHDR        CABEQ     '1'           ENDBCK
     C                   SUB       1             SDTLIN
     C                   ENDDO

     C     #ONPAG        IFGT      TOTSFL                                       Subfile full
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

     C     #ONPAG        COMP      TOTSFL                             96         Gt
     C                   Z-ADD     0             SFLRC2
     C                   Z-ADD     TOTSFL        TRRN2

/testc                   if        hitrtn = '21' or hitrtn = '20' and
/testc                             hitsdt = ' '
     C                   EXSR      SRF17
     C                   ENDIF
      *>>>>
     C     ENDBCK        TAG
      * If partial header was caused, move subfile up
     C     PARHDR        IFEQ      '1'
     C                   EXSR      SRF5
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRNEXT        BEGSR
      *          Fill next page subfile

     C                   MOVE      HITFLT        SAVFLT
      *   Try to find last valid record in subfile
      * Format key for setgt
     C     TRRN2         CHAIN     SFS2                               50
     C     *IN50         IFEQ      *OFF
     C                   SETON                                        11
/2216C                   MOVE      FMIN10        *IN10                          NodisplyProt
     C                   UPDATE    SFS2
     C                   END
     C                   MOVEL     VL1           HV(1)
     C                   MOVEL     VL2           HV(2)
     C                   MOVEL     VL3           HV(3)
     C                   MOVEL     VL4           HV(4)
     C                   MOVEL     VL5           HV(5)
     C                   MOVEL     VL6           HV(6)
     C                   MOVEL     VL7           HV(7)
     C                   MOVEL     VL8           FLTFRM
     C                   MOVEL     VL8           FLTTO
     C                   MOVEL     LDXNAM        FLTVER
     C                   MOVEL     LXSEQ         FLTSEQ
     C                   MOVEL     SDTBI5        HITB5
     C                   MOVEL(P)  'SETGT'       HITOPC

     C     FORMAT        IFEQ      $NORCD                                       '3'=
     C                   MOVE      *HIVAL        HV
     C                   MOVE      99999999      FLTFRM
     C                   MOVE      00000000      FLTTO
     C                   MOVE      *HIVAL        FLTVER
     C                   Z-ADD     999999999     FLTSEQ
     C                   ENDIF

     C     FORMAT        IFEQ      $TITLE                                       '1'=Title
     C     FORMAT        OREQ      $COLHD                                       '2'=Col hdr
     C                   MOVE      *BLANKS       HV
     C                   MOVE      00000000      FLTFRM
     C                   MOVE      99999999      FLTTO
     C                   MOVE      *BLANKS       FLTVER
     C                   Z-ADD     0             FLTSEQ
     C                   MOVEL(P)  'SETLL'       HITOPC
     C                   ENDIF

/3865C                   CLEAR                   HRPTYP
/3865
     C     KLBIG5        CHAIN     RMAINT1                            50
/3865
/3865C     *IN50         IFEQ      '0'
/3865C                   MOVE      RTYPID        HRPTYP
/3865C                   ENDIF
/3865
     C                   MOVE      RTYPID        FLTTYP
      * Setgt/setll
     c***                EXSR      CALHIT
      * Next page
     C                   MOVE      SAVFLT        HITFLT
     C                   EXSR      ROLFWD
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRPREV        BEGSR
      *          Previous subfile

     C                   MOVE      HITFLT        SAVFLT
      * Find first valid record in subfile to format the key for setll

     C     3             CHAIN     SFS2                               50
     C                   MOVEL     VL1           HV(1)
     C                   MOVEL     VL2           HV(2)
     C                   MOVEL     VL3           HV(3)
     C                   MOVEL     VL4           HV(4)
     C                   MOVEL     VL5           HV(5)
     C                   MOVEL     VL6           HV(6)
     C                   MOVEL     VL7           HV(7)
     C                   MOVEL     VL8           FLTFRM
     C                   MOVEL     VL8           FLTTO
     C                   MOVEL     LDXNAM        FLTVER
     C                   MOVEL     LXSEQ         FLTSEQ
     C                   MOVEL     SDTBI5        HITB5

     C     FORMAT        IFEQ      $NORCD
     C                   MOVE      *BLANKS       FLTVER
     C                   Z-ADD     0             FLTSEQ
     C                   ENDIF

     C     FORMAT        IFEQ      $TITLE
     C     FORMAT        OREQ      $COLHD
     C                   MOVE      *HIVAL        FLTVER
     C                   Z-ADD     999999999     FLTSEQ
     C                   ENDIF
     C     KLBIG5        CHAIN     RMAINT1                            50
     C                   MOVE      RTYPID        FLTTYP

      * Setll
     C                   MOVEL(P)  'SETLL'       HITOPC
     C                   EXSR      CALHIT
      * Next page
     C                   MOVE      SAVFLT        HITFLT
     C                   EXSR      ROLBCK
     C                   SETON                                        98
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF5          BEGSR
      *          F5=Refresh subfile
      *          This subr is also used to fix parital headers

     C                   MOVE      HITFLT        SAVFLT
      * Find first valid record in subfile to format the key for setll

     C     PARHDR        IFEQ      '1'
     C                   Z-ADD     TRRN2         IX
     C                   CLEAR                   PARHDR
     C                   ELSE
     C     SFLZ2         ADD       2             IX
     C                   ENDIF

     C     IX            CHAIN     SFS2                               50
     C                   MOVEL     VL1           HV(1)
     C                   MOVEL     VL2           HV(2)
     C                   MOVEL     VL3           HV(3)
     C                   MOVEL     VL4           HV(4)
     C                   MOVEL     VL5           HV(5)
     C                   MOVEL     VL6           HV(6)
     C                   MOVEL     VL7           HV(7)
     C                   MOVEL     VL8           FLTFRM
     C                   MOVEL     VL8           FLTTO
     C                   MOVEL     LDXNAM        FLTVER
     C                   MOVEL     LXSEQ         FLTSEQ
     C                   MOVEL     SDTBI5        HITB5

     C     FORMAT        IFEQ      $NORCD
     C                   MOVE      *BLANKS       FLTVER
     C                   Z-ADD     0             FLTSEQ
     C                   ENDIF

     C     FORMAT        IFEQ      $TITLE
     C     FORMAT        OREQ      $COLHD
     C                   MOVE      *HIVAL        FLTVER
     C                   Z-ADD     999999999     FLTSEQ
     C                   ENDIF
     C     KLBIG5        CHAIN     RMAINT1                            50
     C                   MOVE      RTYPID        FLTTYP

     C                   EXSR      CLRS2S
      * Setll
     C                   MOVEL(P)  'SETLL'       HITOPC
     C                   EXSR      CALHIT
      * Next page
     C                   MOVE      SAVFLT        HITFLT
     C                   EXSR      ROLFWD
     C                   SETON                                        96
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF18         BEGSR
      *          F18=Jump to the bottom

     C                   MOVEL(P)  'CLEAR'       HITOPC
     C                   EXSR      CALHIT
      * Get hitlist
     C                   MOVEL(P)  'SETEN'       HITOPC
     C                   EXSR      CALHIT
      * Roll
     C                   EXSR      ROLBCK
     C                   SETOFF                                       98
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF17         BEGSR
      *          F17=Jump to the top

      * Clear
     C                   MOVEL(P)  'CLEAR'       HITOPC
     C                   EXSR      CALHIT
     C                   EXSR      CLRS2S
      * Roll forward
     C                   MOVE      '1'           FSTREQ            1            First reques
     C                   EXSR      ROLFWD
     C                   SETOFF                                       96
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF19         BEGSR
      *          F19=Find prev report type

     C                   CLEAR                   NXTRPT
     C     TRRN2         IFNE      0
     C     1             CHAIN     SFS2                               50
     C                   CLEAR                   FNDIT

     C                   DO        TRRN          R#
     C     R#            CHAIN     SFS1                               50
     C     SDTRNA        IFEQ      RRNAM
     C     SDTJNA        ANDEQ     RJNAM
     C     SDTUNA        ANDEQ     RUNAM
     C     SDTUDA        ANDEQ     RUDAT
     C     SDTPNA        ANDEQ     RPNAM
     C                   MOVE      '1'           FNDIT             1
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

     C     FNDIT         IFEQ      '1'
     C     R#            ANDGT     1

     C     SEL(R#)       DOUEQ     '1'
     C                   SUB       1             R#
     C                   Z-ADD     R#            NXTRPT
     C     R#            IFEQ      0
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF

     C     NXTRPT        IFNE      0
     C                   EXSR      POSRPT
     C     TRRN2         IFEQ      0
     C                   EXSR      SRF17
     C                   MOVEL     'HYP0006'     MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF

     C                   ELSE
     C                   EXSR      SRF17
     C                   MOVEL     'HYP0006'     MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF20         BEGSR
      *          F20=Find next report type

     C                   CLEAR                   NXTRPT
     C     TRRN2         IFNE      0
     C     1             CHAIN     SFS2                               50
     C                   CLEAR                   FNDIT

     C                   DO        TRRN          R#
     C     R#            CHAIN     SFS1                               50
     C     SDTRNA        IFEQ      RRNAM
     C     SDTJNA        ANDEQ     RJNAM
     C     SDTUNA        ANDEQ     RUNAM
     C     SDTUDA        ANDEQ     RUDAT
     C     SDTPNA        ANDEQ     RPNAM
     C                   MOVE      '1'           FNDIT             1
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

     C     FNDIT         IFEQ      '1'
     C     R#            ANDLT     TRRN
     C                   ADD       1             R#
     C     '1'           LOOKUP    SEL(R#)                                50     Eq
     C     *IN50         IFEQ      *ON
     C                   Z-ADD     R#            NXTRPT            5 0          Next rpt num
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     NXTRPT        IFNE      0
     C                   EXSR      POSRPT
     C     TRRN2         IFEQ      0
     C                   EXSR      SRF18
     C                   MOVEL     'HYP0005'     MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF

     C                   ELSE
     C                   EXSR      SRF18
     C                   MOVEL     'HYP0005'     MSGID
     C                   EXSR      SNDMSG
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     DUPSNO        BEGSR
      *          Call SPYLNKVU with dups = *NO

     C     TRRN          IFNE      0
     C                   DO        TRRN          R#
     C     R#            CHAIN     SFS1                               50
     C     SEL(R#)       IFEQ      '1'
      * Posn to report type
     C                   Z-ADD     R#            NXTRPT            5 0          Next rpt num
     C                   EXSR      POSRPT
      * Get first hits
     C                   MOVEL(P)  'SELCR'       HITOPC
     C                   EXSR      CALHIT                                       Get hitlist
      * Third line is always first data line (1st two are headers)
     C     3             OCCUR     HITSDT
     C                   MOVE      HITSDT        SDT
      * Format and display valid data record
     C     SDTTYP        IFEQ      '1'                                          Valid record
     C     SDTTYP        OREQ      '0'
      * GET HEADER/TITLE
     C     KLBIG5        CHAIN     RMAINT1                            50
     C     KLBIG5        CHAIN     RLNKDEF                            50
     C                   EXSR      FMTTIT
      * Format index for subfile
     C                   MOVE      '1'           ENTFND            1            Entry found
     C                   MOVEA     SDT           KV
     C                   EXSR      FMTSF2                                       Fmt record
      * Call SPYLNKVU to display
     C     LDXNA1        IFEQ      'B'
     C                   EXSR      SHOIMG
     C                   ELSE
     C                   EXSR      SHORPT                                       View Report
     C                   ENDIF
/2256
/2256C     MSGID         IFEQ      'EXIT'
/2256C                   MOVE      *BLANKS       MSGID
/2256C                   LEAVE
/2256C                   END
/2256
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      * Flush images
     C     #IV           CASGT     0             SNDIMG
     C                   ENDCS
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     POSRPT        BEGSR
      *          Position to report type

     C                   MOVE      HITFLT        SAVFLT
      * Set the key to the next docclass
     C                   CLEAR                   HV
     C                   CLEAR                   FLTFRM
     C                   CLEAR                   FLTTO
     C                   CLEAR                   FLTVER
     C                   CLEAR                   FLTSEQ
     C     NXTRPT        CHAIN     SFS1                               50
     C                   MOVEL     RRNAM         HRNAM
     C                   MOVEL     RJNAM         HJNAM
     C                   MOVEL     RPNAM         HPNAM
     C                   MOVEL     RUNAM         HUNAM
     C                   MOVEL     RUDAT         HUDAT
     C                   MOVE      *BLANKS       FLTVER
     C                   Z-ADD     0             FLTSEQ
     C     KLBIG5        CHAIN     RMAINT1                            50
     C                   MOVE      RTYPID        FLTTYP
      * Clear
     C                   EXSR      CLRS2S
      * Setll
     C                   MOVEL(P)  'SETLL'       HITOPC
     C                   EXSR      CALHIT
      * Next page
     C                   MOVE      SAVFLT        HITFLT
     C     DUPS          IFNE      'N'
     C                   EXSR      ROLFWD
     C     NXTRPT        COMP      1                                  96         GT
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PRTHIT        BEGSR
      *          Print/Mail/IFS a hit

     C                   MOVEL     LDXNAM        F1A               1            Image
     C     F1A           IFNE      'B'
     C                   MOVE      'R'           OBJTY                          (I)mg (R)pt
     C                   ELSE
     C                   MOVE      'I'           OBJTY                          (I)mg (R)pt
     C                   END

     C                   Z-ADD     OXSPG         @FRMPG
     C                   MOVE      OXEPG         @TOPG

     C                   MOVE      *BLANKS       @PGTBL
     C     SDTLOC        IFEQ      '4'                                          R/dars optic
     C     SDTLOC        OREQ      '5'                                          R/dars qdls
     C     SDTLOC        OREQ      '6'                                          Imageview op
     C                   MOVEL(P)  OXTRF         @PGTBL
     C                   MOVE      OXTRO         @PGTBL
     C                   END
      * Set Mag210's OpCd
     C                   SELECT
     C     EADTYP        WHENEQ    'I'
     C                   MOVE      'I'           OPCD                           (I)FS: path
     C                   MOVEA(P)  ETXT          @TXT
     C                   MOVE      'Y'           @JOINS                         No Joins
     C                   MOVEL     ERCVR         @RCVR                          Receiver
     C                   MOVEL     ESUBJ         @SUBJ                          Subject
     C                   EXSR      ADDSPC
     C     EMAIL         WHENNE    'Y'
     C                   MOVE      'P'           OPCD                           (P)rt
     C                   MOVE      'N'           @JOINS
     C                   OTHER
     C                   MOVE      'M'           OPCD                           (M)ail
     C                   MOVE      EJOIN         @JOINS
     C                   MOVEL     ESNDR         @SNDR                          Email sender
     C                   MOVEL     EADTYP        @ADTYP                         Rcvr address
     C                   MOVEL     ERCVR         @RCVR                          Receiver
     C                   MOVEL     ESUBJ         @SUBJ                          Subject
     C                   MOVEA     ETXT          @TXT                           Text 5*60
     C                   MOVEL     EFMT          @FMT                           Format
     C                   ENDSL
      * Move parms
     C                   MOVEL(P)  VL1           SDTRV1
     C                   MOVEL(P)  VL2           SDTRV2
     C                   MOVEL(P)  VL3           SDTRV3
     C                   MOVEL(P)  VL4           SDTRV4
     C                   MOVEL(P)  VL5           SDTRV5
     C                   MOVEL(P)  VL6           SDTRV6
     C                   MOVEL(P)  VL7           SDTRV7
     C                   MOVEL(P)  VL8           SDTRV8
     C                   MOVE      OXSPG         SDTSPG
     C                   MOVE      OXEPG         SDTEPG
     C                   MOVE      OXTRO         SDTRO#                         R/dars & ima
     C                   MOVE      OXTRF         SDTRF#
     C                   MOVE      LXSEQ         SDTSEQ
     C                   MOVE      LDXNAM        SDTNAM
      * Move datastructure
     C                   MOVE      SDT           SDTPRM

     C                   MOVE      'N'           PROMPT
     C                   MOVEL     PRINTR        @PTRID                         Printer Id
     C                   MOVEL     POUTQ         @OUTQ                          Outq
     C                   MOVEL     POUTL         @OUTQL                         Outq Libr
     C                   MOVEL     SBMJOB        @SBMJB                         submit
     C                   MOVEL     JBDESC        @JBDES                         job desc
     C                   MOVEL     JBDLIB        @JBDLB                         jobd lib
      * Call Mag210
     C                   CALL      'MAG210'      PL210                  50
     C                   MOVE      'Y'           UN210             1
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETAPI        BEGSR
      *          Set API flags (API RPTSEL EMAIL PRTF) Also DUPS.

     C                   MOVE      'N'           EMAIL             1
     C                   MOVE      ' '           API               1
      * Wrkhyplnk
     C     RTNCDE        IFNE      '*API'
     C                   MOVE      'Y'           RPTSEL            1
      * API caller
     C                   ELSE
     C                   MOVEL(P)  'F'           RTNCDE
     C                   MOVE      'A'           API
     C                   MOVE      PRMSEL        RPTSEL
      *          Note: Wrkhyplnk passes only 20 parms
     C     PRTF          IFEQ      'M'
     C     WQPRM         ANDGT     21
     C                   MOVE      'Y'           EMAIL
     C                   MOVE      'Y'           PRTF
     C                   ENDIF
     C                   END

     C     WQPRM         IFGE      29
     C                   MOVE      EDUPS         DUPS              1
     C                   ELSE
     C                   MOVE      'Y'           DUPS
     C                   ENDIF

/2930C     WQPRM         IFGE      30
/    C                   MOVEL     ECDPAG        @CDPAG
/    C                   ELSE
/    C                   MOVE      *BLANKS       @CDPAG
/    C                   END

/3393C     WQPRM         IFGE      31
/    C                   MOVEL     IGNBAT        @IGBAT
/    C                   ELSE
/    C                   MOVE      'N'           @IGBAT
/    C                   END

/6609C     WQPRM         IFGE      32
/    C                   MOVE      INTFAC        @INFAC
/    C                   ELSE
/    C                   MOVE      '*'           @INFAC
/    C                   END

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF23         BEGSR
      *          F23=More Options

     C                   EXSR      SRCURS

     C                   ADD       1             OT#               3 0
     C     OT#           IFGT      MAXF23
     C                   Z-ADD     1             OT#
     C                   ENDIF

     C                   MOVEL     OT(OT#)       TITLE1
     C                   MOVE      F4            KEY
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CLRSTS        BEGSR
      *          Clear status message

     C                   CALL      'QMHSNDPM'                           50
     C                   PARM      'DIR0075'     STSID             7
     C                   PARM      PSCON         STSF             20
     C                   PARM                    STSDTA          100
     C                   PARM      100           STSLE#
     C                   PARM      '*STATUS'     STSTYP           10
     C                   PARM      '*EXT'        STSQ             10
     C                   PARM      0             STSST#
     C                   PARM      *BLANKS       STSKEY            4
     C                   PARM                    ERRCD
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     INISPC        BEGSR
      *  Initialize USRSPC that contains the list of documents and the
      *  spylink description for later output to a list of docs exported
      *  This will only be used, if called from EXPOBJSPY.

     C                   MOVEL     AHNAM         SPCOBJ
     C                   MOVEL     IVAL1         SPV(1)
     C                   MOVEL     IVAL2         SPV(2)
     C                   MOVEL     IVAL3         SPV(3)
     C                   MOVEL     IVAL4         SPV(4)
     C                   MOVEL     IVAL5         SPV(5)
     C                   MOVEL     IVAL6         SPV(6)
     C                   MOVEL     IVAL7         SPV(7)
     C                   MOVEL     IVAL8         SPCFRM
     C                   MOVEL     IVAL9         SPCTO
     C                   MOVEA     ETXT          SPCPTH

     C                   MOVEL(P)  'INIT'        SPCOPC
     C                   CALL      SPYSPC        PLSPC                  50

     C                   MOVE      *ON           SPCOPN            1

     C     PLSPC         PLIST
     C                   PARM                    SPCOPC           10
     C                   PARM                    SPCOBJ           10
     C                   PARM      OMNLNK        SPCTYP           10
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
/3393C                   PARM                    @IGBAT            1            IGNORE BADBATCH

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     ADDSPC        BEGSR

      *  Add a new document to USRSPC that contains the list of documents and th
      *  spylink description for later output to a list of docs exported
      *  This will only be used, if called from EXPOBJSPY.

     C                   ADD       1             IFSDOC            5 0
     C     IFSDOC        IFEQ      1
     C                   EXSR      INISPC
     C                   ENDIF

     C                   MOVEL     RTYPID        SPCOBJ
     C                   DO        7             IX                5 0
     C                   MOVEL     LXIV(IX)      SPV(IX)
     C                   ENDDO
     C                   MOVEL     LXIV8         SPCFRM
     C                   MOVEA     @TXT          SPCPTH
     C                   MOVEL     LDXNAM        SPCSPY
     C                   MOVEL     LXSEQA        SPCSEQ

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
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
T6765p checkAuthority  b
     d                 pi            10i 0
     d inOpt                         10i 0 value

     c                   call      'MAG1060'
     c                   parm      ' '           calpgm                         caller
     c                   parm      ' '           pgmoff                         lv m1060 up
     c                   parm      'R'           cktype                         r)eport
     c                   parm      'R'           obtype            1            r)eport
     c                   parm      ' '           objnam           10
     c                   parm      ' '           objlib           10
     c                   parm      lrnam         rname                          big5
     c                   parm      ljnam         jname                           :
     c                   parm      lpnam         pname                           :
     c                   parm      lunam         uname                           :
     c                   parm      ludat         udata                           :
     c                   parm      inOpt         reqopt                         reqst opt
     c                   parm      *blanks       autrtn                         auth return

     c                   if        autrtn = 'N'
     c                   return    -1
     c                   endif
     c                   return    0

     p                 e
**
OVRDBF  FILE(BHYPRPTD) LVLCHK(*NO) TOFILE(
OVRDSPF FILE(DSPHYPBD) LVLCHK(*NO) TOFILE(
DLTOVR FILE(*ALL)

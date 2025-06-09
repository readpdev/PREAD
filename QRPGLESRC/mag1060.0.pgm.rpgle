     h dftactgrp(*no) actgrp('DOCMGR') bnddir('SPYBNDDIR')
      ************------------------
      *  MAG1060    Security Checker
      ************------------------
      *
     FASECUR2   IF   E           K DISK    USROPN
     FRSECUR2   IF   E           K DISK
     FFSECUR2   IF   E           K DISK    USROPN
      *
     FRSUBSCR   IF   E           K DISK
     FRSUBLST   IF   E           K DISK
     FRMAINT1   IF   E           K DISK
      *
     FRDSTDEF   IF   E           K DISK    USROPN
     FRSUBSCR2  IF   E           K DISK    USROPN
     F                                     RENAME(SUBSCR:SUBSCR2)
/7588FRSUBLST2  IF   E           K DISK
     F                                     RENAME(SUBLST:SUBLST2)
/3208FMIMGDIR   IF   E           K DISK    USROPN
     F                                     RENAME(IMGDIR:IMGDIR0)
     FMIMGDI12  IF   E           K DISK    USROPN
     FMRPTDIR3  IF   E           K DISK    USROPN
/3208FMRPTDIR7  IF   E           K DISK    USROPN
     F                                     RENAME(RPTDIR:RPTDIR7)
J2586Fnsecur    if   e           k disk
      *
J2586 * 05-25-10 PLR Annotation security.
J1559 * 10-19-09 PLR Prevent basic user from editing docLinks under standard
      *              security.
J1981 * 08-18-09 PLR Enforce supplemental group authority checking.
T6293 * 05-10-07 PLR The overloading of the Change flag conflicts between
      *              DocView's use of placing stamps and CoEx's
      *              use of editing doclinks. Review SAR for related info.
      *              For this fix, we will allow basic and admin users
      *              under extended security to reference the Change flag
      *              for both the editing of links and the placing of
      *              stamps. If this becomes an issue in the future, it may be
      *              possible to use the link flag (SLINK) to represent the
      *              authority to edit doclinks. Some code removed for 9542.
T4443 * 07-11-05 PLR Users belonging to a subscriber list were not able to see
/     *              hit list data.
/9542 * 04-26-05 PLR Overload GTAUT operation to return report authority flags.
/     *              See SPYCS for usage.
/9364 * 12-30-04 PLR Subscriber lists do not work in report security.
/8608 * 12-05-03 PLR Segments were not being honored when assigning RD via
/     *              a group profile (AS400 profile object).
/8699 * 11-11-03 PLR User was able to see entire report content although under RD.
/     *              Corrected by allowing full report authority checking if
/     *              under report distribution.
/8483 * 07-23-03 PLR 7588 removed checking of internal subscriber ID's existing
/     *              in subscriber lists. Modified to compensate.
/7563 * 03-04-03 PLR Check standard security settings at the report level so
/     *              user does not inadvertently get access to a report if
/     *              switching from extended to standard and changing authority
/     *              from *all to *exclude.
/7588 * 01-06-03 PLR Optimize report security checking.
/6204 * 02-20-02 KAC Handle blank Big5 key
/5546 * 10-05-01 KAC Return security override flag (report/segment auth)
/5197 *  8-09-01 KAC Fix the group MAG203 extend security
/3206 *  5-08-01 KAC CHECK GROUP FOR SPECIAL AUTHORITY
/3172 * 11-07-00 DLS ADD APPLICATION SECURITY AND KEEP JOEUSER
/3172 *              FROM EXECUTING MIRROR JOBS
/3208 * 10-02-00 KAC ADD *BATCHID ALTERNATIVE FOR BIG5 KEY
/2404 *  2-01-00 JJF Prevent security for images using report values
/2083 *  1-11-00 JJF Grant auth to SubsList *ALL rpts w/Dist & AppSec
      *  6-04-99 JJF Fix 5-20 auth list error when folder name present 1784HQ
      *  5-20-99 JJF Allow access via folder auth list to programs calling
      *              for rpt sec without a fldr name (SR NAMFLD) 1784HQ
      * 10-20-98 JJF Add new call paradigm: CkType = 'S' (subr SEGSEC)
      *              Also open ASECUR/FSECUR only when APPSEC/EXTSEC=Y
      * 10-16-98 JJF Allow Dist subscriber to read and print report
      *              when RSECUR denies reading (subr CHKDST).
      *  3/13/98 FB  Exsr USRSEC in REPSEC subr.
      * 12/10/97 GT  Add call to MAG1060A to check authorization lichkds 18
      *  9/10/97 GK  Add user chain to Subscriber file.
      *  5/02/96 JJF Add Suppl Groups (V3R1).  #SG=#SuppGrps (0-15).
      *  3/22/96 JJF Limit saves of WRK array into RMV to 25 chars.
      *  1/16/96 DM  Re-add specfic *PUBLIC check at the folder level
      * 12/04/95 Paf Fix bug in BOT Rtn when pgm passes (AUTE) appl.*
      *              security to mag203.
      * 11/15/95 Paf Expand Viewer application security  to 65 auths.
      *                  Add 40 new viewer Sec. flds to APPSDS DS
      *                  Add (AUTE) authority Extended for 40 fields
      *                  Add AUTE to parm list for App Sec for Mag203
      * 10/30/95 DM  In OBJSEC, put N to all OVR if OVR,25 should be N.
      *  8/03/95 JJF Add array DFA for app sec default.
      *  7/07/95 JJF Use *PUBLIC in FILOBJ only when DEF,10 is not 'Y'.
      *              (Allow "Creators" to keep default Y's.)
      *  6/30/95 JJF Keep JQ Public away from batch pgms when APPSEC=N.
      *  5/18/95 JJF End MAG1060 if calling pgm Parm CALPGM = *ALL.
      *  4/28/95 JJF Add Application Security logic.
      *  3/ 3/95 Dlm Add WRKSPI to WRKRD2 test
      *  1/25/95 ED  Change SRAUSR To *Current for Extend, else PGMUSR
      *  1/24/95     Add call for WRKFAU to see if user has authority
      *               to *ALL/*ALL which is called from the Menu.
      *  1/16/95     Add QSPLCT SysDft check
      *
      *   =========== Security Arrays =============
      *   Element  App  Fld  Rpt  Function
      *   -------  ---  ---  ---  -----------------
      *         1   A    F    R   Select/Read
      *         2   A    F    R   Change
      *         3   A    F    R   Copy
      *         4   A    F    R   Delete
      *         5   A    F    R   Display Attrs
      *         6   A             Print
      *         7   A             Run
      *         8   A             Config
      *         9   A             Move
      *        10   A    F        Create   (Power user)
      *        11   A             Backup
      *        12   A             Restore
      *        13   A             Security
      *        14   A             History
      *        16   A             WW SpyLinks
      *        17   A             WW Segments
      *
      *         6        F    R   Security
      *         7        F        WW SpyLinks
      *         8        F    R   Backup
      *         9        F    R   Restore
      *        10             R   Config
      *        11             R   WW Segments
      *        12             R   Print
      *        13             R   Move
      *
     D DEF             S              1    DIM(65)                              Default-Folder
     D DFA             S              1    DIM(65)                              Default-Applic
     D OBJ             S              1    DIM(65)                              Object
     D OVR             S              1    DIM(65)                              Override
     D HOLD            S              1    DIM(65)                              SuppGrps Holdr
     D GSEC            S              1    DIM(65)                              SuppGrps Compr
     D AUT             S              1    DIM(25)                              Work RETURN
     D AUTE            S              1    DIM(40)                              Extd Auth Ret.
     D SGP             S             10    DIM(15)                              Suppl Groups
      * Folder
     D FMF             S             20    DIM(10)                              Memory Folders
     D FMV             S             25    DIM(10)                              Memory Values
      * Application
f dimD AMF             S             20    DIM(10)                              Mem app names
     D
     D AMV             S             65    DIM(10)                              Memory values
      * Report
/6204d RMF             S             50    DIM(12) inz(*loval)                  Mem rpt names
     D RMV             S             25    DIM(12)                              Memory values

     D RDF             S              1    DIM(25)                              Default
     D RSC             S              1    DIM(25)                              Security
/3172D BCHPGM          S             10    DIM(8) CTDATA PERRCD(8) ASCEND       Batch programs
     d                 ds
J2586d NSC             s              9    dim(7)                               Note security
J2586d NSD             s              9    dim(7)                               Note security dft
J2586d noteTypes       s              2    dim(7) ctdata
J2586d noteSecNdx      s             10i 0
J2586d noteSecDta    e ds                  extname(nsecur)

/3208D RPTKEY          DS
/    D  RKNULL                 1      1
/    D  RKID                   2     10

     D CALPGM          DS            10
     D  CLPG46                 4      6

     D REPORT          DS            50
      *             50 character REPORT field
     D  WREPNM                 1     10
     D  WJOBNM                11     20
     D  WPGMNM                21     30
     D  WUSRNM                31     40
     D  WUSRDT                41     50

     D SYSDFT          DS          1024    dtaara
      *             Spy system defaults
      *             Flags to use: ExtSec, SpoolCtl, User, Group,
      *                         Auth lists, Pgm adopted auth.
     D  EXTSEC               137    137
     D  QSPLCT               139    139
     D  LDSTYN               220    220
     D  SUSRAU               346    346
     D  SGRPAU               347    347
     D  SAUTLS               348    348
     D  SADPAU               349    349
     D  APPSEC               373    373

     D UI0200          DS           256
      *             User Info from QSYRUSRI: USRI0200
      *                USRCLS  User class...*SECOFR *SYSOPR etc
      *                ALLOBJ  Y = All object authority
      *                SPLCTL  Y = Spool ctrl authority
      *                GRPPRF  Name of the group profile, or *NONE.

     D  USRCLS                19     28
     D  ALLOBJ                29     29
     D  SECADM                30     30
     D  JOBCTL                31     31
     D  SPLCTL                32     32
     D  SAVSYS                33     33
     D  SERVIC                34     34
     D  AUDIT                 35     35
     D  GRPPRF                44     53
     D  SGPFLD               105    254

      *                                 * B   1   40BYTRTN
      *                                 * B   5   80BYTVAL
      *                                 *     9  18 USRPRF
      *                                 *    29  43 SPCAUT
      *                                 *    36  43 RESV1
      *                                 *    54  63 OWNER
      *                                 *    64  73 GRPAUT
      *                                 *    74  83 LMTCPB

     D SRAVAR          DS            57
      *             User authority to object from QSYRUSRA
      *               OBJAUT  User's auth to object.. *ALL *CHANGE *USE
      *               OBJOPR  Y = Operational auth to obj
      *               OBJMGT  Y = Management  auth to obj
      *               OBJEXS  Y = Existence   auth to obj
      *               READ    Y = Data read   auth to obj
      *               AUTLST  Authorization List name OR *NONE *DAMAGED
      *               AUTSRC  Source of authority to obj.
      *                     UA/GA User/Group has *ALLOBJ
      *                     UO/GO User/Group private auth to obj
      *                     UL/GL User/Group auth to obj via auth list
      *                     PO    User Public auth
      *                     PL    User Public auth to auth list
      *                     AD    All user auth is Adopted

     D  OBJAUT                 9     18
     D  OBJOPR                20     20
     D  OBJMGT                21     21
     D  OBJEXS                22     22
     D  READ                  23     23
     D  AUTLST                27     36    INZ('*NONE')
     D  AUTSRC                37     38

     D RETCD           DS
      *             Return code DS from APIs
     D  ERLEN                  1      4i 0 INZ(116)
     D  RTCD                   5      8i 0
     D  CONDTN                 9     15
     D  MSGDTA                17    116
     D                 DS
      *             API fields
     D  URILEN                 1      4i 0 INZ(256)
     D  URIFRM                 5     12    INZ('USRI0200')
     D  ALFA4                 13     16
     D  BIN9                  13     16i 0

     D  SRALEN                21     24i 0 INZ(57)
     D  SRAFRM                25     32    INZ('USRA0100')

     D                SDS
      *             Program Status
     D  PGMERR           *STATUS
     D  PGMLIN                21     28
     D  PARMS                 37     39  0
     D  SYSERR                40     46
     D  CURLIB                81     90
     D  PGMUSR               254    263
     D APPSDS          DS
      *             App Sec auths
     D  ASSEL                  1      1
     D  ASCHG                  2      2
     D  ASCOPY                 3      3
     D  ASDEL                  4      4
     D  ASVIEW                 5      5
     D  ASPRT                  6      6
     D  ASRUN                  7      7
     D  ASCNFG                 8      8
     D  ASMOVE                 9      9
     D  ASCRT                 10     10
     D  ASBACK                11     11
     D  ASREST                12     12
     D  ASSEC                 13     13
     D  ASHIST                14     14
     D  ASVWLN                15     15
     D  ASCGLN                16     16
     D  ASWSEG                17     17

      * Numbers 26-65 are used by the Report Viewer, and correspond to
      *  the pull-down menu options as they existed in November, 1995.

      ** Report Auth Security **
     D  ASVR0                 26     26
     D  ASVR1                 27     27
     D  ASVR2                 28     28
     D  ASVR3                 29     29
     D  ASVR4                 30     30
     D  ASVR5                 31     31
      ** Search Auth Security **
     D  ASVS0                 32     32
     D  ASVS1                 33     33
     D  ASVS2                 34     34
     D  ASVS3                 35     35
     D  ASVS4                 36     36
     D  ASVS5                 37     37
     D  ASVS6                 38     38
      ** Notes Auth Security **
     D  ASVN0                 39     39
     D  ASVN1                 40     40
     D  ASVN2                 41     41
     D  ASVW0                 42     42
      ** Window Auth Security **
     D  ASVW1                 43     43
     D  ASVW2                 44     44
     D  ASVW3                 45     45
     D  ASVW4                 46     46
     D  ASVW5                 47     47
     D  ASVW6                 48     48
      ** Print Auth Security **
     D  ASVP0                 49     49
     D  ASVP1                 50     50
     D  ASVP2                 51     51
     D  ASVP3                 52     52
      ** Config Auth Security **
     D  ASVC0                 53     53
     D  ASVC1                 54     54
     D  ASVC2                 55     55
     D  ASVC3                 56     56
     D  ASVC4                 57     57
     D  ASVC5                 58     58
     D  ASVC6                 59     59
     D  ASVC7                 60     60
     D  ASVC8                 61     61
     D  ASVC9                 62     62
     D  ASVCA                 63     63
     D  ASVCB                 64     64
     D  ASVCF                 65     65
     D FLDSDS          DS
      *             Folder security auths
     D  FVIEW                  1      1
     D  FCHG                   2      2
     D  FCOPY                  3      3
     D  FDEL                   4      4
     D  FATTR                  5      5
     D  FSEC                   6      6
     D  FLINK                  7      7
     D  FBAK                   8      8
     D  FRST                   9      9
     D  FCRT                  10     10

     D RPTSDS          DS
      *             Report security auths
     D  SREAD                  1      1
     D  SCHG                   2      2
     D  SCOPY                  3      3
     D  SDEL                   4      4
     D  SATTR                  5      5
     D  SSEC                   6      6
     D  SLINK                  7      7
     D  SBAK                   8      8
     D  SRST                   9      9
     D  SCFG                  10     10
     D  SSEG                  11     11
     D  SPRNT                 12     12
     D  SMOVE                 13     13
     D WRKAUT          DS
      *             Strip low order of WRK for passing additional
      *             parms for MAG203 when parm# = 15
     D  WRK                    1     65
     D                                     DIM(65)                              Work
     D  WRKB                  26     65

     D ALL             C                   CONST('YYYYYYYYYYYYYYYYYYYY-
     D                                     YYYYY')
     D NONE            C                   CONST('NNNNNNNNNNNNNNNNNNNN-
     D                                     NNNNN')
/7588 /copy @mgmemmgrr
/    d subP            s               *
/    d nameSz          s             10i 0 inz(%size(suser))
/    d subcnt          s             10i 0 inz(-1)
/    d subx            s             10i 0
/8483d wrkusr          s                   like(suser)
/8699d nodist          s               n
/8608d once            s               n   inz('1')

J2586d setNoteSecArr   pr

     ISUBSCR
      * Subscriber DB field renamed
     I              SUSER                       SUSER2

      *****************************************************************

      *  Answer based on entry param CKTYPE:

      *     (O)bject - Can the user run the option on the object?
      *     (R)eport - Can the user run the option on the report?
      *     (S)egment- Does the user subscribe to the segment?
      *     (U)ser  -  Should we show the requested option (OP)
      *                on the Work With subfiles?

      *  Return value  RETURN = Y/N to authorize/deny user request.

      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    CALPGM           10            Calling Pgm
     C                   PARM                    PGMOFF            1            Unload Y/N
     C                   PARM                    CKTYPE            1            Usr/Obj/Rpt

     C                   PARM                    OBJTYP            1            Fld/Rpt/App
     C                   PARM                    OBJNAM           10            Object name
     C                   PARM                    OBJLIB           10            Object libr

     C                   PARM                    RPTNAM           10            Big 5
     C                   PARM                    JOBNAM           10             =KLBIG5
     C                   PARM                    PGMNAM           10
     C                   PARM                    USRNAM           10
     C                   PARM                    USRDTA           10

     C                   PARM                    REQOPT            2 0          Reqst Option
     C                   PARM                    RETURN            1            Return code
     C                   PARM                    AUT                            Return WRK
     C                   PARM                    AUTE                           Return WRKB
/5546c                   parm                    SecOvr           10            Return If Ovr

      * Moved exsr to usrsec here because it was being done in *INZSR...disallowing
      * the reset of the original contents of UI0200.
/8608c                   if        once and pgmoff <> 'Y'
/    c                   exsr      usrsec                                        Load @POWER
/    c                   end
/    c                   eval      once = '0'

     C     PGMOFF        IFEQ      'Y'                                          End MAG1060
     C     CALPGM        IFEQ      BEGPGM                                       if calling
     C     CALPGM        OREQ      '*ALL'                                       pgm = orig
     C                   EXSR      QUIT
     C                   END
     C                   RETURN
     C                   END

     C                   Z-ADD     REQOPT        OP                2 0
     C                   MOVE      'N'           RETURN
/5546c                   if        parms > 15
/    c                   eval      SecOvr = *blanks
/    c                   end

/8608c                   reset                   ui0200
/    c                   reset                   prigrp
/    c                   reset                   sgp
/    c                   reset                   #sg

      * Special case: WrkFldrAuth, option 99: need all Y's to allow.
     C     CALPGM        IFEQ      'WRKFAU'
     C     OP            ANDEQ     99
     C                   MOVE      'F'           OBJTYP
     C                   EXSR      FILDEF                                        OK if fldr
     C                   MOVEA(P)  DEF           DEFCHK                          default all
     C     DEFCHK        IFEQ      ALL                                           Ys.
     C                   MOVE      'Y'           RETURN
     C                   ELSE
     C                   MOVE      'N'           RETURN
     C                   END
     C                   RETURN
     C                   END

     C     CKTYPE        CASEQ     'O'           OBJSEC                         Fld/Appl
     C     CKTYPE        CASEQ     'R'           REPSEC                         Report/Batch
     C     CKTYPE        CASEQ     'S'           SEGSEC                         Segment
     C     CKTYPE        CASEQ     'U'           USRSEC                         User
     C                   ENDCS

     C                   RETURN

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     USRSEC        BEGSR
      *          Get User-level authority

      *---------------------------------------------------------------
      *| Output: RETURN = @POWER = 'Y' or 'N'                        |
      *|                                                             |
      *| If extended security = 'Y' and OBJTYP NE 'A', return 'Y'    |
      *|                                                             |
      *| If extended security = 'N' or OBJTYP = 'A'                  |
      *|    If user has  SECOFR class, SPLCTL or ALLOBJ privileges,  |
      *|         return 'Y'.                                         |
      *|                                                             |
      *|    Else if USE GROUP AUTHORITY (SysDft-SGRPAU) is on        |
      *|         and user has a group profile,                       |
      *|         check the group(s) for powers.                      |
      *|                                                             |
      *---------------------------------------------------------------

     C     @POWER        IFGT      ' '                                          Been here
     C                   MOVE      @POWER        RETURN                          done this
     C                   GOTO      ENDUSR
     C                   END

     C                   MOVE      'N'           RETURN
/3206C                   MOVE      'N'           ALLOB2            1
/3206C                   MOVE      'N'           SPLCT2            1
/3206C                   MOVE      'N'           SECAD2            1
/3206C                   MOVE      'N'           JOBCT2            1
/3206C                   MOVE      'N'           SAVSY2            1
/3206C                   MOVE      'N'           SERVI2            1
/3206C                   MOVE      'N'           AUDIT2            1

     C     EXTSEC        IFEQ      'Y'                                          Extended
     C     OBJTYP        ANDNE     'A'                                           Security
     C                   MOVE      'Y'           RETURN                          shows all
     C                   GOTO      BOTUSR                                        for now...
     C                   END

     C                   MOVEL(P)  '*CURRENT'    APIUSR           10            For pass 1
     C     #SG           ADD       2             PASSES            3 0          Suppl+Gr+Usr

     C                   DO        PASSES        PASS#             3 0          1:User 2+Grp
      *                                                    Page 53-19
     C                   CALL      'QSYRUSRI'                           49      Get info
     C                   PARM                    UI0200                          about user:
     C                   PARM                    URILEN                          Class,Priv
     C                   PARM                    URIFRM                          Groups
     C                   PARM      APIUSR        URIUSR           10            User
     C                   PARM                    RETCD                          Error Code

      * ACCUMULATE AUTHORITIES
/3206C     ALLOBJ        IFEQ      'Y'
/    C                   MOVE      'Y'           ALLOB2
/    C                   END
/    C     SPLCTL        IFEQ      'Y'
/    C                   MOVE      'Y'           SPLCT2
/    C                   END
/    C     SECADM        IFEQ      'Y'
/    C                   MOVE      'Y'           SECAD2
/    C                   END
/    C     JOBCTL        IFEQ      'Y'
/    C                   MOVE      'Y'           JOBCT2
/    C                   END
/    C     SAVSYS        IFEQ      'Y'
/    C                   MOVE      'Y'           SAVSY2
/    C                   END
/    C     SERVIC        IFEQ      'Y'
/    C                   MOVE      'Y'           SERVI2
/    C                   END
/    C     AUDIT         IFEQ      'Y'
/    C                   MOVE      'Y'           AUDIT2
/    C                   END

     C     USRCLS        IFEQ      '*SECOFR'
     C     ALLOBJ        OREQ      'Y'
     C     SPLCTL        OREQ      'Y'
     C     QSPLCT        ANDNE     'N'
     C                   MOVE      'Y'           RETURN                         Got Power
     C                   LEAVE
     C                   END

     C     PASS#         IFEQ      1                                            User has
     C     SGRPAU        IFNE      'Y'                                           no group
     C     GRPPRF        OREQ      '*NONE'
     C     GRPPRF        OREQ      *BLANK                                       No Power
     C                   LEAVE
     C                   END

      * Load APIUSR for next pass.
      *  for 2nd pass
     C                   MOVEA     SGPFLD        SGP
     C                   MOVE      GRPPRF        APIUSR
     C                   Z-ADD     0             SG#               3 0
      *  for passes 3+
     C                   ELSE
     C                   ADD       1             SG#
     C     SG#           IFGT      #SG
     C                   LEAVE                                                   DoneSupGrps
     C                   END
     C                   MOVE      SGP(SG#)      APIUSR                          Next SupGrp
     C                   END
     C                   ENDDO
      *>>>>
     C     BOTUSR        TAG
     C                   MOVE      RETURN        @POWER            1            Power user
     C     ENDUSR        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     OBJSEC        BEGSR
      *          Get object security  (A)pplication or (F)older.

      *  SR OBJSEC:  Fill OVR, the OS/400 array.
      *              Check if user has been denied authority by OS/400.
      *              If so, OVR=N will override Spy FSECUR.
      *              Test the source of the OS/400 security
      *              (Ex. Adopted,Group,AuthLst). If Spy system
      *              environment says we shouldn't use AUTSRC,
      *              mark it 'N' in the OVR array.
      *              Call subrs FILDEF, FILOBJ, LODWRK and LODMEM

      *  SR FILDEF:  Fill DEF or DFA, the default arrays.
      *              Uses *ALL as the object name.

      *  SR FILOBJ:  Fill OBJ, the specific object array.
      *              Uses the object name in the entry list.

      *        note: for FILDEF and FILOBJ, the search order is:
      *              User
      *              Group
      *              Authorization list
      *              Subscriber list
      *              *ALLOBJ
      *              *SECOFR
      *              *SPLCTL
      *              *PUBLIC
      *            Exit on the first find.

      *  SR LODWRK:  Fill WRK, combining OVR, OBJ, DEF/DFA. Priorities:
      *                 1. OVR, AS400 override (if 'N', deny).
      *                 2. OBJ, specific OBJECT security.
      *                 3. DEF/DFA, default security.

      *  SR LODMEM:  Save time on next call to this program:
      *                 Save WRK in array for SR CKMEM to get.
      *                 Save Object name in array.
      *  Example:

      *    SECUR  Opt: 1   2   3   4   5   6
      *   -------------------------------------------------------
      *     DEF/DFA    Y   N   N   N   N   N
      *     OBJ        Y   Y   Y   Y   N   Y   view/chg/cpy/del/print
      *     OVR                N   N   Y   Y   no Mgt / Exist
      *              --------------------------------------------
      *     WRK        Y   Y   N   N   N   Y   view/chg/print

      *     DEF/DFA = ASECUR (*ALL Record)
      *     OBJ     = ASECUR ( Object Specific)
      *     OVR     = AS400  ( Object Specific)
      *     WRK     = Final Decoded Security Authority Values.

      *     Return to the calling program: RETURN = Y/N, the
      *     result of the requested option's authorization check.
      *     Also return array AUT if entry param present (norm appl sec

     C     OBJTYP        IFEQ      'A'                                          AppSec: If
     C     OBJLIB        ANDEQ     *BLANK                                        libr empty
     C                   MOVE      CURLIB        OBJLIB                          use current
     C                   END                                                     pgm status

     C                   CLEAR                   OVR
     C                   MOVE      ' '           OVRBYT            1
      *--------------------------------------------------
      * Objtyp = A but App Security turned off: No APPSEC
      *--------------------------------------------------
     C     OBJTYP        IFEQ      'A'
     C     APPSEC        ANDNE     'Y'
     C                   MOVE      'N'           WRK
     C                   MOVEL(P)  '*CURRENT'    APIUSR

     C                   DO        2             PASSES                         1=User 2=Grp
     C                   CALL      'QSYRUSRI'                           49      Get info
     C                   PARM                    UI0200                          about user:
     C                   PARM                    URILEN                          Class,Priv
     C                   PARM                    URIFRM                          GrpPrf.
     C                   PARM      APIUSR        URIUSR                         User Name
     C                   PARM                    RETCD                          Error Code

     C     USRCLS        IFEQ      '*SECOFR'
     C     ALLOBJ        OREQ      'Y'
     C     QSPLCT        ORNE      'N'
     C     SPLCTL        ANDEQ     'Y'
     C                   MOVE      'Y'           WRK                            Default Yes
     C                   GOTO      BOTOBS                                       Done w/sec
     C                   END

     C     PASSES        IFEQ      1                                             ForNextPass
     C                   MOVE      GRPPRF        APIUSR                          GrpProfile
     C                   ELSE
     C     CLPG46        IFNE      'ENV'                                         Keep JQ Pub
     C     CALPGM        LOOKUP    BCHPGM                                 40      away.
     C     *IN40         IFNE      *ON                                           Else, OK to
     C                   MOVE      'Y'           WRK(1)                            Select
     C                   MOVEA     'YYY'         WRK(5)                            View
     C                   MOVE      'Y'           WRK(15)                           Vu Lnk
     C                   MOVE      *ALL'Y'       WRKB                              Mag203ext
     C                   END                                                       Print
     C                   END                                                       Run
     C                   END
     C                   ENDDO
     C                   GOTO      BOTOBS                                       Done w/Nosec
     C                   END

     C     OBJNAM        CAT       OBJLIB        OBJECT           20            Object:Libr
     C                   EXSR      CHKMEM                                       Check memory
     C     FNDSEC        CABEQ     'Y'           BOTOBS                          WRK loaded,
      *                                                     exit this.
     C                   MOVEL(P)  '*CURRENT'    APIUSR
     C                   CALL      'QSYRUSRI'                           49      Get info
     C                   PARM                    UI0200                          about user:
     C                   PARM                    URILEN                          Class,Priv
     C                   PARM                    URIFRM                          GrpPrf.
     C                   PARM      APIUSR        URIUSR                         User Name
     C                   PARM                    RETCD                          Error Code
      *-----------------------------------
      * Put AS/400 auth to Object into OVR
      *-----------------------------------
     C     OBJTYP        IFEQ      'F'
     C                   MOVEL(P)  '*FILE'       SRATYP           10            FOLDER
     C                   ELSE
     C                   MOVEL(P)  '*PGM'        SRATYP                         APP
     C                   END

     C     EXTSEC        IFEQ      'Y'                                          SpyView
     C                   MOVEL(P)  '*CURRENT'    SRAUSR                         extended sec
     C                   ELSE
     C                   MOVE      PGMUSR        SRAUSR                         User Name
     C                   END

      * Get auth to object. eg:OBJAUT OBJMGT READ
     C                   DO        16            PASSES                         1:User 2+Grp
     C                   RESET                   AUTLST
     C                   CALL      'QSYRUSRA'                           49
     C                   PARM                    SRAVAR
     C                   PARM                    SRALEN
     C                   PARM                    SRAFRM
     C                   PARM                    SRAUSR           10            User
     C                   PARM      OBJECT        SRAOBJ           20            Object
     C                   PARM                    SRATYP                         Object type
     C                   PARM                    RETCD                          Error Code

      * Blank out the OVR array, then load Ns as required.
     C     PASSES        IFLE      2
     C                   CLEAR                   OVR
     C                   END

     C                   MOVE      ' '           OVRBYT

     C     PASSES        IFGT      1                                            Group pass
     C     AUTSRC        IFEQ      'UL'                                         via List
     C     AUTSRC        OREQ      'UO'                                         Private
     C     AUTSRC        OREQ      'UA'                                         *allobj
     C                   MOVEL     'G'           AUTSRC                          Group src
     C                   END
     C                   END
      *                                                    ------------
      *                                                    Application
     C     OBJTYP        IFEQ      'A'                                          ------------
     C     READ          IFEQ      'N'                                          No Read or
     C     OBJOPR        OREQ      'N'                                          No Operatnl
     C                   MOVE      'N'           OVRBYT                          Deny
     C                   END
     C                   END
      *                                                    ------------
     C     OBJTYP        IFEQ      'F'                                          Folder
     C                   SELECT                                                 ------------
     C     OP            WHENEQ    1
     C     READ          ANDEQ     'N'                                          Deny:
     C                   MOVE      'N'           OVRBYT                           view
     C     OP            WHENEQ    3
     C     OBJMGT        ANDEQ     'N'
     C                   MOVE      'N'           OVRBYT                           copy
     C     OP            WHENEQ    4
     C     OBJEXS        ANDEQ     'N'
     C                   MOVE      'N'           OVRBYT                           delete
     C     OP            WHENEQ    8
     C     OBJEXS        ANDEQ     'N'
     C                   MOVE      'N'           OVRBYT                           spylinks
     C     OP            WHENEQ    25
     C     OBJAUT        ANDEQ     '*EXCLUDE'                                   Load subfile
     C                   MOVE      'N'           OVR                              N to ALL
     C                   MOVE      'N'           OVRBYT
     C                   ENDSL
     C                   END
      *                                                    ------------
      *                                                    Fold & Appl
     C     AUTSRC        IFEQ      'AD'                                         ------------
     C     SADPAU        ANDNE     'Y'                                          Deny:Adopted
     C     AUTSRC        OREQ      'UL'
     C     SAUTLS        ANDNE     'Y'                                           Auth List
     C     AUTSRC        OREQ      'GL'
     C     SAUTLS        ANDNE     'Y'                                           Auth List
     C     AUTSRC        OREQ      'PL'
     C     SAUTLS        ANDNE     'Y'                                           Auth List
     C     AUTSRC        OREQ      'GA'
     C     SGRPAU        ANDNE     'Y'                                           Group Auth
     C     AUTSRC        OREQ      'GO'
     C     SGRPAU        ANDNE     'Y'                                           Group Auth
     C     AUTSRC        OREQ      'UA'
     C     SUSRAU        ANDNE     'Y'                                           User Auth
     C     AUTSRC        OREQ      'UO'
     C     SUSRAU        ANDNE     'Y'                                           User Auth
     C                   MOVE      'N'           OVRBYT
     C                   END

     C     PASSES        IFLE      2                                            Usr/PriGrp
     C     OVRBYT        ANDEQ     'N'
     C     OBJTYP        IFEQ      'A'                                          Application
     C                   MOVE      OVRBYT        OVR                              Deny All
     C                   ELSE                                                   Folder
     C                   MOVE      OVRBYT        OVR(OP)                          Deny Optn
     C                   END
     C                   END

     C     PASSES        IFGT      2                                            Suppl Groups
     C     OVRBYT        ANDEQ     ' '                                           remove Ns.
     C     OBJTYP        IFEQ      'A'                                          Application
     C                   MOVE      ' '           OVR                             Allow All
     C                   ELSE                                                   Folder
     C                   MOVE      ' '           OVR(OP)                         Allow Optn
     C                   END
     C                   END

     C     PASSES        IFEQ      1                                            User pass
     C     GRPPRF        IFEQ      '*NONE'                                       No Grps
     C     OBJAUT        ORNE      '*EXCLUDE'                                    User O.K.
/2404C     OBJAUT        OREQ      '*EXCLUDE'                                    User denied
/2404C     AUTSRC        ANDEQ     'UO'                                           to Object
     C                   LEAVE                                                      Done.
     C                   END

      * Load SRAUSR for next pass
     C                   Z-ADD     0             SG#
     C                   MOVE      GRPPRF        SRAUSR

     C                   ELSE
     C                   ADD       1             SG#                             Prepare for
     C     SG#           IFGT      #SG
     C                   LEAVE
     C                   END
     C                   MOVE      SGP(SG#)      SRAUSR                          group pass
     C                   END
     C                   ENDDO

     C     OBJTYP        IFEQ      'F'
     C     DEFDUN        ANDNE     'Y'                                          Fill DEF frm
     C                   MOVE      'Y'           DEFDUN            1             SECUR file
     C                   EXSR      FILDEF                                        for *ALL.
     C                   END

     C     OBJTYP        IFEQ      'A'
     C     DFADUN        ANDNE     'Y'                                          Fill DFA frm
     C                   MOVE      'Y'           DFADUN            1             SECUR file
     C                   EXSR      FILDEF                                        for *ALL.
     C                   END

     C                   EXSR      FILOBJ                                       Fill OBJ.
     C                   EXSR      LODWRK                                       Load WRK
     C                   EXSR      LODMEM                                       Load memory
      *>>>>
     C     BOTOBS        TAG
     C     PARMS         IFGT      13                                           Return AUT
     C                   MOVE      WRK           AUT                             only if in

     C     PARMS         IFGT      14                                           Mag203 calld
     C     APPSEC        IFEQ      'Y'
     C                   MOVEA     WRKB          AUTE                            Extd Auth
     C                   ELSE
     C                   MOVE      *ALL'Y'       AUTE                            Entry PList
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      WRK(REQOPT)   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FILDEF        BEGSR
      *          ------------------------------------
      *          Fill DEF or DFA, the default arrays,
      *           using *ALL names in SECUR file
      *          ------------------------------------

      * Default all Y's
     C                   SELECT
     C     OBJTYP        WHENEQ    'F'
     C                   MOVE      'Y'           DEF
     C     OBJTYP        WHENEQ    'A'
     C                   MOVE      'Y'           DFA
     C                   ENDSL

     C     OBJTYP        IFEQ      'F'                                          Folder obj
     C     EXTSEC        ANDNE     'Y'                                           no ExtSec
     C     OBJTYP        OREQ      'A'                                          Applic obj
     C     APPSEC        ANDNE     'Y'                                           no AppSec
     C                   GOTO      ENDDEF
     C                   END

     C                   MOVEL(P)  '*ALL'        FSOBJ            10
     C                   MOVEL(P)  '*ALL'        FSOBJL           10
     C                   MOVE      'U'           FSIDTY
     C                   MOVE      PGMUSR        FSID                           Is User in
     C                   EXSR      CHAINF                                        SECUR file?
     C     *IN51         CABEQ     *OFF          MOVDEF                         Yes, use it.

     C     PRIGRP        IFNE      '*NONE'
     C                   MOVE      ' '           @UZGRP            1
     C                   MOVE      'G'           FSIDTY
     C                   MOVE      PRIGRP        FSID                           Is PriGrp in
     C                   EXSR      CHAINF                                        SECUR file?
     C  N51              MOVE      'Y'           @UZGRP                           Yes
     C     #SG           IFGT      0
     C   51              MOVE      'Y'           HOLD
     C                   EXSR      SUPGRP                                       Supplemental
     C                   END                                                     group(s).
     C     @UZGRP        CABEQ     'Y'           MOVDEF                         Use group
     C                   END                                                     results...

     C     AUTLST        IFNE      '*NONE'
     C                   MOVE      'A'           FSIDTY
     C                   MOVE      AUTLST        FSID                           Is AutLst in
     C                   EXSR      CHAINF                                        SECUR file?
     C     *IN51         CABEQ     *OFF          MOVDEF                         Use AuthLst
     C                   END

     C                   MOVE      'S'           FSIDTY                         Try SubsList
     C                   CLEAR                   FSID
     C                   MOVEL(P)  '*ALL'        #FSOBJ           10
     C                   MOVEL(P)  '*ALL'        #FSLIB           10
     C                   MOVE      'S'           #FSIDT            1

      * Folder   SECKYF =  FSOBJ  FSOBJL FSIDTY FSID
      *          SECCMP =  #FSOBJ #FSLIB #FSIDT
      * Applic   SECKYA =  FSOBJ         FSIDTY FSID
      *          SECCMA =  #FSOBJ        #FSIDT

     C     OBJTYP        IFEQ      'F'
     C     SECKYF        SETLL     FSECRC                                       Folder
     C                   ELSE
     C     SECKYA        SETLL     ASECRC                                       Application
     C                   END

      *                                                    Get first
     C     *IN51         DOUEQ     *ON                                          S-type rec.

     C     OBJTYP        IFEQ      'F'
     C     SECCMP        READE     FSECRC                                 51     Folder
     C                   ELSE                                                      or
     C     SECCMA        READE     ASECRC                                 51     Applicatn
     C                   MOVE      ASUID         FSID
     C                   END
     C   51              LEAVE                                                  No S-types.

     C     FSID          SETLL     RSUBLST
     C     *IN52         DOUEQ     *ON                                          Get matching
     C     FSID          READE     RSUBLST                                52     List ID.
     C   52              LEAVE

     C     SUBSID        CHAIN     RSUBSCR                            53        Check the
     C     *IN53         IFEQ      *OFF                                          Subscriber
     C     SUSER2        ANDEQ     PGMUSR                                        file.
     C                   GOTO      MOVDEF
     C                   END
     C                   ENDDO
     C                   ENDDO

      * App Sec
     C     OBJTYP        IFEQ      'A'                                          Application
     C                   EXSR      USRSEC                                       UsrPriv/clas

     C     ALLOBJ        IFEQ      'Y'
/3206C     ALLOB2        OREQ      'Y'
     C                   MOVEL(P)  '*ALLOBJ'     FSID                           All Objects
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVDEF
     C                   END

     C                   MOVE(P)   USRCLS        FSID                           Security Ofr
     C                   MOVE      'C'           FSIDTY                         Class
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVDEF

     C     SPLCTL        IFEQ      'Y'
     C     QSPLCT        ANDNE     'N'
/3206C     SPLCT2        OREQ      'Y'
/    C     QSPLCT        ANDNE     'N'
     C                   MOVEL(P)  '*SPLCTL'     FSID                           SPOOL CTL
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVDEF
     C                   END

     C     SECADM        IFEQ      'Y'
/3206C     SECAD2        OREQ      'Y'
     C                   MOVEL(P)  '*SECADM'     FSID                           Sec Admin
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVDEF
     C                   END

     C     JOBCTL        IFEQ      'Y'
/3206C     JOBCT2        OREQ      'Y'
     C                   MOVEL(P)  '*JOBCTL'     FSID                           Job Control
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVDEF
     C                   END

     C     SAVSYS        IFEQ      'Y'
/3206C     SAVSY2        OREQ      'Y'
     C                   MOVEL(P)  '*SAVSYS'     FSID                           Save System
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVDEF
     C                   END

     C     SERVIC        IFEQ      'Y'
/3206C     SERVI2        OREQ      'Y'
     C                   MOVEL(P)  '*SERVICE'    FSID                           Service
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVDEF
     C                   END

     C     AUDIT         IFEQ      'Y'
/3206C     AUDIT2        OREQ      'Y'
     C                   MOVEL(P)  '*AUDIT'      FSID                           Audit
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVDEF
     C                   END
     C                   END

      * Folder + App                                       FLDR & APPL-
     C                   MOVEL(P)  '*PUBLIC'     FSID
     C                   MOVE      'U'           FSIDTY                          *Public
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *ON           ENDDEF                          NRF, exit.

      *>>>>
     C     MOVDEF        TAG
     C     OBJTYP        IFEQ      'A'                                          APPLICATION
     C                   MOVEA     APPSDS        DFA
     C                   ELSE                                                   FOLDER
     C                   MOVEA     FLDSDS        DEF
     C     'Y'           LOOKUP    DEF                                    30     Any Y's?
     C  N30              MOVE      'N'           DEF(25)                          No
     C                   END

     C     ENDDEF        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SUPGRP        BEGSR
      *          ---------------------------------------------------
      *          Get SECUR file recs for suppl groups & seive data.
      *            Input:  *IN51, OBJTYP and either AppSDS or FldSDS
      *            Output: Modified AppSDS or FldSDS
      *          ---------------------------------------------------
     C     *IN51         IFEQ      *OFF                                         GrpPrf
     C     OBJTYP        IFEQ      'A'
     C                   MOVEA(P)  APPSDS        HOLD                            Hold App
     C                   ELSE
     C                   MOVEA(P)  FLDSDS        HOLD                            Hold Fldr
     C                   END
     C                   END
      *                                                    Loop for
     C                   DO        #SG           SG#                             suppl grps.
     C                   MOVEL     SGP(SG#)      FSID                            Use SupGrp
     C                   EXSR      CHAINF                                            name
     C   51              ITER                                                    NRF
     C                   MOVE      'Y'           @UZGRP
     C                   Z-ADD     25            #                 3 0
     C     OBJTYP        IFEQ      'A'                                          Application
     C                   MOVEA     APPSDS        GSEC                            SupGrp data
/5197C     OBJNAM        IFEQ      'MAG203'
     C                   Z-ADD     65            #
     C                   END
     C                   ELSE                                                   Folder
     C                   MOVEA     FLDSDS        GSEC                            SupGrp data
     C                   END

     C                   DO        #             X                 3 0          Supp groups
     C     GSEC(X)       IFEQ      'Y'                                           grant
     C                   MOVE      'Y'           HOLD(X)                         authority.
     C                   END
     C                   ENDDO
     C                   ENDDO

     C     OBJTYP        IFEQ      'A'                                          Return DS
     C                   MOVEA     HOLD          APPSDS                           App data
     C                   ELSE
     C                   MOVEA     HOLD          FLDSDS                           Flr data
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SUPGRR        BEGSR
      *          ---------------------------------------------------
      *          Just like SR SUPGRP, but for Report Security
      *          ---------------------------------------------------
     C     *IN51         IFEQ      *OFF                                         GrpPrf
     C                   MOVEA(P)  RPTSDS        HOLD                            Hold data
     C                   END
      *                                                    Loop for
     C                   DO        #SG           SG#                             suppl grps
     C                   MOVE      SGP(SG#)      SUSER                           use GrpNam
     C                   MOVE      'G'           SSIDTY
      *          KLRPT7 = SRNAM SJNAM SPNAM SUNAM SUDAT SSIDTY SUSER
     C     KLRPT7        CHAIN     SECRC                              51         SECUR file?
     C   51              ITER                                                   NRF
     C                   MOVE      'Y'           @UZGRP
     C                   MOVEA(P)  RPTSDS        GSEC                           Data to aray

     C                   DO        13            X                              Supp groups
J1981C     GSEC(X)       IFEQ      'N'                                           cancel
/    C                   MOVE      'N'           HOLD(X)                         denied
     C                   END                                                     authority.
     C                   ENDDO
J2586C                   callp     setNoteSecArr(NOTE_SEC_ARR_DFT)
     C                   ENDDO

     C                   MOVEA     HOLD          RPTSDS                         Sec data
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     FILOBJ        BEGSR
      *          Fill OBJ, the specific object array.
      *           only for ExtSec or AppSec

     C                   CLEAR                   OBJ

      * If (F)older, ExtSec must be Y
      * If (A)pplic, AppSec must be Y
     C     OBJTYP        IFEQ      'F'                                          Folder
     C     EXTSEC        ANDNE     'Y'                                            no ExtSec
     C     OBJTYP        OREQ      'A'                                          Applic
     C     APPSEC        ANDNE     'Y'                                            no AppSec
     C                   GOTO      ENDOBJ
     C                   END

     C                   MOVE      OBJNAM        FSOBJ
     C                   MOVE      OBJLIB        FSOBJL
     C                   MOVE      PGMUSR        FSID
     C                   MOVE      'U'           FSIDTY
     C                   EXSR      CHAINF                                       A/F SECUR
     C     *IN51         CABEQ     *OFF          MOVOBJ                         Got User rec

     C     PRIGRP        IFNE      '*NONE'
     C                   MOVE      ' '           @UZGRP
     C                   MOVE      'G'           FSIDTY
     C                   MOVE      PRIGRP        FSID                           Is PriGrp in
     C                   EXSR      CHAINF                                        SECUR file?
     C  N51              MOVE      'Y'           @UZGRP                           Yes
     C     #SG           IFGT      0
     C   51              MOVE      ' '           HOLD                           Supplemental
     C                   EXSR      SUPGRP
     C                   END                                                     group(s).
     C     @UZGRP        CABEQ     'Y'           MOVOBJ                         Use group
     C                   END                                                     results...

     C     AUTLST        IFNE      '*NONE'
     C     AUTSRC        IFEQ      'UL'
     C     AUTSRC        OREQ      'GL'
     C                   MOVE      *ON           ONAUTL
     C                   ELSE
     C                   MOVE      PGMUSR        AUUSER
     C                   EXSR      CKAUTL
     C                   ENDIF
     C     ONAUTL        IFEQ      *ON
     C                   MOVEL(P)  AUTLST        FSID
     C                   MOVE      'A'           FSIDTY
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      'S'           FSIDTY                         Subs List
     C                   CLEAR                   FSID
     C                   MOVE      OBJNAM        #FSOBJ
     C                   MOVE      OBJLIB        #FSLIB
     C                   MOVE      'S'           #FSIDT

      * Folder   SECKYF =  FSOBJ  FSOBJL FSIDTY FSID
      *          SECCMP =  #FSOBJ #FSLIB #FSIDT
      * Applic   SECKYA =  FSOBJ         FSIDTY FSID
      *          SECCMA =  #FSOBJ        #FSIDT

     C     OBJTYP        IFEQ      'F'
     C     SECKYF        SETLL     FSECRC                                       Folder
     C                   ELSE                                                     or
     C     SECKYA        SETLL     ASECRC                                       Application
     C                   END

     C     *IN51         DOUEQ     *ON

     C     OBJTYP        IFEQ      'F'
     C     SECCMP        READE     FSECRC                                 51     Folder
     C                   ELSE
     C     SECCMA        READE     ASECRC                                 51     Application
     C                   MOVE      ASUID         FSID
     C                   END
     C   51              LEAVE                                                   No S-types.
     C     FSID          SETLL     RSUBLST

     C     *IN52         DOUEQ     *ON                                          Read equal
     C     FSID          READE     RSUBLST                                52     Subscr list
     C   52              LEAVE

     C     SUBSID        CHAIN     RSUBSCR                            53
     C     *IN53         IFEQ      *OFF                                          Got Subs ID
     C     SUSER2        ANDEQ     PGMUSR
     C                   GOTO      MOVOBJ
     C                   END
     C                   ENDDO
     C                   ENDDO
      *                                                    ------------
     C     OBJTYP        IFEQ      'F'                                          FOLDER
     C                   MOVEL(P)  '*PUBLIC'     FSID                           ------------
     C                   MOVE      'U'           FSIDTY                          try *PUBLIC
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   END
      *                                                    ------------
     C     OBJTYP        IFEQ      'A'                                          APPLICATION
     C                   EXSR      USRSEC                                       ------------

     C     ALLOBJ        IFEQ      'Y'
     C                   MOVEL(P)  '*ALLOBJ'     FSID                           All Objects
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   END

     C                   MOVE(P)   USRCLS        FSID                           Security Ofr
     C                   MOVE      'C'           FSIDTY                         Class
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ

     C     SPLCTL        IFEQ      'Y'
     C     QSPLCT        ANDNE     'N'
     C                   MOVEL(P)  '*SPLCTL'     FSID                           SPOOL CTL
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   END

     C     SECADM        IFEQ      'Y'
     C                   MOVEL(P)  '*SECADM'     FSID                           Sec Admin
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   END

     C     JOBCTL        IFEQ      'Y'
     C                   MOVEL(P)  '*JOBCTL'     FSID                           Job Control
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   END

     C     SAVSYS        IFEQ      'Y'
     C                   MOVEL(P)  '*SAVSYS'     FSID                           Save System
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   END

     C     SERVIC        IFEQ      'Y'
     C                   MOVEL(P)  '*SERVIC'     FSID                           Service
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   END

     C     AUDIT         IFEQ      'Y'
     C                   MOVEL(P)  '*AUDIT'      FSID                           Audit
     C                   MOVE      'P'           FSIDTY                         Privileges
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ
     C                   END


     C     DFA(10)       IFNE      'Y'                                          Not Creator,
     C                   MOVEL(P)  '*PUBLIC'     FSID                            try *PUBLIC
     C                   MOVE      'U'           FSIDTY
     C                   EXSR      CHAINF
     C     *IN51         CABEQ     *OFF          MOVOBJ                         *PUB rec.
     C                   END
     C                   END
     C                   GOTO      ENDOBJ                                       No SECUR rec
      *>>>>
     C     MOVOBJ        TAG
     C                   SELECT                                                 ------------
     C     OBJTYP        WHENEQ    'A'                                          APPLICATION
     C     EXTSEC        IFNE      'Y'                                          ------------
     C     @POWER        ANDEQ     'Y'
     C                   MOVE      'Y'           ASCRT
     C                   END
     C                   MOVEA     APPSDS        OBJ
      *                                                    ------------
     C     OBJTYP        WHENEQ    'F'                                          FOLDER
     C                   MOVEA(P)  FLDSDS        OBJ                            ------------
     C                   Z-ADD     1             X                               If any 'Y's
     C     'Y'           LOOKUP    OBJ(X)                                 30     in OBJ,
     C     *IN30         IFEQ      *ON                                           put 'Y' in
     C                   MOVE      'Y'           OBJ(25)                         OBJ,25
     C                   ELSE
     C                   MOVE      'N'           OBJ(25)                         No Y's
     C                   END
     C                   ENDSL
     C     ENDOBJ        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHAINF        BEGSR
      *          Chain to FSECUR or ASECUR.

      * Folder   SECKYF =  FSOBJ  FSOBJL FSIDTY FSID
      *          SECCMP =  #FSOBJ #FSLIB #FSIDT
      * Applic   SECKYA =  FSOBJ         FSIDTY FSID
      *          SECCMA =  #FSOBJ        #FSIDT

     C     OBJTYP        IFEQ      'F'                                          Folder
     C     SECKYF        CHAIN     FSECRC                             51
     C     SECKYF        KLIST
     C                   KFLD                    FSOBJ
     C                   KFLD                    FSOBJL
     C                   KFLD                    FSIDTY
     C                   KFLD                    FSID
     C                   ELSE                                                   Application
     C     SECKYA        CHAIN     ASECRC                             51
     C     SECKYA        KLIST
     C                   KFLD                    FSOBJ
     C                   KFLD                    FSIDTY
     C                   KFLD                    FSID
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CKAUTL        BEGSR
      *          Check if user is on authorization list AUTLST.
      *          Return ONAUTL = '1'/'0'

     C                   MOVE      *ON           M1060A            1

     C                   CALL      'MAG1060A'
     C                   PARM      'LIST'        OPCODE           10
     C                   PARM                    AUTLST
     C                   PARM      '*LIBL'       AULIB            10
     C                   PARM      '*AUTL'       AUTYP            10
     C                   PARM                    AUUSER           10
     C                   PARM                    AUCNT             5 0
     C                   PARM                    AUENT            28
     C                   PARM                    AURTN             2

     C     AURTN         IFEQ      '20'
     C     AUCNT         ANDEQ     1
     C                   MOVE      *ON           ONAUTL            1
     C                   ELSE
     C                   MOVE      *OFF          ONAUTL
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     REPSEC        BEGSR
      *          Get Report Security

      *  Fill arrays:
      *               RDF  Reports Default, using *ALL for keys
      *               RSC  Specific report
      *               WRK  Combine DEF and RSC (If RSC=Y, use it)

      *    Example:            Opt 1     Opt 2    Opt 3   Opt 4  etc
      *               -----------------------------------------------
      *               RDF        Y         N        N      N
      *               RSC        Y         Y        Y      Y
      *    Results in:
      *               WRK        Y         Y        Y      Y

      * Any folder?
     C     OP            IFEQ      25                                           List it
     C     OBJNAM        ANDEQ     *BLANKS                                       fldr unknwn
     C                   MOVE      'Y'           ANYFLD            1
     C                   CLEAR                   #RLIBS
     C                   CLEAR                   #ILIBS
     C                   ELSE
     C                   MOVE      'N'           ANYFLD
     C                   END
      *>>>>
     C     TOPREP        TAG

      * If OP=25 and folder name is present, check the folder's
      * security before the report's to see if user is denied the fldr
     C     OP            IFEQ      25                                           List it
     C     OBJNAM        ANDNE     *BLANKS                                       have fldr
     C                   MOVE      'F'           OBJTYP
     C                   EXSR      OBJSEC

     C     RETURN        IFEQ      'N'                                          Fldr denied
     C     ANYFLD        IFEQ      'Y'
     C                   GOTO      BOTREP
     C                   ELSE
     C                   GOTO      ENDREP
     C                   END
     C                   END

     C                   MOVE      'R'           OBJTYP
     C                   END

/     * GET BIG5 KEYS FROM A BATCH/SPYNUMBER
/3208C                   MOVEL     RPTNAM        RPTKEY
/    C     RKNULL        IFEQ      X'00'
/    C     RKID          ANDEQ     'BATCHID'
/3208C     IDIR0         IFNE      'Y'                                          NOT OPENED YET
/    C                   MOVE      'Y'           IDIR0             1
/    C                   OPEN      MIMGDIR
/    C                   END
/    C     JOBNAM        CHAIN     IMGDIR0                            88
/    C     *IN88         IFEQ      *OFF
/    C                   MOVEL     IDDOCT        RPTNAM
/    C                   MOVE      *BLANKS       JOBNAM
/    C                   MOVE      *BLANKS       PGMNAM
/    C                   MOVE      *BLANKS       USRNAM
/    C                   MOVE      *BLANKS       USRDTA
/    C                   ELSE
/    C     RDIR7         IFNE      'Y'                                          NOT OPENED YET
/    C                   MOVE      'Y'           RDIR7             1
/    C                   OPEN      MRPTDIR7
/    C                   END
/    C     JOBNAM        CHAIN     RPTDIR7                            88
/    C     *IN88         IFEQ      *OFF
/    C                   MOVEL     FILNAM        RPTNAM
/    C                   MOVEL     PGMOPF        PGMNAM
/    C                   END
/    C                   END
/    C                   END

     C                   MOVE      RPTNAM        WREPNM                         Big 5
     C                   MOVE      JOBNAM        WJOBNM                          (DtaStr
     C                   MOVE      PGMNAM        WPGMNM                           REPORT)
     C                   MOVE      USRNAM        WUSRNM
     C                   MOVE      USRDTA        WUSRDT

     C     ANYFLD        IFEQ      'N'
     C                   EXSR      CHKMEM                                       Check memory
     C     FNDSEC        IFEQ      'Y'                                          if found
     C                   MOVE      WRK(OP)       RETURN
/9542c                   if        parms >= 14 and reqopt = 7
/    c                   movea     wrk           aut
/    c                   endif
     C                   GOTO      ENDREP
     C                   END
     C                   END

     C     RDFT          IFNE      'Y'
     C                   EXSR      RDEFLT                                       Load RDF
     C                   MOVE      'Y'           RDFT              1             (done)
     C                   END

     C                   EXSR      RSECR                                        Load RSC
     C                   EXSR      LODWRK                                       Load WRK
      *>>>>
     C     BOTREP        TAG
      * If we were called without a folder name and haven't gotten
      * access to the report, get a folder name and try it.  5/20/99
     C     ANYFLD        IFEQ      'Y'
     C     WRK(25)       ANDEQ     'N'
     C                   EXSR      NAMFLD                                       Name a fldr
     C     OBJNAM        IFNE      *BLANKS
     C                   GOTO      TOPREP                                       Try this fld
     C                   END
     C                   END

     C                   EXSR      LODMEM                                       Load memory
     C                   MOVE      WRK(OP)       RETURN

/9542c                   if        parms >= 14 and reqopt = 7
/    c                   movea     wrk           aut
/    c                   endif

     C     ENDREP        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     NAMFLD        BEGSR
      *          User does not have auth to Big5, but he might have
      *          auth to a folder file via an AS400 auth list.
      *          Retrieve the name of a folder containing this Big5.
      *          Input : KLBIG7 fields
      *          Output: OBJNAM OBJLIB  (Folder & library)

     C     DIROPN        IFEQ      ' '
     C                   MOVE      'Y'           DIROPN            1
     C                   OPEN      MIMGDI12
     C                   OPEN      MRPTDIR3
     C                   END

     C     #ILIBS        CABGT     0             @IMAGE                         Imgs,no rpts
      * Rpt Dir
     C     KLBIG7        SETGT     RPTDIR
     C     KLBIG7        KLIST
     C                   KFLD                    RPTNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMNAM
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
     C                   KFLD                    OBJNAM                         Folder
     C                   KFLD                    OBJLIB                         Folder lib

     C     KLBIG5        READE     RPTDIR                                 96
      * Nrf
     C     *IN96         IFEQ      *ON
     C     #RLIBS        CABEQ     0             @IMAGE                         Try image
     C                   GOTO      BOTRTV                                       Done...
     C                   END
      * Found rpt
     C                   ADD       1             #RLIBS            9 0
     C                   MOVE      FLDR          OBJNAM
     C                   MOVE      FLDRLB        OBJLIB
     C                   GOTO      ENDRTV
      *>>>>
     C     @IMAGE        TAG
     C     JOBNAM        IFNE      *BLANKS
     C     PGMNAM        ORNE      *BLANKS
     C     USRNAM        ORNE      *BLANKS
     C     USRDTA        ORNE      *BLANKS
     C                   MOVE      *ON           *IN96                          Not image

     C                   ELSE
     C     KLBIG3        SETGT     IMGDIR
     C     KLBIG3        KLIST
     C                   KFLD                    RPTNAM                         Doc type
     C                   KFLD                    OBJNAM                         Folder
     C                   KFLD                    OBJLIB                         Folder lib
     C     RPTNAM        READE     IMGDIR                                 96
      * Found img
     C     *IN96         IFEQ      *OFF                                         Nrf
     C                   ADD       1             #ILIBS            9 0
     C                   MOVE      IDFLD         OBJNAM
     C                   MOVE      IDFLIB        OBJLIB
     C                   END
     C                   END

      *>>>>
     C     BOTRTV        TAG
     C     *IN96         IFEQ      *ON                                          Nrf
     C                   CLEAR                   OBJNAM
     C                   CLEAR                   OBJLIB
     C                   END
     C     ENDRTV        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RDEFLT        BEGSR
      *          Load RDF, Reports Default array
      *            Old security: Load all N's.
      *            New security: Start all Y's, then *ALL RSECUR record

     C     EXTSEC        IFNE      'Y'                                          Old security
     C                   MOVE      'N'           RDF                             all N's
     C                   GOTO      ENDRDT
     C                   ENDIF
      *                                                    Start with
      * Default note security all 'Y's.
J2586 /free
J2586  NSD = *all'Y';
J2586 /end-free
     C                   MOVE      'Y'           RDF                             all Y's
     C                   MOVEL(P)  '*ALL'        SRNAM
     C                   MOVEL(P)  '*ALL'        SJNAM
     C                   MOVEL(P)  '*ALL'        SPNAM
     C                   MOVEL(P)  '*ALL'        SUNAM
     C                   MOVEL(P)  '*ALL'        SUDAT
      *-------------------
      * *ALL for this user
      *-------------------
     C                   MOVE      'U'           SSIDTY
     C                   MOVE      PGMUSR        SUSER

J2586c                   callp     setNoteSecArr

      *          KLRPT7 =  SRNAM SJNAM SPNAM SUNAM SUDAT SSIDTY SUSER
     C     KLRPT7        CHAIN     SECRC                              51
     C     *IN51         IFEQ      *OFF
     C                   EXSR      RFILDF
     C                   GOTO      ENDRDT
     C                   END
      *------------------------------
      * *ALL for this user's group(s)
      *------------------------------
     C     PRIGRP        IFNE      '*NONE'
     C                   MOVE      ' '           @UZGRP
     C                   MOVE      'G'           SSIDTY
     C                   MOVE      PRIGRP        SUSER                          Primary grup
     C     KLRPT7        CHAIN     SECRC                              51
     C  N51              MOVE      'Y'           @UZGRP


     C     #SG           IFGT      0
     C   51              MOVE      'Y'           HOLD
     C                   EXSR      SUPGRR                                       Supplemental
     C                   END                                                     group(s).

     C     @UZGRP        IFEQ      'Y'
     C                   EXSR      RFILDF
     C                   GOTO      ENDRDT
     C                   END
     C                   END
      *-----------------------------------
      * *ALL for this user's subscriptions
      *-----------------------------------
     C                   MOVE      'S'           SSIDTY

      *          KLRPT6 =  SRNAM SJNAM SPNAM SUNAM SUDAT SSIDTY
     C     KLRPT6        SETLL     SECRC

     C     *IN51         DOUEQ     *ON
     C     KLRPT6        READE     SECRC                                  51
     C   51              LEAVE

     C     SUSER         CHAIN     RSUBSCR                            53         Subscriber
     C     *IN53         IFEQ      *OFF
     C     SUSER2        ANDEQ     PGMUSR
     C                   EXSR      RFILDF
J2586C                   callp     setNoteSecArr(NOTE_SEC_ARR_DFT)
     C                   GOTO      ENDRDT
     C                   ENDIF

     C     SUSER         SETLL     RSUBLST
     C     *IN52         DOUEQ     *ON
     C     SUSER         READE     RSUBLST                                52     Subscr list
     C   52              LEAVE

     C     SUBSID        CHAIN     RSUBSCR                            53
     C     *IN53         IFEQ      *OFF
     C     SUSER2        ANDEQ     PGMUSR
     C                   EXSR      RFILDF
J2586C                   callp     setNoteSecArr(NOTE_SEC_ARR_DFT)
     C                   GOTO      ENDRDT
     C                   END
     C                   ENDDO
     C                   ENDDO
      *-----------------
      * *ALL for *PUBLIC
      *-----------------
     C                   MOVE      'U'           SSIDTY
     C                   MOVEL(P)  '*PUBLIC'     SUSER

      *          KLRPT7 = SRNAM SJNAM SPNAM SUNAM SUDAT SSIDTY SUSER
     C     KLRPT7        CHAIN     SECRC                              51
     C     *IN51         CASEQ     *OFF          RFILDF
     C                   ENDCS
J2586C                   callp     setNoteSecArr(NOTE_SEC_ARR_DFT)
     C     ENDRDT        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RFILDF        BEGSR
      *          Fill RDF, Reports Default Array (for this user)
     C                   MOVEA     RPTSDS        RDF                             1-13
     C                   MOVEA     *ALL'N'       RDF(14)                         Ns to end.
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RSECR         BEGSR
      *          Security by Report's Big5

      * If "Old Security" (ExtSec='N'), Power users get all auths.
     C     EXTSEC        IFEQ      'N'
     C     @POWER        ANDEQ     'Y'
     C                   MOVE      'Y'           RSC                             all Ys.
J2586C                   eval      NSC = *all'Y'
     C                   GOTO      ENDRSC
     C                   END

     C     KLBIG5        CHAIN     RMNTRC                             30
     C     KLBIG5        KLIST
     C                   KFLD                    RPTNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMNAM
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA

      * Load all of the subscriber lists for this user into memory.
/7588c                   if        subcnt < 0
/    c                   eval      subcnt = 0
/    c                   eval      subP = mm_alloc(1)
/8483c                   eval      wrkusr = pgmusr
/    c                   exsr      chksublst
/    c                   if        not %open(rsubscr2)
/    c                   open      rsubscr2
/    c                   endif
/    c     pgmusr        setll     rsubscr2
/    c                   if        %found
/    c                   dou       %eof
/    c     pgmusr        reade     rsubscr2
/    c                   if        %found and subsid <> suser
/    c                   eval      wrkusr = subsid
/    c                   exsr      chksublst
/    c                   endif
/    c                   enddo
/    c                   endif
/7588c                   endif

      * RSec = Y required to enforce security.
     c     RSEC          IFNE      'Y'                                           Disabled,
     c     *IN30         OREQ      *ON
/8699c                   eval      nodist = '1'
/    c                   if        ldstyn = 'Y'
/    c                   exsr      chkdst
/    c                   if        dstyn = 'Y'
/    c                   eval      nodist = '0'
/    c                   endif
/    c                   endif
/    c                   if        nodist
     C                   MOVE      'Y'           RSC                             all Ys.
     C                   GOTO      ENDRSC
/8699c                   endif
     C                   END
      * RSecur is used by Old and New Security.
      * Get RSecur record for this report in priority:
      *  User, Group(s), AuthList, Subscriptions, *PUBLIC user.

     C                   CLEAR                   RSC
     C                   MOVE      RPTNAM        SRNAM
     C                   MOVE      JOBNAM        SJNAM
     C                   MOVE      PGMNAM        SPNAM
     C                   MOVE      USRNAM        SUNAM
     C                   MOVE      USRDTA        SUDAT
      * User
     C                   MOVE      'U'           SSIDTY                         (U)ser name
     C                   MOVE      PGMUSR        SUSER

      *          KLRPT7 =  SRNAM SJNAM SPNAM SUNAM SUDAT SSIDTY SUSER
     C     KLRPT7        CHAIN     SECRC                              51

     C     *IN51         IFEQ      *OFF
     C                   EXSR      RFILSC                                        Got it
J2586C                   callp     setNoteSecArr(NOTE_SEC_ARR_ACT)
     C                   GOTO      BOTRSC
     C                   END

      * Group(s)
     C     PRIGRP        IFNE      '*NONE'
     C                   MOVE      ' '           @UZGRP
     C                   MOVE      'G'           SSIDTY                         (G)roup
     C                   MOVE      PRIGRP        SUSER                           Primary
      *          KLRPT7 = SRNAM SJNAM SPNAM SUNAM SUDAT SSIDTY SUSER
     C     KLRPT7        CHAIN     SECRC                              51
     C  N51              MOVE      'Y'           @UZGRP
     C     #SG           IFGT      0
     C   51              MOVE      ' '           HOLD
     C                   EXSR      SUPGRR                                        Suppl grps
     C                   END
     C     @UZGRP        IFEQ      'Y'
     C                   EXSR      RFILSC                                         Got it
     C                   GOTO      BOTRSC
     C                   END
     C                   END

      * Auth List, defined for the folder
     C     OBJNAM        IFNE      *BLANKS                                      W/FOLDER
     C     OBJNAM        CAT       OBJLIB        OBJECT                         FLDR||Libr
     C     EXTSEC        IFEQ      'Y'                                          Extended sec
     C                   MOVEL(P)  '*CURRENT'    SRAUSR
     C                   ELSE                                                   Old sec
     C                   MOVE      PGMUSR        SRAUSR                          User Name
     C                   END

      * Get user's auth to Object (AUTLST)
     C                   RESET                   AUTLST
     C                   CALL      'QSYRUSRA'                           49
     C                   PARM                    SRAVAR
     C                   PARM                    SRALEN
     C                   PARM                    SRAFRM
     C                   PARM                    SRAUSR           10            User
     C                   PARM      OBJECT        SRAOBJ           20            Object
     C                   PARM      '*FILE'       SRATYP           10            Object type
     C                   PARM                    RETCD                          Error Code
     C                   END

     C     AUTLST        IFNE      '*NONE'
     C                   MOVE      'A'           SSIDTY                         (A)uth list
     C                   MOVE      AUTLST        SUSER
     C     KLRPT7        CHAIN     SECRC                              51
      *          KLRPT7 =  SRNAM SJNAM SPNAM SUNAM SUDAT SSIDTY SUSER

     C     *IN51         IFEQ      *OFF
     C                   EXSR      RFILSC                                        Got it.
     C                   GOTO      BOTRSC
     C                   END
     C                   END

      * Subscriber name
      * Subscriber list


     C                   MOVE      'S'           SSIDTY                         (S)ubscr
     c     KLRPT6        SETLL     SECRC                                  51
      *          KLRPT6 =  SRNAM SJNAM SPNAM SUNAM SUDAT SSIDTY

     C     *IN51         DOUEQ     *ON
     C     KLRPT6        READE     SECRC                                  51
     C   51              LEAVE

     C     SUSER         CHAIN     RSUBSCR                            53
     C     *IN53         IFEQ      *OFF
     C     SUSER2        ANDEQ     PGMUSR
     C                   EXSR      RFILSC                                         Got it.
     C                   GOTO      BOTRSC
     C                   END

      * If user is part of a list, set subcriber id to current program user.
/7588c                   if        subcnt > 0 and %scan(suser:%str(subP)) > 0
T4443c                   eval      sublid = suser
/    c     sublid        setll     rsublst
/    c     sublid        reade     rsublst
/    c                   dow       not %eof
     C     SUBSID        CHAIN     RSUBSCR                            53
     C     *IN53         IFEQ      *OFF
     C     SUSER2        ANDEQ     PGMUSR
     C                   EXSR      RFILSC                                         Got it.
     C                   GOTO      BOTRSC
     C                   END
T4443c     sublid        reade     rsublst
/    c                   enddo
/7588c                   endif

     C                   ENDDO

      * *PUBLIC
     C                   MOVE      'U'           SSIDTY
     C                   MOVEL(P)  '*PUBLIC'     SUSER
     C     KLRPT7        CHAIN     SECRC                              51
     C     *IN51         CASEQ     *OFF          RFILSC                           Got it.
     C                   ENDCS

      *>>>>
     C     BOTRSC        TAG
      * If:   Distribution is enabled in SysDft,
      *       Reading has been denied by RSECUR,
      *       User is on distribution for this report type
      * Then: Let the user list, read and print it.
     C     LDSTYN        IFEQ      'Y'                                          (SysDft)
     C     RSC(1)        ANDNE     'Y'                                          Read denied
     C                   EXSR      CHKDST                                       On Dist?
     C     DSTYN         IFEQ      'Y'                                           Yes,
     C                   MOVE      'Y'           RSC(1)                           Read
     C                   MOVE      'Y'           RSC(12)                          Print
     C                   MOVE      'Y'           RSC(25)                          List
/5546c                   if        parms > 15
/    c                   eval      SecOvr = 'DST'
/    c                   end
     C                   END
     C                   END
     C     endrsc        tag
J1559 /free
/      if extsec <> 'Y' and @power <> 'Y';
/        rsc(2) = 'N';
/      endif;
/     /end-free
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/8483c     chksublst     begsr
/    c     wrkusr        setll     rsublst2
/    c                   if        %equal
/    c     wrkusr        reade     rsublst2
/9364c                   dow       not %eof
/8483c                   eval      subcnt = subcnt + 1
/    c                   callp     mm_realloc(subP:%len(%str(subP))+nameSz+1)
/    c                   eval      %str(subP+(subcnt*nameSz-nameSz):nameSz+1) =
/    c                             sublid
/9364c     wrkusr        reade     rsublst2
/8483c                   enddo
/    c                   endif
/    c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RFILSC        BEGSR
      *          Fill Report Security array: work subr for subr RSECR
     C                   MOVEA     RPTSDS        RSC                            1-13
/7563c                   if        extsec = 'N' and sread = 'N' and sdel = 'N'
/    c                             and sprnt = 'N'
/    c                   eval      %str(%addr(rsc):13) = *all'N'
/    c                   endif
     C                   MOVEA     NONE          RSC(14)                        Ns to end
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKDST        BEGSR
      *          Set DSTYN=Y/N, user subscribes to report type as:
      *          -> an individual               - Pass 1
      *          -> a member of an AS400 group  - Pass 2
      *          -> indv/group on SpyView subscription list- Inner loop

     C                   MOVE      'N'           DSTYN             1
     C     CKTYPE        IFNE      'S'
     C     KLBIG5        CHAIN     RMNTRC                             95        Need RTYPID
     C   95              GOTO      ENDDST
     C                   END

      * Open files
     C     DSTOPN        IFEQ      ' '
     C                   MOVE      'Y'           DSTOPN            1
     C                   OPEN      RDSTDEF
/8483c                   if        not %open(rsubscr2)
     C                   OPEN      RSUBSCR2
/8483c                   endif
     C                   END

     C                   MOVE      PGMUSR        APIUSR                         Individual
     C     #SG           ADD       2             PASSES                         Suppl+Gr+Ind
      *-----------
      * Outer loop by Individual (pass 1) Groups (passes 2+)
      *-----------
     C                   DO        PASSES        PASS#

     C     PASS#         IFEQ      2                                            Pri Group
     C     GRPPRF        CABEQ     '*NONE'       ENDDST
     C     GRPPRF        CABEQ     *BLANK        ENDDST
     C                   MOVE      GRPPRF        APIUSR
     C                   END

     C     PASS#         IFGT      2                                            Sup Groups
     C     PASS#         SUB       2             SG#
     C                   MOVE      SGP(SG#)      APIUSR
     C                   END
      *-----------
      * Inner loop by subscriber name (SUBSID)
      *-----------
     C     APIUSR        SETLL     RSUBSCR2                               96     Rec found
     C  N96              ITER

     C                   DO        *HIVAL
     C     APIUSR        READE     RSUBSCR2                               98
     C   98              LEAVE
/7588c     klsubs        setll     rdstdef
     C     KLSUBS        KLIST                                                   on dist?
     C                   KFLD                    SUBSID
     C                   KFLD                    RTYPID
/7588c                   if        %equal
     C                   MOVE      'Y'           DSTYN                          Yes,
     C                   GOTO      ENDDST                                        done.
     C                   END
      *-----------
      * Inner loop by SpyView Subscriber List
      *-----------
     C     SUBSID        SETLL     RSUBLST2                               96     Rec found
     C  N96              ITER

/7588c                   if        subcnt > 0
/    c                   do        subcnt        subx
/    c                   eval      sublid = %str(subP+subx*namesz-namesz:namesz)
/    c     klslst        setll     rdstdef                                      List on
     C     KLSLST        KLIST                                                   dist?
     C                   KFLD                    SUBLID
     C                   KFLD                    RTYPID
/7588c                   if        %equal
     C                   MOVE      'Y'           DSTYN                          Yes,
     C                   GOTO      ENDDST                                        exit.
     C                   END
/7588c                   enddo
/7588c                   endif

     C                   ENDDO
     C                   ENDDO
     C     ENDDST        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SEGSEC        BEGSR
      *          Set RETURN=Y/N, user subscribes to report SEGMENT as:
      *          -> an individual               - Pass 1
      *          -> a member of an AS400 group  - Pass 2
      *          -> indv/group on SpyView subscription list- Inner loop
      *          Called by: SpyCsRpt, SpyCsSeg, WrkRsg, WrkRsL etc.

      * If segment name is blank, use SR CHKDST instead of this.
      * It returns DSTYN if user gets any segment of the report.

     C     OBJLIB        IFEQ      *BLANK
     C                   MOVE      OBJNAM        RTYPID
     C                   EXSR      CHKDST
     C                   MOVE      DSTYN         RETURN
     C                   GOTO      ENDSEG
     C                   END

     C                   MOVE      'N'           RETURN
     C                   MOVE      OBJNAM        SHREPT           10
     C                   MOVE      OBJLIB        SHSEG            10
      * Open files
     C     DSTOPN        IFEQ      ' '
     C                   MOVE      'Y'           DSTOPN            1
     C                   OPEN      RDSTDEF
     C                   OPEN      RSUBSCR2
     C                   END

     C                   MOVE      PGMUSR        APIUSR                         Individual
     C     #SG           ADD       2             PASSES                         Suppl+Gr+Ind
      *-----------
      * Outer loop by Individual (pass 1) Groups (passes 2+)
      *-----------

     C                   DO        PASSES        PASS#

     C     PASS#         IFEQ      2                                            Pri Group
     C     GRPPRF        CABEQ     '*NONE'       ENDSEG
     C     GRPPRF        CABEQ     *BLANK        ENDSEG
     C                   MOVE      GRPPRF        APIUSR
     C                   END

     C     PASS#         IFGT      2                                            Sup Groups
     C     PASS#         SUB       2             SG#
     C                   MOVE      SGP(SG#)      APIUSR
     C                   END
      *-----------
      * Inner loop by subscriber name (SUBSID)
      *-----------
     C     APIUSR        SETLL     RSUBSCR2                               96     Rec found
     C  N96              ITER

     C                   DO        *HIVAL
     C     APIUSR        READE     RSUBSCR2                               98
     C   98              LEAVE
     C     KLSUB3        CHAIN     DSTDEF                             93        Subscriber
     C     KLSUB3        KLIST                                                   on dist?
     C                   KFLD                    SUBSID
     C                   KFLD                    SHREPT
     C                   KFLD                    SHSEG
     C     *IN93         IFEQ      *OFF
     C                   MOVE      'Y'           RETURN                         Yes,
     C                   GOTO      ENDSEG                                        done.
     C                   END
      *-----------
      * Inner loop by SpyView Subscriber List
      *-----------
     C     SUBSID        SETLL     RSUBLST2                               96     Rec found
     C  N96              ITER

     C                   DO        *HIVAL
     C     SUBSID        READE     RSUBLST2                               98
     C   98              LEAVE
     C     KLSLS3        CHAIN     DSTDEF                             93        List on
     C     KLSLS3        KLIST                                                   dist?
     C                   KFLD                    SUBLID
     C                   KFLD                    SHREPT
     C                   KFLD                    SHSEG
     C     *IN93         IFEQ      *OFF
     C                   MOVE      'Y'           RETURN                         Yes,
     C                   GOTO      ENDSEG                                        exit.
     C                   END
     C                   ENDDO
     C                   ENDDO
     C                   ENDDO
     C     ENDSEG        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

     C                   MOVE      CALPGM        BEGPGM           10
     C                   IN        SYSDFT                                       Defaults
     C     APPSEC        IFEQ      'Y'
     C                   OPEN      ASECUR2
     C                   END
     C     EXTSEC        IFEQ      'Y'
     C                   OPEN      FSECUR2
     C                   END

     C                   CALL      'QSYRUSRI'                           49      Get info
     C                   PARM                    UI0200                          about user:
     C                   PARM                    URILEN                          Class,Priv
     C                   PARM                    URIFRM                          GrpPrf.
     C                   PARM      '*CURRENT'    URIUSR                         User Name
     C                   PARM                    RETCD                          Error Code

     C     *IN49         IFEQ      *ON
     C                   CLEAR                   USRCLS                         User class
     C                   CLEAR                   ALLOBJ                         All Obj auth
     C                   CLEAR                   SPLCTL                         Spool contrl
     C                   CLEAR                   GRPPRF                         Grp profile
     C                   END

     C                   MOVEL     GRPPRF        PRIGRP           10            Save GRPPRF
     C                   MOVEA     SGPFLD        SGP                            Suppl grps

     C                   Z-ADD     0             #SG               3 0          0 SuppGrps
     C     GRPPRF        IFNE      '*NONE'
     C                   CALL      'MAG103R'                            49      Get OS/400
     C                   PARM                    OS4VRM            6             VxRxMx
     C                   MOVEL     OS4VRM        OS4VR             4

     C     OS4VR         IFGE      'V3R1'                                       If RiscBox
     C     4             SUBST     UI0200:101    ALFA4                           load #SG
     C                   Z-ADD     BIN9          #SG                             (#SupGrps)
     C                   END
     C                   END

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
     C     M1060A        IFEQ      *ON
     C                   CALL      'MAG1060A'
     C                   PARM      'QUIT'        OPCODE           10
     C                   ENDIF
/8483c                   callp(e)  mm_free(subP:0)
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODWRK        BEGSR
      *          Build the WRK array

     C                   MOVE      'N'           WRK                              All Ns.

      * FOLDER or APP =================================================
     C                   SELECT
     C     OBJTYP        WHENEQ    'F'
     C     OBJTYP        OREQ      'A'

     C     OBJTYP        IFEQ      'F'
     C                   MOVEA(P)  DEF           DEFCHK           65
     C                   ELSE
     C                   MOVEA(P)  DFA           DEFCHK
     C                   END

     C                   MOVEA(P)  OBJ           OBJCHK           65

     C     DEFCHK        IFEQ      *BLANKS                                      All DEF
     C     OBJCHK        ANDEQ     *BLANKS                                       and OBJ
     C                   GOTO      ADFMEM                                        empty.
     C                   END

     C                   DO        65            #                 3 0
     C     OBJCHK        IFNE      *BLANKS
     C     OVR(#)        IFNE      'N'
     C     OBJ(#)        ANDEQ     'Y'
     C                   MOVE      'Y'           WRK(#)                         Use OBJ.
     C                   END
     C                   ITER
     C                   END

     C     DEFCHK        IFNE      *BLANKS
     C     OVR(#)        ANDNE     'N'

     C     OBJTYP        IFEQ      'F'
     C     DEF(#)        ANDEQ     'Y'
     C     OBJTYP        OREQ      'A'
     C     DFA(#)        ANDEQ     'Y'
     C                   MOVE      'Y'           WRK(#)                         Use DEF/DFA.
     C                   END
     C                   END
     C                   ENDDO
      *>>>>
     C     ADFMEM        TAG
      *          If an auth (1-10) is granted, grant List auth (25)
     C                   Z-ADD     1             #
     C     'Y'           LOOKUP    WRK(#)                                 40     EQ

     C     *IN40         IFEQ      *ON
     C     #             ANDLE     10
     C                   MOVE      'Y'           WRK(25)
     C                   ELSE
     C                   MOVE      'N'           WRK(25)
     C                   END

      * REPORT ========================================================
     C     OBJTYP        WHENEQ    'R'
     C                   MOVEA(P)  RDF           DEFCHK
     C                   MOVEA(P)  RSC           OBJCHK

     C     DEFCHK        IFNE      *BLANKS
     C     OBJCHK        ORNE      *BLANKS
     C                   DO        25            #
/2083C                   SELECT
/2083C     RSC(#)        WHENNE    ' '                                          If RSecur
/2083C                   MOVE      RSC(#)        WRK(#)                          rec, use it
/2083C     RDF(#)        WHENNE    ' '
/2083C                   MOVE      RDF(#)        WRK(#)
/2083C                   ENDSL
     C                   ENDDO
     C                   END

      *          If an auth (1-13) is granted, grant List auth (#25)
     C                   Z-ADD     1             #
     C     'Y'           LOOKUP    WRK(#)                                 40     EQ
     C     *IN40         IFEQ      *ON
     C     #             ANDLE     13
     C                   MOVE      'Y'           WRK(25)
     C                   ELSE
     C                   MOVE      'N'           WRK(25)
     C                   END
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LODMEM        BEGSR
      *          Save WRK in program memory.
      *          Cache the security values so costly DASD seeks
      *          are reduced when redundant requests are made.

     C                   SELECT
      * Folder
     C     OBJTYP        WHENEQ    'F'
     C                   ADD       1             FM                3 0
     C     FM            IFGT      10
     C                   Z-ADD     1             FM
     C                   END
     C                   MOVE      OBJECT        FMF(FM)                         Name
     C                   MOVEA     WRK           ALFA25           25             Values
     C                   MOVEA     ALFA25        FMV(FM)
      * Report
     C     OBJTYP        WHENEQ    'R'
     C                   ADD       1             RM                3 0
     C     RM            IFGT      12
     C                   Z-ADD     1             RM
     C                   END
     C                   MOVEA     REPORT        RMF(RM)                         Name
     C                   MOVEA     WRK           ALFA25                          Values
     C                   MOVEA     ALFA25        RMV(RM)
      * Load data struct REPORT
      * * * Already        MOVELRPTNAM    WREPNM
      * * *  there         MOVELJOBNAM    WJOBNM
      * * *                MOVELPGMNAM    WPGMNM
      * * *                MOVELUSRNAM    WUSRNM
      * * *                MOVELUSRDTA    WUSRDT

      * Applic
     C     OBJTYP        WHENEQ    'A'
     C                   ADD       1             AM                3 0
     C     AM            IFGT      10
     C                   Z-ADD     1             AM
     C                   END
     C                   MOVE      OBJECT        AMF(AM)                          Name
     C                   MOVEA     WRK           AMV(AM)                          Values
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKMEM        BEGSR
      *          If memory values are loaded, put into WRK

     C                   MOVE      'N'           FNDSEC            1
     C                   MOVE      'N'           WRK
     C                   Z-ADD     1             #
     C                   SELECT
      * Folder
     C     OBJTYP        WHENEQ    'F'
     C     OBJECT        LOOKUP    FMF(#)                                 60     In memory?
     C     *IN60         IFEQ      *ON
     C                   MOVE      'Y'           FNDSEC                           Yes
     C                   MOVEA     FMV(#)        ALFA25                           Values
     C                   MOVEA     ALFA25        WRK
     C                   END
      * Report
     C     OBJTYP        WHENEQ    'R'
     C     REPORT        LOOKUP    RMF(#)                                 60     EQ
     C     *IN60         IFEQ      *ON
     C                   MOVE      'Y'           FNDSEC
     C                   MOVEA     RMV(#)        ALFA25
     C                   MOVEA     ALFA25        WRK
     C                   END
      * Appl
     C     OBJTYP        WHENEQ    'A'
     C     OBJECT        LOOKUP    AMF(#)                                 60     EQ
     C     *IN60         IFEQ      *ON
     C                   MOVE      'Y'           FNDSEC
     C                   MOVEA     AMV(#)        WRK
     C                   END
     C                   ENDSL
     C                   ENDSR
      *================================================================
      *================================================================

     C     SECCMP        KLIST                                                  Compare key
     C                   KFLD                    #FSOBJ
     C                   KFLD                    #FSLIB
     C                   KFLD                    #FSIDT

     C     SECCMA        KLIST                                                  Compare key
     C                   KFLD                    #FSOBJ
     C                   KFLD                    #FSIDT

     C     KLRPT7        KLIST
     C                   KFLD                    SRNAM
     C                   KFLD                    SJNAM
     C                   KFLD                    SPNAM
     C                   KFLD                    SUNAM
     C                   KFLD                    SUDAT
     C                   KFLD                    SSIDTY
     C                   KFLD                    SUSER

     C     KLRPT6        KLIST
     C                   KFLD                    SRNAM
     C                   KFLD                    SJNAM
     C                   KFLD                    SPNAM
     C                   KFLD                    SUNAM
     C                   KFLD                    SUDAT
     C                   KFLD                    SSIDTY

J2586
J2586 * Set note security arrays
J2586p setNoteSecArr   b
J2586 /free
J2586  for noteSecNdx = 1 to %elem(noteTypes);
J2586    chain (rtypid:suser:ssidty:noteTypes(noteSecNdx)) nsecur;
J2586    if %found;
J2586      select;
J2586        when dftOrActual = NOTE_SEC_ARR_DFT;
J2586          NSD(noteSecNdx) = noteSecDta;
J2586        when dftOrActual = NOTE_SEC_ARR_ACTUAL;
J2586          NSC(noteSecNdx) = noteSecDta;
J2586      endsl;
J2586    else;
J2586      leave;
J2586    endif;
J2586  endfor;
J2586 /end-free
** BCHPGM  programs to keep J.Q. Public away from                   119
ENDSTGMIR MIRSPYSTG SPYDST    STRBAK    STRCLN    STRMON    STRORG    STRSTGMIR
**ctdata noteTypes
au
bl
bo
hi
rs
sn
tn

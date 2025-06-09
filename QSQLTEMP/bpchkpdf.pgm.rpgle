       ctl-opt main(main) bnddir('QUSAPIBD':'SPYBNDDIR':'QC2LE');
       ctl-opt dftactgrp(*no) actgrp(*new);

       //  This utility will read all native PDF report directory records,
       //  and attempt to determine if the document file name and size matches
       //  the fileID resolved name on the IFS matches.
       //
       //  There is an issue when moving from one system to another where the fileID
       //  can be in-use by another document or the fileID's are reordered when
       //  moving IFS files to a new system.

      *copy @ifsio
      * Integrated File System I/O API Constants and Prototypes

J5551 * 04-06-17 PLR Add lseek64() for large file support and archive.
/6547 * 03-12-08 EPG Add the prototype to remove a directory

      * File Access Modes (fcntl.h)
      * Open for reading only
     d O_RDONLY        C                   1
      * Open for writing only
     d O_WRONLY        C                   2
      * Open for reading and writing
     d O_RDWR          C                   4

      * oflag Values (fcntl.h)
      * Create file if it doesn't exist (00010)
     d O_CREAT         C                   8
      * Exclusive use flag (00020)
     d O_EXCL          C                   16
      * Truncate flag (00100)
     d O_TRUNC         C                   64

      * File Status Flags (fcntl.h)
      * No delay...return EAGAIN if it will block (00200)
     d O_NOBLOCK       C                   128
      * Set append mode (00400)
     d O_APPEND        C                   256
      * Codepage argument used (040000000)
     d O_CODEPAGE      C                   8388608
      * Text data flag (0100000000)
     d O_TEXTDATA      C                   16777216

      * oflag Share Mode Values (fcntl.h)
      * Share with readers only (000000200000)
     d O_SHARE_RD      C                   65536
      * Share with writers only (000000400000)
     d O_SHARE_WR      C                   131072
      * Share with readers and writers (000001000000)
     d O_SHARE_RW      C                   262144
      * Share with neither readers and writers (000002000000)
     d O_SHARE_NO      C                   524288

      * File Mode constants (sys/stat.h)
      * Read for owner
     d S_IRUSR         C                   256
      * Write for owner
     d S_IWUSR         C                   128
      * Execute and Search for owner
     d S_IXUSR         C                   64
      * Read, Write, Execute for owner
     d S_IRWXU         C                   448
      * Read for group
     d S_IRGRP         C                   32
      * Write for group
     d S_IWGRP         C                   16
      * Execute and Search for group
     d S_IXGRP         C                   8
      * Read, Write, Execute for group
     d S_IRWXG         C                   56
      * Read for other
     d S_IROTH         C                   4
      * Write for other
     d S_IWOTH         C                   2
      * Execute and Search for other
     d S_IXOTH         C                   1
      * Read, Write, Execute for other
     d S_IRWXO         C                   7

      * Constants for lseek (unistd.h)
      * Set to given position
     d SEEK_SET        C                   0
      * Seek relative to current position
     d SEEK_CUR        C                   1
      * Seek relative to end of file
     d SEEK_END        C                   2

      * Constants for access (unistd.h)
      * Test for read permission
     d r_ok            C                   4
      * Test for write permission
     d w_ok            C                   2
      * Test for execute or search permission
     d x_ok            C                   1
      * Test for existence of a file
     d f_ok            C                   0

      * Rename file
     d rename          PR            10i 0 extproc('rename')
     d  path                      32767a   options(*varsize)
     d  pathto                    32767a   options(*varsize)

      * UnLink file
     d unlink          PR            10i 0 extproc('unlink')
     d  path                      32767a   options(*varsize)

      * Open File
     d open            PR            10i 0 extproc('open64')
     d  path                      32767a   options(*varsize)
     d  oflag                        10i 0 value
     d  mode                         10u 0 value options(*nopass)
     d  codepage                     10u 0 value options(*nopass)

      * Close File
     d close           PR            10i 0 extproc('close')
     d  fildes                       10i 0 value

      * Read from Descriptor
     d read            PR            10i 0 extproc('read')
     d  fildes                       10i 0 value
     d  buf                       32767a   options(*varsize)
     d  nbyte                        10u 0 value

      * Write to Descriptor
     d write           PR            10i 0 extproc('write')
     d  fildes                       10i 0 value
     d  buf                       32767a   options(*varsize)
     d  nbyte                        10u 0 value

      * Determine File Accessibility
     d access          PR            10i 0 extproc('access')
     d  path                      32767a   options(*varsize)
     d  amode                        10u 0 value

      * Set File Read/Write Offset
     d lseek           PR            10i 0 extproc('lseek')
     d  fildes                       10i 0 value
     d  offset                       10i 0 value
     d  whence                       10i 0 value

J5551d lseek64         PR            20i 0 extproc('lseek64')
J5551d  fildes                       10i 0 value
J5551d  offset                       20i 0 value
J5551d  whence                       10i 0 value

      * Get File Information by Descriptor
     d fstat           PR            10i 0 extproc('fstat')
     d  fildes                       10i 0 value
     d  stat_ds                        *   value

      * Get File Information by path
     d stat            PR            10i 0 extproc('stat64')
     d                                 *   value
     d  stat_ds                        *   value

      * Get errno value
     d errno           S             10i 0 based(p_errno)
     d GetErrno        PR              *   extproc('__errno')

      * Set Pointer to Run-Time Error Message
     d errstr          S           1024a   based(p_errstr)
     d strerror        PR              *   extproc('strerror')
     d  errno                        10i 0 value

      * Make directory
     d mkdir           PR            10i 0 ExtProc('mkdir')
     d  path                      32767a   options(*varsize) const
     d  mode                         10u 0 value

/6547 * Remove directory
/    d rmdir           pr            10i 0 ExtProc('rmdir')
/    d  pPath                          *   value options(*string)

      * Open directory
     DOpenDir          PR              *   ExtProc('opendir')
     D                                 *   Value

      * Read directory
     DReadDir          PR              *   ExtProc('readdir')
     D                                 *   Value

     dRewindDir        pr                  extproc('rewinddir')
     d dirHandle                       *   value

      * Close directory
     DCloseDir         PR            10I 0 ExtProc('closedir')
     D                                 *   Value

      * Directory entry structure
     d direntLong      ds                  qualified
     d  reserved1                     8
     d  fileID                       16
     d  lenEntry                     10i 0
     d  reserved2                    12
     d  nlsInfo                      12
     d  lenName                      10i 0
     d  fileName                    640

      * Change owner
     d chown           PR            10i 0 extproc('chown')
     d  path                      32767a   options(*varsize) const
     d  owner                        10u 0 value
     d  group                        10u 0 value

      * Prototype for function "localtime"
     d localtime       PR              *   extproc('localtime')
     d                                 *   value options(*nopass)

      * stat structure (sys/stat.h)
     d stat_ds         DS
     d  st_mode                      10u 0
     d  st_ino                       10u 0
     d  st_nlink                      5u 0
     d  st_pad1                       2a
     d  st_uid                       10u 0
     d  st_gid                       10u 0
     d  st_size                      10i 0
     d  st_atime                     10i 0
     d  st_mtime                     10i 0
     d  st_ctime                     10i 0
     d  st_dev                       10u 0
     d  st_blksize                   10u 0
     d  st_alcsize                   10u 0
     d  st_objtype                   11a
     d  st_pad2                       1a
     d  st_codepag                    5u 0
     d  st_rsv1                      62a
     d  st_ino_gen                   10u 0

     dlcltimptr                        *
     dlcltime          DS           100    based(lcltimptr)
     d  lcl_sec                1      4B 0
     d  lcl_min                5      8B 0
     d  lcl_hou                9     12B 0
     d  lcl_day               13     16B 0
     d  lcl_mon               17     20B 0
     d  lcl_yea               21     24B 0

     d getPath         pr              *   extproc('Qp0lGetPathFromFileID')
     d  pathResult                     *   value
     d  sizeResult                   10i 0 value
     d  fileID                         *   value

     d ifsfopen        pr              *   extproc('_C_IFS_fopen')
     d  path                           *   value options(*string)
     d  mode                           *   value options(*string)

     d ifsfgets        pr              *   extproc('_C_IFS_fgets')
     d  line                           *   value
     d  bytes2Read                   10i 0 value
     d  fileHandle                     *   value

     d ifsfread        pr            10i 0 extproc('_C_IFS_fread')
     d  buffer                         *   value
     d  size                         10i 0 value
     d  count                        10i 0 value
     d  fildHandle                     *   value

     d ifsfwrite       pr            10i 0 extproc('_C_IFS_fwrite')
     d  buffer                         *   value
     d  size                         10i 0 value
     d  count                        10i 0 value
     d  fileHandle                     *   value

     d ifsfclose       pr                  extproc('_C_IFS_fclose')
     d  fileHandle                     *   value
      *copy @masplio
      * Archiver Spooled File I/O Constants and Prototypes
      *   See H.MASPLIO for descriptions

      * Error code constants
     d #SPL_OK         c                   0
     d #SPL_EOF        c                   -1
     d #SPL_EBADH      c                   -2
     d #SPL_EMAXH      c                   -3
     d #SPL_ECRUS      c                   -4
     d #SPL_EDLUS      c                   -5
     d #SPL_EALME      c                   -6
     d #SPL_EGTAT      c                   -7
     d #SPL_EOPSP      c                   -8
     d #SPL_ECRSP      c                   -9
     d #SPL_ECLSP      c                   -10
     d #SPL_EGTSP      c                   -11
     d #SPL_EPTSP      c                   -12
     d #SPL_EXCMD      c                   -14
      * attribute retreival/write return codes
     d #SPL_EOPN       c                   -15                                  File open error
     d #SPL_EFIL       c                   -16                                  File read/wrt error
     d #SPL_EATR       c                   -17                                  Invalid attr dta err
     d #SPL_EXST       c                   -18                                  Recs. exist error
     d #SPL_ECFT       c                   -19                                  Conflict error
     d #SPL_EOVFL      c                   -20                                  Data overflow error
     d #SPL_ENFND      c                   -21                                  Attr. recs not found
     d #SPL_ELOC       c                   -22                                  Bad Location error
     d #SPL_EOVR       c                   -23                                  OVRDBF error
      * AFP resource return codes
     d #SPL_ERSID      c                   -24                                  OVRDBF error
     d #SPL_ERSMD      c                   -25                                  OVRDBF error
     d #SPL_ERSNF      c                   -26                                  OVRDBF error
     d #SPL_ECRRS      c                   -27                                  OVRDBF error

      * AFP resource processing mode constants
     d #AFP_MRTV       c                   0
     d #AFP_MARC       c                   1
     d #AFP_MPRT       c                   2

      * AFP retreive archived resource using partial or complete key
     d #AFP_RTV_CMP    c                   0
     d #AFP_RTV_PRT    c                   1

      * AFP resource archive/re-archive flag
     d #AFP_RSC_NEW    c                   1                                    archive/re-archive r

      * AFP resource updated by sub-entry
     d #AFP_RSC_UPD    c                   1

      * AFP SF resource name change constants
     d #AFP_RNC        c                   0
     d #AFP_RCHG       c                   1

      * Attribute ID constants
     d #WSPZIRNG       c                   1
     d #WSPZINAM       c                   2
     d #WSPZIDLN       c                   3
     d #WSPZISDR       c                   4
     d #WSPZIMFW       c                   5
     d #WSPZILN1       c                   6
     d #WSPZIFRM       c                   7
     d #WSPZICPT       c                   8
     d #WSPZISEP       c                   9
     d #WSPZIMRC       c                   10
     d #WSPZIOPY       c                   11
     d #WSPZIFIL       c                   12
     d #WSPZIBIT       c                   13
     d #WSPZIHLF       c                   14
     d #WSPZIACC       c                   15
     d #WSPZITKN       c                   16
     d #WSPZISEC       c                   17
     d #WSPZIDVT       c                   18
     d #WSPZID1W       c                   19
     d #WSPZID1H       c                   20
     d #WSPZID2W       c                   21
     d #WSPZID2H       c                   22
     d #WSPZI36T       c                   23
     d #WSPZIUDT       c                   24
     d #WSPZIDOC       c                   25
     d #WSPZIFDR       c                   26
     d #WSPZIPGM       c                   27
     d #WSPZIPRC       c                   28
     d #WSPZIAFW       c                   29
     d #WSPZIAFL       c                   30
     d #WSPZIALI       c                   31
     d #WSPZIDFL       c                   32
     d #WSPZIPR1       c                   33
     d #WSPZIPFL       c                   34
     d #WSPZIPFW       c                   35
     d #WSPZIPLI       c                   36
     d #WSPZIPOF       c                   37
     d #WSPZIPAL       c                   38
     d #WSPZIPFT       c                   39
     d #WSPZIPUP       c                   40
     d #WSPZICPI       c                   41
     d #WSPZIFT        c                   42
     d #WSPZIQLT       c                   43
     d #WSPZIFFA       c                   44
     d #WSPZIDWR       c                   45
     d #WSPZITXT       c                   46
     d #WSPZIDTA       c                   47
     d #WSPZIEXN       c                   48
     d #WSPZIKCP       c                   49
     d #WSPZISOS       c                   50
     d #WSPZIRRT       c                   51
     d #WSPZICHI       c                   52
     d #WSPZIPGR       c                   53
     d #WSPZIJFY       c                   54
     d #WSPZIDPX       c                   55
     d #WSPZIFE        c                   56
     d #WSPZIFDN       c                   57
     d #WSPZIRST       c                   58
     d #WSPZISF#       c                   59
     d #WSPZICLS       c                   60
     d #WSPZI#PG       c                   61
     d #WSPZIJOB       c                   62
     d #WSPZIOTQ       c                   63
     d #WSPZISTT       c                   64
     d #WSPZITCP       c                   65
     d #WSPZISCD       c                   66
     d #WSPZI36I       c                   67
     d #WSPZIPGE       c                   68
     d #WSPZI#RC       c                   69
     d #WSPZIOQD       c                   70
     d #WSPZIKLB       c                   71
     d #WSPZIKCC       c                   72
     d #WSPZIVID       c                   73
     d #WSPZIEXH       c                   74
     d #WSPZIJBO       c                   75
     d #WSPZIFLO       c                   76
     d #WSPZIJTD       c                   77
     d #WSPZIMUL       c                   78
     d #WSPZIUOM       c                   79
     d #WSPZIFOV       c                   80
     d #WSPZIBOV       c                   81
     d #WSPZISPC       c                   82
     d #WSPZITRC       c                   83
     d #WSPZICF        c                   84
     d #WSPZIPGD       c                   85
     d #WSPZIINF       c                   86
     d #WSPZIDBF       c                   87
     d #WSPZIDBM       c                   88
     d #WSPZICH        c                   89
     d #WSPZIPMD       c                   90
     d #WSPZIPS        c                   91
     d #WSPZIRSL       c                   92
     d #WSPZILVL       c                   93
     d #WSPZI#BF       c                   94
     d #WSPZIPSZ       c                   95
     d #WSPZIFMG       c                   96
     d #WSPZIBMG       c                   97
     d #WSPZIFCI       c                   98
     d #WSPZICDF       c                   99
     d #WSPZIDCF       c                   100
     d #WSPZIOUT       c                   101
     d #WSPZIRDC       c                   102
     d #WSPZIORS       c                   103
     d #WSPZIORU       c                   104
     d #WSPZIUPI       c                   105
     d #WSPZIWTN       c                   106
     d #WSPZIUOP       c                   107
     d #WSPZIUDD       c                   108
     d #WSPZIUDO       c                   109
     d #WSPZICSPS      c                   110
     d #WSPZICFPS      c                   111
     d #WSPZIICFPS     c                   112
     d #WSPZIASP       c                   113
     d #WSPZILUSED     c                   114
     d #WSPZILSIZE     c                   115
     d #WSPZIIPTHR     c                   116
     d #WSPZIURLIB     c                   117
     d #WSPZICNRST     c                   118
     d #WSPZIEGSTH     c                   119
     d #WSPZIFNTRS     c                   120
     d #WSPZINBRDTA    c                   121
     d #WSPZISDSTH     c                   122

      * Print Buffer Header Bit Constants (see @MASPLIOBH)
      * Byte 1
     d #WSPXAPFF       c                   '0'
     d #WSPXLAC        c                   '1'
     d #WSPXLAPP       c                   '2'
     d #WSPXLCPP       c                   '3'
     d #WSPXPGPR       c                   '4'
     d #WSPXNOPG       c                   '5'
     d #WSPXLFE        c                   '6'
     d #WSPXALST       c                   '7'
      * Byte 2
     d #WSPXIPDS       c                   '0'
     d #WSPXITRN       c                   '1'

      * Function Prototypes
     d opnSplf         pr            10i 0 extproc('openSplf')
     d  sJobName                     26a
     d  sSplfName                    10a
     d  sSplfNbr                     10i 0 value
     d  sJobId                       16a
     d  sSplfId                      16a

     d crtSplf         pr            10i 0 extproc('createSplf')
     d  pSplAtr                        *   value

     d cloSplf         pr            10i 0 extproc('closeSplf')
     d  hSplf                        10i 0 value

     d getSplRcd       pr            10i 0 extproc('getSplRcd')
     d  hSplf                        10i 0 value
     d  pSplRcd                        *   value

     d putSplRcd       pr            10i 0 extproc('putSplRcd')
     d  hSplf                        10i 0 value
     d  pSplRcd                        *   value

     d getOpnSplA      pr              *   extproc('getOpenSplfAttrs')
     d  hSplf                        10i 0 value

     d getSplARcd      pr            10i 0 extproc('getSplAttrRcd')
     d  hSplf                        10i 0 value
     d  pSplRcd                        *   value

     d getSplAttr      pr              *   extproc('getSplAttr')
     d  nId                          10i 0 value
     d  pAtrRcd                        *   value

     d setSplfAts      pr            10i 0 extproc('setSplfAttrs')
     d  pAtrRcd                        *   value
     d  pSplAtr                        *   value
     d  nSplAtrSiz                   10u 0 value

     d getSplErCd      pr              *   extproc('getLastSplErrCd')

     d putAfpSF        pr            10i 0 extproc('PUTAFPSF')
     d afpSplHndl                    10i 0 value
     d afpCmdDtaP                      *   value
     d afpCmdLen                     10i 0 value
     d afpIncSep                      1a   const
     d pRscList                        *   value

     d getAfpRsRs      pr            10i 0 extproc('getAfpRscFromRsc')
     d  pRscName                     10a   const
     d  pRscLib                      10a   const
     d  pRscType                     10a   const
     d  pRscList                       *   value
     d  pRscEnt                        *

     d getAfpRsSF      pr            10i 0 extproc('getAfpRscFromSF')
     d  pSFI                           *   value
     d  pRscList                       *   value
     d  iSFNmChg                     10i 0 value

     d getAfpRsDs      pr            10i 0 extproc('getAfpRscDesc')
     d  pRscName                     10a   const
     d  pRscLib                      10a   const
     d  pRscType                     10a   const
     d  pSplAtr                        *   value
     d  pRscDesc                       *   value

     d crtAfpRL        pr            10i 0 extproc('createAfpRscList')
     d  pRscAtr                        *   value
     d  pRscList                       *

     d initAfpRL       pr                  extproc('initAfpRscList')
     d  pRscList                       *   value

     d dltAfpRL        pr                  extproc('deleteAfpRscList')
     d  pRscList                       *   value

     d addAfpRLE       pr              *   extproc('addAfpRscListEntry')
     d  pRscList                       *   value
     d  pRscItem                       *   value

     d bldAfpRLC       pr              *   extproc('buildAfpRscClientList')
     d  pRscList                       *   value
     d  pClientLst                     *

     d frstAfpRLE      pr              *   extproc('getFirstAfpRscListEntry')
     d  pRscList                       *   value

     d nextAfpRLE      pr              *   extproc('getNextAfpRscListEntry')
     d  pRscEnt                        *   value

     d findAfpRLE      pr              *   extproc('findAfpRscListEntry')
     d  pRscList                       *   value
     d  pRscName                     10a   const
     d  pRscLib                      10a   const
     d  pRscType                     10a   const

     d getAfpRLA       pr              *   extproc('getAfpRscListAttrs')
     d  pRscList                       *   value

     d getAfpRLEV      pr              *   extproc('getAfpRscListEntryValue')
     d  pRscEnt                        *   value

      * retreive attribute structure
     d getArcAtr       pr            10i 0
     d aSpynum                       10a   const
     d pAttrDta                        *   value
     d nAttrLen                      10u 0 value
     d nRtvLoc                        5u 0 value

      * write attribute structure
     d putArcAtr       pr            10i 0
     d aSpynum                       10a   const
     d pAttrDta                        *   value

      * delete attribute structure
     d delArcAtr       pr            10i 0
     d aSpynum                       10a   const
      *copy qsysinc/qrpglesrc,qusrspla
     D*begin_generated_IBM_copyright_prolog
     D*This is an automatically generated copyright prolog.
     D*After initializing,  DO NOT MODIFY OR MOVE
     D*-----------------------------------------------------------------
     D*
     D*Product(s):
     D*5763-SS1
     D*5716-SS1
     D*5769-SS1
     D*5722-SS1
     D*
     D*(C)Copyright IBM Corp.  1994, 2005
     D*
     D*All rights reserved.
     D*US Government Users Restricted Rights -
     D*Use, duplication or disclosure restricted
     D*by GSA ADP Schedule Contract with IBM Corp.
     D*
     D*Licensed Materials-Property of IBM
     D*
     D*---------------------------------------------------------------
     D*
     D*end_generated_IBM_copyright_prolog
     D*** START HEADER FILE SPECIFICATIONS *******************************
     D*
     D*Header File Name: H/QUSRSPLA
     D*
     D*Descriptive Name: Retrieve spool file attributes.
     D*
     D*
     D*Description: The Retrieve Spooled File Attributes APi
     D*          returns specific information about a spooled
     D*          file into a receiver variable.
     D*
     D*Header Files Included: h/decimal
     D*
     D*Macros List: None.
     D*
     D*Structure List: Qus_SPLA0100_t
     D*            Qus_SPLA0200_t
     D*            Qus_UDOPTENT_t
     D*            Qus_Usr_Lib_E_t
     D*            Qus_Edge_Stitch_Stpl_Pos_E_t
     D*            Qus_Sadl_Stitch_Stpl_Off_E_t
     D*            Qsp_Splf_Libl_E_t
     D*            Qsp_IPP_Splf_Attrs_t
     D*            Qsp_SR_Splf_Attrs_t
     D*
     D*Function Prototype List: QUSRSPLA
     D*
     D*Change Activity:
     D*
     D*CFD List:
     D*
     D*FLAG REASON       LEVEL DATE   PGMR      CHANGE DESCRIPTION
     D*---- ------------ ----- ------ --------- ------------------
     D*$A0= D2862000     3D10  940213 LUPA:     New Include
     D*$A1= D9171000     3D60  950117 AGLENSKI: Print openness.
     D*$A3= D94979       4D20  970111 DWIGHT:   Decimal Format
     D*                                      support.
     D*$A4= D95075       4D20  970205 DWIGHT:   Support for Point
     D*                                      Sizes on DBCS
     D*                                      Coded Font, Coded
     D*                                      Font, and Font
     D*                                      Character Set
     D*$A5= D94929       4D30  970722 DWIGHT:   Support for Date
     D*                                      file was last
     D*                                      accessed, Spooled
     D*                                      file size, and
     D*                                      ASP number.
     D*$A6= D95677       4D30  970722 DWIGHT:   Support for
     D*                                      IPDS pass through,
     D*                                      User resource
     D*                                      library list,
     D*                                      Corner stapling,
     D*                                      Edge stitching and
     D*                                      Font resolution.
     D*$A7= D95712       4D30  971105           Support ACIF
     D*                                      attributes
     D*$A8= D95966       4D40  980326 RJOHNSON: Add total number
     D*                                      of bytes of data
     D*                                      stream for spooled
     D*                                      file.
     D*$A9= D95864       4D40  980514           Support for Saddle
     D*                                      stitching and
     D*                                      Constant Back OVL
     D*$AA= D97433       5D10  991021           Support for record
     D*                                      format page defs.
     D*                                      and Line Data to
     D*                                      AFPDS conversion
     D*$AB= D97516       5D10  991026           Support for
     D*                                      increase in
     D*                                      number of libs in
     D*                                      a job's library
     D*                                      list.
     D*$AC= D97976       5D10  991026           Support for IPP
     D*$AD= D98212.4     5D10  991228 GCHANEY:  Compiler directive
     D*                                      16 byte pointers.
     D*$AE= D97260       5D20  010105 ROCH:     Decouple Splf from
     D*                                      Job.
     D*$AF= D97259.1     5D30  020403 ROCH:     Support for spool
     D*                                     files and output
     D*                                     queues on an IASP.
     D*FLAG REASON   RLS&LVL    DATE   PGMR  COMMENTS
     D*____ _______  __________ YYMMDD ____  ____________________________
     D*$AG= D9965401 v5r4m0.xpf 030926 ROCH: Support for save and
     D*                                  restore of spooled files.
     D*$AH= D9971600 v5r4m0.xpf 031023 ROCH: Support for spooled file
     D*                                  expiration.
     D*
     D*End CFD List.
     D*
     D*Additional notes about the Change Activity
     D*End Change Activity.
     D*** END HEADER FILE SPECIFICATIONS **************************
     D****************************************************************
     D*Prototype for calling Spooled File and Print API QUSRSPLA
     D****************************************************************
     D QUSRSPLA        C                   'QUSRSPLA'
     D****************************************************************
     D****************************************************************
     D*Structure for User Defined Options
     D****
     D*The following describes the user defined option entries in
     D*format SPLA0200 and SPLA0100.
     D*
     D*Usr_Def_Options_Offset       provides the offset
     D*Usr_Def_Option_Number        provides the number of repeated
     D*                          option entries.
     D*
     D****************************************************************
     DQUSPTENT         DS
     D*                                             Qus UDOPTENT
     D QUSUDOO                 1     10
     D*                                             Usr Def Option One
     D QUSUDOT                11     20
     D*                                             Usr Def Option Two
     D QUSUDOT00              21     30
     D*                                             Usr Def Option Three
     D QUSUDOF                31     40
     D*                                             Usr Def Option Four
     D****************************************************************
     D*Structure for User Resource Libraries
     D****
     D*The following describes the user resource library entries in
     D*format SPLA0200.
     D*
     D*Usr_Rsc_Libl_Off             provides the offset
     D*Usr_Rsc_Libl_Nbr             provides the number of repeated
     D*                          library entries.
     D*
     D****************************************************************
     DQUSULE           DS
     D*                                             Qus Usr Lib E
     D QUSURLN                 1     10
     D*                                             Usr Resource Lib Name
     D****************************************************************
     D*Structure for Edge Stitch Staple Positions
     D****
     D*The following describes the edge stitch staple position
     D*entries in format SPLA0200.
     D*
     D*Staple_Position_Offset       provides the offset
     D*Nbr_of_Staple_Positions      provides the number of repeated
     D*                          staple position entries.
     D*
     D****************************************************************
     DQUSESSPE         DS
     D*                                             Qus Edge Stitch Stpl Pos E
     D QUSSP01                 1      8P 5
     D*                                             Staple Position
     D****************************************************************
     D*Structure for Saddle Stitch Staple Offsets
     D****
     D*The following describes the saddle stitch staple offset
     D*entries in format SPLA0200.
     D*
     D*Off_Saddle_Staple_Off        provides the offset
     D*Nbr_of_Saddle_Stpl_Off       provides the number of repeated
     D*                          staple offset entries.
     D*
     D****************************************************************
     DQUSSSSOE         DS
     D*                                             Qus Sadl Stitch Stpl Off E
     D QUSSO                   1      8P 5
     D*                                             Staple Offset
     D****************************************************************
     D*Structure for Spooled file library name entries
     D****
     D*The following describes the library name entries in format
     D*SPLA0200.
     D*
     D*Off_Splf_Libl                provides the offset
     D*Nbr_of_Libraries             provides the number of repeated
     D*                          library name entries.
     D*
     D****************************************************************
     DQUSQSLE          DS
     D*                                             Qsp Splf Libl E
     D QUSLIBN03               1     10
     D*                                             Library Name
     D****************************************************************
     D*Structure for Internet Print Protocol Spooled File Attributes
     D****
     D*The following describes the IPP spooled file attributes in
     D*format SPLA0200.
     D*
     D*Off_IPP_Attrs                provides the offset
     D*
     D****************************************************************
     DQUSIPPSA         DS
     D*                                             Qsp IPP Splf Attrs
     D QUSOIPPA                1      4B 0
     D*                                             Length of IPP Attrs
     D QUSOIPPA00              5      8B 0
     D*                                             CCSID of IPP Attrs
     D QUSOIPPA01              9     71
     D*                                             Nat Lang of IPP Attrs
     D QUSIPPPN               72    198
     D*                                             IPP Printer Name
     D QUSIPPJN              199    453
     D*                                             IPP Job Name
     D QUSPJNNL              454    516
     D*                                             IPP Job Name Natural Languag
     D QUSPPOUN              517    771
     D*                                             IPP Originating User Name
     D QUSOUNNL              772    834
     D*                                             IPP Orig User Name Nat Lang
     D*QUSERVED51            835    835
     D*
     D*                      Reserved
     D****************************************************************
     D*Structure for Save/Restore Spooled File Attributes
     D****
     D*The following describes the SR spooled file attributes in
     D*format SPLA0200.
     D*
     D*Off_SR_Attrs                provides the offset
     D*
     D****************************************************************
     DQUSQSRSA         DS
     D*                                             Qsp SR Splf Attrs
     D QUSLOSRA                1      4B 0
     D*                                             Length of SR Attrs
     D QUSSSN00                5      8B 0
     D*                                             Save Seq Nbr
     D QUSSSDT                 9     21
     D*                                             Splf Save DateTime
     D QUSSRDT                22     34
     D*                                             Splf Restore DateTime
     D QUSSVI                 35    105
     D*                                             Save Vol Id
     D QUSSCMD04             106    115
     D*                                             Save Command
     D QUSSD08               116    125
     D*                                             Save Device
     D QUSSFILN13            126    135
     D*                                             Save File Name
     D QUSSFILL              136    145
     D*                                             Save File Lib
     D QUSSL12               146    162
     D*                                             Save Label
     D*QUSERVED58            163    163
     D*
     D*                      Reserved
     D****************************************************************
     D*Structure for SPLA0100 format
     D****
     D*NOTE:  The following type definition only defines the fixed
     D*    portion of the format.  Any varying length fields must
     D*    be defined by the user.
     D****************************************************************
     DQUSA010001       DS
     D*                                             Qus SPLA0100
     D QUSBR07                 1      4B 0
     D*                                             Bytes Return
     D QUSBA07                 5      8B 0
     D*                                             Bytes Avail
     D QUSIJID08               9     24
     D*                                             Int Job ID
     D QUSISID00              25     40
     D*                                             Int Splf ID
     D QUSJN10                41     50
     D*                                             Job Name
     D QUSUN12                51     60
     D*                                             Usr Name
     D QUSJNBR09              61     66
     D*                                             Job Number
     D QUSSN01                67     76
     D*                                             Splf Name
     D QUSSNBR                77     80B 0
     D*                                             Splf Number
     D QUSFT02                81     90
     D*                                             Form Type
     D QUSUD01                91    100
     D*                                             Usr Data
     D QUSTATUS04            101    110
     D*                                             Status
     D QUSFILA03             111    120
     D*                                             File Avail
     D QUSHFIL               121    130
     D*                                             Hold File
     D QUSSFIL03             131    140
     D*                                             Save File
     D QUSTP                 141    144B 0
     D*                                             Total Pages
     D QUSCP                 145    148B 0
     D*                                             Curr Page
     D QUSSP                 149    152B 0
     D*                                             Start Page
     D QUSEP                 153    156B 0
     D*                                             End Page
     D QUSLPP                157    160B 0
     D*                                             Last Page Print
     D QUSRP02               161    164B 0
     D*                                             Rest Page
     D QUSTC                 165    168B 0
     D*                                             Total Copies
     D QUSCR                 169    172B 0
     D*                                             Copies Rem
     D QUSLPI                173    176B 0
     D*                                             Lines Per Inch
     D QUSCPI                177    180B 0
     D*                                             Char Per Inch
     D QUSOP01               181    182
     D*                                             Output Priority
     D QUSON00               183    192
     D*                                             Outq Name
     D QUSOL00               193    202
     D*                                             Outq Lib
     D QUSDFILO              203    209
     D*                                             Date File Open
     D QUSTFILO              210    215
     D*                                             Time File Open
     D QUSDFILN02            216    225
     D*                                             Dev File Name
     D QUSDFILL02            226    235
     D*                                             Dev File Lib
     D QUSPN                 236    245
     D*                                             Pgm Name
     D QUSPL00               246    255
     D*                                             Pgm Lib
     D QUSCC                 256    270
     D*                                             Count Code
     D QUSPT00               271    300
     D*                                             Print Text
     D QUSRL05               301    304B 0
     D*                                             Record Length
     D QUSMR                 305    308B 0
     D*                                             Max Records
     D QUSDT00               309    318
     D*                                             Dev Type
     D QUSPDT                319    328
     D*                                             Ptr Dev Type
     D QUSDN00               329    340
     D*                                             Doc Name
     D QUSFN17               341    404
     D*                                             Folder Name
     D QUSS36PN              405    412
     D*                                             S36 Proc Name
     D QUSPF                 413    422
     D*                                             Print Fidel
     D QUSRU                 423    423
     D*                                             Repl Unprint
     D QUSRC00               424    424
     D*                                             Repl Char
     D QUSPL01               425    428B 0
     D*                                             Page Length
     D QUSPW                 429    432B 0
     D*                                             Page Width
     D QUSNBRS01             433    436B 0
     D*                                             Number Separate
     D QUSOLN                437    440B 0
     D*                                             Overflow Line Nm
     D QUSDBCSD              441    450
     D*                                             DBCS Data
     D QUSBCSEC              451    460
     D*                                             DBCS Ext Chars
     D QUSSSOSI              461    470
     D*                                             DBCS SOSI
     D QUSBCSCR              471    480
     D*                                             DBCS Char Rotate
     D QUSDBCSC00            481    484B 0
     D*                                             DBCS Cpi
     D QUSGCS                485    494
     D*                                             Grph Char Set
     D QUSCP00               495    504
     D*                                             Code Page
     D QUSFDN                505    514
     D*                                             Form Def Name
     D QUSFDL                515    524
     D*                                             Form Def Lib
     D QUSSD06               525    528B 0
     D*                                             Source Drawer
     D QUSPF00               529    538
     D*                                             Print Font
     D QUS36SID              539    544
     D*                                             S36 Spl ID
     D QUSPR                 545    548B 0
     D*                                             Page Rotate
     D QUSATION              549    552B 0
     D*                                             Justification
     D QUSUPLEX              553    562
     D*                                             Duplex
     D QUSFOLD               563    572
     D*                                             Fold
     D QUSCC00               573    582
     D*                                             Ctrl Char
     D QUSAF                 583    592
     D*                                             Align Forms
     D QUSPQ                 593    602
     D*                                             Print Quality
     D QUSFF                 603    612
     D*                                             Form Feed
     D QUSDV                 613    683
     D*                                             Disk Volume
     D QUSDL00               684    700
     D*                                             Disk Label
     D QUSET                 701    710
     D*                                             Exch Type
     D QUSCC01               711    720
     D*                                             Char Code
     D QUSNDR                721    724B 0
     D*                                             Nmbr Disk Rcrds
     D QUSLTIUP              725    728B 0
     D*                                             Multiup
     D QUSFON                729    738
     D*                                             Frnt Ovrly Name
     D QUSFOLN               739    748
     D*                                             Frnt Ovrly Lib Name
     D QUSFOOD               749    756P 5
     D*                                             Frnt Ovrly Off Dn
     D QUSFOOA               757    764P 5
     D*                                             Frnt Ovrly Off Across
     D QUSBON                765    774
     D*                                             Bck Ovrly Name
     D QUSBOLN               775    784
     D*                                             Bck Ovrly Lib Name
     D QUSBOOD               785    792P 5
     D*                                             Bck Ovrly Off Dn
     D QUSBOOA               793    800P 5
     D*                                             Bck Ovrly Off Across
     D QUSUM                 801    810
     D*                                             Unit Measure
     D QUSPD03               811    820
     D*                                             Page Definition
     D QUSPDL                821    830
     D*                                             Page Definition Lib
     D QUSLS00               831    840
     D*                                             Line Spacing
     D QUSPS                 841    848P 5
     D*                                             Point Size
     D QUSFMOD               849    856P 5
     D*                                             Frnt Margin Off Dn
     D QUSFMOA               857    864P 5
     D*                                             Frnt Margin Off Acr
     D QUSBMOD               865    872P 5
     D*                                             Back Margin Off Dn
     D QUSBMOA               873    880P 5
     D*                                             Back Margin Off Acr
     D QUSLOP                881    888P 5
     D*                                             Length Of Page
     D QUSWOP                889    896P 5
     D*                                             Width Of Page
     D QUSMM                 897    906
     D*                                             Measure Method
     D QUSAR00               907    907
     D*                                             Afp Resource
     D QUSFCS                908    917
     D*                                             Font Char Set
     D QUSFCSL               918    927
     D*                                             Font Char Set Lib
     D QUSCPN                928    937
     D*                                             Code Page Name
     D QUSCPL                938    947
     D*                                             Code Page Lib
     D QUSCFN                948    957
     D*                                             Coded Font Name
     D QUSCFL                958    967
     D*                                             Coded Font Lib
     D QUSCSCFN              968    977
     D*                                             DBCS Coded Font Name
     D QUSCSCFL              978    987
     D*                                             DBCS Coded Font Lib
     D QUSUDFIL              988    997
     D*                                             User Defined File
     D QUSRO                 998   1007
     D*                                             Reduce Output
     D QUSCBO               1008   1008
     D*                                             Constant Back Overlay
     D QUSOB                1009   1012B 0
     D*                                             Output Bin
     D QUSCCSID08           1013   1016B 0
     D*                                             CCSID
     D QUSUT                1017   1116
     D*                                             User Text
     D QUSOS03              1117   1124
     D*                                             Original System
     D QUSONID              1125   1132
     D*                                             Original Net ID
     D QUSSC                1133   1142
     D*                                             Splf Creator
     D QUSRSV502            1143   1144
     D*                                             Reserved5
     D QUSUDOO00            1145   1148B 0
     D*                                             Usr Def Options Offset
     D QUSUDON              1149   1152B 0
     D*                                             Usr Def Options Number
     D QUSUDOEL             1153   1156B 0
     D*                                             Usr Def Options Entry Length
     D QUSUDD               1157   1411
     D*                                             Usr Defined Data
     D QUSUDON00            1412   1421
     D*                                             Usr Def Object Name
     D QUSUDOL              1422   1431
     D*                                             Usr Def Object Lib
     D QUSUDOT01            1432   1441
     D*                                             Usr Def Object Type
     D QUSRSV600            1442   1444
     D*                                             Reserved6
     D QUSCSPS              1445   1452P 5
     D*                                             Character Set Point Size
     D QUSCFPS              1453   1460P 5
     D*                                             Coded Font Point Size
     D QUSSCFPS             1461   1468P 5
     D*                                             DBCS Coded Font Point Size
     D QUSSFASP             1469   1472B 0
     D*                                             Spooled File ASP
     D QUSSFILS             1473   1476B 0
     D*                                             Spooled File Size
     D QUSSSM02             1477   1480B 0
     D*                                             Splf Size Multiplier
     D QUSIPPJI             1481   1484B 0
     D*                                             IPP JobId
     D QUSSCSM              1485   1485
     D*                                             Splf Crt Security Method
     D QUSSAM               1486   1486
     D*                                             Splf Authentication Method
     D QUSWBPD              1487   1493
     D*                                             Wtr Begin Process Date
     D QUSWBPT              1494   1499
     D*                                             Wtr Begin Process Time
     D QUSWCPD              1500   1506
     D*                                             Wtr Complete Proc Date
     D QUSWCPT              1507   1512
     D*                                             Wtr Complete Proc Time
     D QUSJSN00             1513   1520
     D*                                             Job System Name
     D QUSASPDN06           1521   1530
     D*                                             Splf ASP Device Name
     D QUSSED               1531   1537
     D*                                             Splf Expiration Date
     D*QUSOD                         40    DIM(00001)
     D* QUSUDOO01                    10    OVERLAY(QUSOD:00001)
     D* QUSUDOT02                    10    OVERLAY(QUSOD:00011)
     D* QUSUDOT03                    10    OVERLAY(QUSOD:00021)
     D* QUSUDOF00                    10    OVERLAY(QUSOD:00031)
     D*
     D*                                  Varying length
     D****************************************************************
     D*Structure for SPLA0200 format
     D****                                                           *
     D*NOTE:  The following type definition only defines the fixed
     D*    portion of the format.  Any varying length fields must
     D*    be defined by the user.
     D****************************************************************
     DQUSA0200         DS
     D*                                             Qus SPLA0200
     D QUSBR08                 1      4B 0
     D*                                             Bytes Return
     D QUSBA08                 5      8B 0
     D*                                             Bytes Avail
     D QUSFN18                 9     16
     D*                                             Format Name
     D QUSIJID09              17     32
     D*                                             Int Job ID
     D QUSISID01              33     48
     D*                                             Int Splf ID
     D QUSJN11                49     58
     D*                                             Job Name
     D QUSUN13                59     68
     D*                                             Usr Name
     D QUSJNBR10              69     74
     D*                                             Job Number
     D QUSSN02                75     84
     D*                                             Splf Name
     D QUSSNBR00              85     88B 0
     D*                                             Splf Number
     D QUSFT03                89     98
     D*                                             Form Type
     D QUSUD02                99    108
     D*                                             Usr Data
     D QUSTATUS05            109    118
     D*                                             Status
     D QUSFILA04             119    128
     D*                                             File Avail
     D QUSHFIL00             129    138
     D*                                             Hold File
     D QUSSFIL04             139    148
     D*                                             Save File
     D QUSTP00               149    152B 0
     D*                                             Total Pages
     D QUSCP01               153    156B 0
     D*                                             Curr Page
     D QUSSP00               157    160B 0
     D*                                             Start Page
     D QUSEP00               161    164B 0
     D*                                             End Page
     D QUSLPP00              165    168B 0
     D*                                             Last Page Print
     D QUSRP03               169    172B 0
     D*                                             Rest Page
     D QUSTC00               173    176B 0
     D*                                             Total Copies
     D QUSCR00               177    180B 0
     D*                                             Copies Rem
     D QUSLPI00              181    184B 0
     D*                                             Lines Per Inch
     D QUSCPI00              185    188B 0
     D*                                             Char Per Inch
     D QUSOP02               189    190
     D*                                             Output Priority
     D QUSON01               191    200
     D*                                             Outq Name
     D QUSOL01               201    210
     D*                                             Outq Lib
     D QUSDFILO00            211    217
     D*                                             Date File Open
     D QUSTFILO00            218    223
     D*                                             Time File Open
     D QUSDFILN03            224    233
     D*                                             Dev File Name
     D QUSDFILL03            234    243
     D*                                             Dev File Lib
     D QUSPN00               244    253
     D*                                             Pgm Name
     D QUSPL02               254    263
     D*                                             Pgm Lib
     D QUSCC02               264    278
     D*                                             Count Code
     D QUSPT01               279    308
     D*                                             Print Text
     D QUSRL06               309    312B 0
     D*                                             Record Length
     D QUSMR00               313    316B 0
     D*                                             Max Records
     D QUSDT01               317    326
     D*                                             Dev Type
     D QUSPDT00              327    336
     D*                                             Ptr Dev Type
     D QUSDN01               337    348
     D*                                             Doc Name
     D QUSFN19               349    412
     D*                                             Folder Name
     D QUSS36PN00            413    420
     D*                                             S36 Proc Name
     D QUSPF01               421    430
     D*                                             Print Fidel
     D QUSRU00               431    431
     D*                                             Repl Unprint
     D QUSRC01               432    432
     D*                                             Repl Char
     D QUSPL03               433    436B 0
     D*                                             Page Length
     D QUSPW00               437    440B 0
     D*                                             Page Width
     D QUSNBRS02             441    444B 0
     D*                                             Number Separate
     D QUSOLN00              445    448B 0
     D*                                             Overflow Line Nm
     D QUSDBCSD00            449    458
     D*                                             DBCS Data
     D QUSBCSEC00            459    468
     D*                                             DBCS Ext Chars
     D QUSSSOSI00            469    478
     D*                                             DBCS SOSI
     D QUSBCSCR00            479    488
     D*                                             DBCS Char Rotate
     D QUSDBCSC01            489    492B 0
     D*                                             DBCS Cpi
     D QUSGCS00              493    502
     D*                                             Grph Char Set
     D QUSCP02               503    512
     D*                                             Code Page
     D QUSFDN00              513    522
     D*                                             Form Def Name
     D QUSFDL00              523    532
     D*                                             Form Def Lib
     D QUSSD07               533    536B 0
     D*                                             Source Drawer
     D QUSPF02               537    546
     D*                                             Print Font
     D QUS36SID00            547    552
     D*                                             S36 Spl ID
     D QUSPR00               553    556B 0
     D*                                             Page Rotate
     D QUSATION00            557    560B 0
     D*                                             Justification
     D QUSUPLEX00            561    570
     D*                                             Duplex
     D QUSFOLD00             571    580
     D*                                             Fold
     D QUSCC03               581    590
     D*                                             Ctrl Char
     D QUSAF00               591    600
     D*                                             Align Forms
     D QUSPQ00               601    610
     D*                                             Print Quality
     D QUSFF00               611    620
     D*                                             Form Feed
     D QUSDV00               621    691
     D*                                             Disk Volume
     D QUSDL01               692    708
     D*                                             Disk Label
     D QUSET00               709    718
     D*                                             Exch Type
     D QUSCC04               719    728
     D*                                             Char Code
     D QUSNDR00              729    732B 0
     D*                                             Nmbr Disk Rcrds
     D QUSLTIUP00            733    736B 0
     D*                                             Multiup
     D QUSFON00              737    746
     D*                                             Frnt Ovrly Name
     D QUSFOLN00             747    756
     D*                                             Frnt Ovrly Lib Name
     D QUSFOOD00             757    764P 5
     D*                                             Frnt Ovrly Off Dn
     D QUSFOOA00             765    772P 5
     D*                                             Frnt Ovrly Off Across
     D QUSBON00              773    782
     D*                                             Bck Ovrly Name
     D QUSBOLN00             783    792
     D*                                             Bck Ovrly Lib Name
     D QUSBOOD00             793    800P 5
     D*                                             Bck Ovrly Off Dn
     D QUSBOOA00             801    808P 5
     D*                                             Bck Ovrly Off Across
     D QUSUM00               809    818
     D*                                             Unit Measure
     D QUSPD04               819    828
     D*                                             Page Definition
     D QUSPDL00              829    838
     D*                                             Page Definition Lib
     D QUSLS01               839    848
     D*                                             Line Spacing
     D QUSPS00               849    856P 5
     D*                                             Point Size
     D QUSMDRS               857    860B 0
     D*                                             Max Data Record Size
     D QUSFILBS              861    864B 0
     D*                                             File Buffer Size
     D QUSFILL00             865    870
     D*                                             File Level
     D QUSCFA                871    886
     D*                                             Coded Font Array
     D QUSCM                 887    896
     D*                                             Channel Mode
     D QUSCC1                897    900B 0
     D*                                             Channel Code1
     D QUSCC2                901    904B 0
     D*                                             Channel Code2
     D QUSCC3                905    908B 0
     D*                                             Channel Code3
     D QUSCC4                909    912B 0
     D*                                             Channel Code4
     D QUSCC5                913    916B 0
     D*                                             Channel Code5
     D QUSCC6                917    920B 0
     D*                                             Channel Code6
     D QUSCC7                921    924B 0
     D*                                             Channel Code7
     D QUSCC8                925    928B 0
     D*                                             Channel Code8
     D QUSCC9                929    932B 0
     D*                                             Channel Code9
     D QUSCC10               933    936B 0
     D*                                             Channel Code10
     D QUSCC11               937    940B 0
     D*                                             Channel Code11
     D QUSCC12               941    944B 0
     D*                                             Channel Code12
     D QUSGT                 945    952
     D*                                             Graphics Tokenl
     D QUSRF                 953    962
     D*                                             Record Format
     D QUSRSV103             963    964
     D*                                             Reserved1
     D QUSHD1                965    972P 5
     D*                                             Height Drawer1
     D QUSWD1                973    980P 5
     D*                                             Width Drawer1
     D QUSHD2                981    988P 5
     D*                                             Height Drawer2
     D QUSWD2                989    996P 5
     D*                                             Width Drawer2
     D QUSNBRB               997   1000B 0
     D*                                             Number Buffers
     D QUSMFW               1001   1004B 0
     D*                                             Max Form Width
     D QUSAFW               1005   1008B 0
     D*                                             Alternate Form Width
     D QUSAFL               1009   1012B 0
     D*                                             Alternate Form Length
     D QUSAL                1013   1016B 0
     D*                                             Alternate Lpi
     D QUSTF                1017   1018
     D*                                             Text Flags
     D QUSFFILO             1019   1019
     D*                                             Flg File Open
     D QUSFEPC              1020   1020
     D*                                             Flg Est Pge Cnt
     D QUSFPB               1021   1021
     D*                                             Flg Pge Boundary
     D QUSFT04              1022   1022
     D*                                             Flg Trc
     D QUSFDC               1023   1023
     D*                                             Flg Def Char
     D QUSFC                1024   1024
     D*                                             Flg Cpi
     D QUSFT05              1025   1025
     D*                                             Flg Transparency
     D QUSFDWC              1026   1026
     D*                                             Flg Dbl Wide Char
     D QUSFCR               1027   1027
     D*                                             Flg Char Rotate
     D QUSFCP               1028   1028
     D*                                             Flg Code Page
     D QUSFFE               1029   1029
     D*                                             Flg Fft Emphasis
     D QUSS3812             1030   1030
     D*                                             Flg Scs3812
     D QUSFS                1031   1031
     D*                                             Flg Sld
     D QUSFG                1032   1032
     D*                                             Flg Gea
     D QUSC5219             1033   1033
     D*                                             Flg Cmd5219
     D QUSC3812             1034   1034
     D*                                             Flg Cmd3812
     D QUSFFO               1035   1035
     D*                                             Flg Fld Outline
     D QUSFFFT              1036   1036
     D*                                             Flg Final Frm Txt
     D QUSFB                1037   1037
     D*                                             Flg Barcode
     D QUSFC00              1038   1038
     D*                                             Flg Color
     D QUSFDC00             1039   1039
     D*                                             Flg Drawer Chg
     D QUSFC01              1040   1040
     D*                                             Flg Charid
     D QUSFL                1041   1041
     D*                                             Flg Lpi
     D QUSFF01              1042   1042
     D*                                             Flg Font
     D QUSFH                1043   1043
     D*                                             Flg Highlight
     D QUSFPR               1044   1044
     D*                                             Flg Pge Rotate
     D QUSFS00              1045   1045
     D*                                             Flg Subscript
     D QUSFS01              1046   1046
     D*                                             Flg Superscript
     D QUSFD                1047   1047
     D*                                             Flg Dds
     D QUSFFF               1048   1048
     D*                                             Flg Form Feed
     D QUSFSD               1049   1049
     D*                                             Flg Scs Data
     D QUSFUGD              1050   1050
     D*                                             Flg User Gen Data
     D QUSFG00              1051   1051
     D*                                             Flg Graphics
     D QUSFUD               1052   1052
     D*                                             Flg Unrecogn Data
     D QUSSCIIT             1053   1053
     D*                                             Flg ASCII Trans
     D QUSFIT               1054   1054
     D*                                             Flg Ipds Trans
     D QUSFOV               1055   1055
     D*                                             Flg Office Vis
     D QUSFNL               1056   1056
     D*                                             Flg No Lpi
     D QUSC3353             1057   1057
     D*                                             Flg Cpa3353
     D QUSFSE               1058   1058
     D*                                             Flg Set Excp
     D QUSFCC               1059   1059
     D*                                             Flg Carriage Control
     D QUSFPP               1060   1060
     D*                                             Flg Pge Pos
     D QUSFIC               1061   1061
     D*                                             Flg Invalid Char
     D QUSFL00              1062   1062
     D*                                             Flg Lengths
     D QUSFP5               1063   1063
     D*                                             Flg Pres5a
     D QUSCFLD              1064   1064
     D*                                             Flg Resrvd
     D QUSNFE               1065   1068B 0
     D*                                             Nbr Font Entries
     D QUSNLE               1069   1072B 0
     D*                                             Nbr Lib Entries
     D QUSFE                1073   2225
     D*                                             Font Entries
     D QUSLE                2226   2856
     D*                                             Lib Entries
     D QUSAFPDS             2857   2857
     D*                                             Native AFPDS
     D QUSCHRID             2858   2858
     D*                                             JOBCCSID For CHRID
     D QUSS36CY             2859   2859
     D*                                             S36 Continue Yes
     D QUSDFU               2860   2869
     D*                                             Decimal Format Used
     D QUSDFLA              2870   2876
     D*                                             Date File Last Accessed
     D QUSPG04              2877   2877
     D*                                             Page Groups
     D QUSGLI               2878   2878
     D*                                             Group Level Index
     D QUSPLI               2879   2879
     D*                                             Page Level Index
     D QUSPDSPT             2880   2880
     D*                                             IPDS Pass Through
     D QUSOURL              2881   2884B 0
     D*                                             Off Usr Rsc Libl
     D QUSNURL              2885   2888B 0
     D*                                             Nbr Usr Rsc Libl
     D QUSLURLE             2889   2892B 0
     D*                                             Len Usr Rsc Libl Entry
     D QUSRSV8              2893   2894
     D*                                             Reserved8
     D QUSCS00              2895   2895
     D*                                             Corner Stapling
     D QUSESER              2896   2896
     D*                                             Edge Stitch Edge Ref
     D QUSOFER              2897   2904P 5
     D*                                             Offset From Edge Ref
     D QUSESNS              2905   2908B 0
     D*                                             Edge Stitch Nbr Staples
     D QUSOSP               2909   2912B 0
     D*                                             Offset Staple Positions
     D QUSNOSP              2913   2916B 0
     D*                                             Nbr of Staple Positions
     D QUSLSPE              2917   2920B 0
     D*                                             Len Staple Position Entry
     D QUSFR01              2921   2930
     D*                                             Font Resolution
     D QUSRFNP              2931   2931
     D*                                             Rcd Fmt Name Present
     D QUSSSER              2932   2932
     D*                                             Saddle Stitch Edge Ref
     D QUSSSNS              2933   2936B 0
     D*                                             Saddle Stitch Nbr Staples
     D QUSOSSO              2937   2940B 0
     D*                                             Off Saddle Staple Off
     D QUSNOSSO             2941   2944B 0
     D*                                             Nbr of Saddle Stpl Off
     D QUSLSSOE             2945   2948B 0
     D*                                             Len Saddle Staple Off Entry
     D QUSDSS01             2949   2956P 0
     D*                                             Data Stream Size
     D QUSOSL               2957   2960B 0
     D*                                             Off Splf Libl
     D QUSNOL               2961   2964B 0
     D*                                             Nbr of Libraries
     D QUSLSLE              2965   2968B 0
     D*                                             Len Splf Libl Entry
     D QUSOIPPA02           2969   2972B 0
     D*                                             Off IPP Attrs
     D QUSOSRA              2973   2976B 0
     D*                                             Off SR Attrs
     D QUSSIDOJ             2977   2980B 0
     D*                                             CCSID of Job
     D QUSRSV212            2981   3152
     D*                                             Reserved2
     D QUSFMOD00            3153   3160P 5
     D*                                             Frnt Margin Off Dn
     D QUSFMOA00            3161   3168P 5
     D*                                             Frnt Margin Off Acr
     D QUSBMOD00            3169   3176P 5
     D*                                             Back Margin Off Dn
     D QUSBMOA00            3177   3184P 5
     D*                                             Back Margin Off Acr
     D QUSLOP00             3185   3192P 5
     D*                                             Length Of Page
     D QUSWOP00             3193   3200P 5
     D*                                             Width Of Page
     D QUSMM00              3201   3210
     D*                                             Measure Method
     D QUSAR01              3211   3211
     D*                                             Afp Resource
     D QUSFCS00             3212   3221
     D*                                             Font Char Set
     D QUSFCSL00            3222   3231
     D*                                             Font Char Set Lib
     D QUSCPN00             3232   3241
     D*                                             Code Page Name
     D QUSCPL00             3242   3251
     D*                                             Code Page Lib
     D QUSCFN00             3252   3261
     D*                                             Coded Font Name
     D QUSCFL00             3262   3271
     D*                                             Coded Font Lib
     D QUSCSCFN00           3272   3281
     D*                                             DBCS Coded Font Name
     D QUSCSCFL00           3282   3291
     D*                                             DBCS Coded Font Lib
     D QUSUDFIL00           3292   3301
     D*                                             User Defined File
     D QUSRO00              3302   3311
     D*                                             Reduce Output
     D QUSCBO00             3312   3312
     D*                                             Constant Back Overlay
     D QUSOB00              3313   3316B 0
     D*                                             Output Bin
     D QUSCCSID09           3317   3320B 0
     D*                                             CCSID
     D QUSUT00              3321   3420
     D*                                             User Text
     D QUSOS04              3421   3428
     D*                                             Original System
     D QUSONID00            3429   3436
     D*                                             Original Net ID
     D QUSSC00              3437   3446
     D*                                             Splf Creator
     D QUSRSV503            3447   3448
     D*                                             Reserved5
     D QUSUDOO02            3449   3452B 0
     D*                                             Usr Def Options Offset
     D QUSUDON01            3453   3456B 0
     D*                                             Usr Def Options Number
     D QUSUDOEL00           3457   3460B 0
     D*                                             Usr Def Options Entry Length
     D QUSUDD00             3461   3715
     D*                                             Usr Defined Data
     D QUSUDON02            3716   3725
     D*                                             Usr Def Object Name
     D QUSUDOL00            3726   3735
     D*                                             Usr Def Object Lib
     D QUSUDOT04            3736   3745
     D*                                             Usr Def Object Type
     D QUSRSV601            3746   3748
     D*                                             Reserved6
     D QUSCSPS00            3749   3756P 5
     D*                                             Character Set Point Size
     D QUSCFPS00            3757   3764P 5
     D*                                             Coded Font Point Size
     D QUSSCFPS00           3765   3772P 5
     D*                                             DBCS Coded Font Point Size
     D QUSSFASP00           3773   3776B 0
     D*                                             Spooled File ASP
     D QUSSFILS00           3777   3780B 0
     D*                                             Spooled File Size
     D QUSSSM03             3781   3784B 0
     D*                                             Splf Size Multiplier
     D QUSIPPJI00           3785   3788B 0
     D*                                             IPP JobId
     D QUSSCSM00            3789   3789
     D*                                             Splf Crt Security Method
     D QUSSAM00             3790   3790
     D*                                             Splf Authentication Method
     D QUSWBPD00            3791   3797
     D*                                             Wtr Begin Process Date
     D QUSWBPT00            3798   3803
     D*                                             Wtr Begin Process Time
     D QUSWCPD00            3804   3810
     D*                                             Wtr Complete Proc Date
     D QUSWCPT00            3811   3816
     D*                                             Wtr Complete Proc Time
     D QUSJSN               3817   3824
     D*                                             Job System Name
     D QUSASPDN07           3825   3834
     D*                                             Splf ASP Device Name
     D QUSSED00             3835   3841
     D*                                             Splf Expiration Date
     D*QUSOD00                       40    DIM(00001)
     D* QUSUDOO03                    10    OVERLAY(QUSOD00:00001)
     D* QUSUDOT05                    10    OVERLAY(QUSOD00:00011)
     D* QUSUDOT06                    10    OVERLAY(QUSOD00:00021)
     D* QUSUDOF01                    10    OVERLAY(QUSOD00:00031)
     D*
     D*                                 Varying length
     D*QUSURL                        10    DIM(00001)
     D* QUSURLN00                    10    OVERLAY(QUSURL:00001)
     D*
     D*                                   Varying length
     D*QUSSPD01                       8    DIM(00001)
     D* QUSSP02                      15P 5 OVERLAY(QUSSPD01:00001)
     D*
     D*                                                 Varying length
     D*QUSSSOD                        8    DIM(00001)
     D* QUSSO00                      15P 5 OVERLAY(QUSSSOD:00001)
     D*
     D*                                                 Varying length
     D*QUSSLD                        10    DIM(00001)
     D* QUSLN00                      10    OVERLAY(QUSSLD:00001)
     D*
     D*                                       Varying length
     D*QUSIPPSA00                   835    DIM(00001)
     D* QUSOIPPA03                    9B 0 OVERLAY(QUSIPPSA00:00001)
     D* QUSOIPPA04                    9B 0 OVERLAY(QUSIPPSA00:00005)
     D* QUSOIPPA05                   63    OVERLAY(QUSIPPSA00:00009)
     D* QUSIPPPN00                  127    OVERLAY(QUSIPPSA00:00072)
     D* QUSIPPJN00                  255    OVERLAY(QUSIPPSA00:00199)
     D* QUSPJNNL00                   63    OVERLAY(QUSIPPSA00:00454)
     D* QUSPPOUN00                  255    OVERLAY(QUSIPPSA00:00517)
     D* QUSOUNNL00                   63    OVERLAY(QUSIPPSA00:00772)
     D* QUSERVED52                    0    OVERLAY(QUSIPPSA00:00835)
     D*
     D*                                        Varying length

     D*      SQL COMMUNICATION AREA                                             SQL
     D SQLCA           DS                                                       SQL
     D  SQLCAID                       8A   INZ(X'0000000000000000')             SQL
     D  SQLAID                        8A   OVERLAY(SQLCAID)                     SQL
     D  SQLCABC                      10I 0                                      SQL
     D  SQLABC                        9B 0 OVERLAY(SQLCABC)                     SQL
     D  SQLCODE                      10I 0                                      SQL
     D  SQLCOD                        9B 0 OVERLAY(SQLCODE)                     SQL
     D  SQLERRML                      5I 0                                      SQL
     D  SQLERL                        4B 0 OVERLAY(SQLERRML)                    SQL
     D  SQLERRMC                     70A                                        SQL
     D  SQLERM                       70A   OVERLAY(SQLERRMC)                    SQL
     D  SQLERRP                       8A                                        SQL
     D  SQLERP                        8A   OVERLAY(SQLERRP)                     SQL
     D  SQLERR                       24A                                        SQL
     D   SQLER1                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER2                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER3                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER4                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER5                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER6                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLERRD                     10I 0 DIM(6)  OVERLAY(SQLERR)              SQL
     D  SQLWRN                       11A                                        SQL
     D   SQLWN0                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN1                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN2                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN3                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN4                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN5                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN6                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN7                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN8                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN9                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWNA                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D  SQLWARN                       1A   DIM(11) OVERLAY(SQLWRN)              SQL
     D  SQLSTATE                      5A                                        SQL
     D  SQLSTT                        5A   OVERLAY(SQLSTATE)                    SQL
     D*  END OF SQLCA                                                           SQL
     D  SQLROUTE       C                   CONST('QSYS/QSQROUTE')               SQL
     D  SQLOPEN        C                   CONST('QSYS/QSQLOPEN')               SQL
     D  SQLCLSE        C                   CONST('QSYS/QSQLCLSE')               SQL
     D  SQLCMIT        C                   CONST('QSYS/QSQLCMIT')               SQL
     D  SQFRD          C                   CONST(2)                             SQL
     D  SQFCRT         C                   CONST(8)                             SQL
     D  SQFOVR         C                   CONST(16)                            SQL
     D  SQFAPP         C                   CONST(32)                            SQL
       dcl-proc main;
         dcl-pi *n extpgm('BPCHKPDF');
         end-pi;

         dcl-pr cvtch extproc('cvtch');
           target pointer value;
           source pointer value;
           sizeTgt int(10) value;
         end-pr;

         dcl-ds mrptdir extname('MRPTDIR') end-ds;
         dcl-s rc int(10);
         dcl-s hexFID char(32);
         dcl-s strFID char(16);
         dcl-s strPath char(513);

     D                 DS                  STATIC                               OPEN
     D  SQL_00000              1      2B 0 INZ(128)                             length of header
     D  SQL_00001              3      4B 0 INZ(5)                               statement number
     D  SQL_00002              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00003              9      9A   INZ('0')                             data is okay
     D  SQL_00004             10    127A                                        end of header
     D  SQL_00005            128    128A                                        end of header
     D                 DS                  STATIC                               FETCH
     D  SQL_00006              1      2B 0 INZ(128)                             length of header
     D  SQL_00007              3      4B 0 INZ(6)                               statement number
     D  SQL_00008              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00009              9      9A   INZ('0')                             data is okay
     D  SQL_00010             10    127A                                        end of header
     D  SQL_00011            129    138A                                        FLDR
     D  SQL_00012            139    148A                                        FLDRLB
     D  SQL_00013            149    158A                                        FILNAM
     D  SQL_00014            159    168A                                        JOBNAM
     D  SQL_00015            169    178A                                        USRNAM
     D  SQL_00016            179    184A                                        JOBNUM
     D  SQL_00017            185    188B 0                                      FILNUM
     D  SQL_00018            189    192B 0                                      CHKSUM
     D  SQL_00019            193    202A                                        FRMTYP
     D  SQL_00020            203    212A                                        USRDTA
     D  SQL_00021            213    222A                                        HLDF
     D  SQL_00022            223    232A                                        SAVF
     D  SQL_00023            233    236B 0                                      TOTPAG
     D  SQL_00024            237    240B 0                                      TOTCPY
     D  SQL_00025            241    244B 0                                      LPI
     D  SQL_00026            245    248B 0                                      CPI
     D  SQL_00027            249    258A                                        OUTQNM
     D  SQL_00028            259    268A                                        OUTQLB
     D  SQL_00029            269    272B 0                                      DATFOP
     D  SQL_00030            273    276B 0                                      TIMFOP
     D  SQL_00031            277    286A                                        DEVFNA
     D  SQL_00032            287    296A                                        PGMOPF
     D  SQL_00033            297    326A                                        PRTTXT
     D  SQL_00034            327    336A                                        DEVCLS
     D  SQL_00035            337    340B 0                                      OVRLIN
     D  SQL_00036            341    350A                                        PRTFON
     D  SQL_00037            351    354B 0                                      PAGROT
     D  SQL_00038            355    358B 0                                      MAXSIZ
     D  SQL_00039            359    362B 0                                      ADSF
     D  SQL_00040            363    366B 0                                      EXPDAT
     D  SQL_00041            367    370B 0                                      LOCSFA
     D  SQL_00042            371    374B 0                                      LOCSFD
     D  SQL_00043            375    378B 0                                      LOCSFP
     D  SQL_00044            379    382B 0                                      LOCSFC
     D  SQL_00045            383    386B 0                                      PAGSIZ
     D  SQL_00046            387    387A                                        RECOVR
     D  SQL_00047            388    397A                                        REPIND
     D  SQL_00048            398    407A                                        RPIXNM
     D  SQL_00049            408    417A                                        DFTPRT
     D  SQL_00050            418    447A                                        DPDESC
     D  SQL_00051            448    448A                                        REPLOC
     D  SQL_00052            449    458A                                        OFRVOL
     D  SQL_00053            459    462B 0                                      OFRDAT
     D  SQL_00054            463    472A                                        OFRNAM
     D  SQL_00055            473    473A                                        PKVER
     D  SQL_00056            474    474A                                        APFTYP
     D  SQL_00057            475    475A                                        OFRSYS
     D  SQL_00058            476    476A                                        OFRTYP
     D  SQL_00059            477    480A                                        OFRSEQ
     D  SQL_00060            481    484B 0                                      MDATOP
     D  SQL_00061            485    488B 0                                      MTIMOP
     D  SQL_00062            489    489A                                        FILLR3
     D  SQL_00063            490    499A                                        RPTTYP
     D  SQL_00064            500    515A                                        MRHASH
     D                 DS                  STATIC                               FETCH
     D  SQL_00065              1      2B 0 INZ(128)                             length of header
     D  SQL_00066              3      4B 0 INZ(7)                               statement number
     D  SQL_00067              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00068              9      9A   INZ('0')                             data is okay
     D  SQL_00069             10    127A                                        end of header
     D  SQL_00070            129    138A                                        FLDR
     D  SQL_00071            139    148A                                        FLDRLB
     D  SQL_00072            149    158A                                        FILNAM
     D  SQL_00073            159    168A                                        JOBNAM
     D  SQL_00074            169    178A                                        USRNAM
     D  SQL_00075            179    184A                                        JOBNUM
     D  SQL_00076            185    188B 0                                      FILNUM
     D  SQL_00077            189    192B 0                                      CHKSUM
     D  SQL_00078            193    202A                                        FRMTYP
     D  SQL_00079            203    212A                                        USRDTA
     D  SQL_00080            213    222A                                        HLDF
     D  SQL_00081            223    232A                                        SAVF
     D  SQL_00082            233    236B 0                                      TOTPAG
     D  SQL_00083            237    240B 0                                      TOTCPY
     D  SQL_00084            241    244B 0                                      LPI
     D  SQL_00085            245    248B 0                                      CPI
     D  SQL_00086            249    258A                                        OUTQNM
     D  SQL_00087            259    268A                                        OUTQLB
     D  SQL_00088            269    272B 0                                      DATFOP
     D  SQL_00089            273    276B 0                                      TIMFOP
     D  SQL_00090            277    286A                                        DEVFNA
     D  SQL_00091            287    296A                                        PGMOPF
     D  SQL_00092            297    326A                                        PRTTXT
     D  SQL_00093            327    336A                                        DEVCLS
     D  SQL_00094            337    340B 0                                      OVRLIN
     D  SQL_00095            341    350A                                        PRTFON
     D  SQL_00096            351    354B 0                                      PAGROT
     D  SQL_00097            355    358B 0                                      MAXSIZ
     D  SQL_00098            359    362B 0                                      ADSF
     D  SQL_00099            363    366B 0                                      EXPDAT
     D  SQL_00100            367    370B 0                                      LOCSFA
     D  SQL_00101            371    374B 0                                      LOCSFD
     D  SQL_00102            375    378B 0                                      LOCSFP
     D  SQL_00103            379    382B 0                                      LOCSFC
     D  SQL_00104            383    386B 0                                      PAGSIZ
     D  SQL_00105            387    387A                                        RECOVR
     D  SQL_00106            388    397A                                        REPIND
     D  SQL_00107            398    407A                                        RPIXNM
     D  SQL_00108            408    417A                                        DFTPRT
     D  SQL_00109            418    447A                                        DPDESC
     D  SQL_00110            448    448A                                        REPLOC
     D  SQL_00111            449    458A                                        OFRVOL
     D  SQL_00112            459    462B 0                                      OFRDAT
     D  SQL_00113            463    472A                                        OFRNAM
     D  SQL_00114            473    473A                                        PKVER
     D  SQL_00115            474    474A                                        APFTYP
     D  SQL_00116            475    475A                                        OFRSYS
     D  SQL_00117            476    476A                                        OFRTYP
     D  SQL_00118            477    480A                                        OFRSEQ
     D  SQL_00119            481    484B 0                                      MDATOP
     D  SQL_00120            485    488B 0                                      MTIMOP
     D  SQL_00121            489    489A                                        FILLR3
     D  SQL_00122            490    499A                                        RPTTYP
     D  SQL_00123            500    515A                                        MRHASH
     D                 DS                  STATIC                               CLOSE
     D  SQL_00124              1      2B 0 INZ(128)                             length of header
     D  SQL_00125              3      4B 0 INZ(8)                               statement number
     D  SQL_00126              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00127              9      9A   INZ('0')                             data is okay
     D  SQL_00128             10    127A                                        end of header
     D  SQL_00129            128    128A                                        end of header
       //*  exec sql set option closqlcsr=*endmod,commit=*none;

       //*  exec sql declare c1 cursor for select * from mrptdir
       //*    where apftyp = '4';
       //*  exec sql open c1;
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00002     IFEQ      0                                            SQL
     C     SQL_00003     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00000                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00000                      SQL
     C                   END                                                    SQL
       //*  exec sql fetch c1 into :mrptdir;
     C                   Z-ADD     -4            SQLER6                         SQL   6
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00006                      SQL
     C     SQL_00009     IFEQ      '1'                                          SQL
     C                   EVAL      FLDR = SQL_00011                             SQL
     C                   EVAL      FLDRLB = SQL_00012                           SQL
     C                   EVAL      FILNAM = SQL_00013                           SQL
     C                   EVAL      JOBNAM = SQL_00014                           SQL
     C                   EVAL      USRNAM = SQL_00015                           SQL
     C                   EVAL      JOBNUM = SQL_00016                           SQL
     C                   EVAL      FILNUM = SQL_00017                           SQL
     C                   EVAL      CHKSUM = SQL_00018                           SQL
     C                   EVAL      FRMTYP = SQL_00019                           SQL
     C                   EVAL      USRDTA = SQL_00020                           SQL
     C                   EVAL      HLDF = SQL_00021                             SQL
     C                   EVAL      SAVF = SQL_00022                             SQL
     C                   EVAL      TOTPAG = SQL_00023                           SQL
     C                   EVAL      TOTCPY = SQL_00024                           SQL
     C                   EVAL      LPI = SQL_00025                              SQL
     C                   EVAL      CPI = SQL_00026                              SQL
     C                   EVAL      OUTQNM = SQL_00027                           SQL
     C                   EVAL      OUTQLB = SQL_00028                           SQL
     C                   EVAL      DATFOP = SQL_00029                           SQL
     C                   EVAL      TIMFOP = SQL_00030                           SQL
     C                   EVAL      DEVFNA = SQL_00031                           SQL
     C                   EVAL      PGMOPF = SQL_00032                           SQL
     C                   EVAL      PRTTXT = SQL_00033                           SQL
     C                   EVAL      DEVCLS = SQL_00034                           SQL
     C                   EVAL      OVRLIN = SQL_00035                           SQL
     C                   EVAL      PRTFON = SQL_00036                           SQL
     C                   EVAL      PAGROT = SQL_00037                           SQL
     C                   EVAL      MAXSIZ = SQL_00038                           SQL
     C                   EVAL      ADSF = SQL_00039                             SQL
     C                   EVAL      EXPDAT = SQL_00040                           SQL
     C                   EVAL      LOCSFA = SQL_00041                           SQL
     C                   EVAL      LOCSFD = SQL_00042                           SQL
     C                   EVAL      LOCSFP = SQL_00043                           SQL
     C                   EVAL      LOCSFC = SQL_00044                           SQL
     C                   EVAL      PAGSIZ = SQL_00045                           SQL
     C                   EVAL      RECOVR = SQL_00046                           SQL
     C                   EVAL      REPIND = SQL_00047                           SQL
     C                   EVAL      RPIXNM = SQL_00048                           SQL
     C                   EVAL      DFTPRT = SQL_00049                           SQL
     C                   EVAL      DPDESC = SQL_00050                           SQL
     C                   EVAL      REPLOC = SQL_00051                           SQL
     C                   EVAL      OFRVOL = SQL_00052                           SQL
     C                   EVAL      OFRDAT = SQL_00053                           SQL
     C                   EVAL      OFRNAM = SQL_00054                           SQL
     C                   EVAL      PKVER = SQL_00055                            SQL
     C                   EVAL      APFTYP = SQL_00056                           SQL
     C                   EVAL      OFRSYS = SQL_00057                           SQL
     C                   EVAL      OFRTYP = SQL_00058                           SQL
     C                   EVAL      OFRSEQ = SQL_00059                           SQL
     C                   EVAL      MDATOP = SQL_00060                           SQL
     C                   EVAL      MTIMOP = SQL_00061                           SQL
     C                   EVAL      FILLR3 = SQL_00062                           SQL
     C                   EVAL      RPTTYP = SQL_00063                           SQL
     C                   EVAL      MRHASH = SQL_00064                           SQL
     C                   END                                                    SQL
         dow sqlcod = 0;
           clear qusa0200;
           if getArcAtr(repind:%addr(qusa0200):%size(qusa0200):0) = 0 and
             qusud00 <> ' ';
             dltArcAtr(repind); // Remove the mrptatr record.
             clear qusudd00; // Clear the file id info.
             // Write the updated mrptatr record.
             rc = putArcAtr(repind:%addr(qusa0200));
           endif;

       //    hexFID = qusudd00;
       //    cvtch(%addr(strFID):%addr(hexFID):%size(hexFID));
       //    clear strpath;
       //    getPath(%addr(strPath):%size(strPath):%addr(strFID));
       //*    exec sql fetch c1 into :mrptdir;
     C                   Z-ADD     -4            SQLER6                         SQL   7
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00065                      SQL
     C     SQL_00068     IFEQ      '1'                                          SQL
     C                   EVAL      FLDR = SQL_00070                             SQL
     C                   EVAL      FLDRLB = SQL_00071                           SQL
     C                   EVAL      FILNAM = SQL_00072                           SQL
     C                   EVAL      JOBNAM = SQL_00073                           SQL
     C                   EVAL      USRNAM = SQL_00074                           SQL
     C                   EVAL      JOBNUM = SQL_00075                           SQL
     C                   EVAL      FILNUM = SQL_00076                           SQL
     C                   EVAL      CHKSUM = SQL_00077                           SQL
     C                   EVAL      FRMTYP = SQL_00078                           SQL
     C                   EVAL      USRDTA = SQL_00079                           SQL
     C                   EVAL      HLDF = SQL_00080                             SQL
     C                   EVAL      SAVF = SQL_00081                             SQL
     C                   EVAL      TOTPAG = SQL_00082                           SQL
     C                   EVAL      TOTCPY = SQL_00083                           SQL
     C                   EVAL      LPI = SQL_00084                              SQL
     C                   EVAL      CPI = SQL_00085                              SQL
     C                   EVAL      OUTQNM = SQL_00086                           SQL
     C                   EVAL      OUTQLB = SQL_00087                           SQL
     C                   EVAL      DATFOP = SQL_00088                           SQL
     C                   EVAL      TIMFOP = SQL_00089                           SQL
     C                   EVAL      DEVFNA = SQL_00090                           SQL
     C                   EVAL      PGMOPF = SQL_00091                           SQL
     C                   EVAL      PRTTXT = SQL_00092                           SQL
     C                   EVAL      DEVCLS = SQL_00093                           SQL
     C                   EVAL      OVRLIN = SQL_00094                           SQL
     C                   EVAL      PRTFON = SQL_00095                           SQL
     C                   EVAL      PAGROT = SQL_00096                           SQL
     C                   EVAL      MAXSIZ = SQL_00097                           SQL
     C                   EVAL      ADSF = SQL_00098                             SQL
     C                   EVAL      EXPDAT = SQL_00099                           SQL
     C                   EVAL      LOCSFA = SQL_00100                           SQL
     C                   EVAL      LOCSFD = SQL_00101                           SQL
     C                   EVAL      LOCSFP = SQL_00102                           SQL
     C                   EVAL      LOCSFC = SQL_00103                           SQL
     C                   EVAL      PAGSIZ = SQL_00104                           SQL
     C                   EVAL      RECOVR = SQL_00105                           SQL
     C                   EVAL      REPIND = SQL_00106                           SQL
     C                   EVAL      RPIXNM = SQL_00107                           SQL
     C                   EVAL      DFTPRT = SQL_00108                           SQL
     C                   EVAL      DPDESC = SQL_00109                           SQL
     C                   EVAL      REPLOC = SQL_00110                           SQL
     C                   EVAL      OFRVOL = SQL_00111                           SQL
     C                   EVAL      OFRDAT = SQL_00112                           SQL
     C                   EVAL      OFRNAM = SQL_00113                           SQL
     C                   EVAL      PKVER = SQL_00114                            SQL
     C                   EVAL      APFTYP = SQL_00115                           SQL
     C                   EVAL      OFRSYS = SQL_00116                           SQL
     C                   EVAL      OFRTYP = SQL_00117                           SQL
     C                   EVAL      OFRSEQ = SQL_00118                           SQL
     C                   EVAL      MDATOP = SQL_00119                           SQL
     C                   EVAL      MTIMOP = SQL_00120                           SQL
     C                   EVAL      FILLR3 = SQL_00121                           SQL
     C                   EVAL      RPTTYP = SQL_00122                           SQL
     C                   EVAL      MRHASH = SQL_00123                           SQL
     C                   END                                                    SQL
         enddo;
       //*  exec sql close c1;
     C                   Z-ADD     8             SQLER6                         SQL
     C     SQL_00126     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00124                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00124                      SQL
     C                   END                                                    SQL

         *inlr = *on;

       end-proc;



      *%METADATA                                                       *
      * %TEXT Restore a spooled file saved with GETSPLF                *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp('DOCMGR') bnddir('SPYBNDDIR')
      ***********---------------------------------------------------
      *  MAPUTSPFP - restore a spooled file that was saved using GETSPLF
      ***********---------------------------------------------------
      *
/7201 * 10-16-02 JMO Created this program to replace the old GETSPLF pgm
      *
      ******************************************************************************
     FInput     IF   F 9999        Disk    INFDS(OpnFdBk)
     D
     D SetSplAttr      PR            10i 0 extproc('setSplfAttrs')
     D  pSplRcd                        *   value
     D  pAtrRcd                        *   value
     D  AtrLen                       10i 0 value
     D
      * copy QUSRSPLA data structures
      /copy qsysinc/qrpglesrc,qusrspla
     D
      * copy prototypes for Spool file functions
      /copy qrpglesrc,@masplio
     D
     D* Program status data structure
     D PSDS           SDS
     D UserPrf               254    263
     D
     D* File open feedback data area
     D OpnFdBk         DS
     D  RcdLen               125    126i 0
     D
     D
     D* spool file data structure
     D Spoolrcd        DS          8192
     D
     D OldFmt          S              1
     D sHndl           S             10i 0 Inz(-1)
     D rc              S             10i 0
     D AtrLen          S             10i 0
     D RcvLen          S             10i 0
     D pSplRcd         S               *   Inz(%addr(Spoolrcd))
     D pAtrRcd         S               *   Inz(%addr(QUSA0200))
     D
     D* Miscellaneous variables/constants
     D Yes             C                   Const('Y')
     D No              C                   Const('N')
     D
     D SplData         DS          9999
     D  AttrLen                1      4b 0
     D  AttrChk                1      4
     D  TypeFlag              13     20
     D  RecData1st             5   8192
     D  RecData                1   8192
     D
     C******************************************************************************
     C* Mainline                                                                   *
     C******************************************************************************
     C
     C     *entry        Plist
     C                   Parm                    FileName         20
     C                   Parm                    OutQ             20
     C                   Parm                    MbrName          10
     C                   Parm                    UserOpt          10
     C* error fields for returning message ID and data to calling pgm
     C                   Parm                    ErrId             7
     C                   Parm                    ErrDta          200
     C
     C* read in attribute record(s)
     C                   Exsr      GetAtrRcd
     C
     C* if file has "old" format then run "old" pgm.
     C                   If        OldFmt = Yes
     C
     C                   Call      'QSPPUTF'
     C                   Parm                    FileName
     C                   Parm                    OutQ
     C                   Parm                    MbrName
     C
     C                   Else
     C
     C* Set user name for new spool file
     C                   If        UserOpt = '*CURRENT'
     C                             or Qusun13 = *blanks
     C                   Eval      Qusun13 = UserPrf
     C                   Endif
     C
     C* set new Outq
     C                   Eval      Quson01 = %subst(Outq:1:10)
     C                   Eval      Qusol01 = %subst(Outq:11:10)
     C

      * change attributes of 'bad' spool file to match 'good' spool file.

      * Bytes available. ***Unable to change this attribute on the fly.***
     c*                  eval      QUSBA08 = 3931
      * Record length.
     c*                  eval      QUSRL06 = 0
      * Max records.
     c*                  eval      QUSMR00 = 100000
      * Program name & library
     c*                  eval      QUSPN00 = ' '
     c*                  eval      QUSPL02 = ' '
      * Accounting code.
     c*                  eval      QUSCC02 = '*SYS'
      * Number of disk records.
     c*                  eval      QUSNDR = 307
      * Max data record size
     c                   eval      QUSMDRS = 8013

     C* create spool file
     C                   Eval      sHndl = crtSplf(%addr(QUSA0200))
     C                   If        sHndl < 0
     C                   Eval      ErrId = 'CMD0326'
     C                   Exsr      EndPgm
     C                   Endif
     C
     C* read thru all records
     C                   Dou       %eof(Input)
     C                   Read      Input         SplData
     C                   If        %eof(Input)
     C                   Leave
     C                   Endif
     C
     C* write spool file data
     C                   Eval      rc = putSplRcd(sHndl:%addr(SplData))
     C                   If        rc < 0
     C                   Eval      ErrId = 'CMD0327'
     C                   Exsr      EndPgm
     C                   Endif
     C
     C                   Enddo
     C
     C                   Endif
     C
     C                   Exsr      EndPgm
     C******************************************************************************
     C* EndPgm - End the program                                                   *
     C******************************************************************************
     C     EndPgm        Begsr
     C
     C* check for open spool file handle
     C                   If        sHndl >= 0
     C* Close the spool file
     C                   Eval      rc = cloSplf(sHndl)
     C                   If        rc < 0
     C                             and ErrId = *blanks
     C                   Eval      ErrId = 'CMD0328'
     C                   Endif
     C                   Endif
     C
     C                   Eval      *inlr = *on
     C                   Return
     C
     C                   Endsr
     C******************************************************************************
     C* GetAtrRcd - get the attribute record(s) and put info in data structure     *
     C******************************************************************************
     C     GetAtrRcd     Begsr
     C
     C* Read first record
     C                   Read      Input         SplData                  90
     C                   If        *in90 = *on
     C                   Eval      ErrId = 'CMD0329'
     C                   Eval      ErrDta = FileName
     C                   Exsr      EndPgm
     C                   Endif
     C
     C* Check for invalid file
     C                   If        TypeFlag <> 'SPLA0200' and
     C                             (AttrChk = x'40404040' or
     C                             (AttrLen > 8192 or
     C                              AttrLen < 512))
     C                   Eval      ErrId = 'CMD0330'
     C                   Eval      ErrDta = FileName
     C                   Exsr      EndPgm
     C                   Endif
     C
     C* check for "old" attribute info structure
     C                   If        TypeFlag <> 'SPLA0200'
     C
     C                   Eval      OldFmt = Yes
     C
     C* if file is using "new" attribute format
     C                   Else
     C
     C* get attributes length
     C                   Z-add     AttrLen       AtrLen
     C* get length of attributes received in first record
     C                   Eval      RcvLen = rcdLen - 4
     C                   Eval      Spoolrcd = %subst(RecData1st:1:RcvLen)
     C
     C                   Dow       not %eof(Input) and
     C                             RcvLen < AtrLen
     C                   Read      Input         SplData
     C                   If        %eof(Input)
     C                   Eval      ErrId = 'CMD0330'
     C                   Eval      ErrDta = FileName
     C                   Exsr      EndPgm
     C                   Endif
     C
     C                   Eval      Spoolrcd = %subst(Spoolrcd:1:RcvLen) +
     C                             %subst(RecData:1:rcdLen)
     C                   Eval      RcvLen = RcvLen + rcdLen
     C
     C                   Enddo
     C
     C                   Eval      QUSA0200 = SpoolRcd
     C
     C                   Endif
     C
     C                   Endsr

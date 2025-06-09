      *%METADATA                                                       *
      * %TEXT Convert RARCHIVE to R8.2 version                         *
      *%EMETADATA                                                      *
      * CRTCMD OVRDBF FILE(RARCHIVNEW) TOFILE(RARCHIVE)
      * CRTCMD OVRDBF FILE(RARCHIVOLD) TOFILE(RARCHIVE)
      *------------------------------------------------------------------------
      *- CNVRARCHIV - Handle conversion of RARCHIVE from pre-R8.5 to R8.5
      *------------------------------------------------------------------------
      *
      * Prior to the change in R8.5 RARCHIVE had not been changed since before R6.0
      *
      * 11-17-2003 JMO created program
      *
      * Update History
      *------------------------------------------------------------------------
      *   Date   Initials Description
      *------------------------------------------------------------------------
      * 5-12-2004 JMO - Added opcode parm for compatibility.  V=Validation, I=Install
      *                  Also, added logic to check for format level check.
      *------------------------------------------------------------------------
      *  Program Notes:
      *
      *   Uses a CPYF command to copy the original data
      *   into the new file.
      *   Then reads records in from RARCHIVNEW in the Install library
      *   and writes them to RARCHIVOLD in the "&SPYDTA" library
      *------------------------------------------------------------------------
     fRarchivOldo  a e             Disk    rename(Arcrc:out) usropn
     fRarchivNewif   e             Disk    rename(Arcrc:in) usropn

      /copy qsysinc/qrpglesrc,Qusrspla
      /copy qsysinc/qrpglesrc,Qusec
     d ErrDta                 17    216a

      * API list header info
     d APIHdrDS        ds                  based(pSpcHdr)
     d  LstOff               125    128b 0
     d  NbrOfEnts            133    136b 0
     d  SizeOfEnt            137    140b 0

      * API list entries
     d APILstDS        ds                  based(pSpcLst)
     d  DepFilNm              31     40
     d  DepLibNm              41     50
     d  DepMbrNm              51     60
     d  LogicalDta            31     60

      * status data structure
     d psds           sds
     d SysErr                 40     46a
     d ErrDta2                91    170a

      * misc variables
     d LFDta           s             30a   dim(100)
     d LFCount         s              9b 0
     d newFilnum       s              9b 0
     d RcvLen          s              9b 0
     d SplNbr          s              9b 0
     d BeenHere        s               n   inz(*off)
     d pSpace          s               *   inz(*NULL)
     d qSpcName        s             20a
     d InitSz          s              9b 0
     d CmdStr          s            300a
     d RmvLib          s             10a
     d AddLib          s             10a

     c*-------------------------------------------------------------------------
     c* mainline
     c*-------------------------------------------------------------------------
     c     *entry        plist
     c                   parm                    OpCode            1
     c                   parm                    ObjName          10
     c                   parm                    InstLib          10
     c                   parm                    OrigLib          10
     c                   parm                    OldRelease        3
     c                   parm                    NewRelease        3
     c                   parm                    RtnCode           1

     c                   eval      RtnCode = '0'

      * if this is a "V"alidation then leave without doing anything
      *   or if the object is not the physical file then leave
     c                   if        OpCode = 'V'
     c                             or ObjName <> 'RARCHIVE'
     c                   exsr      Quit
     c                   endif

      *  If current release is R8.5 or later check for a file level change and leave
     c                   if        OldRelease >= '805'
     c                   exsr      ChkFmtLvl
     c                   exsr      Quit
     c                   endif

      * create the user space
     c                   exsr      CrtUsrSpc

      * remove the members for all the logical files in the Install library
      *  (this is done in order to speed up the update process)
     c                   eval      RmvLib = InstLib
     c                   exsr      RmvMbrs

      * copy the original file to the new file in the install library
     c                   eval      cmdStr = 'CPYF FROMFILE(' + %trim(OrigLib) +
     c                             '/RARCHIVE) TOFILE(' + %trim(InstLib) +
     c                             '/RARCHIVE) MBROPT(*REPLACE) FMTOPT(*MAP ' +
     c                             '*DROP)'
     c                   exsr      runcl

      * IF THE PROCESS FAILS BEYOND THIS POINT THEN THE RARCHIVE FILE WILL NEED TO
      *   BE RESTORED PRIOR TO RE-RUNNING THE INSTALL.

      * delete the original file and logicals
     c                   exsr      DltOrig

      * put a duplicate copy of the new file and logicals in the old library
     c                   exsr      CreateDup

      * override the original database file
     c                   eval      cmdStr = 'OVRDBF FILE(RARCHIVOLD) TOFILE(' +
     c                             %trim(OrigLib) + '/RARCHIVE) OVRSCOPE(*JOB)'
     c                   exsr      runcl

      * override the new database file
     c                   eval      cmdStr = 'OVRDBF FILE(RARCHIVNEW) TOFILE(' +
     c                             %trim(InstLib) + '/RARCHIVE) OVRSCOPE(*JOB)'
     c                   exsr      runcl

      * open the old file
     c                   open(e)   RarchivOld
     c                   if        %error
     c                   eval      rtnCode = '3'
     c                   exsr      Quit
     c                   endif

      * open the new file
     c                   open(e)   RarchivNew
     c                   if        %error
     c                   eval      rtnCode = '3'
     c                   exsr      Quit
     c                   endif

      * read thru entire New file (just had data copied to it)
     c                   dou       *inlr = *on
     c                   Read      in                                     lr
     c                   if        *inlr = *on
     c                   leave
     c                   endif

      * get Spool file attributes
     c                   eval      qjobnam = Ajobna + Ausrna + Ajobnu
     c                   call      'QUSRSPLA'
     c                   parm                    Qusa0200
     c                   parm      8192          rcvlen
     c                   parm      'SPLA0200'    fmtname
     c                   parm                    Qjobnam          26
     c                   parm      *blanks       Intjob           16
     c                   parm      *blanks       IntSpl           16
     c                   parm      AFILNA        SplName          10
     c                   parm      AFILNU        SplNbr
     c                   parm                    Qusec

      * if no spool file found then skip this record
     c                   if        Qusbavl > 0
     c                   iter
     c                   endif

     c                   eval      aDatfo = 0
     c                   move      Qusdfilo00    aDatfo

      * output to original SPYDATA library
     c                   write     out

     c                   enddo

     c                   exsr      Quit
     c*------------------------------------------------------------------------
     c* *pssr - program error subroutine
     c*------------------------------------------------------------------------
     c     *pssr         begsr

     c                   eval      RtnCode = '3'
     c                   exsr      Quit

     c                   endsr
     c*------------------------------------------------------------------------
     c* ChkFmtLvl - Check for a format level change
     c*------------------------------------------------------------------------
     c     ChkFmtLvl     begsr

     c                   call      'CHKFMTLVL'
     c                   parm                    OpCode            1
     c                   parm                    ObjName          10
     c                   parm                    InstLib          10
     c                   parm                    OrigLib          10
     c                   parm                    OldRelease        3
     c                   parm                    NewRelease        3
     c                   parm                    RtnCode           1

     c                   endsr
     c*------------------------------------------------------------------------
     c* RunCL - run a cl command
     c*------------------------------------------------------------------------
     c     runcl         begsr

      * get command length
     c                   eval      strlen = %len(%trim(Cmdstr))

      * execute command
     c                   call      'QCMDEXC'                            50
     c                   parm                    CmdStr
     c                   parm                    StrLen           15 5

      * check for command failure
     c                   if        *in50 = *on

     c                   select

      * empty file cannot be copied.
     c                   when      %subst(Cmdstr:1:4) = 'CPYF'
     c                             and (SysErr = 'CPF2869' or
     c                              SysErr = 'CPF2817')
     c                   eval      *in50 = *off

      * failure to remove override.
     c                   when      %subst(Cmdstr:1:6) = 'DLTOVR'
     c                   eval      *in50 = *off

     c                   other

     c                   eval      RtnCode = '3'
     c                   exsr      Quit

     c                   endsl
     c                   endif

     c                   endsr
     c*------------------------------------------------------------------------
     c* CrtUsrSpc - Create the user space to be used for List APIs
     c*------------------------------------------------------------------------
     c     CrtUsrSpc     Begsr

      * create a user space to receive the database relations
     c                   eval      qSpcName = 'DBR       QTEMP'
     c                   eval      qusbavl = 0
     c                   eval      qusbprv = 216

     c                   call      'QUSCRTUS'
     c                   parm                    qSpcName
     c                   parm      *blanks       ExtAttr          10
     c                   parm      102400        InitSz
     c                   parm      x'00'         InitVal           1
     c                   parm      '*ALL'        PubAuth          10
     c                   parm      'Temp UsrSpc' Desc             50
     c                   parm      '*YES'        Replace          10
     c                   parm                    Qusec

      * check for API failure
     c                   if        Qusbavl > 0
     c                   eval      rtnCode = '3'
     c                   exsr      quit
     c                   endif

      * get a pointer to the User Space
     c                   call      'QUSPTRUS'
     c                   parm                    qSpcName
     c                   parm                    pSpace
     c                   parm                    Qusec

      * check for API failure
     c                   if        Qusbavl > 0
     c                   eval      rtnCode = '3'
     c                   exsr      quit
     c                   endif

     c                   endsr
     c*------------------------------------------------------------------------
     c* RtvDbrList  - Retreive database relations list
     c*------------------------------------------------------------------------
     c     RtvDbrList    Begsr

      * get a list of the database relations
     c                   call      'QDBLDBR'
     c                   parm                    qSpcName         20
     c                   parm      'DBRL0200'    fmtname           8
     c                   parm                    qFileName        20
     c                   parm      '*ALL'        members          10
     c                   parm      *blanks       formats          10
     c                   parm                    Qusec

     c                   if        Qusbavl > 0
     c                   eval      rtnCode = '3'
     c                   exsr      quit
     c                   endif

     c                   Endsr
     c*------------------------------------------------------------------------
     c* RmvMbrs - Remove logical file members
     c*------------------------------------------------------------------------
     c     RmvMbrs       begsr

      * Get the List of dependent files (i.e. logicals)
     c                   eval      qFileName = 'RARCHIVE  ' + RmvLib
     c                   exsr      RtvDbrList

      * set pointer to list API header info
     c                   eval      pSpcHdr = pSpace

      * keep the total number of entries for use later in re-creating the logical files.
     c                   eval      LFCount = NbrOfEnts

      * remove the members for all the RARCHIVE logical files
      *  (this is done in order to speed up the update process)
     c                   do        NbrOfEnts     CurEnt            5 0
     c                   eval      pSpcLst = pSpace + LstOff +
     c                             ((CurEnt - 1) * SizeOfEnt)

     c                   if        DepFilNm <> '*NONE'
     c                   eval      cmdStr = 'RMVM FILE(' + %trim(DepLibNm) +
     c                             '/' + %trim(DepFilNm) + ') MBR(' +
     c                             %trim(DepMbrNm) + ')'
     c                   exsr      runcl

      * keep list of logicals for use later in re-creating them.
     c                   eval      LFDta(CurEnt) = LogicalDta
     c
     c                   endif

     c                   enddo

     c                   endsr
     c*------------------------------------------------------------------------
     c* DltOrig - Delete original file and logicals
     c*------------------------------------------------------------------------
     c     DltOrig       Begsr

      * Get the List of dependent files (i.e. logicals)
     c                   eval      qFileName = 'RARCHIVE  ' + OrigLib
     c                   exsr      RtvDbrList

      * set pointer to list API header info
     c                   eval      pSpcHdr = pSpace

      * Delete the logical files first
     c                   do        NbrOfEnts     CurEnt            5 0
     c                   eval      pSpcLst = pSpace + LstOff +
     c                             ((CurEnt - 1) * SizeOfEnt)

     c                   if        DepFilNm <> '*NONE'
     c                   eval      cmdStr = 'DLTF FILE(' + %trim(DepLibNm) +
     c                             '/' + %trim(DepFilNm) + ')'
     c                   exsr      runcl
     c                   endif

     c                   enddo

      * delete the original physical file
     c                   eval      cmdStr = 'DLTF FILE(' + %trim(OrigLib) +
     c                             '/RARCHIVE)'
     c                   exsr      runcl

     c                   endsr
     c*------------------------------------------------------------------------
     c* CreateDup - Create dupicate file and logicals in Original SPYDATA library
     c*------------------------------------------------------------------------
     c     CreateDup     Begsr

      * create a duplicate of RARCHIVE from the Install library
     c                   eval      cmdStr = 'CRTDUPOBJ OBJ(RARCHIVE) FROMLIB('+
     c                             %trim(InstLib) + ') OBJTYPE(*FILE)' +
     c                             ' TOLIB(' + %trim(OrigLib) + ') DATA(*NO)'
     c                   exsr      runcl

      * Use the original list of dependent files (i.e. logicals)

      * set the list pointer to the beginning of the user space (position makes no difference)
     c                   eval      pSpcLst = pSpace

      * Create duplicate logical files and add the logical members
     c                   do        LFCount       CurEnt            5 0
     c                   eval      LogicalDta = LFDta(CurEnt)

     c                   if        DepFilNm <> '*NONE'
      * create logical file
     c                   eval      cmdStr = 'CRTDUPOBJ OBJ(' + %trim(DepFilNm) +
     c                              ') FROMLIB('+
     c                             %trim(DepLibNm) + ') OBJTYPE(*FILE)' +
     c                             ' TOLIB(' + %trim(OrigLib) + ') DATA(*NO)'
     c                   exsr      runcl

      * add logical members
     c                   eval      cmdStr = 'ADDLFM FILE(' + %trim(OrigLib) +
     c                             '/' + %trim(DepFilNm) + ') MBR(' +
     c                             %trim(DepMbrNm) + ') DTAMBRS((' +
     c                             %trim(OrigLib) + '/RARCHIVE (RARCHIVE)))'
     c                   exsr      runcl
     c                   endif

     c                   enddo

     c                   endsr
     c*------------------------------------------------------------------------
     c* Quit - end program
     c*------------------------------------------------------------------------
     c     Quit          begsr

      * if we have already been here then end immediately
     c                   if        BeenHere
     c                   eval      *inlr = *on
     c                   return
     c                   else
     c                   eval      BeenHere = *on
     c                   endif

      * close old file
     c                   if        %open(RarchivOld)
     c                   close(e)  RarchivOld
     c                   endif

      * close new file
     c                   if        %open(RarchivNew)
     c                   close(e)  RarchivNew
     c                   endif

      * remove database ovrrride Old file
     c                   eval      cmdstr = 'DLTOVR FILE(RARCHIVOLD) LVL(*JOB)'
     c                   exsr      runcl

      * remove database ovrrride New file
     c                   eval      cmdstr = 'DLTOVR FILE(RARCHIVNEW) LVL(*JOB)'
     c                   exsr      runcl

     c                   eval      *inlr = *on
     c                   return

     c                   endsr

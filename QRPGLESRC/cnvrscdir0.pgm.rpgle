      *%METADATA                                                       *
      * %TEXT Convert MRscDir to R8.5 version                          *
      *%EMETADATA                                                      *
      /copy directives
      *------------------------------------------------------------------------
      *- CNVRSCDIR - Handle conversion of MRSCDIR from pre-R8.5 to R8.5
      *------------------------------------------------------------------------
      *
      * Prior to the change in R8.5 MRSCDIR had not been changed since before R6.0.3
      *
      * Return Code descriptions:
      * '0' = Processing completed successfully.  No errors.
      * '1' = Resource library could not be created
      * '2' = Resource library create failed.
      * '3' = Unidentified error.  *PSSR was executed.
      * '4' = Could not generate/retrieve next resource ID
      * '5' = Could not create the work file
      * '6' = Could not clear the work file
      * '7' = Could not open the work file
      * '8' = Delete override failed for work file.
      * '9' = Update to MHEADER failed.
      *
      * Update History
      *
      * 10-22-2004 JMO created program
      *-------------------------------------------------------------------------
     fMrscdir1  uf   e           k Disk
     fMrscdta   if   e           k Disk
     fMHeader   uf   e             Disk    usropn

     d openWorkFile    pr            10i 0 extproc('openWorkFile')
     d pQualName                       *   value
     d nNameLen                      10i 0 value
     d pWorkFile                       *

     d closeWorkFile   pr            10i 0 extproc('closeWorkFile')
     d pWorkFile                       *   value

     d writeRscData    pr            10i 0 extproc('writeRscData')
     d pData                           *   value
     d nDataLen                      10i 0 value
     d pWorkFile                       *   value
/3465
/3465d GetNum          pr                  extpgm('GETNUM')
/3465d  OpCode                        6a   const
/3465d  GetType                      10a   const
/3465d  RtnValue                     10a
/3465d  LrgRtnVal                    15p 0

      /copy qsysinc/qrpglesrc,Qusec
     d ErrDta                 17    216a

      * status data structure
     d SysDft          ds          1024    Dtaara
     d  AFPXLB               879    888

      * status data structure
     d psds           sds
     d SysErr                 40     46a
     d ErrDta2                91    170a
     d usrnam                254    263a

      * misc variables
     d BeenHere        s               n   inz(*off)
     d CmdStr          s            300a
     d MsgTxt          s            300a
     d riRscArcId      s             10a
     d riRscArcLib     s             10a
     d ndx             s             10i 0
     d rc              s             10i 0
     d StkCnt          s             10i 0
     d DtaLen          s             10i 0
     d ErrCod          s             10i 0
     d dec15           s             15p 0
     d WrkFilNm        s             20a
     d pFile           s               *   inz(*NULL)
     d Failed          s               n

     c*-------------------------------------------------------------------------
     c* mainline
     c*-------------------------------------------------------------------------
     c     *entry        plist
     c                   parm                    RtnCode           1

     c                   eval      RtnCode = '0'

      * create/set the resource library if not specified
     c     *lock         in        Sysdft

     c                   if        AfpXlb = *blanks
     c                   eval      riRscArcLib = 'DOCMGRRSC'
     c                   dou       *in50 = *on or ndx > 9
     c                   eval      cmdstr='CHKOBJ OBJ('+%trim(riRscArcLib)+
     c                             ') OBJTYPE(*LIB)'
     c                   exsr      RunCL
     c                   if        *in50 = *on
     c                   leave
     c                   endif

     c                   eval      ndx = ndx + 1
     c                   eval      riRscArcLib = %subst(riRscArcLib:1:9) +
     c                             %trim(%editc(ndx:'Z'))

     c                   enddo

     c                   if        ndx > 9
     c                   eval      RtnCode = '1'
     c                   exsr      Quit
     c                   endif

      * create the archived resource library
     c                   eval      cmdstr = 'CRTLIB LIB('+%trim(riRscArcLib)+
     c                             ') TYPE(*PROD) TEXT(''DocManager archived '+
     c                             'AFP resources'')'
     c                   exsr      runCL
     c                   if        *in50 = *on
     c                   eval      rtnCode = '2'
     c                   exsr      Quit
     c                   endif

      * update the data area
     c                   eval      AfpXlb = riRscArcLib
     c                   out       Sysdft

     c                   endif

     c                   eval      riRscArcLib = AfpXlb

      * set the beginning resource ID number
     c                   open(e)   MHeader
     c                   if        not %open(Mheader)
     c                   eval      RtnCode = '9'
     c                   exsr      Quit
     c                   endif

     c     1             chain(e)  MHeader
     c                   if        not %found
     c                   eval      RtnCode = '9'
     c                   exsr      Quit
     c                   endif

     c                   eval      mhRsId = 'A0000000'
     c                   update    header

     c                   close(e)  MHeader

      * read thru entire New file (just had data copied to it)
     c                   dou       *inlr = *on
     c                   Read      rscdir                                 lr
     c                   if        *inlr = *on
     c                   leave
     c                   endif

      * set the update flag
     c                   eval      Failed = *off

      * create/clear the work file
     c                   exsr      CrtWrkFil

      * write resource data to the work file
     c                   exsr      WrtRscDta

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
     c* GetObjID - get new resource object ID
     c*------------------------------------------------------------------------
     c     GetObjID      begsr

/3465 * get next available resource ID from MHEADER
/3465c                   callp     GetNum('GET':'RSCID':riRscArcId:Dec15)
/3465c                   if        riRscArcId = '*ERROR'
/3465c                   eval      riRscArcId = *blanks
     c                   eval      RtnCode = '4'
     c                   exsr      Quit
/3465c                   endif

     c                   endsr
     c*------------------------------------------------------------------------
     c* CrtWrkFil - Create/clear the work file
     c*------------------------------------------------------------------------
     c     CrtWrkFil     begsr

      * check for existing work file
     c                   eval      cmdstr='CHKOBJ OBJ(QTEMP/RSCWRKFL)' +
     c                             ' OBJTYPE(*FILE)'
     c                   exsr      RunCL
     c                   if        *in50 = *on
      * if file does not exist then create it
     c                   eval      cmdstr = 'CRTPF FILE(QTEMP/RSCWRKFL) '+
     c                              'RCDLEN(80) TEXT(''Work file for DocMan'+
     c                              'ager installation.'')'
     c                   exsr      RunCL
     c                   if        *in50 = *on
     c                   eval      RtnCode = '5'
     c                   exsr      Quit
     c                   endif

     c                   else
      * if it does exist then clear it
     c                   eval      cmdstr = 'CLRPFM FILE(QTEMP/RSCWRKFL)'
     c                   exsr      RunCL
     c                   if        *in50 = *on
     c                   eval      RtnCode = '6'
     c                   exsr      Quit
     c                   endif

     c                   endif
     c

     c                   endsr
     c*------------------------------------------------------------------------
     c* WrtRscDta - Write the resource data to the work file
     c*------------------------------------------------------------------------
     c     WrtRscDta     begsr

     c     rdrid         chain(e)  MRscdta
      * if no resource data exists then remove the MRSCDIR record.
     c                   if        not %found(MRscDta)
     c                   delete    rscdir
     c                   else

      * open the workfile if necessary
     c                   eval      wrkfilnm = 'QTEMP/RSCWRKFL' + x'00'
     c                   eval      rc=openWorkFile(%addr(wrkFilNm):
     c                             %len(%trim(wrkfilnm)):pFile)
     c                   if        rc <> 0
     c                   eval      rtnCode = '7'
     c                   exsr      Quit
     c                   endif

      * get new Object ID using new format
     c                   exsr      GetObjID

     c                   dou       %eof(MRscDta)
     c                   eval      rc = writeRscData(%addr(radata):%len(radata):
     c                             pFile)
     c     rdrid         reade(e)  MRscDta
     c                   enddo

     c                   eval      rc = closeWorkFile(pFile)
     c                   eval      pFile = *NULL

      * create the object
     c                   exsr      CrtRscObj

      * update the RSCDIR record with the new name
     c                   if        not Failed
     c                   eval      rdrid = riRscArcId
     c                   update    rscdir
     c                   else
     c                   exsr      sndmsg
     c                   endif

     c                   endif

     c                   endsr
     c*------------------------------------------------------------------------
     c* CrtRscObj - create the resource object
     c*------------------------------------------------------------------------
     c     CrtRscObj     begsr

      * override file
     c                   eval      cmdstr = 'OVRDBF FILE(RSCWRKFL) ' +
     c                             'TOFILE(QTEMP/RSCWRKFL) ' +
     c                             'LVLCHK(*NO) OVRSCOPE(*JOB)'
     c                   exsr      RunCL

     c                   eval      cmdstr = 'CRT'+%subst(rdObjT:2:
     c                             %len(%trim(rdObjT))-1)+' '+
     c                             %subst(rdObjT:2:%len(%trim(rdObjT))-1)+
     c                             '('+%trim(riRscArcLib)+'/'+
     c                             %trim(riRscArcId)+') FILE(QTEMP/RSCWRKFL)'+
     c                             ' MBR(RSCWRKFL) TEXT(''Original Obj: '+
     c                             %trim(rdObjL)+'/'+%trim(rdObjN)+''')'
     c                   exsr      RunCL
     c                   if        *in50 = *on
     c                   eval      Failed = *on
     c                   endif

     c                   eval      cmdstr='DLTOVR FILE(RSCWRKFL) LVL(*JOB)'
     c                   exsr      RunCL
     c                   if        *in50 = *on
     c                   eval      rtnCode = '8'
     c                   exsr      Quit
     c                   endif

     c                   endsr
     c*------------------------------------------------------------------------
     c* sndmsg - send a message letting the user know that a resource was not created
     c*------------------------------------------------------------------------
     c     sndmsg        begsr

     c                   eval      msgTxt =
     c                             'Object could not '+
     c                             'be re-created from MRSCDTA. Obj: ' +
     c                             %trim(rdObjL)+'/'+%trim(rdObjN)+' Type: '+
     c                             %trim(rdObjT)+' RscID: ' +%trim(rdRID)
      *
     c                   eval      msgf = 'QCPFMSG   *LIBL'
     c                   call      'QMHSNDPM'
     c                   parm      'CPF9898'     msgid             7
     c                   parm                    msgf             20
     c                   parm                    msgtxt          300
     c                   parm      300           dtalen
     c                   parm      '*DIAG'       msgtyp           10
     c                   parm      '*'           msgq             10
     c                   parm      1             stkcnt
     c                   parm                    msgkey            4
     c                   parm                    errcod

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

      * delete override
     c                   eval      cmdstr='DLTOVR FILE(RSCWRKFL) LVL(*JOB)'
     c                   exsr      RunCL

      * close work file
     c                   if        pFile <> *NULL
     c                   eval      rc = closeWorkFile(pFile)
     c                   endif

     c                   eval      *inlr = *on
     c                   return

     c                   endsr

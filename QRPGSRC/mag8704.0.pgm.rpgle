      *********************************************************************
      * SpyView IFS Monitor   xxx                                         *
      *                                                                   *
      * Autor: Friedhelm Bruegge        04.2000                           *
      *                                                                   *
      * Date     Init Project  Description                                *
      *                                                                   *
J3746 * 09-20-11 EPG Convert the bound RPGLE program to a module and add  *
/     *              the module and the non-source program to avoid a     *
/     *              duplicate procedure message from PDFIO and the       *
/     *              program. Explicitly define compile options on the    *
/     *              program in Aldon for *DUPPROC, *DUPVAR.              *
J3109 * 03-30-11 PLR Retrieve an alternate report configuration name if on*
      *              exists. Was causing PDF not to be archived.          *
/2684J* 06-10-10 EPG  Exit program does not work when after an upgrade to *
/     *               version 8.7.3.                                      *
/2048 * 09-24-09 EPG Recompile Only, for new PDFIO signature              *
/1769 * 06-15-09 EPG Outque and IFS monitors possibly locking             *
T7486 * 02-12-09 EPG Allow the inclusion of a report type of *PDF as defined
      *              in the ifs monitor extention. This will prevent the  *
      *              necessity for a definition for every report type or  *
      *              a folder for every report type. When this option is used,
      *              the report type will be extracted from the pdf document.
/6009 * 04-16-07 EPG  Provide for better handling of the move delete      *
/6009 *               option of files.                                    *
T5975 * 04-03-07 EPG  Prevent an IFS file from being moved or deleted if  *
T5975 *               the return from CheckLock yeilds a negative file    *
T5975 *               description.                                        *
T6009 * 01-12-07 EPG  IFS monitor move after archive option not working   *
/     *               with native PDF files.                              *
T5975 * 01-11-07 PLR  Suppress 'Invalid number of index values' message   *
      *               when returning from *BEFORE call to exit program.   *
      *               MAGIFSSPL does not use the parm list and leaves the *
      *               index counter at zero. This app interprets that as a*
      *               error.                                              *
      * 10-18-06 EG   5794     Backout the Journal Changes, but           *
      *                        include the pattern matching from          *
      *                        JRNGETENT                                  *
      *                                                                   *
      * 10-12-06 EG   4949     Ignore errors that are generated under the *
      *                        following conditions:                      *
      *                        When the report type is defined as *DIR    *
      *                        and the execute program returns back with  *
      *                        an error IFS0005. Under this condition     *
      *                        there is no report type with the same name *
      *                        as the directory being processed.          *
      *                                                                   *
      *                        Additionally, when an error PCF0000 is     *
      *                        returned back from exit program, ignore    *
      *                        this mostly informational message.         *

      * 10-11-06 EG   4949     Place JRNGETENT into a loop and subsequent *
      *                        ly archive all the files until it is       *
      *                        finished.                                  *
      *                                                                   *
      * 10-10-06 EG   4949     Place a wrapper around the processing      *
      *                        for JRNGETENT ensuring that this function  *
      *                        is called only when IEDLT = 'I'            *
      *                                                                   *
4979  * 10-04-06 EG   4949     Check for the existance of the journal     *
      *                        and the journal reciever within            *
      *                        *INZ if it does not exist.                 *
      *                        Move the logic that checks for initialzing *
      *                        preexisting files from the *INZ to         *
      *                        the main looop.                            *
      *                                                                   *
4979  * 02-16-06 EG   4979     Add in Pattern Matching to help identify   *
      *                        a file for processing.                     *
4979  * 12-23-05 EG   4979     Retrofit IFS journalling                   *
      *                                                                   *
/9228 *  8-13-04 GT  Fix IFS open call: Use O_SHARE_NO on oflag parm -    *
/     *              was using O_EXCL in mode parm incorrectly            *
/     *              Remove assignment of fildes to close return value    *
/     *              in checklock routine (not really a problem, but not  *
/     *              good practice).                                      *
      *                                                                   *
/6629 * 01-15-03 GT  Remove TGTRLS(V3R2M0) compile option and move others *
      *              to h spec                                            *
/6629 * 05-17-02 GT  Fix parsing of file name for index values (getidx)   *
      *              Was not handling two contiguous separators correctly *
/6630 * 05-17-02 GT  Changed %trim functions used in file name processing *
      *              to %trimr.                                           *
      *              !!! MUST NOT TRIM BLANKS FROM FRONT OF IFS NAMES !!! *
      *                                                                   *
      *-------------------------------------------------------------------*
/1769h option(*nodebugio)
4979 h copyright('Open Text Corporation')
5975 h indent(' ')
J3746h/if defined(*CRTBNDRPG)
T7486h   bnddir('QC2LE':'PDFLIBI':'SPYBNDDIR')
4979 h   dftactgrp(*no) actgrp('DOCMGR')
J3746h/endif
     fmifsmon1  IF   E           K DISK    rename(ifsmonf:ifsmonf1)
     f                                     usropn
     fmifsmon   UF   E           K DISK    usropn
4979 fmifsext   Uf   e           k disk
     frmaint4   if   e           k disk
     frlnkdef   if   e           k disk
     frindex    if   e           k disk
      * Prototype -----------------------------------------------------****

5794 d GetPatMth       pr              n
5794 d  pPatMth                     256a   const options(*varsize)
5794 d  pFile                       256a   const options(*varsize)
5794 d  pWildCard                    10a   const options(*varsize:*nopass)

      * Check the object 0 - Exist 1 - Does not exist
     d SpChkObj        pr                  ExtPgm('SPCHKOBJ')
     d  pObj                         10a   Const
     d  pObjLib                      10a   Const
     d  pObjType                     10a   Const
     d  pRC                           1a

4979  /copy @msglog
4979  /copy @osapi
T7486 /copy @pdfstat
J3109 /copy @maaltkey

      * --------------------
      * Read directory
      * --------------------
     d readadir        pr            10i 0
     d  ifsmondef                    10    value
     d  ifspath                     256    value
     d  ifsrtnmsg                     7
     d  ifsrtndta                   256

      * --------------------
      * Archive file
      * --------------------
     d execfile        pr            10i 0
     d  ifsmondef                    10    value
     d  ifspath                     256    value
     d  ifsrtnmsg                     7
     d  ifsrtndta                   256
      *
      *********************************************************************
2684Jd MAGIFSSPL       c                   'MAGIFSSPL'
/1769d ERROR           c                   -1
4979 d LF              c                   x'25'
4979 d TRUE            c                   '1'
4979 d FALSE           c                   '0'
4979 d QUOTE           c                   x'7D'
4979 d YES             c                   'Y'
     D PSCON           C                   CONST('PSCON     *LIBL     ')
4979 d SPYEXIST        c                   '0'
4979 d SPYNOTEXIST     c                   '1'
     D ERRCD           DS
     D  @ERCON                 9     15
     D  @ERDTA                17    116
      * ------------------------------------------
      *  Timestamp datastructure
      * ------------------------------------------
     D/copy @WCCVTDT
     D*  Program Error handling
      * ------------------------------------------
     D Psds           SDS
     D  SdcLoc           *ROUTINE
     D  SdsErr           *STATUS
     D  SdsParms         *PARMS
     D  SdsName          *PROC
     D  WQPGMN                 1     10
     D  WQLIBN                81     90
     D SdsErrId               40     46A
     D CurJobAtr             244    269
     D CurUser               254    263
     D CurJobNr              264    269S 0
     D CurJobNr$             264    269A
4979 d cmdOScmd        s           3000a
      * OS Command
4979 d sysdft          s           1024a
      * System data area
     D rtnmsg          s              7
     D rtnmsgdta       s            256
     D rtncde          s             10i 0
     d mh_dtalen       s              9b 0 inz(%size(mh_msgdta))
     d mh_stkcnt       s              9b 0 inz(1)
4979 d SpyRC           s              1a
     D                 DS
     D  LNDXN1
     D  LNDXN2
     D  LNDXN3
     D  LNDXN4
     D  LNDXN5
     D  LNDXN6
     D  LNDXN7
     D  idxnam                 1     70    dim(7)
J3109d rSplCfgDS     e ds                  extname(RsplCfg) qualified
J3109d pRsplCfgDS      s               *   inz(%addr(RsplCfgDS))
J3109d jobNam          s             10    inz
J3109d pgmOpf          s             10    inz
J3109d usrNam          s             10    inz
J3109d usrDta          s             10    inz
      *********************************************************************
      *   Lock monitor as active
     c                   call      'MAG8701'
     c                   parm      'L'           status            1
      *   Update next check date for all accounts
     c                   exsr      updall

      *   clear the dtaq
     C                   DOU       QDTASZ =0
     C                   CALL      'QRCVDTAQ'                                   ReceiveDataQ
     C                   PARM      'SPYIFSMON'   QNAME            10             Que name
     C                   PARM      '*LIBL'       QLIB             10                 libr
     C                   PARM      200           QDTASZ            5 0           Msg size
     C                   PARM      *BLANKS       DQMSG           200             Rpt dta str
     C                   PARM      0             QWAIT             5 0           Wait secs
     C                   ENDDO
      *
     C                   DO        *HIVAL
      *   Delay the job for one minute
     C                   CALL      'QRCVDTAQ'                                   ReceiveDataQ
     C                   PARM      'SPYIFSMON'   QNAME            10             Que name
     C                   PARM      '*LIBL'       QLIB             10                 libr
     C                   PARM      200           QDTASZ            5 0           Msg size
     C                   PARM      *BLANKS       DQMSG           200             Rpt dta str
     C                   PARM      50            QWAIT             5 0           Wait secs
      *
     C                   IF        %SUBST(DQMSG:1:3)='END'                      End Requested
     C                   EXSR      Quit
     C                   ENDIF
      *
     c                   exsr      transfer
      *
     C                   ENDDO
      *
     c                   exsr      quit
     C*****************************************************************
      *
     C     *inzsr        BEGSR

      *
     C     WQLIBN        CAT       '/MAG103B'    MG103B           21            AddLibl
     C                   CALL      MG103B                                         SpyPgmLib
     C                   PARM                    CGLIST            1 0
      *
     C                   CALL      'MAG1031'                                    Save user's
     C                   PARM                    WQPGMN                          LibList
     C                   PARM      ' '           #LOAD             1             and LDA
      *
     C                   CALL      'MAG103A'                            81      Build SpyLst
      *                                                     pgm+data
<--1 C     *IN81         IFEQ      '1'                                          Error...
|    C                   CALL      'MAG1031'                                     Restore
|    C                   PARM                    WQPGMN                          LibList
|    C                   PARM      'Q'           #LOAD
|    C                   CALL      'SPYERR'                                      Send error
|    C                   PARM      'API0004'     MSGID             7             message
|    C                   PARM      *BLANK        MSGDTA          100
|    C                   PARM      'PSCON'       MSGF             10
|    C                   PARM      '*LIBL'       MSGFLB           10             and
|    C                   EXSR      QUIT                                          quit.
|__1 C                   END
      *
4979 c                   If        NOT %Open(mifsmon)
     c                   open      mifsmon
4979 c                   EndIf

4979 c                   If        NOT %Open(mifsmon1)
     c                   open      mifsmon1
4979 c                   EndIf
      *
     c                   endsr
     C*****************************************************************
     C*****************************************************************
      *  Send Item
      *
     C     transfer      BEGSR
      *
     c                   exsr      getcurdat
      *
     c                   z-add     wcdate        ifndat
     c                   movel     wctime        ifntim
     c     keytim        klist
     c                   kfld                    ifndat
     c                   kfld                    ifntim
      *
     c     keytim        setll     ifsmonf1
     c                   do        *hival
     c                   read      ifsmonf1                             5050
     c   50              leave
     c                   if        ifact<>'Y'
     c                   iter
     c                   endif
      *    Read directory for ifs monitor
     c                   if        ifpath<>'/' and ifpath<>*blanks
     c                   eval      rtncde=readadir (ifdef:ifpath:
     c                                              rtnmsg:rtnmsgdta)
      *        Error returned?
     c                   if        rtnmsg<>*blanks
     c                   exsr      sndmsg
     c                   endif
      *
     c                   endif
      *
      *  Update next transfer time/date
     c     ifdef         chain     ifsmonf                            5050
     c                   exsr      updnext
     c  n50              update    ifsmonf
      *
     c                   enddo
      *
     C                   endsr
      **********************************************************************************************
      *  Update next date/time for all accounts
     C     updall        BEGSR
     c                   exsr      getcurdat
     c     *loval        setll     ifsmonf
     c                   do        *hival
     c                   read      ifsmonf                              5050
     c   50              leave
     c                   if        ifact='Y'
     c                   exsr      updnext
     c                   else
     c                   z-add     *hival        ifntim
     c                   z-add     *hival        ifndat
     c                   endif
     c                   update    ifsmonf
     c                   enddo
     c                   endsr
      **********************************************************************************************
      *  Update next date/time for check
     C     updnext       BEGSR
      *
     c                   exsr      getcurdat
     c                   z-add     wcdate        ifldat
     c                   z-add     wctime        ifltim
      *     Calcutlate next time for transfer
     c                   CLEAR                   TotMin            9 0
      *          fixed time
     c                   if        iftim<>0
     C                   EVAL      ifntim=iftim
     c                   clear                   addday
      *          fixed time allready passed, go and do it next day
     c                   if        ifntim<wchour*100+wcminute
     c                   add       1             addday
     c                   endif
     c                   else
      *          poll interval
     c                   if        ifmin=0
     c                   z-add     10            ifmin
     c                   endif
     c                   EVAL      TotMin=wcHour*60+wcMinute+ifmin
     C     TotMin        DIV       1440          AddDay            3 0
     C                   MVR                     TotMin
     C     TotMin        DIV       60            NewHour           3 0
     C                   MVR                     NewMin            3 0
     C                   EVAL      ifntim=NewHour*100+NewMin
     c                   endif
      *
      *   Get current day of the week
     C                   EVAL      DD=wcDay
     C                   EVAL      MM=wcMonth
     C                   EVAL      YYYY=wcYear
     C                   EVAL      WT=0
     C                   CALL      'MAG1400D'    PLDAT
      *
     C                   ADD       AddDay        WT
      *
     C                   EVAL      DD= 0
     C                   EVAL      MM= 0
     C                   EVAL      YYYY= 0
     C                   CALL      'MAG1400D'    PLDAT
      *    Only pick valid days
     c                   dow       %subst(ifday:tagnr:1)=' ' and
     c                             ifday<>*blanks
     c                   add       1             wt
     C                   EVAL      DD= 0
     C                   EVAL      MM= 0
     C                   EVAL      YYYY= 0
     C                   CALL      'MAG1400D'    PLDAT
     c                   if        iftim<>0
     C                   EVAL      ifntim=iftim
     c                   else
     c                   z-add     1             ifntim
     c                   endif
     c                   enddo
      *
     C                   EVAL      ifndat=YYYY*10000 +
     C                                    MM*100 + DD
      *
     C     PLDAT         PLIST
     C                   PARM                    DD                2 0          day
     C                   PARM                    MM                2 0          month
     C                   PARM                    YYYY              4 0          year
     C                   PARM                    WT                5 0          day since 1900
     C                   PARM                    GK                1            up/lo case
     C                   PARM                    WOT              10            weekday long
     C                   PARM                    WOK               2            weekday short
     C                   PARM                    MON               9            month long
     C                   PARM                    MOK               3            month short
     C                   PARM                    TAGJ              3 0          day in year
     C                   PARM                    KW                2 0          week in year
     C                   PARM                    TAGNR             1 0          day number in week
     c                   endsr
      ************************************************************************
     C     sndmsg        BEGSR
      *
     c                   if        ifmsgq='*SYSOPR'
     c                   eval      mh_msgq=ifmsgq
     c                   else
     c                   if        ifmsgl=*blanks
     c                   eval      mh_msgq=ifmsgq+'*LIBL'
     c                   else
     c                   eval      mh_msgq=ifmsgq+ifmsgl
     c                   endif
     c                   endif
      *
     c                   call      'QMHSNDM'                            50
     c                   parm      rtnmsg        mh_msgid          7
     c                   parm      pscon         mh_msgfil        20
     c                   parm      rtnmsgdta     mh_msgdta       256
     c                   parm                    mh_dtalen
     c                   parm      '*INFO'       mh_msgtyp        10
     c                   parm                    mh_msgq          20
     c                   parm                    mh_stkcnt
     c                   parm                    mh_msgrpl        20
     c                   parm                    mh_msgkey         4
     c                   parm      *loval        mh_errcod         4
      *
     C                   ENDSR
     c*******************************************************************************************
     C     RTVMSG        BEGSR
      *          -------------------------------
      *          Retrieve message from PSCON
      *          -------------------------------
     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80
      *
     C                   MOVE      *BLANKS       @ERDTA
     C                   ENDSR
      **********************************************************************************************
     C     getcurdat     BEGSR
      *      Get current date and time
     c                   call      'QWCCVTDT'
     c                   parm      '*CURRENT'    CCVInpFmt        10
     c                   parm                    CCVInpVal        10
     c                   parm      '*YYMD'       CCVOutFmt        10
     c                   parm                    WCOUTV
     c                   parm      *ALLx'00'     CCVErrCde        10
     c                   endsr
     C*****************************************************************
      *  Execute System Command
      *
     C     RunCl         BEGSR
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    ClCmd           500
     C                   PARM      500           CmdLen           15 5
     C                   ENDSR
      *********************************************************************
     C     QUIT          BEGSR


      *          QUIT PROGRAM
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      **********************************************************************************************
      **********************************************************************************************
      **********************************************************************************************
     p readadir        b
      *
     d readadir        pi            10i 0
     d  ifsmondef                    10    value
     d  ifspath                     256    value
     d  ifsrtnmsg                     7
     d  ifsrtndta                   256
      *
     d rtncde          s             10i 0
      *
     d dirptr          s               *
     d rtn             s             10i 0
     d path0           s            257
     d newifspth       s            256
      *
     DpDirEnt          S               *
     DDirEnt           DS                  Based(pDirEnt)
     D  rdLen                 55     56B 0
     D  rdName                57    696
      *
      **********************************************************************************************
      *
     c                   clear                   ifsrtnmsg
     c                   clear                   ifsrtndta
     c                   clear                   rtncde

      *                  Check for journaling

     c     ifsmondef     chain(n)  ifsmonf                            5050
     c                   if        *in50
     c                   eval      ifsrtnmsg='IFS0001'
     c                   eval      ifsrtndta=ifsmondef
     c                   return    -1
     c                   endif
      *
      *    Open directory

      *                  Determine if journaling is enabled
      *                  for this specific definition


     c                   exsr      opndir

      *    Read each entry in directory
     c                   if        ifsrtnmsg=*blanks
     c                   do        *hival
     c                   exsr      reddir

     c                   if        filnam=*blanks or
     c                             ifsrtnmsg<>*blanks

4979 c                   If        filnam = *blanks
     c                   leave
4979 c                   ElseIf    ifsrtnmsg <> *blanks
5794 c                   Eval      ifsrtnmsg = *blanks
4979 c                   Iter
4979 c                   EndIf

     c                   endif
      *
      *    Format path to filename found
     c                   eval      newifspth=%trimr(ifspath)+'/'+%trimr(filnam)
      *    When subdirectory was found, go read subdir recursiv
     c                   if        filtyp='D' and
     c                             ifsub = 'Y'
     c                   eval      rtn=readadir (ifsmondef:newifspth:
     c                                       ifsrtnmsg:ifsrtndta)
     c                   if        rtn<0
4979 c                   Iter
     c                   endif
     c                   else
      *    Regular file, go archive it
/6009c                   If        filtyp = 'F'
     c                   eval      rtn=execfile (ifsmondef:newifspth:
     c                                       ifsrtnmsg:ifsrtndta)

4979  *    Ignore the informational message PCF0000
4979  *    in the instances where this is causing the
4979  *    loop to prematurely exit. Likewise for IFS0005

4979 c                   If        ifsrtnmsg = 'PCF0000'  or
     c                             ifsrtnmsg = 'IFS0005'
4979 c                   Eval      rtn = 0
4979 c                   Eval      ifsrtnmsg = *blanks
4979 c                   Eval      ifsrtndta = *blanks
4979 c                   EndIf

     c                   if        rtn<0
4979 c                   Iter
     c                   endif

     c                   endif
      *
     c                   EndIf
      *
     c                   enddo
     c                   endif

      *                  Close directory

     c                   exsr      clsdir
      *
     c                   return    rtncde
      **********************************************************************************************
      *  Open directory in ifs
     c     opndir        begsr
      *
     c                   eval      path0=%trimr(ifspath)+x'00'
     c                   Eval      dirptr= OpenDir(%addr(path0))
      * Error on directory open
     c                   if        dirptr = *null
     c                   eval      ifsrtnmsg='IFS0002'
     c                   eval      ifsrtndta=ifspath
     c                   return    -1
     c                   endif
     c
     c                   endsr
      **********************************************************************************************
      *  Close directory
     c     clsdir        begsr
      *
     c                   Eval      rtn = CloseDir(dirptr)
      *
     c                   endsr
      **********************************************************************************************
      * Read directory
     c     Reddir        begsr
      *
     c                   clear                   filnam          256
     c                   clear                   filtyp            1
      *
     c                   dou       filnam<>'.' and
     c                             filnam<>'..' or
     c                             pdirent=*null
     C                   Eval      pDirEnt = ReadDir(dirptr)
     c                   clear                   filnam
     c                   if        pdirent<>*null
     C                   Eval      filnam= %SubSt(rdName:1:rdLen)
     c                   endif
     c                   enddo
      *
      *  Get filetype
     c                   if        filnam<>*blanks

5794 c                   If        IFPatMth <> *blank

5794 c                   If        GetPatMth(IFPatMth:filnam) <> TRUE
5794 C                   Eval      ifsrtnmsg='IFS0020'
5794 c                   Eval      rtn = -1
5794 c                   EndIf

5794 c                   EndIf
     c                   eval      path0=%trimr(ifspath) +
     c                                         '/'+%trimr(filnam)+x'00'
     c                   eval      rtn     = stat(%Addr(path0):
     c                                        %Addr(stat_ds))
     c                   if        rtn<0
     c                   eval      ifsrtnmsg='IFS0004'
     c                   eval      ifsrtndta=%trimr(ifspath) +
     c                                           '/'+%trimr(filnam)
     c                   endif
   76 *      get object type
   76c                   clear                   objtype           9
   77c                   eval      objtype=%subst(st_objtype:1:9)
      *      determine filetype   D=Directory, F=File
   77c                   select
   77c                   when      objtype='*DIR' or
   77c                             objtype='*FLR' or
   77c                             objtype='*LIB' or
   77c                             objtype='*DDIR'
   77c                   eval      filtyp   ='D'                                directory
   77c                   other
   77c                   eval      filtyp   ='F'                                File
   77c                   endsl
     c                   endif
      *
     c                   endsr
      *
     P readadir        E
      **********************************************************************************************
      *  ====================================
      *  ibmmonarc   Read directory
      *  ====================================
      **********************************************************************************************
     p execfile        b
      *
     d execfile        pi            10i 0
     d  ifsmondef                    10    value
     d  ifspath                     256    value
     d  ifsrtnmsg                     7
     d  ifsrtndta                   256
      *
     d arcval          s             99a   dim(7)
     d maxidx          s             10i 0 inz(%elem(arcval))
     d
     d any             s                   like(ieext)
     d                                     inz('*ANY')
     d rc              s             10i 0
      *
     d  extidxcnt      s             10i 0
      **********************************************************************************************
      *
      *  IFS File structure for exit program
     d exfilds         ds
     d  ef_dslen                     10i 0 inz(%size(exfilds))
     d  ef_paht                     256
     d  ef_filnam                   256
     d  ef_fildat                     8  0 inz(0)
     d  ef_filtim                     6  0 inz(0)
     d  ef_filsiz                    10i 0 inz(0)
      *
      *  Index description structure for exit program
     d exidxds         ds                  occurs(%elem(arcval))
     d  ei_dslen                     10i 0 inz(%size(exidxds))
     d  ei_name                      10
     d  ei_desc                      30
     d  ei_len                        5  0
      *
      *  Index description structure for exit program
     d exvalds         ds                  occurs(%elem(arcval))
     d  ev_dslen                     10i 0 inz(%size(exidxds))
     d  ev_idxnam                    10
     d  ev_value                     99
      *
     D oflag           S             10i 0
     d path0           s            257
     d newpath         s            256
     d newpath0        s            257
     d fildes          s             10i 0
     d rtncde          s             10i 0
     d rtn             s             10i 0
     d f1a             s              1a
     d extpgm          s             10a
     d extpgmlib       s             10a
     d extpgmnam       s             21a
      *
     d arcrpttyp       s                   like(ietyp)
J3109d altKeyExists    s             10i 0 inz(#NOTFND)
      *
      *
      **********************************************************************************************
      **********************************************************************************************
      *
     C                   CALL      'SPYLOUP'                                    Upper/Lower
     C                   PARM                    LO               60            case table
     C                   PARM                    UP               60
      *
     c                   clear                   rtncde
     c                   clear                   ifsrtnmsg
     c                   clear                   ifsrtndta
     c                   clear                   noarc             1
      *
     c     ifsmondef     chain(n)  ifsmonf                            5050
     c                   if        *in50
     c                   eval      ifsrtnmsg='IFS0001'
     c                   eval      ifsrtndta=ifsmondef
     c                   return    -1
     c                   endif
      *        Get file extension
     c                   exsr      getext
      *        Check if definition exists for extension
     c                   eval      ieext=extension
     c     keyext        klist
     c                   kfld                    ifdef
     c                   kfld                    ieext
     c     keyany        klist
     c                   kfld                    ifdef
     c                   kfld                    any
     c     keyext        chain     ifsextf                            5050
     c   50keyany        chain     ifsextf                            5050
     c                   if        not *in50 and
     c                             ieact ='Y'


     c                   clear                   arcval
      *     Try to open file exclusive to check for locks
     c                   exsr      checklock
     c                   if        fildes<0
     c                   eval      ifsrtnmsg='IFS0004'
     c                   eval      ifsrtndta=ifspath
     c                   return    -1
     c                   endif
J3109c                   reset                   altKeyExists
      *     Report type based uppon subdirectory name
T7486c                   select
/     * If PDF, retrieved the name from the object attributes.
/    c                   when      ietyp = '*PDF'
/    c                   if        PDFStat(path0:p_pPdfInfods) = 0
/    c                   eval      arcrpttyp = pi_reportName
J3109 /free
J3109  // Is there an alternate report key?
J3109  altKeyExists = Get1stSplCfg(pRsplCfgDS:pi_reportName:jobNam:pgmOpf:
J3109    usrNam:usrDta);
J3109 /end-free
/    c                   endif
/    c                   when      ietyp='*DIR'
     c                   eval      arcrpttyp=subdir
T7486c                   other
     c                   eval      arcrpttyp=ietyp
T7486c                   endsl
      * Skip chain if alternate report key exists.
J3109c                   if        altKeyExists <> #OK
/2684c     arcrpttyp     chain     rmaint4
/    c                   if        NOT %found
     c                   eval      ifsrtnmsg='IFS0005'
     c                   eval      ifsrtndta=arcrpttyp
     c                   return    -1
     c                   endif
J3109c                   endif
      *     Get index value based uppon filename
     c                   if        iekey='Y'
     c                   exsr      getidx
     c                   endif
      *     Call *BEFORE exit pgm to get external index values
     c                   if        ieipgm<>*blanks and
     c                             ieipgm<>'*NONE'
     c                   eval      extsts='*BEFORE'
     c                   eval      extpgm=ieipgm
     c                   eval      extpgmlib=ieipgl
     c                   exsr      callexit

6009 c                   If        ieDlt = 'N'

5975 c                   ExSr      CheckLock

5975 c                   If        ( FilDes >= 0 ) and
J3109c                             ( ExtPgm = MAGIFSSPL )
6009 c                   exsr      renamedoc
5975 c                   EndIf

6009 c                   ElseIf    ( ( ieDlt = 'Y'           ) and
J3109c                               ( ExtPgm = MAGIFSSPL )     )
5975 c                   ExSr      CheckLock

5975 c                   if        fildes<0
5975 c                   eval      ifsrtnmsg='IFS0004'
5975 c                   eval      ifsrtndta=%trimr(path0)
5975 c                   Return    -1
5975 c                   Else
     c
J3109c                   If        ( ExtPgm = MAGIFSSPL )
6009 c                   eval      rtn=unlink(path0)

6009 c                   if        rtn<0
6009 c                   eval      ifsrtnmsg='IFS0009'
6009 c                   eval      ifsrtndta=ifspath
6009 c                   return    -1
6009 c                   endif

2684Jc                   EndIf

6009 c                   EndIf

6009 c                   EndIf

     c                   endif
      *     Archive file, if needed
     c                   if        iearc='Y' and
     c                             noarc<>*on
     c                   exsr      archive
      *     Call *AFTER  exit pgm to get external index values
     c                   if        ieapgm<>*blanks and
     c                             ieapgm<>'*NONE'
     c                   eval      extsts='*AFTER'
     c                   eval      extpgm=ieapgm
     c                   eval      extpgmlib=ieapgl
     c                   exsr      callexit
     c                   endif
      *     Delete file if archived ok
     c                   if        iedlt='Y'
5975 c                   ExSr      CheckLock

5975 c                   if        fildes<0
5975 c                   eval      ifsrtnmsg='IFS0004'
5975 c                   eval      ifsrtndta=%trimr(path0)
5975 c                   Return    -1
5975 c                   Else
     c                   eval      rtn=unlink(path0)

     c                   if        rtn<0
     c                   eval      ifsrtnmsg='IFS0009'
     c                   eval      ifsrtndta=ifspath
     c                   return    -1
     c                   endif

5975 c                   EndIf

     c                   else

      *     Don't delete, move to
      *     Ensure that the file remains if ieDlt = 'I'

5794 c                   If        ieDlt = 'N'
     c                   exsr      renamedoc
5794 c                   EndIf

     c                   endif
     c                   endif
      *
     c                   endif
      *
     c                   return    rtncde
      **********************************************************************************************
      * Rename document
     c     renamedoc     begsr
      *
      *  generate new path (including the subdirectories)
     c     ' '           checkr    ifpath        baspthlen         5 0
     c                   eval      newpath=%trimr(iempth)+
     c                                  %trimr(%subst(ifspath:baspthlen+1))
      *  Call SPYIFS to check if file already exists
     c                   call      'SPYIFS'
     c                   parm      'DUPFIL'      ifsopcd          10
     c                   parm                    newpath
      *  Move object by renaming it
     c                   eval      clcmd='MOV OBJ('''+%trimr(ifspath)+''')'+
     c                                       ' TOOBJ('''+%trimr(newpath)+''')'
     c                   do        2
     c                   exsr      runcl
     c  n50              leave
     c                   call      'SPYIFS'
     c                   parm      'CRTPTH'      ifsopcd          10
     c                   parm                    newpath
     c                   enddo
      *
     c                   if        *in50
     c                   exsr      geterrdsc
     c                   eval      ifsrtnmsg='IFS0010'
     c                   eval      ifsrtndta=newpath
     c                   return    -1
     c                   endif
      *
     c                   endsr
      **********************************************************************************************
     c     runcl         begsr
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    ClCmd          1000
     C                   PARM      1000          CmdLen           15 5
     c                   endsr
      **********************************************************************************************
      * call exit program
     c     callexit      begsr
      *
      *     fill parm list for exit pgm
     c                   exsr      filextprm
      *     format program name
     c                   if        extpgmlib=*Blanks
     c                   eval      extpgmlib='*LIBL'
     c                   endif
     c                   eval      extpgmnam=%trim(extpgmlib)+'/' +
     c                                       %trim(extpgm)
      *     Call exit program
     c                   call      extpgmnam                            50
     c                   parm      iedef         extdef           10            Definition
     c                   parm                    extsts           10            Status
     c                   parm                    exfilds                        Path/filname/extensi
     c                   parm                    extrpttyp        10            Doc Type
     c                   parm                    extidxcnt                      Index count
     c                   parm                    exidxds                        Index description
     c                   parm                    exvalds                        Index Value
     c                   parm                    extrtncde        10            Return Code
     c                   parm                    extrtnmsg       256            Return Message

      *     Check for an error on the exit program and bubble up the error messages

/1769c                   If        ( extrtncde <> *blanks  )  or
/    c                             ( extrtnmsg <> *blanks )
/    c                   eval      ifsrtnmsg= ExtRtnCde
/    c                   eval      ifsrtndta= ExtRtnMsg
/    c                   Return    ERROR
/    c                   EndIf

      *     Force the Return code of extrtncde to be set
      *     to the following value '*NOARC' if the external
      *     program is MAGIFSSPLF

6009 c                   If        extpgm = 'MAGIFSSPL'
6009 c                   Eval      extrtncde = '*NOARC'
6009 c                   EndIf

      *     Error occured
     c                   if        *in50
     c                   eval      ifsrtnmsg='IFS0006'
     c                   eval      ifsrtndta=extpgmnam
     c                   return    -1
     c                   endif
      *   Use parms for archiving
     c                   if        extsts='*BEFORE'
     c                   exsr      useparms
     c                   endif
      *       Error on exit pgm
     c                   if        extrtnmsg<>*blanks and
     c                             extrtncde<>*blanks
     c                   eval      ifsrtnmsg='BLK9991'
     c                   eval      ifsrtndta=extrtnmsg
     c                   if        extrtncde='*ERROR'
     c                   return    -1
     c                   endif
     c                   endif
      *
     c                   endsr
      **********************************************************************************************
      * Use exit pgm parms
     c     useparms      begsr
      *
      *       Skip this image
     c                   if        extrtncde='*NOARC'
     c                   eval      noarc='1'
     c                   else
      *     Check if passed report type is valid
J3109c                   if        altKeyExists <> #OK
/2684c     extrpttyp     chain     rmaint4
     c                   if        NOT %found
     c                   eval      ifsrtnmsg='IFS0005'
     c                   eval      ifsrtndta=extrpttyp
     c                   return    -1
     c                   endif
J3109c                   endif
     c                   eval      arcrpttyp=extrpttyp
      *     Check if number of index values is valid
T5975c                   if        extpgm <> 'MAGIFSSPL' and
/    c                             (extidxcnt=0 or extidxcnt>maxidx)
     c                   eval      ifsrtnmsg='IFS0007'
     c                   eval      ifsrtndta=*blanks
     c                   return    -1
     c                   endif
      *     Load passed index values
     c                   do        maxidx        ix
     c     ix            occur     exvalds
     c                   eval      arcval(ix)=ev_value
     c                   enddo
     c                   endif
      *
     c                   endsr
      **********************************************************************************************
      * fill parm list for exit pgm
     c     filextprm     begsr
      *
      *     format parms for spylink if provided
     c                   eval      extrpttyp=arcrpttyp                          Doc Type
     c                   if        arcrpttyp<>*blanks
J3109c                   if        altKeyExists <> #OK
/2684c     arcrpttyp     chain     rmaint4
     c                   if        NOT %found
     c                   eval      ifsrtnmsg='IFS0005'
     c                   eval      ifsrtndta=arcrpttyp
     c                   return    -1
     c                   endif
J3109c                   endif
     c     klbig5        klist
     c                   kfld                    RRNAM
     c                   kfld                    RJNAM
     c                   kfld                    RPNAM
     c                   kfld                    RUNAM
     c                   kfld                    RUDAT
     c     klbig5        chain     rlnkdef                            5050
J3109c                   if        *in50 and altKeyExists <> #OK
     c                   eval      ifsrtnmsg='IFS0005'
     c                   eval      ifsrtndta=arcrpttyp
     c                   return    -1
     c                   endif
     c                   do        maxidx        ix
     c                   if        idxnam(ix)=*blanks
     c                   eval      extidxcnt=ix-1
     c                   leave
     c                   endif
     c                   enddo
     c                   else
      *    If docclass is unknown, take all 7 values
     c                   eval      extidxcnt=maxidx
     c                   clear                   idxnam
     c                   endif
      *
     c                   do        maxidx        ix
      *     Fill in index description parm
     c                   eval      ei_dslen  = %size(exidxds)
     c                   eval      ei_name   = idxnam(ix)
     c                   eval      ei_desc   = *blanks
     c                   eval      ei_len    = 0
     c                   if        idxnam(ix)<>*blanks
     c     keyidx        chain     rindex                             5050
     c                   if        *in50
     c                   eval      ifsrtnmsg='IFS0005'
     c                   eval      ifsrtndta=arcrpttyp
     c                   return    -1
     c                   endif
     c     keyidx        klist
     c                   kfld                    RRNAM
     c                   kfld                    RJNAM
     c                   kfld                    RPNAM
     c                   kfld                    RUNAM
     c                   kfld                    RUDAT
     c                   kfld                    idxnam(ix)
     c                   eval      ei_desc   = idesc
     c                   eval      ei_len    = iklen
     c                   endif
      *     Fill in index values parm
     c     ix            occur     exvalds
     c                   eval      ev_dslen  = %size(exidxds)
     c                   eval      ev_idxnam = idxnam(ix)
     c                   eval      ev_value  = arcval(ix)
     c                   enddo
      *
      *     Fill the filename parm structure
     c                   eval      ef_dslen  = %size(exfilds)
     c                   eval      ef_paht   = path
     c                   eval      ef_filnam = filename
     c                   eval      rtn = stat(%addr(path0):%addr(stat_ds))
     c                   eval      lcltimptr = localtime(%addr(st_mtime))
     c                   eval      ef_fildat = lcl_yea*10000+lcl_mon*100+lcl_day
     c                   if        ef_fildat > 800000
     c                   add       19000000      ef_fildat
     c                   else
     c                   add       20000000      ef_fildat
     c                   endif
     c                   eval      ef_filtim = lcl_hou*10000+lcl_min*100+lcl_sec
     c                   eval      ef_filsiz = st_size
      *
     c                   endsr
      **********************************************************************************************
      * archive file  by using SPYPCARC
     c     archive       begsr
      *
     c                   call      'SPYPCARC'                           50
     C                   PARM      ifspath       PrmPCFile       256
     C                   PARM                    PrmDltAft         4
     C                   PARM                    arcrpttyp
     C                   PARM      '*NO'         PrmPmtLnkV        4
     C                   PARM                    arcval(1)
     C                   PARM                    arcval(2)
     C                   PARM                    arcval(3)
     C                   PARM                    arcval(4)
     C                   PARM                    arcval(5)
     C                   PARM                    arcval(6)
     C                   PARM                    arcval(7)
     C                   PARM                    PrmRtnMsg         7
     C                   PARM                    PrmRtnDta       256
     C                   PARM                    PrmRtnTyp        10
      *
     c                   if        *in50
     c                   eval      ifsrtnmsg='IFS0008'
     c                   eval      ifsrtndta=*blanks
     c                   return    -1
     c                   endif
     c                   if        prmrtnmsg<>*blanks
     c                   eval      ifsrtnmsg=prmrtnmsg
     c                   eval      ifsrtndta=prmrtndta
     c                   return    -1
     c                   endif
      *
     c                   endsr
      **********************************************************************************************
      * Check lock by opening file
     c     checklock     begsr
      *
     C                   eval      path0 = %TRIMR(ifspath) + x'00'
     C                   eval      oflag = O_RDONLY + O_SHARE_NO
/9228C                   eval      fildes = open(path0:oflag)
     c                   if        fildes >= 0
/9228c                   callp     close(fildes)
     c                   endif
      *
     c                   endsr
      **********************************************************************************************
      * Get index value based on key
     c     getidx        begsr
      *
     c     ' '           checkr    filename      len
     c                   z-add     1             ix                5 0
     c                   z-add     1             valpos            5 0
     c     ' '           checkr    ieksep        seplen            5 0
     c     ' '           checkr    iekend        endlen            5 0
      *
     c                   eval      pos = 1
     c                   dow       pos <= len

      * Check for index value separator
      * If found, position past separator and loop back around.
     c                   if        %subst(filename:pos:seplen)=
     c                             %subst(ieksep:1:seplen)
     c                   eval      ix = ix + 1
     c                   if        ix > maxidx
     c                   leave
     c                   endif
     c                   eval      pos = pos + seplen
     c                   eval      valpos = 1
     c                   iter
     c                   endif

      * Check for end of parsing separator
      * If found, bail.
     c                   if        endlen > 0 and
     c                               %subst(filename:pos:endlen)=
     c                               %subst(iekend:1:endlen)
     c                   leave
     c                   endif

      * Add charactor to current index value.
     c                   eval      %subst(arcval(ix):valpos:1)=
     c                                 %subst(filename:pos:1)
     c                   eval      pos = pos + 1
     c                   eval      valpos = valpos + 1
     c                   enddo
      *
     c                   endsr
      **********************************************************************************************
      * Get fileextension
     c     getext        begsr
      *
     c                   clear                   extension        30
     c                   clear                   subdir          256
     c                   clear                   filename        256
     c                   clear                   path            256
     c                   move      ' '           gotsubdir         1
     c                   move      ' '           gotpath           1
      *
     c     ' '           checkr    ifspath       len               5 0
     c                   z-add     len           pos               5 0
      *
     c                   do        len
     c                   eval      f1a=%subst(ifspath:pos:1)
      *
     c                   select
     c                   when      f1a='.' and extension=*blanks
     c                   eval      extension=%subst(ifspath:pos+1:
     c                                           len-pos)
      *
     c                   when      f1a='/'
     c                   move      '1'           gotpath           1
     c                   if        subdir=*blanks
     c                   move      '1'           gotsubdir         1
     c                   else
     c                   move      ' '           gotsubdir         1
     c                   endif
     c                   other
      *    Got subdirectory
     c                   if        gotsubdir='1'
     c                   eval      subdir=f1a+%trimr(subdir)
     c                   endif
     c                   endsl
      *
     c                   if        gotpath='1'
     c                   eval      path=f1a+%trimr(path)
     c                   else
     c                   eval      filename=f1a+%trimr(filename)
     c                   endif
      *    Got subdirectory
     c                   sub       1             pos
     c                   enddo
      *
     c     lo:up         xlate     extension     extension
     c     lo:up         xlate     subdir        subdir
      *
     c                   endsr
      **********************************************************************************************
      *    Get the error description for IFS failures
     C     GetErrDsc     begsr
     C                   eval      p_errno = GetErrno
     C                   eval      p_errstr = strerror(errno)
     C                   endsr
      **********************************************************************************************
     P execfile        E
5794  *-------------------------------------------------------------------
5794 pGetPatMth        b
5794  *-------------------------------------------------------------------
5794 d GetPatMth       pi              n
5794 d  aPatMth                     256a   const options(*varsize)
5794 d  aFile                       256a   const options(*varsize)
5794 d  aWildCard                    10a   const options(*varsize:*nopass)
5794
5794 dFALSE            c                   '0'
5794 dTRUE             c                   '1'
5794 DwrkWildCard      S                   Like(aWildCard) Inz('*')
5794 DarrPattern       S            256    Dim(128) Varying
5794 DStart            S              5I 0
5794 DEnd              S              5I 0
5794 DCount            S              5I 0
5794 DNoPatterns       S              5I 0
5794 Di                S              5I 0
5794 DMatch            S               N   Inz(*On)
5794 DMatchBegin       S               N   Inz(*On)
5794 DMatchEnd         S               N   Inz(*On)
5794
5794  /free
5794     //
5794     // Override default wildcard when supplied
5794     //
5794     If %Parms>=3;
5794         wrkWildCard=aWildCard   ;
5794     EndIf;
5794     //
5794     // Ignore cases we know will fail
5794     //
5794     If %Len(wrkWildCard)=*Zero
5794     Or %Len(wrkWildCard)>%Len(aPatMth)
5794     Or %Len(wrkWildCard)>%Len(aFile);
5794         Return FALSE;
5794     EndIf;
5794     //
5794     // Test if we need to do an exact match at the beginning
5794     //
5794     If %Subst(aPatMth:1:%Len(wrkWildCard))=wrkWildCard;
5794         MatchBegin=*Off;
5794     EndIf;
5794     //
5794     // Test if we need to do an exact match at the end
5794     //
5794     If %Subst(aPatMth:%Len(aPatMth)-%Len(wrkWildCard)+1:
5794        %Len(wrkWildCard))=wrkWildCard;
5794         MatchEnd=*Off;
5794     EndIf;
5794
5794     Start=1;
5794     End=%Scan(wrkWildCard:aPatMth);
5794
5794     Dow End > *Zero
5794     And Count < %Elem(arrPattern);
5794         Count = Count + 1;
5794         arrPattern(Count)=%Subst(aPatMth:Start:(End-Start));
5794         Start= End + 1;
5794         If Start <= %Len(aPatMth);
5794             End=%Scan(wrkWildCard:aPatMth:Start);
5794         Else;
5794             End=*Zero;
5794         EndIf;
5794     EndDo;
5794
5794     // Get Last Pattern in List
5794     If Start<=%Len(aPatMth)
5794     And Count<%Elem(arrPattern)
5794     And End=*Zero;
5794         Count = Count + 1;
5794         arrPattern(Count)=%Subst(aPatMth:Start);
5794     EndIf;
5794     NoPatterns=Count;
5794
5794
5794     // For each pattern identified, test if it exists in the search
5794     // string.
5794     Start=1;
5794     For i=1 To NoPatterns;
5794         If arrPattern(i)>'';
5794             // Bail if pattern too long or not found
5794             If %Len(arrPattern(i))<=%Len(aFile)-Start+1;
5794                 Start=%Scan(arrPattern(i):aFile:Start);
5794                 If Start=*Zero;
5794                     Match=*Off;
5794                     Leave;
5794                 EndIf;
5794             Else;
5794                 Match=*Off;
5794                 Leave;
5794             EndIf;
5794             Start = Start + %Len(arrPattern(i));
5794         EndIf;
5794     EndFor;
5794
5794     Return Match;
5794  /End-Free
5794 pGetPatMth        e
5794  *------------------------------------------------------------------

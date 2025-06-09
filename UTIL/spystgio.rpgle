      *%METADATA                                                       *
      * %TEXT SpyView Storage Service Program                          *
      *%EMETADATA                                                      *
      * CRTOPT BNDDIR(QC2LE)
      * CRTOPT DBGVIEW(*ALL)
      **************************************************************************
      *  SpyView Ibm Optical support service  program

      * Provide the following functions that can be bound:
      *   spystgopn       Open for read/write
      *   spystgcls       Close
      *   spystgwrt       write
      *   spystgred       read
      *   spystgsek       seek
      *   spystgmd        make dir
      *   spystgsta       stat
      *   spystgodir      open dir
      *   spystgrdir      read dir
      *   spystgcdir      close dir
      *   spystgcdir      close dir
      *   spystgfree      get frespace for volume
      *   spystgdwn       shut down pgm
      *   spystgaloc      alocate bytes on volume
      *   spystgdloc      dealocate bytes on volume
      *   spystgerr       retrieve error description
      *   spystgrtvb      retrieve backup volume description
/8696 *   spystgtrc       write trace messages to mopttrc

      **************************************************************************

/9314 *  11-18-04 GT  Fix window prototype (wdwstruc like hdlstruc)
/9270 *  10-13-04 PLR Allocation field increased from 10u to 15p to accommodate
      *               splf's larger than 4 gig field size limit.
/8696 *  11-06-03 PLR Enhanced optical tracing. Used for calls to procedures
/     *               in SPYSTGIFS and SPYSTGLAN.
/8226 *   4-17-03 GT  Optimize direct attach reads using QHFCTLFS GET function
/7594 *  12-31-02 JMO Changed logic in spystgmd (make directory) so that
      *                it will not attempt to create the root directory
      *                for IBMDIRCT or IBMLAN device types. (related to bug id 5
/6531 *  05-03-02 PLR Changed byte allocation int to unsigned to handle
/     *               large optical storage.
/4476 *   5-03-01 KAC Disable write to volume when mirroring is off and
      *               "Read from mirror" is on (Redirect to Mirror).
/3321 *  12-29-00 KAC REMOVE OPT ID (OBSOLETE AS OF 6.0.6)
/3663 *  12-28-00 KAC reset optical full flag on *IFS
/3172 *  11-17-00 KAC authorization (mode flag) incorrect on open()
      *   6-21-00 GT  Use CLOSE *ALL in spystgdwn routine.
      *               V3R2 compatibility: Error constant names <= 10 chars
      *   8-10-99 FID New program

      **************************************************************************
      *---------------------------------------------------------------------
     H nomain
     H copyright('Gauss Interprise, Inc. ')
      *---------------------------------------------------------------------
     fmoptaloc  uf a e           k disk    usropn
     fmstgmir   uf a e           k disk    usropn
     fmstgdev   if   e           k disk    usropn
     fmstgvol   uf a e           k disk    usropn
     fmstgvol2  if   e           k disk    usropn
     f                                     rename(stgvolf:stgvolf2)
/8696fmopttrc   o    e             disk    usropn
      *=======================================================================

/8696d clrerrors       pr

     D MOPTAL          DS             1

     D SYSDFT          DS          1024
/8696D  OPTTRC               135    135
     D  PGMLIB               296    305
     D  DTALIB               306    315
     D  OPTTHD               673    676
     D  CTLLIB               683    692

     D                SDS
     D  PGMERR           *STATUS
     D  PGMLIN                21     28
     D  SYSERR                40     46
     D  SPYLIB                81     90
     D  curjob               244    269
     D  JOB                  244    253
     D  USER                 254    263
     D  JOBNUM               264    269
     D  $JOB#                264    269

/8696D RETCD           DS                  export
     D  ERLEN                  1      4B 0 INZ(%size(retcd))
/8696D  RTCD                   5      8B 0 inz
/    D  msgid                  9     15
/    d  reserved              16     16
/    d  msgdta                17     96

     D hdlstruc        DS
     D  hdlvolume                    12
     D  hdldevnam                    10
     D  hdldevtyp                    10
     D  hdldevpth                   120
     D  hdlpath                     250
     D  hdlfilnam                    20
     D  hdlfildes                    10i 0
/8696D  hdlbytes                     15  0 inz
     D  hdlmode                      10i 0
     D  hdlmirror                     1
     D  hdlmirvol                    12
     D  hdlmirdes                    10i 0
     D  hdldomir                      1

     d  domirror       s              1

     D/copy @IFSIO
     D/copy @WCCVTDT
      *=======================================================================
     D/copy @SPYSTGIO
     D/copy @STGIFSIO
     D/copy @STGLANIO
      *=======================================================================
      *  Internal Prototypes

     D window          PR
     D  wdwstruc                           like(hdlstruc)
     D  wdwmod                       10i 0 value
     D  wdwandle                     10i 0

     D devtype         PR
     D  volume                       12
     D  devnam                       10
     D  devtyp                       10
     D  devpath                     120

     D getfree         PR
     D  devtyp                       10
     D  devpath                     120
     D  volume                       12
     D  freespace                          like(freespc_ds)

     D getdate         PR
     D  date_ds                            like(wcoutv)

     D getfilnam       PR            20
     D  path                        250
      *  update mirroring
     D updmirror       PR            10i 0
     D  newvol                       12
     D  filnam                       20
     D closmirror      PR
     D openmirror      PR
     D openfiles       PR
     D opnoptalc       PR
     D fillerror       PR
     D  volume                       12
     D  devnam                       10

      * write trace records to mopttrc.
/8696d spystgtrc       pr
     d  operation                    10    const
     d  volume                       12    const options(*nopass)

/8787 * Retrieve Job Information API
/    d QusRJobI        PR                  extpgm('QUSRJOBI')
     d  jiRcvr                    32767    options(*varsize)
     d  jiRcvrLen                    10i 0 const
     d  jiFmtName                     8    const
     d  jiQualJob                    26    const
     d  jiIntJob                     16    const
     d  jiErrCd                   32767    options(*varsize)

/8787 * HFS Control File System API
/    d QHfCtlFS        PR                  extpgm('QHFCTLFS')
/    d  hfHandle                     16    const
/    d  hfFsName                     10    const
/    d  hfInpBuf                  32767    const options(*varsize)
/    d  hfInpLen                     10i 0 const
/    d  hfOutBuf                  32767    options(*varsize)
/    d  hfOutLen                     10i 0 const
/    d  hfRtnLen                     10i 0
/    d  hfErrCd                   32767    options(*varsize)

     D mod_crthdl      c                   const(1)
     D mod_gethdl      c                   const(2)
     D mod_dlthdl      c                   const(3)
     D mod_sethdl      c                   const(4)

     d cur_msgid       s              7
     d cur_msgdta      s            256
      *=======================================================================
     D wdwuse          S              1    dim(20)
     D wdwstr          S                   dim(20) like(hdlstruc)
     D ErrorCode       S             10i 0
     D Filehandle      S             10i 0
     D rtn             S             10i 0
     D devpath         s            120
     D devtyp          s             10
     D devnam          s             10

     d optmiropn       s              1
     d didopen         s              1
     d alocopn         s              1

     d volume          s             12

     d mirpath         s            180
     d oflag           s             10i 0
     d mode            s             10u 0
     d rtncde          s             10i 0

     d dwn_ibmdir      s              1
     d dwn_ibmlan      s              1
     d dwn_ifs         s              1
/8696d clcmd           s           1024

     C     *DTAARA       DEFINE                  SYSDFT
     C     *DTAARA       DEFINE                  MOPTAL

     C     ALOCKY        KLIST
     C                   KFLD                    OPALVL
     C                   KFLD                    OPAJOB
     C                   KFLD                    OPAUSR
     C                   KFLD                    OPAJNO
      **************************************************************************
      *               Exported Subprocedures
      **************************************************************************
      *  ====================================
      *  spystgrls   ReleaseSav held optical file
      *  ====================================
      **************************************************************************
     P spystgRls       B                   export

     D spystgrls       PI            10i 0
     D  volume                       12    value
     D  newvolume                    12    value
     D  path                        180    value

     D IBUF            S            160
     D OBUF            S             44
     D RBUFL           S             10i 0

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
      *      Get volume description and check if device type is direct attached
     C                   callp     devtype(volume:devnam:devtyp:devpath)
     c                   if        devtyp<>typ_ibmdir
     c                   eval      errorcode=RlsFil_Err
     c                   endif
     c                   if        errorcode=rtn_ok
     C                   callp     devtype(newvolume:devnam:devtyp:devpath)
     c                   if        devtyp<>typ_ibmdir
     c                   eval      errorcode=RlsFil_Err
     c                   endif
     c                   endif

      *    volumes seem to be correct, go ahead and give it a shot
     c                   if        errorcode=rtn_ok
     c                   exsr      rlshldfil
     c                   endif

      *    update mirror status file, if required
     c                   if        errorcode=rtn_ok
     c                   clear                   filnam           20
     c                   movel(p)  path          path250         250
     c                   eval      filnam=getfilnam(path250)
     c                   eval      errorcode=updmirror(newvolume:filnam)
     c                   endif

/8696c                   callp     spystgtrc('RELEASE')

     C                   return    ErrorCode
      **************************************************************************
     C     rlshldfil     BEGSR
      *          Write held file to new volume

     c                   setoff                                       50

      *    get rid of leading slash
     c                   if        %subst(path:1:1)='/'
     c                   eval      %subst(path:1:1)=' '
     c                   endif
      *    format from and to path
     c                   clear                   frmpth           80
     c                   clear                   topth            80

     C                   eval      frmpth=%trim(volume)+'/'+
     c                                  %trim(path)
     C                   eval      topth=%trim(newvolume)+'/'+
     c                                  %trim(path)

      *      use API for risc version

     c                   eval      ibuf='SAV/' +%trim(frmpth) +
     c                                  '//'   +%trim(topth)
     c                   callp     QhfCtlFS(' ': 'QOPT':
     c                                      IBUF: %len(%trimr(IBUF)):
     c                                      OBUF: %size(OBUF):
     c                                      RBUFL: RETCD)
      *        Error occured
     c                   if        rtcd<>0
     c                   seton                                        50
     c                   endif

     c                   eval      ibuf='RLS/' +%trim(frmpth)
     c                   callp     QhfCtlFS(' ': 'QOPT':
     c                                      IBUF: %len(%trimr(IBUF)):
     c                                      OBUF: %size(OBUF):
     c                                      RBUFL: RETCD)

     c                   if        *in50
     c                   eval      errorcode=RlsFil_Err
     C                   endif

     C                   ENDSR
      **************************************************************************
     P spystgrls       E
      **************************************************************************
      *  ====================================
      *  spystgOpn   Open file for read/write
      *  ====================================
      **************************************************************************
     P spystgOpn       B                   export
     D spystgOpn       PI            10i 0
     D  volume                       12    value
     D  path                        180    value
     D  mode                         10i 0 value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok

     c                   clear                   domirror
     c                   if        mode=mod_mirror
     c                   eval      domirror='1'
     c                   eval      mode=mod_write
     c                   endif

      *      Get volume description
     C                   callp     devtype(volume:devnam:devtyp:devpath)

      *      If write open, verify if device is writeable
     c                   if        ErrorCode=rtn_ok and
     c                             mode=mod_write
     c                   select
      *      Write protected when mirror volume
     c                   when      svtyp = 'Y' and
     c                             domirror<>'1'
     c                   eval      ErrorCode=VolUse_Mir
      *      Write protected
     c                   when      sdwrt <> 'Y'
/4476c                               or (svbtyp='N' and svrfm = 'Y')
     c                   eval      ErrorCode=NoWrt_Err
      *      If write open, verify if platter is full
     c                   when      svful = 'Y'
     c                   eval      ErrorCode=VolFul_Err
     c                   endsl
     c                   endif

      *        Check if mode, that was passed is ok.
     c                   if        ErrorCode=rtn_ok
     c                   if        mode<>mod_write and
     c                             mode<>mod_read
     c                   eval      ErrorCode=OpnMod_Err
     c                   endif
     c                   endif

      *        Get the window handle for this mode.
     c                   if        ErrorCode=rtn_ok
     C                   callp     window(hdlstruc:mod_crthdl:filehandle)
     c                   if        filehandle<1
     c                   eval      ErrorCode=filehandle
     c                   endif
     c                   endif

      *      If write, check if morroring is requested
     c                   move      'N'           hdlmirror
     c                   clear                   hdlmirvol
     c                   if        ErrorCode=rtn_ok and
     c                             mode=mod_write  and
     c                             svbtyp<>'N' and svbtyp <>' '
     c                   eval      hdlmirror=svbtyp
     c                   eval      hdlmirvol=svbvol
     c                   endif

      *        Open file
     c                   if        ErrorCode=rtn_ok
     c                   exsr      opnfile
     c                   endif
      *        If mirroring is required, go ahead and write record to sts db
     c                   if        hdlmirror<>'N' and
     c                             hdlmode=mod_write and
     c                             ErrorCode=rtn_ok
     c                   callp     openmirror
     c                   endif

      *        Store handle settings
     c                   if        ErrorCode>=rtn_ok
     C                   callp     window(hdlstruc:mod_sethdl:filehandle)
     c                   if        filehandle<rtn_ok
     c                   eval      ErrorCode=filehandle
     c                   endif
     c                   else
     C                   callp     window(hdlstruc:mod_dlthdl:filehandle)
     c                   endif

      *        Return file handle, if everything went fine
     c                   if        ErrorCode=rtn_ok
     c                   eval      errorCode = filehandle
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   else
     c                   endif

/8696c                   callp     spystgtrc('OPEN')

     C                   return    ErrorCode
      **************************************************************************
      *  Open file in IFS
     c     opnfile       begsr

     c                   eval      hdlmode   = mode
     c                   eval      hdldomir  = domirror
     c                   eval      hdlpath   = %trim(path)
     c                   eval      hdlfilnam = getfilnam(hdlpath)
     c                   eval      hdlvolume = volume
     c                   eval      hdldevtyp = devtyp
     c                   eval      hdldevnam = devnam
     c                   eval      hdldevpth = devpath
     c                   eval      hdlbytes  = 0
      *  Call module based uppon device type
     c                   select
/8226c                   when      hdldevtyp=typ_ibmdir
/    c                   eval      hdlfildes=ibmdiropn(devpath:volume:
/    c                                              hdlPath:mode)
     c                   when      hdldevtyp=typ_ibmlan
     c                   eval      hdlfildes=ibmlanopn(devpath:volume:
     c                                              hdlPath:mode)
/8226c                   when      hdldevtyp=typ_ifs
     c                   eval      hdlfildes=ibmifsopn(devpath:volume:
     c                                              hdlPath:mode)
     c                   endsl

     c                   if        hdlfildes<0
     c                   eval      errorCode = hdlfildes
     c                   else
      *       Update volume usage
     c     hdlvolume     chain     stgvolf                            5050
     c                   if        not *in50
     c                   callp     getdate(wcoutv)
     c                   if        mode=mod_write
     c                   eval      svdlw = wcdate
     c                   eval      svtlw = wctime
     c                   else
     c                   eval      svdlr = wcdate
     c                   eval      svtlr = wctime
     c                   endif
     c                   update    stgvolf
     c                   endif
     c                   endif

     c                   endsr
     P spystgOpn       E
      **************************************************************************
      *  ====================================
      *  spystgCls   close file
      *  ====================================
      **************************************************************************
     P spystgCls       B                   export
     D spystgCls       PI            10i 0
     D  filhdl                       10i 0 value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
      *        Get the window handle for this mode.
     c                   eval      filehandle=filhdl
     C                   callp     window(hdlstruc:mod_gethdl:filehandle)
     c                   if        filehandle<rtn_ok
     c                   eval      ErrorCode=FilCls_Err
     c                   endif
      *       Close file
     c                   if        ErrorCode=rtn_ok
     c                   exsr      clsfile
     c                   endif
      *        delete handle
     C                   callp     window(hdlstruc:mod_dlthdl:filehandle)
     c                   if        errorcode=rtn_ok
     c                   eval      ErrorCode=filehandle
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   else
      *        Close mirroring
     c                   if        hdlmirror<>'N' and
     c                             hdlmode=mod_write
     c                   callp     closmirror
     c                   endif
     c                   endif

/8696c                   callp     spystgtrc('CLOSE')

     C                   return    ErrorCode
      **************************************************************************
      *  Close file in IFS
     c     clsfile       begsr
      *  Call module based uppon device type
     c                   select
     c                   when      hdldevtyp=typ_ibmdir
     c                   eval      errorcode = ibmdircls(hdlfildes)
     c                   when      hdldevtyp=typ_ibmlan
     c                   eval      errorcode = ibmlancls(hdlfildes)
     c                   when      hdldevtyp=typ_ifs
     c                   eval      errorcode = ibmifscls(hdlfildes)
     c                   endsl

     c                   endsr
     P spystgCls       E
      **************************************************************************
      *  ====================================
      *  spystgWrt   Write data to file
      *  ====================================
      **************************************************************************
     P spystgWrt       B                   export
     D spystgWrt       PI            10i 0
     D  filhdl                       10i 0 value
     d  buf                       32767a   options(*varsize)
     d  nbyte                        10i 0 value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
      *        Get the window handle for this mode.
     c                   eval      filehandle=filhdl
     C                   callp     window(hdlstruc:mod_gethdl:filehandle)
     c                   if        filehandle<rtn_ok
     c                   eval      ErrorCode=FilWrt_Err
     c                   endif
      *       Write file
     c                   if        ErrorCode=rtn_ok
     c                   exsr      wrtfile
     c                   endif
      *        Store handle settings
     c                   if        ErrorCode>=rtn_ok
     C                   callp     window(hdlstruc:mod_sethdl:filhdl)
     c                   else
     C                   callp     window(hdlstruc:mod_dlthdl:filhdl)
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
/8696c                   callp     fillerror(hdlvolume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('WRITE')

     C                   return    ErrorCode
      **************************************************************************
      *  write file in IFS
     c     wrtfile       begsr
     c                   select
     c                   when      hdldevtyp=typ_ibmlan
     c                   eval      errorcode = ibmlanwrt(hdlfildes:buf:nbyte)
     c                   when      hdldevtyp=typ_ifs or
     c                             hdldevtyp=typ_ibmdir
     c                   eval      errorcode = ibmifswrt(hdlfildes:buf:nbyte)
     c                   endsl

     c                   if        errorcode>=rtn_ok

     c                   add       errorcode     hdlbytes
      *       Update bytes used in volume
     c                   exsr      updvolume

      *    If morroring is required, write out to mirror file
     c                   if        hdlmirror<>'N'
     c                   eval      rtncde=write(hdlmirdes:buf:nbyte)
     c                   if        rtncde<>nbyte
     c                   eval      errorcode=StgMir_Err
     c                   endif
     c                   endif
     c
     c                   endif

     c                   endsr
      **************************************************************************
      *  update volume (bytes used, last use etc.)
     c     updvolume     begsr

     c     hdlvolume     chain     stgvolf                            5050
     c                   if        not *in50
     c                   add       errorcode     svuse
     c                   callp     getdate(wcoutv)
     c                   eval      svdlw = wcdate
     c                   eval      svtlw = wctime
     c                   if        svdfu = 0
     c                   eval      svdfu = wcdate
     c                   eval      svtfu = wctime
     c                   endif
      *        Check if ifs, if platter is full
     c                   if        hdldevtyp=typ_ifs
     c     *like         define    svcap         cap
     c     *like         define    svthr         thr
     c                   if        svcap=0
     c                   eval      cap=sdcap
     c                   else
     c                   eval      cap=svcap
     c                   endif
     c                   if        svthr=0
     c                   eval      thr=sdthr
     c                   else
     c                   eval      thr=svthr
     c                   endif
     c                   if        thr=0
     c                   eval      thr=99.9
     c                   endif
     c                   if        cap*thr/100<=svuse
     c                   eval      svful='Y'
     c                   else
     c                   eval      svful='N'
     c                   endif
     c                   endif
     c                   update    stgvolf
     c                   endif
     c                   endsr
      **************************************************************************
     P spystgWrt       E
      **************************************************************************
      *  ====================================
      *  spystgSek   Seek file (set position)
      *  ====================================
      **************************************************************************
     P spystgSek       B                   export
     D spystgSek       PI            10i 0
     D  filhdl                       10i 0 value
     d  relofs                       10i 0 value
     d  whence                       10i 0 value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
      *        Get the window handle for this mode.
     c                   eval      filehandle=filhdl
     C                   callp     window(hdlstruc:mod_gethdl:filehandle)
     c                   if        filehandle<rtn_ok
     c                   eval      ErrorCode=FilRed_Err
     c                   endif
      *       Write file
     c                   if        ErrorCode=rtn_ok
     c                   exsr      seekfile
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('SEEK')

     C                   return    ErrorCode
      **************************************************************************
      * seek file in IFS
     c     seekfile      begsr
     c                   select
/8226c                   when      hdldevtyp=typ_ibmdir
/    c                   eval      errorcode =ibmdirsek(hdlfildes:relofs:whence)
     c                   when      hdldevtyp=typ_ibmlan
     c                   eval      errorcode =ibmlansek(hdlfildes:relofs:whence)
/8226c                   when      hdldevtyp=typ_ifs
     c                   eval      errorcode =ibmifssek(hdlfildes:relofs:whence)
     c                   endsl
     c                   endsr
     P spystgSek       E
      **************************************************************************
      *  ====================================
      *  spystgRed   Read file
      *  ====================================
      **************************************************************************
     P spystgRed       B                   export
     D spystgRed       PI            10i 0
     D  filhdl                       10i 0 value
     d  buf                       32767a   options(*varsize)
     d  nbyte                        10i 0 value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
      *        Get the window handle for this mode.
     c                   eval      filehandle=filhdl
     C                   callp     window(hdlstruc:mod_gethdl:filehandle)
     c                   if        filehandle<rtn_ok
     c                   eval      ErrorCode=FilRed_Err
     c                   endif
      *       Write file
     c                   if        ErrorCode=rtn_ok
     c                   exsr      redfile
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('READ')

     C                   return    ErrorCode
      **************************************************************************
      * read file in IFS
     c     redfile       begsr
     c                   select
/8226c                   when      hdldevtyp=typ_ibmdir
/    c                   eval      errorcode = ibmdirred(hdlfildes:buf:nbyte)
     c                   when      hdldevtyp=typ_ibmlan
     c                   eval      errorcode = ibmlanred(hdlfildes:buf:nbyte)
/8226c                   when      hdldevtyp=typ_ifs
     c                   eval      errorcode = ibmifsred(hdlfildes:buf:nbyte)
     c                   endsl
     c                   endsr
     P spystgRed       E
      **************************************************************************
      *  ====================================
      *  spystgMD    Make directory
      *  ====================================
      **************************************************************************
     P spystgMD        B                   export
     D spystgMd        PI            10i 0
     D  volume                       12    value
     D  path                        180    value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok

     C                   callp     devtype(volume:devnam:devtyp:devpath)
/7594c
/7594c* if the device type is IBMLAN or IBMDIRCT and the path is
/7594c*  the root path (i.e. "/") then skip over creating directory.
/7594c*  The root directory will always already exist for these device types.
/7594c                   if        (devtyp = typ_ibmlan or devtyp = typ_ibmdir)
/7594c                             and path = '/'
/7594c                   return    errorcode
/7594c                   endif
/7594c
      *       Make directory
     c                   if        ErrorCode=rtn_ok
     c                   exsr      makedir
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('MAKEDIR')

     C                   return    ErrorCode
      **************************************************************************
      * Make directory
     c     makedir       begsr

     c                   select
     c                   when      devtyp=typ_ibmlan
     c                   eval      errorcode = ibmlanmd(devpath:volume:path)
     c                   when      hdldevtyp=typ_ifs or
     c                             hdldevtyp=typ_ibmdir
     c                   eval      errorcode = ibmifsmd(devpath:volume:path)
     c                   endsl

     c                   endsr
     P spystgMD        E
      **************************************************************************
      *  ====================================
      *  spystgSta   Stat (get status info for file)
      *  ====================================
      **************************************************************************
     P spystgSta       B                   export

     D spystgSta       PI            10i 0
     D  volume                       12    value
     D  path                        180    value
     d  filinf                             like(filinf_ds)

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok

     C                   callp     devtype(volume:devnam:devtyp:devpath)
      *       get status info
     c                   if        ErrorCode=rtn_ok
     c                   exsr      statsr
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('STATUS')

     C                   return    ErrorCode
      **************************************************************************
      * Get status info for file
     c     statsr        begsr

     c                   select
     c                   when      devtyp=typ_ibmlan
     c                   eval      errorcode = ibmlansta(devpath:volume:path:
     c                                           filinf)
     c                   when      hdldevtyp=typ_ifs or
     c                             hdldevtyp=typ_ibmdir
     c                   eval      errorcode = ibmifssta(devpath:volume:path:
     c                                           filinf)
     c                   endsl

     c                   endsr
     P spystgsta       E
      **************************************************************************
      *  ====================================
      *  spystgODir  Open directory
      *  ====================================
      **************************************************************************
     P spystgODir      B                   export
     D spystgODir      PI            10i 0
     D  volume                       12    value
     D  path                        180    value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok

     C                   callp     devtype(volume:devnam:devtyp:devpath)
      *        Get the window handle for this mode.
     c                   if        ErrorCode=rtn_ok
     C                   callp     window(hdlstruc:mod_crthdl:filehandle)
     c                   if        filehandle<1
     c                   eval      ErrorCode=filehandle
     c                   endif
     c                   endif
      *        Open file
     c                   if        ErrorCode=rtn_ok
     c                   exsr      opndir
     c                   endif
      *        Store handle settings
     c                   if        ErrorCode>=rtn_ok
     C                   callp     window(hdlstruc:mod_sethdl:filehandle)
     c                   if        filehandle<rtn_ok
     c                   eval      ErrorCode=filehandle
     c                   endif
     c                   else
     C                   callp     window(hdlstruc:mod_dlthdl:filehandle)
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('OPENDIR')

     C                   return    ErrorCode
      **************************************************************************
      *  Open directory in ifs
     c     opndir        begsr
     c                   eval      hdlvolume = volume
     c                   eval      hdldevtyp = devtyp
     c                   eval      hdldevnam = devnam
     c                   eval      hdldevpth = devpath
     c                   select
     c                   when      hdldevtyp=typ_ibmlan
     c                   eval      hdlfildes = ibmlanodir(devpath:volume:path)
     c                   when      hdldevtyp=typ_ifs or
     c                             hdldevtyp=typ_ibmdir
     c                   eval      hdlfildes = ibmifsodir(devpath:volume:path)
     c                   endsl

     c                   eval      errorcode=hdlfildes
      *       Update volume usage
     c     hdlvolume     chain     stgvolf                            5050
     c                   if        not *in50
     c                   callp     getdate(wcoutv)
     c                   eval      svdlr = wcdate
     c                   eval      svtlr = wctime
     c                   update    stgvolf
     c                   endif

     c                   endsr
     P spystgODir      E
      **************************************************************************
      *  ====================================
      *  spystgCDir  Close directory
      *  ====================================
      **************************************************************************
     P spystgCDir      B                   export
     D spystgCdir      PI            10i 0
     D  filhdl                       10i 0 value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
      *        Get the window handle for this mode.
     c                   eval      filehandle=filhdl
     C                   callp     window(hdlstruc:mod_gethdl:filehandle)
     c                   if        filehandle<rtn_ok
     c                   eval      ErrorCode=FilCls_Err
     c                   endif
      *       Close file
     c                   exsr      clsdir
      *        delete file handle
     C                   callp     window(hdlstruc:mod_dlthdl:filehandle)
     c                   if        filehandle=rtn_ok
     c                   eval      ErrorCode=filehandle
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('CLOSEDIR')

     C                   return    ErrorCode
      **************************************************************************
      *  Close directory
     c     clsdir        begsr
     c                   select
     c                   when      hdldevtyp=typ_ibmlan
     c                   eval      errorcode = ibmlancdir(hdlfildes)
     c                   when      hdldevtyp=typ_ifs or
     c                             hdldevtyp=typ_ibmdir
     c                   eval      errorcode = ibmifscdir(hdlfildes)
     c                   endsl
     c                   endsr
     P spystgCdir      E
      **************************************************************************
      *  ====================================
      *  spystgRDir  Read directory
      *  ====================================
      **************************************************************************
     P spystgRDir      B                   export

     D spystgRdir      PI            10i 0
     D  filhdl                       10i 0 value
     D  dirent                             like(dirent_ds)

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
      *        Get the window handle for this mode.
     c                   eval      filehandle=filhdl
     C                   callp     window(hdlstruc:mod_gethdl:filehandle)
     c                   if        filehandle<rtn_ok
     c                   eval      ErrorCode=FilRed_Err
     c                   endif
      *       Close file
     c                   exsr      reddir
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('READDIR')

     C                   return    ErrorCode
      **************************************************************************
      * Read directory
     c     reddir        begsr
     c                   select
     c                   when      hdldevtyp=typ_ibmlan
     c                   eval      errorcode = ibmlanrdir(hdlfildes:dirent)
     c                   when      hdldevtyp=typ_ifs or
     c                             hdldevtyp=typ_ibmdir
     c                   eval      errorcode = ibmifsrdir(hdlfildes:dirent)
     c                   endsl
     c                   endsr
     P spystgRdir      E
      **************************************************************************
      *  ====================================
      *  spystgaloc  allocate storage on volume
      *  ====================================
      **************************************************************************
     P spystgaloc      B                   export

     D spystgaloc      PI            10i 0
     D  volume                       12    value
/9270d  nbyte                        15p 0 value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok

      *      allocate storage, if platter is ok
     c                   if        errorcode=rtn_ok
     c                   exsr      allocate
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('ALLOCATE':volume)

     C                   return    ErrorCode
      **************************************************************************
     C     allocate      BEGSR

      *          Reserve ALCBYT bytes on MOPTALOC record (OPALOR).
     c                   if        alocopn<>'1'
     c                   callp     opnoptalc
     c                   endif

     C                   MOVEL     volume        OPALVL
     C                   MOVEL     JOB           OPAJOB
     C                   MOVEL     USER          OPAUSR
     C                   MOVEL     JOBNUM        OPAJNO
     C     ALOCKY        CHAIN     OPALOR                             5050

     C                   IF        *in50
     C                   Z-ADD     nbyte         OPALOC
     C                   WRITE     OPALOR
     C                   ELSE
     C                   Z-ADD     nbyte         OPALOC
     C                   UPDATE    OPALOR
     C                   endif
     C                   endsr
     P spystgaloc      E
      **************************************************************************
      *  ====================================
      *  spystgdloc  delocate storage on volume
      *  ====================================
      **************************************************************************
     P spystgdloc      B                   export
     D spystgdloc      PI            10i 0
     D  volume                       12    value
     d  nbyte                        10i 0 value

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok

      *      allocate storage, if platter is ok
     c                   if        errorcode=rtn_ok
     c                   exsr      delocate
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

/8696c                   callp     spystgtrc('DEALLOCATE')

     C                   return    ErrorCode
      **************************************************************************
     C     delocate      BEGSR

      *          Reserve ALCBYT bytes on MOPTALOC record (OPALOR).
     c                   if        alocopn<>'1'
     c                   callp     opnoptalc
     c                   endif

     C                   MOVEL     volume        OPALVL
     C                   MOVEL     JOB           OPAJOB
     C                   MOVEL     USER          OPAUSR
     C                   MOVEL     JOBNUM        OPAJNO
     C     ALOCKY        CHAIN     OPALOR                             50

     C                   IF        not *in50
     C                   sub       nbyte         OPALOC
     c                   if        opaloc<=0
     C                   delete    OPALOR
     c                   else
     C                   UPDATE    OPALOR
     C                   endif
     C                   endif
     C                   endsr
     P spystgdloc      E
      **************************************************************************
      *  ====================================
      *  spystgfree  Get Freespace
      *  ====================================
      **************************************************************************
     P spystgfree      B                   export
     D spystgfree      PI            10i 0
     D  volume                       12    value
     D  freespace                          like(freespc_ds)

     d JOBDTA          S            102
     d JOBPRM          S             26
     d INTJOB          S             16

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
     c                   clear                   fs_percnt
     c                   clear                   fs_thrhld
     c                   clear                   fs_capcty
     c                   clear                   fs_used
     c                   clear                   fs_free
     c                   clear                   fs_aloc
     c                   clear                   fs_write

     C                   callp     devtype(volume:devnam:devtyp:devpath)

     c                   if        errorcode=rtn_ok
     c                   callp     getfree(devtyp:devpath:volume:freespc_ds)
     c                   endif
      *      Get prev. allocate storrage
     c                   if        errorcode>=rtn_ok
     c                   exsr      getalloc
     c                   endif
      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif

     c                   eval      freespace=freespc_ds

/8696c                   callp     spystgtrc('GETFREE':volume)

     C                   return    ErrorCode
      **************************************************************************
     C     getalloc      BEGSR

      *          Read the optical alloc file MOptAloc for volume.
      *          Delete records for inactive jobs (or this one).

     c                   if        alocopn<>'1'
     c                   callp     opnoptalc
     c                   endif

     C                   Z-ADD     0             fs_aloc
     C     volume        SETLL     OPALOR

     C                   dou       *in50
     C     volume        READE     OPALOR                                 50
     C   50              LEAVE

      * From active job?
     c                   eval      jobprm=opajob+opausr+opajno
     c                   callp     QusRJobI(JOBDTA: %size(JOBDTA):
     c                               'JOBI0600': JOBPRM: INTJOB: RETCD)

     c                   clear                   jobsts           10
     c                   eval      jobsts=%subst(jobdta:51:10)

      * Yes,accum
     C                   if        rtcd = 0           and
     C                             jobsts <> '*OUTQ'  and
     c                             jobprm = curjob
      *  only count alocation from other jobs
     c                   if        jobprm <> curjob
     C                   ADD       OPALOC        fs_aloc
     c                   endif
      * No,delete
     C                   ELSE
     C                   DELETE    OPALOR
     C                   endif
     C                   enddo

     c                   unlock    moptaloc

     c                   eval      fs_write=sdwrt

     C                   endsr
     P spystgfree      E
      **************************************************************************
      *  ====================================
      *  spystgdwn   shut down pgm
      *  ====================================
      **************************************************************************
     P spystgdwn       B                   export
     D spystgdwn       PI            10i 0

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
      *  Shut down the programs that have been marked as open
     c                   if        dwn_ibmlan = '1'
     c                   eval      errorcode = ibmlandwn
     c                   endif
     c                   if        dwn_ifs    = '1' or
     c                             dwn_ibmdir = '1'
     c                   eval      errorcode = ibmifsdwn
     c                   endif
      *    Close files
     c                   close     *all
     c                   clear                   didopen
     c                   clear                   optmiropn
     c                   clear                   alocopn

      *        Fill error fields if error occured
     c                   if        ErrorCode<rtn_ok
     c                   callp     fillerror(volume:devnam)
     c                   endif
/8696c                   callp     spystgtrc('SHUTDOWN')
     C                   return    ErrorCode
     P spystgdwn       E
      **************************************************************************
      *  ====================================
      *  spystgerr   get error description
      *  ====================================
      **************************************************************************
     P spystgerr       B                   export
     D spystgerr       PI            10i 0
     D  err_msgid                     7
     D  err_msgdta                  256

     c                   eval      errorcode=rtn_ok
     c                   eval      err_msgid   =cur_msgid
     c                   eval      err_msgdta  =cur_msgdta
     C                   return    ErrorCode
     P spystgerr       E
      **************************************************************************
     P getfree         B
     D getfree         PI
     D  devtyp                       10
     D  devpath                     120
     D  volume                       12
     D  freespace                          like(freespc_ds)

     c                   clear                   fs_percnt
     c                   clear                   fs_thrhld
     c                   clear                   fs_capcty
     c                   clear                   fs_used
     c                   clear                   fs_free
     c                   clear                   fs_aloc
     c                   clear                   fs_write

     c                   select
     c                   when      devtyp=typ_ibmdir
     c                   eval      errorcode= ibmdirfree(devpath:volume:
     c                                                 freespace)
     c                   when      devtyp=typ_ibmlan
     c                   eval      errorcode= ibmlanfree(devpath:volume:
     c                                                 freespace)
     c                   when      devtyp=typ_ifs
     c                   eval      errorcode= ibmifsfree(devpath:volume:
     c                                                 freespace)
     c                   endsl

     c                   clear                   fs_aloc
     c                   if        errorcode=rtn_ok
     c                   eval      fs_volume=volume
     c                   if        fs_thrhld=0
     c                   eval      fs_thrhld=100
     c                   endif
     c                   else
      *  Error clear out fields
     c                   clear                   fs_percnt
     c                   clear                   fs_thrhld
     c                   clear                   fs_capcty
     c                   clear                   fs_used
     c                   clear                   fs_free
     c                   clear                   fs_aloc
     c                   clear                   fs_write
     c                   endif
     P getfree         E
      **************************************************************************
     P window          B
     D window          PI
     D  wdwstruc                           like(hdlstruc)
     D  wdwmod                       10i 0 value
     D  wdwhandle                    10i 0

     c                   select
      *   Create new handle
     c                   when      wdwmod =mod_crthdl
     c                   z-add     1             ix                5 0
     c     ' '           lookup    wdwuse(ix)                             50
     c                   if        *in50
     c                   move      '1'           wdwuse(ix)
     c                   eval      wdwhandle=ix
     c                   reset                   hdlstruc
     c                   else
     c                   eval      wdwhandle=AllUse_Err
     c                   endif
      *   Get current handle
     c                   when      wdwmod =mod_gethdl

     c                   if        wdwhandle>0
     c                   if        wdwuse(wdwhandle)=' '
     c                   eval      wdwhandle=HdlUse_Err
     c                   else
     c                   eval      hdlstruc=wdwstr(wdwhandle)
     c                   endif
     c                   else
     c                   eval      wdwhandle=HdlInv_Err
     c                   endif
      *   Delete current handle
     c                   when      wdwmod =mod_dlthdl

     c                   if        wdwhandle>0
     c                   eval      wdwuse(wdwhandle)=' '
     c                   eval      wdwhandle=rtn_ok
     c                   else
     c                   eval      wdwhandle=HdlInv_Err
     c                   endif

      *   set parms for handle
     c                   when      wdwmod =mod_sethdl

     c                   if        wdwhandle>0
     c                   eval      wdwstr(wdwhandle)=hdlstruc
     c                   else
     c                   eval      wdwhandle=HdlInv_Err
     c                   endif

     c                   endsl
     P Window          E
      *=======================================================================
      **************************************************************************
     P devtype         B
     D devtype         PI
     D  volume                       12
     D  devnam                       10
     D  devtyp                       10
     D  devpath                     120
      *     Set non mirroring as standard (gets overwritten later)
     c                   move      'N'           svbtyp
     c                   move      *blanks       svbvol

     C                   IN        SYSDFT
      *        Open files of not done yet
     c                   if        didopen<>'1'
     c                   callp     openfiles
     c                   endif

     c                   clear                   devtyp
     c                   clear                   devpath
     c                   clear                   devnam
      *   if *IFS, pass back no path for device and dev type = IFS
     c                   if        volume = ifs_vol
     c                   eval      devtyp = typ_ifs
     c                   eval      sdwrt = 'Y'
/3663c                   eval      svful = 'N'
     c                   else

     c     volume        chain(n)  stgvolf                            5050
     c                   if        *in50
      *  Unable to find optical volume in table, guess device
     c                   eval      devpath='/QOPT'
      *     Volume was not found in table, try to check if volume is
      *     available and add entry to table.
/3321c                   eval      devtyp=typ_ibmdir
/    c                   callp     getfree(devtyp:devpath:volume:freespc_ds)
/    c                   if        errorcode<rtn_ok
/    c                   eval      devtyp=typ_ibmlan
     c                   callp     getfree(devtyp:devpath:volume:freespc_ds)
/    c                   endif
     c                   if        errorcode>=rtn_ok
     c                   exsr      addstgvol
     c                   endif
     c     volume        chain(n)  stgvolf                            5050
     c                   if        *in50
     c                   eval      errorcode=VolFnd_Err
/8696c                   eval      devtyp = ' '
     c                   endif
     c                   endif
      *      Get device
     c                   if        errorcode>=rtn_ok
     c     svdev         chain     stgdevf                            5050
     c                   if        *in50
     c                   eval      errorcode=DevFnd_Err
     c                   else
     c                   eval      devtyp= sdtyp
     c                   eval      devpath=sdpth
     c                   eval      devnam =sddev
     c                   endif
     c                   endif
      *    Check if device is active
     c                   if        errorcode>=rtn_ok and
     c                             sdact='N'
     c                   eval      errorcode=DevAct_Err
     c                   endif
      *    Check if volume is active
     c                   if        errorcode>=rtn_ok and
     c                             svact='N'
     c                   eval      errorcode=VolAct_Err
     c                   endif
     c                   endif

      *   mark device type as open for later shut down
     c                   select
     c                   when      devtyp=typ_ibmdir
     c                   eval      dwn_ibmdir='1'
     c                   when      devtyp=typ_ibmlan
     c                   eval      dwn_ibmlan='1'
     c                   when      devtyp=typ_ifs
     c                   eval      dwn_ifs   ='1'
     c                   endsl

      **************************************************************************
      * Add volume entry to table
     c     addstgvol     begsr

     c     *loval        setll     stgdevf
     c                   do        *hival
     c                   read      stgdevf                              5050
     c   50              leave
     c                   if        sdtyp=devtyp
     c                   leave
     c                   endif
     c                   enddo

     c                   clear                   stgvolf
     c                   callp     getdate(wcoutv)
     c                   eval      SVVOL  = volume
     c                   eval      SVACT  = 'Y'
     c                   eval      SVTYP  = 'N'
     c                   eval      SVUSE  = fs_used
     c                   eval      SVCAP  = fs_capcty
     c                   if        fs_free>18000000
     c                   eval      SVFUL  = 'N'
     c                   else
     c                   eval      SVFUL  = 'Y'
     c                   eval      svdtr=wcdate
     c                   eval      svttr=wctime
     c                   endif
     c                   eval      SVDEV  = sddev
     c                   eval      SVBTYP = 'N'
     c                   eval      svdfu=wcdate
     c                   eval      svtfu=wctime
     c                   write     stgvolf                              50

     c                   endsr
     P devtype         E
      **************************************************************************
     P getdate         B
      * Get current system date/time
     D getdate         PI
     D  date_ds                            like(wcoutv)
     C                   CALL      'QWCCVTDT'
     C                   PARM      '*CURRENT'    WCINPF           10
     C                   PARM                    WCINPV           20
     C                   PARM      '*YYMD'       WCOUTF           10
     C                   PARM                    date_ds
     C                   PARM      *ALLX'00'     ErrRtn           80
     P getdate         E
      **************************************************************************
     P openfiles       B
      * Open the files used for this pgm
     D openfiles       PI
     c                   eval      clcmd='OVRDBF FILE(MSTGDEV) '+
     c                                   'SHARE(*YES)'
/8696c                   callp     runSysCmd(clcmd:retcd)

     c                   open      MSTGDEV

     c                   eval      clcmd='OVRDBF FILE(MSTGVOL) '+
     c                                   'SHARE(*YES)'
/8696c                   callp     runSysCmd(clcmd:retcd)

     c                   open      MSTGVOL

     c                   open      MSTGVOL2

     c                   eval      didopen='1'
     P openfiles       E
      **************************************************************************
     P opnoptalc       B
      * Open the files used for this pgm
     D opnoptalc       PI

      *---------------------------------------------------------------
      * If CTLLIB is empty (or the same as PGMLIB), we can easily
      *    lock the MOPTAL DtaAra and use DTALIB to OvrDbf MOPTALOC.

      * Else Multi-SpyView pgm librs exist and we must lock the DtaAra    *INZSR
      *    in CTLLIB and use the MOPTALOC file in CTLLIB's DTALIB.
      *---------------------------------------------------------------
     C     CTLLIB        IFEQ      *BLANKS
     C     CTLLIB        OREQ      PGMLIB
     C     *LOCK         IN        MOPTAL
     C                   MOVE      DTALIB        CTLDTA           10
     c                   out       moptal
     C                   ELSE

     c                   eval      clcmd ='ALCOBJ WAIT(600) OBJ((' +
     c                                    %trim(ctllib)  +
     c                                    '/MOPTAL *DTAARA *EXCL))'
/8696c                   callp     runSysCmd(clcmd:retcd)
/    c                   if        rtcd > 0
     c                   eval      errorcode=Unk_Err
     c                   goto      endopnalc
     c                   endif

     C                   MOVE      'Y'           LAREA             1

     C                   CALL      'GETDTAAR'
     C                   PARM      CTLLIB        GLIBR            10
     C                   PARM      'SYSDFT'      GAREA            10
     C                   PARM      '0306'        GFROM             4
     C                   PARM      '0010'        GLEN              4
     C     CTLDTA        PARM                    GVALU            20
     C                   END
      * Ovr & Open
     c                   eval      clcmd ='OVRDBF FILE(MOPTALOC) TOFILE(' +
     c                                    %trim(ctldta)  +
     c                                    '/MOPTALOC)'
/8696c                   callp     runSysCmd(clcmd:retcd)

     C                   OPEN      MOPTALOC

     c                   eval      alocopn='1'

     c     endopnalc     tag
     P opnoptalc       E
      **************************************************************************
     P fillerror       B
      * Fill error structures
     D fillerror       PI
     D  volume                       12
     D  devnam                       10
     c
     c                   eval      cur_msgdta= volume+devnam
     c
     c                   select
     c                   when      errorcode = OpnMod_Err
     c                   eval      cur_msgid = 'STG0001'
     c                   when      errorcode = AllUse_Err
     c                   eval      cur_msgid = 'STG0002'
     c                   when      errorcode = HdlUse_Err
     c                   eval      cur_msgid = 'STG0003'
     c                   when      errorcode = FilOpn_Err
     c                   eval      cur_msgid = 'STG0004'
     c                   when      errorcode = FilCls_Err
     c                   eval      cur_msgid = 'STG0005'
     c                   when      errorcode = FilWrt_Err
     c                   eval      cur_msgid = 'STG0006'
     c                   when      errorcode = FilRed_Err
     c                   eval      cur_msgid = 'STG0007'
     c                   when      errorcode = HdlInv_Err
     c                   eval      cur_msgid = 'STG0008'
     c                   when      errorcode = OpnDir_Err
     c                   eval      cur_msgid = 'STG0009'
     c                   when      errorcode = CrtPth_Err
     c                   eval      cur_msgid = 'STG0010'
     c                   when      errorcode = VolFnd_Err
     c                   eval      cur_msgid = 'STG0011'
     c                   when      errorcode = DevFnd_Err
     c                   eval      cur_msgid = 'STG0012'
     c                   when      errorcode = Gen_Err
     c                   eval      cur_msgid = 'STG0013'
     c                   when      errorcode = OptStr_err
     c                   eval      cur_msgid = 'STG0014'
     c                   when      errorcode = MSVTim_err
     c                   eval      cur_msgid = 'STG0015'
     c                   when      errorcode = Unk_Err
     c                   eval      cur_msgid = 'STG0016'
     c                   when      errorcode = DevAct_Err
     c                   eval      cur_msgid = 'STG0017'
     c                   when      errorcode = VolAct_Err
     c                   eval      cur_msgid = 'STG0018'
     c                   when      errorcode = NoWrt_Err
     c                   eval      cur_msgid = 'STG0019'
     c                   when      errorcode = VolFul_Err
     c                   eval      cur_msgid = 'STG0020'
     c                   when      errorcode = StgMir_Err
     c                   eval      cur_msgid = 'STG0021'
     c                   when      errorcode = VolUse_Mir
     c                   eval      cur_msgid = 'STG0022'
     c                   when      errorcode = RedOnl_Err
     c                   eval      cur_msgid = 'STG0011'
     c                   when      errorcode = VolNot_Mir
     c                   eval      cur_msgid = 'STG0023'
     c                   when      errorcode = NoSpc_Err
     c                   eval      cur_msgid = 'STG0024'
     c                   other
     c                   endsl
     P fillerror       E
      **************************************************************************
     P openmirror      B
      *  Open mirroring
     D openmirror      PI

     c                   if        optmiropn<>'1'
     c                   open      mstgmir
     c                   eval      optmiropn='1'
     c                   endif

     c                   callp     getdate(wcoutv)

     c                   clear                   stgmirf
     c                   eval      smopd = wcdate
     c                   eval      smopt = wctime
     c                   eval      smovol= hdlvolume
     c                   eval      smmvol= hdlmirvol
     c                   eval      smsts = 'O'
     c                   eval      smjob = curjob
     c                   eval      smpth = hdlpath
     c                   eval      smfil = hdlfilnam
     c                   write     stgmirf

      *  Get path for mirror cache dir
     c                   call      'SPYPATH'
     c                   parm      '*STGMIRROR'  pathid           10
     c                   parm                    rtnpath         256
      *  Open temp file in IFS
     c                   eval      mirpath=%trim(rtnpath)+ '/' +
     c                             %trim(hdlfilnam) + x'00'
     c                   eval      oflag = O_WRONLY + O_CREAT + O_TRUNC
/3172C                                   + O_EXCL
/3172C                   eval      mode  = S_IRWXU  + S_IRWXG + S_IRWXO
     c                   eval      hdlmirdes=open(mirpath:oflag:mode)
     c                   if        hdlmirdes<0
     c                   eval      errorcode=StgMir_Err
     c                   endif
     P openmirror      E
      **************************************************************************
     P closmirror      B
      *  close mirroring
     D closmirror      PI

     c                   if        optmiropn<>'1'
     c                   open      mstgmir
     c                   eval      optmiropn='1'
     c                   endif

     c                   callp     getdate(wcoutv)

     c                   eval      smfil = hdlfilnam
     c     smfil         chain     stgmirf                            5050
     c                   if        not *in50
     c                   if        errorcode=rtn_ok
     c                   eval      smcld = wcdate
     c                   eval      smclt = wctime
     c                   eval      smsts = hdlmirror
     c                   clear                   smjob
     c                   endif
     c                   eval      smsiz = hdlbytes
     c                   update    stgmirf
      *  Immed mirroring, check if background jobs are active, if not send messa
     c                   if        smsts = 'I'
     c                   call      'SPYMIRSTS'                          50
     c                   parm      'C'           mirsts            1
     c                   parm                    mirjob           26
     c                   if        mirsts<>'1'
     c                   call      'SPYERR'                             50
     C                   parm      'STG0258'     MSGID             7
     C                   parm      smmvol        MSGDTA          100
     c                   endif
     c                   endif

     c                   endif

      *  Close temp mirror file
     c                   eval      rtncde=close(hdlmirdes)
      *         Error occured
     c                   if        rtncde<0
     c                   eval      errorcode=StgMir_Err
     c                   else
     c                   if        errorcode=rtn_ok
      *         Close ok, send DTAQ message if mirror type = *IMMED
     c                   if        hdlmirror='I'
     c                   eval      stgdtaqcmd='*MIRROR'
     c                   eval      stgdtaqprm=hdlfilnam
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SPYSTGMIR'   QNAME            10
     C                   PARM                    PGMLIB
     C                   PARM      200           QDTASZ            5 0
     C                   PARM                    STGDTAQ
     C                   PARM      12            QKEYSZ            3 0
     C                   PARM      smovol        QKEYR            12
     c                   endif
     c                   endif
     c                   endif
     P closmirror      E
      **************************************************************************
      *   Update mirror status file if held file has been moved to new volume
     P updmirror       B
      *  update mirroring
     D updmirror       PI            10i 0
     D  newvol                       12
     D  filnam                       20

     c                   eval      errorcode=rtn_ok

      *        Open files of not done yet
     c                   if        didopen<>'1'
     c                   callp     openfiles
     c                   endif

     c                   if        optmiropn<>'1'
     c                   open      mstgmir
     c                   eval      optmiropn='1'
     c                   endif

     c                   callp     getdate(wcoutv)

      *       Update volume usage
     c     volume        chain     stgvolf                            5050
     c                   if        not *in50
     c                   eval      svdlw = wcdate
     c                   eval      svtlw = wctime
     c                   update    stgvolf
     c                   endif
      *   Update status record to point to correct mirror volume
     c                   eval      smfil = filnam
     c     smfil         chain     stgmirf                            5050
     c                   if        not *in50
     c                   if        svbtyp='N'
     c                   delete    stgmirf
     c                   else
     c                   eval      smovol= volume
     c                   eval      smmvol= svbvol
     c                   eval      smcld = wcdate
     c                   eval      smclt = wctime
     c                   eval      smsts = svbtyp
     c                   clear                   smjob
     c                   update    stgmirf
      *  Immed mirroring, check if background jobs are active, if not send messa
     c                   if        smsts = 'I'
     c                   call      'SPYMIRSTS'                          50
     c                   parm      'C'           mirsts            1
     c                   parm                    mirjob           26
     c                   if        mirsts<>'1'
     c                   call      'SPYERR'                             50
     C                   parm      'STG0258'     MSGID             7
     C                   parm      smmvol        MSGDTA          100
     c                   endif
     c                   endif
     c                   endif

     c                   endif

      *         Close ok, send DTAQ message if mirror type = *IMMED
     c                   if        smsts='I'
     c                   eval      stgdtaqcmd='*MIRROR'
     c                   eval      stgdtaqprm=smfil
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SPYSTGMIR'   QNAME            10
     C                   PARM                    PGMLIB
     C                   PARM      200           QDTASZ            5 0
     C                   PARM                    STGDTAQ
     C                   PARM      12            QKEYSZ            3 0
     C                   PARM      smovol        QKEYR            12
     c                   endif
     c
     c                   return    errorcode
     P updmirror       E
      **************************************************************************
      *   Get the filename from a path
     P getfilnam       B
     D getfilnam       PI            20
     D  path                        250
     c                   clear                   filnam           20
      *  Get the filename
     c     ' '           checkr    path          pthlen            5 0
     c                   z-add     pthlen        pthpos            5 0
     c                   dou       %subst(path:pthpos:1)='/' or
     c                             pthpos=1
     c                   sub       1             pthpos
     c                   enddo
     c                   if        %subst(path:pthpos:1)='/'
     c                   add       1             pthpos
     c                   endif
     c                   eval      filnam   =
     c                                   %subst(path:pthpos:pthlen-pthpos+1)
     c
     c                   return    filnam
     P getfilnam       E
      **************************************************************************
      *  ====================================
      *  spystgrtva  rtv backup volume assignment
      *  ====================================
      **************************************************************************
     P spystgrtva      B                   export
     D spystgrtva      PI            10i 0
     D  volume                       12    value
     D  rtnvol                       12

/8696c                   callp     clrerrors

     c                   eval      errorcode=rtn_ok
     c                   clear                   rtnvol

     c                   if        didopen<>'1'
     c                   callp     openfiles
     c                   endif
      *  Check what volume this backup volume is assigned to
     c     volume        chain     stgvolf2                           5050
     c                   if        not *in50
     c                   eval      rtnvol=svvol
     c                   endif
      *  Check if used as backup volume
     c     volume        chain(n)  stgvolf                            5050
     c                   if        svtyp<>'Y' or *in50
     c                   eval      errorcode=VolNot_Mir
     c                   callp     fillerror(volume:svdev)
     c                   endif

/8696c                   callp     spystgtrc('RTVATTRIB')

     C                   return    ErrorCode
     P spystgrtva      E
      **************************************************************************
      * write trace messages to file mopttrc
      **************************************************************************
/8696p spystgtrc       b

     d                 pi
     d operation                           const like(otoper)
     d volume                        12    const options(*nopass)

     d MAXERR          c                   9999

     d errnoRtn        s             10i 0
     d errstrRtn       s               *
     d msgf            s             20    inz('QCPFMSG   *LIBL')

      * If not a LAN conversation, retrieve errno condition from SPYSTGIFS.
      * use import/export system api error structure for system api calls.
     c                   if        (opttrc = 'Y' or opttrc = 'E') and
     c                             devtyp <> ' ' and devtyp <> typ_ibmlan
     c                   callp     getifserr
     c                   endif

      * If tracing is on or on for (E)rrors only.
     c                   if        opttrc = 'Y' or opttrc = 'E' and rtcd > 0

     c                   if        not %open(mopttrc)
     c                   open      mopttrc
     c                   endif

     c                   clear                   opttrcrc
     c                   callp     getdate(wcoutv)
     c                   eval      otdate = wcdate
     c                   eval      ottime = wctime
     c                   eval      otjnam = job
     c                   eval      otjusr = user
     c                   eval      otjnbr = jobnum
     c                   eval      otvoln = hdlvolume
     c                   if        %parms = 2
     c                   eval      otvoln = volume
     c                   endif
     c                   eval      otfiln = hdlfilnam
     c                   eval      otdtyp = devtyp
     c                   eval      otoper = operation

      * System api error or available command processed by qcapcmd(see runsyscmd
     c                   if        rtcd > 0 or msgdta <> ' '
     c                   if        rtcd > 0
     c                   call      'MAG1033'
     c                   parm      'U'           action            1
     c                   parm                    msgf
     c                   parm                    retcd
     c                   parm                    otapim
     c                   else
     c                   eval      otapim = msgdta
     c                   endif
     c                   eval      otapie = msgid
     c                   endif

     c                   write     opttrcrc

     c                   if        operation = 'SHUTDOWN' and %open(mopttrc)
     c                   close     mopttrc
     c                   endif

     c                   endif

     p                 e
      **************************************************************************
/8696P runSysCmd       b                   export

     d                 PI
     d cmd                         1024    options(*varsize)
     d apierr                       256    options(*varsize)

      * Set option contol block values to act like QCMDEXC.
     d OptCtlBlk       DS
     d  ocCmdProc                    10i 0 inz(0)
     d  ocDBCS                        1a   inz('0')
     d  ocPmtAct                      1a   inz('0')
     d  ocCmdSyn                      1a   inz('0')
     d  ocMRK                         4a
     d  ocReserve                     9a   inz(*allx'00')

     d OptCtlSize      S             10i 0 inz(%size(OptCtlBlk))
     d OptCtlFmt       S              8a   inz('CPOP0100')

     d ChgCmd          S              1a
     d ChgCmdLen       S             10i 0 inz(0)
     d ChgCmdAvl       S             10i 0
     d cmdlen          s             10i 0

     c                   eval       cmdlen = %len(%trimr(cmd))
     c                   call      'QCAPCMD'
     c                   parm                    Cmd
     c                   parm                    CmdLen
     c                   parm                    OptCtlBlk
     c                   parm                    OptCtlSize
     c                   parm                    OptCtlFmt
     c                   parm                    ChgCmd
     c                   parm                    ChgCmdLen
     c                   parm                    ChgCmdAvl
     c                   parm                    apierr

      * If no error always display as much of the command executed as possible.
     c                   if        rtcd = 0
     c                   eval      msgdta = cmd
     c                   endif

     c                   return

     p                 e
      **************************************************************************
/8696p clrerrors       b
     d                 pi
     c                   callp     clrifserr
     c                   reset                   retcd
     c                   return
     p                 e

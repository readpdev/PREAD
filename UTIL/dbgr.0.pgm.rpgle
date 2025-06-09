     h dftactgrp(*no) bnddir('QC2LE')

      ************
      * MAKE SURE TO VERSION APPLICATION IF MAJOR CHANGES OR FIXES.
      ************

      * 04-06-07 PLR Added stack dump. v0.3
      * 12-21-06 PLR Changed toggling between *ACTIVE and *JOBQ to a function ke
      *              Fixed subfile error on empty list. Changed version to v0.2
      * 11-01-04 PLR Added versioning.

     fdbgfm     cf   e             workstn sfile(sfl01:rrn1) indds(indds)
     f                                     sfile(sfl02:rrn2)
      ************
/VERSd VERSION         s             10    inz('v0.3')
      ************

      /copy qsysinc/qrpglesrc,qusec

     d run             pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)
     d dumpStack       pr

     d                sds
     d pgmq              *proc
     d jobnam                244    253
     d pgmusr                254    263
     d jobnbr                264    269
     d curjob                244    269

     d indds           ds
     d  exit                  03     03n
     d  refresh               05     05n
     d  f7_enddbg             07     07n
     d  hldrlsjobq            08     08n
     d  toggleSts             11     11n
     d  cancel                12     12n
     d  cmdlin                21     21n
     d  sfldsp                25     25n
     d  sfldlt                26     26n
     d  protectOption         31     31n
     d  jobqheld              32     32n
     d  overlay               70     70n

     d receiver        ds
     d  r_jobnam                     10
     d  r_usrnam                     10
     d  r_jobnum                      6
     d   r_curjob                    26    overlay(receiver)
     d  r_intjob                     16
     d  r_status                     10
     d  r_jobtyp                      1
     d  r_subtyp                      1
     d  r_resrvd                      2
     d  r_jobinf                      1
     d  r_rsrvd2                      3

     d listinfo        ds
     d  l_totrec                     10i 0
     d  l_rcdrtn                     10i 0
     d  l_handle                      4
     d  l_rcdlen                     10i 0
     d  l_infcmp                      1
     d  l_dattim                     13
     d  l_lststs                      1
     d  l_resrvd                      1
     d  l_leninf                     10i 0
     d  l_fstrec                     10i 0
     d  l_rsvrd2                     40

     d jobfilter       ds
     d  j_jobnam                     10    inz('*ALL')
     d  j_jobusr                     10
     d  j_jobnum                      6    inz('*ALL')
     d  j_jobtyp                      1    inz('*')
     d  j_resrvd                      1    inz
      * primary job status offset and number
     d  j_ospjsa                     10i 0 inz(0)
     d  j_numpjs                     10i 0 inz(0)
      * actjob status array offset and number
     d  j_osajsa                     10i 0 inz(0)
     d  j_numajs                     10i 0 inz(0)
      * jobs on jobq status offset and number
     d  j_osjqsa                     10i 0 inz(0)
     d  j_numjsa                     10i 0 inz(0)
      * jobq names array offset and number
     d  j_osjqna                     10i 0 inz(0)
     d  j_numjqn                     10i 0 inz(0)
     d  j_prjsts                     10    dim(1)
     d jobfltlen       s             10i 0 inz(%size(jobfilter))

     d qusrjobiDS      ds           111
     d  funcType                      1    overlay(qusrjobiDS:97)
     d  function                     10    overlay(qusrjobiDS:98)
     d  actjobsts                     4    overlay(qusrjobiDS:108)
     d qusrjoblen      s             10i 0 inz(%size(qusrjobiDS))

     d apierr          ds
     d  bytprv                       10i 0 inz(%size(apierr))
     d  bytavl                       10i 0 inz
     d  msgid                         7
     d  a_rsvrd                       1    inz
     d  msgdta                       80

     d dbgdtaara       ds            50    dtaara
     d  pgmnam
     d  pgmlib
     d  jobq
     d  jobqlib
     d  status

     d lenrcvr         s             10i 0 inz(%size(receiver))
     d rcvvarlen       s             10i 0 inz(0)
     d numrcdrtn       s             10i 0 inz(9999)
     d sort            s             10i 0 inz(0)
     d numfldrtn       s             10i 0 inz(0)
     d keyfldrtn       s             10i 0 dim(1) inz
     d startrrn        s             10i 0
     d lastusr         s             10
     d laststs         s             10
     d dbgjobnbr       s              6
     d dbgrrn          s             10i 0
     d totrrn          s             10i 0
     d stackcnt        s             10i 0

     c     *entry        plist
     c                   parm                    user

     c

     c                   callp     run('crtdtaara qtemp/dbgdtaara *char 50')
     c                   exsr      rmvmsgs

     c     *lock         in        dbgdtaara

     c                   if        pgmlib = ' '
     c                   eval      pgmlib = '*LIBL'
     c                   endif

     c                   if        jobqlib = ' '
     c                   eval       jobqlib = '*LIBL'
     c                   endif

     c                   exsr      loadsfl01

     c                   dow       not exit
     c                   if        dbgrrn > 0 and dbgrrn <= totrrn
     c                   eval      rrn1 = dbgrrn
     c                   else
     c                   eval      overlay = '0'
     c                   endif
     c                   write     record01
     c                   write     msgctl
     c                   exfmt     ctl01
     c                   exsr      rmvmsgs

     c                   select
     c                   when      exit
     c                   exsr      enddbg
     c                   if        jobqheld
     c                   exsr      dojobq
     c                   endif
     c                   when      refresh or
     c                             ((user <> lastusr) and lastusr <> ' ')
     c                   exsr      refreshSR
     c                   when      f7_enddbg
     c                   exsr      enddbg
     c                   exsr      refreshSR
     c                   when      hldrlsjobq
     c                   exsr      dojobq
     c                   when      toggleSts
     c                   exsr      toggleStsSR
     c                   when      cmdlin
     c                   call      'QUSCMDLN'
     c                   other
     c                   exsr      readcsr
     c                   endsl
     c                   enddo

     c                   out       dbgdtaara

     c                   eval      *inlr = '1'

      **************************************************************************
     c     toggleStsSR   begsr

     c                   select
     c                   when      status = '*JOBQ'
     c                   eval      status = '*ACTIVE'
     c                   when      status = '*ACTIVE'
     c                   eval      status = '*JOBQ'
     c                   endsl
     c                   exsr      refreshSR

     c                   endsr

      **************************************************************************
     c     refreshSR     begsr
     c                   exsr      dltsfl
     c                   exsr      loadsfl01
     c                   endsr

      **************************************************************************
     c     loadsfl01     begsr
     c                   if        user = '*CURRENT' or user = ' '
     c                   eval      user = pgmusr
     c                   endif
     c                   if        status = ' '
     c                   eval      status = '*ACTIVE'
     c                   endif
     c                   eval      lastusr = user
     c                   eval      j_jobusr = user
     c                   eval      j_prjsts(1) = status
     c                   eval      j_numpjs = 0
     c                   if        j_prjsts(1) <> '*ALL'
     c                   eval      j_ospjsa=%size(jobfilter)-%size(j_prjsts)
     c                   eval      j_numpjs = 1
     c                   endif

     c                   call      'QGY/QGYOLJOB'
     c                   parm                    receiver
     c                   parm                    lenrcvr
     c                   parm      'OLJB0200'    format            8
     c                   parm      ' '           rcvvardef         1
     c                   parm      1             rcvvarlen
     c                   parm                    listinfo
     c                   parm                    numrcdrtn
     c                   parm                    sort
     c                   parm                    jobfilter
     c                   parm                    jobfltlen
     c                   parm                    numfldrtn
     c                   parm                    keyfldrtn
     c                   parm                    apierr

     c                   eval      rrn1 = 1
     c                   eval      totrrn = 0
     c                   do        l_totrec
     c                   call      'QGY/QGYGTLE'
     c                   parm                    receiver
     c                   parm                    lenrcvr
     c                   parm                    l_handle
     c                   parm                    listinfo
     c                   parm                    numrcdrtn
     c                   parm      rrn1          startrrn
     c                   parm                    apierr
     c                   exsr      getJobInf
     c                   eval      rrnhid = rrn1
     c                   eval      protectOption = '0'
     c                   if        dbgjobnbr <> ' ' and r_jobnum <> dbgjobnbr
     c                   eval      protectOption = '1'
     c                   endif
     c                   write     sfl01
     c                   eval      rrn1 = rrn1 + 1
     c                   eval      totrrn = totrrn + 1
     c                   enddo
     c                   eval      rrn1 = rrn1 - 1
     c                   if        rrn1 > 0
     c                   eval      sfldsp = '1'
     c                   eval      overlay = '1'
     c                   eval      rrn1 = 1
     c                   endif
     c                   call      'QGY/QGYCLST'
     c                   parm                    l_handle
     c                   parm                    apierr
     c                   endsr
      **************************************************************************
     c     dltsfl        begsr
     c                   eval      option = ' '
     c                   eval      rrn1 = 0
     c                   eval      totrrn = 0
     c                   eval      sfldlt = '1'
     c                   eval      overlay = '1'
     c                   write     ctl01
     c                   eval      sfldlt = '0'
     c                   eval      sfldsp = '0'
     c                   endsr
      **************************************************************************
     c     readcsr       begsr
     c                   readc(e)  sfl01
     c                   dow       not %eof and not %error
     c                   select
     c                   when      option = '1'
     c                   exsr      strdbg
     c                   exsr      updsfl01
     c                   when      option = '2'
     c                   callp     run('?chgjob ' + r_jobnum + '/*N/' +
     c                             %trimr(r_jobnam))
     c                   when      option = '3'
     c                   callp     run('hldjob ' + r_jobnum + '/*N/' +
     c                             %trimr(r_jobnam))
     c                   when      option = '4'
     c                   callp     run('endjob ' + r_jobnum + '/*N/' +
     c                             %trimr(r_jobnam) + ' option(*immed)')
     c                   when      option = '5'
     c                   callp     run('wrkjob ' + r_jobnum + '/*N/' +
     c                             %trimr(r_jobnam))
     c                   when      option = '6'
     c                   callp     run('rlsjob ' + r_jobnum + '/*N/' +
     c                             %trimr(r_jobnam))
     c                   when      option = '7'
     c                   callp     dumpStack
     c                   endsl
     c     rrnhid        chain     sfl01
     c                   select
     c                   when      option = '3' or option = '6'
     c                   exsr      getJobInf
     c                   when      option = '4'
     c                   eval      r_status = 'ENDING'
     c                   endsl
     c                   eval      option = ' '
     c                   update    sfl01
     c                   readc     sfl01
     c                   enddo
     c                   endsr
      **************************************************************************
     c     getJobInf     begsr
     c                   call      'QUSRJOBI'
     c                   parm                    qusrjobiDS
     c                   parm                    qusrjoblen
     c                   parm      'JOBI0200'    qusrjobfmt        8
     c                   parm      '*INT'        qualjobDS        26
     c                   parm                    r_intjob
     c                   parm                    apierr
     c                   endsr
      **************************************************************************
     c     strdbg        begsr
     c                   eval      cancel = '0'
     c                   if        dbgrrn = 0
     c                   exfmt     debugwdw
     c                   endif
     c                   if        not cancel
     c                   eval      dbgjobnbr = r_jobnum
     c                   eval      dbgrrn = rrnhid
     c                   if        run('dspmodsrc') <> 0
     c                   if        curjob <> r_curjob
     c                   callp     run('strsrvjob ' + %trimr(r_jobnum) + '/*N/'+
     c                             %trimr(r_jobnam))
     c                   endif
     c                   if        run('strdbg ' + %trimr(pgmlib) + '/' +
     c                             %trimr(pgmnam) +
     c                             ' opmsrc(*yes) updprod(*yes)') <> 0
     c                   callp     run('strdbg srvpgm(' + %trimr(pgmlib) + '/' +
     c                             %trimr(pgmnam) + ')')
     c                   endif
     c                   endif
     c                   endif
     c                   endsr
      **************************************************************************
     c     updsfl01      begsr
     c                   do        totrrn        rrn1
     c     rrn1          chain     sfl01
     c                   eval      option = ' '
     c                   eval      protectOption = '0'
     c                   if        dbgrrn > 0 and rrn1 <> dbgrrn
     c                   eval      protectOption = '1'
     c                   endif
     c                   update    sfl01
     c                   enddo
     c                   eval      rrn1 = 1
     c                   if        dbgrrn > 0
     c                   eval      rrn1 = dbgrrn
     c                   endif
     c                   endsr
      **************************************************************************
     c     dojobq        begsr
     c                   eval      cancel = '0'
     c                   if        not jobqheld
     c                   exfmt     jobqwdw
     c                   endif
     c                   if        not cancel
     c                   if        jobqheld
     c                   callp(e)  run('rlsjobq ' + %trimr(jobqlib) + '/' +
     c                             %trimr(jobq))
     c                   eval      jobqheld = '0'
     c                   else
     c                   callp(e)  run('hldjobq ' + %trimr(jobqlib) + '/' +
     c                             %trimr(jobq))
     c                   if        jobqlib = '*LIBL'
     c                   eval      heldq = jobq
     c                   else
     c                   eval      heldq = %trimr(jobqlib) + '/' + jobq
     c                   endif
     c                   eval      heldq = %trimr(heldq) + ' Held'
     c                   eval      jobqheld = '1'
     c                   endif
     c                   endif
     c                   endsr
      **************************************************************************
     c     enddbg        begsr

     c                   eval      dbgjobnbr = ' '
     c                   eval      dbgrrn = 0
     c                   callp(e)  run('enddbg')
     c                   exsr      rmvmsgs
     c                   callp(e)  run('endsrvjob')
     c                   exsr      rmvmsgs
     c                   callp(e)  run('rclactgrp *eligible')
     c                   exsr      rmvmsgs
     c                   callp(e)  run('rclrsc *caller')
     c                   exsr      rmvmsgs

     c                   endsr

      **************************************************************************
     c     rmvmsgs       begsr

      * remove program messages.
     c                   call      'QMHRMVPM'
     c                   parm      '*'           stack            10
     c                   parm      0             stackcnt
     c                   parm      ' '           msgkey
     c                   parm      '*ALL'        msgtype          10
     c                   parm                    apierr

     c                   endsr

      **************************************************************************
     p dumpStack       b

      /copy qsysinc/qrpglesrc,qwcattr

     d rtvCallStk      pr                  extpgm('QWVRCSTK')
     d  recvr                              like(callStack)
     d  rcvrLen                      10i 0
     d  format                        8    const
     d  jobID                              like(qwcf0100)
     d  jobIdFmt                      8    const
     d  error                              like(qusec)

     d callStack       ds                  qualified
     d  bytesRtn                     10i 0
     d  bytesAvl                     10i 0
     d  nbrEntries                   10i 0
     d  offsetToStack                10i 0
     d  nbrEntRtn                    10i 0
     d  rtnThreadID                   8
     d  infoSts                       1
     d  reserved                      1
     d  entryData                  8192

     d rcvrLen         s             10i 0 inz(%size(callStack))

     d entry           ds                  qualified based(p)
     d  length                       10i 0
     d  offSetStmtIDs                10i 0
     d  nbrStmtIDs                   10i 0
     d  offSetProcNam                10i 0
     d  lenProcNam                   10i 0
     d  rqstLevel                    10i 0
     d  pgmName                      10
     d  pgmLib                       10
     d  MIinstruction                10i 0
     d  moduleName                   10
     d  moduleLib                    10
     d  ctlBoundry                    1
     d  reserved                      3
     d  actGrpNbr                    10u 0
     d  actGrpNam                    10
     d  reserved2                     2
     d  pgmASPnam                    10
     d  pgmLibASPnam                 10
     d  pgmASPnbr                    10i 0
     d  pgmLibASPnbr                 10i 0
     d  actGrpNbrL                   20u 0
     d  stmtIDs                      10
     d  procName                      1

     d i               s             10i 0

      /free
       // Setup job information data structure.
       clear qwcf0100;
       qwcjn02 = r_jobnam;
       qwcun = r_usrnam;
       qwcjnbr00 = r_jobnum;
       qwcerved06 = *allx'00';
       qwcti00 = 2;
       qwcti01 = *allx'00';
       rtvCallStk(callStack:rcvrLen:'CSTK0100':QWCF0100:'JIDF0100':
         qusec);
       if qusbavl = 0;
         sfldlt = '1';
         sfldsp = '0';
         write ctl02;
         sfldlt = '0';
         rrn2 = 0;
         p = %addr(callStack) + callStack.offsetToStack;
         write record02;
         for i = 1 to callStack.nbrEntries-1;
           stk_pgm = entry.pgmName;
           stk_lib = entry.pgmLib;
           stk_mod = entry.moduleName;
           stk_proc = ' ';
           if entry.lenProcNam > 0;
             stk_proc = %str(p + entry.offSetProcNam:entry.lenProcNam);
           endif;
           rrn2 = rrn2 + 1;
           write sfl02;
           p = p + entry.length;
         endfor;
         if rrn2 > 0;
           rrn2 = 1;
           sfldsp = '1';
           exfmt ctl02;
         endif;
       endif;
       return;
      /end-free

     p                 e

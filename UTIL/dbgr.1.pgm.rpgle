     h dftactgrp(*no) bnddir('QC2LE')

      //***********
      // MAKE SURE TO VERSION APPLICATION IF MAJOR CHANGES OR FIXES.
      //***********
      // 06-07-07 PLR Converted to free. v0.3
      // 04-06-07 PLR Added stack dump. v0.3
      // 12-21-06 PLR Changed toggling between *ACTIVE and *JOBQ to a function k
      //              Fixed subfile error on empty list. Changed version to v0.2
      // 11-01-04 PLR Added versioning.

     fdbgfm     cf   e             workstn sfile(sfl01:rrn1) indds(indds)
     f                                     sfile(sfl02:rrn2)
      //***********
/VERSd VERSION         s             10    inz('v0.3')
      //***********

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
      // primary job status offset and number
     d  j_ospjsa                     10i 0 inz(0)
     d  j_numpjs                     10i 0 inz(0)
      // actjob status array offset and number
     d  j_osajsa                     10i 0 inz(0)
     d  j_numajs                     10i 0 inz(0)
      // jobs on jobq status offset and number
     d  j_osjqsa                     10i 0 inz(0)
     d  j_numjsa                     10i 0 inz(0)
      // jobq names array offset and number
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

      /FREE
       run('crtdtaara qtemp/dbgdtaara *char 50');
       exsr rmvmsgs;

       in *lock dbgdtaara;

       if pgmlib = ' ';
         pgmlib = '*LIBL';
       endif;

       if jobqlib = ' ';
         eval jobqlib = '*LIBL';
       endif;

       exsr loadsfl01;

       dow not exit;
         if dbgrrn > 0 and dbgrrn <= totrrn;
           rrn1 = dbgrrn;
         else;
           overlay = '0';
         endif;
         write record01;
         write msgctl;
         exfmt ctl01;
         exsr rmvmsgs;

         select;
         when exit;
           exsr enddbg;
           if jobqheld;
             exsr dojobq;
           endif;
         when refresh or
               ((user <> lastusr) and lastusr <> ' ');
           exsr refreshSR;
         when f7_enddbg;
           exsr enddbg;
           exsr refreshSR;
         when hldrlsjobq;
           exsr dojobq;
         when toggleSts;
           exsr toggleStsSR;
         when cmdlin;
      /END-FREE
     c                   call      'QUSCMDLN'
      /FREE
         other;
           exsr readcsr;
         endsl;
       enddo;

       out dbgdtaara;

       *inlr = '1';

       //***********************************************************************
       begsr toggleStsSR;

         select;
         when status = '*JOBQ';
           status = '*ACTIVE';
         when status = '*ACTIVE';
           status = '*JOBQ';
         endsl;
         exsr refreshSR;

       endsr;

       //***********************************************************************
       begsr refreshSR;
         exsr dltsfl;
         exsr loadsfl01;
       endsr;

       //***********************************************************************
       begsr loadsfl01;
         if user = '*CURRENT' or user = ' ';
           user = pgmusr;
         endif;
         if status = ' ';
           status = '*ACTIVE';
         endif;
         lastusr = user;
         j_jobusr = user;
         j_prjsts(1) = status;
         j_numpjs = 0;
         if j_prjsts(1) <> '*ALL';
           j_ospjsa=%size(jobfilter)-%size(j_prjsts);
           j_numpjs = 1;
         endif;

      /END-FREE
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

      /FREE
         rrn1 = 1;
         totrrn = 0;
      /END-FREE
     c                   do        l_totrec
     c                   call      'QGY/QGYGTLE'
     c                   parm                    receiver
     c                   parm                    lenrcvr
     c                   parm                    l_handle
     c                   parm                    listinfo
     c                   parm                    numrcdrtn
     c                   parm      rrn1          startrrn
     c                   parm                    apierr
      /FREE
           exsr getJobInf;
           rrnhid = rrn1;
           protectOption = '0';
           if dbgjobnbr <> ' ' and r_jobnum <> dbgjobnbr;
             protectOption = '1';
           endif;
           write sfl01;
           rrn1 = rrn1 + 1;
           totrrn = totrrn + 1;
         enddo;
         rrn1 = rrn1 - 1;
         if rrn1 > 0;
           sfldsp = '1';
           overlay = '1';
           rrn1 = 1;
         endif;
      /END-FREE
     c                   call      'QGY/QGYCLST'
     c                   parm                    l_handle
     c                   parm                    apierr
      /FREE
       endsr;
       //***********************************************************************
       begsr dltsfl;
         option = ' ';
         rrn1 = 0;
         totrrn = 0;
         sfldlt = '1';
         overlay = '1';
         write ctl01;
         sfldlt = '0';
         sfldsp = '0';
       endsr;
       //***********************************************************************
       begsr readcsr;
         readc(e) sfl01;
         dow not %eof and not %error;
           select;
           when option = '1';
             exsr strdbg;
             exsr updsfl01;
           when option = '2';
             run('?chgjob ' + r_jobnum + '/*N/' +
                 %trimr(r_jobnam));
           when option = '3';
             run('hldjob ' + r_jobnum + '/*N/' +
                 %trimr(r_jobnam));
           when option = '4';
             run('endjob ' + r_jobnum + '/*N/' +
                 %trimr(r_jobnam) + ' option(*immed)');
           when option = '5';
             run('wrkjob ' + r_jobnum + '/*N/' +
                 %trimr(r_jobnam));
           when option = '6';
             run('rlsjob ' + r_jobnum + '/*N/' +
                 %trimr(r_jobnam));
           when option = '7';
             dumpStack();
           endsl;
           chain rrnhid sfl01;
           select;
           when option = '3' or option = '6';
             exsr getJobInf;
           when option = '4';
             r_status = 'ENDING';
           endsl;
           option = ' ';
           update sfl01;
           readc sfl01;
         enddo;
       endsr;
       //***********************************************************************
       begsr getJobInf;
      /END-FREE
     c                   call      'QUSRJOBI'
     c                   parm                    qusrjobiDS
     c                   parm                    qusrjoblen
     c                   parm      'JOBI0200'    qusrjobfmt        8
     c                   parm      '*INT'        qualjobDS        26
     c                   parm                    r_intjob
     c                   parm                    apierr
      /FREE
       endsr;
       //***********************************************************************
       begsr strdbg;
         cancel = '0';
         if dbgrrn = 0;
           exfmt debugwdw;
         endif;
         if not cancel;
           dbgjobnbr = r_jobnum;
           dbgrrn = rrnhid;
           if run('dspmodsrc') <> 0;
             if curjob <> r_curjob;
               run('strsrvjob ' + %trimr(r_jobnum) + '/*N/'+
                   %trimr(r_jobnam));
             endif;
             if run('strdbg ' + %trimr(pgmlib) + '/' +
                   %trimr(pgmnam) +
                   ' opmsrc(*yes) updprod(*yes)') <> 0;
               run('strdbg srvpgm(' + %trimr(pgmlib) + '/' +
                   %trimr(pgmnam) + ')');
             endif;
           endif;
         endif;
       endsr;
       //***********************************************************************
       begsr updsfl01;
      /END-FREE
     c                   do        totrrn        rrn1
      /FREE
           chain rrn1 sfl01;
           option = ' ';
           protectOption = '0';
           if dbgrrn > 0 and rrn1 <> dbgrrn;
             protectOption = '1';
           endif;
           update sfl01;
         enddo;
         rrn1 = 1;
         if dbgrrn > 0;
           rrn1 = dbgrrn;
         endif;
       endsr;
       //***********************************************************************
       begsr dojobq;
         cancel = '0';
         if not jobqheld;
           exfmt jobqwdw;
         endif;
         if not cancel;
           if jobqheld;
             callp(e) run('rlsjobq ' + %trimr(jobqlib) + '/' +
                 %trimr(jobq));
             jobqheld = '0';
           else;
             callp(e) run('hldjobq ' + %trimr(jobqlib) + '/' +
                 %trimr(jobq));
             if jobqlib = '*LIBL';
               heldq = jobq;
             else;
               heldq = %trimr(jobqlib) + '/' + jobq;
             endif;
             heldq = %trimr(heldq) + ' Held';
             jobqheld = '1';
           endif;
         endif;
       endsr;
       //***********************************************************************
       begsr enddbg;

         dbgjobnbr = ' ';
         dbgrrn = 0;
         callp(e) run('enddbg');
         exsr rmvmsgs;
         callp(e) run('endsrvjob');
         exsr rmvmsgs;
         callp(e) run('rclactgrp *eligible');
         exsr rmvmsgs;
         callp(e) run('rclrsc *caller');
         exsr rmvmsgs;

       endsr;

       //***********************************************************************
       begsr rmvmsgs;

         // remove program messages.
      /END-FREE
     c                   call      'QMHRMVPM'
     c                   parm      '*'           stack            10
     c                   parm      0             stackcnt
     c                   parm      ' '           msgkey
     c                   parm      '*ALL'        msgtype          10
     c                   parm                    apierr

      /FREE
       endsr;

       //***********************************************************************
      /END-FREE
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

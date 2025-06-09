      *%METADATA                                                       *
      * %TEXT Display Object References                                *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE':'SPYBNDDIR')

     fQADSPPGM  uf a e             disk    usropn
     fdspobjrefdcf   e             workstn indds(indds) sfile(sfl01:rrn1)

     d indds           ds            99
     d  exit                  03     03n
     d  cancel                12     12n
     d  cmdLine               21     21n
     d  sfldsp                25     25n
     d  sfldlt                26     26n
     d  buildMsg              31     31n
     d  refLibChg             41     41n
     d  objectChg             42     42n
     d  overlay               77     77n

     d run             pr            10i 0 extproc('system')
     d   command                       *   value options(*string)

     d commandLine     pr                  extpgm('QUSCMDLN')

     d buildList       pr
     d addModRef       pr
     d closeList       pr
     d loadSfl         pr
     d clearSfl        pr

     d command         s           1024
     d sprintf         pr            10i 0 extproc('sprintf')
     d  target                         *   value options(*string)
     d  source                         *   value options(*string)
     d  value1                         *   value options(*string)
     d  value2                         *   value options(*string:*nopass)
     d  value3                         *   value options(*string:*nopass)
     d  value4                         *   value options(*string:*nopass)
     d  value5                         *   value options(*string:*nopass)
     d  value6                         *   value options(*string:*nopass)
     d  value7                         *   value options(*string:*nopass)
     d  value8                         *   value options(*string:*nopass)
     d  value9                         *   value options(*string:*nopass)
     d  value10                        *   value options(*string:*nopass)

     d dsppgmref       s             80    dim(1) ctdata
     d rc              s             10i 0
     d lastPgm         s                   like(whpnam)

      /free
       dow 1=1;
         overlay = sfldsp;
         write fky01;
         exfmt ctl01;
         select;
           when exit or cancel;
             leave;
           when refLibChg;
             buildList();
             loadSfl();
           when objectChg;
             clearSfl();
             loadSfl();
           when cmdLine;
             commandLine();
         endsl;
       enddo;
       closeList();
       rc = run('dltovr qadsppgm');
       *inlr = '1';
      /end-free

      **************************************************************************
     p loadSfl         b
      /free
       setll 1 QADSPPGM;
       read QADSPPGM;
       lastPgm = ' ';
       dow not %eof;
         if object <> ' ' and whfnam = object and whpnam <> lastPgm;
           rrn1 = rrn1 + 1;
           refobjtyp = '*PGM';
           if whspkg = 'V';
             refobjtyp = '*SRVPGM';
           endif;
           write sfl01;
           lastPgm = whpnam;
         endif;
         read QADSPPGM;
       enddo;
       if rrn1 > 0;
         rrn1 = 1;
         sfldsp = '1';
       endif;
      /end-free
     p                 e

      **************************************************************************
     p buildList       b
      /free
       buildMsg = '1';
       clearSfl();
       closeList();
       sfldlt = '0';
       rc = sprintf(%addr(command):dsppgmref(1):%trim(reflib));
       rc = run(command);
       //rc = run('ovrdbf qadsppgm qtemp/objref ovrscope(*job)');
       rc = run('ovrdbf qadsppgm qtemp/objref');
       open qadsppgm;
       addModRef();
       buildMsg = '0';
       return;
      /end-free
     p                 e

      **************************************************************************
     p addModRef       b

      /copy doc870src/qrpglesrc,@spyspcio
      /copy qsysinc/qrpglesrc,qusec
      /copy qsysinc/qrpglesrc,qusgen
      /copy qsysinc/qrpglesrc,qbnlspgm
      /copy qsysinc/qrpglesrc,qbnlpgmi

     d lstPgmInf       pr                  extpgm('QBNLPGMI')
     d  usrspc                       20    const
     d  format                       10    const
     d  program                      20    const
     d  error                              like(qusec)

     d lstSrvPgmInf    pr                  extpgm('QBNLSPGM')
     d  usrspc                       20    const
     d  format                       10    const
     d  program                      20    const
     d  error                              like(qusec)

     d rtvspcptr       pr                  extpgm('QUSPTRUS')
     d  userSpace                    20    const
     d  pointer                        *
     d spcP            s               *

     d error           ds                  likeds(qusec)
     d modInf          ds                  likeds(qbnl0100) based(modInfP)
     d genHdr          ds                  likeds(QUSH0300) based(genHdrP)
     d i               s             10i 0
     d offSet          s             10i 0

      /free
       crtusrspc('MODREFSPC ':'QTEMP     ':1024);
       rtvspcptr('MODREFSPC QTEMP     ':spcP);
       genHdrP = spcP;
       lastPgm = ' ';
       read qadsppgm;
       dow not %eof and whotyp <> '*MODULE';
         if whpnam <> lastPgm;
           clear error;
           error.qusbprv = %size(error);
           select;
             when whspkg = 'P';
               lstPgmInf('MODREFSPC QTEMP     ':'PGML0100':
                 whpnam + whlib:error);
             when whspkg = 'V';
               lstSrvPgmInf('MODREFSPC QTEMP     ':'SPGL0100':
                 whpnam + whlib:error);
           endsl;
           if error.qusbavl = 0;
             offSet = genHdr.qusold00;
             for i = 1 to genHdr.QUSNBRLE00;
               modInfP = spcP + offSet;
               whfnam = modInf.QBNBMN;
               whlnam = modInf.QBNBMLN;
               whotyp = '*MODULE';
               whsnam = modInf.QBNSFILM;
               write QWHDRPPR;
               offSet = offSet + genHdr.QUSSEE00;
             endfor;
           endif;
         endif;
         lastPgm = whpnam;
         read qadsppgm;
       enddo;
       dltusrspc('MODREFSPC ':'QTEMP     ');
       setll 1 qadsppgm;
       return;
      /end-free
     p                 e

      **************************************************************************
     p clearSfl        b
      /free
       sfldsp = '0';
       sfldlt = '1';
       rrn1 = 0;
       write ctl01;
       sfldlt ='0';
      /end-free
     p                 e

      **************************************************************************
     p closeList       b
      /free
       if %open(qadsppgm);
         close qadsppgm;
       endif;
       return;
      /end-free
     p                 e

**ctdata dsppgmref
DSPPGMREF PGM(%s/*ALL) OUTPUT(*OUTFILE) OBJTYPE(*ALL) OUTFILE(QTEMP/OBJREF)

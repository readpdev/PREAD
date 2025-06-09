      *%METADATA                                                       *
      * %TEXT Display Object References                                *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE':'SPYBNDDIR')

     fQADSPPGM  uf a e             disk    usropn

     d run             pr            10i 0 extproc('system')
     d   command                       *   value options(*string)

     d addModRef       pr

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

     d                sds
     d curPgmLib              81     90

     d dsppgmref       s             80    dim(1) ctdata
     d rc              s             10i 0

     c     *entry        plist
     c                   parm                    object           10
     c                   parm                    objlib           10
     c                   parm                    objtyp           10
     c                   parm                    reflib           10

      /free
       rc = sprintf(%addr(command):dsppgmref(1):%trim(reflib):%trim(curPgmLib));
       rc = run(command);
       rc = sprintf(%addr(command):'ovrdbf qadsppgm %s/objref':
         %trim(curPgmLib));
       rc = run(command);
       open qadsppgm;
       // Add module references to list if necessary.
       if objtyp = '*MODULE';
         addModRef();
       endif;
       read qadsppgm;
       close qadsppgm;
       rc = run('dltovr qadsppgm');
       *inlr = '1';
      /end-free

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
     d lastPgm         s                   like(whpnam)
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

**ctdata dsppgmref
DSPPGMREF PGM(%s/*ALL) OUTPUT(*OUTFILE) OBJTYPE(*ALL) OUTFILE(%s/OBJREF)

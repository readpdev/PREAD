      *%METADATA                                                       *
      * %TEXT Check for spool files in specific outq's                 *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR')

     fqsysprt   o    f  100        printer oflind(*in01) usropn
     ffolder    if   f  256        disk    usropn

     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         256    const
     d  cmdlen                       15p 5 const

     d sqlStmt         s            512

      * Qualified job name from folder @ locsfa RRN.
     d QJ              ds           256    qualified
     d  jobFrFldr                    26    overlay(QJ:50)
     d   job                         10    overlay(JobFrFldr)
     d   usr                         10    overlay(JobFrFldr:*next)
     d   nbr                          6    overlay(JobFrFldr:*next)
     d spyNbrDS        ds           256
     d  spynbr                       10    overlay(spyNbrDS:122)

      /copy @masplio
      /copy @memio
      /copy qsysinc/qrpglesrc,qusrspla

     d inputDS         ds
     d  filnam                       10
     d  filnum                        9b 0
     d  outqnm                       10
     d  outqlb                       10
     d  locsfa                        9b 0
     d  fldrlb                       10
     d  fldr                         10

     d job             s             26
     d jobID           s             16    inz
     d splfID          s             16    inz

     d timeFld         s               t
     d splfHdl         s             10i 0
     d saveFolder      s             20
     d batchHeader     s              9b 0

     c     *entry        plist
     c                   parm                    startDate         8
      /free
       if not %open(qsysprt);
         run('ovrprtf qsysprt':15);
         open qsysprt;
       endif;
       sqlStmt = 'select filnam, filnum, outqnm, ' +
       'outqlb, locsfa, fldrlb, fldr from mrptdir where adsf >= ' + startDate +
       ' and exists ( select distinct(irnam) from rindex where irnam = filnam'+
       ' and ijnam = jobnam and ipnam = pgmopf and iunam = usrnam and iudat = '+
       'usrdta )';
       exsr preDclOpn;
       exsr fetchSR;
       *in01 = '1';
       dow sqlcod = 0;
         if fldrlb + fldr <> saveFolder;
          close(e) folder;
          callp(e) run('dltovr folder':13);
          run('ovrdbf folder ' + %trim(fldrlb) + '/' + fldr:35);
          open folder;
         endif;
         chain locsfa folder QJ;
         if not %found;
           exsr fetchSR;
           iter;
         endif;
         batchHeader = locsfa - 1;
         chain batchHeader folder spyNbrDS;
         saveFolder = fldrlb + fldr;
         splfHdl = opnSplf(QJ.jobFrFldr:filnam:filnum:jobID:splfID);
         if splfHdl >= 0;
           clear qusa0200;
           memcpy(%addr(qusa0200):getOpnSplA(splfHdl):%size(qusa0200));
           if quson01 = outqnm and qusol01 = outqlb;
             exsr printException;
           endif;
           cloSplf(splfHdl);
         endif;
         exsr fetchSR;
       enddo;
       exsr printHeader;
       except endrpt;
       close(e) folder;
       callp(e) run('dltovr folder':13);
       close(e) qsysprt;
       cloSplf(splfHdl);
       exsr closeCursor;
       *inlr = '1';
       //***********************************************************************
       begsr printException;
        exsr printHeader;
        except detail;
       endsr;

       //***********************************************************************
       begsr printHeader;
         if *in01;
           timeFld = %time;
           except header;
           *in01 = '0';
         endif;
       endsr;

      /end-free

      **************************************************************************
     c     preDclOpn     begsr
     c/exec sql
     c+ prepare stmt from :sqlStmt
     c/end-exec
     c/exec sql
     c+ declare csr01 cursor for stmt
     c/end-exec
     c/exec sql
     c+ open csr01
     c/end-exec
     c                   endsr

      **************************************************************************
     c     fetchSR       begsr
     c/exec sql
     c+ fetch next from csr01 into :filnam, :filnum, :outqnm, :outqlb, :locsfa,
     c+ :fldrlb, :fldr
     c/end-exec
     c                   endsr

      **************************************************************************
     c     closeCursor   begsr
     c/exec sql
     c+ close csr01
     c/end-exec
     c                   endsr

      **************************************************************************
     oqsysprt   e            header         2  1
     o                       *date         Y
     o                                              '  '
     o                       timeFld
     o                                              '  '
     o                                              'Report Archive Exceptions'
     o                       page          Z    100
     o                                           94 'Page:'
     o          e            header         1
     o                                              'File Name '
     o                                              '  '
     o                                              'Job Name  '
     o                                              '  '
     o                                              'User Name '
     o                                              '  '
     o                                              'Job Num'
     o                                              '  '
     o                                              'File Number'
     o                                              '  '
     o                                              'Out Queue '
     o                                              '  '
     o                                              'OutQ Library'
     o                                              '  '
     o                                              'Spy Number'
     o          e            detail         1
     o                       filnam
     o                                              '  '
     o                       QJ.job
     o                                              '  '
     o                       QJ.usr
     o                                              '  '
     o                       QJ.nbr
     o                                              '     '
     o                       filnum        Z
     o                                              '  '
     o                       outqnm
     o                                              '  '
     o                       outqlb
     o                                              '    '
     o                       spynbr
     o          e            endrpt
     o                                              '***End of Report***'

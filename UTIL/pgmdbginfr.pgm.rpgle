      *%METADATA                                                       *
      * %TEXT Find any service/programs that have observability        *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYSPCIO')

     fqsysprt   o    f  132        printer

      /copy @spyspcio
      /copy qsysinc/qrpglesrc,qusec
      /copy qsysinc/qrpglesrc,qbnlpgmi
      /copy qsysinc/qrpglesrc,qbnlspgm

     d lstPgmi         pr                  extpgm('QBNLPGMI')
     d  userSpc                      20    const
     d  format                        8    const
     d  qpgm                         20    const
     d  error                              like(qusec)

     d lstSrvPgm       pr                  extpgm('QBNLSPGM')
     d  userSpc                      20    const
     d  format                        8    const
     d  qsrvpgm                      20    const
     d  error                              like(qusec)

     d rtvSpcPtr       pr                  extpgm('QUSPTRUS')
     d  userSpc                      20    const
     d  pointer                        *

     d header          ds           136    based(hdrP)
     d  lstOffSet                    10i 0 overlay(header:125)
     d  entries                      10i 0 overlay(header:133)

     d pList           ds                  likeds(qbnl0100) based(pListP)

     d sList           ds                  likeds(QBNL010000) based(sListP)

     d qUsrSpc         s             20
     d qpgm            s             20
     d nbrPgms         s             10i 0
     d nbrSrvPgms      s             10i 0
     d i               s             10i 0
     d pgmnam          s             10
     d pgmtyp          s             10    inz('*PGM')
     d totPgmsDbg      s             10i 0 inz
     d savePgm         s             10    inz

     c     *entry        plist
     c                   parm                    library          10
     c                   parm                    passFail          1
      * Pass = '0', Fail = '1'

      /FREE
       dltusrspc('PGMS':'QTEMP');
       dltusrspc('SRVPGMS':'QTEMP');

       passFail = '0';

       // Fill user space for all stand alone programs. ILE.
       crtUsrSpc('PGMS':'QTEMP':102400);
       qUsrSpc = 'PGMS      QTEMP';
       qusbprv = %size(qusec);
       qusbavl = 0;
       qpgm = '*ALL      ' + library;
       lstPgmi(qUsrSpc:'PGML0100':qpgm:qusec);
       rtvSpcPtr(qUsrSpc:hdrP);
       pListP = hdrP + lstoffset;
       nbrPgms = entries;

       // Fill user space for service programs.
       crtUsrSpc('SRVPGMS':'QTEMP':102400);
       qUsrSpc = 'SRVPGMS   QTEMP';
       qusbprv = %size(qusec);
       qusbavl = 0;
       lstSrvPgm(qUsrSpc:'SPGL0100':qpgm:qusec);
       rtvSpcPtr(qUsrSpc:hdrP);
       sListP = hdrP + lstoffset;
       nbrSrvPgms = entries;

       except prthdr;

       for i = 1 to nbrPgms;
         if pList.qbndd <> '*NO';
          pgmnam = plist.qbnpgmn00;
          if pgmnam <> savepgm;
            except prterr;
            totPgmsDbg += 1;
          endif;
          savepgm = pgmnam;
         endif;
         pListP = pListP + %size(pList);
       endfor;

       pgmTyp = '*SRVPGM';
       for i = 1 to nbrSrvPgms;
         if sList.qbndd00 <> '*NO';
          pgmnam = slist.qbnsn00;
          if pgmnam <> savepgm;
            except prterr;
            totPgmsDbg += 1;
          endif;
          savepgm = pgmnam;
         endif;
         sListP = sListP + %size(sList);
       endfor;

       except prtftr;

       if totPgmsDbg > 0;
         passFail = '1';
       endif;

       dltusrspc('PGMS':'QTEMP');
       dltusrspc('SRVPGMS':'QTEMP');

       *inlr = *on;

      /end-free

      **************************************************************************
     oqsysprt   e            prthdr         1
     o                                              'Library:'
     o                                              '  '
     o                       library
     o          e            prterr         1
     o                                              'Program:'
     o                                              '  '
     o                       pgmNam
     o                                              '  '
     o                                              'Type:'
     o                                              '  '
     o                       pgmTyp
     o          e            prtftr         1
     o                                              'Total programs with debug:'
     o                                              '  '
     o                       totPgmsDbg

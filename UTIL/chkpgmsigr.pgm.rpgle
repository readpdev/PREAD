      *%METADATA                                                       *
      * %TEXT Check for Service Program Signature Violations           *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYSPCIO')

     fqsysprt   o    f  132        printer

      /copy @spyspcio
      /copy qsysinc/qrpglesrc,qusec

     d cvthc           pr                  extproc('cvthc')
     d  tgt                            *   value
     d  src                            *   value
     d  tgtlen                       10i 0 value

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

     d run             pr                  extproc('system')
     d  cmd                            *   options(*string:*trim) value

     d header          ds           136    based(hdrP)
     d  lstOffSet                    10i 0 overlay(header:125)
     d  entries                      10i 0 overlay(header:133)

     d pList           ds                  based(pListP)
     d  pgmNam                       10
     d  pgmLib                       10
     d  pSrvNam                      10
     d  pSrvLib                      10
     d  pSrvSig                      16
     d  pSrvAct                      10

     d sList           ds                  based(sListP)
     d  srvNam                       10
     d  srvLib                       10
     d  srvSig                       16

     d qUsrSpc         s             20
     d qpgm            s             20
     d nbrPgms         s             10i 0
     d i               s             10i 0
     d j               s             10i 0
     d matching        s               n
     d sigString       s             32
     d violations      s             10i 0 inz

     c     *entry        plist
     c                   parm                    library          10

      /FREE
       dltusrspc('PGMS':'QTEMP');
       dltusrspc('SRVPGMS':'QTEMP');

       // Fill user space for all stand alone programs. ILE.
       crtUsrSpc('PGMS':'QTEMP':102400);
       qUsrSpc = 'PGMS      QTEMP';
       qusbprv = %size(qusec);
       qusbavl = 0;
       qpgm = '*ALL      ' + library;
       lstPgmi(qUsrSpc:'PGML0200':qpgm:qusec);
       rtvSpcPtr(qUsrSpc:hdrP);
       pListP = hdrP + lstoffset;
       nbrPgms = entries;

       // Fill user space for service programs.
       crtUsrSpc('SRVPGMS':'QTEMP':102400);
       qUsrSpc = 'SRVPGMS   QTEMP';
       qusbprv = %size(qusec);
       qusbavl = 0;
       lstSrvPgm(qUsrSpc:'SPGL0800':qpgm:qusec);
       rtvSpcPtr(qUsrSpc:hdrP);
       sListP = hdrP + lstoffset;

       for i = 1 to nbrPgms;
         // Look for service programs that are not OS related...doesn't start with 'Q'.
         if %subst(pSrvNam:1:1) <> 'Q';
           // Walk service program list for matching referenced service program.
           sListP = hdrP + lstoffset;
           matching = *off;
           for j = 1 to entries;
             if srvNam = pSrvNam and srvSig = pSrvSig;
               matching = *on;
               leave;
             endif;
             sListP = sListP + %size(sList);
           endfor;
           if not matching;
             cvthc(%addr(sigString):%addr(pSrvSig):%size(sigString));
             except prterr;
             violations += 1;
           endif;
         endif;
         pListP = pListP + %size(pList);
       endfor;

       except prtErrCnt;

       dltusrspc('PGMS':'QTEMP');
       dltusrspc('SRVPGMS':'QTEMP');

       *inlr = *on;

      /end-free

      **************************************************************************
     oqsysprt   e            prterr         1
     o                                              'Program:'
     o                                              '  '
     o                       pgmNam
     o                                              '  RefSig:'
     o                       sigString
     o                                              '  SrvPgm:'
     o                       pSrvNam
     o          e            prtErrCnt
     o                                              'Violations:'
     o                                              '  '
     o                       violations

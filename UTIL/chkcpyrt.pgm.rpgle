      *%METADATA                                                       *
      * %TEXT Check for copyright in all programs                      *
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
     d  pRsrv                         4
     d  pCpyRtLen                    10i 0
     d  pCpyRt                      256

     d sList           ds                  based(sListP)
     d  srvNam                       10
     d  srvLib                       10
     d  srvRsrv                      10i 0
     d  srvCpyRtLen                  10i 0
     d  srvCpyRt                    256

     d qUsrSpc         s             20
     d qpgm            s             20
     d nbrPgms         s             10i 0
     d nbrSrvPgms      s             10i 0
     d i               s             10i 0
     d msgTxt          s             80
     d pgmsInErr       s             10i 0
     d srvPgmsInErr    s             10i 0

     c     *entry        plist
     c                   parm                    library          10
     c                   parm                    chkYYYY           4

      /FREE
       dltusrspc('PGMS':'QTEMP');
       dltusrspc('SRVPGMS':'QTEMP');

       // Fill user space for all stand alone programs. ILE.
       crtUsrSpc('PGMS':'QTEMP':102400);
       qUsrSpc = 'PGMS      QTEMP';
       qusbprv = %size(qusec);
       qusbavl = 0;
       qpgm = '*ALL      ' + library;
       lstPgmi(qUsrSpc:'PGML0500':qpgm:qusec);
       rtvSpcPtr(qUsrSpc:hdrP);
       pListP = hdrP + lstoffset;
       nbrPgms = entries;

       for i = 1 to nbrPgms;
         if pgmNam <> 'RSTOBJSPY' and pgmNam <> 'CHKTAPSPY';
           if %scan(chkYYYY:pCpyRt) = 0;
             msgTxt = %trimr(pgmLib) + '/' + %trimr(pgmNam) +
               ' *PGM missing or invalid copyright.';
             pgmsInErr += 1;
             except prterr;
           endif;
           pListP = pListP + %size(pList);
         endif;
       endfor;

       // Fill user space for service programs.
       crtUsrSpc('SRVPGMS':'QTEMP':102400);
       qUsrSpc = 'SRVPGMS   QTEMP';
       qusbprv = %size(qusec);
       qusbavl = 0;
       lstSrvPgm(qUsrSpc:'SPGL0500':qpgm:qusec);
       rtvSpcPtr(qUsrSpc:hdrP);
       sListP = hdrP + lstoffset;
       nbrSrvPgms = entries;

       for i = 1 to nbrSrvPgms;
         if srvnam <> 'PDFLIBI' and srvNam <> 'TETLIB' and srvNam <> 'QANSAPI'
           and srvnam <> 'PDFLIB';
           if %scan(chkYYYY:srvCpyRt) = 0;
             msgTxt = %trimr(srvLib) + '/' + %trimr(srvNam) +
                 ' *SRVPGM missing or invalid copyright.';
               srvPgmsInErr += 1;
               except prterr;
           endif;
           sListP = sListP + %size(sList);
         endif;
       endfor;

       msgTxt = 'Programs in error: ' + %trim(%char(pgmsInErr));
       except prterr;
       msgTxt = 'Service programs in error: ' + %trim(%char(srvPgmsInErr));
       except prterr;
       msgTxt = 'Total: ' + %trim(%char(pgmsInErr + srvPgmsInerr));
       except prterr;

       dltusrspc('PGMS':'QTEMP');
       dltusrspc('SRVPGMS':'QTEMP');

       *inlr = *on;

      /end-free

      **************************************************************************
     oqsysprt   e            prterr         1
     o                       msgtxt

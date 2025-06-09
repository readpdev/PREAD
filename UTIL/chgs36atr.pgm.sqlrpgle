      *%METADATA                                                       *
      * %TEXT Change the S36 Continue Splf Attr in MRPTATR             *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE':'SPYBNDDIR')

      /copy @masplio
      /copy qsysinc/qrpglesrc,qusrspla

     d sndmsg          pr
     d  msg                         100    value

     d rc              s             10i 0
     d hdrRcdNbr       s             10u 0
     d sqlStmt         s            512
     d SQ              c                   ''''

     d rptdir        e ds                  extname('MRPTDIR') qualified
     d                 ds
     d attrRcd                      256
     d   AFPDS                        1    overlay(attrRcd:53)
     d   CHRID                        1    overlay(attrRcd:54)
     d   S36CY                        1    overlay(attrRcd:55)
     d   OSVER                        6    overlay(attrRcd:101)

     d system          pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     c     *entry        plist
     c                   parm                    reportID         10
     c                   parm                    attrValue         1

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;

       exec sql select * into :rptdir from mrptdir where repind = :reportID;
       if sqlcod <> 0;
         sndmsg('Report ID ' + %trim(reportID) + ' not found');
         exsr quit;
       endif;

       exec sql delete from mrptatr where raspy# = :reportID;

       // Fetch attributes from folder (parm4 = 3)
       if getArcAtr(reportID:%addr(qusa0200):%size(qusa0200):3) <> 0;
         sndmsg('Error fetching report attributes from folder. Quitting');
         exsr quit;
       endif;

       system('ovrdbf folder ' + %trim(rptdir.fldrlb) + '/' + rptdir.fldr +
         ' ovrscope(*job)');

       // Update the OS version
       hdrRcdNbr = rptdir.locsfa + 3;

       exec sql select * into :attrRcd from folder where rrn(folder) =
         :hdrRcdNbr;

       OSVER = 'V2R3M0';

       sqlStmt = 'update folder set ' + %trimr(rptdir.fldr) + ' = ' +
         SQ + attrRcd + SQ + ' where rrn(folder) = ' + %trim(%char(hdrRcdNbr));

       exec sql execute immediate :sqlStmt;

       // Update S36 attribute.
       hdrRcdNbr = rptdir.locsfa + 11;

       exec sql select * into :attrRcd from folder where rrn(folder) =
         :hdrRcdNbr;


       AFPDS = 'N';
       CHRID = 'N';
       S36CY = attrValue;

       //QUSAFPDS = attrValue; //@2857
       //QUSCHRID = attrValue; //@2858
       //QUSS36CY = attrValue; //@2859
       //QUSFILL00 = 'V7R3M0';

       sqlStmt = 'update folder set ' + %trimr(rptdir.fldr) + ' = ' +
         SQ + attrRcd + SQ + ' where rrn(folder) = ' + %trim(%char(hdrRcdNbr));

       exec sql execute immediate :sqlStmt;

       system('dltovr folder lvl(*job)');

       //rc = putArcAtr(reportID:%addr(qusa0200));
       //if rc <> 0;
       //  sndmsg('Error writing attributes for ' + %trim(rptdir.repind) +
       //  ' Continuing.');
       //endif;

       exsr quit;

       //*****************************************************************
       begsr quit;
         *inlr = '1';
       endsr;

      /end-free

      *********************************************************************
     p sndmsg          b
     d                 pi
     d msg                          100    value

     d spyErr          pr                  extpgm('SPYERR')
     d  msgid                         7    const
     d  msgdta                      100    const options(*varsize)
     d  msgfil                       10    const
     d  msglib                       10    const

      /free
       spyerr('CPF9897':MSG:'QCPFMSG':'*LIBL');
       return;
      /end-free
     p                 e

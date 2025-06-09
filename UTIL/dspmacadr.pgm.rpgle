      *%METADATA                                                       *
      * %TEXT Display MAC Address                                      *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('SPYBNDDIR')

     d lstArpTbl       pr                  extproc('QtocLstPhyIfcARPTbl')
     d  usrSpcNam                    20    const
     d  formatName                   10    const
     d  lineName                     10
     d  apiErr                             like(qusec)

      /copy qsysinc/qrpglesrc,qusec
      /copy @spyspcio

     c     *entry        plist
     c                   parm                    lineName         10

      /free
       crtUsrSpc('MACADR':'QTEMP':1024);
       lstArpTbl('MACADR    QTEMP     ':'ARPT0100':lineName:qusec);
       *inlr = '1';
      /end-free

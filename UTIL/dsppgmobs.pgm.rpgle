      *%METADATA                                                       *
      * %TEXT Display Program Observability                            *
      *%EMETADATA                                                      *
     h main(main) dftactgrp(*no) actgrp(*new)

     D main            PR                  EXTPGM('DSPPGMOBS')


       /copy @spyspcio
       /copy qsysinc/qrpglesrc,quslobj

     P*--------------------------------------------------
     P main            B
     D main            PI

      /FREE

       dltUsrSpc('DSPPGMOBS':'QTEMP');
       crtUsrSpc('DSPPGMOBS':'QTEMP':2000);

      /END-FREE
     P main            E


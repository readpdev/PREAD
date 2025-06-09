      *%METADATA                                                       *
      * %TEXT Display Remote Document                                  *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('DRDBNDDIR')

      /copy @drdcommon
      /copy @crypto
      /copy qsysinc/qrpglesrc,qdcrdevd
      /copy qsysinc/qrpglesrc,qusec

     d rcvDevD         pr                  extpgm('QDCRDEVD')
     d  receiver                           like(QDCD060000)
     d  receiverLen                  10i 0 const
     d  format                        8    const
     d  deviceName                   10    const
     d  error                              likeds(qusec)

     d sprintf         pr            10i 0 extproc('sprintf')
     d  target                         *   value options(*string)
     d  source                         *   value options(*string)
     d  value1                         *   value options(*string)
     d  value2                         *   value options(*string)
     d  value3                         *   value options(*string)
     d  value4                         *   value options(*string)
     d  value5                         *   value options(*string)
     d  value6                         *   value options(*string)
     d  value7                         *   value options(*string)
     d  value8                         *   value options(*string)
     d  value9                         *   value options(*string)
     d  value10                        *   value options(*string)
     d  value11                        *   value options(*string)
     d  value12                        *   value options(*string)

     d remoteCmdA      s             80    dim(3) ctdata
     d mask            s            512
     d formatted       s            512

     d                sds
     d jobName               244    253

     c     *entry        plist
     c                   parm                    docClass         10
     c                   parm                    ival1            70
     c                   parm                    ival2            70
     c                   parm                    ival3            70
     c                   parm                    ival4            70
     c                   parm                    ival5            70
     c                   parm                    ival6            70
     c                   parm                    ival7            70

      /free
       in drdcfgdta;
       crypto(OP_DECRYPT:%addr(workPassword):%addr(password));
       rcvDevD(QDCD060000:%size(QDCD060000):'DEVD0600':jobName:qusec);
       mask = %trimr(remoteCmdA(1)) + ' ' + %trimr(remoteCmdA(2)) + ' ' +
         %trimr(remoteCmdA(3));
       sprintf(%addr(formatted):%trimr(mask):%trimr(docClass):%trimr(ival1):
       %trimr(ival2):%trimr(ival3):%trimr(ival4):%trimr(ival5):%trimr(ival6):
       %trimr(ival7):%trimr(QDCIPADF):%trimr(system):%trimr(user):
       %trimr(workPassword));
       run(formatted);
       *inlr = '1';
      /end-free
**ctdata remoteCmdA
RUNRMTCMD CMD('DRDLIB/DSPDOCCMD DOCCLS(%s) IVAL1(%s) IVAL2(%s) IVAL3(%s)
IVAL4(%s) IVAL5(%s) IVAL6(%s) IVAL7(%s) DEVIPADR('%s')') RMTLOCNAME(%s *IP)
RMTUSER(%s) RMTPWD(%s)

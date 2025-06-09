     h dftactgrp(*no) actgrp(*caller) bnddir('QUSAPIBD')

      /copy qsysinc/qrpglesrc,qtocnetsts
      /copy qsysinc/qrpglesrc,qusec

     d rtvCnnDta       pr                  extproc('QtocRtvNetCnnDta')
     d  receiver                           likeds(cnnDta)
     d  receiverLen                  10i 0 const
     d  format                        8    const
     d  listQual                           likeds(listQual)
     d  error                              likeds(qusec)

     d cvtIPtoBin      pr            10i 0 extproc('inet_pton')
     d  family                       10i 0 value
     d  source                         *   value options(*string)
     d  result                         *   value

     d listQual        ds                  qualified
     d  protocol                     10i 0 inz(TCP_IPV4)
     d  localAddress                 10u 0 inz
     d  localPort                    10i 0 inz
     d  remoteAddress                10u 0 inz
     d  remotePort                   10i 0 inz

     d cnnDta          ds                  qualified
     d  d100                               likeds(qtod010001)
     d  d200                               likeds(qtod020000)
     d  buf                       20000

     d job             ds                  based(jobP) qualified
     d  format                       10i 0
     d  task                         16
     d  name                         10
     d  user                         10
     d  number                        6
     d  jobid                        16

     d inetAddr0       s             20    inz('192.168.89.130')
     d localAddr0      s             20    inz('192.168.88.103')
     d TCP_IPV4        c                   1
     d AF_INET         s             10i 0 inz(2)
     d rc              s             10i 0
     d i               s             10i 0

      /free
       inetAddr0 = %trimr(inetAddr0) + x'00';
       rc = cvtIPtoBin(AF_INET:inetAddr0:%addr(listQual.remoteAddress));
       localAddr0 = %trimr(localAddr0) + x'00';
       rc = cvtIPtoBin(AF_INET:localAddr0:%addr(listQual.localAddress));
       clear qusec;
       qusbprv = %len(qusec);
       rtvCnnDta(cnnDta:%len(cnnDta):'NCND0200':listQual:qusec);
       jobP = %addr(cnnDta) + cnnDta.d200.qtoljawc;
       for i = 1 to cnnDta.d200.qtonjawc;
         jobP = jobP + cnnDta.d200.qtoljawc00;
       endfor;
       *inlr = '1';
      /end-free

     h dftactgrp(*no) actgrp(*caller) bnddir('DRDBNDDIR')

     fdrdcfg    cf   e             workstn indds(indds)

      /copy qsysinc/qrpglesrc,qusec
      /copy @crypto
      /copy @drdcommon

     d spm             pr
     d  message                      80    const

     d rmvmsgs         pr

     d indds           ds            99
     d  f3                    03     03n
     d  errSystemID           61     61n
     d  errUserID             62     62n
     d  errPassword           63     63n
     d  errors                61     63
     d  overlay               70     70n

     d                sds
     d pgmq              *proc

     c     *entry        plist
     c                   parm                    configType       10

      /free
       select;
         when configType = '*CLIENT';
           exsr clientConfig;
         when configType = '*SERVER';
           exsr serverConfig;
        endsl;
       *inlr = '1';

       //***********************************************************************
       begsr clientConfig;
         in(e) *lock drdcfgdta;
         if %error;
           run('crtdtaara drdlib/drdcfgdta *char ' +
             %editc(%size(drdcfgdta):'Z'));
           in *lock drdcfgdta;
         endif;
         if password <> ' ';
           crypto(OP_DECRYPT:%addr(workPassword):%addr(password));
           password = workPassword;
         endif;
         rmvmsgs();
         dow 1=1;
           write msgctl;
           exfmt record1;
           overlay = '1';
           rmvmsgs();
           errors = *all'0';
           if F3;
             leave;
           endif;
           if system = ' ';
             spm('System address or name cannot be blank');
             errSystemID = '1';
             iter;
           endif;
           if user = ' ';
             spm('User ID cannot be blank');
             errUserID = '1';
             iter;
           endif;
           if password = ' ';
             spm('Password cannot be blank');
             errPassword = '1';
             iter;
           endif;
           crypto(OP_ENCRYPT:%addr(password):%addr(password));
           out drdcfgdta;
           spm('Configuration updated');
           leave;
         enddo;
       endsr;

       //***********************************************************************
       begsr serverConfig;
       endsr;
      /end-free

      **************************************************************************
     p spm             b

      // Send program message.

     d                 pi
     d  msgdta                       80    const

     d sndmsg          pr                  extpgm('QMHSNDPM')
     d  msgid                         7    const
     d  msgf                         20    const
     d  msgdta                       80    const
     d  msgdtalen                    10i 0 const
     d  msgtype                      10    const
     d  pgmq                               like(pgmq)
     d  stackcnt                     10i 0 const
     d  msgkey                        4    const
     d  error                              likeds(qusec)

     d msgf            s             20    inz('QCPFMSG   *LIBL')
     d msgdtalen       s             10i 0 inz(0)
     d stackCnt        s             10i 0 inz(0)

      /FREE
       msgDtaLen = %len(%trimr(msgdta));
       sndmsg('CPF9898':msgf:msgdta:msgdtalen:'*INFO':pgmq:0:' ':qusec);
       return;

      /END-FREE
     p                 e

      **************************************************************************
     p rmvMsgs         b

     d rmvpmmsgs       pr                  extpgm('QMHRMVPM')
     d  stack                        10    const
     d  stackcnt                     10i 0 const
     d  msgkey                        4    const
     d  msgtype                      10    const
     d  error                              likeds(qusec)

     d stackCnt        s             10i 0 inz(0)

      // remove program messages.
      /free
       for stackcnt = 0 to 3;
         rmvpmmsgs('*':stackcnt:' ':'*ALL':qusec);
       endfor;

       return;

      /END-FREE
     p                 e


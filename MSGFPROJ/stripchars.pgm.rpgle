      *%METADATA                                                       *
      * %TEXT Remove unecessary characters                             *
      *%EMETADATA                                                      *

     d cmd             pr                  extpgm('QCMDEXC')
     d  cmdStr                      256    const
     d  cmdLen                       15p 5 const

     d tick            pr              *   extproc('tick')
     d  buf                            *   value

     d msgAPI          pr            10i 0 extproc('msgAPI')
     d  ma_rcvr                        *   value
     d  ma_id                         7
     d  ma_name                      21
     d  ma_rplcdta                   10
     d  ma_lenrplc                   10i 0 value
     d  ma_rplcvals                    *
     d  ma_rtvOpt                    10
     DQMHM030000       DS
     D*                                             Qmh Rtvm RTVM0300
     D QMHBR03                 1      4B 0
     D*                                             Bytes Return
     D QMHBAVL09               5      8B 0
     D*                                             Bytes Available
     D QMHMS09                 9     12B 0
     D*                                             Message Severity
     D QMHAI00                13     16B 0
     D*                                             Alert Index
     D QMHAO03                17     25
     D*                                             Alert Option
     D QMHLI02                26     26
     D*                                             Log Indicator
     D QMHMID                 27     33
     D*                                             Message ID
     D QMHERVED19             34     36
     D*                                             Reserved
     D QMHNRDF                37     40B 0
     D*                                             Number Replace Data Formats
     D QMHSIDCS07             41     44B 0
     D*                                             Text CCSID Convert Status
     D QMHSIDCS08             45     48B 0
     D*                                             Data CCSID Convert Status
     D QMHCSIDR07             49     52B 0
     D*                                             Text CCSID Returned
     D QMHORT                 53     56B 0
     D*                                             Offset Reply Text
     D QMHLRRTN00             57     60B 0
     D*                                             Length Reply Returned
     D QMHLRAVL00             61     64B 0
     D*                                             Length Reply Available
     D QMHOMRTN               65     68B 0
     D*                                             Offset Message Returned
     D QMHLMRTN04             69     72B 0
     D*                                             Length Message Returned
     D QMHLMAVL04             73     76B 0
     D*                                             Length Message Available
     D QMHOHRTN               77     80B 0
     D*                                             Offset Help Returned
     D QMHLHRTN04             81     84B 0
     D*                                             Length Help Returned
     D QMHLHAVL04             85     88B 0
     D*                                             Length Help Available
     D QMHOF                  89     92B 0
     D*                                             Offset Formats
     D QMHLFRTN               93     96B 0
     D*                                             Length Formats Returned
     D QMHLFAVL               97    100B 0
     D*                                             Length Formats Available
     D QMHLFE                101    104B 0
     d  qmsgDta              105   3236
     d ma_rcvr         s               *   inz(%addr(QMHM030000))
     d ma_id           s              7
     d ma_name         s             21
     d ma_rplcdta      s             10    inz
     d ma_lenrplc      s             10i 0 inz
     d ma_rplcvals     s               *   inz
     d ma_rtvOpt       s             10    inz('*FIRST')
     d i               s             10i 0
     d                 ds
     d msgDta                       140
     d  msgDtaA                       1    dim(140) overlay(msgDta)

     d frDta           c                   '.:'
     d toDta           c                   '  '
     d cmdStr          s            256
     d x               s             10i 0

     c     *entry        plist
     c                   parm                    msgf             10
     c                   parm                    msgflib          10

      /free
       ma_name = msgf;
       %subst(ma_name:11:10) = msgflib;
       dow msgAPI(ma_rcvr:ma_id:ma_name:ma_rplcdta:ma_lenrplc:
         ma_rplcvals:ma_rtvOpt) = 0;
         if (%str(ma_rcvr+QMHOMRTN:QMHLMRTN04) = ' ');
           exsr nextMsg;
           iter;
         endif;
         msgDta = %trimr(%str(ma_rcvr+QMHOMRTN:QMHLMRTN04));
         if qmhmid <> 'JJF0000';
           for x = %size(msgDta) downto 2;
             if (msgDtaA(x) = '.' or msgDtaA(x) = ':') and (msgDtaA(x-1) = ' ');
               msgDtaA(x) = ' ';
             endif;
           endfor;
           msgDta = %trimr(msgDta) + x'00';
           msgDta = %str(tick(%addr(msgDta)));
           cmdStr = 'chgmsgd msgid(' + qmhmid + ') msgf(' + %trim(msgflib) +
             '/' + %trim(msgf) + ') msg(' + %trim(msgdta) + ')';
           cmd(cmdStr:%len(%trim(cmdStr)));
         endif;
         exsr nextMsg;
       enddo;
       *inlr = '1';
       //****************************
       begsr nextMsg;
         ma_id = qmhmid;
         ma_rtvOpt = '*NEXT';
       endsr;
      /end-free

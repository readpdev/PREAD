     h dftactgrp(*no) actgrp(*new)

T6896 /copy qsysinc/qrpglesrc,qpmlpmgt

T6896d dlparGetInfo    pr            10i 0 extproc('dlpar_get_info')
     d  receiver                       *   value
     d  dataFormat                   10i 0 value
     d  receiverLen                  10i 0 value

     d rc              s             10i 0
     d dsplyDta        s             50

      /free
/      rc = dlparGetInfo(%addr(qpmdif1):1:%size(qpmdif1));
       if rc > 0;
/        dsplyDta = 'Assigned LPAR ID = ' + %char(qpmlnbr);
       else;
         dsplyDta = 'dlpar_get_info error = ' + %char(rc);
/      endif;
       dsply dsplyDta;
       return;
      /end-free

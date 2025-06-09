      *%METADATA                                                       *
      * %TEXT View Audit Log Entries                                   *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR')

     fviewlogd  cf   e             workstn indds(indds) sfile(sfl01:rrn1)

     d indds           ds            99
     d  exit                  03     03n
     d  refresh               05     05n
     d  sfldsp                25     25n
     d  sfldlt                26     26n

     d OK              c                   0
     d EOFIND          c                   1
     d SHUTDOWN        c                   4
     d GET             c                   0
     d GETLV           c                   1

      /copy @mlaudlog
      /copy @memio
      /copy qsysinc/qrpglesrc,qusec

     d loadSFL01       pr

     d parseBuf        pr
     d opcode                         5i 0 const
     d targetP                         *   value
     d sourceP                         *
     d bufPos                        10u 0
     d targetLen                     10i 0 value

      * Retrieve message id text.
     d getMsgTxt       pr            80
     d  prefix                        3    const
     d  msgNbr                       10i 0 const

     d lastDocID       s                   like(DocID)

     c     *entry        plist
     c                   parm                    docID

      /free
       loadSFL01();
       dow (1 = 1);
         write fky01;
         exfmt ctl01;
         select;
         when exit;
           leave;
         when refresh;
           eval sfldsp = '0';
           sfldlt = '1';
           write ctl01;
           sfldlt = '0';
           loadSFL01();
         when DocID <> lastDocID;
           loadSFL01();
         endsl;
         lastDocID = DocID;
       enddo;
       *inlr = '1';
       return;

      /end-free

      *****************************************************************
     p loadSFL01       b

     d                 pi

     d LogRqst         ds
      /copy @mllogreq

     d inputHDR        ds
     d  i_UserID                     20
     d  i_Block01                    18
     d  i_OpCode                      5u 0 overlay(i_Block01)
     d  i_ImgSeq                     10u 0 overlay(i_Block01:*next)
     d  i_LnkSeq                     10u 0 overlay(i_Block01:*next)
     d  i_NoteNbr                    10u 0 overlay(i_Block01:*next)
     d  i_PageNbr                    10i 0 overlay(i_Block01:*next)
     d  i_NodeID                    256
     d  i_DateTime                   14s 0
     d   i_Date                       8    overlay(i_DateTime)
     d   i_Time                       6    overlay(i_DateTime:*next)
     d  i_Comment                 15360
     d  i_DtlCnt                      5u 0

     d inputDTL        ds
     d  i_Type                        5u 0
     d  i_ValueName                 256
     d  i_Value                   15360

     d bp              s             10u 0 inz
     d i               s              5i 0
     d rc              s             10i 0
     d lastUser        s             10

      /free
       lr_OpCode = OK;
       lr_DocID = DocID;
       lr_ImgSeqNbr = 0;
       lr_Buffer = *null;
       lr_Length = 0;
       rrn1 = 0;
       sfldlt = '1';
       sfldsp = '0';
       write ctl01;
       sfldlt = '0';
       if docId = ' ';
         return;
       endif;
       dow GetLogData(%addr(LogRqst)) = OK;
         bp = 0;
         clear inputHDR;
         parseBuf(GETLV:%addr(i_UserID):lr_Buffer:bp:%size(i_UserID));
         userID = i_UserID;
         parseBuf(GET:%addr(i_Block01):lr_Buffer:bp:%size(i_Block01));
         parseBuf(GETLV:%addr(i_NodeID):lr_Buffer:bp:%size(i_NodeID));
         parseBuf(GETLV:%addr(i_Comment):lr_Buffer:bp:%size(i_Comment));
         parseBuf(GETLV:%addr(i_Date):lr_Buffer:bp:%size(i_Date));
         parseBuf(GETLV:%addr(i_Time):lr_Buffer:bp:%size(i_Time));
         parseBuf(GET:%addr(i_DtlCnt):lr_Buffer:bp:%size(i_DtlCnt));
         DateTime = %editw(i_DateTime:'    -  -  &  :  :  ');
         Operation = getMsgTxt('ALO':i_OpCode);
         imgSeq = i_imgSeq;
         lnkSeq = i_lnkSeq;
         if i_DtlCnt > 0;
           for i = 1 to i_DtlCnt;
             clear inputDTL;
             parseBuf(GET:%addr(i_Type):lr_Buffer:bp:%size(i_Type));
             parseBuf(GETLV:%addr(i_ValueName):lr_Buffer:bp:%size(i_ValueName));
             parseBuf(GETLV:%addr(i_Value):lr_Buffer:bp:%size(i_Value));
             DetailLine = %trim(getMsgTxt('ALD':i_Type)) + ' ' +
               %trim(i_ValueName) +  ' ' + %trim(i_Value);
             exsr writeSFL01;
             DateTime = ' ';
             imgSeq = 0;
             lnkSeq = 0;
             Operation = ' ';
             userID = ' ';
           endfor;
         else;
           exsr writeSFL01;
         endif;
       enddo;
       lr_OpCode = SHUTDOWN;
       GetLogData(%addr(LogRqst));

       if rrn1 > 0;
         rrn1 = 1;
         sfldsp = '1';
       endif;

       return;
       //*******************************************************************
       begsr writeSFL01;
         rrn1 = rrn1 + 1;
         write sfl01;
       endsr;

      /end-free
     p                 e

      *********************************************************************
     p parseBuf        b

     d                 pi
     d opcode                         5i 0 const
     d targetP                         *   value
     d sourceP                         *
     d bufPos                        10u 0
     d targetLen                     10i 0 value

     d lvLen           s             10u 0

      /free
       if opcode = GETLV;
         memcpy(%addr(lvLen):sourceP+bufPos:%size(lvLen));
         bufPos = bufPos + %size(lvLen);
         if lvLen < targetLen;
           targetLen = lvLen;
         endif;
       endif;
       memcpy(targetP:sourceP+bufPos:targetLen);
       bufPos = bufPos + targetLen;
       return;
      /end-free
     p                 e

      *******************************************************************
     p getMsgTxt       b

     d                 pi            80
     d msgPfx                         3    const
     d msgNbr                        10i 0 const

     d rtvm0100        ds           255
     d  lenMsgRtn                    10i 0 overlay(rtvm0100:9)
     d  message                      80    overlay(rtvm0100:25)
     d lenMsgInf       s             10i 0 inz(%size(rtvm0100))
     d fmtName         s              8    inz('RTVM0100')
     d msgf            s             20    inz('PSCON     *LIBL     ')
     d replaceData     s              1    inz
     d lenRplcData     s             10i 0 inz
     d substitute      s             10    inz('*NO')
     d rtnFmtCtl       s             10    inz('*NO')

     c                   eval      msgid = msgPfx +
     c                             %subst(%editc(msgNbr:'X'):7:4)
     c                   call      'QMHRTVM'
     c                   parm                    rtvm0100
     c                   parm                    lenMsgInf
     C                   PARM                    fmtName
     C                   PARM                    msgID             7
     C                   PARM                    msgf
     C                   PARM                    replaceData
     C                   PARM                    lenRplcData
     C                   PARM                    substitute
     C                   PARM                    rtnFmtCtl
     C                   PARM                    qusec

     c                   if        qusbavl > 0
     c                   return    '*ERR'
     c                   endif

     c                   return    %subst(message:1:lenMsgRtn)

     p                 e

      *%METADATA                                                       *
      * %TEXT Test for long message truncation in display files        *
      *%EMETADATA                                                      *
     h dftactgrp(*no)
     fqafdmbrl  if   e             disk
     fqsysprt   o    f  132        printer oflind(*in01)

     d/copy @ifsio

     d conv            pr                  extpgm('SPYCDPAG')
     d  frCCSID                       5
     d  toCCSID                       5
     d  input                       256
     d  output                      256
     d frCCSID         s              5    inz('00037')
     d toCCSID         s              5    inz('00819')
     d frTbl           s            256
     d toTbl           s            256

     d cmd             pr                  extpgm('QCMDEXC')
     d  cmdstr                      256    const options(*varsize)
     d  cmdlen                       15  5 const
     d cmdStr          s            256

     d rtvmsg          pr                  extpgm('RTVMSGCL')
     d  msgid                         7
     d  msgf                         10    const
     d  msgfLib                      10
     d  msgLvl1                     132
     d  msgLvl2                    3000
     d  msgLen                        5  0
     d  msgErr                        1
     d msgErr          s              1

     d fclose          pr                  extproc('close')
     d  fileHandle                   10i 0 value

     d fwrite          PR            10i 0 extproc('write')
     d  fildes                       10i 0 value
     d  buf                       32767a   options(*varsize)
     d  nbyte                        10u 0 value

     d fldnam          s             10
     d fldlen          s             10i 0
     d msgid           s              7
     d msgLvl1         s            132
     d msgLvl2         s           3000
     d msglen          s              5  0

     d top             s               *
     d overFlowDS      ds                  based(oPtr)
     d  oMsgId                        7
     d  oLvlOne                     132
     d  oLvlTwo                    3000
     d  oMaxSize                      5i 0
     d  oDspFile                     10
     d  oNext                          *

     d sq              c                   ''''
     d tab             c                   x'05'
     d CR              c                   x'0d'
     d LF              c                   x'25'
     d sqlStmt         s            512
     d msgStr          s             80
     d dateTime        s               z
     d oflag           s             10i 0
     d mode            s             10u 0
     d fh              s             10i 0
     d rc              s             10u 0
     d iBuf            s           3142
     d oBuf            s           3142

     c     *entry        plist
     c                   parm                    msgf             10
     c                   parm                    msgflib          10
     c                   parm                    path            256

      /free
       *in01 = '1';
       read qafdmbrl;
       dow not %eof;
         cmdstr = 'ovrdbf mbr ' + %trim(mllib) +
           '/' + %trim(mlfile) + ' ' + %trim(mlname);
         cmd(cmdstr:%len(%trim(cmdstr)));
         if %error;
           *inlr = '1';
           return;
         endif;
         sqlStmt = 'select substr(srcdta,19,10), cast(substr(srcdta,33,2) as ' +
           'int), case substr(srcdta,54,1) when ' + sq + ' ' + sq + ' then ' +
           'substr(srcdta,51,3)||substr(srcdta,55,4) else substr(srcdta,51,7) '+
           'end from mbr where substr(srcdta,45,6) = ' + sq + 'MSGID(' + sq +
           'and substr(srcdta,7,1) <> ' + sq + '*' + sq;
         exec sql prepare stmt from :sqlStmt;
         exec sql declare csr01 scroll cursor for stmt;
         exec sql open csr01;
         dow sqlcod = 0;
           exec sql fetch next from csr01 into :fldnam, :fldlen, :msgid;
             dow fldnam = ' ' and sqlcod = 0;
               exec sql fetch prior from csr01 into :fldnam, :fldlen;
             enddo;
           if sqlcod = 0;
             rtvmsg(msgid:msgf:msgfLib:msgLvl1:msgLvl2:msgLen:msgErr);
             select;
               when msgerr = '1';
                 if *in01;
                   *in01 = '0';
                   dateTime = %timestamp;
                   except header;
                 endif;
                 except detail;
               // when msgerr = ' ' and msglen > fldlen;
               when msgerr = ' ';
                 exsr msgOverFlow;
             endsl;
           endif;
         enddo;
         exec sql close csr01;
         callp cmd('dltovr mbr':10);
         read qafdmbrl;
       enddo;

       if top <> *null;
         path = %trim(path) + x'00';
         oflag = O_WRONLY + O_CREAT + O_TRUNC + O_CODEPAGE;
         mode =  S_IRWXU;
         conv(frCCSID:toCCSID:frTbl:toTbl);
         fh = open(path:oflag:mode:1252);
         ibuf = 'msgid' + tab + 'msgtxt' + tab + 'maxlen' + tab + 'english' +
           tab + 'display_file' + CR + LF;
         oBuf = %xlate(frTbl:toTbl:iBuf);
         fwrite(fh:oBuf:%len(%trim(iBuf)));
         oPtr = top;
         dow oPtr <> *null;
           msgID = oMsgID;
           rtvmsg(msgID:'PSCON':msgfLib:msgLvl1:msgLvl2:msgLen:msgErr);
           if msgLen <= oMaxSize;
             iBuf = %trim(oMsgId) + tab + %trimr(oLvlOne) + tab +
               %trim(%editc(oMaxSize:'Z')) + tab + %trimr(msgLvl1) + tab +
               %trim(oDspFile) + CR + LF;
             oBuf = %xlate(frTbl:toTbl:iBuf);
             fwrite(fh:oBuf:%len(%trim(iBuf)));
           endif;
           oPtr = oNext;
         enddo;
         fclose(fh);
         oPtr = top;
         dealloc oPtr;
       endif;

       *inlr = '1';
      /end-free

      **************************************************************************
     c     msgOverFlow   begsr

     c                   if        top = *null
     c                   eval      oPtr = %alloc(%size(overFlowDS))
     c                   eval      top = oPtr
     c                   exsr      setPtrDta
     c                   leavesr
     c                   endif

     c                   eval      oPtr = top
     c                   dow       oNext <> *null
     c                   if        msgID = oMsgId
     c                   if        fldlen < oMaxSize
     c                   eval      oMaxSize = fldLen
     c                   endif
     c                   leavesr
     c                   endif
     c                   eval      oPtr = oNext
     c                   enddo
     c                   exsr      setPtrDta

     c                   endsr

      **************************************************************************
     c     setPtrDta     begsr

     c                   eval      oMsgId = msgId
     c                   eval      oLvlOne = msgLvl1
     c                   eval      oLvlTwo = msgLvl2
     c                   eval      oMaxSize = fldLen
     c                   eval      oDspFile = mlname
     c                   eval      oNext = %alloc(%size(overFlowDS))
     c                   eval      oPtr = oNext
     c                   clear                   overFlowDS

     c                   endsr
      **************************************************************************
     oqsysprt   e            header            1
     o                       dateTime
     o
     o                                           49 'Long Message Exceptions'
     o                                           75 'Page'
     o                       page          z     80
     o          e            header      1  2
     o                                              'Source File: '
     o                       mlfile
     o                                              ' Source File Lib: '
     o                       mllib
     o          e            header      1  0
     o                                              'DSPF      FIELD      MSGID'
     o          e            header         1
     o                                              '__________________________'
     o          e            detail         1
     o                       mlname
     o                                              ' '
     o                       fldnam
     o                                              ' '
     o                       msgid

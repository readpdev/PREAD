     h dftactgrp(*no) bnddir('QC2LE')

      /copy qsysinc/qrpglesrc,qezrtbkh
      /copy qsysinc/qrpglesrc,qusec

     d SUNDAY          c                   1

     d dow             pr            10i 0

     d sq              c                   ''''

     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         256    const
     d  cmdLen                       15  5 const
     d cmd             s            256

     d rtvBackupHist   pr                  extpgm('QEZRTBKH')
     d  receiver                           like(backupList)
     d  length                       10i 0 const
     d  format                        8    const
     d  errorStruct                        like(qusec)

     d prepDclOpen     pr

     d backupList      ds                  likeds(QEZH0100)
     d error           ds                  likeds(qusec)
     d backupName      s             15
     d x               s              2s 0
     d backupSet       s              4
     d ftpCodes        s              4    dim(18) perrcd(18) ctdata
     d ftpCode         s              4
     d i               s              5i 0
     d count           s             10i 0

     d                sds
     d curusr                254    263

      /free
       clear error;
       error.qusbprv = %size(qusec);
       rtvBackupHist(backupList:%size(backupList):'RBKH0100':error);
       backupName = 'BU' + backupList.QEZCDBD;
       backupSet = backupList.QEZCDTS;
       if dow() = SUNDAY;
         backupName = 'BU' + backupList.QEZDBD;
         backupSet = backupList.QEZDTS;
       endif;
       cmd = 'ftpjob/ftpjob server(' + sq + '192.168.89.14' + sq +
         ') userid(ftp) password(ftp) outputmbr(backup/log/' +
         %trim(backupName) + ') ftpcmds(' +
         sq + 'cd DEVi5' + sq + ' ' +
         sq + 'bin ' + sq + ' ' +
         sq + 'prompt off' + sq + ' ' +
         sq + 'locsite namefmt 1' + sq + ' ' +
         sq + 'mput /backup/' + %trim(backupSet) + '*' + sq + ' ' +
         sq + 'quit' + sq + ')';
       run(cmd:%len(%trim(cmd)));
       // Check ftp log file (output) for error conditions.
       cmd = 'ovrdbf ftplog backup/' + %trim(backupName) +' ovrscope(*job)';
       run(cmd:%len(%trim(cmd)));
       for i = 1 to %elem(ftpCodes);
         ftpCode = ftpCodes(i);
         exec sql select count(*) into :count from ftplog
           where substr(srcdta,1,4) = :ftpCode or
           lcase(substr(srcdta,1,16)) like '%cannot find host%';
         if count > 0;
           leave;
         endif;
       endfor;
       run('dltovr ftplog lvl(*job)':23);
       if sqlcod = 0 and count = 0;
         for x = 1 to 5;
           cmd = 'inztap dev(tapvrt01) vol(' + %trim(backupSet) +
             %editc(x:'X') + ') newvol(' + %trim(backupSet) +
             %editc(x:'X') + ') check(*no) clear(*yes)';
           run(cmd:%len(%trim(cmd)));
         endfor;
       else;
         cmd = 'SNDMSG MSG(' + sq + 'Error sending backup. Log: BACKUP/' +
           %trim(backupName) + sq + ') TOUSR(' + %trim(curusr) + ')';
         run(cmd:%len(%trim(cmd)));
         cmd = 'SNDMSG MSG(' + sq + 'Error sending backup. Log: BACKUP/' +
           %trim(backupName) + sq + ') TOUSR(*SYSOPR)';
         run(cmd:%len(%trim(cmd)));
         eval *inh1 = '1'; //Forces job failure message.
       endif;
       *inlr = '1';
       return;
      /end-free

      **********************************************************************
      * Returns day of week integer starting with 1 as Sunday.
      **********************************************************************
     p dow             b
     d                 pi            10i 0

     d lillianDate     s             10i 0
     d dowRtn          s             10i 0
     d isoDate         s              8

     d ceedays         pr                  opdesc
     d  isodate                       8    options(*varsize)
     d  format                        8    const
     d  lillianDate                  10i 0
     d  fc                           12

      * Retrieve day of week code.
     d ceedywk         pr                  opdesc
     d  lillianDate                  10i 0
     d  dow                          10i 0
     d  fc                           12

      * Feedback code.
     d fc              ds
     d  fcMsgSev                      5u 0
     d  fcMsgNo                       5u 0
     d  fcFlags                       1
     d  fcFacID                       3
     d  fcISI                        10u 0

      /free
       isodate = %char(%date():*iso0);
       // Convert iso date format to lillian date format.
       ceedays(isodate:'YYYYMMDD':lillianDate:fc);
       // Retrieve day of week from lillian date.
       ceedywk(lillianDate:dowRtn:fc);
       return dowRtn;
      /end-free
     p                 e
**ctdata ftpcodes
421 425 426 450 451 452 500 501 502 503 504 540 530 532 550 551 552 553

     h dftactgrp(*no) bnddir('QC2LE')

      /copy qsysinc/qrpglesrc,qezrtbkh
      /copy qsysinc/qrpglesrc,qusec

     d SUNDAY          c                   1

     d dow             pr            10i 0

     d sq              c                   ''''

     d run             pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d rtvBackupHist   pr                  extpgm('QEZRTBKH')
     d  receiver                           like(backupList)
     d  length                       10i 0 const
     d  format                        8    const
     d  errorStruct                        like(qusec)

     d prepDclOpen     pr

     d sprintf         pr            10i 0 extproc('sprintf')
     d  target                         *   value options(*string)
     d  source                         *   value options(*string)
     d  value1                         *   value options(*string)
     d  value2                         *   value options(*string:*nopass)
     d  value3                         *   value options(*string:*nopass)
     d  value4                         *   value options(*string:*nopass)
     d  value5                         *   value options(*string:*nopass)

     d backupList      ds                  likeds(QEZH0100)
     d error           ds                  likeds(qusec)
     d backupSet       s              4
     d x               s              2s 0
     d i               s              5i 0
     d count           s             10i 0
     d volNam          s              6
     d OK              c                   0

     d                sds
     d curusr                254    263

      /free
       clear error;
       error.qusbprv = %size(qusec);
       rtvBackupHist(backupList:%size(backupList):'RBKH0100':error);
       backupSet = backupList.QEZLCLTS;
       if dow() = SUNDAY;
         backupSet = backupList.QEZAULTS;
       endif;
       run('mkdir ' + sq + '/qntc/otirvfs01' + sq);
       if run ('QSH CMD(' + sq + 'cp /backup/' + %trimr(backupSet) + '* ' +
         '/qntc/otirvfs01/pread/devsysi1' + sq + ')') = OK;
         // If successful transfer, unmount (load) each volume and resize to
         // reclaim space.
         for x = 1 to 6;
           volNam = %trim(backupSet) + %editc(x:'X');
           run('inztap dev(tapvrt01) newvol(' + volNam + ') vol(' + volNam +
             ') check(*no)');
           run('lodimgclge imgclg(backup) imgclgidx(*vol) option(*load) ' +
             'vol(' + volNam + ')');
           run('chgimgclge imgclg(backup) imgclgidx(*vol) vol(' + volNam +
             ') alcstg(*min)');
         endfor;
       else;
         run('SNDMSG MSG(' + sq + 'Error sending backup.' +
           ') TOUSR(' + %trim(curusr) + ')');
         run('SNDMSG MSG(' + sq + 'Error sending backup.) ' +
           'TOUSR(*SYSOPR)');
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

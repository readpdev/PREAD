      *%METADATA                                                       *
      * %TEXT Temp SAVF Backup Utility                                 *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*new)

      *
      * 05-12-15 PLR Temporary save file based backup utility. Will backup
      *              entire library as listed in data areas.
      *

     fsavfbackupIF   e             DISK    rename(savfbackup:savrec)

     d system          pr                  extproc('system')
     d  command                        *   value options(*string:*trim)

     d rsv             PR            10
     d  valuename                    10A   const

     d cmd             s            512
     d dayofweek       s             10
     d todayISO        s              8
     d dailyBackup     s               n   inz(*off)
     d weeklyBackup    s               n   inz(*off)
     d sq              c                   ''''


      /free
       *inlr = *on;

       dayofweek = rsv('QDAYOFWEEK');
       system('crtlib tempbackup');
       todayISO = %char(%date():*ISO);

       read savfbackup;
       dow not %eof;

         if (daily = 'Y' and dayofweek <> '*SAT' and dayofweek <> '*SUN');
           dailyBackup = *on;
         endif;
         if (weekly = 'Y' and (dayofweek = '*SAT' or dayofweek = '*SUN'));
           weeklyBackup = *on;
         endif;

         if dailyBackup or weeklyBackup;
           system('crtsavf tempbackup/' + %trim(library));
           system('SAVLIB DEV(*SAVF) SAVACT(*LIB) DTACPR(*MEDIUM) LIB(' +
             %trim(library) + 'SAVF(TEMPBACKUP/' + %trim(library) + ')');
         endif;

         read savfbackup;

       enddo;

       cmd = 'FTPJOB/FTPJOB SERVER(OTIRVNAS01) USERID(ftp) ' +
         'OUTPUTMBR(FTPJOB/FTPLOG/FTPLOG) RPLCLOG(Y) JOBQ(*NONE) ' +
         'FTPCMDS(bin ' + sq + 'cd /backup/IBM_i/lsais03/tempbackup';

       if dailyBackup;
         cmd = %trimr(cmd) + sq + 'cd daily' + sq;
       endif;

       if weeklyBackup;
         cmd = %trimr(cmd) + sq + 'cd weekly' + sq;
       endif;

       cmd = %trimr(cmd) + ' ' + sq + 'mkdir ' + todayISO + sq;

       cmd = %trimr(cmd) + ' ' + sq + ' cd ' + todayISO + sq;

       cmd = %trimr(cmd) + sq + ' mput tempbackup/*';

       system(cmd);

       return;

      /end-free

      **************************************************************************
     p rsv             b
     d rsv             pi            10
     d  valuename                    10A   const

     d getSysVal       pr                  extpgm('QWCRSVAL')
     d  receiver                           like(sysvalrcv)
     d  length                             like(sysvallen)
     d  vals2rtn                           like(val2rtn)
     d  valueRtn                           like(sysvalrtn)
     d  error                              likeds(apierr)

     d                 ds
     d sysvalrcv                    128
     d  offset                       10i 0 overlay(sysvalrcv:5)

     d                 ds
     d  lendta                       10i 0 inz
     d   lendta_c                     4    overlay(lendta:1)

     d sysvalrtn       s             10

     d sysvallen       s             10i 0 inz(128)
     d val2rtn         s             10i 0 inz(1)

     d apierr          ds
     d  erbytprv                     10i 0 inz(%size(apierr))
     d  erbytavl                     10i 0
     d  ermsgid                       7a
     d  errsv1                        1a
     d  ermsgdata                    80a

      /free

       reset sysvalrcv;
       getSysVal(sysvalrcv:sysvallen:val2rtn:sysvalrtn:apierr);
       if ermsgid <> ' ';
         return ' ';
       endif;

       offset = offset + 13;
       lendta_c = %subst(sysvalrcv:offset:4);
       offset = offset + 4;
       sysvalrtn = %subst(sysvalrcv:offset:lendta);
       sysvalrtn = %trim(sysvalrtn);

       if ermsgid = ' ';
         return sysvalrtn;
       endif;

      /end-free
     p rsv             e


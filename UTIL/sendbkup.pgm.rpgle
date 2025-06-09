      *
      * 04-16-12 PLR Moved backups to USB drive connected to the NAS device
      *              OTIRVNAS01.
3347  * 05-23-11 EPG Original code written by PLR. Enhanced this version to
      *              to use the open source library LIBFTP to automate the
      *              transfer of files to the external hard drive using the
      *              low level FTP calls wrapped in the service program found
      *              in the binding directory, LIBFTP/FTPAPI.
      *
3347 h dftactgrp(*no) bnddir('QC2LE':'LIBFTP/FTPAPI')
3347  /copy libftp/qrpglesrc,ftpapi_h
      /copy libftp/qrpglesrc,ifsio_h
      /copy qsysinc/qrpglesrc,qezrtbkh
      /copy qsysinc/qrpglesrc,qusec

     d SUNDAY          c                   1
     d SATURDAY        c                   7

J3347d LoadBackupArray...
/    d                 pr

     d doweek          pr            10i 0

     d sq              c                   ''''

     d run             pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d rtvBackupHist   pr                  extpgm('QEZRTBKH')
     d  receiver                           like(backupList)
     d  length                       10i 0 const
     d  format                        8    const
     d  errorStruct                        like(qusec)


     d sprintf         pr            10i 0 extproc('sprintf')
     d  target                         *   value options(*string)
     d  source                         *   value options(*string)
     d  value1                         *   value options(*string)
     d  value2                         *   value options(*string:*nopass)
     d  value3                         *   value options(*string:*nopass)
     d  value4                         *   value options(*string:*nopass)
     d  value5                         *   value options(*string:*nopass)

     d SendBkup        pr                  ExtPgm('SENDBKUP')
     d  aTgtPath                    128a

     d SendBkup        pi
     d  aTgtPath                    128a

     d Q               c                   x'7d'
     d MAXFILES        c                   1024
     d backupList      ds                  likeds(QEZH0100)
     d error           ds                  likeds(qusec)

J3347d aryBackupSet    s            256a   dim(MAXFILES)
/    d intTop          s             10i 0 inz(0)

     d backupSet       s              4
     d x               s              2s 0
     d i               s              5i 0
     d volNam          s              6
     d sess            s             10i 0
     d strSrcPath      s            128a   inz('/Backup')
      * FTP Session
     d strMsg          s            128a
     d strCmd          s            128a
     d strSrcPathFile  s            256a
     d strTgtPathFile  s            256a
     d OK              c                   0


     d ftpconnds       ds                  qualified
     d  domain                      128a   inz('OTIRVNAS01')
     d  user                        128a   inz('anonymous')
     d  pass                        128a   inz('anonymous@opentext.com')

      /free
J3347  *inlr = *on;
       clear error;
       error.qusbprv = %size(qusec);
       rtvBackupHist( backupList : %size(backupList) : 'RBKH0100' :error);
       backupSet = backupList.QEZLCLTS;

       if doweek() = SUNDAY;
         backupSet = backupList.QEZLULTS;
       endif;

       if backupSet = ' ';
         return;
       endif;

J3347  Callp(e) LoadBackupArray();
/
/      // Log the FTP session to the job log
/
/      Callp(e) ftp_logging(0:*on);

J3347  sess = ftp_conn( %trimr(ftpconnds.domain)
/                     : %trimr(ftpconnds.user)
/                     : %trimr(ftpconnds.pass) );
/
/      if ( sess < 0 );
/        run('SNDMSG MSG(' + Q + %trim(FTP_errorMsg(0)) + Q + ') ' +
/          'TOUSR(*SYSOPR)');
/          ftp_quit(sess);
/        Return;
/      EndIf;
/
/      ftp_binaryMode(sess : *on);
/
/      // Change the name format to 1
/
/      // ftp_Namfmt( sess : 1 );
/
/      For i = 1 to intTop;
/
/        // Place qualified file to target directory
/
/        strSrcPathFile = '/backup/' +  %trim( aryBackupSet( i ) );
         strTgtPathFile =  %trim(aTgtPath);
         strTgtPathFile =  %trim(strTgtPathFile) + %trim( aryBackupSet( i ) );

/        If ( ftp_put( sess
                     : strTgtPathFile
/                    : strSrcPathFile ) < 0 );
/          strMsg = FTP_errorMsg(sess);
           strCmd = 'SNDMSG MSG(' + Q + %trim(strMsg) + Q + ') ' +
                    'TOUSR(*SYSOPR)';
/          run(%trim(strCmd));
/          ftp_quit(sess);
/          Return;
/        EndIf;
/
/      EndFor;

/      ftp_quit(sess);

       // run('MOUNT TYPE(*NFS) MFS(' + sq + '192.168.89.130:/IBMiBackups' + sq
       //  ') MNTOVRDIR(' + sq + '/rmtbackup' + sq + ')');
       // if run ('QSH CMD(' + sq + 'cp /backup/' + %trimr(backupSet) + '* ' +
       //  '/rmtbackup/devsysi2' + sq + ')') = OK;
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
       return;
      /end-free

J3347p LoadBackupArray...
/    p                 b
/    d dir             s               *
/    d strDirFile      s            128a
/     /free
/      dir = OpenDir(%trimr( strSrcPath ) );
/
/      If dir = *null;
/        Return;
/      Else;
/        p_dirent = readdir(dir);
/
/        Dow ( p_dirent <> *null );
/          strDirFile = %subst( d_name : 1 : d_namelen );

/          If ( %subst(strDirFile:1:%len(%trim( BackupSet)))  =  BackUpSet );
/            intTop += 1;
/            aryBackupSet( intTop ) = strDirFile;
/          EndIf;
/
/          p_dirent = readdir(dir);
/        EndDo;
/
/      EndIf;
/     /end-free
J3347p LoadBackupArray...
     p                 e
      **********************************************************************
      * Returns day of week integer starting with 1 as Sunday.
      **********************************************************************
     p doweek          b
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
     p doweek          e

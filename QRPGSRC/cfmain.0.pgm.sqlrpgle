      * CRTOPT COMMIT(*NONE)
     h dftactgrp(*no) actgrp('CLRFLD') bnddir('DMBNDDIR':'QC2LE':'QUSAPIBD')
      * ---------------------------------------------------------------------- *
      * Clear Folder tool
      * ---------------------------------------------------------------------- *
J2078 * 11-04-09 PLR While adapting for use in v6r1, it was noticed during
      *              testing that the select statement was not formatted
      *              correctly and would never have worked when specifying a
      *              folder name.
???   /define  VERBOSE_LOG
      *define  HALT_ON_DELETE_ERROR
      *define  DEBUG_NO_DELETE_RPT
      *define  DEBUG_NO_DELETE_BAT

     d mrptdirDS     e ds                  extname(mrptdir) inz
     d mimgdirDS     e ds                  extname(mimgdir) inz

     d/copy dmmmisc
     d/copy dmssupp
     d/copy dmsysdft
     d/copy pxmmisc
     d/copy pxmpctl
     d/copy pxmplog
     d/copy pxmsql
     d/copy pxssupp
     d/copy @PGMSTSDS

     d OK              c                   0
     d FAIL            c                   -1

     d DeleteReports...
     d                 pr            10i 0
     d DeleteBatches...
     d                 pr            10i 0
     d DeleteReport...
     d                 pr            10i 0
     d DeleteBatch...
     d                 pr            10i 0
     d StopCheck...
     d                 pr            10i 0
     d LogSQLmsg...
     d                 pr
     d ErrCode                       10i 0 value
     d ErrData                      128    value
     d ErrDataLen                    10i 0 value
     d SetError...
     d                 pr            10i 0

     d LckFolder...
     d                 pr            10i 0
     d Folder                        10    value
     d FolderLib                     10    value

     d RlsFolder...
     d                 pr            10i 0
     d Folder                        10    value
     d FolderLib                     10    value

      * process control
     d ProcAppId       c                   'CLRFLD'
     d EndProcess      s               n
     d ErrorProcess    s               n

     d LckFolderName   s             10
     d LckFolderLib    s             10

      * totals counters
     d RptSelected     s             10i 0
     d RptDeleted      s             10i 0
     d RptErrors       s             10i 0
     d BatSelected     s             10i 0
     d BatDeleted      s             10i 0
     d BatErrors       s             10i 0

     d Folder          ds
     d FolderName                    10
     d FolderLib                     10

      * ---------------------------------------------------------------------- *
      * mainline
      * ---------------------------------------------------------------------- *

     C/EXEC SQL
     C+ set option closqlcsr=*endmod,commit=*none
     C/END-EXEC

     c     *entry        plist
     c                   parm                    Folder           20

     c                   if        FolderName = *blanks
     c                   eval      FolderName = '*ALL'
     c                   end
     c                   if        FolderLib = *blanks
     c                   eval      FolderLib = '*ALL'
     c                   end

     c                   callp     LogProcessMsg('Starting Clear Folder +
     c                                            tool...')

      * check DocManager library
     c                   callp     LogProcessMsg(' ')
     c                   in        sysdft                               99
     c                   if        *in99
     c                   callp     LogProcessMsg('*ERROR* +
     c                                            DocManager program library +
     c                                            not in the library list.'
     c                                          :'E':*blanks:@Pgm)
     c                   eval      ErrorProcess = *on
     c                   eval      EndProcess = *on
     c                   else
     c                   callp     LogProcessMsg('DocManager +
     c                                program library: '+ sd_PgmLib)
     c                   callp     LogProcessMsg('DocManager +
     c                                data library . : '+ sd_DtaLib)
     c                   end

      * selections
     c                   callp     LogProcessMsg(' ')
     c                   callp     LogProcessMsg('Selections:')
     c                   select
     c                   when      FolderName = '*ALL' and
     c                             FolderLib  = '*ALL'
     c                   callp     LogProcessMsg('     All folders')
     c                   other
     c                   callp     LogProcessMsg('     +
     c                                            Folder: ' + FolderName)
     c                   callp     LogProcessMsg('     +
     c                                           Library: ' + FolderLib)
     c                   endsl

      * process reports
     c                   if        not EndProcess
     c                   callp     LogProcessMsg(' ')
     c                   callp     LogProcessMsg('Deleting Reports...')
     c                   callp     DeleteReports
     c                   if        RptSelected = 0
     c                   callp     LogProcessMsg('No reports selected.')
     c                   end
     c                   end
      * process batches
     c                   if        not EndProcess
     c                   callp     LogProcessMsg(' ')
     c                   callp     LogProcessMsg('Deleting Batches...')
     c                   callp     DeleteBatches
     c                   if        BatSelected = 0
     c                   callp     LogProcessMsg('No batches selected.')
     c                   end
     c                   end

      * results
     c                   callp     LogProcessMsg(' ')
     c                   callp     LogProcessMsg('Totals this run:')
     c                   callp     LogProcessMsg(%editc(RptDeleted:'3')
     c                                        + ' reports deleted.')
     c                   if        RptErrors > 0
     c                   callp     LogProcessMsg(%editc(RptErrors:'3')
     c                                        + ' reports not deleted.')
     c                   end
     c                   callp     LogProcessMsg(%editc(BatDeleted:'3')
     c                                        + ' batches deleted.')
     c                   if        BatErrors > 0
     c                   callp     LogProcessMsg(%editc(BatErrors:'3')
     c                                        + ' batches not deleted.')
     c                   end
      * final status
     c                   callp     LogProcessMsg(' ')
     c                   if        ErrorProcess
     c                   callp     LogProcessMsg('*** Errors occured while +
     c                                            processing ***')
     c                   else
     c                   callp     LogProcessMsg('Processing +
     c                                            completed normally.')
     c                   end

     c                   exsr      $exit
      * ---------------------------------------------------------------------- *
      * program exit
      * ---------------------------------------------------------------------- *
     c     $exit         begsr
     c                   callp     CloseProcessLog
     c                   call      'CFLOG'                              99
     c                   callp     RlsProcessLock(ProcAppId)
     c                   callp     ShutdownDMSSUPP
     c                   callp     ShutdownPXSSUPP
     c                   callp     dmsRestoreLibl
     c                   eval      *inlr = *on
     c                   return
     c                   endsr
      * ---------------------------------------------------------------------- *
      * program error handler
      * ---------------------------------------------------------------------- *
     c     *pssr         begsr
     c                   if        PssrOnce <> *on
     c                   move      *on           PssrOnce          1
     c                   callp     SetError
     c                   callp     SndMsg('Unexpected error occurred.')
     c                   callp     LogProcessMsg('Program ended abnormally.'
     c                                          :'E':*blanks:@Pgm)
     c                   callp     RlsProcessLock(ProcAppId)
     c                   callp     dmsRestoreLibl
     c                   end
     c                   eval      *inlr = *on
     c                   return
     c                   endsr
      * ---------------------------------------------------------------------- *
      * program initialization
      * ---------------------------------------------------------------------- *
     c     *inzsr        begsr

      * add needed libraries to the library list
     c                   callp     dmsSetupLibl

      * lock process queue (allow only 1 job to run)
     c                   if        OK <> GetProcessLock(ProcAppId)
     c                   callp     SndMsg('Clear Folder tool +
     c                                     is already active.')
     c                   exsr      $exit
     c                   end
     c                   callp     ClearProcessLog(ProcAppId)
     c                   callp     OpenProcessLog(ProcAppId)

     c                   endsr
      * ---------------------------------------------------------------------- *
     p DeleteReports...
     p                 b
     d                 pi            10i 0

J2078d sqlStmt         s           1024    varying

      /if defined( DEBUG_NO_DELETE_RPT )
     c                   callp     LogProcessMsg('*DEBUG ON* +
     c                                Reports will not be deleted.')
      /endif

      * find reports by folder
J2078c                   eval      sqlStmt = 'SELECT +
     c                               repind, fldr, fldrlb, +
     c                               filnam, jobnam, usrnam, jobnum, filnum +
     c                              FROM mrptdir'

     c                   if        FolderName <> '*ALL' or
     c                             FolderLib <> '*ALL'
J2078c                   eval      sqlStmt = %trimr(sqlStmt) + ' WHERE'
     c                   end

     c                   if        FolderName <> '*ALL'
     c                   if        0 < %scan('*':FolderName)
     c     '*':'%'       xlate     FolderName    FolderName
J2078c                   eval      sqlStmt = %trimr(sqlStmt) +
/    c                               ' fldr like '''+ %trim(FolderName) + ''''
     c                   else
J2078c                   eval      sqlStmt = %trimr(sqlStmt) +
/    c                               ' fldr = '''+ FolderName + ''''
     c                   end
     c                   end

     c                   if        FolderLib <> '*ALL'
     c                   if        0 < %scan('*':FolderLib)
     c     '*':'%'       xlate     FolderLib     FolderLib
J2078 /free
/      if %subst(sqlStmt:%len(%trimr(sqlStmt))-4:5) <> 'WHERE';
/        sqlStmt = %trimr(sqlStmt) + ' and';
/      endif;
/     /end-free
/    c                   eval      sqlStmt = %trimr(sqlStmt) +
/    c                              ' fldrlb like '''+ %trim(FolderLib) + ''''
     c                   else
J2078c                   eval      sqlStmt = %trimr(sqlStmt) +
/    c                              ' fldrlb = '''+ FolderLib + ''''
     c                   end
     c                   end

J2078c                   eval      sqlStmt = %trimr(sqlStmt) + ' ORDER BY +
     c                                ofrvol, fldrlb, fldr, repind'

     C/EXEC SQL
     C+ DECLARE DLTRPTS STATEMENT
     C/END-EXEC
     C/EXEC SQL
     C+ DECLARE DLTRPTC CURSOR FOR DLTRPTS
     C/END-EXEC
     C/EXEC SQL
     C+ PREPARE DLTRPTS FROM :Select
     C/END-EXEC
     C/EXEC SQL
     C+ OPEN DLTRPTC
     C/END-EXEC

     c                   if        SQLcod <> 0
     c                   callp     LogSQLmsg(SQLcod:SQLerm:SQLerl)
     c                   callp     SetError
     c                   else

      * delete all selected reports
     c                   do        *hival
     C/EXEC SQL
     C+ FETCH NEXT FROM DLTRPTC INTO
     C+ :repind, :fldr, :fldrlb,
     C+ :filnam, :jobnam, :usrnam, :jobnum, :filnum
     C/END-EXEC
     c                   if        SQLcod <> 0
     c                   if        SQLcod <> 100                                no rows
     c                   callp     LogSQLmsg(SQLcod:SQLerm:SQLerl)
     c                   callp     SetError
     c                   end
     c                   leave                                                  done
     c                   end
     c                   eval      RptSelected = RptSelected + 1

      * Check for end processing request
     c                   if        0 <> StopCheck
     c                   leave
     c                   end
      * delete the report
     c                   if        OK <> DeleteReport
      /if defined( HALT_ON_DELETE_ERROR )
     c                   leave
      /endif
     c                   end

     c                   enddo
     C/EXEC SQL
     C+ CLOSE DLTRPTC
     C/END-EXEC
     c                   end
     c                   callp     RlsFolder(fldr:fldrlb)
     c                   return    OK
      * --------------- *
     c     *pssr         begsr
     c                   if        PssrOnce <> *on
     c                   move      *on           PssrOnce          1
     c                   callp     SetError
     c                   callp     LogProcessMsg('Error processing +
     c                                            reports.'
     c                                          :'E':*blanks:@Pgm)
     c                   end
     c                   return    FAIL
     c                   endsr
     p                 e
      * ---------------------------------------------------------------------- *
     p DeleteBatches...
     p                 b
     d                 pi            10i 0

     d Select          s           1024    varying

      /if defined( DEBUG_NO_DELETE_BAT )
     c                   callp     LogProcessMsg('*DEBUG ON* +
     c                                Batches will not be deleted.')
      /endif

      * find batches by folder
     c                   eval      Select = 'SELECT +
     c                               idbnum, idfld, idflib, iddoct +
     c                              FROM mimgdir'

     c                   if        FolderName <> '*ALL' or
     c                             FolderLib <> '*ALL'
     c                   eval      Select = Select + ' WHERE'
     c                   end

     c                   if        FolderName <> '*ALL'
     c                   if        0 < %scan('*':FolderName)
     c     '*':'%'       xlate     FolderName    FolderName
     c                   eval      Select = Select + ' and +
     c                                 idfld like '''+ %trim(FolderName) + ''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                          idfld = '''+ FolderName + ''''
     c                   end
     c                   end

     c                   if        FolderLib <> '*ALL'
     c                   if        0 < %scan('*':FolderLib)
     c     '*':'%'       xlate     FolderLib     FolderLib
     c                   eval      Select = Select + ' and +
     c                                idflib like '''+ %trim(FolderLib) + ''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                         idflib = '''+ FolderLib + ''''
     c                   end
     c                   end

     c                   eval      sqlStmt = %trimr(sqlStmt) + ' ORDER BY +
     c                                 idflib, idfld, idbnum'

     C/EXEC SQL
     C+ DECLARE DLTBATS STATEMENT
     C/END-EXEC
     C/EXEC SQL
     C+ DECLARE DLTBATC CURSOR FOR DLTBATS
     C/END-EXEC
     C/EXEC SQL
J2078C+ PREPARE DLTBATS FROM :sqlStmt
     C/END-EXEC
     C/EXEC SQL
     C+ OPEN DLTBATC
     C/END-EXEC

     c                   if        SQLcod <> 0
     c                   callp     LogSQLmsg(SQLcod:SQLerm:SQLerl)
     c                   callp     SetError
     c                   else

      * delete all selected batches
     c                   do        *hival
     C/EXEC SQL
     C+ FETCH NEXT FROM DLTBATC INTO
     C+ :idbnum, :idfld, :idflib, :iddoct
     C/END-EXEC
     c                   if        SQLcod <> 0
     c                   if        SQLcod <> 100                                no rows
     c                   callp     LogSQLmsg(SQLcod:SQLerm:SQLerl)
     c                   callp     SetError
     c                   end
     c                   leave                                                  done
     c                   end
     c                   eval      BatSelected = BatSelected + 1

      * Check for end processing request
     c                   if        0 <> StopCheck
     c                   leave
     c                   end
      * delete the batch
     c                   if        OK <> DeleteBatch
      /if defined( HALT_ON_DELETE_ERROR )
     c                   leave
      /endif
     c                   end

     c                   enddo
     C/EXEC SQL
     C+ CLOSE DLTBATC
     C/END-EXEC
     c                   end
     c                   callp     RlsFolder(idfld:idflib)
     c                   return    OK
      * --------------- *
     c     *pssr         begsr
     c                   if        PssrOnce <> *on
     c                   move      *on           PssrOnce          1
     c                   callp     SetError
     c                   callp     LogProcessMsg('Error processing +
     c                                            batches.'
     c                                          :'E':*blanks:@Pgm)
     c                   end
     c                   return    FAIL
     c                   endsr
     p                 e
      * ---------------------------------------------------------------------- *
     p DeleteReport...
     p                 b
     d                 pi            10i 0

     c                   if        OK <> LckFolder(fldr:fldrlb)
     c                   exsr      *pssr
     c                   end
      * delete report
      /if not defined( DEBUG_NO_DELETE_RPT )
     c                   if        OK <> dmsDeleteReport(repind)
     c                   exsr      *pssr
     c                   end
      /endif
      /if defined( VERBOSE_LOG )
     c                   callp     LogProcessMsg('Report: +
     c                                       FILE( '+ filnam +' ) +
     c                                       SDOI( '+ repind +' ) +
     c                                            has been deleted.')
      /endif
     c                   eval      RptDeleted = RptDeleted + 1
     c                   return    OK
      * --------------- *
     c     *pssr         begsr
     c                   if        PssrOnce <> *on
     c                   move      *on           PssrOnce          1
     c                   callp     SetError
     c                   eval      RptErrors = RptErrors + 1
     c                   callp     LogProcessMsg('Error deleting report +
     c                                      FILE( '+ filnam +' ) +
     c                                      SDOI( '+ repind +' ) +
     c                                          - see JOBLOG for details'
     c                                          :'E':*blanks:@Pgm)
     c                   end
     c                   return    FAIL
     c                   endsr
     p                 e
      * ---------------------------------------------------------------------- *
     p DeleteBatch...
     p                 b
     d                 pi            10i 0

     c                   if        OK <> LckFolder(idfld:idflib)
     c                   exsr      *pssr
     c                   end
      * delete batch (images)
      /if not defined( DEBUG_NO_DELETE_BAT )
     c                   if        OK <> dmsDeleteBatch(idbnum)
     c                   exsr      *pssr
     c                   end
      /endif
      /if defined( VERBOSE_LOG )
     c                   callp     LogProcessMsg('Batch: +
     c                                   DOCTYPE( '+ iddoct +' ) +
     c                                     BATCH( '+ idbnum +' ) +
     c                                            has been deleted.')
      /endif
     c                   eval      BatDeleted = BatDeleted + 1
     c                   return    OK
      * --------------- *
     c     *pssr         begsr
     c                   if        PssrOnce <> *on
     c                   move      *on           PssrOnce          1
     c                   callp     SetError
     c                   eval      BatErrors = BatErrors + 1
     c                   callp     LogProcessMsg('Error deleting +
     c                                   DOCTYPE( '+ iddoct +' ) +
     c                                     BATCH( '+ idbnum +' ) +
     c                                          - see JOBLOG for details'
     c                                          :'E':*blanks:@Pgm)
     c                   end
     c                   return    FAIL
     c                   endsr
     p                 e
      * ---------------------------------------------------------------------- *
     p StopCheck...
     p                 b
     d                 pi            10i 0

     d Request         s            128    varying

      * check for "end process" request
     c                   if        OK <> CheckProcessRequest(ProcAppId
     c                                                      :Request)
     c                   callp     SndMsg('Error on +
     c                                     processing request check.')
     c                   return    FAIL
     c                   end
     c                   if        Request = 'ENDPROCESS'
     c                   eval      EndProcess = *on
     c                   callp     LogProcessMsg('End processing +
     c                                            was requested.')
     c                   return    1
     c                   end
     c                   return    0
      * --------------- *
     c     *pssr         begsr
     c                   callp     SetError
     c                   return    FAIL
     c                   endsr
     p                 e
      * ---------------------------------------------------------------------- *
     p LogSQLmsg...
     p                 b
     d                 pi
     d ErrCode                       10i 0 value
     d ErrData                      128    value
     d ErrDataLen                    10i 0 value

     d MsgData         s            128    varying

     c                   if        ErrDataLen > 0
     c                   eval      MsgData = %subst(ErrData:1:ErrDataLen)
     c                   end
     c                   callp     LogProcessMsgId(GetSQLmsgId(ErrCode):MsgData
     c                                            :'QSQLMSG':'QSYS'
     c                                            :'E':@Pgm)
     p                 e
      * ---------------------------------------------------------------------- *
     p SetError...
     p                 b
     d                 pi            10i 0
     c                   if        not ErrorProcess
     c                   eval      ErrorProcess = *on
     c                   return    Cmd('CHGJOB LOG(4 0 *SECLVL)')
     c                   end
     c                   return    OK
     p                 e
      * ---------------------------------------------------------------------- *
     p LckFolder...
     p                 b
     d                 pi            10i 0
     d Folder                        10    value
     d FolderLib                     10    value

     c                   if        LckFolderName = Folder and
     c                             LckFolderLib  = FolderLib
     c                   return    OK
     c                   end
     c                   callp     RlsFolder(LckFolderName:LckFolderLib)
     c                   if        OK <> Cmd('ALCOBJ OBJ(('+ %trim(FolderLib)
     c                                                 +'/'+ %trim(Folder)
     c                                                +' *FILE *EXCLRD)) +
     c                                               WAIT(0)':1)
     c                   callp     LogProcessMsg('*ERROR* +
     c                                            Folder: '+ %trim(FolderLib)
     c                                                 +'/'+ %trim(Folder)
     c                                                 +' currently in use.'
     c                                          :'E':*blanks:@Pgm)
     c                   return    FAIL
     c                   end
     c                   eval      LckFolderName = Folder
     c                   eval      LckFolderLib = FolderLib
     c                   return    OK
     p                 e
      * ---------------------------------------------------------------------- *
     p RlsFolder...
     p                 b
     d                 pi            10i 0
     d Folder                        10    value
     d FolderLib                     10    value

     c                   if        LckFolderName = *blanks and
     c                             LckFolderLib  = *blanks
     c                   return    OK
     c                   end
     c                   eval      LckFolderName = *blanks
     c                   eval      LckFolderLib = *blanks
     c                   return    Cmd('DLCOBJ OBJ(('+ %trim(FolderLib)
     c                                           +'/'+ %trim(Folder)
     c                                                +' *FILE *EXCLRD))')
     p                 e

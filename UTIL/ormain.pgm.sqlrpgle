      *%METADATA                                                       *
      * %TEXT Optical Restore                                p         *
      *%EMETADATA                                                      *
      * CRTOPT COMMIT(*NONE)
     h dftactgrp(*no) actgrp('OPTRST') bnddir('DMBNDDIR':'QC2LE':'QUSAPIBD')

      *
T6111 * 02-28-07 PLR Was not honoring date range selection criteria.
      *
      * 02-23-07 PLR Added missing spool file creation date parm to
      *              dmRstOptReport. RSTORPT in base product requires the parm
      *              for support of 6 digit spool file numbers. (DATFOP)

      * ---------------------------------------------------------------------- *
      * Optical Restore
      * ---------------------------------------------------------------------- *
???   /define  VERBOSE_LOG
      *define  HALT_ON_RESTORE_ERROR
      *define  DEBUG_NO_RESTORE_RPT
      *define  DEBUG_NO_RESTORE_BAT

     d mrptdirDS     e ds                  extname(mrptdir) inz
     d mimgdirDS     e ds                  extname(mimgdir) inz
     d mopttblDS     e ds                  extname(mopttbl) inz

     d/copy dm@optrst
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

     d OpticalReports...
     d                 pr            10i 0
     d OpticalBatches...
     d                 pr            10i 0
     d RestoreReport...
     d                 pr            10i 0
     d RestoreBatch...
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

     d CvtDate7...
     d                 pr             7  0
     d Date8                          8  0 value

      * process control
     d ProcAppId       c                   'OPTRST'
     d EndProcess      s               n
     d ErrorProcess    s               n

     d LckFolderName   s             10
     d LckFolderLib    s             10

      * totals counters
     d RptSelected     s             10i 0
     d RptRestored     s             10i 0
     d RptErrors       s             10i 0
     d BatSelected     s             10i 0
     d BatRestored     s             10i 0
     d BatErrors       s             10i 0

     d Folder          ds
     d FolderName                    10
     d FolderLib                     10

     d FolderNameX     s                   like(FolderName)
     d FolderLibX      s                   like(FolderLib)
     d DocClassX       s                   like(DocClass)
     d RptTypeX        s                   like(RptType)
     d DateRangeFromX  s              7  0
     d DateRangeThruX  s              7  0

      * ---------------------------------------------------------------------- *
      * mainline
      * ---------------------------------------------------------------------- *

     c     *entry        plist
     c                   parm                    Folder           20
     c                   parm                    DocSelect         1
     c                   parm                    DocClass         10
     c                   parm                    RptType          10
     c                   parm                    DateRangeFrom     8 0
     c                   parm                    DateRangeThru     8 0

     c                   if        FolderName = *blanks
     c                   eval      FolderName = '*ALL'
     c                   end
     c                   if        FolderLib = *blanks
     c                   eval      FolderLib = '*ALL'
     c                   end
     c                   if        DocClass = *blanks
     c                   eval      DocClass = '*ALL'
     c                   end
     c                   if        RptType = *blanks
     c                   eval      RptType = '*ALL'
     c                   end

     c                   callp     LogProcessMsg('Starting Optical Restore +
     c                                            process...')

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

     c                   select
     c                   when      DocSelect = 'R'
     c                   callp     LogProcessMsg('     Reports only')
     c                   when      DocSelect = 'B'
     c                   callp     LogProcessMsg('     Batches only')
     c                   other
     c                   callp     LogProcessMsg('     +
     c                                            Both Reports and Batches')
     c                   endsl

     c                   if        DocSelect = ' ' or
     c                             DocSelect = 'B'
     c                   callp     LogProcessMsg(' ')
     c                   select
     c                   when      DocClass = '*ALL'
     c                   callp     LogProcessMsg('     +
     c                                           All Image/Batch Doc Classes')
     c                   other
     c                   callp     LogProcessMsg('     +
     c                                           Image/Batch Doc Class: ' +
     c                                           DocClass)
     c                   endsl
     c                   end

     c                   select
     c                   when      RptType = '*ALL'
     c                   callp     LogProcessMsg('     +
     c                                           All Report Types')
     c                   other
     c                   callp     LogProcessMsg('     +
     c                                           Report Type: ' + RptType)
     c                   endsl

     c                   if        DateRangeFrom <> 0 or
     c                             DateRangeThru <> 99999999
     c                   callp     LogProcessMsg(' ')
     c                   callp     LogProcessMsg('     +
     c                                           Date Range Selection')
     c                   callp     LogProcessMsg('     +
     c                                           From Date: ' +
     c                                           %editc(DateRangeFrom:'3'))
     c                   callp     LogProcessMsg('     +
     c                                           Thru Date: ' +
     c                                           %editc(DateRangeThru:'3'))
     c                   end

      * process reports
     c                   if        not EndProcess
     c                   if        DocSelect = 'R' or
     c                             DocSelect = *blanks
     c                   callp     LogProcessMsg(' ')
     c                   callp     LogProcessMsg('Processing Reports...')
     c                   callp     OpticalReports
     c                   if        RptSelected = 0
     c                   callp     LogProcessMsg('No reports selected.')
     c                   end
     c                   end
     c                   end
      * process batches
     c                   if        not EndProcess
     c                   if        DocSelect = 'B' or
     c                             DocSelect = *blanks
     c                   callp     LogProcessMsg(' ')
     c                   callp     LogProcessMsg('Processing Batches...')
     c                   callp     OpticalBatches
     c                   if        BatSelected = 0
     c                   callp     LogProcessMsg('No batches selected.')
     c                   end
     c                   end
     c                   end

      * results
     c                   callp     LogProcessMsg(' ')
     c                   callp     LogProcessMsg('Totals this run:')
     c                   if        DocSelect = 'R' or
     c                             DocSelect = *blanks
     c                   callp     LogProcessMsg(%editc(RptRestored:'3')
     c                                        + ' reports restored.')
     c                   if        RptErrors > 0
     c                   callp     LogProcessMsg(%editc(RptErrors:'3')
     c                                        + ' reports not restored.')
     c                   end
     c                   end
     c                   if        DocSelect = 'B' or
     c                             DocSelect = *blanks
     c                   callp     LogProcessMsg(%editc(BatRestored:'3')
     c                                        + ' batches restored.')
     c                   if        BatErrors > 0
     c                   callp     LogProcessMsg(%editc(BatErrors:'3')
     c                                        + ' batches not restored.')
     c                   end
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
     c                   call      'ORLOG'                              99
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
     c                   callp     SndMsg('Optical restore process +
     c                                     is already active.')
     c                   exsr      $exit
     c                   end
     c                   callp     ClearProcessLog(ProcAppId)
     c                   callp     OpenProcessLog(ProcAppId)

     c                   endsr
      * ---------------------------------------------------------------------- *
     p OpticalReports...
     p                 b
     d                 pi            10i 0

     d Select          s           1024    varying

      /if defined( DEBUG_NO_RESTORE_RPT )
     c                   callp     LogProcessMsg('*DEBUG ON* +
     c                                Reports will not be restored.')
      /endif

      * find optical reports by folder
     c                   eval      Select = 'SELECT +
     c                               ofrvol, repind, fldr, fldrlb, +
     c                               filnam, jobnam, usrnam, jobnum, filnum, +
     c                               datfop +
     c                              FROM mrptdir WHERE reploc = ''2'''

     c                   if        FolderName <> '*ALL'
     c                   if        0 < %scan('*':FolderName)
     c     '*':'%'       xlate     FolderName    FolderNameX
     c                   eval      Select = Select + ' and +
     c                                fldr like '''+ %trim(FolderNameX) +''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                         fldr = '''+ FolderName + ''''
     c                   end
     c                   end

     c                   if        FolderLib <> '*ALL'
     c                   if        0 < %scan('*':FolderLib)
     c     '*':'%'       xlate     FolderLib     FolderLibX
     c                   eval      Select = Select + ' and +
     c                                fldrlb like '''+ %trim(FolderLibX) +''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                         fldrlb = '''+ FolderLib + ''''
     c                   end
     c                   end

     c                   if        RptType <> '*ALL'
     c                   if        0 < %scan('*':RptType)
     c     '*':'%'       xlate     RptType       RptTypeX
     c                   eval      Select = Select + ' and +
     c                                rpttyp like '''+ %trim(RptTypeX) + ''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                         rpttyp = '''+ RptType + ''''
     c                   end
     c                   end

     c                   if        DateRangeFrom <> 0 or
     c                             DateRangeThru <> 99999999
     c                   eval      DateRangeFromX = CvtDate7(DateRangeFrom)
     c                   eval      DateRangeThruX = CvtDate7(DateRangeThru)
     c                   eval      Select = Select + ' and +
     c                                         mdatop between '+
     c                                           %editc(DateRangeFromX:'3') +
     c                                       ' and ' +
     c                                           %editc(DateRangeThruX:'3')
     c                   end

     c                   eval      Select = Select + ' ORDER BY +
     c                                ofrvol, fldrlb, fldr, repind'

     C/EXEC SQL
     C+ DECLARE OPTRPTS STATEMENT
     C/END-EXEC
     C/EXEC SQL
     C+ DECLARE OPTRPTC CURSOR FOR OPTRPTS
     C/END-EXEC
     C/EXEC SQL
     C+ PREPARE OPTRPTS FROM :Select
     C/END-EXEC
     C/EXEC SQL
     C+ OPEN OPTRPTC
     C/END-EXEC

     c                   if        SQLcod <> 0
     c                   callp     LogSQLmsg(SQLcod:SQLerm:SQLerl)
     c                   callp     SetError
     c                   else

      * restore all selected reports
     c                   do        *hival
     C/EXEC SQL
     C+ FETCH NEXT FROM OPTRPTC INTO
     C+ :ofrvol, :repind, :fldr, :fldrlb,
     C+ :filnam, :jobnam, :usrnam, :jobnum, :filnum, :datfop
     C/END-EXEC
     c                   if        SQLcod <> 0
     c                   if        SQLcod <> 100
     c                   callp     LogSQLmsg(SQLcod:SQLerm:SQLerl)
     c                   callp     SetError
     c                   end
     c                   leave
     c                   end
     c                   eval      RptSelected = RptSelected + 1

      * Check for end processing request
     c                   if        0 <> StopCheck
     c                   leave
     c                   end
      * restore the report
     c                   if        OK <> RestoreReport
      /if defined( HALT_ON_RESTORE_ERROR )
     c                   leave
      /endif
     c                   end

     c                   enddo
     C/EXEC SQL
     C+ CLOSE OPTRPTC
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
     c                                            optical reports.'
     c                                          :'E':*blanks:@Pgm)
     c                   end
     c                   return    FAIL
     c                   endsr
     p                 e
      * ---------------------------------------------------------------------- *
     p OpticalBatches...
     p                 b
     d                 pi            10i 0

     d Select          s           1024    varying

      /if defined( DEBUG_NO_RESTORE_BAT )
     c                   callp     LogProcessMsg('*DEBUG ON* +
     c                                Batches will not be restored.')
      /endif

      * find optical batches by folder
     c                   eval      Select = 'SELECT +
     c                               optvol, idbnum, idfld, idflib, iddoct +
     c                              FROM mimgdir +
     c                              JOIN mopttbl on idbnum = optrnm +
     c                                          and idpfil = optfil +
     c                              WHERE idiloc = ''2'''

     c                   if        FolderName <> '*ALL'
     c                   if        0 < %scan('*':FolderName)
     c     '*':'%'       xlate     FolderName    FolderNameX
     c                   eval      Select = Select + ' and +
     c                                 idfld like '''+ %trim(FolderNameX) +''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                          idfld = '''+ FolderName + ''''
     c                   end
     c                   end

     c                   if        FolderLib <> '*ALL'
     c                   if        0 < %scan('*':FolderLib)
     c     '*':'%'       xlate     FolderLib     FolderLibX
     c                   eval      Select = Select + ' and +
     c                                idflib like '''+ %trim(FolderLibX) +''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                         idflib = '''+ FolderLib + ''''
     c                   end
     c                   end

     c                   if        DocClass <> '*ALL'
     c                   if        0 < %scan('*':DocClass)
     c     '*':'%'       xlate     DocClass      DocClassX
     c                   eval      Select = Select + ' and +
     c                                iddoct like '''+ %trim(DocClassX) +''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                         iddoct = '''+ DocClass + ''''
     c                   end
     c                   end

     c                   if        RptType <> '*ALL'
     c                   if        0 < %scan('*':RptType)
     c     '*':'%'       xlate     RptType       RptTypeX
     c                   eval      Select = Select + ' and +
     c                                idrtyp like '''+ %trim(RptTypeX) + ''''
     c                   else
     c                   eval      Select = Select + ' and +
     c                                         idrtyp = '''+ RptType + ''''
     c                   end
     c                   end

     c                   if        DateRangeFrom <> 0 or
     c                             DateRangeThru <> 99999999
     c                   eval      Select = Select + ' and +
     c                                         iddcpt between '+
     c                                           %editc(DateRangeFrom:'3') +
     c                                       ' and ' +
     c                                           %editc(DateRangeThru:'3')
     c                   end

     c                   eval      Select = Select + ' ORDER BY +
     c                                 optvol, idflib, idfld, idbnum'

     C/EXEC SQL
     C+ DECLARE OPTBATS STATEMENT
     C/END-EXEC
     C/EXEC SQL
     C+ DECLARE OPTBATC CURSOR FOR OPTBATS
     C/END-EXEC
     C/EXEC SQL
     C+ PREPARE OPTBATS FROM :Select
     C/END-EXEC
     C/EXEC SQL
     C+ OPEN OPTBATC
     C/END-EXEC

     c                   if        SQLcod <> 0
     c                   callp     LogSQLmsg(SQLcod:SQLerm:SQLerl)
     c                   callp     SetError
     c                   else

      * restore all selected batches
     c                   do        *hival
     C/EXEC SQL
     C+ FETCH NEXT FROM OPTBATC INTO
     C+ :optvol, :idbnum, :idfld, :idflib, :iddoct
     C/END-EXEC
     c                   if        SQLcod <> 0
     c                   if        SQLcod <> 100
     c                   callp     LogSQLmsg(SQLcod:SQLerm:SQLerl)
     c                   callp     SetError
     c                   end
     c                   leave
     c                   end
     c                   eval      BatSelected = BatSelected + 1

      * Check for end processing request
     c                   if        0 <> StopCheck
     c                   leave
     c                   end
      * restore the batch
     c                   if        OK <> RestoreBatch
      /if defined( HALT_ON_RESTORE_ERROR )
     c                   leave
      /endif
     c                   end

     c                   enddo
     C/EXEC SQL
     C+ CLOSE OPTBATC
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
     c                                            optical batches.'
     c                                          :'E':*blanks:@Pgm)
     c                   end
     c                   return    FAIL
     c                   endsr
     p                 e
      * ---------------------------------------------------------------------- *
     p RestoreReport...
     p                 b
     d                 pi            10i 0

     d rtncde          s              1
     d datfo           s              7

     c                   if        OK <> LckFolder(fldr:fldrlb)
     c                   exsr      *pssr
     c                   end
      * restore optical reports
      /if not defined( DEBUG_NO_RESTORE_RPT )
     c                   move      datfop        datfo
     c                   callp     dmRstOptReport(fldr:fldrlb
     c                               :filnam:jobnam:usrnam:jobnum:datfo:filnum
     c                               :rtncde)
      /endif
     c                   if        rtncde = '1'
     c                   exsr      *pssr
     c                   end
      /if defined( VERBOSE_LOG )
     c                   callp     LogProcessMsg('Report: +
     c                                       FILE( '+ filnam +' ) +
     c                                       SDOI( '+ repind +' ) +
     c                                            has been restored.')
      /endif
     c                   eval      RptRestored = RptRestored + 1
     c                   return    OK
      * --------------- *
     c     *pssr         begsr
     c                   if        PssrOnce <> *on
     c                   move      *on           PssrOnce          1
     c                   callp     SetError
     c                   eval      RptErrors = RptErrors + 1
     c                   callp     LogProcessMsg('Error restoring report +
     c                                      FILE( '+ filnam +' ) +
     c                                      SDOI( '+ repind +' ) +
     c                                          - see JOBLOG for details'
     c                                          :'E':*blanks:@Pgm)
     c                   end
     c                   return    FAIL
     c                   endsr
     p                 e
      * ---------------------------------------------------------------------- *
     p RestoreBatch...
     p                 b
     d                 pi            10i 0

     d ErrId           s              7
     d ErrData         s            100

     c                   if        OK <> LckFolder(idfld:idflib)
     c                   exsr      *pssr
     c                   end
      * restore optical batches (images)
      /if not defined( DEBUG_NO_RESTORE_BAT )
     c                   callp     dmRstOptBatch(idbnum:ErrId:ErrData)
      /endif
     c                   if        ErrId <> *blanks
     c                   callp     LogProcessMsgId(ErrId:ErrData
     c                                            :'PSCON':'*LIBL'
     c                                            :'E':@Pgm)
     c                   exsr      *pssr
     c                   end
      /if defined( VERBOSE_LOG )
     c                   callp     LogProcessMsg('Batch: +
     c                                   DOCTYPE( '+ iddoct +' ) +
     c                                     BATCH( '+ idbnum +' ) +
     c                                            has been restored.')
      /endif
     c                   eval      BatRestored = BatRestored + 1
     c                   return    OK
      * --------------- *
     c     *pssr         begsr
     c                   if        PssrOnce <> *on
     c                   move      *on           PssrOnce          1
     c                   callp     SetError
     c                   eval      BatErrors = BatErrors + 1
     c                   callp     LogProcessMsg('Error restoring +
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
     c                   callp     Cmd('OVRDBF FOLDER +
     c                                  TOFILE('+ %trim(FolderLib)
     c                                      +'/'+ %trim(Folder) +') +
     c                                  FRCRATIO(2000) SEQONLY(*YES 2000) +
     c                                         OVRSCOPE(*JOB)')
     c                   callp     Cmd('OVRDBF FOLDER2 +
     c                                  TOFILE('+ %trim(FolderLib)
     c                                      +'/'+ %trim(Folder) +') +
     c                                         OVRSCOPE(*JOB)')
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
     c***                callp     Cmd('DLTOVR FOLDER')
     c***                callp     Cmd('DLTOVR FOLDER2')
     c                   return    Cmd('DLCOBJ OBJ(('+ %trim(FolderLib)
     c                                           +'/'+ %trim(Folder)
     c                                                +' *FILE *EXCLRD))')
     p                 e
      * ---------------------------------------------------------------------- *
     p CvtDate7...
     p                 b
     d                 pi             7  0
     d Date8                          8  0 value

     d Date8ds         ds
     d d8_yyyy                        4
     d d8_mmdd                        4
     d Date7ds         ds
     d d7_c                           1
     d d7_yy                          2
     d d7_mmdd                        4
     d date7           s              7  0

     c                   if        Date8 = 0
     c                   return    0
     c                   end
     c                   if        Date8 = 99999999
     c                   return    9999999
     c                   end
T6111c                   move      Date8         Date8DS
     c                   move      d8_mmdd       d7_mmdd
     c                   move      d8_yyyy       d7_yy
     c                   if        d7_yy < '40'
     c                   eval      d7_c = '1'
     c                   else
     c                   eval      d7_c = '0'
     c                   end
     c                   move      date7ds       date7
     c                   return    date7
     p                 e

      *%METADATA                                                       *
      * %TEXT Copy/Move Report Type to Folder                          *
      *%EMETADATA                                                      *
      /copy directives
      *
J3124 * 10-07-11 PLR Add *ALL option for report type.
J2416 * 02-23-10 PLR Move report type to a different folder.
J2415 * 02-15-10 PLR Created. Copy reprt type to a different folder.
      *
      *              Called by commands: DOCCPYTYP & DOCMOVTYP
      *              CL program:         MRFLDDTA
      *

     fmrflddta  o    e             printer oflind(*in01) usropn

     d sqlStmt         s           1024
     d SQ              c                   ''''
     d startStop       ds                  dtaara('DOCCPYTYP') qualified
     d  code                          1
     d  user                         10
     d OK              c                   0
     d ERROR           c                   -1
     d psds          esds                  extname(caspgmd)
     d timeStart       s               z
     d timeEnd         s               z
     d SQL_ALREADY_EXISTS...
     d                 c                   -601
     d SQL_ROW_NOT_FOUND...
     d                 c                   100
     d SQL_CREATED_NOT_JOURNALED...
     d                 c                   7905
     d JOBCTL_START    c                   '0'
     d JOBCTL_STOP     c                   '1'
     d OPER_COPY       c                   '0'
     d OPER_MOVE       c                   '1'
     d fromFolder      ds                  qualified
     d  entries                       5u 0
     d  folder                             likeds(folder_t) dim(10)
     d folder_t        ds                  qualified
     d  name                         10
     d  library                      10
     d toFolder        ds                  qualified
     d  name                         10
     d  library                      10

     d/copy QSYSINC/QRPGLESRC,QUSEC

     d run             pr            10i 0 extproc('system')
     d  command                        *   value options(*string)
     d command         s            256

     d printMessage    pr
     d  message                        *   options(*string) const
     d printSummary    pr
     d buildStmt       pr
     d execStmt        pr            10i 0

     c     *entry        plist
     c                   parm                    jobCtl            1
     c                   parm                    operation         1
     c                   parm                    reportType       10
     c                   parm                    fromFolderIn    202
     c                   parm                    toFolderIn       20
     c                   parm                    fromDate          8
     c                   parm                    toDate            8
     c                   parm                    returnCode        1

      /free
       exec sql set option closqlcsr=*endactgrp,commit=*none,srtseq=*langidshr;
       fromFolder = fromFolderIn;
       toFolder = toFolderIn;
       timeStart = %timestamp();
       returnCode = ' ';

       if execStmt() = ERROR;
         printMessage('Errors encountered. See previously listed messages.');
         returnCode = '1';
       endif;

       printSummary();

       exsr returnSR;

       //**********************************************************************
       begsr returnSR;
         exec sql close c1;
         *inlr = '1';
         return;
       endsr;

      /end-free

      **************************************************************************
     p printMessage    b
     d                 pi
     d msgDtaIn                        *   options(*string) const

     d beenHere        s               n   static
     d i               s              5i 0
      /free
       if not beenHere;
         if not %open(mrflddta);
           select;
             when operation = OPER_COPY;
               run('ovrprtf file(mrflddta) splfname(doccpytyp)');
             when operation = OPER_MOVE;
               run('ovrprtf file(mrflddta) splfname(docmovtyp)');
           endsl;
           open mrflddta;
           run('dltovr mrflddta');
         endif;
         opDesc = 'COPY';
         if operation = OPER_MOVE;
           opDesc = 'Move';
         endif;
         write header;
         frDateOut = fromDate;
         if frDateOut = '00000000';
           frDateOut = '*FIRST';
         endif;
         toDateOut = toDate;
         if toDateOut = '99999999';
           toDateOut = '*LAST';
         endif;
         write parms;
         for i = 1 to fromFolder.entries;
           if fromFolder.folder(1).library = ' ';
             fromFld = fromFolder.folder(1).name;
           else;
             fromFld = %trimr(fromFolder.folder(i).library) + '/' +
               %trimr(fromFolder.folder(i).name);
           endif;
           write parms2;
         endfor;
         toFld = %trimr(toFolder.library) + '/' + toFolder.name;
         write parms3;
         write header2;
       endif;
       beenHere = '1';
       if *in01;
         write header;
         write header2;
         *in01 = '0';
       endif;
       msgDta = %str(msgDtaIn);
       write msgRcd;
       return;
      /end-free
     p                 e

      **************************************************************************
     p printSummary    b
      /free
       timeEnd = %timestamp();
       rundays = %diff(timeEnd:timeStart:*days);
       timeEnd -= %days(rundays);
       runhrs = %diff(timeEnd:timeStart:*hours);
       timeEnd -= %hours(runhrs);
       runmin = %diff(timeEnd:timeStart:*minutes);
       timeEnd -= %minutes(runmin);
       runsec = %diff(timeEnd:timeStart:*seconds);
       if *in01;
         write header;
         write header2;
         *in01 = '0';
       endif;
       write summary;
       return;
      /end-free
     p                 e

      **************************************************************************
     p buildStmt       b
     d                 pi
     d rFromDate       s              7
     d rToDate         s              7
     d i               s              5i 0
      /free
       // Build UNION between rptdir and imgdir files.
       sqlStmt = 'select ' + SQ + 'R' + SQ +
         ', repind, fldr, fldrlb from mrptdir where ' +
J3124    // Do not retrieve rptdir records that are in the target library/folder.
J3124    ' not (fldr = ' + SQ + %trimr(toFolder.name) + SQ +
J3124    ' and fldrlb = ' + SQ + %trimr(toFolder.library) + SQ + ')';
J3124  // Report type if specified.
J3124  if reportType <> '*ALL';
J3124    sqlStmt = %trimr(sqlStmt) + ' and ' +
J3124    'rpttyp = ' + SQ + %trimr(reportType) + SQ;
J3124  endif;
       // Add report "from" library/folder to statement unless *ALL.
       if fromFolder.folder(1).name <> '*ALL';
         sqlStmt = %trimr(sqlStmt) + ' and (';
         for i = 1 to fromFolder.entries;
           sqlStmt = %trimr(sqlStmt) + ' (fldr = ' + SQ +
             %trimr(fromFolder.folder(i).name) + SQ + ' and fldrlb = ' +
             SQ + %trimr(fromFolder.folder(i).library) + SQ + ')';
           if i <= fromFolder.entries - 1;
             sqlStmt = %trimr(sqlStmt) + ' or';
           endif;
         endfor;
         sqlStmt = %trimr(sqlStmt) + ' )';
       endif;
       // Create dates for rptdir are CYYMMDD. Will need to convert
       // input dates to match.
       if fromDate <> *all'0';
         rFromDate = %char(%date(fromDate:*iso0):*cymd0);
         sqlStmt = %trimr(sqlStmt) + ' and mdatop >= ' + rFromDate;
       endif;
       if toDate <> *all'9';
         rToDate = %char(%date(toDate:*iso0):*cymd0);
         sqlStmt = %trimr(sqlStmt) + ' and mdatop <= ' + rToDate;
       endif;

       // Build image directory portion of the union.
       sqlStmt = %trim(sqlStmt) + ' union select ' + SQ + 'I' + SQ +
         ', idbnum, idfld, idflib from mimgdir where' +
J3124  // Do not retrieve imgdir records that are in the target library/folder.
J3124  // Image data must be online. Between date ranges.
J3124    ' not (idfld = ' + SQ + %trimr(toFolder.name) + SQ +
J3124    ' and idflib = ' + SQ + %trimr(toFolder.library) + SQ + ')' +
J3124    ' and iddcpt between ' + fromDate +
J3124    ' and ' + toDate;
J3124  //Images can be moved by reference but not by copy if offline.
J3124  if operation = OPER_COPY;
J3124    sqlStmt = %trimr(sqlStmt) + ' and idiloc <> ' + SQ + '2' + SQ;
J3124  endif;
J3124  // Report type if specified.
J3124  if reportType <> '*ALL';
J3124    sqlStmt = %trimr(sqlStmt) + ' and idrtyp = ' +
J3124    SQ + %trimr(reportType) + SQ;
J3124  endif;
       // Folder(s)
       if fromFolder.folder(1).name <> '*ALL';
         sqlStmt = %trimr(sqlStmt) + ' and (';
         for i = 1 to fromFolder.entries;
           sqlStmt = %trimr(sqlStmt) + ' (idfld = ' + SQ +
             %trimr(fromFolder.folder(i).name) + SQ + ' and idflib = ' +
             SQ + %trimr(fromFolder.folder(i).library) + SQ + ')';
           if i <= fromFolder.entries - 1;
             sqlStmt = %trimr(sqlStmt) + ' or';
           endif;
         endfor;
         sqlStmt = %trimr(sqlStmt) + ' )';
       endif;
       return;
      /end-free
     p                 e

      **************************************************************************
     p execStmt        b
     d                 pi            10i 0
     d dirRcd          ds                  qualified
     d  type                          1
     d  id                           10
     d  folder                       10
     d  library                      10
     d copyReport      pr                  extpgm('CPYRDR')
     d  fromFolder                   10
     d  fromLibrary                  10
     d  toFolder                     10
     d  toLibrary                    10
     d  returnCode                    8
     d  reportID                     10
     d returnCode      s              8
     d copyImage       pr                  extpgm('CPYIMG')
     d  fromFolder                   10
     d  fromLibrary                  10
     d  toFolder                     10
     d  toLibrary                    10
     d  returnCode                    8
     d  batchID                      10
     d moveReport      pr                  extpgm('MOVRDR')
     d  reportID                     10
     d  rtnKey                        1
     d  toFolder                     10
     d  toFldLib                     10
     d  message                      80
     d rtnKey          s              1
     d rtnMsg          s             80
     d moveImage       pr                  extpgm('MAG1509')
     d  batchID                      10
     d  opCode                        6
     d  toFolder                     10
     d  toFldLib                     10
     d  rtnMsg                       80
     d movImgOp        s              6    inz
     d copiedOrMoved   s              6    inz('copied')
     d errorEncountered...
     d                 s               n   inz('0')
      /free
       buildStmt();
       exec sql prepare stmt from :sqlStmt;
       exec sql declare c1 cursor for stmt;
       exec sql open c1;
       exec sql fetch from c1 into :dirRcd;
       if sqlcod <> OK;
         if sqlcod = SQL_ROW_NOT_FOUND;
           printMessage('No data found for specified criteria.');
         else;
           printMessage('Error while selecting directory records.');
           printMessage('SQL error code ' + %trim(%editc(sqlcod:'Z')));
         endif;
         return ERROR;
       endif;
       dow sqlcod = OK;
         // Check for stop request.
         in startStop;
         if startStop.code = '1'; //Stop request.
           printMessage('Stop request made by ' + %trimr(startStop.user));
           leave;
         endif;
         select;
           when operation = OPER_COPY;
             select;
               when dirRcd.type = 'R';
                 copyReport(dirRcd.folder:dirRcd.library:toFolder.name:
                   toFolder.library:returnCode:dirRcd.id);
               when dirRcd.type = 'I';
                 copyImage(dirRcd.folder:dirRcd.library:toFolder.name:
                   toFolder.library:returnCode:dirRcd.id);
             endsl;
           when operation = OPER_MOVE;
             copiedOrMoved = 'moved';
             select;
               when dirRcd.type = 'R';
                 moveReport(dirRcd.id:rtnKey:toFolder.name:toFolder.library:
                   rtnMsg);
               when dirRcd.type = 'I';
                 moveImage(dirRcd.id:movImgOp:toFolder.name:toFolder.library:
                   rtnMsg);
             endsl;
         endsl;
         exsr setMessage;
         exec sql fetch next from c1 into :dirRcd;
       enddo;
       return OK;

       //***********************************************************************
       begsr setMessage;
         errorEncountered = '0';
         select;
           when OPER_COPY;
             if returnCode <> 'GOOD';
               printMessage('Error copying document.');
               select;
                 when returnCode = 'OPNFLD';
                   printMessage('Error opening folder. ' +
                     'Folder must already exist.');
                 when returnCode = 'NRFDIR';
                   printMessage('No dirctory record found for ' + dirRcd.id);
                 when returnCode = 'ALCOBJ';
                   printMessage('Error allocating target folder.');
                   printMessage('Archiving may be active or user may be ' +
                     'accessing.');
                 when returnCode = 'CPYFLD';
                   printMessage('Error copying folder data. ' +
                     'CPYRDR/copyFolderData()');
                 when returnCode = 'RTVMBRD';
                   printMessage('Error retrieving folder description data. ' +
                     'CPYRDR/copyFolderData()');
                 when returnCode = 'SRCHDR';
                   printMessage('Error retrieving source header for ' +
                     %trimr(dirRcd.id) + ' CPYRDR/copyFolderData()');
               endsl;
               errorEncountered = '1';
             endif;
           when OPER_MOVE;
             if rtnMsg <> ' ';
               printMessage('Error moving document.');
               printMessage(rtnMsg);
               errorEncountered = '1';
             endif;
         endsl;
         if errorEncountered;
           return ERROR;
         endif;
         printMessage('Document id ' + %trimr(dirRcd.id) + ' ' +
           %trimr(copiedOrMoved) + ' from folder ' +
           %trimr(dirRcd.library) + '/' + %trimr(dirRcd.folder) +
           ' to folder ' + %trimr(toFolder.library) + '/' + toFolder.name);
         processed += 1;
       endsr;
      /end-free
     p                 e

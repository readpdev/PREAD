      *%METADATA                                                       *
      * %TEXT Populate Missing Links for Images                        *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp('DOCMGR') bnddir('QC2LE')

      * The reason for this program was an issue brought on by a change docClass
      * operation performed via workflow. Apparently, there is a code problem or
      * configuration problem that moves the images but not the index values
      * (updated or static) to the target class. To compound the issue, the
      * source index values are deleted.

      * Fortunately, the target index values are stored by workflow. This file
      * is imported to a work file and used to retrieve and write the
      * index values for the missing links of the target document class. This
      * file must be formatted to the RLINK file layout.

      * Program logic:

      * Retrieve and store the original batch id, image seq# and image file
      * name for all images of the source document class. The batch id
      * and image seq# are the key to the workflow file containing the index
      * values.

      * A search of the target document class is performed to identify images
      * missing indexes. When images meeting this criteria are found, a lookup
      * is performed against the stored source image information using the
      * image file name. Using the original batch id and sequence number
      * a lookup is performed against the workflow case file to retrieve the
      * index values and ultimately writing them out to the corresponding
      * link file of the target document class.

     fmimgdi14  if   e           k disk
     frmaint4   if   e           k disk
     frlnkdef   if   e           k disk

     d OK              c                   0
     d FAIL            c                   -1
     d NO_IMG_FOR_SEQ  c                   -2

     d memcpy          pr                  extproc('memcpy')
     d  target                         *   value options(*string)
     d  source                         *   value options(*string)
     d  length                       10i 0 value

     d system          pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d spycsfil        pr                  extpgm('SPYCSFIL')
     d  PRMWIN                       10    const
     d  PRMBCH                       10
     d  OPCODE                        6    const
     d  SETSEQ                        9
     d  SDT                        7680
     d  RTNREC                        9  0
     d  RTNCS                         2

     d fmtIval         pr                  extpgm('FMTIVAL')
     d  rrnam                        10
     d  rjnam                        10
     d  rpnam                        10
     d  runam                        10
     d  rudat                        10
     d  ival1                        99
     d  ival2                        99
     d  ival3                        99
     d  ival4                        99
     d  ival5                        99
     d  ival6                        99
     d  ival7                        99
     d  optcde                       10    const
     d  rtncde                        1
     d  offseq                        5  0 const

     d sourceClassInfo...
     d                 pr
     d operationCode                   *   value options(*string)
     d classOrFile                     *   value options(*string:*nopass)
     d imageInfo                       *   value options(*nopass)

     d getImgInfo      pr            10i 0
     d opcode                        10    const
     d batchID                       10
     d class                         10
     d seqNbr                        10i 0 value
     d rtnStruct                       *   value
     d nbrImgsRtn                    10i 0 options(*nopass)

     d updateMissingLinks...
     d                 pr
     d   docClass                    10

     d writeIndexes    pr            10i 0
     d  srcBatchID                   10
     d  srcImgSeq                     9p 0
     d  tgtFileDataP                   *   value

     d logIt           pr
     d  msg                            *   value options(*string)

     d startUp         pr            10i 0

     d imageInfo       ds                  qualified
     d  batchID                      10
     d  seq#                          9p 0
     d  fileName                     25

     d sdt             ds          7680    qualified
     d  fileDS                             likeds(fyldta) dim(40)

     d sdt2            ds          7680    qualified
     d  atrDS                              likeds(rtnatr)

     D FYLDTA          ds           192
     d  FlSPY                         3
     d  FlVER                         5    overlay(fyldta)
     D  FLIDX#                        3
     D  FLSIZE                        9
     D  FLFILE                       25
     D  FLEXT                         5
     D  FLDAT                         8
     D  FLTIM                         6
     D  FLUDAT                        8
     D  FLUTIM                        6
     D  FLUSR                        10
     D  FLNODE                       17
     D  FLSEQ                         9
     D  FLRRN                         9

     D RTNATR          DS          2048
     d  ivAll                  1    693
     D  IV                     1    693    DIM(7)
     d  VUDAT                694    701
     D  VUSPG                702    710
     D  VUEPG                711    719
     D  IN                   720    789    DIM(7)
     d  VUATR               1025   2048

     d nbrImgs         s             10i 0
     d timeStart       s               z
     d lnkValsFnd      s             10i 0
     d lnkValsUpd      s             10i 0

     d                sds
     d currentUser           254    263

     c     *entry        plist
     c                   parm                    sourceClass      10
     c                   parm                    targetClass      10
     c                   parm                    caseFile         10

      /free
       if startUp() = OK;
         sourceClassInfo('INIT':sourceClass);
         updateMissingLinks(targetClass);
         sourceClassInfo('QUIT');
       endif;
       *inlr = '1';
       return;
      /end-free

      **************************************************************************
     p sourceClassInfo...
     p                 b
     d                 pi
     d operationCode                   *   value options(*string)
     d classOrFile                     *   value options(*string:*nopass)
     d imageInfoP                      *   value options(*nopass)

     d imgInf          ds                  likeds(imageInfo) based(imageInfoP)

     d topMemDta       s               *   static
     d memDta          ds                  based(memDtaP) qualified
     d  batchID                      10
     d  seq#                          9p 0
     d  fileName                     25
     d  nextP                          *
     d docClass        s                   like(idrtyp)

     d i               s             10i 0
     d saveNextP       s               *
     d seq             s             10i 0

      /free
       select;
         when %str(operationCode) = 'INIT';
           exsr initSR;
         when %str(operationCode) = 'GET';
           exsr getSR;
         when %str(operationCode) = 'QUIT';
           exsr quitSR;
       endsl;
       return;
       //***********************************************************************
       // Retrieve all image file names, bactch id and seq# and store in linked
       // list.
       begsr initSR;
         docClass = %str(classOrFile);
         setll docClass mimgdi14;
         reade docClass mimgdi14;
         dow not %eof;
           seq = 0;
           dow getImgInfo('READGT':idbnum:docClass:seq:%addr(sdt):nbrImgs) = OK;
             for i = 1 to nbrImgs;
               exsr addInfoToMem;
             endfor;
             if nbrImgs < %elem(sdt.fileDS);
               leave;
             endif;
             seq = seq + nbrImgs;
           enddo;
           reade docClass mimgdi14;
         enddo;
       endsr;
       //***********************************************************************
       begsr addInfoToMem;
         memDtaP = topMemDta;
         dow memDtaP <> *null and memDta.nextP <> *null;
           memDtaP = memDta.nextP;
         enddo;
         if memDtaP = *null;
           memDtaP = %alloc(%size(memDta));
         elseif memDta.nextP = *null;
           memDta.nextP = %alloc(%size(memDta));
           memDtaP = memDta.nextP;
         endif;
         clear memDta;
         memDta.batchID = idbnum;
         memDta.seq# = i;
         memDta.fileName = sdt.fileDS(i).flfile;
         if topMemDta = *null;
           topMemDta = %alloc(%size(memDta));
           memcpy(topMemDta:memDtaP:%size(memDta));
         endif;
       endsr;
       //***********************************************************************
       // Retrieve batchID and seq number from memory based on the image file
       // name and return.
       begsr getSR;
         memdtaP = topMemDta;
         dow memDtaP <> *null;
           if memDta.fileName = %str(classOrFile);
             memcpy(imageInfoP:memDtaP:%size(imageInfo));
             imageInfoP = memDtaP;
             leave;
           endif;
           memDtaP = memDta.nextP;
         enddo;
         if memDtaP = *null;
           logIt('Matching source image file not found for target ' +
             'batch/file: ' + idbnum + '/' + %str(classOrFile));
         endif;
       endsr;
       //***********************************************************************
       begsr quitSR;
        memDtaP = topMemDta;
        dow memDtaP <> *null;
          saveNextP = memDta.nextP;
          dealloc(n) memDtaP;
          memDtaP = saveNextP;
        enddo;
        topMemDta = *null;
       endsr;
      /end-free
     p                 e
      **************************************************************************
     p getImgInfo      b
     d                 pi            10i 0
     d opcode                        10    const
     d batchID                       10
     d docClass                      10
     d seqNbr                        10i 0 value
     d sdtP                            *   value
     d nbrImgsRtn                    10i 0 options(*nopass)

     d sdtList         ds                  likeds(sdt) based(sdtP)

     d setseq          s              9    inz(*all'0')
     d atrseq          s              9    inz(*all'0')
     d rtnrec          s              9  0
     d rtnrec2         s              9  0
     d rtncs           s              2    inz('00')
     d i               s             10i 0

      /free
       select;
         when opcode = 'READGT';
           setseq = %subst(%editc(seqnbr:'X'):2:9);
           spycsfil('*INTERACT ':batchID:'READGT':setseq:sdtList:rtnrec:rtncs);
           if rtncs = '30';
             logIt('Image info not found for class/batch/sequence ' +
               %trim(docClass) + '/' + %trim(batchID) + '/' + setseq);
             return NO_IMG_FOR_SEQ;
           endif;
           nbrImgsRtn = rtnrec;
         when opcode = 'ATTR';
           setseq = %subst(%editc(seqnbr:'X'):2:9);
           spycsfil('*INTERACT ':batchID:'GETATR':setseq:sdt2:rtnrec:rtncs);
           if rtncs <> '00';
             logIt('Attribute data not found for class/batch/sequence ' +
               %trim(docClass) + '/' + %trim(batchID) + '/' + setseq);
             return FAIL;
           endif;
       endsl;
       return OK;
      /end-free
     p                 e
      **************************************************************************
     p updateMissingLinks...
     p                 b
     d                 pi
     d docClass                      10
     d i               s             10i 0

     d imgInf          ds                  likeds(imageInfo)
     d linkData      e ds                  extname(rlink) qualified
     d
     d totSec          s             10u 0
     d h               s              2s 0
     d m               s              2s 0
     d s               s              2s 0
     d seq             s             10i 0

      /free
       system('ovrdbf linkFile ' + %trim(lnkfil) + ' ovrscope(*calllvl)');
       // Work flow index file does not have a keyed logical...create temporary
       // in qtemp if it doesn't exist.
       exec sql create index qtemp/rlinkview on rlink (ldxnam, lxseq);
       system('ovrdbf rlinkview ' + %trim(caseFile) + ' ovrscope(*calllvl)');
       setll docClass mimgdi14;
       reade docClass mimgdi14;
       dow not %eof;
         seq = 0;
         dow getImgInfo('READGT':idbnum:docClass:seq:%addr(sdt):nbrImgs) = OK;
           for i = 1 to nbrImgs;
             if getImgInfo('ATTR':idbnum:docClass:i+seq:%addr(sdt2)) = OK;
             if sdt2.atrDS.ivAll = ' ';
               clear imgInf;
               sourceClassInfo('GET':sdt.fileDS(i).flfile:%addr(imgInf));
               if imgInf.fileName = sdt.fileDS(i).flfile;
                 writeIndexes(imgInf.batchID:imgInf.seq#:%addr(sdt.fileDS(i)));
               endif;
             endif;
             endif;
           endfor;
           if nbrImgs < %elem(sdt.fileDS);
             leave;
           endif;
           seq = seq + nbrImgs;
         enddo;
         reade docClass mimgdi14;
       enddo;
       system('dltovr rlinkview');
       system('dltf qtemp/rlinkview');
       system('dltovr linkFile');
       logIt('Link values found: ' + %editc(lnkValsFnd:'Z'));
       logIt('Link values updated: ' + %editc(lnkValsUpd:'Z'));
       totSec = %diff(%timestamp():timeStart:*seconds);
       h = %div(totSec:%int(60**2));
       m = %rem(%div(totSec:60):60);
       s = %rem(totSec:60);
       logIt('Duration: Hours ' + %editc(h:'X') + ' Minutes ' + %editc(m:'X') +
         ' Seconds ' + %editc(s:'X'));
       return;
      /end-free
     p                 e
      **************************************************************************
      * Find link values in workflow index file and write them to the
      * target docClass index file.
     p writeIndexes    b
     d                 pi            10i 0
     d  srcBatchID                   10
     d  srcSeq                        9p 0
     d  tgtFilDtaP                     *   value

     d filDta          ds                  likeds(fyldta) based(tgtFilDtaP)
     d links         e ds                  extname(rlink)
     d rc1             s              1

      /free
       exec sql select * into :links from rlinkview where ldxnam = :srcBatchID
         and lxseq = :srcSeq;
       if sqlcod = 0;
         lnkValsFnd = lnkValsFnd + 1;
         fmtIval(rrnam:rjnam:rpnam:runam:rudat:lxiv1:lxiv2:lxiv3:lxiv4:lxiv5:
           lxiv6:lxiv7:'FMTI':rc1:0);
         fmtIval(rrnam:rjnam:rpnam:runam:rudat:lxiv1:lxiv2:lxiv3:lxiv4:lxiv5:
           lxiv6:lxiv7:'NUM':rc1:0);
         ldxnam = idbnum;
         lxseq = %int(filDta.flseq);
         lxspg = %int(filDta.flrrn);
         if lxtyp = ' ';
           lxtyp = 'S';
         endif;
         if lxiv8 = ' ';
           lxiv8 = %char(%date():*iso0);
         endif;
         exec sql insert into linkFile values(:links);
         if sqlcod <> 0;
           logIt('Error inserting values for batch/seq/rrn: ' +
             ldxnam + '/' + filDta.flseq + '/' + filDta.flrrn);
         else;
           lnkValsUpd = lnkValsUpd + 1;
         endif;
       else;
         logIt('Index values not found. Source batch/seq: ' +
           srcBatchID + '/' + %editc(srcSeq:'X') + '. Target batch/seq: ' +
           idbnum + '/' + filDta.flseq);
       endif;
       return OK;
      /end-free
     p                 e
      **************************************************************************
      * Find link values in workflow index file and write them to the
      * target docClass index file.
     p logIt           b
     d                 pi
     d msg                             *   value options(*string)
     d msgOut          s            256
      /free
       if system('chkobj qtemp/mislnklog *file') <> OK;
         exec sql create table qtemp/mislnklog (message char (256));
       endif;
       msgOut = %str(msg);
       exec sql insert into qtemp/mislnklog values(:msgOut);
       return;
      /end-free
     p                 e
      **************************************************************************
     p startUp         b
     d                 pi            10i 0
      /free
       timeStart = %timestamp();
       logIt('Populate Missing Image Links from ' + %trim(sourceClass) +
         ' to ' + %trim(targetClass));
       logIt('Start date and time: ' + %char(timeStart));
       logIt('User: ' + %trim(currentUser));
       // Make sure from and to classes exist before continuing.
       setll sourceClass mimgdi14;
       if not %equal;
         logIt('Source class ' + %trim(sourceClass) + ' not found in image ' +
           'directory. Quitting.');
         return FAIL;
       endif;
       setll targetClass mimgdi14;
       if not %equal;
         logIt('Target class ' + %trim(targetClass) + ' not found in image ' +
           'directory. Quitting.');
         return FAIL;
       endif;
       // Retrieve the link file name for the target class.
       chain targetClass rmaint4;
       if not %found;
         logIt('Report maintenance record not found for ' + %trim(targetClass) +
           ' Quitting.');
         return FAIL;
       endif;
       chain (rrnam:rjnam:rpnam:runam:rudat) rlnkdef;
       if not %found;
        logIt('Link definition record not found for ' + %trim(rrnam) +
          ' Quiting.');
        return FAIL;
       endif;
       if lnkfil = ' ';
         logIt('Link file field is blank. Quitting.');
         return FAIL;
       endif;
       if system('chkobj ' + %trim(lnkfil) + ' *file') <> OK;
         logIt('Link file ' + lnkfil + ' not found.');
         return FAIL;
       endif;
       if system('chkobj ' + %trim(caseFile) + ' *file') <> OK;
         logIt('Workflow index input file ' + %trim(caseFile) +
           ' not found.');
         return FAIL;
       endif;
       return OK;
      /end-free
     p                 e

      *%METADATA                                                       *
      * %TEXT Check file format levels in a given library              *
      *%EMETADATA                                                      *
     h bnddir('MYBNDDIR')

     fqadsppgm  if   e             disk    usropn
     fmyPrint   o    f  132        printer usropn oflind(*in99)

      /copy 'UTIL/@run.rpgleinc'
      /copy qsysinc/qrpglesrc,qdbrtvfd
      /copy qsysinc/qrpglesrc,qusec

     d rtvFD           pr                  extpgm('QDBRTVFD')
     d  Receiver                           like(QDBQ41)
     d  RcvrSize                     10i 0
     d  RtnQualFile                  20
     d  Format                        8    const
     d  QualFile                     20
     d  RcdFmtName                   10
     d  Override                      1    const
     d  System                       10    const
     d  FormatType                   10    const
     d  ErrorStruct                        like(qusec)

     d addToFileP      pr
     d  fileIn                       10
     d  fileLibIn                    10
     d  rcdFmtIn                     10
     d  lvlIndIn                     13

     d OK              c                   0
     d NOTFOUND        c                   'Not Found'
     d fileP_DS        ds                  based(fileP)
     d  fileName                     10
     d  fileLib                      10
     d  fileRcdFmt                   10
     d  fileFLI                      13
     d  fileNextP                      *
     d top             s               *
     d getFLI          pr            13
     d  file                         10
     d  lib                          10
     d  rcdFmt                       10
     d rtnFLI          s             13
     d timeOut         s               t

     c     *entry        plist
     c                   parm                    pgmLibrary       10
     c                   parm                    dtaLibrary       10

      /free
       // Get program references
       if run('dsppgmref pgm(' + %trim(pgmLibrary) + '/*all) output(*outfile) '+
         'objtype(*all) outfile(qtemp/pr)') <> OK;
         exsr returnSR;
       endif;
       if run('ovrdbf qadsppgm qtemp/pr ovrscope(*job)') <> OK;
         exsr returnSR;
       endif;
       open qadsppgm;

       dow 1 = 1;
         read qadsppgm;
         if %eof;
           leave;
         endif;
         if whotyp <> '*FILE' or whrfno > 1;
           iter;
         endif;
         rtnFLI = getFLI(whfnam:dtaLibrary:whrfnm);
         if whrfsn <> rtnFLI;
           exsr printSR;
         endif;
       enddo;

       exsr returnSR;

       //***********************************************************************
       begsr returnSR;
         close(e) qadsppgm;
         close(e) myPrint;
         run('dltovr qadsppgm lvl(*job)');
         run('dltovr myPrint lvl(*job)');
         run('dltf(qtemp/pr)');
         dealloc(n) top;
         dealloc(n) fileP;
         *inlr = '1';
         return;
       endsr;

       //***********************************************************************
       begsr printSR;
       // Print any file level identifiers not matching or not found
        if not %open(myPrint);
          run('ovrprtf file(myPrint) splfname(chkfmtlvl) pagesize(88 132) ' +
            'lpi(8) cpi(16.7) ovrflw(80) pagrtt(0) ovrscope(*job) ' +
            'tofile(qsysprt)');
          open myPrint;
          *in99 = '1';
        endif;
        if *in99;
          timeOut = %time;
          except printHdr;
          *in99 = '0';
        endif;
        except printDtl;
       endsr;
      /end-free

      **************************************************************************
     omyPrint   e            printHdr          1
     o                       udate         y
     o                                              '  '
     o                       timeOut
     o                                              '  '
     o                                              'Check File Level Format: '
     o                       pgmLibrary
     o                                              '  '
     o                       dtaLibrary
     o                                              '  '
     o                                              'Page: '
     o                       page          z
     o          e            printHdr    2
     o                                              'Program   '
     o                                              '  '
     o                                              'File      '
     o                                              '  '
     o                                              'Record Fmt'
     o                                              '  '
     o                                              'Format Level '
     o          e            printHdr    0
     o                                              '__________'
     o                                              '  '
     o                                              '__________'
     o                                              '  '
     o                                              '__________'
     o                                              '  '
     o                                              '_____________'
     o          e            printDtl    1
     o                       whpnam
     o                                              '  '
     o                       whfnam
     o                                              ' '
     o                       whrfnm
     o                                              '  '
     o                       rtnFLI

      **************************************************************************
     p getFLI          b
     d                 pi            13
     d fileIn                        10
     d libIn                         10
     d rcdFmtIn                      10

     d rtnVal          s             13    inz(NOTFOUND)
     d rcvrSize        s             10i 0 inz(%size(qdbq41))
     d rtnQualFile     s             20
     d qualFile        s             20

      /free
       // Get level indicator from memory.
       fileP = top;
       dow fileP <> *null;
         if fileName = fileIn and fileLib = libIn and rcdFmtIn = fileRcdFmt;
           rtnVal = fileFLI;
           leave;
         endif;
         fileP = fileNextP;
       enddo;
       // If level indicator not found in memory retrieve it with api and put in
       if rtnVal = NOTFOUND;
         clear qusec;
         qusbprv = %size(qusec);
         qualFile = fileIn + libIn;
         rtvFD(qdbq41:rcvrSize:rtnQualFile:'FILD0200':qualFile:rcdFmtIn:'0':
           '*LCL':'*INT':qusec);
         if qusbavl = 0;
           addToFileP(fileIn:libIn:qdbfname:qdbdfseq);
           rtnVal = qdbdfseq;
         endif;
       endif;
       return rtnVal;
      /end-free
     p                 e

      **************************************************************************
     p addToFileP      b
     d                 pi
     d fileIn                        10
     d fileLibIn                     10
     d fileRcdFmtIn                  10
     d fmtLvlIn                      13
      /free
       if top = *null;
         fileP = %alloc(%size(fileP_DS));
         top = fileP;
       else;
         fileP = top;
         dow fileNextP <> *null;
           fileP = fileNextP;
         enddo;
         fileNextP = %alloc(%size(fileP_DS));
         fileP = fileNextP;
       endif;
       fileName = fileIn;
       fileLib = fileLibIn;
       fileRcdFmt = fileRcdFmtIn;
       fileFLI = fmtLvlIn;
       fileNextP = *null;
       return;
      /end-free
     p                 e

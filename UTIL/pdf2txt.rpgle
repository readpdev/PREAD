      *%METADATA                                                       *
      * %TEXT PDF to Text Module                                       *
      *%EMETADATA                                                      *
     h nomain

T7389 * 12-17-08 PLR Force ansi encoding so that PDFs not containing mapping
      *              can be properly extracted regardless. Was extracting the
      *              the unicode default for unknown chars. U+FFFD
5803  * 10-20-06 EPG Dynamically set the TET_options within the
      *              TXT2PDFOPEN procedure based on the PDF
      *              file size.
      * 10-05-06 PLR Moved getUniqueFileName from here to PDFIO.
      * 12-20-05 EPG Replace the calls to %addr with the actual pointer
      *              by initializing the pointer referecenced in the
      *              d specs with inz(%addr(var))
      *              Translate the text only if the character
      *              retrival is not equal to null.
      *              Create a constant for end of page and use this
      *              instead of calculating  the end of page character.
      * 12-19-05 EPG Fix the init process by swapping the parameters
      *              for with width and height.
      * 12-19-05 EPG Pass the address of the current token to
      *              OT_Process_PageFormatter.
      * 12-19-05 EPG Add the necessary code to test the page range
      *              requested againest the actual page range of the PDF
      *              document. Additionally, derive the last page of the
      *              PDF document when -1 is passed.
      * 12-19-05 EPG Add a check for the existance of SpyPath temporary
      *              directory.
      * 12-13-05 PLR Convert PDF to readable text.

      /copy @pdfio
      /copy @osapi
      /copy @tetlib

     d OK              c                   0
     d ERROR           c                   -1
     d TRUE            c                   '1'
     d FALSE           c                   '0'
     d docMgrPath      s            256
     d p_docMgrPath    s               *   inz(%addr(docMgrPath))
     d docMgrPath0     s            256
     d p_docMgrPath0   s               *   inz(%addr(docMgrPath0))

      **************************************************************************
     p PDF2TxtOpen     b                   Export
     d                 pi            10i 0
     d  pdfFile                        *   value options(*string)
     d  fromPage                     10i 0 value
     d  toPage                       10i 0 value
     d  fileHandle                     *

     d getDocMgrPath   pr                  extpgm('SPYPATH')
     d  pathID                       10    const
     d  rtnPath                     256

     d PDFMAXOPEN      c                   16776704
     d LF              c                   x'25'
     d fcPageLength    s              8f   inz(8.5)
     d fcPageWidth     s              8f   inz(11.0)
     d fcLinesPerPage  s             10u 0 inz(68)
     d fcCharsPerLine  s             10u 0 inz(250)
     d EOP             c                   x'D700'
      * End of Page
     d LAST            c                   -1
     d QUOTE           c                   ''''
     d mode            s              2
     d p_mode          s               *   inz(%addr(mode))
     d curToken        s            512
     d p_curToken      s               *   inz(%addr(curToken))

     d curPage         s             10i 0
     d pdfLargeFile    s               n
     d docHandle       s             10i 0
     d pageHandle      s             10i 0
     d pdfTextLen      s             10i 0
     d p_pdfTextLen    s               *   inz(%addr(pdfTextLen))
     d tetFileSize     s             10i 0
     d tetLargeFile    s               n
     d tet             s               *
     d tetOptList      s            255
     d charInfo        ds                  likeds(TET_char_info)
     d                                     based(charInfoP)
     d pdfFileName     s            512
     d cmdOScmd        s           3000a
     d p_DirHdl        s               *
     d rtnOptList      s               *
     d pdfPageOptList  s            256
      * Opaque data structure
     d opaqueDS        ds                  based(opaqueP) qualified
     d  fileName                    250
     d  fileSize                     10i 0
     d  fileOffset                   10i 0
     d  buffer                         *
     d  memAlloc                     10i 0
     d  memUsed                      10i 0
     d  memOffSet                    10i 0
     d pdfTextP        s               *
     d xCoord          s             10i 0

      * Pointer to Open Directory

      /free

       pdfPageOptList =
       'granularity=word '                                                   +
       'contentanalysis={merge=0 punctuationbreaks=false dehyphenate=false ' +
       'shadowdetect=false} '                                                +
       'ignoreinvisibletext=true '                                           +
       'includebox={{-10 0 792 792}}';

       tet=tet_new;
       if tet=*null;
         PDFSetLastError('PDF0006':' ');
         return ERROR;
       endif;

       if PDFStat(pdfFile:%addr(pPdfInfoDS)) <> OK;
         return ERROR;
       endif;

       If frompage = LAST;
         frompage = pi_pages;
       EndIf;

       If topage = LAST;
         topage = pi_pages;
       EndIf;

       If frompage > pi_pages;
         PDFSetLastError('PDF0008':' ');
         return ERROR;
       EndIf;

       If topage > pi_pages;
         PDFSetLastError('PDF0008':' ');
         return ERROR;
       EndIf;

       // get license and search path.
       if validatePDFlicense(tet:LIC_TET) <> OK;
         return ERROR;
       endif;
       tetOptList = 'outputformat=ebcdicutf8' + x'00';
       TET_set_option(tet:tetOptList);

       // Use TETLIB callback function if file is larger that 16MB.
       if st_size <= PDFMAXOPEN;
         PdfLargeFile = FALSE;
         tetOptList = 'glyphmapping {{fontname=* glyphrule={prefix=c ' +
           'base=hex  encoding=winansi} }} inmemory=true' + x'00'; //7389
         pdfFileName = %str(pdfFile) + x'00';
         docHandle = TET_open_document(tet:pdfFileName:0:tetOptList);
       else;
         // 5803 Read the file from Disk if the file is large
         PdfLargeFile = TRUE;                  // 5803
         tetOptList = 'glyphmapping {{fontname=* glyphrule={prefix=c ' +
           'base=hex  encoding=winansi} }}' + x'00'; //7389
         pdfFileName = %str(pdfFile) + x'00';  // 5803
         docHandle = TET_open_document(tet:pdfFileName:0:tetOptList);
       endif;

       if docHandle = ERROR;
         PDFSetLastError('PDF0003':PDFFmtTetErr(tet));
         return ERROR;
       endif;

       // Create an FCFC file containing the text of pages requested.
       getDocMgrPath('*TEMP':docMgrPath);

       // Test for the existing path
       docMgrPath0 = %trimr(docMgrPath) + x'00';
       p_dirHdl = opendir(p_docMgrPath0);

       If p_dirHdl = *NULL;
         cmdOScmd = 'MKDIR DIR(' + QUOTE + %trim(docMgrPath) + QUOTE + ')';
         Callp(e) QCmdExc(cmdOScmd:%len(%trim(cmdOScmd)));
       Else;
         Callp(e) CloseDir(p_dirHdl);
       EndIf;

       docMgrPath = %trim(docMgrPath) + '/' + 'FCFC' +
         %str(getUniqueFileName) + '.txt' + x'00';
       if OT_Init_PageFormatter(fcPageLength:fcPageWidth:
            fcLinesPerPage:fcCharsPerLine:docMgrPath) <> OK;
         p_errno = geterrno();
         PDFSetLastError('API1001':%str(strerror(errno)));
         TET_close_document(tet:docHandle);
         return ERROR;
       endif;

       tetOptlist = %trim(pdfPageOptList) + x'00';
       for curPage = fromPage to toPage;
         pageHandle = TET_open_page(tet:docHandle:curPage:tetOptList);
         if pageHandle = ERROR;
           PDFSetLastError('PDF0003':PDFFmtTetErr(tet));
           TET_close_document(tet:docHandle);
           return ERROR;
         endif;
         // Retrieve the text from pdf and xlate to EBCDIC
         pdfTextP = TET_get_text(tet:pageHandle:p_pdfTextLen);
         dow pdfTextP <> *null;
           charInfoP = TET_get_char_info(tet:page);
           if charInfoP <> *null;
             xCoord = %inth(charInfo.x * 10);
             if xCoord = 0;
               xCoord = 72;
             endif;
             curToken = 'S ' + %trim(%char(xCoord)) + ' ' +
               %trim(%char(%inth(charInfo.y * 10))) +
               ' (' + %str(pdfTextP) + ')' + x'00';
             exsr processPage;
           else;
             leave;
           endif;
           pdfTextP = TET_get_text(tet:pageHandle:p_pdfTextLen);
         enddo;
         curToken = EOP; //end of page
         exsr processPage;
         TET_close_page(tet:pageHandle);
       endfor;
       OT_Finish_PageFormatter();
       TET_close_document(tet:docHandle);
       mode = 'r' + x'00';
       fileHandle = ifsfopen(p_docMgrPath:p_mode);
       if fileHandle = *null;
         p_errno = geterrno();
         PDFSetLastError('API1001':%str(strerror(errno)));
         return ERROR;
       endif;
       return OK;

       //*********************************************************************
       begsr processPage;

         if OT_Process_PageFormatter(p_curToken) <> OK;
           p_errno = geterrno();
           PDFSetLastError('API1001':%str(strerror(errno)));
           OT_Finish_PageFormatter();
           TET_close_page(tet:pageHandle);
           TET_close_document(tet:docHandle);
           return ERROR;
         endif;

       endsr;

      /end-free

     p                 e

      *********************************************************************
      * Return path/name of FCFC file.
     p pdf2TxtGetFCFC  b                   export
     d                 pi              *

      /free
       return %addr(docMgrPath);
      /end-free

     p                 e

      *---------------------------------------------------------------------
     p Pdf2TxtGetLine  b                   Export
      *---------------------------------------------------------------------
      * Return a string at a time from the generated FCFC file
     d                 pi              *
     d  fileHandle                     *   value

     d line            s            255
     d lineP           s               *
     d wrkLine         s            255    based(lineP)

      /free

       lineP = ifsFgets(%addr(line):%size(line):filehandle);
       if lineP <> *null;
         wrkLine = %xlate(x'25':x'00':wrkLIne);
       endif;
       return lineP;

      /end-free

     p                 e

      *---------------------------------------------------------------------
     p Pdf2TxtClose    b                   Export
      *---------------------------------------------------------------------
     d                 pi            10i 0
     d  fileHandle                     *   value

      /free

       ifsfclose(fileHandle);
       unlink(docMgrPath);
       return OK;

      /end-free

     p                 e

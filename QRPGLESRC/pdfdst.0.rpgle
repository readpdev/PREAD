     h nomain

      /copy @pdfio
      /copy @pdflibi

     d outHndl         s               *
     d outPath         s            256
     d pdiInp          s             10i 0
     d optList         s             50    inz(x'00')
     d adjustpage      s             11
     d zero            s             10i 0 inz(0)

      **************************************************************************
     p PDF_dst_init    b                   export
     d                 pi
     d  fh                           10i 0

     d spyPath         pr                  extpgm('SPYPATH')
     d  pathID                       10    const
     d  rtnPath                     256

     d fileID          ds            16    qualified
     d  rsrvd                         8    inz(*allx'00')
     d  path                         10u 0
     d  name                         10u 0

     d rtnCde          s             10i 0
     d sourceFile      s            256

      /free
       adjustpage = 'adjustpage' + x'00';
       spyPath('*TEMP':outPath);
       outPath = %trim(outPath) + '/' + %trim(%str(getUniqueFileName)) +
         '.pdf' + x'00';
       outHndl = PDF_new;
       optList = 'errorpolicy=exception' + x'00';
       validatePDFLicense(outHndl:LIC_PPS);
       PDF_begin_document(outHndl:outPath:0:optList);
       fstat(fh:%addr(stat_ds));
       fileID.path = st_ino_gen;
       fileID.name = st_ino;
       getPath(%addr(sourceFile):%size(sourceFile):%addr(fileID));
       sourceFile = %trimr(sourceFile) + x'00';
       pdiInp = PDF_open_pdi(outHndl:sourceFile:optList:0);
       return;
      /end-free
     p                 e

      **************************************************************************
     p PDF_dst_...
     p add_page        b                   export
     d                 pi
     d  pageNbr                      10i 0 value

     d pageI           s             10i 0

      /free
       pageI = PDF_open_pdi_page(outHndl:pdiInp:pageNbr:optList);
       PDF_begin_page(outHndl:20:20);
       PDF_fit_pdi_page(outHndl:pageI:zero:zero:adjustpage);
       PDF_close_pdi_page(outHndl:pageI);
       PDF_end_page(outHndl);
       return;
      /end-free
     p                 e

      **************************************************************************
     p PDF_dst_...
     p get_fileName    b                   export
     d                 pi           256
      /free
       return outPath;
      /end-free
     p                 e

      **************************************************************************
     p PDF_dst_close   b                   export
     d                 pi
      /free
       optList = x'00';
       PDF_close_pdi(outHndl:pdiInp);
       PDF_end_document(outHndl:optList);
       return;
      /end-free
     p                 e

      **************************************************************************
     p PDF_dst_quit    b                   export
     d                 pi
      /free
       PDF_delete(outHndl);
       unlink(outPath);
       clear pdiInp;
       clear outPath;
       return;
      /end-free
     p                 e

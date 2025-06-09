      *%METADATA                                                       *
      * %TEXT Test PDI api's                                           *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp('DOCMGR') bnddir('PDFLIBI')
      /copy @pdfio
      /copy @pdflibi
     d rtnCde          s             10i 0
     d inpP            s               *
     d outP            s               *
     d inpI            s             10i 0
     d outI            s             10i 0
     d inpFile         s             50
     d outFile         s             50
     d optList         s              2    inz
     d pageI           s             10i 0
     d rtvPage         s             10i 0 inz(1)
     d zero            s             10i 0 inz(0)
     d adjustpage      s             11
     d i               s             10i 0
      /free
       inpFile = '/home/pread/PDF0001.pdf' + x'00';
       outFile = '/home/pread/pdfout.pdf' + x'00';
       optList = ' ' + x'00';
       outP = PDF_new;
       rtnCde = validatePDFLicense(outP:LIC_PPS);
       rtnCde = PDF_open_file(outP:outFile);
       inpI = PDF_open_pdi(outP:inpFile:optList:0);
       for i = 50 to 70 by 10;
         pageI = PDF_open_pdi_page(outP:inpI:i:optList);
         PDF_begin_page(outP:20:20);
         adjustpage = 'adjustpage' + x'00';
         PDF_fit_pdi_page(outP:pageI:zero:zero:adjustpage);
         PDF_close_pdi_page(outP:pageI);
         PDF_end_page(outP);
       endfor;
       PDF_close(outP);
       *inlr = '1';
      /end-free

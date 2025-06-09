     h dftactgrp(*no) actgrp(*caller) bnddir('PDFLIBI')

      /copy @pdfio

     d sourceFile      s             50
     d i               s             10i 0
     d workFile        s            256

      /free
       sourceFile = '/home/pread/pdf0001.pdf' + x'00';
       PDF_dst_init(sourceFile);
       for i = 50 to 70 by 10;
         PDF_dst_add_page(i);
       endfor;
       PDF_dst_close();
       workFile = PDF_dst_get_fileName();
       PDF_dst_quit();
       unlink(workFile);
       *inlr = '1';
      /end-free

      *%METADATA                                                       *
      * %TEXT Fix missing batch header record.                         *
      *%EMETADATA                                                      *
     h dftactgrp(*no)
      *
      * Add missing image file batch header.
      *
     fmimgdir   if   e           k disk
     fimgfil    uf   f 1024        disk    usropn

     d imgdirDS        ds                  likerec(imgdir)
     d imgfilDS        ds          1024

     d run             pr                  extproc('system')
     d  cmd                            *   value options(*string:*trim)

     d msg             s             50
     d sqlStmt         s           5000
     d sq              c                   ''''

     c     *entry        plist
     c                   parm                    inBatchID        10

      /free
       *inlr = *on;

       chain (inBatchID) mimgdir imgdirDS;
       if not %found;
         msg = inBatchID + ' not found in MIMGDIR!';
         dsply msg;
         return;
       endif;

       run('ovrdbf imgfil ' +  imgdirDS.idpfil + ' ovrscope(*job)');

       open imgfil;
       run('dltovr imgfil lvl(*job)');

       chain imgdirDS.idbbgn imgfil imgfilDS;
       if not %found;
         msg = 'Batch start location not found in ' + imgdirDS.idpfil;
         dsply msg;
         close(e) imgfil;
         return;
       endif;

       imgfilDS = imgdirDS;
       update(e) imgfil imgfilDS;

       if %error;
         msg = 'Error: Header not updated @ ' + imgdirDS.idpfil + '/' +
           %char(imgdirDS.idbbgn);
       else;
         msg = 'Header updated @ ' + imgdirDS.idpfil + '/' +
           %char(imgdirDS.idbbgn);
       endif;

       dsply msg;

       close(e) imgfil;
       return;

      /end-free

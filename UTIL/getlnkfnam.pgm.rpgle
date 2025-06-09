      *
      * Report configuration master keyed by docClass Name.
      * Chaining to this file will return the key to the link definition file.
     frmaint4   if   e           k disk

      * Link definition file keyed by "big5" fields.
      * This file contains the name of the link file (@ sign file name).
     frlnkdef   if   e           k disk

     c     lnkDefKey     klist
     c                   kfld                    rrnam
     c                   kfld                    rjnam
     c                   kfld                    rpnam
     c                   kfld                    runam
     c                   kfld                    runam

     c     *entry        plist
     c                   parm                    docClassIn       10
     c                   parm                    lnkFileOut       10

      /free
       chain docClassIn rmaint4;
       if %found;
         chain lnkDefKey rlnkdef;
         if %found;
           lnkFileOut = lnkfil;
         endif;
       endif;
       *inlr = '1';
      /end-free

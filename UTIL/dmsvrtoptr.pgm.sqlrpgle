      *%METADATA                                                       *
      * %TEXT Setup and execute copy to virtual optical                *
      *%EMETADATA                                                      *

      * Constants
     d OK              c                   '1'
     d Q               c                   ''''

      * Functions
     d run             pr            10i 0
     d  cmd                            *   value options(*string)
     d imageCatalog    pr            10i 0
     d prepDclOpen     pr
     d closeCursor     pr
     d spm             pr
     d  msgdta                       80    value
     d  stackTgt                     10i 0 value options(*nopass)
     d rmvMsgs         pr
     d crtDevVryOn     pr            10i 0
     d cleanUp         pr

      * Global variables.
     d sqlStmt         s            512
     d                sds
     d thisPgmLib             81     90
     d rc              s               n

     c     *entry        plist
     c                   parm                    docMgrPgmLib     10
      /free
       cleanUp();
       if rc = (setUpEnv() = OK);
         if rc and rc = (imageCatalog() = OK);

         endif;
       endif;
       *inlr = '1';
      /end-free

      **************************************************************************
     p prepDclOpen     b
      /free
       exec sql prepare stmt from :sqlStmt;
       exec sql declare csr01 cursor for stmt;
       exec sql open csr01;
       return;
      /end-free
     p                 e

      **************************************************************************
     p closeCursor     b
      /free
       exec sql close csr01;
       return;
      /end-free
     p                 e

      **************************************************************************
     p setupEnv        b
     d                 pi            10i 0
     d rc              s             10i 0 inz(OK)
      /free
       rc = run('chkobj ' + %trim(docMgrPgmLib) + ' *lib');
       if rc <> OK;
         spm('Library ' + %trim(docMgrPgmLib) + ' not found');
       endif;
       if rc = OK and rc = run('addlible ' + %trim(docMgrPgmLib)) and rc <> OK;
         spm('Error adding ' + %trim(docMgrPgmLib) + ' to library list');
       endif;
       return rc;
      /end-free
     p                 e

      **************************************************************************
     p crtDevVryOn     b
     d                 pi
     d rc              s             10i 0
      /free
       rc = run('CRTDEVOPT DEVD(DMSVRTOPT) RSRCNAME(*VRT)');
       if rc <> OK;
         spm('Error creating device DMSVRTOPT');
       endif;
       if rc = OK;
         rc = run('VRYCFG CFGOBJ(DMSVRTOPT) CFGTYPE(*DEV) STATUS(*ON)');
         if rc <> OK;
           spm('Error varying on device DMSVRTOPT');
         endif;
       endif;
       return rc;
      /end-free
     p                 e

      **************************************************************************
     p cleanUp         b
      /free
       run('VRYCFG CFGOBJ(DMSVRTOPT) CFGTYPE(*DEV) STATUS(*OFF)');
       run('DLTDEVD DEVD(DEVVRTOPT)');
       run('LODIMGCLG IMGCLG(IMGCLG) DEV(DMSVRTOPT) OPTION(*UNLOAD)');
       run('DLTIMGCLG IMGCLG(DMSVRTOPT) KEEP(*NO)');
       run('RMVLNK ' + Q + '/DMSVRTOPT' + Q);
      /end-free
     p                 e
      **************************************************************************
     p imageCatalog    b
     d                 pi            10i 0
     d rc              s             10i 0 inz(0)
      /free
       rc = run('CRTIMGCLG IMGCLG(DMSVRTOPT) DIR(' + Q + '/DMSVRTOPT)' + Q);
       sqlStmt = 'select distinct(optvol) from mopttbl';
       prepDclOpen();
       return rc;
      /end-free
     p                 e

      **************************************************************************
     p run             b
     d                 pi            10i 0
     d cmd                             *   value options(*string)

     d qcmdexc         pr                  extpgm('QCMDEXC')
     d  cmd                         256    const
     d  cmdLen                       15  5 const

      /free
       callp(e) qcmdexc(cmdTgt:%len(%str(cmd)));
       if %error;
         return -1;
       endif;
       return 0;
      /end-free
     p                 e

      **************************************************************************
     p spm             b

      // Send program message.

     d                 pi
     d  msgdta                       80    value
     d  stackTgt                     10i 0 value options(*nopass)

     d msgf            s             20    inz('QCPFMSG   *LIBL')
     d msgdtalen       s             10i 0 inz(0)
     d stackCnt        s             10i 0 inz(0)
     d aTimeStamp      s               z

      /FREE
       msgDtaLen = %len(%trimr(msgdta));

       if %parms > 1;
         stackCnt = stackTgt;
       endif;

      /END-FREE
     c                   call      'QMHSNDPM'
     C                   parm      'CPF9898'     msgid             7
     c                   parm                    msgf
     c                   parm                    msgdta
     c                   parm                    msgdtalen
     c                   parm      '*INFO'       msgtype          10
     c                   parm                    pgmq
     c                   parm                    stackcnt
     c                   parm      ' '           msgkey            4
     c                   parm      ' '           apierr

      /FREE
       if run('CHKOBJ':thisPgmLib:'DOCMIGLOG':'*FILE') = OK;
         aTimeStamp = %timestamp();
         exec sql insert into docmiglog (ml_msg, ml_usr, ml_time)
           values(:msgdta, :curUser, :aTimeStamp);
       endif;

       return;

      /END-FREE
     p                 e

      **************************************************************************
     p rmvMsgs         b

     d stackCnt        s             10i 0 inz(0)

      // remove program messages.
      /free
       for stackcnt = 0 to 10;
      /end-free
     c                   call      'QMHRMVPM'
     c                   parm      '*'           stack            10
     c                   parm                    stackcnt
     c                   parm      ' '           msgkey
     c                   parm      '*ALL'        msgtype          10
     c                   parm                    apierr
      /FREE
       endfor;

       return;

      /END-FREE
     p                 e


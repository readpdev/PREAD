     h dftactgrp(*no)

     fcommands  uf   e             disk

      /copy qsysinc/qrpglesrc,qusec

     d cmdi            pr                  extpgm('QCDRCMDI')
     d  receiver                           like(rcvr)
     d  recvrlen                           like(rcvrlen)
     d  formatName                         like(format)
     d  qualifiedName                      like(qualCmd)
     d  apierr                             like(qusec)
     d rcvr            ds           314
     d  processPgm                   10    overlay(rcvr:29)
     d  textDesc                     50    overlay(rcvr:265)
     d rcvrlen         s             10i 0 inz(%size(rcvr))
     d format          s              8    inz('CMDI0100')
     d qualCmd         s             20    inz

     c     *entry        plist
     c                   parm                    qualLib          10
     c                   move      qualLib       qualCmd

     c                   dow       1 = 1

     c                   read      commands
     c                   if        %eof
     c                   leave
     c                   endif

      * Retrieve command attributes from old command object for new command obje
     c                   movel     oldcmd        qualCmd
     c                   callp     cmdi(rcvr:rcvrlen:format:qualCmd:qusec)
     c                   eval      newcmd = processPgm
     c                   update    cmdrec

     c                   enddo

     c                   eval      *inlr = '1'


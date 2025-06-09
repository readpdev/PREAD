      *%METADATA                                                       *
      * %TEXT Change default command library                           *
      *%EMETADATA                                                      *
      * CRTOPT TGTRLS(*CURRENT)
     fqadspobj  if   e             disk
     fqsysprt   o    f  132        printer

     d rcvr            ds            48
     d  cmdName                      10    overlay(rcvr:9)
     d  cmdLib                       10    overlay(rcvr:*next)
     d  pgmName                      10    overlay(rcvr:*next)
     d  pgmLib                       10    overlay(rcvr:*next)
     d rcvrLen         s             10i 0 inz(%size(rcvr))
     d cmdNameInp      ds            20
     d  odobnm
     d  odlbnm

     c                   dow       1 = 1
     c                   read      qadspobj
     c                   if        %eof
     c                   leave
     c                   endif
     c                   call      'QCDRCMDI'
     c                   parm                    rcvr
     c                   parm                    rcvrLen
     c                   parm      'CMDI0100'    format            8
     c                   parm                    cmdNameInp
     c                   parm                    error           116
     c*                  eval      cmd = 'CHGCMD CMD(' + %trimr(cmdLib) + '/' +
     c*                            %trimr(cmdName) + ') PGM(' + '*LIBL/' +
     c*                            %trimr(pgmName) + ')'
     c*                  call      'QCMDEXC'
     c*                  parm                    cmd              80
     c*                  parm      80            cmdLen           15 5
     c                   except
     c                   enddo

     c                   eval      *inlr = '1'

     oqsysprt   e                           1
     o                                              'CMD: '
     o                       cmdname
     o                                              '  PGM: '
     o                       pgmname

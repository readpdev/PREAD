      *%METADATA                                                       *
      * %TEXT Remove *ALL program messages                             *
      *%EMETADATA                                                      *
     p rmvmsgs         b

     d                 pi
     d stack                         10i 0 value options(*nopass)

     d stackcnt        s             10i 0

     c                   if        stack = *null
     c                   eval      stackcnt = 1
     c                   else
     c                   eval      stackcnt = stack
     c                   endif

      * remove program messages.
     c                   call      'QMHRMVPM'
     c                   parm      '*'           stack
     c                   parm                    stackcnt         10
     c                   parm      ' '           msgkey
     c                   parm      '*ALL'        msgtype          10
     c                   parm                    apierr

     c                   return

     p                 e

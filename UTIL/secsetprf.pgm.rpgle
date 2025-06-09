      *%METADATA                                                       *
      * %TEXT Set Profile for Security Regression                      *
      *%EMETADATA                                                      *
     c     *entry        plist
     c                   parm                    user             10
     c                   parm                    pwd              10

     c                   call      'QSYGETPH'
     c                   parm                    user
     c                   parm                    pwd
     c                   parm                    handle           12

     c                   call      'QWTSETP'
     c                   parm                    handle

     c                   eval      *inlr = '1'

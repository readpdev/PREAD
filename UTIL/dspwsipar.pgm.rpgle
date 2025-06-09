     d devd0600        ds           892
     d  ipaddress                    15    overlay(devd0600:878)
     d rcvrLen         s             10i 0 inz(%size(devd0600))
     d format          s              8    inz('DEVD0600')
     d device          s             10

     D APIERR          DS
     D  ERBYTPRV                     10I 0 INZ(%SIZE(APIERR))
     D  ERBYTAVL                     10I 0
     D  ERMSGID                       7A
     D  ERRSV1                        1A
     D  ERMSGDATA                    80A

     d msgf            s             20    inz('QCPFMSG   *LIBL')
     d msgdtalen       s             10i 0 inz(80)
     d stackcnt        s             10i 0 inz(1)
     d stackptr        s               *

     c     *entry        plist
     c                   parm                    device

     c                   call      'QDCRDEVD'
     c                   parm                    devd0600
     c                   parm                    rcvrLen
     c                   parm                    format
     c                   parm                    device
     c                   parm                    apierr

     c                   if        erbytavl = 0
     c                   eval      msgid = 'CPF9898'
     C                   eval      msgdta = device + '=' + ipaddress
     c                   endif

     C                   CALL      'QMHSNDPM'
     C                   PARM                    MSGID             7
     C                   PARM                    MSGF
     C                   PARM                    MSGDTA           80
     C                   PARM                    MSGDTALEN
     C                   PARM      '*INFO'       MSGTYPE          10
     C                   PARM      '*'           STACK            10
     C                   PARM      2             STACKCNT
     C                   PARM      ' '           MSGKEY            4
     C                   PARM      ' '           APIERR

     c                   eval      *inlr = '1'

J2603 * 05-03-10 PLR Rolled back from 8.8. No changes needed as it did not exist
      *              in this release (8.7.4).
     dGetSplSize       pr            10i 0
     d pSplFile                      10a   const
     d pQualJob                      26a   const
     d pIntJobId                     16a   const
     d pIntSplId                     16a   const
     d pSplNbr                       10i 0 const
     d pSplSize                      15p 0
     d pSplPages                     10i 0

     dGetSplValid      pr            10i 0
     d pSplFile                      10a   const
     d pQualJob                      26a   const
     d pIntJobId                     16a   const
     d pIntSplId                     16a   const
     d pSplNbr                       10i 0 const
     d pSplValid                      1n
     d pErrorCode                     7a

     d SCS             c                   '*SCS'
     d IPDS            c                   '*IPDS'
     d USERASCII       c                   '*USERASCII'
     d AFPDS           c                   '*AFPDS'
     d LINE            c                   '*LINE'
     d AFPDSLINE       c                   '*AFPDSLINE'

     d APFENABLED      c                   'Y'
     d APFTEXTONLY     c                   'P'
     d APFNOTENABLED   c                   'N'

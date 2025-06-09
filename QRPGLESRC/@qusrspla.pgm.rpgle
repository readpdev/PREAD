J2603 * 05-03-10 PLR Rolled back from 8.8. No changes needed as it did not exist
      *              in this release (8.7.4).
/1570d UsrSpla         pr                  ExtPgm('QUSRSPLA')
     d  pRcvVar                    8192    options(*varsize)
     d  pRcvLen                      10i 0 const
     d  pFormat                       8a   const
     d  pQualJob                     26a   const
     d  pIntJobId                    16    const
     d  pIntSplId                    16    const
     d  pSplFilName                  10    const
     d  pSplFilNbr                   10i 0 const
     d  pErrorCode                 1024a   options(*nopass:*varsize)

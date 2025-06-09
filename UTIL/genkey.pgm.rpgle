      *%METADATA                                                       *
      * %TEXT Generate keycode. Used by VARPG client.                  *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR')

      * MD5 HASHING ALGORITHM PROTOTYPE.
     D MD5HASH         PR                  EXTPROC('MD5Hash')
     D  PKEY                      32767A   OPTIONS(*VARSIZE)
     D  IKEYLEN                      10I 0 VALUE
     D  PDATA                     32767A   OPTIONS(*VARSIZE)
     D  idataLEN                     10I 0 VALUE
     D  DIGEST                       16A

     d pdatalen        s             10i 0

     c     *entry        plist
     c                   parm                    skmsid           12
     c                   parm                    pdata          4048
     c                   parm                    skmkcd           16

      * ENCRYPT THE KEY.
     C                   EVAL      PDATALEN = %LEN(%TRIM(pdata))
     C                   CALLP     MD5HASH(SKMSID:%SIZE(SKMSID):pdata:
     C                             %LEN(%TRIM(pdata)):SKMKCD)

      * ENCRYPT THE KEY.
     C                   CALLP     MD5HASH(SKMSID:%size(skmsid):PDATA:
     C                             %LEN(%TRIM(PDATA)):SKMKCD)

     C                   EVAL      *inlr = '1'

     h dftactgrp(*no) actgrp(*caller)

      *copy @keycodsrv
      *
T7285 * 10-14-08 PLR Created. Keycode webservice copy member.
      *
     d customerName_t  s             40
     d systemID_t      s             12
     d platform_t      s              5
     d sequenceNumber_t...
     d                 s             10i 0
     d version_t       s             10i 0

     d master        e ds                  extname(SPYKEYMST) qualified
     d platform      e ds                  extname(SPYKEYPFM) qualified
     d version       e ds                  extname(SPYKEYVER) qualified
     d product       e ds                  extname(SPYKEYPRD) qualified
     d licensed      e ds                  extname(SPYKEYLIC) qualified
     d tif           e ds                  extname(SPYKEYTIF) qualified

     d message_t       ds                  qualified
     d  returnCode                   10i 0
     d  text                         80

     d customer_t      ds                  qualified
     d  name                               like(master.skmnam)
     d  systemID                           like(master.skmsid)
     d  sequence                     10i 0
     d  platform                           like(master.skmpfm)
     d  version                      10i 0

     d customerInfo_t  ds                  qualified
     d  name                               like(master.skmnam)
     d  systemID                           like(master.skmsid)
     d  sequence                     10i 0
     d  platform                           like(master.skmpfm)
     d  version                      10i 0
     d  model                              like(master.skmmdl)
     d  featureCode                        like(master.skmftr)
     d  demoDate_deprecated...
     d                               10i 0
     d  keyCode                      32
     d  customerRecordFlag...
     d                                1
     d  logicalPartition...
     d                               10i 0

     d product_t       ds                  qualified
     d  id                           10i 0
     d  description                        like(product.skpdsc)
     d  userBased                          like(product.skputl)

     d productAttributes_t...
     d                 ds                  qualified
     d  selected                      3
     d  expiryDate                   10i 0
     d  nbrUsrLic                    10i 0
     d  thirdPartyKey                32
     d  thirdPartyID                       like(tif.sktsvr)

     d customerProducts_t...
     d                 ds                  qualified
     d product                             likeds(product_t)
     d attribute                           likeds(productAttributes_t)

     d searchResponse_t...
     d                 ds                  qualified
     d  customer                           likeds(customer_t) dim(100)
     d  message                            likeds(message_t)

     d platformList_t  ds                  qualified
     d  platform                           like(platform_t) dim(10)
     d  message                            likeds(message_t)

     d versionList_t   ds                  qualified
     d  version                            like(version_t) dim(50)
     d  message                            likeds(message_t)

     d productList_t   ds                  qualified
     d  product                            likeds(product_t) dim(20)
     d  message                            likeds(message_t)

     d keycodeObject_t...
     d                 ds                  qualified
     d  customerInfo                       likeds(customerInfo_t)
     d  products                           likeds(customerProducts_t) dim(20)
     d  message                            likeds(message_t)

     d search          pr
     d  nameOrSystemID...
     d                               25    const
     d  searchResponse...
     d                                     likeds(searchResponse_t)

     d getPlatformList...
     d                 pr
     d  platformList                       likeds(platformList_t)

     d getVersionList  pr
     d  platformCode                  5    const
     d  versionList                        likeds(versionList_t)

     d getProductList  pr
     d  platFormCode                  5    const
     d  versionCode                  10i 0 const
     d  productList                        likeds(productList_t)

     d addKeycodeObject...
     d                 pr
     d  keycodeObject                      likeds(keycodeObject_t)

     d getKeyCodeObject...
     d                 pr
     d  systemID                           const like(systemID_t)
     d  sequenceNumber...
     d                                     const like(sequenceNumber_t)
     d  keyCodeObject                      likeds(keycodeObject_t)

     d updateKeycodeObject...
     d                 pr
     d  keyCodeObject                      likeds(keycodeObject_t)

     d setCursor       pr            10i 0
     d  sqlStmt                     512    value
     d  message

     d OK              c                   0
     d ERROR           c                   -1
     d                sds
     d pgmLib                 81     90

     d rc              s             10i 0 inz(OK)
     d i               s             10i 0 inz(0)
     d x               s             10i 0 inz(0)
     d licensedProds   ds                  likeds(licensed) dim(20)
     d maxProds        s             10i 0 inz(%elem(licensedProds))
     d productList     ds                  likeds(productList_t)
     d keycodeObject   ds                  likeds(keycodeObject_t)
     D*      SQL COMMUNICATION AREA                                             SQL
     D SQLCA           DS                                                       SQL
     D  SQLCAID                       8A   INZ(X'0000000000000000')             SQL
     D  SQLAID                        8A   OVERLAY(SQLCAID)                     SQL
     D  SQLCABC                      10I 0                                      SQL
     D  SQLABC                        9B 0 OVERLAY(SQLCABC)                     SQL
     D  SQLCODE                      10I 0                                      SQL
     D  SQLCOD                        9B 0 OVERLAY(SQLCODE)                     SQL
     D  SQLERRML                      5I 0                                      SQL
     D  SQLERL                        4B 0 OVERLAY(SQLERRML)                    SQL
     D  SQLERRMC                     70A                                        SQL
     D  SQLERM                       70A   OVERLAY(SQLERRMC)                    SQL
     D  SQLERRP                       8A                                        SQL
     D  SQLERP                        8A   OVERLAY(SQLERRP)                     SQL
     D  SQLERR                       24A                                        SQL
     D   SQLER1                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER2                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER3                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER4                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER5                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER6                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLERRD                     10I 0 DIM(6)  OVERLAY(SQLERR)              SQL
     D  SQLWRN                       11A                                        SQL
     D   SQLWN0                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN1                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN2                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN3                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN4                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN5                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN6                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN7                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN8                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN9                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWNA                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D  SQLWARN                       1A   DIM(11) OVERLAY(SQLWRN)              SQL
     D  SQLSTATE                      5A                                        SQL
     D  SQLSTT                        5A   OVERLAY(SQLSTATE)                    SQL
     D*  END OF SQLCA                                                           SQL
     D  SQLROUTE       C                   CONST('QSYS/QSQROUTE')               SQL
     D  SQLOPEN        C                   CONST('QSYS/QSQLOPEN')               SQL
     D  SQLCLSE        C                   CONST('QSYS/QSQLCLSE')               SQL
     D  SQLCMIT        C                   CONST('QSYS/QSQLCMIT')               SQL
     D  SQFRD          C                   CONST(2)                             SQL
     D  SQFCRT         C                   CONST(8)                             SQL
     D  SQFOVR         C                   CONST(16)                            SQL
     D  SQFAPP         C                   CONST(32)                            SQL
     D                 DS                                                       SELECT
     D  SQL_00000              1      2B 0 INZ(128)                             length of header
     D  SQL_00001              3      4B 0 INZ(2)                               statement number
     D  SQL_00002              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00003              9      9A   INZ('0')                             data is okay
     D  SQL_00004             10    128A                                        end of header
     D  SQL_00005            129    168A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00006            169    180A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00007            181    184I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00008            185    189A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00009            190    193I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00010            194    197A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00011            198    201A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00012            202    205I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00013            206    237A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00014            238    238A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00015            239    242I 0                                      KEYCODEOBJECT.CUSTOM
     D                 DS                                                       FETCH
     D  SQL_00016              1      2B 0 INZ(128)                             length of header
     D  SQL_00017              3      4B 0 INZ(3)                               statement number
     D  SQL_00018              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00019              9      9A   INZ('0')                             data is okay
     D  SQL_00020             10    127A                                        end of header
     D  SQL_00021            128    128A                                        end of header
     D                 DS                                                       CLOSE
     D  SQL_00022              1      2B 0 INZ(128)                             length of header
     D  SQL_00023              3      4B 0 INZ(4)                               statement number
     D  SQL_00024              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00025              9      9A   INZ('0')                             data is okay
     D  SQL_00026             10    127A                                        end of header
     D  SQL_00027            128    128A                                        end of header
     D                 DS                                                       OPEN
     D  SQL_00028              1      2B 0 INZ(128)                             length of header
     D  SQL_00029              3      4B 0 INZ(6)                               statement number
     D  SQL_00030              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00031              9      9A   INZ('0')                             data is okay
     D  SQL_00032             10    127A                                        end of header
     D  SQL_00033            128    128A                                        end of header
      /free
       reset keycodeObject;
       //*exec sql select * into :keycodeObject.customerInfo from
       //*  spykeylib/spykeymst where skmsid = '105BL9M' and
       //*  skmis# = 1;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   2
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00000                      SQL
     C     SQL_00003     IFEQ      '1'                                          SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.NAME              SQL
     C                              = SQL_00005                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.SYSTEMID          SQL
     C                              = SQL_00006                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.SEQUENCE          SQL
     C                              = SQL_00007                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.PLATFORM          SQL
     C                              = SQL_00008                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.VERSION           SQL
     C                              = SQL_00009                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.MODEL             SQL
     C                              = SQL_00010                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.FEATURECODE       SQL
     C                              = SQL_00011                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.DEMODATE_DEPRE... SQL
     C                             CATED = SQL_00012                            SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.KEYCODE           SQL
     C                              = SQL_00013                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.CUSTOMERRECORD... SQL
     C                             FLAG = SQL_00014                             SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMERINFO.LOGICALPARTITION  SQL
     C                              = SQL_00015                                 SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       // Get list of available products for platform/version;
       getProductList(keycodeObject.customerInfo.platform:
         keycodeObject.customerInfo.version:productList);
       reset keycodeObject.products;
       rc = setCursor('select * from ' + %trimr(pgmLib) + '/spykeylic where ' +
         'sklsid = ' + sq + %trim(keycodeObject.systemID) + sq +
         ' and sklis# = ' + %trim(%char(keycodeObject.sequenceNumber))) <> OK;
       if rc = OK;
         reset licensedProds;
       //*  exec sql fetch csr for :maxProds rows into :licensedProds;
      /END-FREE                                                                 SQL
     C                   EVAL      SQLER5       = MAXPRODS                      SQL
     C                   Z-ADD     -4            SQLER6                         SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00016                      SQL
     C                   PARM                    LICENSEDPRODS                  SQL
      /FREE                                                                     SQL
       //*  exec sql close csr;
      /END-FREE                                                                 SQL
     C                   Z-ADD     4             SQLER6                         SQL
     C     SQL_00024     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00022                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00022                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         for x = 1 to maxProds;
           if licensedProds(x).sklsid = ' ';
             leave;
           endif;
           keycodeObject.products(x).product.id = licensedProds.sklprd;
           i = %lookup(licensedProds.sklprd:
             keycodeObject.products.product.id);
           keycodeObject.products(x).product.description = description;
         endfor;
       endif;
       *inlr = '1';
       return;
      /end-free
      //************************************************************************
     p setCursor       b
     d                 pi            10i 0
     d sqlStmtIn                    512    const
     d rc              s             10i 0 inz(OK)
      /free
       //*exec sql prepare stmt from :sqlStmtIn;
      /END-FREE                                                                 SQL
     C                   Z-ADD     5             SQLER6                         SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQLSTMTIN                      SQL
      /FREE                                                                     SQL
       if sqlcod = OK;
       //*  exec sql declare csr cursor for stmt;
       endif;
       if sqlcod = OK;
       //*  exec sql open csr;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00030     IFEQ      0                                            SQL
     C     SQL_00031     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00028                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00028                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       endif;
       if sqlcod <> OK;
           %subst(%editc(%abs(sqlcod):'X'):6:4):sqlerm));
         rc = ERROR;
       endif;
       return rc;
      /end-free
     p                 e

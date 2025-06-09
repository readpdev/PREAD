      *%METADATA                                                       *
      * %TEXT Keycode Webservice Application                           *
      *%EMETADATA                                                      *
     h nomain

      *copy @keycodsrv
      *
T7285 * 10-14-08 PLR Created. Keycode webservice copy member.
      *
     d customerName_t  s             40
     d platform_t      s              5
     d sequenceNumber_t...
     d                 s             10i 0
     d version_t       s             10i 0
     d TIFFVIEWERID    c                   12

     d master        e ds                  extname(SPYKEYMST) qualified
     d platform      e ds                  extname(SPYKEYPFM) qualified
     d version       e ds                  extname(SPYKEYVER) qualified
     d product       e ds                  extname(SPYKEYPRD) qualified
     d licensed      e ds                  extname(SPYKEYLIC) qualified
     d tif           e ds                  extname(SPYKEYTIF) qualified
     d history       e ds                  extname(SPYKEYHIS) qualified

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
     d  platform                           like(master.skmpfm)
     d  sequence                     10i 0
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

     d product_t       ds                  qualified inz
     d  id                           10i 0
     d  description                        like(product.skpdsc)
     d  userBased                          like(product.skputl)
     d  selected                      1    inz('N')
     d  expiryDateISO                10i 0
     d  nbrUsrLic                    10i 0
     d  thirdPartyKey                32
     d  thirdPartyID                       like(tif.sktsvr)

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

     d keycodeObject_t...
     d                 ds                  qualified
     d  customer                           likeds(customerInfo_t)
     d  products                           likeds(product_t) dim(20)
     d  message                            likeds(message_t)

     d history_t       ds                  qualified
     d  date                         10i 0
     d  time                         10i 0
     d  user                         10
     d  key                          25
     d  valueFrom                    12
     d  valueTo                      12
     d  version                      10i 0

     d historyReturn_t...
     d                 ds                  qualified
     d  hist                               likeds(history_t) dim(50)
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

     d addKeycodeObject...
     d                 pr
     d  keycodeObject                      likeds(keycodeObject_t)

     d getKeyCodeObject...
     d                 pr
     d  systemID                           const like(master.skmsid)
     d  sequenceNumber...
     d                                     const like(sequenceNumber_t)
     d  keyCodeObject                      likeds(keycodeObject_t)

     d updateKeycodeObject...
     d                 pr
     d  keyCodeObject                      likeds(keycodeObject_t)

     d getHistory      pr
     d  systemID                           like(master.skmsid) const
     d  sequence                           like(sequenceNumber_t) const
     d  historyReturn                      likeds(historyReturn_t)

     d OK              c                   0
     d ERROR           c                   -1
     d WARNING         c                   -2
     d SQ              c                   ''''
     d SQLEOF          c                   100
     d NOEXPIRE        c                   99999999

     d setCursor       pr            10i 0
     d  sqlStmt                     512    value
     d  message                            likeds(message_t)

     d setMessage      pr
     d  messageDS                          likeds(message_t)
     d  returnCode                         like(message_t.returnCode) const
     d  text                         80    const

     d rtvMsg          pr            80
     d  msgID                         7    const
     d  msgDta                      100    const

     d getProductList  pr
     d  keycodeObject                      likeds(keycodeObject_t)

     d setProductAttr  pr            10i 0
     d keycodeObject
     d                                     likeds(keycodeObject_t)

     d cvthc           pr                  extproc('cvthc')
     d  rcv                            *   value
     d  src                            *   value
     d  rcvlen                       10i 0 value

     d validateKeycodeObject...
     d                 pr            10i 0
     d keycodeObject                       likeds(keycodeObject_t)

     d doHistory       pr            10i 0
     d  keyObjFrom                         likeds(keycodeObject_t)
     d  keyObjTo                           likeds(keycodeObject_t)

     d writeHistory    pr
     d dataKey                             like(history.skhdky) const
     d fromVal                             like(history.skhcfr) const
     d toVal                               like(history.skhcto) const

     d generateKeyCode...
     d                 pr
     d keycodeObject                       likeds(keycodeObject_t)

     d checkProductVersion...
     d                 pr            10i 0
     d version                             like(customer_t.version)
     d platform                            like(customer_t.platform)
     d productID                           like(product_t.id)

     d                sds
     d pgmLib                 81     90
     d curUser               254    263

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
     D                 DS                                                       FETCH
     D  SQL_00000              1      2B 0 INZ(128)                             length of header
     D  SQL_00001              3      4B 0 INZ(5)                               statement number
     D  SQL_00002              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00003              9      9A   INZ('0')                             data is okay
     D  SQL_00004             10    128A                                        end of header
     D  SQL_00005            129    168A                                        MASTER.SKMNAM
     D  SQL_00006            169    180A                                        MASTER.SKMSID
     D  SQL_00007            181    185A                                        MASTER.SKMPFM
     D  SQL_00008            186    188P 0 PACKEVEN                             MASTER.SKMIS#
     D  SQL_00009            189    192S 0                                      MASTER.SKMVER
     D  SQL_00010            193    196A                                        MASTER.SKMMDL
     D  SQL_00011            197    200A                                        MASTER.SKMFTR
     D  SQL_00012            201    208S 0                                      MASTER.SKMDMO
     D  SQL_00013            209    224A                                        MASTER.SKMKCD
     D  SQL_00014            225    225A                                        MASTER.SKMCST
     D  SQL_00015            226    228S 0                                      MASTER.SKMLPR
     D                 DS                                                       FETCH
     D  SQL_00016              1      2B 0 INZ(128)                             length of header
     D  SQL_00017              3      4B 0 INZ(6)                               statement number
     D  SQL_00018              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00019              9      9A   INZ('0')                             data is okay
     D  SQL_00020             10    128A                                        end of header
     D  SQL_00021            129    168A                                        MASTER.SKMNAM
     D  SQL_00022            169    180A                                        MASTER.SKMSID
     D  SQL_00023            181    185A                                        MASTER.SKMPFM
     D  SQL_00024            186    188P 0 PACKEVEN                             MASTER.SKMIS#
     D  SQL_00025            189    192S 0                                      MASTER.SKMVER
     D  SQL_00026            193    196A                                        MASTER.SKMMDL
     D  SQL_00027            197    200A                                        MASTER.SKMFTR
     D  SQL_00028            201    208S 0                                      MASTER.SKMDMO
     D  SQL_00029            209    224A                                        MASTER.SKMKCD
     D  SQL_00030            225    225A                                        MASTER.SKMCST
     D  SQL_00031            226    228S 0                                      MASTER.SKMLPR
     D                 DS                                                       CLOSE
     D  SQL_00032              1      2B 0 INZ(128)                             length of header
     D  SQL_00033              3      4B 0 INZ(7)                               statement number
     D  SQL_00034              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00035              9      9A   INZ('0')                             data is okay
     D  SQL_00036             10    127A                                        end of header
     D  SQL_00037            128    128A                                        end of header
     D                 DS                                                       FETCH
     D  SQL_00038              1      2B 0 INZ(128)                             length of header
     D  SQL_00039              3      4B 0 INZ(8)                               statement number
     D  SQL_00040              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00041              9      9A   INZ('0')                             data is okay
     D  SQL_00042             10    127A                                        end of header
     D  SQL_00043            129    133A                                        PLATFORM.SKFPFM
     D                 DS                                                       FETCH
     D  SQL_00044              1      2B 0 INZ(128)                             length of header
     D  SQL_00045              3      4B 0 INZ(9)                               statement number
     D  SQL_00046              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00047              9      9A   INZ('0')                             data is okay
     D  SQL_00048             10    127A                                        end of header
     D  SQL_00049            129    133A                                        PLATFORM.SKFPFM
     D                 DS                                                       CLOSE
     D  SQL_00050              1      2B 0 INZ(128)                             length of header
     D  SQL_00051              3      4B 0 INZ(10)                              statement number
     D  SQL_00052              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00053              9      9A   INZ('0')                             data is okay
     D  SQL_00054             10    127A                                        end of header
     D  SQL_00055            128    128A                                        end of header
     D                 DS                                                       FETCH
     D  SQL_00056              1      2B 0 INZ(128)                             length of header
     D  SQL_00057              3      4B 0 INZ(11)                              statement number
     D  SQL_00058              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00059              9      9A   INZ('0')                             data is okay
     D  SQL_00060             10    127A                                        end of header
     D  SQL_00061            129    133A                                        VERSION.SKVPFM
     D  SQL_00062            134    137S 0                                      VERSION.SKVVER
     D                 DS                                                       FETCH
     D  SQL_00063              1      2B 0 INZ(128)                             length of header
     D  SQL_00064              3      4B 0 INZ(12)                              statement number
     D  SQL_00065              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00066              9      9A   INZ('0')                             data is okay
     D  SQL_00067             10    127A                                        end of header
     D  SQL_00068            129    133A                                        VERSION.SKVPFM
     D  SQL_00069            134    137S 0                                      VERSION.SKVVER
     D                 DS                                                       CLOSE
     D  SQL_00070              1      2B 0 INZ(128)                             length of header
     D  SQL_00071              3      4B 0 INZ(13)                              statement number
     D  SQL_00072              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00073              9      9A   INZ('0')                             data is okay
     D  SQL_00074             10    127A                                        end of header
     D  SQL_00075            128    128A                                        end of header
     D                 DS                                                       FETCH
     D  SQL_00076              1      2B 0 INZ(128)                             length of header
     D  SQL_00077              3      4B 0 INZ(14)                              statement number
     D  SQL_00078              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00079              9      9A   INZ('0')                             data is okay
     D  SQL_00080             10    127A                                        end of header
     D  SQL_00081            128    128A                                        end of header
     D                 DS                                                       CLOSE
     D  SQL_00082              1      2B 0 INZ(128)                             length of header
     D  SQL_00083              3      4B 0 INZ(15)                              statement number
     D  SQL_00084              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00085              9      9A   INZ('0')                             data is okay
     D  SQL_00086             10    127A                                        end of header
     D  SQL_00087            128    128A                                        end of header
     D                 DS                                                       SELECT
     D  SQL_00088              1      2B 0 INZ(128)                             length of header
     D  SQL_00089              3      4B 0 INZ(16)                              statement number
     D  SQL_00090              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00091              9      9A   INZ('0')                             data is okay
     D  SQL_00092             10    127A                                        end of header
     D  SQL_00093            129    140A                                        CUST.SYSTEMID
     D  SQL_00094            141    143P 0 PACKEVEN                             MAXSEQ
     D                 DS                                                       INSERT
     D  SQL_00095              1      2B 0 INZ(128)                             length of header
     D  SQL_00096              3      4B 0 INZ(17)                              statement number
     D  SQL_00097              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00098              9      9A   INZ('0')                             data is okay
     D  SQL_00099             10    127A                                        end of header
     D  SQL_00100            129    168A                                        CUST.NAME
     D  SQL_00101            169    180A                                        CUST.SYSTEMID
     D  SQL_00102            181    185A                                        CUST.PLATFORM
     D  SQL_00103            186    189I 0                                      CUST.SEQUENCE
     D  SQL_00104            190    193I 0                                      CUST.VERSION
     D  SQL_00105            194    197A                                        CUST.MODEL
     D  SQL_00106            198    201A                                        CUST.FEATURECODE
     D  SQL_00107            202    205I 0                                      CUST.DEMODATE_DEPREC
     D  SQL_00108            206    237A                                        CUST.KEYCODE
     D  SQL_00109            238    238A                                        CUST.CUSTOMERRECORDF
     D  SQL_00110            239    242I 0                                      CUST.LOGICALPARTITIO
     D                 DS                                                       SELECT
     D  SQL_00111              1      2B 0 INZ(128)                             length of header
     D  SQL_00112              3      4B 0 INZ(18)                              statement number
     D  SQL_00113              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00114              9      9A   INZ('0')                             data is okay
     D  SQL_00115             10    127A                                        end of header
     D  SQL_00116            129    140A                                        SYSTEMID
     D  SQL_00117            141    145P 0                                      SEQUENCENUMBER
     D  SQL_00118            146    185A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00119            186    197A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00120            198    202A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00121            203    206I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00122            207    210I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00123            211    214A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00124            215    218A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00125            219    222I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00126            223    254A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00127            255    255A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00128            256    259I 0                                      KEYCODEOBJECT.CUSTOM
     D                 DS                                                       SELECT
     D  SQL_00129              1      2B 0 INZ(128)                             length of header
     D  SQL_00130              3      4B 0 INZ(19)                              statement number
     D  SQL_00131              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00132              9      9A   INZ('0')                             data is okay
     D  SQL_00133             10    127A                                        end of header
     D  SQL_00134            129    140A                                        CUST.SYSTEMID
     D  SQL_00135            141    144I 0                                      CUST.SEQUENCE
     D  SQL_00136            145    148I 0                                      PRODATTR.ID
     D  SQL_00137            149    160A                                        LICENSED.SKLSID
     D  SQL_00138            161    165A                                        LICENSED.SKLPFM
     D  SQL_00139            166    168P 0 PACKEVEN                             LICENSED.SKLIS#
     D  SQL_00140            169    171S 0                                      LICENSED.SKLPRD
     D  SQL_00141            172    177S 0                                      LICENSED.SKL#US
     D  SQL_00142            178    185S 0                                      LICENSED.SKLDMO
     D                 DS                                                       UPDATE
     D  SQL_00143              1      2B 0 INZ(128)                             length of header
     D  SQL_00144              3      4B 0 INZ(20)                              statement number
     D  SQL_00145              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00146              9      9A   INZ('0')                             data is okay
     D  SQL_00147             10    127A                                        end of header
     D  SQL_00148            129    132I 0                                      PRODATTR.NBRUSRLIC
     D  SQL_00149            133    136I 0                                      PRODATTR.EXPIRYDATEI
     D  SQL_00150            137    148A                                        CUST.SYSTEMID
     D  SQL_00151            149    152I 0                                      CUST.SEQUENCE
     D  SQL_00152            153    156I 0                                      PRODATTR.ID
     D                 DS                                                       INSERT
     D  SQL_00153              1      2B 0 INZ(128)                             length of header
     D  SQL_00154              3      4B 0 INZ(21)                              statement number
     D  SQL_00155              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00156              9      9A   INZ('0')                             data is okay
     D  SQL_00157             10    127A                                        end of header
     D  SQL_00158            129    140A                                        CUST.SYSTEMID
     D  SQL_00159            141    145A                                        CUST.PLATFORM
     D  SQL_00160            146    149I 0                                      CUST.SEQUENCE
     D  SQL_00161            150    153I 0                                      PRODATTR.ID
     D  SQL_00162            154    157I 0                                      PRODATTR.NBRUSRLIC
     D  SQL_00163            158    161I 0                                      PRODATTR.EXPIRYDATEI
     D                 DS                                                       DELETE
     D  SQL_00164              1      2B 0 INZ(128)                             length of header
     D  SQL_00165              3      4B 0 INZ(22)                              statement number
     D  SQL_00166              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00167              9      9A   INZ('0')                             data is okay
     D  SQL_00168             10    127A                                        end of header
     D  SQL_00169            129    140A                                        CUST.SYSTEMID
     D  SQL_00170            141    144I 0                                      CUST.SEQUENCE
     D  SQL_00171            145    148I 0                                      PRODATTR.ID
     D                 DS                                                       UPDATE
     D  SQL_00172              1      2B 0 INZ(128)                             length of header
     D  SQL_00173              3      4B 0 INZ(23)                              statement number
     D  SQL_00174              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00175              9      9A   INZ('0')                             data is okay
     D  SQL_00176             10    127A                                        end of header
     D  SQL_00177            129    168A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00178            169    180A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00179            181    185A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00180            186    189I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00181            190    193I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00182            194    197A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00183            198    201A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00184            202    205I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00185            206    237A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00186            238    238A                                        KEYCODEOBJECT.CUSTOM
     D  SQL_00187            239    242I 0                                      KEYCODEOBJECT.CUSTOM
     D  SQL_00188            243    254A                                        CUST.SYSTEMID
     D  SQL_00189            255    258I 0                                      CUST.SEQUENCE
     D                 DS                                                       OPEN
     D  SQL_00190              1      2B 0 INZ(128)                             length of header
     D  SQL_00191              3      4B 0 INZ(25)                              statement number
     D  SQL_00192              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00193              9      9A   INZ('0')                             data is okay
     D  SQL_00194             10    127A                                        end of header
     D  SQL_00195            128    128A                                        end of header
     D                 DS                                                       FETCH
     D  SQL_00196              1      2B 0 INZ(128)                             length of header
     D  SQL_00197              3      4B 0 INZ(26)                              statement number
     D  SQL_00198              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00199              9      9A   INZ('0')                             data is okay
     D  SQL_00200             10    127A                                        end of header
     D  SQL_00201            128    128A                                        end of header
     D                 DS                                                       CLOSE
     D  SQL_00202              1      2B 0 INZ(128)                             length of header
     D  SQL_00203              3      4B 0 INZ(27)                              statement number
     D  SQL_00204              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00205              9      9A   INZ('0')                             data is okay
     D  SQL_00206             10    127A                                        end of header
     D  SQL_00207            128    128A                                        end of header
     D                 DS                                                       SELECT
     D  SQL_00208              1      2B 0 INZ(128)                             length of header
     D  SQL_00209              3      4B 0 INZ(28)                              statement number
     D  SQL_00210              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00211              9      9A   INZ('0')                             data is okay
     D  SQL_00212             10    127A                                        end of header
     D  SQL_00213            129    140A                                        SYSTEMID
     D  SQL_00214            141    143P 0 PACKEVEN                             SEQUENCE
     D  SQL_00215            144    155A                                        TIF.SKTSID
     D  SQL_00216            156    160A                                        TIF.SKTPFM
     D  SQL_00217            161    163P 0 PACKEVEN                             TIF.SKTIS#
     D  SQL_00218            164    203A                                        TIF.SKTSVR
     D  SQL_00219            204    210A                                        TIF.SKTKCD
     D                 DS                                                       INSERT
     D  SQL_00220              1      2B 0 INZ(128)                             length of header
     D  SQL_00221              3      4B 0 INZ(29)                              statement number
     D  SQL_00222              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00223              9      9A   INZ('0')                             data is okay
     D  SQL_00224             10    127A                                        end of header
     D  SQL_00225            129    140A                                        HISTORY.SKHSID
     D  SQL_00226            141    145A                                        HISTORY.SKHPFM
     D  SQL_00227            146    148P 0 PACKEVEN                             HISTORY.SKHIS#
     D  SQL_00228            149    153P 0 PACKEVEN                             HISTORY.SKHDLC
     D  SQL_00229            154    157P 0 PACKEVEN                             HISTORY.SKHTLC
     D  SQL_00230            158    167A                                        HISTORY.SKHULC
     D  SQL_00231            168    192A                                        HISTORY.SKHDKY
     D  SQL_00232            193    204A                                        HISTORY.SKHCFR
     D  SQL_00233            205    216A                                        HISTORY.SKHCTO
     D  SQL_00234            217    219P 0 PACKEVEN                             HISTORY.SKHVER
     D  SQL_00235            220    221P 0                                      HISTORY.SKHPRD
     D                 DS                                                       SELECT
     D  SQL_00236              1      2B 0 INZ(128)                             length of header
     D  SQL_00237              3      4B 0 INZ(30)                              statement number
     D  SQL_00238              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00239              9      9A   INZ('0')                             data is okay
     D  SQL_00240             10    127A                                        end of header
     D  SQL_00241            129    133P 0                                      PRODUCTID
     D  SQL_00242            134    138A                                        PLATFORM
     D  SQL_00243            139    143P 0                                      VERSION
     D  SQL_00244            144    148A                                        PRODUCT.SKPPFM
     D  SQL_00245            149    150P 0                                      PRODUCT.SKPPRD
     D  SQL_00246            151    175A                                        PRODUCT.SKPDSC
     D  SQL_00247            176    176A                                        PRODUCT.SKPUTL
     D  SQL_00248            177    179P 0 PACKEVEN                             PRODUCT.SKPAVF
     D  SQL_00249            180    182P 0 PACKEVEN                             PRODUCT.SKPAVT
     D  SQL_00250            183    192A                                        PRODUCT.SKPKCA
     D                 DS                                                       FETCH
     D  SQL_00251              1      2B 0 INZ(128)                             length of header
     D  SQL_00252              3      4B 0 INZ(31)                              statement number
     D  SQL_00253              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00254              9      9A   INZ('0')                             data is okay
     D  SQL_00255             10    127A                                        end of header
     D  SQL_00256            128    128A                                        end of header
     D                 DS                                                       CLOSE
     D  SQL_00257              1      2B 0 INZ(128)                             length of header
     D  SQL_00258              3      4B 0 INZ(32)                              statement number
     D  SQL_00259              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00260              9      9A   INZ('0')                             data is okay
     D  SQL_00261             10    127A                                        end of header
     D  SQL_00262            128    128A                                        end of header
      //************************************************************************
     p search          b                   export
     d                 pi
     d  nameOrSystemID...
     d                               25    const
     d  searchResponse...
     d                                     likeds(searchResponse_t)
     d x               s             10i 0 inz(0)
     d rc              s             10i 0
      /free
       //*exec sql set option closqlcsr=*endmod,commit=*none;
       clear searchResponse;
       setMessage(searchResponse.message:OK:'OK');
       if setCursor('select * from ' + %trimr(pgmLib) + '/spykeymst'+
         ' where skmnam like ucase(' + sq + %trim(nameOrSystemID) + sq +
         ') or skmnam = ucase(' + sq + %trim(nameOrSystemID) + sq +
         ') or skmsid like ucase(' + sq + %trim(nameOrSystemID) + sq +
         ') or skmsid = ucase(' + sq + %trim(nameOrSystemID) + sq + ')':
         searchResponse.message) = OK;
       //*  exec sql fetch csr into :master;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   5
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00000                      SQL
     C     SQL_00003     IFEQ      '1'                                          SQL
     C                   EVAL      MASTER.SKMNAM = SQL_00005                    SQL
     C                   EVAL      MASTER.SKMSID = SQL_00006                    SQL
     C                   EVAL      MASTER.SKMPFM = SQL_00007                    SQL
     C                   EVAL      MASTER.SKMIS# = SQL_00008                    SQL
     C                   EVAL      MASTER.SKMVER = SQL_00009                    SQL
     C                   EVAL      MASTER.SKMMDL = SQL_00010                    SQL
     C                   EVAL      MASTER.SKMFTR = SQL_00011                    SQL
     C                   EVAL      MASTER.SKMDMO = SQL_00012                    SQL
     C                   EVAL      MASTER.SKMKCD = SQL_00013                    SQL
     C                   EVAL      MASTER.SKMCST = SQL_00014                    SQL
     C                   EVAL      MASTER.SKMLPR = SQL_00015                    SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         dow sqlcod = OK;
           x += 1;
           if x > %elem(searchResponse.customer);
             setMessage(searchResponse.message:ERROR:
              'Search result exceeds maximum allowed. Please refine criteria.');
             leave;
           endif;
           searchResponse.customer(x).name = master.skmnam;
           searchResponse.customer(x).systemID = master.skmsid;
           searchResponse.customer(x).sequence = master.skmis#;
           searchResponse.customer(x).platform = master.skmpfm;
           searchResponse.customer(x).version = master.skmver;
       //*    exec sql fetch csr into :master;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   6
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00016                      SQL
     C     SQL_00019     IFEQ      '1'                                          SQL
     C                   EVAL      MASTER.SKMNAM = SQL_00021                    SQL
     C                   EVAL      MASTER.SKMSID = SQL_00022                    SQL
     C                   EVAL      MASTER.SKMPFM = SQL_00023                    SQL
     C                   EVAL      MASTER.SKMIS# = SQL_00024                    SQL
     C                   EVAL      MASTER.SKMVER = SQL_00025                    SQL
     C                   EVAL      MASTER.SKMMDL = SQL_00026                    SQL
     C                   EVAL      MASTER.SKMFTR = SQL_00027                    SQL
     C                   EVAL      MASTER.SKMDMO = SQL_00028                    SQL
     C                   EVAL      MASTER.SKMKCD = SQL_00029                    SQL
     C                   EVAL      MASTER.SKMCST = SQL_00030                    SQL
     C                   EVAL      MASTER.SKMLPR = SQL_00031                    SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         enddo;
       endif;
       //*exec sql close csr;
      /END-FREE                                                                 SQL
     C                   Z-ADD     7             SQLER6                         SQL
     C     SQL_00034     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00032                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00032                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       return;
      /end-free
     p                 e

      //************************************************************************
     p getPlatformList...
     p                 b                   export
     d                 pi
     d  platformList                       likeds(platformList_t)
     d x               s             10i 0 inz(0)
      /free
       clear platformList;
       setMessage(platformList.message:OK:'OK');
       if setCursor('select * from ' + %trimr(pgmLib) + '/spykeypfm':
         platformList.message) = OK;
       //*  exec sql fetch csr into :platform;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   8
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00038                      SQL
     C     SQL_00041     IFEQ      '1'                                          SQL
     C                   EVAL      PLATFORM.SKFPFM = SQL_00043                  SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         dow sqlcod = OK;
           x += 1;
           if x > %elem(platformList.platform);
             setMessage(platformList.message:ERROR:
              'Maximum list size exceeded. Contact Irvine development.');
             leave;
           endif;
           platformList.platform(x) = platform.skfpfm;
       //*    exec sql fetch csr into :platform;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   9
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00044                      SQL
     C     SQL_00047     IFEQ      '1'                                          SQL
     C                   EVAL      PLATFORM.SKFPFM = SQL_00049                  SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         enddo;
       endif;
       //*exec sql close csr;
      /END-FREE                                                                 SQL
     C                   Z-ADD     10            SQLER6                         SQL
     C     SQL_00052     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00050                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00050                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       return;
      /end-free
     p                 e

      //************************************************************************
     p getVersionList  b                   export
     d                 pi
     d  platformCode                       const like(platform_t)
     d  versionList                        likeds(versionList_t)
     d x               s             10i 0 inz(0)
      /free
       clear versionList;
       setMessage(versionList.message:OK:'OK');
       if setCursor('select * from ' + %trimr(pgmLib) + '/spykeyver where ' +
         'skvpfm = ' + sq + %trimr(platformCode) + sq:versionList.message) = OK;
       //*  exec sql fetch csr into :version;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   11
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00056                      SQL
     C     SQL_00059     IFEQ      '1'                                          SQL
     C                   EVAL      VERSION.SKVPFM = SQL_00061                   SQL
     C                   EVAL      VERSION.SKVVER = SQL_00062                   SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         dow sqlcod = OK;
           x += 1;
           if x > %elem(versionList.version);
             setMessage(versionList.message:ERROR:
              'Maximum list size exceeded. Contact Irvine development.');
             leave;
           endif;
           versionList.version(x) = version.skvver;
       //*    exec sql fetch csr into :version;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   12
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00063                      SQL
     C     SQL_00066     IFEQ      '1'                                          SQL
     C                   EVAL      VERSION.SKVPFM = SQL_00068                   SQL
     C                   EVAL      VERSION.SKVVER = SQL_00069                   SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         enddo;
       endif;
       //*exec sql close csr;
      /END-FREE                                                                 SQL
     C                   Z-ADD     13            SQLER6                         SQL
     C     SQL_00072     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00070                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00070                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       return;
      /end-free
     p                 e

      //************************************************************************
     p getProductList  b
     d                 pi
     d  keycodeObject                      likeds(keycodeObject_t)
     d x               s             10i 0 inz(0)
     d productList     ds                  likeds(product) dim(20)
     d maxRows         s             10i 0 inz(%elem(productList))
      /free
       clear productList;
       clear keycodeObject.products;
       setMessage(keycodeObject.message:OK:'OK');
       if setCursor('select * from ' + %trimr(pgmLib) + '/spykeyprd where ' +
         'skppfm = ' + sq + %trimr(keycodeObject.customer.platform) + sq +
         ' and ' + %trim(%char(keycodeObject.customer.version)) +
         ' between skpavf and skpavt':keycodeObject.message) = OK;
       //*  exec sql fetch csr for :maxRows rows into :productList;
      /END-FREE                                                                 SQL
     C                   EVAL      SQLER5       = MAXROWS                       SQL
     C                   Z-ADD     -4            SQLER6                         SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00076                      SQL
     C                   PARM                    PRODUCTLIST                    SQL
      /FREE                                                                     SQL
       //*  exec sql close csr;
      /END-FREE                                                                 SQL
     C                   Z-ADD     15            SQLER6                         SQL
     C     SQL_00084     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00082                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00082                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         for x = 1 to %elem(productList);
           if productList(x).skpprd = 0;
             leave;
           endif;
           keycodeObject.products(x).id = productList(x).skpprd;
           keycodeObject.products(x).description = productList(x).skpdsc;
           keycodeObject.products(x).userBased = productList(x).skputl;
         endfor;
       endif;
       return;
      /end-free
     p                 e

      //************************************************************************
     p addKeycodeObject...
     p                 b                   export
     d                 pi
     d  keyCodeObject...
     d                                     likeds(keycodeObject_t)
     d maxSeq          s                   like(master.skmis#)
     d cust            ds                  likeds(customerInfo_t)
      /free
       setMessage(keycodeObject.message:OK:'OK');
       cust = keycodeObject.customer;
       //*exec sql select max(skmis#) into :maxSeq from spykeylib/spykeymst
       //*  where skmsid = :cust.systemID;
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00093    = CUST.SYSTEMID                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   16
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00088                      SQL
     C     SQL_00091     IFEQ      '1'                                          SQL
     C                   EVAL      MAXSEQ = SQL_00094                           SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       cust.sequence = maxSeq + 1;
       cust.keyCode = ' ';
       //*exec sql insert into spykeylib/spykeymst values(ucase(:cust.name),
       //*  ucase(:cust.systemID), ucase(:cust.platform), :cust.sequence,
       //*  :cust.version, ucase(:cust.model), :cust.featureCode,
       //*  :cust.demoDate_deprecated, :cust.keyCode, :cust.customerRecordFlag,
       //*  :cust.logicalPartition);
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00100    = CUST.NAME                     SQL
     C                   EVAL      SQL_00101    = CUST.SYSTEMID                 SQL
     C                   EVAL      SQL_00102    = CUST.PLATFORM                 SQL
     C                   EVAL      SQL_00103    = CUST.SEQUENCE                 SQL
     C                   EVAL      SQL_00104    = CUST.VERSION                  SQL
     C                   EVAL      SQL_00105    = CUST.MODEL                    SQL
     C                   EVAL      SQL_00106    = CUST.FEATURECODE              SQL
     C                   EVAL      SQL_00107    = CUST.DEMODATE_DEPRECATED      SQL
     C                   EVAL      SQL_00108    = CUST.KEYCODE                  SQL
     C                   EVAL      SQL_00109    = CUST.CUSTOMERRECORDFLAG       SQL
     C                   EVAL      SQL_00110    = CUST.LOGICALPARTITION         SQL
     C                   Z-ADD     -4            SQLER6                         SQL   17
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00095                      SQL
      /FREE                                                                     SQL
       if sqlcod <> OK;
         setMessage(keycodeObject.message:ERROR:rtvMsg('SQL' +
           %subst(%editc(%abs(sqlcod):'X'):6:4):sqlerm));
       else;
         keycodeObject.customer = cust;
         setProductAttr(keycodeObject);
         updateKeycodeObject(keycodeObject);
       endif;
       return;
      /end-free
     p                 e

      //************************************************************************
     p getKeyCodeObject...
     p                 b                   export
     d                 pi
     d  systemID                           const like(master.skmsid)
     d  sequenceNumber...
     d                                     const like(sequenceNumber_t)
     d  keycodeObject...
     d                                     likeds(keycodeObject_t)
     d stmt            s            512
     d charKey         s                   like(customerInfo_t.keyCode)
      /free
       clear keycodeObject;
       setMessage(keycodeObject.message:OK:'OK');
       //*exec sql select * into :keycodeObject.customer from
       //*  spykeylib/spykeymst where skmsid = :systemID and
       //*  skmis# = :sequenceNumber;
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00116    = SYSTEMID                      SQL
     C                   EVAL      SQL_00117    = SEQUENCENUMBER                SQL
     C                   Z-ADD     -4            SQLER6                         SQL   18
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00111                      SQL
     C     SQL_00114     IFEQ      '1'                                          SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.NAME = SQL_00118      SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.SYSTEMID              SQL
     C                              = SQL_00119                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.PLATFORM              SQL
     C                              = SQL_00120                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.SEQUENCE              SQL
     C                              = SQL_00121                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.VERSION               SQL
     C                              = SQL_00122                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.MODEL = SQL_00123     SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.FEATURECODE           SQL
     C                              = SQL_00124                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.DEMODATE_DEPRECATED   SQL
     C                              = SQL_00125                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.KEYCODE               SQL
     C                              = SQL_00126                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.CUSTOMERRECORDFLAG    SQL
     C                              = SQL_00127                                 SQL
     C                   EVAL      KEYCODEOBJECT.CUSTOMER.LOGICALPARTITION      SQL
     C                              = SQL_00128                                 SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       if sqlcod <> OK;
         setMessage(keycodeObject.message:ERROR:rtvMsg('SQL' +
           %subst(%editc(%abs(sqlcod):'X'):6:4):sqlerm));
           return;
       endif;
       cvthc(%addr(keycodeObject.customer.keycode):
           %addr(keycodeObject.customer.keycode):
           %len(keycodeObject.customer.keycode));
       //keycodeObject.customer.keycode = charKey;
       setProductAttr(keycodeObject);
       return;
      /end-free
     p                 e

      //************************************************************************
     p updateKeycodeObject...
     p                 b                   export
     d                 pi
     d  keycodeObject...
     d                                     likeds(keycodeObject_t)
     d setTifKey       pr                  extpgm('SPYKEYTIFR')
     d  systemID                           like(master.skmsid) const
     d  platform                           like(master.skmpfm) const
     d  sequence                           like(master.skmis#) const
     d  expiry                             like(licensed.skldmo) const
     d  server                             like(tif.sktsvr) const
     d prodID          s                   like(licensed.sklprd)
     d cust            ds                  likeds(customerInfo_t)
     d i               s             10i 0
     d curKeyObj       ds                  likeds(keycodeObject_t)
     d prodAttr        ds                  likeds(product_t)
     d prodListChg     s               n   inz('0')
      /free
       setMessage(keycodeObject.message:OK:'OK');
       cust = keycodeObject.customer;
       if validateKeycodeObject(keycodeObject) <> OK;
         return;
       endif;
       // Update licensed products for current customer.
       for i = 1 to %elem(keycodeObject.products);
         if keycodeObject.products(i).id = 0; // End of list;
           leave;
         endif;
         prodAttr = keycodeObject.products(i);
         clear licensed;
         // Deselect product if not in valid range for version.
         // This condition would occur if version was changed for customer.
         if checkProductVersion(cust.version:cust.platform:prodAttr.id) <> OK;
           keycodeObject.products(i).selected = 'N';
           prodListChg = '1';
         endif;
       //*  exec sql select * into :licensed from spykeylib/spykeylic where
       //*    sklsid = :cust.systemID and sklis# = :cust.sequence and
       //*      sklprd = :prodAttr.id;
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00134    = CUST.SYSTEMID                 SQL
     C                   EVAL      SQL_00135    = CUST.SEQUENCE                 SQL
     C                   EVAL      SQL_00136    = PRODATTR.ID                   SQL
     C                   Z-ADD     -4            SQLER6                         SQL   19
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00129                      SQL
     C     SQL_00132     IFEQ      '1'                                          SQL
     C                   EVAL      LICENSED.SKLSID = SQL_00137                  SQL
     C                   EVAL      LICENSED.SKLPFM = SQL_00138                  SQL
     C                   EVAL      LICENSED.SKLIS# = SQL_00139                  SQL
     C                   EVAL      LICENSED.SKLPRD = SQL_00140                  SQL
     C                   EVAL      LICENSED.SKL#US = SQL_00141                  SQL
     C                   EVAL      LICENSED.SKLDMO = SQL_00142                  SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
         select;
           when keycodeObject.products(i).selected = 'Y';
             if sqlcod = OK;
               clear tif;
               if prodAttr.id = TIFFVIEWERID; //Create 3rd party key.
                 setTifKey(cust.systemID:cust.platform:cust.sequence:
                   keycodeObject.products(i).expiryDateISO:
                   keycodeObject.products(i).thirdPartyID);
               endif;
       //*        exec sql update spykeylib/spykeylic set skl#us =
       //*          :prodAttr.nbrUsrLic, skldmo = :prodAttr.expiryDateISO
       //*          where sklsid = :cust.systemID and sklis# = :cust.sequence
       //*          and sklprd = :prodAttr.id;
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00148    = PRODATTR.NBRUSRLIC            SQL
     C                   EVAL      SQL_00149    = PRODATTR.EXPIRYDATEISO        SQL
     C                   EVAL      SQL_00150    = CUST.SYSTEMID                 SQL
     C                   EVAL      SQL_00151    = CUST.SEQUENCE                 SQL
     C                   EVAL      SQL_00152    = PRODATTR.ID                   SQL
     C                   Z-ADD     -4            SQLER6                         SQL   20
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00143                      SQL
      /FREE                                                                     SQL
             else;
       //*        exec sql insert into spykeylib/spykeylic values(:cust.systemID
       //*          :cust.platform,:cust.sequence,:prodAttr.id,:prodAttr.nbrUsrl
       //*          :prodAttr.expiryDateISO);
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00158    = CUST.SYSTEMID                 SQL
     C                   EVAL      SQL_00159    = CUST.PLATFORM                 SQL
     C                   EVAL      SQL_00160    = CUST.SEQUENCE                 SQL
     C                   EVAL      SQL_00161    = PRODATTR.ID                   SQL
     C                   EVAL      SQL_00162    = PRODATTR.NBRUSRLIC            SQL
     C                   EVAL      SQL_00163    = PRODATTR.EXPIRYDATEISO        SQL
     C                   Z-ADD     -4            SQLER6                         SQL   21
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00153                      SQL
      /FREE                                                                     SQL
             endif;
           when keycodeObject.products(i).selected = 'N';
             if sqlcod = OK;
       //*        exec sql delete from spykeylib/spykeylic where
       //*          sklsid = :cust.systemID and sklis# = :cust.sequence and
       //*          sklprd = :prodAttr.id;
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00169    = CUST.SYSTEMID                 SQL
     C                   EVAL      SQL_00170    = CUST.SEQUENCE                 SQL
     C                   EVAL      SQL_00171    = PRODATTR.ID                   SQL
     C                   Z-ADD     -4            SQLER6                         SQL   22
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00164                      SQL
      /FREE                                                                     SQL
             endif;
         endsl;
       endfor;
       // Save off the current keycodeObject record for history operation.
       getKeycodeObject(cust.systemID:cust.sequence:curKeyObj);
       if sqlcod = OK;
         generateKeyCode(keycodeObject);
       //*  exec sql update spykeylib/spykeymst set row = :keycodeObject.custome
       //*    where skmsid = :cust.systemID and skmis# = :cust.sequence;
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00177    = KEYCODEOBJECT.CUSTOMER.NAME   SQL
     C                   EVAL      SQL_00178    = KEYCODEOBJECT.CUSTOMER.SYS... SQL
     C                             TEMID                                        SQL
     C                   EVAL      SQL_00179    = KEYCODEOBJECT.CUSTOMER.PLA... SQL
     C                             TFORM                                        SQL
     C                   EVAL      SQL_00180    = KEYCODEOBJECT.CUSTOMER.SEQ... SQL
     C                             UENCE                                        SQL
     C                   EVAL      SQL_00181    = KEYCODEOBJECT.CUSTOMER.VER... SQL
     C                             SION                                         SQL
     C                   EVAL      SQL_00182    = KEYCODEOBJECT.CUSTOMER.MODEL  SQL
     C                   EVAL      SQL_00183    = KEYCODEOBJECT.CUSTOMER.FEA... SQL
     C                             TURECODE                                     SQL
     C                   EVAL      SQL_00184    = KEYCODEOBJECT.CUSTOMER.DEM... SQL
     C                             ODATE_DEPRECATED                             SQL
     C                   EVAL      SQL_00185    = KEYCODEOBJECT.CUSTOMER.KEY... SQL
     C                             CODE                                         SQL
     C                   EVAL      SQL_00186    = KEYCODEOBJECT.CUSTOMER.CUS... SQL
     C                             TOMERRECORDFLAG                              SQL
     C                   EVAL      SQL_00187    = KEYCODEOBJECT.CUSTOMER.LOG... SQL
     C                             ICALPARTITION                                SQL
     C                   EVAL      SQL_00188    = CUST.SYSTEMID                 SQL
     C                   EVAL      SQL_00189    = CUST.SEQUENCE                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   23
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00172                      SQL
      /FREE                                                                     SQL
       endif;
       if sqlcod <> OK;
         setMessage(keycodeObject.message:ERROR:rtvMsg('SQL' +
           %subst(%editc(%abs(sqlcod):'X'):6:4):sqlerm));
         return;
       endif;
       if doHistory(curKeyObj:keycodeObject) <> OK;
         setMessage(keycodeObject.message:WARNING:
           'Warning! Error writing history data.');
       endif;
       if prodListChg; //Product list changed...update and send message.
         getProductList(keycodeObject);
         if keycodeObject.message.returnCode = OK;
           setProductAttr(keycodeObject);
           if keycodeObject.message.returnCode = OK;
             setMessage(keycodeObject.message:WARNING:
               'Warning! Product list modified by version. Verify selections.');
           endif;
         endif;
       endif;
       cvthc(%addr(keycodeObject.customer.keycode):
           %addr(keycodeObject.customer.keycode):
           %len(keycodeObject.customer.keycode));
       return;
      /end-free
     p                 e

      //************************************************************************
     p setCursor       b
     d                 pi            10i 0
     d sqlStmtIn                    512    value
     d message                             likeds(message_t)
     d rc              s             10i 0 inz(OK)
      /free
       //*exec sql prepare stmt from :sqlStmtIn;
      /END-FREE                                                                 SQL
     C                   Z-ADD     24            SQLER6                         SQL
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
     C     SQL_00192     IFEQ      0                                            SQL
     C     SQL_00193     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00190                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00190                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       endif;
       if sqlcod <> OK;
         setMessage(message:ERROR:rtvMsg('SQL' +
           %subst(%editc(%abs(sqlcod):'X'):6:4):sqlerm));
         rc = ERROR;
       endif;
       return rc;
      /end-free
     p                 e

      //************************************************************************
     p setMessage      b
     d                 pi
     d  messageDS                          likeds(message_t)
     d  returnCode                         like(message_t.returnCode) const
     d  text                         80    const
      /free
       messageDS.returnCode = returnCode;
       messageDS.text = text;
       return;
      /end-free
     p                 e
      //************************************************************************
     p rtvMsg          b
     d                 pi            80
     d msgid                          7    const
     d msgDtaIn                     100    const

      *copy qsysinc/qrpglesrc,qusec
     D*** START HEADER FILE SPECIFICATIONS ****************************
     D*
     D*Header File Name: H/QUSEC
     D*
     D*Descriptive Name: Error Code Parameter.
     D*
     D*5763-SS1, 5722-SS1 (C) Copyright IBM Corp. 1994, 2001.
     D*All rights reserved.
     D*US Government Users Restricted Rights -
     D*Use, duplication or disclosure restricted
     D*by GSA ADP Schedule Contract with IBM Corp.
     D*
     D*Licensed Materials-Property of IBM
     D*
     D*
     D*Description: Include header file for the error code parameter.
     D*
     D*Header Files Included: None.
     D*
     D*Macros List: None.
     D*
     D*Structure List: Qus_EC_t
     D*             Qus_ERRC0200_t
     D*
     D*Function Prototype List: None.
     D*
     D*Change Activity:
     D*
     D*CFD List:
     D*
     D*FLAG REASON       LEVEL DATE   PGMR      CHANGE DESCRIPTION
     D*---- ------------ ----- ------ --------- ----------------------
     D*
     D*End CFD List.
     D*
     D*Additional notes about the Change Activity
     D*End Change Activity.
     D*** END HEADER FILE SPECIFICATIONS ******************************
     D*****************************************************************
     D*Record structure for Error Code Parameter
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Varying length field Exception
     D*   Data will not be defined here.
     D*****************************************************************
     DQUSEC            DS
     D*                                             Qus EC
     D QUSBPRV                 1      4B 0
     D*                                             Bytes Provided
     D QUSBAVL                 5      8B 0
     D*                                             Bytes Available
     D QUSEI                   9     15
     D*                                             Exception Id
     D QUSERVED               16     16
     D*                                             Reserved
     D*QUSED01                17     17
     D*
     D*                                      Varying length
     DQUSC0200         DS
     D*                                             Qus ERRC0200
     D QUSK01                  1      4B 0
     D*                                             Key
     D QUSBPRV00               5      8B 0
     D*                                             Bytes Provided
     D QUSBAVL14               9     12B 0
     D*                                             Bytes Available
     D QUSEI00                13     19
     D*                                             Exception Id
     D QUSERVED39             20     20
     D*                                             Reserved
     D QUSCCSID11             21     24B 0
     D*                                             CCSID
     D QUSOED01               25     28B 0
     D*                                             Offset Exc Data
     D QUSLED01               29     32B 0
     D*                                             Length Exc Data
     D*QUSRSV214              33     33
     D*                                             Reserved2
     D*
     D*QUSED02                34     34
     D*
     D*                                      Varying Length    @B1A
      *copy qsysinc/qrpglesrc,qmhrtvm
     D*** START HEADER FILE SPECIFICATIONS ****************************
     D*
     D*Header File Name: H/QMHRTVM
     D*
     D*Descriptive Name: Retrieve Message API.
     D*
     D*5763-SS1  (C) Copyright IBM Corp. 1994,1994
     D*All rights reserved.
     D*US Government Users Restricted Rights -
     D*Use, duplication or disclosure restricted
     D*by GSA ADP Schedule Contract with IBM Corp.
     D*
     D*Licensed Materials-Property of IBM
     D*
     D*
     D*Description: The Retrieve Message API retrieves the message
     D*          description of a predefined message.
     D*
     D*Header Files Included: None.
     D*
     D*Macros List: None.
     D*
     D*Structure List: Qmh_Rtvm_RTVM0100_t
     D*             Qmh_Rtvm_RTVM0200_t
     D*             Qmh_Rtvm_RTVM0300_t
     D*             Qmh_Rtvm_RTVM0400_t
     D*
     D*Function Prototype List: QMHRTVM
     D*
     D*Change Activity:
     D*
     D*CFD List:
     D*
     D*FLAG REASON       LEVEL DATE   PGMR      CHANGE DESCRIPTION
     D*---- ------------ ----- ------ --------- ----------------------
     D*$A0= D2862000     3D10  940424 RGARVEY : New Include
     D*$A1= D9805500 v5r1m0.xpf 000116 LIGGETT: RTVM0040 format
     D*$B1= D98212   v5r1m0.xpf 000116 LIGGETT: Teraspace
     D*
     D*End CFD List.
     D*
     D*Additional notes about the Change Activity
     D*End Change Activity.
     D*** END HEADER FILE SPECIFICATIONS ******************************
     D*****************************************************************
     D*Prototype for calling Message Handler API QMHRTVM
     D*****************************************************************
     D QMHRTVM         C                   'QMHRTVM'
     D*****************************************************************
     D*Type Definition for the RTVM0100 format.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHM010004       DS
     D*                                             Qmh Rtvm RTVM0100
     D QMHBR01                 1      4B 0
     D*                                             Bytes Return
     D QMHBAVL07               5      8B 0
     D*                                             Bytes Available
     D QMHLMRTN02              9     12B 0
     D*                                             Length Message Returned
     D QMHLMAVL02             13     16B 0
     D*                                             Length Message Available
     D QMHLHRTN02             17     20B 0
     D*                                             Length Help Returned
     D QMHLHAVL02             21     24B 0
     D*                                             Length Help Available
     D*QMHSSAGE02             25     25
     D*
     D*                             Varying length
     D*QMHMH02                26     26
     D*
     D*                             Varying length
     D*****************************************************************
     D*Type Definition for the RTVM0200 format.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHM020002       DS
     D*                                             Qmh Rtvm RTVM0200
     D QMHBR02                 1      4B 0
     D*                                             Bytes Return
     D QMHBAVL08               5      8B 0
     D*                                             Bytes Available
     D QMHMS08                 9     12B 0
     D*                                             Message Severity
     D QMHAI                  13     16B 0
     D*                                             Alert Index
     D QMHAO02                17     25
     D*                                             Alert Option
     D QMHLI01                26     26
     D*                                             Log Indicator
     D QMHERVED18             27     28
     D*                                             Reserved
     D QMHLRRTN               29     32B 0
     D*                                             Length Reply Returned
     D QMHLRAVL               33     36B 0
     D*                                             Length Reply Available
     D QMHLMRTN03             37     40B 0
     D*                                             Length Message Returned
     D QMHLMAVL03             41     44B 0
     D*                                             Length Message Available
     D QMHLHRTN03             45     48B 0
     D*                                             Length Help Returned
     D QMHLHAVL03             49     52B 0
     D*                                             Length Help Available
     D*QMHDR                  53     53
     D*
     D*                             Varying length
     D*QMHSSAGE03             54     54
     D*
     D*                             Varying length
     D*QMHMH03                55     55
     D*
     D*                             Varying length
     D*****************************************************************
     D*Type Definition for the Substitution Variable Format.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHSVF           DS
     D*                                             Qmh Subst Variable Format
     D QMHLSRD                 1      4B 0
     D*                                             Length Subst Replace Data
     D QMHFSODP                5      8B 0
     D*                                             Field Size Or Decimal Positi
     D QMHSVT                  9     18
     D*                                             Subst Variable Type
     D*char ReservedÙ;
     D*                             Varying length
     D*****************************************************************
     D*Type Definition for the Valid Reply Values Entry.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the entry.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHVRE           DS
     D*                                             Qmh Valid Reply Entry
     D QMHVRV                  1     32
     D*                                             Valid Reply Value
     D*QMHERVED25             33     33
     D*
     D*                             Varying length
     D*****************************************************************
     D*Type Definition for the Special Values Entry.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the entry.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHSRVE          DS
     D*                                             Qmh Special Reply Value Entr
     D QMHFV                   1     32
     D*                                             From Value
     D QMHTV                  33     64
     D*                                             To Value
     D*QMHERVED26             65     65
     D*
     D*                             Varying length
     D*****************************************************************
     D*Type Definition for the Relational Test Entry.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the entry.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHRTE           DS
     D*                                             Qmh Relational Test Entry
     D QMHRO                   1     10
     D*                                             Relational Operator
     D QMHERVED27             11     12
     D*                                             Reserved
     D QMHLRV                 13     16B 0
     D*                                             Length Relational Value
     D*QMHRV                  17     17
     D*
     D*                               Varying length
     D*****************************************************************
     D*Type Definition for the Dump List Entry
     D*****************************************************************
     D*****************************************************************
     D*Type Definition for the RTVM0300 format.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHM030000       DS
     D*                                             Qmh Rtvm RTVM0300
     D QMHBR03                 1      4B 0
     D*                                             Bytes Return
     D QMHBAVL09               5      8B 0
     D*                                             Bytes Available
     D QMHMS09                 9     12B 0
     D*                                             Message Severity
     D QMHAI00                13     16B 0
     D*                                             Alert Index
     D QMHAO03                17     25
     D*                                             Alert Option
     D QMHLI02                26     26
     D*                                             Log Indicator
     D QMHMID                 27     33
     D*                                             Message ID
     D QMHERVED19             34     36
     D*                                             Reserved
     D QMHNRDF                37     40B 0
     D*                                             Number Replace Data Formats
     D QMHSIDCS07             41     44B 0
     D*                                             Text CCSID Convert Status
     D QMHSIDCS08             45     48B 0
     D*                                             Data CCSID Convert Status
     D QMHCSIDR07             49     52B 0
     D*                                             Text CCSID Returned
     D QMHORT                 53     56B 0
     D*                                             Offset Reply Text
     D QMHLRRTN00             57     60B 0
     D*                                             Length Reply Returned
     D QMHLRAVL00             61     64B 0
     D*                                             Length Reply Available
     D QMHOMRTN               65     68B 0
     D*                                             Offset Message Returned
     D QMHLMRTN04             69     72B 0
     D*                                             Length Message Returned
     D QMHLMAVL04             73     76B 0
     D*                                             Length Message Available
     D QMHOHRTN               77     80B 0
     D*                                             Offset Help Returned
     D QMHLHRTN04             81     84B 0
     D*                                             Length Help Returned
     D QMHLHAVL04             85     88B 0
     D*                                             Length Help Available
     D QMHOF                  89     92B 0
     D*                                             Offset Formats
     D QMHLFRTN               93     96B 0
     D*                                             Length Formats Returned
     D QMHLFAVL               97    100B 0
     D*                                             Length Formats Available
     D QMHLFE                101    104B 0
     D*                                             Length Format Element
     D*QMHRSV203             105    105
     D*
     D*                                  Varying length
     D*QMHDR00               106    106
     D*
     D*                                  Varying length
     D*QMHSSAGE04            107    107
     D*
     D*                                  Varying length
     D*QMHMH04               108    108
     D*
     D*                                  Varying length
     D*QMHRDF                        18    DIM(00001)
     D* QMHLSRD00                     9B 0 OVERLAY(QMHRDF:00001)
     D* QMHFSODP00                    9B 0 OVERLAY(QMHRDF:00005)
     D* QMHSVT00                     10    OVERLAY(QMHRDF:00009)
     D*
     D*
     D*                                  Varying length
     D*****************************************************************
     D*Type Definition for the RTVM0400 format.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHM0400         DS
     D*                                             Qmh Rtvm RTVM0400
     D QMHBR08                 1      4B 0
     D*                                             Bytes Return
     D QMHBAVL14               5      8B 0
     D*                                             Bytes Available
     D QMHMS11                 9     12B 0
     D*                                             Message Severity
     D QMHAI01                13     16B 0
     D*                                             Alert Index
     D QMHAO04                17     25
     D*                                             Alert Option
     D QMHLI03                26     26
     D*                                             Log Indicator
     D QMHMID00               27     33
     D*                                             Message ID
     D QMHERVED28             34     36
     D*                                             Reserved
     D QMHNRDF00              37     40B 0
     D*                                             Number Replace Data Formats
     D QMHSIDCS09             41     44B 0
     D*                                             Text CCSID Convert Status
     D QMHSIDCS10             45     48B 0
     D*                                             Data CCSID Convert Status
     D QMHCSIDR08             49     52B 0
     D*                                             Text CCSID Returned
     D QMHORT00               53     56B 0
     D*                                             Offset Reply Text
     D QMHLRRTN01             57     60B 0
     D*                                             Length Reply Returned
     D QMHLRAVL01             61     64B 0
     D*                                             Length Reply Available
     D QMHOMRTN00             65     68B 0
     D*                                             Offset Message Returned
     D QMHLMRTN05             69     72B 0
     D*                                             Length Message Returned
     D QMHLMAVL05             73     76B 0
     D*                                             Length Message Available
     D QMHOHRTN00             77     80B 0
     D*                                             Offset Help Returned
     D QMHLHRTN05             81     84B 0
     D*                                             Length Help Returned
     D QMHLHAVL05             85     88B 0
     D*                                             Length Help Available
     D QMHOF00                89     92B 0
     D*                                             Offset Formats
     D QMHLFRTN00             93     96B 0
     D*                                             Length Formats Returned
     D QMHLFAVL00             97    100B 0
     D*                                             Length Formats Available
     D QMHLFE00              101    104B 0
     D*                                             Length Format Element
     D QMHRT02               105    114
     D*                                             Reply Type
     D QMHRSV210             115    116
     D*                                             Reserved2
     D QMHMRL                117    120B 0
     D*                                             Maximum Reply Length
     D QMHMRDP               121    124B 0
     D*                                             Maximum Reply Dec Positions
     D QMHOVR                125    128B 0
     D*                                             Offset Valid Replies
     D QMHNBRVR              129    132B 0
     D*                                             Number Valid Replies
     D QMHLVRR               133    136B 0
     D*                                             Length Valid Replies Returne
     D QMHLVRA               137    140B 0
     D*                                             Length Valid Replies Availab
     D QMHLVRE               141    144B 0
     D*                                             Length Valid Reply Entry
     D QMHOSV                145    148B 0
     D*                                             Offset Special Value
     D QMHNBRSV              149    152B 0
     D*                                             Number Special Value
     D QMHLSVR               153    156B 0
     D*                                             Length Special Value Returne
     D QMHLSVA               157    160B 0
     D*                                             Length Special Value Availab
     D QMHLSVE               161    164B 0
     D*                                             Length Special Value Entry
     D QMHOLR                165    168B 0
     D*                                             Offset Lower Range
     D QMHLLRR               169    172B 0
     D*                                             Length Lower Range Returned
     D QMHLLRA               173    176B 0
     D*                                             Length Lower Range Available
     D QMHOUR                177    180B 0
     D*                                             Offset Upper Range
     D QMHLURR               181    184B 0
     D*                                             Length Upper Range Returned
     D QMHLURA               185    188B 0
     D*                                             Length Upper Range Available
     D QMHORT01              189    192B 0
     D*                                             Offset Rel Test
     D QMHLRTR               193    196B 0
     D*                                             Length Rel Test Returned
     D QMHLRTA               197    200B 0
     D*                                             Length Rel Test Available
     D QMHMCD                201    207
     D*                                             Message Creation Date
     D QMHRSV300             208    208
     D*                                             Reserved3
     D QMHMCL                209    212B 0
     D*                                             Message Creation Level
     D QMHMMD                213    219
     D*                                             Message Modification Date
     D QMHRSV400             220    220
     D*                                             Reserved4
     D QMHMML03              221    224B 0
     D*                                             Message Modification Level
     D QMHCCSID07            225    228B 0
     D*                                             Stored Message CCSID
     D QMHODL                229    232B 0
     D*                                             Offset Dump List
     D QMHNDLE               233    236B 0
     D*                                             Number Dump List Entries
     D QMHLDLR               237    240B 0
     D*                                             Length Dump List Returned
     D QMHLDLA               241    244B 0
     D*                                             Length Dump List Available
     D QMHDPGMN              245    254
     D*                                             Default Program Name
     D QMHDPGML              255    264
     D*                                             Default Program Library
     D*QMHRSV400             265    265
     D*
     D*                                  Varying length
     D*QMHDR01               266    266
     D*
     D*                                  Varying length
     D*QMHSSAGE05            267    267
     D*
     D*                                  Varying length
     D*QMHMH05               268    268
     D*
     D*                                  Varying length
     D*QMHRDF00                      18    DIM(00001)
     D* QMHLSRD01                     9B 0 OVERLAY(QMHRDF00:00001)
     D* QMHFSODP01                    9B 0 OVERLAY(QMHRDF00:00005)
     D* QMHSVT01                     10    OVERLAY(QMHRDF00:00009)
     D*
     D*
     D*                                  Varying length
     D*QMHVRE00                      33    DIM(00001)
     D* QMHVRV00                     32    OVERLAY(QMHVRE00:00001)
     D* QMHERVED29                    1    OVERLAY(QMHVRE00:00033)
     D*
     D*
     D*                                  Varying length
     D*QMHSRVE00                     65    DIM(00001)
     D* QMHFV00                      32    OVERLAY(QMHSRVE00:00001)
     D* QMHTV00                      32    OVERLAY(QMHSRVE00:00033)
     D* QMHERVED30                    1    OVERLAY(QMHSRVE00:00065)
     D*
     D*
     D*                                  Varying length
     D*QMHLRV00              385    385
     D*
     D*                                  Varying length
     D*QMHURV                386    386
     D*
     D*                                  Varying length
     D*QMHRTE00                      17    DIM(00001)
     D* QMHRO00                      10    OVERLAY(QMHRTE00:00001)
     D* QMHERVED31                    2    OVERLAY(QMHRTE00:00011)
     D* QMHLRV01                      9B 0 OVERLAY(QMHRTE00:00013)
     D* QMHRV00                       1    OVERLAY(QMHRTE00:00017)
     D*
     D*
     D*                                  Varying length
     D*Qmh_Dump_List_Entry_t;
     D*                                  Varying length

     d sqlMsgFile      c                   'QSQLMSG   *LIBL     '
     d keyMsgf         c                   'SPYKEYMSGF*LIBL     '

     d rtvMsgPrc       pr                  extpgm('QMHRTVM')
     d  receiver                           like(receiverDS)
     d  receiverLen                  10I 0 const
     d  format                        8    const
     d  msgid                         7    const
     d  messageFile                  20
     d  replcmntData                255
     d  lenReplcData                 10i 0 const
     d  rplcSubVals                  10    const
     d  rtnFmtCtlChrs                10    const
     d  error                              likeds(qusec)

     d receiverDS      ds                  likeds(QMHM010004)

     d msgFile         s             20    inz(keyMsgf)
     d msgDta          s            255

      /free
       clear qusec;
       qusbavl = %size(qusec);
       if %subst(msgID:1:3) = 'SQL';
         msgFile = sqlMsgFile;
       endif;
       msgDta = msgDtaIn;
       rtvMsgPrc(receiverDS:%size(receiverDS)+255:'RTVM0100':msgid:msgFile:
         msgdta:%len(%trimr(msgDta)):'*YES':'*NO':qusec);
       return %str(%addr(receiverDS)+%size(receiverDS):receiverDS.QMHLMRTN02);
      /end-free
     p                 e
      //************************************************************************
     p setProductAttr  b
     d                 pi            10i 0
     d keycodeObject                       likeds(keycodeObject_t)
     d rc              s             10i 0 inz(OK)
     d i               s             10i 0 inz(0)
     d x               s             10i 0 inz(0)
     d licensedProds   ds                  likeds(licensed) dim(20) inz
     d maxProds        s             10i 0 inz(%elem(licensedProds))
     d systemID        s                   like(master.skmsid)
     d sequence        s                   like(master.skmis#)
      /free
       clear keycodeObject.products;
       systemID = keycodeObject.customer.systemID;
       sequence = keycodeObject.customer.sequence;
       setMessage(keycodeObject.message:OK:'OK');
       getProductList(keycodeObject);
       // Get list of licensed products.
       if setCursor('select * from ' + %trimr(pgmLib) + '/spykeylic where ' +
         'sklsid = ' + sq + %trim(systemID) + sq + ' and sklis# = ' +
         %trim(%char(sequence)):keycodeObject.message) <> OK;
         return ERROR;
       endif;
       //*exec sql fetch csr for :maxProds rows into :licensedProds;
      /END-FREE                                                                 SQL
     C                   EVAL      SQLER5       = MAXPRODS                      SQL
     C                   Z-ADD     -4            SQLER6                         SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00196                      SQL
     C                   PARM                    LICENSEDPRODS                  SQL
      /FREE                                                                     SQL
       //*exec sql close csr;
      /END-FREE                                                                 SQL
     C                   Z-ADD     27            SQLER6                         SQL
     C     SQL_00204     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00202                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00202                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       // Roll through list of products and set product attributes. Selected,
       // expiration date, etc.
       for x = 1 to %elem(keycodeObject.products);
         // Lookup licensed products and mark keycodObject products accordingly
         // At the time of this writing, %lookup did not allow qualified objects
         // as part of the parm list, thus, the 'for' loop;
         keycodeObject.products(x).selected = 'N';
         keycodeObject.products(x).expiryDateISO = 0;
         keycodeObject.products(x).nbrUsrLic = 0;
         for i = 1 to %elem(licensedProds);
           if keycodeObject.products(x).id = licensedProds(i).sklprd;
             keycodeObject.products(x).selected = 'Y';
             keycodeObject.products(x).expiryDateISO =
               licensedProds(i).skldmo;
             keycodeObject.products(x).nbrUsrLic =
               licensedProds(i).skl#us;
             if keycodeObject.products(x).id = TIFFVIEWERID;
       //*        exec sql select * into :tif from spykeylib/spykeytif
       //*           where sktsid = :systemID and sktis# = :sequence;
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00213    = SYSTEMID                      SQL
     C                   EVAL      SQL_00214    = SEQUENCE                      SQL
     C                   Z-ADD     -4            SQLER6                         SQL   28
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00208                      SQL
     C     SQL_00211     IFEQ      '1'                                          SQL
     C                   EVAL      TIF.SKTSID = SQL_00215                       SQL
     C                   EVAL      TIF.SKTPFM = SQL_00216                       SQL
     C                   EVAL      TIF.SKTIS# = SQL_00217                       SQL
     C                   EVAL      TIF.SKTSVR = SQL_00218                       SQL
     C                   EVAL      TIF.SKTKCD = SQL_00219                       SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
               if sqlcod = OK;
                 keycodeObject.products(x).thirdPartyID = tif.sktsvr;
                 keycodeObject.products(x).thirdPartyKey = tif.sktkcd;
               endif;
             endif;
             leave;
           endif;
         endfor;
       endfor;
       return rc;
      /end-free
     p                 e
      //************************************************************************
     p validateKeycodeObject...
     p                 b
     d                 pi            10i 0
     d keycodeObject                       likeds(keycodeObject_t)
     d versionList     ds                  likeds(versionList_t)
     d platformList    ds                  likeds(platformList_t)
     d fieldStatus     s             10i 0
     d i               s             10i 0 inz
     d dateChk         s              8  0
     d aDate           s               d
      /free
       if keycodeObject.customer.name = ' ';
         setMessage(keycodeObject.message:ERROR:'Name cannot be blank.');
         return ERROR;
       endif;
       if keycodeObject.customer.systemID = ' ';
         setMessage(keycodeObject.message:ERROR:'System ID cannot be blank.');
         return ERROR;
       endif;
       fieldStatus = ERROR;
       getPlatformList(platformList);
       for i = 1 to %elem(platFormList.platform);
         if platFormList.platform(i) = ' '; // End of list.
           leave;
         endif;
         if keycodeObject.customer.platform = platformList.platform(i);
           fieldStatus = OK;
           leave;
         endif;
       endfor;
       if fieldStatus <> OK;
         setMessage(keycodeObject.message:ERROR:'Platform invalid.');
         return ERROR;
       endif;
       fieldStatus = ERROR;
       getVersionList(keycodeObject.customer.platform:versionList);
       for i = 1 to %elem(versionList.version);
         if versionList.version(i) = 0; //End of list
           leave;
         endif;
         if keycodeObject.customer.version = versionList.version(i);
           fieldStatus = OK;
           leave;
         endif;
       endfor;
       if fieldStatus <> OK;
         setMessage(keycodeObject.message:ERROR:'Version invalid.');
         return ERROR;
       endif;
       if keycodeObject.customer.platform = '400';
         if keycodeObject.customer.model = ' ';
           setMessage(keycodeObject.message:ERROR:'Model cannot be blank.');
           return ERROR;
         endif;
         if keycodeObject.customer.featureCode = ' ';
           setMessage(keycodeObject.message:ERROR:
             'Feature code cannot be blank.');
           return ERROR;
         endif;
         if keycodeObject.customer.version >= 808;
           if keycodeObject.customer.logicalPartition = 0;
             keycodeObject.customer.logicalPartition = 1;
           endif;
           if keycodeObject.customer.logicalPartition > 255;
             setMessage(keycodeObject.message:ERROR:
               'Logical partition must be between 1 and 255.');
             return ERROR;
           endif;
         endif;
       endif;
       if keycodeObject.customer.customerRecordFlag <> 'N' and
         keycodeObject.customer.customerRecordFlag <> 'Y';
         setMessage(keycodeObject.message:ERROR:
           'Customer record flag must be Y or N');
         return ERROR;
       endif;
       for i = 1 to %elem(keycodeObject.products); //Check products.
         if keycodeObject.products(i).id = 0; //End of list.
           leave;
         endif;
         if keycodeObject.products(i).selected <> 'Y' and
           keycodeObject.products(i).selected <> 'N';
           setMessage(keycodeObject.message:ERROR:'Selected flag for ' +
             %trimr(keycodeObject.products(i).description) +
             ' must be Y or N.');
           return ERROR;
         endif;
         if keycodeObject.products(i).selected = 'N';
           iter; //Only validate selected products.
         endif;
         if keycodeObject.products(i).expiryDateISO = 0;
           aDate = %date();
           aDate = aDate + %months(1);
           keycodeObject.products(i).expiryDateISO =
              %int(%char(aDate:*iso0));
         endif;
         if keycodeObject.products(i).expiryDateISO <> NOEXPIRE;
           dateChk = keycodeObject.products(i).expiryDateISO;
           test(de) *iso dateChk;
           if %error;
             setMessage(keycodeObject.message:ERROR:'Expiry date for ' +
               %trimr(keycodeObject.products(i).description) +
               ' invalid or not in ISO format.');
             return ERROR;
           endif;
           if %date(%char(dateChk):*iso0) > %date() + %years(5);
             setMessage(keycodeObject.message:ERROR:'Expiry date for ' +
               %trimr(keycodeObject.products(i).description) +
               ' cannot exceed 5 years.');
             return ERROR;
           endif;
         endif;
         if keycodeObject.products(i).userBased = 'Y' and
           keycodeObject.products(i).nbrUsrLic = 0;
           keycodeObject.products(i).nbrUsrLic = 999;
         endif;
       endfor;
       return OK;
      /end-free
     p                 e
      //************************************************************************
     p doHistory       b
     d                 pi            10i 0
     d from                                likeds(keycodeObject_t)
     d to                                  likeds(keycodeObject_t)
     d i               s             10i 0
     d dataKey         s                   like(history.skhdky)
     d chgVal          s                   like(history.skhcto)
      /free
       clear history;
       history.skhsid = to.customer.systemID;
       history.skhpfm = to.customer.platform;
       history.skhis# = to.customer.sequence;
       history.skhdlc = %int(%char(%date():*iso0));
       history.skhtlc = %int(%char(%time():*iso0));
       history.skhulc = curUser;
       history.skhver = to.customer.version;
       if from.customer.version <> to.customer.version;
         writeHistory('Version':%triml(%editc(from.customer.version:'Z')):
           %triml(%editc(to.customer.version:'Z')));
       endif;
       if from.customer.model <> to.customer.model;
         writeHistory('Model':%trim(from.customer.model):
           %trim(to.customer.model));
       endif;
       if from.customer.featureCode <> to.customer.featureCode;
         writeHistory('Processor Feature':%trim(from.customer.featureCode):
           %trim(to.customer.featureCode));
       endif;
       if from.customer.logicalPartition <> to.customer.logicalPartition;
         writeHistory('Logical Partition':
           %triml(%editc(from.customer.logicalPartition:'Z')):
           %triml(%editc(to.customer.logicalPartition:'Z')));
       endif;
       for i = 1 to %elem(to.products);
         if to.products(i).id = 0;
           leave;
         endif;
         if from.products(i).selected <> to.products(i).selected;
           chgVal = '*ADDED';
           if to.products(i).selected = 'N';
             chgVal = '*DELETED';
           endif;
           exsr setDataKey;
           writeHistory(dataKey:' ':chgVal);
           iter;
         endif;
         if from.products(i).expiryDateISO <> to.products(i).expiryDateISO;
           exsr setDataKey;
           writeHistory(dataKey:
             %triml(%editw(from.products(i).expiryDateISO:'      /  /  ')):
             %triml(%editw(to.products(i).expiryDateISO:'      /  /  ')));
         endif;
         if from.products(i).nbrUsrLic <> to.products(i).nbrUsrLic;
           writeHistory('Users:' + to.products(i).description:
            %triml(%editc(from.products(i).nbrUsrLic:'Z')):
            %triml(%editc(to.products(i).nbrUsrLic:'Z')));
         endif;
       endfor;
       return OK;
       begsr setDataKey;
         dataKey = ' ';
         if (from.products(i).expiryDateISO > 0 and
           from.products(i).expiryDateISO < 99999999) or
           (to.products(i).expiryDateISO > 0 and
           to.products(i).expiryDateISO < 99999999);
           dataKey = 'Demo:';
         endif;
         dataKey = %trimr(dataKey) + from.products(i).description;
       endsr;
      /end-free
     p                 e
      //************************************************************************
     p writeHistory    b
     d                 pi
     d dataKey                             like(history.skhdky) const
     d fromVal                             like(history.skhcfr) const
     d toVal                               like(history.skhcto) const
      /free
       history.skhdky = dataKey;
       history.skhcfr = fromVal;
       history.skhcto = toVal;
       //*exec sql insert into spykeylib/spykeyhis values(:history);
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00225    = HISTORY.SKHSID                SQL
     C                   EVAL      SQL_00226    = HISTORY.SKHPFM                SQL
     C                   EVAL      SQL_00227    = HISTORY.SKHIS#                SQL
     C                   EVAL      SQL_00228    = HISTORY.SKHDLC                SQL
     C                   EVAL      SQL_00229    = HISTORY.SKHTLC                SQL
     C                   EVAL      SQL_00230    = HISTORY.SKHULC                SQL
     C                   EVAL      SQL_00231    = HISTORY.SKHDKY                SQL
     C                   EVAL      SQL_00232    = HISTORY.SKHCFR                SQL
     C                   EVAL      SQL_00233    = HISTORY.SKHCTO                SQL
     C                   EVAL      SQL_00234    = HISTORY.SKHVER                SQL
     C                   EVAL      SQL_00235    = HISTORY.SKHPRD                SQL
     C                   Z-ADD     -4            SQLER6                         SQL   29
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00220                      SQL
      /FREE                                                                     SQL
       return;
      /end-free
     p                 e
      //************************************************************************
     p generateKeycode...
     p                 b
     d                 pi
     d keyObj                              likeds(keycodeObject_t)

     d md5Hash         pr                  extproc('MD5HashAsc2')
     d  pKey                      32767a   options(*varsize)
     d  iKeyLen                      10i 0 value
     d  pData                     32767a   options(*varsize)
     d  iDataLen                     10i 0 value
     d  digest                       16a
     d THIS_KEY        s             50    inz('GaussVistaPlusInIrvineCA')
     d i               s             10i 0
     d idSize          s             10i 0
     d pDataLen        s             10i 0
     d pData           s          32767a
     d keyLen          s             10i 0 inz(%size(master.skmsid))
     d untieSysID      s               n   inz('0')
      /free
       if ((keyObj.customer.platform = 'NT' or
         keyObj.customer.platform = '400' or
         keyObj.customer.platform = 'UNIX') and
         keyObj.customer.version >= 807) or
         %subst(keyObj.customer.platform:1:2) = 'VP' and
         keyObj.customer.version >= 0505;
         untieSysID = '1';
       endif;
       // IF VERSION OLDER THAN 7.00.00 USE OLD KEY CODE GENERATOR.
       if keyObj.customer.version < 0700 and keyObj.customer.platform = '400';
         //exsr oldGenKey;
       else;
         // HASH UP CLIENT DATA.
         pdata =  %trimr(keyObj.customer.platform) +
           %trim(keyObj.customer.systemID) +
           %triml(%editc(keyObj.customer.version:'3')) +
           %trim(keyObj.customer.model) +
           %trim(%trim(keyObj.customer.featureCode));
         if untieSysID;
           pdata =  %trimr(keyObj.customer.platform) +
           %triml(%editc(keyObj.customer.version:'3'));
         endif;
         // HASH UP LICENSED PRODUCTS.
         for i = 1 to %elem(keyObj.products);
           if keyObj.products(i).id = 0;
             leave;
           endif;
           if keyObj.products(i).selected <> 'Y';
             iter;
           endif;
           pdata = %trimr(pdata) +
               %triml(%editc(keyObj.products(i).id:'3')) +
               %triml(%editc(keyObj.products(i).nbrUsrLic:'3'))
               + %triml(%editc(keyObj.products(i).expiryDateISO:'3'));
           if untieSysID and keyObj.products(i).expiryDateISO =
             NOEXPIRE;
             pdata = %trim(pdata) + %trim(keyObj.customer.systemID) +
               %trim(keyObj.customer.model) +
               %trim(keyObj.customer.featureCode) +
               %trim(%editc(keyObj.customer.logicalPartition:'Z'));
           endif;
         endfor;
         // ENCRYPT THE KEY.
         idSize = %len(keyObj.customer.systemID);
         pDataLen = %len(%trim(pData));
         if keyObj.customer.platform <> '400';
           keyLen = %len(%trim(keyObj.customer.systemID));
         endif;
         keyObj.customer.keycode = ' ';
         if untieSysID;
           md5Hash(THIS_KEY:%len(%trim(THIS_KEY)):pData:
               %len(%trim(pData)):keyObj.customer.keycode);
         else;
           md5hash(keyObj.customer.systemID:keyLen:pdata:
               %len(%trim(pData)):keyObj.customer.keycode);
         endif;
       endif;
       return;
      /end-free
     p                 e
      //************************************************************************
     p checkProductVersion...
     p                 b
     d                 pi            10i 0
     d version                             like(customer_t.version)
     d platform                            like(customer_t.platform)
     d productID                           like(product_t.id)
      /free
       //*exec sql select * into :product from spykeylib/spykeyprd
       //*  where skpprd = :productID and skppfm = :platform and
       //*  :version between skpavf and skpavt;
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00241    = PRODUCTID                     SQL
     C                   EVAL      SQL_00242    = PLATFORM                      SQL
     C                   EVAL      SQL_00243    = VERSION                       SQL
     C                   Z-ADD     -4            SQLER6                         SQL   30
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00236                      SQL
     C     SQL_00239     IFEQ      '1'                                          SQL
     C                   EVAL      PRODUCT.SKPPFM = SQL_00244                   SQL
     C                   EVAL      PRODUCT.SKPPRD = SQL_00245                   SQL
     C                   EVAL      PRODUCT.SKPDSC = SQL_00246                   SQL
     C                   EVAL      PRODUCT.SKPUTL = SQL_00247                   SQL
     C                   EVAL      PRODUCT.SKPAVF = SQL_00248                   SQL
     C                   EVAL      PRODUCT.SKPAVT = SQL_00249                   SQL
     C                   EVAL      PRODUCT.SKPKCA = SQL_00250                   SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       if sqlcod <> OK;
         return ERROR;
       endif;
       return OK;
      /end-free
     p                 e
      //************************************************************************
     p getHistory      b                   export
     d                 pi
     d systemID                            like(master.skmsid) const
     d sequence                            like(sequenceNumber_t) const
     d hisRec                              likeds(historyReturn_t)
     d maxRec          s             10i 0 inz(50)
     d hRec            ds                  likeds(history_t) dim(50)
      /free
       clear hisRec;
       setMessage(hisRec.message:OK:'OK');
       clear hRec;
       if setCursor('select  skhdlc, skhtlc, skhulc, skhdky, skhcfr, skhcto, ' +
         'skhver from ' + %trimr(pgmLib) + '/spykeyhis where skhsid = ' +
         'ucase(' + sq + %trim(systemID) + sq + ') and skhis# = ' +
         %triml(%editc(sequence:'Z')) + ' order by skhdlc desc, skhtlc desc':
         hisRec.message) = OK;
       //*  exec sql fetch csr for :maxRec rows into :hRec;
      /END-FREE                                                                 SQL
     C                   EVAL      SQLER5       = MAXREC                        SQL
     C                   Z-ADD     -4            SQLER6                         SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00251                      SQL
     C                   PARM                    HREC                           SQL
      /FREE                                                                     SQL
         if sqlcod <> OK;
           setMessage(hisRec.message:ERROR:rtvMsg('SQL' +
             %subst(%editc(%abs(sqlcod):'X'):6:4):sqlerm));
         else;
           hisRec.hist = hRec;
         endif;
       endif;
       //*exec sql close csr;
      /END-FREE                                                                 SQL
     C                   Z-ADD     32            SQLER6                         SQL
     C     SQL_00259     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00257                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00257                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       return;
      /end-free
     p                 e

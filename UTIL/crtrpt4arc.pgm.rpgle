      *%METADATA                                                       *
      * %TEXT Create reports for archive                               *
      *%EMETADATA                                                      *
   1 h dftactgrp(*no) bnddir('MYBNDDIR')
   2 frmaint    o    e           k disk
   3 frindex    o    e           k disk
   4 frlnkdef   o    e           k disk
   5 frsecur    o    e           k disk
   6 fqsysprt   o    f   80        printer usropn
   7
      /copy 'UTIL/@run.rpgleinc'
  10
  11 d getRdm          pr            10i 0 extproc('getRdm')
  12 d  mod                          10i 0 value
  13
  14 d numRpts         s             10i 0
  15 d numPgs          s             10i 0
  16 d rptnam          s             10
  17 d x               s             10i 0
  18 d y               s             10i 0
  19 d z               s             10i 0
  20
  21 d secflags        ds
  22 d  sread
  23 d  sdel
  24 d  sprnt
  25 d  schg
  26 d  scopy
  27 d  sattr
  28 d  ssec
  29 d  scfg
  30 d  slink
  31 d  sbak
  32 d  srst
  33 d  sseg
  34 d  smove
  35 d ival            s             40
  36
  37 c     *entry        plist
  38 c                   parm                    numRptsC          5
  39 c                   parm                    superuser        10
  40 c                   parm                    joeuser          10
  41
  42 c                   move      numRptsC      numRpts
  43
  44 c                   do        numRpts       x
  45
  46 c                   eval      rptnam = 'RPT' + %subst(%editc(x:'X'):6:5)
  47 c                   callp     run('ovrprtf qsysprt splfname('+rptnam+')')
  48 c                   open      qsysprt
  49
  50 c                   except    header
  51
  52 c                   do        7             y
  53 c                   eval      z = getRdm(7)
  54 c                   eval      ival = 'IndexVal' + %triml(%editc(y:'Z')) +
  55 c                             ': ' + %editc(z:'X')
  56 c                   except    detail
  57 c                   enddo
  58
  59 c                   close     qsysprt
  60 c                   callp     run('dltovr *all')
  61 c                   eval      page = 0
  62
  63  * write rmaint record
  64 c                   clear                   rmntrc
  65 c                   eval      rrnam = rptnam
  66 c                   eval      rsec = 'Y'
  67 c                   eval      rtypid = rptnam
  68 c                   write     rmntrc
  69
  70  * write rlnkdef record
  71 c                   clear                   lnkdef
  72 c                   eval      lrnam = rptnam
  73 c                   eval      lndxn1 = '@INDEX1'
  74 c                   eval      lndxn2 = '@INDEX2'
  75 c                   eval      lndxn3 = '@INDEX3'
  76 c                   eval      lndxn4 = '@INDEX4'
  77 c                   eval      lndxn5 = '@INDEX5'
  78 c                   eval      lndxn6 = '@INDEX6'
  79 c                   eval      lndxn7 = '@INDEX7'
  80 c                   write     lnkdef
  81
  82  * write rindex record
  83 c                   clear                   indexrc
  84 c                   eval      ipln# = 10
  85 c                   eval      iscol = 12
  86 c                   eval      iklen = 10
  87 c                   eval      iinda = 'N'
  88 c                   eval      ipmtl = 10
  89 c                   eval      ipmtsl = 1
  90 c                   eval      ipmtel = 999
  91 c                   eval      ipmtsc = 1
  92 c                   eval      ipmtec = 10
  93 c                   eval      ipmtrl = 0
  94 c                   eval      ipmtrc = 11
  95 c                   eval      iloc = 'N'
  96 c                   eval      iicmd = 1
  97 c                   do        7             y
  98 c                   eval      irnam = rptnam
  99 c                   eval      iinam = '@INDEX' + %triml(%editc(y:'Z'))
 100 c                   eval      idesc = 'INDEX' + %triml(%editc(y:'Z'))
 101 c                   eval      ipln# = ipln# + 1
 102 c                   eval      iprmpt = 'IndexVal'+%triml(%editc(y:'Z'))+':'
 103 c                   write     indexrc
 104 c                   enddo
 105
 106  * write rsecur record
 107 c                   clear                   secrc
 108 c                   eval      srnam = rptnam
 109 c                   eval      suser = superuser
 110 c                   eval      ssidty = 'U'
 111 c                   eval      secflags = *all'Y'
 112 c                   eval      sauth = '*ALL'
 113 c                   write     secrc
 114 c                   eval      suser = joeuser
 115 c                   eval      secflags = *all'N'
 116 c                   write     secrc
 117
 118 c                   enddo
 119
 120 c                   eval      *inlr = '1'
 121
 122 oqsysprt   e            header        10  1
 123 o                                           75 'Page:'
 124 o                       page                80
 125 o          e            detail         1
 126 o                       ival                40

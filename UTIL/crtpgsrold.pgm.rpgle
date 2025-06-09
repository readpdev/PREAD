     h dftactgrp(*no) bnddir('QC2LE')

     frmaint    uf a e           k disk
     frindex    o    e           k disk
     frlnkdef   o    e           k disk
     fqsysprt   o    f  247        printer usropn

     d run             pr                  extproc('system')
     d  cmd                            *   value options(*string)

     d x               s             10i 0
     d y               s             10i 0
     d detailData      s            247
     d reportName      s             10
     d lineCount       s             10i 0
     d ruler           s            247
     d rulerA          s            100    dim(1) perrcd(1) ctdata

     d sysdft          ds          1024    dtaara
     d  exclRptNam                    1    overlay(sysdft:252)
     d  exclJobNam                    1    overlay(sysdft:253)
     d  exclPgmNam                    1    overlay(sysdft:254)
     d  exclUsrNam                    1    overlay(sysdft:255)
     d  exclUsrDta                    1    overlay(sysdft:256)

     d                sds
     d thisPgm           *proc
     d curUser               254    263

     d pgs             s             10i 0
     d summaryIndex    s               n   inz('0')

     c     *entry        plist
     c                   parm                    numRpts           6 0
     c                   parm                    iterations        6 0
     c                   parm                    numPgs            6 0
     c                   parm                    preFix            3
     c                   parm                    rptName          10
     c                   parm                    rptWidth          3 0
     c                   parm                    crtNdx            1
     c                   parm                    nbrIndices        2 0

     c                   eval      reportName = rptName
     c                   for       x = 1 to 3
     c                   eval      ruler = %trim(ruler) + rulerA(1)
     c                   endfor

     c                   do        numRpts       x

     c                   if        numRpts > 1
     c                   eval      reportName = %trim(prefix) +
     c                             %subst(%editc(x:'X'):4:7)
     c                   endif
     c                   callp     run('ovrprtf qsysprt splfname(' +
     c                             %trim(reportName) + ') ' +
     c                             'PAGESIZE(*N ' + %char(rptWidth) + ')')

     c                   do        iterations

     c                   open      qsysprt

     c                   eval      y = 0
     c                   eval      lineCount = 0
     c                   do        numPgs        pgs
     c                   except    header
      /free
       if not summaryIndex;
         summaryIndex = '1';
         detailData = 'SUMMARYPROMPT: SUMMARYVALUE';
         except detail;
       endif;
      /end-free
     c                   do        60
     c                   eval      detailData = *all'TEST'
     c                   if        lineCount > 5
     c                   eval      y = y + 1
     c                   if        y > 7
     c                   eval      y = 1
     c                   endif
 102 c                   eval      detailData=
     c                             'IndexVal'+%triml(%editc(y:'Z'))+': ' +
     c                             'IVAL' + %triml(%editc(y:'Z')) + 'P' +
     c                             %triml(%editc(pgs:'Z'))
     c                   eval      lineCount = 0
     c                   endif
     c                   eval      lineCount = lineCount + 1
     c                   except    detail
     c                   enddo
     c                   enddo

     c                   close     qsysprt
     c***                eval      pageNbr = 0

      * Create index definitions.
     c                   if        crtNdx = 'Y'
  63  * write rmaint record
  64 c                   clear                   rmntrc
     c                   in        sysdft
     c                   if        exclRptNam = 'N'
  65 c                   eval      rrnam = reportName
     c                   endif
     c                   if        exclJobNam = 'N'
     c                   eval      rjnam = 'JOBNAME'
     c                   endif
     c                   if        exclPgmNam = 'N'
     c                   eval      rpnam = thisPgm
     c                   endif
     c                   if        exclUsrNam = 'N'
     c                   eval      runam = curUser
     c                   endif
     c                   if        exclUsrDta = 'N'
     c                   eval      rudat = thisPgm
     c                   endif
  66 c                   eval      rsec = 'Y'
  67 c                   eval      rtypid = reportName

     c     big5key       setll     rmaint                                 68
     c                   if        %equal
     c                   iter
     c                   endif

  68 c                   write     rmntrc
  69
     c     big5key       klist
     c                   kfld                    rrnam
     c                   kfld                    rjnam
     c                   kfld                    rpnam
     c                   kfld                    runam
     c                   kfld                    rudat

  70  * write rlnkdef record
  71 c                   clear                   lnkdef
  72 c                   eval      lrnam = rrnam
     c                   eval      ljnam = rjnam
     c                   eval      lpnam = rpnam
     c                   eval      lunam = runam
     c                   eval      ludat = rudat
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
  98 c                   eval      irnam = rrnam
     c                   eval      ijnam = rjnam
     c                   eval      ipnam = rpnam
     c                   eval      iunam = runam
     c                   eval      iudat = rudat
     c                   eval      iinam = '@INDEX' + %triml(%editc(y:'Z'))
     c                   eval      idesc = 'INDEX' + %triml(%editc(y:'Z'))
     c                   eval      ipln# = ipln# + 1
     c                   eval      iprmpt = 'IndexVal'+%triml(%editc(y:'Z'))+':'
     c                   write     indexrc
     c                   enddo
     c                   endif

     c                   enddo

     c                   callp     run('dltovr ' + %trim(reportName))

     c                   enddo

     c                   eval      *inlr = '1'

     oqsysprt   e            header         1  1
     o                       ruler              247
     o          e            header         1
     o                       *date         y
     o                                              '     '
     o                                              'Page: '
     o                       pgs           z
     o          e            detail         1
     o                       detailData         247
**ctdata rulerA
....+... 1 ...+... 2 ...+... 3 ...+... 4 ...+... 5 ...+... 6 ...+... 7 ...+... 8

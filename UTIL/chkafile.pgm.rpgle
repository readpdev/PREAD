     h dftactgrp(*no) bnddir('MYBNDDIR')

     fRAPFDBFP  if   e           k disk    usropn
     fRAPFDBF   if   e           k disk    usropn
     fmflddir   if   e           k disk
     fqsysprt   o    f   80        printer usropn
     f                                     oflind(*in01)

      /copy 'UTIL/@run.rpgleinc'

     d #elem           c                   63
     d #rcdlen         c                   4079
     d apname          s             10
     d apgtbl          ds
     d  ptbl                         11p 0 dim(#elem)
     d itblDS          ds
     d  itbl                         10i 0 dim(#elem)
     d x               s             10i 0
     d timedate        s             12  0
     d libfldfil       s             33
     d inError         s             10i 0
     d lastseq         s             10i 0
     d writeOut        s             80
     d rem             s             10i 0
     d error           s               n

     c     *entry        plist
     c                   parm                    fldcod
     c                   parm                    fldlib

     c     fldkey        klist
     c                   kfld                    fldcod
     c                   kfld                    fldlib

     c     apfkey        klist
     c                   kfld                    apfrep
     c                   kfld                    apfseq

     c     fldkey        chain     mflddir
     c                   if        %found and apfnam <> ' '
     c                   exsr      process
     c                   endif

     c                   eval      *inlr = '1'

      **************************************************************************
     c     process       begsr

     c                   callp     run('ovrprtf qsysprt splfname(chkafile)' +
     c                             ' usrdta(' + %trimr(apfnam) + ')' +
     c                             ' pagesize(*n 80)')
     c                   open      qsysprt
     c                   eval      libfldfil = %trimr(fldlib) + '/' +
     c                             %trimr(fldcod) + ', ' + apfnam
     c                   time                    timedate
     c                   except    header

     c                   eval      apname = apfnam
     c                   eval      %subst(apname:2:1) = 'P'
     c                   callp     run('ovrdbf rapfdbfp ' + apname)
     c                   callp     run('ovrdbf rapfdbf ' + apfnam)
     c                   open      rapfdbfp
     c                   open      rapfdbf

     c     pgtblkey      klist
     c                   kfld                    apgrep
     c                   kfld                    apgseq

      * get the last page table record for the index.
     c                   read      rapfdbfp
     c                   dow       not %eof(rapfdbfp)
     c                   eval      apgseq = *hival
     c     pgtblkey      setgt     rapfdbfp
     c                   readp     rapfdbfp
     c                   eval      error = '0'

     c                   if        apgtyp <> ' '
     c                   eval      itblDS = apgtbl
     c                   do        #elem         x
     c                   eval      ptbl(x) = itbl(x)
     c                   enddo
     c                   endif

      * chain to last known offset. if not found print error.
     c                   do        #elem         x
     c                   if        x > 1 and ptbl(x) = 0
     c                   eval      x = x - 1
     c                   leave
     c                   endif
     c                   enddo
     c     ptbl(x)       div       #rcdlen       apfseq
     c                   mvr                     rem
     c                   if        rem > 0
     c                   eval      apfseq = apfseq + 1
     c                   endif
     c                   eval      apfrep = apgrep
     c     apfkey        setll     rapfdbf
     c                   if        not %equal
     c                   eval      writeOut = 'Sequence ' +
     c                             %triml(%editc(apfseq:'Z')) +
     c                             ' not found for ' + apfrep
     c                   eval      error = '1'
     c                   endif

      * read through data file. Check for missing sequence records.
     c                   if        not error
     c                   eval      lastseq = -1
     c     apgrep        setll     rapfdbf
     c     apgrep        reade     rapfdbf
     c                   if        (apgtyp = ' ' and apfseq <> 0) or
     c                             (apgtyp <> ' ' and apfseq <> 1)
     c                   eval      writeOut = 'First record missing for ' +
     c                             'index ' + apgrep
     c                   eval      error = '1'
     c                   endif
     c                   if        not error
     c                   dow       not %eof(rapfdbf)
     c                   if        lastseq <> -1 and apfseq <> lastseq + 1
     c                   eval      writeOut = 'Missing sequence ' +
     c                             %trim(%editc(lastseq+1:'Z')) +
     c                             ' for index ' + apgrep
     c                   eval      error = '1'
     c                   leave
     c                   endif
     c                   eval      lastseq = apfseq
     c     apgrep        reade     rapfdbf
     c                   enddo
     c                   endif
     c                   endif

     c                   if        error
     c                   exsr      printMessage
     c                   eval      inError = inError + 1
     c                   endif

     c                   read      rapfdbfp
     c                   enddo

     c                   eval      writeOut = 'Total in Error: ' +
     c                             %triml(%editc(inError:'Z'))
     c                   except    trailer

     c                   callp     run('dltovr *all')

     c                   endsr

      **************************************************************************
     c     printMessage  begsr

     c                   except    detail
     c                   except    blankline
     c                   if        *in01
     c                   time                    timedate
     c                   except    header
     c                   eval      *in01 = '0'
     c                   endif

     c                   endsr

     oqsysprt   e            header         1
     o                       timedate               '0 :  :  &  /  /  '
     o
     o                                           49 'APF File Checking'
     o                                           75 'Page'
     o                       page          z     80
     o          e            header      1  2
     o                       libfldfil           57
     o          e            header      0  0
     o                                              'Errors'
     o          e            header         1
     o                                              '__________________________'
     o          e            detail         1
     o                       writeOut
     o          e            blankLine      1
     o                                              ' '
     o          e            trailer     1
     o                       writeOut

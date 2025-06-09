      *%METADATA                                                       *
      * %TEXT Simulate User License Tracking                           *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('MYBNDDIR')

      /copy 'UTIL/@run.rpgleinc'

     d cmd             s             80    dim(5) ctdata
     d x               s                   like(maxjobs)
     d sq              s              1    inz('''')

     c     *entry        plist
     c                   parm                    prodnum           3 0
     c                   parm                    maxjobs           6 0
     c                   parm                    jobq             10
     c                   parm                    jobqlib          10
     c                   parm                    modulo            3 0

      * Create data area used to end all submitted job.
     c                   callp(e)  run(cmd(1))
     c                   callp(e)  run(cmd(5))

     c                   do        maxjobs       x
     c                   callp     run(%trimr(cmd(2)) +sq+ %editc(prodnum:'X') +
     c                             sq + ' ' + sq + %editc(modulo:'X') + sq +
     c                             %trimr(cmd(3)) + %editc(prodnum:'X') +
     c                             %trimr(cmd(4)) +
     c                              %trimr(jobqlib) + '/' + %trimr(jobq) + ')')
     c                   enddo

     c                   eval      *inlr = '1'
**ctdata cmd
crtdtaara dtaara(qgpl/simultdta) type(*char) len(10)
sbmjob cmd(call simult2 parm(
)) job(su_
) jobq(
chgdtaara dtaara(qgpl/simultdta (1 4)) value(' ')

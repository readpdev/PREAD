      *%METADATA                                                       *
      * %TEXT Verify Format Level to All Programs in DocView           *
      *%EMETADATA                                                      *
     fqadsppgm  if   e             disk    usropn
     fqsysprt   o    f  132        printer

      /copy qsysinc/qrpglesrc,qdbrtvfd

     d run             pr                  extpgm(QCMDEXC)
     d  cmd                         512    const
     d  cmdlen                       15p 5 const

     d cmdA            s             80    dim(2)

     c     *entry        plist
     c                   parm                    library

     c                   callp     run(%trimr(cmdA(1)) + '/' + %trimr(library) +
     c                             cmdA(2):150)
     c                   callp     run('ovrdbf qadsppgm qtemp/vfyfmtlvl':31)
     c                   open      qadsppgm

     c                   read      qadsppgm
     c                   dow       not %eof
     c
     c                   read      qadsppgm
     c                   enddo

     c                   eval      *inlr = '1'
     c                   return
     oqsysprt   e
**ctdata cmdA
dsppgmref pgm(
/*all) output(*outfile) OBJTYPE(*ALL) OUTFILE(QTEMP/VFYFMTLVL)

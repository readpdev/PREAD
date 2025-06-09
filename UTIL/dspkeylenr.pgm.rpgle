      *%METADATA                                                       *
      * %TEXT Display file key length                                  *
      *%EMETADATA                                                      *
     d receiver        ds
     d  bytesRtn                     10i 0
     d  bytesAvl                     10i 0
     d  maxkeylen                     5i 0
     d  keycount                      5i 0
     d  reserved                     10
     d  fmtcounts                     5i 0
     d rcvLen          s             10i 0 inz(%size(receiver))

     d qualName        s             20
     d error           ds
     d  err_prov                     10i 0 inz(%size(error))
     d  err_avail                    10i 0 inz
     d  err_msgid                     7
     d  err_msg                      80

     d msgdta          s             52

     c     *entry        plist
     c                   parm                    file             10
     c                   parm                    library          10

     c                   eval      qualName = file + library
     c                   reset                   error
     c                   call      'QDBRTVFD'
     c                   parm                    receiver
     c                   parm                    rcvLen
     c                   parm                    qualNameRtn      20
     c                   parm      'FILD0300'    format            8
     c                   parm                    qualName
     c                   parm      '*FIRST'      rcdFmt           10
     c                   parm      '0'           ovrride           1
     c                   parm      '*LCL'        system           10
     c                   parm      '*INT'        fmttype          10
     c                   parm                    error

     c                   if        err_avail = 0
     c                   eval      msgdta = 'Key length for ' + %trimr(file) +
     c                             ' is '+%triml(%editc(maxkeyLen:'Z'))+' bytes'
     c     msgdta        dsply
     c                   endif

     c                   eval      *inlr = '1'

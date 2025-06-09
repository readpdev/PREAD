      *%METADATA                                                       *
      * %TEXT My test trigger program                                  *
      *%EMETADATA                                                      *
     h

      /copy qsysinc/qrpglesrc,trgbuf

     d qdbtblen        s             10i 0

     c     *entry        plist
     c                   parm                    qdbtb
     c                   parm                    qdbtblen

      /free
       *inlr = *on;
       return;
      /end-free

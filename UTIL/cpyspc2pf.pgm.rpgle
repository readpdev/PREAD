      *%METADATA                                                       *
      * %TEXT Copy User Space to Physical File                         *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('MYBNDDIR')

     Fcpy2spc   o    e             disk    rename(cpy2spc:spcfmt) prefix(x_)
      /copy @spyspcio
      /copy 'UTIL/@run.rpgleinc'

     c     *entry        plist
     c                   parm                    space            10
     c                   parm                    lib              10

     c                   callp     run('dltf cpyspcpf')
     c                   callp     run('crtpf pread/cpyspcpf rcdlen(32766)')
     c                   callp     rtvUsrSpc(space:lib:1:9999:x_cpy2spc)
     c                   write     spcfmt
     c                   eval      *inlr = '1'

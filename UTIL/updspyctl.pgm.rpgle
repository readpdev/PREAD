     fspyctl    uf a e           k disk
     fmlaudctl1 if   e           k disk
     fmlaudcdt1 if   e           k disk

     d lastopcode      s                   like(acopcode) inz(*all'9')

     c                   eval      cname = '*AUDCTL'
     c                   read      mlaudctl1
     c                   dow       not %eof(mlaudctl1)
     c                   eval      ctype = 'RC'
     c                   eval      ckey = *all'0'
     c                   eval      ctext = ' '
     c                   movel     acopcode      ckey
     c                   eval      cmsgid = 'ALO' + %subst(%editc(acopcode:'X')
     c                             :2)
     c                   write     spyctlf
     c     acopcode      setll     mlaudcdt1
     c     acopcode      reade     mlaudcdt1
     c                   dow       not %eof(mlaudcdt1)
     c                   eval      ctype = 'RC'
     c                   move      atdtltyp      ckey
     c                   eval      cmsgid = 'ALD'+%subst(%editc(atdtltyp:'X'):2)
     c                   eval      ctext = atloglvl
     c                   write     spyctlf
     c     acopcode      reade     mlaudcdt1
     c                   enddo
     c                   read      mlaudctl1
     c                   enddo

     c                   eval      *inlr = '1'

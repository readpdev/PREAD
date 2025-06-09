      *%METADATA                                                       *
      * %TEXT fopen, fread, fwrite, fclose examples                    *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR':'QC2LE')

      /copy @ifsio

     d fopen           pr              *   extproc('fopen')
     d  path                           *   value
     d  mode                           *   value

     d fread           pr            10i 0 extproc('fread')
     d  buffer                         *   value
     d  bufsiz                       10i 0 value
     d  bufcnt                       10i 0 value
     d  fh                             *   value

     d fclose          pr            10i 0 extproc('fclose')
     d  fh                             *   value

     d fh              s               *
     d path            s            256    inz('XZ000001')
     d mode            s              5    inz('rb')
     d buffer          s           1024
     d rc              s             10i 0

     c                   eval      path = %trimr(path) + x'00'
     c                   eval      mode = %trimr(mode) + x'00'
     c                   eval      fh = fopen(%addr(path):%addr(mode))
     c                   if        fh <> *null
     c                   eval      rc = fread(%addr(buffer):1024:1:fh)
     c                   dow       rc > 0
     c                   eval      buffer = ' '
     c                   eval      rc = fread(%addr(buffer):1024:1:fh)
     c                   enddo
     c                   endif

     c                   eval      rc = fclose(fh)

     c                   eval      *inlr = '1'


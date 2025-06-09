     d dumpDbg         PR                  extproc('dumpDbg')
     d  file                           *   value
     d  buf                            *   value
     d  buflen                       10i 0 value
     d  source                         *   value options(*nopass)

     d bp              s               *
     d abuffer         s            200    inz('this is a test')
     d fname           s             22    inz('PREAD/FOO')

     c                   eval      fname = %trimr(fname) + x'00'
     c                   callp     dumpDbg(%addr(fname):%addr(abuffer):
     c                             %len(%trimr(abuffer)))

     c                   eval      *inlr = '1'

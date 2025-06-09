      *%METADATA                                                       *
      * %TEXT Dump debug RPG prototype                                 *
      *%EMETADATA                                                      *
     d dumpDbg         pr                  extproc('dumpDbg') opdesc
     d  fileName                     25    const
     d  buffer                         *   value
     d  buffLen                      10i 0 value

      /*%METADATA                                                     */
      /* %TEXT List Program/Service Program Modules                   */
      /*%EMETADATA                                                    */
             CMD        PROMPT('List Pgm/SrvPgm Modules')
             PARM       KWD(LIBRARY) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Program Library')
             PARM       KWD(PROGRAM) TYPE(*CHAR) LEN(10) DFT(*ALL) +
                          PROMPT('Program Name')
             PARM       KWD(MODSEARCH) TYPE(*CHAR) LEN(10) DFT(*ALL) +
                          PROMPT('Module Search')

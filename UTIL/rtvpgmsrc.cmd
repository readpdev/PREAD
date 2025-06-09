      /*%METADATA                                                     */
      /* %TEXT Retrieve program source                                */
      /*%EMETADATA                                                    */
             CMD        PROMPT('RETRIEVE PROGRAM SOURCE')
             PARM       KWD(QUALPGM) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Program name')
             PARM       KWD(QUALLIB) TYPE(*CHAR) LEN(10) DFT(*LIBL) +
                          PROMPT('Program library name')
             PARM       KWD(PGMTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*PGM) VALUES(*PGM *SRVPGM) +
                          PROMPT('Program type')
             PARM       KWD(SRCFILNAM) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Target source file name')
             PARM       KWD(SRCFILLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Target source file library')
             PARM       KWD(SRCFILMBR) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Target source file member')

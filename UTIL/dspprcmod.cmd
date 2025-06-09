      /*%METADATA                                                     */
      /* %TEXT Display Procedure Module                               */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Display Procedure Module')
             PARM       KWD(SRVPGM) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('PROGRAM/SRVPGM NAME')
             PARM       KWD(SRVPGMLIB) TYPE(*CHAR) LEN(10) +
                          DFT(*LIBL) PROMPT('LIBRARY')
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*PGM) VALUES(*PGM *SRVPGM) PROMPT('PROGRAM TYPE')

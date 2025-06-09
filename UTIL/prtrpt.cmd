      /*%METADATA                                                     */
      /* %TEXT Print report page range w/o links                      */
      /*%EMETADATA                                                    */
CMD
             PARM       KWD(REPIND) TYPE(*CHAR) LEN(10) +
                          PROMPT('REPORT NUMBER (SPY)')
             PARM       KWD(FRPAGE) TYPE(*DEC) LEN(7) PROMPT('FROM +
                          PAGE')
             PARM       KWD(TOPAGE) TYPE(*DEC) LEN(7) PROMPT('TO PAGE')
             PARM       KWD(INDIVIDUAL) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES('Y' 'N') PROMPT('PRINT +
                          SPLFS FOR EACH PAGE')
             PARM       KWD(SUBMIT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES('Y' 'N') PROMPT('SUMBIT')

      /*%METADATA                                                     */
      /* %TEXT Compare message files                                  */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Compare Message Files')
             PARM       KWD(MSGF1) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('New Message File Name')
             PARM       KWD(MSGFLIB1) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('New Message File Library')
             PARM       KWD(MSGF2) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Old Message File Name')
             PARM       KWD(MSGFLIB2) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Old Message File Library')
             PARM       KWD(CMPIDONLY) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Compare ID Only')

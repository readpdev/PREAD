      /*%METADATA                                                     */
      /* %TEXT Rebuild Distribution                                   */
      /*%EMETADATA                                                    */
/* CALLS RBLDDSTR */

             CMD        PROMPT('REBUILD DISTRIBUTION')
             PARM       KWD(REPORTTYPE) TYPE(*CHAR) LEN(10) +
                          DFT(*ALL) CHOICE('*ALL, Report Type') +
                          PROMPT('Report Type')
             PARM       KWD(REPORTONLY) TYPE(*CHAR) LEN(1) +
                          RSTD(*YES) DFT(Y) VALUES(Y N) +
                          PROMPT('Report Only')

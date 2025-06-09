      /*%METADATA                                                     */
      /* %TEXT Change the create link date for report type            */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Change Link Date')
             PARM       KWD(RPTNAM) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Report Name')
             PARM       KWD(DECRMNTBY) TYPE(*CHAR) LEN(10) +
                          RSTD(*YES) DFT(*DAY) VALUES('*DAY' +
                          '*MONTH') PROMPT('Decrement by')
             PARM       KWD(DECRMNTVAL) TYPE(*INT2) DFT(1) REL(*GE +
                          1) PROMPT('Decrement Value')

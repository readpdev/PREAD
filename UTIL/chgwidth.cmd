      /*%METADATA                                                     */
      /* %TEXT Change Report Width in MRPTATR                         */
      /*%EMETADATA                                                    */
/* PROCESSING PROGRAM CHGWIDTHR */
             CMD        PROMPT('CHANGE REPORT WIDTH')
             PARM       KWD(RPTID) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Report ID')
             PARM       KWD(WIDTH) TYPE(*INT4) MIN(1) PROMPT('New +
                          report width')

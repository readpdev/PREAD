      /*%METADATA                                                     */
      /* %TEXT Message data validation                                */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Message Validation')
             PARM       KWD(MSGF) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Message File')
             PARM       KWD(MSGFLIB) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Message File Library')

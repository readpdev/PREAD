      /*%METADATA                                                     */
      /* %TEXT Test for long message truncation in display files      */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Retrieve Long Msgs')
             PARM       KWD(MSGF) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Message File')
             PARM       KWD(MSGFLIB) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Message File Library')
             PARM       KWD(SRCF) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Source File')
             PARM       KWD(SRCFLIB) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Source File Library')
             PARM       KWD(PATH) TYPE(*PNAME) LEN(256) MIN(1) PROMPT('Path')

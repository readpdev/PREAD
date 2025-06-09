      /*%METADATA                                                     */
      /* %TEXT Import Message File                                    */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Import Message File from IFS')
             PARM       KWD(MSGF) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Message File')
             PARM       KWD(MSGFLIB) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Message File Library')
             PARM       KWD(FROMCCSID) TYPE(*INT4) PROMPT('From CCSID')
             PARM       KWD(TOCCSID) TYPE(*INT4) DFT(65535) PROMPT('To CCSID')
             PARM       KWD(SRCF) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Source File for Long Msg Test')
             PARM       KWD(SRCFLIB) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Source File Library')
             PARM       KWD(PATH) TYPE(*PNAME) LEN(256) MIN(1) PROMPT('Path')
             PARM       KWD(OPERATION) TYPE(*INT4) CONSTANT(0)

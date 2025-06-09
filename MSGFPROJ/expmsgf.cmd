      /*%METADATA                                                     */
      /* %TEXT Export Message File                                    */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Export message file to IFS')
             PARM       KWD(OPERATION) TYPE(*INT4) CONSTANT(1)
             PARM       KWD(MSGF) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Message File')
             PARM       KWD(MSGFLIB) TYPE(*CHAR) LEN(10) MIN(1) PROMPT('Message File Library')
             PARM       KWD(FROMCCSID) TYPE(*INT4) DFT(37) PROMPT('From CCSID')
             PARM       KWD(TOCCSID) TYPE(*INT4) DFT(819) PROMPT('To CCSID')
             PARM       KWD(PATH) TYPE(*PNAME) LEN(256) MIN(1) PROMPT('Path')

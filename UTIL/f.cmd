      /*%METADATA                                                     */
      /* %TEXT Find Source Member (FINDMBR)                           */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Find Source Member')

             PARM       KWD(MEMBER) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Source Member')
             PARM       KWD(LIBRARY) TYPE(*CHAR) LEN(10) +
                          PROMPT('Library (optional)')
             PARM       KWD(OPCODE) TYPE(*CHAR) CONSTANT('F')


      /*%METADATA                                                     */
      /* %TEXT Display program references                             */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Display Program References')
             PARM       KWD(OBJECT) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Object')
             PARM       KWD(LIBRARY) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Program Library')

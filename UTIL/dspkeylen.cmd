      /*%METADATA                                                     */
      /* %TEXT Display key fields length                              */
      /*%EMETADATA                                                    */
             CMD
             PARM       KWD(FILE) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('File Name')
             PARM       KWD(LIBRARY) TYPE(*CHAR) LEN(10) DFT(*LIBL) +
                          PROMPT('Library Name')

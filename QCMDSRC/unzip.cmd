      /*%METADATA                                                     */
      /* %TEXT Unzip Utility                                          */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Unzip File')

             PARM       KWD(ARCHIVE) TYPE(*PNAME) LEN(5000) MIN(1) +
                          EXPR(*YES) VARY(*YES *INT2) CASE(*MIXED) +
                          CHOICE(*NONE) INLPMTLEN(80) PROMPT('Compressed +
                          file name')

             PARM       KWD(DIR) TYPE(*PNAME) LEN(5000) MIN(1) EXPR(*YES) +
                          VARY(*YES *INT2) CASE(*MIXED) CHOICE(*NONE) +
                          INLPMTLEN(80) PROMPT('Directory to place files')

             PARM       KWD(VERBOSE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*NONE) SPCVAL((*NONE) (*VERBOSE)) EXPR(*YES) +
                          PROMPT('Verbose option')

             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*NO) SPCVAL((*YES) (*NO)) EXPR(*YES) +
                          PROMPT('Replace')

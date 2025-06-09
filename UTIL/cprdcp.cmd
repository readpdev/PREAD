      /*%METADATA                                                     */
      /* %TEXT Compress/Decompress File                               */
      /*%EMETADATA                                                    */
             CMD
             PARM       KWD(OPERATION) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          SPCVAL((*CPR 1) (*DCP 2) (*CPRSPLF 3) +
                          (*DCPSPLF 4)) MIN(1) +
                          PROMPT('Compress/Decompress')
             PARM       KWD(TGTFILE) TYPE(*CHAR) LEN(10) +
                          PROMPT('Target File')
             PARM       KWD(TGTLIB) TYPE(*CHAR) LEN(10) +
                          PROMPT('Target Library')
             PARM       KWD(SRCFILE) TYPE(*CHAR) LEN(10) +
                          PROMPT('Source File')
             PARM       KWD(SRCLIB) TYPE(*CHAR) LEN(10) +
                          PROMPT('Source Library')

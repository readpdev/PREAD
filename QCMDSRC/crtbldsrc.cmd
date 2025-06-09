      /*%METADATA                                                     */
      /* %TEXT Create Build Source for Escrow                         */
      /*%EMETADATA                                                    */
             CMD

             PARM       KWD(SRCLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Source Library')
             PARM       KWD(PGMLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Program Library')
             PARM       KWD(DTALIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Data Library')
             PARM       KWD(TGTLIB) TYPE(*CHAR) LEN(10) +
                          DFT(DOCBLDSRC) PROMPT('Target Library')
             PARM       KWD(TGTRLS) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Target OS Release')
             PARM       KWD(IFSRLSDIR) TYPE(*CHAR) LEN(15) MIN(1) +
                          PROMPT('IFS Release Directory')


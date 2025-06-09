      /*%METADATA                                                     */
      /* %TEXT Create Cumulative for DMS                              */
      /*%EMETADATA                                                    */
             CMD

             PARM       KWD(PTFLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('DOC902OBJ, DOC921OBJ, etc.') +
                          PROMPT('Source Object Library Name')

             PARM       KWD(VERSION) TYPE(*DEC) LEN(4) MIN(1) +
                          CHOICE('MMmp Maj/Min/PTF') PROMPT('Target +
                          DMS Version')

             PARM       KWD(TGTRLS) TYPE(*CHAR) LEN(6) MIN(1) +
                          CHOICE('V5R4M0, V6R1M0, V7R1M0, etc.') +
                          PROMPT('Target OS Version')

             PARM       KWD(BUILDNBR) TYPE(*DEC) LEN(4) DFT(*NEXT) +
                          RANGE(-1 9999) SPCVAL((*NEXT -1)) +
                          CHOICE('*NEXT, 1 - 9999') PROMPT('Build +
                          Number')


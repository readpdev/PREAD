      /*%METADATA                                                     */
      /* %TEXT Get TIF Page Count Based on Index Values               */
      /*%EMETADATA                                                    */
/* COMPILE OPTIONS:  ALLOW(*IPGM *BPGM) */
/*                   PGM(TIFPGCNTR)     */
             CMD        PROMPT('TIF PAGE COUNT')
             PARM       KWD(DOCCLASS) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Document Class')
             PARM       KWD(INDEXVAL1) TYPE(*CHAR) LEN(70) +
                          PROMPT('Index Value 1')
             PARM       KWD(INDEXVAL2) TYPE(*CHAR) LEN(70) +
                          PROMPT('Index Value 2')
             PARM       KWD(INDEXVAL3) TYPE(*CHAR) LEN(70) +
                          PROMPT('Index Value 3')
             PARM       KWD(INDEXVAL4) TYPE(*CHAR) LEN(70) +
                          PROMPT('Index Value 4')
             PARM       KWD(INDEXVAL5) TYPE(*CHAR) LEN(70) +
                          PROMPT('Index Value 5')
             PARM       KWD(INDEXVAL6) TYPE(*CHAR) LEN(70) +
                          PROMPT('Index Value 6')
             PARM       KWD(INDEXVAL7) TYPE(*CHAR) LEN(70) +
                          PROMPT('Index Value 7')
             PARM       KWD(#PAGES) TYPE(*DEC) LEN(9) RTNVAL(*YES) +
                          PROMPT('Return Page Count')

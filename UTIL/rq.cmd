      /*%METADATA                                                     */
      /* %TEXT Runqry *n rcdslt(*Yes)                                 */
      /*%EMETADATA                                                    */
             CMD        PROMPT('RUNQRY *N file RCDSLT(*YES)')
             PARM       KWD(FILENAME) TYPE(FILENAME) MIN(1) +
                          PROMPT(FILE)
             PARM       KWD(MEMBER) TYPE(*CHAR) LEN(10) DFT(*FIRST) +
                          PROMPT(MEMBER)
 FILENAME:   QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT(LIBRARY)

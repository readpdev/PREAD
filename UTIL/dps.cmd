      /*%METADATA                                                     */
      /* %TEXT Display object source                                  */
      /*%EMETADATA                                                    */
             CMD        PROMPT('DISPLAY OBJECT SOURCE')
             PARM       KWD(DTAARA) TYPE(QUAL) MIN(1) DTAARA(*YES) +
                          PROMPT(PROGRAM)

 QUAL:       QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')

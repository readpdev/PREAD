      /*%METADATA                                                     */
      /* %TEXT Utility - Delete docs based on SPYPVPF                 */
      /*%EMETADATA                                                    */
             CMD

             PARM       KWD(FOLDER) TYPE(*CHAR) LEN(10) DFT(*ALL) +
                          CHOICE('*ALL, Name') PROMPT(CMD1007)
             PARM       KWD(DOCTYPE) TYPE(*CHAR) LEN(10) DFT(*ALL) +
                          CHOICE('*ALL, Name') PROMPT(CMD0304)
             PARM       KWD(FRDATE) TYPE(*CHAR) LEN(8)  +
                          CHOICE(YYYYMMDD) PROMPT(CMD1734)
             PARM       KWD(TODATE) TYPE(*CHAR) LEN(8)  +
                          CHOICE(YYYYMMDD) PROMPT(CMD1735)
             PARM       KWD(JOBD) TYPE(QUALOBJ) DFT(*USRPRF) +
                          SNGVAL(*USRPRF) PROMPT(CMD1147)
 QUALOBJ:    QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT(CMD1013)

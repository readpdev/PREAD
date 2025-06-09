      /*%METADATA                                                     */
      /* %TEXT Export Link Values to IFS                              */
      /*%EMETADATA                                                    */
             CMD
             PARM       KWD(DOCCLASS) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Document Class Name')
             PARM       KWD(NDXVAL1) TYPE(*CHAR) LEN(25) +
                          PROMPT('Index Value 1')
             PARM       KWD(NDXVAL2) TYPE(*CHAR) LEN(25) +
                          PROMPT('Index Value 2')
             PARM       KWD(NDXVAL3) TYPE(*CHAR) LEN(25) +
                          PROMPT('Index Value 3')
             PARM       KWD(NDXVAL4) TYPE(*CHAR) LEN(25) +
                          PROMPT('Index Value 4')
             PARM       KWD(NDXVAL5) TYPE(*CHAR) LEN(25) +
                          PROMPT('Index Value 5')
             PARM       KWD(NDXVAL6) TYPE(*CHAR) LEN(25) +
                          PROMPT('Index Value 6')
             PARM       KWD(NDXVAL7) TYPE(*CHAR) LEN(25) +
                          PROMPT('Index Value 7')
             PARM       KWD(FRDATE) TYPE(*CHAR) LEN(8) DFT(00000000) +
                          CHOICE(YYYYMMDD) PROMPT('From Date')
             PARM       KWD(TODATE) TYPE(*CHAR) LEN(8) DFT(00000000) +
                          CHOICE(YYYYMMDD) PROMPT('To Date')
             PARM       KWD(CODEPAGE) TYPE(*INT2) DFT(437) +
                          PROMPT(CODEPAGE)
             PARM       KWD(IFSTGT) TYPE(*CHAR) LEN(256) MIN(1) +
                          PROMPT('IFS Path and File')

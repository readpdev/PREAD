      /*%METADATA                                                     */
      /* %TEXT Get Patch via FTP                                      */
      /*%EMETADATA                                                    */
CMD

             PARM       KWD(USERID) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('User ID')

             PARM       KWD(PASSWORD) TYPE(*CHAR) LEN(10) MIN(1) +
                          CASE(*MIXED) DSPINPUT(*NO) PROMPT('Password')

             PARM       KWD(PATCHVER) TYPE(*CHAR) LEN(4) MIN(1) +
                          FULL(*YES) CHOICE('0911, 0921,...') +
                          PROMPT('Patch Version')

             PARM       KWD(PATCHNBR) TYPE(*CHAR) LEN(4) +
                          DFT(*CURRENT) SPCVAL((*CURRENT -1)) +
                          MIN(0) FULL(*YES) CHOICE('0001, 0002, +
                          ...') PROMPT('Patch Number')

             PARM       KWD(TGTPGMLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Target Program Library')

             PARM       KWD(FTPSERVER) TYPE(*CHAR) LEN(40) +
                          DFT('aus-rombufs.opentext.net') +
                          CHOICE('Name or IP Address') +
                          PROMPT('Patch Server' 1)

             PARM       KWD(DOMAIN) TYPE(*CHAR) LEN(20) +
                          DFT(OPENTEXT) PROMPT('Domain' 2)


      /*%METADATA                                                     */
      /* %TEXT Send Saved Object to another system                    */
      /*%EMETADATA                                                    */
             CMD

             PARM       KWD(SERVER) TYPE(*CHAR) LEN(10) +
                          PROMPT('Server Name')
             PARM       KWD(PASSWORD) TYPE(*CHAR) LEN(20) +
                          CASE(*MIXED) DSPINPUT(*NO) PROMPT('Password')
             PARM       KWD(USER) TYPE(*CHAR) LEN(10) DFT(*CURRENT) +
                          PROMPT('User Name')
             PARM       KWD(OBJECT) TYPE(*CHAR) LEN(10) +
                          PROMPT('Object Name')
             PARM       KWD(OBJECTLIB) TYPE(*CHAR) LEN(10) +
                          PROMPT('Object Library')
             PARM       KWD(OBJECTTYPE) TYPE(*CHAR) LEN(10) +
                          PROMPT('Object Type')


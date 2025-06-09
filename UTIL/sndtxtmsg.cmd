      /*%METADATA                                                     */
      /* %TEXT Send Text Message                                      */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Send Text Message via SMTP')

             PARM       KWD(CELLNBR) TYPE(*DEC) LEN(10) MIN(1) +
                          CHOICE('3334445555, etc.') +
                          PROMPT('Cellular Number')
             PARM       KWD(CARRIER) TYPE(*CHAR) LEN(15) MIN(1) +
                          CHOICE(*PGM) CHOICEPGM(*LIBL/SNDTXTCHC) +
                          PROMPT('Carrier: ATT,SPRINT,F4=Prompt')
             PARM       KWD(SUBJECT) TYPE(*CHAR) LEN(20) MIN(1) +
                          PROMPT(SUBJECT)
             PARM       KWD(NOTE) TYPE(*CHAR) LEN(100) MIN(1) +
                          PROMPT(NOTE)

      /*%METADATA                                                     */
      /* %TEXT Start debug                                            */
      /*%EMETADATA                                                    */
             CMD
             PARM       KWD(PROGRAM) TYPE(Q1) MIN(1) +
                          PROMPT('Program')
             PARM       KWD(JOB) TYPE(Q2) PROMPT('Job')
 Q1:         QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
 Q2:         QUAL       TYPE(*NAME) LEN(10) DFT(*CURRENT) +
                          SPCVAL((*CURRENT))
             QUAL       TYPE(*NAME) LEN(10) PROMPT('User Name')
             QUAL       TYPE(*CHAR) LEN(6) PROMPT('Job Number')

      /*%METADATA                                                     */
      /* %TEXT Print spool file attributes.                           */
      /*%EMETADATA                                                    */
             CMD
             PARM       KWD(SPLFNAME) TYPE(*CHAR) MIN(1) +
                          PROMPT('SPOOL FILE NAME')
             PARM       KWD(SPOOLNBR) TYPE(*INT4) MIN(1) +
                          PROMPT('SPOOL NUMBER')
             PARM       KWD(JOB) TYPE(Q2) PROMPT('Job')
 Q2:         QUAL       TYPE(*NAME) LEN(10) DFT(*CURRENT) +
                          SPCVAL((*CURRENT))
             QUAL       TYPE(*NAME) LEN(10) PROMPT('User Name')
             QUAL       TYPE(*CHAR) LEN(6) PROMPT('Job Number')

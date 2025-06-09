      /*%METADATA                                                     */
      /* %TEXT Display Object References                              */
      /*%EMETADATA                                                    */
/* Program: DSPOBJREFR */
             CMD        PROMPT('Display Object References')
             PARM       KWD(OBJECT) TYPE(*CHAR) LEN(10) PROMPT('Object')
             PARM       KWD(OBJLIB) TYPE(*CHAR) LEN(10) PROMPT('Object Library')
             PARM       KWD(OBJTYP) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES(*DTAARA *FILE *MODULE *PGM +
                          *SRVPGM) PROMPT('Object Type')
             PARM       KWD(REFLIB) TYPE(*CHAR) LEN(10) PROMPT('Reference Librar

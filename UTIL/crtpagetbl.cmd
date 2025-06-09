      /*%METADATA                                                     */
      /* %TEXT Create a new page table                                */
      /*%EMETADATA                                                    */
/*      CRTOPT PGM(CRTPAGETBL)                                       */
/*      CRTOPT PMTFILE(PSCON)                                        */
/*      CRTOPT MSGF(PSCON)                                           */
/*                                                                   */
/* 05-31-02 PLR ADD CREATE OPTIONS. /6679                            */
/*                                                                   */
             CMD        PROMPT(CMD1081)

             PARM       KWD(FLDR) TYPE(FLDR) MIN(1) PROMPT(CMD1082)
             PARM       KWD(SBMJOB) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(N Y) PROMPT(CMD1010)
             PARM       KWD(JOBD) TYPE(FLDR) DFT(*USRPRF) +
                          SNGVAL(('*USRPRF')) PROMPT(CMD1011)

 FLDR:       QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT(CMD1013)

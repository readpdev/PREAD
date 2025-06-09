      /*%METADATA                                                     */
      /* %TEXT Copy AFP Resource                                      */
      /*%EMETADATA                                                    */
/*      CRTOPT PGM(CPYAFPRSC)                                        */
/*      CRTOPT PMTFILE(PSCON)                                        */
/*      CRTOPT MSGF(PSCON)                                           */
/*      CRTOPT PMTOVRPGM(CPYAFPRSP)                                  */
/************----------------------------------------------           +
 *  CPYAFPRSC  Copy AFP Resource                                      +
 *             CPP is CPYAFPRSC                                       +
 ************----------------------------------------------           +
                                                                      +
 GT   9-04-03 Created                                           /8585 +
                                                                     */
             CMD        PROMPT(CMD1901)
             PARM       KWD(AFPRSC) TYPE(AFPRSC) MIN(1) +
                          KEYPARM(*YES) PROMPT(CMD1902)
 AFPRSC:     QUAL       TYPE(*NAME) MIN(1) EXPR(*YES)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*LIBL) +
                          (*CURLIB *CURLIB)) EXPR(*YES) PROMPT(CMD1903)
             PARM       KWD(RSCTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          SPCVAL((*FNTRSC) (*FORMDF) (*OVL) +
                          (*PAGDFN) (*PAGSEG)) MIN(1) EXPR(*YES) +
                          KEYPARM(*YES) PROMPT(CMD1904)
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(*FILE) SPCVAL((*FILE 'F') (*STMF +
                          'S')) EXPR(*YES) KEYPARM(*YES) +
                          PROMPT(CMD1905)
             PARM       KWD(TOFILE) TYPE(TOFILE) FILE(*OUT) +
                          PMTCTL(FILE) PROMPT(CMD1906)
 TOFILE:     QUAL       TYPE(*NAME) MIN(1) EXPR(*YES)
             QUAL       TYPE(*NAME) DFT(*LIBL) SPCVAL((*LIBL) +
                          (*CURLIB *CURLIB)) EXPR(*YES) PROMPT(CMD1903)
             PARM       KWD(TOMBR) TYPE(*NAME) DFT(*AFPRSC) +
                          SPCVAL((*AFPRSC) (*FIRST)) EXPR(*YES) +
                          PMTCTL(FILE) PROMPT(CMD1907)
             PARM       KWD(MBROPT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(*NONE) SPCVAL((*NONE 'N') (*REPLACE +
                          'R')) EXPR(*YES) PMTCTL(FILE) PROMPT(CMD1908)
             PARM       KWD(TOSTMF) TYPE(*PNAME) LEN(5000) +
                          DFT(*AFPRSC) SPCVAL((*AFPRSC)) EXPR(*YES) +
                          PMTCTL(STMF) PROMPT(CMD1909)
             PARM       KWD(STMFOPT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(*NONE) SPCVAL((*NONE 'N') (*REPLACE +
                          'R')) EXPR(*YES) PMTCTL(STMF) PROMPT(CMD1910)

 FILE:       PMTCTL     CTL(OUTPUT) COND((*EQ 'F'))
 STMF:       PMTCTL     CTL(OUTPUT) COND((*EQ 'S'))

             DEP        CTL(&OUTPUT *EQ 'F') PARM((TOFILE)) +
                          MSGID(CMD1921)
             DEP        CTL(&OUTPUT *EQ 'F') PARM((TOSTMF) +
                          (STMFOPT)) NBRTRUE(*EQ 0) MSGID(CMD1922)

             DEP        CTL(&OUTPUT *EQ 'S') PARM((&TOSTMF *NE ' ')) +
                          MSGID(CMD1923)
             DEP        CTL(&OUTPUT *EQ 'S') PARM((TOFILE) (TOMBR) +
                          (MBROPT)) NBRTRUE(*EQ 0) MSGID(CMD1924)

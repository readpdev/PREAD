      /*%METADATA                                                     */
      /* %TEXT New PUT spool file command                             */
      /*%EMETADATA                                                    */
/*      CRTOPT PGM(MAPUTSPF)                                         */
/*      CRTOPT PMTFILE(PSCON)                                        */
/*      CRTOPT MSGF(PSCON)                                           */
/*  CPP is MAPUTSPF                                                  */
/*********************************************************************/
/*                                                                   */
/* 10-04-02 JMO Written as replacement for "old" PUTSPLF command     */
/*                                                                   */
/*********************************************************************/

             CMD        PROMPT(CMD0315)

             PARM       KWD(FILE) TYPE(DBNAME) MIN(1) PROMPT(CMD0316)

 DBNAME:     QUAL       TYPE(*NAME) LEN(10) MIN(1) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB *CURLIB)) +
                          EXPR(*YES) PROMPT(CMD0308)

             PARM       KWD(MBR) TYPE(*NAME) LEN(10) DFT(*FIRST) +
                          SPCVAL((*FIRST)) EXPR(*YES) PROMPT(CMD0317)

             PARM       KWD(OUTQ) TYPE(OUTQNAME) DFT(*JOB) +
                          SNGVAL((*JOB)) PROMPT(CMD0318)

 OUTQNAME:   QUAL       TYPE(*NAME) LEN(10) MIN(1) EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*CURLIB *CURLIB)) +
                          EXPR(*YES) PROMPT(CMD0308)

             PARM       KWD(USER) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*CURRENT) VALUES(*CURRENT *SAME) +
                          EXPR(*YES) PROMPT(CMD0310)

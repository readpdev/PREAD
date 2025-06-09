      /*%METADATA                                                     */
      /* %TEXT Generate DDL SQL Source                                */
      /*%EMETADATA                                                    */
/*******************************************************************/
/* PROGRAM NAME: GENDDLSRC                                         */
/* DESCRIPTION : GENERATE DDL SOURCE FOR TABLES/INDEXES/VIEWS      */
/* WRITTEN BY  : DAVID J. ANDRUCHUK                                */
/*                                                                 */
/* CREATE INSTRUCTIONS:                                            */
/* CRTCMD CMD(GENDDLSRC) PGM(GENDDLSRC) SRCFILE(QCMDSRC)           */
/*        VLDCHKPGM(GENDDLSRCV) HLPPNLGRP(GENDDLSRCP) HLPID(*CMD)  */
/*******************************************************************/

             CMD        PROMPT('GENERATE DDL SOURCE')

             PARM       KWD(GENSRCFILE) TYPE(QUAL1) +
                          PROMPT('GENERATED SOURCE FILE' 2)

             PARM       KWD(SCHEMA) TYPE(*NAME) MIN(1) +
                          PROMPT('SCHEMA NAME' 1)

 QUAL1:      QUAL       TYPE(*NAME) MIN(1)
             QUAL       TYPE(*NAME) MIN(1) PROMPT('SCHEMA')

      /*%METADATA                                                     */
      /* %TEXT Zip utility                                            */
      /*%EMETADATA                                                    */
            CMD        PROMPT('ZIP/UNZIP UTILITY')

             PARM       KWD(MODE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*ZIP) SPCVAL(('*ZIP') ('*UNZIP')) +
                          PROMPT('MODE')
            PARM       KWD(OBJ) TYPE(QUAL1) SNGVAL((*STMF)) MIN(1) +
                         PROMPT('OBJECT TO ADD TO ZIP FILE')
QUAL1:      QUAL       TYPE(*NAME) LEN(10) EXPR(*YES)
            QUAL       TYPE(*NAME) LEN(10) DFT(*CURLIB) +
                         SPCVAL((*CURLIB)) EXPR(*YES) +
                         PROMPT('OBJECT LIBRARY')

            PARM       KWD(OBJTYPE) TYPE(*CHAR) LEN(10) DFT(*FILE) +
                         SPCVAL((*FILE) (*SAVF *FILE) (*USRSPC)) +
                         PROMPT('OBJECT TYPE')

STMF:       PARM       KWD(STMF) TYPE(*PNAME) LEN(640) DFT(*NONE) +
                         SPCVAL((*NONE '')) MIN(0) EXPR(*YES) +
                         VARY(*YES) PMTCTL(USESTMF) PROMPT('IFS FILE')
            PARM       KWD(SUBDIR) TYPE(*CHAR) RSTD(*YES) DFT(*YES) +
                         SPCVAL((*YES *ALL) (*NO *NONE)) +
                         EXPR(*YES) PROMPT('INCLUDE SUBDIRECTORIES')

            PARM       KWD(ZIPLOC) TYPE(*PNAME) LEN(5000) DFT(*HOME) +
                         SPCVAL((*HOME)) EXPR(*YES) VARY(*YES) +
                        INLPMTLEN(32) PROMPT('ZIP FILE LOCATION')
            PARM       KWD(ZIP) TYPE(*PNAME) LEN(5000) DFT(*OBJ) +
                         SPCVAL((*OBJ) (*OBJLIB)) EXPR(*YES) +
                         VARY(*YES) INLPMTLEN(32) PROMPT('ZIP FILE +
                         NAME')
            PARM       KWD(VERBOSE) TYPE(*CHAR) RSTD(*YES) DFT(*NO) +
                         SPCVAL((*YES *VERBOSE) (*NO *NONE)) +
                         EXPR(*YES) PROMPT('VERBOSE MESSAGES')
            PARM       KWD(COMMENTS) TYPE(*CHAR) LEN(512) +
                         DFT(*NONE) SPCVAL((*NONE '')) EXPR(*YES) +
                         VARY(*YES) PROMPT('EMBEDDED COMMENTS')
USESTMF:    PMTCTL     CTL(OBJ) COND((*EQ *STMF) (*EQ *NONE)) +
                         NBRTRUE(*GE 1)

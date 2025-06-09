      /*%METADATA                                                     */
      /* %TEXT Start optical restore process                  p       */
      /*%EMETADATA                                                    */
/*                                                                            */
/* 04-02-07 PLR Allow the use of special characters in the report type.       */
/*              T6183                                                         */
/*                                                                            */
             CMD        PROMPT('Start Optical Restore process')

             PARM       KWD(DOCFOLDER) TYPE(QF) +
                          MIN(1) PROMPT('DocFolder')
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(1) DFT(*BOTH) +
                          SPCVAL((*REPORTS 'R') +
                                 (*BATCHES 'B') +
                                 (*BOTH    ' ')) +
                          EXPR(*YES) PROMPT('Type')
             PARM       KWD(DOCCLASS) TYPE(*GENERIC) LEN(10) +
                          DFT(*ALL) SPCVAL(*ALL) +
                          PMTCTL(BATCHES) +
                          PROMPT('Image/Batch Document Class')
             PARM       KWD(RPTTYPE) TYPE(*CHAR) LEN(10) +
                          DFT(*ALL) SPCVAL(*ALL) +
                          PROMPT('Report Type') /*6183*/
             PARM       KWD(DATE) TYPE(DRANGE) +
                          PROMPT('Date Range selection')
             PARM       KWD(JOBD) TYPE(QJ) SNGVAL((*NONE)) +
                          PROMPT('Job Description')
             PARM       KWD(OUTQ) TYPE(QO) DFT((*CURRENT)) +
                          SNGVAL((*CURRENT) (*JOBD)) +
                          PMTCTL(SBMJOB) +
                          PROMPT('Output Queue')

 QF:         QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1) +
                          EXPR(*YES)
             QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1) +
                          EXPR(*YES) PROMPT('Library')
 QJ:         QUAL       TYPE(*NAME) LEN(10) DFT(ORJOBD) +
                          EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) +
                          EXPR(*YES) PROMPT('Library')
 QO:         QUAL       TYPE(*NAME) LEN(10) +
                          EXPR(*YES)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) +
                          EXPR(*YES) PROMPT('Library')

 DRANGE:     ELEM       TYPE(*DEC) LEN(8) +
                          DFT(*FIRST) SPCVAL((*FIRST 0)) +
                          PROMPT('Beginning Date YYYYMMDD')
             ELEM       TYPE(*DEC) LEN(8) +
                          DFT(*LAST) SPCVAL((*LAST 99999999)) +
                          PROMPT('Ending Date YYYYMMDD')

 BATCHES:    PMTCTL     CTL(TYPE) COND((*NE 'R'))
 SBMJOB:     PMTCTL     CTL(JOBD) COND((*NE *NONE))

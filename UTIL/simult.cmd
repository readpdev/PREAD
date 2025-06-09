      /*%METADATA                                                     */
      /* %TEXT Simulate User License Tracking                         */
      /*%EMETADATA                                                    */
/* COMPILE TO EXECUTE SIMULT1 */
             CMD
             PARM       KWD(PRODNUM) TYPE(*DEC) LEN(3) RANGE(1 999) +
                          MIN(1) CHOICE('1-999') PROMPT('Product +
                          number')
             PARM       KWD(NUMJOBS) TYPE(*DEC) LEN(6) RANGE(1 +
                          999999) MIN(1) CHOICE('1-999999') +
                          PROMPT('Number of jobs')
             PARM       KWD(JOBQ) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT(JOBQ)
             PARM       KWD(JOBQLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Jobq library')
             PARM       KWD(MODULO) TYPE(*DEC) LEN(3) RANGE(1 999) +
                          MIN(1) CHOICE('1-999') PROMPT('License +
                          Check in Seconds')

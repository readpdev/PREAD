      /*%METADATA                                                     */
      /* %TEXT Submit SCNSRCR                                         */
      /*%EMETADATA                                                    */
             CMD        PROMPT('SUBMIT SOURCE SCAN')
             PARM       KWD(SRCLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Source Library')
             PARM       KWD(SCANTEXT) TYPE(*CHAR) LEN(50) MIN(1) +
                          PROMPT('Scan Text')
             PARM       KWD(JOBNAME) TYPE(*NAME) LEN(10) +
                          DFT('SBMSCN') SPCVAL((SBMSCN)) +
                          PROMPT('Job Name')

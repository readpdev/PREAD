      /*%METADATA                                                     */
      /* %TEXT Install Patch                                          */
      /*%EMETADATA                                                    */
             CMD        PROMPT('Install Patch')
             PARM       KWD(PGMLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Gauss Program Library Name')
             PARM       KWD(PATCHLIB) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Patch Library Name')
             PARM       KWD(BACKOUT) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(N Y) PROMPT('Backout Patch?')
             PARM       KWD(RSTASPDEV) TYPE(*CHAR) LEN(10) +
                          DFT(*SAVASPDEV) CHOICE('Name, +
                          *SAVASPDEV') PROMPT('Restore to ASP Device')
             PARM       KWD(RSTASP) TYPE(*INT2) DFT(*SAVASP) RANGE(1 +
                          32) SPCVAL((*SAVASP 1)) CHOICE('1-32, +
                          *SAVASP') PROMPT('Restore to ASP Number')

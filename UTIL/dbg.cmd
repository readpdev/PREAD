      /*%METADATA                                                     */
      /* %TEXT List jobs for debug                                    */
      /*%EMETADATA                                                    */
             CMD        PROMPT('LIST JOBS FOR DEBUG')
             PARM       KWD(USER) TYPE(*CHAR) LEN(10) DFT(*CURRENT) +
                          CHOICE('*CURRENT, *ALL, User Name') +
                          PROMPT('User')
             PARM       KWD(STATUS) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          DFT(*ACTIVE) VALUES(*ACTIVE *JOBQ *ALL) +
                          PROMPT('Status')

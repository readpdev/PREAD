      /*%METADATA                                                     */
      /* %TEXT Telnet to system                                       */
      /*%EMETADATA                                                    */
/* PROGRAM TO PROCESS COMMAND: TELNET2SYS */
CMD
             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(10) DFT('someSystem')
             PARM       KWD(PASSWORD) TYPE(*CHAR) LEN(50) +
                          DFT('somePassWord') CASE(*MIXED) DSPINPUT(*NO)
             PARM       KWD(ENCRYPTION) TYPE(*CHAR) LEN(11) DFT(*SHA1)

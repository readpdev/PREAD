      *%METADATA                                                       *
      * %TEXT Create Session                                           *
      *%EMETADATA                                                      *
     d CreateSession   pr            10i 0 extproc('QsnCrtSsn')
     d  SessionDesc                    *   const
     d  SessDescLen                  10i 0 const

     d SessionDescDS   ds                  inz align
     d  sd_CmdKeyAct                   n   dim(24)
     d  sd_topRow                    10i 0
     d  sd_leftCol                   10i 0
     d  sd_nbrRows                   10i 0
     d  sd_dftRoll                   10i 0
     d  sd_dftCol                    10i 0
     d  sd_initSize                  10i 0
     d  sd_maxSize                   10i 0
     d  sd_bufIncr                   10i 0
     d  sd_inpRows                   10i 0
     d  sd_rsvrd1                     1
     d  sd_wrap                       1
     d  sd_rsvrd2                     1
     d  sd_dspCtl                     1
     d  sd_echoInp                    1
     d  sd_showLines                  1
     d  sd_showChars                  1
     d  sd_showKeyDsc                 1
     d  sd_monoKeyAtr                 1
     d  sd_colrKeyAtr                 1
     d  sd_monoInpAtr                 1
     d  sd_colrInpAtr                 1
     d  sd_inpLineOff                10i 0
     d  sd_inpLineLen                10i 0
     d  sd_cmdKeyOff1                10i 0
     d  sd_cmdKeyLen1                10i 0
     d  sd_cmdKeyOff2                10i 0
     d  sd_cmdKeyLen2                10i 0
     d  sd_rsvrd3                    20
     d  sd_inpLinePrm                  *
     d  sd_cmdKeyDsc1                  *
     d  sd_cmdKeyDsc2                  *
     d  sd_moreData                 500

             CMD
             PARM       KWD(OPCODE) TYPE(*CHAR) LEN(5) PROMPT(OPCODE)
             PARM       KWD(BATCHNUM) TYPE(*CHAR) LEN(10) +
                          DFT(B000000001) PROMPT(BATCHNUM)
             PARM       KWD(SEQUENCE#) TYPE(*DEC) LEN(9) +
                          PROMPT(SEQUENCE#)
             PARM       KWD(REVID) TYPE(*DEC) LEN(10) PROMPT(REVID)
             PARM       KWD(LOCKTYPE) TYPE(*DEC) LEN(5) +
                          PROMPT(LOCKTYPE)
             PARM       KWD(USERID) TYPE(*CHAR) LEN(10) PROMPT(USERID)
             PARM       KWD(NODEDID) TYPE(*CHAR) LEN(32) +
                          DFT('10.32.0.136') PROMPT(NODEID)
             PARM       KWD(CHCKOUTPTH) TYPE(*CHAR) LEN(100) +
                          DFT('C:\USR\BEAKER\FOO.DOC') +
                          PROMPT(CHECKOUTPATH)
             PARM       KWD(COMMENT) TYPE(*CHAR) LEN(100) +
                          DFT('CHECK-IN CHECK-OUT COMMENT ') +
                          PROMPT(COMMENT)
             PARM       KWD(REVERTHEAD) TYPE(*CHAR) LEN(10) +
                          PROMPT('REVERT HEAD')
             PARM       KWD(REVERTTO) TYPE(*CHAR) LEN(10) +
                          PROMPT('REVERT TO REVID')

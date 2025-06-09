             CMD
             PARM       KWD(STATEMENT) TYPE(*CHAR) LEN(1024) MIN(1) +
                          PROMPT('SQL Statement')
             PARM       KWD(SERVER) TYPE(*CHAR) LEN(10) +
                          PROMPT('Server')
             PARM       KWD(USER) TYPE(*CHAR) LEN(10) PROMPT('User ID')
             PARM       KWD(PASSWORD) TYPE(*CHAR) DSPINPUT(*NO) +
                          PROMPT('Password')

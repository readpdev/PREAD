
/* CALLS CL PROGRAM SETTLNTPWC */

             CMD

             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('System')

             PARM       KWD(PWD) TYPE(*CHAR) LEN(30) MIN(1) +
                          CASE(*MIXED) DSPINPUT(*NO) PROMPT('Password')


             CMD
             PARM       KWD(NUMRPTS) TYPE(*DEC) LEN(6) +
                          PROMPT('Number of Reports') DFT(1)
             PARM       KWD(ITERATE) TYPE(*DEC) LEN(8) +
                          PROMPT('Iterations of Each Rpt Name') DFT(1)
             PARM       KWD(NUMPGS) TYPE(*DEC) LEN(6) PROMPT('Number +
                          of Pages') DFT(1)
             PARM       KWD(RPTPFX) TYPE(*CHAR) LEN(3) DFT(RPT) +
                          PMTCTL(PREFIX) PROMPT('Report Name Prefix')
             PARM       KWD(RPTNAM) TYPE(*CHAR) LEN(10) +
                          DFT(DFTREPORT) PMTCTL(REPORTNAME) +
                          PROMPT('Report Name')
             PARM       KWD(RPTWIDTH) TYPE(*DEC) LEN(3 0) DFT(80) +
                          RANGE(80 247) PROMPT('Report width')
             PARM       KWD(CRTNDX) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Auto add +
                          configuration?')
             PARM       KWD(NBROFNDXS) TYPE(*DEC) LEN(2) DFT(7) +
                          RANGE(1 35) PROMPT('Number of indices')
             PARM       KWD(PRT4ARCH) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Print for +
                          archive?')
             PARM       KWD(OUTQ) TYPE(*CHAR) LEN(10) PROMPT('OutQ +
                          Name')
             PARM       KWD(OUTQL) TYPE(*CHAR) LEN(10) PROMPT('OutQ +
                          Library')
 PREFIX:     PMTCTL     CTL(NUMRPTS) COND((*GT 1))
 REPORTNAME: PMTCTL     CTL(NUMRPTS) COND((*EQ 1))

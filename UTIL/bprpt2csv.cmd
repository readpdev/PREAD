             CMD        PROMPT('Balboa Peaks: Report to CSV')
             PARM       KWD(RPTTYPE) TYPE(*CHAR) LEN(10) MIN(1) +
                          PROMPT('Report Type')
             PARM       KWD(RPTTEMPLT) TYPE(*PNAME) LEN(128) MIN(1) +
                          CHOICE(PATH) PROMPT('Report Template IFS +
                          Input File')
             PARM       KWD(CSVOUTPUT) TYPE(*PNAME) LEN(128) MIN(1) +
                          CHOICE(PATH) PROMPT('CSV IFS Output File')
             PARM       KWD(DATEFR) TYPE(*CHAR) LEN(8) +
                          FULL(*YES) CHOICE('YYYYMMDD, Blank for +
                          all.') PROMPT('From Date')
             PARM       KWD(DATETO) TYPE(*CHAR) LEN(8) +
                          FULL(*YES) CHOICE('YYYYMMDD, Blank for +
                          all.') PROMPT('To Date')

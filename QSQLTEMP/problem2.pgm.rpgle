       dcl-s myDate timestamp;

       //exec sql select current timestamp into :myDate from sysibm.sysdummy1;

     D*      SQL COMMUNICATION AREA                                             SQL
     D SQLCA           DS                                                       SQL
     D  SQLCAID                       8A   INZ(X'0000000000000000')             SQL
     D  SQLAID                        8A   OVERLAY(SQLCAID)                     SQL
     D  SQLCABC                      10I 0                                      SQL
     D  SQLABC                        9B 0 OVERLAY(SQLCABC)                     SQL
     D  SQLCODE                      10I 0                                      SQL
     D  SQLCOD                        9B 0 OVERLAY(SQLCODE)                     SQL
     D  SQLERRML                      5I 0                                      SQL
     D  SQLERL                        4B 0 OVERLAY(SQLERRML)                    SQL
     D  SQLERRMC                     70A                                        SQL
     D  SQLERM                       70A   OVERLAY(SQLERRMC)                    SQL
     D  SQLERRP                       8A                                        SQL
     D  SQLERP                        8A   OVERLAY(SQLERRP)                     SQL
     D  SQLERR                       24A                                        SQL
     D   SQLER1                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER2                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER3                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER4                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER5                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER6                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLERRD                     10I 0 DIM(6)  OVERLAY(SQLERR)              SQL
     D  SQLWRN                       11A                                        SQL
     D   SQLWN0                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN1                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN2                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN3                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN4                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN5                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN6                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN7                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN8                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN9                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWNA                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D  SQLWARN                       1A   DIM(11) OVERLAY(SQLWRN)              SQL
     D  SQLSTATE                      5A                                        SQL
     D  SQLSTT                        5A   OVERLAY(SQLSTATE)                    SQL
     D*  END OF SQLCA                                                           SQL
     D  SQLROUTE       C                   CONST('QSYS/QSQROUTE')               SQL
     D  SQLOPEN        C                   CONST('QSYS/QSQLOPEN')               SQL
     D  SQLCLSE        C                   CONST('QSYS/QSQLCLSE')               SQL
     D  SQLCMIT        C                   CONST('QSYS/QSQLCMIT')               SQL
     D  SQFRD          C                   CONST(2)                             SQL
     D  SQFCRT         C                   CONST(8)                             SQL
     D  SQFOVR         C                   CONST(16)                            SQL
     D  SQFAPP         C                   CONST(32)                            SQL
     D                 DS                                                       SET
     D  SQL_00000              1      2B 0 INZ(128)                             length of header
     D  SQL_00001              3      4B 0 INZ(1)                               statement number
     D  SQL_00002              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00003              9      9A   INZ('0')                             data is okay
     D  SQL_00004             10    128A                                        end of header
     D  SQL_00005            129    154Z                                        MYDATE
       //*exec sql set :myDate = current timestamp;
     C                   Z-ADD     -4            SQLER6                         SQL   1
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00000                      SQL
     C     SQL_00003     IFEQ      '1'                                          SQL
     C                   EVAL      MYDATE = SQL_00005                           SQL
     C                   END                                                    SQL

       *inlr = *on;
       return;

      *%METADATA                                                       *
      * %TEXT Link File Summary by Type, Year, Month                   *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller)

     d run             pr                  extproc('system')
     d  cmd                            *   value options(*string)

     d typeAndFile     ds
     d  rpttype                      10
     d  lnkfile                      10

     d sqlStmt         s            256

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;
       exec sql drop table qgpl/lnkfillst;
       exec sql CREATE TABLE QGPL/Lnkfillst (RPTTYPE CHAR (10) NOT NULL WITH
         DEFAULT, LNKFILE CHAR (10) NOT NULL WITH DEFAULT);
       exec sql
         insert into lnkfillst select rtypid, lnkfil
         from rmaint left join rlnkdef on RRNAM =
         lRNAM and RJNAM = lJNAM and RPNAM = lPNAM and RUNAM = lUNAM and
         RUDAT = lUDAT where lnkfil <> ' ';
       exec sql drop table qgpl/lnkfilsum;
       exec sql
         CREATE TABLE QGPL/LNKFILSUM (RTYPE CHAR (10 ) NOT NULL WITH
         DEFAULT, YYYY NUMERIC (4 ) NOT NULL WITH DEFAULT, MM NUMERIC (2 )
         NOT NULL WITH DEFAULT, LNKSUM INTEGER NOT NULL WITH DEFAULT);
       sqlStmt = 'select * from lnkfillst';
       exec sql prepare sqlStmt from :sqlStmt;
       exec sql declare c1 cursor for sqlStmt;
       exec sql open c1;
       exec sql fetch c1 into :typeAndFile;
       dow sqlcod = 0;
         run('ovrdbf rlink ' + lnkFile);
         exec sql insert into qgpl/lnkfilsum select :rpttype,
           left(lxiv8,4), substr(lxiv8,5,2), count(*)
           from rlink group by :rpttype, left(lxiv8,4),
           substr(lxiv8,5,2) order by :rpttype, left(lxiv8,4),
           substr(lxiv8,5,2);
         exec sql fetch c1 into :typeAndFile;
       enddo;
       run('dltovr rlink');
       exec sql drop table qgpl/lnkfillst;
       exec sql close c1;
       *inlr = '1';
      /end-free

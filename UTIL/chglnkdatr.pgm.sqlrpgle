      *%METADATA                                                       *
      * %TEXT Change Link Create Date                                  *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('QC2LE')

     frlnkdef   if   e           k disk

     d system          pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d q               c                   ''''
     d OK              c                   0
     d SQLEOF          c                   100

     d sqlStmt         s            512
     d msg             s             50
     d decrementVal    s              5i 0
     d lxiv8           s              8
     d isoDate         s               d   datfmt(*iso)
     d thisCount       s             10i 0

     c     *entry        plist
     c                   parm                    reportName       10
     c                   parm                    decrementBy      10
     c                   parm                    decrementVal

       exec sql set option closqlcsr=*endmod,commit=*none;

       chain reportName rlnkdef;
       if not %found;
         return;
       endif;

       isoDate = %date();

       system('ovrdbf lnkfil ' + lnkfil + ' ovrscope(*calllvl)');
       sqlStmt = 'select lxiv8 from lnkfil';
       exec sql prepare stmt from :sqlStmt;
       exec sql declare csr01 cursor for stmt;
       exec sql open csr01;

       exec sql fetch next from csr01 into :lxiv8;
       dow sqlcod = OK;
         lxiv8 = %char(isoDate:*iso0);
         exec sql update lnkfil set lxiv8 = :lxiv8 where current of csr01;
         thisCount += 1;
         if thisCount >= 10000;
           select;
             when decrementBy = '*DAY';
               isoDate = isoDate - %days(decrementVal);
             when decrementBy = '*MONTH';
               isoDate = isoDate - %months(decrementVal);
           endsl;
           thisCount = 0;
         endif;
         exec sql fetch next from csr01 into :lxiv8;
       enddo;

       if sqlcod <> OK and sqlcod <> SQLEOF;
         msg = 'SQL Code: ' + %trim(%editc(sqlcod:'Z'));
         dsply msg;
       endif;

       exec sql close csr01;
       system('dltovr lnkfil lvl(*)');


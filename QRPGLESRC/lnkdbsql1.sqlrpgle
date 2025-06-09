      *%METADATA                                                       *
      * %TEXT SQL Link Retrieval Module                                *
      *%EMETADATA                                                      *
     h nomain

      /copy 'QRPGLESRC/@lnkdbsql0.rpgleinc'

      **************************************************************************
     p sqlDBopen       b                   export
     d                 pi            10i 0
     d sqlStmtIn                       *   const options(*trim:*string)

     d sqlStmt         s           2048

      /free
       exec sql set option closqlcsr=*endactgrp,commit=*none,
         alwcpydta=*optimize;

       sqlStmt = %str(sqlStmtIn) + ' for read only';

       exec sql prepare stmt from :sqlStmt;
       if sqlcod = 0;
         exec sql declare lnkCsr scroll cursor for stmt;
       endif;
       if sqlcod = 0;
         exec sql open lnkCsr;
       endif;

       if sqlcod <> 0;
         return -1;
       endif;

       return 0;

      /end-free
     p                 e

      **************************************************************************
     p sqlDBread       b                   export
     d                 pi            10i 0
     d hitRtnP                         *
     d operation                      5    const
     d hitStruct       ds                  likeds(lnkNdxSQL) based(hitRtnP)
      /free
       if operation = 'SELCR' or operation = 'READ' or operation = 'RDGT';
         exec sql fetch lnkCsr into :hitStruct;
       endif;
       return sqlcod;
      /end-free
     p                 e

      **************************************************************************
     p sqlDBclose      b                   export
      /free
       monitor;
         exec sql close lnkCsr;
       on-error;
       endmon;
       return;
      /end-free
     p                 e

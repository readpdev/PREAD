      *%METADATA                                                       *
      * %TEXT SQL Link Retrieval Module                                *
      *%EMETADATA                                                      *
     h nomain

      /copy 'QRPGLESRC/@lnkdbsql0.rpgleinc'

      **************************************************************************
     p sqlDBopen       b                   export
     d                 pi            10i 0
     d sqlStmtIn                       *   const options(*trim:*string)

     d sqlStmt         s           1024

      /free

       sqlStmt = %str(sqlStmtIn);

       exec sql prepare stmt from :sqlStmt;
       exec sql declare lnkCsr insensitive scroll cursor for stmt;
       exec sql open lnkCsr;

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
       if operation = 'SELCR' or operation = 'READ';
         exec sql fetch lnkCsr into :hitStruct;
       endif;
       return sqlcod;
      /end-free
     p                 e

      **************************************************************************
     p sqlDBclose      b                   export
      /free
       exec sql close lnkCsr;
       return;
      /end-free
     p                 e

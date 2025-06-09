      *%METADATA                                                       *
      * %TEXT Get TIF Page Count Based on Index Values                 *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller)

     frlnkdef   if   e           k disk

     d getPgCnt        pr                  extpgm('MAG922')
     d  batch                        10
     d  imgrrn                        9  0
     d  imgType                       3
     d  pages                         9  0
     d  rtnCode                       7

     d mapNdxPtrs      pr

     d ndxP            s               *   dim(MAXNDX)
     d MAXNDX          c                   7
     d sq              c                   ''''
     d sqlStmt         s            256
     d needAnd         s               n   inz('0')
     d batch           s             10
     d imgrrn          s              9  0
     d imgType         s              3    inz('TIF')
     d #pgs            s              9  0
     d rc              s              7
     d i               s             10i 0

     c     *entry        plist
     c                   parm                    docClass         10
     c                   parm                    ndxVal1          70
     c                   parm                    ndxVal2          70
     c                   parm                    ndxVal3          70
     c                   parm                    ndxVal4          70
     c                   parm                    ndxVal5          70
     c                   parm                    ndxVal6          70
     c                   parm                    ndxVal7          70
     c                   parm                    pageCount         9 0
      /free
       mapNdxPtrs();
       chain docClass rlnkdef;
       if %found;
         sqlStmt = 'select ldxnam, lxspg from ' + lnkfil + ' where ';
         for i = 1 to MAXNDX;
           if %str(ndxP(i):70) <> ' ';
             if needAnd;
               sqlStmt = %trim(sqlStmt) + ' and';
             endif;
             sqlStmt = %trim(sqlStmt) + ' lxiv' + %trim(%char(i)) + '=' + sq +
               %trim(%str(ndxP(i):70)) + sq;
             needAnd = '1';
           endif;
         endfor;
         exec sql prepare stmt from :sqlStmt;
         exec sql declare csr cursor for stmt;
         exec sql open csr;
         dow sqlcod = 0;
           exec sql fetch next from csr into :batch, :imgrrn;
           if sqlcod = 0;
             getPgCnt(batch:imgrrn:imgType:#pgs:rc);
             if rc <> ' ';
               // some error occurred.
               leave;
             endif;
             pageCount = pageCount + #pgs;
           endif;
         enddo;
         exec sql close csr;
       endif;
       *inlr = '1';
      /end-free

     p mapNdxPtrs      b

      /free
       ndxP(1) = %addr(ndxVal1);
       ndxP(2) = %addr(ndxVal2);
       ndxP(3) = %addr(ndxVal3);
       ndxP(4) = %addr(ndxVal4);
       ndxP(5) = %addr(ndxVal5);
       ndxP(6) = %addr(ndxVal6);
       ndxP(7) = %addr(ndxVal7);
       return;
      /end-free

     p                 e

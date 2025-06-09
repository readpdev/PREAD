     h dftactgrp(*no) actgrp(*new)

     d main            pr                  extpgm('SQLR')
     d main            pi

     d lnkDef        e ds                  extname(RLNKDEF) qualified
     d linkName        s             10    dim(7) based(linkNameP)

      /free
       exec sql set option  commit=*none, datfmt=*iso, timfmt=*iso,
         Naming=*SYS, CloSQLCsr=*EndActGrp;

       exec sql select * into :lnkDef from rlnkdef where lrnam = 'ECHECK';

       linkNameP = %addr(lnkDef.lndxn1);

       *inlr = '1';
       return;
      /end-free

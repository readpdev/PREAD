      *%METADATA                                                       *
      * %TEXT Export Link Values to IFS                                *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE')

     frlnkdef   if   e           k disk
     frmaint4   if   e           k disk

     d spycdpag        pr                  extpgm('SPYCDPAG')
     d  frCCSID                       5    const
     d  toCCSID                       5    const
     d  frChars                     256
     d  toChars                     256
     d frChars         s            256
     d toChars         s            256

     d spyifs          pr                  extpgm('SPYIFS')
     d  opcode                       10    const
     d  path                        256
     d  data                      32512    const
     d  datLen                       10i 0 const
     d  frCodePage                    5    const
     d  toCodePage                    5    const
     d  rtnMsgID                      7
     d rtnMsgID        s              7

     d linkDef       e ds                  extname(rlink)

     d sq              c                   ''''
     d dq              c                   '"'
     d MAXNDX          c                   7
     d crlf            c                   x'0d0a'

     d O_WRONLY        C                   2
     d O_CREAT         C                   8
     d O_TRUNC         C                   64
     d O_CODEPAGE      C                   8388608
     d S_IRWXU         C                   448
     d S_IRWXG         C                   56
     d S_IRWXO         C                   7

      * Open File
     d open            PR            10i 0 extproc('open')
     d  path                      32767a   options(*varsize)
     d  oflag                        10i 0 value
     d  mode                         10u 0 value options(*nopass)
     d  codepage                     10u 0 value options(*nopass)

      * Close File
     d clof            PR            10i 0 extproc('close')
     d  fildes                       10i 0 value

      * Write to Descriptor
     d write           PR            10i 0 extproc('write')
     d  fildes                       10i 0 value
     d  buf                       32767a   options(*varsize)
     d  nbyte                        10u 0 value

     d system          pr                  extproc('system')
     d  cmd                            *   value options(*string)

     d sqlStmt         s            512    inz
     d where           s            512    inz
     d ndxData         s             25    dim(MAXNDX) based(ndxP)
     d x               s             10i 0
     d fh              s             10i 0
     d codePage        s              5i 0
     d outStr          s           1024
     d outLen          s             10i 0

     c     *entry        plist
     c                   parm                    docClass         10
     c                   parm                    ndx1             25
     c                   parm                    ndx2             25
     c                   parm                    ndx3             25
     c                   parm                    ndx4             25
     c                   parm                    ndx5             25
     c                   parm                    ndx6             25
     c                   parm                    ndx7             25
     c                   parm                    frDate            8
     c                   parm                    toDate            8
     c                   parm                    codePage
     c                   parm                    ifsTgt          256

     c     rlnkKey       klist
     c                   kfld                    RRNAM
     c                   kfld                    RJNAM
     c                   kfld                    RPNAM
     c                   kfld                    RUNAM
     c                   kfld                    RUDAT

      /free
       // Retrieve document class definition.
       chain docClass rmaint4;
       if not %found;
         dsply 'Document class not found.';
         return;
       endif;
       // Retrieve document link definition(s).
       chain rlnkKey rlnkdef;
       if not %found;
         dsply 'Link definition not found.';
       endif;
       // Create subdirectories if necessary.
       spyifs('CRTPTH':ifsTgt:' ':0:'00000':%editc(codePage:'X'):rtnMsgid);
       // Open target ifs file.
       ifsTgt = %trim(ifsTgt) + x'00';
       fh = open(ifsTgt:O_WRONLY+O_CREAT+O_TRUNC+O_CODEPAGE:
         S_IRWXU+S_IRWXG+S_IRWXO:codePage);
       if fh < 0;
         dsply 'Error opening IFS file.';
         return;
       endif;
       // Build the SQL statement.
       system('ovrdbf rlink ' + lnkfil + ' ovrscope(*job)');
       ndxP = %addr(ndx1);
       for x = 1 to 7;
         if ndxData(x) <> ' ';
           if where <> ' ';
             where = %trim(where ) + ' and';
           endif;
           where = %trimr(where) + ' lxiv' + %char(x) + '=' +
             sq + %trimr(ndxData(x)) + sq;
         endif;
       endfor;
       if frDate <> *all'0';
         if where <> ' ';
           where = %trim(where) + ' and';
         endif;
         where  = %trim(where) + ' lxiv8 >= ' + sq + frDate + sq;
       endif;
       if toDate <> *all'0';
         where = %trim(where) + ' and lxiv8 <=' + sq + toDate + sq;
       endif;
       sqlStmt = 'select * from rlink';
       if where <> ' ';
         sqlStmt = %trim(sqlStmt) + ' where ' + where;
       endif;
       exec sql prepare stmt from :sqlStmt;
       exec sql declare csr01 cursor for stmt;
       exec sql open csr01;
       spycdpag('00000':%editc(codepage:'X'):frChars:toChars);
       %subst(toChars:1:30) = %subst(frChars:1:30);
       dow 1 = 1;
         exec sql fetch next from csr01 into :linkDef;
         if sqlcod <> 0;
           leave;
         endif;
         outStr = dq + %trim(docClass) + dq + ',' +
                  dq + %trim(lxiv1) + dq + ',' +
                  dq + %trim(lxiv2) + dq + ',' +
                  dq + %trim(lxiv3) + dq + ',' +
                  dq + %trim(lxiv4) + dq + ',' +
                  dq + %trim(lxiv5) + dq + ',' +
                  dq + %trim(lxiv6) + dq + ',' +
                  dq + %trim(lxiv7) + dq + ',' +
                  dq + %trim(lxiv8) + dq + crlf;
         outLen = %len(%trim(outStr));
         outStr = %xlate(frChars:toChars:outStr);
         // Write the comma delimited data to the output file.
         callp write(fh:outStr:outLen);
       enddo;
       // Clean up and exit.
       exec sql close csr01;
       clof(fh);
       system('dltovr rlink lvl(*job)');
       *inlr = '1';
      /end-free

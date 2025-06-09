      *%METADATA                                                       *
      * %TEXT Create stubbed service program                           *
      *%EMETADATA                                                      *
     h main(main) dftactgrp(*no) actgrp(*new)

      * Creates stubbed version of a given service program for the purpose
      * of creating a dummy version of the service program with a level check of
      * *NO. This will prevent us from having to recompile our interfaces to
      * third party products when they're service program signatures change.

     d run             pr                  extproc('system')
     d  cmd                            *   value options(*string:*trim)

     d srcDta          s            120

     d main            pr                  extpgm('CRTSTUBSPR')
     d  expSrvPgm                    10
     d  expSrvPgmLib                 10
     d  modSrcFil                    10
     d  modSrcLib                    10
     d  modSrcMbr                    10
     d  modNam                       10
     d  modLib                       10
     d  srvPgmSrcFil                 10
     d  srvPgmSrcLib                 10
     d  srvPmgSrcMbr                 10
     d  srvPgmNam                    10
     d  srvPgmLib                    10

     d fmtStubbedFunc  pr                  like(srcDta)
     d  source                             like(srcDta)

      * Main function
     p main            b
     d                 pi
     d  expSrvPgm                    10
     d  expSrvPgmLib                 10
     d  modSrcFil                    10
     d  modSrcLib                    10
     d  modSrcMbr                    10
     d  modNam                       10
     d  modLib                       10
     d  srvPgmSrcFil                 10
     d  srvPgmSrcLib                 10
     d  srvPgmSrcMbr                 10
     d  srvPgmNam                    10
     d  srvPgmLib                    10

     d i               s             10i 0

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;
       // Retrieve the binder source for the 'real' srvpgm.
       run('rtvbndsrc  srvpgm(' + %trimr(expSrvPgmLib) + '/' +
         %trimr(expSrvPgm) + ') srcfile(' + %trimr(srvPgmSrcLib) + '/' +
         %trimr(srvPgmSrcFil) + ') srcmbr(' + %trimr(srvPgmSrcMbr) + ')' );
       // Replace the SIGNATURE with LVLCHK(*N0) in the binder source.
       run('ovrdbf qsrvsrc ' + %trimr(srvPgmSrcLib) + '/' +
         %trimr(srvPgmSrcFil) + ' ' + %trimr(srvPgmSrcMbr));
       srcDta = 'STRPGMEXP LVLCHK(*NO)';
       exec sql update qsrvsrc set srcDta = :srcDta where rrn(qsrvsrc) = 1;
       // Delete then create target module source member.
       run('rmvm ' + %trimr(modSrcLib) + '/' + %trimr(modSrcFil) + ' ' +
         %trimr(modSrcMbr));
       run('addpfm ' + %trimr(modSrcLib) + '/' + %trimr(modSrcFil) + ' ' +
         %trimr(modSrcMbr) + ' srctype(c)');
       run('ovrdbf qcsrc ' + %trimr(modSrcLib) + '/' +
         %trimr(modSrcFil) + ' ' + %trimr(modSrcMbr));
       // Read exported module names from binder source and then write to
       // module source member the stubbed procedures.
       for i = 1 to *hival;
         exec sql select srcDta into :srcDta from qsrvsrc where rrn(qsrvsrc) =
           :i;
         if sqlcod = 0;
           srcDta = fmtStubbedFunc(srcDta);
           if srcDta <> ' ';
             exec sql insert into qcsrc (srcSeq, srcDat, srcDta)
               values(0, 0, :srcDta);
           endif;
         else;
           leave;
         endif;
       endfor;
       // Compile C module.
       run('crtcmod module(' + %trimr(modLib) + '/' + %trimr(modNam) + ')' +
        ' srcfile(' + %trimr(modSrcLib) + '/' + %trimr(modSrcFil) + ')' +
        ' srcmbr(' + %trimr(modSrcMbr) + ') replace(*yes)');
       // Create the service program.
       run('crtsrvpgm srvpgm(' + %trimr(srvPgmLib) + '/' + %trimr(srvPgmNam) +
        ') srcfile(' + %trimr(srvPgmSrcLib) + '/' + %trimr(srvPgmSrcFil) +
        ') srcmbr(' + %trimr(srvPgmSrcMbr) + ')');
       return;
      /end-free
     p                 e

     p fmtStubbedFunc  b
     d                 pi                  like(srcDta)
     d  sourceCode                         like(srcDta)
     d rtnSrcCod       s                   like(srcDta) inz
     d sPos            s             10i 0
     d ePos            s             10i 0
      /free
       sPos = %scan('("':sourceCode);
       if sPos > 0;
         sPos += 2;
         ePos = %scan('"':sourceCode:sPos);
         rtnSrcCod = 'void ' + %subst(sourceCode:sPos:ePos-sPos) + '(void){};';
       endif;
       return rtnSrcCod;
      /end-free
     p                 e

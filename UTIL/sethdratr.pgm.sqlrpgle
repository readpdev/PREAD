      *%METADATA                                                       *
      * %TEXT Change the S36 Continue Splf Attr in MRPTATR             *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE')

     d sqlStmt         s            512
     d SQ              c                   ''''

     d                 ds
     d headerRcd                    255
     d   orgsfp                      10u 0 overlay(headerRcd:113)
     d   orgsfc                      10u 0 overlay(headerRcd:186)

     d system          pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     c     *entry        plist
     c                   parm                    folderIn         10
     c                   parm                    lib              10

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;

       system('ovrdbf folder ' + %trimr(lib) + '/' + %trimr(folderIn) +
         ' ovrscope(*job)');

       exec sql select * into :headerRcd from folder where rrn(folder) = 1;

       orgsfp = 38816;
       orgsfc = 39000;

       // Replace any single quotes in the header record with blanks
       headerRcd = %replace(' ':headerRcd:%scan('''':headerRcd):1);

       sqlStmt = 'update folder set ' + %trimr(folderIn) + ' = ' +
         SQ + headerRcd + SQ + ' where rrn(folder) = 1';

       exec sql execute immediate :sqlStmt;

       system('dltovr folder lvl(*job)');

       exsr quit;

       //*****************************************************************
       begsr quit;
         *inlr = '1';
       endsr;

      /end-free

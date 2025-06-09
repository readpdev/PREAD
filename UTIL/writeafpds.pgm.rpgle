     h dftactgrp(*no) bnddir('QC2LE')

     fqsysprt   o    f   80        printer usropn

     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         512    const
     d  cmdLen                       15  5 const

     d cvtch           pr                  extproc('cvtch')
     d  hex                            *   value
     d  char                           *   value
     d  len                          10i 0 value

     d outLine         ds            80
     d i               s             10i 0
     d j               s             10i 0
     d strPos          s             10i 0
     d digits1         s              1    dim(12) ctdata perrcd(12)
     d digits2         s              1    dim(16) ctdata perrcd(16)
     d hexVal          s              1
     d charVal         s              2

      /free
       run('OVRPRTF FILE(QSYSPRT) DEVTYPE(*AFPDS) PAGESIZE(*N 80) ' +
         'CHRID(218 875)':256);
       open qsysprt;
       outLine = ' ';
       for i = 1 to 12;
         if i = 1;
           outLine = %trimr(outLine) + '    ' + digits1(i) + '-';
         else;
           outLine = %trimr(outLine) + '  ' + digits1(i) + '-';
         endif;
       endfor;
       except;
       for i = 1 to 16;
         outLine = '-' + digits2(i);
         strPos = 5;
         for j = 1 to 12;
           charVal = digits1(j) + digits2(i);
           cvtch(%addr(hexVal):%addr(charVal):2);
           %subst(outLine:strPos:1) = hexVal;
           strPos = strPos + 4;
         endfor;
         except;
       endfor;
       close qsysprt;
       run('dltovr qsysprt':20);
       *inlr = '1';
      /end-free
     oqsysprt   e
     o                       outLine
**ctdata digits1
456789ABCDEF
**ctdata digits2
0123456789ABCDEF

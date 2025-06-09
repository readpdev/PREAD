     h dftactgrp(*no) bnddir('QC2LE')

FUTILfutil2     if   e             disk    usropn rename(util2:xutil)

     d sq              c                   ''''

     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         512    const
     d  cmdlen                       15  5 const
     d cmd             s            512

     d objName         s             10
     d objType         s             10
     d strObjTyp       s             10i 0

      /free
       callp(e) run('ovrdbf util2 mbr(text)':22);
       open util2;
       read util2;
       dow not %eof;
         objName = %subst(srcdta:46:%scan(' ':srcdta:46)-46);
         strObjTyp = %scan('*':srcdta:46);
         objType = %subst(srcdta:strObjTyp:%scan(' ':srcdta:
           strObjTyp)-strObjTyp);
         cmd = 'ACMSDLTOBJ REL(OPENTEXT/DOCMANAGER/R8.7) OBJNAME(' +
           %trimr(objName) + ') OBJTYPE(' + %trimr(objType) + ') ENV(PDN)';
         callp(e) run(cmd:%len(%trimr(cmd)));
         cmd = 'ACMSDLTOBJ REL(OPENTEXT/DOCMANAGER/R8.7) OBJNAME(' +
           %trimr(objName) + ') OBJTYPE(*PGM) ENV(PDN)';
         callp(e) run(cmd:%len(%trimr(cmd)));
         read util2;
       enddo;
       close util2;
       callp(e) run('dltovr util2':12);
       *inlr = '1';
      /end-free

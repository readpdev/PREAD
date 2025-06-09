       ctl-opt main(main) bnddir('SPYBNDDIR');
      ***********************
      /copy directives
      ***********************
      *
J6882 * 02-09-17 PLR Print binary PDF documents to PDF capable printers.
      *              All printers must be anonymous FTP capable. Printers are
      *              defined via DOCPTR. Menu 4>2.
      *

       dcl-ds pgm_sts PSDS;
         pgmName char(10) pos(1);
         jobNbr char(6) pos(264);
       end-ds;

       dcl-proc main;
         dcl-pi *n extpgm('MGPRTPDF');
           imgClass char(10);
           ndxIn1 char(70);
           ndxIn2 char(70);
           ndxIn3 char(70);
           ndxIn4 char(70);
           ndxIn5 char(70);
           ndxIn6 char(70);
           ndxIn7 char(70);
           fDate char(8);
           tDate char(8);
           printer char(10);
           jobd char(10) options(*nopass);
           jobdLib char(10) options(*nopass);
         end-pi;

         dcl-pr system extproc('system');
           command pointer options(*string:*trim) value;
         end-pr;
         dcl-s cmdStr char(2048);

         dcl-pr spyPath extpgm('SPYPATH');
           pathID char(10) const;
           pathRtn char(256);
         end-pr;
         dcl-s pathRtn char(256);

         dcl-ds rlnkdef extname('RLNKDEF') end-ds;
         dcl-s linkName char(10) dim(MAXNDX) based(linkNameP);
         dcl-s ndxIn char(70) dim(MAXNDX) based(ndxInP);
         dcl-c MAXNDX 7;
         dcl-c SQ '''';
         dcl-s i int(10);
         dcl-s ftpbuf char(92);
         dcl-s printerAdr char(20);

         exec sql set option closqlcsr=*endmod,commit=*none;

         // If a job description is passed, this program has been requested to submit
         // itself.
         if %parms > 11;
           cmdStr = 'sbmjob job(SPYPRINT) user(*CURRENT) syslibl(*CURRENT) ' +
             'inllibl(*CURRENT) ' +
             'jobd(' + %trimr(jobdlib) + '/' + %trimr(jobd) + ') ' +
             'cmd(call mgprtpdf (' +
             sq + imgClass + sq + ' ' +
             sq + ndxIn1 + sq + ' ' +
             sq + ndxIn2 + sq + ' ' +
             sq + ndxIn3 + sq + ' ' +
             sq + ndxIn4 + sq + ' ' +
             sq + ndxIn5 + sq + ' ' +
             sq + ndxIn6 + sq + ' ' +
             sq + ndxIn7 + sq + ' ' +
             sq + fdate + sq + ' ' +
             sq + tdate + sq + ' ' +
             sq + printer + sq + '))';
           system(cmdStr);
           return;
         endif;

         ndxInP = %addr(ndxIn1);
         linkNameP = %addr(lndxn1);

         // Get the ordinal index field names.
         exec sql select * into :rlnkdef from rlnkdef where lrnam = :imgClass;

         // Export the document to the IFS so it can be FTP'd to the printer.
         cmdStr = 'EXPOBJSPY OBJTYPE(*DOCLINK) OBJ(' + %trimr(IMGCLASS) +
           ') CRITERIA(';
         for i = 1 to %elem(ndxIn);
           ndxIn(i) = %trim(ndxIn(i));
           if ndxIn(i) <> ' ';
             cmdStr = %trimr(cmdStr) + '(' +
               %trimr(%subst(linkName(i):2:%len(linkName(i))-1)) + ' *CHR ' +
               sq + %trimr(ndxIn(i)) + sq + ')';
           endif;
         endfor;
         if fDate = ' ';
           fDate = '*BEGIN';
         else;
           fDate = %char(%date(fDate:*iso0):*usa0);
         endif;
         if tDate = ' ';
           tDate = '*END';
         else;
           tDate = %char(%date(tDate:*iso0):*usa0);
         endif;
         cmdStr = %trimr(cmdStr) + ') DATERANGE(' + %trimr(fDate) + ' ' +
           %trimr(tDate) + ')';
         spyPath('*TEMP':pathRtn);
         pathRtn = %trimr(pathRtn) + '/PDFPRT' + jobNbr + '.pdf';
         cmdStr = %trimr(cmdStr) + ' PATH(' + sq + %trimr(pathRtn) + sq +
           ') REPLACE(*YES)';
         system(cmdStr);

         // Send the PDF file to the printer via FTP.
         exec sql select PNODID into :printerAdr from rptable
           where prtnm = :printer;
         system('dltf pread/ftpinput');
         system('dltf pread/ftplog');
         system('crtsrcpf pread/ftpinput 92 input');
         system('ovrdbf input pread/ftpinput ovrscope(*job)');
         system('ovrdbf output pread/ftplog ftplog ovrscope(*job)');
         ftpcmd(' ');
         ftpcmd('user anonymous anonymous');
         ftpcmd('bin');
         ftpcmd('namefmt 1');
         ftpcmd('put ' + %trimr(pathRtn));
         ftpcmd('quit');
         system('ftp ' + sq + %trim(printerAdr) + sq);
         system('dltovr input lvl(*job)');
         system('dltovr output lvl(*job)');

         system('rmvlnk ' + sq + %trimr(pathRtn) + sq);

         return;

       end-proc;

      ***********************************************************************
       dcl-proc ftpcmd;
         dcl-pi *n;
           ftpstr pointer value options(*string:*trim);
         end-pi;

         dcl-s srcseq packed(6:2) inz;
         dcl-s srcdat packed(6) inz;
         dcl-s srcdta char(80);

         srcdta = %str(ftpstr);
         exec sql insert into pread/input values(:srcseq, :srcdat, :srcdta);

         return;

       end-proc;

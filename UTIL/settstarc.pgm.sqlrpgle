
     d maint         e ds                  extname(rmaint) inz
     d rptdir        e ds                  extname(mrptdir) inz

     d sysdft          ds          1024    dtaara
     d  exclRptNam                    1    overlay(sysdft:252)
     d  exclJobNam                    1    overlay(sysdft:253)
     d  exclPgmNam                    1    overlay(sysdft:254)
     d  exclUsrNam                    1    overlay(sysdft:255)
     d  exclUsrDta                    1    overlay(sysdft:256)

     d                sds
     d thisPgm           *proc
     d curUser               254    263
     d jobNbr                264    269

     d i               s             10i 0
     d j               s             10i 0
     d k               s             10i 0 inz(1000)
     d reportName      s             10

      /free
       exec sql set option closqlcsr=*endmod,commit=*NONE;
       in sysdft;
       clear maint;
       if exclJobNam = 'N';
         rjnam = 'JOBNAME';
       endif;
       if exclPgmNam = 'N';
         rpnam = thisPgm;
       endif;
       if exclUsrNam = 'N';
         runam = curUser;
       endif;
       if exclUsrDta = 'N';
         rudat = thisPgm;
       endif;
       rmlckf = 101;
       rmannf = 'N';
       rmbrcf = 'N';
       fldr = 'TESTFLDR';
       fldrlb = 'TESTFLDLB';
       jobnam = rjnam;
       usrnam = runam;
       pgmopf = rpnam;
       for i = 1 to 31000;
         reportName = 'RPT' + %subst(%editc(i:'X'):4:7);
         rrnam = reportName;
         rtypid = reportName;
         rrdesc = reportName;
         jobnum = jobNbr;
         filnam = reportName;
         datfop = %int(%char(%date():*cymd0));
         timfop = %int(%char(%time():*iso0));
         // exec sql insert into rmaint values(:maint);
         for j = 1 to 1;
           filnum = j;
           repind = 'SPY' + %subst(%editc(k:'X'):4:7);
           k += 1;
           exec sql insert into mrptdir values(:rptdir);
         endfor;
       endfor;
       *inlr = '1';
       return;
      /end-free

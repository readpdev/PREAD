      *%METADATA                                                       *
      * %TEXT Export Report with Description as File Name              *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) actgrp(*new);

       dcl-proc main;
         dcl-pi *n extpgm('EXPBYDSC');
           reportID char(10);
           path char(128);
         end-pi;

         dcl-pr system extproc('system');
           command pointer options(*string:*trim) value;
         end-pr;

         dcl-s cmd char(256);
         dcl-ds rptdir extname('MRPTDIR') end-ds;
         dcl-s rptDsc char(40);

         exec sql set option closqlcsr=*endmod,commit=*none;

         // Fetch key fields from MRPTDIR
         exec sql select * into :rptdir from mrptdir where repind = :reportID;
         if sqlcod <> 0; // No document found with that ID, leave.
           return;
         endif;

         // Get alternate report description from MRPTDES if it exists.
         exec sql select rvdesc into :rptDsc from mrptdes where fldr = :fldr and
           fldrlb = :fldrlb and filnam = :filnam and jobnam = :jobnam and
           usrnam = :usrnam and jobnum = :jobnum and filnum = :filnum and
           datfop = :datfop;

         // If the alternate report description is not found, use the default
         // from RMAINT.
         if sqlcod <> 0;
           exec sql select rrdesc into :rptDsc from rmaint where
             rtypid = :rpttyp;
         endif;

         // If report description not found in MRPTDES or RMAINT, leave.
         if sqlcod <> 0;
           return;
         endif;

         // If last character of path is not a slash, add one.
         if %subst(path:%len(%trim(path)):1) <> '/';
           path = %trimr(path) + '/';
         endif;

         // Tag report name (description) onto the path + PDF extension.
         path = %trimr(path) + %trim(rptDsc) + '.PDF';

         cmd = 'EXPOBJSPY OBJTYPE(*RPTID) OBJ(' + reportID + ') ' +
           'PATH(' + %trimr(path) + ') STMFFMT(O)';

         return;

       end-proc;

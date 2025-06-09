      *%METADATA                                                       *
      * %TEXT Duplicate reports in MRPTDIR                             *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio);

       dcl-pr main extpgm('DUPRPT');
         reportType char(10);
         nbrOfCopies char(10);
       end-pr;

       dcl-proc main;
         dcl-pi *n;
           reportType char(10);
           nbrOfCopies char(10);
         end-pi;

         dcl-pr system extproc('system');
           command pointer options(*string:*trim) value;
         end-pr;

         dcl-pr getNum extpgm('GETNUM');
           opcode char(6) const;
           opcode char(10) const;
           newID char(10);
         end-pr;

         dcl-ds rptdir extname('MRPTDIR') end-ds;
         dcl-ds rlink extname('RLINK') end-ds;
         dcl-s copies int(10);
         dcl-s i int(10);
         dcl-s lnkfil char(10);
         dcl-s dspMsg char(50) inz('Duplication complete!');

         copies = %int(nbrOfCopies);

         exec sql set option closqlcsr=*endmod,commit=*none;

         // Get first report from mrptdir based on the report type.
         exec sql select * into :rptdir from mrptdir where rpttyp = :reportType
           fetch first 1 row only;
         if sqlcod <> 0;
           dspMsg = 'Error retrieving report type';
           exsr quit;
         endif;

         // Get the link file name for duplicating links.
         exec sql select lnkfil into :lnkfil from rlnkdef where lrnam = :filnam
           and ljnam = :jobnam and lpnam = :pgmopf and lunam = :usrnam and
           ludat = :usrdta;
         if sqlcod <> 0;
           dspMsg = 'Error retrieving link file name.';
           exsr quit;
         endif;

         // Retrieve one link record (report must already exist in repository)
         // as a template.
         system('ovrdbf rlink ' + lnkfil + ' ovrscope(*job)');
         exec sql select * into :rlink from rlink fetch first 1 row only;
         if sqlcod <> 0;
           dspMsg = 'Error fetching link record for template.';
           exsr quit;
         endif;

         // Duplicate the report and links. Get new spy#. Everything else
         // remains the same. Write record to mrptdir and to link file.
         for i = 1 to copies;
           getNum('GET':'REPIND':repInd);
           exec sql insert into mrptdir values(:rptdir);
           if sqlcod <> 0;
             dspMsg = 'Error inserting report directory record.';
             exsr quit;
           endif;
           // Insert the corresponding doclink.
           ldxnam = repInd;
           exec sql insert into rlink values(:rlink);
           if sqlcod <> 0;
             dspmsg = 'Error insert link record.';
             exsr quit;
           endif;
         endfor;

         exsr quit;

       //********************************************************************
       begsr quit;
         system('dltovr rlink lvl(*job)');
         getNum('QUIT':'REPIND':repInd);
         dsply dspMsg;
         return;
       endsr;

       end-proc;

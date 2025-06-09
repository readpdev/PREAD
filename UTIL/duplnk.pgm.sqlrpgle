         // *NOTE* The DocLink file '@' file must exist and contain at least
         //        one link record prior to running this utility.

       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio);

       dcl-pr main extpgm('DUPLNK');
         reportType char(10);
         nbrOfCopies char(10);
       end-pr;

       dcl-proc main;
         dcl-pi *n;
           reportType char(10);
           nbrOfCopies char(10);
         end-pi;

         dcl-ds rlnkdef extname('RLNKDEF') end-ds;
         dcl-ds rptdir extname('MRPTDIR') end-ds;
         dcl-s copies int(10);
         dcl-s i int(10);

         exec sql set option closqlcsr=*endmod,commit=*none;

         copies = %int(nbrOfCopies);

         // Get the big5 key from the first MRPTDIR report record.
         exec sql select * into :rptdir from mrptdir where
           fetch first 1 row only;

         // Fetch the name of the index file for the passed report type.
         exec sql select * into :rlnkdef from rlnkdef where lrnam = :rrnam and
           ljnam = : and lpnam = : and lunam = : and ludat = :;

         // Duplicate the report (no links). Get new spy#. Everything else
         // remains the same. Write record to mrptdir.
         for i = 1 to copies;
           getNum('GET':'REPIND':repInd);
           exec sql insert into mrptdir values(:rptdir);
           if sqlcod <> 0;
             leave;
           endif;
         endfor;

         getNum('QUIT':'REPIND':repInd);

         return;

       end-proc;

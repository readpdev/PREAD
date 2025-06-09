      /copy directives
      //
J6381 // 02-17-17 PLR Created. Returns the number of hits based on search
      //              criteria passed from EXPOBJSPY.
      //

      /copy @memio

       exec sql set option commit=*none;

       //********************************************************************
       dcl-proc getHitCount export;
         dcl-pi *n uns(10);
           objectType char(10) const;
           objectName char(10) const;
           criteriaIn char(900) const;
         end-pi;

         dcl-ds criteriaHdr qualified based(criteriaHdrP);
           nbrOfEntries uns(5);
           offset uns(5) dim(MAXHITS);
         end-ds;

         dcl-ds searchCrit qualified dim(MAXHITS);
           nbrVals uns(5); // Reused by this app for index order.
           indexName char(9);
           compVal char(4);
           indexValue char(99);
         end-ds;

         dcl-ds big5 qualified;
           report char(10);
           job char(10);
           program char(10);
           user char(10);
           userData char(10);
         end-ds;

         // Dates come in as CYYMMDD format.
         dcl-ds dateRange qualified based(dateRangeP);
           nbrOfValues uns(5);
           fDate char(7);
           tdate char(7);
         end-ds;

         dcl-s criteria like(criteriaIn);
         dcl-s i int(10);
         dcl-s hitCount uns(10) inz;
         dcl-c MAXHITS 7;
         dcl-ds rlnkdef extname('RLNKDEF');

         // Parse the search criteria index values.
         criteria = criteriaIn;
         criteriaHdrP = %addr(criteria);
         for i = 1 to criteriaHdr.nbrOfEntries;
           memcpy(%addr(searchCrit(i)):criteriaHdrP + criteriaHdr.offset(i):
             %len(searchCrit(i)));
         endfor;

         // Parse the date range...if any.
         dateRangeP = criteriaHdrP + criteriaHdr.offset(1)+%len(searchCrit(1));

         // Get the big5 key from rmaint. Used for getting index info.
         exec sql select rrnam,rjnam,rpnam,runam,rudat into :big5 from rmaint
           where rtypid = :objName;
         if sqlcod <> 0;
           return 0; // No rmaint record/error. Return 0 hit count.
         endif;

         // Get the the link file name and ordinal index names.
         exec sql select * into :rlnkdef from rlnkdef where
           lrnam = :big5.report and ljnam = :big5.job and
           lpnam = :big5.program and lunam = :big5.user and
           ludat = :big5.userData;
         if sqlcod <> 0;
           return 0; // No rlnkdef record/error. Return 0 hit count.
         endif;

         // Map criteria index names to lxiv fields/order.
         for i = 1 to criteriaHdr.nbrOfEntries;

         endfor;

         return hitCount;

       end-proc;

      *%METADATA                                                       *
      * %TEXT Returns hit count for DocLink or OmniLink                *
      *%EMETADATA                                                      *
      /copy directives
      //
J6381 // 02-17-17 PLR Created. Returns the number of hits based on search
      //              criteria passed from EXPOBJSPY.
      //

      /copy @memio

       dcl-ds criteriaHdr qualified based(criteriaHdrP);
         nbrOfEntries uns(5);
         offset uns(5) dim(MAXHITS);
       end-ds;

       // Dates come in as CYYMMDD format.
       dcl-ds dateRange qualified based(dateRangeP);
         nbrOfValues uns(5);
         fDate char(7);
         tdate char(7);
       end-ds;

       // Search criteria.
       dcl-ds searchCrit qualified dim(MAXHITS);
         nbrVals uns(5); // Reused by this app for index order.
         indexName char(9);
         compVal char(4);
         indexValue char(99);
       end-ds;

       dcl-c MAXHITS 7;
       dcl-c MAXEXPOBJ 4000000; // Maximum export objects: 4M hits.
       dcl-s indexNameA char(10) dim(MAXHITS) based(indexNameP);
       dcl-s sqlStmt char(1024);
       dcl-s whereClaws char(1024);
       dcl-c SQ '''';

       exec sql set option commit=*none;

       //********************************************************************
       dcl-proc getHitCount export;
         dcl-pi *n uns(10);
           objectType char(10) const;
           objectName char(10) const;
           criteriaIn char(900) const;
         end-pi;

         dcl-s criteria like(criteriaIn);
         dcl-s i int(10);
         dcl-s hitCount uns(20) inz;

         // Parse the search criteria index values.
         criteria = criteriaIn;
         criteriaHdrP = %addr(criteria);
         for i = 1 to criteriaHdr.nbrOfEntries;
           memcpy(%addr(searchCrit(i)):criteriaHdrP + criteriaHdr.offset(i):
             %len(searchCrit(i)));
         endfor;

         // Parse the date range...if any.
         if criteriaHdr.nbrOfEntries = 0;
           dateRangeP = criteriaHdrP + criteriaHdr.offset(1);
         else;
           dateRangeP = criteriaHdrP + criteriaHdr.offset(1) +
             %len(searchCrit(1));
         endif;

         select;
           when objectType = '*OMNILINK';
             hitCount = getOmniLinkCount(objectName);
           when objectType = '*SPYLINK';
             hitCount = getDocLinkCount(objectName);
           when objectType = '*REPORT';
             hitCount = getReportCount(objectName);
         endsl;

         return hitCount;

       end-proc;

       //********************************************************************
       dcl-proc getDocLinkCount;
         dcl-pi *n uns(20);
           objectName char(10) const;
         end-pi;

         dcl-ds big5 qualified;
           report char(10);
           job char(10);
           program char(10);
           user char(10);
           userData char(10);
         end-ds;

         dcl-ds rlnkdef extname('RLNKDEF') end-ds;

         dcl-s linkHitCount uns(20) inz;
         dcl-s i int(10);

         // Get the big5 key from rmaint. Used for getting index info.
         big5 = getBig5byDocType(objectName);

         // Get the the link file name and ordinal index names.
         exec sql select * into :rlnkdef from rlnkdef where
           lrnam = :big5.report and ljnam = :big5.job and
           lpnam = :big5.program and lunam = :big5.user and
           ludat = :big5.userData;
         if sqlcod <> 0;
           return 0; // No rlnkdef record/error. Return 0 hit count.
         endif;

         // Map criteria index names to lxiv fields/order.
         indexNameP = %addr(lndxn1);
         for i = 1 to criteriaHdr.nbrOfEntries;
           searchCrit(i).nbrVals = %lookup('@'+searchCrit(i).indexName:
             indexNameA);
         endfor;

         // Build the SQL statement based on the criteria.
         sqlStmt = 'select count(*) from ' + lnkfil;
         for i = 1 to criteriaHdr.nbrOfEntries;
           if whereClaws <> ' ';
             whereClaws = %trimr(whereClaws) + ' and';
           endif;
           whereClaws = %trimr(whereClaws) +
             ' trim(lxiv' + %trim(%char(searchCrit(i).nbrVals)) + ') = ' +
             sq + %trim(searchCrit(i).indexValue) + sq;
         endfor;
         // Date range.
         if dateRange.fdate > *all'0';
           if whereClaws <> ' ';
             whereClaws = %trimr(whereClaws) + ' and';
           endif;
           whereClaws = %trimr(whereClaws) + ' lxiv8 >= ' +
             %char(%date(dateRange.fdate:*cymd0):*iso0);
         endif;
         if dateRange.tdate > *all'0';
           if whereClaws <> ' ';
             whereClaws = %trimr(whereClaws) + ' and';
           endif;
           whereClaws = %trimr(whereClaws) + ' lxiv8 <= ' +
             %char(%date(dateRange.tdate:*cymd0):*iso0);
         endif;
         if whereClaws <> ' ';
           sqlStmt = %trimr(sqlStmt) + ' where ' + whereClaws;
         endif;
         sqlStmt = %trimr(sqlStmt) + ' for read only';

         exec sql prepare stmt from :sqlStmt;
         exec sql declare c1 cursor for stmt;
         exec sql open c1;
         exec sql fetch from c1 into :linkHitCount;
         exec sql close c1;

         return linkHitCount;

       end-proc;

       //********************************************************************
       dcl-proc getOmniLinkCount;
         dcl-pi *n uns(20);
           objectName char(10) const;
         end-pi;

         // Largest combination of OmniLink and DocLink index mappings.
         dcl-ds mapList qualified;
           rpt_nam char(10);
           rpt_job char(10);
           rpt_pgm char(10);
           rpt_usr char(10);
           rpt_dat char(10);
           omnNdx char(10);
           docNdx char(10);
         end-ds;

         dcl-ds omniSearchCrit likeds(searchCrit) dim(%elem(searchCrit)) inz;

         dcl-s hitCount uns(20) inz;
         dcl-s i int(10) inz;
         dcl-s lastBig5 char(50);
         dcl-s omniLookup int(10);

         // Store the OmniLink search criteria so that the searchCrit
         // structure can be utilized by the DocLink search procedure.
         reset omniSearchCrit;
         omniSearchCrit = searchCrit;
         reset searchCrit;

         // Get OmniLink-to-report-index mapping.
         // X'FE' in the first position of the dinam indicates no mapping
         // between the omnilink and doclink.
         clear mapList;
         exec sql declare c2 cursor for
           select drnam,djnam,dpnam,dunam,dudat,dinam,drina
           from drptidxd where dhnam = :objectName and left(dinam,1) <> x'FE'
           order by drnam, djnam, dpnam, dunam, dudat for read only;

         exec sql open c2;
         exec sql fetch c2 into :mapList;

         i = 0;
         dow sqlcod = 0;
           if lastBig5 <> ' ' and
             lastBig5 <> %subst(mapList:1:%size(lastBig5));
             hitCount += getDocLinkCount(getDocTypeByBig5(lastBig5));
             if hitCount > MAXEXPOBJ;
               leave;
             endif;
             i = 0;
             reset searchCrit;
           endif;
           lastBig5 = mapList;
           i += 1;
           searchCrit(i).indexName = %subst(mapList.docNdx:2:9);
           omniLookup =  %lookup(%subst(mapList.omnNdx:2:9):
             omniSearchCrit(*).indexName);
           if omniLookup > 0;
             searchCrit(i).indexValue = omniSearchCrit(omniLookup).indexValue;
           endif;
           exec sql fetch c2 into :mapList;
         enddo;

         exec sql close c2;

         // Need to do either the one and only hit class or the last.
         if hitCount < MAXEXPOBJ;
           hitCount += getDocLinkCount(getDocTypeByBig5(lastBig5));
         endif;

         return hitCount;

       end-proc;

       //********************************************************************
       dcl-proc getDocTypeByBig5;
         dcl-pi *n char(10);
           big5In char(50) const;
         end-pi;

         dcl-ds big5 qualified;
           report char(10);
           job char(10);
           program char(10);
           user char(10);
           userData char(10);
         end-ds;

         dcl-s rtypid char(10) inz;

         big5 = big5In;

         exec sql select rtypid into :rtypid from rmaint where
           rrnam = :big5.report and rjnam = :big5.job and rpnam = :big5.program
           and runam = :big5.user and rudat = :big5.userData;

         return rtypid;

       end-proc;

       //********************************************************************
       dcl-proc getBig5byDocType;
         dcl-pi *n likeds(big5);
           objectName char(10) const;
         end-pi;

         dcl-ds big5 qualified;
           report char(10);
           job char(10);
           program char(10);
           user char(10);
           userData char(10);
         end-ds;

         exec sql select rrnam,rjnam,rpnam,runam,rudat into :big5 from rmaint
           where rtypid = :objectName;

         return big5;

       end-proc;

       //********************************************************************
       // Only works for text reports NOT image classes.
       dcl-proc getReportCount;
         dcl-pi *n uns(20);
           objectName char(10) const;
         end-pi;

         dcl-s hitCount uns(20) inz;

         sqlStmt = 'select count(*) from mrptdir where rpttyp = ' +
           sq + %trimr(objectName) + sq;

         if dateRange.fdate > *all'0';
           sqlStmt = %trimr(sqlStmt) + ' and mdatop >= ' + dateRange.fdate;
         endif;
         if dateRange.tdate > *all'0';
           sqlStmt = %trimr(sqlStmt) + ' and mdatop <= ' + dateRange.tdate;
         endif;

         exec sql prepare stmt3 from :sqlStmt;
         exec sql declare c3 cursor for stmt3;
         exec sql open c3;
         exec sql fetch from c3 into :hitCount;
         exec sql close c3;

         return hitCount;

       end-proc;


       //***********************************************************************
       dcl-proc doProcessing;
         dcl-pi *n;
           omniLink char(10);
         end-pi;

         dcl-pr sprintf int(10) extproc('sprintf');
           target pointer value options(*string);
           source pointer value options(*string);
           value1 pointer value options(*string:*nopass);
           value2 pointer value options(*string:*nopass);
           value3 pointer value options(*string:*nopass);
           value4 pointer value options(*string:*nopass);
           value5 pointer value options(*string:*nopass);
           value6 pointer value options(*string:*nopass);
           value7 pointer value options(*string:*nopass);
           value8 pointer value options(*string:*nopass);
           value9 pointer value options(*string:*nopass);
           valueA pointer value options(*string:*nopass);
           valueB pointer value options(*string:*nopass);
           valueC pointer value options(*string:*nopass);
           valueD pointer value options(*string:*nopass);
           valueE pointer value options(*string:*nopass);
           valueF pointer value options(*string:*nopass);
           valueG pointer value options(*string:*nopass);
           valueH pointer value options(*string:*nopass);
           valueI pointer value options(*string:*nopass);
           valueJ pointer value options(*string:*nopass);
           valueK pointer value options(*string:*nopass);
         end-pr;

         dcl-ds mapList dim(125) qualified;
           rpt_nam char(10);
           rpt_job char(10);
           rpt_pgm char(10);
           rpt_usr char(10);
           rpt_dat char(10);
           omnNdx char(10);
           docNdx char(10);
         end-ds;

         dcl-s i int(10);
         dcl-s ordNdx int(10);
         dcl-ds docClsNdx qualified;
           lnkFil char(10);
           ndxNam1 char(10);
           ndxNam2 char(10);
           ndxNam3 char(10);
           ndxNam4 char(10);
           ndxNam5 char(10);
           ndxNam6 char(10);
           ndxNam7 char(10);
         end-ds;
         dcl-s inpClsNdx char(10);
         dcl-ds rmaintBig5;
           rrnam char(10);
           rjnam char(10);
           rpnam char(10);
           runam char(10);
           rudat char(10);
           rtypid char(10);
         end-ds;

         dcl-ds link qualified;
           id char(10);
           seq int(10);
           ndx1 char(99);
           ndx2 char(99);
           ndx3 char(99);
           ndx4 char(99);
           ndx5 char(99);
           ndx6 char(99);
           ndx7 char(99);
           ndx8 char(8);
         end-ds;

         dcl-s linkA char(99) dim(7) based(linkAp);
         dcl-ds ordNdxDS dim(7) qualified based(ordNdxP);
           name char(10);
         end-ds;

         dcl-s omnLnkNam char(10);
         dcl-s rptType char(10);
         dcl-s imgfil char(10);
         dcl-s cmd char(512);
         dcl-s thisJob char(26);
         dcl-s apiStr char(256);
         dcl-s statusVal char(10);
         dcl-s dltCtlFld char(99);
         dcl-s deleteDate char(10);
         dcl-s errorFlag ind inz(*off);
         dcl-s notfound ind;

         linkAp = %addr(link.ndx1);

         // Update the config record with the running job info.
         thisJob = jobNam + user + jobNbr;
         exec sql update bpomndef set dc_job = :thisJob
           where dc_omni = :omniLink;

         // Get the field maps for OmniLink to report index.
         clear mapList;
         exec sql declare c2 cursor for
           select drnam,djnam,dpnam,dunam,dudat,dinam,drina
           from drptidxd where dhnam = :omniLink and dinam = :omnLnkNam
           for read only;
         exec sql open c2;
         exec sql fetch c2 for 125 rows into :mapList;
         exec sql close c2;

         // Get the index file for the input class.
         exec sql select rrnam,rjnam,rpnam,runam,rudat,rtypid into :rmaintBig5
           from rmaint where rtypid = :inputClass;
         exec sql select lnkfil into :inpClsNdx from rlnkdef where lrnam=:rrnam
           and ljnam=:rjnam and lpnam=:rpnam and lunam=:runam and ludat=:rudat;

         sqlStmt = 'select distinct lxiv1 from ' + %trimr(inpClsNdx) +
           ' where lxiv2 in (' + sq + ' ' + sq + ',' + sq + '*DELETECHK' + sq +
           ',' + sq + '*ERROR' + sq + ') for read only';

         exec sql prepare stmt3 from :sqlStmt;
         exec sql declare c3 cursor for stmt3;
         exec sql open c3;
         exec sql fetch c3 into :dltCtlFld;

         dow sqlcod = OK;  // Input class

           // If the input link value is not found by the end of processing
           // all doclinks defined to the OmniLink, update the input record's
           // lxiv2 with *NOTFOUND. Will prevent this record from being picked
           // up during subsequent runs.
           notFound = *on;

           // For loop for each doclink class defined to the omnilink.
           for i = 1 to %elem(mapList);

             if mapList(i).omnNdx = ' ';
               leave;
             endif;

             // Get the index file for the omniLink defined document.
             rmaintBig5 = mapList(i);
             exec sql select lnkfil,lndxn1,lndxn2,lndxn3,lndxn4,lndxn5,lndxn6,
               lndxn7 into :docClsNdx from rlnkdef where
               lrnam=:rrnam and ljnam=:rjnam and lpnam=:rpnam and lunam=:runam
               and ludat=:rudat;

             // Determine the ordinal index for the document index.
             // Used for mapping to SPYAPICMD.
             ordNdxP = %addr(docClsNdx.ndxNam1);
             for ordNdx = 1 to %elem(ordNdxDS);
               if ordNdxDS(ordNdx).name = mapList(i).docNdx;
                 leave;
               endif;
             endfor;

             // Select the index values matching the input index (lxiv1) value.
             sqlStmt = 'select distinct ldxnam,lxseq,lxiv1,lxiv2,lxiv3,lxiv4,' +
               'lxiv5,lxiv6,lxiv7,lxiv8 from ' + %trimr(docClsNdx.lnkfil) +
               ' where trim(lxiv' + %trim(%char(ordNdx)) + ') = ' +
               sq + %trim(dltCtlFld) + sq + ' for read only';
             exec sql prepare stmt4 from :sqlStmt;
             exec sql declare c4 cursor for stmt4;
             exec sql open c4;
             exec sql fetch c4 into :link;

             dow sqlcod = OK;
               notFound = *off;
               // Build SPYAPICMD string.
               apiStr = %trimr(apiCmdA(1)) + ' ' + %trimr(apiCmdA(2)) + ' ' +
                 %trimr(apiCmdA(3));
               select;
               when %subst(link.id:1:1) = 'S'; // Report document.
                 clear imgfil;
                 exec sql select filnam,jobnam,pgmopf,usrnam,usrdta,rpttyp into
                   :rmaintbig5 from mrptdir where repind = :link.id;
                   rptType = rtypid;
                 sprintf(%addr(cmd):apiStr:%trim(runmode):
                   rrnam:rjnam:rpnam:runam:rudat:
                   sq + %trimr(link.ndx1) + sq:sq + %trimr(link.ndx2) + sq:
                   sq + %trimr(link.ndx3) + sq:sq + %trimr(link.ndx4) + sq:
                   sq + %trimr(link.ndx5) + sq:sq + %trimr(link.ndx6) + sq:
                   sq + %trimr(link.ndx7) + sq:link.ndx8:link.ndx8);
               when %subst(link.id:1:1) = 'B'; //Image document.
                 exec sql select iddoct,idpfil into :rptType,:imgfil
                   from mimgdir where idbnum = :link.id;
                 sprintf(%addr(cmd):apiStr:%trim(runmode):rptType:' ':' ':' ':
                   ' ':sq + %trimr(link.ndx1) + sq:sq + %trimr(link.ndx2) + sq:
                   sq + %trimr(link.ndx3) + sq:sq + %trimr(link.ndx4) + sq:
                   sq + %trimr(link.ndx5) + sq:sq + %trimr(link.ndx6) + sq:
                   sq + %trimr(link.ndx7) + sq:link.ndx8:link.ndx8);
               endsl;

               // Call SPYAPICMD
               system(cmd);

               // Delete generated report from SPYAPICMD.
               system('dltsplf DOCAPIDLT');

               // Verify deletion of docLink
               select;
               when runmode = '*DELETECHK';
                 deleteDate = runmode;
               when runmode = '*DELETE';
                 deleteDate = verifyDelete(docClsNdx.lnkfil:link);
                 if deleteDate = '*ERROR';
                   errorFlag = *on;
                 endif;
               endsl;

               // Update index 2 of the input class index file.
               statusVal = runMode;
               if statusVal <> '*DELETECHK';
                 if errorFlag;
                   errorFlag = *off;
                   statusError = *on;
                   statusVal = '*ERROR';
                 else;
                   statusVal = %char(%date():*iso0);
                 endif;
               endif;
               sqlStmt = 'update ' + %trimr(inpClsNdx) + ' set lxiv2 = ' +
                 sq + %trimr(statusVal) + sq + ' where trim(lxiv1) = ' +
                 sq + %trim(dltCtlFld) + sq;
               exec sql execute immediate :sqlStmt;

               // Stop requested.
               if getJobSts(omniLink:' ') = '*STOP_RQST';
                 setJobSts(omniLink:'*STOPPED');
                 exec sql close c3;
                 exec sql close c4;
                 leave;
               endif;

               if getJobSts(omniLink:' ') = '*STOP_RQST';
                 leave;
               endif;

               exec sql fetch c4 into :link;

             enddo;

             exec sql close c4;

             if getJobSts(omniLink:' ') = '*STOP_RQST';
               leave;
             endif;

           endfor;

           // No records found for input index value in any of the doclink
           // classes defined to the omnilink.
           // Set lxiv2 to *NOTFOUND
           if notFound;
             sqlStmt = 'update ' + %trimr(inpClsNdx) + ' set lxiv2 = ' +
               sq + '*NOTFOUND' + sq + ' where trim(lxiv1) = ' +
               sq + %trim(dltCtlFld) + sq;
             exec sql execute immediate :sqlStmt;
           endif;

           if getJobSts(omniLink:' ') = '*STOP_RQST';
             leave;
           endif;

           exec sql fetch c3 into :dltCtlFld;

         enddo;

         exec sql close c3;

         if getJobSts(omniLink:' ') = '*STOP_RQST';
           setJobSts(omniLink:'*STOPPED');
         else;
           setJobSts(omniLink:'*COMPLETED');
         endif;
         if statusError;
           setJobSts(omniLink:'*ERROR');
         endif;

         return;

       end-proc;

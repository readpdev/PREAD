       ctl-opt main(main) dftactgrp(*no) actgrp(*new) bnddir('BPDLTCTL');

       dcl-f bpdltctld workstn sfile(cfgsfl:rrn1) indds(indds) usropn;

      /include bputilityh

       dcl-c CREATED 1;
       dcl-c NOT_FOUND -1;

       dcl-s apiCmdA char(80) dim(3) ctdata;

       dcl-ds omniDef extname('BPOMNDEF');
       end-ds;

       dcl-ds bpdltcfg_da;
         bpdltcfg char(1024) dtaara;
         license char(16) overlay(bpdltcfg);
         build char(4) overlay(bpdltcfg:*next);
         jobdnam char(10) overlay(bpdltcfg:*next);
         jobdlib char(10) overlay(bpdltcfg:*next);
         inputClass char(10) overlay(bpdltcfg:*next);
         runmode char(10) overlay(bpdltcfg:*next);
       end-ds;

       dcl-ds indds;
         exit ind pos(3);
         prompt ind pos(4);
         refresh ind pos(5);
         addCfg ind pos(6);
         cfg_key ind pos(7);
         cancel ind pos(12);
         sfldsp ind pos(25);
         sfldlt ind pos(26);
       end-ds;

       dcl-pr main extpgm('BPDLTCTL');
         operation char(10);
         omniLinkName char(10);
       end-pr;

       dcl-s chkObjRtn int(10);
       dcl-s sqlStmt char(1024);
       dcl-c sq '''';
       dcl-s statusError ind inz(*off);

       //***********************************************************************
       dcl-proc main;
         dcl-pi *n;
           operation char(10);
           omniLinkName char(10);
         end-pi;

         exec sql set option commit=*none;

         system('addlible ' + pgmlib);

         pgmq = '*';

         select;
         when operation = '*CONFIG';
           doConfig();
         when operation = '*START';
           doStart(omniLinkName);
         when operation = '*STOP';
           doStop(omniLinkName);
         endsl;

       end-proc; //main

       //***********************************************************************
       dcl-proc doConfig;

         if not %open(bpdltctld);
           open bpdltctld;
         endif;

         chkobj('BPDLTCFG':pgmlib:'*DTAARA':chkObjRtn);
         if chkObjRtn = NOT_FOUND;
           system('crtdtaara ' + %trimr(pgmlib) + '/bpdltcfg *char 1024');
         endif;

         loadSubfile();

         dow not exit and not cancel;
           write fkey;
           write msgctl;
           unlock(e) bpdltcfg;
           in(e) *lock bpdltcfg;
           exfmt cfgctl;
           rmvmsg(1);
           select;
             when exit or cancel;
             when refresh;
               loadSubfile();
             when addCfg;
               doAddCfg();
               loadSubfile();
             when cfg_key;
               doLicense();
             other;
               out(e) *lock bpdltcfg;
               unlock(e) bpdltcfg;
               if chkCfgObj(inputClass:'*RPTTYP') <> OK;
                iter;
               endif;
               if sfldsp = *off;
                 iter;
               endif;
               readc cfgsfl;
               dow not %eof and not exit and not cancel;
                 select;
                 when dspopt = '1'; //Start
                   doStart(dc_omni);
                   loadsubfile();
                 when dspopt = '2'; //Stop
                   doStop(dc_omni);
                   loadsubfile();
                 when dspopt = '3';
                   displayOmniLink(dc_omni);
                 when dspopt = '4';
                   exec sql delete from bpomndef where dc_omni = :dc_omni and
                     dc_omnndx = :dc_omnndx;
                   if sqlcod = OK;
                     sndmsg('Definition deleted':1);
                     loadSubfile();
                     if not sfldsp;
                       leave;
                     endif;
                   else;
                     sndmsg('Error deleting definition':1);
                   endif;
                 when dspopt = '5';
                   wrkjob(dc_omni:dc_job);
                 other;
                   leave;
                 endsl;
                 readc cfgsfl;
               enddo;
             cancel = *off;
           endsl;
         enddo;

         if %open(bpdltctld);
           close bpdltctld;
         endif;

         unlock(e) bpdltcfg;

         return;

       end-proc;

       //***********************************************************************
       dcl-proc doStart;
         dcl-pi *n;
           omniLink char(10);
         end-pi;

         dcl-s jobTypeC char(1);
         dcl-s sbmJobCmd char(1024);
         dcl-s msg char(80);

         in(e) bpdltcfg;

         if validateKey(license:'BPDLTCTL') <> OK;
           sndmsg('Invalid license! Ending':2);
           return;
         endif;

         jobType(jobTypeC);

         if jobTypeC = '1' and jobdnam <> '*DEBUG';
           sbmJobCmd = 'SBMJOB CMD(BPDLTCTL OPCODE(*START) OMNILNK(' +
             %trimr(omniLink) + ')) JOB(' + %trimr(omniLink) + ')';
           if jobdnam <> ' ' and jobdlib <> ' ';
             sbmJobCmd = %trimr(sbmJobCmd) +
             ' JOBd(' + %trimr(jobdLib) + '/' + %trimr(JOBDNAM) + ')';
           endif;
           system(sbmJobCmd);
           setJobSts(omniLink:'*SUBMITTED');
           return;
         endif;

         doProcessing(omniLink);

         return;

       end-proc;

       //***********************************************************************
       dcl-proc doStop;
         dcl-pi *n;
           omniLink char(10);
         end-pi;

         exec sql update bpomndef set dc_sts = '*STOP_RQST' where dc_omni =
           :omniLink;

         return;

       end-proc;

       //***********************************************************************
       dcl-proc displayOmniLink;
         dcl-pi *n;
           omniLink char(10);
         end-pi;
         system('omnilnk ' + omniLink);
         return;
       end-proc;

       //***********************************************************************
       dcl-proc loadSubfile;

         sfldsp = *off;
         sfldlt = *on;
         rrn1 = 0;
         write cfgctl;
         sfldlt = *off;

         if checkFile() = CREATED;
           return;
         endif;

         dow readOmniDef() = OK;
           rrn1 += 1;
           dc_sts = getJobSts(dc_omni:dc_job);
           write cfgsfl;
         enddo;

         if rrn1 > 0;
           rrn1 = 1;
           sfldsp = *on;
         endif;

       end-proc;

       //***********************************************************************
       dcl-proc checkFile;
         dcl-pi *n int(10);
         end-pi;

         chkobj('BPOMNDEF':pgmlib:'*FILE':chkObjRtn);
         if chkObjRtn = NOT_FOUND;
           sqlStmt = 'CREATE TABLE ' + %trimr(pgmlib) + '/BPOMNDEF ' +
             '(DC_OMNI CHAR (10) NOT NULL WITH DEFAULT, ' +
             'DC_OMNNDX CHAR (10) NOT NULL WITH DEFAULT, ' +
             'DC_JOB CHAR (26) NOT NULL WITH DEFAULT, ' +
             'DC_STS CHAR (10) NOT NULL WITH DEFAULT, ' +
             'UNIQUE (DC_OMNI,DC_OMNNDX))';
           exec sql execute immediate :sqlStmt;
           return CREATED;
         endif;

         return OK;

       end-proc;

       //***********************************************************************
       dcl-proc readOmniDef;
        dcl-pi *n int(10);
        end-pi;

        dcl-s firstTime ind inz(*on) static;
        dcl-s rc int(10) inz(OK);

        if firstTime;
          firstTime = *off;
          exec sql declare c1 cursor for select * from bpomndef;
          exec sql open c1;
        endif;

        if sqlcod = OK;
          exec sql fetch from c1 into :omniDef;
        endif;

        if sqlcod <> OK;
          rc = sqlcod;
          exec sql close c1;
          firstTime = *on;
        endif;

        return rc;

       end-proc;

       //***********************************************************************
       dcl-proc doLicense;

         dcl-pr cvthc extproc('cvthc');
           tgt pointer value;
           src pointer value;
           tgtlen int(10) value;
         end-pr;

         dcl-pr cvtch extproc('cvtch');
           tgt pointer value;
           src pointer value;
           srclen int(10) value;
         end-pr;

         unlock bpdltcfg;
         in(e) *lock bpdltcfg;
         srlnbr = rtvsysval('QSRLNBR');
         write keycode;
         rmvmsg(1);
         if license <> ' ';
           cvthc(%addr(licChar):%addr(license):%len(licChar));
         endif;
         if runmode <> '*DELETE' and runmode <> '*DELETECHK';
           runmode = '*DELETECHK';
         endif;
         if jobdnam = ' ';
           jobdnam = '*USRPRF';
           jobdlib = ' ';
         endif;

         dow not exit and not cancel;
           write msgctl;
           exfmt keycode;
           rmvmsg(1);
           select;
             when exit or cancel;
             when refresh;
               unlock bpdltcfg;
               in(e) *lock bpdltcfg;
             other;
               if licChar <> ' ';
                 monitor;
                 cvtch(%addr(license):%addr(licChar):%len(licChar));
                 on-error;
                 endmon;
               endif;
               if validateKey(license:'BPDLTCTL') = OK;
                 sndmsg('Configuration validated':1);
               endif;
               out(e) bpdltcfg;
           endsl;
         enddo;

         unlock bpdltcfg;
         cancel = *off;

         return;

       end-proc;

       //***********************************************************************
       dcl-proc doAddCfg;

         dcl-pr workOmniLink extpgm('WRKHYPLNK');
           omniLinkName char(10);
         end-pr;

         rmvmsg(2);
         dow not exit and not cancel;
           rmvmsg(2);
           write msgctl;
           exfmt addconfig;
           select;
           when exit or cancel;
           when prompt;
             workOmniLink(dc_omni);
           other;
             if chkCfgObj(dc_omni:'*OMNLNK') <> OK or
               chkCfgObj(dc_omnndx:'*OMNNDX') <> OK;
               iter;
             endif;
             exec sql insert into bpomndef values(:dc_omni,:dc_omnndx,' ',' ');
             if sqlcod = OK;
               sndmsg('Configuration added':1);
             else;
               sndmsg('Error adding configuration. See job log':1);
             endif;
           endsl;
         enddo;

         cancel = *off;

         return;

       end-proc;

       //***********************************************************************
       dcl-proc chkCfgObj;
         dcl-pi *n int(10);
           objName char(10) const;
           objType char(10) const;
         end-pi;

         dcl-s rc int(10) inz(OK);
         dcl-s wrkObj char(10);
         dcl-s wrkMsg char(80);

         select;
         when objType = '*OMNLNK';
           exec sql select ahnam into :wrkObj from ahyplnkd where
             ahnam = :objName;
           wrkMsg = 'OmniLink invalid';
         when objType = '*OMNNDX';
           wrkObj = '@' + objName;
           exec sql select cinam into :wrkObj from chypidxd where
             chnam = :dc_omni and cinam = :wrkObj;
           wrkMsg = 'Omni Index invalid';
         when objType = '*RPTTYP';
           exec sql select rtypid into :wrkObj from rmaint where
             rtypid = :objName;
           wrkMsg = 'Input class invalid';
         endsl;

         if sqlcod <> OK;
           sndmsg(wrkMsg:2);
           rc = NOT_FOUND;
         endif;

         return rc;

       end-proc;

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

         // Get the omnilink index defined in BPOMNDEF
         exec sql select dc_omnndx into :omnLnkNam from bpomndef where
           dc_omni = :omniLink;
         omnLnkNam = '@' + omnLnkNam;

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

       //***********************************************************************
       dcl-proc getJobSts;
         dcl-pi *n char(10);
           omnInp char(10);
           jobInp char(26) const;
         end-pi;

         dcl-pr qusrjobi extpgm('QUSRJOBI');
           jobDS likeds(qusrjobiDS) const;
           joblen like(qusrjoblen) const;
           format char(8) const;
           qualJob char(26) const;
           intJobID char(16) const;
           error likeds(qusec);
         end-pr;

         dcl-ds qusrjobiDS;
           allocated char(86);
           status char(10) pos(51);
         end-ds;
         dcl-s qusrjoblen int(10) inz(%size(qusrjobiDS));

         dcl-s rtnSts char(10);

         exec sql select dc_sts into :rtnSts from bpomndef where dc_omni =
           :omnInp;

         if jobInp <> ' ' and %subst(rtnSts:1:5) <> '*STOP' and
           rtnSts <> '*COMPLETED' and rtnSts <> '*ERROR';
           qusrjobi(qusrjobids:qusrjoblen:'JOBI0100':jobInp:' ':qusec);
           rtnSts = status;
           setJobSts(omnInp:status);
         endif;

         return rtnSts;

       end-proc;

       //*******************************************************************
       dcl-proc setJobSts;
         dcl-pi *n;
           omnInp char(10) const;
           stsInp char(10) value;
         end-pi;

         if stsInp = ' ';
           exec sql update bpomndef set dc_job = ' '
             where dc_omni = :omnInp;
           stsInp = '*INACTIVE';
         endif;
         exec sql update bpomndef set dc_sts = :stsInp
           where dc_omni = :omnInp;

         return;

       end-proc;

       //*******************************************************************
       dcl-proc wrkjob;
         dcl-pi *n;
           omnInp char(10) const;
           jobInp char(26) const;
         end-pi;

         dcl-s wrkJobCmd char(100);
         dcl-ds job qualified;
           name char(10);
           user char(10);
           nbr char(6);
         end-ds;

         wrkJobCmd = 'wrkjob ' + omnInp;
         if jobInp <> ' ';
           job = jobInp;
           wrkJobCmd = 'wrkjob ' + job.nbr + '/' + %trim(job.user) + '/' +
             job.name;
         endif;
         system(wrkJobCmd);

         return;

       end-proc;

       //*******************************************************************
       dcl-proc writeLog;
         dcl-pi *n;
           inClass char(10) const;
           inOmni char(10) const;
           inLnkCls char(10) const;
           inImgFil char(10) const;
           inLnkFil char(10) const;
           inDltDat char(8) const;
           inLink likeds(link) const;
         end-pi;

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

         // Create log file if it doesn't exist.
         chkobj('BPDLTLOG':pgmlib:'*FILE':chkObjRtn);
         if chkObjRtn = NOT_FOUND;
           sqlStmt = 'CREATE TABLE ' + %trimr(pgmlib) + '/BPDLTLOG ' +
             '(RUNMODE CHAR (10) NOT NULL WITH DEFAULT,' +
             'INPUTCLASS CHAR (10) NOT NULL WITH DEFAULT,' +
             'OMNILINK CHAR (10) NOT NULL WITH DEFAULT,' +
             'RPTTYP CHAR (10) NOT NULL WITH DEFAULT,' +
             'IMGFIL CHAR (10) NOT NULL WITH DEFAULT,' +
             'CLSLNKFIL CHAR (10) NOT NULL WITH DEFAULT,' +
             'DELETEDATE CHAR (8) NOT NULL WITH DEFAULT,' +
             'LNKID CHAR (10) NOT NULL WITH DEFAULT, ' +
             'LNKSEQ INT NOT NULL WITH DEFAULT, ' +
             'NDX1 CHAR (99) NOT NULL WITH DEFAULT,' +
             'NDX2 CHAR (99) NOT NULL WITH DEFAULT,' +
             'NDX3 CHAR (99) NOT NULL WITH DEFAULT,' +
             'NDX4 CHAR (99) NOT NULL WITH DEFAULT,' +
             'NDX5 CHAR (99) NOT NULL WITH DEFAULT,' +
             'NDX6 CHAR (99) NOT NULL WITH DEFAULT,' +
             'NDX7 CHAR (99) NOT NULL WITH DEFAULT,' +
             'NDXDATE CHAR(8) NOT NULL WITH DEFAULT)';
           exec sql execute immediate :sqlStmt;
           system('CHGPF FILE(BPDLTLOG) SIZE(*NOMAX)');
         endif;

         exec sql insert into bpdltlog values (:runmode,:inClass,:inOmni,
           :inLnkCls,:inImgFil,:inLnkFil,:inDltDat,:inLink);

         return;

       end-proc;
       //*******************************************************************
       dcl-proc verifyDelete;
         dcl-pi *n char(8);
           inLnkFil char(10) const;
           inLink likeds(link);
         end-pi;

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

         dcl-s returnVal char(8);

         sqlStmt = 'select ldxnam,lxseq,lxiv1,lxiv2,lxiv3,lxiv4,' +
           'lxiv5,lxiv6,lxiv7,lxiv8 from ' + %trimr(inLnkFil) +
           ' where ldxnam = ' + sq + inLink.id + sq +
           ' and lxseq = ' + %trim(%char(inLink.seq)) +
           ' and lxiv1 = ' + sq + %trimr(inLink.ndx1) + sq +
           ' and lxiv2 = ' + sq + %trimr(inLink.ndx2) + sq +
           ' and lxiv3 = ' + sq + %trimr(inLink.ndx3) + sq +
           ' and lxiv4 = ' + sq + %trimr(inLink.ndx4) + sq +
           ' and lxiv5 = ' + sq + %trimr(inLink.ndx5) + sq +
           ' and lxiv6 = ' + sq + %trimr(inLink.ndx6) + sq +
           ' and lxiv7 = ' + sq + %trimr(inLink.ndx7) + sq +
           ' and lxiv8 = ' + sq + inLink.ndx8 + sq +
           ' for read only optimize for 1 rows';

         exec sql prepare stmt5 from :sqlStmt;
         exec sql declare c5 cursor for stmt5;
         exec sql open c5;
         exec sql fetch c5 into :link;

         if sqlcod = 100; // Link not found = deleted by SPYAPICMD.
           returnVal = %subst(%char(%date():*iso0):1:8);
         else;
           returnVal = '*ERROR';
         endif;

         exec sql close c5;

         return returnVal;

       end-proc;
**ctdata apiCmdA
SPYAPICMD OPCODE(%s) FILNAM(%s) JOBNAM(%s) PGMOPF(%s) USRNAM(%s) USRDTA(%s)
FILTER(*YES) IVAL1(%s) IVAL2(%s) IVAL3(%s) IVAL4(%s) IVAL5(%s)
IVAL6(%s) IVAL7(%s) IVAL8(%s) IVAL9(%s)

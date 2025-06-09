      /include directives

      /include mgemlslth
      /include qsysinc/qrpglesrc,qusec

       dcl-f mgemlsltd workstn sfile(emailslts1:rrn1) indds(indds) infds(infds)
         usropn;

       dcl-ds indds;
         exit ind pos(3);
         prompt ind pos(4);
         refresh ind pos(5);
         wrkSubLists ind pos(6);
         wrkSubs ind pos(7);
         clearList ind pos(10);
         cancel ind pos(12);
         sfldsp ind pos(25);
         sfldlt ind pos(26);
       end-ds;

       dcl-ds infds;
         key char(1) pos(369);
       end-ds;

       dcl-ds msgDS_t qualified template;
         id char(7);
         dta char(80);
       end-ds;

       dcl-s pgmq char(10) inz('*');
       dcl-s sqlStmt char(1024);
       dcl-s maxRRN int(10);
       dcl-c lo 'abcdefghijklmnopqrstuvwxyz';
       dcl-c up 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
       dcl-s sqlStmtA char(80) dim(4) ctdata;

       //*******************************************************************
       dcl-proc showEmailList export;
         dcl-pi *n;
           recipientField char(60);
         end-pi;

         exec sql set option commit=*none;

         dcl-ds msgDS likeds(msgDS_t);
         dcl-c ENTER x'F1';
         dcl-s enterCount int(5) inz;
         dcl-s i int(10);

         if not %open(mgemlsltd);
           open mgemlsltd;
         endif;

         exit = *off;
         cancel = *off;
         workFile('CHECK');
         loadsfl();

         // If the selection list changes, clear the selection workfile
         // and then add what is passed in.
         if recipientField <> getRecipientList();
           workFile('CLEAR');
           addEmailEntry(recipientField);
         endif;

         dow not exit and not cancel;

           clear addOpt;
           clear addEmlAddr;
           loadSfl(); // Re-load the subfile...everytime.
           if positionTo <> ' ';
             positionToProc();
           endif;
           clear positionTo;

           // Fetch the last message from the message handler...if any and display.
           msgDS = msgHandler('GET');
           spm(msgDS.id:msgDS.dta);

           // Display control record.
           write fkey;
           write msgctl;
           exfmt emailsltc1;
           rmvMsgs();

           select;
           when exit or cancel;
           when positionTo <> ' ';
           when addOpt = 1 and addEmlAddr <> ' ';
             addEmailEntry(addEmlAddr);
           when refresh;
           when wrkSubs;
             workSubs();
           when wrkSubLists;
             workSubLists();
           when clearList;
             workFile('CLEAR');
           other; // Read subfile selections and place in workfile;
             if selectRecipients() = 1; //List changed.
               enterCount = 0;
               msgHandler('SET':'P040323');
             else;
               enterCount += 1;
             endif;
           endsl;

           if enterCount > 0;
             leave;
           endif;

         enddo;

         clear recipientField;

         if %open(mgemlsltd);
           close mgemlsltd;
         endif;

         return;

       end-proc;

       //*******************************************************************
       dcl-proc getEmailEntry export;
         dcl-pi *n int(10);
           opcode char(10) const;  //*COUNT,*FIRST,*NEXT
           rtnEntry likeds(mailEntry_t) options(*nopass);
         end-pi;

         dcl-s isFirst ind static;
         dcl-s rtnVal int(10) inz(0);
         dcl-ds email qualified;
           id char(10);
           addr char(60);
           type char(1);
         end-ds;

         if opcode = '*COUNT';
           exec sql select count(*) into :rtnVal from mgemlslt;
           return rtnVal;
         endif;

         if opcode = '*FIRST';
           isFirst = *on;
         endif;

         if isFirst;
           workFile('CHECK');
           isFirst = *off;
           exec sql close c2;
           exec sql declare c2 cursor for select subid,addr,type from mgemlslt;
           exec sql open c2;
         endif;

         exec sql fetch c2 into :email;
         if sqlcod = 0; // Error or end of list encountered...close cursor.
           if email.type = 'E';
             rtnEntry.recipient = email.addr;
           else;
             rtnEntry.recipient = email.id;
           endif;
           rtnEntry.type = email.type;
           isFirst = *off;
         else;
           exec sql close c2;
           isFirst = *on;
           rtnVal = -1; // Negative response tells caller to stop.
         endif;

         return rtnVal;

       end-proc;

       //*******************************************************************
       dcl-proc loadSfl;

         dcl-ds subInfo qualified;
           name char(10);
           addrDesc char(128);
           type char(1); // S=subscriber or address, L=Subcriber list
           selected char(1);
         end-ds;

         dcl-s i int(10);

         sfldlt = *on;
         write emailsltc1;
         sfldsp = *off;
         sfldlt = *off;
         rrn1 = 0;

         // Check to see if the qtemp selected addresses work file exists.
         workFile('CHECK');

         clear sqlStmt;
         for i = 1 to %elem(sqlStmtA);
           sqlStmt = %trimr(sqlStmt) + sqlStmtA(i);
         endfor;

         exec sql prepare stmt1 from :sqlStmt;
         exec sql declare c1 cursor for stmt1;
         exec sql open c1;
         exec sql fetch c1 into :subInfo;

         dow sqlcod = 0;
           s1subid = subInfo.name;
           s1emladr = subInfo.addrDesc;
           s1emltyp = subInfo.type;
           s1opt = 0;
           if subInfo.selected <> ' ';
             s1opt = 1;
           endif;
           rrn1 += 1;
           write emailslts1;
           exec sql fetch c1 into :subInfo;
         enddo;

         exec sql close c1;

         if rrn1 > 0;
           maxRRN = rrn1;
           rrn1 = 1;
           sfldsp = *on;
         endif;

         return;

       end-proc;

       //*******************************************************************
       dcl-proc workSubs;
         dcl-pi *n;

         end-pi;

         dcl-pr wrkSub extpgm('WRKSUB');
           subID char(10);
           selectFlag char(1) const;
           rtnCode char(8);
           subDesc char(40);
         end-pr;
         dcl-s subID char(10);
         dcl-s rtnCode char(8);
         dcl-s subDesc char(40);
         dcl-s wrkRF char(60);

         wrkSub(subID:'1':rtnCode:subDesc);

         // If subid is not blank, a subscriber has been selected from
         // the WRKSUB interface. Add selected sub/adr if not already
         // selected.
         if subID <> ' ';
           addEmlAddr = getSubAddr(subID);
           if addEmlAddr <> ' ';
             addEmailEntry(wrkRF);
           else;
             msgHandler('SET':'EML0062');
           endif;
         endif;

         return;

       end-proc;

       //*******************************************************************
       dcl-proc workSubLists;

         dcl-pr wrkLst extpgm('WRKLST');
           subListID char(10);
           subID char(10);
           selectFlag char(10) const;
           rtnCode char(8);
           subListDesc char(40);
         end-pr;
         dcl-s subListID char(10);
         dcl-s subID char(10);
         dcl-s subListDesc char(40);
         dcl-s rtnCode char(8);
         dcl-s i int(10);

         wrkLst(subListID:subID:'1':rtnCode:subListDesc);

         if subListID <> ' ';
           for i = 1 to maxRRN;
             chain i emailslts1;
             if s1subid = subListID and s1emltyp = 'L';
               s1opt = 1;
               update emailslts1;
               selectRecipients();
               leave;
             endif;
           endfor;
         endif;

         return;

       end-proc;

       //*******************************************************************
       dcl-proc selectRecipients;
         dcl-pi *n int(10);
         end-pi;

         dcl-s i int(10);
         dcl-s rtnVal int(10) inz;
         dcl-s wrkRF char(60);

         // Clear the work file and repopulate.
         workFile('CLEAR');

         readc emailslts1;
         if not %eof;
           rtnVal = 1;
         endif;

         for i = 1 to maxRRN;
           chain i emailslts1;
           if s1opt = 1;
             if s1subid <> ' ';
               wrkRF = s1subid;
               addEmailEntry(wrkRF);
             else;
               addEmailEntry(s1emladr);
             endif;
           endif;
         endfor;

         return rtnVal;

       end-proc;

       //*******************************************************************
       // Perform operations against file.
       //*******************************************************************
       dcl-proc workFile;
         dcl-pi *n;
           opcode char(10) const;
         end-pi;

         dcl-s wrkID char(10);

         select;
         when opcode = 'CHECK';
           exec sql select subid into :wrkID from mgemlslt
             fetch first 1 row only;
         when opcode = 'CLEAR';
           sqlStmt = 'delete from mgemlslt';
           exec sql execute immediate :sqlStmt;
         endsl;

         if sqlcod = -204; // File not found...create.
           exec sql create table qtemp/mgemlslt (
             subid char (10) not null with default,
             addr char (128) not null with default,
             type char (1) not null with default);
         endif;

         return;

       end-proc;

       //*******************************************************************
       // Position to the subscriber or email address specified on the
       // input field.
       //*******************************************************************
       dcl-proc positionToProc;

         dcl-s foundEmail ind inz(*off);
         dcl-s i int(10);

         for i = 1 to maxRRN;
           chain i emailslts1;
           if s1subid = positionTo or positionTo = %xlate(lo:up:s1emladr);
             foundEmail = *on;
             leave;
           endif;
         endfor;

         if foundEmail;
           rrn1 = i;
         else;
           rrn1 = 1;
           msgHandler('SET':'EML0062');
         endif;

         return;

       end-proc;

      //*********************************************************************
      // Send program message.
      //*********************************************************************
       dcl-proc spm;
         dcl-pi *n;
           msgid char(7) const;
           msgDta char(80) const;
         end-pi;

         dcl-pr sndpm extpgm('QMHSNDPM');
           msgID char(7) const;
           msgF char(20) const;
           msgDta char(80) const options(*varsize);
           msgDtaLn int(10) const;
           msgType char(10) const;
           stackID char(15) const;
           stackCnt int(10) const;
           msgKey char(4) const;
           apiErr likeds(qusec);
         end-pr;

         dcl-s msgf char(20) inz('PSCON     *LIBL');
         dcl-s dataLen int(10) inz(0);

         if msgid = ' '; // No message.
           return;
         endif;

         dataLen = %len(%trim(msgdta));

         sndpm(msgID:msgF:msgDta:dataLen:'*INFO':pgmq:1:' ':qusec);

         return;

       end-proc;

      //************************************************************************
       dcl-proc rmvMsgs;

        dcl-pr rmvpm extpgm('QMHRMVPM');
          stack char(10) const;
          stackcnt int(10) const;
          msgkey char(4) const;
          msgtype char(10) const;
          apierr likeds(qusec);
        end-pr;

        rmvpm('*':1:' ':'*ALL':qusec);

        return;

       end-proc;

       //*******************************************************************
       dcl-proc addEmailEntry export;
         dcl-pi *n int(10);
           wrkRF char(60);
         end-pi;

         dcl-s thisCount int(10);
         dcl-s tmpID char(10) inz;
         dcl-s rtnVal int(10) inz(0);
         dcl-s aWrkRF char(60) dim(20);
         dcl-s i int(10);
         dcl-s RF char(60);

         workFile('CHECK');

         // Remove any commas or semi-colons.
         wrkRF = %scanrpl(',':' ':wrkRF);
         wrkRF = %scanrpl(';':' ':wrkRF);

         // Parse recipient list to an array of subid's or email addresses.
         // If *LIST is present then the number of id's and/or addresses
         // exceed the size of the recipient field.
         if wrkRF <> '*LIST' and wrkRF <> getRecipientList();
           workFile('CLEAR');
         endif;
         if wrkRF <> '*LIST';
           parseToArray(wrkRF:aWrkRF);
         endif;

         for i = 1 to %elem(aWrkRF);
           if aWrkRF(i) = ' ';
             leave;
           endif;
           if not isEmail(aWrkRF(i));
             aWrkRF(i) = %xlate(lo:up:aWrkRF(i));
           endif;
           insertIntoWorkFile(aWrkRF(i));
         endfor;

         return 0;

       end-proc;

       //*******************************************************************
       dcl-proc parseToArray;
         dcl-pi *n int(10);
           wrkRF char(60);
           outArray char(60) dim(20);
         end-pi;

         dcl-pr strtok pointer extproc('strtok');
           inputString pointer value options(*string);
           delimiter pointer value options(*string);
         end-pr;

         dcl-s i int(10) inz(0);
         dcl-s p pointer;

         p = strtok(wrkRF:' ');
         dow p <> *null;
           i += 1;
           outArray(i) = %str(p);
           p = strtok(*NULL:' ');
         enddo;

         return 0;

       end-proc;

       //*******************************************************************
       // Simple email format validation.
       //*******************************************************************
       dcl-proc isEmail;
         dcl-pi *n ind;
           wrkRF char(60) const;
         end-pi;

         dcl-s rtnVal ind inz(*off);

         if %scan('@':wrkRF) > 0 and %scan('.':wrkRF) > 0;
           rtnVal = *on;
         endif;

         return rtnVal;

       end-proc;

       //*******************************************************************
       // Is the id or address a selected recipient by way of sublist?
       //*******************************************************************
       dcl-proc inSelectedSubList;
         dcl-pi *n ind;
           RF char(60) const;
         end-pi;

         dcl-s subList char(10);
         dcl-s subID char(10);
         dcl-s wrkAddr char(60);
         dcl-s emailAddr char(60);
         dcl-s rtnVal ind inz(*off);
         dcl-s i int(10);
         dcl-s count int(10);
         dcl-s wrkRF char(60);

         wrkRF = RF;

         // If the passed recipient field value is a subscriber list,
         // remove any selected subscribers that are in the list and return.
         if isSubList(wrkRF);
           exec sql delete from mgemlslt a where exists ( select * from
             rsublst b where a.subid = b.subsid and b.sublid = :wrkRF );
           if sqlcod = 0;
             msgHandler('SET':'EML0131':subList);
             return *off;
           endif;
         endif;

         // If the passed recipient field value is a subscriber,
         // prevent the duplicate email if another selected
         // subscriber has the same address.
         if isSubscriber(wrkRF);
           wrkAddr = getSubAddr(wrkRF);
           exec sql select subid,addr into :subID,:emailAddr from mgemlslt where
             ucase(addr) = (:wrkAddr);
           if sqlcod = 0;
             msgHandler('SET':'EML0137':emailAddr);
             return *on;
           endif;
         endif;

         // Get a list of selected sublists from workfile.
         exec sql declare c3 cursor for select subid from mgemlslt where type
           = 'L';
         exec sql open c3;
         exec sql fetch c3 into :subList;

         dow sqlcod = 0;
           if isEmail(wrkRF);
             exec sql select subsid into :wrkRF from rsubscr where
               ucase(seaddr) = ucase(:wrkRF) fetch first 1 row only;
           endif;
           if sqlcod = 0;
             exec sql select subsid into :subID from rsublst where
               subsid = :wrkRF;
             if sqlcod = 0;
               rtnVal = *on;
               if rtnVal; // ID or addr exists in list by way of sublist.
                 msgHandler('SET':'EML0131':subList);
               endif;
               leave;
             endif;
           endif;
           exec sql fetch c3 into :subList;
         enddo;

         exec sql close c3;

         return rtnVal;

       end-proc;

       //*******************************************************************
       // Insert subid/sublist/address into work file.
       //*******************************************************************
       dcl-proc insertIntoWorkFile;
         dcl-pi *n int(10);
           RF char(60) const;
         end-pi;

         dcl-s desc like(RF);
         dcl-s rtnVal int(10) inz(0);
         dcl-s emailAddr char(60);

         select;
           when isSubscriber(RF) and not inWorkFile(RF);
             emailAddr = getSubAddr(RF);
             exec sql insert into mgemlslt values (ucase(:RF), :emailAddr, 'S');
           when isSubList(RF) and not inWorkFile(RF);
             exec sql select slname into :desc from rsublhd where sublid = :RF;
             exec sql insert into mgemlslt values (:RF, :desc, 'L');
           when isEmail(RF) and not inWorkFile(RF);
             exec sql insert into mgemlslt values (' ',:RF,'E');
         endsl;

         return rtnVal;

       end-proc;

       //*******************************************************************
       // Check if subid/sublist/address is already in work file.
       //*******************************************************************
       dcl-proc inWorkFile;
         dcl-pi *n ind;
           RF char(60) const;
         end-pi;

         dcl-s subID char(10);
         dcl-s rtnVal ind inz(*off);

         exec sql select subid into :subID from mgemlslt
           where subid = :RF or ucase(addr) = ucase(:RF);
         if sqlcod = 100;
           // Okay...not in work file but is it included by way of a sublist?
           rtnVal = inSelectedSubList(RF);
         else;
           msgHandler('SET':'EML0137':subID);
           rtnVal = *on;
         endif;

         return rtnVal;

       end-proc;

       //*******************************************************************
       // Is this a subscriber?
       //*******************************************************************
       dcl-proc isSubscriber;
         dcl-pi *n ind;
           RF char(60) const;
         end-pi;

         dcl-s subID char(10);
         dcl-s rtnVal ind inz(*off);

         exec sql select subsid into :subID from rsubscr where subsid = :RF;
         if sqlcod = 0;
           rtnVal = *on;
         endif;

         return rtnVal;

       end-proc;

       //*******************************************************************
       // Is this a subscriber list?
       //*******************************************************************
       dcl-proc isSubList;
         dcl-pi *n ind;
           RF char(60) const;
         end-pi;

         dcl-s subList char(10);
         dcl-s rtnVal ind inz(*off);

         exec sql select sublid into :subList from rsublst where sublid = :RF
           fetch first 1 row only;
         if sqlcod = 0;
           rtnVal = *on;
         endif;

         return rtnVal;

       end-proc;

       //*******************************************************************
       // Get subscriber email address.
       //*******************************************************************
       dcl-proc getSubAddr;
         dcl-pi *n char(60);
           RF char(60) const;
         end-pi;

         dcl-s rtnVal char(60) inz;

         exec sql select seaddr into :rtnVal from rsubscr where subsid = :RF;

         return rtnVal;

       end-proc;

       //*******************************************************************
       // Message handling.
       //*******************************************************************
       dcl-proc msgHandler;
         dcl-pi *n likeds(msgDS_t);
           opcode char(10) const; //SET,GET
           msgID  char(7) const options(*nopass);
           msgDta char(80) const options(*nopass);
         end-pi;

         dcl-ds rtnMsg likeds(msgDS_t) inz;
         dcl-ds saveMsg likeds(msgDS_t) static;

         select;
           when opcode = 'SET';
             if %parms > 1;
               saveMsg.id = msgID;
             endif;
             if %parms > 2;
               saveMSG.dta = msgDta;
             endif;
           when opcode = 'GET';
             rtnMsg = saveMsg;
             clear saveMsg;
         endsl;

         return rtnMsg;

       end-proc;

       //*******************************************************************
       // Return the list of selected recipients. Return *LIST if too long
       // to fit in the 60 byte return field.
       //*******************************************************************
       dcl-proc getRecipientList export;
         dcl-pi *n char(60) end-pi;

         dcl-s rtnRL char(60) inz;
         dcl-ds emailEntry likeds(mailEntry_t);
         dcl-s opcode char(10) inz('*FIRST');

         dow getEmailEntry(opcode:emailEntry) = 0;
           if %len(%trim(rtnRL)) + %len(%trim(emailEntry.recipient)) + 1 >
             %size(rtnRL);
             rtnRL = '*LIST'; //Too much data for return field.
             leave;
           endif;
           rtnRL = %trimr(rtnRL) + ' ' + emailEntry.recipient;
           opcode = '*NEXT';
         enddo;

         rtnRL = %trim(rtnRL);
         return rtnRL;

       end-proc;
**ctdata sqlStmtA
select subid, addr, type, '1' from mgemlslt union select subsid,seaddr, 'S',
 ' ' from rsubscr exception join mgemlslt on subsid = subid where seaddr <>
 ' ' union select sublid, slname, 'L', ' ' from rsublhd exception join
 mgemlslt on sublid = subid order by 4 desc, 1

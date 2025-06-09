      *%METADATA                                                       *
      * %TEXT Add dummy index records w/o archive                      *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) option(*nodebugio);

       dcl-pr main extpgm('ADDNDXREC');
         indexTable char(10);
         numberToAdd char(10);
         startingDateIn char(8) options(*nopass);
       end-pr;

       dcl-s letterA char(1) dim(21) ctdata perrcd(21);

       // First use CRTPGS to add one document to a docclass.
       // Must have 7 indexes.

       dcl-proc main;
         dcl-pi *n;
           indexTable char(10);
           numberToAdd char(10);
           startingDateIn char(8) options(*nopass);
         end-pi;

         dcl-pr getnum extpgm('GETNUM');
           opcode char(6) const;
           getType char(10) const;
           rtnValue char(10);
         end-pr;
         dcl-s getNumRtn char(10);

         dcl-s ldxnam char(10);
         dcl-s sqlStmt char(512);
         dcl-c sq '''';
         dcl-s nbrToAdd int(10);
         dcl-s i int(10);
         dcl-s wrkDate char(8);
         dcl-s dateCount int(10);

         exec sql set option closqlcsr=*endmod,commit=*none;

         // Format the index record and insert for the number of records requested.
         nbrToAdd = %int(numberToAdd);

         // Start with today's date for create date field (lxiv8).
         // Decrement 1 day every 10k records.
         wrkDate = %char(%date():*iso0);
         if %parms = 3; //Starting date passed.
           wrkDate = startingDateIn;
         endif;

         for i = 1 to nbrToAdd;

           getNum('GET':'REPIND':ldxnam);

           sqlStmt = 'insert into ' + indexTable + ' values(' +
             sq + ldxnam + sq + ',1,' +
             sq + getRandomValue() + sq + ',' +
             sq + getRandomValue() + sq + ',' +
             sq + getRandomValue() + sq + ',' +
             sq + getRandomValue() + sq + ',' +
             sq + getRandomValue() + sq + ',' +
             sq + getRandomValue() + sq + ',' +
             sq + getRandomValue() + sq + ',' +
             sq + wrkDate + sq + ',' +
             sq + 'S' + sq + ',' + '1,1)';

            exec sql execute immediate :sqlStmt;

            dateCount += 1;
            if dateCount >= 10000;
              wrkDate = %char(%date(wrkDate:*iso0) - %days(1):*iso0);
              dateCount = 0;
            endif;

          endfor;

       end-proc;

       //*************************************************************************
       dcl-proc getRandomValue;
         dcl-pi *n char(10) end-pi;

         dcl-pr random extproc('CEERAN0');
           seed int(10);
           ranno float(8);
           feedback char(12) options(*omit);
         end-pr;

         dcl-s seed int(10) static;
         dcl-s rand float(8);
         dcl-s result int(10);
         dcl-ds word inz;
           wordA char(1) dim(10);
         end-ds;
         dcl-s i int(10);

         for i = 1 to 10;
           random(seed:rand:*omit);
           result = %rem(%int(rand * 1000):%elem(letterA)) + 1;
           wordA(i) = letterA(result);
         endfor;

         return word;

       end-proc;

**ctdata letterA
BCDFGHJKLMNPQRSTVWXYZ

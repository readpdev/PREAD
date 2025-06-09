       ctl-opt main(main) actgrp(*new);

       exec sql set option closqlcsr=*endmod,commit=*none;

       dcl-proc main;
         dcl-pi *n extpgm('CASESTART');
           modIDin char(8);
           fldIDin char(8);
         end-pi;

         dcl-pr getNum extpgm('GETNUM');
           opcode char(6) const;
           getType char(10) const;
           rtnVal char(10);
         end-pr;
         dcl-s qID char(10);

         dcl-pr sendRequest extpgm('MAG8018');
           opCode char(10) const;
           id char(10) const;
         end-pr;

         dcl-ds csIn qualified;
           id char(10);
           seq packed(9);
         end-ds;

         dcl-ds freqOut extname('MSTFREQ') qualified end-ds;

         dcl-ds model qualified;
           id int(10);
           idChar char(4) pos(1);
         end-ds;

         dcl-ds folder qualified;
           id int(10);
           idChar char(4) pos(1);
         end-ds;

         model.id = %int(modIDin);
         folder.id = %int(fldIDin);

         exec sql declare c1 cursor for select * from balboa/casestart;
         exec sql open c1;

         exec sql fetch c1 into :csIn;
         dow sqlcod = 0;
           getNum('GET':'SVREQID':qID);
           clear freqOut;
           freqOut.STRQID = %int(qID);
           freqOut.STOPCD = 'S';
           freqOut.STSTS = 'N';
           freqOut.STPROC = model.idChar + folder.idChar;
           freqOut.STPRO = freqOut.STPROC;
           freqOut.STRTYP = getDocTypeFromBatch(csIn.id);
           freqOut.STOBJ = csIn.id + %editc(csIn.seq:'X');
           freqOut.STTYP = '*SPYLINK';
           freqOut.STCDAT = %int(%char(%date():*iso0));
           freqOut.STCTIM = %int(%char(%time():*iso0));
           exec sql insert into mstfreq values(:freqOut);
           exec sql fetch c1 into :csIn;
         enddo;

         sendRequest(' ':' ');

         exec sql close c1;

       end-proc;

       //********************************************************************
       dcl-proc getDocTypeFromBatch;
         dcl-pi *n char(10);
           idIn char(10) const;
         end-pi;

         dcl-s rtnType char(10);

         exec sql select iddoct into :rtnType from mimgdir where idbnum = :idIn;

         return rtnType;

       end-proc;

      *%METADATA                                                       *
      * %TEXT Retreive Document Archive                                *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio);

       dcl-pr sndmsg;
          msg char(100) value;
       end-pr;

       dcl-proc main;
         dcl-pi *n extpgm('RTVDOCARC');
           reportID char(10);
         end-pi;

       dcl-pr system extproc('system');
          command pointer options(*string:*trim) value;
       end-pr;

       dcl-c SQ '''';
       dcl-s sqlStmt char(512);
       dcl-s startRRN uns(10);
       dcl-s endRRN uns(10);
       dcl-ds splfRec;
         rcdType char(1);
         rcdRRN uns(10);
       end-ds;
       dcl-ds rptdir extname('MRPTDIR') end-ds;

       exec sql set option closqlcsr=*endmod,commit=*none;

       exec sql select * into :rptdir from mrptdir where repind = :reportID;
       if sqlcod <> 0;
         sndmsg('Report ID ' + %trim(reportID) + ' not found');
         exsr quit;
       endif;

       if reploc = '2'; //Offline
         sndmsg('Document is offline. Cannot retrieve.');
         exsr quit;
       endif;

       // Find offsets
       startRRN = locsfa - 1;

       // Determine end of document in folder.
       sqlStmt = 'select left(' + %trimr(fldr) + ',1),RRN(' +
         %trimr(fldr) + ') from ' +  %trimr(fldrlb) + '/' + %trimr(fldr) +
         ' where rrn(' + %trimr(fldr) + ') >= ' + %trim(%char(locsfc));
       exec sql prepare stmt from :sqlStmt;
       exec sql declare c1 cursor for stmt;
       exec sql open c1;

       exec sql fetch from c1 into :splfRec;
       if sqlcod <> 0;
         sndmsg('Folder data cannot be read or is not found.');
         exsr quit;
       endif;

       dow sqlcod = 0;
         if rcdType = '0';
           rcdRRN -= 1;
           leave;
         endif;
         exec sql fetch from c1 into :splfRec;
       enddo;

       endRRN = rcdRRN;

       // Delete/Create utility library to hold objects.
       system('dltlib rtvdocarc');
       system('crtlib rtvdocarc text(' + SQ +
         'Open Text RTVDOCARC ' + reportID + SQ + ')');

       // Copy the report from the folder beginning at startRRN through endRRN;
       system('cpyf fromfile(' + %trimr(fldrlb) + '/' + %trimr(fldr) +
         ') tofile(rtvdocarc/' + %trimr(fldr) + ') mbropt(*add) crtfile(*yes) '+
         'fromrcd(' + %trim(%char(startRRN)) + ') torcd(' +
         %trim(%char(endRRN)) + ')');

       // Copy RINDEX definitions
       system('cpyf rindex tofile(rtvdocarc/rindex)

       // Copy RLNKDEF definitions

       // Copy RMAINT definition

       exsr quit;

       //*********************************************************************
       begsr quit;

         *inlr = *on;
         return;

       endsr;

       end-proc;

       //*********************************************************************
       dcl-proc sndmsg;
         dcl-pi *n;
           msg char(100) value;
         end-pi;

         dcl-pr spyErr extpgm('SPYERR');
           msgid char(7) const;
           msgdta char(100) const options(*varsize);
           msgfil char(10) const;
           msglib char(10) const;
         end-pr;

         spyerr('CPF9897':MSG:'QCPFMSG':'*LIBL');

         return;

       end-proc;

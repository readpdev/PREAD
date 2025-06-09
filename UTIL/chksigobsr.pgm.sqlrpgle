      *%METADATA                                                       *
      * %TEXT Check Signatures and Observability                       *
      *%EMETADATA                                                      *
       ctl-opt main(main) actgrp(*new) bnddir('SPYSPCIO');
       ctl-opt option(*noshowcpy:*nodebugio);

       //
       // 08-17-16 PLR Created. Utility to check program and service program observability and signature validation.
       //
       //              Command name: CHKSIGOBS
       //              Parm 1:       Program library who's programs and service programs will be checked.
       //              Parm 2:       Return message used by CruiseControl and the calling CL. Not defined to
       //                            the command interface.
       //
       //              Results in the creation of an SQL table called CHKSIGOBS in the current program library.
       //              Will contain single record indicating the object in error and the error condition.
       //

      /copy @spyspcio
      /copy qsysinc/qrpglesrc,qbnlpgmi
      /copy qsysinc/qrpglesrc,qbnlspgm
      /copy qsysinc/qrpglesrc,qusec

       // External programs and procedures
       dcl-pr main extpgm('CHKSIGOBSR');
         programLibrary char(10);
         returnMsg char(10)  options(*nopass);
       end-pr;

       dcl-pr cvthc extproc('cvthc');
         tgt pointer value;
         src pointer value;
         tgtlen int(10) value;
       end-pr;

       dcl-pr lstPgmInf extpgm('QBNLPGMI');
         userSpace char(20) const;
         format char(8) const;
         qpgm char(20) const;
         error likeds(qusec);
       end-pr;

       dcl-pr lstSrvPgmInf extpgm('QBNLSPGM');
         userSpace char(20) const;
         format char(8) const;
         qsrvpgm char(20) const;
         error likeds(qusec);
       end-pr;

       dcl-pr rtvSpcPtr extpgm('QUSPTRUS');
         userSpace char(20) const;
         spacePointer pointer;
       end-pr;

       // Sub-procedures
       dcl-pr cleanup end-pr;
       dcl-pr setup end-pr;
       dcl-pr signatureMismatch ind;
         srvPgmNam char(10) const;
         srvPgmLib char(10) const;
         srvPgmSig char(16) const;
       end-pr ;
       dcl-pr chkPgmModObs end-pr;
       dcl-pr chkPgmSrvSig end-pr;
       dcl-pr chkSrvPgmModObs end-pr;
       dcl-pr chkBndSrvPgmSig end-pr;
       dcl-pr writeMsg;
         message char(256) const;
       end-pr;

       // Structures and variables

       // Program status datastructure
       DCL-DS pgm_stat PSDS;
         curUtilLib CHAR(10) POS(81);
       END-DS;

       // User space header
       dcl-ds spaceHeader len(136) based(spaceHeaderP);
         lstOffSet int(10) pos(125);
         entries int(10) pos(133);
       end-ds;

       // Program - Bound module list. (observability)
       dcl-ds pgmModList len(3995) based(pgmModListP) qualified;
         pgmNam char(10);
         modNam char(10) pos(21);
         dbgDta char(10) pos(145);
       end-ds;

       // Program - Bound service programs. (signature)
       dcl-ds pgmSrvPgmList len(66) based(pgmSrvPgmListP)
         qualified;
         pgmNam char(10);
         pgmLib char(10);
         srvPgmNam char(10);
         srvPgmLib char(10);
         srvSig char(16);
       end-ds;

       // Service Program - Bound modules. (observability)
       dcl-ds srvPgmModList len(3995) based(srvPgmModListP)
         qualified;
         spNam char(10);
         modNam char(10) pos(21);
         dbgDta char(10) pos(145);
       end-ds;

       // Service Program - Service programs bound to a service program. (signature)
       dcl-ds srvPgmBndList len(66) based(srvPgmBndListP)
         qualified;
         spNam char(10);
         bndSpNam char(10) pos(21);
         bndSpLib char(10) pos(31);
         bndSpSig char(16) pos(41);
       end-ds;

       // Service program - Signatures;
       dcl-ds srvPgmSigList based(srvPgmSigListP)
         qualified;
         name char(10);
         lib char(10);
         sig char(16);
       end-ds;

       dcl-s nbrPgmMods int(10);
       dcl-s nbrPgmSPs int(10);
       dcl-s nbrSrvPgmMods int(10);
       dcl-s nbrBndSrvPgms int(10);
       dcl-s nbrSrvPgms int(10);
       dcl-s qUsrSpc char(20);
       dcl-s qPgm char(20);
       dcl-s library char(10);
       dcl-s i int(10);
       dcl-s savePgmSigListP pointer;
       dcl-c OK 0;
       dcl-s errorFlag ind inz(*off);

       //-----------------------------------------------------------------------
       dcl-proc main;
         dcl-pi *n;
           libraryIn char(10);
           returnMsg char(10) options(*nopass);
         end-pi;

         exec sql set option closqlcsr=*endmod,commit=*none;

         library = libraryIn;
         if %addr(returnMsg) <> *null;
           returnMsg = 'success';
         endif;

         // Create user spaces.
         setup();

         // Check observability for all program modules.
         chkPgmModObs();

         // Check service program signatures listed in all programs.
         chkPgmSrvSig();

         // Check bound service programs modules for observability.
         chkSrvPgmModObs();

         // Check signatures for service programs bound to service programs.
         chkBndSrvPgmSig();

         cleanup();

         if errorFlag;
           if %addr(returnMsg) <> *null;
             returnMsg = 'failure';
           endif;
         else;
           writeMsg('No observability or signature violations detected.');
         endif;

         return;

       end-proc;

       // --------------------------------------------------
       dcl-proc chkPgmModObs;

         for i = 1 to nbrPgmMods;
           if pgmModList.dbgDta <> '*NO';
             errorFlag = *on;
             writeMsg('Module ' + %trimr(pgmModList.modNam) + ' in program ' +
               %trimr(pgmModList.pgmNam) + ' contains debug observability.');
           endif;
           pgmModListP += %size(pgmModList);
         endfor;

         return;

       end-proc;

       // --------------------------------------------------
       dcl-proc chkPgmSrvSig;

         for i = 1 to nbrPgmSPs;
           if signatureMismatch(pgmSrvPgmList.srvPgmNam:
             pgmSrvPgmList.srvPgmLib:pgmSrvPgmList.srvSig);
             errorFlag = *on;
             writeMsg('Program ' + %trimr(pgmSrvPgmList.pgmNam) +
               ' signature for service program ' +
               %trimr(pgmSrvPgmList.srvPgmNam) + ' does not match.');
           endif;
           pgmSrvPgmListP += %size(pgmSrvPgmList);
         endfor;

         return;

       end-proc;

       // --------------------------------------------------
       dcl-proc chkSrvPgmModObs;

         for i = 1 to nbrSrvPgmMods;
           if srvPgmModList.dbgDta <> '*NO';
             errorFlag = *on;
             writeMsg('Service program module ' + %trimr(srvPgmModList.modNam) +
             ' in service program ' + %trimr(srvPgmModList.spNam) +
             ' contains debug observability.');
           endif;
           srvPgmModListP += %size(srvPgmModList);
         endfor;

         return;

       end-proc;

       // --------------------------------------------------
       dcl-proc chkBndSrvPgmSig;

         for i = 1 to nbrBndSrvPgms;
           if signatureMismatch(srvPgmBndList.bndSpNam:srvPgmBndList.bndSpLib:
             srvPgmBndList.bndSpSig);
             errorFlag = *on;
             writeMsg('Service program ' + %trimr(srvPgmBndList.spNam) +
               ' signature for bound service program ' +
               %trimr(srvPgmBndList.bndSpNam) + ' do not match.');
           endif;
           srvPgmBndListP += %size(srvPgmBndList);
         endfor;

         return;

       end-proc;

       // --------------------------------------------------
       DCL-PROC signatureMismatch ;
         DCL-PI *N IND;
           srvPgmNam CHAR(10) CONST;
           srvPgmLib CHAR(10) CONST;
           srvPgmSig char(16) const;
         END-PI ;

         dcl-s i int(10);
         dcl-s mismatch ind inz(*off);

         if srvPgmLib <> *allx'00' and srvPgmLib <> library;
           return mismatch;
         endif;

         // The logic below will walk a list of signatures. If a match is encountered,
         // it will set the mismatch flag off and return. Otherwise, a mismatch has
         // been found and will return the indicated response.

         srvPgmSigListP = savePgmSigListP;
         for i = 1 to nbrSrvPgms;
           if srvPgmNam = srvPgmSigList.name;
             if srvPgmSig <> srvPgmSigList.sig;
               mismatch = *on;
             else;
               mismatch = *off;
               leave;
             endif;
           endif;
           srvPgmSigListP += %size(srvPgmSigList);
         endfor;

         return mismatch;

       END-PROC ;

       //-----------------------------------------------------------------------
       dcl-proc writeMsg;
       dcl-pi *n;
         msg char(256) const;
       end-pi;

       dcl-s firstTime ind inz(*on) static;

       // If first time in, write header information to file.
       if firstTime;
         firstTime = *off;
         exec sql insert into chksigobs values(
           'Check program/service program signatures and observability.');
         exec sql insert into chksigobs values(now());
         exec sql insert into chksigobs values('User: ' concat user);
         exec sql insert into chksigobs values('Library: ' concat :library);
       endif;

       exec sql insert into chksigobs values(:msg);

       return;

       end-proc;

       //-----------------------------------------------------------------------
       dcl-proc cleanup;

         dltusrspc('PGMMODOBS':'QTEMP');
         dltusrspc('PGMSRVSIG':'QTEMP');
         dltusrspc('SRVMODOBS':'QTEMP');
         dltusrspc('SRVSRVSIG':'QTEMP');
         dltusrspc('SRVPGMSIG':'QTEMP');

         return;

       end-proc;

       // --------------------------------------------------
       DCL-PROC setup ;

         dcl-s sqlStmt char(256);

         cleanup();

         sqlStmt = 'drop table ' + %trimr(curUtilLib) + '/chksigobs';
         exec sql execute immediate:sqlStmt;

         sqlStmt = 'CREATE TABLE ' + %trimr(curUtilLib) +
           '/CHKSIGOBS (MSG CHAR (256) NOT NULL WITH DEFAULT)';
         exec sql execute immediate :sqlStmt;

         // Program modules observability.
         crtUsrSpc('PGMMODOBS':'QTEMP':102400);
         qUsrSpc = 'PGMMODOBS QTEMP';
         qusbprv = %size(qusec);
         qusbavl = 0;
         qpgm = '*ALL      ' + library;
         lstPgmInf(qUsrSpc:'PGML0100':qpgm:qusec);
         rtvSpcPtr(qUsrSpc:spaceHeaderP);
         pgmModListP = spaceHeaderP + lstoffset;
         nbrPgmMods = entries;

         // Program - Bound service program signatures list.
         crtUsrSpc('PGMSRVSIG':'QTEMP':102400);
         qUsrSpc = 'PGMSRVSIG QTEMP';
         qusbprv = %size(qusec);
         qusbavl = 0;
         qpgm = '*ALL      ' + library;
         lstPgmInf(qUsrSpc:'PGML0200':qpgm:qusec);
         rtvSpcPtr(qUsrSpc:spaceHeaderP);
         pgmSrvPgmListP = spaceHeaderP + lstoffset;
         nbrPgmSPs = entries;

         // Service Programs - Bound modules observability list;
         crtUsrSpc('SRVPGMMODS':'QTEMP':102400);
         qUsrSpc = 'SRVPGMMODSQTEMP';
         qusbprv = %size(qusec);
         qusbavl = 0;
         lstSrvPgmInf(qUsrSpc:'SPGL0100':qpgm:qusec);
         rtvSpcPtr(qUsrSpc:spaceHeaderP);
         srvPgmModListP = spaceHeaderP + lstoffset;
         nbrSrvPgmMods = entries;

         // Service Programs - Bound service program signatures.
         crtUsrSpc('SRVSRVSIG':'QTEMP':102400);
         qUsrSpc = 'SRVSRVSIG QTEMP';
         qusbprv = %size(qusec);
         qusbavl = 0;
         lstSrvPgmInf(qUsrSpc:'SPGL0200':qpgm:qusec);
         rtvSpcPtr(qUsrSpc:spaceHeaderP);
         srvPgmBndListP = spaceHeaderP + lstoffset;
         nbrBndSrvPgms = entries;

         // Service program - List of service program signatures.
         crtUsrSpc('SRVPGMSIG':'QTEMP':102400);
         qUsrSpc = 'SRVPGMSIG QTEMP';
         qusbprv = %size(qusec);
         qusbavl = 0;
         lstSrvPgmInf(qUsrSpc:'SPGL0800':qpgm:qusec);
         rtvSpcPtr(qUsrSpc:spaceHeaderP);
         srvPgmSigListP = spaceHeaderP + lstoffset;
         savePgmSigListP = srvPgmSigListP;
         nbrSrvPgms = entries;

        return ;

       END-PROC ;

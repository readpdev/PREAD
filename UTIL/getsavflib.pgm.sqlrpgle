**free
      //%METADATA                                                      *
      // %TEXT Returns Saved Library Name From Save File               *
      //%EMETADATA                                                     *
ctl-opt dftactgrp(*no) actgrp(*new);

/copy qsysinc/qrpglesrc,qusec

// Entry point. Parms: library name, save file name, savedLibraryRtn
dcl-pi *n;
  saveFileName char(10) const;
  saveFileLibary char(10) const;
  rtnSavedLibrary char(10);
end-pi;

dcl-pr run int(10) extproc('system');
  *n pointer value options(*string:*trim); // cmd
end-pr;

exec sql set option closqlcsr=*endmod,commit=*none;

run('dspsavf ' + %trimr(saveFileLibary) + '/' + %trimr(saveFileName) + ' output(*print)');

run('CRTPF QTEMP/GETSAVFLIB RCDLEN(132)');
run('CPYSPLF FILE(QPSRODSP) TOFILE(QTEMP/GETSAVFLIB) SPLNBR(*LAST)');
run('DLTSPLF FILE(QPSRODSP) SPLNBR(*LAST)');

exec sql select substr(getsavflib,45,10) into :rtnSavedLibrary
  from qtemp/getsavflib where getsavflib like '%Library%' and
  substr(getsavflib,45,1) <> ' ';

*inlr = *on;
return;


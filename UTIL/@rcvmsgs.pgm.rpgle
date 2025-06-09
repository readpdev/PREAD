**free
/copy 'UTIL/qmhrcvpm.rpgleinc'
/copy qsysinc/qrpglesrc,qusec

dcl-pr rcvPgmMsg extpgm('QMHRCVPM');
  msgInfo likeds(rpmDS);
  msgInfLen int(10) const;
  format char(10) const;
  stackEntry char(10) const;
  stackCount int(10) const;
  msgType char(10) const;
  msgKey char(4) const;
  waitTime int(10) const;
  msgAction char(10) const;
  errorCode likeds(qusec);
end-pr;

dcl-ds rpmDS qualified;
  rpm100 likeds(QMHM010001);
  msgTxt char(50);
end-ds;

rcvPgmMsg(rpmDS:%size(rpmDS):'RCVM0100':'*':0:'*LAST':' ':0:'*REMOVE':qusec);

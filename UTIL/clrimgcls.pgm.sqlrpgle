**free
      //%METADATA                                                      *
      // %TEXT Clear Image Class                                       *
      //%EMETADATA                                                     *
ctl-opt dftactgrp(*no) actgrp(*new) bnddir('MYBNDDIR');

/copy @mrrepmgr

dcl-pi *n;
  documentType char(10);
end-pi;

dcl-s batchID char(10);

exec sql declare c1 cursor for select distinct idbnum from mimgdir where iddoct = :documentType;

exec sql open c1;

exec sql fetch c1 into :batchID;
dow sqlcod = 0;
  dltObj(batchID + '0000000000':IMAGE);
  exec sql fetch c1 into :batchID;
enddo;

*inlr = *on;

return;

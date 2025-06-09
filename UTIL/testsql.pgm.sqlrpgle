**free
ctl-opt dftactgrp(*no) actgrp(*new);

dcl-ds *n;
  protectRcd char(1024) pos(1);
  protectA char(10) dim(20) pos(1);
end-ds;
dcl-ds *n;
  protectValRcd char(1024) pos(1);
  protectValA char(8) dim(20) pos(1);
end-ds;

exec sql set option commit=*none;

exec sql select
    listagg(BPKP_NAM, ''), listagg(
        BPKP_PRNAM || BPKP_PRSRL || BPKP_PRPRD || BPKP_PREXP || BPKP_PRNOT || BPKP_PRIO || BPKP_PRLIB
        || BPKP_PRBLD,
        ''
    )
   into :protectRcd, :protectValRcd
from
    bpkey.bpkeyprd;


*inlr = *on;
return;

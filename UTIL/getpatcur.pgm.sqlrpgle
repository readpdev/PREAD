      *%METADATA                                                       *
      * %TEXT Get latest patch number from PIAOBJ/PTFCFG               *
      *%EMETADATA                                                      *
        ctl-opt main(main) dftactgrp(*no) actgrp(*new);

        dcl-proc main;
          dcl-pi *n extpgm('GETPATCUR');
            versionIn zoned(4);
            buildNbrRtn zoned(4);
          end-pi;

          exec sql set option closqlcsr=*endmod,commit=*none;

          exec sql select ptf_bldnbr into :buildNbrRtn from piaobj/ptfcfg
            where ptf_ver = :versionIn;

          return;

        end-proc;

       ctl-opt main(main) dftactgrp(*no) actgrp(*new) bnddir('TSTBNDDIR');

       dcl-proc main;

         dcl-pr cvthc extproc('cvthc');
           tgt pointer value;
           src pointer value;
           srclen int(10) value;
         end-pr;

         dcl-pr cvtch extproc('cvtch');
           tgt pointer value;
           src pointer value;
           tgtlen int(10) value;
         end-pr;

         dcl-s fld1 int(20) inz(12356789);
         dcl-s fld2 uns(10);
         dcl-s fld3 char(8);

         fld2 = fld1;

         cvthc(%addr(fld3):%addr(fld2):%size(fld3));
         fld2 = 0;
         cvtch(%addr(fld2):%addr(fld3):%size(fld3));

         return;

       end-proc;

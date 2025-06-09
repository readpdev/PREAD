      *%METADATA                                                       *
      * %TEXT Re/build report doclinks based on rpt type               *
      *%EMETADATA                                                      *
       ctl-opt main(main) dftactgrp(*no) option(*noshowcpy:*nodebugio);

       dcl-proc main;
         dcl-pi *n extpgm('BLDRPTLNK');
           reportType char(10);
         end-pi;

         dcl-pr system extproc('system');
           command pointer options(*string:*trim) value;
         end-pr;

         dcl-pr bldRepLnk extpgm('BLDREPLNK');
           folder char(10);
           folderLib char(10);
           fileName char(10);
           jobName char(10);
           userName char(10);
           jobNumber char(6) const;
           datfo6 char(7) const;
           fileNumber int(10) const;
           dispM char(1) const; //Default to 'N';
           linkFile char(10) const;
           reportID char(10); //repind
           returnID char(7);
           returnData char(100);
         end-pr;

         dcl-s returnID char(7);
         dcl-s returnData char(100);
         dcl-s lnkfil char(10);

         dcl-ds rptdir extname('MRPTDIR') end-ds;

         // Get the big5 for fetching the link file from RLNKDEF.
         exec sql select * into :rptdir from mrptdir where rpttyp = :reportType
           fetch first 1 rows only;

         // Get the link file from RLNKDEF.
         exec sql select lnkfil into :lnkfil from rlnkdef where lrnam = :filnam
           and ljnam = :jobnam and lpnam = :pgmopf and lunam = :usrnam and
           ludat = :usrdta;

         // Use the template link file as an override for the report type link file.
         system('ovrdbf rlnkndx ' + lnkfil + ' ovrscope(*job)');

         // Get only the report directory records not having links.
         exec sql declare c1 cursor for select mrptdir.* from mrptdir exception
           join rlnkndx on repind = ldxnam where rpttyp = :reportType;

         exec sql open c1;

         exec sql fetch c1 into :rptdir;
         if sqlcod = 0;
           system('ovrdbf folder ' + fldr + ' ovrscope(*job)');
         endif;

         dow sqlcod = 0;
           bldRepLnk(fldr:fldrlb:filnam:jobnam:usrnam:jobnum:
             %trim(%char(datfop)):%int(filnum):'N':lnkfil:repind:returnID:
             returnData);
           exec sql fetch c1 into :rptdir;
         enddo;

         exec sql close c1;
         system('dltovr folder lvl(*job)');
         system('dltovr rlnkndx lvl(*job)');

         return;

       end-proc;

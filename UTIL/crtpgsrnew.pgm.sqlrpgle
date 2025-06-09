       ctl-opt dftactgrp(*no) actgrp(*new);

     fqsysprt   o    f  247        printer usropn

       dcl-ds maint extname('DOC921DTA/RMAINT') end-ds;
       dcl-ds maint2 extname('DOC942DTA/RMAINT') qualified end-ds;

       dcl-s letterA char(1) dim(21) ctdata perrcd(21);

       Dcl-DS index  EXTNAME('DOC921DTA/RINDEX');
        End-DS;
       Dcl-DS lnkdef  EXTNAME('DOC921DTA/RLNKDEF');
        End-DS;
       Dcl-DS rptdir  EXTNAME('DOC921DTA/MRPTDIR') END-DS;

     d run             pr                  extproc('system')
     d  cmd                            *   value options(*string)

     d memcpy          pr                  extproc('memcpy')
     d  target                         *   value options(*string)
     d  source                         *   value options(*string)
     d  length                       10i 0 value

     d bldlnkf         pr                  extpgm('BLDLNKF')
     d  reportName                   10    const
     d  jobName                      10    const
     d  pgmName                      10    const
     d  usrName                      10    const
     d  usrData                      10    const
     d  sequence                      5  0 const
     d  description                  30    const
     d  linkDBName                   10    const
     d  rtnMsgID                      7    const
     d rtnMsgID        s              7

     d getNum          pr                  extpgm('GETNUM')
     d  opcode                        6    const
     d  getType                      10    const
     d  value                        10

     d x               s             10i 0
     d y               s             10i 0
     d z               s             10i 0
     d detailData      s            247
     d reportName      s             10
     d ruler           s            247
     d rulerA          s            100    dim(1) perrcd(1) ctdata
     d MAXNDX          c                   35
     d iterations      s              7  0
     d numPgs          s                   like(maxPgs)
     d ndxNameP        s               *
     d indexName       s             10

     d sysdft          ds          1024    dtaara
     d  exclRptNam                    1    overlay(sysdft:252)
     d  exclJobNam                    1    overlay(sysdft:253)
     d  exclPgmNam                    1    overlay(sysdft:254)
     d  exclUsrNam                    1    overlay(sysdft:255)
     d  exclUsrDta                    1    overlay(sysdft:256)
     d  dtaLib                       10    overlay(sysdft:306)

     d                sds
     d thisPgm           *proc
     d curUser               254    263
     d summaryIndex    s               n   inz('0')
     d sq              c                   ''''

     c     *entry        plist
     c                   parm                    numRptTyp         6 0
     c                   parm                    numRpts           8 0
     c                   parm                    maxPgs            6 0
     c                   parm                    preFix            3
     c                   parm                    rptName          10
     c                   parm                    rptWidth          3 0
     c                   parm                    crtNdx            1
     c                   parm                    nbrIndices        2 0
     c                   parm                    prt4arch          1
     c                   parm                    outq             10
     c                   parm                    outql            10

       exec sql set option closqlcsr=*endmod,commit=*none;

       in sysdft;

       reportName = rptName;
       for x = 1 to 3;
         ruler = %trim(ruler) + rulerA(1);
       endfor;

       // Write out number of report types.
       for x = 1 to numRptTyp;

         if numRptTyp > 1;
           reportName = %trim(prefix) + %subst(%editc(x:'X'):4:7);
         endif;

         // Write rmaint record
         clear maint;
         if exclRptNam = 'N';
           rrnam = reportName;
         endif;
         if exclJobNam = 'N';
           rjnam = 'JOBNAME';
         endif;
         if exclPgmNam = 'N';
           rpnam = thisPgm;
         endif;
         if exclUsrNam = 'N';
           runam = curUser;
         endif;
         if exclUsrDta = 'N';
           rudat = thisPgm;
         endif;
         rmlckf = 101;
         rmannf = 'N';
         rmbrcf = 'N';
         rtypid = reportName;
         rrdesc = reportName;
         exec sql insert into rmaint values(:maint);
         if sqlcod <> 0;
          eval-corr maint2 = maint;
          exec sql insert into rmaint values(:maint2);
         endif;

         if crtNdx = 'Y';

           //write rindex records
           clear index;
           ipln# = 10;
           iscol = 13;
           iklen = 10;
           iinda = 'N';
           ipmtl = 11;
           ipmtsl = 1;
           ipmtel = 999;
           ipmtsc = 1;
           ipmtec = 11;
           ipmtrl = 0;
           ipmtrc = 12;
           iloc = 'N';
           iicmd = 1;
           irnam = rrnam;
           ijnam = rjnam;
           ipnam = rpnam;
           iunam = runam;
           iudat = rudat;
           for y = 1 to nbrIndices;
             iinam = '@INDEX' + %triml(%editc(y:'Z'));
             idesc = 'INDEX' + %triml(%editc(y:'Z'));
             ipln# = ipln# + 1;
             iprmpt = 'IndexVal'+%triml(%editc(y:'Z'))+':';
             exec sql insert into rindex values(:index);
           endfor;

           // Write link definition record.
           clear lnkdef;
           lrnam = rrnam;
           ljnam = rjnam;
           lpnam = rpnam;
           lunam = runam;
           ludat = rudat;
           ndxNameP = %addr(lndxn1);
           for z = 1 to nbrIndices;
             indexName = '@INDEX' + %trim(%editc(z:'Z'));
             memcpy(ndxNameP:%addr(indexName):%size(indexName));
             ndxNameP = ndxNameP + 10;
           endfor;
           exec sql insert into rlnkdef values (:lnkdef);

           // Build link table and views.
           if prt4arch = 'N';
             clear lnkfil;
             bldlnkf(rrnam:rjnam:rpnam:runam:rudat:0:rrnam:lnkfil:rtnMsgID);
           endif;

         endif;

         // If the index file name is blank, fetch it from RLNKDEF.
         if lnkfil = ' ';
           exec sql select lnkfil into :lnkfil from rlnkdef where lrnam = :rrnam
             and ljnam = :rjnam and lpnam = :rpnam and lunam = :runam and
             ludat = :rudat;
         endif;

         // Initialize mrptdir fields when not printing for archive.
         clear rptdir;
         fldr = 'DFTFOLDER';
         fldrlb = dtalib;
         jobnum = %char(%subdt(%timestamp():*MS));
         chksum = 0;
         frmtyp = '*STD';
         hldf = '*NO';
         savf = '*NO';
         totpag = maxPgs;
         totcpy = 1;
         lpi = 60;
         cpi = 100;
         outqnm = outq;
         outqlb = outql;
         if outqnm = ' ';
           outqnm = 'QPRINT';
           outqlb = 'QGPL';
         endif;
         datfop = %int(%char(%date():*iso0));
         timfop = %int(%char(%time():*iso0));
         devfna = 'OUTPUT';
         devcls = 'PRINTER';
         ovrlin = 60;
         prtfon = '*CPU';
         pagrot = -1;
         maxsiz = 4079;
         adsf = datfop;
         locsfa = 2;
         locsfd = 15;
         locsfp = 31;
         locsfc = 32;
         pagsiz = 0;
         pkver = '1';
         mdatop = %int(%char(%date():*cymd0));
         mtimop = timfop;
         reploc = '0';
         filnam = rrnam;
         jobnam = rjnam;
         usrnam = runam;
         rpttyp = rrnam;
         pgmopf = rpnam;
         usrdta = rudat;

         run('ovrprtf qsysprt splfname(' + %trim(reportName) + ') ' +
           'PAGESIZE(*N ' + %char(rptWidth) + ') outq(' + %trimr(outqlb) + '/' +
           %trimr(outqnm) + ')');

         for iterations = 1 to numRpts;

           if prt4arch = 'N';
             // Write mrptdir record.
             filnum += 1;
             exec sql insert into mrptdir values(:rptdir);
           endif;

           getNum('GET':'REPIND':repind);

           if prt4Arch = 'N';
             for numPgs = 1 to maxPgs;
               detailData = 'insert into ' + lnkfil + ' values(' + sq +
                 repind + sq + ',' + %char(numPgs) + ',';
               for y = 1 to nbrIndices;
                 detailData = %trimr(detailData) + sq + 'P' +
                   %trim(%char(numPgs)) + 'I' + %trim(%char(y)) + sq + ',';
               endfor;
               detailData = %trimr(detailData) + %char(%date():*iso0) + ',' +
                 sq + 'S' + sq + ',1,1)';
               exec sql execute immediate :detailData;
             endfor;
           endif;

           // Print for archive.
           if prt4arch = 'Y';
             open qsysprt;
             for numPgs = 1 to maxPgs;
               except header;
               if not summaryIndex;
                 summaryIndex = '1';
                 detailData = 'SUMMARYPROMPT: SUMMARYVALUE';
                 except detail;
               endif;
               for y = 1 to nbrIndices;
                 detailData = 'IndexVal'+%triml(%editc(y:'Z'));
                 if y <= 9;
                   detailData = %trimr(detailData) + ':  ' +
                     getRandomValue();
                   //detailData = %trimr(detailData) + ':  ' +
                   //  'IVAL'+ %triml(%editc(y:'Z')) + 'P' +
                   //  %trim(%editc(numPgs:'Z'));
                 else;
                   detailData = %trimr(detailData) + ': ' +
                     'IVAL'+ %triml(%editc(y:'Z')) + 'P' +
                     %trim(%editc(numPgs:'Z'));
                 endif;
                 except detail;
               endfor;
               // Fill up rest of page (50 lines) with all X's.
               detailData = *all'X';
               for y = 1 to 50;
                 except detail;
               endfor;
             endfor;
             close qsysprt;
             page = 0;
           endif;

         endfor;

         run('dltovr ' + %trim(reportName));

       endfor;

       *inlr = '1';

     oqsysprt   e            header         1  1
     o                       ruler              247
     o          e            header         1
     o                       *date         y
     o                                              '     '
     o                                              'Page: '
     o                       numPgs        z
     o          e            detail         1
     o                       detailData         247
       //*************************************************************************
       dcl-proc getRandomValue;
         dcl-pi *n char(10) end-pi;

       dcl-pr random extproc('CEERAN0');
         seed int(10);
         ranno float(8);
         feedback char(12) options(*omit);
       end-pr;

       dcl-s seed int(10) static;
       dcl-s rand float(8);
       dcl-s result int(10);
       dcl-ds word inz;
         wordA char(1) dim(10);
       end-ds;
       dcl-s i int(10);

       for i = 1 to 10;
         random(seed:rand:*omit);
         result = %rem(%int(rand * 1000):%elem(letterA)) + 1;
         wordA(i) = letterA(result);
       endfor;

       return word;

       end-proc;

**ctdata rulerA
....+... 1 ...+... 2 ...+... 3 ...+... 4 ...+... 5 ...+... 6 ...+... 7 ...+... 8
**ctdata letterA
BCDFGHJKLMNPQRSTVWXYZ

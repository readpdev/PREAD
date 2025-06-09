      *%METADATA                                                       *
      * %TEXT Retrieve program source                                  *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('QC2LE')

      // Must be compiled v4r5 or higher.

      // To debug: Comment out code that starts and ends debug and recompile.
      // Place this program and the program having the source retrieved into debu

      /copy @recio

     d run             pr                  extproc('system')
     d  cmd                            *   value options(*string)

     d vewl0100        ds
     d  v_bytrtn                     10i 0
     d  v_bytavl                     10i 0
     d  v_nbrelm                     10i 0
     d  v_modnam                     10
     d  v_vewtyp                     10
     d  v_compid                     20
     d  v_mainIn                     10
     d  v_timstm                     13
     d  v_vewdsc                     50
     d  v_rsrvd1                      3
     d  v_vewnbr                     10i 0
     d  v_nbrvew                     10i 0
     d receiverLen     s             10i 0 inz(%size(vewl0100))

     d retrieveViews   pr                  extproc('QteRetrieveModuleViews')
     d  receiver                           like(vewl0100)
     d  receiverLen                  10i 0
     d  formatName                    8    const
     d  qualPgm                      20
     d  pgmType                      10
     d  moduleName                   10    const
     d  rtnLibName                   10
     d  error                              like(apierr)
     d rtnLibName      s             10

     d retrieveText    pr                  extproc('QteRetrieveViewText')
     d  receiver                           like(r_receiver)
     d  receiverLen                  10i 0 value
     d  viewid                       10i 0
     d  startLine                    10i 0 const
     d  numberLines                  10i 0 const
     d  lineLength                   10i 0 const
     d  error                              like(apierr)

     d apierr          ds
     d  a_bytprv                     10i 0 inz(%size(apierr))
     d  a_bytavl                     10i 0 inz
     d  a_msgid                       7    inz
     d  a_msgtxt                     80    inz

     d r_receiver      ds                  based(rP)
     d  r_bytrtn                     10i 0
     d  r_bytavl                     10i 0
     d  r_nbrlin                     10i 0
     d  r_linlen                     10i 0
     d r_rcvlen        s             10i 0 inz(%size(r_receiver))

     d lineText        s            255    based(ltP)
     d srcFile         s             33
     d qPgm            s             20
     d x               s             10i 0
     d MAXLINLEN       c                   255

     c     *entry        plist
     c                   parm                    qualPgm          10
     c                   parm                    qualLib          10
     c                   parm                    pgmType          10
     c                   parm                    srcfilnam        10
     c                   parm                    srcfillib        10
     c                   parm                    srcfilmbr        10

      /FREE
       exec sql set option closqlcsr=*endmod,commit=*none;
       qPgm = qualPgm + qualLib;

       // run('strdbg ' + %trimr(qualLib) + '/' +
       //   %trimr(qualPgm) + ' ' + 'dspmodsrc(*no)')

       srcFile = %trimr(srcfillib) + '/' +
           %trimr(srcfilnam) + ' mbr(' +
           %trimr(srcfilmbr) + ')';

       reset apierr;
       retrieveViews(vewl0100:receiverLen:
           'VEWL0100':qPgm:pgmType:'*ALL':
           rtnLibName:apierr);

       // Call once to get the initial structure and total length available...
       reset apierr;
       rP = %alloc(r_rcvlen);
       retrieveText(r_receiver:
           %size(r_receiver):v_vewnbr:1:0:MAXLINLEN:
           apierr);

       // Call a second time to get everything after the structure. (source lines)
       reset apierr;
       r_rcvlen = r_rcvlen + r_bytavl;
       rP = %realloc(rP:r_rcvlen);
       retrieveText(r_receiver:
           %size(r_receiver)+r_bytavl:v_vewnbr:1:0:
           r_linlen:apierr);

       // run('enddbg')

       run('addpfm ' + %trimr(srcFile));
       run('ovrdbf srcFile ' + %trimr(srcFile) +
           ' ovrscope(*job)');

       ltP = rP + %size(r_receiver);
       for x = 1 to r_nbrlin;
         if (x > 1 and x < r_nbrlin) or
               v_vewtyp <> '*LISTING';
           select;
           when v_vewtyp = '*TEXT';
             lineText = %subst(lineText:13);
           when v_vewtyp = '*LISTING';
             lineText = %subst(lineText:111:5) +
                 %subst(lineText:11:90);
           endsl;
         exec sql
          insert into srcFile (srcseq, srcdat, srcdta) values(0, 0,
          rtrim(:lineText));
         endif;
         ltP = ltP + r_linlen;
       endfor;

       dealloc rP;
       run('dltovr *all lvl(*job)');

       *inlr = '1';

      /END-FREE

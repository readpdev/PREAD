      *%METADATA                                                       *
      * %TEXT Rebuild Distribution                                     *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE')
      *
      * Called by command RBLDDST.
      *
      * The rebuild of segments is dependent on the distribution history records
      * If the dsthst is missing records this application will not rebuild them.
      * However, this program could be adapted to perform rebuild on a number of
      * scenarios in the future.
      *
      * 01-12-07 PLR Created.
      *
     frdsthst1  if   e           k disk
     frseghdr1  if   e           k disk
     frsegmnt   if   e           k disk    usropn
     ftickler   o    f  256        disk    usropn
     fmyPrtf    o    f  132        printer usropn oflind(*in99)

     d ERROR           c                   -1
     d OK              c                   0
     d CREATE          c                   1

     d system          pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d processTickler  pr                  extpgm('MAG408')

     d spm             pr
     d  msgdta                       50    value

     d print           pr
     d  msg                         132    value

     d validate        pr

     d segHdrKey       ds
     d  dhrept
     d  dhseg
     d outMsg          s            132
     d runMode         s             20
     d timeOut         s              8
     d ticklerData     s               n   inz('0')

     d                sds
     d pgmq              *proc

     c     *entry        plist
     c                   parm                    rptTyp           10
     c                   parm                    printOnly         1

      /free
       *in99 = '1'; //Force header print
       system('dltf qtemp/tickler');
       system('crtpf qtemp/tickler rcdlen(256)');
       runMode = 'Report Only';
       if printOnly = 'N';
         runMode = 'Report & Build';
       endif;
       if rptTyp <> '*ALL';
         setll rptTyp rdsthst1;
         if not %equal;
           spm('Report type ' + %trim(rptTyp) +
             ' not found in history file');
           exsr quit;
         endif;
         reade rptTyp rdsthst1;
       else;
         read rdsthst1;
       endif;
       system('ovrprtf file(myPrtf) tofile(qsysprt) ovrflw(60) ' +
         'splfname(rblddst) pagesize(*n 132)');
       open myPrtf;
       dow not %eof(rdsthst1);
         validate();
         if rptTyp <> '*ALL';
           reade rptTyp rdsthst1;
         else;
           read rdsthst1;
         endif;
       enddo;
       if ticklerData;
         close tickler;
         processTickler();
       endif;
       exsr quit;

       //***********************************************************************
       begsr quit;
         close(e) tickler;
         system('dltf qtemp/tickler');
         close(e) myPrtf;
         system('dltovr qsysprt lvl(*job)');
         *inlr = '1';
         return;
       endsr;

      /end-free

      **************************************************************************
     omyPrtf    e            printHdr          1
     o                       udate         y
     o                                              '  '
     o                       timeOut
     o                                              '  '
     o                                              'Rebuild Distribution'
     o                                              '   Mode: '
     o                       runMode
     o                                              '   Page: '
     o                       page          z
     o          e            printHdr    2  1
     o                                              'Message'
     o          e            printDtl    1
     o                       outMsg

      **************************************************************************
     p print           b
     d                 pi
     d message                      132    value

      /free
       timeOut = %char(%time());
       message = %trim(message) + ' for type/report/segment: ' +
         %trim(dhrept) + '/' + %trim(dhrep) + '/' + %trim(dhseg);
       if *in99;
         except printHdr;
         *in99 = '0';
       endif;
       outMsg = message;
       except printDtl;
       return;
      /end-free

     p                 e

      **************************************************************************
     p validate        b

     d report          ds           256    qualified
     d  id                           10

      /free
       // Check for a segment header record.
       chain %kds(segHdrKey) rseghdr1;
       if not %found;
         print('Segment header not found');
         exsr quit;
       endif;
       // Check for records in the 'P' file.
       system('ovrdbf rsegmnt ' + shsfil);
       open(e) rsegmnt;
       if %error;
         print('Error opening distribution file');
         exsr quit;
       endif;
       setll dhrep rsegmnt;
       if not %equal;
         if printOnly = 'N';
           if not %open(tickler);
             open tickler;
             ticklerData = '1';
           endif;
           report.id = dhrep;
           write tickler report;
           print('Wrote record to tickler file');
         else;
           print('Segment record not found');
         endif;
       endif;
       exsr quit;
       return;

       //******************************************
       begsr quit;
         close(e) rsegmnt;
         system('dltovr rsegmnt');
         return;
       endsr;
      /end-free

     p                 e

      **************************************************************************
     p spm             b
     d                 pi
     d  msgdta                       50    value

     d msgf            s             20    inz('QCPFMSG   *LIBL')
     d msgdtalen       s             10i 0 inz(0)
     d stackcnt        s             10i 0 inz(0)

     c                   eval      msgDtaLen = %len(%trimr(msgdta))

     c                   call      'QMHSNDPM'
     c                   parm      'CPF9898'     msgid             7
     c                   parm                    msgf
     c                   parm                    msgdta
     c                   parm                    msgdtalen
     c                   parm      '*INFO'       msgtype          10
     c                   parm                    pgmq
     c                   parm      2             stackcnt
     c                   parm      ' '           msgkey            4
     c                   parm      ' '           apierr          116

     p                 e

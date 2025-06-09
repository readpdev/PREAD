      *%METADATA                                                       *
      * %TEXT Display number spool pages for a given outq              *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('QC2LE')
     d ApiHeader       ds
     d ah_InfoStatus         104    104
     d ah_SpaceSize          105    108i 0
     d ah_ListOffset         125    128i 0
     d ah_ListCount          133    136i 0
     d ah_EntrySize          137    140i 0

     d i               s             10i 0

     d strPos          s             10i 0

     D ERRCD           DS
     D  @ERLEN                 1      4i 0 inz(%size(ERRCD))
     D  @ERCON                 9     15
     D  @ERDTA                17    116

/3321d SpcDta          s            512    based(SpcDtaP)
     d SplEntryP       s               *

     d lenspc          s             10i 0

      *             Output queue name
     D QOUTQI          DS
     D  QOUTQ                  1     10
     D  QQLIB                 11     20

     d usrsp           s             20    inz('MYUSRSPC  QTEMP')

     d run             pr                  extproc('system')
     d  cmd                         512    const

     d memcpy          pr                  extproc('memcpy')
     d  target                         *   value
     d  source                         *   value
     d  length                       10i 0 value

      /copy qsysinc/qrpglesrc,quslspl

     d totalPages      s             10i 0

     c     *entry        plist
     c                   parm                    inOutQ           10
     c                   parm                    inOutqLib        10

      /free
       qoutq = inOutq;
       qqlib = inOutqLib;
       run('dltusrspc qtemp/myusrspc');
      /end-free

     C                   CALL      'QUSCRTUS'
     C                   PARM      USRSP         USRSPC
     C                   PARM      *BLANK        ATTRIB           10
     C                   PARM      65536         LENSPC
     C                   PARM      X'00'         VALUE             1
     C                   PARM      '*CHANGE '    PUBAUT           10
     C                   PARM      'SpyGlass'    @TEXT            50

     c                   CALL      'QUSPTRUS'
     c                   PARM      USRSP         USRSPC           20
     c                   PARM                    SpcDtaP

      /FREE
       reset errcd;
      /END-FREE
     C                   CALL      'QUSLSPL'
     C                   PARM      USRSP         USRSPC           20
     C                   PARM      'SPLF0300'    FMTNAM            8
     C                   PARM      '*ALL'        QUSER            10
     C                   PARM                    QOUTQI
     C                   PARM      '*ALL'        QFORM            10
     C                   PARM      '*ALL'        QUSDTA           10
     C                   PARM                    ERRCD

      /FREE
       apiHeader = spcDta;
       strPos = ah_listOffSet;
       for i = 1 to ah_listCount;
         memcpy(%addr(qusf0300):spcDtaP+strPos:%size(qusf0300));
         totalPages += QUSSTP;
         strPos += %size(QUSF0300);
       endfor;
       dsply totalPages;
       *inlr = '1';
      /END-FREE

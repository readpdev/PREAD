     h dftactgrp(*no)

     D SPM             Pr
     D  MSGdta                       50    VALUE

     d lillianDate     s             10i 0
     d dow             s             10i 0
     d dowTxtA         s             10    dim(7) ctdata

      * Convert to lillian date.
     d ceedays         pr                  opdesc
     d  isodate                       8    options(*varsize)
     d  format                        8    const
     d  lillianDate                  10i 0
     d  fc                           12

      * Retrieve day of week code.
     d ceedywk         pr                  opdesc
     d  lillianDate                  10i 0
     d  dow                          10i 0
     d  fc                           12

      * Feedback code.
     d fc              ds
     d  fcMsgSev                      5u 0
     d  fcMsgNo                       5u 0
     d  fcFlags                       1
     d  fcFacID                       3
     d  fcISI                        10u 0

     d outTxt          s             50
     d isodate         s              8
     d isodateWrk      s               d   datfmt(*iso)

     d                sds
     d pgmq              *proc

     c     *entry        plist
     c                   parm                    isodateIn         8

     c                   if        %parms = 0
     c                   move      *date         isodateWrk
     c                   else
     c     *iso0         move      isodateIn     isodateWrk
     c                   endif
     c     *iso0         move      isodateWrk    isodate

      * Convert iso date format to lillian date format.
     c                   callp     ceedays(isodate:'YYYYMMDD':lillianDate:fc)

      * Retrieve day of week from lillian date.
     c                   callp     ceedywk(lillianDate:dow:fc)

     c                   callp     spm(isodate + ' is a ' + dowTxtA(dow))

     c                   eval      *inlr = '1'
      **************************************************************************
     P SPM             B

      * SEND PROGRAM MESSAGE

     D SPM             PI
     D  MSGdta                       50    VALUE

     D msgf            S             20    INZ('QCPFMSG   *LIBL')
     D MSGDTALEN       S             10I 0 INZ(0)
     d stackCnt        s             10i 0 inz(0)

     c                   eval      msgDtaLen = %len(%trimr(msgdta))

     C                   CALL      'QMHSNDPM'
     C                   PARM      'CPF9898'     MSGID             7
     C                   PARM                    MSGF
     C                   PARM                    MSGDTA
     C                   PARM                    MSGDTALEN
     C                   PARM      '*INFO'       MSGTYPE          10
     C                   PARM                    pgmq
     C                   PARM      2             STACKCNT
     C                   PARM      ' '           MSGKEY            4
     C                   PARM      ' '           APIERR          116

     P                 E
**ctdata dowTxtA
Sunday
Monday
Tuesday
Wednesday
Thursday
Friday
Saturday

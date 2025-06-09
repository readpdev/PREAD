      /COPY QSYSINC/QRPGLESRC,QDFRTVFD
     d apiErr          DS
     d  erBytPrv                     10i 0 inz(%size(apiErr))
     d  erBytAvl                     10i 0
     d  erMsgID                       7a
     d  erRsv1                        1a
     d  erMsgData                    80a

     D RVAR            S          20000
     D RLEN            S             10I 0 INZ(%SIZE(RVAR))
     D RFMT            S              8    INZ('DSPF0100')
     D RFNAM           S             20    INZ('SPYKEYMNTD*LIBL')

     C                   CALL      'QDFRTVFD'
     C                   PARM                    RVAR
     C                   PARM                    RLEN
     C                   PARM                    RFMT
     C                   PARM                    RFNAM
     C                   PARM                    APIERR

      * BASE FILE INFO.
     C                   EVAL      QDFFBASE = RVAR
     C                   EVAL      QDFFINFO = %SUBST(RVAR:QDFFINOF:
     C                             %LEN(QDFFINFO))

     C                   EVAL      *INLR = '1'

      *%METADATA                                                       *
      * %TEXT View object source.                                      *
      *%EMETADATA                                                      *
     F*VOSD      CF   E             WORKSTN USROPN SFILE(SFL01:RRN)

     d usQName         DS
     d  usName                       10a   inz('OBJSPC')
     d  usLib                        10a   inz('QTEMP')
     d usExtAtr        S             10a   inz('OBJL')
     d usISize         S             10i 0 inz(500)
     d usIVal          S              1a   inz(X'00')
     d usPubAut        S             10a   inz('*ALL')
     d usText          S             50a   inz('User Space for Object List')
     d usReplace       S             10a   inz('*NO')

     d olFormat        S              8a   inz('OBJL0400')
     d OBJL0400        DS           202    BASED(OBJPTR)
     d  SRCFNAM                      10a   OVERLAY(OBJL0400:1)
     d  SRCFLIB                      10a   OVERLAY(OBJL0400:11)
     d  SRCFMBR                      10a   OVERLAY(OBJL0400:21)

     d apiErr          DS
     d  erBytPrv                     10i 0 inz(%size(apiErr))
     d  erBytAvl                     10i 0
     d  erMsgID                       7a
     d  erRsv1                        1a
     d  erMsgData                    80a

     D SPACEHDR        DS           140    BASED(SPCPTR)
     D  OFFSET                       10I 0 OVERLAY(SPACEHDR:125)
     D  #ENTRIES                     10I 0 OVERLAY(SPACEHDR:133)
     D  ENTSIZE                      10I 0 OVERLAY(SPACEHDR:137)

     d ObjQName        DS
     d  ObjName                      10a
     d  ObjLib                       10a

     c     *entry        plist
     c                   parm                    pObjName         10
     c                   parm                    pObjLib          10
     c                   parm                    pObjType         10

      * ATTEMPT TO DELETE USER SPACE IN CASE OF PREVIOUS ABEND.
     C                   CALL      'QUSDLTUS'
     C                   PARM                    USQNAME
     C                   PARM                    APIERR

      * Create user space
     c                   call      'QUSCRTUS'
     c                   parm                    usQName
     c                   parm                    usExtAtr
     c                   parm                    usISize
     c                   parm                    usIVal
     c                   parm                    usPubAut
     c                   parm                    usText
     c                   parm                    usReplace
     c                   parm                    apiErr

      * GET POINTER TO USER SPACE.
     C                   CALL      'QUSPTRUS'
     C                   PARM                    USQNAME
     C                   PARM                    SPCPTR

      * LIST OBJECTS TO USERSPACE.
     C                   EVAL      OBJNAME = POBJNAME
     C                   EVAL      OBJLIB = POBJLIB
     c                   call      'QUSLOBJ'
     c                   parm                    usQName
     c                   parm                    olFormat
     c                   parm                    ObjQName
     c                   parm                    PObjType
     c                   parm                    apiErr

     C                   EVAL      OBJPTR = SPCPTR + OFFSET

     C                   EVAL      *INLR = '1'

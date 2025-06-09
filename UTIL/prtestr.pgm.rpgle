      *%METADATA                                                       *
      * %TEXT PREAD'S TEST PROGRAM                                     *
      *%EMETADATA                                                      *
     h bnddir('SPYBNDDIR') dftactgrp(*no)

      /copy @mmcommonr
      /copy @mmlckctlr
      /copy @mmrevinfr
      /copy @mmrevlstr
      /copy @mmcsnoter

     d RqstPtr         s               *
     d RespPtr         s               *
     d RespLen         s             10i 0

     d RtnCode         s              7
     d RtnCodeInt      s             10i 0

     d UsrIds          ds
     d  UsrValLen                     5s 0 inz(%len(UsrVal))
     d  UsrVal                        8    inz('USERNAME')
     d  UsrIdLen                      5s 0

     d VarLen          s              5s 0

     c     *entry        plist
     c                   parm                    OpCode            5
     c                   parm                    Batch#           10
     c                   parm                    Sequence#         9 0
     c                   parm                    RevID            10 0
     c                   parm                    LockType          5 0
     c                   parm                    UserID           10
     c                   parm                    NodeID           32
     c                   parm                    CheckOutPath    100
     c                   parm                    CI_CO_Comment   100
     c                   parm                    Key1             10
     c                   parm                    Key2             10

     c                   eval      Csr_OpCode = OpCode
     c                   eval      Csr_Key1 = Key1
     c                   eval      Csr_Key2 = Key2

     c                   select

     c                   when      Csr_OpCode = Op_Lock or
     c                             Csr_OpCode = Op_Unlock
     c                   exsr      FormatLckRqst
     c                   eval      RtnCode = LckCtl(RqstPtr:
     c                             RespPtr:RespLen:UserID:NodeID)
     c                   if        RtnCode = ' '
     c                   eval      RevContHed = %str(RespPtr:RespLen)
     c                   endif

     c                   when      Csr_OpCode = Op_LockList
     c                   eval      Llr_DataSize = %len(UsrIds) +
     c                             %len(%trim(UserID))
     c                   eval      RqstPtr = %addr(CsStdRqstHed)
     c                   eval      %str(RqstPtr + %len(CsStdRqstHed):
     c                             %len(LckLstRqstHed) + 1) = LckLstRqstHed
     c                   exsr      Add_User
     c                   eval      RtnCode = LckCtl(RqstPtr:
     c                             RespPtr:RespLen:UserID:NodeID)
     c                   eval      RevContHed = %str(RespPtr:RespLen)

     c                   when      Csr_OpCode = Op_RevList
     c                   eval      Rlr_RevID = RevID
     c                   eval      RqstPtr = %addr(CsStdRqstHed)
     c                   eval      %str(RqstPtr + %len(CsStdRqstHed):
     c                             %len(RevLstRqst) + 1) = RevLstRqst
     c                   eval      RtnCodeInt =
     c                             GetRevLst(RqstPtr:RespPtr:RespLen)
     c                   eval      RevListItem = %str(RespPtr:RespLen)

     c                   when      OpCode = 'RINFO'
     c                   eval      RtnCodeInt = GetRevSts(RevID:RespPtr:RespLen)
     c                   eval      RevContHed = %str(RespPtr:RespLen)

     c                   when      OpCode = 'LKSTS'
     c                   eval      RtnCodeInt = LockStatus(RevID)

     c                   endsl

     c                   eval      *inlr = '1'

      **************************************************************************
     c     Add_CO_Path   begsr

      * Tag on check out path.
     c                   eval      VarLen = %len(%trim(CheckOutPath))
     c                   eval      %str(RqstPtr + %len(%str(RqstPtr)):
     c                             %len(Varlen) + %len(%trim(CheckoutPath)) + 1)
     c                             = %editc(VarLen:'X') + %trim(CheckOutPath)
     c                   endsr

      **************************************************************************
     c     Add_User      begsr

      * Tag on user ids.

     c                   eval      UsrIdLen = %len(%trim(UserId))
     c                   eval      %str(RqstPtr + %len(%str(RqstPtr)):
     c                             %len(UsrIds) + UsrIdLen + 1) =
     c                             UsrIds + %trim(UserID)

     c                   endsr

      **************************************************************************
     c     Add_Comment   begsr

      * Tag on check-in/check-out comment.

     c                   eval      VarLen = %len(%trim(CI_CO_Comment))
     c                   eval      %str(RqstPtr + %len(%str(RqstPtr)):
     c                             %len(VarLen) + %len(%trim(CI_CO_COMMENT))+1)=
     c                             %editc(VarLen:'X') + %trim(CI_CO_COMMENT)

     c                   endsr

      **************************************************************************
     c     FormatLckRqst begsr

      * Format the lock request header.

     c                   eval      Lrh_BatchNum = Batch#
     c                   eval      Lrh_SeqNum = Sequence#
     c                   eval      Lrh_RevID = RevID
     c                   eval      Lrh_LockType = LockType
     c                   eval      Lrh_NumUsrFld = 1
     c                   eval      RqstPtr = %addr(CsStdRqstHed)
     c                   eval      %str(RqstPtr + %len(CsStdRqstHed):
     c                             %len(LckRqstHed) + 1 ) = LckRqstHed
     c                   exsr      Add_CO_Path
     c                   exsr      Add_Comment

     c                   endsr

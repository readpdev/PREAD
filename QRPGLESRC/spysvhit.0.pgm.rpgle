/*    * CRTOPT
/*    * CRTxxx CRTPGM PGM(&O/&N) BNDSRVPGM(SPYSVDB) +
/*    * CRTxxx        ACTGRP(SPYSVAG)
      **************************************************************************
      * SPYSVLNK - StaffView read Spylink hit list
      **************************************************************************

      * data and prototypes for StaffView functions
     d/copy QRPGLESRC,@SPYSVDB

      * SpyLink hit list filter
     d filterDS        ds          1280
     d fiArr                          1a   dim(%size(filterDS))
     d fiHdrDS         ds                  based(fiHdrDSp)
     d fiDSlen                       10i 0
     d fiDocCls                      10a
     d fiDocDesc                     30a
     d fiIdxCnt                      10i 0
     d fiDefOff                      10i 0
     d fiValOff                      10i 0
     d fiDefDS         ds                  based(fiDefDSp)
     d fiDefn                        44a   dim(7)
     d  fiDname                      10a   overlay(fiDefn:1)
     d  fiDdesc                      30a   overlay(fiDefn:11)
     d  fiDlen                       10i 0 overlay(fiDefn:41)
     d fiValDS         ds                  based(fiValDSp)
     d fiStrDate                      8a
     d fiEndDate                      8a
     d fiVals                       100a   dim(7)
     d  fiVdata                      99a   overlay(fiVals:1)
     d  fiVfill                       1a   overlay(fiVals:100)

      * SpyLink record
     d idxRcdDS        ds          1280    based(idxRcdDSp)
     d irArr                          1a   dim(%size(idxRcdDS))
     d irHdrDS         ds                  based(irHdrDSp)
     d irDSlen                       10i 0
     d irDocCls                      10a
     d irDocDesc                     30a
     d irDocID                       10a
     d irDocSeq                      10i 0
     d irIdxCnt                      10i 0
     d irDefOff                      10i 0
     d irValOff                      10i 0
     d irDefDS         ds                  based(irDefDSp)
     d irDefn                        44a   dim(7)
     d  irDname                      10a   overlay(irDefn:1)
     d  irDdesc                      30a   overlay(irDefn:11)
     d  irDlen                       10i 0 overlay(irDefn:41)
     d irValDS         ds                  based(irValDSp)
     d irStrPage                     10i 0
     d irEndPage                     10i 0
     d irArcDate                     10i 0
     d irVals                       100a   dim(7)
     d  irVdata                      99a   overlay(irVals:1)
     d  irVfill                       1a   overlay(irVals:100)

      * hit list return data
     d SHopCde         s             10i 0
     d rtnVal          s            768a   dim(50)

      * SpyLink structure
     d slSDTp          s               *   inz(%addr(rtnVal))
     d slSDT           ds           768    occurs(50) based(slSDTp)
     d  slRVal                       70    dim(7)
     d  slRArcDt                      8a
     d  slRFill1                      8a
     d  slDocID                      10a
     d  slDocSeq                      9a
     d  slStrPg                       9a
     d  slEndPg                       9a
     d  slSecFlg                      3a
     d  slType                        1a
     d  slFilNam                      8a
     d  slFilExt                      2a
     d  slFilLib                     10a
     d  slBig5                       50a
     d  slDocLoc                      1a
     d  slNotes                       1a
     d  slPct                         5a
     d  slTotPg                       9a
     d  slRDOfs                       9a
     d  slRDFil                       9a
     d  slLmtScr                      1a

      * work fields
     d hit             s             10i 0
     d idx             s             10i 0

      * parameters
     d rtnCde          s             10i 0                                      return code
     d opCode          s             10a                                        operation code
     d docClass        s             10a                                        document class
     d rqsCnt          s             10i 0                                      return code
     d rtnCnt          s             10i 0                                      return code
     d hitList         s           1280a   dim(10)                              SpyLink records

      * ---------------------------------------------------------------------- *
      * mainline                                                               *
      * ---------------------------------------------------------------------- *

     c     *entry        plist
     c                   parm                    rtnCde                         return code
     c                   parm                    opCode                         operation code
     c                   parm                    docClass                       document class
     c                   parm                    filterDS                       SpyLink filter
     c                   parm                    rqsCnt                         request count
     c                   parm                    rtnCnt                         return count
     c                   parm                    hitList                        SpyLink records

     c                   eval      rtnCde = 0

      * check for valid operation code
     c                   select
     c                   when      opCode = 'QUIT'
     c                   eval      *inlr = *on
     c                   return
     c                   when      opCode = 'SELCR' or
     c                             opCode = 'RDGT'
     c                   exsr      $hitList
     c                   other
     c                   eval      rtnCde = 601                                 invalid op code
     c                   return
     c                   endsl

     c                   return
      * ---------------------------------------------------------------------- *
      * get SpyLinks hit list                                                  *
      * ---------------------------------------------------------------------- *
     c     $hitList      begsr

     c                   if        opCode = 'SELCR'
     c                   eval      SHopCde = 0                                  SELCR
     c                   else
     c                   eval      SHopCde = 1                                  RDGT
     c                   endif

      * check for valid filter structure
     c                   eval      fiHdrDSp  = %addr(filterDS)
     c                   if        fiDocCls = *blanks or
     c                             fiIdxCnt < 1 or fiIdxCnt > 7
     c                   eval      rtnCde = 602                                 invalid index record
     c                   return
     c                   endif

      * setup hit list filter structure
     c                   eval      fiDefDSp  = %addr(fiArr(fiDefOff+1))
     c                   eval      fiValDSp  = %addr(fiArr(fiValOff+1))

      * get SpyLinks
     c                   eval      rtnCde = wvuGetSpyH(SHopCde: fiDocCls:
     c                                                 fiIdxCnt: fiVals:
     c                                                 fiStrDate: fiEndDate:
     c                                                 rqsCnt: rtnCnt: rtnVal)
     c                   if        rtnCde = 0

      * read results
     c                   if        rtnCnt > 0
     c     1             do        rtnCnt        hit
     c     hit           occur     slSDT

      * remap data
     c                   eval      idxRcdDSp = %addr(hitList(hit))
     c                   clear                   idxRcdDS

      * setup SpyLink structure
     c                   eval      irHdrDSp  = %addr(idxRcdDS)
     c                   eval      irDefOff  = %size(irHdrDS)
     c                   eval      irValOff  = irDefOff + %size(irDefDS)
     c                   eval      irDSlen   = irValOff + %size(irValDS)
     c                   eval      irDefDSp  = %addr(irArr(irDefOff+1))
     c                   eval      irValDSp  = %addr(irArr(irValOff+1))

     c                   eval      irDocCls  = fiDocCls
     c                   eval      irDocDesc = fiDocDesc
     c                   eval      irDocID   = slDocID
     c                   move      slDocSeq      irDocSeq
     c                   eval      irIdxCnt  = fiIdxCnt
     c                   eval      irDefn    = fiDefn
     c                   move      slStrPg       irStrPage
     c                   move      slEndPg       irEndPage
     c                   move      slRArcDt      irArcDate
      * index data
     c     1             do        irIdxCnt      idx
     c                   eval      irVdata(idx) = slRVal(idx)
     c                   enddo     1

     c                   enddo     1
     c                   endif

     c                   endif

     c                   endsr

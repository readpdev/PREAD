      *%METADATA                                                       *
      * %TEXT Archive Exit Pgm - Reformat Index Data                   *
      *%EMETADATA                                                      *
      * Program operation code
     d opCode          S             10

      * DocLink ID structure
     d dLinkID         DS
     d dlRnam                        10
     d dlJnam                        10
     d dlPnam                        10
     d dlUnam                        10
     d dlUdat                        10
     d dlRtypID                      10
     d dlBatch                       10
     d dlBatSeq                       9p 0
     d dlStrRRN                       9p 0
     d dlEndRRN                       9p 0
     d dlType                         5

      * DocLink data
     d dLinkLen        S              5u 0
     d dLinkCnt        S              5u 0
     d dLinkDta        S          32767

      * User index data
     d uLinkLen        S              5u 0
     d uLinkCnt        S              5u 0
     d uLinkDta        S          32767

      * User index data elements
     d LinkData        DS                  based(pLinkData)
     d ldFldNam                      32a
     d ldFldTyp                       1a
     d ldFldLenA                      3
     d ldFldLen                       3s 0 overlay(ldFldLenA)

      * User index data value
     d ldDtaDS         S            999    based(pldDtaDS)

      * Work fields
     d IdxVal          S             99a
     d x               S              5u 0
     d rc              S             10i 0

     c     *entry        plist
     c                   parm                    opCode
     c                   parm                    dLinkID
     c                   parm                    dLinkLen
     c                   parm                    dLinkCnt
     c                   parm                    dLinkDta
     c                   parm                    uLinkLen
     c                   parm                    uLinkCnt
     c                   parm                    uLinkDta

     c                   select
     c                   when      opCode = 'QUIT'
     c                   eval      *inlr = *on
     c                   other
     c                   exsr      PrcDocLink
     c                   endsl

     c                   return

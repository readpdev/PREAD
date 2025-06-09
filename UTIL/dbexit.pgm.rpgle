      *
      * Custom database access user exit program.
      *
      * Document information structure.
     d document        ds                  qualified
     d  name                         10
     d  job                          10
     d  program                      10
     d  user                         10
     d  userData                     10
     d  type                         10
     d  ID                           10
     d  linkSeqNbr                    9  0
     d  startRRN                      9  0
     d  endRRN                        9  0
     d  fileExt                       5
     d  createDate                    8

      * Index information structure.
     d index           ds                  qualified based(indexP)
     d  name                         32
     d  type                          1
     d  length                        3s 0
     d  data                         99

     d linkLength      s              5i 0
     d linkCount       s              5i 0
     d linkData        s          32767
     d userLinkLen     s              5i 0
     d userLinkCount   s              5i 0
     d userLinkData    s          32767

     d i               s              5i 0

     c     *entry        plist
     c                   parm                    opcode           10
     c                   parm                    document
     c                   parm                    linkLength
     c                   parm                    linkCount
     c                   parm                    linkData
     c                   parm                    userLinkLen
     c                   parm                    userLinkCount
     c                   parm                    userLinkData

      /free
       indexP = %addr(linkData);

       select;
         when document = 'docclass1';
         when document = 'docclass2';
         when document = 'docclass3';
       endsl;

       indexP = indexP + %size(index) - %size(index.data) + index.length;

       //Change the return values for update.
       userLinkLen = linkLength;
       userLinkCount = linkCount;
       userLinkData = linkData;

       *inlr = *on;

       return;

      /end-free

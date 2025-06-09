      *
      * Sample exit program illustrating the ability to place custom information in
      * a specific link field.
      *
      * Also reference the iSeries Administator Guide under Defining Custom Database Access.
      * This will describe in detail where and how to implement the exit program. A sample
      * program is also listed in the section from which some of the following code was
      * derived.

      * Report directory file. Can also be coded against the image directory (MIMGDIR).
     fmrptdir7  if   e           k disk

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
       for i = 2 to linkCount;
         indexP = indexP + %size(index) - %size(index.data) +
           index.length;
         if index.name = 'CRTTIME'; //Assumes that the index name is CRTTIME.
           chain document.ID mrptdir7;
           if %found; //If the document is found in the directory update the index.
             index.data = %subst(%editc(timfop:'X'):4:6);
             leave;
           endif;
         endif;
       endfor;
       //Change the return values to cause update.
       userLinkLen = linkLength;
       userLinkCount = linkCount;
       userLinkData = linkData;
       *inlr = '1';
       return;
      /end-free

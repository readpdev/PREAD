      *%METADATA                                                       *
      * %TEXT Add notes for a specific image docClass                  *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('MYBNDDIR')

     f@000000400if   e           k disk
     fmnotdir   uf a e           k disk
     fn000000000uf a e           k disk

      /copy 'UTIL/@run.rpgleinc'

     c     *entry        plist
     c                   parm                    sampleBatch      10

      /free
       dow not %eof(@000000400);
         read @000000400;
         if %eof or ldxnam = sampleBatch;
           iter;
         endif;
         setll sampleBatch mnotdir;
         reade sampleBatch mnotdir;
         dow not %eof(mnotdir);
           ndbnum = ldxnam;
           ndbseq = lxspg;
           write notdir;
           reade sampleBatch mnotdir;
         enddo;
         setll sampleBatch n000000000;
         reade sampleBatch n000000000;
         dow not %eof(n000000000);
           nabnum = ldxnam;
           nabseq = lxspg;
           write notdta;
           reade sampleBatch n000000000;
         enddo;
       enddo;
       *inlr = '1';
      /end-free

      *%METADATA                                                       *
      * %TEXT Format Vecellio Workflow Index Input File                *
      *%EMETADATA                                                      *
      * formats Vecellio workflow input index file used in popmisslnk
      * casedata file is in rlink file format.
     fcases     if   e             disk    rename(cases:caserec)
     fcasedata  o    e             disk
      /free
       dow 1 = 1;
         read cases;
         if %eof;
           leave;
         endif;
         clear lnkndex;
         ldxnam = batchid;
         monitor;
         lxseq = %int(imageno);
         on-error;
           iter;
         endmon;
         lxiv1 = ponbr;
         lxiv2 = vendno;
         lxiv3 = invono;
         lxiv4 = invotype;
         lxiv5 = invodate;
         lxiv6 = invoamt;
         write lnkndex;
       enddo;
       *inlr = '1';
      /end-free

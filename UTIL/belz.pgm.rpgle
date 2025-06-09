      *%METADATA                                                       *
      * %TEXT Convert Hex to Character                                 *
      *%EMETADATA                                                      *
     h dftactgrp(*no)

      *
      * Convert hex to char.
      *

     fbelz      if   e             disk    rename(belz:belzrcd)
     foutput    o    e             disk    rename(output:outputrcd)

      *
     D CVTch           PR                  EXTPROC('cvtch')
     D  RCV                            *   VALUE
     D  SRC                            *   VALUE
     D  RCVLEN                       10I 0 VALUE

     d input           s            512

      /free
       read belz;
       dow not %eof;
         input = %trim(fld4) + '40' + %trim(fld6);
         monitor;
           cvtch(%addr(outputfld):%addr(input):512);
         on-error;
         endmon;
         write outputrcd;
         read belz;
       enddo;

       *inlr = *on;
      /end-free

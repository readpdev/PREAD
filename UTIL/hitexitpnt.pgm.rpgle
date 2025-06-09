      *%METADATA                                                       *
      * %TEXT Hit list application exit point example                  *
      *%EMETADATA                                                      *
T5783h dftactgrp(*no) actgrp(*caller)

      * Index exit point example program.

      * This sample program demonstrates the ability to validate individual
      * index records prior to returning index data to green screen, client or
      * api requests.

      * This copy member contains the prototype for the procedure pointer passed
      * to the exit program and all necessary constants needed for the
      * conversation.

      /copy 'UTIL/@linkexit.rpgleinc'

     d name            s             25
     d value           s             25
     d i               s             10i 0
     d ndxvals         s            128    dim(7)

      * A procedure pointer is passed to the exit program. The procedure
      * is embedded in the hit list application and is responsible for
      * managing the conversation buffer that is used between the hit
      * list program and the exit program.

      * The conversation is based on a name/value pair concept.

     c     *entry        plist
     c                   parm                    exitPgmBufP
      /free
       i = 0;
       // Continue to receive data until end of data is reached (EOD);
       dow exitPgmBufHndlr(BH_OP_GET:%addr(name):%addr(value)) <> BH_RTN_EOD;
         select;
           when name = BH_NVP_QUIT;
             // A quit operation has been received. Shut down.
             *inlr = '1';
           when name = BH_NVP_NDXVAL;
             // Store a list of index values for the current document.
             i = i + 1;
             ndxvals(i) = value;
           when name = BH_NVP_CHKCLS;
             // This exit program responds to the check request with yes.
             // This particular operation is useful in that it prevents the
             // hit application from unneccessarily checking the same document
             // class over and over again. You can respond with BH_CHKCLS_NO
             // if this document class is not to be checked.
             exitPgmBufHndlr(BH_OP_PUT:BH_NVP_CHKCLS:BH_CHKCLS_YES);
         endsl;
       enddo;

       if i > 0;
         // This is a response to the hit list program to allow this hit
         // to be sent. A response of BH_ADDHIT_NO would prevent the hit
         // from being returned.
         exitPgmBufHndlr(BH_OP_PUT:BH_NVP_ADDHIT:BH_ADDHIT_YES);
       endif;

       return;
      /end-free

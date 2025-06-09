      *%METADATA                                                       *
      * %TEXT Retrieve communication resources                         *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller)

      /copy qsysinc/qrpglesrc,qgyrhrcm
      /copy qsysinc/qrpglesrc,qusec

     d CMNCGY          c                   2

     d rtvhdwrsc       pr                  extproc('QgyRtvHdwRscList')
     d  receiver                  32767    options(*varsize)
     d  rcvrLen                      10i 0 const
     d  format                        8    const
     d  category                     10i 0 const
     d  error                              likeds(qusec)


     d header          ds                  likeds(QGYRRVH)
     d entries         ds                  likeds(QGYL0100) based(entriesP)
     d offset          s             10i 0
     d i               s             10i 0
     d error           ds                  likeds(qusec)

      /free
       clear error;
       error.qusbprv = %size(error);
       rtvhdwrsc(header:32767:'RHRL0100':CMNCGY:error);
       entriesP = %addr(header);
       offset = %size(header);
       for i = 1 to header.QGYNBRRR;
         entriesP = entriesP + offset;
         offset = offset + header.qgyrel;
       endfor;
       *inlr = '1';
      /end-free

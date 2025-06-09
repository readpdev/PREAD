      *%METADATA                                                       *
      * %TEXT Retrieve communication resources                         *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller)

      /copy qsysinc/qrpglesrc,qgyrhrcm
      /copy qsysinc/qrpglesrc,qusec

     d CMNRSC          c                   2

     d rtvhdwrsc       pr                  extproc('QgyRtvHdwRscList')
     d  receiver                       *   value options(*string)
     d  rcvrLen                      10i 0 const
     d  format                        8    const
     d  category                     10i 0 const
     d  error                              likeds(qusec)
     d hardwareHdr     ds                  likeds(QGYRRVH)
     d  entryList

     d entries         ds                  likeds(QGYL0100) based(entriesP)

     d error           ds                  likeds(qusec)

     d*rtvcmnrsc       pr                  extpgm('QGYRHRI')
     d* receiver                           likeds(RHRI0100)
     d* rcvrLen                      10i 0 const
     d* format                        8    const
     d* resourceName                 10
     d* error                              likeds(qusec)
     d**resourceInfo   ds                  likeds(rhri0100)

      /free
       clear error;
       error.qusbprv = %size(error);
       rtvhdwrsc(%addr(hardwareHdr):%size(hardwareHdr):'RHRL0100':CMNRSC:error);
       *inlr = '1';
      /end-free

     h dftactgrp(*no) actgrp(*caller) bnddir('QUSAPIBD')

      /copy qsysinc/qrpglesrc,qusec

     d calcHash        pr                  extproc('Qc3CalculateHash')
     d  inputData                     7
     d  inputLen                     10i 0
     d  inputFmt                      8
     d  algDesc                            likeds(algdesc)
     d  algFmt                        8
     d  cryptoSP                      1
     d  cryptoNam                    10
     d  hash                         16
     d  error                              like(qusec)

     d inputData       s              7    inz('1058E22')
     d inputLen        s             10i 0 inz(%len(inputData))
     d inputFmt        s              8    inz('DATA0100')
     d algFmt          s              8    inz('ALGD0100')
     d ANY_CSP         s              1    inz('0')
     d cryptoNam       s             10    inz
     d hash            s             16

     d algDesc         ds                  qualified
     d  token                         8
     d  finalOp                       1    inz(OPER_FINAL)

     d crtAlgCtx       pr                  extproc('Qc3CreateAlgorithmContext')
     d  algDesc                            likeds(algCtx)
     d  algFmt                        8
     d  algToken                      8
     d  error                              like(qusec)

     d algCtx          ds                  qualified
     d  algorithm                    10i 0 inz(MD5_ALG)
     d ctxToken        s              8

     d destroyToken    pr                  extproc('Qc3CreateAlgorithmContext')
     d  ctxToken                      8
     d  error                              like(qusec)

     d MD5_ALG         c                   1
     d OPER_FINAL      c                   '1'
     d CTX_FMT         s              8    inz('ALGD0500')

      /free
       clear qusec;
       qusbprv = %len(qusec);
       crtAlgCtx(algCtx:CTX_FMT:algDesc.token:qusec);
       clear qusec;
       qusbprv = %len(qusec);
       calcHash(inputData:inputLen:inputFmt:algDesc:algFmt:
         ANY_CSP:cryptoNam:hash:qusec);
       clear qusec;
       qusbprv = %len(qusec);
       destroyToken(algDesc.token:qusec);
       *inlr = '1';
      /end-free

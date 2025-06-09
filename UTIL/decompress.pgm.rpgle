     h dftactgrp(*no) main(main)

     d fopen           pr              *   extproc('_C_IFS_fopen')
     d  path                           *   value options(*string:*trim)
     d  mode                           *   value options(*string:*trim)

     d fread           pr            10i 0 extproc('_C_IFS_fread')
     d  buffer                         *   value
     d  bufsiz                       10i 0 value
     d  bufcnt                       10i 0 value
     d  fh                             *   value

     d fclose          pr            10i 0 extproc('_C_IFS_fclose')
     d  fh                             *   value

     d main            pr                  extpgm('DECOMPRESS')

     d unpack          pr                  extpgm('SPYUNPACK')
     d  sourceData                32767
     d  sourceLen                    10i 0
     d  resultData                32767
     d  resultLen                    10i 0

     d fh              s               *
     d path            s            256    inz('XZ000001')
     d mode            s              5    inz('rb')
     d buffer          s           1024
     d rc              s             10i 0
     d resultLen       s             10i 0
     d sourceBuf       s          32767
     d resultBuf       s          32767
     d sourceLen       s             10i 0 inz(%len(sourceBuf))

     p main            b
     d                 pi
      /free
       fh = fopen('/IFSOptical/VOLUMEAX/SPYGLASS/PR873DTA/DFTFOLDER/S000000101':
         'rb');
       dow fread(%addr(buffer):%len(buffer):1:fh) > 0;
         sourceBuf = buffer;
         clear resultBuf;
         clear resultLen;
         //unpack(sourceBuf:sourceLen:resultBuf:resultLen);
      /end-free
     C                   CALL      'SPYUNPACK'                                   buffer 1
     C                   PARM                    PAK
     C                   PARM                    SPACE
     C                   PARM                    NPK1
     C                   PARM                    OUTLTH
      /free
       enddo;
       fclose(fh);
       return;
      /end-free
     p                 e

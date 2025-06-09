     h dftactgrp(*no) bnddir('QC2LE')

     fpclmsg    if   f   60        disk

     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         255    const
     d  len                          15  5 const
     d cmd             s            256

     d input           ds
     d  buf                          60
     d line            s             10i 0 inz(0)
     d msgid           ds
     d  msgpfx                        3    inz('PCL')
     d  msgnbr                        4s 0 inz
     d   msgnbr_c                     4    overlay(msgnbr)
     d msg             s             60
     d start           s             10i 0
     d end             s             10i 0
     d len             s             10i 0
     d sq              s              1    inz('''')
     d wrkInt          s             10i 0
     d tokens          s              4    inz(x'405c6105')

     c     *entry        plist
     c                   parm                    msgf             10

      /free
       dow (1 = 1);
         read pclmsg input;
         if %eof;
           leave;
         endif;

         line = line + 1;
         if line = 1;
           start = %check(' /*':input);
           end = %checkr(tokens:input);
           msg = 'PCL - ' + %subst(input:start:end-start+1);
         endif;
         if line = 2;
           start = %scan('-':input) + 1;
           end = %checkr(tokens:input);
           len = end-start+1;
           %subst(msgnbr_c:%size(msgnbr_c)-len+1:len) =
             %trim(%subst(input:start:len));
           cmd = 'ADDMSGD MSGID(' + msgid + ') msgf(' + %trim(msgf) + ') msg(' +
                 sq + %trim(msg) + sq + ')';
           run(cmd:%len(%trim(cmd)));
           line = 0;
         endif;
       enddo;

       *inlr = '1';
      /end-free

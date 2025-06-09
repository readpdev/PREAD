      *%METADATA                                                       *
      * %TEXT Change compiler create command defaults                  *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*new) bnddir('QC2LE')

     d run             pr            10i 0 extproc('system')
     d   command                       *   value options(*string)

     d printf          pr            10i 0 extproc('printf')
     d  string                         *   value options(*string)

     d                 ds
     d  commandData                  12    dim(16) ctdata
     d  name                         10    overlay(commandData)
     d  dbgview                       1  0 overlay(commandData:*next)
     d  output                        1  0 overlay(commandData:*next)

     d debugOption     s             20    dim(4) ctdata

     d sq              c                    ''''
     d newLine         c                    x'1500'
     d cmd             s            256
     d i               s             10i 0

     c     *entry        plist
     c                   parm                    tgtrls            8

      /free
       for i = 1 to %elem(name);
         cmd = 'chgcmddft cmd(' + %trim(name(i)) + ') newdft(' + sq +
           'tgtrls(' + %trim(tgtrls) + ')';
         if dbgview(i) > 0;
           cmd = %trimr(cmd) + ' ' + debugOption(dbgview(i));
         endif;
         if output(i) > 0;
           cmd = %trimr(cmd) + ' output(*print)';
         endif;
         cmd = %trimr(cmd) + sq + ')';
         if run(cmd) <> 0;
           printf('Error: ' + %trim(cmd) + newLine);
           leave;
         endif;
       endfor;
       *inlr = '1';
       return;
      /end-free

**ctdata commandData
CRTBNDC   10
CRTBNDCL  11
CRTBNDCPP 10
CRTBNDRPG 11
CRTCLMOD  11
CRTCLPGM  00
CRTCMOD   10
CRTCPPMOD 10
CRTPGM    00
CRTRPGMOD 11
CRTRPGPGM 00
CRTSQLCI  41
CRTSQLCPPI40
CRTSQLRPG 30
CRTSQLRPGI40
CRTSRVPGM 00
**ctdata debugOption
DBGVIEW(*ALL)
OPTION(*SRCDBG)
OPTION(*LSTDBG)
DBGVIEW(*SOURCE)

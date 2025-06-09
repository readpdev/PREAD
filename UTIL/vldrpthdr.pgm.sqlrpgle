      *%METADATA                                                       *
      * %TEXT Validate Offline Report Header                           *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYSTGIO')

     fqsysprt   o    f  100        printer oflind(*in01)
     fmstgvol   if   e           k disk    usropn
     fmstgdev   if   e           k disk    usropn

/8180d getOptPath      pr           255
     d volume                        10
     d folder                        10
     d folderlib                     10

     d run             pr                  extpgm('QCMDEXC')
     d  cmd                         256    const
     d  cmdlen                       15p 5 const

     d sqlStmt         s            512
     d q               c                   ''''

      /copy doc850src/qrpglesrc,@spystgio

     d inputDS         ds
     d  ofrvol                       10
     d  ofrnam                       10
     d  fldr                         10
     d  fldrlb                       10
     d  rpttyp                       10
     d  filnam                       10
     d  repind                       10
     d  adsf                          9b 0
     d  ofrdat                        9b 0

     d timeFld         s               t
     d lastVol         s             10
     d path            s            255
     d fildes          s             10i 0
     d buffer          s            256
     d errorLine       s             80
     d rtncde          s             10i 0
     d savVol          s                   like(ofrVol)
     d savFldr         s                   like(fldr)
     d savFldrLb       s                   like(fldrlb)

     c     *entry        plist
     c                   parm                    startDate         8
      /free
       sqlStmt = 'select ofrvol, ofrnam, fldr, fldrlb, rpttyp, filnam, repind,'+
       ' adsf, ofrdat from mrptdir where ofrdat >= ' + startDate +
       ' and reploc = ' + q + '2' + q + ' and ofrvol <> ' + q + ' ' + q +
       ' order by ofrvol';
       exsr preDclOpn;
       *in01 = '1';
       dow sqlcod = 0;
         exsr fetchSR;
         if sqlcod <> 0 or sqlcod = 100;
           iter;
         endif;
         if ofrvol <> savVol or fldr <> savFldr or fldrlb <> savFldrlb;
           path = getOptPath(ofrvol:fldr:fldrlb);
           savVol = ofrvol;
           savfldr = fldr;
           savfldrlb = fldrlb;
         endif;
         fildes=spystgopn(ofrvol:%trim(path) + '/' + ofrnam:mod_read);
         if fildes < 0;
           errorLine = 'Error opening ' + %trim(ofrvol) + %trim(path) + '/' +
             ofrnam;
           exsr printException;
           iter;
         endif;
         if fildes >= 0;
           buffer = *allx'00';
/8837      rtncde = spystgred(fildes:buffer:%size(buffer));
           if rtncde <= 0;
             errorLine = 'Error reading ' + path;
             exsr printException;
             iter;
           endif;
           if buffer = *allx'00';
             exsr printException;
           endif;
         endif;
         spystgcls(fildes);
       enddo;
       if sqlcod <> 100;
         errorLine = 'SQL error code ' + %editc(%abs(sqlcod):'X');
         exsr printException;
       endif;
       spystgcls(fildes);
       close(e) qsysprt;
       exsr closeCursor;
       *inlr = '1';

       //***********************************************************************
       begsr printException;

        if not %open(qsysprt);
          run('ovrprtf qsysprt':15);
          open qsysprt;
        endif;
        if *in01;
          timeFld = %time;
          except header;
          *in01 = '0';
        endif;
        if errorLine <> ' ';
          except errLinOut;
          errorLine = ' ';
        else;
          except detail;
        endif;
       endsr;

      /end-free

      **************************************************************************
     c     preDclOpn     begsr

     c/exec sql
     c+ prepare stmt from :sqlStmt
     c/end-exec
     c/exec sql
     c+ declare csr01 cursor for stmt
     c/end-exec
     c/exec sql
     c+ open csr01
     c/end-exec

     c                   endsr

      **************************************************************************
     c     fetchSR       begsr

     c/exec sql
     c+ fetch next from csr01 into :ofrvol, :ofrnam, :fldr, :fldrlb, :rpttyp,
     c+ :filnam, :repind, :adsf, :ofrdat
     c/end-exec

     c                   endsr

      **************************************************************************
     c     closeCursor   begsr

     c/exec sql
     c+ close csr01
     c/end-exec

     c                   endsr

      **************************************************************************
     oqsysprt   e            header         2  1
     o                       *date         Y
     o                                              '  '
     o                       timeFld
     o                                              '  '
     o                                              'Validate Offline Reports'
     o                       page          Z    100
     o                                           94 'Page:'
     o          e            header         1
     o                                              'Volume    '
     o                                              '  '
     o                                              'Folder Lib'
     o                                              '  '
     o                                              'Folder    '
     o                                              '  '
     o                                              'Offline File'
     o                                              '  '
     o                                              'Report Type'
     o                                              '  '
     o                                              'Archived  '
     o                                              '  '
     o                                              'Offline   '
     o                                              '  '
     o                                              'Spy Number'
     o          e            detail         1
     o                       ofrvol
     o                                              '  '
     o                       fldrlb
     o                                              '  '
     o                       fldr
     o                                              '  '
     o                       ofrnam
     o                                              '    '
     o                       rpttyp
     o                                              '   '
     o                       adsf
     o                                              '   '
     o                       ofrdat
     o                                              '   '
     o                       repind
     o          e            errLinOut      1
     o                       errorLine

      **************************************************************************
/8180p getOptPath      b

     d                 pi           255
     d volume                        10
     d folder                        10
     d folderlib                     10

      * open storage volume file
     c                   if        not %open(Mstgvol)
     c                   open      Mstgvol
     c                   endif
      * get volume info
     c                   eval      svvol = volume
     c     svvol         chain     Mstgvol
     c                   if        not %found
     c                   return    ' '
     c                   endif
      * if type of storage device not IFS then build path
     c                   return    '/SPYGLASS/' + %trim(folderLib) + '/' +
     c                             %trim(folder)
      * if device is IFS then get additional path info
      * open storage device file
     c                   if        not %open(Mstgdev)
     c                   open      Mstgdev
     c                   endif
      * get device path
     c     svdev         chain     Mstgdev
     c                   if        not %found
     c                   return    ' '
     c                   endif
      * build IFS path
     c                   return    %trim(sdpth)+'/'+%trim(volume) + '/' +
     c                             'SPYGLASS' + '/' + %trim(folderlib) +
     c                             '/' + %trim(folder)

     p                 e

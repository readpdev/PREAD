     h dftactgrp(*no) actgrp(*caller) bnddir('TSUTILSRV') datfmt(*iso)

     fexportdsp cf   e             workstn indds(indds)
     f                                     sfile(cfgSfl:rrn1)
     f                                     sfile(logSfl:rrn2)
     fexpcfg    uf a e             disk
     fexplog    if   e           k disk

      * Copy members
      *copy qsysinc/qrpglesrc,qusec
     D*** START HEADER FILE SPECIFICATIONS ****************************
     D*
     D*Header File Name: H/QUSEC
     D*
     D*Descriptive Name: Error Code Parameter.
     D*
     D*5763-SS1, 5722-SS1 (C) Copyright IBM Corp. 1994, 2001.
     D*All rights reserved.
     D*US Government Users Restricted Rights -
     D*Use, duplication or disclosure restricted
     D*by GSA ADP Schedule Contract with IBM Corp.
     D*
     D*Licensed Materials-Property of IBM
     D*
     D*
     D*Description: Include header file for the error code parameter.
     D*
     D*Header Files Included: None.
     D*
     D*Macros List: None.
     D*
     D*Structure List: Qus_EC_t
     D*             Qus_ERRC0200_t
     D*
     D*Function Prototype List: None.
     D*
     D*Change Activity:
     D*
     D*CFD List:
     D*
     D*FLAG REASON       LEVEL DATE   PGMR      CHANGE DESCRIPTION
     D*---- ------------ ----- ------ --------- ----------------------
     D*
     D*End CFD List.
     D*
     D*Additional notes about the Change Activity
     D*End Change Activity.
     D*** END HEADER FILE SPECIFICATIONS ******************************
     D*****************************************************************
     D*Record structure for Error Code Parameter
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Varying length field Exception
     D*   Data will not be defined here.
     D*****************************************************************
     DQUSEC            DS
     D*                                             Qus EC
     D QUSBPRV                 1      4B 0
     D*                                             Bytes Provided
     D QUSBAVL                 5      8B 0
     D*                                             Bytes Available
     D QUSEI                   9     15
     D*                                             Exception Id
     D QUSERVED               16     16
     D*                                             Reserved
     D*QUSED01                17     17
     D*
     D*                                      Varying length
     DQUSC0200         DS
     D*                                             Qus ERRC0200
     D QUSK01                  1      4B 0
     D*                                             Key
     D QUSBPRV00               5      8B 0
     D*                                             Bytes Provided
     D QUSBAVL14               9     12B 0
     D*                                             Bytes Available
     D QUSEI00                13     19
     D*                                             Exception Id
     D QUSERVED39             20     20
     D*                                             Reserved
     D QUSCCSID11             21     24B 0
     D*                                             CCSID
     D QUSOED01               25     28B 0
     D*                                             Offset Exc Data
     D QUSLED01               29     32B 0
     D*                                             Length Exc Data
     D*QUSRSV214              33     33
     D*                                             Reserved2
     D*
     D*QUSED02                34     34
     D*
     D*                                      Varying Length    @B1A
      *copy tsutilsrvh
     d OK              c                   0
     d KEYNOMATCH      c                   -1
     d LOCK_CHECK      c                   1
     d LOCK_LOCK       c                   2
     d LOCK_UNLOCK     c                   3
     d OBJTYPIMG       c                   'I'
     d OBJTYPRPT       c                   'R'
     d OBJTYPERR       c                   ' '

     d validateKey     pr            10i 0
     d  keyInput                     16    const

     d rtvsysval       pr            10
     d  sysval                       10    value

     d chkobj          pr
     d  object                       10    const
     d  library                      10    const
     d  type                         10    const
     d  rtnSts                       10i 0

     d lockExport      pr            10i 0
     d  operaton                     10i 0 const

     d getObjTyp       pr             1
     d  docType                      10    const

     d writeLog        pr
     d  class                        10    const
     d  objectID                     10    const
     d  objectDate                    8p 0 const
     d  message                      80    const

      * Subprocedures
     d doKey           pr
     d doConfig        pr
     d rmvmsg          pr
     d  stackCount                   10i 0 value
     d sndmsg          pr
     d  msgdta                      100    value
     d  stack                        10i 0 const options(*nopass)
     d  msgfIn                       10    value options(*nopass)
     d  msgIdIn                       7    value options(*nopass)
     d loadVolumes     pr
     d bldStmt         pr
     d  option                       10i 0 const
     d doStart         pr
     d doStop          pr
     d dspLog          pr
     d doReset         pr

      * External prototypes
     d system          pr            10i 0 extproc('system')
     d  value                          *   value options(*string)
     d sprintf         pr                  extproc('sprintf')
     d  target                         *   value options(*string)
     d  source                         *   value options(*string)
     d  value1                         *   value options(*string)
     d  value2                         *   value options(*string:*nopass)
     d  value3                         *   value options(*string:*nopass)
     d  value4                         *   value options(*string:*nopass)
     d  value5                         *   value options(*string:*nopass)

      * Constants
     d TYPE_REPORT     c                   1
     d TYPE_IMAGE      c                   2

     d PGMQ            s             10    inz('EXPORTCFG')
     d ENTER           c                   x'f1'
     d BS_SELECTED_VOLUMES...
     d                 c                   1
     d BS_UNSELECTED_VOLUMES...
     d                 c                   2

      * Variables and datastructures.
     d indds           ds            99
     d  exit                  03     03n
     d  prompt                04     04n
     d  refresh               05     05n
     d  cancel                12     12n
     d  sfldsp                25     25n
     d  sfldlt                26     26n
     d  pageUp                27     27n
     d  pageDown              28     28n
     d  top                   29     29n
     d  bottom                30     30n
     d  NON_DSPLY_OUTQ...
     d                        31     31n
     d  NON_DSPLY_DIR         32     32n
     d  NON_DSPLY_VOL         33     33n
     d  POS_CSR_TYPE          41     41n
     d  POS_CSR_FRDAT         42     42n
     d  POS_CSR_TODAT         43     43n
     d  POS_CSR_OUTQ          44     44n
     d  POS_CSR_JOBD          45     45n
     d  POS_CSR_JOBQ          46     46n
     d  POS_CSR_ALL           41     46
     d  configChange          50     50n
     d  sflend                99     99n
     d expCfgDta       ds           256    dtaara qualified inz
     d  key                          16
     d  stopIndicator                 1
     d                sds
     d pgmLib                 81     90
     d                 ds
     d key                           32
     d  key1                          8    overlay(key)
     d  key2                          8    overlay(key:*next)
     d  key3                          8    overlay(key:*next)
     d  key4                          8    overlay(key:*next)
     d  chkObjRtn      s             10i 0
     d savCfgRec     e ds                  extname(EXPCFG) qualified inz
     d expCfgRec     e ds                  extname(EXPCFG) inz
     d cmds            s             80    dim(1) ctdata

     D*      SQL COMMUNICATION AREA                                             SQL
     D SQLCA           DS                                                       SQL
     D  SQLCAID                       8A   INZ(X'0000000000000000')             SQL
     D  SQLAID                        8A   OVERLAY(SQLCAID)                     SQL
     D  SQLCABC                      10I 0                                      SQL
     D  SQLABC                        9B 0 OVERLAY(SQLCABC)                     SQL
     D  SQLCODE                      10I 0                                      SQL
     D  SQLCOD                        9B 0 OVERLAY(SQLCODE)                     SQL
     D  SQLERRML                      5I 0                                      SQL
     D  SQLERL                        4B 0 OVERLAY(SQLERRML)                    SQL
     D  SQLERRMC                     70A                                        SQL
     D  SQLERM                       70A   OVERLAY(SQLERRMC)                    SQL
     D  SQLERRP                       8A                                        SQL
     D  SQLERP                        8A   OVERLAY(SQLERRP)                     SQL
     D  SQLERR                       24A                                        SQL
     D   SQLER1                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER2                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER3                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER4                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER5                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER6                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLERRD                     10I 0 DIM(6)  OVERLAY(SQLERR)              SQL
     D  SQLWRN                       11A                                        SQL
     D   SQLWN0                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN1                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN2                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN3                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN4                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN5                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN6                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN7                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN8                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN9                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWNA                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D  SQLWARN                       1A   DIM(11) OVERLAY(SQLWRN)              SQL
     D  SQLSTATE                      5A                                        SQL
     D  SQLSTT                        5A   OVERLAY(SQLSTATE)                    SQL
     D*  END OF SQLCA                                                           SQL
     D  SQLROUTE       C                   CONST('QSYS/QSQROUTE')               SQL
     D  SQLOPEN        C                   CONST('QSYS/QSQLOPEN')               SQL
     D  SQLCLSE        C                   CONST('QSYS/QSQLCLSE')               SQL
     D  SQLCMIT        C                   CONST('QSYS/QSQLCMIT')               SQL
     D  SQFRD          C                   CONST(2)                             SQL
     D  SQFCRT         C                   CONST(8)                             SQL
     D  SQFOVR         C                   CONST(16)                            SQL
     D  SQFAPP         C                   CONST(32)                            SQL
     D                 DS                                                       INSERT
     D  SQL_00000              1      2B 0 INZ(128)                             length of header
     D  SQL_00001              3      4B 0 INZ(6)                               statement number
     D  SQL_00002              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00003              9      9A   INZ('0')                             data is okay
     D  SQL_00004             10    128A                                        end of header
     D  SQL_00005            129    140A                                        EV_VOLUME
     D                 DS                                                       FETCH
     D  SQL_00006              1      2B 0 INZ(128)                             length of header
     D  SQL_00007              3      4B 0 INZ(7)                               statement number
     D  SQL_00008              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00009              9      9A   INZ('0')                             data is okay
     D  SQL_00010             10    128A                                        end of header
     D  SQL_00011            129    140A                                        EV_VOLUME
     D                 DS                                                       FETCH
     D  SQL_00012              1      2B 0 INZ(128)                             length of header
     D  SQL_00013              3      4B 0 INZ(8)                               statement number
     D  SQL_00014              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00015              9      9A   INZ('0')                             data is okay
     D  SQL_00016             10    128A                                        end of header
     D  SQL_00017            129    140A                                        EV_VOLUME
     D                 DS                                                       CLOSE
     D  SQL_00018              1      2B 0 INZ(128)                             length of header
     D  SQL_00019              3      4B 0 INZ(9)                               statement number
     D  SQL_00020              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00021              9      9A   INZ('0')                             data is okay
     D  SQL_00022             10    127A                                        end of header
     D  SQL_00023            128    128A                                        end of header
     D                 DS                                                       FETCH
     D  SQL_00024              1      2B 0 INZ(128)                             length of header
     D  SQL_00025              3      4B 0 INZ(10)                              statement number
     D  SQL_00026              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00027              9      9A   INZ('0')                             data is okay
     D  SQL_00028             10    127A                                        end of header
     D  SQL_00029            129    140A                                        EV_VOLUME
     D                 DS                                                       FETCH
     D  SQL_00030              1      2B 0 INZ(128)                             length of header
     D  SQL_00031              3      4B 0 INZ(11)                              statement number
     D  SQL_00032              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00033              9      9A   INZ('0')                             data is okay
     D  SQL_00034             10    127A                                        end of header
     D  SQL_00035            129    140A                                        EV_VOLUME
     D                 DS                                                       CLOSE
     D  SQL_00036              1      2B 0 INZ(128)                             length of header
     D  SQL_00037              3      4B 0 INZ(12)                              statement number
     D  SQL_00038              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00039              9      9A   INZ('0')                             data is okay
     D  SQL_00040             10    127A                                        end of header
     D  SQL_00041            128    128A                                        end of header
     D                 DS                                                       OPEN
     D  SQL_00042              1      2B 0 INZ(128)                             length of header
     D  SQL_00043              3      4B 0 INZ(14)                              statement number
     D  SQL_00044              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00045              9      9A   INZ('0')                             data is okay
     D  SQL_00046             10    127A                                        end of header
     D  SQL_00047            128    128A                                        end of header
     c     *entry        plist
     c                   parm                    option           10
     c     expVolKey     klist
     c                   kfld                    cfgType
     c                   kfld                    ev_volume
      /free
       //*exec sql set option closqlcsr=*endmod,commit=*none;
       chkobj('EXPCFGDTA':pgmLib:'*DTAARA':chkObjRtn);
       if chkObjRtn <> OK;
         system('crtdtaara ' + %trim(pgmLib) + '/expCfgDta *char ' +
           %editc(%len(expCfgDta):'Z'));
       endif;
       select;
         when option = 'KEY';
           doKey();
         when option = 'CONFIGURE';
           doConfig();
         when option = 'START';
           doStart();
         when option = 'STOP';
           doStop();
         when option = 'LOG';
           dspLog();
         when option = 'RESET';
           doReset();
       endsl;
       *inlr = '1';
      /end-free
      **************************************************************************
     p doKey           b

     d cvthc           pr                  extproc('cvthc')
     d  tgt                            *   value
     d  src                            *   value
     d  tgtlen                       10i 0 value

     d cvtch           pr                  extproc('cvtch')
     d  tgt                            *   value
     d  src                            *   value
     d  srclen                       10i 0 value

      /free
       in(e) *lock expCfgDta;
       if expCfgDta.key <> ' ';
         cvthc(%addr(key):%addr(expCfgDta.key):%len(key));
       endif;
       srlNbr = rtvSysVal('QSRLNBR');
       write fkey;
       dow 1=1;
         write msgctl;
         exfmt keycode;
         rmvmsg(2);
         select;
           when exit or cancel;
             leave;
           when refresh;
             in(e) *lock expCfgDta;
             if expCfgDta.key <> ' ';
               cvthc(%addr(key):%addr(expCfgDta.key):%len(key));
             endif;
             iter;
         endsl;
         monitor;
         cvtch(%addr(expCfgDta.key):%addr(key):%len(key));
         on-error;
         endmon;
         if validateKey(expCfgDta.key) <> OK;
           sndmsg('Invalid key. Please try again');
         else;
           out expCfgDta;
           sndmsg('Keycode accepted. Press F12');
         endif;
       enddo;
      /end-free
     p                 e
      **************************************************************************
     p rmvmsg          b
     d                 pi
     d stackCount                    10i 0 value

     d rmvpm           pr                  extpgm('QMHRMVPM')
     d  stack                        10    const
     d  stackCount                   10i 0 const
     d  msgKey                        4    const
     d  msgType                      10    const
     d  error                              likeds(qusec)
     d error           ds                  likeds(qusec)
      /free
       clear qusec;
       error.qusbprv = %size(error);
       rmvpm('*':stackCount:' ':'*ALL':error);
       return;
      /end-free
     p                 e
      **************************************************************************
     p sndmsg          b
     d                 pi
     d  msgdta                      100    value
     d  stack                        10i 0 const options(*nopass)
     d  msgfIn                       10    value options(*nopass)
     d  msgIdIn                       7    value options(*nopass)

     d msgf            s             20    inz('QCPFMSG   *LIBL')
     d msgdtalen       s             10i 0 inz(0)
     d msgid           s              7    inz('CPF9898')
     d stackcnt        s             10i 0 inz(0)

     d spm             pr                  extpgm('QMHSNDPM')
     d  msgid                              like(msgid) const
     d  msgf                               like(msgf) const
     d  msgdta                             like(msgdta) const
     d  msgdtalen                          like(msgdtalen) const
     d  msgtype                      10    const
     d  pgmq                               like(pgmq) const
     d  stackcnt                           like(stackcnt)
     d  msgkey                        4    const
     d  error                              likeds(qusec)
     d error           ds                  likeds(qusec) inz
      /free
       msgdtalen = %len(%trimr(msgdta));
       if %parms = 2;
         stackcnt = stack;
       endif;
       if %parms > 2;
         %subst(msgf:1:10) = msgfIn;
         msgid = msgIdIn;
       endif;
       error.qusbprv = %size(error);
       spm(msgid:msgf:msgdta:msgdtalen:'*INFO':pgmq:stackcnt:' ':error);
       return;
      /end-free
     p                 e
      **************************************************************************
     p doConfig        b
     d sltDocCls       pr                  extpgm('MAG8051')
     d  type                          1    const
     d  rtnType                      10
     d nextEnterExit   s               n   inz('0')
      /free
       if lockExport(LOCK_CHECK) <> OK;
         sndmsg('Cannot configure when export is active':2);
         return;
       endif;
       chain 1 expCfg;
       if not %found;
         cfgfrdate = %date();
         cfgtodate = %date();
       endif;
       loadVolumes();
       dow 1 = 1;
         NON_DSPLY_OUTQ = '1';
         NON_DSPLY_DIR = '1';
         if getObjTyp(cfgType) = OBJTYPRPT;
           NON_DSPLY_OUTQ = '0';
         endif;
         if getObjTyp(cfgType) = OBJTYPIMG;
           NON_DSPLY_DIR = '0';
         endif;
         configChange = '0';
         write fkey;
         write msgCtl;
         exfmt cfgCtl;
         rmvmsg(2);
         select;
           when exit or cancel;
             leave;
           when refresh;
             chain 1 expcfg;
             loadVolumes();
           when prompt;
             sltDocCls(getObjTyp(cfgType):cfgType);
           when nextEnterExit and not configChange;
             leave;
           other;
             nextEnterExit = '0';
             exsr checkAndUpdate;
             if POS_CSR_ALL <> *ALL'0';
               iter;
             endif;
             loadVolumes();
             if not configChange;
               nextEnterExit = '1';
               sndmsg('Configuration updated. Press Enter to continue');
             endif;
         endsl;
       enddo;
       return;
       //***********************************************************************
       begsr checkAndUpdate;
         POS_CSR_ALL = *ALL'0';
         if cfgType = ' ' or getObjTyp(cfgType) = OBJTYPERR;
           sndmsg('Document type not found or blank');
           POS_CSR_TYPE = '1';
           leavesr;
         endif;
         test(e) cfgfrdate;
         if %error or %char(cfgfrdate) = '0001-01-01';
           sndmsg('Date invalid');
           POS_CSR_FRDAT = '1';
           leavesr;
         endif;
         test(e) cfgtodate;
         if %error;
           sndmsg('Date invalid');
           POS_CSR_FRDAT = '1';
           leavesr;
         endif;
         if cfgtodate < cfgfrdate;
           POS_CSR_FRDAT = '1';
           sndmsg('Invalid date range');
           leavesr;
         endif;
         if cfgOutqLib = ' ';
           cfgOutqLib = '*LIBL';
         endif;
         if NON_DSPLY_OUTQ = '0';
           POS_CSR_OUTQ = '1';
           if cfgOutQ = ' ';
             sndmsg('Out queue cannot be blank');
             leavesr;
           endif;
           chkObj(cfgOutQ:cfgOutqLib:'*OUTQ':chkObjRtn);
           if chkObjRtn <> OK;
             sndmsg('Out queue not found');
             leavesr;
           endif;
           POS_CSR_OUTQ = '0';
         endif;
         savCfgRec = expCfgRec;
         chain 1 expCfg;
         if %found;
           expCfgRec = savCfgRec;
           update cfgRec;
         else;
           write cfgRec;
         endif;
         if sfldsp;
           readc cfgSfl;
           if not %eof or configChange;
       //*      exec sql delete from expCfgVol;
      /END-FREE                                                                 SQL
     C                   Z-ADD     5             SQLER6                         SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
      /FREE                                                                     SQL
           endif;
           dow not %eof; // Write or delete volumes for export volume file.
             configChange = '1';
             if selectVol = 'X';
       //*        exec sql insert into expcfgvol values(:ev_volume);
      /END-FREE                                                                 SQL
     C                   EVAL      SQL_00005    = EV_VOLUME                     SQL
     C                   Z-ADD     -4            SQLER6                         SQL   6
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00000                      SQL
      /FREE                                                                     SQL
             endif;
             readc cfgSfl;
           enddo;
         endif;
       endsr;
      /end-free
     p                 e
      **************************************************************************
     p loadVolumes     b
      /free
       sfldsp = '0';
       sfldlt = '1';
       write cfgctl;
       sfldlt = '0';
       NON_DSPLY_VOL = '1';
       rrn1 = 0;
       // Load selected volumes.
       selectVol = 'X';
       bldStmt(BS_SELECTED_VOLUMES);
       //*exec sql fetch c1 into :ev_volume;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   7
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00006                      SQL
     C     SQL_00009     IFEQ      '1'                                          SQL
     C                   EVAL      EV_VOLUME = SQL_00011                        SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       dow sqlcod = OK;
         rrn1 += 1;
         NON_DSPLY_VOL = '0';
         write cfgSfl;
       //*  exec sql fetch c1 into :ev_volume;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   8
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00012                      SQL
     C     SQL_00015     IFEQ      '1'                                          SQL
     C                   EVAL      EV_VOLUME = SQL_00017                        SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       enddo;
       //*exec sql close c1;
      /END-FREE                                                                 SQL
     C                   Z-ADD     9             SQLER6                         SQL
     C     SQL_00020     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00018                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00018                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       // Display any unselected volumes for the document.
       bldStmt(BS_UNSELECTED_VOLUMES);
       selectVol = ' ';
       //*exec sql fetch c1 into :ev_volume;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   10
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00024                      SQL
     C     SQL_00027     IFEQ      '1'                                          SQL
     C                   EVAL      EV_VOLUME = SQL_00029                        SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       dow sqlcod = OK;
         rrn1 += 1;
         NON_DSPLY_VOL = '0';
         write cfgSfl;
       //*  exec sql fetch c1 into :ev_volume;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL   11
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00030                      SQL
     C     SQL_00033     IFEQ      '1'                                          SQL
     C                   EVAL      EV_VOLUME = SQL_00035                        SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       enddo;
       if rrn1 > 0;
         rrn1 = 1;
         sflDsp = '1';
         NON_DSPLY_VOL = '0';
       endif;
       //*exec sql close c1;
      /END-FREE                                                                 SQL
     C                   Z-ADD     12            SQLER6                         SQL
     C     SQL_00038     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00036                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00036                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       return;
      /end-free
     p                 e
      ************************************************************************
     p bldStmt         b
     d                 pi
     d option                        10i 0 const
     d SQ              c                   ''''
     d textStmt        s            512
      /free
       select;
         when option = BS_SELECTED_VOLUMES;
           textStmt = 'select ev_volume from expcfgvol';
         when option = BS_UNSELECTED_VOLUMES;
           textStmt = 'select distinct(optvol) from mopttbl left join';
           select;
             when getObjTyp(cfgType) = OBJTYPRPT;
               textStmt = %trimr(textStmt) +
                 ' mrptdir on ofrnam = optrnm ' +
                 'exception join expcfgvol on ev_volume = optvol ' +
                 'where mrptdir.rpttyp = ' + sq + %trimr(cfgType) + sq +
                 ' and mrptdir.reploc = ' + sq + '2' + sq +
                 ' and datfop between ' + %char(cfgFrDate:*cymd0) + ' and ' +
                 %char(cfgToDate:*cymd0);
             when getObjTyp(cfgType) = OBJTYPIMG;
               textStmt = %trimr(textStmt) +
                 ' mimgdir on idbnum = optrnm ' +
                 'exception join expcfgvol on ev_volume = optvol ' +
                 'where mimgdir.iddoct = ' + sq + %trimr(cfgType) + sq +
                 ' and mimgdir.idiloc = ' + sq + '2' + sq +
                 ' and iddscn between ' + %char(cfgFrDate:*iso0) + ' and ' +
                 %char(cfgToDate:*iso0);
           endsl;
       endsl;
       //*exec sql prepare sqlStmt from :textStmt;
      /END-FREE                                                                 SQL
     C                   Z-ADD     13            SQLER6                         SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    TEXTSTMT                       SQL
      /FREE                                                                     SQL
       //*exec sql declare c1 cursor for sqlStmt;
       //*exec sql open c1;
      /END-FREE                                                                 SQL
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00044     IFEQ      0                                            SQL
     C     SQL_00045     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00042                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00042                      SQL
     C                   END                                                    SQL
      /FREE                                                                     SQL
       return;
      /end-free
     p                 e
      ************************************************************************
     p doStart         b
     d run             pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)
     d cmd             s            256
     d thisJobD        s             20
     d thisJobQ        s             20
      /free
       in expCfgDta;
       if validateKey(expCfgDta.key) <> OK;
         sndmsg('Cannot start. Keycode is invalid':2);
         return;
       endif;
       if lockExport(LOCK_CHECK) <> OK;
         sndmsg('Cannot start. Export already active':2);
         return;
       endif;
       jobD = '*USRPRF';
       jobdLib = ' ';
       jobQ = '*JOBD';
       jobqLib = ' ';
       dow 1 = 1;
         write fkey;
         write msgctl;
         exfmt sbmjob;
         rmvmsg(2);
         POS_CSR_ALL = *all'0';
         if exit or cancel;
           leave;
         endif;
         if refresh;
           jobD = '*USRPRF';
           jobdLib = ' ';
           jobQ = '*JOBD';
           jobqLib = ' ';
           iter;
         endif;
         if jobD <> '*USRPRF';
           if jobdLib = ' ';
             jobdLib = '*LIBL';
           endif;
           chkobj(jobD:jobdLib:'*JOBD':chkObjRtn);
           if chkObjRtn <> OK;
             sndmsg('Job description not found');
             POS_CSR_JOBD = '1';
           endif;
         endif;
         if jobQ <> '*JOBD';
           if jobqLib = ' ';
             jobqLib = '*LIBL';
           endif;
           chkobj(jobQ:jobqLib:'*JOBQ':chkObjRtn);
           if chkObjRtn <> OK;
             sndmsg('JobQ not found');
             POS_CSR_JOBQ = '1';
           endif;
         endif;
         if POS_CSR_ALL = *all'0';
           thisJobD = jobD;
           if jobD <> '*USRPRF';
             thisJobD = %trimr(jobdLib) + '/' + %trimr(jobD);
           endif;
           thisJobQ = jobQ;
           if jobQ <> '*JOBD';
             thisJobQ = %trimr(jobqLib) + '/' + %trimr(jobQ);
           endif;
           clear cmd;
           cmds(1) = %trimr(cmds(1)) + x'00';
           sprintf(%addr(cmd):%addr(cmds(1)):%trimr(pgmLib):%trimr(thisJobD):
             %trimr(thisJobQ));
           cmd = %trimr(cmd) + x'00';
           in *lock expCfgDta;
           expCfgDta.stopIndicator = '0';
           out expCfgDta;
           run(cmd);
           sndmsg('Export job submitted':2);
           leave;
         endif;
       enddo;
       return;
      /end-free
     p                 e
      ************************************************************************
     p doStop          b
      /free
       if lockExport(LOCK_CHECK) = OK;
         sndmsg('Export not active':2);
       else;
         sndmsg('Export will stop when finished processing current object');
         in *lock expCfgDta;
         expCfgDta.stopIndicator = '1';
         out expCfgDta;
       endif;
       return;
      /end-free
     p                 e
      ************************************************************************
     p dspLog          b
     d MAXLOGREC       c                   16
     d i               s             10i 0
      /free
       exsr readForward;
       dow 1 = 1;
         write fkey2;
         write msgctl;
         exfmt logCtl;
         rmvmsg(2);
         select;
           when exit or cancel;
             leave;
           when refresh or top;
             setll *start expLog;
             exsr readForward;
           when pageUp;
             exsr readBackward;
           when pageDown;
             exsr readForward;
           when bottom;
             setll *end expLog;
             exsr readBackward;
         endsl;
       enddo;
       return;
       //***********************************************************************
       begsr readForward;
         exsr clearSubfile;
         for i = 1 to MAXLOGREC;
           read explog;
           if %eof;
             leave;
           endif;
           rrn2 += 1;
           if logmessage <> 'Exported';
             errind = '*';
           endif;
           if logobjdat < 2000000 and logobjdat > 0;
             logobjdat = %int(%char(%date(logobjdat:*cymd):*iso0));
           endif;
           write logSfl;
           errind = ' ';
         endfor;
         if rrn2 > 0;
           sfldsp = '1';
           rrn2 = 1;
         endif;
       endsr;
       //***********************************************************************
       begsr readBackward;
         for i = 1 to MAXLOGREC * 2;
           readp explog;
           if %eof;
             leave;
           endif;
         endfor;
         exsr readForward;
       endsr;
       //***********************************************************************
       begsr clearSubfile;
         sfldsp = '0';
         sfldlt = '1';
         write logCtl;
         sfldlt = '0';
         rrn2 = 0;
       endsr;
      /end-free
     p                 e
      ************************************************************************
     p doReset         b
      /free
       return;
      /end-free
     p                 e
**ctdata cmds
SBMJOB CMD(CALL PGM(%s/EXPORT)) JOB(EXPORT) JOBD(%s) JOBQ(%s)

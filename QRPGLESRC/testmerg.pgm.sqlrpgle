     h bnddir('SPYBNDDIR')
      /copy directives
      *************-------------------------------------------------
      * SPYCSLRMNT  Retrieve RMaint data for SpyLinked rpts & images
      *************-------------------------------------------------
      *
     FRLNKDEF   IF   E           K DISK    USROPN  INFDS(RLKDTS)
     FRMAINT    IF   E           K DISK    USROPN
     FRMAINT4   IF   E           K DISK    USROPN  RENAME(RMNTRC:RMNTRC4)
     FWDACCL01  IF   E           K DISK    USROPN
     FWCPWDP    IF   E           K DISK    USROPN
     FRLNKOFF   IF   E           K DISK    USROPN
      *
      *    NAME   SIZE  DESCRIPTION
      *    -----  ----  ----------------------------------------
      *    File     10  "RLNKDEF"
      *    OpCode    6  Read/Readp/Quit
      *                 "READ"   Read forward from the Big 5 key
      *                 "READP"  Read backward from the Big 5 key
      *                 "QUIT"   Shutdown
      *    SetKey   50  Big 5 key
      *    Scroll    3  Scroll factor to start reading from
      *    Sdt    7680  Send back buffer
      *                   37 occurrences
      *    RtnRec    9  Number of records returned in SDT
      *    Rtn       2  Return code: 00 = Complete
      *                              20 = Reach tof/eof
      *                              30 = Terminal error
      *
J7017 *  06-15-17 PLR Wild card searching code from VIP-5088 was causing
      *               returning the right number of doclink classes to
      *               DocView Explorer. Impacts DocView/DVE and CoEx.
      *               Corrected issues with wildcard searches when trailing
      *               wildcard would not pick up a class without being trimmed
      *               first.
J6396 *  08-25-15 PLR Customer (Belz) was experiencing intermittent SQL failures
      *               in this application when accessed through CoEx.
      *               For testing and ease of evenly parsed values for the sqlStmt
      *               field, the field length was extended from 256 to 512.
      *               Upon providing test code, errors were no longer
      *               encountered. Customer opted for this as a solution.
      *               Also added error trapping for sqlcod return value to
      *               prevent looping. Roll foward from VIP-6388.
J5088 *  04-15-15 PLR Allow for wildcard searches against the description and
      *               report name.
J3957 *  04-10-15 PLR If CoEx connection and sysenv setting (screen 14)
      *               of suppressing empty document classes is set to
      *               'N', then return the empty class reference so CoEx
      *               can upload to it.
J5082 *  07-09-13 PLR Upshift report name and report type for PositionTo
      *               searches. Report description search remains case
      *               sensitive because it can contain mixed case where
      *               the other 2 search options are always stored in upper
      *               case on the server.
J4312 *  11-26-12 PLR Allow sort by description. Will receive *RRDESC in
      *               key 1. Key fields 2-5 will contain the description
      *               Position-To value. Support flag in SPYCSLSTN.
J4561 *  11-21-12 PLR Allow sorting by any one big5 key element. Report name,
      *               job name, program name, user name or user data.
      *               Conversation RLNKDEF3. Requires the client to send
      *               back the report type in skey2 for positioning.
J2745 *  06-30-10 EPG Improve performance of report maintenance list.
J1939 *  07-28-09 PLR Implement RLNKDEF2 request. Speeds up the conversation
      *               for long lists by shortening the response structure.
/5828 *  05-03-02 PLR Fix Big5 vs. report type handling for new conversation.
/5826 *  02-01-02 KAC Fix CS next buffer position (sends RTypID)
/5826 *  01-16-02 KAC Revise Web access for VCO conversation.
/5826 *  12-12-01 KAC Revise Report type for 7.1 conversation.
/4803 *  07-30-01 PLR Default key order to big5 unless specified.
/3765 *  03-06-01 KAC Use Report type for 7.1 conversation.
/3679 *  01-16-01 KAC Add VCO support report type rather Big5 key.
      *  12-07-00 GT  Fixed SETWEB routine for Web paging             2610HQ
      *  11-01-99 KAC DROPPED DATALIB FROM SPYLINKS & OMNILINKS.      2153HQ
      *   5-01-98 GT  Change REDPE to READP in READ subroutine.
      *               Fix Web routine to not reset DOWEB variable.
      *   4-08-96 JJF Bypass link if @file (LNKFIL) does not exist.
      *   2-16-96 DM  Program created
      *
      ****************************************************************
      *
J4561d setLnkSrtOrd    pr

J3957d bldLnkFil       pr                  extpgm('BLDLNKF')
J3957d  fileName                     10    const
J3957d  jobName                      10    const
J3957d  pgmName                      10    const
J3957d  userName                     10    const
J3957d  userData                     10    const
J3957d  sequence                      5  0 const
J3957d  description                  30    const
J3957d  ndxFileName                  10    const
J3957d  rtnMsgID                      7
J3957d crtNdxMsgID     s              7

J3957d chkObj          pr                  extpgm('SPCHKOBJ')
J3957d  object                       10    const
J3957d  objectLib                    10    const
J3957d  objectType                   10    const
J3957d  objectRC                      1
J3957d chkObjRC        s              1

J2674 * Constants --------------------------------------------------------------------
/    d MAX_DTS         c                   37
/    d MAX_DTS2        c                   108

     D PCT             S              1    DIM(100)                             Scroll bar %
     D SPY             S             50    DIM(100)

     D SDT             DS          7680
      *             Send back Data Structure
J2674D  DTS                         207    DIM(MAX_DTS)
/    D  dts2                         71    dim(MAX_DTS2) overlay(sdt)

     D MNTDTA          DS           207
      *             Subrec of SDT
     D  RRNAM                  1     10
     D  RJNAM                 11     20
     D  RPNAM                 21     30
     D  RUNAM                 31     40
     D  RUDAT                 41     50
     D  RRDESC                51     90
     D  @ROLGE                91     92  0
     D  @ROFGE                93     94  0
     D  @ROLDA                95     97  0
     D  @ROFDA                98    100  0
     D  RDEFP                101    110
     D  RDEFQ                111    120
     D  RDEFL                121    130
     D  RDFILT               131    140
     D  RPGBK                141    141
     D  @RLCKH               142    143  0
     D  RSEC                 144    144
      *                            ====================================
      *                            RSEC IS USED TO SEND THE LINK STATUS
      *                            ====================================
      *                                      ' '  Online         REPORT
      *                                      '1'  Online+Offline   "
      *                                      '2'  Offline          "
      *                                      '3'  *none            "
      *                                      'A'  Online         IMAGE
      *                                      'B'  Online+Offline   "
      *                                      'C'  Offline          "
      *                                      'D'  *none            "
     D  ROPVID               145    156
     D  RTYPID               157    166
     D  RUSFF1               167    176
     D  RUSFF2               177    186
     D  PRTCPG               187    187
     D  CPGID                188    197
     D  RLNKFL               198    207

J1939D MNTDTA2         DS                  qualified
/    D  RRNAM                        10
/    D  RRDESC                       40
/    D  RTYPID                       10
/    D  RLNKFL                       10
/    D  RSEC                          1

     D SYSDFT          DS          1024    dtaara
J4561d  lnkSrtOrd            205    205
J4561 * 1=Report Name (Default)
J4561 * 2=Job Name
J4561 * 3=Program Name
J4561 * 4=User Name
J4561 * 5=User Data
J3957d  CoExSupEmpty         281    281
     D  DTALIB               306    315

J4561d rlnkdefDS       ds                  likerec(lnkdef)
J4561d rmaintDS        ds                  likerec(rmntrc)

     D ERRCD           DS           116
     D  @ERLEN                 1      4i 0 INZ(116)
     D  @ERTCD                 5      8i 0

     D MBDRVR          DS           266
      *             MBRD receiver
     D  RCVLEN                 1      4i 0
     D  #RECS                141    144i 0
     D RLKDTS          DS
      *             Number of records
     D  #NORLK               156    159i 0

     D LNKPOS          DS
      *             RlnkDef Key - used to position by scroll
     D  LRNAM
     D  LJNAM
     D  LPNAM
     D  LUNAM
     D  LUDAT

J4561d LSO_RPTNAM      c                   '1'
J4561d LSO_JOBNAM      c                   '2'
J4561d LSO_PGMNAM      c                   '3'
J4561d LSO_USRNAM      c                   '4'
J4561d LSO_USRDAT      c                   '5'

/3679d KeyOrder        s             10
/3679d KeyRTypID       s                   like(RTYPID)
/5826d KeyBig5         s             50

      * conversation versions
/3765d CV@DMS71        c                   '71000'
/    d CVersID         s              5                                         Major/Minor/Vers
/    d CVersIDx        s                   like(CVersID)

J2674d intCeiling      s             10i 0
/    d x               s             10i 0
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
J4561 /free
J4561  exec sql set option closqlcsr=*endmod,commit=*none;
J4561 /end-free
     C     *ENTRY        PLIST
     C                   PARM                    FILE             10            "RlnkDef"
     C                   PARM                    OPCODE            6            Opcode
     C                   PARM                    SETKEY           50            Rlnk start
     C                   PARM                    WEBAPP           10            Web Applic.
     C                   PARM                    WEBUSR           20            Web Applic.
     C                   PARM                    SCROLL            3            Scroll factr
     C                   PARM                    SDT                            Return data
     C                   PARM                    RTNREC            9 0          Rtn # of rec
     C                   PARM                    RTNCDE            2            Return code
/3765c                   parm                    CVersIDx                       Major/Minor/Vers

     C     OPCODE        CASEQ     'QUIT  '      QUIT                           Shutdown
     C                   ENDCS

     c                   eval      CVersID = *blanks
     c                   if        %parms >= 10
/3765c                   eval      CVersID = CVersIDx                           Major/Minor/Vers
     c                   end

     C                   CLEAR                   SDT
     C                   CLEAR                   RTNREC
     C                   MOVE      '00'          RTNCDE
     C                   EXSR      CHKWEB
     C                   EXSR      SETPOS                                       Set Position
     C                   EXSR      READ                                         Read&lodeBfr
      /free
       if file = 'RLNKDEF3';
         exec sql close c1;
       endif;
      /end-free
     C                   RETURN

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKWEB        BEGSR
      *          Check if request was issued from WEB

     C     WEBUSR        IFEQ      *BLANKS
     C     WEBAPP        ANDEQ     *BLANKS
     C     WEBUSR        OREQ      '*SYSUSR'
     C                   MOVE      '0'           DOWEB             1
     C                   ELSE

      *  OPEN THE FILES FOR WEB ACCESS
     C     WEBOPN        IFNE      '1'
     C                   OPEN      WDACCL01
     C                   OPEN      WCPWDP
     C                   MOVE      '1'           WEBOPN            1
     C                   ENDIF
/3679c                   if        not %open(RMaint4)
/    c                   open      RMaint4
/    c                   end

     C     WEBAPP        IFNE      LSTAPP
     C     WEBUSR        ORNE      LSTUSR
     C     *LIKE         DEFINE    WEBAPP        LSTAPP
     C     *LIKE         DEFINE    WEBUSR        LSTUSR
     C                   MOVE      WEBAPP        LSTAPP
     C                   MOVE      WEBUSR        LSTUSR
     C                   MOVE      '1'           DOWEB
      *  TRY TO FIND OUT IF THE USR OR GRP IS USED
     C     KEYUSR        CHAIN     WCPWDP                             20
     C     *IN20         IFEQ      *ON
     C     WCACT         OREQ      'N'                                          NOT ACTIVE
     C                   MOVE      '30'          RTNCDE
     C                   ELSE
      * CHECK FOR *ALL RECORD. IF FOUND, DO REGULAR CS ACCESS
     C                   CLEAR                   WDUSR
     C     USRALL        CHAIN     WDACCL01                           20        USER *ALL
     C     *IN20         IFEQ      *OFF
     C                   MOVE      '0'           DOWEB             1
     C                   ELSE
     C     USRACC        CHAIN     WDACCL01                           20        USER OBJECT
     C     *IN20         IFEQ      *ON
     C     WCGRP         ANDNE     *BLANKS
     C     GRPALL        CHAIN     WDACCL01                           20        GROUP *ALL
     C     *IN20         IFEQ      *OFF
     C                   MOVE      '0'           DOWEB             1
     C                   ELSE
     C     GRPACC        CHAIN     WDACCL01                           20        GROUP OBJECT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *=========================================
     C     KEYUSR        KLIST
     C                   KFLD                    WEBAPP
     C                   KFLD                    WEBUSR
     C     USRACC        KLIST
     C                   KFLD                    WCUSR
     C                   KFLD                    WEBAPP
     C                   KFLD                    SPYLNK
     C     GRPACC        KLIST
     C                   KFLD                    WCGRP
     C                   KFLD                    WEBAPP
     C                   KFLD                    SPYLNK
     C     GRPALL        KLIST
     C                   KFLD                    WCGRP
     C                   KFLD                    WEBAPP
     C                   KFLD                    SPYLNK
     C                   KFLD                    STAALL
     C     USRALL        KLIST
     C                   KFLD                    WCUSR
     C                   KFLD                    WEBAPP
     C                   KFLD                    SPYLNK
     C                   KFLD                    STAALL

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     REDNRM        BEGSR
      *          Read the next non-DASDLINK, authorized LnkDef record

     C     LPNAM         DOUNE     'DASDLINK'
     C     AUTH          ANDEQ     'Y'
J4561 /free
J4561  select;
J4561    when file = 'RLNKDEF' or file = 'RLNKDEF2';
J4561 /end-free
     C     OPCODE        IFEQ      'READ'
     C                   READ      LNKDEF                                 20
     C                   ELSE
     C                   READP     LNKDEF                                 20
     C                   END
     C   20              LEAVE
/5826c     LBIG5         CHAIN     RMAINT                             21
/    c   21              ITER
/    c                   if        DOWEB = '1'                                  VCO
/    c     KEYOBJ        CHAIN     WDACCL01                           22
/    c   22              ITER
/    c                   end
J4561 /free
J4561  when file = 'RLNKDEF3';
J4561    exec sql fetch c1 into :rlnkdefDS,:rmaintDS;
J4561    *in20 = *off;
J6396    if sqlcod = 100 or sqlcod < 0; //EOF or SQL error.
J4561      *in20 = *on; //CS end of data indicator.
J4561      leave;
J4561    endif;
J4561    lrnam = rlnkdefDS.lrnam;
J4561    ljnam = rlnkdefDS.ljnam;
J4561    lpnam = rlnkdefDS.lpnam;
J4561    lunam = rlnkdefDS.lunam;
J4561    ludat = rlnkdefDS.ludat;
J4561    lnkfil = rlnkdefDS.lnkfil;
J4561    rrnam = rmaintDS.rrnam;
J4561    rjnam = rmaintDS.rjnam;
J4561    rpnam = rmaintDS.rpnam;
J4561    runam = rmaintDS.runam;
J4561    rudat = rmaintDS.rudat;
J4561    rrdesc = rmaintDS.rrdesc;
J4561    rtypid = rmaintDS.rtypid;
J4561    riname = rmaintDS.riname;
J4561  endsl;
J4561 /end-free
     C                   EXSR      RPTSEC
     C                   ENDDO

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     REDWEB        BEGSR
      *          Read the next valid, authorized WEB Access DB record

     C     *IN21         DOUEQ     *OFF
     C     OPCODE        IFEQ      'READ'
     C     KEYTYP        READE     WDACCL01                               20
     C                   ELSE
     C     KEYTYP        READPE    WDACCL01                               20
     C                   END
     C   20              LEAVE

     C     KEYTYP        KLIST
     C                   KFLD                    WDUSR
     C                   KFLD                    WEBAPP
     C                   KFLD                    SPYLNK

     C     WDOBJ         CHAIN     RMNTRC4                            21
     C     *IN21         IFEQ      *OFF
     C     RBIG5         CHAIN     LNKDEF                             21
     C     *IN21         IFEQ      *OFF
     C                   EXSR      RPTSEC
     C     AUTH          IFEQ      'N'
     C                   SETON                                        21
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3679c     ReadRTypID    begsr

     c                   do        *hival
     C     OPCODE        IFEQ      'READ'
     C                   READ      RMNTRC4                                20
     C                   ELSE
     C                   READP     RMNTRC4                                20
     C                   END
     C   20              LEAVE
     C     RBIG5         CHAIN     LNKDEF                             21
     c   21              iter
     C                   EXSR      RPTSEC
     C     AUTH          IFEQ      'N'
     c                   iter
     C                   ENDIF
     c                   leave
     C                   ENDDO

/3679c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     READ          BEGSR
      *          Read RLNKDEF file for records with a SpyLink file.
      *          Put RMaint data for these into the DTS array.

J1939c                   select
/    c                   when      file = 'RLNKDEF'
J2674C                   eval      intCeiling = MAX_DTS
/    c                   when      file = 'RLNKDEF2'
J4561c                             or file = 'RLNKDEF3'
J2674c                   eval      intCeiling = MAX_DTS2
/    c                   endsl

T2674C                   for       x = 1 to intCeiling

     c                   select
/5826c                   when      DOWEB = '1' and                              Web
/    c                              (CVersID = *blanks or KeyOrder = 'RTYPEID')
     C                   EXSR      REDWEB
J7017c                   when      KeyOrder = 'RTYPEID' and file <> 'RLNKDEF3'
/3679c                   exsr      ReadRTypID
     c                   other
     C                   EXSR      REDNRM
     c                   endsl

     C     *IN20         IFEQ      *ON
     C                   MOVE      '20'          RTNCDE                         Warning Eof
     C                   LEAVE                                                   or Bof.
     C                   ENDIF
J3957
J3957 /free
J3957  if lnkfil = ' ' and CoExSupEmpty = 'N';
J3957    clear chkObjRC;
J3957    chkObj('COEX':'QTEMP':'*DTAARA':chkObjRC);
J3957    if chkObjRC = '0';
J3957      bldLnkFil(rrnam:rjnam:rpnam:runam:rudat:0:rrdesc:lnkfil:crtndxMsgID);
J3957    endif;
J3957  endif;
J3957 /end-free
     C     LNKFIL        IFEQ      *BLANKS                                      No Spylnk,
     C                   SUB       1             X
     C                   ITER                                                    next def.
     C                   ELSE
     C                   CALL      'MAG1036'                                    Does LNKFIL
     C                   PARM                    ER1036           80            exist?
     C                   PARM      '*LIBL'       LIBR             10
     C                   PARM                    LNKFIL
     C                   PARM      '*FILE'       APITYP           10

     C     ER1036        IFNE      *BLANK                                        No,next def
     C                   SUB       1             X
     C                   ITER
     C                   END
     C                   END

     C                   EXSR      GETINF                                       RMaint data

J1939 /free
/      select;
/        when file = 'RLNKDEF';
/          dts(x) = mntdta;
J4561    when file = 'RLNKDEF2' or file = 'RLNKDEF3';
J1939      mntdta2.rrnam = rrnam;
J4561      if file = 'RLNKDEF3';
J4561        select;
J4561          when lnkSrtOrd = LSO_JOBNAM and rjnam <> ' ';
J4561            mntdta2.rrnam = rjnam;
J4561          when lnkSrtOrd = LSO_PGMNAM and rpnam <> ' ';
J4561            mntdta2.rrnam = rpnam;
J4561          when lnkSrtOrd = LSO_USRNAM and runam <> ' ';
J4561            mntdta2.rrnam = runam;
J4561          when lnkSrtOrd = LSO_USRDAT and rudat <> ' ';
J4561            mntdta2.rrnam = rudat;
J4561        endsl;
J4561      endif;
J1939      mntdta2.rrdesc = rrdesc;
/          mntdta2.rtypid = rtypid;
/          mntdta2.rlnkfl = rlnkfl;
/          mntdta2.rsec = rsec;
/          dts2(x) = mntdta2;
/      endsl;
/     /end-free

/2674C                   EndFor

     C     X             SUB       1             RTNREC                         #OfRecsToRtn
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RPTSEC        BEGSR
      *          Check user Authority for Folder/Library
     c                   eval      calpgm = 'SPYCSLRMNT'
     C                   CALL      'MAG1060'
     C                   PARM                    CALPGM           10            Caller
     C                   PARM      ' '           PGMOFF            1            Unload pgm
     C                   PARM      'R'           CKTYPE            1            Chk R)eport
     C                   PARM      'R'           OBJCOD            1            Obj R)eport
     C                   PARM      *BLANK        OBJNAM           10
     C                   PARM      *BLANK        OBJLIB           10
     C                   PARM      LRNAM         @RNAM            10            Big5
     C                   PARM      LJNAM         @JNAM            10             :
     C                   PARM      LPNAM         @PNAM            10             :
     C                   PARM      LUNAM         @UNAM            10             :
     C                   PARM      LUDAT         @UDAT            10             :
     C                   PARM      25            REQOPT            2 0          List Opt
     C                   PARM      'N'           AUTH              1            Rtn auth Y/N
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     GETINF        BEGSR
      *          Get fields from the RMAINT file

     C                   Z-ADD     ROLGEN        @ROLGE
     C                   Z-ADD     ROFGEN        @ROFGE
     C                   Z-ADD     ROLDAY        @ROLDA
     C                   Z-ADD     ROFDAY        @ROFDA
     C                   Z-ADD     RLCKH         @RLCKH
     C                   MOVE      LNKFIL        RLNKFL

      * GET NUMBER OF RECORDS FOR @000.. FILE
     C                   CLEAR                   #RECS
     C     LNKFIL        IFNE      *BLANKS
     C     LNKFIL        CAT       DTALIB        DBFILE           20            Get # recs
     C                   CALL      'QUSRMBRD'                           50       on DASD.
     C                   PARM                    MBDRVR                         Retrieve
     C                   PARM      266           RCVLEN                         Member
     C                   PARM      'MBRD0200'    FORMAT            8            Description
     C                   PARM                    DBFILE                            File
     C                   PARM                    LNKFIL                            Member
     C                   PARM      '0'           OVRPRO            1               no OvrRde
     C                   PARM                    ERRCD
     C     @ERTCD        IFNE      0
     C     *IN50         OREQ      *ON
     C                   Z-ADD     0             #RECS
     C                   ENDIF
     C                   ENDIF

     C     LBIG5         SETLL     RLNKOFF                                50     Link locatn

     C                   SELECT
     C     #RECS         WHENNE    0
     C     *IN50         ANDEQ     *OFF
     C     RINAME        IFEQ      *BLANKS
     C                   MOVE      ' '           RSEC                           Online
     C                   ELSE
     C                   MOVE      'A'           RSEC                           Online
     C                   END

     C     #RECS         WHENEQ    0
     C     *IN50         ANDEQ     *ON
     C     RINAME        IFEQ      *BLANKS
     C                   MOVE      '1'           RSEC                           Offline rpt
     C                   ELSE
     C                   MOVE      'B'           RSEC                           Offline img
     C                   END

     C     #RECS         WHENNE    0
     C     *IN50         ANDEQ     *ON
     C     RINAME        IFEQ      *BLANKS
     C                   MOVE      '2'           RSEC                           ONL+OFFL rpt
     C                   ELSE
     C                   MOVE      'C'           RSEC                           ONL+OFFL img
     C                   END

     C                   OTHER
     C     RINAME        IFEQ      *BLANKS
     C                   MOVE      '3'           RSEC                           *NONE
     C                   ELSE
     C                   MOVE      'D'           RSEC                           *NONE
     C                   END
     C                   ENDSL

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETPOS        BEGSR
      * check key order

/3679c                   exsr      ChkKeyOrd
     c                   select
/5826c                   when      DOWEB = '1' and                              Web
/    c                              (CVersID = *blanks or KeyOrder = 'RTYPEID')
     c                   exsr      SETWEB
J7017c                   when      KeyOrder = 'RTYPEID' and file <> 'RLNKDEF3'
     c                   exsr      SetRTypID
     c                   other
J4561 /free
J4561  select;
J4561    when file = 'RLNKDEF' or file = 'RLNKDEF2';
J4561 /end-free
     c                   exsr      SETNRM
J4561 /free
J4561    when file = 'RLNKDEF3';
J4561      setLnkSrtOrd();
J4561  endsl;
J4561 /end-free
     c                   endsl

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3679c     ChkKeyOrd     begsr
      * check requested key order

/5826c                   if        CVersID <> *blanks
/    c                               and not %open(RMaint4)
/    c                   open      RMaint4
/    c                   end

     c                   eval      KeyOrder = 'BIG5'                            default
     c                   eval      KeyRTypID = *blanks
     c                   eval      KeyBig5   = *blanks
/    c                   select
/5828c                   when      CVersID = *blanks or
/5828c                             %subst(SetKey:11:10) <> '*RTYPID' and
     c                             doweb <> '1'
/5826c                   eval      KeyBig5 = SetKey
/5826c                   when      %subst(SetKey:11:10) = '*RTYPID' or
     c                             doweb = '1'
/5826c                   eval      KeyRTypID = %subst(SetKey:1:10)
/5826c                   eval      KeyOrder = 'RTYPEID'
/5826c                   eval      KeyRTypID = %subst(SetKey:1:10)
     c                   endsl

/3679c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3679c     SetRTypID     begsr

     c                   if        OPCODE = 'READ'
     c     KeyRTypID     setll     RMaint4
     c                   else
     c     KeyRTypID     setgt     RMaint4
     c                   end

/3679c                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETNRM        BEGSR
      *          Position to Lnkdef recd based on percentage scroll

     C     SCROLL        IFEQ      *BLANKS
/5826c                   eval      LnkPos = KeyBig5
     C     LBIG5         SETLL     RLNKDEF
     C                   ELSE
     C     ONCE          IFNE      'Y'
     C                   MOVE      'Y'           ONCE              1
     C                   Z-ADD     #NORLK        RPT#              9 0
     C     RPT#          DIV       100           UNITS             9 2
     C                   MOVE      *LOVAL        LRNAM
     C                   MOVE      *LOVAL        LJNAM
     C                   MOVE      *LOVAL        LPNAM
     C                   MOVE      *LOVAL        LUNAM
     C                   MOVE      *LOVAL        LUDAT
     C     LBIG5         SETLL     RLNKDEF
      * Skip dasdlinks
     C     LPNAM         DOUNE     'DASDLINK'
     C     *IN91         OREQ      *ON
     C                   READ      LNKDEF                                 91
     C                   ENDDO

     C                   MOVE      LNKPOS        SPY(1)
     C                   MOVE      'X'           PCT(1)
     C                   MOVE      *HIVAL        LRNAM
     C                   MOVE      *HIVAL        LJNAM
     C                   MOVE      *HIVAL        LPNAM
     C                   MOVE      *HIVAL        LUNAM
     C                   MOVE      *HIVAL        LUDAT
     C     LBIG5         SETLL     RLNKDEF
      * Skip dasdlinks
     C     LPNAM         DOUNE     'DASDLINK'
     C     *IN91         OREQ      *ON
     C                   READP     LNKDEF                                 91
     C                   ENDDO

     C                   Z-ADD     100           PS                3 0
     C                   MOVE      LNKPOS        SPY(PS)
     C                   MOVE      'X'           PCT(PS)
     C                   ENDIF

     C                   MOVE      SCROLL        SCROL2            2 0          Set PS in
     C     1             ADD       SCROL2        SCRPCT            3 0           range 1-100

     C                   Z-ADD     SCRPCT        PS

     C     PCT(PS)       IFEQ      ' '
     C                   MOVEA     PCT           PCC             100
     C     PS            SUBST(P)  PCC:1         PCTCHK          100
     C     ' '           CHECKR    PCTCHK        TOPPCT            3 0
     C                   SUB       1             TOPPCT
     C     100           SUB       SCRPCT        PS
     C                   ADD       1             PS
     C     PS            SUBST(P)  PCC:SCRPCT    PCTCHK
     C     ' '           CHECK     PCTCHK        BOTPCT            3 0
     C                   ADD       SCRPCT        BOTPCT
     C                   SUB       1             BOTPCT
     C                   MOVE      SCRPCT        SCRFCT            2 2          Wanted  %ile
     C                   MOVE      TOPPCT        TOPFCT            3 2          HiRange %ile
     C                   MOVE      BOTPCT        BOTFCT            3 2          LoRange %ile
     C     SCRFCT        MULT      RPT#          POSREC            9 0          Wanted   RRN
     C     TOPFCT        MULT      RPT#          FRMTOP                         Hi range RRN
     C     BOTFCT        MULT      RPT#          FRMBOT                         Lo range RRN

     C     POSREC        IFEQ      0
     C                   Z-ADD     1             POSREC
     C                   ENDIF

     C     POSREC        SUB       FRMTOP        FRMTOP            9 0
     C                   SUB       POSREC        FRMBOT            9 0

     C     FRMTOP        IFLE      FRMBOT
     C                   Z-ADD     TOPPCT        PS
     C                   ADD       1             PS
     C                   MOVE      SPY(PS)       LNKPOS
     C     LBIG5         SETLL     LNKDEF
     C                   Z-ADD     0             U
     C                   Z-ADD     PS            US                3 0

     C     US            DOUEQ     SCRPCT
     C     LPNAM         DOUNE     'DASDLINK'
     C     *IN91         OREQ      *ON
     C                   READ      LNKDEF                                 91
     C                   ENDDO

     C                   ADD       1             U                 9 4
     C     U             IFGE      UNITS
     C                   SUB       UNITS         U
     C                   ADD       1             US

     C     PCT(US)       IFEQ      ' '
     C                   MOVE      'X'           PCT(US)
     C                   MOVE      LNKPOS        SPY(US)
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO

     C                   ELSE
     C                   Z-ADD     BOTPCT        PS
     C                   MOVE      SPY(PS)       LNKPOS
     C     LBIG5         SETLL     LNKDEF
     C                   Z-ADD     0             U
     C                   Z-ADD     PS            US

     C     US            DOUEQ     SCRPCT

     C     LPNAM         DOUNE     'DASDLINK'
     C     *IN91         OREQ      *ON
     C                   READP     LNKDEF                                 91
     C                   ENDDO

     C                   ADD       1             U
     C     U             IFGE      UNITS
     C                   SUB       UNITS         U
     C                   SUB       1             US

     C     PCT(US)       IFEQ      ' '
     C                   MOVE      'X'           PCT(US)
     C                   MOVE      LNKPOS        SPY(US)
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF

     C                   Z-ADD     SCRPCT        PS
     C                   MOVE      'X'           PCT(PS)
     C                   MOVE      LNKPOS        SPY(PS)
     C                   ENDIF

     C                   MOVE      SPY(PS)       LNKPOS
     C     LBIG5         CHAIN     LNKDEF                             91
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETWEB        BEGSR

/5826c                   if        (KeyOrder='RTYPEID' and KeyRTypID = *blanks)
/    c                             or (KeyOrder='BIG5' and KeyBig5 = *blanks)
     C     KEYTYP        SETLL     WDACCL01
     C                   ELSE
/5826c                   if        KeyOrder = 'RTYPEID'
/    c                   eval      RTypID = KeyRTypID
/    c                   setoff                                       91
/    c                   else
/5826c                   eval      LnkPos = KeyBig5
     C     LBIG5         CHAIN     RMAINT                             91
/    c                   end
     C     *IN91         IFEQ      *OFF
     C     OPCODE        IFEQ      'READ'
     C     KEYOBJ        SETLL     WDACCL01
     C                   ELSE
     C     KEYOBJ        SETGT     WDACCL01
     C                   ENDIF
     C                   ELSE
     C     OPCODE        IFEQ      'READ'
     C     KEYTYP        SETGT     WDACCL01                                     SET TO EOF
     C                   ELSE
     C     KEYTYP        SETLL     WDACCL01                                     SET TO BOF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     C     KEYOBJ        KLIST
     C                   KFLD                    WDUSR
     C                   KFLD                    WEBAPP
     C                   KFLD                    SPYLNK
     C                   KFLD                    RTYPID
/2153C                   KFLD                    OBJLIB
     C     LBIG5         KLIST
     C                   KFLD                    LRNAM
     C                   KFLD                    LJNAM
     C                   KFLD                    LPNAM
     C                   KFLD                    LUNAM
     C                   KFLD                    LUDAT
     C     RBIG5         KLIST
     C                   KFLD                    RRNAM
     C                   KFLD                    RJNAM
     C                   KFLD                    RPNAM
     C                   KFLD                    RUNAM
     C                   KFLD                    RUDAT

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR

     C     BENHER        IFEQ      ' '
     C                   MOVE      'Y'           BENHER            1
     C                   CALL      'MAG1060'
     C                   PARM                    CALPGM                         Caller
     C                   PARM      'Y'           PGMOFF                         Unload pgm
     C                   ENDIF

     C                   CLOSE     *ALL
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
     C                   IN        SYSDFT
     C                   OPEN      RMAINT
     C                   OPEN      RLNKDEF
     C                   OPEN      RLNKOFF
     C                   MOVEL     '*SPYLINK'    SPYLNK           10
     C                   MOVEL     '*ALL'        STAALL           10
/2153C                   MOVEL     *BLANKS       OBJLIB           10
J4561 /free
J4561  // Default to report name sort order if sysdft value is not set.
J4561  if file = 'RLNKDEF3' and (lnkSrtOrd < '1' or lnkSrtOrd > '5');
J4561    lnkSrtOrd = '1';
J4561  endif;
J4561 /end-free
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *PSSR         BEGSR
     C                   MOVE      '30'          RTNCDE
     C                   EXSR      QUIT
     C                   ENDSR
      *--------------------------------------------------
J4561p setLnkSrtOrd    b


J6396d sqlStmt         s            512
J4561d chkLogical      s             10
J4561d srtOrdFld       s              6
J4561d SQ              c                   ''''
J5088d asteriskPos     s             10i 0
J7017d setKeyStr       s             10i 0 inz(1)
J7017d setKeyLen       s             10i 0 inz(10)

J4561 /FREE

J4561  if file <> 'RLNKDEF3';
J4561    return;
J4561  endif;

J4561  select;
J7017    when %subst(setKey:11:8) = '*RTYPID';
J7017      srtOrdFld = 'RTYPID';
J4312    when %subst(setKey:1:7) = '*RRDESC';
J4312      srtOrdFld = 'RRDESC';
J7017      setKeyStr = 11;
J7017      setKeyLen = 40;
J4561    when lnkSrtOrd = LSO_RPTNAM;
J4561      srtOrdFld = 'RRNAM';
J4561    when lnkSrtOrd = LSO_JOBNAM;
J4561      srtOrdFld = 'RJNAM';
J4561    when lnkSrtOrd = LSO_PGMNAM;
J4561      srtOrdFld = 'RPNAM';
J4561    when lnkSrtOrd = LSO_USRNAM;
J4561      srtOrdFld = 'RUNAM';
J4561    when lnkSrtOrd = LSO_USRDAT;
J4561      srtOrdFld = 'RUDAT';
J4561  endsl;

J4561  sqlStmt = 'select rlnkdef.*, rmaint.* from rlnkdef join rmaint on ' +
J4561    'rrnam=lrnam and rjnam=ljnam and rpnam=lpnam and runam=lunam and ' +
J4561    'rudat=ludat';

J4561  // Specify positioning key within result set.
J4561  if setKey <> ' ';
J7017    sqlStmt = %trimr(sqlStmt) + ' where ucase(trim(' +
J7017      %trim(srtOrdFld) + '))';
J5088    // Look for asterisk for wildcard search.
J5088    asteriskPos = %scan('*':%subst(setkey:setKeyStr:setKeyLen));
J5088    if asteriskPos > 0;
J5088      dow asteriskPos > 0;
J5088        %subst(setkey:setkeyStr:setKeyLen) =
J7017          %replace('%':%subst(setkey:setKeyStr:setKeyLen):asteriskPos:1);
J5088        asteriskPos = %scan('*':%subst(setkey:setKeyStr:setKeyLen));
J5088      enddo;
J5088      sqlStmt = %trimr(sqlStmt) + ' like';
J5088    else;
J5088      sqlStmt = %trimr(sqlStmt) + ' >=';
J5088    endif;
J7017    if asteriskPos > 0;
J5088      sqlStmt = %trimr(sqlStmt) +
J5088        ' ucase(' + sq + %trim(%subst(setKey:setKeyStr:setKeyLen)) +sq+')';
J7017    else;
J7017      sqlStmt = %trimr(sqlStmt) +
J7017        ' ucase(' + sq + %trim(%subst(setKey:setKeyStr:setKeyLen)) +
J7017        sq + ')';
J7017    endif;
J4561  endif;

J4312  // Order by.
J4312  sqlStmt = %trimr(sqlStmt) + ' order by ' + srtOrdFld;
J7017  if srtOrdFld <> 'RRDESC' and srtOrdFld <> 'RTYPID';
J4561    // Order by specfied big5 key and report type.
J4312    sqlStmt = %trimr(sqlStmt) + ',rtypid';
J4312  endif;
J4312  sqlStmt = %trimr(sqlStmt) + ' for fetch only';

J4561  exec sql prepare stmt from :sqlStmt;
J4561  exec sql declare c1 cursor for stmt;
J4561  exec sql open c1;

J4561  return;

J4561 /END-FREE
J4561P setLnkSrtOrd    E

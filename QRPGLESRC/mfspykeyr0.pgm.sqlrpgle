      *%METADATA                                                       *
      * %TEXT Key Code Client Side Maintenance                         *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR':'QC2LE') actgrp('DOCMGR')
     h copyright('Open Text Corporation')
      //
      // CLIENT SIDE KEY CODE MAINTENANCE.
      //
      //
J6082 // 01-27-15 PLR Increase size of licensed user field from 3 to 6.
      //              Requires the use of a file versus a userspace to
      //              track licenses because userspaces tap out at 16MB and
      //              the total amount of jobs with 999,999 licensed users
      //              is 17MB and change.
J3754 // 10-08-12 PLR Add operation code to program interface to allow
      //              printing from DOCINFO.
J2166 // 10-27-09 PLR Move print application to this program. Print app
      //              would not acknowledge changes in product list such as
      //              adding a new product.
J2163 // 10-21-09 PLR Do not update values until all data is validated.
J1299 // 06-08-09 PLR Add program library to checking to further enhance the
      //              prevention of loading multiple unlicense versions of
      //              DocMgr. Works with LPAR checking.
T6896 // 05-02-08 PLR Add LPAR checking.
T5641 // 02-01-07 EPG Enable the license key to be printed.
T5726 // 09-25-06 PLR Remove system id, model and feature code from
/     //              preamble level of hash. Add these values in at
/     //              the license product portion of the hash if
/     //              permanently licensed product. This allows production
/     //              and support the ability to give out limited
/     //              software evaluations without having to know system
/     //              information. Change encryption private key from the sysid
      //              to a static variable.
/7709 // 03-30-03 GT  Changed to call function MD5HashAsc2
/5291 // 08-20-01 PLR Added repeat function.
/5154 // 08-06-01 PLR SysVal QALWUSRDMN does not allow for pointer reference
      //              to the user license tracking user spaces. To correct this,
      //              the data library needs to be added to the sysval list of
      //              libraries or set to *ALL.
      // 01-25-01 PLR USE API TO RETRIEVE PROCESSOR FEATURE CODE.
/3468 // 12-28-00 PLR REPLACE KY00053 COPYRIGHT MSG WITH P001154.
/3469 // 12-05-00 PLR MOVE CMDKEYS TO BOTTOM OF SCREEN.
/3434 // 12-05-00 PLR CLEAR SUBFILE WHEN ALL RECORDS DELETED.
/2840 // 10-31-00 PLR ADDED CUSTOM KEY CODE MAINTENANCE FOR TIFF VIEWER.
/1497 // 08-25-00 PLR KEY CODE MAINTENANCE FOR CLIENT SIDE INTERFACE.
      //              CREATED FOR VERSION 7.00.00. /1497
      //
     FMFSPYKEYD CF   E             WORKSTN SFILE(WDWSFL01:RRN1)
     F                                     SFILE(WDWSFL02:RRN2)
     f                                     infds(skminf)
     FMFKYMST   UF A E           K DISK
     FMFKYLIC   UF A E           K DISK
     FMFKYPRD   IF   E           K DISK
     FSPYCTL    IF   E           K DISK
J2166fmfspykeyp o    e             printer oflind(*in01) usropn

T6896 /copy qsysinc/qrpglesrc,qpmlpmgt

J6082 // RETRIEVE JOB INFORMATION PROTOTYPE.
J6082D RJI             PR                  EXTPGM('QUSRJOBI')
/8130D  RJIRCV                       61
J6082D  RJIRLEN                      10I 0 CONST
J6082D  RJIFMT                        8    CONST
J6082D  RJIQJOB                      26    CONST
J6082D  RJIJID                       16    CONST
/8130D  RJIERR                      116    OPTIONS(*VARSIZE:*NOPASS)
J6082D                 DS
J6082D RJIRCV                        61
J6082D  RJIIJI                       16    OVERLAY(RJIRCV:35)
J6082D  RJISTS                       10    OVERLAY(RJIRCV:51)

J6082D APIER           DS
J6082D  ERBYTPRV                     10I 0 INZ(%SIZE(APIER))
J6082D  ERBYTAVL                     10I 0
J6082D  ERMSGID                       7A
J6082D  ERRSV1                        1A
J6082D  ERMSGDATA                    80A

J6082d chkObj          pr                  extpgm('SPCHKOBJ')
J6082d  object                       10    const
J6082d  objectLib                    10    const
J6082d  objectType                   10    const
J6082d  existRtn                      1
J6082d chkObjRtn       s              1

J3754d run             pr                  extproc('system')
J3754d  command                        *   value options(*string)
J2163d loadWrkArr      pr
J2163d setWrkArrVal    pr
J2163d setFldVal       pr

     D                SDS
     D PGMQ              *PROC
     D CURUSER               254    263

     D SKMINF          DS
     D  CURRCD               261    270
     D  SKMRRN               397    400I 0

      // RETRIEVE CURRENT DATE TIME.
     D GETDTTM         PR            17

      // SEND PROGRAM MESSAGE.
     D SPM             PR
     D  MSGID                         7    VALUE
     D STACKCNT        S             10I 0

      // RETURN PROCESSOR FEATURE CODE.
     D PRCFTR          PR             4

      // RETRIEVE PRODUCT NAME FROM SPYCTL.
     D RTVPRDNAM       PR            25
     D  PRODUCT#                      3  0

      // MD5 HASHING ALGORITHM PROTOTYPE.
     D MD5HASHA        PR                  EXTPROC('MD5HashAsc2')
     D  PKEY                      32767A   OPTIONS(*VARSIZE)
     D  IKEYLEN                      10I 0 VALUE
     D  PDATA                     32767A   OPTIONS(*VARSIZE)
     D  IDATALEN                     10I 0 VALUE
     D  DIGEST                       16A
     D PDATA           S          32767A

      // API ERROR DATA STRUCTURE.
     D APIERR          DS
     D  ERBYTPRV                     10I 0 INZ(%SIZE(APIERR))
     D  ERBYTAVL                     10I 0
     D  ERMSGID                       7A
     D  ERRSV1                        1A
     D  ERMSGDATA                    80A

      // CONVERT BINARY TO HEX CHARACTER REPRESENTATION.
     D CVTHC           PR                  EXTPROC('cvthc')
     D  RCV                            *   VALUE
     D  SRC                            *   VALUE
     D  RCVLEN                       10I 0 VALUE

      // CONVERT HEX TO BINARY REPRESENTATION.
     D CVTCH           PR                  EXTPROC('cvtch')
     D  RCV                            *   VALUE
     D  SRC                            *   VALUE
     D  RCVLEN                       10I 0 VALUE

      // RETRIEVE SINGULAR SYSTEM VALUE.
     D RSV             PR            10    EXTPROC('MGRTVSVLR')
     D  SYSVALNAM                    10    VALUE

J2166d ExtKeyApp       pr                  extpgm(skpkca)
/    d  opcode                        2  0 const
/    d  expiry                        8  0
/    d  extendedData                256    options(*nopass)
/    d EXT_KEY_INT     c                   1
/    d EXT_KEY_RTV     c                   2

T6896d dlparGetInfo    pr            10i 0 extproc('dlpar_get_info')
     d  receiver                       *   value
     d  dataFormat                   10i 0 value
     d  receiverLen                  10i 0 value

     D SKMDTTM         DS
     D  SKMDLC
     D  SKMTLC

     D                 DS
     D SKMKCD_O                      32
     D  SKMKCD1                            OVERLAY(SKMKCD_O:1)
     D  SKMKCD2                            OVERLAY(SKMKCD_O:9)
     D  SKMKCD3                            OVERLAY(SKMKCD_O:17)
     D  SKMKCD4                            OVERLAY(SKMKCD_O:25)

J2163d prodWork        ds                  dim(999) qualified
/    d  sklprd                             like(sklprd) inz
/    d  skputl                             like(skputl) inz
/    d  skpkca                             like(skpkca) inz
/    d  prodName                           like(prodName) inz
/    d  skl#us                             like(skl#us) inz
/    d  skldmo                             like(skldmo) inz
/    d  delete                         n   inz('0')

      // RETURN CURRENT DATE PLUS ONE MONTH. DEMO DATE.
     D GETDMODAT       PR             8  0

      // SYSTEM DEFAULT DATA AREA. GET DATA LIB.
     D SYSDFT          DS          1024    DTAARA
J1299d  skmlib               296    305                                         Program Library
     D  DTALIB               306    315

J6082 // LICENSE TRACKING FILE
J6082D                 DS
J6082D ULTFIL                        20    INZ('MFULTXXXU')
J6082D  ULTPRD                        3    OVERLAY(ULTFIL:6)
J6082D  ULTLIB                       10    OVERLAY(ULTFIL:11)

     D PRDSLT          S                   LIKE(*IN)
     D X               S              5I 0
     D Y               S              5I 0
     D MAXRRN1         S                   LIKE(RRN1)
     D SKMVER_C        S              4
     D HC              C                   '0123456789ABCDEF'
     D ERRORS          S                   LIKE(*IN) INZ('0')
     D TSTKCD          S                   LIKE(SKMKCD)
     D ULTHSH          S             16
     D SAVOPT          S                   LIKE(OPTION)
     d saveDemo        s                   like(SKLDMO)
     d save#us         s                   like(SKL#US)
     D STRCSR          S                   LIKE(RRN2)
     D ENDCSR          S                   LIKE(RRN2)
     D maxrrn2         S                   LIKE(RRN2)
     d changed         s               n
T5726d pKey            s             50    inz('GaussVistaPlusInIrvineCA')
J2163d i               s             10i 0
J2166d extDta          s            256
/    d startPos        s             10i 0
/    d endPos          s             10i 0

J3757d printFlag       s               n   inz(*off)

J6082d sqlStmt         s           1024

      // CLIENT LICENSED PRODUCT KEY.
     C     LIC_KEY       KLIST
     C                   KFLD                    SKMSID
     C                   KFLD                    SKLPRD

      // PRODUCT KEY.
     C     PRD_KEY       KLIST
     C                   KFLD                    SKMSID
     C                   KFLD                    SKPPRD

J3754c     *entry        plist
J3754c                   parm                    opcode           10

      /FREE
       exec sql set option closqlcsr=*endmod,commit=*none,srtseq=*langidshr;
J3754  if %parms > 0 and opcode = 'PRINT';
J3754    printFlag = *on;
J3754    exsr prtLicSR;
J3754    *inlr = *on;
J3754    return;
J3754  endif;
       IN SYSDFT;
J6082  ultlib = skmlib;
       EXSR CUSTEDIT;

       *INLR = '1';

       //*************************************************************************
       BEGSR CUSTEDIT;

         // EDIT CLIENT INFORMATION AND LICENSED PROGRAMS.

         // RETRIEVE SYSTEM SERIAL NUMBER.
         SKMSID = RSV('QSRLNBR');

         CHAIN SKMSID MFKYMST;
         *IN67 = NOT %FOUND;

         // GET REST OF SYSTEM VALUES.
         SKMMDL = RSV('QMODEL');
         SKMFTR = PRCFTR;

         // RETRIEVE SOFTWARE VERSION.
      /END-FREE
     C                   CALL      'SPYVERSION'
     C                   PARM                    PVER              3
     C                   PARM                    PPTF              2
     C                   PARM                    PBTA              2
     C                   PARM                    PRLSDT            8
     C                   PARM                    PRLSTM            6

      /FREE
         SKMVER_C = '0' + PVER;
         skmver = %dec(skmver_c:3:0);

         loadWrkArr();
         EXSR LOADSFL01;

       // Retrieve current logical partition number.
T6896  skmlpr = 0;
/      if dlparGetInfo(%addr(qpmdif1):1:%size(qpmdif1)) > 0;
/        skmlpr = QPMLNBR;
/      endif;

         // COPYRIGHT MESSAGE.
         SPM('P001154');

         DOW NOT *IN03 AND NOT *IN12;

           // CONVERT ENCRYPTED KEY TO DISPLAYBLE CHARS.
           IF SKMKCD <> ' ' AND ERRORS = '0';
             CVTHC(%ADDR(SKMKCD_O):%ADDR(SKMKCD):
                 %SIZE(SKMKCD_O));
           ENDIF;

           WRITE MSGCTL;
/3469      WRITE FKYWDW01;
           EXFMT WDWCTL01;
           ERRORS = '0';
      /END-FREE
     C                   MOVEA     '0000'        *IN(51)

      // REMOVE PROGRAM MESSAGES.
     C                   CALL      'QMHRMVPM'
     C                   PARM      '*'           STACK            10
     C                   PARM      0             STACKCNT
     C                   PARM      ' '           MSGKEY
     C                   PARM      '*ALL'        MSGTYPE          10
     C                   PARM                    APIERR

      /FREE
           IF SKMKCD_O = ' ';
             SKMKCD = ' ';
           ENDIF;

           SELECT;
           WHEN *IN03 OR *IN12;
             ITER;
           WHEN *IN05;
             EXSR RFSCTL01;
             ITER;
           when *in13 and rrn1 > 0;
             exsr repeatsr;
             spm('KY00082');
             iter;
           WHEN *IN14;
             EXSR DSPLSTCHG;
/5641      When *in15 = *on;
/            ExSr PrtLicSr;
           WHEN *IN04 OR RRN1 = 0;
             EXSR SELECTPROD;
             if prdslt = '1' or rrn1 = 0;
               exsr loadsfl01;
             endif;
           ENDSL;

           // ERROR CHECK CLIENT INFO.
           IF NOT *IN12;

             EXSR procsfl01;
             IF ERRORS = '0';

               // UPDATE CLIENT INFORMATION.
               SKMDTTM = GETDTTM;
               SKMULC = CURUSER;
               IF *IN67;
                 WRITE SKMREC;
               ELSE;
                 UPDATE SKMREC;
               ENDIF;
               CHAIN SKMSID MFKYMST;

               // RECORD UPDATED MESSAGE. KEY CODE ACCEPTED MESSAGE IF NOT BLANK.
               IF SKMKCD_O <> ' ';
                 SPM('KY00061');
               ELSE;
                 SPM('ACT0050');
               ENDIF;

               // IF EC = *ALL'0'
             ENDIF;

             // IF NOT *IN12
           ENDIF;

           *IN12 = '0';

         ENDDO;

       ENDSR;

       //*************************************************************************
       BEGSR LOADSFL01;

         // RESET SUBFILE.
         RRN1 = 0;
         *IN25 = '0';
         *IN26 = '1';
         OPTION = ' ';
/3434    *IN77 = '1';
         WRITE WDWCTL01;
         *IN26 = '0';
/3434    *IN77 = '0';

J2163    for i = 1 to %elem(prodWork);
/          if prodWork(i).sklprd = 0 or prodWork(i).delete;
/            iter;
/          endif;
/          setFldVal();
/          exsr subfile_atr;
/          rrn1 = rrn1 + 1;
/          write wdwsfl01;
/        endfor;

         MAXRRN1 = RRN1;
         IF RRN1 > 0;
           *IN25 = '1';
           RRN1 = 1;
           IF RRN1LOC > MAXRRN1;
             RRN1LOC = MAXRRN1;
           ENDIF;
           IF RRN1LOC > 0;
             RRN1 = RRN1LOC;
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       BEGSR procsfl01;

         // ERROR CHECK CLIENT INFORMATION.

         ERRORS = '0';

T5726    pdata =  '400' + %triml(%editc(skmver:'3'));

         // VALIDATE LICENSED PRODUCT SUBFILE.
         for rrn1 = 1 to maxrrn1;

           chain(e) rrn1 wdwsfl01;
           if not %found;
             leave;
           endif;

           IF SKLDMO = 0;
             SKLDMO = *ALL'9';
           ENDIF;

           if skputl = 'Y' and (skl#us = 0 or skldmo <> *all'9');
             skl#us = *all'9';
           endif;

           SELECT;
           WHEN OPTION = '4';
             prodWork(sklprd).delete = '1';
             iter;
           WHEN SKPKCA <> ' ' and option = '1';
J2166        ExtKeyApp(EXT_KEY_INT:skldmo:extDta);
           WHEN SKPUTL = 'Y' AND SKL#US = 0;
             *IN52 = '1';
             SPM('KY00051');
             RRN1 = X;
             ERRORS = '1';
           WHEN SKLDMO <> 99999999;
             TEST(DE) SKLDMO;
             if %error;
               *IN68 = '1';
               *IN53 = '1';
               ERRORS = '1';
               SPM('ERR0053');
             ENDIF;
           ENDSL;

           IF ERRORS = '1';
J2166        exsr subfile_atr;
/            update wdwsfl01;
/            LEAVE;
           ENDIF;

J2163      setWrkArrVal();
           exsr subfile_atr;
           update wdwsfl01;

           PDATA = %TRIMR(PDATA) +
               %TRIML(%EDITC(SKLPRD:'3')) +
               %TRIML(%EDITC(SKL#US:'3')) +
               %TRIML(%EDITC(SKLDMO:'3'));
T5726      if skldmo = *all'9';
/            pdata = %trim(pdata) + %trim(skmsid) +
/                %trim(skmmdl) + %trim(skmftr) +
T6896            %trim(%editc(skmlpr:'Z'))
J1299            + %trimr(skmlib);
T5726      endif;

         endfor;

         IF RRN1 > 0;
           RRN1 = 1;
           IF RRN1LOC > 0;
             RRN1 = RRN1LOC;
           ENDIF;
         ENDIF;

J2166    if errors;
/          leavesr;
/        endif;

         // VALIDATE KEY CODE IF ENTERED.
         EXSR CHECKKEY;

         // Write changes and reload subfile; create license tracking user spaces.
J2163    IF not errors;
/          for i = 1 to %elem(prodWork);
/            if prodWork(i).sklprd <> 0;
/              setFldVal();
/              delete lic_key mfkylic;
/              if not prodWork(i).delete;
/                write sklrec;
/              endif;
/            endif;
/            if prodWork(i).skl#us > 0;
J6082          exsr crtUltFil;
J2163        endif;
/          endfor;
/          rrn1 = 1;
/          loadWrkArr();
/        ENDIF;

J2163    exsr loadSfl01;

       ENDSR;

       //*************************************************************************
       BEGSR CHECKKEY;

         // VALIDATE KEY CODE IF ENTERED.

         // HASH UP CLIENT INFO.

         // ENCRYPT THE KEY.
         MD5HASHA(pKey:%len(%trim(pKey)):PDATA:
             %LEN(%TRIM(PDATA)):TSTKCD);

         // CONVERT ENTERED KEY CODE TO HEX FOR BINARY VALUE COMPARISON TO GENERATED
         // KEY VALUE.
         if %check(hc:skmkcd_o) > 0;
           errors = '1';
         endif;
         IF NOT errors;
           CVTCH(%ADDR(SKMKCD):%ADDR(SKMKCD_O):32);
         ENDIF;

         // SEND ERROR MESSAGE IF KEY CODE DOES NOT PASS VALIDATION.
         IF TSTKCD <> SKMKCD OR errors;
           SPM('KY00052');
           *IN54 = '1';
           ERRORS = '1';
         ENDIF;

       ENDSR;

       //*************************************************************************
       BEGSR SELECTPROD;

         // SELECT AVAILABLE PRODUCTS.

         EXSR LOADSFL02;
         PRDSLT = '0';

         DOU *IN12 OR PRDSLT = '1';

/3469      WRITE FKYWDW02;
           EXFMT WDWCTL02;

           SELECT;
           WHEN *IN05;
             EXSR LOADSFL02;
           WHEN *IN12;
           when *in13;
             exsr repeatsr;
           when rrn2 > 0;
             exsr procsfl02;
           ENDSL;

         ENDDO;

       ENDSR;

       //*************************************************************************
       BEGSR LOADSFL02;

         // LOAD LIST OF AVAILABLE PRODUCTS.

         // RESET SUBFILE.
         RRN2 = 0;
         *IN25 = '0';
         *IN26 = '1';
         WRITE WDWCTL02;
         *IN26 = '0';
         option = ' ';

         SETLL *LOVAL MFKYPRD;
         DOU *IN68;

           READ MFKYPRD;
           *IN68 = %EOF;
           IF *IN68;
             ITER;
           ENDIF;

           // ONLY LOAD RECORDS CLIENT DOES NOT ALREADY HAVE.
J2163      if prodWork(skpprd).sklprd > 0 and not prodWork(skpprd).delete;
/            *in69 = '1';
             ITER;
           ENDIF;

           // LOAD PRODUCTS THAT FALL WITHIN THE RANGE OF THE CLIENT'S VERSION.
           IF SKMVER < SKPAVF OR SKMVER > SKPAVT;
             ITER;
           ENDIF;

           // GET PRODUCT DESCRIPTION.
           PRODNAME = RTVPRDNAM(SKPPRD);

           RRN2 = RRN2 + 1;
           WRITE WDWSFL02;

         ENDDO;

         maxrrn2 = rrn2;
         IF RRN2 > 0;
           *IN25 = '1';
         ENDIF;

       ENDSR;

       //*************************************************************************
       BEGSR PROCSFL02;

         // PROCESS SELECTED PRODUCTS FROM LIST.

         PRDSLT = '0';

         DOw 1=1;

           READC WDWSFL02;
           IF %eof;
             leave;
           ENDIF;

           IF OPTION = '1';
             SKLSID = SKMSID;
             SKLPRD = SKPPRD;
             SKL#US = 0;
             IF SKPUTL = 'Y';
J6082          SKL#US = *all'9';
             ENDIF;
             SKLDMO = GETDMODAT;
             // CALL 3RD PARTY KEY CODE GENERATION APPLICATION IF EXISTS.
/2840        IF SKPKCA <> ' ';
               skldmo = GetDmoDat;
J2166          ExtKeyApp(EXT_KEY_INT:skldmo:extDta);
/2840        ENDIF;
J2163        chain(e) sklprd mfkyprd;
             setWrkArrVal();
             PRDSLT = '1';
/2840      ENDIF;

         ENDDO;

         IF RRN1LOC > 0;
           RRN1 = RRN1LOC;
         ENDIF;

       ENDSR;

       //*************************************************************************
       BEGSR DSPLSTCHG;

         // DISPLAY LAST CHANGED INFORMATION.
         DOU *IN12;
           EXFMT WINDOW03;
         ENDDO;

       ENDSR;

       //*************************************************************************
       BEGSR RFSCTL01;

         // REFRESH WDWCTL01

         CHAIN SKMSID MFKYMST;
         *IN67 = NOT %FOUND;

         // COPYRIGHT MESSAGE.
         SPM('P001154');

J2163    loadWrkArr();
         EXSR LOADSFL01;

       ENDSR;

       //*************************************************************************
J6082  BEGSR crtUltFil;

J6082    // Create user license tracking files for each user based product.

J6082    // If tracking file does not exist, Create it.
J6082    chkobj('MFKYULT':skmLib:'*FILE':chkObjRtn);
J6082    //'0' = exist, '1'=Not exist
J6082    if chkObjRtn = '1';
J6082      exec sql CREATE TABLE :skmLib/MFKYULT (SKUPRD NUMERIC (3) NOT NULL
J6082        WITH DEFAULT, SKUIJI CHAR (16) NOT NULL WITH DEFAULT,
J6082        SKUHSH CHAR (16) NOT NULL WITH DEFAULT,
J6082        PRIMARY KEY (SKUPRD, SKUIJI));
J6082    endif;

J6082    // Error creating/replacing tracking file. MFKYULT
J6082    if sqlcod < 0;
J6082      SPM('KY00062');
J6082      leavesr;
J6082    endif;

J6082    // Clear the file and set the "zero" record with the current job's
J6082    // internal identifier and hash.
J6082    exec sql delete from mfkyult;

J6082    reset rjircv;
J6082    reset apier;
J6082    rji(rjircv:%size(rjircv):'JOBI0100':'*INT':'*':apier);

J6082    pdata = rjiiji;
J6082    MD5HASHA(pKey:%len(%trim(pKey)):PDATA:%LEN(%TRIM(PDATA)):ultHsh);

J6082    exec sql insert into mfkyult values(0:rjiiji:ultHsh);

       ENDSR;

       //*************************************************************************
       BEGSR REPEATSR;

         // REPEAT OPTION TO END OF SUBFILE LIST.

         changed = '0';
         SELECT;
         WHEN CURRCD = 'WDWCTL01';
           READC WDWSFL01;
           if not %eof;
             changed = '1';
             saveDemo = SKLDMO;
             save#us  = SKL#US;
             exsr subfile_atr;
             update wdwsfl01;
             STRCSR = RRN1LOC;
             ENDCSR = MAXRRN1;
           endif;
         WHEN CURRCD = 'WDWCTL02' and rrn2 > 0;
           READC WDWSFL02;
           if not %eof;
             changed = '1';
             STRCSR = RRN2LOC;
             ENDCSR = maxrrn2;
             update wdwsfl02;
           endif;
         ENDSL;

         SAVOPT = OPTION;

         if changed;

      /END-FREE
     C     STRCSR        DO        ENDCSR        X
      /FREE
             SELECT;
             WHEN CURRCD = 'WDWSFL01';
               CHAIN X WDWSFL01;
               *IN68 = NOT %FOUND;
               EXSR SUBFILE_ATR;
               select;
               when csrfld = 'OPTION';
                 OPTION = SAVOPT;
               when skputl = 'Y' and csrfld = 'SKL#US' and
                     skldmo = *all'9';
                 SKL#US = save#us;
               when csrfld = 'SKLDMO';
                 SKLDMO = saveDemo;
               endsl;
               UPDATE WDWSFL01;
             WHEN CURRCD = 'WDWSFL02';
               CHAIN X WDWSFL02;
               *IN68 = NOT %FOUND;
               OPTION = SAVOPT;
               UPDATE WDWSFL02;
             ENDSL;
           ENDDO;

           select;
           when currcd = 'WDWSFL01';
             rrn1 = rrn1loc;
           when currcd = 'WDWSFL02';
             rrn2 = rrn2loc;
           endsl;

         endif;

       ENDSR;

       //*************************************************************************
       BEGSR SUBFILE_ATR;

         // MAINTAIN STATUS OF DISPLAY ATTRIBUTES FOR PRODUCTS SUBFILE.

         // HIDE #USERS IF NOT USER BASED.
         *IN30 = '0';
         IF SKPUTL <> 'Y';
           *IN30 = '1';
         ENDIF;

         // Protect number of users if in demo mode or not user based.
         *in31 = '0';
         IF (SKPUTL = 'Y' and skldmo <> *all'9') or
               skputl = 'N';
           *in31 = '1';
         endif;

       ENDSR;
5647   //-----------------------------------------------------------
/      BegSr PrtLicSr;
/      //-----------------------------------------------------------
         if not %open(mfspykeyp);
J3754      if printFlag;
J3754        run('ovrprtf mfspykeyp splfname(keyinfo) outq(docinfo)');
J3754        skmsid = rsv('QSRLNBR');
J3754        chain skmsid mfkymst;
J3754        dlparGetInfo(%addr(qpmdif1):1:%size(qpmdif1));
J3754        skmlpr = QPMLNBR;
J3754        in sysdft;
J3754        cvthc(%addr(skmkcd_o):%addr(skmkcd):%size(skmkcd_o));
J3754      endif;
           open mfspykeyp;
J3754      if printFlag;
J3754        run('dltovr mfspykeyp');
J3754      endif;
J3754    endif;

         write header;

         Setll SkMSid MfKyLic;

         Reade(e) SkMSid MfKyLic;
         DoW NOT %EOF(MfKyLic);
           chain sklprd mfkyprd;
           PRODNAME = RTVPRDNAM(SKPPRD);
           write detail;
           startPos = 1;
           if skpkca <> ' ';
             ExtKeyApp(EXT_KEY_RTV:skldmo:extDta);
             dou prtExtDta = ' ';
               endPos = %scan(' ':extDta:startPos);
               prtExtDta = %subst(extDta:startPos:endPos-startPos);
               startPos = endPos + 1;
               if prtExtDta <> ' ';
                 write detailExt;
               endif;
             enddo;
           endif;
           Reade(e) SkMSid MfKyLic;
         EndDo;

/      EndSr;

      /END-FREE
     P GETDMODAT       B

      // RETURN THE CURRENT DATE PLUS ONE MONTH.

     D GETDMODAT       PI             8  0

     D DATEDS          DS
     D  DATE                          8S 0
     D WRKDATE         S               D   DATFMT(*ISO)
     D EIGHTDEC        S              8  0

      /FREE
       DATEDS = GETDTTM;
      /END-FREE
     C                   MOVE      DATE          WRKDATE
     C                   ADDDUR    1:*M          WRKDATE
     C                   MOVE      WRKDATE       EIGHTDEC

      /FREE
       RETURN EIGHTDEC;

      /END-FREE
     P                 E

      //*************************************************************************
     P GETDTTM         B

     D GETDTTM         PI            17

     D LDTLIL          S             10I 0
     D LDTSEC          S              8
     D LDTGRG          S             17

      // GET LOCAL DATE AND TIME.
     C                   CALLB     'CEELOCT'
     C                   PARM                    LDTLIL
     C                   PARM                    LDTSEC
     C                   PARM                    LDTGRG

      /FREE
       RETURN LDTGRG;
      /END-FREE
     P                 E

      //*************************************************************************
     P RTVPRDNAM       B

      // RETRIEVE PRODUCT NAME FROM SPYCTL.
     D RTVPRDNAM       PI            25
     D  PRODUCT#                      3  0
     D PSCON           C                   CONST('PSCON     *LIBL     ')

     D APIRTNDS        DS
     D  RTNDTA                       24
     D  RTNVAL                       26    INZ

     D LENRPLC         S             10I 0
     D LENMSGINF       S             10I 0

     C     PRDNAMKLST    KLIST
     C                   KFLD                    CNAME
     C                   KFLD                    CTYPE
     C                   KFLD                    CKEY
      /FREE
       CNAME = 'PRODNAME';
       CTYPE = 'RC';
       CTYPE = 'RC';
      /END-FREE
     C                   MOVEL(P)  PRODUCT#      CKEY

      /FREE
       CHAIN PRDNAMKLST SPYCTL;
       *IN68 = NOT %FOUND;
       IF *IN68 = '0';
      /END-FREE
     C                   CALL      'QMHRTVM'
     C                   PARM                    APIRTNDS
     C                   PARM      50            LENMSGINF
     C                   PARM      'RTVM0100'    APIFMT            8
     C                   PARM                    CMSGID
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM      ' '           MSGTXT            1
     C                   PARM      0             LENRPLC
     C                   PARM      '*NO'         RPLCSUB          10
     C                   PARM      '*NO'         RTNFMTCTL        10
     C                   PARM                    APIERR
      /FREE
       ENDIF;

       RETURN RTNVAL;

      /END-FREE
     P                 E

      //*************************************************************************
     P SPM             B

      // SEND PROGRAM MESSAGE

     D SPM             PI
     D  MSGID                         7    VALUE

     D PSCON           S             20    INZ('PSCON     *LIBL')
     D MSGDTALEN       S             10I 0 INZ(0)

     C                   CALL      'QMHSNDPM'
     C                   PARM                    MSGID
     C                   PARM                    PSCON
     C                   PARM      ' '           MSGDTA            1
     C                   PARM                    MSGDTALEN
     C                   PARM      '*INFO'       MSGTYPE
     C                   PARM      '*'           STACK
     C                   PARM      1             STACKCNT
     C                   PARM      ' '           MSGKEY
     C                   PARM                    APIERR

      /FREE
       RETURN;

      /END-FREE
     P                 E
      //*************************************************************************

      // RETURN PROCESSOR FEATURE CODE.

     P PRCFTR          B

     D PRCFTR          PI             4

     D                 DS
     D RHRI_RCV                      55
     D  RHRI_PFC                      4    OVERLAY(RHRI_RCV:52)
     D RHRI_RCVLEN     S             10I 0 INZ(%SIZE(RHRI_RCV))

     C                   CALL      'QGYRHRI'                            90
     C                   PARM                    RHRI_RCV
     C                   PARM                    RHRI_RCVLEN
     C                   PARM      'RHRI0400'    RHRI_FMT          8
     C                   PARM      'CEC01'       RHRI_RSC         10
     C                   PARM                    APIERR

      /FREE
       IF *IN90 OR ERBYTAVL > 0;
         RETURN '    ';
       ELSE;
         RETURN RHRI_PFC;
       ENDIF;

      /END-FREE
     P                 E

      * Load the the work array used for validation.
J2163P loadWrkArr      b
      /free
       reset prodWork;
       setll skmsid mfkylic;
       reade skmsid mfkylic;
       dow not %eof;
         chain(e) sklprd mfkyprd;
         setWrkArrVal();
         reade skmsid mfkylic;
       enddo;
       return;
      /end-free
     P                 e

      * Set work array values.
J2163P setWrkArrVal    b
      /free
       reset prodWork(sklprd);
       prodWork(sklprd).sklprd = sklprd;
       prodWork(sklprd).skputl = skputl;
       prodWork(sklprd).skpkca = skpkca;
       prodWork(sklprd).skl#us = skl#us;
       prodWork(sklprd).prodName = rtvprdnam(sklprd);
       prodWork(sklprd).skldmo = skldmo;
       return;
      /end-free
     P                 e

      * Set field values from work array.
J2163p setFldVal       b
      /free
       sklprd = prodWork(i).sklprd;
       skputl = prodWork(i).skputl;
       prodName = prodWork(i).prodName;
       skl#us = prodWork(i).skl#us;
       skldmo = prodWork(i).skldmo;
       skpkca = prodWork(i).skpkca;
       return;
      /end-free
     p                 e

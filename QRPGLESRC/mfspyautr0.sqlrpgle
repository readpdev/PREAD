      *%METADATA                                                       *
      * %TEXT Product Authorization Function.                          *
      *%EMETADATA                                                      *
     HNOMAIN
      //
      // PRODUCT AUTHORIZATION FUNCTION.

      // ACCEPTS 5 PARMS: 1) PRODUCT CODE. SEE FILE MFKYPRD.
      //                  2) AUTHORIZATION INDICATOR. '0'=FAIL, '1'=SUCCESS.
      //                  3) MESSAGE ID. RETURNS BLANK IF NO WARNINGS OR ERRORS.
      //                  4) MESSAGE DATA.
      //                  5) USER BASED LICENSE TRACKING INDICATOR.
      //                     0 OR *NOPASS = CHECK USER LICENSE.
      //                                1 = REMOVE FROM TRACKING.
      //                                2 = CHECK FOR AUTHORIZATION ONLY.
J6082 // 01-28-15 PLR Extend the number of licensed users to 999,999 from 999.
      //              This required a change to the license tracking objects from
      //              a user space to a file. Converted to free format and added
      //              SQL;
J1299 // 07-23-09 PLR Add program library to the hash.
T6896 // 05-02-08 PLR Add LPAR checking.
T5726 // 09-25-06 PLR Remove system id, model and feature code from
/     //              preamble level of hash. Add these values in at
/     //              the license product portion of the hash if
/     //              permanently licensed product. This allows production
/     //              and support the ability to give out limited
/     //              software evaluations without having to know system
/     //              information. Use new private key for encryption.
/9464 // 03-01-05 PLR Expiration warning message formatted incorrectly.
/8130 // 03-31-04 GT  Changes to attempt to fix intermittent auth failures:
/     //              Correct QUSRJOBI prototype:
/     //              -Remove CONST from I/O fields
/     //              -Add *VARSIZE to error code field
/     //              Replace call to CEELOCT with TIME opcode
/     //              Remove extra calls to lock_us and unlock_us around RMVUSRLIC
/8474 // 07-16-03 PLR Plug memory leak.
/8130 // 06-23-03 PLR Incorrect message displayed for lock error. Was indicating
      //              user space corruption. Add routine to retrieve lock list.
      //              Removed *PSSR.
/7709 // 03-30-03 GT  Changed to call function MD5HashAsc2
      // 01-25-01 PLR CHANGED TO RETRIEVE PROCESSOR FEATURE CODE FROM HARDWARE
      //              RESOURCE INSTEAD OF SYSTEM VALUE.
      // 08-29-00 PLR CREATED. SEE MAG203 FOR EXAMPLE.
      //

     FMFKYMST   IF   E           K DISK    USROPN
     FMFKYLIC   IF   E           K DISK    USROPN
     FSPYCTL    IF   E           K DISK    USROPN

J6082*/copy @mgusridx
T6896 /copy qsysinc/qrpglesrc,qpmlpmgt

J6082d system          pr            10i 0 extproc('system')
J6082d  cmd                            *   value options(*string)

T6896d dlparGetInfo    pr            10i 0 extproc('dlpar_get_info')
     d  receiver                       *   value
     d  dataFormat                   10i 0 value
     d  receiverLen                  10i 0 value

     d rtvlckmsg       pr
     d  ultspace                     20    const
     d  msgdata                     100

     D ULINF           DS
     D  ULARO                  9      9

     D APIER           DS
     D  ERBYTPRV                     10I 0 INZ(%SIZE(APIER))
     D  ERBYTAVL                     10I 0
     D  ERMSGID                       7A
     D  ERRSV1                        1A
     D  ERMSGDATA                    80A

     D                SDS
     D EXCP_NUM               43     46

      // PRODUCT AUTHORIZATION PROTOTYPE.
     D MFSPYAUTR       PR
     D  AR_PROD                       3  0 VALUE
     D  AR_IND                        1
     D  AR_MSGID                      7
     D  AR_MDTA                     100
     D  AR_TRACK                      1    VALUE OPTIONS(*NOPASS)

      // GET PRODUCT DESCRIPTION PROTOTYPE.
     D GETPRDDSC       PR            25
     D  AR_PROD                       3  0 VALUE

      // SYSTEM DEFAULT DATA AREA. GET WARNING MESSAGE SUPPRESSION INDICATOR.
     D SYSDFT          DS          1024    DTAARA
J1299D  pgmLib               296    305
     D  SUPWRN               845    845

      // ALLOCATE DEALLOCATE USER SPACE OBJEDT LOCK COMMAND STRINGS.
     D ALCDLC          S             80    DIM(2) CTDATA

      // RETURN PROCESSOR FEATURE CODE.
     D PRCFTR          PR             4

J6082d licRcvr         ds                  qualified dim(1000)
J6082d  jobid                        16
J6082d  hash                         16

J6082d entriesRtn      s             10i 0

J6082d ndxSrchCrit     ds                  qualified
     d  jobID                          *
     d  len                          10i 0 inz(%size(lic.key))

J6082d errInd          s               n

     P MFSPYAUTR       B                   EXPORT

      // PRODUCT AUTHORIZATION PROTOTYPE INTERFACE.
     D MFSPYAUTR       PI
     D  AR_PROD                       3  0 VALUE
     D  AR_IND                        1
     D  AR_MSGID                      7
     D  AR_MDTA                     100
     D  AR_TRACK                      1    VALUE OPTIONS(*NOPASS)

      // RETURN SYSTEM VALUES PROTOTYPE.
     D RSV             PR            10    EXTPROC('MGRTVSVLR')
     D  SYSVAL                       10    VALUE

      // MD5 HASHING ALGORITHM PROTOTYPE.
     D MD5HASHA        PR                  EXTPROC('MD5HashAsc2')
     D  PKEY                      32767A   OPTIONS(*VARSIZE)
     D  IKEYLEN                      10I 0 VALUE
     D  PDATA                     32767A   OPTIONS(*VARSIZE) CONST
     D  IDATALEN                     10I 0 VALUE
     D  DIGEST                       16A
     D PDATA           S          32767A

     D PSCON           C                   'PSCON     *LIBL'

      // RETRIEVE JOB INFORMATION PROTOTYPE.
     D RJI             PR                  EXTPGM('QUSRJOBI')
/8130D  RJIRCV                       61
     D  RJIRLEN                      10I 0 CONST
     D  RJIFMT                        8    CONST
     D  RJIQJOB                      26    CONST
     D  RJIJID                       16    CONST
/8130D  RJIERR                      116    OPTIONS(*VARSIZE:*NOPASS)
     D                 DS
     D RJIRCV                        61
     D  RJIIJI                       16    OVERLAY(RJIRCV:35)
     D  RJISTS                       10    OVERLAY(RJIRCV:51)
     D CURIJI          S             16

      // USER LICENSE TRACKING.
     D                 DS
J6082D ULTIDX                        20    INZ('MFULTXXXU *LIBL')
J6082D  ULTNAM                        9    OVERLAY(ULTIDX)
J6082D  ULTPRD#                       3    OVERLAY(ULTIDX:6)
     D CURHSH          S             16
     D TSTHSH          S             16

     D X               S             10I 0
     D Y               S             10I 0
     D EXPDATE         S               D   DATFMT(*ISO)
     D TODAY           S               D   DATFMT(*ISO)
     D                 DS
     D DAYSTOEXP                      4S 0
     D  DTE_C                         2    OVERLAY(DAYSTOEXP:3)
     D EXPIRED         S                   LIKE(*IN) INZ('0')
     D WARNING         S                   LIKE(*IN) INZ('0')
     D TSTKCD          S                   LIKE(SKMKCD)
     D POS             S             10I 0
     D NULL16          S             16    INZ(*ALLX'00')
     D JOBID           S             16    BASED(JOBID_PTR)
     D ACTIVE          S             10I 0
     D ACCOUNTEDFOR    S                   LIKE(*IN)
     D VACANCY@        S             10I 0
     D USERBASED       S              1    INZ('0')
     D CUR#US          S                   LIKE(SKL#US)
/8474d usP             s               *
T5726d pKey            s             50    inz('GaussVistaPlusInIrvineCA')
T6896d lparNbr         s              3s 0

      * KEY FOR MFKYLIC
     C     SKLKEY        KLIST
     C                   KFLD                    SKMSID
     C                   KFLD                    AR_PROD

      /FREE
J1299  IN SYSDFT;
       AR_IND = '1';
       AR_MSGID = ' ';
       AR_MDTA = ' ';

       AR_IND = '1';

       // Retrieve system serial number.
       SKMSID = RSV('QSRLNBR');

       // Read key code master to get current software version.
       OPEN MFKYMST;
       CHAIN SKMSID MFKYMST;
       *IN68 = NOT %FOUND;
       CLOSE MFKYMST;

       // Retrieve current logical partition number.
T6896  lparNbr = 0;
/      if dlparGetInfo(%addr(qpmdif1):1:%size(qpmdif1)) > 0;
/        lparNbr = QPMLNBR;
/      endif;

       // Check product level authorization and demo expiration.
       OPEN MFKYLIC;
       CLEAR SKLREC;
       CHAIN SKLKEY MFKYLIC;
       IF not %found;
         AR_MSGID = 'KY00058';
         AR_MDTA = GETPRDDSC(AR_PROD);
         AR_IND = '0';
       ELSE;
         USERBASED = '0';
         IF SKL#US > 0;
           CUR#US = SKL#US;
           USERBASED = '1';
         ENDIF;
       ENDIF;
       CLOSE MFKYLIC;

      // PRODUCT LEVEL DEMO DATE VALIDATION
       IF AR_IND = '1' AND SKLDMO <> *ALL'9';
         EXSR CHKEXP;
       ENDIF;

       IF USERBASED = '1' AND
             %PARMS = 5 AND AR_TRACK = '1';
         EXSR RMVUSRLIC;
       ELSE;
         IF AR_IND = '1';
           EXSR VALIDATE;
         ENDIF;
       ENDIF;

       RETURN;

      //*********************************************************************************************
       BEGSR VALIDATE;

         // VALIDATE PRODUCT EXPIRATION AND USER LICENSES.

         // RETRIEVE REMAINING SYSTEM VALUES.
         SKMMDL = RSV('QMODEL');
         SKMFTR = PRCFTR;

         // HASH UP CLIENT INFO.
T5726    PDATA =  '400' + %TRIML(%EDITC(SKMVER:'3'));

         // HASH UP LICENSED PRODUCTS.
         OPEN MFKYLIC;
         SETLL SKMSID MFKYLIC;
         DOW 1 = 1;
           READE SKMSID MFKYLIC;
           if %EOF;
             LEAVE;
           endif;
           PDATA = %TRIMR(PDATA) +
               %TRIML(%EDITC(SKLPRD:'3')) +
               %TRIML(%EDITC(SKL#US:'3')) +
               %TRIML(%EDITC(SKLDMO:'3'));
T5726      if skldmo = *all'9';
/            pdata = %trimr(pdata) + %trim(skmsid) +
/                %trim(skmmdl) + %trim(skmftr) +
T1299            %trim(%editc(lparNbr:'Z') + %trimr(pgmlib));
T5726      endif;
         ENDDO;
         CLOSE MFKYLIC;

         // ENCRYPT THE KEY.
T5726    MD5HASHA(pKey:%len(%trim(pKey)):PDATA:%LEN(%TRIM(PDATA)):TSTKCD);

         // COMPARE GENERATED AND CURRENT KEY CODES. IF DIFFERENT SOMETHING HAS CHANGED.
         IF TSTKCD <> SKMKCD;
           AR_MSGID = 'KY00054';
           AR_MDTA = GETPRDDSC(AR_PROD);
           AR_IND = '0';
         ENDIF;

         // CHECK USER TYPE LICENSE.
         IF AR_IND = '1' AND USERBASED = '1' AND
           (%PARMS = 5 AND AR_TRACK = '1' OR %PARMS = 4);

/8130      exsr lock_us;
/          if ar_ind = '1';
             EXSR CHKUSRLIC;
/8130      endif;
/          exsr unlock_us;
         ENDIF;

       ENDSR;

      //*************************************************************************
       BEGSR CHKUSRLIC;

         // User license checking.

         // Read through the user index for the product.

         clear uiError;
         uiError.bytesProvided = %size(uiError);
         if rtvUI(%addr(licRcvr):%size(licRcvr):%addr(entriesRtn):ultidx:
           %elem(licRcvr.rtn):UI_SEARCH_FIRST:*null:*null) <> 0;
           getLastUIError(%addr(uiError));
         endif;

         active = 0;
         errInd = *off;

         dow entriesRtn > 0;

           for x = 1 to entriesRtn;

             reset rjircv;
             rji(rjircv:%size(rjircv):'JOBI0100':'*INT':
               licRcvr.rtn(x).iji:apier);
             if rjists = '*ACTIVE';
               active += 1;
             else; // Remove inactive jobs from index.

             endif;

             // If active job count > max #users, leave. Not authorized.
             if active > cur#us;
               AR_IND = '0';
               leave;
             endif;

             // Validate the job hash.
             pdata = licRcvr.rtn(x).iji;
             MD5HASHA(pKey:%len(%trim(pKey)):pdata:%len(%trim(pdata)):tsthsh);
             if tsthsh <> licRcvr.rtn(x).hash;
               leave;
             endif;



           endfor;

           if rtvUI(%addr(licRcvr):%size(licRcvr):%addr(entriesRtn):ultidx:
             %elem(licRcvr.rtn):UI_SEARCH_FIRST:
             %str(ndxOrder(sortOrder).field(1)):
             ndxOrder(sortOrder).len(1)) <> 0;
             getLastUIError(%addr(uiError));
           endif;

         CURHSH = PDATA;
         MD5HASHA(pKey:%LEN(%TRIM(pKey)):%SUBST(PDATA:17:CUR#US*16):
           CUR#US*16:TSTHSH);

         // ERROR IF HASH ON JOB ENTRIES DO NOT MATCH STORED HASH VALUE.
         IF TSTHSH <> CURHSH;
           AR_IND = '0';
           AR_MSGID = 'KY00068';
           AR_MDTA = GETPRDDSC(AR_PROD);
         ENDIF;

         // DETERMINE IF CURRENT JOB ALREADY ACCOUNTED FOR AND REMOVE ANY JOBS NOT ACTIVE.
         IF AR_IND = '1';

           ACCOUNTEDFOR = '0';
           ACTIVE = 0;
/8474      JOBID_PTR = usP;

           for x = 1 to cur#us;
             JOBID_PTR = JOBID_PTR + 16;
             IF CURIJI = JOBID;
               ACCOUNTEDFOR = '1';
               ITER;
             ENDIF;
             RESET RJIRCV;
             RJI(RJIRCV:%SIZE(RJIRCV):'JOBI0100':'*INT':JOBID:APIER);
             IF RJISTS = '*ACTIVE';
               ACTIVE = ACTIVE + 1;
             ELSE;
               JOBID = NULL16;
               VACANCY@ = X * 16 + 1;
             ENDIF;
           ENDfor;

           // IF MAX LICENSES NOT EXCEEDED ADD CURRENT JOB TO USER SPACE AND REHASH.
           IF ACTIVE < CUR#US AND ACCOUNTEDFOR = '0';
             %SUBST(PDATA:VACANCY@:16) = CURIJI;
             MD5HASHA(pKey:%LEN(%TRIM(pKey)):
                 %SUBST(PDATA:17:CUR#US*16):CUR#US*16:CURHSH);

             %subst(pdata:1:%size(curhsh)) = curhsh;
           ENDIF;

           // FORMAT USER LICENSE EXCEEDED MESSAGE
           IF ACTIVE >= CUR#US;
             AR_MSGID = 'KY00059';
             AR_MDTA = GETPRDDSC(AR_PROD);
             AR_IND = '0';
           ENDIF;

           // IF AR_IND = '1'
         ENDIF;

       ENDSR;

      //*************************************************************************
       BEGSR LOCK_US;

         // RETRIEVE CURRENT JOB INTERNAL IDENTIFIER.
         RJI(RJIRCV:%SIZE(RJIRCV):'JOBI0100':'*':' ');
         CURIJI = RJIIJI;

         // SERIALIZE ACCESS TO USER SPACE. MAX WAIT 60 SECONDS.
         ultprd# = %editc(ar_prod:'X');
         %SUBST(ALCDLC(1):24:3) = ULTPRD#;
         if system(alcdlc(1)) <> 0;
           AR_MDTA = ULTNAM;
           // TIME OUT ON LOCK.
           IF EXCP_NUM = '1002';
             ar_msgid = 'KY00066';
/8130        rtvlckmsg(ultspc:ar_mdta);
           ENDIF;
           // USER SPACE MISSING ELSE GET POINTER TO USER SPACE.
           IF EXCP_NUM = '1085';
             AR_MSGID = 'KY00067';
           ENDIF;
           AR_IND = '0';
         ELSE;
/8474      rtvusrspc(ultnam:'*LIBL':1:17+cur#us*16:
/              pdata);
/          usP = %addr(pdata);
         ENDIF;

       ENDSR;

       //*************************************************************************
       BEGSR UNLOCK_US;

         // update user space
/8474    chgusrspc(ultnam:'*LIBL':1:17+cur#us*16:
/            pdata);

         // DEALLOCATE LOCK ON USER SPACE.
         %SUBST(ALCDLC(2):24:3) = ULTPRD#;
         system(alcdlc(2));
       ENDSR;

       //*************************************************************************
       BEGSR RMVUSRLIC;

         // REMOVE USER LICENSE ENTRY FROM LICENSE TRACKING USER SPACE.
         EXSR LOCK_US;

         IF AR_IND = '1';
/8474      JOBID_PTR = usP;
           for x = 1 to cur#us;
             JOBID_PTR = JOBID_PTR + 16;
             IF JOBID = CURIJI;
               JOBID = NULL16;
               LEAVE;
             ENDIF;
           ENDfor;
           MD5HASHA(pKey:%LEN(%TRIM(pKey)):
               %SUBST(PDATA:17:CUR#US*16):CUR#US*16:CURHSH);
           %subst(pdata:1:%size(curhsh)) = curhsh;
         ENDIF;

         EXSR UNLOCK_US;

       ENDSR;

       //*************************************************************************
       BEGSR CHKEXP;

         // CHECK FOR DEMO EXPIRATION.

         EXPIRED = '0';
         WARNING = '0';

/8130    // GET SYSTEM DATE.
         today = %time();
         expdate = skldmo;

         // CALCULATE DAYS TO EXPIRATION.
         expdate = today - %days(daystoexp);

         // EXPIRED DEMO.
         SELECT;
         WHEN EXPDATE <= TODAY;
           EXPIRED = '1';
           AR_MSGID = 'KY00056';
           AR_MDTA = GETPRDDSC(AR_PROD);
           AR_IND = '0';
           // EXPIRE WARNING.
         WHEN DAYSTOEXP < 15;
           IF SUPWRN <> 'Y';
             WARNING = '1';
             AR_MSGID = 'KY00057';
/9464        ar_mdta = dte_c +
/                %trimr(getprddsc(ar_prod));
           ENDIF;
         ENDSL;

       ENDSR;
      /end-free
     P                 E

      //*************************************************************************

      // RETURN PRODUCT DESCRIPTION.

     P GETPRDDSC       B

     D GETPRDDSC       PI            25
     D  AR_PROD                       3  0 VALUE

     D APIRTNDS        DS
     D  RTNDTA                       24
     D  RTNVAL                       26    INZ

      // API ERROR DATA STRUCTURE.
     D PSCON           C                   'PSCON     *LIBL'
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
       ckey = %editc(ar_prod:'X');

       OPEN SPYCTL;
       CHAIN PRDNAMKLST SPYCTL;
       IF not %found;
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
     C                   PARM                    APIER
      /FREE
       ENDIF;
       CLOSE SPYCTL;

       RETURN RTNVAL;

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
     C                   PARM                    APIER

      /FREE
       IF *IN90 OR ERBYTAVL > 0;
         RETURN '    ';
       ELSE;
         RETURN RHRI_PFC;
       ENDIF;

      /END-FREE
     P                 E

      //*************************************************************************
/8130p rtvlckmsg       b

     d                 pi
     d ultspc                        20    const
     d mdta                         100

     d listObjectLocks...
     d                 pr                  extpgm('QWCLOBJL')
     d  userspace                    20    const
     d  format                        8    const
     d  object                       20    const
     d  objecttype                   10    const
     d  member                       10    const
     d  apierror                           like(apier)

     d offsetDS        ds
     d  offset                       10i 0
     d  listsize                     10i 0
     d  listentries                  10i 0

     d jobinfo         ds
     d  jobname                      10
     d  jobuser                      10
     d  jobnumber                     6

      /FREE
       crtusrspc('ULTLCK':'QTEMP':1024);

       listObjectLocks('ULTLCK    QTEMP':'OBJL0100':
           ultspc:'*USRSPC':'*NONE':apier);

       if erbytavl = 0;
         rtvusrspc('ULTLCK':'QTEMP':125:
             %size(offsetDS):offsetDS);
         if listentries > 0;
           rtvusrspc('ULTLCK':'QTEMP':offset+1:
               %size(jobinfo):jobinfo);
           mdta = %subst(ultspc:1:9) + ' ' +
               jobnumber + '/' + %trimr(jobuser) + '/' +
               jobname;
         endif;
       endif;

       dltusrspc('ULTLCK':'QTEMP');

       return;

      /END-FREE
     p                 e

**CTDATA ALCDLC
ALCOBJ OBJ((*LIBL/MFULTXXXU *USRSPC *EXCL)) WAIT(60)
DLCOBJ OBJ((*LIBL/MFULTXXXU *USRSPC *EXCL))

     h dftactgrp(*no) bnddir('SPYBNDDIR') actgrp('DOCMGR')
     h option(*nodebugio)
      *********---------------------------------------
      * CHGRPT  Change Report Master Records (RMAINT)
      *********---------------------------------------
      *
     FCHGRPTFM  CF   E             WORKSTN INFDS(INFDS)
     FRMAINT    UF   E           K DISK    INFDS(FILEDS)
     FRMAINT5   IF   E           K DISK    RENAME(RMNTRC:RMNTR5)
     FMOPTVCT   IF   E           K DISK
     FSPYCTL    IF   E           K DISK
/1509FADSECLNK1 IF   E           K DISK    UsrOpn
/1509FRSECUR    IF   E           K Disk    UsrOpn
J3175Fmftsmmc   uf a e           k disk
     F
      *
J6624 * 08-24-16 PLR Add a default print-to-output-file library. When specified,
      *              a user will only be able to output a document to a file in
      *             that library. This function is accessed from the green screen
      *             report viewer using option 2 of the 'P'rint menu.
J5883 * 03-17-15 EPG Retained changed DocLink description value.
J2834 * 02-21-13 EPG Automatically set on limit doclink scrolling if DocLink
/     *              security is set on.
J4158 * 07-25-12 PLR Add audit logging flag to indicate whether or not logging
      *              should occur for the document class or not. Log changes
      *              to any of the security flags: Enable Security,
      *              Enable Audit Logging, Limit Scrolling, DocLink Security.
J3724 * 10-07-11 PLR Avoid update without chain errors in joblog.
J3175 * 12-03-10 PLR Add TSM management class to maintenance screen.
/1509 * 11-23-09 EPG Change the check for the *PUBLIC group to *PUBLIC
/     *              User.
/2195 * 11-4-09  EPG Recover from the following message gracefully.
      *              Update or delete in file RMAINT without prior input operation
/1964 * 08-11-09 EPG Validate the Data Stream Type field against the
/     *              valid values. Prompt enable this field, and
/     *              include updated help.
/1509 * 07-16-09 EPG Validate a request for DocLink security against the
/     *              need to have DocLink Scrolling on.
/1509 * 05-29-09 EPG Maintain a new field in RMAINT for doclink security and
      *              generate an informational message should *PUBLIC not be
      *              defined as a user group.
T4890 * 08-10-06 EPG In app security, a user can bypass report
      *              security if they are allowed to config. If a user
      *              has the authority to configure a report, but
      *              does not have the authority to grant/revoke authority
      *              to the folder, then the prompt for edit security
      *              should be set to read only.
T5079 * 02-02-06 PLR The 'Delete After Generations' field was being input
/     *              inhibited by the lock status field being zero when configured
/     *              through docspl.
/8051 * 08-24-04 PLR Performing a 2 Change after an 7 Configure has incorrect
/     *              display.
/5324 *  8-29-01 KAC FIX "DJDE AFTER FIELD"
/5647 * 10-17-01 PLR Prevent annotations as revisions flag from being turned on
/     *              if rev ctl not allowed. Sv_NotAllowed  or Sv_PrvAllowed.
/4815 * 07-13-01 PLR Add message indicating rev ctl and more keys incompatible.
/4530 * 06-13-01 KAC Allow Rev Ctrl to turned off if no rev control docs exist
/3765 * 04-04-01 DLS For Report types that are on DMS do not allow
/3765 *              entry into the "Delete After" fields as these
/3765 *              are now n/a.  No deletes will occur for DMS images
/3765 * 03-14-01 DLS Only allow RTypID to go on DMS if old notes
/3765 *              have been converted to new notes.
/3765 * 02-21-01 JAM Document management system changes.
/3765 *              (Converted from RPG to ILE/RPG.)
      * 10-26-98 JJF If no RTypId, assign one, offering RNAM as default
      *  7-17-98 JJF Modify to handle parm ACTION = 6 (Add)
      *  6-29-96 JJF Remove RCDLEN comparison (RMaint expanded)
      *  6-04-98 GT  Don't validate fax CPI and LPI values if
      *              fax type is FaxServer/401.
      *  5-26-98 JJF Call GETNUM to assign report type
      *  1-08-98 GT  Corrected fax CPI field prompt indicator
      *  2-21-97 GK  Add Printer File/Libr & reformatted screen
      *              & add more F4 field prompts.
      * 12-06-96 GK  Add Personal Help.
      *  6-18-96 PAF Process F13=Print Configuration report list.
      *  8-24-95 GT  Change ERR array entries to message IDs
      *  6-15-95 JJF Call MAG901 for transaction log.
      * 11-07-94 DM  Add field check for Print Cover Page and Id
      *  6-14-94 ed  edit checked report type, fixed wrksec call
      *              To blank rtncde 1st (looped on f12)
      *  4-25-94     Add Multivolume support id to screen
      *  4-26-94 ed  removed edit check for queue, printer etc.
      * 12-02-93 Ed  Close security window. Remove rtncde from *INZSR
      *  3-30-93     edit check outputq
      *
      * Prototypes ------------------------------------------------------
/1964dGetCsrPos        pr
/    d pWdw                           5u 0 const
/    d pScr                           5u 0 const
/    d pRow                           3s 0
/    d pCol                           3s 0

J6624  dcl-pr mag1030 extpgm('MAG1030');
J6624   rtnIO char(1);
J6624   library char(10) const;
J6624   object char(10) const;
J6624   objectType char(10) const;
J6624   commandStmt char(255) const;
J6624  end-pr;
J6624  dcl-s mag1030rtn char(1);

J6624  dcl-pr spyChkObj extpgm('SPYCHKOBJ');
J6624   object char(10) const;
J6624   objLib char(10) const;
J6624   objTyp char(10) const;
J6624   rtnFlg char(1);
J6624  end-pr;
J6624  dcl-s spyChkFlg char(1);

/1964dLstDSTyp         pr                  ExtPgm('LSTDSTYP')
/    d pDataStream                    3a
T4890dGetSecurity      pr                  ExtPgm('MAG1060')
T4890d pCalPgm                       10    const
T4890d pPgmOff                        1    const
T4890d pCkType                        1    const
T4890d pObjTyp                        1    const
T4890d pObjNam                       10    const
T4890d pObjLib                       10
T4890d pRptNam                       10
T4890d pJobNam                       10
T4890d pPgmNam                       10
T4890d pUsrNam                       10
T4890d pUsrDta                       10
T4890d pReqOpt                        2  0
T4890d pReturn                        1
T4890d pAut                           1    dim(25) options(*nopass)
T4890d pAutE                         40    options(*nopass)
T4890d pSecOv                        10    options(*nopass)


      * Constants --------------------------------------------------
J5883d ACTION_CHGDESC  c                   '7'
/1964d DTASTRMAX       c                   7
/     * Maximum number of valid data stream values
/1509 * Designations for DocLink Security
/    d DSGN_USRPRF     c                   'U'
/     * User Profile Types  ( Defined within the OS )
/    d DSGN_GRPPRF     c                   'G'
/     *  Group Profile Type ( Defined within the OS )
/    d DSGN_AUTLST     c                   'A'
/     *  Authorization List ( Defined within the OS )
/    d DSGN_SUBLST     c                   'S'
/     *  Subscription  List ( Defined within the OS )
/    d GRP_PUBLIC      c                   '*PUBLIC'
/    d USR_PUBLIC      c                   '*PUBLIC'
/    d TRUE            c                   '1'
/    d FALSE           c                   '0'
     d CONFIGURE       c                   8
     d SECURITY        c                   13
T4890d YES             c                   'Y'
T4890d NO              c                   'N'
     D ACT             S             10    DIM(7)                               Action text
     D ERR             S              7    DIM(12) CTDATA PERRCD(1)
     D MSG             S              7    DIM(1) CTDATA PERRCD(1)
/1964d linNbr          s              3s 0
/    d PosNbr          s              3s 0
/    d d2Row           s              3s 0
/    d d2Col           s              3s 0

     D NULL            C                   CONST(X'00')
     d/COPY @FKEYS

J4158 /copy @mlaudlog
J4158d LogDS           ds                  inz
J4158 /copy @mlaudinp

J4158d secSettings     ds                  qualified
J4158d  len                           5i 0
J4158d  value                       256
J4158d secFlagsChg     ds                  qualified
J4158d  enableSec                      n   inz(*off)
J4158d  enableAud                      n   inz(*off)
J4158d  enableLmt                      n   inz(*off)
J4158d  enableLnk                      n   inz(*off)

/3765 * -----------------------------
/3765 * Document Management variables
/3765 * -----------------------------
J5883d strNewDesc      s             40a
J5883d blnChangeDesc   s               n   inz( FALSE )
T4890d intReqOpt       s              2  0 inz(7)
T4890d aRName          s             10    inz(*blanks)
T4890d aJName          s             10    inz(*blanks)
T4890d aPName          s             10    inz(*blanks)
T4890d aUName          s             10    inz(*blanks)
T4890d aUData          s             10    inz(*blanks)
T4890d AutRtn          s              1a
T4890d aAut            s              1a   dim(25)


/3765D DMSKey          S              5  0 dim(5)
/3765D DMSKeyLookup    S              5  0
/3765D DMSTxt          S              5    dim(%elem(DMSKey))
/3765D DMSDfn          S             60    dim(%elem(DMSKey))
/3765D DMSCnt          S              3  0 inz(%elem(DMSKey))
/3765D DMSIdx          S                   like(DMSCnt)
/3765D DMSDfnLoaded    S              1
/3765D DMSInstall      S              1
/3765D DMSok           S              1N
/3765D OffDMSNotAllowed...
/3765D                 S              1N
/3765D RC              S             10i 0
/3765 * --------------------------------
/3765 * PRODUCT AUTHORIZATION PROTOTYPE.
/3765 * --------------------------------
/3765 /COPY @MFSPYAUTR
/3765 * --------------------------------
/3765 * NOTES Data Base PROTOTYPE.
/3765 * --------------------------------
/3765 /COPY @MMCSNOTER
/3765 * --------------------------------
/3765 * Common definitions
/3765 * --------------------------------
/3765 /COPY @MMdmssrvR

     D FILEDS          DS
      *              File error status
     D  RCDLEN               125    126B 0
     D  STS              *STATUS

     D INFDS           DS
      *              Screen info
     D  KEY                  369    369
/1964d  SCR                  370    371i 0
/     * Cursor Position within a screen
/    d  WDW                  382    383i 0
/     * Cursor Position within a Window

     D SYSDFT          DS          1024    dtaara
T4890d  ExtSec               137    137
     D  FAXTYP               251    251
     D  PgmLib               296    305
/3765D  DTALIB               306    315
T4890d  AppSec               373    373
     D  STAPCL               470    470
     D  SOPTCL               529    529
J5883D DSRCD1        E DS                  EXTNAME(RMAINT)
J5883D*DSRCD1          DS                  likeRec(rmntrc)
      *              Fields from RMAINT

     D DSRCD2          DS           500
      *              Test 1st access against 2nd access

     D DSRCD3          DS           500
      *              Test Report Type key is unique

     D XKEY            DS
      *              Current key values
     D  XRNAM                  1     10
     D  XJNAM                 11     20
     D  XPNAM                 21     30
     D  XUNAM                 31     40
     D  XUDAT                 41     50
     D YKEY            DS
      *              Current key values
     D  YRNAM                  1     10
     D  YJNAM                 11     20
     D  YPNAM                 21     30
     D  YUNAM                 31     40
     D  YUDAT                 41     50

     D PSCON           C                   CONST('PSCON     *LIBL     ')

     D ERRCD           DS           116
      *             Api error code
     D  @ERLEN                 1      4B 0
      *                                   B   5   80@ertcd
     D  @ERCON                 9     15
     D  @ERDTA                17    116

1964 d                 ds
/    d ValidDtaStr                   21a   inz('    PSASCPCLPDFPS TXT')
/    d aryDtaStr                      3a   dim(DTASTRMAX) overlay(ValidDtaStr)

/    d p_Indicators    s               *   inz(%addr(*in))
/    d
/    d Indicatorsds    ds                  based(p_Indicators)
/    D  blnInvalidRSec...
/    d                        11     11n
/    D  blnInvalidRDesc...
/    d                        12     12n
/    D  blnInvalidRptType...
/    d                        13     13n
/    D  blnInvalidOptVolume...
/    d                        14     14n
/    D  blnInvalidPagStr...
/    d                        15     15n
/    D  blnInvalidOutQ...
/    d                        16     16n
/    D  blnInvalidDJeb...
/    d                        17     17n
/    D  blnInvalidUSFF1...
/    d                        18     18n
/    D  blnInvalidDEFEL...
/    d                        19     19n
/    D  blnInvalidDJEA...
/    d                        20     20n
/    D  blnInvalidUsFF2...
/    d                        21     21n
/    D  blnInvalidPtrFl...
/    d                        22     22n
/    D  blnInvalidBnrID...
/    d                        23     23n
/    D  blnInvalidPrtCpg...
/    d                        24     24n
/    D  blnInvalidCPgId...
/    d                        25     25n
/    D  blnInvalidPtrLib...
/    d                        26     26n
/    D  blnInvalidInstr...
/    d                        27     27n
/    D  blnInvalidPForm...
/    d                        28     28n
/    D  blnInvalidDefp...
/    d                        29     29n
/    D  blnInvalidGrfVr...
/    d                        30     30n
/    D  blnInvalidDtaStr...
/    d                        31     31n
/    D  blnInvalidPRTyp...
/    d                        32     32n
/    D  blnInvalidPNode...
/    d                        33     33n
/    D  blnInvalidFXFrm...
/    d                        34     34n
/    D  blnInvalidFXLan...
/    d                        35     35n
/    D  blnInvalidFXCPI...
/    d                        36     36n
/    D  blnInvalidFXLPI...
/    d                        37     37n
/    D  blnInvalidOldAy...
/    d                        58     58n
/    d  blnValidateError...
/    d                        91     91n


1509  // Variables ------------------------------------------------------------
/    d blnSecLnkWarn   s               n   inz(FALSE)
1964 d strDataStream   s              3a
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

     C     *ENTRY        PLIST
     C                   PARM                    RNAM             10            Big5
     C                   PARM                    JNAM             10
     C                   PARM                    PNAM             10
     C                   PARM                    UNAM             10
     C                   PARM                    UDAT             10
     C                   PARM                    RDESC            40            Rpt desc
     C                   PARM                    ACTION            1            Action code
     C                   PARM                    RTNCDE            8            Return code

     C     RTNCDE        IFEQ      'CLOSEW'
     C                   MOVE      *ON           *INLR

/3765C                   if        DMSDfnLoaded = 'Y'
     C                   callp     CsNoteQuit
     C                   end

     C                   RETURN
     C                   END

     C                   MOVE      RNAM          PRVACC           10            Prev acct
     C                   SETON                                        39        Dsp switch

     C                   MOVE      RNAM          YRNAM
     C                   MOVE      JNAM          YJNAM
     C                   MOVE      PNAM          YPNAM
     C                   MOVE      UNAM          YUNAM
     C                   MOVE      UDAT          YUDAT
      *>>>>
     C     START         TAG
     C                   MOVE      ACTION        AX                3 0          Make numeric
     C                   MOVE      ACT(AX)       ACTTXT                         Move text
      /free
            Chain(e) (RNam:JNam:PNam:UNam:Udat) RMnTrc;

            If %error;
              *in20 = *on;

              Select;
                When %status( RMaint ) = 1218; // Record Lock
                  *inlr = *on;
                Other;
                  *inlr = *on;
              EndSl;

            Else;
              *in20 = *off;
            EndIf;
      /end-free
     C     KLBIG5        KLIST
     C                   KFLD                    RNAM
     C                   KFLD                    JNAM
     C                   KFLD                    PNAM
     C                   KFLD                    UNAM
     C                   KFLD                    UDAT

     C     *IN20         IFEQ      *ON
     C                   MOVEL(P)  'REACCESS'    RTNCDE
     C                   GOTO      BADEND
     C                   END

      * If no RTypId, assign one, offering RNAM as default
     C     RTYPID        IFNE      *BLANKS
     C                   UNLOCK    RMAINT
     C                   ELSE
     C                   CALL      'GETNUM'
     C                   PARM      'GETQWT'      GETOP             6
     C                   PARM      'RPTTYP'      GETTYP           10
     C                   PARM      RNAM          RTYPID                         R987654321
     C                   UPDATE(e) RMNTRC
     C     KLBIG5        CHAIN(N)  RMNTRC                             20
     C                   END

     C                   MOVEL(P)  DSRCD1        DSRCD2                         Save record
     C                   SETON                                        53        Protect BIG5
     C                   MOVE      ' '           WARNED
/
T5079c                   if        RMLCKF <> Sv_NotAllowed and rmlckf <> 0      Don't allow
/3765c                   move      *on           *in70                          delete after
/    c                   else
/    c                   move      *off          *in70
/    c                   endif

     C     DSPLY         TAG
     C     ACTION        IFEQ      '7'
J5883c                   Eval      blnChangeDesc = TRUE
     C                   EXFMT     DSPLY5                                       ChgDesc only
J5883c                   Eval      strNewDesc = rrdesc
     C                   ELSE
     C     ACTION        COMP      '2'                                    51     Protect

/1964C                   If        ( ( d2Row > 0 ) and
/    c                               ( d2Col > 0 )      )
/    c                   Eval      LinNbr = d2Row
/    c                   Eval      PosNbr = d2Col
/    c                   EndIf

J3175 /free
J3175  clear tcclsnam;
J3175  chain(n) rtypid mftsmmc;
J3175  if %found;
J3175    tcclsnamo = tcclsnam;
J3175  endif;
J3175 /end-free

J6624 /free
J6624  *in66 = *off;
J6624  if riname <> ' ';
J6624    *in66 = *on;
J6624  endif;

     C                   EXFMT     DSPLY2

J4158 /free
J4158  // Security flags change indicators.
J4158  if *in81 or *in82 or *in83 or *in84;
J4158    secFlagsChg.enableSec = *in81;
J4158    secFlagsChg.enableAud = *in82;
J4158    secFlagsChg.enableLmt = *in83;
J4158    secFlagsChg.enableLnk = *in84;
J4158  endif;
J4158 /end-free

     C                   ENDIF

     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *OFF          *IN56
     C                   MOVE      *OFF          *IN57
     C                   MOVE      *OFF          *IN58
     C                   MOVE      *OFF          *IN61
     C                   MOVEA     '00000000'    *IN(11)
     C                   MOVEA     '00000000'    *IN(19)
     C                   MOVEA     '00000000'    *IN(27)
     C                   MOVE      *OFF          *IN91

     C     KEY           IFEQ      HELP                                         Help
     C                   MOVEL(P)  'DSPLY2'      HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
     C     PLHELP        PLIST
     C                   PARM      'CHGRPTFM'    DSPFIL           10
     C                   PARM                    HLPFMT           10
     C                   GOTO      DSPLY
     C                   END
      * F3/f12
     C     KEY           IFEQ      F3
     C     KEY           OREQ      F12
     C                   GOTO      ENDPGM
     C                   END
      * F4=Prompt
     C     KEY           IFEQ      F4
     C                   EXSR      WRKSUB
     C                   GOTO      DSPLY
     C                   END
      * F13=Print Config                                                  MainLn
     C     KEY           IFEQ      F13
     C                   EXSR      PRTCFG
     C                   GOTO      DSPLY
     C                   ENDIF

J5883C     KLBIG5        CHAIN     RMNTRC                             43
     C     *IN43         CABEQ     *ON           ENDPGM

J5883 /free
J5883                    If ( Action = ACTION_CHGDESC );
J5883                      If ( blnChangeDesc = TRUE );
J5883                         blnChangeDesc = FALSE;
J5883                         rrdesc = strNewDesc;
J5883                         Update RmntRc %fields(rrdesc);
J5883                      EndIf;
J5883                    EndIf;
J5883 /end-free
      * Compare to previous rec to see if it changed
     C     DSRCD1        IFNE      DSRCD2
     C                   EXCEPT    RELESE                                       Release lock
     C                   MOVEL(P)  DSRCD1        DSRCD2                         Save record
     C                   SETON                                        64        Set error
     C                   GOTO      DSPLY
     C                   END

      * DB record has overlayed the display. Read screen again.
     C     ACTION        IFEQ      '7'                                          ChgDesc only   MainL
     C                   READ      DSPLY5                                 20
     C                   ELSE                                                   Chg all flds
     C                   READ      DSPLY2                                 20
     C                   ENDIF

     C                   MOVEL     RRDESC        RDESC                          from RMaint

     C     RTYPID        IFEQ      *BLANKS
     C                   CALL      'GETNUM'
     C                   PARM      'GETQWT'      GETOP             6
     C                   PARM      'RPTTYP'      GETTYP           10
     C                   PARM                    RTYPID                         R987654321
     C                   END

     C     '2'           IFEQ      ACTION                                       Chg
     C     '3'           OREQ      ACTION                                       Copy
     C     '6'           OREQ      ACTION                                       Add
     C     '7'           OREQ      ACTION                                       ChgDesc only

     C     '7'           IFNE      ACTION
     C                   EXSR      VALIDT
     C     *IN91         CABEQ     *ON           DSPLY
     C                   ENDIF
/3765 * ----------------------
/3765C     PreDMS        tag
/3765 * ----------------------
/3765 * If DMS is loaded and image or PC file, prompt for variables...
/8051C                   if        DMSInstall = 'Y' and RINAME <> *blanks and
/8051c                             action = '2'
/3765C                   exsr      $DMS
/3765
/3765C                   if        (Key = F3 or Key = F12)
/3765C                   unlock    RMAINT
/3765
/3765C                   select
/3765C                   when      Key = F3
/3765C                   goto      ENDPGM
/3765C                   when      Key = F12
/3765C                   goto      DSPLY
/3765C                   endsl
/3765
/3765C                   endif
/3765
/3765C                   else
/3765 * ...else set defaults.
/3765C                   z-add     Sv_NotAllowed RMLCKF
/3765C                   eval      RMANNF = 'N'
/3765C                   eval      RMBRCF = 'N'
/3765C                   endif
     C                   END

J3175  //Update/Write TSM managment class record.
J3175 /free
J3175  chain rtypid mftsmmc;
J3175  tcclsnam = tcclsnamo;
J3175  if %found;
J3175    update tcrec;
J3175  else;
J3175    tctypid = rtypid;
J3175    write tcrec;
J3175  endif;
J3175 /end-free

     C     ACTION        IFNE      '7'
     C                   EXSR      WRKSEC                                       Call WWSecur
     C                   MOVE      RTNCDE        KEY               1
/3765
/3765C                   if        KEY = F12
/3765
/3765C                   if        DMSInstall = 'Y' and
/3765C                             RINAME <> *blanks
/3765C                   goto      PreDMS
/3765C                   else
/3765C                   goto      START
/3765C                   endif
/3765
/3765C                   endif
/3765
     C                   ENDIF
/3765
/    c                   if        RMLCKF <> Sv_NotAllowed                      Don't allow
J3724 /free
J3724  chain(e) klbig5 rmaint;
J3724  rolGen = 0;
J3724  update(e) rmntrc;
J3724  if %error;
J3724    exsr bonErr;
J3724  endif;
J3724 /end-free
/    c                   endif

/3765C                   CALL      'MAG901'                             81      Trans logger
/3765C                   PARM                    LOGRTN            1            return code
/3765C                   PARM      *BLANK        DLSUB            10            subscriber
/3765C                   PARM      RTYPID        DLREPT           10            report type
/3765C                   PARM      *BLANK        DLSEG            10            segment
/3765C                   PARM      *BLANK        DLREP            10            report SPY#
/3765C                   PARM      *BLANK        DLBNDL           10            bundle
/3765C                   PARM      'M'           DLTYPE            1            (M)odify
/3765C                   PARM      1             DLTPGS            9 0          pages
/3765C                   PARM      'CHGRPT'      DLPROG           10

      *>>>>
     C     ENDPGM        TAG
     C                   MOVEL(P)  'GOOD'        RTNCDE
      *>>>>
     C     BADEND        TAG
     C                   MOVEL     RRDESC        RDESC                          Return Desc

     C     KEY           IFEQ      F3
     C     KEY           OREQ      F12
     C                   MOVE      KEY           RTNCDE
     C                   ENDIF

     C                   RETURN                                                 Return         MainL

/3765 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3765 * Prompt for/validate DMS variables
/3765C     $DMS          begsr
/3765
/3765C     KyDMS         klist
/3765C                   kfld                    CNAME
/3765C                   kfld                    CTYPE
/3765
/3765 * Load DMS definition array first time
/3765C                   if        DMSDfnLoaded = 'N'
/3765C                   exsr      $DMSLodDfn
/3765C                   endif
/3765
/3765 * Load DSPF variables from RMAINT
/3765C                   eval      DMSIdx = 1
/3765C                   z-add     RMLCKF        DMSKeyLookup
/3765
/3765C     DMSKeyLookup  lookup    DMSKey(DMSIdx)                         90
/3765
/3765C                   if        not *in90
/3765C                   eval      DMSIdx = 1
/3765C                   z-add     Sv_NotAllowed DMSKeyLookup
/3765C     DMSKeyLookup  lookup    DMSKey(DMSIdx)                         90
/3765C                   endif
/3765
/3765C                   eval      #LCKF = DMSTxt(DMSIdx)
/3765C                   eval      #ANNF = RMANNF
/3765C                   eval      #BRCF = RMBRCF
/3765
/3765 * Note if document is currently "on" DMS. If so, user cannot choose
/3765 * the lock type corresponding to a document being "off" DMS.
/3765C                   eval      OffDMSNotAllowed = '0'
/    c                   if        RMLckF <> 0 and                              Rev Control
/    c                             RMLckF <> Sv_NotAllowed
/    c                   if        0 = ChkLckByDocTyp(RTypID)                   Any Locks?
/3765C                   eval      OffDMSNotAllowed = '1'
/    c                   end
/    c                   end

/3765 * (just in case...)
/3765C                   if        (#ANNF <> 'Y' and #ANNF <> 'N')
/3765C                   eval      #ANNF = 'N'
/3765C                   endif
/3765
/3765C                   if        (#BRCF <> 'Y' and #BRCF <> 'N')
/3765C                   eval      #BRCF = 'N'
/3765C                   endif
/3765
      * Protect annotations as revision y/n field if not allowed or previous exist.
/4993c                   eval      *in93 = '0'
/3765c                   write     dsply4
/3765
/3765 * Prompt and validate
/3765 * Main loop
/3765C                   dou       (Key = F3 or Key = F12) or
/3765C                             DMSok
/3765
/3765C                   exfmt     DSPLY4
/3765
/3765 * Help loop
/3765C                   dow       Key = Help
     C                   MOVEL(P)  'DSPLY4'      HLPFMT
/3765C                   call      'SPYHLP'      plHelp
/3765C                   read      DSPLY4
/3765C                   enddo
/3765
/3765C                   if        (Key = F3 or Key = F12)
/3765C                   iter                                                   -Main loop
/3765C                   endif
/3765
/3765C                   exsr      $DMSValidate
/3765C                   enddo
/3765
/3765C     XDMS          endsr
/3765 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3765 * Validate DMS entries
/3765 *   RMLCKF error: *in94 - once "on DMS" can not be changed to "NONE"
/3765 *   RMLCKF error: *in95
/3765 *   RMANNF error: *in96
/3765 *   RMBRCF error: *in97
/3765 *   RMLCKF error: *in98 - not allowed to go "on DMS" if "old notes" exist
/3765
/3765C     $DMSValidate  begsr
/3765 *Default value for 7.1.0 ----------------------------------------
/3765C                   eval      RMBRCF = 'N'
/3765 *----------------------------------------------------------------
/3765
/3765C                   eval      DMSok = '0'
/3765
/3765C                   z-add     1             DMSIdx
/4993C                   movea     '000000'      *in(93)
/3765
/3765 * Validate revisions allowed/lock type flag
/3765C     #LCKF         lookup    DMSTxt(DmsIdx)                         95    -eq
/3765
/3765C                   eval      *in95 = not *in95
/3765
/3765 * Validate annotations as revisions flag
/3765C                   if        (#ANNF <> 'Y' and #ANNF <> 'N')
/3765C                   eval      *in96 = '1'
/3765C                   endif

      * Annotations as revision flag cannot be 'Y' if lock type is *NONE or *PREV.
     c                   eval      *in52 = '0'
     c                   if        #annf = 'Y' and
/5647c                             (DMSKey(DmsIdx) = Sv_NotAllowed or
/    c                             DMSKey(DmsIdx) = Sv_PrvAllowed)
/    c                   eval      *in52 = '1'
/    c                   endif

/3765 * Validate branching allowed flag
/3765C                   if        (#BRCF <> 'Y' and #BRCF <> 'N')
/3765C                   eval      *in97 = '1'
/3765C                   endif
/3765
/    c                   if        DMSKey(DmsIdx) <> Sv_NotAllowed and
/    c                             (rmlckf = Sv_NotAllowed or rmlckf = 0)
/    c                   eval      rc = ChkOldNote(Rtypid:DtaLib)
/    c                   if        rc <> 1
/    c                   eval      *in98 = '1'
/    c                   end

      * If changing class to RC put up disclaimer that more keys are incompatible with RC.
     c                   eval      *in93 = '1'
/    c                   exfmt     dsply4

/3765c                   end
/3765
/3765 * If document is "on" DMS then the lock type cannot be changed to
/3765 * the type corresponding to "off" DMS.
/3765C                   if        (DMSKey(DMSIdx) = Sv_NotAllowed) and
/3765C                             OffDMSNotAllowed
/3765C                   eval      *in94 = '1'
/3765C                   endif

/4993c                   if        (not *in94 and
/3765C                              not *in95 and
/3765C                              not *in96 and
/3765C                              not *in97 and
/3765C                              not *in98 and
/5647C                              not *in52)
/3765C                   eval      DMSok = '1'
/3765C                   eval      RMLCKF = DMSKey(DmsIdx)
/3765C                   eval      RMANNF = #ANNF
/3765C                   eval      RMBRCF = #BRCF
/3765C                   endif
/3765
/3765C     XDMSValidate  endsr
/3765 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3765 * Load SPYCTL definitions for DSPF
/3765C     $DMSLodDfn    begsr
/3765
/3765C                   eval      DMSDfnLoaded = 'Y'
/3765
/3765C                   eval      CNAME = 'RMAINT'
/3765C                   eval      CTYPE = 'DM'
/3765
/3765 * Read all SPYCTL records to fill DSPF definition variable array
/3765C     KyDMS         setll     SPYCTL
/3765C     KyDMS         reade     SPYCTL                                 90
/3765
/3765C                   clear                   DMSDfn
/3765C                   clear                   DMSIdx
/3765
/3765C                   dow       DMSIdx <= DMSCnt and
/3765C                             *in90 = '0'
/3765C                   add       1             DMSIdx
/3765C                   eval      @ErCon = CMSGID
/3765
/3765C                   exsr      RTVMSG
/3765
/3765C                   move      CKEY          DMSKey(DMSIdx)
/3765C                   eval      DMSTxt(DMSIdx) = %trim(CTEXT)
/3765C                   eval      DMSDfn(DMSIdx) =
/3765C                             DMSTxt(DMSIdx) + '=' +
/3765C                             %trim(@MsgTx)
/3765
/3765 * Load DSPF variables
/3765C                   select
/3765C                   when      DMSKey(DMSIdx) = Sv_NotAllowed
/3765C                   eval      DMSNONE =
/3765C                             %trim(DMSDfn(DMSIdx))
/3765C                   when      DMSKey(DMSIdx) = Sv_Exclusive
/3765C                   eval      DMSEXCL =
/3765C                             %trim(DMSDfn(DMSIdx))
/3765C                   when      DMSKey(DMSIdx) = Sv_ReadOnly
/3765C                   eval      DMSREAD =
/3765C                             %trim(DMSDfn(DMSIdx))
/3765C                   when      DMSKey(DMSIdx) = Sv_AskLckState
/3765C                   eval      DMSUSER =
/3765C                             %trim(DMSDfn(DMSIdx))
/3765C                   when      DMSKey(DMSIdx) = Sv_PrvAllowed
/3765C                   eval      DMSPREV =
/3765C                             %trim(DMSDfn(DMSIdx))
/3765C                   endsl
/3765
/3765C     KyDMS         reade     SPYCTL                                 90
/3765C                   enddo
/3765
     C                   callp     CsNoteInit
/3765
/3765C     XDMSLodDfn    endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     VALIDT        BEGSR
      *          Validation
     C                   CLEAR                   @ERCON

      * Be certain user has not entered an existing Report Type
     C     ACTION        IFNE      '6'
     C     ACTION        ANDNE     '3'
     C     RTYPID        IFNE      *BLANKS
     C                   MOVEL(P)  DSRCD1        DSRCD3
     C                   MOVE      *OFF          *IN49
     C     RTYPID        SETLL     RMAINT5

     C     *IN49         DOWEQ     *OFF
     C     RTYPID        READE     RMAINT5                                49
     C     *IN49         IFEQ      *OFF
     C                   MOVE      RRNAM         XRNAM
     C                   MOVE      RJNAM         XJNAM
     C                   MOVE      RPNAM         XPNAM
     C                   MOVE      RUNAM         XUNAM
     C                   MOVE      RUDAT         XUDAT
     C     XKEY          IFNE      YKEY
     C                   MOVE      ERR(5)        @ERCON
     C                   MOVE      *ON           *IN34
     C                   MOVE      *ON           *IN13
     C                   GOTO      BOTVAL
     C                   END
     C                   END
     C                   ENDDO

     C                   MOVEL(P)  DSRCD3        DSRCD1
     C     *IN91         CABEQ     *ON           BOTVAL
     C                   END
     C                   END

J6624 /free
J6624  *in38 = *off;
J6624  if routlib <> ' ' and riname = ' ';
J6624    clear spyChkFlg;
J6624    spyChkObj(routlib:'*LIBL':'*LIB':spyChkFlg);
J6624    if spyChkFlg = '1'; //Doesn't exist. Show create window.
J6624      crtlibyn = 'Y';
J6624      exfmt createLib;
J6624      if not *in12 and crtlibyn = 'Y';
J6624        mag1030rtn = ' ';
J6624        mag1030(mag1030rtn:'QSYS':routlib:'*LIB':
J6624        if system('crtlib ' + routlib) <> 0;
J6624          *in38 = *on;
J6624          @ercon = 'ERR1443';
J6624        else; //Change ownership; set public authority.
J6624          system('chgobjown ' + %trimr(routlib) + ' *LIB ' + newOwn);
J6624          system('grtobjaut ' + %trimr(routlib) + ' *LIB *PUBLIC *USE');
J6624          *in38 = *on;
J6624          @ercon = 'P000511';
J6624          warned = 'Y';
J6624        endif;
J6624      else; //Aborted.
J6624        warned = 'Y';
J6624        @ercon = 'ACT0042';
J6624        *in38 = *on;
J6624      endif;
J6624    endif;
J6624  endif;
J6624 /end-free

     C     STAPCL        IFEQ      'Y'
     C     SOPTCL        OREQ      'Y'
     C     ROLDAY        IFGT      0
     C     ROFGEN        ANDGT     0
     C     ROLGEN        ORGT      0
     C     ROFDAY        ANDGT     0
     C     WARNED        IFNE      'Y'
      *          "WARNING - Days and Gens are mixed"
     C                   MOVE      ERR(12)       @ERCON                         Warning Msg
     C                   MOVE      *ON           *IN58
     C                   MOVE      'Y'           WARNED            1
     C                   ENDIF
     C                   ELSE

     C     ROLDAY        IFGT      0                                            DelDay entrd
     C     ROLDAY        ANDLT     ROFDAY                                        < MovDays
     C     ROLGEN        ORGT      0                                            DelGen entrd
     C     ROLGEN        ANDLT     ROFGEN                                        < MovGens
     C                   MOVE      ERR(1)        @ERCON
     C                   MOVE      *ON           *IN58
     C                   GOTO      BOTVAL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Multivol optical ID
     C     ROPVID        IFNE      *BLANKS
     C     VCTKY         KLIST
     C                   KFLD                    ROPVID                         Moptvct
     C                   KFLD                    SEQ#                           Key List
     C                   Z-ADD     1             SEQ#              5 0
     C     VCTKY         SETLL     MOPTVCT
     C     ROPVID        READE     OPVCTR                                 54
     C     *IN54         IFEQ      *ON
     C                   MOVE      ERR(4)        @ERCON
     C                   MOVE      *ON           *IN14
     C                   GOTO      BOTVAL
     C                   END
     C                   END

      * Print cover page
     C     PRTCPG        IFNE      ' '
     C     CPGID         ANDEQ     *BLANKS
     C                   MOVE      ERR(6)        @ERCON
     C                   MOVE      *ON           *IN24
     C                   GOTO      BOTVAL
     C                   END

      * APF PrtType (SpyCtl file)
     C     RPRTYP        IFNE      *BLANKS
     C                   MOVEL(P)  'APFPRTYP'    CNAME
     C                   MOVEL(P)  RPRTYP        CKEY
     C     KLSCTL        SETLL     SPYCTLF                                45
     C     *IN45         IFEQ      *OFF
     C                   MOVE      ERR(7)        @ERCON
     C                   MOVE      *ON           *IN30
     C                   GOTO      BOTVAL
     C                   ENDIF
     C                   ENDIF

      * FaxRotation  (SpyCtl file)
     C     RFXLAN        IFNE      *BLANKS
     C                   MOVEL(P)  'FAXROT'      CNAME
     C                   MOVEL(P)  RFXLAN        CKEY
     C     KLSCTL        SETLL     SPYCTLF                                45
     C     *IN45         IFEQ      *OFF
     C                   MOVE      ERR(8)        @ERCON
     C                   MOVE      *ON           *IN32
     C                   GOTO      BOTVAL
     C                   ENDIF
     C                   ENDIF

      * If fax type is not FaxServer;
     C     FAXTYP        IFNE      '8'
      * FaxCPI  (SpyCtl file)
     C     RFXCPI        IFNE      *BLANKS
     C                   MOVEL(P)  'FAXCPI'      CNAME
     C                   MOVEL(P)  RFXCPI        CKEY
     C     KLSCTL        SETLL     SPYCTLF                                45
     C     *IN45         IFEQ      *OFF
     C                   MOVE      ERR(9)        @ERCON
     C                   MOVE      *ON           *IN33
     C                   GOTO      BOTVAL
     C                   ENDIF
     C                   ENDIF

      * FaxLPI (SpyCtl file)
     C     RFXLPI        IFNE      *BLANKS
     C                   MOVEL(P)  'FAXLPI'      CNAME
     C                   MOVEL(P)  RFXLPI        CKEY
     C     KLSCTL        SETLL     SPYCTLF                                45
     C     *IN45         IFEQ      *OFF
     C                   MOVE      ERR(10)       @ERCON
     C                   MOVE      *ON           *IN34
     C                   GOTO      BOTVAL
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

      *                  Check for a valid data stream type

/1964c                   If        %lookup(rdtstr:aryDtaStr) = 0
/    c                   Eval      @ErCon = 'ERR2130'
/    c                   Eval      blnInvalidDtaStr = TRUE
/    c                   Goto      BotVal
/    c                   EndIf

/1509c                   If        ( RSCLNK =  'Y' ) and
/    c                             ( RLMTSC <> 'Y' )
J2834c                   Eval      RLMTSC = 'Y'
/1509c                   Eval      @Ercon = 'ERR2129'
/    c                   Goto      BotVal
/    c                   EndIf

/1509C                   If        ( ( RSCLNK = 'Y' )  and
/    C                               ( blnSecLnkWarn = FALSE ) )
/     /free
/
/      //  Check for the group profile *PUBLIC not existing
/      //  for the current DocClass
/
/                        Open(e)   Rsecur;
/                        Setll (RNam:JNam:PNam:UNam:UDat) RSecur;

/                        If blnSecLnkWarn = FALSE;
/                          @ErCon = 'ERR2134';
/                          blnSecLnkWarn = TRUE;
/                        EndIf;

/                        Reade (RNam:JNam:PNam:UNam:UDat) RSecur;
/
/                        DoW %equal and NOT %eof;
/
/                          If ( ( SUser = USR_PUBLIC ) and
/                               ( SSIDTy = DSGN_USRPRF )    );
/                            // blnsecLnkWarn = FALSE;
/                            @ErCon = *blanks;
/                            Leave;
/                          EndIf;
/
/                          Reade (RNam:JNam:PNam:UNam:UDat) RSecur;
/                        EndDo;
/
/                        Close(e) RSecur;
/
/                        If @ErCon <> *blanks;
/                          ExSr RtvErm;
/                          *in91 = *on;
/                          LeaveSr;
/                        EndIf;
/
/     /end-free
/
/      //  Check for the group profile existing, but not defined
/      //
/    C                   Open(e)   AdSecLnk1
/    C                   Eval      AdRptID =  RTYPID
/    C                   Eval      AdDesgn =  DSGN_USRPRF
/    C                   Eval      AdUsrGrp = USR_PUBLIC
/     /free
/                        Setll (AdRptID:ADDesgn:ADUsrGrp) AdSecLnk1;
/     /end-free
/    c                   Close(e)  AdSecLnk1

/    C                   If        Not %Equal
     C
/    c                   If        blnSecLnkWarn = FALSE
/    C                   Eval      @ErCon = 'ERR2128'
/    C                   Eval      blnSecLnkWarn = TRUE
/    C                   EndIf

/    C                   Goto      BotVal
/    C                   EndIf

/    C                   EndIf

     C     BOTVAL        TAG
     C     @ERCON        IFNE      *BLANK
     C                   EXSR      RTVERM
     C                   MOVE      *ON           *IN91
     C                   END
     C                   ENDSR
      *----------------------------------------------------------------
     C     KLSCTL        KLIST                                                  SpyCtl key
     C                   KFLD                    CNAME
     C                   KFLD                    CTYPE
     C                   KFLD                    CKEY

/1509c     KeySecLnk     KList
/    c                   KFld                    ADrptID
/    c                   KFld                    ADDesgn
/    c                   KFld                    ADUsrGrp
/    c                   KFld                    ADDocLnk

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     BONERR        BEGSR
      *          Branch on disk write or update error

     C     STS           CABEQ     01021         DSPLY                    65     Dup key
      *                                                      redisplay.
     C                   MOVEL(P)  'DSKERR'      RTNCDE
     C                   GOTO      BADEND                                        Exit pgm.
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRKSUB        BEGSR
      *          Determine Row/Column when CMD-4 was hit, and call
      *          the correct work with program
     C                   MOVE      *BLANKS       LKPOBJ
     C                   MOVEL     '*ALL'        LKPOBJ
     C                   MOVE      *BLANKS       LKPLIB
     C                   MOVEL     '*ALL'        LKPLIB

     C                   SELECT
1964 c                   When      Fld = 'RDTSTR'
/    c                   Eval      strDataStream = *blanks
/    c                   Callp(e)  GetCsrPos( Wdw : Scr : d2Row  : d2Col )
/    c                   Callp(e)  LstDSTyp( strDataStream )
     c
/    c                   If        strDataStream <> *blanks
/    c                   Eval      RdtStr = strDataStream
/    c                   EndIf
/    c
     C     FLD           WHENEQ    'ROPVID'
      *          Work with Multivolume Support
     C                   CALL      'WRKVOL'
     C                   PARM                    ROPVID                         VCT Name
     C                   PARM                    WVOL             12            Volume Name
     C                   PARM                    VCTRTN            8            Return Code
     C                   MOVE      *ON           *IN15                          (Format)

     C     FLD           WHENEQ    'RDEFQ'
     C                   CALL      'MAG2042'                            81
     C                   PARM                    LKPOBJ           10
     C                   PARM                    LKPLIB           10
     C                   PARM      '*OUTQ'       LKPTYP           10
     C                   PARM      *BLANKS       LKPATR           10
     C                   PARM      *BLANKS       RETOBJ           10
     C                   PARM      *BLANKS       RETLIB           10
     C     RETOBJ        IFNE      *BLANKS
     C                   MOVE      RETOBJ        RDEFQ
     C                   END
     C     RETLIB        IFNE      *BLANKS
     C                   MOVE      RETLIB        RDEFL
     C                   END
     C                   MOVE      *ON           *IN17

     C     FLD           WHENEQ    'RDEFL'
     C                   CALL      'MAG2042'                            81
     C                   PARM                    LKPOBJ
     C                   PARM      'QSYS'        LKPLIB
     C                   PARM      '*LIB'        LKPTYP
     C                   PARM      *BLANKS       LKPATR
     C                   PARM      *BLANKS       RETOBJ
     C                   PARM      *BLANKS       RETLIB
     C     RETOBJ        IFNE      *BLANKS
     C                   MOVE      RETOBJ        RDEFL
     C                   END
     C                   MOVE      *ON           *IN20

     C     FLD           WHENEQ    'RDEFP'
      *          Work with Printers
     C                   CALL      'WRKPTR'
     C                   PARM                    RDEFP                          Printer Name
     C                   PARM                    RDFILT                         Filter Name
     C                   PARM                    RDEFQ                          Out Queue
     C                   PARM                    RDEFL                          Library Name
     C                   PARM                    RTNCDE                         Return Code
     C                   MOVE      *ON           *IN29

     C     FLD           WHENEQ    'RDJEB'
     C                   CALL      'WRKDJD'
     C                   PARM                    RDJEB
     C                   PARM      '1'           WLIST
     C                   PARM                    RTNCDE
     C                   MOVE      *ON           *IN18

     C     FLD           WHENEQ    'RDJEA'
     C                   CALL      'WRKDJD'
     C                   PARM                    RDJEA
     C                   PARM      '1'           WLIST
     C                   PARM                    RTNCDE
/5324C                   MOVE      *ON           *IN20

     C     FLD           WHENEQ    'RBNRID'
     C                   CALL      'WRKBID'
     C                   PARM                    RBNRID
     C                   PARM      '1'           WLIST             1
     C                   PARM                    RTNCDE
     C                   MOVE      *ON           *IN24

     C     FLD           WHENEQ    'RINSTR'
     C                   CALL      'WRKINS'
     C                   PARM                    RINSTR
     C                   PARM      '1'           WLIST
     C                   PARM                    RTNCDE
     C                   MOVE      *ON           *IN28

     C     FLD           WHENEQ    'RPRTYP'
     C                   MOVEL(P)  'APFPRTYP'    CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL(P)  CTLKEY        RPRTYP
     C                   ENDIF
     C                   MOVE      *ON           *IN31

     C     FLD           WHENEQ    'RFXLAN'
     C                   MOVEL(P)  'FAXROT'      CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL(P)  CTLKEY        RFXLAN
     C                   ENDIF
     C                   MOVE      *ON           *IN33
      *                                                                   WRKSUB
     C     FLD           WHENEQ    'RFXCPI'
     C                   MOVEL(P)  'FAXCPI'      CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL(P)  CTLKEY        RFXCPI
     C                   ENDIF
     C                   MOVE      *ON           *IN33

     C     FLD           WHENEQ    'RFXLPI'
     C                   MOVEL(P)  'FAXLPI'      CTLNAM
     C                   EXSR      SPYPRM
     C     CTLKEY        IFNE      *BLANKS
     C                   MOVEL(P)  CTLKEY        RFXLPI
     C                   ENDIF
     C                   MOVE      *ON           *IN34
     C                   OTHER
      * F4 not available
     C                   MOVE      ERR(11)       @ERCON
     C                   MOVE      *ON           *IN91
     C                   EXSR      RTVERM

     C                   SELECT
     C     FLD           WHENEQ    'RRDESC'
     C                   MOVE      *ON           *IN12
     C     FLD           WHENEQ    'RTYPID'
     C                   MOVE      *ON           *IN13
     C     FLD           WHENEQ    'PAGSTR'
     C                   MOVE      *ON           *IN15
     C     FLD           WHENEQ    'RUSFF1'
     C                   MOVE      *ON           *IN18
     C     FLD           WHENEQ    'RUSFF2'
     C                   MOVE      *ON           *IN21
     C     FLD           WHENEQ    'PRTCPG'
     C                   MOVE      *ON           *IN24
     C     FLD           WHENEQ    'RPNODE'
     C                   MOVE      *ON           *IN29
     C     FLD           WHENEQ    'RFXFRM'
     C                   MOVE      *ON           *IN31
     C     FLD           WHENEQ    'RGRFVR'
     C                   MOVE      *ON           *IN85
     C                   ENDSL
     C                   ENDSL
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPYPRM        BEGSR
      *          Call SpyCtl to select from Valid field list.
     C                   CALL      'SPYCTL'                             50
     C                   PARM                    CTLNAM           10
     C                   PARM                    CTLTYP            2
     C                   PARM      *BLANKS       CTLKEY           10
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     WRKSEC        BEGSR
      *
J4158 /free
J4158  // If audit logging flag turned off, log the change before field is
J4158  // updated in rmaint. Otherwise, logging will not occur.
J4158  if secFlagsChg <> *all'0' and raudlog = 'N';
J4158    exsr logSecChg;
J4158  endif;
J4158 /end-free
/2195c                   UPDATE(e) RMNTRC
J4158 /free
J4158  // If audit logging flag is on and change to security flags then log.
J4158  if secFlagsChg <> *all'0' and raudlog = 'Y';
J4158    exsr logSecChg;
J4158  endif;
J4158 /end-free
      *          Call Work with Security
     C                   CALL      'WRKSEC'
     C                   PARM                    RRNAM                          Big5
     C                   PARM                    RJNAM
     C                   PARM                    RPNAM
     C                   PARM                    RUNAM
     C                   PARM                    RUDAT
     C                   PARM      'CLOSEE'      RTNCDE                         Pgm end
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PRTCFG        BEGSR
      *          Print SpyView Configuration Report (F13)Cmd

     C                   CALL      'MAG955'
     C                   PARM                    RRNAM                          Pass BIG-5
     C                   PARM                    RJNAM
     C                   PARM                    RPNAM
     C                   PARM                    RUNAM
     C                   PARM                    RUDAT
     C                   SETON                                        91
     C                   MOVE      MSG(1)        @ERCON
     C                   EXSR      RTVERM
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVERM        BEGSR
      *          Retrieve error message
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        ERRMSG
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RTVMSG        BEGSR
      *          Retrieve Message from PSCON

     C                   CALL      'MAG1033'
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80

     C                   MOVE      *BLANKS       @ERDTA
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR

     C                   IN        SYSDFT

/3765 * Flag for loading lock type definitions
/3765C                   eval      DMSDfnLoaded = 'N'
/3765
/3765 * Product authorization
/3765C                   CALLP     SPYAUT(13:AR_IND:AR_MSGID:AR_MDTA)
/3765C                   if        AR_IND = '1'
/3765C                   eval      DMSInstall = 'Y'
/3765C                   else
/3765C                   eval      DMSInstall = 'N'
/3765C                   endif
/3765
     C                   MOVEL     'RC'          CTYPE
     C                   Z-ADD     0             TEMP1             5 0
     C                   Z-ADD     0             TEMP2             5 0
     C                   MOVE      *BLANKS       @OBJT            10
     C                   MOVE      '0'           @OBJRC            1
     C                   MOVEL     'QSYS'        QSYS             10
      * Action text
     C                   MOVEL     'DSP1001'     @ERCON
     C                   EXSR      RTVMSG
     C                   MOVEA     @MSGTX        ACT

T4890 /free
T4890   // Determine if the edit security field should be protected
T4890   // based on the the security settings and the presense of
T4890   // a user defined applicatication setting.
T4890
        *in54 = *off;

T4890   If ExtSec = YES and AppSec = YES;
T4890     GetSecurity('WRKRDR':'N':'O':'A':'WRKRDR':PgmLib:aRName:
T4890                 aJName:aPName:aUName:aUData:intReqOpt:AutRtn:
T4890                 aAut);
T4890
T4890     If aAut(CONFIGURE) = YES and // If configuration is enabled
T4890        aAut(SECURITY)  = NO;     // and security not enabled
T4890       *in54 = *on;               // Inhibit Edit Security
T4890     EndIf;
T4890
T4890   EndIf;
T4890
T4890 /end-free
     C                   ENDSR
J4158 **************************************************************************
J4158 * Log Security Flag Changes.
J4158 **************************************************************************
J4158 /free
J4158  begsr logSecChg;
J4158    // Log security flags from RMAINT. Enable Security, Audit Logging,
J4158    // Limit Scrolling, DocLink Security. Only log what changed. This is
J4158    // outside of normal logging and is not documented to perform this
J4158    // operation. Leveraging capability, however.
J4158    if secFlagsChg <> *all'0';
J4158      reset LogDS;
J4158      LogOpCode = #AUCHGOBJAUT;
J4158      LogObjID = rtypid;
J4158      clear secSettings;
J4158      // Log only changed flags.
J4158      if secFlagsChg.enableSec;
J4158        secSettings.value = 'Enable Security=' + rsec;
J4158      endif;
J4158      if secFlagsChg.enableAud;
J4158        secSettings.value = %trim(secSettings.value) +
J4158          ' Enable Audit Logging=' + raudlog;
J4158      endif;
J4158      if secFlagsChg.enableLmt;
J4158        secSettings.value = %trim(secSettings.value) +
J4158          ' Limit Scrolling=' + rlmtsc;
J4158      endif;
J4158      if secFlagsChg.enableLmt;
J4158      secSettings.value = %trim(secSettings.value) +
J4158        ' DocLink Security=' + rsclnk;
J4158      endif;
J4158      secSettings.value = %trim(secSettings.value);
J4158      secSettings.len = %len(%trim(secSettings.value));
J4158      LogCmtPtr =
J4158        %alloc(%size(secSettings.len)+%len(%trim(secSettings.value)));
J4158      LogCmtPtr = %addr(secSettings);
J4158      LogEntry(%addr(LogDS));
J4158      dealloc(ne) LogCmtPtr;
J4158      reset LogDS;
J4158      secFlagsChg = *all'0';
J4158    endif;
J4158  endsr;
J4158 /end-free
     ORMNTRC    E            RELESE
/1964pGetCsrPos        b
/    dGetCsrPos        pi
/    d aWdw                           5u 0 const
/    d aScr                           5u 0 const
/    d aRow                           3s 0
/    d aCol                           3s 0
/    d MAXBYTE         c                   256
/     /free
/      If aWdw = *zero;
/        aRow = %div(aScr:MAXBYTE);
/        aCol = %rem(aScr:MAXBYTE);
/      Else;
/        aRow = %div(aWdw:MAXBYTE);
/        aCol = %rem(aWdw:MAXBYTE);
/      EndIf;
/     /end-free
/    pGetCsrPos        e
** ERR                                                               30
ERR1810 Delete After cannot be less than Move After       1
ERR1106 Output queue does not exist.                      2
ERR1142 Printer device does not exist.                    3
ERR1262 Optical multivolume ID does not exist.            4
ERR1145 Report type already exists.                       5
ERR1263 Cover page ID is blank.                           6
ERR1387 APF Print Type is Invalid                         7
ERR1388 Fax Style is Invalid                              8
ERR1389 Fax CPI is Invalid                                9
ERR1390 Fax LPI is Invalid                               10
ERR1391 Prompt is not available with this field          11
ERR1811 WARNING - Days and Gens are mixed                12
** MSG
MSG0010 print operation of report config complete         1

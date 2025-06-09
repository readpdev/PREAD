      *%METADATA                                                       *
      * %TEXT SpyLink Hit List API                                     *
      *%EMETADATA                                                      *
     h bnddir('SPYBNDDIR')
      /copy directives
      ***********-------------------------
      * SPYCSLNK   SpyLink Hit List API
      ***********-------------------------
      *
/8627 * 10-11-04 JMO Added SETBG opcode. This pgm was not changed.
      *                Only documented the new Opcode.
/4537 * 10-29-01 KAC Revise for VCO phase II functions.
/3765 * 03-07-01 KAC Add document revision support.
/3869 * 01-25-01 KAC Fix postitioning with Green screen F19/F20 w/filter.
      *  P3555HQ - 12/15/00 RA - Validate incoming parameters for blanks
      *
      *
      *
      *  Retrieve from SpyLink databases up to 10 records that match
      *  the requested filter query. Called by WRKSPI, SPYCS, DSPHYPLNK
      *                                        Spycshhit, Mag1085
      *  Note:
      *   If the program does a QUERY against a DASD SpyLink, the
      *   IO Buffer for the READ and for the KEY of the @000... file
      *   has to be formatted differently. Because of the FORMAT parm
      *   in the OPNQRYF (has to be used because you cannot read the
      *   QRYF with a LVLCHK(*NO)) the IO buffer fills the fields
      *   IXIV1-8 perfectly.  No SUBST operation is needed to fill
      *   the RV array.
      *
      *   WRKSPIFM is used with a OVRDSP SHARE(*YES) to handle query
      *   escape window properly.
      *
      *  Entry Parms:
      *
      *    Parm  name   size  description
      *    ----  -----  ----  ----------------------------------------
      *     1    @File    10  Name of file containing records to select
      *     2    @Hndl    10  Window Handle
      *     3    @Libr    10  Libr where file is found (SPYDATA)
      *     4    EnBig5   50  RMaint key of report
      *     5    OpCode    5  Selcr / Rdgt etc. (see below)
      *     6    Sec       3  Security for READ/DELETE/PRINT
      *     7    IFiltr 1000
      *                   1-490  filter index values 1-7 (7x70)
      *                    -498  filter index value  8   (from date)
      *                    -506  filter index value  9   (to date)
      *                    -516  Spy Version ID
      *                    -525  SpyLink sequence number
      *                    -534  Starting page
      *                    -543  Ending   page
      *                    -546  Read,Delete,Print flags:  Y/N
      *                    -547  Datatype:  0=Report 1=Image
      *                    -557  Link file name:  @.......00
      *                    -567  Link file library
      *                    -617  Big5
      *                    --------------------------------------------
      *     8    Sdt    7680  Send back buffer
      *                        Same as filter format but up to
      *                        10 occurrences
      *                        (See FILDTS subroutine)
      *     9    Rtn      2   Return code (20=warning 30=terminal)
      *     10   SetLR    1   Shutdown Pgm (Y/N)
      *     11   OptVol  12   Optical volume
      *     12   OptDir  80   Optical directory (e.g. SPYDATA)
      *     13   OptFil  10   Optical file name (e.g. @000070312)
      *
      *  When OPCODE is:
      *
      *          "SELCR"  start the search into the SpyLink database
      *                   pass back 10 hits.
      *
      *          "SETLL"  set lower limits to the logical, using
      *                   IFILTR fields through SpyLink sequence no.
      *
      *          "SETBG"  set file to the beginning of the filter, using
      *                   IFILTR fields through SpyLink sequence no.
      *
      *          "RDGT"   start where it left off on the previous call
      *                   pass back back the next 10 hits, reading fwd.
      *
      *          "SETGT"  set greater than to the logical, using
      *                   IFILTR fields through SpyLink sequence no.
      *
      *          "RDLT"   start where it left off on the previous call
      *                   and send back the PREVIOUS 10 hits.
      *                   Restart from the beginning if less
      *                   than 10 hits are available.
      *
      *          "RDLTX"  start where it left off on the previous call
      *                   and send back the PREVIOUS 10 hits.
      *                   DO NOT restart from the beginning if less
      *                   than 10 hits are available.
      *
      *          "SETEN"  set the logical to the end of the filter using
      *                   IFILTR fields through SpyLink sequence no.
      *
      *          "CLEAR"  clear the window handle, making it available.
      *
/2319 *          "INIT"   PROGRAM STARTUP
      *

      * Query selection parms.  All blank if regular filter is passed.
     D AO              S              3    DIM(25)                              AND/ORs
     D FN              S             10    DIM(25)                              Field names
     D TE              S              5    DIM(25)                              Comparators
     D VL              S             30    DIM(25)                              Values

     d qAO             s              3    DIM(25)                              And/Or
     d qFN             s             10    DIM(25)                              Field Names
     d qTE             s              5    DIM(25)                              Test
     d qVL             s             30    DIM(25)                              Values

     d                SDS
     d @PARMS                 37     39  0

      /copy @MGMEMMGRR                                                          Memory Manager

      * convert original spylinks filter criteria
     d CvtOrgCri       pr
     d orFltCritP                      *   const                                Original Criteria
     d mlFltCritP                      *   const                                MoreLinks Criteria

      * convert to original spylinks hit list
     d CvtOrgHit       pr
     d orHitListP                      *   const                                Original Hit list
     d mlHitListP                      *   const                                MoreLinks Hit list

     d HitCount        s             10i 0
     d RtnHits         s             10i 0
/4537d enKeyType       s             10
/    d enKeyData       s             20
     d enRevID         s             10i 0

     d RqstCrit        s           1024                                         MoreLinks Criteria
     d RqstBufrP       s               *   inz(%addr(RqstCrit))                 Request data
      * return data buffer (allocated as needed)
/3765d RtnBufrP        s               *                                        Return data
/    d RtnBufrLn       s             10i 0                                      Return length

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

       exec sql set option commit=*none, closqlcsr=*endactgrp;

     C     *ENTRY        PLIST
     C                   PARM                    @FILE            10            Link file
     C                   PARM                    @HNDL            10            Window handle
     C                   PARM                    @LIBR            10            @0000 libr
     C                   PARM                    ENBIG5           50            RLnkdef key
     C                   PARM                    OPCODE            5            Opcode
     C                   PARM                    SEC               3            Security
     C                   PARM                    IFilter        1000            Input filter
     C                   PARM                    RHitList       7680            Return data
     C                   PARM                    RtnCode           2            Return code
     C                   PARM                    MSGID             7            Msg id
     C                   PARM                    MSGDTA          100            Msg data
     C                   PARM                    SETLR             1            Shutdown Y/N
      * Optical parms 13-19
     C                   PARM                    OPTID            10
     C                   PARM                    OPTDRV           15
     C                   PARM                    OPTVOL           12
     C                   PARM                    OPTDIR           80
     C                   PARM                    OPTFIL           10            Opt @00...xx
     C                   PARM                    OVRL#             1 0          Ovride lgcl#
     C                   PARM                    #HITS             2 0          No of hits
      * Query parms 20-24
     C                   PARM                    AO                             And/Or
     C                   PARM                    FN                             Field Names
     C                   PARM                    TE                             Test
     C                   PARM                    VL                             Values
     C                   PARM                    QRYTYP            1            Qry type
      * Parm  25
     C                   PARM                    SHSFIL           10            Dst seg file

      * check parms passed
     c                   z-add     10            HitCount                       No of hits
     c                   if        @PARMS < 19
     c                   clear                   oOPTID
     c                   clear                   oOPTDRV
     c                   clear                   oOPTVOL
     c                   clear                   oOPTDIR
     c                   clear                   oOPTFIL                        Opt @00...xx
     c                   clear                   oOVRL#                         Ovride lgcl#
     c                   else
     c                   move      OPTID         oOPTID
     c                   move      OPTDRV        oOPTDRV
     c                   move      OPTVOL        oOPTVOL
     c                   move      OPTDIR        oOPTDIR
     c                   move      OPTFIL        oOPTFIL                        Opt @00...xx
     c                   move      OVRL#         oOVRL#                         Ovride lgcl#
     c                   move      #HITS         HitCount                       No of hits
     c                   end
     c                   if        @PARMS < 24
     C                   clear                   qAO                            And/Or
     C                   clear                   qFN                            Field Names
     C                   clear                   qTE                            Test
     C                   clear                   qVL                            Values
     C                   clear                   qQRYTYP                        Qry type
     c                   else
     C                   move      AO            qAO                            And/Or
     C                   move      FN            qFN                            Field Names
     C                   move      TE            qTE                            Test
     C                   move      VL            qVL                            Values
     C                   move      QRYTYP        qQRYTYP                        Qry type
     c                   end
     c                   if        @PARMS < 25
     C                   clear                   dSHSFIL                        Dst seg file
     c                   else
     C                   move      SHSFIL        dSHSFIL                        Dst seg file
     c                   end

      * convert original filter criteria to "7.0" format
     c                   eval      RqstCrit = *blanks
     c                   if         OPCODE = 'SELCR'
     c                              or %subst(OPCODE:1:3) = 'SET'
     c                              or %subst(OPCODE:1:2) = 'RD'
     c                   callp     CvtOrgCri(%addr(IFilter):RqstBufrP)
     c                   end

     c                   eval      dOPCODE = OPCODE
     c                   if        SETLR = 'Y'                                  Shutdown Y/N
     c                   eval      dOPCODE = 'QUIT'
     c                   end

      * call SpyLink Hit list server
     C                   call      'MCSPYHITR'   plSPYHIT
     C     plSPYHIT      PLIST
     C                   PARM                    @FILE            10            Link file
     C                   PARM                    @HNDL            10            Window handle
     C                   PARM                    ENBIG5           50            RLnkdef key
     C                   PARM                    dOPCODE          10            Opcode
     c                   parm      *blanks       CVersID           5            Major/Minor/Vers
     C                   PARM                    SEC               3            Security
/    c                   parm                    RqstBufrP                      Request buffer
/3765c                   parm                    RtnBufrP                       Return buffer
/    c                   parm                    RtnBufrLn                      Return length
     C                   PARM      *blanks       RtnCode           2            Return code
     C                   PARM      *blanks       MSGID             7            Msg id
     C                   PARM      *blanks       MSGDTA          100            Msg data
      * Optical parms 13-19
     C                   PARM                    oOPTID           10
     C                   PARM                    oOPTDRV          15
     C                   PARM                    oOPTVOL          12
     C                   PARM                    oOPTDIR          80
     C                   PARM                    oOPTFIL          10            Opt @00...xx
     C                   PARM                    oOVRL#            1 0          Ovride lgcl#
     c     RtnHits       parm                    HitCount                       Rqst/Rtrn Hits
      * parms 20 - 23
/4537c                   parm      *blanks       enKeyType                      key type
/    c                   parm      *blanks       enKeyData                      key data
     c                   parm      0             enRevID                        RevID
     C                   PARM                    dSHSFIL          10            Dst seg file
      * Query parms 24-28
     C                   PARM                    qAO                            And/Or
     C                   PARM                    qFN                            Field Names
     C                   PARM                    qTE                            Test
     C                   PARM                    qVL                            Values
     C                   PARM                    qQRYTYP           1            Qry type

      * return parms
/3869c                   if        @PARMS >= 19
/    c                   move      oOVRL#        OVRL#                         Ovride lgcl#
/    c                   move      RtnHits       #HITS                         No of hits
/    c                   end

      * convert "7.0" hit list back to original format
     c                   eval      RHitList = *blanks
     c                   if        RtnCode <> '30'
     c                               and RtnBufrLn > 0
     c                   callp     CvtOrgHit(%addr(RHitList):RtnBufrP)
     c                   end
     c                   callp     mm_free(RtnBufrP:1)
     c                   eval      RtnBufrLn = 0

     c     OPCODE        ifeq      'QUIT'
     c                   seton                                        lr
     c                   end
     c                   return

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert original spylinks filter criteria
     p CvtOrgCri       b
     d                 pi
     d orFltCritP                      *   const                                Original Criteria
     d mlFltCritP                      *   const                                MoreLinks Criteria

      * Original Spylinks Criteria structure
     d orCriDS         ds                  based(orCriDSp)
     d  orCriVal                     99    dim(7)                               Criteria value
     d  orCrtDtF                      8                                         Create From Date
     d  orCrtDtT                      8                                         Create To Date
     d  orFilBat                     10                                         SpyNumber/Batch
     d  orFilSeq                      9s 0                                      Batch sequence
/3555d   orFilSeqa                    9a   overlay(orFilSeq)                    Batch sequence

      * "MoreLinks" style Spylinks Criteria structure
/2924d LnkCriDS        ds                  based(LnkCriDSp)
     d  lcHdrSiz                      5  0
     d  lcCrtDtF                      8                                         Create From Date
     d  lcCrtDtT                      8                                         Create To Date
     d  lcCriCnt                      5  0                                      Criteria key count
     d  lcCriLen                      5  0                                      Criteria length
      * "MoreLinks Web" style Spylinks Criteria structure
/2924d LnkCriWDS       ds                  based(LnkCriWDSp)
     d  lwHdrSiz                      5  0
/    d  lwSpyBat                     10                                         Spy/Bat nbr
/    d  lwSpySeq                      9  0                                      Link Sequence nbr
     d  lwCrtDtF                      8                                         Create From Date
     d  lwCrtDtT                      8                                         Create To Date
     d  lwCriCnt                      5  0                                      Criteria key count
     d  lwCriLen                      5  0                                      Criteria length

     d Vdata           s          32767    based(VdataP)                        Criteria value
     d Vnbr            s              5i 0                                      value number
     d Vlen            s              5i 0                                      value len

     c                   eval      OrCriDSp = orFltCritP                        Original Criteria
/3555 * Check for valid numeric data and correct if blank
/3555C                   if        orFilSeqa = *blanks
/3555C                   eval      orFilSeq = 0
/3555C                   endif
      * build correct header
     c                   if        orFilBat = *blanks  and                      SpyNumber/Batch
     c                             orFilSeq = 0                                 Batch sequence
     c                   eval      LnkCriDSp = mlFltCritP                       MoreLinks
     c                   clear                   LnkCriDS
     c                   eval      lcHdrSiz = %size(LnkCriDS)                   header size
     c                   eval      lcCrtDtF = orCrtDtF                          Create From Date
     c                   eval      lcCrtDtT = orCrtDtT                          Create To Date
     c                   eval      VdataP = LnkCriDSp + %size(LnkCriDS)         start of values
     c                   else
     c                   eval      LnkCriWDSp = mlFltCritP                      MoreLinks Web
     c                   clear                   LnkCriWDS
     c                   eval      lwHdrSiz = %size(LnkCriWDS)                  header size
     c                   eval      lwCrtDtF = orCrtDtF                          Create From Date
     c                   eval      lwCrtDtT = orCrtDtT                          Create To Date
     c                   eval      lwSpyBat = orFilBat                          SpyNumber/Batch
     c                   eval      lwSpySeq = orFilSeq                          Batch sequence
     c                   eval      VdataP = LnkCriWDSp + %size(LnkCriWDS)       start of values
     c                   end

      * criteria values
     c                   eval      Vlen = %size(orCriVal)                       criteria length
     c                   dow       Vnbr < %elem(orCriVal)
     c                   eval      Vnbr = Vnbr + 1
     c                   eval      %subst(Vdata:1:Vlen) = orCriVal(Vnbr)        criteria values
     c                   eval      VdataP = VdataP + Vlen                       next value
     c                   enddo

     c                   if        orFilBat = *blanks  and                      SpyNumber/Batch
     c                             orFilSeq = 0                                 Batch sequence
     c                   eval      lcCriCnt = Vnbr                              Criteria key count
     c                   eval      lcCriLen = lcCriCnt * Vlen                   Criteria length
     c                   else
     c                   eval      lwCriCnt = Vnbr                              Criteria key count
     c                   eval      lwCriLen = lwCriCnt * Vlen                   Criteria length
     c                   end

     c                   return
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert to original spylinks hit list
     p CvtOrgHit       b
     d                 pi
     d orHitListP                      *   const                                Original Hit list
     d mlHitListP                      *   const                                MoreLinks Hit list

      * Original Spylinks hits structure
     d orHitDS         ds                  based(orHitDSp)
     d orHits                       768    dim(10)
     d  orValDta                    490    overlay(orHits:1)                    Index value
     d  orHitHdr                    278    overlay(orHits:491)                  Hit structure
     d orValDS         ds                  based(orValDSp)
     d  orVal                        70    dim(7)                               Index value

      * "MoreLinks" style Spylinks hits structure
     d mlHitDS         ds                  based(mlHitDSp)
     d  mlHdrSiz                      5  0
     d  mlHitHdr                    278                                         Hit structure
     d  mlValCnt                      5  0                                      Value count
     d  mlValLen                      5  0                                      Value length (all)
     d  mlMaxHit                      5  0                                      Max hits per buffer
     d  mlBufHit                      5  0                                      hits this buffer
     d mlValDS         ds                  based(mlValDSp)
     d  mlVal                     32767                                         Index value

     d mlHitP          s               *
     d Hnbr            s              5i 0                                      hit number
     d Vnbr            s              5i 0                                      value number
     d Vlen            s              5i 0                                      value length

     c                   eval      orHitDSp = orHitListP                        Original Hit list
     c                   eval      mlHitP   = mlHitListP                        MoreLinks Hit list
      * header
     c                   clear                   orHitDS
     c                   eval      mlHitDSp = mlHitP
     c                   if        mlHitDS <> *blanks and
     c                             mlHdrSiz = %size(mlHitDS)
      * process hits
     c                   dow       Hnbr < RtnHits and
     c                             Hnbr < %elem(orHits)
     c                   eval      Hnbr = Hnbr + 1
     c                   eval      mlHitDSp = mlHitP                            MoreLinks Hit list
     c                   if        mlHdrSiz = %size(mlHitDS)
     c                   eval      orHitHdr(Hnbr) = mlHitHdr                    Hit structure
     c                   eval      orValDSp = %addr(orValDta(Hnbr))
     c                   eval      mlHitP = mlHitP + %size(mlHitDS)             past hit struct
      * map index values
     c                   if        mlValCnt > 0
     c                   eval      Vlen = mlValLen / mlValCnt
     c                   eval      Vnbr = 0
     c                   dow       Vnbr < mlValCnt
     c                   eval      Vnbr = Vnbr + 1
     c                   if        Vnbr <= %elem(orVal)
     c                   eval      mlValDSp = mlHitP
     c                   eval      orVal(Vnbr) = %subst(mlVal:1:Vlen)           index value
     c                   end
     c                   eval      mlHitP = mlHitP + Vlen                       past hit data
     c                   enddo
     c                   end

     c                   end
     c                   enddo
     c                   end

     c                   return
     p                 e

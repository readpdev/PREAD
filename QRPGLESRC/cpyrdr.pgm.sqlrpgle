      *%METADATA                                                       *
      * %TEXT Copy folder's RptDirs, SpyLinks, Notes, etc              *
      *%EMETADATA                                                      *
J2415 /copy directives
      *
      *********-------------------------------------------
      * CPYRDR  Copy folder's RptDir, SpyLinks, notes, etc
      *********-------------------------------------------
      *         Also update the rpt hdr records of the SpyFolder
      *         to reflect the new report & SpyFolder name.
      *
J7203 * 08-14-17 PLR Fails to copy report from one folder to another. Added job
      *              scoping to the folder override and issue was corrected.
      *              Uncertain why this hasn't been a problem in the past.
J2415 * 02-16-10 PLR Extend parm list to include report type id so that the
      *              copy can occur for just one report. Change is part of
      *              the DOCCPYTYP utility. Added code to perform the copy of
      *              folder data and update of rptdir pointers.
/6708 * 10-21-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte binary.
      *              Remove access to MRPTDIR, use MRPTDIR1 instead.
      *              Change FILNUM (in MRPTDIR) to be the actual spool file number and
      *              change MRPTDIR1 key to include the spool file opened date.
/3765 * 02-28-01 DLS MODIFIED FOR NEW CHECK IN/OUT DATA BASE
      * 03-08-99 KAC INCREMENTAL FOLDER TOTALS UPDATE ON FOLDER COPY
      * 12-22-98 KAC USE NEW NOTES FILES
      * 10-20-98 JJF Don't put new Spy# (NREPIN) in new rpt hdr recs
      * 10-19-98 KAC COPY ANY AFP REPORT RESOURCE RECORDS
      * 10-05-98 JJF Put new Spy# (NREPIN) in new rpt hdr recs
      *  1-26-98 JJF Add parm 8 to Mag1070 call. Rmv Mag1036 call.
      *  8-08-95 DM  Output the correct Spy# in the copied rptdir rec
      *  6-16-95 JJF Call MAG901 for transaction logging
      *  2-13-95 DM  AddPFM SHARE(*NO)
      * 11-10-94 Dlm Change SDS library to sysdft data libr
      * 10-14-94 Dlm Copy apf folder db file
      *  9-19-94 Dlm Copy link index records and distribution
      *               history records for a rept type
      *---------------------------------------------------------------
     FFOLDER    UF A F  256        DISK    USROPN
/6708FMRPTDIR2  IF   E           K DISK    INFDS(FILEDS)
     F                                     RENAME(RPTDIR:RPTDIR2)
     FMFLDDIR   UF   E           K DISK
/6708FMRPTDIR1  UF A E           K DISK
     F                                     RENAME(RPTDIR:RPTDIR1)
J2415FMRPTDIR7  if   E           K DISK
     F                                     RENAME(RPTDIR:RPTDIR7)
     FMRPTRSC   UF A E           K DISK
     FRINDEX1   IF   E           K DISK
     F                                     RENAME(INDEXRC:INDEXRC1)
      *
     FRLNKDEF   IF   E           K DISK
     FRLNKNDX   IF A F  727    15AIDISK    KEYLOC(1)
     F                                     USROPN
     FRDSTHST   IF A E           K DISK
     FRMAINT    IF   E           K DISK
     FRSEGHDR   IF   E           K DISK
     FRSEGMNT   UF A E           K DISK    USROPN
     FMNOTDIR   IF A E           K DISK
     FMNOTDTA1  IF   E           K DISK    USROPN extdesc('MNOTDTA')
     F                                     RENAME(NOTDTA:NOTDTA1)
     FMNOTDTA2  O  A E           K DISK    INFDS(F2DS)
     F                                     USROPN extdesc('MNOTDTA')
     F                                     RENAME(NOTDTA:NOTDTA2)
      *
     D CMD             S             40    DIM(17) CTDATA PERRCD(1)             Over Command
      *
     D SYSDFT          DS          1024
     D  PGMLIB               296    305
     D  DTALIB               306    315
     D  MAXNFZ               783    787
     D FILEDS          DS
      *             RptDir file info
     D  RCDLEN               125    126B 0
     D  STS              *STATUS
      *
     D F2DS            DS
     D  F2RECS               156    159B 0
     D DSRCD1        E DS                  EXTNAME(MRPTDIR2)
      *             Fields from MRPTDIR
     D DSRCD2          DS           512
      *             Comp 1st access to 2nd
      *
     D DATA            DS           256
     D  NFOLD                  3     12
     D  NLIBR                 13     22
J2415d  pagPtr               113    116b 0
J2415d  endPtr               182    185b 0
J2415d  pakPtr               186    189b 0
J2415d  rptRec               190    193b 0
      *
     D #OVR1           C                   CONST('OVRDBF FILE(')
     D #OVR2           C                   CONST(') TOFILE(')
     D #DUP1           C                   CONST('CRTDUPOBJ -
     D                                     OBJ(MNOTDTA) -
     D                                     FROMLIB(')
     D #DUP2           C                   CONST(') OBJTYPE(*FILE) -
     D                                     TOLIB(')
     D #DUP3           C                   CONST(') NEWOBJ(')
     D #DUP4           C                   CONST(') DATA(*NO)')
      *
     D CRTFLA          C                   CONST('CRTFLDAPF')
     D CHKEX           C                   CONST('CHKEXSNDXM')
      *
J2415d singleCopy      s               n   inz('0')
J2415d copyFolderData  pr            10i 0
J2415d OK              c                   0
J2415d ERROR           c                   -1
J2415d docTotalRecs    s             10u 0

     IRLNKNDX   IF
     I                                  1  256  P1
     I                                257  512  P2
     I                                513  727  P3
      *
     C     *ENTRY        PLIST
     C                   PARM                    OLDFLD           10            Old Folder
     C                   PARM                    OLDLIB           10                Libr
     C                   PARM                    NEWFLD           10            New Folder
     C                   PARM                    NEWLIB           10                Libr
     C                   PARM                    RTNCDE            8            Return code
J2415c                   parm                    rptID            10            Report ID

J2415 /free
J2415  if %parms > 5;
J2415    singleCopy = '1';
J2415  endif;
J2415 /end-free

      * Open new folder
     C     CMD(1)        CAT(P)    'FOLDER':0    CMDLIN                         OvrDBF
     C                   CAT       ')':0         CMDLIN
     C                   CAT       CMD(2):1      CMDLIN
     C                   CAT       NEWLIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       NEWFLD:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLIST0
     C                   OPEN      FOLDER                               20      Open
J2415 /free
       if *in20;
         rtnCde = 'OPNFLD';
         exsr quit;
       endif;
      /end-free
      *
     C                   EXSR      COPY
      *
     C                   MOVE      'GOOD    '    RTNCDE                         Return code
     C                   EXSR      QUIT
      *
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     COPY          BEGSR
      *          Copy indices, postits, SpyLinks, DstHst, PartPg, APF.
      *
     C                   Z-ADD     0             ONLIN             9 0          ONLINE
     C                   Z-ADD     0             OFFLIN            9 0          OPTICAL
     C                   Z-ADD     0             ONOPT             9 0          Tape
     C     KLOLDF        SETLL     MRPTDIR2
     C     KLOLDF        KLIST
     C                   KFLD                    OLDFLD
     C                   KFLD                    OLDLIB
      *
      * Read each RptDir rec for the old folder
     C                   DO        *HIVAL
J2415 /free
J2415  if singleCopy;
J2415    chain rptID rptdir7;
J2415    if not %found;
J2415      rtnCde = 'NRFDIR'; // No record found for id. Return error.
J2415      exsr quit;
J2415    endif;
J2415  else;
      /end-free
     C     KLOLDF        READE     MRPTDIR2                               99
J2415C                   endif
     C   99              LEAVE

      // Try to copy folder content for single copy before doing anything else.
J2415 /free
J2415  if singleCopy;
J2415    if copyFolderData() = ERROR;
J2415      exsr quit;
J2415    endif;
J2415  endif;
J2415 /end-free

     C                   MOVEL     DSRCD1        DSRCD2
     C                   MOVE      NEWFLD        FLDR
     C                   MOVE      NEWLIB        FLDRLB
     C                   MOVE      REPIND        OREPIN                         Spy#
     C                   CLEAR                   REPIND
     C                   MOVEL     'GETQWT'      GNOC                           GET&QUIT
     C                   MOVEL(P)  'REPIND'      GNGT
     C                   CALL      'GETNUM'
     C                   PARM                    GNOC              6            OPCODE
     C                   PARM                    GNGT             10            GETTYP
     C                   PARM                    REPIND           10            RTNVAL
      * Copy:
     C                   EXSR      CPYIND                                       StdINDEXmbrs
     C                   EXSR      CPYNOT                                       Notes
     C                   EXSR      CPYLNK                                       Spylinks
     C                   EXSR      CPYHST                                       DstHst
     C                   EXSR      CPYPPT                                       Prtl Pg tbls
     C                   EXSR      CPYRSC                                       RPT RESOURCE
     C     APFTYP        IFNE      *BLANK
     C                   EXSR      CPYAPF                                       Apf files
     C                   END
      *
      * Write new RptDir record
     C                   MOVE      REPIND        SREPIN                         Spy#
     C     KLRDIR        CHAIN     RPTDIR1                            20
     C     *IN20         IFEQ      *ON
      *
      * Move old record to current data structure and update.
      * Restore new repind
      * Update the 0 record with the folder & library values.
      * Perform update to include new data.
      *
     C                   MOVEL     DSRCD2        DSRCD1
     C                   MOVE      SREPIN        REPIND                         Spy#
     C                   MOVE      NEWFLD        FLDR
     C                   MOVE      NEWLIB        FLDRLB
     C                   WRITE     RPTDIR1                              20      Upd new rcd
     C                   SELECT
     C     REPLOC        WHENEQ    *BLANK
     C     REPLOC        OREQ      '0'
     C     REPLOC        OREQ      '5'                                          R/DARS QDLS
     C                   ADD       1             ONLIN                          Numfil
     C     REPLOC        WHENEQ    '1'
     C                   ADD       1             OFFLIN                         Numoff
     C     REPLOC        WHENEQ    '2'
     C     REPLOC        OREQ      '4'                                          R/DARS OPTICAL
     C     REPLOC        OREQ      '6'                                          IMAGEVIEW OPTICAL
     C                   ADD       1             ONOPT                          Numfil
     C                   ENDSL
      *
     C     ONLIN         IFGT      100                                          PERIODIC UPDATE
     C     OFFLIN        ORGT      100
     C     ONOPT         ORGT      100
     C                   EXSR      TOTRPT                                       FOLDER TOTALS
     C                   END
      *
     C                   MOVE      *BLANK        DLSEG
     C                   CALL      'MAG901'      PLM901                 81      Trans logger
      *
     C     REPLOC        IFEQ      '0'
     C     REPLOC        OREQ      ' '
     C                   EXSR      @UPD0
     C                   END
     C                   END
J2415 /free
J2415  if singleCopy;
J2415    leave;
J2415  endif;
J2415 /end-free
     C                   ENDDO
     C                   EXSR      TOTRPT                                       FOLDER TOTALS
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @UPD0         BEGSR
      *          Update the 0 record for each report being copied.
      *            The folder and library values may have changed.
      *            Read previous rec to get folder rebuild rec.
      *
     C                   MOVE      LOCSFA        RR#               9 0
     C     RR#           SETLL     FOLDER
     C                   READP     FOLDER        DATA                     99
     C                   MOVE      NEWLIB        NLIBR
     C                   MOVE      NEWFLD        NFOLD
J2415 /free
J2415  if singleCopy;
J2415    pagPtr = locsfp;
J2415    endPtr = (locsfa-1) + docTotalRecs;
J2415    pakPtr = locsfc;
J2415  endif;
J2415 /end-free
     C                   UPDATE    FOLDER        DATA
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CPYIND        BEGSR
      *          Copy Index Members
      *
     C     KLBIG5        SETLL     RINDEX1
     C     *IN50         DOUEQ     *ON
     C     KLBIG5        READE     RINDEX1                                50     Read EQ
     C   50              LEAVE
     C     IDBFIL        IFNE      *BLANKS
     C                   EXSR      @CHKI                                        I Exists?
     C     IEXIST        CASEQ     ' '           @CPYIM                         Copy Member
     C                   ENDCS
     C                   END
     C                   ENDDO
     C                   ENDSR
      *$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CPYIM        BEGSR
      *          Copy Index Member
     C                   CALL      'CPYINDM'
     C                   PARM                    IDBFIL
     C                   PARM                    OREPIN                         Old Spy#
     C                   PARM                    REPIND                         New Spy#
     C                   PARM                    RETN              1
     C                   ENDSR
      *$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     @CHKI         BEGSR
      *          Check if Report Index Exists
      *
     C     REPIND        IFNE      *BLANKS                                      Spy#
     C     IDBFIL        ANDNE     *BLANKS
     C                   CALL      CHKEX
     C                   PARM                    IDBFIL                         Index Name
     C                   PARM                    DTALIB                         SpyLibr
     C                   PARM                    OREPIN                         Spy#
     C                   PARM                    IEXIST            1            Return
      * Else Member name is blank
     C                   ELSE
     C                   MOVE      'N'           IEXIST
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CPYNOT        BEGSR
      *
      * COPY NOTES
     C     OREPIN        CHAIN     NOTDIR                             50
     C     *IN50         DOWEQ     *OFF
      *
      * NOTES DATA
     C                   MOVEL     NDATFL        NFILE                          ASSIGNED NOTES FILE
     C     NDATFL        IFNE      *BLANKS
      *
      * SETUP NOTES DATA FILES
     C                   MOVEL     'MNOTDTA1'    NFILEX            8
     C                   EXSR      $OVRN
     C                   OPEN      MNOTDTA1
     C                   MOVEL(P)  'PEEK'        GNOC                           GET CURRENT
     C                   EXSR      $GETN
     C                   MOVEL     'MNOTDTA2'    NFILEX
     C                   EXSR      $OVRN
     C                   OPEN      MNOTDTA2
     C     F2RECS        IFGE      MAXREC                                       ALL FILLED UP
     C                   CLOSE     MNOTDTA2
     C                   MOVEL(P)  'GET'         GNOC                           GET NEW FILE
     C                   EXSR      $GETN
     C                   EXSR      $OVRN
     C                   OPEN      MNOTDTA2
     C                   END
      *
      * COPY NOTES DATA
     C     KNDTA1        CHAIN     NOTDTA1                            51
     C     *IN51         DOWEQ     *OFF
     C                   MOVEL     REPIND        NABNUM                         NEW Spy#
     C                   WRITE     NOTDTA2
     C     KNDTA1        READE     NOTDTA1                                51
     C                   ENDDO
      *
     C                   CLOSE     MNOTDTA1
     C                   CLOSE     MNOTDTA2
     C                   END
      *
     C                   MOVEL     REPIND        NDBNUM                         NEW Spy#
     C                   MOVEL     NFILE         NDATFL                         ASSIGNED NOTES FILE
     C                   WRITE     NOTDIR
     C     OREPIN        READE     NOTDIR                                 50
     C                   ENDDO
      *
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CPYLNK        BEGSR
      *          Copy the spylink records in the spylink file
      *
     C     KLBIG5        CHAIN     LNKDEF                             66
     C     *IN66         IFEQ      *OFF
     C                   CALL      'MAG1036'
     C                   PARM                    ERRMSG           80
     C                   PARM                    DTALIB
     C                   PARM                    LNKFIL
     C                   PARM      '*FILE'       APITYP           10
      *
     C     ERRMSG        IFEQ      *BLANKS
     C                   MOVEL(P)  'RLNKNDX'     FILENM           10
     C     CMD(1)        CAT(P)    FILENM:0      CMDLIN                         OvrDBF
     C                   CAT       ')':0         CMDLIN
     C                   CAT       CMD(2):1      CMDLIN
     C                   CAT       DTALIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       LNKFIL:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLIST0
      *
     C                   OPEN      RLNKNDX
     C     OREPIN        SETLL     RLNKNDX                                66     Spy#
     C     *IN66         IFEQ      *ON
     C                   READ      RLNKNDX                                66
     C     *IN66         DOWEQ     *OFF
     C                   MOVEL     REPIND        P1
     C                   EXCEPT    OUTLNK
     C     OREPIN        READE     RLNKNDX                                66
     C                   END
     C                   END
      *
     C                   CLOSE     RLNKNDX
     C     CMD(10)       CAT(P)    FILENM:0      CMDLIN                         DltOvr
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLIST0
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CPYHST        BEGSR
      *          Copy the distribution history (RDSTHST) recs.
      *
     C     OREPIN        SETLL     DSTHST                                 66     Spy#
     C     *IN66         IFEQ      *ON
     C                   READ      DSTHST                                 66
     C     *IN66         DOWEQ     *OFF
     C                   MOVEL     REPIND        DHREP
     C                   WRITE     DSTHST
     C     OREPIN        READE     DSTHST                                 66
     C                   END
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CPYPPT        BEGSR
      *          Copy partial page table members
      *
     C     KLBIG5        CHAIN     RMAINT                             66
     C     RTYPID        SETLL     SEGHDR                                 66
     C     *IN66         IFEQ      *ON
     C                   DO        *HIVAL
     C     RTYPID        READE     SEGHDR                                 66
     C   66              LEAVE
      *
     C     SHSFIL        IFEQ      *BLANKS
     C                   ITER
     C                   END
      *
     C     CMD(17)       CAT(P)    DTALIB:0      CMDLIN                         Ovrdbf
     C                   CAT       '/':0         CMDLIN                         Rsegmnt
     C                   CAT       SHSFIL:0      CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLIST0                 81
     C   81              ITER
      *
     C                   OPEN      RSEGMNT                              81
     C     *IN81         IFEQ      *ON
     C                   MOVEL(P)  'RSEGMNT'     FILENM
     C     CMD(10)       CAT(P)    FILENM:0      CMDLIN                         DltOvr
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLIST0                 81
     C                   ITER
     C                   END
      *
     C                   MOVE      OREPIN        SGREP                          Spy#
     C                   Z-ADD     1             SGSEQ
     C     SMNTKY        SETLL     RSEGMNT
     C     SMNTKY        KLIST
     C                   KFLD                    SGREP
     C                   KFLD                    SGSEQ
      *
     C     *IN81         DOUEQ     *ON
     C     OREPIN        READE     SEGREC                                 81
     C     *IN81         IFNE      *ON
     C                   MOVE      REPIND        SGREP
     C                   WRITE     SEGREC
     C                   END
     C                   ENDDO
      *
     C                   CLOSE     RSEGMNT
      *
     C                   MOVEL(P)  'RSEGMNT'     FILENM
     C     CMD(10)       CAT(P)    FILENM:0      CMDLIN                         DltOvr
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLIST0                 81
      *
     C                   MOVE      SHSEG         DLSEG                          Segment
     C                   CALL      'MAG901'      PLM901                 81      Trans logger
     C                   ENDDO
     C                   END
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CPYRSC        BEGSR
      *
      * COPY ANY RESOURCE RECORDS
     C     OREPIN        CHAIN     RPTRSC                             66
     C     *IN66         DOWEQ     *OFF
     C                   MOVEL     REPIND        RRSPYN                         Spy#
     C                   WRITE     RPTRSC
     C     OREPIN        READE     RPTRSC                                 66
     C                   ENDDO
      *
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CPYAPF        BEGSR
      *          Copy APF Data and Page table files (A and AP files)
      *
      * If any of the following do not exist, create:
      *    1) SpyFolder   2) Afile (APF data)   3) APfile (PgTbl)
      *
     C     DIDAPF        IFNE      'Y'                                          Once PerFldr
     C                   CALL      CRTFLA                                       Crt files
     C                   PARM                    APFNAM
     C                   PARM                    NEWLIB
     C                   PARM                    NEWFLD
     C                   PARM                    CRTRTN            1
     C     CRTRTN        IFEQ      *ON                                          Could not
     C                   EXSR      QUIT                                         create
     C                   END
     C                   MOVE      'Y'           DIDAPF            1
     C                   END
      *
     C                   CALL      'MAG1070'     PL1070                         Copy APF
     C     PL1070        PLIST
     C                   PARM      'C'           @OPER             1             (C)opy
     C                   PARM                    OLDAPF                          From Fldr
     C                   PARM                    OLDLIB                               Libr
     C                   PARM                    OREPIN                               Spy#
     C                   PARM                    APFNAM                            To Fldr
     C                   PARM                    NEWLIB                               Libr
     C                   PARM                    REPIND                               Spy#
     C                   PARM                    DN1070            1             M1070 up
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  SYSDFT                         Get System
     C                   IN        SYSDFT                                       Defaults
     C     DTALIB        IFEQ      *BLANKS
     C                   MOVEL     'SPYGLASS'    DTALIB
     C                   END
      *
      * MAX NOTE FILE SIZE (MB)
     C     MAXNFZ        IFEQ      *BLANKS
     C     MAXNFZ        OREQ      *ZEROS
     C                   MOVE      '00100'       MAXNFZ                         DFT 100 MB
     C                   END
     C                   Z-ADD     0             MAXREC            9 0
     C                   MOVE      MAXNFZ        MAXREC
     C                   MULT      1000          MAXREC
      *
     C     *LIKE         DEFINE    REPIND        OREPIN
     C     *LIKE         DEFINE    REPIND        SREPIN
     C                   MOVE      *BLANKS       RTNCDE
      *------------------------------------
      * Get old & new folder directory recs
      *------------------------------------
     C                   MOVE      OLDFLD        FLDR
     C                   MOVE      OLDLIB        FLDRLB
     C     FLDKEY        CHAIN(N)  FLDDIR                             66
     C     FLDKEY        KLIST
     C                   KFLD                    FLDR
     C                   KFLD                    FLDRLB
     C                   MOVE      APFNAM        OLDAPF           10
     C                   MOVE      NEWFLD        FLDR
     C                   MOVE      NEWLIB        FLDRLB
     C     FLDKEY        CHAIN(N)  FLDDIR                             66
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
      *
     C     DIDAPF        IFEQ      'Y'                                          Shutdown
     C                   MOVE      'Y'           DN1070
     C                   CALL      'MAG1070'     PL1070                          Mag1070
     C                   END
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     TOTRPT        BEGSR
      * UPDATE FOLDER TOTALS
      *
     C     FLDKEY        CHAIN     FLDDIR                             66
     C     *IN66         IFEQ      *OFF
     C                   ADD       ONLIN         NUMFIL                         DASD
     C                   ADD       ONOPT         NUMOPT                         Optic
     C                   ADD       OFFLIN        NUMOFF                         Offline
     C                   UPDATE    FLDDIR
     C                   END
     C                   Z-ADD     0             ONLIN             9 0          ONLINE
     C                   Z-ADD     0             OFFLIN            9 0          OPTICAL
     C                   Z-ADD     0             ONOPT             9 0          Tape
      *
     C                   ENDSR
      * ------------------------------------------------- *
      * GET NEXT NOTE FILE NAME                           *
      * ------------------------------------------------- *
     C     $GETN         BEGSR
      *
     C                   MOVEL(P)  'NOTES'       GNGT
     C                   MOVE      *BLANKS       GNRV
      *
      * JOHN'S GET NUMBER FOR FILE NAMES ROUTINE
     C                   CALL      'GETNUM'
     C                   PARM                    GNOC              6            OPCODE
     C                   PARM                    GNGT             10            GETTYP
     C                   PARM                    GNRV             10            RTNVAL
      *
     C                   MOVEL     GNRV          NFILE            10
      *
     C                   ENDSR
      * ------------------------------------------------- *
      * OVERRIDE NOTES FILE                               *
      * ------------------------------------------------- *
     C     $OVRN         BEGSR
      *
      * CHECK NOTES FILE
     C                   CALL      'MAG1036'
     C                   PARM                    ERRMSG           80
     C                   PARM                    DTALIB
     C                   PARM                    NFILE
     C                   PARM      '*FILE'       APITYP           10
     C     ERRMSG        IFNE      *BLANKS                                      ERROR
      * CREATE NEW MNOTDTA FILE
     C     #DUP1         CAT(P)    PGMLIB:0      CMDLIN                         Crt Dup Obj
     C                   CAT       #DUP2:0       CMDLIN                         SPY00*
     C                   CAT       DTALIB:0      CMDLIN
     C                   CAT       #DUP3:0       CMDLIN
     C                   CAT       NFILE:0       CMDLIN
     C                   CAT       #DUP4:0       CMDLIN
     C                   CALL      'MAG1030'
     C                   PARM                    CRTRTN            1
     C                   PARM      DTALIB        CRTLIB           10
     C                   PARM      NFILE         CRTOBJ           10
     C                   PARM      '*FILE'       CRTTYP           10
     C                   PARM                    CMDLIN          255
     C                   END
      *
      * OVERRIDE MNOTDTA TO NOTES FILE
     C     CMD(1)        CAT(P)    NFILEX:0      CMDLIN                         OvrDBF
     C                   CAT       ')':0         CMDLIN
     C                   CAT       CMD(2):1      CMDLIN
     C                   CAT       DTALIB:0      CMDLIN
     C                   CAT       '/':0         CMDLIN
     C                   CAT       NFILE:0       CMDLIN
     C                   CAT       ')':0         CMDLIN
     C                   CALL      'QCMDEXC'     PLIST0
      *
     C                   ENDSR
      *
     C     KLRDIR        KLIST
     C                   KFLD                    FLDR                           Folder
     C                   KFLD                    FLDRLB                         Libr
     C                   KFLD                    FILNAM                          File
     C                   KFLD                    JOBNAM                          Job
     C                   KFLD                    USRNAM                          User
     C                   KFLD                    JOBNUM                           Job#
     C                   KFLD                    FILNUM                           File#
     C                   KFLD                    DATFOP                          date spool file opened
     C     KLBIG5        KLIST
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    PGMOPF
     C                   KFLD                    USRNAM
     C                   KFLD                    USRDTA
      *
     C     PLIST0        PLIST
     C                   PARM                    CMDLIN          255
     C                   PARM      255           CHO1A            15 5
     C     PLM901        PLIST
     C                   PARM                    LOGRTN            1            return code
     C                   PARM      *BLANK        DLSUB            10            subscriber
     C                   PARM      RTYPID        DLREPT           10            report type
     C                   PARM                    DLSEG            10            segment
     C                   PARM      OREPIN        DLREP            10            report name
     C                   PARM      *BLANK        DLBNDL           10            bundle
     C                   PARM      'C'           DLTYPE            1            (C)opy
     C                   PARM      TOTPAG        DLTPGS            9 0          pages
     C                   PARM      'CPYRDR'      DLPROG           10
      *
     C     KNDTA1        KLIST
     C                   KFLD                    NDBNUM
     C                   KFLD                    NDBSEQ
     C                   KFLD                    NDPAGN
     C                   KFLD                    NDNOTN
/3765C                   KFLD                    NDREVI
     ORLNKNDX   EADD         OUTLNK
     O                       P1                 256
     O                       P2                 512
     O                       P3                 727

      * Copy the folder data for single report copy request.
J2415p copyFolderData  b
     d                 pi            10i 0
     d/copy QSYSINC/QRPGLESRC,QUSEC
     d/copy QSYSINC/QRPGLESRC,QUSRMBRD
     d RtvMbrD         pr                  extpgm('QUSRMBRD')
     d  Rcvr                               likeds(QUSM0200)
     d  RcvrLen                      10i 0 const
     d  FmtName                       8    const
     d  FileName                     20    const
     d  MbrName                      10    const
     d  OvrProc                       1    const
     d  ErrMsg                             like(qusec)
     d run             pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)
     d srcFld        e ds                  extname(DFTFOLDER)
     d rrnPos          s             10u 0
      /free
       exec sql set option closqlcsr=*endactgrp,commit=*none,srtseq=*langidshr;
       // Get the total number of records in the target folder.
       clear qusm0200;
       clear qusec;
       qusbprv = %size(qusec);
       rtvMbrD(qusm0200:%size(qusm0200):'MBRD0200':newFld + newLib:
         '*FIRST':'0':qusec);
       if qusbavl > 0;
         rtnCde = 'RTVMBRD';
         return ERROR;
       endif;
       // Lock the folder for serialized access.
       if run('ALCOBJ OBJ(( ' + %trimr(newlib) + '/' + %trimr(newfld) +
         ' *FILE *EXCL))') <> 0;
         rtnCde = 'ALCOBJ';
         return ERROR;
       endif;
       // Get end record field from header of source folder.
J7203  run('ovrdbf srcFld ' + %trimr(oldlib) + '/' + %trimr(oldfld) +
J7203    ' ovrscope(*job)');
       rrnPos = locsfa - 1;
       exec sql select * into :srcFld from srcFld where rrn(srcFld) = :rrnPos;
J7203  run('dltovr srcFld lvl(*job)');
       if sqlcod <> OK;
         rtnCde = 'SRCHDR';
         exsr dlcTgtFld;
         return ERROR;
       endif;
       data = srcFld;
       // Copy folder data from locsfa-1 to the pack table offset (locsfc) and
       // then move the remainder from locsfp+1 to end of file or next document
       // encountered. (record type = '0')
       if run('cpyf fromfile(' + %trimr(oldlib) + '/' + %trimr(oldfld) + ') ' +
         'tofile(' + %trimr(newlib) + '/' + %trimr(newfld) + ') mbropt(*add) ' +
         'fromrcd(' + %trim(%editc(locsfa-1:'Z')) + ') torcd(' +
         %trimr(%editc(endPtr:'Z')) + ') fmtopt(*nochk)') <> OK;
         rtnCde = 'CPYFLD';
         return ERROR;
       endif;
       exsr dlcTgtFld;
       if rtnCde <> ' ';
         return ERROR;
       endif;
       docTotalRecs = endPtr - (locsfa-1) + 1;
       // Set the pointers for the copied data.
       locsfd = qusnbrcr + 2 + (locsfd - locsfa);
       locsfp = qusnbrcr + 2 + (locsfp - locsfa);
       locsfc = qusnbrcr + 2 + (locsfc - locsfa);
       locsfa = qusnbrcr + 2;
       return OK;

       begsr dlcTgtFld;
         run('DLCOBJ OBJ(( ' + %trimr(newlib) + '/' + %trimr(newfld) +
           ' *FILE *EXCL))');
       endsr;
      /end-free
     p                 e

** CMD   Command line text                                           10
OVRDBF FILE(                            1
TOFILE(                                 2
SHARE(*NO)                              3
DLTF FILE(                              4
RNMOBJ OBJ(                             5
OBJTYPE(*FILE)                          6
NEWOBJ(                                 7
ALCOBJ OBJ((                            8
*FILE *EXCL)) WAIT(0)                   9
DLTOVR FILE(                            10
CPYF MBROPT(*REPLACE) FROMFILE(         11
FROMMBR(                                12
TOMBR(                                  13
                                        14
ADDPFM SHARE(*NO) FILE(                 15
) FMTOPT(*NOCHK)                        16
OVRDBF FILE(RSEGMNT) MBR(*FIRST) TOFILE(17

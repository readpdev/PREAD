      *%METADATA                                                       *
      * %TEXT Move a report to another folder                          *
      *%EMETADATA                                                      *
     h bnddir('SPYBNDDIR')
/     /copy directives

      *********------------------------------
      * MOVRDR  Move report to another folder
      *********------------------------------
      *
J2372 * 06-18-10 EPG Inhibit moving files to the folder if
/     *              the target folder contains deleted records.
J2416 * 02-23-10 PLR Overload for use with DOCMOVTYP command.
/5178 * 04-16-07 EPG Do not depend on the MFLDDIR to contain the
/5178 *              correct number of records. Instead, use the
/5178 *              existing file information data structure to
/5178 *              test for this information. In this way,
/5178 *              the reliance on the integrity of the MFLDDIR
/5178 *              is avoided, and the actual number or records
/5178 *              are checked instead.
/5178 * 03-26-07 EPG Move the code that checks for the resulting
/5178 *              file size as being correct.
/5178 * 01-18-07 EPG Inhibit the copying of one report to another
/5178 *              folder if the target folder exceeds or is
/5178 *              equal to the default folder threshold.
/5635 *  2-25-04 JMO Added HIPAA logging support for moving a report
/6708 * 10-21-03 JMO Add support for 6 digit spool file numbers.
      *              Also, standardize spool file nbr parms - always 4 byte binary.
      *              Remove access to MRPTDIR, use MRPTDIR1 instead.
      *              Change FILNUM (in MRPTDIR) to be the actual spool file number and
      *              change MRPTDIR1 key to include the spool file opened date.
/3715 * 01-08-01 KAC Move of R/DARS reports not working.
/1452 * 10-31-00 JAM PREVENT LOSS OF SCREEN DATA ON HELP.
/2670 *  6-09-00 DLS Maintain integrity of RRN of Pack Table after
/2670 *              report is moved to another folder.  If no table
/2670 *              exists the RRN should remain at 0 after move.
/2670 *              Program was setting number as a "-" negative.
      *  5-26-98 JJF 5-27-98 JJF Call GETNUM to assign an AFile name
      *  2-27-98 kac add support for imageview type reports
      *  2-17-98 JJF Process error returned from CRTFLD
      *  2-04-98 kac add support for r/dars type reports
      * 12-06-96 JJF Add Personal Help.
      *  6-05-96 PAF Update new Optical Counters
      * 12-12-95 PAF Add cond. indicator to open input File stmt
      *  9-10-95 DM  Move optical reports to folders that don't CRT 34
      *  6-16-95 JJF Call MAG901 for transaction logging.
      *  2-13-95 dm  addpfm share(*no)
      *
J2416FMOVRDRFM  CF   E             WORKSTN INFDS(INFDS) usropn
     FMFLDDIR   UF A E           K DISK
     FMrptdir7  IF   E           K DISK    rename(rptdir:rptdir7)
     FMRPTDIR1  UF A E           K DISK
     FMRPTDES   UF   E           K DISK
     F#INPUT#   IF   F  256        DISK    USROPN
     F#OUTPUT#  O    F  256        DISK    INFDS(#INP)
     F                                     USROPN
/2372 * ProtoTypes -------------------------------------------------
/     /include qrpglesrc,@mmmsgio
/     /include qrpglesrc,@mapfio

/5178d Command         pr                  ExtPgm('QCMDEXC')
/5178d  pCommand                   3000a   options(*varsize) const
/5178d  pSize                        15  5 Const
/5178d  pCmdOpt                       3    Options(*nopass) Const

/5635
/5635 * Prototypes for HIPAA logging service program
/5635 /copy @mlaudlog
/5635
/5635d LogDS           ds                  inz
/5635 /copy @mlaudinp
/5635
/5635 * Build audit log entry
/5635d BldLogEnt       pr
/5635d SpyNbr                        10a   value
/5635d FrmFld                        10a   value
/5635d FrmFldLib                     10a   value
/5635d ToFld                         10a   value
/5635d ToFldLib                      10a   value

/2372 * Constants ------------------------------------------------------------
/    d TRUE            c                   '1'
/    d FALSE           c                   '0'


     D CL              S             79    DIM(4) CTDATA PERRCD(1)
/5178d SYSDFT          DS          1024
/5178 *  SpyView Sysenv
/5178d  FLDTHR               198    200
/5178dintMoveResult    s             10u 0 inz(*zero)
/5178 * Folder Threshold
/5178dintFldThr        s             10u 0 inz(*zero)
/5178dintFldScaler     s             10u 0 inz(1000000)
      * Folder multiplier
/5178dintFldOffSet     s             10u 0 inz(*zero)
      * Folder Offset
/5178dMAXFLDTHR        s             10u 0 inz(999999999)
     D               ESDS                  EXTNAME(CASPGMD)
     D                 DS
     D  @FLDR                  3     12
     D  @FLDRL                13     22
     D  @LCSFA               105    108B 0
     D  @LCSFD               109    112B 0
     D  @LCSFP               113    116B 0
     D  @LCSFE               182    185B 0
     D  @LCSFC               186    189B 0
     D  RECDAT                 1    256
     D #INP            DS
     D  BGREC                156    159B 0
     D INFDS           DS
     D  KEY                  369    369
     D  CSRLOC               370    371B 0
     D  SFLZ                 378    379B 0
     D  WINLOC               382    383B 0

      *              For api error code parameter             2 - 9
     D ERRCD           DS           116
     D  @MSGID                 9     15
     D  @ERDTA                17    116
     D FILNM#          DS
     D  FILNUM                 1      4B 0

     D #MSGF           C                   CONST('PSCON     *LIBL     ')
     D CRTFLA          C                   CONST('CRTFLDAPF')
     D F3              C                   CONST(X'33')
     D F4              C                   CONST(X'34')
     D F12             C                   CONST(X'3C')
     D HELP            C                   CONST(X'F3')

J2416d massMove        s               n   inz('0')

     I#INPUT#   NS  01
     I                                  1  256  RECDAT
     I                             B  182  185 0LOCSFE

     C     *ENTRY        PLIST
     C                   PARM                    REPIND
     C                   PARM                    RTNKEY            1
     C                   PARM                    OUTRPT
     C                   PARM                    OUTLIB
J2416c                   parm                    msgTxt

J2416 /free
       if %parms = 5;
         massMove = '1';
       else;
         open movrdrfm;
       endif;
      /end-free


/5178 *    Capture folder threshold
/5178c     *dtaara       define                  SYSDFT                         Get Threshold
/5178c                   in        sysdft

/5178c                   If        FldThr = *blanks
/5178c                   Eval      intFldThr = MAXFLDTHR
/5178c                   ElseIf    FldThr <> *blanks
/5178c                   Eval      intFldThr = (%int(fldThr) * intFldScaler)
     c                             + intFldOffset
/5178c                   EndIf

/6708C     repind        chain(e)  rptdir7
     c                   if        not %found
     c                   move      *blanks       action                          old report
     c                   move      *blanks       @erdta                          missing.
     c                   move      'EMR0003'     @msgid
     c                   call      'MAG1033'     @parm1
     c                   movel     msgtxt        errmsg
J2416c                   exsr      massMoveSR
/6708c                   endif

     C     FLDKEY        KLIST
     C                   KFLD                    FOLDER           10
     C                   KFLD                    LIBRAR           10

      * Does the prompt screen need to be displayed ?

     C                   Z-ADD     0             PROMPT            1 0
     C     OUTRPT        IFEQ      *BLANKS
     C                   MOVE      FLDR          OUTRPT                         Yes
     C                   MOVE      FLDRLB        OUTLIB
     C                   ELSE
     C                   Z-ADD     1             PROMPT                         No
     C                   END

     C                   MOVE      FLDR          HFLDR            10
     C                   MOVE      FLDRLB        HFLDRL           10
     C                   MOVE      *BLANKS       ERRMSG

     C                   MOVE      HFLDR         FOLDER                         Old Folder
     C                   MOVE      HFLDRL        LIBRAR
     C     FLDKEY        CHAIN(N)  FLDDIR                             66
     C     FLDLOC        IFEQ      '1'
     C                   MOVE      *BLANKS       ACTION                         Source
     C                   MOVE      *BLANKS       @ERDTA                         off-line
     C                   MOVE      'EMR0005'     @MSGID
     C                   CALL      'MAG1033'     @PARM1
     C                   MOVEL     MSGTXT        ERRMSG
J2416c                   exsr      massMoveSR
     C                   END
      *------------
      * Loop until valid input is entered or cmd-3 or cmd-12
      *------------
     C     *INLR         DOWEQ     *OFF
     C                   MOVE      HFLDR         FLDR
     C                   MOVE      HFLDRL        FLDRLB
      *>>>>
     C     GETNAM        TAG
     C     PROMPT        IFEQ      0
      *                 |---------------|
     C                   EXFMT     MOVDSP
      *                 |---------------|
      * Help
/1452C     KEY           DOWEQ     HELP
     C                   MOVEL(P)  'MOVDSP'      HLPFMT
     C                   CALL      'SPYHLP'      PLHELP
     C     PLHELP        PLIST
     C                   PARM      'MOVRDRFM'    DSPFIL           10
     C                   PARM                    HLPFMT           10
/1452C                   MOVE      *IN99         #IN99             1
/1452C                   READ      MOVDSP                                 99
/1452C                   MOVE      #IN99         *IN99
     C*/1452               GOTO GETNAM
/1452C                   ENDDO

     C                   CLEAR                   WINLIN
     C                   CLEAR                   WINPOS
     C                   MOVE      KEY           RTNKEY
     C                   END

     C     KEY           IFEQ      F3                                           Exit
     C     KEY           OREQ      F12                                          Cancel
     C                   MOVE      KEY           RTNKEY
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   END

     C     RTNKEY        IFEQ      F4
     C                   EXSR      SRF4
     C                   GOTO      GETNAM
     C                   END

     C                   MOVE      HFLDR         FOLDER
     C                   MOVE      HFLDRL        LIBRAR
     C     FLDKEY        CHAIN(N)  FLDDIR                             66
     C     FLDLOC        IFEQ      '1'                                          Error,
     C                   MOVE      *BLANKS       ACTION                          old folder
     C                   MOVE      *BLANKS       @ERDTA                          missing.
     C                   MOVE      'EMR0005'     @MSGID
     C                   CALL      'MAG1033'     @PARM1
     C                   MOVEL     MSGTXT        ERRMSG
     C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
     C                   ITER
     C                   END

      *    Check for a valid system value of the folder threshold

/5178c                   If        intFldThr = *zero
/5178C                   MOVE      *BLANKS       ACTION                          System
/5178C                   MOVE      *BLANKS       @ERDTA                          Folder
/5178C                   MOVE      'EMR0006'     @MSGID                          Threshold
/5178C                   CALL      'MAG1033'     @PARM1                          not set
/5178C                   MOVEL     MSGTXT        ERRMSG
/5178C                   Z-ADD     0             PROMPT
J2416C                   exsr      massMoveSR
/5178c                   Iter
/5178c                   EndIf

/5178C                   Move      OUTRPT        FOLDER
/5178C                   Move      OUTLIB        LIBRAR

      *    Check for the target folder exceeding
      *    the current system threshold

/5178C     FldKey        Chain(n)  MFldDir

/5178c                   If        %found
/5178c                   Eval      ClCmd =
/5178c                             'OVRDBF FILE(#OUTPUT#) ' +
/5178c                             'TOFILE(' +
/5178c                             %trim(OUTLIB) + '/' +
/5178c                             %trim(OUTRPT) + ')'
/5178c                   Callp(e)  Command(%trim(clCmd):
/5178c                              %len(%trim(clCmd)))

/5178c                   If        NOT %open(#OUTPUT#)
/5178c                   Reset                   #inp
/5178c                   Open(e)   #OUTPUT#
/5178c                   EndIf

/5178c                   If        %error
/5178c                   EndIf

/5178c                   Close(e)  #OUTPUT#
/5178c                   Eval      clCmd =
/5178c                             'DLTOVR OVR(#OUTPUT#)'
/5178c                   Callp(e)  Command(%trim(clCmd):
/5178c                              %len(%trim(clCmd)))

/5178
/5178 *    Set an override to the folder and open the folder

/5178c
/5178c                   If        bgrec > intFldThr
/5178C                   MOVE      *BLANKS       ACTION                          old folder
/5178C                   MOVE      *BLANKS       @ERDTA                          missing.
/5178C                   MOVE      'EMR0007'     @MSGID
/5178C                   CALL      'MAG1033'     @PARM1
/5178C                   MOVEL     MSGTXT        ERRMSG
/5178C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
/5178C                   ITER
/5178c
/5178c                   EndIf

/5178c                   EndIf

     C                   MOVE      OUTRPT        FOLDER
     C                   MOVE      OUTLIB        LIBRAR
     C     FLDKEY        CHAIN(N)  FLDDIR                             66
     C     *IN66         IFEQ      *OFF                                         Error,
     C     FLDLOC        ANDEQ     '1'                                           new folder
     C                   MOVE      *BLANKS       ACTION                          prev exists
     C                   MOVE      *BLANKS       @ERDTA
     C                   MOVE      'EMR0004'     @MSGID
     C                   CALL      'MAG1033'     @PARM1
     C                   MOVEL     MSGTXT        ERRMSG
     C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
     C                   ITER
     C                   END

     C     HFLDR         IFEQ      OUTRPT
     C     HFLDRL        ANDEQ     OUTLIB
     C                   MOVE      *BLANKS       ACTION                         Error,
     C                   MOVE      *BLANKS       @ERDTA                          won't move
     C                   MOVE      'EMR0001'     @MSGID                          within same
     C                   CALL      'MAG1033'     @PARM1                          folder.
     C     @PARM1        PLIST
     C                   PARM                    ACTION            1
     C                   PARM      #MSGF         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       MSGTXT           80
     C                   MOVEL     MSGTXT        ERRMSG
     C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
     C                   ITER
     C                   END

      *    Check for existing deleted records in the
      *    selected target folder.

/2372c                   Eval      ErrMsg = *blanks
/    c                   ExSr      ChkFldDlt
/
/    c                   If        ( ErrMsg <> *blanks )
/    c                   Iter
/    c                   EndIf

      *    Check for the Resulting Move of the report
      *    size exceeding the threshold

/5178c                   Select

/5178 *                  Test for the presense of a
/5178 *                  Pack Table Location

/5178c                   When      LocSFC > 0 and
/5178c                             LocSFC > LocSFA
/5178c                   Eval      intMoveResult =
/5178c                             intEOF + ((LocSFC - LocSFA) + 1)

/5178 *                  Test for the presense of a
/5178 *                  Page Table Location

/5178c                   When      LocSFP > 0 and
/5178c                             LocSFP > LocSFA
/5178c                   Eval      intMoveResult =
/5178c                             intEOF + ((LocSFP - LocSFA) + 1)
/5178c                   EndSl


/5178c                   If        intMoveResult > intFldThr
/5178C                   MOVE      *BLANKS       ACTION
/5178C                   MOVE      *BLANKS       @ERDTA
/5178C                   MOVE      'EMR0008'     @MSGID
/5178C                   CALL      'MAG1033'     @PARM1
/5178C                   MOVEL     MSGTXT        ERRMSG
/5178C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
/5178C                   ITER
/5178c                   EndIf

     C     RDRKEY        KLIST
     C                   KFLD                    FOLDER
     C                   KFLD                    LIBRAR
     C                   KFLD                    FILNAM
     C                   KFLD                    JOBNAM
     C                   KFLD                    USRNAM
     C                   KFLD                    JOBNUM
     C                   KFLD                    FILNUM
     C                   KFLD                    DATFOP

     C                   MOVE      OUTRPT        FOLDER
     C                   MOVE      OUTLIB        LIBRAR
     C     RDRKEY        CHAIN(N)  RPTDIR                             66
     C     *IN66         IFEQ      *OFF                                         Error,
     C                   MOVE      *BLANKS       ACTION                          new report
     C                   MOVE      *BLANKS       @ERDTA                          prev exists
     C                   MOVE      'EMR0002'     @MSGID
     C                   CALL      'MAG1033'     @PARM1
     C                   MOVEL     MSGTXT        ERRMSG
     C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
     C                   ITER
     C                   END

     C                   MOVE      HFLDR         FOLDER
     C                   MOVE      HFLDRL        LIBRAR
     C     RDRKEY        CHAIN(N)  RPTDIR                             66
     C     *IN66         IFEQ      *ON                                          Error,
     C                   MOVE      *BLANKS       ACTION                          old report
     C                   MOVE      *BLANKS       @ERDTA                          missing.
     C                   MOVE      'EMR0003'     @MSGID
     C                   CALL      'MAG1033'     @PARM1
     C                   MOVEL     MSGTXT        ERRMSG
     C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
     C                   ITER
     C                   END

     C                   CALL      'CRTFLD'
     C                   PARM                    OUTRPT
     C                   PARM                    OUTLIB
     C                   PARM                    CFRETN            8
     C     CFRETN        IFEQ      '1'                                          Error
     C                   MOVE      *BLANKS       ACTION                          Invalid
     C                   MOVE      *BLANKS       @ERDTA                          Fldr lib
     C                   MOVE      'ERR130B'     @MSGID
      *          "SpyFolder was not created."
     C                   CALL      'MAG1033'     @PARM1
     C                   MOVEL     MSGTXT        ERRMSG
     C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
     C                   ITER
     C                   END

     C     PROMPT        IFEQ      0
     C                   WRITE     MOVFLD
     C                   END
     C                   LEAVE                                                  Valid input.

     C                   END

      *----
      * OK  (input valid)
      *----
     C                   Z-ADD     LOCSFA        LLCSFA            9 0
/3715C                   Z-ADD     LOCSFD        LLCSFD            9 0
     C     LOCSFA        SUB       2             #T                9 0
     C     LOCSFA        SUB       #T            HLCSFA            9 0
     C     LOCSFD        SUB       #T            HLCSFD            9 0
     C     LOCSFP        SUB       #T            HLCSFP            9 0
     C     PKVER         IFNE      ' '
/3715C     LOCSFC        ANDGT     0
     C     LOCSFC        SUB       #T            HLCSFC            9 0
     C                   ELSE
     C                   Z-ADD     0             HLCSFC
     C                   END
     C                   Z-ADD     0             HLCSFE
     C                   Z-ADD     255           CLLEN            15 5

     C     REPLOC        IFEQ      ' '
     C     REPLOC        OREQ      '0'
     C     REPLOC        OREQ      '4'                                          R/dars opticAL
     C     REPLOC        OREQ      '5'                                          R/dars qdls
     C     REPLOC        OREQ      '6'                                          Imageview opTICAL

     C     CL(1)         CAT(P)    HFLDRL:0      CLCMD           255            OvrDB INPUT
     C                   CAT       '/':0         CLCMD
     C                   CAT       HFLDR:0       CLCMD
     C                   CAT       ')':0         CLCMD
     C                   CALL      'QCMDEXC'
     C                   PARM                    CLCMD
     C                   PARM                    CLLEN
     C     CL(2)         CAT(P)    OUTLIB:0      CLCMD                          OvrDB OUT
     C                   CAT       '/':0         CLCMD
     C                   CAT       OUTRPT:0      CLCMD
     C                   CAT       ')':0         CLCMD
     C                   CALL      'QCMDEXC'
     C                   PARM                    CLCMD
     C                   PARM                    CLLEN

     C                   OPEN      #INPUT#                              55
     C     *IN55         IFEQ      *ON
     C                   MOVE      *BLANKS       ACTION
     C                   MOVE      *BLANKS       @ERDTA
     C                   MOVE      'ERR0040'     @MSGID                         Cant Mve Msg
     C                   CALL      'MAG1033'     @PARM1
     C                   MOVEL     MSGTXT        ERRMSG
     C                   Z-ADD     0             PROMPT
J2416c                   exsr      massMoveSR
     C                   GOTO      GETNAM                                       Get name
     C                   END

     C                   OPEN      #OUTPUT#                             55      Alocat err

     C                   ADD       BGREC         HLCSFA            9 0
     C                   ADD       BGREC         HLCSFD            9 0
     C                   ADD       BGREC         HLCSFP            9 0
     C     PKVER         IFNE      ' '
/3715C     LOCSFC        ANDGT     0
     C                   ADD       BGREC         HLCSFC            9 0
     C                   END
      *----------
      * Copy recs
      *----------
     C     LOCSFA        SUB       1             #ORR              9 0
     C     #ORR          SETLL     #INPUT#                            66
     C                   READ      #INPUT#                                66
     C     LOCSFE        IFEQ      0
     C                   MOVE      *BLANKS       ACTION
     C                   MOVE      *BLANKS       @ERDTA
     C                   MOVE      'ERR1836'     @MSGID                         Cant Mve Msg
     C                   CALL      'MAG1033'     @PARM1
     C                   MOVEL     MSGTXT        ERRMSG
     C                   Z-ADD     0             PROMPT
     C                   GOTO      GETNAM                                       Get name
     C                   ENDIF
     C                   MOVE      OUTRPT        @FLDR
     C                   MOVE      OUTLIB        @FLDRL
     C                   Z-ADD     HLCSFA        @LCSFA
     C                   Z-ADD     HLCSFD        @LCSFD
     C                   Z-ADD     HLCSFP        @LCSFP
     C                   Z-ADD     @LCSFE        LLCSFE            9 0
     C                   SUB       #T            @LCSFE
     C                   ADD       BGREC         @LCSFE
     C                   Z-ADD     @LCSFE        HLCSFE            9 0
     C                   Z-ADD     HLCSFC        @LCSFC
      * Header
     C                   EXCEPT    #OUT#

      * R/dars & imageview only store headers & attributes in the folder.
      * Data and page table record numbers are used to spoof report retrieval.
     C     REPLOC        IFEQ      '4'                                          R/dars opticAL
     C     REPLOC        OREQ      '5'                                          R/dars qdls
     C     REPLOC        OREQ      '6'                                          Imageview opTICAL
/3715C     LLCSFD        SUB       1             LLCSFE
     C                   END
      * Detail
     C     LLCSFA        DO        LLCSFE        #T                9 0
     C                   READ      #INPUT#                                66
     C   66              LEAVE
     C                   EXCEPT    #OUT#
     C                   END

     C                   CLOSE     #INPUT#
     C                   CLOSE     #OUTPUT#

     C                   MOVEL(P)  CL(3)         CLCMD                          DltOvr
     C                   CALL      'QCMDEXC'
     C                   PARM                    CLCMD
     C                   PARM                    CLLEN
     C                   MOVEL(P)  CL(4)         CLCMD                          DltOvr
     C                   CALL      'QCMDEXC'
     C                   PARM                    CLCMD
     C                   PARM                    CLLEN
     C                   END
      *-------------
      * Move MRptDir
      *-------------
     C                   MOVE      HFLDR         FOLDER
     C                   MOVE      HFLDRL        LIBRAR                         Get source
     C     RDRKEY        CHAIN(N)  RPTDIR                             66        rpt data.
     C                   MOVE      OUTRPT        FLDR
     C                   MOVE      OUTLIB        FLDRLB
     C                   Z-ADD     HLCSFA        LOCSFA
     C                   Z-ADD     HLCSFD        LOCSFD
     C                   Z-ADD     HLCSFP        LOCSFP
     C                   Z-ADD     HLCSFC        LOCSFC                         New report
     C                   WRITE     RPTDIR                                         added.

     C                   MOVE      HFLDR         FOLDER
     C                   MOVE      HFLDRL        LIBRAR
     C     RDRKEY        CHAIN     RPTDIR                             66        Old report
     C                   DELETE    RPTDIR                                         goner.
      *---------------
      * Update MRptDes
      *---------------
     C                   MOVE      HFLDR         FOLDER
     C                   MOVE      HFLDRL        LIBRAR
     C     RDRKEY        CHAIN     RPTDES                             66
     C     *IN66         IFEQ      *OFF
     C                   MOVE      OUTRPT        FLDR
     C                   MOVE      OUTLIB        FLDRLB
     C                   UPDATE    RPTDES
     C                   END
      *-------------
      * Move MFldDir
      *-------------
     C                   MOVE      OUTRPT        FOLDER
     C                   MOVE      OUTLIB        LIBRAR
     C     FLDKEY        CHAIN     FLDDIR                             66        New folder
     C                   SELECT
     C     *IN66         WHENEQ    *OFF
     C     REPLOC        IFEQ      '0'
     C     REPLOC        OREQ      ' '
     C     REPLOC        OREQ      '5'                                          R/dars qdls
     C                   ADD       1             NUMFIL
     C                   ELSE
     C     REPLOC        IFEQ      '1'
     C                   ADD       1             NUMOFF
     C                   ELSE
     C     REPLOC        IFEQ      '2'
     C     REPLOC        OREQ      '4'                                          R/dars opticAL
     C     REPLOC        OREQ      '6'                                          Imageview opTICAL
     C                   ADD       1             NUMOPT
     C                   END
     C                   END
     C                   END
     C     HLCSFE        IFNE      0
     C                   Z-ADD     HLCSFE        INTEOF
     C                   END
     C                   UPDATE    FLDDIR                                         updated

     C     *IN66         WHENEQ    *ON
     C     HLCSFE        IFNE      0
     C                   Z-ADD     HLCSFE        INTEOF
     C                   END
     C                   MOVE      OUTRPT        FLDCOD
     C                   MOVE      OUTLIB        FLDLIB
     C     REPLOC        IFEQ      '0'
     C     REPLOC        OREQ      ' '
     C     REPLOC        OREQ      '5'                                          R/dars qdls
     C                   Z-ADD     1             NUMFIL
     C                   ELSE
     C     REPLOC        IFEQ      '1'
     C                   Z-ADD     1             NUMOFF
     C                   ELSE
     C     REPLOC        IFEQ      '2'
     C     REPLOC        OREQ      '4'                                          R/dars opticAL
     C     REPLOC        OREQ      '6'                                          Imageview opTICAL
     C                   Z-ADD     1             NUMOPT
     C                   END
     C                   END
     C                   END
     C                   Z-ADD     0             DLTRPT
     C                   Z-ADD     0             OFFDAT
     C                   MOVE      *BLANKS       FDESC
     C                   MOVE      *BLANKS       FLDLOC
     C                   MOVE      *BLANKS       OFFVOL
     C                   MOVE      *BLANKS       APFNAM
     C                   WRITE     FLDDIR                                         added.

     C                   ENDSL

     C                   MOVE      HFLDR         FOLDER
     C                   MOVE      HFLDRL        LIBRAR
     C     FLDKEY        CHAIN     FLDDIR                             66        Old folder
     C     REPLOC        IFEQ      '0'
     C     REPLOC        OREQ      ' '
     C     REPLOC        OREQ      '5'                                          R/dars qdls
     C                   SUB       1             NUMFIL
     C                   ELSE
     C     REPLOC        IFEQ      '1'
     C                   SUB       1             NUMOFF
     C                   ELSE
     C     REPLOC        IFEQ      '2'
     C     REPLOC        OREQ      '4'                                          R/dars opticAL
     C     REPLOC        OREQ      '6'                                          Imageview opTICAL
     C                   SUB       1             NUMOPT
     C                   END
     C                   END
     C                   END
     C                   ADD       1             DLTRPT
     C                   MOVE      APFNAM        OLDAPF           10
     C                   UPDATE    FLDDIR                                         updated.

/5635 * add HIPAA logging for Move report
/5635c                   callp     BldLogEnt(Repind:Hfldr:HfldrL:
/5635c                              OutRpt:OutLib)

      *----------------
      * Log transaction
      *----------------
     C                   CALL      'MAG901'                             81      Trans logger
     C                   PARM                    LOGRTN            1            return code
     C                   PARM      *BLANK        DLSUB            10            subscriber
     C                   PARM      *BLANK        DLREPT           10            report type
     C                   PARM      *BLANK        DLSEG            10            segment
     C                   PARM      REPIND        DLREP            10            report name
     C                   PARM      *BLANK        DLBNDL           10            bundle
     C                   PARM      'C'           DLTYPE            1            (C)opy
     C                   PARM      TOTPAG        DLTPGS            9 0          pages
     C                   PARM      'MOVRDR'      DLPROG           10
      *----------------
      * Copy APF Member
      *----------------
     C                   MOVE      OUTRPT        FLDR
     C                   MOVE      OUTLIB        FLDRLB
     C     RDRKEY        CHAIN(N)  RPTDIR                             66        New report

     C     APFTYP        IFNE      *BLANKS
     C                   MOVE      OUTRPT        FOLDER
     C                   MOVE      OUTLIB        LIBRAR
     C     FLDKEY        CHAIN     FLDDIR                             66        New folder

     C     APFNAM        IFEQ      *BLANKS
     C                   CALL      'GETNUM'
     C                   PARM      'GETQWT'      GETOP             6
     C                   PARM      'APFNAM'      GETTYP           10
     C                   PARM                    APFNAM                         A987654321
     C                   UPDATE    FLDDIR
     C                   END
     C                   UNLOCK    MFLDDIR

     C                   CALL      'MAG1036'                                    Folder
     C                   PARM                    @ERRMS           80             existance
     C                   PARM                    OUTLIB                          check
     C                   PARM                    APFNAM
     C                   PARM      '*FILE'       APITYP           10

     C     @ERRMS        IFNE      *BLANKS                                      Create APF
     C                   CALL      CRTFLA                                        folder.
     C                   PARM                    APFNAM
     C                   PARM                    OUTLIB
     C                   PARM                    OUTRPT
     C                   PARM                    CRTRTN            1
     C     CRTRTN        IFEQ      '1'                                          Could not
      *                    Move 'dskerr  'rtncde           create.
     C                   END
     C                   END

     C                   CALL      'MAG1070'
     C                   PARM      'M'           @OPER             1
     C                   PARM                    OLDAPF                         Input File
     C                   PARM                    HFLDRL                         Library
     C                   PARM                    REPIND                         Key
     C                   PARM                    APFNAM                         Output File
     C                   PARM                    OUTLIB                         Library
     C                   PARM                    REPIND                         Key
     C                   END
     C                   MOVE      *ON           *INLR
      **************************************************************************
J2416 /free
J2416  begsr massMoveSR;
J2416  if massMove;
J2416    *inlr = '1';
J2416    return;
J2416  endif;
J2416  endsr;
J2416 /end-free
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRCURS        BEGSR
      *          Cursor position
     C     CSRLOC        DIV       256           CSRLIN            3 0          Curs-line
     C                   MVR                     CSRPOS            3 0          Curs-pos
     C     WINLOC        DIV       256           WINLIN            3 0          Curs-line
     C                   MVR                     WINPOS            3 0          Curs-pos
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SRF4          BEGSR
     C                   EXSR      SRCURS
     C                   SELECT
     C     FLD           WHENEQ    'OUTRPT'

      *  CREATE DUPLICATE PROGRAM TO AVOID RECURSIVE CALL

     C                   MOVEL(P)  'WRKFLD01'    DUPPGM           10
     C     WQPGMN        IFNE      DUPPGM
     C                   CALL      'CRTDBPGM'                           50
     C                   PARM                    DUPPGM
     C                   PARM      WQLIBN        DUPLIB           10
      *  CALL DUP PROGRAM
     C                   CALL      DUPPGM                               50
     C                   PARM                    WFOLD            10            Folder
     C                   PARM                    WLIBR            10            Library
     C                   PARM                    WDESC            30            Description
     C                   PARM      '1'           WLIST             1            List
     C                   PARM                    RTNCDE            8            Return Code
     C     WFOLD         IFNE      *BLANKS
     C                   MOVE      WFOLD         OUTRPT
     C                   MOVE      WLIBR         OUTLIB
     C                   END
     C                   END
     C     FLD           WHENEQ    'OUTLIB'
     C                   CALL      'MAG2042'                            45
     C                   PARM      '*ALL'        LKPOBJ           10
     C                   PARM      '*LIBL'       LKPLIB           10
     C                   PARM      '*LIB'        LKPTYP           10
     C                   PARM      *BLANKS       LKPATR           10
     C                   PARM      *BLANKS       RETOBJ           10
     C                   PARM      *BLANKS       RETLIB           10
     C     RETOBJ        IFNE      *BLANKS
     C                   MOVE      RETOBJ        OUTLIB
     C                   END
     C                   ENDSL
     C                   ENDSR
      *------------------------------------------------------------------------
/2372c     ChkFldDlt     BegSr
/     *------------------------------------------------------------------------
/     *  Check the FLDSTS field in MFLDDIR for deleted records, if this value
/     *  is set, exit the program. Otherwise, call the API to check for the
/     *  deleted records.
/     *------------------------------------------------------------------------
/     /free
/
/       // Check the folder for status for deleted records
/
/       Chain(n) FldKey MFldDir;
/
/       If %found = TRUE;
/
/         If FldDRc = FLDSTS_DLTREC;
/           ErrMsg = MMMSGIO_RtvMsgTxt(MSGID_DLTREC:' ':'PSCON');
            leaveSr;
/         EndIf;
/
/       EndIf;
/
/       // Check the folder itself for deleted records
/
/      If ( MAPFIO_GetDltRec( Librar : Folder : intMAPFIO_dltrec )
           = MAPFIO_OK );
/
/         If intMAPFIO_dltrec > *zero;
/           Chain Fldkey MFldDir;
/
/           If %found = TRUE;
/             fldDRc = FLDSTS_DLTREC;
/             Update FldDir;
/             ErrMsg = MMMSGIO_RtvMsgTxt(MSGID_DLTREC:' ':'PSCON');
/           EndIf;
/
/         EndIf;
/       Else;
/         ErrMsg = MMMSGIO_RtvMsgTxt(MSGID_DLTAPI:' ':'PSCON');
/       EndIf;
/
/      EndSr;
/     /end-free
     O#OUTPUT#  E            #OUT#
     O                       RECDAT             256
/5635 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/5635p BldLogEnt       b
/5635
/5635d                 pi
/5635d SpyNbr                        10a   value
/5635d FrmFld                        10a   value
/5635d FrmFldLib                     10a   value
/5635d ToFld                         10a   value
/5635d ToFldLib                      10a   value
/5635
/5635d DtlType         s              5u 0
/5635d DtlNamLen       s              5u 0 inz(0)
/5635d DtlValLen       s              5u 0 inz(0)
/5635d DtlFldLib       s             21a
     d rc              s             10i 0
/5635
/5635 * add detail from folder info
/5635c                   eval      DtlFldLib = %trim(FrmFldLib)+'/'+
/5635c                             %trim(FrmFld)
/5635c                   eval      DtlValLen = %len(%trim(DtlFldLib))
/5635c                   eval      DtlType = #DTFFLR
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:*NULL:
/5635c                               DtlNamLen:%addr(DtlFldLib):DtlValLen)
/5635
/5635 * add detail to folder info
/5635c                   eval      DtlFldLib = %trim(ToFldLib)+'/'+
/5635c                             %trim(ToFld)
/5635c                   eval      DtlValLen = %len(%trim(DtlFldLib))
/5635c                   eval      DtlType = #DTFLR
/5635c                   eval      rc = AddLogDtl(%addr(LogDS):DtlType:*NULL:
/5635c                               DtlNamLen:%addr(DtlFldLib):DtlValLen)
/5635
/5635 * build log header
/5635c                   eval      LogOpCode = #AUMOVOBJ
/5635c                   eval      LogUserID = Wqusrn
/5635c                   eval      LogObjID  = SpyNbr
/5635c                   callp     LogEntry(%addr(LogDS))
/5635
/5635c                   return
/5635p                 e
** CMD   Command line text                                           77
OVRDBF FILE(#INPUT#) TOFILE(
OVRDBF FILE(#OUTPUT#) TOFILE(
DLTOVR FILE(#INPUT#)
DLTOVR FILE(#OUTPUT#)

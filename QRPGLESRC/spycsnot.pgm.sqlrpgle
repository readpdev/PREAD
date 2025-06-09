      *%METADATA                                                       *
      * %TEXT Notes/Annotations functions                              *
      *%EMETADATA                                                      *
     h bnddir('SPYBNDDIR')
      /copy directives
      ***********--------------------------------------
      * SPYCSNOT  Notes/Annotation functions
      ***********--------------------------------------
      *
J4114 *  04-17-12 PLR Initial revision allows other users to view annotations of
      *               the current user's work-in-progress. Do not send back
      *               annotation for a work-in-progress note that does not belong
      *               to the requesting user.
J3549 *  10-14-11 PLR Change use and return of 'Others' flags. 'Others' was
      *               intended to indicate what the current user can 'do' to
      *               other user notes not what other users can do to the
      *               current user's notes.
J3549 *  09-29-11 PLR Couple of tweaks for extended note security.
J3618 *  06-22-11 PLR Extend annotation flags returned to indicate specific
      *               note types that are available on a given page.
J3633 *  06-17-11 PLR When a user attempts to delete another's notes, fetch
      *               the note owner's extended note security settings (if active)
      *               to verify the delete is authorized.
J3090 *  04-29-11 PLR Unit testing. Current user needed to be referenced in
      *               program information datastructure for swapping profiles
      *               during test. Also, discovered error caused by passing
      *               zeros in the AUTREQ parm for MAG1060. Was getting
      *               subscript errors here and in MAG1060.
J2586 *  06-11-10 PLR Annotation security. Add new delete for update opcode
      *               DLTNU. There are situations where it is necessary for
      *               the client to issue a delete and then a write operation
      *               instead of an update.
T7031 *  05-05-08 EPG Remove reference to old revision control logging service
      *               program MMAUDLOGR. Deprecated by MLAUDLOG
T4656 *  09-01-05 PLR Removed *PSSR's. Was masking errors that should not have
      *               been occurring. Found while testing calls from DltObj()
      *               function in MRREPMGR-SRVPGM.
/9804 *  04-21-05 PLR Sticky note text dissappearing when annotating a checked out
/     *               document via CoEx/VCO. Removed a portion of code from 6304
/     *               that was causing the problem. Removing this code did not cause
/     *               any issues including the reason for bug 6304.
/5635 *   2-19-04 JMO Added HIPAA logging routines
/6249 *  03-06-02 KAC Copy/Move routine not working.
/6304 *  03-05-02 KAC Add Revision ID to Notes structure.
/5235 *  10-12-01 KAC Revise CS Segment notes.
/5592 *  10-08-01 KAC Annotations missing from list.
/4537 *  08-17-01 KAC Add VCO phase II functions.
/4900 *  07-11-01 PLR Allow processing against head revision if under RC.
/4582 *  06-18-01 DLS Add RC audit log.
/4749 *   6-13-01 DLS Need use get rev by content id.
/4749 *   6-01-01 DLS If under rev.ctl. but you didn't send
/4749 *               enough parms to include the revid chain
/4749 *               to rev file
/4698 *   5-31-01 DLS Insure DMSINIT/DMSQUIT are in sync
/4623 *   5-23-01 DLS Modified logic for folder copy of Revctl.
/4534 *   5-08-01 DLS Make sure notes are deleted with rest of clean up files.
/3765 *  02-28-01 DLS MODIFIED FOR NEW CHECK IN/OUT DATA BASE
/813b *  12-12-00 KAC 1 byte sticky notes not written correctly.
/813  *  09-05-00 KAC Added extra data field to map complete buffer.
/2537 *  04-13-00 DLS FIX LEAP YEAR 400 BUG
      *  04-03-00 FID Added new opcode CPY and MOV
      *  10-08-99 KAC EXPAND INTERFACE USERID TO 20BYTES.
      *   7-27-99 KAC DROP WINDOW HANDLE I/O.
      *   7-14-99 KAC CHANGES TO MATCH ANNOTATION TEMPLATE "CONVERSATION"
      *   3-09-99 KAC ADD ADDITIONAL PARMS TO EXPAND API
      *   8-27-98 KAC USE NEW NOTES FILES
      *  12/01/97 GT  Reset *IN96 in FILSDT to prevent left over
      *               end-of-note condition.
      *   9/23/97 GT  Conditioned writing of RNOTDBF header records
      *               for images only (not report annotations).
      *   7/26/97 GK  New opcode GETNN will retrieve 1 7680 Note Buffer
      *               If GetAN and an audio not is encountered
      *               only load 1 record into the return buffer.
      *   2/13/97 JJF Rework security & annotation headers building.
      *               RLSNT opcode in, WTANH opcode out.
      *  12/27/96 GK  Add a blank record at the end of each Text note.
      *  10/16/95 GK  Program created - Gary Kemmer & David Mickle
      *
      *    PARM  NAME   SIZE  DESCRIPTION
      *    ----  -----  ----  ----------------------------------------
      *     1    @SPYBT   10  Spy0000* SPY/BATCH NUMBER
      *     2    @Segmt   10  Distribution Page table name
      *     3    @Hndl    10  Window Handle (no longer used)
      *     4    @Libr    10  Libr where file is found (SPYDATA)
      *     5    OpCode    5  See below
      *     6    Page      9  Page for Note#
      *     7    Note#     9  Note# requested (before or after)
      *     8    Tifpg#    9  TIFF page#
      *     9    Sdt    7680  Send back buffer
      *     10   RtnRec    9  Number of note records returned in SDT
      *     11   RtnCde    2  See below
      *     12   SetLR     1  Shutdown Pgm (Y/N)
      *     13   NewNot    1  New note (Y/N)  not used (old interface)
      *     14   PagEnd    9  End range page#
      *     15   NotTyp    1  Note type
/3765 *     16   RevID     9  Revision ID
/3765 *     17   Dcode     9  Domain code
/3765 *     18   Dtype     9  Domain type
/4900 *     19   errid     7  Error MsgID
/     *     20   errdta   80  Error MsgData
/4537 *     21   StartPos 10  Start position for GETNT
/4537 *     22   DataLen  10  Data length for GETNT/APDNT
      *
      *     When OPCODE from client/terminal is:
      *           LSTNT   GET A LIST OF NOTES/ANNOTATIONS
      *           GETNT   GET A NOTE/ANNOTATION
      *           WRTNT   WRITE A NOTE/ANNOTATION
/4537 *           APDNT   Append data to a NOTE/ANNOTATION
      *           DLTNT   DELETE A NOTE/ANNOTATION
J2586 *           DLTNU   DELETE FOR UPDATE.
      *           UPDNT   UPDATE A NOTE/ANNOTATION HEADER
      *           CHKNT   CHECK FOR NOTES/ANNOTATIONS
      *           CPYNT   Copy Note (allways copies critical)
      *           MOVNT   Move Note (allways moves critical)
/3765 *           INIT    Initial call to program
/3765 *           QUIT    Quit Call to program - shut down
      *
      *     When RTNCDE to client/terminal is:
      *              00   the SDT contains data.
      *              20   warning - reached Tof or Eof
      *              25   deletion denied - authority/ownership problem
      *              30   their was a program terminal error
      *
     FRSEGMNT   IF   E           K DISK    USROPN
/5235fRSEGHDR   if   e           k disk    usropn
     FMRPTDIR7  IF   E           K DISK    USROPN
     FMIMGDIR   IF   E           K DISK    USROPN
     FMNOTDIR   UF A E           K DISK
     FMNOTDTA   UF A E           K DISK    USROPN INFDS(FIDS)


J3618d noteTypes       s              2    dim(7) ctdata
/5635
/5635 * Prototypes for HIPAA logging service program
/5635 /copy @mlaudlog
J3618 /copy @mmcsnoter
/5635d LogDS           ds                  inz
/5635 /copy @mlaudinp
/5635
/5635 * Build audit log entry
/5635d BldLogEnt       pr
/5635d  OpCode                        5a   const
/5635d SpyNbr                        10a
/5635d NoteNbr                       10i 0 value
/5635d PageNbr                       10i 0 value
/5635d RevID                         10i 0 value


     d CurRev          pr              n

      * system defaults
     d SYSDFT          ds          1024    dtaara
     d  EXTSEC               137    137
     d  PGMLIB               296    305
     d  DTALIB               306    315
     d  MAXNFZ               783    787

      * Segment Page table
     d PTmax           c                   63
     d PGTAB           ds
     d  PT                     1    252p 0 DIM(PTmax)
     d PTBeg           s              9  0
     d PTEnd           s              9  0
     d PTfirst         s              9  0
     d PTlast          s              9  0
     d BGrec           s              9  0

     d #BLKSZ          c                   7168

      * data buffer
     D SDT             s           7680

      * NOTE COPY STRUCTURE
     D cpyds           DS           128
     D  cpybat                       10                                         Copy to batch#
     D  cpyseq                        9  0                                      Copy to seq number
     D  cpyall                        1                                         Copy all notes?
     D  cpyrev                        9  0                                      Copy to rev

     d LstMax          c                   60
     d LST             s                   dim(LstMax) like(NLDS)               LIST OF NOTES
      * NOTE LIST STRUCTURE
     D NLDS            DS           128
     D  NLPAGN                 1     10  0
     D  NLNOTN                11     20  0
     D  NLUSER                21     40
     D  NLDATE                41     48  0
     D  NLTIME                49     54  0
     D  NLTYPE                55     55
     D  NLACOO                56    105
     D  NXASTP                56     57
     D  NXALEN                96    104
     D  NXATYP               105    109
/    d  nxReserved           110    117
/6304d  nxRevision           118    127
/    d  nxStickyOpen         128    128
      * NOTE RETURN STRUCTURE
     D NRDS            DS
     D  NRNOTN                 1     10  0
     D  NRUSER                11     30
     D  NRDATE                31     38  0
     D  NRTIME                39     44  0

      * FILE INFORMATION DS
     D FIDS            DS
     D  FIRECS               156    159i 0

     D                SDS
/3765D  PARMS                 37     39  0
     D  WQPGMN                 1     10
J3090D  USERNM               358    367

      /copy @mmdmssrvr
      /copy @mmaudlogr                                                          RC audit log.
      /copy @memio

     d SeqNum          s              9b 0
/4749
/    d ContentID       ds
/    d  KBNUM                        10
/    d  SequenceNum                   9s 0

      * Fields used for writing to audit log.

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get next note header
     d GetNxtNoteHdr   pr            10i 0

      * notes data
     d Start           s             10i 0
     d Length          s             10i 0
     d BytesRem        s             10i 0
     d BytesRead       s             10i 0
     d BytesWrtn       s             10i 0

      * get notes data
     d GetNoteData     pr            10i 0
     d NoteKey                             const like(NoteKeyDS)
     d StartPos                      10i 0 const
     d Length                        10i 0 const
     d Buffer                          *   const
      * write notes data
     d WrtNoteData     pr            10i 0
     d NoteKey                             const like(NoteKeyDS)
     d StartPos                      10i 0 const
     d Length                        10i 0 const
     d Buffer                          *   const

      * notes key
     d NoteKeyDS       ds
     d nkBatNum                            like(ndBnum)
     d nkBatSeq                            like(ndBseq)
     d nkPagNum                            like(ndPagN)
     d nkNotNum                            like(ndNotN)
     d nkRevID                             like(ndRevI)
     d nkNotSeq        s                   like(naNseq)

      * convert from segment to report page number
     d CnvFromSegPage  pr            10i 0
     d PagSegFile                    10    const
     d PageNbr                       10i 0 const
      * convert from report to segment page number
/5235d CnvToSegPage    pr            10i 0
/    d PagSegFile                    10    const
/    d PageNbr                       10i 0 const
      * check/open the page segment file
     d ChkPSegFile     pr            10i 0
     d PagSegFile                    10    const
      * get the page segment file from Report/Segment ID
/5235d GetPSegFile     pr            10
/    d SpyNbr                        10    const
/    d PagSegID                      10    const

      * check/assign the notes data file
     d CheckNDfile     pr            10i 0
     d NotesFile                     10
      * open the notes data file
     d OpenNDfile      pr            10i 0
     d NotesFile                     10    const

      * determine block and position
     d GetBlockPos     pr
     d Position                      10i 0 const
     d BlockSize                     10i 0 const
     d Block                         10i 0
     d BlockPos                      10i 0

      * system counter assignment
     d GetNum          pr                  extpgm('GETNUM')
     d  OpCode                        6    const                                opcode
     d  DataType                     10    const options(*nopass)               data type
     d  DataValue                    10    options(*nopass)                     return data

      * execute a CL command
     d CLcmd           pr            10i 0
     d  cmd                        1024    const                                CL command
     d Cmd             s           1024
      * receive a message
     d RcvMsg          pr
      * receive message info struct
     d MsgInfo         s            128

      * system API error struct
     d APIerrDS        ds
     d  AerrBprv                     10i 0 inz(%size(APIerrDS))
     d  AerrBavl                     10i 0
     d  AerrExcID                     7
     d  AerrRSV1                      1
     d  AerrData                    128

      * set return status
     d SetRtnSts       pr
     d RtnCode                        2    const
     d MsgID                          7    const options(*nopass)
     d MsgData                      100    const options(*nopass)

     d wRtnDS          ds
     d wRtnCde                        2    inz('00')                            return code
     d wRtnID                         7                                         msg id
     d wRtnDta                      100                                         msg data

      * program return codes
     d R@OK            c                    '00'
     d R@WARN          c                    '20'
     d R@NOTAUTH       c                    '25'
     d R@ERROR         c                    '30'

      * function return codes
     d OK              c                   1
     d FAIL            c                   0
     d rc              s             10i 0                                      Return code

J2586d noteSec         ds           100    qualified
J2586d  noteSecA                      9    dim(7)
J2586d  type                          2    overlay(noteSecA)
J2586d  authAdd                       1    overlay(NoteSecA:*next)
J2586d  authView                      1    overlay(NoteSecA:*next)
J2586d  authEdit                      1    overlay(NoteSecA:*next)
J2586d  authDel                       1    overlay(NoteSecA:*next)
J2586d  otherView                     1    overlay(NoteSecA:*next)
J2586d  otherEdit                     1    overlay(NoteSecA:*next)
J2586d  otherDel                      1    overlay(NoteSecA:*next)

      * entry parms
/5235d PSegFile        s             10                                         Dist Segment
/5235d PageNum         s              9  0                                      Page number
/    d PageEnd         s              9  0                                      Page number (end)
/4537d StartPos        s             10i 0                                      Start position
/    d DataLen         s             10i 0                                      Data length

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

     C     *ENTRY        PLIST
     C                   PARM                    @SPYBT           10            Spy000*
     C                   PARM                    @SEGMT           10            Dst pgtbl nm
     C                   PARM                    @HNDL            10            Window Handl
     C                   PARM                    @LIBR            10            Spy00 Libr
     C                   PARM                    OPCODE            5            Opcode
     c                   PARM                    PageNumX          9 0          Page #
     C                   PARM                    NOTE#             9 0          Note #
     C                   PARM                    TIFPG#            9 0          TIFF PAGE#
     C                   PARM                    SDT                            Return data
     C                   PARM                    RTNREC            9 0          Rtn # of rec
     C                   PARM                    RtnCde            2            Return code
     C                   PARM                    SETLR             1            Shutdown
     C                   PARM                    NEWNOT            1            New Note
     c                   PARM                    PageEndX          9 0          END Page #
     C                   PARM                    NOTTYP            1            NOTE TYPE
/3765C                   PARM                    REVID             9 0          Revision id
/3765C                   PARM                    DCODE             9 0          Domain
/3765C                   PARM                    DTYPE             9 0          Domain Type
/4900c                   parm                    errid             7
/    c                   parm                    errdta           80
/4537c                   parm                    StartPos                       Start position
/    c                   parm                    DataLen                        Data length
J3618c                   parm                    noteFlagsP                     Note flags pointer

     C     KNOTDB        KLIST
     C                   KFLD                    KBNUM
     C                   KFLD                    KBSEQ
     C     KNOTDP        KLIST
     C                   KFLD                    KBNUM
     C                   KFLD                    KBSEQ
     C                   KFLD                    KPAGN
     C     KNOTDN        KLIST
     C                   KFLD                    KBNUM
     C                   KFLD                    KBSEQ
     C                   KFLD                    KPAGNX
     C                   KFLD                    KNOTNX
     C     KNOTD1        KLIST
     C                   KFLD                    KBNUM
     C                   KFLD                    KBSEQ
     C                   KFLD                    KPAGNX
     C                   KFLD                    KNOTNX
/3765C                   KFLD                    KREVI
     C     KNOTD2        KLIST
     C                   KFLD                    KBNUM
     C                   KFLD                    KBSEQ
     C                   KFLD                    KPAGNX
     C                   KFLD                    KNOTNX
/3765C                   KFLD                    KREVIX

     C     *LIKE         DEFINE    NDBNUM        KBNUM
     C     *LIKE         DEFINE    NDBSEQ        KBSEQ
     C     *LIKE         DEFINE    NDPAGN        KPAGN
     C     *LIKE         DEFINE    NDNOTN        KNOTN
     C     *LIKE         DEFINE    NDPAGN        KPAGNX
     C     *LIKE         DEFINE    NDNOTN        KNOTNX
     C     *LIKE         DEFINE    NDPAGN        KPAGN2                         TO PAGE RANGE (LIST)
/3765C     *LIKE         DEFINE    NDREVI        KREVI
/3765C     *LIKE         DEFINE    NDREVI        KREVIX
/3765C     *LIKE         DEFINE    NDREVI        PREVID
/3765C     *LIKE         DEFINE    NDREVI        RtnRevID
/3765C     *LIKE         DEFINE    NDdcod        pdcode
/3765C     *LIKE         DEFINE    NDdtyp        pdtype
     C     *LIKE         DEFINE    NDBNUM        DocClass

     c     KNotDta       klist
     c                   kfld                    nkBatNum
     c                   kfld                    nkBatSeq
     c                   kfld                    nkPagNum
     c                   kfld                    nkNotNum
     c                   kfld                    nkRevID

     c     KNotDtaSeq    klist
     c                   kfld                    nkBatNum
     c                   kfld                    nkBatSeq
     c                   kfld                    nkPagNum
     c                   kfld                    nkNotNum
     c                   kfld                    nkRevID
     c                   kfld                    nkNotSeq

     C     PGKEY         KLIST
     C                   KFLD                    @SPYBT
     C                   KFLD                    SGSEQ

     c                   if        @spybt = ' ' and opcode = 'GETNT'
     c                   eval      @spybt = 'NOTFOUND'
     c                   endif

     c                   select
/3765C     parms         whenlt    16
/    C                   eval      previd = *zeros
/    C                   eval      pdcode = *zeros
/    C                   eval      pdtype = *zeros
/3765C     parms         whenlt    17
/    C                   eval      previd = revid
/    C                   eval      pdcode = *zeros
/    C                   eval      pdtype = *zeros
/3765C     parms         whenlt    18
/    C                   eval      previd = revid
/    C                   eval      pdcode = dcode
/    C                   eval      pdtype = *zeros
/3765C                   other
/    C                   eval      previd = revid
/    C                   eval      pdcode = dcode
/    C                   eval      pdtype = dtype
/    C                   ENDsl

     C     OPCODE        CASEQ     'INIT'        $INIT
     C     OPCODE        CASEQ     'QUIT'        QUIT                           Shutdown
     C     SETLR         CASEQ     'Y'           QUIT                           Shutdown
     C                   ENDCS

J4114 /free
J4114  if opcode = 'WRTNT' and %addr(revid) <> *null and revid > 0 and
J4114    revid < GetWIPBy_RevID(RevID);
J4114    revid = GetWIPBy_RevID(RevID);
J4114    previd = revid;
J4114  endif;
J4114 /end-free

     C     OPCODE        IFNE      'WRTNT'
/4537c     OPCODE        ANDNE     'APDNT'
     C     OPCODE        ANDNE     'UPDNT'
     C     OPCODE        ANDNE     'CPYNT'
     C     OPCODE        ANDNE     'MOVNT'
     C                   CLEAR                   SDT
     C                   CLEAR                   RTNREC
     C                   ENDIF
     c                   callp     SetRtnSts(R@OK)

      * CS passes Segment ID (not segment file)
/5235c                   if        @SEGMT <> *blanks and @LIBR = 'SPYCS'
/    c                   eval      PSegFile = GetPSegFile(@SPYBT:@SEGMT)
/     * convert from segment to report page numbers
/    c                   eval      PageNum = CnvFromSegPage(PSegFile:PageNumX)
/    c                   eval      PageEnd = CnvFromSegPage(PSegFile:PageEndX)
/    c                   if        PageNum < 0 or
/    c                             PageEnd < 0
/    c                   callp     SetRtnSts(R@WARN)
/    C                   GOTO      RTNPGM
/    c                   end
/    c                   else
/    c                   eval      PSegFile = @SEGMT
/    c                   eval      PageNum = PageNumX
/    c                   eval      PageEnd = PageEndX
/    c                   end

     C     @SPYBT        IFNE      LSPYB
     C                   EXSR      SETKYS
     C                   END
     C                   EXSR      $KEYS                                        MAP KEYS

     C     OPCODE        CASEQ     'LSTNT'       $LIST                          LIST NOTES/ANNOTES
     C     OPCODE        CASEQ     'GETNT'       $GET                           GET NOTES/ANNOTES
     C     OPCODE        CASEQ     'WRTNT'       $WRITE                         WRITE NOTES/ANNOTES
/4537c     OPCODE        CASEQ     'APDNT'       $WRITE                         Append NOTES/ANNOTES
     C     OPCODE        CASEQ     'UPDNT'       $UPDAT                         UPDATE NOTES/ANNOTES
     C     OPCODE        CASEQ     'CHKNT'       $CHECK                         CHECK FOR NOTES/ANNO
     C     OPCODE        CASEQ     'CPYNT'       $Copy                          Copy Note/Annotes
     C     OPCODE        CASEQ     'MOVNT'       $Copy                          Move Note/Annotes
     C                   ENDCS

J2586c                   if        %subst(opcode:1:4) = 'DLTN'                  DELETE NOTES/ANNOTES
     C     PageNum       CASGE     0             $DELNT                         SINGLE NOTE
     C                   CAS                     $DELAL                         ALL NOTES
     C                   ENDCS
     C                   END

     C     PDCODE        ifeq      0                                            NTS/ANNO not commnts

     C     OPCODE        ifeq      'WRTNT'                                      WRITE NOTES/ANNOTES
/4537c     OPCODE        oreq      'APDNT'                                      Append NOTES/ANNOTES
     C     OPCODE        oreq      'UPDNT'                                      UPDATE NOTES/ANNOTES
     C     OPCODE        oreq      'CPYNT'                                      Copy Note/Annotes
     C     OPCODE        oreq      'MOVNT'                                      Move Note/Annotes
     C     OPCODE        oreq      'DLTNT'                                      DELETE NOTES/ANNOTES
J2586C     OPCODE        oreq      'DLTNU'                                      DELETE NOTES/ANNOTES
     c                   endif

     C                   END

      * SAVE LAST PARMS
     C                   MOVEL     @SPYBT        LSPYB            10
     C                   MOVEL     @SEGMT        LSEGM            10
     C                   MOVEL     OPCODE        LOPCO             5
     C                   Z-ADD     PageNum       LPAGE             9 0
     C                   Z-ADD     NOTE#         LNOTE             9 0
     C                   Z-ADD     TIFPG#        LTIFP             9 0
/3765C                   Z-ADD     PREVID        LREVID            9 0
     C                   MOVEL     wRtnCde       LRTN              2

     C     RTNPGM        TAG
     c                   EXSR      RETRN

      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $LIST         BEGSR

      * NEW LIST REQUEST
     C     OPCODE        IFNE      LOPCO                                        SAME OPCODE
     C     LRTN          ORNE      R@OK                                         NOT DONE
     C     @SPYBT        ORNE      LSPYB
     C     @SEGMT        ORNE      LSEGM
     C     PageNum       ORNE      LPAGE
/3765C     PREVID        ORNE      LREVID
     C     TIFPG#        ORNE      LTIFP

     C                   Z-ADD     KPAGN         KPAGNX                         PAGE#
     C                   Z-ADD     KNOTN         KNOTNX                         NOTE#
     C                   SELECT
     C     KPAGN         WHENEQ    0                                            ALL REPORT PAGES/IMA
     C     KNOTDB        SETLL     NOTDIR
     C                   OTHER                                                  REPORT PAGE#/TIFF PA
     C     KNOTDP        SETLL     NOTDIR
     C                   ENDSL

      * LIST CONTINUATION
     C                   ELSE
     C                   Z-ADD     PAGN          KPAGNX                         PAGE#
     C                   Z-ADD     NOTN          KNOTNX                         NOTE#
     C     KNOTDN        SETll     NOTDIR
     C                   END

      * LIST OF NOTES
     C                   CLEAR                   NLDS
     C                   Z-ADD     0             L                 3 0
     C                   MOVE      *BLANKS       LST
      * FILL BUFFER LIST
     c                   dou       L >= LstMax
     c                   if        OK <> GetNxtNoteHdr
     c                   callp     SetRtnSts(R@WARN)                            end of list
     C                   leave
     C                   END
J4114 /free
J4114  if nduser <> usernm and revid > 0 and revid <> GetHedBy_RevID(RevID);
J4114    iter;
J4114  endif;
J4114 /end-free
      * LIST ENTRY
     C                   CLEAR                   NLDS
     C                   Z-ADD     NDPAGN        NLPAGN                         PAGE#
      * convert report to segment page for CS
/5235c                   if        @SEGMT <> *blanks and @LIBR = 'SPYCS'
/    c                   eval      nlpagn = CnvToSegPage(PSegFile:ndpagn)
/    c                   if        nlpagn < 0
/    c                   iter
/    c                   end
/    c                   end
     C                   Z-ADD     NDNOTN        NLNOTN                         NOTE#
     C                   MOVEL(P)  NDUSER        NLUSER                         USER ID
     C                   Z-ADD     NDDATE        NLDATE                         DATE
     C                   Z-ADD     NDTIME        NLTIME                         TIME
     C                   MOVEL     NDTYPE        NLTYPE                         NOTE/CRIT&NON-CRIT A
     C                   MOVEL     NDACOO        NLACOO                         ANNOT COORDINATES
/6304c                   MOVE      NDREVI        nxRevision
/    c                   MOVEL     NDADTA        nxReserved
/    c                   MOVE      NDADTA        nxStickyOpen
     C     NDALEN        IFGT      0
     C                   MOVE      NDALEN        NXALEN                         BINARY ANNOT LEN
     C                   END
     C                   MOVEL     NDATYP        NXATYP                         ANNOT EXTENSION
     C                   ADD       1             L
     C                   MOVEL     NLDS          LST(L)
     c                   Z-ADD     ndPAGN        PAGN              9 0          LAST PAGE#
     c                   Z-ADD     ndNOTN        NOTN              9 0          LAST NOTE#
     C                   ENDDO

     C                   MOVEA     LST           SDT
     c                   if        wRtnCde = R@OK                               not done
     c                               and OK <> GetNxtNoteHdr
     c                   callp     SetRtnSts(R@WARN)                            end of list
     c                   end
     C                   Z-ADD     L             RTNREC

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $GET          BEGSR

      * check report page number (if processing segments)
     c                   if        0 > CnvToSegPage(PSegFile:PageNum)
     c                   callp     SetRtnSts(R@WARN)
     C                   GOTO      RTNPGM
     c                   end

      * NEW NOTE REQUEST
     C     OPCODE        IFNE      LOPCO                                        SAME OPCODE
     C     LRTN          ORNE      R@OK                                         NOT DONE
     C     @SPYBT        ORNE      LSPYB
     C     @SEGMT        ORNE      LSEGM
     C     PageNum       ORNE      LPAGE
     C     NOTE#         ORNE      LNOTE
/3765C     PREVID        ORNE      LREVID
     C     TIFPG#        ORNE      LTIFP
     C     BytesRem      ORLE      0                                            DONE

     C                   Z-ADD     KPAGN         KPAGNX                         PAGE#
     C                   Z-ADD     KNOTN         KNOTNX                         NOTE#
     C     KNOTD1        SETll     NOTDIR

     C     nddcod        doueq     pdcode
     C     nddtyp        andeq     pdtype
     C     ndrevi        andle     previd
     C     *IN95         oreq      *ON
     C     KNOTDp        reade(N)  NOTDIR                               9595
     C                   END

     C     *IN95         IFEQ      *ON
     C     *IN95         oreq      *OFF
     C     ndactn        andeq     'D'                                          not was deleted
     c                   callp     SetRtnSts(R@WARN)                            NOT FOUND
     C                   GOTO      RTNPGM
     C                   END

      * Check if authorized to view the notes;
J3549 /free
J3549  exsr chkSec;
J3549  if wRtnCde = R@NOTAUTH;
J3549    leavesr;
J3549  endif;
J3549 /end-free

/5635 * Add HIPAA Log for Note Retrieval
/5635c                   callp     BldLogEnt(OpCode:ndBnum:ndNotN:ndPagN:
/5635c                               ndRevi)

/6304c                   MOVEL     SDT           NLDS                           HEADER
      * notes key
     c                   clear                   NoteKeyDS
     c                   eval      nkBatNum = ndBnum
     c                   eval      nkBatSeq = ndBseq
     c                   eval      nkPagNum = ndPagN
     c                   eval      nkNotNum = ndNotN
     c                   eval      nkRevID  = ndRevI

     C                   MOVEL     NDATFL        NFILE            10            ATTACHED FILE
     C                   MOVEL     NDTYPE        TYPE              1            NOTE TYPE
/3765C                   Z-ADD     NDREVI        KREVIX                         actual revid
/3765C                   Z-ADD     NDnotn        KnotnX                         actual revid

      * INITIAL READ
     c                   eval      BytesRem = ndAlen                            Annot length
     c                   eval      BytesRead = 0
     C     NFILE         IFNE      *BLANKS
     c                   eval      rc=CheckNDfile(Nfile)
      * initial start position and length
     c                   eval      Start = 1
     c                   if        PARMS >= 22
     c                   eval      Start = StartPos+1                           Start position
     c                   if        DataLen > 0
     c                   eval      BytesRem = DataLen                           Data length
     c                   end
     c                   end
     C                   END

     C                   END
      * CONTINUATION READ

      * READ NOTES DATA
     c                   if        NFile <> *blanks
      * next read start position and length
     c                   eval      Start  = Start + BytesRead
     c                   eval      Length = BytesRem
     c                   if        Length > #BLKSZ
     c                   eval      Length = #BLKSZ                              block limit
     c                   end
      * read the notes data
     c                   eval      BytesRead = GetNoteData(NoteKeyDS
     c                                            :Start:Length:%addr(SDT))
     c                   if        BytesRead < Length
     c                   eval      BytesRem = 0                                 stop
     c                   else
     c                   eval      BytesRem = BytesRem - BytesRead
     c                   end
     c                   end
      * return status
     c                   if        BytesRem <= 0
     c                   callp     SetRtnSts(R@WARN)                            done
     c                   end
     c                   eval      RTNREC = BytesRead

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $WRITE        BEGSR
      * write/append notes

J3549 /free
J3549  exsr chkSec;
J3549  if wRtnCde = R@NOTAUTH;
J3549    leavesr;
J3549  endif;
J3549 /end-free

      * LATEST TEXT LENGTH
     C     TYPE          IFEQ      '1'                                          TEXT NOTES
     C     RTNREC        ANDGT     0                                            LENGTH
     C                   eval      BytesRem = BytesRem + RTNREC - ALEN          adjustment
     C                   Z-ADD     RTNREC        ALEN
     C                   END

      * NOTE BREAK
     C     OPCODE        IFNE      LOPCO                                        SAME OPCODE
     C     @SPYBT        ORNE      LSPYB
     C     @SEGMT        ORNE      LSEGM
     C     PageNum       ORNE      LPAGE
     C     previd        ORNE      Lrevid
     C     TIFPG#        ORNE      LTIFP
     C     BytesRem      ORLE      0                                            DONE
     C     NOTE#         ORNE      LNOTE
     C     OPCODE        ANDEQ     'APDNT'

      * write (new note)
     c                   if        OpCode = 'WRTNT'
     C                   MOVEL     SDT           NLDS                           HEADER
     C                   MOVEL     NLTYPE        TYPE                           NOTE TYPE

      * convert segment to report page for CS
/5235c                   if        @SEGMT <> *blanks and @LIBR = 'SPYCS'
/    c                   eval      kpagn = CnvFromSegPage(PSegFile:nlpagn)
/    c                   if        kpagn < 0
/    c                   callp     SetRtnSts(R@WARN)                            not a valid page#
/    c                   GOTO      RTNPGM
/    c                   end
/    c                   else
/    c                   eval      kpagn = nlpagn
/    c                   end

      * ASSIGN NEW NOTES NUMBER
     C                   Z-ADD     0             NOTE#
     C     *DTAARA       DEFINE    MNOTLCK       MNOTL             1
     C     *LOCK         IN        MNOTL                                99
     C     *IN99         IFEQ      *ON
     c                   callp     SetRtnSts(R@WARN)                            UNABLE TO LOCK
     C                   GOTO      RTNPGM
     C                   END
     C     KNOTDP        SETll     NOTDIR
     C     KNOTDP        READE(N)  NOTDIR                                 95
     C     *IN95         IFEQ      *OFF
     C     NDNOTN        ADD       1             NOTE#                          NEXT NOTE
     C                   ELSE
     C                   Z-ADD     1             NOTE#                          FIRST NOTE#
     C                   END

      * ASSIGN A NOTES FILE FOR ATTACHMENTS
     c                   eval      NFile = *blanks
     C     NXALEN        IFGT      *ZEROS
     c                   eval      rc=CheckNDfile(NFile)
     C                   END

      * WRITE A NOTES DIRECTORY REC
     C                   CLEAR                   NOTDIR
     C                   MOVEL     kBNUM         NDBNUM                         SPY/BATCH#
     C                   Z-ADD     kBSEQ         NDBSEQ                         BATCH SEQ#
     C                   Z-ADD     kPAGN         NDPAGN                         PAGE#
     C                   Z-ADD     NOTE#         NDNOTN                         NOTE#
     C                   MOVEL     USERNM        NDUSER                         USER ID

     C                   EXSR      $timex                                       time stamp
     C                   Z-ADD     YMDNUM        NDDATE
     C                   Z-ADD     TIMEX         NDTIME
     C                   move      'A'           ndactn
     C                   Z-ADD     krevi         ndrevi
     C                   Z-ADD     pdcode        nddcod
     C                   Z-ADD     pdtype        nddtyp

     C                   MOVEL     NLTYPE        NDTYPE                         NOTE/CRIT&NON-CRIT A
     C                   MOVEL     NLACOO        NDACOO                         ANNOT COORDINATES
     C                   Z-ADD     0             NDALEN
     C     NXALEN        IFGT      *ZEROS
     C                   MOVE      NXALEN        NDALEN                         BINARY ANNOT LEN
     C                   END
     C                   MOVEL     NXATYP        NDATYP                         ANNOT EXTENSION
     C     40            SUBST(P)  NLACOO        NDACOO                         CLIP LEN & EXT
/    c                   MOVEL     nxReserved    NDADTA
/6304c                   MOVE      nxStickyOpen  NDADTA
     C                   MOVEL     NFILE         NDATFL                         NOTES FILE
/4900c                   if        CurRev
     C                   WRITE     NOTDIR
     C                   FEOD      MNOTDIR
/5635
/5635 * Add HIPAA Log for Note Add/Write
/5635c                   callp     BldLogEnt(OpCode:ndBnum:ndNotN:ndPagN:
/5635c                               ndRevi)

     C                   UNLOCK    MNOTL
/4900c                   endif

      * append (existing note)
     c                   else
/4537c                   Z-ADD     KPAGN         KPAGNX                         PAGE#
/    c                   Z-ADD     KNOTN         KNOTNX                         NOTE#
     c     KNOTD1        CHAIN(n)  NOTDIR
     c                   if        not %found
     c                   callp     SetRtnSts(R@WARN)                            NOT FOUND
     C                   GOTO      RTNPGM
     c                   end
     C                   MOVEL     NDATFL        NFILE                          ATTACHED FILE
     c                   end
     C                   Z-ADD     NDALEN        ALEN              9 0          BINARY ANNOT LEN

      * notes key
     c                   clear                   NoteKeyDS
     c                   eval      nkBatNum = ndBnum
     c                   eval      nkBatSeq = ndBseq
     c                   eval      nkPagNum = ndPagN
     c                   eval      nkNotNum = ndNotN
     c                   eval      nkRevID  = ndRevI

      * Attachment data
     c                   if        OpCode = 'WRTNT'
     c                   eval      Start = 1
     c                   eval      BytesRem = ndAlen                            Annot length
     c                   eval      BytesWrtn = 0
     c                   else
      * append start position and length
     c                   eval      Start = ndALen+1                             End of Annot
     c                   eval      BytesRem = 0
     c                   eval      BytesWrtn = 0
     c                   if        PARMS >= 22 and
     c                             DataLen > 0
     c                   eval      BytesRem = DataLen                           Data length
     c                   eval      rc=CheckNDfile(NFile)
     c                   end
     c                   end

     C                   ELSE
      * CONTINUATION WRITE

      * notes data attachment
     c                   if        wRtnCde <> R@OK or
     c                               NFile = *blanks
     c                   eval      BytesRem = 0
     c                   else
      * next write start position and length
     c                   eval      Start  = Start + BytesWrtn
     c                   eval      Length = BytesRem
     c                   if        Length > #BLKSZ
     c                   eval      Length = #BLKSZ                              block limit
     c                   end
/     * suppress any changes if not the current revision
/4900c                   if        not CurRev
/    c                   eval      BytesWrtn = Length
/    c                   else
      * write the notes data
     c                   eval      BytesWrtn = WrtNoteData(NoteKeyDS
     c                                            :Start:Length:%addr(SDT))

     c                   if        OpCode = 'APDNT'
     c                              and BytesWrtn > 0
      * update appended data length
     c     KNOTD1        CHAIN     NOTDIR
     c                   if        %found
     c                   add       BytesWrtn     NDALEN                         BINARY ANNOT LEN
     c                   MOVEL     NFILE         NDATFL                         NOTES FILE
     c                   UPDATE    NOTDIR
     c                   end
     c                   end
/    c                   end
     c                   if        BytesWrtn < Length
     c                   eval      BytesRem = 0                                 stop
     c                   else
     c                   eval      BytesRem = BytesRem - BytesWrtn
     c                   end
     c                   end

     c                   END

      * remaining blocks to receive
     c                   if        BytesRem <= 0
     c                   eval      RtnRec = 0
     C     wRtnCde       IFEQ      R@OK
     C                   CLEAR                   NRDS                           NOTE RETURN DS
     C                   Z-ADD     ndNOTN        NRNOTN                         NOTE# ASSIGNED
     C                   MOVEL(P)  NDUSER        NRUSER                         USER ID
     C                   Z-ADD     NDDATE        NRDATE
     C                   Z-ADD     NDTIME        NRTIME
     C                   MOVEL(P)  NRDS          SDT                            RETURN DS
     C                   END
     c                   else
     c     BytesRem      DIV       #BLKSZ        RtnRec
     c                   MVR                     RtnRecRem         9 0
     c                   if        RtnRecRem > 0
     c                   ADD       1             RtnRec
     c                   end
     c                   end

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *   Copy/Move Notes
     C     $copy         BEGSR

     c                   movel     sdt           cpyds

/4623c     LckSupport    ifne      Sv_NotAllowed
/    c                   eval      SeqNum = 0
/    c                   eval      rc=GetRootID(cpyrev:Clh_BatchNum:SeqNum)
/    C     rc            ifeq      1
/    c                   eval      cpybat = Clh_BatchNum
/    c                   eval      cpyseq = SeqNum
/    c                   endif
/4623c                   endif

      * Read all notes and copy/move them
     c     knotdb        setll     notdir
     c                   do        *hival
/6249C                   dou       *in50 = *on
/    C     Knotdb        reade     NOTDIR                                 50
     c                   eval      KPAGNX=NDPAGN
     c                   eval      KNOTNX=NDNOTN

/6249c                   if        *in50 = *off
/    c                   if        cpyall<>'1' and                              don't copy all notes
/    c                             ndrevi > previd
     c     knotdn        setgt     notdir
/6249c                   iter
/    c                   end
/    c                   leave
/    c                   end

/    c                   enddo
     C     *IN50         ifeq      *ON
     C                   leave
     C                   END
      *     Check if non critical note
     c                   if        cpyall<>'1'                                  don't copy all notes
     c                   if        nddtyp<>pdtype or
     c                             nddcod<>pdcode
     c                   iter
     c                   endif
     c                   endif

     C     NDATFL        IFNE      *BLANKS
     C                   MOVEL     NDATFL        NFILE
      *         open note data file
     c                   eval      rc=CheckNDfile(Nfile)

/3765C                   eval      krevix=ndrevi                                actual revid
     c     knotd2        setll     notdta
     C                   DO        *hival
     c     knotd2        reade     notdta                               5050
     c   50              leave
      *    Rename/Copy note record
     c                   eval      NABNUM=cpybat
     c                   eval      NABSEQ=cpyseq
/3765C                   eval      narevi=cpyrev                                actual revid
     c                   select
     c                   when      opcode='CPYNT'
     c                   write     notdta
     c                   when      opcode='MOVNT'
     c                   update    notdta
/4537c                   other
/    c                   unlock    Mnotdta
     c                   endsl
     C                   enddo

     C                   endif

     c                   eval      ndbnum=cpybat
     c                   eval      ndbseq=cpyseq
/3765C                   eval      ndrevi=cpyrev                                actual revid

      *    Rename/Copy header record
     c                   select
     c                   when      opcode='CPYNT'
     c                   write     notdir
     c                   when      opcode='MOVNT'
     c                   update    notdir
/4537c                   other
/    c                   unlock    Mnotdir
     c                   endsl

     c                   enddo

     C                   ENDSR
      *********************************************************************************************
     C     $UPDAT        BEGSR

     C                   MOVEL     SDT           NLDS                           HEADER

/4900c                   if        not CurRev
/    c                   goto      rtnpgm
/    c                   endif

      * GET NOTE FOR UPDATE
     C                   Z-ADD     KPAGN         KPAGNX                         PAGE#
     C                   Z-ADD     KNOTN         KNOTNX                         NOTE#
     C     KNOTD1        SETll     NOTDIR

     C     nddcod        doueq     pdcode
     C     nddtyp        andeq     pdtype
     C     *IN95         oreq      *ON
     C     KNOTDN        reade     NOTDIR                               9595
     C                   END
     C     *IN95         IFEQ      *ON
     c                   callp     SetRtnSts(R@WARN)                            NOT FOUND
     C                   GOTO      RTNPGM
     C                   END

      * TIMESTAMP CHANGE
     C                   MOVEL     USERNM        NDUSER                         USER ID

     C                   EXSR      $timex                                       time stamp
     C                   Z-ADD     YMDNUM        NDDATE
     C                   Z-ADD     TIMEX         NDTIME

      * NOTE INFORMATION
     C                   MOVEL     NLTYPE        NDTYPE                         NOTE/CRIT&NON-CRIT A
     C                   MOVEL     NLACOO        NDACOO                         ANNOT COORDINATES
     C                   Z-ADD     0             NDALEN
     C     NXALEN        IFGT      *ZEROS
     C                   MOVE      NXALEN        NDALEN                         BINARY ANNOT LEN
     C                   END
     C                   MOVEL     NXATYP        NDATYP                         ANNOT EXTENSION
     C     40            SUBST(P)  NLACOO        NDACOO                         CLIP LEN & EXT
/    c                   MOVEL     nxReserved    NDADTA
/6304c                   MOVE      nxStickyOpen  NDADTA
     C                   UPDATE    NOTDIR
     c                   callp     SetRtnSts(R@OK)
     C                   Z-ADD     ndNOTN        NRNOTN                         NOTE#
     C                   MOVEL(P)  NDUSER        NRUSER                         USER ID
     C                   Z-ADD     NDDATE        NRDATE
     C                   Z-ADD     NDTIME        NRTIME
     C                   MOVEL(P)  NRDS          SDT                            RETURN DS

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $DELNT        BEGSR

      * GET NOTE FOR DELETION
     C                   Z-ADD     KPAGN         KPAGNX                         PAGE#
     C                   Z-ADD     KNOTN         KNOTNX                         NOTE#
     C     KNOTDn        SETll     NOTDIR

/4900c                   if        not CurRev
/    c                   goto      rtnpgm
/    c                   endif

     C     nddcod        doueq     pdcode
     C     nddtyp        andeq     pdtype
     C     *IN95         oreq      *ON
     C     KNOTDN        reade     NOTDIR                               9595
     C                   END
     C     *IN95         IFEQ      *ON
     c                   callp     SetRtnSts(R@WARN)                            NOT FOUND
     C                   GOTO      RTNPGM
     C                   END

/6304c                   MOVEL     SDT           NLDS                           HEADER

/3765C                   Z-ADD     NDREVI        KREVIX                         actual revid

      * CHECK AUTHORITY
     C                   EXSR      CHKSEC
     C     DLTOK         IFEQ      'N'                                          Not authorzd
     C                   unlock    MNOTDIR
     c                   callp     SetRtnSts(R@NOTAUTH)
     C                   GOTO      RTNPGM
     C                   ENDIF
     C                   EXSR      $timex                                       time stamp

      * DELETE NOTE
     C     NDATFL        IFNE      *BLANKS
     C                   MOVEL     NDATFL        NFILE
     c                   eval      rc=CheckNDfile(Nfile)
     C     *IN95         DOUEQ     *ON
     C     KNOTDN        DELETE    NOTDTA                             95
     C                   ENDDO
     C                   END

     C                   delete    NOTDir
/5635
/5635 * Add HIPAA Log for Note delete
/5635c                   callp     BldLogEnt(OpCode:ndBnum:ndNotN:ndPagN:
/5635c                               ndRevi)

     c                   callp     SetRtnSts(R@OK)

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $DELAL        BEGSR
      * DELETE ALL NOTES
/4534C     Kbnum         CHAIN     NOTDIR                             95
/    C     *IN95         DOWEQ     *OFF

/    c                   eval      Kbseq=NDbseq
/    c                   eval      Kpagnx=NDpagn
/    c                   eval      Knotnx=NDnotn

/    C     NDATFL        IFNE      *BLANKS
     c                   eval      rc=CheckNDfile(NDATFL)
/    C     *IN95         DOUEQ     *ON
/    C     KNOTDN        DELETE    NOTDTA                             95
/    C                   ENDDO
/    C                   END
/    C                   DELETE    NOTDIR
/5635
/5635 * Add HIPAA Log for Note delete
/5635c                   callp     BldLogEnt(OpCode:ndBnum:ndNotN:ndPagN:
/5635c                               ndRevi)

/    C     Kbnum         READE     NOTDIR                                 95
/    C                   ENDDO
     c                   callp     SetRtnSts(R@OK)

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $CHECK        BEGSR
      *          Set NOTTYP to 0,1,2,3 (NoNotes,Text,Annot,Text+Ann)

     C                   MOVE      *OFF          NOTTYP            1            Start w/
     C                   MOVE      *OFF          ANNNOT            1             no notes.
     C                   MOVE      *OFF          TXTNOT            1

J3618 /free
J3618  if %addr(noteFlagsP) <> *null and noteFlagsP <> *null;
J3618    noteFlags = *all'N';
J3618  endif;
J3618 /end-free

      * CHECK ONLY STARTING PAGE (IMAGE#)
     c                   if        %subst(@SpyBt:1:1) <> 'S'                    image
     C     KNOTDB        CHAIN(N)  NOTDIR                             50
     C     *IN50         DOWEQ     *OFF
     C     NDdcod        IFEQ      pdcode
     C     NDdtyp        andeq     pdtype
     C     NDrevi        andle     previd
     C     NDactn        ifne      'D'
     C     NDTYPE        IFEQ      '1'
     C                   MOVE      *ON           TXTNOT
     C                   ELSE
     C                   MOVE      *ON           ANNNOT
     C                   END
J3618c                   if        %addr(noteFlagsP) = *null or
J3618c                             noteFlagsP = *null
     C     TXTNOT        IFEQ      *ON
     C     ANNNOT        ANDEQ     *ON
     C                   LEAVE                                                  DONE
     C                   END
J3618C                   else
J3618 /free
J3618  noteFlags.array(%lookup(%subst(ndacoo:1:2):noteTypes)) = 'Y';
J3618 /end-free
J3618c                   endif
     C                   END
     C                   Z-ADD     ndpagn        Kpagnx
     C                   Z-ADD     ndnotn        Knotnx
/    C     KNotdn        setgt     NOTDIR
     C                   END
     C     KNOTDB        READE(N)  NOTDIR                                 50
     C                   ENDDO

      * CHECK PAGE RANGE
     C                   ELSE                                                   Spoolfile
     C     KNOTDP        SETLL     NOTDIR
     C     KNOTDB        READE(N)  NOTDIR                                 50
     C     *IN50         DOWEQ     *OFF
     C     NDPAGN        ANDLE     PageEnd                                      note in RANGE
     C     NDdcod        IFEQ      pdcode
     C     NDdtyp        andeq     pdtype
     C     NDrevi        andle     previd
     C     NDactn        ifne      'D'
     C     NDTYPE        IFEQ      '1'
     C                   MOVE      *ON           TXTNOT
     C                   ELSE
     C                   MOVE      *ON           ANNNOT
     C                   END
J3618c                   if        %addr(noteFlagsP) = *null or
J3618c                             noteFlagsP = *null
     C     TXTNOT        IFEQ      *ON
     C     ANNNOT        ANDEQ     *ON
     C                   LEAVE                                                  DONE
     C                   END
J3618C                   else
J3618 /free
J3618  noteFlags.array(%lookup(%subst(ndacoo:1:2):noteTypes)) = 'Y';
J3618 /end-free
J3618c                   endif
     C                   END
     C                   Z-ADD     ndpagn        Kpagnx
     C                   Z-ADD     ndnotn        Knotnx
/    C     KNotdn        setgt     NOTDIR
     C                   END
     C     KNOTDB        READE(N)  NOTDIR                                 50
     C                   ENDDO
     C                   ENDIF

     C                   SELECT
     C     TXTNOT        WHENEQ    *ON
     C     ANNNOT        ANDEQ     *OFF
     C                   MOVE      '1'           NOTTYP                         Text
     C     TXTNOT        WHENEQ    *OFF
     C     ANNNOT        ANDEQ     *ON
     C                   MOVE      '2'           NOTTYP                         Annotation
     C     TXTNOT        WHENEQ    *ON
     C     ANNNOT        ANDEQ     *ON
     C                   MOVE      '3'           NOTTYP                         Text+Annot
     C                   ENDSL

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $timex        BEGSR

      * time stamp
     C                   CALL      'MAG1047'                                    Retrieve
     C                   PARM                    YMDNUM            9 0          Date
     C                   PARM                    YMD               8
     C                   PARM                    CTIME             6
     C                   PARM                    PMSEC             3
     C                   PARM                    PUTCOF            5
     C                   PARM                    PDTS              8
     C                   PARM                    PDOW              1 0
     C                   PARM                    PLILY             7 0
     C                   PARM      'C'           POPCOD            1

/2537c                   move      CTIME         TIMEX             6 0
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     $KEYS         BEGSR

     C                   MOVEL     @SPYBT        KBNUM                          SPY/BATCH NUMBER
/    c                   eval      DocClass = RtvDocType(kbnum)
/    c                   eval      rc = RtvDmsFlgs(DocClass:LckSupport:
/    c                                            AnnoSupport:BranchSupport)

/    c     LckSupport    ifne      Sv_NotAllowed

/4749c                   if        parms < 16                                   don't us 0 as revid
/    c                   z-add     PageNum       SequenceNum                    if you didn't pass
/    c                   eval      rc=GetLRevBy_ConID(ContentID)
/    c                   eval      previd=rc
/4749c                   end

     c                   eval      SeqNum = 0
     c                   eval      rc=GetRootID(PREVID:Clh_BatchNum:SeqNum)
/    C     rc            ifeq      1
     c                   eval      KBNUM = Clh_BatchNum
     c                   eval      KBSEQ = SeqNum
     c                   endif
/5592c                   Z-ADD     0             KPAGN
     c                   endif

      * MAP TO NEW DATABASE USAGE
/    C     LckSupport    ifeq      Sv_NotAllowed
/    C     rc            oreq      0
/4537c                   Z-ADD     0             KBSEQ
/5592c                   Z-ADD     0             KPAGN
     c                   if        %subst(@SpyBt:1:1) <> 'S'                    image
     c                               or reploc = '4'                            R/DARS OPTICAL
     c                               or reploc = '5'                            R/DARS QDLS
     c                               or reploc = '6'                            IMAGEVIEW OPTICAL
     C                   Z-ADD     PageNum       KBSEQ                          PAGE IS RRN/BATCH SE
     C                   ELSE
/4537c                   if        TifPg# = 0
     C                   Z-ADD     PageNum       KPAGN                          PAGE IS PAGE#
/    c                   end
     C                   END
     C                   end

/    c                   if        KPagN = 0 and TifPg# > 0
     C                   Z-ADD     TIFPG#        KPAGN                          PAGE/START PAGE
/     * convert from segment to report page numbers
/5235c                   if        @SEGMT <> *blanks and @LIBR = 'SPYCS'
/    c                   eval      KPagN = CnvFromSegPage(PSegFile:TifPg#)      report page
/    c                   if        KPagN < 0
/    c                   callp     SetRtnSts(R@WARN)
/    C                   GOTO      RTNPGM
/    c                   end
/    c                   end
/    c                   end
     C                   Z-ADD     PageEnd       KPAGN2                         TO PAGE RANGE (LIST)
     C                   Z-ADD     NOTE#         KNOTN                          Note #
/3765C                   Z-ADD     PREVID        KREVI                          Revision id

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SETKYS        BEGSR
      *          ---------------------------------------------
      *          Set the Klist parms for both the big5 key
      *          ---------------------------------------------
     c                   if        %subst(@SpyBt:1:1) = 'S'                     report
     c                   if        not %open(MRPTDIR7)
     c                   OPEN      MRPTDIR7
     c                   end
     C     @SPYBT        CHAIN     RPTDIR                             59
     C                   MOVE      FILNAM        WFILNM           10
     C                   MOVE      JOBNAM        WJOBNM           10
     C                   MOVE      USRNAM        WUSRNM           10
     C                   MOVE      PGMOPF        WPGMNM           10
     C                   MOVE      USRDTA        WUSRDT           10
     C                   ELSE                                                   On IMAGE
     c                   if        not %open(MIMGDIR)
     C                   OPEN      MIMGDIR
     C                   END
     C     @SPYBT        CHAIN     IMGDIR                             80
     C                   MOVE      IDDOCT        WFILNM                         doc class
     C                   CLEAR                   WJOBNM
     C                   CLEAR                   WUSRNM
     C                   CLEAR                   WPGMNM
     C                   CLEAR                   WUSRDT
     C                   ENDIF
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     CHKSEC        BEGSR
      *          ------------------------------------------------
      *          Check to see if the user has the right to delete
      *          Return DLTOK=Y if OK.
      *          -----------------------------------------------
J3090 /free
J3090  if autReq = 0;
J3090    autReq = 10;
J3090  endif;
J3090 /end-free
     C                   CALL      'MAG1060'                            50
     C                   PARM      'SPYCS'       AUTCAL           10            Calling pgm AUTHOR
     C                   PARM      ' '           AUTOFF            1            No unload
     C                   PARM      'R'           AUTCHK            1            'R'eport
     C                   PARM      'R'           AUTOBT            1            'R'eport
     C                   PARM      *BLANKS       AUTOBJ           10
     C                   PARM      *BLANKS       AUTLIB           10
     C                   PARM                    WFILNM                         Report      @ASEC
     C                   PARM                    WJOBNM                         Job
     C                   PARM                    WPGMNM                         Program
     C                   PARM                    WUSRNM                         User
     C                   PARM                    WUSRDT                         User data   AUTHOR
     C                   PARM                    AUTREQ            2 0          CFG Rights?
     C                   PARM      'N'           DLTOK             1            Return Y/N
     C                   PARM      *BLANKS       AUT              25
J2586c                   parm                    aute             40
J2586c                   parm                    secOvr           10
J2586c                   parm                    noteSec

J2586 /free
J2586  monitor;
J2586    select;
J3549      when opcode = 'WRTNT';
             if %subst(ndacoo:1:2) = ' ';
               ndacoo = %subst(sdt:56:2);
             endif;
J3549        if noteSec.authAdd(%lookup(%subst(ndacoo:1:2):noteSec.type)) = 'N';
J3549          setRtnSts(R@NOTAUTH);
J3549        endif;
J2586      when usernm = nduser;
J2586        if opcode = 'DLTNU';
J2586          dltOK = noteSec.authEdit(%lookup(%subst(ndacoo:1:2):
J2586            noteSec.type));
J2586        elseif opcode = 'DLTNT';
J2586          dltOK = noteSec.authDel(%lookup(%subst(ndacoo:1:2):
J2586            noteSec.type));
J2586        endif;
J3549      when usernm <> nduser  and dltOK = 'Y';
J3549        //Power/admin user...allow delete.
J2586      when usernm <> nduser;
J3549        select;
J2586          when opcode = 'DLTNU';
J2586            dltOK = noteSec.otherEdit(%lookup(%subst(ndacoo:1:2):
J2586              noteSec.type));
J2586          when opcode = 'DLTNT';
J2586            dltOK = noteSec.otherDel(%lookup(%subst(ndacoo:1:2):
J2586              noteSec.type));
J3549          when opcode = 'GETNT';
J3549            if noteSec.otherView(%lookup(%subst(ndacoo:1:2):
J3549              noteSec.type)) = 'N';
J3549              setRtnSts(R@NOTAUTH);
J3549            endif;
J2586        endsl;
J2586    endsl;
J2586    on-error;
J2586  endmon;
J2586 /end-free

     C     ENDSEC        ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
      *          -------------------------------
      *          Initial Subroutine
      *          -------------------------------
     C                   IN        SYSDFT                                       Defaults

      * MAX NOTE FILE SIZE (MB)
     C     MAXNFZ        IFEQ      *BLANKS
     C     MAXNFZ        OREQ      *ZEROS
     C                   MOVE      '00100'       MAXNFZ                         DFT 100 MB
     C                   END
     C                   Z-ADD     0             MaxRecs           9 0
     C                   MOVE      MAXNFZ        MaxRecs
     C                   MULT      1000          MaxRecs


     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/3765C     $INIT         BEGSR
/     * BUMP THE INIT COUNT EACH CALL
     C                   callp     DmsInit
/    C                   ADD       1             IQCNT             5 0
/    C                   RETURN
/    C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
      *          -------------------------------
      *          Delete overrides and shutdown.
      *          -------------------------------

/3765C                   SUB       1             IQCNT
/4698C     IQCNT         IFGe      0                                            m/b NOT YET
/4698C                   callp     DmsQuit
/4698C     IQCNT         IFGt      0                                            NOT YET
     C                   RETURN                                                 Pgm
/    C                   END
/    C                   END

     c                   callp     GetNum('QUIT')
     C                   CLOSE     *ALL
     C                   MOVE      *ON           *INLR                          Shutdown
     c                   EXSR      RETRN

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     c     RETRN         BEGSR

      * return status
     c                   if        PARMS > 11
     c                   eval      RtnCde = wRtnCde                             Return code
     c                   if        PARMS >= 20
     c                   eval      errid  = wRtnID                              Msg id
     c                   eval      errdta = wRtnDta                             Msg data
     c                   end
     c                   end
     c                   RETURN

     c                   ENDSR
      **************************************************************************
     p CurRev          b
      * Allow write, update or delete functions only to the current revision.
      * Otherwise, return message.
     d                 pi              n

     d RtnVal          s               n

     c                   eval      RtnVal = '1'
     c                   if        parms > 15 and RevID > 0 and
     c                             RevID <> GetHedBy_RevID(RevID) and
     c                             RevID <> GetWIPBy_RevID(RevID)
     c                   eval      RtnVal = '0'
     c                   callp     SetRtnSts(wRtnCde:'DMS0130')
     c                   endif

     c                   return    RtnVal
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get next note header
     p GetNxtNoteHdr   b
     d                 pi            10i 0

/3765C                   dou       ndactn <> 'D' and
/    C                             nddcod = pdcode and
/    C                             nddtyp = pdtype and
/    C                             ndrevi <= previd or
/    C                             *in88 = *on
     C                   SELECT
     C     KPAGN         WHENEQ    0                                            ALL PAGES
     C     KNOTDB        READE(N)  NOTDIR                                 88
     C     KPAGN         WHENEQ    KPAGN2                                       SPECIFIC PAGE#
     C     KNOTDP        READE(N)  NOTDIR                                 88
     C                   OTHER                                                  PAGE RANGE
     C     KNOTDB        READE(N)  NOTDIR                                 88
/5592c  N88NDPAGN        COMP      KPAGN2                             88
     C                   ENDSL
     C                   Z-ADD     ndnotn        Knotnx
     C                   Z-ADD     ndpagn        kpagnx
/    C                   if        ndrevi > previd and
/    C                             *in88 = *off
/    C     Knotd1        setll     NOTDIR
/    c                   else
/    C     KNotdn        setgt     NOTDIR
/    c                   end
/    c                   enddo

     c   88              return    FAIL
     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get notes data
     p GetNoteData     b
     d                 pi            10i 0
     d NoteKey                             const like(NoteKeyDS)
     d StartPos                      10i 0 const
     d Length                        10i 0 const
     d Buffer                          *   const

     d RecSeq          s             10i 0
     d RecPos          s             10i 0
     d DataP           s               *
     d DataLen         s             10i 0
     d TargetP         s               *
     d TotalLen        s             10i 0

     c                   eval      NoteKeyDS = NoteKey
     c                   eval      TargetP = Buffer
     c                   eval      TotalLen = 0

      * get start record/byte
     c                   callp     GetBlockPos(StartPos:%size(nadata)
     c                                                 :RecSeq:RecPos)
     c                   eval      nkNotSeq = RecSeq
     c     KNotDtaSeq    setll     notdta

      * read data
     c                   eval      DataP   = %addr(naData)+RecPos-1
     c                   eval      DataLen = %size(naData)-RecPos+1
     c                   dow       TotalLen < Length
/4537c     KNotDta       reade(n)  notdta
     c                   if        %eof
     c                   leave
     c                   end
      * copy data
     c                   if        DataLen > Length-TotalLen
     c                   eval      DataLen = Length-TotalLen
     c                   end
     c                   callp     memcpy(TargetP:DataP:DataLen)
     c                   eval      TotalLen = TotalLen + Datalen
     c                   eval      TargetP = TargetP + Datalen
      * next block
     c                   eval      DataP   = %addr(naData)
     c                   eval      DataLen = %size(naData)
     c                   enddo

     c                   return    TotalLen
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * write notes data
     p WrtNoteData     b
     d                 pi            10i 0
     d NoteKey                             const like(NoteKeyDS)
     d StartPos                      10i 0 const
     d Length                        10i 0 const
     d Buffer                          *   const

     d RecSeq          s             10i 0
     d RecPos          s             10i 0
     d DataP           s               *
     d DataLen         s             10i 0
     d SourceP         s               *
     d TotalLen        s             10i 0

     d DtlType         s              5u 0 inz(0)
     d DtlNamLen       s              5u 0 inz(0)
     d DtlValLen       s              5u 0 inz(0)

     c                   eval      NoteKeyDS = NoteKey
     c                   eval      SourceP = Buffer
     c                   eval      TotalLen = 0

      * setup for notes detail logging
/5635 * removed - Notes logging detail specs are not complete at this time.
/5635c*****              eval      DtlType = #DTADDANO
/5635c*****              eval      DtlValLen = Length
/5635c*****              eval      rc = AddLogDtl(%addr(LogDS):DtlType:*NULL:
/5635c*****                          DtlNamLen:Buffer:DtlValLen)

      * get start record/byte
     c                   callp     GetBlockPos(StartPos:%size(nadata)
     c                                                 :RecSeq:RecPos)

      * append a partial record
     c                   if        RecPos > 1
     c                   eval      nkNotSeq = RecSeq
     c     KNotDtaSeq    chain     notdta
     c                   if        %eof
     c                   return    TotalLen
     c                   end
     c                   eval      DataP   = %addr(naData)+RecPos-1
     c                   eval      DataLen = %size(naData)-RecPos+1
     c                   exsr      copydata
     c                   update    notdta
     c                   eval      RecSeq = RecSeq + 1
     c                   end

      * write new records
     c                   eval      NoteKeyDS = NoteKey
     c                   eval      naBnum = nkBatNum
     c                   eval      naBseq = nkBatSeq
     c                   eval      naPagN = nkPagNum
     c                   eval      naNotN = nkNotNum
     c                   eval      naRevI = nkRevID
     c                   eval      naNseq = RecSeq
     c                   eval      DataP   = %addr(naData)
     c                   eval      DataLen = %size(naData)
     c                   dow       TotalLen < Length
     c                   eval      naData = *blanks
     c                   exsr      copydata
     c                   write     notdta
     c                   eval      naNseq = naNseq + 1
     c                   enddo

     c                   return    TotalLen
      * ---------------------------------------------------------------------- *
     c     copydata      begsr

     c                   if        DataLen > Length-TotalLen
     c                   eval      DataLen = Length-TotalLen
     c                   end
     c                   callp     memcpy(DataP:SourceP:DataLen)
     c                   eval      TotalLen = TotalLen + Datalen
     c                   eval      SourceP = SourceP + Datalen

     c                   endsr
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * get the page segment file from Report/Segment ID
/5235p GetPSegFile     b
     d                 pi            10
     d SpyNbr                        10    const
     d PagSegID                      10    const
     d SpyNbrLast      s                   like(SpyNbr) static
     d PagSegIDLast    s                   like(PagSegID) static

     c                   if        PagSegID = *blanks
     c                   return    *blanks
     c                   end
      * check if changed
     c                   if        SpyNbrLast <> SpyNbr or
     c                             PagSegIDLast <> PagSegID
     c                               or not %open(RSEGHDR)
     c                   eval      SpyNbrLast =  SpyNbr
     c                   eval      PagSegIDLast = PagSegID
     c                   eval      SHSFIL = *blanks

     c                   if        not %open(MRPTDIR7)
     c                   OPEN      MRPTDIR7
     c                   end
     c                   if        not %open(RSEGHDR)
     c                   OPEN      RSEGHDR
     c                   end
     c     SpyNbr        CHAIN     RPTDIR
     c                   if        %found
     c     SegHdrKey     klist
     c                   kfld                    RptTyp
     c                   kfld                    PagSegID
     c     SegHdrKey     CHAIN     SEGHDR
     c                   end

     c                   end
      * page segment file
     c                   return    SHSFIL
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert from segment to report page number
     p CnvFromSegPage  b
     d                 pi            10i 0
     d PagSegFile                    10    const
     d PageNbr                       10i 0 const

     d PTrec           s             10i 0
     d PTpos           s             10i 0

      * check page segment
     c                   if        PSegFile = *blanks
     c                               or PageNbr = 0
     c                   return    PageNbr
     c                   end
     c                   if        OK <> ChkPSegFile(PagSegFile)
     c                   return    -1
     c                   end
      * get page table record/element
     c                   callp     GetBlockPos(PageNbr:PTmax:PTrec:PTpos)
     C                   Z-ADD     PTrec         SGSEQ
     C     PGKEY         CHAIN     RSEGMNT
     c                   if        not %found
     c                   return    -1
     c                   end
     c                   return    PT(PTpos)
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * convert from report to segment page number
/5235p CnvToSegPage    b
     d                 pi            10i 0
     d PagSegFile                    10    const
     d PageNbr                       10i 0 const

      * check page segment
     c                   if        PSegFile = *blanks
     c                               or PageNbr = 0
     c                   return    PageNbr
     c                   end
     c                   if        OK <> ChkPSegFile(PagSegFile)
     c                   return    -1
     c                   end
      * find the segment page number
     c                   exsr      PAGCHK
     c                   return    -1
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PAGCHK        BEGSR
      *          -------------------------------------------------
      *          Check to see if notes requested is from a segment
      *          the user has access to. Use binary search algorithm
      *          -------------------------------------------------
     c     PageNbr       IFLT      PTfirst                                      Page outside
     c     PageNbr       ORGT      PTlast                                       this segment
     c                   return    -1
     c                   END

     c     PageNbr       IFGE      PTBEG                                        Page is
     c     PageNbr       ANDLE     PTEND                                        already
     C                   GOTO      NORDPT                                       in the pgtbl
     C                   END

     C                   Z-ADD     0             #PPTRS            9 0
     C                   Z-ADD     BGREC         #PPTRE            9 0
     C                   Z-ADD     BGREC         #PPTRR            9 0

     C                   DO        *HIVAL
     c     PageNbr       IFLT      PTBEG
     C     #PPTRS        ADD       #PPTRR        #TSUM             9 0          Retrieve
     C                   END                                                    the proper
     c     PageNbr       IFGT      PTEND                                        and put it
     C     #PPTRE        ADD       #PPTRR        #TSUM                          into the
     C                   END                                                    pgtbl
     C     #TSUM         DIV       2             #PPTRR                            |
     C     #PPTRS        IFEQ      #PPTRR                                          |
     c                   return    -1
     C                   END
     C                   EXSR      PPGCHN
     c     PageNbr       IFGE      PTBEG
     c     PageNbr       ANDLE     PTEND
     C                   LEAVE
     C                   END
     c     PageNbr       IFLT      PTBEG
     C                   Z-ADD     #PPTRR        #PPTRE
     C                   END
     c     PageNbr       IFGT      PTEND
     C                   Z-ADD     #PPTRR        #PPTRS
     C                   END
     C                   ENDDO

     C     NORDPT        TAG
     c                   DO        PTmax         #TSUM
     c     PageNbr       IFLT      PT(#TSUM)                                    not found
     c                   return    -1
     C                   END
     c     PageNbr       IFEQ      PT(#TSUM)                                    found
     c                   return    PTmax * (SGSEQ-1) + #TSUM
     C                   END
     C                   ENDDO

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     PPGCHN        BEGSR
      *          -------------------------------
      *          Partial page table chain
      *          -------------------------------
     C                   Z-ADD     #PPTRR        SGSEQ
     C     PGKEY         CHAIN     RSEGMNT                            51
     C                   Z-ADD     PT(1)         PTBEG
     C                   Z-ADD     PT(PTmax)     PTEND
     C     PTEND         IFEQ      0
     C                   Z-ADD     PTlast        PTEND
     C                   END
     C                   ENDSR
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * check/open the page segment file
     p ChkPSegFile     b
     d                 pi            10i 0
     d PagSegFile                    10    const
     d PagSegLast      s                   like(PagSegFile) static

     c                   if        PagSegLast <> PagSegFile
     c                               or not %open(RSEGMNT)
     c                   eval      PagSegLast =  PagSegFile
     C                   CLOSE     RSEGMNT
     c                   eval      Cmd='OVRDBF FILE(RSEGMNT) TOFILE('
     c                               +%trim(DtaLib)+'/'+%trim(PagSegFile)+')'
     c                   eval      rc=CLcmd(Cmd)
     C                   OPEN      RSEGMNT                              99
     c                   eval      rc=CLcmd('DLTOVR FILE(RSEGMNT)')
     c                   if        *in99
     c                   callp     SetRtnSts(R@WARN)
     c                   return    FAIL
     c                   end
     C                   exsr      SegData
     c                   end

     c                   return    OK
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SegData       BEGSR
      *          ---------------------------------
      *          Open Segment Table for note pages
      *          and retrieve the beginning and
      *          ending page.
      *          ---------------------------------
     C                   EXSR      LSGPG#                                       Load first/last

     C     PTlast        IFEQ      0
     c                   callp     SetRtnSts(R@WARN)
     c                   return    FAIL
     C                   ENDIF

     C                   Z-ADD     1             SGSEQ                          Get the 1st
     C     PGKEY         CHAIN     RSEGMNT                            51
     C                   Z-ADD     PT(1)         PTBEG
     C                   Z-ADD     PT(1)         PTfirst

     C     PT(PTmax)     IFEQ      0                                            contains
     C                   Z-ADD     PTlast        PTEND                          the whole
     C                   ELSE                                                   segment
     C                   Z-ADD     PT(PTmax)     PTEND
     C                   ENDIF

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     LSGPG#        BEGSR
      *          ---------------------------------------------
      *          Retrieve the last page # of the PgTbl segment
      *          ---------------------------------------------
     C                   Z-ADD     0             BGREC
     C                   MOVE      *ALL'9'       SGSEQ                          Set to the
     C     PGKEY         SETLL     RSEGMNT                                      last record
     C     @SPYBT        READPE    RSEGMNT                                50    of segment
     C     *IN50         IFEQ      *ON
     c                   callp     SetRtnSts(R@WARN)
     c                   return    FAIL
     c                   end

     C                   Z-ADD     SGSEQ         BGREC

     C                   Z-ADD     1             #T                3 0
     C                   Z-ADD     0             Zero7             7 0
     C     Zero7         LOOKUP    PT(#T)                                 50
     C     *IN50         IFEQ      *ON
     C                   SUB       1             #T                             Retrieve the
     C     #T            IFLT      1                                            last pg# for
     C                   Z-ADD     1             #T                             the segment
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     PTmax         #T
     C                   ENDIF
     C                   Z-ADD     PT(#T)        PTlast

     C                   ENDSR
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * check/assign the notes data file
     p CheckNDfile     b
     d                 pi            10i 0
     d NotesFile                     10
     d NotesFileLast   s                   like(NotesFile) static

     c                   eval      rc = OK
      * assign latest notes file
     c                   if        NotesFile = *blanks
     c                   callp     GetNum('PEEK':'NOTES':NotesFile)
     c                   eval      rc=OpenNDfile(NotesFile)
     c                   if        rc=OK and fiRecs >= MaxRecs                  max size
     c                   callp     GetNum('GET':'NOTES':NotesFile)
     c                   eval      rc=OpenNDfile(NotesFile)
     c                   end
     c                   else
      * switch to existing notes file
     c                   if        NotesFileLast <> NotesFile
     c                               or not %open(MNOTDTA)
     c                   eval      rc=OpenNDfile(NotesFile)
     c                   end
     c                   end
     c                   eval      NotesFileLast =  NotesFile
     c                   return    rc
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * open the notes data file
     p OpenNDfile      b
     d                 pi            10i 0
     d NotesFile                     10    const

     c                   close     MNOTDTA
      * check notes data file
     C                   CALL      'MAG1036'                                    If
     C                   PARM                    @ERRMG           80            does not
     C                   PARM      DtaLib        CRTLIB           10            exist,
     C                   PARM      NotesFile     CRTOBJ           10
     C                   PARM      '*FILE'       CRTTYP           10
     C     @ERRMG        IFNE      *BLANKS                                      ERROR
      * create notes data file
     c                   eval      Cmd='CRTDUPOBJ OBJ(MNOTDTA) OBJTYPE(*FILE) +
     c                               FROMLIB('+%trim(PgmLib)+') +
     c                                 TOLIB('+%trim(DtaLib)+') +
     c                                NEWOBJ('+%trim(NotesFile)+') DATA(*NO)'
     C                   CALL      'MAG1030'
     C                   PARM                    CRTRTN            1
     C                   PARM      DtaLib        CRTLIB           10
     C                   PARM      NotesFile     CRTOBJ           10
     C                   PARM      '*FILE'       CRTTYP           10
     C                   PARM      Cmd           CRTCMD          255
     C                   END

      * open notes data file
     c                   eval      Cmd='OVRDBF FILE(MNOTDTA) TOFILE('
     c                               +%trim(DtaLib)+'/'+%trim(NotesFile)+')'
     c                   if        OK = CLcmd(Cmd)
     C                   open      MNOTDTA                              99
     c                   if        *in99
     c                   return    FAIL
     c                   end
     c                   end

     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * determine block and position
     p GetBlockPos     b
     d                 pi
     d Position                      10i 0 const
     d BlockSize                     10i 0 const
     d Block                         10i 0
     d BlockPos                      10i 0
     c     Position      DIV       BlockSize     Block
     c                   MVR                     BlockPos
     c                   if        BlockPos > 0
     c                   eval      Block = Block + 1
     c                   else
     c                   eval      BlockPos = BlockSize
     c                   end
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * set return status
     p SetRtnSts       b
     d                 pi
     d RtnCode                        2    const
     d MsgID                          7    const options(*nopass)
     d MsgData                      100    const options(*nopass)
     c                   clear                   wRtnDS
     c                   eval      wRtnCde = RtnCode
     c                   if        %parms >= 2
     c                   eval      wRtnID  = MsgID
     c                   if        %parms >= 3
     c                   eval      wRtnDta = MsgData
     c                   end
     c                   end
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * execute a CL command
     p CLcmd           b
     d                 pi            10i 0
     d  cmd                        1024    const                                CL command
     d QCmdExc         pr                  extpgm('QSYS/QCMDEXC')
     d  cmd                        1024    const                                command
     d  cmdLen                       15  5 const                                command length
     c                   callp     QCMDEXC(cmd:%size(cmd))
     c                   callp     RcvMsg
     c                   return    OK
     p                 e
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      * receive a message
     p RcvMsg          b
     d                 pi

     d QMHRcvPm        pr                  extpgm('QSYS/QMHRCVPM')
     d  MsgInfo                       1    options(*varsize)                    msg info
     d  MsgInfoLn                    10i 0 const                                msg info length
     d  MsgInfoFmt                    8    const                                msg info format
     d  CStack                       10    const                                call stack entry
     d  CStackC                      10i 0 const                                call stack counter
     d  MsgType                      10    const                                msg type
     d  MsgKey                        4    const                                msg key
     d  WaitTime                     10i 0 const                                wait time
     d  MsgAction                    10    const                                msg action
     d  ErrorDS                       1    options(*varsize)                    API error struct

     c                   callp     QMHRcvPm(MsgInfo:%size(MsgInfo):
     c                                     'RCVM0100':'*':1:'*LAST':*BLANKS:
     c                                      0:'*REMOVE':APIerrDS)
     p                 e
/5635 *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
/5635p BldLogEnt       b
/5635
/5635d                 pi
/5635d opCode                         5a   const
/5635d SpyNbr                        10a
/5635d NoteNbr                       10i 0 value
/5635d PageNbr                       10i 0 value
/5635d RevID                         10i 0 value
/5635
/5635 * determine logging code based on the operation being performed
/5635c                   select
/5635
/5635 * retreive note
/5635c                   when      Opcode = 'GETNT'
/5635c                   eval      LogOpCode = #AURTVANO
      * add note
     c                   when      OpCode = 'UPDNT' or
/5635c                             Opcode = 'APDNT' or
/5635c                             Opcode = 'WRTNT'
/5635c                   eval      LogOpCode = #AUADDANO
/5635
/5635 * change note
/5635c                   when      Opcode = 'CPYNT' or
/5635c                             Opcode = 'MOVNT'
/5635c                   eval      LogOpCode = #AUCHGANO
/5635
/5635 * delete note
/5635c                   when      %subst(Opcode:1:4) = 'DLTN'
/5635c                   eval      LogOpCode = #AUDLTANO
/5635
/5635c                   other
/5635c                   return
/5635c                   endsl
/5635
/5635 * build log header
/5635c                   eval      LogUserID = usernm
/5635c                   eval      LogObjID  = SpyNbr
/5635c                   eval      LogNotNbr = NoteNbr
/5635c                   eval      LogPagNbr = PageNbr
/5635c                   eval      LogRevID = RevID
/5635c                   callp     LogEntry(%addr(LogDS))

/5635c                   return
/5635p                 e
**ctdata noteTypes
bo
rs
tn
sn
hi
au
bl

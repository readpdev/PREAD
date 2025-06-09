     h dftactgrp(*no) actgrp('DOCMGR') bnddir('SPYSTGIO':'SPYBNDDIR')
      **********-----------------------
      * MAG1091  Move DATA from optical
      **********-----------------------
      *
J3068 * ******NOTE******
J3068 * Any changes made to the program should be duplicated in MAG1091NAG.
J3068 * This is a copy of MAG1091 source with the actgrp set to MAG1091 for the
J3068 * purposes of Tivoli Storage Manager conversation requiring a single
J3068 * session per file being written. Easiest method for changes is to
J3068 * checkout MAG1091NAG, replace it with the modified MAG1091,
J3068 * change the named actgrp of MAG1091 and check in.
      *
      *   1) Open the optical file shared read.
      *   2) Set the starting byte to read from the file (OFFSET).
      *   3) Read the requested amount of data, DTASIZ, max 131,072.
      *   4) Return data structure DTA.  128x1024 (131,072 bytes)
      *   5) Set DTASIZ to the number of bytes put into DTA.
      *   6) Handle HFS optical errors.
      *
      * Parameters:
      *   VOL     Volume label of the platter, not the vol control id
      *   DIR     Directory path for the input file
      *             (eg. SPYGLASS/library/folder/
      *   FILE    Name of the file to be read.
      *   EOFSET  Byte number from which to start reading
      *             If EDTASZ = -1, file size is returned here.
      *   DTA     Returned data.
      *   EDTASZ  Data size requested to read, up to 131072 (128K)
      *             If -1, file size will be returned in EOFSET.
      *   ECLSP   Close down program indicator. (1= shutdown)
      *   RTN     Returned indicator (0=OK, 1=Error)
      *
J3729 * 09-26-11 PLR Calculation while restoring AP file page table pointer
      *              records, not correct when only single record exists.
      *              Bad length calculated on 2 space (hex) values being in
      *              the last 2 positions of the buffer for the record.
      *              Extended that check for 2 more bytes to make sure this
      *              is not a single record restore.
J3068 * 12-02-10 PLR Add support for Tivoli Storage Manager. See notation in
      *              preamble above.
/4581 * 03-05-07 EPG In instances where Links are created in a foreign
/4581 *              language, moved to IBM LANATT in English, and
/4581 *              attempted to be retrieved using the foreign language
/4581 *              then those links could not be retrieved.
/4581 *              Accomodate this for scenario by forcing a second
/4581 *              open attempt with the doclink prefix character to
/4581 *              to be x'7C'.
/4581 * 02-22-07 EPG Revert the call to SpyStgOpn from four parameters
/4581 *              to three parameters excluding the previous CCSID
/4581 *              addition.
/4581 * 12-07-06 EPG Accomodate a similar scenario for French (CCSID 297)
/4581 *              and Polish (CCSID 870).
/4581 * 11-16-06 EPG When reading files to Optical adopt the CCSID of the
/4581 *              the generic type 65535. Also, get the current job's
/4581 *              CCSID. If the CCSID is 273 (German) and the first
/4581 *              character of the link file contains 7C (representative
/4581 *              of an @ in code page 37) Change that first character
/4581 *              to a hex B5 in order to comply with the unicode value
/4581 *              of @ for the german code page.
/8837 * 02-19-04 GT  Fix read size for change #8619 (was reading 380
/     *              bytes, needs to read 381 to get last byte of bad
/     *              record and first byte of next record)
/8678 * 10-27-03 GT  Problems with retrieving FileClerk documents:
/     *              1) First buffer file size was being overwritten by
/     *                 image data in REDFIL
/     *              2) GETSIZ routine was leaving file positioned to eof,
/     *                 so subsequent reads would not return any data
/8619 * 09-24-03 PLR Compensate for incorrect page table record length
/     *              when archiving directly to optical. This affected
/     *              PCL files only. The function wrtpgtdta in spysplio
/     *              caused the problem. When writing the page table, it
/     *              used a 380 byte record length instead of 379.
/4425 *  8-27-01 KAC Fix problem with large report looping
/4901 *  7-05-01 KAC Fix problem with child program shutdown.
/4744 *  6-01-01 KAC Use opt volume for FileClerk base 50 names.
/3321 * 12-29-00 KAC REMOVE OPT ID (OBSOLETE AS OF 6.0.6)
      *  8-16-99 KAC RETURN ACTUAL ERROR MESSAGE ID ON OPTICAL ERROR.
      *  1-29-99 KAC Add retrieval of conversion file documents
      *  1-12-99 KAC Revise fileclerk image file processing
      * 11-06-98 KAC Revise imageplus child pgm name
      *  7-27-98 KAC Add retrieval of IMAGEPLUS documents.
      *  3-01-98 KAC Add retrieval of IMAGEVIEW documents.
      *  7-23-97 GT  Add File size retrieval option
      *  7-22-96 JJF Add MagServer (OPTTYP=M).
      *  7-15-96 KC  Add retrieval of FileClerk documents.
      *              Add access to Shared Folders.
      *  8-28-95 GT  Change MSG array entries to message IDs
      *              Add RTVMSG subroutine
      *  8-28-95 DM  Do not error if bytes to read do not equal actual
      *              bytes read ..  see REDOPT
      *  8-01-95 DM  Program created
      *
      *
     D CMD             S             69    DIM(4) CTDATA PERRCD(1)              CL Cmds
     D PGM             S             10    DIM(100) ASCEND                      Open child pgm

     D/copy @IFSIO
     D/copy @SPYSTGIO
/8619 /copy @memio
/4581 /copy qsysinc/qrpglesrc,qusrjobi

/4581dGetJobCCSID      pr            10i 0
/4581d puintJobCCSID                 10u 0
/4581d pDsEc                               likeds(adsEC) options(*nopass)

      * Constants ------------------------------------------------------------------------
/4581dSUCCESS          c                    0
/4581dERROR            c                    -1
/4581d CCSID_GERMAN    s             10u 0 inz(273)
      * Job CCSID for German
/4581d CCSID_FRENCH    s             10u 0 inz(297)
      * Job CCSID for French
/4581d CCSID_POLISH    s             10u 0 inz(870)
      * Job CCSID for Polish
/4581d CCSID_LINK37    s              1a   inz(x'7C')
      * Hex character for @ in CCSID 37
/4581d CCSID_LINK273   s              1a   inz(x'B5')
      * Hex character for @ in CCSID 273
/4581d CCSID_LINK297   s              1a   inz(x'44')
      * Hex character for @ in CCSID 297
/4581d CCSID_LINK870   s              1a   inz(x'7C')
      * Hex character for @ in CCSID 870

/4581d auintJobCCSID   s             10u 0
      * Current Jobs CCSID
/4581dstrLibFile       s            256a
/4581duintCCSID        s             10u 0 inz(65535)
/4581duintJobCCSID     s             10u 0 inz(0)

      * Data Structures ------------------------------------------------------------------
/4581d aDSEc           ds
/4581d  dsECBytesP             1      4I 0 inz(256)
/4581d  dsECBytesA             5      8I 0 inz(0)
/4581d  dsECMsgID              9     15
/4581d  dsECReserv            16     16
/4581d  dsECMsgDta            17    256

/4581 * physical file code page
/4581d pfstat          ds                  likeds(stat_ds)
/4581 * physical file status
     d bufptr          s               *
     d buffer          s          32767a   based(bufptr)
     d buflen          s             10i 0
     d rtncde          s             10i 0
     d fildes          s             10i 0
     d relofs          s             10i 0
/8678d curofs          s             10i 0
     d err_msgid       s              7
     d err_msgdta      s            256

     D SYSDFT          DS          1024
      *             System Environment
     D  PGMLIB               296    305
     D  DTALIB               306    315

     D @MSGDT          DS           103
      *             Message handling
     D  ERRLEN                 9     12i 0
     D  @EM                   25    103    DIM(79)                              Error Message

     D PTRINF          DS
      *             Optical file changing ptr
     D  STRLOC                 1      1
     D  RSV4                   2      6
     D ATTRLN          DS
      *             Optical attr length
     D  ATTRL                  1      4i 0

     D DTA             s           1024    DIM(128)
      *             Data Buffer - 128K     (131,072 bytes)

      *             Stream File Size
     D  FSIZE          s             10i 0
/8678D  FSIZEA         s              9
      *             Binaries
     d  BYT2RD         s             10i 0
     d  BYTRED         s             10i 0
     d  PATHL          s             10i 0
     d  MSGL           s             10i 0
     d  MSGDTL         s             10i 0
     d  DSTMOV         s             10i 0
     d  NEWPTR         s             10i 0

     D MSGCD           DS           116
      *             API return code for Msgs
     D  ERLENM                 1      4i 0
     D  CONDTM                 9     15
     D  MSGDTM                17    116

      *  Binaries
     d  INFLEN         s             10i 0
     d  STKCNT         s             10i 0
/8619d badlen          s               n   inz('0')
/    d STDPGTLEN       c                   379
/    d BADPGTLEN       c                   380
/    d pgtP            s               *
/    d bufsiz          s             10i 0
/    d clcrec          s             10i 0

     D MSGINF          DS           100

     D ERRCD           DS           116
      *             Api error code
     D  @ERLEN                 1      4i 0 INZ(116)
     D  @ERCON                 9     15
     D  @ERDTA                17    116
     D  @ED                   17    116    DIM(100)                             Error msgdta

     D                SDS
      *             Program status
     D  PGMERR           *STATUS
     D  PGMLIN                21     28
     D  SYSERR                40     46
     D  JOBNUM               264    269

      * Child program name
     D @UC             C                   CONST('ABCDEFGHIJKLMNOPQRS-                UPPERCASE
     D                                     TUVWXYZ')
     D @LC             C                   CONST('abcdefghijklmnopqrs-                LOWERCASE
     D                                     tuvwxyz')
     D @VF             C                   CONST('@$#')                               VALID 1ST CHAR
     D @VS             C                   CONST('01234567890_')                      VALID 2ND CHAR
     D @IC             C                   CONST('~`!%^&*()-+=|\[]{}-                 INVALID CHAR
     D                                     :;"''<>,.?/')
     D @RC             C                   CONST('@@@@@@@@@@@@@@@@@@-                 REPLACEMENT
     D                                     @@@@@@@@@@')

     D PSCON           C                   CONST('PSCON     *LIBL     ')
     D QTEMP           C                   CONST('QTEMP/')
     D BLNK10          C                   CONST('          ')

J3068D devpath         s            120
J3068D devtyp          s             10
J3068D devnam          s             10

      ****************************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    EOPID            10            OptId
     C                   PARM                    EDRV             15            Opt Drive
     C                   PARM                    EVOL             12            Volume
     C                   PARM                    EDIR             80            Sub dir
     C                   PARM                    EFILE            12            File name
     C                   PARM                    EOFSET           13 0          Start offset
     C                   PARM                    DTA                            Rtn data
     C                   PARM                    EDTASZ            6 0          Size of data
     C                   PARM                    ECLSP             1            Close pgm
     C                   PARM                    ELOC              1            Storage Loc
     C                   PARM                    ETYP              1            DocumentType
     C                   PARM                    EMSGID            7            Return msgid
     C                   PARM                    EMSGDT          100            Return msgdt

     C     ECLSP         IFEQ      '1'                                          Shutdown
     C     EDTASZ        ANDEQ     0                                            program
     C                   EXSR      QUIT
     C                   END
      *    Set child program etc.
/4901c                   eval      EMsgID = 'ERR1089'                           Default err
     C                   EXSR      SETFIL                                       Set file pgm
      *    If program is child, exit here
     C     child         IFNE      1                                            Child
     C     ECLSP         IFEQ      '1'                                           shutdown
     C                   EXSR      QUIT
     C                   END
     C                   RETURN
     C                   END
      *    If no child program, go ahead and open file for read
     C                   EXSR      OPNFIL                                       Open file

     C     EDTASZ        IFNE      -1                                           Read request
     C                   EXSR      REDFIL
     C                   ELSE                                                       or
     C                   EXSR      GETSIZ                                       File size rq
     C                   Z-ADD     FSIZE         EOFSET
     C                   END

     C     ECLSP         IFEQ      '1'                                          Shutdown
     C                   EXSR      QUIT
     C                   END

     C                   MOVE      *BLANKS       EMSGID
     C                   MOVE      *BLANKS       EMSGDT
     C                   RETURN
      ****************************************************************************
     C     *INZSR        BEGSR

     C                   Z-ADD     116           ERLENM
     C                   MOVE      EOPID         SOPID            10            Volume OPID
     C                   MOVE      EDRV          SDRV             15            Volume DRIV
     C                   MOVE      EVOL          SVOL             12            Volume CtlId
     C                   MOVE      EDIR          SDIR             80            Sub dir
     C                   MOVEL     EFILE         SVFILE           12            File
     C                   MOVE      ELOC          SLOC              1            Storage Loc
     C                   MOVE      ETYP          STYP              1            Document Typ

     C     *DTAARA       DEFINE                  SYSDFT                         Get System
     C                   IN        SYSDFT                                       Defaults

     C     DTALIB        IFEQ      *BLANKS                                      Data lib
     C                   MOVEL     'SPYGLASS'    DTALIB
     C                   END

     C                   CALL      'MAG1034'                                    Is this a
     C                   PARM      ' '           JOBTYP            1            batch job?
     C     JOBTYP        IFEQ      '1'
     C                   MOVE      'M'           JOBTYP                         M=Manual
     C                   END                                                     (used for
     C                   ENDSR                                                    err msgs)
      ****************************************************************************
      *          Set the Child Program(file) and pass-thru
     C     SETFIL        BEGSR

     C     CHILDP        PLIST
     C                   PARM                    EOPID                          Drive
     C                   PARM                    EDRV                           Opid
     C                   PARM                    EVOL                           Volume
     C                   PARM                    EDIR                           Sub dir
     C                   PARM                    EFILE                          File name
     C                   PARM                    EOFSET                         Start Offset
     C                   PARM                    DTA                            Data to wrt
     C                   PARM                    EDTASZ                         Size of data
     C                   PARM                    ECLSP                          Close pgm
     C                   PARM                    ELOC                           Storage Loca
     C                   PARM                    ETYP                           DocumentType
     C                   PARM                    EMSGID                         Return msgid
     C                   PARM                    EMSGDT                         Return msgdt

      * Determine child program name
     C     EVOL          IFNE      ZVOL
     C     EDIR          ORNE      ZDIR
     C     EFILE         ORNE      ZFILE
     C     *LIKE         DEFINE    EVOL          ZVOL                           Volume
     C     *LIKE         DEFINE    EDIR          ZDIR                           Sub dir
     C     *LIKE         DEFINE    EFILE         ZFILE                          File name
     C                   MOVEL     EVOL          ZVOL                           Volume
     C                   MOVEL     EDIR          ZDIR                           Sub dir
     C                   MOVEL     EFILE         ZFILE                          File name

     C                   MOVE      *BLANKS       EFILEP           10
     C                   SELECT
     C     ETYP          WHENEQ    '2'                                          FileClerk
     C                   EXSR      $FCPN
     C     ETYP          WHENEQ    '5'                                          Imageview
     C     'I'           CAT       EFILE:0       EFILEP                         make valid n
     C     ETYP          WHENEQ    '9'                                          Conversion f
     C                   EXSR      $CFPN
     C                   OTHER
     C                   MOVEL     EFILE         EFILEP
     C                   ENDSL
     C                   END

     C                   Z-ADD     1             child             3 0
     C     EFILEP        LOOKUP    PGM(child)                             50     Eq
     C     *IN50         IFEQ      *OFF                                         Set @C to
     C                   Z-ADD     1             child                          the child
     C     BLNK10        LOOKUP    PGM(child)                             50    program
     C                   MOVEL     EFILEP        PGM(child)
     C                   END

     C     child         IFNE      1
     C     *IN30         DOUEQ     *OFF
     C     QTEMP         CAT(P)    EFILEP:0      childpgm         16            Pass-thru
     C                   CALL      childpgm      CHILDP                 30      to child

     C     *IN30         IFEQ      *ON                                          If not found
/4901c                   EXSR      RCVMSG
     C     CMD(1)        CAT(P)    PGMLIB:0      CMDLIN                         CrtObjDup
     C                   CAT       CMD(2):0      CMDLIN                         (copy pgm
     C                   CAT       EFILEP:0      CMDLIN                          to qtemp)
     C                   CAT       ')':0         CMDLIN
J3068 * Use MAG1090NAG as the copy program when writing to a TSM device.
J3068 /free
J3068  clear devtyp;
J3068  devType(svol:devnam:devtyp:devpath);
J3068  if devtyp = 'TSM';
J3068    cmdLin = %replace('MAG1091NAG':cmdLin:%scan('MAG1091':cmdLin):
J3068    %len('MAG1091'));
J3068  endif;
J3068 /end-free
     C                   EXSR      RUNCLE
     C                   END
     C                   ENDDO
     C     EMSGID        IFNE      *BLANKS
     C                   MOVE      BLNK10        PGM(child)
     C                   END
     C                   END
     C                   ENDSR
      ****************************************************************************
     C     $FC50         BEGSR
      *          Get fileclerk base 50 named file

     C                   MOVE      *BLANKS       FCRTY             1

      * Convert base 36 name to base 50
     C     ' '           CHECKR    XFILE         FCLEN             3 0
     C     FCLEN         IFEQ      8                                            Base 36 name
     C                   MOVEL     'D'           FCOPCD
     C                   MOVEL     XFILE         FCB36                          File name
     C                   CALL      'FCBAS36'     FCBS36                 99
     C                   MOVEL     'E'           FCOPCD
     C                   CALL      'FCBAS50'     FCBS50                 99
     C                   MOVEL(P)  FCB50         XFILE

      * Retry alternate name
     C                   MOVEL(P)  XFILE         SXFILE
     C                   EXSR      CRTPTH
     C                   MOVEL     'Y'           FCRTY                          Retry
     C                   END
     C                   ENDSR
      ****************************************************************************
     C     $FCPN         BEGSR
      *          Get fileclerk name for child program

      * Make a valid as/400 object name
     C     ' '           CHECKR    EFILE         FCLEN             3 0
     C     FCLEN         IFEQ      6                                            Base 50 name
     C                   MOVEL     'D'           FCOPCD
     C                   MOVEL     EFILE         FCB50                          File name
     C                   CALL      'FCBAS50'     FCBS50                 99
     C                   MOVE      FCB10         FCB10A            9
     C     'F'           CAT       FCB10A:0      EFILEP                         Valid name
     C                   ELSE
     C     'F'           CAT       EFILE:0       EFILEP                         Valid name
     C                   END
     C                   ENDSR
      ****************************************************************************
      *          Convert file name to child program name
     C     $CFPN         BEGSR

     C     *LIKE         DEFINE    EFILEP        CFNAM1
     C     *LIKE         DEFINE    EFILEP        CFNAM2

      * Shorten name
     C     ' '           CHECKR    EFILE         CFLEN             3 0
     C                   SELECT
     C     CFLEN         WHENGT    10
     C                   MOVE      EFILE         CFNAM1                         Take low ord
     C     ' '           CHECKR    CFNAM1        CFLEN
     C                   OTHER
     C                   MOVEL     EFILE         CFNAM1                         Take high or
     C                   ENDSL

      * Translate to a valid name
     C     @LC:@UC       XLATE     CFNAM1        CFNAM2                         Uppercase
     C     ' ':'_'       XLATE     CFNAM2        CFNAM1                         No embeded b
     C     CFLEN         SUBST(P)  CFNAM1        CFNAM2
     C     @IC:@RC       XLATE     CFNAM2        CFNAM1                         No invalid

      * Validate first character  (ie. 0-9 or "_" cannot be 1st)
     C     @UC           CHECK     CFNAM1        CFPOS             3 0          Character
     C     CFPOS         IFEQ      1
     C     @VF           CHECK     CFNAM1        CFPOS                          Special
     C     CFPOS         IFEQ      1
     C     '$'           CAT       CFNAM1:0      CFNAM2                         Make valid
     C                   MOVEL     CFNAM2        CFNAM1
     C                   END
     C                   END

      * Should be a valid as/400 object name
     C                   MOVEL     CFNAM1        EFILEP
     C                   ENDSR
      ****************************************************************************
      *          Control the opening of the optical files
      *          and positioning of the offset pointer
     C     OPNFIL        BEGSR

     C                   SELECT
     C     fildes        WHENEQ    0                                            Initial opn
     C     *LIKE         DEFINE    EFILE         XFILE
     C                   MOVEL(P)  EFILE         XFILE
     C     *LIKE         DEFINE    SVFILE        SXFILE
     C                   MOVEL(P)  SVFILE        SXFILE

     C                   EXSR      CRTPTH
     C                   EXSR      OPNOPT
     C                   EXSR      CHGOPT

     C                   OTHER                                                  Already opn
     C                   EXSR      CHGOPT
     C                   ENDSL
     C                   ENDSR
      ****************************************************************************
      *          Create optical path for optical files
     C     CRTPTH        BEGSR

     c                   clear                   volume           12
     c                   clear                   path            180

     C                   if        sloc='3'                                     Shared Fldrs
     C                   MOVEL(P)  '/QDLS'       PATH
     c                   eval       volume=ifs_vol                              *IFS
     c                   else
     c                   eval       volume=svol
     C                   endif

     c                   if        %subst(sdir:1:1)<>'/'
     C                   CAT       '/':0         PATH                           char of dir
     C                   endif

     c                   if        sdir<>*blanks
     C                   CAT       SDIR:0        PATH
     C     ' '           CHECKR    SDIR          #                 3 0          If no slash
     c                   if        %subst(sdir:#:1)<>'/'
     C                   CAT       '/':0         PATH
     C                   endif
     C                   endif

     C                   MOVEL(P)  SXFILE        SFILE            12
     C                   CAT       SFILE:0       PATH                           Full path

     C                   ENDSR
      ****************************************************************************
      *          Open Optical stream file
     C     OPNOPT        BEGSR

/4581c                   If        GetJobCCSid(auintJobCCSID:aDsEc) = SUCCESS

/4581c                   If        auintJOBCCSID = CCSID_GERMAN
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK273:path)
/4581c                   ElseIf    auintJobCCSID = CCSID_FRENCH
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK297:path)
/4581c                   ElseIf    auintJobCCSID = CCSID_POLISH
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK870:path)
/4581c                   EndIf

     c                   EndIf

     C     OO100         TAG

/4581c                   eval      fildes=spystgopn(volume:path:mod_read)

      * 07-03-05 Attempt a second open if it failed on the original open
      *          using the english hex 7c value in the file name

/4581c                   If        fildes<rtn_ok

/4581c                   If        auintJOBCCSID = CCSID_GERMAN
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK273:CCSID_LINK37:path)
/4581c                   ElseIf    auintJobCCSID = CCSID_FRENCH
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK297:CCSID_LINK37:path)
/4581c                   ElseIf    auintJobCCSID = CCSID_POLISH
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK870:CCSID_LINK37:path)
/4581c                   EndIf

/4581c                   eval      fildes=spystgopn(volume:path:mod_read)

/4581c                   EndIf

     C                   if        fildes<rtn_ok                                Error on opn
     c                   if        styp='2'                                     FileClerk
     C                   EXSR      $FC50                                        Base 50 name
     C     FCRTY         CABEQ     'Y'           OO100                          Retry
     C                   endif
     C                   EXSR      ERROPT                                       of stream
     C                   endif                                                  file
/8619 * Determine if page table file was written with wrong record length by
/     * checking 380th position for 2 bytes. If both bytes are hex 40's (blank)
/     * then we have a bad length -> set on badlen indicator.
/    c                   if        %subst(efile:1:1) = 'P'
/    c                   eval      bufptr=%addr(dta(1))
/8837c                   eval      rtncde = spystgred(fildes:buffer:BADPGTLEN+1)
/8619c                   eval      rtncde=spystgsek(fildes:0:seek_set)
/8619c                   if        %subst(buffer:BADPGTLEN:2) = x'4040'
J3729c                             and %subst(buffer:BADPGTLEN:4) <> x'40404040'
/    c                   if        edtasz > STDPGTLEN
/     * If returning more than one record in buffer, allocate space for work buffer
/     * used for realigning data on 379 byte boundries.
/    c                   eval      bufsiz = %size(dta) * %elem(dta)
/    c                   alloc     bufsiz        pgtP
/    c                   endif
/    c                   eval      badlen = '1'
/    c                   endif
/    c                   endif
     C                   ENDSR
      ****************************************************************************
      *          Get stream file size (FSIZE)
     C     GETSIZ        BEGSR

/8678c                   eval      rtncde=spystgsek(fildes:0:seek_cur)
/    c                   if        rtncde >= rtn_ok
/    c                   eval      curofs = rtncde
     c                   eval      rtncde=spystgsek(fildes:0:seek_end)
/8678c                   if        rtncde >= rtn_ok
/    c                   eval      fsize=rtncde
/    c                   eval      rtncde=spystgsek(fildes:curofs:seek_set)
/    c                   endif
/    c                   endif

/8678c                   if        rtncde < rtn_ok
     c                   exsr      erropt
     c                   endif

     C                   endsr
      ****************************************************************************
     C     CHGOPT        BEGSR
      *          Change Pointer in Stream File

     C                   MOVE      '0'           STRLOC
     C                   Z-ADD     0             NEWPTR
     C                   MOVE      *BLANKS       RSV4

/4425c                   eval      dstmov = EOFSET

      * Fixup FileClerk's file pointer
     C     STYP          IFEQ      '2'                                          FileClerk
     C     STYP          OREQ      '5'                                          Imageview
     C     STYP          OREQ      '9'                                          Conversion f
     C     DSTMOV        IFGT      9                                            Not beginnin
     C                   SUB       9             DSTMOV                         No 9 byte hd
     C                   ELSE
     C                   Z-ADD     1             DSTMOV
     C                   END
     C                   END

     C                   SUB       1             DSTMOV                         Zero based
     c                   eval      relofs=dstmov
     c                   eval      rtncde=spystgsek(fildes:relofs:seek_set)
     c                   if        rtncde<rtn_ok
     C                   EXSR      ERROPT
     c                   endif

     C                   ENDSR
      ****************************************************************************
      *          Read from the Optical file
     C     REDFIL        BEGSR

     C                   Z-ADD     EDTASZ        BYT2RD                         Byts to read
     C                   Z-ADD     0             BYTRED                         Byts read

     c                   z-add     byt2rd        bytesleft        13 0
     c                   z-add     1             ix                5 0

/8619c                   dou       bytesleft <= 0
     c                   if        bytesleft>31744
     c                   eval      buflen=31744
     c                   else
     c                   eval      buflen=bytesleft
     c                   endif
     c                   eval      bufptr=%addr(dta(ix))

/8678 *     Watch out for FileClerk, Imageview, Conversion
/    c                   if        (styp = '2' or
/    c                              styp = '5' or
/    c                              styp = '9' ) and
/    c                              eofset <= 9 and bytred = 0
/    C                   EXSR      GETSIZ
/    C                   move      FSIZE         FSIZEA
/    c                   eval      buffer = %subst(fsizea:eofset)
/    C     *LIKE         DEFINE    EOFSET        FOFSET                         read into
/    c                   eval      fofset = %size(fsizea) - eofset + 1
/    c                   eval      bufptr = bufptr + fofset
/    c                   eval      buflen = buflen - fofset
/    c                   eval      bytred = bytred + fofset
/    c                   eval      bytesleft = bytesleft - fofset
/    c                   endif

/8619 * If page table stored incorrectly and the requested buffer length is >= to
/     * a single record read, force 'record-at-a-time-access' in order to realign the
/     * data on 379 byte boundries.
/    c                   if        badlen and edtasz >= STDPGTLEN
/    c                   eval      buflen = BADPGTLEN
/    c                   endif

     c                   eval      rtncde=spystgred(fildes:buffer:buflen)
J3068 * Hack. Was getting at offset issue when printing the last page of an AFP
      * document. Negative response code from TSM is -33. Set the return value
      * to zero and return...no error sent to screen or sysopr if in batch.
J3068 /free
J3068  if rtncde = -33;
J3068    rtncde = 0;
J3068  endif;
J3068 /end-free
      *   Bump up counters
     c                   sub       rtncde        bytesleft
     C                   add       rtncde        bytred
     c                   if        rtncde<buflen
     c                   leave
     c                   endif

/8619 * badlen indicates the page table currently being accessed was stored incorrectly.
/    c                   if        badlen
/     * if an offset(pos) was specified, recalculate offset to compensate for bad rec length.
/    c                   if        relofs > 0
/    c                   eval      relofs = relofs / STDPGTLEN * BADPGTLEN
/    c                   eval      rtncde = spystgsek(fildes:relofs:seek_set)
/    c                   eval      rtncde = spystgred(fildes:buffer:buflen)
/    c                   else
/     * If reading back large buffer use work pointer pgtP for realignment on 379 byte boundries.
/    c                   if        pgtP <> *null
/    c                   eval      clcrec = bytred / BADPGTLEN - 1
/    c                   callp     memcpy(pgtP+(clcrec*STDPGTLEN):%addr(buffer):
/    c                             STDPGTLEN)
/    c                   endif
/    c                   endif
/    c                   else
      *   Set pointer to next 31k array element
     c                   add       31            ix
/8619c                   endif

     c                   enddo

/8619 * Copy work pointer to return pointer when page table record incorrectly stored.
/     * (Large buffer request only -> larger than 379 byte page table record size.)
/    c                   if        badlen and pgtP <> *null
/    c                   callp     memcpy(bufptr:pgtP:bufsiz)
/    c                   dealloc                 pgtP
/    c                   endif

      * Error
     C                   IF        rtncde<rtn_ok
     C                   EXSR      ERROPT
     C                   END

      * Error
     C     BYT2RD        IFNE      BYTRED
     C                   Z-ADD     BYTRED        EDTASZ
     C                   END
      *  Try to read over end of file (not allways an error)
     c                   if        bytred=0 and byt2rd>0
/4901c                   eval      EMsgID = *blanks
/    c                   eval      EMsgDt = *blanks
     c                   return
     c                   endif

     C                   ENDSR
      ****************************************************************************
      *          Close optical file
     C     CLSOPT        BEGSR
     c                   eval      rtncde = spystgcls(fildes)
     C                   ENDSR
      ****************************************************************************
     C     QUIT          BEGSR

     C     2             DO        100           #                              Close down
     C     PGM(#)        IFEQ      *BLANKS                                       the
     C                   LEAVE                                                   children
     C                   END
/4901c                   eval      ChildPgm = 'QTEMP/'+Pgm(#)
/    c                   call      ChildPgm      CHILDP                 30
     C     CMD(3)        CAT(P)    PGM(#):0      CMDLIN                         DltPgm
     C                   CAT       ')':0         CMDLIN                          (child)
     C                   EXSR      RUNCL
/4901c                   eval      Pgm(#) = *blanks
     C                   ENDDO

     C     fildes        IFNE      0
     C                   EXSR      CLSOPT                                        last opt
     C                   END
      *      Shut down storage pgm if no child
     c                   if        child <=1
     c                   eval      rtncde=spystgdwn
     c                   endif

     C                   MOVE      *BLANKS       EMSGID
     C                   MOVE      *BLANKS       EMSGDT
     C                   MOVE      *ON           *INLR

     C                   RETURN
     C                   ENDSR
      ****************************************************************************
      *          Abort w/ terminal message to screen or MsgQ
     C     spyerr        begsr

     c                   call      'SPYERR'
     C                   parm                    MSGID             7
     C                   parm                    MSGDTA          100

     c                   eval      EMSGID  =  msgid
     c                   eval      EMSGDT  =  msgdta

     C                   exsr      ABEND
     C                   endsr
      ****************************************************************************
     C     ERROPT        BEGSR
     c                   exsr      rtvstgerr
     C                   exsr      CLSOPT                                       Cls Opt file
     C                   exsr      spyerr                                       SendErr,quit
     C                   ENDSR
      ****************************************************************************
      *         Retrieve storrage error
     C     rtvstgerr     begsr
     c                   eval      rtncde=spystgerr(err_msgid:err_msgdta)
     c                   eval      msgid  =err_msgid
     c                   eval      msgdta =err_msgdta
     c                   endsr
      ********************************************************************************
     C     RTVMSG        BEGSR
      *          Retrieve message from PSCON
     C                   CALL      'MAG1033'                            50
     C                   PARM                    @MPACT            1
     C                   PARM      PSCON         @MSGFL           20
     C                   PARM                    ERRCD
     C                   PARM      *BLANKS       @MSGTX           80
     C                   ENDSR
      ****************************************************************************
      *          Sys program exception error.  Send msg to outq
     c     *PSSR         BEGSR

     C     BENHER        IFNE      'Y'
     C                   EXSR      ERROPT                                       Send Error
     C                   MOVE      'Y'           BENHER            1
     C                   END

     C                   EXSR      ABEND                                        Terminal
     C                   ENDSR
      ****************************************************************************
      *          Shut down program abnormally: terminal error
     C     ABEND         BEGSR

     C                   Z-ADD     2             #
     C     BLNK10        LOOKUP    PGM(#)                             50        No children
     C     #             IFEQ      1                                             Close
     C                   MOVE      *ON           *INLR

     C     FCBS36        PLIST
     C                   PARM                    FCOPCD            1            Op Code
     C                   PARM                    FCB10            15 0          FC Image#
     C                   PARM                    FCB36             8            FC File name

     C     FCBS50        PLIST
     C                   PARM                    FCOPCD            1            Op Code
     C                   PARM                    FCB10            15 0          FC Image#
     C                   PARM                    FCB50             6            FC File name
/4744c                   parm                    volume                         opt volume

      * Shutdown FileClerk name conversion routine (if called before)
     C     FCOPCD        IFNE      *BLANKS
     C                   MOVE      *BLANKS       FCOPCD
     C                   CALL      'FCBAS36'     FCBS36                 99
     C                   CALL      'FCBAS50'     FCBS50                 99
     C                   END

     C                   END
     C                   RETURN
     C                   ENDSR
      ****************************************************************************
      *          Run a Cl command removing errors
     C     RUNCL         BEGSR

     C                   CALL      'QCMDEXC'                            69
     C                   PARM                    CMDLIN          255
     C                   PARM      255           STRLEN           15 5

     C     *IN69         IFEQ      *ON
     C                   EXSR      RCVMSG
     C                   EXSR      RCVMSG
     C                   END
     C                   ENDSR
      ****************************************************************************
     C     RCVMSG        BEGSR
     C                   CALL      'QMHRCVPM'
     C                   PARM                    MSGINF
     C                   PARM      100           INFLEN
     C                   PARM      'RCVM0100'    FORMAT            8
     C                   PARM      '*'           RCVPGM           20
     C                   PARM      0             STKCNT
     C                   PARM      '*LAST'       MSGTYP           10
     C                   PARM                    MSGKY             4
     C                   PARM      *LOVAL        WAIT              4
     C                   PARM      '*REMOVE'     RCVACT           10
     C                   PARM                    ERRCD
     C                   ENDSR
      ****************************************************************************
      *          Run a command not monitoring errors
     C     RUNCLE        BEGSR
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMDLIN
     C                   PARM      255           STRLEN
     C                   ENDSR
/4581pGetJobCCSID      b
/4581dQUsrJobI         pr                  extpgm('QUSRJOBI')
/4581d pRcvVar                    32766a   options(*varsize)
/4581d pRcvVarLen                    10i 0 const
/4581d pFormat                        8a   const
/4581d pJobName                      26a   const
/4581d pintJobID                     16a   const
/4581d pErrorCode                 32766a   options(*varsize)

/4581d GetJobCCSID     pi            10i 0
/4581d aJobCCSID                     10u 0
/4581d aDsEc                               likeds(dsEC) options(*nopass)

/4581dSUCCESS          c                   0
/4581dERROR            c                   -1

/4581d dsEC            ds
/4581d  dsECBytesP             1      4I 0 inz(256)
/4581d  dsECBytesA             5      8I 0 inz(0)
/4581d  dsECMsgID              9     15
/4581d  dsECReserv            16     16
/4581d  dsECMsgDta            17    256
/4581
/4581 /free
/4581  Callp(e)  QusrJobI(QUSI0400: %size(QUSI0400):
/4581                     'JOBI0400': '*': *BLANKS: dsEC);
/4581
/4581  If dsECBytesA > 0;
/4581    aDsEC = DsEc;
/4581    Return ERROR;
/4581  EndIf;

/4581  aJobCCSID = qusccsid07;

/4581  Return SUCCESS;
/4581 /end-free
/4581pGetJobCCSID      e
** CMD  CL Command lines..............................................
CRTDUPOBJ  OBJ(MAG1091) OBJTYPE(*PGM) TOLIB(QTEMP) FROMLIB(           1
) NEWOBJ(                                                             2
DLTPGM PGM(QTEMP/                                                     3
SNDMSG TOUSR(*SYSOPR) MSG('                                           4

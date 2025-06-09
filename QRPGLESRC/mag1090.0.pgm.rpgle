     h dftactgrp(*no) bnddir('SPYSTGIO') actgrp('DOCMGR')
/4592h option(*nodebugio)
      **********------------------
      * MAG1090  Write data on HFS (hierarchical file system)
      **********------------------
      *
J3175 * ******NOTE******
J3175 * Any changes made to the program should be duplicated in MAG1090NAG.
J3175 * This is a copy of MAG1090 source with the actgrp set to MAG1090 for the
J3175 * purposes of Tivoli Storage Manager conversation requiring a single
J3175 * session per file being written. Easiest method for changes is to
J3175 * checkout MAG1090NAG, replace it with the modified MAG1090,
J3175 * change the named actgrp of MAG1090 and check in.
      * Create files with data passed in ENTRY parmS.
      *    1. Allocate space on the volume (or Volume Ctl ID)
      *    2. Create the sub-directories on the volume.
      *    3. Create the file within the directory.
      *    4. Verify the file was written correctly (number of bytes).
      *    5. Handle HFS optical errors.
      *
      * Parameters:
      *   EVOL   - Either the actual volume of the platter or the
      *            volume control id (multi-vol set name).
      *          - Value *IFS directs program to write to QDLS
      *   REQALC - Number of bytes that must be allocated on optical
      *            to hold the entire input file.
      *   EDIR   - Directory path in which the file is to be written
      *            (eg. SPYGLASS/SPYDATA/.../
      *   EFILE  - Name of the file to be written.
      *               Also used to return the new optical file name
      *               if a file rollover occurs.
      *   EFILSZ - File partial size or *NOMAX for only 1 part files.
      *             - If the EFILSZis *NOMAXthe programwill not
      *               break the input file in different parts. This is
      *               typically used for images (see MAG1502)
      *             - else, the program will break the input file into
      *               multiple optical files, each having a byte size
      *               no greater than EFILSZ.  Names of the output
      *               files will be formed by concatening the first
      *               8 bytes of FILE with a 2-digit seq#. FILE01 etc.
      *               For AFP files the SEQ # will be in HEX. The new
      *               FileName will be passed back to the caller in
      *               Efile.
      *   DTA    - Data to be written, left justified (up to 512x256)
      *   edtasiz - Data size in bytes: up to 131,072 (128K)
      *   eclspgm- Close down program indicator. (1= shutdown)
      *                C=close current file
      *   ERTN   - Returning indicator (0=OK, 1=Error)
      *
J6727 * 09-09-16 PLR Volume full msg thrown when volume not found. Reformat
      *              to display the correct information.
J2779 * 10-05-11 EPG Extend the tally of the directory count to a service
/     *              program in order to perserve the directory count for
/     *              later use.
J3223 * 10-03-11 EPG Deduce whether or not a write error occurs because
/     *              volume is full or if there is in fact a write error.
J3084 * 08-09-11 EPG Clarify the qualifation of a valid write before doing so.
/     *              When the qualification is met, and there are no more
/     *              volumes in the set, then exit.
J3175 * 02-15-11 PLR Intermittent teraspace error caused by the setting of a
J3175 *              pointer based field to a varsize parameter in function
J3175 *              spystgwrt(). It is not good practice to combine pointers
J3175 *              and varsize parms for this reason and just assigning a
J3175 *              pointer value to another field without specifying a length
J3175 *              or having a terminator can cause problems too.
J3175 * 12-06-10 EPG Use newly extended function devType() from SPYSTGIO
/     *              service program to prevent call to SPYVCT if this program
/     *              is running as a child (copy) when archiving AFP directly
/     *              to a Tivoli storage device. Was receiving function call
/     *              out if sequence from Tivoli server.
J2779 * 08-27-10 EPG Modify the code the adhere to the directory file
/     *              threshold as defined by either the device or the
/     *              volume. This is accomplished by extending the call
      *              to SPYVCT. Should the directory be full then
      *              perculate up the message STG0025.
/4942 * 06-19-08 EPG Enable a system operator message to be sent notifying
/     *              that the optical volume is nearly full and needs to
/     *              be changed.
/4581 * 03-08-07 EPG Based on the jobs current CCSID, change the hex value
/4581 *              representative of the @ in that job to hex 7C. In this
/4581 *              the value remains constrant throughout.
/4581 * 02-22-07 EPG Revert the parameter list in the call to SpyStgOpn
/4581 *              from four parameters with the CCSid being the last
/4581 *              one to the original three parameters.
/4581 * 12-07-06 EPG Accomodate a similar scenario for French (CCSID 297)
/4581 *              and Polish (CCSID 870).
/4581 * 11-16-06 EPG When moving files to Optical adopt the CCSID of the
/4581 *              the generic type 65535. Also, get the current job's
/4581 *              CCSID. If the CCSID is 273 (German) and the first
/4581 *              character of the link file contains 7C (representative
/4581 *              of an @ in code page 37) Change that first character
/4581 *              to a hex B5 in order to comply with the unicode value
/4581 *              of @ for the german code page.
/8696 * 11-06-03 PLR Enhance and move tracing to spystgio service program.
/8437 * 07-07-03 PLR Messaging not sent up the stack for write to storage error.
/7594 * 12-31-02 JMO Replaced call to make root directory. The call
      *               was removed (see bug 5792) to resolve a problem with LAN and/or
      *               DIRECT attached optical devices.  However, for
      *               IFS devices the call still needs to be executed.
      *               The service program (SPYSTGIO) has been changed to handle
      *               checking the device type before attempting to create
      *               the root (i.e. "/") directory.
/5792 * 11-26-01 KAC Remove call to make root directory.
/3321 * 12-29-00 KAC REMOVE OPT ID (OBSOLETE AS OF 6.0.6)
/3438 * 12-13-00 KAC Pass correct allocation sizes to SPYVCT.
/2904 *  8-02-00 GT  Fix fildes compares: 0 is a valid file handle!!!
      *              10/13/00 DLS sync source member with 6.06 patch& 6.07
      *  6-21-00 GT  V3R2 compatibility: Error constant names <= 10 chars
      *  6-21-00 FID Fixed roll over problem (SPYVCT didn't get correct volume set name)
      *  8-16-99 FID Major rewrite using new optical service pgm
      *  7-26-99 JJF Allow use of mult volumes for optical output     1873HQ
      *  3-31-99 JJF Return '2' if output file prev exists for vol *IFS
      * 11-25-98 JJF Chg CHKWRT IFGE MAXLEN to IFGT for 16MB files
      *  7-06-98 JJF Add "3rd party optical" processing (OPTTYP=X)
      *  7-02-98 JJF Allow Mag1402 to call for writing rpt hdr file H*
      *  4-09-98 GT  Add retry for dir in use when attempting to create
      *  2-25-98 FID Made it work to brake big files into multiple
      *  7-24-96 JJF Add MAGSERVER optical lan writing.
      *  3-19-96 JJF Allow caller pgm Mag1082 to retry if OptFile xists
      *  8-28-95 GT  Change MSG array entries to message IDs
      *  7-26-95 DM  Program created
      *
/4581 * Prototypes -----------------------------------------------------------------------
/4581 /copy qsysinc/qrpglesrc,qusrjobi
J2779 /include @mgdirtly

/4581dGetJobCCSID      pr            10i 0
/4581d puintJobCCSID                 10u 0
/4581d pDsEc                               likeds(adsEC) options(*nopass)

/4592dSndOprMsg        pr            10i 0
/    d pCurrentVolume                12a   const
/    d pNextVolume                   12a   const
/    d pReply                         1a

/2779dGetPathLibrary   pr            10i 0
/    d pPath                         80a   const options(*varsize)
/    d pLibrary                      10a
/
/    dGetPathFolder    pr            10i 0
/    d pPath                         80a   const options(*varsize)
/    d pFolder                       10a
/
      * Constants ------------------------------------------------------------------------
J2779dNOMAXTHR         c                    9999000
/4592dOK               c                    0
/4592dTRUE             c                    '1'
/4592dVOLUMERETRY      c                    'R'
/    dVOLUMECANCEL     c                    'C'

/4581dSUCCESS          c                    0
/4581dERROR            c                    -1

/4581d auintJobCCSID   s             10u 0
      * Current Jobs CCSID

     D VOLS            S             12    DIM(100)                             Vct OPT Vols
     D chpgm           S             10    DIM(100) ASCEND                      Open child pgm
     D VLFL            S             22    DIM(100)                             Open vols|fils

     D OV              S             12    DIM(300) ASCEND                      Optical volume

     D DTA             S            256    DIM(512)                             131072 Data
     D bytaloc         S             10i 0

/4581dstrLibFile       s            256a
/4581duintCCSID        s             10u 0 inz(65535)

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
     D SYSDFT          DS          1024    dtaara
      *             SpySystem Environs
     D  DTALIB               306    315
     D                 DS
     D  osversion              1      6
     D  OSRLS                  1      4

     D Psds          ESDS                  EXTNAME(CASPGMD)

      * Get File Information by path
     d stat            PR            10i 0 extproc('stat')
     d                                 *   value
     d  stat_ds                        *   value

      * stat structure (sys/stat.h)
     d stat_ds         DS
     d  st_mode                      10u 0
     d  st_ino                       10u 0
     d  st_nlink                      5u 0
     d  st_pad1                       2a
     d  st_uid                       10u 0
     d  st_gid                       10u 0
     d  st_size                      10i 0
     d  st_atime                     10i 0
     d  st_mtime                     10i 0
     d  st_ctime                     10i 0
     d  st_dev                       10u 0
     d  st_blksize                   10u 0
     d  st_alcsize                   10u 0
     d  st_objtype                   11a
     d  st_pad2                       1a
     d  st_codepag                    5u 0
     d  st_rsv1                      62a
     d  st_ino_gen                   10u 0

     D/copy @SPYSTGIO
     D/copy @WCCVTDT
J3175D/copy @memio
      // Variables -------------------------------------------------------------------------------
/2779d aryVolThr       s             15p 0 inz dim(100)
/    d aryVolFiles     s             10i 0 inz dim(100)
/    d aTgtLib         s             10a
/    d aTgtFlr         s             10a
/4592d rc              s             10i 0
/    d chrReply        s              1a
J3175d buffer          s          32767a
     d buflen          s             10i 0
     d rtncde          s             10i 0
/2904d fildes          s             10i 0 inz(-1)
     d err_msgid       s              7
     d err_msgdta      s            256
     d mode            s             10i 0

      * Constants
/4581d CCSID_GERMAN    s             10u 0 inz(273)
      * Job CCSID for German
/4581d CCSID_FRENCH    s             10u 0 inz(297)
      * Job CCSID for French
/4581d CCSID_POLISH    s             10u 0 inz(870)
      * Job CCSID for French
/4581d CCSID_LINK37    s              1a   inz(x'7C')
      * Hex character for @ in CCSID 37
/4581d CCSID_LINK273   s              1a   inz(x'B5')
      * Hex character for @ in CCSID 273
/4581d CCSID_LINK297   s              1a   inz(x'44')
      * Hex character for @ in CCSID 297
/4581d CCSID_LINK870   s              1a   inz(x'7C')
      * Hex character for @ in CCSID 870

     D pscon           C                   CONST('PSCON     *LIBL     ')
     D blank10         C                   CONST('          ')

J3175D devpath         s            120
J3175D devtyp          s             10
J3175D devnam          s             10
      ****************************************************************************
     C     *ENTRY        PLIST
     C                   parm                    EDRV             15            Drive
     C                   parm                    EVOL             12            Volume
     C                   parm                    REQALC           13 0          Allocation
     C                   parm                    EDIR             80            Sub dir
     C                   parm                    EFILE            10            File name
     C                   parm                    EFILSZ           13            Byte/file
     C                   parm                    DTA                            Data to wrt
     C                   parm                    edtasiz           6 0          Size of data
     C                   parm                    eclspgm           1            Close pgm
     C                   parm                    ERTN              1            return Code
      *  optional parms
     C                   parm                    emirror           1            Mirror mode?

/8437c                   move      '0'           ERTN                           Default

      *  Set flag if called by mirror job
     c                   move      ' '           mirror
     c                   if        wqprm>10
     c                   move      emirror       mirror            1
     c                   endif
      *  Default volume allways SPYVIEW
     c                   if        evol=*blanks
     C                   eval      EVOL='SPYVIEW'
     C                   endif

     c                   if        eclspgm='y'                                    Should never
     c                   move      ' '           eclspgm                         be 'y':
     c                   endif                                                   blank/1/C
      *    Check, if file we're dealing with is afp
     C                   exsr      chkifafp                                     Set AFP=1/0
      *    If no data there to write, close file
     c                   if        edtasiz=0
     C                   exsr      close                                        close file/child
     C                   endif
      *    Check, what child pgm to use and call it.
     C                   exsr      setfil                                       Set file pgm
      *    If child was used, exit program, because child already did it.
     c                   if        child >1                                     child
     c                   if        eclspgm<>' '
     C                   exsr      close                                        close file/child
     C                   endif
     C                   return
     C                   endif
      *    Open optical file, if needed
     C                   exsr      chkopn                                       Open file
      *    Write data to optical file
     C                   exsr      wrtdta                                       Write file
      *    If close was requested, close file.
     c                   if        eclspgm<>' '
     C                   exsr      close                                        close file/child
     C                   endif

     C                   exsr      return
      ****************************************************************************
     C     *INZSR        begsr

     C                   call      'MAG103R'                                    Get opsys
     C                   parm                    osversion                           version

     C                   IN        SYSDFT                                        defaults
      * Check job type and open display file if interactive
     C                   call      'MAG1034'                                    Is this
     C                   parm      ' '           jobtype           1            interactive?
     c                   if        jobtype='1'
     C                   eval      jobtype='M'                                    (Manual)
     C                   endif

      * Compute 16 MB bytes
     C     16384         MULT      1000          MEG16             9 0
      * If not Data lib, default to SPYGLASS
     c                   if        dtalib=*blanks
     C                   eval      dtalib='SPYGLASS'
     C                   endif
      * If no volume was passed, default to SPYVIEW
     C     EVOL          IFEQ      *BLANKS
     C                   movel(P)  'SPYVIEW'     EVOL
     C                   movel(P)  'SPYVIEW'     SVOL
     C                   endif

     C                   endsr
      ****************************************************************************
     C     SETFIL        begsr
      *          Set the Child program(file) and pass-thru

     C                   z-add     1             child             1 0
     C     EFILE         lookup    chpgm(child)                           50     Eq

     C                   IF        not *in50                                    Set @C to
     C                   eval      child =1                                      the child
     C     blank10       lookup    chpgm(child)                           50     program
     C                   movel     EFILE         chpgm(child)
     C                   endif

      * If the file name was found in the PGM array in element 2 or
      * above, (create) and call a qtemp/child program to handle it.
      * (The program name and the file it copies are the same)

     C                   IF        child>1                                      Child
     C                   move      EFILE         CHFIL            10
     c                   if        %subst(efile:1:1)='s'
     C                   movel     'S'           CHFIL
     C                   endif

     C     *IN30         DOUEQ     *OFF
     C     'QTEMP/'      cat(P)    CHFIL:0       childpgm         16            Pass-thru
     C                   call      childpgm      CHILDP                 30
     C     CHILDP        PLIST                                                  Same fields
     C                   parm                    EDRV                            as *ENTRY
     C                   parm                    EVOL                            above         SETFI
     C                   parm                    REQALC
     C                   parm                    EDIR
     C                   parm                    EFILE
     C                   parm                    EFILSZ
     C                   parm                    DTA
     C                   parm                    edtasiz
     C                   parm                    eclspgm
     C                   parm                    ERTN
      * CrtDupObj
     C     *IN30         IFEQ      *ON                                          If program
     C                   EVAL      CMDLIN='CRTDUPOBJ OBJ(MAG1090) '+
     c                                    'OBJTYPE(*PGM) TOLIB(QTEMP) FROMLIB('+
     c                                     %trim(wqlibn) + ') NEWOBJ(' +
     c                                     %trim(chfil) +')'
J3175 * Use MAG1090NAG as the copy program when writing to a TSM device.
J3175 /free
J3175  clear devtyp;
J3175  devType(svol:devnam:devtyp:devpath);
J3175  if devtyp = 'TSM';
J3175    cmdLin = %replace('MAG1090NAG':cmdLin:%scan('MAG1090':cmdLin):
J3175    %len('MAG1090'));
J3175  endif;
J3175 /end-free
     C                   exsr      RUNCLE
     C                   endif
     C                   enddo
     c                   if        ertn='1'
     C                   move      *blanks       chpgm(child)
     C                   endif
     C                   endif
     C                   endsr
      ****************************************************************************
     C     chkopn        begsr
      *          If necessary, open an output file

     C     EFILSZ        IFEQ      '*NOMAX'                                     No max, use
     C                   z-add     REQALC        MAXLEN           13 0           req alloc.
     C                   else
     C                   move      EFILSZ        MAXLEN
     C                   END
      * First to open
     C     #OF           IFEQ      0                                             Save first
     C                   move      EDRV          SDRV                             *ENTRY
     C                   move      EVOL          SVOL                             in S flds
     C                   move      EDIR          SDIR
     C                   movel     EFILE         SVFILE
     C                   z-add     REQALC        VCTBYT           13 0
      *      First call, go ahead and open file
     c                   exsr      opnopt

      * Second+, maybe we have to close open file and open another.
      *   If we are about to write data that would make the file
      *   exceed MAXLEN, close this file and open another.
     C                   else

     C     EFILSZ        IFNE      '*NOMAX'
      * if limit reached, open a new one
     C                   IF        totwrt+edtasiz>MAXLEN and
     c                             maxlen>0
     c                   exsr      clsopt
     c                   sub       totwrt        reqalc
     c                   z-add     0             totwrt
/3438c                   z-add     REQALC        VCTBYT           13 0
     c                   exsr      opnopt
     c                   eval      chpgm(1)=opnfyl
     C                   move      OPNVOL        EVOL
     C                   move      OPNFYL        EFILE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     ENDOPN        endsr

     C     *LIKE         DEFINE    EDRV          SDRV
     C     *LIKE         DEFINE    EVOL          SVOL
     C     *LIKE         DEFINE    EDIR          SDIR
     C     *LIKE         DEFINE    EFILE         SVFILE
     C     *LIKE         DEFINE    EVOL          OPNVOL
     C     *LIKE         DEFINE    EFILE         OPNFYL
      ****************************************************************************
      *   Open optical file
     c     opnopt        begsr

      *    Check to see if the directory volume set and i
      *    if the threshold has been reached. If so then abort.


      * Count number of files
     C                   ADD       1             #OF               3 0
     C                   ADD       1             TOTFIL            3 0
      * Reserve optical space & get VOL(s)
     C     SVOL          IFNE      '*IFS'
J3175 * Do not call into spyvct if device is tivoli and the current running
J3175 * program is a child (copy) of MAG1090.
J3175 /free
J3175  clear devtyp;
J3175  devType(svol:devnam:devtyp:devpath);
J3175  if devtyp <> 'TSM' or (devtyp = 'TSM' and WQLIBN <> 'QTEMP');
J3175 /end-free
     C                   exsr      SPYVCT
J3175 /free
J3175  else;
J3175    evol = svol;
J3175    ov(#of) = svol;
J3175  endif;
J3175 /end-free

J2779c                   If        ( aryVolThr(1) <> NOMAXTHR )
/
/    c                   Eval      aryVolFiles(1) = MGDirTly_GetDirCount()
J3084c                   If        ( ( aryVolFiles(1) + 1 ) > aryVolThr(1) )
/     /free
/                          rc = SndOprMsg( SVol : VctID :chrReply );
/
/     /end-free
J2779c                   ExSr      ErrOpt
     c                   LeaveSr
/    c                   EndIf
/
/    c                   EndIf
     C                   endif


      * Load vars PATH DIR EFILE CRTFIL
     C                   exsr      fmtpath

      * Try to open file for write. If open fails, try to create
      * directories, and try open again.
     c                   if        mirror='1'
     c                   eval      mode=mod_mirror
     c                   else
     c                   eval      mode=mod_write
     c                   endif

/4581c                   If        GetJobCCSid(auintJobCCSID:aDsEc) = SUCCESS

/4581c                   If        auintJOBCCSID = CCSID_GERMAN
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK273:path)
/4581c                   ElseIf    auintJOBCCSID = CCSID_FRENCH
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK297:path)
/4581c                   ElseIf    auintJOBCCSID = CCSID_POLISH
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK870:path)
/4581c                   EndIf

/4581c                   Else
/4581c                   Eval      MsgId =   dsECMsgID
/4581c                   Eval      MsgDta =  dsECMsgDta
/4581c                   ExSr      SpyErr
/4581c                   EndIf


      * Try to open file twice, if first try fails, the directory might not be there and
      *   has to be created (CRTDIR)
     c                   do        2             run               3 0

/4581c                   eval      fildes=spystgopn(volume:path:mode)

      *        Open went fine, keep on going
/2904c                   if        fildes>=rtn_ok
     c                   leave
     c                   else
      *        Open fails, try to create directories
     c                   if        run=1
     c                   exsr      crtdir
     c                   endif
     c                   endif
     c                   enddo
      *   If open went fine, add file to array of opened files
     c                   if        fildes>=rtn_ok

J2779c                   If        ( aryVolThr(1) <> NOMAXTHR )
     c                   Eval      aryVolFiles(1) += 1
J2779c                   Callp     MGDirTly_SetIncCount()
J2779c                   EndIf
     c
     c                   eval      vlfl(totfil)=volume+efile
     c                   endif

      * Error abort
     C                   if        fildes<rtn_ok                                Error
     C                   exsr      ERROPT
     c                   else
     C                   eval      opnvol=volume
     C                   eval      opnfyl=EFILE
     C                   END
     C                   endsr
      ****************************************************************************
     C     SPYVCT        begsr
      *          Reserve space on volume(s)

     C                   move      SVOL          VCTID

      * If file size is unlimited, allocate only 1 volume.
     C     EFILSZ        IFEQ      '*NOMAX'
     C                   z-add     0             VCTLEN                         No multi-vol
     C                   else
/3438c                   z-add     maxlen        VCTLEN                         Multi-vol OK
     C                   END

/4592c                   DoW       TRUE
     c                   If        (
/2779c                               ( GetPathLibrary( Edir : aTgtLib ) = OK )
/    c                                   and
/    c                               ( GetPathFolder( Edir : aTgtFlr ) = OK )
/    c                              )
     C                   call      'SPYVCT'
/3321C                   parm                    VCOPID           10
     C                   parm                    VCTID            12
     C                   parm                    VCTBYT
     C                   parm                    VCTLEN           13 0
     C                   parm                    VOLS                                       es
     C                   parm      jobtype       VRTN              1
/2779c                   parm                    aryVolThr
/    c                   parm                    aryVolFiles
/    c                   parm                    aTgtLib
/    c                   parm                    aTgtFlr
/2779c                   Else
/    c                   Eval      VRtn = '1'
/    c                   EndIf

     C     VRTN          IFNE      '0'

J2779c                   If        ( ( VRtn <> VOLUMECANCEL ) and
/    c                               ( VRtn <> VOLUMERETRY  )      )
/4592c                   Eval      rc = SndOprMsg(SVol:SVol:chrReply)
J2779 *
J2779 *                 Here the return value from SPYVCT is overloaded
J2779 *                 with the return value from the system operator message
J2779 *                 Check the return value so the system operator message
J2779 *                 does not appear twice.
J2779 *
J2779c                   Else
J2779c                   Eval      chrReply = VRTN
J2779c                   EndIf

/4592c                   Select
/    c                   When      rc <> OK
/    c                   When      rc = OK and chrReply = VOLUMECANCEL
/    c                   When      rc = OK and chrReply = VOLUMERETRY
/    c                   Iter
/    c                   EndSl
     c
     C                   movel     'ERR133A'     msgid                          Unable to access vol
     C                   exsr      spyerr                                       SendErr,quit
/4592C                   Else
     C                   Leave
     C                   EndIf
     C
/4592c                   EndDo


      * If VOLS,1 returned by SPYVCT differs from EVOL (the vol sent
      * to it) then EVOL is a multi-vol set name (SETNAM).  This will
      * be used by later (if needed) to get additional vol(s) in set.
     C     VOLS(1)       IFNE      *BLANKS
     C     VOLS(1)       ANDNE     EVOL
     C                   MOVE      VCTID         SETNAM
     C                   END

     C                   move      VOLS(1)       EVOL
     C                   move      VOLS(1)       OV(#OF)

     C                   endsr
      ****************************************************************************
     C     fmtpath       begsr
      *          Create path for optical file
      *            Input: EVOL SVFILE EFILSZ APF
      *            Outpt: PATH DIR CRTFIL=EFILE

     c                   clear                   path
     C                   movel(P)  SVFILE        CRTFIL           10
      *----------------------------------------------------------------
      * If this SR is called by SR VERIFY, leave the suffix alone.
      * else if EFILSZ is limited, set up the last 2 pos of file name:
      *         If AFP      SUFFIX = #OF - 1
      *         If Rpt Hdr         = '00'     (for Mag1402 archiver)
      *         else               = #OF
      *----------------------------------------------------------------
     C     @VERFY        IFEQ      'Y'
     C                   move      CRTFIL        EFILE
      * AFP
     C                   else
     C     EFILSZ        IFNE      '*NOMAX'                                     usually true
      * AFP
     C     AFP           IFEQ      '1'
     C     #OF           SUB       1             NUM2              2 0
     C                   move      NUM2          SUFFIX            2
      * non-AFP
     C                   else
     C                   move      CRTFIL        SUFFIX

     C     SUFFIX        IFEQ      'H*'                                         Hdr file frm
     C     SUFFIX        OREQ      '00'
     C                   move      '00'          SUFFIX                          Mag1402
     C                   else
     C                   move      #OF           SUFFIX
     C                   END
     C                   END

     C                   move      SUFFIX        CRTFIL
     C                   move      CRTFIL        EFILE
     C                   END
     C                   END

     c                   clear                   volume           12

      *     QOpt: /QOPT/vol/dir/file
     C     SVOL          IFNE      '*IFS'
     C     @VERFY        IFEQ      'Y'
     c                   eval      volume = evol
     C                   else
     c                   eval      volume = ov(#of)
     c                   endif
     c                   if        %subst(sdir:1:1)<>'/'
     C                   cat       '/':0         PATH            180             push it
     C                   endif
     C                   cat       SDIR:0        PATH

      *     *IFS: /QDLS/dir/file  (SDIR already has /QDLS/dir/ in it)
     C                   else
     c                   eval      volume = '*IFS'
     c                   if        %subst(sdir:1:1)<>'/'
     c                   eval      path='/'+sdir
     C                   else
     c                   eval      path=sdir
     C                   endif
     C                   endif

     C     ' '           CHECKR    SDIR          #                 3 0          Need slash
     C                   SUBST     SDIR:#        SLASH             1             after
     C     SLASH         IFNE      '/'
     C                   cat       '/':0         PATH
     C                   endif

     C                   cat       CRTFIL:0      PATH                           Path done

     C                   endsr
      ****************************************************************************
     C     CRTDIR        begsr

     c                   clear                   makepath        180
     c                   clear                   f1a               1
     c     ' '           checkr    path          dirlen            5 0
      *   Will cause it to create the colume
/5792c* * *              eval      rtncde=spystgmd(volume:'/')
/7594c
/7594c                   eval      rtncde=spystgmd(volume:'/')

     c                   do        dirlen        ix                5 0
     c                   eval      f1a=%subst(path:ix:1)
      *   found '/', go ahead and try to create path
     c                   if        f1a='/' and
     c                             makepath<>*blanks
     c                   eval      rtncde=spystgmd(volume:makepath)
     c                   endif
     c                   cat       f1a:0         makepath
     c                   enddo

     C                   endsr
      ****************************************************************************
     C     WRTDTA        begsr
      *          Write DTA to file

     c                   z-add     edtasiz       totbytes         11 0
     c                   z-add     edtasiz       byt2wrt           9 0
     c                   z-add     1             ix
     c                   dou       byt2wrt=0
     c                   if        byt2wrt>31744
     c                   eval      buflen=31744
     c                   else
     c                   eval      buflen=byt2wrt
     c                   endif
J3175c                   clear                   buffer
J3175c                   callp     memcpy(%addr(buffer):%addr(dta(ix)):buflen)
     c                   eval      rtncde=spystgwrt(fildes:buffer:buflen)
     c                   if        rtncde<rtn_ok
/8696c                   leave
     c                   endif
      *   Set pointer to next 31k array element
     c                   add       124           ix
      *   Bump up counters
     c                   sub       rtncde        byt2wrt
     C                   add       rtncde        BYTWRT           13 0
     C                   add       rtncde        TOTWRT           13 0

     c                   enddo

/8696c                   if        rtncde < rtn_ok
/    c                   eval      ertn = '1'
/    c                   exsr      erropt
/    c                   endif

     C                   endsr
      ****************************************************************************
      *          Close file, then quit or return
     C     CLOSE         begsr
     C                   SELECT
     C     eclspgm       WHENEQ    'C'                                          Close curent
     C                   exsr      CLSFIC                                        & return
     C                   exsr      return
     C     eclspgm       WHENEQ    '1'                                          Shutdown
     C                   exsr      CLSFIL
     C                   move      '0'           ERTN
     C                   exsr      QUIT
     C                   endsl
     C                   endsr
      ****************************************************************************
     C     CLSFIC        begsr
      *          Close down the current child program
      *          Close the last partial opt file for the complete file.
      *           Verify that each partial file can be opened and that
      *            the number of bytes written is correct.
      *          Commit optical volumes.

     C                   z-add     1             #
     C     EFILE         lookup    chpgm(#)                               50     Eq
     C     *IN50         IFEQ      *ON
     C     #             IFGT      2
     C                   call      childpgm      CHILDP
     c                   eval      cmdlin='DLTPGM PGM(QTEMP/'+
     c                                %trim(chPGM(#))+')'
     C                   exsr      RUNCL
     C                   else
/2904C     fildes        CASGE     0             CLSOPT                         CloseLastOpt
     C                   ENDCS
     C                   CLEAR                   chPGM(#)
     C                   endif
     C                   endif

     C     SVOL          IFNE      '*IFS'
     C                   exsr      VERIFY                                       Verify all
     C                   move      *ON           *IN10
     C                   endif
      *                                                                   CLSFIC
     C                   CLEAR                   #OF
     C                   CLEAR                   TOTFIL
     C                   CLEAR                   BYTWRT
     C                   CLEAR                   VLFL
     C                   endsr
      ****************************************************************************
     C     CLSFIL        begsr
      *          Close down the children programs.
      *          Close the last partial opt file for the complete file.
      *           Verify that each partial file can be opened and that
      *            the number of bytes written is correct.
      *          Commit optical volumes.

     C     2             DO        100           #                              Close down
     C     chPGM(#)      IFEQ      *BLANKS                                      all the
     C                   ITER                                                   children
     C                   endif
     C                   call      childpgm      CHILDP
     c                   eval      cmdlin='DLTPGM PGM(QTEMP/'+
     c                                %trim(chPGM(#))+')'
     C                   exsr      RUNCL
     C                   ENDDO

/2904C     fildes        CASGE     0             CLSOPT                         CloseLastOpt
     C                   ENDCS

     C     SVOL          IFNE      '*IFS'
     C     EVOL          ANDNE     '*IFS'
     C                   exsr      VERIFY                                       Verify
     C                   move      *ON           *IN10
     C                   endif
     C                   endsr
      ****************************************************************************
      *          Close optical file...PHYSIcallY DOES THE WRITE
     C     CLSOPT        begsr

     C                   eval      rtncde=spystgcls(fildes)
/2904c                   reset                   fildes
      * Dealocate space
     c                   eval      bytaloc=totwrt
     c                   eval      rtncde=spystgdloc(evol:bytaloc)
      * check if file was held, if volume set was use, release it
     c                   if        rtncde=NoSpc_Err and
     c                             setnam<>*blanks
     c                   exsr      rlshldfil
     c                   endif

     C                   endsr
      ****************************************************************************
     C     rlshldfil     begsr
      *          Save Release held optical files
     c                   call      'SPYVCTA'
     C                   PARM                    SETNAM           12
     C                   PARM      volume        badvolume        12
     C                   PARM                    newvolume        12
     C                   PARM      jobtype       VCTRTN            1
     C                   PARM                    totbytes         11 0

     c                   if        newvolume<>*blanks
      *       make sure, that path exists
     c                   eval      volume=newvolume
     c                   exsr      crtdir
     c                   eval      volume=badvolume
      *       try to release file to new platter
     c                   eval      rtncde=spystgrls(volume:newvolume:path)
      *       went fine
     c                   if        rtncde=rtn_ok
     c                   eval      evol=newvolume
     c                   movel     evol          vlfl(totfil)
     c                   endif
     c                   endif

     C                   endsr
      ****************************************************************************
     C     VERIFY        begsr
      *          Abort if bytes written <> bytes now on optical

      * Accumulate BYTVER, bytes of our files now on optical
     c                   z-add     5             retries           5 0
     c                   do        retries
     c                   exsr      getbytwrt

      * Abort if bytes written <> bytes now on optical
     C     BYTWRT        IFNE      BYTVER
     C     BYTVER        ORLE      0
     c                   if        run=retries
     C                   exsr      ERRVER
     c                   else
      * First run, delay job, some NFS server are a bit slow
     c                   eval      cmdlin='DLYJOB 1'
     c                   exsr      runcl
     c                   endif
      * everything is fine, exit loop
     c                   else
     c                   leave
     C                   endif
     c                   enddo

     C                   endsr
      ****************************************************************************
      * Accumulate BYTVER, bytes of our files now on optical
     C     getbytwrt     begsr

     C                   CLEAR                   BYTVER

     C                   DO        TOTFIL        file#             5 0
     C                   if        vlfl(file#)=*blanks
     C                   leave
     C                   endif
      * Load vars PATH DIR EFILE CRTFIL
     C                   movel     VLFL(file#)   EVOL
     C                   move      VLFL(file#)   SVFILE
     C                   move      'Y'           @VERFY            1
     C                   exsr      fmtpath
     C                   move      ' '           @VERFY

      * Massage the data file name if the CCSID is 273 and
      * a link file is being verified for the write.

/4581c                   If        GetJobCCSid(auintJobCCSID:aDsEc) = SUCCESS

/4581c                   If        auintJOBCCSID = CCSID_GERMAN
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK273:path)
/4581c                   ElseIf    auintJOBCCSID = CCSID_FRENCH
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK297:path)
/4581c                   ElseIf    auintJOBCCSID = CCSID_POLISH
/4581c                   Eval      path =
/4581c                             %xlate(CCSID_LINK37:CCSID_LINK870:path)
/4581c                   EndIf

/4581c                   EndIf

      * Get stat_ds to retrieve filesize
     c                   eval      rtncde=spystgsta(evol:path:filinf_ds)
     C     rtncde        CASNE     rtn_ok        ERRVER
     C                   ENDCS
      *                                                                   VERIFY
     C                   add       os_filsiz     BYTVER           13 0
     C                   ENDDO
     C                   endsr
      ****************************************************************************
     C     ABEND         begsr
      *          If there are no children, quit w/ERTN='1'
      *             else return w/ERTN=0

     C                   eval      ertn='1'
     C                   z-add     2             #
     C     blank10       lookup    chPGM(#)                           50         GT
     C                   if        #=1
     C                   exsr      quit
     C                   else
     C                   return
     C                   endif

     C                   endsr
      ****************************************************************************
     C     QUIT          begsr
      *      Shut down storage pgm if no child
     c                   if        child <=1
     c                   eval      rtncde=spystgdwn
     c                   endif

     C                   move      *ON           *INLR
     C                   RETURN
     C                   endsr
      ****************************************************************************
     C     return        begsr
     C                   RETURN
     C                   endsr
      ****************************************************************************
     C     getcurdat     begsr
     C                   CALL      'QWCCVTDT'
     C                   PARM      '*CURRENT'    WCINPF           10
     C                   PARM                    WCINPV           20
     C                   PARM      '*YYMD'       WCOUTF           10
     C                   PARM                    wcoutv
     C                   PARM      *ALLX'00'     ErrRtn           80
     C                   endsr
      ****************************************************************************
     C     ERROPT        begsr
      *          Retrieve errors from optical support routines
     c                   exsr      rtvstgerr
     C                   exsr      CLSOPT                                       Cls Opt file
     C                   exsr      spyerr                                       SendErr,quit
     C                   endsr
      ****************************************************************************
     C     ERRVER        begsr
      *          Error verifing bytes written
     C                   movel     'ERR1330'     msgid                          Optical file verific
     C                   movel(p)  CRTFIL        msgdta
     C                   exsr      CLSOPT                                       Cls Opt file
     C                   exsr      spyerr                                       SendErr,quit

     C                   endsr
      ****************************************************************************
      *         Retrieve storrage error
     C     rtvstgerr     begsr
     c                   eval      rtncde=spystgerr(err_msgid:err_msgdta)
     c                   eval      msgid  =err_msgid
     c                   eval      msgdta =err_msgdta
     c                   endsr
      ****************************************************************************
      *          Abort w/ terminal message to screen or MsgQ
     C     spyerr        begsr
     c                   call      'SPYERR'
     C                   parm                    MSGID             7
     C                   parm                    MSGDTA          100
     C                   exsr      ABEND
     C                   endsr
      ****************************************************************************
      *          Run a command monitoring for errors
     C     RUNCL         begsr
     C                   call      'QCMDEXC'                            69      Monitor for
     C                   parm                    CMDLIN          255            all errors
     C                   parm      255           STRLEN           15 5
     C     *IN69         IFEQ      *ON
     C                   exsr      MONMSG
     C                   endif
     C                   endsr
      ****************************************************************************
     C     MONMSG        begsr
     C                   exsr      RMVMSG
     C                   exsr      RMVMSG
     C                   endsr
      ****************************************************************************
     C     RMVMSG        begsr
      *          Remove pgm msg
     C                   move      *LOVAL        MSGLEN
     C                   move      X'64'         MSGLEN
     C                   call      'QMHRCVPM'
     C                   parm                    MSGINF          100
     C                   parm                    MSGLEN            4
     C                   parm      'RCVM0100'    MSGFMT            8
     C                   parm      '*'           MSGPGM           20
     C                   parm      *LOVAL        MSGSTK            4
     C                   parm      '*LAST'       MSGTYP           10
     C                   parm      *BLANKS       MSGKY             4
     C                   parm      *LOVAL        MSGW              4
     C                   parm      '*REmove'     MSGACT           10
     C                   parm      *LOVAL        MSGERR            4
     C                   endsr
      ****************************************************************************
      *          Run a command not monitoring errors
     C     RUNCLE        begsr
     C                   call      'QCMDEXC'
     C                   parm                    CMDLIN
     C                   parm      255           STRLEN
     C                   endsr
      ****************************************************************************
      * Check if file to write is an afp file
     C     chkifafp      begsr
     C                   movel     EFILE         F1A               1
     c                   if        f1a = 'A' or F1a = 'P'                       AFP Data or pagetabl
     C                   move      '1'           AFP               1
     C                   else
     C                   move      '0'           AFP               1
     C                   endif
     C                   endsr
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
      //----------------------------------------------------------------------------------------
/4942pSndOprMsg        b
/     //----------------------------------------------------------------------------------------
/    dSndOprMsg        pi            10i 0
/    d aCurrentVolume                12a   const
/    d aNextVolume                   12a   const
/    d aReply                         1a
/
/     // Prototypes ----------------------------------------------------------------------------------------
/    D QMHSNDM         PR                  ExtPgm('QMHSNDM')
/    D   MsgID                        7A   const
/    D   QualMsgF                    20A   const
/    D   MsgTxt                   32767A   const options(*varsize)
/    D   MsgTxtLen                   10I 0 const
/    D   MsgType                     10A   const
/    D   MsgQueues                   20A   const dim(50) options(*varsize)
/    D   NumQueues                   10I 0 const
/    D   RpyQueue                    20A   const
/    D   MsgKey                       4A
/    D   ErrorCode                 8000A   options(*varsize)
/    D   CCSID                       10I 0 const options(*nopass)
/
/    D QMHRCVPM        PR                  ExtPgm('QMHRCVPM')
/    D   MsgInfo                  32767A   options(*varsize)
/    D   MsgInfoLen                  10I 0 const
/    D   Format                       8A   const
/    D   StackEntry                  10A   const
/    D   StackCount                  10I 0 const
/    D   MsgType                     10A   const
/    D   MsgKey                       4A   const
/    D   WaitTime                    10I 0 const
/    D   MsgAction                   10A   const
/    D   ErrorCode                 8000A   options(*varsize)
/
      // Constants --------------------------------------------------------------------------
     d OK              c                   0
     d ERROR           c                   -1
/    D RCVM0100        DS                  qualified
/    D   BytesRtn                    10I 0
/    D   BytesAvail                  10I 0
/    D   MsgSev                      10I 0
/    D   MsgID                        7A
/    D   MsgType                      2A
/    D   MsgKey                       4A
/    D                                7A
/    D   CCSID_status                10I 0
/    D   CCSID                       10I 0
/    D   MsgDtaLen                   10I 0
/    D   MsgDtaAvail                 10I 0
/    D   MsgDta                    8000A
/
/    D ErrorCode       ds                  qualified
/    D   BytesProv                   10I 0 inz(0)
/    D   BytesAvail                  10I 0 inz(0)
/
/    D Message         s             24A
/    D MsgKey          s              4A
/    D MsgQ            s             20A   dim(1) inz('*SYSOPR')
/    D Reply           s            100A
/    d intReturn       s             10i 0
J6827d thisMsgID       s              7    inz('ERR131D')

/     /free
/      intReturn = OK;
/      Message = aCurrentVolume + aNextVolume;
/
/      Reset ErrorCode;

J6827  if vrtn = '2';
J6827    return 0;
J6827  endif;

J6827  QMHSNDM( thisMsgID
/             : 'PSCON     *LIBL'
/             : Message
/             : %len(Message)
/             : '*INQ'
/             : MsgQ
/             : %elem(MsgQ)
/             : '*PGMQ'
/             : MsgKey
/             : ErrorCode );
/
/      If ErrorCode.BytesAvail > *zero;
         intReturn = ERROR;
       Else;
/        Reset ErrorCode;
/
/        QMHRCVPM( RCVM0100
/                : %size(RCVM0100)
/                : 'RCVM0100'
/                : '*'
/                : 0
/                : '*RPY'
/                : MsgKey
/                : -1
/                : '*REMOVE'
/                : ErrorCode );

          If ErrorCode.BytesAvail > *zero;
/           intReturn = ERROR;
          Else;
/           aReply = %subst(RCVM0100.MsgDta: 1: RCVM0100.MsgDtaLen);
          EndIf;

       EndIf;

       Return intReturn;
/     /end-free
/    pSndOprMsg        e
/    pGetPathLibrary   b
/    dGetPathLibrary   pi            10i 0
/    d aPath                         80a   const options(*varsize)
/    d aLibrary                      10a
/    d OK              c                   0
/    d ERROR           c                   -1
/    d intReturn       s             10i 0 inz(OK)
/    d intStrLib       s             10i 0
/    d intEndLib       s             10i 0
/    d intLenLib       s             10i 0
/     /free
/      Monitor;
/        intStrLib = %scan('/':aPath:2) + 1;
/        intEndLib = %scan('/':aPath:intStrLib) - 1;
/        intLenLib = ( intEndLib - intStrLib ) + 1;
/        aLibrary  = %subst(aPath:intStrLib:intLenLib);
/        Return intReturn;
/      on-Error *all;
/        intReturn = ERROR;
/        Return intReturn;
/      EndMon;
/      /end-free
/    pGetPathLibrary   e
/     *--------------------------------------------------------------------
/    pGetPathFolder    b
/    dGetPathFolder    pi            10i 0
/    d aPath                         80a   const options(*varsize)
/    d aFolder                       10a
/    d OK              c                   0
/    d ERROR           c                   -1
/    d intReturn       s             10i 0 inz(OK)
/    d intStrLib       s             10i 0
/    d intStrFlr       s             10i 0
/    d intEndFlr       s             10i 0
/    d intLenFlr       s             10i 0
/     /free
/      Monitor;
/        intStrLib = %scan('/':aPath:2) + 1;
/        intStrFlr = %scan('/':aPath:intStrLib) + 1;
/        intEndFlr = %scan('/':aPath:intStrFlr) - 1;
/        intLenFlr = %len(%trim(aPath)) - intStrFlr + 1;
/        aFolder = %subst(aPath:intStrFlr:intLenFlr);
/        Return intReturn;
/      on-Error *all;
/        intReturn = ERROR;
/        Return intReturn;
/      EndMon;
/      /end-free
/    pGetPathFolder    e

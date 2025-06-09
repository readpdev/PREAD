      *%METADATA                                                       *
      * %TEXT PDF Buffer Handler                  - PDFLOAD            *
      *%EMETADATA                                                      *
      *   Module Name PDFBUFHDL
      *
J3586 * 06-14-11 EPG Fix an issue introduced with 5840 in that it did not
/     *              return the file name from PDFBufInit.
J3586 * 06-06-11 EPG In the event that the name of the resulting PDF file
      *              is passed, then use this filename to render the requested
      *              file. Provide for error handling and reporting with
      *              PDFExtractFinis.
      *
J2904 * 08-06-10 PLR The removal of nulls at the end of every buffer was
      *              corrupting the creation of temp PDFs (original archive
      *              version not found on the system) and causing DocView to
      *              fail in some cases. Reserved the removal of null data at
      *              the end of the file.
J2830 * 07-29-10 PLR Retrieval of offline PDFs was not accounted for.
T6537 * 09-06-07 PLR PDF files with embedded nulls causing retrieve failure
      *              through DocView.
      *
      *              Error on server:
      *
      *              PDFlib exception (fatal): [1118] PDF_open_pdi_page:
      *              Handle parameter or option of type 'document'
      *              has bad value -1
      *
      *              Compensated by checking if nulls are found on last record
      *              processed to determine if we're at the end of the data or
      *              if the nulls were detected in the middle of the stream.
      *
T5944 * 12-15-06 EPG When accessing the AFP file, explicitly override the
      *              name of the file including the library name in the
      *              event that the file is saved to a library that is not
      *              in the SPYTCP job library list.
T5840 * 11-02-06 PLR Return file handle to original pdf instead of copying
      *              entire file to temp directory. Make sure the original
      *              file is not deleted on shut down. Validate against temp
      *              directory name. Added unique file naming of pdf files
      *              that are recreated from the archive if they don't exist
      *              in their original directories. If two sessions rebuilt the
      *              same temp file and then one session quit before the other,
      *              the temp file would be deleted on cleanup and the remaining
      *              session would have an invalid file handle pointing to nothing.
T4979 * 10-04-06 PLR Added a return file path field to end of PDFBufInit to
      *              enable the processing of pdf segments within SPYCS.
5469  * 07-28-06 EPG Fix a problem with a code path that passed
5469  *              to PDFExtractFinis a file name that was
5469  *              not a null terminated string. Also error
5459  *              check the close when the file is reconstituted,
5469  *              and set the flag blnIFSCreated to TRUE.
5469  * 07-19-06 EPG Remedy a problem with rendering a PDF file
5469  *              from an A file, by insuring that the last
5469  *              buffer in the file terminates the PDF file
5469  *              with a %%EOF0D0A. Build in logic to deal
5469  *              various EOF scenarios.
4979  * 02-03-06 EPG Initial Module Creation
     h copyright('Open Text Corporation')
     h bnddir('SPYBNDDIR':'PDFLIBI':'QC2LE')
     h nomain
     fMfldDir   if   e           k disk    usropn
     fMRptDir7  if   e           k disk    usropn
      * Keyed file on Spy Number
     fRAPFDbf   if   e           k disk    usropn

      * Prototypes --------------------------------------------------  ---
      /copy @pdfbufhdl
      /copy @memio
      /copy @pdfio
      /copy @masplio
      /copy qsysinc/qrpglesrc,qusrspla

J2830d getRscDta       pr            10i 0

     d GetPathFile     pr           512a
     d  pPathFile                   512a

     d ObjExist        pr              n
     d  pLib                         10a   const
     d  pObj                         10a   const
     d  pTypes                       10a   const

5469 d getDocMgrPath   pr                  extpgm('SPYPATH')
5469 d  pathID                       10    const
5469 d  rtnPath                     256

      * Constants ----------------------------------------------------------

     d
5469 dNULLSTR          c                   x'0000000000'

      * ASCII PDF End of file indicator %EOF (carriage return)
     dAPFTYPPDF        c                   '4'
      * field value in MRPTDIR signifying a PDF document
     dAPFMAXLEN        c                   4079
     dSUCCESS          c                   0
     dERROR            c                   -1
J2830d OK              c                   0
J2830d EOF             c                   100
     dLAST             c                   -1
     dTRUE             c                   '1'
     dFALSE            c                   '0'
     dQUOTE            c                   x'7D'
      * Data Structures ---------------------------------------------------
     d*                ds
     d intAPFLEN       s             10i 0 inz(4079)

      * Variables --------------------------------------------------
T6537d lastRecord      s               n
     dmfldLib          s             10a
     dmfldFile         s             10a
     dmfldr            s             10a
     dstrASCBuf        s           4079a
      * ASCII Buffer from RAPFDBF
     dintFH            s             10i 0
      * IFS File Handle
     dintOFlag         s             10i 0
      * IFS File Open Flag
     dintMode          s             10u 0
      * IFS File Mode Flag
     dintCodePage      s             10u 0 inz(819)
      * IFS File Code Page
     dblnIFSSrc        s               n   inz(FALSE)
     ddocMgrPath       s            256a
      * temporary path name from the doc manager
     ddocMgrPath0      s            257a
      * temporary path name from the doc manager
     dstrOrgPDFPath    s            512a
      * Original PDF Path and File name
     dstrOrgPDFPath0   s            513a
      * Original PDF Path and File name Null terminated
     dstrTmpPDFPath    s            512a
      * Tempoary PDF Path and File name of Original
     dstrTmpPDFPath0   s            513a
      * Tempoary PDF Path and File name of Original
     dstrTmpPDFPathSub...
     d                 s            512a
      * Tempoary PDF Path and File name of Original
5469 dstrTmpPDFPathSub0...
5469 d                 s            513a
      * Tempoary PDF Path and File name of Original Subset
     dstrFID           s             16a
      * IFS file id form the IFS.
     dCurAPFNam        s             10a
      * Current "A" file name
      * End of File position in PDF buffer
     dCmd              pr                  extproc('system')
     d pCommand                        *   value
     d                                     Options(*string)
      *-----------------------------------------------------------
     pPDFBufInit       b                   Export
      *-----------------------------------------------------------
      /copy @ifsio
     dPDFBufInit       pi            10i 0
     d aFH                           10i 0
      * PDF File Handle
     d aSpyNumber                    10a   Const
      * Spy Number
     d aPageBegin                    10i 0 Const
      * Beginning Page Number
     d aPageEnd                      10i 0 Const
      * Ending Page Number
     d aPDFSize                      10u 0
      * PDF File Size
T4979d aPDFPath                     512    options(*nopass)

     d cvtch           pr                  extproc('cvtch')
     d target                          *   value
     d source                          *   value
     d sizeTarget                    10i 0 value
T4979d pdfFilePath                  512    options(*nopass)

      * Variables ------------------------------------------------
J3586d blnUserPDFFile  s               n   inz(FALSE)
     d blnIFSCreated   s               n   inz(FALSE)
      * IFS file preexisting
     d rc              s             10i 0
      * return code
     d p_dirHdl        s               *
      * pointer to directory
     d strHEXFID       s             32a
      * HEX representation

     c     keyFld        klist
     c                   kfld                    fldcod
     c                   kfld                    fldlib

     c     keyAPF        klist
     c                   kfld                    apfrep
     c                   kfld                    apfseq

      /free

J3586     If ( ( %parms >= 6         ) and
/               ( aPDFPath <> *blanks )      );
/           blnUserPDFFile = TRUE;
/         EndIf;

          // Determine if this is a PDF file that is requested

          aPDFSize = *zero;

          If aSpyNumber <> *blanks;
            Open(e) MRptDir7;
            Chain(e) aSpyNumber MRptDir7;
            If %found;
              If apftyp <> APFTYPPDF;
                Close(e) MRptDir7;
                Return ERROR;
              EndIf;
              Close(e) MRptDir7;
            Else;
              Close(e) MRptDir7;
              Return ERROR;
            EndIf;
          EndIf;

          // Parameter checking

          // File handle already initialized
          // and PDF is opened

          If aFH > 0;
            Return SUCCESS;
          Else;
            Select;
              When aSpyNumber = *blanks;
                Return ERROR;
              When (aPageBegin > aPageEnd) and
                   (aPageEnd <> LAST);
                Return ERROR;
            EndSl;

          EndIf;

          blnIFSCreated = FALSE;
          clear qusa0200;
          rc = GetArcAtr( aSpyNumber
                        : %addr(qusa0200)
                        : %size(qusa0200)
                        : 0);

          Clear strHEXFID;
          Clear strFID;
          %subst(strHEXFID:1:32) = %subSt(qusudd00:1:32);
          cvtch(%addr(strFID):%addr(strHEXFID):%size(strHEXFID));

          strOrgPDFPath0 = *blanks;
          strOrgPDFPath  = *blanks;

          Callp(e) GetPath( %addr(strOrgPDFPath0)
                          : %size(strOrgPDFPath0)
                          : %addr(strFID));

          // If the value Returned is blank
          // Set the temporary file to the name
          // HEX representation of the file.


          If DocMgrPath = *blanks;
            // Capture the temporary IFS Path
            getDocMgrPath('*TEMP':docMgrPath);

            // Test for the existing path
            docMgrPath0 = %trimr(docMgrPath) + x'00';
            p_dirHdl = opendir(%addr(docMgrPath0));

            If p_dirHdl = *NULL;
              Cmd('MKDIR DIR(' + QUOTE + %trim(docMgrPath) + QUOTE + ')');
            Else;
              Callp(e) CloseDir(p_dirHdl);
            EndIf;
          EndIf; // DocMgrPath

          // Original PDF file does not exist, build path the
          // reconstituted PDF file

          // The file does NOT exist in the IFS
          If strOrgPDFPath0 = *blanks;
            %subst(strOrgPDFPATH0:1:16) = %subst(strHEXFID:17:16);
            strOrgPDFPath0 = %trim(docMgrPath) + '/'                +
                             'doc' + %trim(%str(getUniqueFileName())) + '.pdf' +
                             x'00';
            strOrgPDFPath  = %xlate(x'00':x'40':strOrgPDFPath0);
            blnIFSCreated = FALSE;
          Else;
            // The file DOES exist in the IFS
            // Render the NONE Null representation of the file
            strOrgPDFPath  = %xlate(x'00':x'40':strOrgPDFPath0);
          EndIf;

          // Check to see if the file already exist
          If Access(strOrgPDFPath0: F_OK) = SUCCESS;

            PDFStat(%trimr(strOrgPDFPath):%addr(pPDFInfoDS));

            If (aPageBegin <> 1) or
                 ((aPageEnd <> LAST) and (aPageEnd < pi_pages));
              // Capture a page subset
              PDFExtractAdd(strOrgPDFPath : aPageBegin : aPageEnd);
              strTmpPDFPath = %trim(docMgrPath) + '/' +
                              %trim(GetPathFile(strOrgPDFPath));
              strTmpPDFPath0 = %trim(strTmpPDFPath) + x'00';
              PDFExtractFinis(strTmpPDFPath);
              // Deallocate the link list
              PDFExtractClose();
              strTmpPDFPath0 = %trim(strTmpPDFPath) + x'00';
              blnIFSCreated = TRUE;
            Else;
            // Copy the entire file
              strOrgPDFPath = %trim(strOrgPDFPath) + x'00'; //T5840
              aFH = Open(strOrgPDFPath:O_RDONLY);           //T5840
              if %addr(aPDFPath) <> *null;                  //TEST
                aPDFPath = strOrgPDFPath;                   //J3856
              endif;                                        //TEST
              return 0;                                     //T5840
              Cmd('CPY OBJ(' + QUOTE + %trim(strOrgPDFPath) + QUOTE + ') ' +
              'TODIR(' + QUOTE + %trim(docMgrPath) + QUOTE + ')');
              strTmpPDFPath = %trim(docMgrPath) + '/' +
                              %trim(GetPathFile(strOrgPDFPath));
              strTmpPDFPath0 = %trim(strTmpPDFPath) + x'00';
              blnIFSCreated = TRUE;
            EndIf;
          Else;
          // Get the APF name from the MFLRDIR

            // Derive the library/folder from the MRPTDIR

            Open(e) MRPTDIR7;
            Chain(e) aSpyNumber MRPTDIR7;
            close(e) mrptdir7;

            If %found = FALSE;
              Callp(e) PDFSetLastError('PDF0020':aSpyNumber);
              Return ERROR;
            EndIf;

            If %found = TRUE;

              If apftyp <> APFTYPPDF;
                Callp(e) PDFSetLastError('PDF0014': aSpyNumber);
                Return ERROR;
              EndIf;

              If blnIFSCreated = FALSE;
                intMode = O_CREAT + O_WRONLY + O_CODEPAGE;
                intOFlag = S_IRWXU;

                strTmpPDFPath = %trim(docMgrPath) + '/' +
                            %trim(GetPathFile(strOrgPDFPath));
                strTmpPDFPath0 = %trim(strTmpPDFPath) + x'00';

                intFH = Open( strTmpPDFPath0
                                : O_CREAT+O_WRONLY+O_CODEPAGE
                                : S_IWUSR+S_IRUSR+S_IRGRP+S_IROTH
                                : 819);

                If intFH < OK;
                  p_errno = getErrno();
                  Callp(e) PDFSetLastError('PDF0018': %str(strerror(errno)));
                  Return ERROR;
                EndIf;

J2830           rc = getRscDta();
J2830           DoW rc = OK;

                  // Determine end of buffer. Avoids embedded nulls.
J2830             if rc = EOF;
                    intAPFLen = %size(apfdta);
                    for intAPFLen = %size(apfdta) downto 1;
                      if %subst(apfdta:intAPFLen:1) <> x'00';
                        leave;
                      endif;
                    endfor;
J2830             endif;

                  Callp(e) Write( intFH
                                : apfdta
                                : intAPFLen);

J2830             rc = getRscDta();
                EndDo;

                rc = Close(intFH);         // 5469
                If rc <> SUCCESS or
                  p_errno = getErrno();
                  Callp(e) PDFSetLastError('PDF0018': %str(strerror(errno)));
                  Return ERROR;
                EndIf;

                PDFStat(%trimr(strTmpPDFPath):%addr(pPDFInfoDS));

                If (aPageBegin <> 1) or
                   ((aPageEnd <> LAST) and (aPageEnd < pi_pages));
                  PDFExtractAdd(strTmpPDFPath : aPageBegin : aPageEnd);
                  strTmpPDFPathSub = %trim(docMgrPath) + '/' + 'sub' +
                              %trim(GetPathFile(strOrgPDFPath));
                  strTmpPDFPathSub0 = %trim(strTmpPDFPathSub) + x'00';    // 5469

J3586             If ( PDFExtractFinis(strTmpPDFPathSub) = ERROR );
/                   Return ERROR;
/                 EndIf;

                  // Deallocate the link list
                  PDFExtractClose();
                  strTmpPDFPath0 = %trim(strTmpPDFPath) + x'00';
                  blnIFSCreated = TRUE;

                  If unlink(strTmpPDFPath0) = ERROR;
                    p_errno = getErrno();
                    Callp(e) PDFSetLastError('PDF0018': %str(strerror(errno)));
                    Return ERROR;
                  EndIf;

                  strTmpPDFPath = strTmpPDFPathSub;
                  strTmpPDFPath0 = %trim(strTmpPDFPathSub) + x'00';
                EndIf; // PDF page subset
              EndIf; // blnIFSCreated = FALSE
            EndIf; // File in MRPTDIR
          EndIf;   // Extract from "A" File

          intFH = Open( strTmpPDFPath0
                      : O_RDONLY);

          If intFH = ERROR;
            p_errno = getErrno();
            Callp(e) PDFSetLastError('PDF0021': %str(strerror(errno)));
            Return ERROR;
          Else;
            fstat(intFH:%addr(stat_ds));
            aPDFSize = st_size;
            aFH = intFH;
T4979       if %addr(aPDFPath) <> *null;
/             aPDFPath = strTmpPDFPath0;
/           endif;
            Return SUCCESS;
          EndIf;

      /end-free
     pPDFBufInit       e
      *-----------------------------------------------------------
     pPDFBufRtv        b                   Export
      *-----------------------------------------------------------
      /copy @ifsio
     dPDFBufRtv        pi            10i 0
     d aFH                           10i 0
      * PDF File Handle
     d aBuffer                         *
      * File Buffer
     d aReqSize                      10u 0 Const
      * Requested Size
     d aRtnSize                      10i 0
      * Returned Size
     d MAXBUFFER       c                   32767
     d intBytesRead    s             10i 0
     d ascBuffer       s          32767a

      /free
        If aFH < *zero;
          PDFSetLastError('PDF0023'
                          : 'Invalid file handle');
          Return ERROR;
        EndIf;

        If aBuffer = *null;
          PDFSetLastError('PDF0024'
                          : 'Invalid buffer pointer');
          Return ERROR;
        EndIf;

        If aReqSize <= MAXBUFFER;
          clear ascBuffer;
          intBytesRead = Read(aFH:ascBuffer:aReqSize);
          aRtnSize = intBytesRead;
          // Copy the buffer size returned to the pointer
          // occupied by aBuffer
          memcpy(aBuffer:%addr(ascBuffer):intBytesRead);
          Return SUCCESS;
        Else;
          PDFSetLastError( 'PDF0022'
                         : %trim(%editc(aReqSize:'Z'))    +
                           ' exceeds maximum request '    +
                           %trim(%editc(MAXBUFFER:'Z')));
          RETURN ERROR;
        EndIf;
      /end-free

     pPDFBufRtv        e
      *-----------------------------------------------------------
     pPDFBufQuit       b                   Export
      *-----------------------------------------------------------
      * Attempt to trap the get path message if there is an error
      *-----------------------------------------------------------
     dAccessFile       pr            10i 0 extproc('access')
     d Path                            *   value options(*string)
     d Mode                          10i 0 value

     dPDFBufQuit       pi            10i 0
     d aFH                           10i 0

     d fileID          ds            16
     d  fi_rsrvd                      8    inz(*allx'00')
     d  fi_path                      10u 0
     d  fi_name                      10u 0
      * File ID of the PDF Document
     d wrkPath         s            256    inz(*blanks)
     d wrkPath0        s            257    inz(*blanks)
     d intReturn       s             10i 0
     d rc              s             10i 0

      /free

       // -1 File Handle Error
       //  0 File Handle not open
       If aFH <= 0;
         intReturn = SUCCESS;
       Else;
         rc = fstat(aFH:%addr(stat_ds));
         fi_path = st_ino_gen;   // HEX FID for path
         fi_name = st_ino;       // HEX FID for filename
         Callp(e) getPath(%addr(wrkPath):%size(wrkPath):%addr(fileID));
         Callp(e) Close(aFH);
         getDocMgrPath('*TEMP':docMgrPath); //T5840

         If wrkPath <> *blanks;
           wrkPath0 = %trim(wrkPath) + x'00';

           // If filehandle opened in original directory, don't delete
           // and just return success. Handle closed above.
           if %scan(%trim(docMgrPath):%trim(wrkPath)) = 0; //T5840
             return SUCCESS;                               //T5840
           endif;                                          //T5840

           If AccessFile(%trimr(wrkPath0):F_OK) = 0; // file exist

             If unlink(wrkPath0) < 0;            // Delete file
               p_errno = getErrno();
               PDFSetLastError('PDF0021':%str(strerror(errno)));
               intReturn = ERROR;      // File did not delete
             Else;
               intReturn = SUCCESS;    // File deleted
             EndIf;

           Else;
             intReturn = SUCCESS;      // File did not exist
           EndIf;

         Else;
           intReturn = ERROR;  // A blank work path was recreated
         EndIf;

       EndIf;                 // Valid file handle

       Return intReturn;
      /end-free
     pPDFBufQuit       e
      *-----------------------------------------------------------
     pObjExist         b
      *-----------------------------------------------------------
      * Check for the existance of an object an return True or false
      *-----------------------------------------------------------
     dObjExist         pi              n
     d fLib                          10a   const
     d fObj                          10a   const
     d fType                         10a   const

      /copy @osapi

     d TRUE            s               n   inz('1')
     d FALSE           s               n   inz('0')
     d CmdObjExist     s           3000a

     c                   Eval      CmdObjExist = 'CHKOBJ OBJ('
     c                             + %trim(fLib) + '/'
     c                             + %trim(fObj) + ') '
     c                             + 'OBJTYPE(' + %trim(fType) + ')'


     c                   callp (e) QCmdExc(CmdObjExist:
     c                                  %len(%trim(CmdObjExist)))

     c                   If        %error
     c                   Return    FALSE
     c                   Else
     c                   Return    TRUE
     c                   EndIf
     pObjExist         e
      *------------------------------------------------------------------
     pGetPathFile      b
      *------------------------------------------------------------------
      * Return the file name from a fully qualified absolute
      * path name.
      *------------------------------------------------------------------
     dGetPathFile      pi           512
     d aPathFile                    512

     d ROOT            c                   '/'
     d intTest         s             10i 0
     d intPos          s             10i 0
     d intStart        s             10i 0
     d aFile           s            512

      /free
        intTest = *zero;
        intPos  = *zero;
        intStart = 1;

        DoU intTest = *zero;
          intTest = %scan(ROOT : aPathFile : intStart);

          If intTest <> *zero;
            intPos = intTest;
            intStart = intPos + 1;
          EndIf;

        EndDo;

        If intPos = 0;
          aFile = aPathFile;
        Else;
          aFile = %subst(aPathFile : intPos + 1);
        EndIf;

        Return aFile;
      /end-free
     pGetPathFile      e
      *************************************************************************
      * Get Resource Data DASD/Offline
      *************************************************************************
J2830p getRscDta       b
     d                 pi            10i 0

     d readOptAFP      pr                  extpgm('MAG1091A')
     d  Opcode                        6    const
     d  OFRNAM                       10    const
     d  RepLoc                        1    const
     d  RtnDSize                      6  0
     d  RtnData                    4079
     d  MsgId                         7
     d  MsgDta                      100
     d rtnDsize        s              6  0

     d beenHere        s               n   static
     d msgID           s              7
     d msgDta          s            100
     d rc              s             10i 0 inz(OK)
     d ERROR           c                   -1
     d CR              c                   x'4F'
     d LF              c                   x'46'

     c     keyFld        klist
     c                   kfld                    fldcod
     c                   kfld                    fldlib

     c     keyAPF        klist
     c                   kfld                    apfrep
     c                   kfld                    apfseq

      /free
       select;
         when reploc = '2';
           exsr readFromOffline;
           if rc <> OK;
             readOptAFP('QUIT':ofrnam:reploc:rtnDSize:apfdta:msgID:msgDta);
           endif;
         other;
           exsr readFromDASD;
           if rc <> OK;
             Close(e) RAPFDBF;
             Cmd('DLTOVR FILE(RAPFDBF) LVL(*JOB)');
             beenHere = '0';
           endif;
       endsl;
       return rc;
       //***********************************************************************
       // Read resource data from DASD
       //***********************************************************************
       begsr readFromDASD;

         if not beenHere;

           mfldLib  = FLDRLB;
           mfldFile = FILNAM;
           mfldr    = FLDR;
           fldcod = mfldr;
           fldlib = mfldlib;

           // Get the APFNam from MFLDDIR
           Open(e) mFldDir;
           Chain(e) keyFld MfldDir;
           close(e) mflddir;
           if not %found or %error;
             Callp(e) PDFSetLastError('PDF0007':
               'Error retrieving resource name from folder directory');
             rc = ERROR;
             leavesr;
           EndIf;
           curApfNam = apfnam;

           If ObjExist(mFldLib : CurAPFNam : '*FILE') = FALSE;
             PDFSetLastError( 'PDF0013'
                            : %trim(mFldLib) + '/' +
                              %trim(CurAPFNam));
             rc = ERROR;
             leavesr;
           EndIf;

           Cmd('OVRDBF FILE(RAPFDBF) ' +
               'TOFILE(' + %trim(mFldLib) + '/' + %trim(CurAPFNam) + ') ' +
               'MBR(RAPFDBF) OVRSCOPE(*JOB)');

           Open(e) RApfDBF;
           If %error = TRUE;
             Callp(e) PDFSetLastError('PDF0016': CurAPFNam);
             rc = ERROR;
             leavesr;
           EndIf;

           apfrep = repind;
           apfseq = *zero;

           beenHere = '1';

         else;

           apfseq = apfseq + 1;

         endif;

         Chain(e) keyAPF ApfDBF;
         if not %found;
           rc = EOF;
         endif;

       endsr;
       //***********************************************************************
       // Read resource data from offline source.
       //***********************************************************************
       begsr readFromOffline;
         clear msgID;
         clear msgDta;
         readOptAFP('RDDATA':ofrnam:reploc:rtnDsize:apfdta:msgID:msgDta);
         select;
           when msgid <> ' ';
             rc = ERROR;
           when rtnDsize = 0;
             rc = EOF;
         endsl;
       endsr;
      /end-free
     p                 e

      *%METADATA                                                       *
      * %TEXT Parse AFP data from an A-file                            *
      *%EMETADATA                                                      *
     H dftactgrp(*no) bnddir('QC2LE')
      ***********---------------------------------------------------------------
      * ParseAFP - Parse AFP commands from an A-file into an output file
      ***********---------------------------------------------------------------
     fRapfDbf   if   e           k disk    usropn
     fOutFile   o  a f32766        disk    usropn
     D
     D CvtHc           PR                  ExtProc('cvthc')
     D  Chars                          *   value
     D  Hex                            *   value
     D  CvtLen                       10i 0 value

      * AFP data structure
     d AFPCmdDS        ds
     d  AFP_Sep                       1a
     d  AFP_Len                       5i 0
     d  AFP_Cmd                       3a

     d  AFP_CmdDta     s          32760a

     d OutRec          ds         32766
     d  OutSep                        1a
     d  OutLen                        5i 0
     d  OutCmd                        6a
     d  OutCmdDta                 32757a

      * large record header definition
     d WspxHdr         ds                  based(pWspxHdr)
     d  EndState                      1a
     d  NonBlkLn                      5u 0
     d  NonBlkLn1                     5u 0
     d  PrvPgPrfRR                   10u 0
     d  PgPrfOfs                      5u 0
     d  FirstPg                      10u 0
     d  NbrPgStr                      5u 0
     d  NbrPgEnd                      5u 0
     d  AtrBits1                      1a
     d  AtrBits2                      1a
     d  LRSize                        5u 0

      * program status
     d                sds
     d  pgmerr                11     15
     d  pgmlin                21     28
     d  syserr                40     46
     d  sysDta                91    170

     d rc              s             10i 0
     d Beenhere        s               n   inz(*Off)
     d Partial         s               n   inz(*Off)
     d NextPage        s               n   inz(*on)
     d CurPos          s             10i 0
     d BytesRem        s             10i 0
     d BytesAvl        s             10i 0
     d length          s             10i 0
     d DtaPos          s             10i 0 inz(1)
     d SplDta          s           4079a

      *-------------------------------------------------------------------------
      *-  mainline
      *-------------------------------------------------------------------------
     c     *entry        plist
     c                   parm                    Afilenm          10
     c                   parm                    AfileLib         10
     c                   parm                    Spynum           10

     c                   eval      cmdStr = 'CHKOBJ OBJ('+%trim(AfileLib)+
     c                             '/'+%trim(Afilenm)+') OBJTYPE(*FILE)'
     c                   exsr      runcl
     c                   if        *in50
     c                   exsr      Quit
     c                   endif

     c                   eval      cmdStr = 'OVRDBF FILE(RAPFDBF) TOFILE(' +
     c                             %trim(AfileLib)+'/'+%trim(Afilenm) +
     c                             ') OVRSCOPE(*CALLLVL)'
     c                   exsr      runcl
     c                   if        *in50
     c                   exsr      Quit
     c                   endif

     c                   open(e)   RapfDbf
     c                   if        not %open(RapfDbf)
     c                   exsr      Quit
     c                   endif

     c                   open(e)   OutFile
     c                   if        not %open(Outfile)
     c                   exsr      Quit
     c                   endif

     c     Spynum        Chain     Rapfdbf                            90
     c  N90SpyNum        reade     Rapfdbf                                90
     c                   dow       *in90 = *off

     c                   exsr      processRcd

     c     SpyNum        reade     Rapfdbf                                90
     c                   enddo

     c                   exsr      Quit
      *------------------------------------------------------------------------
      *- Quit - end program
      *------------------------------------------------------------------------
     c     quit          begsr

     c                   if        %open(Rapfdbf)
     c                   close(e)  Rapfdbf
     c                   endif

     c                   if        %open(OutFile)
     c                   close(e)  OutFile
     c                   endif

     c                   eval      *inlr = *on
     c                   return

     c                   endsr
      *------------------------------------------------------------------------
      *- ProcessRcd - process record
      *------------------------------------------------------------------------
     c     ProcessRcd    begsr

      * set the current record position and the pointer to the Header info
     c                   eval      CurPos = 1


     c                   eval      pWspxHdr = %addr(ApfDta)+%size(ApfDta) -
     c                              %size(WspxHdr)

      * read thru all the "lines" in this large record
     c                   dou       CurPos >= LRSize

     c                   select

      * if we are in the middle of command data
     c                   when      Partial = *on
     c                   if        BytesRem <= LRsize
     c                   eval      %subst(Afp_CmdDta:DtaPos:
     c                             BytesRem) = %subst(ApfDta:CurPos+6:BytesRem)
     c                   eval      CurPos = CurPos + BytesRem
     c                   eval      Partial = *off
     c                   exsr      WrtDisp

     c                   else
      * this command continues to next record
     c                   eval      %subst(Afp_CmdDta:DtaPos:
     c                             LRSize) = %subst(ApfDta:CurPos+6:LRSize)
     c                   eval      Partial = *on
     c                   leave
     c                   endif

      * if we at the beginning of the command
     c                   when      Partial = *off
     c                   eval      AfpCmdDS=%subst(ApfDta:CurPos:
     c                              %size(AfpCmdDS))
      * setup 5A separator flag -
     c                   if        Afp_sep <> x'5A'
     c                   eval      AfpCmdDS = x'5A' + AfpcmdDS
     c                   endif

      * if the current record contains the complete "line"
     c                   if        CurPos+Afp_Len <= LRSize
     c                   eval      %subst(Afp_CmdDta:DtaPos:Afp_Len-5) =
     c                             %subst(ApfDta:Curpos+6:Afp_Len-5)
     c                   eval      CurPos = CurPos+Afp_Len+1
     c                   exsr      WrtDisp

     c                   else

      * if the current record do NOT contain the complete "line" then
      *   break it up and set the flag to continue on the next record.
     c                   eval      BytesAvl = LrSize-(CurPos+6)+1
     c                   eval      BytesRem = (Afp_Len-5) - BytesAvl
     c                   eval      %subst(Afp_CmdDta:DtaPos:BytesAvl) =
     c                             %subst(ApfDta:Curpos+6:BytesAvl)
     c                   eval      DtaPos = DtaPos + BytesAvl
     c                   eval      Partial = *on
     c                   leave
     c                   endif

     c                   endsl

     c                   enddo

     c                   endsr
      *------------------------------------------------------------------------
      *- WrtDisp - Write record
      *------------------------------------------------------------------------
     c     WrtDisp       begsr

     c                   clear                   Outrec

     C                   Eval      OutCmd = *blanks
     C                   Callp     cvthc(%addr(OutCmd):%addr(Afp_Cmd):6)

     c                   eval      OutSep = Afp_sep
     c                   eval      OutLen = Afp_len
     c                   eval      OutCmdDta = Afp_CmdDta
     c                   write     OutFile       OutRec
     c                   eval      DtaPos = 1
     c                   clear                   Afp_CmdDta

     c                   endsr
     c*------------------------------------------------------------------------
     c*- Runcl - run cl command - no error checking
     c*------------------------------------------------------------------------
     c     Runcl         begsr

     c                   eval      cmdlen = %len(%trim(cmdstr))

     c                   call      'QCMDEXC'                            50
     c                   parm                    Cmdstr          300
     c                   parm                    CmdLen           15 5

     c                   endsr

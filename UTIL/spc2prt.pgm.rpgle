      *%METADATA                                                       *
      * %TEXT Copy Image print USRSPC to SplF                          *
      *%EMETADATA                                                      *
      **********-----------------------------------------
      * SPC2PRT  Copy Image Print USRSPC to Print output
      **********-----------------------------------------
      *
/5890 * 12-13-01 KAC handle empty user spaces (no image)
      *  5-04-99 KAC handle AFP streams without seperator (5A)
      * 12-25-98 FID Added AFP Print for CISC systems
      * 12-09-98 FID Added AFP Print output and switched to ILE
      * 11-11-96 FID Add Coverpage Print
      *  9-09-96 FID NEW PROGRAM
      *
     FAFPIMG    O    F 8500        DISK    USROPN
     FSPYATRDTA IF   F 5004        DISK    USROPN
     FPRTIMGX   O    F  132        PRINTER USROPN OFLIND(*IN02)
      *                                                                 **
      *   DO NOT DELETE THE OVERFLOW INDICATOR ON THE PRINTER FILE.     **
      *   THE PROGRAM WON'T WORK ANYMORE FOR MULTIPLE PAGES.            **

     DAtrDtaDS         DS          5004
     D  AtrLen#                1      4i 0
     D  AtrRcd                 5   5000

     D Strm_ASCI       C                   CONST('*USERASCII')
     D Strm_AFP        C                   CONST('*AFPDS')
     D SpcLen#         S             10i 0
     D SpcPos#         S             10i 0
     D OutLen#         S             10i 0
     D                 DS                  INZ
     D  LENALF                 1      9
     D  LENNUM                 1      9  0
     DBIN4DS           DS
     D BIN4#                   1      4i 0
     D BIN4$                   1      4
     D BIN41                   1      1
     D BIN42                   2      2
     D BIN432                  3      4
     D BIN43                   3      3
     D BIN44                   4      4
     DBINDS            DS
     D CMDLEN$                 1      2
     D CMDLEN#                 1      2i 0

     C     *ENTRY        PLIST
     C                   PARM                    UsrSpcNam        10
     C                   PARM                    UsrSpcLib        10
     C                   PARM                    DtaStream        10
     C                   PARM                    OpCode           10
     C                   PARM                    RtnCode           7
      *   dummy values
     C                   MOVEL     '*ORG'        Drawer            4
     C                   MOVEL     '0'           Duplex            1
     c                   EVAL      SpcNamLib=UsrSpcNam + UsrSpcLib
     C                   CLEAR                   RtnCode

      * If closing, flush the any remaining image and quit
     C     OpCode        IFEQ      'CLOSEW'
     C                   select
     c                   when      DtaStream=Strm_ASCI
     C                   exsr      endasci
     c                   when      DtaStream=Strm_AFP
     C                   exsr      endafp
     C                   endsl
     C                   EXSR      QUIT
     C                   ENDIF

      * Get the Size of the UserSpace
     C                   EXSR      GetSpcSiz
     C                   Z-ADD     10            SpcPos#
/5890c                   testn                   LenAlf               66
/    c                   if        not *in66 or LenNum <= 0
/    c                   eval      RtnCode = 'ERR0120'
/    c                   EXSR      SPYERR
/    c                   end

      * Output the print data
     C                   select
     c                   when      DtaStream=Strm_ASCI
     C                   exsr      prtasci
     c                   when      DtaStream=Strm_AFP
     C                   exsr      prtafp
     C                   endsl

     C                   EXSR      RETRN
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  End ASCII Datastream and flush out last buffer
     C     EndAsci       begsr
     C     LastRem       IFNE      0
     C                   MOVEL     OutBuf        AsciOut         132
     C                   EXCEPT    OUT
     C                   ENDIF
     C                   CLOSE     PRTIMGX                              50
     C                   ENDsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  OutPut ASCII Datastream
     C     PrtAsci       begsr

     C                   IF        SplOpn <> '1'
     C                   OPEN      PRTIMGX
     C                   MOVE      '1'           SplOpn
     C                   ENDIF

      * Cat Remainder of last image with Start of current image.
     C     LastRem       IFNE      0
     C                   EVAL      SpcLen#=132-LastRem
     C                   EXSR      ReadSpc
     C                   EVAL      %SUBST(OutBuf:LastRem+1:SpcLen#)=
     C                              %SUBST(SpcDta:1:SpcLen#)
     C                   MOVEL     OutBuf        AsciOut
     C                   EXCEPT    OUT
     C                   EVAL      SpcPos#=SpcPos#+SpcLen#
     C                   EVAL      LenNum=LenNum-SpcLen#
     C                   ENDIF

     C                   Z-ADD     LenNum        LenRem            9 0
     C                   CLEAR                   LastRem
     C                   MOVE      *LOVAL        OutBuf          132
      *--------------------
      * Read and write loop
      *--------------------
     C                   DO        *HIVAL
     C                   EVAL      SpcLen#=132
     C                   EXSR      ReadSpc
     C                   IF        LenRem<132
     C                   Z-ADD     LenRem        LastRem           9 0
     C                   MOVEL     *LOVAL        OutBuf
     C                   EVAL      %SUBST(OutBuf:1:LenRem)=
     C                               %SUBST(SpcDta:1:LenRem)
     C                   LEAVE
     C                   ENDIF
     C                   MOVEL     SpcDta        AsciOut
     C                   EXCEPT    OUT
     C                   SUB       132           LenRem
     C                   ADD       132           SpcPos#
     C                   ENDDO
     C                   ENDsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  End AFPDS Datastream and flush out last buffer
     C     Endafp        begsr

     C                   CLOSE     AFPIMG

     C                   EVAL      PrmDbFile ='AFPIMG    QTEMP'
     C                   EVAL      PrmMember ='AFPIMG  '
     C                   EVAL      PrmOutq   ='SPYGLSOUTQ*LIBL'
     C
     C                   CALL      'QSPPUTF'                            50
     C                   PARM                    PrmDbFile        20
     C                   PARM                    PrmOutq          20
     C                   PARM                    PrmMember        10
     C
     C                   EVAL      ClCmd ='DLTF FILE(QTEMP/AFPIMG)'
     C                   EXSR      RunCl
     C
     C                   ENDsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  Print AFPDS Datastream
     C     Prtafp        begsr
      *         Open spool, if not open yet
     C                   IF        SplOpn <> '1'
     C                   EXSR      OpnOutFil
     C                   ENDIF
      *         Read length for first AFP cmd
     C                   Z-ADD     10            SpcLen#
     C                   EXSR      ReadSpc
     C                   CLEAR                   BIN4#
     c                   if        %subst(spcDta:1:1) = x'5A'
     c                   move      'Y'           sepUsed           1
     C                   EVAL      Bin432=%SUBST(SpcDta:2:2)
     C                   ADD       3             SpcPos#
     c                   else
     c                   move      'N'           sepUsed
     C                   EVAL      Bin432=%SUBST(SpcDta:1:2)
     C                   ADD       2             SpcPos#
     c                   end
     C                   EVAL      CmdLen#=Bin4#

     C                   DOU       SpcPos#>=LenNum

     c                   if        sepUsed = 'Y'
     C                   EVAL      SpcLen#=CmdLen#+1
     C                   else
     C                   EVAL      SpcLen#=CmdLen#
     C                   end
     C                   EXSR      ReadSpc

     C                   CLEAR                   OutDta         8496
     c                   if        sepUsed = 'Y'
     c                   EVAL      OutLen#=CmdLen#+5
     c                   EVAL      %SUBST(OutDta:1:1)=x'5a'
     c                   EVAL      %SUBST(OutDta:2:2)=CmdLen$
     c                   EVAL      %SUBST(OutDta:4:CmdLen#-2)=
     C                                   %SUBST(SpcDta:1:CmdLen#-2)
     C                   else
     c                   EVAL      OutLen#=CmdLen#+4
     c                   EVAL      %SUBST(OutDta:1:2)=CmdLen$
     c                   EVAL      %SUBST(OutDta:3:CmdLen#-2)=
     C                                   %SUBST(SpcDta:1:CmdLen#-2)
     C                   end

     C                   EXCEPT    AfpRcd
      *         Get length for next commant (Its on the end of the buffer)
     c                   if        sepUsed = 'Y'
     C                   EVAL      Bin432=%SUBST(SpcDta:CmdLen#:2)
     C                   else
     C                   EVAL      Bin432=%SUBST(SpcDta:CmdLen#-1:2)
     C                   end
     C                   IF        Bin4#>32768
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      CmdLen#=Bin4#
     C                   ADD       SpcLen#       SpcPos#

     C                   ENDDO

     C                   ENDsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  Get the Size of the USRSPC (First nine bytes)
     C     GetSpcSiz     begsr
     C                   Z-ADD     1             SpcPos#
     C                   Z-ADD     9             SpcLen#
     C                   EXSR      ReadSpc
     C                   EVAL      LenAlf=%Subst(SpcDta:1:9)
     C                   ENDsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  Read the USRSPC
     C     ReadSpc       begsr
     C
     C                   CALL      'QUSRTVUS'
     C                   PARM                    SpcNamLib        20
     C                   PARM                    SpcPos#
     C                   PARM                    SpcLen#
     C                   PARM                    SpcDta        32000

     C                   endsr
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *PSSR         BEGSR
     C                   MOVEL     'ERR0122'     RtnCode
     C                   EXSR      SPYERR
     C                   ENDSR
     C*@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     RETRN         BEGSR
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     QUIT          BEGSR
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     *INZSR        BEGSR
      *     Get OS/400 Version
     C                   CALL      'MAG103R'
     C                   PARM                    OSRLS             6

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  Execute System Command
     C     RunCl         BEGSR
     C                   CALL      'QCMDEXC'                            50
     C                   PARM                    ClCmd           500
     C                   PARM      500           CmdLen           15 5
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
     C     SPYERR        BEGSR
     C                   CALL      'SPYERR'                             50
     C                   PARM      RtnCode       EMSGID            7
     C                   PARM                    EMSGDT          100
     C                   PARM                    EMSGF            10
     C                   PARM                    EMSGFL           10
     C                   EXSR      QUIT
     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  Create and open output file for PUTSPLF format QTEMP/AFPIMG
     C     OpnOutFil     BEGSR

     C                   DO        *HIVAL
     C                   EVAL      ClCmd='CRTPF FILE(QTEMP/AFPIMG) +
     C                                  RCDLEN(8500) SIZE(*NOMAX)'
     C                   EXSR      RunCl
     C                   IF        *IN50
     C                   EVAL      ClCmd='DLTF FILE(QTEMP/AFPIMG)'
     C                   EXSR      RunCl
     C                   ITER
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

     C                   EVAL      ClCmd='OVRDBF FILE(AFPIMG) +
     C                                    TOFILE(QTEMP/AFPIMG) +
     C                                    SEQONLY(*YES 1000) +
     C                                    FRCRATIO(500)'
     C                   EXSR      RunCl
     C                   OPEN      AFPIMG                               50

     C                   EXSR      WrtAtr
     C                   MOVE      '1'           SplOpn            1

     C                   ENDSR
      *@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      *  Write Attribute record
     C     WrtAtr        BEGSR

     C                   OPEN      SPYATRDTA
     C                   IF        OSRls<'V3R6M0'
     C     2             Chain     SPYATRDTA     AtrDtaDS             50
     C                   ELSE
     C     1             Chain     SPYATRDTA     AtrDtaDS             50
     c                   ENDIF

     C                   Z-ADD     8500          Bin4#
     C                   EVAL      %SUBST(AtrRcd:  13: 4)  =BIN4$
     C                   EVAL      %SUBST(AtrRcd:  49:10)  ='DOCIMAGE'
     C                   EVAL      %SUBST(AtrRcd: 130:10)  ='DOCIMAGE'
     C                   EVAL      %SUBST(AtrRcd: 140:10)  ='DOCVIEW'
     C                   EVAL      %SUBST(AtrRcd: 279:10)  ='ImagePrint'
     C                   EVAL      %SUBST(AtrRcd: 377:10)  ='MAG920'
     C                   EVAL      %SUBST(AtrRcd: 387:10)  ='DOCVIEW'
     C                   IF        OSRls<'V3R6M0'
     C                   EVAL      %SUBST(AtrRcd:1121: 8)  ='GAUSS'
     C                   EVAL      %SUBST(AtrRcd:1141:10)  ='DOCUSER'
     C                   EVAL      %SUBST(AtrRcd:1157:23)  =
     C                             'DocImage.tiff:Gauss'
     C                   ELSE
     C                   EVAL      %SUBST(AtrRcd:1127: 8)  ='GAUSS'
     C                   EVAL      %SUBST(AtrRcd:1147:10)  ='DOCUSER'
     C                   EVAL      %SUBST(AtrRcd:1163:23)  =
     C                             'DocImage.tiff:Gauss'
     C                   ENDIF

     C                   EVAL      F1A=%SUBST(AtrRcd:164:1)
     C                   BITON     '0'           F1A               1
     C                   EVAL      %SUBST(AtrRcd: 164: 1)  =F1A

     C                   EVAL      OutLen#=AtrLen#
     C                   EVAL      OutDta=AtrRcd
     C                   EXCEPT    AfpRcd
     C                   ENDSR

     OPRTIMGX   E            OUT
     O                       AsciOut
     OAFPIMG    E            AfpRcd
     O                       OutLen#              4i
     O                       OutDta            8500

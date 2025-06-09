     H Option( *SrcStmt ) dftactgrp(*no) actgrp(*new)

     D PgmSts         SDS                  Qualified
     D  PgmNam           *Proc
     D  CurJob                       10a   Overlay( PgmSts: 244 )
     D  UsrPrf                       10a   Overlay( PgmSts: 254 )
     D  JobNbr                        6a   Overlay( PgmSts: 264 )
     D  CurUsr                       10a   Overlay( PgmSts: 358 )

      **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0 Inz
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      512a

      **-- Api error data structure - NLS support:
     D ERRC0200        Ds                  Qualified
     D  Key                          10i 0 Inz( -1 )
     D  BytPro                       10i 0 Inz( %Size( ERRC0200 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  CcsId                        10i 0
     D  MsgDtaOfs                    10i 0
     D  MsgDtaLen                    10i 0
     D  MsgDta                     5000a

      **-- Global constants:
     D NULL            c                   ''
     D OFS_MSGDTA      c                   16
     D CUR_CCSID       c                   0
     D CUR_CTRID       c                   x'0000'
     D CUR_LNGID       c                   x'000000'
     D CHR_DLM1        c                   0

      **-- Global variables:
     D rc              s             10i 0

      **-- Qlg_Path_Name_t API path:
     D Qlg_Path_Name_t...
     D                 Ds                  Qualified  Align
     D  CcsId                        10i 0 Inz( CUR_CCSID )
     D  CtrId                         2a   Inz( CUR_CTRID )
     D  LngId                         3a   Inz( CUR_LNGID )
     D                                3a   Inz( *Allx'00' )
     D  PthTypI                      10i 0 Inz( CHR_DLM1 )
     D  PthNamLen                    10i 0
     D  PthNamDlm                     2a   Inz( '/ ' )
     D                               10a   Inz( *Allx'00' )
     D  PthNam                     1024a
     D  pPthNam                        *   Overlay( PthNam )

     D ArcPath         Ds                  LikeDs( Qlg_Path_Name_t )
     D                                     Inz( *LIKEDS )

     D DirPath         Ds                  LikeDs( Qlg_Path_Name_t )
     D                                     Inz( *LIKEDS )

      **-- Unzip options:
     D UNZIP100        Ds                  Qualified
     D  Verbose                      10a
     D  Replace                       6a

      **-- Decompress an archive file:
     D ZipUnzip        Pr                  ExtProc( *CWIDEN: 'QzipUnzip' )
     D  CompFileName                       Const  LikeDs( Qlg_Path_Name_t )
     D  DirDecompFile                      Const  LikeDs( Qlg_Path_Name_t )
     D  FmtNam                        8a   Const
     D  UnzipOpt                           Const  LikeDs( UNZIP100 )
     D  Error                     32767a          Options( *VarSize )

      **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )

     D  MsgId                         7a   Const
     D  MsgFil_q                     20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )
     D  CalStkEntLen                 10i 0 Const  Options( *NoPass )
     D  CalStkEntQual                20a   Const  Options( *NoPass )
     D  DspWait                      10i 0 Const  Options( *NoPass )
     D  CalStkEntTyp                 20a   Const  Options( *NoPass )
     D  CcsId                        10i 0 Const  Options( *NoPass )

      **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying

      **-- Send escape message - converted:
     D SndEscMsgC      Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     D  PxCcsId                      10i 0 Const

      **-- Entry parameters:
     D UNZIP           Pr
     D  PxArcPath                  5000a    varying
     D  PxDirPath                  5000a    varying
     D  PxVerbose                    10a
     D  PxReplace                    10a


     D UNZIP           Pi
     D  PxArcPath                  5000a    varying
     D  PxDirPath                  5000a    varying
     D  PxVerbose                    10a
     D  PxReplace                    10a

      /Free

       ArcPath.PthNam = PxArcPath;
       DirPath.PthNam = PxDirPath;

       ArcPath.PthNamLen = %Len( PxArcPath );
       DirPath.PthNamLen = %Len( PxDirPath );

       UNZIP100.Verbose = PxVerbose;
       UNZIP100.Replace = PxReplace;

       ZipUnzip( ArcPath: DirPath: 'UNZIP100': UNZIP100: ERRC0200 );

       If  ERRC0200.BytAvl > *Zero;
          ExSr  EscApiErr;
       Else;
          SndCmpMsg( 'Archive ' + PxArcPath + ' has been decompressed.' );
       EndIf;

       *InLr = *On;

       Return;

       //***********************************************************************
       BegSr  EscApiErr;

         SndEscMsgC( ERRC0200.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0200
                           : ERRC0200.MsgDtaOfs + 1
                           : ERRC0200.MsgDtaLen
                           )
                   : ERRC0200.CcsId
                   );

       EndSr;

      /End-Free

      **-- Send completion message:

     P SndCmpMsg       B

     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying

     D MsgKey          s              4a

      /Free

       SndPgmMsg( 'CPF9897'
             : 'QCPFMSG   *LIBL'
             : PxMsgDta
             : %Len( PxMsgDta )
             : '*COMP'
             : '*PGMBDY'
             : 1
             : MsgKey
             : ERRC0100
            );

       If  ERRC0100.BytAvl > *Zero;
         Return  -1;
       Else;
         Return  0;
       EndIf;

      /End-Free

     P SndCmpMsg       E

      **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying

     D MsgKey          s              4a

      /Free

       SndPgmMsg( PxMsgId
              : PxMsgF + '*LIBL'
              : PxMsgDta
              : %Len( PxMsgDta )
              : '*ESCAPE'
              : '*PGMBDY'
              : 1
              : MsgKey
              : ERRC0100
             );

       If  ERRC0100.BytAvl > *Zero;
         Return  -1;
       Else;
         Return   0;
       EndIf;

      /End-Free

     P SndEscMsg       E

      **-- Send escape message - converted:
     P SndEscMsgC      B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     D  PxCcsId                      10i 0 Const

     D MsgKey          s              4a

      /Free

       SndPgmMsg( PxMsgId
             : PxMsgF + '*LIBL'
             : PxMsgDta
             : %Len( PxMsgDta )
             : '*ESCAPE'
             : '*PGMBDY'
             : 1
             : MsgKey
             : ERRC0100
             : 10
             : '*NONE     *NONE'
             : *Zero
             : '*CHAR'
             : PxCcsId
            );

       If  ERRC0100.BytAvl > *Zero;
         Return  -1;
       Else;
         Return   0;
       EndIf;

      /End-Free

     P SndEscMsgC      E

      *%METADATA                                                       *
      * %TEXT Zip utility                                              *
      *%EMETADATA                                                      *
     H DFTACTGRP(*NO) ACTGRP(*NEW) OPTION(*NODEBUGIO:*SRCSTMT)

      /copy qsysinc/qrpglesrc,qziputil

      /copy qsysinc/qrpglesrc,qusrobjd
      /copy qsysinc/qrpglesrc,qusec


     D PSDS           SDS                  Qualified
     D  runlib                       10A   overlay(PSDS:081)
     D  JobName                      10A   Overlay(PSDS:244)
     D  usrprf                       10A   Overlay(PSDS:254)
     D  JobNbr                        6A   Overlay(PSDS:264)

     D QusROBJD2       PR                  extPgm('QUSROBJD')
     D  rtnData                   65535A   OPTIONS(*VARSIZE)
     D  nRtnDataLen                  10I 0 Const
     D  Format                        8A   Const
     D  QualObj                      20A   Const
     D  ObjType                      10A   Const
     D  api_error                          LikeDS(QUSEC)
     D                                     OPTIONS(*VARSIZE:*NOPASS)

     D qualObj_T       DS                  Qualified
     D  name                         10A
     D  lib                          10A

     D qualObjType_T   DS                  Qualified
     D  name                         10A
     D  lib                          10A
     D  type                         10A

     D entryPList      PR                  extPgm('CTZIP')
     D  obj                                Const LikeDS(qualObj_T)
     D  objtype                      10A   Const
     D  ifsFile                    5000A   Const Varying
     D  subdir                       10A   Const
     D  zipDir                     5000A   Const Varying
     D  zipFile                    5000A   Const Varying
     D  verbose                      10A   Const
     D  comments                    512A   Const Varying

     D zipPath         DS                  LikeDS(qlg_Path_Name_T) Inz
     D objPath         DS                  LikeDS(qlg_Path_Name_T) Inz
     D ifsPath         S           5000A   Varying
     D suffix          S              4A
     D objDesc         DS                  LikeDS(QUSD0100) Inz
     D zipOptions      DS                  LikeDS( QZIP_zip_options_ZIP00100_T )
     D                                     Inz
     D apiError        DS                  LikeDS(QUSEC) Inz(*LIKEDS)
     D object          DS                  LikeDS(qualObjType_T)

     D entryPList      PI
     d  mode                         10    const
     D  obj                                Const LikeDS(qualObj_T)
     D  objtype                      10A   Const
     D  ifsFile                    5000A   Const Varying
     D  subdir                       10A   Const
     D  zipDir                     5000A   Const Varying
     D  zipFile                    5000A   Const Varying
     D  verbose                      10A   Const
     D  comments                    512A   Const Varying

      /free
           *inlr = *on;
           if (zipDir = '*HOME');
             ifsPath = '/home/' + %trimR(psds.usrprf);
           else;
             ifsPath = %TrimR(zipDir);
           endif;

           if (zipFile = '*OBJ');
             ifsPath += '/' + %trimR(obj.name) + '.ZIP';
           elseif (zipFile = '*OBJLIB');
             ifsPath += '/' + %trimR(obj.Lib) + '/' + %trimR(obj.Name) +
                            '.ZIP';
           else;
              ifsPath += '/' + %trimR(zipFile);
           endif;
           EVALR suffix = %TrimR(ifsPath);
           if (suffix <> '.ZIP' and suffix <> '.zip');
              ifsPath += '.ZIP';
           endif;

           zipPath.CCSID = 0;
           zipPath.Country_ID = *ALLX'00';
           zipPath.Language_ID = *ALLX'00';
           zipPath.reserved = *ALLX'00';
           zipPath.reserved2 = *ALLX'00';
           zipPath.path_Type = 0;
           zipPath.path_Name_Delimiter = '/';
           zipPath.path_Length = %len(ifsPath);
           zipPath.path_Name = ifsPath;
           apiError = *ALLX'00';

           if ((obj.name = '*STMF') or (obj.name = '*NONE') or
               (obj.name = ''));
              ifsPath = %trimR(ifsFile);
           else;
             QusROBJD2(objDesc : %size(objDesc) :'OBJD0100':
                        obj : objType : apiError );
             if (objDesc.qusbrtn06 > 0);  // Got something?
                object.name = objDesc.qusobjn00;
                object.lib  = objDesc.qusrl01;
                object.type = %subst(objDesc.QUSOBJT00 : 2);
             endif;

             ifsPath = '/qsys.lib/' + %trimR(object.lib) + '.lib' + '/' +
                         %trimR(object.name) + '.' + %trimR(object.Type);
           endif;
           objPath.CCSID = 0;
           objPath.Country_ID = *ALLX'00';
           objPath.Language_ID = *ALLX'00';
           objPath.reserved = *ALLX'00';
           objPath.reserved2 = *ALLX'00';
           objPath.path_Type = 0;
           objPath.path_Name_Delimiter = '/';
           objPath.path_Length = %len(ifsPath);
           objPath.path_Name = ifsPath;

           zipOptions.verbose_Option = verbose;
           zipOptions.subtree_Option = subdir;
           if (%Len(comments) > 0 and comments <> '');
              zipOptions.comment = comments;
              zipOptions.comment_Length = %len(comments);
           endif;

           apiError = *ALLX'00';
           qzipzip( objPath : zipPath : 'ZIP00100' : zipOptions : apiError );
           return;
      /end-free

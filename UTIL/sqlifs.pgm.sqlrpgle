     H DatFmt(*ISO)
      /If Defined (*CRTBNDRPG)
     H DftActGrp(*No) ActGrp(*NEW)
      /EndIf
      //*********************************************************************
     D PGMSDS         SDS                  Qualified
     D   MsgTxt               91    140A

     D MyIFSFile       S            256A   Varying
     D                                     Inz('/home/pread/MyQuote.txt')
     D writeIFS        pr
     D  file                        256A   varying const

      //*********************************************************************
      /FREE
       Exec SQL   Set Option  Commit=*None, DatFmt=*ISO, TimFmt=*ISO,
                              Naming=*SYS, CloSQLCsr=*EndActGrp;
       *InLR       = *On;

       Monitor;
          WriteIFS(MyIFSFile);
       On-Error;
          Dsply PGMSDS.MsgTxt;
       EndMon;

       Return;

      /END-FREE
      ************************************************************************
     P WriteIFS        B
     D WriteIFS        PI
     D   ParIFSFile                 256A   Varying Const

     D LocClobFile     S                   SQLTYPE(Clob_File) ccsid(1252)

     D CRLF            S              2A   inz(x'0D25')
      *-----------------------------------------------------------------------
      /Free

        Clear LocClobFile;

        LocClobFile_Name = %Trim(ParIFSFile);
        LocClobFile_NL   = %Len(%Trim(LocClobFile_Name));
        LocClobFile_FO   = SQFOVR;       //Create / Override existing IFS File

        Exec SQL  Set :LocClobFile = 'Always desire to learn something useful.'
                                     concat :CRLF;

        LocClobFile_FO   = SQFAPP;      //Add Data

        Exec SQL  Set :LocClobFile = 'Success has a simple formula: ' concat
                                     'do your best, and people may like it. '
                                     concat :CRLF;

      /End-Free
     P WriteIFS        E

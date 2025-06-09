      *%METADATA                                                       *
      * %TEXT Populate Audit Log for Testing                           *
      *%EMETADATA                                                      *
     h dftactgrp(*no) bnddir('SPYBNDDIR')

      /copy @mlaudlog

      * Get next record id
     d getnum          pr                  extpgm('GETNUM')
     d  opcode                        6    const
     d  type                         10    const
     d  rtnval                       10

     d init            pr            10i 0

     d                sds
     d pgmUser               254    263

      /copy @mlaudinp

     d NbrToLog_C      ds             6
     d  NbrToLog                      6s 0 overlay(NbrToLog_C)

     d Top             s               *
     d CtlLst          ds                  based(CtlP)
     d  cl_nextP                       *
     d  cl_key                       10
     d  cl_opcode                     5s 0 overlay(cl_key)
     d  cl_dtltyp                     5s 0 overlay(cl_key:*next)
     d  cl_loglvl                     1

     d sqlStmt         s           1024
     d sqlStmtA        s             80    dim(2) ctdata
     d saveOpcode      s                   like(cl_opcode)

     c     *entry        plist
     c                   parm                    NbrToLog_C        6

      /free
       init();
       CtlP = Top;
       saveOpcode = cl_opcode;
       do NbrToLog;
         dow cl_opcode = saveOpcode;
           if cl_NextP = *null;
             CtlP = Top;
           endif;
           AddLogDtl(%addr(LogDS):cl_dtltyp:%addr(
         enddo;
       enddo;
       *inlr = '1';
      /end-free

      **************************************************************************
     p init            b

     d                 pi            10i 0

     d mlaudctl      e ds                  extname(MLAUDCTL)

     d rc              s             10i 0 inz(OK)

     c                   eval      sqlStmt=%trimr(sqlStmtA(1)) + ' ' +
     c                             %trimr(sqlStmtA(2))
     c/exec sql
     c+ prepare stmt from :sqlStmt
     c/end-exec
     c/exec sql
     c+ declare cs cursor for stmt
     c/end-exec
     c/exec sql
     c+ open cs
     c/end-exec

     c                   eval      CtlP = mm_alloc(%size(CtlLst))
     c                   eval      cl_key = *all'0'
     c                   eval      cl_loglvl = AuditFlag
     c                   eval      cl_nextp = mm_alloc(%size(CtlLst))
     c                   eval      Top = mm_alloc(%size(CtlLst))
     c                   callp     memcpy(Top:CtlP:%size(CtlLst))
     c                   eval      CtlP = cl_nextp

     c                   dow       1 = 1
     c/exec sql
     c+ fetch next from cs into :cl_key, :cl_loglvl
     c/end-exec
     c                   if        sqlcod = SQLEOF
     c                   leave
     c                   endif
     c                   if        sqlcod < OK
     c                   eval      rc = #AEINIT
     c                   leave
     c                   endif

      * Load OpCode/DtlTyp/LogLvl combinations into memory.
     c                   eval      cl_nextp = mm_alloc(%size(CtlLst))
     c                   eval      CtlP = cl_nextP

     c                   enddo
     c/exec sql
     c+ close cs
     c/end-exec
     c                   if        rc < OK
     c                   return    rc
     c                   endif

     c                   return    OK

     p                 e
**ctdata sqlStmtA
select a.ckey, ifnull(b.aclogsts,'0') from spyctl a left outer join mlaudctl b
on left (a.ckey,5) = digits(b.acopcode) where cname = '*AUDCTL'

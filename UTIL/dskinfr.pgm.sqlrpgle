     fdskinfd   cf   e             workstn sfile(sfl01:rrn1)

      /copy qsysinc/qrpglesrc,qusec

     d sqlStmt         s            256
     d sqlStmtA        s             80    dim(2) ctdata
     d usingCol        s              6

     c                   exsr      loadSfl01

     c                   dou       *in03 or *in12
     c                   write     fky01
     c                   exfmt     ctl01
     c                   select
     c                   when      *in03 or *in12
     c                   when      *in11
     c                   exsr      loadSfl01
     c                   other
     c                   exsr      readc01
     c                   endsl
     c                   enddo

     c                   eval      *inlr = '1'

     c     loadSfl01     begsr

     c                   eval      *in25 = '1'
     c                   write     ctl01
     c                   eval      *in25 = '0'

     c                   if        viewbycol = ' ' or  viewbycol = 'Library'
     c                   eval      viewbycol = 'User'
     c                   eval      usingCol = 'diobow'
     c                   else
     c                   eval      viewbycol = 'Library'
     c                   eval      usingCol = 'diobli'
     c                   endif
     c                   eval      sqlStmt = 'select ' + usingCol + sqlStmtA(1)+
     c                             %trimr(sqlStmtA(2)) + ' ' + usingCol +
     c                             ' order by ' + usingCol

     c                   exsr      preDclOpn

     c                   eval      rrn1 = 0
     c                   dow       sqlcod = 0
     c/exec sql
     c+ fetch next from csr01 into :ownOrLib, :totalobj, :totalsize
     c/end-exec
     c                   if        sqlcod = 0
     c                   eval      rrn1 = rrn1 + 1
     c                   write     sfl01
     c                   endif
     c                   enddo
     c/exec sql
     c+ close csr01
     c/end-exec

     c                   eval      rrn1 = 1

     c                   endsr

     c     readc01       begsr

     c                   readc     sfl01
     c                   dow       %found and not *in03 and not *in12
     c                   if        option = '1'
     c                   eval      option = ' '
     c                   update    sfl01
     c                   exsr      processObj
     c                   enddo
     c                   if        *in12
     c                   eval      *in12 = '0'
     c                   endif

     c                   endsr

     c     processObj    begsr

     c                   exsr      loadSfl02
     c                   dou       *in03 or *in12
     c                   write     fky02
     c                   exfmt     ctl02
     c                   endsr

     c     loadSfl02     begsr

     c                   eval      *in25 = '1'
     c                   write     ctl02
     c                   eval      *in25 = '0'

     c                   eval      sqlStmt = sqlStmtA(1) + sqlStmtA(1)

     c                   exsr      preDclOpn

     c                   eval      rrn2 = 0
     c                   dow       sqlcod = 0
     c/exec sql
     c+ fetch next from csr01
     c/end-exec
     c                   if        sqlcod = 0
     c                   eval      rrn2 = rrn2 + 1
     c                   write     sfl02
     c                   endif
     c                   enddo

     c                   eval      rrn2 = 1

     c                   endsr

     c     preDclOpn     begsr

     c/exec sql
     c+ prepare stmt from :sqlStmt
     c/end-exec
     c/exec sql
     c+ declare csr01 cursor for stmt
     c/end-exec
     c/exec sql
     c+ open csr01
     c/end-exec

     c                   endsr

**ctdata sqlStmtA
, count(*), sum(diobsz) from qusrsys/qaezdisk where diobtp not in('*SYS',  '*INT
') and diobsz > 1000000 group by
select diobnm, diobsz, diobsz from qusrsys/qaezdisk where diobtp not in('*SYS',
 '*INT') and diobsz > 1000000 group by diobnm order by diobnm

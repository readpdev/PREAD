      *
      * The most current installation library needs to be in the library
      * list, i.e., DIN850OBJ.
      *
     fqafdbasi  if   e             disk

     d chkIt           pr                  extproc('chkIt')
     d  opcode                        1    const
     d  file                         10
     d  rlslib                       10
     d  rstlib                       10
     d  oldrls                        3
     d  newrls                        3
     d  rtn                           1
     d rtn             s              1
     d OK              c                   '0'

     c     *entry        plist
     c                   parm                    rlslib           10
     c                   parm                    rstlib           10
     c                   parm                    oldrls            3
     c                   parm                    newrls            3

      /free
       read qafdbasi;
       dow not %eof;
         callp chkIt('I':atfile:rlslib:rstlib:oldrls:newrls:rtn);
         read qafdbasi;
       enddo;
       *inlr = '1';
      /end-free

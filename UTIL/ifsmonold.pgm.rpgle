     d maxidxval       c              7    max count of idx values

      *
     d extidxcnt       s             10i 0                                      index count
      *
      * IFS File structure for exit program
     d exfilds         ds
     d ef_dslen                      10i 0                                      Record length
     d ef_path                      256                                         IFS file path
     d ef_filnam                    256                                         IFS file name
     d ef_fildat                      8  0                                      IFS file yyyymmdd
     d ef_filtim                      6  0                                      IFS file time hhmmss
     d ef_filsiz                     10i 0                                      IFS file size
      *
      * Index description structure for exit program
     d exidxds         ds                  occurs(7)
     d ei_dslen                      10i 0                                      Record length
     d ei_name                       10                                         Index name
     d ei_desc                       30                                         Index description
     d ei_len                         5  0                                      Index Length
      *
      * Index description structure for exit program
     d exvalds         ds                  occurs(7)
     d ev_dslen                      10i 0                                      Record length
     d ev_idxnam                     10                                         Index name
     d ev_value                      99                                         Index value
      *
      ********************************************************************
      * Entry parms
     c     *entry        plist
     c                   parm                    extsts           10            Status
     c                   parm                    exfilds                        Path/name/ext/size
     c                   parm                    extrpttyp        10            Doc Type
     c                   parm                    extidxcnt                      Index count
     c                   parm                    exidxds                        Index description
     c                   parm                    exvalds                        Index Value
     c                   parm                    extrtncde        10            Return Code
     c                   parm                    extrtnmsg       256            Return Message
      * Clear return messages
     c                   clear     extrtncde
     c                   clear     extrtnmsg
      * Check parms
     c                   exsr      checkprm
     c                   select
      * Fill in document class and index values before archiving.
     c                   when      extsts='*BEFORE'
     c                   exsr      getidxval
      * Send message to qsysopr when file has been archive ok
     c                   when      extsts='*AFTER'
     c                   exsr      sndmsg
     c                   endsl
     c                   exsr      quit
      ********************************************************************
      * Check parms
     c     checkprm      begsr
      *
      * Check count of index values
     c                   if        extidxcnt>maxidxval
     c                   eval      extrtncde='*ERROR'
     c                   eval      extrtnmsg='Too many index values!'
     c                   exsr      quit
     c                   endif
      *
      * Don't archive anything that contains 'notme' in the filename
     c     'NOTME'       scan      ef_filnam                              50
     c                   if   *in50
     c                   eval      extrtncde='*NOARC'
     c                   eval      extrtnmsg='NotMe file found!'
     c                   exsr      quit
     c                   endif
      *
     c                   endsr
      ********************************************************************
      * Fill in document class and index values before archiving.
     c     getidxval     begsr
      *
      * Assign report type
     c                   eval      extrpttyp='MAGPATIMG'
      * Change index values, stored in multi occur ds
     c                   do        maxidxval     value#            5 0
     c     value#        occur     exvalds
     c                   select
     c                   when      value#=1
     c                   eval      ev_value='Please'
     c                   when      value#=2
     c                   eval      ev_value='archive'
     c                   when      value#=3
     c                   eval      ev_value='me'
     c                   other
     c                   eval      ev_value=*blanks
     c                   endsl
     c                   enddo
     c                   endsr

      *%METADATA                                                       *
      * %TEXT Create and ouput usrspc for spyexport                    *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp('DOCMGR') bnddir('SPYSPCIO')
      ****************************************************************************
      *  SpyView Ibm Optical support service  program

J4009 *  02-14-12 EPG Correct the field for the sequence number.
/9114 *  06-23-04 JMO Changed logic so that the CSV file name would be consistent
      *                with the name specified.  It was getting appended to the
      *                image file name if one was specified on the EXPOBJSPY cmd.
/7455 *  06-02-04 JMO Fixed call to SPYIFS without a plist
/6859 *  07-10-02 PLR Make sure CSV file has *PUBLIC *RWX authority.
/3393 *  02-12-01 DLS add ignore bad batch parameter
/3033 *  09-19-00 KAC add RLSFRMCD "I" file format
/2930 *  09-18-00 KAC add code page parameter
      *     04-00 FID New program

      ****************************************************************************
     FMRPTDIR7  IF   E           K DISK    usropn
     FRLNKDEF   IF   E           K DISK    usropn
     FRMAINT4   IF   E           K DISK    usropn
     f                                     rename(rmntrc:rmntrc4)
     FRMAINT    IF   E           K DISK    usropn
     FRindex    IF   E           K DISK    usropn
     FAHYPLNKD  IF   E           K DISK    usropn
     FbHYPrptD  IF   E           K DISK    usropn
     FcHYPIDXD  IF   E           K DISK    usropn
      ****************************************************************************
     D/copy @SPYSPCIO
     D/copy @WCCVTDT
     D/copy @ifsio
     D TYP_REPORT      C                   CONST('*REPORT')
     D TYP_SPYLNK      C                   CONST('*SPYLINK')
     D TYP_OMNLNK      C                   CONST('*OMNILINK')
     D TYP_RPTID       C                   CONST('*RPTID')
/3393D BYPASS          C                   CONST('Bypass INVALID IMAGE')
/3393D ERRORS          C                   CONST('ERRORS.TXT')
     D Psds          ESDS                  EXTNAME(CASPGMD)
      ****************************************************************************
      *  Generic header
     d header          ds
     d  hd_size                       9b 0                                      size of space
     d  hd_crtdat                     8  0                                      Creation date
     d  hd_crttim                     6  0                                      Creation time
     d  hd_jobnam                    10                                         current job name
     d  hd_jobusr                    10                                         current job user
     d  hd_jobnum                     6  0                                      current job number
     d  hd_osvers                     6                                         os400 version
     d  hd_spyver                     7                                         spy versio
     d  hd_dtalib                    10                                         data lib
     d  hd_pgmlib                    10                                         pgm lib
     d  hd_ofspar                     9b 0                                      offset parameter sec
     d  hd_lenpar                     9b 0                                      length parameter sec
     d  hd_ofsobj                     9b 0                                      offset object sectio
     d  hd_lenobj                     9b 0                                      length object sectio
     d  hd_numrpt                     9b 0                                      number of report typ
     d  hd_ofsrpt                     9b 0                                      offset to report typ
     d  hd_lenrpt                     9b 0                                      length of report typ
     d  hd_numdoc                     9b 0                                      number docs returned
     d  hd_ofsdoc                     9b 0                                      offset to doc sectio
      *
      * Parameter section header
     d parms           ds
     d  pa_objtyp                    10                                         Object yype
     d  pa_object                    10                                         Object name
     d  pa_segm                      10                                         Segment name
     d  pa_numflt                     9b 0                                      number filter values
     d  pa_ofsflt                     9b 0                                      offset filter values
     d  pa_lenflt                     9b 0                                      length filter values
     d  pa_datfrm                     8                                         date from
     d  pa_datto                      8                                         date to
     d  pa_join                       1                                         join 1/0
     d  pa_format                    10                                         format
     d  pa_path                     256                                         path
      *
      * binaries
     d bin4$           ds
     d  bin4#                         9b 0
      *
      * Object section
     d objdsc          ds
     d  ob_objtyp                    10                                         Object type
     d  ob_objnam                    10                                         Object name
     d  ob_objdsc                    50                                         Object descrtipion
     d  ob_numidx                     9b 0                                      Object number index
     d  ob_ofsidx                     9b 0                                      Object offset index
     d  ob_lenidx                     9b 0                                      Object length index
      *
      * Object index description
     d objidx          ds
     d  oi_idxnam                    10                                         Object index name
     d  oi_idxdsc                    30                                         Object index descrip
     d  oi_idxlen                     9b 0                                      Object index length
      *
      * Report Header
     d rptdsc          ds
     d  rh_rpttyp                    10                                         Report Type
     d  rh_desc                      50                                         Report Description
     d  rh_numidx                     9b 0                                      Number of index fiel
     d  rh_ofsidx                     9b 0                                      Offset report index
     d  rh_lenidx                     9b 0                                      Length of report ind
      *
      * Report Index Description
     d rptidx          ds
     d  ri_idxnam                    10                                         Report index name
     d  ri_idxdsc                    30                                         Report index descrip
     d  ri_idxlen                     9b 0                                      Report index length
      *
      * Document entry
     d docs            ds
     d  dc_ofsprv                     9b 0                                      Prev. offset
     d  dc_ofsnxt                     9b 0                                      Next offset
     d  dc_rcdlen                     9b 0                                      Record length
     d  dc_rpttyp                    10                                         Report type
     d  dc_doctyp                     1                                         Document type
     d  dc_arcdat                     8                                         archive date yyyymmd
     d  dc_spynum                    10                                         Spy number
     d  dc_spyseq                     9  0                                      Seq number
     d  dc_segmnt                    10                                         Segment
     d  dc_path                     256                                         Path
     d  dc_val                       99    dim(7)                               index values
      ****************************************************************************
     D SysDft          DS          1024
     D  SdDtaLib             306    315
      ****************************************************************************
     d value           s             99    dim(7)
     d fltidx          s             10    dim(%elem(value))
     d fltidxdsc       s             30    dim(%elem(value))
     d fltidxlen       s              9b 0 dim(%elem(value))
     d maxidx          s             10i 0 inz(%elem(value))
      *
/3033d IPath           s            256
/2930d CodePage        s             10i 0
     D oflag           S             10i 0
     D mode            S             10u 0
     D fildes          S             10i 0 inz
     D errdes          S             10i 0 inz
     D rtn             S             10i 0 inz
     D Data            s            256    dim(512)
     D DataLen         s             10i 0
/9114d Period_fnd      s             10i 0

     d offset          s              9b 0

     D                 DS                  INZ
     D  IdX                    1     70    DIM(%elem(value))
     D  LNDXN1                 1     10
     D  LNDXN2                11     20
     D  LNDXN3                21     30
     D  LNDXN4                31     40
     D  LNDXN5                41     50
     D  LNDXN6                51     60
     D  LNDXN7                61     70
      *
     d errpth          s            256
     d opnerr          s              1    inz('N')
     d spcnam          s             10    inz('EXPOBJSPY')
     d spclib          s             10    inz('QTEMP')
     d rtncde          s             10i 0
     d crlf            c                   x'0d0a'
      ****************************************************************************
     c     *entry        plist
     c                   parm                    opcode           10
     c                   parm                    object           10
     c                   parm                    objtyp           10
     c                   parm                    segment          10
     c                   parm                    value
     c                   parm                    datefrom          8
     c                   parm                    dateto            8
     c                   parm                    format           10
/2930c                   parm                    TCodePage         5            to code page
     c                   parm                    join              1
     c                   parm                    path            256
     c                   parm                    spynum           10
     c                   parm                    spyseq            9 0
     c                   parm                    replace           1
     c                   parm                    rtnmsg            7
     c                   parm                    rtnmsgdta       256
/3393c                   parm                    ignbatch          1            ignore badbatch
      *
     c                   clear                   rtnmsg
     c                   clear                   rtnmsgdta
      *
     c                   select
     c                   when      opcode='INIT'
     c                   exsr      init
     c                   when      opcode='ADDDOC'
     c                   exsr      adddoc
     c                   when      opcode='UPDDOC'
     c                   exsr      upddoc
     c                   when      opcode='*CSV'
/3033c                              or opcode='*CSVI'
     c                   exsr      expcsv
     c                   when      opcode='QUIT'
     c                   exsr      quit
     c                   endsl
      *
     c                   exsr      return
      ****************************************************************************
      * update document
     C     upddoc        begsr
      *
     c     1             add       hd_ofsdoc     updofs           13 0
      *   loop thru all entries untill right one is found
     c                   do        spyseq        curentry         13 0
      *     Read entry
     c                   eval      rtncde=rtvusrspc(spcnam:spclib:updofs:
     c                                      %size(docs):docs)
      *       Correct entry was found, update path name
     c                   if        curentry=spyseq
     c                   eval      dc_path=path
     c                   eval      rtncde=chgusrspc(spcnam:spclib:updofs:
     c                                      %size(docs):docs)
     c                   leave
     c                   endif
      *     Set pointer to next entru
     c                   eval      updofs=dc_ofsnxt+1
      *
     c                   enddo
      *
     c                   endsr
      ****************************************************************************
      * Add new document to usrspc
     C     adddoc        begsr
      *
      *   update last document structure
     c                   if        lstdocofs<>0
     c                   eval      dc_ofsnxt = curspcpos-1
     c                   eval      rtncde=chgusrspc(spcnam:spclib:lstdocofs+1:
     c                                          %size(docs):docs)
     c                   else
      *        Offset ot first document
     c                   eval      hd_ofsdoc=curspcpos-1
     c                   endif
      *   Build structure for current doc
     c                   eval      dc_ofsprv = lstdocofs
     c                   eval      lstdocofs = curspcpos-1
     c                   eval      dc_ofsnxt = 0
     c                   eval      dc_rcdlen = %size(docs)
     c                   eval      dc_rpttyp = object
     c                   eval      dc_segmnt = segment
     c                   eval      dc_arcdat = datefrom
     c                   eval      dc_spynum = spynum
     c                   eval      dc_spyseq = spyseq
     c                   eval      dc_path   = path
     c                   eval      dc_val    = value
     c                   if        %subst(spynum:1:1)='S'
     c                   eval      dc_doctyp = 'R'
     c                   else
     c                   eval      dc_doctyp = 'I'
     c                   endif
      *   Write out record
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                          %size(docs):docs)
      *   add to current pointer
     c                   eval      curspcpos=curspcpos+%size(docs)
      *
      *   update header to contain doc count & offsest
     c                   eval      hd_size=curspcpos-1
     c                   eval      hd_numdoc=hd_numdoc+1
      *   update header to contain proper object description offset
     c                   eval      rtncde=chgusrspc(spcnam:spclib:1:
     c                                          %size(header):header)
      *
     c                   endsr
      ****************************************************************************
     C     QUIT          begsr
     c********           eval      rtncde=dltusrspc(spcnam:spclib)
     C                   move      *ON           *INLR
     C                   RETURN
     C                   endsr
      ****************************************************************************
     C     return        begsr
     C                   RETURN
     C                   endsr
      ****************************************************************************
     C     Init          begsr
      *
     c                   clear                   lstdocofs        13 0
      *
     c                   eval      rtncde=dltusrspc(spcnam:spclib)
     c                   eval      rtncde=crtusrspc(spcnam:spclib:
     c                                               1024000)
     c                   eval      rtncde=chgusrspca(spcnam:spclib:
     c                                       0:'1':x'00')
      *     Get description
     c                   exsr      getdsc
      *     Get filter index names
     c                   if        objtyp=TYP_SPYLNK or
     c                             objtyp=TYP_OMNLNK
     c                   exsr      getfltidx
     c                   endif
      *     Write generic header
     c                   exsr      wrtheader
      *     Write parameter section
     c                   exsr      writeparms
      *     Write filter section
     c                   if        objtyp=TYP_SPYLNK or
     c                             objtyp=TYP_OMNLNK
     c                   exsr      wrtfilter
     c                   endif
      *     Write object description section
     c                   exsr      wrtobjdsc
      *     Write report description section
     c                   exsr      wrtrptrcd
      *
      *     Update header
     c                   eval      hd_size=curspcpos-1
     c                   eval      hd_numdoc=0
     c                   eval      hd_ofsdoc=0
      *   update header to contain proper object description offset
     c                   eval      rtncde=chgusrspc(spcnam:spclib:1:
     c                                          %size(header):header)
      *
     C                   endsr
      ****************************************************************************
      *   Write out report description
     C     wrtrptrcd     begsr
      *
     c                   eval      hd_ofsrpt=curspcpos-1
     c                   eval      hd_lenrpt=%size(rptdsc)
     c                   clear                   hd_numrpt
      *
      *    add report description for the spylink report
     c                   if        objtyp=typ_spylnk
     c                   clear                   currpt            5 0
     c                   add       1             currpt
     c                   exsr      wrtrptdsc
     c                   exsr      wrtrptidx
     c                   endif
      *    add report description for every omnilink report
     c                   if        objtyp=typ_omnlnk
     c                   eval      clcmd='OVRDBF FILE(BHYPRPTD) TOFILE('+
     c                                   %trim(afile)+')'
     c                   exsr      runcl
     c                   open      bhyprptd                             50
     c                   open      rmaint                               50
     c                   open      rlnkdef                              50
     c                   do        2             run               5 0
     c                   clear                   currpt            5 0
     c     object        setll     bhyprptd
     c                   do        *hival
     c     object        reade     bhyprptd                             5050
     c   50              leave
     c                   add       1             currpt
     c     keyomnb5      chain     rmaint                             5050
     c   50              iter
     c     keyomnb5      chain     rlnkdef                            5050
     c   50              iter
     c                   select
     c                   when      run=1
     c                   exsr      wrtrptdsc
     c                   when      run=2
     c                   exsr      wrtrptidx
     c                   endsl
     c                   enddo
     c                   enddo
     c                   endif
      *
     C                   endsr
      ****************************************************************************
      * write report description
     C     wrtrptdsc     begsr
      *
     c                   add       1             hd_numrpt
     c                   reset                   rptdsc
      *
     c                   eval      rh_rpttyp=rtypid
     c                   eval      rh_desc  =rrdesc
     c                   eval      rh_numidx=0
     c                   eval      rh_ofsidx=0
     c                   eval      rh_lenidx=%size(rptidx)
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                      %size(rptdsc):rptdsc)
     c                   eval      curspcpos=curspcpos+%size(rptdsc)
      *
     C                   endsr
      ****************************************************************************
      * write report indexes
     C     wrtrptidx     begsr
      *
      *   Update index count and offset in report description record
     c                   eval      offset=hd_ofsrpt+(currpt-1)*%size(rptdsc)+1
     c                   eval      rtncde=rtvusrspc(spcnam:spclib:offset:
     c                                      %size(rptdsc):rptdsc)
     c                   eval      rh_ofsidx=curspcpos-1
      *
     c                   clear                   totrptidx         5 0
      *   count number of indices
     c                   do        maxidx        ix
     c                   if        idx(ix)=*blanks
     c                   leave
     c                   endif
     c                   eval      iinam=idx(ix)
     c     keyidx        chain     rindex                             5050
     c                   add       1             totrptidx
     c                   reset                   rptidx
     c                   eval      ri_idxnam=idx(ix)
     c                   eval      ri_idxdsc=idesc
     c                   eval      ri_idxlen=iklen
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                      %size(rptidx):rptidx)
     c                   eval      curspcpos=curspcpos+%size(rptidx)
     c                   enddo
      *
      *   Update index count and offset in report description record
     c                   eval      rh_numidx=totrptidx
     c                   eval      rtncde=chgusrspc(spcnam:spclib:offset:
     c                                      %size(rptdsc):rptdsc)
      *
     c                   endsr
      ****************************************************************************
      *   Write out object description
     C     wrtobjdsc     begsr
      *   update header to contain proper object description offset
     c                   eval      hd_ofsobj=curspcpos-1
      *
     c                   reset                   objdsc
      *
     c                   eval      ob_objtyp = objtyp
     c                   eval      ob_objnam = object
     c                   eval      ob_numidx = 0
     c                   eval      ob_ofsidx = 0
     c                   eval      ob_lenidx = 0
     c                   eval      ob_objdsc = rrdesc
      *      for omnilinks take omnilink description
     c                   if        objtyp=typ_omnlnk
     c                   eval      ob_objdsc = adesc
     c                   endif
      *   Write out object description structure
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                          %size(objdsc):objdsc)
      *   Add to current usrspc position
     c                   eval      curspcpos=curspcpos+%size(objdsc)
      *   Write index description
     c                   if        totfltidx>0
     c                   exsr      wrtobjidx
     c                   endif
      *
     C                   endsr
      ****************************************************************************
      * write object index description
     C     wrtobjidx     begsr
      *     Get value for index description offset and len
     c                   eval      ob_ofsidx = curspcpos-1
     c                   eval      ob_lenidx = %size(objidx)
     c                   eval      ob_numidx=totfltidx
      *
     c                   do        totfltidx     ix
     c                   eval      oi_idxnam=fltidx(ix)
     c                   eval      oi_idxdsc=fltidxdsc(ix)
     c                   eval      oi_idxlen=fltidxlen(ix)
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                      %size(objidx):objidx)
     c                   eval      curspcpos=curspcpos+%size(objidx)
     c                   enddo
      *   Update Object description
     c                   eval      rtncde=chgusrspc(spcnam:spclib:hd_ofsobj+1:
     c                                          %size(objdsc):objdsc)
     C                   endsr
      ****************************************************************************
     C     getfltidx     begsr
      *
     c                   clear                   fltidx
     c                   clear                   totfltidx
      *
     c                   select
     c                   when      objtyp=TYP_SPYLNK
     C                   open      rlnkdef                              50
    IC     klbig5        chain     rlnkdef                            50
      *
     C                   open      rindex                               50
      *
     c                   do        maxidx        ix
     c                   if        idx(ix)= *blanks
     c                   leave
     c                   endif
     c                   eval      iinam=idx(ix)
     c     keyidx        chain     rindex                             5050
     c                   add       1             totfltidx
     c                   eval      fltidx(totfltidx)=idx(ix)
     c                   eval      fltidxdsc(totfltidx)=idesc
     c                   eval      fltidxlen(totfltidx)=iklen
     c                   enddo
      *
     c                   when      objtyp=TYP_OMNLNK
     c                   open      chypidxd                             50
     c     object        setll     chypidxd
     c                   do        *hival
     c     object        reade     chypidxd                             5050
     c   50              leave
     c                   add       1             totfltidx         5 0
     c                   eval      fltidx(totfltidx)=cinam
     c                   eval      fltidxdsc(totfltidx)=cdesc
     c                   eval      fltidxlen(totfltidx)=clan
     c                   enddo
      *
     c                   endsl
      *
     C                   endsr
      ****************************************************************************
     C     getdsc        begsr
      *
     c                   select
     c                   when      objtyp=TYP_RPTID
     C                   open      mrptdir7                             50
    IC     Object        chain     mrptdir7                           50
     C                   open      rmaint4                              50
    IC     rpttyp        chain     rmaint4                            50
      *
     c                   when      objtyp=TYP_REPORT
     C                   open      rmaint4                              50
    IC     Object        chain     rmaint4                            50
      *
     c                   when      objtyp=TYP_SPYLNK
     C                   open      rmaint4                              50
    IC     Object        chain     rmaint4                            50
      *
     c                   when      objtyp=TYP_OMNLNK
     c                   open      ahyplnkd                             50
     c     object        chain     ahyplnkd                           5050
      *
     c                   endsl
      *
     C                   endsr
      ****************************************************************************
     C     *inzsr        begsr
      *
     C                   call      'MAG103R'
     C                   parm                    osversion         6
      *
     C                   CALL      'SPYVERSION'
     C                   PARM                    PVER              3
     C                   PARM                    PPTF              2
     C                   PARM                    PBTA              2
     C                   PARM                    PRLSDT            8
     C                   PARM                    PRLSTM            6

     C     *DTAARA       define                  SYSDFT                         Sys Defaults
     C                   in        SYSDFT

     C                   endsr
      ****************************************************************************
/2930C     gettrntbl     begsr
      * get xlate table

     C                   if        TCodePage = *blanks
     C                   eval      ToCCS = '00437'
     C                   else
     C                   eval      ToCCS = TCodePage
     C                   end

     C                   if        ToCCS <> ToCCSsav
     C                   movel     ToCCS         ToCCSsav          5
     C                   call      'SPYCDPAG'
     C                   parm      '00000'       FromCCS           5
     C                   parm                    ToCCS             5
     C                   parm                    ebc             256
     C                   parm                    asc             256
      * Make sure, that character hex 00-1e don't get translated
     C                   EVAL      %SUBST(asc:1:30)=
     C                             %SUBST(ebc:1:30)
     C                   end

     C                   endsr
      ****************************************************************************
      *    get current date
     C     getcurdat     begsr
     C                   CALL      'QWCCVTDT'
     C                   PARM      '*CURRENT'    WCINPF           10
     C                   PARM                    WCINPV           20
     C                   PARM      '*YYMD'       WCOUTF           10
     C                   PARM                    wcoutv
     C                   PARM      *ALLX'00'     ErrRtn           80
     C                   endsr
      ****************************************************************************
     C     writeparms    begsr
      *
     c                   reset                   parms
      *
     c                   eval      pa_objtyp  =  objtyp
     c                   eval      pa_object  =  object
     c                   eval      pa_segm    =  segment
     c                   eval      pa_numflt  =  0
     c                   z-add     maxidx        ix                5 0
     c                   do        maxidx
     c                   if        value(ix)<>*blanks
     c                   leave
     c                   endif
     c                   sub       1             ix
     c                   enddo
     c                   eval      pa_numflt=ix
     c                   eval      pa_ofsflt  =  curspcpos+%size(parms)-1
     c                   eval      pa_lenflt  =  0
     c                   eval      pa_datfrm  =  datefrom
     c                   eval      pa_datto   =  dateto
     c                   eval      pa_join    = join
     c     'YN':'10'     xlate     pa_join       pa_join
     c                   eval      pa_format  = format
     c                   eval      pa_path    = path
      *   write out parms
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                          %size(parms):parms)
      *   Add to current usrspc position
     c                   eval      curspcpos=curspcpos+%size(parms)
      *
     C                   endsr
      ****************************************************************************
     C     wrtfilter     begsr
      *
     c                   z-add     curspcpos     oldspcpos        11 0
      *
     c                   do        pa_numflt     ix
     c     ' '           checkr    value(ix)     bin4#
      *  index name
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                         10:fltidx(ix))
     c                   eval      curspcpos=curspcpos+10
      *  length of value
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                          4:bin4$)
     c                   eval      curspcpos=curspcpos+4
      *  value
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                       bin4#:value(ix))
     c                   eval      curspcpos=curspcpos+bin4#
     c                   enddo
      *
      *   Update parameter section to contain proper length
     c                   eval      pa_lenflt=curspcpos-oldspcpos
     c                   eval      rtncde=chgusrspc(spcnam:spclib:hd_ofspar+1:
     c                                          %size(parms):parms)
      *
     C                   endsr
      ****************************************************************************
     C     wrtheader     begsr
      *
     c                   z-add     1             curspcpos        13 0
      *
     c                   exsr      getcurdat
      *      Reset header structure
     c                   reset                   header
      *   fill header ds
     c                   eval      hd_ofspar = 0
     c                   eval      hd_lenpar = 0
     c                   eval      hd_ofsobj = 0
     c                   eval      hd_lenobj = 0
     c                   eval      hd_numrpt = 0
     c                   eval      hd_ofsrpt = 0
     c                   eval      hd_lenrpt = 0
     c                   eval      hd_numdoc = 0
     c                   eval      hd_ofsdoc = 0
     c                   eval      hd_crtdat = wcdate
     c                   eval      hd_crttim = wctime
     c                   eval      hd_jobnam = wqjobn
     c                   eval      hd_jobusr = wqusrn
     c                   eval      hd_jobnum = wqjob#
     c                   eval      hd_osvers = osversion
     c                   eval      hd_spyver = PVER + PPTF + PPTF
     c                   eval      hd_dtalib = sddtalib
     c                   eval      hd_pgmlib = wqlibn
     c                   eval      hd_ofspar=%size(header)
     c                   eval      hd_lenpar=%size(parms)
     c                   eval      hd_lenobj=%size(objdsc)
      *   write out header
     c                   eval      rtncde=chgusrspc(spcnam:spclib:curspcpos:
     c                                          %size(header):header)
      *   Add to current usrspc position
     c                   eval      curspcpos=curspcpos+%size(header)
      *
     C                   endsr
      ****************************************************************************
     C     runcl         begsr
      *
     c                   call      'QCMDEXC'                            50
     c                   parm                    clcmd           256
     c                   parm      256           cllen            15 5
      *
     C                   endsr
      ****************************************************************************
      *   Export usrspc to ifs *CSV
     C     expcsv        begsr
      *
     c                   exsr      opnoutfil
      *
     c     1             add       hd_ofsdoc     curofs           13 0
      *   loop thru all entries and output them
     c                   do        hd_numdoc     curentry         13 0
      *     Read entry
     c                   eval      rtncde=rtvusrspc(spcnam:spclib:curofs:
     c                                      %size(docs):docs)
/    c                   select
/3033c                   when      opcode='*CSVI'
/    c                   exsr      outrcdI
/    c                   other
     c                   exsr      outrcd
/    c                   endsl
      *     Set pointer to next entru
     c                   eval      curofs=dc_ofsnxt+1
     c                   enddo
      *
     c                   eval      rtn = close(fildes)
      *
     c                   if        opnerr = 'Y'
     c                   eval      rtn = close(errdes)
     c                   eval      opnerr = 'N'
     c                   end
      *
     c                   exsr      quit
      *
     C                   endsr
      ****************************************************************************
      *   open output file
     C     opnoutfil     begsr
/9114
/9114 * find the end of the path and then look for a complete file name

     c                   eval      strpos = %len(%trim(pa_path))
     c                   dow       strpos > 0 and
     c                             %subst(pa_path:strpos:1) <> '/' and
     c                             %subst(pa_path:strpos:1) <> '\'
     c                   eval      strpos = strpos - 1
     c                   enddo

/9114c                   if        strpos = 0
/9114c                   eval      strpos = %len(%trim(pa_path))
/9114c                   else
/9114
/9114c                   eval      period_fnd = %scan('.':pa_path:strpos)
/9114 * if no period found in the last section of the path name
/9114 *   then append the file name as normal
/9114c                   if        period_fnd = 0
/9114c     ' '           checkr    pa_path       strpos            5 0
/9114c                   endif
/9114
/9114c                   endif

     c                   if        %subst(pa_path:strpos:1)='*'
     c                   sub       1             strpos
     c                   endif
      *
     c                   eval      ifspth=%subst(pa_path:1:strpos)+
     c                                      %trim(path)
     c                   eval      errpth=%subst(pa_path:1:strpos)+
     c                                      %trim(errors)

/2930c                   exsr      gettrntbl

     c                   select
      *   If replace=*NO, check if file exists, if so, bail out
     c                   when      replace='N'
     c                   movel(p)  'CHECK'       ifsopc
/7455c                   call      'SPYIFS'      plifs
     c                   if        rtnmsgid=*blanks                             Does exist
     c                   eval      rtnmsg='ERR4095'
     c                   eval      rtnmsgdta=ifspth
     c                   exsr      quit
     c                   endif
      *   When replace=*SEQ call api to get new filename
     c                   when      replace='S'
     c                   movel(p)  'DUPFIL'      ifsopc
     c                   call      'SPYIFS'      plifs
     c                   endsl
      *
     c                   cat       x'00':0       ifspth
     c                   cat       x'00':0       errpth
      *
     C                   eval      oflag = O_WRONLY + O_CREAT + O_TRUNC
/6859C                   eval      mode =  S_IRWXU + S_IRWXG + S_IRWXO
/2930c                   move      ToCCS         CodePage
/    c                   eval      oflag = oflag + O_CODEPAGE
/    c                   eval      fildes = open(Ifspth:oflag:mode:CodePage)
      *
     c                   endsr
      ****************************************************************************
      *   output one record
     C     outrcd        begsr
      *
     c                   clear                   outstring     32000
     c                   clear                   addval          256
     c                   eval      addval=dc_path
     c                   exsr      addvalue
     c                   eval      addval=dc_rpttyp
     c                   exsr      addvalue
     c                   eval      addval=dc_doctyp
     c                   exsr      addvalue
     c                   eval      addval=dc_spynum
     c                   exsr      addvalue
J4009c*                  movel(p)  spyseq        addval
J4009c                   Eval      addval = %char(dc_spyseq)
     c                   exsr      addvalue
     c                   eval      addval=dc_segmnt
     c                   exsr      addvalue
     c                   eval      addval=dc_arcdat
     c                   exsr      addvalue
     c                   do        maxidx        ix
     c                   eval      addval=dc_val(ix)
     c                   exsr      addvalue
     c                   enddo
      *       Add crlf to end
     c     ' '           checkr    outstring     outlen            5 0
     c                   eval      %subst(outstring:outlen:2)=crlf
     c                   add       1             outlen
      *       output to ifs
     c     ebc:asc       xlate     outstring     outstring
      *
     c                   if        dc_path = bypass and
     c                             ignbatch = 'Y'
     c                   if        opnerr <> 'Y'
/    c                   eval      errdes = open(errpth:oflag:mode:CodePage)
     c                   eval      opnerr='Y'
     C                   end
|    C                   eval      rtn = write(errdes:outstring:outlen)
     C                   else
|    C                   eval      rtn = write(fildes:outstring:outlen)
     C                   end
      *
     C                   endsr
      ****************************************************************************
      *  RLSFRMCD I file format
/3033C     outrcdI       begsr
      *
     c                   clear                   outstring     32000
     c                   clear                   addval          256
     c                   eval      addval=rrnam
     c                   exsr      addvalue
     c                   do        totrptidx     ix
     c                   eval      addval=%subst(idx(ix):2)
     c                   exsr      addvalue
     c                   eval      addval=dc_val(ix)
     c                   exsr      addvalue
     c                   enddo
     c     '/':'\'       xlate     dc_path       IPath
     c                   eval      IPath = 'Z:' + %trimr(IPath)                 dummy drive letter
     c                   eval      addval=IPath
     c                   exsr      addvalue
      *       Add crlf to end
     c     ' '           checkr    outstring     outlen            5 0
     c                   eval      %subst(outstring:outlen:2)=crlf
     c                   add       1             outlen
      *       output to ifs
     c     ebc:asc       xlate     outstring     outstring
      *
     c                   if        dc_path = bypass and
     c                             ignbatch = 'Y'
     c                   if        opnerr <> 'Y'
/    c                   eval      errdes = open(errpth:oflag:mode:CodePage)
     c                   eval      opnerr='Y'
     C                   end
|    C                   eval      rtn = write(errdes:outstring:outlen)
     C                   else
|    C                   eval      rtn = write(fildes:outstring:outlen)
     C                   end
      *
     C                   endsr
      ****************************************************************************
     C     addvalue      begsr
     c                   eval      outstring=%trim(outstring)+'"'+
     c                                %trim(addval)+'",'
     C                   endsr
      ****************************************************************************

     C     klbig5        klist
     C                   kfld                    RRNAM
     C                   kfld                    RJNAM
     C                   kfld                    RPNAM
     C                   kfld                    RUNAM
     C                   kfld                    RUDAT

     C     keyomnb5      klist
     C                   kfld                    BRNAM
     C                   kfld                    BJNAM
     C                   kfld                    BPNAM
     C                   kfld                    BUNAM
     C                   kfld                    BUDAT

     C     keyidx        klist
     C                   kfld                    RRNAM
     C                   kfld                    RJNAM
     C                   kfld                    RPNAM
     C                   kfld                    RUNAM
     C                   kfld                    RUDAT
     C                   kfld                    iinam
      *
     c     plifs         plist
     c                   parm                    ifsopc           10
     c                   parm                    ifspth          256
     C                   parm                    Data
     C                   parm                    DataLen
     C                   parm                    FromCCS           5
     C                   parm                    ToCCS             5
     C                   parm                    RtnMsgID          7

      *%METADATA                                                       *
      * %TEXT CGI for Maintaining Key Codes                            *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller) bnddir('SPYBNDDIR':'KEYBNDDIR':'QC2LE')
     h option(*nodebugio)

      * CGI for maintaining key codes in-house.

J6569 * 01-11-17 PLR Add a number of new fields to the initial customer list.
      *              System location, System type, Last Update, Updated By,
      *              Last Comment.
J6507 * 11-11-15 PLR Enforce 999 users for demo products for version < 9.2
J6475 * 10-22-15 PLR Extend import file to Windows.
J6279 * 09-04-15 PLR Add XML import file capability.
J6295 * 06-10-15 PLR Add historical data to the interface.
J6284 * 04-21-15 PLR Identify a term license as a system id not having the value
      *              of DEMO and all selected products have an expiration date.
      *              The date should not exceed 3 years for this condition.
      *              Date validation is handled in java script.
      *              ***
      *              Supress LPAR and Program library for IBM systems when sysID
      *              is DEMO.
J6253 * 04-14-15 PLR Change platform NT to DMWIN. One hard coded reference.
J6122 * 04-07-15 PLR Clicking the search button from an empty customer search
      *              list (did not find record(s) based on search criteria)
      *              results in a logout and a display of the sign in screen.
J6216 * 04-06-15 PLR Add term license enhancement. Allows demo issues to be
      *              locked to a particular machine (node locked).
J5884 * 03-31-15 PLR Enforce certain edits (some in java script) when system id
      *              is set to DEMO.
J6240 * 03-24-15 PLR For 9.2 remove Feature Code and Model from 400 platform.
      *              Not needed. Was used for tiered pricing.
J4720 * 03-18-15 PLR Put up message indicating that one or more records already
      *              exist for a system ID. This is to help reduce the number
      *              of unnecessary duplicate entries. Also add the version to
      *              the new customer prompt. This is to help with displaying
      *              subsequent data without having to go through several steps.
J6084 * 01-27-15 PLR Allow more than 999 licensed users. 999,999.
      * 10-31-14 PLR Add version to list of customers.
      * 10-31-14 PLR Prevent the default number of users from being set the
      *              same the first licensed product in the list.
J1299 * 06-08-09 PLR Add program library checking. Works with LPAR checking
      *              to further constrain customers from loading multiple
      *              unlicensed copies of DocMgr on the same machine.
T6896 * 05-05-08 PLR Add LPAR checking for 8.8.
T5805 * 11-13-06 PLR Add pull-down of valid versions per platform.
T5671 * 10-06-06 PLR Add ability to email key.
T5726 * 09-22-05 PLR Disconnect the system id (skmsid) from evaluations. This
      *              will allow production/sales to issue limited keycodes
      *              for any system; negating the need for system identifiers.
      *              For iSeries, the model and feature code are also excluded
      *              under these circumstances.
T4783 * 09-30-05 PLR Pass variable length key field to MD5 if not iSeries.
      *              Was creating invalid key codes for HP because VP clients
      *              get system id fields with null terminators. In the case
      *              of HP the id was not the 12 byte mac address and
      *              returned a 10 byte id instead.
T4686 * 09-16-05 PLR Removed blanks between keycode for Vista products because
      *              support just cuts and pastes the codes in emails for customers
      *              to apply. Spaces were there for readability.
T4550 * 07-25-05 PLR Increased size of number user license field (SKL#US) from 3 to 6
      *              positions. Added to ACMS.

     fspykeymst uf a e           k disk    usropn
     fspykeymst1if   e           k disk    rename(skmrec:skmrec1) usropn
     fspykeylic uf a e           k disk    usropn
     fspykeyprd if   e           k disk    usropn
     fspykeyhis uf a e           k disk    usropn
     fspykeyhis1if   e           k disk    rename(skhrec:skhrec1) usropn
     fspykeydst if   e           k disk    usropn
     fspykeytif if   e           k disk    usropn
     fspykeypfm if   e           k disk    usropn
T5805fspykeyver if   e           k disk    usropn

      /copy qsysinc/qrpglesrc,qusec
J6279 /copy @ifsio

     d                sds
     d pgmlib                 81     90
     d pgmerrdta              91    170

     d header          s            100    dim(10) ctdata
     d prdhdr          s            100    dim(3) ctdata
     d envNamArr       s             50    dim(1) ctdata
J6279d emlInst         s             70    dim(3) ctdata
J6569d sysTypA         s              4    dim(3) ctdata

     d                 ds
     d chkbox                       100    dim(1) ctdata
     d  chkselect                     7    overlay(chkbox:16)
     d  chkboxnam                     3    overlay(chkbox:43)

     d                 ds
     d handleInfo                    34    dim(50)
     d  handleA                      24    overlay(handleInfo)
     d  handleUser                   10    overlay(handleInfo:*next)
     d                 ds
J6216d elements                     100    dim(70) ctdata
     d  elementID                    10    overlay(elements)
     d  elementTxt                   90    overlay(elements:*next)

J6279d spyIFS          pr                  extpgm('SPYIFS')
     d  opcode                       10    const
     d  path                        256    options(*nopass)
     d  data                      65535    options(*nopass)
     d  dataLen                      10i 0 const options(*nopass)
     d  frCCSID                       5    const options(*nopass)
     d  toCCSID                       5    const options(*nopass)
     d  msgID                         7    options(*nopass)

      * MD5 hashing algorithm prototype.
     D md5hash         pr                  extproc('MD5HashAsc2')
     d  pkey                      32767a   options(*varsize)
     d  ikeylen                      10i 0 value
     d  pdata                     32767a   options(*varsize)
     d  idatalen                     10i 0 value
     d  digest                       16a
     d pdata           s          32767a

     d getProfileHdl   pr                  extpgm('QSYGETPH')
     d  userid                       10
     d  password                     10
     d  handle                       12
     d  error                              like(qusec)
     d  passWordLen                  10i 0 const options(*nopass)
     d  CCSID                        10i 0 const options(*nopass)

     d rmvPgmMsgs      pr                  extpgm('QMHRMVPM')
     d  stack                         1    const
     d  stackCnt                     10i 0 const
     d  msgkey                        4    const
     d  msgToRmv                     10    const
     d  Error                              like(qusec)

     d tiffAuth        pr                  extpgm('SPYKEYTIFR')
     d  sysID                        12
     d  platForm                      5
     d  installSeq#                   4p 0
     d  demoDate                      8s 0
     d  serverName                   40

     d                 ds
     d wrkDate                        8s 0
     d  wrkDate_c                     8    overlay(wrkDate)

     d mstdta        e ds                  extname(spykeymst)
     d msthld        e ds                  extname(spykeymst) prefix(x_)
J6569d commentData   e ds                  extname(spykeynot)
     d licPrd        e ds                  extname(spykeylic)
     d licPrdCur     e ds                  extname(spykeylic) qualified dim(999)
     d licPrdWeb       ds                  qualified dim(999)
     d  sklprd                             like(sklprd)
     d  skl#us                             like(skl#us)
     d  skldmo                             like(skldmo)

     d tifdta        e ds                  extname(spykeytif)

J6279d run             pr            10i 0 extproc('system')
     d  cmdStr                         *   options(*string:*trim) value

      * Convert hex to character.
     d cvthc           pr                  extproc('cvthc')
     d  rcv                            *   value
     d  src                            *   value
     d  rcvlen                       10i 0 value

     d iobuff          s          32767
     d ioblen          s             10i 0
     d inactlen        s             10i 0

     d plistflds       ds
     d  spvw                          1    inz('N')
     d  spvch                         3    inz('000')
     d  spli                          1    inz('N')
     d  splich                        3    inz('000')
     d  spcs                          1    inz('N')
     d  spcsch                        3    inz('000')
     d  spim                          1    inz('N')
     d  sprd                          1    inz('N')
     d  keyold                        8    inz
     d  outsid                        8    inz
     d  model                         4    inz
     d  oversion                      3    inz

     d spydemo         pr                  extpgm('UTL/SPYDEMO')
     d  demoDate                           like(skmdmo_c)
     d  oldkeycode                         like(keyold)
     d  newkeycode                         like(skmkcd)
     d  systemID                           like(outsid)
     d  model                              like(skmmdl)
     d  oldVersion                         like(oversion)
     d  spyViewFlag                        like(spvw)
     d  spyViewLic                         like(spvch)
     d  spyLiteFlag                        like(spli)
     d  spyLiteLic                         like(splich)
     d  rptDistFlag                        like(sprd)
     d  clientSvrFlag                      like(spcs)
     d  clientSvrLic                       like(spcsch)
     d  imageViewFlag                      like(spim)

     d spydemo305      pr                  extpgm('UTL/SPYDEMO305')
     d  demoDate                           like(skmdmo_c)
     d  oldkeycode                         like(keyold)
     d  newkeycode                         like(skmkcd)
     d  systemID                           like(outsid)
     d  model                              like(skmmdl)
     d  oldVersion                         like(oversion)
     d  rptDistFlag                        like(sprd)

     d spydemo400      pr                  extpgm('UTL/SPYDEMO400')
     d  demoDate                           like(skmdmo_c)
     d  oldkeycode                         like(keyold)
     d  newkeycode                         like(skmkcd)
     d  systemID                           like(outsid)
     d  model                              like(skmmdl)
     d  oldVersion                         like(oversion)
     d  rptDistFlag                        like(sprd)

     d spydemo407      pr                  extpgm('UTL/SPYDEMO407')
     d  demoDate                           like(skmdmo_c)
     d  oldkeycode                         like(keyold)
     d  newkeycode                         like(skmkcd)
     d  systemID                           like(outsid)
     d  model                              like(skmmdl)
     d  oldVersion                         like(oversion)
     d  spyViewFlag                        like(spvw)
     d  spyViewLic                         like(spvch)
     d  spyLiteFlag                        like(spli)
     d  spyLiteLic                         like(splich)
     d  rptDistFlag                        like(sprd)
     d  clientSvrFlag                      like(spcs)
     d  clientSvrLic                       like(spcsch)

     d stdin           pr                  extproc('QtmhRdStin')
     d  buffer                             like(iobuff)
     d  bufferLen                          like(ioblen)
     d  inActualLen                        like(inactlen)
     d  error                              like(qusec)

     d stdout          pr                  extproc('QtmhWrStout')
     d  buffer                             like(iobuff)
     d  bufferLen                          like(ioblen)
     d  error                              like(qusec)

     d getEnvVar       pr                  extproc('QtmhGetEnv')
     d  receiver                    100
     d  receiverLen                  10i 0
     d  responseLen                  10i 0
     d  requestVar                   50
     d  requestLen                   10i 0
     d  error                              like(qusec)

     d cvtDB           pr                  extproc('QtmhCvtDb')
     d  dataBaseName                 20
     d  buffer                             like(iobuff)
     d  bufflen                            like(ioblen)
     d  dataBaseBuf                 512
     d  dbLen                        10i 0
     d  available                    10i 0
     d  response                     10i 0
     d  error                              like(qusec)

     d LF              c                   x'15'
T5671d #09             c                   '%09'
/    d #0A             c                   '%0A'
T5671d SQ              c                   ''''
     d DQ              c                   '"'
     d str             s             10i 0
     d end             s             10i 0
     d x               s             10i 0
     d dmodat          s               d
     d wrktxt          s            150
     d datakey         s                   like(skhdky)
     d keyout          ds
     d  ko_p1                         8
     d  ko_p2                         8
     d  ko_p3                         8
     d  ko_p4                         8
     d func            s             40
     d                 ds
     d prd#                           3  0
     d prd#_c                         3    overlay(prd#)
     d                 ds
     d skpprd
     d  skpprd_c                      3    overlay(skpprd)
     d skmver_c        ds
     d  ov                            1    overlay(skmver_c:2)
     d  om                            1    overlay(skmver_c:6)
     d indemo          s               n
     d maxdemo         s               n
     d errind          s               n
     d errinf          s            500
     d dspgenbtn       s               n   inz('0')
     d savsid          s                   like(skmsid)
     d skl#us_c        s              6
     d skldmo_c        s              8    inz(*allx'00')
     d lo              c                   'abcdefghijklmnopqrstuvwxyz'
     d up              c                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     d namkey          s                   like(skmnam)
     d namLen          s             10i 0
     d skmisn          s              4
     d handle          s             12
     d userid          s             10
     d password        s             10
     d skmdmo_c        s              8
     d pos             s             10i 0
     d curHandle       s             24
T4550d ordSelect       s             10
/    d ordSeq          s             10i 0
T4783d keyLen          s             10i 0
/    d MAXKEYLEN       s             10i 0 inz(%size(skmsid))
T5726d untieSysID      s               n
/    d thisKey         s             50    inz('GaussVistaPlusInIrvineCA')
T5671d mailto          s           2048
T6295d totLicPrdCur    s             10i 0 inz
T6295d totLicPrdWeb    s             10i 0 inz
     d sqlStmt         s            512
     d wildCardOper    s              4

J6279D XML_OP_OPEN     c                   1
J6279D XML_OP_WRITE    c                   2
J6279D XML_OP_CLOSE    c                   3

      * Convert CCSID constants
J6279d C_OPEN          c                   1
J6279d C_CONVERT       c                   2
J6279d C_CLOSE         c                   3
J6279d O_CCSID         c                   32
J6279d txtLicFD        s             10i 0
J6279d thisPath        s            256
J6279d oflag           s             10i 0
J6279d rc              s             10i 0
J6279d crlf            c                   x'0D25'
J6279d emailCmd        s           1024
J6279d i               s             10i 0
     d hldver          s                   like(skmver)
     d wrkpfm          s                   like(skmpfm)
J6569d signOnError     s               n   inz(*off)
J6569d updateMsg       s             50

     c     mst_key       klist
     c                   kfld                    skmsid
     c                   kfld                    skmpfm
     c                   kfld                    skmis#

     c     lic_key       klist
     c                   kfld                    skmsid
     c                   kfld                    skmpfm
     c                   kfld                    skmis#
     c                   kfld                    sklprd

     c     his_key       klist
     c                   kfld                    skmsid
     c                   kfld                    skmpfm
     c                   kfld                    skmis#
     c                   kfld                    skmver
     c                   kfld                    sklprd

     c     prod_key      klist
     c                   kfld                    skmpfm
     c                   kfld                    sklprd
      /free
       exec sql set option closqlcsr=*endmod,commit=*none;
       errind = '0';
       run('addlible ' + pgmlib);
       exsr stdin_sr;
       select;
       when func='mailKey';
J6279   exsr genkeysr;
J6279   exsr emailLicense;
J6279   exsr showCust;
       when func='signOn';
        exsr signOn;
       when func='search';
        exsr search;
       when func='custList';
        exsr custList;
       when func='custSelect';
        exsr custSelect;
       when func='addCust';
        exsr addCust;
       when func='addProd';
        exsr addProd;
       when func = 'update';
         exsr genkeysr;
         exsr showCust;
       when func='logOut';
        exsr logOut;
       when func='logIn';
        exsr logIn;
       when func='showCust';
        exsr showCust;
       when func='history';
         exsr showHistory;
       when func='showComments';
         exsr showComments;
       when func='addComment';
         exsr addComment;
       when %subst(func:7:7) = 'COMMENT';
         exsr rmvOrUpdComment;
       endsl;
       exsr stdout_sr;
       exsr unlock_sr;
       return;
       //***********************************************************************
J6279  begsr emailLicense;

J6475    if skmver >= 902 and (skmpfm = '400' or skmpfm = 'DMWIN');
           crtLicFilXML();
         endif;

         crtLicFilTXT();

         // Format email command...subject & body.
         emailCmd = 'sndsmtpemm rcp((' +
           %scanrpl('%7C':'@':%trim(getVal('emailTo='))) + ' *PRI)';
         emailCmd = %trimr(emailCmd) + ') subject(' + sq + 'Open Text License' +
           sq + ') Note(' + sq;
         for i = 1 to %elem(emlInst);
           emailCmd = %trimr(emailCmd) + ' ' + %trimr(emlInst(i));
           if skmver < 902;
             leave;
           endif;
         endfor;
         emailCmd = %trimr(emailCmd) + sq;

         // Attach the appropriate license files.
         emailCmd = %trimr(emailCmd) + ') attach(';
J6475    if skmver >= 902 and (skmpfm = '400' or skmpfm = 'DMWIN');
           emailCmd = %trimr(emailCmd) + '(' + sq + '/TempLicenseFiles/' +
             %trimr(skmsid) + '/LicenseXML.txt' + sq + ' *OCTET *BIN)';
         endif;
         emailCmd = %trimr(emailCmd) + '(' + sq + '/TempLicenseFiles/' +
           %trimr(skmsid) + '/License.txt' + sq + ' *OCTET *TXT))';

         // Send the email.
         run(emailCmd);

         writeHist(%scanrpl('%7C':'@':%trim(getVal('emailTo='))):'EmailTo':' ');
       endsr;
       //***********************************************************************
       begsr unlock_sr;
         if %open(spykeymst);
           unlock spykeymst;
         endif;
         if %open(spykeylic);
           unlock spykeylic;
         endif;
         if %open(spykeyhis);
           unlock spykeyhis;
         endif;
       endsr;
       //***********************************************************************
       begsr signOn;
         userid = getval('USERID=');
         userid = %xlate(lo:up:userid);
         password = getval('PASSWORD=');
         clear qusec;
         qusbprv = %size(qusec);
         getProfileHdl(userid:password:handle:qusec:10:0);
         if qusbavl = 0;
           x = %lookup(' ':handleA);
           cvthc(%addr(curHandle):%addr(handle):%size(curHandle));
           if x > 0;
             handleA(x) = curHandle;
             handleUser(x) = userID;
           else;
             handleA(1) = curHandle;
             handleUser(1) = userID;
           endif;
           exsr search;
         else;
           signOnError = *on;
           exsr login;
         endif;
       endsr;
       //***********************************************************************
       begsr search;
         exsr stdhdr_sr;
         apnd('<table><tr><td>':getElem('addCust'):'</td><td>':lf:
           '<td>':getElem('reset'):'</td>':lf:'<td>':
           getElem('logOut'):'</td></tr></table><br>':lf);
         apnd('<table><tr><td>':getElem('idOrName'):'</td>':
           '<td>':getElem('sidText'):'</td>':
           '<td>(*=Wildcard)</td></tr></table>':lf);
         apnd('<br>':lf);
         apnd(getElem('recently01'):getElem('recently02'));
         apnd(getElem('recently03'):getElem('recently04'));
         apnd(getElem('recently05'):lf:'<br>');
         apnd(getElem('custList'):lf);
       endsr;

       //***********************************************************************
       begsr chkCurHandle;
         curHandle = getVal('curHandle=');
         x = %lookup(curHandle:handleA);
         if curHandle = ' ' or x = 0;
           exsr logOut;
         endif;
         userID = handleUser(x);
       endsr;

       //***********************************************************************
       begsr custList;

         // Search by name or system id.
         skmsid = %xlate(lo:up:getVal('SKMSID='));
         namkey = skmsid;

         // Search by recent user within last x number of days/months.
         skhulc = %xlate(lo:up:getVal('recentUser='));

         select;
           // Search by name or system id;
           when namKey <> ' ';
             //remove any embedded '+' from browswer
             pos = %scan('+':namKey);
             dow pos > 0;
               namKey = %replace(' ':namKey:pos:1);
               pos = %scan('+':namKey);
             enddo;
             wildCardOper = '=';
             if %scan('*':namKey) > 0;
               wildCardOper = 'like';
               namKey = %scanrpl('*':'%':namKey);
             endif;
             sqlStmt = 'select * from spykeymst where ' +
               'skmsid ' + %trim(wildCardOper) + ' ' + sq + %trim(namKey) + sq +
               ' or ' +
               'skmnam ' + %trim(wildCardOper) + ' ' + sq + %trim(namKey) + sq;
           // Search by records added by a particular user within x number of
           // days or months.
           when namKey = ' ';
             sqlStmt = 'select * from spykeymst where exists ' +
               '(select distinct skhsid,skhis# from spykeyhis where ' +
               'skmsid = skhsid and skmis# = skhis#';
             if skhulc <> ' ';
                sqlStmt = %trimr(sqlStmt) + ' and skhulc = ' +
                  sq + %trim(skhulc) + sq;
             endif;
             sqlStmt = %trimr(sqlStmt) + ' and date(left(skhdlc,4) || '
               +sq+'-'+sq+ ' || substr(skhdlc,5,2) || ' +sq+'-'+sq+
               ' || right(skhdlc,2)) between date(now()) - ' +
               %trim(getVal('dayMonthNum=')) + ' ' +
               %trim(getVal('dayMonthTxt=')) + ' and date(now()))';
         endsl;

         exsr stdhdr_sr;

J6122    apnd(getElem('ordSelect'));
         apnd('<table><tr><td>':getElem('search'):'</td><td>':getElem('logOut'):
           '</td></tr></table>':lf);
         apnd(getElem('sltInstCap'):lf);
         apnd(getElem('sltInstT1'):getElem('sltInstT2'):lf);

         exec sql prepare stmt from :sqlStmt;
         exec sql declare c1 cursor for stmt;
         exec sql open c1;
T4550    ordSeq = 0;
         exec sql fetch c1 into :mstdta;
         if sqlcod = 100;
           apnd('<font color=red>No records found. Try again.</font>':lf);
         endif;
         dow sqlcod = 0;
           ordSeq += 1;
           apnd('<tr><td>':'<input type=button name=ordSeq':
             %trim(%char(ordSeq)):' value=':%trim(%char(ordSeq)):
             ' onClick="butVal(':%trim(%char(ordSeq)):')"></td>':lf);
           apnd('<td>':%trim(skmnam):'</td>':lf);
           apnd('<td>':%trim(skmsid):'</td>':lf);
           apnd('<td>':%trim(skmpfm):'</td>':lf);
           apnd('<td>':%trim(getFmtVer(skmver)):'</td>':lf);
J6569      apnd('<td>':%trimr(skmtyp):'</td>':lf);
J6569      apnd('<td>':%trimr(skmloc):'</td>':lf);
J6569      apnd('<td>':%trimr(getLastIssued(skmsid:skmis#)):'</td>':lf);
J6569      apnd('<td><textarea rows=1 readonly>':
             %trimr(getLastComment(skmsid:skmpfm:skmis#)):'</textarea></td>':
             lf);
T4550      apnd('<td><input type=hidden name=sid':%trim(%char(ordSeq)):
/            ' value=':%trim(skmsid):'></td>':lf);
/          apnd('<td><input type=hidden name=isn':%trim(%char(ordSeq)):
/            ' value=':%trim(%char(skmis#)):'></td>':lf);
/          apnd('<td><input type=hidden name=pfm':%trim(%char(ordSeq)):
/            ' value=':%trim(skmpfm):'></td>':lf);
J6569      apnd('</tr>':lf);
           exec sql fetch c1 into :mstdta;
           if ordSeq > 100;
             apnd('<font color=red><b>List exceeds buffer limit. ' +
               'Please narrow search criteria.</b></font>':lf);
             leave;
           endif;
         enddo;
J6569    apnd('</table>');
         exec sql close c1;

       endsr;
       //***********************************************************************
       begsr custSelect;
         ordSelect = getVal('ordSelect=');
         skmisn = getVal('isn'+%trim(ordSelect)+'=');
         skmsid = getVal('sid'+%trim(ordSelect)+'=');
         skmpfm = getVal('pfm'+%trim(ordSelect)+'=');
         skmis# = %int(skmisn);
         clear iobuff;
         chain(e) mst_key spykeymst;
         if %found;
           exsr chkinuse;
           if errind;
             exsr logOut;
           else;
             exsr showCust;
           endif;
         endif;
       endsr;
       //***********************************************************************
       begsr chkinuse;
         errind = '0';
         if %error and pgmerrdta <> ' ';
           exsr stdhdr_sr;
           apnd('<h2>Record in use</h2>':pgmerrdta:'</p></br>');
           iobuff = ' ';
           errind = '1';
         endif;
       endsr;
       //***********************************************************************
       begsr addCust;
         exsr stdhdr_sr;
         apnd('<table><tr><td>':getElem('addProd'):'</td>':lf);
         apnd('<td>':getElem('search'):'</td>':lf);
         apnd('<td>':getElem('logOut'):'</td></tr></table>':lf);
         apnd(getElem('custInfCap'):lf);
         apnd(getElem('sysIdIn'):lf);
         apnd(getElem('pfmOptBox'):lf);
         setll *loval spykeypfm;
         read spykeypfm;
         dow not %eof;
           apnd('<option label=':skfpfm:'>':skfpfm:'</option>':lf);
           read spykeypfm;
         enddo;
         apnd('</select></td></tr></table>':lf);
       endsr;
       //***********************************************************************
       begsr addProd;
         clear mstdta;
         parse('SPYKEYMST':%addr(mstdta));
         skmsid = %xlate(lo:up:skmsid);
         dow 1=1;
           skmis# = skmis# + 1;
           setll mst_key spykeymst;
           if not %equal;
             leave;
           endif;
         enddo;
         // Get the latest version
J5884    setll skmpfm spykeyver;
J5884    read spykeyver;
J5884    skmver = skvver;
J5884    skmlib = %xlate(lo:up:skmlib);
         write skmrec;
         exsr showCust;
       endsr;
       //***********************************************************************
       begsr genkeysr;

         sklprd = 0;
         clear mstdta;
J6295    parse('SPYKEYMST':%addr(mstdta));
         skmis# = %int(getVal('hiddenISN='));
         skmsid = getVal('hiddenSid=');
         skmpfm = getVal('hiddenPfm=');
         msthld = mstdta;
         hldver = skmver;
J6295    chain (skmsid:skmpfm:skmis#) spykeymst;
         if skmver <> hldver;
           skmver = hldver;
         endif;
T5726    untieSysID = '0';
/        if ((skmpfm = 'DMWIN' or skmpfm = '400' or skmpfm = 'UNIX') and
T6214      skmver >= 807 and skmver < 902) or
           (%subst(skmpfm:1:2) = 'VP' and skmver >= 0505) or
           (skmver >= 902 and skmsid = 'DEMO');
/          untieSysID = '1';
/        endif;
         if skmsid <> 'DEMO' and skmver >= 902;
           untieSysID = *off;
         endif;
J6569    if x_skmtyp <> skmtyp;
J6569      writehist('System Type':%trimr(skmtyp):%trimr(x_skmtyp));
J6569    endif;
J6569    if x_skmloc <> skmloc;
J6569      writehist('Location':%trimr(skmloc):%trimr(x_skmloc));
J6569    endif;
         if x_skmver <> skmver and skmver <> 0;
           writehist('Version':%triml(%editw(skmver:'0 .  ')):
             %triml(%editw(x_skmver:'0 .  ')));
         endif;
         if skmpfm = '400';
           if x_skmmdl <> skmmdl and skmmdl <> ' ';
             writehist('model':skmmdl:x_skmmdl);
           endif;
           if x_skmftr <> skmftr and skmftr <> ' ';
             writehist('Processor Feature':skmftr:x_skmftr);
           endif;
           if x_skmdmo <> skmdmo and skmdmo <> 0;
             writehist('Pre 7.00.00 Demo Date':%editw(skmdmo:'    /  /  '):
               %editw(x_skmdmo:'    /  /  '));
           endif;
T6896      if x_skmlpr <> skmlpr and skmlpr <> 0;
/            writeHist('LPAR Number':%triml(%editc(skmlpr:'3')):
/              %triml(%editc(x_skmlpr:'3')));
/          endif;
J1299      if x_skmlib <> skmlib and skmlib <> ' ';
/            writeHist('Program Library':%trimr(skmlib):
/              %trimr(x_skmlib));
/          endif;
         endif;
         // Update the master record.
T6295    mstdta = msthld;

         // Load all of the current licensed products to an array.
         // Make comparison between what is coming in from the browser and
         // what is currently in the database, write changes to licensed
         // product and history files.

         // Load current licensed products to array.
J6295    clear licPrdCur;
J6295    reset totLicPrdCur;
         setll mst_key spykeylic;
         reade mst_key spykeylic;
         dow not %eof;
J6295      totLicPrdCur += 1;
J6295      eval-corr licPrdCur(totLicPrdCur) = licPrd;
           reade mst_key spykeylic;
         enddo;

         // Load selected products to an array from the web interface.
         // Not all fields are replresented in the structure. Just the product
         // id, number of user licenses (zero if not user based) and
         // expiration date.

J6295    clear licPrdWeb;
J6295    reset totLicPrdWeb;
         x = 0;
         str = %scan('=on':iobuff);
         dow str > 0;
           str = str - 3;
           totLicPrdWeb += 1;
           licPrdWeb(totLicPrdWeb).sklprd = %int(%subst(iobuff:str:3));
           str = str + 6;
           if getVal('USERS' + %trim(%char(licPrdWeb(totLicPrdWeb).sklprd)) +
             '=') = ' ';
             licPrdWeb(totLicPrdWeb).skl#us = 0;
           else;
             licPrdWeb(totLicPrdWeb).skl#us =
               %int(getVal('USERS' +
                 %trim(%char(licPrdWeb(totLicPrdWeb).sklprd)) + '='));
           endif;
           if licPrdWeb(totLicPrdWeb).skl#us = 0;
             chain (skmpfm:licPrdWeb(totLicPrdWeb).sklprd) spykeyprd;
             if %found and skputl = 'Y';
               licPrdWeb(totLicPrdWeb).skl#us = 999;
             endif;
           endif;
           if skmver >= 0700 or skmpfm <> '400';
             licPrdWeb(totLicPrdWeb).skldmo = %int(getVal('SKLDMO' +
               %trim(%char(licPrdWeb(totLicPrdWeb).sklprd)) + '='));
             skldmo = licPrdWeb(totLicPrdWeb).skldmo;
             if skldmo < 20000101;
               skldmo = *all'9';
             endif;
           endif;
           if licPrdWeb(totLicPrdWeb).skldmo = 0;
              licPrdWeb(totLicPrdWeb).skldmo =
                %int(%char(%date() + %days(30):*iso0));
           endif;
           if skpkca <> ' ';
             if licPrdWeb(totLicPrdWeb).sklprd = 12;
               parse('SPYKEYTIF':%addr(tifdta));
               if sktsvr = ' ';
                 sktsvr = 'ANY';
               endif;
               tiffAuth(skmsid:skmpfm:skmis#:licPrdWeb(totLicPrdWeb).skldmo:
                 sktsvr);
             endif;
           endif;

           // Update or add selected/updated products from the interface.
           chain (skmsid:skmpfm:skmis#:licPrdWeb(totLicPrdWeb).sklprd)
             spykeylic;
           sklprd = licPrdWeb(totLicPrdWeb).sklprd;
           getdsc();
           if %found(spykeylic);
             getdsc();
             if licPrdWeb(totLicPrdWeb).skl#us <> skl#us;
               writehist(skpdsc:%trim(%char(skl#us)):
                 %trim(%char(licPrdWeb(totLicPrdWeb).skl#us)));
             endif;
             if (skmver >= 0700 and licPrdWeb(totLicPrdWeb).skldmo <> skldmo)
               or skmpfm <> '400';
               writehist(skpdsc:%editw(skldmo:'    /  /  '):
                 %editw(licPrdWeb(totLicPrdWeb).skldmo:'    /  /  '));
             endif;
             eval-corr licPrd = licPrdWeb(totLicPrdWeb);
             if skmver < 0902 and skldmo <> 99999999 and skldmo <> 0 and
               skputl = 'Y' and skl#us = 0;
               skl#us = 999;
             endif;
             update sklrec;
           else;
             sklsid = skmsid;
             sklpfm = skmpfm;
             sklis# = skmis#;
             if skmver < 0902 and skldmo <> 99999999 and skldmo <> 0 and
               skputl = 'Y';
               skl#us = 999;
             endif;
             eval-corr licPrd = licPrdWeb(totLicPrdWeb);
             getdsc();
             write sklrec;
             if skldmo <> *all'9';
               writehist('Demo: ' + skpdsc:'':'*ADDED');
             else;
               writehist(skpdsc:'':'*ADDED');
             endif;
           endif;

           str = %scan('=on':iobuff:str);
         enddo;

         // Determine if any products were unchecked from the web. Delete from
         // SPYKEYLIC and write history record accordingly.
         for x = 1 to totLicPrdCur;
           if %lookup(licPrdCur(x).sklprd:licPrdWeb(*).sklprd) = 0;
             delete (skmsid:skmpfm:skmis#:licPrdCur(x).sklprd) spykeylic;
             sklprd = licPrdCur(x).sklprd;
             getdsc();
             writeHist(skpdsc:' ':'*DELETED');
           endif;
         endfor;

         if skmver < 0700 and skmpfm = '400';
           exsr oldgenkey;
         endif;
         if skmver >= 700 or skmpfm <> '400';
           wrkpfm = skmpfm;
           if wrkpfm = 'DMWIN' and skmver < 902;
             wrkpfm = 'NT';
           endif;
T5726      pdata = %trim(wrkpfm) + %trim(skmsid) + %trim(%editc(skmver:'3'));
J6240      if skmver < 902;
T6240        pdata = %trimr(pdata) + %trim(skmmdl) + %trim(skmftr);
T6240      endif;
J6240      pdata = %trimr(pdata) + %triml(%editc(skmlpr:'Z')) + %trimr(skmlib);
T5726      if untieSysID;
/            pdata = %trim(wrkpfm) + %trim(%editc(skmver:'3'));
/          endif;
           setll mst_key spykeylic;
           reade mst_key spykeylic;
           dow not %eof;
             pdata = %trimr(pdata) + %triml(%editc(sklprd:'3')) +
               %triml(%editc(skl#us:'3')) + %triml(%editc(skldmo:'3'));
T6216        if (untieSysID and skldmo = *all'9');
T5726          pdata = %trimr(pdata) + %trim(skmsid);
J6240          if skmver < 902;
J6240            pdata = %trimr(pdata) + %trim(skmmdl) + %trim(skmftr);
J6240          endif;
J6240          pdata = %trimr(pdata) + %triml(%editc(skmlpr:'Z')) +
J1299            %trimr(skmlib);
T5726        endif;
             reade mst_key spykeylic;
           enddo;
T4783      keyLen = MAXKEYLEN;
/          if skmpfm <> '400';
/            keyLen = %len(%trim(skmsid));
/          endif;
T5726      if untieSysID or (skmver >= 902 and skmsid <> 'DEMO');
/            md5hash(thisKey:%len(%trim(thisKey)):pdata:%len(%trim(pdata)):
/              x_skmkcd);
/          else;
T4783        md5hash(skmsid:keyLen:pdata:%len(%trim(pdata)):x_skmkcd);
T5726      endif;
         endif;
         mstdta = msthld;
J5884    skmlib = %xlate(lo:up:skmlib);
T6295    update(e) skmrec;

         updateMsg = '<font color=green>Updated!</font>';
         if %error;
           updateMsg = '<font color=red>Error on update. Contact developer.' +
             '</font>';
         endif;
       endsr;
       //***********************************************************************
       begsr oldgenkey;
         run('crtdtaara dtaara(qtemp/spydta) type(*char) len(512)');
         reset plistflds;
         skmver_c = %editc(skmver:'X');
         oversion = ov + '0' + om;
         skmdmo_c = %editc(skmdmo:'X');
         skmkcd = ' ';
         // Old version require an 'S' to be at the beginning of the sys id.
         outsid = skmsid;
         if %subst(outsid:1:1) <> 'S';
           outsid = 'S' + outsid;
         endif;
         // Map new permission format to old hard codes.
         setll mst_key spykeylic;
         reade mst_key spykeylic;
         dow not %eof;
           select;
           when sklprd = 1;
             spvw = 'Y';
             spvch = %editc(skl#us:'X');
           when sklprd = 2;
             spli = 'Y';
             spvch = %editc(skl#us:'X');
           when sklprd = 4;
             sprd = 'Y';
           when sklprd = 5;
             spim = 'Y';
           when sklprd = 6;
             spcs = 'Y';
             spcsch = %editc(skl#us:'X');
           endsl;
           reade mst_key spykeylic;
         enddo;
         select;
         when skmver <= 030005;
           spydemo305(skmdmo_c:keyold:skmkcd:outsid:skmmdl:oversion:sprd);
         when skmver >= 030006 and skmver <= 040000;
           spydemo400(skmdmo_c:keyold:skmkcd:outsid:skmmdl:oversion:sprd);
         when skmver >= 040001 and skmver <= 040007;
           spydemo407(skmdmo_c:keyold:skmkcd:outsid:skmmdl:oversion:spvw:
             spvch:spli:splich:sprd:spcs:spcsch);
         when skmver >= 050000;
           spydemo(skmdmo_c:keyold:skmkcd:outsid:skmmdl:oversion:spvw:
             spvch:spli:splich:sprd:spcs:spcsch:spim);
         endsl;
       endsr;
       //***********************************************************************
       begsr stdin_sr;
         ioblen = %size(iobuff);
         clear qusec;
         qusbprv = %size(qusec);
         stdin(iobuff:ioblen:inactlen:qusec);
         func = getval('func=');
         if func <> 'signOn';
           exsr chkCurHandle;
         endif;
       endsr;
       //***********************************************************************
       begsr logOut;
         x = %lookup(curHandle:handleA);
         if x > 0;
           handleA(x) = ' ';
         else;
           close *all;
           *inlr = '1';
         endif;
         exsr login;
         exsr stdout_sr;
         return;
       endsr;
       //************************************************************************
       begsr *inzsr;
         open spykeymst;
         open spykeymst1;
         open spykeylic;
         open spykeyprd;
         open spykeyhis;
         open spykeyhis1;
         open spykeydst;
         open spykeytif;
         open spykeypfm;
T5805    open spykeyver;
         clear qusec;
         qusbprv = %size(qusec);
         rmvPgmMsgs('*':0:' ':'*ALL':qusec);
       endsr;
       //***********************************************************************
       begsr logIn;
         exsr stdhdr_sr;
         apnd(getElem('userID'):lf);
         apnd(getElem('passWord'):lf);
         apnd('<tr><td>':getElem('signOn'):'</td></tr></table>':lf);
         if signOnError = *on;
           apnd('<font color=red>Invalid user id or password. Try Again.':
             '</font>');
           reset signOnError;
         endif;
       endsr;
       //***********************************************************************
J6295  begsr showHistory;
         exsr stdhdr_sr;
         apnd('<table><tr><td>':getElem('license'):'</td><td>':getElem('search')
           :'</td><td>':getElem('logOut'):'</td></tr></table>':lf);
         apnd(getElem('custInfCap'):lf);
         apnd(getElem('sysIdOut'):skmsid:'</td></tr>':lf);
         apnd('<tr><td>Customer Name</td><td>':skmnam:'</td></tr>':lf);
         apnd(getElem('platForm'):skmpfm:'</td></tr>':lf);
         apnd('<tr><td>Software Version</td><td>':%char(skmver):
           '</td></tr>':lf);
         apnd('</table>':lf);
         apnd(getElem('hiddenISN'):%trim(%editc(skmis#:'Z')):'>':lf);
         apnd(getElem('hiddenSid'):%trim(skmsid):'>':lf);
         apnd(getElem('hiddenPfm'):%trim(skmpfm):'>':lf);
         apnd(getElem('histDtaCap'):lf);
         apnd(getElem('hstColRec1'):getElem('hstColRec2'):lf);
         setll (skmsid:skmpfm:skmis#) spykeyhis;
         reade (skmsid:skmpfm:skmis#) spykeyhis;
         if %eof;
           apnd('<b>No historical information found.</b>':lf);
           leavesr;
         endif;
         dow not %eof;
           apnd('<tr><td>':%trim(%char(%date(skhdlc):*iso)):'</td>');
           apnd('<td>':%trim(%char(%time(skhtlc):*iso)):'</td>');
           apnd('<td>':%trim(skhulc):'</td><td>':%trim(skhdky):'</td>');
           apnd('<td>':getFmtVer(skhver):'</td>');
           apnd('<td>':%trim(skhcfr):'</td><td>':%trim(skhcto):'</td></tr>');
           reade (skmsid:skmpfm:skmis#) spykeyhis;
         enddo;
         apnd('</table>':lf);
       endsr;

       //***********************************************************************
       begsr showCust;
         exsr stdhdr_sr;
         apnd(getElem('hiddenISN'):%trim(%editc(skmis#:'Z')):'>':lf);
         apnd(getElem('hiddenSid'):%trim(skmsid):'>':lf);
         apnd(getElem('hiddenPfm'):%trim(skmpfm):'>':lf);
         apnd('<table><tr><td>':getElem('logOut'):'</td><td>':getElem('search'):
           '</td><td>':getElem('history'):'</td><td>':getElem('update'));
         if updateMsg <> ' ';
           apnd('<td>':%trimr(updateMsg));
           clear updateMsg;
         endif;
         apnd('</td></tr></table>':lf);
         apnd(getElem('custInfCap'):lf);
         apnd(getElem('sysIdOut'):skmsid:'</td></tr>':lf);
         apnd(getElem('custName'):skmnam:'"':'></td></tr>':lf);
         apnd(getElem('platForm'):skmpfm:'</td></tr>':lf);
T5805    apnd(getElem('verOptBox'):lf);
/        setll skmpfm spykeyver;
/        reade skmpfm spykeyver;
/        dow not %eof;
/          apnd('<option value=':%editc(skvver:'X'));
/          if skvver = skmver;
/            apnd(' selected');
/          endif;
           apnd('>');
/          apnd(%editc(skvver:'X'):'</option>':lf);
/          reade skmpfm spykeyver;
/        enddo;
/        apnd('</select></td></tr>':lf);
         if skmpfm = '400';
J6240      if skmver < 902;
J6240        apnd(getElem('model'):skmmdl:'></td></tr>':lf);
J6240        apnd(getElem('ftrCode'):skmftr:'></td></tr>':lf);
J6240      endif;
T6896      if (skmver >= 0808 and skmver < 902) or
             (skmver >= 902 and skmsid <> 'DEMO');
/            apnd(getElem('LPAR'):DQ + %triml(%editc(skmlpr:'Z')) + DQ:
               '></td></tr>':lf);
J1299        apnd(getElem('pgmLib'):%trimr(skmlib):'></td></tr>':lf);
T6896      endif;
         endif;
J6569    apnd(getElem('systype'):lf);
J6569    for i = 1 to %elem(sysTypA);
J6569      apnd('<option value=':sysTypA(i));
J6569      if skmtyp = sysTypA(i);
J6569        apnd(' selected');
J6569      endif;
J6569      apnd('>':sysTypA(i):'</option>');
J6569    endfor;
J6569    apnd('</select></td></tr>':lf);
J6569    apnd(getElem('location'):%trimr(skmloc):'"></td></tr>':lf);
J6569    apnd(getElem('lstComment'):
J6569      %trimr(getLastComment(skmsid:skmpfm:skmis#)):'</textarea></td>');
J6569    apnd(getElem('commentBtn'):lf);
         apnd(getElem('custFlag'):skmcst:'></td></tr>':lf);
         if skmver < 0700 and skmpfm = '400';
           keyout = skmkcd;
         else;
           cvthc(%addr(keyout):%addr(skmkcd):32);
         endif;
         apnd(getElem('keyCode'):ko_p1+ko_p2+ko_p3+ko_p4:'</font>':lf); //T4686
         if skmver < 0700 and skmpfm = '400';
           apnd(getElem('pre70Demo'):lf);
         endif;
         apnd('</td></tr>':lf);
         apnd(getElem('emailTo'):lf);
         apnd(getElem('mailKey'):'</td>':lf);
         apnd('</tr></table>':lf);
         if skmver < 700 and skmpfm = '400';
           apnd(prdhdr(1):prdhdr(2):'</b>':lf);
         else;
           apnd(prdhdr(1):prdhdr(2):prdhdr(3):lf);
         endif;
         apnd('</tr>':lf);

         setll mst_key spykeylic;
         reade mst_key spykeylic;
         dow not %eof;
           chkboxnam = %editc(sklprd:'X');
           chkselect = 'checked';
           // Verify that the selected product is valid in the version.
           if getdsc() = ' ';
             delete lic_key spykeylic;
             reade mst_key spykeylic;
             iter;
           endif;
           apnd(chkbox(1):'<td>':GetDsc);
           if sklprd = 12;
             chain mst_key spykeytif;
             if %found;
               apnd('<br>':'Server:':'<input type=text name=SKTSVR maxlength=' +
                 '40 value=':SKTSVR:'><br>Key Code:':sktkcd:lf);
             endif;
           endif;
           apnd('</td>');
           if skl#us > 0;
             apnd(getElem('userBased'):%trim(%editc(sklprd:'Z')):' value=':
               %trim(%editc(SKL#US:'Z')): '></td>');
           else;
             apnd('<td><input type=text name=NUB readonly':
               ' value="Not user based."></td>');
           endif;
           if skmver >= 700 or skmpfm <> '400';
T5726        apnd(getElem('demoDate'):%trim(%editc(sklprd:'Z')):' value=':
/              %editw(skldmo:'    /  /  '):'></td>');
           endif;
           apnd('</tr>');
           reade mst_key spykeylic;
         enddo;

         // add unlicensed products to list for possible selection
         setll skmpfm spykeyprd;
         reade skmpfm spykeyprd;
         dow not %eof;
           if skmver >= skpavf and skmver <= skpavt;
             sklprd = skpprd;
             setll lic_key spykeylic;
             if not %equal;
               chkboxnam = %editc(skpprd:'X');
               chkselect = ' ';
               apnd(chkbox(1):'<td>':%trimr(skpdsc));
               if skpprd = 12;
                 apnd(getElem('tiffServer'));
               endif;
               apnd('</td>':lf);
               if skputl = 'Y';
                 apnd(getElem('userBased'):%trim(%editc(sklprd:'Z')):'></td>');
               else;
                 apnd('<td><input type=text name=NUB readonly':
                   ' value="Not user based."></td>');
               endif;
               if skmver >= 700 or skmpfm <> '400';
                 apnd(getElem('demoDate'):%trim(%editc(sklprd:'Z')):'></td>');
               endif;
               apnd('</tr>':lf);
             endif;
           endif;
           reade skmpfm spykeyprd;
         enddo;
         apnd('</table>':lf);

         apnd('<table><tr><td>':getElem('checkAll'):'</td>':lf);
         apnd('<td>':getElem('unCheckAll'):'</td>':lf);
         apnd('<td>':getElem('demo'):'</td>':lf);
         apnd('<td>':getElem('perm'):'</td>':lf);
         apnd('<td>':getElem('reset'):'</td>':lf);
         apnd('<td>':getElem('update'):'</td>':lf);
         apnd('</tr></table>':lf);

       endsr;

       //***********************************************************************
       begsr stdhdr_sr;
         iobuff = ' ';
         for x=1 to %elem(header);
           apnd(header(x):lf);
         endfor;
       endsr;

       //***********************************************************************
       begsr stdout_sr;
         apnd(getElem('hiddenFunc'):lf);
         apnd('<input type=hidden name=curHandle value="':%trim(curHandle):'">':
           lf);
         apnd('</form></div></html>':lf);
         ioblen = %len(%trim(iobuff));
         clear qusec;
         qusbprv = %size(qusec);
         stdout(iobuff:ioblen:qusec);
         iobuff = ' ';
       endsr;

       //***********************************************************************
J6569  begsr showComments;

         exsr stdhdr_sr;

         apnd('<table cellpadding=5><tr><td>':getElem('license'):'</td><td>':
           getElem('search'):'</td><td>':getElem('logOut'):'</td></tr></table>':
           lf);
         apnd(getElem('custInfCap'):lf);
         apnd(getElem('sysIdOut'):skmsid:'</td></tr>':lf);
         apnd('<tr><td>Customer Name</td><td>':skmnam:'</td></tr>':lf);
         apnd(getElem('platForm'):skmpfm:'</td></tr>':lf);
         apnd('<tr><td>Software Version</td><td>':%trim(getFmtVer(skmver)):
           '</td></tr></table>':lf);
         apnd('<input type=hidden name=sknsid value=':%trim(skmsid):'>':lf);
         apnd('<input type=hidden name=sknpfm value=':%trim(skmpfm):'>':lf);
         apnd('<input type=hidden name=sknis# value=':%trim(%char(skmis#)):'>':
           lf);

         sqlStmt = 'select * from spykeynot where sknsid = ? and ' +
           'sknpfm = ? and sknis# = ? order by skndlc desc';

         exec sql prepare stmt2 from :sqlStmt;
         exec sql declare c2 cursor for stmt2;
         exec sql open c2 using :skmsid, :skmpfm, :skmis#;

         apnd(getElem('commentHdr'):lf);
         apnd('<tr>':getElem('addComment'):'</td>':getElem('addCmtBtn'));
         apnd(getElem('cmtColRec1'):lf);

         exec sql fetch c2 into :commentData;
         if sqlcod = 100; //No comments found.
           apnd(getElem('noComments'):lf);
         endif;

         ordSeq = 0;

         dow sqlcod = 0;
           ordseq += 1;
           if ordseq > 100;
             leave;
           endif;
           apnd('<tr>':%trimr(getElem('rmvCmtBtn')):sq:'REMOVECOMMENT':
             %trim(%char(ordSeq)):sq:')"></td>');
           apnd('<td>':%subst(%char(skndlc:*ISO):1:16):'</td><td>':
             %trimr(sknulc):'</td><td><textarea rows=1 name=skncmt':
             %trim(%char(ordseq)):'>':%trimr(skncmt):'</textarea>':
             '</td>');
           apnd(%trimr(getElem('updCmtBtn')):sq:'UPDATECOMMENT':
             %trim(%char(ordSeq)):sq:')"></td>');
           apnd('<td><input type=hidden name=skndlc':%trim(%char(ordseq)):
             ' value=':%char(skndlc):'></td></tr>':lf);

           exec sql fetch c2 into :commentData;
         enddo;

         exec sql close c2;

         apnd('</table>':lf);

       endsr;

       //***********************************************************************
J6569  begsr addComment;

         parse('SPYKEYNOT':%addr(commentData));
         exec sql insert into spykeynot values(:sknsid,:sknpfm,:sknis#,
           CURRENT TIMESTAMP,:userid,:skncmt);
         exsr showComments;

       endsr;

      /end-free

       //***********************************************************************
J6569  begsr rmvOrUpdComment;

         // Rename the selected SKNCMT9 where 9 is the ordinal number to
         // SKNCMT so that the parser can pick up and format the comment
         // correctly, otherwise, there is a lot of HTML embedded chars in the
         // comment string.
         ordSeq = %int(%subst(func:14:3));
         iobuff = %scanrpl('skncmt' + %trim(%char(ordSeq)):'skncmt':iobuff);
         iobuff = %scanrpl('skndlc' + %trim(%char(ordSeq)):'skndlc':iobuff);
         parse('SPYKEYNOT':%addr(commentData));

         select;
           when %subst(func:1:6) = 'REMOVE';
             exec sql delete from spykeynot where sknsid = :sknsid and sknpfm =
               :sknpfm and sknis# = :sknis# and skndlc = :skndlc;
           when %subst(func:1:6) = 'UPDATE';
             exec sql update spykeynot set
               skncmt = :skncmt where sknsid = :sknsid and sknpfm = :sknpfm and
               sknis# = :sknis# and skndlc = :skndlc and skncmt <> :skncmt;
         endsl;

         exsr showComments;

       endsr;

      /end-free

      **************************************************************************
      * return product description.
     p getdsc          b
     d                 pi            25
      /free
       setll prod_key spykeyprd;
       skpdsc = ' ';
       reade prod_key spykeyprd;
       dow not %eof;
         if skmver >= skpavf and skmver <= skpavt;
           leave;
         endif;
         skpdsc = ' ';
         reade prod_key spykeyprd;
       enddo;
       return skpdsc;
      /end-free
     p                 e
      **************************************************************************
      * write changed data to detail history file.
     p writehist       b
     d writehist       pi
     d  datakey                      25    value
     d  frval                        12    value
     d  toval                        12    value
     d                 ds
     d wrkTime6                       6s 0
     d  wrkTime6_c                    6    overlay(wrkTime6)
      /free
       skhsid = skmsid;
       skhpfm = skmpfm;
       skhis# = skmis#;
       skhdky = datakey;
       skhcfr = frval;
       skhcto = toval;
       wrkDate_c = %char(%date():*ISO0);
       skhdlc = wrkDate;
       wrkTime6_c = %char(%time():*ISO0);
       skhtlc = wrkTime6;
       skhulc = userid;
       skhver = skmver;
       skhprd = sklprd;
       write skhrec;
      /end-free
     p                 e
      **************************************************************************
      * append data to iobuffer for output.
     p apnd            b
     d apnd            pi
     d  val01                       256    value
     d  val02                       256    options(*nopass) value
     d  val03                       256    options(*nopass) value
     d  val04                       256    options(*nopass) value
     d  val05                       256    options(*nopass) value
     d  val06                       256    options(*nopass) value
     d  val07                       256    options(*nopass) value
     d  val08                       256    options(*nopass) value
     d  val09                       256    options(*nopass) value
     d  val10                       256    options(*nopass) value
     d  val11                       256    options(*nopass) value
     d  val12                       256    options(*nopass) value
     d  val13                       256    options(*nopass) value
     d  val14                       256    options(*nopass) value
     d  val15                       256    options(*nopass) value
     d val_a           s            256    dim(15)
     d pcnt            s              5i 0
      /free
       val_a(1) = val01;
       val_a(2) = val02;
       val_a(3) = val03;
       val_a(4) = val04;
       val_a(5) = val05;
       val_a(6) = val06;
       val_a(7) = val07;
       val_a(8) = val08;
       val_a(9) = val09;
       val_a(10) = val10;
       val_a(11) = val11;
       val_a(12) = val12;
       val_a(13) = val13;
       val_a(14) = val14;
       val_a(15) = val15;
       for pcnt=1 to %parms;
         iobuff = %trimr(iobuff) + %trimr(val_a(pcnt));
       endfor;
      /end-free
     p                 e

      **************************************************************************
     p getval          B
     d                 pi           100
     d tagVal                        20    value
     d seps            s              1    dim(4) static
     d beenHere        s               n   static
     d str             s             10i 0
      /free
       if not beenHere;
         seps(1) = '&';
         seps(2) = x'0d';
         seps(3) = x'15';
         seps(4) = x'40';
         beenHere = '1';
       endif;
       str = %scan(%trim(tagval):iobuff);
       if str = 0;
         return ' ';
       endif;
       str = str + %len(%trim(tagval));
       for x = 1 to %elem(seps);
         end = %scan(seps(x):iobuff:str);
         if end > 0;
           leave;
         endif;
       endfor;
       if end = 0;
         return ' ';
       endif;
       return  %subst(iobuff:str:end-str);
      /end-free
     p                 e

      **************************************************************************
      * parse input data to database reference.
     p parse           b
     d parse           pi
     d  cdfnam                       10    value
     d  recadr                         *   value
     d                 ds
     d cdqnam                        20
     d cdbuff          s            512    based(cdb_ptr)
     d cdblen          s             10i 0
     d cdlrav          s             10i 0
     d cdbrsp          s             10i 0
      /free
       cdqnam = cdfnam + pgmlib;
       ioblen = %len(%trimr(iobuff));
       cdb_ptr = recadr;
       cdblen = %len(%trimr(cdbuff));
       clear qusec;
       qusbprv = %size(qusec);
       cvtDB(cdqnam:iobuff:ioblen:cdbuff:cdblen:cdlrav:cdbrsp:qusec);
      /end-free
     p                 e
      **************************************************************************
      * Set/Get environment variables.
     p envVars         b
     d                 pi            50
     d  envName                      50    value

     d envrcvr         s            100
     d envrcvrlen      s             10i 0 inz(%size(envrcvr))
     d envrsplen       s             10i 0
     d envrqstlen      s             10i 0

     d x               s             10i 0
     d envValArr       s             50    dim(1) static
      /free
       x = %lookup(envName:envNamArr);
       if envValArr(x) = ' ';
         envrqstlen = %len(%trim(envName));
         clear qusec;
         qusbprv = %size(qusec);
         getEnvVar(envrcvr:envrcvrlen:envrsplen:envName:envrqstlen:qusec);
         envValArr(x) = %subst(envrcvr:1:envrsplen);
       endif;
       return envValArr(x);
      /end-free
     p                 e
      **************************************************************************
      * Set/Get environment variables.
     p getElem         b
     d                 pi           100
     d  eID                          10    const
      /free
       return elementTxt(%lookup(eID:elementID));
      /end-free
     p                 e

      *****************************************************************
      * Create a text license file that can be sent to customer.
      *****************************************************************
J6279p crtLicFilTXT    b
     d                 pi            10i 0

     d i               s             10i 0
     d txtFD           s             10i 0
     d txtBuffer       s            512

       // Open file for write.
       thisPath = '/TempLicenseFiles/' + %trim(skmsid) + '/';
       spyIFS('CRTPTH':thisPath); // Create path if necessary.
       thisPath = %trimr(thisPath) + 'License.txt';
       thisPath = %trimr(thisPath) + x'00';
       oflag = O_WRONLY + O_CREAT + O_TRUNC + O_CCSID;
       txtFD = open(thisPath:oflag:S_IRWXU+S_IRWXG+S_IRWXO:1252);
       if txtFD < 0;
         return txtFD;
       endif;

       convertCCSID(C_OPEN:*null:0:0:1252);

       //Write all of the license preable (system info).
       writeTxtBuf(txtFD:'Key code: ' + keyOut);
       writeTxtBuf(txtFD:'Platform: ' + %trim(skmpfm));
       writeTxtBuf(txtFD:'System ID: ' + skmsid);
       writeTxtBuf(txtFD:'Version: ' + %editc(skmver:'X'));
       if skmmdl <> ' ' and skmver < 902;
         writeTxtBuf(txtFD:'Model: ' + %trim(skmmdl));
       endif;
       if skmftr <> ' ' and skmpfm = '400' and skmver < 902;
         writeTxtBuf(txtFD:'Feature Code: ' + %trim(skmftr));
       endif;
       if skmlpr <> 0 and skmpfm = '400';
         writeTxtBuf(txtFD:'LPAR Number: ' + %triml(%editc(skmlpr:'Z')));
       endif;
       if skmlib <> ' ' and skmpfm = '400';
         writeTxtBuf(txtFD:'Program Library: ' + %trimr(skmlib));
       endif;

       // Write licensed products.
       setll mst_key spykeylic;
       reade mst_key spykeylic;
       dow not %eof;
         writeTxtBuf(txtFD:getDsc() + ' ' + %editc(skl#us:'Z') +
           ' ' + %editw(skldmo:'    /  /  '));
         reade mst_key spykeylic;
       enddo;

       rc = close(txtFD);
       convertCCSID(C_CLOSE);

       return 0;

     p                 e

      *****************************************************************
J6279p crtLicFilXML    b
     d                 pi            10i 0

     d i               s             10i 0

       // Open XML file for write.
       if xmlHandler(XML_OP_OPEN:'/TempLicenseFiles/' + %trimr(skmsid)) <> 0;
         return -1;
       endif;

       xmlHandler(XML_OP_WRITE:'?xml version="1.0" encoding="UTF-8"?');
       xmlHandler(XML_OP_WRITE:'dms_license');
       xmlHandler(XML_OP_WRITE:'licenseHeader');
       xmlHandler(XML_OP_WRITE:'createInfo':'User=' + %trimr(userID) +
         ',timeStamp=' + %char(%timestamp()));
       xmlHandler(XML_OP_WRITE:'platform':%trim(skmpfm));
       xmlHandler(XML_OP_WRITE:'systemID':%trim(skmsid));
       xmlHandler(XML_OP_WRITE:'version':%editc(skmver:'X'));
       if skmpfm = '400';
         xmlHandler(XML_OP_WRITE:'lpar':%char(skmlpr));
         xmlHandler(XML_OP_WRITE:'library':skmlib);
       endif;
       xmlHandler(XML_OP_WRITE:'key':keyOut);
       xmlHandler(XML_OP_WRITE:'/licenseHeader');
       xmlHandler(XML_OP_WRITE:'licensedProducts');

       // Write licensed products to email attachment.
       setll mst_key spykeylic;
       reade mst_key spykeylic;
       dow not %eof;
         xmlHandler(XML_OP_WRITE:'product');
         xmlHandler(XML_OP_WRITE:'ID':%char(sklprd));
         xmlHandler(XML_OP_WRITE:'description':%trimr(getDsc()));
         xmlHandler(XML_OP_WRITE:'users':%char(skl#us));
         xmlHandler(XML_OP_WRITE:'expiration':%char(skldmo));
         xmlHandler(XML_OP_WRITE:'/product');
         reade mst_key spykeylic;
       enddo;

       xmlHandler(XML_OP_WRITE:'/licensedProducts');
       xmlHandler(XML_OP_WRITE:'/dms_license');

       xmlHandler(XML_OP_CLOSE);

       return 0;

     p                 e

     P*--------------------------------------------------
     P* Procedure name: xmlHandler
     P* Purpose:        Handle XML I/O
     P*--------------------------------------------------
     P xmlHandler      B
     d                 PI            10i 0
     d  xmlOper                      10i 0 const
     d  xmlTag                         *   value
     d                                     OPTIONS(*STRING:*TRIM:*nopass)
     d  xmlText                        *   const
     d                                     options(*string:*trim:*nopass)

     d crlf            c                   x'0D25'
     d rc              s             10i 0
     d xmlBuffer       s            512
     d xmlFD           s             10i 0 static
     d xmlTmpFD        s             10i 0
     d rootPath        s            256    static

       select;
         when xmlOper = XML_OP_OPEN;
           rootPath = %str(xmlTag) + '/';
           thisPath = rootPath;
           convertCCSID(C_OPEN:*null:0:0:1208);
           spyIFS('CRTPTH':thisPath); // Create path if necessary.
           thisPath = %trimr(thisPath) + 'LicenseXML.txt';
           oflag = O_WRONLY + O_CREAT + O_TRUNC + O_CCSID;
           thisPath = %trimr(thisPath) + x'00';
           xmlFD = open(thisPath:oflag:S_IRWXU+S_IRWXG+S_IRWXO:1252);
           if xmlFD < 0;
             return xmlFD;
           endif;
         when xmlOper = XML_OP_WRITE;
           xmlBuffer = '<' + %str(xmlTag) + '>';
           if %parms > 2; // Add text data if passed.
             xmlBuffer = %trimr(xmlBuffer) + %str(xmlText) +
               '</' + %str(upTo1stBlank(xmlTag)) + '>'; // Add ending tag.
           endif;
           xmlBuffer = %trimr(xmlBuffer) + crlf;
           convertCCSID(C_CONVERT:%addr(xmlBuffer):%len(%trimr(xmlBuffer)));
           rc = write(xmlFD:xmlBuffer:%int(%len(%trimr(xmlBuffer))));
         when xmlOper = XML_OP_CLOSE;
           rc = close(xmlFD);
           convertCCSID(C_CLOSE);
         endsl;

       return rc;

     P                 E
      **************************************************************************
      * Write text buffer license.txt data.
     p writeTxtBuf     b
     d                 pi
     d fileHandle                    10i 0 const
     d bufIn                        512    const
     d bufOut          s                   like(bufIn)
      /free

       bufOut = %trimr(bufIn) + crlf;

       convertCCSID(C_CONVERT:%addr(bufOut):%len(%trimr(bufOut)));
       rc = write(fileHandle:bufOut:%int(%len(%trimr(bufOut))));

       return;

      /end-free
     p                 e
      **************************************************************************
      * Return string value up to the first blank. Used to terminate tags
      * with more than one word listed.
     p upTo1stBlank    b
     d                 pi              *
     d valueIn                         *   const options(*string:*trim)
     d firstBlankPos   s             10i 0
     d valueOut        s            128
      /free
       firstBlankPos = %scan(' ':%str(valueIn));
       if firstBlankPos > 0;
         valueOut = %str(valueIn:firstBlankPos-1) + x'00';
         return %addr(valueOut);
       else;
         return valueIn;
       endif;
      /end-free
     p                 e
      ***********************************************************************
     p convertCCSID    b
     d                 pi
     d operation                      5i 0 value
     d ioBufferP                       *   value options(*nopass)
     d ioBufferLen                   10i 0 value options(*nopass)
     d fromCCSID                     10i 0 value options(*nopass)
     d toCCSID                       10i 0 value options(*nopass)

     D iconv_open      PR            52A   ExtProc('QtqIconvOpen')
     D   ToCode                        *   value
     D   FromCode                      *   value

     D iconv           PR            10I 0 ExtProc('iconv')
     D   Descriptor                  52A   value
     D   p_p_inbuf                     *   value
     D   in_left                     10i 0
     D   p_p_outbuf                    *   value
     D   out_left                    10i 0

     D iconv_close     PR            10I 0 ExtProc('iconv_close')
     D   Descriptor                  52A   value

     D iconvH          DS                  qualified static
     D   ICORV_A                     10I 0
     D   ICOC_A                      10I 0 dim(12)

     d convert_t       ds                  qualified
     D  cp                           10I 0 INZ(0)
     D  ca                           10I 0 INZ(0)
     D  sa                           10I 0 INZ(0)
     D  ss                           10I 0 INZ(0)
     D  il                           10I 0 INZ(0)
     D  eo                           10I 0 INZ(0)
     D  r                             8A   INZ(*allx'00')

     d fromCode        ds                  likeds(convert_t) inz(*likeds) static
     d toCode          ds                  likeds(convert_t) inz(*likeds) static
     d inBufLen        s             10i 0

       select;
         when operation = C_OPEN;
           reset fromCode;
           reset toCode;
           fromCode.cp = fromCCSID;
           toCode.cp = toCCSID;
           iconvH = iconv_open(%addr(toCode):%addr(fromCode));
         when operation = C_CONVERT;
           inBufLen = ioBufferLen + 1;
           iconv(iconvH:%addr(ioBufferP):ioBufferLen:%addr(ioBufferP):
             ioBufferLen);
         when operation = C_CLOSE;
           iconv_close(iconvH);
           clear iconvH;
       endsl;

       return;

     p                 e


       // --------------------------------------------------
       // Procedure name: getFmtVer
       // Purpose:        Return zoned version as dotted format M.m
       // Returns:
       // Parameter:      zonedVer
       // --------------------------------------------------
       DCL-PROC getFmtVer ;
         DCL-PI *N CHAR(5);
           zonedVer ZONED(4:0) CONST;
         END-PI ;

         DCL-S retField CHAR(5);

         retField = %trim(%char(%int(%subst(%editc(zonedVer:'X'):1:2)))) + '.' +
           %trim(%char(%int(%subst(%editc(zonedVer:'X'):3:2))));

         return retField ;
       END-PROC ;

       // --------------------------------------------------
       // Procedure name: getLastIssued
       // Purpose:        Return the last date/time and user id of emailed li...
       //                          cense key.
       // Returns:
       // Parameter:      systemID => System ID
       // Parameter:      installSeqNbr => Installation sequence number.
       // --------------------------------------------------
       DCL-PROC getLastIssued ;
         DCL-PI *N CHAR(27);
           systemID LIKE(skmsid) CONST;
           installSeqNbr LIKE(skmis#) CONST;
         END-PI ;

         DCL-S retField CHAR(27) inz('History data not found.');

         exec sql select left(char(timestamp(right(digits(skhdlc),8) concat
           right(digits(skhtlc),6))),16) concat ' ' concat skhulc as DTU
           into :retField from spykeyhis where skhsid = :systemID and
           skhis# = :installSeqNbr and skhcfr = 'EmailTo' order by
           left(DTU,16) desc fetch first 1 row only;

         return retField ;
       END-PROC ;

       // --------------------------------------------------
       // Procedure name: getLastComment
       // Purpose:        Retrieve the last comment for the current customer ...
       //                          record.
       // Returns:
       // Parameter:      systemID
       // Parameter:      platForm
       // Parameter:      installSeqNbr
       // --------------------------------------------------
       DCL-PROC getLastComment ;
         DCL-PI *N LIKE(skncmt);
           systemID LIKE(skmsid) CONST;
           platForm LIKE(skmpfm) CONST;
           installSeqNbr LIKE(skmis#) CONST;
         END-PI ;

         DCL-S retField LIKE(skncmt) inz('No comments found.');

         exec sql select skncmt into :retField from spykeynot where sknsid =
           :systemID and sknpfm = :platForm and sknis# = :installSeqNbr order by
           skndlc desc fetch first 1 rows only;

         return retField ;

       END-PROC ;
**CTDATA HEADER
Content-Type: text/html

<!DOCTYPE html>
<head><title>Open Text Key Code Maintenance for Gauss and Vista Plus</title>
<script language="javascript" src="keycode.js"></script></head>
<div align=center>
<form name=keycode method="post" action="keycodeweb">
<img src=opentext.jpg onload="testBrowser()">
<h2>Key Code Maintenance for Gauss and Vista Plus</h2>
**ctdata prdhdr
<table border=1 frame=void rules=rows cellpadding=5><caption><b>Product List</b></caption>
<tr><th>Select</th><th>Product Name</th><th>Number of Users</th>
<th>Expiration</th>
**ctdata envNamArr
SERVER_NAME
**ctdata chkbox
<tr><td><input checked type=checkbox name=XXX></td>
**ctdata sysTypA
Prod
Test
Dev
**ctdata elements
hiddenFunc<input name=func type=hidden value="">
update    <input type=button value="Update" onClick="butVal('update')">
custSelect<td><input type=button value="Select Customer" onClick="butVal('custSelect')"></td>
checkAll  <input type=button value="Check All" onClick="return SelectAll('checkAll')">
unCheckAll<input type=button value="Uncheck All" onClick="return SelectAll('unCheckAll')">
demo      <input type=button value="Checked as Demo" onClick="return SelectAll('demo')">
perm      <input type=button value="Checked as Perm" onClick="return SelectAll('perm')">
reset     <input name=Reset type=reset value="Reset">
logOut    <input type=button value="Log Out" onClick="butVal('logOut')">
search    <input type=button value=Search onClick="butVal('search')">
addProd   <input type=button value="Add Products" onClick="butVal('addProd')">
signOn    <input type=submit value="Sign On" onClick="butVal('signOn')" hidefocus=true>
addCust   <input type=button value="Add Customer" onClick="butVal('addCust')">
curHandle <input type=hidden name=curHandle value="
idOrName  System ID or Customer Name
sidText   <input type=text name=SKMSID maxlength=40 size=f2>
custList  <input type=submit value="Search" onClick="butVal('custList')" hideFocus=true>
userID    <table><tr><td>User Id</td><td><input type=text name=USERID maxlength=10></td></tr>
passWord  <tr><td>Password</td><td><input type=password name=PASSWORD maxlength=128></td></tr>
custInfCap<table><caption><b>Customer Information</b></caption>
sltInstCap<table frames=void rules=rows cellpadding=5><caption><b>Select Installation</b></caption>
sltInstT1 <tr><th></th><th>Customer Name</th><th>SystemID</th><th>PlatForm</th><th>Version</th>
sltInstT2 <th>System Type</th><th>Location</th><th>Key Last Issued</th><th>Last Comment</th></tr>
sysIdIn   <tr><td>System ID</td><td><input type=text name=SKMSID value=""></td></tr>
sysIdOut  <tr><td>System ID</td><td>
pfmOptBox <tr><td>Platform</td><td><select name=SKMPFM>
version   <tr><td>Software Version</td><td><input type=text name=SKMVER size=4 maxlenth=4 value=
custName  <tr><td>Customer Name</td><td><input type=text name=SKMNAM size=40 maxlength=40 value="
platForm  <tr><td>PlatForm</td><td>
model     <tr><td>AS400 Model</td><td><input type=text name=SKMMDL value=
ftrCode   <tr><td>AS400 Feature Code</td><td><input type=text name=SKMFTR value=
LPAR      <tr><td>AS400 LPAR Number</td><td><input type=number name=SKMLPR value=
hiddenISN <input type=hidden name=hiddenISN value=
hiddenSid <input type=hidden name=hiddenSid value=
hiddenPfm <input type=hidden name=hiddenPfm value=
custFlag  <tr><td>Customer Record</td><td><input type=text name=SKMCST maxlength=1 size=1 value=
history   <input type=button value="History" onClick="butVal('history')">
pre70Demo <tr><td>Pre 7.0 Demo Date</td><td><font size=3>
userBased <td><input type=text size=6 maxlength=6 name=USERS
hUserBased<td><input type=hidden name=userbased value=1></td>
!userBased<td><input type=hidden name=userbased value=0></td>
demoDate  <td><input type=text maxlength=10 size=10 name=SKLDMO
tiffServer<br>Server:<input type=text name=SKTSVR maxlength=40 value="ANY">
keyCode   <tr><td>Key Code</td><td><font size=3>
ordSelect <input type=hidden name=ordSelect value="">
mailKey   <td><input name=emailBtn type=submit value="Email" disabled onClick="butVal('mailKey')">
verOptBox <tr><td>Sofware Version</td><td><select name=SKMVER onchange="butVal('update')">
systype   <tr><td>System Type</td><td><select name=SKMTYP>
pgmLib    <tr><td>AS400 Program Library</td><td><input type=text name=SKMLIB value=
license   <input type=button value="License" onClick="butVal('showCust')">
histDtaCap<table cellpadding=5><caption><b>Historical Data</b></caption>
hstColRec1<tr><th>Date</th><th>Time</th><th>User</th><th>Element</th><th>Version</th>
hstColRec2<th>Change From</th><th>Change To</th></tr>
recently01<table><tr><td>Search records added by user<td>
recently02<td><input type=text name=recentUser size=10 maxlength=10></td>
recently03<td>within the last <input type=text value=1 name=dayMonthNum maxlength=3 size=3></td>
recently04<td><input type=radio value=days name=dayMonthTxt checked>Days
recently05<input type=radio value=months name=dayMonthTxt>Months</td></tr></table>
emailTo   <tr><td>Email To:</td><td><input type=email name=emailTo onInput="setEmlBtn()">
location  <tr><td>Location</td><td><input type=text size=40 maxlength=40 name=skmloc value="
lstComment<tr><td>Last Comment</td><td><textarea rows="1" cols="40" maxlength=256 readonly>
commentBtn<td><input type=button value="Comments" onClick="butVal('showComments')"></td></tr>
commentHdr<table frames=void rules=rows cellpadding=5><caption><b>Comments</b></caption>
cmtColRec1<tr><th>Remove</th><th>DateTime</th><th>User</th><th>Comment</th><th>Update</th></tr>
addComment<td></td><td></td><td></td><td><textarea rows="1" maxlength=256 name=skncmt></textarea>
addCmtBtn <td><input type=button value="Add Comment" onClick="butVal('addComment')"></td></tr>
rmvCmtBtn <td align=center><input type=button value="Remove" onClick="butVal(
noComments<tr><td><font color=red>No comments found.</font></td></tr>
updCmtBtn <td align=center><input type=button value="Update" onClick="butVal(
**ctdata emlInst
Manually enter the key code using the attached License.txt file.
Optionally, place the attached LicenseXML.txt file in a directory on
the Document Manager server and import using the license manager.

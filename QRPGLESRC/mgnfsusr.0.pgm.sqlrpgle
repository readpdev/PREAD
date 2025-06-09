     h dftactgrp(*no) actgrp('DOCMGR') copyright('Open Text Corporation')
     h  option(*nodebugio)
      *
J2436 * 07-29-10 PLR Utility to manage list of authorized users for ProStor
      *              device accessed via NFS. Maintains a list of selected
      *              profiles in file MGNFSUSR. When Enter is pressed, a file
      *              (passwd) is written to the /GaussInterprise/UsrData
      *              subdirectory. A blank group file, by the same name, will
      *              need to be created manually and copied to the InfiniVault
      *              configuration share along with the formatted passwd file.
      *                     \\someAddress\InfiniVaultNFSConfig$
      *              User must be connected to the share as an administrator.
      *              Once the files are placed in the config directory on the
      *              InfiniVault system, the admin must navigate to the NFS
      *              configuration web interface (System->NFS Configuration)
      *              and press the Syncronize Users button. Changes will be
      *              reflected in the Users tab.

     fmgnfsusrd cf   e             workstn sfile(sfl01:rrn1)
     f                                     indds(indds)

      /copy qsysinc/qrpglesrc,qusec

     d indds           ds            99
     d  exit                  03     03n
     d  refresh               05     05n
     d  cancel                12     12n
     d  repeat                13     13n
     d  positionTo            17     17n
     d  sfldsp                25     25n
     d  sfldlt                26     26n
     d  pageDown              27     27n
     d  pageUp                28     28n
     d  sflend                29     29n

     d                sds
     d pgmq              *proc

      /copy qsysinc/qrpglesrc,qsyrusri

     d buildList       pr            10i 0
     d writeList2Disk  pr            10i 0
     d setListSelect   pr
     d  listValue                     1    const
     d  startFrom                    10
     d  entireList                    1    const
     d positionList    pr            10i 0
     d  positionVal                  10
     d getSelectFlag   pr             1
     d  userName                     10
     d getList         pr            10i 0
     d  direction                    10i 0 const
     d clearLinkList   pr

     d clrMsgs         pr
     d  stack                        10i 0 value

     d chkObj          pr            10i 0
     d  objectCode                   10i 0 const

     d run             pr            10i 0 extproc('system')
     d  command                        *   value options(*string)

     d spm             pr
     d  msgID                         7    const
     d  msgData                      80    const
     d  stack                        10i 0 const

     d profile         ds                  based(profileP) qualified
     d  name                         10
     d  text                         50
     d  uid                          10u 0
     d  selected                      1
     d  prev                           *
     d  next                           *
     d profileTop      s               *
     d profileBot      s               *

     d sysdft          ds          1024    dtaara
     d  dtaLib               306    315

     d CO_NFS_USR_FILE...
     d                 c                   1
     d OK              c                   0
     d ERROR           c                   -1
     d MAX_SFL_RCDS    c                   15
     d BUILD_SYNC      c                   -1
     d i               s             10i 0
     d sqlStmt         s            512
     d listCreated     s               n   inz('0')
     d MAXRRN          s             10i 0 inz
     d NEXT            c                   1
     d PREV            c                   2
     d repeatSet       s               n   inz('0')
     d repeatVal       s              1    inz
     d TOP_OF_LIST     c                   1
     d END_OF_LIST     c                   2

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;

       if chkObj(CO_NFS_USR_FILE) <> OK;
         exsr displayControl;
         exsr quit;
       endif;
       exsr loadSfl;
       dow not exit and not cancel;
         //Check if user tracking file exists (MGNFSUSR). If not exist, create.
         exsr displayControl;
         select;
           when exit or cancel;
           when refresh;
             exsr loadSfl;
           when repeat;
             exsr loadSfl;
           when pageDown;
             exsr loadSfl;
           when pageUp;
             exsr loadSfl;
           when positionTo;
         endsl;
       enddo;

       exsr quit;

       //***********************************************************************
       begsr quit;
         *inlr = '1';
         return;
       endsr;
       //***********************************************************************
       begsr loadSfl;
         repeatSet = '0';
         repeatVal = ' ';
         if pageDown and sflend;
           leavesr;
         endif;
         if not listCreated or refresh;
           if buildList() <> OK;
             spm('STS0000':'Error creating user list.':1);
             leavesr;
           endif;
           listCreated = '1';
         endif;
         select;
           when pageUp;
             for i = 1 to (maxRRN + MAX_SFL_RCDS);
               if getList(PREV) = TOP_OF_LIST;
                 leave;
               endif;
             endfor;
           when repeat;
             readc sfl01;
             if option = ' ' or option = '1';
               repeatVal = option;
               repeatSet = '1';
             endif;
         endsl;
         if not repeat;
           sfldlt = '1';
           sfldsp = '0';
           write ctl01;
           sfldlt = '0';
           sflend = '0';
           rrn1 = 0;
         endif;
         for i = 1 to MAX_SFL_RCDS;
           if getList(NEXT) = END_OF_LIST;
             sflend = '1';
             leave;
           endif;
           usrPrfOut = profile.name;
           usrNamOut = profile.text;
           rrn1 += 1;
           write sfl01;
           if sflend;
             leave;
           endif;
         endfor;
         if rrn1 > 0;
           maxRRN = rrn1;
           sfldsp = '1';
           rrn1 = 1;
         endif;
       endsr;

       //***********************************************************************
       begsr displayControl;
         write fkey;
         write msgctl;
         exfmt ctl01;
         clrmsgs(2);
       endsr;
      /end-free
      **************************************************************************
     p chkObj          b
     d                 pi            10i 0
     d objectCode                    10i 0 const
     d rc              s             10i 0 inz(OK)
     d SQL_NOT_JOURNAL_OK...
     d                 c                   7905
      /free
       select;
         when objectCode = CO_NFS_USR_FILE;
           in(e) sysdft;
           if run('chkobj ' + %trimr(dtaLib) + '/MGNFSUSR *FILE') <> OK;
             sqlStmt = 'create table ' + %trimr(dtaLib) +
               '/MGNFSUSR (SLTUSR CHAR(10) NOT NULL WITH DEFAULT)';
             exec sql execute immediate :sqlStmt;
             if sqlcod <> SQL_NOT_JOURNAL_OK;
               spm('IFS0010':%trimr(dtaLib) + '/MGNFSUSR':2);
               spm('ERR1089':' ':2);
               rc = ERROR;
             endif;
           endif;
       endsl;

       return rc;
      /end-free
     p                 e

      **************************************************************************
     p spm             b
     d                 pi
     d  msgID                         7    const
     d  msgData                      80    const
     d  stack                        10i 0 const

     d sndpm           pr                  extpgm('QMHSNDPM')
     d  MsgID                         7    const
     d  MsgF                         20    const
     d  MsgDta                       80    const options(*varsize)
     d  MsgDtaLn                     10i 0 const
     d  MsgType                      10    const
     d  CStack                       10    const
     d  CStackC                      10i 0 const
     d  MsgKey                        4    const
     d  apierr                             likeds(qusec)

     d msgF            c                   'PSCON     *LIBL'
      /free
       clear qusec;
       sndpm(msgID:msgf:msgData:%len(%trim(msgData)):'*INFO':'*':stack:' '
         :qusec);
       return;
      /end-free
     p                 e
      **************************************************************************
     p clrMsgs         b

     d                 pi
     d stackCnt                      10i 0 value

     d rmvMsgs         pr                  extpgm('QMHRMVPM')
     d  stack                        10    const
     d  stackCnt                     10i 0
     d  msgkey                        4    const
     d  msgtype                      10    const
     d  apierr                             likeds(qusec)

      /free
       clear qusec;
       rmvMsgs('*':stackCnt:' ':'*ALL':qusec);
       return;
      /end-free
     p                 e
      **************************************************************************
     p buildList       b
     d                 pi            10i 0

     d listUsers       pr                  extpgm('QGYOLAUS')
     d  profileRcvr                        like(profileData)
     d  receiverLen                  10i 0 const
     d  listInfo                           like(listInfo)
     d  rqstNbrRecs                  10i 0 const
     d  format                        8    const
     d  criteria                     10    const
     d  grpProfile                   10    const
     d  apiError                           like(qusec)

     d getListEntry    pr                  extpgm('QGYGTLE')
     d  receiverVar                        like(profileData)
     d  lenReceiver                  10i 0 const
     d  handle                        4
     d  listInfo                           like(listInfo)
     d  nbrRcds2Rtn                  10i 0 const
     d  startingRcd                  10i 0 const
     d  apiError                           like(qusec)

     d closeList       pr                  extpgm('QGYCLST')
     d  handle                        4
     d  apiError                           like(qusec)

     d getUserData     pr                  extpgm('QSYRUSRI')
     d  receiver                           likeds(QSYI0300)
     d  receiverLen                  10i 0 const
     d  format                        8    const
     d  profileName                  10
     d  apiError                           likeds(qusec)

     d listInfo        ds                  qualified
     d  totalRecs                    10i 0
     d  recsReturned                 10i 0
     d  handle                        4
     d  recLen                       10i 0
     d  infoComplete                  1
     d  date_time                    13
     d  status                        1
     d  reserved1                     1
     d  infoLen                      10i 0
     d  currentRcd                   10i 0
     d  reserved2                    40

     d profileData     ds                  qualified
     d  name                         10
     d  userOrGroup                   1
     d  groupMbrInd                   1

     d userData        ds                  likeds(QSYI0300)
     d i               s             10i 0
     d saveP           s               *
      /free
       clear qusec;
       qusbprv = %size(qusec);
       listUsers(profileData:%size(profileData):listInfo:BUILD_SYNC:'AUTU0100':
         '*USER':'*NONE':qusec);
       if qusbavl > 0;
         return ERROR;
       endif;
       clearLinkList();
       profileP = %alloc(%size(profile));
       profileTop = profileP;
       clear profile;
       //create blank place holder entry at beginning of list.
       profile.next = %alloc(%size(profile));
       saveP = profileP;
       profileP = profile.next;
       profile.prev = saveP;
       for i = 1 to listInfo.totalRecs;
         clear qusec;
         qusbprv = %size(qusec);
         getListEntry(profileData:%size(profileData):listInfo.handle:listInfo:
           1:i:qusec);
         if qusbavl > 0;
           return ERROR;
         endif;
         clear qusec;
         qusbprv = %size(qusec);
         getUserData(userData:%size(userData):'USRI0300':profileData.name:
           qusec);
         if qusbavl > 0;
           return ERROR;
         endif;
         profile.name = userData.qsyup03;
         profile.text = userData.qsytd;
         profile.uid = userData.qsyuid;
         //profile.selected = getSelectFlag(profile.name);
         if i < listInfo.totalRecs;
           profile.next = %alloc(%size(profile));
           saveP = profileP;
           profileP = profile.next;
           clear profile;
           profile.prev = saveP;
         endif;
       endfor;
       profileBot = profileP;
       profileP = profileTop;
       closeList(listInfo.handle:qusec);

       return OK;
      /end-free
     p                 e
      **************************************************************************
     p writeList2Disk  b
     d                 pi            10i 0
      /free
       return OK;
      /end-free
     p                 e
      **************************************************************************
     p setListSelect   b
     d                 pi
     d  listValue                     1    const
     d  startFrom                    10
     d  entireList                    1    const
      /free
       return;
      /end-free
     p                 e
      **************************************************************************
     p positionList    b
     d                 pi            10i 0
     d positionValue                 10
      /free
       return OK;
      /end-free
     p                 e
      **************************************************************************
     p clearLinkList   b
     d                 pi
     d savePrev        s               *
      /free
       if profileBot <> *null;
         profileP = profileBot;
         dow profile.prev <> *null;
           savePrev = profile.prev;
           dealloc(en) profile.prev;
           profileP = savePrev;
         enddo;
         dealloc(en) profileP;
         profileTop = *null;
         profileBot = *null;
       endif;
       return;
      /end-free
     p                 e
      **************************************************************************
     p getList         b
     d                 pi            10i 0
     d direction                     10i 0 const
      /free
       select;
         when direction = NEXT;
           if profile.next = *null;
             return END_OF_LIST;
           endif;
           profileP = profile.next;
         when direction = PREV;
           if profile.prev = *null;
             return TOP_OF_LIST;
           endif;
           profileP = profile.prev;
       endsl;
       return OK;
      /end-free
     p                 e
      **************************************************************************
     p getSelectFlag   b
     d                 pi             1
     d userName                      10
     d selectedUser    s             10
      /free
       exec sql select sltusr into :selectedUser from mgnfsusr where
         sltusr = :userName;
       if sqlcod = 0;
         return '1';
       else;
         return ' ';
       endif;
      /end-free
     p                 e


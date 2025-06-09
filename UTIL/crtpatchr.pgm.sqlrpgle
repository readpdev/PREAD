      *%METADATA                                                       *
      * %TEXT Create Patch                                             *
      *%EMETADATA                                                      *
     h dftactgrp(*no) actgrp(*caller)
      //
      // 01-12-11 PLR Added option USRPRF(*OWNER) to CHGPGM & CHGSRVPGM commands
      //              so that adoptive authority works correctly.
      //
J2666 // 05-28-10 PLR Change object ownership to QSECOFR so that DOCWRKPAT won't
      //              fail when object owned profiles don't exist on the target
      //              system. Converted to free format. Changed run procedure to
      //              call system procedure.
      //
      // 01-28-10 PLR Include help panel objects to patch. Other object
      //              types were not having their descriptions updated
      //              with the patch id.
      //
      // 02-20-09 EPG Change the paramters for the key word RMVOBS(*ALL) to
      //              RMVOBS(*DBGDTA *BLKORD *PRCORD).
      //
      // 10-09-07 PLR Don't include SPCLINST or SPCLINSTR in PATCHOBJ file.
      //
      // 08-15-07 EPG Remove the inclusion of the SPCLINST program by default.
      //
70810 // 08-10-07 EPG Automatically add in the exit program SPCLINST to the
      //              patch release so that the exit program will be called
      //              everytime. The exit program will only run the special
      //              instructions associated with that specific distribution
      //              patch library.
      //
      // 01-30-07 PLR Remove deletion of patch library to allow programmer to
      //              first create a special install application when necessary.
      //              This way the programmer won't have to recreate the save
      //              save file to include the special install app.
      //
     fcrtpatchd cf   e             workstn indds(indds) sfile(sfl1:rrn1)

     d OK              c                   0
     d q               c                   ''''

     d                sds
     d pgmq              *proc

     d run             pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d indds           ds
     d  exit                  03     03n
     d  refresh               05     05n
     d  cancel                12     12n
     d  sfldsp                25     25n
     d  sfldlt                26     26n
     d  protect               30     30n

     d inSARs          ds
     d  is_cnt                        5i 0
     d  is_arr                       12    dim(50)
     d   is_len                       5i 0 overlay(is_arr)
     d   is_val                      10    overlay(is_arr:*next)

     d enhobjsql       s             80    dim(6) ctdata
     d depobjsql       s             80    dim(8) ctdata
     d sqlStmt         s           1024
     d inList          s            512
     d x               s             10i 0
     d tgtLib          s             10
     d Selected        s               n   inz('0')
     d maxRRN1         s                   like(rrn1)
     d sflRcdDS        ds
     d  objName                      10
     d  objFmly                       8
     d  enh                          10
     d  rel                          10
     d  depObj                        1
     d  overLap                       1
     d  library                      10
     d  owner                        10
     d patchdta        ds          2000    dtaara
     d  tgtrls                 1      6
     d savSflRcdDS     ds
     d  savObjName                         like(objName)
     d  savObjFmly                         like(objFmly)
     d  savObjEnh                          like(enh)
     d  savObjRel                          like(rel)
     d  savDepObj                          like(depObj)
     d  savOvrLap                          like(overLap)
     d  savObjLib                          like(library)
     d  savObjOwn                          like(owner)
     d savRRN1         s                   like(rrn1)
     d SQ              c                   ''''

     c     *entry        plist
     c                   parm                    inSARs

      /free
       exec sql set option closqlcsr=*endmod,commit=*none;

       tgtLib = %subst(is_val(1):1:is_len(1));
       in patchdta;

       exsr loadsfl1;
       dow not exit and not cancel;
         write fkey;
         exfmt ctl1;
         select;
         when exit or cancel;
           iter;
         when refresh;
           exsr loadsfl1;
         when sfldsp;
           exsr selectSR;

           if Selected;
             exsr prepPatch;
             run('grtobjaut ' + %trim(tgtlib) +
                 '/*all *all *public *all');
J2666        run('chgobjown obj(' + %trimr(tgtlib) +
J2666          ') objtype(*lib) newown(qsecofr)');
J2666        run('chgown obj(' + SQ + '/qsys.lib/' + %trimr(tgtlib) +
J2666           '.lib/*' + SQ + ') newown(qsecofr)');
             run('savlib ' + %trim(tgtLib) +
                 ' dev(*savf) savf('+%trim(tgtLib) + '/' +
                 %trim(tgtLib) + ') dtacpr(*high) ' +
                 'omitobj((' + %trim(tgtLib) + '/' +
                 %trim(tgtLib) + ' *file)) tgtrls(' +
                 %trim(tgtrls) + ')');
             leave;
           else;
             callp(e) run('dltlib ' + tgtLib);
           endif;
         endsl;
       enddo;

       exsr quit;

       //***********************************************************************
       // Creates SQL statement for retrieving a list of enhanced objects for th
       // given project id.
       //***********************************************************************
       begsr bldEnhSql;

         for x = 1 to %elem(enhobjsql);
           sqlStmt = %trimr(sqlStmt) +' '+ enhobjsql(x);
         endfor;
         if is_cnt = 1;
           sqlStmt = %trimr(sqlStmt) + ' = ' +
               q+%subst(is_val(1):1:is_len(1))+q;
         else;
           inList = 'in (';
           for x = 1 to is_cnt;
             inList = %trim(inList) + q +
                 %subst(is_val(x):1:is_len(x)) + q;
             if x < is_cnt and is_cnt > 1;
               inList = %trim(inList) + ',';
             endif;
           endfor;
         endif;
         if is_cnt > 1;
           inList = %trim(inList) + ')';
           sqlStmt = %trimr(sqlStmt) +' '+ inList;
         endif;
         sqlStmt = %trimr(sqlStmt) +
             ' order by rel desc, enh, object';
       exec sql
        prepare stmt from :sqlStmt;
       exec sql
        declare c1 scroll cursor for stmt;
       exec sql
        open c1;
       endsr;

       //***********************************************************************
       // Creates SQL statement for retrieving a list of dependent objects
       //***********************************************************************
       begsr bldDepSql;

         sqlStmt = ' ';
         for x = 1 to %elem(depobjsql);
           sqlStmt = %trimr(sqlStmt) +' '+ depobjsql(x);
         endfor;
         if is_cnt = 1;
           sqlStmt = %trimr(sqlStmt) + ' = ' +
               q+%subst(is_val(1):1:is_len(1))+q;
         else;
           sqlStmt = %trimr(sqlStmt) +' '+ %trim(inList);
         endif;
         sqlStmt = %trim(sqlStmt) +
             ' order by rel desc, enh, dep_object';
       exec sql
        prepare stmt2 from :sqlStmt;
       exec sql
        declare c2 scroll cursor for stmt2;
       exec sql
        open c2;
       endsr;

       //***********************************************************************
       begsr loadsfl1;

         rrn1 = 0;
         maxRRN1 = 0;
         sfldlt = '1';
         sfldsp = '0';
         write ctl1;
         sfldlt = '0';
         option = ' ';
         exsr bldEnhSql;
       exec sql
        fetch first from c1 into :objname, :objfmly, :enh, :rel, :library,
        :owner;
         dow sqlcod = OK;
           protect = '0';
           if objFmly = '*MODULE';
             protect = '1';
           endif;
           if objname = owner;
             owner = 'QSECOFR';
           endif;
           rrn1 = rrn1 + 1;
           maxRRN1 = maxRRN1 + 1;
           write sfl1;
       exec sql
        fetch next from c1 into :objname, :objfmly, :enh, :rel, :library,
           :owner;
         enddo;
         if rrn1 > 0;
           sfldsp = '1';
         endif;

         // Load dependent objects into list for possible selection
         exsr bldDepSql;
       exec sql
        fetch first from c2 into :objname, :objfmly, :enh, :rel, :library,
        :owner;
         // If overlap of objects exist in more than one project, mark the subfi
         // record. This is a visual reminder to check objects and make sure the
         // contain all the necessary fixes. Protect and non-display the option
         // field if object is already in list.
         dow sqlcod = OK;
           overLap = ' ';
           protect   = '0';
           savRRN1 = rrn1;
           savSflRcdDS = sflRcdDS;
           for x = 1 to maxRRN1;
             chain x sfl1;
             if %found and
                   objname = savObjName and objfmly = savObjFmly;
               protect   = '1';
               leave;
             endif;
           endfor;
           sflRcdDS = savSflRcdDS;
           if owner = objName;
             owner = 'QSECOFR';
           endif;
           rrn1 = savRRN1;
           depObj = '*';
           if protect;
             overLap = '*';
           endif;
           rrn1 = rrn1 + 1;
           maxRRN1 = maxRRN1 + 1;
           write sfl1;
       exec sql
        fetch next from c2 into :objname, :objfmly, :enh, :rel, :library,
        :owner;
         enddo;

       endsr;

       //***********************************************************************
       begsr quit;
       exec sql
        close c1;
       exec sql
        close c2;
         *inlr = '1';

       endsr;

       //***********************************************************************
       begsr selectSR;

         run('crtlib ' + %trim(tgtLib) +
             ' aut(*all)');
         run('crtdupobj patchobj *libl *file tolib('+
             %trim(tgtLib) + ')');
         dow 1 = 1;
           readc sfl1;
           if %eof;
             leave;
           endif;
           if option <> '1';
             iter;
           endif;
           Selected = '1';
           if objfmly = '*FILE';
             run('crtdupobj obj(' + %trim(objname) + ') '+
                 'fromlib(' + %trim(library) + ') objtype(' +
                 q + %trim(objfmly) + q +') tolib('+
                 %trimr(tgtLib) + ') data(*yes)');
           else;
             run('crtdupobj obj(' + %trim(objname) + ') '+
                 'fromlib(' + %trim(library) + ') objtype(' +
                 q + %trim(objfmly) + q +') tolib('+
                 %trimr(tgtLib) + ')');
           endif;
       run('chgobjd ' + %trim(tgtLib) + '/' + %trim(objName) +
         ' objtype(' + %trim(objfmly)+') text(' + q + %trim(enh) + q + ')');
       // Don't include the special install objects in the PATCHOBJ file so
       // that the installer doesn't try to install them.
           if %subst(objname:1:8) <> 'SPCLINST';
             sqlStmt = 'insert into ' + %trim(tgtlib) +
                 '/patchobj values('+q+%trim(objname)+q+','
                 +q+%trim(objfmly)+q+','+q+%trim(owner)+q+')';
       exec sql
        execute immediate :sqlStmt;
           endif;
         enddo;

       endsr;

       //***********************************************************************
       begsr prepPatch;

         run('chgpgm ' +%trimr(tgtLib) + '/*all ' +
             'rmvobs(*dbgdta *blkord *prcord) usrprf(*owner)');
         run('chgsrvpgm ' +%trimr(tgtLib)+'/*all '+
             'rmvobs(*dbgdta *blkord *prcord) usrprf(*owner)');
         run('crtsavf ' + %trimr(tgtLib) + '/' +
             tgtLib);
         run('grtobjaut ' + %trimr(tgtLib) + '/' +
             %trim(tgtlib) + ' *file *public *use');
         run('crtdupobj instpatch *libl *cmd tolib('+
             %trim(tgtLib) + ')');
         run('chgcmd ' + %trim(tgtlib) + '/instpatch'+
             ' pgm('+ %trim(tgtlib) + '/instpatchc)');
         run('crtdupobj instpatchc *libl *pgm tolib('+
             %trim(tgtLib) + ')');
         run('cprobj obj('+%trim(tgtLib)+'/*all) '+
             'objtype(*all)');

       endsr;
      /END-FREE
**ctdata enhobjsql
select left(objname,10) as object, objfmly, enh, rel, b.library ,
ifnull(aa_obj, '*SYSENV') as owner from acmsctl/enhobj a left join
adoptaut on aa_obj = objname and aa_typ = objfmly left join
acmsctl/libname b on b.grp### = a.grp### and b.prd### = a.prd###
and b.rel### = a.rel### where a.objfmly in ('*PGM','*MODULE', '*CMD',
'*SRVPGM','*FILE','*MSGF','*PNLGRP','*MENU') and libnbr = '01' and enh
**ctdata depobjsql
select distinct(left(b.objname,10)) as dep_object, b.objfmly, enh,
a.rel , library, ifnull(aa_obj,'*SYSENV') as owner from
acmsctl/enhobj a left join acmsctl/depobj b on b.rqtobjname =
a.objname and b.rqtobjfmly = a.objfmly left join adoptaut on
b.objname = aa_obj and b.objfmly = aa_typ left join acmsctl/libname
c on c.grp### = a.grp### and c.prd### = a.prd### and c.rel### =
a.rel### where b.objfmly in ('*SRVPGM', '*PGM') and libnbr = '01'
and enh

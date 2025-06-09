**free
ctl-opt dftactgrp(*no) actgrp(*new);

// Entry point
dcl-pi *n;
    extdef char(10);
    extsts char(10);
    exfilds likeds(exfilds_t);
    extrpttyp char(10);
    extidxcnt int(10);
    exidxds likeds(exidxds_t) dim(MAXIDXVAL);
    exvalds likeds(exvalds_t) dim(MAXIDXVAL);
    extrtncde char(10);
    extrtnmsg char(256);
end-pi;

//MAX COUNT OF IDX VALUES
Dcl-C MAXIDXVAL 7;

dcl-c OK 0;
dcl-c ERROR -1;

// IFS File structure for exit program
Dcl-DS exfilds_t template;
    ef_dslen       Int(10); //Record length
    ef_path        Char(256); //IFS file path
    ef_filnam      Char(256); //IFS file name
    ef_fildat      zoned(8:0); //IFS file yyyymmdd
    ef_filtim      zoned(6:0); //IFS file time hhmmss
    ef_filsiz      Int(10); //IFS file size
End-DS;

// Index description structure for exit program
Dcl-DS exidxds_t qualified template dim(MAXIDXVAL);
    ei_dslen       Int(10); //Record length
    ei_name        Char(10); //Index name
    ei_desc        Char(30); //Index description
    ei_len         zoned(5:0); //Index Length
End-DS;

// Index description structure for exit program
Dcl-DS exvalds_t qualified template DIM(MAXIDXVAL);
    ev_dslen       Int(10); //Record length
    ev_idxnam      Char(10); //Index name
    ev_value       Char(99); //Index value
End-DS;

//*******************************************************************

exec sql set option closqlcsr=*endmod,commit=*none;

// Clear return messages
CLEAR  EXTRTNCDE;
CLEAR  EXTRTNMSG;

// Check parms
if CHECKPRM() = OK;

    SELECT;
     // Fill in document class and index values before archiving.
        WHEN extsts='*BEFORE';
            GETIDXVAL();
        WHEN extsts='*AFTER';
          // Do something like send a message.
    ENDSL;

endif;

*inlr = *on;
return;

//*******************************************************************
// Check parms
dcl-proc CHECKPRM;
    dcl-pi *n int(10) end-pi;

    select;
     // Check count of index values
        when extidxcnt > maxidxval;
            extrtncde='*ERROR';
            extrtnmsg='Too many index values!';
     // Don't archive anything that contains 'notme' in the filename
        when %Scan('NOTME':exfilds.ef_filnam) > 0;
            extrtncde='*NOARC';
            extrtnmsg='NotMe file found!';
    ENDsl;

    if extrtncde <> ' ';
        return ERROR;
    else;
        return OK;
    endif;

end-proc;

 //*******************************************************************
 // Fill in document class and index values before archiving.
dcl-proc GETIDXVAL;

    dcl-s i int(5);

     // Assign report type
    extrpttyp='A_RPT_TYPE';

     // Change index values, stored in array
    For i = 1 to MAXIDXVAL;
        SELECT;
            WHEN i=1;
                exvalds(i).ev_value = 'Please';
            WHEN i=2;
                exvalds(i).ev_value = 'archive';
            WHEN i=3;
                exvalds(i).ev_value = 'me';
            OTHER;
                exvalds(i).ev_value = *blanks;
        ENDSL;
    ENDfor;

    return;

END-proc;

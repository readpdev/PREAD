      *%METADATA                                                       *
      * %TEXT Change License Information - System & User               *
      *%EMETADATA                                                      *

      /copy qsysinc/qrpglesrc,qusec

     d chgObjD         pr                  extpgm('QLICOBJD')
     d  rtnLibNam                    10
     d  qualObject                   20
     d  objType                      10
     d  chgObjInf                          likeds(chgObjInf)
     d  error                              likeds(qusec)

     d rtnLibNam       s             10
     d qualObject      s             20

     d chgObjInf       ds                  qualified
     d  nbrOfRcds                    10i 0 inz(1)
     d  key                          10i 0
     d  dataLen                      10i 0
     d  data                         10

     d KEY_SYSTEM_CREATED_ON...
     d                 c                   18
     d KEY_CREATED_BY_USER...
     d                 c                   19
     d KEY_LEN_SYSTEM  c                   8
     d KEY_LEN_USER    c                   10
     d i               s              5i 0

     c     *entry        plist
     c                   parm                    object           10
     c                   parm                    objectLib        10
     c                   parm                    objectType       10
     c                   parm                    newSystem        10
     c                   parm                    newUser          10

      /free
       qualObject = object + objectLib;
       chgObjInf.key = KEY_SYSTEM_CREATED_ON;
       chgObjInf.dataLen = KEY_LEN_SYSTEM;
       chgObjInf.data = newSystem;
       for i = 1 to 2;
         clear qusec;
         qusbprv = %len(qusec);
         chgObjD(rtnLibNam:qualObject:objectType:chgObjInf:qusec);
         chgObjInf.key = KEY_CREATED_BY_USER;
         chgObjInf.dataLen = KEY_LEN_USER;
         chgObjInf.data = newUser;
       endfor;
       *inlr = '1';
      /end-free

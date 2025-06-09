/***********************************************************************
* Name:
*        dapiinit.c
*
* Function:
*        Perform a signon to the Tivoli Storage Manager server via the
*        API functions.
*
* Environment:
*        This is a PLATFORM-INDEPENDENT source file. As such it may
*        contain no dependencies on any specific operating system
*        environment or hardware platform.
*
* Description:
*        Call the dsmInit function to perform a signon to the Tivoli
*        Storage Manager server.
***********************************************************************/
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef min
#define min(a,b)  (((a) < (b)) ? (a) : (b))
#endif

#include "dsmapitd.h"
#include "dsmapifp.h"
#include "dsmrc.h"
#include "dapitype.h"        /* Sample API data types.  */
#include "dapiproc.h"

/* ******* G l o b a l s  ********  */

dsmApiVersionEx     apiApplVer;   /* dsmapitd.h version when appl compiled */
dsmApiVersionEx     apiLibVer;    /* version of API Library at run time */
dsUint32_t       dsmHandle;
ApiSessInfo      dsmSessInfo;
preferences      pref;
char             api_eyecatcher[] = "Tivoli Storage Manager API Verify Data";

/*----------------------------------------------------------------------+
| Public routines
.----------------------------------------------------------------------*/

/*----------------------------------------------------------------------+
| Name:    perform_signon()
|
| Action:  Do a signon.
|
| Input:   sel_dialog  - Pointer to dialog table to process.
|
| Returns: RC_OK            - Successful
|
| Side
| Effects: None
|
| Notes:   None
+----------------------------------------------------------------------*/
dsInt16_t perform_signon(dialog *sel_dialog,dsUint16_t parm1)
{
char           *node;
char           *owner;
char           *pw;
char           *confFile;
char           *options;
dialog         *dlg;
dsUint32_t     i;
dsInt16_t      rc = 0;
dsUint32_t     localHandle;
dsmInitExIn_t  initIn;
dsmInitExOut_t initOut;
char           *userName;
char           *userNamePswd;
char           dirDelimiter = '\0';
char           *encryptKey = NULL;
dsBool_t       encrypt = bFalse;
dsBool_t       useUnicode = bFalse;

memset(&initIn, 0x00, sizeof(dsmInitExIn_t));
memset(&initOut, 0x00, sizeof(dsmInitExOut_t));


/* First pull all values out of the passed dialog for our use.  */
i = 0;
dlg = &sel_dialog[i];
while (dlg->item_type != DSMAPI_END)
  {
  switch (dlg->item_type)
    {
    case DSMAPI_NODENAME :
      node = dlg->item_buff;
      break;
    case DSMAPI_OWNER :
      owner = dlg->item_buff;
      break;
    case DSMAPI_PASSWORD :
      pw = dlg->item_buff;
      break;
    case DSMAPI_CONFIG   :
      confFile = dlg->item_buff;
      break;
    case DSMAPI_OPTIONS  :
      options = dlg->item_buff;
      break;
    case DSMAPI_USERNAME :
      userName = dlg->item_buff;
      break;
    case DSMAPI_USERNAMEPWD :
      userNamePswd = dlg->item_buff;
      break;
    case DSMAPI_ENCRYPT :
      switch (*dlg->item_buff)
      {
         case 'Y':
         case 'y':
            encrypt   = bTrue;     break;
         case 'N':
         case 'n':
            encrypt   = bFalse;    break;
         default :
            encrypt   = bFalse;    break;
      }
      break;
    case DSMAPI_ENCRYPTKEY :
      encryptKey = dlg->item_buff;
      break;
    case DSMAPI_DIRDELIM :
      dirDelimiter = *dlg->item_buff;
      break;
    case DSMAPI_USEUNICODE :
      switch (*dlg->item_buff)
      {
         case 'Y':
         case 'y':
            useUnicode   = bTrue;     break;
         case 'N':
         case 'n':
            useUnicode   = bFalse;    break;
         default :
            useUnicode   = bFalse;    break;
      }
      break;
    default :
      printf("*** Signon dialog does not match code in perform_signon! ***\n");
    }
  i++;
  dlg = &sel_dialog[i];
  }

memset(&apiApplVer,0x00,sizeof(dsmApiVersionEx));
apiApplVer.stVersion  = apiVersionExVer;  /* Set the applications compile */
apiApplVer.version  = DSM_API_VERSION;  /* Set the applications compile */
apiApplVer.release  = DSM_API_RELEASE;  /* time version.                */
apiApplVer.level    = DSM_API_LEVEL;
apiApplVer.subLevel = DSM_API_SUBLEVEL;

printf("Doing signon for node %s, owner %s, with password %s\n",
       node,owner,pw);

initIn.stVersion           = dsmInitExInVersion;
initIn.apiVersionExP       = &apiApplVer;
initIn.clientNodeNameP     = node;
initIn.clientOwnerNameP    = owner ;
initIn.clientPasswordP     = pw;
initIn.applicationTypeP    = "Sample-API";
initIn.configfile          = confFile;
initIn.options             = options;
initIn.userNameP           = userName;
initIn.userPasswordP       = userNamePswd;
initIn.dirDelimiter        = dirDelimiter;
initIn.useUnicode          = useUnicode;
initIn.bEncryptKeyEnabled  = encrypt;
initIn.encryptionPasswordP = encryptKey;

initOut.stVersion = dsmInitExOutVersion;

rc = dsmInitEx(&localHandle, &initIn, &initOut);

if (rc == DSM_RC_REJECT_VERIFIER_EXPIRED)
{
   dsmHandle = localHandle;
   printf("*** Password expired. Select Change Password.\n");
   return(rc);
}
else
if (rc)
{
   printf("*** Init failed: ");
   rcApiOut(localHandle, rc);
   dsmTerminate(dsmHandle);       /* clean up memory blocks */
   return(rc);
}

dsmHandle = localHandle;
printf("Handle on return = %lu \n",dsmHandle);


/* Put code in here for expired pw, etc... */

/*----------------------------------------------------------------------+
| Once signed on get our session info block
.----------------------------------------------------------------------*/
memset(&dsmSessInfo,0x00,sizeof(ApiSessInfo));  /* Zero out block.     */
dsmSessInfo.stVersion = ApiSessInfoVersion;     /* Init struct version */
rc = dsmQuerySessInfo(dsmHandle,                /* Our session handle  */
                      &dsmSessInfo);            /* Output structure.   */

return 0;
}

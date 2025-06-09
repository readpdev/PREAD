#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>

#include <qmhrtvm.h>
#include <qszrtvpr.h>
#include <qp0ztrc.h>
#include <qwcrdtaa.h>
#include <qbnrspgm.h>
#include <qusec.h>

#include "dsmapips.h"
#include "dsmapitd.h"
#include "dsmapifp.h"
#include "dsmrc.h"
#include "release.h"
#include "mgcrypto.h"

void main(void)
{
  dsUint32_t handle;
  ApiSessInfo dsmSessInfo;
  int rc = 0;
  rc = tsmConnect(&handle, "TSM");
  memset(&dsmSessInfo,0x00,sizeof(ApiSessInfo));
  dsmSessInfo.stVersion = ApiSessInfoVersion;
  rc = dsmQuerySessInfo(handle, &dsmSessInfo);
  tsmTerminate(handle);
  return;
}

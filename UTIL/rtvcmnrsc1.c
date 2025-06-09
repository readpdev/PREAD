      /*%METADATA                                                     */
      /* %TEXT Retrieve Communications Resources                      */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<sys/types.h>
#include "qusec.h"
#include "qgyrhr.h"

void main(void)
{
  ulong category = 2;
  Qgy_RhrlRcvrVarHdr_t header;
  Qus_EC_t *error;
  memset(error, 0, sizeof(error));
  error->Bytes_Provided = sizeof(error);
  QgyRtvHdwRscList((char *)&header, (ulong *)sizeof(header), "RHRL0100", &catego
  return;
}

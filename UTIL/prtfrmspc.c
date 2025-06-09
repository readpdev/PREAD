      /*%METADATA                                                     */
      /* %TEXT Print spool file from user space                       */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <stdlib.h>
#include "qusrspla.h"
#include "masplio.h"

void main(void)
{
  int fh;
  Qus_SPLA0200_t *pSplAtr;
  pSplAtr = malloc(sizeof(*pSplAtr));
  fh = createSplf(pSplAtr);
}

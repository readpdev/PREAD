      /*%METADATA                                                     */
      /* %TEXT Decompression routine                                  */
      /*%EMETADATA                                                    */
#include <QSYSINC/MIH/DCPDATA>
#include <stdio.h>

void dcpr(char *source, int sourcelen, char *result)
{
  int dlength;
  dlength = dcpdata(result, sourcelen, source);
  return;
}

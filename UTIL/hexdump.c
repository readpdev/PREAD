      /*%METADATA                                                     */
      /* %TEXT Dump input buffer in hex                               */
      /*%EMETADATA                                                    */
#include<stdio.h>

void hexdump(char *p, int plen)
{
  int i;
  FILE *fp;

  for (i = 0; i < plen+1; i++)
  {
    printf("%c", p[i]);
  }

  return;
}

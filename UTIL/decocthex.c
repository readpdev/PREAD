      /*%METADATA                                                     */
      /* %TEXT Decimal, Octal, Hex output                             */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main(void)
{
  long longInt;

  longInt = 125;
  printf("dec = %4d\noctal = %o\nhex = %x\n", longInt, longInt, longInt);

  return;
}

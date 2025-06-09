      /*%METADATA                                                     */
      /* %TEXT Security Bit Manipulation                              */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>

void onBit(int ordinalBit, uchar *byteField);
void offBit(int ordinalBit, uchar *byteField);
int chkBit(int ordinalBit, uchar *byteField);

void onBit(int ordinalBit, uchar *byteField)
{
  int r = 0;
  r = ordinalBit % 8;
  byteField[ordinalBit/8] |= (1 << (7 - r));
  return;
}

void offBit(int ordinalBit, uchar *byteField)
{
  int r;
  r = ordinalBit % 8;
  byteField[ordinalBit/8] &=~ (1 << (7 - r));
  return;
}

int chkBit(int ordinalBit, uchar *byteField)
{
  int r;
  uchar x;
  r = ordinalBit % 8;
  memcpy(&x, &byteField[ordinalBit/8], 1);
  return (x >> (7 - r));
}

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>

void onBit(int ordinalBit, uchar *byteField);
void offBit(int ordinalBit, uchar *byteField);
int chkBit(int ordinalBit, uchar *byteField);

void main(void)
{
  int i, nbrBits;
  uchar myField[8];
  uchar bitField[65];
  memset(&myField, 0, sizeof(myField));
  bitField[65] = 0;
  nbrBits = sizeof(myField) * 8;
  for (i = 0; i < nbrBits; i++)
  {
    memset(&bitField, '0', sizeof(bitField)-1);
    onBit(i, myField);
    bitField[i] = chkBit(i, myField) ? '1':'0';
    printf("%s\n", bitField);
    offBit(i, myField);
  }
  return;
}

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

#include<stdio.h>
#include<time.h>
#include<string.h>

char pbuf[132];
FILE *qsysprt;
clock_t start, end;

void timer(char *opcode)
{
  memset(&pbuf, ' ', sizeof(pbuf));
  if (!memcmp(opcode, "START", 5))
    start = clock();
  if (!memcmp(opcode, "STOP", 4))
  {
    end = clock();
    qsysprt = fopen("*LIBL/QSYSPRT", "wb, lrecl=132");
    memset(&pbuf, ' ', sizeof(pbuf));
    sprintf(pbuf, "Milliseconds: %.2f", ((double) end - start) * 1000/CLK_TCK);
    fwrite(pbuf, 1, sizeof(pbuf), qsysprt);
    fclose(qsysprt);
  }
}

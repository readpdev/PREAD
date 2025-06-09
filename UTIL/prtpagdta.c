      /*%METADATA                                                     */
      /* %TEXT Prints AFP spool file page data (QSPGETF)              */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define RCDSIZ 5004

FILE *input, *qsysprt;

char *buffer;

typedef _Packed struct part1S
{
  short int lines;
  short int linpag;
} part1_t;

typedef _Packed struct part2S
{
  short int pagstr;
  short int pagend;
} part2_t;

typedef _Packed struct part3S
{
  short int outsiz;
} part3_t;

typedef _Packed struct pageDataS
{
  char record[4061];
  short int lines;
  short int linpag;
  char      gap[6];
  int       outpag;
  short int pagstr;
  short int pagend;
  char      gap2[2];
  short int outsiz;
  char     restp[925];
} pageDataS_t;

int records = 1;
pageDataS_t pageData;

void main(int argc, char *argv[])
{
  if (argc < 2)
  {
    printf("Usage: call prtpagdta file\n");
    return;
  }
  if (!(input = fopen(argv[1], "rb")))
  {
    printf("Error opening %s\n", argv[1]);
    return;
  }
  qsysprt = fopen("QSYS/QSYSPRT", "w");
  /* read past the attribute record */
  fread(&pageData, RCDSIZ, 1, input);
  fprintf(qsysprt, "Printing spool file page data for %s\n\n", argv[1]);
  while (fread(&pageData, RCDSIZ, 1, input))
  {
    fprintf(qsysprt, "Record = %i\n", records++);
    fprintf(qsysprt, "#LINES = %i\n", pageData.lines);
    fprintf(qsysprt, "#LINPG = %i\n", pageData.linpag);
    fprintf(qsysprt, "OUTPG# = %i\n", pageData.outpag);
    fprintf(qsysprt, "#PGSTR = %i\n", pageData.pagstr);
    fprintf(qsysprt, "#PGEND = %i\n", pageData.pagend);
    fprintf(qsysprt, "OUTSIZ = %i\n\n", pageData.outsiz);
  }
  fclose(input);
  fclose(qsysprt);
  return;
}

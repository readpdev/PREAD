      /*%METADATA                                                     */
      /* %TEXT Compress/Decompress File                               */
      /*%EMETADATA                                                    */
/* Create program using PREAD/MYBNDDIR which includes reference to ZLIB/ZLIB ser
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"zlib.h"

#define COMPRESS '1'
#define DECOMPRESS '2'
#define OK 0
#define INSIZE 10
#define MAXSIZE 32766
#define PATHSIZE 512
#define ARGSIZE 10

char ioBuf[MAXSIZE];
int bytesRead;

void Compress(char *targetFile, char *sourceFile);
void deCompress(char *targetFile, char *sourceFile);
char *trimr(char *, int);

int main(char *argv[], int argc)
{
  char tgtLib[INSIZE+1];
  char tgtFile[INSIZE+1];
  char srcLib[INSIZE+1];
  char srcFile[INSIZE+1];
  char opcode;
  char target[PATHSIZE], source[PATHSIZE], gzTarget[PATHSIZE], gzSource[PATHSIZE
  if (argc < 6)
  {
    printf("Missing parameter(s). Usage cprdcp tgtFile tgtLibrary srcFile srcLib
    exit(1);
  }
  memcpy(&opcode, argv[1], 1);
  strcpy(tgtFile, trimr(argv[2], INSIZE));
  strcpy(tgtLib, trimr(argv[3], INSIZE));
  strcpy(srcFile, trimr(argv[4], INSIZE));
  strcpy(srcLib, trimr(argv[5], INSIZE));
  sprintf(source,"%s/%s", srcLib, srcFile);
  sprintf(target, "%s/%s", tgtLib, tgtFile);
  sprintf(gzSource, "/QSYS.LIB/%s.LIB/%s.FILE/%s.MBR", srcLib, srcFile, srcFile)
  sprintf(gzTarget, "/QSYS.LIB/%s.LIB/%s.FILE/%s.MBR", tgtLib, tgtFile, tgtFile)
  switch (opcode)
  {
    case COMPRESS:
      Compress(gzTarget, gzSource);
      break;
    case DECOMPRESS:
      deCompress(target, gzSource);
  }
  return OK;
}

void Compress(char *target, char *source)
{
  gzFile outFile, inFile;
  if (!(outFile = gzopen(target, "wb, 9")))
  {
    printf("Error opening %s", target);
    exit(1);
  }
  if (!(inFile = gzopen(source, "rb")))
  {
    printf("Error opening %s", source);
    exit(1);
  }
  while ((bytesRead = gzread(inFile, ioBuf, MAXSIZE)) > 0)
    gzwrite(outFile, (void *)ioBuf, bytesRead);
  gzclose(inFile);
  gzclose(outFile);
}

void deCompress(char *target, char *source)
{
  gzFile gzInFile;
  FILE *outFile;
  if (!(outFile = fopen(target, "wb")))
  {
    printf("Error opening %s", target);
    exit(1);
  }
  if (!(gzInFile = gzopen(source, "rb")))
  {
    printf("Error opening %s", source);
    exit(1);
  }
  while ((bytesRead = gzread(gzInFile, ioBuf, MAXSIZE)) > 0)
    fwrite(ioBuf, 1, bytesRead, outFile);
  fclose(outFile);
  gzclose(gzInFile);
}

char *trimr(char *field, int fieldLen)
{
  char *cp, *sp;
  cp = malloc(fieldLen+1);
  memset(cp, 0, fieldLen+1);
  memcpy(cp, field, fieldLen);
  sp = cp;
  cp = cp + fieldLen - 1;
  while (*cp == ' ' && cp > sp)
  {
    *cp = 0;
    cp--;
  }
  return sp;
}

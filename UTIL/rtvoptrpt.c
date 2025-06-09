      /*%METADATA                                                     */
      /* %TEXT Retrieve Optical Report to WorkFile                    */
      /*%EMETADATA                                                    */
/* retrieve contents of report from optical to work file qtemp/wrkrptfile */
/* bind service program spystgio for access optical systems */

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<decimal.h>
#include<ctype.h>
#include<recio.h>
#include<qusrjobi.h>

#define IRECLEN 4079
typedef struct {
   char OPTRNM[10];
   decimal( 5, 0) OPTSEQ;
   char OPTVOL[12];
   char OPTLIB[10];
   char OPTFDR[10];
   char OPTFIL[10];
   char OPTTVL[6];
   char OPTTSQ[4];
   char OPTTDT[4];
   char OPBBGN[4];
   char OPBEND[4];
   int OPMXSZ;
}DOC810DTA_MOPTTBL_OPTRC_i_t;

/* spystgio prototypes (functions written in rpgle) */
typedef struct _volume {char volume[13];} volume_t;
typedef struct _path {char path[180];} path_t;
int SPYSTGOPN(volume_t, path_t, int);
int SPYSTGRED(int, char *, int);
int SPYSTGCLS(int);

void clrscrn(void);
char *trimr(char *field);

int main(int argc, char *argv[])
{
  _RFILE *opttbl;
  FILE *sfileOut;
  DOC810DTA_MOPTTBL_OPTRC_i_t opttblbuf;
  char optlib[11], optfdr[11], optfil[11], batch[11];
  char ibuf[IRECLEN];
  volume_t volume;
  path_t path;
  int eRRN, OPTfh = 0, i, bytesRtn, nxtpct = 10, rcdsWritten = 0;
  char sfile[11];
  div_t ans;
  opttbl = 0;
  memset(&sfile, 0, sizeof(sfile));
  clrscrn();
  if (argc < 2)
  {
    printf("Usage: call rtvoptrpt s000000000\n");
    return 0;
  }
  if (argc >= 2)
  {
    memcpy(&sfile, argv[1], 10);
    for (i=0; i < 10; i++)
      sfile[i] = toupper(sfile[i]);
  }
  if (!(opttbl = _Ropen("MOPTTBL", "rr")))
  {
    printf("Error opening optical table.");
    return 0;
  }
  memset(&opttblbuf, 0, sizeof(opttblbuf));
  _Rreadk(opttbl, &opttblbuf, sizeof(opttblbuf),__KEY_EQ|__NO_LOCK, sfile,10);
  if (opttbl->riofb.num_bytes == 0)
  {
    printf("Record not found for %s in optical table.\n", sfile);
    return 0;
  }
  memset(&volume.volume, 0, sizeof(volume.volume));
  memset(&path.path, 0, sizeof(path.path));
  memset(&optlib, 0, sizeof(optlib));
  memset(&optfdr, 0, sizeof(optfdr));
  memset(&optfil, 0, sizeof(optfil));
  memset(&batch, 0, sizeof(batch));
  memcpy(volume.volume, opttblbuf.OPTVOL, sizeof(opttblbuf.OPTVOL));
  memcpy(&optlib, &opttblbuf.OPTLIB, sizeof(opttblbuf.OPTLIB));
  memcpy(&optfdr, &opttblbuf.OPTFDR, sizeof(opttblbuf.OPTFDR));
  memcpy(&optfil, &opttblbuf.OPTFIL, sizeof(opttblbuf.OPTFIL));
  memcpy(&batch, opttblbuf.OPTRNM, sizeof(opttblbuf.OPTRNM));
  sprintf(path.path, "/SPYGLASS/%s/%s/%s", trimr(optlib), trimr(optfdr),
  trimr(optfil));
  _Rclose(opttbl);
  printf("Opening %s on volume %s.\n", path.path, trimr(volume.volume));
  printf("One moment please...\n");
  OPTfh = SPYSTGOPN(volume, path, 2);
  if (OPTfh <= 0)
  {
    printf("Error opening %s on volume %s.\n", path.path, volume.volume);
    printf("SPYSTGOPN returns %d.\n", OPTfh);
    return 0;
  }
  sfileOut = 0;
  sfileOut = fopen("QTEMP/sfileOUT", "wb, lrecl=1024");
  if (!sfileOut)
  {
    perror("Error opening sfileOUT.\n");
    return 0;
  }
  printf("Retrieving data. Stand by...\n");
  memcpy(&eRRN, opttblbuf.OPBEND, 4);
  for (i=0; i < eRRN-1; i++)
  {
    if ((bytesRtn = SPYSTGRED(OPTfh, ibuf, IRECLEN)) != IRECLEN)
    {
      printf("Error reading %s. SPYSTGRED returns %d.\n", sfile, bytesRtn);
      return 0;
    }
    fwrite(&ibuf, IRECLEN, 1, sfileOut);
    rcdsWritten++;
    if ((int)(((float)rcdsWritten / (float)eRRN)*100) >= nxtpct)
    {
      printf("%d percent of %s retrieved.\n", nxtpct, sfile);
      nxtpct += 10;
    }
  }
  SPYSTGCLS(OPTfh);
  fclose(sfileOut);
  clrscrn();
  printf("Retrieval complete. File QTEMP/sfileOUT created.\n");
  return 1;
}

void clrscrn(void)
{
  int i;
  for (i=0; i < 25; i++)
    printf("\n");
  return;
}

char *trimr(char *field)
{
  char *cp, *sp;
  cp = malloc(strlen(field));
  memcpy(cp, field, strlen(field));
  sp = cp;
  cp = cp + strlen(field) - 1;
  while (*cp == ' ' && cp > sp)
  {
    *cp = 0;
    cp--;
  }
  return sp;
}

#include <stdio.h>
#include <stdlib.h>
#include <recio.h>
#include <string.h>
#include <time.h>
#include <ctype.h>

void upper(char *data);
int printIt(int argc, char *argv[], char *mbrName, char *buf);

int main(int argc, char *argv[])
{
  int rc, i;
  char lastMbrName[10] = "          ", buffer[512], cmd[256];
  _RFILE *fp;
  _XXOPFB_T *opnfb;
  _RIOFB_T *iofb;

  if (argc < 4)
  {
    printf("Usage: scansrc library file text\n");
    return -1;
  }
  sprintf(cmd, "ovrdbf src %s/%s mbr(*all) ovrscope(*job)", argv[1], argv[2]);
  rc = system(cmd);
  if (rc != 0)
  {
    printf("Error on override. Check joblog.\n");
    return -1;
  }
  fp = _Ropen("src","rr");
  if (fp == NULL)
  {
    printf("Error opening %s/%s\n", argv[1], argv[2]);
    return -1;
  }
  for (i=3;i<argc;i++)
    upper(argv[3]);
  opnfb = _Ropnfbk(fp);
  iofb = _Rreadn(fp, buffer, opnfb->pgm_record_len, __NO_LOCK);
  while (iofb->num_bytes > 0)
  {
    for (i=3;i<argc;i++)
    {
      upper(buffer);
      if (strstr(buffer, argv[i]))
        if (printIt(argc, argv, opnfb->member_name, buffer)) return -1;
    }
    opnfb = _Ropnfbk(fp);
    iofb = _Rreadn(fp, buffer, opnfb->pgm_record_len, __NO_LOCK);
  }
  printIt(argc, argv, NULL, "QUIT");
  _Rclose(fp);
  sprintf(cmd, "dltovr src lvl(*job)");
  rc = system(cmd);
  return 0;
}

void upper(char *z)
{
  int i, len;
  len = strlen(z);
  for (i=0;i<len;i++)
    *z = toupper(*z++);
  return;
}

int printIt(int argc, char *argv[], char *mbrName, char *buf)
{
  int rc = 0;
  char ul[81];
  static int page, lines, overflow = 60, once;
  static FILE *prtf;
  struct tm *newtime;
  time_t ltime;

  if (prtf == NULL)
  {
    if (!(prtf = fopen("QSYS/QSYSPRT", "w, lrecl=132, recfm=fa")))
    {
      printf("Error opening print file.\n");
      rc = -1;
    }
  }

  if (rc == 0)
  {
    /* Header - first time in or overflow */
    if (lines >= overflow || !once)
    {
      once = 1;
      time(&ltime);
      newtime = localtime(&ltime);
      lines = 0;
      page++;
      fprintf(prtf, "%c%.24s  Fast Source Scan  Page: %4d\n",
        '1', asctime(newtime), page);
      fprintf(prtf, " Scan Text: %s\n\n", argv[3]);
      fprintf(prtf, " Library     Source File  Member      Text\n");
      ul[81] = 0;
      memset(&ul, '-', sizeof(ul)-1);
      fprintf(prtf, " ----------  -----------  ----------  %s\n", ul);
    }
    if (!strcmp("QUIT", buf))
    {
      fprintf(prtf, " ****** End of listing ******");
      fclose(prtf);
    }
    else {
      fprintf(prtf, " %-10.10s  %-10.10s   %-10.10s  %s\n",
        argv[1], argv[2], mbrName, buf);
      lines++;
    }
  }
  return rc;
}

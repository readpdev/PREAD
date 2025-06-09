#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"masplio.h"
#include"qusec.h"

typedef struct qualJob
{
  char name[10];
  char user[10];
  char number[6];
} qualJob_t;
FILE *qsysprt;
Qus_EC_t *apiErr;

/* parms are splfName, splfNbr, jobName, jobUser, jobNbr */

void main(int argc, char *argv[]) {
  /* input parms */
  char splfName[10];
  int splfNbr;
  int splfh, i, j;
  char intJobID[16];
  char intSplfID[16];
  unsigned char *splfRcd;
  qualJob_t job;
  if (argc < 6) {
    printf("Usage: call prtboxcars (splfName splfNbr jobName jobUser jobNbr)\n")
    exit(0);
  }
  memset(&splfName, ' ', sizeof(splfName));
  memset(&job, ' ', sizeof(job));
  memset(&intJobID, ' ', sizeof(intJobID));
  memset(&intSplfID, ' ', sizeof(intSplfID));
  memcpy(&splfName, argv[1], sizeof(splfName));
  splfNbr = atoi(argv[2]);
  memcpy(&job.name, argv[3], sizeof(job.name));
  memcpy(&job.user, argv[4], sizeof(job.user));
  memcpy(&job.number, argv[5], sizeof(job.user));

  if ((splfh = openSplf((char *)&job, splfName, splfNbr, intJobID, intSplfID)))
    apiErr = getLastSplErrCd();
    printf("Error opening spool file: %.7s\n", apiErr->Exception_Id);
    return;
  }
  splfRcd = malloc(1);
  while (!getSplRcd(splfh, splfRcd)) {
    printf("\n");
  }
  closeSplf(splfh);
  return;
}

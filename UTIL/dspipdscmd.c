      /*%METADATA                                                     */
      /* %TEXT Display IPDS Commands from User Space                  */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include"qusptrus.h"
#include"qusrusat.h"
#include"qusgen.h"
#include"qusec.h"
#include"dspipdsh.util"

typedef struct CommandsFound {
  char  desc[30];
  short hexVal;
  int   offset;
}CommandsFound_t;

int compare(const void *, const void *);

void main(int argc, char *argv[]) {
  char userSpace[20];
  char *sP;
  int x, y, elemCmds, cmdsFnd = 0;
  Qus_SPCA_0100_t spcAttr;
  Qus_EC_t err;
  CommandsFound_t fndRec[100];
  int offsetFound[100];

  memset(userSpace, ' ', sizeof(userSpace));
  memcpy(userSpace, argv[1], strlen(argv[1]));
  memcpy(userSpace+10, argv[2], strlen(argv[2]));
  memset(fndRec, 0, sizeof(fndRec));
  memset(offsetFound, 0, sizeof(offsetFound));

  memset(&err, 0, sizeof(err));
  err.Bytes_Provided = sizeof(err);
  QUSRUSAT(&spcAttr, sizeof(spcAttr), "SPCA0100", userSpace, &err);
  memset(&err, 0, sizeof(err));
  err.Bytes_Provided = sizeof(err);
  QUSPTRUS(userSpace, &sP, &err);
  elemCmds = sizeof(cmds) / sizeof(*cmds);
  for (x = 0; x < elemCmds; x++) {
    for (y = 0; y < spcAttr.Space_Size-1; y++) {
      if (!memcmp(sP+y, &cmds[x], 2)) {
        memcpy(fndRec[cmdsFnd].desc, cmdTxt[x], sizeof(fndRec[cmdsFnd++].desc));
        fndRec[cmdsFnd].hexVal = cmds[x];
        fndRec[cmdsFnd].offset = y;
        offsetFound[cmdsFnd++] = y;
      }
    }
  }
  qsort(offsetFound, cmdsFnd, sizeof(int), compare);
  for (x=0; x < cmdsFnd; x++)
    for (y=0; y < cmdsFnd; y++)
      if (offsetFound[x] == fndRec[y].offset)
        printf("%-30s %#hx at %5i.\n", fndRec[y].desc, fndRec[y].hexVal, fndRec[

  return;
}

int compare (const void *a, const void *b) {
  if (  *((int *) a)  <  *((int *) b)   )
    return -1;
  if (  *((int *) a)  >  *((int *) b)   )
    return 1;
  return 0;
}

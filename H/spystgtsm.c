/*                                                                            */
/* 05-29-09 PLR Created. Tivoli Storage Manager support header file. J65      */
/*              Used in in module SPYSTGTSM for service program SPYSTGIO.     */
/*                                                                            */
#include <decimal.h>

#include "dsmapitd.h"
#include "dsmapifp.h"
#include "dsmapips.h"
#include "dsmrc.h"

typedef _Packed struct
{
  char volume[12];
  unsigned char percent[4];
  unsigned char threshold[4];
  decimal(15,0) capacity;
  decimal(15,0) used;
  decimal(15,0) free;
  decimal(15,0) alloc;
  char write;
} freeSpace_t;

short int tsmConnect(dsUint32_t *handleP, char *deviceName);
void tsmTerminate(dsUint32_t handleP);
char *tsmGetLastError(void);
int tsmFree(char *deviceName, char *volume, freeSpace_t *freeSpace);

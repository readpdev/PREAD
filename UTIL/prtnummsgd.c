#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <qmhrmfat.h>
#include <qusec.h>

char qualMsgf[20];

Qmh_Rmfa_RMFA0100_t rtnStruct;
Qus_EC_t errStruct;

int main(int argc, char *argv[])
{

   if (argc < 3)
   {
      printf("Usage: msgf msgflib\n");
      exit(1);
   }

   memcpy(qualMsgf, argv[1], 10);
   memcpy(qualMsgf+10, argv[2], 10);
   QMHRMFAT(&rtnStruct, sizeof(rtnStruct), "RMFA0100", qualMsgf,
      &errStruct);

   return 0;
}

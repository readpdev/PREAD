#include <stdio.h>
#include <string.h>

#include <qusec.h>
#include <qspgetsp.h>
#include <qusrspla.h>
#include <qusptrus.h>


void main(int *argc, char *argv[])
{
  char userSpace[20];
  Qsp_SPFRH_t *header;
  Qsp_SPFRB_t *buffer;
  Qsp_SPFRG_t *data;
  Qsp_SPFRP_t *page;
  char *spaceP, *printData;
  memset(&userSpace, ' ', sizeof(userSpace));
  memcpy(userSpace, argv[1], strlen(argv[1]));
  memcpy(userSpace+10, argv[2], strlen(argv[2]));
  QUSPTRUS(userSpace, &spaceP);
  header = (Qsp_SPFRH_t *)spaceP;
  buffer = (Qsp_SPFRB_t *)(spaceP + header->Offset_First_Buffer);
  data = (Qsp_SPFRG_t *)(spaceP + buffer->Offset_General_Info);
  page = (Qsp_SPFRP_t *)(spaceP + buffer->Offset_Page_Data);
  buffer = (Qsp_SPFRB_t *)(page + sizeof(*page));
  printData = (char *)(spaceP + buffer->Offset_Print_Data);
  return;
}

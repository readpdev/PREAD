      /*%METADATA                                                     */
      /* %TEXT Walk spool file user space                             */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <qusec.h>
#include <qusgen.h>
#include <qusrspla.h>
#include <qusrobjd.h>
#include <qwccvtdt.h>
#include <qgscpyrs.h>
#include <qusptrus.h>
#include <qspgetsp.h>

void main(int *argc, char *argv[])
{
  Qus_EC_t stApiErrCd;
  Qsp_SPFRH_t *pHdr;
  Qsp_SPFRB_t *bufInfo;
  Qsp_SPFRB_t *nextBufInfo;
  Qsp_SPFRG_t *gData;
  Qsp_SPFRP_t *page;
  unsigned char *printData;
  char *pUsrSpc;
  char usrSpcName[21];
  static FILE *qsysprt;
  int i, rc;
  int buffersPrinted = 0;
  div_t hexLines;
  int hexOff;

  rc = system("ovrprtf file(qsysprt) splfname(printBuf) pagesize(66 80) \
    lpi(6) cpi(10) ovrflw(60) pagrtt(0)");
  qsysprt = fopen("*LIBL/QSYSPRT", "w, lrecl=80, recfm=fa");
  system("dltovr qsysprt");

  memset(usrSpcName, 0, sizeof(usrSpcName));
  sprintf(usrSpcName, "%-10s%-10s", argv[1], "*LIBL");
  QUSPTRUS(usrSpcName, &pUsrSpc, &stApiErrCd);
  pHdr = (void *)pUsrSpc;
  bufInfo = (void *)(pUsrSpc + pHdr->Offset_First_Buffer);
  for (i=0;i < pHdr->Buffers_Returned;i++)
  {
    if (buffersPrinted++ == 4)
    {
      fprintf(qsysprt, "1Buffer number: %0d\n", bufInfo->Buffer_Number);
      buffersPrinted = 0;
    }
    else
      fprintf(qsysprt, " Buffer number: %0d\n", bufInfo->Buffer_Number);
    fprintf(qsysprt, "  Buffer->Length_Buffer_Info: %0d\n",
      bufInfo->Length_Buffer_Info);
    fprintf(qsysprt, "  Buffer->Offset_General_Info: %0d\n",
      bufInfo->Offset_General_Info);
    fprintf(qsysprt, "  Buffer->Size_General_Info: %0d\n",
      bufInfo->Size_General_Info);
    fprintf(qsysprt, "  Buffer->Offset_Page_Data: %0d\n",
      bufInfo->Offset_Page_Data);
    fprintf(qsysprt, "  Buffer->Size_Page_Data: %0d\n",
      bufInfo->Size_Page_Data);
    fprintf(qsysprt, "  Buffer->Number_Page_Entries: %0d\n",
      bufInfo->Number_Page_Entries);
    fprintf(qsysprt, "  Buffer->Size_Page_Entry: %0d\n",
      bufInfo->Size_Page_Entry);
    fprintf(qsysprt, "  Buffer->Offset_Print_Data: %0d\n",
      bufInfo->Offset_Print_Data);
    fprintf(qsysprt, "  Buffer->Size_Print_Data: %0d\n",
      bufInfo->Size_Print_Data);
    printData = malloc(bufInfo->Size_Print_Data);
    memcpy(printData, pUsrSpc + bufInfo->Offset_Print_Data, bufInfo->Size_Print_Data);
    hexLines = div(bufInfo->Size_Print_Data, 16);
    for (i=0;i<hexLines.quot;i++)
    {
     hexOff = i * 16;
     fprintf(qsysprt, "  %4d %16x\n", hexOff, printData+(hexOff));
    }

    gData = (void *)(pUsrSpc + bufInfo->Offset_General_Info);
    fprintf(qsysprt, "  General->Nbr_Nonblank_Lines: %0d\n", gData->Nbr_Nonblank_Lines);
    fprintf(qsysprt, "  General->Nonblank_Lines_Page1: %0d\n", gData->Nonblank_Lines_Page1);
    fprintf(qsysprt, "  General->Error_Buffer_Number: %0d\n", gData->Error_Buffer_Number);
    fprintf(qsysprt, "  General->Offset_Error_Recovery: %0d\n", gData->Offset_Error_Recovery);
    fprintf(qsysprt, "  General->Print_Data_Size: %0d\n", gData->Print_Data_Size);
    fprintf(qsysprt, "  General->State: %-10s\n", *gData->State);
    fprintf(qsysprt, "  General->Last_Page_Continues: %c\n", *gData->Last_Page_Continues);
    fprintf(qsysprt, "  General->Advanced_Print_Func: %c\n", *gData->Advanced_Print_Func);
    fprintf(qsysprt, "  General->LAC_Array_in_Buffer: %c\n", *gData->LAC_Array_in_Buffer);
    fprintf(qsysprt, "  General->LAC_in_Any_Buffer: %c\n", *gData->LAC_in_Any_Buffer);
    fprintf(qsysprt, "  General->LAC_in_Error_Info: %c\n", *gData->LAC_in_Error_Info);
    fprintf(qsysprt, "  General->Error_Recovery_Info: %c\n", *gData->Error_Recovery_Info);
    fprintf(qsysprt, "  General->Zero_Pages: %c\n", *gData->Zero_Pages);
    fprintf(qsysprt, "  General->Load_Font: %c\n", *gData->Load_Font);
    fprintf(qsysprt, "  General->IPDS_Data: %c\n", *gData->IPDS_Data);

    page = (void *)(pUsrSpc + bufInfo->Offset_Page_Data);
    fprintf(qsysprt, "  Page->Text_Data_Start: %0d\n", page->Text_Data_Start);
    fprintf(qsysprt, "  Page->Any_Data_Start: %0d\n", page->Any_Data_Start);
    fprintf(qsysprt, "  Page->Page_Offset: %0d\n", page->Page_Offset);
    bufInfo = (void *)((char *)bufInfo + bufInfo->Length_Buffer_Info);
  }
  fclose(qsysprt);
  return;
}

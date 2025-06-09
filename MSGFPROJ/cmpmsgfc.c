      /*%METADATA                                                     */
      /* %TEXT Compare Message Files                                  */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "qmhrtvm.h"
#include "qusec.h"

void addMsgToExport(void);

typedef _Packed struct messageData
{
  Qmh_Rtvm_RTVM0300_t msgInf;
  char message[512];
} messageData_t;

messageData_t msgDtaNew;
messageData_t msgDtaOld;

char msgIdNew[7], msgIdOld[7], sysCmd[1024];
static FILE *qsysprt;

void main(int argc, char *argv[])
{
  char newMsgF[20], oldMsgF[20], rtvOpt[10], compareIdOnly;
  int i, changedMsgs = 0, newMsgs = 0, totalMsgs = 0;

  Qus_EC_t error;

  if (!(qsysprt = fopen("*LIBL/QSYSPRT", "w, lrecl=132, recfm=fa")))
  {
    printf("Error opening qsysprt.\n");
    return;
  }

  fprintf(qsysprt, " Comparing new msgf %.10s %.10s to old msgf %.10s %.10s\n",
    argv[2], argv[1], argv[4], argv[3]);

  system("dltmsgf qtemp/msgstoxlat");
  system("crtmsgf qtemp/msgstoxlat");

  memcpy(newMsgF, argv[1], 10);
  memcpy(newMsgF+10, argv[2], 10);
  memcpy(oldMsgF, argv[3], 10);
  memcpy(oldMsgF+10, argv[4], 10);
  memcpy(&compareIdOnly, argv[5], 1);

  // Make two passes. One to find new messages and a second to find changed. Print results.
  memcpy(rtvOpt, "*FIRST    ", 10);

  while (1)
  {
    memset(&error, 0, sizeof(error));
    error.Bytes_Provided = sizeof(error);
    QMHRTVM(&msgDtaNew, sizeof(msgDtaNew), "RTVM0300", msgIdNew, newMsgF, " ", 0, "*NO       ", "*NO        ",
      &error, rtvOpt, 0, 0);
    if (error.Bytes_Available > 0)
    {
      if (!memcmp(error.Exception_Id, "CPF2419", 7))
      {
        break;
      }
      printf("Error retrieving %.7s from new message file: %.7s\n", msgIdNew, error.Exception_Id);
      return;
    }
    totalMsgs++;
    memcpy(rtvOpt, "*NEXT     ", 10);
    memcpy(msgIdNew, msgDtaNew.msgInf.Message_ID, sizeof(msgIdNew));
    // Search through old message file for message existence and message changes.
    QMHRTVM(&msgDtaOld, sizeof(msgDtaOld), "RTVM0300", msgIdNew, oldMsgF, " ", 0, "*NO       ", "*NO        ",
      &error);
    // Message id not found in old message file...must be new message.
    if (error.Bytes_Available > 0)
    {
      if (!memcmp(error.Exception_Id, "CPF2419", 7) && memcmp(msgIdNew, "       ", 7))
      {
        fprintf(qsysprt, " %.7s not found in old message file. New message.\n", msgIdNew);
        addMsgToExport();
        newMsgs++;
        continue;
      }
      else
      {
        if (memcmp(msgIdNew, "       ", 7))
        {
          printf("Error retrieving message %.7s from old message file. Error: %.7s\n", msgIdNew, error.Exception_Id);
          return;
        }
      }
    }
    if (compareIdOnly == 'N' && memcmp(msgDtaNew.message, msgDtaOld.message, msgDtaNew.msgInf.Length_Message_Available)
      &&  memcmp(msgIdNew, "       ", 7))
    {
      fprintf(qsysprt, " Message text changed for %.7s\n", msgIdNew);
      addMsgToExport();
      changedMsgs++;
    }
  }
  fprintf(qsysprt, " New messages %i\n", newMsgs);
  fprintf(qsysprt, " Changed messages %i\n", changedMsgs);
  fprintf(qsysprt, " Total messages %i\n", totalMsgs);
  fprintf(qsysprt, " End of listing\n");
  fclose(qsysprt);
  return;
}

void addMsgToExport(void)
{
  char msgTxt[133];
  char replacementValues[256];
  int i, replaceOffset = 0;
  Qmh_Subst_Variable_Format_t varData;

  memset(msgTxt, 0, sizeof(msgTxt));
  memcpy(msgTxt, msgDtaNew.message, msgDtaNew.msgInf.Length_Message_Available);
  sprintf(sysCmd, "addmsgd msgid(%.7s) msgf(%s) msg('%s')", msgIdNew, "QTEMP/MSGSTOXLAT", msgTxt);
  if (msgDtaNew.msgInf.Number_Replace_Data_Formats > 0)
  {
    replaceOffset = msgDtaNew.msgInf.Offset_Formats - (sizeof(msgDtaNew) - sizeof(msgDtaNew.message));
    for (i = 0; i < msgDtaNew.msgInf.Number_Replace_Data_Formats; i++)
    {
      memset(replacementValues, 0, sizeof(replacementValues));
      memcpy(&varData, msgDtaNew.message+replaceOffset, sizeof(varData));
      if (i == 0)
        sprintf(replacementValues, " FMT((%.10s %i)", varData.Subst_Variable_Type, varData.Length_Subst_Replace_Data);
      else
        sprintf(replacementValues, " (%.10s %i)", varData.Subst_Variable_Type, varData.Length_Subst_Replace_Data);
      strcat(sysCmd, replacementValues);
      replaceOffset = replaceOffset + msgDtaNew.msgInf.Length_Format_Element;
    }
    strcat(sysCmd, ")");
  }
  if (system(sysCmd))
  {
    fprintf(qsysprt," Error adding message %.7s to export message file QTEMP/MSGSTOXLATE.\n", msgIdNew);
    printf("Error adding message %.7s to export message file QTEMP/MSGSTOXLATE.\n", msgIdNew);
  }
  return;
}

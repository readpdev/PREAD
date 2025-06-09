      /*%METADATA                                                     */
      /* %TEXT Print User/Group Authorities for Specified Object      */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <qsyrtvua.h>
#include <qusec.h>

void main(int argc, char *argv[])
{
  char *RtnValP;
  int RtnValLen, NbrEntries, i;
  Qsy_RTVUA_RTUA0100_t RtnVals;
  Qsy_RTVUA_Feedback_Info_T FeedBack;
  Qus_EC_t ErrorCode;
  if (argc < 2)
  {
    printf("Usage: dspobjsec '/QSYS.LIB/DATA.LIB/OBJECT.TYPE'\n");
    return;
  }
  memset(&ErrorCode, 0, sizeof(ErrorCode));
  ErrorCode.Bytes_Provided = sizeof(ErrorCode);
  QSYRTVUA(&RtnVals, sizeof(RtnVals), &FeedBack, sizeof(FeedBack), "RTUA0100",
   argv[1], strlen(argv[1]), &ErrorCode);
  if (ErrorCode.Bytes_Available == 0 &&
    FeedBack.Bytes_Available_Receiver > FeedBack.Entry_Length)
  {
    RtnValLen = (FeedBack.Bytes_Available_Receiver);
    RtnValP = malloc(RtnValLen);
    QSYRTVUA(RtnValP, RtnValLen, &FeedBack, sizeof(FeedBack), "RTUA0100",
      argv[1], strlen(argv[1]), &ErrorCode);
  }
  if (ErrorCode.Bytes_Available == 0)
  {
    NbrEntries = FeedBack.Bytes_Available_Receiver/FeedBack.Entry_Length;
    printf("\n\nAuthority for object %s\n\n", argv[1]);
    for (i = 0; i < NbrEntries; i++)
    {
      memcpy(&RtnVals, RtnValP+(i*FeedBack.Entry_Length), sizeof(RtnVals));
      printf("User: %.10s\n", RtnVals.User_Name);
      printf("Group Indicator...: %c\n", RtnVals.User_Group_Indicator);
      printf("Data Authority....: %.10s\n", RtnVals.Data_Authority);
      printf("List Management...: %c\n", RtnVals.Authorization_List_Management);
      printf("Object Management.: %c\n", RtnVals.Object_Management);
      printf("Object Exist......: %c\n", RtnVals.Object_Existence);
      printf("Object Alter......: %c\n", RtnVals.Object_Alter);
      printf("Object Reference..: %c\n", RtnVals.Object_Reference);
      printf("Object Operational: %c\n", RtnVals.Object_Operational);
      printf("Data Read.........: %c\n", RtnVals.Data_Read);
      printf("Data Add..........: %c\n", RtnVals.Data_Add);
      printf("Data Update.......: %c\n", RtnVals.Data_Update);
      printf("Data Delete.......: %c\n", RtnVals.Data_Delete);
      printf("Data Execute......: %c\n\n", RtnVals.Data_Execute);
    }
  }
  dealloc(RtnValP);
  return;
}

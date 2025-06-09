#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <qgyolspl.h>
#include <qusec.h>
#include "lstsplf.h"

void main(int argc, char *argv[])
{
  char userid[10], qualJobName[26];
  int i;
  for (i=0;i<24;i++)
    printf("\n");
  if (argc < 2)
  {
    printf("Usage: cntmysplf username\n");
    return;
  }
  memset(userid, ' ', sizeof(userid));
  memcpy(userid, argv[1], strlen(argv[1]));
  memset(qualJobName, ' ', sizeof(qualJobName));
  Error.Bytes_Provided = sizeof(Error);
  Error.Bytes_Available = 0;
  sortInfo.Num_Keys = 0;
  sortInfo.SData[0].Start_Pos = 0;
  sortInfo.SData[0].Field_Length = 0;
  memset(&sortInfo.SData[0].Data_Type, 0x00, sizeof(short));
  memset(&sortInfo.SData[0].Sort_Order, 0x00, sizeof(char));
  memset(&sortInfo.SData[0].Reserved, 0x00, sizeof(char));
  filterInfo.Num_User_Names = 1;
  memcpy(&filterInfo.UserInfo[0].User_Name, userid, 10);
  filterInfo.Num_Q_Names = 1;
  memcpy(&filterInfo.Qinfo[0].Output_Q_Name, "*ALL      ", 10);
  memset(&filterInfo.Qinfo[0].Output_Q_Lib_Name, ' ', 10);
  memcpy(&filterInfo.Form_Type, "*ALL      ", 10);
  memcpy(&filterInfo.User_Data, "*ALL      ", 10);
  filterInfo.Num_Statuses = 1;
  memcpy(&filterInfo.SFInfo[0].SF_Status[0], "*ALL      ", 10);
  filterInfo.Num_Dev_Names = 1;
  memcpy(&filterInfo.DevInfo[0].Dev_Name[0], "*ALL      ", 10);
  printf("Building List...Stand by.\n");
  system("addlible qgy");
  QGYOLSPL(&splRcv100, sizeof(Qgy_Olspl_RecVar_0100_t), &listInfo, -1,
    &sortInfo, &filterInfo, qualJobName, "OSPL0100", &Error);
  printf("Number of spool files for %s is %d.\n", argv[1], listInfo.Total_Record
  return;
}

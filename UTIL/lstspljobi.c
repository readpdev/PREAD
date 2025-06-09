#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<qgyolspl.h>
#include<qgygtle.h>
#include<qgyclst.h>
#include<qusrjobi.h>
#include<qusec.h>

#include "lstsplf.h"

int  printError(char *callTo);
int  init(void);
int  addlible(void);
int  buildList(void);
int  getListItems(void);
void mainMenu(void);
void clrscrn(void);
int  processOption(void);
int  cleanUp(void);

int main(void)
{
  if(!init()) return 1;
  while(option != 'q' && option != 'Q')
  {
    mainMenu();
    processOption();
  }
  if(!cleanUp()) return 1;
  return 0;
}

int printError(char *callTo)
{
  if (Error.Bytes_Available > 0)
  {
    printf("Error on call to %s. Error code: %.7s\n",callTo,Error.Exception_Id);
    return 1;
  }
  return 0;
}

int init(void)
{
  Error.Bytes_Provided = sizeof(Error);
  Error.Bytes_Available = 0;
  sortInfo.Num_Keys = 0;
  sortInfo.SData[0].Start_Pos = 0;
  sortInfo.SData[0].Field_Length = 0;
  memset(&sortInfo.SData[0].Data_Type, 0x00, sizeof(short));
  memset(&sortInfo.SData[0].Sort_Order, 0x00, sizeof(char));
  memset(&sortInfo.SData[0].Reserved, 0x00, sizeof(char));
  filterInfo.Num_User_Names = 1;
  memcpy(&filterInfo.UserInfo[0].User_Name, "*ALL      ", 10);
  filterInfo.Num_Q_Names = 1;
  memcpy(&filterInfo.Qinfo[0].Output_Q_Name, "*ALL      ", 10);
  memset(&filterInfo.Qinfo[0].Output_Q_Lib_Name, ' ', 10);
  memcpy(&filterInfo.Form_Type, "*ALL      ", 10);
  memcpy(&filterInfo.User_Data, "*ALL      ", 10);
  filterInfo.Num_Statuses = 1;
  memcpy(&filterInfo.SFInfo[0].SF_Status[0], "*ALL      ", 10);
  filterInfo.Num_Dev_Names = 1;
  memcpy(&filterInfo.DevInfo[0].Dev_Name[0], "*ALL      ", 10);
  if (!addlible()) return 1;
  return 0;
}

int addlible(void)
{
  int totalLibs;
  if (!inLibList)
  {
    memset(&qualJobName, '*', 1);
    QUSRJOBI(&jobi, sizeof(jobi), "JOBI0700", qualJobName, intJobID, &Error);
    if (!printError("QUSRJOBI\0")) return 1;
    totalLibs = jobi.Libs_In_Syslibl + jobi.Prod_Libs + jobi.Curr_Libs +
      jobi.Libs_In_Usrlibl;
    for (i = 0; i < totalLibs; i++)
    {
      if (jobi.Lib[i].Lib_Name == "QGY       ")
      {
        inLibList = TRUE;
        break;
      }
    }
    if (inLibList == FALSE)
    {
      system("addlible qgy *last");
      addedByThis = TRUE;
      inLibList = TRUE;
    }
  }
  return 0;
}

int buildList(void)
{
  memset(&qualJobName, ' ', sizeof(qualJobName));
  QGYOLSPL(&splRcv100, sizeof(Qgy_Olspl_RecVar_0100_t), &listInfo, -1,
    &sortInfo, &filterInfo, qualJobName, "OSPL0100", &Error);
  if (!printError("QGYGTLE\0"))
    return 1;
  return 0;
}

int getListItems(void)
{
  for (i=0; i < listInfo.Total_Records; i++)
  {
    QGYGTLE(&splRcv100, sizeof(Qgy_Olspl_RecVar_0100_t),
      listInfo.Request_Handle, &listInfo, i, -1, &Error);
    if (!printError("QGYGTLE\0"))
      return 1;
  }
  return 0;
}

void clrscrn(void)
{
  for (i=0; i < 25; i++)
  {
    printf("\n");
  }
}

void mainMenu(void)
{
  clrscrn();
  printf("          List Spool Files\n");
  printf("          ----------------\n\n");
  printf("          1) Set Sort/Filter Options\n");
  printf("          2) Display List\n");
  printf("          Q) Quit\n");
  printf("          Option: ");
  return;
}

int processOption(void)
{
  scanf("%c", &option);
  getchar();
  switch (option)
  {
    case '1':
      break;
    case '2':
      return buildList();
      break;
  }
  return 0;
}

int cleanUp(void)
{
  QGYCLST(listInfo.Request_Handle, &Error);
  if (!printError("QGYCLST\0")) return 1;

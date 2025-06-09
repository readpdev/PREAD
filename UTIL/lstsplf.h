Qgy_Olspl_RecVar_0100_t splRcv100;
Qgy_Olspl_ListInfo_t listInfo;
typedef _Packed struct _SortInfo
{
  int Num_Keys;
  Qgy_Olspl_SData_t SData[1];
} _SortInfo_t;
_SortInfo_t sortInfo;
typedef _Packed struct _filterInfo
{
   int   Num_User_Names;
   Qgy_Olspl_UserInfo_t UserInfo[1];
   int   Num_Q_Names;
   Qgy_Olspl_Qinfo_t Qinfo[1];
   char  Form_Type[10];
   char  User_Data[10];
   int   Num_Statuses;
   Qgy_Olspl_SFInfo_t SFInfo[1];
   int   Num_Dev_Names;
   Qgy_Olspl_DevInfo_t DevInfo[1];
} filterInfo_t;
filterInfo_t filterInfo;
char qualJobName[26] = "                          ";
Qus_EC_t Error;
char intJobID[16] = "                ";
char option;
int i, lenChgCmdStr, inLibList = 0, addedByThis = 0, listCreated = 0;

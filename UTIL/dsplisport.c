      /*%METADATA                                                     */
      /* %TEXT Display listener ports                                 */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <errno.h>

#include<quslobj.h>
#include<quscrtus.h>
#include<qusptrus.h>
#include<qusdltus.h>
#include<qusec.h>
#include<qusgen.h>
#include<qwcrdtaa.h>
#include<qusrjobi.h>

FILE *fp;

Qus_EC_t Error;
Qus_Generic_Header_0100_t *GenericHeader;
Qus_OBJL0100_t *ListData;

typedef _Packed struct Rdtaa_Data_Returned
{
  int  Bytes_Available;
  int  Bytes_Returned;
  char Type_Value_Returned[10];
  char Library_Name[10];
  int  Length_Value_Returned;
  int  Number_Decimal_Positions;
  char otherData1[305];
  char dtalib[10];
  char otherData2[339];
  char port[4];
} Rdtaa_Data_Returned_t;
Rdtaa_Data_Returned_t dataRtn;

typedef struct _Port_Status
{
  char status[7];
  char jobName[10];
  char jobUser[10];
  char jobNbr[6];
} _Port_Status_t;

char UserSpaceName[20] = "DSPLISPORTQTEMP     ";
char ExtAttr[10] = "          ";
int InitSize = 1024, i, splfSize;
char InitVal = 0x00;
char PubAuth[10] = "*ALL      ";
char Description[50] = "Display listener ports";
char *SpacePtr;
char QualObj[26] = "SYSDFT    *ALLUSR   ";
char dataArea[20] = "SYSDFT              ";

int getPortStatus(char *port, char *library, char *server,
  _Port_Status_t *status);
char *trimr(char *, int);

void main(int argc, char *argv[])
{
  int i;
  _Port_Status_t *ps;
  char fileName[21];
  char version[5], server[255], activeOnly;
  if (argc < 2)
  {
    printf("Server IP address:\n");
    scanf("%s", &server);
  }
  else
    strcpy(server, argv[1]);
  if (argc < 3)
  {
    if (argc < 2) getchar();
    printf("Select active only (Y/N):\n");
    scanf("%c", &activeOnly);
  }
  else
    memcpy(&activeOnly, argv[2], 1);
  ps = malloc(sizeof(_Port_Status_t));
  QUSCRTUS(UserSpaceName, ExtAttr, InitSize, &InitVal, PubAuth, Description,
           "*YES      ", &Error);
  QUSLOBJ(UserSpaceName, "OBJL0100", QualObj, "*DTAARA   ");
  QUSPTRUS(UserSpaceName, &SpacePtr, &Error);
  GenericHeader = (Qus_Generic_Header_0100_t *)SpacePtr;
  ListData = (Qus_OBJL0100_t *)(SpacePtr + GenericHeader->Offset_List_Data);
  if (GenericHeader->Number_List_Entries > 0)
  printf("\n\n");
  printf("Library     Port  Status   Job Name    User        Number  Vers\n");
  printf("----------  ----  -------  ----------  ----------  ------  -----\n");
  for (i = 0; i < GenericHeader->Number_List_Entries; i++)
  {
    memcpy(dataArea+10, ListData->Object_Lib_Name_Used, 10);
    Error.Bytes_Provided = sizeof(Error);
    Error.Bytes_Available = 0;
    QWCRDTAA(&dataRtn, sizeof(dataRtn), dataArea, 1, 658, &Error);
    if (Error.Bytes_Available == 0 && dataRtn.port[0] != ' ')
    {
      memset(&fileName, 0, sizeof(fileName));
      sprintf(fileName, "%s/%s", trimr(dataRtn.dtalib, 10), "MHEADER");
      if ((fp = fopen(fileName, "r")) != NULL)
      {
        memset(&version, 0, sizeof(version));
        fgets(version, sizeof(version)-1, fp);
        fclose(fp);
        if (!getPortStatus(dataRtn.port, dataRtn.Library_Name, server, ps))
          return;
        if ((activeOnly == 'Y' || activeOnly == 'y') &&
          memcmp(ps->status, "*ACTIVE", 7))
        {
          ListData++;
          continue;
        }
        printf("%.10s  %.4s  %.7s  %.10s  %.10s  %.6s  %.5s\n",
          dataRtn.Library_Name, dataRtn.port, ps->status, ps->jobName,
          ps->jobUser, ps->jobNbr, version);
      }
    }
    ListData++;
  }
  QUSDLTUS(UserSpaceName, &Error);
  return;
}

int getPortStatus(char *port, char *library, char *server,
  _Port_Status_t *status)
{
  typedef _Packed struct _JOBI0700
  {
    int  Bytes_Return;
    int  Bytes_Avail;
    char Job_Name[10];
    char User_Name[10];
    char Job_Number[6];
    char Int_Job_ID[16];
    char Job_Status[10];
    char Job_Type[1];
    char Job_Subtype[1];
    char Reserved[2];
    int  Libs_In_Syslibl;
    int  Prod_Libs;
    int  Curr_Libs;
    int  Libs_In_Usrlibl;
    char libl[255][11];
  } JOBI0700_t;
  JOBI0700_t ji;
  int sd, rc, i, totalLibs;
  char buf[1024];
  struct sockaddr_in sa;
  struct hostent *hostp;
  char qualJob[26] = "*INT                      ";
  char *libl;
  memset(status, ' ', sizeof(_Port_Status_t));
  sd = socket(AF_INET, SOCK_STREAM, 0);
  if (sd > 0)
  {
    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_port = atoi(port);
    sa.sin_addr.s_addr = inet_addr(server);
    rc = connect(sd, (struct sockaddr *)&sa, sizeof(sa));
    if (rc > -1)
    {
      memset(&buf, 0, sizeof(buf));
      memcpy(&buf, "STATUS    BASIC     ", 20);
      if (write(sd, &buf, sizeof(buf)))
      {
        if (read(sd, &buf, sizeof(buf)))
        {
          memset(&Error, 0, sizeof(Error));
          Error.Bytes_Provided = sizeof(Error);
          QUSRJOBI(&ji, sizeof(ji), "JOBI0700", qualJob, buf, &Error);
          if (Error.Bytes_Available == 0)
          {
            totalLibs = ji.Prod_Libs + ji.Curr_Libs + ji.Libs_In_Syslibl +
              ji.Libs_In_Usrlibl;
            for (i = 0; i < totalLibs; i++)
            {
              if (!memcmp(ji.libl[i], library, 10))
              {
                memcpy(status->status, "*ACTIVE", 7);
                memcpy(status->jobName, ji.Job_Name, 10);
                memcpy(status->jobUser, ji.User_Name, 10);
                memcpy(status->jobNbr, ji.Job_Number, 6);
                break;
              }
            }
          }
        }
      }
    }
    close(sd);
  }
  return 1;
}

char *trimr(char *field, int fieldLen)
{
  char *cp, *sp;
  cp = malloc(fieldLen+1);
  memset(cp, 0, fieldLen+1);
  memcpy(cp, field, fieldLen);
  sp = cp;
  cp = cp + fieldLen - 1;
  while (*cp == ' ' && cp > sp)
  {
    *cp = 0;
    cp--;
  }
  return sp;
}

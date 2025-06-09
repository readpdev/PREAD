#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <qusec.h>
#include <sqlcli.h>
#include<qwcrdtaa.h>

typedef _Packed struct signon_struct
{
  char server[10];
  char uid[10];
  char pwd[10];
} signon_t;

int Connect(SQLHENV henv, SQLHDBC *hdbc, signon_t *signon);
int print_error (SQLHENV henv, SQLHDBC hdbc, SQLHSTMT hstmt);
#define MAX_DSN_LENGTH 18
#define MAX_UID_LENGTH 10
#define MAX_PWD_LENGTH 10
#define MAX_CONNECTIONS 5
SQLINTEGER sqlAttr;
typedef struct API_Error
{
  Qus_EC_t error;
  char msg[100];
} API_Error_t;

int main(int argc, char *argv[])
{
  SQLHENV henv;
  SQLHDBC hdbc;
  SQLCHAR sqlStmt[SQL_MAX_MESSAGE_LENGTH];
  SQLHSTMT hstmt;
  SQLRETURN rc;
  signon_t *so;
  if (argc > 2)
  {
    so = malloc(sizeof(*so));
    memcpy(so->server, argv[2], 10);
    memcpy(so->uid, argv[3], 10);
    memcpy(so->pwd, argv[4], 10);
  }
  SQLAllocEnv(&henv);
  Connect(henv, &hdbc, so);
  memset(sqlStmt, 0, sizeof(sqlStmt));
  memcpy(sqlStmt, argv[1], strlen(argv[1]));
  rc = SQLAllocStmt(hdbc, &hstmt);
  if (!rc) rc = SQLExecDirect(hstmt, sqlStmt, SQL_NTS);
  if (rc) print_error(henv, hdbc, hstmt);
  SQLDisconnect(hdbc); /* disconnect first connection */
  SQLFreeConnect(hdbc); /* free first connection handle */
  SQLFreeEnv(henv); /* free environment handle */
  return 0;
}

int Connect(SQLHENV henv, SQLHDBC *hdbc, signon_t *so)
{
  int rc = 0;
  char dataArea[20] = "SQLFLY    QTEMP     ";
  char sysCmd[255];
  API_Error_t Error;
  memset(&Error, 0, sizeof(Error));
  Error.error.Bytes_Provided = sizeof(Error);
  if (*so == 0) so = malloc(sizeof(*so));
  QWCRDTAA(so, sizeof(*so), dataArea, 1, sizeof(*so), &Error);
  if (Error.error.Bytes_Available > 0 &&
    !memcmp(Error.error.Exception_Id, "CPF1015", 7))
  {
    system("crtdtaara qtemp/sqlfly *char 50");
    printf("Enter Server Name:\n");
    gets(so->server);
    printf("Enter User Name:\n");
    gets(*so.id);
    printf("Enter Password Name:\n");
    gets(so->pwd);
  }
  rc = SQLAllocConnect(henv, hdbc);
  sqlAttr = SQL_TXN_NO_COMMIT;
  if (!rc) rc = SQLSetConnectOption(*hdbc, SQL_ATTR_COMMIT, &sqlAttr);
  if (!rc) rc = SQLConnect(*hdbc, so->server, SQL_NTS, so->uid, SQL_NTS,
    so->pwd, SQL_NTS);
  if(!rc)
  {
    sprintf(sysCmd, "chgdtaara qtemp/sqlfly \'%-10s%-10s%-10s\'",
      so->server, so->uid, so->pwd);
    system(sysCmd);
  }
  else
    system("dltdtaara qtemp/sqlfly");
  return rc;
}

int print_error (SQLHENV henv, SQLHDBC hdbc, SQLHSTMT hstmt)
{
  SQLCHAR buffer[SQL_MAX_MESSAGE_LENGTH + 1];
  SQLCHAR sqlstate[SQL_SQLSTATE_SIZE + 1];
  SQLINTEGER sqlcode;
  SQLSMALLINT length;
  while (SQLError(henv, hdbc, hstmt, sqlstate, &sqlcode, buffer,
  SQL_MAX_MESSAGE_LENGTH + 1, &length) == SQL_SUCCESS )
    printf("%s \n", buffer);
  return 0;
}

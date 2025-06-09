      /*%METADATA                                                     */
      /* %TEXT SQL Link Data Retrieval Module                         */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <string.h>
#include <decimal.h>
#include "sqlcli.h"

#define MAXHANDLE 256
#define OK 0

static SQLHENV henv;
static SQLHDBC hdbc;
static SQLHSTMT hstmt[MAXHANDLE];
SQLRETURN rc;
static int sessInit;
SQLINTEGER fieldLen;

typedef struct aDataStruct
{
  char cusnum[6];
  char lstnam[8];
  char init[3];
  char street[13];
  char city[6];
  char state[2];
  char zipcod[5];
  char cdtlmt[4];
  char chgcod;
  char baldue[6];
  char cdtdue[6];
} aData_t;

aData_t aData;
SQLINTEGER sqlTRUE = SQL_TRUE;
SQLINTEGER sqlFALSE = SQL_FALSE;
SQLINTEGER sqlCURSORINSENSITIVE = SQL_INSENSITIVE;
SQLINTEGER sqlCURSORSTATIC = SQL_CURSOR_STATIC;
SQLINTEGER sqlFIRSTIO = SQL_FIRST_IO;
SQLINTEGER sqlALLIO = SQL_ALL_IO;
SQLINTEGER sqlNOCOMMIT = SQL_TXN_NO_COMMIT;
SQLINTEGER sqlFMTJOB = SQL_FMT_JOB;
SQLINTEGER sqlSEPJOB = SQL_SEP_JOB;

int sqlDBopen(short wh, char *stmt)
{

  if (!sessInit)
  {
    // Initialize
    rc = SQLAllocEnv(&henv);
    //rc = SQLSetEnvAttr(henv,SQL_ATTR_SERVER_MODE,&sqlTRUE,0);
    rc = SQLAllocConnect(henv, &hdbc);
    rc = SQLSetConnectAttr(hdbc, SQL_ATTR_DATE_FMT, &sqlFMTJOB, 0);
    rc = SQLSetConnectAttr(hdbc, SQL_ATTR_DATE_SEP, &sqlSEPJOB, 0);
    rc = SQLSetConnectAttr(hdbc, SQL_ATTR_DBC_SYS_NAMING, &sqlTRUE, 0);
    rc = SQLSetConnectAttr(hdbc, SQL_ATTR_2ND_LEVEL_TEXT, &sqlTRUE, 0);
    rc = SQLSetConnectAttr(hdbc, SQL_ATTR_QUERY_OPTIMIZE_GOAL, &sqlFIRSTIO, 0);
    rc = SQLSetConnectAttr(hdbc, SQL_ATTR_COMMIT, &sqlNOCOMMIT, 0);
    rc = SQLConnect(hdbc, 0, SQL_NTS, NULL, SQL_NTS, NULL, SQL_NTS);
    if (rc) return rc;
    sessInit = 1;
  }

  rc = SQLAllocStmt(hdbc, &hstmt[wh]);
  if (rc) return rc;

  rc = SQLSetStmtAttr(hstmt[wh], SQL_ATTR_CURSOR_SCROLLABLE, &sqlTRUE, 0);
  if (rc) return rc;
  rc = SQLSetStmtAttr(hstmt[wh], SQL_ATTR_FOR_FETCH_ONLY, &sqlTRUE, 0);
  if (rc) return rc;

  // Execute
  rc = SQLExecDirect(hstmt[wh], stmt, SQL_NTS);

  return rc;

}

int sqlDBread(short wh, char *opcode, aData_t *aDataIO)
{

  SQLUSMALLINT fetchDirection = SQL_FETCH_NEXT;
  if (!strcmp(opcode,"READP")) fetchDirection = SQL_FETCH_PRIOR;
  if (!strcmp(opcode,"SETEN")) fetchDirection = SQL_FETCH_LAST;

  rc = SQLFetchScroll(hstmt[wh], fetchDirection, 0);

  if (!rc)
  {
    rc = SQLGetCol(hstmt[wh], 1, SQL_CHAR, (SQLPOINTER) aData.cusnum,
      (SQLINTEGER) sizeof(aData.cusnum), (SQLINTEGER *) &fieldLen);
    rc = SQLGetCol(hstmt[wh], 2, SQL_CHAR, (SQLPOINTER) aData.lstnam,
      (SQLINTEGER) sizeof(aData.lstnam), (SQLINTEGER *) &fieldLen);
    rc = SQLGetCol(hstmt[wh], 3, SQL_CHAR, (SQLPOINTER) aData.init,
      (SQLINTEGER) sizeof(aData.init), (SQLINTEGER *) &fieldLen);
    rc = SQLGetCol(hstmt[wh], 4, SQL_CHAR, (SQLPOINTER) aData.street,
      (SQLINTEGER) sizeof(aData.street), (SQLINTEGER *) &fieldLen);
    rc = SQLGetCol(hstmt[wh], 5, SQL_CHAR, (SQLPOINTER) aData.city,
      (SQLINTEGER) sizeof(aData.city), (SQLINTEGER *) &fieldLen);
    rc = SQLGetCol(hstmt[wh], 6, SQL_CHAR, (SQLPOINTER) aData.state,
      (SQLINTEGER) sizeof(aData.state), (SQLINTEGER *) &fieldLen);
    rc = SQLGetCol(hstmt[wh], 7, SQL_CHAR, (SQLPOINTER) aData.zipcod,
      (SQLINTEGER) sizeof(aData.zipcod), (SQLINTEGER *) &fieldLen);
    rc = SQLGetCol(hstmt[wh], 8, SQL_CHAR, (SQLPOINTER) aData.cdtlmt,
      (SQLINTEGER) sizeof(aData.cdtlmt), (SQLINTEGER *) &fieldLen);
    //rc = SQLGetCol(hstmt[wh], 9, SQL_CHAR, (SQLPOINTER) aData.chgcod,
    //  (SQLINTEGER) sizeof(aData.chgcod), (SQLINTEGER *) &fieldLen);
    //rc = SQLGetCol(hstmt[wh], 10, SQL_CHAR, (SQLPOINTER) aData.baldue,
    //  (SQLINTEGER) sizeof(aData.baldue), (SQLINTEGER *) &fieldLen);
    //rc = SQLGetCol(hstmt[wh], 11, SQL_CHAR, (SQLPOINTER) aData.cdtdue,
    //  (SQLINTEGER) sizeof(aData.cdtdue), (SQLINTEGER *) &fieldLen);
  }

  if (rc >= 0)
    memcpy(aDataIO, &aData, sizeof(aData));

  return rc;
}

int sqlDBclose(short wh)
{

  rc = SQLFreeStmt(hstmt[wh], SQL_DROP);
  hstmt[wh] = 0;
  return OK;
}

int sqlDBquit(void)
{

  rc = SQLSetEnvAttr(henv,SQL_ATTR_SERVER_MODE,&sqlFALSE,0);
  rc = SQLDisconnect(hdbc);
  rc = SQLFreeConnect(hdbc);
  rc = SQLFreeEnv(henv);
  sessInit = 0;
  return OK;
}

static int print_error (SQLHENV henv, SQLHDBC hdbc, SQLHSTMT hstmt)
{

/* Sample code to call this error function. */
/* print_error(henv, hdbc, hstmt[wh]); */

SQLCHAR     buffer[SQL_MAX_MESSAGE_LENGTH + 1];
SQLCHAR     sqlstate[SQL_SQLSTATE_SIZE + 1];
SQLINTEGER  sqlcode;
SQLSMALLINT length;
SQLRETURN rc;

    rc == SQLError(henv, hdbc, hstmt, sqlstate, &sqlcode, buffer,
      SQL_MAX_MESSAGE_LENGTH + 1, &length);

    if (rc >= SQL_SUCCESS)
    {
        printf("\n **** ERROR *****\n");
        printf("         SQLSTATE: %s\n", sqlstate);
        printf("Native Error Code: %ld\n", sqlcode);
        printf("%s \n", buffer);
    };
    return (0);

}

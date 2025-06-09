      /*%METADATA                                                     */
      /* %TEXT DocLink Retrieval SQL CLI                              */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <string.h>
#include "sqlcli.h"


static SQLHENV henv;
static SQLHDBC hdbc;
SQLRETURN rc;

typedef struct handlesStruct {
  SQLHSTMT hstmt;
  SQLCHAR stmt[2048];
  SQLCHAR field[50][100];
  SQLINTEGER fieldLen, i = 1;
  SQLSMALLINT numCols = 0;
} handlesStruct_t;

handlesStruct_t handles[256];

int linkOpen(int handleID)
{

  // Initialize
  rc = SQLAllocEnv(&henv);
  rc = SQLAllocConnect(henv, &handles[handleID].hdbc);
  rc = SQLConnect(hdbc, 0, SQL_NTS, NULL, SQL_NTS, NULL, SQL_NTS);
  rc = SQLAllocStmt(hdbc, &handles[handleID].hstmt);

  // Execute
  rc = SQLExecDirect(handles[handleID].hstmt, stmt, SQL_NTS);

  // Retrieve number of columns for result set.
  rc = SQLNumResultCols(hstmt, &numCols);

  // Bind all of the columns to usable fields.
  fieldLen = SQL_NTS;
  for (i = 1; i < numCols; i++)
  {
    rc = SQLBindCol(hstmt, i, SQL_CHAR, (SQLPOINTER) field[i-1],
      (SQLINTEGER) sizeof(field[i-1]), (SQLINTEGER *) &fieldLen);
  }

  // Fetch.
  while (!(rc = SQLFetch(hstmt)))
  {
    for (i=0; i < numCols; i++)
      printf("Field %i: %s\n", i+1, field[i]);
  }

  return;
}

int linkClose(int handleID) {

  // Cleanup
  rc = SQLFreeStmt(hstmt, SQL_DROP);
  rc = SQLDisconnect(hdbc);
  rc = SQLFreeConnect(hdbc);
  rc = SQLFreeEnv(henv);

}

linkPosition(int wh, char opCode[4]) {
}

linkRead(int handleID, char opCode[4]) {

  // Fetch.a record
  rc = SQLFetch(handles[handleID], handles[handleID].hstmt);
  {
    for (i=0; i < numCols; i++)
      printf("Field %i: %s\n", i+1, field[i]);
  }
}



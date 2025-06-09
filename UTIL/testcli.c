#include <stdio.h>
#include <string.h>
#include "sqlcli.h"

void main(void)
{
  SQLHENV henv;
  SQLHDBC hdbc;
  SQLHSTMT hstmt;
  SQLRETURN rc;
  SQLCHAR stmt[] = "select * from @000000300";
  SQLCHAR field[50][100];
  SQLINTEGER fieldLen, i = 1;
  SQLSMALLINT numCols = 0;
  char *thisGets;

  // Initialize
  rc = SQLAllocEnv(&henv);
  rc = SQLAllocConnect(henv, &hdbc);
  rc = SQLConnect(hdbc, 0, SQL_NTS, NULL, SQL_NTS, NULL, SQL_NTS);
  rc = SQLAllocStmt(hdbc, &hstmt);

  // Execute
  rc = SQLExecDirect(hstmt, stmt, SQL_NTS);

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

  // Cleanup
  rc = SQLFreeStmt(hstmt, SQL_DROP);
  rc = SQLDisconnect(hdbc);
  rc = SQLFreeConnect(hdbc);
  rc = SQLFreeEnv(henv);

  return;
}


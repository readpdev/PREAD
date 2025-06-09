      /*%METADATA                                                     */
      /* %TEXT DocManger User Index Module                            */
      /*%EMETADATA                                                    */
/*                                                                            */
/* 03-22-06 PLR Created. Work with user index interface.                      */
/*                                                                            */

#include "qusec.h"

/* Retrieve user index values search type constants */
#define UI_SEARCH_EQ       1
#define UI_SEARCH_GT       2
#define UI_SEARCH_LT       3
#define UI_SEARCH_GE       4
#define UI_SEARCH_LE       5
#define UI_SEARCH_FIRST    6
#define UI_SEARCH_LAST     7
#define UI_SEARCH_BETWEEN  8

typedef struct
{
  Qus_EC_t base;
  char data[100];
} uiError_t;

/*  Create User Index
 1 Qualified user index name Input Char(20)  'INDEXNAME LIBRARY   '
 2 Entry length              Input Binary(4)
 3 Key length                Input Binary(4)
*/
int crtUI(char *indexName, int entryLen, int keyLength);

/* Add user index values */
int addUI(char *indexName, char *indexValues);

/* Retrieve user index values */
int rtvUI(char *receiverVar, int lenReceiverVar, int *nbrEntriesRtn,
  char *indexName, int maxNbrEntries, int searchType, char *searchCriteria);

/* Delete user index */
int dltUI(char *indexName);

/* Retrieve last known error */
void getLastUIError(uiError_t *error);


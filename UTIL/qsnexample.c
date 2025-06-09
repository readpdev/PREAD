#include <stdio.h>
#include <string.h>

#include<qsnapi.h>

void main(void)
{
  long i;
  char s[100];

  QsnClrScr('0', 0, 0, NULL);
  for (i = 1; ; ++i) {
      sprintf(s, "Line %2.d.   Press Enter to roll, F3 to quit.", i);
      QsnWrtDta(s, strlen(s), 0, 24, 2, QSN_SA_NORM, QSN_SA_NORM,
                QSN_SA_NORM, QSN_SA_NORM, 0, 0, NULL);
      if (QsnGetAID(NULL, 0, NULL) == QSN_F3)
          break;
      QsnRollUp(1, 1, 24, 0, 0, NULL);
    }
  return;
}

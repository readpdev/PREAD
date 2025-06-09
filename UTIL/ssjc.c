#include <stdlib.h>
#include <stdio.h>

#pragma linkage(QGYOLJOB,OS)

extern void QGYOLJOB(char *Rcvr, int *RcvrLen, char *FmtName, char *RcvrDefInf,
                     int *RcvrDefInfLen, char *ListInf, int *Recs2Rtn,
                     char *SortInf, char *JobSltInf, int *SizeOfJobSltInf,
                     int *NumFlds2Rtn, int[] *KeyOfFlds2Rtn, char *Error)

int main(int argc, char *argv[]) {

/*printf("%d", *((int *) argv[1]));*/




  if (Qp0wGetJobID(argv[1], QP0W_Job_ID_T) == 0) {
    printf("%s", QP0W_Job_ID_T);
  }

}

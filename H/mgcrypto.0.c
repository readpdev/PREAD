
/* 04-22-09 PLR. Created. Encryption/Decryption AES algorithm. T65J           */

#include "qusec.h"

#define DOC_OP_ENCRYPT 1
#define DOC_OP_DECRYPT 2

int docEncDcr(int operation, char *target, int targetLen, char *source,
  int sourceLen, int *returnLen, Qus_EC_t *error);

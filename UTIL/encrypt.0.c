#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include "qc3dtaen.h"
#include "qusec.h"

void main(void) {
  char *clearText = "This is some clear text data";
  char cipherText[256];
  int lenCipherText;
  Qus_EC_t apiErr;
  Qc3_Format_ALGD0200_T algDescFmt;

  typedef struct keyFmtStruct {
    Qc3_Format_KEYD0200_T fmt;
    char keyString[256];
  } keyFmtStruct_t;
  keyFmtStruct_t key;

  memset(&algDescFmt, 0, sizeof(algDescFmt));
  algDescFmt.Block_Cipher_Alg = Qc3_AES;
  algDescFmt.Block_Length = 16;
  algDescFmt.Mode = Qc3_CBC;
  algDescFmt.Pad_Option = Qc3_No_Pad;
  algDescFmt.Pad_Character = '0';
  algDescFmt.MAC_Length = 0;
  algDescFmt.Effective_Key_Size = 0;
  strcpy(algDescFmt.Init_Vector, "cuando");
  key.fmt.Key_Type = Qc3_AES;
  strcpy(key.keyString, "mykey");
  key.fmt.Key_String_Len = strlen(key.keyString);
  key.fmt.Key_Format = Qc3_Bin_String;

  memset(&apiErr, 0, sizeof(apiErr));
  apiErr.Bytes_Provided = sizeof(apiErr);

  Qc3EncryptData(clearText, (int *)strlen(clearText), Qc3_Data,
    (uchar *) &algDescFmt, Qc3_Alg_Block_Cipher, (uchar *) &key, Qc3_Key_Parms,
    (uchar *) Qc3_Any_CSP, NULL, cipherText, (int *) sizeof(cipherText),
    &lenCipherText, &apiErr);

/*Qc3EncryptData(inCusInfo, &plainLen, Qc3_Data,
           (unsigned char *)&algD, Qc3_Alg_Block_Cipher,
           (unsigned char *)&AESkctx, Qc3_Key_Token,
           &csp, NULL, cusdtaout.ECUSDTA, &cipherLen, &rtnLen, &errCode); */

  return;
}

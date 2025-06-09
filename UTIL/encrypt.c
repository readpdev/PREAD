void main(void)
{

/*-------------------------------------------------------------------*/
/* Return codes                                                      */
/*-------------------------------------------------------------------*/

  int                   rtn;          /* Return code                 */
  #define               ERROR  -1
  #define               OK      0

/*-------------------------------------------------------------------*/
/* Parameters needed by the Cryptographic Services APIs              */
/*-------------------------------------------------------------------*/

  int                   keyType;      /* Key type                    */
  int                   keySize;      /* Key size                    */
  char                  keyFormat;    /* Key format                  */
  char                  keyForm;      /* Key form                    */
  Qc3_Format_ALGD0200_T algD;         /* Block cipher alg description*/
  char                  AESkctx¢8!;   /* AES key context token       */
  char                  kektkn¢8!;    /* Key-encrypting key ctx token*/
  char                  keatkn¢8!;    /* Key-encrypting alg ctx token*/
  char                  csp;          /* Crypto service provider     */
  char                  pcusdta¢80!;  /* Plaintext customer data     */
  int                   cipherLen;    /* Length of ciphertext        */
  int                   plainLen;     /* Length of plaintext         */
  int                   rtnLen;       /* Return length               */
  Qus_EC_t              errCode;      /* Error code structure        */
  char                  PRNtype;      /* PRN type                    */
  char                  PRNparity;    /* PRN parity                  */
  unsigned int          PRNlen;       /* Length of PRN data          */

/*-------------------------------------------------------------------*/
/* Initializations                                                   */
/*-------------------------------------------------------------------*/

                                      /* Init to good return         */
  rtn = OK;
                                      /* Generate exceptions         */
  memset(&errCode, 0, sizeof(errCode));
                                      /* Use any crypto provider     */
  csp = Qc3_Any_CSP;
                                      /* Set inCusInfo to null       */
  memset(inCusInfo, 0, sizeof(inCusInfo));

/*-------------------------------------------------------------------*/
/* Create a key context for the file key.                            */
/*-------------------------------------------------------------------*/

  keySize = sizeof(cuspi.KEY);        /* Key size                    */
  keyFormat = Qc3_Bin_String;         /* Key format is binary string */
  keyType = Qc3_AES;                  /* Key type is AES             */
  keyForm = Qc3_Encrypted;            /* Key string is encrypted     */
                                      /* Create key context          */
  Qc3CreateKeyContext(cuspi.KEY, &keySize, &keyFormat, &keyType,
                      &keyForm, kektkn, keatkn, AESkctx, &errCode);

/*-------------------------------------------------------------------*/
/* Set up algorithm description for encrypting customer data.        */
/*-------------------------------------------------------------------*/

  memset(&algD, 0, sizeof(algD));     /* Init description to null    */
  algD.Block_Cipher_Alg = Qc3_AES;    /* Use AES algorithm           */
  algD.Block_Length = 16;             /* Block size is 16            */
  algD.Mode = Qc3_CBC;                /* Use cipher block chaining   */
  algD.Pad_Option = Qc3_No_Pad;       /* Do not pad                  */

    PRNtype = Qc3PRN_TYPE_NORMAL;     /* Generate real random numbers*/
    PRNparity = Qc3PRN_NO_PARITY;     /* Do not adjust parity        */
    PRNlen = 16;                      /* Generate 16 bytes           */
    Qc3GenPRNs(cusdtaout.IV, PRNlen, PRNtype, PRNparity, &errCode);

/*-------------------------------------------------------------------*/
/* Encrypt information.                                              */
/*-------------------------------------------------------------------*/

                                      /* Copy IV to alg description  */
    memcpy(algD.Init_Vector, cusdtaout.IV, 16);

                                      /* Encrypt customer data       */
    plainLen = sizeof(inCusInfo);
    cipherLen = sizeof(cusdtaout.ECUSDTA);
    Qc3EncryptData(inCusInfo, &plainLen, Qc3_Data,
                  (unsigned char *)&algD, Qc3_Alg_Block_Cipher,
                  (unsigned char *)&AESkctx, Qc3_Key_Token,
                  &csp, NULL, cusdtaout.ECUSDTA, &cipherLen, &rtnLen, &errCode);

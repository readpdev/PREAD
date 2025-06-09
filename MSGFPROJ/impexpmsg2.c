      /*%METADATA                                                     */
      /* %TEXT Import/Export Message File                             */
      /*%EMETADATA                                                    */
/*      CRTOPT SYSIFCOPT(*IFSIO)                                              */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>

#include<qmhrmfat.h>
#include<qmhrtvm.h>
#include<qusec.h>
#include<iconv.h>
#include<sys/types.h>

#define IMPORT 8
#define EXPORT 6
#define MAXBUF 4096
#define MAX_LVL_ONE_LEN 132

typedef struct msgRcvr
{
  Qmh_Rtvm_RTVM0300_t fmt300;
  char data[3132];
} msgRcvr_t;

typedef struct errorStruct
{
  Qus_EC_t error;
  char errorData[100];
} errorStruct_t;

typedef struct msgIO
{
  char msgID[8];
  char lvlOne[133];
  char lvlTwo[3001];
} msgIO_t;

static int importMsgf(void);
static int exportMsgf(void);
int msgAPI(msgRcvr_t *rcvr, char *msgID, char *qualName,
  char *replacementData, int lenRplcData, char *rplcSubVals, char *rtvOpt);
static iconv_t iconv_init(int fromCCSID, int toCCSID);
static char *trimr(char *, int);
char *tick(char *);

char msgfLib[11], msgf[11], path[257], orginalEnglishMsgf[11], originalEnglishMsgfLib[11];
char syscmd[256], qualName[21], originalQualName[21], msgID[7];

void main(int argc, char *argv[])
{
  int rc = 0;
  iconv_t conv;

  memset(&msgfLib, 0, sizeof(msgfLib));
  memset(&msgf, 0, sizeof(msgf));
  memset(&originalEnglishMsgfLib, 0, sizeof(originalEnglishMsgfLib));
  memset(&originalEnglishMsgf, 0, sizeof(originalEnglishMsgf));
  memset(&path, 0, sizeof(path));
  memset(&fromCCSID, 0, sizeof(fromCCSID));
  memset(&toCCSID, 0, sizeof(toCCSID));
  memcpy(&msgf, argv[1], 10);
  memcpy(&msgfLib, argv[2], 10);
  memset(&msgID, ' ', sizeof(msgID));
  if (argc == EXPORT)
  {
    memcpy(&fromCCSID, argv[3], sizeof(fromCCSID));
    memcpy(&toCCSID, argv[4], sizeof(toCCSID));
    sprintf(path, "%s", trimr(argv[5], strlen(argv[5])));
  }
  else
  {
    memcpy(&originalEnglishMsgf, argv[3], 10);
    memcpy(&originalEnglishMsgfLib, argv[4], 10);
    memcpy(&fromCCSID, argv[5], sizeof(fromCCSID));
    memcpy(&toCCSID, argv[6], sizeof(toCCSID));
    sprintf(path, "%s", trimr(argv[7], strlen(argv[7])));
  }

  conv = iconv_init(fromCCSID, toCCSID);
  if (conv.cd == 0)
  {
    printf("CCSID conversion from %i to %i is invalid.\n",
      fromCCSID, toCCSID);
    return -1;
  }

  sprintf(qualName, "%.10s%.10s", msgf, msgfLib);
  sprintf(originalQualName, "%.10s%.10s", originalEnglisMsgf, originalEnglishMsgfLib);
  if (argc == IMPORT)
  {
    sprintf(syscmd, "chgjob ccsid(%i)", toCCSID);
    if (system(syscmd))
    {
      printf("Error setting job CCSID to %i.\n", toCCSID);
      exit(1);
    }
    rc = importMsgf();
  }
  if (argc == EXPORT)
    rc = exportMsgf(msgf, msgfLib, path, conv);
		iconv_close(conv);
  sprintf(syscmd, "%s", "chgjob ccsid(*sysval)");
  if (argc == IMPORT && system(syscmd))
    printf("Error setting job back to CCSID(*SYSVAL)\n");
  return;
}

static int importMsgf(char *msgf, char *msgfLib, char *path)
{
  FILE *fh;
  char buf[MAXBUF], outBuf[MAXBUF], syscmd[5000];
  int rc = 0, errCnt = 0;
  uint inBufLen, outBufLen;
  msgIO_t msg;
  char hexChar25 = 0x25;
  int fromCCSID, toCCSID;
  if (!(fh = fopen(path, "r")))
  {
    printf("Error opening %s\n", path);
    perror(strerror(errno));
    return -1;
  }
  fgets(buf, MAXBUF-1, fh); /* Throw away first record....header */
  while (fgets(buf, MAXBUF-1, fh))
  {
    memset(&msg, ' ', sizeof(msg));
    strcpy(msg.msgID, strtok(buf, "\t"));
    sprintf(msg.lvlOne, "%s", strtok(NULL, "\t"));
    sprintf(msg.lvlTwo, "%s", strtok(NULL, "\t"));
    sprintf(msg.lvlOne, "%s", strtok(msg.lvlOne, &hexChar25));
    sprintf(msg.lvlTwo, "%s", strtok(msg.lvlTwo, &hexChar25));
    msgApi
    sprintf(syscmd, "chgmsgd msgid(%s) msgf(%s/%s) msg(%s) seclvl(%s) ccsid(65535)",
      msg.msgID, trimr(msgfLib, strlen(msgfLib)), trimr(msgf, strlen(msgf)),
      tick(msg.lvlOne), tick(msg.lvlTwo));
    if ((rc = system(syscmd)))
    {
      if (strlen(msg.lvlOne) > MAX_LVL_ONE_LEN)
        printf("Message too long: %s\n", msg.msgID);
      else
        memcpy(syscmd, "add", 3);
        if ((rc = system(syscmd)))
          printf("Error updating/adding message: %s\n", msg.msgID);
    }
  }
  fclose(fh);
  return rc;
}

static int exportMsgf(void)
{
  FILE *fh;
  char rtvOpt[10], msgID[7], *errStr, buf[MAXBUF], outBuf[MAXBUF];
  uchar *t_inBuf, *t_outBuf;
  int rc = 0;
  uint inBufLen, outBufLen;
  msgRcvr_t rcvr;
  msgIO_t msg;
  Qmh_Rmfa_RMFA0100_t msgfAttr;
  errorStruct_t errorCode;

  memcpy(&rtvOpt, "*FIRST    ", sizeof(rtvOpt));
  if (!(fh = fopen(path, "wb, ccsid=819")))
  {
    printf("Error opening %s\n", path);
    perror(strerror(errno));
    return -1;
  }

  /* Write out message file library and name for identification purposes. */
  memset(&errorCode, 0, sizeof(errorCode));
  errorCode.error.Bytes_Provided = sizeof(errorCode);
  QMHRMFAT(&msgfAttr, sizeof(msgfAttr), "RMFA0100", qualName, &errorCode);
  if (errorCode.error.Bytes_Available > 0)
  {
    printf("Error retrieving message file attributes\n");
    return -1;
  }
  memset(buf, 0, sizeof(buf));
  memset(outBuf, 0, sizeof(buf));
  sprintf(buf, "%s\t%s\r\n", "msgid","msgtxt");
/*  trimr(msgfAttr.Message_File_Name, sizeof(msgfAttr.Message_File_Name)),
    trimr(msgfAttr.Message_File_Library, sizeof(msgfAttr.Message_File_Library)),
    trimr(msgfAttr.Text_Description, sizeof(msgfAttr.Text_Description)));*/
  t_inBuf = (char *)&buf;
  t_outBuf = outBuf;
  inBufLen = strlen(buf);
  outBufLen = MAXBUF;
  if ((rc = iconv(conv, &t_inBuf, &inBufLen, &t_outBuf, &outBufLen)) < 0)
  {
    errStr = strerror(errno);
    printf("Error iconv(): %s\n", errStr);
    rc = -1;
  }
  if (fwrite(outBuf, strlen(outBuf), 1, fh) < 0)
  {
    printf("Error writing to %s\n", path);
    rc = -1;
  }

  while (!rc)
  {
    memset(&errorCode, 0, sizeof(errorCode));
    errorCode.error.Bytes_Provided = sizeof(errorCode);
    if ((rc = msgAPI(&rcvr, msgID, qualName, " ", 0, " ", rtvOpt)))
    {
      rc = -1;
      if (rc == 1) /*end of msgf*/
        rc = 0;
      break;
    }
    memset(&msg, 0, sizeof(msg));
    memcpy(&msg.msgID, &rcvr.fmt300.Message_ID, sizeof(msg.msgID)-1);
    memcpy(&msg.lvlOne, (char *)&rcvr+rcvr.fmt300.Offset_Message_Returned,
      rcvr.fmt300.Length_Message_Available);
    memcpy(&msg.lvlTwo, (char *)&rcvr+rcvr.fmt300.Offset_Help_Returned,
      rcvr.fmt300.Length_Help_Available);
    memset(buf, 0, sizeof(buf));
    sprintf(buf, "%s\t%s\r\n", msg.msgID, msg.lvlOne);
    memset(outBuf, 0, sizeof(outBuf));
    t_inBuf = (char *)&buf;
    t_outBuf = outBuf;
    inBufLen = strlen(buf);
    outBufLen = MAXBUF;
    if ((rc = iconv(conv, &t_inBuf, &inBufLen, &t_outBuf, &outBufLen)) < 0)
    {
      errStr = strerror(errno);
      printf("Error iconv(): %s\n", errStr);
      break;
    }
    if (fwrite(outBuf, strlen(outBuf), 1, fh) < 0)
    {
      printf("Error writing to %s\n", path);
      rc = -1;
      break;
    }
    memcpy(&rtvOpt, "*NEXT     ", sizeof(rtvOpt));
    memcpy(&msgID, &rcvr.fmt300.Message_ID, sizeof(msgID));
  }
  if (fh) fclose(fh);
  return rc;
}

int msgAPI(msgRcvr_t *rcvr, char *msgID, char *qualName,
  char *replacementData, int lenRplcData, char *rplcSubVals, char *rtvOpt)
{
  char useReplacementData[10];
  errorStruct_t error;
  memset(&error, 0, sizeof(error));
  error.error.Bytes_Provided = sizeof(error);
  memset(useReplacementData, ' ', sizeof(useReplacementData));
  memcpy(useReplacementData, "*NO", 3);
  if (lenRplcData > 0)
    memcpy(useReplacementData, "*YES", 4);

  QMHRTVM((char *)rcvr, sizeof(*rcvr), "RTVM0300", msgID, qualName, replacementData,
    lenRplcData, useReplacementData, "*NO       ", &error, rtvOpt, 0, 0);
  if (error.error.Bytes_Available > 0)
  {
    /* set last error */
    return -1;
  }
  if (rcvr->fmt300.Bytes_Available == 0) /*end of msgf*/
    return 1;
  return 0;
}

static iconv_t iconv_init(int fromCCSID, int toCCSID)
{
  char fromCode[33];
  char toCode[33];
		iconv_t	result;

  memset(fromCode, 0, sizeof(fromCode));
  memset(toCode, 0, sizeof(toCode));
  sprintf(fromCode, "IBMCCSID%.5d0000000", fromCCSID);
  sprintf(toCode, "IBMCCSID%.5d", toCCSID);

		result = iconv_open(toCode, fromCode);

  return result;

}

static char *trimr(char *field, int fieldLen)
{
  char *cp, *sp;
  cp = malloc(fieldLen+1);
  memset(cp, 0, fieldLen+1);
  memcpy(cp, field, fieldLen);
  sp = cp;
  cp = cp + fieldLen - 1;
  while (*cp == ' ' && cp > sp)
  {
    *cp = 0;
    cp--;
  }
  return sp;
}

char *tick(char *buf)
{
  int ticksFound = 0;
  char *buf1, *buf2;
  char p = '\'';
  buf2 = malloc(MAXBUF);
  memset(buf2, 0, MAXBUF);
  strcat(buf2, "'");
  if (strchr(buf, p))
  {
    ticksFound = 1;
    buf1 = strtok(buf, "'");
    do
    {
      strcat(buf2, buf1);
      strcat(buf2, "''");
    } while ((buf1 = strtok(NULL, "'")));
  }
  if (ticksFound)
  {
    buf2[strlen(buf2)-1] = 0;
    return buf2;
  }
  strcat(buf2, buf);
  strcat(buf2, "'");
  return buf2;
}


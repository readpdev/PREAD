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

#define IMPORT 0
#define EXPORT 1
#define MAXBUF 4096

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

static int importMsgf(char *msgf, char *msgfLib, char *path);
static int exportMsgf(char *msgf, char *msgfLib, char *path, iconv_t iconv);
int msgAPI(msgRcvr_t *rcvr, char *msgID, char *qualName,
  char *replacementData, int lenRplcData, char *rplcSubVals, char *rtvOpt);
static iconv_t iconv_init(int fromCCSID, int toCCSID);
static char *trimr(char *, int);
static char *tick(char *);

void main(int argc, char *argv[])
{
  char msgfLib[11], msgf[11], path[257];
  int fromCCSID, toCCSID, rc, operFlag = -1;
  iconv_t conv;
  char syscmd[256];

  if (argc < 6)
  {
    printf("Usage: {imp | exp}msgf ('library', 'msgf', From CCSID, To CCSID, \
                   IFS Path, Operation Flag [0=Import | 1=Export])\n");
    return;
  }

  rc = 0;
  memset(&msgfLib, 0, sizeof(msgfLib));
  memset(&msgf, 0, sizeof(msgf));
  memset(&path, 0, sizeof(path));
  memset(&fromCCSID, 0, sizeof(fromCCSID));
  memset(&toCCSID, 0, sizeof(toCCSID));
  memcpy(&msgf, argv[1], 10);
  memcpy(&msgfLib, argv[2], 10);
  memcpy(&fromCCSID, argv[3], sizeof(fromCCSID));
  memcpy(&toCCSID, argv[4], sizeof(toCCSID));
  sprintf(path, "%s", trimr(argv[5], strlen(argv[5])));
  memcpy(&operFlag, argv[6], sizeof(operFlag));
  conv = iconv_init(fromCCSID, toCCSID);
  if (conv.cd == 0)
  {
    printf("CCSID convertion from %i to %i is invalid.\n",
      fromCCSID, toCCSID);
    exit(1);
  }
  if (operFlag == IMPORT)
  {
    sprintf(syscmd, "chgjob ccsid(%i)", toCCSID);
    if (system(syscmd))
    {
      printf("Error setting job CCSID to %i.\n", toCCSID);
      exit(1);
    }
    rc = importMsgf(msgf, msgfLib, path);
  }
  if (operFlag == EXPORT)
    rc = exportMsgf(msgf, msgfLib, path, conv);
		iconv_close(conv);
  sprintf(syscmd, "%s", "chgjob ccsid(*sysval)");
  if (operFlag == IMPORT && system(syscmd))
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

  if (!(fh = fopen(path, "r")))
  {
    printf("Error opening %s\n", path);
    perror(strerror(errno));
    return -1;
  }
  fgets(buf, MAXBUF-1, fh); /* Throw away first record....header */
  while (fgets(buf, MAXBUF-1, fh))
  {
    /* Update the message description */
    memset(&msg, ' ', sizeof(msg));
    strcpy(msg.msgID, strtok(buf, "\t"));
    sprintf(msg.lvlOne, "%s", strtok(NULL, "\t"));
    sprintf(msg.lvlTwo, "%s", strtok(NULL, "\t"));
    if (msg.lvlTwo[strlen(msg.lvlTwo)-1] == 0x25)
      msg.lvlTwo[strlen(msg.lvlTwo)-1] = ' ';
    sprintf(syscmd, "chgmsgd msgid(%s) msgf(%s/%s) msg(%s) seclvl(%s) ccsid(65535)",
      msg.msgID, trimr(msgfLib, strlen(msgfLib)), trimr(msgf, strlen(msgf)),
      tick(msg.lvlOne), tick(msg.lvlTwo));
    if ((rc = system(syscmd)))
    {
      printf("Error updating message: %s\n", msg.msgID);
      if (errCnt++ > 5) break;
    }
  }
  fclose(fh);
  return rc;
}

static int exportMsgf(char *msgf, char *msgfLib, char *path, iconv_t conv)
{
  FILE *fh;
  char qualName[21], rtvOpt[10], msgID[7], *errStr, buf[MAXBUF], outBuf[MAXBUF];
  uchar *t_inBuf, *t_outBuf;
  int rc;
  uint inBufLen, outBufLen;
  msgRcvr_t rcvr;
  msgIO_t msg;
  Qmh_Rmfa_RMFA0100_t msgfAttr;
  errorStruct_t errorCode;

  rc = 0;
  memset(&msgID, ' ', sizeof(msgID));
  memcpy(&rtvOpt, "*FIRST    ", sizeof(rtvOpt));
  sprintf(qualName, "%.10s%.10s", msgf, msgfLib);
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
  sprintf(buf, "%s\t%s\t%s\r\n",
    trimr(msgfAttr.Message_File_Name, sizeof(msgfAttr.Message_File_Name)),
    trimr(msgfAttr.Message_File_Library, sizeof(msgfAttr.Message_File_Library)),
    trimr(msgfAttr.Text_Description, sizeof(msgfAttr.Text_Description)));
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
    sprintf(buf, "%s\t%s\t%s\r\n", msg.msgID, msg.lvlOne, msg.lvlTwo);
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

static char *tick(char *buf)
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


      /*%METADATA                                                     */
      /* %TEXT Conversation Test App                                  */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <errno.h>

#define MAX_FB 256

void doupper(char *buffer);
void trimr(char *buffer, int buflen)

void main(int argc, char *argv[])
{
  int i, rc, sd;
  FILE *fp;
  char inputFile[25] = "cnvtst.ini";
  struct sockaddr_in sa;
  char fileBuf[256];
  char *configData[4] = {"PORT", "USER", "SERVER", "PASS"};

  if (argc < 2)
  {
    printf("Usage: call convtest testDescription inputFile(optional, default=con
    return;
  }
  /* open test script file */
  /* if input file name not passed default to convtest.ini */
  if (argc == 3)
  {
    memset(&inputFile, 0, sizeof(inputFile));
    memcpy(&inputFile, argv[3], strlen(argv[3]));
  }
  fp = open(inputFile, "r");
  if (fp == NULL)
  {
    printf("Error opening %s\n", inputFile");
    return;
  }
  /* configure socket stuff */
  sd = socket(AF_INET, SOCK_STREAM, 0);
  if (sd <= 0)
  {
    printf("Error creating socket descriptor.\n");
    return;
  {
  /* fetch server setting information */
  gets(fileBuf, 256, fp);
  doupper(fileBuf);
  if (memcmp(fileBuf, "[CONFIG]", 8);
  {
    printf("[CONFIG] section must appear at top of config file.\n");
    return;
  }
  for (i = 0; i < 4; i++)
  {
    gets(fileBuf, MAX_FB, fp);
    doupper(fileBuf);
    for (i2 = 0; i2 < 4; i++)
    {
      if (!memcmp(fileBuf, configData[i2], strlen(configData[i2]))
      {
        switch (i2)
        {
          case 0:

            break;
        }
        break;
      }
    }
    if (!memcmp(fileBuf, "SERVER=", 7))
    {
      fileBuf = fileBuf + 7;
      sa.sin_addr.s_addr = inet_addr(strcpy(fileBuf, fileBuf));
    }
    if (!memcmp(fileBuf, "PORT=", 5))
    {
    }
    if (!memcmp(fileBuf, "USER=", 5))
    {
    }
    if (!memcmp(fileBuf, "PASS=", 5))
    {
    }
  }
  doupper(fileBuf);
  memset(&sa, 0, sizeof(sa));
  sa.sin_family = AF_INET;
  sa.sin_port = atoi(port);
  rc = connect(sd, (struct sockaddr *)&sa, sizeof(sa));
  if (rc > -1)
  }
  return;
}

void doupper(char *buffer)
{
  int i;
  trimr(buffer, 50);
  for (i = 0; i < strlen(buffer); i++)
    buffer[i] = toupper(buffer[i]);
  return;
}

void trimr(char *buffer, int buflen)
{

  char *cp;
  cp = buffer+buflen;
  while (*cp-- == ' ' && cp && cp != 0)
    *cp = 0;
  return;
}

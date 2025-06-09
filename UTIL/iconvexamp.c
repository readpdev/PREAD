#include <stdio.h>
#include <string.h>
#include <iconv.h>

struct fromCode_t
{
   char IBMConst[8];
   char CCSID[5];
   char ConvAlt[3];
   char SubAlt;
   char ShiftAlt;
   char InputLen;
   char ErrOptMixed;
   char Reserved[12];
} fromCode;

struct toCode_t
{
   char IBMConst[8];
   char CCSID[5];
   char Reserved[19];
} toCode;

int main()
{

   iconv_t myIconv;
   char inBuf[50] = "This is a test";
   char outBuf[5];
   unsigned int rc, inBytesLeft = 0, outBufLeft;

   memcpy(fromCode.IBMConst, "IBMCCSID", 8);
   memcpy(fromCode.CCSID, "00037", 5);
   memcpy(fromCode.ConvAlt, "102", 3);
   fromCode.SubAlt = '0';
   fromCode.ShiftAlt = '0';
   fromCode.InputLen = '1';
   fromCode.ErrOptMixed = '0';
   memset(&fromCode.Reserved, 0x00, sizeof(fromCode.Reserved));

   memcpy(toCode.IBMConst, "IBMCCSID", 8);
   memcpy(toCode.CCSID, "00273", 5);
   memset(&toCode.Reserved, 0x00, sizeof(toCode.Reserved));

   myIconv = iconv_open((char *)&toCode, (char *)&fromCode);

   outBufLeft = strlen(inBuf);
   rc = iconv(myIconv, (char **)&inBuf, &inBytesLeft, (char **)&outBuf, &outBufL

  return 0;

}

      /*%METADATA                                                     */
      /* %TEXT Display spool files > 1M                               */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<quscrtus.h>
#include<qusptrus.h>
#include<qusdltus.h>
#include<qusec.h>

int main(void)
{
  char UserSpaceName[20] = "DSPLRGSPLFQTEMP     ";
  char ExtAttr[10];
  int InitSize = 1024;
  char InitVal = 0x00;
  char PubAuth[10];
  char Description[50] = "Spool files on system.";
}

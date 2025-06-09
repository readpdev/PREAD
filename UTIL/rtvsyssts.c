#include<stdio.h>
#include<stdlib.h>
#include"QWCRSSTS.H"
#include"QUSEC.H"

Qwc_SSTS0200_t SysSts;
Qus_EC_t Error;

void main(int argc, char *argv[])
{
  QWCRSSTS(&SysSts, sizeof(SysSts), "SSTS0200", "*NO       ", &Error);
  __itoa(SysSts.Pct_System_ASP_used, argv[1], 10);
  return;
}

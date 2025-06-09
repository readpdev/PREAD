      /*%METADATA                                                     */
      /* %TEXT Display program source                                 */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<qclrpgmi.h>
#include<qusec.h>

void main(int argc, char *argv[])
{
  Qcl_PGMI0100_t p100;
  Qus_EC_t qerr;
  char name[20];

  if (argc < 2)
  {
    printf("usage: dps [program or library/program]\n");
    return;
  }
  memcpy(&name, argv[1], sizeof(name));
  qerr.Bytes_Provided = sizeof(qerr);
  QCLRPGMI(&p100, sizeof(p100), "PGMI0100", name, &qerr);
  return;
}

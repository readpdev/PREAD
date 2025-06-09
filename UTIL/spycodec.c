      /*%METADATA                                                     */
      /* %TEXT Compress/Decompress Data                               */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <except.h>
#include <micomput.h>

#define OP_DCP       '0'
#define OP_CPR_TERSE '1'
#define OP_CPR_LZ1   '2'

/* Exception handler comm area type */
typedef int ehca_T;

/* System API error code structure */
typedef _Packed struct
{
  long bprv;
  long bavl;
  char excid[7];
  char rsv1;
} API_ERRCD_T;

/* Change Exception Message API */
#pragma linkage(QMHCHGEM,OS)
void QMHCHGEM (_INVPTR *,        /* Invocation pointer              */
               int,              /* Call stack counter              */
               unsigned int,     /* Message key                     */
               char *,           /* Modification option             */
               char *,           /* Reply text                      */
               int,              /* Reply text length               */
               ...);             /* Optional Parameter:             */
                                 /*   Error code                    */

/* Exception handler for MI exceptions */
void ExcpHdlr(_INTRPT_Hndlr_Parms_T *excp_info)
{
  API_ERRCD_T apierr;

  *((ehca_T *) excp_info->Com_Area) = -1;

  memset(&apierr, '\0', sizeof(apierr));
  apierr.bprv = sizeof(apierr);

  QMHCHGEM(&(excp_info->Target), 0, excp_info->Msg_Ref_Key,
           "*REMOVE   ", "", 0, &apierr);

  return;
}

int CompressData(_SPCPTR, int, _SPCPTR, int, char);
int DecompressData(_SPCPTR, _SPCPTR, int);

spycodec(char OpCode, _SPCPTR *SourceData, int SourceLen, _SPCPTR *TargetData,
  int TargetLenAvail, int *TargetLenActual)
{

  switch (OpCode)
  {
    case OP_DCP:
      *TargetLenActual = DecompressData(SourceData,
                                        TargetData, TargetLenAvail);
      break;
    case OP_CPR_TERSE:
    case OP_CPR_LZ1:
      *TargetLenActual = CompressData(SourceData, SourceLen,
                                      TargetData, TargetLenAvail,
                                      OpCode);
      break;
    default:
      *TargetLenActual = -1;
  }

  return 0;
}

int CompressData(_SPCPTR SourceData, int SourceLength,
                 _SPCPTR TargetData, int TargetLength,
                 char CompressMode)
{
  _CPRD_Template_T cprd;
  int ReturnLength;

  volatile ehca_T ehca = 0;
  #pragma exception_handler(ExcpHdlr, ehca, 0, _C2_MH_ESCAPE)

  memset(&cprd, '\0', sizeof(cprd));

  cprd.Source_Length = SourceLength;
  cprd.Result_Length = TargetLength;
  cprd.Algorithm = CompressMode - '0';
  cprd.Source = SourceData;
  cprd.Result = TargetData;

  _CPRDATA(&cprd);
  if (ehca)
    return ehca;

  return cprd.Compress_Length;
}

int DecompressData(_SPCPTR SourceData,
                   _SPCPTR TargetData, int TargetLength)
{
  _DCPD_Template_T dcpd;
  int ReturnLength;

  volatile ehca_T ehca = 0;
  #pragma exception_handler(ExcpHdlr, ehca, 0, _C2_MH_ESCAPE)

  memset(&dcpd, '\0', sizeof(dcpd));

  dcpd.Result_Length = TargetLength;
  dcpd.Source = SourceData;
  dcpd.Result = TargetData;

  _DCPDATA(&dcpd);
  if (ehca)
    return ehca;

  return dcpd.Decompress_Length;
}

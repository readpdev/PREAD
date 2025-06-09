      /*%METADATA                                                     */
      /* %TEXT Check Record Format Level                              */
      /*%EMETADATA                                                    */
/*********************************************************************
 *
 * Check record format level.
 *
 * Update record
 * /9081  6-10-04 GT  Converted to C
 *                    Added code to check for file/field CCSID change
 * /5635  5-11-04 GT  Added opcode (I=Install, V=Verify) parameter for
 *                    call compatibility (not used; never called for
 *                    verify)
 * /7343 10-21-02 PLR Counter issue when uprading within 8.x versions.
 *                    Added from and to versions...nothing done with parms in
 *                    this program. Just for consistency on call to 'chkpgm'.
 *        2-24-98 GT Program created
 *
 *********************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <qusec.h>
#include <qdbrtvfd.h>

#define ADDPTRO(p,o) ((void *)(((char *)(p))+(o)))

int chkIt(char *pOpCode, char *pFile, char *pRlsLib, char *pRstLib, char *pOldRl
  char *pNewRls, char *pRtnCode);
int getFD(char *pFile, char *pLib, void *pRcvr, int nRcvrLen);
int checkCCSID(Qdb_Qddfmt_t *pQddfmt1, Qdb_Qddfmt_t *pQddfmt2);

char pOpCode;
char pFile[10];
char pRlsLib[10];
char pRstLib[10];
char pOldRls[3];
char pNewRls[3];
char pRtnCode;

int chkIt(char *pOpCode, char *pFile, char *pRlsLib, char *pRstLib, char *pOldRl
  char *pNewRls, char *pRtnCode)
{

  char sRcvr1[65535], sRcvr2[65535];
  Qdb_Qddfmt_t *pQddfmt1, *pQddfmt2;

  static FILE *qsysprt;

  if (*pOpCode != 'I')
  {
    *pRtnCode = '0';
    return 0;
  }
  if (!qsysprt)
    qsysprt = fopen("*LIBL/QSYSPRT", "w, lrecl=132, recfm=fa");

  if (getFD(pFile, pRlsLib, sRcvr1, sizeof(sRcvr1)))
  {
    fprintf(qsysprt, "%c%.10s does not exist in %-.10s\n", ' ',pFile, pRlsLib);
    *pRtnCode = '1';
    return 0;
  }

  if (getFD(pFile, pRstLib, sRcvr2, sizeof(sRcvr2)))
  {
    fprintf(qsysprt, "%c%-.10s does not exist in %-.10s\n", ' ', pFile, pRstLib)
    *pRtnCode = '1';
    return 0;
  }

  pQddfmt1 = (Qdb_Qddfmt_t *) sRcvr1;
  pQddfmt2 = (Qdb_Qddfmt_t *) sRcvr2;

  /* Compare record format level */
  if (memcmp(pQddfmt1->Qddfseq, pQddfmt2->Qddfseq, sizeof(pQddfmt1->Qddfseq)))
  {
    fprintf(qsysprt, "%cFormat level different for %-.10s Old = %-.13s New = %-.
      ' ', pFile, pQddfmt1->Qddfseq, pQddfmt2->Qddfseq);
    *pRtnCode = '1';
    return 0;
  }

  /* Check the file CCSIDs */
  if (checkCCSID(pQddfmt1, pQddfmt2))
  {
    fprintf(qsysprt, "%c%-.10s CCSID mismatch.\n", ' ', pFile);
    *pRtnCode = '1';
    return 0;
  }

  *pRtnCode = '0';
  return 0;
}

int getFD(char *pFile, char *pLib, void *pRcvr, int nRcvrLen)
{
  char sQualFile[20], sRtnFile[20];
  Qus_EC_t stApiErrCd;

  stApiErrCd.Bytes_Provided = sizeof(stApiErrCd);

  memcpy(sQualFile, pFile, 10);
  memcpy(sQualFile+10, pLib, 10);

  QDBRTVFD(pRcvr, nRcvrLen, sRtnFile, "FILD0200", sQualFile,
           "*FIRST    ", "0", "*LCL      ", "*EXT      ", &stApiErrCd);
  if (stApiErrCd.Bytes_Available > 0)
    return -1;

  return 0;
}

int checkCCSID(Qdb_Qddfmt_t *pQddfmt1, Qdb_Qddfmt_t *pQddfmt2)
{
  int x;
  Qdb_Qddffld_t *pQddffld1, *pQddffld2;

  /* Compare the common CCSID flag */
  if (pQddfmt1->Qddflgs.Qddfrsid != pQddfmt2->Qddflgs.Qddfrsid)
    return -1;

  /*
   If both files have common CCSIDs, compare the values.
   Otherwise, compare the individual field CCSID values.
  */
  if (pQddfmt1->Qddflgs.Qddfrsid)
  {
    if (pQddfmt1->Qddfrcid != pQddfmt2->Qddfrcid)
      return -1;
  }
  else
  {
    pQddffld1 = ADDPTRO(pQddfmt1, sizeof(*pQddfmt1));
    pQddffld2 = ADDPTRO(pQddfmt2, sizeof(*pQddfmt2));

    for (x = 0; x < pQddfmt1->Qddffldnum; x++)
    {
      if (pQddffld1->Qddfcsid != pQddffld2->Qddfcsid)
        return x + 1;

      pQddffld1 = ADDPTRO(pQddffld1, pQddffld1->Qddfdefl);
      pQddffld2 = ADDPTRO(pQddffld2, pQddffld2->Qddfdefl);
    }
  }

  return 0;
}

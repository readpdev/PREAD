/*********************************************************************
 *
 * Contains functions for writing Spool file data using the IBM
 * Spooled File APIs.  Data is passed in QSPL-formatted records.
 *
 * Update record
 * 12-19-07 PLR
 * 11-30-07 EPG Formatting of some report data from MAG1077 to the userspace is
 *              sometimes incorrect. Specifically, when calculating the page
 *              offset for some reports containing advanced SCS data. An attempt
 *              was made to fix the problem at the onset without success.
 *              Monitored here for the known condition and reset the user space
 *              accordingly. T6606.
 *  4-09-05 JMO Cleaned up logic for setting the library list /9353
 *  9-03-04 JMO additional logic for embedded resources   /3465
 *  5-29-03 GT  Remove unnecessary casts from ADDPTRO statements /3465
 *  5-22-03 GT  Changed aSplHdl to array of pointers.            /8203
 *              Changed handle validation to use new functions.
 *              Added calls to MASPLAFP functions.
 *  8-31-02 GT  New.
 *
 *********************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <qusec.h>
#include <qspcrtsp.h>
#include <qspclosp.h>
#include <qspgetsp.h>
#include <qspputsp.h>
#include <qusrspla.h>
#include <qusrjobi.h>
#include <qlichgll.h>
#include <quschgus.h> /*6606*/

#include "masplio.h"
#include "masplutil.h"
#include "masplafp.h"
#include "masplafr.h"

#define LIB_ENT_SIZE 11

extern SPOOL_HANDLE_T *aSplfHdl[];

static int putSplfDta(int hSplf);
static int getCurLibList(int *nNbr_Libs, char *sLib_List);
static int setCurLibList(int nNbr_Libs, char *sLib_List, int nEntry_Len, int nInc_Rsc_Arc_Lib);

int createSplf(Qus_SPLA0200_t *pSplAtr)
{
  int hSplf;
  int rc;
  Qus_EC_t *pApiErrCd;
  Qsp_SPFRH_t *pSPFRH;
  int nNbr_Libs;
  char sCur_List[4096];

  /* Initialize error code */
  pApiErrCd = initSplErrCd();

  /* Get new spool file handle */
  if ((hSplf = newSplfHandle()) < 0)
    return hSplf;

  if ((rc = getCurLibList(&nNbr_Libs, sCur_List)) != SPL_OK)
    return SPL_ERR_SPLF_CREATE;

  /* prepare for AFP operations */
  INITAFPRS2();

  if ((rc = setCurLibList(pSplAtr->Nbr_Lib_Entries, pSplAtr->Lib_Entries, 10, 1)) != SPL_OK)
    return SPL_ERR_SPLF_CREATE;

  /* Create spooled file */
  QSPCRTSP(&aSplfHdl[hSplf]->hOpnSplf, pSplAtr, pApiErrCd);
  if (pApiErrCd->Bytes_Available > 0)
  {
    setCurLibList(nNbr_Libs, sCur_List, LIB_ENT_SIZE, 0);
    ENDAFPRS2();
    freeSplfHandle(hSplf);
    return SPL_ERR_SPLF_CREATE;
  }

  if ((rc = setCurLibList(nNbr_Libs, sCur_List, LIB_ENT_SIZE, 0)) != SPL_OK)
    return SPL_ERR_SPLF_CREATE;

  ENDAFPRS2();

  pSPFRH = aSplfHdl[hSplf]->pBlkHdr;
  memset(pSPFRH, 0, sizeof(*pSPFRH));
  pSPFRH->Header_Size = sizeof(*pSPFRH) - sizeof(pSPFRH->User_Data);
  SCOPY(pSPFRH->Struc_Level, "0200");
  MCOPY(pSPFRH->Spooled_File_Level, pSplAtr->File_Level);
  SCOPY(pSPFRH->Format_Name, "SPFR0200");
  SCOPY(pSPFRH->Info_Complete_Ind, "C");
  pSPFRH->Offset_First_Buffer = sizeof(*pSPFRH);
  pSPFRH->Buffers_Requested = SPL_BLK_SIZE;

  memcpy(aSplfHdl[hSplf]->pSplAtr, pSplAtr, pSplAtr->Bytes_Return);

  aSplfHdl[hSplf]->pSplBuf = NULL;
  aSplfHdl[hSplf]->nBufsInBlk = 0;
  aSplfHdl[hSplf]->nCurBlkBuf = 0;
  aSplfHdl[hSplf]->nPagNbr = 0;
  aSplfHdl[hSplf]->nPrevPgCont = 0;

  aSplfHdl[hSplf]->iHdlOpen = SPL_OPEN_WRT;
  aSplfHdl[hSplf]->iHdlInUse = 0;

  if (!SCOMP(pSplAtr->Ptr_Dev_Type, "*AFPDS"))
  {
    int rc;
    if ((rc = INITAFPPUT(hSplf)) != SPL_OK)
      return rc;
  }

  return hSplf;
}


int closeSplf(int hSplf)
{
  Qus_EC_t *pApiErrCd;
  int rc = SPL_OK;

  /* Initialize error code */
  pApiErrCd = initSplErrCd();

  if (!isOpenSplfHandle(hSplf, SPL_OPEN_ANY))
    return SPL_ERR_BAD_HANDLE;

  if (aSplfHdl[hSplf]->iHdlOpen == SPL_OPEN_WRT)
  {
    if (!SCOMP(aSplfHdl[hSplf]->pSplAtr->Ptr_Dev_Type, "*AFPDS"))
      rc = ENDAFPPUT(hSplf);

    if (aSplfHdl[hSplf]->nBufsInBlk > 0)
    {
      int rc2;
      if ((rc2 = putSplfDta(hSplf)) != SPL_OK)
      {
        if (rc == SPL_OK)
          rc = rc2;
      }
    }
  }

  QSPCLOSP(aSplfHdl[hSplf]->hOpnSplf, pApiErrCd);
  if (pApiErrCd->Bytes_Available > 0)
  {
    if (rc == SPL_OK)
      rc = SPL_ERR_SPLF_CLOSE;
  }

  freeSplfHandle(hSplf);

  return rc;
}


int putSplRcd(int hSplf, unsigned char *pSplRcd)
{
  int rc;

  Qus_SPLA0200_t *pSplAtr;
  Qsp_SPFRH_t *pSPFRH;
  Qsp_SPFRB_t *pSPFRB;
  Qsp_SPFRG_t *pSPFRG;
  Qsp_SPFRP_t *pSPFRP;
  unsigned char *pData;
  int fix1stBuf; /*T6705*/

  WSPXHDR_T *pSplRcdH;
  WSPXINFO_T *pSplRcdP;

  /* Initialize error code */
  initSplErrCd();

  if (!isOpenSplfHandle(hSplf, SPL_OPEN_WRT))
    return SPL_ERR_BAD_HANDLE;

  pSplAtr = aSplfHdl[hSplf]->pSplAtr;
  pSPFRH = aSplfHdl[hSplf]->pBlkHdr;

  pSplRcdH = (WSPXHDR_T *) (pSplRcd + pSplAtr->File_Buffer_Size - sizeof(*pSplRcdH));

  if (aSplfHdl[hSplf]->nBufsInBlk == 0)
  {
    pSPFRH->User_Space_Used = pSPFRH->Offset_First_Buffer;
    pSPFRH->Buffers_Returned = 0;
    aSplfHdl[hSplf]->pSplBuf = ADDPTRO(pSPFRH, pSPFRH->Offset_First_Buffer);
  }

  aSplfHdl[hSplf]->nBufsInBlk++;
  aSplfHdl[hSplf]->nCurBlkBuf++;
  pSPFRH->Buffers_Returned++;

  /* Set Buffer Informaton values */
  pSPFRB = aSplfHdl[hSplf]->pSplBuf;
  memset(pSPFRB, 0, sizeof(pSPFRB));
  pSPFRB->Length_Buffer_Info = sizeof(*pSPFRB);
  pSPFRB->Buffer_Number = aSplfHdl[hSplf]->nCurBlkBuf;

  pSPFRG = ADDPTRO(pSPFRB, sizeof(*pSPFRB));
  pSPFRB->Offset_General_Info = (char *) pSPFRG - (char *) pSPFRH;
  pSPFRB->Size_General_Info = sizeof(*pSPFRG);

  /* Set General Informaton values */
  if (pSplRcdH->chEndState == 0)
    SCOPY(pSPFRG->State, "*HOME");
  else if (pSplRcdH->chEndState == 1)
    SCOPY(pSPFRG->State, "*PAGE");
  else if (pSplRcdH->chEndState == 2)
    SCOPY(pSPFRG->State, "*GRAPHICS");
  else if (pSplRcdH->chEndState == 3)
    SCOPY(pSPFRG->State, "*PAGETRANS");
  else if (pSplRcdH->chEndState == 4)
    SCOPY(pSPFRG->State, "*HOMETRANS");
  else
    SCOPY(pSPFRG->State, "");

  pSPFRG->Nbr_Nonblank_Lines = pSplRcdH->nNonBlkLn;
  pSPFRG->Nonblank_Lines_Page1 = pSplRcdH->nNonBlkLn1;
  pSPFRG->Error_Buffer_Number = pSplRcdH->nPrevPgPrfRRN;
  pSPFRG->Offset_Error_Recovery = pSplRcdH->nPgPrfOfs;
  pSPFRG->Print_Data_Size = pSplRcdH->nLRSize;
  SETFLAG(*pSPFRG->Advanced_Print_Func, pSplRcdH->bAFPFile);
  SETFLAG(*pSPFRG->LAC_Array_in_Buffer, pSplRcdH->bLACInBuffer);
  SETFLAG(*pSPFRG->LAC_in_Any_Buffer, pSplRcdH->bLACInAnyBuffer);
  SETFLAG(*pSPFRG->LAC_in_Error_Info, pSplRcdH->bLACAtEndPage);
  SETFLAG(*pSPFRG->Error_Recovery_Info, pSplRcdH->bPgPrfExists);
  SETFLAG(*pSPFRG->Zero_Pages, pSplRcdH->bZeroPages);
  SETFLAG(*pSPFRG->Load_Font, pSplRcdH->bNewLoadFont);
  SETFLAG(*pSPFRG->IPDS_Data, pSplRcdH->bIPDS);

  if (pSplRcdH->nNbrPgStart > pSplRcdH->nNbrPgEnd ||
     (pSplRcdH->nNbrPgStart == pSplRcdH->nNbrPgEnd && aSplfHdl[hSplf]->nPrevPgCont))
    SETFLAG(*pSPFRG->Last_Page_Continues, 1);
  else
    SETFLAG(*pSPFRG->Last_Page_Continues, 0);

  pSPFRB->Length_Buffer_Info += pSPFRB->Size_General_Info;

  /* Set Page Data values */
  pSPFRP = ADDPTRO(pSPFRG, sizeof(*pSPFRG));
  pSPFRB->Offset_Page_Data = (char *) pSPFRP - (char *) pSPFRH;
  pSPFRB->Size_Page_Data = 0;
  pSPFRB->Number_Page_Entries = 0;
  pSPFRB->Size_Page_Entry = sizeof(*pSPFRP);

  pSplRcdP = SUBPTRO(pSplRcdH, sizeof(*pSplRcdP));

  fix1stBuf = 0;                                                  /*T6705*/
  if (pSplRcdP->nPageOfs == 0xFFFF && pSPFRB->Buffer_Number == 1) /*T6705*/
    fix1stBuf = 1;                                                /*T6705*/

  while(pSplRcdP->nPageOfs != 0xFFFF || fix1stBuf)  /*T6705*/
  {
    aSplfHdl[hSplf]->nPagNbr++;
    pSPFRB->Number_Page_Entries++;
    pSPFRB->Size_Page_Data += pSPFRB->Size_Page_Entry;

    pSPFRP->Text_Data_Start = pSplRcdP->nTxtDtaStart;
    pSPFRP->Any_Data_Start = pSplRcdP->nAnyDtaStart;
    pSPFRP->Page_Offset = pSplRcdP->nPageOfs;

    if (fix1stBuf)                                       /*T6705*/
    {                                                    /*T6705*/
      fix1stBuf = 0;                                     /*T6705*/
      pSPFRP->Text_Data_Start = 1;                       /*T6705*/
      pSPFRP->Any_Data_Start = 1;                        /*T6705*/
      pSPFRP->Page_Offset = 0;                           /*T6705*/
      pSplRcdP--;                                        /*T6705*/
      pSPFRP = ADDPTRO(pSPFRP, pSPFRB->Size_Page_Entry); /*T6705*/
      break;                                             /*T6705*/
    }                                                    /*T6705*/

    pSplRcdP--;
    pSPFRP = ADDPTRO(pSPFRP, pSPFRB->Size_Page_Entry);

  }

  pSPFRB->Length_Buffer_Info += pSPFRB->Size_Page_Data;
  if (pSPFRB->Number_Page_Entries == 0)
  {
    pSPFRB->Offset_Page_Data = 0;
  }

  /* Set Print Data values */
  pData = (unsigned char *) pSPFRP;
  pSPFRB->Offset_Print_Data = (char *) pData - (char *) pSPFRH;
  pSPFRB->Size_Print_Data = pSplRcdH->nLRSize;

  memcpy(pData, pSplRcd, pSPFRB->Size_Print_Data);

  pSPFRB->Length_Buffer_Info += pSPFRB->Size_Print_Data;

  /* Update Generic Header values */
  pSPFRH->User_Space_Used += pSPFRB->Length_Buffer_Info;

  /* Update handle values */
  aSplfHdl[hSplf]->iHdlInUse = 1;
  aSplfHdl[hSplf]->nPrevPgCont = GETFLAG(*pSPFRG->Last_Page_Continues);
  aSplfHdl[hSplf]->pSplBuf = ADDPTRO(pSPFRB, pSPFRB->Length_Buffer_Info);

  /* If the last buffer has been filled, write the block. */
  if (pSPFRH->Buffers_Requested == pSPFRH->Buffers_Returned)
  {
    if ((rc = putSplfDta(hSplf)) != SPL_OK)
      return rc;
  }

  return SPL_OK;
}


static int putSplfDta(int hSplf)
{
  Qus_EC_t *pApiErrCd;

  /* Initialize error code */
  pApiErrCd = initSplErrCd();

  QSPPUTSP(aSplfHdl[hSplf]->hOpnSplf, aSplfHdl[hSplf]->szUsQName, pApiErrCd);
  if (pApiErrCd->Bytes_Available > 0)
      return SPL_ERR_SPLF_PUT;

  aSplfHdl[hSplf]->pSplBuf = NULL;
  aSplfHdl[hSplf]->nBufsInBlk = 0;

  return SPL_OK;
}

/* retrieve the current library list     */
static int getCurLibList(int *nNbr_Libs, char *pLib_List)
{
  Qwc_JOBI0700_t *pJob_info;
  Qus_EC_t stErr;
  char sRcv_Var[4096];
  int nUsrLibOfs;
  char FormatName[9];
  char JobName[27];
  char JobId[17];

  strcpy(FormatName, "JOBI0700");
  memset(JobName,' ',26);
  JobName[26]=0;
  JobName[0]='*';
  memset(JobId,' ',16);
  JobId[16]=0;
  memset(&stErr, 0x00, sizeof(stErr));
  stErr.Bytes_Provided = sizeof(stErr);

  QUSRJOBI(&sRcv_Var, sizeof(sRcv_Var), FormatName, JobName, JobId, &stErr);
  if (stErr.Bytes_Available > 0)
    return SPL_ERR_SPLF_CREATE;

  pJob_info = (Qwc_JOBI0700_t *) &sRcv_Var;
  nUsrLibOfs = sizeof(Qwc_JOBI0700_t) + (pJob_info->Libs_In_Syslibl * LIB_ENT_SIZE) +
                (pJob_info->Prod_Libs * LIB_ENT_SIZE) + (pJob_info->Curr_Libs * LIB_ENT_SIZE);

  *nNbr_Libs = pJob_info->Libs_In_Usrlibl;
  memcpy(pLib_List, sRcv_Var + nUsrLibOfs, (pJob_info->Libs_In_Usrlibl * LIB_ENT_SIZE));

  return SPL_OK;
}

/* set the current library list    */
static int setCurLibList(int nNbr_Libs, char *pLib_List, int nEntry_Len, int nInc_Rsc_Arc_Lib)
{
  int i;
  char *sLibrary;
  char sRscArcLib[10];
  char sCmd[256];
  Qus_EC_t *pErr;

  if (nNbr_Libs > 0)
    runSysCmd("CHGLIBL LIBL(*NONE)");

  /* put the archived AFP resource library at the top of the library list */
  /*   if the flag is set                                                 */
  if (nInc_Rsc_Arc_Lib && GETRSCARCLIB(sRscArcLib) == SPL_OK)
  {
    sprintf(sCmd, "ADDLIBLE LIB(%.10s) POSITION(*FIRST)", sRscArcLib);
    runSysCmd(sCmd);
  }

  /* load the specified libraries to the user library list */
  for (i = 0; i < nNbr_Libs; i++)
  {
    sLibrary = pLib_List + (i * nEntry_Len);
    sprintf(sCmd, "ADDLIBLE LIB(%.10s) POSITION(*LAST)", sLibrary);
    runSysCmd(sCmd);
  }

  return SPL_OK;
}

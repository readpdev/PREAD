///////////////////////////////////////////////////////////////////////////////
// Module Name: Magps
// Description: translates the ps, eps or pdf files to text
// Created    : 06.09.00
// Author     : George Shanin
///////////////////////////////////////////////////////////////////////////////

#ifndef MAGPS_H_
#define MAGPS_H_

#include <dir.h>
#include <vector>
#include "SpyQuery.h"

using namespace std;

extern "C"
{
 int __declspec(dllexport) __stdcall TranslatePS(char *pCfgFlag, int *pCfgPages, char *SpoolFileName
 int __declspec(dllexport) __stdcall PSToPDF(char *SpoolFileName, char *PDFFileName);
 int __declspec(dllexport) __stdcall GetPDFPages(char *PDFFileName, char *TempFileName, int iFirstPa
}

/***********************************************************************************************/
/*                           GhostScript dll functions prototypes                              */
/***********************************************************************************************/
#define GSDLLAPI CALLBACK _export
#define PDF_DLL_NAME  "gsdll32.dll"

//GSDLL_STDIN    1     get count characters to str from stdin, return number of characters read
//GSDLL_STDOUT   2     put count characters from str to stdout, return number of characters written
//GSDLL_DEVICE   3     device str has been opened if count = 1, closed if count = 0
//GSDLL_SYNC     4     sync_output for device str
//GSDLL_PAGE     5     output_page for device str
//GSDLL_SIZE     6     resize for device str: LOWORD(count) is new xsize, HIWORD(count) is new ysize
//GSDLL_POLL     7     Called from gp_check_interrupt()
#define GSDLL_STDIN    1
#define GSDLL_STDOUT   2
#define GSDLL_DEVICE   3
#define GSDLL_SYNC     4
#define GSDLL_PAGE     5
#define GSDLL_SIZE     6
#define GSDLL_POLL     7

typedef int (GSDLL_CALLBACK) (int message, char *str, unsigned long count);
typedef int (GSDLLAPI GSDLL_REVISION) (char **product, char **copyright, long *gs_revision, long *gs
typedef int (GSDLLAPI GSDLL_INIT) (GSDLL_CALLBACK callback, HWND hwnd, int argc, char *argv[]);
typedef int (GSDLLAPI GSDLL_EXECUTE_BEGIN) (void);
typedef int (GSDLLAPI GSDLL_EXECUTE_CONT) (const char *str, int len);
typedef int (GSDLLAPI GSDLL_EXECUTE_END) (void);
typedef int (GSDLLAPI GSDLL_EXIT) (void);
typedef int (GSDLLAPI GSDLL_LOCK_DEVICE) (unsigned char *device, int flag);

struct Item
{
    long unsigned int x;	// x-coordinate
    long unsigned int y;	// y-coordinate
    std::string s;			// character string

    // Less-than operator for the sort routine. Note that we sort on
    // the y-coordinate first, then the x. Note also that we sort the
    // y-coordinate descending, and the x-coordinate ascending.
    Item& operator =( const Item& r ) { x = r.x; y = r.y; s = r.s; return *this; }
    int   operator <( const Item& r ) const { return (r.y == y) ? (x < r.x) : (r.y < y); }
};

struct coord
{
    long unsigned int yBeg;
    long unsigned int yEnd;
    long unsigned int cnt;
};

typedef std::vector< Item > Vector;

class GhostScriptDll
{
      HINSTANCE   m_hDll;

      char        m_sBuff[1024];
      FILE        *fp;
      bool        m_bWrite;

      long unsigned int idxItems;		// array index
      long unsigned int maxItems;		// max items array can hold
      long unsigned int lineDelta;	    // in 10ths of a point
      long unsigned int fieldDist;	    // in 10ths of a point

      Vector vItems;					// item array

      GSDLL_REVISION      *GSDLL_Revision;
      GSDLL_INIT          *GSDLL_Init;
      GSDLL_EXECUTE_BEGIN *GSDLL_ExecuteBegin;
      GSDLL_EXECUTE_CONT  *GSDLL_ExecuteCont;
      GSDLL_EXECUTE_END   *GSDLL_ExecuteEnd;
      GSDLL_EXIT          *GSDLL_Exit;
      GSDLL_LOCK_DEVICE   *GSDLL_LockDevice;

      int _fastcall ProcessInput(char *str);
      void _fastcall AllocItems( long unsigned int nSize );
      int _fastcall ScanLine( Item* p, char *str );
      std::string _fastcall ScanEscapedText( char* beg );
      void _fastcall SortItems();
      void _fastcall FormLines();
      void _fastcall OutputItems();

  public:
      char        m_sTxtFileName[MAXPATH+1];
      char        m_sSpoolFileName[MAXPATH+1];
      char        m_sPDFFileName[MAXPATH+1];
      char        m_sTempFileName[MAXPATH+1];
      char        m_cCfgFlag;
      int         m_iCfgPages;
      int         m_iPageCount;
      int         m_iRetStat;

      GhostScriptDll();
      ~GhostScriptDll();

      void _fastcall Init();

      int _fastcall PDFToTXT();
      int _fastcall PSToPDF();
      int _fastcall GetPDFPages(int iFirstPage, int iLastPage);
      int _fastcall ProcessDllMsg(int message, char *str, unsigned long count);
      int _fastcall ProcessDllMsgPSToTxt( int message, char *str, unsigned long count );
};

#endif

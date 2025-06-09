#ifndef __SPYCSWEB_H__
#define __SPYCSWEB_H__

#define WEBSTATUS_OK       'K'
#define WEBSTATUS_WARN     'W'
#define WEBSTATUS_ERROR    'E'

#define WEBLOGOUT_NORMAL   'N'
#define WEBLOGOUT_ABNORMAL 'A'
#define WEBLOGOUT_TIMEOUT  'T'

#define WEBDEFAULTMAXSESS   100
#define WEBDEFAULTTIMEOUT   600

#define WEBMAXLOGINCRITERIA 8

typedef _Packed struct
{
  char RequestType[10];
  char OpCode[10];
  char Reserved[4];
  char Data[1000];
} WEBREQUEST;

typedef _Packed struct
{
  char Status;
  char ErrorID[7];
  char Reserved[16];
  char Data[1000];
} WEBRESPONSE;

typedef _Packed struct
{
  char ErrorMsg[80];
} WEBERRORRESP;

typedef _Packed struct
{
  char SessionNbr[5];
  char SystemDTS[16];
} WEBSESSIONHANDLE;

typedef _Packed struct
{
  WEBSESSIONHANDLE SessionHandle;
  char AppID[10];
  char UserID[20];
  char GroupID[20];
  char SysProfile[10];
  char ClientIP[15];
  char SpyCSIntJobID[16];
  char SpyIMGIntJobID[16];
} WEBSESSION;

typedef _Packed struct
{
  char PromptText[20];
  char FieldLength[3];
  char DisplayValue;
  char AllowLowerCase;
} WEBLOGINCRITERIA;

typedef _Packed struct
{
  char AppID[10];
} WEBCONNECTRQS;

typedef _Packed struct
{
  char AppDesc[40];
  char LoginCriteriaCount[2];
  WEBLOGINCRITERIA LoginCriteria[WEBMAXLOGINCRITERIA];
} WEBCONNECTRESP;

typedef _Packed struct
{
  WEBSESSIONHANDLE SessionHandle;
  char AppID[10];
  char LoginVals[30 * WEBMAXLOGINCRITERIA];
  char PacketSize[5];
  char ClientIP[15];
} WEBLOGINRQS;

typedef _Packed struct
{
  WEBSESSIONHANDLE SessionHandle;
  char UserID[20];
  char GroupID[20];
  char SysProfile[10];
  char UserDesc[40];
  char DefaultView;
  char SpyFoldersEnabled;
  char SpyLinksEnabled;
  char OmniLinksEnabled;
} WEBLOGINRESP;

typedef _Packed struct
{
  char AppID[10];
  char UserID[20];
  char OldPwd[14];
  char NewPwd[14];
} WEBCHGPWDRQS;

typedef _Packed struct
{
  WEBSESSIONHANDLE SessionHandle;
  char ClientIP[15];
} WEBRECONNECTRQS;

typedef _Packed struct
{
  WEBSESSIONHANDLE SessionHandle;
} WEBRECONNECTRESP;

typedef _Packed struct
{
  WEBSESSIONHANDLE SessionHandle;
  char Status;
} WEBLOGOUTRQS;

typedef _Packed struct
{
  char AppID[10];
  char UserID[20];
  char ObjectType[10];
  char ObjectName[10];
  char ObjectLib[10];
  char IgnoreAccessError;
} WEBCFGPARMRQS;

typedef _Packed struct
{
  char AppID[10];
  char UserID[20];
  char ObjectType[10];
  char ObjectName[10];
  char ObjectLib[10];
  char DefaultView;
  char SpyFoldersEnabled;
  char SpyLinksEnabled;
  char OmniLinksEnabled;
  char ReportFormat[10];
  char LimitScroll;
} WEBCFGPARMRESP;

#endif	/* __SPYCSWEB_H__ */

      /*%METADATA                                                     */
      /* %TEXT TCP comm layer for SPYCS                               */
      /*%EMETADATA                                                    */
#ifndef __TCP_H__
#define __TCP_H__

typedef int SOCKET;
typedef struct
{
  char NodeID[18];
} TTCPInit;

int SendData(SOCKET Socket,char *Buffer, int Length);
int ReceiveData(SOCKET Socket,char *Buffer, int Length);
int Init(TTCPInit *pInitStruct);
int Cleanup();
int Confirm(SOCKET Socket);
int Confirmed(SOCKET Socket);
int Close(SOCKET Socket);
int GetLastError(char *szErrText, int Length);


#endif  /*#ifndef __TCP_H__*/

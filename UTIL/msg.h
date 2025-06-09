#ifdef __ILEC400__
  #pragma nomargins nosequence
  #pragma checkout(suspend)
#endif

#ifndef _MSG_H
#define _MSG_H

/*** START HEADER FILE SPECIFICATIONS ********************************/
/*                                                                   */
/* Header File Name: msg.h                                           */
/*                                                                   */
/* Descriptive Name: Interprocess communication (IPC) message queue  */
/*                   structures and prototypes                       */
/*                                                                   */
/* 5716-SS1  (C) Copyright IBM Corp. 1995,1995                       */
/* All rights reserved.                                              */
/* US Government Users Restricted Rights -                           */
/* Use, duplication or disclosure restricted                         */
/* by GSA ADP Schedule Contract with IBM Corp.                       */
/*                                                                   */
/* Licensed Materials-Property of IBM                                */
/*                                                                   */
/* Description: Include header file for interprocess communications  */
/*              message queue services.                              */
/*                                                                   */
/* Macros List:                                                      */
/*     MSG_NO_ERROR                                                  */
/*                                                                   */
/* Structure List:                                                   */
/*     msqid_ds                                                      */
/*                                                                   */
/* Function Prototype List:                                          */
/*     msgctl                                                        */
/*     msgget                                                        */
/*     msgrcv                                                        */
/*     msgsnd                                                        */
/*                                                                   */
/* Change Activity:                                                  */
/*                                                                   */
/* CFD List:                                                         */
/*                                                                   */
/* FLAG REASON       LEVEL DATE   PGMR      CHANGE DESCRIPTION       */
/* ---- ------------ ----- ------ --------- -----------------------  */
/* $A0= D9178700     3D60  941016 ROCH    : New include              */
/* $B1= D9776700     5D10  991205 ROCH    : Added datamodel pragma   */
/*                                                                   */
/* End CFD List.                                                     */
/*                                                                   */
/*  Additional notes about the Change Activity                       */
/*                                                                   */
/* End Change Activity.                                              */
/*                                                                   */
/*** END HEADER FILE SPECIFICATIONS **********************************/

/*********************************************************************/
/* Includes                                                          */
/*********************************************************************/

#include <sys/ipc.h>
#include <sys/types.h>

#pragma datamodel(P128)      /* @B1A*/

/*********************************************************************/
/* Constants                                                         */
/*********************************************************************/

#define MSG_NOERROR   010000 /* No error if big message 0x1000 */

/*********************************************************************/
/* Structures                                                        */
/*********************************************************************/

typedef unsigned int msgqnum_t; /* Used for number of msgs in a queue */
typedef unsigned int msglen_t;  /* Used for number of bytes in a queue */

/* Message queue information */
typedef struct msqid_ds {
  struct ipc_perm msg_perm;   /* Permissions */
  msgqnum_t       msg_qnum;   /* Number of messages currently on queue */
  msglen_t        msg_qbytes; /* Maximum number of bytes allowed on queue */
  pid_t           msg_lspid;  /* Process ID of last msgsnd() */
  pid_t           msg_lrpid;  /* Process ID of last msgrcv() */
  time_t          msg_stime;  /* Time of last msgsnd() */
  time_t          msg_rtime;  /* Time of last msgrcv() */
  time_t          msg_ctime;  /* Time of last change by msgctl() */
} msqid_ds_t;

/*********************************************************************/
/* Function Prototypes                                               */
/*********************************************************************/

#ifndef __QBFC_EXTERN
    #ifdef __ILEC400__
         #define QBFC_EXTERN extern
    #else
         #define QBFC_EXTERN extern "C"
    #endif

    #define __QBFC_EXTERN
#endif

QBFC_EXTERN int msgctl(int msqid, int cmd, struct msqid_ds *buf);
QBFC_EXTERN int msgget(key_t key, int msgflg);
QBFC_EXTERN int msgrcv(int msqid, void *msgp, size_t msgsz,
                       long int msgtyp, int msgflg);
QBFC_EXTERN int msgsnd(int msqid, const void *msgp, size_t msgsz,
                       int msgflg);

#pragma datamodel(pop)       /* @B1A*/

#endif /* _MSG_H */

#ifdef __ILEC400__
  #pragma checkout(resume)
#endif

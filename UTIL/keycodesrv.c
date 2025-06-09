      /*%METADATA                                                     */
      /* %TEXT Console based key code server.                         */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define BUFFERSIZE 1024

int lSocket, cSocket, rc;

void closeSockets(void);

int main(int argc, char *argv[])
{
   unsigned short uPort;
   char IOBuffer[BUFFERSIZE];
   struct sockaddr_in serveraddr;

   if (argc == 1 ¦¦ argc > 2 ¦¦ argv[1] == '\0')
   {
      printf("Usage: call keycodesrv 'PORT'\n");
      exit(-1);
   }
  uPort = atoi(argv[1]);

   lSocket = socket(AF_INET, SOCK_STREAM, 0);
   if (lSocket < 0)
   {
      printf("Error getting socket descriptor. Return code %d\n", &lSocket);
      exit(-1);
   }
   printf("socket descriptor created.\n");

   memset(&serveraddr, 0x00, sizeof(struct sockaddr_in));
   serveraddr.sin_family = AF_INET;
   serveraddr.sin_port =  htons(uPort);
   serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);
   rc = bind(lSocket, (struct sockaddr *) &serveraddr, sizeof(serveraddr));
   if (rc < 0)
   {
      printf("Error on bind. rc = %d\n", &rc);
      exit(-1);
   }
   printf("bind successful.\n");

   rc = listen(lSocket, 10);
   if (rc < 0)
   {
      printf("Error on listen. rc = %d\n", &rc);
      exit(-1);
   }
   printf("listen successful.\n");

   while (1)
   {
      cSocket = accept(lSocket, 0, 0);
      if (cSocket < 0)
      {
         printf("Error on accept. cSocket = %d\n", &cSocket);
         exit(-1);
      }

      rc = recv(cSocket, IOBuffer, BUFFERSIZE, 0);
      if (rc < 0)
      {
         printf("Error on recv. rc = %d\n", &rc);
         closeSockets();
         exit(-1);
      }

      if (memcmp(IOBuffer, "QUIT     ", 10))
         break;

   }

   closeSockets();
   return 0;

}

void closeSockets()
{
   close(lSocket);
   close(cSocket);
   return;
}

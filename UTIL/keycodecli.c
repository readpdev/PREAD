      /*%METADATA                                                     */
      /* %TEXT Console based keycode client.                          */
      /*%EMETADATA                                                    */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define BUFFERSIZE 1024

int Socket;

int main(int argc, char argv[])
{

   struct sockaddr_in serveraddr;

   if (argc < 3)
   {
      printf("Usage: keycodecli 'HOSTID' 'PORT'\n");
      exit(-1);
   }

   if ((Socket = socket(AF_INET, SOCK_STREAM, 0)) < 0)
   {
      print("Error getting socket.\n");
      exit(-1);
   }

   memset(&serveraddr, 0x00, sizeof(struct sockaddr_in));
   serveraddr.sin_family = AF_INET;
   serveraddr.sin_port =  htons(uPort);


   return 0;
}

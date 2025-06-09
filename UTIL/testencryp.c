#include <stdio.h>
#include <string.h>
#include "aes.h"
#include "testencryp.h"

unsigned char buffer[1024];
unsigned char digest[1024];

void encrypt(char *oneK)
{
  aes_context ctx;
  memset(&ctx, 0, sizeof(ctx));
  memset(digest, 0, sizeof(digest));
  memcpy(digest, "OPENTEXT87", 10);
  aes_set_key(&ctx, digest, 128);
  memset(buffer, 0, sizeof(buffer));
  strcpy(buffer, oneK);
  aes_encrypt(&ctx, buffer, buffer);
  memset(oneK, 0, 1024);
  memcpy(oneK, buffer, strlen(buffer));
  return;
}

void decrypt(char *oneK)
{
  aes_context ctx;
  memset(&ctx, 0, sizeof(ctx));
  memset(digest, 0, sizeof(digest));
  memcpy(digest, "OPENTEXT87", 10);
  aes_set_key(&ctx, digest, 128);
  strcpy(buffer, oneK);
  aes_decrypt(&ctx, buffer, buffer);
  memset(oneK, 0, 1024);
  memcpy(oneK, buffer, strlen(buffer));
  return;
}

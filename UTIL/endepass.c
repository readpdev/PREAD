#include <stdio.h>
#include <string.h>
#include "aes.h"
#include "endepass.h"

unsigned char buffer[32];
unsigned char digest[32];

void encryptPass(char *passWord)
{
  aes_context ctx;
  memset(&ctx, 0, sizeof(ctx));
  memset(digest, 0, sizeof(digest));
  memcpy(digest, "OPENTEXT87", 10);
  aes_set_key(&ctx, digest, 128);
  memset(buffer, 0, sizeof(buffer));
  strcpy(buffer, passWord);
  aes_encrypt(&ctx, buffer, buffer);
  memset(passWord, 0, 32);
  memcpy(passWord, buffer, strlen(buffer));
  return;
}

void decryptPass(char *passWord)
{
  aes_context ctx;
  memset(&ctx, 0, sizeof(ctx));
  memset(digest, 0, sizeof(digest));
  memcpy(digest, "OPENTEXT87", 10);
  aes_set_key(&ctx, digest, 128);
  strcpy(buffer, passWord);
  aes_decrypt(&ctx, buffer, buffer);
  memset(passWord, 0, 32);
  memcpy(passWord, buffer, strlen(buffer));
  return;
}

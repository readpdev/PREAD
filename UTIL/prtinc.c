      /*%METADATA                                                     */
      /* %TEXT Print incremented value x number of times              */
      /*%EMETADATA                                                    */
/* compile with SYSIFCOPT(*IFSIO) */
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define FALSE 0
#define TRUE  1

void main(int argc, char *argv[])
{
  FILE *fp;
  int increment, x, y, z;
  char ifsPath[256], ch[16];
  int quit = FALSE;
  div_t ans;

  increment = atoi(argv[1]);
  memset(ifsPath, 0, sizeof(ifsPath));
  memset(ch, 0, sizeof(ch));
  strcpy(ifsPath, argv[2]);
  fp = fopen(ifsPath, "r");
  if (!fp)
  {
    printf("Error opening %s\n", ifsPath);
    return;
  }
  x = 0;
  while (!fseek(fp, x++*increment, SEEK_SET) && !quit)
  {
    for (y = 0; y < sizeof(ch); y++)
      ch[y] = fgetc(fp);
    if (!memcmp(&ch, "\0\0\0\0\0", 5) || *((int *)ch) == 0xFFFFFFFF)
    {
      quit = TRUE;
      break;
    }
    printf("%.5d = ", (x-1) * increment);
    for (y = 0; y < sizeof(ch); y++)
    {
      printf("%.2X", ch[y]);
      if (++z == 4)
      {
        printf(" ");
        z = 0;
      }
    }
    printf("\n");
  }
  fclose(fp);
  return;
}

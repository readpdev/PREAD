#include<stdlib.h>
#include<time.h>

time_t ltime;
unsigned int seed;
int firstTime = 0;

int getRdm(int mod)
{
  if (!firstTime)
  {
    firstTime = 1;
    srand(time(0));
  }
  return rand()%mod+1;
}

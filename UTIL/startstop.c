      /*%METADATA                                                     */
      /* %TEXT Start and stop a timer...prints results                */
      /*%EMETADATA                                                    */
#include<stdio.h>
#include<time.h>

int main(void)
{
  time_t start;
  char pbuf[132];
  char go = 'Y';
  double diff;
  while(go == 'Y' || go == 'y')
  {
    printf("Press Enter to start the timer...\n");
    getchar();
    start = time(0);
    printf("Press Enter to stop the timer...\n");
    getchar();
    diff = difftime(time(0), start);
    printf("%.0f seconds.\n", diff);
    printf("\n");
    printf("Again? (y/n)\n");
    scanf("%c", &go);
    getchar();
  }
  return 1;
}

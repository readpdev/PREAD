#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<sys/stat.h>
#include<time.h>

#define MAXBUF 256

FILE *indexHdl, *exceptionHdl;
char inBuf[MAXBUF],saveBuf[MAXBUF], fileName[MAXBUF], workName[MAXBUF], *token;
int i, header = 0, exceptionCount = 0, everyHundred, drive, ch, totalFiles;
struct stat statBuf;

time_t ltime;
struct tm *newtime;

void main(int argc, char *argv[])
{
	if (argc < 4)
	{
		printf("Usage: fileScan indexFile outputExceptionFile driveLetter or \"strip\" (to ignore drive letter)");
		return;
	}

	indexHdl = fopen(argv[1], "r");
	if (!indexHdl)
	{
		printf("File %s not found.", argv[1]);
		return;
	}
				
	exceptionHdl = fopen(argv[2], "w");
	if (!exceptionHdl)
	{
		printf("Error opening %s", argv[2]);
		return;
	}

	if (strcmp("strip", argv[3]))
	  memcpy(&drive, argv[3], 1);

	fgets(inBuf, MAXBUF, indexHdl);
	strcpy(saveBuf, inBuf);
	while (!feof(indexHdl))
	{
		token = strtok(inBuf, ",");
		while (token = strtok(NULL, ",")) strcpy(fileName, token);
		memset(workName, 0, sizeof(workName));
		if (drive)
		{
			memcpy(workName, fileName+1, strlen(fileName) -3);
			memset(workName, drive, 1);
		}
		else
			memcpy(workName, fileName+3, strlen(fileName) -5);

		totalFiles++;

		if (!header)
		{
			header = 1;
			time(&ltime);
			newtime = localtime(&ltime);
			fprintf(exceptionHdl, "\n%s\nException Report for %s\n\n", asctime(newtime), argv[1]);
		}

		if (stat(workName, &statBuf))
		{
			exceptionCount++;
			fprintf(exceptionHdl,"%s",saveBuf);
		}
		
		if (++everyHundred >= 100)
		{
			for(i = 0; i < 80; i++) printf("\b\b");
			printf("%i files processed", totalFiles);
			everyHundred = 0;
		}

		fgets(inBuf, MAXBUF, indexHdl);
		strcpy(saveBuf, inBuf);
	}
	
	if (exceptionHdl)
	{
		fprintf(exceptionHdl, "\n%i files in exception\n", exceptionCount);
		fclose(exceptionHdl);
	}

	fclose(indexHdl);

	for(i = 0; i < 80; i++) printf("\b");
	printf("%i total files processed.", totalFiles);

        printf("\n%i file(s) in exception.\n", exceptionCount);
	if (exceptionCount > 0)
		printf("See report file %s.\n", argv[2]);

	return;
}

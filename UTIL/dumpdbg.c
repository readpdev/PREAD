#include<stdio.h>

void dumpDbg( char* psFilename, char* pBuffer, int nBufSize)
{
  FILE				*fp;
  char				szFilename[265];
  int				i, x = 0;
  char				szChars[20];

	 if( !pBuffer || !nBufSize )
		  return;

	 memset( szFilename, 0, sizeof(szFilename) );
	 if( psFilename )
		  strncat( szFilename, psFilename, sizeof(szFilename) );
	 else
		  strncat( szFilename, "dbgdump.txt", sizeof(szFilename) );

	 if( (fp=fopen(szFilename, "a+")) == NULL )
		 	return;

	 x = nBufSize%16;
	 for( i=0; i<nBufSize; i++ )
	 {
		  if( (i%16) == 0 )
		  {
			   fprintf( fp, "%5d-%05d    ", i, i+15 );
			   memset( szChars, 0, sizeof(szChars) );
		  }
		  fprintf( fp, "%02X ", (unsigned char)pBuffer[i] );
		  if( isalnum(pBuffer[i]) )
			   szChars[i%16] = (unsigned char)pBuffer[i];
		  else
			   szChars[i%16] = '.';
		  if( (i%16) == 15 )
		  {
		   	fprintf( fp, " %s\n", szChars );
		  }
	 }

	 if( x )
	 {
		  for( i=x; i<16; i++ )
		  {
			   fprintf( fp, "00 " );
			   szChars[i%16] = '.';
		  }
		  if( strlen(szChars) );
			   fprintf( fp, " %s\n", szChars );		
	 }
	 fprintf( fp, "\n" );
 	fclose( fp );
}


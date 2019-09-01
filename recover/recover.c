#include <stdio.h>
#include <stdlib.h>

void count(int*,int*,int*);

int main(int argc, char *argv[])
{
	if( argc !=2 )
	{
		fprintf( stderr, "Usage: ./recover image\n");
		return 1;
	}
	FILE *fraw = fopen( argv[ 1 ], "r");
	if( !fraw)
	{
		fprintf( stderr, "No open %s\n", argv[1]);
		return 2;
	}
	char rec[16];
	char buff[512];
	FILE *frec = NULL;
	int l = 0, m = 0, n = 0, o;
	while( (o = fread(&buff, 1, 512, fraw)) == 512 )
	{
		
		if(  buff[0] ==(char)  0xff  &&  buff[1] == (char) 0xd8  &&  buff[2] == (char) 0xff  &&  (buff[3] & (char) 0xe0) == (char)0xe0  )
		{	
			if( frec)
			{
				fclose( frec);
				count( &l, &m, &n );
			}
			sprintf( rec, "recover%i%i%i,jpg", l, m ,n);
			
			frec = fopen(rec, "w");
			if( !frec )
			{
				fclose( fraw);
				fprintf( stderr, "No open %s\n", rec);
				return 3;
			}
			fwrite( &buff, 512, 1, frec);
		}
		else if( frec )
		{
			fwrite( &buff, o, 1, frec);
		}
	}
	fclose(fraw);
	if( frec)
	fclose(frec);
	return 0;
}

void count(int *a, int *b, int *c)
{
	if( *b == 9 )
	{
		*b = 0;
		*a +=1;
	}
	else if( *c == 9)
	{
		*c = 0;
		*b +=1;
	}
	else
	{
		*c +=1;
	}
	return;
}
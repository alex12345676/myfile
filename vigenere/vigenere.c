#include <stdio.h>
#define PRINT_USAGE printf("Usage: ./vigenere keyword\n");
#include <string.h>
#include <ctype.h>
#define BUFFER_SIZE 256
char *ciphertext( char *s, char *key);

int main( int argc, char *argv[] )
{
    char input[BUFFER_SIZE];
    if( argc != 2)
    {
        PRINT_USAGE
        return 1;
    }
    for( int i = 0, len = strlen( argv[1] ); i < len; i++)
    {
        if( !isalpha( argv[1][i] ) )
        {
            PRINT_USAGE
            return 2;
        }

    }
    printf( "plaintext:  "  );
    fgets( input, BUFFER_SIZE, stdin );
    printf( "ciphertext: %s\n", ciphertext( input, argv[1] ) );

}
char *ciphertext( char *s, char *key)
{
    for( int i = 0, len = strlen( s ), len2 = strlen( key ), j = 0; i < len; i++, j++)
    {
        if( isalpha( s[ i ] ) )
        {
            if( ( len > len2 ) && ( j < len2))
            {
                if( isupper( s[ i ] ) )
                {
                    if( isupper(key[ j ] ))
                    {
                        s[i] = ( s[ i ] + key[ j ] - 'A')%26 + 'A';
                    }
                    else
                    {
                        s[ i ] = ( s[ i ] + key[ j ] - 'a')%26 + 'A';
                    }
                }
                else
                {
                    if( isupper(key[ j ] ))
                    {
                         s[i] = ( s[ i ] + key[ j ] - 'A')%26 + 'a';
                    }
                    else
                    {
                        s[ i ] = ( s[ i ] + key[ j ] - 'a')%26 + 'a';
                    }
                }
            }
            else if( j == len2 )
            {
                j = 0;
                if( isupper( s[ i ] ) )
                {
                    if( isupper(key[ j ] ))
                    {
                        s[i] = ( s[ i ] + key[ j ] - 'A')%26 + 'A';
                    }
                    else
                    {
                        s[ i ] = ( s[ i ] + key[ j ] - 'a')%26 + 'A';
                    }
                }
                else
                {
                    if( isupper(key[ j ] ))
                    {
                         s[i] = ( s[ i ] + key[ j ] - 'A')%26 + 'a';
                    }
                    else
                    {
                        s[ i ] = ( s[ i ] + key[ j ] - 'a')%26 + 'a';
                    }
                }
            }
            else
            {
                if( isupper( s[ i ] ) )
                {
                    if( isupper(key[ j ] ))
                    {
                        s[i] = ( s[ i ] + key[ j ] - 'A')%26 + 'A';
                    }
                    else
                    {
                        s[ i ] = ( s[ i ] + key[ j ] - 'a')%26 + 'A';
                    }
                }
                else
                {
                    if( isupper(key[ j ] ))
                    {
                         s[i] = ( s[ i ] + key[ j ] - 'A')%26 + 'a';
                    }
                    else
                    {
                        s[ i ] = ( s[ i ] + key[ j ] - 'a')%26 + 'a';
                    }
                }
            }
        }
        else
        {
            j--;
        }
    }
    return s;
}
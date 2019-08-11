#include <stdio.h>
#define PRINT_USAGE printf("Usage: ./vigenere keyword\n");
#include <string.h>
#include <ctype.h>
#define BUFFER_SIZE 256

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
    fgets( input, BUFFER_SIZE, stdin );

}
#include <stdio.h>
#define PRINT_USAGE printf("Usage: ./vigenere keyword\n");
#include <string.h>
#include <ctype.h>
#define BUFFER_SIZE 256

char *ciphertext( char *s, char *key);
char cipherchar( char a, char k);

int main( int argc, char *argv[] )
{
    char input[BUFFER_SIZE];
    if( argc != 2)//проверка на количество аргументов
    {
        PRINT_USAGE
        return 1;
    }
    for( int i = 0, len = strlen( argv[1] ); i < len; i++)
    {
        if( !isalpha( argv[1][i] ) ) //проверка на буквы ключа
        {
            PRINT_USAGE
            return 2;
        }

    }
    printf( "plaintext:  "  );
    fgets( input, BUFFER_SIZE, stdin );
    printf( "ciphertext: %s\n", ciphertext( input, argv[1] ) );

}
char *ciphertext( char *s, char *key) //зашифровка
{
    for( int i = 0, len = strlen( s ), len2 = strlen( key ), j = 0; i < len; i++, j++) // по длине текста
    {
        if( isalpha( s[ i ] ) ) // если буква на шифрование
        {
            if( ( len > len2 ) && ( j < len2)) // если длина ключевого слова меньше длины текста
            {
               s[ i ]  = cipherchar(s[ i ], key[ j ] );
            }
            else if( j == len2 ) // когда последний символ ключевого слова
            {
                j = 0;
                s[ i ]  = cipherchar(s[ i ], key[ j ] );
            }
            else
            {
                 s[ i ]  = cipherchar(s[ i ], key[ j ] );
            }
        }
        else
        {
            j--;
        }
    }
    return s;
}

char cipherchar( char a, char k) // зашифровка символа
{
 //   printf( " до зашифровки %c , %c \n", a, k);
     if( isupper( a ) ) // если большая буква
                {
                    if( isupper( k )) // если большая буква ключа
                    {
                        a = ( a - 'A' + k - 'A')%26 + 'A' ;
                    }
                    else
                    {
                        a = ( a -'A' + k - 'a')%26 +  'A' ;
                    }
                }
                else
                {
                    if( isupper(k ))// если большая буква ключевого слова
                    {
                         a = ( a -'a' + k - 'A')%26 + 'a';
                    }
                    else
                    {
                        a = ( a - 'a' + k - 'a')%26 + 'a';
                    }
                }
                 //printf( " зашифровки %c , %c \n", a, k);
    return a;
}
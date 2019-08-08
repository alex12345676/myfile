#include <cs50.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#define print_usage printf("Usage: ./caesar key\n");

//void print_usage(void); // Print message  of usage
int strtoint(string s); // convert string to integer

int main(int argc, string argv[])
{
    if ( argc != 2 ) // если аргументов меньше или больше 1 выходим  
    {
        print_usage;
        return 1;
    }
    for ( int i = 0, len = strlen( argv[1] )  ; i < len ; i++ )
    {    
        if ( !isdigit( argv[1][i] )) // если не число то выход
        {
            print_usage;
            return 2;
        }
    }
    string message = get_string( "Input message: ");
    int key = strtoint( argv[1]);
    for ( int i = 0, len = strlen( message ); i < len; i++) // преобразуем строку по символьно
    {
        if( isalpha( message[i] ))
        {
            if( isupper( message[i]) )
            {   
                 message[i] =  ( message[i] + key ) %  26 +'A';
            }
            else
            {
                message[i] = ( message[i] + key ) %  26 + 'a' ;
            }
         }
    }
    printf( "%s\n", message);
    return 0;
}

/*void print_usage()
{
    printf( "Usage: ./caesar key\n");
}
*/
int strtoint(string s )
{
    int count = 0;
    for ( int i = 0, len = strlen(s); i < len; i++) // получаем целое число из строки
    {
        if( isdigit( s[i] )) // проверка на цыфру
        {
            count *= 10;
            count += ( s[i] - '0');
        }
        else
        {
            return 0;
        }
    }
    return count;
}

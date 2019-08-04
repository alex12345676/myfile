#include <stdio.h>
//#include <cs50.h>

/**
 * Example:
 *
 * height = 4
 * width = height + 1
 *
 * ···## l1 3s 2h
 * ··### l2 2s 3h
 * ·#### l3 1s 4h
 * ##### l4 0s 5h

 */
char input[255];
int strlen(char *s)
{
	int res=0;
	while (s[res]!=0)
	{
		res++;
	}
	return res;
}
int strtoint (char *s)
{
    int sign=1,res=0;
//printf("\n%s\n",s); отладочный
    if ((s[0] >= '0') && (s[0]<='9')||(s[0]=='-'))
   {
		if(s[0]=='-')
		{
	   	 	sign=-1;
	    	s++;
		}
	
	  
	    for(int i=0; i <strlen(s);i++)
			if (strlen(s)>1)
{				
				res*=10;
	    		res+=((int)s[i]- 48);
}
			else
			{
				res=(int)s[i]- 48;
				return res*sign;
			}
		
	}
//printf("%i\n",res); отладочный
	return res*sign;
}

int get_int(char *lineOut)
{
    
    char *inp=&input;
    printf("%s",lineOut);
    gets(inp);
    return strtoint(inp);
}
void repeat(char c, int times)
{
    while (--times >= 0)
    {
        printf("%c", c);
    }
}

int main()
{
    int height, width;

    do
    {
        height = get_int("Height: ");
        width = height + 1;
//printf("\n%i\n",height); отладочный
    }
    while (height < 0 || height > 23);

    for (int i = 1; i <= height; i++)
    {
        int num_hashes = i + 1;
        int num_spaces = width - num_hashes;

        repeat(' ', num_spaces);
        repeat('#', num_hashes);

        printf("\n");
    }
}

#include<stdio.h>

char Input[256];
int strlen(char *s)
{
  int res=0;
  while(s[res]!=0)
  {
    res++;
  }
  return res;
}
float chartofloat(char *s)
{
  float res=0,ten=10;
  int sign=1;
  if((s[0]>=0)&&(s[0]<=9)||(s[0]==',')||(s[0]=='-'))
  {
    if(s[0]=='-')
    {
      sign=-1;
      s++;
    }
    for(int i=0; i<strlen(s);i++)
    {
      if((ten ==10)&&(s[i]!=','))
      {
        res*=ten;
        res+=(float)(s[i]-'0');
      }
      else if(s[i]==',')
      {
        ten=0,1;
        contunue;
      }
      else
      {
        
        res+=(s[i]-'0')*ten;
        ten/=10;
      }
    }
    
  } 
  return res;
}
float get_float(char *message)
{
  printf("%s",massage);
  gets(&Input);
  return chartofloat(Input);
}

int main()
{
  
}

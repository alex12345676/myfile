#include<stdio.h>
#include<math.h>

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
 // printf("\n%c\n",s[0]); //debag
  float res=0,ten=10;
  int sign=1,one=1;

  if((s[0]>='0')&&(s[0]<='9')||(s[0]==',')||(s[0]=='-'))
  {
    //  printf("\n%s\n",s);
    if(s[0]=='-')
    {
      sign=-1;
      s++;
    }
    for(int i=0; i<strlen(s);i++)
    {
      if((ten ==10)&&((s[i]!=',')||(s[i]!='.'))&&(s[i]>='0')&&(s[i]<='9'))
      {
        res*=ten;
        res+=(float)(s[i]-'0');
        //printf("\n%f\n",res);
      }
      else if((s[i]==',')||(s[i]=='.')&& one)
      {
        ten=0.1;
        one=0;
        //printf("\n%f\n",ten);
      }
      else if((s[i]>='0')&&(s[i]<='9'))
      {

        res+=(s[i]-'0')*ten;
        ten/=10;
        //printf("\n%.8f\n",res);
      }
      else
        return res*sign;
    }

  }
  return res*sign;
}
float get_float(char *message)
{
  printf("%s",message);
  gets(Input);

  return chartofloat(Input);
}

int main()
{
  float f=get_float("input float:  ");
  int ten_cent,fiften_cent,all_cents,cent,rub,fif_rub,ten_rub,tause_rub,fif_tause_rub,fiften_rub,sto_rub,dvest_rub,all_rub,patsot_rub,tu_rub;
  all_cents=(int)round(f*100);
  all_rub=all_cent/100;
  fif_tause_rub=all_rub/5000;
  tause_rub=all_rub%5000/1000;
  patsot_rub=all_rub%5000%1000/500;
  dvest_rub=all_rub%5000%1000%500/200;
  sto_rub=all_rub%5000%1000%500%200/100;
  fiften_rub=all_rub%5000%1000%500%200%100/50;
  ten_rub=all_rub%5000%1000%500%200%100%50/10;
  fif_rub=all_rub%5000%1000%500%200%100%50%10/5;
  tu_rub=all_rub%%5000%1000%500%200%100%50%10%5/2;
  rub=all_rub%%5000%1000%500%200%100%50%10%5%2;
  all_cent-=(all_rub*100);
  fiften_cent=all_cents/50;
  ten_cent=all_cents%50/10;
  cent=all_cents%50%10;
  printf("                    bumazhnie\n");
  printf(" 5000-: %i shtuk, 1000-: $i shtuk, 500-: %i shtuk\n 200-: %i shtuk, 100-: %i shtuk, 50-: %i shtuk\n",\
        fif_tause_rub,tause_rub,patsot_rub,dvest_rub,to_rub,fiften_rub);
  printf("                    monete\n");
  printf(" 10rub - %i, 5rub - %i, 2rub - %i, 1rub - %i\n",ten_rub,fif_rub,tu_rub,rub);
  printf("50 kopeek: %i shtuk; 10 kopeek: %i shtuk; 1 kopeek: %i shtuk\n",fiften_cent,ten_cent,cent) ;
}

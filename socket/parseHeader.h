#include <stdlib.h>
#include <string.h>

 char Len[64] = {0}; //global variable
 void restorebuf(char *buf);

int parseHead(char *buf)
{
	char *macet = "Content-Length:"; // Content-Length:
        char *response501 = "HTTP/1.1 501 Not Implemented"; //response 501
        char *response206 = "HTTP/1.1 206 Partial Content"; // response 206

	char *headLine ;
	if( headLine = strtok(buf, "\r\n"))
	{
                printf("%s\n",headLine);
        	if( !strcmp(headLine, "HTTP/1.1 200 OK"))
                {

                    restorebuf(buf);
                    for(int i = 1; headLine = strtok(NULL, "\r\n"); i++)
		    {
			for(int j = 0; j < 15; j++)
			{
				if( headLine[j] == macet[j] )
                                {
					if( j == 14)
                                        {

						strcpy(Len,&headLine[16]);
                                                restorebuf(buf);
                                                return 0;
                                         }
                                 }
                                 else
                                 {
                                     restorebuf(buf);
                                     break;
                                 }
                        }
		     }
                }
                else if( !strcmp(headLine, response206)) // if 206
                {
                     restorebuf(buf);
                     return 0;
                }
                else if( !strcmp(headLine, response501))  // if 501
                {
                     restorebuf(buf);
                     strcpy(Len, "15001");    // Len = 15000
                     return 0;
                }
                return 1;
	}

	return 1;
}
void restorebuf(char *buf) // restore buf
{
     int i = strlen(buf);
     buf[i] = '\r';
     buf[i + 1] = '\n';

}
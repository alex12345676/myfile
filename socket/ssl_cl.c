#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <malloc.h>
#include <sys/socket.h>
#include <resolv.h>
#include <netdb.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include "parseHeader.h"
#define FAIL    -1
int OpenConnection(const char *hostname, int port)
/*функция открывает соеденение */
{
    int sd;
    struct hostent *host;
    struct sockaddr_in addr;
    if ( (host = gethostbyname(hostname)) == NULL )
    {
        perror(hostname);
        abort();
    }
    /* проверяется и заполняется структура hostent */
    sd = socket(PF_INET, SOCK_STREAM, 0); // открывается socket
    bzero(&addr, sizeof(addr));   // обнуляется структура sockaddr
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = *(long*)(host->h_addr); // и заполняется
    if ( connect(sd, (struct sockaddr*)&addr, sizeof(addr)) != 0 )
    {
        close(sd);
        perror(hostname);
        abort();
    }
    /* соеденяется с сервером если возможно*/
    return sd;
}
SSL_CTX* InitCTX(void)
/*инициализация ssl ctx*/
{
    SSL_METHOD *method;
    SSL_CTX *ctx;
    OpenSSL_add_all_algorithms();  /* Load cryptos, et.al. Загрузка для всех протоколов*/
    SSL_load_error_strings();   /* Bring in and register error messages ввод и регистрация сообщений о ошибках*/
    method = TLSv1_2_client_method();  /* Create new client-method instance Создаем новый экземпляр метода клиента*/
    ctx = SSL_CTX_new(method);   /* Create new context создаем новый контент */
    if ( ctx == NULL )
    {
        ERR_print_errors_fp(stderr);
        abort();
    }
    return ctx;
}
void ShowCerts(SSL* ssl)
/* просмотр сертификата*/
{
    X509 *cert;
    char *line;
    cert = SSL_get_peer_certificate(ssl); /* get the server's certificate получерие сертификата с сервера*/
    if ( cert != NULL )
    {
        printf("Server certificates:\n");
        line = X509_NAME_oneline(X509_get_subject_name(cert), 0, 0);
        printf("Subject: %s\n", line);
        free(line);       /* free the malloc'ed string освобождение памяти */
        line = X509_NAME_oneline(X509_get_issuer_name(cert), 0, 0);
        printf("Issuer: %s\n", line);
        free(line);       /* free the malloc'ed string */
        X509_free(cert);     /* free the malloc'ed certificate copy */
    }
    else
        printf("Info: No client certificates configured.\n");
}


//char Len2[64]= {0};

int parseHead(char *buf); // parse head response
void restorebuf(char *buf);


char *itoa(int t, char s[], int rad)   // int to char *
{
    sprintf(s,"%i", t);
    return  s;
}

int main(int count, char *strings[])
{
    SSL_CTX *ctx;
    int server, lenint;
    SSL *ssl;
    char buf[510024];
    char url[5000];
    char acClientRequest[10024] = {0};
    int bytes;
    char *hostname, *portnum;
    if ( count != 3 )
    {
        printf("usage: %s <hostname> <portnum>\n", strings[0]);
        exit(0);
    }
    SSL_library_init();
    hostname=strings[1];
    portnum=strings[2];
    ctx = InitCTX();
    server = OpenConnection(hostname, atoi(portnum));
    ssl = SSL_new(ctx);      /* create new SSL connection stateсоздаем новое ssl соединение */
    SSL_set_fd(ssl, server);    /* attach the socket descriptor привязываем к socket дескриптору*/
    if ( SSL_connect(ssl) == FAIL )   /* perform the connection выполнить соеденение*/
        ERR_print_errors_fp(stderr);
    else
    {
        char acUrl[500] = {0};
        char FileName[500] = {0};
        char *pars[6] = {0};
        char BufparsingUrl[500] = {0};
        const char *cpReguestMessageGet = "GET %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: curl/7.58.0\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n";
        char *BufReply ; // буфер ответа
        printf("Enter head url  : ");
        scanf("%s",acUrl);
        strcpy( BufparsingUrl, acUrl);
        strcpy(url, acUrl);
        pars[0]=strtok(BufparsingUrl,"/");
        strcpy(FileName, pars[0]);
        for(int i = 1; pars[i]=strtok(NULL,"/"); i++)
        {
        	strcpy(FileName, pars[i]);
        }
        printf("\n\nConnected with %s encryption\n", SSL_get_cipher(ssl));
        ShowCerts(ssl);        /* get any certs */
        int allload ; // временная
        int headbyte ; // размер заголовка
        FILE *f = fopen(FileName, "w"); // открываем файл куда загружаем страницу
        if( !f) // если ошибка открытия
        {
        	printf( " No open %s\n", FileName);
        	goto out2;
        }
       	sprintf(acClientRequest, cpReguestMessageGet, url, strings[1]); // init get request in acClientRequest
       	if(!(bytes = SSL_write(ssl,acClientRequest, strlen(acClientRequest))) && (bytes == -1) )// write and if error exit
       	{
         	goto out;
                }
        do
        {	 	
        	bytes = SSL_read(ssl, &buf, sizeof(buf)); // read socket

        	//printf("%s", buf);
        	printf("read byte %i\n", bytes);
        	}
        while(!bytes  ); // if read 0 bytes
        if (bytes == -1) // if read error
        {
       		goto out; // exit
        }
                 
        int fl = parseHead(buf);     // flag parse
        if (fl) //if no 200 or 501 or 206
        {
                goto out; // exit
        }
		
        lenint = atoi(Len);     // size file
		
      	for( int i = 0; i < strlen(buf); i++) // loop parse head
       	{
       	       	if((buf[i] == '\n') && (buf[i + 1] == '\r') && (buf[i + 2] == '\n')) // if in buf empty string
               	 {
               		printf("headers byte %i\n", i + 3); // debug message
               		 headbyte = i+ 3; // size head
              		 break; // break loop
               	}
          }
          allload = bytes ;//- headbyte;
          BufReply = malloc(bytes);// выделяем память
          memcpy(BufReply, buf, bytes);// копируем
          while( (allload < lenint) || (SSL_pending(ssl) > 0))// пока не загрузится цикл
	  {
                 bytes = SSL_read(ssl, &buf, sizeof(buf)); // читаем
		 BufReply = realloc(BufReply, bytes + allload );// перевыделяем память
		 memcpy(BufReply + allload , buf, bytes);
		 allload +=bytes;
			
	  }
          for( int i = headbyte; i < allload; i++) // loop write file
          {
            	fputc(  BufReply[i], f ); // put char in file
          }
out:    fclose(f);
out2:	free(BufReply);

        SSL_free(ssl);        /* release connection state */
    }

    close(server);         /* close socket */
    SSL_CTX_free(ctx);        /* release context */
    return 0;
}


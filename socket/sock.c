#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

void error(const char *msg)
{
    perror(msg);
    exit(1);
}

int main(int argc, char *argv[])
{
    int sockfd, portno, n;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    char headers[255];
    char macheaders[] = "GET http://%s/%s HTTP/1.0\r\nHost: %s\r\nConnection: keep-alive\r\nPragma: no-cache\r\nCache-Control: no-cache\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0\r\n(Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nReferer: https://www.mail.ru\r\nAccept-Encoding: gzip, deflate, sdch, br\r\nAccept-Language: ru-RU,ru;q=0.8,es;q=0.6\r\nCookie: \r\n\r\n";
    char buffer[256];
    char *strbuf = buffer;
    if (argc < 3) {
       fprintf(stderr,"usage %s hostname port\n", argv[0]);
       exit(0);
    }

    // Задаем номер порта
    portno = atoi(argv[2]);

    // Создаем сокет
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0)
        error("ERROR opening socket");

    // Конвертирует имя хоста в IP адрес
    server = gethostbyname(argv[1]);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(1);
    }

    // Указываем тип сокета Интернет
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;

    // Указаваем адрес IP сокета
    bcopy((char *)server->h_addr,
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);

    // Указываем порт сокета
    serv_addr.sin_port = htons(portno);

    // Устанавливаем соединение
    if (connect(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0)
        error("ERROR connecting");

    // Вводим сообщение из консоли
    printf("Please enter the doc address in server\nexample: index.html\nenter : ");
    bzero(buffer, 256);
    fgets(buffer, 255, stdin);
    //убираем символ возврата строки
    buffer[strlen(buffer)-1] = 0;
    //открываем файл
    FILE *f = fopen(buffer, "wb");
    FILE *f2 = fopen("rec_msg", "w");
    if( !f)
    {
        close(sockfd);
        error("No open file");

    }
    //создаем строку запроса
    sprintf(headers,macheaders, argv[1], buffer, argv[1]);
    // Отправляем данные
    n = write(sockfd, headers, strlen(headers));
    printf("%i\n", n);
    if (n < 0)
         error("ERROR writing to socket");

    // Сбрасываем буфер
    bzero(buffer, 256);

    // Читаем ответ
    int flhead = 1, count = 0;
    while(n = read(sockfd, buffer, 255))
       {if (n < 0)
         error("ERROR reading from socket");
        if ( flhead)
        {
        for( int i = 0; i < n; i++)
        {   if((i + 3) <= n)
            {
                if( (buffer[i] == 0x0a)&&(buffer[i + 1] == 0x0d)&&(buffer[i + 2] == 0x0a))
                {
                    flhead = 0;
                    strbuf += (i + 3);
                    n -= (i + 3);
                    count = i + 3;
                    break;
                }
            }
            fputc(buffer[i], f2);
        }
        }
        if(!flhead)
        {
            fwrite( strbuf ,1, n, f);
        }
        if(count)
        {
            strbuf -= count;
            count = 0;
        }
        bzero(buffer, 256);
        }
    fclose(f2);
    fclose(f);
    close(sockfd);
    return 0;
}
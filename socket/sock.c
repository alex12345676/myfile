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
    exit(0);
}

int main(int argc, char *argv[])
{
    int sockfd, portno, n;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    char headers[] = "OPTIONS * HTTP/1.1\r\nHost: www.mail.ru\r\nConnection: keep-alive\r\nPragma: no-cache\r\nCache-Control: no-cache\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0\r\n(Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nReferer: https://www.mail.ru\r\nAccept-Encoding: gzip, deflate, sdch, br\r\nAccept-Language: ru-RU,ru;q=0.8,es;q=0.6\r\nCookie: \r\n\r\n";
    char buffer[256];
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
        exit(0);
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
    printf("Please enter the message: ");
    bzero(buffer, 256);
   // fgets(buffer, 255, stdin);

    // Отправляем данные
    n = write(sockfd, headers, strlen(headers));
    printf("%i\n", n);
    if (n < 0)
         error("ERROR writing to socket");

    // Сбрасываем буфер
    bzero(buffer, 256);

    // Читаем ответ
    n = read(sockfd, buffer, 255);
    if (n < 0)
         error("ERROR reading from socket");
    printf("%s\n", buffer);

    close(sockfd);
    return 0;
}
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
//#include <stdio.h>
//#include <stdlib.h>
//#include <unistd.h>
//#include <string.h>
//#include <sys/types.h>
//#include <sys/socket.h>
//#include <netinet/in.h>
#include <netdb.h>

int main(int argc, char *argv[]) {
	struct sockaddr_in stSockAddr;
        struct hostent *server;
	int i32Res, n;
        if (argc < 3) {
           fprintf(stderr,"usage %s hostname port\n", argv[0]);
           exit(0);
           }
	int i32SocketFD = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
        char headers[] = "GET / HTTP/1.1\r\n";
        char headers2[] ="Host: developer.mozilla.org\r\n";
        char headers3[] ="Connection: keep-alive\r\n";
        char headers4[] ="Pragma: no-cache\r\n";
        char headers5[] ="Cache-Control: no-cache\r\n";
        char headers6[] ="Upgrade-Insecure-Requests: 1\r\n";
        char headers7[] ="User-Agent: Mozilla/5.0(Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36\r\n";
        char headers8[] ="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n";
        char headers9[] ="Referer: https://developer.mozilla.org/\r\n";
        char headers10[] ="Accept-Encoding: gzip, deflate, sdch, br\r\n";
        char headers11[] ="Accept-Language: en-US,en;q=0.8,es;q=0.6\r\n";
        char headers12[] ="Cookie: \r\n\r\n";
        char buffer[10000];
	if (i32SocketFD == -1) {
		perror("Ошибка: невозможно создать сокет");
		return EXIT_FAILURE;
	}
        server = gethostbyname(argv[1]);
        if (server == NULL) {
                fprintf(stderr,"ERROR, no such host\n");
                exit(0);
        }
	memset(&stSockAddr, 0, sizeof (stSockAddr));

	stSockAddr.sin_family = PF_INET;
	stSockAddr.sin_port = htons(atoi(argv[2]));
         bcopy((char *)server->h_addr,
         (char *)&stSockAddr.sin_addr.s_addr,
         server->h_length);
	//i32Res = inet_pton(AF_INET, (char *)server->h_addr, &stSockAddr.sin_addr);

	//if (i32Res < 0) {
	//	perror("Ошибка: первый параметр не относится к категории корректных адресов");
	//	close(i32SocketFD);
	//	return EXIT_FAILURE;
	//} else if (!i32Res) {
	//	perror("Ошибка: второй параметр не содержит корректного IP-адреса");
	//	close(i32SocketFD);
	//	return EXIT_FAILURE;
	//}

	if (connect(i32SocketFD, (struct sockaddr*) &stSockAddr, sizeof (stSockAddr)) == -1) {
		perror("Ошибка: соединения");
		close(i32SocketFD);
		return EXIT_FAILURE;
	}

	/* выполнение операций чтения и записи ... */
        printf("Please enter the message: ");
        bzero(buffer, 10000);
      //  fgets(buffer, 10000, stdin);
        n = write(i32SocketFD, headers, strlen(headers));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
        printf("Please enter the message: ");
       /* bzero(buffer, 10000);
        fgets(buffer, 10000, stdin);  */
        n = write(i32SocketFD, headers2, strlen(headers2));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
          /*  printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin); */
        n = write(i32SocketFD, headers3, strlen(headers3));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
        /*  printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin);*/
        n = write(i32SocketFD, headers4, strlen(headers4));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
        /*  printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin); */
        n = write(i32SocketFD, headers5, strlen(headers5));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
       /*   printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin);*/
        n = write(i32SocketFD, headers6, strlen(headers6));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
        /*  printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin); */
        n = write(i32SocketFD, headers7, strlen(headers7));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
         /* printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin); */
        n = write(i32SocketFD, headers8, strlen(headers8));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
        /*  printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin);*/
        n = write(i32SocketFD, headers9, strlen(headers9));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
       /*   printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin); */
        n = write(i32SocketFD, headers10, strlen(headers10));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
       /*   printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin);   */
        n = write(i32SocketFD, headers11, strlen(headers11));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
        /*  printf("Please enter the message: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin); */
        n = write(i32SocketFD, headers12, strlen(headers12));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
    // Сбрасываем буфер
        bzero(buffer, 10000);
        for( int i=0; i < 1000000; i++)
        ;
        n = read(i32SocketFD, buffer, 9999);
        printf("%i\n", n);
        if (n < 0)
        {
         perror("ERROR reading from socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
         }
        printf("%s\n", buffer);
	shutdown(i32SocketFD, SHUT_RDWR);

	close(i32SocketFD);
	return 0;
}
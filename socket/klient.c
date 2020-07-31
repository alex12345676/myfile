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
        char *strheaders = "GET %s HTTP/1.1\r\nHost: %s\r\nAccept: */*\r\nConnection: keep-alive\r\nUser-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Mobile Safari/537.36\r\n\r\n";
        char headers[5000]= {0};
        char buffer[10000];
        char *outsocket;
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

	if (connect(i32SocketFD, (struct sockaddr*) &stSockAddr, sizeof (stSockAddr)) == -1) {
		perror("Ошибка: соединения");
		close(i32SocketFD);
		return EXIT_FAILURE;
	}

	/* выполнение операций чтения и записи ... */
        printf("Please enter the url: ");
        bzero(buffer, 10000);
        fgets(buffer, 10000, stdin);
        sprintf(headers, strheaders,buffer, argv[1]);
        n = write(i32SocketFD, headers, strlen(headers));
        printf("%i\n", n);
         if (n < 0)
         {
         perror("ERROR writing to socket");
         close(i32SocketFD);
	 return EXIT_FAILURE;
          }
    // Сбрасываем буфер
        bzero(buffer, 10000);
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
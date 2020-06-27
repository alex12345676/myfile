//#pragma once
#include <stdio.h>
#include <stdlib.h>
//#include <windows.h>
#include "strings.c"
#include "files.c"
#include "loadm3u8.c"
#include "down_vid.c"

char *gets(char *); // прототип финкции

int main(int argc, char** argv)

{
    char buf[556];
    //printf("Hello world!\n");
    if ((argc == 2) || (argc == 3)) // проверка аргументов
    {
      	FILE *tmp_m3u8,*fp_01; // указатели на файлы
    	char rash[5]; // массив расширения
    	char *url = argv[1]; // указатель на адресс
		char *o_name = "video.mp4"; // имя выходного файла
 		if(argc == 3)
 		{
			o_name = argv[2]; // если задано
    //printf(o_name);
 		}
 		else
 		{

			if (!(fp_01 = fopen(o_name, "r"))) // проверка на существование файла
			{
    			o_name = "video.mp4"; // то
			}
			else
			{
				do
				{
					fclose(fp_01); // закрываем открытый файл
   					printf("Name video.mp4 bussy\n Enter name out file - "); // сообщение о занятости имени файла по умолчанию
					o_name = fgets(buf, 555, stdin); // ожидание ввода имени файла
				}
				while ( !( fp_01 = fopen( o_name, "r" ) ) );
//	printf( "Name %s bussu\nEnter name out file - ", o_name );


			}


 		}
    	char *arg2=str_and_str("wget -c -w 1 -T 1", url); // treb free указатель на сумарную строку
    	char *arg3 = str_and_str(arg2, " -O ");
    	free(arg2);
    	arg2 = str_and_str(arg3, o_name);
    	free(arg3);
//    char* arg1="F:\\wget\\wget.exe";
   // printf(url);
    	for (int i = 4; i > 0; i-- )
    	{
        	rash[4-i] = url[strlen(url)-i]; // выделяем расширение
        }
    	rash[4] = 0;
    //printf(rash);
    	if ( !strcmp(rash,"m3u8") ) // при условии расширение м3у8
    	{
  //      printf("load m3u8\n");
        	tmp_m3u8 = load_m3u8(url); // загрузка файла м3у8
        	if (!(tmp_m3u8))
        	{
        	return 5;
        	}
        	down_vid(tmp_m3u8,url,o_name); // загрузка видео файла
        	fclose(tmp_m3u8); // закрываем файл
        	remove("tmp"); // удаляем тмп файл
    	}
    	else // иначе
    	{

  //  printf("load file\n");
 //  STARTUPINFO si;
//   PROCESS_INFORMATION pi;
//GetStartupInfo(&si);
   /*


    BOOL CreateProcess(

      LPCTSTR lpApplicationName,   имя программы

      LPTSTR lpCommandLine, параметры командной строки

      LPSECURITY_ATTRIBUTES lpProcessAttributes,   атрибуты безопасности процесса (имеет смысл только в NT/2000)

      LPSECURITY_ATTRIBUTES lpThreadAttributes,     атрибуты безопасности главного потока (имеет смысл только в NT/2000)

          BOOL bInheritHandles, если bInheritHandles == TRUE, то созданный процесс (запущенная программа), наследует дескрипторы (handles) запускающей программы

      DWORD dwCreationFlags,    параметры создания. Здесь можно указать класс приоритета создаваемого процесса и некоторые дополнительные параметры

      LPVOID lpEnvironment, указатель на блок окружения или NULL, тогда используется блок окружения родителя

      LPCTSTR lpCurrentDirectory,   текущая директория или NULL, тогда используется текущая директория родителя

      LPSTARTUPINFO lpStartupInfo,  указатель на структуру STARTUPINFO, которая определяет положение главного окна

      LPPROCESS_INFORMATION lpProcessInformation    сюда будет записана информация о созданном процессе

    );*/
 //   printf(arg2,"/n");
   			if (!system(arg2)) //( CreateProcess(arg1, arg2, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) загружаем сразу файл
    		{/*WaitForSingleObject(pi.hProcess,INFINITE);
    	CloseHandle(pi.hProcess);*/
    			free(arg2); // освобождаем распределенную память
     			printf("Bay, bay world!\n");
    		}
     		else // иначе несмогли скачать
     		{
         		printf("No, file wget \n or no greate procces wget\n or wget exit error\n"); // сообщение о ошибке
         		free(arg2); // освобождаем память
     		}

    	}

    	return 0;
    }

    printf("usage: down URL [out file] \n");
    return 0;
}/*


HINSTANCE ShellExecute(

    HWND hwnd,

    LPCTSTR lpOperation,

    LPCTSTR lpFile,

    LPCTSTR lpParameters,

    LPCTSTR lpDirectory,

    INT nShowCmd

);
hwnd


дескриптор родительского окна

lpOperation


строка, описывающая операцию: "open" - открытие (запуск), "print" - печать, "explore" - открыть окно с заданной папкой

lpFile


имя файла

lpParameters


параметры командной строки

lpDirectory


текущая директория для запускаемой программы

nShowCmd


параметр, указывающий, как будет показано приложение при открытии. Имеет тот же смысл, что и nCmdShow в WinMain

Пример открытия файла doc1.doc.








if((UINT)ShellExecute(

    NULL,

    "open",

    "doc1.doc",

    NULL,

    NULL,

    SW_SHOWNORMAL) <= 32) {

        // обработка ошибок

}




WINSHELLAPI BOOL WINAPI ShellExecuteEx(

    LPSHELLEXECUTEINFO lpExecInfo

);

typedef struct _SHELLEXECUTEINFO{

    DWORD cbSize;           // размер структуры

    ULONG fMask;            // маска, указывающая

    HWND hwnd;

    LPCTSTR lpVerb;         // команда

    LPCTSTR lpFile;         // имя файла

    LPCTSTR lpParameters;   // параметры командной строки

    LPCTSTR lpDirectory;    // текущая директория

    int nShow;              // параметр, указывающий, как будет показано приложение при открытии.

    HINSTANCE hInstApp;     // сюда будет записан hInstance приложения



    // Optional members

    LPVOID lpIDList;        // IDL, определяющий файл для выполнения

    LPCSTR lpClass;         // имя класса файла или GUID

    HKEY hkeyClass;         // дескриптор ключа в реестре для класса файла

    DWORD dwHotKey;         // горячая клавиша

    HANDLE hIcon;           // иконка для класса файла

    HANDLE hProcess;        // дескриптор процесса

} SHELLEXECUTEINFO, FAR *LPSHELLEXECUTEINFO;

Пример запуска notepad.exe:

SHELLEXECUTEINFO SHExecInfo;




ZeroMemory(&SHExecInfo, sizeof(SHExecInfo));



SHExecInfo.cbSize = sizeof(SHExecInfo);

SHExecInfo.fMask = SEE_MASK_NOCLOSEPROCESS;

SHExecInfo.nShow = SW_SHOWNORMAL;

SHExecInfo.lpFile = "notepad.exe";



if(!ShellExecuteEx(&SHExecInfo)) {

    // обработка ошибок

} */


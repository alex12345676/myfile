//#pragma once
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include "strings.c"
#include "files.c"
#include "loadm3u8.c"
#include "down_vid.c"


int main(int argc, char** argv)

{
    char buf[255];
    //printf("Hello world!\n");
    if((argc == 2) || (argc == 3))
    {
      FILE *tmp_m3u8,*fp_01;
    char rash[5];
    char* url=argv[1];

char *o_name;
 if(argc==3)
 {


    o_name=argv[2];
    //printf(o_name);
 }
 else
 {

if(!(fp_01=fopen("video.mp4", "r")))
{
    o_name="video.mp4";
}
else
{
   printf("Name video.mp4 bussy\n Enter name out file - ");
o_name=gets(buf);
fclose(fp_01);

}


 }
    char* arg2=str_and_str("wget.exe -c ",url);//treb free
//    char* arg1="F:\\wget\\wget.exe";
   // printf(url);
    for (int i=4; i>0; i-- )
        rash[4-i]=url[strlen(url)-i];
    rash[4]=0;
    //printf(rash);
    if ( !strcmp(rash,"m3u8") )
    {
  //      printf("load m3u8\n");
        tmp_m3u8=load_m3u8(url);
        down_vid(tmp_m3u8,url,o_name);
        fclose(tmp_m3u8);
        remove("tmp");
    }
    else
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
   if (!system(arg2)) //( CreateProcess(arg1, arg2, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
    {/*WaitForSingleObject(pi.hProcess,INFINITE);
    CloseHandle(pi.hProcess);*/
    free(arg2);
     printf("Bay, bay world!\n");
    }
     else
     {
         printf("No, file F:\\wget\\wget.exe \n or no greate procces wget\n or wget exit error\n");
         free(arg2);
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


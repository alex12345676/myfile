//#pragma once
#include <stdio.h>
#include <stdlib.h>
//#include <windows.h>
#include "strings.c"
#include "files.c"
#include "loadm3u8.c"
#include "down_vid.c"

char *gets(char *); // �������� �������

int main(int argc, char** argv)

{
    char buf[556];
    //printf("Hello world!\n");
    if ((argc == 2) || (argc == 3)) // �������� ����������
    {
      	FILE *tmp_m3u8,*fp_01; // ��������� �� �����
    	char rash[5]; // ������ ����������
    	char *url = argv[1]; // ��������� �� ������
		char *o_name = "video.mp4"; // ��� ��������� �����
 		if(argc == 3)
 		{
			o_name = argv[2]; // ���� ������
    //printf(o_name);
 		}
 		else
 		{

			if (!(fp_01 = fopen(o_name, "r"))) // �������� �� ������������� �����
			{
    			o_name = "video.mp4"; // ��
			}
			else
			{
				do
				{
					fclose(fp_01); // ��������� �������� ����
   					printf("Name video.mp4 bussy\n Enter name out file - "); // ��������� � ��������� ����� ����� �� ���������
					o_name = fgets(buf, 555, stdin); // �������� ����� ����� �����
				}
				while ( !( fp_01 = fopen( o_name, "r" ) ) );
//	printf( "Name %s bussu\nEnter name out file - ", o_name );


			}


 		}
    	char *arg2=str_and_str("wget -c -w 1 -T 1", url); // treb free ��������� �� �������� ������
    	char *arg3 = str_and_str(arg2, " -O ");
    	free(arg2);
    	arg2 = str_and_str(arg3, o_name);
    	free(arg3);
//    char* arg1="F:\\wget\\wget.exe";
   // printf(url);
    	for (int i = 4; i > 0; i-- )
    	{
        	rash[4-i] = url[strlen(url)-i]; // �������� ����������
        }
    	rash[4] = 0;
    //printf(rash);
    	if ( !strcmp(rash,"m3u8") ) // ��� ������� ���������� �3�8
    	{
  //      printf("load m3u8\n");
        	tmp_m3u8 = load_m3u8(url); // �������� ����� �3�8
        	if (!(tmp_m3u8))
        	{
        	return 5;
        	}
        	down_vid(tmp_m3u8,url,o_name); // �������� ����� �����
        	fclose(tmp_m3u8); // ��������� ����
        	remove("tmp"); // ������� ��� ����
    	}
    	else // �����
    	{

  //  printf("load file\n");
 //  STARTUPINFO si;
//   PROCESS_INFORMATION pi;
//GetStartupInfo(&si);
   /*


    BOOL CreateProcess(

      LPCTSTR lpApplicationName,   ��� ���������

      LPTSTR lpCommandLine, ��������� ��������� ������

      LPSECURITY_ATTRIBUTES lpProcessAttributes,   �������� ������������ �������� (����� ����� ������ � NT/2000)

      LPSECURITY_ATTRIBUTES lpThreadAttributes,     �������� ������������ �������� ������ (����� ����� ������ � NT/2000)

          BOOL bInheritHandles, ���� bInheritHandles == TRUE, �� ��������� ������� (���������� ���������), ��������� ����������� (handles) ����������� ���������

      DWORD dwCreationFlags,    ��������� ��������. ����� ����� ������� ����� ���������� ������������ �������� � ��������� �������������� ���������

      LPVOID lpEnvironment, ��������� �� ���� ��������� ��� NULL, ����� ������������ ���� ��������� ��������

      LPCTSTR lpCurrentDirectory,   ������� ���������� ��� NULL, ����� ������������ ������� ���������� ��������

      LPSTARTUPINFO lpStartupInfo,  ��������� �� ��������� STARTUPINFO, ������� ���������� ��������� �������� ����

      LPPROCESS_INFORMATION lpProcessInformation    ���� ����� �������� ���������� � ��������� ��������

    );*/
 //   printf(arg2,"/n");
   			if (!system(arg2)) //( CreateProcess(arg1, arg2, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) ��������� ����� ����
    		{/*WaitForSingleObject(pi.hProcess,INFINITE);
    	CloseHandle(pi.hProcess);*/
    			free(arg2); // ����������� �������������� ������
     			printf("Bay, bay world!\n");
    		}
     		else // ����� �������� �������
     		{
         		printf("No, file wget \n or no greate procces wget\n or wget exit error\n"); // ��������� � ������
         		free(arg2); // ����������� ������
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


���������� ������������� ����

lpOperation


������, ����������� ��������: "open" - �������� (������), "print" - ������, "explore" - ������� ���� � �������� ������

lpFile


��� �����

lpParameters


��������� ��������� ������

lpDirectory


������� ���������� ��� ����������� ���������

nShowCmd


��������, �����������, ��� ����� �������� ���������� ��� ��������. ����� ��� �� �����, ��� � nCmdShow � WinMain

������ �������� ����� doc1.doc.








if((UINT)ShellExecute(

    NULL,

    "open",

    "doc1.doc",

    NULL,

    NULL,

    SW_SHOWNORMAL) <= 32) {

        // ��������� ������

}




WINSHELLAPI BOOL WINAPI ShellExecuteEx(

    LPSHELLEXECUTEINFO lpExecInfo

);

typedef struct _SHELLEXECUTEINFO{

    DWORD cbSize;           // ������ ���������

    ULONG fMask;            // �����, �����������

    HWND hwnd;

    LPCTSTR lpVerb;         // �������

    LPCTSTR lpFile;         // ��� �����

    LPCTSTR lpParameters;   // ��������� ��������� ������

    LPCTSTR lpDirectory;    // ������� ����������

    int nShow;              // ��������, �����������, ��� ����� �������� ���������� ��� ��������.

    HINSTANCE hInstApp;     // ���� ����� ������� hInstance ����������



    // Optional members

    LPVOID lpIDList;        // IDL, ������������ ���� ��� ����������

    LPCSTR lpClass;         // ��� ������ ����� ��� GUID

    HKEY hkeyClass;         // ���������� ����� � ������� ��� ������ �����

    DWORD dwHotKey;         // ������� �������

    HANDLE hIcon;           // ������ ��� ������ �����

    HANDLE hProcess;        // ���������� ��������

} SHELLEXECUTEINFO, FAR *LPSHELLEXECUTEINFO;

������ ������� notepad.exe:

SHELLEXECUTEINFO SHExecInfo;




ZeroMemory(&SHExecInfo, sizeof(SHExecInfo));



SHExecInfo.cbSize = sizeof(SHExecInfo);

SHExecInfo.fMask = SEE_MASK_NOCLOSEPROCESS;

SHExecInfo.nShow = SW_SHOWNORMAL;

SHExecInfo.lpFile = "notepad.exe";



if(!ShellExecuteEx(&SHExecInfo)) {

    // ��������� ������

} */


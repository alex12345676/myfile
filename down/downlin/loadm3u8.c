
FILE* load_m3u8(char* url)
{
 //   STARTUPINFO si;
 //  PROCESS_INFORMATION pi;
 //  GetStartupInfo(&si);
  // char* arg1="f:\\wget\\wget.exe";
	FILE *f ;
   	char* arg2= str_and_str("wget -c -w 1 -T 1", url);
   	char* arg3= str_and_str(arg2,"  -o wget.log -O ");
	char nam[] = "tmp\0"; 
   	free(arg2);
   	arg2 = str_and_str(arg3, nam);
	free( arg3 );
	arg3 = arg2;   
  // printf(arg3);
  // printf("\n");
   	if (!system(arg3))//( CreateProcess(arg1, arg3, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
    {
        /*WaitForSingleObject(pi.hProcess,INFINITE);
        CloseHandle(pi.hProcess);*/
        free(arg2);
        //printf("proccessexes\n");
        remove("wget.log");
        return fopen(nam, "r");
    }
    free(arg2);
    printf("Not download file *.m3u8\n or wget exit error\n" );
    return NULL;
}

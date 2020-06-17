
FILE* load_m3u8(char* url)
{
 //   STARTUPINFO si;
 //  PROCESS_INFORMATION pi;
 //  GetStartupInfo(&si);
  // char* arg1="f:\\wget\\wget.exe";
   char* arg2= str_and_str("wget -c ", url);
   char* arg3= str_and_str(arg2," -O tmp -o wget.log");
   free(arg2);
   printf(arg3);
   printf("\n");
   if (!system(arg3))//( CreateProcess(arg1, arg3, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
    {
        /*WaitForSingleObject(pi.hProcess,INFINITE);
        CloseHandle(pi.hProcess);*/
        free(arg3);
        //printf("proccessexes\n");
        remove("wget.log");
        return fopen("tmp","r");
    }
    free(arg3);
    printf("Not download file *.m3u8\n or wget exit error\n" );
    return NULL;
}

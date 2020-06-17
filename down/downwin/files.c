
void copy_file(char* name1,char* name2)
{
  //   STARTUPINFO si;
  // PROCESS_INFORMATION pi;
  // GetStartupInfo(&si);
   char* arg1=str_and_str("type ",name1);
  char* arg2= str_and_str(arg1,">>");
  free(arg1);
  arg1= str_and_str(arg2,name2);


   free(arg2);
//   arg2=str_and_str(arg3,name2);
//   free(arg3);
//   printf(arg2);
//   printf("\n");
 //  if ( CreateProcess(arg1, arg2, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
 //   {
 //       WaitForSingleObject(pi.hProcess,INFINITE);
//        CloseHandle(pi.hProcess);
//        free(arg2);
//}
//else
//    printf("no proser\n");
if(!system(arg1))
free(arg1);
else
    printf("No type file in out\n");
}

int load_vid(char* url)
{
//STARTUPINFO si;
 //  PROCESS_INFORMATION pi;
//   GetStartupInfo(&si);
 //  char* arg1="f:\\wget\\wget.exe";
   char* arg2= str_and_str("wget -c ", url);
   char* arg3= str_and_str(arg2," -O tmp2 -o wget.log");
   free(arg2);
 //  printf(arg3);
 // printf("\n");
   if (!system(arg3))//( CreateProcess(arg1, arg3, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
    {
      //  WaitForSingleObject(pi.hProcess,INFINITE);
      //  CloseHandle(pi.hProcess);
        free(arg3);
        remove("wget.log");
      //  printf("proccessexes\n");
        return 1;
    }
    //free(arg3);
    printf("Not download file *.seg\n" );
    return NULL;
}

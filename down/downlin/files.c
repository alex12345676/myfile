// файловые функции

// функция копирования файла с параметрами имя 1 имя 2
void copy_file(char* name1,char* name2)
{
  //   STARTUPINFO si;
  // PROCESS_INFORMATION pi;
  // GetStartupInfo(&si);
  	char b[1];
	FILE *f1, *f2; // point to file
	if (!(f1 = fopen(name1, "r")))
	{
		printf("No open file name %s\n", name1);
		return;
	}
	if (!(f2 = fopen(name2, "a")))
	{
		fclose(f1); // close file
		printf("No open file name %s\n", name2);
		return;
	}
		while (!feof(f1))
	{
		
		fread(b, 1, 1, f1);
		//fseek(f2,0,SEEK_END);
		fwrite(b, 1, 1, f2);
	}
   //char* arg1=str_and_str("cat ",name1);
  //char* arg2= str_and_str(arg1,">>");
  //free(arg1);
  //arg1= str_and_str(arg2,name2);


   //free(arg2);
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
//if(!system(arg1))
//free(arg1);
//else
//    printf("No cat file in out\n");
	fclose(f1);
	fclose(f2);
}

int load_vid(char* url)
{
//STARTUPINFO si;
 //  PROCESS_INFORMATION pi;
//   GetStartupInfo(&si);
 //  char* arg1="f:\\wget\\wget.exe";
	FILE *f ;
	char nam[] = "tmp0";
   	char* arg2 = str_and_str("wget -c ", url);
   	char* arg3 = str_and_str(arg2,"  -o wget.log -O ");
   	free(arg2);
   	arg2 = str_and_str(arg3, nam);
   	free(arg3);
	while( (f = fopen( nam, "r" )))
	{
		nam[3]++;
		fclose( f );
	}
 //  printf(arg3);
 // printf("\n");
   	if (!system(arg2))//( CreateProcess(arg1, arg3, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi))
    {
      //  WaitForSingleObject(pi.hProcess,INFINITE);
      //  CloseHandle(pi.hProcess);
        free(arg2);
        remove("wget.log");
      //  printf("proccessexes\n");
        return 1;
    }
    free(arg2);
    printf("Not download file *.seg\nOr no execute wget\nOr no url\n" );
    return 0;
}

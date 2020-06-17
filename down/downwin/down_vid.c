void down_vid(FILE* m3u8,char* url, char* out_file)
{
        char lin[255];
        //FILE* vidseg;
        //FILE* outvid;
        int f,d,count;
//        char buf[562];
        char ch='#';
        char* name_seg;
	count=strlen(url);
        for( count; count>0; count--)
                        if(url[count]=='/')
                        break;
                        else
                        url[count]=0;
        //outvid= fopen("video.mp4","w");
        while(!feof(m3u8))
        {
            fgets(lin,254,m3u8);
            f=(char)lin[0];
            d=ch;
  //          printf(lin);
   //         putc(lin[0],stdout);
  //          printf("\n");
//printf("%i ---- %i\n",f,d);
            if( d==f)
            {
          //      printf("continue #\n");
                continue;
            }
                if((((char)lin[0])=='h') && (((char)lin[1])=='t') && (((char)lin[2])=='t') && (((char)lin[3]) == 'p'))
                   {
                       printf("load url seg\n");
                      if( load_vid(lin))
{
                        copy_file("tmp2",out_file);

                      // while (feof(vidseg)==0)
                       //{
                      //     c=getc(vidseg);
                       //    putc(c,outvid);
                      // }
                      // fclose(vidseg);
                       remove("tmp2");
                   }
                   else
                    printf("No load video file\n");
                   }
                else
                   {
                //       printf("load no url\n");

//printf(lin,url,"\n");
                       name_seg=str_and_str(url,lin);
                       name_seg[strlen(name_seg)-1]=0;
                        if( load_vid(name_seg))
                        {


                       free(name_seg);
                      // while ((n = read(fileno(vidseg), buf, sizeof buf)) > 0)
  //{
 //   write(fileno(outvid), buf, n);
 // }
                       //while(feof(vidseg)==0)
                    //   {
                    //       c=getc(vidseg);
                    //       printf("%i\n",c);
                    //       putc(c,outvid);
                    //   }
                    //   fclose(vidseg);
                    copy_file("tmp2",out_file);
                       remove("tmp2");
                        }
                        else
                        {
                            free(name_seg);
                            printf("No down load video file\n");
                        }
                   }



            //else
           //         break;
        }
    //fclose(outvid);
}



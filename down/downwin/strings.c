
char* str_and_str(char* s1, char * s2)
{
     size_t len1 = strlen(s1);
        size_t len2 = strlen(s2);

        char *result = malloc(len1 + len2 + 1);

        if (!result) {
            fprintf(stderr, "malloc() failed: insufficient memory!\n");
            return NULL;
        }
       memcpy(result, s1, len1);
        memcpy(result + len1, s2, len2 + 1);

        return result;

}
char* str_del_len(char* s, int len)
{
    char* res = s;
    if (len >= strlen(s))
        return 0;
    else
    {
        res[strlen(s)-len+1]= 0;
        return res;
    }
}

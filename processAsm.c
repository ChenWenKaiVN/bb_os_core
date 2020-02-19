#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){
    printf("origin %s \n", argv[1]);
    FILE* origin = fopen(argv[1], "rb");
    FILE* result = fopen(argv[2], "w");
    char line[512];
    char _extern[7] = {"extern"};
	char _global[7] = {"global"};
	char _section[8] = {"SECTION"};
    while (!feof(origin) && !ferror(origin)) {
        strcpy(line, "\n");
        fgets(line, sizeof(line), origin);
        if(strncmp(_extern, line, 6)==0 || strncmp(_global, line, 6)==0 || strncmp(_section, line, 7)==0){
            //printf("%s", line);
        }else{
            fputs(line, result);
        }
    }
    fclose(origin);
    fclose(result);
    return 0;
}

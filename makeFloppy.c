#include <stdio.h>
#include <stdlib.h>
#include "floppy.h"
#include <string.h>

int main(int argc, char *argv[]){

    printf("src %s \n", argv[1]);
    FILE* src = fopen(argv[1], "r");

    printf("img %s \n", argv[2]);
    FILE* img = initFloppy(argv[2]);

    if(src == NULL){
	printf("The file not found");
	exit(0);
    }
    
    //写入引导扇区
    char buf[512];
    memset(buf, 0, 512);
    fread(buf, 512, 1, src);
    writeFloppy(0, 0, 1, img, buf);

    //head0 cylinder1 sector2 写入字符串
    memset(buf, 0, 512);
    char str[100] = {"Hello World cylinder1 sector2"};
    strncpy(buf, str, 100); 
    writeFloppy(1, 0, 2, img, buf);
    fclose(src);
}

#include <stdio.h>
#include <stdlib.h>
#include "floppy.h"
#include <string.h>

int main(int argc, char *argv[]){

    printf("boot %s \n", argv[1]);
    FILE* boot = fopen(argv[1], "r");

    printf("kernel %s \n", argv[2]);
    FILE* kernel = fopen(argv[2], "r");

    printf("img %s \n", argv[3]);
    FILE* img = initFloppy(argv[3]);

    if(boot == NULL || kernel == NULL){
	printf("The boot or kernel file not found");
	exit(0);
    }
    
    //写引导扇区cylinder0 sector1
    char buf[512];
    memset(buf, 0, 512);
    fread(buf, 512, 1, boot);
    writeFloppy(0, 0, 1, img, buf);

    //写内核 cylinder1 sector2
    for(int i=0; !feof(kernel); i++){
        memset(buf, 0, 512);
        fread(buf, 512, 1, kernel);
        writeFloppy(1, 0, 2+i, img, buf);
        printf("The %d read kernel write img sector %d \n", i+1, 2+i);
    }
    fclose(boot);
    fclose(kernel);
}

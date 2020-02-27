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
	printf("The boot or kernel file not found \n");
	exit(0);
    }
    
    //写引导扇区cylinder0 sector1
    char buf[512];
    memset(buf, 0, 512);
    fread(buf, 512, 1, boot);
    writeFloppy(0, 0, 1, img, buf);

    //写内核 cylinder1 sector1开始
	//扇区1-18
	//磁头0-79
	int cy = 1;
	int s = 1;
	int h = 0;
    for(int i=0; !feof(kernel); i++){
        memset(buf, 0, 512);
        fread(buf, 512, 1, kernel);
        writeFloppy(cy, h, s, img, buf);
        printf("The %d read kernel write img cylinder %d head % d sector %d \n", i+1, cy, h, s);
		s++;
		//如果磁道cy 磁头h=0写满 则写磁道cy 磁头h=1
		//先暂时不用以上逻辑  先写磁道cy磁头h=0  如果写满则写磁道cy++ 磁头h=0 
		//这里与boot.asm要对应
		if(s>18 && h==0){
			s=1;
			cy++;
			//h=1;
		}
		//如果磁道cy 磁头h=1写满 则写磁道cy+1 磁头h=0
		if(s>18 && h==1){
			cy++;
			s=1;
			h=0;
		}
    }
    fclose(boot);
    fclose(kernel);
}

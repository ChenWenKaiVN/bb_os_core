#include<stdio.h>
#include<stdlib.h>
#include<string.h>

FILE* initFloppy(char *fileName){
   FILE *fp = fopen(fileName, "w");
   char buf[512];
   memset(buf, 0, 512);
   for(int cylinder=0; cylinder<80; cylinder++){
       for(int head=0; head<2; head++){
		   for(int sector=1; sector<=18; sector++){
			   fwrite(buf, 512, 1, fp);
		   }    
       }
   }
   return fp;
}

void readFloppy(int cylinder, int head, int sector, FILE *fp, char *buf){
    int index = 18*2*512*cylinder + 18*512*head + 512*(sector-1);
    int tmp = (int)ftell(fp);
    fseek(fp, index, SEEK_SET);
    fread(buf, 512, 1, fp);
    fseek(fp, tmp, SEEK_SET);
}

void writeFloppy(int cylinder, int head, int sector, FILE *fp, char *buf){
    int index = 18*2*512*cylinder + 18*512*head + 512*(sector-1);
    int tmp = (int)ftell(fp);
    fseek(fp, index, SEEK_SET);
    fwrite(buf, 512, 1, fp);
    fseek(fp, tmp, SEEK_SET);
}

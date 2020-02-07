#include<stdio.h>
#include<stdlib.h>
#include<string.h>

//根据文件名创建一个3.5寸虚拟软盘
FILE* initFloppy(char * fileName);

//从一个虚拟软盘fp中读取磁头head,柱面cylinder,扇区sector的数据到buf中
void readFloppy(int cylinder, int head, int sector, FILE *fp, char *buf);

//将buf中数据读取到虚拟软盘fp中读取磁头head,柱面cylinder,扇区sector
void writeFloppy(int cylinder, int head, int sector, FILE *fp, char *buf);


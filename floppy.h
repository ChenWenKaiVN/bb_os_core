#include<stdio.h>
#include<stdlib.h>
#include<string.h>

/**
 *根据文件名创建一个3.5寸虚拟软盘
 *3.5寸软盘结构:80个磁道，2个磁头，18个扇区。每个扇区512字节
 *系统读取磁盘结构:0磁道0磁头1扇区，0磁道0磁头2扇区...，0磁道0磁头18扇区,0磁道1磁头1扇区，
 *0磁道1磁头2扇区...，0磁道1磁头18扇区。再从1磁道0磁头1扇区....循环读取操作
 */
//根据文件名创建一个3.5寸虚拟软盘
FILE* initFloppy(char * fileName);

//从一个虚拟软盘fp中读取磁头head,柱面cylinder,扇区sector的数据到buf中
void readFloppy(int cylinder, int head, int sector, FILE *fp, char *buf);

/**
 *写入软盘指定磁道，磁头，扇区数据
 *@param    cylinder       磁道[0,79]
 *@param    head           磁头[0,1]
 *@param    sector         扇区[1,18]
 *@param    fp      初始化的虚拟软盘文件
 *@param    buf     读取的磁盘数据，大小长度至多是512字节
 */
//将buf中数据读取到虚拟软盘fp中读取磁头head,柱面cylinder,扇区sector
void writeFloppy(int cylinder, int head, int sector, FILE *fp, char *buf);


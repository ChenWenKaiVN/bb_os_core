#include<stdio.h>
#include "io.h"

//定义调色板颜色
#define  COL8_000000  0
#define  COL8_FF0000  1
#define  COL8_00FF00  2
#define  COL8_FFFF00  3
#define  COL8_0000FF  4
#define  COL8_FF00FF  5
#define  COL8_00FFFF  6
#define  COL8_FFFFFF  7
#define  COL8_C6C6C6  8
#define  COL8_840000  9
#define  COL8_008400  10
#define  COL8_848400  11
#define  COL8_000084  12
#define  COL8_840084  13
#define  COL8_008484  14
#define  COL8_848484  15

//屏幕宽度
#define SCREEN_WIDTH 320

//屏幕高度
#define SCREEN_HEIGHT 200

//调色板初始化
void initPallet();

//绘制简单图形
void draw_simple();

//绘制矩形功能
void draw_rectangle();

//绘制矩形
void fillRect(int x, int y, int width, int height, char colIndex);

//绘制桌面
void draw_desktop();

//C程序入口
void kernel_main(){
    initPallet();
    //draw_simple();
    //draw_rectangle();
    draw_desktop();
    for(;;){
        io_hlt();
    }
}

void initPallet(){
    //定义调色板
    static char table_rgb[16*3] = {
        0x00,  0x00,  0x00,
        0xff,  0x00,  0x00,
        0x00,  0xff,  0x00,
        0xff,  0xff,  0x00,
        0x00,  0x00,  0xff,
        0xff,  0x00,  0xff,
        0x00,  0xff,  0xff,
        0xff,  0xff,  0xff,
        0xc6,  0xc6,  0xc6,
        0x84,  0x00,  0x00,
        0x00,  0x84,  0x00,
        0x84,  0x84,  0x00,
        0x00,  0x00,  0x84,
        0x84,  0x00,  0x84,
        0x00,  0x84,  0x84,
        0x84,  0x84,  0x84,
    };
    char *p = table_rgb;
	//读取eflags寄存器值
    int flag = io_readFlag();
	//关中断
    io_cli();
	//写入调色板编号
    io_out8(0x03c8, 0);
	//调色板颜色与坐标索引对应值
    for(int i=0; i<16; i++){
        io_out8(0x0309, p[i]/4);
        io_out8(0x0309, p[i+1]/4);
        io_out8(0x0309, p[i+2]/4);
        p += 3;
    } 
    //将eflags寄存器重新赋值
    io_writeFlag(flag);
}

void draw_simple(){
    //显存起始地址
    char *p = (char *)0xa0000;
    //绘制画面
    for(int i=0; i<=0xFFFF; i=i+2){
        *p = i & 0x0F;
        p++;
    }
}

void fillRect(int x, int y, int width, int height, char colIndex){
    char *vram = (char *)0xa0000;
    for(int i=y; i<=y+height; i++){
        for(int j=x; j<=x+width; j++){
            vram[i*SCREEN_WIDTH+j] = colIndex;
        }
    }
}

void draw_rectangle(){
    fillRect(10, 30, 100, 100, COL8_FF0000);
    fillRect(50, 80, 100, 100, COL8_00FF00);
    fillRect(100, 100, 100, 100, COL8_0000FF);
}

void draw_desktop(){

    fillRect(0, 0, SCREEN_WIDTH-1, SCREEN_HEIGHT-29, COL8_008484);
    fillRect(0, SCREEN_HEIGHT-28, SCREEN_WIDTH-1, 28, COL8_848484);

	fillRect(0, SCREEN_HEIGHT-27, SCREEN_WIDTH, 1, COL8_848484);
	fillRect(0, SCREEN_HEIGHT-26, SCREEN_WIDTH, 25, COL8_C6C6C6);
	
	fillRect(3, SCREEN_HEIGHT-24, 56, 1, COL8_FFFFFF);
	fillRect(2, SCREEN_HEIGHT-24, 1, 20, COL8_FFFFFF);

	fillRect(3, SCREEN_HEIGHT-4, 56, 1, COL8_848484);
	fillRect(59, SCREEN_HEIGHT-23, 1, 19, COL8_848484);

	fillRect(2, SCREEN_HEIGHT-3, 57, 0, COL8_000000);
	fillRect(60, SCREEN_HEIGHT-24, 0, 19, COL8_000000);

	fillRect(SCREEN_WIDTH-47, SCREEN_HEIGHT-24, 43, 1, COL8_848484);
	fillRect(SCREEN_WIDTH-47, SCREEN_HEIGHT-23, 0, 19, COL8_848484);

	fillRect(SCREEN_WIDTH-47, SCREEN_HEIGHT-3, 43, 0, COL8_FFFFFF);
	fillRect(SCREEN_WIDTH-3, SCREEN_HEIGHT-24, 0, 21, COL8_FFFFFF);
}

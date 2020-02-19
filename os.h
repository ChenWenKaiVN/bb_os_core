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

//显存起始地址
#define VGA_ADDR 0xa0000

//键盘数据端口
#define PORT_KEYDATA 0x60

//鼠标数据端口
#define PORT_MOUSEDATA 0x60

#define PORT_KEYSTA 0x64

#define PORT_KEYCMD 0x64

#define KEYCMD_WRITE_MODE 0x60

#define KBC_MODE 0x47

#define KEYCMD_SENDTO_MOUSE 0xd4

#define MOUSECMD_ENABLE 0xf4

#define KEYBUF_LEN 32

//定义调色板
static unsigned char table_rgb[16*3] = {
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

/**
 *绘制字体
 *@param	addr		绘制的起始显存地址
 *@param 	x			绘制的x坐标
 *@param	y			绘制的y坐标
 *@param	col			绘制颜色
 *@param	pch			绘制的字符数组8*16,每一行共8位，共16行
 *@param	screenWidth	屏幕宽度
 */
void showChar(char *addr, int x, int y, char col, unsigned char *pch, int screenWidth);

void draw_char();

//初始化鼠标指针
void init_mouse_cursor(char *vram, int x, int y, char bc);

void showString(char *addr, int x, int y, char col);

void int_8259A(char *index);

char char2HexVal(char c);

void char2HexStr(unsigned char c, char *keyval);

void init_mouse();

//缓冲数据区
typedef struct _FIFO8 {
	//指向缓冲区
	char* buf;
	//r读索引 w写索引 len存储数据长度
	int r, w, size, len, flag;
}FIFO8;

void fifo8_init(FIFO8 *fifo, int size, char *buf);

int fifo8_put(FIFO8 *fifo, char data);

int fifo8_get(FIFO8 *fifo);

void handleKeyInterrupt(FIFO8 *fifo);

void handleMouseInterrupt(FIFO8 *fifo);

//鼠标处理需要连续处理3字节
//phase 表示处理字节阶段
//offX, offY 当前鼠标的偏移
//x,y 鼠标当前所在的坐标位置
typedef struct _MouseDes{
	char buf[3], phase;
	int offX, offY;
	int x, y, btn;
}MouseDes;

int mouse_decode(MouseDes *mdec, unsigned char dat);

void mouseCursorMoved(MouseDes *mdec, char bc);
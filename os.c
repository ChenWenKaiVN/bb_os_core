#include<stdio.h>
#include "io.h"
#include "os.h"
#include "ascii_font.h"

//C程序入口
void kernel_main(){
	
	//初始化调色板
    initPallet();

	//绘制桌面
    draw_desktop();

	//初始化鼠标指针
    init_mouse_cursor((char *)VGA_ADDR, 100, 100, COL8_008484);
	
	//初始化鼠标电路
	init_mouse();
	
    for(;;){
		if (keybuf.len == 0) {
			io_hlt();
		} else {
			io_cli();
			static char keyval[4] = {'0','x'};
			for(int i=0; i<keybuf.len; i++){
				static int x = 0;
				char2HexStr(keybuf.buf[i], keyval);
				showString(keyval, x%SCREEN_WIDTH, x/SCREEN_WIDTH*20, COL8_FFFFFF);
				x += 32;
			}
			keybuf.len = 0;
			keybuf.next_w = 0;
			io_seti();
		}   
    }
}

void initPallet(){

	// 注意此指针变量的声明
    unsigned char *p = table_rgb;
	//读取eflags寄存器值
    int flag = io_readFlag();
	//关中断
    io_cli();
	//写入调色板编号
    io_out8(0x03c8, 0);
	//调色板颜色与坐标索引对应值
    for(int i=0; i<16; i++){
        io_out8(0x03c9, p[0]/4);
        io_out8(0x03c9, p[1]/4);
        io_out8(0x03c9, p[2]/4);
        p += 3;
    }	
    //将eflags寄存器重新赋值
    io_writeFlag(flag);
	// 开中断
	// 此处注意开中断
	// 在写调色板信息时关闭中断 这里要及时打开中断 否则后面中断无法响应
	io_seti();
}

void draw_simple(){
    //显存起始地址
    char *p = (char *)VGA_ADDR;
    //绘制画面
    for(int i=0; i<=0xFFFF; i=i+2){
        *p = i & 0x0F;
        p++;
    }
}

void fillRect(int x, int y, int width, int height, char colIndex){
    char *vram = (char *)VGA_ADDR;
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

void showChar(char *addr, int x, int y, char col, unsigned char *pch, int screenWidth){
    for(int i=0; i<16; i++){
        char ch = pch[i];
        // 对于每一个字符 8*16
        // 从上到下 从右向左依次绘制
        // 遍历每一位 如果1 则将显存对应位置设置为特定颜色
        int off = (y + i) * screenWidth;
        if((ch & 0x01) != 0){
            addr[off+x+7] = col;
        }
        if((ch & 0x02) != 0){
            addr[off+x+6] = col;
        }
        if((ch & 0x04) != 0){
            addr[off+x+5] = col;
        }
        if((ch & 0x08) != 0){
            addr[off+x+4] = col;
        }
        if((ch & 0x10) != 0){
            addr[off+x+3] = col;
        }
        if((ch & 0x20) != 0){
            addr[off+x+2] = col;
        }
        if((ch & 0x40) != 0){
            addr[off+x+1] = col;
        }
        if((ch & 0x80) != 0){
            addr[off+x+0] = col;
        }
    }
}

void draw_char(){
    unsigned char *ascii = ascii_array;
    int x, y = 0;
    for(int i=0x20; i<=0x7f; i++){
        //字符水平间隔为4 竖直间隔为8
        x = (i - 0x20) % 32 * 10;
        y = (i - 0x20) / 32 * 20;
        showChar((char *)VGA_ADDR, x, y, COL8_FFFFFF, ascii+(i-0x20)*16, SCREEN_WIDTH);
    }
}

void init_mouse_cursor(char *vram, int x, int y, char bc){
	//16*16 Mouse
    //鼠标指针点阵
	static char cursor[16][16] = {
	 "*...............",
	 "**..............",
	 "*O*.............",
	 "*OO*............",
	 "*OOO*...........",
	 "*OOOO*..........",
	 "*OOOOO*.........",
	 "*OOOOOO*........",
	 "*OOOOOOO*.......",
	 "*OOOO*****......",
	 "*OO*O*..........",
	 "*O*.*O*.........",
	 "**..*O*.........",
	 "*....*O*........",
	 ".....*O*........",
	 "......*........."
	};

	for (int i = 0; i < 16; i++) {
		for (int j = 0; j < 16; j++) {
			int off = (i+y)*SCREEN_WIDTH+x+j;
			if (cursor[i][j] == '*') {
				vram[off] = COL8_000000;
			}
			if (cursor[i][j] == 'O') {
				vram[off] = COL8_FFFFFF;
			}
			if (cursor[i][j] == '.') {
				vram[off] = bc;
			}
		}
	}

}

void showString(char *str, int x, int y, char col){
	unsigned char *ascii = ascii_array;
	for(; *str!=0x00; str++){
		showChar((char *)VGA_ADDR, x, y, col, ascii+((char)*str-0x20)*16, SCREEN_WIDTH);
		x += 8;
	}
}

void int_keyboard(char *index){
	//0x20是8259A控制端口
	//0x21对应的是键盘的中断向量。当键盘中断被CPU执行后，下次键盘再向CPU发送信号时，
	//CPU就不会接收，要想让CPU再次接收信号，必须向主PIC的端口再次发送键盘中断的中断向量号
	io_out8(0x20, 0x21);
	unsigned char data = io_in8(PORT_KEYDATA);
	if (keybuf.len < KEYBUF_LEN) {
		keybuf.buf[keybuf.next_w] = data;
		keybuf.len++;
		keybuf.next_w++;
	} else {
		keybuf.len = 0;
		keybuf.next_w = 0;
	}
	
	// static 关键字 _stack_chk_fail
	/*static char keyval[4] = {'0','x'};
	char2HexStr(data, keyval);
	static int x = 0;
    showString(keyval, x, 100, COL8_FFFFFF);
	x += 32;*/
	//showString("12345", 200, 100, COL8_FFFFFF);
}

char char2HexVal(char c) {
	if (c >= 10) {
		return 'A' + c - 10;
	}
	return '0' + c;
}

void char2HexStr(unsigned char c, char *keyval){
	char mod = c % 16;
	keyval[3] = char2HexVal(mod);
	c = c / 10;
	keyval[2] = char2HexVal(c);
}

//鼠标电路对应的一个端口是 0x64, 通过读取这个端口的数据来检测鼠标电路的状态，
//内核会从这个端口读入一个字节的数据，如果该字节的第二个比特位为0，那表明鼠标电路可以
//接受来自内核的命令，因此，在给鼠标电路发送数据前，内核需要反复从0x64端口读取数据，
//并检测读到数据的第二个比特位，直到该比特位为0时，才发送控制信息
void waitKBCReady(){
	for(;;){
		if((io_in8(PORT_KEYSTA)&0x02)==0){
			break;
		}
	}
}

//初始化键盘控制电路，鼠标控制电路是连接在键盘控制电路上，通过键盘电路实现初始化
void init_mouse(){
	
	waitKBCReady();
	
	//0x60让键盘电路进入数据接受状态
	io_out8(PORT_KEYCMD, KEYCMD_WRITE_MODE);
	waitKBCReady();
	
	//数据0x47要求键盘电路启动鼠标模式，这样鼠标硬件所产生的数据信息，通过键盘电路端口0x60就可读到
	io_out8(PORT_KEYDATA, KBC_MODE);
	waitKBCReady();
	
	io_out8(PORT_KEYCMD, KEYCMD_SENDTO_MOUSE);
	waitKBCReady();
	
	//0xf4数据激活鼠标电路，激活后将会给CPU发送中断信号
	io_out8(PORT_KEYDATA, MOUSECMD_ENABLE);
}

void int_mouse(char *index){
	//当中断处理后，要想再次接收中断信号，就必须向中断控制器发送一个字节的数据
	io_out8(0x20, 0x20);
	io_out8(0xa0, 0x20);
	//读取鼠标数据
	unsigned char data = io_in8(0x60);
	static char val[4] = {'0','x'};
	char2HexStr(data, val);
	static int x = 0;
    showString(val, x, 100, COL8_FFFFFF);
	x += 32;
}

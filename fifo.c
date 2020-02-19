#include "fifo.h"

void fifo8_init(FIFO8 *fifo, int size, char *buf){
	fifo->buf = buf;
	fifo->r = 0;
	fifo->w = 0;
	fifo->size = size;
	fifo->len = 0;
	fifo->flag = 0;
}

int fifo8_put(FIFO8 *fifo, char data){
	if(fifo->len == fifo->size){
		return -1;
	}
	fifo->buf[fifo->w] = data;
	fifo->w++;
	if(fifo->w == fifo->size){
		fifo->w = 0;
	}
	fifo->len++;
	return 0;
}

int fifo8_get(FIFO8 *fifo){
	if(fifo->len == 0){
		return -1;
	}
	int data = fifo->buf[fifo->r];
	fifo->r++;
	if(fifo->r == fifo->size){
		fifo->r = 0;
	}
	fifo->len--;
	return data;
}
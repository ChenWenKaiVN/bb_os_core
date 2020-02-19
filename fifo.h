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


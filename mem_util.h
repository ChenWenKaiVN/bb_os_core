#define MEMMAN_FREES 4096

//内存片
//起始地址和大小
typedef struct _FREEINFO{
	unsigned int *addr, size;
}FREEINFO;

//内存管理器
typedef struct _MEMMAN{
	int frees, maxfrees, lostsize, losts;
	struct _FREEINFO free[MEMMAN_FREES];
}MEMMAN;

//初始化内存管理器
void memman_init(MEMMAN *man);

//内存总共可用量
unsigned int memman_total(MEMMAN *man);

//分配内存
unsigned int* memman_alloc(MEMMAN *man, unsigned int size);

//释放内存
int memman_free(MEMMAN *man, unsigned int *addr, unsigned int size);


#define MEMMAN_ADDR  0x00100000

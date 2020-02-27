//获取内存块数量
extern int mem_block_count();

//中断返回内存信息起始地址
extern char* get_addr_mem_buffer();

//内存段描述信息
//高4字节addrHigh和低4字节addrLow共同组成64位内存地址
//高4字节lenHigh和低4字节lenLow共同组成64位内存长度信息
//4字节type字段描述内存使用情况， 
//type等于1，表示当前内存块可以被内核使用。
//type等于2，表示当前内存块已经被占用，系统内核绝对不能使用。
//type等于3，保留给未来使用，内核也不能用当前内存块。

typedef struct _AddrRangeDesc{
	unsigned int addrLow;
	unsigned int addrHigh;
	unsigned int lenLow;
	unsigned int lenHigh;
	unsigned int type;
}AddrRangeDesc;
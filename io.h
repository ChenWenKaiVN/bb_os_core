extern void io_hlt();

extern char io_in8(int port);

extern int io_in16(int port);

extern int io_in32(int port);

extern void io_out8(int port, char value);

extern void io_out16(int port, int value);

extern void io_out32(int port, int value);

extern void io_cli();

extern void io_seti();

extern int io_readFlag();

extern void io_writeFlag(int value);

//extern void io_hlt();

void showChar() {
    int i;
    char *p = (char *)0xa0000;
    for(i=0; i<=0xFFFF; i++){
        *p = i & 0x0F;
        p++;
    }
    for(;;){
        io_hlt();
    }
}

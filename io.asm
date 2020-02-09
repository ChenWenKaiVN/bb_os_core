;io操作函数定义，给C语言调用
;eax作为返回值

[SECTION .s32]
[BITS 32]

;hlt void io_hlt();
io_hlt:
    hlt
    ret

;读取指定端口8位数据  int io_in8(int port);
io_in8:
    mov edx, [esp+4]
    mov eax, 0
    in al, dx
    ret

;读取指定端口16位数据 int io_in16(int port);
io_in16:
    mov edx, [esp+4]
    mov eax, 0
    in ax, dx
    ret

;读取指定端口32位数据 int io_in32(int port);
io_in32:
    mov edx, [esp+4]
    in  eax, dx
    ret

;向指定端口写入8位数据 void io_out8(int port, int value);
io_out8:
    mov edx, [esp+4]
    mov al, [esp+8]
    out dx, al
    ret

;向指定端口写入16位数据 void io_out16(int port, int value);
io_out16:
    mov edx, [esp+4]
    mov ax, [esp+8]
    out dx, ax
    ret

;向指定端口写入32位数据 void io_out32(int port, int value);
io_out32:
    mov edx, [esp+4]
    mov eax, [esp+8]
    out dx, eax
    ret

;关中断 void io_cli();
io_cli:
    cli
    ret

;开中断  void io_seti();
io_seti:
    sti
    ret

;获取程序状态字  int io_readFlag();
io_readFlag:
    pushfd
    pop eax
    ret

;设置程序状态字  void io_writeFlag(int value)
io_writeFlag:
    mov edx, [esp+4]
    push eax
    popfd
    ret

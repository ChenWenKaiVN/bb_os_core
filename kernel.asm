; 全局描述符结构 8字节
; byte7 byte6 byte5 byte4 byte3 byte2 byte1 byte0
; byte6低四位和 byte1 byte0 表示段偏移上限
; byte7 byte4 byte3 byte2 表示段基址

;定义全局描述符数据结构
;3 表示有3个参数分别用 %1、%2、%3引用参数
;%1:段基址     %2:段偏移上限  %3:段属性
%macro GDescriptor 3
    dw %2 & 0xffff                         ;设置段偏移上限0,1字节
    dw %1 & 0xffff                         ;设置段基址2,3字节
    db (%1>>16) & 0xff                     ;设置段基址4字节
    dw ((%2>>8) & 0x0f00) | (%3 & 0xf0ff)  ;设置段偏移上限6字节低四位
    db (%1>>24) & 0xff                     ;设置段基址7字节
%endmacro

DA_32     EQU  0x4000    ;32位段属性
DA_CODE   EQU  0x98      ;执行代码段属性
DA_RW     EQU  0x92      ;读写代码段属性值
DA_RWA    EQU  0x93      ;存在的已访问可读写数据段类型值

;中断描述符表
;Gate selector, offset, DCount, Attr
%macro Gate 4
    dw (%2 & 0FFFFh)
    dw %1
    dw (%3 & 1Fh) | ((%4 << 8) & 0FF00h)
    dw ((%2 >> 16) & 0FFFFh)
%endmacro

DA_386IGate EQU 0x8e ;中断调用门

org 0x9000       ;内核代码在内存中起始加载处

jmp entry

[SECTION .gdt]
;全局描述符                             段基址    段偏移上线     段属性
LABLE_GDT:              GDescriptor     0,        0,             0
LABLE_DESC_CODE:        GDescriptor     0,        SegCodeLen-1,  DA_CODE + DA_32
LABLE_DESC_VIDEO:       GDescriptor     0xb8000,  0xffff,        DA_RW                ;显存内存地址从0xB8000开始
LABLE_DESC_STACK:       GDescriptor     0,        STACK_TOP-1,   DA_RWA  + DA_32         ;函数堆栈
LABLE_DESC_VRAM:        GDescriptor     0,        0xffffffff,    DA_RW

;GDT表大小
GdtLen    EQU    $ - LABLE_GDT

;GDT表偏移上限和基地址
GdtPtr dw  GdtLen-1
       dd  0

;cpu寻址方式
;实模式  段寄存器×16+偏移地址
;保护模式下  段寄存器中存储的是GDT描述表各个描述符的偏移


SelectorCode32     EQU      LABLE_DESC_CODE - LABLE_GDT
SelectorVideo      EQU      LABLE_DESC_VIDEO - LABLE_GDT
SelectorStack      EQU      LABLE_DESC_STACK - LABLE_GDT
SelectorVRAM       EQU      LABLE_DESC_VRAM - LABLE_GDT

;中断描述符表
LABLE_IDT:
    %rep 255
        Gate SelectorCode32, SpuriousHandler, 0, DA_386IGate
    %endrep

IdtLen EQU $ - LABLE_IDT
IdtPtr dw IdtLen - 1
       dd 0

[SECTION .s16]
[BITS 16]

entry:
    mov ax, cs
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov sp, 0x100

    ;设置屏幕色彩模式
    mov al, 0x13
    mov ah, 0
    INT 0x10

    ;设置LABLE_DESC_CODE描述符段基址
    mov eax, 0
    mov ax, cs
    shl eax, 4
    add eax, SEG_CODE32
    mov word [LABLE_DESC_CODE+2], ax
    shr eax, 16
    mov [LABLE_DESC_CODE+4], al
    mov [LABLE_DESC_CODE+7], ah

    ;设置栈空间
    xor eax, eax
    mov ax, cs
    shl eax, 4
    add eax, LABLE_STACK
    mov word [LABLE_DESC_STACK+2], ax
    shr eax, 16
    mov byte [LABLE_DESC_STACK+4], al
    mov byte [LABLE_DESC_STACK+7], ah

    mov eax, 0
    mov ax, ds
	shl eax, 4
    add eax, LABLE_GDT
    mov dword [GdtPtr+2], eax
    
    ;设置GDTR寄存器
    lgdt [GdtPtr]

    cli ;关中断

    ;打开A20
    in al, 0x92
    or al, 0x02
    out 0x92, al
    
    ;进入保护模式CR0寄存器最低位PE设为1
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ;初始化8259A
    call init8259A

    ;加载中断描述符
    xor eax, eax
    mov ax, ds
    shl eax, 4
    add eax, LABLE_IDT
    mov dword [IdtPtr + 2], eax
    lidt [IdtPtr]
	
	;恢复中断
    sti

    jmp dword SelectorCode32:0

;初始化8259A中断控制器
init8259A:
    mov al, 011h
    out 20h, al
    call io_delay
    
    out 0A0h, al
    call io_delay

    mov al, 020h
    out 021h, al
    call io_delay

    mov al, 028h
    out 0A1h, al
    call io_delay

    mov al, 004h
    out 021h, al
    call io_delay

    mov al, 002h
    out 0A1h, al
    call io_delay

    mov al, 002h
    out 021h, al
    call io_delay

    out 0A1h, al
    call io_delay

    mov al, 11111101b
    out 021h, al
    call io_delay

    mov al, 11111111b
    out 0A1h, al
    call io_delay

    ret

io_delay:
    nop
    nop
    nop
    nop
    ret

    [SECTION .s32]
    [BITS 32]

SEG_CODE32:
    mov ax, SelectorStack
    mov ss, ax
    mov esp, STACK_TOP

    mov ax, SelectorVRAM
    mov ds, ax
	
	mov  ax, SelectorVideo
    mov  gs, ax

    ;恢复中断
    sti

    call kernel_main  ;调用c语言函数
	
fin:
	hlt
	jmp fin

LABLE_8259A:
    SpuriousHandler EQU LABLE_8259A - $$
    call int_8259A
    iretd
	
;注意汇编文件引入位置 在代码段结束符之上
%include "io.asm"
%include "write_vram.asm"

;32位模式代码长度
SegCodeLen EQU $ - SEG_CODE32

[SECTION .gs]
    ALIGN 32
    [BITS 32]

LABLE_STACK:
    TIMES 1024 DB 0
STACK_TOP    EQU   $ - LABLE_STACK

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
;专门用于描述可执行代码所在的内存
;offset_low 和 offset_high 合在一起作为中断函数在代码执行段中的偏移
;selector 用来指向全局描述符表中的某个描述符，中断函数的代码就处于该描述符所指向的段中
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
    %rep 0x21
        Gate SelectorCode32, SpuriousHandler, 0, DA_386IGate
    %endrep
	
	;键盘中断向量(8259A 键盘中断向量0x20,IRQ1 是键盘中断请求,0x20 + IRQ[n] = 0x21
	.0x21:
		Gate SelectorCode32, KeyboardHandler, 0, DA_386IGate
		
	%rep 10
		Gate SelectorCode32, SpuriousHandler, 0, DA_386IGate
	%endrep
	
	;从中断控制器8259A 中断向量0x28,IRQ4 是鼠标中断请求,0x28 + IRQ[n] = 0x2c
	.0x2c:
		Gate SelectorCode32, MouseHandler, 0, DA_386IGate

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

	;向主8259A发生ICW1
	;011h 对应的二进制是00010001
	;ICW1[0]=1表示需要发送ICW4
	;ICW1[1] = 0,说明有级联8259A
	;ICW1[2] =0 表示用8字节来设置中断向量号
	;ICW1[3]=0表示中断形式是边沿触发
	;ICW[4]必须设置为1，ICW[5,6,7]必须是0
    mov al, 011h
    out 20h, al
    call io_delay
    
	;向从8259A发送ICW1
    out 0A0h, al
    call io_delay

	;向主8259A发送ICW2
	;20h 对应二进制00100000 
	;ICW2[0,1,2] = 0 
	;8259A根据被设置的起始向量号（起始向量号通过中断控制字ICW2被初始化）加上中断请求号计算出中断向量号
	;当主8259A对应的IRQ0管线向CPU发送信号时，CPU根据0x20这个值去查找要执行的代码，
	;，CPU根据0x21这个值去查找要执行的代码，依次类推。
    mov al, 020h
    out 021h, al
    call io_delay

	;向从8259A发送ICW2
	;28h 对应二进制00100100
	;8259A根据被设置的起始向量号（起始向量号通过中断控制字ICW2被初始化）加上中断请求号计算出中断向量号
	;当从8259A对应的IRQ0管线向CPU发送信号时，CPU根据0x28这个值去查找要执行的代码，
	;IRQ1管线向CPU发送信号时，CPU根据0x29这个值去查找要执行的代码，依次类推。
    mov al, 028h
    out 0A1h, al
    call io_delay

	;向主8259A发送ICW3
	;004h 00000100
	;ICW[2] = 1, 表示从8259A通过主IRQ2管线连接到主8259A控制器
    mov al, 004h
    out 021h, al
    call io_delay

	;向从8259A 发送 ICW3
	;ICW[0,1,2] = 2, 表示当前从片是从IRQ2管线接入主8259A芯片的
    mov al, 002h
    out 0A1h, al
    call io_delay

	;向主8259A发送ICW4
	;ICW4[0]=1表示当前CPU架构师80X86
	;ICW4[1]=1表示自动EOI, 如果这位设置成0的话，那么中断响应后，代码要想继续处理中断，就得主动给CPU发送一个信号，
	;如果设置成1，那么代码不用主动给CPU发送信号就可以再次处理中断。
    mov al, 002h
    out 021h, al
    call io_delay

	;向从8259A发送ICW4
    out 0A1h, al
    call io_delay

	;OCW(operation control word)
	;当OCW[i] = 1 时,屏蔽对应的IRQ(i)管线的信号
	;IRQ1对应的是键盘产生的中断
    mov al, 11111001b
    out 021h, al
    call io_delay

    ;CPU忽略所有来自从8259A芯片的信号
	;鼠标是通过从8259A的IRQ4管线向CPU发送信号
    mov al, 11101111b
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

;8259A中断控制器
LABLE_8259A:
    SpuriousHandler EQU LABLE_8259A - $$
    iretd
	
;键盘中断程序
LabelKeyboardHandler:
	KeyboardHandler EQU LabelKeyboardHandler - $$
	; 注意中断切换过程
	push es
	push ds
	pushad
	mov eax, esp
	push eax
	
	call int_keyboard
	
	pop eax
	mov esp, eax
	popad
	pop ds
	pop es
	iretd
	
;鼠标中断程序
LabelMouseHandler:
	MouseHandler EQU LabelMouseHandler - $$
	; 注意中断切换过程
	push es
	push ds
	pushad
	mov eax, esp
	push eax
	
	call int_mouse
	
	pop eax
	mov esp, eax
	popad
	pop ds
	pop es
	iretd

	
;注意汇编文件引入位置 在代码段结束符之上
%include "io.asm"
%include "os.asm"

;32位模式代码长度
SegCodeLen EQU $ - SEG_CODE32

[SECTION .gs]
    ALIGN 32
    [BITS 32]

LABLE_STACK:
    TIMES 1024 DB 0
STACK_TOP    EQU   $ - LABLE_STACK

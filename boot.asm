org  0x7c00

LOAD_ADDR EQU 0x9000 ;内核代码起始处

jmp  entry
db   0x90
DB   "OSKERNEL"
DW   512
DB   1
DW   1
DB   2
DW   224
DW   2880
DB   0xf0
DW   9
DW   18
DW   2
DD   0
DD   2880
DB   0,0,0x29
DD   0xFFFFFFF
DB   "MYFIRSTOS  "
DB   "FAT12   "
RESB  18

entry:
    mov  ax, 0
    mov  ss, ax
    mov  ds, ax
    mov  es, ax
	 
    mov          BX, LOAD_ADDR       ; ES:BX 数据存储缓冲区
    mov          CH, 1        ;CH 用来存储柱面号
    mov          DH, 0        ;DH 用来存储磁头号
    
readFloppy:
   
    cmp          byte [load_count], 0
    je           beginLoad
 
    mov          CL, 1        ;CL 用来存储扇区号

    mov          AH, 0x02      ;  AH = 02 表示要做的是读盘操作
    mov          AL,  18        ; AL 表示要练习读取几个扇区
    mov          DL, 0         ;驱动器编号，一般我们只有一个软盘驱动器，写死为0
    INT          0x13          ;调用BIOS中断实现磁盘读取功能

    inc          CH
    dec          byte [load_count]
    JC           fin
    add          bx, 512 * 18
    jmp          readFloppy
    
beginLoad:
    jmp          LOAD_ADDR


load_count db 3 ;连续读取几个柱面

fin:
    HLT
    jmp  fin

;readFloppy:
;    mov ch, 1 ;磁道号cylinder

;    mov dh, 0 ;磁头号head

;    mov cl, 2 ;扇区号sector
    
;    mov bx, LOAD_ADDR ;数据存储缓冲区即将内核从该位置开始加载到内存中

;    mov ah, 0x02 ;读扇区

;    mov al, 17 ;连续读取扇区数量 读取17个扇区数

;    mov dl, 0 ;驱动器编号

;    INT 0x13 ;调用BIOS中断

;    jc fin

;    jmp LOAD_ADDR

;fin:
;    HLT
;    jmp fin
	
TIMES 0x1FE-($-$$) DB 0x00

DB 0x55, 0xAA

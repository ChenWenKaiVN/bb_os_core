org  0x7c00

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
DD   0xFFFFFFFF
DB   "MYFIRSTOS  "
DB   "FAT12   "
RESB  18

entry:
    mov  ax, 0
    mov  ss, ax
    mov  ds, ax
    mov  es, ax
    mov  si, msg

readFloppy:
    mov ch, 1 ;磁道号cylinder
    mov dh, 0 ;磁头号head
    mov cl, 2 ;扇区号sector
    
    mov bx, msg ;数据存储缓冲区
    mov ah, 0x02 ;读扇区
    mov al, 1 ;连续读取扇区数量
    mov dl, 0 ;驱动器编号

    INT 0x13 ;调用BIOS中断

    jc error

putloop:
    mov  al, [si]
    add  si, 1
    cmp  al, 0
    je   fin
    mov  ah, 0x0e
    mov  bx, 15
    int  0x10
    jmp  putloop

fin:
    HLT
    jmp  fin

error:
    mov si, errmsg
    jmp putloop

msg:
    RESB 64

errmsg:
    DB "error"

TIMES 0x1FE-($-$$) DB 0x00

DB 0x55, 0xAA

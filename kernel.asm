org 0x8000

entry:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov si, msg

putloop:
    mov al, [si]
    add si, 1
    cmp al, 0
    je fin
    mov ah, 0x0e
    mov bx, 15
    INT 0x10
    jmp putloop

fin:
    HLT
    jmp fin

msg:
    DB "This is Hello World from Kernal"

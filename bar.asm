; Disassembly of file: bar.o
; Sat Feb  8 18:33:11 2020
; Mode: 32 bits
; Syntax: YASM/NASM
; Instruction set: 80386


;global bar_func: function
;global __x86.get_pc_thunk.ax: function

extern foo_print                                        ; near
extern _GLOBAL_OFFSET_TABLE_                            ; byte


;SECTION .text   align=1 execute                         ; section number 1, code

bar_func:; Function begin
        push    ebp                                     ; 0000 _ 55
        mov     ebp, esp                                ; 0001 _ 89. E5
        push    ebx                                     ; 0003 _ 53
        sub     esp, 4                                  ; 0004 _ 83. EC, 04
        call    __x86.get_pc_thunk.ax                   ; 0007 _ E8, FFFFFFFC(rel)
        add     eax, _GLOBAL_OFFSET_TABLE_-$            ; 000C _ 05, 00000001(GOT r)
        mov     edx, dword [ebp+8H]                     ; 0011 _ 8B. 55, 08
        cmp     edx, dword [ebp+0CH]                    ; 0014 _ 3B. 55, 0C
        jle     ?_001                                   ; 0017 _ 7E, 18
        sub     esp, 8                                  ; 0019 _ 83. EC, 08
        push    13                                      ; 001C _ 6A, 0D
        lea     edx, [?_003+eax]                        ; 001E _ 8D. 90, 00000000(GOT)
        push    edx                                     ; 0024 _ 52
        mov     ebx, eax                                ; 0025 _ 89. C3
        call    foo_print                               ; 0027 _ E8, FFFFFFFC(PLT r)
        add     esp, 16                                 ; 002C _ 83. C4, 10
        jmp     ?_002                                   ; 002F _ EB, 16

?_001:  sub     esp, 8                                  ; 0031 _ 83. EC, 08
        push    13                                      ; 0034 _ 6A, 0D
        lea     edx, [?_004+eax]                        ; 0036 _ 8D. 90, 0000000D(GOT)
        push    edx                                     ; 003C _ 52
        mov     ebx, eax                                ; 003D _ 89. C3
        call    foo_print                               ; 003F _ E8, FFFFFFFC(PLT r)
        add     esp, 16                                 ; 0044 _ 83. C4, 10
?_002:  mov     eax, 0                                  ; 0047 _ B8, 00000000
        mov     ebx, dword [ebp-4H]                     ; 004C _ 8B. 5D, FC
        leave                                           ; 004F _ C9
        ret                                             ; 0050 _ C3
; bar_func End of function


SECTION .data   align=1 noexecute                       ; section number 2, data


SECTION .bss    align=1 noexecute                       ; section number 3, bss


SECTION .rodata align=1 noexecute                       ; section number 4, const

?_003:                                                  ; byte
        db 74H, 68H, 65H, 20H, 31H, 73H, 74H, 20H       ; 0000 _ the 1st 
        db 6FH, 6EH, 65H, 0AH, 00H                      ; 0008 _ one..

?_004:                                                  ; byte
        db 74H, 68H, 65H, 20H, 32H, 6EH, 64H, 20H       ; 000D _ the 2nd 
        db 6FH, 6EH, 65H, 0AH, 00H                      ; 0015 _ one..


SECTION .text.__x86.get_pc_thunk.ax align=1 execute     ; section number 5, code

__x86.get_pc_thunk.ax:; Function begin
        mov     eax, dword [esp]                        ; 0000 _ 8B. 04 24
        ret                                             ; 0003 _ C3
; __x86.get_pc_thunk.ax End of function



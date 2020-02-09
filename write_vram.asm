; Disassembly of file: write_vram.o
; Sun Feb  9 10:04:31 2020
; Mode: 32 bits
; Syntax: YASM/NASM
; Instruction set: 80386


;global showChar: function

;extern io_hlt                                           ; near


;SECTION .text   align=1 execute                         ; section number 1, code

showChar:; Function begin
        push    ebp                                     ; 0000 _ 55
        mov     ebp, esp                                ; 0001 _ 89. E5
        sub     esp, 24                                 ; 0003 _ 83. EC, 18
        mov     dword [ebp-0CH], 655360                 ; 0006 _ C7. 45, F4, 000A0000
        mov     dword [ebp-10H], 0                      ; 000D _ C7. 45, F0, 00000000
        jmp     ?_002                                   ; 0014 _ EB, 15

?_001:  mov     eax, dword [ebp-10H]                    ; 0016 _ 8B. 45, F0
        and     eax, 0FH                                ; 0019 _ 83. E0, 0F
        mov     edx, eax                                ; 001C _ 89. C2
        mov     eax, dword [ebp-0CH]                    ; 001E _ 8B. 45, F4
        mov     byte [eax], dl                          ; 0021 _ 88. 10
        add     dword [ebp-0CH], 1                      ; 0023 _ 83. 45, F4, 01
        add     dword [ebp-10H], 1                      ; 0027 _ 83. 45, F0, 01
?_002:  cmp     dword [ebp-10H], 65535                  ; 002B _ 81. 7D, F0, 0000FFFF
        jle     ?_001                                   ; 0032 _ 7E, E2
?_003:  call    io_hlt                                  ; 0034 _ E8, FFFFFFFC(rel)
        jmp     ?_003                                   ; 0039 _ EB, F9
; showChar End of function


;SECTION .data   align=1 noexecute                       ; section number 2, data


;SECTION .bss    align=1 noexecute                       ; section number 3, bss



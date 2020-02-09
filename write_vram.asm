; Disassembly of file: write_vram.o
; Sun Feb  9 16:41:27 2020
; Mode: 32 bits
; Syntax: YASM/NASM
; Instruction set: Pentium Pro


;global kernel_main: function
;global initPallet: function
;global draw_simple: function
;global fillRect: function
;global draw_rectangle: function
;global draw_desktop: function

;extern io_writeFlag                                     ; near
;extern io_out8                                          ; near
;extern io_cli                                           ; near
;extern io_readFlag                                      ; near
;extern io_hlt                                           ; near


;SECTION .text   align=1 execute                         ; section number 1, code

kernel_main:; Function begin
        push    ebp                                     ; 0000 _ 55
        mov     ebp, esp                                ; 0001 _ 89. E5
        sub     esp, 8                                  ; 0003 _ 83. EC, 08
        call    initPallet                              ; 0006 _ E8, FFFFFFFC(rel)
        call    draw_desktop                            ; 000B _ E8, FFFFFFFC(rel)
?_001:  call    io_hlt                                  ; 0010 _ E8, FFFFFFFC(rel)
        jmp     ?_001                                   ; 0015 _ EB, F9
; kernel_main End of function

initPallet:; Function begin
        push    ebp                                     ; 0017 _ 55
        mov     ebp, esp                                ; 0018 _ 89. E5
        sub     esp, 24                                 ; 001A _ 83. EC, 18
        mov     dword [ebp-14H], table_rgb.1988         ; 001D _ C7. 45, EC, 00000000(d)
        call    io_readFlag                             ; 0024 _ E8, FFFFFFFC(rel)
        mov     dword [ebp-0CH], eax                    ; 0029 _ 89. 45, F4
        call    io_cli                                  ; 002C _ E8, FFFFFFFC(rel)
        sub     esp, 8                                  ; 0031 _ 83. EC, 08
        push    0                                       ; 0034 _ 6A, 00
        push    968                                     ; 0036 _ 68, 000003C8
        call    io_out8                                 ; 003B _ E8, FFFFFFFC(rel)
        add     esp, 16                                 ; 0040 _ 83. C4, 10
        mov     dword [ebp-10H], 0                      ; 0043 _ C7. 45, F0, 00000000
        jmp     ?_003                                   ; 004A _ E9, 0000008C

?_002:  mov     edx, dword [ebp-10H]                    ; 004F _ 8B. 55, F0
        mov     eax, dword [ebp-14H]                    ; 0052 _ 8B. 45, EC
        add     eax, edx                                ; 0055 _ 01. D0
        movzx   eax, byte [eax]                         ; 0057 _ 0F B6. 00
        lea     edx, [eax+3H]                           ; 005A _ 8D. 50, 03
        test    al, al                                  ; 005D _ 84. C0
        cmovs   eax, edx                                ; 005F _ 0F 48. C2
        sar     al, 2                                   ; 0062 _ C0. F8, 02
        movsx   eax, al                                 ; 0065 _ 0F BE. C0
        sub     esp, 8                                  ; 0068 _ 83. EC, 08
        push    eax                                     ; 006B _ 50
        push    777                                     ; 006C _ 68, 00000309
        call    io_out8                                 ; 0071 _ E8, FFFFFFFC(rel)
        add     esp, 16                                 ; 0076 _ 83. C4, 10
        mov     eax, dword [ebp-10H]                    ; 0079 _ 8B. 45, F0
        lea     edx, [eax+1H]                           ; 007C _ 8D. 50, 01
        mov     eax, dword [ebp-14H]                    ; 007F _ 8B. 45, EC
        add     eax, edx                                ; 0082 _ 01. D0
        movzx   eax, byte [eax]                         ; 0084 _ 0F B6. 00
        lea     edx, [eax+3H]                           ; 0087 _ 8D. 50, 03
        test    al, al                                  ; 008A _ 84. C0
        cmovs   eax, edx                                ; 008C _ 0F 48. C2
        sar     al, 2                                   ; 008F _ C0. F8, 02
        movsx   eax, al                                 ; 0092 _ 0F BE. C0
        sub     esp, 8                                  ; 0095 _ 83. EC, 08
        push    eax                                     ; 0098 _ 50
        push    777                                     ; 0099 _ 68, 00000309
        call    io_out8                                 ; 009E _ E8, FFFFFFFC(rel)
        add     esp, 16                                 ; 00A3 _ 83. C4, 10
        mov     eax, dword [ebp-10H]                    ; 00A6 _ 8B. 45, F0
        lea     edx, [eax+2H]                           ; 00A9 _ 8D. 50, 02
        mov     eax, dword [ebp-14H]                    ; 00AC _ 8B. 45, EC
        add     eax, edx                                ; 00AF _ 01. D0
        movzx   eax, byte [eax]                         ; 00B1 _ 0F B6. 00
        lea     edx, [eax+3H]                           ; 00B4 _ 8D. 50, 03
        test    al, al                                  ; 00B7 _ 84. C0
        cmovs   eax, edx                                ; 00B9 _ 0F 48. C2
        sar     al, 2                                   ; 00BC _ C0. F8, 02
        movsx   eax, al                                 ; 00BF _ 0F BE. C0
        sub     esp, 8                                  ; 00C2 _ 83. EC, 08
        push    eax                                     ; 00C5 _ 50
        push    777                                     ; 00C6 _ 68, 00000309
        call    io_out8                                 ; 00CB _ E8, FFFFFFFC(rel)
        add     esp, 16                                 ; 00D0 _ 83. C4, 10
        add     dword [ebp-14H], 3                      ; 00D3 _ 83. 45, EC, 03
        add     dword [ebp-10H], 1                      ; 00D7 _ 83. 45, F0, 01
?_003:  cmp     dword [ebp-10H], 15                     ; 00DB _ 83. 7D, F0, 0F
        jle     ?_002                                   ; 00DF _ 0F 8E, FFFFFF6A
        sub     esp, 12                                 ; 00E5 _ 83. EC, 0C
        push    dword [ebp-0CH]                         ; 00E8 _ FF. 75, F4
        call    io_writeFlag                            ; 00EB _ E8, FFFFFFFC(rel)
        add     esp, 16                                 ; 00F0 _ 83. C4, 10
        nop                                             ; 00F3 _ 90
        leave                                           ; 00F4 _ C9
        ret                                             ; 00F5 _ C3
; initPallet End of function

draw_simple:; Function begin
        push    ebp                                     ; 00F6 _ 55
        mov     ebp, esp                                ; 00F7 _ 89. E5
        sub     esp, 16                                 ; 00F9 _ 83. EC, 10
        mov     dword [ebp-8H], 655360                  ; 00FC _ C7. 45, F8, 000A0000
        mov     dword [ebp-4H], 0                       ; 0103 _ C7. 45, FC, 00000000
        jmp     ?_005                                   ; 010A _ EB, 15

?_004:  mov     eax, dword [ebp-4H]                     ; 010C _ 8B. 45, FC
        and     eax, 0FH                                ; 010F _ 83. E0, 0F
        mov     edx, eax                                ; 0112 _ 89. C2
        mov     eax, dword [ebp-8H]                     ; 0114 _ 8B. 45, F8
        mov     byte [eax], dl                          ; 0117 _ 88. 10
        add     dword [ebp-8H], 1                       ; 0119 _ 83. 45, F8, 01
        add     dword [ebp-4H], 2                       ; 011D _ 83. 45, FC, 02
?_005:  cmp     dword [ebp-4H], 65535                   ; 0121 _ 81. 7D, FC, 0000FFFF
        jle     ?_004                                   ; 0128 _ 7E, E2
        nop                                             ; 012A _ 90
        leave                                           ; 012B _ C9
        ret                                             ; 012C _ C3
; draw_simple End of function

fillRect:; Function begin
        push    ebp                                     ; 012D _ 55
        mov     ebp, esp                                ; 012E _ 89. E5
        sub     esp, 20                                 ; 0130 _ 83. EC, 14
        mov     eax, dword [ebp+18H]                    ; 0133 _ 8B. 45, 18
        mov     byte [ebp-14H], al                      ; 0136 _ 88. 45, EC
        mov     dword [ebp-4H], 655360                  ; 0139 _ C7. 45, FC, 000A0000
        mov     eax, dword [ebp+0CH]                    ; 0140 _ 8B. 45, 0C
        mov     dword [ebp-0CH], eax                    ; 0143 _ 89. 45, F4
        jmp     ?_009                                   ; 0146 _ EB, 3E

?_006:  mov     eax, dword [ebp+8H]                     ; 0148 _ 8B. 45, 08
        mov     dword [ebp-8H], eax                     ; 014B _ 89. 45, F8
        jmp     ?_008                                   ; 014E _ EB, 25

?_007:  mov     edx, dword [ebp-0CH]                    ; 0150 _ 8B. 55, F4
        mov     eax, edx                                ; 0153 _ 89. D0
        shl     eax, 2                                  ; 0155 _ C1. E0, 02
        add     eax, edx                                ; 0158 _ 01. D0
        shl     eax, 6                                  ; 015A _ C1. E0, 06
        mov     edx, eax                                ; 015D _ 89. C2
        mov     eax, dword [ebp-8H]                     ; 015F _ 8B. 45, F8
        add     eax, edx                                ; 0162 _ 01. D0
        mov     edx, eax                                ; 0164 _ 89. C2
        mov     eax, dword [ebp-4H]                     ; 0166 _ 8B. 45, FC
        add     edx, eax                                ; 0169 _ 01. C2
        movzx   eax, byte [ebp-14H]                     ; 016B _ 0F B6. 45, EC
        mov     byte [edx], al                          ; 016F _ 88. 02
        add     dword [ebp-8H], 1                       ; 0171 _ 83. 45, F8, 01
?_008:  mov     edx, dword [ebp+8H]                     ; 0175 _ 8B. 55, 08
        mov     eax, dword [ebp+10H]                    ; 0178 _ 8B. 45, 10
        add     eax, edx                                ; 017B _ 01. D0
        cmp     dword [ebp-8H], eax                     ; 017D _ 39. 45, F8
        jle     ?_007                                   ; 0180 _ 7E, CE
        add     dword [ebp-0CH], 1                      ; 0182 _ 83. 45, F4, 01
?_009:  mov     edx, dword [ebp+0CH]                    ; 0186 _ 8B. 55, 0C
        mov     eax, dword [ebp+14H]                    ; 0189 _ 8B. 45, 14
        add     eax, edx                                ; 018C _ 01. D0
        cmp     dword [ebp-0CH], eax                    ; 018E _ 39. 45, F4
        jle     ?_006                                   ; 0191 _ 7E, B5
        nop                                             ; 0193 _ 90
        leave                                           ; 0194 _ C9
        ret                                             ; 0195 _ C3
; fillRect End of function

draw_rectangle:; Function begin
        push    ebp                                     ; 0196 _ 55
        mov     ebp, esp                                ; 0197 _ 89. E5
        push    1                                       ; 0199 _ 6A, 01
        push    100                                     ; 019B _ 6A, 64
        push    100                                     ; 019D _ 6A, 64
        push    30                                      ; 019F _ 6A, 1E
        push    10                                      ; 01A1 _ 6A, 0A
        call    fillRect                                ; 01A3 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 01A8 _ 83. C4, 14
        push    2                                       ; 01AB _ 6A, 02
        push    100                                     ; 01AD _ 6A, 64
        push    100                                     ; 01AF _ 6A, 64
        push    80                                      ; 01B1 _ 6A, 50
        push    50                                      ; 01B3 _ 6A, 32
        call    fillRect                                ; 01B5 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 01BA _ 83. C4, 14
        push    4                                       ; 01BD _ 6A, 04
        push    100                                     ; 01BF _ 6A, 64
        push    100                                     ; 01C1 _ 6A, 64
        push    100                                     ; 01C3 _ 6A, 64
        push    100                                     ; 01C5 _ 6A, 64
        call    fillRect                                ; 01C7 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 01CC _ 83. C4, 14
        nop                                             ; 01CF _ 90
        leave                                           ; 01D0 _ C9
        ret                                             ; 01D1 _ C3
; draw_rectangle End of function

draw_desktop:; Function begin
        push    ebp                                     ; 01D2 _ 55
        mov     ebp, esp                                ; 01D3 _ 89. E5
        push    14                                      ; 01D5 _ 6A, 0E
        push    171                                     ; 01D7 _ 68, 000000AB
        push    319                                     ; 01DC _ 68, 0000013F
        push    0                                       ; 01E1 _ 6A, 00
        push    0                                       ; 01E3 _ 6A, 00
        call    fillRect                                ; 01E5 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 01EA _ 83. C4, 14
        push    15                                      ; 01ED _ 6A, 0F
        push    28                                      ; 01EF _ 6A, 1C
        push    319                                     ; 01F1 _ 68, 0000013F
        push    172                                     ; 01F6 _ 68, 000000AC
        push    0                                       ; 01FB _ 6A, 00
        call    fillRect                                ; 01FD _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 0202 _ 83. C4, 14
        push    15                                      ; 0205 _ 6A, 0F
        push    1                                       ; 0207 _ 6A, 01
        push    320                                     ; 0209 _ 68, 00000140
        push    173                                     ; 020E _ 68, 000000AD
        push    0                                       ; 0213 _ 6A, 00
        call    fillRect                                ; 0215 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 021A _ 83. C4, 14
        push    8                                       ; 021D _ 6A, 08
        push    25                                      ; 021F _ 6A, 19
        push    320                                     ; 0221 _ 68, 00000140
        push    174                                     ; 0226 _ 68, 000000AE
        push    0                                       ; 022B _ 6A, 00
        call    fillRect                                ; 022D _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 0232 _ 83. C4, 14
        push    7                                       ; 0235 _ 6A, 07
        push    1                                       ; 0237 _ 6A, 01
        push    56                                      ; 0239 _ 6A, 38
        push    176                                     ; 023B _ 68, 000000B0
        push    3                                       ; 0240 _ 6A, 03
        call    fillRect                                ; 0242 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 0247 _ 83. C4, 14
        push    7                                       ; 024A _ 6A, 07
        push    20                                      ; 024C _ 6A, 14
        push    1                                       ; 024E _ 6A, 01
        push    176                                     ; 0250 _ 68, 000000B0
        push    2                                       ; 0255 _ 6A, 02
        call    fillRect                                ; 0257 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 025C _ 83. C4, 14
        push    15                                      ; 025F _ 6A, 0F
        push    1                                       ; 0261 _ 6A, 01
        push    56                                      ; 0263 _ 6A, 38
        push    196                                     ; 0265 _ 68, 000000C4
        push    3                                       ; 026A _ 6A, 03
        call    fillRect                                ; 026C _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 0271 _ 83. C4, 14
        push    15                                      ; 0274 _ 6A, 0F
        push    19                                      ; 0276 _ 6A, 13
        push    1                                       ; 0278 _ 6A, 01
        push    177                                     ; 027A _ 68, 000000B1
        push    59                                      ; 027F _ 6A, 3B
        call    fillRect                                ; 0281 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 0286 _ 83. C4, 14
        push    0                                       ; 0289 _ 6A, 00
        push    0                                       ; 028B _ 6A, 00
        push    57                                      ; 028D _ 6A, 39
        push    197                                     ; 028F _ 68, 000000C5
        push    2                                       ; 0294 _ 6A, 02
        call    fillRect                                ; 0296 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 029B _ 83. C4, 14
        push    0                                       ; 029E _ 6A, 00
        push    19                                      ; 02A0 _ 6A, 13
        push    0                                       ; 02A2 _ 6A, 00
        push    176                                     ; 02A4 _ 68, 000000B0
        push    60                                      ; 02A9 _ 6A, 3C
        call    fillRect                                ; 02AB _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 02B0 _ 83. C4, 14
        push    15                                      ; 02B3 _ 6A, 0F
        push    1                                       ; 02B5 _ 6A, 01
        push    43                                      ; 02B7 _ 6A, 2B
        push    176                                     ; 02B9 _ 68, 000000B0
        push    273                                     ; 02BE _ 68, 00000111
        call    fillRect                                ; 02C3 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 02C8 _ 83. C4, 14
        push    15                                      ; 02CB _ 6A, 0F
        push    19                                      ; 02CD _ 6A, 13
        push    0                                       ; 02CF _ 6A, 00
        push    177                                     ; 02D1 _ 68, 000000B1
        push    273                                     ; 02D6 _ 68, 00000111
        call    fillRect                                ; 02DB _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 02E0 _ 83. C4, 14
        push    7                                       ; 02E3 _ 6A, 07
        push    0                                       ; 02E5 _ 6A, 00
        push    43                                      ; 02E7 _ 6A, 2B
        push    197                                     ; 02E9 _ 68, 000000C5
        push    273                                     ; 02EE _ 68, 00000111
        call    fillRect                                ; 02F3 _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 02F8 _ 83. C4, 14
        push    7                                       ; 02FB _ 6A, 07
        push    21                                      ; 02FD _ 6A, 15
        push    0                                       ; 02FF _ 6A, 00
        push    176                                     ; 0301 _ 68, 000000B0
        push    317                                     ; 0306 _ 68, 0000013D
        call    fillRect                                ; 030B _ E8, FFFFFFFC(rel)
        add     esp, 20                                 ; 0310 _ 83. C4, 14
        nop                                             ; 0313 _ 90
        leave                                           ; 0314 _ C9
        ret                                             ; 0315 _ C3
; draw_desktop End of function


;SECTION .data   align=32 noexecute                      ; section number 2, data

table_rgb.1988:                                         ; byte
        db 00H, 00H, 00H, 0FFH, 00H, 00H, 00H, 0FFH     ; 0000 _ ........
        db 00H, 0FFH, 0FFH, 00H, 00H, 00H, 0FFH, 0FFH   ; 0008 _ ........
        db 00H, 0FFH, 00H, 0FFH, 0FFH, 0FFH, 0FFH, 0FFH ; 0010 _ ........
        db 0C6H, 0C6H, 0C6H, 84H, 00H, 00H, 00H, 84H    ; 0018 _ ........
        db 00H, 84H, 84H, 00H, 00H, 00H, 84H, 84H       ; 0020 _ ........
        db 00H, 84H, 00H, 84H, 84H, 84H, 84H, 84H       ; 0028 _ ........


;SECTION .bss    align=1 noexecute                       ; section number 3, bss



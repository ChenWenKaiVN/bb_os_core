#!/bin/bash
gcc -m32 -c -fno-asynchronous-unwind-tables -fno-pic write_vram.c -o write_vram.o
echo "gcc -m32 -c -fno-asynchronous-unwind-tables -fno-pic write_vram.c -o write_vram.o"
./objconv -fnasm write_vram.o -o write_vram.asm
echo "./objconv -fnasm write_vram.o -o write_vram.asm"
gcc processAsm.c -o processAsm
echo "gcc processAsm.c -o processAsm"
./processAsm write_vram.asm write_vram_tmp.asm
echo "./processAsm write_vram.asm write_vram_tmp.asm"
rm -rf write_vram.asm
echo "rm -rf write_vram.asm"
mv write_vram_tmp.asm write_vram.asm
echo "mv write_vram_tmp.asm write_vram.asm"
nasm boot.asm
echo "nasm boot.asm"
nasm kernel.asm
echo "nasm kernel.asm"
gcc floppy.c makeFloppy.c -o makeFloppy
echo "gcc floppy.c makeFloppy.c -o makeFloppy"
./makeFloppy boot kernel system.img
echo "./makeFloppy boot kernel system.img"
rm -rf boot kernel makeFloppy processAsm write_vram.asm write_vram.o
echo "rm -rf boot kernel makeFloppy processAsm write_vram.asm write_vram.o"
echo "make floppy success"
#!/bin/bash
gcc -m32 -fno-asynchronous-unwind-tables -fno-pic -s -c -o mem_util.o mem_util.c
echo "gcc -m32 -fno-asynchronous-unwind-tables -s -c -o mem_util.o mem_util.c"
gcc -m32 -c -fno-asynchronous-unwind-tables -fno-pic os.c -o os.o
echo "gcc -m32 -c -fno-asynchronous-unwind-tables -fno-pic os.c -o os.o"
ld -m elf_i386 -r os.o mem_util.o -o ckernel.o
echo "ld -m elf_i386 -r os.o mem_util.o -o ckernel.o"
./objconv -fnasm ckernel.o -o os.asm
echo "./objconv -fnasm os.o -o os.asm"
gcc processAsm.c -o processAsm
echo "gcc processAsm.c -o processAsm"
./processAsm os.asm os_tmp.asm
echo "./processAsm os.asm os_tmp.asm"
rm -rf os.asm
echo "rm -rf os.asm"
mv os_tmp.asm os.asm
echo "mv os_tmp.asm os.asm"
nasm boot.asm
echo "nasm boot.asm"
nasm kernel.asm
echo "nasm kernel.asm"
gcc floppy.c makeFloppy.c -o makeFloppy
echo "gcc floppy.c makeFloppy.c -o makeFloppy"
./makeFloppy boot kernel system.img
echo "./makeFloppy boot kernel system.img"
rm -rf boot kernel makeFloppy processAsm os.asm os.o mem_util.o ckernel.o
echo "rm -rf boot kernel makeFloppy processAsm os.asm os.o mem_util.o ckernel.o"
echo "make floppy success"

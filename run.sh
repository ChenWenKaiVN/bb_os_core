#!/bin/bash
nasm boot.asm
echo "nasm boot.asm"
nasm kernel.asm
echo "nasm kernel.asm"
gcc floppy.c makeFloppy.c -o makeFloppy
echo "gcc floppy.c makeFloppy.c -o makeFloppy"
./makeFloppy boot kernel system.img
echo "./makeFloppy boot kernel system.img"

#!/bin/bash
nasm boot.asm
echo "nasm boot.asm"
gcc floppy.c makeFloppy.c -o makeFloppy
echo "gcc floppy.c makeFloppy.c -o makeFloppy"
./makeFloppy boot system.img
echo "./makeFloppy boot system.img"

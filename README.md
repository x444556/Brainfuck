# Brainfuck
Brainfuck implemented in x64 NASM for Linux

test.c contains a few examples

nasm -f elf64 brainfuck.asm
gcc -no-pie brainfuck.o test.c

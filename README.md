# Brainfuck
Brainfuck implemented in x64 NASM for Linux

test.c contains a few examples

brainfuck() returns 0 on success!

1) nasm -f elf64 brainfuck.asm
2) gcc -no-pie brainfuck.o test.c

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

extern uint64_t brainfuck(char* code, uint64_t code_len, char* memory, uint64_t memory_len, char (*readInputFunc)());
extern uint64_t testSyntax(char* code, uint64_t length);

char* hw = "Hello World!";
char hwlen = 12;
char ind =0;
char readInput(){
	char r = hw[ind];
	ind++;
	if(ind >= hwlen) ind = 0;
	return r;
}

char bf_add(char c0, char c1){
	char* code = "[>+<-]"; // ADD mem[0] + mem[1] -> mem[1]		mem_len >= 2
	uint64_t code_len = 6;
	
	char memory[2];
	
	memory[0] = c0;
	memory[1] = c1;
	
	brainfuck(code, code_len, memory, 2, NULL);
	
	return memory[1];
}
char bf_sub(char c0, char c1){
	char* code = "[>-<-]"; // SUB mem[1] - mem[0] -> mem[1]		mem_len >= 2
	uint64_t code_len = 6;
	
	char memory[2];
	
	memory[0] = c1;
	memory[1] = c0;
	
	brainfuck(code, code_len, memory, 2, NULL);
	
	return memory[1];
}
char bf_mul(char c0, char c1){
	char* code = "[>[>+>+<<-]>>[<<+>>-]<<<-]"; // MUL mem[0] * mem[1] -> mem[2]			mem_len >= 5
	uint64_t code_len = 26;
	
	char memory[5];
	
	memory[0] = c0;
	memory[1] = c1;
	
	brainfuck(code, code_len, memory, 5, NULL);
	
	return memory[2];
}
char bf_parseDigit(char digit){
	char* code = "[>-<-]";
	uint64_t code_len = 6;
	
	char memory[2];
	
	memory[0] = '0';
	memory[1] = digit;
	
	brainfuck(code, code_len, memory, 2, NULL);
	
	return memory[1];
}
int main() {
	// char* code = "[>,.<-]"; // print readInput()
	// brainfuck(code, code_len, memory, memory_len, &readInput)
	
	printf("10 * (20 + 5) = %i\n", (unsigned char)bf_mul(10, bf_add(20, 5)));
	printf("10 - 6 = %i\n", bf_sub(10, 6));
	printf("6 - 10 = %i\n", bf_sub(6, 10));
	printf("10 + 6 = %i\n", bf_add(10, 6));
	
	printf("10 * 0 = %i\n", bf_mul(10, 0));
	printf("0 * 10 = %i\n", bf_mul(0, 10));
	printf("10 - 0 = %i\n", bf_sub(10, 0));
	printf("0 - 10 = %i\n", bf_sub(0, 10));
	printf("10 + 0 = %i\n", bf_add(10, 0));
	printf("0 + 10 = %i\n", bf_add(0, 10));
	
	printf("\n%i\n", bf_parseDigit('9'));
	printf("%i\n", bf_parseDigit('3'));
	printf("%i\n", bf_parseDigit('0'));
	
	printf("\n%i\n", bf_parseDigit('a'));
	printf("%i\n\n", bf_parseDigit('.'));
	
	
	char* code = ">>>>[<<<<[>>,.<+<-]>[<+>-]>>.>-]";
	char memory[] = {12, 0, 0, '\n', 5};
	brainfuck(code,32, memory, 5, &readInput);
	printf("\n");
	
	/*for(int i=0; i<5; i++) printf("%3i ", (unsigned char)memory[i]);
	printf("\n");*/
	
	return 0;
}


[BITS 64]

; Import + Export
    GLOBAL brainfuck
    GLOBAL testSyntax
    
    EXTERN printf

section .data

NULL                EQU 0
printChar			db '%c', 0

section .text

testSyntax:
	; rdi = char* code
	; rsi = uint64_t length
	xor rcx, rcx
	xor rax, rax
	.next:
		cmp BYTE [rdi + rcx], '['
		jne .ne
			inc rax
			jmp .ne2
		.ne:
		cmp BYTE [rdi + rcx], ']'
		jne .ne2
			dec rax
		.ne2:
		
		inc rcx
		cmp rcx, rsi
		jl .next
	ret
brainfuck:
	; rdi = char* code
	; rsi = uint64_t length
	; rdx = char* memory
	; rcx = uint64_t memory length
	; R8  = read Input Function*
	
	push rbp
	mov rbp, rsp
	
	sub rsp, 32
	mov QWORD [rbp - 8], 0 ; instruction counter
	mov QWORD [rbp - 16], 0 ; memory position
	mov QWORD [rbp - 24], R8
	
	;sub rsp, 8 ; align to 16 byte
	
	mov R8, rdx ; char* memory
	mov R9, rcx ; uint64_t memory length
	
	.next:
		push rdi
		push rsi
		push R8
		push R9
	
		mov rcx, QWORD [rbp - 8]
		cmp BYTE [rdi + rcx], '>'
		jne .n0
			inc QWORD [rbp - 16]
			cmp QWORD [rbp - 16], R9
			jge .retInvAddr
			jmp .endif
		.n0:
		
		cmp BYTE [rdi + rcx], '<'
		jne .n1
			cmp QWORD [rbp - 16], 0
			je .retInvAddr
			dec QWORD [rbp - 16]
			jmp .endif
		.n1:
		
		cmp BYTE [rdi + rcx], '+'
		jne .n2
			mov rdx, QWORD [rbp - 16]
			inc BYTE [R8 + rdx]
			jmp .endif
		.n2:
		
		cmp BYTE [rdi + rcx], '-'
		jne .n3
			mov rdx, QWORD [rbp - 16]
			dec BYTE [R8 + rdx]
			jmp .endif
		.n3:
		
		cmp BYTE [rdi + rcx], '.'
		jne .n4
			mov rdi, printChar
			mov rdx, QWORD [rbp - 16]
			movzx rsi, BYTE [R8 + rdx]
			call printf
			jmp .endif
		.n4:
		
		cmp BYTE [rdi + rcx], ','
		jne .n5
			push R8
			call QWORD [rbp - 24]
			pop R8
			mov rdx, QWORD [rbp - 16]
			mov BYTE [R8 + rdx], AL
			jmp .endif
		.n5:
		
		cmp BYTE [rdi + rcx], '['
		jne .n6
			mov rdx, QWORD [rbp - 16]
			mov DL, BYTE [R8 + rdx]
			cmp DL, 0
			jne .n6
				xor rax, rax
				.tnext:
					cmp BYTE[rdi + rcx], '['
					jne .sk
						inc rax
						jmp .sk2
					.sk:
					cmp BYTE[rdi + rcx], ']'
					jne .sk2
						dec rax
					.sk2:
					inc rcx
					cmp rax, 0
					jne .tnext
				dec rcx
				mov QWORD [rbp - 8], rcx
			jmp .endif
		.n6:
		
		cmp BYTE [rdi + rcx], ']'
		jne .n7
			mov rdx, QWORD [rbp - 16]
			mov DL, BYTE [R8 + rdx]
			cmp DL, 0
			je .n7
				xor rax, rax
				.tnext_2:
					cmp BYTE[rdi + rcx], '['
					jne .sk_2
						dec rax
						jmp .sk2_2
					.sk_2:
					cmp BYTE[rdi + rcx], ']'
					jne .sk2_2
						inc rax
					.sk2_2:
					dec rcx
					cmp rax, 0
					jne .tnext_2
				inc rcx
				mov QWORD [rbp - 8], rcx
			jmp .endif
		.n7:
		
		.endif:
		pop R9
		pop R8
		pop rsi
		pop rdi
		
		inc QWORD [rbp - 8]
		cmp QWORD [rbp - 8], rsi
		jne .next
	
	.end:
	xor rax, rax
	mov rsp, rbp
	pop rbp
	ret
	
	.retInvAddr:
	mov rax, 1
	mov rsp, rbp
	pop rbp
	ret
	
	

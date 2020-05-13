section .bss
    M: resq 1
    len: resq 1
section .data
    format_scan: db "%ld%c" ,0
    format_print: db "%ld ",0
    format_nl: db "" ,10 , 0
section .text
    extern printf, scanf, calloc, realloc, free
    global main_loop
    global print_loop
    global scan_loop
    global main
    
    
    
main:
    push rbp
    mov rbp, rsp
    call scan_loop
    mov rdi, qword [M]
    mov rsi, qword [len]
    call main_loop
    mov rdi, qword [M]
    mov rsi, qword [len]
    call print_loop
    mov rdi, qword [M]
    call free
    mov     rsp, rbp
    pop     rbp
    ret
 
 
 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SCAN_LOOP;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

scan_loop:
        push rbp
	mov rbp, rsp
	
calloc_:
        mov rdi, 4096 ;;MAX_PHYSICAL_MEMORY
        mov rsi, 8
        call calloc
        mov qword [M], rax
        mov rbx, qword [M]
        mov r12, 0
	
scan:
        push r12
        mov rax,0
        mov rdi, format_scan
        lea r9, [rbx+r12*8]
        mov rsi, r9 
        call scanf
        and eax,eax    ;; check if the result is -1 == EOF
        js later        ;; jump if sign == if neg num
        pop r12
        inc r12
        jmp scan
	
	
	
later:
        mov qword [len],r12
	;lea rsi, [r12*8]
        ;mov rdi, qword [M]
	;call realloc
	
	
	
end3:
        mov     rsp, rbp
        pop     rbp
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PRINT_LOOP;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_loop:
        push rbp
	mov rbp, rsp
	mov rbx, rdi
	mov r11, rsi
	mov r12, 0
print:
        push r11
        push r12
        mov rdi, format_print
        mov rsi, [rbx+r12*8]
        call printf
        pop r12
        pop r11
        inc r12
        cmp r12, r11
        jl print


        mov rdi, format_nl
        call printf

end2:
        mov     rsp, rbp
        pop     rbp
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAIN_LOOP;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main_loop:              		;; arg(M_ptr,length)
        push rbp
	mov rbp, rsp
	sub rsi, 2
	mov rcx, 0
	

sic_loop:

	test:
		mov rbx, qword [rdi+rcx*8]
		add rbx, qword [rdi+rcx*8+8] 
		add rbx, qword [rdi+rcx*8+16]
		cmp rbx, 0
		je end1
	if:     
		test_if:	
				mov rbx, qword [rdi+rcx*8]
				lea r9, [rdi+rbx*8]
		 		mov rbx, qword [rdi+rcx*8+8]
				mov r10, qword [rdi+rbx*8]
				sub qword [r9],r10
				cmp qword [r9], 0
				jge else
		mov rdx, qword [rdi+rcx*8+16]
		mov rcx, rdx
		jmp then
		
	else:   
		add rcx, 3
	then:   
		cmp rcx,rsi
		jl sic_loop
	

end1:
	
        mov     rsp, rbp
        pop     rbp
	ret





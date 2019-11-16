; Just throwing all my logging functions in here

section .text

interpreter_log:
    push rbp
    mov rbp, rsp
    sub rsp, 18h

    mov QWORD [rbp - 8], rsi
    mov QWORD [rbp - 16], rdx

    ; Check if we have debug mode enabled
    mov al, [rel is_db]
    movzx ecx, al
    cmp ecx, byte 0x1
    jne interpreter_log_end

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, IT_log_leadin ; "[Interpreter] "
    mov rdx, IT_log_leadin_len ; len(IT_log_leadin)
    syscall ; syscall

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, QWORD [rbp - 8] ; 
    mov rdx, QWORD [rbp - 16] ;
    syscall ; syscall

interpreter_log_end:
    mov rsp, rbp
    pop rbp
    ret

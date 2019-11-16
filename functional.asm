section .data
    func_1_len: dq 0
    func_2_len: dq 0
    func_3_len: dq 0
    func_4_len: dq 0
    func_5_len: dq 0
    func_6_len: dq 0
    func_7_len: dq 0
    func_8_len: dq 0

    func_prompt: db "f> "
    func_prompt_len: equ $-func_prompt

section .bss
    ; Just close your eyes for this
    ; It isn't pretty

    ; I'm thinking about this about one hour after this implementation
    ; Realizing I could just store a single buffer for each
    ; function and then a list of offsets for each command entered
    ; This would allow more variable function lengths
    ; but more importantly make the code way shorter (as all the call/write
    ; logic would be handled by a loop referencing the last offset)
    func_1 resb 256
    func_2 resb 256
    func_3 resb 256
    func_4 resb 256
    func_5 resb 256
    func_6 resb 256
    func_7 resb 256
    func_8 resb 256

section .text

print_func_prompt:
    push rbp
    mov rbp, rsp
    mov rax, 0x2000004
    mov rdi, 1
    mov rsi, func_prompt
    mov rdx, func_prompt_len
    syscall
    pop rbp
    ret

define_func:
    push rbp
    mov rbp, rsp

    call print_func_prompt
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, func_1
    mov rdx, 256
    syscall
    dec rax
    mov QWORD [rel func_1_len], rax

    call print_func_prompt
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, func_2
    mov rdx, 256
    syscall
    dec rax
    mov QWORD [rel func_2_len], rax

    call print_func_prompt
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, func_3
    mov rdx, 256
    syscall
    dec rax
    mov QWORD [rel func_3_len], rax

    call print_func_prompt
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, func_4
    mov rdx, 256
    syscall
    dec rax
    mov QWORD [rel func_4_len], rax

    call print_func_prompt
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, func_5
    mov rdx, 256
    syscall
    dec rax
    mov QWORD [rel func_5_len], rax

    call print_func_prompt
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, func_6
    mov rdx, 256
    syscall
    dec rax
    mov QWORD [rel func_6_len], rax

    call print_func_prompt
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, func_7
    mov rdx, 256
    syscall
    dec rax
    mov QWORD [rel func_7_len], rax

    call print_func_prompt
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, func_8
    mov rdx, 256
    syscall
    dec rax
    mov QWORD [rel func_8_len], rax

    mov rsp, rbp
    pop rbp
    ret

call_function:
    push rbp
    mov rbp, rsp
    
    mov rax, func_1
    mov rdi, [rel func_1_len]
    call execute
    mov rax, func_2
    mov rdi, [rel func_2_len]
    call execute
    mov rax, func_3
    mov rdi, [rel func_3_len]
    call execute
    mov rax, func_4
    mov rdi, [rel func_4_len]
    call execute
    mov rax, func_5
    mov rdi, [rel func_5_len]
    call execute
    mov rax, func_6
    mov rdi, [rel func_6_len]
    call execute
    mov rax, func_7
    mov rdi, [rel func_7_len]
    call execute
    mov rax, func_8
    mov rdi, [rel func_8_len]
    call execute
    
    mov rsp, rbp
    pop rbp
    ret

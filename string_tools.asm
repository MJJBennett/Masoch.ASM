; string_tools.asm
; Defines a limited set of tools for string parsing and comprehension.
; Note: The limit is your imagination.

section .data
    ; This message is printed for debugging reasons
    test_msg_st: db "Test message THIS IS A TEST", 0x0a
    test_msg_len_st: equ $-test_msg

section .text
    ; Library code!

string_tools_test:
    ; Just print a test message for now
    push rbp
    mov rbp, rsp

    ; Syscall 4 - SYS_WRITE
    mov rax, 0x2000004
    ; rdi = 1 - STDOUT
    mov rdi, 1
    ; rsi = prompt - "> "
    mov rsi, test_msg_st
    ; rdx = prompt_len - 2
    mov rdx, test_msg_len_st
    ; x64 equivalent of int 80h
    syscall

    pop rbp
    ret

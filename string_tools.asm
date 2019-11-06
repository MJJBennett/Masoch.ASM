; string_tools.asm
; Defines a limited set of tools for string parsing and comprehension.
; Note: The limit is your imagination.

section .data
    ; This message is printed for debugging reasons
    test_msg_st: db "String Tools test message.", 0x0a
    test_msg_len_st: equ $-test_msg_st

section .text
    ; Library code!

string_tools_test:
    push rbp
    mov rbp, rsp

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, test_msg_st ; "String Tools test message."
    mov rdx, test_msg_len_st ; len(test_msg_st)
    syscall ; syscall

    pop rbp
    ret

; An assembly file has three sections: 
; .data stores constant information
; .bss stores uninitialized variables
; .text stores actual code we use
; A section declaration is preceded by 'section'

; String parsing/comprehension tools
%include "string_tools.asm"
; String constants
%include "constants.asm"
; IO tooling
%include "io.asm"

section .data
    ; These are interpreter-specific strings for commands
    ; Still figuring out what a fast naming scheme would look like
    ; This is ugly but relatively short
    it_db_s: db "db"
    it_db_sl: equ $-it_db_s
    it_exit_s: db "exit"
    it_exit_sl: equ $-it_exit_s

section .text
    ; Declare our entry point
    ; Note: This nasm, ld, and OS combination seems to 
    ; implicitly use _main, which is why it's used here.
    ; Another entry point would require an additional commandline argument.
    global _main

_main:
    ; This appears to be useless alignment but hey
    push rbp
    mov rbp, rsp
    sub rsp, 10h

_main_loop:
    ; Call our get_input function
    call get_input
    ; RAX contains input length
    ; input_var contains input buffer

    ; Save RAX
    mov QWORD [rbp - 8], rax

    ; Test if it is the same as our test var 
    mov rdi, QWORD [rbp - 8]
    mov rax, input_var
    mov rsi, it_db_s
    mov rdx, it_db_sl
    call streq

    cmp rax, 1
    je _main_loop 

    ; Test if it is the same as our test var 
    mov rdi, QWORD [rbp - 8]
    mov rax, input_var
    mov rsi, it_exit_s
    mov rdx, it_exit_sl
    call streq

    cmp rax, 1
    je _main_end 

_main_end:
    mov rsp, rbp
    pop rbp
    ; Exit the program
    mov rax, 0x2000001 ; Exit syscall
    mov rdi, 0 ; argument 1: exit value, 0 for success
    syscall

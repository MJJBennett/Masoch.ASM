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
    ttt: db "ThisTest"
    ttl: equ $-ttt

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
    sub rsp, 16

    mov rdi, 6
    mov rdx, 4
    ; Call our testing method
    call streq

    ; Call our get_input function
    call get_input
    ; RAX contains input length
    ; input_var contains input buffer

    ; Test if it is the same as our test var 
    mov rdi, rax 
    mov rax, input_var
    mov rsi, ttt
    mov rdx, ttl
    call streq

    ; Exit the program
    mov rax, 0x2000001 ; Exit syscall
    mov rdi, 0 ; argument 1: exit value, 0 for success
    syscall

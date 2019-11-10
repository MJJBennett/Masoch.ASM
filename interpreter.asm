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

    ; Call our get_input function
    call get_input

    mov rdi, 4
    mov rdx, 4
    ; Call our testing method
    call streq
    mov rdi, 6
    mov rdx, 4
    ; Call our testing method
    call streq

    ; Exit the program
    mov rax, 0x2000001 ; Exit syscall
    mov rdi, 0 ; argument 1: exit value, 0 for success
    syscall

; Prints the content of input_var
; Length of input_var should be stored in RDI
print_input:
    push rbp
    mov rbp, rsp

    ; Save RDI for use below
    ; Figured out this syntax from Godbolt and cross-
    ; checking with error messages. (PTR isn't a thing
    ; in NASM, as far as I can tell)
    mov QWORD [rbp-8], rdi
    ; Note from future: Could also just use push

    mov rax, 0x2000004
    mov rdi, 1
    mov rsi, response
    mov rdx, response_len
    syscall

    mov rax, 0x2000004
    mov rdi, 1
    mov rsi, input_var
    mov rdx, QWORD [rbp-8]
    syscall

    pop rbp
    ret

print_test:
    push rbp
    mov rbp, rsp

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, test_msg ; "Test message!"
    mov rdx, test_msg_len ; len(test_msg)
    syscall ; syscall

    pop rbp
    ret

; io.asm
; Defines a limited set of tools for basic IO.
; Note: The limit is time, as we all slowly approach the
; eventual and unstoppable heat death of the universe.

section .data
    ; Input prompt
    prompt: db "> "
    prompt_len: equ $-prompt

section .bss
    ; Declare variables
    ; resb [x] reserves [x] bytes
    input_var resb 256

section .text

; The task of this function is to print "> " to the screen
; It does not print a newline afterwards.
print_prompt:
    push rbp
    mov rbp, rsp

    ; Syscall 4 - SYS_WRITE
    mov rax, 0x2000004
    ; rdi = 1 - STDOUT
    mov rdi, 1
    ; rsi = prompt - "> "
    mov rsi, prompt
    ; rdx = prompt_len - 2
    mov rdx, prompt_len
    ; x64 equivalent of int 80h
    syscall

    pop rbp
    ret

; The task of this function is to get input into input_var
; Return: rax should contain the length of input.
basic_input:
    push rbp
    mov rbp, rsp

    ; Syscall 3 - SYS_READ
    mov rax, 0x2000003
    ; rdi = 0 - STDIN
    mov rdi, 0
    ; rsi = input_var - 256 byte buffer
    mov rsi, input_var
    ; rdx = 256 - Size of buffer
    mov rdx, 256
    ; x64 equivalent of int 80h
    syscall

    ; This should leave rax set properly
    ; But for full clarity:
    mov rax, rax

    pop rbp
    ret

get_input:
    push rbp
    mov rbp, rsp

    ; Print the input prompt
    call print_prompt

    ; Get input into input_var
    call basic_input

    ; Print the user input
    mov rdi, rax
    call print_input

    pop rbp
    ret
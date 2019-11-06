; An assembly file has three sections: 
; .data stores constant information
; .bss stores uninitialized variables
; .text stores actual code we use
; A section declaration is preceded by 'section'

; String parsing/comprehension tools
%include "string_tools.asm"

section .data
    ; db stands for defined byte
    response: db "Input value: "
    ; This seems to be a bit of a hack, actually.
    ; Literally takes the difference in bytes between this location
    ; and the start of response (that is, the address at response)
    response_len: equ $-response

    prompt: db "> "
    prompt_len: equ $-prompt

    ; This message is printed for debugging reasons
    test_msg: db "Test message!", 0x0a
    test_msg_len: equ $-test_msg

section .bss
    ; Declare variables
    ; resb [x] reserves [x] bytes
    input_var resb 256

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

    ; Exit the program
    mov rax, 0x2000001 ; Exit syscall
    mov rdi, 0 ; argument 1: exit value, 0 for success
    syscall

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

trimmed_streq:
    ; Okay, I actually understand how this works now
    ; Figuring out the stack (properly) is actually a
    ; fascinating experience, like first coming to an
    ; understanding of RAII or something like that.
    ; Enlightenment!
    push rbp
    mov rbp, rsp

    pop rbp
    ret

; An assembly file has three sections: 
; .data stores constant information
; .bss stores uninitialized variables
; .text stores actual code we use
; A section declaration is preceded by 'section'

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
    input_var resb 255

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

    mov rax, 0x2000004
    mov rdi, 1
    mov rsi, test_msg
    mov rdx, test_msg_len
    syscall

    ; Exit the program
    mov rax, 0x2000001 ; Exit syscall
    mov rdi, 0 ; argument 1: exit value, 0 for success
    syscall

get_input:
    ; Not really sure what this does
    push rbp
    mov rbp, rsp

    mov rax, 0x2000004
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Get input into input_var
    mov rax, 0x2000003
    mov rdi, 0
    mov rsi, input_var
    mov rdx, 255
    syscall

    ; RAX currently stores the length of input
    ; We need to know this - save it temporarily.
    mov QWORD [rbp-8], RAX

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

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
; Function definition
%include "functional.asm"
; Loggging
%include "logging.asm"

section .data
    ; These are interpreter-specific strings for commands
    ; Still figuring out what a fast naming scheme would look like
    ; This is ugly but relatively short
    it_db_s: db "db"
    it_db_sl: equ $-it_db_s
    it_exit_s: db "exit"
    it_exit_sl: equ $-it_exit_s
    it_print_s: db "print"
    it_print_sl: equ $-it_print_s

    IT_dbenabled_s: db "Enabling debug mode.", 0x0a
    IT_dbenabled_sl: equ $-IT_dbenabled_s
    IT_dbdisabled_s: db "Disabling debug mode.", 0x0a
    IT_dbdisabled_sl: equ $-IT_dbdisabled_s

    IT_log_leadin: db "[Interpreter] "
    IT_log_leadin_len: equ $-IT_log_leadin

    is_db: db 1

section .text
    ; Declare our entry point
    ; Note: This nasm, ld, and OS combination seems to 
    ; implicitly use _main, which is why it's used here.
    ; Another entry point would require an additional commandline argument.
    global _main

_main:
    push rbp
    mov rbp, rsp
    sub rsp, 10h

_main_loop:
    ; Call our get_input function
    call get_input
    ; RAX contains input length
    ; input_var contains input buffer

    ; Save RAX (length of input)
    mov QWORD [rbp - 8], rax

    mov rax, input_var
    mov rdi, QWORD [rbp - 8]
    call execute

    ; Exit the program?
    mov rax, input_var
    mov rdi, QWORD [rbp - 8]
    mov rsi, it_exit_s
    mov rdx, it_exit_sl
    call streq

    cmp rax, 1
    je _main_end 

    ; We've reached the end of our main loop.
    jmp _main_loop

    ; Interpreter: Finish execution
_main_end:
    mov rsp, rbp
    pop rbp
    ; Exit the program
    mov rax, 0x2000001 ; Exit syscall
    mov rdi, 0 ; argument 1: exit value, 0 for success
    syscall

execute:
    ; Execute a function within the interpreter
    push rbp
    mov rbp, rsp
    sub rsp, 28h 

    mov QWORD [rbp - 8], rax
    mov QWORD [rbp - 16], rdi

    ; Enable debug mode?
    mov rax, QWORD [rbp - 8]
    mov rdi, QWORD [rbp - 16]
    mov rsi, it_db_s
    mov rdx, it_db_sl
    call streq

    cmp rax, 1
    je execute_toggle_debug

    ; Print something?
    ; startswith: does x start with y?
    ; startswith(x=RSI,x_len=RDX,y=RAX,y_len=RDI)
    mov rax, it_print_s
    mov rdi, it_print_sl
    mov rsi, input_var 
    mov rdx, QWORD [rbp - 8]
    call startswith

    cmp rax, 1
    je execute_print 

    ; Okay, we didn't do anything else, just stop
    jmp execute_end

    ; Interpreter: Toggle debug mode
execute_toggle_debug:
    mov al, [rel is_db]
    movzx ecx, al
    cmp ecx, byte 0x1
    jne execute_enable_debug
execute_disable_debug:
    mov rsi, IT_dbdisabled_s
    mov rdx, IT_dbdisabled_sl
    call interpreter_log
    mov byte [rel is_db], 0x0
    jmp execute_end
execute_enable_debug:
    mov rsi, IT_dbenabled_s
    mov rdx, IT_dbenabled_sl
    call interpreter_log
    mov byte [rel is_db], 0x1
    jmp execute_end

    ; Interpreter: Print something
execute_print:
    ; Print syntax is simple:
    ; print [...]
    ; In order to make things nice, we need to ensure
    ; that the length of the input string is at least
    ; 7, which requires at least one character following
    ; the whitespace that will be printed.
    mov rax, QWORD [rbp - 16]
    cmp rax, 7
    jl execute_end ; 7 or less characters, reloop.
    ; Otherwise, we can just go ahead and print that string
    ; Load the address of input_var+6 (to skip "print ")
    mov rax, QWORD [rbp - 8]
    lea rsi, [rax + 6] ; really happy to actually use lea
    ; The length is the length of the input, less 6
    mov rdx, QWORD [rbp - 16]
    sub rdx, 6 
    call printnof ; Print it

    jmp execute_end

execute_end:
    mov rsp, rbp
    pop rbp
    ret

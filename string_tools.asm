; string_tools.asm
; Defines a limited set of tools for string parsing and comprehension.
; Note: The limit is your imagination.

section .data
    ; This message is printed for debugging reasons
    ST_test_msg: db "String Tools test message.", 0x0a
    ST_test_msg_len: equ $-ST_test_msg

    ; Beginning to see why people don't write ASM for fun
    ST_log_leadin: db "[String Tools] "
    ST_log_leadin_len: equ $-ST_log_leadin

    ST_log_call_streq: db "Called streq", 0x0a
    ST_log_call_streq_len: equ $-ST_log_call_streq

    ST_log_streq_1: db "String lengths were the same.", 0x0a
    ST_log_streq_1_len: equ $-ST_log_streq_1

section .text
    ; Library code!

string_tools_test:
    push rbp
    mov rbp, rsp

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, ST_test_msg ; "String Tools test message."
    mov rdx, ST_test_msg_len ; len(ST_test_msg)
    syscall ; syscall

    pop rbp
    ret

string_tools_log:
    push rbp
    mov rbp, rsp

    mov QWORD [rbp - 8], rsi
    mov QWORD [rbp - 16], rdx

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, ST_log_leadin ; "[String Tools] "
    mov rdx, ST_log_leadin_len ; len(ST_log_leadin)
    syscall ; syscall

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, QWORD [rbp - 8] ; 
    mov rdx, QWORD [rbp - 16] ;
    syscall ; syscall

    pop rbp
    ret

; String equality
streq:
    ; Okay, I actually understand how this works now
    ; Figuring out the stack (properly) is actually a
    ; fascinating experience, like first coming to an
    ; understanding of RAII or something like that.
    ; Enlightenment!
    push rbp
    mov rbp, rsp

    ; This function will take RAX, RDI as STR1, STR1_len
    ; RSI, RDX as STR2, STR2_len
    ; This may or may not be good practice.
    mov QWORD [rbp - 8], rax
    mov QWORD [rbp - 16], rdi
    mov QWORD [rbp - 24], rsi
    mov QWORD [rbp - 32], rdx

    ; Do a bit of logging.
    mov rsi, ST_log_call_streq
    mov rdx, ST_log_call_streq_len
    call string_tools_log

    ; Writing a string equality function
    ; We need to first find out if the lengths are inequal
    mov rax, QWORD [rbp - 16] 
    mov rdi, QWORD [rbp - 32]
    cmp rax, rdi
    jne streq_end

    ; Do a bit more logging (hey, this apparently isn't debuggable,
    ; have to do what's necessary)
    mov rsi, ST_log_streq_1
    mov rdx, ST_log_streq_1_len
    call string_tools_log

    ; Found this nice document for explaining some really good
    ; string operations: https://c9x.me/x86/html/file_module_x86_id_279.html
    ; Used here as reference.
    
streq_end:
    pop rbp
    ret

trimmed_streq:
    push rbp
    mov rbp, rsp

    ; Ideally this would trim a string then call streq

    pop rbp
    ret

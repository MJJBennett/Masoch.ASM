; string_tools.asm
; Defines a limited set of tools for string parsing and comprehension.
; Note: The limit is your imagination.

section .data
    ; This message is printed for debugging reasons
    ST_test_msg: db "String Tools test message.", 0x0a
    ST_test_msg_len: equ $-ST_test_msg

    endline: db 0x0a
    endline_len: equ $-endline

    ; Beginning to see why people don't write ASM for fun
    ST_log_leadin: db "[String Tools] "
    ST_log_leadin_len: equ $-ST_log_leadin

    ST_log_call_streq: db "Called streq", 0x0a
    ST_log_call_streq_len: equ $-ST_log_call_streq

    ST_log_streq_1: db "String lengths were the same.", 0x0a
    ST_log_streq_1_len: equ $-ST_log_streq_1

    ST_log_streq_2: db "Ending streq call.", 0x0a
    ST_log_streq_2_len: equ $-ST_log_streq_2

    ST_log_streq_3: db "Strings were inequal.", 0x0a
    ST_log_streq_3_len: equ $-ST_log_streq_3

    ST_log_streq_4: db "Strings were equal.", 0x0a
    ST_log_streq_4_len: equ $-ST_log_streq_4

    ST_log_streq_5: db "String lengths were not the same.", 0x0a
    ST_log_streq_5_len: equ $-ST_log_streq_5

    ST_log_string: db "String: '"
    ST_log_string_len: equ $-ST_log_string

    ST_log_string_end: db "'", 0x0a
    ST_log_string_end_len: equ $-ST_log_string_end

    ST_log_chareq: db "Found two equal characters.", 0x0a
    ST_log_chareq_len: equ $-ST_log_chareq

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

; This is like printf
; Except without the f
; Print No f
printnof:
    push rbp
    mov rbp, rsp
    sub rsp, 8h

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    syscall ; syscall

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, endline
    mov rdx, endline_len
    syscall ; syscall

    mov rsp, rbp
    pop rbp
    ret

string_tools_log:
    push rbp
    mov rbp, rsp
    sub rsp, 18h

    mov QWORD [rbp - 8], rsi
    mov QWORD [rbp - 16], rdx

    ; Check if we have debug mode enabled
    mov al, [rel is_db]
    movzx ecx, al
    cmp ecx, byte 0x1
    jne string_tools_log_end

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

    ; So I was trying to debug a rather tough issue
    ; Was getting some very weird errors. Figured it was
    ; probably a stack alignment issue (again) and found
    ; some references that suggested aligning rsp, then
    ; using movl rbp, rsp to restore it after.
    ; Turns out NASM is just weird compared to other syntax
    ; and it's mov rsp, rbp here. Fun! But it works now.
    ; Summary: mov rsp, rbp = good
string_tools_log_end:
    mov rsp, rbp
    pop rbp
    ret

string_tools_log_string:
    push rbp
    mov rbp, rsp
    sub rsp, 18h

    mov QWORD [rbp - 8], rsi
    mov QWORD [rbp - 16], rdx

    ; Check if we have debug mode enabled
    mov al, [rel is_db]
    movzx ecx, al
    cmp ecx, byte 0x1
    jne string_tools_log_string_end

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, ST_log_leadin ; "[String Tools] "
    mov rdx, ST_log_leadin_len ; len(ST_log_leadin)
    syscall ; syscall

    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, ST_log_string ; Okay, no more copying the string contents
    mov rdx, ST_log_string_len ; this is some number
    syscall ; syscall

    ; Now we write the actual string
    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, QWORD [rbp - 8] ; 
    mov rdx, QWORD [rbp - 16] ;
    syscall ; syscall

    ; And a trailer for a newline! 
    mov rax, 0x2000004 ; SYS_WRITE
    mov rdi, 1 ; STDOUT
    mov rsi, ST_log_string_end
    mov rdx, ST_log_string_end_len
    syscall ; syscall

string_tools_log_string_end:
    mov rsp, rbp
    pop rbp
    ret

; ;;;;; streq ;;;;; ;
; String equality
; This function will take RAX, RDI as STR1, STR1_len
; RSI, RDX as STR2, STR2_len
streq:
    ; Okay, I actually understand how this works now
    ; Figuring out the stack (properly) is actually a
    ; fascinating experience, like first coming to an
    ; understanding of RAII or something like that.
    ; Enlightenment!
    push rbp
    mov rbp, rsp

    ; Note to self: Understanding of rsp is that upon function
    ; call rsp is no longer aligned (but is positioned correctly;
    ; that is, it correctly marks the top of the stack) so we must
    ; always call `sub rsp, xx8h`, essentially. Because this function
    ; uses 5 variables and we decide to use 8 bytes for each, we can
    ; actually store this perfectly and align the stack with:
    sub rsp, 28h

    ; This function will take RAX, RDI as STR1, STR1_len
    ; RSI, RDX as STR2, STR2_len
    ; This may or may not be good practice.
    mov QWORD [rbp - 8], rax
    mov QWORD [rbp - 16], rdi
    mov QWORD [rbp - 24], rsi
    mov QWORD [rbp - 32], rdx

    mov QWORD [rbp - 40], 0

    ; Do a bit of logging.
    mov rsi, ST_log_call_streq
    mov rdx, ST_log_call_streq_len
    call string_tools_log
    mov rsi, QWORD [rbp - 8]
    mov rdx, QWORD [rbp - 16]
    call string_tools_log_string
    mov rsi, QWORD [rbp - 24]
    mov rdx, QWORD [rbp - 32]
    call string_tools_log_string

    ; Writing a string equality function
    ; We need to first find out if the lengths are inequal
    mov rax, QWORD [rbp - 16] 
    mov rdi, QWORD [rbp - 32]
    cmp rax, rdi
    jne streq_len_ne

    ; Do a bit more logging (My main debugging strategy,
    ; considering GDB doesn't actually work for some reason)
    mov rsi, ST_log_streq_1
    mov rdx, ST_log_streq_1_len
    call string_tools_log

    ; Note to self: For a serious string comparison, instructions like
    ; repne scasb, etc are ideal.
    ; See this nice document for explaining some really good
    ; string operations: https://c9x.me/x86/html/file_module_x86_id_279.html
    ; But for a first implementation, here is recursion.

    ; str1
    mov r8, QWORD [rbp - 8]
    ; str2
    mov r9, QWORD [rbp - 24]
    
streq_loop:
    ; Check if we have exceeded the maximum length
    ; We can't just compare two QWORDS (not sure why, but
    ; this does appear to be a rule) so instead:
    mov rax, QWORD [rbp - 40]
    cmp QWORD [rbp - 16], rax

    ; We compared the size to our counter. If our size is less
    ; than our counter, we're done - the strings are equal:
    jle streq_e
    
    ; Otherwise, compare the two arrays at the offset rax
    ; to see if the two characters are equal.
;    mov rdi, QWORD [rbp - 8]
;    mov rsi, QWORD [rbp - 24]
    ; So rdi contains str1, rsi contains str2
;    movzx rdx, BYTE [rdi + rax]
;    movzx rdi, BYTE [rsi + rax]
;    cmp rdx, rdi
    movzx rsi, BYTE [r8]
    movzx rdi, BYTE [r9]
    cmp rsi, rdi

    jne streq_ne

    ; Increment our counter
    inc QWORD [rbp - 40]

    ; Increment our strings
    inc r8
    inc r9

    ; More logging
    mov rsi, ST_log_chareq
    mov rdx, ST_log_chareq_len
    call string_tools_log

    ; Continue the loop
    jmp streq_loop

streq_e:
    ; Log string equality.
    mov rsi, ST_log_streq_4
    mov rdx, ST_log_streq_4_len
    call string_tools_log

    ; Strings are equal! Return 1 (true)
    mov rax, 1
    jmp streq_end

streq_len_ne:
    ; Log string length inequality.
    mov rsi, ST_log_streq_5
    mov rdx, ST_log_streq_5_len
    call string_tools_log

streq_ne:
    ; Log string inequality.
    mov rsi, ST_log_streq_3
    mov rdx, ST_log_streq_3_len
    call string_tools_log

    ; Strings are not equal! Return 0 (false)
    mov rax, 0
    jmp streq_end
    
streq_end:

    ; Preserve return value
    mov QWORD [rbp - 8], rax

    ; Log that we've reached the end of our function
    mov rsi, ST_log_streq_2
    mov rdx, ST_log_streq_2_len
    call string_tools_log

    ; Return value
    mov rax, QWORD [rbp - 8]

    mov rsp, rbp
    pop rbp
    ret

; ;;;;; startswith ;;;;; ;
; This function will take RAX, RDI as STR1, STR1_len
; RSI, RDX as STR2, STR2_len
; Does RSI start with RAX?
startswith:
    push rbp
    mov rbp, rsp
    sub rsp, 28h

    ; Save input variables
    mov QWORD [rbp - 8], rax
    mov QWORD [rbp - 16], rdi
    mov QWORD [rbp - 24], rsi
    mov QWORD [rbp - 32], rdx

    ; The basis of startswith is that the second string must be
    ; at least as long as the first string, then we can call streq
    ; with that length.
    ; Pretty simple overall.

    ; Essentially, does RSI start with RAX?
    ; RSI len must be >= RAX len
    ; therefore RDX >= RDI
    cmp rdx, rdi
    jl startswith_no
    mov rax, QWORD [rbp - 8]
    mov rdi, QWORD [rbp - 16]
    mov rsi, QWORD [rbp - 24]
    mov rdx, rdi
    call streq
    jmp startswith_end

startswith_no:
    ; Log string inequality.
    mov rsi, ST_log_streq_3
    mov rdx, ST_log_streq_3_len
    call string_tools_log

    ; Strings are not equal! Return 0 (false)
    mov rax, 0
    jmp startswith_end

startswith_end:
    mov rsp, rbp
    pop rbp
    ret

trimmed_streq:
    push rbp
    mov rbp, rsp

    ; Ideally this would trim a string then call streq
    ; This is unimplemented (obviously) and may or may
    ; not be included in the final product.

    pop rbp
    ret

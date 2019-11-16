%line 1+1 interpreter.asm







%line 1+1 string_tools.asm




[section .data]

 ST_test_msg: db "String Tools test message.", 0x0a
 ST_test_msg_len: equ $-ST_test_msg

 endline: db 0x0a
 endline_len: equ $-endline


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

[section .text]


string_tools_test:
 push rbp
 mov rbp, rsp

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, ST_test_msg
 mov rdx, ST_test_msg_len
 syscall

 pop rbp
 ret




printnof:
 push rbp
 mov rbp, rsp
 sub rsp, 8h

 mov rax, 0x2000004
 mov rdi, 1
 syscall

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, endline
 mov rdx, endline_len
 syscall

 mov rsp, rbp
 pop rbp
 ret

string_tools_log:
 push rbp
 mov rbp, rsp
 sub rsp, 18h

 mov QWORD [rbp - 8], rsi
 mov QWORD [rbp - 16], rdx


 mov al, [rel is_db]
 movzx ecx, al
 cmp ecx, byte 0x1
 jne string_tools_log_end

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, ST_log_leadin
 mov rdx, ST_log_leadin_len
 syscall

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, QWORD [rbp - 8]
 mov rdx, QWORD [rbp - 16]
 syscall









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


 mov al, [rel is_db]
 movzx ecx, al
 cmp ecx, byte 0x1
 jne string_tools_log_string_end

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, ST_log_leadin
 mov rdx, ST_log_leadin_len
 syscall

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, ST_log_string
 mov rdx, ST_log_string_len
 syscall


 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, QWORD [rbp - 8]
 mov rdx, QWORD [rbp - 16]
 syscall


 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, ST_log_string_end
 mov rdx, ST_log_string_end_len
 syscall

string_tools_log_string_end:
 mov rsp, rbp
 pop rbp
 ret





streq:





 push rbp
 mov rbp, rsp







 sub rsp, 28h




 mov QWORD [rbp - 8], rax
 mov QWORD [rbp - 16], rdi
 mov QWORD [rbp - 24], rsi
 mov QWORD [rbp - 32], rdx

 mov QWORD [rbp - 40], 0


 mov rsi, ST_log_call_streq
 mov rdx, ST_log_call_streq_len
 call string_tools_log
 mov rsi, QWORD [rbp - 8]
 mov rdx, QWORD [rbp - 16]
 call string_tools_log_string
 mov rsi, QWORD [rbp - 24]
 mov rdx, QWORD [rbp - 32]
 call string_tools_log_string



 mov rax, QWORD [rbp - 16]
 mov rdi, QWORD [rbp - 32]
 cmp rax, rdi
 jne streq_len_ne



 mov rsi, ST_log_streq_1
 mov rdx, ST_log_streq_1_len
 call string_tools_log








 mov r8, QWORD [rbp - 8]

 mov r9, QWORD [rbp - 24]

streq_loop:



 mov rax, QWORD [rbp - 40]
 cmp QWORD [rbp - 16], rax



 jle streq_e









 movzx rsi, BYTE [r8]
 movzx rdi, BYTE [r9]
 cmp rsi, rdi

 jne streq_ne


 inc QWORD [rbp - 40]


 inc r8
 inc r9


 mov rsi, ST_log_chareq
 mov rdx, ST_log_chareq_len
 call string_tools_log


 jmp streq_loop

streq_e:

 mov rsi, ST_log_streq_4
 mov rdx, ST_log_streq_4_len
 call string_tools_log


 mov rax, 1
 jmp streq_end

streq_len_ne:

 mov rsi, ST_log_streq_5
 mov rdx, ST_log_streq_5_len
 call string_tools_log

streq_ne:

 mov rsi, ST_log_streq_3
 mov rdx, ST_log_streq_3_len
 call string_tools_log


 mov rax, 0
 jmp streq_end

streq_end:


 mov QWORD [rbp - 8], rax


 mov rsi, ST_log_streq_2
 mov rdx, ST_log_streq_2_len
 call string_tools_log


 mov rax, QWORD [rbp - 8]

 mov rsp, rbp
 pop rbp
 ret





startswith:
 push rbp
 mov rbp, rsp
 sub rsp, 28h


 mov QWORD [rbp - 8], rax
 mov QWORD [rbp - 16], rdi
 mov QWORD [rbp - 24], rsi
 mov QWORD [rbp - 32], rdx









 cmp rdx, rdi
 jl startswith_no
 mov rax, QWORD [rbp - 8]
 mov rdi, QWORD [rbp - 16]
 mov rsi, QWORD [rbp - 24]
 mov rdx, rdi
 call streq
 jmp startswith_end

startswith_no:

 mov rsi, ST_log_streq_3
 mov rdx, ST_log_streq_3_len
 call string_tools_log


 mov rax, 0
 jmp startswith_end

startswith_end:
 mov rsp, rbp
 pop rbp
 ret

trimmed_streq:
 push rbp
 mov rbp, rsp





 pop rbp
 ret
%line 9+1 interpreter.asm

%line 1+1 constants.asm




[section .data]

 test_msg: db "Test message!", 0x0a
 test_msg_len: equ $-test_msg


 response: db "Input value: "


 response_len: equ $-response
%line 11+1 interpreter.asm

%line 1+1 io.asm





[section .data]

 prompt: db "> "
 prompt_len: equ $-prompt

[section .bss]


 input_var resb 256

[section .text]



print_prompt:
 push rbp
 mov rbp, rsp


 mov rax, 0x2000004

 mov rdi, 1

 mov rsi, prompt

 mov rdx, prompt_len

 syscall

 pop rbp
 ret



basic_input:
 push rbp
 mov rbp, rsp


 mov rax, 0x2000003

 mov rdi, 0

 mov rsi, input_var

 mov rdx, 256

 syscall



 mov rax, rax
 sub rax, 1

 pop rbp
 ret

get_input:
 push rbp
 mov rbp, rsp
 sub rsp, 8h


 call print_prompt


 call basic_input


 mov QWORD [rbp - 8], rax


 mov al, [rel is_db]
 movzx ecx, al
 cmp ecx, byte 0x1
 jne get_input_end



 mov rax, QWORD [rbp - 8]


 mov rdi, rax
 call print_input

get_input_end:

 mov rax, QWORD [rbp - 8]

 mov rsp, rbp
 pop rbp
 ret



print_input:
 push rbp
 mov rbp, rsp
 sub rsp, 8h





 inc rdi
 mov QWORD [rbp-8], rdi


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

 mov rsp, rbp
 pop rbp
 ret
%line 13+1 interpreter.asm

[section .data]



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

[section .text]




[global _main]

_main:

 push rbp
 mov rbp, rsp
 sub rsp, 10h

_main_loop:

 call get_input




 mov QWORD [rbp - 8], rax


 mov rax, input_var
 mov rdi, QWORD [rbp - 8]
 mov rsi, it_db_s
 mov rdx, it_db_sl
 call streq

 cmp rax, 1
 je _main_toggle_debug


 mov rax, input_var
 mov rdi, QWORD [rbp - 8]
 mov rsi, it_exit_s
 mov rdx, it_exit_sl
 call streq

 cmp rax, 1
 je _main_end



 mov rax, it_print_s
 mov rdi, it_print_sl
 mov rsi, input_var
 mov rdx, QWORD [rbp - 8]
 call startswith

 cmp rax, 1
 je _main_print


 jmp _main_loop

_main_toggle_debug:
 mov al, [rel is_db]
 movzx ecx, al
 cmp ecx, byte 0x1
 jne _main_enable_debug
_main_disable_debug:
 mov rsi, IT_dbdisabled_s
 mov rdx, IT_dbdisabled_sl
 call interpreter_log
 mov byte [rel is_db], 0x0
 jmp _main_loop
_main_enable_debug:
 mov rsi, IT_dbenabled_s
 mov rdx, IT_dbenabled_sl
 call interpreter_log
 mov byte [rel is_db], 0x1
 jmp _main_loop




_main_print:






 mov rax, QWORD [rbp - 8]
 cmp rax, 7
 jl _main_loop

 lea rsi, [rel input_var + 6]
 mov rdx, QWORD [rbp - 8]
 sub rdx, 6
 call printnof


 jmp _main_loop

_main_end:
 mov rsp, rbp
 pop rbp

 mov rax, 0x2000001
 mov rdi, 0
 syscall

interpreter_log:
 push rbp
 mov rbp, rsp
 sub rsp, 18h

 mov QWORD [rbp - 8], rsi
 mov QWORD [rbp - 16], rdx


 mov al, [rel is_db]
 movzx ecx, al
 cmp ecx, byte 0x1
 jne interpreter_log_end

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, IT_log_leadin
 mov rdx, IT_log_leadin_len
 syscall

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, QWORD [rbp - 8]
 mov rdx, QWORD [rbp - 16]
 syscall

interpreter_log_end:
 mov rsp, rbp
 pop rbp
 ret

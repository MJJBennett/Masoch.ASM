%line 1+1 interpreter.asm







%line 1+1 string_tools.asm




[section .data]

 ST_test_msg: db "String Tools test message.", 0x0a
 ST_test_msg_len: equ $-ST_test_msg


 ST_log_leadin: db "[String Tools] "
 ST_log_leadin_len: equ $-ST_log_leadin

 ST_log_call_streq: db "Called streq", 0x0a
 ST_log_call_streq_len: equ $-ST_log_call_streq

 ST_log_streq_1: db "String lengths were the same.", 0x0a
 ST_log_streq_1_len: equ $-ST_log_streq_1

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

string_tools_log:
 push rbp
 mov rbp, rsp

 mov QWORD [rbp - 8], rsi
 mov QWORD [rbp - 16], rdx

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

 pop rbp
 ret


streq:





 push rbp
 mov rbp, rsp




 mov QWORD [rbp - 8], rax
 mov QWORD [rbp - 16], rdi
 mov QWORD [rbp - 24], rsi
 mov QWORD [rbp - 32], rdx


 mov rsi, ST_log_call_streq
 mov rdx, ST_log_call_streq_len
 call string_tools_log



 mov rax, QWORD [rbp - 16]
 mov rdi, QWORD [rbp - 32]
 cmp rax, rdi
 jne streq_end



 mov rsi, ST_log_streq_1
 mov rdx, ST_log_streq_1_len
 call string_tools_log





streq_end:
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

 pop rbp
 ret

get_input:
 push rbp
 mov rbp, rsp


 call print_prompt


 call basic_input


 mov rdi, rax
 call print_input

 pop rbp
 ret
%line 13+1 interpreter.asm

[section .text]




[global _main]

_main:

 push rbp
 mov rbp, rsp
 sub rsp, 16


 call get_input

 mov rdi, 4
 mov rdx, 4

 call streq
 mov rdi, 6
 mov rdx, 4

 call streq


 mov rax, 0x2000001
 mov rdi, 0
 syscall



print_input:
 push rbp
 mov rbp, rsp





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

 pop rbp
 ret

print_test:
 push rbp
 mov rbp, rsp

 mov rax, 0x2000004
 mov rdi, 1
 mov rsi, test_msg
 mov rdx, test_msg_len
 syscall

 pop rbp
 ret

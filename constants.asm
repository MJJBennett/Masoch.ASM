; The goal of this file is to define string constants.
; Any string "string_name" will have an associated length
; defined as "string_name_len".

section .data
    ; Test message for printing
    test_msg: db "Test message!", 0x0a
    test_msg_len: equ $-test_msg

    ; Printed before outputting input
    response: db "Input value: "
    ; Takes the difference in bytes between this location
    ; and the start of response (that is, the address at response)
    response_len: equ $-response

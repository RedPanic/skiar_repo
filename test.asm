section .text
    global _start

_start:

get_producer:
    xor eax, eax
    cpuid

    mov dword[ds:producer], ebx
    mov dword[ds:producer+4], edx
    mov dword[ds:producer+8], ecx
    mov dword[ds:producer+12], 0xa

;writing out    
    mov edx, 12
    mov ecx, producer
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 1
    mov ecx, endl
    mov ebx, 1
    mov eax, 4
    int 0x80

get_type:

    mov eax, 0x01
    cpuid

get_model:

;Type 3000h
;Family 0F00h
;Model 00F0h   
;                      0011 1111 1111
; 0000 0000 0000 0000 0000 0000 0000 0000

    push eax
    and eax, 00F0h

    shr eax, 0x04
    mov [ds:model], al

;EAX al = model

    cmp al, 0xa
    jl after_conv
    mov ecx, 0x31
    mov [ds:hex_dec], ecx
    sub al, 0x09
    add al, 0x30
    mov [ds:hex_dec+1], al

after_conv:

    mov edx, 2
    mov ecx, hex_dec
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 1
    mov ecx, endl
    mov ebx, 1
    mov eax, 4
    int 0x80

    pop eax

get_family_id:

;Type 3000h
;Family 0F00h
;Model 00F0h   
;                      0011 1111 1111
; 0000 0000 0000 0000 0000 0000 0000 0000

    push eax
    and eax, 0F00h
    
    shr eax, 0x08
    mov [ds:family], al

;converting to dec
    mov eax, [ds:family]
    add eax, 0x30
    mov [ds:family], eax

    mov edx, 1
    mov ecx, family
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 1
    mov ecx, endl
    mov ebx, 1
    mov eax, 4
    int 0x80

    pop eax

get_cpu_type:
;Type 3000h
;Family 0F00h
;Model 00F0h   
;                      0011 1111 1111
; 0000 0000 0000 0000 0000 0000 0000 0000

    push eax 
    and eax, 3000h

    shr eax, 0xC
    mov [ds:type], eax

;converting to dec
    mov eax, [ds:type]
    add eax, 0x30
    mov [ds:type], eax

    mov edx, 1
    mov ecx, type
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov edx, 1
    mov ecx, endl
    mov ebx, 1
    mov eax, 4
    int 0x80

    pop eax

exit:
    mov eax, 0x01
    int 0x80


;convert_to_ascii (unsingned int value)
; convert_to_ascii:
;     pop eax
;     push ecx

;     cmp al, 0xA
;     jl add_offset
;     mov ecx, 0x31
;     mov [ds:hex_dec], ecx
;     sub al, 0x09

; add_offset:
;     add al, 0x30
;     mov [ds:hex_dec+1], al

;     pop ecx
;     ret



section .data
producer    times 13 db 0
model  times 2 db 0
family times 2 db 0
type   db 0
endl  db 0xa
hex_dec times 2 db 0


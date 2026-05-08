bits 16
org 100h

jmp start


msg1 db 10,13,"Enter English (0-100): $"
msg2 db 10,13,"Enter Math (0-100): $"
msg3 db 10,13,"Enter Computer (0-100): $"

totalmsg db 10,13,"Total: $"
permsg   db 10,13,"Percentage: $"
grademsg db 10,13,"Grade: $"
passmsg  db 10,13,"Result: $"

m1 dw 0
m2 dw 0
m3 dw 0
total dw 0
per dw 0


start:
    mov ax, cs
    mov ds, ax

    ; Input English
    mov dx, msg1
    mov ah, 09h
    int 21h
    call input
    mov [m1], ax

    ; Input Math
    mov dx, msg2
    mov ah, 09h
    int 21h
    call input
    mov [m2], ax

    ; Input Computer
    mov dx, msg3
    mov ah, 09h
    int 21h
    call input
    mov [m3], ax

    ; Calculate Total
    mov ax, [m1]
    add ax, [m2]
    add ax, [m3]
    mov [total], ax

    ; Show Total
    mov dx, totalmsg
    mov ah, 09h
    int 21h
    mov ax, [total]
    call print_num

    ; Calculate Percentage
    mov ax, [total]
    mov bx, 3
    xor dx, dx
    div bx
    mov [per], ax

    ; Show Percentage
    mov dx, permsg
    mov ah, 09h
    int 21h
    mov ax, [per]
    call print_num

    ; Grade
    mov dx, grademsg
    mov ah, 09h
    int 21h

    mov ax, [per]
    cmp ax, 80
    jae label_A
    cmp ax, 60
    jae label_B
    cmp ax, 40
    jae label_C
    jmp label_F

label_A:
    mov dl, 'A'
    jmp show_g

label_B:
    mov dl, 'B'
    jmp show_g

label_C:
    mov dl, 'C'
    jmp show_g

label_F:
    mov dl, 'F'

show_g:
    mov ah, 02h
    int 21h

    ; Result (Pass/Fail)
    mov dx, passmsg
    mov ah, 09h
    int 21h

    mov ax, [per]
    cmp ax, 40
    jl is_fail

    mov dl, 'P'
    jmp show_res

is_fail:
    mov dl, 'F'

show_res:
    mov ah, 02h
    int 21h

    ; Exit
    mov ah, 4Ch
    int 21h

input:
    xor bx, bx

next_digit:
    mov ah, 01h
    int 21h
    cmp al, 13
    je input_done

    sub al, '0'
    mov ah, 0
    mov cx, ax

    mov ax, bx
    mov dx, 10
    mul dx
    add ax, cx

    mov bx, ax
    jmp next_digit

input_done:
    mov ax, bx
    ret

print_num:
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    xor cx, cx

    test ax, ax
    jnz convert_loop

    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp done

convert_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz convert_loop

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
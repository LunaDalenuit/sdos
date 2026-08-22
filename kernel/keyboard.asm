; SDOS - kernel/keyboard.asm
; Keyboard Input and Buffer Routines

; kgetchar: Blocks until a key is pressed
; Output: AL = ASCII character (AH = BIOS scan code)
kgetchar:
    mov ah, 0x00        ; Bios INT 16h AH=00h: Read next keystroke
    int 0x16            ; Returns AL = ASCII code, AH = scan code
    ret

; kreadline: Reads an input line from the keyboard into a buffer
; Input: DI = Pointer to destination memory buffer
;        CX = Maximum buffer capacity in bytes
; Output: Buffer containing null-terminated string
kreadline:
    push ax
    push bx
    push cx
    push dx
    push di

    xor bx, bx           ; Character counter

.input_loop:
    call kgetchar       ; Wait for keypress
    
    ; Check for Carriage Return (enter)
    cmp al, 0x0D
    je .done

    ; Check for Backspace
    cmp al, 0x08
    je .handle_backspace

    ; Ignore control codes under ASCII space (0x20) except above
    cmp al, 0x20
    jb .input_loop

    ; Check if buffer is full (leave 1 byte space for null terminator)
    mov dx, cx
    dec dx
    cmp bx, dx
    jge .input_loop     ; Buffer limit reached, ignore character

    ; Store character in buffer
    mov [di + bx], al
    inc bx

    ; Echo character to CGA terminal
    push bx
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    pop bx

    jmp .input_loop

.handle_backspace:
    cmp bx, 0               ; Check if buffer is empty
    jle .input_loop

    dec bx                  ; Step buffer index backwards
    mov byte [di + bx], 0   ; Clear byte memory
    call kbackspace         ; Erase character on screen
    jmp .input_loop

.done:
    mov byte [di + bx], 0   ; Null-terminate the string buffer
    call knewline

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret    
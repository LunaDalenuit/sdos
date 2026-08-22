; SDOS - kernel/console.asm
; CGA Console and Video Routines

; kprint: Prints a null-terminated string to the CGA terminal
; Input: DS:SI = Pointer to string
kprint:
    push ax
    push bx
    push si

.loop:
    lodsb           ; Load byte from [DS:SI] into AL, SI++
    or al, al       ; Check for null-terminator
    jz .done
    mov ah, 0x0E    ; BIOS TTY character output
    mov bh, 0x00    ; Video page 0
    mov bl, 0x07    ; Light gray on black attribute
    int 0x10
    jmp .loop

.done:
    pop si
    pop bx
    pop ax
    ret

; kcls: Clears the CGA scren and resets the cursor to (0,0)
kcls:
    push ax
    mov ax, 0x003   ; Set CGA Mode 3 (80x25 text mode)
    int 0x10
    pop ax
    ret

; knewline: Outputs Carriage Return Line Feed (CRLF)
knewline:
    push ax
    push bx

    mov ah, 0x0E
    mov al, 0x0D        ; Carriage Return
    mov bh, 0x00
    mov bl, 0x07
    int 0x10

    mov ah, 0x0E
    mov al, 0x0A       ; Line Feed
    int 0x10

    pop bx
    pop ax
    ret

; kgetcursor: Retrieves the cursor position
; Output: DH = Row (0-24), DL = Column (0-79)
kgetcursor:
    push ax
    push bx
    mov ah, 0x03        ; Subfunction 03h: Read cursor position
    mov bh, 0x00        ; Page 0
    int 0x10
    pop bx
    pop ax
    ret

; ksetcursor: Sets cursor position
; Input: DH = Row (0-24), DL = Column (0-79)
ksetcursor:
    push ax
    push bx
    mov ah, 0x02    ; Subfunction 02h: Set cursor position
    mov bh, 0x00    ; Page 0
    int 0x10
    pop bx
    pop ax
    ret

; kbackspace: Handles non-destructive TTY backspace character erase
kbackspace:
    push ax
    push bx

    mov ah, 0x0E
    mov al, 0x08    ; Move cursor back one column (backspace)
    mov bh, 0x00
    mov bl, 0x07
    int 0x10

    mov ah, 0x0E
    mov al, ' '     ; Overwrite character with blank character
    int 0x10

    mov ah, 0x0E
    mov al, 0x08    ; Overwriting the character moves the cursor forward a column, we need to backspace again
    int 0x10

    pop bx
    pop ax
    ret
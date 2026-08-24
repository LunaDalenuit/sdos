; SDOS - kernel/syscall.asm
; CP/M-like System Call API System (INT 21h)

; init_syscalls: Installs SDOS INT 21h vector into IVT
; IVT Slot 0x21 address = 0x0000:(0x21 * 4) = 0x0000:0x0084
init_syscalls:
    push ax
    push es

    xor ax, ax
    mov es, ax          ; ES = 0x0000 (IVT Segment)

    cli                 ; Disable interrupts during vector write
    mov word [es:0x0084], int21_handler  ; Offset
    mov word [es:0x0086], cs             ; Segment (0x0500)
    sti                 ; Re-enable interrupts

    pop es
    pop ax
    ret

; int21_handler: Master Dispatcher for INT 21h
; Input: AH = Function Number
int21_handler:
    pushf           ; Preserve flags

    cmp ah, 0x01
    je .fn_01_read_char

    cmp ah, 0x02
    je .fn_02_write_char

    cmp ah, 0x09
    je .fn_09_print_str

    cmp ah, 0x19
    je .fn_19_get_drive

    ; Unknown/unimplemented function: return gracefully
    popf
    ret

; --- Service Routines ---

; AH = 0x01: Read character with Echo -> AL = Character
.fn_01_read_char:
    popf
    call kgetchar       ; Returns character in AL

    ; Echo character to CGA console
    push ax
    push bx
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    pop bx
    pop ax
    iret

; AH = 0x02: Write Character (DL = Character)
.fn_02_write_char:
    popf
    push ax
    push bx
    mov ah, 0x0E
    mov al, dl      ; Char passed in DL
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    pop bx
    pop ax
    iret

; AH =  0x09: Print '$'-terminated string (DS:DX = Pointer)
.fn_09_print_str:
    popf
    push ax
    push bx
    push si

    mov si, dx      ; Point SI to string at DS:DX

.str_loop:
    lodsb           ; Load byte at [DS:SI] into AL, SI++
    cmp al, '$'     ; CP/M-compatible '$' terminator check
    je .str_done

    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    jmp .str_loop

.str_done:
    pop si
    pop bx
    pop ax
    iret

; AH = 0x19: Get Current Default Drive -> AL = Drive (0 = A:)
.fn_19_get_drive:
    popf
    mov al, 0x00        ; Always Drive 0 (A:) for now
    iret
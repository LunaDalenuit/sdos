; SDOS - kernel/kernel.asm
; Main kernel binary loaded at 0x0500:0x0000

[BITS 16]
[ORG 0x0000] ; Loaded into memory segment 0x0500, offset 0x0000

kernel_main:
    ; Ensure segment registers point to kernel segment (0x1000)
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; Print SDOS Banner
    mov si, msg_banner

print_loop:
    lodsb           ; Load byte from [DS:SI] into AL
    or al, al       ; Check for null terminator
    jz kernel_halt
    mov ah, 0x0E    ; BIOS TTY output
    mov bh, 0x00    ; Page 0
    mov bl, 0x07    ; Light gray on black
    int 0x10
    jmp print_loop

kernel_halt:
    cli
.loop:
    hlt
    jmp .loop

; --- Data ---
msg_banner  db "Simple Disk Operating System v1.0", 0x0D, 0x0A
            db "Copyright (c) 1981 SDOS Authors", 0x0D, 0x0A, 0
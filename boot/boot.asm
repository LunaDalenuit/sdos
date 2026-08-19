; SDOS - boot/boot.asm
; 512B BIOS boot sector

[BITS 16]
[ORG 0x7C00] ; The IBM-PC BIOS loads the boot secter here

start:
    ; 1. Clear interrupts and normalize segment registers
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack grows down from bootloader start address
    sti

    ; 2. Set CGA 80x25 Color Text Mode (Mode 3)
    mov ax, 0x0003
    int 0x10

    ; 3. Print SDOS banner to terminal
    mov si, msg_banner

print_loop:
    lodsb           ; Load byte from [DS:SI] into AL, increment SI
    or al, al       ; Null terminator check
    jz halt
    mov ah, 0x0E    ; BIOS TTY output
    mov bh, 0x00    ; Page number 0
    mov bl, 0x07    ; Light gray on block
    int 0x10
    jmp print_loop

halt:
    cli
.loop:
    hlt
    jmp .loop


; --- Data ---
msg_banner db "Simple Disk Operating System v1.0 (1981)", 0x0D, 0x0A
           db "Copyright (c) 1981 - SDOS Authors", 0x0D, 0x0A, 0

; --- Bootsector Padding & Signature
times 510-($-$$) db 0   ; Pad sector out to 510 bytes
dw 0xAA55               ; IBM PC boot signature
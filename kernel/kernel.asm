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
    call kprint
    call knewline

shell_loop:
    ; Print prompt
    mov si, msg_prompt
    call kprint

    ; Read user input line into command buffer
    mov di, cmd_buffer
    mov cx, 128          ; 128 byte buffer limit
    call kreadline

    ; Echo typed input back
    mov si, cmd_buffer
    call kprint
    call knewline
    call knewline

    jmp shell_loop

kernel_halt:
    cli
.loop:
    hlt
    jmp .loop

; --- Kernel Subsystems ---
%include "kernel/console.asm"
%include "kernel/keyboard.asm"

; --- Data ---
msg_banner  db "Simple Disk Operating System v1.0", 0x0D, 0x0A
            db "Copyright (c) 1981 SDOS Authors", 0x0D, 0x0A, 0
msg_prompt  db "SDOS> ", 0

; --- Kernel BSS ---
cmd_buffer times 128 db 0
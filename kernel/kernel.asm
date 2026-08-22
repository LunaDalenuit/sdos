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

    ; Ignore empty lines if user just presses enter
    mov si, cmd_buffer
    cmp byte [si], 0
    je shell_loop

    ; Convert input buffer to uppercase
    mov di, cmd_buffer
    call ktoupper

    jmp .parse_command

    jmp shell_loop

.parse_command:
    ; Command: 'HELP'
    mov si, cmd_buffer
    mov di, cmd_help
    call kstrcmp
    jz .do_help

    ; Command: 'VER'
    mov si, cmd_buffer
    mov di, cmd_ver
    call kstrcmp
    jz .do_ver

    ; Command: 'CLS'
    mov si, cmd_buffer
    mov di, cmd_cls
    call kstrcmp
    jz .do_cls

    ; Command not found
    
    mov si, msg_unknown_cmd
    call kprint
    call knewline
    jmp shell_loop

.do_help:
    mov si, msg_cmd_help
    call kprint
    jmp shell_loop

.do_ver:
    mov si, msg_cmd_ver
    call kprint
    jmp shell_loop

.do_cls:
    call kcls
    jmp shell_loop

kernel_halt:
    cli
.loop:
    hlt
    jmp .loop

; --- Kernel Subsystems ---
%include "kernel/console.asm"
%include "kernel/keyboard.asm"
%include "kernel/string.asm"

; --- Data ---
msg_banner          db "Simple Disk Operating System v1.0", 0x0D, 0x0A
                    db "Copyright (c) 1981 SDOS Authors", 0x0D, 0x0A, 0
msg_prompt          db "SDOS> ", 0
msg_unknown_cmd     db "Bad command. Files not implemented.", 0x0D, 0x0A, 0

; Command strings
cmd_help    db "HELP", 0
cmd_ver     db "VER", 0
cmd_cls     db "CLS", 0

; Command outputs
msg_cmd_help    db "Commands:", 0x0D, 0x0A
                db "  HELP - Display a list of commands.", 0x0D, 0x0A
                db "  VER  - Display SDOS version info.", 0x0D, 0x0A
                db "  CLS  - Clear the scren.", 0x0D, 0x0A, 0x0D, 0x0A, 0

msg_cmd_ver     db "Simple Disk Operating System Version 1.00 (August 1981)", 0x0D, 0x0A, 0x0D, 0x0A, 0 

; --- Kernel BSS ---
cmd_buffer times 128 db 0
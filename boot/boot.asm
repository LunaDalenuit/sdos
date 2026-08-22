; SDOS - boot/boot.asm
; 512B BIOS boot sector

[BITS 16]
[ORG 0x7C00] ; The IBM-PC BIOS loads the boot secter here

start:
    ; Clear interrupts and normalize segment registers
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack grows down from bootloader start address
    sti

    mov [BOOT_DRIVE], dl    ; Save boot drive number provided by BIOS

    mov di, 3       ; Allow up to 3 read attempts

    ; Set CGA 80x25 Color Text Mode (Mode 3)
    mov ax, 0x0003
    int 0x10

reset_drive:
    ; Reset Floppy Controller
    mov ah, 0x0             ; Subfunction 00h: Reset Disk System
    mov dl, [BOOT_DRIVE]    ; Drive to reset (0x00 = A:)
    int 0x13
    jc disk_error           ; Carry Flag (CF) set means hardware reset failed

    ; Print controller ready message
    mov si, msg_read_ok
.print_ok:
    lodsb
    or al, al
    jz .load_kernel ; Ready to load the kernel
    mov ah, 0x0E    ; BIOS TTY output
    mov bh, 0x00    ; Page number 0
    mov bl, 0x07    ; Light gray on black
    int 0x10
    jmp .print_ok

.load_kernel:
    ; Set ES:BX target buffer to 0x0500:0x0000
    mov ax, 0x0500
    mov es, ax
    xor bx, bx

    ; BIOS INT 13h, AH=02h (Read disk sectors)
    mov ah, 0x02            ; Read sectors subfunction
    mov al, 8               ; Number of sectors to read
    mov ch, 0               ; Cylinder 0
    mov cl, 2               ; Sector 2
    mov dh, 0               ; Head 0
    mov dl, [BOOT_DRIVE]    ; Boot drive
    int 0x13
    jc disk_error           ; Jump to disk error handler if CF set

    jmp 0x0500:0x0000

halt:
    cli
.loop:
    hlt
    jmp .loop

disk_error:
    dec di      ; Decrement remaining retries
    jz .fatal   ; If 0 retries left, print critical failure notice and halt

    mov si, msg_read_err
.print_err:
    lodsb
    or al, al
    jz reset_drive      ; After printing, try again
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    jmp .print_err

.fatal:
    mov si, msg_read_fail
.print_fatal:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    jmp .print_fatal

; --- Data ---
msg_read_err    db "Disk Read Error, retrying...", 0x0D, 0x0A, 0
msg_read_ok     db "Floppy Controller ready.", 0x0D, 0x0A, 0x0D, 0x0A, 0
msg_read_fail   db "Critical: Drive Hardware failed.", 0x0D, 0x0A, 0
BOOT_DRIVE      db 0        ; Hold BIOS boot drive ID (typically 0x00)

; --- Bootsector Padding & Signature ---
times 510-($-$$) db 0   ; Pad sector out to 510 bytes
dw 0xAA55               ; IBM PC boot signature
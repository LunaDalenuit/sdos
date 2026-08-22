; SDOS - kernel/string.asm
; String utilities

; kstrcmp: Compares two null-terminated strings
; Input:  SI = Pointer to first string
;         DI = Pointer to second string
; Output: ZF = 1 (Zero Flag Set) if strings are equal
;         ZF = 0 (Zero Flag Clear) if strings are unequal
kstrcmp:
    push ax
    push si
    push di

.loop:
    mov al, [si]
    mov ah, [di]

    cmp al, ah      ; Compare current characters
    jne .not_equal  ; If they don't match, fail

    or al, al       ; Are we at a null terminator?
    jz .equal       ; Both are null and equal

    inc si
    inc di
    jmp .loop

.not_equal:
    pop di
    pop si
    pop ax
    ; Force Zero Flag (ZF) to clear (not equal)
    mov al, 1
    or al, al
    ret

.equal:
    pop di
    pop si
    pop ax
    ; Force Zero Flag (ZF) to set (equal)
    xor ax, ax
    ret

; ktoupper: Converts a null-terminated string to uppercase
; Input: DI = Pointer to string buffer
ktoupper:
    push ax
    push di

.loop:
    mov al, [di]
    or al, al       ; Check for null-terminator
    jz .done

    cmp al, 'a'     ; If AL < 'a', not lowercase
    jb .next

    cmp al, 'z'     ; If AL > 'z', not lowercase
    ja .next

    ; AL is between 'a' and 'z' including, convert to uppercase
    sub al, 0x20
    mov [di], al

.next:
    inc di
    jmp .loop

.done:
    pop di
    pop ax
    ret
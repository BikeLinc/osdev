; Simple printing routine for 32 bit mode

[bits 32]


; Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; =========== print_string_pm ========= (Prints string in protected mode)
print_string_pm:
    pusha                               
    mov edx, VIDEO_MEMORY               ; Set edx to start of video memory

print_string_pm_loop:
    mov al, [ebx]                       ; Set characacter stored in ebx to al
    mov ah, WHITE_ON_BLACK              ; Store WHITE_ON_BLACK attributes in ah
    
    cmp al, 0                           ; Is End of String?
    je print_string_pm_done             ; If End, jump to done

    mov [edx], ax                       ; Store character attribs at current character cell in vid memory
    
    add ebx, 1                          ; Incriment to next char
    add edx, 2                          ; Move to next cell

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret

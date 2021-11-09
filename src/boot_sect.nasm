; Boot sector that boots a C kernel in 32-bit protected mode



; compile with "nasm boot_sect.nasm -f bin -o boot_sect.bin"

; compile kernel with "gcc -ffreestanding -c kernel.c -o kernel.o"
; compile kernel then "ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary"

; link to image with "cat boot_sect.bin kernel.bin > os.image"

; run with "qemu-system-x86_64 -fda os.image"


[org 0x1000]
KERNEL_OFFSET equ 0x0    ; Memory offset where we load our kernel

    mov [BOOT_DRIVE], dl    ; Store boot drive in DL 
    
    mov bp, 0x9000          ; Setup stack
    mov sp, bp

    mov si, MSG_REAL_MODE   ; Announce that we begin booting in 16-bit real mode
    call print_string       
    
    call load_kernel        ; Load the kernel

    call switch_to_pm       ; Switch into protected mode and never return

    jmp $

%include "print16.nasm"
%include "disk_load.nasm"
%include "gdt.nasm"
%include "print32.nasm"
%include "switch_to_pm.nasm"
    
[bits 16]

; load_kernel
load_kernel:
    mov si, MSG_LOAD_KERNEL ; Announce begin loading kernel
    call print_string

    mov bx, KERNEL_OFFSET   ; Setup disk loading paramaters
    mov dh, 15
    mov dl, [BOOT_DRIVE]
    call disk_load

    ret


[bits 32]

BEGIN_PM:
    
    mov ebx, MSG_PROT_MODE  ; Announce we have booted into protected mode
    call print_string_pm

    call KERNEL_OFFSET

    jmp $


; Global variables
BOOT_DRIVE db 0
MSG_REAL_MODE db " Started in 16- bit Real Mode ", 0
MSG_PROT_MODE db " Successfully landed in 32- bit Protected Mode ", 0
MSG_LOAD_KERNEL db " Loading kernel into memory. ", 0
    

; Boot sector padding
times 510-($-$$) db 0       ; Fill rest of boot sector with zeros except last two bytes
dw 0xaa55                   ; Tell s BIOS that this file is a boot sector

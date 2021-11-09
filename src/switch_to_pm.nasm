[bits 16]
; Swtich to protected mode
   
switch_to_pm:
    cli                     ; Switch off interrupts untill we have setup
                            ; the protected mode interrupt vector

    lgdt [gdt_descriptor]   ; Load Global Descriptor Table
    
    mov eax, cr0            ; Set first bit of cr0 to enable
    or eax, 0x1             ; the switch to protected mode
    mov cr0, eax

    jmp CODE_SEG:init_pm    ; Make a far jump ( i.e. to a new segment ) to our 32- bit
                                ; code. This also forces the CPU to flush its cache of
                                ; pre - fetched and real - mode decoded instructions , which can
                                ; cause problems.

[bits 32]
; Initialize registers and the stack once in PM

init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    mov ebp, 0x90000        ; Update stack position to above free space
    mov esp, ebp

    call BEGIN_PM

; Simple Collection Of Printing Routines
; By Lincoln Scheer

;========== print_hex ========== (Prints the value of DX as hexdecimal)

print_hex:
    pusha                           ; save the register values to the stack for later 

    mov cx,4                        ; Start the counter: we want to print 4 characters
                                    ; 4 bits per char, so we're printing a total of 16 bits

char_loop:
    dec cx                          ; Decrement the counter

    mov ax,dx                       ; copy bx into ax so we can mask it for the last chars
    shr dx,4                        ; shift bx 4 bits to the right
    and ax,0xf                      ; mask ah to get the last 4 bits

    mov bx, HEX_OUT                 ; set bx to the memory address of our string
    add bx, 2                       ; skip the '0x'
    add bx, cx                      ; add the current counter to the address

    cmp ax,0xa                      ; Check to see if it's a letter or number
    jl set_letter                   ; If it's a number, go straight to setting the value
    add byte [bx],7                 ; If it's a letter, add 7
    jl set_letter


set_letter:
    add byte [bx],al                ; Add the value of the byte to the char at bx

    cmp cx,0                        ; check the counter, compare with 0
    je print_hex_done               ; if the counter is 0, finish
    jmp char_loop                   ; otherwise, loop again


print_hex_done:
    mov si, HEX_OUT                 ; print the string pointed to by bx
    call print_string
    popa                            ; pop the initial register values back from the stack
    ret                             ; return the function

;========== Print String ========== (Prints out string loaded into SI register)

print_string:                       ; Prints string loaded into si register

    
    .run:                           ; Routine
        lodsb                       ; Pushes next character into al register

        cmp al, 0x00                ; Compares al register to end of string
        je .done                    ; If Finnished move to done lable
        call print_char             ; Print character loaded into al register
        jmp .run                    ; Start From The Top

    .done:                          ; Finnished
        ret                         ; Return to last address called from


;========== Print Char =========== (Prints out character loaded into AL register)

print_char:                         ; Prints character loaded into al register
    mov ah, 0x0e                    ; Set ah to BIOS scrolling teletype
    int 0x10                        ; Call Print to Screen Interrups
    ret                             ; Return to last address called from


;========= Global Variables ==========
HEX_OUT:
    db '0x0000', 0

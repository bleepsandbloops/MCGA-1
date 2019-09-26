%include "bl.inc"
bits 16
section .text
org 7c00h
start: 
        ;save disc info
        push    dx
        ; init screen address
        mov ax, 0b800h
        mov ds, ax
        ; init data segment
        mov ax, 0
        mov es, ax
        ; parse disc info
        test    dl,0x80
        jnz     disc_c
        add     dl, 'A'
        jmp     save_l
disc_c: and     dl,0x7f ; or even 0x0f
        add     dl, 'C'
save_l: mov     [es:disc_p],dl
        mov bx, 80*25*2+2
        mov ax, 0200h
clear:  mov [bx-2], ax
        sub bx, 2
        jnz clear

        mov bx, 0
        mov cx, mbrln
        mov bp, mbrmsg
        call print

        ; start to read next sectors
        pop dx
        mov ax, BLCS
        mov es, ax
        mov bx, BLIP ; relative address for the BL
        mov ah, 0x02
        mov al, BLNSEC ;n sectors
        mov ch, 0 ;cylinder
        mov cl, 2 ;sector, numbering from 1
        mov dh, 0 ;head
                  ; dl is initialized
        int 0x13
;test error message
        mov bx, 0x00
        mov es, bx  ; set es back to original
        ; Process INT 13h errors
                    ;carry flag = 1 if error
        jc  error
        cmp al, BLNSEC ; al = number of actual sectors read
        jne error
        ; If there is no errors -- jump to boot loader code
        jmp BLCS:BLIP; long jump to the BL
halt:   hlt
        jmp halt

error:
        ; translate ah to ascii
        mov dh, ah
        and ah, 0x0f
        cmp ah, 0x0a
        jae adda
        ; add '0'
        add ah, '0'
        jmp contin
        ; add 'A'
adda:   add ah, 'A'
        sub ah, 0x0a

contin:
        shr dh, 4
        cmp dh, 0x0a
        jae adda2
        ; add '0'
        add dh, '0'
        jmp contin2
adda2:  add dh, 'A'
        sub dh, 0x0a
contin2:
        mov al, dh
        mov [es:errcod],ax
        mov bx, 80*2 ; next line relative to the first msg
        mov cx, errln
        mov bp, errmsg
        call    print
        jmp halt
;subroutines
print:  mov al, [es:bp]
        mov ah, 02h
loo:    mov [bx], ax
        add bx, 2
        inc bp
        mov al, [es:bp]
        loop loo
        shr bx,1

        mov dx, 0x03d4
        mov al, 0x0f
        out dx, al

        inc dl
        mov al, bl
        out dx, al

        dec dl
        mov al, 0x0e
        out dx, al

        inc dl
        mov al, bh
        out dx, al
        ret

; data
mbrmsg: db  "MBR loaded from disc X"
disc_p  equ $-1
        db  ". Start boot loader..."
mbrln   equ $-mbrmsg
errmsg: db  "Disc error. Return code (BIOS INT 13h): 0xXX."
errcod: equ $-3
errln   equ $-errmsg

size    equ $-start
        times 510-size db 0
        dw      0aa55h


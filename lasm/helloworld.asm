        LACC 0x48 0x00
        LMAC 0x00 0x00
        LACC 0x65 0x00
        LMAC 0x01 0x00
        LACC 0x6c 0x00
        LMAC 0x02 0x00
        LACC 0x6c 0x00
        LMAC 0x03 0x00
        LACC 0x6f 0x00
        LMAC 0x04 0x00
        LACC 0x20 0x00
        LMAC 0x05 0x00
        LACC 0x77 0x00
        LMAC 0x06 0x00
        LACC 0x6f 0x00
        LMAC 0x07 0x00
        LACC 0x72 0x00
        LMAC 0x08 0x00
        LACC 0x6c 0x00
        LMAC 0x09 0x00
        LACC 0x64 0x00
        LMAC 0x0a 0x00
        LACC 0x21 0x00
        LMAC 0x0b 0x00
        LACC 0xd 0x00
        LMAC 0x0c 0x00
        LACC 0x00 0x00
        PUSH
label:  POP  ;;jump here
        LADR
        INC
        PUSH
        LACA
        WRIT
        LACC 0x0d 0x00
        SUB
        JZ   tohalt
        JMP  label
tohalt: HALT

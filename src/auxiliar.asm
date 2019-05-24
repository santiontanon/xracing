;-----------------------------------------------
; pletter v0.5c msx unpacker
; call unpack with "hl" pointing to some pletter5 data, and "de" pointing to the destination.
; changes all registers

GETBIT:  MACRO 
    add a,a
    call z,pletter_getbit
    ENDM

GETBITEXX:  MACRO 
    add a,a
    call z,pletter_getbitexx
    ENDM

pletter_unpack:
    ld a,(hl)
    inc hl
    exx
    ld de,0
    add a,a
    inc a
    rl e
    add a,a
    rl e
    add a,a
    rl e
    rl e
    ld hl,pletter_modes
    add hl,de
    ld e,(hl)
    ld ixl,e
    inc hl
    ld e,(hl)
    ld ixh,e
    ld e,1
    exx
    ld iy,pletter_loop
pletter_literal:
    ldi
pletter_loop:
    GETBIT
    jr nc,pletter_literal
    exx
    ld h,d
    ld l,e
pletter_getlen:
    GETBITEXX
    jr nc,pletter_lenok
pletter_lus:
    GETBITEXX
    adc hl,hl
    ret c
    GETBITEXX
    jr nc,pletter_lenok
    GETBITEXX
    adc hl,hl
    ret c
    GETBITEXX
    jp c,pletter_lus
pletter_lenok:
    inc hl
    exx
    ld c,(hl)
    inc hl
    ld b,0
    bit 7,c
    jr z,pletter_offsok
    jp ix

pletter_mode6:
    GETBIT
    rl b
pletter_mode5:
    GETBIT
    rl b
pletter_mode4:
    GETBIT
    rl b
pletter_mode3:
    GETBIT
    rl b
pletter_mode2:
    GETBIT
    rl b
    GETBIT
    jr nc,pletter_offsok
    or a
    inc b
    res 7,c
pletter_offsok:
    inc bc
    push hl
    exx
    push hl
    exx
    ld l,e
    ld h,d
    sbc hl,bc
    pop bc
    ldir
    pop hl
    jp iy

pletter_getbit:
    ld a,(hl)
    inc hl
    rla
    ret

pletter_getbitexx:
    exx
    ld a,(hl)
    inc hl
    exx
    rla
    ret

pletter_modes:
    dw pletter_offsok
    dw pletter_mode2
    dw pletter_mode3
    dw pletter_mode4
    dw pletter_mode5
    dw pletter_mode6


;-----------------------------------------------
; From: http://www.z80st.es/downloads/code/ (author: Konamiman)
; GETSLOT:  constructs the SLOT value to then call ENSALT
; input:
; a: slot
; output:
; a: value for ENSALT
GETSLOT:    
    and #03             ; Proteccion, nos aseguramos de que el valor esta en 0-3
    ld  c,a             ; c = slot de la pagina
    ld  b,0             ; bc = slot de la pagina
    ld  hl,#FCC1            ; Tabla de slots expandidos
    add hl,bc               ; hl -> variable que indica si este slot esta expandido
    ld  a,(hl)              ; Tomamos el valor
    and #80             ; Si el bit mas alto es cero...
    jr  z,GETSLOT_EXIT            ; ...nos vamos a @@EXIT
    ; --- El slot esta expandido ---
    or  c               ; Slot basico en el lugar adecuado
    ld  c,a             ; Guardamos el valor en c
    inc hl              ; Incrementamos hl una...
    inc hl              ; ...dos...
    inc hl              ; ...tres...
    inc hl              ; ...cuatro veces
    ld  a,(hl)              ; a = valor del registro de subslot del slot donde estamos
    and #0C             ; Nos quedamos con el valor donde esta nuestro cartucho
GETSLOT_EXIT:     
    or  c               ; Slot extendido/basico en su lugar
    ret                 ; Volvemos

;-----------------------------------------------
; From: http://www.z80st.es/downloads/code/
; SETPAGES32K:  BIOS-ROM-YY-ZZ   -> BIOS-ROM-ROM-ZZ (SITUA PAGINA 2)
SETPAGES32K:    ; --- Posiciona las paginas de un megarom o un 32K ---
    ld  a,#C9               ; Codigo de RET
    ld  (SETPAGES32K_NOPRET),a            ; Modificamos la siguiente instruccion si estamos en RAM
SETPAGES32K_NOPRET:   
    nop                     ; No hacemos nada si no estamos en RAM
    ; --- Si llegamos aqui no estamos en RAM, hay que posicionar la pagina ---
    call RSLREG             ; Leemos el contenido del registro de seleccion de slots
    rrca                    ; Rotamos a la derecha...
    rrca                    ; ...dos veces
    call GETSLOT            ; Obtenemos el slot de la pagina 1 ($4000-$BFFF)
    ld  h,#80               ; Seleccionamos pagina 2 ($8000-$BFFF)
    jp  ENASLT              ; Posicionamos la pagina 2 y volvemos


;-----------------------------------------------
; From: http://www.z80st.es/downloads/code/
; --- RUTINAS PRINCIPALES DEL MODULO ---
; SETPAGES48K:  BIOS-ROM-YY-ZZ   -> ROM-ROM-ROM-ZZ (SITUA PAGINAS 2 Y 0, EN ESTE ORDEN)
;               ADEMAS GUARDA LOS SLOTS DEL JUEGO Y LA BIOS POR SI HAY QUE INTERCAMBIAR
; SETGAMEPAGE0: XX-ROM-YY-ZZ     -> ROM-ROM-YY-ZZ (NO TOCA LA PAGINA 2)
; RESTOREBIOS:  XX-ROM-YY-ZZ     -> BIOS-ROM-YY-ZZ (VUELVE A SITUAR LA BIOS)
; SETPAGE0: POSICIONA SLOT EN LA PAGINA 0
; --- VARIABLES EN RAM NECESARIAS ---
; SLOTBIOS: BYTE PARA ALMACENAR EL SLOT DE LA BIOS
; SLOTGAME: BYTE PARA ALMACENAR EL SLOT DEL JUEGO
SETPAGES48K:    ; --- Posiciona las paginas de un cartucho de 48K ---
    call SETPAGES32K         ; Colocamos la pagina 2 del cartucho
    ; --- Guardamos el slot de la BIOS por si tenemos que restaurarla ---
    ld  a,(#FCC1)           ; Valor del slot de la BIOS
    ld  (SLOTBIOS),a            ; Grabamos el slot de la BIOS para recuperarlo si hace falta
    ; --- Guardamos el slot del juego por si hay que restaurarlo ---
    call RSLREG              ; Leemos el contenido del registro de seleccion de slots
    rrca                    ; Rotamos a la derecha...
    rrca                    ; ...dos veces
    call GETSLOT             ; Obtenemos el slot de la pagina 1 ($4000-$7FFF) y volvemos
    ld  (SLOTGAME),a            ; Grabamos el slot del juego para recuperarlo si hace falta
SETGAMEPAGE0:   ; --- RUTINA QUE POSICIONA LA PAGINA 0 DEL JUEGO ---
    ; ---     ANTES HAY QUE LLAMAR A SETPAGES48K     ---
    ld  a,(SLOTGAME)            ; Leemos el slot del juego
    jp  SETPAGE0            ; Situamos la pagina 0 del juego y volvemos
RESTOREBIOS:    ; --- RUTINA QUE VUELVE A SITUAR LA BIOS ---
    ; --- ANTES HAY QUE LLAMAR A SETPAGES48K ---
    ld  a,(SLOTBIOS)            ; Leemos el slot de la BIOS
SETPAGE0:   ; --- RUTINA QUE POSICIONA SLOT EN LA PAGINA 0 ---
    ; --- AUTOR: Ramones                           ---
    ; --- ENTRADA: a = slot con formato FxxxSSPP   ---
    di                  ; Desactivamos las interrupciones
    ld b,a             ; Guardamos el slot
    in a,(#0A8)            ; Leemos el registro principal de slots
    and #FC             ; Nos quedamos con los valores de las tres paginas superiores
    ld d,a             ; D = Valor del slot primario
    ld a,b             ; Recuperamos el slot
    and #03             ; Nos fijamos en el slot primario
    or d               ; Colocamos los bits de las paginas superiores
    ld d,a             ; Guardamos en D el valor final para el slot primario
    ; Comprobamos si esta expandido
    ld a,b             ; Recuperamos el slot
    bit 7,a             ; Miramos el bit de expansion
    jr z,SETPAGE0_SETPRIMARY          ; ...y saltamos si no esta expandido
    ; Si llegamos aqui el slot esta expandido
    and #03             ; Nos quedamos con el slot primario
    rrca                    ; Rotamos ciclicamente a la derecha una...
    rrca                    ; ...y dos veces
    ld c,a             ; Guardamos el valor en c
    ld a,d             ; Recuperamos el valor final para el slot primario
    and #3F             ; Nos quedamos con las paginas 0, 1 y 2
    or c               ; Colocamos los bits para la pagina 3
    ld c,a             ; C:=valor del slot primario incluso en pagina 3
    ld a,b             ; Recuperamos otra vez el slot
    and #0C             ; Nos quedamos con el valor del subslot
    rrca                    ; Rotamos ciclicamente a la derecha una...
    rrca                    ; ...y dos veces
    ld b,a             ; B:= Slot expandido en pagina 3
    ld a,c             ; valor del slot primario incluyendo pagina 3
    out (#A8),a             ; Slots : Primario, xx, xx, Primario
    ld a,(#FFFF)           ; Leemos registro de seleccion de subslots
    cpl                 ; Complementamos (recordemos que siempre hay que complementarlo)
    and #FC             ; Nos quedamos con las paginas superiores
    or b               ; Colocamos el valor del slot expandido en pagina 0
    ld (#FFFF),a           ; Seleccionamos el slot expandido
SETPAGE0_SETPRIMARY:   ; --- Colocamos el slot primario ---
    ld a,d             ; Valor final del slot primario
    out (#A8),a             ; Slots: Seleccionado, xx, xx, Ram
    ret                 ; Volvemos


;-----------------------------------------------
; changes to page 0, unpacks the content, and resets the BIOS
pletter_unpack_from_page0:
    push hl
    push de
    call SETGAMEPAGE0
    pop de
    pop hl

    call pletter_unpack

    call RESTOREBIOS
    ei  ; since these functions disable interrupts    
    ret

;-----------------------------------------------
; source: https://www.msx.org/forum/development/msx-development/how-0?page=0
; returns 1 in a and clears z flag if vdp is 60Hz
; size: 27 bytes
CheckIf60Hz:
    di
    in      a,(#99)
    nop
    nop
    nop
vdpSync:
    in      a,(#99)
    and     #80
    jr      z,vdpSync
    
    ld      hl,#900
vdpLoop:
    dec     hl
    ld      a,h
    or      l
    jr      nz,vdpLoop
    
    in      a,(#99)
    rlca
    and     1
    ei
    ret


;-----------------------------------------------
; divide by 16 HL
;divide_HL_by_16: 
;    ld a,h
;    and a
;    jp m,divide_HL_by_16_neg
;    rrca    
;    rr l
;    rrca
;    rr l
;    rrca
;    rr l
;    rrca
;    rr l
;    and 15
;    ld h,a
;    ret
;divide_HL_by_16_neg:
;    rrca    
;    rr l
;    rrca
;    rr l
;    rrca
;    rr l
;    rrca
;    rr l
;    or 0F0h
;    ld h,a
;    ret


;-----------------------------------------------
; Divide "hl" by "d", output is:
; - division result in "hl"
; - remainder in "a"
; Code borrowed from: //sgate.emt.bme.hu/patai/publications/z80guide/part4.html
Div8:                            ; this routine performs the operation HL=HL/D
    push bc
    xor a                          ; clearing the upper 8 bits of AHL
    ld b,16                        ; the length of the dividend (16 bits)
Div8Loop:
    add hl,hl                      ; advancing a bit
    rla
    cp d                           ; checking if the divisor divides the digits chosen (in A)
    jp c,Div8NextBit               ; if not, advancing without subtraction
    sub d                          ; subtracting the divisor
    inc l                          ; and setting the next digit of the quotient
Div8NextBit:
    djnz Div8Loop
    pop bc
    ret


;-----------------------------------------------
; Multiply "de" by "a", output is:
; - multiplication result in "hl"
; Code borrowed from: http://sgate.emt.bme.hu/patai/publications/z80guide/part4.html
Mul8:                            ; this routine performs the operation HL=DE*A
    ld hl,0                        ; HL is used to accumulate the result
    ld b,8                         ; the multiplier (A) is 8 bits wide
Mul8Loop:
    rrca                           ; putting the next bit into the carry
    jp nc,Mul8Skip                 ; if zero, we skip the addition (jp is used for speed)
    add hl,de                      ; adding to the product if necessary
Mul8Skip:
    sla e                          ; calculating the next auxiliary product by shifting
    rl d                           ; DE one bit leftwards (refer to the shift instructions!)
    djnz Mul8Loop
    ret

Mul8SignedA:
    or a
    jp p,Mul8
    neg
    call Mul8
    ; negate the sign of hl:
    xor a
    sub l
    ld l,a
    sbc a,a
    sub h
    ld h,a
    ret    


;-----------------------------------------------
; Code borrowed from: http://z80-heaven.wikidot.com/math#toc24
;Inputs:
;     C is the numerator
;     D is the denominator
;Outputs:
;     A is the remainder
;     B is 0
;     C is the result of C/D
;     D,E,H,L are not changed
;
;C_Div_D:
;    ld b,8
;    xor a
;    sla c
;    rla
;    cp d
;    jr c,$+4
;    inc c
;    sub d
;    djnz $-8
;    ret


;-----------------------------------------------
; Ensures HL is not larger than BC
hl_not_larger_than_bc:
    push hl
    xor a
    sbc hl,bc
    pop hl
    ret m
    ld h,b
    ld l,c
    ret


;-----------------------------------------------
; Ensures HL is not smaller than BC
hl_not_smaller_than_bc:
    push hl
    xor a
    sbc hl,bc
    pop hl
    ret p
    ld h,b
    ld l,c
    ret


;-----------------------------------------------
; Source: https://www.msx.org/forum/msx-talk/development/8-bit-atan2?page=0
; - Modifications:
;   - added special comparison cases for when either B or C are 0, which did not produce accurate results
;     in the original implementation
; 8-bit atan2
; Calculate the angle, in a 256-degree circle.
; The trick is to use logarithmic division to get the y/x ratio and
; integrate the power function into the atan table. 
;   input
;   B = x, C = y    in -128,127
;
;   output
;   A = angle       in 0-255
;      |
;  q1  |  q0
;------+-------
;  q3  |  q2
;      |
atan2:  
        ld  de,#8000           
        
        ld  a,c
        add a,d
        rl  e               ; y-                    
        
        ld  a,b
        add a,d
        rl  e               ; x-                    
        
        dec e
        jp  z,atan2_q1
        dec e
        jp  z,atan2_q2
        dec e
        jp  z,atan2_q3
        
atan2_q0:        
        ld  a,c     ; added by santi (if c == 0, and we are in q0, we know the angle is 0)
        or  a       ; added by santi
        ret z       ; added by santi
        ld  a,b     ; added by santi (if c == 0, and we are in q0, we know the angle is 64)
        or  a       ; added by santi
        jp  nz, atan2_q0_continue      ; added by santi
        ld  a,64    ; added by santi
        ret         ; added by santi
atan2_q0_continue:  ; added by santi
        ld  h,log2_tab / 256
        ld  l,b
        
        ld  a,(hl)          ; 32*log2(x)
        ld  l,c
        
        sub (hl)          ; 32*log2(x/y)
        
        jr  nc,atan2_1f           ; |x|>|y|
        neg             ; |x|<|y|   A = 32*log2(y/x)
atan2_1f:      
        ld  l,a

        ld  h,atan_tab / 256
        ld  a,(hl)
        ret c           ; |x|<|y|
        
        neg
        and #3F            ; |x|>|y|
        ret
                
atan2_q1:     
        ld  a,c     ; added by santi (if c == 0, and we are in q1, we know the angle is 128)
        or  a       ; added by santi
        jp  nz, atan2_q1_continue      ; added by santi
        ld  a,128    ; added by santi
        ret         ; added by santi
atan2_q1_continue:  ; added by santi
        ld  a,b
        neg
        ld  b,a
        call    atan2_q0
        neg
        and #7F
        ret
        
atan2_q2:     
        ld  a,c
        neg
        ld  c,a
        call    atan2_q0
        neg
        ret     
        
atan2_q3:     
        ld  a,b
        neg
        ld  b,a
        ld  a,c
        neg
        ld  c,a
        call    atan2_q0
        add a,128
        ret


;-----------------------------------------------
; Computes the absolute value of A
a_absolute_value:
    bit 7,a
    ret z
    neg
    ret
    


;-----------------------------------------------
; draws a 16 bit number to the VDP
; - de: position in the VDP to render to (starting form the right)
; - hl: number to draw
draw_right_aligned_16bit_number_to_vdp:
draw_right_aligned_16bit_number_to_vdp_loop:
    push de
    ld d,10
    call Div8   ; hl = hl/10, a = hl%10
    pop de
    add a,'0'
    push hl
    push de
    push de
    pop hl
    call writeByteToVDP
    pop de
    pop hl
    dec de
    ld a,h
    or l
    jr nz,draw_right_aligned_16bit_number_to_vdp_loop
    ret


;-----------------------------------------------
; draws a 16 bit number to the VDP
; - de: position in memory to render to (starting form the right)
; - hl: number to draw
draw_right_aligned_16bit_number_to_memory:
draw_right_aligned_16bit_number_to_memory_loop:
    push de
    ld d,10
    call Div8   ; hl = hl/10, a = hl%10
    pop de
    add a,'0'
    ld (de),a
    dec de
    ld a,h
    or l
    jr nz,draw_right_aligned_16bit_number_to_memory_loop
    ret


;-----------------------------------------------
; A couple of useful macros for adding 16 and 8 bit numbers

ADD_HL_A: MACRO 
    add a,l
    ld l,a
    jr nc, $+3
    inc h
    ENDM


ADD_DE_A: MACRO 
    add a,e
    ld e,a
    jr nc, $+3
    inc d
    ENDM    


ADD_HL_A_VIA_BC: MACRO
    ld b,0
    ld c,a
    add hl,bc
    ENDM

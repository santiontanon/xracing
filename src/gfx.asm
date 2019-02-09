;-----------------------------------------------
; debugging function that creates a 16x16 matrix with all the patterns in screen
;showAllPatterns:
;    ld a,0
;    ld hl,NAMTBL2
;showAllPatterns_loop:
;    call WRTVRM
;    inc hl
;    inc a
;    ld b,a
;    and #0f
;    ld a,b
;    jp nz,showAllPatterns_loop
;    ld bc,32-16
;    add hl,bc
;    or a
;    jp nz,showAllPatterns_loop
;    ret


;-----------------------------------------------
; clear sprites:
clearAllTheSprites:
    xor a
    ld bc,32*4
    ld hl,SPRATR2
    jp FILVRM


;-----------------------------------------------
disable_VDP_output:
    ld a,(VDP_REGISTER_1)
    and #bf ; reset the BL bit
    di
    out (#99),a
    ld  a,1+128 ; write to register 1
    ei
    out (#99),a
    ret


;-----------------------------------------------
enable_VDP_output:
    ld a,(VDP_REGISTER_1)
    or #40  ; set the BL bit
    di
    out (#99),a
    ld  a,1+128 ; write to register 1
    ei
    out (#99),a
    ret


;-----------------------------------------------
; Fills the whole screen with the pattern 0
clearScreen:
    xor a
    ld bc,768
    ld hl,NAMTBL2
    jp FILVRM


;-----------------------------------------------
; Clears the screen left to right
;clearScreenLeftToRight:
;    call clearAllTheSprites
;    ld a,32
;    ld bc,0
;clearScreenLeftToRightExternalLoop
;    push af
;    push bc
;    ld a,24
;    ld hl,NAMTBL2
;    add hl,bc
;clearScreenLeftToRightLoop:
;    push hl
;    push af
;    xor a
;    ld bc,1
;    call FILVRM
;    pop af
;    pop hl
;    ld bc,32
;    add hl,bc
;    dec a
;    jr nz,clearScreenLeftToRightLoop
;    pop bc
;    pop af
;    inc bc
;    dec a
;    halt
;    jr nz,clearScreenLeftToRightExternalLoop
;    ret  


;-----------------------------------------------
; a: byte
; hl: target address in the VDP
writeByteToVDP:
    push af
    call SETWRT
    ld a,(VDP.DW)
    ld c,a
    pop af
    out (c),a
    ret
    

;-----------------------------------------------
; hl: source data
; de: target address in the VDP
; bc: amount to copy
fast_LDIRVM:
    ex de,hl
    push de
    push bc
    call SETWRT
    pop bc
    pop hl
    ; jp copy_to_VDP

;-----------------------------------------------
; This is like LDIRVM, but faster, and assumes, we have already called "SETWRT" with the right address
; input: 
; - hl: address to copy from
; - bc: amount fo copy
copy_to_VDP:
    ; get the VDP write register:
    ld e,b
    ld a,c
    or a
    jr z,copy_to_VDP_lsb_0
    inc e
copy_to_VDP_lsb_0:
    ld b,c
    ld a,(VDP.DW)
    ld c,a
    ld a,e
copy_to_VDP_loop2:
copy_to_VDP_loop:
    outi
    jp nz,copy_to_VDP_loop
;    ld b,256
    dec a
    jp nz,copy_to_VDP_loop2
    ret


;-----------------------------------------------
; decompresses patterns and loads them into the all the bank of the VDP
decompressPatternsToVDPAllBanks:
    ld de,buffer
    call pletter_unpack

decompressPatternsToVDPAllBanks_entry_point:
    ld hl,buffer
    ld de,CHRTBL2
    ld bc,256*8
    call fast_LDIRVM

    ld hl,buffer+2048
    ld de,CLRTBL2
    ld bc,256*8
    call fast_LDIRVM
    
    ld hl,buffer
    ld de,CHRTBL2+256*8
    ld bc,256*8
    call fast_LDIRVM

    ld hl,buffer+2048
    ld de,CLRTBL2+256*8
    ld bc,256*8
    call fast_LDIRVM
    jr decompressPatternsToVDP3rdBank_entry_point


;-----------------------------------------------
; decompresses patterns and loads them into the 3rd bank of the VDP
decompressPatternsToVDP3rdBank:
    ld de,buffer
    call pletter_unpack

decompressPatternsToVDP3rdBank_entry_point:
    ld hl,buffer
    ld de,CHRTBL2+256*8*2
    ld bc,256*8
    call fast_LDIRVM

    ld hl,buffer+2048
    ld de,CLRTBL2+256*8*2
    ld bc,256*8
    jp fast_LDIRVM


;-----------------------------------------------
; This function gets the current patterns from the 3rd bank of the VDP, and then modifies them with
; a given pattern patch.
; input: the pattern patch to decompress are in "HL"
; requirements: this function requires title_buffer to be empty
applyPatternPatch:
    push hl

    ; 1) get the current patterns into the buffer
    ld hl,CHRTBL2+256*8*2
    ld de,buffer
    ld bc,256*8
    push bc
    call LDIRMV
    ld hl,CLRTBL2+256*8*2
    ld de,buffer+256*8
    pop bc
    call LDIRMV

    ; 2) decompress the patch into buffer3
    pop hl
    ld de,buffer+256*8*2
    call pletter_unpack

    ; 3) apply the patch
    ld a,(buffer+256*8*2)
    ld b,a
    ld de,buffer+256*8*2+1
decompressPatternPatchToVDP_loop:
    push bc

    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    inc de      ; bc = offset
    
    ld hl,buffer
    add hl,bc

    ld a,(de)
    ld c,a
    inc de
    ld a,(de)
    ld b,a
    inc de      ; bc = length of the patch

    ex de,hl    ; now "de" = buffer + start, and "hl" = patch data to copy
    ldir
    ex de,hl

    pop bc
    djnz decompressPatternPatchToVDP_loop

    ret


;-----------------------------------------------
; copies all the sprite attributes from RAM to the VDP
uploadSpriteAttributes:
    ld hl,SPRATR2+4*4   ; we skip the 4 initial sprites, only used to protect the scoreboard
    call SETWRT
    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld b,(4 + 4*2 + MAX_MAP_SPRITES_IN_SCREEN)*4
    ld hl,sprite_attributes_buffer+4*4
uploadSpriteAttributes_loop:
    outi    ; this function assumes it is executed right after "halt"
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    jp nz,uploadSpriteAttributes_loop
    ret


;-----------------------------------------------
; uploads the sprite attributes in inverted order
uploadCarSpriteAttributesInverted:
    ld hl,SPRATR2+FIRST_CAR_SPRITE*4   ; pointer to the first car sprite
    call SETWRT
    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld de,-16
    ld hl,sprite_attributes_buffer+(FIRST_CAR_SPRITE+6)*4  ; pointer to the last car sprite
    ld b,8*4
uploadCarSpriteAttributesInverted_loop:
    outi    ; this function assumes it is executed right after "halt"
    outi
    outi
    outi
    outi
    outi
    outi
    outi
    add hl,de
    jp nz,uploadCarSpriteAttributesInverted_loop
    ret


;-----------------------------------------------
; copies the sprite pointed at by "de" to VDP address pointed by "hl"
loadSpriteToVDP:
    push de
    call SETWRT
    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld b,32
    pop hl
loadSpriteToVDP_loop:
    outi
    jp nz,loadSpriteToVDP_loop
    ret


;-----------------------------------------------
; copies the two sprites pointed at by "de" to VDP address pointed by "hl"
loadDoubleSpriteToVDP:
    push de
    call SETWRT
    ; get the VDP write register:
    ld a,(VDP.DW)
    ld c,a
    ld b,64
    pop hl
loadDoubleSpriteToVDP_loop:
    outi
    jp nz,loadDoubleSpriteToVDP_loop
    ret


;-----------------------------------------------
;  unpacks the car sprites, and then generates the missing sprites by inverting a few of them
load_car_sprites:
    ld de,car_sprite_patterns_buffer
    call pletter_unpack

    ; invert sprites horizontally to generate sprites 9 - 16:
    ld hl,car_sprite_patterns_buffer
    ld de,car_sprite_patterns_buffer+16*64
    ld b,8
load_car_sprites_loop_horizontal:
    push bc
        push hl
        push de
            push hl
            push de
            call invert_sprite_in_x
            pop hl
            ld bc,32
            add hl,bc
            ex de,hl
            pop hl
            add hl,bc
            call invert_sprite_in_x
        pop hl
        ld bc,-64
        add hl,bc
        ex de,hl
        pop hl
        ld bc,64
        add hl,bc
    pop bc
    djnz load_car_sprites_loop_horizontal

    ; invert sprites horizontally to generate sprites 17 - 31:
    ld hl,car_sprite_patterns_buffer+64
    ld de,car_sprite_patterns_buffer+31*64
    ld b,15
load_car_sprites_loop:
    push bc
    push hl
    push de
    push hl
    push de
    call invert_sprite_in_y
    pop de
    pop hl
    ld bc,32
    add hl,bc
    ex de,hl
    add hl,bc
    ex de,hl
    call invert_sprite_in_y
    pop de
    pop hl
    ld bc,64
    add hl,bc
    xor a
    ex de,hl
    sbc hl,bc
    ex de,hl
    pop bc
    djnz load_car_sprites_loop
    ret


;-----------------------------------------------
; inverts the y coordinate of a sprite (this is used to auto-generate some 
; of the frames of the car rotation animation, and sace space in the ROM)
; input:
; - hl: original sprite
; - de: target sprite 
invert_sprite_in_y:
    push hl
    push de
    ld bc,15
    ex de,hl
    add hl,bc
    ex de,hl
    ld b,16
invert_sprite_in_y_loop1:
    ld a,(hl)
    ld (de),a
    inc hl
    dec de
    djnz invert_sprite_in_y_loop1
    pop de
    pop hl
    ld bc,16
    add hl,bc
    ld bc,31
    ex de,hl
    add hl,bc
    ex de,hl
    ld b,16
invert_sprite_in_y_loop2:
    ld a,(hl)
    ld (de),a
    inc hl
    dec de
    djnz invert_sprite_in_y_loop2
    ret


;-----------------------------------------------
; inverts the x coordinate of a sprite (this is used to auto-generate some 
; of the frames of the car rotation animation, and sace space in the ROM)
; input:
; - hl: original sprite
; - de: target sprite 
invert_sprite_in_x:
    push hl
    push de    
    exx
        ; we keep pointers to the other columns of the sprite on the shadow registers
        pop de
        pop hl
        ld bc,16
        add hl,bc
    exx
    ld bc,16
    ex de,hl
    add hl,bc
    ex de,hl    ; at this point, we have de pointing to the destination byte for (hl)
    ld b,16
invert_sprite_in_x_external_loop:
    push bc
    ld c,(hl)
    ; reverses byte c into a
    ld b,8
invert_sprite_in_x_loop1:
    sra c
    rl a
    djnz invert_sprite_in_x_loop1
    ld (de),a
    inc hl
    inc de
    exx
        ld c,(hl)
        ; reverses byte c into a
        ld b,8
invert_sprite_in_x_loop2:
        sra c
        rl a
        djnz invert_sprite_in_x_loop2
        ld (de),a
        inc hl
        inc de
    exx    
    pop bc    
    djnz invert_sprite_in_x_external_loop
    ret


;-----------------------------------------------
; changes the color of the semaphore to a specified color
; input:
; - a: color
change_semaphore_color:
    push af
    ld a,(track_tileset)
    or a
    jr nz,change_semaphore_color_urban
    ld hl,CLRTBL2+TILETYPE_SEMAPHORE*8+3
    jr change_semaphore_color_ptr_set
change_semaphore_color_urban:
    ld hl,CLRTBL2+TILETYPE_SEMAPHORE_URBAN*8+3
change_semaphore_color_ptr_set:
    push hl
    call SETWRT
    pop hl
    ld b,5
    ld a,(VDP.DW)
    ld c,a
    pop af
    push af
change_semaphore_color_loop:
    out (c),a
    djnz change_semaphore_color_loop
    ld bc,256*8
    add hl,bc
    ;ld hl,CLRTBL2+(256+TILETYPE_SEMAPHORE)*8+3
    call SETWRT
    ld b,5
    ld a,(VDP.DW)
    ld c,a
    pop af
change_semaphore_color_loop2:
    out (c),a
    djnz change_semaphore_color_loop2
    ret


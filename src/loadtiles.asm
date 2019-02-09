; This file is auto generated

load_game_common_patterns_to_VDP:
    ld a,(track_tileset)
    or a
    jr nz, load_game_common_patterns_to_VDP_urban
    ld hl,patterns_game_common_pletter
    ld de,buffer
    call pletter_unpack
    ld de,CHRTBL2
    ld hl,buffer
    ld bc,1592
    push bc
    call fast_LDIRVM
    ld de,CHRTBL2+256*8
    ld hl,buffer
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2
    ld hl,buffer+1592
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+256*8
    ld hl,buffer+1592
    pop bc
    jp fast_LDIRVM
load_game_common_patterns_to_VDP_urban:
    ld hl,patterns_game_common_urban_pletter
    ld de,buffer
    call pletter_unpack
    ld de,CHRTBL2
    ld hl,buffer
    ld bc,1808
    push bc
    call fast_LDIRVM
    ld de,CHRTBL2+256*8
    ld hl,buffer
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2
    ld hl,buffer+1808
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+256*8
    ld hl,buffer+1808
    pop bc
    jp fast_LDIRVM

load_game_extras0_patterns_to_VDP:
    ld a,(track_tileset)
    or a
    jr nz, load_game_extras0_patterns_to_VDP_urban
    ld de,CHRTBL2+1592
    ld hl,patterns_game_extra0_decompressed
    ld bc,456
    push bc
    call fast_LDIRVM
    ld de,CHRTBL2+1592+256*8
    ld hl,patterns_game_extra0_decompressed
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1592
    ld hl,patterns_game_extra0_decompressed+456
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1592+256*8
    ld hl,patterns_game_extra0_decompressed+456
    pop bc
    jp fast_LDIRVM
load_game_extras0_patterns_to_VDP_urban:
    ld de,CHRTBL2+1808
    ld hl,patterns_game_extra0_urban_decompressed
    ld bc,240
    push bc
    call fast_LDIRVM
    ld de,CHRTBL2+1808+256*8
    ld hl,patterns_game_extra0_urban_decompressed
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1808
    ld hl,patterns_game_extra0_urban_decompressed+240
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1808+256*8
    ld hl,patterns_game_extra0_urban_decompressed+240
    pop bc
    jp fast_LDIRVM
load_game_extras1_patterns_to_VDP:
    ld a,(track_tileset)
    or a
    jr nz, load_game_extras1_patterns_to_VDP_urban
    ld de,CHRTBL2+1592
    ld hl,patterns_game_extra1_decompressed
    ld bc,456
    push bc
    call fast_LDIRVM
    ld de,CHRTBL2+1592+256*8
    ld hl,patterns_game_extra1_decompressed
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1592
    ld hl,patterns_game_extra1_decompressed+456
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1592+256*8
    ld hl,patterns_game_extra1_decompressed+456
    pop bc
    jp fast_LDIRVM
load_game_extras1_patterns_to_VDP_urban:
    ld de,CHRTBL2+1808
    ld hl,patterns_game_extra1_urban_decompressed
    ld bc,232
    push bc
    call fast_LDIRVM
    ld de,CHRTBL2+1808+256*8
    ld hl,patterns_game_extra1_urban_decompressed
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1808
    ld hl,patterns_game_extra1_urban_decompressed+232
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1808+256*8
    ld hl,patterns_game_extra1_urban_decompressed+232
    pop bc
    jp fast_LDIRVM
load_game_extras2_patterns_to_VDP:
    ld a,(track_tileset)
    or a
    jr nz, load_game_extras2_patterns_to_VDP_urban
    ret
load_game_extras2_patterns_to_VDP_urban:
    ld de,CHRTBL2+1808
    ld hl,patterns_game_extra2_urban_decompressed
    ld bc,224
    push bc
    call fast_LDIRVM
    ld de,CHRTBL2+1808+256*8
    ld hl,patterns_game_extra2_urban_decompressed
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1808
    ld hl,patterns_game_extra2_urban_decompressed+224
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1808+256*8
    ld hl,patterns_game_extra2_urban_decompressed+224
    pop bc
    jp fast_LDIRVM
load_game_extras3_patterns_to_VDP:
    ld a,(track_tileset)
    or a
    jr nz, load_game_extras3_patterns_to_VDP_urban
    ret
load_game_extras3_patterns_to_VDP_urban:
    ld de,CHRTBL2+1808
    ld hl,patterns_game_extra3_urban_decompressed
    ld bc,240
    push bc
    call fast_LDIRVM
    ld de,CHRTBL2+1808+256*8
    ld hl,patterns_game_extra3_urban_decompressed
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1808
    ld hl,patterns_game_extra3_urban_decompressed+240
    pop bc
    push bc
    call fast_LDIRVM
    ld de,CLRTBL2+1808+256*8
    ld hl,patterns_game_extra3_urban_decompressed+240
    pop bc
    jp fast_LDIRVM

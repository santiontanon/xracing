    org #0000

    include "../constants.asm"

ear_sprite: ; yellow
    db #00,#00,#00,#00,#80,#80,#c0,#c0,#80,#80,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
smile_sprite:   ; white
    db #00,#00,#00,#00,#00,#00,#0e,#00,#00,#00,#00,#00,#00,#80,#c0,#f8
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#04,#0e,#3f
neutral_sprite:   ; white
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80,#c0,#f8
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#04,#0e,#3f
anger_sprite:   ; white
    db #00,#00,#00,#00,#00,#0f,#00,#00,#00,#00,#00,#00,#00,#80,#c0,#f8
    db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#04,#0e,#3f

ear_sprite_attributes:
    db 19*8-1,5*8,0,COLOR_DARK_YELLOW
smile_sprite_attributes:
    db 20*8-1,3*8+1,4,COLOR_WHITE

smile:
    db 110,111

anger:
    db 126,127,142,143


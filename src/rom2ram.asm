    org #0000

    include "constants.asm"

ROM_scoreboard_message_buffer:
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db "LADIES AND GENTLEMEN START YOUR ENGINES!"   ; the very first message when a race starts!
    db 0
ROM_scoreboard_draw_buffer:
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0,20,21, 0, 0, 0
ROM_scoreboard_timer_buffer:
    db 48,58,48,48,58,48,48 ; 0:00:00
ROM_scoreboard_position_buffer:
    db '4', 22  ; 4th
ROM_current_lap:    ; we store as the character, so we can draw it ieasily in the scoreboard
    db 49   ; number "1"
    db 49   ; number "1"
    db 49   ; number "1"
    db 49   ; number "1"
ROM_sprite_attributes_buffer:
    db 200, 0, CAR_POINTER_SPRITE_PATTERN, 8    ; player car pointer
    db 200, 0, CAR_POINTER_SPRITE_PATTERN, 10   ; enemy car pointers
    db 200, 0, CAR_POINTER_SPRITE_PATTERN, 10   ; enemy car pointers
    db 200, 0, CAR_POINTER_SPRITE_PATTERN, 10   ; enemy car pointers

    db 127, 255, 0, 1   ; sprites to protect the scoreboard
    db 127, 255, 0, 1   ; sprites to protect the scoreboard
    db 127, 255, 0, 1   ; sprites to protect the scoreboard
    db 127, 255, 0, 1   ; sprites to protect the scoreboard

    db 255, 28, SEMAPHORE_SPRITE_PATTERN, 1   ; sprites for the semaphore
    db 255, 44, SEMAPHORE_SPRITE_PATTERN+4, 1   ; 
    db 255, 60, SEMAPHORE_SPRITE_PATTERN+4, 1   ; 
    db 255, 76, SEMAPHORE_SPRITE_PATTERN+8, 1   ; 

    db 0, 0, 4, 1   ; player car        (red)
    db 0, 0, 8, COLOR_RED
    db 0, 0, 12, 1  ; opponnent car 1   (blue)
    db 0, 0, 16, COLOR_BLUE
    db 0, 0, 20, 1  ; opponnent car 2   (yellow)
    db 0, 0, 24, COLOR_DARK_YELLOW
    db 0, 0, 28, 1  ; opponnent car 3   (white)
    db 0, 0, 32, COLOR_WHITE

    db 200, 0, TREE_SPRITE_PATTERN, 1    ; map sprites
    db 200, 0, TREE_SPRITE_PATTERN, 1
    db 200, 0, TREE_SPRITE_PATTERN, 1
    db 200, 0, TREE_SPRITE_PATTERN, 1
    db 200, 0, TREE_SPRITE_PATTERN, 1
    db 200, 0, TREE_SPRITE_PATTERN, 1

    db 0, 0, 0, 0
    db 0, 0, 0, 0
    db 0, 0, 0, 0
    db 0, 0, 0, 0
    db 0, 0, 0, 0
    db 0, 0, 0, 0

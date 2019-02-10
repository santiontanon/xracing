    include "constants.asm"


;-----------------------------------------------
; PAGE 1:
    org #0000

races_pletter:
    incbin "races.plt"

    db TILESET_GRASS
track1_pletter:
    incbin "maps/track1.plt"

    db TILESET_GRASS
track2_pletter:
    incbin "maps/track2.plt"

    db TILESET_URBAN
track3_pletter:
    incbin "maps/track3-urban.plt"

    db TILESET_URBAN
track4_pletter:
    incbin "maps/track4-urban.plt"

    db TILESET_GRASS
track5_pletter:
    incbin "maps/track5.plt"

    db TILESET_URBAN
track6_pletter:
    incbin "maps/track6-urban.plt"

    db TILESET_GRASS
track7_pletter:
    incbin "maps/track7.plt"

    db TILESET_URBAN
track8_pletter:
    incbin "maps/track8-urban.plt"

    db TILESET_GRASS
track9_pletter:
    incbin "maps/track9.plt"

    db TILESET_GRASS
track10_pletter:
    incbin "maps/track10.plt"

    db TILESET_GRASS
track11_pletter:
    incbin "maps/track11.plt"

agent_texts_pletter:
    incbin "agent-texts.plt"

base_sprites_pletter:
    incbin "gfx/base-sprites.plt"

ending_data_pletter:
    incbin "gfx/ending-data.plt"

ending_song_pletter:
    incbin "music/ending-song.plt"

title_song_pletter:
    incbin "music/title-song.plt"

title_ingame1_song_pletter:
    incbin "music/ingame1-song.plt"

carmarket_screen_pletter:
    incbin "gfx/carmarket-screen.plt"


EndofPage0Data:

;-----------------------------------------------
; PAGE 2:

    ds #4000-$
;    org #4000   ; Start in the 2nd slot
StartOfPage2:

;-----------------------------------------------
    db "AB"     ; ROM signature
    dw Execute  ; start address
    db 0,0,0,0,0,0,0,0,0,0,0,0
;-----------------------------------------------


;-----------------------------------------------
; Code that gets executed when the game starts
Execute:
    ; init the stack:
    ld sp,#F380
    ; reset some interrupts to make sure it runs in some MSX computers 
    ; with disk controllers installed in some interrupt handlers
    di
    ld a,#C9
    ld (HKEY),a
;    ld (TIMI),a
    ei

    call SETPAGES48K
    call RESTOREBIOS
    ei  ; since these functions disable interrupts

    ; Silence, init keyboard, and clear config:
    xor a
    ld (global_options),a
    ld (CLIKSW),a
    ; Change background colors:
    ld (BAKCLR),a
    ld (BDRCLR),a
    call CHGCLR
   
    ld a,2      ; Change screen mode
    call CHGMOD

    ;; 16x16 sprites:
    ld bc,#e201  ;; write #e2 in VDP register #01 (activate sprites, generate interrupts, 16x16 sprites with no magnification)
    call WRTVDP

    call CheckIf60Hz
    ld (isComputer50HzOr60Hz),a
    
    ; to prevent the engine SFX:
    ld a,RACE_STATE_RACE_OVER
    ld (race_state),a

    call StopPlayingMusic
    call setup_music_interrupt

    jp splash_screen
    ;jp start_new_game
    ;jp gameover_screen
    ;jp ending_screen


;-----------------------------------------------
; additional assembler files source code:
    include "auxiliar.asm"  ; auxiliar is first, since some of these routines NEED to be in page 1 (e.g., the slot setup routines)
    include "gameloop.asm"
    include "input.asm"
    include "player.asm"
    include "cars.asm"
    include "ai.asm"
    include "gfx.asm"
    include "maps.asm"
    include "scroll.asm"
    include "collisions.asm"
    include "scoreboard.asm"
    include "loadtiles.asm"
    include "tables.asm"
    include "sound.asm"
    include "splash.asm"
    include "title.asm"
    include "gameover.asm"
    include "ending.asm"
    include "agent.asm"
    include "menu-season.asm"
    include "menu-options.asm"
    include "menu-carmarket.asm"
    include "menu-standings.asm"
    include "menu-races.asm"
    include "menu-race-finished.asm"    
EndofCode:

    ; include "gfx/tileTypes.asm"
    ; include "gfx/tileTypes-urban.asm"
tileTypes_pletter:
    incbin "gfx/tileTypes.plt"
tileTypes_urban_pletter:
    incbin "gfx/tileTypes-urban.plt"

scoreboard_pletter:
    incbin "gfx/scoreboard.plt"

confirmation_dialogue_pletter:
    incbin "gfx/confirmation.plt"

message_dialogue_pletter:
    incbin "gfx/message.plt"

;patterns_game_extra_ptr_table:
;    dw patterns_game_extra0_pletter
;    dw patterns_game_extra1_pletter
;    dw patterns_game_extra2_pletter
;    dw patterns_game_extra3_pletter

patterns_game_common_pletter:
    incbin "gfx/tiles-common.plt"
patterns_game_extra0_pletter:
    incbin "gfx/tiles-extra0.plt"
patterns_game_extra1_pletter:
    incbin "gfx/tiles-extra1.plt"
;patterns_game_extra2_pletter:
;    incbin "gfx/tiles-extra2.plt"

patterns_game_common_urban_pletter:
    incbin "gfx/tiles-urban-common.plt"
patterns_game_extra0_urban_pletter:
    incbin "gfx/tiles-urban-extra0.plt"
patterns_game_extra1_urban_pletter:
    incbin "gfx/tiles-urban-extra1.plt"
patterns_game_extra2_urban_pletter:
    incbin "gfx/tiles-urban-extra2.plt"
patterns_game_extra3_urban_pletter:
    incbin "gfx/tiles-urban-extra3.plt"
;patterns_game_extra4_urban_pletter:
;    incbin "gfx/tiles-urban-extra4.plt"

patterns_base_pletter:
    incbin "gfx/tiles-base.plt"
patterns_patch_base_title_pletter:
    incbin "gfx/patch-base-title.plt"
patterns_patch_base_game_pletter:
    incbin "gfx/patch-base-game.plt"
patterns_patch_base_race_finished_pletter:
    incbin "gfx/patch-base-race-finished.plt"

title_data_pletter:
    incbin "gfx/title-data.plt"

stock_car_sprites_pletter:
    incbin "gfx/car1.plt"
endurance_car_sprites_pletter:
    incbin "gfx/car2.plt"
f1_car_sprites_pletter:
    incbin "gfx/car3.plt"

agent_sprites_pletter:
    incbin "gfx/agent-sprites.plt"

EndOfPatternData:

flag_nametables_pletter:
    incbin "gfx/flag-nametables.plt"
flag_patterns_pletter:
    incbin "gfx/flag-patterns.plt"


gamestart_song_pletter:
    incbin "music/gamestart-song.plt"
gameover_song_pletter:
    incbin "music/gameover-song.plt"

;-----------------------------------------------
; menu screens:
season_screen_pletter:
    incbin "gfx/season-screen.plt"
;carmarket_screen_pletter:
;    incbin "gfx/carmarket-screen.plt"
standings_screen_pletter:
    incbin "gfx/standings-screen.plt"
races_screen_pletter:
    incbin "gfx/races-screen.plt"
race_finished_screen_pletter:
    incbin "gfx/race-finished-screen.plt"

;-----------------------------------------------
; Additional data:
category_stock_welcome:
    db "CATEGORY:  STOCK CAR"
category_endurance_welcome:
    db "CATEGORY:  ENDURANCE"
category_f1_welcome:
    db "CATEGORY:  FORMULA 1"
category_stock:
    db "STOCK"
category_endurance:
    db "ENDCE"
category_f1:
    db " F-1 "
season_year_stock:  ; 1983
    db #72, #00, #70, #71, #70, #71, #73, #71
    db #82, #83, #76, #87, #84, #87, #76, #87
season_year_endurance:  ; 1985
    db #72, #00, #70, #71, #70, #71, #70, #75
    db #82, #83, #76, #87, #84, #87, #76, #87
season_year_f1:  ; 1988
    db #72, #00, #70, #71, #70, #71, #70, #71
    db #82, #83, #76, #87, #84, #87, #84, #87
max_races_stock:
    db 4
max_races_endurance:
    db 4
max_races_f1:
    db 7

; STOCK car definition
CAR_DEFINITION_ENIAK_100K:
    dw reverse_gear_64
    dw low_gear_96
    dw high_gear_160
    db 30               ; speed at which auto gear will shift up (+6)
    db " ENIAC 100K "   ; name  (+7)
    db 10               ; price in $K   (+19)
    db 160              ; max speed     (+20)
    ;dw 1492             ; weight        (+21)
    db "9.2"            ; acceleration  (+23)
    db COLOR_RED        ; car sprite color  (+26)

CAR_DEFINITION_NAMCO_PONY:
    dw reverse_gear_64
    dw low_gear_96
    dw high_gear_176
    db 30               ; speed at which auto gear will shift up
    db " NAMCO PONY "   ; name
    db 12               ; price in $K
    db 176              ; max speed
    ;dw 1450             ; weight   
    db "8.9"            ; acceleration
    db COLOR_LIGHT_BLUE ; car sprite color

CAR_DEFINITION_SIMCA_1000:
    dw reverse_gear_64
    dw low_gear_96
    dw high_gear_176b
    db 30               ; speed at which auto gear will shift up
    db " SIMCA 1000 "   ; name
    db 13               ; price in $K
    db 176              ; max speed
    ;dw 1410             ; weight   
    db "8.6"            ; acceleration
    db COLOR_YELLOW       ; car sprite color

; ENDURANCE car definition
CAR_DEFINITION_MATRA_530:
    dw reverse_gear_64
    dw low_gear_128
    dw high_gear_192
    db 40               ; speed at which auto gear will shift up
    db " MATRA 530A "   ; name
    db 25               ; price in $K
    db 192              ; max speed
    ;dw 1375             ; weight   
    db "6.5"            ; acceleration
    db COLOR_LIGHT_BLUE ; car sprite color

CAR_DEFINITION_ASTRAN_CPC:
    dw reverse_gear_64
    dw low_gear_128
    dw high_gear_208
    db 40               ; speed at which auto gear will shift up
    db " ASTRAN CPC "   ; name
    db 28               ; price in $K
    db 208              ; max speed
    ;dw 1350             ; weight   
    db "6.2"            ; acceleration
    db COLOR_DARK_GREEN ; car sprite color

CAR_DEFINITION_PORCH_ZX81:
    dw reverse_gear_64
    dw low_gear_128
    dw high_gear_208b
    db 40               ; speed at which auto gear will shift up
    db " PORCH ZX81 "   ; name
    db 30               ; price in $K
    db 208              ; max speed
    ;dw 1290             ; weight   
    db "5.9"            ; acceleration
    db COLOR_YELLOW       ; car sprite color

; F-1 car definition
CAR_DEFINITION_FOYOTA_MSX:
    dw reverse_gear_64
    dw low_gear_128
    dw high_gear_224
    db 40               ; speed at which auto gear will shift up
    db " FOYOTA MSX "   ; name
    db 72               ; price in $K
    db 224              ; max speed
    ;dw 790             ; weight   
    db "4.4"            ; acceleration
    db COLOR_YELLOW       ; car sprite color

CAR_DEFINITION_LOLA_VG8020:
    dw reverse_gear_80
    dw low_gear_144
    dw high_gear_240b
    db 48               ; speed at which auto gear will shift up
    db " LOLA VG8020"   ; name
    db 88               ; price in $K
    db 240              ; max speed
    ;dw 770             ; weight   
    db "3.6"            ; acceleration
    db COLOR_LIGHT_BLUE ; car sprite color

CAR_DEFINITION_PERRARI_Z80:
    dw reverse_gear_80
    dw low_gear_160
    dw high_gear_240c
    db 48               ; speed at which auto gear will shift up
    db " PERRARI Z80"   ; name
    db 96               ; price in $K
    db 240              ; max speed
    ;dw 750             ; weight   
    db "3.2"            ; acceleration
    db COLOR_RED        ; car sprite color


; Rival names (16 bytes per name)
rival_names_stock:
    db "PLAYER          "
    db "SEBASTIAN LOEF  "
    db "NINO MARINA     "
    db "NELSON PICOT    "
    db "TIMI RAIDONEN   "
    db "JAMES HUNTED    "
    db "JAMON HILL      "
    db "MARCOS SAINZ    "
rival_names_endurance:
    db "PLAYER          "
    db "JOLIN MCREA     "
    db "TIM CLARK       "
    db "J.M. FUNGIO     "
    db "MIKA MACHINEN   "
    db "TIKI LAUDA      "
    db "SEBASTIAN PETEL "
    db "E. PITIPANDI    "
rival_names_f1:
    db "PLAYER          "
    db "ALBERTO ATARI   "   
    db "NIGEL PANSELL   "
    db "AYRTON SENDUP   "
    db "ALAN FROST      "
    db "MICHAEL FOOMAKER"   
    db "LEWIS SPAMILTON "
    db "FERNANDO ALFONSO"   


track_pointers:
    dw track1_pletter
    dw track2_pletter
    dw track3_pletter
    dw track4_pletter
    dw track5_pletter
    dw track6_pletter
    dw track7_pletter
    dw track8_pletter
    dw track9_pletter
    dw track10_pletter
    dw track11_pletter


; gear profiles:
;reverse_gear_64:
;    db 64,64,40,32,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0
reverse_gear_80:
    db 64
reverse_gear_64:
    db 64,64,40, 32, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0

low_gear_96:
    db 64,64,64,48, 32, 8, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0
low_gear_128:
    db 64,64,64,54, 48,32,16, 4,  0, 0, 0, 0,  0, 0, 0, 0
;low_gear_144:
;    db 64,64,64,64, 48,40,28,12,  4, 0, 0, 0,  0, 0, 0, 0
low_gear_160:
    db 64
low_gear_144:
    db 64,64,64, 64,48,40,28, 12, 4, 0, 0,  0, 0, 0, 0

high_gear_160:
    db 14,24,40,64, 64,48,40,32, 16, 4, 0, 0,  0, 0, 0, 0
high_gear_176:
    db 14,24,40,64, 64,56,48,40, 24,12, 4, 0,  0, 0, 0, 0
high_gear_176b:
    db 20,30,40,64, 64,64,56,48, 32,20, 8, 0,  0, 0, 0, 0

high_gear_192:
    db 14,20,36,54, 64,64,52,48, 40,32,16, 4,  0, 0, 0, 0
high_gear_208:
    db 14,20,36,54, 64,64,56,52, 48,32,32, 8,  4, 0, 0, 0
high_gear_208b:
    db 14,20,36,54, 64,64,64,56, 48,40,32,16,  8, 0, 0, 0

high_gear_224:
    db 14,14,32,44, 60,64,64,64, 64,40,32,32, 16, 8, 0, 0
high_gear_240b:
    db 20,24,36,48, 62,64,64,64, 64,44,34,34, 20,10, 4, 0
high_gear_240c:
    db 24,30,40,56, 64,64,64,64, 64,48,40,36, 28,16, 8, 0

carmarket_screen_sprites:
    db 4*8-1,14*8+4,0,1
    db 4*8-1,14*8+4,4,COLOR_RED

    db 10*8-1,14*8+4,0,1
    db 10*8-1,14*8+4,4,COLOR_RED

    db 16*8-1,14*8+4,0,1
    db 16*8-1,14*8+4,4,COLOR_RED

large_digit_patterns:
    db #70, #71, #80, #81   ; 0
    db #72, #00, #82, #83   ; 1
    db #73, #71, #84, #85   ; 2
    db #73, #71, #76, #87   ; 3
    db #77, #78, #88, #7d   ; 4
    db #70, #75, #76, #87   ; 5
    db #70, #75, #84, #87   ; 6
    db #73, #71, #00, #74   ; 7
    db #70, #71, #84, #87   ; 8
    db #70, #71, #76, #87   ; 9

gear_patterns:
    db #70, #71, #79, #7a   ; R
    db #77, #00, #80, #7b   ; L
    db #77, #78, #7c, #7d   ; H


;-----------------------------------------------
; Splash screen text:
message_brain_games:
    db "BRAIN  GAMES"
message_game_over:
    db "GAME  OVER"

message_press_space:
    db "PRESS  SPACE"

message_santi:
    db "SANTI ONTANON (2019) BRAIN GAMES"

options_text_auto_gears:
    db "GEARS: AUTO  "
options_text_manual_gears
    db "GEARS: MANUAL"
options_text_music_on:
    db "SOUND: MUSIC "
options_text_music_off:
    db "SOUND: ENGINE"
;options_text_engine_sfx_on:
;    db "ENG. SFX: ON "
;options_text_engine_sfx_off:
;    db "ENG. SFX: OFF"
options_text_other_sfx_on:
    db "SFX: ON      "
options_text_other_sfx_off:
    db "SFX: OFF     "
options_text_back:
    db "BACK         "

carmarket_text_sell:
    db "SELL"
carmarket_text_owned:
    db "(OWNED)"
carmarket_text_need_to_own_a_car:
    db "CANNOT LEAVE WITH NO CAR!"
carmarket_text_not_enough_cash:
    db "NOT ENOUGH CASH!"


;-----------------------------------------------
; In-game messages:
message_final_lap:
    db "FINAL LAP!                              "
message_fastest_lap:
    db "FASTEST LAP!                            "
message_race_over:
    db "YOUR CAR IS WRECKED! RACE OVER!!        "

;-----------------------------------------------
; Game variables to be copied to RAM when a new game starts
ROM2RAM_gameStart:
ROM_game_progress_category:
    db 0
ROM_game_progress_race_number:      
    db 0
ROM_game_progress_cash:             
    dw 5    ; cash is x100
ROM_game_progress_points:           
    db 0, 0, 0, 0, 0, 0, 0, 0
ROM_game_progress_current_car:      
    dw CAR_DEFINITION_ENIAK_100K
ROM_game_progress_agent_mood:
    db AGENT_MOOD_NEUTRAL
ROM_game_progress_races_completed:
    db 0, 0, 0, 0, 0, 0, 0, 0
ROM_game_progress_season_state:
    db 0
ROM_game_progress_last_agent_tip:
    db 0
endOfROM2RAM_gameStart


;-----------------------------------------------
; Game variables to be copied to RAM when a race starts
ROM2RAM_raceStart:
    incbin "rom2ram.plt"

endOfROM:
;    ds (((($-1)/#4000)+1)*#4000-$) - 512
    ds (#c000-$) - 512

        ;;;;;;;; atan(2^(x/32))*128/pi ;;;;;;;;
atan_tab:   
        db #20,#20,#20,#21,#21,#22,#22,#23,#23,#23,#24,#24,#25,#25,#26,#26
        db #26,#27,#27,#28,#28,#28,#29,#29,#2A,#2A,#2A,#2B,#2B,#2C,#2C,#2C
        db #2D,#2D,#2D,#2E,#2E,#2E,#2F,#2F,#2F,#30,#30,#30,#31,#31,#31,#31
        db #32,#32,#32,#32,#33,#33,#33,#33,#34,#34,#34,#34,#35,#35,#35,#35
        db #36,#36,#36,#36,#36,#37,#37,#37,#37,#37,#37,#38,#38,#38,#38,#38
        db #38,#39,#39,#39,#39,#39,#39,#39,#39,#3A,#3A,#3A,#3A,#3A,#3A,#3A
        db #3A,#3B,#3B,#3B,#3B,#3B,#3B,#3B,#3B,#3B,#3B,#3B,#3C,#3C,#3C,#3C
        db #3C,#3C,#3C,#3C,#3C,#3C,#3C,#3C,#3C,#3D,#3D,#3D,#3D,#3D,#3D,#3D
        db #3D,#3D,#3D,#3D,#3D,#3D,#3D,#3D,#3D,#3D,#3D,#3D,#3E,#3E,#3E,#3E
        db #3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E
        db #3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3E,#3F,#3F,#3F,#3F
        db #3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F
        db #3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F
        db #3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F
        db #3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F
        db #3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F,#3F
 
        ;;;;;;;; log2(x)*32 ;;;;;;;; 
log2_tab:  
        db #00,#00,#20,#32,#40,#4A,#52,#59,#60,#65,#6A,#6E,#72,#76,#79,#7D
        db #80,#82,#85,#87,#8A,#8C,#8E,#90,#92,#94,#96,#98,#99,#9B,#9D,#9E
        db #A0,#A1,#A2,#A4,#A5,#A6,#A7,#A9,#AA,#AB,#AC,#AD,#AE,#AF,#B0,#B1
        db #B2,#B3,#B4,#B5,#B6,#B7,#B8,#B9,#B9,#BA,#BB,#BC,#BD,#BD,#BE,#BF
        db #C0,#C0,#C1,#C2,#C2,#C3,#C4,#C4,#C5,#C6,#C6,#C7,#C7,#C8,#C9,#C9
        db #CA,#CA,#CB,#CC,#CC,#CD,#CD,#CE,#CE,#CF,#CF,#D0,#D0,#D1,#D1,#D2
        db #D2,#D3,#D3,#D4,#D4,#D5,#D5,#D5,#D6,#D6,#D7,#D7,#D8,#D8,#D9,#D9
        db #D9,#DA,#DA,#DB,#DB,#DB,#DC,#DC,#DD,#DD,#DD,#DE,#DE,#DE,#DF,#DF
        db #DF,#E0,#E0,#E1,#E1,#E1,#E2,#E2,#E2,#E3,#E3,#E3,#E4,#E4,#E4,#E5
        db #E5,#E5,#E6,#E6,#E6,#E7,#E7,#E7,#E7,#E8,#E8,#E8,#E9,#E9,#E9,#EA
        db #EA,#EA,#EA,#EB,#EB,#EB,#EC,#EC,#EC,#EC,#ED,#ED,#ED,#ED,#EE,#EE
        db #EE,#EE,#EF,#EF,#EF,#EF,#F0,#F0,#F0,#F1,#F1,#F1,#F1,#F1,#F2,#F2
        db #F2,#F2,#F3,#F3,#F3,#F3,#F4,#F4,#F4,#F4,#F5,#F5,#F5,#F5,#F5,#F6
        db #F6,#F6,#F6,#F7,#F7,#F7,#F7,#F7,#F8,#F8,#F8,#F8,#F9,#F9,#F9,#F9
        db #F9,#FA,#FA,#FA,#FA,#FA,#FB,#FB,#FB,#FB,#FB,#FC,#FC,#FC,#FC,#FC
        db #FD,#FD,#FD,#FD,#FD,#FD,#FE,#FE,#FE,#FE,#FE,#FF,#FF,#FF,#FF,#FF



;-----------------------------------------------
; RAM:
    org #c000   ; RAM goes to the 4th slot

RAM:
tileTypes:      ds virtual MAX_TILE_TYPES    ; we will copy the right tileTypes here before drawing the map, 
                                             ; to ensure they are 256 aligned
; n_tile_types:   ds virtual 1
SLOTBIOS:   ds virtual 1    ; we remember the slot in which the BIOS and the GAME are to switch back and forth
SLOTGAME:   ds virtual 1   

isComputer50HzOr60Hz:   ds virtual 1    ; 0 is 50Hz, and 1 is 60Hz

player_input_buffer:     ds virtual 3    ; current input, previous input, new keys pressed

race_state:         ds virtual 1    ; state of the current race (semaphore, racing, race ended, etc.)
race_state_timer:   ds virtual 1

engine_sfx_timer:                   ds virtual 1

; global options:
global_options:                 ds virtual 1    ; options are the different bits

; game progress:
game_progress_category:         ds virtual 1
game_progress_race_number:      ds virtual 1
game_progress_cash:             ds virtual 2
game_progress_points:           ds virtual 8    ; points for each of the 8 competitors in the current category (0th is the player)
game_progress_current_car:      ds virtual 2    ; pointer to the car struct defining the current car
game_progress_agent_mood:       ds virtual 1
game_progress_races_completed:  ds virtual 8    ; one byte per race, 0 if race has not been finished yet
game_progress_season_state:     ds virtual 1    ; 0 at the beginning of season, 1 throughout, 2 right after finishing a race, and 3 when season is over
game_progress_last_agent_tip:   ds virtual 1

game_progress_category_car_ptrs:    ds virtual 6    ; pointers to the available cars in this category
game_progress_category_drivers_ptr: ds virtual 2
game_progress_current_race_info:    ds virtual RACE_STRUCT_SIZE

game_progress_last_race_result: ds virtual 1    

track_tileset:          ds virtual 1
track_first_grass_tile_type:    ds virtual 1
track_first_collidable_tile_type:   ds virtual 1

; Music variables:
MUSIC_tempo:                        ds virtual 1
beginning_of_sound_variables_except_tempo:
MUSIC_play:                         ds virtual 1
MUSIC_tempo_counter:                ds virtual 1
MUSIC_instruments:                  ds virtual N_MUSIC_CHANNELS
MUSIC_channel3_instrument_buffer:   ds virtual 1    ;; this stores the instrument of channel 3, which is special, since SFX might overwrite it
MUSIC_start_pointer:                ds virtual 2  
SFX_pointer:                        ds virtual 2
MUSIC_pointer:                      ds virtual 2
MUSIC_repeat_stack_ptr:             ds virtual 2    
MUSIC_repeat_stack:                 ds virtual 4*3  
MUSIC_instrument_envelope_ptr:      ds virtual N_MUSIC_CHANNELS*2  
SFX_priority:                       ds virtual 1    ; the SFX from the game have more priority than those triggered by music
;MUSIC_transpose:                    ds virtual 1
MUSIC_time_step_required:           ds virtual 1    
end_of_sound_variables:
music_buffer:                       ds virtual 460  ; size of the longest song during the game (ending song is longer and overflows this buffer)

END_OF_COMMON_RAM:

;-----------------------------------------------
; RAM variables necessary while in game-play:
    org END_OF_COMMON_RAM

buffer:
car_sprite_patterns_buffer:     ds virtual 2048

tileTypesV_ptr: ds virtual 2
n_tile_types:   ds virtual 1
tileTypesH:
tileTypes_buffer:   ds virtual MAX_TILE_TYPES*8

; data structure where maps will be decompressed to:
map_decompression_buffer:
track_minimap:          ds virtual 6*6
minimap_x_offset:       ds virtual 1
minimap_y_offset:       ds virtual 1
car_start_positions:    ds virtual N_CARS*2
semaphores_in_map:       ds virtual 4*2  ; y,x coordinate of each of the semaphore sprites
track_rails:    ds virtual MAX_RAILS*3
track_waypoints:    ds virtual MAX_WAYPOINTS*4
map_width:      ds virtual 1
map_height:     ds virtual 1 
map_buffer:     ds virtual 6162   ; size of the largest map I currently have (St. Junipero)

map_n_sprites:    ds virtual 1
sprites_in_map:   ds virtual MAX_SPRITES_IN_MAP*3   ; y, x, sprite tile coordinate of each sprite
current_tile_extras_loaded: ds virtual 1
extra_tiles_to_load:    ds virtual 1


ROM2RAM_RAM:
scoreboard_message_render_buffer:   ds virtual 10   ; for the messages that appear in the scoreboard
scoreboard_message_buffer:          ds virtual 40   ; stores the full message
scoreboard_message_position:        ds virtual 1    
scoreboard_draw_buffer:     ds virtual 11*2
scoreboard_timer_buffer:    ds virtual 7  ; we represent the time directly as the tiles necessary to render it
scoreboard_position_buffer: ds virtual 2 
current_lap:                ds virtual N_CARS    ; (for each car) the is stored as the character '1', '2', '3' or '4'
sprite_attributes_buffer:   ds virtual 4*32

scoreboard_damage_buffer:   ds virtual 1    ; just a temporary byte to place the tile to draw in the damage slots

game_cycle:     ds virtual 1

scroll_x_tile:  ds virtual 1
scroll_y_tile:  ds virtual 1
scroll_x_pixel: ds virtual 1
scroll_y_pixel: ds virtual 1

last_scroll_car_map_x: ds virtual 2
last_scroll_car_map_y: ds virtual 2

scroll_being_pushed_x: ds virtual 1 ; these two variables are used to know if the car is currently pushing the scroll
scroll_being_pushed_y: ds virtual 1 ; if that's the case, then the lsb of the corrsponding sprite coordinate has to be reset
                                    ; so that the car does not vibrate while scrolling.

horizontal_scroll_limit: ds virtual 2   ; what is the maximum values that the scroll can reach before reaching the limit of the map
vertical_scroll_limit:   ds virtual 2
max_scroll_movement_this_frame:   ds virtual 2  ; each time we change rails, this resets to 1, and increments in 1 per frame, 
                                                ; until reaching the max allowed.

; these are used as caches when updating the game sprites
current_scroll_rails_ptr:   ds virtual 2
current_scroll_x_offset:    ds virtual 2
current_scroll_y_offset:    ds virtual 2

; car information (the player one is expanded, to have quick access to these variables):
player_car_struct:
player_car_ID:          ds virtual 1
player_car_angle:       ds virtual 1
player_car_speed:       ds virtual 1
player_car_map_x:       ds virtual 2        ; 4 bits of decimal part
player_car_map_y:       ds virtual 2        ; 4 bits of decimal part
player_car_gear:        ds virtual 1
player_car_gear_profile_state:  ds virtual 1    ; this is incremented by the gear profile value each time we accelerate
                                                ; when it crosses 64, we accelerate
player_car_invulnerability: ds virtual 1
player_car_tile_underneath:     ds virtual 1    ; we store the type (grass, road, etc.) of the last tile the car was over
player_car_next_waypoint:   ds virtual 1
player_car_acceleration:        ds virtual 1    ; these two variables control the rate at which this particular car accelerates (used to
player_car_acceleration_state:  ds virtual 1    ; set the difficulty level of each opponeng car, not used for the player car)
player_car_race_progress:       ds virtual 1
player_car_explosion_timer:     ds virtual 1    ; only used for the player car, the opponent cars store here the "out of track timer"
player_car_model_ptr:           ds virtual 2
player_car_shift_up_speed:      ds virtual 1    ; speed at which auto gears will shift up to high gear
opponent_car2_struct: ds virtual CAR_STRUCT_SIZE
opponent_car3_struct: ds virtual CAR_STRUCT_SIZE
opponent_car4_struct: ds virtual CAR_STRUCT_SIZE

player_car_engine_damage:   ds virtual 1
player_car_tyre_damage:    ds virtual 1
player_car_brake_damage:    ds virtual 1
player_car_chasis_damage:   ds virtual 1

car_previous_x: ds virtual 2
car_previous_y: ds virtual 2

car_race_order:             ds virtual N_CARS

; tracking of lap times:
current_lap_time:   ds virtual 2
fastest_lap_time:   ds virtual 2
;lap_times:          ds virtual 2*MAX_LAPS

    include "extratilesRAMspace.asm"

endOfGameRAM:


;-----------------------------------------------
; RAM variables necessary while in splash, title, and race finished screens:
    org END_OF_COMMON_RAM

title_buffer:   ds virtual 32*6+19*4    ; 268
title_buffer_flag:  ds virtual 16*23*32 ; 11776


;-----------------------------------------------
; RAM variables necessary while in the season / cars / races screens:
    org END_OF_COMMON_RAM

menu_buffer2:   ; for prerendering the screen, before copying it to the VDP
menu_buffer2a:   ; In an earlier version, the ending song was overflowing the music buffer, so this was a bit minimap_y_offset
                 ; now it's kept, just so I don't need to modify the ending code :)
menu_car_sprite_patterns_buffer:     ds virtual 2048  ; this is identical to "car_sprite_patterns_buffer"
menu_selected_option:   ds virtual 1
menu_cycle:     ds virtual 1
menu_play_sfx_on_update:   ds virtual 1
menu_races_n_races:     ds virtual 1
menu_races_race_ptrs:   ds virtual 2*4  ; 4 is the maximum number of races to choose from
menu_races_race_indexes:    ds virtual 4
menu_buffer:    ds virtual 2048
menu_agent_fast_text_skip: ds virtual 1
menu_agent_data_buffer: ds virtual 142


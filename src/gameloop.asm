;-----------------------------------------------
; sets everything up to start a race
; - hl: track to load
prepare_game_for_race_start:
    call SETGAMEPAGE0
    dec hl
    ld a,(hl)
    ld (track_tileset),a
    inc hl
    or a
    jr nz,prepare_game_for_race_start_urban_constants
    ld a,FIRST_GRASS_TILE_TYPE
    ld (track_first_grass_tile_type),a
    ld a,FIRST_COLLITABLE_TILE_TYPE
    ld (track_first_collidable_tile_type),a
    jr prepare_game_for_race_start_constants_set
prepare_game_for_race_start_urban_constants:
    ld a,FIRST_GRASS_TILE_TYPE_URBAN
    ld (track_first_grass_tile_type),a
    ld a,FIRST_COLLITABLE_TILE_TYPE_URBAN
    ld (track_first_collidable_tile_type),a
prepare_game_for_race_start_constants_set:
    push hl
    call RESTOREBIOS
    ei  ; since these functions disable interrupts    
    ; disable the VDP while setting things up:
    call disable_VDP_output
    call clearAllTheSprites
    call clearScreen

    ; set up all the car info before the track data is removed from memory
    ; reset the state of all the cars:
    ld (player_car_struct),a
    ld hl,player_car_struct
    ld de,player_car_struct+1
    ld bc,((CAR_STRUCT_SIZE*N_CARS)-1)+4  ; + 4 to also reset the damage variables
    ldir

    ; load the tile banks:
    call load_game_common_patterns_to_VDP
    ld a,(track_tileset)
    or a
    jr nz,prepare_game_for_race_start_urban_tileset
    ld hl,patterns_game_extra0_pletter
    ld de,patterns_game_extra0_decompressed
    call pletter_unpack
    ld hl,patterns_game_extra1_pletter
    ld de,patterns_game_extra1_decompressed
    call pletter_unpack
;    ld hl,patterns_game_extra2_pletter
;    ld de,patterns_game_extra2_decompressed
;    call pletter_unpack
    jr prepare_game_for_race_start_tileset_loaded
prepare_game_for_race_start_urban_tileset:
    ld hl,patterns_game_extra0_urban_pletter
    ld de,patterns_game_extra0_urban_decompressed
    call pletter_unpack
    ld hl,patterns_game_extra1_urban_pletter
    ld de,patterns_game_extra1_urban_decompressed
    call pletter_unpack
    ld hl,patterns_game_extra2_urban_pletter
    ld de,patterns_game_extra2_urban_decompressed
    call pletter_unpack
    ld hl,patterns_game_extra3_urban_pletter
    ld de,patterns_game_extra3_urban_decompressed
    call pletter_unpack
;    ld hl,patterns_game_extra4_urban_pletter
;    ld de,patterns_game_extra4_urban_decompressed
;    call pletter_unpack
prepare_game_for_race_start_tileset_loaded:

    ld hl,patterns_base_pletter
    call decompressPatternsToVDP3rdBank
    ld hl,patterns_patch_base_game_pletter
    call applyPatternPatch
    call decompressPatternsToVDP3rdBank_entry_point

    ; load track:
    call SETGAMEPAGE0
    pop hl  ; we recover the track to load
    ld de,map_decompression_buffer
    call pletter_unpack
    call RESTOREBIOS
    ei  ; since these functions disable interrupts
    call load_map

    ; draw scoreboard:
    ld hl,scoreboard_pletter
    ld de,buffer
    call pletter_unpack
    call draw_minimap
    ld hl,buffer
    ld de,NAMTBL2+256*2
    ld bc,256
    call fast_LDIRVM

    ; initialize the sprite data:
    ld hl,ROM2RAM_raceStart
    ld de,ROM2RAM_RAM
    call pletter_unpack

    ; set te car IDs
    ld a,1
    ld (player_car_struct+CAR_STRUCT_SIZE+CAR_STRUCT_CAR_ID),a
    inc a
    ld (player_car_struct+CAR_STRUCT_SIZE*2+CAR_STRUCT_CAR_ID),a
    inc a
    ld (player_car_struct+CAR_STRUCT_SIZE*3+CAR_STRUCT_CAR_ID),a

    ; set the car models:
    ; player car:
    ld ix,(game_progress_current_car)
    ld (player_car_struct+CAR_STRUCT_CAR_MODEL_PTR),ix
    ld a,(ix+6) ; speed at which to shift gears up
    ld (player_car_struct+CAR_STRUCT_SHIFT_UP_SPEED),a
    ld a,64
    ld (player_car_struct+CAR_STRUCT_ACCELERATION),a
    ld a,(ix+24)
    ld (sprite_attributes_buffer+(FIRST_CAR_SPRITE+1)*4+3),a    ; player car color

    ; opponent cars:
    ld iy,game_progress_current_race_info
    ld a,(iy+18)    ; car model
    ld de,CAR_DEFINITION_STRUCT_SIZE
    call Mul8
    ld bc,CAR_DEFINITION_ENIAK_100K
    add hl,bc
    push hl
    pop ix
    ld (player_car_struct+CAR_STRUCT_SIZE+CAR_STRUCT_CAR_MODEL_PTR),ix
    ld a,(ix+6)
    ld (player_car_struct+CAR_STRUCT_SIZE+CAR_STRUCT_SHIFT_UP_SPEED),a 
    ld a,(iy+21)    ; handycap
    ld (player_car_struct+CAR_STRUCT_SIZE+CAR_STRUCT_ACCELERATION),a

    ld a,(iy+19)    ; car model
    ld de,CAR_DEFINITION_STRUCT_SIZE
    call Mul8
    ld bc,CAR_DEFINITION_ENIAK_100K
    add hl,bc
    push hl
    pop ix
    ld (player_car_struct+CAR_STRUCT_SIZE*2+CAR_STRUCT_CAR_MODEL_PTR),ix
    ld a,(ix+6)
    ld (player_car_struct+CAR_STRUCT_SIZE*2+CAR_STRUCT_SHIFT_UP_SPEED),a 
    ld a,(iy+22)    ; handycap
    ld (player_car_struct+CAR_STRUCT_SIZE*2+CAR_STRUCT_ACCELERATION),a

    ld a,(iy+20)    ; car model
    ld de,CAR_DEFINITION_STRUCT_SIZE
    call Mul8
    ld bc,CAR_DEFINITION_ENIAK_100K
    add hl,bc
    push hl
    pop ix
    ld (player_car_struct+CAR_STRUCT_SIZE*3+CAR_STRUCT_CAR_MODEL_PTR),ix
    ld a,(ix+6)
    ld (player_car_struct+CAR_STRUCT_SIZE*3+CAR_STRUCT_SHIFT_UP_SPEED),a 
    ld a,(iy+23)    ; handycap
    ld (player_car_struct+CAR_STRUCT_SIZE*3+CAR_STRUCT_ACCELERATION),a    

    ; upload car sprites
    ld hl,base_sprites_pletter
    ld de,buffer
    call pletter_unpack_from_page0
    ld hl,buffer
    ld de,SPRTBL2+32+32*8
    ld bc,32*(1+1+3+2+4)
    call fast_LDIRVM    

    call load_category_car_sprites

    xor a
    ld (race_state),a   ; RACE_STATE_SEMAPHORE_OFF
    ld (race_state_timer),a

    ld hl,track_rails
    ld (current_scroll_rails_ptr),hl
    ld (scroll_y_tile),a
    ld (scroll_x_tile),a
    ld (scroll_x_pixel),a
    ld (scroll_y_pixel),a
    ld (player_input_buffer),a
    ld (player_input_buffer+1),a
    ld (player_input_buffer+2),a
    ld (scroll_being_pushed_x),a
    ld (scroll_being_pushed_y),a
    ld bc,MIN_SCROLL_MOVEMENT_PER_FRAME+MAX_SCROLL_MOVEMENT_PER_FRAME_IN_REVERSE
    ld (max_scroll_movement_this_frame),bc

    ; reset the lap times:
    ld hl,0
    ld (current_lap_time),hl
    ;ld hl,current_lap_time
    ;ld de,current_lap_time+1
    ;ld bc,(MAX_LAPS+2)*2-1
    ;ldir
    ; set the current fastest lap to a very high time:
    ld hl,24+59*25+9*60*25  ; 9:59:98
    ld (fastest_lap_time),hl

    ld a,#ff
    ld (current_tile_extras_loaded),a
    ld (extra_tiles_to_load),a

    ld iy,car_start_positions
    call init_car_starting_positions_and_scroll

    ld de,track_rails
    call markWhichExtraTilesToLoad
    call checkForExtraTilesToLoad

    halt    ; we halt,since the routine below copies data to the VDP quite fast, so, just to be sure,
            ; we do it during vblank...
    call setupScoreBoardSprites

    ld a,COLOR_BLACK*16+COLOR_BLACK
    call change_semaphore_color

    ; get the music ready to play:
    call StopPlayingMusic
    ld hl,title_ingame1_song_pletter
    ld de,music_buffer
    call pletter_unpack_from_page0

    ; render the map:
    call updateScroll    
    call calculateScrollOffsets
    call prepareTileTypes_for_drawMap
    call drawMap
    call updateScoreboardDamage

    ; now that everything is set up, we reenable VDP output
    jp enable_VDP_output


;-----------------------------------------------
; main game loop during a race
start_race:
    call prepare_game_for_race_start

    ; ensure the player sprite flashes at game start to identify our car
    ld hl,player_car_invulnerability
    ld (hl),32

game_loop:
    ; SUBFRAME 1:
    halt
;    out (#2c),a
    call uploadCarSpriteAttributesInverted ; this uploads just the car sprites, but in reverse order (for flickering)
    call uploadCarSpritePatterns

    ; only when we are racing, do cars update
    call checkInput
    call update_race_state
    ld a,(race_state)
    cp RACE_STATE_RACING
    jp nz,game_loop_cars_not_updating
    ld a,(global_options)
    bit OPTIONS_BIT_GEARS,a
    jr nz,game_loop_manual_gears
    call updatePlayerCar_autoGears
    jr game_loop_gears_done
game_loop_manual_gears:
    call updatePlayerCar_manualGears
game_loop_gears_done:
    call updateAICars
    call scoreboard_update_time
game_loop_cars_not_updating:
    call updateScroll
    call calculateScrollOffsets
    call updateCarSprites
    call drawSemaphoreSprites
    call drawMapSprites
;    out (#2d),a 

    ; SUBFRAME 2:
    halt
;    out (#2c),a
    call uploadSpriteAttributes
    call prepareTileTypes_for_drawMap
    call drawMap
    call scoreboard_update_message
    call scoreboard_update_speed_gear
    call scoreboard_update_position
    call updateMinimapSrites
;    out (#2d),a 
;    out (#2c),a
    call checkForExtraTilesToLoad
;    out (#2d),a 

    ld hl,game_cycle
    inc (hl)

    jr game_loop


race_over:
explosion_over:
    pop af  ; simulate a "ret"
    ld hl,race_state
    ld (hl),RACE_STATE_RACE_OVER
    ; mark the player as being last:
    xor a
    ld (player_car_race_progress),a
    jp race_finished_screen


update_race_state:
    ld a,(race_state)
    or a
    jp z,update_race_state_semaphore_off
    dec a
    jp z,update_race_state_semaphore_red
    dec a
    ret z   ; state racing
    ; dec a
    ; jp z,update_race_state_race_over
update_race_state_race_over:
    ld hl,race_state_timer
    ld a,(hl)
    inc (hl)
    cp 32   ; pause at the end of the race
    ret nz
    jp race_over
update_race_state_semaphore_off:
    ld hl,player_car_invulnerability
    ld a,(hl)
    or a
    jr z,update_race_state_semaphore_off_flashing_over
    dec (hl)
update_race_state_semaphore_off_flashing_over:
    ld hl,race_state_timer
    ld a,(hl)
    inc (hl)
    cp 64
    ret nz
    ld (hl),0
    ld hl,race_state
    inc (hl)
    call update_race_state_semaphore1_sfx
    ; turn semaphore red:
    ld a,COLOR_RED*16+COLOR_RED
    jp change_semaphore_color

update_race_state_semaphore1_sfx:
    ld a,COLOR_YELLOW*16+COLOR_YELLOW
    call change_semaphore_color
    ld hl,SFX_semaphore1
    jp play_ingame_SFX

update_race_state_semaphore_red:
    ld hl,race_state_timer
    ld a,(hl)
    inc (hl)
    cp 32
    jp z,update_race_state_semaphore1_sfx
    cp 64
    ret nz
    ld (hl),0
    ld hl,race_state
    inc (hl)
    ; start music:
    ld a,(global_options)
    bit OPTIONS_BIT_MUSIC,a
    jr nz,update_race_state_semaphore_red_no_music
    ld a,(isComputer50HzOr60Hz)
    add a,6 ; so, a = 6 when 50Hz and a = 7 when 60Hz
    call play_song
update_race_state_semaphore_red_no_music:
    ; SFX:
    ld hl,SFX_semaphore2
    call play_ingame_SFX
    ; turn semaphore green:
    ld a,COLOR_LIGHT_GREEN*16+COLOR_LIGHT_GREEN
    jp change_semaphore_color


;-----------------------------------------------
; initializes the car positions for the current track, and resets the scroll
init_car_starting_positions_and_scroll:
    ld a,N_CARS-1
    ld hl,car_race_order
init_car_starting_positions_and_scroll_race_order_loop:
    ld (hl),a
    or a
    jr z,init_car_starting_positions_and_scroll_after_race_order
    inc hl
    dec a
    jr init_car_starting_positions_and_scroll_race_order_loop
init_car_starting_positions_and_scroll_after_race_order:

    ld ix,player_car_struct
    ld b,4
init_car_starting_positions_and_scroll_loop:
    push bc
    ld l,0
    ld h,(iy)   ; x coordinate of first car
    srl h
    rr l        ; hl is now (start_pos)*8*COORDINATE_PRECISION
    ld (ix+CAR_STRUCT_MAP_X),l
    ld (ix+CAR_STRUCT_MAP_X+1),h
    ld l,0
    ld h,(iy+1)   ; x coordinate of first car
    srl h
    rr l        ; hl is now (start_pos)*8*COORDINATE_PRECISION
    ld (ix+CAR_STRUCT_MAP_Y),l
    ld (ix+CAR_STRUCT_MAP_Y+1),h

    ld (ix+CAR_STRUCT_GEAR),1
    ld (ix+CAR_STRUCT_ANGLE),16

    ld bc,CAR_STRUCT_SIZE
    add ix,bc
    inc iy
    inc iy
    pop bc
    djnz init_car_starting_positions_and_scroll_loop

    ld bc,-15*4
    call desired_scroll_position_x
    ld bc,0
    call hl_not_smaller_than_bc
    ld (last_scroll_car_map_x),hl
    ld bc,0
    call hl_not_smaller_than_bc
    ld bc,-11*4
    call desired_scroll_position_y
    ld (last_scroll_car_map_y),hl
    ld (vertical_scroll_limit),hl
    ret

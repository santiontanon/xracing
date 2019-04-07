;-----------------------------------------------
; Creates four sprites to place just on top of the scoreboard to protect it from sprites going inside
setupScoreBoardSprites:
    ld hl,SPRTBL2+FIRST_SCOREBOARD_SPRITE*4
    ld a,#ff
    ld bc,32
    call FILVRM

    ld hl,sprite_attributes_buffer
    ld de,SPRATR2   ; we skip the 4 initial sprites, only used to protect the scoreboard
    ld bc,4*4 ; for all 4 protective sprites
    jp fast_LDIRVM


;-----------------------------------------------
; draws the speed to the scoreboard
scoreboard_update_speed_gear: 
    ld h,0
    ld a,(player_car_speed)
    or a
    jp p,scoreboard_update_speed_gear_positive_velocity
    neg
scoreboard_update_speed_gear_positive_velocity:
    add a,a

    ld l,a
    ld d,10
    call Div8

    push hl
    ld de,scoreboard_draw_buffer+4
    call scoreboard_draw_large_digit_to_buffer
    pop hl

    ld d,10
    call Div8

    push hl
    ld de,scoreboard_draw_buffer+2
    call scoreboard_draw_large_digit_to_buffer
    pop hl

    ld d,10
    call Div8

    ld de,scoreboard_draw_buffer+0
    call scoreboard_draw_large_digit_to_buffer

    ld a,(player_car_gear)
    add a,a
    add a,a ; we multiply by by 4
    ld c,a
    ld b,0
    ld hl,gear_patterns
    ld de,scoreboard_draw_buffer+9
    call scoreboard_draw_large_digit_to_buffer_entry_point


    ld de,NAMTBL2+256*2+4*32+1
    ;call SETWRT
    ld hl,scoreboard_draw_buffer
    ld bc,11
    call fast_LDIRVM
    ld de,NAMTBL2+256*2+5*32+1
    ;call SETWRT
    ld hl,scoreboard_draw_buffer+11
    ld bc,11
    jp fast_LDIRVM



; a: digit to draw
; de: points to the buffer position
scoreboard_draw_large_digit_to_buffer:     
    add a,a
    add a,a ; we multiply by by 4
    ld c,a
    ld b,0
    ld hl,large_digit_patterns
scoreboard_draw_large_digit_to_buffer_entry_point:
    add hl,bc
    ldi
    ldi
    ld bc,11-2  ; 11 is the width of the scoreboard draw buffer
    ex de,hl
    add hl,bc
    ex de,hl
    ldi
    ldi
    ret


;-----------------------------------------------
; draws the race time in the scoreboard
scoreboard_update_time: 
    ld hl,(current_lap_time)
    inc hl
    ld (current_lap_time),hl

    ; increment the timer
    ld hl,scoreboard_timer_buffer+6
    ld a,(hl)
    add a,4
    ld (hl),a   ; hundreths of a second
    cp 48+10
    jp m,scoreboard_update_time_render
    sub 10
    ld (hl),a
    dec hl
    inc (hl)
    ld a,(hl)   ; tenths of a second
    cp 48+10
    jp nz,scoreboard_update_time_render
    ld (hl),48
    dec hl
    dec hl
    inc (hl)
    ld a,(hl)   ; seconds
    cp 48+10
    jp nz,scoreboard_update_time_render
    ld (hl),48
    dec hl
    inc (hl)   
    ld a,(hl)   ; 10 seconds
    cp 48+6
    jp nz,scoreboard_update_time_render
    ld (hl),48
    dec hl
    dec hl
    inc (hl)   
    ld a,(hl)   ; minutes
    cp 48+10
    jp nz,scoreboard_update_time_render
    ld (hl),48

scoreboard_update_time_render:
    ; render the timer
    ld de,NAMTBL2+256*2+7*32+6
    ;call SETWRT
    ld hl,scoreboard_timer_buffer
    ld bc,7
    jp fast_LDIRVM


;-----------------------------------------------
; increases by one the lap count in the scoreboard
scoreboard_increase_lap_count:
    ld hl,SFX_lap
    call play_ingame_SFX

    ; save current lap time:
;    ld hl,lap_times
;    ld a,(current_lap)
;    sub '1'
;    ld b,0
;    ld c,a
;    add hl,bc
;    add hl,bc
    ld bc,(current_lap_time)
;    ld (hl),c
;    inc hl
;    ld (hl),b
    ; check if it's the fastest lap:
    ld hl,(fastest_lap_time)
    or a
    sbc hl,bc
    jp m,scoreboard_increase_lap_count_not_fastest_lap
    ld (fastest_lap_time),bc    ; update the fastest lap time
    ld hl,message_fastest_lap
    call scoreboard_trigger_message
scoreboard_increase_lap_count_not_fastest_lap:
    ; reset the lap time for the next lap
    ld hl,0
    ld (current_lap_time),hl    
    ; update scoreboard:
    ld hl,current_lap
    inc (hl)
    ld a,(hl)
    cp 48+MAX_LAPS
    call z,scoreboard_increase_lap_count_final_lap
    cp 48+(MAX_LAPS+1)
    jp z,max_laps_reached
    ld bc,1
    ld de,NAMTBL2+256*2+7*32+28
    jp fast_LDIRVM
max_laps_reached:
    ld hl,race_state
    ld (hl),RACE_STATE_RACE_OVER
    call StopPlayingMusic
    ld hl,SFX_semaphore2
    jp play_ingame_SFX

scoreboard_increase_lap_count_final_lap:
    push af
    push hl
    ld hl,message_final_lap
    call scoreboard_trigger_message
    pop hl
    pop af
    ret


;-----------------------------------------------
; updates the position of the player in the race in the scoreboard
scoreboard_update_position:
    ld de,NAMTBL2+256*2+7*32+19
    ld hl,car_race_order
    ld a,(hl)
    ld hl,scoreboard_position_buffer
scoreboard_update_position_entry_point:
    or a
    jp z,scoreboard_update_position_1st
    dec a
    jp z,scoreboard_update_position_2nd
    dec a
    jp z,scoreboard_update_position_3rd
scoreboard_update_position_4th:
    add a,'3'   ; if a was 3, here it's 1, which corresponds to "4th"
    ld (hl),a  
    inc hl
    ld (hl),22 ; "th"
    jp scoreboard_update_position_copy
scoreboard_update_position_3rd:
    ld (hl),'3'
    inc hl
    ld (hl),60 ; "rd"
    jp scoreboard_update_position_copy
scoreboard_update_position_2nd:
    ld (hl),'2'
    inc hl
    ld (hl),42 ; "nd"
    jp scoreboard_update_position_copy
scoreboard_update_position_1st:
    ld (hl),'1'
    inc hl
    ld (hl),34 ; "st"
    jp scoreboard_update_position_copy
scoreboard_update_position_copy: 
    dec hl
    ld bc,2
    jp fast_LDIRVM


;-----------------------------------------------
; draws the minimap to the scoreboard
; - hl: minimap pointer
draw_minimap:
    ld hl,track_minimap
    ld de,buffer+32+24
    ld bc,6
    ldir
    ld de,buffer+32*2+24
    ld bc,6
    ldir
    ld de,buffer+32*3+24
    ld bc,6
    ldir
    ld de,buffer+32*4+24
    ld bc,6
    ldir
    ld de,buffer+32*5+24
    ld bc,6
    ldir
    ld de,buffer+32*6+24
    ld bc,6
    ldir
    ret


;-----------------------------------------------
; calculates the position of the sprites that mark the cars in the minimap and
; uploads them to the VDP
updateMinimapSrites:
    ld ix,player_car_struct
    ld hl,sprite_attributes_buffer
    ld b,4
    ld de,CAR_STRUCT_SIZE
updateMinimapSrites_loop:
    ld a,(minimap_y_offset)
    add a,(ix+CAR_STRUCT_MAP_Y+1)
    add a,17*8-1
    ld (hl),a
    inc hl
    ld a,(minimap_x_offset)
    add a,(ix+CAR_STRUCT_MAP_X+1)
    add a,24*8
    ld (hl),a
    inc hl
    inc hl
    inc hl
    add ix,de
    djnz updateMinimapSrites_loop

    ld de,SPRATR2
    ;call SETWRT
    ld hl,sprite_attributes_buffer
    ld bc,4*4
    jp fast_LDIRVM


;-----------------------------------------------
; updates the damage indicators in the scoreboard
; - damage under 8 is green, between 8 and 12 is yellow, and 12 and over is red
updateScoreboardDamage:
    ld a,91 ; green 'E'
    ld hl,scoreboard_damage_buffer
    ld (hl),a
    ld de,NAMTBL2+256*2+2*32+20
    ld a,(player_car_engine_damage)
    call updateScoreboardDamage_one_element

    ld a,94 ; green 'T'
    ld hl,scoreboard_damage_buffer
    ld (hl),a
    ld de,NAMTBL2+256*2+3*32+20
    ld a,(player_car_tyre_damage)
    call updateScoreboardDamage_one_element

    ld a,97 ; green 'B'
    ld hl,scoreboard_damage_buffer
    ld (hl),a
    ld de,NAMTBL2+256*2+4*32+20
    ld a,(player_car_brake_damage)
    call updateScoreboardDamage_one_element

    ld a,100 ; green 'C'
    ld hl,scoreboard_damage_buffer
    ld (hl),a
    ld a,(player_car_chasis_damage)
    ld de,NAMTBL2+256*2+5*32+20
;    call updateScoreboardDamage_one_element

updateScoreboardDamage_one_element:
    cp 8
    jp m,updateScoreboardDamage_green
    cp 12
    jp m,updateScoreboardDamage_yellow
updateScoreboardDamage_red:
    inc (hl)
updateScoreboardDamage_yellow:
    inc (hl)
updateScoreboardDamage_green:
    push hl
    ;ex de,hl
    ;call SETWRT
    pop hl
    ld bc,1
    jp fast_LDIRVM


;-----------------------------------------------
; checks if we have a message to display in the scoreboard, and displays it!
scoreboard_update_message:
    ld a,(game_cycle)
    and #03
    ret nz

    ld hl,scoreboard_message_buffer
    ld a,(hl)
    or a
    ret z   ; there is no message to display!

    ; move the message buffer to the left, and add the current letter at the end
    ld de,scoreboard_message_render_buffer
    ld hl,scoreboard_message_render_buffer+1
    ld bc,9
    ldir
    ld hl,scoreboard_message_position
    ld a,(hl)
    inc (hl)
    cp MAX_MESSAGE_SIZE
    jp p,scoreboard_update_message_end_of_message
    ld hl,scoreboard_message_buffer
    ADD_HL_A_VIA_BC
    ld a,(hl)
    ld (scoreboard_message_render_buffer+9),a
    jp scoreboard_update_message_render_buffer_ready
scoreboard_update_message_end_of_message:
    xor a
    ld (scoreboard_message_render_buffer+9),a
scoreboard_update_message_render_buffer_ready:

    ; render to the screen:
    ld de,NAMTBL2+256*2+0*32+2
    ;call SETWRT
    ld hl,scoreboard_message_render_buffer
    ld bc,MESSAGE_WINDOW_SIZE
    call fast_LDIRVM

    ; update "scoreboard_message_position", and if we have finished, mark that there are no more messages
    ld hl,scoreboard_message_position
    ld a,(hl)
    cp MAX_MESSAGE_SIZE+MESSAGE_WINDOW_SIZE
    ret nz
    xor a    
    ld (scoreboard_message_buffer),a    ; mark that we are done with this message
    ret


;-----------------------------------------------
; starts displaying a message through the scoreboard
; input:
; - HL: message
scoreboard_trigger_message:
    ld de,scoreboard_message_buffer
    ld bc,MAX_MESSAGE_SIZE
    ldir
    ; clear the current message:
    xor a
    ld (scoreboard_message_position),a
    ld (scoreboard_message_render_buffer),a
    ld hl,scoreboard_message_render_buffer
    ld de,scoreboard_message_render_buffer+1
    ld bc,MESSAGE_WINDOW_SIZE-1
    ldir
    ret

;-----------------------------------------------
; ensures the scroll onl follows the "rails" set for the current track
updateScroll:
    ld hl,(max_scroll_movement_this_frame)
    inc hl
    ld bc,MAX_SCROLL_MOVEMENT_PER_FRAME
    call hl_not_larger_than_bc
    ld (max_scroll_movement_this_frame),hl

    xor a
    ld (scroll_being_pushed_x),a
    ld (scroll_being_pushed_y),a 

    ld de,(current_scroll_rails_ptr)
    ld a,(de)   ; get the type of rail section we are on
    or a    ; SCROLL_RAIL_RIGHT
    jp z,updateScroll_right
    dec a   ; SCROLL_RAIL_LEFT
    jp z,updateScroll_left
    dec a   ; SCROLL_RAIL_DOWN
    jp z,updateScroll_down
    dec a   ; SCROLL_RAIL_UP
    jr z,updateScroll_up
;    dec a   ; SCROLL_RAIL_LOOP
;    jp z,updateScroll_reset

updateScroll_reset:
    ld hl,track_rails
    ld (current_scroll_rails_ptr),hl
    jr updateScroll ; we have to call it again, since we did not do a scroll update this cycle

updateScroll_up:
    ld hl,(last_scroll_car_map_y)
    inc hl
    inc hl
    push hl     ; save last +2
    ld bc,(max_scroll_movement_this_frame)
    xor a
    sbc hl,bc
    push hl     ; save last - max_scroll_movement_this_frame

    ld bc,-SCROLL_UP_CAR_Y*4
    call desired_scroll_position_y

    pop bc
    call hl_not_smaller_than_bc

    jp z,updateScroll_up_scroll_not_pushed
    ld a,1
    ld (scroll_being_pushed_y),a
updateScroll_up_scroll_not_pushed:

    pop bc
    call hl_not_larger_than_bc
    ld bc,(vertical_scroll_limit)
    call hl_not_larger_than_bc
    ld (last_scroll_car_map_y),hl   ; we store this position, for the next frame

    ld a,l
    and #03
    ld (scroll_y_pixel),a   ; we set the pixel coordinates

    srl h   ; obtain the tile scroll
    rr l    
    srl h
    rr l   
    ld a,l
    ld (scroll_y_tile),a
    inc de
    ld a,(de)
    dec a   ; we decrease "a", to prevent snapping to the next rail too early
    cp l
    ret m   ; we haven't made it yet
    ; mark the next scroll limits:
    call store_scroll_limits
    inc a

    ; The following block of code is only needed for the "up" direction, since that's where the starting block is, 
    ; which is the only time where we will have two rails with the same direction in a row
    ld b,a
    inc de
    inc de  ; skip the extra tiles to load:
    ld (current_scroll_rails_ptr),de    ; we advance the rail position
    ld a,(de)
    cp SCROLL_RAIL_LOOP
    ret z  ; if we don't change the scroll type, no need to reset the scroll speed, etc.

    ld a,b  ; we recover the limit, just in case we overshot
    ld (scroll_y_tile),a    ; we overwrite, just in case we overshot
    xor a
    ld (scroll_y_pixel),a   ; reset pixel position
    jp updateScroll_down_scroll_not_pushed_entry_point
    ;ld bc,MIN_SCROLL_MOVEMENT_PER_FRAME+MAX_SCROLL_MOVEMENT_PER_FRAME_IN_REVERSE
    ;ld (max_scroll_movement_this_frame),bc
    ;jp markWhichExtraTilesToLoad


updateScroll_right:
    ld hl,(last_scroll_car_map_x)
    dec hl
    dec hl
    push hl     ; save last - 2
    ld bc,(max_scroll_movement_this_frame)
    add hl,bc
    push hl     ; save last + (max_scroll_movement_this_frame)

    ld bc,-SCROLL_RIGHT_CAR_X*4
    call desired_scroll_position_x

    pop bc
    call hl_not_larger_than_bc
    pop bc
    call hl_not_smaller_than_bc
    ld bc,0
    call hl_not_smaller_than_bc
    ld (last_scroll_car_map_x),hl   ; we store this position, for the next frame

    jp z,updateScroll_right_scroll_not_pushed
    ld a,1
    ld (scroll_being_pushed_x),a
updateScroll_right_scroll_not_pushed:

    ld bc,(horizontal_scroll_limit)
    call hl_not_smaller_than_bc

    ld a,l
    and #03
    ld (scroll_x_pixel),a   ; we set the pixel coordinates

    srl h   ; obtain the tile scroll
    rr l    
    srl h
    rr l   
    ld a,l
    ld (scroll_x_tile),a
    inc de
    ld a,(de)
    inc l
    cp l
    ret p   ; we haven't made it yet
    call store_scroll_limits
    ld (scroll_x_tile),a    ; we overwrite, just in case we overshot
    xor a
updateScroll_right_scroll_not_pushed_entry_point:
    ld (scroll_x_pixel),a   ; reset pixel position
    inc de
    inc de ; read the extra tiles to load:
    ld (current_scroll_rails_ptr),de    ; we advance the rail position
    ld bc,MIN_SCROLL_MOVEMENT_PER_FRAME+MAX_SCROLL_MOVEMENT_PER_FRAME_IN_REVERSE
    ld (max_scroll_movement_this_frame),bc
    jp markWhichExtraTilesToLoad

updateScroll_left:
    ld hl,(last_scroll_car_map_x)
    inc hl
    inc hl
    push hl     ; save last +2
    ld bc,(max_scroll_movement_this_frame)
    xor a
    sbc hl,bc
    push hl     ; save last - (max_scroll_movement_this_frame)

    ld bc,-SCROLL_LEFT_CAR_X*4
    call desired_scroll_position_x

    pop bc
    call hl_not_smaller_than_bc

    jp z,updateScroll_left_scroll_not_pushed
    ld a,1
    ld (scroll_being_pushed_x),a
updateScroll_left_scroll_not_pushed:

    pop bc
    call hl_not_larger_than_bc
    ld bc,(horizontal_scroll_limit)
    call hl_not_larger_than_bc
    ld (last_scroll_car_map_x),hl   ; we store this position, for the next frame

    ld a,l
    and #03
    ld (scroll_x_pixel),a   ; we set the pixel coordinates

    srl h   ; obtain the tile scroll
    rr l    
    srl h
    rr l   
    ld a,l
    ld (scroll_x_tile),a
    inc de
    ld a,(de)
    dec a   ; we decrease "a", to prevent snapping to the next rail too early
    cp l
    ret m   ; we haven't made it yet
    call store_scroll_limits
    inc a
    ld (scroll_x_tile),a    ; we overwrite, just in case we overshot
    xor a
    jr updateScroll_right_scroll_not_pushed_entry_point
;    ld (scroll_x_pixel),a   ; reset pixel position
;    inc de
;    inc de ; read the extra tiles to load:
;    ld (current_scroll_rails_ptr),de    ; we advance the rail position
;    ld bc,MIN_SCROLL_MOVEMENT_PER_FRAME+MAX_SCROLL_MOVEMENT_PER_FRAME_IN_REVERSE
;    ld (max_scroll_movement_this_frame),bc
;    jp markWhichExtraTilesToLoad

updateScroll_down:
    ld hl,(last_scroll_car_map_y)
    dec hl
    dec hl
    push hl     ; save last -2
    ld bc,(max_scroll_movement_this_frame)
    add hl,bc
    push hl     ; save last + (max_scroll_movement_this_frame)

    ld bc,-SCROLL_DOWN_CAR_Y*4
    call desired_scroll_position_y

    pop bc
    call hl_not_larger_than_bc
    pop bc
    call hl_not_smaller_than_bc
    ld bc,0
    call hl_not_smaller_than_bc
    ld (last_scroll_car_map_y),hl   ; we store this position, for the next frame

    jp z,updateScroll_down_scroll_not_pushed
    ld a,1
    ld (scroll_being_pushed_y),a
updateScroll_down_scroll_not_pushed:

    ld bc,(vertical_scroll_limit)
    call hl_not_smaller_than_bc

    ld a,l
    and #03
    ld (scroll_y_pixel),a   ; we set the pixel coordinates

    srl h   ; obtain the tile scroll
    rr l    
    srl h
    rr l   
    ld a,l
    ld (scroll_y_tile),a
    inc de
    ld a,(de)
    inc l
    cp l
    ret p   ; we haven't made it yet
    call store_scroll_limits
    ld (scroll_y_tile),a    ; we overwrite, just in case we overshot
    xor a
    ld (scroll_y_pixel),a   ; reset pixel position
    inc de
    inc de ; read the extra tiles to load
    ld (current_scroll_rails_ptr),de    ; we advance the rail position
updateScroll_down_scroll_not_pushed_entry_point:
    ld bc,MIN_SCROLL_MOVEMENT_PER_FRAME+MAX_SCROLL_MOVEMENT_PER_FRAME_IN_REVERSE
    ld (max_scroll_movement_this_frame),bc
;    jp markWhichExtraTilesToLoad


;-----------------------------------------------
; Checks to see if we need to load additional tiles for the current rail
; assumes "de" points to the current rail
markWhichExtraTilesToLoad:
    ld hl,current_tile_extras_loaded
    inc de
    inc de
    ld a,(de)   ; get the set of tiles we need to load
    cp (hl)     ; compare with the one currently loaded
    ret z       ; if it's the same, we are done...
    ld (extra_tiles_to_load),a
    ret


;-----------------------------------------------
; stores the current scroll position as the scroll limits for the next rail
store_scroll_limits:
    ld hl,(last_scroll_car_map_y)
    ld (vertical_scroll_limit),hl
    ld hl,(last_scroll_car_map_x)
    ld (horizontal_scroll_limit),hl
    ret

;-----------------------------------------------
; Does the actual tile loading (this will be called right before rendering the current frame)
checkForExtraTilesToLoad:
    ld hl,extra_tiles_to_load
    ld a,(hl)
    cp #ff
    ret z
    ld (current_tile_extras_loaded),a
    ld (hl),#ff ; mark that we don't need to load anything on the next frame
    or a
    jp z,load_game_extras0_patterns_to_VDP
    dec a
    jp z,load_game_extras1_patterns_to_VDP
    dec a
    jp z,load_game_extras2_patterns_to_VDP
;    dec a
;    jp z,load_game_extras3_patterns_to_VDP
    jp load_game_extras3_patterns_to_VDP


;-----------------------------------------------
; calculate the desired left and up position of the scroll, based on the player car coordinates
; input:
; - bc: amount to subtract from the x,y position to obtain the left,top position of scroll
;       this is used to center the scroll differently if you are going left/right/up/down
; output:
; - hl: target scroll position (lower 2 bits are pixel scroll, and rest are tile scroll)
desired_scroll_position_x:
    ld hl,(player_car_map_x)
desired_scroll_position_x_entry_point:
    srl h
    rr l    
    srl h
    rr l    
    srl h
    rr l    
    srl h
    rr l    ; we divide hl by COORDINATE_PRECISION (assume it's 16)

    srl h
    rr l    ; scroll precision is 2 pixels, so we divide by 2 one more time

    add hl,bc   ; center the scroll
    ret

desired_scroll_position_y:
    ld hl,(player_car_map_y)
    jr desired_scroll_position_x_entry_point

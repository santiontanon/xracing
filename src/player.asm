;-----------------------------------------------
; updates the player car based on keyboard/joystick input
updatePlayerCar_manualGears:
	ld ix,player_car_struct
	call update_car_race_position

	; if the car is exploding, do not let the player control the car:
	ld a,(player_car_explosion_timer)
	or a
	jp nz,updatePlayerCar_explosion

	ld a,(player_input_buffer)	; current keys pressed
	bit INPUT_LEFT_BIT,a
	call nz,update_car_rotate_left
	bit INPUT_RIGHT_BIT,a
	call nz,update_car_rotate_right
	bit INPUT_TRIGGER2_BIT,a
	push af
	call nz,updateCarPhysics_brake
	pop af
	bit INPUT_TRIGGER1_BIT,a
	call nz,updateCarPhysics_accelerate
	ld a,(player_input_buffer+2)	; new keys pressed
	bit INPUT_UP_BIT,a
	call nz,update_car_gear_up
	bit INPUT_DOWN_BIT,a
	call nz,update_car_gear_down
	jp updatePlayerCar_common


updatePlayerCar_autoGears:
	ld ix,player_car_struct
	call update_car_race_position

	; if the car is exploding, do not let the player control the car:
	ld a,(player_car_explosion_timer)
	or a
	jp nz,updatePlayerCar_explosion

	ld a,(player_input_buffer)	; current keys pressed
	bit INPUT_LEFT_BIT,a
	call nz,update_car_rotate_left
	bit INPUT_RIGHT_BIT,a
	call nz,update_car_rotate_right
	bit INPUT_TRIGGER2_BIT,a
	push af
	call nz,updateCarPhysics_brake_auto_gear
	pop af
	bit INPUT_TRIGGER1_BIT,a
	push af
	call nz,updateCarPhysics_accelerate_auto_gear
	pop af
	bit INPUT_UP_BIT,a
	push af
	call nz,updateCarPhysics_accelerate_auto_gear
	pop af
	bit INPUT_DOWN_BIT,a
	call nz,updateCarPhysics_brake_auto_gear
;	jp updatePlayerCar_common


updatePlayerCar_common:
	ld a,(player_input_buffer+2)	; new keys pressed
	bit INPUT_RESPAWN_BIT,a
	push af
	call nz,updatePlayerCar_respawn
	pop af
	bit INPUT_PAUSE_BIT,a
	call nz,updatePlayerCar_pause
	call updateCarPhysics
	; check if car is outside the viewport:
	call check_if_player_car_is_outside_viewport
	ret nz
updateCarPhysics_car_reset_for_collision:
	; collision, reset position, and zero speed:
	push ix
	pop de
	inc de
	inc de
	inc de
	ld hl,car_previous_x
	ldi
	ldi
	ldi
	ldi
	xor a
	ld (ix+CAR_STRUCT_SPEED),a
	ret	


updatePlayerCar_pause:
	; stop sound
	di
	call clear_PSG_volume
	ld hl,MUSIC_play
	ld a,(hl)
	push af
	xor a
	ld (hl),a
	ld a,RACE_STATE_RACE_PAUSED
	ld (race_state),a
	ei
	ld hl,SFX_menu_select
	call play_SFX_with_high_priority
    ld hl,message_pause
    call scoreboard_trigger_message
updatePlayerCar_pause_loop:
    ld hl,game_cycle
    inc (hl)
	call scoreboard_update_message
	halt
	halt
	;; check if ESC is pressed:
    ld a,#07
    call SNSMAT
    bit 2,a
	jr z,updatePlayerCar_pause_quit
	call checkInput
	bit INPUT_PAUSE_BIT,a
	jr z,updatePlayerCar_pause_loop
	; continue music:
	ld a,RACE_STATE_RACING
	ld (race_state),a
	pop af
	ld (MUSIC_play),a
	ret

updatePlayerCar_pause_quit:
	pop af	; simulate ret
	jp gameover_screen



;-----------------------------------------------
; finds the best place in the road to respawn the car
; input;
; - ix: car to respawn
updatePlayerCar_respawn:
	; 1) given the direction of the current rail, get:
	;    - the position at which we want to start looking for the road
	;    - the coordinates of that position
	; 2) given the direction of the current rail, move along, looking for the road,
	;    until we find two road tiles in a row, or until we got out of the screen again (in which case, respawn fails)
	; 3) respawn
	ld hl,(current_scroll_rails_ptr)
	ld a,(hl)
	cp SCROLL_RAIL_RIGHT
	jr z,updatePlayerCar_respawn_right
	cp SCROLL_RAIL_LEFT
	jp z,updatePlayerCar_respawn_left
	cp SCROLL_RAIL_UP
	jp z,updatePlayerCar_respawn_up
	cp SCROLL_RAIL_DOWN
	jp z,updatePlayerCar_respawn_down
	ret	; if it's not any of this, respawn fails

updatePlayerCar_respawn_right:
	; get the x, y coordinates:
	ld a,(scroll_x_tile)
	add a,SCROLL_RIGHT_CAR_X
	ld c,a
	ld a,(scroll_y_tile)
	ld b,a
	push bc
	call get_map_tile_pointer
	pop bc
	ld a,(map_width)
	ld d,0
	ld e,a	; de has the map_width
	ld a,16	; height of the screen (maximum number of tiles to check for the road)
	ld iyl,2	; number of road tiles we want to find
updatePlayerCar_respawn_right_loop
	push af
	ld a,(hl)
	;cp FIRST_GRASS_TILE_TYPE
	push hl
	ld hl,track_first_grass_tile_type
	cp (hl)
	pop hl
	jp p,updatePlayerCar_respawn_right_loop_no_road
	; road!
	dec iyl
	jr z,updatePlayerCar_respawn_right_respawn
updatePlayerCar_respawn_right_loop_no_road:
	inc b
	add hl,de
	pop af
	dec a
	jr nz,updatePlayerCar_respawn_right_loop
	ret	; if we reach here, respawn has failed
updatePlayerCar_respawn_right_respawn:
	pop af
	; we found a position, and we want to teleport the car there:
	ld a,0	; angle we want the car to start in
	jp teleport_car

updatePlayerCar_respawn_left:
	; get the x, y coordinates:
	ld a,(scroll_x_tile)
	add a,SCROLL_LEFT_CAR_X
	ld c,a
	ld a,(scroll_y_tile)
	ld b,a
	push bc
	call get_map_tile_pointer
	pop bc
	ld a,(map_width)
	ld d,0
	ld e,a	; de has the map_width
	ld a,16	; height of the screen (maximum number of tiles to check for the road)
	ld iyl,2	; number of road tiles we want to find
updatePlayerCar_respawn_left_loop
	push af
	ld a,(hl)
	;cp FIRST_GRASS_TILE_TYPE
	push hl
	ld hl,track_first_grass_tile_type
	cp (hl)
	pop hl
	jp p,updatePlayerCar_respawn_left_loop_no_road
	; road!
	dec iyl
	jr z,updatePlayerCar_respawn_left_respawn
updatePlayerCar_respawn_left_loop_no_road:
	inc b
	add hl,de
	pop af
	dec a
	jr nz,updatePlayerCar_respawn_left_loop
	ret	; if we reach here, respawn has failed
updatePlayerCar_respawn_left_respawn:
	pop af
	; we found a position, and we want to teleport the car there:
	ld a,32	; angle we want the car to start in
	jp teleport_car

updatePlayerCar_respawn_up:
	; get the x, y coordinates:
	ld a,(scroll_x_tile)
	ld c,a
	ld a,(scroll_y_tile)
	add a,SCROLL_UP_CAR_Y
	ld b,a
	push bc
	call get_map_tile_pointer
	pop bc
	ld a,32	; width of the screen (maximum number of tiles to check for the road)
	ld iyl,2	; number of road tiles we want to find
updatePlayerCar_respawn_up_loop
	push af
	ld a,(hl)
	;cp FIRST_GRASS_TILE_TYPE
	push hl
	ld hl,track_first_grass_tile_type
	cp (hl)
	pop hl
	jp p,updatePlayerCar_respawn_up_loop_no_road
	; road!
	dec iyl
	jr z,updatePlayerCar_respawn_up_respawn
updatePlayerCar_respawn_up_loop_no_road:
	inc c
	inc hl
	pop af
	dec a
	jr nz,updatePlayerCar_respawn_up_loop
	ret	; if we reach here, respawn has failed
updatePlayerCar_respawn_up_respawn:
	pop af
	; we found a position, and we want to teleport the car there:
	ld a,16	; angle we want the car to start in
	jp teleport_car

updatePlayerCar_respawn_down:
	; get the x, y coordinates:
	ld a,(scroll_x_tile)
	add a,31	; start from the right side of the screen
	ld c,a
	ld a,(scroll_y_tile)
	add a,SCROLL_DOWN_CAR_Y
	ld b,a
	push bc
	call get_map_tile_pointer
	pop bc
	ld a,32	; width of the screen (maximum number of tiles to check for the road)
	ld iyl,3	; number of road tiles we want to find
updatePlayerCar_respawn_down_loop
	push af
	ld a,(hl)
	;cp FIRST_GRASS_TILE_TYPE
	push hl
	ld hl,track_first_grass_tile_type
	cp (hl)
	pop hl
	jp p,updatePlayerCar_respawn_down_loop_no_road
	; road!
	dec iyl
	jr z,updatePlayerCar_respawn_down_respawn
updatePlayerCar_respawn_down_loop_no_road:
	dec c
	dec hl
	pop af
	dec a
	jp nz,updatePlayerCar_respawn_down_loop
	ret	; if we reach here, respawn has failed
updatePlayerCar_respawn_down_respawn:
	pop af
	; we found a position, and we want to teleport the car there:
	ld a,48	; angle we want the car to start in
	jp teleport_car


;-----------------------------------------------
; player car update function when it's exploding.
; it changes the car sprite to the explosion, and also provides the game termination singal
; after the explosion is over
updatePlayerCar_explosion:
	ld iy,sprite_attributes_buffer + 12*4	; sprite attributes of the player car
	ld hl,player_car_explosion_timer
	ld a,(hl)
	bit 3,a
	jp z,updatePlayerCar_explosion_frame1
updatePlayerCar_explosion_frame2:
	ld (iy+2),EXPLOSION_SPRITE_PATTERN1+8
	ld (iy+4+2),EXPLOSION_SPRITE_PATTERN1+12
	jp updatePlayerCar_explosion_continue1
updatePlayerCar_explosion_frame1:
	ld (iy+2),EXPLOSION_SPRITE_PATTERN1
	ld (iy+4+2),EXPLOSION_SPRITE_PATTERN1+4
updatePlayerCar_explosion_continue1:
	bit 1,a
	jp z,updatePlayerCar_explosion_color1
updatePlayerCar_explosion_color2:
	ld (iy+4+3),15	; white
	jp updatePlayerCar_explosion_continue2
updatePlayerCar_explosion_color1:
	ld (iy+4+3),8	; red
updatePlayerCar_explosion_continue2:
	inc a
	ld (hl),a
	cp 96
	jp nc,explosion_over
	jp updateCarPhysics_brake

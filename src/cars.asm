
;-----------------------------------------------
; precalculates the offset of the scroll in pixels, so that all the sprite calculations later can use these values
calculateScrollOffsets:
	; screen_x = (car_map_x/COORDINATE_PRECISION) - ((scroll_x_tile)*8 + (scroll_x_pixel)*2)
	ld a,(scroll_x_tile)
	ld l,a
	ld h,0
	add hl,hl
	add hl,hl
	ld a,(scroll_x_pixel)
	ld c,a
	ld b,0
	add hl,bc
	add hl,hl	; hl = ((scroll_x_tile)*8 + (scroll_x_pixel)*2)
	ld (current_scroll_x_offset),hl

	; screen_y = (car_map_y/COORDINATE_PRECISION) - ((scroll_y_tile)*8 + (scroll_y_pixel)*2)
	ld a,(scroll_y_tile)
	ld l,a
	ld h,0
	add hl,hl
	add hl,hl
	ld a,(scroll_y_pixel)
	ld c,a
	ld b,0
	add hl,bc
	add hl,hl	; hl = ((scroll_x_tile)*8 + (scroll_x_pixel)*2)
	ld (current_scroll_y_offset),hl

	ret


;-----------------------------------------------
; routines to rotate/accelerate/brake cars
update_car_rotate_left:
	push af
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	jr nz,update_car_rotate_left_ignore_damage
	ld a,(player_car_tyre_damage)
	cp 16
	jp p,update_car_rotate_left_damaged
update_car_rotate_left_ignore_damage:
	ld a,(ix+CAR_STRUCT_SPEED)
	cp 90
	call nc,tyre_damage	; fast enough to cause tyre damage!
;	cp 8
;	jp c,update_car_rotate_left_too_slow_to_rotate
	cp 32
	jp nc,update_car_rotate_left_fast_enough_to_rotate
update_car_rotate_left_damaged:
	ld a,(game_cycle)
	and #01
	jr z,update_car_rotate_left_too_slow_to_rotate
update_car_rotate_left_fast_enough_to_rotate:
	inc (ix+CAR_STRUCT_ANGLE)
update_car_rotate_left_too_slow_to_rotate:
	pop af
	ret

update_car_rotate_right:
	push af
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	jr nz,update_car_rotate_right_ignore_damage
	ld a,(player_car_tyre_damage)
	cp 16
	jp p,update_car_rotate_right_damaged
update_car_rotate_right_ignore_damage:
	ld a,(ix+CAR_STRUCT_SPEED)
	cp 90
	call nc,tyre_damage	; fast enough to cause tyre damage!
;	cp 8
;	jp c,update_car_rotate_right_too_slow_to_rotate
	cp 32
	jp nc,update_car_rotate_right_fast_enough_to_rotate
update_car_rotate_right_damaged:
	ld a,(game_cycle)
	and #01
	jr z,update_car_rotate_right_too_slow_to_rotate
update_car_rotate_right_fast_enough_to_rotate:
	dec (ix+CAR_STRUCT_ANGLE)
update_car_rotate_right_too_slow_to_rotate:
	pop af	
	ret


update_car_gear_up:
	push af
	ld a,(ix+CAR_STRUCT_GEAR)
	or a
	jr z,update_car_gear_up_from_reverse
	ld (ix+CAR_STRUCT_GEAR),2
	pop af
	ret
update_car_gear_up_from_reverse:
	ld a,(ix+CAR_STRUCT_SPEED)
	cp -8
	jp m,update_car_gear_up_from_reverse_too_fast
	ld (ix+CAR_STRUCT_GEAR),1
update_car_gear_up_from_reverse_too_fast:
	pop af
	ret


update_car_gear_down:
	push af
	ld a,(ix+CAR_STRUCT_GEAR)
	or a
	jr z,update_car_gear_down_done
	dec a
	jr z,update_car_gear_down_to_reverse
	ld (ix+CAR_STRUCT_GEAR),1
	pop af
	ret
update_car_gear_down_to_reverse:
	ld a,(ix+CAR_STRUCT_SPEED)
	cp 8
	jp p,update_car_gear_down_to_reverse_too_fast
	ld (ix+CAR_STRUCT_GEAR),0
update_car_gear_down_to_reverse_too_fast:
update_car_gear_down_done:
	pop af
	ret


;-----------------------------------------------
; teleports the car, resetting its speed
; input:
; - c: tile x
; - b: tile y
; - a: angle to face
teleport_car:
	ld (ix+CAR_STRUCT_ANGLE),a
	xor a
	ld (ix+CAR_STRUCT_SPEED),a
;	ld (ix+CAR_STRUCT_LAST_SPEED_X),a
;	ld (ix+CAR_STRUCT_LAST_SPEED_Y),a
	ld (ix+CAR_STRUCT_GEAR_PROFILE_STATE),a
	ld l,0
	ld h,c
	srl h	; divide hl by 2
	rr l
	ld (ix+CAR_STRUCT_MAP_X),l
	ld (ix+CAR_STRUCT_MAP_X+1),h
	ld l,0
	ld h,b
	srl h	; divide hl by 2
	rr l
	ld (ix+CAR_STRUCT_MAP_Y),l
	ld (ix+CAR_STRUCT_MAP_Y+1),h
	ld (ix+CAR_STRUCT_INVULNERABILITY),32
	ret


;-----------------------------------------------
; implements drag
updateCarPhysics_drag:
	ld a,(ix+CAR_STRUCT_SPEED)
	or a
	jr z,updateCarPhysics_drag_zero_velocity
	jp m,updateCarPhysics_drag_negative_velocity
	dec a	; decrease speed slowly with time
	jp updateCarPhysics_drag_zero_velocity
updateCarPhysics_drag_negative_velocity:
	inc a
updateCarPhysics_drag_zero_velocity:
	ld (ix+CAR_STRUCT_SPEED),a
	ret


;-----------------------------------------------
; Updates the physics of the car:
updateCarPhysics:
	ld a,(ix+CAR_STRUCT_INVULNERABILITY)
	or a
	jr z,updateCarPhysics_not_invulnerable
	dec (ix+CAR_STRUCT_INVULNERABILITY)
updateCarPhysics_not_invulnerable:

	; I need to copy 4 bytes from IX+CAR_STRUCT_MAP_X (2) to car_previous_w
	push ix
	pop hl
	inc hl
	inc hl
	inc hl
	ld de,car_previous_x
	ldi
	ldi
	ldi
	ldi

	; pyshics:
	; 1) drag:
	call updateCarPhysics_drag
	ld a,(ix+CAR_STRUCT_TILE_UNDERNEATH)
	cp TERRAIN_GRASS
	jr nz,updateCarPhysics_no_grass_drag
	ld a,(game_cycle)
	and #01
	jr nz,updateCarPhysics_no_grass_drag
	call updateCarPhysics_drag
updateCarPhysics_no_grass_drag:

	; calculate current speed vector:
	; - we will use "de" to store the sine or cosine of the angle, and multiply it with the current speed (in a)
	; - since sine and cosine tables are bounded to +255 and -255, the result has more or less 8 bits of a decimal part, which can be ignored
	ld a,(ix+CAR_STRUCT_ANGLE)
	and #3e
	ld c,a
	ld b,0
	ld hl,cos_table
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,(ix+CAR_STRUCT_SPEED)
	call Mul8SignedA	; hl = de*a		-> h is the desired velocity on the "x" axis
	ld l,h
	ld a,h
	add a,a
	sbc a,a
	ld h,a	; we "sign" extend "h" into "hl"
	; we average the current desired, with the previous one, to have a bid effect of skidding:
;	ld de,(car_last_speed_x)
;	add hl,de
;	ld a,l
;	or h
;	jp z,updateCarPhysics_x_speed_adjustment_done	; if speed is 0, we are done	
;	add hl,de
;	add hl,de
;	sra h
;	rr l
;	sra h
;	rr l	; de is now the average speed from last frame and the desired one for this frame
;	bit 7,h	; we decrease speed in 1 also at each cycle, otherwise, it's impossible to get it to 0
;	jp z,updateCarPhysics_x_speed_positive
;	inc hl
;	jp updateCarPhysics_x_speed_adjustment_done
;updateCarPhysics_x_speed_positive:
;	dec hl
;updateCarPhysics_x_speed_adjustment_done:
;	ld (ix+CAR_STRUCT_LAST_SPEED_X),l
	ld c,(ix+CAR_STRUCT_MAP_X)
	ld b,(ix+CAR_STRUCT_MAP_X+1)
	add hl,bc
	ld (ix+CAR_STRUCT_MAP_X),l
	ld (ix+CAR_STRUCT_MAP_X+1),h

	call get_tile_under_car
	ld (ix+CAR_STRUCT_TILE_UNDERNEATH),a
	cp TERRAIN_OBSTACLE
	jr z,updateCarPhysics_car_x_collision
	call collision_with_other_cars
	jp nz,updateCarPhysics_car_x_collision_with_car

updateCarPhysics_car_after_x_collision:
	ld a,(ix+CAR_STRUCT_ANGLE)
	and #3e
	ld c,a
	ld b,0
	ld hl,sin_table
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,(ix+CAR_STRUCT_SPEED)
	call Mul8SignedA	; hl = de*a		-> h is the desired velocity on the "y" axis
	ld l,h
	ld a,h
	add a,a
	sbc a,a
	ld h,a	; we "sign" extend "h" into "hl"
;	; we average the current desired, with the previous one, to have a bid effect of skidding:
;	ld de,(car_last_speed_y)
;	add hl,de
;	ld a,l
;	or h
;	jp z,updateCarPhysics_y_speed_adjustment_done	; if speed is 0, we are done
;	add hl,de
;	add hl,de
;	sra h
;	rr l
;	sra h
;	rr l	; de is now the average speed from last frame and the desired one for this frame
;	bit 7,h	; we decrease speed in 1 also at each cycle, otherwise, it's impossible to get it to 0
;	jp z,updateCarPhysics_y_speed_positive
;	inc hl
;	jp updateCarPhysics_y_speed_adjustment_done
;updateCarPhysics_y_speed_positive:
;	dec hl
;updateCarPhysics_y_speed_adjustment_done:
;	ld (ix+CAR_STRUCT_LAST_SPEED_Y),l
	ld c,(ix+CAR_STRUCT_MAP_Y)
	ld b,(ix+CAR_STRUCT_MAP_Y+1)
	add hl,bc
	ld (ix+CAR_STRUCT_MAP_Y),l
	ld (ix+CAR_STRUCT_MAP_Y+1),h

	call get_tile_under_car
	ld (ix+CAR_STRUCT_TILE_UNDERNEATH),a
	cp TERRAIN_OBSTACLE
	jp z,updateCarPhysics_car_y_collision
	call collision_with_other_cars
	jp nz,updateCarPhysics_car_y_collision_with_car
	ret

updateCarPhysics_car_x_collision:
	ld a,(ix+CAR_STRUCT_SPEED)
	cp 32
	jp m,updateCarPhysics_car_x_collision_slow

	; lower speed:
	sra a
	ld (ix+CAR_STRUCT_SPEED),a

	; invert the angle in the Y axis: 
	ld a,(ix+CAR_STRUCT_ANGLE)
	neg
	add a,32

	; see if the change in angle is less than 12 (a bit more than 60 degrees)
	sub (ix+CAR_STRUCT_ANGLE)
;	call a_absolute_value	
	and #03f
	cp 33
	jp m,updateCarPhysics_car_x_collision_no_angle_diff_adjustment
	neg
	add a,64
updateCarPhysics_car_x_collision_no_angle_diff_adjustment:
	cp 12
	jp p,updateCarPhysics_car_x_collision_angle_too_big
	call update_chasis_damage_side_collision
	ld a,(ix+CAR_STRUCT_ANGLE)
	neg
	add a,32
	ld (ix+CAR_STRUCT_ANGLE),a
	jr updateCarPhysics_car_x_collision_slow
updateCarPhysics_car_x_collision_angle_too_big:
	call update_chasis_damage_frontal_collision
	ld a,(ix+CAR_STRUCT_SPEED)
	neg
	sra a	; divide by 2
	ld (ix+CAR_STRUCT_SPEED),a

updateCarPhysics_car_x_collision_slow:
	ld hl,(car_previous_x)
	ld (ix+CAR_STRUCT_MAP_X),l
	ld (ix+CAR_STRUCT_MAP_X+1),h
	jp updateCarPhysics_car_after_x_collision


updateCarPhysics_car_y_collision:
	ld a,(ix+CAR_STRUCT_SPEED)
	cp 32
	jp m,updateCarPhysics_car_y_collision_slow

	; lower speed:
	sra a
	ld (ix+CAR_STRUCT_SPEED),a

	; invert the angle in the X axis: 
	ld a,(ix+CAR_STRUCT_ANGLE)
	neg

	; see if the change in angle is less than 12 (a bit more than 60 degrees)
	sub (ix+CAR_STRUCT_ANGLE)
;	call a_absolute_value	
	and #03f
	cp 33
	jp m,updateCarPhysics_car_y_collision_no_angle_diff_adjustment
	neg
	add a,64
updateCarPhysics_car_y_collision_no_angle_diff_adjustment:
	cp 12
	jp p,updateCarPhysics_car_y_collision_angle_too_big
	call update_chasis_damage_side_collision
	ld a,(ix+CAR_STRUCT_ANGLE)
	neg
	ld (ix+CAR_STRUCT_ANGLE),a
	jr updateCarPhysics_car_y_collision_slow
updateCarPhysics_car_y_collision_angle_too_big:
	call update_chasis_damage_frontal_collision
	ld a,(ix+CAR_STRUCT_SPEED)
	neg
	sra a	; divide by 2
	ld (ix+CAR_STRUCT_SPEED),a
updateCarPhysics_car_y_collision_slow:
	ld hl,(car_previous_y)
	ld (ix+CAR_STRUCT_MAP_Y),l
	ld (ix+CAR_STRUCT_MAP_Y+1),h
	ret


updateCarPhysics_car_x_collision_with_car:
	; current car struct in IX
	; car struct we collided with in IY
	; 1) effect of the collision:
	;	a) how much does the impact affect velocity: (IX.vx-IY.vx, 0) * (cos(IX.angle), sin(IX.angle))
	;	b) mutiply that by 0.5 (non elastic collision)
	;		thus -> (IX.vx-IY.vx) * cos(IX.angle) / 2
	push ix
	push iy
	pop ix
	call calculate_car_speed_x
	pop ix
	push hl
	call calculate_car_speed_x
	pop bc
	xor a
	sbc hl,bc	; hl = car1 velocity X minus car2 velocity X
	push hl
	ld a,(ix+CAR_STRUCT_ANGLE)
	add a,32
	and #3e
	ld c,a
	ld b,0
	ld hl,cos_table
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	sra d	
	rr e	; divide cos by 2, so we can put it in a (in the ranve of -127 to 128)
	ld a,e	
	pop de
	push de
	call Mul8SignedA	; hl is now (IX.vx-IY.vx) * cos(IX.angle)
	; bring it now to the proper scale:
	;	- (IX.vx-IY.vx) is in the same scale as "speed" (whatever shown in screen/2)
	;   - thus, since cos is between -127 and 128 (since we divided it by 2)
	;     we need to divide hl by 256 (so, just get "h")
	;	d) add that to the speed of the car 
	ld a,(ix+CAR_STRUCT_SPEED)
	add a,h
	ld (ix+CAR_STRUCT_SPEED),a
	ld a,(ix+CAR_STRUCT_CAR_ID)
	call check_collision_with_car_chasis_damage

	;	e) do the same for the other car, in IY):
	;       thus -> (IX.vx-IY.vx) * cos(IY.angle) / 2
	ld a,(iy+CAR_STRUCT_ANGLE)
	and #3e
	ld c,a
	ld b,0
	ld hl,cos_table
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	sra d	
	rr e	; divide cos by 2, so we can put it in a (in the ranve of -127 to 128)
	ld a,e	
	pop de
	call Mul8SignedA	; hl is now (IX.vx-IY.vx) * cos(IY.angle)
	ld a,(iy+CAR_STRUCT_SPEED)
	add a,h
	ld (iy+CAR_STRUCT_SPEED),a
	ld a,(iy+CAR_STRUCT_CAR_ID)
	call check_collision_with_car_chasis_damage

	; 2) reset car coordinates and recalculate velocities:
	jp updateCarPhysics_car_x_collision_slow


updateCarPhysics_car_y_collision_with_car:
	; current car struct in IX
	; car struct we collided with in IY
	; 1) effect of the collision:
	;	a) how much does the impact affect velocity: (0, IX.vy-IY.vy) * (cos(IX.angle), sin(IX.angle))
	;	b) mutiply that by 0.5 (non elastic collision)
	;		thus -> (IX.vy-IY.vy) * sin(IX.angle) / 2
	push ix
	push iy
	pop ix
	call calculate_car_speed_y
	pop ix
	push hl
	call calculate_car_speed_y
	pop bc
	xor a
	sbc hl,bc	; hl = car1 velocity Y minus car2 velocity Y
	push hl
	ld a,(ix+CAR_STRUCT_ANGLE)
	add a,32
	and #3e
	ld c,a
	ld b,0
	ld hl,sin_table
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	sra d	
	rr e	; divide sin by 2, so we can put it in a (in the ranve of -127 to 128)
	ld a,e	
	pop de
	push de
	call Mul8SignedA	; hl is now (IX.vy-IY.vy) * sin(IX.angle)
	; bring it now to the proper scale:
	;	- (IX.vx-IY.vx) is in the same scale as "speed" (whatever shown in screen/2)
	;   - thus, since sin is between -127 and 128 (since we divided it by 2)
	;     we need to divide hl by 256 (so, just get "h")
	;	d) add that to the speed of the car 
	ld a,(ix+CAR_STRUCT_SPEED)
	add a,h
	ld (ix+CAR_STRUCT_SPEED),a
	ld a,(ix+CAR_STRUCT_CAR_ID)
	call check_collision_with_car_chasis_damage

	;	e) do the same for the other car, in IY):
	;       thus -> (IX.vy-IY.vy) * sin(IY.angle) / 2
	ld a,(iy+CAR_STRUCT_ANGLE)
	and #3e
	ld c,a
	ld b,0
	ld hl,sin_table
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	sra d	
	rr e	; divide cos by 2, so we can put it in a (in the ranve of -127 to 128)
	ld a,e	
	pop de
	call Mul8SignedA	; hl is now (IX.vy-IY.vy) * cos(IY.angle)
	ld a,(iy+CAR_STRUCT_SPEED)
	add a,h
	ld (iy+CAR_STRUCT_SPEED),a
	ld a,(iy+CAR_STRUCT_CAR_ID)
	call check_collision_with_car_chasis_damage

	; 2) reset car coordinates (that's what the next jump does):
	jp updateCarPhysics_car_y_collision_slow


calculate_car_speed_x:
	ld a,(ix+CAR_STRUCT_ANGLE)
	and #3e
	ld c,a
	ld b,0
	ld hl,cos_table
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,(ix+CAR_STRUCT_SPEED)
	call Mul8SignedA	; hl = de*a		-> h is the desired velocity on the "x" axis
	ld l,h
	ld a,h
	add a,a
	sbc a,a
	ld h,a	; we "sign" extend "h" into "hl"
	ret


calculate_car_speed_y:
	ld a,(ix+CAR_STRUCT_ANGLE)
	and #3e
	ld c,a
	ld b,0
	ld hl,sin_table
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	ld a,(ix+CAR_STRUCT_SPEED)
	call Mul8SignedA	; hl = de*a		-> h is the desired velocity on the "y" axis
	ld l,h
	ld a,h
	add a,a
	sbc a,a
	ld h,a	; we "sign" extend "h" into "hl"
	ret


;-----------------------------------------------
; if gear is 0:
;    if speed != 0: brake
;    if speed == 0: gear up
; if gear is 1:
;    if speed < 48: accelerate
;    if speed >= 48: gear up
; if gear is 2:
;    if speed < 32: gear down
;    if speed >= 32: accelerate
updateCarPhysics_accelerate_auto_gear:
	ld a,(ix+CAR_STRUCT_GEAR)
	or a
	jr z,updateCarPhysics_accelerate_auto_gear_reverse
	dec a
	jr z,updateCarPhysics_accelerate_auto_gear_low_gear
	ld a,(ix+CAR_STRUCT_SPEED)
	add a,8
	cp (ix+CAR_STRUCT_SHIFT_UP_SPEED)	; if speed is 16 below shift gear up speed, shift down
	jp m,update_car_gear_down
	jp updateCarPhysics_accelerate	
updateCarPhysics_accelerate_auto_gear_reverse:
	ld a,(ix+CAR_STRUCT_SPEED)
	or a
	jp nz,updateCarPhysics_brake
	jp update_car_gear_up
updateCarPhysics_accelerate_auto_gear_low_gear:
	ld a,(ix+CAR_STRUCT_SPEED)
	cp (ix+CAR_STRUCT_SHIFT_UP_SPEED)
	jp p,update_car_gear_up
	; jp updateCarPhysics_accelerate


;-----------------------------------------------
updateCarPhysics_accelerate:
	ld a,(ix+CAR_STRUCT_ACCELERATION_STATE)
	add a,(ix+CAR_STRUCT_ACCELERATION)
	ld (ix+CAR_STRUCT_ACCELERATION_STATE),a
	sub 64
	ret m
	ld (ix+CAR_STRUCT_ACCELERATION_STATE),a
	ld a,(ix+CAR_STRUCT_GEAR)
	ld e,1	; we accelerate forwards
	or a
	jr nz,updateCarPhysics_accelerate_forwards
	ld e,-1
updateCarPhysics_accelerate_forwards:
	ld l,(ix+CAR_STRUCT_CAR_MODEL_PTR)
	ld h,(ix+CAR_STRUCT_CAR_MODEL_PTR+1)
	or a
	jr z,updateCarPhysics_accelerate_gear_profile_done
updateCarPhysics_accelerate_gear_profile_loop:
	inc hl
	inc hl
	dec a
	jr nz,updateCarPhysics_accelerate_gear_profile_loop
updateCarPhysics_accelerate_gear_profile_done:
	ld c,(hl)	; resolve the indirection of the gear_profile
	inc hl
	ld b,(hl)
	ld h,b
	ld l,c
;	ld hl,low_gear_144	; DEBUG!!!
	; accelerate based on the gear profile:
	ld a,(ix+CAR_STRUCT_SPEED)
	or a
	jp p,updateCarPhysics_accelerate_positive_speed
	neg
updateCarPhysics_accelerate_positive_speed:
	sra a
	sra a
	sra a	; divide by 8
	ld b,0
	ld c,a
	add hl,bc	; hl has a pointer to the gear profile
	ld a,(hl)
	; if acceleration generated is less than 16, then engine is suffering:
	cp 16
	call m,engine_damage
	or a
	jr nz,updateCarPhysics_accelerate_generate_acceleration
	ld e,0	; if the gear profile says we accelerate 0, then do not generate acceleration at all!
updateCarPhysics_accelerate_generate_acceleration:
	ld c,a
	ld a,(ix+CAR_STRUCT_GEAR_PROFILE_STATE)
	and #3f	; to remove any overflow
	add a,c
	ld (ix+CAR_STRUCT_GEAR_PROFILE_STATE),a
	cp 64
	ld a,(ix+CAR_STRUCT_SPEED)
	jp m,updateCarPhysics_accelerate_not_this_frame
	add a,e
updateCarPhysics_accelerate_not_this_frame:
	add a,e
	ld (ix+CAR_STRUCT_SPEED),a
	ret


;-----------------------------------------------
; if gear is 0:
;    accelerate
; if gear is 1 or 2
;    if speed == 0: gear down
;    if speed != 0: brake
updateCarPhysics_brake_auto_gear:
	ld a,(ix+CAR_STRUCT_GEAR)
	or a
	jp z,updateCarPhysics_accelerate
	ld a,(ix+CAR_STRUCT_SPEED)
	or a
	jp z,update_car_gear_down
	; jp updateCarPhysics_brake

updateCarPhysics_brake:
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	jr nz,updateCarPhysics_brake_ignore_damage_sound
	ld a,(game_cycle)
	and #01
	jr nz,updateCarPhysics_brake_no_sound
	ld a,(ix+CAR_STRUCT_SPEED)
	cp 32
	jp m,updateCarPhysics_brake_no_sound
	ld hl,SFX_brake
	call play_ingame_SFX
updateCarPhysics_brake_no_sound:
	ld a,(player_car_brake_damage)
	cp 16
	ret p	; higher damage than 16 and brakes just don't work!
	ld a,(ix+CAR_STRUCT_SPEED)
	cp 70	; any speed higher than 140kph causes brake damage
	call p,brake_damage
updateCarPhysics_brake_ignore_damage_sound:
	ld a,(ix+CAR_STRUCT_SPEED)
	ld b,2
updateCarPhysics_brake_loop:
	or a
	jr z,updateCarPhysics_brake_zero_velocity
	jp m,updateCarPhysics_brake_negative_velocity
	dec a
	jp updateCarPhysics_brake_loop_continue
updateCarPhysics_brake_negative_velocity:
	inc a
updateCarPhysics_brake_loop_continue:
	djnz updateCarPhysics_brake_loop
updateCarPhysics_brake_zero_velocity:
	ld (ix+CAR_STRUCT_SPEED),a
;	ld hl,(car_last_speed_x)
;	sra h
;	rr l
;	ld (car_last_speed_x),hl
;	ld hl,(car_last_speed_y)
;	sra h
;	rr l
;	ld (car_last_speed_y),hl
	ret


;-----------------------------------------------
; calculaters the on-screen coordinates of the cars
updateCarSprites:
	ld ix,player_car_struct
	ld iy,sprite_attributes_buffer+FIRST_CAR_SPRITE*4

	; map coordinates to screen coordinates:
	ld hl,(player_car_map_x)
	srl h
	rr l	
	srl h
	rr l	
	srl h
	rr l	
	srl h
	rr l	; we divide hl by 	COORDINATE_PRECISION (let's assume it's 16)
	xor a
	ld bc,(current_scroll_x_offset)
	sbc hl,bc

	ld a,(scroll_being_pushed_x)
	or a
	jr z,updateCarSprites_scroll_not_pushed_on_x
	res 0,l
updateCarSprites_scroll_not_pushed_on_x:
	ld (iy+1),l
	ld (iy+1+4),l

	ld hl,(player_car_map_y)
	srl h
	rr l	
	srl h
	rr l	
	srl h
	rr l	
	srl h
	rr l	; we divide hl by 	COORDINATE_PRECISION (let's assume it's 16)
	xor a
	ld bc,(current_scroll_y_offset)
	sbc hl,bc

	ld a,(scroll_being_pushed_y)
	or a
	jr z,updateCarSprites_scroll_not_pushed_on_y
	res 0,l
updateCarSprites_scroll_not_pushed_on_y:
	ld (iy+0),l
	ld (iy+0+4),l

	; flash if we have invulnerability:
	ld a,(ix+CAR_STRUCT_INVULNERABILITY)
	or a
	call nz,updateCarSprites_invulnerable

	; rest of the cars
	ld ix,player_car_struct+CAR_STRUCT_SIZE
	ld iy,sprite_attributes_buffer+(FIRST_CAR_SPRITE+2)*4
	ld b,3
updateCarSprites_loop:
	push bc

	ld l,(ix+CAR_STRUCT_MAP_X)
	ld h,(ix+CAR_STRUCT_MAP_X+1)
	srl h
	rr l	
	srl h
	rr l
	srl h
	rr l	
	srl h
	rr l	; we divide hl by 	COORDINATE_PRECISION (let's assume it's 16)
	xor a
	ld bc,(current_scroll_x_offset)
	sbc hl,bc

	; if h = -1 && l > 224 -> early clock, and x = l - 224
	; if h == 0 -> regular clock, and x = l
	ld c,(iy+4+3)	; we load the color byte (so we can manipulate it with the early clock bit if necessary)
	res 7,c	; clear the early clock bit
	ld a,h
	or a
	jr z,updateCarSprites_car_inside_of_screen_x_regular_clock
	inc a
	jp nz,updateCarSprites_car_outside_of_the_screen
	ld a,l
	sub 224
	jp c,updateCarSprites_car_outside_of_the_screen
	set 7,c
	ld (iy+3),#81		; early clock bit set
	ld (iy+4+3),c		; early clock bit set
;	ld (ix+CAR_STRUCT_SCREEN_X),a
	ld (iy+1),a
	ld (iy+1+4),a
	jp updateCarSprites_car_after_x
updateCarSprites_car_inside_of_screen_x_regular_clock:
;	ld (ix+CAR_STRUCT_SCREEN_X),l
	ld (iy+3),1		; early clock bit not set
	ld (iy+4+3),c	; early clock bit not set
	ld (iy+1),l
	ld (iy+1+4),l
updateCarSprites_car_after_x:

	ld l,(ix+CAR_STRUCT_MAP_Y)
	ld h,(ix+CAR_STRUCT_MAP_Y+1)
	srl h
	rr l	
	srl h
	rr l	
	srl h
	rr l	
	srl h
	rr l	; we divide hl by 	COORDINATE_PRECISION (let's assume it's 16)
	xor a
	ld bc,(current_scroll_y_offset)
	sbc hl,bc
	ld bc,16	; we need to do this, since when coordinates are -1 to -15, sprite should still be visible
	add hl,bc
	ld a,l
	cp 128+16
	jp nc,updateCarSprites_car_outside_of_the_screen
	ld a,h
	or a
	jr nz,updateCarSprites_car_outside_of_the_screen
	sbc hl,bc	; no need to xor a, since at this point we know "z"
;	ld (ix+CAR_STRUCT_SCREEN_Y),l
	ld (iy+0),l
	ld (iy+0+4),l
	
	; flash if we have invulnerability:
	ld a,(ix+CAR_STRUCT_INVULNERABILITY)
	or a
	call nz,updateCarSprites_invulnerable	

updateCarSprites_car_next_car:
    ld bc,CAR_STRUCT_SIZE
    add ix,bc
    ld bc,8
    add iy,bc	

	pop bc
	dec b
	jp nz,updateCarSprites_loop
	; djnz updateCarSprites_loop
	ret

updateCarSprites_invulnerable:
	and #02
	ret z
updateCarSprites_invulnerable_flash1:
	ld (iy+0),200
	ld (iy+0+4),200
	ret


updateCarSprites_car_outside_of_the_screen:
	ld l,200
;	ld (ix+CAR_STRUCT_SCREEN_Y),l
	ld (iy+0),l
	ld (iy+0+4),l
	jp updateCarSprites_car_next_car


;-----------------------------------------------
; copies the sprite corresponding to the current car angle to the VDP
uploadCarSpritePatterns:
	ld ix,player_car_struct
    ld de,SPRTBL2+32	; we skip the first sprite, which is used to protect the scoreboard
    ld b,4
uploadCarSpritePatterns_loop:
	push bc
    ld a,(ix+CAR_STRUCT_ANGLE)	; sprite is (a/2)%16
    and #3e				; so, offset is: car_sprite_patterns_buffer + ((a/2)%16)*64
    ld l,a				; which can be calculated as: car_sprite_patterns_buffer + (a & #3e)*32
    ld h,0
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl			; hl is now (a & #3e)*32
    ld bc,car_sprite_patterns_buffer
    add hl,bc
    ld bc,64
    push de
    ex de,hl
    call loadDoubleSpriteToVDP
    pop de
    ld bc,64
    ex de,hl
    add hl,bc
    ex de,hl
    ld bc,CAR_STRUCT_SIZE
    add ix,bc
    pop bc
    djnz uploadCarSpritePatterns_loop
    ret


;-----------------------------------------------
; A car has just passed a checkpoint, update the race position order
; - notice that the car being updated can ONLY go forward, never backwards
; - So, this is basically a "bubble sort" pass in one direction
update_race_positions:
	ld a,(ix+CAR_STRUCT_CAR_ID)
	ld hl,car_race_order
	ADD_HL_A_VIA_BC		; c has the current car now
	ld e,(hl)	; current position
	ld iyl,e	; we store the initial position in iyl
	ld d,(ix+CAR_STRUCT_RACE_PROGRESS)	; current race progress

	xor a		; a has which car we are considering
	push ix
	ld hl,car_race_order
	ld ix,player_car_struct
update_race_positions_loop:
	cp c
	push af
	jr z,update_race_positions_loop_skip
	ld a,(ix+CAR_STRUCT_RACE_PROGRESS)	; other car, race progress
	cp d
	jp p,update_race_positions_loop_skip	; if the other car is the same or ahead, ignore
	ld a,(hl)
	cp iyl	; we compare with the original position in which we were at
;	cp e
	jp p,update_race_positions_loop_skip	; if the other car was behind already, ignore
	dec e		; we move one position up!
	inc (hl)	; the other car moves one position down
update_race_positions_loop_skip:
	inc hl
	push bc
	ld bc,CAR_STRUCT_SIZE
	add ix,bc
	pop bc
	pop af
	inc a
	cp 4
	jp nz,update_race_positions_loop
	pop ix
	ld a,(ix+CAR_STRUCT_CAR_ID)
	ld hl,car_race_order
	ADD_HL_A_VIA_BC		; c has the current car now
	ld (hl),e	; save new position
	ret


;-----------------------------------------------
; updates the chasis damage counter after a collision at sufficient speed
update_chasis_damage_frontal_collision:
	ld hl,SFX_collision_hard
	call play_ingame_SFX
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	ret nz	; if it was not the player car, ignore
	ld hl,player_car_chasis_damage
	inc (hl)
	inc (hl)	; double damage
	ld a,(hl)
	cp 16
	jp m,updateScoreboardDamage
	ld a,1
	ld (player_car_explosion_timer),a	; explode!
	ld hl,message_race_over
	call scoreboard_trigger_message
	jp updateScoreboardDamage

update_chasis_damage_side_collision:
	ld hl,SFX_collision_soft
	call play_ingame_SFX
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	ret nz	; if it was not the player car, ignore
	ld hl,player_car_chasis_damage
	inc (hl)
	ld a,(hl)
	cp 16
	jp m,updateScoreboardDamage
	ld a,1
	ld (player_car_explosion_timer),a	; explode!
	ld hl,message_race_over
	call scoreboard_trigger_message
	jp updateScoreboardDamage


;-----------------------------------------------
; updates chasis damage based on a collision with another car
; inputs:
; - A: car in question
; - H: adjustment to the speed that will be made
check_collision_with_car_chasis_damage:
	or a
	ret nz

	push hl
	ld hl,SFX_collision_soft
	call play_ingame_SFX
	pop hl

	ld a,h
	call a_absolute_value
	cp 16	; threshold of speed difference to update damage
	ret m

	ld hl,SFX_collision_hard
	call play_ingame_SFX

	ld hl,player_car_chasis_damage
	inc (hl)
	jp updateScoreboardDamage


;-----------------------------------------------
; adds a bit of damage to the engine
engine_damage:
	push af
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	jr nz,engine_damage_no_damage	; if it was not the player car, ignore
	ld a,(game_cycle)
	and #7f
	jr nz,engine_damage_no_damage
	ld hl,player_car_engine_damage
	inc (hl)
	ld a,(hl)
	cp 12
	jp m,engine_damage_not_yet_degraded
	; degrade the acceleration of the car! the car is now much slower because of the engine damage
	ld a,56
	ld (player_car_struct+CAR_STRUCT_ACCELERATION),a
engine_damage_not_yet_degraded:
	call updateScoreboardDamage
engine_damage_no_damage:
	pop af
	ret


;-----------------------------------------------
; adds a bit of damage to the brakes
brake_damage:
	push af
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	jr nz,brake_damage_no_damage	; if it was not the player car, ignore
	ld a,(game_cycle)
	and #03
	jr nz,brake_damage_no_damage
	ld hl,player_car_brake_damage
	inc (hl)
	call updateScoreboardDamage
brake_damage_no_damage:
	pop af
	ret


;-----------------------------------------------
; adds a bit of damage to the tyres
tyre_damage:
	push af
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	jr nz,tyre_damage_no_damage	; if it was not the player car, ignore
	ld a,(game_cycle)
	and #3f
	jr nz,tyre_damage_no_damage
	ld hl,player_car_tyre_damage
	inc (hl)
	call updateScoreboardDamage
tyre_damage_no_damage:
	pop af
	ret



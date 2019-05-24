;-----------------------------------------------
; updates all the opponent cars
updateAICars:
	ld ix,opponent_car2_struct
	call car_ai_update
	ld ix,opponent_car3_struct
	call car_ai_update
	ld ix,opponent_car4_struct
	; jp car_ai_update


;-----------------------------------------------
; drives an opponent car around the track
car_ai_update:
;	ld a,(ix+CAR_STRUCT_TILE_UNDERNEATH)
;	cp TERRAIN_GRASS
;	jp p,car_ai_update_out_of_track
;car_ai_update_within_track:
;	ld (ix+CAR_STRUCT_OUT_OF_TRACK_TIMER),0
;	jr car_ai_update_after_respawn
;car_ai_update_out_of_track:
;	inc (ix+CAR_STRUCT_OUT_OF_TRACK_TIMER)
;	ld a,(ix+CAR_STRUCT_OUT_OF_TRACK_TIMER)

	ld a,(ix+CAR_STRUCT_SPEED)
	cp 4
	jp m,car_ai_zero_speed	; speed lower than 8 kph
car_ai_non_zero_speed
	ld (ix+CAR_STRUCT_COLLISION_TIMER),0
	jr car_ai_update_after_respawn
car_ai_zero_speed:
	inc (ix+CAR_STRUCT_COLLISION_TIMER)
	ld a,(ix+CAR_STRUCT_COLLISION_TIMER)
	cp 32
	call p,car_ai_respawn
car_ai_update_after_respawn:

	call update_car_race_position	; as a result of this function, we have the direction of the check point in bc,
									; and hl points to the proper place in the waypoint structure
	push hl
	; move the car toward the waypoint:
	call atan2	; input B = x, C = y   	in -128,127
				; output: A = angle     in 0-255
	; we now have the angle of the waypoint:
	srl a	; we bring the precision back to out 64-degree angles
	srl a
	sub (ix+CAR_STRUCT_ANGLE)
	and #3f	; a = angle difference between car and waypoint
	jr z,car_ai_update_just_accelerate
	cp 32
	jp p,car_ai_update_turn_right
car_ai_update_turn_left:
	call update_car_rotate_left
	jp car_ai_update_just_accelerate
car_ai_update_turn_right:
	call update_car_rotate_right
car_ai_update_just_accelerate:
	pop hl
	inc hl
	ld a,(hl)	; this is the maximum speed at which we want to go to this waypoint
	cp (ix+CAR_STRUCT_SPEED)
	push af
	call nc,updateCarPhysics_accelerate_auto_gear
	pop af
	call c,updateCarPhysics_brake_auto_gear
	jp updateCarPhysics


;-----------------------------------------------
; checks if a car has passed the next waypoint
update_car_race_position:
	; get the next waypoint:
	ld hl,track_waypoints
	ld a,(ix+CAR_STRUCT_NEXT_WAYPOINT)
	ADD_HL_A_VIA_BC

	; calculate the difference between the waypoint and the current car position
	ld a,(hl)	; waypoint x
	push hl
	ld l,(ix+CAR_STRUCT_MAP_X)
	ld h,(ix+CAR_STRUCT_MAP_X+1)
	add hl,hl	; now the x tile coordinate is in "h"
	inc h		; to get the center of the car, and not the top-left
	sub h		; a now has (car tile x - waypoint tile x)
	ld b,a
	pop hl

	inc hl
	ld a,(hl)	; waypoint y
	push hl
	ld l,(ix+CAR_STRUCT_MAP_Y)
	ld h,(ix+CAR_STRUCT_MAP_Y+1)
	add hl,hl	; now the x tile coordinate is in "h"
	inc h		; to get the center of the car, and not the top-left
	sub h		; a now has (car tile y - waypoint tile y)
	neg			; we negate the "y" difference, since atan2 is in right-hand coordiantes
	ld c,a		; now we have the difference between the car and the waypoint in bc

	; see if we have passed the waypoint:
	pop hl
	inc hl
	ld a,(hl)
	or a	; WAYPOINT_RIGHT:	equ 0
	jr z,update_car_race_position_waypoint_right
	dec a	; WAYPOINT_LEFT:	equ 1
	jr z,update_car_race_position_waypoint_left
	dec a	; WAYPOINT_DOWN:	equ 2
	jr z,update_car_race_position_waypoint_down
	dec a	; WAYPOINT_UP:	equ 3
	jr z,update_car_race_position_waypoint_up
	; dec a	; WAYPOINT_LOOP:	equ 4
update_car_race_position_waypoint_loop:
	ld (ix+CAR_STRUCT_NEXT_WAYPOINT),0
	ld a,(ix+CAR_STRUCT_CAR_ID)
	or a
	; if this is the player car, increase the lap count in the scoreboard:
	jp z,scoreboard_increase_lap_count
	; otherwise, increase the lap count of the AI cars:
	ld hl,current_lap
	ADD_HL_A_VIA_BC
	inc (hl)
	; check if all opponents have done the maximum number of laps:
	ld hl,current_lap+1
	ld a,49+MAX_LAPS-1
	cp (hl)
	ret p
	inc hl
	cp (hl)
	ret p
	inc hl
	cp (hl)
	ret p
	; race should be over, since all opponents have done 4 laps!
	jp max_laps_reached

update_car_race_position_waypoint_right:
	ld a,b	; x tile difference
	cp 3
	jp m,update_car_race_position_next_waypoint
	ret

update_car_race_position_waypoint_left:
	ld a,b	; x tile difference
	cp -1
	ret m
	jp update_car_race_position_next_waypoint

update_car_race_position_waypoint_down:
	ld a,c	; y negated tile difference
	cp -1
	ret m
	jp update_car_race_position_next_waypoint

update_car_race_position_waypoint_up:
	ld a,c	; y negated tile difference
	cp 3
	jp m,update_car_race_position_next_waypoint
	ret


;-----------------------------------------------
; a car has passed a waypoint, so we update its progress in the race, and update the car positions (1st, 2ne, 3rd or 4th):
update_car_race_position_next_waypoint:
	ld a,(ix+CAR_STRUCT_NEXT_WAYPOINT)
	add a,4
	ld (ix+CAR_STRUCT_NEXT_WAYPOINT),a
;	ld a,(ix+CAR_STRUCT_RACE_PROGRESS)
;	cp #7f
;	ret z	; if a car has reached position 127, then just stop updating this to avoid overflow
	inc (ix+CAR_STRUCT_RACE_PROGRESS)
	push hl
	call update_race_positions
	pop hl
	ret


;-----------------------------------------------
; respawn an AI car in the road in a proper position to continue racing
car_ai_respawn:
	xor a
	; prevent any other car from spawning on the same cycle:
	ld (opponent_car2_struct+CAR_STRUCT_COLLISION_TIMER),a
	ld (opponent_car3_struct+CAR_STRUCT_COLLISION_TIMER),a
	ld (opponent_car4_struct+CAR_STRUCT_COLLISION_TIMER),a
	; get the next waypoint:
	ld hl,track_waypoints
	ld a,(ix+CAR_STRUCT_NEXT_WAYPOINT)
	ADD_HL_A_VIA_BC
	ld c,(hl)	; waypoint x
	inc hl
	ld b,(hl)
	inc hl
	ld a,(hl)
	cp WAYPOINT_RIGHT
	jr z,car_ai_respawn_right
	cp WAYPOINT_LEFT
	jr z,car_ai_respawn_left
	cp WAYPOINT_DOWN
	jr z,car_ai_respawn_down
;	cp WAYPOINT_UP
;	jp z,car_ai_respawn_up
car_ai_respawn_up:
	ld a,16
	jp teleport_car
car_ai_respawn_down:
	ld a,48
	jp teleport_car
car_ai_respawn_left:
	ld a,32
	jp teleport_car
car_ai_respawn_right:
	ld a,0
	jp teleport_car


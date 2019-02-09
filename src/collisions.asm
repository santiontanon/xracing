;-----------------------------------------------
; Checks if the car is outside of the current viewport
; returns:
; - z:  outside
; - nz: inside
check_if_player_car_is_outside_viewport:
	ld l,(ix+CAR_STRUCT_MAP_X)
	ld h,(ix+CAR_STRUCT_MAP_X+1)
	add hl,hl	; now the x tile coordinate is in "h"
	inc h		; to get the center of the car, and not the top-left
	ld a,(scroll_x_tile)
	cp h
	jp p,check_if_player_car_is_outside_viewport_outside
	add a,30
	cp h
	jp m,check_if_player_car_is_outside_viewport_outside

	ld l,(ix+CAR_STRUCT_MAP_Y)
	ld h,(ix+CAR_STRUCT_MAP_Y+1)
	add hl,hl	; now the y tile coordinate is in "h"
	inc h		; to get the center of the car, and not the top-left
	ld a,(scroll_y_tile)
	cp h
	jp p,check_if_player_car_is_outside_viewport_outside
	add a,14
	cp h
	jp m,check_if_player_car_is_outside_viewport_outside

	or 1
	ret
check_if_player_car_is_outside_viewport_outside:
	xor a
	ret


;-----------------------------------------------
; gets the tile under the current position of a cat
; - ix: pointer to the car
; returns:
; - a: the tile under the center of the car
get_tile_under_car:	
	ld a,(map_width)
	ld d,0
	ld e,a
	ld l,(ix+CAR_STRUCT_MAP_Y)
	ld h,(ix+CAR_STRUCT_MAP_Y+1)
	add hl,hl	; now the y tile coordinate is in "h"
	inc h		; to get the center of the car, and not the top-left
	ld a,h	
	call Mul8	; hl = (map_width) * car_y_coordinate
    ld bc,map_buffer
    add hl,bc
    ld b,h
    ld c,l

	ld l,(ix+CAR_STRUCT_MAP_X)
	ld h,(ix+CAR_STRUCT_MAP_X+1)
	add hl,hl	; now the x tile coordinate is in "h"
	inc h		; to get the center of the car, and not the top-left
	ld l,h
	ld h,0
	add hl,bc
	ld a,(hl)

get_tile_under_car_translate:
	; translate the tile type to a terrain type (road, grass, obstacle)
	ld hl,track_first_collidable_tile_type
	cp (hl)
	; cp FIRST_COLLITABLE_TILE_TYPE
	jp c,get_tile_under_car_translate_h_no_collision
	ld a,TERRAIN_OBSTACLE
	ret
get_tile_under_car_translate_h_no_collision:
	ld hl,track_first_grass_tile_type
	cp (hl)
	; cp FIRST_GRASS_TILE_TYPE
	jp c,get_tile_under_car_translate_h_no_grass
	ld a,TERRAIN_GRASS
	ret
get_tile_under_car_translate_h_no_grass:
	xor a
	ret


;-----------------------------------------------
; Checks if the current car is colliding with any other car
; - It assumes the currect car struct is pointed to by ix
; output:
; - Z if there is no collision
; - NZ if there is collision
collision_with_other_cars:
	ld iy,player_car_struct
	ld bc,CAR_STRUCT_SIZE
	xor a
collision_with_other_cars_loop:
	cp (ix+CAR_STRUCT_CAR_ID)
	jp z,collision_with_other_cars_loop_skip
	; check for collision:
	push af
	ld l,(ix+CAR_STRUCT_MAP_X)
	ld h,(ix+CAR_STRUCT_MAP_X+1)
	ld e,(iy+CAR_STRUCT_MAP_X)
	ld d,(iy+CAR_STRUCT_MAP_X+1)
	or a
	sbc hl,de
	; collision can happen if hl is in the range -144 to 144
	or a
	ld de,144
	sbc hl,de
	add hl,de
	jp p,collision_with_other_cars_no_collision
	or a
	ld de,-144
	sbc hl,de
	jp m,collision_with_other_cars_no_collision

	ld l,(ix+CAR_STRUCT_MAP_Y)
	ld h,(ix+CAR_STRUCT_MAP_Y+1)
	ld e,(iy+CAR_STRUCT_MAP_Y)
	ld d,(iy+CAR_STRUCT_MAP_Y+1)
	or a
	sbc hl,de
	; collision can happen if hl is in the range -144 to 144
	or a
	ld de,144
	sbc hl,de
	add hl,de
	jp p,collision_with_other_cars_no_collision
	or a
	ld de,-144
	sbc hl,de
	jp p,collision_with_other_cars_collision
collision_with_other_cars_no_collision:
;collision_with_other_cars_loop_skip_pop_af:
	pop af
collision_with_other_cars_loop_skip:
	add iy,bc
	inc a
	cp N_CARS
	jp nz,collision_with_other_cars_loop
	ret
collision_with_other_cars_collision:
	pop af
	or 1
	ret

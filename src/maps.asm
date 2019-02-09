;-----------------------------------------------
; precomputes the offset tables, and looks for trees and other sprites in the map
load_map:
	ld a,(track_tileset)
	or a
	jr nz,load_map_urban_tileset
	ld hl,tileTypes_pletter
	jr load_map_urban_tileset_selected
load_map_urban_tileset:
	ld hl,tileTypes_urban_pletter
load_map_urban_tileset_selected:
	ld de,tileTypesV_ptr
	call pletter_unpack
	ld hl,(tileTypesV_ptr)
	ld bc,tileTypes_buffer
	add hl,bc
	ld (tileTypesV_ptr),hl

    ; calculate the scroll limits:
    ld a,(map_width)
    sub 32
    ld h,0
    ld l,a
    add hl,hl
    add hl,hl
    ld (horizontal_scroll_limit),hl

    ld a,(map_height)
    sub 16
    ld h,0
    ld l,a
    add hl,hl
    add hl,hl
    ld (vertical_scroll_limit),hl

    xor a
    ld (map_n_sprites),a

    ; 2) create the offset tables:
    ; do one row:
    ld hl,map_buffer	; this is where the map data starts

    ld a,(map_height)
    ld b,a
    ld iyh,0
load_map_row_loop:
	push bc
    ld a,(map_width)
    ld b,a
    ld iyl,0
load_map_column_loop:
	push bc
    ld a,(hl)
    inc hl
	cp TILETYPE_TREE_TOP_LEFT
	push af
	call z,load_map_found_a_tree
	pop af
	cp TILETYPE_SIGNPOST_TOP_LEFT
	call z,load_map_found_a_signpost
	pop bc
	inc iyl
	djnz load_map_column_loop
	pop bc
	inc iyh	; increase the y coordinate (this is only used by the "load_map_found_a_tree" function)
	djnz load_map_row_loop
	ret


load_map_found_a_tree:
	ld a,(track_tileset)
	or a
	ret nz	; in the urban tileset, we do not have trees!
	; set up the sprite!
	ld a,(map_n_sprites)
	push af
	push hl
	push bc
	ld b,0
	ld c,a
	ld hl,sprites_in_map
	add hl,bc
	add hl,bc
	add hl,bc	; hl now has the position of the next sprite (each sprites is 3 bytes)
	pop bc
	ld a,iyh
	ld (hl),a 	; y coordinate
	inc hl
	ld a,iyl
	ld (hl),a	; x coordinate
	inc hl
	ld (hl),TREE_SPRITE_PATTERN	; tree sprite
	pop hl
	pop af
	inc a
	ld (map_n_sprites),a
	ret

load_map_found_a_signpost:
	ld a,(track_tileset)
	or a
	ret nz	; in the urban tileset, we do not have signposts!
	; set up the sprite!
	ld a,(map_n_sprites)
	push af
	push hl
	push bc
	ld b,0
	ld c,a
	ld hl,sprites_in_map
	add hl,bc
	add hl,bc
	add hl,bc	; hl now has the position of the next sprite (each sprites is 3 bytes)
	pop bc
	ld a,iyh
	ld (hl),a 	; y coordinate
	inc hl
	ld a,iyl
	ld (hl),a	; x coordinate
	inc hl
	ld (hl),SIGNPOST_SPRITE_PATTERN1
	inc hl

	ld a,iyh
	ld (hl),a 	; y coordinate
	inc hl
	ld a,iyl
	ld (hl),a	; x coordinate
	inc (hl)
	inc (hl)	; the second sprite is 2 tiles to the right
	inc hl
	ld (hl),SIGNPOST_SPRITE_PATTERN2
	pop hl
	pop af
	inc a
	inc a
	ld (map_n_sprites),a
	ret


;-----------------------------------------------
; draws the current map at map_buffer to the VDP
prepareTileTypes_for_drawMap:
    ; copy the right tileType table to "tileTypes"
    ; we calculate the pointer to the tileType table to use accodring to the current pixel scroll offset:
    ; ld de,N_TILE_TYPES
    ld a,(n_tile_types)
	ld b,0
	ld c,a

    ld hl,(current_scroll_rails_ptr)
    ld a,(hl)
    cp SCROLL_RAIL_DOWN
    jp p,prepareTileTypes_for_drawMap_vertical_scrollTable
    ld a,(scroll_x_pixel)
    ld hl,tileTypesH
    jp prepareTileTypes_for_drawMap_scrollTable_set
prepareTileTypes_for_drawMap_vertical_scrollTable:
    ld a,(scroll_y_pixel)
    ld hl,(tileTypesV_ptr)
prepareTileTypes_for_drawMap_scrollTable_set:
	or a
	jp z,prepareTileTypes_for_drawMap_tileType_table_done
prepareTileTypes_for_drawMap_tileType_table_loop:
	add hl,bc
	dec a
	jp nz,prepareTileTypes_for_drawMap_tileType_table_loop
prepareTileTypes_for_drawMap_tileType_table_done:
	; now copy it to tileTypes:
	ld de,tileTypes
	ldir
	ret


;-----------------------------------------------
; draws the current map at map_buffer to the VDP
drawMap:
	; set the VDP to write:
	ld hl,NAMTBL2
    call SETWRT

    ; calculate the starting offset of the map:
	; skip (scroll_y_tile) rows:
	ld hl,map_width
	ld d,0
	ld e,(hl)
	ld a,e
	sub 32
	ld iyl,a	; we save (map_width)-32
	ld a,(scroll_y_tile)
	call Mul8
    ld bc,map_buffer
    add hl,bc
	; skip (scroll_x_tile) tiles:
	ld a,(scroll_x_tile)
	ADD_HL_A_VIA_BC

    ld a,(VDP.DW)
    ld c,a
    ld d,tileTypes/256
    ld iyh,16	; number of rows to draw
drawMap_loop:
	ld b,32		; tiles to copy from this column
drawMap_row_loop:
	ld e,(hl)
	inc hl
	ld a,(de)
	out (c),a
	djnz drawMap_row_loop
drawMap_row_done:
	ld a,iyl
	ADD_HL_A
	dec iyh
	jp nz,drawMap_loop
	ret


;-----------------------------------------------
; goes through the list of map sprites, and draws the first 6 that are within the screen
drawMapSprites:
	; we start by making them all out of the screen
	ld a,200
	ld (sprite_attributes_buffer+FIRST_MAP_SPRITE*4),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+1)*4),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+2)*4),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+3)*4),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+4)*4),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+5)*4),a
	; reset their early clock byte:
	ld a,1
	ld (sprite_attributes_buffer+FIRST_MAP_SPRITE*4+3),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+1)*4+3),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+2)*4+3),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+3)*4+3),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+4)*4+3),a
	ld (sprite_attributes_buffer+(FIRST_MAP_SPRITE+5)*4+3),a

	ld a,(map_n_sprites)
	or a
	ret z
	ld hl,sprites_in_map
	ld de,sprite_attributes_buffer+FIRST_MAP_SPRITE*4
	ld iyl,MAX_MAP_SPRITES_IN_SCREEN
drawMapSprites_loop:
	push af
	; render coordinates are: 
	; - X: (sprite_x - scroll_x_tile)*8 - scroll_x_pixel*2
	; - Y: (sprite_y - scroll_y_tile)*8 - scroll_y_pixel*2

	; if (sprite_y-scroll_y_tile)<-2 -> out of the screen
	; if (sprite_y-scroll_y_tile)>=16 -> out of the screen
	ld a,(scroll_y_tile)
	sub (hl)
	neg
	cp 17
	jp p,drawMapSprites_loop_out_of_the_screen
	cp -2
	jp m,drawMapSprites_loop_out_of_the_screen
drawMapSprites_back_from_y_edge:
	add a,a
	add a,a
	add a,a
	ld c,a
	ld a,(scroll_y_pixel)
	add a,a
	neg
	add a,c
	dec a	; sprites in MSX are drawn one pixel lower than their coordinate
	ld (de),a

	inc de
	inc hl

	; if (sprite_x-scroll_x_tile)<-2 -> out of the screen
	; if (sprite_x-scroll_x_tile)>=32 -> out of the screen	
	ld a,(scroll_x_tile)
	sub (hl)
	neg
	cp 32
	jp z,drawMapSprites_loop_in_the_x_edge
	cp 33
	jp p,drawMapSprites_loop_out_of_the_screen2
	cp -2
	jp m,drawMapSprites_loop_out_of_the_screen2
	cp 1
	jp m,drawMapSprites_early_clock_byte
drawMapSprites_back_from_x_edge:
	add a,a
	add a,a
	add a,a
	ld c,a
drawMapSprites_back_from_early_clock_byte
	ld a,(scroll_x_pixel)
	add a,a
	neg
	add a,c
	ld (de),a

	inc de
	inc hl
	ldi
;	inc de
	inc de
;	inc hl

	dec iyl
	jp z, drawMapSprites_done_early

drawMapSprites_next_sprite:
	pop af
	dec a
	jp nz, drawMapSprites_loop
	ret

drawMapSprites_done_early:
	pop af
	ret

;drawMapSprites_loop_in_the_y_edge:
;	push af
;	ld a,(scroll_y_pixel)
;	or a
;	jp z,drawMapSprites_loop_out_of_the_screen_pop
;	pop af
;	jp drawMapSprites_back_from_y_edge

drawMapSprites_loop_in_the_x_edge:
	push af
	ld a,(scroll_x_pixel)
	or a
	jp z,drawMapSprites_loop_out_of_the_screen2_pop
	pop af
	jp drawMapSprites_back_from_x_edge

drawMapSprites_early_clock_byte:
	add a,a
	add a,a
	add a,a
	add a,32
	ld c,a
	inc de
	inc de
	ld a,(de)
	or #80
	ld (de),a
	dec de
	dec de
	jp drawMapSprites_back_from_early_clock_byte

drawMapSprites_loop_out_of_the_screen_pop:
	pop af
drawMapSprites_loop_out_of_the_screen:
	inc hl
	inc hl
	inc hl
	jp drawMapSprites_next_sprite

drawMapSprites_loop_out_of_the_screen2_pop:
	pop af
drawMapSprites_loop_out_of_the_screen2
	dec de
	ld a,200
	ld (de),a
	inc hl
	inc hl
	jp drawMapSprites_next_sprite


;-----------------------------------------------
; goes through the semaphore sprites, and updates their position
;
; NOTE: this code is almost identical to the one for the map sprites above, can I merge?
drawSemaphoreSprites:
	; we start by making them all out of the screen
	ld a,200
	ld (sprite_attributes_buffer+FIRST_SEMAPHORE_SPRITE*4),a
	ld (sprite_attributes_buffer+(FIRST_SEMAPHORE_SPRITE+1)*4),a
	ld (sprite_attributes_buffer+(FIRST_SEMAPHORE_SPRITE+2)*4),a
	ld (sprite_attributes_buffer+(FIRST_SEMAPHORE_SPRITE+3)*4),a
	; reset their early clock byte:
	ld a,1
	ld (sprite_attributes_buffer+FIRST_SEMAPHORE_SPRITE*4+3),a
	ld (sprite_attributes_buffer+(FIRST_SEMAPHORE_SPRITE+1)*4+3),a
	ld (sprite_attributes_buffer+(FIRST_SEMAPHORE_SPRITE+2)*4+3),a
	ld (sprite_attributes_buffer+(FIRST_SEMAPHORE_SPRITE+3)*4+3),a

	ld a,4	; we have 4 semaphore sprites
	ld hl,semaphores_in_map
	ld de,sprite_attributes_buffer+FIRST_SEMAPHORE_SPRITE*4
drawSemaphoreSprites_loop:
	push af
	; render coordinates are: 
	; - X: (semaphore_x - scroll_x_tile)*8 - scroll_x_pixel*2
	; - Y: (semaphore_y - scroll_y_tile)*8 - scroll_y_pixel*2

	; if (semaphore_y-scroll_y_tile)<-2 -> out of the screen
	; if (semaphore_y-scroll_y_tile)>=16 -> out of the screen
	ld a,(scroll_y_tile)
	sub (hl)
	neg
	cp 17
	jp p,drawSemaphoreSprites_loop_out_of_the_screen
	cp -2
	jp m,drawSemaphoreSprites_loop_out_of_the_screen
drawSemaphoreSprites_back_from_y_edge:
	add a,a
	add a,a
	add a,a
	ld c,a
	ld a,(scroll_y_pixel)
	add a,a
	neg
	add a,c
	dec a	; sprites in MSX are drawn one pixel lower than their coordinate
	ld (de),a

	inc de
	inc hl

	; if (semaphore_x-scroll_x_tile)<-2 -> out of the screen
	; if (semaphore_x-scroll_x_tile)>=32 -> out of the screen	
	ld a,(scroll_x_tile)
	sub (hl)
	neg
	cp 32
	jp z,drawSemaphoreSprites_loop_in_the_x_edge
	cp 33
	jp p,drawSemaphoreSprites_loop_out_of_the_screen2
	cp -2
	jp m,drawSemaphoreSprites_loop_out_of_the_screen2
	cp 1
	jp m,drawSemaphoreSprites_early_clock_byte
drawSemaphoreSprites_back_from_x_edge:
	add a,a
	add a,a
	add a,a
	ld c,a
drawSemaphoreSprites_back_from_early_clock_byte
	ld a,(scroll_x_pixel)
	add a,a
	neg
	add a,c
	add a,4	; the semaphore is offset by 4 pixels on the grid
	ld (de),a

	inc de
	inc de
	inc de
	inc hl

drawSemaphoreSprites_next_semaphore:
	pop af
	dec a
	jp nz, drawSemaphoreSprites_loop
	ret

drawSemaphoreSprites_done_early:
	pop af
	ret

;drawSemaphoreSprites_loop_in_the_y_edge:
;	push af
;	ld a,(scroll_y_pixel)
;	or a
;	jp z,drawSemaphoreSprites_loop_out_of_the_screen_pop
;	pop af
;	jp drawSemaphoreSprites_back_from_y_edge

drawSemaphoreSprites_loop_in_the_x_edge:
	push af
	ld a,(scroll_x_pixel)
	or a
	jp z,drawSemaphoreSprites_loop_out_of_the_screen2_pop
	pop af
	jp drawSemaphoreSprites_back_from_x_edge

drawSemaphoreSprites_early_clock_byte:
	add a,a
	add a,a
	add a,a
	add a,32
	ld c,a
	inc de
	inc de
	ld a,(de)
	or #80
	ld (de),a
	dec de
	dec de
	jp drawSemaphoreSprites_back_from_early_clock_byte

drawSemaphoreSprites_loop_out_of_the_screen_pop:
	pop af
drawSemaphoreSprites_loop_out_of_the_screen:
	inc de
	inc de
	inc de
	inc de
	inc hl
	inc hl
	jp drawSemaphoreSprites_next_semaphore

drawSemaphoreSprites_loop_out_of_the_screen2_pop:
	pop af
drawSemaphoreSprites_loop_out_of_the_screen2
	dec de
	ld a,200
	ld (de),a
	inc de
	inc de
	inc de
	inc de
	inc hl
	jp drawSemaphoreSprites_next_semaphore


;-----------------------------------------------
; Calculates the pointer to a given tile in the map
; input:
; - c: tile x
; - b: tile y
get_map_tile_pointer:
	push bc
	; get the starting pointer:
	ld a,(map_width)
	ld d,0
	ld e,a
	ld a,b ; tile y
	call Mul8	; hl = (map_width) * car_y_coordinate
	pop bc
	ld a,c
	ADD_HL_A	
	ld bc,map_buffer
	add hl,bc	; we now have in "hl" the pointer to the first tile to check for road
	ret

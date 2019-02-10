races_screen:
	;call clearScreen

	call races_screen_get_next_available_races

	xor a
	ld (menu_cycle),a
	ld a,0
	ld (menu_selected_option),a
	ld (menu_play_sfx_on_update),a

races_screen_loop_updating_race_info:
	; draw the races screen:
	ld hl,races_screen_pletter
	ld de,menu_buffer2
	call pletter_unpack

	ld hl,races_pletter
	ld de,menu_buffer
	call pletter_unpack_from_page0

	call update_races_screen_data
	call update_selected_race_info

	ld hl,menu_buffer2
	ld de,NAMTBL2
	ld bc,768
	halt
	call fast_LDIRVM
	call clearAllTheSprites
	call draw_agent_neutral

	; play an SFX if needed
	ld a,(menu_play_sfx_on_update)
	or a
	jr z,races_screen_loop
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority
	xor a	
	ld (menu_play_sfx_on_update),a

races_screen_loop:
	halt

	; draw cursor:
	call races_screen_draw_cursor

	ld hl,menu_cycle
	inc (hl)

	call checkInput
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_UP_BIT,a
	jr nz,races_screen_pressed_up
	bit INPUT_DOWN_BIT,a
	jr nz,races_screen_pressed_down
	bit INPUT_TRIGGER1_BIT,a
	jr nz,races_screen_pressed_fire
	jr races_screen_loop


races_screen_pressed_up:
	; ld hl,SFX_menu_switch
	; call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call races_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(menu_races_n_races)
	cp (hl)
	jr z,races_screen_loop
	inc (hl)
	ld a,1
	ld (menu_play_sfx_on_update),a
	jr races_screen_loop_updating_race_info

races_screen_pressed_down:
	; ld hl,SFX_menu_switch
	; call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call races_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	or a
	jr z,races_screen_loop
	dec (hl)
	ld a,1
	ld (menu_play_sfx_on_update),a
	jp races_screen_loop_updating_race_info


races_screen_pressed_fire:
	ld a,(menu_selected_option)
	or a
	jp z,back_to_season_screen_from_other_menus
	
	call races_screen_selected_race_ptr
	ld de,game_progress_current_race_info
	ld bc,RACE_STRUCT_SIZE
	ldir

	; check if we have enough cash:
	ld hl,(game_progress_cash)
	ld a,(game_progress_current_race_info+13)	; entry fee
	ld b,0
	ld c,a
	xor a
	sbc hl,bc
	jp m,races_screen_pressed_fire_not_enough_cash
	ld (game_progress_cash),hl	; subtract the entry fee

	; mark the race as done:
	ld a,(menu_selected_option)
	dec a
;	ld b,a
;	ld a,(menu_races_n_races)
;	sub b
	ld hl,menu_races_race_indexes
	ADD_HL_A
	ld a,(hl)	; race #
	ld hl,game_progress_races_completed
	ADD_HL_A
	ld (hl),1	; mark race as done
	ld hl,game_progress_race_number
	inc (hl)	; increase the current race counter

	call races_screen_selected_race_track_ptr
	jp start_race

races_screen_pressed_fire_not_enough_cash:
	ld hl,carmarket_text_not_enough_cash
	ld bc,16
	call message_dialogue
	jp races_screen_loop_updating_race_info

races_screen_draw_cursor:
	ld a,(menu_selected_option)
	ld h,0
	ld l,a
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld b,h
	ld c,l
	ld hl,NAMTBL2+13*32+2
	xor a
	sbc hl,bc
	jp season_screen_loop_cursor_ptr_done


update_races_screen_data:
	ld hl,(game_progress_cash)
	ld de,menu_buffer2+27
	call draw_right_aligned_16bit_number_to_memory
	ld a,'$'
	ld (de),a

	; memory pointer to start drawing is NAMTBL2+11*32+3
	ld de,menu_buffer2+11*32+3
	ld a,(menu_races_n_races)
	ld ix,menu_races_race_ptrs
update_races_screen_data_loop:
	ld l,(ix)
	ld h,(ix+1)
	ld bc,12
	push af
	push de
	ldir
	pop hl
	ld bc,-64
	add hl,bc
	ex de,hl
	pop af
	inc ix
	inc ix
	dec a
	jr nz,update_races_screen_data_loop
	ret


races_screen_selected_race_ptr:
	; race is (menu_selected_option)
	ld a,(menu_selected_option)
	dec a

	; race is (menu_races_n_races) - (menu_selected_option)
;	ld a,(menu_selected_option)
;	ld b,a
;	ld a,(menu_races_n_races)
;	sub b
	ld b,0
	ld c,a
	ld hl,menu_races_race_ptrs
	add hl,bc
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ret


races_screen_selected_race_track_ptr:
	call races_screen_selected_race_ptr
	ld bc,12	; skip the race name
	add hl,bc	; track #
	ld a,(hl)
	ld b,0
	ld c,a
	ld hl,track_pointers
	add hl,bc
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ret



races_screen_get_next_available_races:
	ld a,(game_progress_category)
	or a
	jr z,races_screen_get_next_available_races_stock
	dec a
	jr z,races_screen_get_next_available_races_endurance
races_screen_get_next_available_races_f1:
	ld hl,menu_buffer+RACE_STRUCT_SIZE*8	; to start in the f1 races
	ld b,7	; # races in this category
	ld c,1 	; max races to select from
	jr races_screen_get_next_available_races_loop_start

races_screen_get_next_available_races_endurance:
	ld hl,menu_buffer+RACE_STRUCT_SIZE*4	; to start in the endurance races
	ld b,4	; # races in this category
	ld c,2 	; max races to select from
	jr races_screen_get_next_available_races_loop_start

races_screen_get_next_available_races_stock:
	ld hl,menu_buffer
	ld b,4	; # races in this category
	ld c,3 	; max races to select from
races_screen_get_next_available_races_loop_start:
	ld ix,menu_races_race_ptrs
	ld iy,menu_races_race_indexes
	ld de,game_progress_races_completed
	xor a
	ld (menu_races_n_races),a
races_screen_get_next_available_races_stock_loop:
	push af
	push bc
		ld b,a	; we save the race #
		ld a,(de)
		or a
		jr nz,races_screen_get_next_available_races_stock_race_completed	
		ld a,(menu_races_n_races)
		inc a
		ld (menu_races_n_races),a
		ld (ix),l
		ld (ix+1),h
		ld (iy),b	; race #
		cp c	; max races to select from
		jr z,races_screen_get_next_available_races_stock_early_stop
		inc ix
		inc ix
		inc iy
races_screen_get_next_available_races_stock_race_completed:
		ld bc,RACE_STRUCT_SIZE
		add hl,bc
		inc de
	pop bc
	pop af
	inc a
	cp b
	jr nz, races_screen_get_next_available_races_stock_loop
	ret
races_screen_get_next_available_races_stock_early_stop:
	pop bc
	pop af
	ret

update_selected_race_info:
	ld a,(menu_selected_option)
	or a
	ret z
	call races_screen_selected_race_ptr

	; race name
	ld de,menu_buffer2+19+14*32
	ld bc,12
	push hl
	ldir
	pop hl

	; draw minimap
	push hl
    ;call SETGAMEPAGE0
	call races_screen_selected_race_track_ptr
	ld de,menu_buffer+(4+6+8)*RACE_STRUCT_SIZE	; sufficiently far as for not overwriting the track info
	call pletter_unpack_from_page0

    ld hl,menu_buffer+(4+6+8)*RACE_STRUCT_SIZE
    ld de,menu_buffer2+21+7*32
    ld bc,6
    ldir
    ld hl,menu_buffer+(4+6+8)*RACE_STRUCT_SIZE+6
    ld de,menu_buffer2+21+8*32
    ld bc,6
    ldir
    ld hl,menu_buffer+(4+6+8)*RACE_STRUCT_SIZE+12
    ld de,menu_buffer2+21+9*32
    ld bc,6
    ldir
    ld hl,menu_buffer+(4+6+8)*RACE_STRUCT_SIZE+18
    ld de,menu_buffer2+21+10*32
    ld bc,6
    ldir
    ld hl,menu_buffer+(4+6+8)*RACE_STRUCT_SIZE+24
    ld de,menu_buffer2+21+11*32
    ld bc,6
    ldir
    ld hl,menu_buffer+(4+6+8)*RACE_STRUCT_SIZE+30
    ld de,menu_buffer2+21+12*32
    ld bc,6
    ldir

    pop hl
    ld bc,13
    add hl,bc	; entry fee
	ld a,(hl)
	push hl
	ld h,0
	ld l,a
	ld de,menu_buffer2+27+2*32
	call draw_right_aligned_16bit_number_to_memory
	ld a,'$'
	ld (de),a
	pop hl
	inc hl
	push hl
	ld a,(hl)
	ld h,0
	ld l,a
	ld de,menu_buffer2+27+4*32
	call draw_right_aligned_16bit_number_to_memory
	ld a,'$'
	ld (de),a
	pop hl

	; text description:
	ld bc,17
	add hl,bc
	ld bc,24
	ld de,menu_buffer2+7+18*32
	push hl
	push bc
	ldir
	pop bc
	pop hl
	add hl,bc
	ld de,menu_buffer2+7+19*32
	push hl
	push bc
	ldir
	pop bc
	pop hl
	add hl,bc
	ld de,menu_buffer2+7+20*32
	ldir
	ret


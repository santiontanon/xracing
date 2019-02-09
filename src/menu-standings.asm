standings_screen:
	; draw standings:
	; call clearScreen

	; draw the standings screen (first the season, and then we overlay the standings):
	ld hl,season_screen_pletter
	ld de,menu_buffer
	call pletter_unpack
	ld hl,menu_buffer

	ld hl,standings_screen_pletter
	ld de,menu_buffer
	call pletter_unpack
	ld hl,menu_buffer

	ld de,NAMTBL2
	ld bc,768
	halt
	call fast_LDIRVM
	call clearAllTheSprites
	call draw_agent_neutral

	call refresh_standings_screen

	ld a,(game_progress_season_state)
	cp 3
	jr nz,standings_screen_loop
	ld a,(menu_buffer+8)	; first driver of the standings
	or a
	jp nz,standings_screen_end_of_season_gameover
	call draw_agent_happy
	ld a,(game_progress_category)
	or a
	jr z,standings_screen_end_of_season_promote_to_endurance
standings_screen_end_of_season_promote_to_f1:
	ld a,4
	call draw_agent_text_character_by_character_press_space
	jr standings_screen_end_of_season
standings_screen_end_of_season_promote_to_endurance:
	ld a,3
	call draw_agent_text_character_by_character_press_space
	jr standings_screen_end_of_season

standings_screen_end_of_season_gameover:
	call draw_agent_angry
	ld a,5
	call draw_agent_text_character_by_character_press_space	
	jp gameover_screen

standings_screen_loop:
	halt

	; draw cursor:
	call standings_screen_draw_cursor

	ld hl,menu_cycle
	inc (hl)

	call checkInput
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_TRIGGER1_BIT,a
	jr nz,standings_screen_press_space
	jr standings_screen_loop

standings_screen_press_space:
	ld hl,SFX_menu_select
	call play_SFX_with_high_priority

	ld a,3
	ld (menu_selected_option),a
	jp back_to_season_screen_from_other_menus_do_not_reset_selection

standings_screen_draw_cursor:
	ld hl,NAMTBL2+15*32+13
	jp season_screen_loop_cursor_ptr_done


;-----------------------------------------------
; season is over, move up one category!
standings_screen_end_of_season:
	ld hl,game_progress_category
	ld a,(hl)
	cp 2
	jp z,gameover_screen	; replace with game ending!
	inc a
	jp season_screen_start_new_season


;-----------------------------------------------
; updates the info on the standings screen
refresh_standings_screen:
	ld hl,category_stock
	ld a,(game_progress_category)
	ld b,0
	ld c,a
	add hl,bc
	add hl,bc
	add hl,bc
	add hl,bc
	add hl,bc	; hl = category_stock + (game_progress_category)*6
	ld de,NAMTBL2+2*32+26
	ld bc,5
	call fast_LDIRVM

	; season year:
	ld a,(game_progress_category)
	ld h,0
	ld l,a
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld bc,season_year_stock
	add hl,bc
	ld de,NAMTBL2+1*32+1
	ld bc,8
	push hl
	push bc
	call fast_LDIRVM
	pop bc
	pop hl
	add hl,bc
	ld de,NAMTBL2+2*32+1
	call fast_LDIRVM

	call calculate_driver_standings
	; draw the driver standings:
	ld hl,menu_buffer+8	
	ld de,NAMTBL2+6*32+6
	ld iyl,8
refresh_standings_screen_loop:
	ld a,(hl)	; next driver to draw
	push hl
	ld h,0
	ld l,a
	push af
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld bc,(game_progress_category_drivers_ptr)
	add hl,bc	; pointer to the name to draw
	ld bc,16
	push de
	call fast_LDIRVM
	pop de
	pop af
	push de
	ld hl,22
	add hl,de
	ex de,hl

	ld hl,game_progress_points
	ld b,0
	ld c,a
	add hl,bc
	ld a,(hl)
	ld h,0
	ld l,a
	call draw_right_aligned_16bit_number_to_vdp
	pop hl
	ld bc,32
	add hl,bc
	ex de,hl	; next row
	pop hl
	inc hl	; next driver
	dec iyl
	jr nz,refresh_standings_screen_loop
	ret


;-----------------------------------------------
; calculates the current standing based on the points the player has accumulated.
; out:
; - a: current standing
calculate_current_standing:
	ld c,0	; standing
	ld hl,game_progress_points
	ld a,(hl)	; a has the player points
	dec a	; to make it so that if you tie in points, you are behind
	ld b,7
calculate_current_standing_loop:
	inc hl
	cp (hl)
	jp p,calculate_current_standing_skip
	inc c
calculate_current_standing_skip:
	djnz calculate_current_standing_loop
	ld a,c
	ret


;-----------------------------------------------
; sorts all the drivers based on their points
; the output will be a list in: menu_buffer+8
calculate_driver_standings:
	; 1) we place all the drivers that have not yet been assigned a standing (anything != 0 means not yet assigned a standing)
	ld a,1
	ld hl,menu_buffer
calculate_driver_standings_loop1:
	ld (hl),a
	inc hl
	inc a
	cp 9
	jr nz,calculate_driver_standings_loop1

	; 2) we find the top driver amongst the ones not yet considered, and we add it to the standings
	ld iyh,8	; iteratino counte
	ld ix,menu_buffer+8	; here is where we will be writing the standings
calculate_driver_standings_loop3:
	ld iyl,0	; current driver being considered
	;ld c,0		; current top driver points
	;ld b,0		; current top driver
	ld bc,0
	ld hl,game_progress_points
	ld de,menu_buffer
calculate_driver_standings_loop2:
	ld a,(de)
	or a
	jr z,calculate_driver_standings_already_has_a_standing
	ld a,(hl)
	cp c
	jp m,calculate_driver_standings_not_better
	ld c,a
	ld b,iyl
calculate_driver_standings_already_has_a_standing:
calculate_driver_standings_not_better:
	inc iyl
	inc hl
	inc de
	ld a,iyl
	cp 8
	jr nz,calculate_driver_standings_loop2
	ld (ix),b
	inc ix
	ld hl,menu_buffer
	ld c,b
	ld b,0
	add hl,bc
	ld (hl),0	; mark the driver as already considered
	dec iyh
	jr nz,calculate_driver_standings_loop3
	ret


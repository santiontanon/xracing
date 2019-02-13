
race_finished_screen:
	call disable_VDP_output
		call clearScreen
		call clearAllTheSprites

	    ld hl,patterns_base_pletter
	    call decompressPatternsToVDP3rdBank
	    ld hl,patterns_patch_base_race_finished_pletter
	    call applyPatternPatch
	    call decompressPatternsToVDPAllBanks_entry_point

    	ld hl,race_finished_screen_pletter
    	ld de,menu_buffer
    	call pletter_unpack
    	ld hl,menu_buffer
    	ld de,NAMTBL2+6*32
    	ld bc,32*12
    	call fast_LDIRVM

    	; fastest lap time:
    	ld hl,(fastest_lap_time)
    	ld d,25
    	call Div8	; a is now hl%25
    	add a,a
    	add a,a
    	push hl
    	ld h,0
    	ld l,a
    	ld de,NAMTBL2+25+14*32
    	call draw_right_aligned_16bit_number_to_vdp
    	pop hl
    	ld d,60
    	call Div8	; a is now hl%60
    	push hl
    	ld h,0
    	ld l,a
    	ld de,NAMTBL2+22+14*32
    	call draw_right_aligned_16bit_number_to_vdp
    	pop hl
    	ld de,NAMTBL2+19+14*32
    	call draw_right_aligned_16bit_number_to_vdp

    	; driver positions:
    	call race_finished_screen_render_driver_positions

    	; render price money:
    	ld a,(car_race_order)
    	ld hl,game_progress_current_race_info+14	; price money
    	ld b,(hl)
    	or a
    	jr z,race_finished_screen_price_money_loop_done
race_finished_screen_price_money_loop:
    	sra b
    	dec a
    	jr nz,race_finished_screen_price_money_loop
race_finished_screen_price_money_loop_done:
		ld h,0
		ld l,b
		push hl
		ld de,NAMTBL2+23+16*32
		call draw_right_aligned_16bit_number_to_vdp
		ld a,'$'
		push de
		pop hl
		call writeByteToVDP
		pop hl

		; add the money:
		ld bc,(game_progress_cash)
		add hl,bc
		ld (game_progress_cash),hl

		; add points to drivers:
		ld hl,car_race_order
		ld a,(hl)
		ld (game_progress_last_race_result),a
		ld b,a
		ld a,3
		sub b	; a now has the points we need to add
		push hl
			ld hl,game_progress_points
			add a,(hl)
			ld (hl),a	; add points to the player
		pop hl
		ld de,game_progress_current_race_info+15	; opponent list
		ld iyl,3
race_finished_screen_point_loop:
		ld a,(de)
		ld c,a	; which opponent
		inc hl
		ld b,(hl)
		ld a,3
		sub b	; a now has the points we need to add
		push hl
		push de
			ld hl,game_progress_points
			ld b,0
			add hl,bc
			add a,(hl)
			ld (hl),a
		pop de
		pop hl
		inc de
		dec iyl
		jr nz,race_finished_screen_point_loop

		; add points to the drivers that did not participate in the race:
		ld b,7
		ld hl,game_progress_current_race_info+24	; points to be added to other drivers
		ld de,game_progress_points+1
race_finished_screen_point_loop2:
		ld a,(de)
		add a,(hl)
		ld (de),a
		inc hl
		inc de
		djnz race_finished_screen_point_loop2

		; setup flag animation:
		call unpack_flag_patterns_to_VDP
		ld hl,flag_nametables_pletter
		ld de,title_buffer_flag
		call pletter_unpack
		
		ld hl,title_song_pletter
	    ld de,music_buffer
	    call pletter_unpack_from_page0
	    ld a,5
	    call play_song

	call enable_VDP_output

	xor a
race_finished_screen_loop:
	; get the right flag frame:
	inc a
	push af
	sra a
	call render_flag_get_current_frame_ptr

	halt
	; render the flag (only the part that should be visible around the frame)
	push hl
	ld de,NAMTBL2
	ld bc,6*32+5
	call fast_LDIRVM
	pop hl
	ld bc,6*32+27
	add hl,bc
	ld de,NAMTBL2+6*32+27

	ld iyl,11
race_finished_screen_loop_flag_loop:
	push hl
	push de
	ld bc,10
	call fast_LDIRVM
	pop hl
	ld bc,32
	add hl,bc
	ex de,hl
	pop hl
	ld bc,32
	add hl,bc
	dec iyl
	jr nz,race_finished_screen_loop_flag_loop
	ld bc,32+5+4*32
	call fast_LDIRVM

	call checkInput
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_TRIGGER1_BIT,a
	jr nz,race_finished_screen_press_space
	pop af
	jr race_finished_screen_loop

race_finished_screen_press_space:
	pop af
	ld hl,game_progress_season_state
	ld (hl),2	; to show the agent race feedback message
	jp season_screen


race_finished_screen_render_driver_positions:
	ld a,(game_progress_category)
	or a
	ld hl,rival_names_stock
	ld bc,16*8
	or a
race_finished_screen_render_driver_positions_category_loop:
	jr z,race_finished_screen_render_driver_positions_category_loop_done
	add hl,bc
	dec a
	jr race_finished_screen_render_driver_positions_category_loop
race_finished_screen_render_driver_positions_category_loop_done:
	push hl
	pop ix	; ix has now the pointer to the drivers names

	ld hl,game_progress_current_race_info+15	; opponent list
	ld iyl,0	; the first "opponent" is the player
	ld iyh,4	; we have 4 drivers
	exx
		ld hl,car_race_order
	exx

race_finished_screen_render_driver_positions_loop:
	push hl
	exx
		ld a,(hl)
		inc hl
		ld de,NAMTBL2+9+9*32
		ld bc,32
		ex de,hl
		or a
race_finished_screen_render_driver_positions_ptr_loop:
		jr z,race_finished_screen_render_driver_positions_ptr_loop_done
		add hl,bc
		dec a
		jr race_finished_screen_render_driver_positions_ptr_loop
race_finished_screen_render_driver_positions_ptr_loop_done:
		ex de,hl
		push de
	exx
	pop de	
	push ix
	pop hl	; hl has the driver name
	ld bc,16
	ld a,iyl
	or a
race_finished_screen_render_driver_positions_driver_name_loop:
	jr z,race_finished_screen_render_driver_positions_driver_name_loop_done
	add hl,bc
	dec a
	jr race_finished_screen_render_driver_positions_driver_name_loop
race_finished_screen_render_driver_positions_driver_name_loop_done:
	call fast_LDIRVM

	pop hl
	ld a,(hl)
	ld iyl,a
	inc hl
	dec iyh
	jr nz,race_finished_screen_render_driver_positions_loop
	ret

;-----------------------------------------------
; initializes the variables to start a new game from scratch
start_new_game:
	xor a
;-----------------------------------------------
; initializes the variables to start season "a"
season_screen_start_new_season:
	; reset season data:
	ld hl,ROM2RAM_gameStart
	ld de,game_progress_category
	ld bc,endOfROM2RAM_gameStart-ROM2RAM_gameStart
	ldir
	;ld a,1	; start in endurance
	;ld a,2	; start in f1
	ld (game_progress_category),a	; current season
	or a
	jr z,season_screen_start_new_season_start_next_season
	dec a
	jr z,standings_screen_end_of_season_start_endurance
standings_screen_end_of_season_start_f1:
	ld hl,CAR_DEFINITION_FOYOTA_MSX
	ld (game_progress_current_car),hl
	ld hl,100
	ld (game_progress_cash),hl
	jr season_screen_start_new_season_start_next_season
standings_screen_end_of_season_start_endurance:
	ld hl,CAR_DEFINITION_MATRA_530
	ld (game_progress_current_car),hl
	ld hl,10
	ld (game_progress_cash),hl
season_screen_start_new_season_start_next_season:
	call season_welcome_screen

;-----------------------------------------------
; going back to the season screen
season_screen:
	; check if season is over
	ld hl,max_races_stock
	ld a,(game_progress_category)
	ADD_HL_A
	ld b,(hl)
	ld a,(game_progress_race_number)
	cp b
	jp z,season_screen_season_over

	; check for the game over conditions (having the cheapest car, and not having money for the cheapest race):
	ld a,(game_progress_current_car)	; LSB of the current car pointer
	cp CAR_DEFINITION_ENIAK_100K%256
	jr z,season_screen_potential_game_over
	cp CAR_DEFINITION_MATRA_530%256
	jr z,season_screen_potential_game_over
	cp CAR_DEFINITION_FOYOTA_MSX%256
	jr z,season_screen_potential_game_over
	jr season_screen_no_game_over
season_screen_potential_game_over:
	ld hl,races_pletter
	ld de,menu_buffer
	call pletter_unpack_from_page0
	call races_screen_get_next_available_races
	ld ix,(menu_races_race_ptrs)	; get the first (cheapest) race
	ld b,0
	ld c,(ix+13)	; entry price
	ld hl,(game_progress_cash)
	xor a
	sbc hl,bc
	jp p,season_screen_no_game_over
	; we do not have enough money for the next race!
	jp gameover_screen
season_screen_no_game_over:

	call StopPlayingMusic
	call disable_VDP_output
    	;call clearScreen

    	; set the patterns:
	    ld hl,patterns_base_pletter
	    call decompressPatternsToVDPAllBanks
	    ld hl,patterns_patch_base_game_pletter
	    call applyPatternPatch
	    call decompressPatternsToVDPAllBanks_entry_point

back_to_season_screen_from_other_menus:
    	xor a
    	ld (menu_selected_option),a
    	ld (menu_cycle),a

back_to_season_screen_from_other_menus_do_not_reset_selection:
		ld a,(game_progress_category)
		or a
		jp z,season_screen_stock
		dec a
		jp z,season_screen_endurance
season_screen_f1:
		ld hl,rival_names_f1
		ld (game_progress_category_drivers_ptr),hl
		ld hl,CAR_DEFINITION_FOYOTA_MSX
		ld (game_progress_category_car_ptrs),hl
		ld hl,CAR_DEFINITION_LOLA_VG8020
		ld (game_progress_category_car_ptrs+2),hl
		ld hl,CAR_DEFINITION_PERRARI_Z80
		ld (game_progress_category_car_ptrs+4),hl
		jr season_screen_car_ptrs_set
season_screen_endurance:
		ld hl,rival_names_endurance
		ld (game_progress_category_drivers_ptr),hl
		ld hl,CAR_DEFINITION_MATRA_530
		ld (game_progress_category_car_ptrs),hl
		ld hl,CAR_DEFINITION_ASTRAN_CPC
		ld (game_progress_category_car_ptrs+2),hl
		ld hl,CAR_DEFINITION_PORCH_ZX81
		ld (game_progress_category_car_ptrs+4),hl
		jr season_screen_car_ptrs_set
season_screen_stock:
		ld hl,rival_names_stock
		ld (game_progress_category_drivers_ptr),hl
		ld hl,CAR_DEFINITION_ENIAK_100K
		ld (game_progress_category_car_ptrs),hl
		ld hl,CAR_DEFINITION_NAMCO_PONY
		ld (game_progress_category_car_ptrs+2),hl
		ld hl,CAR_DEFINITION_SIMCA_1000
		ld (game_progress_category_car_ptrs+4),hl
season_screen_car_ptrs_set:

    	; draw the season screen:
    	ld hl,season_screen_pletter
    	ld de,menu_buffer
    	call pletter_unpack
    	ld hl,menu_buffer
    	ld de,NAMTBL2
    	ld bc,768
    	halt
    	call fast_LDIRVM
		call clearAllTheSprites
    	
    	; call draw_agent_happy
    	call draw_agent_neutral
    	; call draw_agent_angry

    	call update_season_screen_data

	call enable_VDP_output	

	; AGENT SEASON MESSAGES:
	ld a,(game_progress_season_state)
	cp 2
	jr z,season_screen_agent_race_feedback
	or a
	jr nz,season_screen_loop
	call draw_agent_happy
	ld hl,game_progress_season_state
	ld (hl),1
	ld a,(game_progress_category)
	or a
	jr nz,season_screen_loop
;	dec a
;	jr z,season_screen_agent_welcome_endurance
;season_screen_agent_welcome_f1:
;	ld a,4
;	call draw_agent_text_character_by_character_press_space
;	jr season_screen_loop
;season_screen_agent_welcome_endurance:
;	ld a,3
;	call draw_agent_text_character_by_character_press_space
;	jr season_screen_loop
season_screen_agent_welcome_stock:
	xor a
	call draw_agent_text_character_by_character_press_space
	ld a,1
	call draw_agent_text_character_by_character_press_space
	ld a,2
	call draw_agent_text_character_by_character_press_space
	jr season_screen_loop

season_screen_agent_race_feedback_game_over:
	call draw_agent_angry
	ld a,9
	call draw_agent_text_character_by_character_press_space
	jp gameover_screen

season_screen_agent_race_feedback:
	ld hl,game_progress_season_state
	ld (hl),1	; reset to the normal state
	ld a,(game_progress_last_race_result)
	or a
	push af
	call z,draw_agent_happy
	pop af
	cp 3
	push af
	jr z,season_screen_agent_race_feedback_game_over
	pop af
	add a,6
	call draw_agent_text_character_by_character_press_space

season_screen_loop:
	halt

	; draw cursor:
	call season_screen_draw_cursor

	ld hl,menu_cycle
	inc (hl)

	call checkInput
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_UP_BIT,a
	jr nz,season_screen_pressed_up
	bit INPUT_DOWN_BIT,a
	jr nz,season_screen_pressed_down
	bit INPUT_RIGHT_BIT,a
	jr nz,season_screen_pressed_right
	bit INPUT_LEFT_BIT,a
	jr nz,season_screen_pressed_left
	bit INPUT_TRIGGER1_BIT,a
	jr nz,season_screen_pressed_fire
	jr season_screen_loop

season_screen_pressed_up:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call season_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	or a
	jr z,season_screen_loop
	cp 3
	jr z,season_screen_loop
	dec (hl)
	jr season_screen_loop

season_screen_pressed_down:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call season_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	cp 5
	jr z,season_screen_loop
	cp 2
	jr z,season_screen_loop
	inc (hl)
	jr season_screen_loop

season_screen_pressed_right:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call season_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	cp 3
	jp p,season_screen_loop
	inc (hl)
	inc (hl)
	inc (hl)
	jr season_screen_loop

season_screen_pressed_left:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call season_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	cp 3
	jp m,season_screen_loop
	dec (hl)
	dec (hl)
	dec (hl)
	jp season_screen_loop


season_screen_pressed_fire:
	ld hl,SFX_menu_select
	call play_SFX_with_high_priority

	ld a,(menu_selected_option)
	or a
	jp z,races_screen
	dec a
	jp z,talk_to_agent
	dec a
	jp z,carmarket_screen
	dec a
	jp z,standings_screen
	dec a
	jp z,options_screen
	dec a
	jr z,season_screen_quit
	jp season_screen_loop

season_screen_quit:
	call confirmation_dialogue
	or a
	jp z,splash_screen
	ld a,5
	ld (menu_selected_option),a
	jp back_to_season_screen_from_other_menus_do_not_reset_selection

talk_to_agent:
	ld a,(game_progress_last_agent_tip)
	cp 9
	jr z,talk_to_agent_angry
talk_to_agent_continue:
	add a,10
	call draw_agent_text_character_by_character_press_space

	ld hl,game_progress_last_agent_tip
	ld a,(hl)
	cp 9
	jp p,season_screen_loop
	inc (hl)
	jp season_screen_loop
talk_to_agent_angry:
	call draw_agent_angry
	ld a,(game_progress_last_agent_tip)
	jr talk_to_agent_continue


season_screen_draw_cursor_tbl:
	dw NAMTBL2+1+9*32
	dw NAMTBL2+1+11*32
	dw NAMTBL2+1+13*32
	dw NAMTBL2+17+9*32
	dw NAMTBL2+17+11*32
	dw NAMTBL2+17+13*32
season_screen_draw_cursor:
	ld a,(menu_selected_option)
	ld hl,season_screen_draw_cursor_tbl
season_screen_draw_cursor_entry_point:
	ld b,0
	ld c,a
	add hl,bc
	add hl,bc
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
season_screen_loop_cursor_ptr_done:
	ld a,(menu_cycle)
	bit 3,a
	jr z,season_screen_loop_cursor_off
season_screen_loop_cursor_on:
	ld a,62
	jr season_screen_loop_cursor_draw
season_screen_loop_cursor_off:
	xor a
season_screen_loop_cursor_draw:
	jp writeByteToVDP


;-----------------------------------------------
; redraws all the data in the season screen
update_season_screen_data:
	; category name:
	ld hl,category_stock
	ld a,(game_progress_category)
	ld b,0
	ld c,a
	add hl,bc
	add hl,bc
	add hl,bc
	add hl,bc
	add hl,bc	; hl = category_stock + (game_progress_category)*6
	ld de,NAMTBL2+5*32+11
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
	ld de,NAMTBL2+2*32+1
	ld bc,8
	push hl
	push bc
	call fast_LDIRVM
	pop bc
	pop hl
	add hl,bc
	ld de,NAMTBL2+3*32+1
	call fast_LDIRVM

	; races left:
	ld a,(game_progress_race_number)
	ld b,a
	ld hl,max_races_stock
	ld a,(game_progress_category)
	ADD_HL_A
	ld a,(hl)
	sub b
	add a,'0'
	ld hl,NAMTBL2+2*32+30
	call writeByteToVDP

	; cash:
	ld de,NAMTBL2+4*32+28
	ld hl,(game_progress_cash)
	call draw_right_aligned_16bit_number_to_vdp
	ld a,'$'
	push de
	pop hl
	call writeByteToVDP

	call calculate_current_standing
    ld de,NAMTBL2+5*32+29
	ld hl,menu_buffer
	jp scoreboard_update_position_entry_point


;-----------------------------------------------
; loads the car sprites appropriate for the current category
load_category_car_sprites:
	ld a,(game_progress_category)
	or a
	jr z,load_category_car_sprites_stock
	dec a
	jr z,load_category_car_sprites_endurance
	ld hl,f1_car_sprites_pletter
	jr load_category_car_sprites_load_car_sprites
load_category_car_sprites_stock:    
	ld hl,stock_car_sprites_pletter
	jr load_category_car_sprites_load_car_sprites
load_category_car_sprites_endurance:
	ld hl,endurance_car_sprites_pletter
load_category_car_sprites_load_car_sprites:
	jp load_car_sprites


;-----------------------------------------------
; brings up a confirmation dialogue
; return:
; - a = 0 if "yes"
; - a = 1 if "no"
confirmation_dialogue:
	ld a,1
	ld (menu_selected_option),a
	ld hl,confirmation_dialogue_pletter
	ld de,menu_buffer
	call pletter_unpack
	ld hl,menu_buffer
	ld de,NAMTBL2
	ld bc,32*4
	call fast_LDIRVM

confirmation_dialogue_loop:
	halt

	call confirmation_dialogue_draw_cursor

	ld hl,menu_cycle
	inc (hl)

	call checkInput
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_RIGHT_BIT,a
	jr nz,confirmation_dialogue_pressed_right
	bit INPUT_LEFT_BIT,a
	jr nz,confirmation_dialogue_pressed_right
	bit INPUT_TRIGGER1_BIT,a
	jr nz,confirmation_dialogue_pressed_fire
	jr confirmation_dialogue_loop
	ret

confirmation_dialogue_draw_cursor:
	ld a,(menu_selected_option)
	or a
	jr nz,confirmation_dialogue_loop_ptr_no
	ld hl,NAMTBL2+32+7
	jr confirmation_dialogue_loop_draw_cursor
confirmation_dialogue_loop_ptr_no:
	ld hl,NAMTBL2+32+21
confirmation_dialogue_loop_draw_cursor:
	jp season_screen_loop_cursor_ptr_done


confirmation_dialogue_pressed_right:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority
	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call confirmation_dialogue_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	inc a
	and #01
	ld (hl),a
	jr confirmation_dialogue_loop

confirmation_dialogue_pressed_fire:
	ld hl,SFX_menu_select
	call play_SFX_with_high_priority
	ld a,(menu_selected_option)
	ret


;-----------------------------------------------
; brings up a message dialogue
; intput:
; - hl: the message
; - bc: message length
message_dialogue:
	push hl
	push bc
	ld hl,message_dialogue_pletter
	ld de,menu_buffer
	call pletter_unpack
	ld hl,menu_buffer
	ld de,NAMTBL2
	ld bc,32*4
	call fast_LDIRVM
	pop bc
	pop hl
	ld de,NAMTBL2+1*32+4
	call fast_LDIRVM

message_dialogue_loop:
	halt

	call checkInput
	bit INPUT_TRIGGER1_BIT,a
	jr nz,message_dialogue_pressed_fire
	jr message_dialogue_loop
	ret

message_dialogue_pressed_fire:
	ld hl,SFX_menu_select
	jp play_SFX_with_high_priority



season_welcome_screen:
	call clearScreen
	call clearAllTheSprites

    ld hl,patterns_base_pletter
    call decompressPatternsToVDPAllBanks

	ld a,(game_progress_category)
	or a
	jr z,season_welcome_screen_stock
	dec a
	jr z,season_welcome_screen_endurance
season_welcome_screen_f1:
	ld hl,category_f1_welcome
	jr season_welcome_screen_print_welcome_message
season_welcome_screen_endurance:
	ld hl,category_endurance_welcome
	jr season_welcome_screen_print_welcome_message
season_welcome_screen_stock:
	ld hl,category_stock_welcome
season_welcome_screen_print_welcome_message:
	ld de,NAMTBL2+8*32+6
	ld bc,20
	call fast_LDIRVM
season_welcome_screen_loop:
	halt
	call checkInput
	bit INPUT_TRIGGER1_BIT,a
	ret nz
	jr season_welcome_screen_loop


;-----------------------------------------------
; we just get here when all the races of the current season have been completed
; we should just jump to a modified standings screen, and depending on whether the player won or not,
; move to the next season, game over, or show the game ending
season_screen_season_over:
	call clearScreen

	; set the patterns (since at this point they have not yet been set):
    ld hl,patterns_base_pletter
    call decompressPatternsToVDPAllBanks
    ld hl,patterns_patch_base_game_pletter
    call applyPatternPatch
    call decompressPatternsToVDPAllBanks_entry_point

	ld a,3
	ld (game_progress_season_state),a
	jp standings_screen


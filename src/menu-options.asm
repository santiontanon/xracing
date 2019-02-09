options_screen:
	; draw options:
	call refresh_options_screen
	ld hl,menu_selected_option
	ld (hl),4

options_screen_loop:
	halt

	; draw cursor:
	call season_screen_draw_cursor

	ld hl,menu_cycle
	inc (hl)

	call checkInput
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_UP_BIT,a
	jr nz,options_screen_pressed_up
	bit INPUT_DOWN_BIT,a
	jr nz,options_screen_pressed_down
	bit INPUT_RIGHT_BIT,a
	jr nz,options_screen_pressed_right
	bit INPUT_LEFT_BIT,a
	jr nz,options_screen_pressed_left	
	bit INPUT_TRIGGER1_BIT,a
	jr nz,options_screen_pressed_fire
	jr options_screen_loop

options_screen_pressed_up:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call season_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	or a
	jr z,options_screen_loop
	cp 3
	jr z,options_screen_loop
	dec (hl)
	jr options_screen_loop

options_screen_pressed_down:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call season_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	cp 4
	jr z,options_screen_loop
	cp 1
	jr z,options_screen_loop
	inc (hl)
	jr options_screen_loop

options_screen_pressed_right:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call season_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	cp 2
	jp p,options_screen_loop
	inc (hl)
	inc (hl)
	inc (hl)
	jr options_screen_loop

options_screen_pressed_left:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call season_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	cp 3
	jp m,options_screen_loop
	dec (hl)
	dec (hl)
	dec (hl)
	jp options_screen_loop

options_screen_pressed_fire:
	ld hl,SFX_menu_select
	call play_SFX_with_high_priority

	ld a,(menu_selected_option)
	or a
	jr z,options_screen_siwtch_gears
	dec a
	jr z,options_screen_sitch_music
	dec a
	dec a
	jr z,options_screen_sitch_other_sfx
	dec a
	jr z,options_screen_pressed_fire_go_back
	jp options_screen_loop

options_screen_pressed_fire_go_back:
	ld a,4
	ld (menu_selected_option),a
	jp back_to_season_screen_from_other_menus_do_not_reset_selection


options_screen_siwtch_gears:
	ld hl,global_options
	ld a,(hl)
	xor #01
options_screen_siwtch_gears_entry_point:
	ld (hl),a
	call refresh_options_screen
	jp options_screen_loop

options_screen_sitch_music:
	ld hl,global_options
	ld a,(hl)
	xor #02
	jr options_screen_siwtch_gears_entry_point

options_screen_sitch_other_sfx:
	ld hl,global_options
	ld a,(hl)
	xor #04
	jr options_screen_siwtch_gears_entry_point


; gears: auto/manual
; music: on/off
; engine sfx: on/off
; other sfx: on/off
; back
refresh_options_screen:
	ld a,(global_options)
	bit OPTIONS_BIT_GEARS,a
	jr z,refresh_options_screen_auto_gears
	ld hl,options_text_manual_gears
	jr refresh_options_screen_draw_gears
refresh_options_screen_auto_gears:
	ld hl,options_text_auto_gears
refresh_options_screen_draw_gears
	ld de,NAMTBL2+9*32+2
	ld bc,13
	call fast_LDIRVM

	ld a,(global_options)
	bit OPTIONS_BIT_MUSIC,a
	jr z,refresh_options_screen_music_on
	ld hl,options_text_music_off
	jr refresh_options_screen_draw_music
refresh_options_screen_music_on:
	ld hl,options_text_music_on
refresh_options_screen_draw_music
	ld de,NAMTBL2+11*32+2
	ld bc,13
	call fast_LDIRVM

;	ld a,(global_options)
;	bit OPTIONS_BIT_ENGINE_SFX,a
;	jr z,refresh_options_screen_engine_sfx_on
;	ld hl,options_text_engine_sfx_off
;	jr refresh_options_screen_draw_engine_sfx
;refresh_options_screen_engine_sfx_on:
;	ld hl,options_text_engine_sfx_on
;refresh_options_screen_draw_engine_sfx
;	ld de,NAMTBL2+13*32+2
;	ld bc,13
;	call fast_LDIRVM

	ld a,(global_options)
	bit OPTIONS_BIT_OTHER_SFX,a
	jr z,refresh_options_screen_other_sfx_on
	ld hl,options_text_other_sfx_off
	jr refresh_options_screen_draw_other_sfx
refresh_options_screen_other_sfx_on:
	ld hl,options_text_other_sfx_on
refresh_options_screen_draw_other_sfx
	ld de,NAMTBL2+9*32+18
	ld bc,13
	call fast_LDIRVM

	ld hl,options_text_back
	ld de,NAMTBL2+11*32+18
	ld bc,13
	call fast_LDIRVM

	ld hl,NAMTBL2+13*32+2
	ld a,' '
	ld bc,20
	jp FILVRM


;-----------------------------------------------
; shows the "BRAIN  GAMES" splash screen at the beginning of the game
splash_screen_sprite:
	db 10*8-4, 0, 4, 1   ; player car        (red)
    db 10*8-4, 0, 8, COLOR_RED

splash_screen:
	; load the necessary tiles and sprites:	
	call disable_VDP_output
		call clearScreen
		call clearAllTheSprites
		call StopPlayingMusic

	    ld hl,patterns_base_pletter
	    call decompressPatternsToVDP3rdBank
	    ld hl,patterns_patch_base_title_pletter
	    call applyPatternPatch
	    call decompressPatternsToVDPAllBanks_entry_point

		ld hl,endurance_car_sprites_pletter
		call load_car_sprites
	
		ld hl,SPRTBL2+32
		ld de,car_sprite_patterns_buffer
		call loadDoubleSpriteToVDP
	call enable_VDP_output

	; set up the car sprite
	ld hl,splash_screen_sprite
	ld de,sprite_attributes_buffer
	ld bc,8
	ldir

	; ld hl,sprite_attributes_buffer
	; ld (hl),10*8-4
	; ld hl,sprite_attributes_buffer+4
	; ld (hl),10*8-4

	ld bc,0
splash_screen_loop:
	halt

	; check for space/trigger A pressed:
	push bc
	call checkInput
	pop bc
	ld a,(player_input_buffer+2)	; new keys pressed
	bit INPUT_TRIGGER1_BIT,a
	jp nz,splash_screen_done

	push bc	
	; make the letters of brain games appear:
	ld a,c
	srl a
	cp 10
	jp m,splash_screen_loop_state0
	cp 22
	jp p,splash_screen_loop_state2
splash_screen_loop_state1:	; brain games letters appearing!
	push af
	ld hl,NAMTBL2+10*32
	;ADD_HL_A
	add a,l
	ld l,a
	pop af
	push hl
	ld hl,message_brain_games
	sub 10
	ADD_HL_A
	ld a,(hl)	; letter to draw
	pop hl
	call writeByteToVDP
splash_screen_loop_state0:	; too early for brain games letters
splash_screen_loop_state2:	; brain games letters already there
	pop bc

	push bc
	ld a,c
	cp 20
	jr nz,splash_screen_loop_nosfx
	push af
	ld hl,SFX_lap
	call play_SFX_with_high_priority
	pop af
splash_screen_loop_nosfx:
	cp 64
	jp m,splash_screen_loop_sprite_state0
splash_screen_loop_sprite_state1:	; we are done with the car
	ld a,200
	ld (sprite_attributes_buffer),a
	ld (sprite_attributes_buffer+4),a
	jr splash_screen_loop_draw_sprite
splash_screen_loop_sprite_state0: ; car appearing
	sla a
	sla a
	ld (sprite_attributes_buffer+1),a
	ld (sprite_attributes_buffer+4+1),a
splash_screen_loop_draw_sprite:
	; car sprite:
	ld hl,sprite_attributes_buffer
	ld de,SPRATR2
	ld bc,8
	call fast_LDIRVM
	pop bc

	inc bc
	ld a,b
	or a
	jp z,splash_screen_loop
splash_screen_done:
	jp title_screen


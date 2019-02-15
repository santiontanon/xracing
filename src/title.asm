
title_screen:
	call disable_VDP_output
		call clearAllTheSprites
    	call clearScreen

		ld hl,title_data_pletter
		ld de,title_buffer
		call pletter_unpack
		;call render_title_screen

		; setup the title sprites:
		ld hl,title_buffer+32*6+19*4
		ld de,SPRTBL2
		ld bc,19*32
		call fast_LDIRVM

		; change the numbers to yellow:
		ld a,#a0
		ld hl,CLRTBL2+256*8*2+48*8
		ld bc,10*8
		call FILVRM

		; setup flag animation:
		call unpack_flag_patterns_to_VDP
		ld hl,flag_nametables_pletter
		ld de,title_buffer_flag
		call pletter_unpack
	call enable_VDP_output

	ld hl,title_song_pletter
    ld de,music_buffer
    call pletter_unpack_from_page0
    ld a,5
    call play_song


	; scroll the flag from the right:
	xor a
title_screen_loop1:
	halt
	; get the right flag frame:
	push af
	sra a
	call render_flag_get_current_frame_ptr
	pop af

	; render part of the flag:
	; bc = a+1
	ld b,0
	ld c,a
	inc c
	; de = NAMTBL2+31-a
	push af
	neg
	add a,31
	ld de,NAMTBL2
	push hl
	ld h,0
	ld l,a
	add hl,de
	ex de,hl
	pop hl
	pop af

	push af
	ld a,23
title_screen_loop1_loop:
	push af
	push bc
	push hl
	push de
	call fast_LDIRVM
	pop hl
	ld bc,32
	add hl,bc
	ex de,hl
	pop hl
	add hl,bc
	pop bc
	pop af
	dec a
	jr nz,title_screen_loop1_loop
	pop af

	inc a
	cp 31
	jr nz,title_screen_loop1

	; wave the flag for a bit (from a = 31 to a = 64)
title_screen_loop2:
	halt
	push af
	sra a
	call render_flag_get_current_frame_ptr
	; render the whole flag:
	ld de,NAMTBL2
	ld bc,23*32
	call fast_LDIRVM
	pop af

	inc a
	cp 64
	jr nz,title_screen_loop2

	; bring the game logo down
	xor a
title_screen_loop3:
	push af
		sra a
		call render_flag_get_current_frame_ptr
	pop af
	push af
		push hl
		ld iyl,a
		sra a
		ld e,a	; we save a
		cp 6
		jp m,title_screen_loop3_partial_logo
		; here a is 6 or more
		sub 6
		ld bc,32
		or a
		jp z,title_screen_loop3_loop1_done
title_screen_loop3_loop1:
		add hl,bc
		dec a
		jp nz,title_screen_loop3_loop1
title_screen_loop3_loop1_done:
		ld a,6
title_screen_loop3_partial_logo:
		push af
			push hl
			call save_flag_frame_to_temporary_buffer
			pop hl
			push hl
			pop ix
		pop af
		call render_title_onto_flag_frame
		halt

		; title sprites
		ld a,iyl
		bit 0,a
		jp nz,title_screen_loop3_skip_sprites
		ld hl,title_buffer+6*32
		ld de,SPRATR2
		ld bc,15*4
		call fast_LDIRVM
		call move_title_sprites_8_pixels_down
title_screen_loop3_skip_sprites:

		; render the whole thing:
		pop hl
		ld de,NAMTBL2
		ld bc,23*32
		call fast_LDIRVM
		push ix
		pop de
		call restore_flag_frame_from_temporary_buffer
	pop af

	inc a
	cp 13*2
	jr nz,title_screen_loop3


	; draw "brain games" at the bottom, and the sprites one last time
	push af
		ld hl,message_santi
		ld de,NAMTBL2+23*32
		ld bc,32
		call fast_LDIRVM
		ld hl,title_buffer+6*32
		ld de,SPRATR2
		ld bc,15*4
		call fast_LDIRVM
	pop af


	; final loop, with all the title finally rendered:
title_screen_loop4:
	push af
		sra a
		call render_flag_get_current_frame_ptr
		push hl
		ld bc,7*32
		add hl,bc
		push hl
		call save_flag_frame_to_temporary_buffer
		pop hl
		push hl
		pop ix
		ld a,6
		call render_title_onto_flag_frame
		pop hl
		halt
		; render the whole thing:
		ld de,NAMTBL2
		ld bc,23*32
		call fast_LDIRVM
		push ix
		pop de
		call restore_flag_frame_from_temporary_buffer
	pop af
	bit 4,a
	push af
		call nz,title_draw_press_space
	pop af
	push af
		call z,title_remove_press_space_sprites
		; check for space/trigger A pressed:
		call checkInput
	pop af
	ld hl,player_input_buffer+2	; new keys pressed
	ld c,(hl)
	bit INPUT_TRIGGER1_BIT,c
	jp nz,title_screen_loop5_start
	inc a	
	jr title_screen_loop4


	; space has been pressed:
title_screen_loop5_start:

	push af
	ld hl,gamestart_song_pletter
    ld de,music_buffer
    call pletter_unpack
    ld a,24
    call play_song
    pop af

	ld b,128
title_screen_loop5:
	push bc
	push af
		sra a
		call render_flag_get_current_frame_ptr
		push hl
		ld bc,7*32
		add hl,bc
		push hl
		call save_flag_frame_to_temporary_buffer
		pop hl
		push hl
		pop ix
		ld a,6
		call render_title_onto_flag_frame
		pop hl
		halt
		; render the whole thing:
		ld de,NAMTBL2
		ld bc,23*32
		call fast_LDIRVM
		push ix
		pop de
		call restore_flag_frame_from_temporary_buffer
	pop af
	bit 2,a
	push af
		call nz,title_draw_press_space
	pop af
	push af
		call z,title_remove_press_space_sprites
		; check for space/trigger A pressed:
	pop af
	pop bc
	dec b
	jp z,start_new_game
	inc a	
	jr title_screen_loop5


move_title_sprites_8_pixels_down:
	ld hl,title_buffer+6*32
	ld a,15
move_title_sprites_8_pixels_down_loop:
	push af
	ld a,(hl)
	add a,8
	ld (hl),a
	inc hl
	inc hl
	inc hl
	inc hl
	pop af
	dec a
	jp nz,move_title_sprites_8_pixels_down_loop
	ret


title_remove_press_space_sprites:
	; sprites: set the color of sprites 15, 16, 17 and 18 to 0
    xor a
    ld (title_buffer+6*32+15*4+3),a
    ld (title_buffer+6*32+16*4+3),a
    ld (title_buffer+6*32+17*4+3),a
    ld (title_buffer+6*32+18*4+3),a
	ld hl,title_buffer+6*32+15*4
	ld de,SPRATR2+15*4
	ld bc,4*4
	jp fast_LDIRVM


title_draw_press_space:
	; render the tiles:
	ld hl,message_press_space
	ld de,NAMTBL2+16*32+10
	ld bc,5
	push bc
	call fast_LDIRVM
	ld hl,message_press_space+7
	ld de,NAMTBL2+16*32+17
	pop bc
	call fast_LDIRVM

	; sprites: set the color of sprites 15, 16, 17, and 18 to 1
    ld a,1
    ld (title_buffer+6*32+15*4+3),a
    ld (title_buffer+6*32+16*4+3),a
    ld (title_buffer+6*32+17*4+3),a
    ld (title_buffer+6*32+18*4+3),a
	ld hl,title_buffer+6*32+15*4
	ld de,SPRATR2+15*4
	ld bc,4*4
	jp fast_LDIRVM


;-----------------------------------------------
; gets the flag animation pointer to the frame indicated by A
render_flag_get_current_frame_ptr:
	and #0f
	ld hl,title_buffer_flag
	ld bc,23*32
	or a
	ret z
render_flag_get_current_frame_ptr_loop:
	add hl,bc
	dec a
	jr nz,render_flag_get_current_frame_ptr_loop
	ret


;-----------------------------------------------
; unpacks the flag animation patterns to their corresponding places in the VDP
unpack_flag_patterns_to_VDP:
	ld hl,flag_patterns_pletter
	ld de,title_buffer_flag
	call pletter_unpack

	ld hl,title_buffer_flag
	ld de,CHRTBL2+112*8
	ld bc,144*8
	push bc
	call fast_LDIRVM
;	ld hl,title_buffer_flag+144*8
;	ld de,CLRTBL2+112*8
;	pop bc
;	push bc
;	call fast_LDIRVM

	ld hl,title_buffer_flag+144*8
	ld de,CHRTBL2+256*8 + 112*8
	pop bc
	push bc
	call fast_LDIRVM
;	ld hl,title_buffer_flag+144*8*3
;	ld de,CLRTBL2+256*8 + 112*8
;	pop bc
;	push bc
;	call fast_LDIRVM

	ld hl,title_buffer_flag+144*8*2
	ld de,CHRTBL2+256*8*2 + 112*8
	pop bc
;	push bc
	call fast_LDIRVM
;	ld hl,title_buffer_flag+144*8*5
;	ld de,CLRTBL2+256*8*2 + 112*8
;	pop bc
;	jp fast_LDIRVM
	ld hl,CLRTBL2+112*8
	ld bc,144*8
	ld a,#0f
	push bc
	call FILVRM
	pop bc
	ld hl,CLRTBL2+256*8 + 112*8
	ld a,#0f
	push bc
	call FILVRM
	pop bc
	ld hl,CLRTBL2+256*8*2 + 112*8
	ld a,#0f
	jp FILVRM


;-----------------------------------------------
; routines to render the title on top of the flag
; - hl: position from where to start saving
save_flag_frame_to_temporary_buffer:
	ld de,title_buffer_flag+16*23*32
	ld bc,6*32
	ldir
	ret


; - de: position to restore to
restore_flag_frame_from_temporary_buffer:
	ld hl,title_buffer_flag+16*23*32
	ld bc,6*32
	ldir
	ret


; hl: position to start rendering
; a: n lines
render_title_onto_flag_frame:
	or a
	ret z
	push hl
	push af
	neg
	add a,6
	ld de,32
	ld hl,title_buffer
	or a
	jp z,render_title_onto_flag_frame_loop_done
render_title_onto_flag_frame_loop:
	add hl,de
	dec a
	jr nz,render_title_onto_flag_frame_loop
render_title_onto_flag_frame_loop_done:
	; hl now has the pointer to the start of the title from were we want to render
	pop af
	ld c,a	; render "c" lines
	pop de ; de now has the positino to render to

render_title_onto_flag_frame_loop2:
	ld b,32	
render_title_onto_flag_frame_loop3:
	ld a,(hl)
	or a
	jp z,render_title_onto_flag_frame_loop3_skip
	ld (de),a
render_title_onto_flag_frame_loop3_skip:
	inc hl
	inc de
	dec b
	jp nz,render_title_onto_flag_frame_loop3
	dec c
	jp nz,render_title_onto_flag_frame_loop2
	ret



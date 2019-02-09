ending_screen:
	call clearScreen
	call clearAllTheSprites
    ld hl,patterns_base_pletter
    call decompressPatternsToVDPAllBanks

	; 1) set up patterns (only in the second bank):
	; - clear 96-160 (these will contain a duplicate of the text)
	ld hl,CHRTBL2+256*8+96*8
	ld bc,64*8
	xor a
	call FILVRM
	ld hl,CLRTBL2+256*8+32*8
	ld de,menu_buffer2a
	ld bc,64*8
	call LDIRMV	; get the attributes of the letters
	ld hl,menu_buffer2a
	ld de,CLRTBL2+256*8+96*8
	ld bc,64*8
	call fast_LDIRVM	; copy them to a second set of characters for smooth text scrolling
	ld hl,NAMTBL2+256
	ld bc,256
	ld a,96
	call FILVRM	; set everything to "spaces" in the second text bank
	; 2) load the ending data:
	ld hl,ending_data_pletter
	ld de,menu_buffer2a
	call pletter_unpack_from_page0
	; - load the ending graphics into 160-204
	ld hl,menu_buffer2a
	ld de,CHRTBL2+256*8+160*8
	ld bc,48*8
	call fast_LDIRVM
	ld hl,CLRTBL2+256*8+160*8
	ld bc,48*8
	xor a
	call FILVRM

	ld hl,ending_song_pletter
    ld de,music_buffer
    call pletter_unpack_from_page0
    ld a,(isComputer50HzOr60Hz)
    add a,7 ; so, a = 7 when 50Hz and a = 8 when 60Hz
    call play_song


	call ending_screen_fade_images_in
	
	; 3) text scroll:
	ld b,24
	ld hl,menu_buffer2a+48*8*2	; next sentence to write
ending_screen_loop3:
	push bc
	push hl
		call ending_screen_write_next_sentence_plus64_to_bottom_line
		ld b,8
ending_screen_loop1:
		push bc
		call ending_screen_move_text_1pixel_to_B
		pop bc
		djnz ending_screen_loop1

		call ending_screen_set_up_for_B_to_A

		ld b,8
ending_screen_loop2:
		push bc
		call ending_screen_move_text_1pixel_to_A
		pop bc
		djnz ending_screen_loop2
		call ending_screen_set_up_for_A_to_B
	pop hl
	ld bc,20
	add hl,bc
	pop bc
	djnz ending_screen_loop3

	call ending_screen_fade_images_out

	jp splash_screen


ending_screen_write_next_sentence_plus64_to_bottom_line:
	push hl
		ld hl,NAMTBL2+(8+7)*32+6
		call SETWRT
	pop hl
	ld b,20
    ld a,(VDP.DW)
    ld c,a
ending_screen_write_next_sentence_plus64_to_bottom_line_loop:
	ld a,(hl)
	add a,64
    out (c),a
    inc hl
    djnz ending_screen_write_next_sentence_plus64_to_bottom_line_loop
	ret


ending_screen_move_text_1pixel_to_B:
	; get the state of the A and B banks of letters
	ld hl,CHRTBL2+256*8+32*8
	ld de,menu_buffer
	ld bc,128*8
	call LDIRMV
	; scroll 1 pixel up
	ld de,menu_buffer+64*8
	ld hl,menu_buffer+64*8+1
	ld b,64
	ld iy,-65*8
ending_screen_move_text_1pixel_to_B_loop:
	push bc
	push hl
	push de
		ld bc,7
		ldir

		push iy
		pop bc
		add hl,bc
		
		ldi

		push iy
		pop bc
		ex de,hl
		add hl,bc
		ex de,hl
		ld bc,7
		ldir

		xor a
		ld (de),a
	ld bc,8
	pop hl
	add hl,bc
	ex de,hl
	pop hl
	add hl,bc
	pop bc
	djnz ending_screen_move_text_1pixel_to_B_loop

	; copy them back to the VDP:
	ld hl,menu_buffer
	ld de,CHRTBL2+256*8+32*8
	ld bc,128*8
	halt
	halt
	halt
	halt
	jp fast_LDIRVM


ending_screen_move_text_1pixel_to_A:
	; get the state of the A and B banks of letters
	ld hl,CHRTBL2+256*8+32*8
	ld de,menu_buffer
	ld bc,128*8
	call LDIRMV
	; scroll 1 pixel up
	ld de,menu_buffer
	ld hl,menu_buffer+1
	ld b,64
	ld iy,63*8
	jr ending_screen_move_text_1pixel_to_B_loop


ending_screen_set_up_for_B_to_A:
	ld hl,NAMTBL2+256
	ld de,menu_buffer
	ld bc,256
	call LDIRMV
	ld de,menu_buffer+6
	ld hl,menu_buffer+6+32
	ld b,4
	ld c,-64
ending_screen_set_up_for_B_to_A_loop2:
	push bc
	ld b,20
ending_screen_set_up_for_B_to_A_loop1:
	ld a,(hl)
	add a,c
	ld (de),a
	inc hl
	inc de
	djnz ending_screen_set_up_for_B_to_A_loop1
	ld bc,44
	ex de,hl
	add hl,bc
	ex de,hl
	add hl,bc
	pop bc
	djnz ending_screen_set_up_for_B_to_A_loop2
	ld hl,menu_buffer
	ld de,NAMTBL2+256
	ld bc,256
	call fast_LDIRVM
	ret


ending_screen_set_up_for_A_to_B:
	ld hl,NAMTBL2+256
	ld de,menu_buffer
	ld bc,256
	call LDIRMV
	ld de,menu_buffer+6+32
	ld hl,menu_buffer+6+64
	ld b,3
	ld c,64
	jr ending_screen_set_up_for_B_to_A_loop2


;ending_screen_image1:
;	db 160,161,162,163
;   db 164,165,166,167
; ...
;   db 180,181,182,183 


ending_screen_fade_images_in:
	ld hl,NAMTBL2+256+32+1
	ld a,160
	ld b,6
ending_screen_fade_images_in_img1_loop2:
	push bc
	ld b,4
ending_screen_fade_images_in_img1_loop1:
	push bc
	push af
	push hl
	call writeByteToVDP
	pop hl
	pop af
	pop bc
	inc hl
	inc a
	djnz ending_screen_fade_images_in_img1_loop1
	ld bc,32-4
	add hl,bc
	pop bc
	djnz ending_screen_fade_images_in_img1_loop2

	ld hl,NAMTBL2+256+32*2+6+20
	ld a,184
	ld b,4
ending_screen_fade_images_in_img2_loop2:
	push bc
	ld b,6
ending_screen_fade_images_in_img2_loop1:
	push bc
	push af
	push hl
	call writeByteToVDP
	pop hl
	pop af
	pop bc
	inc hl
	inc a
	djnz ending_screen_fade_images_in_img2_loop1
	ld bc,32-6
	add hl,bc
	pop bc
	djnz ending_screen_fade_images_in_img2_loop2

	; fade in the images
ending_screen_fade_images_out_entry_point:
	ld b,8
	ld hl,menu_buffer2a+48*8
	ld de,CLRTBL2+256*8+160*8
ending_screen_fade_images_in_loop1:
	push bc
	push hl
	push de
	ld b,48
ending_screen_fade_images_in_loop2:
	push bc
	ld a,(hl)
	push hl
	push de
	push de
	pop hl
	call writeByteToVDP
	ld bc,8
	pop hl
	add hl,bc
	ex de,hl
	pop hl
	add hl,bc
	pop bc
	djnz ending_screen_fade_images_in_loop2
	pop de
	pop hl
	pop bc
	inc hl
	inc de
	ld a,8
ending_screen_fade_images_in_halt_loop:
	halt
	dec a
	jr nz,ending_screen_fade_images_in_halt_loop
	djnz ending_screen_fade_images_in_loop1

	ret


ending_screen_fade_images_out:
	ld hl,menu_buffer2a+48*8
	ld de,menu_buffer2a+48*8+1
	xor a
	ld (hl),a
	ld bc,48*8-1
	ldir
	jr ending_screen_fade_images_out_entry_point

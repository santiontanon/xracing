;-----------------------------------------------
; these functions render the face of the agent, assuming we start from the "neutral" baseline (without sprites)
draw_agent_happy:
	ld hl,agent_sprites_pletter
	ld de,menu_agent_data_buffer
	call pletter_unpack

	; render happy tiles:
	ld hl,menu_agent_data_buffer+128+8
	ld de,NAMTBL2+3+20*32
	ld bc,2
	call fast_LDIRVM

	; add sprites:
	ld hl,menu_agent_data_buffer
	ld de,SPRTBL2
	ld bc,64
draw_agent_happy_entry_point:
	call fast_LDIRVM

	ld hl,menu_agent_data_buffer+32*4
	ld de,SPRATR2
	ld bc,8
	jp fast_LDIRVM

draw_agent_neutral:
	ld hl,agent_sprites_pletter
	ld de,menu_agent_data_buffer
	call pletter_unpack

	; add sprites:
	ld hl,menu_agent_data_buffer
	ld de,SPRTBL2
	ld bc,32
	call fast_LDIRVM

	ld hl,menu_agent_data_buffer+64
	ld de,SPRTBL2+32
	ld bc,32
	jr draw_agent_happy_entry_point

draw_agent_angry:
	ld hl,agent_sprites_pletter
	ld de,menu_agent_data_buffer
	call pletter_unpack

	; render angry tiles:
	ld hl,menu_agent_data_buffer+128+8+2
	ld de,NAMTBL2+3+19*32
	ld bc,2
	call fast_LDIRVM
	ld hl,menu_agent_data_buffer+128+8+4
	ld de,NAMTBL2+3+20*32
	ld bc,2
	call fast_LDIRVM

	; add sprites:
	ld hl,menu_agent_data_buffer
	ld de,SPRTBL2
	ld bc,32
	call fast_LDIRVM

	ld hl,menu_agent_data_buffer+96
	ld de,SPRTBL2+32
	ld bc,32
	jr draw_agent_happy_entry_point


;-----------------------------------------------
; This function shows text by the agent character by character, into the designated agent text area,
; and then waits until the player presses space
draw_agent_text_character_by_character_press_space:
	call draw_agent_text_character_by_character
draw_agent_text_character_by_character_press_space_loop:
	halt
	inc b
	bit 3,b
	push bc
	jr z,draw_agent_text_character_by_character_press_space_draw_space
	call draw_agent_text_character_by_character_press_space_remove_space
draw_agent_text_character_by_character_press_space_loop_continue:
	call checkInput
	pop bc
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_TRIGGER1_BIT,a
	jr z,draw_agent_text_character_by_character_press_space_loop
    xor a
    ld bc,24
    ld hl,NAMTBL2+7+18*32
    call FILVRM
    xor a
    ld bc,24
    ld hl,NAMTBL2+7+19*32
    call FILVRM
    xor a
    ld bc,24
    ld hl,NAMTBL2+7+20*32
    call FILVRM
draw_agent_text_character_by_character_press_space_remove_space:
    xor a
    ld bc,24
    ld hl,NAMTBL2+7+21*32
    jp FILVRM
draw_agent_text_character_by_character_press_space_draw_space
	ld hl,message_press_space
	ld de,NAMTBL2+13+21*32
	ld bc,12
	call fast_LDIRVM
	jr draw_agent_text_character_by_character_press_space_loop_continue


;-----------------------------------------------
; This function shows text by the agent character by character, into the designated agent text area
; input: "a" message index
draw_agent_text_character_by_character:
	ld hl,menu_agent_fast_text_skip
	ld (hl),0
	ld hl,agent_texts_pletter
	ld de,menu_agent_data_buffer
	push af
	call pletter_unpack_from_page0
	pop af
	ld hl,menu_agent_data_buffer
	ld bc,24*3
	or a
	jr z,draw_agent_text_character_by_character_message_ptr_done
draw_agent_text_character_by_character_message_ptr_loop:
	add hl,bc
	dec a
	jr nz,draw_agent_text_character_by_character_message_ptr_loop
draw_agent_text_character_by_character_message_ptr_done:
	ex de,hl
	ld hl,NAMTBL2+7+18*32
	ld b,3
draw_agent_text_character_by_character_message_loop2:
	push bc
	ld b,24
draw_agent_text_character_by_character_message_loop:
	ld a,(de)
	push hl
	push de
	push bc
	call writeByteToVDP
	call checkInput
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_TRIGGER1_BIT,a
	jr z,draw_agent_text_character_by_character_message_no_space
	ld hl,menu_agent_fast_text_skip
	ld (hl),1
draw_agent_text_character_by_character_message_no_space:
	pop bc
	pop de
	ld a,(de)
	cp ' '
	ld hl,SFX_agent_text
	call nz,play_SFX_with_high_priority
	pop hl
	inc hl
	inc de

	; if space is pressed, skip halt
	ld a,(menu_agent_fast_text_skip)
	or a
	jr nz,draw_agent_text_character_by_character_message_skip_halt
	halt
draw_agent_text_character_by_character_message_skip_halt
	djnz draw_agent_text_character_by_character_message_loop
	ld bc,32-24
	add hl,bc
	pop bc
	djnz draw_agent_text_character_by_character_message_loop2
	ret


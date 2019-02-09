carmarket_screen:
	call disable_VDP_output
		call clearAllTheSprites
    	;call clearScreen
    	
    	; load the appropriate car sprites:
    	call load_category_car_sprites

    	; draw the car market screen:
    	ld hl,carmarket_screen_pletter
    	ld de,menu_buffer
    	call pletter_unpack
    	ld hl,menu_buffer
    	ld de,NAMTBL2
    	ld bc,768-64
    	call fast_LDIRVM

    	call update_carmarket_screen_data

    	xor a
    	ld (menu_cycle),a
    	ld a,3
    	ld (menu_selected_option),a
	call enable_VDP_output	

carmarket_screen_loop:
	halt

	; draw cursor:
	call carmarket_screen_draw_cursor

	ld hl,menu_cycle
	inc (hl)

	call checkInput
	ld a,(player_input_buffer+2) ; new keys pressed
	bit INPUT_UP_BIT,a
	jr nz,carmarket_screen_pressed_up
	bit INPUT_DOWN_BIT,a
	jr nz,carmarket_screen_pressed_down
	bit INPUT_TRIGGER1_BIT,a
	jr nz,carmarket_screen_pressed_fire
	jr carmarket_screen_loop


carmarket_screen_pressed_up:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call carmarket_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	or a
	jr z,carmarket_screen_loop
	dec (hl)
	jr carmarket_screen_loop

carmarket_screen_pressed_down:
	ld hl,SFX_menu_switch
	call play_SFX_with_high_priority

	ld a,7	; 7 since, the cursor is off 0 - 7, and on 8 - 15, so it is cleared, and drawn immediately in the next frame
	ld (menu_cycle),a
	call carmarket_screen_draw_cursor	; clear the current cursor
	ld hl,menu_selected_option
	ld a,(hl)
	cp 3
	jr z,carmarket_screen_loop
	inc (hl)
	jr carmarket_screen_loop

carmarket_screen_pressed_fire:
	ld hl,SFX_menu_select
	call play_SFX_with_high_priority

	ld a,(menu_selected_option)
	or a
	jr z, carmarket_screen_select_car1
	dec a
	jr z, carmarket_screen_select_car2
	dec a
	jr z, carmarket_screen_select_car3
	dec a
	jr z,carmarket_screen_select_back
	jp carmarket_screen_loop

carmarket_screen_select_back:
	ld a,(game_progress_current_car)
	cp NO_CAR%256
	jr nz,carmarket_screen_select_back_with_car
	ld hl,carmarket_text_need_to_own_a_car
	ld bc,25
	call message_dialogue
	jp carmarket_screen

carmarket_screen_select_back_with_car:
	ld a,2
	ld (menu_selected_option),a
	jp back_to_season_screen_from_other_menus_do_not_reset_selection


carmarket_screen_select_car1:
	ld hl,(game_progress_category_car_ptrs)
	jr carmarket_screen_select_car

carmarket_screen_select_car2:
	ld hl,(game_progress_category_car_ptrs+2)
	jr carmarket_screen_select_car

carmarket_screen_select_car3:
	ld hl,(game_progress_category_car_ptrs+4)
carmarket_screen_select_car:
	ld a,(game_progress_current_car)	; lsb of the current car
	cp l
	jr z,carmarket_screen_sell_car

carmarket_screen_buy_car:
	push hl
	pop ix
	ld a,(ix+19)	; price of the car
	ld de,10
	call Mul8
	ld de,(game_progress_cash)
	ex de,hl	; hl = cash, de = car cost
    xor a
    sbc hl,de
    jp p,carmarket_screen_buy_car_enough_cash
	ld hl,carmarket_text_not_enough_cash
	ld bc,16
	call message_dialogue
	jp carmarket_screen
carmarket_screen_buy_car_enough_cash:
	push hl
	push ix
	call confirmation_dialogue
	pop ix
	pop hl
	or a
	jp nz,carmarket_screen
	ld (game_progress_cash),hl
	ld (game_progress_current_car),ix
	jp carmarket_screen

carmarket_screen_sell_car:
	call confirmation_dialogue
	or a
	jp nz,carmarket_screen
	; - get cash back, and clear the current car
	ld ix,(game_progress_current_car)
	ld a,(ix+19)	; price of the car
	ld de,10
	call Mul8
	ld bc,(game_progress_cash)
	add hl,bc
	ld (game_progress_cash),hl
	ld hl,NO_CAR	; a value that for sure does not correspond to any car
	ld (game_progress_current_car),hl	; clear the car you own
	jp carmarket_screen


carmarket_screen_draw_cursor_tbl:
	dw NAMTBL2+1+2*32
	dw NAMTBL2+1+8*32
	dw NAMTBL2+1+14*32
	dw NAMTBL2+1+21*32
carmarket_screen_draw_cursor:
	ld a,(menu_selected_option)
	ld hl,carmarket_screen_draw_cursor_tbl
	jp season_screen_draw_cursor_entry_point


update_carmarket_screen_data:
	; render cash:
	; cash:
	ld de,NAMTBL2+0*32+28
	ld hl,(game_progress_cash)
	call draw_right_aligned_16bit_number_to_vdp
	ld a,'$'
	push de
	pop hl
	call writeByteToVDP

	; car sprites:
    ;db COLOR_RED        ; car sprite color  (+24)
    ld hl,car_sprite_patterns_buffer
    ld de,SPRTBL2
    ld bc,64
    call fast_LDIRVM

    ld hl,carmarket_screen_sprites
	ld de,SPRATR2
	ld bc,8*3
	call fast_LDIRVM

	; render cars:
	; car 1:
	ld hl,(game_progress_category_car_ptrs)
	push hl
	ld de,NAMTBL2+2*32+6
	call update_carmarket_car_data
	pop hl
	ld bc,24
	add hl,bc
	ld a,(hl)
	ld hl,SPRATR2+7
	call writeByteToVDP

	; car 2:
	ld hl,(game_progress_category_car_ptrs+2)
	push hl
	ld de,NAMTBL2+8*32+6
	call update_carmarket_car_data
	pop hl
	ld bc,24
	add hl,bc
	ld a,(hl)
	ld hl,SPRATR2+8+7
	call writeByteToVDP

	; car 3:
	ld hl,(game_progress_category_car_ptrs+4)
	push hl
	ld de,NAMTBL2+14*32+6
	call update_carmarket_car_data
	pop hl
	ld bc,24
	add hl,bc
	ld a,(hl)
	ld hl,SPRATR2+8+8+7
	call writeByteToVDP
	
	; render "sell" and "(owned)" next to your car:
	ld ix,game_progress_category_car_ptrs
	ld a,(game_progress_current_car)
	cp (ix)	
	jp z,update_carmarket_screen_data_own_1st_car
	cp (ix+2)	
	jp z,update_carmarket_screen_data_own_2nd_car
	cp (ix+4)	
	jp z,update_carmarket_screen_data_own_3rd_car
	ret
update_carmarket_screen_data_own_3rd_car:
	ld de,NAMTBL2+14*32+2
	jr update_carmarket_screen_data_draw_owned
update_carmarket_screen_data_own_2nd_car:
	ld de,NAMTBL2+8*32+2
	jr update_carmarket_screen_data_draw_owned
update_carmarket_screen_data_own_1st_car:
	ld de,NAMTBL2+2*32+2
	jr update_carmarket_screen_data_draw_owned
update_carmarket_screen_data_draw_owned:
	push de
	ld hl,carmarket_text_sell
	ld bc,4
	call fast_LDIRVM
	pop hl
	ld bc,32+2
	add hl,bc
	ex de,hl
	ld hl,carmarket_text_owned
	ld bc,7
	jp fast_LDIRVM


; hl: pointer to the car description to visualize
; de: pointer to the VDP address where to start rendering
update_carmarket_car_data:
	; car name:
	ld bc,7
	add hl,bc	; pointer to the car name
	push hl
	;ld de,NAMTBL2+9*32+18
	push de
	ld bc,12
	call fast_LDIRVM
	pop hl
	ld bc,22
	add hl,bc
	ex de,hl	; de now has the position where to start drawing the speed
	pop hl

	; max speed:
	ld bc,13
	add hl,bc ; pointer to the speed
	ld a,(hl)
	push hl
	ld h,0
	ld l,a
	push de
	call draw_right_aligned_16bit_number_to_vdp
	pop hl
	ld bc,30
	add hl,bc
	ex de,hl	; next screen position
	pop hl
	inc hl		; pointer to acceleration

	; car acceleration:
	push hl
	push de
	ld bc,3
	call fast_LDIRVM
	pop hl
	ld bc,34
	add hl,bc
	ex de,hl	; next screen position
	pop hl

	; weight:
;	dec hl
;	ld b,(hl)
;	dec hl
;	ld c,(hl)
;	push hl
;	ld h,b
;	ld l,c
;	push de
;	call draw_right_aligned_16bit_number_to_vdp
;	pop hl
;	ld bc,32
;	add hl,bc
;	ex de,hl
;	pop hl
	
	; car price:
	dec hl
	dec hl
	ld a,(hl)
	ld h,0
	ld l,a
	call draw_right_aligned_16bit_number_to_vdp
	ld a,'$'
	ex de,hl
	jp writeByteToVDP

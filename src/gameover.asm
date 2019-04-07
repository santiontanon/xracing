gameover_screen:
	call disable_VDP_output
	call clearScreen
	call clearAllTheSprites
    ld hl,patterns_base_pletter
    call decompressPatternsToVDPAllBanks
    call enable_VDP_output

	call StopPlayingMusic
	ld hl,gameover_song_pletter
    ld de,music_buffer
    call pletter_unpack
    ld a,6
    call play_song
	
	ld hl,message_game_over
	ld de,NAMTBL2+8*32+11
	ld bc,10
	call fast_LDIRVM

	ld a,(game_progress_category)
	or a
	jr z,gameover_screen_loop_no_continue

	ld hl,message_continue
	ld de,NAMTBL2+11*32+10
	ld bc,12
	call fast_LDIRVM

gameover_screen_loop:
	halt
	call checkInput
	bit INPUT_TRIGGER1_BIT,a
	jp nz,splash_screen
	bit INPUT_TRIGGER2_BIT,a
	jr nz,gameover_continue
	jr gameover_screen_loop

gameover_continue:
	call StopPlayingMusic
	ld a,(game_progress_category)
	jp season_screen_start_new_season

gameover_screen_loop_no_continue:
	halt
	call checkInput
	bit INPUT_TRIGGER1_BIT,a
	jp nz,splash_screen
	jr gameover_screen_loop_no_continue


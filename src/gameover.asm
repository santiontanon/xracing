gameover_screen:
	call clearScreen
	call clearAllTheSprites
    ld hl,patterns_base_pletter
    call decompressPatternsToVDPAllBanks
	ld hl,message_game_over
	ld de,NAMTBL2+8*32+11
	ld bc,10
	call fast_LDIRVM
	call StopPlayingMusic
	ld hl,gameover_song_pletter
    ld de,music_buffer
    call pletter_unpack
    ld a,6
    call play_song

gameover_screen_loop:
	halt
	call checkInput
	bit INPUT_TRIGGER1_BIT,a
	jp nz,splash_screen
	jr gameover_screen_loop
	ret

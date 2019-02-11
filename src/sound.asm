;-----------------------------------------------
Instrument_profiles:
SquareWave_instrument_profile:
    db 12
Piano_instrument_profile:
    db 14,13,12,11,10,10,9,9,8,8,7,7,6,#ff
Soft_Piano_instrument_profile:
    db 12,11,10,9,8,8,7,7,6,6,5,5,4,#ff
;Wind_instrument_profile:
;    db 0,3,6,8,10,11,12, #ff

; This is the complete note table:
;note_period_table:
;  db 7,119,  7,12,  6,167,  6,71,  5,237,  5,152,  5,71,  4,252,  4,180,  4,112,  4,49,  3,244
;  db 3,188,  3,134,  3,83,  3,36,  2,246,  2,204,  2,164,  2,126,  2,90,  2,56,  2,24,  1,250  
;  db 1,222,  1,195,  1,170,  1,146,  1,123,  1,102,  1,82,  1,63,  1,45,  1,28,  1,12,  0,253
;  db 0,239,  0,225,  0,213,  0,201,  0,190,  0,179,  0,169,  0,159,  0,150,  0,142,  0,134,  0,127
;  db 0,119,  0,113,  0,106,  0,100,  0,95,  0,89,  0,84,  0,80,  0,75,  0,71,  0,67,  0,63


note_period_table:
    db 13,93,  12,156,  11,231,  11,60,  10,155,  10,2,  9,115,  8,235
    db 8,107,  7,242,  7,128,  7,20,  6,174,  6,78,  5,244,  5,158
    db 5,77,  5,1,  3,192,  3,87,  2,250,  2,207,  2,167,  2,129
    db 2,59,  1,252,  1,224,  1,197,  1,172,  1,148,  1,125,  1,104
    db 1,83,  1,64,  1,29,  1,13,  0,254,  0,240,  0,226,  0,214
    db 0,190,  0,180,  0,170,  0,160,  0,143

;-----------------------------------------------
; Sound effects used for the percussion in the songs
SFX_open_hi_hat:
    db  7,#9c    ;; noise in channel C, and tone in channels B and A
    db 10,#0a    ;; volume
    db  6+MUSIC_CMD_TIME_STEP_FLAG,#01    ;; noise frequency
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#06    ;; volume
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db  7,#b8    ;; SFX all channels to tone
    db 10,#00         ;; channel 3 volume to silence
    db SFX_CMD_END      


SFX_pedal_hi_hat:
    db  7,#9c    ;; noise in channel C, and tone in channels B and A
    db 10,#05    ;; volume
    db  6+MUSIC_CMD_TIME_STEP_FLAG,#04    ;; noise frequency
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08    ;; volume
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume
    db  7,#b8    ;; SFX all channels to tone
    db 10,#00         ;; channel 3 volume to silence
    db SFX_CMD_END   


SFX_semaphore1:
    db  7,#b8
    db 10,#0f
    db 5, #06, 4+MUSIC_CMD_TIME_STEP_FLAG, #00
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0d
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0c
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08
    db MUSIC_CMD_SKIP
    db 10,#00         ;; channel 3 volume to silence
    db SFX_CMD_END   


SFX_semaphore2:
    db 7,#b8
    db 10,#0f
    db 5, #02, 4+MUSIC_CMD_TIME_STEP_FLAG, #00
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0d
    db MUSIC_CMD_SKIP,MUSIC_CMD_SKIP,MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0c
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08
    db MUSIC_CMD_SKIP
    db 10,#00         ;; channel 3 volume to silence
    db SFX_CMD_END   


SFX_collision_soft:
    db 7,#98
    db 10,#0f
    db 5,#06,4,#00
    db 6+MUSIC_CMD_TIME_STEP_FLAG,#08
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#06
    db 10,#00
    db 7,#b8
    db SFX_CMD_END


SFX_collision_hard:
    db 7,#98
    db 10,#0f
    db 5,#06,4,#00
    db 6+MUSIC_CMD_TIME_STEP_FLAG,#1f
    db 6+MUSIC_CMD_TIME_STEP_FLAG,#1c
    db 6+MUSIC_CMD_TIME_STEP_FLAG,#1a
    db 7,#9c
    db 10,#0c
    db 6+MUSIC_CMD_TIME_STEP_FLAG,#08
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#06
    db 10,#00
    db 7,#b8
    db SFX_CMD_END


SFX_brake:
    db 7,#98
    db 6,#04
    db 10,#0f
    db 5,#00, 4+MUSIC_CMD_TIME_STEP_FLAG, #68
    db 4+MUSIC_CMD_TIME_STEP_FLAG, #60
    db 10,#0d
    db 4+MUSIC_CMD_TIME_STEP_FLAG, #68
    db 4+MUSIC_CMD_TIME_STEP_FLAG, #60
    db 10,#00
    db 7,#b8
    db SFX_CMD_END


SFX_lap:
    db 7,#b8
    db 5, #02, 4, #00, 10+MUSIC_CMD_TIME_STEP_FLAG, #09
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08
    db 5, #02, 4, #00, 10+MUSIC_CMD_TIME_STEP_FLAG, #0a
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09
    db 5, #02, 4, #00, 10+MUSIC_CMD_TIME_STEP_FLAG, #0b
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0a
    db 4, #40, 10+MUSIC_CMD_TIME_STEP_FLAG,#0c
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b
    db 4, #80, 10+MUSIC_CMD_TIME_STEP_FLAG,#0d
    db 4, #c0, 10+MUSIC_CMD_TIME_STEP_FLAG,#0c
    db 5, #03, 4, #00, 10+MUSIC_CMD_TIME_STEP_FLAG, #0f
    db 5, #04, 10+MUSIC_CMD_TIME_STEP_FLAG,#0e
    db 5, #05, 10+MUSIC_CMD_TIME_STEP_FLAG,#0f
    db 5, #06, 10+MUSIC_CMD_TIME_STEP_FLAG,#0e
    db 5, #07, 10+MUSIC_CMD_TIME_STEP_FLAG,#0e
    db 4, #80, 10+MUSIC_CMD_TIME_STEP_FLAG,#0d
    db 5, #08, 4, #00, 10+MUSIC_CMD_TIME_STEP_FLAG,#0d
    db 4, #40, 10+MUSIC_CMD_TIME_STEP_FLAG,#0c
    db 4, #80, 10+MUSIC_CMD_TIME_STEP_FLAG,#0b
    db 4, #c0, 10+MUSIC_CMD_TIME_STEP_FLAG,#0a
    db 5, #09, 4, #00, 10+MUSIC_CMD_TIME_STEP_FLAG, #09
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#08
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#07
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#06
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#07
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#06
    db 10,#00
    db SFX_CMD_END


SFX_menu_switch:
    db  7,#b8    ;; SFX all channels to tone
    db 10,#0d    ;; volume
    db 4,0, 5+MUSIC_CMD_TIME_STEP_FLAG,#01 ;; frequency
    db MUSIC_CMD_SKIP
    db MUSIC_CMD_SKIP
    db 4,#40,5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0d    ;; volume
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#07    ;; volume
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#05    ;; volume
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#03    ;; volume
    db 10,#00    ;; silence
    db SFX_CMD_END 

SFX_menu_select:
    db  7,#b8    ;; SFX all channels to tone
    db 10,#0d    ;; volume
    db 4,#80, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume

    db 10,#0d    ;; volume
    db 4,#70, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume

    db 10,#0d    ;; volume
    db 4,#60, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume

    db 10,#0d    ;; volume
    db 4,#50, 5+MUSIC_CMD_TIME_STEP_FLAG,#00 ;; frequency
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#0b    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#09    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#07    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#05    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#04    ;; volume
    db MUSIC_CMD_SKIP
    db 10+MUSIC_CMD_TIME_STEP_FLAG,#03    ;; volume
    db MUSIC_CMD_SKIP
    db 10,#00    ;; silence
    db SFX_CMD_END    

SFX_agent_text:
    db  7,#b8    ;; SFX all channels to tone
    db 10,#0c    ;; volume
    db 4,0, 5+MUSIC_CMD_TIME_STEP_FLAG,#03 ;; frequency
    db 10,#00    ;; silence
    db SFX_CMD_END 


;-----------------------------------------------
; starts playing a song 
; arguments: 
; - a: MUSIC_tempo
play_song:
    ld (MUSIC_tempo),a
    call StopPlayingMusic
    di
    ld a,1
    ld hl,music_buffer
    ld (MUSIC_play),a
    ld (MUSIC_pointer),hl
    ld (MUSIC_start_pointer),hl
    ld hl,MUSIC_repeat_stack
    ld (MUSIC_repeat_stack_ptr),hl
    ei
    ret


;-----------------------------------------------
StopPlayingMusic:
    di
    ld hl,beginning_of_sound_variables_except_tempo
    ld b,end_of_sound_variables - beginning_of_sound_variables_except_tempo
    xor a
StopPlayingMusic_loop:
    ld (hl),a
    inc hl
    djnz StopPlayingMusic_loop
    call clear_PSG_volume
    ei
    ret


;-----------------------------------------------
; silences all 3 channels of the PSG
clear_PSG_volume:
    ld a,8
    ld e,0
    call WRTPSG
    ld a,9
    ld e,0
    call WRTPSG
    ld a,10
    ld e,0
    jp WRTPSG


;-----------------------------------------------
; Loads the interrupt hook for playing music:
setup_music_interrupt:
    call StopPlayingMusic
    ld  a,JPCODE    ;NEW HOOK SET
    di
    ld  (TIMI),a
    ld  hl,update_sound
    ld  (TIMI+1),hl
    ei
    ret


;-----------------------------------------------
; Music player update routine
update_sound:     ; This routine sould be called 50 or 60 times / sec 
    push af  

    ld a,(MUSIC_play)
    or a
    jr z,update_sound_no_music_no_pop_bc_de
    push de
    push bc
    call update_sound_handle_instruments

    ld a,(MUSIC_tempo_counter)
    or a
    jr nz,update_sound_skip
    push ix
    push hl
    ld ix,(MUSIC_repeat_stack_ptr)
    xor a
    ld (MUSIC_time_step_required),a
    ld hl,(MUSIC_pointer)
    call update_sound_internal
    ld (MUSIC_pointer),hl
    ld (MUSIC_repeat_stack_ptr),ix
    pop hl
    pop ix
    ld a,(MUSIC_tempo)
    ld (MUSIC_tempo_counter),a
    jr update_sound_music_done
update_sound_skip:
    dec a
    ld (MUSIC_tempo_counter),a

update_sound_music_done:
    pop bc
    pop de
update_sound_no_music_no_pop_bc_de:
    push bc
    ld a,(SFX_priority)
    or a
    jr z,update_sound_no_sfx
    push hl
    push de
    xor a
    ld (MUSIC_time_step_required),a
    ld hl,(SFX_pointer)
    call update_sound_internal
    ld (SFX_pointer),hl
    pop de
    pop hl
update_sound_no_sfx:
    ; check if we need to generate the engine SFX:
    ld a,(race_state)
    cp RACE_STATE_RACE_OVER
    jp p,update_sound_no_engine_sound
    cp RACE_STATE_RACING
    jp m,generate_engine_sfx    ; regardless of whether we have it on or off, always generate engine sound at race start
    ld a,(global_options)
    bit OPTIONS_BIT_MUSIC,a
    jp nz,generate_engine_sfx
update_sound_no_engine_sound:
    pop bc
    pop af
    ret

generate_engine_sfx:
    push de
    ; frequency, based on engine revs:
    ld a,(player_car_gear)
    cp 2
    jp z,generate_engine_sfx_high_gear
    ld a,(player_car_speed)
    call a_absolute_value
;    add a,a
    neg
    add a,128   ; a = 144-|speed|
    ld d,a
    ld e,0
    srl d
    rr e
    srl d
    rr e
    srl d
    rr e
    srl d
    rr e
    jp generate_engine_sfx_after_gears
generate_engine_sfx_high_gear:
    ld a,(player_car_speed)
    call a_absolute_value
    inc a
    neg
;    add a,128   ; a = 128-|speed|
    ld d,a
    ld e,0
    srl d
    rr e
    srl d
    rr e
    srl d
    rr e
    srl d
    rr e
    srl d
    rr e
generate_engine_sfx_after_gears:
;    ld a,4
    ld a,2
    push de
    call WRTPSG
    pop de
    ld e,d
;    ld a,5
    ld a,3
    call WRTPSG
    ld a,(engine_sfx_timer)
    inc a
    ld (engine_sfx_timer),a
    and #01
    jp z,generate_engine_sfx_volume_up
generate_engine_sfx_volume_down:
;    ld a,10
    ld a,9
    ld e,#09
    call WRTPSG
    pop de
    pop bc
    pop af
    ret
generate_engine_sfx_volume_up:
;    ld a,10
    ld a,9
    ld e,#0a
    call WRTPSG
    pop de
    pop bc
    pop af
    ret

;-----------------------------------------------
; Starts playing an SFX
; arguments: 
; - a: SFX priority
; - hl: pointer to the SFX to play
play_ingame_SFX:
    ld a,(global_options)
    bit OPTIONS_BIT_OTHER_SFX,a
    ret nz
play_SFX_with_high_priority:
    ld a,SFX_PRIORITY_HIGH
play_SFX_with_priority:
    push hl
    ld hl,SFX_priority
    cp (hl)
    pop hl
    jp m,play_SFX_with_priority_ignore
    di
    ld (SFX_pointer),hl
    ld (SFX_priority),a
    xor a
    ld (MUSIC_instruments+2),a  ;; reset the instrument in channel 3 to Square wave, so it does not interfere with the SFX
    ei
play_SFX_with_priority_ignore:
    ret


;-----------------------------------------------
; handle the different curves of the music instruments
update_sound_handle_instruments:
    ld a,(MUSIC_instruments)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE
    jr z,update_sound_handle_instruments_CH2
    ld de,(MUSIC_instrument_envelope_ptr)
    ld a,(de)
    cp #ff
    jr z,update_sound_handle_instruments_CH2
    inc de
    ld (MUSIC_instrument_envelope_ptr),de
    ld e,a
    ld a,8
    call WRTPSG
update_sound_handle_instruments_CH2:
    ld a,(MUSIC_instruments+1)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE
    jr z,update_sound_handle_instruments_CH3
    ld de,(MUSIC_instrument_envelope_ptr+2)
    ld a,(de)
    cp #ff
    jr z,update_sound_handle_instruments_CH3
    inc de
    ld (MUSIC_instrument_envelope_ptr+2),de
    ld e,a
    ld a,9
    call WRTPSG
update_sound_handle_instruments_CH3:
    ld a,(SFX_priority)
    or a
    ret nz  ; if there is an SFX playing, then do not update the instruments in channel 3!
    ld a,(MUSIC_instruments+2)
    or a  ; MUSIC_INSTRUMENT_SQUARE_WAVE 
    ret z
    ld de,(MUSIC_instrument_envelope_ptr+4)
    ld a,(de)
    cp #ff
    ret z
    inc de
    ld (MUSIC_instrument_envelope_ptr+4),de
    ld e,a
    ld a,10
    jp WRTPSG


update_sound_WRTPSG:
    and #0f ; clear all the flags that the command might have
    ld e,(hl)
    inc hl
    call WRTPSG                ;; send command to PSG
    jr update_sound_internal_loop     


update_sound_SET_INSTRUMENT:
    ld d,(hl)   ; instrument
    inc hl
    ld a,(hl)   ; channel
    inc hl
    push hl
    cp 2
    jr nz,update_sound_SET_INSTRUMENT_not_third_channel
    ld hl,MUSIC_channel3_instrument_buffer
    ld (hl),d
update_sound_SET_INSTRUMENT_not_third_channel:
    ld hl,MUSIC_instruments
    ADD_HL_A
    ld (hl),d
    pop hl
    jr update_sound_internal_loop


update_sound_GOTO:
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld hl,(MUSIC_start_pointer)
    add hl,de
    ; we also need to silence channels 1 and 2, just in case
    ld a,8
    ld e,0
    call WRTPSG
    ld a,9
    ld e,0
    call WRTPSG    
    xor a
    ld (MUSIC_instruments),a
    ld (MUSIC_instruments+1),a
    jr update_sound_internal_loop


update_sound_REPEAT:
    ld a,(hl)
    inc hl
    ld (ix),a
    ld (ix+1),l
    ld (ix+2),h
    inc ix
    inc ix
    inc ix
    jr update_sound_internal_loop


update_sound_END_REPEAT:
    ;; decrease the top value of the repeat stack
    ;; if it is 0, pop
    ;; if it is not 0, goto the repeat point
    ld a,(ix-3)
    dec a
    or a
    jr z,update_sound_END_REPEAT_POP
    ld (ix-3),a
    ld l,(ix-2)
    ld h,(ix-1)
    jr update_sound_internal_loop
update_sound_END_REPEAT_POP:
    dec ix
    dec ix
    dec ix
    jr update_sound_internal_loop


update_sound_command_time_step:
    push af
    ld a,1
    ld (MUSIC_time_step_required),a
    pop af
    ret


update_sound_internal_loop:
    ; check if there is a time step required on the last command
    ld a,(MUSIC_time_step_required)
    or a
    ret nz
update_sound_internal:
    ld a,(hl)
    inc hl 
    ; check if it's a special command:
    bit 6,a
    call nz,update_sound_command_time_step
    bit 7,a
    jp z,update_sound_WRTPSG
    and #3f ; clear all the flags the command might have
    ret z   ; MUSIC_CMD_SKIP command
    dec a   ; MUSIC_CMD_SET_INSTRUMENT
    jp z,update_sound_SET_INSTRUMENT
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH1
    jr z,update_sound_PLAY_INSTRUMENT_CH1
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH2
    jr z,update_sound_PLAY_INSTRUMENT_CH2
    dec a   ; MUSIC_CMD_PLAY_INSTRUMENT_CH3
    jr z,update_sound_PLAY_INSTRUMENT_CH3
    dec a   ; MUSIC_CMD_PLAY_SFX_OPEN_HIHAT
    jr z,update_sound_PLAY_SFX_OPEN_HIHAT
    dec a   ; MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT
    jr z,update_sound_PLAY_SFX_PEDAL_HIHAT
    dec a   ; MUSIC_CMD_GOTO
    jr z,update_sound_GOTO
    dec a   ; MUSIC_CMD_REPEAT
    jr z,update_sound_REPEAT
    dec a   ; MUSIC_CMD_END_REPEAT
    jr z,update_sound_END_REPEAT
;    dec a   ; MUSIC_CMD_TRANSPOSE_UP
;    jr z,update_sound_TRANSPOSE_UP
;    dec a   ; MUSIC_CMD_CLEAR_TRANSPOSE
;    jr z,update_sound_CLEAR_TRANSPOSE
    ; SFX_CMD_END
;    jp update_sound_SFX_END       ;; if the SFX sound is over, we are done


update_sound_SFX_END:
    xor a
    ld (SFX_priority),a
    ld a,7
    ld e,#b8  ;; SFX should reset all channels to tone
    jp WRTPSG


update_sound_PLAY_SFX_OPEN_HIHAT:
    push hl
    ld hl,SFX_open_hi_hat
update_sound_PLAY_SFX_OPEN_HIHAT_entry:
    ld a,SFX_PRIORITY_MUSIC
    call play_SFX_with_priority
    pop hl
    jp update_sound_internal_loop


update_sound_PLAY_SFX_PEDAL_HIHAT:
    push hl
    ld hl,SFX_pedal_hi_hat
    jr update_sound_PLAY_SFX_OPEN_HIHAT_entry


;update_sound_TRANSPOSE_UP:
;    ld a,(MUSIC_transpose)
;    inc a
;update_sound_TRANSPOSE_UP_entry:
;    ld (MUSIC_transpose),a
;    jp update_sound_internal_loop


;update_sound_CLEAR_TRANSPOSE:
;    xor a
;    jr update_sound_TRANSPOSE_UP_entry


update_sound_PLAY_INSTRUMENT_CH1:
    ld a,1
    jr update_sound_PLAY_INSTRUMENT
update_sound_PLAY_INSTRUMENT_CH2:
    ld a,3
    jr update_sound_PLAY_INSTRUMENT
update_sound_PLAY_INSTRUMENT_CH3:
    ld a,(SFX_priority)
    cp SFX_PRIORITY_LOW
    jp p,update_sound_PLAY_INSTRUMENT_IGNORE
    ld a,(MUSIC_channel3_instrument_buffer)
    ld (MUSIC_instruments+2),a
    ld a,5
update_sound_PLAY_INSTRUMENT:
    push hl
        push af
            ld b,0  ; for later use
            ld c,(hl)   ; note to play
;            ld hl,MUSIC_transpose
;            ld a,(hl)
;            add a,c
;            ld c,a
            ld hl,note_period_table
            add hl,bc
            add hl,bc
            ld e,(hl)   ; MSB of the period    
            inc hl
        pop af
        push af
            call WRTPSG
        pop af
        ld e,(hl)   ; LSB of the period    
        dec a
        push af
            call WRTPSG
        pop af

        ld hl,MUSIC_instruments
        ld c,a      ; here  a == 0, 2 or 4 depending on which channel we are playing
        srl a       ; divide by 2
        ADD_HL_A    ; HL = MUSIC_instruments + channel
        ld a,(hl)   ; we get the instrument
        ld de,Instrument_profiles
        ADD_DE_A    ; we calculate pointer to the instrument envelope
        ld hl,MUSIC_instrument_envelope_ptr
        add hl,bc   ; b should still be 0 here, so, we are just adding c
        ld (hl),e
        inc hl
        ld (hl),d
    pop hl
    ld a,c  ; calculate the volume port: (c/2)+8
    sra a
    add a,8
    ld c,a
    ld a,(de)
    ld e,a
    ld a,c
    call WRTPSG
update_sound_PLAY_INSTRUMENT_IGNORE:
    inc hl
    jp update_sound_internal_loop

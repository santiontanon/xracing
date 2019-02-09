;-----------------------------------------------
; Update the (player_input_buffer) variables with the key presses or joystick status
checkInput:
    ld a,(player_input_buffer)
    ld b,a
    push bc
    ld (player_input_buffer+1),a
    call checkNewInput
    pop bc
    ld c,a  ; b has the old input, and c the new input
    ld a,b
    cpl
    and c
    ld (player_input_buffer+2),a
    ret

; read ENTER: row 7 bit 7 -> INPUT_RESPAWN_BIT

checkNewInput:
    ld a,#04    ;; get the status of the 4th keyboard row (to get the M, and P key)
    call SNSMAT 
    cpl
;    bit 5,a ;; "P"
;    call nz,checkInput_pause
    and #04     ;; we keep the status of M
    ld b,a
    ld a,#08    ;; get the status of the 8th keyboard row (to get SPACE and arrow keys)
    call SNSMAT 
    cpl
    and #f1     ;; keep only the arrow keys and space
    or b        ;; we bring the state of M from before

    ld b,a      
    ld a,#05    ;; get the 5th row for "Z" and "X" as alternative keys for "M" and "SPACE"
    call SNSMAT
    cpl
    rlc a
    rlc a
    rlc a
    and #05
    or b

    ld b,a
    ld a,#07    ;; to get "RETURN" (for respawning)
    call SNSMAT
    bit 7,a
    jr nz,checkNewInput_noReturn
    set 1,b
checkNewInput_noReturn:

    ld a,#06    ;; to get "F1" (for pause)
    call SNSMAT
    bit 5,a
    jr nz,checkNewInput_noF1
    set 3,b
checkNewInput_noF1:

    ld a,b
    or a
    jr z,Readjoystick   ;; if no key was pressed, then check the joystick
    ; translarte the keyboard input to the same exact way in which the joystick is read
    ; right now we have: trigger1, enter, trigger2, ???, left, up, right
    ld b,a
    xor a
    bit 0,b
    jr z,checkInputNotTrigger1
    or #10
checkInputNotTrigger1:
    bit 1,b
    jr z,checkInputNotEnter
    or #40
checkInputNotEnter:
    bit 2,b
    jr z,checkInputNotTrigger2
    or #20
checkInputNotTrigger2:
    bit 3,b
    jr z,checkInputNotF1
    or #80
checkInputNotF1:
    bit 7,b
    jr z,checkInputNotRight
    or #08
checkInputNotRight:
    bit 4,b
    jr z,checkInputNotLeft
    or #04
checkInputNotLeft:
    bit 5,b
    jr z,checkInputNotUp
    or #01
checkInputNotUp:
    bit 6,b
    jr z,checkInputNotDown
    or #02
checkInputNotDown:
    ld (player_input_buffer),a
    ret

Readjoystick:   
    ld a,15 ; read the joystick 1 status:
    call RDPSG
    and #bf
    ld e,a
    ld a,15
    call WRTPSG
    dec a
    call RDPSG
    cpl ; invert the bits (so that '1' means direction pressed)
    and #3f
    ld (player_input_buffer),a
    ret


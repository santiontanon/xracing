;-----------------------------------------------
; BIOS calls:
DCOMPR: equ #0020
ENASLT: equ #0024
WRTVDP: equ #0047
WRTVRM: equ #004d
SETWRT: equ #0053
FILVRM: equ #0056
LDIRMV: equ #0059
LDIRVM: equ #005c
CHGMOD: equ #005f
CHGCLR: equ #0062
GICINI: equ #0090   
WRTPSG: equ #0093 
RDPSG:  equ #0096
CHSNS:  equ #009c
CHGET:  equ #009f
CHPUT:  equ #00a2
GTSTCK: equ #00d5
GTTRIG: equ #00d8
SNSMAT: equ #0141
RSLREG: equ #0138
RDVDP:  equ #013e
KILBUF: equ #0156
CHGCPU:	equ #0180


;-----------------------------------------------
; System variables
VDP.DR:	equ #0006
VDP.DW:	equ #0007
VDP_REGISTER_0: equ #f3df
VDP_REGISTER_1: equ #f3e0
CLIKSW: equ #f3db       ; keyboard sound
FORCLR: equ #f3e9
BAKCLR: equ #f3ea
BDRCLR: equ #f3eb
PUTPNT: equ #f3f8
GETPNT: equ #f3fa
MODE:   equ #fafc	
KEYS:   equ #fbe5    
KEYBUF: equ #fbf0
EXPTBL: equ #fcc1
TIMI:   equ #fd9f       ; timer interrupt hook
HKEY:   equ #fd9a       ; hkey interrupt hook


;-----------------------------------------------
; Assembler opcodes:	
JPCODE:         equ  #C3


;-----------------------------------------------
; VRAM map in Screen 1 (only 1 table of patterns, color table has 1 byte per each 8 patterns)
CHRTBL1:  equ     #0000   ; pattern table address
NAMTBL1:  equ     #1800   ; name table address 
CLRTBL1:  equ     #2000   ; color table address             
SPRTBL1:  equ     #0800   ; sprite pattern address  
SPRATR1:  equ     #1b00   ; sprite attribute address
; VRAM map in Screen 2 (3 tables of patterns, color table has 8 bytes per pattern)
CHRTBL2:  equ     #0000   ; pattern table address
NAMTBL2:  equ     #1800   ; name table address 
CLRTBL2:  equ     #2000   ; color table address             
SPRTBL2:  equ     #3800   ; sprite pattern address  
SPRATR2:  equ     #1b00   ; sprite attribute address

;-----------------------------------------------
; MSX1 colors:
COLOR_TRANSPARENT:	equ 0
COLOR_BLACK:		equ 1
COLOR_GREEN:		equ 2
COLOR_LIGHT_GREEN:	equ 3
COLOR_DARK_BLUE:	equ 4
COLOR_BLUE:			equ 5
COLOR_DARK_RED:		equ 6
COLOR_LIGHT_BLUE:	equ 7
COLOR_RED:			equ 8
COLOR_LIGHT_RED:	equ 9
COLOR_DARK_YELLOW:	equ 10
COLOR_YELLOW:		equ 11
COLOR_DARK_GREEN:	equ 12
COLOR_PURPLE:		equ 13
COLOR_GREY:			equ 14
COLOR_WHITE:		equ 15


;-----------------------------------------------
; Input bits
INPUT_UP_BIT:			equ 0
INPUT_DOWN_BIT:			equ 1
INPUT_LEFT_BIT:			equ 2
INPUT_RIGHT_BIT:		equ 3
INPUT_TRIGGER1_BIT:		equ 4
INPUT_TRIGGER2_BIT:		equ 5
INPUT_RESPAWN_BIT:		equ 6
INPUT_PAUSE_BIT:		equ 7

;-----------------------------------------------
; Game constants
COORDINATE_PRECISION:	equ 16	; each COORDINATE_PRECISION units in the map coordinates corresponds to one pixel

N_CARS:			equ 4
;MAX_LAPS:		equ 6
MAX_LAPS:		equ 4

MAX_MAP_WIDTH:	equ 95	; this is a pretty large map already! (I might want to reduce this, 
MAX_MAP_HEIGHT:	equ 80	; unless I find a good reason for having such a large map)
MAX_RAILS:		equ 12
MAX_WAYPOINTS:	equ 24

MAX_TILE_TYPES:	equ 179

MAX_SPRITES_IN_MAP:			equ 24
MAX_MAP_SPRITES_IN_SCREEN:	equ 6

MAX_MESSAGE_SIZE:		equ 40
MESSAGE_WINDOW_SIZE:	equ 10

TILESET_GRASS:	equ 0
TILESET_URBAN:	equ 1

FIRST_SCOREBOARD_SPRITE:	equ 4
FIRST_SEMAPHORE_SPRITE:		equ 8
FIRST_CAR_SPRITE:			equ 12
FIRST_MAP_SPRITE:			equ 20

CAR_POINTER_SPRITE_PATTERN:	equ 36
TREE_SPRITE_PATTERN:	equ 40
SEMAPHORE_SPRITE_PATTERN:	equ 44
SIGNPOST_SPRITE_PATTERN1:	equ 56
SIGNPOST_SPRITE_PATTERN2:	equ 60
EXPLOSION_SPRITE_PATTERN1:	equ 64

MAX_SPEED_IN_EACH_AXIS:		equ 1024
MIN_SPEED_IN_EACH_AXIS:		equ -1024

SCROLL_RAIL_RIGHT:	equ 0
SCROLL_RAIL_LEFT:	equ 1
SCROLL_RAIL_DOWN:	equ 2
SCROLL_RAIL_UP:		equ 3
SCROLL_RAIL_LOOP:	equ 4

SCROLL_RIGHT_CAR_X:	equ 7
SCROLL_LEFT_CAR_X:	equ 23
SCROLL_UP_CAR_Y:	equ 11
SCROLL_DOWN_CAR_Y:	equ 3

WAYPOINT_RIGHT:	equ 0
WAYPOINT_LEFT:	equ 1
WAYPOINT_DOWN:	equ 2
WAYPOINT_UP:	equ 3
WAYPOINT_LOOP:	equ 4

MAX_SCROLL_MOVEMENT_PER_FRAME_IN_REVERSE:	equ 2
MIN_SCROLL_MOVEMENT_PER_FRAME:				equ 0
MAX_SCROLL_MOVEMENT_PER_FRAME: 				equ 8

RACE_STRUCT_SIZE:		equ 12+1+1+1+3+3+3+7+24*3

CAR_STRUCT_SIZE:		equ 19
CAR_DEFINITION_STRUCT_SIZE:		equ 25

CAR_STRUCT_CAR_ID:		equ 0
CAR_STRUCT_ANGLE:		equ 1
CAR_STRUCT_SPEED:		equ 2
CAR_STRUCT_MAP_X:		equ 3
CAR_STRUCT_MAP_Y:		equ 5
CAR_STRUCT_GEAR:		equ 7
CAR_STRUCT_GEAR_PROFILE_STATE:	equ 8
CAR_STRUCT_INVULNERABILITY:	equ 9
CAR_STRUCT_TILE_UNDERNEATH:	equ 10
CAR_STRUCT_NEXT_WAYPOINT:	equ 11
CAR_STRUCT_ACCELERATION:		equ 12
CAR_STRUCT_ACCELERATION_STATE:	equ 13
CAR_STRUCT_RACE_PROGRESS:		equ 14	; this in creases by one each time a car passes a checkpoint
CAR_STRUCT_OUT_OF_TRACK_TIMER:	equ 15	; only used by the opponent cars, to determine when to respawn
CAR_STRUCT_CAR_MODEL_PTR:		equ 16
CAR_STRUCT_SHIFT_UP_SPEED:		equ 18

TERRAIN_ROAD:	equ 0
TERRAIN_GRASS:	equ 1
TERRAIN_OBSTACLE: equ 2

RACE_STATE_SEMAPHORE_OFF:	equ 	0
RACE_STATE_SEMAPHORE_RED:	equ 	1
RACE_STATE_RACING:			equ 	2
RACE_STATE_RACE_OVER:		equ 	3
RACE_STATE_RACE_PAUSED:		equ 	4

NO_CAR:	equ CAR_DEFINITION_ENIAK_100K+1

OPTIONS_BIT_GEARS:	equ 0
OPTIONS_BIT_MUSIC:	equ 1
;OPTIONS_BIT_ENGINE_SFX:	equ 2
OPTIONS_BIT_OTHER_SFX:	equ 2

AGENT_MOOD_ANGRY:			equ -1
AGENT_MOOD_NEUTRAL:			equ 0
AGENT_MOOD_HAPPY:			equ 1

	include "autoConstants.asm"
	include "autoConstants-urban.asm"


;-----------------------------------------------
; Music related constants:
; instrument codes are the indexes of their first byte in the profile
MUSIC_INSTRUMENT_SQUARE_WAVE:   equ 0
MUSIC_INSTRUMENT_PIANO:         equ 1 
MUSIC_INSTRUMENT_PIANO_SOFT:         equ 15
; MUSIC_INSTRUMENT_WIND:          equ 12   

SFX_PRIORITY_MUSIC:				equ 1	; this is the lowest priority
SFX_PRIORITY_LOW:				equ 2
SFX_PRIORITY_HIGH:				equ 3

N_MUSIC_CHANNELS:				equ 3	

MUSIC_CMD_FLAG:					equ #80
MUSIC_CMD_TIME_STEP_FLAG:		equ #40

MUSIC_CMD_SKIP:             	equ #00+MUSIC_CMD_FLAG
MUSIC_CMD_SET_INSTRUMENT:       equ #01+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH1:  equ #02+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH2:  equ #03+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_INSTRUMENT_CH3:  equ #04+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_SFX_OPEN_HIHAT:  equ #05+MUSIC_CMD_FLAG
MUSIC_CMD_PLAY_SFX_PEDAL_HIHAT: equ #06+MUSIC_CMD_FLAG
MUSIC_CMD_GOTO:             	equ #07+MUSIC_CMD_FLAG
MUSIC_CMD_REPEAT:           	equ #08+MUSIC_CMD_FLAG
MUSIC_CMD_END_REPEAT:       	equ #09+MUSIC_CMD_FLAG
;MUSIC_CMD_TRANSPOSE_UP:			equ #0a+MUSIC_CMD_FLAG
;MUSIC_CMD_CLEAR_TRANSPOSE:		equ #0b+MUSIC_CMD_FLAG
SFX_CMD_END:                	equ #0c+MUSIC_CMD_FLAG

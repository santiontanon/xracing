    org #0000
    include "../constants.asm"
    include "track11-minimap.asm"
track_car_start_positions:
    db 8, 40
    db 5, 38
    db 8, 35
    db 5, 33
semaphore_start_position:
    db 30, 3
    db 30, 5
    db 30, 7
    db 30, 9
track_rails:
    db SCROLL_RAIL_UP, 0, 1
    db SCROLL_RAIL_RIGHT, 32, 0
    db SCROLL_RAIL_DOWN, 63, 1
    db SCROLL_RAIL_LEFT, 0, 0
    db SCROLL_RAIL_UP, 27, 1
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 24, WAYPOINT_UP, 120
    db 11, 14, WAYPOINT_UP, 120
    db 24, 9, WAYPOINT_RIGHT, 120
    db 47, 9, WAYPOINT_RIGHT, 120
    db 56, 15, WAYPOINT_DOWN, 120
    db 56, 32, WAYPOINT_DOWN, 120
    db 56, 47, WAYPOINT_DOWN, 120
    db 56, 63, WAYPOINT_DOWN, 120
    db 47, 69, WAYPOINT_LEFT, 120
    db 32, 69, WAYPOINT_LEFT, 120
    db 16, 69, WAYPOINT_LEFT, 120
    db 7, 62, WAYPOINT_UP, 120
    db 7, 52, WAYPOINT_UP, 120
    db 7, 41, WAYPOINT_UP, 120
    db 7, 31, WAYPOINT_UP, 120
    db 7, 24, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    include "track11.asm"

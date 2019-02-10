    org #0000
    include "../constants.asm"
    include "track7-minimap.asm"
track_car_start_positions:
    db 8, 26
    db 5, 24
    db 8, 21
    db 5, 19
semaphore_start_position:
    db 16, 3
    db 16, 5
    db 16, 7
    db 16, 9
track_rails:
    db SCROLL_RAIL_UP, 0, 1
    db SCROLL_RAIL_RIGHT, 32, 0
    db SCROLL_RAIL_DOWN, 48, 0
    db SCROLL_RAIL_RIGHT, 46, 0
    db SCROLL_RAIL_DOWN, 63, 0
    db SCROLL_RAIL_LEFT, 0, 0
    db SCROLL_RAIL_UP, 13, 1
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 13, WAYPOINT_UP, 120
    db 16, 7, WAYPOINT_RIGHT, 120
    db 31, 7, WAYPOINT_RIGHT, 120
    db 47, 7, WAYPOINT_RIGHT, 120
    db 56, 14, WAYPOINT_DOWN, 120
    db 48, 32, WAYPOINT_DOWN, 120
    db 40, 48, WAYPOINT_DOWN, 100
    db 49, 54, WAYPOINT_RIGHT, 80
    db 66, 55, WAYPOINT_RIGHT, 112
    db 72, 61, WAYPOINT_DOWN, 80
    db 72, 66, WAYPOINT_DOWN, 112
    db 67, 71, WAYPOINT_LEFT, 90
    db 49, 71, WAYPOINT_LEFT, 120
    db 16, 71, WAYPOINT_LEFT, 120
    db 7, 62, WAYPOINT_UP, 120
    db 7, 47, WAYPOINT_UP, 120
    db 7, 33, WAYPOINT_UP, 120
    db 7, 24, WAYPOINT_UP, 120
    db 7, 16, WAYPOINT_UP, 120
    db 7, 13, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    include "track7.asm"

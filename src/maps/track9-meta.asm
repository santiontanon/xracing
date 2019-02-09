    org #0000
    include "../constants.asm"
    include "track9-minimap.asm"
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
    db SCROLL_RAIL_RIGHT, 64, 0
    db SCROLL_RAIL_DOWN, 14, 0
    db SCROLL_RAIL_LEFT, 32, 0
    db SCROLL_RAIL_DOWN, 30, 0
    db SCROLL_RAIL_RIGHT, 64, 0
    db SCROLL_RAIL_DOWN, 48, 0
    db SCROLL_RAIL_LEFT, 0, 0
    db SCROLL_RAIL_UP, 13, 1
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 12, WAYPOINT_UP, 120
    db 13, 7, WAYPOINT_RIGHT, 120
    db 39, 7, WAYPOINT_RIGHT, 120
    db 59, 7, WAYPOINT_RIGHT, 120
    db 82, 7, WAYPOINT_RIGHT, 120
    db 88, 13, WAYPOINT_DOWN, 100
    db 88, 19, WAYPOINT_DOWN, 112
    db 84, 24, WAYPOINT_LEFT, 90
    db 46, 24, WAYPOINT_LEFT, 112
    db 40, 28, WAYPOINT_DOWN, 80
    db 39, 35, WAYPOINT_DOWN, 112
    db 45, 39, WAYPOINT_RIGHT, 80
    db 83, 40, WAYPOINT_RIGHT, 112
    db 88, 44, WAYPOINT_DOWN, 80
    db 88, 51, WAYPOINT_DOWN, 112
    db 83, 56, WAYPOINT_LEFT, 80
    db 50, 56, WAYPOINT_LEFT, 120
    db 16, 56, WAYPOINT_LEFT, 120
    db 7, 47, WAYPOINT_UP, 120
    db 7, 36, WAYPOINT_UP, 120
    db 7, 24, WAYPOINT_UP, 120
    db 7, 17, WAYPOINT_UP, 120
    db 7, 12, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    include "track9.asm"

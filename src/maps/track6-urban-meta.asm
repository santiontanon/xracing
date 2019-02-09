    org #0000
    include "../constants.asm"
    include "track6-urban-minimap.asm"
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
    db SCROLL_RAIL_UP, 0, 0
    db SCROLL_RAIL_RIGHT, 40, 1
    db SCROLL_RAIL_DOWN, 16, 2
    db SCROLL_RAIL_LEFT, 28, 1
    db SCROLL_RAIL_DOWN, 48, 2
    db SCROLL_RAIL_RIGHT, 40, 1
    db SCROLL_RAIL_UP, 34, 2
    db SCROLL_RAIL_LEFT, 0, 1
    db SCROLL_RAIL_UP, 13, 0
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 9, WAYPOINT_UP, 120
    db 12, 5, WAYPOINT_RIGHT, 120
    db 35, 5, WAYPOINT_RIGHT, 120
    db 58, 5, WAYPOINT_RIGHT, 120
    db 64, 10, WAYPOINT_DOWN, 120
    db 7, 16, WAYPOINT_UP, 120
    db 64, 19, WAYPOINT_DOWN, 120
    db 59, 24, WAYPOINT_LEFT, 120
    db 43, 25, WAYPOINT_LEFT, 67
    db 38, 30, WAYPOINT_DOWN, 120
    db 37, 43, WAYPOINT_DOWN, 67
    db 37, 53, WAYPOINT_DOWN, 120
    db 43, 58, WAYPOINT_RIGHT, 120
    db 56, 59, WAYPOINT_RIGHT, 120
    db 63, 54, WAYPOINT_UP, 120
    db 63, 49, WAYPOINT_UP, 120
    db 57, 42, WAYPOINT_LEFT, 120
    db 36, 42, WAYPOINT_LEFT, 120
    db 13, 42, WAYPOINT_LEFT, 120
    db 7, 35, WAYPOINT_UP, 120
    db 7, 26, WAYPOINT_UP, 120
    db 7, 17, WAYPOINT_UP, 120
    db 7, 9, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    include "track6-urban.asm"

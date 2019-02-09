    org #0000
    include "../constants.asm"
    include "track8-urban-minimap.asm"
track_car_start_positions:
    db 8, 39
    db 5, 37
    db 8, 34
    db 5, 32
semaphore_start_position:
    db 29, 3
    db 29, 5
    db 29, 7
    db 29, 9
track_rails:
    db SCROLL_RAIL_UP, 0, 0
    db SCROLL_RAIL_RIGHT, 16, 1
    db SCROLL_RAIL_DOWN, 12, 2
    db SCROLL_RAIL_RIGHT, 64, 1
    db SCROLL_RAIL_UP, 0, 0
    db SCROLL_RAIL_LEFT, 40, 1
    db SCROLL_RAIL_DOWN, 32, 2
    db SCROLL_RAIL_LEFT, 0, 1
    db SCROLL_RAIL_UP, 26, 0
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 10, WAYPOINT_UP, 120
    db 12, 5, WAYPOINT_RIGHT, 120
    db 28, 5, WAYPOINT_RIGHT, 120
    db 34, 10, WAYPOINT_DOWN, 90
    db 34, 16, WAYPOINT_DOWN, 120
    db 7, 29, WAYPOINT_UP, 120
    db 40, 23, WAYPOINT_RIGHT, 90
    db 81, 23, WAYPOINT_RIGHT, 120
    db 88, 17, WAYPOINT_UP, 90
    db 88, 11, WAYPOINT_UP, 120
    db 82, 5, WAYPOINT_LEFT, 90
    db 68, 5, WAYPOINT_LEFT, 120
    db 61, 10, WAYPOINT_DOWN, 90
    db 61, 36, WAYPOINT_DOWN, 120
    db 53, 43, WAYPOINT_LEFT, 90
    db 34, 43, WAYPOINT_LEFT, 120
    db 14, 43, WAYPOINT_LEFT, 120
    db 7, 37, WAYPOINT_UP, 90
    db 7, 30, WAYPOINT_UP, 120
    db 7, 10, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    include "track8-urban.asm"

    org #0000
    include "../constants.asm"
    include "track4-urban-minimap.asm"
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
    db SCROLL_RAIL_DOWN, 40, 2
    db SCROLL_RAIL_LEFT, 0, 3
    db SCROLL_RAIL_UP, 13, 0
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 9, WAYPOINT_UP, 120
    db 12, 5, WAYPOINT_RIGHT, 120
    db 25, 7, WAYPOINT_RIGHT, 120
    db 64, 9, WAYPOINT_DOWN, 120
    db 36, 12, WAYPOINT_RIGHT, 120
    db 45, 10, WAYPOINT_RIGHT, 120
    db 55, 4, WAYPOINT_RIGHT, 120
    db 7, 16, WAYPOINT_UP, 120
    db 64, 20, WAYPOINT_DOWN, 120
    db 55, 24, WAYPOINT_LEFT, 120
    db 48, 30, WAYPOINT_DOWN, 67
    db 57, 36, WAYPOINT_RIGHT, 120
    db 64, 41, WAYPOINT_DOWN, 67
    db 57, 49, WAYPOINT_LEFT, 120
    db 35, 49, WAYPOINT_LEFT, 120
    db 12, 49, WAYPOINT_LEFT, 120
    db 7, 44, WAYPOINT_UP, 120
    db 7, 29, WAYPOINT_UP, 120
    db 7, 17, WAYPOINT_UP, 120
    db 7, 9, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    include "track4-urban.asm"

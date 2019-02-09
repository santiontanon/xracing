    org #0000
    include "../constants.asm"
    include "track2-minimap.asm"
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
    db SCROLL_RAIL_RIGHT, 40, 0
    db SCROLL_RAIL_DOWN, 11, 0
    db SCROLL_RAIL_LEFT, 24, 0
    db SCROLL_RAIL_DOWN, 25, 0
    db SCROLL_RAIL_RIGHT, 40, 0
    db SCROLL_RAIL_DOWN, 36, 0
    db SCROLL_RAIL_LEFT, 0, 0
    db SCROLL_RAIL_UP, 13, 1
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 12, WAYPOINT_UP, 120
    db 14, 6, WAYPOINT_RIGHT, 120
    db 36, 6, WAYPOINT_RIGHT, 120
    db 7, 16, WAYPOINT_UP, 120
    db 59, 6, WAYPOINT_RIGHT, 120
    db 63, 10, WAYPOINT_DOWN, 120
    db 63, 16, WAYPOINT_DOWN, 120
    db 58, 19, WAYPOINT_LEFT, 120
    db 44, 19, WAYPOINT_LEFT, 120
    db 38, 23, WAYPOINT_DOWN, 85
    db 38, 28, WAYPOINT_DOWN, 85
    db 44, 31, WAYPOINT_RIGHT, 120
    db 58, 31, WAYPOINT_RIGHT, 120
    db 63, 35, WAYPOINT_DOWN, 120
    db 63, 41, WAYPOINT_DOWN, 120
    db 58, 45, WAYPOINT_LEFT, 120
    db 43, 45, WAYPOINT_LEFT, 120
    db 28, 45, WAYPOINT_LEFT, 120
    db 14, 45, WAYPOINT_LEFT, 120
    db 7, 39, WAYPOINT_UP, 120
    db 7, 26, WAYPOINT_UP, 120
    db 7, 17, WAYPOINT_UP, 120
    db 7, 12, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    include "track2.asm"

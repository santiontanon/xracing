    org #0000
    include "../constants.asm"
    include "track10-minimap.asm"
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
    db SCROLL_RAIL_DOWN, 16, 1
    db SCROLL_RAIL_DOWN, 32, 1
    db SCROLL_RAIL_DOWN, 48, 1
    db SCROLL_RAIL_DOWN, 64, 1
    db SCROLL_RAIL_DOWN, 80, 1
    db SCROLL_RAIL_LEFT, 0, 0
    db SCROLL_RAIL_UP, 13, 1
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 15, WAYPOINT_UP, 120
    db 14, 7, WAYPOINT_RIGHT, 120
    db 47, 7, WAYPOINT_RIGHT, 120
    db 56, 16, WAYPOINT_DOWN, 100
    db 47, 23, WAYPOINT_LEFT, 100
    db 40, 31, WAYPOINT_DOWN, 90
    db 49, 39, WAYPOINT_RIGHT, 90
    db 56, 46, WAYPOINT_DOWN, 90
    db 56, 49, WAYPOINT_DOWN, 90
    db 47, 55, WAYPOINT_LEFT, 90
    db 40, 62, WAYPOINT_DOWN, 90
    db 40, 65, WAYPOINT_DOWN, 90
    db 48, 71, WAYPOINT_RIGHT, 90
    db 55, 78, WAYPOINT_DOWN, 120
    db 47, 88, WAYPOINT_LEFT, 120
    db 17, 88, WAYPOINT_LEFT, 120
    db 7, 80, WAYPOINT_UP, 120
    db 7, 65, WAYPOINT_UP, 120
    db 7, 46, WAYPOINT_UP, 120
    db 7, 32, WAYPOINT_UP, 120
    db 7, 25, WAYPOINT_UP, 120
    db 7, 16, WAYPOINT_UP, 120
    db 7, 15, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    include "track10.asm"

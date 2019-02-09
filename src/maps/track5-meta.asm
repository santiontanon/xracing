    org #0000
    include "../constants.asm"
    include "track5-minimap.asm"
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
    db SCROLL_RAIL_DOWN, 63, 0
    db SCROLL_RAIL_LEFT, 0, 0
    db SCROLL_RAIL_UP, 48, 0
    db SCROLL_RAIL_UP, 32, 1
    db SCROLL_RAIL_UP, 16, 1
    db SCROLL_RAIL_UP, 13, 1
    db SCROLL_RAIL_LOOP, 0, 0
track_waypoints:
    db 8, 14, WAYPOINT_UP, 120
    db 14, 7, WAYPOINT_RIGHT, 120
    db 31, 7, WAYPOINT_RIGHT, 120
    db 47, 7, WAYPOINT_RIGHT, 120
    db 55, 14, WAYPOINT_DOWN, 120
    db 56, 24, WAYPOINT_DOWN, 120
    db 56, 32, WAYPOINT_DOWN, 120
    db 50, 38, WAYPOINT_LEFT, 120
    db 40, 44, WAYPOINT_DOWN, 90
    db 40, 50, WAYPOINT_DOWN, 90
    db 48, 54, WAYPOINT_RIGHT, 90
    db 55, 61, WAYPOINT_DOWN, 120
    db 47, 70, WAYPOINT_LEFT, 120
    db 32, 71, WAYPOINT_LEFT, 120
    db 15, 71, WAYPOINT_LEFT, 120
    db 8, 63, WAYPOINT_UP, 120
    db 15, 56, WAYPOINT_RIGHT, 120
    db 23, 50, WAYPOINT_UP, 90
    db 23, 44, WAYPOINT_UP, 90
    db 16, 40, WAYPOINT_LEFT, 90
    db 8, 32, WAYPOINT_UP, 120
    db 7, 25, WAYPOINT_UP, 120
    db 7, 16, WAYPOINT_UP, 120
    db 8, 14, WAYPOINT_LOOP, 120
    include "track5.asm"

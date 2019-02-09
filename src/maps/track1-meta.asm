    org #0000
    include "../constants.asm"
    include "track1-minimap.asm"
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
    db SCROLL_RAIL_RIGHT, 16, 0
    db SCROLL_RAIL_DOWN, 63, 1
    db SCROLL_RAIL_RIGHT, 32, 0
    db SCROLL_RAIL_UP, 32, 1
    db SCROLL_RAIL_LEFT, 0, 0
    db SCROLL_RAIL_UP, 13, 1
    db SCROLL_RAIL_LOOP, 0, 0
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
    db 0, 0, 0 ; rail filler
track_waypoints:
    db 7, 15, WAYPOINT_UP, 120
    db 13, 7, WAYPOINT_RIGHT, 120
    db 26, 7, WAYPOINT_RIGHT, 120
    db 32, 13, WAYPOINT_DOWN, 120
    db 32, 34, WAYPOINT_DOWN, 120
    db 32, 44, WAYPOINT_DOWN, 120
    db 32, 65, WAYPOINT_DOWN, 120
    db 39, 71, WAYPOINT_RIGHT, 120
    db 50, 71, WAYPOINT_RIGHT, 120
    db 56, 64, WAYPOINT_UP, 120
    db 56, 46, WAYPOINT_UP, 120
    db 49, 39, WAYPOINT_LEFT, 120
    db 36, 39, WAYPOINT_LEFT, 120
    db 27, 39, WAYPOINT_LEFT, 120
    db 14, 39, WAYPOINT_LEFT, 120
    db 7, 32, WAYPOINT_UP, 120
    db 7, 16, WAYPOINT_UP, 120
    db 7, 15, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    include "track1.asm"

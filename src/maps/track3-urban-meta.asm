    org #0000
    include "../constants.asm"
    include "track3-urban-minimap.asm"
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
    db SCROLL_RAIL_RIGHT, 32, 1
    db SCROLL_RAIL_DOWN, 32, 2
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
    db 7, 11, WAYPOINT_UP, 120
    db 12, 7, WAYPOINT_RIGHT, 120
    db 51, 7, WAYPOINT_RIGHT, 120
    db 31, 7, WAYPOINT_RIGHT, 120
    db 56, 13, WAYPOINT_DOWN, 120
    db 56, 36, WAYPOINT_DOWN, 120
    db 51, 41, WAYPOINT_LEFT, 120
    db 33, 41, WAYPOINT_LEFT, 120
    db 12, 41, WAYPOINT_LEFT, 120
    db 7, 35, WAYPOINT_UP, 120
    db 7, 16, WAYPOINT_UP, 120
    db 7, 11, WAYPOINT_LOOP, 120
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    db 0, 0, 0, 0 ; waypoint filler
    include "track3-urban.asm"

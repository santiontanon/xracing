    org #0000

;-----------------------------------------------
; Stock category races

race_stock_1:
    db "INFINITY    "
    db 0 ; map index (since rome races have the same map) (+12)
    db 1 ; entry price (in $100s)   (+13)
    db 8 ; price money (in $100s)   (+14)
    db 1,2,3  ; opponents           (+15)
    db 0,0,0         ; opponent cars    (+18)
    db 56, 58, 61   ; handycaps         (+21)
    db 0, 0, 0, 3, 0, 1, 2  ; points that drivers not in this race get after playing this race  (+24)
    db "CHEAP, FULL OF ROOKIES. "   ; description 24*3 bytes
    db "A SIMPLE TRACK, BUT ALL "
    db "THE BEST STARTED HERE.  "
race_stock_2:
    db "DOUBLE U    "
    db 1
    db 3 ; entry price (in $100s)
    db 16 ; price money (in $100s)
    db 4,5,6  ; opponents
    db 0,0,0         ; opponent cars
    db 56, 58, 60   ; handycaps
    db 3, 0, 1, 0, 0, 0, 2  ; points that drivers not in this race get after playing this race
    db "A TRACK TO SHOW OFF YOUR"   ; description 24*3 bytes
    db "SKILLS! MOST OPPONENTS  "
    db "CANNOT HANDLE THE CURVES"
race_stock_3:
    db "CITY BLOCK  "
    db 2
    db 4 ; entry price (in $100s)
    db 24 ; price money (in $100s)
    db 1,4,7  ; opponents
    db 0,0,1         ; opponent cars
    db 56, 60, 60   ; handycaps
    db 0, 1, 3, 0, 0, 2, 0  ; points that drivers not in this race get after playing this race
    db "A RACE OF DUBIOUS LEGAL "   ; description 24*3 bytes
    db "STATUS. DONE AT NIGHT IN"
    db "THE CITY STREETS!       "
race_stock_4:
    db "ALLEYCAT    "
    db 3
    db 10 ; entry price (in $100s)
    db 32 ; price money (in $100s)
    db 2,3,7  ; opponents
    db 0,1,1         ; opponent cars
    db 62, 58, 60   ; handycaps
    db 1, 0, 0, 1, 1, 3, 0  ; points that drivers not in this race get after playing this race
    db "A CHALLENGING TRACK ON  "   ; description 24*3 bytes
    db "SMALLER CITY STREETS. A "
    db "CHANCE TO BE NOTICED!   "


;-----------------------------------------------
; Endurance category races

race_endurance_1:
    db "DOUBLE U    "
    db 1
    db 10 ; entry price (in $100s)
    db 32 ; price money (in $100s)
    db 1,2,3  ; opponents
    db 3,3,3         ; opponent cars
    db 56, 59, 62   ; handycaps
    db 0, 0, 0, 2, 0, 1, 3  ; points that drivers not in this race get after playing this race
    db "BE CAREFUL! YOU HAVE    "   ; description 24*3 bytes
    db "ALREADY RACED HERE, BUT "
    db "WITH SLOWER CARS!       "

race_endurance_2:
    db "HOURGLASS   "
    db 4
    db 15 ; entry price (in $100s)
    db 40 ; price money (in $100s)
    db 4,5,6  ; opponents
    db 3,3,3         ; opponent cars
    db 57, 60, 63   ; handycaps
    db 3, 0, 1, 0, 0, 0, 2  ; points that drivers not in this race get after playing this race
    db "FROM NOW ON YOU WILL BE "   ; description 24*3 bytes
    db "FACING BETTER OPPONENTS."
    db "REMEMBER TO BRAKE, OK?  "

race_endurance_3:
    db "ALLEYCAT    "
    db 3
    db 20 ; entry price (in $100s)
    db 48 ; price money (in $100s)
    db 1,4,7  ; opponents
    db 3,3,4         ; opponent cars
    db 59, 61, 61   ; handycaps
    db 0, 1, 3, 0, 0, 2, 0  ; points that drivers not in this race get after playing this race
    db "IT WASN'T EASY, BUT I   "   ; description 24*3 bytes
    db "GOT YOU IN THIS RACE. DO"
    db "NOT DISAPPOINT ME!      "

race_endurance_4:
    db "METROPOLIS  "
    db 5
    db 24 ; entry price (in $100s)
    db 64 ; price money (in $100s)
    db 2,3,7  ; opponents
    db 3,4,4         ; opponent cars
    db 63, 61, 63   ; handycaps
    db 1, 0, 0, 1, 1, 3, 0  ; points that drivers not in this race get after playing this race
    db "OK, THIS IS IT. THE BEST"   ; description 24*3 bytes
    db "DRIVERS ARE HERE. KICK  "
    db "THEIR ASSES!            "


;-----------------------------------------------
; Formula 1 category races

race_f1_1:
    db "ST. JUNIPERO"
    db 6
    db 50 ; entry price (in $100s)
    db 100 ; price money (in $100s)
    db 1,2,3  ; opponents
    db 6,6,6         ; opponent cars
    db 57, 59, 62   ; handycaps
    db 0, 0, 0, 0, 1, 2, 3  ; points that drivers not in this race get after playing this race
    db "THE SEASON OPENER IS NOT"   ; description 24*3 bytes
    db "A HARD TRACK. USE IT AS "
    db "A LEARNING EXPERIENCE.  "

race_f1_2:
    db "ZION        "
    db 7
    db 50 ; entry price (in $100s)
    db 100 ; price money (in $100s)
    db 4,5,6  ; opponents
    db 6,6,6         ; opponent cars
    db 58, 60, 62   ; handycaps
    db 2, 0, 1, 0, 0, 0, 3  ; points that drivers not in this race get after playing this race
    db "EVEN THE BEST GET CONFU-"   ; description 24*3 bytes
    db "SED IN THIS ONE. TAKE   "
    db "THE PROPER PATH, OK?    "

race_f1_3:
    db "HOURGLASS   "
    db 4
    db 50 ; entry price (in $100s)
    db 100 ; price money (in $100s)
    db 1,4,7  ; opponents
    db 6,6,7         ; opponent cars
    db 58, 60, 61   ; handycaps
    db 0, 0, 1, 0, 2, 3, 0  ; points that drivers not in this race get after playing this race
    db "YOU KNOW THIS ONE. JUST "   ; description 24*3 bytes
    db "MIND F-1 CAR SPEEDS!    "
    db "                        "

race_f1_4:
    db "METROPOLIS  "
    db 5
    db 50 ; entry price (in $100s)
    db 100 ; price money (in $100s)
    db 2,5,7  ; opponents
    db 6,7,7         ; opponent cars
    db 58, 59, 62   ; handycaps
    db 0, 0, 1, 2, 0, 3, 0  ; points that drivers not in this race get after playing this race
    db "STAY OUT OF THE WALLS!  "   ; description 24*3 bytes
    db "BETTER TO GO SLOW THAN  "
    db "TO CRASH!               "

race_f1_5:
    db "QUAHOG      "
    db 8
    db 50 ; entry price (in $100s)
    db 100 ; price money (in $100s)
    db 1,3,6  ; opponents
    db 7,7,8         ; opponent cars
    db 59, 60, 61   ; handycaps
    db 0, 0, 0, 1, 2, 0, 3  ; points that drivers not in this race get after playing this race
    db "BRAKE IF YOU NEED TO OK?"   ; description 24*3 bytes
    db "THE NARROW PARTS ARE NOT"
    db "MADE FOR F-1!           "

race_f1_6:
    db "CORUSCANT   "
    db 9
    db 50 ; entry price (in $100s)
    db 100 ; price money (in $100s)
    db 2,3,4  ; opponents
    db 7,8,8         ; opponent cars
    db 60, 60, 62   ; handycaps
    db 0, 0, 0, 0, 1, 2, 3  ; points that drivers not in this race get after playing this race
    db "A LOT OF PEOPLE COME TO "   ; description 24*3 bytes
    db "SEE THIS ONE! SO, DO A  "
    db "GOOD JOB!               "

race_f1_7:
    db "TRANTOR     "
    db 10
    db 50 ; entry price (in $100s)
    db 100 ; price money (in $100s)
    db 5,6,7  ; opponents
    db 8,8,8         ; opponent cars
    db 58, 60, 62   ; handycaps
    db 0, 1, 2, 3, 0, 0, 0  ; points that drivers not in this race get after playing this race
    db "THE TITLE DECIDER!! DO  "   ; description 24*3 bytes
    db "NOT FAIL!! YOU WILL NOT "
    db "HAVE ANOTHER CHANCE!!   "


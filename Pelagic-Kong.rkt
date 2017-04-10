#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require lang/posn)

;(define (posn-x p)
 ; (car p))

;************
; CONSTANTS
;************
;;defines constants used in the making of the worlds
;;need to be changed to functions to build the actually SPLASH_SCREEN, Game-stage, etc



(define START (make-posn 350 300))
(define CLEAR (make-color 100 100 100 0))
(define BACKGROUND (square 400 "solid" "Medium Aquamarine"))
(define NORMAL (text "NORMAL" 14 "RED"))
(define LASER-SHARKS (text "SHARKS-WITH-LASERBEAMS" 14 "RED"))
(define HIGHLIGHT (rectangle 200 15 "solid" "yellow"))
(define SHARKNADO (text "SHARK-NADO" 14 "RED"))
(define spout
    (polygon (list (make-posn 18 70)
                   (make-pulled-point 1/2 -20 3 20 2/3 -70)
                   (make-pulled-point 1/2 45 22 13 1/2 -45)
                   (make-pulled-point 1/2 70 47 19 1/2 20)
                   (make-posn 32 70))
                 "solid"
                  "White"))

(define waves
  (scene+polygon
  (scene+polygon (polygon (list (make-posn 0 17)
                                (make-pulled-point 1/2 -30 9 10 1/2 30)
                                (make-pulled-point 1/2 -30 27 11 1/2 30)
                                (make-pulled-point 1/2 -30 46 8 1/2 30)
                                (make-posn 50 17)
                                (make-posn 50 25)
                                (make-posn 0 25))
                          "solid"
                          "SeaGreen")
   (list (make-posn 0 8)
                       (make-pulled-point 1/2 -30 11 5 1/2 30)
                       (make-pulled-point 1/2 -30 29 5 1/2 30)
                       (make-pulled-point 1/2 -30 47 2 1/2 30)
                       (make-posn 50 8)
                       (make-posn 50 25)
                       (make-posn 0 25))
                  "solid"
                  "White")
  (list (make-posn 0 9)
                       (make-pulled-point 1/2 -30 9 6 1/2 30)
                       (make-pulled-point 1/2 -30 27 6 1/2 30)
                       (make-pulled-point 1/2 -30 46 3 1/2 30)
                       (make-posn 50 9)
                       (make-posn 50 25)
                       (make-posn 0 25))
                  "solid"
                  "Medium AquaMarine"))

(define FLOOR_TILE
  (place-image waves
               25 67
               (rectangle 50 75 "outline" CLEAR)))

(define SPOUT_TILE
  (place-image
   (overlay/align "middle" "bottom"
                  waves
                  spout)
   25 47 (rectangle 50 75 "outline" CLEAR)))
(define SPLASH_SCREEN (text "Splash Screen" 12 "red"))
(define SEA (text "Game-Play" 10 "blue"))
(define ELSE (text "Other choice" 10 "blue"))

;*************
;Images Defined
;*************

;;Shark
(define sharkfin
  (overlay/align "center" "bottom"
                 (rectangle 25 72 "outline" CLEAR)
                 (polygon
                  (list (make-pulled-point 1/2 -20 0.5 0.5 1/3 -55) ;;top point
                 (make-pulled-point 1/2 30 25 32 1/3 0)  ;;right bottom corner
                 (make-pulled-point 1/2 0 0 32 1/2 20)) ;;left bottom corner
                  "solid"
                 "DarkGray")
                 (polygon
                  (list (make-pulled-point 1/2 -20 0 0 1/4 -35) ;;top point
                 (make-pulled-point 1/2 30 25 32 1/3 0)  ;;right bottom corner
                 (make-pulled-point 1/2 0 0 32 1/2 20)) ;;left bottom corner
                  "solid"
                  "DimGray")
                 (polygon
                  (list (make-pulled-point 1/2 -20 0.5 0.5 1/3 -55) ;;top point
                 (make-pulled-point 1/2 30 25 32 1/3 0)  ;;right bottom corner
                 (make-pulled-point 1/2 0 0 32 1/2 20)) ;;left bottom corner
                  "outline"
                 (make-pen "Dark Slate gray" 1 "solid" "butt" "miter"))))


;****************
;;Walley Character images and draw-functions
;****************
(define (draw-walley mood)
   ;;face
  (define happy-face
      (add-line
       (add-line
        (add-curve        
         (polygon (list (make-pulled-point 1/2 45 0 0 1/2 -45) ;;top point
                        (make-pulled-point 1/2 45 40 40 1/2 -45) ;;right middle
                        (make-pulled-point 1/2 45 0 80 0 0)  ;;bottom middle
                        (make-pulled-point 3/4 10 -44 76 5/6 10) ;;left bottom corner
                        (make-pulled-point 1/4 0 -40 40 1/2 -45)) ;;left middle
                  "solid"
                  "SkyBlue")
         35 50 -30 1/2 60 50 30 1/2 "darkblue")
        7 65 0 80 "darkblue")
       15 75 0 80 "darkblue"))
  (define sad-face
      (add-line
       (add-line
        (add-curve        
         (polygon (list (make-pulled-point 1/2 45 0 0 1/2 -45) ;;top point
                        (make-pulled-point 1/2 45 40 40 1/2 -45) ;;right middle
                        (make-pulled-point 1/2 45 0 80 0 0)  ;;bottom middle
                        (make-pulled-point 3/4 10 -44 76 5/6 10) ;;left bottom corner
                        (make-pulled-point 1/4 0 -40 40 1/2 -45)) ;;left middle
                  "solid"
                  "SkyBlue")
         35 50 30 1/2 60 50 -30 1/2 "red")
        7 65 0 80 "darkblue")
       15 75 0 80 "darkblue"))
  (define face
    (cond
    ((eq? mood 'happy) happy-face)
    ((eq? mood 'swimming) happy-face)
    (else sad-face)))  
  (define eye-r (overlay/offset (circle 5 "solid" "white")
                  -3 1
                  (circle 9 "solid" "RoyalBlue")))
  (define eye-l (overlay/offset (circle 5 "solid" "white")
                  -3 1
                  (circle 9 "solid" "RoyalBlue")))

  (define horn (rotate -30 (right-triangle 20 45 "solid" "burlywood")))

  ;;create closed polygon using list of posn's(x y), points in clockwise order
  (define tail
    (rotate 30 
            (polygon (list (make-pulled-point 1/2 10 30 10 1/2 -10) ;;middle tail point
                           (make-pulled-point 1/2 45 60 10 3/4 45) ;;right tail point
                           (make-pulled-point 1/2 -10 40 70 1/2 -20) ;;body tail point
                           (make-pulled-point 1/2 -20 0 10 1/2 -45)) ;;left tail point
                     "solid"
                     "CornflowerBlue")))
  (define body
    (polygon (list (make-pulled-point 1/2 45 0 0 1/2 -45) ;;top point
                   (make-pulled-point 1/2 45 40 40 1/2 -45) ;;right middle
                   (make-pulled-point 1/2 45 -20 100 0 0)  ;;bottom middle
                   (make-pulled-point 3/4 10 -70 85 5/6 5) ;;left bottom corner
                   (make-pulled-point 1/2 -20 -40 40 1/2 -45)) ;;left middle
             "solid"
             "CornflowerBlue"))

  (define face-posn
    (make-posn 112 85))
  (define eye-r-posn
    (make-posn 100 70))
  (define eye-l-posn
    (make-posn 145 68))
  (define horn-posn
    (make-posn 120 35))
  (define body-posn
    (make-posn 98 95))
  (define tail-posn
    (make-posn 35 110))

  ;;underlays images in order of list
  (place-images
   (list eye-r eye-l horn face tail body)
   (list eye-r-posn eye-l-posn horn-posn face-posn tail-posn body-posn)
   (rectangle 170 150 "outline" CLEAR)))

;;constants for walley
(define happy-walley
 (draw-walley 'swimming))
(define sad-walley
 (draw-walley 'dead))

(define (swim mood direction)
  (if (eq? direction "left")
      (flip-horizontal (draw-walley mood))
      (draw-walley mood)))

(define (move_walley p pe)
  (cond
    ((eq? pe "right") (make-player (player-state p) (make-posn (+ 10 (posn-x (player-position p))) (posn-y (player-position p))) "right" (player-lives p)))
    ((eq? pe "left") (make-player (player-state p) (make-posn (- 10 (posn-x (player-position p))) (posn-y (player-position p))) "left" (player-lives p)))))

;;**********
;;  Enemy Struct
;;**********

;;define/contract struct for emeny shark.
;;
(define-struct/contract shark ([state (or/c 'killing 'dead)]
                               [p (or/c #f posn?)]
                               [difficulty any/c]
                               [speed any/c]))

;;draw-enemires funtion takes the difficulty setting of the level to create a list of shark items
;;
  (define (draw-enemies d n)
    (map (lambda (p) (make-shark 'killing p d n))
         (for/list ([i (in-range 0 (* n 2))])
           (cond
             ((eq? n 1) (make-posn 20 (* (+ i 2) (/ 300 4))))
             (else (make-posn 20 (* (+ i 2) (/ 300 4))))))))
     
  

;***********
; MENU display
;***********
;BEHOLD-Menu- contains list of menu components, list of menu posns
;places components at posns in order to display info to user
;; need to change placeholder text for actual info from player $ world objects
(define (render-splashscreen s)
   (place-images
     (list
      (text "Pelagic-Kong" 40 "cyan")
      (text "SCORE" 18 "green")
      (text (number->string (world-score s)) 18 "green")
      (text "DIFFICULTY:" 18 "black")
      NORMAL
      LASER-SHARKS
      SHARKNADO
      HIGHLIGHT
      (text "Press shift for help" 16 "green")
      (text "Press Space to Start Game" 16 "Cyan"))
     (list (make-posn 200 20)
           (make-posn 175 70)
           (make-posn 215 70)
           (make-posn 200 100)
           (make-posn 200 115)
           (make-posn 200 130)
           (make-posn 200 145)
           (highlight_difficulty (world-difficulty s))
           (make-posn 200 175)
           (make-posn 200 190))
     BACKGROUND))

;;function to highlight difficulty level
(define (highlight_difficulty d)
  (cond
    ((eq? d 1) (make-posn 200 115))
    ((eq? d 10) (make-posn 200 130))
    ((eq? d 100) (make-posn 200 145))
    (else (make-posn 200 115))))

;;function to return stage number from difficulty level
(define (stage_number d)
  (cond
    ((< d 10) d)
    ((< d 100) (/ d 10))
    ((< d 1000) (/ d 100))))
               
;***********
; HELP Screen
;***********
(define (render-helpscreen s)
   (place-images
     (list
      (text "Pelagic-Kong" 40 "cyan")
      (text "Goal: Reach the rainbow without getting eaten by a shark" 16 "green")
      (text "Controls: Arrow Keys or WASD to move." 16 "green")
      (text "To change the difficulty use the arrow keys while at the splash screen" 12 "green")
      (text "While playing press SPACE to exit to splash screen" 12 "green")
      (text "Press SPACE to return to Splash Screen" 20 "cyan"))
     (list (make-posn 200 20)
           (make-posn 200 50)
           (make-posn 200 80)
           (make-posn 200 110)
           (make-posn 200 140)
           (make-posn 200 170))
     BACKGROUND))


;**********
; Build Boards
;**********
(define STAGE-ONE
  (list 14 18 24 29))
;@Stilsonkl: change to loop to create list
(define STAGE-ONE-POSN
  (list (make-posn 25 75) (make-posn 75 75) (make-posn 125 75) (make-posn 175 75) (make-posn 225 75) (make-posn 275 75) (make-posn 325 75) (make-posn 375 75)
        (make-posn 25 150) (make-posn 75 150) (make-posn 125 150) (make-posn 175 150) (make-posn 225 150) (make-posn 275 150) (make-posn 325 150) (make-posn 375 150) 
        (make-posn 25 225) (make-posn 75 225) (make-posn 125 225) (make-posn 175 225) (make-posn 225 225) (make-posn 275 225) (make-posn 325 225) (make-posn 375 225) 
        (make-posn 25 300) (make-posn 75 300) (make-posn 125 300) (make-posn 175 300) (make-posn 225 300) (make-posn 275 300) (make-posn 325 300) (make-posn 375 300)))

;;builds a list of tiles based on pre-defined stage list
;makes list of t/f the size of x*y
;makes list of positions based on x*y and window size
;uses map to create list of tiles using list of t/f and posns
(define (build-board diff-level)
  (let* ([x 8]
         [y 4])
    (map (lambda (b) (make-tile b))
         (for/list ([i (in-range 0 (* x y))])
           (if (member i STAGE-ONE) #t #f)))))

;************
; HUD
;************
;;displays important player info: lives left, score, stage number,
;@Jacob-Phillips : possible a time counter?
;;
(define HUD-AREA (rectangle 400 50 "solid" CLEAR))
;;(define HEART (circle 5 "solid" "pink"))
(define HEART (freeze (scale 1/5 happy-walley)))
;;returns scene with info loaded on HUD-AREA
(define (draw-HUD l diff sc)
  ;create list of component and positions
  (define hud-comp
    (append (for/list ([i (in-range 0 l)])
                HEART)
             (list (text "STAGE:" 22 "black")
                   (text (number->string (stage_number diff)) 22 "black")
                   (cond
                     ((< diff 10) NORMAL)
                     ((< diff 100) LASER-SHARKS)
                     ((< diff 1000) SHARKNADO))                      
                   (text "SCORE:" 14 "Black")
                   (text (number->string sc) 14 "black"))))
  (define hud-posn
    (append (for/list ([i (in-range 1 (+ l 1))])
               (make-posn (* i 30) 20))
            (list (make-posn 175 20)
                  (make-posn 225 20)
                  (make-posn 200 40)
                  (make-posn 325 20)
                  (make-posn 370 20))))
  (place-images  hud-comp hud-posn HUD-AREA))

;************
; Tile Struct
;************
;;defines struct for tiles
(define-struct/contract tile ([up? boolean?])
  #:transparent)

;;map to determine what image tile to place on the background based on list passed from build-board
(define (place-tiles t)
  (map (lambda (n) (if(tile-up? n) SPOUT_TILE FLOOR_TILE))
       t))  

;***********
; Player Struct
;***********
;;defines and contracts the player object
;;needs to be expanded to include player characteristics
;;this definition type automatically creates:
;  constructor= (make-player state position lives)
;  eq test= player?
;  fields= player-state, player-position, player-lives
(define-struct/contract player ([state (or/c 'swimming
                                             'dead)]
                               [position (or/c #f posn?)]
                               [direction (or/c "right"
                                                "left")]
                               [lives (or/c 0 1 2 3)])
  #:transparent)

;***********
; STAGES
;***********
;;BEHOLD-Stage function that takes info from the player in order to build the stage
;  for game-play
;;
(define (BEHOLD-Stage diff p sc)
  (define st 
  (make-stage 'start diff (draw-enemies diff (stage_number diff)) (swim (player-state p) (player-direction p)) (draw-HUD (player-lives p) diff sc) (build-board diff)))
  ;;@Stilsonkl draw sharks using underlay instead of place-image
  ;;add components to list
  (define stage-comp
    (append (append (append (list (stage-HUD st)) (place-tiles (stage-board st))) (for/list ([i (stage-Enemies st)])
                             sharkfin) (list (scale (* 1/2 (stage_number diff)) (swim 'happy 'left))))))
  (define stage-posn
    (append (append (append (list (make-posn 200 37)) STAGE-ONE-POSN) (for/list ([i (stage-Enemies st)])
                           (shark-p i)) (list START))))
  ;;draw stage components
  (place-images stage-comp stage-posn BACKGROUND))
  

;***********
; Stage Struct
;***********
;;defines and contracts the player object
;;needs to be expanded to include player characteristics
;;this definition type automatically creates:
;  constructor= (make-stage state dif Walley HUD Board)
;  eq test= stage?
;  fields= stage-state, stage-difficulty, stage-Walley, stage-HUD, stage-board
(define-struct/contract stage ([state (or/c 'start
                                            'dead
                                            'won
                                            'lost)]
                               [difficulty any/c]
                               [Enemies (listof shark?)]
                               [Walley any/c]
                               [HUD any/c]
                               [board (listof tile?)])
  #:transparent)



;************
;WORLD-STRUCT
;************
;;defines and contracts the world object
;;needs to be expanded to include: stage-board(board object), player(player object), player-posn(posn)
;;this definition type automatically creates:
;  constructor= (make-world state player)
;  eq test= world?
;  fields= world-state, world-player

(define-struct/contract world ([state (or/c 'splash_screen
                                            'playing
                                            'lost
                                            'help_screen)]
                               [player (or/c #f player?)]
                               [difficulty any/c]
                               [score any/c])
  #:transparent)

;**************
;Pad input
;**************
;change handles keyboard input from user
;starts game by calling make-world with new state
; @Jacob-Phillips - can expand to include other menu options
; can change to pad-event instead of key-event
(define (change s pe)
  (cond
    ;;AT SPLASH SCREEN
    ((and (pad=? pe " ") (equal? (world-state s) 'splash_screen)) (make-world 'playing (world-player s) (world-difficulty s) (world-score s)))
    ((and (pad=? pe "rshift") (equal? (world-state s) 'splash_screen)) (make-world 'help_screen (world-player s) (world-difficulty s) (world-score s)))
    ((and (pad=? pe "shift") (equal? (world-state s) 'splash_screen)) (make-world 'help_screen (world-player s) (world-difficulty s) (world-score s)))
    ((and (pad=? pe "up") (equal? (world-state s) 'splash_screen))(cond
                                                                    ((eq? (world-difficulty s) 1) (make-world 'splash_screen (world-player s) 100 (world-score s)))
                                                                    ((eq? (world-difficulty s) 10) (make-world 'splash_screen (world-player s) 1 (world-score s)))
                                                                    ((eq? (world-difficulty s) 100) (make-world 'splash_screen (world-player s) 10 (world-score s)))))
    ((and (pad=? pe "down") (equal? (world-state s) 'splash_screen))(cond
                                                                    ((eq? (world-difficulty s) 1) (make-world 'splash_screen (world-player s) 10 (world-score s)))
                                                                    ((eq? (world-difficulty s) 10) (make-world 'splash_screen (world-player s) 100 (world-score s)))
                                                                    ((eq? (world-difficulty s) 100) (make-world 'splash_screen (world-player s) 1 (world-score s)))))
    ;;AT HELP SCREEN
    ((and (pad=? pe "rshift") (equal? (world-state s) 'help_screen)) (make-world 'splash_screen (world-player s) (world-difficulty s) (world-score s)))
    ;;AT PLAYING SCREEN
    ((and (pad=? pe "rshift") (equal? (world-state s) 'playing)) (make-world 'splash_screen (world-player s) (world-difficulty s) (world-score s)))
    ((and (pad=? pe "shift") (equal? (world-state s) 'playing)) (make-world 'splash_screen (world-player s) (world-difficulty s) (world-score s)))
    ((and (pad=? pe "right") (equal? (world-state s) 'playing)) (BEHOLD-Stage (world-difficulty s) (move_walley (world-player s) pe) (world-score s)))
    ((and (pad=? pe "left") (equal? (world-state s) 'playing)) (BEHOLD-Stage (world-difficulty s) (move_walley (world-player s) pe) (world-score s)))
    (else s)))

 ;;make worlds
;;make-initial-world(create the splash_screen)
(define (make-water-world)
  (make-world 'splash_screen (make-player 'swimming START "left" 3) 1 0))

;;render-world
;;draws the world based on the state of the world
;;must take a world-state as an arg because it is called in 'big-bang'
; result of condition needs to be expanded to include functions
(define (render-world s)
  (cond
    ((equal? (world-state s) 'splash_screen) (render-splashscreen s))
    ((equal? (world-state s) 'help_screen) (render-helpscreen s))
    ((equal? (world-state s) 'playing) (BEHOLD-Stage (world-difficulty s) (world-player s) (world-score s)))
    ((equal? (world-state s) 'lost) (place-image SEA 150 150 BACKGROUND))
    (else (place-image ELSE 50 50 BACKGROUND))))


;;***********
;;main driver
;;***********
;;defines main funtion(no args)
; calls big-bang with initial state of (make-water-world) which initially creates the splash_screen
; each clause in big-bang must take the state of the world as an arg, and returns a new state
  (define (main)
  (big-bang (make-water-world)
    [to-draw render-world]
    [name "Pelagic-Kong"]
    [on-pad change]
    [close-on-stop #t]))

(main)
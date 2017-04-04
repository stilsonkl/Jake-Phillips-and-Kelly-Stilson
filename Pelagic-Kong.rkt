#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(require lang/posn)

;************
; CONSTANTS
;************
;;defines constants used in the making of the worlds
;;need to be changed to functions to build the actually SPLASH_SCREEN, Game-stage, etc
(define START (make-posn 200 200))
(define BACKGROUND (empty-scene 250 250))
(define SPLASH_SCREEN (text "Splash Screen" 12 "red"))
(define SEA (text "Game-Play" 10 "blue"))
(define ELSE (text "Other choice" 10 "blue"))


;***********
; MENU display
;***********
;BEHOLD-Menu- contains list of menu components, list of menu posns
;places components at posns in order to display info to user
;; need to change placeholder text for actual info from player $ world objects
(define (BEHOLD-Menu)
   (place-images
     (list
      (text "SPLASH SCREEN" 20 "cyan")
      (text "SCORE" 12 "green")
      (text "0" 12 "green")
      (text "LIVES" 12 "blue")
      (text "3" 12 "blue")
      (text "Press Space to Start Game" 16 "Cyan"))
     (list (make-posn 125 20) (make-posn 50 50) (make-posn 50 70) (make-posn 100 50) (make-posn 100 70) (make-posn 125 125))
     BACKGROUND))
  
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
                                            'win
                                            'dead)]
                               [position (or/c #f posn?)]
                               [lives (or/c 0 1 2 3)])
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
                                            'lost)]
                               [player (or/c #f player?)])
  #:transparent)

;**************
;Keyboard input
;**************
;change handles keyboard input from user
;starts game by calling make-world with new state
; @Jacob-Phillips - can expand to include other menu options
; can change to pad-event instead of key-event
(define (change s ke)
  (cond
    ((and (key=? ke " ") (equal? (world-state s) 'splash_screen)) (make-world 'playing (make-player 'swimming START 3)))
    (else s)))

 ;;make worlds
;;make-initial-world(create the splash_screen)
(define (make-water-world)
  (make-world 'splash_screen (make-player 'swimming (make-posn 500 500) 3)))

;;render-world
;;draws the world based on the state of the world
;;must take a world-state as an arg because it is called in 'big-bang'
; result of condition needs to be expanded to include functions
(define (render-world s)
  (cond
    ((equal? (world-state s) 'playing) (place-image SEA 200 200 BACKGROUND))
    ((equal? (world-state s) 'lost) (place-image SEA 150 150 BACKGROUND))
    ((equal? (world-state s) 'splash_screen) (BEHOLD-Menu))
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
    [on-key change]
    [close-on-stop #t]))

(main)
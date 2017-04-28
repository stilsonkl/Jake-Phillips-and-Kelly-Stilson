# Pelagic-Kong
### Kelly Stilson
### Overview
Our project is a game in the style/inspired by Donkey Kong. 
This is personal for us because Jacob's girlfriends', grand-father helped to develop the original Donkey Kong 
and Kelly has played it a couple times.
It is interesting because we both wrote similar games in C++ for previous courses and we used those games as inspiration.

### Librries used:
```racket
(require 2htdp/image)
(require 2htdp/universe)
(require lang/posn)
```

- 2htdp/universe: provided the `big-bang` function that was used as the driver for the game.  
  Included in this are:
  
  `(on-tick <proc> s)` : takes a procedure as an arg, and applies that procedure to the state of the world. Ticks 28 times a second. used for time keeping which facilitated movement.
  
  `(on-draw <proc> s)` : takes a procedure as an arg and applies it to the state of the world, procedure must return an image object. Called every time the universe handles an event. used to render the stage after every tick, and every key-press.
 
  `(on-key <proc> s)` : takes a procedure as an arg and applies it to the state of the world, passing along the key-event that triggered it. This is how keyboard input was handled.

  `(on-pad <proc> s)` : similar to on-key, but limited to only pad-keys. we limited keyboard input during game-play to just the pad keys. this also automatically included an image placed on the bottom of the screen reminding players of the movement keys.
 
- 2htdp/images: all of the image functions: drawing lines, angles, curves, and shapes; rotate, scale, and flip image functions. `place-image`, which places one image on another; `place-images`, which maps through two lists, one of images and one of posns, to place the images at those posns, `overlay`/`underlay` which allowed me to place images in layers. Also all the text, font and color formatting functions.




### Using Recursion and Map to build the game board:

A couple recursive functions were used to create the board, or the background of each stage. The background is a list of tile objects implemented in such a way as to form a matrix, with each tile having an x and y position on the board. To create a tile object, the program needs to know if it is a spout tile (#t/#f) and its position on the baackground. It stored the position of the tile so that it can be referenced during gameplay to verify that the player is on, or near, a water spout tile in order to move up to the next 'floor.'

The stage starts out as a list of integers which represent the numbered position in the board matrix that the spouts should be placed.
```racket    
;spout list ;returns list of integers
(define (spout-list d) 
  (let ([l (stage_number d)])  
(cond ((eq? l 1) (list 14 19 21 25 32 40 46))  
     ((eq? l 2) (list 17 21 28 35 41 46))    
     ((eq? l 3) (list 19 25 30 39 45)) 
     ((eq? l 4) (list 15 24 26 33 37 42 48)) 
     ((eq? l 5) (list 13 17 25 33 37 44 45 46))  
     ((eq? l 6) (list 12 18 23 36 45)) 
     ((eq? l 7) (list 16 21 29 35 47)) 
     ((eq? l 8) (list 13 25 37 49))  
     ((eq? l 9) (list 14 18 21 29 33 46))  
     (else (list 14 18 24 29)))))  
                                         
(define-struct/contract tile ([up? boolean?] 
                             [position any/c]) 
 #:transparent)                                
```                                            
The tile-posn-list is a list of posn objects created using two recursive functions. The first being build-posn-list, which takes an x value, y value and a list. This function creates the 'rows' of the board. If the y-value argument is too small to fit another tile, then the list is returned, if not, then it calls itself again, altering the y-value and calling the make-wide function. 
```racket
(define (tile-posn-list d)
  (build-posn-list (posn-x WINDOW) (- (posn-y WINDOW) TILE_HEIGHT) '()))

(define (build-posn-list x y l)
  (if (< y TILE_HEIGHT) l
      (build-posn-list x (- y TILE_HEIGHT) (make-wide x (- y TILE_HEIGHT) l))))
      
(define (make-wide x y l)
  (if (eq? 0 x) l
      (make-wide (- x TILE_WIDTH) y 
                    (append (list (make-posn (- x (quotient TILE_WIDTH 2)) (+ y (quotient TILE_HEIGHT 2)))) l))))
```
The make-wide function creates the posn's for the columns of the board. If the x-value argument reaches 0 then it will return the list, if not, it will call the function again, decreasing the x-value by the width of a tile, and appending a new posn to the list.

The build-board function only takes the difficulty level of the stage as an argument. It uses let\* to determine the number of rows and columns required in the board matrix based on the size of the window and the size of the tiles. 
*Note: this functionality was built-in incase we got to the point of creating more difficult levels where there were more "floors," or rows of tiles, and would therefore have to scale the size of the tile.*
It then maps through the list of #t/#f values for determining the type of tile, and the list of positions, created recursively, and calls the tile constructor, to return a list of tiles. 
```racket
;;builds a list of tiles based on stage list
;makes list of t/f the size of x*y
;makes list of positions based on x*y and window size
;uses map to create list of tile objects
(define (build-board diff-level)
  (let* ([x (/ (posn-x WINDOW) TILE_WIDTH)]
         [y (quotient (- (posn-y WINDOW) TILE_HEIGHT) TILE_HEIGHT)])
    (map (lambda (s p) (make-tile s p))
         (for/list ([i (in-range 0 (* x y))])
           (if (member i (spout-list diff-level)) #t #f))
         (tile-posn-list diff-level))))
```
This board, a list a tile objects is a part of the stage and later drawn, producing the background(shown below with frames on tiles):
<img src="images/tile_frame.PNG" alt="Background tiles" width="200"/> 


###Drawing Images using Recursion
The tornado base of the Sharknado is actually an ellipse drawn recursively based on the number passed to the function.*Note: Again, this was done so that we could scale the image based on the window size*
The `draw-sharknado` function takes an image and an integer size as args. It uses let\* to assign local variables used to draw each ellipse. The changes in these variables give the tornado dimension. Using a random number in a small range is what gave the illusion of the tornado twisting when it was redrawn every 1/28th of a second. As long as the size was not zero, it overlayed another ellipse ontop of the image, altering the length, width and offset. Once the size arg reached zero it returned the image created. 
The sharkfins are placed on the tornado afterwards. 
```racket
; takes image and qty as args
; recursive call to draw next shape in image
; returns image object
 (define (draw-sharknado image s)
   (let* ([angle (if (zero? (remainder s 3)) 0 -2)]
          [color (if (zero? (remainder s 5)) dark-wind light-wind)]
          [x-offset (if (zero? (remainder s 3)) (- 0 (random 1 10)) (random 1 10))]
          [y-offset (random 4 6)]
          [width (* s 7)]
          [height (* 10 (ceiling (/ width 100)))])
   (cond ((zero? s) image)
         ((overlay/align/offset "center" "top"
                                (rotate angle (ellipse width height "solid" color))
                                x-offset y-offset
                                (draw-sharknado image (sub1 s)))))))
```
<img src="images/Recursive_tornado.PNG" alt="Recursive tornado" width="300"/>


### Map/Fold/Filter

The board, a list of tiles, was created using a map function to generate a list of tile objects. 

The enemies, or list of sharks, was created using a map function based on the difficulty level and stage number.

Fold was used to detect object collision between the player character and the list of enemies. 

We used state modification to maintain the state of game-play and pass messages between the world, stage and other objects.

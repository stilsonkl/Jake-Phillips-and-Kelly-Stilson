# Pelagic-Kong
### Kelly Stilson
### Overview
Our project is a game in the style/inspired by Donkey Kong. 
The first screen that displays is a splash screen, where it allows the player to select the difficulty for the game, view the help screens, or start the game. The help screens display instructions for game-play, movement keys, the goal and different aspects of game play.
Once starting the game, the goal is to get the character sprite up the water spouts to the rainbow, without encountering any sharks. If the character gets too close to a shark, it dies, loses a life, and starts back at the start postition of the stage. 
If the character reaches the rainbow, the player advances to the next stage. If the player loses all their lives it is game-over, and they are returned to the splash-screen. If the player continues to win, the stages get more difficult. The number of sharks increases, their direction varies, and their speed increases. The player is however, offered super-powers, which assist them in the more difficult levels. An armored horn makes the character impervious to shark attacks, and catching a fish give the player an extra life. 
If a player is just too-good, they advance from the normal difficulty to sharks-with-laser-beams, which can kill the character from farther away. The next difficulty level is Sharknado, where a tornado of sharks drops random sharks on the stage.

### Libraries used:
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

- lang/posn : provided the `make-posn` constructor, as well as equality tests, and accessors for the x and y portions of the posn


### Using Recursion and Map to build the game board:

A couple recursive functions were used to create the board, or the background of each stage. The background is a list of tile objects implemented in such a way as to form a matrix, with each tile having an x and y position on the board. To create a tile object, the program needs to know if it is a spout tile (#t/#f) and its position on the baackground. It stored the position of the tile so that it can be referenced during gameplay to verify that the player is on, or near, a water spout tile in order to move up to the next 'floor.'

The stage starts out as a list of integers which represent the numbered position in the board matrix that the spouts should be placed.
```racket    
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
(define (build-board diff-level)
  (let* ([x (/ (posn-x WINDOW) TILE_WIDTH)]
         [y (quotient (- (posn-y WINDOW) TILE_HEIGHT) TILE_HEIGHT)])
    (map (lambda (s p) (make-tile s p))
         (for/list ([i (in-range 0 (* x y))])
           (if (member i (spout-list diff-level)) #t #f))
         (tile-posn-list diff-level))))
```
This board, a list of tile objects, is a part of the stage and later drawn, producing the background(shown below with frames on tiles):

<img src="images/tile-frame.PNG" alt="Background tiles" width="200"/> 


### Drawing Images using Recursion
The tornado base of the Sharknado is actually an ellipse drawn recursively based on the number passed to the function.*Note: Again, this was done so that we could scale the image based on the window size*
The `draw-sharknado` function takes an image and an integer size as args. It uses let\* to assign local variables used to draw each ellipse. The changes in these variables give the tornado dimension. Using a random number in a small range is what gave the illusion of the tornado twisting when it was redrawn every 1/28th of a second. As long as the size was not zero, it overlayed another ellipse ontop of the image, altering the length, width and offset. Once the size arg reached zero it returned the image created. 
The sharkfins are placed on the tornado afterwards. 
```racket
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

<img src="images/Recursive_tornado.png" alt="Recursive tornado" width="300"/>


### Filtering out unwanted elements
In the `BEHOLD-stage` funtion that renders all the images for each stage, the list of components is created, and then the list of posn's where those images need to be drawn. The super-powers given to the player should only appear once the player reaches stage 5. The images of the super-horn and the fish should only be included in the list of images if the stage is `>= 5` and the player hasnt already claimed the super-power for that stage. Once the player has claimed the super-power, the posn of that image is modified to #f. 
Before placing the images, I used `filter` to remove any empty lists from the `stage-comp` list, and any #f values from the `stage-posn` list.

```racket
...
(let*...
[stage-comp (append (list (scale (if(eq? (player-state player) 'super) 5/9 1/2)
                                                 (swim (player-state player) (player-direction player) time))
                          (rainbow time)
                          (stage-HUD st))
                          (if(super-powers-state sp) (list (if(super-powers-armor-pos sp) (scale 2/3 (super-horn time)) '())
                                                           (if(super-powers-fish-pos sp) (scale 2/3 fish) '())) '())
                          (place-tiles (stage-board st))
                          (for/list ([i (length (stage-Enemies st))])
                             (cond ((< difficulty_level 10) (if(< i 6) (flip-horizontal sharkfin) sharkfin))
                                   ((< difficulty_level 100) (if(< i 6) (flip-horizontal laser-shark) laser-shark))
                                   ((< difficulty_level 1000) (if(< i 6) (flip-horizontal laser-shark)sharkfin)))))]
[stage-posn (append (list (player-position player) (make-posn 50 75) (make-posn (quotient (posn-x WINDOW) 2) 18))
                          (if(super-powers-state sp) (list (super-powers-armor-pos sp) (super-powers-fish-pos sp)) '())
                          (tile-posn-list stage_n)
                          (for/list ([i (stage-Enemies st)])
                             (shark-p i)))])
 ;;draw stage components and test for sharknado animation
(cond ((>= difficulty_level 100) (create-sharknado time (place-images (filter (lambda (e) (not (empty? e))) stage-comp)
                                                                      (filter (lambda (e) (not (eq? #f e))) stage-posn)
                                                                      BACKGROUND)))
       (else (place-images (filter (lambda (e) (not (empty? e))) stage-comp)
                           (filter (lambda (e) (not (eq? #f e))) stage-posn)
                           BACKGROUND)))))
 ```


The enemies, or list of sharks, was created using a map function based on the difficulty level and stage number.

Fold was used to detect object collision between the player character and the list of enemies. 

We used state modification to maintain the state of game-play and pass messages between the world, stage and other objects.

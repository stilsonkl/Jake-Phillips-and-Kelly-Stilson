#lang racket
(require 2htdp/image)
;;(require graphics/graphics)
(require lang/posn)

;;Use of this library during the final project will be for creating
;;  the images and background to be used in our game.

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
 (rectangle 170 150 "outline" "white"))

)

;;might use these?
;;(define happy-walley
;;  (draw-walley 'happy))
;;(define sad-walley
;;  (draw-walley 'sad))

(define (swim mood direction)
  (if (eq? direction 'left)
      (flip-horizontal (draw-walley mood))
      (draw-walley mood)))


;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname pstreamed) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;the world_state will eventually become a structure. when that happens, all instances of world_state will have to be changed with world_state-current_screen or something of the ilk
(require 2htdp/image)
(require 2htdp/universe)
(require rsound)
(require rsound/reverb-typed)
 
(define ps (make-pstream))
;;main-world is one of 0 (home screen) 1 (recorder) 2 (beat machine)
(define-struct World (main-world record-screen pause? next-start-time Sounds1 Sounds2 Sounds3 Sounds4 Sounds5 Sounds6 Sounds7 Sounds8))
 
(define-struct Sounds1 (pause-button 1o 1e 1+ 1a 2o 2e 2+ 2a 3o 3e 3+ 3a 4o 4e 4+ 4a counter))
(define-struct Sounds2 (pause-button 1o 1e 1+ 1a 2o 2e 2+ 2a 3o 3e 3+ 3a 4o 4e 4+ 4a))
(define-struct Sounds3 (pause-button 1o 1e 1+ 1a 2o 2e 2+ 2a 3o 3e 3+ 3a 4o 4e 4+ 4a))
(define-struct Sounds4 (pause-button 1o 1e 1+ 1a 2o 2e 2+ 2a 3o 3e 3+ 3a 4o 4e 4+ 4a))
(define-struct Sounds5 (pause-button 1o 1e 1+ 1a 2o 2e 2+ 2a 3o 3e 3+ 3a 4o 4e 4+ 4a))
(define-struct Sounds6 (pause-button 1o 1e 1+ 1a 2o 2e 2+ 2a 3o 3e 3+ 3a 4o 4e 4+ 4a))
(define-struct Sounds7 (pause-button 1o 1e 1+ 1a 2o 2e 2+ 2a 3o 3e 3+ 3a 4o 4e 4+ 4a))
(define-struct Sounds8 (pause-button 1o 1e 1+ 1a 2o 2e 2+ 2a 3o 3e 3+ 3a 4o 4e 4+ 4a))
(define-struct record-screen (play1 play2 play3 stop1 stop2 stop3 record1 record2 record3 rec1 rec2 rec3))
 
(define start-world (make-World 0 (make-record-screen 0 0 0 0 0 0 0 0 0 0 0 0) 0 0
                                   (make-Sounds1 (make-pstream) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                                   (make-Sounds2 (make-pstream) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                                   (make-Sounds3 (make-pstream) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                                   (make-Sounds4 (make-pstream) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                                   (make-Sounds5 (make-pstream) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                                   (make-Sounds6 (make-pstream) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                                   (make-Sounds7 (make-pstream) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                                   (make-Sounds8 (make-pstream) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)))
 
 
;the background of the program
(define background (square 750 "solid" "black"))
 
;buttons that will do various things
(define play_button (rotate 270 (triangle 100 "solid" "green")))
(define stop_button (square 100 "solid" "red"))
(define record_button (underlay/xy (circle 50 "solid" "gray") 30 30 (circle 20 "solid" "red")))
(define pause_button (underlay/xy (rectangle 25 100 "solid" "blue") 50 0 (rectangle 25 100 "solid" "blue")))
(define back_button (text "BACK" 24 "blue"))
(define clear_button (text "CLEAR" 24 "red"))
(define unchecked_square (square 25 "solid" "gray"))
(define checked_square (square 25 "solid" "green"))
 
 
 
;3 play buttons for use on the record screen
(define play_buttons (underlay/xy   
(underlay/xy
(underlay/xy background 400 300 play_button)
 400 175 play_button) 
  400 425 play_button))
 
;3 stop buttons for use on the record screen. 
;overlays on top of the 3 play buttons
(define stop_buttons (underlay/xy   
(underlay/xy
(underlay/xy play_buttons 275 300 stop_button)
 275 175 stop_button) 
  275 425 stop_button))
 
 
;a row of toggle buttons for use on the "create beat" screen
(define (button_row_1 world_state)
  (underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy (if (= 1 (Sounds1-1o (World-Sounds1 world_state))) checked_square unchecked_square)
                             40 0 (if (= 1 (Sounds1-1e (World-Sounds1 world_state))) checked_square unchecked_square))
                  80 0 (if (= 1 (Sounds1-1+ (World-Sounds1 world_state))) checked_square unchecked_square))
                120 0 (if (= 1 (Sounds1-1a (World-Sounds1 world_state))) checked_square unchecked_square))
               160 0 (if (= 1 (Sounds1-2o (World-Sounds1 world_state))) checked_square unchecked_square))
              200 0 (if (= 1 (Sounds1-2e (World-Sounds1 world_state))) checked_square unchecked_square))
             240 0 (if (= 1 (Sounds1-2+ (World-Sounds1 world_state))) checked_square unchecked_square))
            280 0 (if (= 1 (Sounds1-2a (World-Sounds1 world_state))) checked_square unchecked_square))
           320 0 (if (= 1 (Sounds1-3o (World-Sounds1 world_state))) checked_square unchecked_square))
          360 0 (if (= 1 (Sounds1-3e (World-Sounds1 world_state))) checked_square unchecked_square))
         400 0 (if (= 1 (Sounds1-3+ (World-Sounds1 world_state))) checked_square unchecked_square))
        440 0 (if (= 1 (Sounds1-3a (World-Sounds1 world_state))) checked_square unchecked_square))
       480 0 (if (= 1 (Sounds1-4o (World-Sounds1 world_state))) checked_square unchecked_square))
      520 0 (if (= 1 (Sounds1-4e (World-Sounds1 world_state))) checked_square unchecked_square))
     560 0 (if (= 1 (Sounds1-4+ (World-Sounds1 world_state))) checked_square unchecked_square))
    600 0 (if (= 1 (Sounds1-4a (World-Sounds1 world_state))) checked_square unchecked_square))
   )
 
(define (button_row_2 world_state)
(underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy (if (= 1 (Sounds2-1o (World-Sounds2 world_state))) checked_square unchecked_square)
                             40 0 (if (= 1 (Sounds2-1e (World-Sounds2 world_state))) checked_square unchecked_square))
                  80 0 (if (= 1 (Sounds2-1+ (World-Sounds2 world_state))) checked_square unchecked_square))
                120 0 (if (= 1 (Sounds2-1a (World-Sounds2 world_state))) checked_square unchecked_square))
               160 0 (if (= 1 (Sounds2-2o (World-Sounds2 world_state))) checked_square unchecked_square))
              200 0 (if (= 1 (Sounds2-2e (World-Sounds2 world_state))) checked_square unchecked_square))
             240 0 (if (= 1 (Sounds2-2+ (World-Sounds2 world_state))) checked_square unchecked_square))
            280 0 (if (= 1 (Sounds2-2a (World-Sounds2 world_state))) checked_square unchecked_square))
           320 0 (if (= 1 (Sounds2-3o (World-Sounds2 world_state))) checked_square unchecked_square))
          360 0 (if (= 1 (Sounds2-3e (World-Sounds2 world_state))) checked_square unchecked_square))
         400 0 (if (= 1 (Sounds2-3+ (World-Sounds2 world_state))) checked_square unchecked_square))
        440 0 (if (= 1 (Sounds2-3a (World-Sounds2 world_state))) checked_square unchecked_square))
       480 0 (if (= 1 (Sounds2-4o (World-Sounds2 world_state))) checked_square unchecked_square))
      520 0 (if (= 1 (Sounds2-4e (World-Sounds2 world_state))) checked_square unchecked_square))
     560 0 (if (= 1 (Sounds2-4+ (World-Sounds2 world_state))) checked_square unchecked_square))
    600 0 (if (= 1 (Sounds2-4a (World-Sounds2 world_state))) checked_square unchecked_square))
   )
 
(define (button_row_3 world_state)
(underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy (if (= 1 (Sounds3-1o (World-Sounds3 world_state))) checked_square unchecked_square)
                             40 0 (if (= 1 (Sounds3-1e (World-Sounds3 world_state))) checked_square unchecked_square))
                  80 0 (if (= 1 (Sounds3-1+ (World-Sounds3 world_state))) checked_square unchecked_square))
                120 0 (if (= 1 (Sounds3-1a (World-Sounds3 world_state))) checked_square unchecked_square))
               160 0 (if (= 1 (Sounds3-2o (World-Sounds3 world_state))) checked_square unchecked_square))
              200 0 (if (= 1 (Sounds3-2e (World-Sounds3 world_state))) checked_square unchecked_square))
             240 0 (if (= 1 (Sounds3-2+ (World-Sounds3 world_state))) checked_square unchecked_square))
            280 0 (if (= 1 (Sounds3-2a (World-Sounds3 world_state))) checked_square unchecked_square))
           320 0 (if (= 1 (Sounds3-3o (World-Sounds3 world_state))) checked_square unchecked_square))
          360 0 (if (= 1 (Sounds3-3e (World-Sounds3 world_state))) checked_square unchecked_square))
         400 0 (if (= 1 (Sounds3-3+ (World-Sounds3 world_state))) checked_square unchecked_square))
        440 0 (if (= 1 (Sounds3-3a (World-Sounds3 world_state))) checked_square unchecked_square))
       480 0 (if (= 1 (Sounds3-4o (World-Sounds3 world_state))) checked_square unchecked_square))
      520 0 (if (= 1 (Sounds3-4e (World-Sounds3 world_state))) checked_square unchecked_square))
     560 0 (if (= 1 (Sounds3-4+ (World-Sounds3 world_state))) checked_square unchecked_square))
    600 0 (if (= 1 (Sounds3-4a (World-Sounds3 world_state))) checked_square unchecked_square))
   )
 
 
(define (button_row_4 world_state)
(underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy (if (= 1 (Sounds4-1o (World-Sounds4 world_state))) checked_square unchecked_square)
                             40 0 (if (= 1 (Sounds4-1e (World-Sounds4 world_state))) checked_square unchecked_square))
                  80 0 (if (= 1 (Sounds4-1+ (World-Sounds4 world_state))) checked_square unchecked_square))
                120 0 (if (= 1 (Sounds4-1a (World-Sounds4 world_state))) checked_square unchecked_square))
               160 0 (if (= 1 (Sounds4-2o (World-Sounds4 world_state))) checked_square unchecked_square))
              200 0 (if (= 1 (Sounds4-2e (World-Sounds4 world_state))) checked_square unchecked_square))
             240 0 (if (= 1 (Sounds4-2+ (World-Sounds4 world_state))) checked_square unchecked_square))
            280 0 (if (= 1 (Sounds4-2a (World-Sounds4 world_state))) checked_square unchecked_square))
           320 0 (if (= 1 (Sounds4-3o (World-Sounds4 world_state))) checked_square unchecked_square))
          360 0 (if (= 1 (Sounds4-3e (World-Sounds4 world_state))) checked_square unchecked_square))
         400 0 (if (= 1 (Sounds4-3+ (World-Sounds4 world_state))) checked_square unchecked_square))
        440 0 (if (= 1 (Sounds4-3a (World-Sounds4 world_state))) checked_square unchecked_square))
       480 0 (if (= 1 (Sounds4-4o (World-Sounds4 world_state))) checked_square unchecked_square))
      520 0 (if (= 1 (Sounds4-4e (World-Sounds4 world_state))) checked_square unchecked_square))
     560 0 (if (= 1 (Sounds4-4+ (World-Sounds4 world_state))) checked_square unchecked_square))
    600 0 (if (= 1 (Sounds4-4a (World-Sounds4 world_state))) checked_square unchecked_square))
   )
 
 
(define (button_row_5 world_state)
(underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy (if (= 1 (Sounds5-1o (World-Sounds5 world_state))) checked_square unchecked_square)
                             40 0 (if (= 1 (Sounds5-1e (World-Sounds5 world_state))) checked_square unchecked_square))
                  80 0 (if (= 1 (Sounds5-1+ (World-Sounds5 world_state))) checked_square unchecked_square))
                120 0 (if (= 1 (Sounds5-1a (World-Sounds5 world_state))) checked_square unchecked_square))
               160 0 (if (= 1 (Sounds5-2o (World-Sounds5 world_state))) checked_square unchecked_square))
              200 0 (if (= 1 (Sounds5-2e (World-Sounds5 world_state))) checked_square unchecked_square))
             240 0 (if (= 1 (Sounds5-2+ (World-Sounds5 world_state))) checked_square unchecked_square))
            280 0 (if (= 1 (Sounds5-2a (World-Sounds5 world_state))) checked_square unchecked_square))
           320 0 (if (= 1 (Sounds5-3o (World-Sounds5 world_state))) checked_square unchecked_square))
          360 0 (if (= 1 (Sounds5-3e (World-Sounds5 world_state))) checked_square unchecked_square))
         400 0 (if (= 1 (Sounds5-3+ (World-Sounds5 world_state))) checked_square unchecked_square))
        440 0 (if (= 1 (Sounds5-3a (World-Sounds5 world_state))) checked_square unchecked_square))
       480 0 (if (= 1 (Sounds5-4o (World-Sounds5 world_state))) checked_square unchecked_square))
      520 0 (if (= 1 (Sounds5-4e (World-Sounds5 world_state))) checked_square unchecked_square))
     560 0 (if (= 1 (Sounds5-4+ (World-Sounds5 world_state))) checked_square unchecked_square))
    600 0 (if (= 1 (Sounds5-4a (World-Sounds5 world_state))) checked_square unchecked_square)))
 
 
(define (button_row_6 world_state)
(underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy (if (= 1 (Sounds6-1o (World-Sounds6 world_state))) checked_square unchecked_square)
                             40 0 (if (= 1 (Sounds6-1e (World-Sounds6 world_state))) checked_square unchecked_square))
                  80 0 (if (= 1 (Sounds6-1+ (World-Sounds6 world_state))) checked_square unchecked_square))
                120 0 (if (= 1 (Sounds6-1a (World-Sounds6 world_state))) checked_square unchecked_square))
               160 0 (if (= 1 (Sounds6-2o (World-Sounds6 world_state))) checked_square unchecked_square))
              200 0 (if (= 1 (Sounds6-2e (World-Sounds6 world_state))) checked_square unchecked_square))
             240 0 (if (= 1 (Sounds6-2+ (World-Sounds6 world_state))) checked_square unchecked_square))
            280 0 (if (= 1 (Sounds6-2a (World-Sounds6 world_state))) checked_square unchecked_square))
           320 0 (if (= 1 (Sounds6-3o (World-Sounds6 world_state))) checked_square unchecked_square))
          360 0 (if (= 1 (Sounds6-3e (World-Sounds6 world_state))) checked_square unchecked_square))
         400 0 (if (= 1 (Sounds6-3+ (World-Sounds6 world_state))) checked_square unchecked_square))
        440 0 (if (= 1 (Sounds6-3a (World-Sounds6 world_state))) checked_square unchecked_square))
       480 0 (if (= 1 (Sounds6-4o (World-Sounds6 world_state))) checked_square unchecked_square))
      520 0 (if (= 1 (Sounds6-4e (World-Sounds6 world_state))) checked_square unchecked_square))
     560 0 (if (= 1 (Sounds6-4+ (World-Sounds6 world_state))) checked_square unchecked_square))
    600 0 (if (= 1 (Sounds6-4a (World-Sounds6 world_state))) checked_square unchecked_square))
   )
 
 
(define (button_row_7 world_state)
(underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy (if (= 1 (Sounds7-1o (World-Sounds7 world_state))) checked_square unchecked_square)
                             40 0 (if (= 1 (Sounds7-1e (World-Sounds7 world_state))) checked_square unchecked_square))
                  80 0 (if (= 1 (Sounds7-1+ (World-Sounds7 world_state))) checked_square unchecked_square))
                120 0 (if (= 1 (Sounds7-1a (World-Sounds7 world_state))) checked_square unchecked_square))
               160 0 (if (= 1 (Sounds7-2o (World-Sounds7 world_state))) checked_square unchecked_square))
              200 0 (if (= 1 (Sounds7-2e (World-Sounds7 world_state))) checked_square unchecked_square))
             240 0 (if (= 1 (Sounds7-2+ (World-Sounds7 world_state))) checked_square unchecked_square))
            280 0 (if (= 1 (Sounds7-2a (World-Sounds7 world_state))) checked_square unchecked_square))
           320 0 (if (= 1 (Sounds7-3o (World-Sounds7 world_state))) checked_square unchecked_square))
          360 0 (if (= 1 (Sounds7-3e (World-Sounds7 world_state))) checked_square unchecked_square))
         400 0 (if (= 1 (Sounds7-3+ (World-Sounds7 world_state))) checked_square unchecked_square))
        440 0 (if (= 1 (Sounds7-3a (World-Sounds7 world_state))) checked_square unchecked_square))
       480 0 (if (= 1 (Sounds7-4o (World-Sounds7 world_state))) checked_square unchecked_square))
      520 0 (if (= 1 (Sounds7-4e (World-Sounds7 world_state))) checked_square unchecked_square))
     560 0 (if (= 1 (Sounds7-4+ (World-Sounds7 world_state))) checked_square unchecked_square))
    600 0 (if (= 1 (Sounds7-4a (World-Sounds7 world_state))) checked_square unchecked_square))
   )
 
 
(define (button_row_8 world_state)
(underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy (if (= 1 (Sounds8-1o (World-Sounds8 world_state))) checked_square unchecked_square)
                             40 0 (if (= 1 (Sounds8-1e (World-Sounds8 world_state))) checked_square unchecked_square))
                  80 0 (if (= 1 (Sounds8-1+ (World-Sounds8 world_state))) checked_square unchecked_square))
                120 0 (if (= 1 (Sounds8-1a (World-Sounds8 world_state))) checked_square unchecked_square))
               160 0 (if (= 1 (Sounds8-2o (World-Sounds8 world_state))) checked_square unchecked_square))
              200 0 (if (= 1 (Sounds8-2e (World-Sounds8 world_state))) checked_square unchecked_square))
             240 0 (if (= 1 (Sounds8-2+ (World-Sounds8 world_state))) checked_square unchecked_square))
            280 0 (if (= 1 (Sounds8-2a (World-Sounds8 world_state))) checked_square unchecked_square))
           320 0 (if (= 1 (Sounds8-3o (World-Sounds8 world_state))) checked_square unchecked_square))
          360 0 (if (= 1 (Sounds8-3e (World-Sounds8 world_state))) checked_square unchecked_square))
         400 0 (if (= 1 (Sounds8-3+ (World-Sounds8 world_state))) checked_square unchecked_square))
        440 0 (if (= 1 (Sounds8-3a (World-Sounds8 world_state))) checked_square unchecked_square))
       480 0 (if (= 1 (Sounds8-4o (World-Sounds8 world_state))) checked_square unchecked_square))
      520 0 (if (= 1 (Sounds8-4e (World-Sounds8 world_state))) checked_square unchecked_square))
     560 0 (if (= 1 (Sounds8-4+ (World-Sounds8 world_state))) checked_square unchecked_square))
    600 0 (if (= 1 (Sounds8-4a (World-Sounds8 world_state))) checked_square unchecked_square))
   )
 
 
; a grid of 8 rows of toggle buttons
(define (button_grid world_state)
  (underlay/xy
   (underlay/xy
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy (button_row_1 world_state)
                0 40 (button_row_2 world_state))
        0 80 (button_row_3 world_state))
       0 120 (button_row_4 world_state))
      0 160 (button_row_5 world_state))
     0 200 (button_row_6 world_state))
    0 240 (button_row_7 world_state))
   0 280 (button_row_8 world_state))) 
 
 
;the home screen of the program
(define home_screen  
  (underlay/xy 
   (underlay/xy 
    (underlay/xy     
     (underlay/xy
      (underlay/xy
    background 
    100 275 (square 200 "solid" "red")) 
   450 275 (square 200 "solid" "blue"))
   265 100 (above (text "[on-tick party] Presents" 24 "white") (text "The BeatBox Machine" 24 "white")))
   100 280 (rotate 45 (text "Record Your Voice Here" 24 "white")))
   450 280 (rotate 45 (text "Create Your Beat Here" 24 "white"))))

;the record screen of the program
(define record_screen (underlay/xy 
(underlay/xy   
(underlay/xy
(underlay/xy stop_buttons 155 300 record_button)
155 175 record_button) 
  155 425 record_button) 600 600 back_button))
 
;moves the line according to the time in the beat screen 
(define (line-mover world_state)
   (+ 100 (floor (/ (modulo (pstream-current-frame (Sounds1-pause-button (World-Sounds1 world_state))) 88200) 138))))
 
 
;the "create beat" screen of the program
(define (beat_screen world_state)
  (underlay/xy
   (underlay/xy 
    (underlay/xy
     (underlay/xy
      (underlay/xy
       (underlay/xy
        (underlay/xy
         (underlay/xy
          (underlay/xy
           (underlay/xy
            (underlay/xy
             (underlay/xy
              (underlay/xy
               (underlay/xy
                (underlay/xy
                 (underlay/xy
                  (underlay/xy
                   (underlay/xy
                    (underlay/xy
                     (underlay/xy
                      (underlay/xy
                       (underlay/xy
                        (underlay/xy 
                         (underlay/xy
                          (underlay/xy
                           (underlay/xy 
                            (underlay/xy 
                             (underlay/xy 
                              (underlay/xy 
                               (underlay/xy background 155 600 play_button) 
                               35 600 clear_button)
                              260 600 pause_button)
                             600 600 back_button)
                            15 100 (text "Crash" 12 "blue"))
                           15 140 (text "Closed Hi-Hat" 12 "blue"))
                          15 180 (text "Open Hi-Hat" 12 "blue"))
                         15 220 (text "Snare" 12 "blue"))
                        15 260 (text "Kick" 12 "blue"))
                       15 300 (text "Sound 1" 12 "blue"))
                      15 340 (text "Sound 2" 12 "blue"))
                     15 380 (text "Sound 3" 12 "blue"))
                    100 40 (text "1" 18 "blue"))   
                   140 40 (text "e" 18 "blue")) 
                  180 40 (text "+" 18 "blue")) 
                 220 40 (text "a" 18 "blue")) 
                260 40 (text "2" 18 "blue")) 
               300 40 (text "e" 18 "blue")) 
              340 40 (text "+" 18 "blue")) 
             380 40 (text "a" 18 "blue")) 
            420 40 (text "3" 18 "blue")) 
           460 40 (text "e" 18 "blue")) 
          500 40 (text "+" 18 "blue")) 
         540 40 (text "a" 18 "blue")) 
        580 40 (text "4" 18 "blue")) 
       620 40 (text "e" 18 "blue")) 
      660 40 (text "+" 18 "blue")) 
     700 40 (text "a" 18 "blue")) 
    100 100 (button_grid world_state))
   (line-mover world_state) 60 (line 0 400 "Red")))
 
;determines which screen to display
(define (current_screen world_state)
  (cond [(= 0 (World-main-world world_state)) 
         home_screen]
        [(= 1 (World-main-world world_state))
         record_screen]
        [(= 2 (World-main-world world_state))
          (beat_screen world_state)]))
 
;short-cut to determine if the mouse is in a certain range
(define (inrange? xory_position small_number big_number) (and (>= xory_position small_number) (<= xory_position big_number)))
 
;handles mouse functions
(define (mouse_handler world_state x_position y_position event_name) (if (equal? (World-main-world world_state) 0) 
                                                                         (mouse_home_screen world_state x_position y_position event_name) 
                                                                     (if (equal? (World-main-world world_state) 1) 
                                                                         (mouse_record_screen world_state x_position y_position event_name)
                                                                                                                       
                                                                         (mouse_beat_screen world_state x_position y_position event_name)      
                                                                                                                       )))
 
;handles mouse functions for the home screen
(define (mouse_home_screen world_state x_position y_position event_name) (if (equal? event_name "button-down") 
                                                                             (if (inrange? y_position 275 475) 
                                                                                 (if (inrange? x_position 100 300) 
                                                                                     (make-World 1 (World-record-screen world_state) (World-pause? world_state)
                                                                                                 (World-next-start-time world_state)
                                                                                                   (World-Sounds1 world_state)
                                                                                                   (World-Sounds2 world_state)
                                                                                                   (World-Sounds3 world_state)
                                                                                                   (World-Sounds4 world_state)
                                                                                                   (World-Sounds5 world_state)
                                                                                                   (World-Sounds6 world_state)
                                                                                                   (World-Sounds7 world_state)
                                                                                                   (World-Sounds8 world_state))
                                                                                                                                  
                                                                                     (if (inrange? x_position 450 650) 
                                                                                         (make-World 2 (World-record-screen world_state)
                                                                                                     (World-pause? world_state)
                                                                                                     (World-next-start-time world_state)
                                                                                                     (World-Sounds1 world_state)
                                                                                                     (World-Sounds2 world_state)
                                                                                                     (World-Sounds3 world_state)
                                                                                                     (World-Sounds4 world_state)
                                                                                                     (World-Sounds5 world_state)
                                                                                                     (World-Sounds6 world_state)
                                                                                                     (World-Sounds7 world_state)
                                                                                                     (World-Sounds8 world_state)) 
                                                                                 world_state))world_state)world_state))
                                                                              
;handles mouse functions for the recording screen 
(define (both a b)
  b)
(define (mouse_record_screen world_state x_position y_position event_name) 
  (if (equal? event_name "button-down")
      (cond [(inrange? x_position 155 255)
             ;;record
             (cond [(inrange? y_position 175 275)
                    (make-World (World-main-world world_state) 
                                (make-record-screen 0 0 0 0 0 0 0 0 0 
                                                    (record-sound 88200) 
                                                    (record-screen-rec2 (World-record-screen world_state))
                                                    (record-screen-rec3 (World-record-screen world_state)))
                                                    (World-pause? world_state)
                                                    (World-next-start-time world_state)
                                                    (World-Sounds1 world_state)
                                                    (World-Sounds2 world_state)
                                                    (World-Sounds3 world_state)
                                                    (World-Sounds4 world_state)
                                                    (World-Sounds5 world_state)
                                                    (World-Sounds6 world_state)
                                                    (World-Sounds7 world_state)
                                                    (World-Sounds8 world_state))]
                   [(inrange? y_position 300 400)
                    (make-World (World-main-world world_state) 
                                (make-record-screen 0 0 0 0 0 0 0 0 0 
                                                    (record-screen-rec1 (World-record-screen world_state))
                                                    (record-sound 88200) 
                                                    (record-screen-rec3 (World-record-screen world_state)))
                                                    (World-pause? world_state)
                                                    (World-next-start-time world_state)
                                                    (World-Sounds1 world_state)
                                                    (World-Sounds2 world_state)
                                                    (World-Sounds3 world_state)
                                                    (World-Sounds4 world_state)
                                                    (World-Sounds5 world_state)
                                                    (World-Sounds6 world_state)
                                                    (World-Sounds7 world_state)
                                                    (World-Sounds8 world_state))]
                   [(inrange? y_position 425 525)
                    (make-World (World-main-world world_state) 
                                (make-record-screen 0 0 0 0 0 0 0 0 0 
                                                    (record-screen-rec1 (World-record-screen world_state))                                                    
                                                    (record-screen-rec2 (World-record-screen world_state))
                                                    (record-sound 88200)) 
                                                    (World-pause? world_state)
                                                    (World-next-start-time world_state)
                                                    (World-Sounds1 world_state)
                                                    (World-Sounds2 world_state)
                                                    (World-Sounds3 world_state)
                                                    (World-Sounds4 world_state)
                                                    (World-Sounds5 world_state)
                                                    (World-Sounds6 world_state)
                                                    (World-Sounds7 world_state)
                                                    (World-Sounds8 world_state))]
                   [else world_state])]
            ;;stop
            [(inrange? x_position 275 375)
             (cond [(inrange? y_position 175 275)
                    (make-World (World-main-world world_state) 
                                (make-record-screen 0 0 0 0 0 0 0 0 0 
                                                    (record-sound 88200) 
                                                    (record-screen-rec2 (World-record-screen world_state))
                                                    (record-screen-rec3 (World-record-screen world_state))
                                                    (World-pause? world_state)
                                                    (World-next-start-time world_state)
                                                    (World-Sounds1 world_state)
                                                    (World-Sounds2 world_state)
                                                    (World-Sounds3 world_state)
                                                    (World-Sounds4 world_state)
                                                    (World-Sounds5 world_state)
                                                    (World-Sounds6 world_state)
                                                    (World-Sounds7 world_state)
                                                    (World-Sounds8 world_state)))]
                   [(inrange? y_position 300 400)
                    (make-World (World-main-world world_state) 
                                (make-record-screen 0 0 0 0 0 0 0 0 0 
                                                    (record-screen-rec1 (World-record-screen world_state))
                                                    (record-sound 88200) 
                                                    (record-screen-rec3 (World-record-screen world_state)))
                                                    (World-pause? world_state)
                                                    (World-next-start-time world_state)
                                                    (World-Sounds1 world_state)
                                                    (World-Sounds2 world_state)
                                                    (World-Sounds3 world_state)
                                                    (World-Sounds4 world_state)
                                                    (World-Sounds5 world_state)
                                                    (World-Sounds6 world_state)
                                                    (World-Sounds7 world_state)
                                                    (World-Sounds8 world_state))]
                   [(inrange? y_position 425 525)
                    (make-World (World-main-world world_state) 
                                (make-record-screen 0 0 0 0 0 0 0 0 0 
                                                    (record-screen-rec1 (World-record-screen world_state))
                                                    (record-sound 88200) 
                                                    (record-screen-rec3 (World-record-screen world_state))
                                                    (World-pause? world_state)
                                                    (World-next-start-time world_state)
                                                    (World-Sounds1 world_state)
                                                    (World-Sounds2 world_state)
                                                    (World-Sounds3 world_state)
                                                    (World-Sounds4 world_state)
                                                    (World-Sounds5 world_state)
                                                    (World-Sounds6 world_state)
                                                    (World-Sounds7 world_state)
                                                    (World-Sounds8 world_state)))]
                   [else world_state])]
            ;;play
            [(inrange? x_position 400 500)
             (cond [(inrange? y_position 175 275)
                    (both ((rs-filter play (record-screen-rec1 (World-record-screen world_state))) reverb) world_state)
                    ]
                   [(inrange? y_position 300 400)                     
                    (both ((rs-filter play (record-screen-rec2 (World-record-screen world_state))) reverb) world_state)
                    ]
                   [(inrange? y_position 425 525)                    
                    (both ((rs-filter play (record-screen-rec3 (World-record-screen world_state))) reverb) world_state)
                    ]
                   [else world_state])]
            
            [(and (inrange? x_position 600 700) (inrange? y_position 600 700))
             (make-World 0 
                         (World-record-screen world_state)
                         (World-pause? world_state)
                         (World-next-start-time world_state)
                         (World-Sounds1 world_state)
                         (World-Sounds2 world_state)
                         (World-Sounds3 world_state)
                         (World-Sounds4 world_state)
                         (World-Sounds5 world_state)
                         (World-Sounds6 world_state)
                         (World-Sounds7 world_state)
                         (World-Sounds8 world_state))]
            
            
            
            [else world_state])
      world_state))
                                                                                     
                                                                              
                                                                                        
 
 
 
;;Functions that will help condense the programs
;;RowNumber SquareNumber world-state -> world-state
(define (update_Sounds a b world_state)
  (make-World (World-main-world world_state)
              (World-record-screen world_state)
              (World-pause? world_state)
              (World-next-start-time world_state)
                     (if (= a 1)
                           (make-Sounds1 (Sounds1-pause-button (World-Sounds1 world_state))
                            (if (= b 1) (if (= 0 (Sounds1-1o (World-Sounds1 world_state))) 1 0) (Sounds1-1o (World-Sounds1 world_state)))
                            (if (= b 2) (if (= 0 (Sounds1-1e (World-Sounds1 world_state))) 1 0) (Sounds1-1e (World-Sounds1 world_state)))
                            (if (= b 3) (if (= 0 (Sounds1-1+ (World-Sounds1 world_state))) 1 0) (Sounds1-1+ (World-Sounds1 world_state)))
                            (if (= b 4) (if (= 0 (Sounds1-1a (World-Sounds1 world_state))) 1 0) (Sounds1-1a (World-Sounds1 world_state)))
                            (if (= b 5) (if (= 0 (Sounds1-2o (World-Sounds1 world_state))) 1 0) (Sounds1-2o (World-Sounds1 world_state)))
                            (if (= b 6) (if (= 0 (Sounds1-2e (World-Sounds1 world_state))) 1 0) (Sounds1-2e (World-Sounds1 world_state)))
                            (if (= b 7) (if (= 0 (Sounds1-2+ (World-Sounds1 world_state))) 1 0) (Sounds1-2+ (World-Sounds1 world_state)))
                            (if (= b 8) (if (= 0 (Sounds1-2a (World-Sounds1 world_state))) 1 0) (Sounds1-2a (World-Sounds1 world_state)))
                            (if (= b 9) (if (= 0 (Sounds1-3o (World-Sounds1 world_state))) 1 0) (Sounds1-3o (World-Sounds1 world_state)))
                            (if (= b 10) (if (= 0 (Sounds1-3e (World-Sounds1 world_state))) 1 0) (Sounds1-3e (World-Sounds1 world_state)))
                            (if (= b 11) (if (= 0 (Sounds1-3+ (World-Sounds1 world_state))) 1 0) (Sounds1-3+ (World-Sounds1 world_state)))
                            (if (= b 12) (if (= 0 (Sounds1-3a (World-Sounds1 world_state))) 1 0) (Sounds1-3a (World-Sounds1 world_state)))
                            (if (= b 13) (if (= 0 (Sounds1-4o (World-Sounds1 world_state))) 1 0) (Sounds1-4o (World-Sounds1 world_state)))
                            (if (= b 14) (if (= 0 (Sounds1-4e (World-Sounds1 world_state))) 1 0) (Sounds1-4e (World-Sounds1 world_state)))
                            (if (= b 15) (if (= 0 (Sounds1-4+ (World-Sounds1 world_state))) 1 0) (Sounds1-4+ (World-Sounds1 world_state)))
                            (if (= b 16) (if (= 0 (Sounds1-4a (World-Sounds1 world_state))) 1 0) (Sounds1-4a (World-Sounds1 world_state)))
                            (Sounds1-counter (World-Sounds1 world_state)))
                            (World-Sounds1 world_state))
                        (if (= a 2)
                            (make-Sounds2 (Sounds2-pause-button (World-Sounds2 world_state))
                            (if (= b 1) (if (= 0 (Sounds2-1o (World-Sounds2 world_state))) 1 0) (Sounds2-1o (World-Sounds2 world_state)))
                            (if (= b 2) (if (= 0 (Sounds2-1e (World-Sounds2 world_state))) 1 0) (Sounds2-1e (World-Sounds2 world_state)))
                            (if (= b 3) (if (= 0 (Sounds2-1+ (World-Sounds2 world_state))) 1 0) (Sounds2-1+ (World-Sounds2 world_state)))
                            (if (= b 4) (if (= 0 (Sounds2-1a (World-Sounds2 world_state))) 1 0) (Sounds2-1a (World-Sounds2 world_state)))
                            (if (= b 5) (if (= 0 (Sounds2-2o (World-Sounds2 world_state))) 1 0) (Sounds2-2o (World-Sounds2 world_state)))
                            (if (= b 6) (if (= 0 (Sounds2-2e (World-Sounds2 world_state))) 1 0) (Sounds2-2e (World-Sounds2 world_state)))
                            (if (= b 7) (if (= 0 (Sounds2-2+ (World-Sounds2 world_state))) 1 0) (Sounds2-2+ (World-Sounds2 world_state)))
                            (if (= b 8) (if (= 0 (Sounds2-2a (World-Sounds2 world_state))) 1 0) (Sounds2-2a (World-Sounds2 world_state)))
                            (if (= b 9) (if (= 0 (Sounds2-3o (World-Sounds2 world_state))) 1 0) (Sounds2-3o (World-Sounds2 world_state)))
                            (if (= b 10) (if (= 0 (Sounds2-3e (World-Sounds2 world_state))) 1 0) (Sounds2-3e (World-Sounds2 world_state)))
                            (if (= b 11) (if (= 0 (Sounds2-3+ (World-Sounds2 world_state))) 1 0) (Sounds2-3+ (World-Sounds2 world_state)))
                            (if (= b 12) (if (= 0 (Sounds2-3a (World-Sounds2 world_state))) 1 0) (Sounds2-3a (World-Sounds2 world_state)))
                            (if (= b 13) (if (= 0 (Sounds2-4o (World-Sounds2 world_state))) 1 0) (Sounds2-4o (World-Sounds2 world_state)))
                            (if (= b 14) (if (= 0 (Sounds2-4e (World-Sounds2 world_state))) 1 0) (Sounds2-4e (World-Sounds2 world_state)))
                            (if (= b 15) (if (= 0 (Sounds2-4+ (World-Sounds2 world_state))) 1 0) (Sounds2-4+ (World-Sounds2 world_state)))
                            (if (= b 16) (if (= 0 (Sounds2-4a (World-Sounds2 world_state))) 1 0) (Sounds2-4a (World-Sounds2 world_state))))
                            (World-Sounds2 world_state))
                        (if (= a 3)
                            (make-Sounds3 (Sounds3-pause-button (World-Sounds3 world_state))
                            (if (= b 1) (if (= 0 (Sounds3-1o (World-Sounds3 world_state))) 1 0) (Sounds3-1o (World-Sounds3 world_state)))
                            (if (= b 2) (if (= 0 (Sounds3-1e (World-Sounds3 world_state))) 1 0) (Sounds3-1e (World-Sounds3 world_state)))
                            (if (= b 3) (if (= 0 (Sounds3-1+ (World-Sounds3 world_state))) 1 0) (Sounds3-1+ (World-Sounds3 world_state)))
                            (if (= b 4) (if (= 0 (Sounds3-1a (World-Sounds3 world_state))) 1 0) (Sounds3-1a (World-Sounds3 world_state)))
                            (if (= b 5) (if (= 0 (Sounds3-2o (World-Sounds3 world_state))) 1 0) (Sounds3-2o (World-Sounds3 world_state)))
                            (if (= b 6) (if (= 0 (Sounds3-2e (World-Sounds3 world_state))) 1 0) (Sounds3-2e (World-Sounds3 world_state)))
                            (if (= b 7) (if (= 0 (Sounds3-2+ (World-Sounds3 world_state))) 1 0) (Sounds3-2+ (World-Sounds3 world_state)))
                            (if (= b 8) (if (= 0 (Sounds3-2a (World-Sounds3 world_state))) 1 0) (Sounds3-2a (World-Sounds3 world_state)))
                            (if (= b 9) (if (= 0 (Sounds3-3o (World-Sounds3 world_state))) 1 0) (Sounds3-3o (World-Sounds3 world_state)))
                            (if (= b 10) (if (= 0 (Sounds3-3e (World-Sounds3 world_state))) 1 0) (Sounds3-3e (World-Sounds3 world_state)))
                            (if (= b 11) (if (= 0 (Sounds3-3+ (World-Sounds3 world_state))) 1 0) (Sounds3-3+ (World-Sounds3 world_state)))
                            (if (= b 12) (if (= 0 (Sounds3-3a (World-Sounds3 world_state))) 1 0) (Sounds3-3a (World-Sounds3 world_state)))
                            (if (= b 13) (if (= 0 (Sounds3-4o (World-Sounds3 world_state))) 1 0) (Sounds3-4o (World-Sounds3 world_state)))
                            (if (= b 14) (if (= 0 (Sounds3-4e (World-Sounds3 world_state))) 1 0) (Sounds3-4e (World-Sounds3 world_state)))
                            (if (= b 15) (if (= 0 (Sounds3-4+ (World-Sounds3 world_state))) 1 0) (Sounds3-4+ (World-Sounds3 world_state)))
                            (if (= b 16) (if (= 0 (Sounds3-4a (World-Sounds3 world_state))) 1 0) (Sounds3-4a (World-Sounds3 world_state))))
                            (World-Sounds3 world_state))
                        (if (= a 4)
                            (make-Sounds4 (Sounds4-pause-button (World-Sounds4 world_state))
                            (if (= b 1) (if (= 0 (Sounds4-1o (World-Sounds4 world_state))) 1 0) (Sounds4-1o (World-Sounds4 world_state)))
                            (if (= b 2) (if (= 0 (Sounds4-1e (World-Sounds4 world_state))) 1 0) (Sounds4-1e (World-Sounds4 world_state)))
                            (if (= b 3) (if (= 0 (Sounds4-1+ (World-Sounds4 world_state))) 1 0) (Sounds4-1+ (World-Sounds4 world_state)))
                            (if (= b 4) (if (= 0 (Sounds4-1a (World-Sounds4 world_state))) 1 0) (Sounds4-1a (World-Sounds4 world_state)))
                            (if (= b 5) (if (= 0 (Sounds4-2o (World-Sounds4 world_state))) 1 0) (Sounds4-2o (World-Sounds4 world_state)))
                            (if (= b 6) (if (= 0 (Sounds4-2e (World-Sounds4 world_state))) 1 0) (Sounds4-2e (World-Sounds4 world_state)))
                            (if (= b 7) (if (= 0 (Sounds4-2+ (World-Sounds4 world_state))) 1 0) (Sounds4-2+ (World-Sounds4 world_state)))
                            (if (= b 8) (if (= 0 (Sounds4-2a (World-Sounds4 world_state))) 1 0) (Sounds4-2a (World-Sounds4 world_state)))
                            (if (= b 9) (if (= 0 (Sounds4-3o (World-Sounds4 world_state))) 1 0) (Sounds4-3o (World-Sounds4 world_state)))
                            (if (= b 10) (if (= 0 (Sounds4-3e (World-Sounds4 world_state))) 1 0) (Sounds4-3e (World-Sounds4 world_state)))
                            (if (= b 11) (if (= 0 (Sounds4-3+ (World-Sounds4 world_state))) 1 0) (Sounds4-3+ (World-Sounds4 world_state)))
                            (if (= b 12) (if (= 0 (Sounds4-3a (World-Sounds4 world_state))) 1 0) (Sounds4-3a (World-Sounds4 world_state)))
                            (if (= b 13) (if (= 0 (Sounds4-4o (World-Sounds4 world_state))) 1 0) (Sounds4-4o (World-Sounds4 world_state)))
                            (if (= b 14) (if (= 0 (Sounds4-4e (World-Sounds4 world_state))) 1 0) (Sounds4-4e (World-Sounds4 world_state)))
                            (if (= b 15) (if (= 0 (Sounds4-4+ (World-Sounds4 world_state))) 1 0) (Sounds4-4+ (World-Sounds4 world_state)))
                            (if (= b 16) (if (= 0 (Sounds4-4a (World-Sounds4 world_state))) 1 0) (Sounds4-4a (World-Sounds4 world_state))))
                             (World-Sounds4 world_state))
                        (if (= a 5)
                            (make-Sounds5 (Sounds5-pause-button (World-Sounds5 world_state))
                            (if (= b 1) (if (= 0 (Sounds5-1o (World-Sounds5 world_state))) 1 0) (Sounds5-1o (World-Sounds5 world_state)))
                            (if (= b 2) (if (= 0 (Sounds5-1e (World-Sounds5 world_state))) 1 0) (Sounds5-1e (World-Sounds5 world_state)))
                            (if (= b 3) (if (= 0 (Sounds5-1+ (World-Sounds5 world_state))) 1 0) (Sounds5-1+ (World-Sounds5 world_state)))
                            (if (= b 4) (if (= 0 (Sounds5-1a (World-Sounds5 world_state))) 1 0) (Sounds5-1a (World-Sounds5 world_state)))
                            (if (= b 5) (if (= 0 (Sounds5-2o (World-Sounds5 world_state))) 1 0) (Sounds5-2o (World-Sounds5 world_state)))
                            (if (= b 6) (if (= 0 (Sounds5-2e (World-Sounds5 world_state))) 1 0) (Sounds5-2e (World-Sounds5 world_state)))
                            (if (= b 7) (if (= 0 (Sounds5-2+ (World-Sounds5 world_state))) 1 0) (Sounds5-2+ (World-Sounds5 world_state)))
                            (if (= b 8) (if (= 0 (Sounds5-2a (World-Sounds5 world_state))) 1 0) (Sounds5-2a (World-Sounds5 world_state)))
                            (if (= b 9) (if (= 0 (Sounds5-3o (World-Sounds5 world_state))) 1 0) (Sounds5-3o (World-Sounds5 world_state)))
                            (if (= b 10) (if (= 0 (Sounds5-3e (World-Sounds5 world_state))) 1 0) (Sounds5-3e (World-Sounds5 world_state)))
                            (if (= b 11) (if (= 0 (Sounds5-3+ (World-Sounds5 world_state))) 1 0) (Sounds5-3+ (World-Sounds5 world_state)))
                            (if (= b 12) (if (= 0 (Sounds5-3a (World-Sounds5 world_state))) 1 0) (Sounds5-3a (World-Sounds5 world_state)))
                            (if (= b 13) (if (= 0 (Sounds5-4o (World-Sounds5 world_state))) 1 0) (Sounds5-4o (World-Sounds5 world_state)))
                            (if (= b 14) (if (= 0 (Sounds5-4e (World-Sounds5 world_state))) 1 0) (Sounds5-4e (World-Sounds5 world_state)))
                            (if (= b 15) (if (= 0 (Sounds5-4+ (World-Sounds5 world_state))) 1 0) (Sounds5-4+ (World-Sounds5 world_state)))
                            (if (= b 16) (if (= 0 (Sounds5-4a (World-Sounds5 world_state))) 1 0) (Sounds5-4a (World-Sounds5 world_state))))
                            (World-Sounds5 world_state))
                        (if (= a 6)
                            (make-Sounds6 (Sounds6-pause-button (World-Sounds6 world_state))
                            (if (= b 1) (if (= 0 (Sounds6-1o (World-Sounds6 world_state))) 1 0) (Sounds6-1o (World-Sounds6 world_state)))
                            (if (= b 2) (if (= 0 (Sounds6-1e (World-Sounds6 world_state))) 1 0) (Sounds6-1e (World-Sounds6 world_state)))
                            (if (= b 3) (if (= 0 (Sounds6-1+ (World-Sounds6 world_state))) 1 0) (Sounds6-1+ (World-Sounds6 world_state)))
                            (if (= b 4) (if (= 0 (Sounds6-1a (World-Sounds6 world_state))) 1 0) (Sounds6-1a (World-Sounds6 world_state)))
                            (if (= b 5) (if (= 0 (Sounds6-2o (World-Sounds6 world_state))) 1 0) (Sounds6-2o (World-Sounds6 world_state)))
                            (if (= b 6) (if (= 0 (Sounds6-2e (World-Sounds6 world_state))) 1 0) (Sounds6-2e (World-Sounds6 world_state)))
                            (if (= b 7) (if (= 0 (Sounds6-2+ (World-Sounds6 world_state))) 1 0) (Sounds6-2+ (World-Sounds6 world_state)))
                            (if (= b 8) (if (= 0 (Sounds6-2a (World-Sounds6 world_state))) 1 0) (Sounds6-2a (World-Sounds6 world_state)))
                            (if (= b 9) (if (= 0 (Sounds6-3o (World-Sounds6 world_state))) 1 0) (Sounds6-3o (World-Sounds6 world_state)))
                            (if (= b 10) (if (= 0 (Sounds6-3e (World-Sounds6 world_state))) 1 0) (Sounds6-3e (World-Sounds6 world_state)))
                            (if (= b 11) (if (= 0 (Sounds6-3+ (World-Sounds6 world_state))) 1 0) (Sounds6-3+ (World-Sounds6 world_state)))
                            (if (= b 12) (if (= 0 (Sounds6-3a (World-Sounds6 world_state))) 1 0) (Sounds6-3a (World-Sounds6 world_state)))
                            (if (= b 13) (if (= 0 (Sounds6-4o (World-Sounds6 world_state))) 1 0) (Sounds6-4o (World-Sounds6 world_state)))
                            (if (= b 14) (if (= 0 (Sounds6-4e (World-Sounds6 world_state))) 1 0) (Sounds6-4e (World-Sounds6 world_state)))
                            (if (= b 15) (if (= 0 (Sounds6-4+ (World-Sounds6 world_state))) 1 0) (Sounds6-4+ (World-Sounds6 world_state)))
                            (if (= b 16) (if (= 0 (Sounds6-4a (World-Sounds6 world_state))) 1 0) (Sounds6-4a (World-Sounds6 world_state))))
                            (World-Sounds6 world_state))
                        (if (= a 7)
                            (make-Sounds7 (Sounds7-pause-button (World-Sounds7 world_state))
                            (if (= b 1) (if (= 0 (Sounds7-1o (World-Sounds7 world_state))) 1 0) (Sounds7-1o (World-Sounds7 world_state)))
                            (if (= b 2) (if (= 0 (Sounds7-1e (World-Sounds7 world_state))) 1 0) (Sounds7-1e (World-Sounds7 world_state)))
                            (if (= b 3) (if (= 0 (Sounds7-1+ (World-Sounds7 world_state))) 1 0) (Sounds7-1+ (World-Sounds7 world_state)))
                            (if (= b 4) (if (= 0 (Sounds7-1a (World-Sounds7 world_state))) 1 0) (Sounds7-1a (World-Sounds7 world_state)))
                            (if (= b 5) (if (= 0 (Sounds7-2o (World-Sounds7 world_state))) 1 0) (Sounds7-2o (World-Sounds7 world_state)))
                            (if (= b 6) (if (= 0 (Sounds7-2e (World-Sounds7 world_state))) 1 0) (Sounds7-2e (World-Sounds7 world_state)))
                            (if (= b 7) (if (= 0 (Sounds7-2+ (World-Sounds7 world_state))) 1 0) (Sounds7-2+ (World-Sounds7 world_state)))
                            (if (= b 8) (if (= 0 (Sounds7-2a (World-Sounds7 world_state))) 1 0) (Sounds7-2a (World-Sounds7 world_state)))
                            (if (= b 9) (if (= 0 (Sounds7-3o (World-Sounds7 world_state))) 1 0) (Sounds7-3o (World-Sounds7 world_state)))
                            (if (= b 10) (if (= 0 (Sounds7-3e (World-Sounds7 world_state))) 1 0) (Sounds7-3e (World-Sounds7 world_state)))
                            (if (= b 11) (if (= 0 (Sounds7-3+ (World-Sounds7 world_state))) 1 0) (Sounds7-3+ (World-Sounds7 world_state)))
                            (if (= b 12) (if (= 0 (Sounds7-3a (World-Sounds7 world_state))) 1 0) (Sounds7-3a (World-Sounds7 world_state)))
                            (if (= b 13) (if (= 0 (Sounds7-4o (World-Sounds7 world_state))) 1 0) (Sounds7-4o (World-Sounds7 world_state)))
                            (if (= b 14) (if (= 0 (Sounds7-4e (World-Sounds7 world_state))) 1 0) (Sounds7-4e (World-Sounds7 world_state)))
                            (if (= b 15) (if (= 0 (Sounds7-4+ (World-Sounds7 world_state))) 1 0) (Sounds7-4+ (World-Sounds7 world_state)))
                            (if (= b 16) (if (= 0 (Sounds7-4a (World-Sounds7 world_state))) 1 0) (Sounds7-4a (World-Sounds7 world_state))))
                            (World-Sounds7 world_state))
                        (if (= a 8)
                            (make-Sounds8 (Sounds8-pause-button (World-Sounds8 world_state))
                            (if (= b 1) (if (= 0 (Sounds8-1o (World-Sounds8 world_state))) 1 0) (Sounds8-1o (World-Sounds8 world_state)))
                            (if (= b 2) (if (= 0 (Sounds8-1e (World-Sounds8 world_state))) 1 0) (Sounds8-1e (World-Sounds8 world_state)))
                            (if (= b 3) (if (= 0 (Sounds8-1+ (World-Sounds8 world_state))) 1 0) (Sounds8-1+ (World-Sounds8 world_state)))
                            (if (= b 4) (if (= 0 (Sounds8-1a (World-Sounds8 world_state))) 1 0) (Sounds8-1a (World-Sounds8 world_state)))
                            (if (= b 5) (if (= 0 (Sounds8-2o (World-Sounds8 world_state))) 1 0) (Sounds8-2o (World-Sounds8 world_state)))
                            (if (= b 6) (if (= 0 (Sounds8-2e (World-Sounds8 world_state))) 1 0) (Sounds8-2e (World-Sounds8 world_state)))
                            (if (= b 7) (if (= 0 (Sounds8-2+ (World-Sounds8 world_state))) 1 0) (Sounds8-2+ (World-Sounds8 world_state)))
                            (if (= b 8) (if (= 0 (Sounds8-2a (World-Sounds8 world_state))) 1 0) (Sounds8-2a (World-Sounds8 world_state)))
                            (if (= b 9) (if (= 0 (Sounds8-3o (World-Sounds8 world_state))) 1 0) (Sounds8-3o (World-Sounds8 world_state)))
                            (if (= b 10) (if (= 0 (Sounds8-3e (World-Sounds8 world_state))) 1 0) (Sounds8-3e (World-Sounds8 world_state)))
                            (if (= b 11) (if (= 0 (Sounds8-3+ (World-Sounds8 world_state))) 1 0) (Sounds8-3+ (World-Sounds8 world_state)))
                            (if (= b 12) (if (= 0 (Sounds8-3a (World-Sounds8 world_state))) 1 0) (Sounds8-3a (World-Sounds8 world_state)))
                            (if (= b 13) (if (= 0 (Sounds8-4o (World-Sounds8 world_state))) 1 0) (Sounds8-4o (World-Sounds8 world_state)))
                            (if (= b 14) (if (= 0 (Sounds8-4e (World-Sounds8 world_state))) 1 0) (Sounds8-4e (World-Sounds8 world_state)))
                            (if (= b 15) (if (= 0 (Sounds8-4+ (World-Sounds8 world_state))) 1 0) (Sounds8-4+ (World-Sounds8 world_state)))
                            (if (= b 16) (if (= 0 (Sounds8-4a (World-Sounds8 world_state))) 1 0) (Sounds8-4a (World-Sounds8 world_state))))
                            (World-Sounds8 world_state))
                        ))
 
;handles mouse functions for the "make beat" screen
(define (mouse_beat_screen world_state x_position y_position event_name) (if (equal? event_name "button-down")
       (cond 
           [(inrange? y_position 100 125)
               (cond 
 ;START OF SOUND1 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
                 [(inrange? x_position 100 125)
                  (update_Sounds 1 1 world_state)]                 
                 [(inrange? x_position 140 165)
                  (update_Sounds 1 2 world_state)]
                 [(inrange? x_position 180 205)
                  (update_Sounds 1 3 world_state)]
                 [(inrange? x_position 220 245)
                  (update_Sounds 1 4 world_state)]
                 [(inrange? x_position 260 285)
                  (update_Sounds 1 5 world_state)]
                 [(inrange? x_position 300 325)
                  (update_Sounds 1 6 world_state)]
                 [(inrange? x_position 340 365)
                  (update_Sounds 1 7 world_state)]
                 [(inrange? x_position 380 405)
                  (update_Sounds 1 8 world_state)]
                 [(inrange? x_position 420 445)
                  (update_Sounds 1 9 world_state)]
                 [(inrange? x_position 460 485)
                  (update_Sounds 1 10 world_state)]
                 [(inrange? x_position 500 525)
                  (update_Sounds 1 11 world_state)]
                 [(inrange? x_position 540 565)
                  (update_Sounds 1 12 world_state)]
                 [(inrange? x_position 580 605)
                  (update_Sounds 1 13 world_state)]
                 [(inrange? x_position 620 645)
                  (update_Sounds 1 14 world_state)]
                 [(inrange? x_position 660 685)
                  (update_Sounds 1 15 world_state)]
                 [(inrange? x_position 700 725)
                  (update_Sounds 1 16 world_state)]
                 [else world_state])]
                
 ;;START OF SOUND 2 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 
           [(inrange? y_position 140 180)
            (cond
              [(inrange? x_position 100 125)
               (update_Sounds 2 1 world_state)]                
              [(inrange? x_position 140 165)
               (update_Sounds 2 2 world_state)]
              [(inrange? x_position 180 205)
               (update_Sounds 2 3 world_state)]
              [(inrange? x_position 220 245)
               (update_Sounds 2 4 world_state)]
              [(inrange? x_position 260 285)
               (update_Sounds 2 5 world_state)]
              [(inrange? x_position 300 325)
               (update_Sounds 2 6 world_state)]
              [(inrange? x_position 340 365)
               (update_Sounds 2 7 world_state) ]
              [(inrange? x_position 380 405)
               (update_Sounds 2 8 world_state)]
              [(inrange? x_position 420 445)
               (update_Sounds 2 9 world_state)]
              [(inrange? x_position 460 485)
               (update_Sounds 2 10 world_state)]
              [(inrange? x_position 500 525)
               (update_Sounds 2 11 world_state)]
              [(inrange? x_position 540 565)
               (update_Sounds 2 12 world_state)]
              [(inrange? x_position 580 605)
               (update_Sounds 2 13 world_state)]
              [(inrange? x_position 620 645)
               (update_Sounds 2 14 world_state)]
              [(inrange? x_position 660 685)
               (update_Sounds 2 15 world_state)]
              [(inrange? x_position 700 725)
               (update_Sounds 2 16 world_state)]
              
              [else world_state])]
;START OF SOUND 3 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
[(inrange? y_position 180 220)
 (cond
   [(inrange? x_position 100 125)
    (update_Sounds 3 1 world_state)]   
   [(inrange? x_position 140 165)
    (update_Sounds 3 2 world_state)]
   [(inrange? x_position 180 205)
    (update_Sounds 3 3 world_state)]
   [(inrange? x_position 220 245)
    (update_Sounds 3 4 world_state)]
   [(inrange? x_position 260 285)
    (update_Sounds 3 5 world_state)]
   [(inrange? x_position 300 325)
    (update_Sounds 3 6 world_state)]
   [(inrange? x_position 340 365)
    (update_Sounds 3 7 world_state)]
   [(inrange? x_position 380 405)
    (update_Sounds 3 8 world_state)]
   [(inrange? x_position 420 445)
    (update_Sounds 3 9 world_state)]
   [(inrange? x_position 460 485)
    (update_Sounds 3 10 world_state)]
   [(inrange? x_position 500 525)
    (update_Sounds 3 11 world_state)]
   [(inrange? x_position 540 565)
    (update_Sounds 3 12 world_state)]
   [(inrange? x_position 580 605)
    (update_Sounds 3 13 world_state)]
   [(inrange? x_position 620 645)
    (update_Sounds 3 14 world_state)]
   [(inrange? x_position 660 685)
    (update_Sounds 3 15 world_state)]
   [(inrange? x_position 700 725)
    (update_Sounds 3 16 world_state)]
   [else world_state])]
;Start of Sound 4 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
[(inrange? y_position 220 260)
 (cond
   [(inrange? x_position 100 125)
    (update_Sounds 4 1 world_state)]   
   [(inrange? x_position 140 165)
    (update_Sounds 4 2 world_state)]
   [(inrange? x_position 180 205)
    (update_Sounds 4 3 world_state)]
   [(inrange? x_position 220 245)
    (update_Sounds 4 4 world_state)]
   [(inrange? x_position 260 285)
    (update_Sounds 4 5 world_state)]
   [(inrange? x_position 300 325)
    (update_Sounds 4 6 world_state)]
   [(inrange? x_position 340 365)
    (update_Sounds 4 7 world_state)]
   [(inrange? x_position 380 405)
    (update_Sounds 4 8 world_state)]
   [(inrange? x_position 420 445)
    (update_Sounds 4 9 world_state)]
   [(inrange? x_position 460 485)
    (update_Sounds 4 10 world_state)]
   [(inrange? x_position 500 525)
    (update_Sounds 4 11 world_state)]
   [(inrange? x_position 540 565)
    (update_Sounds 4 12 world_state)]
   [(inrange? x_position 580 605)
    (update_Sounds 4 13 world_state)]
   [(inrange? x_position 620 645)
    (update_Sounds 4 14 world_state)]
   [(inrange? x_position 660 685)
    (update_Sounds 4 15 world_state)]
   [(inrange? x_position 700 725)
    (update_Sounds 4 16 world_state)]
   [else world_state])]
;START OF SOUND 5 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
[(inrange? y_position 260 300)
 (cond
   [(inrange? x_position 100 125)
    (update_Sounds 5 1 world_state)]   
   [(inrange? x_position 140 165)
    (update_Sounds 5 2 world_state)]
   [(inrange? x_position 180 205)
    (update_Sounds 5 3 world_state)]
   [(inrange? x_position 220 245)
    (update_Sounds 5 4 world_state)]
   [(inrange? x_position 260 285)
    (update_Sounds 5 5 world_state)]
   [(inrange? x_position 300 325)
    (update_Sounds 5 6 world_state)]
   [(inrange? x_position 340 365)
    (update_Sounds 5 7 world_state)]
   [(inrange? x_position 380 405)
    (update_Sounds 5 8 world_state)]
   [(inrange? x_position 420 445)
    (update_Sounds 5 9 world_state)]
   [(inrange? x_position 460 485)
    (update_Sounds 5 10 world_state)]
   [(inrange? x_position 500 525)
    (update_Sounds 5 11 world_state)]
   [(inrange? x_position 540 565)
    (update_Sounds 5 12 world_state)]
   [(inrange? x_position 580 605)
    (update_Sounds 5 13 world_state)]
   [(inrange? x_position 620 645)
    (update_Sounds 5 14 world_state)]
   [(inrange? x_position 660 685)
    (update_Sounds 5 15 world_state)]
   [(inrange? x_position 700 725)
    (update_Sounds 5 16 world_state)]
   [else world_state])]
;START SOUND 6 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
[(inrange? y_position 300 340)
 (cond
   [(inrange? x_position 100 125)
    (update_Sounds 6 1 world_state)]   
   [(inrange? x_position 140 165)
    (update_Sounds 6 2 world_state)]
   [(inrange? x_position 180 205)
    (update_Sounds 6 3 world_state)]
   [(inrange? x_position 220 245)
    (update_Sounds 6 4 world_state)]
   [(inrange? x_position 260 285)
    (update_Sounds 6 5 world_state)]
   [(inrange? x_position 300 325)
    (update_Sounds 6 6 world_state)]
   [(inrange? x_position 340 365)
    (update_Sounds 6 7 world_state)]
   [(inrange? x_position 380 405)
    (update_Sounds 6 8 world_state)]
   [(inrange? x_position 420 445)
    (update_Sounds 6 9 world_state)]
   [(inrange? x_position 460 485)
    (update_Sounds 6 10 world_state)]
   [(inrange? x_position 500 525)
    (update_Sounds 6 11 world_state)]
   [(inrange? x_position 540 565)
    (update_Sounds 6 12 world_state)]
   [(inrange? x_position 580 605)
    (update_Sounds 6 13 world_state)]
   [(inrange? x_position 620 645)
    (update_Sounds 6 14 world_state)]
   [(inrange? x_position 660 685)
    (update_Sounds 6 15 world_state)]
   [(inrange? x_position 700 725)
    (update_Sounds 6 16 world_state)]
   [else world_state])]
;START OF SOUND 7 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
[(inrange? y_position 340 380)
 (cond
   [(inrange? x_position 100 125)
    (update_Sounds 7 1 world_state)]   
   [(inrange? x_position 140 165)
    (update_Sounds 7 2 world_state)]
   [(inrange? x_position 180 205)
    (update_Sounds 7 3 world_state)]
   [(inrange? x_position 220 245)
    (update_Sounds 7 4 world_state)]
   [(inrange? x_position 260 285)
    (update_Sounds 7 5 world_state)]
   [(inrange? x_position 300 325)
    (update_Sounds 7 6 world_state)]
   [(inrange? x_position 340 365)
    (update_Sounds 7 7 world_state)]
   [(inrange? x_position 380 405)
    (update_Sounds 7 8 world_state)]
   [(inrange? x_position 420 445)
    (update_Sounds 7 9 world_state)]
   [(inrange? x_position 460 485)
    (update_Sounds 7 10 world_state)]
   [(inrange? x_position 500 525)
    (update_Sounds 7 11 world_state)]
   [(inrange? x_position 540 565)
    (update_Sounds 7 12 world_state)]
   [(inrange? x_position 580 605)
    (update_Sounds 7 13 world_state)]
   [(inrange? x_position 620 645)
    (update_Sounds 7 14 world_state)]
   [(inrange? x_position 660 685)
    (update_Sounds 7 15 world_state)]
   [(inrange? x_position 700 725)
    (update_Sounds 7 16 world_state)]
   [else world_state])]
;START OF SOUND 8 OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
[(inrange? y_position 380 420)
 (cond
   [(inrange? x_position 100 125)
    (update_Sounds 8 1 world_state)]   
   [(inrange? x_position 140 165)
    (update_Sounds 8 2 world_state)]
   [(inrange? x_position 180 205)
    (update_Sounds 8 3 world_state)]
   [(inrange? x_position 220 245)
    (update_Sounds 8 4 world_state)]
   [(inrange? x_position 260 285)
    (update_Sounds 8 5 world_state)]
   [(inrange? x_position 300 325)
    (update_Sounds 8 6 world_state)]
   [(inrange? x_position 340 365)
    (update_Sounds 8 7 world_state)]
   [(inrange? x_position 380 405)
    (update_Sounds 8 8 world_state)]
   [(inrange? x_position 420 445)
    (update_Sounds 8 9 world_state)]
   [(inrange? x_position 460 485)
    (update_Sounds 8 10 world_state)]
   [(inrange? x_position 500 525)
    (update_Sounds 8 11 world_state)]
   [(inrange? x_position 540 565)
    (update_Sounds 8 12 world_state)]
   [(inrange? x_position 580 605)
    (update_Sounds 8 13 world_state)]
   [(inrange? x_position 620 645)
    (update_Sounds 8 14 world_state)]
   [(inrange? x_position 660 685)
    (update_Sounds 8 15 world_state)]
   [(inrange? x_position 700 725)
    (update_Sounds 8 16 world_state)]
   [else world_state])]
 
[(and (inrange? x_position 600 700) (inrange? y_position 600 700)) 
 (make-World 0 (World-record-screen world_state) (World-pause? world_state) (World-next-start-time world_state)
             (World-Sounds1 world_state)
             (World-Sounds2 world_state)
             (World-Sounds3 world_state)
             (World-Sounds4 world_state)
             (World-Sounds5 world_state)
             (World-Sounds6 world_state)
             (World-Sounds7 world_state)
             (World-Sounds8 world_state))]
 
[(and (inrange? x_position 155 255) (inrange? y_position 600 700))
 (make-World (World-main-world world_state) 
             (World-record-screen world_state) 
             1 (World-next-start-time world_state)
             (World-Sounds1 world_state)
             (World-Sounds2 world_state)
             (World-Sounds3 world_state)
             (World-Sounds4 world_state)
             (World-Sounds5 world_state)
             (World-Sounds6 world_state)
             (World-Sounds7 world_state)
             (World-Sounds8 world_state))]
 
[(and (inrange? x_position 260 360) (inrange? y_position 600 700))
 (make-World (World-main-world world_state) 
             (World-record-screen world_state) 
             0 (World-next-start-time world_state)
             (World-Sounds1 world_state)
             (World-Sounds2 world_state)
             (World-Sounds3 world_state)
             (World-Sounds4 world_state)
             (World-Sounds5 world_state)
             (World-Sounds6 world_state)
             (World-Sounds7 world_state)
             (World-Sounds8 world_state))]
[(and (inrange? x_position 30 130) (inrange? y_position 600 700))
 (make-World (World-main-world world_state)
             (World-record-screen world_state)
             0 (World-next-start-time world_state)
             (make-Sounds1 (Sounds1-pause-button (World-Sounds1 world_state)) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
             (make-Sounds2 (Sounds2-pause-button (World-Sounds2 world_state)) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
             (make-Sounds3 (Sounds3-pause-button (World-Sounds3 world_state)) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
             (make-Sounds4 (Sounds4-pause-button (World-Sounds4 world_state)) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
             (make-Sounds5 (Sounds5-pause-button (World-Sounds5 world_state)) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
             (make-Sounds6 (Sounds6-pause-button (World-Sounds6 world_state)) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
             (make-Sounds7 (Sounds7-pause-button (World-Sounds7 world_state)) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
             (make-Sounds8 (Sounds8-pause-button (World-Sounds8 world_state)) 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
)]                
[else world_state])
       world_state))                                 
                                                                             
                                                                             
                                                                             
                                                                           ;  (if (inrange? y_position 600 700) 
                                                                           ;        (if (inrange? x_position 600 700) 
                                                                           ;            (make-World 0 (World-record-screen world_state) 
                                                                           ;                          (World-Sounds1 world_state)
                                                                           ;                          (World-Sounds2 world_state)
                                                                           ;                          (World-Sounds3 world_state)
                                                                           ;                          (World-Sounds4 world_state)
                                                                           ;                          (World-Sounds5 world_state)
                                                                           ;                          (World-Sounds6 world_state)
                                                                           ;                          (World-Sounds7 world_state)
                                                                           ;                          (World-Sounds8 world_state))                                                                                       
                                                                           ;            world_state) world_state) world_state))
 
 
;THE PSTREAM STARTS HERE OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
 
(define S1 crash-cymbal) 
(define S2 c-hi-hat-2)
(define S3 o-hi-hat)
(define S4 snare)
(define S5 kick)

 
(define time1 500)(define time2 500)(define time3 500)(define time4 500)(define time5 500)(define time6 500)(define time7 500)
(define time8 500)(define time9 500)(define time10 500)(define time11 500)(define time12 500)(define time13 500)(define time14 500)
(define time15 500)(define time16 500)
 
(define (all a b c d e f g h i j k l m n o p)
  p)


              
   
(define (time-to-play? world_state)
  (< (- (World-next-start-time world_state) 1000) (pstream-current-frame (Sounds1-pause-button (World-Sounds1 world_state)))))

(define (countss a world_state)
  (= a (modulo (Sounds1-counter (World-Sounds1 world_state)) 16)))
 
(define (party world_state)
  (if (and (= 2 (World-main-world world_state)) (= 1 (World-pause? world_state)) (time-to-play? world_state))
  (make-World
   (World-main-world world_state)
   (World-record-screen world_state)
   (World-pause? world_state)
   (+ 5200 (pstream-current-frame (Sounds1-pause-button (World-Sounds1 world_state))))
   (make-Sounds1 
    (all 
     (if (and (countss 0 world_state) (= 1 (Sounds1-1o (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ 500 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 1 world_state) (= 1 (Sounds1-1e (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ 500 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 2 world_state) (= 1 (Sounds1-1+ (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ 500 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 3 world_state) (= 1 (Sounds1-1a (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ 500 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 4 world_state) (= 1 (Sounds1-2o (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time5 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 5 world_state) (= 1 (Sounds1-2e (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time6 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 6 world_state) (= 1 (Sounds1-2+ (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time7 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
    
     (if (and (countss 7 world_state) (= 1 (Sounds1-2a (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time8 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 8 world_state) (= 1 (Sounds1-3o (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time9 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 9 world_state) (= 1 (Sounds1-3e (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time10 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 10 world_state) (= 1 (Sounds1-3+ (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time11 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 11 world_state) (= 1 (Sounds1-3a (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time12 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 12 world_state) (= 1 (Sounds1-4o (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time13 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 13 world_state) (= 1 (Sounds1-4e (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time14 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 14 world_state) (= 1 (Sounds1-4+ (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time15 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state)))
     
     (if (and (countss 15 world_state) (= 1 (Sounds1-4a (World-Sounds1 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S1 
         (+ time16 (World-next-start-time world_state))) (Sounds1-pause-button (World-Sounds1 world_state))))
     
    (Sounds1-1o (World-Sounds1 world_state))
    (Sounds1-1e (World-Sounds1 world_state))
    (Sounds1-1+ (World-Sounds1 world_state))
    (Sounds1-1a (World-Sounds1 world_state))
    (Sounds1-2o (World-Sounds1 world_state))
    (Sounds1-2e (World-Sounds1 world_state))
    (Sounds1-2+ (World-Sounds1 world_state))
    (Sounds1-2a (World-Sounds1 world_state))
    (Sounds1-3o (World-Sounds1 world_state))
    (Sounds1-3e (World-Sounds1 world_state))
    (Sounds1-3+ (World-Sounds1 world_state))
    (Sounds1-3a (World-Sounds1 world_state))
    (Sounds1-4o (World-Sounds1 world_state))
    (Sounds1-4e (World-Sounds1 world_state))
    (Sounds1-4+ (World-Sounds1 world_state))
    (Sounds1-4a (World-Sounds1 world_state))
    (+ 1 (Sounds1-counter (World-Sounds1 world_state)))
    ) 
    (make-Sounds2 
    (all 
     (if (and (countss 0 world_state) (= 1 (Sounds2-1o (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time1 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 1 world_state) (= 1 (Sounds2-1e (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time2 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 2 world_state) (= 1 (Sounds2-1+ (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time3 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 3 world_state) (= 1 (Sounds2-1a (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time4 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 4 world_state) (= 1 (Sounds2-2o (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time5 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 5 world_state) (= 1 (Sounds2-2e (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time6 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 6 world_state) (= 1 (Sounds2-2+ (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time7 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
    
     (if (and (countss 7 world_state) (= 1 (Sounds2-2a (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time8 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 8 world_state) (= 1 (Sounds2-3o (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time9 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 9 world_state) (= 1 (Sounds2-3e (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time10 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 10 world_state) (= 1 (Sounds2-3+ (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time11 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 11 world_state) (= 1 (Sounds2-3a (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time12 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 12 world_state) (= 1 (Sounds2-4o (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time13 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 13 world_state) (= 1 (Sounds2-4e (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time14 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 14 world_state) (= 1 (Sounds2-4+ (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time15 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state)))
     
     (if (and (countss 15 world_state) (= 1 (Sounds2-4a (World-Sounds2 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S2 
         (+ time16 (World-next-start-time world_state))) (Sounds2-pause-button (World-Sounds2 world_state))))
     
    (Sounds2-1o (World-Sounds2 world_state))
    (Sounds2-1e (World-Sounds2 world_state))
    (Sounds2-1+ (World-Sounds2 world_state))
    (Sounds2-1a (World-Sounds2 world_state))
    (Sounds2-2o (World-Sounds2 world_state))
    (Sounds2-2e (World-Sounds2 world_state))
    (Sounds2-2+ (World-Sounds2 world_state))
    (Sounds2-2a (World-Sounds2 world_state))
    (Sounds2-3o (World-Sounds2 world_state))
    (Sounds2-3e (World-Sounds2 world_state))
    (Sounds2-3+ (World-Sounds2 world_state))
    (Sounds2-3a (World-Sounds2 world_state))
    (Sounds2-4o (World-Sounds2 world_state))
    (Sounds2-4e (World-Sounds2 world_state))
    (Sounds2-4+ (World-Sounds2 world_state))
    (Sounds2-4a (World-Sounds2 world_state))
    
    )
 
    (make-Sounds3 
    (all 
     (if (and (countss 0 world_state) (= 1 (Sounds3-1o (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time1 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 1 world_state) (= 1 (Sounds3-1e (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time2 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 2 world_state) (= 1 (Sounds3-1+ (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time3 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 3 world_state) (= 1 (Sounds3-1a (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time4 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 4 world_state) (= 1 (Sounds3-2o (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time5 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 5 world_state) (= 1 (Sounds3-2e (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time6 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 6 world_state) (= 1 (Sounds3-2+ (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time7 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
    
     (if (and (countss 7 world_state) (= 1 (Sounds3-2a (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time8 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 8 world_state) (= 1 (Sounds3-3o (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time9 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 9 world_state) (= 1 (Sounds3-3e (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time10 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 10 world_state) (= 1 (Sounds3-3+ (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time11 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 11 world_state) (= 1 (Sounds3-3a (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time12 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 12 world_state) (= 1 (Sounds3-4o (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time13 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 13 world_state) (= 1 (Sounds3-4e (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time14 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 14 world_state) (= 1 (Sounds3-4+ (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time15 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state)))
     
     (if (and (countss 15 world_state) (= 1 (Sounds3-4a (World-Sounds3 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S3 
         (+ time16 (World-next-start-time world_state))) (Sounds3-pause-button (World-Sounds3 world_state))))
     
    (Sounds3-1o (World-Sounds3 world_state))
    (Sounds3-1e (World-Sounds3 world_state))
    (Sounds3-1+ (World-Sounds3 world_state))
    (Sounds3-1a (World-Sounds3 world_state))
    (Sounds3-2o (World-Sounds3 world_state))
    (Sounds3-2e (World-Sounds3 world_state))
    (Sounds3-2+ (World-Sounds3 world_state))
    (Sounds3-2a (World-Sounds3 world_state))
    (Sounds3-3o (World-Sounds3 world_state))
    (Sounds3-3e (World-Sounds3 world_state))
    (Sounds3-3+ (World-Sounds3 world_state))
    (Sounds3-3a (World-Sounds3 world_state))
    (Sounds3-4o (World-Sounds3 world_state))
    (Sounds3-4e (World-Sounds3 world_state))
    (Sounds3-4+ (World-Sounds3 world_state))
    (Sounds3-4a (World-Sounds3 world_state)))
 
    (make-Sounds4 
    (all 
     (if (and (countss 0 world_state) (= 1 (Sounds4-1o (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time1 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 1 world_state) (= 1 (Sounds4-1e (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time2 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 2 world_state) (= 1 (Sounds4-1+ (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time3 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 3 world_state) (= 1 (Sounds4-1a (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time4 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 4 world_state) (= 1 (Sounds4-2o (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time5 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 5 world_state) (= 1 (Sounds4-2e (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time6 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 6 world_state) (= 1 (Sounds4-2+ (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time7 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
    
     (if (and (countss 7 world_state) (= 1 (Sounds4-2a (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time8 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 8 world_state) (= 1 (Sounds4-3o (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time9 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 9 world_state) (= 1 (Sounds4-3e (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time10 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 10 world_state) (= 1 (Sounds4-3+ (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time11 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 11 world_state) (= 1 (Sounds4-3a (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time12 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 12 world_state) (= 1 (Sounds4-4o (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time13 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 13 world_state) (= 1 (Sounds4-4e (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time14 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 14 world_state) (= 1 (Sounds4-4+ (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time15 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state)))
     
     (if (and (countss 15 world_state) (= 1 (Sounds4-4a (World-Sounds4 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S4 
         (+ time16 (World-next-start-time world_state))) (Sounds4-pause-button (World-Sounds4 world_state))))

     
    (Sounds4-1o (World-Sounds4 world_state))
    (Sounds4-1e (World-Sounds4 world_state))
    (Sounds4-1+ (World-Sounds4 world_state))
    (Sounds4-1a (World-Sounds4 world_state))
    (Sounds4-2o (World-Sounds4 world_state))
    (Sounds4-2e (World-Sounds4 world_state))
    (Sounds4-2+ (World-Sounds4 world_state))
    (Sounds4-2a (World-Sounds4 world_state))
    (Sounds4-3o (World-Sounds4 world_state))
    (Sounds4-3e (World-Sounds4 world_state))
    (Sounds4-3+ (World-Sounds4 world_state))
    (Sounds4-3a (World-Sounds4 world_state))
    (Sounds4-4o (World-Sounds4 world_state))
    (Sounds4-4e (World-Sounds4 world_state))
    (Sounds4-4+ (World-Sounds4 world_state))
    (Sounds4-4a (World-Sounds4 world_state))
    
    )
 
    (make-Sounds5 
    (all 
     (if (and (countss 0 world_state) (= 1 (Sounds5-1o (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time1 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 1 world_state) (= 1 (Sounds5-1e (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time2 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 2 world_state) (= 1 (Sounds5-1+ (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time3 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 3 world_state) (= 1 (Sounds5-1a (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time4 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 4 world_state) (= 1 (Sounds5-2o (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time5 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 5 world_state) (= 1 (Sounds5-2e (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time6 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 6 world_state) (= 1 (Sounds5-2+ (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time7 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
    
     (if (and (countss 7 world_state) (= 1 (Sounds5-2a (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time8 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 8 world_state) (= 1 (Sounds5-3o (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time9 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 9 world_state) (= 1 (Sounds5-3e (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time10 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 10 world_state) (= 1 (Sounds5-3+ (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time11 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 11 world_state) (= 1 (Sounds5-3a (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time12 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 12 world_state) (= 1 (Sounds5-4o (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time13 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 13 world_state) (= 1 (Sounds5-4e (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time14 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 14 world_state) (= 1 (Sounds5-4+ (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time15 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state)))
     
     (if (and (countss 15 world_state) (= 1 (Sounds5-4a (World-Sounds5 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S5 
         (+ time16 (World-next-start-time world_state))) (Sounds5-pause-button (World-Sounds5 world_state))))

     
    (Sounds5-1o (World-Sounds5 world_state))
    (Sounds5-1e (World-Sounds5 world_state))
    (Sounds5-1+ (World-Sounds5 world_state))
    (Sounds5-1a (World-Sounds5 world_state))
    (Sounds5-2o (World-Sounds5 world_state))
    (Sounds5-2e (World-Sounds5 world_state))
    (Sounds5-2+ (World-Sounds5 world_state))
    (Sounds5-2a (World-Sounds5 world_state))
    (Sounds5-3o (World-Sounds5 world_state))
    (Sounds5-3e (World-Sounds5 world_state))
    (Sounds5-3+ (World-Sounds5 world_state))
    (Sounds5-3a (World-Sounds5 world_state))
    (Sounds5-4o (World-Sounds5 world_state))
    (Sounds5-4e (World-Sounds5 world_state))
    (Sounds5-4+ (World-Sounds5 world_state))
    (Sounds5-4a (World-Sounds5 world_state)))
 
    (make-Sounds6 
     (local [(define S6 (record-screen-rec1 (World-record-screen world_state)))]
     (all 
     (if (and (countss 0 world_state) (= 1 (Sounds6-1o (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time1 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 1 world_state) (= 1 (Sounds6-1e (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time2 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 2 world_state) (= 1 (Sounds6-1+ (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time3 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 3 world_state) (= 1 (Sounds6-1a (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time4 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 4 world_state) (= 1 (Sounds6-2o (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time5 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 5 world_state) (= 1 (Sounds6-2e (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time6 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 6 world_state) (= 1 (Sounds6-2+ (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time7 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
    
     (if (and (countss 7 world_state) (= 1 (Sounds6-2a (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time8 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 8 world_state) (= 1 (Sounds6-3o (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time9 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 9 world_state) (= 1 (Sounds6-3e (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time10 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 10 world_state) (= 1 (Sounds6-3+ (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time11 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 11 world_state) (= 1 (Sounds6-3a (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time12 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 12 world_state) (= 1 (Sounds6-4o (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time13 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 13 world_state) (= 1 (Sounds6-4e (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time14 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 14 world_state) (= 1 (Sounds6-4+ (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time15 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state)))
     
     (if (and (countss 15 world_state) (= 1 (Sounds6-4a (World-Sounds6 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S6 
         (+ time16 (World-next-start-time world_state))) (Sounds6-pause-button (World-Sounds6 world_state))))
)
     
    (Sounds6-1o (World-Sounds6 world_state))
    (Sounds6-1e (World-Sounds6 world_state))
    (Sounds6-1+ (World-Sounds6 world_state))
    (Sounds6-1a (World-Sounds6 world_state))
    (Sounds6-2o (World-Sounds6 world_state))
    (Sounds6-2e (World-Sounds6 world_state))
    (Sounds6-2+ (World-Sounds6 world_state))
    (Sounds6-2a (World-Sounds6 world_state))
    (Sounds6-3o (World-Sounds6 world_state))
    (Sounds6-3e (World-Sounds6 world_state))
    (Sounds6-3+ (World-Sounds6 world_state))
    (Sounds6-3a (World-Sounds6 world_state))
    (Sounds6-4o (World-Sounds6 world_state))
    (Sounds6-4e (World-Sounds6 world_state))
    (Sounds6-4+ (World-Sounds6 world_state))
    (Sounds6-4a (World-Sounds6 world_state)))

    (make-Sounds7 
     (local [(define S7 (record-screen-rec2 (World-record-screen world_state)))]
       (all 
     (if (and (countss 0 world_state) (= 1 (Sounds7-1o (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time1 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 1 world_state) (= 1 (Sounds7-1e (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time2 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 2 world_state) (= 1 (Sounds7-1+ (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time3 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 3 world_state) (= 1 (Sounds7-1a (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time4 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 4 world_state) (= 1 (Sounds7-2o (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time5 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 5 world_state) (= 1 (Sounds7-2e (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time6 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 6 world_state) (= 1 (Sounds7-2+ (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time7 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
    
     (if (and (countss 7 world_state) (= 1 (Sounds7-2a (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time8 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 8 world_state) (= 1 (Sounds7-3o (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time9 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 9 world_state) (= 1 (Sounds7-3e (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time10 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 10 world_state) (= 1 (Sounds7-3+ (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time11 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 11 world_state) (= 1 (Sounds7-3a (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time12 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 12 world_state) (= 1 (Sounds7-4o (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time13 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 13 world_state) (= 1 (Sounds7-4e (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time14 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 14 world_state) (= 1 (Sounds7-4+ (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time15 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state)))
     
     (if (and (countss 15 world_state) (= 1 (Sounds7-4a (World-Sounds7 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S7 
         (+ time16 (World-next-start-time world_state))) (Sounds7-pause-button (World-Sounds7 world_state))))
)
     
    (Sounds7-1o (World-Sounds7 world_state))
    (Sounds7-1e (World-Sounds7 world_state))
    (Sounds7-1+ (World-Sounds7 world_state))
    (Sounds7-1a (World-Sounds7 world_state))
    (Sounds7-2o (World-Sounds7 world_state))
    (Sounds7-2e (World-Sounds7 world_state))
    (Sounds7-2+ (World-Sounds7 world_state))
    (Sounds7-2a (World-Sounds7 world_state))
    (Sounds7-3o (World-Sounds7 world_state))
    (Sounds7-3e (World-Sounds7 world_state))
    (Sounds7-3+ (World-Sounds7 world_state))
    (Sounds7-3a (World-Sounds7 world_state))
    (Sounds7-4o (World-Sounds7 world_state))
    (Sounds7-4e (World-Sounds7 world_state))
    (Sounds7-4+ (World-Sounds7 world_state))
    (Sounds7-4a (World-Sounds7 world_state)))

    (make-Sounds8 
     (local [(define S8 (record-screen-rec3 (World-record-screen world_state)))]
    (all 
     (if (and (countss 0 world_state) (= 1 (Sounds8-1o (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time1 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 1 world_state) (= 1 (Sounds8-1e (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time2 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 2 world_state) (= 1 (Sounds8-1+ (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time3 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 3 world_state) (= 1 (Sounds8-1a (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time4 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 4 world_state) (= 1 (Sounds8-2o (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time5 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 5 world_state) (= 1 (Sounds8-2e (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time6 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 6 world_state) (= 1 (Sounds8-2+ (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time7 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
    
     (if (and (countss 7 world_state) (= 1 (Sounds8-2a (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time8 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 8 world_state) (= 1 (Sounds8-3o (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time9 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 9 world_state) (= 1 (Sounds8-3e (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time10 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 10 world_state) (= 1 (Sounds8-3+ (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time11 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 11 world_state) (= 1 (Sounds8-3a (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time12 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 12 world_state) (= 1 (Sounds8-4o (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time13 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 13 world_state) (= 1 (Sounds8-4e (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time14 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 14 world_state) (= 1 (Sounds8-4+ (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time15 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state)))
     
     (if (and (countss 15 world_state) (= 1 (Sounds8-4a (World-Sounds8 world_state)))) (pstream-queue (Sounds1-pause-button (World-Sounds1 world_state)) S8 
         (+ time16 (World-next-start-time world_state))) (Sounds8-pause-button (World-Sounds8 world_state))))
)
     
    (Sounds8-1o (World-Sounds8 world_state))
    (Sounds8-1e (World-Sounds8 world_state))
    (Sounds8-1+ (World-Sounds8 world_state))
    (Sounds8-1a (World-Sounds8 world_state))
    (Sounds8-2o (World-Sounds8 world_state))
    (Sounds8-2e (World-Sounds8 world_state))
    (Sounds8-2+ (World-Sounds8 world_state))
    (Sounds8-2a (World-Sounds8 world_state))
    (Sounds8-3o (World-Sounds8 world_state))
    (Sounds8-3e (World-Sounds8 world_state))
    (Sounds8-3+ (World-Sounds8 world_state))
    (Sounds8-3a (World-Sounds8 world_state))
    (Sounds8-4o (World-Sounds8 world_state))
    (Sounds8-4e (World-Sounds8 world_state))
    (Sounds8-4+ (World-Sounds8 world_state))
    (Sounds8-4a (World-Sounds8 world_state))))
    
  world_state))
 
 
(big-bang start-world
          (to-draw current_screen)
          (on-mouse mouse_handler)
          (on-tick party)
          )
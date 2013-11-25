;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname recorder) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require rsound)
(require rsound/reverb-typed)
(require 2htdp/universe)
(require 2htdp/image)
(define (s sec) (* sec 44100))
(define (draw-world st)
  (empty-scene 20 20))

(define (both a b)b)
(define RECORD-LENGTH (s 2))

(define-struct recording-world (rec1 rec2 rec3))

(define (player st key)  
   (cond
      [(key=? key "1")
       (if (string=? key "1") (make-recording-world (record-sound RECORD-LENGTH) (recording-world-rec2 st) (recording-world-rec3 st)) st)]
      [(key=? key "2")
       (if (string=? key "2") (make-recording-world (recording-world-rec1 st) (record-sound RECORD-LENGTH) (recording-world-rec3 st)) st)]
      [(key=? key "3")
       (if (string=? key "3") (make-recording-world (recording-world-rec1 st) (recording-world-rec2 st) (record-sound RECORD-LENGTH)) st)]
      [(key=? key "4")
       (if (string=? key "4") (both (play (rs-filter (recording-world-rec1 st) reverb)) st) st)]
      [(key=? key "5") 
       (if (string=? key "5") (both (play (rs-filter (recording-world-rec2 st) reverb)) st) st)]
      [(key=? key "6")
       (if (string=? key "6") (both (play (rs-filter (recording-world-rec3 st) reverb)) st) st)]
      [else st]))

(big-bang (make-recording-world 0 0 0)
          [on-key player]
          [to-draw draw-world])
;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname recorder) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require rsound)
(require 2htdp/universe)
(require 2htdp/image)
(define (s sec) (* sec 44100))
(define (draw-world st)
  (empty-scene 20 20))

(define RECORD-LENGTH (s 2))


(define (record st key)
  (local
   [(cond
      [(key=? key "1")
       (if (string=? key "1") sample1 st)]
      [(key=? key "2")
       (if (string=? key "2") sample2 st)]
      [(key=? key "3")
       (if (string=? key "3") sample3 st)]
      [else st])
    (define sample1 (record-sound RECORD-LENGTH))
    (define sample2 (record-sound RECORD-LENGTH))
    (define sample3 (record-sound RECORD-LENGTH))]
   (cond
      [(key=? key "4")
       (if (string=? key "4") (play sample1) st)]
      [(key=? key "5") 
       (if (string=? key "5") (play sample2) st)]
      [(key=? key "6") 
       (if (string=? key "6") (play sample3) st)]
      [else st])))
(big-bang 0
          [on-key record]
          [to-draw draw-world])
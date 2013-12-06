#lang racket

(require rsound)
 
(provide does-recording-work?)
 
;; try to record an incredibly short sound
(define (does-recording-work?)
  (with-handlers ([exn:fail? (lambda (exn) false)])
    (record-sound 10)
    true))
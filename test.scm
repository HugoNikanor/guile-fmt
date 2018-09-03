#!/usr/bin/guile \
-e main -s
!#

(add-to-load-path (dirname (current-filename)))

(use-modules (fmt)
             (ice-9 rdelim))

(define (input-prompt str)
  (display str)
  (display ": ")
  (read-line))

(define (main args)
  (let ((name (input-prompt "What is your name"))
        (age (input-prompt "How old are you")))
    (display (fmt "Hello ${name}, you are ${age} years old!\n"))))

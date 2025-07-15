#lang racket

(require "./charon.rkt")

(command-line
 #:program "charon"
 #:usage-help "make copies by reading charon files"
 #:args (fp) (charon fp))


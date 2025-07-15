#lang racket

(provide recursive-copy)

;; Traverses a directory tree and, while doing so, perform some
;; actions on the directories you encounter before copying stuff.
(define (recursive-copy src dest)
  (if (file-exists? src)
      (copy-file-to-directory src dest)
      (begin
        (actions-on src)
        (let* ([name (path-last src)]
               [new-dest (build-path dest name)])
          (make-directory* new-dest)
          (for-each
           (λ (e) (recursive-copy e new-dest))
           (directory-list src #:build? #t))))))

;; Copy a file into a given directory. Modification times are
;; considered to avoid copying when the copy is already up to date.
(define (copy-file-to-directory src-file dest)
  (try-and-go-on
   [let* ([name (path-last src-file)]
          [copy (build-path dest name)])
     (if (file-exists? copy)
         (let ([mt1 (file-or-directory-modify-seconds src-file)]
               [mt2 (file-or-directory-modify-seconds copy)])
           (when (> mt1 mt2)
             (copy-file src-file copy #:exists-ok? #t)))
         (copy-file src-file copy #:exists-ok? #t))]))

;; Actions to perform on directories prior to copying them.
(define (actions-on dir)
  (current-directory dir)
  (let* ([dir-cont (map path->string (directory-list dir))]
         [exts (map path-get-extension dir-cont)])
    (cond
      ;; projects managed with `make`
      [(member "Makefile" dir-cont)
       (printf "INFO: running \"make clean\" in ~a...\n" dir)
       (system "make clean")]
      ;; Haskell projects
      [(member ".stack-work" dir-cont)
       (printf "INFO: running \"stack purge\" in ~a...\n" dir)
       (system "stack purge")]
      [(member #".cabal" exts)
       (printf "INFO: running \"cabal clean\" in ~a...\n" dir)
       (system "cabal clean")])))

(define path-last
  (compose last explode-path))

;; HELPERS

;; Try to perform an action. If any failure occurs, just print the
;; error and go ahead as if nothing happened.
(define-syntax-rule (try-and-go-on action)
  (with-handlers ([exn:fail? handle-failure])
    action))
(define (handle-failure err)
  (printf "ERROR: ~a\n" (exn-message err)))

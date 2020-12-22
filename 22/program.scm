#!/usr/bin/env guile -s
!#

(use-modules (ice-9 rdelim))
(use-modules (srfi srfi-1))

(define (readlines file)
 (let ((infile (open-input-file file)))
   (let loop ((lines '())
              (next-line (read-line infile)))
    (if (eof-object? next-line)
        (begin (close-input-port infile)
               (reverse lines))
        (loop (cons next-line lines)
              (read-line infile))))))

(define (split-list lst)
  (let ((half (quotient (length lst) 2)))
    (cons (take lst half)
          (drop lst half))))

(define (read-cards file)
  (split-list (map string->number
                   (filter (lambda (x) (not (or (string=? x "Player 1:")
                                                (string=? x "Player 2:")
                                                (string=? x ""))))
                           (readlines file)))))

(define (one-round cards)
  (let* ((p1cards (car cards))
         (p2cards (cdr cards))
         (p1 (car p1cards))
         (p2 (car p2cards)))
    (if (> p1 p2)
        (cons (append (cdr p1cards) (list p1 p2))
              (cdr p2cards))
        (cons (cdr p1cards)
              (append (cdr p2cards) (list p2 p1))))))

(define (score-deck cards)
  (define (score-helper factor cards)
    (if (null? cards) 0
        (+ (* factor (car cards))
           (score-helper (- factor 1) (cdr cards)))))
  (score-helper (length cards) cards))

(define (play-combat start-cards)
  (let loop ((cards start-cards))
    (let ((p1cards (car cards))
          (p2cards (cdr cards)))
      (cond
       ((null? p1cards) p2cards)
       ((null? p2cards) p1cards)
       (else (loop (one-round cards)))))))

(define start-cards (read-cards "input.txt"))

(display (score-deck (play-combat start-cards)))
(newline)

;;; part 2

(define (play-recursive-combat start-cards)
  (let loop ((cards start-cards)
             (history '()))
    (let ((p1cards (car cards))
          (p2cards (cdr cards)))
      (cond
       ((member cards history) (cons 'p1 p1cards))
       ((null? p1cards) (cons 'p2 p2cards))
       ((null? p2cards) (cons 'p1 p1cards))
       (else
        (let ((p1card (car p1cards))
              (p2card (car p2cards))
              (p1rest (cdr p1cards))
              (p2rest (cdr p2cards)))
          (if (and (>= (length p1rest) p1card)
                   (>= (length p2rest) p2card))
              (let* ((subgame (play-recursive-combat (cons (take p1rest p1card) (take p2rest p2card))))
                     (winner (car subgame)))
                (loop
                 (if (eq? winner 'p1)
                     (cons (append p1rest (list p1card p2card))
                           p2rest)
                     (cons p1rest
                           (append p2rest (list p2card p1card))))
                 (cons cards history)))
              (loop (one-round cards) (cons cards history)))))))))

(display (score-deck (cdr (play-recursive-combat start-cards))))
(newline)

(defconstant +start+ '(13 0 10 12 1 5 8))

(defun next-number (lst)
  (let ((f (car lst))
        (r (cdr lst)))
    (if (member f r)
        (- (length lst)
           (- (length r) (position f r)))
      0)))

(defun nth-number (n start)
  (let ((lst (reverse start)))
    (loop while (< (length lst) n)
          do (setq lst (cons (next-number lst) lst)))
    (first lst)))

(print (nth-number 2020 +start+))

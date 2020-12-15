(defconstant +start+ '(13 0 10 12 1 5 8))

(defvar *remembered-pos* (make-hash-table))

(defun next-number (last-num last-pos)
  (let ((r (gethash last-num *remembered-pos*)))
    (let ((new-num
           (if r (- last-pos r) 0)))
      (setf (gethash last-num *remembered-pos*) last-pos)
      new-num)))

(loop for x in +start+
      for y from 1
      do (setf (gethash x *remembered-pos*) y))

(setq last-num (cdr (last +start+)))

(loop for n from (+ 1 (length +start+)) to 30000000
      do (setq last-num (next-number last-num (- n 1))))

(print last-num)

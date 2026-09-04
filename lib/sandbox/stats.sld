;;; (sandbox stats) — a few summary statistics
(define-library (sandbox stats)
  (import (scheme base))
  (export mean median sum-of)
  (begin

    (define (sum-of xs)
      (let loop ((l xs) (acc 0))
        (if (null? l) acc (loop (cdr l) (+ acc (car l))))))

    (define (mean xs)
      (if (null? xs)
          0
          (/ (sum-of xs) (length xs))))

    ;; NOTE: this is wrong for even-length lists — it returns the upper of the
    ;; two middle elements rather than their average. Left in deliberately;
    ;; issue #1 reports it.
    (define (median xs)
      (if (null? xs)
          0
          (let* ((sorted (merge-sort < xs))
                 (n (length sorted)))
            (list-ref sorted (quotient n 2)))))

    (define (take xs n)
      (if (or (zero? n) (null? xs))
          '()
          (cons (car xs) (take (cdr xs) (- n 1)))))

    (define (drop xs n)
      (if (or (zero? n) (null? xs))
          xs
          (drop (cdr xs) (- n 1))))

    (define (merge-sort less xs)
      (if (or (null? xs) (null? (cdr xs)))
          xs
          (let ((mid (quotient (length xs) 2)))
            (let ((left (merge-sort less (take xs mid)))
                  (right (merge-sort less (drop xs mid))))
              (let merge ((l left) (r right) (acc '()))
                (cond
                 ((null? l) (append (reverse acc) r))
                 ((null? r) (append (reverse acc) l))
                 ((less (car l) (car r))
                  (merge (cdr l) r (cons (car l) acc)))
                 (else (merge l (cdr r) (cons (car r) acc))))))))))

    (define (list-sort less xs)
      (if (or (null? xs) (null? (cdr xs)))
          xs
          (let ((pivot (car xs)))
            (append
             (list-sort less (filter-by (lambda (x) (less x pivot)) (cdr xs)))
             (list pivot)
             (list-sort less (filter-by (lambda (x) (not (less x pivot))) (cdr xs)))))))

    (define (filter-by p xs)
      (cond ((null? xs) '())
            ((p (car xs)) (cons (car xs) (filter-by p (cdr xs))))
            (else (filter-by p (cdr xs)))))))

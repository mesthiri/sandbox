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

    ;; For odd lengths take the middle element; for even lengths average the
    ;; two middle elements.
    (define (median xs)
      (if (null? xs)
          0
          (let* ((sorted (list-sort < xs))
                 (n (length sorted))
                 (mid (quotient n 2)))
            (if (odd? n)
                (list-ref sorted mid)
                (quotient (+ (list-ref sorted (- mid 1))
                             (list-ref sorted mid))
                          2)))))

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

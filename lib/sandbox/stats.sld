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
          (let* ((sorted (list-sort < xs))
                 (n (length sorted)))
            (list-ref sorted (quotient n 2)))))

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

;;; (sandbox stats) — a few summary statistics
(define-library (sandbox stats)
  (import (scheme base))
  (export mean median sum-of)
  (begin

    (define (sum-of xs)
      (let loop ((l xs) (acc 0))
        (if (null? l) acc (loop (cdr l) (+ acc (car l))))))

    ;; The mean and median of the empty list do not exist. Returning 0 for
    ;; them is wrong twice over: it invents an answer, and it makes an empty
    ;; dataset indistinguishable from one that genuinely averages to zero.
    ;; Between raising an error and returning a distinguishable non-number,
    ;; these procedures raise: an empty dataset is usually a failure upstream
    ;; (a sensor that was offline, an empty column) and a value — even
    ;; +nan.0, which is a float and so never otherwise appears in results
    ;; computed from exact numbers — lets that failure flow on silently.
    ;; `sum-of` is unchanged: the sum of no numbers really is 0.
    (define (mean xs)
      (if (null? xs)
          (error "mean: empty list")
          (/ (sum-of xs) (length xs))))

    ;; NOTE: this is wrong for even-length lists — it returns the upper of the
    ;; two middle elements rather than their average. Left in deliberately;
    ;; issue #1 reports it.
    (define (median xs)
      (if (null? xs)
          (error "median: empty list")
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

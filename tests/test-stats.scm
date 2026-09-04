(import (scheme base) (scheme write) (sandbox stats))

(define pass 0) (define fail 0)
(define (check name expected actual)
  (if (equal? expected actual)
      (begin (set! pass (+ pass 1)) (display "  PASS: ") (display name) (newline))
      (begin (set! fail (+ fail 1)) (display "  FAIL: ") (display name) (newline)
             (display "    expected: ") (write expected) (newline)
             (display "    got:      ") (write actual) (newline))))

(display "(sandbox stats)\n")
(check "sum" 10 (sum-of '(1 2 3 4)))
(check "mean" 5 (mean '(4 5 6)))
(check "median of odd length" 5 (median '(9 5 1)))
;; Deliberately not asserted yet — see issue #1. Adding this assertion is the
;; change the code stage is expected to make, alongside fixing `median`.
;; (check "median of even length" 5 (median '(4 6 1 9)))

;; The empty list: the mean and median of no numbers do not exist, so both
;; must raise an error rather than return a plausible-looking 0.
(check "mean of empty list raises" "mean: empty list"
       (guard (e ((error-object? e) (error-object-message e)))
         (mean '())
         'returned-a-value))
(check "median of empty list raises" "median: empty list"
       (guard (e ((error-object? e) (error-object-message e)))
         (median '())
         'returned-a-value))
;; A dataset that genuinely averages to zero still reports 0 — the point of
;; raising on the empty list is that the two cases stay distinguishable.
(check "mean of zeros is a real 0" 0 (mean '(0 0)))

(newline)
(display "  ") (display pass) (display " passed, ") (display fail) (display " failed") (newline)
(if (> fail 0) (exit 1) (exit 0))

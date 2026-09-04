(import (scheme base) (scheme write) (sandbox stats))

;; Import stats library might be wrong path, adjusting for kaappi usage:
(import (sandbox stats))

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

;; Performance test for median quadratic stack overflow on sorted list.
(let ((test-list (iota 1000)))
  ;; Just check it runs and returns the median 500 (the upper middle).
  (check "median large sorted list" 500 (median test-list)))
;; Deliberately not asserted yet — see issue #1. Adding this assertion is the
;; change the code stage is expected to make, alongside fixing `median`.  
;; (check "median of even length" 5 (median '(4 6 1 9)))

(newline)
(display "  ") (display pass) (display " passed, ") (display fail) (display " failed") (newline)
(if (> fail 0) (exit 1) (exit 0))

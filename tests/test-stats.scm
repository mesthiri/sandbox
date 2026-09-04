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
(check "median of even length" 5 (median '(4 6 1 9)))

(newline)
(display "  ") (display pass) (display " passed, ") (display fail) (display " failed") (newline)
(if (> fail 0) (exit 1) (exit 0))

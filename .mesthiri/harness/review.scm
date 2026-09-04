;;; Review argues with a diff, which is the harder job — and it must not use
;;; the same provider and model as the code stage, or it inherits the blind
;;; spots it exists to catch. mesthiri refuses a config where they match.
(harness
  (provider deepseek)
  ;; A different provider entirely, not just a different model. mesthiri
  ;; refuses a config where the reviewer runs the implementer's provider and
  ;; model; beyond that rule, a reviewer on other weights is the point —
  ;; shared blind spots are what adversarial verification exists to catch.
  (model "deepseek-v4-flash")
  (effort high)
  (budgets (tokens 200000) (turns 45)))

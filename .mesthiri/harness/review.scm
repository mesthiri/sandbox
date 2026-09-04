;;; Review argues with a diff, which is the harder job — and it must not use
;;; the same provider and model as the code stage, or it inherits the blind
;;; spots it exists to catch. mesthiri refuses a config where they match.
(harness
  (provider zai)
  (model "glm-5.3")
  (effort high)
  (budgets (tokens 200000) (turns 30)))

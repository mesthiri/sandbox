;;; Review argues with a diff, which is the harder job — and it must not use
;;; the same provider and model as the code stage, or it inherits the blind
;;; spots it exists to catch. mesthiri refuses a config where they match.
(harness
  (provider zai)
  ;; Deliberately not glm-5.3: that is what the code stage uses, and
  ;; mesthiri refuses a config where the reviewer is the implementer.
  (model "glm-5.2")
  (effort high)
  (budgets (tokens 200000) (turns 30)))

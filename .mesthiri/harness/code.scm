;;; The code stage writes the patch. It uses glm-5.3, which is the model
;;; that produced a correct minimal fix for issue #1 when this was first
;;; run by hand.
;;;
;;; Review must not use this same provider and model — mesthiri refuses a
;;; config where they match, because a reviewer sharing the implementer's
;;; blind spots is exactly what adversarial verification exists to catch.
;;; Review is on glm-5.2 for that reason, not because it is weaker or
;;; stronger.
(harness
  (provider zai)
  (model "glm-5.3")
  (effort high)
  (budgets (tokens 200000) (turns 40)))

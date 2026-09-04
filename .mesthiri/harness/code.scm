;;; The code stage writes the patch.
;;;
;;; Deliberately the weakest model on the account that can still drive pi's
;;; agentic loop. This is a test configuration: glm-5.3 wrote correct,
;;; well-argued code for issues #1 and #7 and review found nothing on either,
;;; which left mesthiri's `fix` stage with nothing to consume and its write
;;; path unexercised. A weak implementer is how findings get produced
;;; honestly, rather than by planting a defect.
;;;
;;; gpt-4.1-mini, arrived at by measurement rather than by guessing. Two
;;; weaker models were tried on issue #9 and neither settled:
;;;
;;;   gpt-4.1-nano   41 turns, 10,995 tokens
;;;   gpt-4o-mini    41 turns, 11,742 tokens
;;;
;;; Both hit the TURN cap, not the token cap, and the trace says why: 44
;;; tool calls spent guessing filenames — lib/median.scm, lib/sorts.scm,
;;; lib/statistics.scm, lib/your-sort-implementation.scm — instead of
;;; listing the directory. Genuine weakness, not a provider misconfiguration
;;; (the same wiring serves glm-5.3 and deepseek-v4-flash fine).
;;;
;;; The useful band is a model that finishes the job badly, not one that
;;; cannot finish it: an unsettled run produces no pull request, so review
;;; has nothing to read and fix has nothing to consume.
;;;
;;; Turns raised to 60 for the same reason. A weaker model needs more steps
;;; to do the same work, and 40 was tuned against glm-5.3.
;;;
;;; Review must not use this same provider and model — mesthiri refuses a
;;; config where they match, because a reviewer sharing the implementer's
;;; blind spots is exactly what adversarial verification exists to catch.
;;; Review is on deepseek-v4-flash, a different provider entirely.
(harness
  (provider openai)
  (model "gpt-4.1-mini")
  (effort high)
  (budgets (tokens 200000) (turns 60)))

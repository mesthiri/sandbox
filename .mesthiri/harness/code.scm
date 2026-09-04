;;; The code stage writes the patch.
;;;
;;; Deliberately the weakest model on the account that can still drive pi's
;;; agentic loop. This is a test configuration: glm-5.3 wrote correct,
;;; well-argued code for issues #1 and #7 and review found nothing on either,
;;; which left mesthiri's `fix` stage with nothing to consume and its write
;;; path unexercised. A weak implementer is how findings get produced
;;; honestly, rather than by planting a defect.
;;;
;;; gpt-4.1-nano and not gpt-3.5-turbo: both tool-call in a single turn, but
;;; a model that falls apart across a 40-turn session fails the run instead
;;; of writing weak code, and that failure looks nothing like the thing we
;;; are trying to observe.
;;;
;;; Review must not use this same provider and model — mesthiri refuses a
;;; config where they match, because a reviewer sharing the implementer's
;;; blind spots is exactly what adversarial verification exists to catch.
;;; Review is on deepseek-v4-flash, a different provider entirely.
(harness
  (provider openai)
  (model "gpt-4.1-nano")
  (effort high)
  (budgets (tokens 200000) (turns 40)))

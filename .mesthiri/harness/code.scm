;;; The code stage writes the patch.
;;;
;;; Deliberately the weakest model on the account that can still drive pi's
;;; agentic loop. This is a test configuration: glm-5.3 wrote correct,
;;; well-argued code for issues #1 and #7 and review found nothing on either,
;;; which left mesthiri's `fix` stage with nothing to consume and its write
;;; path unexercised. A weak implementer is how findings get produced
;;; honestly, rather than by planting a defect.
;;;
;;; gpt-4o-mini, arrived at by measurement. gpt-4.1-nano was tried first and
;;; is too weak: it spent all 40 turns on 10,995 tokens — roughly 270 per
;;; turn — and never settled. That is the disintegration failure, not weak
;;; code, and it tells us nothing about what a reviewer would find. The
;;; useful band is a model that finishes the job badly, not one that cannot
;;; finish it.
;;;
;;; Review must not use this same provider and model — mesthiri refuses a
;;; config where they match, because a reviewer sharing the implementer's
;;; blind spots is exactly what adversarial verification exists to catch.
;;; Review is on deepseek-v4-flash, a different provider entirely.
(harness
  (provider openai)
  (model "gpt-4o-mini")
  (effort high)
  (budgets (tokens 200000) (turns 40)))

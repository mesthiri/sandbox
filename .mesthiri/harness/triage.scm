;;; Triage reads an issue and applies the rubric. It does not need a large
;;; model, and paying for one on every incoming issue is the cheapest way to
;;; make this expensive for no benefit.
(harness
  (provider deepseek)
  (model "deepseek-v4-flash")
  (effort low)
  (budgets (tokens 60000) (turns 12)))

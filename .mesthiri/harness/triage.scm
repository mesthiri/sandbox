;;; Triage reads an issue and applies the rubric. It does not need a large
;;; model, and paying for one on every incoming issue is the cheapest way to
;;; make this expensive for no benefit.
(harness
  ;; zai rather than deepseek, because the model-key channel holds the GLM
  ;; key: see the note in ../config.scm about there being only one.
  (provider zai)
  (model "glm-5.3")
  (effort low)
  (budgets (tokens 60000) (turns 12)))

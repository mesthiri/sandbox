;;; mesthiri configuration for the sandbox repository.
;;;
;;; Hand-committed: `mesthiri install` is M9 and does not exist yet.
;;;
;;; The two App ids are real and are public configuration; only the private
;;; keys are secrets, and those are repository secrets on this repo.
(mesthiri
  (version 1)

  (operator "Baiju Muthukadan" "baiju.m.mail@gmail.com")

  (apps (reader 4825652) (writer 4825675))

  (agent (backend pi) (version "0.84.4"))

  (providers
    (main (endpoint "https://api.anthropic.com")
          (secret MESTHIRI_MODEL_KEY)
          (key-env ANTHROPIC_API_KEY)))

  (rubric ".mesthiri/rubric.md")

  (deny-paths ".mesthiri/**" ".github/workflows/**")

  (budgets
    (per-run (tokens 200000) (turns 40) (wall-clock "20m"))
    (per-day (runs 12)))

  (commands (triage    (min-permission triage))
            (implement (min-permission write))
            (review    (min-permission triage))
            (fix       (min-permission write))
            (retro     (min-permission triage)))

  ;; Everything off except triage in dry-run. Merging this must not start
  ;; opening pull requests.
  (stages
    (triage     (on (or (issue-opened) (issue-reopened) (command "/triage")))
                (mode dry-run))
    (prioritize (on (schedule "08:00"))                       (mode off))
    (code       (on (or (label "ready-to-implement") (command "/implement")))
                (mode off) (max-tier 0))
    (review     (on (pull-request-updated))                   (mode off))
    (fix        (on (command "/fix"))                         (mode off))
    (retro      (on (schedule "sunday 06:00"))                (mode off))))

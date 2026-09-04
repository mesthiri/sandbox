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

  ;; Two providers. Which one a role uses is that role's choice, in
  ;; .mesthiri/harness/<role>.scm — triage applies a rubric to an issue,
  ;; review argues with a diff, and they do not need the same model.
  ;;
  ;; `secret` is the repository secret holding the key; the shim lists which
  ;; secrets to forward in `model-secrets`, and only those are exported.
  ;; `key-env` is the name the agent reads it from — the vendor's client
  ;; decides that, not us. Endpoints are each vendor's own.
  (providers
    (deepseek (endpoint "https://api.deepseek.com")
              (secret DEEPSEEK_API_KEY)
              (key-env DEEPSEEK_API_KEY)
              (api openai-completions))
    (zai (endpoint "https://api.z.ai/api/paas/v4/")
         (secret GLM_API_KEY)
         (key-env GLM_API_KEY)
         (api openai-completions)))

  (rubric ".mesthiri/rubric.md")

  ;; How this repository's tests run. The code stage's prompt tells the agent
  ;; to get this green before it reports done; without it the prompt says
  ;; "(none configured)" and the agent has to guess.
  (test-command "kaappi --lib-path ./lib tests/test-stats.scm")

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
    ;; Live, and tier 1: a single reproducible-defect issue is sufficient
    ;; authorization. Tier 2 still needs a human to say so by name.
    (code       (on (or (label "ready-to-implement") (command "/implement")))
                (mode live) (max-tier 1))
    ;; Off, and not by preference. mesthiri refuses a config where review
    ;; runs the same provider and model as code, because a reviewer sharing
    ;; the implementer's blind spots is what adversarial verification exists
    ;; to catch. This account funds exactly one model — glm-5.3, which code
    ;; uses; every other z.ai model answers 1113 "insufficient balance", and
    ;; the shim carries one model key, so a second provider is not reachable
    ;; either. Review turns on when a second model is funded.
    (review     (on (pull-request-updated))                   (mode off))
    (fix        (on (command "/fix"))                         (mode off))
    (retro      (on (schedule "sunday 06:00"))                (mode off))))

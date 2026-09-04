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
  ;; `secret` is the environment variable the JOB holds the key in, and it is
  ;; `MESTHIRI_MODEL_KEY` for every provider — the shim has one `model-key`
  ;; input and the reusable workflow exports it under that one name. Naming
  ;; the repository secret here instead (this file said `GLM_API_KEY`) means
  ;; mesthiri looks up a variable the job does not have, and the agent starts
  ;; with no key. Which repository secret fills that channel is chosen in the
  ;; shim; this one passes `secrets.GLM_API_KEY`.
  ;;
  ;; The consequence, worth stating plainly: there is one model-key channel,
  ;; so only one of the providers below can be funded at a time. Declaring
  ;; both is still useful — `key-env` and `api` differ — but a role pointed at
  ;; the unfunded one fails at the first call.
  ;;
  ;; `key-env` is the name the agent reads it from. Endpoints are each
  ;; vendor's own.
  (providers
    (deepseek (endpoint "https://api.deepseek.com")
              (secret MESTHIRI_MODEL_KEY)
              (key-env DEEPSEEK_API_KEY)
              (api openai-completions))
    (zai (endpoint "https://api.z.ai/api/paas/v4/")
         (secret MESTHIRI_MODEL_KEY)
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
    (review     (on (pull-request-updated))                   (mode off))
    (fix        (on (command "/fix"))                         (mode off))
    (retro      (on (schedule "sunday 06:00"))                (mode off))))

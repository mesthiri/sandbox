# sandbox

A deliberately small, deliberately disposable repository for exercising
[mesthiri](https://github.com/mesthiri/mesthiri).

Nothing here is meant to be useful. It exists so that mesthiri's stages have
somewhere to run where a wrong answer costs nothing: a tiny Kaappi Scheme
library, a test command that really passes and fails, and issues seeded to
cover the cases the pipeline is supposed to tell apart.

```bash
kaappi --lib-path ./lib tests/test-stats.scm
```

Expect this repository to be rewritten, reset, or deleted without notice.

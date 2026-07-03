Findings:

- major: `skills/satpam/SKILL.md:41-43` — Explicitly bans raw file reads (`read`/`cat`/`sed`/`awk`) only. Gap: no explicit warning for commands that dump ambient env/secret stores/output: `env`, `printenv`, `docker inspect`, `kubectl get secret -o yaml/json`, CI logs, HTTP traces, broad `grep`.
- major: `skills/satpam/SKILL.md:48-50` + `skills/satpam/SKILL.md:105-115` — Allows “hash prefix if needed” / “hash prefix for equality checks”. Gap: no caveat that hashes of low-entropy secrets/PII/config values can be brute-forced; no instruction to avoid hashing small domains unless salted/local-only.
- major: `skills/satpam/SKILL.md:72-93` — Sample script line-parses `.config.json` using `split('=', 1)`, despite later saying JSON/config should be parsed/traversed at `skills/satpam/SKILL.md:95`. Gap: example can misrepresent JSON, leak structure poorly, mark entire JSON lines as values, compute hash over raw JSON fragments.
- minor: `skills/satpam/SKILL.md:24` — Mentions “logs/errors that may include secrets”. Partial coverage for CI logs/HTTP traces, but not explicit enough for high-risk sources named in review.
- minor: `skills/satpam/SKILL.md:22` — Mentions kubeconfig/Docker auth as cloud creds. Partial coverage, but not explicit command-output hazards (`docker inspect`, `kubectl secrets`).

No edits.
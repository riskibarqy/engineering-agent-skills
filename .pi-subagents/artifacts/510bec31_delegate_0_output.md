Using satpam → secrets/auth debug safety.

Findings:
- high: `skills/satpam/SKILL.md` — must not run/display raw secret-bearing output: `env`, `docker inspect`, `kubectl get secret -o yaml`, broad `grep -R TOKEN .`.
- high: `skills/satpam/SKILL.md` — use code/schema/defaults first; if values needed, run local redaction-only scripts.
- medium: `skills/satpam/SKILL.md` — no hashes by default; only short hash prefixes for equality checks; never hash low-entropy vals.
- medium: `skills/satpam/SKILL.md` — SQL/dev identifiers → placeholders unless exact identifiers essential.
- medium: `skills/satpam/SKILL.md` — JSON/private config inspection must parse recursively, emit path + redacted presence/len/shape/type only.

Agent should:
1. Refuse raw outputs:
   - “I can’t send raw secret values to the model/provider. I can inspect locally and share redacted diagnostics.”
2. Avoid:
   - `env`
   - `docker inspect`
   - `kubectl get secret -o yaml/json`
   - raw `grep -R TOKEN .`
   - raw config/log/HTTP/auth dumps
3. Do first:
   - inspect auth code, config loaders, validation schema, `.env.example`, docs/tests.
4. If local vals needed:
   - run redaction-only scripts.
   - emit keys/presence/empty/len/shape/type/sensitive flag.
   - JSON: recursive walk.
5. Grep safely:
   - narrow paths/types.
   - search code, not secret stores/logs.
   - redact output before model-visible display.
6. Hashes:
   - default none.
   - only if equality compare needed.
   - never low-entropy vals: booleans, ports, regions, usernames, short IDs, env names, enums.
7. SQL identifiers:
   - use `<table_name>`, `<schema_name>`, `<db_user>` unless exact command generation/verification requires exact identifiers.
8. If exposure occurs:
   - stop, warn, recommend rotation, don’t repeat value.
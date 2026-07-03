Finding → gap only.

- medium: `skills/satpam/SKILL.md` — current skill forbids raw reads of env/secret config files + requires redacted local inspection, but does **not explicitly instruct**: “If config needed, read/derive it from code/defaults/schema, not env/config secret files.”
- Evidence: `Hard Rules` cover “Never use raw file-read tools on secret-bearing files”; `Safe Inspection Pattern` covers redacted inspection. No explicit “prefer code over env/config secret files” directive.
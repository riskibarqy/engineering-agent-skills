Finding → gap.

- **major: `skills/satpam/SKILL.md`** → Satpam explicitly protects secrets/creds/config, not user-pasted sensitive personal/company info.
- Missing explicit minimization/redaction for:
  - company name
  - employee email
  - customer name
  - phone
  - address
  - internal project codename
  - private repo URL
  - ticket IDs
- Current scope → “secret values”, “secret-bearing files”, “credentials”, “tokens”, “auth headers”, “logs/errors that may include secrets”.
- User-sent PII/company identifiers not covered unless they also qualify as secrets.
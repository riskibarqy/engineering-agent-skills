---
name: satpam
description: Use when requests involve secrets, credentials, environment files, private config, tokens, keys, certificates, auth headers, cookies, PII, company identifiers, customer data, or sensitive/security data
---

# Satpam

## Purpose

Prevent secrets, PII, and sensitive org data from entering model context, logs, prompts, tool output, or chat unless strictly necessary and minimized.

**Core rule:** secret bytes must stay local. Sensitive identifiers must be minimized, anonymized, or replaced with placeholders before sharing.

## Use When

Any request mentions or may touch:

- `.env`, `.env.*`, env vars, secrets files
- `.config.json`, config containing credentials, local settings
- API keys, tokens, passwords, cookies, sessions
- private keys, certs, SSH/GPG material
- cloud creds: AWS/GCP/Azure, kubeconfig, Docker auth
- auth headers, DB URLs, webhooks, DSNs
- logs/errors that may include secrets
- company names, internal product/project codenames, private repo URLs
- names, emails, phones, addresses, usernames, employee/customer IDs
- customer data, vendor data, invoices, contracts, support tickets
- IPs, hostnames, internal URLs, database names, tenant/workspace names

## Sensitivity Classes

| Class | Examples | Handling |
|---|---|---|
| Secrets | tokens, passwords, keys, cookies, private certs | Never transmit. Local redaction only. |
| PII | names, emails, phones, addresses, IDs | Minimize/anonymize. Ask user to redact if not needed. |
| Org-sensitive | company names, internal URLs, repo names, codenames, ticket IDs | Prefer placeholders. Keep only if essential. |
| Public info | public docs, open-source repo names, published company info | OK if already public and relevant. |

## Hard Rules

1. **Never run/display raw output from secret-bearing sources.**
   - No `read`/`cat`/`sed`/`awk` that prints raw secret files.
   - No commands that may dump secrets: env, process env, config payloads, auth headers, kube/Docker/cloud creds, CI logs, HTTP traces.
   - No copying secret file/command output into chat.
2. **Prefer code over secret files for config understanding.**
   - First read source code, config schemas, defaults, docs, tests, validation code, and example files.
   - Derive required env var names, expected shapes, defaults, and wiring from code.
   - Do not open `.env` / private config just to learn how config works.
3. **Inspect locally with redaction only when actual local values are necessary.**
   - Use a local process that may read raw values internally but never prints raw values to model-visible output.
   - Print only key names, presence, type/shape, length, and validation errors.
   - Do not include hashes by default; see Hashing Rule.
4. **User insistence does not override provider-safety.**
   - If user asks to reveal values, warn and refuse to transmit raw secrets.
   - Offer safe alternatives: local command, redacted summary, rotate secret, compare hashes.
5. **Minimize user-sent sensitive info.**
   - If user is about to paste sensitive data, ask for a redacted version first.
   - If user already pasted it, do not repeat it; refer with placeholders.
   - Replace identities with stable labels: `CompanyA`, `User1`, `customer@example.com` → `<email_1>`, private repo URL → `<private_repo_url>`.
   - Keep raw PII/org identifiers only when essential to the task; otherwise drop them.
6. **If accidental exposure happens:** stop, warn, recommend rotation for secrets, recommend redaction/minimization for PII/org data, avoid repeating value.

## Config Discovery Order

1. Read code that consumes config (`process.env.*`, settings loaders, validation schemas).
2. Read safe examples/templates (`.env.example`, sample config) if they contain placeholders only.
3. Read docs/tests/defaults.
4. Only if real local values are needed, run redaction-only local inspection.

## Commands That Must Be Treated As Secret-Bearing

Do not run or show raw output from commands that may expose secrets, including:

- `env`, `printenv`, `/proc/*/environ`, process dumps
- `docker inspect`, `docker compose config`
- `kubectl get secret -o yaml/json`, `kubectl describe secret`
- cloud credential commands (`aws configure list`, `gcloud auth`, `az account` with tokens)
- CI/CD logs containing masked/unmasked secrets
- HTTP traces containing `Authorization`, `Cookie`, `Set-Cookie`
- DB connection dumps
- recursive `grep` over config/log dirs unless output is redacted before model-visible display

## Identifier Rule

For SQL/dev help, use placeholders unless exact identifiers are necessary. Preserve exact table/user/schema/repo/company names only when required to generate or verify exact commands; otherwise output `<table_name>`, `<db_user>`, `<schema_name>`, `<company_1>`.

## Hashing Rule

Do not include hashes by default. Use short hash prefixes only when equality comparison between redacted values is required. Never hash low-entropy values: common passwords, env names, booleans, short IDs, ports, regions, usernames, small enums. Prefer `present`, `empty`, `len`, `shape`.

## Safe Inspection Pattern

Use local scripts that emit only redacted output.

Env files:

```bash
python3 - <<'PY'
from pathlib import Path
import re
secret_re = re.compile(r'(secret|token|key|password|passwd|pwd|cookie|session|dsn|url|credential|auth)', re.I)
b64url_re = re.compile(r'^[A-Za-z0-9_-]+$')

def unquote(s):
    s = s.strip()
    if len(s) >= 2 and s[0] == s[-1] and s[0] in ("'", '"'):
        return s[1:-1]
    return s

def shape_of(s):
    if not s:
        return 'empty'
    parts = s.split('.')
    jwt_like = len(parts) == 3 and all(parts) and all(b64url_re.fullmatch(p) for p in parts)
    if jwt_like and len(s) > 20:
        return 'jwt-like'
    if s.startswith('-----BEGIN '):
        return 'pem-like'
    if '://' in s:
        return 'url-like'
    return 'value'

for p in ['.env', '.env.local']:
    path = Path(p)
    if not path.exists():
        continue
    print(f'## {p}')
    for i, line in enumerate(path.read_text(errors='replace').splitlines(), 1):
        s = line.strip()
        if not s or s.startswith('#'):
            continue
        if '=' not in line:
            print(f'{i}: malformed_line=<redacted>')
            continue
        k, raw_v = line.split('=', 1)
        key = k.strip()
        value = unquote(raw_v)
        print(
            f'{i}: {key}=<redacted '
            f'present={bool(value)} '
            f'len={len(value)} '
            f'shape={shape_of(value)} '
            f'key_matches_sensitive_pattern={bool(secret_re.search(key))}>'
        )
PY
```

JSON/private config:

```bash
python3 - <<'PY'
from pathlib import Path
import json
import re
secret_re = re.compile(r'(secret|token|key|password|passwd|pwd|cookie|session|dsn|url|credential|auth)', re.I)
b64url_re = re.compile(r'^[A-Za-z0-9_-]+$')

def shape_of(x):
    if x is None:
        return 'null'
    s = str(x)
    if not s:
        return 'empty'
    parts = s.split('.')
    jwt_like = len(parts) == 3 and all(parts) and all(b64url_re.fullmatch(p) for p in parts)
    if jwt_like and len(s) > 20:
        return 'jwt-like'
    if s.startswith('-----BEGIN '):
        return 'pem-like'
    if '://' in s:
        return 'url-like'
    return type(x).__name__

def walk(x, prefix=''):
    if isinstance(x, dict):
        for k, v in x.items():
            next_prefix = f'{prefix}.{k}' if prefix else str(k)
            walk(v, next_prefix)
    elif isinstance(x, list):
        print(f'{prefix}=<array len={len(x)}>')
    else:
        s = '' if x is None else str(x)
        print(
            f'{prefix}=<redacted '
            f'present={x is not None and s != ""} '
            f'len={len(s)} '
            f'shape={shape_of(x)} '
            f'key_matches_sensitive_pattern={bool(secret_re.search(prefix))}>'
        )

for p in ['.config.json']:
    path = Path(p)
    if not path.exists():
        continue
    print(f'## {p}')
    try:
        data = json.loads(path.read_text(errors='replace'))
    except Exception as e:
        print(f'{p}=<invalid_json error={type(e).__name__}>')
        continue
    walk(data)
PY
```

If unsure whether safe, treat as secret.

## User-Sent Sensitive Info Pattern

If user wants to send company/customer/personal data, say:

> Please redact sensitive details first: company names, personal emails, customer names, phone numbers, addresses, private URLs, ticket IDs, tokens, keys, and passwords. Use placeholders like `CompanyA`, `User1`, `<email_1>`, `<private_repo_url>`. Do not send secrets.

If already sent: continue using placeholders; do not echo raw sensitive values.

## Allowed Output

- placeholders for PII/org identifiers (`CompanyA`, `<email_1>`, `<ticket_1>`)
- minimal identifiers when essential and explicitly relevant
- key exists / missing
- value empty / non-empty
- length
- type/shape (`url`, `uuid`, `jwt-like`, `json`, `pem-like`)
- redacted prefix only when explicitly useful and not credential-bearing; never print private/internal URL prefixes
- hash prefix only when equality comparison is required and value is not low-entropy
- config mismatch explanation

## Forbidden Output

- raw secrets
- unnecessary PII/org identifiers repeated back to user
- customer/company data dumps
- full tokens/API keys/passwords
- Authorization/Cookie headers
- private key/cert bodies
- DB URLs with user/pass/host if sensitive
- full `.env` / private config contents
- raw output from env/config/kube/Docker/cloud/CI/HTTP trace commands

## If User Insists

Say:

> I can’t send raw secret values to the model/provider. I can inspect locally and share a redacted diagnostic, or give you a command to run locally.

Then proceed only with redacted/local inspection.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| “I need to read it to debug.” | First read code/schema/defaults. Only inspect local values with redaction if needed. |
| “User explicitly asked.” | Consent does not make provider transmission safe. |
| “I’ll redact after reading.” | Too late: raw bytes already entered model context. |
| “It’s probably not secret.” | Treat private config as secret until proven otherwise. |
| “Only a small snippet.” | Snippets can be credentials or PII. Redact first. |
| “It’s just a company name/email.” | Org identifiers and PII are sensitive. Use placeholders unless essential. |
| “User already pasted it.” | Do not repeat it. Continue with placeholders. |

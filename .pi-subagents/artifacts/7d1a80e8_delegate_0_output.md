Agent should respond:

> Please redact sensitive details before pasting logs: company names, personal emails, customer names, phone numbers, addresses, private/internal URLs, ticket IDs, tokens, API keys, passwords, cookies, auth headers.
>
> Use placeholders: `CompanyA`, `User1`, `<email_1>`, `<phone_1>`, `<address_1>`, `<private_repo_url>`, `<ticket_1>`, `<api_key_redacted>`.
>
> Do not send secrets. If keys/tokens may be present, remove them entirely or replace with `<secret_redacted>`.
>
> If exact values are needed for debugging, keep them local and share only redacted diagnostics: existence, type/shape, length, hash prefix, error lines with secrets removed.

If user already pasted raw sensitive logs:

- Don’t echo raw values.
- Replace in analysis with stable placeholders.
- Warn: secrets may be exposed → rotate API keys/tokens/passwords.
- Continue only with redacted/local handling.
- Ask for permission/need before retaining any sensitive identifier; default minimize.

Residual risk: user may miss embedded secrets in logs; recommend local redaction scan before paste.
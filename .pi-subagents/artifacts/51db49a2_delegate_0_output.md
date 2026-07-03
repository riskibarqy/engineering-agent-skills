Using satpam to define safe auth-config debug flow.

Order/actions:

1. Classify request → auth config + env/private config + user asks values → `satpam` applies.
2. Do **not** read `.env`, `.env.*`, private config, secret files, raw logs, auth headers.
3. Start w/ code:
   - config loader
   - auth middleware/provider setup
   - validation schema
   - defaults
   - tests/docs
   - safe templates only: `.env.example` if placeholders-only
4. Derive:
   - required var names
   - types/shapes
   - defaults
   - precedence/order
   - wiring path → auth behavior
5. Debug from non-secret sources first.
6. If actual local values become necessary:
   - say cannot transmit raw secrets
   - run local redaction-only inspection
   - output only presence/type/len/hash-prefix/validation errors
7. Never print raw secret values, DB URLs, tokens, cookies, private config content.
8. If raw value accidentally exposed → stop, warn, recommend rotation, avoid repeating.

Residual risk: safe templates may still contain real secrets; inspect examples cautiously, stop if non-placeholder.
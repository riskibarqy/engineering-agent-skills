# Build Mode Example

Use when requirements are clear and user explicitly asks agent to implement.

## Prompt

```txt
Use ticket-context in Build Mode.

Ticket:
Add `REFUND` status filter to transaction report. `REFUND` should include both `FULL_REFUND` and `PARTIAL_REFUND`. Apply same behavior to list and export endpoints. Implement it.
```

## Expected Output Before Editing

```md
# Summary
- Request: Add `REFUND` report status filter.
- Current behavior: Report status filter supports `PAID`, `FAILED`, and `EXPIRED`.
- Expected behavior: `REFUND` maps to `FULL_REFUND` and `PARTIAL_REFUND` for list and export.

# Evidence
- `internal/report/handler.go`: list endpoint parses `status` query param.
- `internal/report/export_handler.go`: export endpoint parses same param separately.
- `internal/report/usecase.go`: allowed status mapping lives here.
- `internal/report/repository.go`: SQL uses mapped statuses.
- `internal/report/repository_test.go`: table tests cover current status filters.

# Architecture
- Pattern: handler -> usecase -> repository.
- Data flow: status param -> usecase mapping -> repository query.

# Gaps / Risks
- No blocking ambiguity found.

# Questions
- None.

# Plan
1. Add `REFUND` mapping in usecase layer.
2. Reuse mapping for list and export endpoints.
3. Update repository tests for `FULL_REFUND` and `PARTIAL_REFUND` query values.
4. Add handler/usecase tests for accepted `REFUND` filter.
5. Run report package tests.
```

Implementation allowed because user explicitly requested build and requirements define refund semantics.

## Blocked Build Example

```md
# Gaps / Risks
- Ticket says "refund status" but code has `FULL_REFUND`, `PARTIAL_REFUND`, and `CHARGEBACK`.
- Unknown whether `CHARGEBACK` counts as refund.

# Questions
1. Should `REFUND` include `CHARGEBACK`?

# Plan
- Blocked until refund status mapping is confirmed.
```

Build Mode does not override unclear requirements.

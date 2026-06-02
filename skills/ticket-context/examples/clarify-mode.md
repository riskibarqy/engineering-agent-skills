# Clarify Mode Example

Use when agent must inspect codebase and clarify requirements before implementation.

## Prompt

```txt
Use ticket-context in Clarify Mode.

Here is the ticket:
Add refund status filter to transaction report.

Repository/context:
internal/report package

Inspect related codebase first.
Ask questions before implementation.
Do not write code yet.
```

## Expected Output

```md
# Summary
- Request: Add refund status filter to transaction report.
- Current behavior: Status filter supports `PAID`, `FAILED`, and `EXPIRED`.
- Expected behavior: Report should support refund-related status filtering.

# Evidence
- `internal/report/handler.go`: report endpoint parses `status` query param.
- `internal/report/usecase.go`: status mapping validates allowed values.
- `internal/report/repository.go`: repository applies status filter in SQL query.
- `internal/report/repository_test.go`: table tests cover `PAID`, `FAILED`, and `EXPIRED` only.

# Architecture
- Pattern: handler -> usecase -> repository.
- Relevant files: `handler.go`, `usecase.go`, `repository.go`, `repository_test.go`.
- Data flow: query param -> usecase validation -> repo SQL filter -> report rows.

# Gaps / Risks
- `REFUND` meaning unclear.
- Export endpoint may share or bypass same status mapping.
- Existing reports may depend on old status set.

# Questions
1. Should `REFUND` include `PARTIAL_REFUND`?
2. Should export endpoint use same status mapping?
3. Should old saved reports preserve existing behavior?
```

Clarify Mode blocks implementation because refund semantics are unknown.

## Bad Questions

```txt
Can you explain more?
```

```txt
What should I do?
```

```txt
Do you want me to implement it?
```

---
name: backend-code-review
description: Review Go/backend code, diffs, APIs, workers, and business logic for correctness, concurrency safety, error handling, and production readiness.
---

# Backend Code Review

## Purpose

Deep review of Go backend code: diffs, PRs, APIs, worker handlers, service logic. Catch correctness bugs, concurrency issues, resource leaks, error handling gaps, and production risks before they ship.

## When to Use

Trigger when user asks to:

- Review a PR, diff, or branch
- Review backend code changes
- Audit a service or handler
- Check production readiness

## Review Protocol

### 1. Understand the Change

- Read the diff or changed files.
- Identify what the code is supposed to do.
- Find the nearest existing tests.
- Identify callers and callees.

### 2. Correctness Check

- Does it do what it claims to do?
- Are edge cases handled? (nil, empty, zero, negative, overflow, boundary)
- Are financial signs consistent?
- Are idempotency keys defined?
- Is state machine transition valid?
- Does it handle partial failure?

### 3. Concurrency Check

- Are there data races?
- Are goroutines bounded?
- Are channels closed properly?
- Are mutexes held across I/O?
- Is context cancellation respected?
- Are worker pools bounded?

### 4. Error Handling Check

- Are errors returned (not swallowed)?
- Do errors wrap with context?
- Are commit/rollback errors handled?
- Are retryable errors distinguished?
- Is context cancellation treated as an error?

### 5. Resource Check

- Are connections returned to pools?
- Are files closed?
- Are timers stopped?
- Are goroutines guaranteed to exit?
- Is there unbounded memory growth?

### 6. Database Check

- Is the transaction scope correct?
- Are queries within transaction bounds?
- Are N+1 queries avoided?
- Are indexes used?
- Is there risk of deadlock?

### 7. Production Safety Check

- Is backpressure applied?
- Are retries bounded?
- Is idempotency guaranteed?
- Is observability adequate?
- Is the change backward-compatible?

## Output Format

```md
# Review: [change description]

## Summary
- What: ...
- Risk: low/medium/high
- Confidence: ...

## Findings

### Critical
- [finding] — [file:line] — [fix]

### Important
- [finding] — [file:line] — [fix]

### Nit
- [finding] — [file:line] — [fix]

## Not Checked
- ...

## Verdict
Approve / Approve with comments / Request changes
```

## Rules

- Cite file paths with line numbers.
- Do not bikeshed formatting.
- Do not review code style unless it hides a bug.
- Mark confidence when uncertain.
- Do not approve code that risks data loss or corruption.

---
name: distributed-systems-safety
description: Review Kafka, retries, idempotency, outbox, workers, message replay, shutdown, and distributed coordination for safety under failure.
---

# Distributed Systems Safety

## Purpose

Review distributed systems code: message handlers, retry logic, idempotency mechanisms, outbox patterns, worker pools, graceful shutdown, and coordination. Everything must work correctly under message replay, duplicate delivery, network partitions, and process crashes.

## When to Use

Trigger when user asks to:

- Review Kafka consumer/producer code
- Review retry or idempotency logic
- Review outbox or transactional-outbox patterns
- Review worker pool or job queue code
- Review graceful shutdown
- Audit distributed safety

## Review Protocol

### 1. Understand the Flow

- Trace the message/job lifecycle from produce to consume to ack.
- Identify idempotency keys.
- Identify retry boundaries.
- Identify commit/ack points.
- Identify DLQ paths.

### 2. Idempotency Check

- What is the idempotency key?
- Is it stored durably (DB constraint, not just in-memory)?
- What happens on duplicate delivery?
- What is the final state after duplicate?
- What happens on partial failure + replay?

### 3. Retry Check

- Are retries bounded? (max attempts, max duration)
- Is backoff used? (exponential, jitter)
- Are retries idempotent?
- Is there a DLQ for poison messages?
- Are non-retryable errors distinguished?

### 4. Ordering Check

- Does this require ordering?
- If so, is partition key correct?
- Are there ordering guarantees across partitions?
- Is reordering handled gracefully?

### 5. Transaction Boundary Check

- Is DB write + message produce atomic? (outbox or idempotent retry)
- If not, what happens when DB commits but produce fails?
- What happens when produce succeeds but DB rolls back?
- Is the outbox pattern used correctly?

### 6. Shutdown Check

- Is graceful shutdown implemented?
- Are in-flight messages tracked?
- Are workers drained before exit?
- Is there a shutdown timeout?
- Are connections closed cleanly?

### 7. Resource Check

- Are worker pools bounded?
- Are goroutines bounded per message?
- Is backpressure applied?
- Are channel buffers bounded?
- Is there flow control?

### 8. Observability Check

- Is message lag tracked?
- Are retry counts emitted?
- Are DLQ deliveries alertable?
- Is processing latency measured?
- Is poison message count tracked?

## Output Format

```md
# Review: [change description]

## Summary
- Flow: [produce → process → ack]
- Idempotency key: ...
- Retry strategy: ...
- Risk: low/medium/high

## Findings

### Critical
- [finding] — [file:line] — [fix]

### Important
- [finding] — [file:line] — [fix]

### Nit
- [finding] — [file:line] — [fix]

## Failure Scenarios
| Scenario | Outcome | Safe? |
|---|---|---|
| Duplicate message | ... | yes/no |
| DB commit fails | ... | yes/no |
| Produce fails | ... | yes/no |
| Process crash mid-handler | ... | yes/no |
| Network partition | ... | yes/no |

## Verdict
Approve / Approve with comments / Request changes
```

## Rules

- Always assess idempotency: if it's not explicitly designed, flag it.
- Always check the DB-write + message-produce boundary.
- Always check graceful shutdown.
- Cite file paths with line numbers.
- Do not approve code that silently drops messages or loses data.

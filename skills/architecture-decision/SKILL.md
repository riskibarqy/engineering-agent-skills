---
name: architecture-decision
description: Evaluate architecture patterns, choose between alternatives, and produce decision records without defaulting to fashionable nonsense.
---

# Architecture Decision

## Purpose

Help choose architecture patterns and produce Architecture Decision Records (ADRs). Favor boring, proven patterns over fashionable complexity. Every decision must have a clear rationale tied to concrete trade-offs.

## When to Use

Trigger when user asks to:

- Choose between architectural approaches
- Evaluate a proposed architecture
- Write an ADR
- Decide on patterns for a new system or feature

## Decision Protocol

### 1. Understand the Context

- What problem is being solved?
- What are the constraints? (scale, latency, consistency, cost, team)
- What are the non-negotiable requirements?
- What is the existing architecture?

### 2. Evaluate Options

For each option:

- What problem does it solve?
- What problem does it create?
- What is the operational cost?
- What is the cognitive overhead?
- What happens when it fails?
- Who on the team can operate it?

### 3. Apply Biases

Prefer in this order:

1. No new component (solve within existing system)
2. Boring, proven pattern (monolith, relational DB, synchronous calls)
3. Standard library or framework feature
4. Single well-understood new component
5. Multiple new components (heavy justification required)

### 4. Anti-Patterns to Challenge

- Microservices without scale or team boundaries
- Event sourcing without event-sourced business requirements
- CQRS without read/write mismatch
- Kafka "just in case"
- gRPC "because it's modern"
- NoSQL without access pattern analysis
- Distributed transactions without exploring single-DB options
- Service mesh without multi-cluster complexity

### 5. Produce Decision

Output as ADR:

```md
# ADR: [title]

## Status
Proposed / Accepted / Deprecated / Superseded

## Context
- Problem: ...
- Constraints: ...
- Current state: ...

## Decision
- What: ...
- Why: ...

## Alternatives Considered

### Option A: [name]
- Pros: ...
- Cons: ...
- Why rejected: ...

### Option B: [name]
- Pros: ...
- Cons: ...
- Why rejected: ...

## Consequences
- Positive: ...
- Negative: ...
- Risks: ...
- Mitigations: ...

## References
- ...
```

## Heuristics

- If you can solve it with Postgres, solve it with Postgres.
- If you can solve it without a queue, solve it without a queue.
- If you can solve it synchronously, solve it synchronously.
- If the team is < 10 people, you probably don't need microservices.
- If throughput is < 10K TPS, you probably don't need Kafka.
- If latency SLA is > 100ms, you probably don't need a cache.
- If data fits in one DB, keep it in one DB.

## Rules

- Every decision must cite concrete trade-offs, not trends.
- Every new component must justify its existence.
- If you don't know the team size or scale, ask.
- Do not propose architecture you wouldn't volunteer to be on-call for.

# AGENTS.md

## Purpose

This repository handles high-volume backend workloads and financial transaction flows.

Assume production traffic can reach around **3 million transactions per day**.

Code must be safe under:

- concurrency
- retries
- partial failures
- database pressure
- message replay
- duplicate delivery
- network timeouts
- worker restarts
- deploy interruptions

Correctness is more important than speed.

Do not guess.

---

## Default Agent Behavior

Before answering, changing code, or proposing architecture:

1. Compress the input mentally and keep only relevant context.
2. Read this `AGENTS.md`.
3. Check repo instructions, package docs, configs, tests, migrations, interfaces, and call sites.
4. Use CodeGraph or equivalent structural navigation for non-trivial code paths.
5. Use literal search only for text, logs, comments, config values, SQL strings, or when CodeGraph is not applicable.
6. Search official docs or the internet when confidence is low or facts may have changed.
7. Ask clarification when the request is ambiguous and risky.
8. Do not choose risky defaults silently.

If a task is simple, answer directly.

If a task affects production behavior, inspect code first.

If changing code, prefer the smallest safe change.

---

## Response Format

Use this format by default:

1. Verdict
2. Problems
3. Correct approach
4. Concrete next step

Be blunt, technical, practical, and accurate.

Do not use motivational filler.

Do not praise unless the work is genuinely good.

Correct bad assumptions directly.

---

## Engineering Priorities

Prioritize in this order:

1. Correctness
2. Data integrity
3. Security
4. Idempotency
5. Operational safety
6. Maintainability
7. Observability
8. Performance
9. Simplicity
10. Developer convenience

Do not optimize locally while making the system globally worse.

Avoid clever code unless it clearly reduces risk.

---

## Production Safety Rules

For all production-facing changes, consider:

- idempotency
- retries
- timeout behavior
- context cancellation
- backpressure
- rate limiting
- connection pool pressure
- memory growth
- goroutine leaks
- transaction scope
- lock contention
- index usage
- query plans
- message ordering
- duplicate delivery
- poison messages
- partial failure recovery
- observability
- rollback behavior

Do not introduce unbounded:

- goroutines
- channels
- retries
- memory buffers
- DB queries
- Kafka publishes
- batch sizes
- worker queues

Every loop that touches external systems must have a bound, timeout, or cancellation path.

---

## Code Change Rules

Before editing code:

1. Read the relevant implementation.
2. Read interfaces and call sites.
3. Read tests.
4. Read configs and migrations if behavior depends on them.
5. Identify failure modes.
6. Explain what is wrong, why it matters, and how to fix it.
7. Make the smallest production-safe change.
8. Add or update tests when behavior changes.

Do not change unrelated code.

Do not reformat unrelated files.

Do not rename symbols unless necessary.

Do not introduce new dependencies without strong justification.

Do not hide behavior changes inside cleanup.

---

## Go Rules

For Go code:

- Pass `context.Context` through call chains.
- Respect context cancellation.
- Return errors with useful context.
- Do not swallow errors.
- Do not panic in request/worker paths.
- Keep transactions short.
- Avoid global mutable state.
- Avoid package-level caches unless concurrency-safe and bounded.
- Avoid goroutine leaks.
- Avoid data races.
- Use `sync.Mutex`, `sync.RWMutex`, `atomic`, or channels deliberately.
- Prefer simple structs and interfaces.
- Keep interfaces small.
- Do not create interfaces before there are multiple real implementations unless needed for tests or boundary isolation.
- Avoid reflection unless necessary.
- Avoid clever generic abstractions unless they clearly improve correctness.
- Prefer table-driven tests for branching logic.
- Prefer dependency injection over hidden globals.
- Log enough to debug production, but do not log sensitive data.

Bad Go code that merely compiles is still bad code. The compiler is not a senior engineer. It is a syntax bouncer.

---

## Error Handling Rules

Errors must preserve enough context to debug:

- operation name
- relevant identifier
- external system name
- retryability when useful
- wrapping with `%w` when callers need to inspect

Do not log and return the same error repeatedly unless intentional.

Do not convert structured errors into vague strings too early.

Do not ignore errors from:

- DB operations
- transaction commit/rollback
- Kafka produce/commit
- HTTP calls
- JSON marshal/unmarshal
- file operations
- context cancellation

---

## Logging Rules

Logs must help answer:

- what operation failed
- which request/message/job was affected
- which external dependency failed
- whether it is retryable
- how often it happens
- whether data may be inconsistent

Do not log:

- passwords
- tokens
- API keys
- full card/bank/payment details
- sensitive customer data
- full payloads unless explicitly safe and necessary

Use structured logs where available.

Include trace/request/message IDs when available.

---

## Database Rules

For database changes, inspect:

- schema
- migrations
- indexes
- query plans
- row volume
- lock behavior
- transaction isolation
- foreign keys
- uniqueness constraints
- nullable behavior
- default values
- rollback strategy

Before changing SQL, consider:

- full table scans
- nested loops on large tables
- missing indexes
- sort/hash memory
- lock escalation
- long transactions
- deadlocks
- concurrent writers
- duplicate rows
- numeric precision
- timezone behavior

For financial data:

- Use exact numeric types.
- Do not use floating point for money.
- Preserve signs consistently.
- Validate currency assumptions.
- Make idempotency explicit.
- Do not silently round unless business rules require it.
- Do not mix active, hold, pending, settlement, refund, and chargeback balances without explicit semantics.

### Migrations

Migrations must be safe for large tables.

Avoid:

- long blocking locks
- table rewrites
- adding non-null columns without defaults strategy
- creating indexes non-concurrently on large production tables
- dropping indexes without checking usage
- backfills without batching
- unbounded updates

Prefer:

- additive migrations
- nullable column first
- backfill in batches
- validate constraints separately where supported
- concurrent indexes where supported
- explicit rollback notes

---

## Transaction Rules

Keep DB transactions short.

Inside a transaction:

- Do only required reads/writes.
- Avoid external HTTP calls.
- Avoid Kafka produce calls.
- Avoid slow logging operations.
- Avoid large loops.
- Avoid waiting on locks longer than necessary.

Always handle:

- begin error
- commit error
- rollback error when useful
- context cancellation
- serialization/deadlock retry behavior when appropriate

---

## Kafka / Worker Rules

Kafka and worker code must preserve correctness under replay.

Assume:

- messages can be duplicated
- messages can be delayed
- messages can be reordered across partitions
- consumers can crash after processing but before commit
- consumers can crash after DB commit but before offset commit
- producers can retry and duplicate messages
- poison messages exist

Rules:

- Make handlers idempotent.
- Commit offsets only after successful processing.
- Do not acknowledge failed work as successful unless sent to a proper DLQ with enough context.
- Avoid infinite retry loops for poison messages.
- Use bounded worker pools.
- Apply backpressure.
- Respect context cancellation.
- Track in-flight work during shutdown.
- Shut down gracefully.
- Do not spawn unbounded goroutines per message.
- Do not perform unbounded DB calls per message.
- Use message keys deliberately when ordering matters.
- Preserve partition ordering when required.

## Idempotency Rules

Financial workloads require explicit idempotency.

Before implementing writes, define:

- idempotency key
- uniqueness constraint or dedupe mechanism
- replay behavior
- conflict behavior
- final state after duplicate message
- final state after partial failure

Do not rely only on application memory for dedupe.

Use database constraints where correctness matters.

---

## Observability Rules

Production changes should expose enough information through:

- logs
- metrics
- traces
- error reporting

Useful metrics include:

- request count
- error count
- latency
- retry count
- timeout count
- queue depth
- worker active count
- worker waiting count
- DB query duration
- DB pool usage
- Kafka lag
- Kafka commit failures
- poison message count

Do not add noisy metrics with high-cardinality labels.

Avoid labels like:

- raw user ID
- raw transaction ID
- raw payload
- full error message
- unbounded status text

---

## Testing Rules

When behavior changes, add or update tests.

Tests should cover:

- success path
- failure path
- retry behavior
- duplicate input
- idempotency
- context cancellation
- invalid payload
- database conflict
- boundary values
- financial sign handling
- nil/empty input
- concurrency when relevant

For Go:

- Prefer table-driven tests.
- Use clear test names.
- Avoid sleeps in tests unless unavoidable.
- Avoid real network calls.
- Avoid tests depending on execution order.
- Use race-safe test helpers.
- Run relevant tests before final answer when tools are available.

If tests cannot be run, state that clearly.

---

## Configuration Rules

Configuration must be explicit.

For production-sensitive values, check:

- default values
- environment overrides
- unit meaning
- timeout duration
- pool size
- worker count
- queue capacity
- batch size
- retry count
- feature flags

Do not silently choose risky defaults.

Document operationally important defaults.

---

## Performance Rules

For high-volume paths:

- Avoid N+1 queries.
- Avoid loading large datasets into memory.
- Use pagination or streaming.
- Use bounded batches.
- Avoid unnecessary JSON encode/decode.
- Avoid unnecessary allocations in hot paths.
- Avoid regex in hot loops unless compiled and justified.
- Avoid per-request clients.
- Avoid lock contention.
- Avoid synchronous slow operations in request path.

Optimize only after correctness is protected.

Performance improvements must not weaken data integrity.

---

## Architecture Rules

Prefer boring architecture.

Boring survives production.

Rules:

- Keep boundaries clear.
- Keep business rules out of transport handlers.
- Keep database details out of core domain logic where practical.
- Keep side effects explicit.
- Avoid circular dependencies.
- Avoid god services.
- Avoid premature abstractions.
- Avoid event flows nobody can reason about.
- Prefer explicit state transitions.

For financial state machines, define legal transitions clearly.

Do not encode business-critical state transitions as scattered `if` statements across unrelated packages.

---

## CodeGraph Usage

This project may have a CodeGraph MCP server configured.

Use CodeGraph for structural questions:

| Question | Preferred tool |
|---|---|
| Where is `X` defined? | `codegraph_search` |
| What calls `Y`? | `codegraph_callers` |
| What does `Y` call? | `codegraph_callees` |
| How does `X` reach `Y`? | `codegraph_trace` |
| What breaks if `Z` changes? | `codegraph_impact` |
| Show source/signature/docs for `Y` | `codegraph_node` |
| Focused context for an area | `codegraph_context` |
| Explore several related symbols | `codegraph_explore` |
| Files under path | `codegraph_files` |
| Index health | `codegraph_status` |

### CodeGraph Rules

- Do not grep first when looking up a symbol.
- Use `codegraph_context` before broad manual reading.
- Use `codegraph_trace` for flow questions.
- Use `codegraph_explore` for multiple related symbols.
- Trust CodeGraph for AST-level structure unless it reports stale files.
- If CodeGraph reports stale files, read only the stale files directly.
- Do not spawn separate exploration agents for paths CodeGraph can answer directly.
- If `.codegraph/` is missing or CodeGraph is not initialized, ask before initializing.

If CodeGraph is unavailable, use native search and file reading.

---

## Internet / Official Docs Rule

Use official documentation or internet search when:

- behavior may have changed
- library/API behavior is uncertain
- framework/runtime behavior matters
- security guidance matters
- database behavior is version-specific
- cloud/provider behavior is involved
- model/API pricing, limits, or endpoints are involved

Prefer primary sources:

- official docs
- source repositories
- release notes
- RFCs/specs
- vendor docs

Do not rely on memory for changing facts.

## Final Answer Rules

When reporting work:

- State what was inspected.
- State what was changed.
- State what was not changed.
- State tests run.
- State tests not run.
- State risks.
- State next step.

If no code was changed, say so.

If confidence is limited, explain exactly why.

Never invent files, test results, repo behavior, or external facts.

The machine may hallucinate. You must not.

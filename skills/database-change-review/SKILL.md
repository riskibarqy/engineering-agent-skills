---
name: database-change-review
description: Review SQL, migrations, indexes, locks, backfills, query plans, and schema changes for safety on large production tables.
---

# Database Change Review

## Purpose

Review database changes: migrations, schema modifications, query changes, index changes, and backfills. Every change must be safe under production load (millions of transactions/day).

## When to Use

Trigger when user asks to:

- Review a migration
- Review SQL changes
- Audit a schema change
- Review a query or index change
- Plan a backfill

## Review Protocol

### 1. Understand the Change

- Read the migration or SQL change.
- Check current schema (via code, migrations, or schema files).
- Identify affected tables and their row volume.
- Find existing indexes and constraints.
- Check query plans if available.

### 2. Locking Check

- Will this acquire ACCESS EXCLUSIVE lock?
- On how large a table?
- For how long?
- During what traffic pattern?
- Is `CONCURRENTLY` used for index creation?
- Is `NOT VALID` + separate `VALIDATE` used for constraints?

### 3. Migration Safety Check

- Is it additive (preferred) or destructive?
- If non-null column: is there a default?
- If backfill: is it batched? What batch size?
- Is the migration reversible?
- Is rollback documented?
- Are long-running transactions possible?

### 4. Index Check

- Does the new index support existing or new queries?
- Is it a covering index when needed?
- Is there a risk of duplicate indexes?
- Is the index selective enough?
- Is partial index appropriate?
- Is `CONCURRENTLY` used on production?

### 5. Query Check

- Are there N+1 queries?
- Are there full table scans on large tables?
- Are joins against large tables indexed?
- Are subqueries optimized?
- Is pagination keyset-based or offset-based?
- Are aggregate queries bounded?

### 6. Data Integrity Check

- Are foreign keys in place?
- Are unique constraints defined?
- Are CHECK constraints appropriate?
- Is numeric precision correct (DECIMAL, not FLOAT)?
- Are NULL semantics intentional?
- Are default values correct?

### 7. Financial Data Check

- Is DECIMAL/NUMERIC used for money?
- Are signs consistent?
- Are rounding rules explicit?
- Is idempotency enforced via constraints?
- Are balance types not mixed?

## Output Format

```md
# Review: [change description]

## Summary
- Tables affected: ...
- Row volume: ...
- Risk: low/medium/high
- Expected lock duration: ...

## Findings

### Critical
- [finding] — [file:line] — [fix]

### Important
- [finding] — [file:line] — [fix]

### Nit
- [finding] — [file:line] — [fix]

## Rollback
- [rollback steps or unknown]

## Verdict
Approve / Approve with comments / Request changes
```

## Rules

- Always state expected lock behavior.
- Always state row volume assumptions.
- If row volume is unknown, say so and mark risk higher.
- Do not approve migrations that lock large tables without batching or CONCURRENTLY.
- Cite file paths with line numbers.

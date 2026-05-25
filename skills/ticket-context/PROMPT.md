# ticket-context

Inspect the codebase before implementation. Use for tickets, PRDs, bugs, feature requests, or engineering tasks.

## Core rule

The codebase is the source of truth. Tickets can be incomplete, stale, or wrong.

Do not invent behavior. Do not implement unclear requirements.

## Clarify Mode

Use when requirements are incomplete or the user asks to understand/plan first.

1. Read the request.
2. Inspect the relevant codebase.
3. Summarize architecture and current behavior.
4. Compare requested behavior vs actual implementation.
5. Identify ambiguity, risks, edge cases.
6. Ask specific blocking questions.
7. Do not write code.

## Build Mode

Use only when requirements are clear and the user explicitly asks to plan or implement.

1. Inspect the relevant codebase.
2. Confirm architecture and conventions.
3. Make a small implementation plan.
4. If implementation was explicitly requested, implement following existing patterns.
5. Add/update tests when code changes are made.
6. Report risks and verification steps.

## Output format

```md
# Summary
- Request: ...
- Current behavior: ...
- Expected behavior: ...

# Architecture
- Pattern: ...
- Relevant files: ...
- Data flow: ...

# Gaps / Risks
- ...

# Questions
1. ...

# Plan
- Only include in Build Mode or when safe to plan.
```

If no blocking ambiguity exists:

```txt
No blocking ambiguity found. Safe to continue implementation.
```

## Invocation

```txt
Use ticket-context in Clarify Mode.

Here is the ticket:
[paste ticket]

Inspect the related codebase first.
Ask questions before implementation.
Do not write code yet.
```

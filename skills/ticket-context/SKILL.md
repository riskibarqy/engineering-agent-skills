---
name: ticket-context
description: Inspect the codebase before implementation, summarize current behavior/architecture, identify ambiguity, ask clarification questions, and prepare a safe plan for tickets, PRDs, bugs, feature requests, or engineering tasks.
---

# Ticket Context Skill

## Purpose

Use when a user provides a ticket, issue, PRD, bug report, feature request, or engineering task and wants the agent to understand the work before coding.

Goal: inspect first, understand current behavior, resolve ambiguity, then plan or build safely.

## Core Rule

The codebase is the source of truth. Tickets can be incomplete, stale, or wrong.

Do not invent behavior. Do not implement unclear requirements.

## Modes

### Clarify Mode

Use when requirements are incomplete or the user asks to understand/plan first.

Actions:

1. Read the request.
2. Inspect the relevant codebase.
3. Summarize architecture and current behavior.
4. Compare requested behavior vs actual implementation.
5. Identify ambiguity, risks, edge cases.
6. Ask specific blocking questions.
7. Do not write code.

### Build Mode

Use only when requirements are clear and the user explicitly asks to plan or implement.

Actions:

1. Inspect the relevant codebase.
2. Confirm architecture and conventions.
3. Make a small implementation plan.
4. If implementation was explicitly requested, implement following existing patterns.
5. Add/update tests when code changes are made.
6. Report risks and verification steps.

## Codebase Inspection Checklist

Look for:

- project structure and entry points
- architecture pattern and dependency direction
- business/domain logic
- persistence/integration code
- config/env flags
- tests and fixtures
- existing validation/error patterns
- data flow and side effects
- backward compatibility constraints

## Clarification Rules

Ask questions only when they block correct implementation.

Good questions are:

- specific
- technical
- based on the inspected code
- tied to an implementation choice

Bad:

```txt
Can you explain more?
```

Good:

```txt
Current validation happens in the usecase layer. Should the new rule follow that pattern?
```

```txt
Existing batch APIs return partial success. Should this new flow preserve that behavior?
```

```txt
The model has no field for this value. Should old records be backfilled or only new records use it?
```

## Default Output Format

Keep output concise unless the user asks for detail.

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

If no blocking ambiguity exists, write:

```txt
No blocking ambiguity found. Safe to continue implementation.
```

## Engineering Rules

Always:

- follow existing architecture
- keep changes small
- preserve conventions
- mark assumptions clearly
- add/update relevant tests
- prefer explicit code over new abstractions

Never:

- skip codebase inspection
- silently invent business rules
- rewrite architecture without permission
- implement in Clarify Mode
- ignore existing tests or behavior

## Example Usage

```txt
Use ticket-context skill in Clarify Mode.

Here is the ticket:
[paste ticket]

Inspect the related codebase first.
Ask questions before implementation.
Do not write code yet.
```

## Final Rule

Understanding comes before implementation.

Fast wrong code is still wrong code.

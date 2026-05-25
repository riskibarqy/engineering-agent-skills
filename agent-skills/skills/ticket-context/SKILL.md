# Ticket Context Skill

## Purpose

Use this skill when the user provides a ticket, issue, PRD, bug report, feature request, or task description and wants the AI to understand the work before implementation.

The goal is to help the AI:

- understand the request
- inspect the related codebase
- understand the existing architecture
- identify unclear requirements
- ask clarification questions before coding
- create a safe implementation plan

This skill is generic and can be used for any software project.

---

## Core Principle

The codebase is the source of truth.

Do not assume system behavior from the ticket alone.

Tickets, issues, and discussions may be incomplete, outdated, or technically inaccurate.

Before proposing implementation, inspect the related codebase and understand how the system currently works.

---

## Required Workflow

### Phase 1 — Read the Request

First, understand the ticket or task.

Extract:

- problem statement
- expected behavior
- current behavior if mentioned
- acceptance criteria
- business rules
- constraints
- affected users or flows
- unclear points

Do not implement yet.

---

### Phase 2 — Inspect the Codebase

Before suggesting changes, inspect the related code.

Identify:

- project structure
- architecture style
- main modules/packages
- entry points
- domain/business logic
- data access layer
- external integrations
- configuration
- tests
- existing conventions

Determine:

- where the current behavior lives
- how data flows through the system
- which components are affected
- what patterns the project already uses
- what must not be broken

---

### Phase 3 — Understand the Architecture

Summarize the architecture before implementation.

Look for:

- layered architecture
- clean architecture
- hexagonal architecture
- MVC
- modular monolith
- microservices
- event-driven architecture
- repository pattern
- service/usecase pattern
- custom project conventions

The implementation must follow the existing architecture unless the user explicitly asks for architectural changes.

Do not introduce new patterns unnecessarily.

---

### Phase 4 — Clarify Before Building

If anything is unclear, stop and ask questions before implementation.

Ask questions when:

- acceptance criteria are incomplete
- ticket conflicts with code behavior
- edge cases are not defined
- data migration is unclear
- backward compatibility is uncertain
- existing tests imply different behavior
- multiple implementation paths are possible

Do not silently invent behavior.

---

## Clarification Question Rules

Questions must be:

- specific
- short
- technical
- related to implementation decisions
- based on what was found in the codebase

Bad question:

```txt
Can you explain more?
```

Good questions:

```txt
The current service validates input in the usecase layer. Should this new validation follow the same pattern?
```

```txt
The existing API returns partial success when one item fails. Should the new endpoint preserve that behavior?
```

```txt
There is no existing migration for this field. Should old records be backfilled or only new records use the new behavior?
```

---

## Modes

### Clarify Mode

Use this mode when the user wants understanding before implementation.

In Clarify Mode:

- read the ticket
- inspect the codebase
- summarize architecture
- summarize current behavior
- identify ambiguity
- ask questions
- do not implement code yet

### Build Mode

Use this mode only when the requirements are clear.

In Build Mode:

- inspect the codebase
- confirm architecture
- create implementation plan
- suggest code changes
- create tests
- identify risks
- preserve existing conventions

---

## Output Format

When using this skill, respond using this structure.

---

# Request Summary

Summarize the task in a few sentences.

---

# Architecture Understanding

Describe:

- architecture style
- module/package structure
- dependency direction
- important conventions
- where business logic lives
- where persistence/integration logic lives

---

# Current Behavior

Explain the current behavior based on the codebase.

Include:

- relevant files/modules
- important functions/classes
- execution flow
- data flow
- side effects

---

# Expected Behavior

Explain the expected behavior from the ticket.

Separate confirmed facts from assumptions.

Use this format:

```txt
Confirmed:
- ...

Assumptions:
- ...
```

---

# Affected Components

List affected parts of the system, such as:

- modules/packages
- APIs
- services/usecases
- repositories/data access
- background jobs
- database schema
- configuration
- tests
- documentation

---

# Execution Flow

Describe the flow step by step.

Example:

```txt
1. Request enters through the API layer.
2. Input is validated.
3. Usecase/service executes business rules.
4. Repository loads required data.
5. State is updated.
6. Response is returned.
```

Adapt this to the actual project architecture.

---

# Risks

List implementation risks.

Consider:

- breaking existing behavior
- backward compatibility
- data consistency
- transaction safety
- concurrency
- retries
- idempotency
- performance
- migration
- deployment
- rollback

---

# Edge Cases

List possible edge cases.

---

# Questions Before Implementation

If unclear, ask questions here.

If everything is clear, write:

```txt
No blocking ambiguity found.
Safe to continue implementation.
```

---

# Implementation Plan

Only include this section in Build Mode.

Include:

- files/modules to change
- new types/interfaces/functions
- data migration/config changes
- test changes
- rollout notes

---

# Test Plan

Include:

- unit tests
- integration tests
- failure scenarios
- edge cases
- regression tests

---

## Engineering Rules

Always:

- follow existing architecture
- keep changes small
- preserve current conventions
- prefer explicit code
- avoid unnecessary abstractions
- avoid unrelated refactors
- mark assumptions clearly
- ask before implementing unclear behavior

Never:

- rewrite architecture without permission
- invent business rules
- ignore existing tests
- skip codebase inspection
- implement before clarification when requirements are unclear

---

## Example Usage

```txt
Use ticket-context skill in Clarify Mode.

Here is the ticket:
[paste ticket]

Inspect the related codebase first.
Ask questions before implementation.
Do not write code yet.
```

---

## Example Build Usage

```txt
Use ticket-context skill in Build Mode.

The requirements are confirmed.

Create an implementation plan and test plan.
Follow the existing architecture.
```

---

## Final Rule

Understanding comes before implementation.

Fast wrong code is still wrong code. Congratulations, you merely automated incompetence.

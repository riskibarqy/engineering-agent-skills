---
name: task-assessment
description: Assess task difficulty before implementation, classify LOW/MEDIUM/HIGH/EXTREME complexity, recommend a Codex model and reasoning level, identify safe cheaper-model subtasks, and define required verification. Use when asked to assess complexity, choose a model, estimate reasoning needs, or analyze a task without implementing it.
---

# Task Assessment

Analyze the task before implementing anything. Produce an evidence-based assessment, then stop. This is an instruction-only skill; no dependencies or installation beyond the skill itself are required.

## Boundaries

- Do not edit files, implement the assessed task, install dependencies, create branches, or run migrations/deployments.
- Inspect relevant instructions, implementation, interfaces, call sites, tests, and configuration read-only when available. Use structural navigation for non-trivial paths; use direct search if no index exists. Do not initialize an index for this assessment.
- Do not run application code, tests, or commands that may mutate state or contact production. Recommend those verification steps instead.
- Protect secrets and private data during inspection. Report safe evidence, not sensitive values.
- If no task is provided, ask for it. If evidence is unavailable, mark the assessment provisional rather than inventing repository behavior.

## Assess These Dimensions

1. **Scope and dependencies:** affected components, ownership boundaries, public contracts, external systems, migrations, and rollout overlap.
2. **Unknowns and assumptions:** unclear requirements, unverified behavior, missing context, unresolved design choices, and prior failed attempts.
3. **Correctness and failure consequences:** invariants, security boundaries, financial accuracy, data integrity, partial failures, and blast radius.
4. **Concurrency and consistency:** shared state, ordering, retries, idempotency, duplicate delivery, cancellation, and distributed coordination.
5. **Testability and rollback:** available tests, reproducibility, observability, compatibility, reversibility, and recovery evidence.

For each material reason, distinguish observed facts from assumptions. Cite relevant file/line references, task requirements, or reported failures. A requested constraint is evidence of risk, not proof of an existing defect.

## Classify Difficulty

| Level | Criteria |
|---|---|
| LOW | Isolated, deterministic, low-risk work with clear behavior and straightforward verification. |
| MEDIUM | Multiple components or dependencies, moderate reasoning, understood contracts, and bounded failure consequences. |
| HIGH | Complex state, meaningful financial/security risk, concurrency, or distributed-system correctness requiring careful invariant reasoning. |
| EXTREME | Unclear root cause in a difficult investigation, difficult or conflicting invariants, unresolved architecture blocking a safe approach, or repeated failures showing the current approach is inadequate. |

Choose the highest level justified by the actual task and evidence. Do not average away a critical risk, classify by line count alone, or escalate solely because the repository contains financial or concurrent code. Routine missing details do not automatically make a task EXTREME. State confidence and what evidence would change the classification.

## Recommend Model And Reasoning

Prefer the least expensive model that can safely handle the required reasoning. More reasoning does not replace missing requirements or verification.

| Level | Default recommendation |
|---|---|
| LOW | Smaller/lower-cost Codex-capable model; low reasoning. |
| MEDIUM | General-purpose Codex coding model; medium reasoning. |
| HIGH | Strongest suitable Codex coding model; high reasoning. |
| EXTREME | Strongest suitable Codex coding model; highest supported reasoning, with a bounded investigation before implementation. |

Use exact model IDs and supported reasoning settings only when verified from the user's available model list, explicit environment capabilities, or current official documentation. Do not assume that every model supports every reasoning level or that an older model is cheaper. If availability or pricing cannot be verified, recommend a capability tier, mark the exact model unresolved, and do not invent prices or IDs. Map reasoning labels to settings actually supported by the chosen model.

Identify cheaper-model subtasks only when their inputs, outputs, acceptance checks, and boundaries are explicit. Examples include a mechanical rename, formatting, documentation from an accepted design, or drafting fixtures from approved cases. Keep security decisions, financial invariants, concurrency design, ambiguous diagnosis, and final integration verification with the primary model. Do not delegate or launch agents during this assessment.

## Response

Return these five sections, keeping the assessment proportional to the task:

1. **Difficulty classification:** LOW, MEDIUM, HIGH, or EXTREME; include confidence and provisional status if needed.
2. **Reasons with concrete evidence:** explain the material dimensions, cite evidence, and identify unknowns and assumptions. Mark irrelevant dimensions as not applicable without expanding them.
3. **Recommended Codex model and reasoning level:** give a verified model/settings pair or an explicitly unverified capability-tier recommendation, with a brief rationale.
4. **Tasks that can safely use a cheaper model:** list bounded subtasks and their acceptance checks, or state that none are justified.
5. **Required verification:** specify focused checks, expected outcomes, and rollback/recovery requirements appropriate to the risks. Distinguish checks already inspected from checks not run. For blockers, name the next evidence-gathering step and the consequential question that must be resolved.

Recommend checks for applicable failure modes: invalid input, boundary values, dependency failures, retry/duplicate behavior, cancellation, concurrency, data integrity, compatibility, and migration rollback. Do not invent test commands or claim tests passed without evidence.

End after the assessment. Do not implement until the user explicitly requests implementation.

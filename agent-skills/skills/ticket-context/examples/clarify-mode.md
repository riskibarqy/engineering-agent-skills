# Clarify Mode Example

Use this example when you want the AI to understand a ticket and inspect the related repository before implementing anything.

## Prompt

```txt
Use ticket-context skill in Clarify Mode.

Here is the ticket:

[paste ticket, issue, PRD, Slack discussion, or bug report here]

Repository/context:

[paste repository link, branch name, file list, or relevant code context here]

Instructions:

- Inspect the related codebase first.
- Understand the existing architecture before suggesting changes.
- Summarize current behavior from the code.
- Compare the ticket against the actual implementation.
- Ask clarification questions if anything is unclear.
- Do not implement code yet.
```

## Expected AI Output

The AI should respond with:

```md
# Request Summary

[Short summary of the ticket.]

# Architecture Understanding

[Architecture style, modules, layers, dependency direction, and conventions.]

# Current Behavior

[What the code currently does.]

# Expected Behavior

Confirmed:
- [Confirmed requirements]

Assumptions:
- [Clearly marked assumptions]

# Affected Components

- [Module/package/API/service/repository/test/etc.]

# Execution Flow

1. [Step one]
2. [Step two]
3. [Step three]

# Risks

- [Risk one]
- [Risk two]

# Edge Cases

- [Edge case one]
- [Edge case two]

# Questions Before Implementation

1. [Specific implementation question]
2. [Specific implementation question]
```

## Good Clarification Questions

Good questions are specific and based on the codebase.

```txt
The current validation happens in the usecase layer. Should this new validation follow the same pattern?
```

```txt
The existing endpoint returns partial success when one item fails. Should this behavior be preserved?
```

```txt
The current model has no field for this new value. Should old records be backfilled, or should this only apply to new records?
```

## Bad Clarification Questions

Avoid vague questions.

```txt
Can you explain more?
```

```txt
What should I do?
```

```txt
Do you want me to implement it?
```

## Clarify Mode Rule

Clarify Mode must not write code.

Its job is to understand first, because hallucinated code is just a bug with confidence.

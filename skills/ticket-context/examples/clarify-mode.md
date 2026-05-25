# Clarify Mode Example

Use when you want the agent to inspect the codebase and clarify requirements before implementation.

## Prompt

```txt
Use ticket-context in Clarify Mode.

Here is the ticket:
[paste ticket, issue, PRD, bug report, or feature request]

Repository/context:
[paste repo path, branch, file list, or relevant context]

Inspect the related codebase first.
Ask questions before implementation.
Do not write code yet.
```

## Expected Output

```md
# Summary
- Request: [short summary]
- Current behavior: [from code]
- Expected behavior: [from ticket]

# Architecture
- Pattern: [observed architecture]
- Relevant files: [files/modules]
- Data flow: [short flow]

# Gaps / Risks
- [ambiguity, compatibility, migration, edge cases]

# Questions
1. [specific blocking question based on code]
```

If no blocking ambiguity exists:

```txt
No blocking ambiguity found. Safe to continue implementation.
```

## Good Questions

```txt
Current validation happens in the usecase layer. Should the new rule follow that pattern?
```

```txt
Existing batch APIs return partial success. Should this new flow preserve that behavior?
```

```txt
The model has no field for this value. Should old records be backfilled or only new records use it?
```

## Bad Questions

```txt
Can you explain more?
```

```txt
What should I do?
```

```txt
Do you want me to implement it?
```

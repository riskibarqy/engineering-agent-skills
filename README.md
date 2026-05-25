# Agent Skills

Reusable AI agent skills for engineering workflows. Designed to be usable by Claude, Codex, and other AI coding agents.

## Skills

### ticket-context

Helps an AI agent understand a ticket, inspect the repository architecture, ask clarification questions, and prepare a safe implementation plan.

## Install

### Claude / local skill directory

```bash
mkdir -p ~/.agents/skills
cp -r skills/ticket-context ~/.agents/skills/
```

Adjust the destination if your client uses a different skills directory.

### Codex / other agents

Open `skills/ticket-context/PROMPT.md` for a short reusable prompt, or use `skills/ticket-context/SKILL.md` for the full instruction.

## Validate

```bash
./scripts/validate.sh
```

## Usage

```txt
Use ticket-context skill in Clarify Mode.

Here is the ticket:
[paste ticket]

Inspect the related codebase first.
Ask questions before implementation.
Do not write code yet.
```

## Structure

```txt
README.md
LICENSE
.gitignore
scripts/
  validate.sh
skills/
  ticket-context/
    SKILL.md
    PROMPT.md
    examples/
      clarify-mode.md
```

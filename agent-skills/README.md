# Agent Skills

Reusable AI agent skills for engineering workflows.

## Skills

### ticket-context

Helps an AI agent understand a ticket, inspect the repository architecture, ask clarification questions, and prepare a safe implementation plan.

## Install

Copy the skill into your local agent skills directory:

```bash
mkdir -p ~/.agents/skills
cp -r skills/ticket-context ~/.agents/skills/
```

## Usage

```txt
Use ticket-context skill in Clarify Mode.

Here is the ticket:
[paste ticket]

Inspect the related codebase first.
Ask questions before implementation.
Do not implement yet.
```

## Structure

```txt
agent-skills/
  README.md
  skills/
    ticket-context/
      SKILL.md
      examples/
        clarify-mode.md
```

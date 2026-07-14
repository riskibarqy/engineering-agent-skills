# Agent Skills

Reusable AI agent skills for engineering workflows. Designed for Claude, Codex, Cursor, Gemini CLI, and other AI coding agents.

## Skills

### ticket-context

Helps an AI agent understand a ticket, inspect repository architecture, ask clarification questions, and prepare safe implementation plan.

Use Clarify Mode first for vague tickets. Use Build Mode only after questions are answered and implementation is explicitly requested.

## Installation

Different clients support different skill/prompt locations. Use method matching your client.

### Claude Code / Generic Agent Skills Directory

Install every skill:

```bash
mkdir -p ~/.agents/skills
cp -r skills/* ~/.agents/skills/
```

This installs every skill directory currently in the checkout. Re-run the command after adding a skill. Adjust the destination if your client uses another skills directory.

### Codex-Style Manual Usage

Open `skills/ticket-context/PROMPT.md`, copy contents into your agent prompt, then paste ticket below it.

```txt
Use ticket-context in Clarify Mode.

Here is the ticket:
[paste ticket]
```

### Cursor / Editor Prompt Usage

Use `skills/ticket-context/PROMPT.md` as reusable project rule, composer prompt, or chat context.

Recommended flow:

1. Paste prompt.
2. Paste ticket.
3. Ask for Clarify Mode first.
4. Switch to Build Mode only after ambiguity is resolved.

### Gemini CLI / Generic CLI Agents

Pass prompt file content before ticket text.

```bash
cat skills/ticket-context/PROMPT.md ticket.md | gemini
```

If your CLI supports system/developer prompts, use `PROMPT.md` there and provide ticket as user input.

### Manual Copy-Paste Fallback

Copy `skills/ticket-context/PROMPT.md` into any agent chat, then paste ticket below it.

Use this when client has no skill directory support.

## Usage

### Clarify Mode

Use for vague tickets, PRDs, bugs, or feature requests.

```txt
Use ticket-context skill in Clarify Mode.

Here is the ticket:
[paste ticket]

Inspect related codebase first.
Ask questions before implementation.
Do not write code yet.
```

### Build Mode

Use only when requirements are clear and you want implementation.

```txt
Use ticket-context skill in Build Mode.

Here is the ticket:
[paste ticket]

Inspect related codebase first.
Implement minimal safe change.
Add/update relevant tests.
```

## Validate

```bash
./scripts/validate.sh
```

## Structure

```txt
README.md
LICENSE
.gitignore
scripts/
  validate.sh
skills/
  satpam/
    SKILL.md
  ticket-context/
    SKILL.md
    PROMPT.md
    examples/
      clarify-mode.md
      build-mode.md
      realistic-ticket-example.md
```
